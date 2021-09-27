/**
* @description       : DPS-20640
* @author            : ChangeMeIn@UserSettingsUnder.SFDoc
* @group             : 
* @last modified on  : 06-14-2021
* @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
* Modifications Log 
* Ver   Date         Author                               Modification
* 1.0   06-14-2021   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
**/
public with sharing class OmniTrialsCreateSobject{
    
    /**
* @description saveTrials
* @param trialSobj
* @param selectedProducts
* @param selectedContacts
* @return omniTrialWrap
*/
    @AuraEnabled
    public static OmniTrialWrapper  saveTrialAndChildSobjects(Ent_Trial__c trialSobj, string selectedProducts, string selectedContacts){
         
        List<TrialProductWrapper> trialProducts = (List<TrialProductWrapper>) JSON.deserialize(selectedProducts, List<TrialProductWrapper>.class);
        List<TrialContactWrapper> trialContacts = (List<TrialContactWrapper>) JSON.deserialize(selectedContacts, List<TrialContactWrapper>.class);
        //trialSobj.Trial_Status__c = 'Draft';
        
        System.debug(LoggingLevel.DEBUG, '@@trialSobj: '+trialSobj);
        System.debug(LoggingLevel.DEBUG, '@@trialProducts : '+trialProducts );
        System.debug(LoggingLevel.DEBUG, '@@trialContacts : '+trialContacts );
        
        trialSobj.External_Account_Number__c = '';
        trialSobj.External_Account_Number_Source__c = '';
        trialSobj.profile_Type__c = '';
          
        //get Primary contact Profile Type and populate on Trial
        trialSobj.profile_Type__c = getPrimaryContactProfileType( trialContacts);
        trialSobj = OmniTrialsCreateSobjectHelper.populateExternalAccountNumSource(trialSobj, trialContacts);
        
        upsert trialSobj;
        
        Ent_Trial__c entTrial = getUpdatedTrialSobject(trialSobj.Id);
        
        set<id> existingContactIds = deletingExistingRec(entTrial,trialProducts,trialContacts);
        Map<Id, Trial_Product__c> trilPrdMap = createTrialProducts(entTrial, trialProducts);
        Map<Id, Trial_Contact__c> trialContMap = createTrialContacts(entTrial, trialContacts);
        
        set<id> newContacts = new set<Id>();
        newContacts = trialContMap.keyset();
        newContacts.removeAll(existingContactIds);
        // List<id> trialPrdContIds= createTrialProductContacts(trialSobj.Id, trilPrdMap.keyset(),newContacts);
        createTrialProductContacts(trialSobj.Id, trilPrdMap.keyset(),newContacts);
        
        OmniTrialWrapper  omniTrialWrap = OmniTrialsDetailToWrapper.getExistingTrailDetails(trialSobj.Id, trialSobj.Opportunity__c,trialSobj.Trial_status__c);
        
        
        return omniTrialWrap;
        
    }
    
    /**
    * @description getPrimaryContactProfileType
    * @param trialContacts
    * @return profileType 
    */
    public static string getPrimaryContactProfileType(List<TrialContactWrapper> trialContacts){
        
        String profileType = '';
        for(TrialContactWrapper trialContWrap : trialContacts){
            if(trialContWrap.isPrimaySelectedFromUI){
               profileType = trialContWrap.olcOnePass.profileType; 
            }
        }
        
        return profileType;
    }
    
    /**
* @description deletingExistingRec
* @param trialSobj
* @param trialProducts
* @param trialContacts
* @return
*/
    private static set<id> deletingExistingRec(Ent_Trial__c trialSobj,List<TrialProductWrapper> trialProducts,List<TrialContactWrapper> trialContacts){
        
        Map<Id,trial_Product__c> trlPrdosMap = NEW  Map<Id,trial_Product__c>();
        Map<Id,trial_Contact__c> trlConsMap = NEW  Map<Id,trial_Contact__c>();
        
        set<id> existingContactIds = new set<id>();
        contactAndProdsWrapper wrap = fetchingRecords(trialSobj);
        trlPrdosMap = wrap.trlPrdosMap;
        trlConsMap = wrap.trlConsMap;
        
        for(TrialProductWrapper trp : trialProducts){
            if(trp.trialPrdRecordId != null && trlPrdosMap.containsKey(trp.trialPrdRecordId)){
                trlPrdosMap.remove(trp.trialPrdRecordId);
            }
        }
        
        for(TrialContactWrapper trc : trialContacts){
            if(trc.trialContRecordId != null && trlConsMap.containsKey(trc.trialContRecordId)){
                trlConsMap.remove(trc.trialContRecordId);
            }
        }
        
        existingContactIds = trlConsMap.Keyset();
        
        if(trlPrdosMap.values() != null){
            delete trlPrdosMap.values();
        }
        if(trlConsMap.values() != null){
            delete trlConsMap.values();
        }
        
        return existingContactIds;
        
    }
    
    private static contactAndProdsWrapper fetchingRecords(Ent_Trial__c trialSobj){
        contactAndProdsWrapper wp = new contactAndProdsWrapper();
        wp.trlPrdosMap = NEW  Map<Id,trial_Product__c>();
        wp.trlConsMap = NEW  Map<Id,trial_Contact__c>();
        if(Trial_Product__c.SObjectType.getDescribe().isAccessible()&&schema.sobjectType.Trial_Product__c.isAccessible()){
            wp.trlPrdosMap = new Map<Id, trial_Product__c>([select id,Trial__c from  trial_Product__c where Trial__c = :trialSobj.id]);
            wp.trlConsMap = new  Map<Id,trial_Contact__c>([select id,Trials__c from  trial_Contact__c where Trials__c = :trialSobj.id]);
        } 
        return wp;
    }
    
    
    /**
* @description saveTrials
* @param trial
* @param trialProducts
* @return trilPrdMap

*/
    
    @testVisible
    private static Map<Id, Trial_Product__c>  createTrialProducts(Ent_Trial__c  trial, List<TrialProductWrapper> trialProducts){
        
        List<Trial_Product__c> trilPrdList = new List<Trial_Product__c>();
        for(TrialProductWrapper trialPrdWrap : trialProducts){
            Trial_Product__c trilPrd = new Trial_Product__c();
            trilPrd.Product_Name__c = trialPrdWrap.trialPrdId ;
            trilPrd.Trial__c = trial.Id ;
            trilPrd.Id = trialPrdWrap.trialPrdRecordId ;
            
            trilPrd.Segment__c = trialPrdWrap.segmentType;
            trilPrd.Base_Material_Number__c = trialPrdWrap.baseMaterialNumber;
            trilPrd.Relationship_Type__c = trialPrdWrap.relationshipType;
            
            trilPrdList.add(trilPrd);
        }
        if(Trial_Product__c.SObjectType.getDescribe().isCreateable() && Trial_Product__c.SObjectType.getDescribe().isUpdateable()){
            upsert trilPrdList;
        }
        Map<Id, Trial_Product__c> trilPrdMap= new Map<Id, Trial_Product__c>(trilPrdList);
        return trilPrdMap;
        
    }
    
    
    
    /**
* @description createTrialContacts
* @param trial
* @param trialContacts
* @return
*/
    
    @testVisible
    private static Map<Id, Trial_Contact__c> createTrialContacts(Ent_Trial__c  trial, List<TrialContactWrapper> trialContacts){
        
        List<Trial_Contact__c> trilContList = new List<Trial_Contact__c>();
        for(TrialContactWrapper cont : trialContacts){
            Trial_Contact__c trialCont = new Trial_Contact__c();
            trialCont.Id  = cont.trialContRecordId;
            trialCont.Email__c = cont.email ;
            trialCont.End_Date__c = trial.Trial_End_Date__c;
            trialCont.First_Name__c = cont.firstName ;
            trialCont.Last_Name__c = cont.lastName ;
            trialCont.Online_Contact__c = cont.onlineContact ;
            trialCont.Contact__c = cont.contactId ;
            trialCont.Primary__c = cont.isPrimaySelectedFromUI ;
            trialCont.Start_Date__c = trial.Trial_Start_Date__c ;
            trialCont.Status__c = cont.trialStatus;
            trialCont.request_Type__c = cont.requestType;//this value will be populated from LWC
            trialCont.Trials__c = trial.Id;
            
            //trialCont.Unique_Name__c = cont.email+system.now();
            TrialOLCOnePassByEmailRespWrap olcOnePass = cont.olcOnePass;
            if(olcOnePass != null){
                trialCont.COBALT_GUID__c = olcOnePass.cobaltGUID ;
                trialCont.DATAROOM_GUID__c = olcOnePass.dataRoomGUID ;
                trialCont.One_Pass_ID__c = olcOnePass.onePassId ;
                trialCont.One_Pass_User_Name__c = olcOnePass.onePassUserName ;
                trialCont.External_Contact_Number__c = olcOnePass.externalContactNumber ;
                trialCont.External_Contact_Number_Source__c = olcOnePass.externalContactNumberSource ;
                trialCont.Profile_Type__c= olcOnePass.profileType;
            }
            
            trilContList.add(trialCont);
        }
        if(Trial_Contact__c.SObjectType.getDescribe().isCreateable() && Trial_Contact__c.SObjectType.getDescribe().isUpdateable()){
            upsert trilContList;
        }
        Map<Id, Trial_Contact__c> trialContMap = new Map<Id, Trial_Contact__c>(trilContList);
        return trialContMap;
        
    }
    
    
    
    /**

* @description saveTrials
* @param trialId
* @param trialPrdIds
* @param trialContIds
* @return

*/
    
    @testVisible
    private static List<Id> createTrialProductContacts(Id trialId, Set<Id> trialPrdIds, Set<Id> trialContIds){
        
        map<String,id> trlProdContactsMap = new Map<string,id>();
        list<Trial_Product_Contact__c> trlProdContacts = [select id,Trial_Contact__c,Trial_Product__c from Trial_Product_Contact__c where Trials__c = :trialId];
        for(Trial_Product_Contact__c tprCon : trlProdContacts){
            trlProdContactsMap.put(String.valueof(tprCon.Trial_Contact__c) +'-'+ String.valueOf(tprCon.Trial_Product__c),tprCon.id );
        }
        List<Trial_Product_Contact__c> trialPrdContList = new List<Trial_Product_Contact__c>();
        for(Id trialPrdId : trialPrdIds){
            for(Id trialContId : trialContIds){
                Trial_Product_Contact__c trialPrdCont= new Trial_Product_Contact__c();
                trialPrdCont.Trial_Contact__c = trialContId;
                trialPrdCont.Trial_Product__c = trialPrdId;
                trialPrdCont.Trials__c = trialId;
                trialPrdCont.id = trlProdContactsMap.get(trialContId+'-'+trialPrdId);
                trialPrdContList.add(trialPrdCont);
            }       
        }
        if(Trial_Product_Contact__c.SObjectType.getDescribe().isCreateable() && Trial_Product_Contact__c.SObjectType.getDescribe().isUpdateable()){
            Upsert trialPrdContList;
            
        }
        return null;
        
    }
    
    /**
    * @description       : getUpdatedTrialSobject
    * @param trialid
    * @return entTrial
    */
    private static Ent_Trial__c getUpdatedTrialSobject(Id trialid){
        
        Ent_Trial__c entTrial = new Ent_Trial__c();
        if(Schema.sObjectType.Ent_Trial__c.isAccessible()){
            entTrial = [Select id,Trial_Start_Date__c,Number_of_Days__c,
                    Trial_End_Date__c, Account__c, Account__r.BU_Segment__c, Opportunity__c,
                    Trial_Status__c,Profile_Type__c from Ent_Trial__c where Id =: trialId];
        }
        return entTrial;
    }
    
    /**
     * @description ContactAndProdsWrapper
     */

    public class ContactAndProdsWrapper{
        /**
         * @description  trlPrdosMap
         */
        public  Map<Id,trial_Product__c> trlPrdosMap{set;get;}
         /**
         * @description  trlConsMap
         */
         public  Map<Id,trial_Contact__c> trlConsMap{set;get;}
    }
    
    
}