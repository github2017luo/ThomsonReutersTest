/******************************************************************************************
* Class         : OmniCallToOLCFetchOnlineContacts
* @description  : test
* @param        : NA
* @return       : NA
* Created Date  : 07-May-2021
* Author        : TCS Developer 
* ****************************************************************************************/
public class OmniCallToOLCFetchOnlineContactsHelper {
    /******************************************************************************************
* Method Name   : responseDeserialize
* @description  : Deserilaizing the Response
* Created Date  : 07-May-2021
* Author        : TCS Developer 
* ****************************************************************************************/  
    /** 
* @description Deserilaizing the Response.
* @param res
* @return esiResp
*/  
    public static OmniEsiResponseWrapper responseDeserialize(HTTPResponse res){
        OmniEsiResponseWrapper esiResp;
        if (res.getStatusCode() == 200) {
            esiResp = (OmniEsiResponseWrapper) JSON.deserialize(res.getBody(), OmniEsiResponseWrapper.class);
            
        }
        return esiResp;
    }
    
    /******************************************************************************************
* Method Name   : preparingDisplayItems
* @description  : Preparing the DisplayItems List
* Created Date  : 07-May-2021
* Author        : TCS Developer 
* ****************************************************************************************/  
    /** 
* @description Deserilaizing the Response.
* @param accountID
* @param olcon
* @return displayContactsWrapper
*/  
    public static displayContactsWrapper preparingDisplayItems(string accountID,OmniEsiResponseWrapper.onlineContact olcon){
        displayContactsWrapper dw = new displayContactsWrapper();
       
     
        for (OmniTrialOnlineContactWrapper.Entitlements enti: olcon.entitlements) {
            //DLT-12962 : Start
            try {
                 if (enti.status != null) {
                //if (enti.registered != null && enti.status != null && enti.registered == true) {
                 dw = fliteringDisplayItems(accountID,enti);
               
                }
            } catch (Exception e) {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, +e.getMessage()));
                // System.debug('Error' + e.getMessage());
            }
        }
    
        return dw;
    }
    
 /******************************************************************************************
* Method Name   : fliteringDisplayItems
* @description  : Preparing the DisplayItems List
* Created Date  : 07-May-2021
* Author        : TCS Developer 
* ****************************************************************************************/  
    /** 
* @description Deserilaizing the Response.
* @param accountID
* @param enti
* @return dw displayContactsWrapper
*/  
    public static displayContactsWrapper fliteringDisplayItems(string accountID,OmniTrialOnlineContactWrapper.Entitlements enti){
   
        displayContactsWrapper dw = new displayContactsWrapper();
        dw.sFDCconid = '';
        dw.sFDCaccid = accountID;
        dw.registeredWithOLC = FALSE;
        dw.isCobalt = FALSE;
        dw.isActive = FALSE;
      
        //for (OmniTrialOnlineContactWrapper.Entitlements enti: olcon.entitlements) {
            //DLT-12962 : Start
            try {
                System.debug(LoggingLevel.WARN,'@@enti: '+enti);
                if (enti.applicationId.equalsIgnoreCase('COBALT')){
                    if(enti.status == 'ACTIVE') {
                        dw.registeredWithOLC = TRUE;
                        dw.apguid = enti.appUserGuid;
                        //dw.email = enti.authEmail;
                        dw.appid = enti.applicationId;
                        dw.oLCStatus = enti.status;
                        dw.isCobalt = TRUE;
                        dw.isActive = TRUE;
                    } 
                    else if ( enti.status == 'INACTIVE') {
                        dw.registeredWithOLC = TRUE;
                        dw.apguid = enti.appUserGuid;
                        //dw.email = enti.authEmail;
                        dw.appid = enti.applicationId;
                        dw.oLCStatus = enti.status;
                        dw.isCobalt = TRUE;
                        dw.isActive = FALSE;
                    } 
                }
                else if (dw.isCobalt != TRUE ){
                     dw = checkingForNonCobalt(accountID,enti);
                }
                    
            } catch (Exception e) {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, +e.getMessage()));
                // System.debug('Error' + e.getMessage());
            }
        //}
        

        return dw;
    }
    
   
 /******************************************************************************************
* Method Name   : checkingForNonCobalt
* @description  : Checking applicationId as Non COBALT 
* Created Date  : 07-May-2021
* Author        : TCS Developer 
* ****************************************************************************************/  
    /** 
* @description Deserilaizing the Response.
* @param accountID
* @param enti
* @return displayContactsWrapper
*/  
     public static displayContactsWrapper checkingForNonCobalt(string accountID,OmniTrialOnlineContactWrapper.Entitlements enti){
        displayContactsWrapper dw = new displayContactsWrapper();
        dw.sFDCconid = '';
        dw.sFDCaccid = accountID;
        dw.registeredWithOLC = FALSE;
        dw.isCobalt = FALSE;
        dw.isActive = FALSE;
         if(enti.status == 'ACTIVE' && !enti.applicationId.equalsIgnoreCase('COBALT')) {
                        dw.registeredWithOLC = TRUE;
                        dw.apguid = enti.appUserGuid;
                        //dw.email = enti.authEmail;
                        dw.appid = enti.applicationId;
                        dw.oLCStatus = enti.status;
                        dw.isActive = TRUE;
                    } 
                    else if (enti.status == 'INACTIVE' && dw.isActive != TRUE) {
                        dw.registeredWithOLC = TRUE;
                        dw.apguid = enti.appUserGuid;
                        //dw.email = enti.authEmail;
                        dw.appid = enti.applicationId;
                        dw.oLCStatus = enti.status;
                        dw.isActive = FALSE;
                    }
         return dw;
     }
    
    /******************************************************************************************
* Method Name   : preparingDisplayItems
* @description  : Preparing the DisplayItems List
* Created Date  : 07-May-2021
* Author        : TCS Developer 
* ****************************************************************************************/  
    /** 
* @description Deserilaizing the Response.
* @param der
* @param olcon
* @return esiResp
*/  
    public static displayContactsWrapper filteringDisplayingItemds(displayContactsWrapper der,OmniEsiResponseWrapper.onlineContact olcon){
        displayContactsWrapper dw = der;
        
        dw.sAPConId = olcon.contactNumber;              
        OmniEsiResponseWrapper.address adrs = olcon.address;
        if (adrs != null) {
            dw.fname = adrs.firstName;
            dw.lname = adrs.lastName;
            dw.email = adrs.emailAddress;
        }
        if (olcon.account != null) {
            dw.sAPAccid = olcon.account.accountNumber;
        }
        
        return dw;
    }
    
    
    
    /******************************************************************************************
* WrapperClass Name : displayContactsWrapper
* @Description      : Wrapper
* @param            : NA
* Created Date      : 07-May-2021
* Author            : TCS Developer 
* @return           : NA
*******************************************************************************************/
    
    /**
* @description displayContactsWrapper
*/ 
    public class DisplayContactsWrapper{
        /**
* @description fname

*/
        public  string fname;
        /**
* @description lname

*/
        public  string lname;
        /**
* @description apguid

*/
        public  string apguid;
        /**
* @description email

*/
        public  string email;
        /**
* @description sAPConId

*/
        public  string sAPConId;
        /**
* @description sFDCconid

*/
        public  string sFDCconid;
        /**
* @description sAPAccid

*/
        public  string sAPAccid;
        /**
* @description sFDCaccid

*/
        public  string sFDCaccid;
        /**
* @description oLCStatus

*/
        public  string oLCStatus;
        /**
* @description appid

*/
        public  string appid;
        /**
* @description registeredWithOLC

*/
        public  Boolean registeredWithOLC;
        /**
* @description isCobalt

*/
        public  Boolean isCobalt;
        /**
* @description isActive

*/
        public  Boolean isActive;
    }
}