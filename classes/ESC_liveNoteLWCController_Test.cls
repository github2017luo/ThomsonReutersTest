@isTest public class ESC_liveNoteLWCController_Test 
{
    @isTest public static void testESC_liveNoteLWCController()
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
        oCustomerProspectSettings.Name = 'LiveNoteLicenses';
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
        ssd.Source_System_Account_Number__c='1004628718';
        insert ssd;
        
        system.debug('Account Source System Record'+ssd);
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new DellBoomiTokenGeneration_Test.DellBoomiCalloutMock());
        String ssdID=ssd.Id;
        ESC_liveNoteLWCController.retriveAccssd(ssdID);
        
        test.stopTest();
        
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
        catch(Exception e){
           system.debug('Exception Occurred Test Class'+e.getMessage());       
          }
         
    }
        
}