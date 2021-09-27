/**
 * Test class for testing the DigitalDocuSignEnvelopeCreation class.  The DigitalDocuSignEnvelopeCreationclass is a schedulable job that
 * creates DocuSign Envelope ID for Proposal Quote that meet specific criteria.  
 */
/**
 * CHANGE HISTORY
 * =============================================================================
 * Date         Name                    Description
 * 2017-04-01   Brenda Shields          Created
 * 2017-07-11   Dinesh Kumar            Updated the class 
 * 2017-09-12   Brenda Shields          Updated for new Jiras DLT-2301, DLT-2689 and DLT-495
 * 2017-12-29   Brenda Shields          Updated for new quote selection logic  DLT-6929
 * 2018-01-11   Benjamin Her            Updated to ensure 85% code coverage as of date.
 * 2018-02-28   Brenda Shields          Updated for DLT-7917 - Create Opportunity Pricing record for Straight Renewal Quotes
 * 2018-06-11   Brenda Shields          DLT-9762 - GLI Updates
 * 2020-03-07   Brenda Shields          DLT-21480 - [ALL] Update the Envelope Creation class to look for the order form pdf as a file and not an attachment
 *                                                  Fix PMD violations
 * =============================================================================
 */
/** 
* @description : test class for DDigitalDocuSignEnvelopeCreation class
*/ 
@isTest
private class DigitalDocuSignEnvelopeCreation_Test {
    public static String accountId;
    public static String oppId;
    public static String quoteId;
    public static string attachmentId;

    
    // Create Quote data for DocuSign Envelope Creation
    @testSetup
    static void setup(){
        // create account, ssd, opp, contact and quote
        DCTestData.createData();
        Test.startTest();   
        DCTestData.createQuote();      
        
        list<WebServiceSettings__c> webServiceList = new list<WebServiceSettings__c>{new WebServiceSettings__c(Name='EnterpriseWSDL',Endpoint__c='https://api.thomsonreuters.com/ebs/entitlement/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
           new WebServiceSettings__c(Name='StatusPostbackLocation',Endpoint__c='https://api.thomsonreuters.com/ebs/entitlement/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
           new WebServiceSettings__c(Name='PostbackLocation',Endpoint__c='https://api.thomsonreuters.com/ebs/entitlement/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
           new WebServiceSettings__c(Name='Payment AutoCharge',Endpoint__c='https://api.thomsonreuters.com/ebs/entitlement/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
           new WebServiceSettings__c(Name='PaymentCreditIncrease',Endpoint__c='https://api.thomsonreuters.com/ebs/entitlement/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available')};
        insert webServiceList;
        
        // update renewal date on Opp
        Opportunity oOpp = new Opportunity();
        oOpp.id = DCTestData.oppId;
        oOpp.StageName = 'Contacting';
        oOpp.Renewal_Date__c = system.today().addDays(180);
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

        // create a matching Digital Subscription record
        Product_Account_Detail__c prodAcctDetail = DCTestData.createDigitalSubscriptions('42072689','42072690', 'Plus', '1004284494', System.Today()+30, 'testCampaign');
        prodAcctDetail.Current_Subscription__c = '41010973';
        prodAcctDetail.sub_Campaign_Code__c = 'subtestcampaign';
        update prodAcctDetail;
                
        // create data for DocuSign connection
        DCTestData.createDocuSignUser();
        
        // delete extra quote
        Apttus_Proposal__Proposal__c oQuote2 = new Apttus_Proposal__Proposal__c();
        oQuote2.Id = DCTestData.cQuoteId;
        //delete oQuote2;
        
        // create web services
        DCTestData.createDocuSignWebService();
        DCTestData.createMarketAutomationWebsvc();
        DCTestData.createPaymentCreditWebService();
        
        // create attachment for the quote
        DCTestData.createAttachment(oQuote.id);
        //DCTestData.createFileAttachment(oQuote.id);      
        Test.stopTest();      
        
    }

    // Test for normal Envelope creation - Test should end successfully
    static testmethod void testEnvelopeCreation() {
        
        Test.startTest();   
        
        // Set mock callout class for Envelope response
        Test.setMock(HttpCalloutMock.class, new HttpResponseMock());
        
        DigitalDocuSignEnvelopeCreation dc = new DigitalDocuSignEnvelopeCreation();
        dc.execute(null,dc.QuoteList);
        
        // Check to see if the envelope was created
        Apttus_Proposal__Proposal__c oQuotes = [Select id, Digital_Envelope_Created__c from Apttus_Proposal__Proposal__c where Digital_Envelope_Created__c =: TRUE LIMIT 1];
        system.AssertEquals(True, oQuotes.Digital_Envelope_Created__c, 'Envelope should have been created');
        
        Test.stopTest();
    }
    
     
    static testmethod void testEnvelopeCreationWithUpdates() {
        // Create Envelope with different values causing different updates - Test should end successfully
        
        Opportunity oOpp = [SELECT id, Renewal_Date__c, StageName, Digital_PreviousStageName__c
                            FROM Opportunity 
                            WHERE StageName = 'Contacting'];
        oOpp.Renewal_Date__c = system.today().addDays(-180);
        oOpp.StageName = 'Appointment Scheduled';
        oOpp.Digital_PreviousStageName__c = 'Generate Contract';
        update oOpp;
    
        
        Test.startTest();   
        
        // Set mock callout class for Envelope response
        Test.setMock(HttpCalloutMock.class, new HttpResponseMock());
        
        DigitalDocuSignEnvelopeCreation dc = new DigitalDocuSignEnvelopeCreation();
        dc.execute(null,dc.QuoteList);
        
        // Check to see if the envelope was created and stage set to correct value
        Opportunity oOppty = [Select id, StageName from Opportunity where id =: oOpp.id];
        system.AssertEquals('Appointment Scheduled', oOppty.StageName, 'Opportunity should be the correct stage');
        
        Test.stopTest();
    }
    
    // don't create an attachment so the envelope generation will not complete
    static testmethod void testEnvelopeCreationError() {
            
        // create quote with no attachment so it will get an error    
        List<Attachment> oAttachment = [SELECT id FROM Attachment];
        delete oAttachment;
                   
        Test.startTest(); 
        
        // Set mock callout class for Envelope response
        Test.setMock(HttpCalloutMock.class, new HttpResponseMock());
        
        DigitalDocuSignEnvelopeCreation dc = new DigitalDocuSignEnvelopeCreation();
        dc.execute(null,dc.QuoteList);
        
        // Check to see if the envelope was not created due to no attachment        
        Apttus_Proposal__Proposal__c oQuotes = [Select id, Digital_Envelope_Created__c from Apttus_Proposal__Proposal__c where Digital_Envelope_Created__c = false LIMIT 1];
        system.AssertEquals(False, oQuotes.Digital_Envelope_Created__c, 'Envelope Creation Flag');
        
        Test.stopTest();
    }    
    
    //test where call to create DocuSign envelope failed
    static testmethod void testEnvelopeCreationCalloutError() {
         
        Test.startTest(); 
        // Set mock callout class for Envelope response
        Test.setMock(HttpCalloutMock.class, new HttpResponseMock.failToCreatEnvelope());
        
        DigitalDocuSignEnvelopeCreation dc = new DigitalDocuSignEnvelopeCreation();
        dc.execute(null,dc.QuoteList);
        
        // check to see the envelope was not created
        Apttus_Proposal__Proposal__c oQuotes = [Select id, Digital_Envelope_Created__c from Apttus_Proposal__Proposal__c where Digital_Envelope_Created__c = false LIMIT 1];
        system.AssertEquals(False, oQuotes.Digital_Envelope_Created__c, 'Envelope creation flag');  
        
        Test.stopTest();
    }    
    
    // test where call to DocSign to validate users failed
    static testmethod void testDocusignStartMethod() {

        Test.startTest(); 
        
        // Set mock callout class for Envelope response
        Test.setMock(HttpCalloutMock.class, new HttpResponseMock.failToCreatEnvelope());
        
        DigitalDocuSignEnvelopeCreation dc = new DigitalDocuSignEnvelopeCreation();
        Iterable<Apttus_Proposal__Proposal__c> proposalList = dc.start(null);
        
        System.Assert(proposalList != null, 'proposalList is null');
        
        Test.stopTest();

    } 

    static testmethod void testDocusignFinishMethod(){

        Test.startTest(); 
        
        // Set mock callout class for Envelope response
        Test.setMock(HttpCalloutMock.class, new HttpResponseMock.failToCreatEnvelope());
        
        DigitalDocuSignEnvelopeCreation dc = new DigitalDocuSignEnvelopeCreation();
        dc.finish(null);

        List<Product_Account_Detail__c> digitalSubscriptionsList = [
            SELECT id
            FROM Product_Account_Detail__c 
            WHERE Campaign_Code__c != null AND Renewal_Date__c > Today AND Bypass_Automation__c = true
        ];

        System.Assert(digitalSubscriptionsList != null, 'DS Bypass not updated');
        
        Test.stopTest();

    }
    
    static testmethod void testEnvelopeCreationNewSales() {
        // Test New Sales specific code
        // update Opp for New Sales
        Opportunity oOpp = [SELECT id, Renewal_Date__c, StageName, Digital_PreviousStageName__c
                            FROM Opportunity 
                            WHERE StageName = 'Contacting'];
        oOpp.Is_Digital_New_Sales__c = true;
        update oOpp;
    
        // update Proposal for New Sales
        Apttus_Proposal__Proposal__c oQuote = [select id, Digital_Quote_TYpe__c 
        					from Apttus_Proposal__Proposal__c 
        					where Apttus_Proposal__Opportunity__c = : oOpp.Id];
        oQuote.Digital_Quote_Type__c = 'Manual';         
        update oQuote;

        Test.startTest();   
        
        // Set mock callout class for Envelope response
        Test.setMock(HttpCalloutMock.class, new HttpResponseMock());
        
        list<Apttus_Proposal__Proposal__c> quoteList = [Select id, name, Apttus_Proposal__Opportunity__c,
          Apttus_Proposal__Opportunity__r.Source_System_Detail__r.Digital_Firm__c,
          Apttus_Proposal__Opportunity__r.SAP_Account_Number__c,
          Apttus_Proposal__Opportunity__r.Owner.Email, Apttus_Proposal__Opportunity__r.Owner.Name,
          Apttus_Proposal__Opportunity__r.Digital_PreviousStageName__c,
          APTS_Order_Confirmation_Contact__c, APTS_Order_Confirmation_Contact_Name__c,
          APTS_Order_Confirmation_Contact_Email__c, APTS_Renewal__c,
          Apttus_Proposal__Primary__c, Digital_Quote_Type__c,
          APTS_Sold_To_SAP_Account_Number__c, APTS_Approval_Segment__c,APTS_Proposal_Business_Unit__c,
          Apttus_Proposal__Opportunity__r.Renewal_Date__c, CreatedDate, Is_Digital_New_Sales__c
          FROM Apttus_Proposal__Proposal__c WHERE id =: oQuote.Id];

      	DigitalDocuSignEnvelopeCreation.CreateEnvelopes(quoteList);
        
        // Check to see if the envelope was created and stage set to correct value
        Opportunity oOppty = [Select id, StageName from Opportunity where id =: oOpp.id];
        system.AssertEquals('Contacting', oOppty.StageName, 'Opportunity should be the correct stage');
        
        Test.stopTest();
    }
    
/*
    static testmethod void testContentVersionCreation(){
        
        DigitalDocuSignEnvelopeCreation dc = new DigitalDocuSignEnvelopeCreation(); 
            
		// LatAm User  
		// work-around for error inserting content version records in ContentDocuDelRestrictionHandler
		User u = [select Id from User where profile.Name = 'LatAm User' and IsActive = true limit 1];
        system.runAs(u) {          
        	ContentVersion contentVer = new ContentVersion();
        	contentVer.ContentLocation = 'S';
        	contentVer.Title = String.valueOf('Order Form Test Content Version');
        	contentVer.PathOnClient = String.valueOf('Test PathOnClient');
        	contentVer.versiondata = EncodingUtil.base64Decode('Test versionData');
        	contentVer.Legacy_ParentId__c = dc.QuoteList[0].id; // use this field to tie the content version to the proposal
        	insert contentVer;
        	contentVer = [SELECT id, ContentDocumentId FROM ContentVersion WHERE Title = 'Order Form Test Content Version' LIMIT 1];

        	ContentDocumentLink contentDocLink = new ContentDocumentLink();
        	contentDocLink.ContentDocumentId = contentVer.ContentDocumentId;
       	 	contentDocLink.LinkedEntityId  = dc.QuoteList[0].id;
        	insert contentDocLink;
        }
        Test.startTest();

        // Set mock callout class for Envelope response
        Test.setMock(HttpCalloutMock.class, new HttpResponseMock());
        
        dc.execute(null,dc.QuoteList);
        
        // Check to see if the envelope was created
        Apttus_Proposal__Proposal__c oQuotes = [Select id, Digital_Envelope_Created__c from Apttus_Proposal__Proposal__c where Digital_Envelope_Created__c =: TRUE LIMIT 1];
        system.AssertEquals(True, oQuotes.Digital_Envelope_Created__c, 'Envelope should have been creaed');

        Test.stopTest();
    }
*/
    
}