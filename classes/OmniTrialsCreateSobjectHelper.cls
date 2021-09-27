/**
* @description       : DPS-20640 OmniTrialsCreateSobjectHelper
* @author            : 
* @group             : 
* @last modified on  : 06-14-2021
* @last modified by  : TCS
* Modifications Log 
* Ver   Date         Author                               Modification
* 1.0   06-14-2021   TCS   Initial Version
**/
public with sharing class OmniTrialsCreateSobjectHelper{
    
  
  /**
  * @description : populateExternalAccountNumSource
  * @param  trialSobj
  * @param  trialContacts
  * @return  trialSobj
  */
  public static Ent_Trial__c populateExternalAccountNumSource(Ent_Trial__c trialSobj, List<TrialContactWrapper> trialContacts){
      
      String externalAccNum = '';
      String externalAccSrc = '';
      
      String externalAccNumPrimary = '';
      String externalAccSrcPrimary = '';
      
      for(TrialContactWrapper cont : trialContacts)
      {
      
          TrialOLCOnePassByEmailRespWrap olcOnePass = cont.olcOnePass;
          
          if(olcOnePass!= null && cont.isPrimaySelectedFromUI && olcOnePass.externalAccountNumber != null && olcOnePass.externalAccountNumberSource != null){
              externalAccNumPrimary = olcOnePass.externalAccountNumber;
              externalAccSrcPrimary = olcOnePass.externalAccountNumberSource;
          }
          
          if(olcOnePass!= null && olcOnePass.externalAccountNumber != null && olcOnePass.externalAccountNumberSource != null){
              externalAccNum = olcOnePass.externalAccountNumber;
              externalAccSrc = olcOnePass.externalAccountNumberSource;
          }
      }
      
      trialSobj = getExternalAccSrcUpdate(trialSobj, externalAccNum,externalAccSrc);
      
      //Update primary contact details
      trialSobj = getExternalAccSrcUpdate(trialSobj, externalAccNumPrimary,externalAccSrcPrimary);
      
      
      return trialSobj;
  }
  
  /**
  * @description       : getExternalAccSrcUpdate
  * @param trialSobj 
  * @param externalAccNumToUpdate 
  * @param   externalAccSrcToUpdate
  * @return : trialSobj
  */
  private static Ent_trial__c getExternalAccSrcUpdate(Ent_trial__c trialSobj, String externalAccNumToUpdate ,String externalAccSrcToUpdate) {
      
      if(String.isNotBlank(externalAccNumToUpdate) && String.isNotBlank(externalAccSrcToUpdate)){
          trialSobj.External_Account_Number__c = externalAccNumToUpdate;
          trialSobj.External_Account_Number_Source__c = externalAccSrcToUpdate;
      }
      
      return trialSobj;
  }
}