/********************************************************************************************************
 *  @description ODTDG_TrialRecord_ContactHelper : wMain class to hold incoming request contact details 
*********************************************************************************************************/
 
public with sharing class ODTDG_TrialRecord_ContactHelper {
     



/********************************************************************************************************
 *  @description TrialContacts : wrapper class that holds incoming request contact details 
*********************************************************************************************************/

    public class TrialContacts { // Completed 
        public String firstName;
        public String lastName;
        public String email;
        public string trialContactSfId;
        public Boolean primaryUser;        
        public String cobaltGUID;
        public String dataroomGUID; 
        public String userAuthId;
        public String contactNumber;
        public String contactNumSource;
        public String trialStatus;
        public String trialContactUniqueName;
        //public dateTime acceptedTermDT;
        public string businessPhone;
        public string profileType;
        public dateTime trialAcceptanceDateTime;
    }

    
    

}