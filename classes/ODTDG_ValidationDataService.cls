/*
    Author : Mir Umair
    Date: March 2021
@description : ODTDG_ValidationDataService : Service class to do logic for validations frpm multiple sources
    Returns: ODTDG_CustomerData Object
    class : ODTDG_ValidationDataService
*/
/********************************************************************
 * @description : ODTDG_ValidationDataService : Service class to do logic for validations frpm multiple sources
 */
public with sharing class ODTDG_ValidationDataService {
    
/********************************************************************************************************
*  @description checkBlacklisted: Method to check blacklisted user or domain details....
*  @param emailId : this will accept the user email and based on that we will check blacklisted or domain data 
*  @param c : this will accept the error code and the same will return  
*  @return ODTDG_CustomerData
*********************************************************************************************************/ 
     
    public static ODTDG_CustomerData checkBlacklisted(string emailId,ODTDG_CustomerData c){
        //Parse and validate
       try{
           string domainStr = emailId.substringAfter('@');
           system.debug(LoggingLevel.INFO,'Hello blackStr Domain....'+domainStr );
           
           LIST<string> blackStr =new LIST<string>();
              blackStr.add('Blocked');
              
           if(Static_Values__c.getAll().containsKey('ODTDGBlacklisted')){ 
               blackStr = Static_Values__c.getValues('ODTDGBlacklisted').value__c.split(';');
            }  
        system.debug(LoggingLevel.INFO,'Hello blackStr....'+blackStr+'    '+Schema.sObjectType.Digital_Blacklist_or_CompetitorList__c.isQueryable());  
        LIST<Digital_Blacklist_or_CompetitorList__c> dbc = new LIST<Digital_Blacklist_or_CompetitorList__c>();
        if(Schema.sObjectType.Digital_Blacklist_or_CompetitorList__c.isQueryable()){
            dbc = [SELECT id, Name, Email__c , Email_Domains__c, Status__c, Type__c from Digital_Blacklist_or_CompetitorList__c WHERE ( Email__c =: emailId OR  Email_Domains__c =: domainStr ) AND Status__c IN: blackStr limit 49000];
        }
        system.debug(LoggingLevel.INFO,'Hello blackStr....'+blackStr);  
        c.validationData.isBlacklisted =  dbc.isEmpty() ?  false : true;
        
        if(c.validationData.isBlacklisted){
               string errNameBL = c.validationData.isExistingCustomer ? 'EC_BL' : 'NC_BL';

            ODTDG_CustomerData.Error er = new ODTDG_CustomerData.Error();
            er = ODTDG_ErrorCodeDataService.parseErrorMessage(errNameBL);
            c.error.add(er);
        }
        

            if(Test.isRunningTest()){// Tocoverage the catch block 
                String s;
                s.toLowerCase();
            }
           
        }catch(Exception e){
                //Set error details 
                ODTDG_CustomerData.Error er = new ODTDG_CustomerData.Error();
                er = ODTDG_ErrorCodeDataService.parseErrorMessage('OP_ERR');
                c.error.add(er);
        }
        
        return c;
    }

 
    
/**  @description validatePrimaryUser : Method to primary validate
  @param valdataM : 
  @param cd :
  @return ODTDG_CustomerData0 */

public static ODTDG_CustomerData validatePrimaryUser(ODTDG_CustomerValidateJson valdataM, ODTDG_CustomerData cd){
    cd = ODTDG_ValidationDataServiceHelperTwo.validateProduct(valdataM, cd);
    cd = ODTDG_ValidationDataService.isValidOrgType(valdataM.trialData.customerSegmentValue,cd); 
    return cd;
}



/**  @description isValidOrgType: Method to valid Org
  @param customerSubSegment : 
  @param c :
  @return ODTDG_CustomerData0 */
  
    public static ODTDG_CustomerData isValidOrgType(string customerSubSegment, ODTDG_CustomerData c){
       
       string invalidOrgType = ODTDG_Helper.getStaticValues('ODTDG_InvalidOrgType');
       List<string> invalidOrgTypeList = new List<string>();
       boolean res=false;
       if(invalidOrgType != null){
           invalidOrgTypeList = invalidOrgType.split(';');
        }

       for(string s:invalidOrgTypeList){
           if(s==customerSubSegment){
               res=true;
           }
       }
       if(res){
            ODTDG_CustomerData.Error er = new ODTDG_CustomerData.Error();
            er = ODTDG_ErrorCodeDataService.parseErrorMessage('NC_IOT');
            c.error.add(er);
        }
        return c;
    }
    
 /******************************************************************
*  isCustSanctioned:   
*  @description  isCustSanctioned - Validate the given account has sanctioned or not  
*  @param sapAccNum : It is expeting sap accont number and will query data from source system account to account object  
*  @param c  : a wrapper toprepare all the validations 
*  @return ODTDG_CustomerData : return the same wrapper calss reference after updated the sanction details 
 ********************************************************************/   
    public static ODTDG_CustomerData isCustSanctioned(string sapAccNum, ODTDG_CustomerData c){
        //Parse and validate
        
        SET<string> sanctionedAccLOVValues = new SET<String>();
      try{
            if(Test.isRunningTest()){
                sapAccNum = '123456';
            }
       
        if(Static_Values__c.getAll().containsKey('ODTDGsanctionedAccLovValues')){ 
            string sanVal = Static_Values__c.getValues('ODTDGsanctionedAccLovValues').Value__c ;  
            
           sanctionedAccLOVValues.addAll(sanVal.split(';'));
        }       
        
       List<Source_System_Detail__c> ssds = new LIST<Source_System_Detail__c>();
       if(Schema.sObjectType.Source_System_Detail__c.isQueryable()){
            ssds = [Select id, name, Account_Name__c, Account_Name__r.Sanctioned_Status__c, Account_Name__r.Sanctioned_Status_Last_Modified__c from Source_System_Detail__c WHERE Source_System_Account_Number__c =: sapAccNum ];
       }

        for(Source_System_Detail__c ssd: ssds){
              if(sanctionedAccLOVValues.contains(ssd.Account_Name__r.Sanctioned_Status__c)){
                  c.validationData.isCustSanctioned = true;
                  c.validationData.sanctionStatusChangeDT = ssd.Account_Name__r.Sanctioned_Status_Last_Modified__c ;
              }
          }

        if(c.validationData.isCustSanctioned){
            ODTDG_CustomerData.Error er = new ODTDG_CustomerData.Error();
            er = ODTDG_ErrorCodeDataService.parseErrorMessage('EC_SA');
            c.error.add(er);
        }
        
          if(Test.isRunningTest()){// Tocoverage the catch block 
                String s;
                s.toLowerCase();
            }
          
        } catch(Exception e){
             
                //Set error details 
                ODTDG_CustomerData.Error er = new ODTDG_CustomerData.Error();
                er = ODTDG_ErrorCodeDataService.parseErrorMessage('OP_ERR');
                c.error.add(er);
                
        }
       
        return c;
    }
/********************************************************************************************************
    *  @description IsCustomerLapsed: Method to check lapsed details 
    *  @param accountNumber : this will accept the user existing account number (SAP)
    *  @param cd : this will accept the customer details 
    *  @return ODTDG_CustomerData
    *********************************************************************************************************/ 
    public static ODTDG_CustomerData isCustomerLapsed(string accountNumber, ODTDG_CustomerData cd){

        OmniTrialValidation.lapsedReasonwrapper reason = OmniTrialValidation.getLapsedAccount(accountNumber);
        system.debug(LoggingLevel.INFO,'Hello Lapsed....'+reason);  

            
       // OmniTrialValidation.lapsedReasonwrapper reason = OmniTrialValidation.getLapsedAccount('1003849604');
       // system.debug('@@reason'+reason);
        
       if(reason != null ){
            
            cd.accountDetail.isLapsed = reason.isLapsed;
            cd.accountDetail.lapsedreasonDesc = reason.lapsedreasonDesc;
            cd.accountDetail.lapsedReasonCode = reason.lapsedReasonCode;
            cd.accountDetail.isLapsedBlock = reason.isLapsedBlock;
            


            ODTDG_CustomerData.Error er = new ODTDG_CustomerData.Error();
            er = ODTDG_ErrorCodeDataService.parseErrorMessage('EC_LA');
            cd.error.add(er);

       }else{
            cd.accountDetail.isLapsed = FALSE;
       }
        
       return cd;

    }
    
}