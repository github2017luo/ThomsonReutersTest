@isTest
public  class LTS_DataUtilityTest {

    @isTest
    static void getCountryCodeTest()
    {   
        Country__c countryValues = new Country__c();
        countryValues.Name = 'New Country';
        countryValues.Country_Code__c = 'NC'; 
        insert  countryValues;      
        Test.startTest();        
        LTS_DataUtility.getCountryCode();
        System.assertEquals(LTS_DataUtility.getCountryCode().isEmpty(),false);
        Test.stopTest();
    }

    @isTest
    static void getStateValuesTest()
    { 
        Country_Region__c stateValues = new Country_Region__c();
        stateValues.Name = 'TestState';
        stateValues.Country_Code__c = 'TestCountry';
        stateValues.Region_Code__c = 'TestRC';
        stateValues.Region_Name__c = 'TestRN';
        insert stateValues;
        Test.startTest();     
        LTS_DataUtility.getStateValues('TestCountry');
        System.assertEquals(LTS_DataUtility.getStateValues('TestCountry').isEmpty(),false);
        Test.stopTest();

    }

    @isTest
    static void getAccountAddressTest(){

          Account accObj = new Account();
          accObj.name = 'test acc';
          accObj.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('GLI Account').getRecordTypeId();  
          accObj.BU_Region__c = 'Canada';
          accObj.Bu_Segment__c = 'Professional Tax';
          accObj.Is_GLI__c = true;
          accObj.Sales_Org__c = 'GLI';   
          accObj.BillingStreet = 'Test';
          accObj.Street_Address_2__c= 'Test';
          accObj.County__c= 'Test';
          accObj.BillingPostalCode= 'Test';
          accObj.BillingCity= 'Test';
          accObj.BillingCountry  = 'US'; 
          accObj.BillingState= 'TX';
          accObj.PO_Box__c= 'Test';
          accObj.Suite_Number__c= 'Test';
          accObj.ECM_Party_ID__c= 'Test';
          insert accObj;

        Test.startTest();     
        LTS_DataUtility.getAccountAddress(accObj.Id);
        System.assertEquals(LTS_DataUtility.getAccountAddress(accObj.Id).isEmpty(),false);
        Test.stopTest();

    }
    
    @isTest
    static void validateAddressTest(){

        Map<String,String> stringMap = new Map<String,String>();
                stringMap.put('AccountName','AccountName');
                stringMap.put('BillingCity','BillingCity');
                stringMap.put('BillingCountry','BillingCountry');
                stringMap.put('BillingCounty','BillingCounty');
                stringMap.put('BillingPoBox','BillingPoBox');
                stringMap.put('BillingPostalCode','BillingPostalCode');
                stringMap.put('BillingProvince','BillingProvince');
                stringMap.put('BillingState','BillingState');
                stringMap.put('BillingStreet','BillingStreet');

                Test.startTest();     
                LTS_DataUtility.validateAddress(stringMap);
                System.assertEquals(LTS_DataUtility.validateAddress(stringMap).isEmpty(),false);
                Test.stopTest();


    }
    
    @isTest
    static void populateBuRegionTest(){

        Account accObj = new Account();
          accObj.name = 'test acc';
          accObj.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('GLI Account').getRecordTypeId();  
          accObj.BU_Region__c = 'Canada';
          accObj.Bu_Segment__c = 'Professional Tax';
          accObj.Is_GLI__c = true;
          accObj.Sales_Org__c = 'GLI';   
          accObj.BillingStreet = 'Test';
          accObj.Street_Address_2__c= 'Test';
          accObj.County__c= 'Test';
          accObj.BillingPostalCode= 'Test';
          accObj.BillingCity= 'Test';
          accObj.BillingCountryCode  = 'US'; 
          accObj.BillingStateCode= 'TX';
          accObj.PO_Box__c= 'Test';
          accObj.Suite_Number__c= 'Test';
          accObj.ECM_Party_ID__c= 'Test';
          insert accObj;

        Test.startTest();     
        LTS_DataUtility.populateBuRegion(accObj.Id,'US');
        LTS_DataUtility.getExcludedCountries();
        System.assertEquals(accObj.BU_Region__c != '',true);
        Test.stopTest();


    }

    @isTest
    static void getLeadAddressTest(){

        KeyValueListStore__c profilename = new KeyValueListStore__c();
        profilename.TextValue__c = 'TR Corp Partner Community User';
        profilename.Name = 'LTS_partnerUserProfileName';
        insert profilename;

        
        
        KeyValueListStore__c leadsourcevalue = new KeyValueListStore__c();
        leadsourcevalue.Name = 'LTS_partnerUserLeadSourceValue';
        leadsourcevalue.TextValue__c = 'Partner';
        insert leadsourcevalue;
        
        KeyValueListStore__c busegment = new KeyValueListStore__c();
        busegment.Name = 'LTS_partnerUserBUSegmentValue';
        busegment.TextValue__c = 'Corporate';
        insert busegment;

        Lead objLead = new Lead();
        objLead.FirstName = 'Unit';
        objLead.LastName = 'Tester1';
        objLead.Company = 'Tester1';
        objLead.Status = 'Contacting';         
        objLead.LCRM_Sub_BU__c='US';
        objLead.BU_Segment__c='Corporate';
        objLead.Is_GLI__c = true;        
        objLead.Billing_Street__c = 'Test';
        objLead.Billing_City__c = 'Test';
        objLead.Billing_Country__c = 'Test';
        objLead.Billing_State__c = 'Test';
        objLead.Billing_Zip__c = 'Test';
        objLead.County__c = 'Test';
        objLead.PO_Box__c = 'Test';
        objLead.recordtypeId = Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName().get('GLI').getRecordTypeId(); 
        insert objLead;

        

        Test.startTest();     
        LTS_DataUtility.getLeadAddress(objLead.Id);        
        System.assertEquals(LTS_DataUtility.getLeadAddress(objLead.Id).isEmpty(),false);
        Test.stopTest();

    }
    
    

}