@IsTest
private class WebserviceResponseHandler_Test {
    
    public static testMethod Void testupdateQuoteOnRemoveSuccess(){
        //Test.StartTest();
        UnitTest.createOptiTestData();
        UnitTest.createTestData();
        
        Account a1 = UnitTest.getaccountInstance();
        Insert a1;
        
        Opportunity Op1 = new Opportunity(name='Test Opty',AccountId=a1.id,StageName='75%',Closedate=System.today());
        Op1.SAP_Quotation_Document_number__c='123123';
        Insert op1;
        
        Quote Q1 = new Quote();
        Q1.name = 'test';
        Q1.OpportunityId = op1.Id;
        Insert Q1;
        
        List<Quote> lstQuote = new List<Quote>();
        lstQuote.add(Q1);
        //Test.StopTest();
        Renewal_Request__c rq1=new Renewal_Request__c(Quote__c=q1.id, Remove_Reason__c='Trial', Remove_Comments__c='Test removal', Was_There_a_Competitor__c='Yes', Competitor_Name__c='Aderant');
        Insert rq1;
        
        Test.startTest();
        KeyValueListStore__c kv1 = new KeyValueListStore__c();
        kv1.name='BigRuleProductId';
        kv1.TextValue__c='Test value';
        Insert kv1;
        
        KeyValueListStore__c kv2 = new KeyValueListStore__c();
        kv2.name='BigRuleCconfigGroup';
        kv2.TextValue__c='Test value';
        Insert kv2; 
        
        WebServiceSettings__c ws1= new WebServiceSettings__c();
        ws1.Name='Dellboomi SFDC Legal';
        ws1.Username__c='Username';
        ws1.Password__c='Password';
        ws1.Endpoint__c='https://dev.api.apigarden-qa.thomsonreuters.com/boomi/oauth2/token';
        ws1.Service_Unavailable_Message__c='Service_Unavailable';
        insert ws1;
        
        
        //Test.setMock(HttpCalloutMock.class, new DellBoomiTokenGeneration_Test.DellBoomiCalloutMock());
        
       
        
        ecomRenewalWebservice.SubRenewalServiceV01 objSRS = new ecomRenewalWebservice.SubRenewalServiceV01();
        ecomRenewalWebservice.context_element objConEle = new ecomRenewalWebservice.context_element();
        objConEle.productId = KeyValueListStore__c.getInstance('BigRuleProductId').TextValue__c; //'SF03';
        objConEle.configGroup = KeyValueListStore__c.getInstance('BigRuleCconfigGroup').TextValue__c; //'WRP';
        WebServiceSettings__c objWBSSetting = AppUtil.getWebServiceSettings('RemoveRenewalRequest');
        
        
        
        WebserviceResponseHandler.updateQuoteOnRemoveSuccess(lstQuote,'Test');
        WebserviceResponseHandler.createNewCase(Q1,'Full Cancellation');
        WebserviceResponseHandler.createNewCase(Q1,'Remove Renewal');
        WebserviceResponseHandler.updateSAPQuote('01');
        Test.stopTest();
    
        
    }
    
    
}