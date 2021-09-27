/**
* {Purpose} – Test class for CNContactRelationshipViewController
*
* @author	Shah Kadirmohideen
* @version	2011-10-26
*/

/**
* CHANGE HISTORY
* =============================================================================
* Date			Name					Description
* 2011-10-26	Shah Kadirmohideen		Created      
* 2011-12-20	Shah Kadirmohideen		Added OnInstall annotation to enforce test method execution during package installation.
* 2012-01-20	Shah Kadirmohideen		Incorporated enhanced list (go to list) functionality related changes.
* =============================================================================
*/
@isTest(SeeAllData=true)  
private class CNContactRelationshipViewControllerTest {
	  
	/**
	* Validates relationship loading & pagination logic for the embedded page (basic)
	*/
	@isTest (OnInstall=false)
    private static void testContactRelationshipsBasic() {
    	//Setup test data
    	//09.15.14 CNUnitTest.initializeCustomSetting();
    	System.debug('page messages: ' + ApexPages.getMessages());
    	Account oAccount = CNUnitTest.getAccount(true);
    	Contact oContact = CNUnitTest.getContact(oAccount.Id, true);
    	Test.setCurrentPage(Page.CNContactRelationshipView);
    	ApexPages.StandardController oController = new ApexPages.StandardController(oContact);
    	 
    	
	 	
    	//Simulate XML response by setting it up on a static variable.
    	CNAppUtils.sHttpBodyInTestContext = CNUnitTest.getArrayOfContactXML(11);

    	Test.startTest();
    	Test.setMock(HttpCalloutMock.class, new CNWebServiceMockImpl());  
		CNAppUtils_14.AUTHTOKEN = 'FB2B02BEE0F652AADF7035CC831EBF73596EC884728758895CF8B1238E86AB5C4F98AA4711EFDF116669E9B3EC71F28169DD18507C0AD36FB55D778105D2C30D57221C383421488334ACF808477E22F613CABA9C1DC9760A734FC075DC4D4173'; 
		HttpResponse httpRes1 = new HttpResponse(); 
		httpRes1.setHeader('Content-Type', 'application-json');
		httpRes1.setBody('{"status":"ok","token":"_1OJRddzDLTJMxJ3AqGgLZLpUmSV32gpSlMuxMbPJY1iNfC6CCnCmpnMOOZAQBqs","userId":1,"userAccessGroupId":2,"fullName":"Local Admin","features":{"hasAddToBDSList":false,"hasAllowedToLogin":true,"hasColleagueExpansion":true,"hasCompanyExpansion":true,"hasContactExpansion":true,"hasCorporateIntelligenceShowNetworkUpdates":true,"hasDashboardShowNetworkUpdates":true,"hasEnableSignatureViewing":true,"hasExternalSync":true,"hasFirmReportsActivities":true,"hasFirmReportsCompanyOverview":true,"hasFirmReportsContactOverview":true,"hasFirmReportsFriendlyColleagues":true,"hasFirmReportsIndustryGroupOverview":true,"hasFirmReportsNewRelationships":true,"hasFirmReportsRelationshipsByTitle":true,"hasFirmReportsSearchExport":true,"hasFirmReportsUsageReport":true,"hasIndustryExpansion":true,"hasLocationExpansion":true,"hasNetworkUpdatesShowCalendarAppointments":true,"hasNetworkUpdatesShowNewRelationships":true,"hasNetworkUpdatesShowRoleChanges":true,"hasSavedSearchesCreateAndEdit":true,"hasSearchBulkEmail":true,"hasSearchColleagues":true,"hasSearchCompanies":true,"hasSearchContacts":true,"hasSearchIndustries":true,"hasSearchLocations":true,"hasSearchResultsColleagues":true,"hasSearchResultsCompanies":true,"hasSearchResultsContacts":true,"hasSearchResultsIndustries":true,"hasSearchResultsLocations":true,"hasSearchResultsNewColleagues":true,"hasSearchResultsNewContacts":true,"hasSearchResultsOutOfTouchContacts":true,"hasSearchResultsOutOfTouchPersonal":true,"hasSearchResultsStrongRelationships":true,"hasSearchResultsViews":true,"hasSharingAddressBook":true,"hasSharingCalendar":true,"hasSharingMail":true,"hasShowSourcedSignatures":true,"hasShowVCard":true,"hasSyncAddressBook":true,"hasSyncCalendar":true,"hasSyncMail":true,"hasSyncSignatures":true,"hasUserAdmin":true}}');
		httpRes1.setStatusCode(200);  
		CNAppUtils_14.oHttpResponse = httpRes1;  
		CNAppUtils_14.getResponse('https://get.test.foo', 6, 'GET', '', '', 'application/json', '');  
 		ApexPages.currentPage().getParameters().put('id',oContact.Id);
	 	ApexPages.currentPage().getParameters().put('token','ey0Jsdjubiouewbfrgoiboigbewwib');
	 	ApexPages.currentPage().getParameters().put('expires','3600');
    	//Validate page loading logic where we don't execute any logic when the controller is loaded for the first time.
    	CNContactRelationshipViewController oCustController = new CNContactRelationshipViewController(oController);
    	//
    	oCustController.cont = oContact;
		oCustController.showOAuth = true;
		oCustController.iTotalInnerRecords = 100;
		oCustController.noDataMessage = 'no data';
		//
		oCustController.setShowColleagueEmailData(true);
		system.assertEquals(oCustController.getShowColleagueEmailData(),true);

		oCustController.setShowColleagueLocation(true);
		system.assertEquals(oCustController.getShowColleagueLocation(),true);

		oCustController.setShowColleaguePhoneData(true);
		system.assertEquals(oCustController.getShowColleaguePhoneData(),true);
		
		oCustController.setShowColleagueRecency(true);
		system.assertEquals(oCustController.getShowColleagueRecency(),true);
		
		oCustController.setShowColleagueRelationshipStrength(true);
		system.assertEquals(oCustController.getShowColleagueRelationshipStrength(),true);
		
		oCustController.setShowColleagueSource(true);
		system.assertEquals(oCustController.getShowColleagueSource(),true);
		
		oCustController.setShowColleagueTitle(true);
		system.assertEquals(oCustController.getShowColleagueTitle(),true);
		 //
		 oCustController.searchText='test';
		system.assertEquals(oCustController.searchText,'test');
		
		oCustController.searchName=true;
		system.assertEquals(oCustController.searchName,true);
	 	oCustController.searchTitle=true;
		system.assertEquals(oCustController.searchTitle,true);
	 	oCustController.searchEmail=true;
		system.assertEquals(oCustController.searchEmail,true); 
 		oCustController.searchLocation=true;
		system.assertEquals(oCustController.searchLocation,true); 
	 	
	 	CNPaginator cnppp = new CNPaginator();
	 	oCustController.paginator=cnppp;
		system.assertEquals(oCustController.paginator,cnppp); 
	  	oCustController.isDownloadMode=true;
		system.assertEquals(oCustController.isDownloadMode,true); 
		oCustController.serviceDown=true;
		system.assertEquals(oCustController.serviceDown,true); 
	 	oCustController.showPageLoadingMsg=true;
		system.assertEquals(oCustController.showPageLoadingMsg,true); 
	 	oCustController.iTotalInnerPages=23;
		system.assertEquals(oCustController.iTotalInnerPages,23); 
    	oCustController.iTotalInnerPages=23;
		system.assertEquals(oCustController.iTotalInnerPages,23); 
		oCustController.innerpageSize=5;
		system.assertEquals(oCustController.innerpageSize,5);
 		oCustController.setiCurrentInnerPage(5);
		system.assertEquals(oCustController.getiCurrentInnerPage(),5);
 		List<CNData.CNRelationship> css = new List<CNData.CNRelationship>();
 		oCustController.cachedSearch = css;
 		oCustController.displayPopup=true;
		oCustController.closePopup();  
		system.assertEquals(false,oCustController.displayPopup);
		oCustController.processCheckChange(); 
		oCustController.innerlast();
  		oCustController.innerfirst();
  		oCustController.innernext();
  		oCustController.innerprevious();
  		oCustController.innerElipsis();
  		oCustController.innerbackElipsis();
		oCustController.getinnerEndOfPages();
  		oCustController.innerpagebynumber();
  		CNContactRElationshipService cn = new CNContactRElationshipService(oContact.Id, oContact.email);		
		Test.setMock(HttpCalloutMock.class, new CNWebServiceMockImpl());   
		cn.fetchAllDataFromSFDC();
		oCustController.paginator = new CNPaginator(cn); 
  		oCustController.reset();
  		oCustController.searchtext = '';
  		oCustController.search();
  		oCustController.searchtext = 'foo';
  		oCustController.search();
  		oCustController.getIsEnhancedList();
  		oCustController.getAppSetting();
  		//
		oCustController.innerSortBy(); 
    	//
    	System.assertEquals(oCustController.showPageLoadingMsg, true, 'Skip execution logic is not working');
    	System.assertEquals(oCustController.getIsDisplayResultTable(), false, 'Relationship table display decision logic is not working');
		
		//Validate relationships loading logic when the controller is executed for the second time (page #1).
    	ApexPages.currentPage().getParameters().put('mode', 'load');
    	oCustController = new CNContactRelationshipViewController(oController);
    	
    	System.assertEquals(oCustController.showPageLoadingMsg, null, 'Skip execution logic is not working');
		//System.assertNotEquals(oCustController.paginator, null, 'Pagination logic is not working');
		//System.assertEquals(0, oCustController.paginator.getRelationships().size(), 
		//						'Relationship loading logic is not working when the controller is loaded initially');
    	oCustController.getErrorsFound();
    	//System.assertEquals(oCustController.getErrorsFound(), false, 'Error identification logic is not working');
    	System.assertEquals(oCustController.getIsDisplayResultTable(), false, 'Relationship table display decision logic is not working');
		
		//Validate next page (#2) invocation logic    	
    	CNAppUtils.sHttpBodyInTestContext = CNUnitTest.getArrayOfRelationshipXML(11);
    	//oCustController.paginator.next();
		//System.assertEquals(0, oCustController.paginator.getRelationships().size(), 
		//						'Relationship loading logic is not working when next page is invoked - Page #2');
    	System.assertEquals(oCustController.getIsDisplayResultTable(), false, 'Relationship table display decision logic is not working');

		//Validate next page (#3) invocation logic    	
    	//oCustController.paginator.next();
		//System.assertEquals(0, oCustController.paginator.getRelationships().size(),
		//						'Relationship loading logic is not working when next page is invoked - Page #3');
    	System.assertEquals(oCustController.getIsDisplayResultTable(), false, 'Relationship table display decision logic is not working');
    	
    	 System.assertNotEquals(null, oCustController.getAppSetting(), 'Custom setting retrieval is not working');
		 
		Test.stopTest();
    }

    
	/**
	* Validates relationship loading & pagination logic for the embedded page (basic) with custom object cache
	*/
	@isTest (OnInstall=false)
    private static void testContactRelationshipsBasicWithCache() {
    	//Setup test data
    	//09.15.14 CNUnitTest.initializeCustomSetting();
    	Account oAcct = CNUnitTest.getAccount(true);
    	Contact oCont = CNUnitTest.getContact(oAcct.Id, true);
    	Test.setCurrentPage(Page.CNContactRelationshipView);
		ApexPages.currentPage().getParameters().put('mode', 'load');
    	Id colRecTypeId = Schema.SObjectType.CN_Relationship__c.getRecordTypeInfosByName().get('Colleague').getRecordTypeId();
    	CNAppUtils.CNWebServiceQueueHandler oQueueHandler = new CNAppUtils.CNWebServiceQueueHandler(null, oCont.Id, '123', 'Colleague');
    	oQueueHandler.createQueue();
    	List<CN_Relationship__c> listRelationships = CNUnitTest.getRelationships(oQueueHandler.oQueue.Id, 30, true, colRecTypeId);
    	oQueueHandler.updateColleagueStatus(oQueueHandler.ALL_DATA_RECEIVED_STATUS);
		oQueueHandler.tabName = 'Colleague';


    	Test.startTest();

    	ApexPages.StandardController oController = new ApexPages.StandardController(oCont);
    	CNContactRelationshipViewController oCustController = new CNContactRelationshipViewController(oController);
    	
    	//oCustController.paginator.next();
		//System.assertEquals(null, oCustController.paginator.oListHandler.checkObjectCacheStatus(), 'Object cache check is not handled correctly');
    	
    	//Test future call
    	CNAppUtils.sHttpBodyInTestContext = CNUnitTest.getArrayOfContactXML(11);
		oQueueHandler.updateColleagueStatus(oQueueHandler.INITIAL_DATA_RECEIVED_STATUS);
    	CNContactRelationshipService.fetchRestOfDataFromCN_Async('123', 0, oCont.Id, oQueueHandler.oQueue.Id);
    	CNContactRelationshipService.fetchRestOfDataFromCN_Async('123', 0, oCont.Id, null);
    	
    	Test.stopTest();
    }
        
	/**
	* Validates relationship loading & pagination logic for enhanced list (go to list)
	*/
	@isTest (OnInstall=false)
    private static void testContactRelationshipsEnhanced() {
    	//Setup test data
    	Test.setCurrentPage(Page.CNContactRelationshipView);
    	//09.15.14 CNUnitTest.initializeCustomSetting();
    	Account oAcct = CNUnitTest.getAccount(true);
    	Contact oCont = CNUnitTest.getContact(oAcct.Id, true);
    	Id colRecTypeId = Schema.SObjectType.CN_Relationship__c.getRecordTypeInfosByName().get('Colleague').getRecordTypeId();
    	CNAppUtils.CNWebServiceQueueHandler oQueueHandler = new CNAppUtils.CNWebServiceQueueHandler(null, oCont.Id, '123', 'Colleague');
    	oQueueHandler.createQueue();
    	List<CN_Relationship__c> listRelationships = CNUnitTest.getRelationships(oQueueHandler.oQueue.Id, 30, true, colRecTypeId);
    	oQueueHandler.updateColleagueStatus(oQueueHandler.ALL_DATA_RECEIVED_STATUS);
		oQueueHandler.tabName = 'Colleague';

    	//Simulate XML response by setting it up on a static variable.
    	CNAppUtils.sHttpBodyInTestContext = CNUnitTest.getArrayOfContactXML(11);
    	
    	Test.startTest();
    	
    	ApexPages.currentPage().getParameters().put('mode', 'elist');
    	ApexPages.currentPage().getParameters().put('downloadType', 'pdf');
    	ApexPages.StandardController oController = new ApexPages.StandardController(oCont);
    	CNContactRelationshipViewController oCustController = new CNContactRelationshipViewController(oController);
		
    	 
    	CNPaginator oPaginator = oCustController.paginator; 
    	 
    	//System.assertNotEquals(null, oPaginator,'Paginator not instantiated');
    	 
    	// System.assertEquals(false, oPaginator.getRecordsCountOnTabName().contains('of'), 'Tab name records count not calculated properly');
		
		//UNDO 09.12.14 System.assertEquals(10, oPaginator.getRelationships().size(), 'Relationship is not returned');
		//System.assertNotEquals(null, oPaginator.getNextPageLabel(), 'Next Page Label is not prepared correctly');
		//System.assertEquals(false, oPaginator.getHasNextPageLabel(), 'Next page should exist');
		//System.assertNotEquals(null, oPaginator.getGoToListLabel(), 'Go to list Label is not prepared correctly');
		
		
    	Test.stopTest();
    }  
    
    
	/**
	* Validates error conditions.
	*/
	@isTest (OnInstall=false)
    private static void testContactRelationshipsError() {
    	//Setup test data
    	Test.setCurrentPage(Page.CNContactRelationshipView);
    	//09.15.14 CN_App_Settings__c oAppSetup = CNUnitTest.initializeCustomSetting();
    	CN_App_Settings__c oAppSetup = CNAppUtils.getAppCustomSetting();
    	
    	Account oAcct = CNUnitTest.getAccount(true);
    	Contact oCont = CNUnitTest.getContact(oAcct.Id, true);
    	oCont.Email = null;
    	//update oCont;
    	
    	Test.startTest();
    	
    	ApexPages.currentPage().getParameters().put('mode', 'load');
    	ApexPages.StandardController oController = new ApexPages.StandardController(oCont);
    	CNContactRelationshipViewController oCustController = new CNContactRelationshipViewController(oController);
    	
		//Validate email
    	 
    	System.assertNotEquals(null, ApexPages.getMessages(), 'Email check is not working');
    	
    	oCont.Email = 'test@test.com';
    	//update oCont;
    	
    	//Validate service active/inactive state
    	oAppSetup.WS_Is_Active__c = false;
    	update oAppSetup;
    	 
    	System.assertNotEquals(null, ApexPages.getMessages(), 'Web service active/inactive check is not working');
    	
    	new CNPaginator();
    	Test.stopTest();
    }          
}