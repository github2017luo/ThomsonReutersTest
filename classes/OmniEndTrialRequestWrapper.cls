/**
 * @description       : 
 * @ JIRA             : DPS-21106
 * @ TestClass        : OmniEndTrial_Test
 * @author            : TCS Devteam
 * @group             : 
 * @last modified on  : 07-30-2021
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log 
 * Ver   Date         Author        Modification
 * 1.0   05-28-2021   TCS Devteam   Initial Version
**/
public class OmniEndTrialRequestWrapper{
  
    public String trialId;
    public String requestType;
    public String trialUseCase;
    public String effectiveDate;
    public String endDate;
    public String dataOwner;
    public String reasonCode;
    public OmniEndTrialBooomiHeaderReqWrap BOOMIHeader;
    public List<OmniEndTrialProductsReqWrap> products;    
    public OmniEndTrialCustomerReqWrap customer;
    
  /**           
   * @description  OmniEndTrialRequestWrapper
   * @param json body
   * @return OmniEndTrialRequestWrapper
   * */             
    public static OmniEndTrialRequestWrapper parse(String json) {
        return (OmniEndTrialRequestWrapper) System.JSON.deserialize(json, OmniEndTrialRequestWrapper.class);
    }  
}