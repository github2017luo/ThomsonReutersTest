trigger ProductTrialBeforeEventListener on Product_Trial__c (before insert,before update) {
    if(ProductTrialTriggerHandler.flag == true){
        ProductTrialTriggerHandler.flag = false;
        ProductTrialTriggerHandler.UpdateAccountOnTrial(trigger.new);
     }

}