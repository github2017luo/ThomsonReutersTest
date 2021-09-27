public without sharing class USLsubscriptionsJsonWrapper {
     public static String error;
     public static String strBody;
     public class USLSubscriptionRequestWrapper {
     public EsiHeadercls esiHeader{get;set;}
     public Accountcls account{get;set;}
     public GetSubscriptionsByAccountFiltercls getSubscriptionsByAccountFilter{get;set;}
        
          public USLsubscriptionRequestWrapper(EsiHeadercls USLesiHeader,Accountcls USLaccount,GetSubscriptionsByAccountFiltercls USLgetSubscriptionsByAccountFilter){
            esiHeader = USLesiHeader;
            account=USLaccount;
            getSubscriptionsByAccountFilter = USLgetSubscriptionsByAccountFilter;
        }
      }
    
    public class EsiHeadercls{
        public String applicationId{get;set;}
        public String companyId{get;set;}
        public String timeStamp{get;set;}
         
        public EsiHeadercls(String USLapplicationId,String USLcompanyId,String USLtimeStamp){
            applicationId=USLapplicationId;
            companyId = USLcompanyId;
            timeStamp = USLtimeStamp;
    }
    }
    public class Accountcls {
        public String accountNumber{get;set;}   //1000550803
        public String language{get;set;}    //EN
        public String companyId{get;set;}   //West
        public String isPrimary;    //true
        public String isActive; //true
        public String applyDate;
    
    public Accountcls(String USLaccountNumber,string USLlanguage,string USLcompanyId,string USLisPrimary,string USLisActive,string USLapplyDate)
    {
        accountNumber=USLaccountNumber;
        language=USLlanguage;
        companyId=USLcompanyId;
        isPrimary=USLisPrimary;
        isActive=USLisActive;
        applyDate=USLapplyDate;
    }
    }
    public class GetSubscriptionsByAccountFiltercls {
        public String partnerType{get;set;}
        public String includeLapsedSubs{get;set;}
        public String includeActiveSubs{get;set;}
        // public List<SortParmcls> sortParm{get;set;}
        
        
        public GetSubscriptionsByAccountFiltercls(String USLsubType,String USLincludeLapsedSubs,String USLincludeActiveSubs){
            partnerType = USLsubType;
            includeLapsedSubs = USLincludeLapsedSubs;
            includeActiveSubs = USLincludeActiveSubs;
              //sortParm = USLsortParm;
        }

}
  public class SortParmcls {
        public String parmName{get;set;}
        public String sortDirection{get;set;}
      }


public class USLSubscriptionResponseWrapper {
    public EsiHeader esiHeader {get;set;} 
    public List<Subscription> subscription {get;set;} 
    public List<Promotion> promotion {get;set;} 
}
    public class CreditCardData_Z {
        public String number_Z {get;set;} // in json: number
        public String cardType {get;set;} 
        public String expiration {get;set;} 
    
}
    public class SubscriptionLines_Z {
        public String quantity {get;set;} 
        public String practiceAreaCode {get;set;} 
        public String programId {get;set;} 
        public String lapseDate {get;set;} 
        public String lapsedReasonDescription {get;set;} 
        public String contentGroupRecordType {get;set;} 
        public List<PriceRates> priceRates {get;set;}       
    }
    
    public class PriceRates {
        public String priceRateType {get;set;} 
        public String  priceRateDescription {get;set;}
         public String  CPCplan {get;set;}
    }
    
    public class Material_Z {
        public String materialNumber {get;set;} 
        public String materialDescription {get;set;}        
    }
    
    public class CreditCardData {
        public String number_Z {get;set;} // in json: number
        public String cardType {get;set;} 
        public String expiration {get;set;}         
    }
    
    public class SubscriptionLines {
        public String subscriptionLineNumber{get;set;}
        public String quantity {get;set;} 
        public String practiceAreaCode {get;set;} 
        public String programId {get;set;} 
        public String lapseDate {get;set;} 
        public String lapsedReasonDescription {get;set;} 
        public String contentGroupRecordType {get;set;} 
        public List<PriceRates> priceRates {get;set;} 
        public String lapseIndicator {get;set;} 
        public String categoryDesc {get;set;} 
        public String topic {get;set;}      
    }
    
    public class EsiHeader {
        public String messageId {get;set;} 
    }
    
    public class Material {
        public String materialNumber {get;set;} 
        public String materialDescription {get;set;} 
        public String materialType {get;set;} 
    }
    
    public class Subscription {
        public String subscriptionNumber {get;set;} 
        public String subscriptionType {get;set;} 
        public Material material {get;set;} 
        public String salesOrgCode {get;set;} 
        public String distributionChannelCode {get;set;} 
        public String division {get;set;} 
        public List<SubscriptionLines> subscriptionLines {get;set;} 
        public String licensedUserCount {get;set;} 
        public String licenseKeyCode {get;set;} 
        public String startDate {get;set;} 
        public String endDate {get;set;} 
        public String storageKey {get;set;} 
        public String brandValue {get;set;} 
        public String priceQuantity {get;set;} 
        public String priceQuantityTypeMaterial {get;set;} 
        public CreditCardData creditCardData {get;set;} 
        public String trialEndDate {get;set;} 
        public String billBlocked {get;set;} 
        public String billInAdvance {get;set;} 
        public String billPlan {get;set;} 
        public String billPlanEndDate {get;set;} 
        public String agreementNumber {get;set;} 
        public String MYRType {get;set;} 
        public String productDependencyType {get;set;} 
        public String MediaType {get;set;}  
    }
    
    public class Promotion {
        public Material_Z material {get;set;} 
        public List<SubscriptionLines_Z> subscriptionLines {get;set;} 
        public CreditCardData_Z creditCardData {get;set;} 

    }
      public class DisplaySubscriptionResponse{
        public String subscriptionNumber {get;set;} 
        public String subscriptionType {get;set;} 
    
        public String materialNumber {get;set;} 
        public String materialDescription {get;set;} 
        public String materialType {get;set;} 
        public String salesOrgCode {get;set;} 
        public String distributionChannelCode {get;set;} 
        public String division {get;set;} 
        public String licensedUserCount {get;set;} 
        public String licenseKeyCode {get;set;} 
        public String startDate {get;set;} 
        public String endDate {get;set;} 
        public String storageKey {get;set;} 
        public String brandValue {get;set;} 
        public String priceQuantity {get;set;} 
        public String priceQuantityTypeMaterial {get;set;} 
		public Boolean isselected{get;set;} //added for DSS-3663
     
        public String trialEndDate {get;set;} 
        public String billBlocked {get;set;} 
        public String billInAdvance {get;set;} 
        public String billPlan {get;set;} 
        public String billPlanEndDate {get;set;} 
        public String agreementNumber {get;set;} 
        public String MYRType {get;set;} 
        public String productDependencyType {get;set;} 
        public String MediaType {get;set;} 
        public String quantity {get;set;} 
        public String practiceAreaCode {get;set;} 
        public String programId {get;set;} 
        public String lapseDate {get;set;} 
        public String lapsedReasonDescription {get;set;} 
        public String contentGroupRecordType {get;set;} 
    
        public String lapseIndicator {get;set;} 
        public String categoryDesc {get;set;} 
        public String topic {get;set;} 
        public String priceRateType {get;set;}
        public String priceRateDescription{get;set;}
        public String CPCplan{get;set;}
        public String cardType {get;set;} 
        public String expiration {get;set;} 
        public String subscriptionLineNumber{get;set;} 
     public DisplaySubscriptionResponse(Subscription subcls){
         subscriptionNumber=subcls.subscriptionNumber;
         subscriptionType=subcls.subscriptionType;
         salesOrgCode=subcls.salesOrgCode;
         distributionChannelCode=subcls.distributionChannelCode;
         licensedUserCount=subcls.licensedUserCount;
         licenseKeyCode=subcls.licenseKeyCode;
         startDate = subcls.startDate;
         endDate = subcls.endDate;
         storageKey=subcls.storageKey;
         brandValue=subcls.brandValue;
         priceQuantity=subcls.priceQuantity;
         priceQuantityTypeMaterial=subcls.priceQuantityTypeMaterial;
         trialEndDate=subcls.trialEndDate;
         billBlocked=subcls.billBlocked;
         billInAdvance=subcls.billInAdvance;
         billPlan=subcls.billPlan;
         billPlanEndDate=USLsubscriptionsJsonWrapper.formatdate(subcls.billPlanEndDate);
         agreementNumber=subcls.agreementNumber;
         MYRType=subcls.MYRType;
         productDependencyType=subcls.productDependencyType;
         Map<String,String> mediamap= new Map<String,String>();
         Mediamap.put('02','CD');
         Mediamap.put('06','Online');
         Mediamap.put('07','Print');
         Mediamap.put('13','Software');
         Mediamap.put('','Others');
         Mediamap.put(NUll,'Others');
         if(subcls.MediaType != '02'&& subcls.MediaType != '06'&& subcls.MediaType != '07'&& subcls.MediaType != '13'){
         subcls.MediaType=Null;
         }
         MediaType=Mediamap.get(subcls.MediaType);      
         cardType=subcls.CreditCardData.cardType;
         expiration=subcls.CreditCardData.expiration;
        
        // SubscriptionLines
         subscriptionLineNumber=subcls.SubscriptionLines[0].subscriptionLineNumber;
         quantity=subcls.SubscriptionLines[0].quantity;
         practiceAreaCode=subcls.SubscriptionLines[0].practiceAreaCode;
         programId=subcls.SubscriptionLines[0].programId;
         lapseDate=subcls.SubscriptionLines[0].lapseDate;
         lapsedReasonDescription=subcls.SubscriptionLines[0].lapsedReasonDescription;
         contentGroupRecordType=subcls.SubscriptionLines[0].contentGroupRecordType;
         lapseIndicator=subcls.SubscriptionLines[0].lapseIndicator;
         categoryDesc=subcls.SubscriptionLines[0].categoryDesc;
         topic=subcls.SubscriptionLines[0].topic;
          
         //priceRates
         priceRateType=subcls.SubscriptionLines[0].priceRates[0].priceRateType;
         priceRateDescription=subcls.SubscriptionLines[0].priceRates[0].priceRateDescription;
          if(subcls.SubscriptionLines[0].priceRates[0].priceRateType =='AD'||subcls.SubscriptionLines[0].priceRates[0].priceRateType =='2N'||subcls.SubscriptionLines[0].priceRates[0].priceRateType =='AS'||subcls.SubscriptionLines[0].priceRates[0].priceRateType =='CA'||subcls.SubscriptionLines[0].priceRates[0].priceRateType =='CD'||subcls.SubscriptionLines[0].priceRates[0].priceRateType =='CH'||subcls.SubscriptionLines[0].priceRates[0].priceRateType =='CI'||subcls.SubscriptionLines[0].priceRates[0].priceRateType =='CJ'||subcls.SubscriptionLines[0].priceRates[0].priceRateType =='CK'||subcls.SubscriptionLines[0].priceRates[0].priceRateType =='CN'||subcls.SubscriptionLines[0].priceRates[0].priceRateType =='CO'||subcls.SubscriptionLines[0].priceRates[0].priceRateType =='CR'||subcls.SubscriptionLines[0].priceRates[0].priceRateType =='CT'||subcls.SubscriptionLines[0].priceRates[0].priceRateType =='CU'||subcls.SubscriptionLines[0].priceRates[0].priceRateType =='CW'||subcls.SubscriptionLines[0].priceRates[0].priceRateType =='CY'||subcls.SubscriptionLines[0].priceRates[0].priceRateType =='NF'||subcls.SubscriptionLines[0].priceRates[0].priceRateType =='PT')
            { 
             CPCplan=Label.USLSubfed;
          }
         else if(subcls.SubscriptionLines[0].priceRates[0].priceRateType=='CE'||subcls.SubscriptionLines[0].priceRates[0].priceRateType=='GV'){
             CPCplan=Label.USLSubsta;
         }
          else if(subcls.SubscriptionLines[0].priceRates[0].priceRateType=='CM'||subcls.SubscriptionLines[0].priceRates[0].priceRateType=='CB'){
             CPCplan=Label.USLCommercial;
         }
          else if(subcls.SubscriptionLines[0].priceRates[0].priceRateType=='CV'){
             CPCplan=Label.USLPro;
         }
         else if(subcls.SubscriptionLines[0].priceRates[0].priceRateType==null||subcls.SubscriptionLines[0].priceRates[0].priceRateType=='')
         {
              CPCplan='';
         }
        //Material
         materialNumber= subcls.Material.materialNumber.removestart('0000000000');
         materialDescription=subcls.Material.materialDescription;
         materialType=subcls.Material.materialType;
         
           }
      }
      
       /*
    *@Authorization form salesforce to SAP System 
    */        
    Public static HttpRequest getHttpRequestCred(String WebServiceName,String jsonString){
    System.debug('USLsubscriptionsJsonWrapper getHttpRequestCred:--');
        WebServiceSettings__c oWebServiceSettings = AppUtil.getWebServiceSettings(WebServiceName);      
        System.debug('oWebServiceSettings:-'+oWebServiceSettings);
        HttpRequest request = new HttpRequest();
        request.setEndpoint(oWebServiceSettings.Endpoint__c);
        request.setMethod('POST');

        // Specify the required user name and password to access the endpoint 
        // As well as the header and header information 
        Blob headerValue = Blob.valueOf(oWebServiceSettings.Username__c + ':' + oWebServiceSettings.Password__c);
        String authorizationHeader = 'Basic ' +
        EncodingUtil.base64Encode(headerValue);

        request.setHeader('Content-Type', 'application/json');
        // Header info with remote server user name and password
        request.setHeader('Authorization', authorizationHeader);
        request.setHeader('Accept', 'application/json');
        // timeout in milliseconds       
        request.setTimeout((oWebServiceSettings.Timeout__c * 1000).intValue());
        System.debug('jsonString:-'+jsonString);
        if(String.IsNotBlank(jsonString)){
        request.setBody(jsonString);
        System.debug('request:-'+request);
        }
     return request; 

    }
      
       /*-------------------------------------------------------------------------------    
        Method to create records for Format Date
    --------------------------------------------------------------------------------*/
    public static String formatdate(String s){
    System.debug('**call formatdate method**');
     String subscriptionDate='';
         if(S.length()>1){
        String year = s.substring(0,4);
        String month= s.substring(4,6);
        String day= s.substring(6,8);
        System.debug('Date-->'+year+'/'+month+'/'+day);
        subscriptionDate = month+'/'+day+'/'+year;
        }
        System.debug('subscriptionDate:-'+subscriptionDate);
        return subscriptionDate;
    }
    
    
      /*-------------------------------------------------------------------------------    
        Method to create records for Return the Response Parameters from SAP System and Use for displaying in VF page
    --------------------------------------------------------------------------------*/  
      public static list<DisplaySubscriptionResponse> getUSLSubscriptionResponse(USLSubscriptionRequestWrapper requestsub){
       System.debug('USLsubscriptionsJsonWrapper getUSLSubscriptionResponse:--');
        //Parameters define
        list<DisplaySubscriptionResponse> listofdisplaySubscriptionResponse =new list<DisplaySubscriptionResponse> ();
        final string SubscriptionWebService = 'USLSubscriptionService';

        // Serialize the value Of
        String subscriptionRequestJson = JSON.serialize(requestsub);
        System.debug('RwquestJson JSON:--**'+subscriptionRequestJson);
        //Deserialze
        Http http = new Http();
        HttpRequest request = new HttpRequest();

        request = getHttpRequestCred(SubscriptionWebService,subscriptionRequestJson);
        HttpResponse Response = http.Send(request);
      System.debug('Response:-'+Response);
        String JsonResponseSubscription=Response.getBody();
        System.debug('JsonResponseSubscription**'+JsonResponseSubscription);
        
        if (Response.getStatusCode() == 200 ) {
            USLSubscriptionResponseWrapper SSDsubscriptionResp = new  USLSubscriptionResponseWrapper();
            SSDsubscriptionResp = (USLSubscriptionResponseWrapper)System.JSON.deserialize(JsonResponseSubscription,USLSubscriptionResponseWrapper.class);
           System.debug('SSDsubscriptionResp:-'+SSDsubscriptionResp);
           if(SSDsubscriptionResp.subscription==null){
                ESC_HandlerCustomException es=new ESC_HandlerCustomException();
                es.setmessage('No Subscriptions available for this Account number');
                throw es;
           }else{
            for(Subscription sub :SSDsubscriptionResp.subscription)
            {
                listofdisplaySubscriptionResponse.add(new DisplaySubscriptionResponse(sub));
             
            }
        }
             System.debug('listofdisplaySubscriptionResponse:-'+listofdisplaySubscriptionResponse);
                }
          
        else{
             ESC_HandlerCustomException es=new ESC_HandlerCustomException();
                es.setmessage(Label.LCRMWebServiceError);
                throw es;
        }
        return listofdisplaySubscriptionResponse;
    }
 
}