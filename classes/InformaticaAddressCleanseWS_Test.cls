/**
 * Validates the functionality provided by the InformaticaAddressCleanseWS class.
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
private class InformaticaAddressCleanseWS_Test {

	/**
	 * Tests the creation of all known class types associated with the 
	 * InformaticaAddressCleanseWS class. 
	 */
	public static testMethod void testWebServiceSchema() {
		
		Test.startTest();
		
		InformaticaAddressCleanseWS.WS_SFDC_Address_ValidationResponseElement_element oValidationResponseElement = new InformaticaAddressCleanseWS.WS_SFDC_Address_ValidationResponseElement_element();
		InformaticaAddressCleanseWS.WS_SFDC_Address_ValidationRequestType oValidationRequestType = new InformaticaAddressCleanseWS.WS_SFDC_Address_ValidationRequestType();
		InformaticaAddressCleanseWS.WS_SFDC_Address_ValidationRequestElement_element oValidationRequestElement = new InformaticaAddressCleanseWS.WS_SFDC_Address_ValidationRequestElement_element();
		InformaticaAddressCleanseWS.WS_SFDC_Address_ValidationResponseType oValidationResponseType = new InformaticaAddressCleanseWS.WS_SFDC_Address_ValidationResponseType();
		InformaticaAddressCleanseWS.WS_SFDC_Address_ValidationSuggestionElement_element oValidationSuggestionElement = new InformaticaAddressCleanseWS.WS_SFDC_Address_ValidationSuggestionElement_element();
		InformaticaAddressCleanseWS.WS_SFDC_Address_ValidationPort oService = new InformaticaAddressCleanseWS.WS_SFDC_Address_ValidationPort();
		
		Test.stopTest();
	}
	
	/**
	 * Tests invoking the web service callouts for code coverage
	 * <p>
	 * Note: The original callout methods have been modified after being generated from a WSDL
	 * to ensure that the actual callout method is skipped during a unit test. This 
	 * allows the callout setup to be tested without actually submitting the request.
	 * 
	 * Should the InformaticaAddressCleanseWS class need to be regenerated the following changes need to be
	 * made to support this test method:
	 *
	 * 1. Set the variable response_x to an instance to prevent a null exception
	 * 2. Wrap the WebServiceCallout.invoke call in a Test.isRunningTest() statement to skip the callout during a unit test
	 */
	public static testMethod void testInvokeWebServiceCallout() {
		//Setup Test
		InformaticaAddressCleanseWS.WS_SFDC_Address_ValidationPort oService = new InformaticaAddressCleanseWS.WS_SFDC_Address_ValidationPort();
		oService.inputHttpHeaders_x = new Map<String, String>();
		oService.timeout_x = 1000; //1 Second
		oService.endpoint_x = 'http://unittest@thomsonreuters.com';
		oService.outputHttpHeaders_x = new Map<String,String>();
		
		//Mock Request
		InformaticaAddressCleanseWS.WS_SFDC_Address_ValidationRequestElement_element requestElement = new InformaticaAddressCleanseWS.WS_SFDC_Address_ValidationRequestElement_element();
	 	requestElement.Name1 = '123';
        requestElement.Street = '555 Some Street';
        requestElement.City = 'Dallas';
        requestElement.State_County = 'TX';
        requestElement.PostalCode = '55555';
        requestElement.Country = 'US';
        
        //Mock Response
        InformaticaAddressCleanseWS.WS_SFDC_Address_ValidationResponseElement_element responseElement = new InformaticaAddressCleanseWS.WS_SFDC_Address_ValidationResponseElement_element();
		responseElement.Street = '555 SOME STREET';
        responseElement.Mailability_Score = '5';
        responseElement.Name1 = 'Unit Test';
        responseElement.City = 'Dallas';
        responseElement.PostalCode = '55555';
        responseElement.State_County = 'TX';
        responseElement.Country = 'UNITED STATES';
        responseElement.Match_Code = '0';
        
        InformaticaAddressCleanseWS.WS_SFDC_Address_ValidationResponseType responseType = new InformaticaAddressCleanseWS.WS_SFDC_Address_ValidationResponseType();
		responseType.WS_SFDC_Address_ValidationResponseElement = responseElement;
		
        UnitTest.MockWebServiceResponse.put(DataQualityUtil.CleanseAddressServiceName, responseType);
        
		Test.startTest();
		
		//Callout - Address Cleanse
		InformaticaAddressCleanseWS.WS_SFDC_Address_ValidationResponseElement_element oResponse = oService.WS_SFDC_Address_ValidationOperation(requestElement);
		
		Test.stopTest();
	}
}