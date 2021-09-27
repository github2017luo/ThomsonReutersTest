/*
 * CHANGE HISTORY
 * ==================================================================================================================================
 * Date         Name                  Description
 * 2019-05-10   Navleen Kaur          DLT-16389 - Find Law- AEM call to set Correct template for Findlaw to SFDC during Generate Document
 * 17-12-2020   Rahul Natarajan       DLT-21120 - [TECH][SFDC][REN][NSE] Update New OrderForm template for all Renewal and New Sales proposals
 * ==================================================================================================================================   
 */
@istest
public class Digital_WS_GenerateDocumentTest {
	@testsetup
	public static void testdata() {
		Test.startTest();
		DCTestData.createData();
		Test.stopTest();

		Opportunity opp = [select id from Opportunity Limit 1];
		Account acc = [select id from Account Limit 1];
		Contact con = [select id from Contact Limit 1];
		List<Apttus_Proposal__Proposal__c > quoteList = new list<Apttus_Proposal__Proposal__c > ();

		Apttus_Proposal__Proposal__c q1 = new Apttus_Proposal__Proposal__c();
		q1.Apttus_Proposal__Proposal_Name__c = 'Quote 1';
		q1.Apttus_Proposal__Opportunity__c = opp.id;
		q1.Apttus_Proposal__Account__c = acc.id;
		q1.Apttus_QPConfig__BillToAccountId__c = acc.id;
		q1.Apttus_QPConfig__ShipToAccountId__c = acc.id;
		q1.Apttus_Proposal__Approval_Stage__c = 'Draft';
		q1.APTS_Order_Confirmation_Contact__c = con.id;
		q1.Apttus_Proposal__ReadyToGenerate__c = TRUE;
		q1.APTS_Proposal_Business_Unit__c = 'FindLaw';
		q1.Apttus_Proposal__Primary__c = true;
		quoteList.add(q1);

		Apttus_Proposal__Proposal__c q2 = new Apttus_Proposal__Proposal__c();
		q2.Apttus_Proposal__Proposal_Name__c = 'Quote 2';
		q2.Apttus_Proposal__Opportunity__c = opp.id;
		q2.Apttus_Proposal__Account__c = acc.id;
		q2.Apttus_QPConfig__BillToAccountId__c = acc.id;
		q2.Apttus_QPConfig__ShipToAccountId__c = acc.id;
		q2.Apttus_Proposal__Approval_Stage__c = 'Draft';
		q2.APTS_Order_Confirmation_Contact__c = con.id;
		q2.Apttus_Proposal__ReadyToGenerate__c = TRUE;
		q2.APTS_Proposal_Business_Unit__c = 'SCS';
		q2.Apttus_Proposal__Primary__c = true;
		quoteList.add(q2);
		insert quoteList;

		// create new cart
		list<Apttus_Config2__ProductConfiguration__c > cartList = new list<Apttus_Config2__ProductConfiguration__c > ();
		Apttus_Config2__ProductConfiguration__c newCart1 = new Apttus_Config2__ProductConfiguration__c();
		newCart1.Apttus_QPConfig__Proposald__c = quoteList[0].Id;
		newCart1.Apttus_Config2__Status__c = 'Finalized';
		cartList.add(newCart1);
		insert cartList;

		// create template - need more data than this
		List<Apttus__APTS_Template__c > listOfTemp = new List<Apttus__APTS_Template__c > ();
		Apttus__APTS_Template__c newTemplate = new Apttus__APTS_Template__c();
		newTemplate.Name = System.Label.Digital_OF;
		newTemplate.Apttus__IsActive__c = TRUE;
		newTemplate.Apttus__Type__c = 'Proposal';
		newTemplate.Apttus__ReferenceId__c = '0db18264-424c-a7fa-5058-680a594f5189';
		newTemplate.Apttus__Agreement_Types__c = 'Default;Proposal;RFP';
		newTemplate.Apttus__FrameworkFormat__c = 'FX2';
		listOfTemp.add(newTemplate);

		Apttus__APTS_Template__c newTemplate1 = new Apttus__APTS_Template__c();
		newTemplate1.Name = System.Label.Digital_FOF;
		newTemplate1.Apttus__IsActive__c = TRUE;
		newTemplate1.Apttus__Type__c = 'Proposal';
		newTemplate1.Apttus__ReferenceId__c = '0db18264-424c-a7fa-5058-680a594f5189';
		newTemplate1.Apttus__Agreement_Types__c = 'Default;Proposal;RFP';
		newTemplate1.Apttus__FrameworkFormat__c = 'FX2';
		listOfTemp.add(newTemplate1);
		Insert listOfTemp;
	}
	private static testmethod void testEnvelopeCreation() {
		Apttus_Proposal__Proposal__c quote = [SELECT id, APTS_Proposal_Business_Unit__c FROM Apttus_Proposal__Proposal__c WHERE APTS_Proposal_Business_Unit__c = 'SCS'
			LIMIT 1
		];
		Test.startTest();
		Digital_WS_GenerateDocument.DigitalResponse dr = new Digital_WS_GenerateDocument.DigitalResponse();
		dr = Digital_WS_GenerateDocument.doPost(quote.id);
		System.AssertEquals(dr.Status, 'Failure', 'Expected Value');
		Test.stopTest();
	}
	private static testmethod void testEnvelopeCreation1() {
		Apttus_Proposal__Proposal__c quote = [SELECT id, APTS_Proposal_Business_Unit__c FROM Apttus_Proposal__Proposal__c WHERE APTS_Proposal_Business_Unit__c = 'FindLaw'
			LIMIT 1
		];
		Test.startTest();
		Digital_WS_GenerateDocument.DigitalResponse dr = new Digital_WS_GenerateDocument.DigitalResponse();
		dr = Digital_WS_GenerateDocument.doPost(quote.id);
		System.AssertEquals(dr.Status, 'Failure', 'Expected Value');
		Test.stopTest();
	}
	private static testmethod void testNegative() {
		List<Apttus__APTS_Template__c > listOfTemp = [select id from Apttus__APTS_Template__c where Name =:System.Label.Digital_FOF];
		delete listOfTemp;
		Apttus_Proposal__Proposal__c quote = [SELECT id, APTS_Proposal_Business_Unit__c FROM Apttus_Proposal__Proposal__c WHERE APTS_Proposal_Business_Unit__c = 'FindLaw'
			LIMIT 1
		];
		Test.startTest();
		Digital_WS_GenerateDocument.DigitalResponse dr = new Digital_WS_GenerateDocument.DigitalResponse();
		dr = Digital_WS_GenerateDocument.doPost(quote.id);
		System.AssertEquals(dr.Status, null, 'Expected Value');
		Test.stopTest();
	}
}