@isTest
private class CaseMgmtEmailHandler_Test{
    static testmethod void TestEmailToSalesforce(){
        UnitTest.createTestData();
        
        //Preparing test data for Case
        Case objCase = new Case();
        objCase.Status = 'Closed'; 
        objCase.Origin = 'Other';
        objCase.CurrencyIsoCode = 'USD';
        INSERT objCase;
        Case fetchCaseData = [SELECT CaseNumber FROM Case WHERE Id=: objCase.Id]; 
        
        //Preparing test data for SalesOrgMapping__c Custom Setting
        SalesOrgMapping__c salesMap = new SalesOrgMapping__c();
        salesMap.name= 'LLEY';
        salesMap.Language__c = 'Spanish';        
        INSERT salesMap; 
        
        Messaging.InboundEmail email  = new Messaging.InboundEmail();
        Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();

        Messaging.InboundEmail.TextAttachment attachmenttext = new Messaging.InboundEmail.TextAttachment();
        attachmenttext.body = 'my attachment text';
        attachmenttext.fileName = 'textfiletwo.txt';
        attachmenttext.mimeTypeSubType = 'texttwo/plain';

        String bcc = System.Label.TR_Bcc_Email_Address;
        //email.plainTextBody = 'Test';
        email.fromAddress = 'test@test.com';
        String contactEmail = 'test@domain.com';
        email.ccAddresses = new String[] {bcc};
        email.subject = 'Case -' +fetchCaseData.CaseNumber;
        //email.subject = 'Case- '+fetchCaseData.CaseNumber;
        email.plainTextBody = 'Hello -- This is the body of test mail !';
        email.textAttachments =   new Messaging.inboundEmail.TextAttachment[] { attachmenttext };        
        email.htmlBody='<html><title>This s A test mail</title><body>Hi i am here.</body></html>';
        
        Messaging.InboundEmail.BinaryAttachment inAtt = new Messaging.InboundEmail.BinaryAttachment();
        inAtt.body = blob.valueOf('test');
        inAtt.fileName = 'my attachment name';
        inAtt.mimeTypeSubType = 'plain/txt';

        email.binaryAttachments = new Messaging.inboundEmail.BinaryAttachment[] {inAtt }; 

        // Call the class and test it with the test data
        Test.startTest();
        CaseMgmtEmailHandler emailServiceObj = new CaseMgmtEmailHandler();
        emailServiceObj.handleInboundEmail(email, env ); 
        Test.stopTest();
    }
}