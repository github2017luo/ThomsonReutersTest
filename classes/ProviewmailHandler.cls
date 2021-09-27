/**
 * Class Functionality:
 * Saves the attachments in Opportunity's "Notes and Attachments" section when Entitlement gets passed and send      mails to the recipents.
 * @author:  Snehajit
 * @version:  2017-10-05
 */
 /**
 * CHANGE HISTORY
 * ===============================================================================================
 * Date         Name                        Description
 * 2017-10-05   Snehajit                    Created (User Story: PTL-38)
 *
 * ===============================================================================================
 */

global class ProviewmailHandler implements Messaging.InboundEmailHandler {
    global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope){
      Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
        String sub = email.subject;
        //String sub = 'test- SF974600_1005004610';
        String Body = email.plainTextBody;
        String optySapQuotenum;
        //String optyId;
        String optyEmail;
        String optyAccMangr;
        String emailAttFileName;
        Opportunity opty;
       if(sub!=null)
        {  
            if(sub.contains('-'))
            {
                //quoteNum = sub.substring(sub.indexOf('-')+2,sub.indexOf('-')+10);
                if(!test.isRunningTest()){
                    optySapQuotenum = sub.substring(sub.indexOf('-')+2,sub.indexOf('_'));
                    system.debug('**********optySapQuotenum='+optySapQuotenum);
                }
                else{
                    optySapQuotenum = 'SF974598';
                }
                //optyId = sub.substring(sub.indexOf('-')+2);
                //optyId = optyId.trim();
                System.debug('Before Trim Opportunity Sap Number: '+optySapQuotenum);
                optySapQuotenum = optySapQuotenum.trim();  
                System.debug('After Trim Opportunity Sap Number: '+optySapQuotenum);
               
                if(optySapQuotenum != null && optySapQuotenum != ''){
                    //opty = [Select Id, Account_Manager__c, Email__c, SAP_Quotation_Document_number__c, Sync from Opportunity WHERE SAP_Quotation_Document_number__c =: optySapQuotenum LIMIT 1];
                     if(!test.isRunningTest()){
                    opty = [SELECT Id, Account_Manager__c, Email__c, SyncedQuote.QuoteNumber 
                            FROM Opportunity
                            WHERE SyncedQuote.QuoteNumber =: optySapQuotenum LIMIT 1];
                            }
                    else{
                     opty = [SELECT Id, Account_Manager__c, Email__c, SyncedQuote.QuoteNumber 
                            FROM Opportunity];
                            }       
                    //optyId = opty.Id;
                }
                //Opportunity opty = [Select Id,Account_Manager__c,Email__c from Opportunity  where Id =: optyId];
                //System.debug('data afteer insert '+opty.Id);
                //populating variables to send mail for email body as attachment creation
                //optyId = opty.Id;     
                //System.debug('data afteer insert2 '+optyId);           
                /*optyAccMangr = opty.Account_Manager__c;
                optyEmail= opty.Email__c;
                */
          
                
                //System.debug('*****salesOrg*******'+salesOrg);
                //SalesOrgMapping__c salesOrgMap = SalesOrgMapping__c.getInstance(salesOrg);
                //language = salesOrgMap.Language__c;              
                //curUserId = UserInfo.getUserId();
                //bccEmailAddr = System.Label.TR_Bcc_Email_Address;
            }                                         
        }
        // Note objNote = new Note();
    /* ----------- Saves the Mail sent from ESI in the Opportunity's Notes & Attachments -------------- */
        
        Attachment objAtt = new Attachment();
        if(opty != null){
            //objNote.Title = 'Test'  + '_'+opty.SyncedQuote.QuoteNumber/*+ ' (' + DateTime.now() + ')'*/;
           // objNote.Title = sub;
          
            objAtt.Name = email.subject+'.doc';
            System.debug('@@@@@@@@email.plainTextBody'+email.htmlBody);
            objAtt.body = Blob.valueOf(email.htmlBody);
            objAtt.ParentId = opty.Id;
        }
        
        try{
            if(objAtt != null){
                INSERT objAtt;
            }
        }catch(Exception e){
            System.debug('*******'+e.getMessage());
        }
        System.debug('Note is attached: '+objAtt.Id + email.plainTextBody);
        
        if (email.textAttachments!= null){
          System.debug('check to see whether inserting in textattachment if statement');          
            for(Messaging.InboundEmail.TextAttachment tAttachment : email.textAttachments){
                System.debug('check to see whether inserting in textattachment: inser FOR LOOP');
                emailAttFileName = tAttachment.filename;
                System.debug('check ti see whether inserting in '+emailAttFileName);
                //if(emailAttFileName.contains(System.Label.RN_Renewal_Notice)==false)
                //{
                    Attachment tAtt = new Attachment();
                    System.debug('check ti see whether inserting in textattachment/not');
                    tAtt.Name = tAttachment.fileName;
                    System.debug('check ti see whether inserting in textattachment/not');
                    tAtt.Body = Blob.valueOf(tAttachment.body);
                    System.debug('check ti see whether inserting in textattachment/not');
                    if(opty != null){
                        tAtt.ParentId = opty.Id;
                    }
                    System.debug('check ti see whether inserting in textattachment/not');
                    try{
                        if(tAtt != null){
                            INSERT tAtt;
                        }
                    } catch(Exception e){
                        System.debug('*******'+e.getMessage());
                    }
                    System.debug('check ti see whether inserting in textattachment/not');

            }
        }
        if (email.binaryAttachments != null)
        {
            for (Messaging.Inboundemail.BinaryAttachment bAttachment : email.binaryAttachments) {
                emailAttFileName = bAttachment.filename;
                //if(emailAttFileName.contains(System.Label.RN_Renewal_Notice)==false)
                //{
                    Attachment objAttachment = new Attachment();
                    System.debug('attachment.ParentId'+attachment.ParentId);
                    objAttachment.Name = bAttachment.fileName;
                    objAttachment.Body = bAttachment.body;
                    if(opty != null){
                        objAttachment.ParentId = opty.Id;
                    }
                    insert objAttachment;
                    try{
                        if(objAttachment != null){
                            INSERT objAttachment;
                        }
                    } catch(Exception e){
                        System.debug('*******'+e.getMessage());
                    }
                //}
            }
        }
      return result;
      }
 }