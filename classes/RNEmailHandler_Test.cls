@isTest(SeeAllData=false)

private class RNEmailHandler_Test {

static testmethod void TestEmailToSalesforce(){

        UnitTest.createTestData();
        //Preparing Account data
        Account objAcc = UnitTest.getAccountInstance();
         INSERT objAcc;
        
        //Preparing Opportunity data        
        Opportunity objOpp = UnitTest.getOpportunityInstance(objAcc.Id);
        //objOpp.Sales_Org__c = 'ABEP'; 
        objOpp.Sales_Org__c = 'LLEY';
        objOpp.Renewal_Flag__c = true;
        objOpp.Pricebook2Id = Test.getStandardPricebookId();
        objOpp.Expected_Revenue_Date__c = Date.newInstance(2016, 7, 11);
        INSERT objOpp;
        
        //Preparing Product data
        Product2 objProd=UnitTest.getProductInstance();
        objProd.IsActive = true;
        INSERT objProd;
        
        //Preparing PricebookEntry data
        PricebookEntry testEntry = new PricebookEntry(isactive=true,Pricebook2id=Test.getStandardPricebookId(),Product2Id=objProd.id,unitprice=200);
        INSERT testEntry;
        
        //Preparing Quote data
        Quote objQty = new Quote();
        objQty.Name = 'Test Quote';
        objQty.Status = 'Draft';
        objQty.OpportunityId = objOpp.id;
        objQty.Pricebook2Id = Test.getStandardPricebookId();
        objQty.Approval_Status__c = 'Cancellation Approved';
        objQty.Current_Renewal_Options__c= 'Opt-In - Negotiable Renewal';
        objQty.Invoice_Type__c = 'Detailed';
        objQty.Grace_Period_Indicator__c = false;
        objQty.RecordTypeId = Schema.SObjectType.Quote.getRecordTypeInfosByName().get('LATAM Renewal Quote').getRecordTypeId();   
        INSERT objQty;
        
        Quote fetchQuoteData = [SELECT QuoteNumber,Sales_Org__c  FROM Quote WHERE Id=: objQty.id];
        
        SalesOrgMapping__c salesMap = new SalesOrgMapping__c();
        //salesMap.name= 'ABEP';
        salesMap.name= 'LLEY';
        salesMap.Language__c = 'Spanish';
        salesMap.Renewal_email__c = 'renovacion.subscripciones@thomsonreuters.com';
        salesMap.Sales_Org_Desc__c = 'Abeledo Perrot';
        salesMap.TR_Business_Address__c = 'Tucumán 1471';
        salesMap.TR_Business_Address_City__c = 'C1050AAC';
        salesMap.TR_Business_Address_Zip__c = 'CABA';
        
        INSERT salesMap; 
      
      
       RenewalNotices__c renewal = new RenewalNotices__c();
       renewal.Name = 'RN OptIn Detailed_(-60)_SPA';
       renewal.Email_Folder__c = 'Renewal Process Email Templates SPA';
       renewal.Email_Template__c = 'RN_OptIn_Without_Grace_Detailed_M60_SPA';
       renewal.Email_Template_Attachment__c = 'RN_OptIn_Without_Grace_Detailed_M60_SPAA';
       renewal.Grace_Period_Indicator__c = false;
       renewal.Invoice_Type__c = 'Detailed';
       renewal.Language__c = 'Spanish';
       renewal.Max_Value__c = 9999;
       renewal.Min_Value__c = -9999;
       renewal.Renewal_Option__c = 'Opt-In - Negotiable Renewal';
      
       INSERT renewal;
       
        //System.debug('***Sales_Org__c****' +fetchQuoteData.Sales_Org__c);
        
    Messaging.InboundEmail email  = new Messaging.InboundEmail();
    Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
    
    Messaging.InboundEmail.TextAttachment attachmenttext = new Messaging.InboundEmail.TextAttachment();
    attachmenttext.body = 'my attachment text';
    attachmenttext.fileName = 'textfiletwo.txt';
    attachmenttext.mimeTypeSubType = 'texttwo/plain';

    String bcc = System.Label.TR_Bcc_Email_Address;
    email.plainTextBody = 'Test';
    email.fromAddress = 'test@test.com';
    String contactEmail = 'test@domain.com';
    email.ccAddresses = new String[] {bcc};
    email.subject = 'Quote is renewed for - '+fetchQuoteData.QuoteNumber;
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
    RNEmailHandler emailServiceObj = new RNEmailHandler();
    emailServiceObj.handleInboundEmail(email, env ); 
    Test.stopTest();
    }
}