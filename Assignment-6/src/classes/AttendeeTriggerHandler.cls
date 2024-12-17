/** 
 * Purpose          :   Handler Class for AttendeeTrigger
 * 
 * Created by       :   Sajal Mittal
 * 
 * Created Date     :   06-12-2024
 * 
 * Rivision Logs    :   V_1.0 - Created
 *                      V_2.0 - Updated - added a null check so that a null contactId can not be added in the list newContacts.
 *                                                      By this, we'll not be getting excpetion while associating a attendee to a contact (update) if it is not already associated.
 *                      V_3.0 - Updated - Implemented Trigger Framework 
 * 
**/
public without sharing class AttendeeTriggerHandler extends TriggerHandler {
    
    // Method to perform After Insert Events
    public override void afterInsert() {
        Set<Id> contactIds = AttendeeTriggerHandler.createContactSet((List<Attendee__c>)trigger.new, 
                                                                     (Map<Id, Attendee__c>)trigger.oldMap);
        if(!contactIds.isEmpty()) {
            AttendeeTriggerHandler.updateSessionNumberOnContact(contactIds);
        }     
    }

    // Method to perform After Update Events
    public override void afterUpdate() {
        Set<Id> contactIds = AttendeeTriggerHandler.createContactSet((List<Attendee__c>)trigger.new,
                                                                     (Map<Id, Attendee__c>)trigger.oldMap);
        if(!contactIds.isEmpty()) {
            AttendeeTriggerHandler.updateSessionNumberOnContact(contactIds);
        }
    }

    // Method to perform After Delete Events
    public override void afterDelete() {
        Set<Id> contactIds = AttendeeTriggerHandler.createContactSet((List<Attendee__c>)trigger.new,
                                                                     (Map<Id, Attendee__c>)trigger.oldMap);
        if(!contactIds.isEmpty()) {
            AttendeeTriggerHandler.updateSessionNumberOnContact(contactIds);
        }
    }

    /**
     * Method Name  :   createContactSet
     * 
     * Created by   :   Sajal Mittal
     * 
     * Purpose      :   Method to create set of ContactIds. 
     * 
     * return       :   Set<Id>
     * 
     * param        :   List<Contact> newAttendees, Map<Id, Attendee__c> mapOfOldAttendees
    **/
    public static Set<Id> createContactSet(List<Attendee__c> newAttendees, Map<Id, Attendee__c> mapOfOldAttendees) {
        Set<Id> contactIds = new Set<Id>();
        for(Attendee__c att: newAttendees!=null? newAttendees: mapOfOldAttendees.values()) {

            if(att.Contact__c != null) {

                contactIds.add(att.Contact__c);

                if(mapOfOldAttendees != null && (mapOfOldAttendees.get(att.Id).Contact__c != att.Contact__c)) {
                    contactIds.add(mapOfOldAttendees.get(att.Id).Contact__c);
                }
            }
        }
        return contactIds;
    }

    /**
     * Method Name  :   updateSessionNumberOnContactForAfterEvents
     * 
     * Created by   :   Sajal Mittal
     * 
     * Purpose      :   Method to update No_Of_Training_Session__c field on Contact object 
     *                  based on Trainins Sessions that contact enrolled in
     * 
     * return       :   void
     * 
     * param        :   Set<Id> conIds
    **/
    public static void updateSessionNumberOnContact(Set<Id> conIds) {
        List<Contact> newContacts = new List<Contact>();
        // Map to store contact Id as key and count of Tarining Session as value    
        Map<Id, Integer> mapToStoreSessionCount = new Map<Id, Integer>();

        for(AggregateResult agr: [SELECT Contact__c, COUNT_DISTINCT(Session__c) session
                                    FROM Attendee__c 
                                    WHERE Contact__c IN: conIds
                                    GROUP BY Contact__c]) {
            mapToStoreSessionCount.put((Id)agr.get('Contact__c'), (Integer)agr.get('session'));
        }

        for(Id conId: conIds) {
            Contact newCon = new Contact();
            newCon.Id = conId;
            newCon.No_Of_Training_Session__c = 0;

            if(mapToStoreSessionCount.containsKey(conId)){
                newCon.No_Of_Training_Session__c = mapToStoreSessionCount.get(conId);
            } 

            if(conId != null){
                newContacts.add(newCon);
            }
        }
        if(!newContacts.isEmpty()) {
            update newContacts;
        }
    }
}