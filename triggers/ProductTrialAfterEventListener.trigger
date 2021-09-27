trigger ProductTrialAfterEventListener on Product_Trial__c (after Insert,after update) {
 if(ProductTrialTriggerHandler.recflag == true){
        ProductTrialTriggerHandler.recflag = false;
    ProductTrialTriggerHandler.InsertTrialUsers(trigger.new);
    }
}