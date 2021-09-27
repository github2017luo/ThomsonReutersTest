/**
 * Validates the functionality provided by the InformaticaContactProspectWS class.
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
private class InformaticaContactProspectWS_Test {

	/**
	 * Tests the creation of all known class types associated with the 
	 * InformaticaContactProspectWS class. 
	 */
	private static testMethod void testWebServiceSchema() {
		
		Test.startTest();
		
		//Request Elements
		InformaticaContactProspectWS.WS_MDB_Contact_UpsertRequestElement_element requestElement = new InformaticaContactProspectWS.WS_MDB_Contact_UpsertRequestElement_element();
		requestElement.MDB_CUSTID = '';
        requestElement.MDB_CONTACTID = '';
        requestElement.SAP_CONTACTID = '';
        requestElement.EXTERNAL_SYSTEM = '';
        requestElement.EXTERNAL_ID = '';
        requestElement.NAME_TITLE = '';
        requestElement.NAME_LAST = '';
        requestElement.NAME_FIRST = '';
        requestElement.GENDER = '';
        requestElement.MARITAL_STATUS = '';
        requestElement.CONTACT_DEPARTMENT = '';
        requestElement.JOB_FUNCTION = '';
        requestElement.ONLINE_FLAG = '';
        requestElement.SOURCE_ID = '';
        requestElement.NON_SAP_EMAIL = '';
        requestElement.CONTACT_FUNCTION_CODE = '';
        requestElement.PERM_MKT_SOURCE_ID = '';
        requestElement.PHONE = '';
        requestElement.FAX = '';
        requestElement.NO_TELEMARKETING_IND = '';
        requestElement.NO_SALESCARD_IND = '';
        requestElement.NO_ADVERTISING_IND = '';
        requestElement.WLEC_DO_NOT_CALL = '';
        requestElement.CONTACT_ROLES = '';
        requestElement.CASE_LOADS = '';
        requestElement.CONTACT_ASSOCATIONS = '';
        requestElement.CONTACT_EXTERNAL_SYSTEMS = '';
        requestElement.CONTACT_DELETE_FLAG = '';
        requestElement.INACTIVE_REASON_CODE = '';
        requestElement.LAST_UPDATE_USER = '';
        requestElement.LAST_UPDATE_SYSTEM = '';
        requestElement.BUYING_HABITS = '';
        requestElement.CALL_FREQUENCY = '';
        requestElement.CONTACT_AD_MATERIAL = '';
        requestElement.CONTACT_HIGH_LVL_PERSON = '';
        requestElement.CONTACT_NOTES = '';
        requestElement.VIP_IND = '';
        
		InformaticaContactProspectWS.WS_MDB_Contact_UpsertRequestType requestType = new InformaticaContactProspectWS.WS_MDB_Contact_UpsertRequestType();
		requestType.WS_MDB_Contact_UpsertRequestElement = requestElement;
		
		//Response Elements
		InformaticaContactProspectWS.WS_MDB_Contact_UpsertResponseElement_element responseElement = new InformaticaContactProspectWS.WS_MDB_Contact_UpsertResponseElement_element();
		responseElement.MDB_CUSTID = '';
		responseElement.MDB_CONTACTID = '';
		
		InformaticaContactProspectWS.WS_MDB_Contact_UpsertResponseType responseType = new InformaticaContactProspectWS.WS_MDB_Contact_UpsertResponseType();
		responseType.WS_MDB_Contact_UpsertResponseElement = responseElement;
		
		//Service Class
		InformaticaContactProspectWS.WS_MDB_Contact_UpsertPort oService = new InformaticaContactProspectWS.WS_MDB_Contact_UpsertPort();
	
		Test.stopTest();
	}
	
	/**
	 * Tests invoking the web service callouts for code coverage
	 * <p>
	 * Note: The original callout methods have been modified after being generated from a WSDL
	 * to ensure that the actual callout method is skipped during a unit test. This 
	 * allows the callout setup to be tested without actually submitting the request.
	 * 
	 * Should the InformaticaContactProspectWS class need to be regenerated the following changes need to be
	 * made to support this test method:
	 *
	 * 1. Set the variable response_x to an instance to prevent a null exception
	 * 2. Wrap the WebServiceCallout.invoke call in a Test.isRunningTest() statement to skip the callout during a unit test
	 */
	private static testMethod void testInvokeWebServiceCallout() {
		//Setup Test
		InformaticaContactProspectWS.WS_MDB_Contact_UpsertPort oService = new InformaticaContactProspectWS.WS_MDB_Contact_UpsertPort();
		oService.inputHttpHeaders_x = new Map<String, String>();
		oService.timeout_x = 1000; //1 Second
		oService.endpoint_x = 'http://unittest@thomsonreuters.com';
		oService.outputHttpHeaders_x = new Map<String,String>();
		
		//Mock Request
		InformaticaContactProspectWS.WS_MDB_Contact_UpsertRequestElement_element requestElement = new InformaticaContactProspectWS.WS_MDB_Contact_UpsertRequestElement_element();
		requestElement.MDB_CUSTID = '12343';
        requestElement.MDB_CONTACTID = '314134';
        requestElement.SAP_CONTACTID = '12341324';
        requestElement.EXTERNAL_SYSTEM = 'SFDC CORE LEGAL';
        requestElement.EXTERNAL_ID = 'adsfadsf';
        requestElement.NAME_TITLE = 'Unit Tester';
        requestElement.NAME_LAST = 'Doe';
        requestElement.NAME_FIRST = 'John';
        requestElement.GENDER = 'M';
        
		InformaticaContactProspectWS.WS_MDB_Contact_UpsertRequestType requestType = new InformaticaContactProspectWS.WS_MDB_Contact_UpsertRequestType();
		requestType.WS_MDB_Contact_UpsertRequestElement = requestElement;
		
		//Response Elements
		InformaticaContactProspectWS.WS_MDB_Contact_UpsertResponseElement_element responseElement = new InformaticaContactProspectWS.WS_MDB_Contact_UpsertResponseElement_element();
		responseElement.MDB_CUSTID = '10009';
		responseElement.MDB_CONTACTID = '10090';
		
		InformaticaContactProspectWS.WS_MDB_Contact_UpsertResponseType responseType = new InformaticaContactProspectWS.WS_MDB_Contact_UpsertResponseType();
		responseType.WS_MDB_Contact_UpsertResponseElement = responseElement;
		
        UnitTest.MockWebServiceResponse.put(MDBIntegrationUtil.UpsertContactServiceName, responseType);
        
		Test.startTest();
		
		//Callout - Customer Match
		InformaticaContactProspectWS.WS_MDB_Contact_UpsertResponseElement_element oResponse = oService.WS_MDB_Contact_UpsertOperation(requestElement);
		System.assertEquals('10009', oResponse.MDB_CUSTID);
		System.assertEquals('10090', oResponse.MDB_CONTACTID);
		
		Test.stopTest();
	}
}