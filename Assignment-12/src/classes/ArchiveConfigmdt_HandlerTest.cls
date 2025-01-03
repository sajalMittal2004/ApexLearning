/** 
 * Purpose          :   Test class of ArchiveConfigmdt_Handler class
 * 
 * Created by       :   Sajal Mittal
 * 
 * Created Date     :   02-01-2025
 * 
 * Rivision Logs    :   V_1.0 - Created
 * 
**/
@isTest(seeAllData = true)
private class ArchiveConfigmdt_HandlerTest {    

    // Test method to test scheduler class ArchiveConfigmdt_Handler
    @isTest
    static void testArchiveConfigmdtHandler() {  
        
        Test.startTest();
            String cronExp = '0 0 0 * * ? 2042';
            ArchiveConfigmdt_Handler handler = new ArchiveConfigmdt_Handler();
            System.schedule('Test ArchiveConfig MDT Job', cronExp, handler);
        Test.stopTest(); 
        
        Assert.areEqual(3, ArchiveConfigmdt_Handler.noOfTimeBatchExecuted);
    }   

    // test method to test batch class
    @isTest
    static void testArchiveData() {  
        Account acc = new Account(Name='Test acc1', Phone='00000000');
        insert acc;

        List<String> listOfFields = new List<String>{'Id','Name','CreatedDate'};
        String fields = String.join(listOfFields,', ');
        String query = 'SELECT '+fields+' FROM Account WHERE Name LIKE \'Test acc1\'';
        
        Test.startTest();
            ArchiveData ad = new ArchiveData(query, listOfFields);
            Database.executeBatch(ad);
        Test.stopTest(); 
        
        List<Account> accList = [SELECT Id FROM Account WHERE Name LIKE 'Test acc1'];
        Assert.areEqual(0, accList.size());
        Assert.areEqual(1, ArchiveData.emailInvocations);
    }   
}