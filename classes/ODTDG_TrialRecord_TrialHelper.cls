/********************************************************************************************************
 
*  @description ODTDG_TrialRecord_TrialHelper : class to hold TrialInfo service trial details 
*********************************************************************************************************/
@SuppressWarnings('PMD.ExcessivePublicCount')
public with sharing class ODTDG_TrialRecord_TrialHelper {

    /********************************************************************************************************
 *  @description TrialInfo : wrapper class that holds trial information 
*********************************************************************************************************/

    public class TrialInfo { //Completed
     
        public String trialStatus;
        public String campaignCode;
        public String trialStartDate;
        public integer trialDuration;
        public string trialProfileType; 
        public string webStore;
        public string trialSfId;
        public string apiCallPath;
        public string leadId;

/********************************************************************************************************
 *  @description TrialInfo : constructor
*********************************************************************************************************/        
        public TrialInfo(){
            apiCallPath= '';
        }
    }
    
/********************************************************************************************************
 *  @description TrialInfo : wrapper class that holds trial account information 
*********************************************************************************************************/
   
    public class TrialAccountInfo { // Completed
        public String accountNumber;        
        public String countryCode;
        public String state;
        public Boolean isLapsed;
        public String lapsedReasonCode;
        public String customerSegment;
        public String customerSegmentValue;
        public string accountNumSource; 
        public string accountName; 
        public string zipCode; 

/********************************************************************************************************
 *  @description TrialAccountInfo : constructor
*********************************************************************************************************/        
        public TrialAccountInfo(){
            accountName ='';
        }
        
    }



}