/** 
 * Purpose          :   Test Class for AttendeeTriggerHandler
 * 
 * Created by       :   Sajal Mittal
 * 
 * Created Date     :   13-12-2024
 * 
 * Rivision Logs    :   V_1.0 - Created
 * 
**/
@isTest
private class AttendeeTriggerHandlerTest {

    // Test Setup method for creating pre-required fake data
    @TestSetup
    static void makeData(){
        List<Training_Session__c> TrainingSessions = new List<Training_Session__c>();
        Date sessionDate = Date.Today()+5;

        for(Integer i = 1; i <= 3; i++) {
            Training_Session__c ts = new Training_Session__c(Name = 'Test Session '+i,
                                                        Session_Date__c = sessionDate,
                                                        Location__c = 'Remote');
            TrainingSessions.add(ts);
        }
        insert TrainingSessions;
        
        List<Contact> contacts = new List<Contact>();
        for(Integer i = 1; i <= 3; i++) {
            Contact con = new Contact(LastName = 'Test Contact '+i);
            contacts.add(con);
        }
        insert contacts;
    }

    // Test Method for testing No_Of_Training_Session__c on contact object After insertion of Attendee__c record 
    @isTest
    static void myUnitTestForInsertion() {

        List<Contact> contacts = [SELECT Id, Name, No_Of_Training_Session__c FROM Contact WHERE Name LIKE 'Test Contact%'];
        List<Training_Session__c> sessions = [SELECT Id, Name FROM Training_Session__c WHERE Name LIKE 'Test Session%'];

        List<Attendee__c> attendees = new List<Attendee__c>();
        attendees.add(new Attendee__c(Phone__c = '0000000000', Contact__c = contacts[0].Id, Session__c=sessions[0].Id));
        attendees.add(new Attendee__c(Phone__c = '0000000000', Contact__c = contacts[0].Id, Session__c=sessions[0].Id));
        attendees.add(new Attendee__c(Phone__c = '0000000000', Contact__c = contacts[0].Id, Session__c=sessions[1].Id));

        Test.startTest();
        insert attendees;
        Test.stopTest();
        
        List<Contact> updatedContacts = [SELECT Id, Name, No_Of_Training_Session__c FROM Contact WHERE Name LIKE 'Test Contact%'];
        Assert.areEqual(2, updatedContacts[0].No_Of_Training_Session__c);   
    }

    // Test Method for testing No_Of_Training_Session__c on contact object After updation on Attendee__c record 
    @isTest
    private static void myUnitTestForUpdation() {

        List<Contact> contacts = [SELECT Id, Name, No_Of_Training_Session__c FROM Contact WHERE Name LIKE 'Test Contact%'];    
        List<Training_Session__c> sessions = [SELECT Id, Name FROM Training_Session__c WHERE Name LIKE 'Test Session%'];
        
        List<Attendee__c> attendees = new List<Attendee__c>();
        attendees.add(new Attendee__c(Phone__c = '0000000000', Contact__c = contacts[0].Id, Session__c=sessions[0].Id));
        attendees.add(new Attendee__c(Phone__c = '0000000000', Contact__c = contacts[0].Id, Session__c=sessions[0].Id));
        attendees.add(new Attendee__c(Phone__c = '0000000000', Contact__c = contacts[0].Id, Session__c=sessions[1].Id));
		insert attendees;

        attendees[0].Contact__c = contacts[1].Id;
        attendees[1].Contact__c = contacts[2].Id;
        attendees[2].Contact__c = contacts[1].Id;

        Test.startTest();
        update attendees;
        Test.stopTest();
        
        List<Contact> updatedContacts = [SELECT Id, Name, No_Of_Training_Session__c FROM Contact WHERE Name LIKE 'Test Contact%'];
        Assert.areEqual(0,updatedContacts[0].No_Of_Training_Session__c);
        Assert.areEqual(2,updatedContacts[1].No_Of_Training_Session__c);
        Assert.areEqual(1,updatedContacts[2].No_Of_Training_Session__c);
    }
    
    // Test Method for testing No_Of_Training_Session__c on contact object After deletion of Attendee__c record 
    @istest
    private static void myUnitTestForDeletion() {

        List<Contact> contacts = [SELECT Id, Name, No_Of_Training_Session__c FROM Contact WHERE Name LIKE 'Test Contact%'];        
        List<Training_Session__c> sessions = [SELECT Id, Name FROM Training_Session__c WHERE Name LIKE 'Test Session%'];
        
        List<Attendee__c> attendees = new List<Attendee__c>();
        attendees.add(new Attendee__c(Phone__c = '0000000000', Contact__c = contacts[0].Id, Session__c=sessions[0].Id));
        attendees.add(new Attendee__c(Phone__c = '0000000000', Contact__c = contacts[0].Id, Session__c=sessions[0].Id));
        attendees.add(new Attendee__c(Phone__c = '0000000000', Contact__c = contacts[0].Id, Session__c=sessions[1].Id));
		insert attendees;
        
        Test.startTest();
        delete attendees[2]; 
        Test.stopTest();
        
        List<Contact> updatedContacts = [SELECT Id, Name, No_Of_Training_Session__c FROM Contact WHERE Name LIKE 'Test Contact%'];  
        Assert.areEqual(1,updatedContacts[0].No_Of_Training_Session__c);   
    }
}