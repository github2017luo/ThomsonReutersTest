trigger APTS_OrderTrigger on Apttus_Config2__Order__c (before update, after insert, after update) {
    System.debug(LoggingLevel.DEBUG,'inside trigger execution');
    APTS_OrderTriggerHandler.exclusionframework(Trigger.new,Trigger.OldMap);
    
    if(Trigger.isInsert && Trigger.isAfter){
        AutoPayment_TriggerHandler.doAfterInsert(trigger.new);
    }
    if(Trigger.isUpdate && Trigger.isAfter){
        AutoPayment_TriggerHandler.doAfterUpdate(trigger.new,trigger.oldMap);
    }
}