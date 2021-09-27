/**
 * {Purpose} – Test class for CNAppUtils_14
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
@isTest(SeeAllData=true)


private class CNAppUtils_14_Test {

	static testMethod void myUnitTest() {
		Test.startTest();
		//set up response
		HttpResponse httpRes = new HttpResponse(); 
		httpRes.setHeader('Content-Type', 'application-json');
		httpRes.setBody('{"status":"ok","token":"DDgKhDk1mzrL8SENN5oCoqVAVy2UOMHf2EOILApZjzXEo24BuuqsNjTcojeBZOIm","userId":649,"userAccessGroupId":2,"fullName":"Anthony Anderson","features":{"hasAddToBDSList":false,"hasAllowedToLogin":true,"hasCorporateIntelligenceShowNetworkUpdates":true,"hasDashboardShowNetworkUpdates":true,"hasEnableSignatureViewing":true,"hasFirmReportsActivities":true,"hasFirmReportsCompanyOverview":true,"hasFirmReportsContactOverview":true,"hasFirmReportsFriendlyColleagues":true,"hasFirmReportsIndustryGroupOverview":true,"hasFirmReportsNewRelationships":true,"hasFirmReportsRelationshipsByTitle":true,"hasFirmReportsSearchExport":true,"hasFirmReportsUsageReport":true,"hasNetworkUpdatesShowCalendarAppointments":true,"hasNetworkUpdatesShowNewRelationships":true,"hasNetworkUpdatesShowRoleChanges":true,"hasSavedSearchesCreateAndEdit":true,"hasSearchBulkEmail":true,"hasSearchColleagues":true,"hasSearchCompanies":true,"hasSearchContacts":true,"hasSearchIndustries":true,"hasSearchLocations":true,"hasSearchResultsColleagues":true,"hasSearchResultsCompanies":true,"hasSearchResultsContacts":true,"hasSearchResultsIndustries":true,"hasSearchResultsLocations":true,"hasSearchResultsNewColleagues":true,"hasSearchResultsNewContacts":true,"hasSearchResultsOutOfTouchContacts":true,"hasSearchResultsOutOfTouchPersonal":true,"hasSearchResultsStrongRelationships":true,"hasSearchResultsViews":true,"hasSharingAddressBook":true,"hasSharingCalendar":true,"hasSharingMail":true,"hasShowSourcedSignatures":true,"hasShowVCard":true,"hasSyncAddressBook":true,"hasSyncCalendar":true,"hasSyncMail":true,"hasSyncSignatures":true,"hasUserAdmin":true}}');
		httpRes.setStatusCode(200);  
		CNAppUtils_14.oHttpResponse = httpRes;   
		CNAppUtils_14  cn = new CNAppUtils_14 ();
		Test.setMock(HttpCalloutMock.class, new CNWebServiceMockImpl());
		system.assertNotEquals(null,cn);
		 
		 
		Test.setMock(HttpCalloutMock.class, new CNWebServiceMockImpl());  
		CNAppUtils_14.AUTHTOKEN = 'FB2B02BEE0F652AADF7035CC831EBF73596EC884728758895CF8B1238E86AB5C4F98AA4711EFDF116669E9B3EC71F28169DD18507C0AD36FB55D778105D2C30D57221C383421488334ACF808477E22F613CABA9C1DC9760A734FC075DC4D4173'; 
		HttpResponse httpRes1 = new HttpResponse(); 
		httpRes1.setHeader('Content-Type', 'application-json');
		httpRes1.setBody('{"status":"ok","token":"_1OJRddzDLTJMxJ3AqGgLZLpUmSV32gpSlMuxMbPJY1iNfC6CCnCmpnMOOZAQBqs","userId":1,"userAccessGroupId":2,"fullName":"Local Admin","features":{"hasAddToBDSList":false,"hasAllowedToLogin":true,"hasColleagueExpansion":true,"hasCompanyExpansion":true,"hasContactExpansion":true,"hasCorporateIntelligenceShowNetworkUpdates":true,"hasDashboardShowNetworkUpdates":true,"hasEnableSignatureViewing":true,"hasExternalSync":true,"hasFirmReportsActivities":true,"hasFirmReportsCompanyOverview":true,"hasFirmReportsContactOverview":true,"hasFirmReportsFriendlyColleagues":true,"hasFirmReportsIndustryGroupOverview":true,"hasFirmReportsNewRelationships":true,"hasFirmReportsRelationshipsByTitle":true,"hasFirmReportsSearchExport":true,"hasFirmReportsUsageReport":true,"hasIndustryExpansion":true,"hasLocationExpansion":true,"hasNetworkUpdatesShowCalendarAppointments":true,"hasNetworkUpdatesShowNewRelationships":true,"hasNetworkUpdatesShowRoleChanges":true,"hasSavedSearchesCreateAndEdit":true,"hasSearchBulkEmail":true,"hasSearchColleagues":true,"hasSearchCompanies":true,"hasSearchContacts":true,"hasSearchIndustries":true,"hasSearchLocations":true,"hasSearchResultsColleagues":true,"hasSearchResultsCompanies":true,"hasSearchResultsContacts":true,"hasSearchResultsIndustries":true,"hasSearchResultsLocations":true,"hasSearchResultsNewColleagues":true,"hasSearchResultsNewContacts":true,"hasSearchResultsOutOfTouchContacts":true,"hasSearchResultsOutOfTouchPersonal":true,"hasSearchResultsStrongRelationships":true,"hasSearchResultsViews":true,"hasSharingAddressBook":true,"hasSharingCalendar":true,"hasSharingMail":true,"hasShowSourcedSignatures":true,"hasShowVCard":true,"hasSyncAddressBook":true,"hasSyncCalendar":true,"hasSyncMail":true,"hasSyncSignatures":true,"hasUserAdmin":true}}');
		httpRes1.setStatusCode(200);  
		CNAppUtils_14.oHttpResponse = httpRes1;  
		CNAppUtils_14.getResponse('https://get.test.foo', 6, 'GET', '', '', 'application/json', '');  
 	
		CN_App_Settings__c csett = [SELECT APP_OAUTH_CLIENTID__c,APP_OAUTH_SECRET__c,APP_OAUTH_TOKEN__c,APP_PASSWORD__c,APP_USERNAME__c,OAUTH_GRANTTYPE__c,OAUTH_URL__c FROM CN_App_Settings__c];
    	
    	String HOSTNAME = csett.OAUTH_URL__c ;		
		String CLIENTID = csett.APP_OAUTH_CLIENTID__c;
		String SECRET = csett.APP_OAUTH_SECRET__c;
		 
		
		
		system.assertEquals(CNAppUtils_14.AUTHTOKEN,'FB2B02BEE0F652AADF7035CC831EBF73596EC884728758895CF8B1238E86AB5C4F98AA4711EFDF116669E9B3EC71F28169DD18507C0AD36FB55D778105D2C30D57221C383421488334ACF808477E22F613CABA9C1DC9760A734FC075DC4D4173');
		CNAppUtils_14.tokenExpires = 3600;
		system.assertEquals(3600,CNAppUtils_14.tokenExpires);
		CNAppUtils_14.token = '23465432tg25fgt255fg';
		system.assertEquals('23465432tg25fgt255fg',CNAppUtils_14.token);
		
		//test save auth token		
		CNAppUtils_14.saveToken();
		User u = [SELECT BDP_OAuth_Expires_At__c, BDP_OAuth_Token__c FROM User where id=:UserInfo.getUserId()];
		//system.assertEquals(u.BDP_OAuth_Token__c, 'U2FsZXNGb3JjZTpzYWxlc2ZvcmNl');
		Test.stopTest();
	}
}