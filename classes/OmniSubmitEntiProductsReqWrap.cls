/**
 * @description       :
 * @ JIRA 			  : DPS-209568
 * @ TestClass        : OmniSubmitEntitlement_Test 
 * @author            : TCS Devteam
 * @group             : 
 * @last modified on  : 05-28-2021
 * @last modified by  : TCS Devteam
 * Modifications Log 
 * Ver   Date         Author        Modification
 * 1.0   05-28-2021   TCS Devteam   Initial Version
**/
public class OmniSubmitEntiProductsReqWrap {

        public String productId;
        public String productName; 
        public String productType;
        public String offerId;
        public String referenceId;
        public String effectiveDate;
        public String endDate;
    	public string promotionCode;
        public List<OmniSubmitEntiContactsReqWrap> contact;
    
     /**           
   * @description  OmniSubmitEntiProductsReqWrap
   * @param json
   * @return OmniSubmitEntiProductsReqWrap
   * */             
    public static OmniSubmitEntiProductsReqWrap parse(String json) {
        return (OmniSubmitEntiProductsReqWrap) System.JSON.deserialize(json, OmniSubmitEntiProductsReqWrap.class);
    }  
}