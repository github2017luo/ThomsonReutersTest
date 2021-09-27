trigger RenewalQuoteTrigger on Renewal_Quote__c (before update) {
           RenewalQuoteTriggerHelper.genericAfterUpdate(trigger.newmap,trigger.oldmap);
}