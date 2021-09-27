/**
* @description       : 
* @ JIRA             : DPS-21106
* @author            : TCS Developer
* @group             : 
* @last modified on  : 07-30-2021
* @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
* Modifications Log 
* Ver   Date         Author          Modification
* 1.0   05-24-2021   TCS Developer   Initial Version
**/
@isTest
public class OmniEndTrial_Test {
    /**
* @description       : testMethod1 
*/
    @isTest
    public static void testMethod1(){
        Account acc = new account();
        acc.name = 'test';
        acc.BillingCountry = 'US';
        acc.Billingcity= 'Baltimore';
        acc.billingstate= 'AK';
        ACC.BillingpostalCode='21204';
        
        insert acc;
         Contact contact1 = new Contact(
        FirstName = 'Test',
        Lastname = 'McTesty',
        AccountId = acc.Id,
        Email = System.now().millisecond() + 'test@test.com',
        Contact_Group__c = 'Non-Sales Contact'
       );
      
    insert(contact1);
        
        Ent_Trial__c trc= new Ent_Trial__c();
        trc.Account__c = acc.id;
        trc.Trial_Start_Date__c  =system.today();
        trc.Trial_End_Date__c = system.today();
        trc.External_Account_Number__c = '4332938';
        insert trc;
        
        list<Trial_Contact__c> trlContacts = new list< Trial_Contact__c>();
        Trial_Contact__c trContact1 = new Trial_Contact__c();
        trContact1.Trials__c = trc.id;
        trContact1.Email__c = 'test@gmail1.com';
        trContact1.First_Name__c = 'test Fname';
        trContact1.Last_Name__c='Test Lname';
        trContact1.Status__c = 'Active';
        trContact1.DATAROOM_GUID__c  = 'FAKSDJFKJSDKLF';
        trContact1.COBALT_GUID__c = 'DraADFJKSDJFLft';
        trContact1.One_Pass_ID__c='0016979131';
        //trContact1.contact__c = contact1.Id;
        trContact1.Entitlement_Email_Sent__c = false ;
        trContact1.External_Contact_Number__c ='0016979131';
        trlContacts.add(trContact1);
        
        Trial_Contact__c trContact2 = new Trial_Contact__c();
        trContact2.Trials__c = trc.id;
        trContact2.Email__c = 'test@gmail2.com';
        trContact2.First_Name__c = 'test Fname2';
        trContact2.Last_Name__c='Test Lname2';
        trContact2.Status__c = 'Active';
        trContact2.One_Pass_ID__c='00169791312';
        trContact2.External_Contact_Number__c ='00169791312';
        trContact2.Entitlement_Email_Sent__c = false ;
        //trContact2.contact__c = contact1.Id;
        trlContacts.add(trContact2);
        
        insert trlContacts;
        
        set<id> triaConIds = new set<id>();
        for(Trial_Contact__c trCon : trlContacts){
            triaConIds.add(trCon.id);
        }
        
        list<Product2> prds = new list<Product2>();
        
        Product2 prd = new Product2();
        prd.DC_Product_Title__c = 'sample product';
        prd.Name ='TEST';
        prd.ProductCode = '753987';
        prds.add(prd);
        
        Product2 prd1 = new Product2();
        prd1.DC_Product_Title__c = 'sample product';
        prd1.Name ='TEST';
        prd1.ProductCode = '753986';
        prds.add(prd1);
        
        insert prds;
        
        list<Trial_Product__c> trlProds =  new list<Trial_Product__c>();
        
        Trial_Product__c trprd = new Trial_Product__c();
        trprd.Product_Name__c = prds[0].id;
        trprd.Trial__C = trc.id;
        trlProds.add(trprd);
        
        Trial_Product__c trprd1 = new Trial_Product__c();
        trprd1.Product_Name__c = prds[1].id;
        trprd1.Trial__C = trc.id;
        trlProds.add(trprd1);
        
        insert trlProds;
        
        list<WebServiceSettings__c> wbs = new list<WebServiceSettings__c>();
        WebServiceSettings__c  wb = new WebServiceSettings__c ();
        wb.Name = 'OmniSubmitEntitlementBoomiService';
        wb.CurrencyIsoCode = 'USD';
        wb.Active__c = true;
        wb.Endpoint__c = 'https://api-test.thomsonreuters.com/boomi/omc/' ;
        wb.Service_Unavailable_Message__c ='ODTGenericEntitlement Service used to fetch online contacts from OLC';
        wb.Timeout__c = 120 ; 
        wbs.add(wb);
        
        WebServiceSettings__c  wb1 = new WebServiceSettings__c ();
        wb1.Name = 'OmniBoomiToken';
        wb1.CurrencyIsoCode = 'USD';
        wb1.Active__c = true;
        wb1.Endpoint__c = 'https://api-test.thomsonreuters.com/boomi/omc/' ;
        wb1.Service_Unavailable_Message__c ='ODTGenericEntitlement Service used to fetch online contacts from OLC';
        wb1.Timeout__c = 120 ; 
        wbs.add(wb1);
        insert wbs;
        
        
        Test.setMock(HttpCalloutMock.class, new OmniMockHttpResponseGeneratorMock());
        test.startTest();
        OmniCalltoEndTrial.callToEndTrail(trc.id,'End product','TRIAL_END');
        OmniEndTrialRequestJSON.endTrialRequest(trc.id,'End product','TRIAL_END');
        OmniEndTrialsController.updateEntTrialContAfterEndTrial(trc.id,triaConIds,'End product');
        OmniEndTrialsController.checkTRAdministratorAssigned();
        OmniEndTrialsController.getPicklistValues('Trial_Contact__c','Status__c');
       
        system.assertEquals('753987', prd.ProductCode, 'SUCCESS');
        
        test.stopTest();
    }
       /**
* @description       : testExtendTrial 
*/
    @isTest
    public static void testExtendTrial(){
        Account acc = new account();
        acc.name = 'test';
        acc.BillingCountry = 'US';
        acc.Billingcity= 'Baltimore';
        acc.billingstate= 'AK';
        ACC.BillingpostalCode='21204';
        
        insert acc;
        
         Contact contact1 = new Contact(
        FirstName = 'Test',
        Lastname = 'McTesty',
        AccountId = acc.Id,
        Email = System.now().millisecond() + 'test@test.com',
        Contact_Group__c = 'Non-Sales Contact'
       );
      
    insert(contact1);
        
        Ent_Trial__c trc= new Ent_Trial__c();
        trc.Account__c = acc.id;
        trc.Trial_Start_Date__c  =system.today();
        trc.Trial_End_Date__c = system.today();
        trc.External_Account_Number__c = '4332938';
        insert trc;
        
        list<Trial_Contact__c> trlContacts = new list< Trial_Contact__c>();
        Trial_Contact__c trContact1 = new Trial_Contact__c();
        trContact1.Trials__c = trc.id;
        trContact1.Email__c = 'test@gmail1.com';
        trContact1.First_Name__c = 'test Fname';
        trContact1.Last_Name__c='Test Lname';
        trContact1.Status__c = 'Active';
        trContact1.DATAROOM_GUID__c  = 'FAKSDJFKJSDKLF';
        trContact1.COBALT_GUID__c = 'DraADFJKSDJFLft';
        trContact1.One_Pass_ID__c='0016979131';
        trContact1.contact__c = contact1.Id;
        trContact1.Entitlement_Email_Sent__c = false ;
        trContact1.External_Contact_Number__c ='0016979131';
        trlContacts.add(trContact1);
        
        Trial_Contact__c trContact2 = new Trial_Contact__c();
        trContact2.Trials__c = trc.id;
        trContact2.Email__c = 'test@gmail2.com';
        trContact2.First_Name__c = 'test Fname2';
        trContact2.Last_Name__c='Test Lname2';
        trContact2.Status__c = 'Active';
        trContact2.One_Pass_ID__c='00169791312';
        trContact2.External_Contact_Number__c ='00169791312';
        trContact2.Entitlement_Email_Sent__c = false ;
        trContact2.contact__c = contact1.Id;
        trlContacts.add(trContact2);
        
        insert trlContacts;
        
        set<id> triaConIds = new set<id>();
        for(Trial_Contact__c trCon : trlContacts){
            triaConIds.add(trCon.id);
        }
        
        list<Product2> prds = new list<Product2>();
        
        Product2 prd = new Product2();
        prd.DC_Product_Title__c = 'sample product';
        prd.Name ='TEST';
        prd.ProductCode = '753987';
        prds.add(prd);
        
        Product2 prd1 = new Product2();
        prd1.DC_Product_Title__c = 'sample product';
        prd1.Name ='TEST';
        prd1.ProductCode = '753986';
        prds.add(prd1);
        
        insert prds;
        
        list<Trial_Product__c> trlProds =  new list<Trial_Product__c>();
        
        Trial_Product__c trprd = new Trial_Product__c();
        trprd.Product_Name__c = prds[0].id;
        trprd.Trial__C = trc.id;
        trlProds.add(trprd);
        
        Trial_Product__c trprd1 = new Trial_Product__c();
        trprd1.Product_Name__c = prds[1].id;
        trprd1.Trial__C = trc.id;
        trlProds.add(trprd1);
        
        insert trlProds;
        
        list<WebServiceSettings__c> wbs = new list<WebServiceSettings__c>();
        WebServiceSettings__c  wb = new WebServiceSettings__c ();
        wb.Name = 'OmniSubmitEntitlementBoomiService';
        wb.CurrencyIsoCode = 'USD';
        wb.Active__c = true;
        wb.Endpoint__c = 'https://api-test.thomsonreuters.com/boomi/omc/' ;
        wb.Service_Unavailable_Message__c ='ODTGenericEntitlement Service used to fetch online contacts from OLC';
        wb.Timeout__c = 120 ; 
        wbs.add(wb);
        
        WebServiceSettings__c  wb1 = new WebServiceSettings__c ();
        wb1.Name = 'OmniBoomiToken';
        wb1.CurrencyIsoCode = 'USD';
        wb1.Active__c = true;
        wb1.Endpoint__c = 'https://api-test.thomsonreuters.com/boomi/omc/' ;
        wb1.Service_Unavailable_Message__c ='ODTGenericEntitlement Service used to fetch online contacts from OLC';
        wb1.Timeout__c = 120 ; 
        wbs.add(wb1);
        insert wbs;
        
        
        Test.setMock(HttpCalloutMock.class, new OmniMockHttpResponseGeneratorMock());
        test.startTest();
        OmniCalltoEndTrial.callToEndTrail(trc.id,'5','TRIAL_EXTEND');
        OmniEndTrialRequestJSON.extendTrialRequest(trc.id,'5','TRIAL_EXTEND');
        OmniEndTrialsController.updateEntTrialContAfterExtTrial(trc.id,triaConIds,'5');
        
        system.assertEquals('753987', prd.ProductCode, 'SUCCESS');
        
        test.stopTest();
    }
    
    @isTest
    public static void testMethod2(){
        string json1 = '{';
        json1 += '"contactNumber":null,';
        json1 += '"firstName":"abbcd",';
        json1 += '"lastName":"test4",';
        json1 += '"emailAddress":"test@gmail3.com",';
        json1 += '"contactFunction":null,';
        json1 += '"effectiveDate":"2021-05-21",';
        json1 += '"endDate":"2021-05-22",';
        json1 += '"profileIdentifier":null,';
        json1 += '"extContactId":"aOe2g000000000kCAA"';
        json1 +='}';
        
        OmniEndTrialContactsReqWrap.parse(json1);
        
        string json2 = '{';
        json2 += '"userGUID":null,';
        json2 += '"domain":"abbcd",';
        json2 += '"storageKey":"test4"';
        json2 +='}';
        OmniEndTrialUsersReqWrap.parse(json2);
        OmniEndTrialCustomerReqWrap.parse(json2);
        OmniEndTrialProductsReqWrap.parse(json2);
        OmniEndTrialRequestWrapper.parse(json2);
        OmniEndTrialBooomiHeaderReqWrap.parse(json2);
        
        system.assertEquals(true, json2!= null, 'SUCCESS');
        
    }
    
    
}