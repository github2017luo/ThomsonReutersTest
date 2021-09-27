global without sharing class TRSToreMicrositeapprovalsResp implements Messaging.InboundEmailHandler {


      global static Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope) {
      
          System.debug(loggingLevel.INFO,'Hello Email..........'+email);
          System.debug(loggingLevel.INFO,'Hello envelope..........'+envelope);
          System.debug(loggingLevel.INFO,'Hello Email plainTextBody..........'+email.plainTextBody);
          System.debug(loggingLevel.INFO,'Hello Email fromAddress..........'+email.fromAddress);
          System.debug(loggingLevel.INFO,'Hello Email plainTextBody..........'+email.plainTextBody.startswith('Approve'));
          
         System.debug(loggingLevel.INFO,'Hello Email plainTextBody..........'+email.subject);
          
          string leadId = email.subject.substringAfter('- ');
          
          Lead leadrec = new Lead();
          leadRec = queryLead(leadId);
          
          string approvalsAccepted = 'Request to Quote Create';
          string approvalsRejected = 'Approvals Rejected';
          string approvalsResend = 'Resend Request';
          
          if(Static_Values__c.getAll().containsKey('micrositeApprovedMsg') ){
              approvalsAccepted = Static_Values__c.getAll().get('micrositeApprovedMsg').value__c;
          } 
          
          if(Static_Values__c.getAll().containsKey('micrositeRejectMsg') ){
              approvalsRejected = Static_Values__c.getAll().get('micrositeRejectMsg').value__c;
          } 
          
          if(Static_Values__c.getAll().containsKey('micrositeResendMsg') ){
              approvalsResend = Static_Values__c.getAll().get('micrositeResendMsg').value__c;
          } 
          
          List<Database.saveResult> quoteRes = new List<Database.saveResult>();
          boolean isreqToCreateQuote = false;
          
          if(email.plainTextBody != null && leadRec.Microsite_Lead_Status__c != approvalsRejected && leadRec.Microsite_Lead_Status__c != approvalsAccepted ){
              
              string approvedTxt = 'Approve';
              string rejectedTxt = 'Reject';
              
               if(Static_Values__c.getAll().containsKey('micrositeApprovedApprovals') ){
                    approvedTxt = Static_Values__c.getAll().get('micrositeApprovedApprovals').value__c;
                }
             if(Static_Values__c.getAll().containsKey('micrositeRejectApprovals') ){
                    rejectedTxt = Static_Values__c.getAll().get('micrositeRejectApprovals').value__c;
                } 
              
             integer ApprovedCount = email.plainTextBody.countMatches(approvedTxt);    // Static Custom Settings........
             integer rejectedCount = email.plainTextBody.countMatches(rejectedTxt);    // Static Custom Settings........
             
             System.debug(loggingLevel.INFO,'leadRec.Microsite_Lead_Status__c..........'+ leadRec.Microsite_Lead_Status__c);
             System.debug(loggingLevel.INFO,'ApprovedCount  ..........'+ ApprovedCount  );
             System.debug(loggingLevel.INFO,'ApprovedCount  ..........'+ email.plainTextBody.startswith(approvedTxt));
             
             if( (leadRec.Microsite_Lead_Status__c == approvalsResend || leadRec.Microsite_Lead_Status__c == null || leadRec.Microsite_Lead_Status__c == 'Waiting for Approvals') && ApprovedCount  >= 2 && email.plainTextBody.startswith(approvedTxt)){
 
 
                  leadRec.Microsite_Lead_Status__c = approvalsAccepted;
                  isreqToCreateQuote = true;
                  
                  System.debug(loggingLevel.INFO,'isreqToCreateQuote ..........'+ isreqToCreateQuote );
             
                  
             }else  if((leadRec.Microsite_Lead_Status__c == approvalsResend  || leadRec.Microsite_Lead_Status__c == null || leadRec.Microsite_Lead_Status__c == 'Waiting for Approvals' ) && rejectedCount  >= 2 && email.plainTextBody.startswith(rejectedTxt)){
                 leadRec.Microsite_Lead_Status__c = approvalsRejected;
                 leadRec.Microsite_Approvals_History__c = email.plainTextBody;
                 // Call notes logic to create inbound email service details under Lead
                 
                     createNote(leadrec.id, email.plainTextBody, 'Order rejected by microsite admin '+ email.fromAddress);
                 
                  
             } else if(leadRec.Microsite_Lead_Status__c == null){
             
                 leadRec.Microsite_Lead_Status__c = 'Waiting for Approvals';
             }else{
                 leadRec.Microsite_Lead_Status__c = approvalsResend ;
                 leadRec.Microsite_Approvals_History__c = email.plainTextBody;
                 
                 createNote(leadrec.id, email.plainTextBody, 'Wrong email received by microsite admin '+ email.fromAddress);
                 
             }
             
             
             Database.update (leadrec, false);
             System.debug(loggingLevel.INFO,'Hello isreqToCreateQuote........'+isreqToCreateQuote);
             
             if(isreqToCreateQuote){
             // Call Quote Create logic......
                  LIST<Lead> Reqleads = new LIST<Lead>();
                  reqleads.add(leadRec);
                  quoteRes = TRStore_MicrositeQuote.mapMicrositeProposal(reqleads);
             System.debug(loggingLevel.INFO,'Hello quoteRes........'+quoteRes);
             
             // Call notes logic to create inbound email service details under Quote
                  for(Database.saveResult sv: quoteRes ){
                      if(sv.isSuccess()){
                          createNote(sv.getId(), email.plainTextBody, 'Order Approved by microsite admin '+ email.fromAddress);
                          // Call Lead Convert........................
                          
                           id jobId = system.enqueueJob(new TRStore_LeadConvertQueueable(sv.getId(), leadRec.id, leadRec.Product_Configuration__c, leadRec.email, leadrec.SAPAccountNumber__c));
                           
                           System.debug(loggingLevel.INFO,'Hello Lead convert Quauable........'+jobId );
             
                          
                      }else
                          createNote(leadRec.id, email.plainTextBody, 'Order Approved by microsite admin '+ email.fromAddress);    
                  }
             
              
              }
        }
          
          Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
          return result;
      }
      
      public static lead queryLead(id lid){
      
          Lead l = new Lead();
          
          l = [Select id, email,Microsite_Lead_Status__c, Lead_Region__c, Product_Configuration__c, SAPAccountNumber__c FROM Lead WHERE id =: lid ];
      
          return l;
      }
      
      
       public static Database.SaveResult createNote(String recid, String reqBody, string title){
        System.debug(loggingLevel.INFO,'create noteResult');
  
        Note nt = new Note();

        nt.Title = title;
        String reqBodyStr = '';
        
        if(String.isNotBlank(reqBody)){
            reqBodyStr = reqBody.left(30000);
        }
        nt.Body = reqBodyStr;  
        nt.ParentId = recid;
        nt.IsPrivate = TRUE;

        Database.SaveResult noteResult = Database.insert(nt, false);
        System.debug(loggingLevel.INFO,'noteResult+++'+noteResult);
        return noteResult;
    }
      
      
  }