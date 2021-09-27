@isTest
public class ESC_ProdocLWCController_Test {
     static testMethod void  testESC_ProdocLWCController()
    {
        UserRole UR =[SELECT  DeveloperName,Id,Name FROM UserRole where DeveloperName='USL_Customer_Service_Agent_Level_1'];
    Profile testprofile = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User testUser = new User(
            Alias = 'sUser',
            Email = 'abc1@testorg.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'Testing',
            LanguageLocaleKey = 'es',
            LocaleSidKey = 'es',
            ProfileId = testprofile.id,
            Sales_Org__c = 'WEST',
            Sub_Bu__c = 'USL',
            UserRoleId=UR.id,
            TimeZoneSidKey = 'America/Los_Angeles',
            UserName = 'abc123@testorg.com'
        );
        insert testUser;
        
        try{
        
        System.runAs(testUser){
        
        WebServiceSettings__c ws1= new WebServiceSettings__c();
        ws1.Name='Dellboomi SFDC Legal';
        ws1.Username__c='Username';
        ws1.Password__c='Password';
        ws1.Endpoint__c='https://dev.api.apigarden-qa.thomsonreuters.com/boomi/oauth2/token';
        ws1.Service_Unavailable_Message__c='Service_Unavailable';
        insert ws1;
        
        WebServiceSettings__c oCustomerProspectSettings = new WebServiceSettings__c();
        oCustomerProspectSettings.Name = 'ProdocLicenses';
        oCustomerProspectSettings.Endpoint__c = 'https://api-uat.thomsonreuters.com/boomi/subscriptionservice/qa/v1';
        oCustomerProspectSettings.Timeout__c = 120;
        oCustomerProspectSettings.Active__c = true;
        oCustomerProspectSettings.Service_Unavailable_Message__c = 'Service Unavailable';
        insert oCustomerProspectSettings;
        
        USL_Roles_Static_CC_Milestone__c uslInstance=new USL_Roles_Static_CC_Milestone__c();
        uslInstance.Rolename__c='USL_Customer_Service_Agent_Level_1';
        uslInstance.Name='USL_Customer_Service_Agent_Level_1';
        insert uslInstance;
        
        UnitTest.createOptiTestData();
        Account testAcc1 = UnitTest.getAccountInstance();
        //Account testAcc1=new Account();
        testAcc1.name='Test_Account';
        testAcc1.sapAccountNumber__C = '512345';
        //testAcc1.CompanyCodeDescription__c = '0010';
        testAcc1.Sales_Org__c = 'WEST';
        //testAcc1.DistributionChannel__c = 'W';
        //testAcc1.DivisionCodeDescription__c = 'W';
        
        insert testAcc1;
        
        
        system.debug('Account Success Navpreet'+testAcc1.Name);
        
        //Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('UKI Source Systems').getRecordTypeId();
    Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get(label.SourcesystemdetailUSLRecordtype).getRecordTypeId();
        
        
        Source_System_Detail__c ssd= new Source_System_Detail__c();
        ssd.RecordtypeId=ssdRecorType;
        ssd.Name='ABC';
        ssd.Source_System_Name__c='ABC';
        ssd.Digital_Billing_City__c='tst';
        ssd.Account_Name__c=testAcc1.ID;
        //ssd.Source_System_Account_Number__c='1000671248';
        ssd.Source_System_Account_Number__c='1004628718';
        insert ssd;
        
        system.debug('Account Source System Record'+ssd);
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new DellBoomiTokenGeneration_Test.DellBoomiCalloutMock());
        String ssdID=ssd.Id;
            String ssdID_null='';
        ESC_ProdocLWCController.retriveAccssd(ssdID);
        //ESC_ProdocLWCController.retriveAccssd(ssdID_null);
        test.stopTest();
        
        // ecomTocServicesThomsonComService1PD1.BandRange br = new ecomTocServicesThomsonComService1PD1.BandRange();
         //ecomTocServicesThomsonComService1PD1.getSubscriptionsByAccount_element gtSub = new ecomTocServicesThomsonComService1PD1.getSubscriptionsByAccount_element();
        // ecomTocServicesThomsonComService1PD1.getSubscriptionsByAccountResponse_element gtSub1 = new ecomTocServicesThomsonComService1PD1.getSubscriptionsByAccountResponse_element();
       //  ecomTocServicesThomsonComService1PD1.SubscriptionServiceerror subError = new ecomTocServicesThomsonComService1PD1.SubscriptionServiceerror();
       //  ecomTocServicesThomsonComService1PD1.material material = new ecomTocServicesThomsonComService1PD1.material();
         ecomTocServicesThomsonComService1PD1.getLicensesResponse_element lElement = new ecomTocServicesThomsonComService1PD1.getLicensesResponse_element();
        // ecomTocServicesThomsonComService1PD1.GetSubscriptionsFilter subFilter = new ecomTocServicesThomsonComService1PD1.GetSubscriptionsFilter();
         //ecomTocServicesThomsonComService1PD1.PurchaseOrder po = new ecomTocServicesThomsonComService1PD1.PurchaseOrder();
        // ecomTocServicesThomsonComService1PD1.CtcType ctc = new ecomTocServicesThomsonComService1PD1.CtcType();
         ecomTocServicesThomsonComService1PD1.getLicenses_element lElement1 = new ecomTocServicesThomsonComService1PD1.getLicenses_element();
         //ecomTocServicesThomsonComService1PD1.Subscription s = new ecomTocServicesThomsonComService1PD1.Subscription();
        // ecomTocServicesThomsonComService1PD1.Classification c = new ecomTocServicesThomsonComService1PD1.Classification();
        // ecomTocServicesThomsonComService1PD1.GetSubscriptionsByAccountResponse g = new ecomTocServicesThomsonComService1PD1.GetSubscriptionsByAccountResponse();
        // ecomTocServicesThomsonComService1PD1.CreditCardData cc = new ecomTocServicesThomsonComService1PD1.CreditCardData();
        // ecomTocServicesThomsonComService1PD1.SubscriptionLineItem subLine = new ecomTocServicesThomsonComService1PD1.SubscriptionLineItem();
         ecomTocServicesThomsonComService1PD1.License ln1 = new ecomTocServicesThomsonComService1PD1.License(); 
         ecomTocServicesThomsonComService1PD1.installationCodeList install = new ecomTocServicesThomsonComService1PD1.installationCodeList(); 
         ecomTocServicesThomsonComService1PD1.SubscriptionServiceV01 sub = new ecomTocServicesThomsonComService1PD1.SubscriptionServiceV01();
         ecomTocServicesThomsonComService1PD1.GetLicensesRequest request1 = new ecomTocServicesThomsonComService1PD1.GetLicensesRequest();
         List<ecomTocServicesThomsonComService1PD1.GetLicensesResponse> lresp1 = new List<ecomTocServicesThomsonComService1PD1.GetLicensesResponse>();
         lresp1 = sub.getLicenses(request1);
        }
        }
        catch(Exception e){
           system.debug('Exception Occurred Test Class'+e.getMessage());       
          }
    }
    
    
   /* static testMethod void  testESC_ProdocLWCController2()
    {
        UserRole UR =[SELECT  DeveloperName,Id,Name FROM UserRole where DeveloperName='USL_Customer_Service_Agent_Level_1'];
    Profile testprofile = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User testUser = new User(
            Alias = 'sUser',
            Email = 'abc1234@testorg.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'Testing1',
            LanguageLocaleKey = 'es',
            LocaleSidKey = 'es',
            ProfileId = testprofile.id,
            Sales_Org__c = 'WEST',
            Sub_Bu__c = 'USL',
            UserRoleId=UR.id,
            TimeZoneSidKey = 'America/Los_Angeles',
            UserName = 'abc1234@testorg.com'
        );
        insert testUser;
        
        try{
        
        System.runAs(testUser){
        
        WebServiceSettings__c ws1= new WebServiceSettings__c();
        ws1.Name='Dellboomi SFDC Legal';
        ws1.Username__c='Username';
        ws1.Password__c='Password';
        ws1.Endpoint__c='https://dev.api.apigarden-qa.thomsonreuters.com/boomi/oauth2/token';
        ws1.Service_Unavailable_Message__c='Service_Unavailable';
        insert ws1;
        
        WebServiceSettings__c oCustomerProspectSettings = new WebServiceSettings__c();
        oCustomerProspectSettings.Name = 'ProdocLicenses';
        oCustomerProspectSettings.Endpoint__c = 'https://api-uat.thomsonreuters.com/boomi/subscriptionservice/qa/v1';
        oCustomerProspectSettings.Timeout__c = 120;
        oCustomerProspectSettings.Active__c = true;
        oCustomerProspectSettings.Service_Unavailable_Message__c = 'Service Unavailable';
        insert oCustomerProspectSettings;
        
        USL_Roles_Static_CC_Milestone__c uslInstance=new USL_Roles_Static_CC_Milestone__c();
        uslInstance.Rolename__c='USL_Customer_Service_Agent_Level_1';
        uslInstance.Name='USL_Customer_Service_Agent_Level_1';
        insert uslInstance;
        
        UnitTest.createOptiTestData();
        Account testAcc1 = UnitTest.getAccountInstance();
        testAcc1.name='Test_Account';
        testAcc1.sapAccountNumber__C = '512345';
        testAcc1.Sales_Org__c = 'WEST';
        insert testAcc1;
        
        
        system.debug('Account Success Navpreet'+testAcc1.Name);
        
        //Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('UKI Source Systems').getRecordTypeId();
    Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get(label.SourcesystemdetailUSLRecordtype).getRecordTypeId();
        
        
        Source_System_Detail__c ssd= new Source_System_Detail__c();
        ssd.RecordtypeId=ssdRecorType;
        ssd.Name='ABC';
        ssd.Source_System_Name__c='ABC';
        ssd.Digital_Billing_City__c='tst';
        ssd.Account_Name__c=testAcc1.ID;
        ssd.Source_System_Account_Number__c='1000671248';
        insert ssd;
        
        system.debug('Account Source System Record'+ssd);
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new DellBoomiTokenGeneration_Test.DellBoomiCalloutMock());
        String ssdID=ssd.Id;
            String ssdID_null='';
        ESC_ProdocLWCController.retriveAccssd(ssdID);
        test.stopTest();
        
        
         ecomTocServicesThomsonComService1PD1.getLicensesResponse_element lElement = new ecomTocServicesThomsonComService1PD1.getLicensesResponse_element();
         ecomTocServicesThomsonComService1PD1.getLicenses_element lElement1 = new ecomTocServicesThomsonComService1PD1.getLicenses_element();
         ecomTocServicesThomsonComService1PD1.License ln1 = new ecomTocServicesThomsonComService1PD1.License(); 
         ecomTocServicesThomsonComService1PD1.installationCodeList install = new ecomTocServicesThomsonComService1PD1.installationCodeList(); 
         ecomTocServicesThomsonComService1PD1.SubscriptionServiceV01 sub = new ecomTocServicesThomsonComService1PD1.SubscriptionServiceV01();
         ecomTocServicesThomsonComService1PD1.GetLicensesRequest request1 = new ecomTocServicesThomsonComService1PD1.GetLicensesRequest();
         List<ecomTocServicesThomsonComService1PD1.GetLicensesResponse> lresp1 = new List<ecomTocServicesThomsonComService1PD1.GetLicensesResponse>();
        // lresp1 = sub.getLicenses(request1);
        }
        }
        catch(Exception e){
           system.debug('Exception Occurred Test Class'+e.getMessage());   
           
        }
    }*/
}