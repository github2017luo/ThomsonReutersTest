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
* @description OmniTrialProductContactTriggerHandler
* 
*/

public without sharing class OmniTrialProductContactTriggerHandler {
    /**
*  @description isRecursive Flag
*/
    public static boolean isRecursive = false;
    
    /**
* @description onAfterInsertUpdateTrigger Context
* @param newTrialProductcontact
* 
*/
    
    public static void onAfterInsertUpdateTrigger(List<Trial_Product_Contact__c> newTrialProductcontact){
        
        
        if(!OmniTrialProductContactTriggerHandler.isRecursive && Trigger.isAfter && Trigger.isupdate){
            
            OmniTrialProductContactTriggerHandler.isRecursive = true;
            processTrialContact(newTrialProductcontact);
            
        }          
    } 
    
    /**
* @description processTrialContact 
* @param newTrialProductcontact
* 
*/
    
    public static void processTrialContact(List<Trial_Product_Contact__c> newTrialProductcontact )
    {
        set<id>  trailsIdlist = new set<id>();
        
        for(Trial_Product_Contact__c tpc : newTrialProductcontact){
            trailsIdlist.add (tpc.Trials__c);            
        }
        
        
        List<Trial_Contact__c> trialConlist = OmniTrialProductContactTrgrHandlerHelper.fetchTrialContactRecords(trailsIdlist);
        List<Trial_Contact__c> trialConupdate = new List<Trial_Contact__c>();
        if(trialConlist !=null && trialConlist.size()>0 ){
            Map<id,Trial_Contact__c>trialConmap = new Map<id,Trial_Contact__c>(trialConlist);
            
            List<Trial_Product_Contact__c> trialProContactlist = OmniTrialProductContactTrgrHandlerHelper.fetchTrialProductContactRecords(trialConmap);
            
            //Creating map with trial contact with its trailproductcontact
            
            Map<Id, List<Trial_Product_Contact__c>>  mapTrialConWithTrialProContacts = mapTrialConWithTrlProCon(trialProContactlist);
            
            
            //create a map  trailcont with Status list for processing
            
            Map<id,Set<String>> statusMap = createTrialConWithStatusForProcess(trialConlist,mapTrialConWithTrialProContacts);
            
            // Processing the status of Trialcontact based on TrialProductContact
            trialConupdate = trialContactTobeUpdated(trialConlist,statusMap);
        }        
        //updating the trial contact record
        OmniTrialProductContactTrgrHandlerHelper.updateTrialContactStatus(trialConupdate);
        
    }
    
    /**
* @description mapTrialConWithTrlProCon
* @param trialProContactlist
* @return mapTrialConWithTrialProContacts 
* 
*/
    
    public static Map<Id, List<Trial_Product_Contact__c>> mapTrialConWithTrlProCon(List<Trial_Product_Contact__c> trialProContactlist){
        Map<Id, List<Trial_Product_Contact__c>>  mapTrialConWithTrialProContacts = new Map<Id, List<Trial_Product_Contact__c>> ();
        
        for(Trial_Product_Contact__c tpc : trialProContactlist){
            if(mapTrialConWithTrialProContacts.containsKey(tpc.Trial_Contact__c)) {
                List<Trial_Product_Contact__c> trialContList= mapTrialConWithTrialProContacts.get(tpc.Trial_Contact__c);
                trialContList.add(tpc);
                mapTrialConWithTrialProContacts.put(tpc.Trial_Contact__c, trialContList);
            }else 
            {
                mapTrialConWithTrialProContacts.put(tpc.Trial_Contact__c, new List<Trial_Product_Contact__c> { tpc });
            }            
        }
        return mapTrialConWithTrialProContacts;
    }  
    
    
    /**
* @description createTrialConWithStatusForProcess
* @param trialConlist
* @param mapTrialConWithTrialProContacts
* @return statusMap 
* 
*/
    
    
    public static Map<id,Set<String>> createTrialConWithStatusForProcess(List<Trial_Contact__c> trialConlist,Map<Id, List<Trial_Product_Contact__c>>  mapTrialConWithTrialProContacts){
        Map<id,Set<String>> statusMap = new Map<id,Set<String>>();
        
        //create a map  trailcont with Status list for processing        
        for(Trial_Contact__c trialcon : trialConlist ){
            
            List<Trial_Product_Contact__c> trailProconList = mapTrialConWithTrialProContacts.get(trialcon.id);
            
            for(Trial_Product_Contact__c trailProcon  :trailProconList){
                
                String status='';
                if(trailProcon.Entitlement_Status__c != '' ||trailProcon.Entitlement_Status__c != null ){
                    status = checkTrialProConStatus(trailProcon);
                }                
                if(statusMap.containsKey(trailProcon.Trial_Contact__c)) {
                    Set<String> statusTrlProconList= statusMap.get(trailProcon.Trial_Contact__c);
                    statusTrlProconList.add(status);
                    statusMap.put(trailProcon.Trial_Contact__c, statusTrlProconList);
                }else 
                {
                    statusMap.put(trailProcon.Trial_Contact__c, new Set<String> { status });
                }
                
            }            
        }        
        return statusMap;
    }
    
    /**
* @description trialContactTobeUpdated
* @param trialConlist
* @param statusMap
* @return trialConlist 
* 
*/
    
    
    public static List<Trial_Contact__c> trialContactTobeUpdated(List<Trial_Contact__c> trialConlist,Map<id,Set<String>> statusMap){
        
        for(Trial_Contact__c trialCon : trialConlist ){            
            Set<String> updateTrailProconList = statusMap.get(trialCon.id);            
            
            if(updateTrailProconList.contains('Entitlement Error')){
                trialCon.Status__c = 'Entitlement Error';                
            }else if(updateTrailProconList.size()== 1 && (updateTrailProconList.contains('Ended') || updateTrailProconList.contains('Active') ||updateTrailProconList.contains('Extended'))){
                trialCon.Status__c = OmniTrialProductContactTrgrHandlerHelper.setTrialConStatus(updateTrailProconList);
            }
            
        }
        return trialConlist;
    }
        
    
    /**
* @description checkTrialProConStatus
* @param trailProcon
* @return status 
* 
*/   
    
    public static String checkTrialProConStatus(Trial_Product_Contact__c trailProcon){
        String status ='';        
        if(trailProcon.Entitlement_Status__c == 'COMPLETE'){
            status = OmniTrialProductContactTrgrHandlerHelper.checkCompleteStatusOfTrialProCon(trailProcon);
        }else if(trailProcon.Entitlement_Status__c != null && trailProcon.Entitlement_Status__c != '' && trailProcon.Entitlement_Status__c != 'COMPLETE'){
            status='Entitlement Error';            
        }
        return status;
    }
    
    
    
   
    
}