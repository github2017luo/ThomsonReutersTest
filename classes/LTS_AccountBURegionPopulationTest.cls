/********************************************************************** 
Name: LTS_AccountBURegionPopulationTest  
====================================================== 
Req: Exclusion Framework - LOTUS Program
====================================================== 
Purpose: This test class os used for covering functionality of BU segment population 
i.e  LCRMGenericComponent.populatebuRegionSegmentLotus method.
====================================================== 
History 
------- 
VERSION    AUTHOR             DATE             DETAIL 
1.0        TCS Developer     11/3/2019     Initial Development  
***********************************************************************/
@isTest
public class LTS_AccountBURegionPopulationTest {
    
    /* @testSetup static void insertGLIAccount(){


Account acc = new Account();
acc.Is_GLI__c = true;
acc.BillingCountry = 'US';
acc.Name = 'TESTREGIONACCOUNT';
acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('GLI_Account').getRecordTypeId();
insert acc;
}*/
    @isTest static void populateRegionSegment(){
        //SELECT LTS_Country_Code__c, LTS_Country_Name__c, LTS_Region__c, Id FROM Lotus_countrycode_region_mappings__mdt
        
        Map<string,string> testMap = new Map<string,string>();
        List<Lotus_countrycode_region_mappings__mdt> countryCodeRegionMappingTestList = [SELECT LTS_Country_Code__c, LTS_Country_Name__c, LTS_Region__c, Id FROM Lotus_countrycode_region_mappings__mdt];
        for(Lotus_countrycode_region_mappings__mdt countryInstance : countryCodeRegionMappingTestList){
            System.debug('COUNTRY REGION'+countryInstance.LTS_Country_Code__c+':::'+countryInstance.LTS_Region__c);
            
        }
        Test.startTest();
        List<Profile> lstProfile =[SELECT Id FROM Profile WHERE Name =:'TR Sales'];
        User user1 = UnitTest.getUserInstance();
        user1.Username = 'Test@xyzAccountregion.com';
        user1.LastName = 'XYZ';
        user1.Email = 'abc@xyz.com';
        user1.Alias = 'abcd';  
        user1.Segment__c = 'Corporate';
        user1.ProfileId = lstProfile[0].Id;
        insert user1;
        
        system.runAs(user1){
            //Account acc = [Select id,Name,Bu_Region__c from account Where Name = 'TESTREGIONACCOUNT'];
            List<Account> accList = new List<Account>();
            Account acc = new Account();
            acc.Is_GLI__c = true;
            acc.BillingCountry = 'IN';
            acc.BillingState = 'GJ';
            acc.Name = 'TESTREGIONACCOUNT';
            acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('GLI_Account').getRecordTypeId();
            insert acc;
            accList.add(acc);
            
            //populatebuRegionSegmentLotus
            LCRMGenericComponent.populatebuRegionSegmentLotus(accList);
            //System.assertEquals(acc.Bu_Region__c == 'US', String.isNotBlank(acc.Bu_Region__c));
        }
        Test.stopTest();
        
    }
    //Negative scenario
    @isTest static void populateRegionSegmentBlank(){
        //SELECT LTS_Country_Code__c, LTS_Country_Name__c, LTS_Region__c, Id FROM Lotus_countrycode_region_mappings__mdt
        
        Map<string,string> testMap = new Map<string,string>();
        List<Lotus_countrycode_region_mappings__mdt> countryCodeRegionMappingTestList = [SELECT LTS_Country_Code__c, LTS_Country_Name__c, LTS_Region__c, Id FROM Lotus_countrycode_region_mappings__mdt];
        for(Lotus_countrycode_region_mappings__mdt countryInstance : countryCodeRegionMappingTestList){
            System.debug('COUNTRY REGION'+countryInstance.LTS_Country_Code__c+':::'+countryInstance.LTS_Region__c);
            
        }
        Test.startTest();
        List<Profile> lstProfile =[SELECT Id FROM Profile WHERE Name =:'TR Sales'];
        User user1 = UnitTest.getUserInstance();
        user1.Username = 'Test@xyzAccountregion.com';
        user1.LastName = 'XYZ';
        user1.Email = 'abc@xyz.com';
        user1.Alias = 'abcd';  
        user1.Segment__c = '';
        user1.ProfileId = lstProfile[0].Id;
        insert user1;
        
        system.runAs(user1){
            //Account acc = [Select id,Name,Bu_Region__c from account Where Name = 'TESTREGIONACCOUNT'];
            List<Account> accList = new List<Account>();
            Account acc = new Account();
            acc.Is_GLI__c = true;
            acc.BillingCountry = 'IN';
            acc.Name = 'TESTREGIONACCOUNT';
            acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('GLI_Account').getRecordTypeId();
            insert acc;
            accList.add(acc);
            
            //populatebuRegionSegmentLotus
            LCRMGenericComponent.populatebuRegionSegmentLotus(accList);
            //System.assertEquals(true, String.isBlank(acc.Bu_Region__c));
        }
        Test.stopTest();
        
    }
    
    //Address
    @isTest static void testAddressEdit() {
        
        List<Profile> lstProfile =[SELECT Id FROM Profile WHERE Name =:'TR Sales'];
        User user1 = UnitTest.getUserInstance();
        user1.Username = 'Test@xyzAccountregion.com';
        user1.LastName = 'XYZ';
        user1.Email = 'abc@xyz.com';
        user1.Alias = 'abcd';       
        user1.ProfileId = lstProfile[0].Id;
        insert user1;
        
        system.runAs(user1){
            //Account acc = [Select id,Name,Bu_Region__c from account Where Name = 'TESTREGIONACCOUNT'];
            List<Account> accList = new List<Account>();
            Account acc = new Account();
            acc.Is_GLI__c = true;
            //acc.BillingCountry = 'US';
            acc.Name = 'TESTREGIONACCOUNT';
            acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('GLI_Account').getRecordTypeId();
            acc.BillingStreet = '555 Test Street';
            acc.BillingCity = 'Dallas';
            acc.BillingState = 'GJ';
            acc.BillingPostalCode = '55555';
            acc.BillingCountry = 'IN';
            insert acc;
            
            PageReference oPageAccountAddress = Page.AccountAddress;
            Test.setCurrentPage(oPageAccountAddress);
            
            
            ApexPages.StandardController oStandardController = new ApexPages.StandardController(acc);
            
            //Execute Test
            Test.startTest();        
            
            AccountAddressController oController = new AccountAddressController(oStandardController);
            oController.edit();
            acc.BillingCountry = 'US';
            
            oController.addressCountryChanged();
            
            PageReference oSavePageReference = oController.save();
            
            PageReference oContinueSavePageReference = oController.continueSave();
            
            PageReference oCancelPageReference = oController.cancel();
            
            Test.stopTest();
        }
    }
    
    
}