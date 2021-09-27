trigger APTS_ProposalTrigger on Apttus_Proposal__Proposal__c (before insert, before update, before delete, after insert, after update, after delete) {
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
        system.debug('inside proposal trigger');
        APTS_ProposalTriggerHandler handler = new APTS_ProposalTriggerHandler();
        
        if(Trigger.isInsert && Trigger.isBefore){
            Credit_IncreaseTriggerHelper.updateCreditcarddetails(Trigger.new);
            handler.OnBeforeInsert(Trigger.new);
        } else if(Trigger.isUpdate && Trigger.isBefore){
            Credit_IncreaseTriggerHelper.updatePaymentStatus(Trigger.new);
            handler.OnBeforeUpdate(trigger.oldMap,Trigger.new,trigger.newMap);
        } else if (Trigger.isUpdate && Trigger.isAfter) {
            handler.OnAfterUpdate(Trigger.oldMap, Trigger.new, Trigger.newMap);
        } else if (Trigger.isInsert && Trigger.isAfter) {
            handler.OnAfterInsert(Trigger.oldMap, Trigger.new, Trigger.newMap);
        }
        //DOC-5003 Starts       
        else if (Trigger.isDelete && Trigger.isBefore) {        
            handler.OnBeforeDelete(Trigger.old);        
        }       
        //DOC-5003 Ends
        /*else if(Trigger.isBefore && Trigger.isUpdate){
// p.adderror('@@@@@');
for(Apttus_Proposal__Proposal__c p : Trigger.new){
p.adderror('@@@@@');
string str = handler.OnBeforeInsertUpdate(p);
if(str=='')
p.adderror('@@@@');
else
p.adderror('s');
}
}*/
        
        /* if(trigger.isAfter && trigger.isInsert){
Set<Id> cartIdSet = new set<Id>();
for(Apttus_Proposal__Proposal__c cart : Trigger.new){
cartIdSet.add(cart.id);   
}
Digital_ProposalAutomation.GenerateDocument(cartIdSet);
} */
    }
    // START: DPS-16056
    if(Boolean.valueOf(System.Label.Lcrm_disable_opportunityquotesync) == False){
        if(Trigger.isAfter && Trigger.isUpdate){
            
            if(Limits.getQueueableJobs() < Limits.getLimitQueueableJobs() && !System.isQueueable() && !System.isFuture() && !LCRMGenericComponent.StrikeIronCheckActive() && LcrmOpportunityQuoteSync.invokeOnce==false) 
            {
                LcrmOpportunityQuoteSync.invokeOnce=true;
                ID JobID=System.enqueueJob(new LcrmOpportunityQuoteSync(trigger.new, trigger.oldMap, trigger.newMap));
                
            }
        }
        if(Trigger.isAfter && Trigger.isInsert){
            if(Limits.getQueueableJobs() < Limits.getLimitQueueableJobs() && !System.isQueueable() && !System.isFuture() && !LCRMGenericComponent.StrikeIronCheckActive() && LcrmOpportunityQuoteSync.invokeOnce==false) 
            {
                LcrmOpportunityQuoteSync.invokeOnce=true;
                ID JobID=System.enqueueJob(new LcrmOpportunityQuoteSync(trigger.new));
            }
        }}
    //END: DPS-16056
    
}