trigger TaskTrigger on Task (after insert, after update, after delete, after undelete) {
    if(trigger.isAfter) {
        if(trigger.isInsert || trigger.isUpdate || trigger.isDelete || trigger.isUndelete) {
            TaskTriggerHandler.handleTask(trigger.new, trigger.oldMap);
        }
    }
}