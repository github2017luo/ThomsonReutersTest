/**
 * @description       : 
 * @JIRA 			  : 21463
 * @Test Class		  : OmniSubmitEntitlement_Test
 * @author            : TCS Dev Team
 * @group             : 
 * @last modified on  : 06-24-2021
 * @last modified by  :  TCS Dev Team
 * Modifications Log 
 * Ver   Date         Author                               Modification
 * 1.0   05-28-2021    TCS Dev Team   Initial Version
**/
public class OmniSubmitEntiBooomiHeaderReqWrap {
        public string companyId;
    
      /**           
   * @description  OmniSubmitEntiBooomiHeaderReqWrap
   * @param json body
   * @return OmniSubmitEntiBooomiHeaderReqWrap
   * */             
    public static OmniSubmitEntiBooomiHeaderReqWrap parse(String json) {
        return (OmniSubmitEntiBooomiHeaderReqWrap) System.JSON.deserialize(json, OmniSubmitEntiBooomiHeaderReqWrap.class);
    }  
}