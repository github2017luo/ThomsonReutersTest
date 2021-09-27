/**
 * @description       : 
 * @JIRA 			  : DPS- 21106
 * @Test Class		  : OmniEndTrial_Test
 * @author            : TCS Dev Team
 * @group             : 
 * @last modified on  : 07-24-2021
 * @last modified by  :  TCS Dev Team
 * Modifications Log 
 * Ver   Date         Author                               Modification
 * 1.0   05-28-2021    TCS Dev Team   Initial Version
**/
public class OmniEndTrialBooomiHeaderReqWrap {
        public string companyId;
    
      /**           
   * @description  OmniEndTrialBooomiHeaderReqWrap
   * @param json body
   * @return OmniEndTrialBooomiHeaderReqWrap
   * */             
    public static OmniEndTrialBooomiHeaderReqWrap parse(String json) {
        return (OmniEndTrialBooomiHeaderReqWrap) System.JSON.deserialize(json, OmniEndTrialBooomiHeaderReqWrap.class);
    }  
}