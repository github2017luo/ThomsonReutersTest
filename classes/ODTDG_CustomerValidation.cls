/*
    Author : Mir Umair
    Date: March 2021
    @Description ODTDG_CustomerValidation: Facade class to call the sub methods for validations from multiple sources
    Returns: Serialized JSON 
*/
/******************************************************************
 * @description ODTDG_CustomerValidation: Facade class to call the sub methods for validations from multiple sources
 ******************************************************************/
public with sharing class ODTDG_CustomerValidation {

/********************************************************************************************************
*  @description validateAll: Method to check all customer validations 
*  @param requestData : this will accept the user email 
*  @param valDataM : this will accept the user input data
*  @return ODTDG_CustomerData
*********************************************************************************************************/ 

    public static ODTDG_CustomerData validateAll(string requestData,ODTDG_CustomerValidateJson valDataM){
        ODTDG_CustomerData cd = new ODTDG_CustomerData(new ODTDG_CustomerData.ValidationData(),new List<ODTDG_CustomerData.Error>());
        
        //Customer details
         List<ODTDG_CustomerData_Helper.CustomerDetails> clst = new List<ODTDG_CustomerData_Helper.CustomerDetails>();
         ODTDG_CustomerData_Helper.CustomerDetails c = new ODTDG_CustomerData_Helper.CustomerDetails();
        c.emailAddress = requestData;
        c.isPrimary = true;
        clst.add(c);
        cd.customerDetails = clst;
        
    
        //Account details
        ODTDG_CustomerData_AccountDetails.AccountDetail a = new ODTDG_CustomerData_AccountDetails.AccountDetail();
        cd.accountDetail = a;
        
        try{
            
            try{
            	cd = ODTDG_ExistingUserCheck.checkExistingUsercheck(requestData, cd);
            }
            catch(Exception ex){
                List<ODTDG_CustomerData.Error> errList = new List<ODTDG_CustomerData.Error>();
                ODTDG_CustomerData.Error er = new ODTDG_CustomerData.Error();
                string errName = 'OP_ERR';
                er = ODTDG_ErrorCodeDataService.parseErrorMessage(errName);
                errList.add(er);
                cd.error = errList;
            }
            
        cd = ODTDG_ValidationDataService.checkBlacklisted(requestData,cd);
            
        //Customer details
        // List<ODTDG_CustomerData_Helper.CustomerDetails> clst = new List<ODTDG_CustomerData_Helper.CustomerDetails>();
        // ODTDG_CustomerData_Helper.CustomerDetails c = new ODTDG_CustomerData_Helper.CustomerDetails();
        //cd.customerDetails[0].emailAddress = requestData;
        //cd.customerDetails[0].isPrimary = true;
         cd.customerDetails[0].isBlacklisted = cd.validationData.isBlacklisted;
        // clst.add(c);
        // cd.customerDetails = clst;
    
        //Account details
        //ODTDG_CustomerData_AccountDetails.AccountDetail a = new ODTDG_CustomerData_AccountDetails.AccountDetail();
        //cd.accountDetail = a;
        
       List<String> emails=new List<String>{requestData};

       cd = ODTDG_ValidationDataServiceHelperTwo.IsCustomerDup(emails,cd,valDataM);
       cd = ODTDG_ValidationDataServiceHelperTwo.isTrialActive(emails,cd,valDataM);
        
        if(cd.validationData.isExistingCustomer){
            string accountNum = cd.accountDetail.accountNumber;
            cd = ODTDG_ValidationDataService.isCustomerLapsed(accountNum ,cd);
            cd = ODTDG_ValidationDataService.isCustSanctioned(accountNum ,cd);
        }
         

       	}catch(Exception ex){
        	List<ODTDG_CustomerData.Error> errList = new List<ODTDG_CustomerData.Error>();
            ODTDG_CustomerData.Error er = new ODTDG_CustomerData.Error();
            string errName = 'OP_ERR';
            er = ODTDG_ErrorCodeDataService.parseErrorMessage(errName);
            errList.add(er);
            cd.error = errList;
    	}
        
       return cd;
       
    }
}