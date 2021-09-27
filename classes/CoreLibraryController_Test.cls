/*
===============================================================================
 $CoreLibraryController_Test$
===============================================================================

PURPOSE:			Contains all the testMethods for CoreLibraryController.cls

FUNCTIONALITY:  

COMMENTS:		
CHANGE HISTORY
===============================================================================
DATE			NAME					DESC
2012-11-12		Shawn Gray				Created
2017-03-31      Karthi                  Optimized the coverage as per JIRA STORY: PS0-1
===============================================================================
*/
@isTest
public with sharing class CoreLibraryController_Test {

 	private static testmethod void testCoreLibrary(){
		//setup
		
		setupCoreLibraryServiceSettings();
		
		Account oAccount = UnitTest.getAccountInstance();
		
		oAccount.FrozenMarketSegment__c = 'SLF 7-10';
		 
		insert oAccount;
		           
		MarketSegment__c oMarketSegment = MarketSegment__c.getinstance(oAccount.FrozenMarketSegment__c);
		if (oMarketSegment == null) {
			oMarketSegment = new MarketSegment__C() ;
			oMarketSegment.MarketSegmentKey__c = 22;
			oMarketSegment.Name = 'SLF 7-10';
			insert oMarketSegment;
		}
		
		
		PageReference oPageReference = Page.CoreLibrary;
		
		Test.setCurrentPageReference(oPageReference);
		apexPages.StandardController oStandardController = new apexPages.StandardController(oAccount);
		
		
		
		list<string> outputcode = new list<string>();
		outputcode.add('test1');
		outputcode.add('test2');
		UnitTest.MockWebServiceResponse.put(CoreLibraryService.MockCalloutGetCoreLibraryCodes,outputcode);
			
		
		//execute test
		test.startTest();
			CoreLibraryController oCoreLibrary = New CoreLibraryController(oStandardController);
			oCoreLibrary = New CoreLibraryController(oStandardController);
			
			List<selectoption> listCodeSelectOptions = new List<selectoption>();
			list<string> oOptions = new list<string>();
			oOptions.add('test1');
		    oOptions.add('test2');
			listcodeselectoptions = ocorelibrary.getCoreLibraryListOptions(oOptions);
			ocorelibrary.Code1 = 'a';
			listcodeselectoptions = ocorelibrary.SelectLibraries1;
			
			
		test.stopTest();
		
		//system.assertequals(false, ApexPages.hasMessages(apexpages.severity.error));
		system.assertequals(2, oCoreLibrary.corelibrarycodes.size());
		system.assertequals('test1', oCoreLibrary.corelibrarycodes[0]);
			
		}
	
 	private static testmethod void testGetCoreLibraries(){
		//setup
		
		setupCoreLibraryServiceSettings();
		
		Account oAccount = UnitTest.getAccountInstance();
		
		oAccount.FrozenMarketSegment__c = 'SLF 7-10';
		 
		insert oAccount;
		           
		MarketSegment__c oMarketSegment = MarketSegment__c.getinstance(oAccount.FrozenMarketSegment__c);
		if (oMarketSegment == null) {
			oMarketSegment = new MarketSegment__C() ;
			oMarketSegment.MarketSegmentKey__c = 22;
			oMarketSegment.Name = 'SLF 7-10';
			insert oMarketSegment;
		}
		
		
		PageReference oPageReference = Page.CoreLibrary;
		
		Test.setCurrentPageReference(oPageReference);
		apexPages.StandardController oStandardController = new apexPages.StandardController(oAccount);
		 
		CoreLibraryController.CoreLibraries CoreLibrariesResponse = new CoreLibraryController.CoreLibraries();
		CoreLibrariesResponse.CoreLibraryId = '123';
        CoreLibrariesResponse.CoreLibraryDesc = 'test123';

		UnitTest.MockWebServiceResponse.put(CoreLibraryService.MockCalloutGetCoreLibraries,CoreLibrariesResponse);

		//execute test
		test.startTest();
		
		CoreLibraryController oCoreLibrary = New CoreLibraryController(oStandardController);	
		List<CoreLibraryService.CoreLibraries>  oCoreLibraries = new List<CoreLibraryService.CoreLibraries>();
		
		//list<SelectOption> listLibrarySelectOptions = new List<SelectOption>();
		//listLibrarySelectOptions = loadSelectLibraries('a');
		oCoreLibraries = oCoreLibrary.GetCoreLibraries('a');
		
			
		test.stopTest();
		
		
		//validate test
		
		
	}

	private static testmethod void testgetCoreLibraryMaterials(){
		//setup
		setupCoreLibraryServiceSettings();
		
		Account oAccount = UnitTest.getAccountInstance();
		
		oAccount.FrozenMarketSegment__c = 'SLF 7-10';
		 
		insert oAccount;
		           
		MarketSegment__c oMarketSegment = MarketSegment__c.getinstance(oAccount.FrozenMarketSegment__c);
		if (oMarketSegment == null) {
			oMarketSegment = new MarketSegment__C() ;
			oMarketSegment.MarketSegmentKey__c = 22;
			oMarketSegment.Name = 'SLF 7-10';
			insert oMarketSegment;
		}
		
		PageReference oPageReference = Page.CoreLibrary;
		
		Test.setCurrentPageReference(oPageReference);
		apexPages.StandardController oStandardController = new apexPages.StandardController(oAccount);

		//execute test
		test.startTest();
		
		CoreLibraryController oCoreLibrary = New CoreLibraryController(oStandardController);	
		list<CoreLibraryService.CoreLibraryMaterials> oCoreLibrariesMat = new list<CoreLibraryService.CoreLibrarymaterials>();
		oCoreLibrariesMat = oCoreLibrary.getCoreLibraryMaterials('a','b');
		
		test.stopTest();
		
		
		//validate test
	}




	private static testmethod void testchangeDisplayCoreLibraryList(){
		//setup
		setupCoreLibraryServiceSettings();
		
		Account oAccount = UnitTest.getAccountInstance();
		
		oAccount.FrozenMarketSegment__c = 'SLF 7-10';
		 
		insert oAccount;
		           
		MarketSegment__c oMarketSegment = MarketSegment__c.getinstance(oAccount.FrozenMarketSegment__c);
		if (oMarketSegment == null) {
			oMarketSegment = new MarketSegment__C() ;
			oMarketSegment.MarketSegmentKey__c = 22;
			oMarketSegment.Name = 'SLF 7-10';
			insert oMarketSegment;
		}
		
		PageReference oPageReference = Page.CoreLibrary;
		
		Test.setCurrentPageReference(oPageReference);
		apexPages.StandardController oStandardController = new apexPages.StandardController(oAccount);

		//execute test
		test.startTest();
		
		CoreLibraryController oCoreLibrary = New CoreLibraryController(oStandardController);	
		list<CoreLibraryService.CoreLibraryMaterials> oCoreLibrariesMat = new list<CoreLibraryService.CoreLibrarymaterials>();
		oCoreLibrariesMat = oCoreLibrary.getCoreLibraryMaterials('a','b');
		oCoreLibrary.changeDisplayCoreLibraryList();
		test.stopTest();
		
		
		//validate test
	}


	
	public static WebServiceSettings__c setupCoreLibraryServiceSettings() {
		WebServiceSettings__c oWebServiceSettings = WebServiceSettings__c.getInstance(CoreLibraryservice.WebServiceName);
		
		if (oWebServiceSettings == null) {
			oWebServiceSettings = new WebServiceSettings__c();
			oWebServiceSettings.Name = CoreLibraryservice.WebServiceName;
			oWebServiceSettings.Endpoint__c = 'https:\\CoreLibrary.thomsonreuters.com';
			oWebServiceSettings.Timeout__c = 5;
			oWebServiceSettings.Active__c = true;
			oWebServiceSettings.Service_Unavailable_Message__c = 'Service is currently unavailable';
			insert oWebServiceSettings;
		}
		
		return oWebServiceSettings;
	}	
}