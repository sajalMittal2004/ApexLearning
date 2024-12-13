/** 
 * 
 * Purpose          :   Trigger for Contact Object
 * 
 * Created by       :   Sajal Mittal
 * 
 * Created Date     :   04-12-2024
 * 
 * Rivision Logs    :   V_1.0 - Created
 *                      V_2.0 - Updated - Implemented Trigger FrameWork
 * 
**/
trigger ContactTrigger on Contact (before insert, before update) {
   new ContactTriggerHandler().run();
}