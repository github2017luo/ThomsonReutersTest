/**
 * Test class for DCDocusignService, DCDocuSignController and DCGenerateDocumentController
 * These classes are used to generate the Order Form attachment for a Proposal and to send the Order Form to 
 * DocuSign for the creation of the Envelope
 */
/**
 * CHANGE HISTORY
 * =============================================================================
 * Date         Name                    Description
 *                                      Created
 * 2019-06-11   Brenda Shields          DLT-16790 - Fix code scan Major issues
 * 2019-06-26	Benjamin Her			DLT-16925 - Fix code scan Minor issues
 * 2021-04-01   Brenda Shields          DLT-21586 - [SFDC]-Removing FindLaw Approval Segment Value
 *                                                  Change field being checked from -> APTS_Approval_Segment__c to -> APTS_Proposal_Business_Unit__c 
 * =============================================================================
 */
/**
 * @description : Test class for DCDocusignService class
 */
@isTest
public class DCDocusignService_Test {

	public static String oppId;
	public static String quoteId;
   /**
	* @description : Create the appropriate test data for the generation of the Order Form attachment and the DocuSign Envelope
	*/
	@testSetup
	public static void testCreateData() {

		// create account, ssd, opp, contact and quote
		DCTestData.createData();
		Test.startTest();
		DCTestData.createQuote();
		Test.stopTest();

		// create web services
		DCTestData.createDocuSignWebService();
		DCTestData.createMarketAutomationWebsvc();

		// create data for DocuSign connection
		DCTestData.createDocuSignUser();
		// create template
		DCTestData.createTemplate();

		// update renewal date on Opp
		Opportunity oOpp = new Opportunity();
		oOpp.id = DCTestData.oppId;
		oOpp.CloseDate = System.Today() + 30;
		oOpp.StageName = '10%';
		oOpp.Renewal_Date__c = System.Today() + 1;
		oOpp.Status__c = 'Converted';
		oOpp.isDigitalSpearHead__c = TRUE;
		update oOpp;
		oppId = oOpp.id;

		// update Proposal
		Apttus_Proposal__Proposal__c oQuote = new Apttus_Proposal__Proposal__c();
		oQuote.id = DCTestData.bQuoteId;
		oQuote.Apttus_Proposal__Approval_Stage__c = 'Generated';
		oQuote.Apttus_Proposal__Primary__c = true;
		oQuote.Digital_Batch_Processed__c = true;
		oQuote.Digital_Quote_Automation__c = true;
		oQuote.Digital_Quote_Type__c = 'Straight Renewal';
		oQuote.Digital_Envelope_Created__c = false;
		update oQuote;
		quoteId = oQuote.id;

	}

	@isTest public static void docusignTest() {

		Test.startTest();

		// Set mock callout class for Envelope response
		Test.setMock(HttpCalloutMock.class, new HttpResponseMock());
		// Get Proposals to process
		Apttus_Proposal__Proposal__c oQuote = [SELECT id FROM Apttus_Proposal__Proposal__c limit 1];
		List<String> qs = new List<String> ();
		qs.add(oQuote.id);
		DCDocusignService.generatePDFDocByQuoteIds(qs);
		DCDocusignService.envelopeCreation(qs);
		DCDocusignService.getGlobalSettingServerURL();
		// Check to see if the envelope was created - envelopes are not created in thie scenario
		Apttus_Proposal__Proposal__c oQuotes = [Select id, DocuSign_Envelope_ID__c, Digital_Envelope_Created__c from Apttus_Proposal__Proposal__c where id =: oQuote.id LIMIT 1];
		System.AssertEquals(null, oQuotes.DocuSign_Envelope_ID__c, 'Expected Value');

		Test.stopTest();

	}

	@isTest public static void docusignNewSalesTest() {

		Test.startTest();

		// Set mock callout class for Envelope response
		Test.setMock(HttpCalloutMock.class, new HttpResponseMock());

		// update New Sales flag on Opp
		Opportunity oOpp = [select id, IsdigitalSpearHead__c, Is_Digital_New_Sales__c from Opportunity limit 1];
		oOpp.Is_Digital_New_Sales__c = true;
		oOpp.isDigitalSpearHead__c = false;
		update oOpp;
		Apttus_Proposal__Proposal__c oQuote = [SELECT id FROM Apttus_Proposal__Proposal__c where Apttus_Proposal__Opportunity__c =: oOpp.id limit 1];
		DCDocuSignController.envelopeCreation(oQuote.id);
		// Check to see if the envelope was created - envelopes are not created in thie scenario
		Apttus_Proposal__Proposal__c oQuotes = [Select id, DocuSign_Envelope_ID__c from Apttus_Proposal__Proposal__c where id =: oQuote.id LIMIT 1];
		System.AssertEquals(null, oQuotes.DocuSign_Envelope_ID__c, 'Expected Value');
		Test.stopTest();

	}

	@isTest public static void controllerTest() {

		Test.startTest();

		Apttus_Proposal__Proposal__c oQuote = [SELECT id FROM Apttus_Proposal__Proposal__c limit 1];
		List<String> qs = new List<String> ();
		qs.add(oQuote.id);
		DCDocuSignController.envelopeCreation(null);
		DCDocuSignController.envelopeCreation(qs[0]);
		DCDocuSignController.envelopeCreation('2345');
		// Check to see if the envelope was created - envelopes are not created in thie scenario
		Apttus_Proposal__Proposal__c oQuotes = [Select id, DocuSign_Envelope_ID__c from Apttus_Proposal__Proposal__c where id =: oQuote.id LIMIT 1];
		System.AssertEquals(null, oQuotes.DocuSign_Envelope_ID__c, 'Expected Value');

		Test.stopTest();

	}

	@isTest public static void generateDocument() {

		Test.startTest();
		Apttus_Proposal__Proposal__c oQuote = [SELECT id FROM Apttus_Proposal__Proposal__c limit 1];
		List<String> qs = new List<String> ();
		qs.add(oQuote.id);
		DCGenerateDocumentController.envelopeCreation(qs);
		DCGenerateDocumentController.envelopeCreation(null);

		// Check to see if the envelope was created - envelopes are not created in thie scenario
		Apttus_Proposal__Proposal__c oQuotes = [Select id, DocuSign_Envelope_ID__c from Apttus_Proposal__Proposal__c where id =: oQuote.id LIMIT 1];
		System.AssertEquals(null, oQuotes.DocuSign_Envelope_ID__c, 'Expected Value');
		Test.stopTest();

	}

	@isTest public static void negativeGenerateDocumenttest() {

		Test.startTest();
		// Test.setMock(HttpCalloutMock.class, new DCConfiguratorMockHttpLoginTest());

		Apttus_Proposal__Proposal__c oQuote = [SELECT id FROM Apttus_Proposal__Proposal__c limit 1];
		List<String> qs = new List<String> ();
		qs.add('quoteList');
		DCDocusignService.envelopeCreation(qs);

		// Check to see if the envelope was created - envelopes are not created in thie scenario
		Apttus_Proposal__Proposal__c oQuotes = [Select id, DocuSign_Envelope_ID__c from Apttus_Proposal__Proposal__c where id =: oQuote.id LIMIT 1];
		System.AssertEquals(null, oQuotes.DocuSign_Envelope_ID__c, 'Expected Value');
		Test.stopTest();

	}

}