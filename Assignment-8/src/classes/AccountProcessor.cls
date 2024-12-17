/** 
 * 
 * Purpose          :   Class to update no. of contacts on Account object using future method
 * 
 * Created by       :   Sajal Mittal
 * 
 * Created Date     :   16-12-2024
 * 
 * Rivision Logs    :   V_1.0 - Created
 * 
**/
public with sharing class AccountProcessor {
    // future method to count the number of contacts of Account and 
    // update them in the Number_Of_Contacts__c field on Account object
    @future
    public static void countContacts(List<Id> accIds) {
        Map<Id, Integer> mapOfAccountsWithContactsCount = new Map<Id, Integer>();

        for(Id id: accIds) {

            if(id != NULL) {
                mapOfAccountsWithContactsCount.put(id, 0);
            }
        }
        
        if(!mapOfAccountsWithContactsCount.keySet().isEmpty()) {
            List<Account> accountsToUpdate = new List<Account>();
            for(AggregateResult agr: [SELECT AccountId, COUNT(Id) No_Of_Contacts
                                    FROM Contact 
                                    WHERE AccountId IN: mapOfAccountsWithContactsCount.keySet()
                                    GROUP BY AccountId]) {
                                        mapOfAccountsWithContactsCount.put((Id)agr.get('AccountId'), (Integer)agr.get('No_Of_Contacts'));
            }
            
            for(Id accId: mapOfAccountsWithContactsCount.keySet()) {
                Account acct = new Account();
                acct.Id = accId;
                acct.Number_Of_Contacts__c = mapOfAccountsWithContactsCount.get(accId);
                acct.Phone = '1212121212';

                accountsToUpdate.add(acct);
            }
            
            if(!accountsToUpdate.isEmpty()) {
                update accountsToUpdate;
            }
        }
    }
}