/*--**********************************
Class Name: ESC_InboundCaseEmailService
Purpose: Emailhandler class to work on the Incoming Email with Valid or Invalid thread Id
Author:Mousumi Panda
Date Created:24/05/2017
Date Updated:V0:
***********************************/
global class ESC_InboundCaseEmailService implements Messaging.InboundEmailHandler{

    global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope){
    
        Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
       if(ESC_Static_Values__c.getValues('EmailSevice_InboundCaseSwitch').ESC_Value__c == 'ON'){
       
        String subject = email.subject;  //'Sandbox: Hurricane Sandy - A Message from Thomson Reuters    [ ref:_00De0pmED._500e01hTGB:ref ]';
        String body = email.plainTextBody;
        Case thisCase = null;
        
        String casethreadid1;
        String casethreadid2;
       
        if(email.fromAddress == null || 'mailer-daemon@salesforce.com'.equalsIgnoreCase(email.fromAddress))
            return null;

        if(subject != null && subject.contains('[ ref:'))
            casethreadid1 = subject.substring(subject.indexOf('[ ref:')+6);
        else if(body != null && body.contains('ref:_'))
            casethreadid1 = body.substring(body.indexOf('ref:')+4).trim();
        
        if(String.isNotEmpty(casethreadid1))
            casethreadid2 = casethreadid1.split(':')[0];
        
        if(String.isNotEmpty(casethreadid2)){

            Id theCaseID = Cases.getCaseIdFromEmailThreadID(casethreadid2);
            
            List<Case> caseList = [Select AccountId, ContactId,OwnerId ,RecordTypeId,CaseNumber,Status,
                                        Origin 
                                        from Case where Id =:theCaseID];

            if(caseList.isEmpty()){
                return null;
            }   
            else{
            /**********************Task***********************
            //Task Creation
            Task t = new Task();
            t.WhatId = thisCase.Id;
            t.Subject = subject;
            t.OwnerId = caseList[0].OwnerId;
            t.Priority = 'Medium';
            t.Status= 'not started';
           if(thisCase.ContactId != null)
            t.WhoId = thisCase.ContactId;
            try
              {
               insert t;
              }
            catch(Exception e)
              {
               System.debug('The following exception has occurred: ' + e.getMessage());
              }*/
                
            /**********************EmailMessage***********************/
            //EmailMessage on Case related list 
            thisCase = caseList[0];
            EmailMessage emessage= new EmailMessage();
            emessage.ParentId=thisCase.Id;
            //emessage.ReplyToEmailMessageId=email.toAddresses[0];
            emessage.Incoming=ESC_StaticVariables.EmailMessageIncoming;
            emessage.Status=ESC_StaticVariables.EmailMessageStatus;
            emessage.Subject=subject;
            emessage.TextBody=body;
            //emessage.ActivityId=t.Id;
            emessage.ToAddress=email.toAddresses[0];
            emessage.FromAddress = email.fromAddress;
            //emessage.FromName = 'FXAll Client Service',
            
            try
            { 
             insert emessage;
            }
            catch(Exception e)
            {
             System.debug('The following exception has occurred: ' + e.getMessage());
            }
            }
            
             if(thisCase.Status == 'Closed'){
            
                
                List<Id> casIdList= new List<Id>();
            
                //If owner is available online, then case should get assign to the owner            
                if(thisCase.OwnerId.getSObjectType() == User.sObjectType){
     
                    //ESC: Enhanced - How to use UserServicePresence  OmniLogin__c.PresenceID__c is the ID of the ready status
                    //OmniLogin__c os = OmniLogin__c.getInstance(caseOwnerId);
                    
                    List<UserServicePresence> usp_statusidList= [select servicePresenceStatusId from UserServicePresence where IsCurrentState = true and userid=:thisCase.OwnerId limit 1];
                    if (usp_statusidList.size()>0 && ESC_Static_Values__c.getValues('EmailServiceOmniLogin').ESC_Value__c== usp_statusidList[0].servicePresenceStatusId){
                        //ESC: Add logic here - the user is online and email received for a closed case 
                        Task t = new Task(OwnerId = thisCase.OwnerId,WhatId =Caselist[0].id,Subject='Email to Closed Case');
                        insert t;
                         system.debug('Omnichannel Routing'+usp_statusidList);
                    }
                    return null;
                }
                //ESC: As is - If owner of FXAll case is offline, ownership will be changed to the Global Queue HD_TRAN_FXT
              /*  if(thisCase.Origin.equalsIgnoreCase(GeneralProperties__c.getInstance('Case_Origin_FXAll_Email').value__c)){
                    
                    if(thisCase.OwnerId.getSObjectType() == User.sObjectType){

                        String fxallQueue = GeneralProperties__c.getInstance('FXAll_Queue').value__c;
                        Group fxAllGrp = [Select Id from Group where type='Queue' and Name= :fxallQueue];
                        thisCase.OwnerId = FXAllGrp.Id;
                        
                        update thisCase;
                        //ESC: TODO: Return proper result in this case. Once assigned, there is no further processing required.
                        return null;
                    }
                }*/
            }
            
          
        }
        else{ //No case reference detected; Auto-response start
            
            if(isValidEmailForResonse(subject)){
              Contact c = [select id, Email from Contact where email <> null limit 1];
                String contactus = '(https://customers.reuters.com/crmcontactus/support.asp)';
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                String[] toAddresses = new String[] {email.fromAddress};
                mail.setToAddresses(toAddresses);
                mail.setTargetObjectId(c.Id);
                //mail.setWhatId(thisCase.Id);

                mail.setSenderDisplayName(ESC_Static_Values__c.getValues('EmailSevice_EmailTemplateName').ESC_Value__c);
                mail.setReplyTo(ESC_Static_Values__c.getValues('EmailSevice_EmailReplyTo').ESC_Value__c); ///**********************
                ESC_Static_Values__c escstatic = ESC_Static_Values__c.getValues('EmailSevice_EmailTemplateName');
                 EmailTemplate templateId;
                if(Test.isRunningTest()){
                   templateId = [Select id,Subject from EmailTemplate limit 1];
                }else{
                   templateId = [Select id,Subject from EmailTemplate where developername =: escstatic.ESC_Value__c limit 1];
                }
                mail.setTemplateID(templateId.Id);
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            }
        }
      }
        return result;
    
    }
    
    private boolean isValidEmailForResonse(String subjectLine){
        boolean retvalue = true;
        for(InvalidEmail__mdt subject:[Select MasterLabel,developername from InvalidEmail__mdt]){
            if(subjectLine.contains(subject.MasterLabel)){
                retValue = false;
                break;
            }
        }
        return retValue;
    }

}