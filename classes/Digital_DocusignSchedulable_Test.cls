@isTest
public class Digital_DocusignSchedulable_Test {
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
        Test.stopTest();
        
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
        oQuote.Digital_Envelope_Created__c = true;          
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
    }
    
    public static testmethod void testSched() {
    	
    	Test.startTest();
    	// Set mock callout class for Envelope response
        Test.setMock(HttpCalloutMock.class, new HttpResponseMock());

        DateTime now  = DateTime.now();
        DateTime nextRunTime = now.addHours(2);
        String cronString = '' + nextRunTime.second() + ' ' + nextRunTime.minute() + ' ' + nextRunTime.hour() + ' ' + nextRunTime.day() + ' ' + nextRunTime.month() + ' ? ' + nextRunTime.year(); 
        Digital_DocusignSchedulable ddc = new Digital_DocusignSchedulable();
        system.schedule('Testexecution', cronString, ddc);
        Test.stopTest();
        
        // Check to see if the envelope was created
        Apttus_Proposal__Proposal__c oQuotes = [Select id, Digital_Envelope_Created__c from Apttus_Proposal__Proposal__c where Digital_Envelope_Created__c =: false LIMIT 1];
        System.AssertEquals(false, oQuotes.Digital_Envelope_Created__c);

    } 
}