/**
* {Purpose} – Test the CNData_14_AutoComplete class 
*
* @author	Glen Cunningham
* @version	11-6-2015
*/

/**
* CHANGE HISTORY
* =============================================================================
* Date			Name					Description
*  
* =============================================================================
*/
@isTest
private class CNData_14_AutoComplete_Test {

    static testMethod void myUnitTest() {
    //Response when bitmask = 1;	
 	string json1 ='{"Collection": [{ "Type": 1, "Collection": [ { "Title": null, "OrganizationName": "O\'melveny & Myers Llp", "NumColleagues": 1, "Id": "2970232", "DisplayValue": "rsagner@omm.com" }], "TotalResults": 1}]}';
 	//Response when bitmask = 16
	string json2 = '{"Collection": [{ "Type": 16, "Collection": [ { "NumColleagues": 31, "NumContacts": 48, "NumRelationships": 56, "HasFamilyTree": false, "Id": "5000428393", "DisplayValue": "Simpson Thacher & Bartlett Mnp Llp" }], "TotalResults": 1}]}'; 
    CNData_14_AutoComplete cn1 = CNData_14_AutoComplete.parse(json1);
    CNData_14_AutoComplete cn2 = CNData_14_AutoComplete.parse(json2);
    CNData_14_AutoComplete.Collection  cnc = CNData_14_AutoComplete.getSingleItem(0, cn1);
    CNData_14_AutoComplete.Collection  cnc1 = CNData_14_AutoComplete.getSingleItemSortedByRelationshipCountDesending(cn2);
    CNData.CNCompany co = CNData_14_AutoComplete.MapTo(cnc);
    CNData.CNContact cc =  CNData_14_AutoComplete.MapToBaseContact(cnc1);
    }
}