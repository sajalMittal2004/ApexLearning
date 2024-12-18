/** 
 * Purpose          :   Test Class for AccountProcessor
 * 
 * Created by       :   Sajal Mittal
 * 
 * Created Date     :   17-12-2024
 * 
 * Rivision Logs    :   V_1.0 - Created
 * 
**/
@isTest
private class AccountProcessorTest {
    // Test Setup method for creating pre-required fake data
    @TestSetup
    static void makeData(){
        Account acc1 = new Account(Name = 'Test Account 1',
                                    Phone = '0000000000');
        Account acc2 = new Account(Name = 'Test Account 2',
                                    Phone = '0000000000');
        insert acc1;
        insert acc2;
        Contact con1 = new Contact(LastName = 'Test Contact 1',
                                   AccountId = acc1.Id);
        Contact con2 = new Contact(LastName = 'Test Contact 2',
                                   AccountId = acc1.Id);
        insert con1;
        insert con2;
    }

    // Test Method for testing Number_Of_Contacts__c on Account object
    @isTest
    static void TestNoOfContactOnAccount() {
        List<Account> acclist = [SELECT Id, Name, Number_Of_Contacts__c 
                                FROM Account
                                WHERE Name Like 'Test Account%' 
                                LIMIT 2];
        
        Test.startTest();
        AccountProcessor.countContacts(new List<Id>{acclist[0].Id, acclist[1].Id});
        Test.stopTest();
  
        List<Account> updatedAccounts = [SELECT Id, Name, Number_Of_Contacts__c 
                                FROM Account
                                WHERE Name Like 'Test Account%' 
                                LIMIT 2];

        Assert.areEqual(2, updatedAccounts[0].Number_Of_Contacts__c, 'Contact number is not same');
        Assert.areEqual(0, updatedAccounts[1].Number_Of_Contacts__c);
    }
}