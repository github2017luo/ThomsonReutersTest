/**
 * Validates the functionality provided by the DataServicesWS class.
 *
 * @author	John De Santiago - Thomson Reuters Code Share
 * @version	2011-03-09
 */

/**
 * CHANGE HISTORY
 * =============================================================================
 * Date			Name					Description
 * 2011-03-09   John De Santiago        Created
 * =============================================================================
 */
@IsTest
private class DataServicesWS_Test {

	/**
	 * Tests the creation of all known class types associated with the 
	 * DataServicesWS class. 
	 */
	private static testMethod void testWebServiceSchema() {
		//Contact DeDupe
		DataServicesWS.DeDupeContactInput_element oDeDupeContactInput = new DataServicesWS.DeDupeContactInput_element();
		DataServicesWS.DeDupeContactOutput_element oDeDupeContactOutput = new DataServicesWS.DeDupeContactOutput_element();
		DataServicesWS.DeDupeContactInputRecord_element oDeDupeContactInputRecord = new DataServicesWS.DeDupeContactInputRecord_element();
		DataServicesWS.DeDupeContactOutputRecord_element oDeDupeContactOutputRecord = new DataServicesWS.DeDupeContactOutputRecord_element();
		
		//Account DeDupe
		DataServicesWS.DeDupeAccountInput_element oDeDupeAccountInput = new DataServicesWS.DeDupeAccountInput_element();
		DataServicesWS.DeDupeAccountOutput_element oDeDupeAccountOutput = new DataServicesWS.DeDupeAccountOutput_element();
		DataServicesWS.DeDupeAccountInputRecord_element oDeDupeAccountInputRecord = new DataServicesWS.DeDupeAccountInputRecord_element();
		DataServicesWS.DeDupeAccountOutputRecord_element oDeDupeAccountOutputRecord = new DataServicesWS.DeDupeAccountOutputRecord_element();
		
		//Address
		DataServicesWS.AddressInput_element oAddressInput = new DataServicesWS.AddressInput_element();
		DataServicesWS.AddressInputRecord_element oAddressInputRecord = new DataServicesWS.AddressInputRecord_element();
		DataServicesWS.AddressOutput_element oAddressOutput = new DataServicesWS.AddressOutput_element();
		DataServicesWS.AddressOutputRecord_element oAddressOutputRecord = new DataServicesWS.AddressOutputRecord_element();
	}
	
	/**
	 * Tests invoking the web service callouts for code coverage
	 * <p>
	 * Note: The original callout methods have been modified after being generated from a WSDL
	 * to ensure that the actual callout method is skipped during a unit test. This 
	 * allows the callout setup to be tested without actually submitting the request.
	 * 
	 * Should the DataServicesWS class need to be regenerated the following changes need to be
	 * made to support this test method:
	 *
	 * 1. Set the variable response_x to an instance to prevent a null exception
	 * 2. Wrap the WebServiceCallout.invoke call in a Test.isRunningTest() statement to skip the callout during a unit test
	 */
	private static testMethod void testInvokeWebServiceCallout() {
		//Setup Test
		DataServicesWS.Service oService = new DataServicesWS.Service();
		oService.inputHttpHeaders_x = new Map<String, String>();
		oService.timeout_x = 1000; //1 Second
		oService.endpoint_x = 'http://unittest@thomsonreuters.com';
		oService.outputHttpHeaders_x = new Map<String,String>();
		
		DataServicesWS.AddressInputRecord_element oAddressInputRecord = new DataServicesWS.AddressInputRecord_element();
		
		List<DataServicesWS.DeDupeAccountInputRecord_element> listAccountDeDupeInputRecords = new List<DataServicesWS.DeDupeAccountInputRecord_element>();
		listAccountDeDupeInputRecords.add(new DataServicesWS.DeDupeAccountInputRecord_element());
		
		List<DataServicesWS.DeDupeContactInputRecord_element> listContactDeDupeInputRecords = new List<DataServicesWS.DeDupeContactInputRecord_element>();
		listContactDeDupeInputRecords.add(new DataServicesWS.DeDupeContactInputRecord_element());
		
		Test.startTest();
		
		//Callout - Login
		string sSessionId = oService.Logon('Unit Tester', 'password');
		
		//Callout - Logout
		string sStatus = oService.Logout();
		
		//Callout - Ping
		string sVersion = oService.Ping();
		
		//Callout - Address Cleanse
		DataServicesWS.AddressOutputRecord_element oAdressOutputRecord = oService.Address_sf(oAddressInputRecord);
		
		//Callout - Account DeDupe
		List<DataServicesWS.DeDupeAccountOutputRecord_element> listAccountDeDupeOutputRecords = oService.DeDupe_Account_sf(listAccountDeDupeInputRecords);
		
		//Callout - Contact DeDupe
		List<DataServicesWS.DeDupeContactOutputRecord_element> listContactDeDupeOutputRecords = oService.DeDupe_Contact_sf(listContactDeDupeInputRecords);
		
		Test.stopTest();
	}
}