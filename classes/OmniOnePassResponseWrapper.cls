/**
* @description       : OmniOnePassResponseWrapper 
* @author            : TCS Dev Team
* @group             : Omni Trial Team
* @last modified on  : MAY-JUN 2021
* @last modified by  : 
* Modifications Log 
* Ver   Date         Author                               Modification
* 1.0   MAY-2021   TCS DEV Team                        Initial Version
**/
public class OmniOnePassResponseWrapper {

  /**           * @description */         
  @AuraEnabled public BOOMIHeader boOMIHeader;
  /**           * @description */         
  @AuraEnabled public Notification notification;
  /**           * @description */         
  @AuraEnabled public OmniOnePassResponseGenereicWrapper.Header header;
  /**           * @description */         
  @AuraEnabled public ServiceStatus serviceStatus;
  /**           * @description */         
  @AuraEnabled public OmniOnePassResponseGenereicWrapper.Trace trace;
  /**           * @description */         
  @AuraEnabled public List<Results> results;


  /**           * @description */         
  public class Notification {
      /**           * @description */         
      @AuraEnabled public String statusCode;
      /**           * @description */         
      @AuraEnabled public String statusDescription;
      /**           * @description */         
      @AuraEnabled public String trackingId;
      /**           * @description */         
      @AuraEnabled public String statusDetailMessage;
  }


  /**           * @description */         
  public class BOOMIHeader {
      /**           * @description */         
      @AuraEnabled public String companyId;
  }


  /**           * @description */         
  public class Results {
      /**           * @description */         
      @AuraEnabled public OmniOnePassResponseGenereicWrapper.Criteria criteria;
      /**           * @description */         
      @AuraEnabled public List<OmniTrialsProfilesWrapper.Profiles> profiles;
  }

  /**           * @description */         
  public class ServiceStatus {
      /**           * @description */         
      @AuraEnabled public String elapsedTime;
      /**           * @description */         
      @AuraEnabled public String startTime;
      /**           * @description */         
      @AuraEnabled public String statusCode;
      /**           * @description */         
      @AuraEnabled public String statusDescription;
  }


  
  
  /**           
   * @description  OmniOnePassResponseWrapper
   * @param json body
   * @return OmniOnePassResponseWrapper
   * */         
  public static OmniOnePassResponseWrapper parse(String json) {
      return (OmniOnePassResponseWrapper) System.JSON.deserialize(json, OmniOnePassResponseWrapper.class);
  }
}