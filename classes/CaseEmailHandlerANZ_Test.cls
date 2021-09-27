@isTest
private class CaseEmailHandlerANZ_Test{
    static testmethod void TestEmailToSalesforce1(){
     Case objCase = new Case();
        objCase = UnitTest.getCaseInstance();
        objCase.Status = 'New';
        INSERT objCase;
     Case fetchCaseData = [SELECT CaseNumber FROM Case WHERE Id=: objCase.Id]; 
     
     Messaging.InboundEmail email  = new Messaging.InboundEmail();
     Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();  
     EmailMessage em = new EmailMessage();
    
    Test.startTest(); 
    String strToAddress = Label.ANZ_EmailService_Label;
    email.fromAddress = 'test@test.com';
    String contactEmail = 'test@domain.com';
    email.toAddresses = new String[]{strToAddress};
    email.ccAddresses = new String[] {strToAddress};
    email.subject = 'Case - '+fetchCaseData.CaseNumber;    
    email.plainTextBody = 'Hello -- This is the body of test mail !';   
    
    Messaging.InboundEmail.TextAttachment attachmenttext = new Messaging.InboundEmail.TextAttachment();
    attachmenttext.body = 'my attachment text1';
    attachmenttext.fileName = 'textfiletwo.txt';
    attachmenttext.mimeTypeSubType = 'texttwo/plain';
    
    Messaging.InboundEmail.BinaryAttachment inAtt = new Messaging.InboundEmail.BinaryAttachment();
    inAtt.body = blob.valueOf('test attachment 2');
    inAtt.fileName = 'my attachment name';
    inAtt.mimeTypeSubType = 'plain/txt';
    
    email.textAttachments = new Messaging.inboundEmail.TextAttachment[] { attachmenttext };        
    email.htmlBody = '<html><title>This s A test mail</title><body>Hi i am here.</body></html>';
    email.binaryAttachments = new Messaging.inboundEmail.BinaryAttachment[] {inAtt }; 
    
    CaseEmailHandlerANZ emailServiceObj = new CaseEmailHandlerANZ();
    emailServiceObj.handleInboundEmail(email, env ); 
    Test.stopTest();        
    
    }
     static testmethod void TestEmailToSalesforce2(){
     Case objCase = new Case();
        objCase = UnitTest.getCaseInstance();
        objCase.Status = 'Closed';
        INSERT objCase;
     Case fetchCaseData = [SELECT CaseNumber FROM Case WHERE Id=: objCase.Id]; 
     
     Messaging.InboundEmail email  = new Messaging.InboundEmail();
     Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();  
     
    String toAddress = Label.ANZ_EmailService_Label;
    email.fromAddress = 'test@test.com';
    String contactEmail = 'test@domain.com';
    email.ccAddresses = new String[] {toAddress};
    email.subject = 'Case - '+fetchCaseData.CaseNumber;    
    email.plainTextBody = 'Hello -- This is the body of test mail !';  
    
    Test.startTest();
    CaseEmailHandlerANZ emailServiceObj = new CaseEmailHandlerANZ();
    emailServiceObj.handleInboundEmail(email, env ); 
    Test.stopTest();        
    
    }
 }