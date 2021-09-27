/*
===============================================================================
LCRMTrialNotifyOBATeamCtrl
===============================================================================

PURPOSE: Controller Class for LCRMTrialNotifyOBATeamPage Page

COMMENTS:

CHANGE HISTORY
===============================================================================
DATE            NAME                    DESC
2017-08-21      Rajesh                  Created 
===============================================================================
*/

Public without sharing Class LCRMTrialNotifyOBATeamCtrl{
    //Properties
    public Opportunity opp {get;set;}
    public emailTemplateWrap emailTemplateObj{get;set;}
    public String mailHeaderUrl{get;set;}
    public Boolean errorFlag{get;set;}
    public Boolean showTemplateScreen{get;set;}
    public String notifyType{get;set;}
    public String contractID{get;set;}
    public String contractNo{get;set;}
    
    //contructor
    public LCRMTrialNotifyOBATeamCtrl(ApexPages.StandardController controller){
        //notifyType = 'Update Trial';
        showTemplateScreen = false;
        errorFlag = false;
        emailTemplateObj = new emailTemplateWrap();
        try{
            Id oppID = ((Opportunity)controller.getRecord()).ID;
             if(Schema.sObjectType.Opportunity.isAccessible() && Schema.sObjectType.Opportunity.isQueryable())
            {opp = [SELECT ID, Name, StageName, Renewal_Flag__c, Expected_End_Date__c, LCRM_Sub_BU__c, accountID, account.Name, Expiration_Date__c, Is_GLI__c, CurrencyIsoCode, LCRM_Split_On__c, LCRM_Transaction_Type__c, LCRM_Target_Opportunity__c, Key_Contact__c, Key_Contact__r.Email, Key_Contact__r.Name, ownerid, (SELECT ID from OpportunityLineItems) FROM OPPORTUNITY WHERE ID = :oppID];}
            System.debug('opp : '+opp);
            //try{
            User userObj = new User();
            if(Schema.sObjectType.User.isAccessible() && Schema.sObjectType.User.isQueryable())
               //if(Schema.sObjectType.User.isQueryable())
               {userObj = [SELECT ID, Name, Email from User where ID = :opp.ownerId];}
                emailTemplateObj.fromAddName = userObj.Name;
                emailTemplateObj.fromAddEmail = userObj.Email;
            //}catch(Exception e){}
            System.debug('opp.OpportunityLineItems : '+opp.OpportunityLineItems);
            //if opp is having no products add error on ui
            if(opp.OpportunityLineItems == null || opp.OpportunityLineItems.size()==0){
                errorFlag = true;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,System.Label.LCRM_TrialNotifyOBANoProdError));
            }
            System.debug('opp.StageName : '+opp.StageName);
            Set<String> excludeStages = new Set<String>();
            excludeStages.addAll(getCustomSettingData('LCRMTrialNotifyOBA_ExcludeStages'));
            System.debug('excludeStages : '+excludeStages);
            //if opp stage is excluded for this functionality add error on ui
            if(excludeStages.contains(opp.StageName)){
                errorFlag = true;
                String errorMsg = System.Label.LCRM_TrialNotifyOBAStageError;
                String stages = '';
                for(String str : excludeStages){
                    if(str!=null && str!='')stages = (stages==null || stages=='')?str:stages + ', ' + str;
                }
                if(stages!=null && stages!=''){
                    stages = stages.reverse();
                    stages = stages.replaceFirst(',','ro ');
                    stages = stages.reverse();
                    errorMsg = errorMsg.replace('<stages>',stages);
                }
                
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, errorMsg));
            }
            emailTemplateObj.relatedToOpp = opp.name;
        }catch(Exception e){
            System.debug('Exception : '+e.getMessage());
            System.debug('Exception trace : '+e.getStackTraceString());
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage()));
            errorFlag = true;
        }
    }
    
    //method used to get notify types list  
    public List<selectOption> getNotifyTypesList(){
        List<SelectOption> options = new List<SelectOption>();
        Set<String> notifyTypes = new Set<String>();
        notifyTypes.addAll(getCustomSettingData('LCRMTrialNotifyOBA_NotifyTypes'));
        options.add(new SelectOption('','--none--'));
        for(String str : notifyTypes){
            options.add(new SelectOption(str,str));
        }
        return options;
    }
    
    //method to fetch data from KeyValueStore(custom setting) based on label and split the value by comma and return as set
    public List<String> getCustomSettingData(String keyLabel){
        List<String> dataList = (KeyValueListStore__c.getValues(keyLabel) == null || 
                                   KeyValueListStore__c.getValues(keyLabel).TextValue__c == null || 
                                   KeyValueListStore__c.getValues(keyLabel).TextValue__c == '')?
                                   new List<String>():
                                   KeyValueListStore__c.getValues(keyLabel).TextValue__c.split(',');
        return dataList;
    }
    
    //method added for a dummy callout from page
    public void dummy(){}
    
    //method used to pull email template information according to notification type selection
    public void selectNotifyType(){
        errorFlag = false;
        //if notification type is not selected add error on ui
        if(notifyType == null || notifyType == ''){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.LCRM_TrialNotifyOBASelectTypeError));
            return;
        } 
        //if notification type is unpaid trial and contract is not selected then add error on ui
        if(notifyType == 'Update Trial' && (contractId == null || contractId == '')){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.LCRM_TrialNotifyOBASelectContractError));
            return;
        }
        String toAddLbl = 'LCRMTrialNotifyOBA_EmailGroup';
        emailTemplateObj.toAdd = (KeyValueListStore__c.getValues(toAddLbl) == null || 
                                   KeyValueListStore__c.getValues(toAddLbl).TextValue__c == null || 
                                   KeyValueListStore__c.getValues(toAddLbl).TextValue__c == '')?
                                   '':KeyValueListStore__c.getValues(toAddLbl).TextValue__c;
        //if email group configration for oba team is not found then add error on ui
        if(emailTemplateObj.toAdd == null || emailTemplateObj.toAdd == ''){
            errorFlag = true;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.LCRM_TrialNotifyOBAToError));
            return;
        }
        //code to generate url for image used as header on email
        mailHeaderUrl = 'https://c.<instance>.content.force.com/servlet/servlet.ImageServer?id=<document_id>&oid=<organization_id>';
        String s = System.URL.getSalesforceBaseUrl().getHost();
        System.debug('s :'+s);
        List<String> urlList = s.split('\\.');
        System.debug('urlList :'+urlList);
        if(urlList!=null && urlList.size()>2){
            mailHeaderUrl = mailHeaderUrl.replace('<instance>',urlList[1]);
        }
        try{
            Document doc=new Document();
            if(Schema.sObjectType.Document.isAccessible() && Schema.sObjectType.Document.isQueryable())
            {doc = [SELECT ID FROM Document where DeveloperName = 'LCRMTrialWizardHeader'];}
            mailHeaderUrl = mailHeaderUrl.replace('<document_id>',doc.id);
        }catch(Exception e){
            System.debug('Exception : '+e.getMessage());
        }
        mailHeaderUrl = mailHeaderUrl.replace('<organization_id>',UserInfo.getOrganizationId());
        System.debug('mailHeaderUrl : '+mailHeaderUrl);
        
        //select email template from custom setting data based on notification type selection
        List<String> notifyTypes = new List<String>();
        notifyTypes.addAll(getCustomSettingData('LCRMTrialNotifyOBA_NotifyTypes'));
        List<String> templates = new List<String>();
        templates.addAll(getCustomSettingData('LCRMTrialNotifyOBA_EmailTemp'));
        String selTemplate = '';
        Integer i = 0;
        System.debug('notifyType : '+notifyType);
        if(notifyTypes!=null && templates !=null && notifyTypes.size()==templates .size()){
            for(String str : notifyTypes){
                if(str == notifyType){
                    selTemplate = templates[i];
                    break;
                }
                i = i+1;
            }
        }
        System.debug('selTemplate  : '+selTemplate);
        if(selTemplate!=null && selTemplate!=''){
            
            //if(Schema.SobjectType.EmailTemplate.isAccessible())
            EmailTemplate tempID = new EmailTemplate();
            if(EmailTemplate.sObjectType.getDescribe().IsAccessible())
            {tempID = [SELECT Id,Name,Body,HTMLValue,Subject FROM EmailTemplate WHERE DeveloperName = :selTemplate];}
            emailTemplateObj.subject = tempID.subject;
            emailTemplateObj.body = '<img src="'+mailHeaderUrl+'" width="100%"/><br/><br/>' + tempID.HTMLValue;
            String fullRecordURL = URL.getSalesforceBaseUrl().toExternalForm() + '/' + opp.Id;
            emailTemplateObj.body = emailTemplateObj.body.replace('&lt;link to opportunity&gt;','<a href="'+fullRecordURL+'">'+opp.Name+'</a>');
            emailTemplateObj.body = emailTemplateObj.body.replace('&lt;contact on opportunity&gt;',opp.Key_Contact__r.Name);
            if(contractID!=null && contractID!=''){
                emailTemplateObj.body = emailTemplateObj.body.replace('&lt;trial contract ID&gt;',contractID);
            }
            emailTemplateObj.body = emailTemplateObj.body.replace('&lt;account name&gt;',opp.account.Name);
            emailTemplateObj.body = emailTemplateObj.body.replace('&lt;opportunity ID&gt;',opp.Id);
            emailTemplateObj.body = emailTemplateObj.body.replace('&lt;OpportunityOwnerName&gt;',emailTemplateObj.fromAddName);
        }
        showTemplateScreen = true;
    }
    
    //method used to send email after contract creation
    public PageReference sendEmail(){
        PageReference pg = null;
        try{
            // Step 0: Create a master list to hold the emails we'll send
            List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
      
            // Step 1: Create a new Email
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            
            // Step 2: Set list of people who should get the email
            List<String> sendTo = new List<String>();
            List<String> addToList = new List<String>();
            System.debug('emailTemplateObj.addToAdd : '+emailTemplateObj.addToAdd);
            if(emailTemplateObj.addToAdd!=null && emailTemplateObj.addToAdd!=''){
                addToList = emailTemplateObj.addToAdd.split(';');
                if(addToList!=null && addToList.size()>0){
                    for(String str : addToList){
                        sendTo.add(str.trim());
                    }
                }
            }
            if(emailTemplateObj.toAdd !=null && emailTemplateObj.toAdd!=''){
                sendTo.add(emailTemplateObj.toAdd);
            }
            System.debug('sendTo : '+sendTo);
            mail.setToAddresses(sendTo);
            
            // Step 3: Set who the email is sent from
            mail.setReplyTo(emailTemplateObj.fromAddEmail);
            mail.setSenderDisplayName(emailTemplateObj.fromAddName);
            
            // (Optional) Set list of people who should be CC'ed
            List<String> ccTo = new List<String>();
            List<String> ccToList = new List<String>();
            if(emailTemplateObj.ccAdd!=null && emailTemplateObj.ccAdd!=''){
                ccToList = emailTemplateObj.ccAdd.split(';');
                if(ccToList!=null && ccToList.size()>0){
                    for(String str : ccToList){
                        ccTo.add(str.trim());
                    }
                }
            }
            System.debug('ccTo : '+ccTo);
            
            if(ccTo!=null && ccTo.size()>0){
                mail.setCcAddresses(ccTo);
            }
            
            // (Optional) Set list of people who should be BCC'ed
            List<String> bccTo = new List<String>();
            List<String> bccToList = new List<String>();
            if(emailTemplateObj.bccAdd!=null && emailTemplateObj.bccAdd!=''){
                bccToList = emailTemplateObj.bccAdd.split(';');
                if(bccToList!=null && bccToList.size()>0){
                    for(String str : bccToList){
                        bccTo.add(str.trim());
                    }
                }
            }
            System.debug('bccTo : '+bccTo);
            
            if(bccTo!=null && bccTo.size()>0){
                mail.setBccAddresses(bccTo);
            }
            
            // Step 4. Set email contents - you can use variables!
            mail.setSubject(emailTemplateObj.subject);
            
            //if(emailTemplateObj.body.contains('<ContactFirstName>')){
            //    emailTemplateObj.body = emailTemplateObj.body.replace('<ContactFirstName>',getSelContactName());
            //}else{
            //    emailTemplateObj.body = emailTemplateObj.body.replace('Dear ,','Dear ' + getSelContactName()+ ',');
            //}
            String body = emailTemplateObj.body;
            mail.setHtmlBody(body);
            
            // Step 5. Add your email to the master list
            mails.add(mail);
            
            System.debug('Mails : '+mails);
            
            // Step 6: Send all emails in the master list
            Messaging.sendEmail(mails);
            Task taskObj = new Task();
            taskObj.Type = 'Email';
            String toaddr = emailTemplateObj.toAdd;
            taskObj.Description = 'To: ' + emailTemplateObj.toAdd +
                            'Additional To: ' + emailTemplateObj.addToAdd +
                            '\nCC: ' + emailTemplateObj.ccAdd +
                            '\nBCC: ' + emailTemplateObj.bccAdd +
                            '\nAttachment: ' +
                            '\nSubject: ' + emailTemplateObj.subject +
                            '\nBody: ' + emailTemplateObj.body;
            taskObj.ActivityDate = Date.Today();
            taskObj.Status = 'Completed';
            taskObj.whatId = opp.Id;
            //if(toAddSplit!=null && toAddSplit.size()>0){
            //    taskObj.whoId = toAddSplit[0];
            //}
            taskObj.subject = 'Email:'+emailTemplateObj.subject;
            if(Schema.sObjectType.Task.isCreateable())
            {insert taskObj;}
            System.debug('taskObj : '+taskObj);
            pg = new PageReference('/'+opp.ID);
        }catch(Exception e){
            System.debug('Exception : '+e.getMessage());
            System.debug('Exception trace : '+e.getStackTraceString());
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage()));
        }
        return pg;
    }
    
    //wrapper used for email template
    public class emailTemplateWrap{
        public String fromAddName{get;set;}
        public String fromAddEmail{get;set;}
        public String relatedToOpp{get;set;}
        public String toAdd{get;set;}
        public String addToAdd{get;set;}
        public String ccAdd{get;set;}
        public String bccAdd{get;set;}
        public String subject{get;set;}
        public String body{get;set;}
    }
}