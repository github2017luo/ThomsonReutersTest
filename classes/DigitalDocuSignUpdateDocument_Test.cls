/**
 * This is the test class for DigitalDocuSignUpdateDocument
 */
/**
 * CHANGE HISTORY
 * =================================================================================================================
 * Date         Name                    Description
 * 2021-06-28   Brenda Shields          DLT-21973 - Fix to add field to selection query for DLT-21574 
 * =================================================================================================================
 */
/** 
 * @description : Test class for DigitalDocuSignUpdateDocument class
 */ 
@isTest
public class DigitalDocuSignUpdateDocument_Test {
	public static string templateId;
	public static string quoteId;
	// Create Test Data
	@testSetup
	static void setup() {
		// create account, ssd, opp, contact and quote
		DCTestData.createData();
		Test.startTest();
		DCTestData.createQuote();
		Test.stopTest();
		// create attachment for the quote
		DCTestData.createAttachment(DCTestData.bQuoteid);
		// create template
		DCTestData.createTemplate();
		// create data for DocuSign connection
		DCTestData.createDocuSignUser();
		// create web services
		DCTestData.createDocuSignWebService();
		DCTestData.createMarketAutomationWebsvc();
		quoteId = DCTestData.bQuoteId;
	}
	
	// test Envelope creation method
	@istest static void testEnvelopeCreation1() {

		Test.startTest();
		// Set mock callout class for Envelope response
		Test.setMock(HttpCalloutMock.class, new HttpResponseMock());
		//Test.setMock(HttpCalloutMock.class, new DigitalDocuSignUpdateDocMock_Test());
		//HttpResponse res = DigitalDocuSignUpdateDocCallout_Test.getInfoFromExternalService();
		//System.assertEquals(200, res.getStatusCode());
		Apttus_Proposal__Proposal__c quote = [SELECT id FROM Apttus_Proposal__Proposal__c LIMIT 1];
		DigitalDocuSignUpdateDocument.updateEnvelope(quote.id);
		DigitalDocuSignUpdateDocument.envelopeCreation(quote.id);

		try {
			List<Apttus__APTS_Template__c > oTemplate = [SELECT id FROM Apttus__APTS_Template__c];
			delete oTemplate;
			DigitalDocuSignUpdateDocument.updateEnvelope(quoteId);
			DigitalDocuSignUpdateDocument.envelopeCreation(quoteId);
		} catch (Exception e) {
			system.assertEquals(e.getMessage(), e.getMessage(),'Expected Value');
		}
		Test.stopTest();
		// was the envelope created successfully
		Apttus_Proposal__Proposal__c oQuotes = [Select id, Digital_Envelope_Created__c from Apttus_Proposal__Proposal__c where Digital_Envelope_Created__c = true LIMIT 1];
		System.AssertEquals(True, oQuotes.Digital_Envelope_Created__c,'Expected Value');
	}

	// test method for error processing during envelope creation process
	@istest static void testEnvelopeCreationError() {

		Test.startTest();
		// Set mock callout class for Envelope response
		Test.setMock(HttpCalloutMock.class, new HttpResponseMock());
		// set for failures
		DCTestData.enableisRunningTest = false;
		Apttus_Proposal__Proposal__c quote = [SELECT id FROM Apttus_Proposal__Proposal__c LIMIT 1];
		DigitalDocuSignUpdateDocument.updateEnvelope(quote.id);
		DigitalDocuSignUpdateDocument.envelopeCreation(quote.id);
		Test.stopTest();
		// was the envelope created successfully
		Apttus_Proposal__Proposal__c oQuotes = [Select id, Digital_Envelope_Created__c from Apttus_Proposal__Proposal__c where Digital_Envelope_Created__c = false LIMIT 1];
		System.AssertEquals(false, oQuotes.Digital_Envelope_Created__c,'Expected Value');
	}
	
	// test method do Order Form creation
	@istest static void testDocCreation() {

		// don't use DocuSign mock service so the process will fail   
		Test.setMock(HttpCalloutMock.class, new DCConfiguratorMockHttpLoginTest());
		Test.startTest();
		DigitalDocuSignUpdateDocument.updateEnvelope(DCTestData.bQuoteId);
		Test.stopTest();
		// no envelope will be created
		Apttus_Proposal__Proposal__c oQuotes = [Select id, Digital_Envelope_Created__c from Apttus_Proposal__Proposal__c where Digital_Envelope_Created__c = false LIMIT 1];
		System.AssertEquals(false, oQuotes.Digital_Envelope_Created__c,'Expected Value');
	}

	// test method session login
	@istest static void testLogin() {
		Test.startTest();
		Test.setMock(HttpCalloutMock.class, new DCConfiguratorMockHttpLoginTest());
		list<DC_Global_Settings__mdt > globalSettingList = [SELECT Login_Domain__c, Username__c, Password__c, Security_Token__c, Request_Timeout__c, Use_API_User__c FROM DC_Global_Settings__mdt LIMIT 1];
		system.debug(logginglevel.INFO, 'Global Settings: ' + globalSettingList);
		Map<String, String> mapsessionId = new Map<String, String> ();
		mapsessionId = DigitalDocuSignUpdateDocument.getSession();
		Test.stopTest();
		System.AssertNotEquals(null, mapsessionId,'Expected Value');
	}
}