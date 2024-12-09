/** 
 * 
 * Purpose          :   Handler Class for contactTrigger
 * 
 * Created by       :   Sajal Mittal
 * 
 * Created Date     :   05-12-2024
 * 
 * Rivision Logs    :   V_1.0 - Created
 *                      V_2.0 - Updated (07/12/2024) - added filter condition to enter in the trigger logic in case of After Update 
 *                                        only if contact's Id or Email is changed. 
 * 
**/
public with sharing class ContactTriggerHandler {
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
    * param        :   List<Contact> newContacts
   **/
   public Static void validateContactEmailDomain(List<Contact> newContacts, Map<Id, Contact> mapOfOldContacts) {
       Set<Id> accIds = new Set<Id>();
       for(Contact con: newContacts){
           if(con.AccountId != null && 
               (mapOfOldContacts == null 
                   || (mapOfOldContacts.get(con.Id).AccountId != con.AccountId || mapOfOldContacts.get(con.Id).Email != con.Email))){  
                       accIds.add(con.AccountId);      
           }
       }
       if(!accIds.isEmpty()) {
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
}