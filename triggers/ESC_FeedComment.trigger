trigger ESC_FeedComment on FeedComment (after insert,before insert) {
//LTS_6301 : Exclusion framework
      System.debug('LTS_ApplicationAutomationUtility.checkTriggerApplicability()** '+LTS_ApplicationAutomationUtility.checkTriggerApplicability());
      If(LTS_ApplicationAutomationUtility.checkTriggerApplicability())
      {return;}
    if(trigger.isAfter && trigger.isInsert){
        ESC_VSTSstagingUpdate.updateVSTSstaging(Trigger.New);
        ESC_ServiceNowStagingHelper.updateSNstagingFeedUpdate(Trigger.New);
    }
    
    /*if(trigger.isBefore && trigger.isInsert){
        ESC_VSTSstagingUpdate.PendingVSTSstaging(Trigger.New);
    }*/
}