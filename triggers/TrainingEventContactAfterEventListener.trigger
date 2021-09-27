trigger TrainingEventContactAfterEventListener on Training_Event_Contact__c (after delete, after insert, after update) {


    Set<Id> trainingEventIds = new Set<Id>();
    
    if (trigger.isInsert || trigger.isUpdate) {
        for (Training_Event_Contact__c oEventContact : trigger.new) {
            trainingEventIds.add(oEventContact.Training_Event__c);
        }
    }
    else if (trigger.isDelete){
        for (Training_Event_Contact__c oEventContact : trigger.old) {
            trainingEventIds.add(oEventContact.Training_Event__c);
        }
    }
    
    if (trainingEventIds.isEmpty() == false) {
        TrainingEventsUtil.syncTrainingEventAccounts(trainingEventIds);
        
        }
}