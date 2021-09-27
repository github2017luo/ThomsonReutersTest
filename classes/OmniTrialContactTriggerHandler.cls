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
* @description OmniTrialContactTriggerHandler
* 
*/

public without sharing class OmniTrialContactTriggerHandler {
    /**
*  @description isRecursive Flag
*/
    public static boolean isRecursive = false;
    
    /**
*  @description updateCounter is used to update trial status based on trial contact updation post trial product contact Updation
*/
    public static Integer updateCounter = 0;
    
    /**
* @description afterInsert Context
* @param newTrialcontact
* 
*/
    
    public static void onAfterInsertUndeleteTrigger(List<Trial_Contact__c> newTrialcontact){
        
        if(!OmniTrialContactTriggerHandler.isRecursive && Trigger.isAfter && (Trigger.isinsert || Trigger.isundelete)){          
            OmniTrialContactTriggerHandler.isRecursive = true;           
            processTrails(newTrialcontact);
        }          
    }    
    
    /**
* @description After Update Trigger
* @param newTrialcontact
* @param oldTrialcontactMap
* 
*/
    public static void onAfterUpdateTrigger(List<Trial_Contact__c> newTrialcontact,Map<id,Trial_Contact__c> oldTrialcontactMap){
        if((!OmniTrialContactTriggerHandler.isRecursive || updateCounter < 2 ) && Trigger.isAfter && Trigger.isupdate){ 
            OmniTrialContactTriggerHandler.updateCounter ++ ;
            processTrails(newTrialcontact);
            OmniTrialContactTrgrContactUpdateHelper.processContacts(newTrialcontact,oldTrialcontactMap);
            OmniTrialContactTriggerHandlerHelper.createBlackListRecordTrigger(newTrialcontact,oldTrialcontactMap);
            OmniTrialContactTrgrEloquaHelper.UpdateEntitlementEmailSentByEloqua(newTrialcontact);
            OmniTrialContactTriggerHandler.isRecursive = true;
        }
        
    }
    
    /**
* @description Updates Trail status
* @param trialcontact
* 
*/
    @testVisible
    private static void processTrails(List<Trial_Contact__c> trialcontact){
        set<id> trialids= new set<id>();
        for(Trial_Contact__c c: trialcontact){                
            if(c.Trials__c!=null){
                trialids.add(c.Trials__c);
            }                
        }
        if(trialids != null && trialids.size()>0){
            OmniTrialContactTriggerHandler.updateTrialRecord(trialids);
        }
    }
    
    
    /**
* @description afterdelete Context
* @param oldTrialcontact
* 
*/
    public static void onAfterDeleteTrigger(List<Trial_Contact__c> oldTrialcontact){        
        if(!OmniTrialContactTriggerHandler.isRecursive && Trigger.isAfter && Trigger.isdelete){
            OmniTrialContactTriggerHandler.isRecursive = true;            
            processTrails(oldTrialcontact);
        }        
    }
    
    /**
* @description updateTrialRecord
* @param trailId
* 
*/
    public static void updateTrialRecord(set<id> trailId){        
        List<Ent_Trial__c> trialList = OmniTrialContactTriggerHandlerHelper.fetchTrialRecords(trailId);
        
        //Map<Id, Ent_Trial__c> entTrialMap = new Map<Id, ENt_Trial__c>(trialList);
        
        List<Trial_Contact__c> trialContSobjList = OmniTrialContactTriggerHandlerHelper.fetchTrialContactRecords(trailId);
        
        //create Map which will contact Trial/TrialId, List Of trial contacts
        Map<Id, List<Trial_Contact__c>> mapTrialWithContacts = new Map<Id, List<Trial_Contact__c>>();
        mapTrialWithContacts = getMapOfTrialWIthTrialContacts(trialContSobjList);
        
        if(mapTrialWithContacts != null && mapTrialWithContacts.size()>0){
            for(Ent_Trial__c trial : trialList ){
                updateStatusforTrail(trial,mapTrialWithContacts);                        
            }
        }
            OmniTrialContactTriggerHandlerHelper.updateTrials(trialList);
            
        
    }  
    
    
     /**
* @description updateStatusforTrail
* @param trial
* @param mapTrialWithContacts
* 
*/
    public static void updateStatusforTrail(Ent_Trial__c trial,Map<Id, List<Trial_Contact__c>> mapTrialWithContacts){
         set<String> trailConStatus = OmniTrialContactTriggerHandlerHelper.fetchTrialContactStatus(mapTrialWithContacts.get(trial.Id)); 
                Boolean isTrialStatusCheck = OmniTrialContactTriggerHandlerHelper.checkContainTrialStatus(trailConStatus);
                if(trailConStatus.size()>0 && isTrialStatusCheck){
                    
                    trial.Trial_Status__c = OmniTrialContactTriggerHandlerHelper.checkTrialContactStatus(trailConStatus );
                    
                }else if (trailConStatus.size()== 1 && !trailConStatus.contains('New') && !trailConStatus.contains('Extended')){
                    List<String> statuslist = new List<String>();
                    statuslist.addAll(trailConStatus);
                    trial.Trial_Status__c = statuslist[0];                   
                }else if(trailConStatus.size()== 1 && trailConStatus.contains('Extended')) {
                    trial.Extended__c= True;
                }      
    }
    
    /**
* @description getMapOfTrialWIthTrialContacts
* @param trialConSobjtList
* @return mapTrialWithContacts
*/
    @testVisible
    private static Map<Id, List<Trial_Contact__c>> getMapOfTrialWIthTrialContacts(List<Trial_Contact__c> trialConSobjtList){
        Map<Id, List<Trial_Contact__c>>  mapTrialWithContacts = new Map<Id, List<Trial_Contact__c>> ();
        if(trialConSobjtList != null && trialConSobjtList.size()>0){
            for(Trial_Contact__c trialCont : trialConSobjtList){
                if(mapTrialWithContacts.containsKey(trialCont.Trials__c)) {
                    List<Trial_Contact__c> trialContList= mapTrialWithContacts.get(trialCont.Trials__c);
                    trialContList.add(trialCont);
                    mapTrialWithContacts.put(trialCont.Trials__c, trialContList);
                } 
                else 
                {
                    mapTrialWithContacts.put(trialCont.Trials__c, new List<Trial_Contact__c> { trialCont });
                }
                
            }
        }
        
        return mapTrialWithContacts;
    }   
    
    
}