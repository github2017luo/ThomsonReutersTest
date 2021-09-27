/* Class: ODTDG_ErrorCodeDataService
* @description: This class will parsing the error message based on error code 
* Created: 04/16/2021
* Author: Mallikarjuna Rao
* 
* CHANGE HISTORY
* =============================================================================
* Date         Name             JIRA        Description
* 2021-04-16   Mallikarjuna     DCP-1140    
* =============================================================================
* @description class for error handlings for all services, data will be fetch from SFDC custom meta data
*/
/******************************************************************
 * @description ODTDG_CustomerValidation: class for error handlings for all services, data will be fetch from SFDC custom meta data
 ******************************************************************/

 public with sharing class ODTDG_ErrorCodeDataService {
    
/********************************************************************************************************
*  @description getErrorDetailsByCode: get error message from custom settings 
*  @param code : this will accept the user email and based on that we will check blacklisted or domain data 
*  @return ODTDG_CustomerData.Error
*********************************************************************************************************/ 
    public static Error_Code__mdt getErrorDetailsByCode(string code){
    
        if(Error_Code__mdt.getAll().containsKey(code)){ 
            return Error_Code__mdt.getInstance(code) ;  
        } 
    
        return null;
    }  
 
/********************************************************************************************************
*  @description parseError: Method to map the error message from custom settings 
*  @param ec : this will accept the user email and based on that we will check blacklisted or domain data 
*  @return ODTDG_CustomerData.Error
*********************************************************************************************************/ 
    public static ODTDG_CustomerData.Error parseError(Error_Code__mdt ec){
            ODTDG_CustomerData.Error e = new ODTDG_CustomerData.Error();
                e.message = ec.Error_Description__c; //'Error message here!';//Set error message details in custom setting
                e.errortype = ec.Error_Type__c; // 'SanctionedError'; 
                e.code = ec.Error_Status_Code__c; //'ERR-004';
                e.errorHeader = ec.Error_Header__c;
          return e;      
    }

/********************************************************************************************************
*  @description parseErrorMessage: Method to map the error message from error code
*  @param code : this will accept the user email and based on that we will check blacklisted or domain data 
*  @return ODTDG_CustomerData.Error
*********************************************************************************************************/ 
    public static ODTDG_CustomerData.Error parseErrorMessage(string code){

        Error_Code__mdt ec = new Error_Code__mdt();
        ec = getErrorDetailsByCode(code);
        
        ODTDG_CustomerData.Error e = new ODTDG_CustomerData.Error();
        if(ec.Error_Status_Code__c != null){
            e = parseError(ec);
        }
        return e;
    }


}