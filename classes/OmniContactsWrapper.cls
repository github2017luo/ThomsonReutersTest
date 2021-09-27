/******************************************************************************************
* Class         : OmniContactsWrapper
* @description  : test
* @param        : NA
* @return       : NA
* Created Date  : 07-May-2021
* Author        : TCS Developer 
* ****************************************************************************************/
   
public class OmniContactsWrapper {
         
/******************************************************************************************
* WrapperClass Name : ContactsWrapper
* @Description      : Wrapper
* @param            : NA
* Created Date      : 07-May-2021
* Author            : TCS Developer 
* @return           : NA
*******************************************************************************************/
    
    /**
     * @description ContactsWrapper
     */
    public class ContactsWrapper {
        /**
          * @description firstName */
        
        @AuraEnabled public string firstName ;
        
        /**
          * @description lastName */
        @AuraEnabled public string lastName ;
        
         /**
          * @description appGUID */
        @AuraEnabled public string appGUID ;
        
         /**
          * @description emailId */
        @AuraEnabled public string emailId ;
        
         /**
          * @description sAPContactId */
        @AuraEnabled public string sAPContactId ;
        
         /**
          * @description sFDCContactId */
        @AuraEnabled public string sFDCContactId ;
        
         /**
          * @description sAPAccountId */
        @AuraEnabled public string sAPAccountId ;
        
         /**
          * @description sFDCAccountId */
        @AuraEnabled public string sFDCAccountId ;
        
         /**
          * @description oLCStatus */
        @AuraEnabled public string oLCStatus ;
        
         /**
          * @description contactSSD */
        @AuraEnabled public LCRM_Contact_SSD__c contactSSD ;
        
         /**
          * @description userDomain */
        @AuraEnabled public string userDomain ; 
        /**
          * @description ContactsWrapper
          * @param der
         
          
          */
        public ContactsWrapper(OmniCallToOLCFetchOnlineContactsHelper.displayContactsWrapper der) {
            this.firstName = der.fname;
            this.lastName = der.lname;
            this.appGUID = der.apguid;
            this.emailId = der.email;
            this.sAPContactId = der.sAPConId;
            this.sFDCContactId = der.sFDCconid;
            this.sAPAccountId = der.sAPAccid;
            this.sFDCAccountId = der.sFDCaccid;
            this.oLCStatus = der.oLCStatus;
            this.userDomain = der.appid;
        }
    } 
 
}