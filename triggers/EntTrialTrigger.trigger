/**
* JIRA Details: 
* CHANGE HISTORY
* =============================================================================
* Date         Name                    Description
* JUN 2021     TCS                      Created as Part of DPS-20397,DPS-20399,DPS-20400
*                                       to update the "Has Active Trail" field on Account, Lead, Opportunity
*                                       when it has atleast one Trial with the Status - Rep Initiated or Accepted  
* =================================================================================
*/
trigger EntTrialTrigger on Ent_Trial__c (before delete, after insert, after update, after delete, after undelete, before insert, before update) {
    
    
        EntTrialTriggerHandler.onAfterInsert(trigger.NewMap); 
        EntTrialTriggerHandler.onAfterUpdate(trigger.NewMap, trigger.OldMap);
        EntTrialTriggerHandler.onAfterDelete(trigger.OldMap); 

}