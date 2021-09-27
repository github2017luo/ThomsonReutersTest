/*
    Author : Mir Umair
    Date: March 2021
    Description : Data class for validations - Serialized version of this class will be returned to AEM
*/
/* Class: ODTDG_CustomerData
* @description: Data class for validations - Serialized version of this class will be returned to AEM
* Created: 03/25/2021
* Author: Mir Umair
* 
* CHANGE HISTORY
* =============================================================================
* Date         Name             JIRA        Description
* 2021-04-16   Mallikarjuna   DCP-          
* =============================================================================
* @description : Data class for validations - Serialized version of this class will be returned to AEM
*/ 

/********************************************************************************************************
*  
*  @description ODTDG_CustomerData : Data class for validations - Serialized version of this class will be returned to AEM
*********************************************************************************************************/
@SuppressWarnings('PMD.AvoidGlobalModifier') 
global with sharing class ODTDG_CustomerData{
    public ValidationData validationData;
    public List<Error> error;
    public List<ODTDG_CustomerData_Helper.CustomerDetails> customerDetails;
    public ODTDG_CustomerData_AccountDetails.AccountDetail accountDetail;    
  
/********************************************************************************************************
*  @description ODTDG_CustomerData: This is the parameterised constructor with validation data and list of error messages 
*  @param v : This will be accepted the customer data 
*  @param e : This will accepted the list of error messages when parsing blacklisted or sanctioned account and others 
*********************************************************************************************************/ 
    public ODTDG_CustomerData(ValidationData v,List<ODTDG_CustomerData.Error> e){
        this.validationData = v;
        this.error = new LIST<Error>();
        this.error = e;
        this.customerDetails = new List<ODTDG_CustomerData_Helper.CustomerDetails>();
        this.accountDetail = new ODTDG_CustomerData_AccountDetails.AccountDetail();
    }

/********************************************************************************************************
*  @description ValidationData is the class which are having Customer validations and holding isBlacklisted, isExistingCustomer, isCustomerDup, isCustSanctioned, sanctionStatusChangeDT
*********************************************************************************************************/     
    public class ValidationData{
        //@description isBlacklisted is a variable to have a blacklisted boolean type 
        public boolean isBlacklisted; 
        public boolean isExistingCustomer;  
        public boolean isCustomerDup; 
        public boolean isCustSanctioned;  
        public dateTime sanctionStatusChangeDT;  
      //  public ODTDG_LapsedAccountServiceHandler.LapsedAccountDetails lapsedAccountDetails;
        
        // @description validationData constructor 
        // @return null
/********************************************************************************************************
*  @description validationData : this is the contructor for validation data 
*********************************************************************************************************/  
        public validationData(){
            isBlacklisted =  false;
            isExistingCustomer = false;
            isCustomerDup = false;
            isCustSanctioned = false;
        }
        
    }
 
/********************************************************************************************************
*  @description Error is the class which are having errortype, code and message 
*********************************************************************************************************/ 
    public class Error {
        public String errortype;
        public String message;
        public String code;
        public string errorHeader;
/********************************************************************************************************
*  @description error is the constructor for error 
*********************************************************************************************************/ 
        public error(){
            errortype = '';
            message = '';
            code = '';
            errorHeader = '';
        }
    }
    
/********************************************************************************************************
*  @description parse: This is the parameterised constructor with validation data and list of error messages 
*  @param v : This will be accepted the customer data 
*  @param e : This will accepted the list of error messages when parsing blacklisted or sanctioned account and others 
*********************************************************************************************************/
  /*  public class AccountDetail {
        public String accountNumber;
        public String cutomerType;//NCJ "CustomerDomain" : "Same_Domain", //New _Domain
    }
*/
 
/********************************************************************************************************
*  @description CustomerDetails is the constructor for customer details  
*********************************************************************************************************/ 
  /*  public class CustomerDetails {
        public String isPrimary;
        public String emailAddress;
        public String gUID;
        public String userAuthId;
        public String contactNumber;
    } 
*/
}