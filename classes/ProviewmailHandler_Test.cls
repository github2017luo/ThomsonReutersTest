@isTest(SeeAllData=false)

private class ProviewmailHandler_Test{
static testmethod void TestEmailToSalesforce(){

UnitTest.createTestData();
//Preparing Account data
Account objAcc = UnitTest.getAccountInstance();
INSERT objAcc;

//Preparing Opportunity data        
    //Opportunity objOpp = UnitTest.getOpportunityInstance(objAcc.Id);
        Opportunity oOpportunity = new Opportunity();
        oOpportunity.AccountId = objAcc.Id;
        oOpportunity.Name = 'Unit Test Opportuntiy';
        oOpportunity.CloseDate = System.Today() + 5;
        oOpportunity.StageName = '75%';
    oOpportunity.Sales_Org__c = 'TSL'; 
    oOpportunity.Renewal_Flag__c = true;
    oOpportunity.Pricebook2Id = Test.getStandardPricebookId();
    oOpportunity.Expected_Revenue_Date__c = Date.newInstance(2016, 7, 11);
    oOpportunity.SAP_Quotation_Document_number__c = 'SF974598';
//objOpp.SAP_Account_Number__c ='SAP002236';
    INSERT oOpportunity;
    /*
    Opportunity objOpp = [SELECT id, SAP_Account_Number__c, CloseDate FROM Opportunity WHERE id =: 'oOpportunity.id'];
    Opportunity objOpp = new Opportunity(id = oOpportunity.id);
    objOpp.CloseDate = System.Today() + 6;
    UPDATE objOpp;
    */


//Preparing Quote data
Quote objQty = new Quote();
objQty.Name = 'Test Quote';
objQty.Status = 'Draft';
objQty.OpportunityId = oOpportunity.id;
objQty.Pricebook2Id = Test.getStandardPricebookId();
objQty.Approval_Status__c = 'Cancellation Approved';
//objQty.Current_Renewal_Options__c= 'Opt-In - Negotiable Renewal';
//objQty.Invoice_Type__c = 'Detailed';
//objQty.Grace_Period_Indicator__c = false;
//objQty.RecordTypeId = Schema.SObjectType.Quote.getRecordTypeInfosByName().get('LATAM Renewal Quote').getRecordTypeId();   
INSERT objQty;
System.debug('objQuote @@@@'+objQty.QuoteNumber );


//Opportunity fetchOptydata= [SELECT Id  FROM Opportunity WHERE Id=: oOpportunity.id];

       //System.debug('***Sales_Org__c****' +fetchQuoteData.Sales_Org__c);
        
    Messaging.InboundEmail email  = new Messaging.InboundEmail();
    Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
    
    Messaging.InboundEmail.TextAttachment attachmenttext = new Messaging.InboundEmail.TextAttachment();
    attachmenttext.body = 'my attachment text';
    attachmenttext.fileName = 'textfiletwo.txt';
    attachmenttext.mimeTypeSubType = 'texttwo/plain';

    //String bcc = System.Label.TR_Bcc_Email_Address;
    String bcc = 'proviewmaildispatchnotification@1rtr5y4mwiql098iy7zfx6kg928v1kum8witrlcn0tnvpv9vuz.n-93kheay.cs30.apex.sandbox.salesforce.com';
    email.plainTextBody = 'Test';
    email.fromAddress = 'test@test.com';
    String contactEmail = 'test@domain.com';
    email.ccAddresses = new String[] {bcc};
    email.subject = 'This is test for - '+oOpportunity.id;
    email.textAttachments =   new Messaging.inboundEmail.TextAttachment[] { attachmenttext };
     
    email.htmlBody='<html><title>This s A test mail</title><body>Hi i am here.</body></html>';
    ///////////////////////////////////////////////////////
    
    Messaging.InboundEmail.BinaryAttachment inAtt = new Messaging.InboundEmail.BinaryAttachment();
    inAtt.body = blob.valueOf('test');
    inAtt.fileName = 'my attachment name';
    inAtt.mimeTypeSubType = 'plain/txt';

    email.binaryAttachments = new Messaging.inboundEmail.BinaryAttachment[] {inAtt }; 

    // call the class and test it with the data in the testMethod
    Test.startTest();
    ProviewmailHandler emailServiceObj = new ProviewmailHandler();
    emailServiceObj.handleInboundEmail(email, env); 
    Test.stopTest();
    }
}