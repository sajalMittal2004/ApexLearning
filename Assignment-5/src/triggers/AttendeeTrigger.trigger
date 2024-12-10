/** 
 * 
 * Purpose          :   Trigger for Attendee Object
 * 
 * Created by       :   Sajal Mittal
 * 
 * Created Date     :   06-12-2024
 * 
 * Rivision Logs    :   V_1.0 - Created
 * 
**/
trigger AttendeeTrigger on Attendee__c (After Insert, After Update, After Delete) {

    if(trigger.isAfter) {

        if(trigger.isInsert || trigger.isUpdate || trigger.isDelete) {

            AttendeeTriggerHandler.updateSessionNumberOnContactForAfterEvents(trigger.new, trigger.oldMap);
        }
    }
}