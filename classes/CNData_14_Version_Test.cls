/**
* {Purpose} � This class provides a test for json parser for the api call releaseinfo
* 
* @author   Glen Cunningham
* @version  2015.12.01
* 
* CHANGE HISTORY
* =============================================================================
* Date          Name                    Description 
*2015-12-01		Glen Cunningham 		created
* =============================================================================
*/
@isTest
private class CNData_14_Version_Test {
	
	static testMethod void testParse() {
		String json = '{\"LastUpdateTime\":\"10:22 AM\",\"LastUpdateDate\":\"2015/11/24\",\"CopyrightYear\":\"2015\",\"Version\":\"15.2.0.7857\"}';
		CNData_14_Version obj = CNData_14_Version.parse(json);
		System.assert(obj != null);
		json = '';
		obj = CNData_14_Version.parse(json);
		System.assert(obj == null);
	}
}