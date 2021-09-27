/***********************************************************************************************
Purpose      : Add New Case to Parent Case if Parent Case is closed, 
               else add replied email to the case under Email Section with attachments
Developed By : TCS Offshore-Case Manangement - Dinesh Kumar Voonna
Date         : 31/03/2017
Jira Story   : STB-43, STB-44
Changed Log  : 
************************************************************************************************/

global class CaseEmailHandlerANZ implements Messaging.InboundEmailHandler {

   global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope) {
        
        System.debug('Entered into CaseEmailHandlerANZ class' +email);
        
        Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
        
        String strMailSub = email.subject;
        String strMailBody = email.plainTextBody;
        list<String> strMailListCCAddresses = email.ccAddresses;
        list<String> strToAddress = email.toAddresses;
        String strMailFromAddress = email.fromAddress; 
        String strFromName = email.fromName;
        String caseNum;
        
        System.debug('Body: '+strMailBody);
        System.debug('sub: '+strMailSub);
        System.debug('sub: '+strMailFromAddress);
        System.debug('sub: '+strMailListCCAddresses);
        
        Case objParentCase = new Case();
        
        
        try{
          if(strMailSub!=null)
            {  
                if(strMailSub.contains('-'))
                {
                    caseNum = strMailSub.substring(strMailSub.lastIndexOf('-')+1,strMailSub.lastIndexOf('-')+10);
                    System.debug('Case No from Email:'+caseNum.trim());
                    if(caseNum!=null){
                        objParentCase = [Select Id,OwnerId,Owner.name,ContactId,Contact.name,AccountId,Account.name,ContactEmail,ContactPhone,
                                         ANZ_Support_Type__c,Priority,Sales_Org__c,Product__c,ANZ_Issue__c,Reason__c,Origin,Status,Description,RecordTypeId
                                         from Case where CaseNumber =: caseNum.trim()];                        
                        
                        if(objParentCase.id != Null && objParentCase.Status == 'Closed'){
                           Case childCase = new Case();
                           childCase = objParentCase.clone(false,false,false,false);
                           childCase.ParentId = objParentCase.Id;
                           childCase.Status = 'New';
                           childCase.Description = strMailBody;
                           childCase.Subject = strMailSub;
                           childCase.Origin = 'Email';
                           childCase.OwnerId = objParentCase.OwnerId;
                           childCase.ContactId = objParentCase.ContactId;
                           childCase.AccountId = objParentCase.AccountId;                          
                           childCase.ANZ_Support_Type__c = objParentCase.ANZ_Support_Type__c;
                           childCase.Priority = objParentCase.Priority;
                           childCase.Sales_Org__c = objParentCase.Sales_Org__c;
                           childCase.Product__c = objParentCase.Product__c;
                           childCase.ANZ_Issue__c = objParentCase.ANZ_Issue__c;
                           childCase.RecordTypeId = objParentCase.RecordTypeId;
                           childCase.Reason__c = objParentCase.Reason__c; 
                          try{                            
                           Database.SaveResult lsr = Database.insert(childCase);
                          }
                          Catch(Exception e){
                           System.debug('\n\nError4:: ' + e + '\n\n');
                          } 
                          
                        }
                       else{
                           if(strMailBody != Null && strMailBody != ''){
                            EmailMessage em = new EmailMessage();
                            em.Incoming = TRUE;
                            String finalToAddresses;
                            String finalCCAddresses;
                            
                            for(String s : strToAddress){
                              finalToAddresses = finalToAddresses + '; ';
                            }
                            for(String s : strToAddress){
                              finalCCAddresses = finalCCAddresses + '; ';
                            }
                            em.ParentId = objParentCase.id;
                            em.Status =  '0';
                            em.FromAddress = strMailFromAddress; 
                            em.Subject = strMailSub;
                            em.TextBody = strMailBody;
                            
                          try{ 
                            insert em;
                           }
                           Catch(Exception e){
                             System.debug('\n\nError3:: ' + e + '\n\n'); 
                           }
                            
                          if(email.binaryAttachments != Null && email.binaryAttachments.size() > 0){
                              for (integer i = 0 ; i < email.binaryAttachments.size() ; i++) {
                                try{
                                 if (email.binaryAttachments[i].filename != null) { 
                                    Attachment newAttachment = new Attachment(ParentId = em.Id,
                                     Name = email.binaryAttachments[i].filename,
                                     Body = email.binaryAttachments[i].body);
                                     insert newAttachment;                                    
                                 }
                                }
                                 catch(Exception e) {
                                    System.debug('\n\nError1:: ' + e + '\n\n');
                                } 
                              }
                           }
                           if (email.textAttachments!=null && email.textAttachments.size() > 0) {
                                for (Integer i = 0 ; i < email.textAttachments.size() ; i++) {
                                    try {
                                        if (email.textAttachments[i].filename != null) { 
                                            Attachment newAttachment = new Attachment(ParentId = em.Id,
                                            Name = email.textAttachments[i].filename,
                                            Body = Blob.valueOf(email.textAttachments[i].body) );
                                            insert newAttachment;
                                         }
                                    }
                                    catch (Exception e) {
                                    System.debug('\n\nError2:: ' + e + '\n\n');
                                   }
                                }
                            }
                          
                          }
                       }
                    }               
                }                                         
            }
         } 
        Catch(Exception e){
               System.debug('Exception occured'+e);
        }   
   return result;
   }

}