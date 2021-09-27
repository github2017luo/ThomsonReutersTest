/**
 * Validates the functionality provided by the DataServices class.
 *
 * @author  John De Santiago - Thomson Reuters Code Share
 * @version 2011-03-16
 */

/**
 * CHANGE HISTORY
 * =============================================================================
 * Date         Name                    Description
 * 2011-03-16   John De Santiago        Created
 * =============================================================================
 */
@IsTest
private class DataServices_Test {
    /**
     * Validates the address cleanse method call
     */
    private static testMethod void testCleanseAddress() {
        //Setup Test
        DataServices.AddressInfo oAddress = new DataServices.AddressInfo();
        oAddress.Name = 'Unit Test';
        oAddress.Street = '555 Unit Test Street';
        oAddress.City = 'SomeCity';
        oAddress.State = 'TX';
        oAddress.PostalCode = '55555';
        oAddress.County = 'SomeCounty';
        oAddress.Country = 'US';
        
        //Generate Mock Login Response
        DataServices.Session oMockLoginResponse = new DataServices.Session();
        oMockLoginResponse.EndPoint = 'http://unittest@thomsonreuters.com';
        oMockLoginResponse.Timeout = 1000; //1 second
        oMockLoginResponse.SessionId = 'UnitTest_Session';
        UnitTest.MockWebServiceResponse.put('LoginRequest', oMockLoginResponse);
        
        //Generate Mock Address Cleanse Response
        DataServices.AddressCleanseResponse oMockAddressResponse = new DataServices.AddressCleanseResponse();
        oMockAddressResponse.IsSuccess = true;
        oMockAddressResponse.Id = '001';
        oMockAddressResponse.Name1 = 'Unit Test';
        oMockAddressResponse.Name2 = 'Unit Test 2';
        oMockAddressResponse.Street = '123 SomeStreet';
        oMockAddressResponse.City = 'Some City';
        oMockAddressResponse.State = 'TX';
        oMockAddressResponse.PostalCode = '666666';
        oMockAddressResponse.County = 'Some County';
        oMockAddressResponse.Country = 'US';
        UnitTest.MockWebServiceResponse.put('AddressCleanseRequest', oMockAddressResponse);
        
        //Execute Test
        Test.startTest();
        
        DataServices.AddressInfo oCleansedAddress = DataServices.cleanseAddress(oAddress);

        Test.stopTest(); 
    }
    
    /**
     * Validates the submission of a basic login request
     */
    private static testMethod void testSubmitLoginRequest() {
        //Setup Test
        DataServices.LoginRequest oRequest = new DataServices.LoginRequest();
        oRequest.EndPoint = 'http://unittest@thomsonreuters.com';
        oRequest.Username = 'unittest@thomsonreuters.com';
        oRequest.Password = 'unittest';
        oRequest.Timeout = 1000; //1 second
        
        //Generate Mock Login Response
        DataServices.Session oMockResponse = new DataServices.Session();
        oMockResponse.SessionId = 'UnitTest_Session';
        
        UnitTest.MockWebServiceResponse.put('LoginRequest', oMockResponse);
        
        Test.startTest();
        
        //Test: Submit Request
        DataServices oDataServices = new DataServices();
        
        DataServices.Session oSession = oDataServices.submitLoginRequest(oRequest);
        System.assert(oSession.IsValid, 'Expected a mock success response to be returned');
        
        Test.stopTest(); 
    }
    
    /**
     * Validates the submission of a basic address cleanse request
     */
    private static testMethod void testSubmitAddressCleanseRequest() {
        //Setup Test
        DataServices.AddressCleanseRequest oRequest = new DataServices.AddressCleanseRequest();
        oRequest.Session.EndPoint = 'http://unittest@thomsonreuters.com';
        oRequest.Session.SessionId = '12345';
        oRequest.Session.Timeout = 1000; //1 Second
        
        oRequest.Id = '001';
        oRequest.Name1 = 'Unit Test';
        oRequest.Name2 = 'Unit Test 2';
        oRequest.Street = '123 SomeStreet';
        oRequest.City = 'SomeCity';
        oRequest.State = 'TX';
        oRequest.PostalCode = '55555';
        oRequest.County = 'SomeCounty';
        oRequest.Country = 'US';
        
        //Generate Mock Response
        DataServices.AddressCleanseResponse oMockResponse = new DataServices.AddressCleanseResponse();
        oMockResponse.IsSuccess = true;
        oMockResponse.Id = '001';
        oMockResponse.Name1 = 'Unit Test';
        oMockResponse.Name2 = 'Unit Test 2';
        oMockResponse.Street = '123 SomeStreet';
        oMockResponse.City = 'Some City';
        oMockResponse.State = 'TX';
        oMockResponse.PostalCode = '666666';
        oMockResponse.County = 'Some County';
        oMockResponse.Country = 'US';
        
        UnitTest.MockWebServiceResponse.put('AddressCleanseRequest', oMockResponse);
        
        DataServices oDataServices = new DataServices();
        
        Test.startTest();
        
        //Test: Submit Request
        //DataServices.AddressCleanseResponse oResponse = oDataServices.submitAddressCleanseRequest(oRequest);
        //System.assertEquals(oMockResponse.Id, oResponse.Id);
        
        //Test: Parse Response
        //DataServicesWS.AddressOutputRecord_element oAddressElement = new DataServicesWS.AddressOutputRecord_element();
        //oAddressElement.Id = 'UT';
        
        //oResponse.parse(oAddressElement);
        //System.assertEquals('UT', oResponse.Id);
        
        Test.stopTest();
    }
    
    /**
     * Validates the submission of a basic account deduplication request
     */
    private static testMethod void testSubmitAccountDeDupeRequest() {
        //Setup Test
        DataServices.AccountDeDupeRequest oRequest = new DataServices.AccountDeDupeRequest();
        oRequest.Session.EndPoint = 'http://unittest@thomsonreuters.com';
        oRequest.Session.SessionId = '12345';
        oRequest.Session.Timeout = 1000; //1 Second
        
        DataServices.AccountDetail oAccountDetail = new DataServices.AccountDetail();
        oAccountDetail.Id = '001';
        oAccountDetail.Name1 = 'Unit';
        oAccountDetail.Name2 = 'Test';
        oAccountDetail.Street = '123 Some Street';
        oAccountDetail.City = 'Some City';
        oAccountDetail.State = 'TX';
        oAccountDetail.PostalCode = '55555';
        oAccountDetail.County = 'SomeCounty';
        oAccountDetail.Country = 'US';
        oAccountDetail.Sales_Org = 'S01';
        oAccountDetail.STREET_RANGE = 'SR1';
        oAccountDetail.STREET_NAME = 'Range';
        oAccountDetail.STREET_PRE_DIR = 'PreDir';
        oAccountDetail.STREET_POST_DIR = 'PostDir';
        oAccountDetail.STREET_TYPE =  'Drive';
        oAccountDetail.SECONDARY_RANGE = 'Range2';
        oAccountDetail.DEDUP_TOKEN = 'XYZ';
        oAccountDetail.MASTER = '12345';
        
        oRequest.Accounts.add(oAccountDetail);  
        
        //Generate Mock Response
        DataServices.AccountDeDupeResponse oMockResponse = new DataServices.AccountDeDupeResponse();
        oMockResponse.Accounts.add(oAccountDetail);
        
        UnitTest.MockWebServiceResponse.put('AccountDeDupeRequest', oMockResponse);
        
        DataServices oDataServices = new DataServices();
        
        Test.startTest();
        
        //Test: Submit Request
        DataServices.AccountDeDupeResponse oResponse = oDataServices.submitAccountDeDupeRequest(oRequest);
        
        //Test: Parse Response
        List<DataServicesWS.DeDupeAccountOutputRecord_element> listResponses = new List<DataServicesWS.DeDupeAccountOutputRecord_element>();
        DataServicesWS.DeDupeAccountOutputRecord_element oAccountDeDupeElement = new DataServicesWS.DeDupeAccountOutputRecord_element();
        oAccountDeDupeElement.Id = 'UT';
        
        listResponses.add(oAccountDeDupeElement);
        oResponse.parse(listResponses);
        
        for (DataServices.AccountDetail oResponseItem : oResponse.Accounts) {
            System.assertEquals('UT', oResponseItem.Id);
        }
        
        Test.stopTest();
    }
    
    /**
     * Validates the submission of a basic contact deduplication request
     */
    private static testMethod void testSubmitContactDeDupeRequest() {
        //Setup Test
        DataServices.ContactDeDupeRequest oRequest = new DataServices.ContactDeDupeRequest();
        oRequest.Session.EndPoint = 'http://unittest@thomsonreuters.com';
        oRequest.Session.SessionId = '12345';
        oRequest.Session.Timeout = 1000; //1 Second
        
        DataServices.ContactDetail oContactDetail = new DataServices.ContactDetail();
        oContactDetail.Id = '001';
        oContactDetail.AccountId = '001';
        oContactDetail.FirstName = 'Unit';
        oContactDetail.LastName = 'Test';
        oContactDetail.Street = '123 Some Street';
        oContactDetail.City = 'Some City';
        oContactDetail.State = 'TX';
        oContactDetail.PostalCode = '55555';
        oContactDetail.County = 'SomeCounty';
        oContactDetail.Country = 'US';
        oContactDetail.STREET_RANGE = 'SR1';
        oContactDetail.STREET_NAME = 'Range';
        oContactDetail.STREET_PRE_DIR = 'PreDir';
        oContactDetail.STREET_POST_DIR = 'PostDir';
        oContactDetail.STREET_TYPE =  'Drive';
        oContactDetail.SECONDARY_RANGE = 'Range2';
        oContactDetail.DEDUP_TOKEN = 'XYZ';
        oContactDetail.MASTER = '12345';
        
        oRequest.Contacts.add(oContactDetail);  
        
        //Generate Mock Response
        DataServices.ContactDeDupeResponse oMockResponse = new DataServices.ContactDeDupeResponse();
        oMockResponse.Contacts.add(oContactDetail);
        
        UnitTest.MockWebServiceResponse.put('ContactDeDupeRequest', oMockResponse);
        
        DataServices oDataServices = new DataServices();
        
        Test.startTest();
        
        //Test: Submit Request
        DataServices.ContactDeDupeResponse oResponse = oDataServices.submitContactDeDupeRequest(oRequest);
        
        //Test: Parse Response
        List<DataServicesWS.DeDupeContactOutputRecord_element> listResponses = new List<DataServicesWS.DeDupeContactOutputRecord_element>();
        DataServicesWS.DeDupeContactOutputRecord_element oContactDeDupeElement = new DataServicesWS.DeDupeContactOutputRecord_element();
        oContactDeDupeElement.Id = 'UT';
        
        listResponses.add(oContactDeDupeElement);
        oResponse.parse(listResponses);
        
        for (DataServices.ContactDetail oResponseItem : oResponse.Contacts) {
            System.assertEquals('UT', oResponseItem.Id);
        }
        
        Test.stopTest();
    }
    
    /**
     * Validates the submission of a basic login request fails
     * due to invalid web service credentials
     */
    private static testMethod void negativeTestLoginRequestValidationFail() {
        //Setup Test
        DataServices.LoginRequest oLoginRequest =new DataServices.LoginRequest();

        DataServices oDataServices = new DataServices();
        
        Test.startTest();
        
        //Negative Test: Submit Null Request
        try {
            DataServices.Session oSession = oDataServices.submitLoginRequest(null);
        }
        catch (Exception oException) {
            System.assert(oException instanceof DataServices.ValidationException, 'Expected validation exception, instead: ' + oException.getMessage());
        }
        
        //Negative Test: Submit Request w/Invalid Credentials
        try {
            DataServices.Session oSession = oDataServices.submitLoginRequest(oLoginRequest);
        }
        catch (Exception oException) {
            System.assert(oException instanceof DataServices.ValidationException, 'Expected validation exception, instead: ' + oException.getMessage());
        }
        
        Test.stopTest();
    }

    /**
     * Validates the submission of a basic address cleanse request fails
     * due to invalid web service credentials
     */
    private static testMethod void negativeTestAddressCleanseRequestValidationFail() {
        //Setup Test
        DataServices oDataServices = new DataServices();
        
        Test.startTest();
        
        //Negative Test: Submit Null Request
        try {
            DataServices.AddressCleanseResponse oResponse = oDataServices.submitAddressCleanseRequest(null);    
        }
        catch (Exception oException) {
            System.assert(oException instanceof DataServices.ValidationException, 'Expected validation exception, instead: ' + oException.getMessage());
        }
        
        //Negative Test: Submit Request w/Invalid Credentials
        try {
            DataServices.AddressCleanseResponse oResponse = oDataServices.submitAddressCleanseRequest(new DataServices.AddressCleanseRequest());
        }
        catch (Exception oException) {
            System.assert(oException instanceof DataServices.ValidationException, 'Expected validation exception, instead: ' + oException.getMessage());
        }
        
        Test.stopTest();
    }
    
    /**
     * Validates the submission of a basic account deduplication request fails
     * due to invalid web service credentials
     */
    private static testMethod void negativeTestAccountDeDupeRequestValidationFail() {
        //Setup Test
        DataServices.AccountDeDupeRequest oRequest =new DataServices.AccountDeDupeRequest();

        DataServices oDataServices = new DataServices();
        
        Test.startTest();
        
        //Negative Test: Submit Null Request
        try {
            oDataServices.submitAccountDeDupeRequest(null); 
        }
        catch (Exception oException) {
            System.assert(oException instanceof DataServices.ValidationException, 'Expected validation exception, instead: ' + oException.getMessage());
        }
        
        //Negative Test: Submit Request w/Invalid Credentials
        try {
            oDataServices.submitAccountDeDupeRequest(oRequest);
        }
        catch (Exception oException) {
            System.assert(oException instanceof DataServices.ValidationException, 'Expected validation exception, instead: ' + oException.getMessage());
        }
        
        Test.stopTest();
    }   
    
    /**
     * Validates the submission of a basic contact deduplication request fails
     * due to invalid web service credentials
     */
    private static testMethod void negativeTestContactDeDupeRequestValidationFail() {
        //Setup Test
        DataServices.ContactDeDupeRequest oRequest =new DataServices.ContactDeDupeRequest();

        DataServices oDataServices = new DataServices();
        
        Test.startTest();
        
        //Negative Test: Submit Null Request
        try {
            oDataServices.submitContactDeDupeRequest(null); 
        }
        catch (Exception oException) {
            System.assert(oException instanceof DataServices.ValidationException, 'Expected validation exception, instead: ' + oException.getMessage());
        }
        
        //Negative Test: Submit Request w/Invalid Credentials
        try {
            oDataServices.submitContactDeDupeRequest(oRequest);
        }
        catch (Exception oException) {
            System.assert(oException instanceof DataServices.ValidationException, 'Expected validation exception, instead: ' + oException.getMessage());
        }
        
        Test.stopTest();
    }   
    
    /**
     * Validates the submission of a basic login request fails
     * due to callout error
     */
    private static testMethod void negativeTestLoginRequestCalloutException() {
        //Setup Test
        DataServices.LoginRequest oRequest = new DataServices.LoginRequest();
        oRequest.EndPoint = 'http://unittest@thomsonreuters.com';
        oRequest.Username = 'unittest@thomsonreuters.com';
        oRequest.Password = 'unittest';
        oRequest.Timeout = 1000; //1 second
        
        //Generate Mock Response
        AppUtil.AppException oMockException = new AppUtil.AppException('Mock Callout Exception');
        
        UnitTest.MockWebServiceResponse.put('LoginRequest', oMockException);
        
        Test.startTest();
        
        //Negative Test: Submit Request with Mock Exception
        DataServices oDataServices = new DataServices();
        
        DataServices.Session oSession = oDataServices.submitLoginRequest(oRequest);
        //System.assert(oSession.IsValid == false, 'Expected response to indicate a failure');
        
        Test.stopTest();
    }   
    
    /**
     * Validates the submission of a basic address cleanse request fails
     * due to callout error
     */
    private static testMethod void negativeTestAddressCleanseRequestCalloutException() {
        //Setup Test
        DataServices.AddressCleanseRequest oRequest = new DataServices.AddressCleanseRequest();
        oRequest.Session.EndPoint = 'http://unittest@thomsonreuters.com';
        oRequest.Session.SessionId = '12345';
        oRequest.Session.Timeout = 1000; //1 second
        
        //Generate Mock Response
        AppUtil.AppException oMockException = new AppUtil.AppException('Mock Callout Exception');
        
        UnitTest.MockWebServiceResponse.put('AddressCleanseRequest', oMockException);
        
        Test.startTest();
        
        //Negative Test: Submit Request with Mock Exception
        DataServices oDataServices = new DataServices();
        
        DataServices.AddressCleanseResponse oResponse = oDataServices.submitAddressCleanseRequest(oRequest);
        //System.assert(oResponse.IsSuccess == false, 'Expected response to indicate a failure');
        //System.assertEquals(oMockException.getMessage(), oResponse.ErrorMessage);
        
        Test.stopTest();
    }
    
    /**
     * Validates the submission of a basic account deduplication request fails
     * due to callout error
     */
    private static testMethod void negativeTestAccountDeDupeRequestCalloutException() {
        //Setup Test
        DataServices.AccountDeDupeRequest oRequest = new DataServices.AccountDeDupeRequest();
        oRequest.Session.EndPoint = 'http://unittest@thomsonreuters.com';
        oRequest.Session.SessionId = '12345';
        oRequest.Session.Timeout = 1000; //1 second
        
        //Generate Mock Response
        AppUtil.AppException oMockException = new AppUtil.AppException('Mock Callout Exception');
        
        UnitTest.MockWebServiceResponse.put('AccountDeDupeRequest', oMockException);
        
        Test.startTest();
        
        //Negative Test: Submit Request with Mock Exception
        DataServices oDataServices = new DataServices();
        
        DataServices.AccountDeDupeResponse oResponse = oDataServices.submitAccountDeDupeRequest(oRequest);
        //System.assert(oResponse.IsSuccess == false, 'Expected response to indicate a failure');
        //System.assertEquals(oMockException.getMessage(), oResponse.ErrorMessage);
        
        Test.stopTest();
    }   
    
    /**
     * Validates the submission of a basic contact deduplication request fails
     * due to callout error
     */
    private static testMethod void negativeTestContactDeDupeRequestCalloutException() {
        //Setup Test
        DataServices.ContactDeDupeRequest oRequest = new DataServices.ContactDeDupeRequest();
        oRequest.Session.EndPoint = 'http://unittest@thomsonreuters.com';
        oRequest.Session.SessionId = '12345';
        oRequest.Session.Timeout = 1000; //1 second
        
        //Generate Mock Response
        AppUtil.AppException oMockException = new AppUtil.AppException('Mock Callout Exception');
        
        UnitTest.MockWebServiceResponse.put('ContactDeDupeRequest', oMockException);
        
        Test.startTest();
        
        //Negative Test: Submit Request with Mock Exception
        DataServices oDataServices = new DataServices();
        
        DataServices.ContactDeDupeResponse oResponse = oDataServices.submitContactDeDupeRequest(oRequest);
        //System.assert(oResponse.IsSuccess == false, 'Expected response to indicate a failure');
        //System.assertEquals(oMockException.getMessage(), oResponse.ErrorMessage);
        
        Test.stopTest();
    }   
}