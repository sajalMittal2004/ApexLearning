/** 
 * Purpose          :   Class to process Archive_Config_mdt records and
 *                      archive the records of specified object based on specified filter and condition 
 *                      asynchronously using batch apex
 * 
 * Created by       :   Sajal Mittal
 * 
 * Created Date     :   31-12-2024
 * 
 * Rivision Logs    :   V_1.0 - Created
 * 
**/
global without sharing class ArchiveConfigmdt_Handler implements Schedulable {
    @TestVisible private static Integer noOfTimeBatchExecuted = 0;

    // Method to process Archive_Config_mdt records
    public void recordProcessor() {
        List<Archive_Config__mdt> configList = [SELECT Id, Object_API_Name__c, Duration__c, Filter__c FROM Archive_Config__mdt];

        if(!configList.isEmpty()) {

            for(Archive_Config__mdt arcRecord: configList) {
                String query = '';

                String obj = (String)arcRecord.get('Object_API_Name__c');
                Integer duration = Integer.valueOf(arcRecord.get('Duration__c'));
                String filter = (String)arcRecord.get('Filter__c');

                List<String> listOfFields = getFields(obj);
                String fields = String.join(listOfFields,', ');
                query += 'SELECT '+fields+' FROM '+obj+' WHERE CreatedDate < LAST_N_Days:'+duration+' AND '+filter;
                ArchiveData arcData = new ArchiveData(query, listOfFields);
                Database.executeBatch(arcData);

                noOfTimeBatchExecuted++;
            }
        } 
    }

    // Method to fetch all the fields of object that is coming as parameter and return a list of fields of that object.
    private static List<String> getFields(String sObj) {
        Map<String, Schema.sObjectField> fieldmap = new Map<String, Schema.sObjectField>(); 
        fieldmap = ((SObject)Type.forName(sObj).newInstance()).getSObjectType().getDescribe().fields.getMap();
        List<String> listOfFields = new List<String>();
        
        for(Schema.sObjectField field: fieldmap.values()) {
            listOfFields.add(field.getDescribe().getName());
        }
        return listOfFields;
    }

    // execute method of Schedulable class.
    global void execute(SchedulableContext sc) {
        ArchiveConfigmdt_Handler arcHandlerRef = new ArchiveConfigmdt_Handler();
        arcHandlerRef.recordProcessor();
    }
}