trigger Strategy2OpptybeforeEventListener on SFDC_Strategy2Oppty__c (before insert,before update) {
    if(trigger.isInsert){
        StrategyTriggerHandler.Strategy2OpptyDuplicatePreventer(trigger.new);
    }
    if(trigger.isUpdate){
        StrategyTriggerHandler.Strategy2OpptyDuplicatePreventer(trigger.new,trigger.oldmap);
    }
}