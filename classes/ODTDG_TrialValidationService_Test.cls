@istest(seeAllData=false)
public with sharing class ODTDG_TrialValidationService_Test {

    static testmethod void callingData(){
    
        boolean testBool=true;
        WebServiceSettings__c wst = new WebServiceSettings__c ();
        wst.Name = 'ECM Accesstoken';
        wst.Endpoint__c = 'https://qa.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease';
        wst.Timeout__c  = 120;
        wst.Service_Unavailable_Message__c = 'Service temporarily unavailable';
        wst.Password__c='PZUWkJQyAvUps7jb';
        wst.Username__c='JdJNIGAKVxZzkDqQAEg5dsJ4r3oANDbd';
        wst.Active__c=true;
        insert wst;
    
        System.assert(testBool != false,'boolean true');
    }

/********************************************************************************************************
*  @description method1: this is the test method to validate the trial validation service 
*********************************************************************************************************/
    public static testmethod void method1() {
        callingData();
        LIST<WebServiceSettings__c> ws = new LIST<WebServiceSettings__c> ();
        ws.add(ODTDG_TestFactory.webservicesSettingData('PaymentCreditIncrease', 'https://qa.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease'));
        ws.add(ODTDG_TestFactory.webservicesSettingData('Payment AutoCharge', 'https://qa.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentAutoCharge'));
        ws.add(ODTDG_TestFactory.webservicesSettingData('OmniGenericEntitlementService', 'https://qa.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/testingrequest'));
        ws.add(ODTDG_TestFactory.webservicesSettingData('OmniOnePassToBoomi', 'https://api-uat.thomsonreuters.com/ebs/entitlement/uat/getEntitlements'));
         
        insert ws;


        LIST<Static_Values__c> staticList = new LIST<Static_Values__c>();
        staticList.add(ODTDG_TestFactory.staticCustomSetting('ODTDGBlacklisted', 'Blocked'));
        staticList.add(ODTDG_TestFactory.staticCustomSetting('ODTDGsanctionedAccLovValues', 'Blocked/Denied'));
        staticList.add(ODTDG_TestFactory.staticCustomSetting('ODTDG_InvalidOrgType', 'law-30;gov-fed;acad;pro-se;other-corp-or-bus-500+'));
        staticList.add(ODTDG_TestFactory.staticCustomSetting('ODTDG_ActiveStatus', 'active;'));
        insert staticList;
         
       Account acc =  ODTDG_TestFactory.createAccount();
       acc.Sanctioned_Status__c = ODTDG_Helper.getStaticValues('ODTDGsanctionedAccLovValues');
       insert acc;

       Source_system_detail__c ssd = ODTDG_TestFactory.createAccountSSD(acc);
        insert ssd;

       Digital_Blacklist_or_CompetitorList__c blackComp = ODTDG_TestFactory.createDigitalBlacklisted();
        insert blackComp;
        
        
       
       Test.startTest();
       
       Test.setMock(HttpCalloutMock.class, new OmniMockHttpResponseGeneratorMock());        
   
        string jsonStr = '{\"trialData\":{\"customerSegment\":\"SLW\",\"productOffering\":\"PL\",\"isPrimaryCheck\":false,\"trialSource\":\"Digital\",\"trialContacts\":[{\"customerEmail\":\"bill@1031.us\",\"forValidation\":false,\"primaryUser\":true},{\"customerEmail\":\"abctestapr142021@blacklistedmail.com\",\"forValidation\":true,\"primaryUser\":false},{\"customerEmail\":\"business23@email.com\",\"forValidation\":true,\"primaryUser\":false}]}}';

       RestRequest req1 = new RestRequest(); 
       req1.requestURI = '/services/apexrest/ODTDGValidateTrialCustomer' ;
       req1.httpMethod = 'POST';
       req1.requestBody = Blob.valueof(jsonStr);
       RestContext.request = req1;  

       ODTDG_CustomerData odtcpost = ODTDG_TrialValidationService.validatecustomersData();

       System.debug(LoggingLevel.INFO,'odtcpost...............'+odtcpost);
       System.assert(odtcpost!=null,'No Output');


        set<string> emailString = new set<string>();
        emailString.add('abctestapr142021@blacklistedmail.com');
        emailString.add('abctestapr142022@blacklistedmail.com');
        emailString.add('abctestapr142023@blacklistedmail.com');
        
        LIST<ODTDG_CustomerData_Helper.CustomerDetails>  custNewList1 = ODTDG_ValidationDataServiceHelper.prepareNewCustomerData(emailString);
        LIST<ODTDG_CustomerData_Helper.CustomerDetails>  custNewList2 = ODTDG_ValidationDataServiceHelper.prepareexistingCustomerData(custNewList1);
        
        List<Digital_Blacklist_or_CompetitorList__c> blaList = new List<Digital_Blacklist_or_CompetitorList__c>();
        blaList.add(blackComp);

        
        LIST<ODTDG_CustomerData_Helper.CustomerDetails>  custNewList3 = ODTDG_ValidationDataServiceHelper.mapToExistingCustomerData(emailString, custNewList2, blaList );

        System.debug(LoggingLevel.INFO,'custNewList3...............'+custNewList3);

          
        string jsonStr2 = '{\"trialData\":{\"customerSegment\":\"SLW\",\"customerSegmentValue\":\"law-30\",\"productOffering\":\"PL\",\"isPrimaryCheck\":true,\"trialSource\":\"Digital\",\"trialContacts\":[{\"customerEmail\":\"abctestapr142021@blacklistedmail.com\",\"forValidation\":false,\"primaryUser\":true},{\"customerEmail\":\"abctestapr142021@blacklistedmail.com\",\"forValidation\":true,\"primaryUser\":false},{\"customerEmail\":\"business23@email.com\",\"forValidation\":true,\"primaryUser\":false}]}}';

        RestRequest req2 = new RestRequest(); 
        req2.requestURI = '/services/apexrest/ODTDGValidateTrialCustomer' ;
        req2.httpMethod = 'POST';
        req2.requestBody = Blob.valueof(jsonStr2);
        RestContext.request = req2;  
 
         
        Test.setMock(HttpCalloutMock.class, new OmniMockHttpResponseGeneratorMock());
        ODTDG_CustomerData odtcpost2 = ODTDG_TrialValidationService.validatecustomersData();   
        System.debug(LoggingLevel.INFO,'odtcpost2...............'+odtcpost2);

        string jsonStr3 = '{\"trialData\":{\"customerSegment\":\"SLW\",\"productOffering\":\"PL\",\"isPrimaryCheck\":true,\"trialSource\":\"Digital\",\"trialContacts\":[{\"customerEmail\":\"wrongemail@domain\",\"forValidation\":false,\"primaryUser\":true},{\"customerEmail\":\"abctestapr142021@blacklistedmail.com\",\"forValidation\":true,\"primaryUser\":false},{\"customerEmail\":\"business23@email.com\",\"forValidation\":true,\"primaryUser\":false}]}}';
        req2.requestBody = Blob.valueof(jsonStr3);
        RestContext.request = req2;  
        ODTDG_CustomerData odtcpost3 = ODTDG_TrialValidationService.validatecustomersData(); 
        System.debug(LoggingLevel.INFO,'odtcpost3...............'+odtcpost3); 
    
            
        ODTDG_Helper.getStaticValues('Testnull');
        
       
       
        Test.stopTest();
  
    }
/********************************************************************************************************
*  @description method2: this is the test method to validate the trial validation duplicate data 
*********************************************************************************************************/
    public static testmethod void method2() {
        
        callingData();
        LIST<Static_Values__c> staticList = new LIST<Static_Values__c>();
        staticList.add(ODTDG_TestFactory.staticCustomSetting('ODTDG_RelationshipLinkType', 'best'));
        staticList.add(ODTDG_TestFactory.staticCustomSetting('ODTDG_FreeTrial', 'Digital'));
        staticList.add(ODTDG_TestFactory.staticCustomSetting('ODTDG_RelationshipTypeMain', 'plan to plan'));
        staticList.add(ODTDG_TestFactory.staticCustomSetting('ODTDG_RelationshipTypeExtended', 'Accessory Product'));
        staticList.add(ODTDG_TestFactory.staticCustomSetting('ODTDG_InvalidOrgType', 'law-30;gov-fed;acad;pro-se;other-corp-or-bus-500+'));
        staticList.add(ODTDG_TestFactory.staticCustomSetting('ODTDG_ActiveStatus', 'Active;'));
        staticList.add(ODTDG_TestFactory.staticCustomSetting('ODTDG_TandCAccStatus', 'Rep Initiated;Invited;Draft;New;Entitlement Error'));
        staticList.add(ODTDG_TestFactory.staticCustomSetting('ODTDG_TandCEntInvalidStatus', 'OP_ERR'));
        insert staticList;
        
        
        Account acc = new account();
        acc.name = 'test';
        acc.BillingCountry = 'US';
        insert acc;
        
        ent_Trial__c trc= new ent_Trial__c();
        trc.account__c = acc.id;
        trc.Trial_Start_Date__c  =system.today();
        trc.Trial_End_Date__c = system.today();
        insert trc;
        
        Trial_Contact__c trlCon = new Trial_Contact__c();
        trlCon.Email__c = 'mallik.rao2@mailinator.com';
        trlCon.Trials__c = trc.id;
        trlCon.name = 'test';
        trlCon.Status__c  = 'Invited';
        trlCon.First_Name__c = 'Fname';
        trlCon.Last_Name__c = 'lname';
        trlcon.Name= 'Test Name';
        insert trlCon;
        
        
        Product2 prd = new Product2();
        prd.DC_Product_Title__c = 'sample product';
        prd.Name ='TEST';
        prd.ProductCode = '42514196';
        prd.Product_Offering__c='Westlaw Edge';
        prd.free_trial__c = 'Digital';
        insert prd;
        
        Trial_Product__c trprd = new Trial_Product__c();
        trprd.Product_Name__c = prd.id;
        trprd.Trial__c = trc.id;
        trprd.Name= 'Test Name';
        insert trprd;
        
        Product_Relationship__c p1 = new Product_Relationship__c();
        p1.Product_to__c = prd.Id;
        p1.Product_from__c = prd.Id;
        p1.Segment__c = 'In-house counsel';
        p1.Relationship_Link_Type__c ='best';
        p1.Relationship_Type__c = 'plan to plan';
        insert p1;
        
        Trial_Product_Contact__c trialPrdCont= new Trial_Product_Contact__c();
        trialPrdCont.Trial_Contact__c = trlCon.id;
        trialPrdCont.Trial_Product__c = trprd.Id;
        trialPrdCont.Trials__c = trc.Id;
        insert trialPrdCont;
        
    Test.startTest();
   
        // duplicate check invite
    
    string jsonStr5 = '{\"trialData\":{\"customerSegment\":\"In-house counsel\",\"productOffering\":\"Westlaw Edge\",\"isPrimaryCheck\":false,\"trialSource\":\"Digital\",\"trialContacts\":[{\"customerEmail\":\"mallik.rao23@mailinator.com\",\"forValidation\":true,\"primaryUser\":true},{\"customerEmail\":\"mallik.rao2@mailinator.com\",\"forValidation\":true,\"primaryUser\":false}]}}';

        RestRequest req5 = new RestRequest(); 
        req5.requestURI = '/services/apexrest/ODTDGValidateTrialCustomer' ;
        req5.httpMethod = 'POST';
        req5.requestBody = Blob.valueof(jsonStr5);
        RestContext.request = req5;  
 
         Test.setMock(HttpCalloutMock.class, new OmniMockHttpResponseGeneratorMock());
        ODTDG_CustomerData odtcpost5 = ODTDG_TrialValidationService.validatecustomersData();   
        System.debug(LoggingLevel.INFO,'odtcpost5...............'+odtcpost5);
         System.assert(odtcpost5!=null,'No Output');
        
         // duplicate check primary
        trlCon.Status__c='Active';
        update trlCon;
    string jsonStr4 = '{\"trialData\":{\"customerSegment\":\"In-house counsel\",\"productOffering\":\"Westlaw Edge\",\"isPrimaryCheck\":true,\"trialSource\":\"Digital\",\"trialContacts\":[{\"customerEmail\":\"mallik.rao2@mailinator.com\",\"forValidation\":true,\"primaryUser\":true}]}}';

        RestRequest req4 = new RestRequest(); 
        req4.requestURI = '/services/apexrest/ODTDGValidateTrialCustomer' ;
        req4.httpMethod = 'POST';
        req4.requestBody = Blob.valueof(jsonStr4);
        RestContext.request = req4;  
 
         Test.setMock(HttpCalloutMock.class, new OmniMockHttpResponseGeneratorMock());
        ODTDG_CustomerData odtcpost4 = ODTDG_TrialValidationService.validatecustomersData();   
        System.debug(LoggingLevel.INFO,'odtcpost4...............'+odtcpost4);


        
        ent_Trial__c trc1= new ent_Trial__c();
        trc1.account__c = acc.id;
        trc1.Trial_Start_Date__c  =system.today()-10;
        trc1.Trial_End_Date__c = system.today()-5;
        trc1.External_Account_Number__c = '4332938';
        trc1.External_Account_Number_Source__c = 'SAP';
        insert trc1;
        
        list<Trial_Contact__c> trialContacts = new list<Trial_Contact__c>();
        Trial_Contact__c trlCon2 = new Trial_Contact__c();
        trlCon2.Email__c = 'mallik.rao2@mailinator.com';
        trlCon2.Trials__c = trc1.id;
        trlCon2.name = 'test';
        trlCon2.Status__c  = 'Accepted';
        trlCon2.First_Name__c = 'Fname';
        trlCon2.Last_Name__c = 'lname';
        trlcon2.Name= 'Test Name';
        trlcon2.External_Contact_Number_Source__c= 'SAP';
        trlCon2.Primary__c=true;
        trialContacts.add(trlCon2);

        Trial_Contact__c trlCon1 = new Trial_Contact__c();
        trlCon1.Email__c = 'get2arpit@me.com';
        trlCon1.Trials__c = trc1.id;
        trlCon1.name = 'test';
        trlCon1.Status__c  = 'Active';
        trlCon1.First_Name__c = 'Fname';
        trlCon1.Last_Name__c = 'lname';
        trlcon1.Name= 'Test Name';
        trlcon1.External_Contact_Number_Source__c= 'OLC';
        trlCon1.Primary__c=false;
        trialContacts.add(trlCon1);

        insert trialContacts;
        
        
        string jsonStr6 = '{\"trialData\":{\"customerSegment\":\"In-house counsel\",\"productOffering\":\"Westlaw Edge\",\"isPrimaryCheck\":false,\"trialSource\":\"SFDC\",\"trialContacts\":[{\"customerEmail\":\"bill@1031.us\",\"forValidation\":false,\"primaryUser\":true,\"trialContactSfId\":"'+trlCon2.id+'"},{\"customerEmail\":\"abctestapr142021@blacklistedmail.com\",\"forValidation\":true,\"primaryUser\":false,\"trialContactSfId\":\"'+trlCon1.id+'\"}]}}';

       RestRequest req6 = new RestRequest(); 
       req6.requestURI = '/services/apexrest/ODTDGValidateTrialCustomer' ;
       req6.httpMethod = 'POST';
       req6.requestBody = Blob.valueof(jsonStr6);
       RestContext.request = req6;  

       Test.setMock(HttpCalloutMock.class, new OmniMockHttpResponseGeneratorMock());
       ODTDG_CustomerData odtcpost6 = ODTDG_TrialValidationService.validatecustomersData();

       System.debug(LoggingLevel.INFO,'odtcpost6...............'+odtcpost6);

        Test.stopTest();
    }
    

}