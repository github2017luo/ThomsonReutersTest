/**
 * Validates the functionality provided by the InformaticaCustomerMatch_WSObject class.
 *
 * @author  Nandita Shet
 * @version  2014-07-14
 */

/**
 * CHANGE HISTORY
 * =============================================================================
 * Date         Name                Description
 * 2014-07-14   Nandita Shet        Created
 * =============================================================================
 */
@IsTest
private class InformaticaCustomerMatch_WSObject_Test {
 
  private static testMethod void testWebServiceSchema() {
    
    Test.startTest();
    
    //Request Elements
    InformaticaCustomerMatch_WSObject.WS_CustomerMatchRequestElement_element requestElement = new InformaticaCustomerMatch_WSObject.WS_CustomerMatchRequestElement_element();
     requestElement.ID = '';
        requestElement.NAME = '';
        requestElement.ADDRESS = '';
        requestElement.CITY = '';
        requestElement.ZIPCODE = '';
        requestElement.COUNTRYCODE = '';
        requestElement.POBOX = '';
        
    InformaticaCustomerMatch_WSObject.WS_CustomerMatchRequestType requestType = new InformaticaCustomerMatch_WSObject.WS_CustomerMatchRequestType();
    requestType.WS_CustomerMatchRequestElement = requestElement;
    
    //Response Elements
    InformaticaCustomerMatch_WSObject.WS_CustomerMatchResponseElement_element responseElement = new  InformaticaCustomerMatch_WSObject.WS_CustomerMatchResponseElement_element();
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
        responseElement.POBOX = '';
        
    InformaticaCustomerMatch_WSObject.WS_CustomerMatchResponseType responseType = new InformaticaCustomerMatch_WSObject.WS_CustomerMatchResponseType();
    responseType.WS_CustomerMatchResponseElement = new InformaticaCustomerMatch_WSObject.WS_CustomerMatchResponseElement_element[] { responseElement };
    
    
  
    Test.stopTest();
  }
  
  


}