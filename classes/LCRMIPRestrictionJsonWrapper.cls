/*
@Author: Noopur Rathod  
@JIRA Story: CRM-8066
@Purpose: This Controller is for IP Restriction Webservice. 
          Performs REQUEST JSON String to Apex and serializes the REQUEST. Also, performs RESPONSE JSON String to Apex and deserializes the RESPONSE.
@Version: 2017-10-12

* CHANGE HISTORY
* =============================================================================
* Date              Name                    Description
*                                      
* =============================================================================

*/

Public class LCRMIPRestrictionJsonWrapper{

    /**** START REQUEST WRAPPER IP Restriction****/
    public class SSDRequestWrapper{
        public cls_GetIPRestrictionRequest GetIPRestrictionRequest;   
        public SSDRequestWrapper(cls_GetIPRestrictionRequest LCRM_IPRestriction){
            GetIPRestrictionRequest = LCRM_IPRestriction;
        }
    }

    public class cls_GetIPRestrictionRequest{
        public cls_ESIHeader ESIHeader;
        public String domain;
        public String validityDate;
        public List<String> accountNumbers;
        
        public cls_GetIPRestrictionRequest(cls_ESIHeader LCRM_ESIHeader,String LCRM_domain,String LCRM_validityDate,List<String> LCRM_AccountNumber){
          ESIHeader = LCRM_ESIHeader;
          accountNumbers = LCRM_AccountNumber;
          domain = LCRM_domain;
          validityDate = LCRM_validityDate;     
        }
    }
   
    public class cls_ESIHeader{
        public String applicationId;
        public String postBackURL;

        public cls_ESIHeader(String LCRM_appId,String LCRM_postBackURL){
            applicationId = LCRM_appId;
            postBackURL = LCRM_postBackURL;
        }
    }
    
    //Serialize the Request
    public static String getCredentialReqJsonString(String appID,String postBackURL,String IPResDomain,String strValidityDateIP,List<Source_System_Detail__c> ListofSSD){
        String StrJsonCredential='';
        List<String> LCRM_SAPAccNo = new List<String>();
        //Map the Reuest parameters with Object's(SSD) fields value
        try{
            if(ListofSSD.size()>0){
                for(Source_System_Detail__c SSD : ListofSSD){
                    if(String.IsNotBlank(SSD.Source_System_Account_Number__c)){
                        LCRM_SAPAccNo.add(SSD.Source_System_Account_Number__c);
                    }
                }//End For Loop
            }//End SSD List Size Checking
            /*
            *To serialize the IP Request for getting the Json.
            *JSON use to set the Request body
            */
            if(strValidityDateIP != null && LCRM_SAPAccNo.size()>0 && (IPResDomain =='CLEAR' || IPResDomain =='CREDENTIALING' || IPResDomain =='RFI')) {
                //cls_account ESIAccount = new cls_account(CredentialsalesOrg);
                cls_ESIHeader ESIHeaderRec = new cls_ESIHeader(appID,postBackURL); 
                // cls_ESIHeader LCRM_ESIHeader,List<String> LCRM_AccountNumber,cls_account LCRM_acc
                cls_GetIPRestrictionRequest GetIPRestrictionRequest= new cls_GetIPRestrictionRequest(ESIHeaderRec,IPResDomain,strValidityDateIP,LCRM_SAPAccNo);
                SSDRequestWrapper SSDRequest= new SSDRequestWrapper(GetIPRestrictionRequest);
                StrJsonCredential = JSON.serialize(SSDRequest);
            }else{
                Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Error: '+'No Records are Found!'));
            }
        } 
        catch(Exception objException){
            Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Error: '+objException.getMessage()));
        }
        return StrJsonCredential;
    } 
    
    public class SSDResponseWrapper {
        public GetIPRestrictionResponse GetIPRestrictionResponse;
    }

    public class GetIPRestrictionResponse {
        public List<cls_IPRestrictionItem> IPRestrictionItem;
    }
  
    public class cls_IPRestrictionItem {
        public String accountNumber{get;set;}
        public String groupType{get;set;}
        public Integer groupID{get;set;}
        public String IPRestrictionType{get;set;}
        public String IPRestrictionDesc{get;set;}
        public String IPAddress{get;set;}
        public String IPUpper{get;set;}
        public String countryCode{get;set;}
        public String countryDesc{get;set;}
        public String effectiveBegDate{get;set;}
        public String effectiveEndDate{get;set;}
    }

  
    //Deserialize the Response with Wrapper class Parameters
    public static List<cls_IPRestrictionItem> getMatchedCredentialRecord(String jsonResponse){
         
        List<cls_IPRestrictionItem> ClsCredIteamlst = new List<cls_IPRestrictionItem>();
        SSDResponseWrapper SSDResWrap = new SSDResponseWrapper();
        try{
            SSDResWrap = (SSDResponseWrapper)System.JSON.deserialize(jsonResponse,SSDResponseWrapper.class);
            
            if(SSDResWrap.getIPRestrictionResponse!=null){
                if(SSDResWrap.getIPRestrictionResponse.IPRestrictionItem.size()>0){
                    for(cls_IPRestrictionItem IPInfo: SSDResWrap.getIPRestrictionResponse.IPRestrictionItem){
                             ClsCredIteamlst.add(IPInfo);           
                    }
                }
            }
        } 
        catch(Exception objException) {
            Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Error: '+objException.getMessage()));
        }
         return ClsCredIteamlst;
    }
     /**** END WRAPPER IP Restriction****/
     
    /** Exception Handling Wrapper **/ 
    public class ExternalExceptionMessagesWrapper {
        public GetIPRestrictionRequestcls GetIPRestrictionRequest;
    }

    public class StatusDetailcls {
        public String statusCode{get;set;}
        public String statusDescription{get;set;}
        public String statusDetailMessage{get;set;}
    }

    public class GetIPRestrictionRequestcls {
        public StatusDetailcls StatusDetail;
    }

    public static StatusDetailcls getSAPExceptionMesg(String jsonResponse){
        StatusDetailcls Exptioninfo = new StatusDetailcls ();
        ExternalExceptionMessagesWrapper  exptionmesg = new ExternalExceptionMessagesWrapper ();
        try{
            exptionmesg = (ExternalExceptionMessagesWrapper)System.JSON.deserialize(jsonResponse,ExternalExceptionMessagesWrapper.class);
            if(exptionmesg.GetIPRestrictionRequest!=null){
            if(exptionmesg != null && exptionmesg.GetIPRestrictionRequest.StatusDetail!=null){
                Exptioninfo = exptionmesg.GetIPRestrictionRequest.StatusDetail;           
            } 
            } 
        } catch(Exception objException){
            Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Error: '+objException.getMessage()));
        }
           
        return Exptioninfo;
    } 
}