@isTest
public class OmniTrialContactSubmitEntl_Test {
    
    @isTest
    public static void testMethod1(){
       
       OmniCustomerSegmentCreateTrial__c cs = new OmniCustomerSegmentCreateTrial__c();
       cs.Bu_Segment__c = 'Government';
       cs.Country__c = 'US';
       cs.Customer_Segment_Value__c = '03';
       cs.Government_Type__c = 'Federal';
       cs.name ='test';
       insert cs;
       
       OmniContactFunctionCreateTrial__c cf = new OmniContactFunctionCreateTrial__c();
       cf.Bu_Segment__c = 'Government';
       cf.Contact_Function_Value__c = '50';
       cf.name ='test';
       insert cf;
       Product2 obj = new Product2();
        obj.DC_Product_Title__c = 'test1';
        obj.Name = 'test1';
        obj.Family ='CD';
        obj.Free_Trial__c = 'Omni';
        obj.family='WESTLAW';
        insert obj;
       
        Account acc = new Account();
        acc.name = 'test acc';
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('GLI Account').getRecordTypeId();  
        acc.BU_Region__c = 'Canada';
        acc.Bu_Segment__c = 'Government';
        acc.ECC_Government_Type__c = 'Federal';
        acc.BillingCountryCode = 'US';
        acc.Is_GLI__c = true;
        insert acc;
        
        Ent_Trial__c trl= new Ent_Trial__c();
        trl.Account__c = acc.id;
        trl.Trial_Status__c = 'Accepted';
        trl.Trial_Start_Date__c  =system.today();
        trl.Trial_End_Date__c = system.today();
        trl.External_Account_Number__c = '4332938';
        insert trl;  
        
        Trial_Contact__c trlCon = new Trial_Contact__c();
        trlCon.Email__c = 'get2arpit@me.com';
        trlCon.Trials__c = trl.id;
        trlCon.name = 'test';
        trlCon.Status__c  = 'Draft';
        trlCon.First_Name__c = 'Fname';
        trlCon.Last_Name__c = 'lname';
        trlCon.Last_Name__c = 'NET_NEW';
        trlcon.Name= 'Test Name';
        trlcon.COBALT_GUID__c = 'jkakjndjkankdjnk';
        trlcon.DATAROOM_GUID__c = 'jkakjndjkankdjnk';
        insert trlCon;
        
        Trial_Contact__c trlCon1 = new Trial_Contact__c();
        trlCon1.Email__c = 'get2arpit@me2.com';
        trlCon1.Trials__c = trl.id;
        trlCon1.name = 'test';
        trlCon1.Status__c  = 'Accepted';
        trlCon1.First_Name__c = 'Fname';
        trlCon1.Last_Name__c = 'lname';
        trlCon1.Last_Name__c = 'NET_NEW';
        trlcon1.Name= 'Test Name';
        insert trlCon1;
        
        Trial_Product__c tp = new Trial_Product__c();
        tp.Product_Name__c = obj.Id;
        tp.Trial__c = trl.id;
        insert tp;
        
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
        OmniTrialContactSubmitEntitlment.processRec(trlCon.ID);
        OmniTrialContactSubmitEntitlment.processRec(trlCon1.ID);
        test.stopTest();
        system.assertEquals('Accepted',trl.Trial_Status__c ,'SUCCESS');
    }
    
    @isTest
    public static void testMethod2(){
       
       OmniCustomerSegmentCreateTrial__c cs = new OmniCustomerSegmentCreateTrial__c();
       cs.Bu_Segment__c = 'Government';
       cs.Country__c = 'US';
       cs.Customer_Segment_Value__c = '03';
       cs.Government_Type__c = 'FEDERAL GOVERNMENT';
       cs.name ='test';
       insert cs;
       
       OmniContactFunctionCreateTrial__c cf = new OmniContactFunctionCreateTrial__c();
       cf.Bu_Segment__c = 'Government';
       cf.Contact_Function_Value__c = '50';
       cf.name ='test';
       insert cf;
       Product2 obj = new Product2();
        obj.DC_Product_Title__c = 'test1';
        obj.Name = 'test1';
        obj.Family ='CD';
        obj.Free_Trial__c = 'Omni';
        obj.family='WESTLAW';
        insert obj;
       
        Account acc = new Account();
        acc.name = 'test acc';
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('GLI Account').getRecordTypeId();  
        acc.BU_Region__c = 'Canada';
        acc.Bu_Segment__c = 'Government';
        acc.ECC_Government_Type__c = 'Federal';
        acc.BillingCountryCode = 'US';
        acc.Is_GLI__c = true;
        insert acc;
        
        Ent_Trial__c trl= new Ent_Trial__c();
        trl.Account__c = acc.id;
        trl.Trial_Status__c = 'Accepted';
        trl.Trial_Start_Date__c  =system.today();
        trl.Trial_End_Date__c = system.today();
        trl.External_Account_Number__c = '4332938';
        trl.Trial_Source__c = 'Digital';
        insert trl;  
        
        Trial_Contact__c trlCon = new Trial_Contact__c();
        trlCon.Email__c = 'get2arpit@me.com';
        trlCon.Trials__c = trl.id;
        trlCon.name = 'test';
        trlCon.Status__c  = 'Draft';
        trlCon.First_Name__c = 'Fname';
        trlCon.Last_Name__c = 'lname';
        trlCon.Last_Name__c = 'NET_NEW';
        trlcon.Name= 'Test Name';
        trlcon.COBALT_GUID__c = 'jkakjndjkankdjnk';
        trlcon.DATAROOM_GUID__c = 'jkakjndjkankdjnk';
        insert trlCon;
        
        Trial_Contact__c trlCon1 = new Trial_Contact__c();
        trlCon1.Email__c = 'get2arpit@me2.com';
        trlCon1.Trials__c = trl.id;
        trlCon1.name = 'test';
        trlCon1.Status__c  = 'Accepted';
        trlCon1.First_Name__c = 'Fname';
        trlCon1.Last_Name__c = 'lname';
        trlCon1.Last_Name__c = 'NET_NEW';
        trlcon1.Name= 'Test Name';
        insert trlCon1;
        
        Trial_Product__c tp = new Trial_Product__c();
        tp.Product_Name__c = obj.Id;
        tp.Trial__c = trl.id;
        insert tp;
        
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
        OmniTrialContactSubmitEntitlment.processRec(trlCon.ID);
        OmniTrialContactSubmitEntitlment.processRec(trlCon1.ID);
        test.stopTest();
        system.assertEquals('Accepted',trl.Trial_Status__c ,'SUCCESS');
    }
}