/** 
 * 
 * Purpose          :   Class to update Lead Source on lead object to DreamSource using Batch Apex
 * 
 * Created by       :   Sajal Mittal
 * 
 * Created Date     :   18-12-2024
 * 
 * Rivision Logs    :   V_1.0 - Created
 * 
**/
global class LeadProcessor implements Database.Batchable<sObject>, Database.Stateful, Schedulable {
    
    Integer recordProcessed = 0;
    global Database.QueryLocator start(Database.BatchableContext BC) {
        String query = 'SELECT Id, LeadSource FROM Lead';
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Lead> leadList) {
        List<Lead> listToUpdateLeadRecords = new List<Lead>();
        
        for(lead lr: leadList) {
            lr.LeadSource = 'Dreamforce';
            listToUpdateLeadRecords.add(lr);
            recordProcessed += 1;
        }
        
        if(!listToUpdateLeadRecords.isEmpty()) {
            update listToUpdateLeadRecords;
        }
    }
    
    global void finish(Database.BatchableContext BC) {
        System.debug('Total record Processed: '+recordProcessed);  
    }

    // execute method for Schedulable Interface
    global void execute(SchedulableContext sc) {
        LeadProcessor lp = new LeadProcessor();
        Database.executeBatch(lp, 100);
    }
}