/**
 * Validates the functionality provided by the InformaticaAddressCleanse_WS class.
 *
 * @author   Nandita Shet
 * @version  2014-07-16
 */

/**
 * CHANGE HISTORY
 * =============================================================================
 * Date          Name                Description
 * 2014-07-16    Nandita Shet        Created
 * =============================================================================
 */
@IsTest
private class InformaticaAddressCleanse_WS_Test {

 public static testMethod void testInvokeWebServiceCallout() {
    //Setup Test
    InformaticaAddressCleanse_WS.WS_SFDC_Address_Validation_V3Port oService = new InformaticaAddressCleanse_WS.WS_SFDC_Address_Validation_V3Port();
    oService.inputHttpHeaders_x = new Map<String, String>();
    oService.timeout_x = 1000; //1 Second
    oService.endpoint_x = 'http://unittest@thomsonreuters.com';
    oService.outputHttpHeaders_x = new Map<String,String>();
    
    //Mock Request
    InformaticaAddressCleanse_WSObject.WS_SFDC_Address_ValidationRequestElement_element requestElement = new InformaticaAddressCleanse_WSObject.WS_SFDC_Address_ValidationRequestElement_element();
        requestElement.Name1 = '123';
        requestElement.Street = '555 Some Street';
        requestElement.City = 'Dallas';
        requestElement.State_County = 'TX';
        requestElement.PostalCode = '55555';
        requestElement.Country = 'US';
        
        //Mock Response
    InformaticaAddressCleanse_WSObject.WS_SFDC_Address_ValidationResponseElement_element  responseElement = new  InformaticaAddressCleanse_WSObject.WS_SFDC_Address_ValidationResponseElement_element();
    responseElement.Street = '555 SOME STREET';
        responseElement.Mailability_Score = '5';
        responseElement.Name1 = 'Unit Test';
        responseElement.City = 'Dallas';
        responseElement.PostalCode = '55555';
        responseElement.State_County = 'TX';
        responseElement.Country = 'UNITED STATES';
        responseElement.Match_Code = '0';
        
     InformaticaAddressCleanse_WSObject.WS_SFDC_Address_ValidationResponseType responseType = new InformaticaAddressCleanse_WSObject.WS_SFDC_Address_ValidationResponseType();
      responseType.WS_SFDC_Address_ValidationResponseElement = responseElement;
    
        UnitTest.MockWebServiceResponse.put(DataQualityUtil.CleanseAddressServiceName, responseType);
        
    Test.startTest();
    
    //Callout - Address Cleanse
    InformaticaAddressCleanse_WSObject.WS_SFDC_Address_ValidationResponseElement_element  oResponse = oService.WS_SFDC_Address_Validation_V3Operation(requestElement);
    
    Test.stopTest();
  }


}