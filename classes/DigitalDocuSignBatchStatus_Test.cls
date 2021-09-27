/**
 * This class contains unit tests for validating the behavior of Apex class DigitalDocuSignBatchStatus
 */
 /**
 * CHANGE HISTORY
 * =============================================================================
 * Date         Name                    Description
 * 2018-04-04   Brenda Shields          Created
 * 2018-06-29   Brenda Shields          DLT-10717 - Remove Obsolete Items - Remove SendOnBehalfOfEmail labels and CMT
 *                                      Update for Best Practices and use DCTestData
 * =============================================================================
 */
@isTest
private class DigitalDocuSignBatchStatus_Test {
    
    @isTest static void testEnvelopeUpdate_Voided()
    {
        // check logic for successful processing

        // Set mock callout class for Envelope response
        Test.setMock(HttpCalloutMock.class, new HttpResponseMock.docusignEnvelopeStatus_Voided());
        
        Test.startTest();   
        DigitalDocuSignBatchStatus dc = new DigitalDocuSignBatchStatus();
        database.executebatch(dc,1); 
        Test.stopTest();
        
        // Check to see if the envelope has been udpated
        Apttus_DocuApi__DocuSignEnvelope__c oEnvelope = [Select id, Apttus_DocuApi__RecallReason__c from Apttus_DocuApi__DocuSignEnvelope__c Limit 1];
        System.AssertEquals('test expiration', oEnvelope.Apttus_DocuApi__RecallReason__c);
                
    }    
    
    @isTest static void testEnvelopeUpdate_Accepted()
    {
        // check logic for successful processing

        // Set mock callout class for Envelope response
        Test.setMock(HttpCalloutMock.class, new HttpResponseMock.docusignEnvelopeStatus_Accepted());
        
        Test.startTest();   
        DigitalDocuSignBatchStatus dc = new DigitalDocuSignBatchStatus();
        database.executebatch(dc,1); 
        Test.stopTest();
        
        // Check to see if the envelope has been udpated
        Apttus_DocuApi__DocuSignEnvelope__c oEnvelope = [Select id, Apttus_DocuApi__Status__c from Apttus_DocuApi__DocuSignEnvelope__c Limit 1];
        System.AssertEquals('completed', oEnvelope.Apttus_DocuApi__Status__c);
                
    }
        
    @isTest static void testEnvelopeFailure()
    {
        // check logic to for bad response from DocuSign on status check
         
        // Set mock callout class for Envelope response
        Test.setMock(HttpCalloutMock.class, new HttpResponseMock.docusignFailureStatus());
        
        Test.startTest();   
        DigitalDocuSignBatchStatusSch dc = new DigitalDocuSignBatchStatusSch();
        dc.execute(null);
        Test.stopTest();
        
        // Check to see if the envelope is unchanged
        Apttus_DocuApi__DocuSignEnvelope__c oEnvelope = [Select id, Apttus_DocuApi__RecallReason__c from Apttus_DocuApi__DocuSignEnvelope__c Limit 1];
        System.AssertEquals('DocuSign has Purged this Envelope from this Demo Account', oEnvelope.Apttus_DocuApi__RecallReason__c);
                
    }
    
    @isTest static void testEnvelopeProdFailure()
    {
        // check logic to for bad response from DocuSign on status check   
        
        // Set mock callout class for Envelope response
        Test.setMock(HttpCalloutMock.class, new HttpResponseMock.docusignProdFailureStatus());
        
        Test.startTest();   
        DigitalDocuSignBatchStatusSch dc = new DigitalDocuSignBatchStatusSch();
        dc.execute(null);
        Test.stopTest();
        
        // Check to see if the envelope is unchanged
        Apttus_DocuApi__DocuSignEnvelope__c oEnvelope = [Select id, Apttus_DocuApi__RecallReason__c from Apttus_DocuApi__DocuSignEnvelope__c Limit 1];
        System.AssertEquals('DocuSign has Purged this Envelope from this Demo Account', oEnvelope.Apttus_DocuApi__RecallReason__c);
                
    }
        
    @isTest static void testConnectionFailure()
    {
        // check logic for failure to get a good response back from DocuSign login
        
        // Set mock callout class for Envelope response
        Test.setMock(HttpCalloutMock.class, new HttpResponseMock.failToConnectTest());
        
        Test.startTest();   
        DigitalDocuSignBatchStatusSch dc = new DigitalDocuSignBatchStatusSch();
        dc.execute(null);
        Test.stopTest();
        
        // Check to see if the envelope is unchanged
        Apttus_DocuApi__DocuSignEnvelope__c oEnvelope = [Select id, Apttus_DocuApi__RecallReason__c from Apttus_DocuApi__DocuSignEnvelope__c Limit 1];
        System.AssertEquals(null, oEnvelope.Apttus_DocuApi__RecallReason__c);
                
    }    
    
    // Create Quote data for DocuSign status batch job
    @testSetup static void prepareTestQuote() {
        // create account, ssd, opp, contact and quote
        DCTestData.createData();
        Test.startTest();
        DCTestData.createQuote();
        Test.StopTest();
            
        // update renewal date on Opp
        Opportunity oOpp = new Opportunity();
        oOpp.id = DCTestData.oppId;
        oOpp.StageName = 'Contacting';
        oOpp.Renewal_Date__c = system.today().addDays(180);
        update oOpp;        

        // update Proposal
        Apttus_Proposal__Proposal__c oQuote = new Apttus_Proposal__Proposal__c();
        oQuote.id = DCTestData.bQuoteId;
        oQuote.Apttus_Proposal__Approval_Stage__c = 'Expired';
        oQuote.Apttus_Proposal__Primary__c = true;
        oQuote.Digital_Batch_Processed__c = true;
        oQuote.Digital_Quote_Automation__c = true;
        oQuote.Digital_Quote_Type__c = 'Straight Renewal';
        oQuote.Digital_Envelope_Created__c = false;          
        update oQuote;
        
        // create envelope
        Apttus_DocuApi__DocuSignEnvelope__c oEnvelope = DCTestData.createDocuSignEnvelope('voided', oQuote.id);
        oEnvelope.Apttus_DocuApi__RecallReason__c = '';
        oEnvelope.Apttus_DocuApi__EnvelopeId__c = 'ce12dc3d-ffff-4444-aaaa-3b0494af30b9';
        insert oEnvelope; 

        // create attachment for the quote
        DCTestData.createAttachment(oQuote.id);
                
        // create data for DocuSign connection
        DCTestData.createDocuSignUser();
        
        // delete extra quote
        Apttus_Proposal__Proposal__c oQuote2 = new Apttus_Proposal__Proposal__c();
        oQuote2.Id = DCTestData.cQuoteId;
        delete oQuote2;
        
        // create web services
        DCTestData.createDocuSignWebService();
        DCTestData.createMarketAutomationWebsvc();
    }
    
}