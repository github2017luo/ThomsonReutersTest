/*
===============================================================================
LCRMTrialWizardCtrl
===============================================================================

PURPOSE: Controller Class for LCRMTrialWizardPage Page

COMMENTS:

CHANGE HISTORY
===============================================================================
DATE            NAME                    DESC
2017-07-10      Rajesh                  Created 
===============================================================================
*/

Public Class LCRMTrialWizardCtrl{
    //Properties
    public Opportunity opp {get;set;}
    public List<OLI> oliList{get;set;}
    public List<Contract_Line_Item__c> cliList{get;set;}
    public emailTemplateWrap emailTemplateObj{get;set;}
    public Contract contractObj{get;set;}
    public String currentScreen{get;set;}
    public Boolean showMailPopup{get;set;}
    public Boolean showContarctPopup{get;set;}
    public Boolean showContarctPopupHasError{get;set;}
    public Boolean selAllProd{get;set;}
    public String mailHeaderUrl{get;set;}
    public Boolean errorFlag{get;set;}
    
    //contructor
    public LCRMTrialWizardCtrl(ApexPages.StandardController controller) {
        mailHeaderUrl = 'https://c.<instance>.content.force.com/servlet/servlet.ImageServer?id=<document_id>&oid=<organization_id>';
        String s = System.URL.getSalesforceBaseUrl().getHost();
        System.debug('s :'+s);
        List<String> urlList = s.split('\\.');
        System.debug('urlList :'+urlList);
        if(urlList!=null && urlList.size()>2){
            mailHeaderUrl = mailHeaderUrl.replace('<instance>',urlList[1]);
        }
        try{
            Document doc = new Document();
             if(Schema.sObjectType.Document.isAccessible())
            {doc = [SELECT ID FROM Document where DeveloperName = 'LCRMTrialWizardHeader'];}
            mailHeaderUrl = mailHeaderUrl.replace('<document_id>',doc.id);
        }catch(Exception e){
            System.debug('Exception : '+e.getMessage());
        }
        mailHeaderUrl = mailHeaderUrl.replace('<organization_id>',UserInfo.getOrganizationId());
        System.debug('mailHeaderUrl : '+mailHeaderUrl);
        
        //EmailTemplate tempID = [SELECT Id,Name,Body,HTMLValue,Subject FROM EmailTemplate WHERE DeveloperName = 'LCRMTrialWizardHTMLEmail'];
        EmailTemplate tempID = new EmailTemplate();
        if(EmailTemplate.sObjectType.getDescribe().IsAccessible())
        {tempID = [SELECT Id,Name,Body,HTMLValue,Subject FROM EmailTemplate WHERE DeveloperName = 'LCRMTrialWizardHTMLEmailVF'];}
         
        emailTemplateObj = new emailTemplateWrap();
        showMailPopup = false;
        showContarctPopup = false;
        showContarctPopupHasError = false;
        selAllProd = false;
        //currentScreen = nextScreen();
        nextScreen();
        //currentScreen = 'opportunity';
        System.debug('currentScreen : '+currentScreen);
        contractObj = new Contract();
        oliList = new List<OLI>();
        cliList = new List<Contract_Line_Item__c>();
        try{
            Id oppID = ((Opportunity)controller.getRecord()).ID;
             if(Schema.sObjectType.OPPORTUNITY.isAccessible() && Schema.sObjectType.OPPORTUNITY.isQueryable())
            {opp = [SELECT ID, Name, Renewal_Flag__c, Expected_End_Date__c, LCRM_Sub_BU__c, accountID, Expiration_Date__c, Is_GLI__c, CurrencyIsoCode, LCRM_Split_On__c, LCRM_Transaction_Type__c, LCRM_Target_Opportunity__c, Key_Contact__c, Key_Contact__r.Email, Key_Contact__r.Name, ownerid FROM OPPORTUNITY WHERE ID = :oppID];
            }
            for(OpportunityLineItem oliObj : [SELECT ID, Product2Id, LCRM_Product_Type__c, LCRM_Product_Category__c, LCRM_Action__c, LCRM_Current_ACV__c, LCRM_New_ACV_SalesPrice__c, LCRM_Incremental_Amount__c, LCRM_Source_Opportunity__c, LCRM_Units__c from OpportunityLineItem where OpportunityId=:opp.Id]){
                OLI oliTempRec = new OLI();
                oliTempRec.sel = false;
                oliTempRec.oliRec = oliObj;
                oliList.add(oliTempRec);
            }
            errorFlag = false;
            if(opp.Renewal_Flag__c == true){
                errorFlag = true;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,System.Label.LCRM_TrialWizNonRenError));
            }
            if(oliList == null || oliList.size()==0){
                errorFlag = true;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,System.Label.LCRM_TrialWizNoProdError));
            }
            if(errorFlag == true){
            
            }
            try{
                User userObj=new User();
                if(Schema.sObjectType.USER.isAccessible() && Schema.sObjectType.USER.isQueryable() )
                {userObj = [SELECT ID, Name, Email from USER where ID = :opp.ownerId];}
                emailTemplateObj.fromAddName = userObj.Name;
                emailTemplateObj.fromAddEmail = userObj.Email;
            }catch(Exception e){}
            
            emailTemplateObj.relatedToOpp = opp.name;
            emailTemplateObj.toAdd = opp.Key_Contact__c + ';' + opp.Key_Contact__r.Email;
            String addToLbl = 'LCRMTrialEmailAddTo';
            String ccLbl = 'LCRMTrialEmailCc';
            String bccLbl = 'LCRMTrialEmailBcc';
            //String subLbl = System.Label.LCRM_TrialWizEmailSubject;
            //String bodyLbl = System.Label.LCRM_TrialWizEmailBody;
            emailTemplateObj.addToAdd = (KeyValueListStore__c.getValues(addToLbl) == null || 
                                   KeyValueListStore__c.getValues(addToLbl).TextValue__c == null || 
                                   KeyValueListStore__c.getValues(addToLbl).TextValue__c == '')?
                                   '':KeyValueListStore__c.getValues(addToLbl).TextValue__c;
            if(emailTemplateObj.addToAdd!=null && emailTemplateObj.addToAdd!=''){
                emailTemplateObj.addToAdd = emailTemplateObj.addToAdd.replace('null','');
            }
            emailTemplateObj.ccAdd = (KeyValueListStore__c.getValues(ccLbl) == null || 
                                   KeyValueListStore__c.getValues(ccLbl).TextValue__c == null || 
                                   KeyValueListStore__c.getValues(ccLbl).TextValue__c == '')?
                                   '':KeyValueListStore__c.getValues(ccLbl).TextValue__c;
            if(emailTemplateObj.ccAdd!=null && emailTemplateObj.ccAdd!=''){
                emailTemplateObj.ccAdd = emailTemplateObj.ccAdd.replace('null','');
            }
            emailTemplateObj.bccAdd = (KeyValueListStore__c.getValues(bccLbl) == null || 
                                   KeyValueListStore__c.getValues(bccLbl).TextValue__c == null || 
                                   KeyValueListStore__c.getValues(bccLbl).TextValue__c == '')?
                                   '':KeyValueListStore__c.getValues(bccLbl).TextValue__c;
            if(emailTemplateObj.bccAdd!=null && emailTemplateObj.bccAdd!=''){
                emailTemplateObj.bccAdd = emailTemplateObj.bccAdd.replace('null','');
            }
            /*emailTemplateObj.subject = (KeyValueListStore__c.getValues(subLbl) == null || 
                                   KeyValueListStore__c.getValues(subLbl).TextValue__c == null || 
                                   KeyValueListStore__c.getValues(subLbl).TextValue__c == '')?
                                   '':KeyValueListStore__c.getValues(subLbl).TextValue__c;
            if(emailTemplateObj.subject!=null && emailTemplateObj.subject!=''){
                emailTemplateObj.subject = emailTemplateObj.subject.replace('null','');
            }
            emailTemplateObj.body = (KeyValueListStore__c.getValues(bodyLbl) == null || 
                                   KeyValueListStore__c.getValues(bodyLbl).Failure_Email__c == null || 
                                   KeyValueListStore__c.getValues(bodyLbl).Failure_Email__c == '')?
                                   '':KeyValueListStore__c.getValues(bodyLbl).Failure_Email__c;
            if(emailTemplateObj.body!=null && emailTemplateObj.body!=''){
                emailTemplateObj.body = emailTemplateObj.body.replace('null','');
            }*/
            emailTemplateObj.subject = tempID.subject;
            emailTemplateObj.body = '<img src="'+mailHeaderUrl+'" width="100%"/><br/><br/>' + tempID.HTMLValue;
            //emailTemplateObj.body = emailTemplateObj.body.replace('<ContactFirstName>',opp.Key_Contact__r.Name);
            emailTemplateObj.body = emailTemplateObj.body.replace('<OpportunityOwnerName>',emailTemplateObj.fromAddName);
            System.debug('emailTemplateObj.body : '+emailTemplateObj.body);
            
            contractObj.AccountId = opp.accountID;
            contractObj.TR_Retention__Primary_Contact__c = opp.Key_Contact__c;
            contractObj.Status = 'Draft';
            contractObj.LCRM_Transaction_Type__c = 'Unpaid Trial';
            contractObj.LCRM_Originating_Opportunity__c = opp.id;
            contractObj.StartDate = Date.Today();
            contractObj.TR_Retention__Contract_End_Date__c= Date.Today()+14;
            contractObj.ownerid = opp.ownerid;
         }catch(Exception e){
            System.debug('Exception : '+e.getMessage());
            System.debug('Exception trace : '+e.getStackTraceString());
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage()));
            errorFlag = true;
        }
    }
    
    public String getSelContactName(){
        String conName = '';
        try{
            String conID = '';
            List<String> toAddSplit = emailTemplateObj.toAdd.split(';');
            System.debug('toAddSplit : getSelContactName : '+toAddSplit);
            if(toAddSplit !=null && toAddSplit.size()>1){
                conID = toAddSplit[0];
                 Contact con = new Contact();
                 if(Schema.sObjectType.CONTACT.isAccessible() && Schema.sObjectType.CONTACT.isQueryable())
                {con = [SELECT ID, Name, Email FROM CONTACT WHERE ID = :conID];}
                conName = con.Name;
            }
            System.debug('conName : '+conName);
        }catch(Exception e){
        }
        return conName;
    }
    
    //method used to toggle show/hide product on screen
    public void toggleSelAllProd(){
        if(selAllProd == true){
            if(cliList!=null){
                for(OLI tempOLI : oliList){
                    tempOLI.sel = true;
                }
            }
        }else{
            if(cliList!=null){
                for(OLI tempOLI : oliList){
                    tempOLI.sel = false;
                }
            }
        }
        
    }
    
    //method used to get contactrole list and populate on to address picklist 
    public List<selectOption> getToAddressList(){
        List<SelectOption> options = new List<SelectOption>();
        if(opp != null){
            List<ID> conIdList = new List<Id>();
            conIdList.add(opp.Key_Contact__c);
            for(OpportunityContactRole conRole : [SELECT ContactId FROM OpportunityContactRole WHERE OpportunityId = :opp.ID]){
                conIdList.add(conRole.ContactId);
            }
            for(Contact con : [SELECT ID, Name, Email FROM CONTACT WHERE ID IN :conIdList order by name]){
                    options.add(new SelectOption(con.ID + ';' + con.Email, con.Name));
            }
        }
        return options;
    }
    
    /*public List<String> getScreensList(){
        KeyValueListStore__c tempObj = KeyValueListStore__c.getInstance('LCRMTrialWizardScreens');
        List<String> splitValues = null;
        if(tempObj != null && tempObj.TextValue__c != null && tempObj.TextValue__c != ''){
            splitValues = tempObj.TextValue__c.split(',');
        }
        return splitValues;
    }*/
    
    //method used to get screen list from custom settings
    public List<String> getScreensLblList(){
        KeyValueListStore__c tempObj = KeyValueListStore__c.getInstance('LCRMTrialWizardScreensLabels');
        List<String> splitValues = null;
        if(tempObj != null && tempObj.TextValue__c != null && tempObj.TextValue__c != ''){
            splitValues = tempObj.TextValue__c.split(',');
        }
        return splitValues;
    }
    
    //method used to get screen counter 
    public Integer getCurrentScreenCounter(){
        Integer CurrentScreenCounter = 0;
        List<String> splitValues = getScreensLblList();
        System.debug('splitValues : '+splitValues);
        if(splitValues!=null && splitValues.size()>0){
            for(String splitVal : splitValues){
                if(currentScreen == splitVal){
                    break;
                }
                CurrentScreenCounter = CurrentScreenCounter + 1;
            }
        }
        return CurrentScreenCounter;
    }
    
    //method used to get table width on the screen
    public Decimal getTableWidth(){
        return 100/getScreensLblList().size();
    }
    
    //method used to change to next screen
    public void nextScreen(){
        System.debug('currentScreen before : '+currentScreen);
        System.debug('emailTemplateObj.body : '+emailTemplateObj.body);
        if(currentScreen=='Email Details'){
            String fields = '';
            if(emailTemplateObj.subject == null || emailTemplateObj.subject == ''){
                fields = fields + 'Subject';
            }
            if(emailTemplateObj.body == null || emailTemplateObj.body == ''){
                fields = (fields == null || fields == '')?'Body':fields + ' & ' + 'Body';
            }
            if(fields != null && fields != ''){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, (System.Label.LCRM_TrialWizReqErrMsg).Replace('<fields>',fields)));
                return;
            }
        }
        String nextScreen = currentScreen;
        //KeyValueListStore__c tempObj = KeyValueListStore__c.getInstance('LCRMTrialWizardScreens');
        //if(tempObj != null && tempObj.TextValue__c != null && tempObj.TextValue__c != ''){
            //List<String> splitValues = tempObj.TextValue__c.split(',');
            List<String> splitValues = getScreensLblList();
            System.debug('splitValues : '+splitValues);
            if(splitValues!=null && splitValues.size()>0){
                if(currentScreen == null || currentScreen == ''){
                    nextScreen = splitValues[0];
                    System.debug('if nextScreen : '+nextScreen);
                }else{
                    for(Integer i=splitValues.size()-1; i>=0; i--){
                        System.debug('nextScreen : '+nextScreen+' i before : '+i);
                        System.debug('currentScreen : '+currentScreen+'splitValues[i] : '+splitValues[i]);
                        if(currentScreen == splitValues[i]){
                            break;
                        }
                        nextScreen = splitValues[i];
                        System.debug('nextScreen : '+nextScreen+' i after : '+i);
                    }
                }
            }       
        //}
        currentScreen = nextScreen;
        System.debug('currentScreen after : '+currentScreen);
    }
    
    //method used to send previous screen value 
    public void previousScreen(){
        System.debug('currentScreen before : '+currentScreen);
        String nextScreen = currentScreen;
        //KeyValueListStore__c tempObj = KeyValueListStore__c.getInstance('LCRMTrialWizardScreens');
        //if(tempObj != null && tempObj.TextValue__c != null && tempObj.TextValue__c != ''){
            //List<String> splitValues = tempObj.TextValue__c.split(',');
            List<String> splitValues = getScreensLblList();
            System.debug('splitValues : '+splitValues);
            if(splitValues!=null && splitValues.size()>0){
                if(currentScreen == null || currentScreen == ''){
                    nextScreen = splitValues[0];
                    System.debug('if nextScreen : '+nextScreen);
                }else{
                    for(Integer i=0; i<=splitValues.size()-1; i++){
                        System.debug('nextScreen : '+nextScreen+' i before : '+i);
                        System.debug('currentScreen : '+currentScreen+'splitValues[i] : '+splitValues[i]);
                        if(currentScreen == splitValues[i]){
                            break;
                        }
                        nextScreen = splitValues[i];
                        System.debug('nextScreen : '+nextScreen+' i after : '+i);
                    }
                }
            }       
        //}
        currentScreen = nextScreen;
        System.debug('currentScreen after : '+currentScreen);
    }
    
    /*public EmailTemplate getEmailtemplatePreview(){ 
        EmailTemplate  et = [Select id, name, body, subject, HTMLValue  from EmailTemplate where name = 'LCRMTrialWizardHTMLEmail' ];
        return et;
    }*/

    //method used to send email after contract creation
    public void sendEmail(){
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
        List<String> toAddSplit = emailTemplateObj.toAdd.split(';');
        if(toAddSplit !=null && toAddSplit.size()>1){
            sendTo.add(toAddSplit[1]);
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
        //String myUrl = PageReference.forResource('LCRMTrialWizardEmailHeader').getUrl();
        //myUrl = myUrl.subString(0, myUrl.indexOf('?'));
        //system.debug(myUrl + '/logo.jpg');
        
        if(emailTemplateObj.body.contains('<ContactFirstName>')){
            emailTemplateObj.body = emailTemplateObj.body.replace('<ContactFirstName>',getSelContactName());
        }else{
            emailTemplateObj.body = emailTemplateObj.body.replace('Dear ,','Dear ' + getSelContactName()+ ',');
        }
        String body = emailTemplateObj.body;
        //body = body.replaceAll('\\n','<br/>');
        
        //body = '<img src="'+mailHeaderUrl+'" width="100%"/><br/><br/>'+body;
        mail.setHtmlBody(body);
        
        // Step 5. Add your email to the master list
        mails.add(mail);
        
        System.debug('Mails : '+mails);
        
        // Step 6: Send all emails in the master list
        Messaging.sendEmail(mails);
        Task taskObj = new Task();
        taskObj.Type = 'Email';
        String toaddr = (toAddSplit !=null && toAddSplit.size()>1)?toAddSplit[1]:'';
        taskObj.Description = 'Additional To: ' + emailTemplateObj.addToAdd +
                        '\nCC: ' + emailTemplateObj.ccAdd +
                        '\nBCC: ' + emailTemplateObj.bccAdd +
                        '\nAttachment: ' +
                        '\nSubject: ' + emailTemplateObj.subject +
                        '\nBody: ' + emailTemplateObj.body;
        taskObj.ActivityDate = Date.Today();
        taskObj.Status = 'Completed';
        taskObj.whatId = opp.Id;
        if(toAddSplit!=null && toAddSplit.size()>0){
            taskObj.whoId = toAddSplit[0];
        }
        taskObj.subject = 'Email:'+emailTemplateObj.subject;
        if(Schema.sObjectType.Task.isCreateable())
        {insert taskObj;}
    }
    
    //method used to create contract and contract line item records
    public PageReference finish(){
        PageReference pg = null;
        Savepoint sp;
        if(contractObj!=null){
            try{
                sp = Database.setSavepoint();
                if(Schema.sObjectType.Contract.isCreateable() && Schema.sObjectType.Contract.isUpdateable())
                {upsert contractObj;}
                contractObj.Status = 'Activated';
                update contractObj;
                for(Contract_Line_Item__c cli : cliList){
                    cli.Contract__c = contractObj.ID;
                }
                if(cliList!=null && cliList.size()>0 && Schema.sObjectType.Contract_Line_Item__c.isCreateable()){
                    insert cliList;
                }
                sendEmail();
                pg = new PageReference('/'+contractObj.ID);
            }catch(Exception e){
                System.debug('Exception : '+e.getMessage());
                System.debug('Exception trace : '+e.getStackTraceString());
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
                if(sp!=null)Database.rollback(sp);
            }
        }
        //redirect logic here
        return pg;
    }
    
    //method used to toggle popup for create contract confirmation
    public void showContarctPopup(){
        showContarctPopup = true;
        showContarctPopupHasError = true;
        cliList = new List<Contract_Line_Item__c>();
        for(OLI tempOLI : oliList){
            if(tempOLI.sel == true){
                showContarctPopupHasError = false;
                Contract_Line_Item__c tempCli = new Contract_Line_Item__c();
                //tempCli.Price__c = tempOLI.oliRec.LCRM_New_ACV_SalesPrice__c;
                tempCli.Price__c = 0;
                tempCli.Product__c = tempOLI.oliRec.Product2Id;
                tempCli.Units__c = tempOLI.oliRec.LCRM_Units__c;
                //tempCli.Account__c = opp.accountId;
                cliList.add(tempCli);
            }
        }
        System.debug('showContarctPopup  : '+showContarctPopup+' : showContarctPopupHasError  : '+showContarctPopupHasError);
    }
    
    //method used to toggle popup for create contract confirmation
    public void hideContarctPopup(){
        showContarctPopup = false;
        showContarctPopupHasError = false;
        System.debug('showContarctPopup  : '+showContarctPopup+' : showContarctPopupHasError  : '+showContarctPopupHasError);
    }
    
    //method used to toggle popup for mail preview box
    public void showMailPopup(){
        showMailPopup = true;
        System.debug('showMailPopup  : '+showMailPopup);
    }
    
    //method used to toggle popup for mail preview box
    public void hideMailPopup(){
        showMailPopup = false;
        System.debug('showMailPopup  : '+showMailPopup);
    }
    
    public String getMailText(){
        String body = emailTemplateObj.body;
        body = body.replaceAll('\\n','<br/>');
        return body;
    }
    
    //wrapper class for OLI selection section
    public class OLI{
        public boolean sel{get;Set;}
        public OpportunityLineItem oliRec{get;set;}
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