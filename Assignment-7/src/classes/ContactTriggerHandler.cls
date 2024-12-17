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
public with sharing class ContactTriggerHandler extends TriggerHandler {
    
    // Method to perform Before Insert Events
    public override void beforeInsert() {
        Set<Id> accIds = ContactTriggerHandler.createAccountSet((List<Contact>)trigger.new,
                                                                 (Map<Id, Contact>)trigger.oldMap);
        if(!accIds.isEmpty()) {
            ContactTriggerHandler.validateContactEmailDomain(accIds, (List<Contact>)trigger.new);
        }
    }

    // Method to perform Before Update Events
    public override void beforeUpdate() {
        Set<Id> accIds = ContactTriggerHandler.createAccountSet((List<Contact>)trigger.new,
                                                                 (Map<Id, Contact>)trigger.oldMap);
        if(!accIds.isEmpty()) {
            ContactTriggerHandler.validateContactEmailDomain(accIds, (List<Contact>)trigger.new);
        }
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
    public Static Set<Id> createAccountSet(List<Contact> newContacts, Map<Id, Contact> mapOfOldContacts) {
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
    public Static void validateContactEmailDomain(Set<Id> accIds, List<Contact> newContacts) {
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
}