/**
 * CHANGE HISTORY
 * =============================================================================
 * Name                : ODTTrialTriggerHandler
 * Description         : This class is serving as helper class for trigger 'ODTTrialTrigger'. The main purpose is to create 
 *                       assets and contact entitlements for a Sales rep initiated trial which is in accepted status.
 * Created Date        : 8/13/2018 
 * Author              : Ameeta Antonio
 * Modification History: Modified by Ameeta Antonio on 26/10/2018
 *                       DLT-12944 :Initiate Trial From opportunity
 * =============================================================================
 */ 
public without sharing class ODTTrialTriggerHandler {
    
    static LIST<Asset> assetList;
    static LIST<LCRM_Contact_Entitlement__c> contEntitlementList;
    static Set<Id> contactIds;
    static List<Opportunity_Trial__c> oppTrialToUpdate;
    static LIST<Invite_Colleagues__c> icList = new LIST<Invite_Colleagues__c>();
    static LIST<Invite_Colleagues__c> updateICList =new LIST<Invite_Colleagues__c>();
    public static boolean checkexecuted=true;
    //static List<Opportunity> oppTrialBeforeUpdate;
    
    //helper method to check if Trial Status is accepted and Trial journey is 'Rep Initiated Journey' based on which assets are created
    public static void handleODTTrialAfterUpdate(List<Trial__c> listOfTrials, Map<Id,Trial__c> oldMapTrials){
        System.debug('@@@Triallist'+listOfTrials);
        Set<ID> trialIdlist = new Set<ID>();
        Set<ID> trialIdlistForOpp = new Set<ID>();
        for(Trial__c newTrial : listOfTrials){
            if(oldMapTrials.containsKey(newTrial.Id)){
                Trial__c oldTrial = oldMapTrials.get(newTrial.Id);
                if((oldTrial.Trial_Status__c != 'Accepted' && newTrial.Trial_Status__c =='Accepted') && (newTrial.Trial_Journey__c =='Rep Initiated Journey' || newTrial.Trial_Journey__c =='ECJ')){
                    trialIdlist.add(newTrial.Id);
                }
               if(oldTrial.Trial_Status__c != 'Accepted' && newTrial.Trial_Status__c =='Accepted'){
                    trialIdlistForOpp.add(newTrial.Id);
                }
            }
        }
        System.debug('@@@Trial'+trialIdlist);
        if(!trialIdlist.isEmpty())
        createAssetsForRepInitiatedTrial(trialIdlist);
        
        if(!trialIdlistForOpp.isEmpty())
            updateSSDOnOpportunity(trialIdlistForOpp);
    }
    
    //create Assets when Sales Rep Initiated Trial is Accepted
    public static void createAssetsForRepInitiatedTrial(Set<ID> trialList){
        assetList = new LIST<Asset>();
        
        LIST<Trial__c> trialDetails = new LIST<Trial__c>([SELECT ID, Name, Contact_LeadId__c,Trial_Start_Date__c, Trial_End_Date__c, Source_System_Detail__c,Source_System_Detail__r.Account_Name__c,(SELECT Id,Name,LCRM_Product_Name__c,LCRM_Product_Name__r.Duration__c,LCRM_Product_Name__r.Name FROM Recommended_Products__r),(Select id,Contact_Id_from_Lead__c,Name,Trial_Status__c,Trial__c from Invite_Colleagues__r where Trial_Status__c ='Accepted'),(Select Id, is_Trial_Asset__c,Trial_Details__c FROM Assets__r) FROM Trial__c WHERE ID IN:trialList]);
        
        if(!trialDetails.isEmpty()){
            for(Trial__c t : trialDetails){
                
                if(t.Assets__r.isEmpty()){
                if(!t.Recommended_Products__r.isEmpty()){
                    
                    for(LCRM_Recommended_Product__c lp: t.Recommended_Products__r){
                        
                        assetList.add(new Asset(Name=lp.LCRM_Product_Name__r.Name, Accountid=t.Source_System_Detail__r.Account_Name__c, Product2id=lp.LCRM_Product_Name__c, Status='Active', InstallDate=t.Trial_Start_Date__c, Source_System_Detail__c=t.Source_System_Detail__c,LCRM_Asset_Type__c='On Demand Trial', Trial_Details__c= t.id, is_Trial_Asset__c=true));
                    }
                }
               }
            }
        }
        System.debug('@@@Asset'+assetList);
        if(!assetList.isEmpty()){
            List<Database.SaveResult> result= database.insert(assetList, false);
            createContactEntitlementsForRepInitiatedTrial(assetList, trialDetails);
       
        }
         
    }
    
    //DLT-12944 :Update Account SSD on Opportunity when Trial is initiatedfrom opportunity not having SSD.
    public static void updateSSDOnOpportunity(Set<ID> trialList){
        System.debug('updateSSDOnOpportunity'+trialList);
        oppTrialToUpdate = new List<Opportunity_Trial__c>();
        LIST<Opportunity> tobeUpdateOpty = new LIST<Opportunity>();
        List<Opportunity_Trial__c> oppTrial = new List<Opportunity_Trial__c>([Select Id,Opportunity__c, Trial__c,Opportunity__r.Source_System_Detail__c,Trial__r.Source_System_Detail__c FROM Opportunity_Trial__c WHERE Trial__c IN: trialList AND Opportunity__r.Source_System_Detail__c = null AND Trial__r.Source_System_Detail__c != null ]);
        System.debug('oppTrial'+oppTrial);
        
        for(Opportunity_Trial__c opp : oppTrial){
           //Opportunity oppty = [Select ID, Source_System_Detail__c From Opportunity where id =: opp.Opportunity__c];
           if(opp.Trial__r.Source_System_Detail__c != null)
               tobeUpdateOpty.add(new opportunity(id=opp.Opportunity__c, Source_System_Detail__c = opp.Trial__r.Source_System_Detail__c));
           
         /*  opp.Opportunity__r.Source_System_Detail__c = opp.Trial__r.Source_System_Detail__c;
           System.debug('opp.Trial__r.Source_System_Detail__c===='+opp.Trial__r.Source_System_Detail__c);
           oppTrialToUpdate.add(opp);
           System.debug('oppTrialToUpdate-----'+oppTrialToUpdate);
           */
        }
        if(tobeUpdateOpty.size() > 0){
            try{
                List<Database.SaveResult> result= database.update(tobeUpdateOpty, false);
                            System.debug('Result----'+result);

            }catch(Exception e){
                System.debug('exception e----'+e);
            } 
               
        }
            
    }
    
    //create Contact Entitlements when Sales Rep Initiated Trial is Accepted
    public static void createContactEntitlementsForRepInitiatedTrial(List<Asset> assetDetails, LIST<Trial__c> trialList){
        contEntitlementList = new LIST<LCRM_Contact_Entitlement__c>();
        
        for(Trial__c tr : trialList){
            if(!tr.Invite_Colleagues__r.isEmpty()){
                for(Asset a : assetDetails){
                    if(a.Trial_Details__c == tr.id){
                        for(Invite_Colleagues__c inv :tr.Invite_Colleagues__r){
                            contEntitlementList.add(new LCRM_Contact_Entitlement__c(Name=a.Name+' Entitlement',LCRM_Asset__c=a.Id, Trial_Status__c='Trial Started',LCRM_Access_Start_Date__c=tr.Trial_Start_Date__c, LCRM_Access_End_Date__c=tr.Trial_End_Date__c, Invited_Colleagues__c = inv.id));
                        }
                    }
                }
            }
        }
        System.debug('@@@CE :'+contEntitlementList);
        if(!contEntitlementList.isEmpty()){
           List<Database.SaveResult> contResult = Database.insert(contEntitlementList, false);
        }
    }
    
    //DLT-12322 Starts: Added by Harshitha --->Method to update IC record of Primary user when the corresponding Trial record is updated
    public static  boolean updateIcPrimaryUser(List<Trial__c> listOfNewTrials, Map<Id,Trial__c> mapOfOldTrials){
            system.debug('before update');
            icList=[SELECT id, Primary_User__c, Trial__c, Trial_Status__c from Invite_Colleagues__c WHERE Primary_User__c=:true AND Trial__c IN:listOfNewTrials];
            for(Trial__c newTrial:listOfNewTrials){
                System.debug('new trial' +newTrial);
                if(mapOfOldTrials.containsKey(newTrial.Id)){
                    Trial__c oldtrial=mapOfOldTrials.get(newTrial.Id);
                    for(Invite_Colleagues__c ic:icList){
                        system.debug('ic' +ic);
                        if(ic.Trial__c==newTrial.id){
                            System.debug('@@@138');
                            ic.Trial_Status__c=newTrial.Trial_Status__c;
                            if(newTrial.Trial_Start_Date__c!=null && newTrial.Trial_End_Date__c!=null){
                                ic.Trial_Start_Date__c=newTrial.Trial_Start_Date__c;
                                ic.Trial_End_Date__c=newTrial.Trial_End_Date__c;
                            }
                            updateICList.add(ic);
                        }
                        //Database.SaveResult updateIC=Database.update(ic, false);
                        //system.debug('after update' +updateIC);
                    }
                    if(updateICList.size()>0){
                        try{
                            LIST<Database.SaveResult> updatedIC=database.update( updateICList, false);
                            checkexecuted=false;
                        }catch(Exception e){
                          System.debug('exception e' +e);
                       } 
                   }
                }
            }
        return checkexecuted;
    }
    //DLT-12322 Ends
    
    public static boolean recordTypeBool = true;
    
    public static void processRecordTypes(LIST<Trial__c> allTrials){
    
        for(Trial__c t: allTrials){
            if(t.Trial_Status__c != null){
                if(t.Trial_Status__c == 'Rep Initiated' ||  t.Trial_Status__c == 'Invited' ||  t.Trial_Status__c == 'Bounceback' || t.Trial_Status__c == 'Timed-out' )
                    t.RecordTypeID = Schema.SObjectType.Trial__c.getRecordTypeInfosByName().get('Invited Trials').getRecordTypeId();
                else  if(t.Trial_Status__c == 'Accepted')
                    t.RecordTypeID = Schema.SObjectType.Trial__c.getRecordTypeInfosByName().get('Accepted Trials').getRecordTypeId();
                else  if(t.Trial_Status__c == 'Expired'|| t.Trial_Status__c == 'Ended' )
                    t.RecordTypeID = Schema.SObjectType.Trial__c.getRecordTypeInfosByName().get('Expired Trials').getRecordTypeId();
                else  if(t.Trial_Status__c == 'Entitlement Error' )
                    t.RecordTypeID = Schema.SObjectType.Trial__c.getRecordTypeInfosByName().get('NCJ Entitlement').getRecordTypeId();            
            }     
        }
    
        recordTypeBool = false;
    
    }
    
    
}