trigger EventTrigger on Event (after insert, after update, after delete, after undelete) {
    if(trigger.isAfter) {
        if(trigger.isInsert || trigger.isUpdate || trigger.isDelete || trigger.isUndelete) {
            EventTriggerHandler.handleEvent(trigger.new, trigger.oldMap);
        }
    }
}