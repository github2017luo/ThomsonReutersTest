/**
* Test class : OmniTrialContactTriggerHandler_Test
* JIRA Details: 
* CHANGE HISTORY
* =====================================================================================================================
* Date         Name                    Description
* JULY 2021     TCS DevTeam             Created as Part of DPS-20419
*                                       to update the Trial Status Based on the Trail contact status
*                                                                 
* =====================================================================================================================
*/
/**
* @description OmniTrialContactTriggerHandlerHelper
* 
*/

public without sharing class OmniTrialContactTriggerHandlerHelper {
    
    /**
* @description fetchTrialRecords
* @param trailId
* @return trialList
* 
*/    
    
    public static List<Ent_Trial__c> fetchTrialRecords(set<id> trailId){
        List<Ent_Trial__c> trialList = new List<Ent_Trial__c>();
        if(Schema.sObjectType.Ent_Trial__c.isAccessible() ){
            trialList = [Select id, Trial_Status__c ,Extended__c from Ent_Trial__c where id IN: trailId];
        }
        return trialList;
    }
    
    
    /**
* @description fetchTrialContactRecords
* @param trailId
* @return trialContList 
* 
*/    
    
    public static List<Trial_Contact__c> fetchTrialContactRecords(set<id> trailId){
        List<Trial_Contact__c> trialContList = new List<Trial_Contact__c>();
        if( Schema.sObjectType.Trial_Contact__c.isAccessible()){
            trialContList = [Select id, Status__c,Trials__c,Entitlement_Email_Sent__c  from Trial_Contact__c where Trials__c IN: trailId];
        }
        return trialContList;
    }
    
    
    /**
* @description fetchTrialContactStatus
* @param trialCOntList
* @return trailConStatus
* 
*/    
    
    public static set<String> fetchTrialContactStatus(List<Trial_Contact__c> trialCOntList){
        set<String> trailConStatus = new set<String>();
        if(trialCOntList != null && trialCOntList.size()>0){
            for(Trial_Contact__c trialcont : trialCOntList){                        
                trailConStatus.add(trialcont.Status__C);
            }
        }
        return trailConStatus;
    }
    
        
    
    /**
* @description checkTrialContactStatus
* @param trlConStatus
* @return trialStatus
* 
*/
    public static String checkTrialContactStatus(set<String> trlConStatus){
        
        String trialStatus;
        if(trlConStatus.contains('Active')){
            trialStatus = 'Active';                    
        }else if(trlConStatus.contains('Accepted')){
            trialStatus = 'Accepted';
        }else if(trlConStatus.contains('Invited')){
            trialStatus = 'Invited';
        }
        return trialStatus;
    }
    
    
    /**
* @description createBlackListRecordTrigger
* @param newTrialcontact
* @param oldTrialcontactMap
* 
*/
    public static void createBlackListRecordTrigger(List<Trial_Contact__c> newTrialcontact,Map<id,Trial_Contact__c> oldTrialcontactMap){
        List<Digital_Blacklist_or_CompetitorList__c> blacklist = new List<Digital_Blacklist_or_CompetitorList__c> ();            
        for(Trial_Contact__c  tc : newTrialcontact){
            if(tc.Status__c == 'Ended' && (tc.Status__c != oldTrialcontactMap.get(tc.Id).Status__c)){
                Digital_Blacklist_or_CompetitorList__c blackListRec = new Digital_Blacklist_or_CompetitorList__c();
                blackListRec.Name = tc.First_Name__c +' '+tc.Last_Name__c;
                blackListRec.Email__c = tc.Email__c;
                blackListRec.Type__c = 'Blacklist';
                blackListRec.Status__c='Blocked';
                blackListRec.Reason__c='Trial Abuser';
                
                blacklist.add(blackListRec);
            }
        }
        if(blacklist != null && blacklist.size()>0){
            createBlacklistRecords(blacklist);
        }
        
    }
    
    /**
* @description createBlacklistRecords
* @param blacklist
* 
*/
    @testVisible
    private static void createBlacklistRecords(List<Digital_Blacklist_or_CompetitorList__c> blacklist){
        if(Digital_Blacklist_or_CompetitorList__c.SobjectType.getDescribe().isCreateable() && 
           Digital_Blacklist_or_CompetitorList__c.SobjectType.getDescribe().isUpdateable() && 
           blacklist.size()>0){
               Database.insert(blacklist, false);
           }
    }
    
    /**
* @description updateTrials
* @param trials
* 
*/
    
    public static void updateTrials(List<Ent_Trial__c> trials){
        if(Ent_Trial__c.SobjectType.getDescribe().isCreateable() && 
           Ent_Trial__c.SobjectType.getDescribe().isUpdateable() && 
           trials.size()>0){
               Database.update(trials, false);
           }
    } 
    
    /**
    * @description checkContainTrialStatus
    * @param trailConStatus
    * @return isCheck
    */
    public static Boolean checkContainTrialStatus(Set<String> trailConStatus){
        Boolean isCheck = false;
        if(trailConStatus.contains('Active')|| trailConStatus.contains('Accepted') || trailConStatus.contains('Invited')){
            isCheck = true;
        }
        return isCheck;
    }
}