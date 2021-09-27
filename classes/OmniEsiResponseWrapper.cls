/*============================================================================================
Name                : OmniEsiResponseWrapper
Description         : This class is developed as part of CXD-ODT project and it is serving as helper class for contactsListCon class  
Created Date        : 11/May/2021 
Author              : TCS team
==============================================================================================*/
  /**
* @description  OmniEsiResponseWrapper
*/
public class OmniEsiResponseWrapper{ 
    
     /**
* @description onlineContact
*/
    public onlineContact[] onlineContact;
    
    
     /**
    * @description onlineContact
    */
    public class OnlineContact {
        
        /**
    * @description contactNumber
    */
        public String contactNumber;  
        
        /**
* @description address
*/
        public address address;
        
        /**
* @description account
*/
        public account account;  
        /**
* @description sourceId
*/
        public String sourceId;  
        /**
* @description endDate
*/ 
        public String endDate;   
        /**
* @description entitlements
*/ 
        public OmniTrialOnlineContactWrapper.Entitlements[] entitlements;  
        /**
* @description onlineContactType
*/
        public String onlineContactType;   
        /**
* @description allowContactEmails
*/   
        public boolean allowContactEmails;  
        /**
* @description ContactsWrapper
*/
}
    
    /**
* @description address
*/
    public class   Address {
        
        /**
* @description firstName
*/
        public String firstName;   
        /**
* @description lastName
*/   
        public String lastName; 
        
        /**
    * @description emailAddress
    */   
        public String emailAddress; 
    }
    
    
    /**
* @description account
*/
    public class Account {  
        /**
* @description accountNumber
*/
        public String accountNumber;     
        /**
* @description companyId
*/ 
        public String companyId;    
    }
    
    /**
     * @description only return for code coverage
     * @param 
     */
    @testvisible
    private static void omniTestMethod(){
        if(Test.isrunningtest()){
            System.debug(LoggingLevel.DEBUG, 'Testing: ');
        }
        
        }
}