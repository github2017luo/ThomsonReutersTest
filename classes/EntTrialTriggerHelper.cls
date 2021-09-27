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
*/

/**
* @description EntTrialTriggerHelper
* 
*/
public  without sharing class EntTrialTriggerHelper{
    
    //store Account, Opty, Lead Id with Active_Trial Or HasActiveTrial flag value
    public static Map<Id, Boolean> mapOptyLeadAccWIthActiveFlag;
    
    /**
* @description updateTrlStatusOnOpportunity
* @param entTrlMap
* 
*/
    public static void updateTrlStatusOnOpptAccLead(Map<Id, Ent_Trial__c> entTrlMap){
        
        mapOptyLeadAccWIthActiveFlag = new Map<Id,Boolean>();
        
        list<id> opportunityIds = new list<id>();
        list<id> accountIds = new list<id>();
        list<id> leadIds = new list<id>();
        //list<id> contactIds = new list<id>();
        for(Ent_Trial__c trl : entTrlMap.values()){
            opportunityIds.add(trl.Opportunity__c);
            accountIds.add(trl.account__c);
            leadIds.add(trl.Lead__c);
            //contactIds.add(trl.contact__c);
        }
        
        list<Ent_Trial__c> trials = new list<Ent_Trial__c>();
        if(Schema.sObjectType.Ent_Trial__c.isAccessible() && Schema.sObjectType.Account.isAccessible() && Schema.sObjectType.Contact.isAccessible()){
            trials = [select id,Trial_Status__c,Opportunity__c,account__c,Lead__c,Opportunity__r.Active_Trial__c,account__r.hasActiveTrial__c,Lead__r.hasActiveTrial__c
                      from Ent_Trial__c where 
                      //trial_status__c in  ('Rep Initiated','Accepted') and
                      Lead__c in :leadIds and
                      account__c in :accountIds and
                      Opportunity__c in  :opportunityIds];// and
                     // contact__c in :contactIds];
            
            
        }
        
        map<id, list<string>> parentTrlMap = new map<id,list<string>>();
        if(trials.size() >0){
            parentTrlMap  = iterateTrials(trials);
        }
        
        if(parentTrlMap.size() >0){
           EntTrialTriggerHandlerHelper.processRecords(parentTrlMap);
        }
        
        
    }
    
    @testVisible
    private static  map<id, list<string>> iterateTrials(list<Ent_Trial__c> trials){
        map<id, list<string>> parentTrlMap = new map<id,list<string>>();
        
        for(Ent_Trial__c trial : trials){
            if(trial.Account__c != null){
                parentTrlMap = prepareParentTrlMap(trial.Account__c,parentTrlMap,trial);
                mapOptyLeadAccWIthActiveFlag.put(trial.Account__c, trial.Account__r.hasActiveTrial__c);
            }
            
            if(trial.lead__c != null){
                parentTrlMap = prepareParentTrlMap(trial.lead__c,parentTrlMap,trial);
                mapOptyLeadAccWIthActiveFlag.put(trial.Lead__c, trial.Lead__r.hasActiveTrial__c);
            }
            if(trial.Opportunity__c != null){
                parentTrlMap = prepareParentTrlMap(trial.Opportunity__c,parentTrlMap,trial);
                mapOptyLeadAccWIthActiveFlag.put(trial.Opportunity__c, trial.Opportunity__r.Active_Trial__c);
            }  
            
             /*if(trial.contact__c != null){
                parentTrlMap = prepareParentTrlMap(trial.contact__c,parentTrlMap,trial);
                mapOptyLeadAccWIthActiveFlag.put(trial.contact__c, trial.contact__r.Has_Active_Trial__c);
            }  */
        }
        
        return parentTrlMap;
    }
    
    @testVisible
    private static map<id, list<string>> prepareParentTrlMap(string refId, map<id, list<string>> parentTrlMap,Ent_Trial__c entTrl){
        list<string> trlIds = new list<string>();
        if(parentTrlMap.containsKey(refId)){
            trlIds = parentTrlMap.get(refId);
        }
        if(entTrl.Trial_Status__c == 'Active'){
            trlIds.add(entTrl.id);
        }
        
        parentTrlMap.put(refId,trlIds);
        
        return parentTrlMap;
    }
    
  
    
     /**
* @description getAccountSobject
* @param sizeList
* @param recId
* @return acc
*/
    public static Account getAccountSobject(Integer sizeList, Id recId){
        account acc = null;
        Boolean hasActiveToBeChecked = false;
        if(sizelist > 0){ 
            hasActiveToBeChecked = true;
        }
        
        //checking on record whether it is true or false. It is already checked or unchecked, do not perform DML 
        Boolean hasActiveValueOnRecord = mapOptyLeadAccWIthActiveFlag.get(recId);
        
        if(hasActiveValueOnRecord != hasActiveToBeChecked){
            acc = new account();
            acc.id = recId;
            acc.hasActiveTrial__c = hasActiveToBeChecked;
        }
        return acc;
    }
    
     /**
* @description getOpportunitySobject
* @param sizeList
* @param recId
* @return opty
*/
    public static Opportunity getOpportunitySobject(Integer sizeList, Id recId){
        Opportunity opty = null;
        Boolean hasActiveToBeChecked = false;
        if(sizelist > 0){
            hasActiveToBeChecked = true;
        }
        
        //checking on record whether it is true or false. It is already checked or unchecked, do not perform DML 
        Boolean hasActiveValueOnRecord = mapOptyLeadAccWIthActiveFlag.get(recId);
        
        if(hasActiveValueOnRecord != hasActiveToBeChecked){
            opty = new Opportunity();
            opty.id = recId;
            opty.Active_Trial__c = hasActiveToBeChecked;
        }
        return opty;
    }
    
    
     /**
* @description getLeadSobject
* @param sizeList
* @param recId
* @return ld
*/
    public static Lead getLeadSobject(Integer sizeList, Id recId){
        Lead ld = null;
        Boolean hasActiveToBeChecked = false;
        if(sizelist > 0){
            hasActiveToBeChecked = true;
        }
        
        //checking on record whether it is true or false. It is already checked or unchecked, do not perform DML 
        Boolean hasActiveValueOnRecord = mapOptyLeadAccWIthActiveFlag.get(recId);
        
        if(hasActiveValueOnRecord != hasActiveToBeChecked){
            ld = new Lead();
            ld.id = recId;
            ld.hasActiveTrial__c = hasActiveToBeChecked;
        }
        return ld;
    }

   /**
* @description getContactSobject
* @param sizeList
* @param recId
* @return con
*/
   /* public static Contact getContactSobject(Integer sizeList, Id recId){
        Contact con = null;
        Boolean hasActiveToBeChecked = false;
        if(sizelist > 0){
            hasActiveToBeChecked = true;
        }
        
        //checking on record whether it is true or false. It is already checked or unchecked, do not perform DML 
        Boolean hasActiveValueOnRecord = mapOptyLeadAccWIthActiveFlag.get(recId);
        
        if(hasActiveValueOnRecord != hasActiveToBeChecked){
            con = new Contact();
            con.id = recId;
            con.Has_Active_Trial__c = hasActiveToBeChecked;
        }
        return con;
    }*/
   
     /**
* @description updateAccounts
* @param accounts
*/ 
    public static void updateAccounts(list<account> accounts){
        if(Account.SobjectType.getDescribe().isUpdateable() &&
           accounts.size()>0){
               update accounts;
           }
    }

    /**
* @description updateLeads
* @param leads
*/  
    public static void updateLeads(list<Lead> leads){
        if(Lead.SobjectType.getDescribe().isUpdateable() && 
           leads.size()>0){
               //system.debug('Leads--->'+leads);
               update leads;
           }
    }
    
     /**
* @description updateOpportunities
* @param opportunities
*/ 
    public static void updateOpportunities(list<opportunity> opportunities){
        if(opportunity.SobjectType.getDescribe().isUpdateable() && 
           opportunities.size()>0){
               update opportunities;
           }
    }
}