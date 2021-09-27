/**********************************
Name: ESC_ReferalTrigger
Purpose:
Author:Mousumi Panda
Date Created:20/06/2017
Date Updated:V0:
**********************************/

trigger ESC_ReferalTrigger on ESC_Case_Collaborator__c (before Insert,before Update,after Update,after Insert) {
    
    if(trigger.isafter && trigger.isInsert){
        ESC_ReferalTriggerHelperClass.isInsertContext = false;
        ESC_ReferalTriggerHelperClass.addremoveOwnerToCaseTeam(trigger.new,null);
        ESC_ReferalTriggerHelperClass.updateRelatedCaseRefStatus(trigger.newMap, new Map<id,ESC_Case_Collaborator__c>());
        ESC_ReferalTriggerHelperClass.updateCaseEscalation(trigger.newMap,null);
        ESC_FollowersMgmt.manageCaseFollowersForReferral(trigger.new , null);
        ESC_ReferalTriggerHelperClass.CaseChatterPostforReferralCreated(trigger.newMap);
    }
    
    if(trigger.isafter && trigger.isUpdate){
        if(MasterCaseTriggerRecursiveCheck.afterUpdateReferralRun == true){
            ESC_ReferalTriggerHelperClass.addremoveOwnerToCaseTeamFilter(trigger.newMap, trigger.oldMap);
            System.debug('trigger.isafter && trigger.isUpdate called');
            ESC_ReferalTriggerHelperClass.updateRelatedCaseRefStatus(trigger.newMap, trigger.oldMap);
            ESC_ReferalTriggerHelperClass.updateCaseEscalation(trigger.newMap, trigger.oldMap);
            ESC_FollowersMgmt.manageCaseFollowersForReferral(trigger.new , trigger.oldMap);
            MasterCaseTriggerRecursiveCheck.afterUpdateReferralRun=false;
        }
        ESC_ReferalTriggerHelperClass.CaseChatterPostforRejectedReferral(trigger.newMap, trigger.oldMap);
    }
    
    if(trigger.isbefore && trigger.isInsert){
        system.debug('Going To call b4insert ESC_VSTSstagingUpdate.ReferralTriggerHelper');
        ESC_VSTSstagingUpdate.ReferralTriggerHelper(Trigger.New,trigger.oldMap,true);
        ESC_ReferalTriggerHelperClass.isInsertContext = true;
        ESC_VSTSstagingUpdate.isvstsContext= true;
        ESC_ReferalTriggerHelperClass.EndDatingOldReferral(trigger.new);
        ESC_ReferalTriggerHelperClass.referralOwnerTeamDivisionInsert(trigger.new);
        ESC_ReferalTriggerHelperClass.EscalationChangeOwnerShip(trigger.new);
        ESC_ReferalTriggerHelperClass.CalculateReferralSLAinsert(trigger.new);
    }
    
    if(trigger.isbefore && trigger.isUpdate){
        if(checkRecursive.runOnce()){
            if(ESC_VSTSstagingUpdate.isvstsContext==false){
                system.debug('Going To call b4Update ESC_VSTSstagingUpdate.ReferralTriggerHelper');
                ESC_VSTSstagingUpdate.ReferralTriggerHelper(Trigger.New,trigger.oldMap,false);
                ESC_ReferalTriggerHelperClass.updUnchecking(trigger.new);
            }
            ESC_ReferalTriggerHelperClass.EndDatingOldReferralFilter(trigger.newMap, trigger.oldMap);
            ESC_ReferalTriggerHelperClass.referralOwnerTeamDivisionUpdate(trigger.newMap, trigger.oldMap);
            ESC_ReferalTriggerHelperClass.CalculateReferralSLA(trigger.newMap, trigger.oldMap);
        }
    }
    
}