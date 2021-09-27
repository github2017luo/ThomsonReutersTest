@isTest
public with sharing class ODTDG_AEMdataTest {
    
    @TestSetup
    static void makeData() {
        // Inserting a new country and state
        Country_Region__c  stateTest = new Country_Region__c(Name='US-AA', Country_Code__c='US',Region_Code__c='AA', Region_Name__c='Armed Forces US', IsActive__c =true);
        insert stateTest;
        
        Country__c  countryTest = new Country__c(Name='UNITED STATES', Country_Code__c='US', IsActive__c =true);
        insert countryTest;
    }
    @isTest
    static void testAemdata() {
        Test.startTest();
        ODTDG_AEMdata js = new ODTDG_AEMdata('US');
        String json = js.parse();
        List<ODTDG_AEMdata.Countries> c = js.allCountries;
        List<ODTDG_AEMdata.States> s = js.allStates;  
        System.debug(LoggingLevel.Info,'country ...'+c);
        System.debug(LoggingLevel.Info,'state ...'+s);
        System.assert(json != null,'null');
        Test.stopTest();
    }
    
}