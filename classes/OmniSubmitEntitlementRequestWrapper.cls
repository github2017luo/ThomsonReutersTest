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
public class OmniSubmitEntitlementRequestWrapper {
  
    public String trialId;
    public String requestType;
    public String trialUseCase;
    public String effectiveDate;
    public String endDate;
    public String dataOwner;
    public OmniSubmitEntiBooomiHeaderReqWrap BOOMIHeader;
    //public Customer customer;
    public List<OmniSubmitEntiProductsReqWrap> products;
    
    //public OmniSubmitEntiProductsReqWrap productsWrap;
    public OmniSubmitEntiCustomerReqWrap customer;
     
    //public OmniSubmitEntiUsersReqWrap userWrap;
    //public OmniSubmitEntiContactsReqWrap contactsWrap;
    
  /**           
   * @description  OmniSubmitEntitlementRequestWrapper
   * @param json body
   * @return OmniSubmitEntitlementRequestWrapper
   * */             
    public static OmniSubmitEntitlementRequestWrapper parse(String json) {
        return (OmniSubmitEntitlementRequestWrapper) System.JSON.deserialize(json, OmniSubmitEntitlementRequestWrapper.class);
    }  
}