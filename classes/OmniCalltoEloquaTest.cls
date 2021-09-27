@isTest
public class OmniCalltoEloquaTest {
    
    @isTest
    public static void testMethod1(){
          Account acc = new account();
        acc.name = 'test';
        acc.BillingCountry = 'US';
        acc.Billingcity= 'Baltimore'; 
        acc.billingstate= 'AK';
        ACC.BillingpostalCode='21204';
        
        insert acc;
        
        Ent_Trial__c trl= new Ent_Trial__c();
        trl.Account__c = acc.id;
        trl.Trial_Start_Date__c  =system.today();
        trl.Trial_End_Date__c = system.today();
        trl.External_Account_Number__c = '4332938';
        trl.External_Account_Number_Source__c = 'SAP';
        insert trl;
        
        
        list<Trial_Contact__c> trialContacts = new list<Trial_Contact__c>();
        Trial_Contact__c trlCon = new Trial_Contact__c();
        trlCon.Email__c = 'get2arpit@me.com';
        trlCon.Trials__c = trl.id;
        trlCon.name = 'test';
        trlCon.Status__c  = 'Draft';
        trlCon.First_Name__c = 'Fname';
        trlCon.Last_Name__c = 'lname';
        trlcon.Name= 'Test Name';
        trlcon.External_Contact_Number_Source__c= 'SAP';
        trialContacts.add(trlCon);
        
        Trial_Contact__c trlCon1 = new Trial_Contact__c();
        trlCon1.Email__c = 'get2arpit@me.com';
        trlCon1.Trials__c = trl.id;
        trlCon1.name = 'test';
        trlCon1.Status__c  = 'Draft';
        trlCon1.First_Name__c = 'Fname';
        trlCon1.Last_Name__c = 'lname';
        trlcon1.Name= 'Test Name';
        trlcon1.External_Contact_Number_Source__c= 'OLC';
        trialContacts.add(trlCon1);
        insert trialContacts;
        
          Product2 prd = new Product2();
        prd.DC_Product_Title__c = 'sample product';
        prd.Name ='TEST';
        prd.ProductCode = '824925';
        insert prd;
        
        
        list<Trial_Product__c> trialProducts = new list<Trial_Product__c>();
        
        Trial_Product__c trprd = new Trial_Product__c();
        trprd.Product_Name__c = prd.id;
        trprd.Trial__c = trl.id;
        trprd.Name= 'Test Name';
        trprd.Relationship_Type__c = 'Plan to Plan';
        
        trialProducts.add(trprd);
         Trial_Product__c trprd1 = new Trial_Product__c();
        trprd1.Product_Name__c = prd.id;
        trprd1.Trial__c = trl.id;
        trprd1.Name= 'Test Name';
        trprd1.Relationship_Type__c = 'Accessory Product';
        trialProducts.add(trprd1);
        insert trialProducts;  
        
        KeyValueListStore__c kvlQA = new KeyValueListStore__c();
        kvlQA.name ='OmniEloquaCallTestEnv';
        kvlQA.TextValue__c = 'QA';
        insert kvlQA;
        KeyValueListStore__c kvl = new KeyValueListStore__c();
        kvl.name ='OmniTrialPrdSizeToEloqua';
        kvl.TextValue__c = '123232';
        insert kvl;
        KeyValueListStore__c kvl2 = new KeyValueListStore__c();
        kvl2.name ='OmniEloquaCallEncryptionKey';
        kvl2.TextValue__c = 'ondemandtrialpro';
        insert kvl2;
         WebServiceSettings__c  wb1 = new WebServiceSettings__c ();
        wb1.Name = 'OmniEntTrialsEloqua';
        wb1.CurrencyIsoCode = 'USD';
        wb1.Active__c = true;
        wb1.Endpoint__c = 'https://api-uat.thomsonreuters.com/ebs/entitlement/uat/getEntitlements' ;
        wb1.Service_Unavailable_Message__c ='ODTGenericEntitlement Service used to fetch online contacts from OLC';
        wb1.Timeout__c = 120 ; 
       insert wb1;
        
        Test.setMock(HttpCalloutMock.class, new OmniMockHttpResponseGeneratorMock());
        test.startTest();
        
        List<Id> trialContId = new List<Id>();
        trialContId.add(trlCon.Id);
        
        List<Id> trialPrdId = new List<Id>();
        trialPrdId.add(trprd1.Id);
        
        OmniCalltoEloqua.getOmniTrialsEloquaCallsLWC(String.valueof(JSON.serialize(trl.Id)),String.valueof(JSON.serialize(trialContId)),String.valueof(JSON.serialize(trialPrdId)));
        
        test.stopTest();
        SYSTEM.assertEquals(true, Ent_Trial__c.trial_status__c!=null,'SUCCESS');
        
    }
        
    @isTest
    public static void testMethod11(){
          Account acc = new account();
        acc.name = 'test';
        acc.BillingCountry = 'US';
        acc.Billingcity= 'Baltimore'; 
        acc.billingstate= 'AK';
        ACC.BillingpostalCode='21204';
        
        insert acc;
        
        Ent_Trial__c trl= new Ent_Trial__c();
        trl.Account__c = acc.id;
        trl.Trial_Start_Date__c  =system.today();
        trl.Trial_End_Date__c = system.today();
        trl.External_Account_Number__c = '4332938';
        trl.External_Account_Number_Source__c = 'SAP';
        insert trl;
        
        
        list<Trial_Contact__c> trialContacts = new list<Trial_Contact__c>();
        Trial_Contact__c trlCon = new Trial_Contact__c();
        trlCon.Email__c = 'get2arpit@me.com';
        trlCon.Trials__c = trl.id;
        trlCon.name = 'test';
        trlCon.Status__c  = 'Draft';
        trlCon.First_Name__c = 'Fname';
        trlCon.Last_Name__c = 'lname';
        trlcon.Name= 'Test Name';
        trlcon.External_Contact_Number_Source__c= 'SAP';
        trialContacts.add(trlCon);
        
        Trial_Contact__c trlCon1 = new Trial_Contact__c();
        trlCon1.Email__c = 'get2arpit@me.com';
        trlCon1.Trials__c = trl.id;
        trlCon1.name = 'test';
        trlCon1.Status__c  = 'Draft';
        trlCon1.First_Name__c = 'Fname';
        trlCon1.Last_Name__c = 'lname';
        trlcon1.Name= 'Test Name';
        trlcon1.External_Contact_Number_Source__c= 'OLC';
        trialContacts.add(trlCon1);
        insert trialContacts;
        
          Product2 prd = new Product2();
        prd.DC_Product_Title__c = 'sample product';
        prd.Name ='TEST';
        prd.ProductCode = '824925';
        insert prd;
        
        
        list<Trial_Product__c> trialProducts = new list<Trial_Product__c>();
        
        Trial_Product__c trprd = new Trial_Product__c();
        trprd.Product_Name__c = prd.id;
        trprd.Trial__c = trl.id;
        trprd.Name= 'Test Name';
        trprd.Relationship_Type__c = 'Plan to Plan';
        
        trialProducts.add(trprd);
         Trial_Product__c trprd1 = new Trial_Product__c();
        trprd1.Product_Name__c = prd.id;
        trprd1.Trial__c = trl.id;
        trprd1.Name= 'Test Name';
        trprd1.Relationship_Type__c = 'Accessory Product';
        trialProducts.add(trprd1);
        insert trialProducts;  
        
        KeyValueListStore__c kvlQA = new KeyValueListStore__c();
        kvlQA.name ='OmniEloquaCallTestEnv';
        kvlQA.TextValue__c = 'QA';
        insert kvlQA;
        KeyValueListStore__c kvl = new KeyValueListStore__c();
        kvl.name ='OmniTrialPrdSizeToEloqua';
        kvl.TextValue__c = '123232';
        insert kvl;
        
        KeyValueListStore__c kvl2 = new KeyValueListStore__c();
        kvl2.name ='OmniEloquaCallEncryptionKey';
        kvl2.TextValue__c = 'ondemandtrialpro';
        insert kvl2;
        
        
         WebServiceSettings__c  wb1 = new WebServiceSettings__c ();
        wb1.Name = 'OmniEntTrialsEloqua';
        wb1.CurrencyIsoCode = 'USD';
        wb1.Active__c = true;
        wb1.Endpoint__c = 'https://api-uat.thomsonreuters.com/ebs/entitlement/uat/getEntitlements' ;
        wb1.Service_Unavailable_Message__c ='ODTGenericEntitlement Service used to fetch online contacts from OLC';
        wb1.Timeout__c = 120 ; 
       insert wb1;
        
        Test.setMock(HttpCalloutMock.class, new OmniMockHttpResponseGeneratorMock());
        test.startTest();
        
        list<id> trialContactIds = new list<id>{trlCon.id};
        list<id> trialProductIds = new list<id>{trprd.id};
            
        OmniCalltoEloqua.getOmniTrialsEloquaCalls(trl.id,trialContactIds,trialProductIds);


        OmniCalltoEloquaHelper.getTrialProdMappingUrl(trl,trialProducts);
        OmniCalltoEloquaHelper.getTrialContMappingUrl(trl,trlCon);
        OmniCalltoEloquaHelper.getTrialContMappingUrl(trl,trlCon1);
        OmniCalltoEloquaHelper.getEntTrialMappingUrl(trl);
        OmniCalltoEloquaHelperTwo.updateTrialStatus(trl.Id,trialContacts);
        
        
        List<Id> trialContId = new List<Id>();
        trialContId.add(trlCon.Id);
        
        List<Id> trialPrdId = new List<Id>();
        trialPrdId.add(trprd1.Id);
        
        //OmniCalltoEloqua.getOmniTrialsEloquaCallsLWC(String.valueof(JSON.serialize(trl.Id)),String.valueof(JSON.serialize(trialContId)),String.valueof(JSON.serialize(trialPrdId)));
        
        test.stopTest();
        SYSTEM.assertEquals(true, Ent_Trial__c.trial_status__c!=null,'SUCCESS');
        
    }
}