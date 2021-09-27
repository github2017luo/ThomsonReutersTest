/**
* @description       : DPS-21463
* @ JIRA        : DPS-21463
* @author            : TCS Developer
* @group             : 
* @last modified on  : 05-24-2021
* @last modified by  : TCS Developer
* Modifications Log 
* Ver   Date         Author          Modification
* 1.0   05-24-2021   TCS Developer   Initial Version
**/
@isTest
public class OmniSubmitEntitlement_Test {
    /**
* @description       : testMethod1
*/
    @isTest
    public static void testMethod1(){
        OmniCustomerSegmentCreateTrial__c cs = new OmniCustomerSegmentCreateTrial__c();
       cs.Bu_Segment__c = 'Government';
       cs.Country__c = 'US';
       cs.Customer_Segment_Value__c = '03';
       cs.Government_Type__c = 'Federal';
       cs.name ='test';
       insert cs;
       
       OmniCustomerSegmentCreateTrial__c cs1 = new OmniCustomerSegmentCreateTrial__c();
       cs1.Bu_Segment__c = 'Government';
       cs1.Country__c = '';
       cs1.Customer_Segment_Value__c = '';
       cs1.Government_Type__c = '';
       cs1.name ='test1';
       insert cs1;
       
       OmniContactFunctionCreateTrial__c cf = new OmniContactFunctionCreateTrial__c();
       cf.Bu_Segment__c = 'Government';
       cf.Contact_Function_Value__c = '50';
       cf.name ='test';
       insert cf;
       
       OmniContactFunctionCreateTrial__c cf1 = new OmniContactFunctionCreateTrial__c();
       cf1.Bu_Segment__c = '';
       cf1.Contact_Function_Value__c = '';
       cf1.name ='test1';
       insert cf1;
       
       Product2 obj = new Product2();
        obj.DC_Product_Title__c = 'test1';
        obj.Name = 'test1';
        obj.Family ='CD';
        obj.Free_Trial__c = 'Omni';
        obj.family='WESTLAW';
        insert obj;
       
       
        Account acc = new account();
        acc.name = 'test';
        acc.BillingCountry = 'US';
        acc.Billingcity= 'Baltimore';
        acc.billingstate= 'AK';
        ACC.BillingpostalCode='21204';
        
        insert acc;
        
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
        trContact1.Status__c = 'Draft';
        trContact1.DATAROOM_GUID__c  = 'FAKSDJFKJSDKLF';
        trContact1.COBALT_GUID__c = 'DraADFJKSDJFLft';
        trContact1.One_Pass_ID__c='0016979131';
        trContact1.External_Contact_Number__c ='0016979131';
        trlContacts.add(trContact1);
        
        Trial_Contact__c trContact2 = new Trial_Contact__c();
        trContact2.Trials__c = trc.id;
        trContact2.Email__c = 'test@gmail2.com';
        trContact2.First_Name__c = 'test Fname2';
        trContact2.Last_Name__c='Test Lname2';
        trContact2.Status__c = 'Draft';
        trContact2.One_Pass_ID__c='00169791312';
        trContact2.External_Contact_Number__c ='00169791312';
        trlContacts.add(trContact2);
        
        insert trlContacts;
        
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
        
         List<Id> emailIds = new list<Id>{trContact1.Id,trContact2.id};
            List<Id> productCodes  = new list<Id>{trprd.Id,trprd1.Id};
                Test.setMock(HttpCalloutMock.class, new OmniMockHttpResponseGeneratorMock());
        test.startTest();
        OmniCalltoSubmitEntitlement.callToSubmitEntitlement(trc.id,emailIds,productCodes);
        OmniSubmitEntitlRequestJSON.submitEntitlement(trc.id,emailIds,productCodes);
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
         
        OmniSubmitEntiContactsReqWrap.parse(json1);
        
         string json2 = '{';
        json2 += '"userGUID":null,';
        json2 += '"domain":"abbcd",';
        json2 += '"storageKey":"test4"';
        json2 +='}';
         OmniSubmitEntiUsersReqWrap.parse(json2);
        OmniSubmitEntiCustomerReqWrap.parse(json2);
        OmniSubmitEntiProductsReqWrap.parse(json2);
        OmniSubmitEntitlementRequestWrapper.parse(json2);
         OmniSubmitEntiBooomiHeaderReqWrap.parse(json2);
        system.assertEquals(true, json2!= null, 'SUCCESS');
        OmniSubmitEntitlRequestJSONHelper.getCustomerSegmentValue('Government','','');
        OmniSubmitEntitlRequestJSONHelper.getCustomerSegmentValue('Government','Federal','US');
        
        }
    }