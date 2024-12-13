/** 
 * 
 * Purpose          :   Trigger for Attendee__c Object
 * 
 * Created by       :   Sajal Mittal
 * 
 * Created Date     :   06-12-2024
 * 
 * Rivision Logs    :   V_1.0 - Created
 *                      V_2.0 - Updated - Implemented Trigger FrameWork
 * 
**/
trigger AttendeeTrigger on Attendee__c (After Insert, After Update, After Delete) {
    
    new AttendeeTriggerHandler().run();
    
}