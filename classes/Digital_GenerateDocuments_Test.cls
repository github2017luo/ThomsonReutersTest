/**
 * Test class for testing Digital_GenerateDocuments.  The Digital_GenerateDocuments class is a schedulable job that
 * attaches the order form to digital quote/proposals to complete the automated renewal creation process.  
 */
/**
 * CHANGE HISTORY
 * =============================================================================
 * Date         Name                    Description
 * 2017-06-01   Brenda Shields          Created
 * 2019-05-13   Navleen Kaur            Removing one method as created new test class for Digital_WS_GenerateDocument as part of DLT-16389
 * 2020-08-27   Rahul Natarajan       DLT-20631 - [SFDC] [REN] Critical Code scan issue`   
 * =============================================================================
 */
@istest
private class Digital_GenerateDocuments_Test {

	static testmethod void testEnvelopeCreation() {
		Map<String, Schema.RecordTypeInfo > recordTypes = Opportunity.sObjectType.getDescribe().getRecordTypeInfosByName();
		Id optyPipeRecTypeId = recordTypes.get('Pipeline Opportunity').getRecordTypeId();
		Id optyPreRecTypeID = recordTypes.get('Pre-Pipeline Opportunity').getRecordTypeId();
		Profile p1 = [SELECT Id FROM Profile WHERE Name = 'ANZ Users'];

		WebServiceSettings__c wc = new WebServiceSettings__c();
		wc.Name = 'Digital_GenerateDoc_SignIn_Creds';
		wc.Active__c = TRUE;
		wc.Username__c = 'test';
		wc.Password__c = 'test';
		wc.Endpoint__c = 'test';
		wc.Timeout__c = 3000;
		wc.Service_Unavailable_Message__c = 'test';
		insert wc;

		KeyValueListStore__C keyCustomSetting = new KeyValueListStore__c(Name = 'ANZUsersProfileId', TextValue__c = p1.id);
		insert keyCustomSetting;

		// DLT-20631  - Removed Hardcoded ID
		List<RecordtypeIds__c > recTList = new List<RecordtypeIds__c > ();
		RecordtypeIds__c recT = new RecordtypeIds__c();
		recT.name = 'Pre-Pipeline Opportunities';
		recT.recTypeId__C = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Pre-Pipeline Opportunity').getRecordTypeId();
		recTList.add(recT);

		RecordtypeIds__c recT1 = new RecordtypeIds__c();
		recT1.Name = 'Pipeline Opportunities';
		recT1.recTypeId__C = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Pipeline Opportunity').getRecordTypeId();
		recTList.add(recT1);
		insert recTList;

		Account acc = New Account();
		acc = UnitTest.getAccountInstance();
		insert acc;

		Contact testcontact = UnitTest.getContactInstance(Acc.Id);
		testcontact.LastName = 'testContact';
		testcontact.FirstName = 'testContact';
		testcontact.AccountId = acc.Id;
		testcontact.email = 'testfirst.testlast@thomson.com';
		insert testcontact;

		list<Opportunity> oppList = new list<Opportunity> ();

		Opportunity opp1 = new Opportunity();
		opp1 = UnitTest.getOpportunityInstance(acc.id);
		opp1.isdigitalSpearhead__c = TRUE;
		opp1.CloseDate = System.Today() + 30;
		opp1.StageName = '10%';
		opp1.Renewal_Date__c = System.Today() + 1;
		opp1.Status__c = 'Converted';
		opp1.RecordTypeId = optyPipeRecTypeId;
		opp1.isDigitalSpearHead__c = TRUE;
		oppList.add(opp1);

		Opportunity opp2 = new Opportunity();
		opp2 = UnitTest.getOpportunityInstance(acc.id);
		opp2.isdigitalSpearhead__c = TRUE;
		opp2.CloseDate = System.Today() + 30;
		opp2.StageName = '10%';
		opp2.Renewal_Date__c = System.Today() - 1;
		opp2.Status__c = 'Converted';
		opp2.RecordTypeId = optyPipeRecTypeId;
		opp2.isDigitalSpearHead__c = TRUE;
		oppList.add(opp2);

		Opportunity opp3 = new Opportunity();
		opp3 = UnitTest.getOpportunityInstance(acc.id);
		opp3.isdigitalSpearhead__c = TRUE;
		opp3.CloseDate = System.Today() + 30;
		opp3.StageName = '10%';
		opp3.Renewal_Date__c = System.Today();
		opp3.RecordTypeId = optyPipeRecTypeId;
		opp3.Status__c = 'Converted';
		opp3.isDigitalSpearHead__c = TRUE;
		oppList.add(opp3);

		insert oppList;

		List<Apttus_Proposal__Proposal__c > quoteList = new list<Apttus_Proposal__Proposal__c > ();

		Apttus_Proposal__Proposal__c q1 = new Apttus_Proposal__Proposal__c();
		q1.Apttus_Proposal__Proposal_Name__c = 'Quote 1';
		q1.Apttus_Proposal__Opportunity__c = oppList[0].id;
		q1.Apttus_Proposal__Account__c = acc.id;
		q1.Apttus_QPConfig__BillToAccountId__c = acc.id;
		q1.Apttus_QPConfig__ShipToAccountId__c = acc.id;
		q1.Apttus_Proposal__Approval_Stage__c = 'Draft';
		q1.APTS_Order_Confirmation_Contact__c = testcontact.id;
		q1.Apttus_Proposal__ReadyToGenerate__c = TRUE;
		q1.Apttus_Proposal__Primary__c = true;
		q1.APTS_Proposal_Business_Unit__c = 'Findlaw';
		quoteList.add(q1);

		Apttus_Proposal__Proposal__c q2 = new Apttus_Proposal__Proposal__c();
		q2.Apttus_Proposal__Proposal_Name__c = 'Quote 2';
		q2.Apttus_Proposal__Opportunity__c = oppList[0].id;
		q2.Apttus_Proposal__Account__c = acc.id;
		q2.Apttus_QPConfig__BillToAccountId__c = acc.id;
		q2.Apttus_QPConfig__ShipToAccountId__c = acc.id;
		q2.Apttus_Proposal__Approval_Stage__c = 'Draft';
		q2.APTS_Order_Confirmation_Contact__c = testcontact.id;
		q2.Apttus_Proposal__ReadyToGenerate__c = TRUE;
		q2.Apttus_Proposal__Primary__c = true;
		q2.APTS_Proposal_Business_Unit__c = 'Findlaw';
		quoteList.add(q2);
		insert quoteList;

		// create new cart
		list<Apttus_Config2__ProductConfiguration__c > cartList = new list<Apttus_Config2__ProductConfiguration__c > ();
		Apttus_Config2__ProductConfiguration__c newCart1 = new Apttus_Config2__ProductConfiguration__c();
		newCart1.Apttus_QPConfig__Proposald__c = quoteList[0].Id;
		newCart1.Apttus_Config2__Status__c = 'Finalized';
		cartList.add(newCart1);
		insert cartList;

		Apttus_Proposal__Proposal_Line_Item__c line = new Apttus_Proposal__Proposal_Line_Item__c();
		line.Apttus_Proposal__Proposal__c = quoteList[0].id;
		insert line;

		// create template - need more data than this
		Apttus__APTS_Template__c newTemplate = new Apttus__APTS_Template__c();
		newTemplate.Name = System.Label.Digital_OF;
		newTemplate.Apttus__IsActive__c = TRUE;
		newTemplate.Apttus__Type__c = 'Proposal';
		newTemplate.Apttus__ReferenceId__c = '0db18264-424c-a7fa-5058-680a594f5189';
		newTemplate.Apttus__Agreement_Types__c = 'Default;Proposal;RFP';
		newTemplate.Apttus__FrameworkFormat__c = 'FX2';
		Insert newTemplate;

		// create template - need more data than this
		Apttus__APTS_Template__c newFLTemplate = new Apttus__APTS_Template__c();
		newFLTemplate.Name = System.Label.Digital_FOF;
		newFLTemplate.Apttus__IsActive__c = TRUE;
		newFLTemplate.Apttus__Type__c = 'Proposal';
		newFLTemplate.Apttus__ReferenceId__c = '0db18264-424c-a7fa-5058-680a594f5189';
		newFLTemplate.Apttus__Agreement_Types__c = 'Default;Proposal;RFP';
		newFLTemplate.Apttus__FrameworkFormat__c = 'FX2';
		Insert newFLTemplate;

		Digital_MasterContactsBatch dmc = new Digital_MasterContactsBatch();
		database.executebatch(dmc, 1);

		// Set mock callout class for Envelope response
		Test.setMock(HttpCalloutMock.class, new HttpResponseMock.documentCreationSuccess());

		Test.startTest();
		Digital_GenerateDocumentsBatch dg = new Digital_GenerateDocumentsBatch();
		database.executebatch(dg, 1);
		Test.stopTest();
	}

/*	static testmethod void testDocumentCreationFailure() {
		Map<String, Schema.RecordTypeInfo > recordTypes = Opportunity.sObjectType.getDescribe().getRecordTypeInfosByName();
		Id optyPipeRecTypeId = recordTypes.get('Pipeline Opportunity').getRecordTypeId();
		Id optyPreRecTypeID = recordTypes.get('Pre-Pipeline Opportunity').getRecordTypeId();
		Profile p1 = [SELECT Id FROM Profile WHERE Name = 'ANZ Users'];

		WebServiceSettings__c wc = new WebServiceSettings__c();
		wc.Name = 'Digital_GenerateDoc_SignIn_Creds';
		wc.Active__c = TRUE;
		wc.Username__c = 'test';
		wc.Password__c = 'test';
		wc.Endpoint__c = 'test';
		wc.Timeout__c = 3000;
		wc.Service_Unavailable_Message__c = 'test';
		insert wc;

		KeyValueListStore__C keyCustomSetting = new KeyValueListStore__c(Name = 'ANZUsersProfileId', TextValue__c = p1.id);
		insert keyCustomSetting;

		// DLT-20631  - Removed Hardcoded ID
		List<RecordtypeIds__c > recTList = new List<RecordtypeIds__c > ();
		RecordtypeIds__c recT = new RecordtypeIds__c();
		recT.name = 'Pre-Pipeline Opportunities';
		recT.recTypeId__C = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Pre-Pipeline Opportunity').getRecordTypeId();
		recTList.add(recT);

		RecordtypeIds__c recT1 = new RecordtypeIds__c();
		recT1.Name = 'Pipeline Opportunities';
		recT1.recTypeId__C = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Pipeline Opportunity').getRecordTypeId();
		recTList.add(recT1);
		insert recTList;

		Account acc = New Account();
		acc = UnitTest.getAccountInstance();
		insert acc;

		Contact testcontact = UnitTest.getContactInstance(Acc.Id);
		testcontact.LastName = 'testContact';
		testcontact.FirstName = 'testContact';
		testcontact.AccountId = acc.Id;
		testcontact.email = 'testfirst.testlast@thomson.com';
		insert testcontact;

		list<Opportunity> oppList = new list<Opportunity> ();

		Opportunity opp1 = new Opportunity();
		opp1 = UnitTest.getOpportunityInstance(acc.id);
		opp1.isdigitalSpearhead__c = TRUE;
		opp1.CloseDate = System.Today() + 30;
		opp1.StageName = '10%';
		opp1.Renewal_Date__c = System.Today() + 1;
		opp1.Status__c = 'Converted';
		opp1.RecordTypeId = optyPipeRecTypeId;
		opp1.isDigitalSpearHead__c = TRUE;
		oppList.add(opp1);

		Opportunity opp2 = new Opportunity();
		opp2 = UnitTest.getOpportunityInstance(acc.id);
		opp2.isdigitalSpearhead__c = TRUE;
		opp2.CloseDate = System.Today() + 30;
		opp2.StageName = '10%';
		opp2.Renewal_Date__c = System.Today() - 1;
		opp2.Status__c = 'Converted';
		opp2.RecordTypeId = optyPipeRecTypeId;
		opp2.isDigitalSpearHead__c = TRUE;
		oppList.add(opp2);

		Opportunity opp3 = new Opportunity();
		opp3 = UnitTest.getOpportunityInstance(acc.id);
		opp3.isdigitalSpearhead__c = TRUE;
		opp3.CloseDate = System.Today() + 30;
		opp3.StageName = '10%';
		opp3.Renewal_Date__c = System.Today();
		opp3.RecordTypeId = optyPipeRecTypeId;
		opp3.Status__c = 'Converted';
		opp3.isDigitalSpearHead__c = TRUE;
		oppList.add(opp3);

		insert oppList;

		List<Apttus_Proposal__Proposal__c > quoteList = new list<Apttus_Proposal__Proposal__c > ();

		Apttus_Proposal__Proposal__c q1 = new Apttus_Proposal__Proposal__c();
		q1.Apttus_Proposal__Proposal_Name__c = 'Quote 1';
		q1.Apttus_Proposal__Opportunity__c = oppList[0].id;
		q1.Apttus_Proposal__Account__c = acc.id;
		q1.Apttus_QPConfig__BillToAccountId__c = acc.id;
		q1.Apttus_QPConfig__ShipToAccountId__c = acc.id;
		q1.Apttus_Proposal__Approval_Stage__c = 'Draft';
		q1.APTS_Order_Confirmation_Contact__c = testcontact.id;
		q1.Apttus_Proposal__ReadyToGenerate__c = TRUE;
		q1.Apttus_Proposal__Primary__c = true;
		q1.APTS_Proposal_Business_Unit__c = 'SCS';
		quoteList.add(q1);

		Apttus_Proposal__Proposal__c q2 = new Apttus_Proposal__Proposal__c();
		q2.Apttus_Proposal__Proposal_Name__c = 'Quote 2';
		q2.Apttus_Proposal__Opportunity__c = oppList[0].id;
		q2.Apttus_Proposal__Account__c = acc.id;
		q2.Apttus_QPConfig__BillToAccountId__c = acc.id;
		q2.Apttus_QPConfig__ShipToAccountId__c = acc.id;
		q2.Apttus_Proposal__Approval_Stage__c = 'Draft';
		q2.APTS_Order_Confirmation_Contact__c = testcontact.id;
		q2.Apttus_Proposal__ReadyToGenerate__c = TRUE;
		q2.Apttus_Proposal__Primary__c = true;
		q2.APTS_Proposal_Business_Unit__c = 'SCS';
		quoteList.add(q2);
		insert quoteList;

		// create new cart
		list<Apttus_Config2__ProductConfiguration__c > cartList = new list<Apttus_Config2__ProductConfiguration__c > ();
		Apttus_Config2__ProductConfiguration__c newCart1 = new Apttus_Config2__ProductConfiguration__c();
		newCart1.Apttus_QPConfig__Proposald__c = quoteList[0].Id;
		newCart1.Apttus_Config2__Status__c = 'Finalized';
		cartList.add(newCart1);
		insert cartList;

		Apttus_Proposal__Proposal_Line_Item__c line = new Apttus_Proposal__Proposal_Line_Item__c();
		line.Apttus_Proposal__Proposal__c = quoteList[0].id;
		insert line;

		// create template - need more data than this
		Apttus__APTS_Template__c newTemplate = new Apttus__APTS_Template__c();
		newTemplate.Name = System.Label.Digital_OF;
		newTemplate.Apttus__IsActive__c = TRUE;
		newTemplate.Apttus__Type__c = 'Proposal';
		newTemplate.Apttus__ReferenceId__c = '0db18264-424c-a7fa-5058-680a594f5189';
		newTemplate.Apttus__Agreement_Types__c = 'Default;Proposal;RFP';
		newTemplate.Apttus__FrameworkFormat__c = 'FX2';
		Insert newTemplate;

		Digital_MasterContactsBatch dmc = new Digital_MasterContactsBatch();
		database.executebatch(dmc, 1);

		// Set mock callout class for Envelope response
		Test.setMock(HttpCalloutMock.class, new HttpResponseMock.documentCreationFailure());

		Test.startTest();
		Digital_GenerateDocumentsBatch dg = new Digital_GenerateDocumentsBatch();
		database.executebatch(dg, 1);
		Digital_GenerateDocumentsBatch.createExceptionLog('', '', '', '', '', '');
		Test.stopTest();
	} */

	static testmethod void testEnvelopeCreation2() {
		Map<String, Schema.RecordTypeInfo > recordTypes = Opportunity.sObjectType.getDescribe().getRecordTypeInfosByName();
		Id optyPipeRecTypeId = recordTypes.get('Pipeline Opportunity').getRecordTypeId();
		Id optyPreRecTypeID = recordTypes.get('Pre-Pipeline Opportunity').getRecordTypeId();
		Profile p1 = [SELECT Id FROM Profile WHERE Name = 'ANZ Users'];

		WebServiceSettings__c wc = new WebServiceSettings__c();
		wc.Name = 'Digital_GenerateDoc_SignIn_CredsXXX';
		wc.Active__c = FALSE;
		wc.Username__c = 'test';
		wc.Password__c = 'test';
		wc.Endpoint__c = 'test';
		wc.Timeout__c = 3000;
		wc.Service_Unavailable_Message__c = 'test';
		insert wc;

		KeyValueListStore__C keyCustomSetting = new KeyValueListStore__c(Name = 'ANZUsersProfileId', TextValue__c = p1.id);
		insert keyCustomSetting;

		// DLT-20631  - Removed Hardcoded ID
		List<RecordtypeIds__c > recTList = new List<RecordtypeIds__c > ();
		RecordtypeIds__c recT = new RecordtypeIds__c();
		recT.name = 'Pre-Pipeline Opportunities';
		recT.recTypeId__C = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Pre-Pipeline Opportunity').getRecordTypeId();
		recTList.add(recT);

		RecordtypeIds__c recT1 = new RecordtypeIds__c();
		recT1.Name = 'Pipeline Opportunities';
		recT1.recTypeId__C = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Pipeline Opportunity').getRecordTypeId();
		recTList.add(recT1);
		insert recTList;

		Account acc = New Account();
		acc = UnitTest.getAccountInstance();
		insert acc;

		Contact testcontact = UnitTest.getContactInstance(Acc.Id);
		testcontact.LastName = 'testContact';
		testcontact.FirstName = 'testContact';
		testcontact.AccountId = acc.Id;
		testcontact.email = 'testfirst.testlast@thomson.com';
		insert testcontact;

		list<Opportunity> oppList = new list<Opportunity> ();

		Opportunity opp1 = new Opportunity();
		opp1 = UnitTest.getOpportunityInstance(acc.id);
		opp1.isdigitalSpearhead__c = TRUE;
		opp1.CloseDate = System.Today() + 30;
		opp1.StageName = '10%';
		opp1.Renewal_Date__c = System.Today() + 1;
		opp1.Status__c = 'Converted';
		opp1.RecordTypeId = optyPipeRecTypeId;
		opp1.isDigitalSpearHead__c = TRUE;
		oppList.add(opp1);

		Opportunity opp2 = new Opportunity();
		opp2 = UnitTest.getOpportunityInstance(acc.id);
		opp2.isdigitalSpearhead__c = TRUE;
		opp2.CloseDate = System.Today() + 30;
		opp2.StageName = '10%';
		opp2.Renewal_Date__c = System.Today() - 1;
		opp2.Status__c = 'Converted';
		opp2.RecordTypeId = optyPipeRecTypeId;
		opp2.isDigitalSpearHead__c = TRUE;
		oppList.add(opp2);

		Opportunity opp3 = new Opportunity();
		opp3 = UnitTest.getOpportunityInstance(acc.id);
		opp3.isdigitalSpearhead__c = TRUE;
		opp3.CloseDate = System.Today() + 30;
		opp3.StageName = '10%';
		opp3.Renewal_Date__c = System.Today();
		opp3.RecordTypeId = optyPipeRecTypeId;
		opp3.Status__c = 'Converted';
		opp3.isDigitalSpearHead__c = TRUE;
		oppList.add(opp3);

		insert oppList;

		List<Apttus_Proposal__Proposal__c > quoteList = new list<Apttus_Proposal__Proposal__c > ();

		Apttus_Proposal__Proposal__c q1 = new Apttus_Proposal__Proposal__c();
		q1.RecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Proposal').getRecordTypeId();
		q1.Apttus_Proposal__Proposal_Name__c = 'Quote 1';
		q1.Apttus_Proposal__Opportunity__c = oppList[0].id;
		q1.Apttus_Proposal__Account__c = acc.id;
		q1.Apttus_QPConfig__BillToAccountId__c = acc.id;
		q1.Apttus_QPConfig__ShipToAccountId__c = acc.id;
		q1.Apttus_Proposal__Approval_Stage__c = 'Draft';
		q1.APTS_Order_Confirmation_Contact__c = testcontact.id;
		q1.Apttus_Proposal__ReadyToGenerate__c = TRUE;
		q1.Apttus_Proposal__Primary__c = true;
		q1.APTS_Proposal_Business_Unit__c = 'SCS';
		q1.Contract_Type__c = 'Ineligible';
		q1.Digital_Quote_Type__c = 'Straight Renewal';
		q1.Digital_Batch_Processed__c = true;
		quoteList.add(q1);

		Apttus_Proposal__Proposal__c q2 = new Apttus_Proposal__Proposal__c();
		q2.RecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Proposal').getRecordTypeId();
		q2.Apttus_Proposal__Proposal_Name__c = 'Quote 2';
		q2.Apttus_Proposal__Opportunity__c = oppList[0].id;
		q2.Apttus_Proposal__Account__c = acc.id;
		q2.Apttus_QPConfig__BillToAccountId__c = acc.id;
		q2.Apttus_QPConfig__ShipToAccountId__c = acc.id;
		q2.Apttus_Proposal__Approval_Stage__c = 'Draft';
		q2.APTS_Order_Confirmation_Contact__c = testcontact.id;
		q2.Apttus_Proposal__ReadyToGenerate__c = TRUE;
		q2.Apttus_Proposal__Primary__c = true;
		q2.APTS_Proposal_Business_Unit__c = 'SCS';
		q2.Contract_Type__c = 'Ineligible';
		q2.Digital_Quote_Type__c = 'Straight Renewal';
		q2.Digital_Batch_Processed__c = true;
		quoteList.add(q2);
		insert quoteList;

		// create new cart
		list<Apttus_Config2__ProductConfiguration__c > cartList = new list<Apttus_Config2__ProductConfiguration__c > ();
		Apttus_Config2__ProductConfiguration__c newCart1 = new Apttus_Config2__ProductConfiguration__c();
		newCart1.Apttus_QPConfig__Proposald__c = quoteList[1].Id;
		newCart1.Apttus_Config2__Status__c = 'Finalized';
		cartList.add(newCart1);
		insert cartList;

		// create template - need more data than this
		Apttus__APTS_Template__c newTemplate = new Apttus__APTS_Template__c();
		newTemplate.Name = System.Label.Digital_OF;
		Insert newTemplate;

		Test.startTest();
		List<Apttus_Proposal__Proposal__c > prplist = new List<Apttus_Proposal__Proposal__c > ();
		prplist = [select id, Digital_Quote_Type__c, Contract_Type__c, Apttus_Proposal__Proposal_Name__c from Apttus_Proposal__Proposal__c where Digital_Quote_Type__c = 'Straight Renewal'
			and Contract_Type__c = 'Ineligible'
		];

		List<Apttus_Config2__ProductConfiguration__c > carprplist = new List<Apttus_Config2__ProductConfiguration__c > ();
		carprplist = [select id, Apttus_QPConfig__Proposald__c, Apttus_QPConfig__Proposald__r.Digital_Quote_Type__c, Apttus_QPConfig__Proposald__r.Contract_Type__c from Apttus_Config2__ProductConfiguration__c where(Apttus_QPConfig__Proposald__r.Apttus_Proposal__Opportunity__r.isDigitalSpearHead__c = TRUE AND Apttus_Config2__Status__c = 'Finalized'
			AND(Apttus_QPConfig__Proposald__r.Apttus_Proposal__Approval_Stage__c = 'Draft'
				OR Apttus_QPConfig__Proposald__r.Apttus_Proposal__Approval_Stage__c = 'Approved') AND Apttus_QPConfig__Proposald__r.APTS_Order_Confirmation_Contact__c != Null) Limit 10];
		system.debug('====' + prplist);
		system.debug('====' + carprplist);
		system.debug('====' + quoteList[0]);
		Digital_GenerateDocumentsBatch db = new Digital_GenerateDocumentsBatch();
		Id jobId = database.executebatch(db, 1);
		AsyncApexJob a = [Select Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email, ExtendedStatus from AsyncApexJob where Id =: jobId];
		if (a.Status == 'Completed') {
			System.abortJob(a.id);
		}
		Test.stopTest();
	}
}