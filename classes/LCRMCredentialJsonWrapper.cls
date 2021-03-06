/**
* @JIRA Story: (CRM-6978 - CRM-7957) 
*@Purpose\Description:  LCRMCredentialJsonWrapper Which are generated by Json files.
                        SDFC Integration Development with ESI Team for Credential Webservice
* CHANGE HISTORY
* =============================================================================
* Date              Name                    Description
*2017-09-15      Radhika Pawar              Credential 
* =============================================================================
 */
Public class LCRMCredentialJsonWrapper{

    /**** START REQUEST WRAPPER CREDENTIALINFO****/
    public class SSDRequestWrapper {
        public cls_getCredentialInfoRequest getCredentialInfoRequest;   
        public SSDRequestWrapper(cls_getCredentialInfoRequest LCRM_CredentialInfo){
            getCredentialInfoRequest=LCRM_CredentialInfo;
        }
    }
    public class Cls_getCredentialInfoRequest{
        public cls_ESIHeader ESIHeader;
        public List<String> accountNumbers;
        public cls_account account;
        
        public cls_getCredentialInfoRequest(cls_ESIHeader LCRM_ESIHeader,List<String> LCRM_AccountNumber,cls_account LCRM_acc){
            ESIHeader = LCRM_ESIHeader;
            accountNumbers = LCRM_AccountNumber;
            account=LCRM_acc;
        }
    }
    
    public class Cls_ESIHeader{
    }
    
    public class Cls_account{
            public String action;
            public String salesOrg;
        
        public cls_account(String LCRM_action,String LCRM_salesOrg){
            action=LCRM_action;
            salesOrg =LCRM_salesOrg;
        }
    }
/*    
//Serialize the Request which are recived from external system
*/
    public static String getCredentialReqJsonString(String Credentialaction,String CredentialsalesOrg,List<Source_System_Detail__c> ListofSSD){
        String StrJsonCredential='';
        System.debug('ListofSSD:-'+ListofSSD);
        System.debug('Credentialaction:-'+Credentialaction);
        System.debug('CredentialsalesOrg:-'+CredentialsalesOrg);
        List<String> LCRM_SAPAccNo = new List<String>();
        //Map the Reuest parameters with Object's(SSD) fields value ListofSSD.size()>0
        try{
            if(!ListofSSD.isEmpty()){
                for(Source_System_Detail__c SSD : ListofSSD){
                    if(String.IsNotBlank(SSD.Source_System_Account_Number__c)){
                         LCRM_SAPAccNo.add(SSD.Source_System_Account_Number__c);
                    }
                }//End For Loop
            }//End SSD List Size Checking
            /*
            *To serialize the Credential Request for getting the Json.
            *JSON use to set the Request body
            */
            if( Credentialaction =='CredentialInfo' && CredentialsalesOrg =='WEST' && LCRM_SAPAccNo.size()>0) {
                cls_account ESIAccount = new cls_account(Credentialaction,CredentialsalesOrg);
                cls_ESIHeader ESIHeaderRec = new cls_ESIHeader(); 
                // 
                cls_getCredentialInfoRequest getCredentialInfoRequest= new cls_getCredentialInfoRequest (ESIHeaderRec,LCRM_SAPAccNo,ESIAccount);
                SSDRequestWrapper SSDRequest= new SSDRequestWrapper(getCredentialInfoRequest);
                StrJsonCredential = JSON.serialize(SSDRequest);
                System.debug('StrJsonCredential:'+StrJsonCredential);
            }else{
                //Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Error: '+'No Records are Found!'));
                if(ApexPages.currentPage() != null){
    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                                'Not Found'));
}
            }
        }catch(Exception objException){
            Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Error: '+objException.getMessage()));
        }
        
        return StrJsonCredential;
    } 
 /*
 * RESPONSE WRAPPER 
 *Response parameters or Json received from external system and covert to apex by Dev team 
 */
   
    public class SSDResponseWrapper {
        public GetCredentialInfoResponse getCredentialInfoResponse;
    }
    public class GetCredentialInfoResponse {
        public List<CredentialInfoItemcls> CredentialInfoItem;
        public List<BusinessRestrictionItemcls> BusinessRestrictionItem;
    }
    
    public class CredentialInfoItemcls {
        public String accountNumber{get;set;}
        public String domain{get;set;}
        public String credentialProgress{get;set;}
        public String credentialProgressDesc{get;set;}
        public String credentialStatus{get;set;}
        public String credentialStatusDesc{get;set;}
        public String businessType{get;set;}
        public String businessTypeDesc{get;set;}
        public String restrictionCls{get;set;}
        public String restrictionClsDesc{get;set;}
        public String progessDt{get;set;}
        public String statusDt{get;set;}
        public String responseStatus{get;set;}
        public String responseStatusDescription{get;set;}
    }
    
    public class BusinessRestrictionItemcls {
        public String accountNumber{get;set;}
        public String businessRestriction{get;set;}
        public String businessRestrictionDesc{get;set;}
        public String responseStatus{get;set;}
        public String responseStatusDescription{get;set;}
    }
    
/*
*Purpose:-//Deserialize the Response with Wrapper class Parameters and pass it to CredentialInfoBusinessRestrictionItem
*/
    public static List<CredentialInfoBusinessRestrictionItem> getMatchedCredBusRecord(String jsonResponse){
        //Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Wrapper class****'+jsonResponse));
        List<CredentialInfoBusinessRestrictionItem> ClsCredBusItemlst = new List<CredentialInfoBusinessRestrictionItem>();
        SSDResponseWrapper SSDResWrap = new SSDResponseWrapper();
        try{
        SSDResWrap = (SSDResponseWrapper)System.JSON.deserialize(jsonResponse,SSDResponseWrapper.class);
        if(SSDResWrap.getCredentialInfoResponse.CredentialInfoItem !=null){
            for(CredentialInfoItemcls oitem:SSDResWrap.getCredentialInfoResponse.CredentialInfoItem){
                 System.debug('oitem.responseStatusDescription**'+oitem.responseStatusDescription);
                 if(oitem.responseStatusDescription!='Invalid Account' || oitem.responseStatusDescription!='No Data Found'){
                     System.debug('Account*oitem.responseStatusDescription**'+oitem.responseStatusDescription);
                     
                    System.debug('No Data found **Account*oitem.responseStatusDescription**'+oitem.responseStatusDescription);
                    ClsCredBusItemlst.add(new CredentialInfoBusinessRestrictionItem(oitem));               
                   
                   }
            }//End for
        }
        
        if (SSDResWrap.getCredentialInfoResponse.BusinessRestrictionItem != null){
            for(BusinessRestrictionItemcls oIPitem : SSDResWrap.getCredentialInfoResponse.BusinessRestrictionItem){
                  if(oIPitem.BusinessRestrictionDesc!=null){
                ClsCredBusItemlst.add(new CredentialInfoBusinessRestrictionItem(oIPitem));
                }
            }
        }
        
        } catch(Exception objException) {
             Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Error: '+objException.getMessage()));
        }
        return ClsCredBusItemlst;
    }
    /**** END WRAPPER CREDENTIALINFO****/
/*
* Wrapper is used for Displaing the Credential and Business Restriction information in Same table
*/
    public class CredentialInfoBusinessRestrictionItem{
            public String Domain{get;set;}
            public String AccountNumber{get;set;}
            public String CredentialProgress{get;set;}
            public String CredentialProgressDesc{get;set;}
            public String CredentialStatus{get;set;}
            public String CredentialStatusDesc{get;set;}
            public String BusinessType{get;set;}
            public String BusinessTypeDesc{get;set;}
            public String RestrictionCls{get;set;}
            public String RestrictionClsDesc{get;set;}
            public String ProgessDt{get;set;}
            public String StatusDt{get;set;}
            public String BusinessRestriction{get;set;}
            public String BusinessRestrictionDesc{get;set;}
            public String BusinessAccountnumber{get;set;}
            
        public CredentialInfoBusinessRestrictionItem(CredentialInfoItemcls oCredentialInfoItem) {
            Domain = oCredentialInfoItem.Domain;
            AccountNumber=oCredentialInfoItem.accountNumber;
            CredentialProgress = oCredentialInfoItem.CredentialProgress;
            CredentialProgressDesc = oCredentialInfoItem.CredentialProgressDesc;
            CredentialStatus = oCredentialInfoItem.CredentialStatus;
            CredentialStatusDesc = oCredentialInfoItem.CredentialStatusDesc;
            BusinessType = oCredentialInfoItem.BusinessType;
            BusinessTypeDesc = oCredentialInfoItem.BusinessTypeDesc;
            RestrictionCls = oCredentialInfoItem.RestrictionCls;
            RestrictionClsDesc = oCredentialInfoItem.RestrictionClsDesc;
            ProgessDt = oCredentialInfoItem.ProgessDt;
            StatusDt = oCredentialInfoItem.StatusDt;
        // OnsiteInspectionDt = oCredentialInfoItem.OnsiteInspectionDt;
        
        }
        
        public CredentialInfoBusinessRestrictionItem(BusinessRestrictionItemcls oBusinessRestrictionItem) {
            BusinessRestriction = oBusinessRestrictionItem.BusinessRestriction;
            BusinessRestrictionDesc = oBusinessRestrictionItem.BusinessRestrictionDesc;
            BusinessAccountnumber = oBusinessRestrictionItem.accountNumber;
        }
    }
    //Handle exception from SAP team
    public class ExternalExceptionMessagesWrapper {
        public GetCredentialInfoResponsecls getCredentialInfoResponse;
    }
    
    public class StatusDetailcls {
        public String statusCode{get;set;}
        public String statusDescription{get;set;}
        public String statusDetailMessage{get;set;}
    }
    
    public class GetCredentialInfoResponsecls {
        public StatusDetailcls StatusDetail;
    }
    public static LCRMCredentialJsonWrapper.SSDResponseWrapper parse(String json){
return (LCRMCredentialJsonWrapper.SSDResponseWrapper) System.JSON.deserialize(json, LCRMCredentialJsonWrapper.SSDResponseWrapper.class);
}
    public static list<LCRMCredentialJsonWrapper.CredentialInfoItemcls> getjsonresponse(String jsonResponse){
        list<LCRMCredentialJsonWrapper.CredentialInfoItemcls> credInfoList1 = new list<LCRMCredentialJsonWrapper.CredentialInfoItemcls>();
        LCRMCredentialJsonWrapper.SSDResponseWrapper SSDResWrap = new LCRMCredentialJsonWrapper.SSDResponseWrapper();
        SSDResWrap = parse(jsonResponse);
        
                //SSDResWrap = (LCRMCredentialJsonWrapper.SSDResponseWrapper)System.JSON.deserialize(jsonResponse,LCRMCredentialJsonWrapper.SSDResponseWrapper.class);
        system.debug('test123sh '+SSDResWrap);
                if(SSDResWrap !=null){
     for(LCRMCredentialJsonWrapper.CredentialInfoItemcls oitem : SSDResWrap.getCredentialInfoResponse.CredentialInfoItem)
     
     {
     //oitemres1 = new LCRMCredentialJsonWrapper.CredentialInfoBusinessRestrictionItem(oitem);
        credInfoList1.add(oitem);
        
     }
                    
     }
        return credInfoList1;
    }
    
    public static StatusDetailcls getSAPExceptionMesg(String jsonResponse){
        System.debug('getSAPExceptionMesg jsonResponse**:-'+jsonResponse);
        StatusDetailcls Exptioninfo = new StatusDetailcls ();
        ExternalExceptionMessagesWrapper  exptionmesg = new ExternalExceptionMessagesWrapper ();
        try{
                exptionmesg = (ExternalExceptionMessagesWrapper)System.JSON.deserialize(jsonResponse,ExternalExceptionMessagesWrapper.class);
            if(exptionmesg != null){
                Exptioninfo = exptionmesg.getCredentialInfoResponse.StatusDetail;
            }  
        } catch(Exception objException) {
            Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Error: '+objException.getMessage()));
        }
        System.debug('Exptioninfo:-'+Exptioninfo);
        return Exptioninfo;
    }

}