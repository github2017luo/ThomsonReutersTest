/**
 * Test class to validate the functionality provided by the createCustomer class 
 *
 * @author  Srikanth kuruva
 * @version  2013-03-27 
 *
 * CHANGE HISTORY
 * =================================================================================================================================================
 * Date         Name                    Description
 * 2013-03-27   Srikanth Kuruva            Created    
      
 * =================================================================================================================================================
**/

@isTest
public class createCustomer_Test{ 

    public static testMethod void testCreateCustomer() {
        
        
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
        
        
        Opportunity oOpportunity = new Opportunity();
        oOpportunity.AccountId = oAccount.Id;
        oOpportunity.Name = 'Unit Test Opportuntiy';
        oOpportunity.CloseDate = System.Today() + 5;
        oOpportunity.StageName = '75%';
        insert oOpportunity;
        
        WebServiceSettings__c ws1= new WebServiceSettings__c();
        ws1.Name='Dellboomi SFDC Legal';
        ws1.Username__c='Username';
        ws1.Password__c='Password';
        ws1.Endpoint__c='https://dev.api.apigarden-qa.thomsonreuters.com/boomi/oauth2/token';
        ws1.Service_Unavailable_Message__c='Service_Unavailable';
        insert ws1;


        WebServiceSettings__c ws2 = new WebServiceSettings__c();
        ws2.name = 'BigRuleCreateCustomer';       
        ws2.Active__c = true;
        ws2.Endpoint__c = 'https://tacss.thomsonreuters.com/rocketdeploy/services/Order_v5_0Port';
        ws2.Password__c = 'sfdconepass123';
        ws2.Service_Unavailable_Message__c = 'Orders setting for the Web service';
        ws2.Timeout__c = 120;
        ws2.Username__c = 'Salesforce';
        insert ws2;            

        KeyValueListStore__c oKey1 = new KeyValueListStore__c();
        oKey1.name = 'BigRuleProductId';       
        oKey1.TextValue__c = 'SF03';
        insert oKey1;

        KeyValueListStore__c oKey2 = new KeyValueListStore__c();
        oKey2.name = 'BigRuleCconfigGroup';       
        oKey2.TextValue__c = 'WRP';
        insert oKey2;          
        
        KeyValueListStore__c oKey3 = new KeyValueListStore__c();
        oKey3.name = 'CustomerReviewPostbackURL';       
        oKey3.TextValue__c = 'https://thomsonreutersglis2e.my.salesforce.com/services/apexrest/customerpostback';
        insert oKey3; 
        
        KeyValueListStore__c oKey4 = new KeyValueListStore__c();
        oKey4.name = 'C.I.';       
        oKey4.TextValue__c = '70';
        insert oKey4;  
        
        KeyValueListStore__c oKey5 = new KeyValueListStore__c();
        oKey5.name = 'CustomerRecordTypeId';       
        oKey5.TextValue__c = '01230000001MA4a';
        insert oKey5; 
     

        IXOSCodeMap__c ixos=new IXOSCodeMap__c(); 
        ixos.Name='WEST';
        ixos.Company_Code__c='0010';
        ixos.Dist_Chan_Code__c='W';
        ixos.Division_Code__c='W';
        ixos.Sales_Org_Code__c='West';
        insert ixos;  
        
        BigRuleGenericSettings__c br1= new BigRuleGenericSettings__c();
        br1.Name='IND:ACADEMIA';
        br1.Value__c='EC5';
        insert br1;
        
        BigRuleGenericSettings__c br2= new BigRuleGenericSettings__c();
        br2.Name='CG:ACADEMIC';
        br2.Value__c='02';
        insert br2;
        
        BigRuleGenericSettings__c br3 = new BigRuleGenericSettings__c();
        br3.Name = 'PF:SP';       
        br3.Value__c = 'Sold To';
        insert br3;         
    
        
        Test.StartTest();
        Test.setMock(HttpCalloutMock.class, new  DellBoomiTokenGeneration_Test.DellBoomiCalloutMock());        
        
        // Create a new email and envelope object
        Messaging.InboundEmail email = new Messaging.InboundEmail();
        Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
        
        // Create the email body
        email.plainTextBody = 'This should become a note';
        email.fromAddress ='test@test.com';
        //email.ccAddresses = new String[] {'sapquotecreation@m-27qvut4jdjntz8djm7d9jbgfbw2qd3hmp2rgyhfdy46ucrmste.q-5ncfma2.q.apex.sandbox.salesforce.com'};   
        email.subject = 'CreateCustomer:>'+oOpportunity.AccountId;
        SAPCustomerQuoteCreationServiceHandler oTestEmailHandler = new SAPCustomerQuoteCreationServiceHandler();
        Messaging.InboundEmailResult oTestResult = new Messaging.InboundEmailresult();
        oTestResult = oTestEmailHandler.handleInboundEmail(email, env);
        
        //state/region is blank
        oAccount.BillingState = '';
        update oAccount;
        
        oTestResult = new Messaging.InboundEmailresult();
        oTestResult = oTestEmailHandler.handleInboundEmail(email, env);

        //----------code coverage for other classes generated from wsdl
        
        ecomTocServicesThomsonCom20Common oCommon = new ecomTocServicesThomsonCom20Common();
        ecomTocServicesThomsonCom20Common.Confirmation oConfirmation = new ecomTocServicesThomsonCom20Common.Confirmation();
        ecomTocServicesThomsonCom20Common.EcomResponse oEcomResponse = new ecomTocServicesThomsonCom20Common.EcomResponse();
        ecomTocServicesThomsonCom20Common.ConfirmationResponse oConfirmationResponse = new ecomTocServicesThomsonCom20Common.ConfirmationResponse();
        ecomTocServicesThomsonCom20Common.Property oProperty = new ecomTocServicesThomsonCom20Common.Property();
        ecomTocServicesThomsonCom20Common.CallbackEvent oCallbackEvent = new ecomTocServicesThomsonCom20Common.CallbackEvent();
        ecomTocServicesThomsonCom20Common.EcomSystemError oEcomSystemError = new ecomTocServicesThomsonCom20Common.EcomSystemError();
        ecomTocServicesThomsonCom20Common.Notification oNotification = new ecomTocServicesThomsonCom20Common.Notification();
        ecomTocServicesThomsonCom20Common.EcomContext oEcomContext = new ecomTocServicesThomsonCom20Common.EcomContext();
        ecomTocServicesThomsonCom20Common.EcomValidationError oEcomValidationError = new ecomTocServicesThomsonCom20Common.EcomValidationError();
        ecomTocServicesThomsonCom20Common.User_x oUser_x = new ecomTocServicesThomsonCom20Common.User_x();
        ecomTocServicesThomsonCom20Common.EcomRequest oEcomRequest = new ecomTocServicesThomsonCom20Common.EcomRequest();
        ecomTocServicesThomsonCom20Common.Address oAddress = new ecomTocServicesThomsonCom20Common.Address();
        ecomTocServicesThomsonCom20Common.EcomServiceError oEcomServiceError = new ecomTocServicesThomsonCom20Common.EcomServiceError();
        ecomTocServicesThomsonCom20Common.EcomError oEcomError = new ecomTocServicesThomsonCom20Common.EcomError();
        ecomTocServicesThomsonCom20Common.UserContext oUserContext = new ecomTocServicesThomsonCom20Common.UserContext();

  
      test.StopTest();
    }
}