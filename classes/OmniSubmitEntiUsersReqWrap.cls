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
public class OmniSubmitEntiUsersReqWrap {

        public String userGUID;
        public String domain;
        public String storageKey;
    
     /**           
   * @description  OmniSubmitEntiUsersReqWrap
   * @param json body
   * @return OmniSubmitEntiUsersReqWrap
   * */             
    public static OmniSubmitEntiUsersReqWrap parse(String json) {
        return (OmniSubmitEntiUsersReqWrap) System.JSON.deserialize(json, OmniSubmitEntiUsersReqWrap.class);
    } 
}