/**
* {Purpose} Test Class for CNData_14_Login
*
* @author   Glen Cunningham
* @version  2015.11.5
*/ 

/**
* CHANGE HISTORY
* =============================================================================
* Date          Name                    Description
*  
* =============================================================================
*/
@isTest
private class CNData_14_Login_Test {

    static testMethod void myUnitTest() {
        string json = '{"status":"ok","token":"TAqBaX1Ifhncbo9Myy-g4gyCnCKybaCFij4XubKpCLIGht7y106hwwe9mKBk-Y4x","userId":649,"userAccessGroupId":2,"fullName":"Anthony Anderson","features":{"hasAddToBDSList":false,"hasAllowedToLogin":true,"hasCorporateIntelligenceShowNetworkUpdates":true,"hasDashboardShowNetworkUpdates":true,"hasEnableSignatureViewing":true,"hasFirmReportsActivities":true,"hasFirmReportsCompanyOverview":true,"hasFirmReportsContactOverview":true,"hasFirmReportsFriendlyColleagues":true,"hasFirmReportsIndustryGroupOverview":true,"hasFirmReportsNewRelationships":true,"hasFirmReportsRelationshipsByTitle":true,"hasFirmReportsSearchExport":true,"hasFirmReportsUsageReport":true,"hasNetworkUpdatesShowCalendarAppointments":true,"hasNetworkUpdatesShowNewRelationships":true,"hasNetworkUpdatesShowRoleChanges":true,"hasSavedSearchesCreateAndEdit":true,"hasSearchBulkEmail":true,"hasSearchColleagues":true,"hasSearchCompanies":true,"hasSearchContacts":true,"hasSearchIndustries":true,"hasSearchLocations":true,"hasSearchResultsColleagues":true,"hasSearchResultsCompanies":true,"hasSearchResultsContacts":true,"hasSearchResultsIndustries":true,"hasSearchResultsLocations":true,"hasSearchResultsNewColleagues":true,"hasSearchResultsNewContacts":true,"hasSearchResultsOutOfTouchContacts":true,"hasSearchResultsOutOfTouchPersonal":true,"hasSearchResultsStrongRelationships":true,"hasSearchResultsViews":true,"hasSharingAddressBook":true,"hasSharingCalendar":true,"hasSharingMail":true,"hasShowSourcedSignatures":true,"hasShowVCard":true,"hasSyncAddressBook":true,"hasSyncCalendar":true,"hasSyncMail":true,"hasSyncSignatures":true,"hasUserAdmin":true}}';
        CNData_14_Login obj = CNData_14_Login.parse(json);
		System.assert(obj != null);
		json = '';		
		obj = CNData_14_Login.parse(json);
    }
}