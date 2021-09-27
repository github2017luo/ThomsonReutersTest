/**
 * @description       :
 * @ JIRA 			  : DPS-21106
 * @ TestClass        : OmniEndTrial_Test 
 * @author            : TCS Devteam
 * @group             : 
 * @last modified on  : 07-28-2021
 * @last modified by  : TCS Devteam
 * Modifications Log 
 * Ver   Date         Author        Modification
 * 1.0   05-28-2021   TCS Devteam   Initial Version
**/
public class OmniEndTrialProductsReqWrap {

        public String productId;
        public String productName; 
        public String productType;
        public String offerId;
        public String referenceId;
        public String effectiveDate;
        public String endDate;
        public List<OmniEndTrialContactsReqWrap> contact;
    
     /**           
   * @description  OmniEndTrialProductsReqWrap
   * @param json
   * @return OmniEndTrialProductsReqWrap
   * */             
    public static OmniEndTrialProductsReqWrap parse(String json) {
        return (OmniEndTrialProductsReqWrap) System.JSON.deserialize(json, OmniEndTrialProductsReqWrap.class);
    }  
}