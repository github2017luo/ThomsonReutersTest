/********************************************************************************************************
*  @description ODTDG_CustomerValidateJson is the class which are having Customer type  and product category and list of contacts validation
*********************************************************************************************************/ 
public with sharing class ODTDG_CustomerValidateJson {

    public TrialValidation trialData;
/********************************************************************************************************
*  @description TrialValidation is the class which are having Customer type  and product category and list of contacts validation
*********************************************************************************************************/ 
    public class TrialValidation {
        public String customerSegment;  //SLW
        public String customerSegmentValue;
        //public String productCategory;    //PL
        public String productOffering;  
        public Boolean isPrimaryCheck; // InviteCheck or PrimaryCheck
        public string trialSource;
        public List<TrialContacts> trialContacts;
    }

/********************************************************************************************************
*  @description TrialContacts is the class which are having Customer input for validation  such as email and status
*********************************************************************************************************/     
    public class TrialContacts {
        public String customerEmail;    //business@email.com
        public boolean forValidation;   //Validate
        public boolean primaryUser;
        public string userAuthId;
        public string trialContactSfId;
    }

/********************************************************************************************************
*  @description parse This is the method for parsing json response on customer validation 
*  @param json It is expected json as a param 
*  @return ODTDG_CustomerValidateJson return the class 
*********************************************************************************************************/     
     
    public static ODTDG_CustomerValidateJson parse(String json) {
        return (ODTDG_CustomerValidateJson) System.JSON.deserialize(json, ODTDG_CustomerValidateJson.class);
    }

}