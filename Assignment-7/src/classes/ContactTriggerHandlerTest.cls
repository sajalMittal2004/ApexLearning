/** 
 * Purpose          :   Test Class for contactTriggerHandler
 * 
 * Created by       :   Sajal Mittal
 * 
 * Created Date     :   13-12-2024
 * 
 * Rivision Logs    :   V_1.0 - Created
 * 
**/
@isTest(seeAllData = FALSE)
private class ContactTriggerHandlerTest {

    // Test Setup method for creating pre-required fake data
    @TestSetup
    static void makeData(){
        List<Account> accList = new list<Account>();
        accList.add(new Account(Name = 'Test Account 1', Phone = '0000000000', Domain__c='test1.com'));
        accList.add(new Account(Name = 'Test Account 2', Phone = '0000000000', Domain__c='test2.com'));
        accList.add(new Account(Name = 'Test Account 3', Phone = '0000000000'));
        insert accList;
        
        List<Contact> contactsToInsert = createContacts();
        Database.insert(contactsToInsert, false);
    }
    
    /**
     * Test Method for testing Insertion of Contact record based on Email 
     * if it is associated with an Account and have correct Domain as on Account.
     **/
    @isTest
    static void myUnitTestForInsertion() {
        List<Contact> contactsToInsert = createContacts();
        
        Test.startTest();
        insert contactsToInsert[1];
        insert contactsToInsert[43];
        insert contactsToInsert[53];
        insert contactsToInsert[58];
        insert contactsToInsert[71];
        try {
            insert contactsToInsert[17];
        }catch(Exception e) {
            Assert.isTrue(!String.isEmpty(e.getMessage()));
        }
        try {
            insert contactsToInsert[11];
        }catch(Exception e) {
            Assert.isTrue(!String.isEmpty(e.getMessage()));
        }
        Test.stopTest();

        Assert.isTrue(contactsToInsert[1].Email.endsWith('Test1.com'));
        Assert.isTrue(contactsToInsert[71].AccountId == NULL);
    }
    
    /**
     * Test Method for testing Updation of Contact record based on Email 
     * if it is associated with an Account and have correct Domain as on Account.
     **/
    @isTest
    static void myUnitTestForUpdation() {
 		List<Contact> conList = [SELECT Id, LastName, Email, Phone, AccountId, Account.Name FROM Contact WHERE Name LIKE 'Test%'];
        List<Contact> ContactsToUpdate = updateContacts(conList);
        System.debug(ContactsToUpdate[5]);
        
        Test.StartTest();
        try{
            update ContactsToUpdate[5];
        }catch(Exception e) {
            System.debug(e.getMessage());
            Assert.isTrue(!String.isEmpty(e.getMessage()));
        }
        update ContactsToUpdate[12];
        update ContactsToUpdate[33];
        Test.StopTest(); 

        System.assertEquals(TRUE, ContactsToUpdate[12].AccountId == NULL);
        System.assertEquals('Test@Test1.com',ContactsToUpdate[33].Email);
    }

    // Method to create fake Contact records
    private static List<Contact> createContacts() {
        List<Account> accounts = [SELECT Id, Name, Domain__c FROM Account WHERE Name LIKE '%Test%'];
        List<Contact> contacts = new List<Contact>();
        for(Integer i = 1; i <= 100; i++) {
            Contact con = new Contact();
            con.Lastname = 'Test Contact '+i;

            if(i <= 20) {
                Account acc = accounts[0];
                con.AccountId = acc.Id;

                if(i <= 10){
                    con.Email = 'Test@Test1.com';
                }else if(i <= 15 && i > 10) {
                    con.Email = 'Test@Test3.com';
                }
            }
            
            if(i > 20 && i <= 40) {
                Account acc = accounts[1];
                con.AccountId = acc.Id;

                if(i <= 30){
                    con.Email = 'Test@Test2.com';
                }else if(i <= 35 && i > 30) {
                    con.Email = 'Test@Test4.com';
                }
            }
            
            if(i > 40 && i <= 60) {
                Account acc = accounts[2];
                con.AccountId = acc.Id;

                if(i <= 50){
                    con.Email = 'Test@Test.com';
                }else if(i <= 55 && i > 50) {
                    con.Email = 'Test@Test3.com';
                }
            }
            
            if(i > 60 && i <= 80) {
                con.Email = 'Test@Test.com';
            }
            contacts.add(con);
        }        
        return contacts;
    }

    // Method to alter fake Contact records
    private static List<Contact> updateContacts(List<Contact> contacts) {
        List<Account> accounts = [SELECT Id, Domain__c FROM Account WHERE Name LIKE '%Test%'];
        List<Contact> updatedContacts = new List<Contact>();
        Integer i = 0;
        for(Contact con: contacts) {
            
            con.LastName += ' Updated';
            if(i < 5) {
                con.Phone = '1111111111';
            }
            if(i >= 5 && i < 10) {
                con.Email = null;
            }
            if(i >= 10 && i < 15) {
                con.AccountId = null;
            }
            if(i >= 15 && i < 20) {
                con.Email = 'test@gmail.com';
            }
            if(i >= 20 && i < 25) {
                con.AccountId = accounts[1].Id;
            }
            if(i >= 25 && i < 30) {
                con.Email = null;
                con.AccountId = null;
            }
            if(i >= 30 && i < 40) {
                con.Email = 'Test@Test1.com';
                con.AccountId = accounts[0].Id;
            }
            updatedContacts.add(con);
            i++;
        }
        return updatedContacts;
    }
}