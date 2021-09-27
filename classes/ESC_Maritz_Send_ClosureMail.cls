/**
 * @description send closure mail for Maritz
 */
public without sharing class ESC_Maritz_Send_ClosureMail {
 Public static List<ESC_EPx_Survey_Reply_Address__c> epx = new List<ESC_EPx_Survey_Reply_Address__c>();
    
     @InvocableMethod(label='Send Maritz Closure mail' description='Sends closure mail when case is closed')
        /**
        * @description sendEmail
        * @param caseList
        */
        public static void sendEmail(List<Case> caseList){
        List<Id> conIds = new List<Id>();
        boolean isreopen = false;
        String brand ='';
        String language = '';
        String region ='';
        String segment ='';
        OrgWideEmailAddress owa = new OrgWideEmailAddress();
        String[] toAddress = new String[] {};
        EmailTemplate templateId = new EmailTemplate();
        for(case c : caseList){
            if(c.contactid != null){
            conIds.add(c.contactid);
            }
            if(c.ESC_Reopen_Case__c == true){
             isreopen = true;
            }
            if(c.LCRM_Sub_BU__c =='GGO' ||  ((c.LCRM_Sub_BU__c == '' || c.LCRM_Sub_BU__c == null) && c.IS_gli__c == false)){
                language =c.ESC_GGO_Contact_Preferred_Language__c;
            }
            else{
                language =c.ESC_CDN_Contact_Preferred_Language__c;
            }
            brand = c.ESC_Product_Segment_Brand__c; 
            region = c.LCRM_Sub_BU__c;
            segment = c.BU_Segment__c;
           if(! test.isrunningtest()){
             toAddress.add(c.ContactEmail);
             }
        }
        if(test.isrunningtest()){
            contact con1= new contact();
            if(Schema.sObjectType.contact.isQueryable() || Schema.sObjectType.contact.isAccessible()){
              con1 = [select id,email from contact where id =: conIds[0]];
            }
             toAddress.add(con1.Email);
             language = 'English';
             }
        if(!test.isrunningtest() && (language =='' || language == null)){
             language = 'English';
        } 
        String temp ='';
           
           if(epx.size() == 0 && (Schema.sObjectType.ESC_EPx_Survey_Reply_Address__c.isQueryable() || Schema.sObjectType.ESC_EPx_Survey_Reply_Address__c.isAccessible())){
            epx = [select id,Region__c,Brand__c,Preferred_Language__c,ReplyTo_Address__c,ReopenEmailTemplate__c,Email_Template__c,ESC_From_Address__c from ESC_EPx_Survey_Reply_Address__c where  Region__c =: region  and  Brand__c =: brand and Preferred_Language__c =: language]; 
            }if(epx.size()>0){
                for(ESC_EPx_Survey_Reply_Address__c ep : epx){
                    System.debug(LoggingLevel.WARN,'entered1--->'+region+brand+ep);
                    temp = ep.ReplyTo_Address__c;
                    templateId = getTemplateID(isreopen,ep.ReopenEmailTemplate__c,ep.Email_Template__c);
                    owa = getOWA(ep.ESC_From_Address__c);
            }
            }
            else{
                temp  = system.Label.ESC_EPX_From_Addres;
                templateId = getTemplateID(isreopen,'ESC_Maritz_closure_email_template_without_Survey','ESC_Maritz_closure_email_template_with_Survey');
                owa = getOWA(system.Label.ESC_EPX_From_Addres);
            }       
        //String[] toAddress = new String[] {caselist[0].ContactEmail};
        System.debug(LoggingLevel.WARN,'toaddress--->'+  caselist[0].ContactEmail+toAddress);
        List<Messaging.SingleEmailMessage> allmsg = new List<Messaging.SingleEmailMessage>();
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
             mail.setWhatId(caselist[0].id);
             mail.setTreatTargetObjectAsRecipient(false);
             mail.setToAddresses(toAddress);
             mail.setSaveAsActivity(false);
             if(temp!= '' && temp != null){
                 mail.setReplyTo(temp); 
             }
        if(templateId != null){
             mail.setTemplateID(templateId.Id); 
        }
        if(conIds.size() > 0 && conIds != null){ 
            system.debug(LoggingLevel.WARN,'contact 1'+conIds);
            mail.setTargetObjectId(conIds[0]);
        }
        else{
            Contact con;
            if(Schema.sObjectType.contact.isQueryable() || Schema.sObjectType.contact.isAccessible()){
              con = [select id from contact limit 1];
            }
            mail.setTargetObjectId(con.id);
        }
        if(owa != null){
            mail.setOrgWideEmailAddressId(owa.id);
        }
        allmsg.add(mail);
        sendemail(allmsg);
        attachemail(mail,caselist);
    }
    /**
        * @description sendemail
        * @param allmsg
        */
    static void sendemail(List<Messaging.SingleEmailMessage> allmsg){
    try{
        Messaging.SendEmailResult[] results = Messaging.sendEmail(allmsg);
            if (results[0].success) {
            System.debug(LoggingLevel.WARN,'The email was sent successfully.');
            } else {
            System.debug(LoggingLevel.WARN,'The email failed to send: ' + results[0].errors[0].message);
            }
        }
        catch(Exception e){
            System.debug(LoggingLevel.WARN,'exception:' + e);
        }
    }
    /**
        * @description attachemail
        * @param mail
        * @param caseList
        */
    static void attachemail(Messaging.SingleEmailMessage mail,List<Case> caseList){
        try{
            EmailMessage emailForCase = new EmailMessage();
            emailForCase.toAddress = caselist[0].ContactEmail;
            emailForCase.Subject = mail.subject;
            emailForCase.ParentId = caselist[0].id;
            emailForCase.htmlBody = mail.htmlBody;
            if(Schema.sObjectType.EmailMessage.isAccessible() || Schema.sObjectType.EmailMessage.isCreateable()){
            insert emailForCase;
            }
            }
        catch(Exception e){
            System.debug(LoggingLevel.WARN,'exception:' + e);
        }
    }
    /**
        * @description getTemplateID
        * @param isreopen
        * @param reopentemp
        * @param closetemp
        * @return EmailTemplate
        */
    static EmailTemplate getTemplateID(Boolean isreopen,String reopentemp, String closetemp){
        EmailTemplate templateId = new EmailTemplate();
        if(isreopen && (Schema.sObjectType.EmailTemplate.isQueryable() || Schema.sObjectType.EmailTemplate.isAccessible())){
            templateId = [Select id from EmailTemplate where Developername =: reopentemp];
        }
        else {
            templateId = [Select id from EmailTemplate where Developername =: closetemp];
        }
        return templateId;
    }
    /**
        * @description getTemplateID
        * @param fromAdd
        * @return OrgWideEmailAddress
        */
    static OrgWideEmailAddress getOWA(string fromAdd){
    System.debug(LoggingLevel.WARN,'fromadd--->'+fromAdd);
        OrgWideEmailAddress owa = new OrgWideEmailAddress();
         if(! test.isrunningtest() && (Schema.sObjectType.OrgWideEmailAddress.isQueryable() || Schema.sObjectType.OrgWideEmailAddress.isAccessible())){
            owa = [select id from OrgWideEmailAddress where Address =: fromAdd];
        }
        if(test.isrunningtest()){
            owa = [select id from OrgWideEmailAddress limit 1];
        }
        return owa;
    }
    
}