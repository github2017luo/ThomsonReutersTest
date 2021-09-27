/*
 * DCAccpetQuoteTest
 * Test class for DCAcceptQuoteTest
 *
 *
 *            Change History 
 *     Date            Name            Change
 * 2018-11-19        Benjamin Her        DLT-13461 - Inital Creation of Test class
 * 2019-06-24        Srikanth kota       DLT-16787- [Code Scan] -Fix code scan MAJOR issues in this DCAcceptQuoteTest ,DCAddRemoveAddOns, DCAddRemoveOnlineContacts
 *
 *
 */



@isTest
private class DCAcceptQuoteTest{

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
        oQuote.Apttus_Proposal__Approval_Stage__c = 'Presented';
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
    
    @isTest
    public static void testDCAcceptQuotesuccess(){
        Test.setMock(HttpCalloutMock.class, new HttpResponseMock.docusignEnvelopeStatus_Accepted());
        DCAcceptQuote acceptquote = new DCAcceptQuote();
        DCMessage message = new DCMessage();
        Apttus_DocuApi__DocuSignEnvelope__c docSignEnv = [SELECT Apttus_DocuApi__EnvelopeId__c,Apttus_DocuApi__Status__c 
                                                            FROM Apttus_DocuApi__DocuSignEnvelope__c 
                                                            WHERE Apttus_DocuApi__EnvelopeId__c  = 'ce12dc3d-ffff-4444-aaaa-3b0494af30b9'];

        Test.startTest();                                                    
        message = DCAcceptQuote.acceptQuote(docSignEnv.Apttus_DocuApi__EnvelopeId__c);
        Test.stopTest();
        System.assertEquals(docSignEnv.Apttus_DocuApi__Status__c,'voided');
    }
        
    @isTest
    public static void testDCAcceptQuotefailure(){
        Test.setMock(HttpCalloutMock.class, new HttpResponseMock.docusignEnvelopeStatus_Accepted());
        DCAcceptQuote acceptquote = new DCAcceptQuote();
        DCMessage message = new DCMessage();
        Test.startTest();                                                    
        message = DCAcceptQuote.acceptQuote('');
        Test.stopTest();
        System.assertEquals(message.code,404);
    }
    
    @isTest
    public static void testDCAcceptQuotenullParameter(){
        DCAcceptQuote acceptquote = new DCAcceptQuote();
        DCMessage message = new DCMessage();
        /* Apttus_DocuApi__DocuSignEnvelope__c docSignEnv = [SELECT Apttus_DocuApi__EnvelopeId__c 
                                                            FROM Apttus_DocuApi__DocuSignEnvelope__c 
                                                            WHERE Apttus_DocuApi__EnvelopeId__c  = 'ce12dc3d-ffff-4444-aaaa-3b0494af30b9'];
*/        
        Test.startTest();                                                    
        message = DCAcceptQuote.acceptQuote(null);
        
        Test.stopTest();
        System.assertEquals(message.code,404);
    }
}