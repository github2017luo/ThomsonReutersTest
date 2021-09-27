trigger StrategyAfterEventListener on SFDC_Strategy__c (after Insert) {
    if(trigger.isAfter && trigger.isInsert){
        StrategyTriggerHandler.createStrategy2Oppty(trigger.new);
        StrategyTriggerHandler.createStrategy2TE(trigger.new);
    }
}