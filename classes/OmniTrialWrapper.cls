/**
* @description       : Align with LWC table and objects
* @author            : TCS Dev Team
* @group             : Omni Trials
* @last modified on  : 06-09-2021
* @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
* Modifications Log 
* Ver   Date         Author                               Modification
* 1.0   05-18-2021   TCS DEV Team                        Initial Version
**/
  public class OmniTrialWrapper{
      
      /**
      * @description primaryContactName
      */
      @AuraEnabled
      public String primaryContactName;
      
      /**
      * @description entTrial
      */
      @AuraEnabled
      public Ent_Trial__c entTrial{get;set;}
      
      /**
      * @description primaryContactEmail
      */
      @AuraEnabled
      public String primaryContactEmail{get;set;}
      
      /**
      * @description trialContacts
      */
      @AuraEnabled
      public List<TrialContactWrapper> trialContacts{get;set;}
      
      /**
      * @description trialProducts
      */
      @AuraEnabled
      public List<TrialProductWrapper> trialProducts{get;set;}
  }