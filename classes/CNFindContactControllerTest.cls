/**
* {Purpose} – Test class for CNFindContactController.
*
* @author	Shah Kadirmohideen
* @version	2012-01-29
*/

/** 
* CHANGE HISTORY
* =============================================================================
* Date			Name					Description
* 2012-01-29	Shah Kadirmohideen		Created  
* 2013-04-25	Mike Eaton				Updated test for valid search URL
* =============================================================================
*/
@isTest
private class CNFindContactControllerTest {
	/**
	* Validates search URL preparation
	*/
	@isTest (OnInstall=false)
    private static void test_getSearchURL() {
    	Test.startTest();
    	
    	CNFindContactController oController = new CNFindContactController();
    	
    	//Validate basic search
    	oController.useGlobal = false;
    	oController.includeAccount = true;
    	oController.includeContact = true;
    	oController.includeLead = true;
    	String sURL = oController.getSearchURL();
    	System.assert(sURL.contains('001'), 'Account search parameter not included');
    	System.assert(sURL.contains('003'), 'Contact search parameter not included');
    	System.assert(sURL.contains('00Q'), 'Lead search parameter not included');
    	System.assert(sURL.contains('/search/SearchResults?searchType=2'), 'Incorrect search URL for basic search');

		//Validate global search
    	oController.useGlobal = true;
    	oController.includeAccount = false;
    	oController.includeContact = true;
    	oController.includeLead = false;
    	sURL = oController.getSearchURL();
    	System.assert(!sURL.contains('001'), 'Account search parameter not included');
    	System.assert(sURL.contains('003'), 'Contact search parameter not included');
    	System.assert(!sURL.contains('00Q'), 'Lead search parameter not included');
    	System.assert(sURL.contains('/_ui/search/ui/UnifiedSearchResults?'), 'Incorrect search URL for global search');
    	//
    	oController.accountId = '00100dF4352T000';
    	Test.stopTest();
	
    }
}