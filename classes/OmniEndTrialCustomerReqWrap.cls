/**
 * @description       :
 * @ JIRA             : DPS-21106
 * @ TestClass        : OmniEndTrial_Test 
 * @author            : TCS Devteam
 * @group             : 
 * @last modified on  : 07-28-2021
 * @last modified by  : TCS Devteam
 * Modifications Log 
 * Ver   Date         Author        Modification
 * 1.0   05-28-2021   TCS Devteam   Initial Version
**/
public class OmniEndTrialCustomerReqWrap {

    public Long customerNumber;
    public String salesOrg;
     /**           
   * @description  OmniEndTrialCustomerReqWrap
   * @param json body
   * @return OmniEndTrialCustomerReqWrap
   * */             
    public static OmniEndTrialCustomerReqWrap parse(String json) {
        return (OmniEndTrialCustomerReqWrap) System.JSON.deserialize(json, OmniEndTrialCustomerReqWrap.class);
    } 
}