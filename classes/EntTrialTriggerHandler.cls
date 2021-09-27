/**
* Test class : EntTrailTriggerHelper_Test
* JIRA Details: 
* CHANGE HISTORY
* =====================================================================================================================
* Date         Name                    Description
* JUN 2021     TCS DevTeam             Created as Part of DPS-22641, DPS-20397,DPS-20399,DPS-20400
*                                       to update the "Has Active Trail" field on Account, Lead, Opportunity
*                                       when it has atleast one Trial with the Status - Active
*                                                                 
* =====================================================================================================================
*
*/
/**
* @description to update the Boolean Flag
* 
*/
public  without sharing class EntTrialTriggerHandler{
    
    /**
*  @description isRecursive Flag
*/
    public static boolean isRecursive = false;
    
    /**
* @description afterInsert Context
* @param triggerNewMap
* 
*/
    public static void onAfterInsert(Map<Id, Ent_Trial__c> triggerNewMap){
        if(!EntTrialTriggerHandler.isRecursive){
            if(Trigger.isInsert && Trigger.isAfter){ 
                EntTrialTriggerHandler.isRecursive = true;
                EntTrialTriggerHelper.updateTrlStatusOnOpptAccLead(triggerNewMap);
            }
        }
    }
    
    /**
* @description AfterUpdate Context
* @param triggerNewMap
* @param triggerOldMap
* 
*/
    public static void onAfterUpdate(Map<Id, Ent_Trial__c> triggerNewMap, Map<Id, Ent_Trial__c> triggerOldMap){
        if(!EntTrialTriggerHandler.isRecursive){
            if(Trigger.isUpdate && Trigger.isAfter ){
                EntTrialTriggerHandler.isRecursive = true;
                EntTrialTriggerHelper.updateTrlStatusOnOpptAccLead(triggerNewMap);
            }
        }
    }
    
     /**
* @description onAfterDelete Context
* @param triggerOldMap
* 
*/
    public static void onAfterDelete(Map<Id, Ent_Trial__c> triggerOldMap){
        if(!EntTrialTriggerHandler.isRecursive){
            if(Trigger.isDelete && Trigger.isAfter ){
                EntTrialTriggerHandler.isRecursive = true;
                EntTrialTriggerHelper.updateTrlStatusOnOpptAccLead(triggerOldMap);
            }
        }
    }
}