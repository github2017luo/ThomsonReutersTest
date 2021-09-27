/*
======================================================================================================================
CLASS NAME:  LiveNoteLicenseCode 
======================================================================================================================
=
PURPOSE:    LEGACY CODE

CHANGE HISTORY:
======================================================================================================================
DATE              NAME                    DESC
2017-03-31        Meenakshmi Goswami      Optimized the code as per JIRA STORY: PS0-1
2019-12-10        Shyam Sundar Shet       Endpoint changed from MISSOA to DellBoomi as part of JIRA BMP-1218
======================================================================================================================
*/
public with sharing class LiveNoteLicenseCode {
public ecomTocServicesThomsonComService1LN1.GetLicensesResponse output {get;set;}
public List<ecomTocServicesThomsonComService1LN1.License> licenseList {get;set;}
public Account accnt {get;set;}

public LiveNoteLicenseCode(ApexPages.StandardController stdController){
  accnt = (Account)stdcontroller.getRecord();
  output = new ecomTocServicesThomsonComService1LN1.GetLicensesResponse();
  List<ecomTocServicesThomsonComService1LN1.GetLicensesResponse> outputList = new List<ecomTocServicesThomsonComService1LN1.GetLicensesResponse>();
  licenseList = new List<ecomTocServicesThomsonComService1LN1.License>();
  if(Schema.sObjectType.Account.isAccessible())
  {accnt = [Select Id,Name,SAPAccountNumber__c from Account where Id = :accnt.Id WITH SECURITY_ENFORCED];}
  ecomTocServicesThomsonComService1LN1.SubscriptionServiceV01 stub = new ecomTocServicesThomsonComService1LN1.SubscriptionServiceV01();
  ecomTocServicesThomsonComService1LN1.GetLicensesRequest input = new ecomTocServicesThomsonComService1LN1.GetLicensesRequest();
  
  input.context = new ecomTocServicesThomsonComService1LN1.context_element();
  input.account = new ecomTocServicesThomsonComService1LN1.Account();
  input.context.productId = 'SF03';
  input.account.accountNumber = accnt.SAPAccountNumber__c;
  input.account.companyId = 'West';
  input.licensedProduct = 'LIVENOTE';
  WebServiceSettings__c oWebServiceSettings = AppUtil.getWebServiceSettings('LiveNoteLicenses');
  try{
         String accessToken=DellBoomiTokenGeneration.getAuthToken();
         stub.endpoint_x = oWebServiceSettings.Endpoint__c; // BMP-1218
           // stub.endpoint_x = 'https://api-test.thomsonreuters.com/boomi/subscriptionservice/dev/v1';
            stub.inputHttpHeaders_x = new Map<String, String>();
            stub.timeout_x = (oWebServiceSettings.Timeout__c * 1000).intValue(); //Convert seconds to milliseconds
            //Blob blobCredentials = Blob.valueOf(oWebServiceSettings.Username__c + ':' + oWebServiceSettings.Password__c);
            //string sAuthorizationHeader = 'Basic ' + EncodingUtil.base64Encode(blobCredentials);
            string sAuthorizationHeader = 'Bearer ' +accessToken;
            stub.inputHttpHeaders_x.put('Authorization', sAuthorizationHeader);
            stub.outputHttpHeaders_x = new Map<String,String>();
  
   if(!Test.isRunningTest()){
    output = stub.getLicenses(input);
   }   
  outputList.add(output);
  
  if(Test.isRunningTest()){
    ecomTocServicesThomsonComService1LN1.License ln = new ecomTocServicesThomsonComService1LN1.License();
    List<ecomTocServicesThomsonComService1LN1.License> listLn = new List<ecomTocServicesThomsonComService1LN1.License>();
    ln.keyCode = 'test';
    listLn.add(ln);
    output.licenses = listLn;
  }
    
  if(output.licenses!=null || Test.isRunningTest()){
  for(ecomTocServicesThomsonComService1LN1.License ol : output.licenses){
       ecomTocServicesThomsonComService1LN1.License oLicense = new ecomTocServicesThomsonComService1LN1.License();
       oLicense.keyCode = ol.keyCode;
       oLicense.licenseDesc = ol.licenseDesc;
       oLicense.licenseContact = ol.licenseContact;
       oLicense.issueDate = ol.issueDate;
       oLicense.tokensRequired = ol.tokensRequired;
       oLicense.seats = ol.seats;
       oLicense.webSeats = ol.webSeats;
       oLicense.expirationDate = ol.expirationDate;
       oLicense.productActivated = ol.productActivated;
       licenseList.add(oLicense);
     }
   }          
  }catch(Exception e){
      //IntegrationLogger.addMessage(String.ValueOf(e),accnt.Id, 'Account','', 'Outbound','LiveNoteLicenseCode',false);
       ApexPages.addMessages(e);
  }
 }
 }