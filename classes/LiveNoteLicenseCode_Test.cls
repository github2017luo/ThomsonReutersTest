/**
======================================================================================================================
TEST CLASS NAME: LiveNoteLicenseCode_Test
======================================================================================================================
PURPOSE:    Validates the functionality provided by the LiveNoteLicenseCode class.

CHANGE HISTORY:
======================================================================================================================
  DATE                  NAME                           DESC

2017-03-31            Karthi                     Optimized the coverage as per JIRA STORY: PS0-1
======================================================================================================================
*/
@istest (SeeAllData=false)
public with sharing class LiveNoteLicenseCode_Test{

    // testMethod for the controller

    private static testMethod void testController(){
        
       
        UnitTest.createOptiTestData();
        Account testAcc1 = UnitTest.getAccountInstance();
        testAcc1.sapAccountNumber__C = '512345';
        testAcc1.CompanyCodeDescription__c = '0010';
        testAcc1.Sales_Org__c = 'WEST';
        testAcc1.DistributionChannel__c = 'W';
        testAcc1.DivisionCodeDescription__c = 'W';
        testAcc1.parentid =null;
        insert testAcc1;
        Account testAcc2 = UnitTest.getAccountInstance();
        testAcc2.parentid = testAcc1.id;   
        insert testacc2;
        
        WebServiceSettings__c ws1= new WebServiceSettings__c();
        ws1.Name='Dellboomi SFDC Legal';
        ws1.Username__c='Username';
        ws1.Password__c='Password';
        ws1.Endpoint__c='https://dev.api.apigarden-qa.thomsonreuters.com/boomi/oauth2/token';
        ws1.Service_Unavailable_Message__c='Service_Unavailable';
        insert ws1;
        
        WebServiceSettings__c ws2= new WebServiceSettings__c();
        ws2.Name= 'LiveNoteLicenses';
        ws2.Username__c= 'Username1';
        ws2.Password__c='Password1';
        ws2.Endpoint__c='https://api.thomsonreuters.com/ebs/entitlement/getEntitlements/boomi/oauth2/token';
        ws2.Service_Unavailable_Message__c='Service_Unavailable';
        insert ws2;
        
   
        Test.startTest(); 
        Test.setMock(HttpCalloutMock.class, new DellBoomiTokenGeneration_Test.DellBoomiCalloutMock());
        ApexPages.standardController sc = new ApexPages.standardController(testAcc1);
        Test.setCurrentPageReference(Page.LiveNoteKeyCodes);
        LiveNoteLicenseCode controller = new LiveNoteLicenseCode(sc);  
        Test.stopTest();
        
        //WebServiceSettings__c objWBSSetting = AppUtil.getWebServiceSettings('LiveNoteLicenses');
        
         ecomTocServicesThomsonComService1LN1.BandRange br = new ecomTocServicesThomsonComService1LN1.BandRange();
         ecomTocServicesThomsonComService1LN1.getSubscriptionsByAccount_element gtSub = new ecomTocServicesThomsonComService1LN1.getSubscriptionsByAccount_element();
         ecomTocServicesThomsonComService1LN1.getSubscriptionsByAccountResponse_element gtSub1 = new ecomTocServicesThomsonComService1LN1.getSubscriptionsByAccountResponse_element();
         ecomTocServicesThomsonComService1LN1.SubscriptionServiceerror subError = new ecomTocServicesThomsonComService1LN1.SubscriptionServiceerror();
         ecomTocServicesThomsonComService1LN1.material material = new ecomTocServicesThomsonComService1LN1.material();
         ecomTocServicesThomsonComService1LN1.getLicensesResponse_element lElement = new ecomTocServicesThomsonComService1LN1.getLicensesResponse_element();
         ecomTocServicesThomsonComService1LN1.GetSubscriptionsFilter subFilter = new ecomTocServicesThomsonComService1LN1.GetSubscriptionsFilter();
         ecomTocServicesThomsonComService1LN1.PurchaseOrder po = new ecomTocServicesThomsonComService1LN1.PurchaseOrder();
         ecomTocServicesThomsonComService1LN1.CtcType ctc = new ecomTocServicesThomsonComService1LN1.CtcType();
         ecomTocServicesThomsonComService1LN1.getLicenses_element lElement1 = new ecomTocServicesThomsonComService1LN1.getLicenses_element();
         ecomTocServicesThomsonComService1LN1.Subscription s = new ecomTocServicesThomsonComService1LN1.Subscription();
         ecomTocServicesThomsonComService1LN1.Classification c = new ecomTocServicesThomsonComService1LN1.Classification();
         ecomTocServicesThomsonComService1LN1.GetSubscriptionsByAccountResponse g = new ecomTocServicesThomsonComService1LN1.GetSubscriptionsByAccountResponse();
         ecomTocServicesThomsonComService1LN1.CreditCardData cc = new ecomTocServicesThomsonComService1LN1.CreditCardData();
         ecomTocServicesThomsonComService1LN1.SubscriptionLineItem subLine = new ecomTocServicesThomsonComService1LN1.SubscriptionLineItem();
         
        
         
         
        } 
       
}