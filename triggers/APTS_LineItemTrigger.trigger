trigger APTS_LineItemTrigger on Apttus_Config2__LineItem__c (before insert, before update, before delete, after insert, after update, after delete) {
    Boolean isBulkLoad=false;
    Boolean isTestrun=false;
    
    //Added by Tejaswi (GLI-OC) to deactive triggers during data load

    if(!Test.isRunningTest()){
        isTestrun=false;
        GLI_OC_Bulk_Load__c loadValues = GLI_OC_Bulk_Load__c.getInstance(UserInfo.getUserId());        
        if(loadValues!=null && loadValues.APTS_Disable_Triggers__c) isBulkLoad=true;
    }else {
    
        isTestrun=true;
    
    }
    //End of trigger Deactivate logic
    
     if(isTestrun || (isTestrun== false && isBulkLoad ==false))
     {
     System.debug('inside trigger execution');
    APTS_LineItemTriggerHandler handler = new APTS_LineItemTriggerHandler();    
    if (Trigger.isUpdate && Trigger.isAfter) {
        handler.OnAfterUpdate(Trigger.oldMap, Trigger.new, Trigger.newMap);
    } else if (Trigger.isInsert && Trigger.isAfter) {
        handler.OnAfterInsert(Trigger.oldMap, Trigger.new, Trigger.newMap);
    } else if (Trigger.isDelete && Trigger.isAfter) {
        handler.OnAfterDelete(Trigger.old);
    } else if (Trigger.isDelete && Trigger.isBefore) {
        handler.OnBeforeDelete(Trigger.old);
    } else if (Trigger.isUpdate && Trigger.isBefore) {
        handler.onBeforeUpdate(Trigger.new);    // Written by Bhupendra Jain on 27-Oct-16
        If(!Test.isRunningTest())
            APTS_LineItemTriggerHelper.retrieveAdjustmentAmount(Trigger.new); //SOC-4319
    }//Added before insert logic by Keerthana for Findlaw changes
       else if(trigger.isInsert && trigger.Isbefore){
        handler.onBeforeInsert(Trigger.new);
        APTS_LineItemTriggerHelper.retrieveAdjustmentAmount(Trigger.new); //SOC-4319
    } /*SOC-4319
       else if (Trigger.isBefore && (Trigger.isInsert ||Trigger.isUpdate)){
       System.debug('Inside 4319');
       APTS_LineItemTriggerHelper.retrieveAdjustmentAmount(Trigger.new);
    }  */
       
    }   
}