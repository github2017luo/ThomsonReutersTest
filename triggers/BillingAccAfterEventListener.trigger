/**
 * CHANGE HISTORY
 * =============================================================================
 * Date         Name                   Description
 * 2016-06-03   TCS Offshore           Created((BRS_MS7.1.18,BRS_MS7.1.26)
 * =============================================================================
 */
trigger BillingAccAfterEventListener on Billing_Account_Split__c (after update) {

  if(trigger.isUpdate){
      BillingAccountSplitTriggerHandler.afterUpdateBAQuoteSync(Trigger.newMap,Trigger.oldMap);
  }
    
}