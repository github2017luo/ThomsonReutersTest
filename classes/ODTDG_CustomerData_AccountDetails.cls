/* Class: ODTDG_CustomerData_Helper
* @description ODTDG_CustomerData_Helper : This is the class to stomre more customer details 
* Created: 05/11/2021
* Author: Mallikarjuna Rao
* 
* CHANGE HISTORY
* =============================================================================
* Date         Name             JIRA        Description
* 2021-05-11   Mallikarjuna   DCP-     
* =============================================================================
* @description class for storing customer additional details 
*/
/********************************************************************************************************
*  
*  @description ODTDG_CustomerData_Helper: This is the helper class for customer data 
*********************************************************************************************************/
@SuppressWarnings('PMD.AvoidGlobalModifier') 
global with sharing class ODTDG_CustomerData_AccountDetails {
    
    global AccountDetail accountDetail;    
    
/********************************************************************************************************
*  @description AccountDetail: This is the wrapper for Account details 
*********************************************************************************************************/
    public class AccountDetail {
        public String accountNumber;
        public String accountNumberSource;
        public string lapsedReasonCode;
        public string lapsedreasonDesc;
        public Boolean isLapsed;
        public Boolean isLapsedBlock;
    }

}