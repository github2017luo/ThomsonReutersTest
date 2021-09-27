/**
 * CHANGE HISTORY
 * =============================================================================
 * Date         Name                    Description
 * 2018-04-16   Shailesh Patel          Created
 * =============================================================================
 */ 
trigger LCRMRecommendedProductTrigger on LCRM_Recommended_Product__c (Before insert, Before Update) {
    
    //DLT-9069 to update Product Look up field on Lead Product obj.
    if(LeadProductTriggerHandler.trialProductFlag){ 
        LeadProductTriggerHandler.trialProductFlag = false;   
        if(Trigger.isBefore && Trigger.isInsert){
            LeadProductTriggerHandler.handlBeforeInsert(trigger.New);
        }    
        
        if(Trigger.isBefore && Trigger.isUpdate){
            LeadProductTriggerHandler.handlBeforeUpdate(trigger.New, Trigger.oldMap);
        }
    } 
}