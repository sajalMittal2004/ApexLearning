/**  
 * Purpose          :   Class to archive records using Batch Apex and 
 *                      send email consisting of csv file of the archived records
 * 
 * Created by       :   Sajal Mittal
 * 
 * Created Date     :   01-01-2025
 * 
 * Rivision Logs    :   V_1.0 - Created
 * 
**/
global without sharing class ArchiveData implements Database.Batchable<sObject>, Database.Stateful{
    String query;
    List<String> listOfFields = new List<String>();
    List<sObject> recordsToarchive = new List<sObject>();
    @testVisible private static Integer emailInvocations = 0;

    // Constructor to assign the value of query and listOfFields that are coming as paramater
    global ArchiveData(String query, List<String> listOfFields) {
        this.query = query;
        this.listOfFields = listOfFields;
    }

    // start methid to query the records.
    global Database.QueryLocator start(Database.batchableContext bc) {
        return Database.getQueryLocator(query);
    }

    // execute method to delete the records.
    global void execute(Database.batchableContext bc, List<sObject> scope) {
        List<sObject> recordsToBeDeleted = new List<sObject>();

        for(sObject sObjRecord: scope) {
            recordsToBeDeleted.add(sObjRecord);
            recordsToarchive.add(sObjRecord); 
        }
        
        if(!recordsToBeDeleted.isEmpty()) {   
            delete recordsToBeDeleted;
        }
    }

    // finish method that creates csv file of archivedRecords and send csv file in email. 
    global void finish(Database.batchableContext bc) {
        
        if (!recordsToarchive.isEmpty()) {
            String objName = ((Id)(recordsToarchive[0].get('Id'))).getsObjectType().getDescribe().getName();
            String csvData = CreateCSV(recordsToarchive);
            String csvFileName = 'Archived_'+objName+ '_Data.csv';
            String emailBody = 'Hello,\n\nWe have archived data for the ';
            emailBody += ObjName+' object. Please find the attached CSV file containing archived records.';
            emailBody += '\n\nBest regards';

            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage(); 
            mail.setToAddresses(new String[] {'Sajal.Mittal@fexle.com'}); 
            mail.setSubject('Archived Data Report: '+objName);
            mail.setPlainTextBody(emailBody); 

            Messaging.EmailFileAttachment attachment = new Messaging.EmailFileAttachment(); 
            attachment.setFileName(csvFileName); 
            attachment.setBody(Blob.valueOf(csvData)); 

            mail.setFileAttachments(new Messaging.EmailFileAttachment[] {attachment}); 
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});
            
            emailInvocations = Limits.getEmailInvocations();
        } 
    }
    // Method to create CSV file of list of records that coming as paramaneter
    private String createCSV(List<sObject> recordsToarchive) {   
        String csvHeader = (String.join(listOfFields,','))+'\n';
        String csvContent = csvHeader;
        
        for (sObject sObjRecord : recordsToarchive) {
            List<String> row = new List<String>(); 

            for (String fieldName : listOfFields) {
                Object fieldValue = sObjRecord.get(fieldName);
                row.add(fieldValue != null ? String.valueOf(fieldValue) : '');
            }
            csvContent += (String.join(row,','))+'\n';
        }
        return csvContent.toString();   
    }
}