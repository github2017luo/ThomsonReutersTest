/**
 * Validates the functionality provided by the InformaticaCustomerMatch_WS class.
 *
 * @author   Nandita Shet
 * @version  2014-07-14
 */

/**
 * CHANGE HISTORY
 * =============================================================================
 * Date         Name               Description
 * 2014-07-14   Nandita Shet       Created
 * =============================================================================
 */

@isTest

private class InformaticaCustomerMatch_WS_Test{
 private static testMethod void testInvokeWebServiceCallout() {
    //Setup Test
    InformaticaCustomerMatch_WS.WS_Customer_Match_V2Port oService = new InformaticaCustomerMatch_WS.WS_Customer_Match_V2Port ();
    oService.inputHttpHeaders_x = new Map<String, String>();
    oService.timeout_x = 1000; //1 Second
    oService.endpoint_x = 'http://unittest@thomsonreuters.com';
    oService.outputHttpHeaders_x = new Map<String,String>();
    
    //Mock Request
    InformaticaCustomerMatch_WSObject.WS_CustomerMatchRequestElement_element requestElement = new InformaticaCustomerMatch_WSObject.WS_CustomerMatchRequestElement_element();
     requestElement.ID = '123';
        requestElement.NAME = 'Unit Test';
        requestElement.ADDRESS = '555 Some Street';
        requestElement.CITY = 'Dallas';
        requestElement.ZIPCODE = '55555';
        requestElement.COUNTRYCODE = 'US';
        requestElement.POBOX = '123456';
        
    //Mock Response
    InformaticaCustomerMatch_WSObject.WS_CustomerMatchResponseElement_element responseElement = new InformaticaCustomerMatch_WSObject.WS_CustomerMatchResponseElement_element();
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
        responseElement.POBOX = '';
        
    InformaticaCustomerMatch_WSObject.WS_CustomerMatchResponseType responseType = new InformaticaCustomerMatch_WSObject.WS_CustomerMatchResponseType();
    responseType.WS_CustomerMatchResponseElement = new InformaticaCustomerMatch_WSObject.WS_CustomerMatchResponseElement_element[] { responseElement };
    
        UnitTest.MockWebServiceResponse.put(DataQualityUtil.AccountMatchingServiceName, responseType);
        
    Test.startTest();
    
    //Callout - Customer Match
    InformaticaCustomerMatch_WSObject.WS_CustomerMatchRequestElement_element testRequest = requestElement;
    InformaticaCustomerMatch_WSObject.WS_CustomerMatchResponseElement_element[] oResponse = oService.WS_Customer_Match_V2Operation(testRequest);
    
    Test.stopTest();
  }



}