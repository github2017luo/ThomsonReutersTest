/**
 * CHANGE HISTORY
 * =========================================================================================================
 * Date            Name                    Description
 * 2016-06-13      Rajashree               BillingAccBeforeEventListener Created (BRS_MS7.1.18,BRS_MS7.1.26)
 * ==========================================================================================================
 */
 
 
trigger BillingAccBeforeEventListener on Billing_Account_Split__c (before update, before delete) {

  if(trigger.isDelete){   
      BillingAccountSplitTriggerHandler.beforeDeleteBAChildOppQuoteSync(trigger.old);
      BillingAccountSplitTriggerHandler.beforeDeleteBAS(trigger.old);
   }
   if(trigger.isUpdate){   
     // BillingAccountSplitTriggerHandler.BASLock(trigger.new, trigger.old);
   } 
 /*  if(trigger.isUpdate || trigger.isInsert) {
       BillingAccountSplitTriggerHandler.SalesPriceCheck(trigger.oldMap, trigger.newMap); 
   }*/
}