@isTest
public with sharing class ODTDG_Country_StatesTest {

    @TestSetup
    static void makeData() {
        // Inserting a new country anD state
        Country_Region__c  stateTest = new Country_Region__c(Name='US-AA', Country_Code__c='US',Region_Code__c='AA', Region_Name__c='Armed Forces US', IsActive__c =true);
        insert stateTest;

        Country__c  countryTest = new Country__c(Name='UNITED STATES', Country_Code__c='US', IsActive__c =true);
        insert countryTest;
    }

    // Testing the GET request
    @isTest
    static void testGetCountryAndStates() {
        
        Test.startTest();
        // Forming the request
        RestRequest contactRequest = new RestRequest();
        contactRequest.requestUri = '/services/apexrest/ODTDGCountryStates';
        contactRequest.addParameter('countryCode', 'US');
        contactRequest.httpMethod = 'GET';
        RestContext.request = contactRequest;

        // Testing the API
        ODTDG_Country_States.WrapperCountry wapCou = ODTDG_Country_States.getCountryRegions();        
        System.assert(wapCou != null,'is empty');
       
        Test.stopTest();
                
        
    }
}