/***********************************************************************************************
Purpose      : Add Task in Case when Replied 
Developed By : TCS Offshore-Case Manangement
Date         : 12/02/2016
Changed Log  :
************************************************************************************************/
global class CaseMgmtEmailHandler implements Messaging.InboundEmailHandler {
    global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope) {
        Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
        String strMailSub = email.subject;
        String strMailBody = email.plainTextBody;
        System.debug('Body: '+strMailBody);
        System.debug('sub: '+strMailSub);
        String caseNum;
        Case objParentCase = new Case();
        
        try{
        
        
            if(strMailSub!=null)
            {  
                if(strMailSub.contains('-'))
                {
                    caseNum = strMailSub.substring(strMailSub.lastIndexOf('-')+1,strMailSub.lastIndexOf('-')+9);
                    System.debug('Case No from Email : '+caseNum);
                    if(caseNum!=null){
                        objParentCase = [Select Id from Case where CaseNumber =: caseNum]; 
                    }               
                }                                         
            }
            ///Insert Task as email body
            if(objParentCase.Id!=null){
                Task objTaskForCase = new Task();
                
                objTaskForCase.Subject = strMailSub;
                objTaskForCase.Description = strMailBody;
                objTaskForCase.WhatId = objParentCase.Id;
                objTaskForCase.Type = 'Inbound Email';
                //objTaskForCase.LCRM_Activity_Type__c = 'Inbound Email';
                objTaskForCase.ActivityDate=system.today();
                
                Database.SaveResult lsr = Database.insert(objTaskForCase);
                
                //insert attachment in case
                if (email.textAttachments!= null){
                    List<Attachment> lstTextAttachment = new List<Attachment>();
                    for(Messaging.InboundEmail.TextAttachment tAttachment : email.textAttachments){                
                        Attachment textAttachment = new Attachment();
                        textAttachment.Name = tAttachment.fileName;
                        textAttachment.Body = Blob.valueOf(tAttachment.body);
                        textAttachment.ParentId = objParentCase.Id;
                        lstTextAttachment.add(textAttachment);    
                    }
                    Database.SaveResult[] lsr1 = Database.insert(lstTextAttachment,false);  
                    System.debug('Text Attachment Inserted');     
                }
                System.debug('After Text Attachment Code Execution');
                if (email.binaryAttachments != null)
                {
                    List<Attachment> lstBinaryAttachment = new List<Attachment>();
                    for (Messaging.Inboundemail.BinaryAttachment bAttachment : email.binaryAttachments) {                
                        Attachment attachment = new Attachment();                
                        attachment.Name = bAttachment.fileName;
                        attachment.Body = bAttachment.body;
                        attachment.ParentId = objParentCase.Id;
                        lstBinaryAttachment.add(attachment);  
                                       
                    }
                    Database.SaveResult[] lsr1 = Database.insert(lstBinaryAttachment,false);  
                    System.debug('Binary Attachment Inserted');   
                } 
                System.debug('After Binary Attachment Code Execution'); 
            }
            else{
                System.debug('Case not found');
            }
        }catch(Exception e){
            System.debug('Exception occured'+e);
        }
                     

    return result;
    }
}