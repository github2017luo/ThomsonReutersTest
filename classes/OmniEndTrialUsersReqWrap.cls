/**
 * @description       : 
 * @ JIRA 			  : DPS-21106
 * @ TestClass        : OmniEndTrial_Test
 * @author            : TCS Devteam
 * @group             : 
 * @last modified on  : 05-28-2021
 * @last modified by  : TCS Devteam
 * Modifications Log 
 * Ver   Date         Author        Modification
 * 1.0   05-28-2021   TCS Devteam   Initial Version
**/
public class OmniEndTrialUsersReqWrap {

        public String userGUID;
        public String domain;
        public String storageKey;
    
     /**           
   * @description  OmniEndTrialUsersReqWrap
   * @param json body
   * @return OmniEndTrialUsersReqWrap
   * */             
    public static OmniEndTrialUsersReqWrap parse(String json) {
        return (OmniEndTrialUsersReqWrap) System.JSON.deserialize(json, OmniEndTrialUsersReqWrap.class);
    } 
}