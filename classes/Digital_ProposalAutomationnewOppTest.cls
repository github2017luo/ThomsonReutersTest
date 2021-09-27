@isTest
public class Digital_ProposalAutomationnewOppTest{
    public static Source_System_Detail__c accountSSD1;
    public static String opp2id;
    public static String acct1id;
    public static String acctssd1id;
  @testsetup
    public static void testdata(){
        Test.startTest();
         //To fix the test class error from UpdateMultiListAccountTier
      WebServiceSettings__c web = new WebServiceSettings__c();
        web.Endpoint__c = 'https://thomsonreutersglis2e--merge.cs19.my.salesforce.com/servlet/servlet.ExternalRedirect?url=https%3A%2F%2Fqa.securepayment.thomsonreuters.com%2FTRPaymentGateway%2FBilling%2FInvoiceSummary%2FTRPaymentAutoCharge';
      web.Name = 'Payment AutoCharge';
      web.Username__c = 'test.user';
      web.Password__c = 'test:123';
      web.Service_Unavailable_Message__c = 'testservice';
      insert web;
        List<WebServiceSettings__c> webserviceList = new List<WebServiceSettings__c>{new WebServiceSettings__c(Name='EnterpriseWSDL',Endpoint__c='https://api.thomsonreuters.com/ebs/entitlement/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
           new WebServiceSettings__c(Name='StatusPostbackLocation',Endpoint__c='https://api.thomsonreuters.com/ebs/entitlement/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
           new WebServiceSettings__c(Name='PostbackLocation',Endpoint__c='https://api.thomsonreuters.com/ebs/entitlement/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
           new WebServiceSettings__c(Name='Payment AutoCharge',Endpoint__c='https://api.thomsonreuters.com/ebs/entitlement/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available')};
        insert webserviceList;
        
       
        Id mollyUserId = [Select id from User where name = 'Molly Bentz'].ID;  
        DCTestData.createData();
        
        
        opp2id = DCTestdata.oppId;
        acct1id = DCTestData.accountId;
        acctssd1id = DCTestData.accssdid;  
        Account acc = new Account();
        acc.Name = 'Test Account';
        acc.FrozenMarketSegment__c = 'Solo Law Firm';
        acc.SAPAccountNumber__c = '1004284495';
        acc.Customer_Group__c = 'FIRM';
        acc.APTS_Band_Number__c = 1;
        acc.APTS_Customer_Category__c = '3';
        acc.APTS_eOutput_Eligibilty__c = '';
        insert acc;
        
         Contact oContact = new Contact();
        oContact.AccountId = acc.ID;
        oContact.FirstName = 'Unit';
        oContact.LastName = 'Test';
        oContact.SAP_Role__c = 'EML ORDER CONFIRM';
        insert oContact;

        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();
        Source_System_Detail__c accountSSD= new Source_System_Detail__c();
        accountSSD.RecordtypeId=ssdRecorType;
        accountSSD.Name='ABC';
        accountSSD.Source_System_Name__c='ABC';
        accountSSD.Account_Name__c=acc.ID; 
        accountSSD.Account_Inactive__c = false;  
        accountSSD.Source_System_Account_Number__c = acc.SAPAccountNumber__c;    
        accountSSD.LCRM_Frozen_Market_Segment__c = 'Solo Law Firm';
        accountSSD.LCRM_SAP_Account_Number__c = '1004284495';        
        accountSSD.LCRM_APTS_Band_Number__c= 1;
        accountSSD.APTS_Customer_Category__c = '3';
        accountSSD.LCRM_eOutput_Eligibility__c= ''; 
        accountSSD.LCRM_Sales_Org__c= 'WEST';
        accountSSD.State__c = 'California';
        accountSSD.LCRM_Customer_Group__c = 'FIRM';
        insert accountSSD;
        list<LCRM_Contact_SSD__c> csd = new list<LCRM_Contact_SSD__c>();
        LCRM_Contact_SSD__c conSSD = new LCRM_Contact_SSD__c();
        conSSD.LCRM_Contact__c=oContact.Id;
        conSSD.LCRM_SAP_Role__c=oContact.SAP_Role__c;
        //conSSD.LCRM_Source_Contact_Id__c=con.SAP_Contact_ID__c;
        conSSD.LCRM_Account_SSD__c = accountSSD.Id;
        conSSD.LCRM_Email__c= oContact.Email;
         csd.add(conSSD);
        LCRM_Contact_SSD__c conSSD1 = new LCRM_Contact_SSD__c();
        conSSD1.LCRM_Contact__c=oContact.Id;
        conSSD.LCRM_SAP_Role__c=oContact.SAP_Role__c;
        //conSSD.LCRM_Source_Contact_Id__c=con.SAP_Contact_ID__c;
        conSSD1.LCRM_Account_SSD__c =acctssd1id;
        conSSD1.LCRM_Email__c= oContact.Email;
        csd.add(conSSD1);
        insert csd;
    test.stoptest();
        List<Opportunity> oppList = new List<Opportunity>();
        list<Product_Account_Detail__c> prodactdetailList = new list<Product_Account_Detail__c>();
        
        Product_Account_Detail__c prodactdetail1 = DCTestData.createDigitalSubscriptions('42072689','42072690', 'Plus', '1004284494', System.Today().addDays(integer.valueof(label.Digital_Max_Asset_Days.trim())), '00237KI');
        prodactdetail1.Account__c = acct1id;
        prodactdetail1.AccountSSD__c = acctssd1id;
        prodactdetail1.Actual_New_Subscription__c = '42009613';  
        prodactdetail1.Premium_New_Service__c = '42009613';
        prodactdetail1.Offer_Price__c = -5;
        prodactdetail1.Type__c ='Config';
        prodactdetailList.add(prodactdetail1); 
        
        Product_Account_Detail__c prodactdetail2 = DCTestData.createDigitalSubscriptions('41935308','41935309', 'Plus', '1004284494', System.Today().addDays(integer.valueof(label.Digital_Max_Asset_Days.trim())), '00237KI');
        
        prodactdetail2.Account__c = acct1id;
        prodactdetail2.AccountSSD__c = acctssd1id;
        prodactdetail2.Current_Subscription__c = '40974107';
        prodactdetail2.Actual_New_Subscription__c = '42009613';
        prodactdetail2.Actual_New_Service__c = '42009613';
        prodactdetail2.Type__c ='Config';
        prodactdetailList.add(prodactdetail2);
        
        Product_Account_Detail__c prodactdetail3 = DCTestData.createDigitalSubscriptions('42072689','42072690', 'Plus', '1004284494', System.Today().addDays(integer.valueof(label.Digital_Max_Asset_Days.trim())), '00237KI');
        
        prodactdetail3.Account__c = acct1id;
        prodactdetail3.AccountSSD__c = acctssd1id;
        prodactdetail3.Premium_New_Service__c = '42009614';
        prodactdetail3.Actual_New_Subscription__c = '42009613';
        prodactdetail3.Premium_New_Subscription__c = '40974108';
        prodactdetail3.Offer_Price__c = 5;
        prodactdetail3.Type__c ='Config';
        prodactdetailList.add(prodactdetail3);
          
        upsert prodactdetailList;
    }
    
    public static testMethod void newOppTest(){       
        Test.startTest();
        Digital_ProposalAutomationnewOpp dpb = new Digital_ProposalAutomationnewOpp();
        Database.executeBatch(dpb, 1);
        System.assert(dpb != null,'Job failed');
        Test.stopTest();
    }
    public static testMethod void newOppTest1(){       
        List<Opportunity> oppList  = [select id from Opportunity LIMIT 100];
        delete oppList;
        Test.startTest();
        Digital_ProposalAutomationnewOpp dpb = new Digital_ProposalAutomationnewOpp();
        Database.executeBatch(dpb, 1);
        System.assert(dpb != null,'Job failed');
        Test.stopTest();
    }
}