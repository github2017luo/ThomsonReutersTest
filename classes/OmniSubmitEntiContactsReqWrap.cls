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
public class OmniSubmitEntiContactsReqWrap {
    
    public String contactNumber;
    public String firstName;
    public String lastName;
    public String emailAddress;
    public String contactFunction;
    public String effectiveDate;
    public String endDate;
    public String profileIdentifier;
    public String extContactId;
    public List<OmniSubmitEntiUsersReqWrap> users;
    
    /**           
   * @description  OmniSubmitEntitlementRequestWrapper
   * @param json body
   * @return OmniSubmitEntitlementRequestWrapper
   * */             
    public static OmniSubmitEntiContactsReqWrap parse(String json) {
        return (OmniSubmitEntiContactsReqWrap) System.JSON.deserialize(json, OmniSubmitEntiContactsReqWrap.class);
    }  
    
}