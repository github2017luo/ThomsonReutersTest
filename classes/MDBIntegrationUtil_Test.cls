/*
======================================================================================================================
TEST CLASS NAME: MDBIntegrationUtil_Test
======================================================================================================================
PURPOSE:    Validates the functionality provided by the MDBIntegrationUtil class.

CHANGE HISTORY:
======================================================================================================================
  DATE                  NAME                           DESC

2011-02-02          John De Santiago             Created
2017-03-31            Karthi                     Optimized the coverage as per JIRA STORY: PS0-1
======================================================================================================================
*/

@IsTest
public class MDBIntegrationUtil_Test {
	/**
	 * Validates a valid submission token value is returned
	 */
	private static testMethod void testGenerateMDBSubmissionToken() {
		//Setup Test
		Account oAccount = UnitTest.getAccountInstance();
		insert oAccount;
		
		//Run Test
		Test.startTest();
		
		string sSubmissionToken = MDBIntegrationUtil.generateMDBSubmissionToken(oAccount.Id);
		
		Test.stopTest();
		
		//Validate Test
		System.assert(sSubmissionToken != null, 'Expected a non-null value to be returned');
		System.assert(sSubmissionToken.indexOf(oAccount.Id) != -1, 'Expected record id to be incorporated into submission token');
	}
	
	/**
	 * Validates that an account can be successfully submitted to the MDB upsert account service
	 */
	private static testMethod void testUpsertAccountSuccess() {
		//Setup Test
		WebServiceSettings__c oWebServiceSettings = setupUpsertAccountServiceSettings();
		setupMockUpsertAccountSuccessResponse();
		
		MDBIntegrationUtil.UpsertAccountRequest oRequest = new MDBIntegrationUtil.UpsertAccountRequest();
		oRequest.EndPoint = oWebServiceSettings.Endpoint__c;
		oRequest.Timeout = (oWebServiceSettings.Timeout__c * 1000); //Convert seconds to milliseconds
		oRequest.MDBId = '1234';
		oRequest.SAPId = '1234';
		oRequest.AccountId = null;
		oRequest.SalesOrg = 'WEST';
		oRequest.Name1 = 'Unit Test';
		oRequest.AddressLine1 = '55 Some Street';
		oRequest.City = 'Dallas';
		oRequest.State = 'TX';
		oRequest.PostalCode = '55555';
		oRequest.Country = 'US';
		oRequest.Phone = '555-555-5555';
		
		//Run Test
		Test.startTest();
		
		MDBIntegrationUtil.UpsertAccountResponse oResponse =  MDBIntegrationUtil.upsertAccount(oRequest);
		
		Test.stopTest();
		
		//Validate Test
		System.assertEquals(true, oResponse.IsSuccess, 'Expected a successful response from the upsert account service');
	}
	
	/**
	 * Validates that an failed sumbission to the MDB upsert account service is handled approriately
	 */
	private static testMethod void testUpsertAccountFailure() {
		//Setup Test
		WebServiceSettings__c oWebServiceSettings = setupUpsertAccountServiceSettings();
		setupMockUpsertAccountFailureResponse();
		
		MDBIntegrationUtil.UpsertAccountRequest oRequest = new MDBIntegrationUtil.UpsertAccountRequest();
		oRequest.EndPoint = oWebServiceSettings.Endpoint__c;
		oRequest.Timeout = (oWebServiceSettings.Timeout__c * 1000); //Convert seconds to milliseconds
		oRequest.MDBId = '1234';
		oRequest.SAPId = '1234';
		oRequest.AccountId = null;
		oRequest.SalesOrg = 'WEST';
		oRequest.Name1 = 'Unit Test';
		oRequest.AddressLine1 = '55 Some Street';
		oRequest.City = 'Dallas';
		oRequest.State = 'TX';
		oRequest.PostalCode = '55555';
		oRequest.Country = 'US';
		oRequest.Phone = '555-555-5555';
		
		//Run Test
		Test.startTest();
		
		MDBIntegrationUtil.UpsertAccountResponse oResponse =  MDBIntegrationUtil.upsertAccount(oRequest);
		
		Test.stopTest();
		
		//Validate Test
		System.assertEquals(false, oResponse.IsSuccess, 'Expected a failure response from the upsert account service');
	}
	
	/**
	 * Validates the results of a failed account upsert scenario due to 
	 * an invalid request being supplied
	 */
	private static testMethod void testUpsertAccountBadRequest() {
		//Setup Test
		WebServiceSettings__c oWebServiceSettings = setupUpsertAccountServiceSettings();
        
        MDBIntegrationUtil.UpsertAccountRequest oRequest = new MDBIntegrationUtil.UpsertAccountRequest();
	    MDBIntegrationUtil.UpsertAccountRequest oNullRequest = null;
        
		//Run Test
		Test.startTest();
		
		MDBIntegrationUtil.UpsertAccountResponse oNullResponse = MDBIntegrationUtil.upsertAccount(oNullRequest);	
		MDBIntegrationUtil.UpsertAccountResponse oFailResponse = MDBIntegrationUtil.upsertAccount(oRequest);	
		
		Test.stopTest();
		
		//Validate Response
		System.assertEquals(false, oNullResponse.IsSuccess, 'Expected response to report an invalid request');
		System.assertEquals(false, oFailResponse.IsSuccess, 'Expected response to report an invalid request');
	}
	
	/**
	 * Validates that an contact can be successfully submitted to the MDB upsert contact service
	 */
	private static testMethod void testUpsertContactSuccess() {
		//Setup Test
		WebServiceSettings__c oWebServiceSettings = setupUpsertContactServiceSettings();
		setupMockUpsertContactSuccessResponse();
		
		MDBIntegrationUtil.UpsertContactRequest oRequest = new MDBIntegrationUtil.UpsertContactRequest();
		oRequest.EndPoint = oWebServiceSettings.Endpoint__c;
		oRequest.Timeout = (oWebServiceSettings.Timeout__c * 1000); //Convert seconds to milliseconds
		oRequest.FirstName = 'Unit';
		oRequest.LastName = 'Tester';
		oRequest.MDBAccountId = '54321';
		oRequest.MDBContactId = '12345';
		
		//Run Test
		Test.startTest();
		
		MDBIntegrationUtil.UpsertContactResponse oResponse =  MDBIntegrationUtil.upsertContact(oRequest);
		
		Test.stopTest();
		
		//Validate Test
		System.assertEquals(true, oResponse.IsSuccess, 'Expected a failure response from the upsert account service');
	}
	
	/**
	 * Validates that an failed sumbission to the MDB upsert contact service is handled approriately
	 */
	private static testMethod void testUpsertContactFailure() {
		//Setup Test
		WebServiceSettings__c oWebServiceSettings = setupUpsertContactServiceSettings();
		setupMockUpsertContactFailureResponse();
		
		MDBIntegrationUtil.UpsertContactRequest oRequest = new MDBIntegrationUtil.UpsertContactRequest();
		oRequest.EndPoint = oWebServiceSettings.Endpoint__c;
		oRequest.Timeout = (oWebServiceSettings.Timeout__c * 1000); //Convert seconds to milliseconds
		oRequest.FirstName = 'Unit';
		oRequest.LastName = 'Tester';
		oRequest.MDBAccountId = '54321';
		oRequest.MDBContactId = '12345';
		
		//Run Test
		Test.startTest();
		
		MDBIntegrationUtil.UpsertContactResponse oResponse =  MDBIntegrationUtil.upsertContact(oRequest);
		
		Test.stopTest();
		
		//Validate Test
		System.assertEquals(false, oResponse.IsSuccess, 'Expected a failure response from the upsert account service');
	}

	/**
	 * Validates the results of a failed contact upsert scenario due to 
	 * an invalid request being supplied
	 */
	private static testMethod void testUpsertContactBadRequest() {
		//Setup Test
		WebServiceSettings__c oWebServiceSettings = setupUpsertContactServiceSettings();
        
        MDBIntegrationUtil.UpsertContactRequest oRequest = new MDBIntegrationUtil.UpsertContactRequest();
	    MDBIntegrationUtil.UpsertContactRequest oNullRequest = null;
        
		//Run Test
		Test.startTest();
		
		MDBIntegrationUtil.UpsertContactResponse oNullResponse = MDBIntegrationUtil.upsertContact(oNullRequest);	
		MDBIntegrationUtil.UpsertContactResponse oFailResponse = MDBIntegrationUtil.upsertContact(oRequest);	
		
		Test.stopTest();
		
		//Validate Response
		System.assertEquals(false, oNullResponse.IsSuccess, 'Expected response to report an invalid request');
		System.assertEquals(false, oFailResponse.IsSuccess, 'Expected response to report an invalid request');
	}
	
	//Public Setup Helper Methods
	
	/**
	 * Generates mock web service settings for the MDB upsert account web service
	 */
	public static WebServiceSettings__c setupUpsertAccountServiceSettings() {
		WebServiceSettings__c oWebServiceSettings = WebServiceSettings__c.getInstance(MDBIntegrationUtil.UpsertAccountServiceName);
		
		if (oWebServiceSettings == null) {
			oWebServiceSettings = new WebServiceSettings__c();
			oWebServiceSettings.Name = MDBIntegrationUtil.UpsertAccountServiceName;
			oWebServiceSettings.Endpoint__c = 'https:\\upsertaccount.thomsonreuters.com';
			oWebServiceSettings.Timeout__c = 5;
			oWebServiceSettings.Active__c = true;
			oWebServiceSettings.Service_Unavailable_Message__c = 'Service is currently unavailable';
			insert oWebServiceSettings;
		}
		
		return oWebServiceSettings;
	}
	
	/**
	 * Generates mock web service settings for the MDB upsert contact web service
	 */
	public static WebServiceSettings__c setupUpsertContactServiceSettings() {
		WebServiceSettings__c oWebServiceSettings = WebServiceSettings__c.getInstance(MDBIntegrationUtil.UpsertContactServiceName);
		
		if (oWebServiceSettings == null) {
			oWebServiceSettings = new WebServiceSettings__c();
			oWebServiceSettings.Name = MDBIntegrationUtil.UpsertContactServiceName;
			oWebServiceSettings.Endpoint__c = 'https:\\upsertcontact.thomsonreuters.com';
			oWebServiceSettings.Timeout__c = 5;
			oWebServiceSettings.Active__c = true;
			oWebServiceSettings.Service_Unavailable_Message__c = 'Service is currently unavailable';
			insert oWebServiceSettings;
		}
		
		return oWebServiceSettings;
	}
	
	/** 
	 * Generates mock data for testing the MDB account upsert services in the context of a successful scenario
	 */
	public static InformaticaCustomerProspectWS.WS_CUSTPROSP_UPSERTResponseType setupMockUpsertAccountSuccessResponse() {
		InformaticaCustomerProspectWS.WS_CUSTPROSP_UPSERTResponseElement_element oResponseElement = new InformaticaCustomerProspectWS.WS_CUSTPROSP_UPSERTResponseElement_element();
		oResponseElement.MDBID = '10089';
		
		InformaticaCustomerProspectWS.WS_CUSTPROSP_UPSERTResponseType oResponseType = new InformaticaCustomerProspectWS.WS_CUSTPROSP_UPSERTResponseType();
		oResponseType.WS_CUSTPROSP_UPSERTResponseElement = oResponseElement;
		
        UnitTest.MockWebServiceResponse.put(MDBIntegrationUtil.UpsertAccountServiceName, oResponseType);
        return oResponseType;
	}
	
	/** 
	 * Generates mock data for testing the MDB account upsert services in the context of a failure scenario
	 */
	public static InformaticaCustomerProspectWS.WS_CUSTPROSP_UPSERTResponseType setupMockUpsertAccountFailureResponse() {
		InformaticaCustomerProspectWS.WS_CUSTPROSP_UPSERTResponseElement_element oResponseElement = new InformaticaCustomerProspectWS.WS_CUSTPROSP_UPSERTResponseElement_element();
		oResponseElement.MDBID = null;
	
		InformaticaCustomerProspectWS.WS_CUSTPROSP_UPSERTResponseType oResponseType = new InformaticaCustomerProspectWS.WS_CUSTPROSP_UPSERTResponseType();
		oResponseType.WS_CUSTPROSP_UPSERTResponseElement = oResponseElement;
		
        UnitTest.MockWebServiceResponse.put(MDBIntegrationUtil.UpsertAccountServiceName, oResponseType);
        return oResponseType;
	}
	
	/** 
	 * Generates mock data for testing the MDB contact upsert services in the context of a successful scenario
	 */
	public static InformaticaContactProspectWS.WS_MDB_Contact_UpsertResponseType setupMockUpsertContactSuccessResponse() {
		InformaticaContactProspectWS.WS_MDB_Contact_UpsertResponseElement_element oResponseElement = new InformaticaContactProspectWS.WS_MDB_Contact_UpsertResponseElement_element();
		oResponseElement.MDB_CUSTID = '10009';
		oResponseElement.MDB_CONTACTID = '10090';
		
		InformaticaContactProspectWS.WS_MDB_Contact_UpsertResponseType oResponseType = new InformaticaContactProspectWS.WS_MDB_Contact_UpsertResponseType();
		oResponseType.WS_MDB_Contact_UpsertResponseElement = oResponseElement;
		
        UnitTest.MockWebServiceResponse.put(MDBIntegrationUtil.UpsertContactServiceName, oResponseType);
        return oResponseType;
	}
	
	/** 
	 * Generates mock data for testing the MDB contact upsert services in the context of a failure scenario
	 */
	public static InformaticaContactProspectWS.WS_MDB_Contact_UpsertResponseType setupMockUpsertContactFailureResponse() {
		InformaticaContactProspectWS.WS_MDB_Contact_UpsertResponseElement_element oResponseElement = new InformaticaContactProspectWS.WS_MDB_Contact_UpsertResponseElement_element();
		oResponseElement.MDB_CUSTID = null;
		oResponseElement.MDB_CONTACTID = null;
		
		InformaticaContactProspectWS.WS_MDB_Contact_UpsertResponseType oResponseType = new InformaticaContactProspectWS.WS_MDB_Contact_UpsertResponseType();
		oResponseType.WS_MDB_Contact_UpsertResponseElement = oResponseElement;
		
        UnitTest.MockWebServiceResponse.put(MDBIntegrationUtil.UpsertContactServiceName, oResponseType);
        return oResponseType;
	}
}