/** 
 * 
 * Purpose          :   Test class for AddPrimaryContact class
 * 
 * Created by       :   Sajal Mittal
 * 
 * Created Date     :   19-12-2024
 * 
 * Rivision Logs    :   V_1.0 - Created
 * 
**/
@isTest
private class AddPrimaryContactTest {
    
    // Test Setup method for creating pre-required fake data
    @TestSetup
    static void makeData(){
        Contact con = new Contact(LastName = 'Test Contact');
        insert con;
        List<Account> accList = new List<Account>();

        for(Integer i = 1; i <= 100; i++){
            Account acc = new Account(Name = 'Test Account '+i, Phone = '0000000000');
            
            if(Math.mod(i,2) == 0) {
                acc.BillingState = 'NY';
            }else {
                acc.BillingState = 'CA';
            }
            accList.add(acc);
        }
        insert accList;        
    }
    
    // Test Method for testing Contacts on Account object
    @isTest
    static void testContactInsertionByState() {
        Contact cont = [SELECT Id, LastName FROM Contact WHERE Name LIKE 'Test Contact' LIMIT 1];
        System.debug('cont: '+ cont);

        Test.StartTest();
        AddPrimaryContact apc = new AddPrimaryContact(cont, 'CA');
        System.enqueueJob(apc);
        Test.StopTest();

        List<Contact> conList = [SELECT Id, Name FROM Contact WHERE Account.BillingState = 'CA'];
        Assert.areEqual(50, conList.size());
        Assert.areEqual('Test Contact', conList[0].Name);
    }
}