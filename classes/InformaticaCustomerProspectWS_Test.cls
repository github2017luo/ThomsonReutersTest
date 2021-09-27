/**
 * Validates the functionality provided by the InformaticaCustomerProspectWS class.
 *
 * @author	John De Santiago
 * @version	2012-05-15
 */

/**
 * CHANGE HISTORY
 * =============================================================================
 * Date			Name					Description
 * 2012-05-15   John De Santiago        Created
 * =============================================================================
 */
@IsTest
private class InformaticaCustomerProspectWS_Test {

	/**
	 * Tests the creation of all known class types associated with the 
	 * InformaticaCustomerProspectWS class. 
	 */
	public static testMethod void testWebServiceSchema() {
		
		Test.startTest();
		
		//Request Elements
		InformaticaCustomerProspectWS.WS_CUSTPROSP_UPSERTRequestElement_element requestElement = new InformaticaCustomerProspectWS.WS_CUSTPROSP_UPSERTRequestElement_element();
		requestElement.MDBID = '';
        requestElement.SAPID = '';
        requestElement.EXTERNAL_SYSTEM = '';
        requestElement.EXTERNAL_SYSTEM_ID = '';
        requestElement.SALES_ORG = '';
        requestElement.COMPANY_CODE = '';
        requestElement.DIVISION_CODE = '';
        requestElement.DISTRIBUTION_CHANNEL = '';
        requestElement.TITLE = '';
        requestElement.NAME_LINE1 = '';
        requestElement.NAME_LINE2 = '';
        requestElement.NAME_LINE3 = '';
        requestElement.ADDRESS_LINE1 = '';
        requestElement.ADDRESS_LINE2 = '';
        requestElement.ADDRESS_LINE3 = '';
        requestElement.POBOX = '';
        requestElement.CITY = '';
        requestElement.COUNTY = '';
        requestElement.STATE = '';
        requestElement.ZIP_CODE = '';
        requestElement.COUNTRY = '';
        requestElement.PHONE = '';
        requestElement.PHONE_EXT = '';
        requestElement.PHONE_COUNTRY_CODE = '';
        requestElement.FAX = '';
        requestElement.INDUSTRY = '';
        requestElement.CUSTOMER_GROUP = '';
        requestElement.CUSTOMER_TYPE = '';
        requestElement.ACCOUNT_GROUP_CODE = '';
        requestElement.FROZEN_MKT_SEGMENT = '';
        requestElement.MARKET_SEGMENT = '';
        
		InformaticaCustomerProspectWS.WS_CUSTPROSP_UPSERTRequestType requestType = new InformaticaCustomerProspectWS.WS_CUSTPROSP_UPSERTRequestType();
		requestType.WS_CUSTPROSP_UPSERTRequestElement = requestElement;
		
		//Response Elements
		InformaticaCustomerProspectWS.WS_CUSTPROSP_UPSERTResponseElement_element responseElement = new InformaticaCustomerProspectWS.WS_CUSTPROSP_UPSERTResponseElement_element();
		responseElement.MDBID = '';
		
		InformaticaCustomerProspectWS.WS_CUSTPROSP_UPSERTResponseType responseType = new InformaticaCustomerProspectWS.WS_CUSTPROSP_UPSERTResponseType();
		responseType.WS_CUSTPROSP_UPSERTResponseElement = responseElement;
		
		//Service Class
		InformaticaCustomerProspectWS.WS_CustProsp_UpsertPort oService = new InformaticaCustomerProspectWS.WS_CustProsp_UpsertPort();
	
		Test.stopTest();
	}
	
	/**
	 * Tests invoking the web service callouts for code coverage
	 * <p>
	 * Note: The original callout methods have been modified after being generated from a WSDL
	 * to ensure that the actual callout method is skipped during a unit test. This 
	 * allows the callout setup to be tested without actually submitting the request.
	 * 
	 * Should the InformaticaCustomerProspectWS class need to be regenerated the following changes need to be
	 * made to support this test method:
	 *
	 * 1. Set the variable response_x to an instance to prevent a null exception
	 * 2. Wrap the WebServiceCallout.invoke call in a Test.isRunningTest() statement to skip the callout during a unit test
	 */
	public static testMethod void testInvokeWebServiceCallout() {
		//Setup Test
		InformaticaCustomerProspectWS.WS_CustProsp_UpsertPort oService = new InformaticaCustomerProspectWS.WS_CustProsp_UpsertPort();
		oService.inputHttpHeaders_x = new Map<String, String>();
		oService.timeout_x = 1000; //1 Second
		oService.endpoint_x = 'http://unittest@thomsonreuters.com';
		oService.outputHttpHeaders_x = new Map<String,String>();
		
		//Mock Request
		InformaticaCustomerProspectWS.WS_CUSTPROSP_UPSERTRequestElement_element requestElement = new InformaticaCustomerProspectWS.WS_CUSTPROSP_UPSERTRequestElement_element();
		requestElement.MDBID = '1212';
        requestElement.SAPID = '1212';
        requestElement.EXTERNAL_SYSTEM = 'CORE SALESFORCE.COM';
        requestElement.EXTERNAL_SYSTEM_ID = '1241';
        requestElement.SALES_ORG = 'LEGAL';
        requestElement.COMPANY_CODE = '1';
        requestElement.DIVISION_CODE = '1';
        requestElement.DISTRIBUTION_CHANNEL = '10';
        requestElement.TITLE = 'COMPANY';
        requestElement.MARKET_SEGMENT = '21212';
        
		InformaticaCustomerProspectWS.WS_CUSTPROSP_UPSERTRequestType requestType = new InformaticaCustomerProspectWS.WS_CUSTPROSP_UPSERTRequestType();
		requestType.WS_CUSTPROSP_UPSERTRequestElement = requestElement;
		
		//Response Elements
		InformaticaCustomerProspectWS.WS_CUSTPROSP_UPSERTResponseElement_element responseElement = new InformaticaCustomerProspectWS.WS_CUSTPROSP_UPSERTResponseElement_element();
		responseElement.MDBID = '10089';
		
		InformaticaCustomerProspectWS.WS_CUSTPROSP_UPSERTResponseType responseType = new InformaticaCustomerProspectWS.WS_CUSTPROSP_UPSERTResponseType();
		responseType.WS_CUSTPROSP_UPSERTResponseElement = responseElement;
		
        UnitTest.MockWebServiceResponse.put(MDBIntegrationUtil.UpsertAccountServiceName, responseType);
        
		Test.startTest();
		
		//Callout - Customer Match
		InformaticaCustomerProspectWS.WS_CUSTPROSP_UPSERTResponseElement_element oResponse = oService.WS_CustProsp_UpsertOperation(requestElement);
		System.assertEquals('10089', oResponse.MDBID);
		
		Test.stopTest();
	}
}