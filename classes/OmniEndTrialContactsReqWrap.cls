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
public class OmniEndTrialContactsReqWrap {
    
    public String contactNumber;
    public String profileIdentifier;
    public String extContactId;
    public List<OmniEndTrialUsersReqWrap> users;
    
    /**           
   * @description  OmniEndTrialContactsReqWrap
   * @param json body
   * @return OmniEndTrialContactsReqWrap
   * */             
    public static OmniEndTrialContactsReqWrap parse(String json) {
        return (OmniEndTrialContactsReqWrap) System.JSON.deserialize(json, OmniEndTrialContactsReqWrap.class);
    }  
    
}