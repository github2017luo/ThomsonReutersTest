trigger TrainingEventTrigger on Training_Event__c (after update , before delete, after insert,before insert,before update) {
//LTS_6300 : Exclusion framework
      System.debug('LTS_ApplicationAutomationUtility.checkTriggerApplicability()** '+LTS_ApplicationAutomationUtility.checkTriggerApplicability());
      If(LTS_ApplicationAutomationUtility.checkTriggerApplicability())
     {return;}

  List<Training_Event__c> listTrainingEvents = new List<Training_Event__c>();
  List<Training_Event__c> listTrainingEventsCompleted = new List<Training_Event__c>();

  //Added for user story CRM-14346
    string triggerDisable = Label.DisableTrigger_TrainingEvent;
    system.debug('@@@@triggerDisable'+triggerDisable);
    Boolean triggerDisbl = triggerDisable.equalsIgnoreCase('True');
    system.debug('@@@triggerDisbl'+triggerDisbl);
    
    if(!triggerDisbl){// For Informatica load CRM-14346
    if(trigger.isDelete){
        TrainingEventsUtil.LastTrainedUpdateonAccountdel(Trigger.old);
    }
    else if(trigger.isAfter){
        if(trigger.isUpdate){
          for(Training_Event__c oTrainingEvent : trigger.new){
            if(oTrainingEvent.Training_Date__c!=trigger.oldmap.get(oTrainingEvent.Id).Training_Date__c){
                listTrainingEvents.add(oTrainingEvent);
            }
            // if the status is changing to 'Completed' - send email alert to all team members
            if(oTrainingEvent.Status__c != trigger.oldmap.get(oTrainingEvent.Id).Status__c && oTrainingEvent.Status__c == 'Completed'){
                listTrainingEventsCompleted.add(oTrainingEvent);
            }              
          } 
          TrainingEventsUtil.LastTrainedUpdateonAccount(listTrainingEvents);
          if(!ListTrainingEventsCompleted.isEmpty()) 
            TrainingEventsUtil.CompletedTrainingEvent(listTrainingEventsCompleted);
         
        }
        if(trigger.isInsert){
            TrainingEventsUtil.CreateTrainingEventAccount(Trigger.newMap);
            TrainingEventsUtil.createStrategy2TrainingEvent(Trigger.newMap);
        }
    }
    if(trigger.isBefore){
        if(trigger.isInsert){
            //added by Saloni for CRM-3248
            TrainingEventsUtil.initialiseGLITrainingEventFields(trigger.new);
            
            if(!LCRMGenericComponent.StrikeIronCheckActive() && LCRMGenericComponent.isLotusUser()){
             LCRMGenericComponent.populatebuRegionSegmentLotus(trigger.new);
            }
        }
    }
    }

}