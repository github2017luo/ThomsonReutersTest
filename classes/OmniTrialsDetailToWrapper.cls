/**
* @description       : calling from LWC UI check if existing Trial avaialble on Opportunity.
* if available, then store Trial, Trial Contacts and Trial Products records into Wrapper class
* @author            : TCS Dev Team
* @group             : Omni Trials
* @last modified on  : 06-09-2021
* @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
* Modifications Log 
* Ver   Date         Author                               Modification
* 1.0   05-18-2021   TCS DEV Team                        Initial Version
**/
public with sharing class  OmniTrialsDetailToWrapper{
    
    /**
    *  @description  : calling from LWC UI check if existing Trial avaialble on Opportunity.
    * if available, then store Trial, Trial Contacts and Trial Products records into Wrapper class
    *  @param     trialId
    *  @param     optyId
    *  @param     trialStatus 
    *  @return    trialWrap
    */ 
    @AuraEnabled
    public static OmniTrialWrapper getExistingTrailDetails(String trialId, String optyId, String trialStatus){
        
        OmniTrialWrapper trialWrap = new OmniTrialWrapper ();
        Ent_Trial__c entTrial = getEntTrailSobjects(trialId, optyId, trialStatus);//getTrailSobjects(optyId);
        
        System.debug(LoggingLevel.DEBUG, 'entTrial : '+entTrial );
        
        if(entTrial != null){
            System.debug(LoggingLevel.DEBUG, 'entTrial Not null: '+entTrial );
            trialWrap = getOmniTrialWrapperList(entTrial, trialWrap ,trialStatus);
        }
        else{
            Ent_Trial__C ent = new Ent_Trial__c ();
            ent.Trial_Start_Date__c = system.today(); 
            trialWrap.entTrial = ent;
        }
        
        System.debug(LoggingLevel.DEBUG, 'trialWrap : '+trialWrap);
  
        return trialWrap;
    }
    
    /**
    *  @description  : Get Trial , Trial Contact, Trail Products - used in OmniTrialsAddUserController class
    *  @param     entTrial
    *  @param     trialWrap
    *  @param     trialStatus
    *  @return    trialWrap
    */
    public static OmniTrialWrapper getOmniTrialWrapperList(Ent_Trial__c entTrial, OmniTrialWrapper trialWrap, string trialStatus){
        
        
            trialWrap = getOmniTrialIntoWrapper(entTrial, trialWrap);
            
            trialWrap = getOmniTrialProductsIntoWrapper(getTrailProductSobjects(entTrial.Id), trialWrap);
            
            trialWrap = getOmniTrialContactsIntoWrapper(getTrailContactSobjects(entTrial.Id, trialStatus), trialWrap);
        
        
        return trialWrap;
    }
    
    /**
    *  @description  : Get Trial , Trial Contact, Trail Products
    *  @param     trailConts
    *  @param     trialWrap
    *  @return    trialWrap
    */
    public static OmniTrialWrapper getOmniTrialContactsIntoWrapper(List<Trial_Contact__c> trailConts, OmniTrialWrapper trialWrap){
        List<TrialContactWrapper> trialConts = new List<TrialContactWrapper> ();
        for(Trial_Contact__c trailCont: trailConts){
        
            TrialContactWrapper contactWrap = new TrialContactWrapper();
            contactWrap.trialContRecordId = trailCont.Id;
            contactWrap.contactId = trailCont.Contact__c; 
            contactWrap.email = trailCont.Email__c; 
            contactWrap.firstName = trailCont.First_Name__c; 
            contactWrap.lastName = trailCont.Last_Name__c; 
            contactWrap.onlineContact = trailCont.Online_Contact__c; 
            contactWrap.isPrimaySelectedFromUI = trailCont.Primary__c;
            contactWrap.onlineContactDesignation = trailCont.Contact__r.Online_Contact_Designation__c;
            contactWrap.gsiPrimaryFlag = trailCont.Contact__r.Primary_Flag__c ;
            contactWrap.fullName = trailCont.Contact__r.Name;
            contactWrap.trialId = trailCont.Trials__c;
            contactWrap.trialStatus= trailCont.Status__c;
            contactWrap.requestType= trailCont.request_Type__c;
            
            TrialOLCOnePassByEmailRespWrap olcOnepassRes =new  TrialOLCOnePassByEmailRespWrap ();
            olcOnepassRes.profileType= trailCont.Profile_Type__c;
            contactWrap.olcOnePass = olcOnepassRes;
            
            if(trailCont.Primary__c){
                trialWrap.primaryContactEmail = trailCont.Email__c;//to display on Radio button
                trialWrap.primaryContactName = trailCont.First_Name__c + ' '+trailCont.Last_Name__c;//to display on Radio button
            }
            trialConts.add(contactWrap);
        }
        
        trialWrap.trialContacts = trialConts;
        
        return trialWrap;
    }
    
    /**
    *  @description  : Get Trial , Trial Contact, Trail Products
    *  @param     trailPrds
    *  @param trialWrap
    *  @return    trialWrap
    */
    public static OmniTrialWrapper getOmniTrialProductsIntoWrapper(List<Trial_Product__c> trailPrds, OmniTrialWrapper trialWrap){
        
        List<TrialProductWrapper> trialProds = new List<TrialProductWrapper> ();
        for(Trial_Product__c trailPrd: trailPrds){
        
            TrialProductWrapper trialPrdWrap = new TrialProductWrapper();
            
            trialPrdWrap.trialPrdId = trailPrd.Product_Name__c; //Product 2 Id
            trialPrdWrap.trialPrdRecordId = trailPrd.id;
            trialPrdWrap.trialId = trailPrd.Trial__c;
            
            trialPrdWrap.productCode = trailPrd.Material_Number__c;
            trialPrdWrap.bundleType = trailPrd.Product_Name__r.Bundle_Type__c ;
            trialPrdWrap.materialType= trailPrd.Product_Name__r.Material_Type__c;
            trialPrdWrap.productName = trailPrd.Product_Name__r.Name;
            trialPrdWrap.baseMaterialName = trailPrd.Base_Material_Number__r.Name;
            trialPrdWrap.baseMaterialNumber= trailPrd.Base_Material_Number__c;
            trialPrdWrap.relationshipType= trailPrd.Relationship_Type__c;
            trialPrdWrap.segmentType= trailPrd.Segment__c;
            
            trialProds.add(trialPrdwrap);
        }
        trialWrap.trialProducts = trialProds;
        return trialWrap;
    }
    
    /**
    *  @description  : Get Trial , Trial Contact, Trail Products
    *  @param     trial
    *  @param     trialWrap
    *  @return    trialWrap
    */
    public static OmniTrialWrapper getOmniTrialIntoWrapper(Ent_Trial__c trial, OmniTrialWrapper trialWrap){
        trialWrap.entTrial = trial;
        
        if(trial.trial_status__c =='Draft' || trial.trial_status__c == null){
            trialWrap.entTrial.Trial_Start_Date__c = system.today();
        }
        return trialWrap;
    }
    
     /**
    *  @description  : Get Trial 
    *  @param     trialId
    *  @param     optyId
    *  @param     trialStatus
    *  @return    trial
    */
    @testVisible
    private static Ent_Trial__c getEntTrailSobjects(String trialId, String optyId, String trialStatus){
        
        Ent_Trial__c trial = new Ent_Trial__c();
        
        if(String.isNotBlank(trialId) && Schema.sObjectType.Ent_Trial__c.isAccessible() )
        {
            List<Ent_Trial__c> trials  = [select Id, Account__c, Opportunity__c, Trial_Start_Date__c, Trial_End_Date__c, Trial_Status__c,
                                        profile_type__c,Number_of_Days__c,Extended__c
                                      from Ent_Trial__c where Id = :trialId limit 1];
            if(!trials.isEmpty() && trials != null){
                trial = trials[0];
            }
        }//used below query to fetch Draft Trial
        else if(String.isNotBlank(optyId) && Schema.sObjectType.Ent_Trial__c.isAccessible() )
        {
            List<Ent_Trial__c> trials  = [select Id, Account__c, Opportunity__c, Trial_Start_Date__c, Trial_End_Date__c, Trial_Status__c,
                                        profile_type__c,Number_of_Days__c,Extended__c
                                      from Ent_Trial__c where Opportunity__c  = :optyId AND Trial_Status__c = :trialStatus  limit 1];
            if(!trials.isEmpty() && trials != null){
                trial = trials[0];
            }
        }
        //System.debug('trial: '+trial);
        return trial;
    } 
    
    /**
    *  @description  : Get Trial , Trial Contact
    *  @param     trialId
    *  @param     trialStatus
    *  @return    trialConts
    */
    public static List<Trial_Contact__c> getTrailContactSobjects(String trialId, String trialStatus){
        
        List<Trial_Contact__c> trialConts = new List<Trial_Contact__c>();
        
        if(String.isNotBlank(trialId) && 
            Schema.sObjectType.Trial_Contact__c.isAccessible() &&
            Schema.sObjectType.Contact.isAccessible()  )
        {
            if(String.isNotBlank(trialStatus)){
                trialConts  = [Select Id, Name, Trials__c, External_Contact_Number__c, External_Contact_Number_Source__c, Contact__c, First_Name__c, 
                            Last_Name__c, Email__c, One_Pass_ID__c,One_Pass_User_Name__c, Status__c, Online_Contact__c, COBALT_GUID__c, DATAROOM_GUID__c, Start_Date__c, 
                            End_Date__c, Account__c, Opportunity__c, Primary__c, Contact__r.Online_Contact_Designation__c, Contact__r.Name, 
                            Contact__r.Primary_Flag__c, Request_Type__c, Profile_Type__c
                            from Trial_Contact__c WHERE Trials__c = :trialId and status__c = :trialStatus];
            }
            else if(String.isBlank(trialStatus)){
                trialConts  = [Select Id, Name, Trials__c, External_Contact_Number__c, External_Contact_Number_Source__c, Contact__c, First_Name__c, 
                            Last_Name__c, Email__c, One_Pass_ID__c,One_Pass_User_Name__c, Status__c, Online_Contact__c, COBALT_GUID__c, DATAROOM_GUID__c, Start_Date__c, 
                            End_Date__c, Account__c, Opportunity__c, Primary__c, Contact__r.Online_Contact_Designation__c, Contact__r.Name, 
                            Contact__r.Primary_Flag__c, Request_Type__c, Profile_Type__c
                            from Trial_Contact__c WHERE Trials__c = :trialId ];
            }
        }
        //System.debug('trialConts: '+trialConts);
        return trialConts;
    } 
    
    /**
    *  @description  : Get Trail Products
    *  @param     trialId
    *  @return    trialPrds
    */
    public static List<Trial_Product__c> getTrailProductSobjects(String trialId){
        
        List<Trial_Product__c> trialPrds = new List<Trial_Product__c>();
        
        if(String.isNotBlank(trialId) && 
            Schema.sObjectType.Trial_Product__c.isAccessible() &&
            Schema.sObjectType.Product2.isAccessible()  ){
            trialPrds  = [select Id, Name, Product_Name__c, Trial__c, Product_Name__r.Name, Material_Number__c, Product_Type__c,              
                        Product_Name__r.Material_Type__c, Product_Name__r.Bundle_Type__c,
                        Segment__c, Relationship_Type__c, Base_Material_Number__c,Base_Material_Number__r.Name 
                        from  Trial_Product__c WHERE Trial__c = :trialId];
        }
        //System.debug('trialPrds: '+trialPrds);
        return trialPrds;
        
    } 
   
     
  }