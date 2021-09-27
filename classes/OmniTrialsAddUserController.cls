/**
* @description       : calling from LWC UI check for Add User button which is available on Trial Record page
* @author            : TCS Dev Team
* @group             : Omni Trials
* @last modified on  : 06-09-2021
* @last modified by  : 
* JIRA Number:  DPS-21098
* Modifications Log 
* Ver   Date         Author                               Modification
* 1.0   05-18-2021   TCS DEV Team                        Initial Version
**/
public with sharing class  OmniTrialsAddUserController{
    
    /**
    *  @description  : calling from LWC UI check if existing Trial avaialble on Opportunity.
    * if available, then store Trial, Trial Contacts and Trial Products records into Wrapper class
    *  @param     trialId
    *  @param     trialContIds
    *  @return    trialWrap
    */ 
    @AuraEnabled
    public static OmniTrialWrapper getExistingTrailDetailsAddUser(String trialId, List<Id> trialContIds){
        
        OmniTrialWrapper trialWrap = new OmniTrialWrapper ();
        
        Ent_Trial__c entTrial = getEntTrailSobjects(trialId);
        
        trialWrap.entTrial = enttrial;
        
        trialWrap = OmniTrialsDetailToWrapper.getOmniTrialProductsIntoWrapper(OmniTrialsDetailToWrapper.getTrailProductSobjects(entTrial.Id), trialWrap);
        
        List<Trial_Contact__c> trialContList = getTrailContactSobjects(enttrial.id,trialContIds);
        
        trialWrap = OmniTrialsDetailToWrapper.getOmniTrialContactsIntoWrapper(trialContList , trialWrap);
        
        return trialWrap;
    }
      
       /**
    *  @description  : Get Trial , Trial Contact
    *  @param     trialId
    *  @param     trialContIds
    *  @return    trialConts
    */
    @testVisible
    private static List<Trial_Contact__c> getTrailContactSobjects(String trialId, List<Id> trialContIds){
        
        List<Trial_Contact__c> trialConts = new List<Trial_Contact__c>();
        
        if(String.isNotBlank(trialId) && 
            Schema.sObjectType.Trial_Contact__c.isAccessible() &&
            Schema.sObjectType.Contact.isAccessible()  ){
            trialConts  = [Select Id, Name, Trials__c, External_Contact_Number__c, External_Contact_Number_Source__c, Contact__c, First_Name__c, 
                        Last_Name__c, Email__c, One_Pass_ID__c, Status__c, Online_Contact__c, COBALT_GUID__c, DATAROOM_GUID__c, Start_Date__c, 
                        End_Date__c, Account__c, Opportunity__c, Primary__c, Contact__r.Online_Contact_Designation__c, Contact__r.Name, 
                        Contact__r.Primary_Flag__c, Request_Type__c, Profile_Type__c
                        from Trial_Contact__c WHERE Trials__c = :trialId and Id in :trialContIds];
        }
        //System.debug('trialConts: '+trialConts);
        return trialConts;
    } 
      
     /**
    *  @description  : Get Trial 
    *  @param     trialId
    *  @return    trial
    */
    @testVisible
    private static Ent_Trial__c getEntTrailSobjects(String trialId){
        
        Ent_Trial__c trial = new Ent_Trial__c();
        
        if(String.isNotBlank(trialId) && 
            Schema.sObjectType.Ent_Trial__c.isAccessible() )
        {
            List<Ent_Trial__c> trials  = [select Id, Account__c, Opportunity__c, Trial_Start_Date__c, Trial_End_Date__c, Trial_Status__c, Number_of_Days__c
                                      from Ent_Trial__c where Id = :trialId ];
            if(!trials.isEmpty() && trials != null){
                trial = trials[0];
            }
        }
        //System.debug('trial: '+trial);
        return trial;
    }  
      /**
    *  @description  : saveTrialAndChildSobjectsAddUser
    *  @param     trialSobj
    *  @param     selectedProducts
    *  @param     selectedContacts
    *  @return    omniTrialWrap
    */
       @AuraEnabled
   public static OmniTrialWrapper  saveTrialAndChildSobjectsAddUser(Ent_Trial__c trialSobj, string selectedProducts, string selectedContacts){
         
          List<TrialProductWrapper> trialProducts = (List<TrialProductWrapper>) JSON.deserialize(selectedProducts, List<TrialProductWrapper>.class);
          List<TrialContactWrapper> trialContacts = (List<TrialContactWrapper>) JSON.deserialize(selectedContacts, List<TrialContactWrapper>.class);
          Map<string, TrialProductWrapper> trilPrdMap= new Map<string, TrialProductWrapper>();
           for(TrialProductWrapper productWrap : trialProducts){
               trilPrdMap.put(productWrap.trialPrdRecordId, productWrap);
           }
         
          Map<Id, Trial_Contact__c> trialContMap = createTrialContacts(trialSobj, trialContacts);
         
          
          set<id> newContactset = trialContMap.keyset();
         List<id> newContacts =new List<Id>(newContactset );
          createTrialProductContacts(trialSobj.Id, trilPrdMap.keyset(),newContacts);
          
          OmniTrialWrapper  omniTrialWrap = getExistingTrailDetailsAddUser(trialSobj.Id,newContacts);
         
          return omniTrialWrap;
         
      }
     
       /**
    *  @description  : createTrialContacts
    *  @param     trial
    *  @param     trialContacts
    *  @return    trial
    */
      @testVisible
      private static Map<Id, Trial_Contact__c> createTrialContacts(Ent_Trial__c  trial, List<TrialContactWrapper> trialContacts){
          
          //get primary Trial Contact
          Trial_Contact__c primaryTrialCont = getPrimaryTrialContact(trial.Id);
          
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
              trialCont.request_Type__c = cont.requestType;
              trialCont.Trials__c = trial.Id;
              TrialOLCOnePassByEmailRespWrap olcOnePass = cont.olcOnePass;
              if(olcOnePass != null){
                  trialCont.COBALT_GUID__c = olcOnePass.cobaltGUID ;
                  trialCont.DATAROOM_GUID__c = olcOnePass.dataRoomGUID ;
                  trialCont.One_Pass_ID__c = olcOnePass.onePassId ;
                  trialCont.External_Contact_Number__c = olcOnePass.externalContactNumber ;
                  trialCont.External_Contact_Number_Source__c = olcOnePass.externalContactNumberSource ;
                  trialCont.Profile_Type__c= olcOnePass.profileType;
              }
              
          if(primaryTrialCont != null){
                  trialCont.Invite_User_First_Name__c = primaryTrialCont.First_Name__c;
                  trialCont.Invite_User_Last_Name__c = primaryTrialCont.Last_Name__c;
              }
              trilContList.add(trialCont);
          }
          if(Trial_Contact__c.SObjectType.getDescribe().isCreateable() && Trial_Contact__c.SObjectType.getDescribe().isUpdateable()){
              insert trilContList;
          }
          Map<Id, Trial_Contact__c> trialContMap = new Map<Id, Trial_Contact__c>(trilContList);
          return trialContMap;
          
      }
      
      @testVisible
      private static Trial_Contact__c getPrimaryTrialContact(String trialId){
      
          Trial_Contact__c trialCont = new Trial_Contact__c();
          
          if(String.isNotBlank(trialId) && Schema.sObjectType.Trial_Contact__c.isAccessible() ){
          
              List<Trial_Contact__c> trialContList = [SELECT id,First_Name__c,Last_Name__c from Trial_Contact__c WHERE Trials__c = : trialId and Primary__c = true LIMIT 1];
              
              if(trialContList != null && trialContList.size() >0){
                  trialCont = trialContList[0];
              }
          }
          return trialCont;
      }
      
        @testVisible
      private static List<Id> createTrialProductContacts(Id trialId, Set<string> trialPrdIds, List<Id> trialContIds){
          
          map<String,id> trlProdContactsMap = new Map<string,id>();
          list<Trial_Product_Contact__c> trlProdContacts;
          if(String.isNotBlank(trialId) && Schema.sObjectType.Trial_Product_Contact__c.isAccessible() ){
               trlProdContacts = [select id,Trial_Contact__c,Trial_Product__c from Trial_Product_Contact__c where Trials__c = :trialId];
          }
          
          
          for(Trial_Product_Contact__c tprCon : trlProdContacts){
              trlProdContactsMap.put(String.valueof(tprCon.Trial_Contact__c) +'-'+ String.valueOf(tprCon.Trial_Product__c),tprCon.id );
          }
          List<Trial_Product_Contact__c> trialPrdContList = new List<Trial_Product_Contact__c>();
          for(string trialPrdId : trialPrdIds){
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
              Insert trialPrdContList;
              
          }
          return null;
          
      }
      
  }