/**
 * Validates the functionality provided by the InformaticaCustomerMatchWS class.
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
private class InformaticaCustomerMatchWS_Test {

	/**
	 * Tests the creation of all known class types associated with the 
	 * InformaticaCustomerMatchWS class. 
	 */
	private static testMethod void testWebServiceSchema() {
		
		Test.startTest();
		
		//Request Elements
		InformaticaCustomerMatchWS.WS_CustomerMatchRequestElement_element requestElement = new InformaticaCustomerMatchWS.WS_CustomerMatchRequestElement_element();
	 	requestElement.ID = '';
        requestElement.NAME = '';
        requestElement.ADDRESS = '';
        requestElement.CITY = '';
        requestElement.ZIPCODE = '';
        requestElement.COUNTRYCODE = '';
        
		InformaticaCustomerMatchWS.WS_CustomerMatchRequestType requestType = new InformaticaCustomerMatchWS.WS_CustomerMatchRequestType();
		requestType.WS_CustomerMatchRequestElement = new InformaticaCustomerMatchWS.WS_CustomerMatchRequestElement_element[] { requestElement };
		
		//Response Elements
		InformaticaCustomerMatchWS.WS_CustomerMatchResponseElement_element responseElement = new InformaticaCustomerMatchWS.WS_CustomerMatchResponseElement_element();
		responseElement.SOURCE_ID = '';
        responseElement.SOURCE_NAME = '';
        responseElement.SOURCE_ADDRESS = '';
        responseElement.SOURCE_CITY = '';
        responseElement.SOURCE_ZIPCODE = '';
        responseElement.SOURCE_COUNTRYCODE = '';
        responseElement.MATCH_MDBID = '';
        responseElement.MATCH_SAPID = '';
        responseElement.MATCH_NAME = '';
        responseElement.MATCH_ADDRESS = '';
        responseElement.MATCH_CITY = '';
        responseElement.MATCH_ZIPCODE = '';
        responseElement.MATCH_COUNTRYCODE = '';
        responseElement.MATCH_SCORE = '';
        
		InformaticaCustomerMatchWS.WS_CustomerMatchResponseType responseType = new InformaticaCustomerMatchWS.WS_CustomerMatchResponseType();
		responseType.WS_CustomerMatchResponseElement = new InformaticaCustomerMatchWS.WS_CustomerMatchResponseElement_element[] { responseElement };
		
		//Service Class
		InformaticaCustomerMatchWS.WS_Customer_MatchPort oService = new InformaticaCustomerMatchWS.WS_Customer_MatchPort();
	
		Test.stopTest();
	}
	
	/**
	 * Tests invoking the web service callouts for code coverage
	 * <p>
	 * Note: The original callout methods have been modified after being generated from a WSDL
	 * to ensure that the actual callout method is skipped during a unit test. This 
	 * allows the callout setup to be tested without actually submitting the request.
	 * 
	 * Should the InformaticaCustomerMatchWS class need to be regenerated the following changes need to be
	 * made to support this test method:
	 *
	 * 1. Set the variable response_x to an instance to prevent a null exception
	 * 2. Wrap the WebServiceCallout.invoke call in a Test.isRunningTest() statement to skip the callout during a unit test
	 */
	private static testMethod void testInvokeWebServiceCallout() {
		//Setup Test
		InformaticaCustomerMatchWS.WS_Customer_MatchPort oService = new InformaticaCustomerMatchWS.WS_Customer_MatchPort();
		oService.inputHttpHeaders_x = new Map<String, String>();
		oService.timeout_x = 1000; //1 Second
		oService.endpoint_x = 'http://unittest@thomsonreuters.com';
		oService.outputHttpHeaders_x = new Map<String,String>();
		
		//Mock Request
		InformaticaCustomerMatchWS.WS_CustomerMatchRequestElement_element requestElement = new InformaticaCustomerMatchWS.WS_CustomerMatchRequestElement_element();
	 	requestElement.ID = '123';
        requestElement.NAME = 'Unit Test';
        requestElement.ADDRESS = '555 Some Street';
        requestElement.CITY = 'Dallas';
        requestElement.ZIPCODE = '55555';
        requestElement.COUNTRYCODE = 'US';
        
		//Mock Response
		InformaticaCustomerMatchWS.WS_CustomerMatchResponseElement_element responseElement = new InformaticaCustomerMatchWS.WS_CustomerMatchResponseElement_element();
		responseElement.SOURCE_ID = '123';
        responseElement.SOURCE_NAME = 'UNIT TEST';
        responseElement.SOURCE_ADDRESS = '555 Some Street';
        responseElement.SOURCE_CITY = 'Dallas';
        responseElement.SOURCE_ZIPCODE = '55555';
        responseElement.SOURCE_COUNTRYCODE = 'US';
        responseElement.MATCH_MDBID = '12';
        responseElement.MATCH_SAPID = '14';
        responseElement.MATCH_NAME = '';
        responseElement.MATCH_ADDRESS = '';
        responseElement.MATCH_CITY = '';
        responseElement.MATCH_ZIPCODE = '';
        responseElement.MATCH_COUNTRYCODE = '';
        responseElement.MATCH_SCORE = '';
        
		InformaticaCustomerMatchWS.WS_CustomerMatchResponseType responseType = new InformaticaCustomerMatchWS.WS_CustomerMatchResponseType();
		responseType.WS_CustomerMatchResponseElement = new InformaticaCustomerMatchWS.WS_CustomerMatchResponseElement_element[] { responseElement };
		
        UnitTest.MockWebServiceResponse.put(DataQualityUtil.AccountMatchingServiceName, responseType);
        
		Test.startTest();
		
		//Callout - Customer Match
		List<InformaticaCustomerMatchWS.WS_CustomerMatchRequestElement_element> testRequest = new List<InformaticaCustomerMatchWS.WS_CustomerMatchRequestElement_element> { requestElement };
		InformaticaCustomerMatchWS.WS_CustomerMatchResponseElement_element[] oResponse = oService.WS_Customer_MatchOperation(testRequest);
		
		Test.stopTest();
	}
}