/**
 * Validates the functionality provided by the AccountAddressController class.
 *
 * @author  John De Santiago
 * @version 2012-05-15
 */
 
 /**
 * CHANGE HISTORY
 * =============================================================================
 * Date         Name                    Description
 * 2012-05-15   John De Santiago        Created                                                                   
 * =============================================================================
 */
 
@IsTest
private class AccountAddressController_Test {
    /**
     * Validates controller handling for a null standard controller
     */
    public static testMethod void testNullStandardController() {
        //Setup Test
        PageReference oPageAccountAddress = Page.AccountAddress;
        Test.setCurrentPage(oPageAccountAddress);
        
        Test.startTest();
        
        AccountAddressController oController = new AccountAddressController(null);
        System.assert(ApexPages.hasMessages() == true, 'Expected error message when a null standard controller is used');
 
        Test.stopTest();
    }
    
    /**
     * Validates that the standard detail view is initialized
     * for a customer record type
     */
    private static testMethod void testCustomerDetailView() {
        
        //Setup Test
        TestInfo oTestInfo = setupTest();
        
        oTestInfo.Account.RecordTypeId = AccountUtil.CustomerRecordTypeId;
        insert oTestInfo.Account;
        
        PageReference oPageAccountAddress = Page.AccountAddress;
        Test.setCurrentPage(oPageAccountAddress);
        
        ApexPages.StandardController oStandardController = new ApexPages.StandardController(oTestInfo.Account);
        
        //Execute Test
        Test.startTest();
        
        AccountAddressController oController = new AccountAddressController(oStandardController);
        
        Test.stopTest();
        
        //Validate Test
        System.assertEquals(true, oController.AllowEdit);
        System.assertEquals(false, oController.EditAddress);
        System.assertEquals(false, oController.ServiceError);
        System.assertEquals(false, oController.SkipAddressCleanse);
        
        System.assert(oController.CountryOptions.isEmpty() == false, 'Expected at least one country option to be available');
        System.assert(oController.CountryRegionOptions.isEmpty() == false, 'Expected at least one country region option to be available');
    }
    
    /**
     * Validates that the standard detail view is initialized
     * for a prospect record type
     */
    private static testMethod void testProspectDetailView() {
        
        //Setup Test
        TestInfo oTestInfo = setupTest();
        
        oTestInfo.Account.RecordTypeId = AccountUtil.ProspectRecordTypeId;
        insert oTestInfo.Account;
        
        PageReference oPageAccountAddress = Page.AccountAddress;
        Test.setCurrentPage(oPageAccountAddress);
        
        ApexPages.StandardController oStandardController = new ApexPages.StandardController(oTestInfo.Account);
        
        //Execute Test
        Test.startTest();
        
        AccountAddressController oController = new AccountAddressController(oStandardController);
        
        Test.stopTest();
        
        //Validate Test
        System.assertEquals(true, oController.AllowEdit);
        System.assertEquals(false, oController.EditAddress);
        System.assertEquals(false, oController.ServiceError);
        System.assertEquals(false, oController.SkipAddressCleanse);
        
        System.assert(oController.CountryOptions.isEmpty() == false, 'Expected at least one country option to be available');
        System.assert(oController.CountryRegionOptions.isEmpty() == false, 'Expected at least one country region option to be available');
    }
    
    /**
     * Validates that an address can be modified, cleansed, and saved
     */
    private static testMethod void testAddressEdit() {
        //Setup Test
        
        TestInfo oTestInfo = setupTest();
        
        oTestInfo.Account.RecordTypeId = AccountUtil.ProspectRecordTypeId;
        oTestInfo.Account.BillingState = '';
        oTestInfo.Account.BillingCountry = '';
        insert oTestInfo.Account;
        
        PageReference oPageAccountAddress = Page.AccountAddress;
        Test.setCurrentPage(oPageAccountAddress);
        
        ApexPages.StandardController oStandardController = new ApexPages.StandardController(oTestInfo.Account);
        
        //Execute Test
        Test.startTest();
        
        AccountAddressController oController = new AccountAddressController(oStandardController);
        oController.edit();
        
        oTestInfo.Account.BillingCountry = 'US';
        oController.addressCountryChanged();
        
        PageReference oSavePageReference = oController.save();
        
        PageReference oContinueSavePageReference = oController.continueSave();
        
        PageReference oCancelPageReference = oController.cancel();
        
        Test.stopTest();
    }
    
    /**
     * Validates that an error is reported when the address cleanse
     * service reports an error
     */
    private static testMethod void testAddressEditFailedAddressCleanse() {
        
        //Setup Test
        
        TestInfo oTestInfo = setupTest();
        
        oTestInfo.Account.RecordTypeId = AccountUtil.ProspectRecordTypeId;
        insert oTestInfo.Account;
        
        PageReference oPageAccountAddress = Page.AccountAddress;
        Test.setCurrentPage(oPageAccountAddress);
        
        ApexPages.StandardController oStandardController = new ApexPages.StandardController(oTestInfo.Account);
        
        //Mock Failed Cleanse Response
        DataQualityUtil_Test.setupMockAddressCleanseServiceFailedResponse();
        
        //Execute Test
        Test.startTest();
        
        AccountAddressController oController = new AccountAddressController(oStandardController);
        oController.edit();
        
        oTestInfo.Account.BillingCountry = 'US';
        oController.addressCountryChanged();
        
        PageReference oSavePageReference = oController.save();
        System.assert(ApexPages.hasMessages() == true, 'Expected error message when a failed address cleanse response is reported');
 
        Test.stopTest();
    }
    
    //Unit Test Helper Methods
    
    /**
     * Unit test helper method that creates any required data for testing
     * and returns information about the data instantiated for the test
     *
     * @return  an instance of a TestInfo class
     */
    public static TestInfo setupTest() {
        //Required Web Service Settings
        WebServiceSettings__c oCustomerProspectSettings = new WebServiceSettings__c();
        oCustomerProspectSettings.Name = MDBIntegrationUtil.UpsertAccountServiceName;
        oCustomerProspectSettings.Endpoint__c = 'https:\\thomsonreuters.com';
        oCustomerProspectSettings.Timeout__c = 5;
        oCustomerProspectSettings.Active__c = true;
        oCustomerProspectSettings.Service_Unavailable_Message__c = 'Service is currently unavailable';
        insert oCustomerProspectSettings;
        
        WebServiceSettings__c oAddressCleanseSettings = new WebServiceSettings__c();
        oAddressCleanseSettings.Name = DataQualityUtil.CleanseAddressServiceName;
        oAddressCleanseSettings.Endpoint__c = 'https:\\thomsonreuters.com';
        oAddressCleanseSettings.Timeout__c = 5;
        oAddressCleanseSettings.Active__c = true;
        oAddressCleanseSettings.Service_Unavailable_Message__c = 'Service is currently unavailable';
        insert oAddressCleanseSettings;
        
        //Mock Response
        InformaticaCustomerProspectWS.WS_CUSTPROSP_UPSERTResponseElement_element oCustomerProspectResponse = new InformaticaCustomerProspectWS.WS_CUSTPROSP_UPSERTResponseElement_element();
        oCustomerProspectResponse.MDBID = 'UT001';
        
        InformaticaCustomerProspectWS.WS_CUSTPROSP_UPSERTResponseType oCustomerProspectResponseType = new InformaticaCustomerProspectWS.WS_CUSTPROSP_UPSERTResponseType();
        oCustomerProspectResponseType.WS_CUSTPROSP_UPSERTResponseElement = oCustomerProspectResponse;
        
        UnitTest.MockWebServiceResponse.put(MDBIntegrationUtil.UpsertAccountServiceName, oCustomerProspectResponseType);
        
        //Mock Response
        DataQualityUtil_Test.setupMockAddressCleanseServiceSuccessResponse();
        
        Country__c oCountry = new Country__c();
        oCountry.Name = 'United States';
        oCountry.Country_Code__c = 'US';
        insert oCountry;
        
        Country_Region__c oCountryRegion = new Country_Region__c();
        oCountryRegion.Country_Code__c = 'US';
        oCountryRegion.Name = 'US-TX';
        oCountryRegion.Region_Name__c = 'Texas';
        oCountryRegion.Region_Code__c = 'TX';
        insert oCountryRegion;
        
        TestInfo oTestInfo = new TestInfo();
        oTestInfo.Account = UnitTest.getAccountInstance();
        oTestInfo.Account.Name = 'Unit Test';
        oTestInfo.Account.RecordTypeId = AccountUtil.ProspectRecordTypeId;
        oTestInfo.Account.BillingStreet = '555 Test Street';
        oTestInfo.Account.BillingCity = 'Dallas';
        oTestInfo.Account.BillingState = 'TX';
        oTestInfo.Account.BillingPostalCode = '55555';
        oTestInfo.Account.BillingCountry = 'US';
        
        return oTestInfo;
    }
    
    //Internal Classes
    public class TestInfo {
        public Account Account {get;set;}
    }
}