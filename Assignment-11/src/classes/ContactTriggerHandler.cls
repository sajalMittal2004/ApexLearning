/** 
 * 
 * Purpose          :   Handler Class for contactTrigger
 * 
 * Created by       :   Sajal Mittal
 * 
 * Created Date     :   05-12-2024
 * 
 * Rivision Logs    :   V_1.0 - Created
 *                      V_2.0 - Updated - added filter condition to enter in the trigger logic in case of After Update 
 *                                        only if contact's Id or Email is changed.
 *                      V_3.0 - Updated - Implemented Trigger Framework 
 * 
**/
public without sharing class ContactTriggerHandler extends TriggerHandler {

    // Method to perform Before Insert Events
    public override void beforeInsert() {
        Set<Id> accIds = ContactTriggerHandler.createAccountSet((List<Contact>)trigger.new,
                                                                    (Map<Id, Contact>)trigger.oldMap);
        if(!accIds.isEmpty()) {
            ContactTriggerHandler.validateContactEmailDomain(accIds, (List<Contact>)trigger.new);
        }
        ContactTriggerHandler.populateObjectNameAndPicklistFieldName((List<Contact>)trigger.new,
                                                                        (Map<Id, Contact>)trigger.oldMap);
    }

    // Method to perform Before Update Events
    public override void beforeUpdate() {           
        ContactTriggerHandler.populateObjectNameAndPicklistFieldName((List<Contact>)trigger.new,
                                                                        (Map<Id, Contact>)trigger.oldMap);
        Set<Id> accIds = ContactTriggerHandler.createAccountSet((List<Contact>)trigger.new,
                                                                    (Map<Id, Contact>)trigger.oldMap);
        if(!accIds.isEmpty()) {
            ContactTriggerHandler.validateContactEmailDomain(accIds, (List<Contact>)trigger.new);
        }
    }

    // Method to perform After Insert Events
    public override void afterInsert() {
    }
    // Method to perform After Update Events
    public override void afterUpdate() {
    }
    // Method to perform After Delete Events
    public override void afterDelete() {
    }



    /**
     * Method Name  :   createAccountSet
     * 
     * Created by   :   Sajal Mittal
     * 
     * Purpose      :   Method to create set of ContactIds. 
     * 
     * return       :   Set<Id>
     * 
     * param        :   List<Contact> newContacts, Map<Id, Contact> mapOfOldContacts
    **/
    public static Set<Id> createAccountSet(List<Contact> newContacts, Map<Id, Contact> mapOfOldContacts) {
        Set<Id> accountIds = new Set<Id>();

        for(Contact con: newContacts){
            if(con.AccountId != null && 
                (mapOfOldContacts == null 
                || (mapOfOldContacts.get(con.Id).AccountId != con.AccountId 
                || mapOfOldContacts.get(con.Id).Email != con.Email))){  
                    accountIds.add(con.AccountId);      
            }
        }
        return accountIds;
    }

    /**
     * Method Name  :   validateContactEmailDomain
     * 
     * Created by   :   Sajal Mittal
     * 
     * Purpose      :   Method to validate domain name in Email field of contact object based on custom field 'Domain' value 
     *                  whenever a contact record is getting insert or update. 
     * 
     * return       :   void
     * 
     * param        :   Set<Id> accIds, List<Contact> newContacts
    **/
    public static void validateContactEmailDomain(Set<Id> accIds, List<Contact> newContacts) {
        Map<Id, Account> accountMap = new Map<Id, Account>([SELECT Id, Domain__c FROM Account WHERE Id IN: accIds]);

        for(Contact con: newContacts){

            if(accIds.contains(con.AccountID)){

                if(!accountMap.isEmpty() && accountMap.get(con.AccountId).Domain__c != null){

                    if(!(con.Email != null && con.Email.endsWith(accountMap.get(con.AccountId).Domain__c.toLowerCase()))){
                        con.addError('Either Email is null or Domain is not Correct. It Should be '+accountMap.get(con.AccountId).Domain__c);
                    }
                }
            }
        }      
    }

    /**
     * Method Name  :   populateObjectNameAndPicklistFieldName
     * 
     * Created by   :   Sajal Mittal
     * 
     * Purpose      :   Method to populate object name in Object_Name__c field and available piklist fields in Picklist_Fields__c 
     *                  on that object based on the input value in Record_Id__c field on contact object 
     * 
     * return       :   void
     * 
     * param        :   List<Contact> newContacts, Map<Id, Contact> oldContactsMap
    **/
    public static void populateObjectNameAndPicklistFieldName(List<Contact> newContacts, Map<Id, Contact> oldContactsMap) {
        Set<Id> setOfRecordIds = new Set<Id>();
        
        for(Contact con: newContacts) {

            if(!String.isBlank(con.Record_Id__c) && 
                                (oldContactsMap == null || oldContactsMap.get(con.Id).Record_Id__c != con.Record_Id__c)) {
                    try {
                        if(ContactTriggerHandler.isValidatedId(Id.valueOf(con.Record_Id__c))){
                            setOfRecordIds.add(Id.valueOf(con.Record_Id__c));
                        }else {
                            con.addError('No record found for ID: '+con.Record_Id__c);
                        }
                    }catch(Exception e) {
                        con.addError('Invalid record Id: '+con.Record_Id__c);
                    }
                }
            }

        if(!setOfRecordIds.isEmpty()) {
            Map<Id, String> recordIdAndObjectName = ContactTriggerHandler.populateObjectName(setOfRecordIds, newContacts);
            ContactTriggerHandler.populatePicklistFieldsName(setOfRecordIds, newContacts);
        }
    }

    // Method to populate Object Name in Object_Name__c field on contact object based on Record Id provided in Record_Id__c field
    private static Map<Id, String> populateObjectName(Set<Id> recordIds, List<Contact> newContacts) {
        Map<Id, String> getObjectNameMap = new Map<Id, String>();

        for(Id recordId: recordIds) {
            getObjectNameMap.put(recordId, recordId.getSObjectType().getDescribe().getName());
        }

        for(Contact con: newContacts) {

            if(getObjectNameMap.containsKey(Id.valueOf(con.Record_Id__c))) {
                con.Object_Name__c = getObjectNameMap.get(con.Record_Id__c);
            }
        }    
        return getObjectNameMap;
    }

    // Method to populate picklist fields Name in Picklist_Fields__c field on contact object based on Record Id provided in Record_Id__c field
    private static void populatePicklistFieldsName(Set<Id> recordIds, List<Contact> newContacts) {
        Map<Id, String> picklistFieldData = new Map<Id, String>();

        for (Id recordId : recordIds) {
            Schema.SObjectType objType = recordId.getSObjectType();
            Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
            Map<String, Schema.SObjectField> fieldsMap = objDescribe.fields.getMap();
            List<String> picklistFields = new List<String>();

            for (String fieldName : fieldsMap.keySet()) {
                Schema.DescribeFieldResult fieldDescribe = fieldsMap.get(fieldName).getDescribe();

                if (fieldDescribe.getType() == Schema.DisplayType.PICKLIST) {
                    picklistFields.add(fieldName);
                }
            }

            if (!picklistFields.isEmpty()) {
                picklistFieldData.put(recordId, String.join(picklistFields, '\n'));
            }else {
                picklistFieldData.put(recordId, 'No picklist field available');
            }        
        }

        for (Contact con : newContacts) {

            if (picklistFieldData.containsKey(con.Record_Id__c)) {
                con.Picklist_Fields__c = picklistFieldData.get(con.Record_Id__c);
            }
        }
    }

    // Method to validate record id provided in Record_Id__c field on contact object
    private static boolean isValidatedId(Id inputId) {
        if(inputId != null) {
            String sObjectName = inputId.getSObjectType().getDescribe().getName();
            String query = 'SELECT ID FROM '+sObjectName+' WHERE ID =: inputId';
            List<sObject> sObjectList = Database.query(query);

            if(!sObjectList.isEmpty()) {
                return true;
            }
        }
        return false;
    }
}