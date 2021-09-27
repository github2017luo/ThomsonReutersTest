trigger APTS_ProductConfigurationTrigger on Apttus_Config2__ProductConfiguration__c (before update, after update, after insert) {
    Boolean isBulkLoad=false;
    Boolean isTestrun=false;
    
    //Added by Tejaswi (GLI-OC) to deactive triggers during data load

    if(!Test.isRunningTest()){
        isTestrun=false;
        GLI_OC_Bulk_Load__c loadValues = GLI_OC_Bulk_Load__c.getInstance(UserInfo.getUserId());        
        if(loadValues!=null && (loadValues.APTS_Disable_Triggers__c)) isBulkLoad=true;
    }else {
        isTestrun=true;
    }
    //End of trigger Deactivate logic
    
     if(isTestrun || (isTestrun== false && isBulkLoad ==false))
     {
     System.debug('inside trigger execution');
    if(trigger.isAfter && trigger.isUpdate){
        APTS_ProductConfigurationTriggerHandler.OnAfterUpdate(trigger.oldMap, trigger.new, trigger.newMap);
    }
    
    if(trigger.isBefore && trigger.isUpdate){
        APTS_ProductConfigurationTriggerHandler.onBeforeUpdate(trigger.new);
    }
     
    }
  }