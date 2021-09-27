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
public class OmniSubmitEntiCustomerReqWrap {

    public Long customerNumber;
    public String customerName;
    public String customerSegment;
    public String salesOrg;
    public String countryCode;
    public String currencyCode;
    public String city;
    public String state;
    public String zipcode;
    public String taxClass;
    public String industryCode;
    public String industryCode1;
    public String jurisdictionCode;
     /**           
   * @description  OmniSubmitEntiUsersReqWrap
   * @param json body
   * @return OmniSubmitEntiUsersReqWrap
   * */             
    public static OmniSubmitEntiCustomerReqWrap parse(String json) {
        return (OmniSubmitEntiCustomerReqWrap) System.JSON.deserialize(json, OmniSubmitEntiCustomerReqWrap.class);
    } 
}