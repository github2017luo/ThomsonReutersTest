/**
 * Test class to validate the functionality provided by the createQuote class 
 *
 * @author  Anshita Sharma
 * @version  2013-03-22
 *
 * CHANGE HISTORY
 * =================================================================================================================================================
 * Date         Name                    Description
 * 2013-03-22   Anshita Sharma            Created         
 * =================================================================================================================================================
**/

@isTest
public class createQuote_Test{
    
    public static testMethod void testCreateQuote() {
        Profile p = [SELECT Id FROM profile WHERE name='System Administrator'];   
        //UserRole psRole = [SELECT Id FROM UserRole WHERE DeveloperName = 'Legal' limit 1];
        User u1;
        System.runAs ( new User(Id = UserInfo.getUserId()) ) {
            u1 = new User(alias = 'User1', email='user1@tr.com', 
                           emailencodingkey='UTF-8', lastname='Testing12', languagelocalekey='en_US', 
                           localesidkey='en_US', profileid = p.Id, employeenumber='0144020',
                           Sales_Org__c = 'GLI', timezonesidkey='America/Los_Angeles', username='usertest123@tr.com');        
        insert u1;
        }
        UnitTest.createTestData();
        
        Account oAccount = new Account();
        oAccount.Name = 'Unit Test';
        oAccount.Sales_Org__c = 'WEST';
        oAccount.Customer_Type__c = 'Individual';
        oAccount.Customer_Group__c = 'ACADEMIC';
        oAccount.Industry = 'ACADEMIA';
        oAccount.BillingStreet = '275 BATTERY ST STE 1500';
        oAccount.BillingCity = 'SAN FRANCISCO';
        oAccount.BillingState = 'CA';
        oAccount.BillingPostalCode = '94111-3334';
        oAccount.BillingCountry = 'US';
        oAccount.Tax_Number_Type__c='C.I.';
        oAccount.Tax_Number__c='12345';
        oAccount.Is_Customer_Review_Complete__c=true;
        MDBIntegrationUtil_Test.setupUpsertAccountServiceSettings();
        MDBIntegrationUtil_Test.setupMockUpsertAccountSuccessResponse();
        insert oAccount;
        
        Account oAccount1 = new Account();
        oAccount1.Name = 'Unit Test';
        oAccount1.Sales_Org__c = 'WEST';
        oAccount1.Customer_Type__c = 'Individual';
        oAccount1.Customer_Group__c = 'ACADEMIC';
        oAccount1.Industry = 'ACADEMIA';
        oAccount1.BillingStreet = '275 BATTERY ST STE 1500';
        oAccount1.BillingCity = 'SAN FRANCISCO';
        oAccount1.BillingState = 'CA';
        oAccount1.BillingPostalCode = '94111-3334';
        oAccount1.BillingCountry = 'US';
        oAccount1.Tax_Number_Type__c='C.I.';
        oAccount1.Tax_Number__c='12345';
        oAccount1.Is_Customer_Review_Complete__c=true;
        MDBIntegrationUtil_Test.setupUpsertAccountServiceSettings();
        MDBIntegrationUtil_Test.setupMockUpsertAccountSuccessResponse();
        insert oAccount1; 
        
       
        
        List<OpportunityLineItem> oliList1 = new List<OpportunityLineItem>(); 
        
        Opportunity oOpportunity = new Opportunity();
        oOpportunity.AccountId = oAccount.Id;
        oOpportunity.Name = 'Unit Test Opportuntiy';
        oOpportunity.CloseDate = System.Today() + 5;
        oOpportunity.StageName = '75%';
        insert oOpportunity;
        
        Product2 prod1 =UnitTest.getProductInstance();
        insert prod1;
        
        PricebookEntry pbe1 = new PricebookEntry(isactive=true,Pricebook2id=Test.getStandardPricebookId(),Product2Id=prod1.id,unitprice=1,UseStandardPrice=false);
        insert pbe1;
        
        OpportunityLineItem oli1= new OpportunityLineItem();
        oli1.Quantity=1;
        oli1.OpportunityId=oOpportunity.Id;
        oli1.PricebookEntryId=pbe1.Id;
        oliList1.add(oli1);
        insert oliList1;
        
        List<OpportunityLineItem> oliList2 = new List<OpportunityLineItem>();
        
        Opportunity oOpportunity1 = new Opportunity();
        oOpportunity1.AccountId = oAccount1.Id;
        oOpportunity1.Name = 'Unit Test Opportuntiy';
        oOpportunity1.CloseDate = System.Today() + 5;
        oOpportunity1.StageName = '75%';
        insert oOpportunity1; 
        
        OpportunityLineItem oli2= new OpportunityLineItem();
        oli2.Quantity=2;
        oli2.OpportunityId=oOpportunity1.Id;
        oli2.PricebookEntryId=pbe1.Id;
        oliList2.add(oli2);
        insert oliList2; 
                
        
        WebServiceSettings__c ws1= new WebServiceSettings__c();
        ws1.Name='Dellboomi SFDC Legal';
        ws1.Username__c='Username';
        ws1.Password__c='Password';
        ws1.Endpoint__c='https://dev.api.apigarden-qa.thomsonreuters.com/boomi/oauth2/token';
        ws1.Service_Unavailable_Message__c='Service_Unavailable';
        insert ws1;
        
        WebServiceSettings__c ws2= new WebServiceSettings__c();
        ws2.Name='BigRuleCreateQuote';
        ws2.Username__c='Username';
        ws2.Password__c='Password';
        ws2.Endpoint__c='http://dev.mis-soa.thomsonreuters.com/ecomsoa/services/OrdersServiceV02';
        ws2.Timeout__c = 120;
        ws2.Service_Unavailable_Message__c='Service_Unavailable';
        insert ws2;        

        BigRuleGenericSettings__c br1= new BigRuleGenericSettings__c();
        br1.Name='QS:WEST';
        br1.Value__c='75%,90%,95%,100%';
        insert br1;
        
        BigRuleGenericSettings__c br11= new BigRuleGenericSettings__c();
        br11.Name='QS:GLI';
        br11.Value__c='75%,90%,95%,100%';
        insert br11;
        
        KeyValueListStore__c oKey1 = new KeyValueListStore__c();
        oKey1.name = 'BigRuleProductId';       
        oKey1.TextValue__c = 'SF03';
        insert oKey1;

        KeyValueListStore__c oKey2 = new KeyValueListStore__c();
        oKey2.name = 'BigRuleCconfigGroup';       
        oKey2.TextValue__c = 'WRP';
        insert oKey2;         
        
        Test.StartTest();
        Test.setMock(HttpCalloutMock.class, new  DellBoomiTokenGeneration_Test.DellBoomiCalloutMock());                
        // Create a new email and envelope object
        Messaging.InboundEmail email = new Messaging.InboundEmail();
        Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
        
        // Create the email body
        email.plainTextBody = 'This should become a note';
        email.fromAddress ='test@test.com';
        //email.ccAddresses = new String[] {'sapquotecreation@m-27qvut4jdjntz8djm7d9jbgfbw2qd3hmp2rgyhfdy46ucrmste.q-5ncfma2.q.apex.sandbox.salesforce.com'};   
        email.subject = 'CreateQuoteFrmOpp:>'+oOpportunity.id;
        SAPCustomerQuoteCreationServiceHandler oTestEmailHandler = new SAPCustomerQuoteCreationServiceHandler();
        Messaging.InboundEmailResult oTestResult = new Messaging.InboundEmailresult();
        oTestResult = oTestEmailHandler.handleInboundEmail(email, env);
        
        email.subject =  'CreateQuoteFrmAccount:>'+oAccount1.Id;
        oTestResult = oTestEmailHandler.handleInboundEmail(email, env);
        
        Test.StopTest();

    }

   public static testMethod void testCreateQuote2(){
        UnitTest.createTestData();
        Id RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
        
        Test.startTest();
        Account oAccount2 = new Account();
        oAccount2.Name = 'Unit Test';
        oAccount2.Sales_Org__c = 'WEST';
        oAccount2.Customer_Type__c = 'Individual';
        oAccount2.Customer_Group__c = 'ACADEMIC';
        oAccount2.Industry = 'ACADEMIA';
        oAccount2.BillingStreet = '275 BATTERY ST STE 1500';
        oAccount2.BillingCity = 'SAN FRANCISCO';
        oAccount2.BillingState = 'CA';
        oAccount2.BillingPostalCode = '94111-3334';
        oAccount2.BillingCountry = 'US';
        oAccount2.Tax_Number_Type__c='C.I.';
        oAccount2.Tax_Number__c='12345';
        oAccount2.RecordTypeId=RecordTypeId;
        oAccount2.Is_Customer_Review_Complete__c=true;
        MDBIntegrationUtil_Test.setupUpsertAccountServiceSettings();
        MDBIntegrationUtil_Test.setupMockUpsertAccountSuccessResponse();
        insert oAccount2;        
        
        Product2 prod1 =UnitTest.getProductInstance();
        insert prod1;
        
        PricebookEntry pbe1 = new PricebookEntry(isactive=true,Pricebook2id=Test.getStandardPricebookId(),Product2Id=prod1.id,unitprice=1,UseStandardPrice=false);
        insert pbe1;
        
        Opportunity oOpportunity2 = new Opportunity();
        oOpportunity2.AccountId = oAccount2.Id;
        oOpportunity2.Name = 'Unit Test Opportuntiy';
        oOpportunity2.CloseDate = System.Today() + 5;
        oOpportunity2.StageName = '75%';
        insert oOpportunity2;
        
        OpportunityLineItem oli3= new OpportunityLineItem();
        oli3.Quantity=2;
        oli3.OpportunityId=oOpportunity2.Id;
        oli3.PricebookEntryId=pbe1.Id;
        insert oli3;
        
        Quote quo= new Quote();
        quo.Name='TestQuote';
        quo.OpportunityId=oOpportunity2.Id;
        insert quo;
        
        WebServiceSettings__c ws1= new WebServiceSettings__c();
        ws1.Name='Dellboomi SFDC Legal';
        ws1.Username__c='Username';
        ws1.Password__c='Password';
        ws1.Endpoint__c='https://dev.api.apigarden-qa.thomsonreuters.com/boomi/oauth2/token';
        ws1.Service_Unavailable_Message__c='Service_Unavailable';
        insert ws1;
        
        WebServiceSettings__c ws2= new WebServiceSettings__c();
        ws2.Name='BigRuleCreateQuote';
        ws2.Username__c='Username';
        ws2.Password__c='Password';
        ws2.Endpoint__c='http://dev.mis-soa.thomsonreuters.com/ecomsoa/services/OrdersServiceV02';
        ws2.Timeout__c = 120;
        ws2.Service_Unavailable_Message__c='Service_Unavailable';
        insert ws2;        

        BigRuleGenericSettings__c br1= new BigRuleGenericSettings__c();
        br1.Name='QS:WEST';
        br1.Value__c='75%,90%,95%,100%';
        insert br1;
        BigRuleGenericSettings__c br11= new BigRuleGenericSettings__c();
        br11.Name='QS:GLI';
        br11.Value__c='75%,90%,95%,100%';
        insert br11;
        
        KeyValueListStore__c oKey1 = new KeyValueListStore__c();
        oKey1.name = 'BigRuleProductId';       
        oKey1.TextValue__c = 'SF03';
        insert oKey1;

        KeyValueListStore__c oKey2 = new KeyValueListStore__c();
        oKey2.name = 'BigRuleCconfigGroup';       
        oKey2.TextValue__c = 'WRP';
        insert oKey2;         
        

        Test.setMock(HttpCalloutMock.class, new  DellBoomiTokenGeneration_Test.DellBoomiCalloutMock());                
        // Create a new email and envelope object
        Messaging.InboundEmail email = new Messaging.InboundEmail();
        Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
        
        // Create the email body
        email.plainTextBody = 'This should become a note';
        email.fromAddress ='test@test.com';
        //email.ccAddresses = new String[] {'sapquotecreation@m-27qvut4jdjntz8djm7d9jbgfbw2qd3hmp2rgyhfdy46ucrmste.q-5ncfma2.q.apex.sandbox.salesforce.com'};   
        email.subject =  'CreateQuoteFrmOpp:>'+oOpportunity2.id;
        SAPCustomerQuoteCreationServiceHandler oTestEmailHandler = new SAPCustomerQuoteCreationServiceHandler();
        Messaging.InboundEmailResult oTestResult = new Messaging.InboundEmailresult();
        oTestResult = oTestEmailHandler.handleInboundEmail(email, env);
        
        email.subject =  'CreateQuoteFrmAccount:>'+oAccount2.Id;
        oTestResult = oTestEmailHandler.handleInboundEmail(email, env); 


        Test.StopTest();

    }

   public static testMethod void testCreateQuote3(){
        UnitTest.createTestData();
        Id RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
        
        
        Account oAccount2 = new Account();
        oAccount2.Name = 'Unit Test';
        oAccount2.Sales_Org__c = 'WEST';
        oAccount2.Customer_Type__c = 'Individual';
        oAccount2.Customer_Group__c = 'ACADEMIC';
        oAccount2.Industry = 'ACADEMIA';
        oAccount2.BillingStreet = '275 BATTERY ST STE 1500';
        oAccount2.BillingCity = 'SAN FRANCISCO';
        oAccount2.BillingState = 'CA';
        oAccount2.BillingPostalCode = '94111-3334';
        oAccount2.BillingCountry = 'US';
        oAccount2.Tax_Number_Type__c='C.I.';
        oAccount2.Tax_Number__c='12345';
        oAccount2.SAPAccountNumber__c='';
        oAccount2.RecordTypeId=RecordTypeId;
        oAccount2.Is_Customer_Review_Complete__c=true;
        MDBIntegrationUtil_Test.setupUpsertAccountServiceSettings();
        MDBIntegrationUtil_Test.setupMockUpsertAccountSuccessResponse();
        insert oAccount2;        
        
        Product2 prod1 =UnitTest.getProductInstance();
        insert prod1;
        
        PricebookEntry pbe1 = new PricebookEntry(isactive=true,Pricebook2id=Test.getStandardPricebookId(),Product2Id=prod1.id,unitprice=1,UseStandardPrice=false);
        insert pbe1;
        
        Opportunity oOpportunity2 = new Opportunity();
        oOpportunity2.AccountId = oAccount2.Id;
        oOpportunity2.Name = 'Unit Test Opportuntiy';
        oOpportunity2.CloseDate = System.Today() + 5;
        oOpportunity2.StageName = '75%';
        insert oOpportunity2;
        
        OpportunityLineItem oli3= new OpportunityLineItem();
        oli3.Quantity=2;
        oli3.OpportunityId=oOpportunity2.Id;
        oli3.PricebookEntryId=pbe1.Id;
        insert oli3;
        
        Quote quo= new Quote();
        quo.Name='TestQuote';
        quo.OpportunityId=oOpportunity2.Id;
        insert quo;
        
        WebServiceSettings__c ws1= new WebServiceSettings__c();
        ws1.Name='Dellboomi SFDC Legal';
        ws1.Username__c='Username';
        ws1.Password__c='Password';
        ws1.Endpoint__c='https://dev.api.apigarden-qa.thomsonreuters.com/boomi/oauth2/token';
        ws1.Service_Unavailable_Message__c='Service_Unavailable';
        insert ws1;
        
        WebServiceSettings__c ws2= new WebServiceSettings__c();
        ws2.Name='BigRuleCreateQuote';
        ws2.Username__c='Username';
        ws2.Password__c='Password';
        ws2.Endpoint__c='http://dev.mis-soa.thomsonreuters.com/ecomsoa/services/OrdersServiceV02';
        ws2.Timeout__c = 120;
        ws2.Service_Unavailable_Message__c='Service_Unavailable';
        insert ws2;        

        BigRuleGenericSettings__c br1= new BigRuleGenericSettings__c();
        br1.Name='QS:WEST';
        br1.Value__c='75%,90%,95%,100%';
        insert br1;
        
        KeyValueListStore__c oKey1 = new KeyValueListStore__c();
        oKey1.name = 'BigRuleProductId';       
        oKey1.TextValue__c = 'SF03';
        insert oKey1;

        KeyValueListStore__c oKey2 = new KeyValueListStore__c();
        oKey2.name = 'BigRuleCconfigGroup';       
        oKey2.TextValue__c = 'WRP';
        insert oKey2; 
        
        quote q=[select QuoteNumber from Quote where ID=:quo.Id];
        string sQuoteNumber=q.QuoteNumber;
        string sSalesOrg=oAccount2.Sales_Org__c;
        string sSAPAccountNumber=oAccount2.SAPAccountNumber__c;
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new  DellBoomiTokenGeneration_Test.DellBoomiCalloutMock2());                
        createQuote.createSAPQuote( sQuoteNumber,  sSalesOrg,  sSAPAccountNumber);

        Test.StopTest();

    }

  /*  public static testMethod void testCreateQuote() {
    
        test.StartTest();
        //-------test records creation BEGIN---------
        List<Account> listAccounts = new List<Account>();
        List<Opportunity> listOpportunities = new List<Opportunity>();
        List<Quote> listQuote = new list<Quote>();
        Account oAccount = new Account();
        oAccount.Name = 'Unit Test';
        oAccount.Sales_Org__c = 'WEST';
        oAccount.Customer_Type__c = 'Individual';
        oAccount.Customer_Group__c = 'ACADEMIC';
        oAccount.Industry = 'TAX';
        oAccount.Is_Customer_Review_Complete__c=true;
        listAccounts.add(oAccount);
        
        Account oAccount1 = new Account();
        oAccount1.Name = 'Unit Test1';
        oAccount1.Sales_Org__c = 'WEST';
        oAccount1.Customer_Type__c = 'Individual';
        oAccount1.Customer_Group__c = 'ACADEMIC';
        oAccount1.Industry = 'TAX';
        oAccount1.Is_Customer_Review_Complete__c=true;
        listAccounts.add(oAccount1);
        
        insert listAccounts;
        
        Opportunity oOpportunity = new Opportunity();
        oOpportunity.AccountId = oAccount.Id;
        oOpportunity.Name = 'Unit Test Opportuntiy';
        oOpportunity.CloseDate = System.Today() + 5;
        oOpportunity.StageName = '10%';
        listOpportunities.add(oOpportunity);
        
        Opportunity oOpportunity2 = new Opportunity();
        oOpportunity2.AccountId = oAccount1.Id;
        oOpportunity2.Name = 'Unit Test Opportuntiy2';
        oOpportunity2.CloseDate = System.Today() + 5;
        oOpportunity2.StageName = '75%';
        listOpportunities.add(oOpportunity2);
        
        Opportunity oOpportunity1 = new Opportunity();
        oOpportunity1.AccountId = oAccount1.Id;
        oOpportunity1.Name = 'Unit Test Opportuntiy1';
        oOpportunity1.CloseDate = System.Today() + 5;
        oOpportunity1.StageName = '10%';
        listOpportunities.add(oOpportunity1);
        
        Opportunity oOpportunity23 = new Opportunity();
        oOpportunity23.AccountId = oAccount1.Id;
        oOpportunity23.Name = 'Unit Test Opportuntiy1';
        oOpportunity23.CloseDate = System.Today() + 5;
        oOpportunity23.StageName = '75%';
        listOpportunities.add(oOpportunity23);
        
        Opportunity oOpportunity3 = new Opportunity();
        oOpportunity3.AccountId = oAccount.Id;
        oOpportunity3.Name = 'Unit Test Opportuntiy';
        oOpportunity3.CloseDate = System.Today() + 5;
        oOpportunity3.StageName = '10%';
        listOpportunities.add(oOpportunity3);
        
        insert listOpportunities;
        
        Quote oQuote22 = new Quote();
        oQuote22.Name = 'Quote_'+oOpportunity23.Name;
        oQuote22.OpportunityId = oOpportunity23.id;
        oQuote22.SAP_IDOC_Number__c = '';
        listQuote.add(oQuote22);
        
        Quote oQuote = new Quote();
        oQuote.Name = 'Quote_'+oOpportunity1.Name;
        oQuote.OpportunityId = oOpportunity1.id;
        oQuote.SAP_IDOC_Number__c = '123456';
        listQuote.add(oQuote);
        
        Quote oQuote3 = new Quote();
        oQuote3.Name = 'Quote_'+oOpportunity3.Name;
        oQuote3.OpportunityId = oOpportunity3.Id;
        oQuote3.SAP_IDOC_Number__c = '';
        listQuote.add(oQuote3);
        
        insert listQuote;
        //-------test records creation END---------
        
        //use case 1: with no existing quotes
        Opportunity oOpp = new Opportunity(id=oOpportunity.id);
        oOpp.StageName ='75%';
        update oOpp;
        
        
        
        // Create a new email and envelope object
        Messaging.InboundEmail email = new Messaging.InboundEmail();
        Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
        
        // Create the email body
        email.plainTextBody = 'This should become a note';
        email.fromAddress ='test@test.com';
        email.ccAddresses = new String[] {'sapquotecreation@m-27qvut4jdjntz8djm7d9jbgfbw2qd3hmp2rgyhfdy46ucrmste.q-5ncfma2.q.apex.sandbox.salesforce.com'};   
        email.subject = 'CreateQuoteFrmOpp:>'+oOpportunity.id;
        SAPCustomerQuoteCreationServiceHandler oTestEmailHandler = new SAPCustomerQuoteCreationServiceHandler();
        Messaging.InboundEmailResult oTestResult = new Messaging.InboundEmailresult();
        oTestResult = oTestEmailHandler.handleInboundEmail(email, env);
        
        //use case 2: with existing quotes
        
        Opportunity oOpp1 = new Opportunity(id=oOpportunity1.id);
        oOpp1.StageName ='95%';
        update oOpp1;
        
        // Create a new email and envelope object
        Messaging.InboundEmail email1 = new Messaging.InboundEmail();
        Messaging.InboundEnvelope env1 = new Messaging.InboundEnvelope();
        
        // Create the email body
        email1.plainTextBody = 'This should become a note';
        email1.fromAddress ='test@test.com';
        email1.ccAddresses = new String[] {'sapquotecreation@m-27qvut4jdjntz8djm7d9jbgfbw2qd3hmp2rgyhfdy46ucrmste.q-5ncfma2.q.apex.sandbox.salesforce.com'};   
        email1.subject = 'CreateQuoteFrmAccount:>'+oAccount1.Id;
        SAPCustomerQuoteCreationServiceHandler oTestEmailHandler1 = new SAPCustomerQuoteCreationServiceHandler();
        Messaging.InboundEmailResult oTestResult1 = new Messaging.InboundEmailresult();
        oTestResult1 = oTestEmailHandler1.handleInboundEmail(email1, env1);
        
        //use case 3: opportunity with existing qutoes
        
        
        Opportunity oOpp3 = new Opportunity(id=oOpportunity3.id);
        oOpp3.StageName ='75%';
        update oOpp3;
        
        // Create a new email and envelope object
        Messaging.InboundEmail email3 = new Messaging.InboundEmail();
        Messaging.InboundEnvelope env3 = new Messaging.InboundEnvelope();
        
        // Create the email body
        email3.plainTextBody = 'This should become a note';
        email3.fromAddress ='test@test.com';
        email3.ccAddresses = new String[] {'sapquotecreation@m-27qvut4jdjntz8djm7d9jbgfbw2qd3hmp2rgyhfdy46ucrmste.q-5ncfma2.q.apex.sandbox.salesforce.com'};   
        email3.subject = 'CreateQuoteFrmOpp:>'+oOpportunity3.id;
        SAPCustomerQuoteCreationServiceHandler oTestEmailHandler3 = new SAPCustomerQuoteCreationServiceHandler();
        Messaging.InboundEmailResult oTestResult3 = new Messaging.InboundEmailresult();
        oTestResult3 = oTestEmailHandler3.handleInboundEmail(email3, env3);
        
        test.StopTest();
        //----------code coverage for other classes generated from wsdl
        ecomTocServicesThomsonCom10Core oCore = new ecomTocServicesThomsonCom10Core();
        ecomTocServicesThomsonCom10Core.CoreSystemError oCoreSystemError = new ecomTocServicesThomsonCom10Core.CoreSystemError();
        ecomTocServicesThomsonCom10Core.CoreServiceError oCoreServiceError = new ecomTocServicesThomsonCom10Core.CoreServiceError();
        ecomTocServicesThomsonCom10Core.Message oMessage = new ecomTocServicesThomsonCom10Core.Message();
        ecomTocServicesThomsonCom10Core.CoreValidationError oCoreValidationError = new ecomTocServicesThomsonCom10Core.CoreValidationError();
        ecomTocServicesThomsonCom10Core.Response oResponse = new ecomTocServicesThomsonCom10Core.Response();
        ecomTocServicesThomsonCom10Core.Account oAccount2 = new ecomTocServicesThomsonCom10Core.Account();
        ecomTocServicesThomsonCom10Core.RequestContext oRequestContext = new ecomTocServicesThomsonCom10Core.RequestContext();
        ecomTocServicesThomsonCom10Core.Request oRequest = new ecomTocServicesThomsonCom10Core.Request();
        ecomTocServicesThomsonCom10Core.CoreError oCoreError = new ecomTocServicesThomsonCom10Core.CoreError();
        ecomTocServicesThomsonCom10Core.Property oProperty = new ecomTocServicesThomsonCom10Core.Property();
        ecomTocServicesThomsonCom10Core.ExtensibleObject oExtensibleObject = new ecomTocServicesThomsonCom10Core.ExtensibleObject();
        
        ecomTocServicesThomsonCom20Orders oOrders = new ecomTocServicesThomsonCom20Orders();
        ecomTocServicesThomsonCom20Orders.context_element ocontext_element = new ecomTocServicesThomsonCom20Orders.context_element();
        ecomTocServicesThomsonCom20Orders.OrdersServiceException_element oOrdersServiceException_element = new ecomTocServicesThomsonCom20Orders.OrdersServiceException_element();
        ecomTocServicesThomsonCom20Orders.SapOrderMessage oSapOrderMessage = new ecomTocServicesThomsonCom20Orders.SapOrderMessage();
        ecomTocServicesThomsonCom20Orders.OrderAddress oOrderAddress = new ecomTocServicesThomsonCom20Orders.OrderAddress();
        ecomTocServicesThomsonCom20Orders.CreateQuoteRequest_element oCreateQuoteRequest_element = new ecomTocServicesThomsonCom20Orders.CreateQuoteRequest_element();
        ecomTocServicesThomsonCom20Orders.CreateQuoteResponse_element oCreateQuoteResponse_element = new ecomTocServicesThomsonCom20Orders.CreateQuoteResponse_element();
        
        tocSchemasThomsonComHeaders200602 oHeaders = new tocSchemasThomsonComHeaders200602();
        tocSchemasThomsonComHeaders200602.TocHeader_element oTocHeader_element = new tocSchemasThomsonComHeaders200602.TocHeader_element();
        tocSchemasThomsonComHeaders200602.Message_element oMessage_element = new tocSchemasThomsonComHeaders200602.Message_element();
        tocSchemasThomsonComHeaders200602.X_element oX_element = new tocSchemasThomsonComHeaders200602.X_element();
        tocSchemasThomsonComHeaders200602.Id_element oId_element = new tocSchemasThomsonComHeaders200602.Id_element();
        
        ecomOrdersServiceV02 oecomOrdersServiceV02 = new ecomOrdersServiceV02();
        ecomOrdersServiceV02.OrdersServiceV02 oTestService = new ecomOrdersServiceV02.OrdersServiceV02();
        
    }*/
}