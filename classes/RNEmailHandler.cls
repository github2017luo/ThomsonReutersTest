/***********************************************************************************************
Purpose      : Add Attachments to Quote and send mail with attachments with renewal notices 
Developed By : TCS Offshore-Renewal Notice
Date         : 07/20/2016
Changed Log  :
************************************************************************************************/
global class RNEmailHandler implements Messaging.InboundEmailHandler {
    global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope) {
        Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
        String sub = email.subject;
        String Body = email.plainTextBody;
        System.debug('Body: '+Body );
        System.debug('sub: '+sub);
        String optyNum;
        String quoteId;
        String optyId;
        String quoteNum;
        String renewalType;
        String invType;
        String salesOrg;
        Boolean graceIndicator;
        Decimal daysLeft;
        String language;
        String curUserId;
        String bccEmailAddr;
        String templateAttName;
        String templateAttNameId;
        String emailAttFileName;
        
        
        
        if(sub!=null)
        {  
            if(sub.contains('-'))
            {
                //quoteNum = sub.substring(sub.indexOf('-')+2,sub.indexOf('-')+10);
				quoteNum = sub.substring(sub.indexOf('-')+2);
                quoteNum = quoteNum.trim();  
                System.debug('Before Trim Quote Id: '+quoteNum);
                Quote c = [Select Id,OpportunityId,Opportunity_ID__c,QuoteNumber,Current_Renewal_Options__c,Invoice_Type__c,Sales_Org__c,Grace_Period_Indicator_TR__c,Days_Left_Until_Renewal__c from Quote where QuoteNumber =: quoteNum];
               
                //populating variables to send mail for email body as attachment creation
                quoteId = c.Id;                
                renewalType = c.Current_Renewal_Options__c;
                invType = c.Invoice_Type__c;
                salesOrg = c.Sales_Org__c;
                graceIndicator = c.Grace_Period_Indicator_TR__c;
                daysLeft = c.Days_Left_Until_Renewal__c;
                
                //System.debug('*****salesOrg*******'+salesOrg);
                SalesOrgMapping__c salesOrgMap = SalesOrgMapping__c.getInstance(salesOrg);
                language = salesOrgMap.Language__c;              
                curUserId = UserInfo.getUserId();
                bccEmailAddr = System.Label.TR_Bcc_Email_Address;
            }                                         
        }
        ///Insert note as email body
        /*Note note = new Note();
        
        note.Title = email.fromName + '_'+quoteId+ ' (' + DateTime.now() + ')';
        note.Body = email.plainTextBody;
        note.ParentId = quoteId;
        insert note;
        System.debug('Note is attached: '+note.Id + email.plainTextBody);*/

        if (email.textAttachments!= null)
        {
                    
            for(Messaging.InboundEmail.TextAttachment tAttachment : email.textAttachments)
            { 
                emailAttFileName = tAttachment.filename;
                if(emailAttFileName.contains(System.Label.RN_Renewal_Notice)==false)
                {
                    Attachment tAtt = new Attachment();
                    tAtt.Name = tAttachment.fileName;
                    tAtt.Body = Blob.valueOf(tAttachment.body);
                    tAtt.ParentId = quoteId;
                    insert tAtt;
                }
            }
        }
        if (email.binaryAttachments != null)
        {
            for (Messaging.Inboundemail.BinaryAttachment bAttachment : email.binaryAttachments) {
                emailAttFileName = bAttachment.filename;
                if(emailAttFileName.contains(System.Label.RN_Renewal_Notice)==false)
                {
                    Attachment attachment = new Attachment();
                    System.debug('attachment.ParentId'+attachment.ParentId);
                    attachment.Name = bAttachment.fileName;
                    attachment.Body = bAttachment.body;
                    attachment.ParentId = quoteId;
                    insert attachment;
                }
            }
        }
        //RN_Only_For_Attachment
        if(email.htmlBody != null && email.subject != null && sub.contains(System.Label.RN_Only_For_Attachment)==false)
        {
            Attachment emailBody = New Attachment ();
            emailBody.ContentType = 'application/pdf';            
            
             
            emailBody.ParentId = quoteId;
            emailBody.Name = 'Email_Body'+'.pdf';
            //fetching related email attachment
            List<RenewalNotices__c> renNoticeRecords = RenewalNotices__c.getall().values();
            System.debug('**alltemps****' +renNoticeRecords);
            //added by AG 09-Sep-2016
            daysLeft=daysLeft*(-1);
            for(RenewalNotices__c rec: renNoticeRecords){
                if((invType == rec.Invoice_Type__c) &&(renewalType == rec.Renewal_Option__c) && 
                (graceIndicator == rec.Grace_Period_Indicator__c)&& (daysLeft >= rec.Min_Value__c && daysLeft <= rec.Max_Value__c) &&
                (language == rec.Language__c)){
                    templateAttName = rec.Email_Template_Attachment__c;
                }
            }
            
            //Fetching templateAttNameId
            templateAttNameId = [Select Id from EmailTemplate where name =: templateAttName].Id;
            
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            message.toAddresses = new String[] {bccEmailAddr};
            //message.subject = 'For saving attachment';
            //message.plainTextBody = 'This is the message body.';
            message.setWhatId(quoteId);
            message.setTemplateID(templateAttNameId); 
            message.setTargetObjectId(curUserId);
            message.setSaveAsActivity(false);
            Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage> {message};
            Messaging.SendEmailResult[] results=new List<Messaging.SendEmailResult>();
            
            try{
                Messaging.sendEmail(messages);
            }catch(Exception e){}
            
            if (results.size()>0 && results[0].success) {
                System.debug('The email was sent successfully.');
            } else {
                System.debug('The email failed to send: '); //+ results[0].errors[0].message
            }



            
            //insert emailBody;
        }
        
        


        
    return result;
    }
}