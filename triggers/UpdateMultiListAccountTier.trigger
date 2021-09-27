/*
* Description   : CRM-8693 : Trigger for Updating Multi-picklist Account Tier on Account when "Customer Master Attribute 5" on SSD is Inserted or Updated.    
* Author        : Noopur Rathod 
* Change History: 06-Nov-2017 Initial Version
  09-Feb-2018   Modified by Abhirup Banik for CRM-12611
  28-Mar-2018   Commented Line 14,17-19 by Abhirup as CRM-12611 descoped
  02-June-2018  Total active subscriptions roll up summary on Account object .Changes w.r.t CRM-14994
*/
trigger UpdateMultiListAccountTier on Source_System_Detail__c (before insert,after insert, after update, after delete,after Undelete) {
     
    //LTS_5227 : Exclusion framework
    System.debug(LoggingLevel.DEBUG,'LTS_ApplicationAutomationUtility.checkTriggerApplicability()** '+LTS_ApplicationAutomationUtility.checkTriggerApplicability());
    if(LTS_ApplicationAutomationUtility.checkTriggerApplicability()){
        return;
    } //Removing PMD violation added by Miriam
    Boolean isBulkLoad=false;
    Boolean isTestrun=false;
    List<ID> uodatessdList = new List<ID>();
    List<ID> proposalIds = new List<ID>();
    /*List<ID> taxpropIds = new List<ID>();*/ //Added as part of DOC-4080    
    //Added by Tejaswi (GLI-OC) to deactive triggers during data load
    if(!Test.isRunningTest()){
        System.debug(LoggingLevel.DEBUG,'insdie 1 if isTestrun'+isTestrun+' isBulkLoad'+isBulkLoad);
        isTestrun=false;GLI_OC_Bulk_Load__c loadValues = GLI_OC_Bulk_Load__c.getInstance(UserInfo.getUserId());        
        if(loadValues!=null && loadValues.APTS_Disable_Triggers__c){isBulkLoad=true;}
        System.debug(LoggingLevel.DEBUG,'insdie 2 if isTestrun'+isTestrun+' isBulkLoad'+isBulkLoad);
    }else{
        isTestrun=true;
        System.debug(LoggingLevel.DEBUG,'insdie else isTestrun'+isTestrun+' isBulkLoad'+isBulkLoad);
    }
    //End of trigger Deactivate logic     
    if(isTestrun || (isTestrun== false && isBulkLoad ==false)){
        if(Trigger.IsAfter){
            if(Trigger.IsInsert || Trigger.isUpdate || Trigger.isUndelete){
                if(checkRecursive.runOnce()){
                    UpdateMultiListAccountTierHandler.updateAccountTier(Trigger.new);
                    //UpdateAccTierRecalutingSSDAccTier.updateAccountTier(Trigger.new);
                }
            }    
            /* if(Trigger.IsDelete){
                System.debug(LoggingLevel.DEBUG,'@@ After delete trigger');
                LCRMAccountCustomRollupService.CountRollup(Trigger.oldMap,Trigger.newMap);
            }*/
        } 
    } 
    //added by vaishali w.r.t CRM-14994 
    if(Boolean.valueOf(System.Label.LCRMGLISSDLoadTriggerFlag) == false){   
        //DPS-2725,DPS-2727
        if(Trigger.IsBefore && Trigger.IsInsert){
            if(!LCRMGenericComponent.StrikeIronCheckActive() && LCRMGenericComponent.isLotusUser()){
                LCRMGenericComponent.populatebuRegionSegmentLotus(trigger.new);
            }
        }
        //END
        if(Trigger.IsAfter){
            if(Trigger.IsInsert || Trigger.isUpdate || Trigger.isUndelete){
                System.debug(LoggingLevel.DEBUG,'@@ After insert trigger');
                if(LCRMAccountCustomRollupService.checkRecursive()){
                    System.debug(LoggingLevel.DEBUG,'@@ insert trigger');
                    LCRMAccountCustomRollupService.CountRollup(Trigger.oldMap,Trigger.newMap);   
                }
            }    
            if(Trigger.isUpdate){
                System.debug(LoggingLevel.DEBUG,'@@ After update trigger'); 
                APTS_UpdateMultiListAccountTierHelper.updatessdproporder(Trigger.oldMap,Trigger.new);
            }
            if(Trigger.IsDelete){
                System.debug(LoggingLevel.DEBUG,'@@ After delete trigger');
                LCRMAccountCustomRollupService.CountRollup(Trigger.oldMap,Trigger.newMap);
            }
        }
    }
}