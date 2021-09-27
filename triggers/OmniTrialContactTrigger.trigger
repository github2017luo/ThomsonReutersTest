/**
* JIRA Details: 
* CHANGE HISTORY
* =============================================================================
* Date         Name                    Description
* JUN 2021     TCS                      Created as Part of DPS-20419
*                                       to update the Trial Status Based on the Trail contact status*                                        
* =================================================================================
*/
trigger OmniTrialContactTrigger on Trial_Contact__c ( after insert, after update, after delete, after undelete) {
    
    OmniTrialContactTriggerHandler.onAfterInsertUndeleteTrigger(trigger.new);
    OmniTrialContactTriggerHandler.onAfterDeleteTrigger(trigger.old);
    OmniTrialContactTriggerHandler.onAfterUpdateTrigger(trigger.new,Trigger.oldMap);
    
}