/** 
 * 
 * Purpose          :   Class to demonstrate Custome Label in Apex, Database class DML methods, and Complex SOQL(Assignment-3). 
 * 
 * Created by       :   Sajal Mittal
 * 
 * Created Date     :   28-11-24
 * 
 * Rivision Logs    :   V_1.0 - Created
 * 
**/
public with sharing class TrainingSessionDataHandler {
    /**
     * Method Name  :   implementationOfCustomLabel
     * 
     * Created by   :   Sajal Mittal
     * 
     * Purpose      :   Method to implement the use of Custom Label in Apex
     * 
     * return       :   void
    **/
    public static void implementationOfCustomLabel(){
        List<Training_Session__c> listOfSession = [SELECT Id, Name, Session_Type__c, Description__c FROM Training_Session__c];
        for(Training_Session__c session: listOfSession){
            if(session.Session_Type__c == 'WORKSHOP'){
                session.Description__c = System.Label.Custom_Label_For_Worshop_Training_Session;
            }
            if(session.Session_Type__c == 'WEBINAR'){
                session.Description__c = System.Label.Custom_Label_For_WebinarTraining_Session;
            }
            if(session.Session_Type__c == 'SEMINAR'){
                session.Description__c = System.Label.Custom_Label_For_Seminar_Training_Session;
            }
        }
        if(!listOfSession.isEmpty()){
            update listOfSession;
        }
    }
    /**
     * Method Name  :   complexSOQLImplementation
     * 
     * Created by   :   Sajal Mittal
     * 
     * Purpose      :   Method to implement Complex SOQL to optimize the performance
     * 
     * return       :   void
    **/
    public static void complexSOQLImplementation(){
        List<Training_Session__c> listOfSession = [SELECT Id, Name, No_of_Attandees__c, Session_Date__c, Session_Type__c
                                                   FROM Training_Session__c 
                                                   WHERE No_of_Attandees__c > 4 AND Session_Type__c = 'WORKSHOP' AND Session_Date__c > TOMORROW];
        System.debug(listOfSession);
    }
    /**
     * Method Name  :   bulkUpdateOperation
     * 
     * Created by   :   Sajal Mittal
     * 
     * Purpose      :   Method to implement Database.Update() to handle large data volumes and partial success
     * 
     * return       :   void
    **/
    public static void bulkUpdateOperation(){
        List<Training_Session__c> listOfTrainingSessionToUpdate = [SELECT Id, Name FROM training_Session__c];
        for(Training_Session__c session: listOfTrainingSessionToUpdate){
            session.Name += ' Bulk';
        }
        if(!listOfTrainingSessionToUpdate.isEmpty()){
            Database.SaveResult[] saveResultList = Database.update(listOfTrainingSessionToUpdate, false);
            List<Id> listOfIdsOfSuccessfullyInsertedrecord = new List<Id>();
            for(Database.SaveResult sr: saveResultList){
                if(sr.isSuccess()){
                    listOfIdsOfSuccessfullyInsertedrecord.add(sr.getId());
                }
                else{
                    for(Database.Error err: sr.getErrors()){
                        System.debug('Error cought:'+ err.getmessage());
                    }
                }
            }
        }
    }
    /**
     * Method Name  :   bulkDeleteOperation
     *      * 
     * Created by   :   Sajal Mittal
     * 
     * Purpose      :   Method to implement Database.delete() to handle large data volumes and partial success
     * 
     * return       :   void
    **/
    public static void bulkDeleteOperation(){
        List<Training_Session__c> listOfTrainingSessionToDelete = [SELECT Id, Name, Session_Type__c FROM training_Session__c WHERE Session_Type__c = 'SEMINAR'];
        if(!listOfTrainingSessionToDelete.isEmpty()){
            Database.DeleteResult[] drList = Database.delete(listOfTrainingSessionToDelete, false);
            List<Id> listOfIdsOfSuccessfullyDeletedrecord = new List<Id>();
            for(Database.DeleteResult dr : drList) {
                if (dr.isSuccess()) {
                    listOfIdsOfSuccessfullyDeletedrecord.add(dr.getId());
                }
                else {                
                    for(Database.Error err : dr.getErrors()) {
                        System.debug('Error cought:'+ err.getmessage());
                    }
                }
            }
        }
    }
    /**
     * Method Name  :   bulkInsertOperation
     * 
     * Created by   :   Sajal Mittal
     * 
     * Purpose      :   Method to implement Database.Insert() to handle large data volumes and partial success
     * 
     * return       :   void
    **/
    public static void bulkInsertOperation(List<Training_Session__c> listOfSessionToInsert){
        if(!listOfSessionToInsert.isEmpty()){
            Database.SaveResult[] saveResultList = Database.insert(listOfSessionToInsert, false);
            List<Id> listOfIdsOfSuccessfullyInsertedrecord = new List<Id>();
            for(Database.SaveResult sr : saveResultList) {
                if (sr.isSuccess()) {
                    listOfIdsOfSuccessfullyInsertedrecord.add(sr.getId());
                }
                else {                
                    for(Database.Error err : sr.getErrors()) {
                        System.debug('Error cought:'+ err.getmessage());
                    }
                }
            }
        }
    }
}