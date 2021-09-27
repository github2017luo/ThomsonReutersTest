/*
 * Test class for the invocable method class that calls the DigitalDocusignEnvelopeCreation envelope creation method.
 *
 *                      ****** Change History *******
 *    Date                      Name                                Description
 *    2021-04-01                Brenda Shields                      DLT-21586 - [SFDC]-Removing FindLaw Approval Segment Value
 *                                                                  Change field being checked from -> APTS_Approval_Segment__c to -> APTS_Proposal_Business_Unit__c
 */
@isTest
private class Digital_InvokeDocusignEnvelopeTest{
    public static String accountId;
    public static String oppId;
    public static String quoteId;
    public static string attachmentId;
    
    @testSetup static void createData(){
        // create account, ssd, opp, contact and quote
        DCTestData.createData();
        Test.startTest();   
        DCTestData.createQuote();      
        Test.stopTest();
        
        Contact con = [SELECT id,SAP_Role__c,SAP_Contact_ID__c,Email FROM Contact WHERE Email = 'testfirst.testlast@test.com' LIMIT 1];
        
        Source_System_Detail__c ssd = [SELECT id FROM Source_System_Detail__c LIMIT 1];
        
        DCTestData.createContactSSD(con,ssd);
        // update renewal date on Opp
        Opportunity oOpp = new Opportunity();
        oOpp.id = DCTestData.oppId;
        oOpp.StageName = 'Contacting';
        oOpp.Renewal_Date__c = system.today().addDays(180);
        oOpp.Key_Contact__c = con.id;
        update oOpp;  
        oppId = oOpp.id;  

        // update Proposal
        Apttus_Proposal__Proposal__c oQuote = new Apttus_Proposal__Proposal__c();
        oQuote.id = DCTestData.bQuoteId;
        oQuote.Apttus_Proposal__Approval_Stage__c = 'Presented';
        oQuote.Apttus_Proposal__Primary__c = true;
        oQuote.Digital_Batch_Processed__c = true;
        oQuote.Digital_Quote_Automation__c = true;
        oQuote.Digital_Quote_Type__c = 'Manual';
        oQuote.Digital_Envelope_Created__c = true;     
        oQuote.Apttus_Proposal__Opportunity__c = oppId;  
        oQuote.Display_in_CXD_Renewals__c = false; 
     
        update oQuote;
        quoteId = oQuote.id;
         
        Apttus_Proposal__Proposal__c oQuote2 = new Apttus_Proposal__Proposal__c();
        oQuote2.Id = DCTestData.cQuoteId;
        oQuote2.Apttus_Proposal__Approval_Stage__c = 'Presented';
        oQuote2.Apttus_Proposal__Primary__c = false;
        oQuote2.Digital_Batch_Processed__c = true;
        oQuote2.Digital_Quote_Automation__c = true;
        oQuote2.Digital_Quote_Type__c = 'Manual';
        oQuote2.Digital_Envelope_Created__c = false;     
        oQuote2.Apttus_Proposal__Opportunity__c = oppId;
        oQuote2.Display_in_CXD_Renewals__c = true; 
        update oQuote2;
        // create attachment for the quote
        DCTestData.createAttachment(oQuote.id);
                
        // create data for DocuSign connection
        DCTestData.createDocuSignUser();
        

        
        // create web services
        DCTestData.createDocuSignWebService();
        DCTestData.createMarketAutomationWebsvc();  
    }
    
    @isTest
    static void invokeDocusignCreationTest(){
        
        Apttus_Proposal__Proposal__c quote = [SELECT id
                                                FROM Apttus_Proposal__Proposal__c 
                                                WHERE Apttus_Proposal__Approval_Stage__c = 'Presented'
                                                AND Digital_Quote_Type__c = 'Manual'
                                                AND Display_in_CXD_Renewals__c = true
                                                LIMIT 1];                                       
       
        System.assert(quote!=null,'quote is null');
        List<ID> quoteIDs = new List<ID>();
        quoteIDs.add(quote.id);
        
        Test.startTest();
        //update quote;
        Digital_InvokeDocusignEnvelopeCreation.invokeCreateEnvelopes(quoteIDs);
        Test.stopTest();
    }
    
    @isTest
    static void updateOpportunityToDigitalTest(){
        List<Opportunity> listOpp = [SELECT id, Renewal_Date__c, Digital_Review_Complete__c, Unmarked_Digital_Channel__c, isDigitalSpearHead__c
                                    FROM Opportunity
                                    LIMIT 1];
        listOpp[0].Renewal_Date__c = null;
        listOpp[0].Digital_Review_Complete__c = false;
        listOpp[0].Unmarked_Digital_Channel__c = true;
        listOpp[0].isDigitalSpearHead__c = false;
        
        Test.startTest();
        Digital_InvokeDocusignEnvelopeCreation.updateOpportunityToDigital(listOpp);
        System.assert(listOpp[0].Renewal_Date__c != null, 'Renewal date is empty');
        System.assert(listOpp[0].Digital_Review_Complete__c != false, 'Digital review is false');
        System.assert(listOpp[0].Unmarked_Digital_Channel__c != true, 'Umarked digital is true');
        System.assert(listOpp[0].isDigitalSpearHead__c != false, 'Digital channel is false');
        Test.stopTest();
    }
    
    @isTest
    static void generateOrderFormTest(){
        List<Apttus_Proposal__Proposal__c> listProp = [SELECT id FROM Apttus_Proposal__Proposal__c LIMIT 1];
        
        Test.startTest();
        System.assert(listProp != null, 'No proposals found');
        Digital_InvokeDocusignEnvelopeCreation.generateOrderForm(new List<id>{listProp[0].id});
        Test.stopTest();
        
    }

}