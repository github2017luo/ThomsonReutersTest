/**
* Test class : OmniTrialProdConTriggerHandlerTest
* JIRA Details: 
* CHANGE HISTORY
* =====================================================================================================================
* Date         Name                    Description
* JULY 2021     TCS DevTeam             Created as Part of DPS-20978
*                                       to update the Trial Contact Status Based on the Trail Product contact status*  
*                                                                 
* =====================================================================================================================
*/
/**
* @description OmniTrialProductContactTrgrHandlerHelper
* 
*/

public without sharing class OmniTrialProductContactTrgrHandlerHelper {
    
    /**
* @description fetchTrialContactRecords
* @param trailsIdlist
* @return trialContList 
* 
*/    
    
    public static List<Trial_Contact__c> fetchTrialContactRecords(set<id>  trailsIdlist){
        List<Trial_Contact__c> trialContList = new List<Trial_Contact__c>();
        if( Schema.sObjectType.Trial_Contact__c.isAccessible()){
            trialContList = [Select id, Status__c, Trials__r.id from Trial_Contact__c  where Trials__r.id IN: trailsIdlist];
        }
        return trialContList;
    }
    
    /**
* @description fetchTrialProductContactRecords
* @param trialConmap
* @return trialProContList 
* 
*/    
    
    public static List<Trial_Product_Contact__c> fetchTrialProductContactRecords(Map<id,Trial_Contact__c>trialConmap){
        List<Trial_Product_Contact__c> trialProContList = new List<Trial_Product_Contact__c>();
        if( Schema.sObjectType.Trial_Product_Contact__c.isAccessible()){
            trialProContList = [Select id,Trial_Contact__c,Entitlement_Status__c,Entitlement_Status_Description__c from Trial_Product_Contact__c  where Trial_Contact__r.id  IN: trialConmap.keySet()];
        }
        return trialProContList;
    }
    
     /**
* @description updateTrialContactStatus
* @param trialConlist
* 
*/
   
    public static void updateTrialContactStatus(List<Trial_Contact__c> trialConlist){
        if(Trial_Contact__c.SobjectType.getDescribe().isCreateable() && 
           Trial_Contact__c.SobjectType.getDescribe().isUpdateable() && 
           trialConlist.size()>0){
               Database.update(trialConlist,false);
           }
    }  
    
     /**
* @description checkCompleteStatusOfTrialProCon
* @param trailProcon
* @return status 
* 
*/
    public static String checkCompleteStatusOfTrialProCon(Trial_Product_Contact__c trailProcon){
        String status ='';
        if(trailProcon.Entitlement_Status__c == 'COMPLETE' && trailProcon.Entitlement_Status_Description__c == 'User access is ended' ){            
            status='Ended';            
        }else if(trailProcon.Entitlement_Status__c == 'COMPLETE' && (trailProcon.Entitlement_Status_Description__c =='User is entitled') ){            
            status='Active';
        }else if(trailProcon.Entitlement_Status__c == 'COMPLETE' && (trailProcon.Entitlement_Status_Description__c =='User access is extended') ){            
            status='Extended';
        }
        return status;
        
    }
    
     /**
* @description setTrialConStatus
* @param updateTrailProconList
* @return status 
* 
*/
    
    public static String setTrialConStatus(Set<String> updateTrailProconList){
        String status ='';
        if(updateTrailProconList.contains('Ended')){                
            status = 'Ended';                
        }else if(updateTrailProconList.contains('Active')){
            status = 'Active';                
        }else if(updateTrailProconList.contains('Extended')){
            status = 'Extended';                
        }  
        return status;
    }
    

}