/** 
 * 
 * Purpose          :   Handler Class of Trigger on contact object
 * 
 * Created by       :   Sajal Mittal
 * 
 * Created Date     :   05-12-2024
 * 
 * Rivision Logs    :   V_1.0 - Created
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
    public Static void validateContactEmailDomain(List<Contact> newContacts) {
        Set<Id> accIds = new Set<Id>();
        for(Contact con: newContacts){
            if(con.AccountId != null){
                accIds.add(con.AccountId);  
            }
        }
        Map<Id, Account> accountMap = new Map<Id, Account>([SELECT Id, Domain__c FROM Account WHERE Id IN: accIds]);
        for(Contact con: newContacts){
            if(accIds.contains(con.AccountID)){
                if(accountMap.get(con.AccountId).Domain__c != null){
                    if(!(con.Email != null && con.Email.contains(accountMap.get(con.AccountId).Domain__c))){
                        con.addError('Either Email is null or does not contain correct domain value');
                    }
                }
                else{
                    con.addError('Associated Account does not have valid domain specified');
                }
            }
        }
    }
}