/**
===============================================================================
 $ContentController_Test$
===============================================================================

PURPOSE:			Contains all the testMethods for ContentController.cls

FUNCTIONALITY:  

COMMENTS:		
CHANGE HISTORY
===============================================================================
DATE			NAME					DESC
2012-05-5		Shawn Gray				Created
2017-03-31      Karthi                  Optimized the coverage as per JIRA STORY: PS0-1
===============================================================================
*/
@isTest
private class ContentController_Test {

	private static testmethod void testContentController(){
		//setup
		Account oAccount = UnitTest.getAccountInstance();
		 
		insert oAccount;
		
		PageReference oPageReference = Page.PlanMatch;
		oPageReference.getParameters().put('Id',oAccount.Id);
		
		Test.setCurrentPageReference(oPageReference);
		apexPages.StandardController oStandardController = new apexPages.StandardController(oAccount);
		
		ContentOptimizerServiceWS.Customer outputCustomer = new ContentOptimizerServiceWS.Customer();
		outputCustomer.AddrStateCode = 'NY';

		UnitTest.MockWebServiceResponse.put(ContentOptimizerService.MockCalloutGetCustomer,outputCustomer);
		
		//execute test
		test.startTest();
			ContentController oContentController = New ContentController(oStandardController);
			oPageReference.getParameters().put('SAP','123456789');
			
			oContentController = New ContentController(oStandardController);
			
		test.stopTest();
		
		
		//validate test
		
		//system.assertequals(true, ApexPages.hasMessages(apexpages.severity.error));
			
		}
		
	private static testmethod void test1ContentController(){
		//setup
		Account oAccount = UnitTest.getAccountInstance();
		 
		insert oAccount;
		
		PageReference oPageReference = Page.PlanMatch;
		oPageReference.getParameters().put('Id',oAccount.Id);
		
		Test.setCurrentPageReference(oPageReference);
		apexPages.StandardController oStandardController = new apexPages.StandardController(oAccount);
		
		ContentOptimizerServiceWS.Customer outputCustomer = new ContentOptimizerServiceWS.Customer();
		outputCustomer.AddrStateCode = Null;

		UnitTest.MockWebServiceResponse.put(ContentOptimizerService.MockCalloutGetCustomer,outputCustomer);
		
		//execute test
		test.startTest();
			ContentController oContentController = New ContentController(oStandardController);
			oPageReference.getParameters().put('SAP','123456789');
			
			oContentController = New ContentController(oStandardController);
			
		test.stopTest();
		
		
		//validate test
		
		system.assertequals(true, ApexPages.hasMessages(apexpages.severity.error));
			
		}		
	
	private static testmethod void testgetUsageData(){
		//setup
		
		Account oAccount = UnitTest.getAccountInstance();
		//oAccount.SAPAccountNumber__c = 'u000000139';
				//oAccount.SAPAccountNumber__c = '139';
		insert oAccount;
		
		PageReference oPageReference = Page.PlanMatch;
		
		oPageReference.getParameters().put('Id',oAccount.Id);
		
		
		Test.setCurrentPageReference(oPageReference);
		apexPages.StandardController oStandardController = new apexPages.StandardController(oAccount);
		
		ContentOptimizerServiceWS.Customer outputCustomer = new ContentOptimizerServiceWS.Customer();
		outputCustomer.AddrStateCode = 'NY';
		outputCustomer.ZwAcctSapId = 1000000139;

		UnitTest.MockWebServiceResponse.put(ContentOptimizerService.MockCalloutGetCustomer,outputCustomer);

		ContentOptimizerServiceWS.MaterialContent outputMaterialContent = new ContentOptimizerServiceWS.MaterialContent();
		
		outputMaterialContent.AcctSapId = 1000000139;
		//outputMaterialContent.OtherMaterials.add =
		//outputMaterialContent.PrimaryMaterials
		
		outputMaterialContent.PrimaryMaterials = new List<ContentOptimizerServiceWS.MaterialItem>();
		for (integer i=0; i<20; i++) {    
			ContentOptimizerServiceWS.MaterialItem oMatch = new ContentOptimizerServiceWS.MaterialItem();  
		    oMatch.materialnumber = i;    
		 	oMatch.MaterialDesc = 'SAP-' + i;    
		 	oMatch.listprice = i + 100;          
		  	outputMaterialcontent.PrimaryMaterials.add(oMatch);
		}
		  
		outputMaterialContent.PublicMaterials = new List<ContentOptimizerServiceWS.MaterialItem>();
		for (integer i=0; i<20; i++) {    
			ContentOptimizerServiceWS.MaterialItem oMatch = new ContentOptimizerServiceWS.MaterialItem();  
		    oMatch.materialnumber = i;    
		 	oMatch.MaterialDesc = 'SAP-' + i;    
		 	oMatch.listprice = i + 100;          
		  	outputMaterialcontent.PublicMaterials.add(oMatch);
		}
	
		outputMaterialContent.OtherMaterials = new List<ContentOptimizerServiceWS.MaterialItem>();
		for (integer i=0; i<20; i++) {    
			ContentOptimizerServiceWS.MaterialItem oMatch = new ContentOptimizerServiceWS.MaterialItem();  
		    oMatch.materialnumber = i;    
		 	oMatch.MaterialDesc = 'SAP-' + i;    
		 	oMatch.listprice = i + 100;          
		  	outputMaterialcontent.OtherMaterials.add(oMatch);
		}	
			  
		UnitTest.MockWebServiceResponse.put(ContentOptimizerService.MockCalloutCalculateMatch,outputMaterialContent);

		oPageReference.getParameters().put('SAP','1000000139');

		
		
		
		//execute test
		test.startTest();
		
		ContentController oContentController = New ContentController(oStandardController);	
		list<ContentController.Content>  oContent = new list<ContentController.Content>();
		
		oContent = oContentController.getUsageData();
	
			
		test.stopTest();
		
		
		//validate test
		
		
	}
		
	
	private static testmethod void testlazyLoadPlanMatch(){
		//setup
		
		Account oAccount = UnitTest.getAccountInstance();
		//oAccount.SAPAccountNumber__c = 'u000000139';
				//oAccount.SAPAccountNumber__c = '139';
		insert oAccount;
		
		PageReference oPageReference = Page.PlanMatch;
		
		oPageReference.getParameters().put('Id',oAccount.Id);
		
		
		Test.setCurrentPageReference(oPageReference);
		apexPages.StandardController oStandardController = new apexPages.StandardController(oAccount);
		
		ContentOptimizerServiceWS.Customer outputCustomer = new ContentOptimizerServiceWS.Customer();
		outputCustomer.AddrStateCode = 'NY';
		outputCustomer.ZwAcctSapId = 1000000139;

		UnitTest.MockWebServiceResponse.put(ContentOptimizerService.MockCalloutGetCustomer,outputCustomer);
		
		oPageReference.getParameters().put('SAP','1000000139');

		
		
		
		//execute test
		test.startTest();
		
		ContentController oContentController = New ContentController(oStandardController);	
		
		oContentController.lazyLoadPlanMatch();
		oContentController.lazyLoadUsageMatch();
		oContentController.lazyLoadKnownMatch();
		oContentController.lazyLoadPlanUsageMatch();
		oContentController.lazyLoadTotalMatch();
		
			
		test.stopTest();
		
		
		//validate test
	}

	private static testmethod void testfindAccount2(){
		//setup
		
		Account oAccount = UnitTest.getAccountInstance();
		oAccount.SAPAccountNumber__c = '000000139';
				//oAccount.SAPAccountNumber__c = '139';
		insert oAccount;
		
		PageReference oPageReference = Page.PlanMatch;
		
		oPageReference.getParameters().put('Id',oAccount.Id);
		
		
		Test.setCurrentPageReference(oPageReference);
		apexPages.StandardController oStandardController = new apexPages.StandardController(oAccount);
		
		ContentOptimizerServiceWS.Customer outputCustomer = new ContentOptimizerServiceWS.Customer();
		outputCustomer.AddrStateCode = 'NY';
		outputCustomer.ZwAcctSapId = 1000000139;

		UnitTest.MockWebServiceResponse.put(ContentOptimizerService.MockCalloutGetCustomer,outputCustomer);
		
		oPageReference.getParameters().put('SAP','1000000139');

		//oContentController.searchText = '1000000139';
		
		
		//execute test
		test.startTest();
		
		ContentController oContentController = New ContentController(oStandardController);
		PageReference oPageReference3 = oContentController.findAccount2();
		oContentController.searchText = '000000139';	
		
		PageReference oPageReference2 = oContentController.findAccount2();
	
		test.stopTest();
		
		
		//validate test
	}
	
	
		private static testmethod void testGotoPage(){
		//setup
		
		Account oAccount = UnitTest.getAccountInstance();
		//oAccount.SAPAccountNumber__c = 'u000000139';
				//oAccount.SAPAccountNumber__c = '139';
		insert oAccount;
		
		PageReference oPageReference = Page.PlanMatch;
		
		oPageReference.getParameters().put('Id',oAccount.Id);
		
		
		Test.setCurrentPageReference(oPageReference);
		apexPages.StandardController oStandardController = new apexPages.StandardController(oAccount);
		
		ContentOptimizerServiceWS.Customer outputCustomer = new ContentOptimizerServiceWS.Customer();
		outputCustomer.AddrStateCode = 'NY';
		outputCustomer.ZwAcctSapId = 1000000139;

		UnitTest.MockWebServiceResponse.put(ContentOptimizerService.MockCalloutGetCustomer,outputCustomer);
		
		oPageReference.getParameters().put('SAP','1000000139');

		test.startTest();
		
		ContentController oContentController = New ContentController(oStandardController);
		oContentController.searchText = '1000000139';	
		oContentController.lazyLoadPlanMatch();
		
		oContentController.DisplayPlanDetail1();
		oContentController.SearchPlanMatchDetails();
		PageReference oPageReference3 = oContentController.GotoPage();
	
		test.stopTest();
		
		
		//validate test
	}
	
	private static testmethod void testbackpage(){
		//setup
		
		Account oAccount = UnitTest.getAccountInstance();
		//oAccount.SAPAccountNumber__c = 'u000000139';
				//oAccount.SAPAccountNumber__c = '139';
		insert oAccount;
		
		PageReference oPageReference = Page.PlanMatch;
		
		oPageReference.getParameters().put('Id',oAccount.Id);
		
		
		Test.setCurrentPageReference(oPageReference);
		apexPages.StandardController oStandardController = new apexPages.StandardController(oAccount);
		
		ContentOptimizerServiceWS.Customer outputCustomer = new ContentOptimizerServiceWS.Customer();
		outputCustomer.AddrStateCode = 'NY';
		outputCustomer.ZwAcctSapId = 1000000139;

		UnitTest.MockWebServiceResponse.put(ContentOptimizerService.MockCalloutGetCustomer,outputCustomer);
		
		oPageReference.getParameters().put('SAP','1000000139');

		//execute test
		test.startTest();
		
		ContentController oContentController = New ContentController(oStandardController);
		oContentController.searchText = '1000000139';	
		
		PageReference oPageReference4 = oContentController.backpage();
	
		test.stopTest();
		
		
		//validate test
	}

	private static testmethod void testfindAccount3(){
		//setup
		
		Account oAccount = UnitTest.getAccountInstance();
		//oAccount.SAPAccountNumber__c = 'u000000139';
				//oAccount.SAPAccountNumber__c = '139';
		insert oAccount;
		
		PageReference oPageReference = Page.PlanMatch;
		
		oPageReference.getParameters().put('Id',oAccount.Id);
		
		
		Test.setCurrentPageReference(oPageReference);
		apexPages.StandardController oStandardController = new apexPages.StandardController(oAccount);
		
		ContentOptimizerServiceWS.Customer outputCustomer = new ContentOptimizerServiceWS.Customer();
		outputCustomer.AddrStateCode = 'NY';
		outputCustomer.ZwAcctSapId = 1000000139;

		UnitTest.MockWebServiceResponse.put(ContentOptimizerService.MockCalloutGetCustomer,outputCustomer);
		
		oPageReference.getParameters().put('SAP','1000000139');

		//oContentController.searchText = '1000000139';
		
		
		//execute test
		test.startTest();
		
		ContentController oContentController = New ContentController(oStandardController);
		oContentController.searchText = '1000000139';	
		
		PageReference oPageReference2 = oContentController.findAccount3();
	
		test.stopTest();
		
		
		//validate test
	}
	private static testmethod void testDisplayPlanDetail1(){
		//setup
		
		Account oAccount = UnitTest.getAccountInstance();
		//oAccount.SAPAccountNumber__c = 'u000000139';
				//oAccount.SAPAccountNumber__c = '139';
		insert oAccount;
		
		PageReference oPageReference = Page.PlanMatch;
		
		oPageReference.getParameters().put('Id',oAccount.Id);
		
		
		Test.setCurrentPageReference(oPageReference);
		apexPages.StandardController oStandardController = new apexPages.StandardController(oAccount);
		
		ContentOptimizerServiceWS.Customer outputCustomer = new ContentOptimizerServiceWS.Customer();
		outputCustomer.AddrStateCode = 'NY';
		outputCustomer.ZwAcctSapId = 1000000139;

		UnitTest.MockWebServiceResponse.put(ContentOptimizerService.MockCalloutGetCustomer,outputCustomer);
		
		oPageReference.getParameters().put('SAP','1000000139');

		//oContentController.searchText = '1000000139';
		
		
		
		
		//execute test
		test.startTest();
		
		ContentController oContentController = New ContentController(oStandardController);
		oContentController.searchText = '1000000139';	
		ContentOptimizerServiceWS.MaterialContent outputMaterialContent = new ContentOptimizerServiceWS.MaterialContent();
		
		outputMaterialContent.AcctSapId = 1000000139;
 
		outputMaterialContent.PrimaryMaterials = new List<ContentOptimizerServiceWS.MaterialItem>();
		for (integer i=0; i<20; i++) {    
			ContentOptimizerServiceWS.MaterialItem oMatch = new ContentOptimizerServiceWS.MaterialItem();  
		    oMatch.materialnumber = i;    
		 	oMatch.MaterialDesc = 'SAP-' + i;    
		 	oMatch.listprice = i + 100; 
		 //oContentController.lazyLoadPlanMatch();         
		outputMaterialcontent.PrimaryMaterials.add(oMatch);
		}
		  
		outputMaterialContent.PublicMaterials = new List<ContentOptimizerServiceWS.MaterialItem>();
		for (integer i=0; i<20; i++) {    
			ContentOptimizerServiceWS.MaterialItem oMatch = new ContentOptimizerServiceWS.MaterialItem();  
		    oMatch.materialnumber = i;    
		 	oMatch.MaterialDesc = 'SAP-' + i;    
		 	oMatch.listprice = i + 100;     
//		 	oContentController.planPubliccontents.add(oMatch);     
		outputMaterialcontent.PublicMaterials.add(oMatch);
		  	
		 }
	
		outputMaterialContent.OtherMaterials = new List<ContentOptimizerServiceWS.MaterialItem>();
		for (integer i=0; i<20; i++) {    
			ContentOptimizerServiceWS.MaterialItem oMatch = new ContentOptimizerServiceWS.MaterialItem();  
		    oMatch.materialnumber = i;    
		 	oMatch.MaterialDesc = 'SAP-' + i;    
		 	oMatch.listprice = i + 100;       
	//	  	oContentController.planOthercontents.add(oMatch);        
		outputMaterialcontent.OtherMaterials.add(oMatch);
		}
		
		oContentController.PlanPrimaryContents = new list<ContentController.Content>();
		oContentController.UsagePrimaryContents = new list<ContentController.Content>();
		oContentController.UsagePublicContents = new list<ContentController.Content>();
		oContentController.UsageOtherContents = new list<ContentController.Content>();
			for (integer i=0; i<20; i++) {    
			ContentController.Content ocontent = new ContentController.Content();  
		    ocontent.materialnumber = i;    
		 	ocontent.Material = 'SAP-' + i;    
		 	ocontent.IsSelected = true;      
		  	oContentController.PlanPrimaryContents.add(ocontent);
		  	oContentController.UsagePrimaryContents.add(ocontent);
		  	oContentController.UsagePublicContents.add(ocontent);
		  	oContentController.UsageOtherContents.add(ocontent);
		}
		oContentController.PlanOtherContents = new list<ContentController.Content>();
		oContentController.KnownPrimaryContents = new list<ContentController.Content>();
		oContentController.KnownPublicContents = new list<ContentController.Content>();
		oContentController.KnownOtherContents = new list<ContentController.Content>();
			for (integer i=0; i<20; i++) {    
			ContentController.Content ocontent = new ContentController.Content();  
		    ocontent.materialnumber = i;    
		 	ocontent.Material = 'SAP-' + i;    
		 	ocontent.IsSelected = true;      
		  	oContentController.PlanOtherContents.add(ocontent);
		  	oContentController.KnownPrimaryContents.add(ocontent);
		  	oContentController.KnownPublicContents.add(ocontent);
		  	oContentController.KnownOtherContents.add(ocontent);
		}
		oContentController.PlanPublicContents = new list<ContentController.Content>();
		oContentController.PlanUsagePublicContents = new list<ContentController.Content>();
		oContentController.PlanUsagePrimaryContents = new list<ContentController.Content>();
		oContentController.UsagePublicContents = new list<ContentController.Content>();
		oContentController.PlanUsageOtherContents = new list<ContentController.Content>();
		oContentController.TotalPrimaryContents = new list<ContentController.Content>();
		oContentController.TotalPublicContents = new list<ContentController.Content>();
		oContentController.TotalOtherContents = new list<ContentController.Content>();
			for (integer i=0; i<20; i++) {    
			ContentController.Content ocontent = new ContentController.Content();  
		    ocontent.materialnumber = i;    
		 	ocontent.Material = 'SAP-' + i;    
		 	ocontent.IsSelected = true;      
		  	oContentController.PlanUsagePrimaryContents.add(ocontent);
		  	oContentController.PlanPublicContents.add(ocontent);
		  	oContentController.PlanUsagePublicContents.add(ocontent);
		  	oContentController.UsagePublicContents.add(ocontent);
		  	oContentController.PlanUsageOtherContents.add(ocontent);
		  	oContentController.TotalPrimaryContents.add(ocontent);
		  	oContentController.TotalPublicContents.add(ocontent);
		  	oContentController.TotalOtherContents.add(ocontent);
		}
		
	
		PageReference oPageReference2 = oContentController.DisplayPlanDetail1();
		PageReference oPageReference3 = oContentController.DisplayUsageDetail();
		PageReference oPageReference4 = oContentController.DisplayKnownDemandDetail();
		PageReference oPageReference5 = oContentController.DisplayPlanAndUsageDetail();
		PageReference oPageReference6 = oContentController.DisplayTotalDetail();
	
	    ContentController.PlanMatchDBS pmd = new ContentController.PlanMatchDBS();
	    pmd.dbs = 'ten';
        pmd.dbsdescription ='Test';
        pmd.inplan =true;
        pmd.inplantrans = 12;
        pmd.ancillarytrans = 123;
        pmd.wsdtrans = 12312;
        
        ContentController.UnmappedDBS umd = new ContentController.UnmappedDBS();
	    umd.dbs = 'ten';
        umd.dbsdescription ='Test';
        umd.inplan =true;
        umd.inplantrans = 12;
        umd.ancillarytrans = 123;
        umd.wsdtrans = 12312;
        
        ContentController.ExcessDBS ed = new ContentController.ExcessDBS();
	    ed.dbs = 'ten';
        ed.dbsdescription ='Test';
        ed.inplan =true;
        ed.inplantrans = 12;
        ed.ancillarytrans = 123;
        ed.wsdtrans = 12312;
        
        ContentController.MatchItem mi = new ContentController.MatchItem();
	    mi.dbs = 'ten';
        mi.dbsdescription ='Test';
        mi.inplan = 'true';
        mi.inplantrans = 12;
        mi.ancillarytrans = 123;
        mi.wsdtrans = 12312;
		test.stopTest();
		
		
		//validate test
	}
	
	private static testmethod void test2DisplayPlanDetail1(){
		//setup
		
		Account oAccount = UnitTest.getAccountInstance();
		//oAccount.SAPAccountNumber__c = 'u000000139';
				//oAccount.SAPAccountNumber__c = '139';
		insert oAccount;
		
		PageReference oPageReference = Page.PlanMatch;
		
		oPageReference.getParameters().put('Id',oAccount.Id);
		
		
		Test.setCurrentPageReference(oPageReference);
		apexPages.StandardController oStandardController = new apexPages.StandardController(oAccount);
		
		ContentOptimizerServiceWS.Customer outputCustomer = new ContentOptimizerServiceWS.Customer();
		outputCustomer.AddrStateCode = 'NY';
		outputCustomer.ZwAcctSapId = 1000000139;

		UnitTest.MockWebServiceResponse.put(ContentOptimizerService.MockCalloutGetCustomer,outputCustomer);
		
		oPageReference.getParameters().put('SAP','1000000139');
		
		ContentOptimizerServiceWS.MaterialContent outputMaterialContent = new ContentOptimizerServiceWS.MaterialContent();
		
		outputMaterialContent.AcctSapId = 1000000139;

				outputMaterialContent.PrimaryMaterials = new List<ContentOptimizerServiceWS.MaterialItem>();
		for (integer i=0; i<20; i++) {    
			ContentOptimizerServiceWS.MaterialItem oMatch = new ContentOptimizerServiceWS.MaterialItem();  
		    oMatch.materialnumber = i;    
		 	oMatch.MaterialDesc = 'SAP-' + i;    
		 	oMatch.listprice = i + 100;          
		  	outputMaterialcontent.PrimaryMaterials.add(oMatch);
		}
		  
		outputMaterialContent.PublicMaterials = new List<ContentOptimizerServiceWS.MaterialItem>();
		for (integer i=0; i<20; i++) {    
			ContentOptimizerServiceWS.MaterialItem oMatch = new ContentOptimizerServiceWS.MaterialItem();  
		    oMatch.materialnumber = i;    
		 	oMatch.MaterialDesc = 'SAP-' + i;    
		 	oMatch.listprice = i + 100;          
		  	outputMaterialcontent.PublicMaterials.add(oMatch);
		}
	
		outputMaterialContent.OtherMaterials = new List<ContentOptimizerServiceWS.MaterialItem>();
		for (integer i=0; i<20; i++) {    
			ContentOptimizerServiceWS.MaterialItem oMatch = new ContentOptimizerServiceWS.MaterialItem();  
		    oMatch.materialnumber = i;    
		 	oMatch.MaterialDesc = 'SAP-' + i;    
		 	oMatch.listprice = i + 100;          
		  	outputMaterialcontent.OtherMaterials.add(oMatch);
		}	
			  
		UnitTest.MockWebServiceResponse.put(ContentOptimizerService.MockCalloutCalculateMatch,outputMaterialContent);
		
		
		//execute test
		test.startTest();
		
		ContentController oContentController = New ContentController(oStandardController);	
		
		oContentController.lazyLoadPlanMatch();
		PageReference oPageReference2 = oContentController.DisplayPlanDetail1();
		//oContentController.lazyLoadUsageMatch();
		//oContentController.lazyLoadKnownMatch();
		//oContentController.lazyLoadPlanUsageMatch();
		//oContentController.lazyLoadTotalMatch();
		
			
		test.stopTest();
		
		
		//validate test
	}
	private static testmethod void testDisplayUsageDetail(){
		//setup
		
		Account oAccount = UnitTest.getAccountInstance();
		//oAccount.SAPAccountNumber__c = 'u000000139';
				//oAccount.SAPAccountNumber__c = '139';
		insert oAccount;
		
		PageReference oPageReference = Page.PlanMatch;
		
		oPageReference.getParameters().put('Id',oAccount.Id);
		
		
		Test.setCurrentPageReference(oPageReference);
		apexPages.StandardController oStandardController = new apexPages.StandardController(oAccount);
		
		ContentOptimizerServiceWS.Customer outputCustomer = new ContentOptimizerServiceWS.Customer();
		outputCustomer.AddrStateCode = 'NY';
		outputCustomer.ZwAcctSapId = 1000000139;

		UnitTest.MockWebServiceResponse.put(ContentOptimizerService.MockCalloutGetCustomer,outputCustomer);
		
		oPageReference.getParameters().put('SAP','1000000139');
		
		ContentOptimizerServiceWS.MaterialContent outputMaterialContent = new ContentOptimizerServiceWS.MaterialContent();
		
		outputMaterialContent.AcctSapId = 1000000139;

				outputMaterialContent.PrimaryMaterials = new List<ContentOptimizerServiceWS.MaterialItem>();
		for (integer i=0; i<20; i++) {    
			ContentOptimizerServiceWS.MaterialItem oMatch = new ContentOptimizerServiceWS.MaterialItem();  
		    oMatch.materialnumber = i;    
		 	oMatch.MaterialDesc = 'SAP-' + i;    
		 	oMatch.listprice = i + 100;          
		  	outputMaterialcontent.PrimaryMaterials.add(oMatch);
		}
		  
		outputMaterialContent.PublicMaterials = new List<ContentOptimizerServiceWS.MaterialItem>();
		for (integer i=0; i<20; i++) {    
			ContentOptimizerServiceWS.MaterialItem oMatch = new ContentOptimizerServiceWS.MaterialItem();  
		    oMatch.materialnumber = i;    
		 	oMatch.MaterialDesc = 'SAP-' + i;    
		 	oMatch.listprice = i + 100;          
		  	outputMaterialcontent.PublicMaterials.add(oMatch);
		}
	
		outputMaterialContent.OtherMaterials = new List<ContentOptimizerServiceWS.MaterialItem>();
		for (integer i=0; i<20; i++) {    
			ContentOptimizerServiceWS.MaterialItem oMatch = new ContentOptimizerServiceWS.MaterialItem();  
		    oMatch.materialnumber = i;    
		 	oMatch.MaterialDesc = 'SAP-' + i;    
		 	oMatch.listprice = i + 100;          
		  	outputMaterialcontent.OtherMaterials.add(oMatch);
		}	
			  
		UnitTest.MockWebServiceResponse.put(ContentOptimizerService.MockCalloutCalculateMatch,outputMaterialContent);
		
		
		//execute test
		test.startTest();
		
		ContentController oContentController = New ContentController(oStandardController);	
		
		//oContentController.lazyLoadPlanMatch();
		
		oContentController.lazyLoadUsageMatch();
		PageReference oPageReference2 = oContentController.DisplayUsageDetail();
		//oContentController.lazyLoadKnownMatch();
		//oContentController.lazyLoadPlanUsageMatch();
		//oContentController.lazyLoadTotalMatch();
		
			
		test.stopTest();
		
		
		//validate test
	}
	private static testmethod void testDisplayKnownDemandDetail(){
		//setup
		
		Account oAccount = UnitTest.getAccountInstance();
		//oAccount.SAPAccountNumber__c = 'u000000139';
				//oAccount.SAPAccountNumber__c = '139';
		insert oAccount;
		
		PageReference oPageReference = Page.PlanMatch;
		
		oPageReference.getParameters().put('Id',oAccount.Id);
		
		
		Test.setCurrentPageReference(oPageReference);
		apexPages.StandardController oStandardController = new apexPages.StandardController(oAccount);
		
		ContentOptimizerServiceWS.Customer outputCustomer = new ContentOptimizerServiceWS.Customer();
		outputCustomer.AddrStateCode = 'NY';
		outputCustomer.ZwAcctSapId = 1000000139;

		UnitTest.MockWebServiceResponse.put(ContentOptimizerService.MockCalloutGetCustomer,outputCustomer);
		
		oPageReference.getParameters().put('SAP','1000000139');
		
		ContentOptimizerServiceWS.MaterialContent outputMaterialContent = new ContentOptimizerServiceWS.MaterialContent();
		
		outputMaterialContent.AcctSapId = 1000000139;

				outputMaterialContent.PrimaryMaterials = new List<ContentOptimizerServiceWS.MaterialItem>();
		for (integer i=0; i<20; i++) {    
			ContentOptimizerServiceWS.MaterialItem oMatch = new ContentOptimizerServiceWS.MaterialItem();  
		    oMatch.materialnumber = i;    
		 	oMatch.MaterialDesc = 'SAP-' + i;    
		 	oMatch.listprice = i + 100;          
		  	outputMaterialcontent.PrimaryMaterials.add(oMatch);
		}
		  
		outputMaterialContent.PublicMaterials = new List<ContentOptimizerServiceWS.MaterialItem>();
		for (integer i=0; i<20; i++) {    
			ContentOptimizerServiceWS.MaterialItem oMatch = new ContentOptimizerServiceWS.MaterialItem();  
		    oMatch.materialnumber = i;    
		 	oMatch.MaterialDesc = 'SAP-' + i;    
		 	oMatch.listprice = i + 100;          
		  	outputMaterialcontent.PublicMaterials.add(oMatch);
		}
	
		outputMaterialContent.OtherMaterials = new List<ContentOptimizerServiceWS.MaterialItem>();
		for (integer i=0; i<20; i++) {    
			ContentOptimizerServiceWS.MaterialItem oMatch = new ContentOptimizerServiceWS.MaterialItem();  
		    oMatch.materialnumber = i;    
		 	oMatch.MaterialDesc = 'SAP-' + i;    
		 	oMatch.listprice = i + 100;          
		  	outputMaterialcontent.OtherMaterials.add(oMatch);
		}	
			  
		UnitTest.MockWebServiceResponse.put(ContentOptimizerService.MockCalloutCalculateMatch,outputMaterialContent);
		
		
		//execute test
		test.startTest();
		
		ContentController oContentController = New ContentController(oStandardController);	
		
		//oContentController.lazyLoadPlanMatch();
		
		//oContentController.lazyLoadUsageMatch();
		oContentController.lazyLoadKnownMatch();
		PageReference oPageReference2 = oContentController.DisplayKnownDemandDetail();
		
		//oContentController.lazyLoadPlanUsageMatch();
		//oContentController.lazyLoadTotalMatch();
		
			
		test.stopTest();
		
		
		//validate test
	}	
	private static testmethod void testDisplayPlanAndUsageDetail(){
		//setup
		
		Account oAccount = UnitTest.getAccountInstance();
		//oAccount.SAPAccountNumber__c = 'u000000139';
				//oAccount.SAPAccountNumber__c = '139';
		insert oAccount;
		
		PageReference oPageReference = Page.PlanMatch;
		
		oPageReference.getParameters().put('Id',oAccount.Id);
		
		
		Test.setCurrentPageReference(oPageReference);
		apexPages.StandardController oStandardController = new apexPages.StandardController(oAccount);
		
		ContentOptimizerServiceWS.Customer outputCustomer = new ContentOptimizerServiceWS.Customer();
		outputCustomer.AddrStateCode = 'NY';
		outputCustomer.ZwAcctSapId = 1000000139;

		UnitTest.MockWebServiceResponse.put(ContentOptimizerService.MockCalloutGetCustomer,outputCustomer);
		
		oPageReference.getParameters().put('SAP','1000000139');
		
		ContentOptimizerServiceWS.MaterialContent outputMaterialContent = new ContentOptimizerServiceWS.MaterialContent();
		
		outputMaterialContent.AcctSapId = 1000000139;

				outputMaterialContent.PrimaryMaterials = new List<ContentOptimizerServiceWS.MaterialItem>();
		for (integer i=0; i<20; i++) {    
			ContentOptimizerServiceWS.MaterialItem oMatch = new ContentOptimizerServiceWS.MaterialItem();  
		    oMatch.materialnumber = i;    
		 	oMatch.MaterialDesc = 'SAP-' + i;    
		 	oMatch.listprice = i + 100;          
		  	outputMaterialcontent.PrimaryMaterials.add(oMatch);
		}
		  
		outputMaterialContent.PublicMaterials = new List<ContentOptimizerServiceWS.MaterialItem>();
		for (integer i=0; i<20; i++) {    
			ContentOptimizerServiceWS.MaterialItem oMatch = new ContentOptimizerServiceWS.MaterialItem();  
		    oMatch.materialnumber = i;    
		 	oMatch.MaterialDesc = 'SAP-' + i;    
		 	oMatch.listprice = i + 100;          
		  	outputMaterialcontent.PublicMaterials.add(oMatch);
		}
	
		outputMaterialContent.OtherMaterials = new List<ContentOptimizerServiceWS.MaterialItem>();
		for (integer i=0; i<20; i++) {    
			ContentOptimizerServiceWS.MaterialItem oMatch = new ContentOptimizerServiceWS.MaterialItem();  
		    oMatch.materialnumber = i;    
		 	oMatch.MaterialDesc = 'SAP-' + i;    
		 	oMatch.listprice = i + 100;          
		  	outputMaterialcontent.OtherMaterials.add(oMatch);
		}	
			  
		UnitTest.MockWebServiceResponse.put(ContentOptimizerService.MockCalloutCalculateMatch,outputMaterialContent);
		
		
		//execute test
		test.startTest();
		
		ContentController oContentController = New ContentController(oStandardController);	
		
		//oContentController.lazyLoadPlanMatch();
		
		//oContentController.lazyLoadUsageMatch();
		//oContentController.lazyLoadKnownMatch();
		oContentController.lazyLoadPlanUsageMatch();
		PageReference oPageReference2 = oContentController.DisplayPlanAndUsageDetail();
		
		
		//oContentController.lazyLoadTotalMatch();
		
			
		test.stopTest();
		
		
		//validate test
	}
	private static testmethod void testDisplayTotalDetail(){
		//setup
		
		Account oAccount = UnitTest.getAccountInstance();
		//oAccount.SAPAccountNumber__c = 'u000000139';
				//oAccount.SAPAccountNumber__c = '139';
		insert oAccount;
		
		PageReference oPageReference = Page.PlanMatch;
		
		oPageReference.getParameters().put('Id',oAccount.Id);
		
		
		Test.setCurrentPageReference(oPageReference);
		apexPages.StandardController oStandardController = new apexPages.StandardController(oAccount);
		
		ContentOptimizerServiceWS.Customer outputCustomer = new ContentOptimizerServiceWS.Customer();
		outputCustomer.AddrStateCode = 'NY';
		outputCustomer.ZwAcctSapId = 1000000139;

		UnitTest.MockWebServiceResponse.put(ContentOptimizerService.MockCalloutGetCustomer,outputCustomer);
		
		oPageReference.getParameters().put('SAP','1000000139');
		
		ContentOptimizerServiceWS.MaterialContent outputMaterialContent = new ContentOptimizerServiceWS.MaterialContent();
		
		outputMaterialContent.AcctSapId = 1000000139;

				outputMaterialContent.PrimaryMaterials = new List<ContentOptimizerServiceWS.MaterialItem>();
		for (integer i=0; i<20; i++) {    
			ContentOptimizerServiceWS.MaterialItem oMatch = new ContentOptimizerServiceWS.MaterialItem();  
		    oMatch.materialnumber = i;    
		 	oMatch.MaterialDesc = 'SAP-' + i;    
		 	oMatch.listprice = i + 100;          
		  	outputMaterialcontent.PrimaryMaterials.add(oMatch);
		}
		  
		outputMaterialContent.PublicMaterials = new List<ContentOptimizerServiceWS.MaterialItem>();
		for (integer i=0; i<20; i++) {    
			ContentOptimizerServiceWS.MaterialItem oMatch = new ContentOptimizerServiceWS.MaterialItem();  
		    oMatch.materialnumber = i;    
		 	oMatch.MaterialDesc = 'SAP-' + i;    
		 	oMatch.listprice = i + 100;          
		  	outputMaterialcontent.PublicMaterials.add(oMatch);
		}
	
		outputMaterialContent.OtherMaterials = new List<ContentOptimizerServiceWS.MaterialItem>();
		for (integer i=0; i<20; i++) {    
			ContentOptimizerServiceWS.MaterialItem oMatch = new ContentOptimizerServiceWS.MaterialItem();  
		    oMatch.materialnumber = i;    
		 	oMatch.MaterialDesc = 'SAP-' + i;    
		 	oMatch.listprice = i + 100;          
		  	outputMaterialcontent.OtherMaterials.add(oMatch);
		}	
			  
		UnitTest.MockWebServiceResponse.put(ContentOptimizerService.MockCalloutCalculateMatch,outputMaterialContent);
		
		
		//execute test
		test.startTest();
		
		ContentController oContentController = New ContentController(oStandardController);	
		
		//oContentController.lazyLoadPlanMatch();
		
		//oContentController.lazyLoadUsageMatch();
		//oContentController.lazyLoadKnownMatch();
		//oContentController.lazyLoadPlanUsageMatch();
		oContentController.lazyLoadTotalMatch();
		PageReference oPageReference2 = oContentController.DisplayTotalDetail();
		
		
		
		
			
		test.stopTest();
		
		
		//validate test
	}	
}