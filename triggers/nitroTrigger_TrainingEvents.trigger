trigger nitroTrigger_TrainingEvents on Training_Event__c (after insert, after update) {
/* SKG
  if (nitro.NitroCommonUtility.isParticipant()) {
    nitro.NitroAPICall apiCall = new nitro.NitroAPICall();  
      String nitroUserId = nitro.NitroCommonUtility.getNitroUserId();  
      Integer actionCounter = 0;
      
      for (Training_Event__c TE :trigger.new) {
        if (trigger.isUpdate) {
            if (TE.Status__c == 'Completed' && trigger.oldMap.get(TE.id).Status__c != 'Completed') {
                apiCall.addLogAction('TRAININGEVENT_COMPLETED',nitroUserId);
                actionCounter++;
            } 
        } else {
            if (TE.Status__c == 'Completed') {
                apiCall.addLogAction('TRAININGEVENT_COMPLETED',nitroUserId);
                actionCounter++;
            }
        }
      }
      
      if (actionCounter != 0)
        nitro.NitroProxy.logActions(apiCall.getActionList()); 
  } */
}