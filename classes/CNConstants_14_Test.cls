/**
* {Purpose} – Test class for CNConstants_14
*
* @author	Glen Cunningham
* @version	2015-12-3
*/

/**
* CHANGE HISTORY
* ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
* Date			Name					Description
*
* ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
*/
@isTest
private class CNConstants_14_Test {

    static testMethod void myUnitTest() {
       //ContactNet 14R1 API RESOURCES
	    system.AssertEquals(CNConstants_14.URL_14R1_LOGIN , '/api/Authentication/Login');
	    system.AssertEquals(CNConstants_14.URL_14R1_AUTOCOMPLETE , '/api/AutoComplete');
	    system.AssertEquals(CNConstants_14.URL_14R1_SEARCHRESULTS , '/api/SearchResults');
	    system.AssertEquals(CNConstants_14.URL_14R1_SEARCHRESULTSDETAILS , '/api/SearchResultsDetail');
	    system.AssertEquals(CNConstants_14.URL_14R1_RELEASEINFO , '/api/releaseinfo');
	    
	    //ContactNet 14R1 API AutoComplete BitMasks
	    system.AssertEquals(CNConstants_14.AUTOCOMPLETE_14R1_BITMASK_CONTACTS , 1);
	    system.AssertEquals(CNConstants_14.AUTOCOMPLETE_14R1_BITMASK_CONTACT_TITLES , 2);
	    system.AssertEquals(CNConstants_14.AUTOCOMPLETE_14R1_BITMASK_COLLEAGUES , 4);
	    system.AssertEquals(CNConstants_14.AUTOCOMPLETE_14R1_BITMASK_INDUSTRIES , 8);
	    system.AssertEquals(CNConstants_14.AUTOCOMPLETE_14R1_BITMASK_COMPANIES , 16);
	    system.AssertEquals(CNConstants_14.AUTOCOMPLETE_14R1_BITMASK_LOCATIONS , 32);
	
	    //ContactNet 14R1 API SearchResult ViewTypes
	    system.AssertEquals(CNConstants_14.SEARCHRESULT_14R1_VIEWTYPE_CONTACTS , 1);
	    system.AssertEquals(CNConstants_14.SEARCHRESULT_14R1_VIEWTYPE_COLLEAGUES , 2);
	    system.AssertEquals(CNConstants_14.SEARCHRESULT_14R1_VIEWTYPE_COMPANIES , 10);    
	    
	    system.AssertEquals(CNConstants_14.HOURS_UNTIL_AUTH_COOKIE_IS_STALE , 8);  
    }
}