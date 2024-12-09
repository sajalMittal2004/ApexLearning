trigger ContactTrigger on Contact (before insert, before update) {
    if(trigger.isBefore){
        if(trigger.isInsert || trigger.isUpdate){
            ContactTriggerHandler.validateContactEmailDomain(trigger.new, trigger.olMap);
        }
    }
}