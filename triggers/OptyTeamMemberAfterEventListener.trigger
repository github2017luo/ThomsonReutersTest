trigger OptyTeamMemberAfterEventListener on OpportunityTeamMember (After Insert, After Update, After Delete) {

      //LTS_6268 : Exclusion framework
      System.debug('LTS_ApplicationAutomationUtility.checkTriggerApplicability()** '+LTS_ApplicationAutomationUtility.checkTriggerApplicability());
      If(LTS_ApplicationAutomationUtility.checkTriggerApplicability())
      {return;}

if(Boolean.valueOf(System.Label.LCRMGLIOpportunityLoadTriggerFlag) == False){//Added for CRM-14346

    if(trigger.IsInsert){
        OptyTeamMemberTriggerHandler.SyncUserQuota(trigger.new,true);
        OptyTeamMemberTriggerHandler.syncOppTeamToOppTeamClone('insert',Trigger.NewMap.keySet());
        OptyTeamMemberTriggerHandler.syncOppTeamHistory(Trigger.New, Trigger.OldMap, 'Created');
    }else if(trigger.IsUpdate){
        if(checkRecursive.runsyncOppTeamToOppTeamClone()){ //Added for CRM-17836
            OptyTeamMemberTriggerHandler.syncOppTeamToOppTeamClone('update',Trigger.NewMap.keySet());
        }
        OptyTeamMemberTriggerHandler.syncOppTeamHistory(Trigger.New, Trigger.OldMap, 'Updated');
    }else if(trigger.IsDelete){
        OptyTeamMemberTriggerHandler.syncOppTeamToOppTeamClone('delete',Trigger.OldMap.keySet());
        OptyTeamMemberTriggerHandler.syncOppTeamHistory(Trigger.New, Trigger.OldMap, 'Deleted');
    }

}

  
}