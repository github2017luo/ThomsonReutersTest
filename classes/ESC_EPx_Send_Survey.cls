/*
Author: Matthew Main
Date: 4/06/18
Version: 1.0
*/

public  without sharing class ESC_EPx_Send_Survey implements Schedulable{


   public Static List<ESC_EPx_Template_Selector__c> templateSelectors;
    public Case currentCase = new Case();
    public ESC_EPx__c survey = new ESC_EPx__c();
    public EmailTemplateSelector templateSelector = null;// new EmailTemplateSelector();
    static List<OrgWideEmailAddress> owa = [SELECT id, Address, DisplayName from OrgWideEmailAddress];
    public static ESC_EPX_User_Wrapper usr;
    public static Languages__c langEnglish = [SELECT id, Language_Name__c, Salesforce_ISO_Code__c, ISO_Code__c FROM Languages__c where Language_Name__c = 'English'];
    public static Languages__c langEnglishDefault = [SELECT id, Language_Name__c, Salesforce_ISO_Code__c, ISO_Code__c FROM Languages__c where Language_Name__c = 'English (Default)'];

    

   public ESC_EPx_Send_Survey(Case c, ESC_EPx__c survey, EmailTemplateSelector templateSelector ){
       this.survey = survey;
       this.currentCase = c;
       this.templateSelector = templateSelector;
   }

    public void execute(SchedulableContext sc) {
      
      System.debug('Enter Execute Method');
      System.debug('survey.ESC_EPx_Type__c:' + this.survey.ESC_EPx_Type__c);
      //System.debug('survey.id:' + survey.getId());

      sendEmailLink(this.currentCase, this.templateSelector, this.survey);
      System.debug('Exit Execute Method');
    
      
   }
   
    @InvocableMethod(label='Send Survey' description='Sends Clicktools survey when case is closed')
    public static void sendSurvey(List<Case> caseList){

        usr = new ESC_EPX_User_Wrapper();

        
        List<ESC_EPx__c> surveyList = new List<ESC_EPx__c>();
        Id recTypeSupp = Schema.SObjectType.ESC_EPx__c.getRecordTypeInfosByName().get('ESC_Eps_Surpressed').getRecordTypeId();
        Id recTypeSent = Schema.SObjectType.ESC_EPx__c.getRecordTypeInfosByName().get('ESC_EPs_Sent').getRecordTypeId();
        //List<ESC_EPx_Template_Selector__c> templateSelectors;
        if(Schema.sObjectType.ESC_EPx_Template_Selector__c.isAccessible() || Schema.sObjectType.ESC_EPx_Template_Selector__c.isQueryable()){   
            if(templateSelectors==null){
            templateSelectors = 
                [SELECT id, ESC_EPs_Delay_Mins__c, ESC_EPx_Email_Template__c, ESC_Expiration_In_Days__c,
                        ESC_EPs_Make_EscalationScore__c, ESC_EPs_Make_FeedbackScore__c, ESC_EPs_Reopen_Auto__c,
                        Profile__c, Record_Type__c , ESC_EPx_Sent_From_Address__c, Allow_Multiple_EPS_Requests__c,
                        Case_Field_1__c , Case_Field_2__c, Case_Field_3__c, Case_Field_4__c, Case_Field_5__c, 
                        Case_Value_1__c, Case_Value_2__c, Case_Value_3__c, Case_Value_4__c, Case_Value_5__c,
                        Condition_1__c, Condition_2__c, Condition_3__c, Condition_4__c, Condition_5__c
                        from ESC_EPx_Template_Selector__c];
        }
        }
        List<EmailTemplateSelector> templateselectorList = new List<EmailTemplateSelector>();
        
        List<Id> caseIds = new List<Id>();
        List<Id> contactIds = new List<Id>(); //[INC1270648 09/06/18 IK]
        for(Case c : caseList){
            caseIds.add(c.id);
            contactIds.add(c.contactid);
        }
        
        for(ESC_EPx_Template_Selector__c ts :templateSelectors){
            templateselectorList.add(
                new EmailTemplateSelector(ts));
        }
        List<ESC_EPx__c> surveysToCount;
        if(Schema.sObjectType.ESC_EPx__c.isAccessible() || Schema.sObjectType.ESC_EPx__c.isQueryable()){
        if(contactIds !=null){
         surveysToCount= [SELECT id, ESC_Case__r.contactid from ESC_EPx__c WHERE createdDate > YESTERDAY AND ESC_EPx_Type__c != 'EPs - Supressed' AND ESC_Case__r.contactid IN :contactIds ] ;
            }
        }
        Map<Id,Integer> mapSurveyCount = new Map<Id,Integer>();
         
         for(ESC_EPx__c s : surveysToCount){
             System.debug('Key1:'+ s.ESC_Case__r.contactid );
             Set<Id> keys = mapSurveyCount.keySet();
             
             if(keys.contains(s.ESC_Case__r.contactid)){
                 mapSurveyCount.put(s.ESC_Case__r.contactid , mapSurveyCount.get(s.ESC_Case__r.contactid) + 1);
             }
             else{
                 mapSurveyCount.put(s.ESC_Case__r.contactid, 1);
             }
         }
         List<ESC_EPx__c> listSentSurveys;
        if(Schema.sObjectType.ESC_EPx__c.isAccessible() || Schema.sObjectType.ESC_EPx__c.isQueryable()){
        listSentSurveys = [SELECT id, ESC_Case__c from ESC_EPx__c where ESC_EPx_Type__c = 'EPs - Sent' AND ESC_case__c IN:caseIds];
        }
        Map<Id, List<ESC_EPx__c>> mapSentSurveys = new Map<Id,List<ESC_EPx__c>>();

        for(ESC_EPx__c s : listSentSurveys){

            Id key = s.ESC_Case__c;
            System.debug('Key1:'+ key);
            Set<Id> keys = mapSentSurveys.keySet();

            if(keys.contains(key)){
                List<ESC_EPx__c> listEpx = new List<ESC_Epx__c>();
                listEpx = (List<ESC_Epx__c>) mapSentSurveys.get(key);
                listEpx.add(s);
                mapSentSurveys.put(key, listEpx);
            }
            else{
                List<ESC_EPx__c> listEPX = new List<ESC_EPx__c>();
                listEPX.add(s);
                mapSentSurveys.put(key, listEPX);
            }
        }
   
 
        Set<String> a = case.sObjectType.getDescribe().fields.getMap().keySet();
        String fields = '';

        for(String s : a){
            fields += (fields==''?'':',')+s;

        }

        fields = fields.substring(0,fields.length());
        String caseQry = 'Select ' + fields + ',Account.ESC_OptOut_CSAT_Check__c, Account.ShippingCountry, Contact.ESC_OptOut_CSAT_Check__c, Contact.ESC_Frequency_Cap__c, Contact.ESC_Language_Text__c, RecordType.Name, Contact.Account.ShippingCountry, Owner.Name, Owner.UserRole.name ' + ' from Case where id IN :caseIds';
        List<Case> c1 = Database.query(caseQry);
        
        List<scheduledTaskObject> scheduledTasks = new List<scheduledTaskObject>();
    
        System.debug('##############');
        for(Case c : c1){
        
            EmailTemplateSelector emailTemplateSelected = getEmailTemplateSelector(c, templateselectorList);

            if(emailTemplateSelected != null) {
                System.debug('Call getEmailTemplateSelector, returned:' + emailTemplateSelected.toString());
            }

            List<ESC_EPx__c> surveysSent;
            Integer surveySentSize = 0;

          //Condition to check if we should allow for mutiple surveys to be sent.
          if(emailTemplateSelected != null){
              if(emailTemplateSelected.ts.Allow_Multiple_EPS_Requests__c == false){
                    try{
                        surveysSent = mapSentSurveys.get(c.id);
                        surveySentSize = surveysSent.size();
                    }
                    catch(exception ex){
                        System.debug('There have been no surveys sent yet');
                    }
               }

            if(surveysSent == null || emailTemplateSelected.ts.Allow_Multiple_EPS_Requests__c == true ||  (emailTemplateSelected.ts.Allow_Multiple_EPS_Requests__c == false && surveySentSize <= 0)){
            
                ESC_EPx__c survey = new ESC_EPx__c();
                System.debug('SurveyID:' + survey.id);
                survey.ESC_Case__c = c.id;
                survey.ESC_EPx_Category__c = 'EPs';
                survey.ESC_Case_Owner__c = c.Owner.name;
                survey.ESC_Case_Team__c = c.Owner.UserRole.name;
               
                  
                 
                 
                 System.debug('##############');
                 
                  
                 if(ESC_EPx_Send_Survey.recordTypeCheck(c)){
                 
                     
                     if(ESC_EPx_Send_Survey.suppressionChecks(c, survey, mapSurveyCount)){
                        survey.RecordTypeId = recTypeSupp;
                        survey.ESC_EPx_Type__c = 'EPs - Supressed';     
                     }
                     else{ 
                        //System.debug('Call getEmailTemplateSelector');
                        //EmailTemplateSelector emailTemplateSelected = getEmailTemplateSelector(c, templateselectorList);
              
                        if(emailTemplateSelected == null){
                            survey.RecordTypeId = recTypeSupp;
                            survey.ESC_EPx_Type__c = 'EPs - Supressed'; 
                            survey.ESC_Eps_Supr_NoMatchingTempl__c = true;
                        }
                        else{
                            survey.RecordTypeId = recTypeSent;
                            survey.ESC_EPx_Type__c = 'EPs - Sent';
                            survey.ESC_EPx_Template_Selector__c = emailTemplateSelected.ts.id;
                            survey.ESC_EPx_Language__c = emailTemplateSelected.selectedLanguage.id;
                            Date expirationDate = Date.today().addDays((Integer)emailTemplateSelected.ts.ESC_Expiration_In_Days__c);
                            survey.Expiration_Date__c = expirationDate;
                            survey.Expiration_Date_Text__c = expirationDate.year() + '-' + expirationDate.month() + '-' + expirationDate.day();
                            survey.Date_Time_Sent__c = dateTime.now().addMinutes((integer)emailTemplateSelected.ts.ESC_EPs_Delay_Mins__c);
                            scheduledTaskObject sch = new scheduledTaskObject(emailTemplateSelected.ts.ESC_EPs_Delay_Mins__c, c, survey, emailTemplateSelected);
                            scheduledTasks.add(sch);
                            
                        }
                     }                 
                     
                     surveyList.add(survey);
                 }//end record type check 
               }//End if templateSelector != null check
               else{
                   System.debug('Email Template Selector is null unable to determine what EPx to send');
               }
             }//end catch Remove coment of QA
        }
        if((surveyList.size() > 0)&&(Schema.sObjectType.ESC_EPx__c.isAccessible() || Schema.sObjectType.ESC_EPx__c.isCreateable())){
             insert surveyList;
        }
        
        for(scheduledTaskObject sch : scheduledTasks){
            if(sch.delay == 0){
                 sendEmailLink(sch.c, sch.templateSelector, sch.survey);
            }
            else{
                scheduleDeployment(sch.delay, sch.c, sch.survey, sch.templateSelector);
            }
        }
        
        
    }
    
    public static void scheduleDeployment(Decimal delayInMin, Case c, ESC_EPx__c survey, EmailTemplateSelector templateSelector){          
        
        DateTime now = DateTime.now();
        DateTime delayedTime = now.addMinutes(delayInMin.intValue());
        
        String sec = String.valueOf(delayedTime.second());       
        String min = String.valueOf(delayedTime.minute());        
        String hour = String.valueOf(delayedTime.hour());
        String day = String.valueOf(delayedTime.day()); 
        String month = String.valueOf(delayedTime.month());
        String year = String.valueOf(delayedTime.year());
        
        String sch = sec+' '+min+' '+ hour +' '+day+' '+month+' ? ' + year;

        try {
            String jobID = system.schedule('Send Survey:' + c.Id + ' ' + sch, sch, new ESC_EPx_Send_Survey(c, survey, templateSelector));
        }
        catch(exception e) {
            System.debug(e.getMessage());
            String jobID = system.schedule('Send Survey:' + c.Id + '_' + sch, sch, new ESC_EPx_Send_Survey(c, survey, templateSelector));
        }
    
    }

    public static Boolean suppressionChecks(Case c, ESC_EPx__c survey, Map<Id,Integer> mapSurveyCount){
         
         Boolean suppressed = false;
         //ESC_EPX_User_Wrapper usr = new ESC_EPX_User_Wrapper();

        
         //Get Global Decline Criteria
         List<ESC_EPx_DeclineCriteria__c> custSetDecline = ESC_EPx_DeclineCriteria__c.getall().values();
         List<DeclineCriteria> declineList = new List<DeclineCriteria>();
         
         for(ESC_EPx_DeclineCriteria__c decline : custSetDecline){
             if(String.isBlank(decline.User_Role__c) || decline.User_Role__c == usr.UserRole.DeveloperName){
                 declineList.add(New DeclineCriteria(decline.Object_Name__c, decline.Object_Field_Name__c, decline.Field_Value__c));
             }
         }
         
        
         for(DeclineCriteria d : declineList){
             if(d.checkCriteria(c)){
                suppressed = true;


                 if(d.obj == 'Account' && d.fld == 'ESC_OptOut_CSAT_Check__c'){
                     survey.ESC_EPs_Supr_AcctUnsub__c = true;
                     //suppressed = true;
                 }
                 else if(d.obj == 'Contact' && d.fld == 'ESC_OptOut_CSAT_Check__c'){
                     survey.ESC_EPs_Supr_ContUnsub__c = true;
                     //suppressed = true;
                 }
                 
                 else if(d.fld == 'ESC_Proactive_Type__c'){
                     survey.ESC_EPs_Supr_Proactive__c = d.val;
                     //suppressed = true;
                 }
                 
                 else if(d.fld == 'ESC_Diagnosis_Summary__c'){
                     survey.ESC_EPs_Supr_Diagnosis__c = d.val;
                     //suppressed = true;

                 }
                 else if(d.fld == 'Service_Product_Category__c'){
                     survey.ESC_EPs_Supr_Proactive__c = d.val;
                     //suppressed = true;
                 }
                 else if(d.obj == 'User' && d.fld == 'UserRole'){
                     survey.ESC_EPs_Supr_OwnerRole__c = d.val;
                     //suppressed = true;
                 }
                 else{
                     if(survey.ESC_Other_Suppresions__c == null){
                        survey.ESC_Other_Suppresions__c = '';
                     }
                     survey.ESC_Other_Suppresions__c += d.toString() + '\n';

                 }
                 
             }
         }
         
         
         System.debug('Key2:'+ c.contactid );

         Integer ePxSendCount = mapSurveyCount.get(c.contactId);
         
         
         Decimal freqCap = c.contact.ESC_Frequency_Cap__c;
        

         if(freqCap == null){
             freqCap = ESC_EPX_Max_Number_Of_EPx__c.getInstance().Max_Number_of_EPs_per_day__c;
         }
         
         System.debug('&&&&&&&&&&&&&&&&&&&&&&&FreqCap:' + freqCap);
         
         if(ePxSendCount >= freqCap){
             survey.ESC_EPs_Supr_FreqCap__c = true;
             suppressed = true;
         }
    
        return suppressed;
    }
    
    public static Boolean recordTypeCheck(Case c){
    
        //Retrieve the valid recordTypes and add them to list.
        String cRecordTypeName = Schema.SObjectType.Case.getRecordTypeInfosById().get(c.recordtypeid).getname();
        List<ESC_EPx_RecordTypesAvailable__c> custSetRecType = ESC_EPx_RecordTypesAvailable__c.getall().values();
        List<String> custSetAvailableRecordTypes = new List<String>();
        
        for(ESC_EPx_RecordTypesAvailable__c recType : custSetRecType){
              custSetAvailableRecordTypes.add(recType.RecordTypes__c);
          }
          
        if(custSetAvailableRecordTypes.contains(cRecordTypeName)){
            return true;
        }
    
        return false;
    }
    
    public static Boolean sendEmailLink(Case c, EmailTemplateSelector ts, ESC_EPx__c survey){
        System.debug('Current Case:' + c.id);
        
        Messaging.reserveSingleEmailCapacity(2);
        Map<String,ESC_EPx_Survey_Reply_Address__c> replyMap =  ESC_EPx_Survey_Reply_Address__c.getall();
        
        
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        //EmailTemplate et = [SELECT Id,name,HTMLValue,subject,Body FROM EmailTemplate WHERE DeveloperName = 'ESC_Survey_VF_Template'];
         String temp ='';
    //Contact contact;     
        //if(Schema.sObjectType.Contact.isAccessible() || Schema.sObjectType.Contact.isQueryable()){
        //contact = [SELECT email,id,BU_Segment__c,BU_Region__c from Contact where id =: c.Contactid limit 1];
        //system.debug('contact :' +contact);
        //}
        String[] toAddress = new String[] {c.ContactEmail};        
        Id eId = Id.valueOf(ts.getEmailTemplateId());
        mail.setToAddresses(toAddress);
        //Code bolck added for DSS-5470
        for(string s : replyMap.keySet()){
        if(temp==''){
            ESC_EPx_Survey_Reply_Address__c epx = ESC_EPx_Survey_Reply_Address__c.getValues(s);
            if(c.LCRM_Sub_BU__c == epx.Region__c && (epx.Segment__c == null || epx.Segment__c =='')){
            temp = epx.ReplyTo_Address__c;
            //mail.setReplyTo(epx.ReplyTo_Address__c);
            }
            else if(c.LCRM_Sub_BU__c == epx.Region__c && (epx.Segment__c != null || epx.Segment__c !='') && epx.Segment__c == c.BU_Segment__c){
            temp = epx.ReplyTo_Address__c;
            //mail.setReplyTo(epx.ReplyTo_Address__c);
            }
            }
        }   
        //mail.setReplyTo(Label.ESC_EPX_From_Addres);
        //Code bolck end for DSS-5470          
          mail.setReplyTo(temp);           
        mail.setTemplateId(eId);
        mail.setOrgWideEmailAddressId(ts.getFromEmailAddressId());
        mail.setTargetObjectId(c.contactId);
        System.debug('SurveyID:' + survey.id);
        mail.setWhatId(survey.id);
        mail.setSaveAsActivity(true);
        mail.setUseSignature(false);

        
        try{
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            EmailMessage emailForCase = new EmailMessage();
            emailForCase.toAddress = c.ContactEmail;
            emailForCase.Subject = mail.subject;
            emailForCase.ParentId = c.id;
            emailForCase.htmlBody = mail.htmlBody;
            if(Schema.sObjectType.EmailMessage.isAccessible() || Schema.sObjectType.EmailMessage.isCreateable()){
            insert emailForCase;
            }
            return true;
            }
        catch(Exception e){
            System.debug('exception:' + e);
            return false;
        }
        
        

    }
    
    public static EmailTemplateSelector getEmailTemplateSelector(Case c, List<EmailTemplateSelector> emailSelectorList){
        
        for(EmailTemplateSelector e : emailSelectorList){
            System.debug('Call Matches');
            if(e.matches(c)){
                return e; 
            }
        }
        
        return null;
    
    }

    
    public static String getRecordTypeNameById(String objectName, Id strRecordTypeId){
        return Schema.getGlobalDescribe().get(objectName).getDescribe().getRecordTypeInfosById().get(strRecordTypeId).getName();
    }

    public class scheduledTaskObject{
            
        Decimal delay {get;set;}
        Case c {get;set;}
        ESC_EPx__c survey {get;set;}
        EmailTemplateSelector templateSelector {get;set;}
        
        public scheduledTaskObject(Decimal delay, Case c,  ESC_EPx__c survey, EmailTemplateSelector template){
            this.c = c;
            this.delay = delay;
            this.survey = survey;
            this.templateSelector = template;
        }
    
    }
    
    
    public class DeclineCriteria{
        
        String obj {get;set;}
        String fld {get;set;}
        String val {get;set;}
        
        public DeclineCriteria(String obj, String fld, String val){
            this.obj = obj.toLowerCase();
            this.fld = fld.toLowerCase();
            this.val = val.toLowerCase();

            System.debug('Decline Criteria Initialized:' + toString());
        }
        
        public boolean checkCriteria(Case c){
            System.debug('Check for decline criteria:' + toString());
            System.debug('UserRole:' + usr.userRole.Name);
            if(obj == 'user' && fld == 'userRole'){
                //ESC_EPX_User_Wrapper usr = new ESC_EPX_User_Wrapper();
                System.debug('UserRole:' + usr.userRole.Name);
                if(val == usr.userRole.Name){
                    return true;
                }
                return false;
            }
            
            if(obj == 'case'){
                if(val == 'true' || val == 'false'){
                    if(Boolean.valueOf(c.get(fld))){
                        return true;
                    }
                }
                
                if(c.get(fld) == val){
                    return true;
                } 
                return false;
            }
           
           
            if(val == 'true' || val == 'false'){
                if(Boolean.valueOf(c.getSObject(obj).get(fld))){
                    return true;
                }
                return false;
            }
            
            if(c.getSObject(obj).get(fld) == val){
                return true;
            }
            return false;   
        }
        
        
        public override String toString(){ 
            return 'obj:' + obj + ' fld:'+fld+ ' val:'+val;
        }
        
        
    
    }
    
    public class EmailTemplateSelector{
    
        ESC_EPx_Template_Selector__c ts {get; set;}
        private List<String> listProfiles = new List<String>();
        private List<String> listRecordTypes = new List<String>();
        private List<Condition> listConditions = new List<Condition>();
        List<ESC_EPx_Supported_Languages__mdt> custMetSupportedLanguages;
        List<String> listSupportedLanguages;
        Languages__c selectedLanguage;
        Languages__c lang;

        private Id owaId;   
    
        public EmailTemplateSelector(ESC_EPx_Template_Selector__c templateSelector){
            this.ts= templateSelector;
            listSupportedLanguages = new List<String>();
            if(ts.ESC_EPx_Email_Template__c !=null){
            custMetsupportedLanguages = [SELECT Language__r.Language__c from ESC_EPx_Supported_Languages__mdt where Email_Template_ID__c = : ts.ESC_EPx_Email_Template__c];
            
            }
            for(ESC_EPx_Supported_Languages__mdt lang : custMetsupportedLanguages){
                listSupportedLanguages.add(lang.Language__r.Language__c);
            }
            
            listConditions.add(new Condition(ts.Case_Field_1__c, ts.Condition_1__c, ts.Case_Value_1__c));
            listConditions.add(new Condition(ts.Case_Field_2__c, ts.Condition_2__c, ts.Case_Value_2__c));
            listConditions.add(new Condition(ts.Case_Field_3__c, ts.Condition_3__c, ts.Case_Value_3__c));
            listConditions.add(new Condition(ts.Case_Field_4__c, ts.Condition_4__c, ts.Case_Value_4__c));
            listConditions.add(new Condition(ts.Case_Field_5__c, ts.Condition_5__c, ts.Case_Value_5__c));

            
            if(!String.isBlank(ts.profile__c)){
                listProfiles = ts.profile__c.split(',');
            }
            
            
            if(!String.isBlank(ts.record_Type__c)){
                listRecordTypes = ts.record_Type__c.split(',');
            }
            
            
            //this.selectedLanguage = selectLanguage();
        }
        
        public Id getEmailTemplateId(){
            return ts.ESC_EPx_Email_Template__c;
        }
        
        public Id getFromEmailAddressId(){
        
            if(owaId == null){
                for(OrgWideEmailAddress e : owa){
                    if(e.Address == ts.ESC_EPx_Sent_From_Address__c){
                        owaId = e.Id;
                    }
                }
            }
            return owaId;
        
        }
        
        public boolean isSupportedLanguage(String languageName){
            if(languageName =='English (Default)'){
                return true;
            }
        
            if(listSupportedLanguages.contains(languageName)){
                return true;
            }
            return false;
        }
        
        public boolean matches(Case c){
            this.selectedLanguage = selectLanguage(c);
            System.debug('Begin Matches');

            //Id devRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(recordType).getRecordTypeId();
            Profile userProfile = ESC_EPX_User_Wrapper.getUserProfile();
            //Profile userProfile = [select Name from profile where id = : UserInfo.getProfileId() Limit 1];
            
            if(!listRecordTypes.contains(c.recordType.Name)){
                System.debug('Exit Match: RecordType:' + c.recordType.Name);
                return false;
            }

            if(!this.listProfiles.contains(userProfile.Name)){
                System.debug('Exit Match - Profile: ProfileList - ' + listProfiles + '; User Profile - ' + userProfile.Name);
                return false;
            }
            
            for(Condition con : listConditions){
                if(!con.matches(c)){
                    return false;
                }
            }
            
            if(selectedLanguage == null){
                System.debug('Selected Language was Null');
                return false;
            }
            
            if(!listSupportedLanguages.contains(selectedLanguage.Language_Name__c) && selectedLanguage.Language_Name__c != 'English (default)'){
                System.debug('#########listSupportedLanguages:' + listSupportedLanguages + ' #############');
                System.debug('The Selected Language:' + selectedLanguage.Language_Name__c + ' is not supported by the Email Template');
                return false;
            }
            
            System.debug('Match Found');
            return true;
        
        }
        
        public Languages__c selectLanguage(Case c){
             Languages__c[] sOQLcontactPreferredLang ;
            if(Schema.sObjectType.Languages__c.isAccessible() || Schema.sObjectType.Languages__c.isQueryable()){
             if(c.Contact.ESC_Language_Text__c !=null){
           sOQLcontactPreferredLang=  [SELECT id, Language_Name__c, ISO_Code__c, Salesforce_ISO_Code__c FROM Languages__c where Language_Name__c =: c.Contact.ESC_Language_Text__c];
            }
            }
            Languages__c contactPreferredLang = null;
             if(sOQLcontactPreferredLang !=null){
             
            if(sOQLcontactPreferredLang.size() > 0){
               contactPreferredLang = sOQLcontactPreferredLang[0];
            }
            }
            
            //ESC_EPX_User_Wrapper usr = new ESC_EPX_User_Wrapper();
            String choice = usr.getTeamLangSetting();
            
            System.debug('####################Team Choice:' + choice + ' ######################');
            
            if(choice == 'A'){
                //Use Contacts Preferred Language else English 
                if(contactPreferredLang != null && this.isSupportedLanguage(contactPreferredLang.Language_Name__c)){
                    
                    lang = contactPreferredLang;
                   // selectedLanguage = lang;
                    return lang;
                }
                
                System.debug('LanguageChoosen:'+langEnglish.Language_Name__c);
                //selectedLanguage = langEnglish;
                return langEnglish;
            }
            
            if(choice == 'B'){
                //Use Contacts Preferred Language else D
                if(contactPreferredLang != null && this.isSupportedLanguage(contactPreferredLang.Language_Name__c)){
                   
                   
                    lang = contactPreferredLang;
                    //selectedLanguage = lang;
                    System.debug('Selected Language:' + lang.Language_Name__c);
                    return lang;
                }
                
                choice = 'D';
            
            }
            if(choice == 'C'){
                //Use Contacts Preferred Language else E
                if(contactPreferredLang != null && this.isSupportedLanguage(contactPreferredLang.Language_Name__c)){
                   
                   
                    lang = contactPreferredLang;
                    //selectedLanguage = lang;
                    System.debug('Selected Language:' + lang.Language_Name__c);
                    return lang;
                    
                }
                choice = 'E';
            }
            if(choice == 'D'){
                //Use Shipping Country Associated with Account
                try{
                    String country = c.Account.ShippingCountry;
                    System.debug('&&&&&&&&&&&&&&&&Contacts Shipping Country:' + country);
                    ESC_EPx_Country_To_Lang_Map_Wrapper instanceCountryToLangMap = ESC_EPx_Country_To_Lang_Map_Wrapper.getInstance();
                    Languages__c mappedLanguage = instanceCountryToLangMap.getLanguage(usr.userRole.Developername, country);
                    
                    
                    if(!String.isBlank(country) && this.isSupportedLanguage(mappedLanguage.Language_Name__c)){
                                   
                        System.debug('LanguageChoosen:'+mappedLanguage.Language_Name__c);
                        System.debug('Selected Language:' + mappedLanguage.Language_Name__c);
                        return mappedLanguage;
                    }
                    else{ return langEnglish;}
                }
                catch(Exception e){
                    System.debug('Language was not found in ESC_EPX_Country_To_Lang_Map__mdt, return english');
                    return langEnglish;
                }
     
            
            }
            if(choice == 'E'){
                //Use users language 
                lang = usr.getTeamLanguage();
                System.debug('Selected Language:' + lang);
                return lang;
                
            }
             
            return langEnglishDefault;
        }
    
    
    }
    
    public class Condition{
    
        String field;
        String condition;
        String value;
        
    
    
        public Condition(String field, String condition, String value){
            this.field = field;
            this.condition = condition;
            this.value = value;
        }
        
        public Boolean matches(Case c){
            if(!String.isBlank(field) ){
                if(condition == '=' && value != c.get(field)){
                    System.debug('Exit: Not a match becuase of condition:' + toString() );
                    return false;
                }
                if(condition == '!=' && value == c.get(field)){
                    System.debug('Exit: Not a match becuase of condition:' + toString() );
                    return false;
                }
        
            }
            return true;
        }
        
        public override String toString(){
            return field + ' ' + condition + ' ' + value;
        }
    
    }        
        
    
    //Not Using currently, leaving as an example of how to make an API call to clicktools.    
/*    public static void clicktoolsAPIRequest(){
         HttpRequest req = new HttpRequest();
         req.setEndpoint('https://api.clicktools.com/v1/contacts');
         req.setMethod('GET');
         
         String username = 'matthew.main@thomsonreuters.com';
         String password = 'Password1';
         Blob headerValue = Blob.valueOf(username + ':' + password);
         String authorizationHeader = 'Basic ' +
         EncodingUtil.base64Encode(headerValue);
         req.setHeader('Authorization', authorizationHeader);


         
         System.debug('AuthHeader:' + req.toString());

         
         req.setBody(
                        '{'+
                        '    "title": "test",'+
                        '    "description": "test",'+
                        '    "deploymentType": "immediate-deploy",'+
                        '    "deploymentMethod": "email",'+
                        '    "instanceId": "3gxcobg0zbxc4",'+
                        '    "what": {'+
                        '        "removeDuplicates": "false",'+
                        '        "subject": "test of immediate email deployment",'+
                        '        "from": "matthew.main@thomsonreuters.com",'+
                        '        "emailTemplate": "31625420bc6bc9",'+
                        '        "notificationId": "matthew.main@thomsonreuters.com"'+
                        '    },'+
                        '    "contacts": ['+
                        '        "mainx016@gmail.com"'+
                        '    ]'+
                        '}'
                     );
                     
         Http http = new Http();
         HTTPResponse res = http.send(req);
         System.debug(res.getBody());
    }*/
    
   
    
}