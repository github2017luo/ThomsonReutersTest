trigger TrainingEventcStats on Training_Event__c(after insert, after update, after delete, after undelete) {

//LTS_6300 : Exclusion framework
      System.debug('LTS_ApplicationAutomationUtility.checkTriggerApplicability()** '+LTS_ApplicationAutomationUtility.checkTriggerApplicability());
      If(LTS_ApplicationAutomationUtility.checkTriggerApplicability())
      {return;}


     //Added for user story CRM-14346
    string triggerDisable = Label.DisableTrigger_TrainingEvent;
    system.debug('@@@@triggerDisable'+triggerDisable);
    Boolean triggerDisbl = triggerDisable.equalsIgnoreCase('True');
    system.debug('@@@triggerDisbl'+triggerDisbl);
    
     if(!triggerDisbl){// For Informatica load CRM-14346
    try {
      List<sObject> so = Database.query('SELECT Id FROM hoopla__Field__c');
      String changeType = Trigger.isInsert ? 'insert' : Trigger.isUpdate ? 'update' : Trigger.isDelete ? 'delete' : 'undelete';
      hoopla.NotifierGlobal.processNotifications('Training_Event__cStats', Trigger.newMap, Trigger.oldMap, changeType);
    }
    catch(Exception e) {
      //Package suspended, uninstalled or expired, exit gracefully.
    }
    }
}