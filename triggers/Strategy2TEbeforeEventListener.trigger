trigger Strategy2TEbeforeEventListener on Strategy2TrainingEvent__c (before insert,before update) {

    if(trigger.isInsert){
        StrategyTriggerHandler.Strategy2TrainingEventDuplicatePreventer(trigger.new);
    }
    if(trigger.IsUpdate){
        StrategyTriggerHandler.Strategy2TrainingEventDuplicatePreventer(trigger.new,trigger.oldmap);
    }
}