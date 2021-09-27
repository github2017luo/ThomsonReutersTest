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
global with sharing class ODTDG_CustomerData_Helper {

    global List<CustomerDetails> customerDetails;

/********************************************************************************************************
*  @description CustomerDetails is the constructor for customer details  
*********************************************************************************************************/ 
    public class CustomerDetails {
        public Boolean isPrimary;
        public String emailAddress;
        public String cobaltGUID;
        public String dataroamGUID;
        public String userAuthId;
        public String contactNumber;
        public string contactNumberSource;
        public boolean isBlacklisted;
        public boolean isCustomerDup;
        public boolean isDifferentDomain;
        public boolean isAlreadyAdded;
        public boolean isTrialActive;
        public String trialId;
        public String profileType;
        public string trialContactSfId;


        /********************************************************************************************************
        *  @description CustomerDetails: This is the constructor for wrapper  
        *********************************************************************************************************/
        public CustomerDetails(){
            isBlacklisted = false;
            isCustomerDup = false;
            isPrimary = false;
            isDifferentDomain = false;
            isAlreadyAdded = false;
            isTrialActive = false;
        }

    } 

}