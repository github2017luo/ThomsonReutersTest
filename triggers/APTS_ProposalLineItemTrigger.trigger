trigger APTS_ProposalLineItemTrigger on Apttus_Proposal__Proposal_Line_Item__c (before insert, before update, before delete, after insert, after update, after delete) {
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
        APTS_ProposalLineItemTriggerHandler handler = new APTS_ProposalLineItemTriggerHandler();
        // Sreenu Changes Start for validating the Online/Master Contacs Flag on before insert - SOC-2337
        if(Trigger.isInsert && Trigger.isBefore){
            handler.OnBeforeInsert(Trigger.new);
        }
        // Sreenu changes End
        if(Trigger.isInsert && Trigger.isAfter){
            handler.OnAfterInsert(Trigger.new);
        } else if (Trigger.isUpdate && Trigger.isAfter){
            handler.onAfterUpdate(Trigger.new);
        } else if (Trigger.isDelete && Trigger.isBefore){
            handler.onBeforeDelete(Trigger.old);
        } else if (Trigger.isUpdate && Trigger.isBefore){
            handler.onBeforeUpdate(Trigger.new);
        }
    }
}