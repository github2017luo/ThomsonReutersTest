/********************************************************************************************************
 *  @description ODTDG_TrialRecord : Main class to hold incoming entitlement request 
*********************************************************************************************************/
public class ODTDG_TrialRecord {
    
  /********************************************************************************************************
 *  @description odtdgTrialDetails : variable to hold the values 
*********************************************************************************************************/
public OdtdgTrialDetails odtdgTrialDetails;

   /********************************************************************************************************
 *  @description ODTDG_TrialRecord : constructor
*********************************************************************************************************/
     public ODTDG_TrialRecord (){
       odtdgTrialDetails = new OdtdgTrialDetails();
     }
    
   /********************************************************************************************************
 *  @description OdtdgTrialDetails : wrapper class to hold incoming request all details 
*********************************************************************************************************/
 public class OdtdgTrialDetails {
        public ODTDG_TrialRecord_TrialHelper.TrialInfo trialInfo;
        public ODTDG_TrialRecord_TrialHelper.TrialAccountInfo trialAccountInfo;
        public List<TrialProdInfo> trialProdInfo;
    //    private List<LeadTrial> leadTrialInfo;
        public List<ODTDG_TrialRecord_ContactHelper.TrialContacts> trialContacts; 

/********************************************************************************************************
 *  @description OdtdgTrialDetails : constructor
*********************************************************************************************************/
        public OdtdgTrialDetails(){
            trialContacts = new List<ODTDG_TrialRecord_ContactHelper.TrialContacts>();
            trialProdInfo = new List<TrialProdInfo>();
        }
        
    }
    
/********************************************************************************************************
 *  @description TrialProdInfo : wrapper class to hold incoming request products details 
*********************************************************************************************************/

    public class TrialProdInfo { // Completed
        //public String trialProductCode;
        public String productOffering;
        public string trialProductNumber;
        public string productSfId;
 
/********************************************************************************************************
 *  @description TrialProdInfo : constructor
*********************************************************************************************************/
        public TrialProdInfo (){
            trialProductNumber= '';
        }
    }

   /* private class LeadTrial {
        
        private String trialleadRecord;
        
    } */
    
 /********************************************************************************************************
 *  @description parse : method to parse the json request 
 *  @param json expected the json parameter 
 *  @return ODTDG_TrialRecord return deserialized details on class format 
*********************************************************************************************************/
public static ODTDG_TrialRecord  parse(String json) {
        return (ODTDG_TrialRecord) System.JSON.deserialize(json, ODTDG_TrialRecord.class);
    }
      
}