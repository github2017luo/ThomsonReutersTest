trigger APTS_GroupTrigger on APTS_Group__c (before insert, before update, before delete, after insert, after update, after delete) {
    
    APTS_GroupTriggerHandler handler = new APTS_GroupTriggerHandler();
    
    if(Trigger.isInsert && Trigger.isAfter){
        handler.onAfterInsert(Trigger.new);
    }
    
    if(Trigger.isUpdate && Trigger.isAfter){
        handler.onAfterUpdate(Trigger.new);
    }

}