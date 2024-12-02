/** 
 * 
 * Purpose          :   Class to create separate methods to perform DML operations such as Insert, update, and Delete, and to demonstrate the use of Enum, Set, and Safe Navigation Operator in Apex(Assignment-2).
 * 
 * Created by       :   Sajal Mittal
 * 
 * Created Date     :   28-11-24
 * 
 * Rivision Logs    :   V_1.0 - Created
 * 
**/
public with sharing class TrainingSessionManager {
    public enum SessionType{ WEBINAR, WORKSHOP, SEMINAR}
    /**
     * Method Name  :   createTrainingSession
     * 
     * Created by   :   Sajal Mittal
     * 
     * Purpose      :   Method to perform Insert DML operation using Enum for categorization of training session
     * 
     * param        :   String nameOfSession, SessionType sessionType, String dateOfSession, String locationOfSession
     * 
     * return       :   void
    **/
    public static void createTrainingSession(String nameOfSession, SessionType sessionType, String dateOfSession, String locationOfSession) {
        Date formattedDate = Date.parse(dateOfSession);
        Training_Session__c session = new Training_Session__c();
        session.Name = nameOfSession;
        session.Session_Date__c = formattedDate;
        session.Session_Type__c = sessionType.name();
        if(sessionType == TrainingSessionManager.SessionType.WEBINAR){
            session.Location__c = 'Remote';
        }else{
            session.Location__c = locationOfSession;
        }
        try{
            insert session;
        }catch(DMLException e){
            System.debug('Error found: '+e.getMessage());
        }
        
    }
    /**
     * Method Name  :   readTrainingSession
     * 
     * Created by   :   Sajal Mittal
     * 
     * Purpose      :   Method to fetch Training_Session__c records
     * 
     * param        :   String nameOfSession
     * 
     * return       :   void
    **/
    public static void readTrainingSession(String nameOfSession) {
        List<Training_Session__c> listOfSession = new List<Training_Session__c>([SELECT Id, Name, Session_Date__c, Location__c 
                                                                                            FROM Training_Session__c 
                                                                                            WHERE Name =: nameOfSession]);
        System.debug(listOfSession);
    }
    /**
     * Method Name  :   updateTrainingSession
     * 
     * Created by   :   Sajal Mittal
     * 
     * Purpose      :   Method to perform update DML operation on record of Training_Session__c
     * 
     * param        :   Id id, String nameToUpdate
     * 
     * return       :   void
    **/
    public static void updateTrainingSession(Id id, String nameToUpdate) {
        List<Training_Session__c> listOfSessionForUpdation = new List<Training_Session__c>([SELECT Id, Name, Session_Date__c, Location__c 
                                                                                            FROM Training_Session__c 
                                                                                            WHERE Id =: id]);
        if(!listOfSessionForUpdation.isEmpty()){
            for(training_Session__c ts: listOfSessionForUpdation){
                ts.Name = nameToUpdate;                                                                
            }
            if(!listOfSessionForUpdation.isEmpty()){
                try{
                    update listOfSessionForUpdation;
                }catch(DMLException e){
                    System.debug('Error found: '+e.getMessage());
                }            
            }
        }
    }
    /**
     * Method Name  :   deleteTrainingSession
     * 
     * Created by   :   Sajal Mittal
     * 
     * Purpose      :   Method to perform Delete DML operation on record of Training_Session__c
     * 
     * param        :   Id id
     * 
     * return       :   void
    **/
    public static void deleteTrainingSession(Id id) {
        List<Training_Session__c> listOfSessionForDeletion = new List<Training_Session__c>([SELECT Id, Name, Session_Date__c, Location__c 
                                                                                            FROM Training_Session__c 
                                                                                            WHERE Id =: id]);
        if(!listOfSessionForDeletion.isEmpty()){
            try{
                delete listOfSessionForDeletion;
            }catch(DMLException e){
                System.debug('Error found: '+e.getMessage());
            }
        }
    }
     /**
     * Method Name  :   addAttendeeRecords
     * 
     * Created by   :   Sajal Mittal
     * 
     * Purpose      :   Method to add records of Attendee__c on Training_Session__c ensuring each attendee is only added once
     * 
     * param        :   Id sessionId, List<Attendee__c> listofAttendeeToInsert
     * 
     * return       :   void
    **/
    public static void addAttendeeRecords(Id sessionId, List<Attendee__c> listofAttendeeToInsert){
        List<Attendee__c> listOfExistingAttendees = [SELECT Id, Name, Session__c, Phone__c FROM Attendee__c WHERE Session__c =: sessionId];
        Set<String> setOfExistingPhone = new Set<String>();
        List<Attendee__c> listOfAttendeeToBeInserted = new List<Attendee__c>();

        for(Attendee__c ExistingAttendee: listOfExistingAttendees){
            setOfExistingPhone.add(ExistingAttendee.Phone__c);
        }
        for(Attendee__c attendeeToInsert: listofAttendeeToInsert){
            if(!setOfExistingPhone.contains(attendeeToInsert.Phone__c)){
                attendeeToInsert.Session__c = sessionId;
                listOfAttendeeToBeInserted.add(attendeeToInsert);
                setOfExistingPhone.add(attendeeToInsert.Phone__c);
            }
        }
        if(!listOfAttendeeToBeInserted.isEmpty()){
            try{
                insert listOfAttendeeToBeInserted;
            }catch(DMLException e){
                System.debug('Error found: '+e.getMessage());
            }  
        }
    }
    /**
     * Method Name  :   implementationOfSafeNavigation
     * 
     * Created by   :   Sajal Mittal
     * 
     * Purpose      :   Method to implement Safe Navigation Operator that return attendee name if it is not null 
     * 
     * param        :   Id sessionId
     * 
     * return       :   List<String>
    **/
    public static List<String> implementationOfSafeNavigation(Id sessionId){
        List<Training_Session__c> listOfTrainingSession = [SELECT Id, Name, (SELECT Id, Name From Attendees__r)
                                                            FROM Training_Session__c
                                                            WHERE Id =: sessionId LIMIT 1];
        List<String> attendeeName = new List<String>();
        for(Training_Session__c trainingSession: listOfTrainingSession){
            if(trainingSession.Attendees__r != null){
                for(Attendee__c attendee: trainingSession.Attendees__r){
                    String Name = attendee?.Name;
                    attendeeName.add(Name);
                }
            }
        }
        return attendeeName;
    }
}