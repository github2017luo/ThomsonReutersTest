/**
* JIRA Details: 
* CHANGE HISTORY
* =============================================================================
* Date         Name                    Description
* JUN 2021     TCS                      Created as Part of DPS-20978
*                                       to update the Trial Contact Status Based on the Trail Product contact status*                                        
* =================================================================================
*/
trigger OmniTrialProductContactTrigger on Trial_Product_Contact__c (after insert, after update) {
    OmniTrialProductContactTriggerHandler.onAfterInsertUpdateTrigger(trigger.new);
}