trigger nitroTrigger_Activities on Task (after insert) {
  /* skg
  if (nitro.NitroCommonUtility.isParticipant()) {
    nitro.NitroAPICall apiCall = new nitro.NitroAPICall();
    String nitroUserId = nitro.NitroCommonUtility.getNitroUserId();
    Integer actionCounter = 0;
    set<string> TaskTypes = new set<string>{'Call', 'Cold call', 'Outbound Call', 'Inbound Call', 'Email'};
    
    for (Task T : trigger.new) {
      if (TaskTypes.contains(T.Type)) {
        system.debug('Task Activity logAction');
        apiCall.addLogAction('TASK_ACTIVITY');
        actionCounter++;
      }
      
      if (T.Activity_Category__c == 'A Referral') {
        system.debug('A Referral logAction');
        apiCall.addLogAction('TASK_ACTIVITYCATEGORY_AREFERRAL');
        actionCounter++;
      } else if (T.Activity_Category__c == 'B Referral') {
        system.debug('B Referral logAction');
        apiCall.addLogAction('TASK_ACTIVITYCATEGORY_BREFERRAL');
        actionCounter++;
      } else if (T.Activity_Category__c == 'P Referral') {
        system.debug('P Referral logAction');
        apiCall.addLogAction('TASK_ACTIVITYCATEGORY_PREFERRAL');
        actionCounter++;
      }
    }
    
    if (actionCounter > 0) {
      system.debug('send Nitro Actions');
      nitro.NitroProxy.logActions(apiCall.getActionList());
    }
  } */
}