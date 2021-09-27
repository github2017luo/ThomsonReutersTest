/*
======================================================================================================================
CLASS NAME:    LCRMsubscriptionsJsonWrapper 
======================================================================================================================
=
PURPOSE:    GLIEDW, this wrapper is used for serialized and deserialized Json Request and response .

CHANGE HISTORY:
======================================================================================================================
DATE              NAME                    DESC
10/26/2017       Radhika Pawar     [CRM-7821] [SFDC DEV] Code behind the Subscription button on the account
======================================================================================================================
*/
public without sharing class LCRMsubscriptionsJsonWrapper{
  //Integration Logger Paramters
    public static String error;
    public static String strBody;
    /*------------Subscription Request ---------*/
    public class LCRMSubscriptionRequestWrapper {
        public EsiHeadercls esiHeader{get;set;}
        public List<Accountcls> account{get;set;}
        public GetSubscriptionsByAccountFiltercls getSubscriptionsByAccountFilter{get;set;}
        
        public LCRMSubscriptionRequestWrapper(EsiHeadercls lCRMesiHeader,List<Accountcls> lCRMaccount,GetSubscriptionsByAccountFiltercls lCRMgetSubscriptionsByAccountFilter){
            esiHeader = lCRMesiHeader;
            account=lCRMaccount;
            getSubscriptionsByAccountFilter = lCRMgetSubscriptionsByAccountFilter;
        }
    }
    
    public class EsiHeadercls {
        public String applicationId{get;set;}
        public String companyId{get;set;}
        public String postBackURL{get;set;}
        
        public EsiHeadercls(String lCRMapplicationId,String lCRMcompanyId,String lCRMpostBackURL){
            applicationId=lCRMapplicationId;
            companyId = lCRMcompanyId;
            postBackURL = lCRMpostBackURL;
        }
    }
    
    public class Accountcls {
        public String accountNumber{get;set;}
        
        /*public Accountcls(String LCRMaccountNumber){
            accountNumber = LCRMaccountNumber;
        }*/
    }

    public class GetSubscriptionsByAccountFiltercls {
        public String subType{get;set;}
        public String includeLapsedSubs{get;set;}
        public String includeActiveSubs{get;set;}
        public String startRecord{get;set;}
        public String endRecord{get;set;}
        public String totalRecords{get;set;}
        public String maxResults{get;set;}
        public List<SortParmcls> sortParm{get;set;}
        
        public GetSubscriptionsByAccountFiltercls(String lCRMsubType,String lCRMincludeLapsedSubs,String lCRMincludeActiveSubs,String lCRMstartRecord,String lCRMendRecord,String lCRMtotalRecords,String lCRMmaxResults,List<SortParmcls> lCRMsortParm){
            subType = lCRMsubType;
            includeLapsedSubs = lCRMincludeLapsedSubs;
            includeActiveSubs = lCRMincludeActiveSubs;
            startRecord =lCRMstartRecord;
            endRecord =lCRMendRecord;
            totalRecords = lCRMtotalRecords;
            maxResults =lCRMmaxResults;
            sortParm = lCRMsortParm;
        }
    }

    public class SortParmcls {
        public String parmName{get;set;}
        public String sortDirection{get;set;}
      }
      
      
/*
*  Subscription Json response deserialized using below class
*/  
    public class AccountRes {
        public String accountNumber{get;set;}
    }

    public class PriceRatescls {
        public String priceRateType{get;set;}
        public String priceRate{get;set;}
    }

    public class BandRangecls {
        public Integer userCount{get;set;}
    }

    public class Classificationscls {
        public String classificationName{get;set;}
        public String classificationType{get;set;}
    }

    public class LCRMSubscriptionResponseWrapper {
        public List<StatusDetailscls> statusDetails{get;set;}
        public List<Subscriptioncls> subscription{get;set;}
    }

    public class StatusDetailscls {
        public String statusCode{get;set;}
        public String statusDescription{get;set;}
    }

    public class SubscriptionLinescls {
        public String subscriptionLineNumber{get;set;}
        public Integer quantity{get;set;} 
        public String practiceAreaCode{get;set;}
        public String practiceAreaDescription{get;set;}
        public String locationCode{get;set;}
        public String locationDescription{get;set;}
        public String dealId{get;set;}
        public String lapseDate{get;set;}
        public String lapsedReasonCode{get;set;}
        public String lapsedReasonDescription{get;set;}
        public String contentGroupNumber{get;set;}
        public String titleId{get;set;}
        public Boolean autoRenewFlag{get;set;}
        //public Integer firstYearDiscount{get;set;}
        public decimal firstYearDiscount{get;set;}
        public decimal netAmount{get;set;}
        public List<PriceRatescls> priceRates{get;set;}
    }

    public class Adjustmentscls {
        public String discountCode{get;set;}
        public String discountAmount{get;set;}
        public String discountPercent{get;set;}
        public String discountReason{get;set;}
    }

    public class Materialcls {
        public String materialNumber{get;set;}
        public String materialDescription{get;set;}
    }

    public class Subscriptioncls {
        public String subscriptionNumber{get;set;}
        public String subscriptionType{get;set;}
        public String subscriptionStatus{get;set;}
        public Materialcls material{get;set;}
        public List<Adjustmentscls> adjustments{get;set;}
        public List<AccountRes> account{get;set;}
        public List<SubscriptionLinescls> subscriptionLines{get;set;}
        public BandRangecls bandRange{get;set;}
        public String startDate{get;set;}
        public String endDate{get;set;}
        public List<Classificationscls> classifications{get;set;}
        public String storageKey{get;set;}
        public List<String> levelCode{get;set;}
        public List<String> levelValue{get;set;}
    }  
    
  // Use for display in VF Page
  public class DisplaySubscriptionResponse{
        
    public String subscriptionNumber{get;set;}
    public String subscriptionType{get;set;}
    public String subscriptionStatus{get;set;}
    public String storageKey{get;set;}
    public String levelCode{get;set;}
    public String levelValue{get;set;}
    public Boolean isselected{get;set;} //added for DSS-3663
    //account
    public String sapAccountNumber{get;set;}
    //material number
    public String materialNumber{get;set;}
    public String materialDescription{get;set;}
    //Adjustmentscls
    public String discountCode{get;set;}
    public String discountAmount{get;set;}
    public String discountPercent{get;set;}
    public String discountReason{get;set;}
    //bandRange
    public Integer userCount{get;set;}
    //
    public String startDate{get;set;}
    public String endDate{get;set;}

    //classifications
    public String classificationName{get;set;}
    public String classificationType{get;set;}
    //   subscriptionLines
    public String subscriptionLineNumber{get;set;}
    public Integer quantity{get;set;}   
    public String practiceAreaCode{get;set;}
    public String practiceAreaDescription{get;set;}
    public String locationCode{get;set;}
    public String locationDescription{get;set;}
    public String dealId{get;set;}
    public String lapseDate{get;set;}
    public String lapsedReasonCode{get;set;}
    public String lapsedReasonDescription{get;set;}
    public String contentGroupNumber{get;set;}
    public String titleId{get;set;}
    public Boolean autoRenewFlag{get;set;}
    public Decimal firstYearDiscount{get;set;}
    public decimal netAmount{get;set;}
    
    //As per Existing Functionality
    //Following are additional columns apart from the ones sent from webservice
    public id productid{get;set;}         
    public Decimal totalEstimatedUpkeep{get;set;}        
    public Decimal discountPerUnit{get;set;}
    public Decimal totalPrintDiscount{get;set;}
    public Decimal totalUpkeepAfterDiscount{get;set;}
    public Decimal minimumIncremental{get;set;}
    
    //Only Used for showing Exception 
    public String statusCode{get;set;}
    public String statusDescription{get;set;}
    
      //Price Rate
    public String priceRateType{get;set;}
    public String priceRate{get;set;}
    
    public DisplaySubscriptionResponse(Subscriptioncls subcls){
        System.debug('subcls:-'+subcls);
        subscriptionNumber = subcls.subscriptionNumber;
        subscriptionType = subcls.subscriptionType;
        subscriptionStatus = subcls.subscriptionStatus;
        storageKey = subcls.storageKey;
        startDate =  LCRMsubscriptionsJsonWrapper.formatdate(subcls.startDate);
        endDate = LCRMsubscriptionsJsonWrapper.formatdate(subcls.endDate);
        System.debug('Account Size :-'+subcls.account.size());
        if(subcls.account.size()==1){
        sapAccountNumber = subcls.account[0].accountNumber;
        }
        
        materialNumber = subcls.material.materialNumber;
        materialDescription = subcls.material.materialDescription;
        userCount = subcls.bandRange.userCount;
        
        //Adjustment
        discountCode = subcls.adjustments[0].discountCode;
        discountAmount=subcls.adjustments[0].discountAmount;
        discountPercent=subcls.adjustments[0].discountPercent;
        discountReason=subcls.adjustments[0].discountReason;
        //subscriptionLines
        subscriptionLineNumber = subcls.subscriptionLines[0].subscriptionLineNumber;
        quantity = subcls.subscriptionLines[0].quantity;
        practiceAreaCode = subcls.subscriptionLines[0].practiceAreaCode;
        practiceAreaDescription = subcls.subscriptionLines[0].practiceAreaDescription;
        locationCode = subcls.subscriptionLines[0].locationCode;
        locationDescription = subcls.subscriptionLines[0].locationDescription;
        dealId = subcls.subscriptionLines[0].dealId;
        lapseDate = LCRMsubscriptionsJsonWrapper.formatdate(subcls.subscriptionLines[0].lapseDate);
        lapsedReasonCode = subcls.subscriptionLines[0].lapsedReasonCode;
        lapsedReasonDescription = subcls.subscriptionLines[0].lapsedReasonDescription;
        contentGroupNumber = subcls.subscriptionLines[0].contentGroupNumber;
        titleId = subcls.subscriptionLines[0].titleId;
        autoRenewFlag = subcls.subscriptionLines[0].autoRenewFlag;
        firstYearDiscount = subcls.subscriptionLines[0].firstYearDiscount;
        netAmount = subcls.subscriptionLines[0].netAmount;
        priceRateType = subcls.subscriptionLines[0].priceRates[0].priceRateType;
        priceRate = subcls.subscriptionLines[0].priceRates[0].priceRate;
        
        //classifications
        classificationName = subcls.classifications[0].classificationName;
        classificationType = subcls.classifications[0].classificationType;
        
        //
        levelCode=subcls.levelCode[0];
        levelValue=subcls.levelValue[0];
        
         //---initialize additional columns - Value set as default
          totalEstimatedUpkeep = 0.0;        
          discountPerUnit = 0.0;
          totalPrintDiscount = 0.0;
          totalUpkeepAfterDiscount = 0.0;
          minimumIncremental = 0.0;
        
    }
    
    // Status Details
    public DisplaySubscriptionResponse(StatusDetailscls statusInfo){
    statusCode = statusInfo.statusCode;
    statusDescription = statusInfo.statusDescription;    
    }
    
    } 
    
   /*
   Get the Product information which are present in salesforce
   */
    
   public static void getProducts(List<DisplaySubscriptionResponse> oSubList){
        System.debug('**Method called getProducts**');
        System.debug('oSubList:-'+oSubList);
        if(oSubList != null){       
            List<string> materialNumList = new List<string>();
            List<product2> oProd = new list<product2>();
            Map<string,id> materialnumIdMap = new Map<string,id>();
            for(DisplaySubscriptionResponse oSub: oSubList){
            if(String.isnotblank(oSub.MaterialNumber)){  
                materialNumList.add(oSub.MaterialNumber); 
            }
            } 
        System.debug('materialNumList:-'+materialNumList);
        if(Schema.sObjectType.product2.isAccessible() || Schema.sObjectType.product2.isQueryable()){             
        oProd= [select id,ProductCode from product2 where ProductCode in: materialNumList];
        }
        System.debug('oProd:-'+oProd);
        for(product2 p:oProd ){
            materialnumIdMap.put(p.ProductCode,p.id);
            System.debug('materialnumIdMap:-'+materialnumIdMap);                           
        }
        System.debug('oSubList:-'+oSubList);
        for(DisplaySubscriptionResponse oSub: oSubList){
        System.debug('oSub.MaterialNumber'+oSub.MaterialNumber);
            if(oSub.MaterialNumber != null) {
            if(materialnumIdMap.containsKey(oSub.MaterialNumber)){ 
            oSub.productid=materialnumIdMap.get(oSub.MaterialNumber); 
            }
            System.debug(' oSub.productid:-'+ oSub.productid);
            }    
        }
        materialNumList=null;
        oProd = null;
        materialnumIdMap =null;
        System.debug(' materialNumList:-'+materialNumList+'*oProd*'+oProd+'**materialnumIdMap**'+materialnumIdMap);
        }    
    } 
     /*
    *@Authorization form salesforce to SAP System 
    */        
    Public static HttpRequest getHttpRequestCred(String webserviceName,String jsonString){
    System.debug('LCRMsubscriptionsJsonWrapper getHttpRequestCred:--');
        WebServiceSettings__c oWebServiceSettings = AppUtil.getWebServiceSettings(webserviceName);      
        System.debug('oWebServiceSettings:-'+oWebServiceSettings);
        HttpRequest request = new HttpRequest();
        request.setEndpoint('callout:LCRMSubscriptionServices');
        request.setMethod('GET');

        // Specify the required user name and password to access the endpoint 
        // As well as the header and header information 
        //Blob headerValue = Blob.valueOf(oWebServiceSettings.Username__c + ':' + oWebServiceSettings.Password__c);
        //String authorizationHeader = 'Basic ' +
        //EncodingUtil.base64Encode(headerValue);

        request.setHeader('Content-Type', 'application/json');
        // Header info with remote server user name and password
        //request.setHeader('Authorization', authorizationHeader);
        //request.setHeader('Accept', 'application/json');
        // timeout in milliseconds       
        //request.setTimeout((oWebServiceSettings.Timeout__c * 1000).intValue());
        System.debug('jsonString:-'+jsonString);
        if(String.IsNotBlank(jsonString)){
        request.setBody(jsonString);
        System.debug('request:-'+request);
        }
     return request; 

    }
    /*-------------------------------------------------------------------------------    
        Method to create records for Return the response Parameters from SAP System and Use for displaying in VF page
    --------------------------------------------------------------------------------*/  
      public static list<DisplaySubscriptionResponse> getLcrmSubscriptionResponse(LCRMSubscriptionRequestWrapper requestsub){
       System.debug('LCRMsubscriptionsJsonWrapper getLcrmSubscriptionResponse:--');
        //Parameters define
        list<DisplaySubscriptionResponse> listofdisplaySubscriptionResponse =new list<DisplaySubscriptionResponse> ();
        final string SubscriptionWebService = 'LCRMSubscriptionServices';

        // Serialize the value Of
        String subscriptionRequestJson = JSON.serialize(requestsub);
        System.debug('RwquestJson JSON:--**'+subscriptionRequestJson);
        //Deserialze
        Http http = new Http();
        HttpRequest request = new HttpRequest();

        request = getHttpRequestCred(SubscriptionWebService,subscriptionRequestJson);
        HttpResponse response = http.Send(request);
        System.debug('response:-'+response);
        System.debug(''+response.getBody());
        System.debug(''+response.getBody());
        String jsonResponseSubscription=response.getBody();
        System.debug('jsonResponseSubscription**'+jsonResponseSubscription);
        //
        if (response.getStatusCode() == 200 ) {
            LCRMSubscriptionResponseWrapper ssdsubscriptionResp = new  LCRMSubscriptionResponseWrapper();
            ssdsubscriptionResp = (LCRMSubscriptionResponseWrapper)System.JSON.deserialize(jsonResponseSubscription,LCRMSubscriptionResponseWrapper.class);
            System.debug('ssdsubscriptionResp:-'+ssdsubscriptionResp);
            // Crete different Ways
            System.debug('statusDetails**:-'+ssdsubscriptionResp.statusDetails.size());
            // System.debug('subscription **:-'+ssdsubscriptionResp.subscription.size());
            //System.debug('ssdsubscriptionResp.subscription:**'+ssdsubscriptionResp.subscription);

            if(ssdsubscriptionResp.statusDetails.size() == 1 && ssdsubscriptionResp.statusDetails[0].statusCode =='200' && ssdsubscriptionResp.statusDetails[0].statusDescription == 'SUCCESS'){
                if(ssdsubscriptionResp.subscription.size()>0){
                    if(ssdsubscriptionResp.subscription.size()>0){
                    for(Subscriptioncls subitem : ssdsubscriptionResp.subscription){
                        DisplaySubscriptionResponse subItemResponse = new DisplaySubscriptionResponse(subitem);
                        listofdisplaySubscriptionResponse.add(subItemResponse);
                    }
                    getProducts(listofdisplaySubscriptionResponse);
                    }
                }

            }
            
            if(ssdsubscriptionResp.statusDetails.size() == 1 && ssdsubscriptionResp.statusDetails[0].statusCode !='200'){
                       System.debug('Status Informationif exception Returned:**'+ssdsubscriptionResp.statusDetails[0].statusCode);
                    for(StatusDetailscls statusInfo : ssdsubscriptionResp.statusDetails){
                        DisplaySubscriptionResponse subscriptionstatusResponse = new DisplaySubscriptionResponse(statusInfo);
                        listofdisplaySubscriptionResponse.add(subscriptionstatusResponse);
                    }
                     /*
                    strBody = 'Exception received.';
                    error = 'Got the Exception Status Code'+ssdsubscriptionResp.statusDetails[0].statusCode+' and get the Exception Status '+ssdsubscriptionResp.statusDetails[0].statusDescription;
                    System.debug('strBody'+strBody+'error'+error);
                    logException(strBody, error, SubscriptionWebService);
                    */
                }
            System.debug('listofdisplaySubscriptionResponse:-'+listofdisplaySubscriptionResponse);
            System.debug('listofdisplaySubscriptionResponse Size:-'+listofdisplaySubscriptionResponse.size());
        }else{
            System.debug('response.getStatusCode():-'+response.getStatusCode());
             Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,Label.LCRMWebServiceError));
            
            strBody = 'Exception received.';
            error = 'Got the response Status Code'+response.getStatusCode()+' and got the response Status '+response.getStatus();
            System.debug('strBody'+strBody+'error'+error);
            logException(strBody, error, SubscriptionWebService);
            
          
        }
        return listofdisplaySubscriptionResponse;
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
        Method to create records for Integration_Logger
    --------------------------------------------------------------------------------*/
    public static void logException(string strBody, string error, String webserviceName) {
        try{
            System.debug('**call logException method**');
            WebServiceSettings__c oWebServiceSettings = AppUtil.getWebServiceSettings(webserviceName); 
            Integration_Logger__c intLog = new Integration_Logger__c();
            intLog.Object_Name__c = 'Source System Detail';
            intLog.Exception_Message__c = error;
            intLog.Request_Message__c = strBody;
            intLog.Request_Type__c = 'Outbound';
            intLog.Service_Name__c = webserviceName;
            intLog.Object_Id__c = '01I1300000224X1EAI';
            database.insert(intLog,false); 
            System.debug('intLog'+intLog);
        } catch(Exception e){
             ApexPages.addMessages(e);
        }
           
     }
     
      /*-------------------------------------------------------------------------------    
        Method to Show UI Error messages using Custom SSetting
    --------------------------------------------------------------------------------*/
    public static void subscriptionExceptionHandling(String statusCode, String statusDescription,String webserviceName,String salesOrg ){
        System.debug('**Called subscriptionExceptionHandling Method***'+statusCode+''+statusDescription+''+webserviceName);
        String uniqueValueExp = '';
        String existingvalue = '';
        String matchedStatusDetailinfo = '';
        map<String,String> mapOfExceptionInfo = new map<String,String>();
        matchedStatusDetailinfo = webserviceName+statusCode+statusDescription;
        System.debug('matchedStatusDetailinfo :-'+matchedStatusDetailinfo );
        List<LCRM_Exception_Handling__c> lstofExceptionInfo = LCRM_Exception_Handling__c.getall().values();
        System.debug('lstofExceptionInfo:-'+lstofExceptionInfo);
        
        For(LCRM_Exception_Handling__c expHandling : lstofExceptionInfo)
        {
            uniqueValueExp =expHandling.Webservice_Name__c+expHandling.Status_Code__c+expHandling.Status_Description__c;
            System.debug('uniqueValueExp:-'+uniqueValueExp);
            if(mapOfExceptionInfo.containsKey(uniqueValueExp))
            {
                existingvalue = mapOfExceptionInfo.get(expHandling.UI_Error_Message_English__c);
                System.debug('---->'+existingvalue);
                mapOfExceptionInfo.put(uniqueValueExp,existingvalue);
            }
            else
            {
                mapOfExceptionInfo.put(uniqueValueExp,expHandling.UI_Error_Message_English__c);
                System.debug('Not contain value---->'+mapOfExceptionInfo);
            }
        }
        System.debug('mapOfExceptionInfo value---->'+mapOfExceptionInfo.values());
        System.debug('mapOfExceptionInfo KeySet---->'+mapOfExceptionInfo.Keyset());
        If(mapOfExceptionInfo.containsKey(matchedStatusDetailinfo)){
            // Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,''+mapOfExceptionInfo.get(matchedStatusDetailinfo)));    
            // System.debug('matched Error Information**:-'+mapOfExceptionInfo.get(matchedStatusDetailinfo));
            if( matchedStatusDetailinfo.contains('Invalid Sales Org Value')){
                Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,salesOrg+' is '+mapOfExceptionInfo.get(matchedStatusDetailinfo)));  
                System.debug('matched Error Information**:-'+mapOfExceptionInfo.get(matchedStatusDetailinfo));                      
            }else{
                Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,''+mapOfExceptionInfo.get(matchedStatusDetailinfo)));    
                System.debug('matched Error Information**:-'+mapOfExceptionInfo.get(matchedStatusDetailinfo));          
            }
        
        }else{
            Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,Label.LCRMWebServiceError));
            
            System.debug('**statusCode:**'+statusCode+'**statusDescription**'+statusDescription);
            
            strBody = 'Exception received.';
            error = 'Got the Exception Status Code'+statusCode+' and get the Exception Status '+statusDescription;
            System.debug('strBody'+strBody+'error'+error);
            logException(strBody, error, 'LCRMSubscriptionServices');
        }
        
        
    }
     
        
}