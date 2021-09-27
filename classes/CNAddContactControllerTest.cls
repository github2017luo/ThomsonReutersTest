/**
* {Purpose} – Test class for CNAddContactController.
*
* @author	Shah Kadirmohideen
* @version	2012-07-12
*/

/** 
* CHANGE HISTORY
* =============================================================================
* Date			Name					Description
* 2012-07-12	Shah Kadirmohideen		Created  
* =============================================================================
*/
@isTest
private class CNAddContactControllerTest {
	
	/**
	* Validates add URL preparation
	*/
	@isTest (OnInstall=false)
    private static void test_getAddURL() {
    	Test.startTest();
    	
    	CNAddContactController oController = new CNAddContactController();
    	oController.firstName = 'TestFirstname';
    	oController.lastName = 'TestLastname';
    	oController.title = 'TestTitle';
    	oController.phone = '111-222-3333';
    	
    	String sURL = oController.getAddURL();
    	
		String sContObjectPrefix = Schema.SObjectType.Contact.getKeyPrefix();
		String sAddURL = '/' + sContObjectPrefix + '/e';
    	
    	System.assert(sURL.startsWith(sAddURL), 'Contact add URL not prepared correctly');
    	System.assert(sURL.contains('TestFirstname'), 'Firstname not added to the URL');
    	System.assert(sURL.contains('TestLastname'), 'Lastname not added to the URL');
    	System.assert(sURL.contains('TestTitle'), 'Title not added to the URL');
    	System.assert(sURL.contains('111-222-3333'), 'Phone not added to the URL');
    	
    	Test.stopTest();
    }
}