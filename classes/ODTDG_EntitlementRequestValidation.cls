/*
Author : Ameeta Antonio
Date: July 2021
Description: This  class is mainly to validate the required fields received in the entitlement request. 
Returns: Error codes for missing fields
*/
/********************************************************************************************************
*  @description ODTDG_EntitlementRequestValidation class to validate request fields 
*************************************************************************************/
public with sharing class ODTDG_EntitlementRequestValidation {
    
    /********************************************************************************************************
*  @description validateRequestFields: Method to check if product offering and other request fields are valid
*  @param container : this will pass the customer input data
*  @param td : response record
*  @return ODTDG_EntitlementWrapper : error response for service
*********************************************************************************************************/ 
    public static ODTDG_EntitlementWrapper validateRequestFields(ODTDG_TrialRecord container, ODTDG_EntitlementWrapper td){
        ODTDG_TrialRecord.OdtdgTrialDetails trialData = container.odtdgTrialDetails;
        ODTDG_TrialRecord_TrialHelper.TrialAccountInfo trAcc = trialData.trialAccountInfo;
        List<ODTDG_TrialRecord.TrialProdInfo> trPrIn = trialData.trialProdInfo;
        
        List<String> prodoffering = new List<String>();       
        
        for(ODTDG_TrialRecord.TrialProdInfo tpin:trPrIn){
            prodoffering.add(tpin.productOffering);
        }
        List<String> pCodeList = ODTDG_Helper.getProductCode(prodOffering, trAcc.customerSegment);
        if(pCodeList.isEmpty()){
            string errNameBL = 'OP_NF';
            ODTDG_CustomerData.Error er = new ODTDG_CustomerData.Error();
            er = ODTDG_ErrorCodeDataService.parseErrorMessage(errNameBL);
            
            td.errors.add(er);
        }
        
        td = validateRequestFieldsTwo(container, td);
        
        return td;
        
    }
    
    /********************************************************************************************************
*  @description validateRequestFieldsTwo: Method to check if request fields are valid
*  @param container : this will pass the customer input data
*  @param trialrec : response variable
*  @return ODTDG_EntitlementWrapper : error response for service
*********************************************************************************************************/ 
    public static ODTDG_EntitlementWrapper validateRequestFieldsTwo(ODTDG_TrialRecord container,ODTDG_EntitlementWrapper trialrec){  
        ODTDG_TrialRecord.OdtdgTrialDetails trialData = container.odtdgTrialDetails; 
        List<ODTDG_TrialRecord_ContactHelper.TrialContacts> trCon = trialData.trialContacts;
        ODTDG_TrialRecord_TrialHelper.TrialInfo trInfo = trialData.trialInfo;
        Boolean fieldMissing = false;
        
        fieldMissing = validatePrimaryInvitedContact(trCon,trInfo);
        
        
        if(fieldMissing){
            string errNameBL = 'OP_MF';
            ODTDG_CustomerData.Error er = new ODTDG_CustomerData.Error();
            er = ODTDG_ErrorCodeDataService.parseErrorMessage(errNameBL);
            
            trialrec.errors.add(er);
        }
        return trialrec;
    }
    
    /********************************************************************************************************
*  @description validatePrimaryInvitedContact: Method to check if request fields are valid
*  @param trCon : list of trial contacts
*  @param trInfo : trial details
*  @return boolean 
*********************************************************************************************************/
    public static boolean validatePrimaryInvitedContact(List<ODTDG_TrialRecord_ContactHelper.TrialContacts> trCon, ODTDG_TrialRecord_TrialHelper.TrialInfo trInfo){
        Boolean isInValid = false;
        
        if(trInfo.trialStatus == 'Draft' || trInfo.trialStatus == 'Invite'){
            for(ODTDG_TrialRecord_ContactHelper.TrialContacts tc : trCon){
                
                isInValid = (String.isBlank(tc.email) && String.isBlank(tc.userAuthId))?true:false;
                
                
            }
        }
        
        return isInValid;
    }
    
}