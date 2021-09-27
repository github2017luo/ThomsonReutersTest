/**
     * @description CaseCommentHelperextended
     *Created as part of VAC-987 which is extended class of CaseCommentHelper.sendEmailMessage
     */
public with sharing class CaseCommentHelperExtended {
/**
         * @description sendEmailMessage
         * @param listOfCases
         * @param caseFollower
         * @param subjectMap
         */     
        
        public static void sendEmail(List<Case> listOfCases,Map<ID,List<String>> caseFollower, Map<ID,String> subjectMap){
            EmailTemplate et = new EmailTemplate();
            if(Schema.sObjectType.EmailTemplate.isAccessible() && Schema.sObjectType.EmailTemplate.isQueryable()){
                et = [SELECT Id,Body,Subject,HtmlValue FROM EmailTemplate WHERE DeveloperName ='Au_Sales_template'];
            }
            //List<Messaging.SingleEmailMessage> allmsg = new List<Messaging.SingleEmailMessage>();
            FieldId__c inst = FieldId__c.getOrgDefaults();
            String url = inst.Instance_URL__c; 
            for(Case caseRec:listOfCases){   
                if(!caseFollower.isEmpty() && caseFollower.get(caseRec.Id) != null){
                    for(String usrId:caseFollower.get(caseRec.Id)){
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    //List<string> toAddress = caseFollower.get(caseRec.Id);
                    //mail.setToAddresses(toAddress);
                    mail.setTargetObjectId(usrId);
                    mail.setOrgWideEmailAddressId(Label.OrgWideEmailId);
                    mail.setTreatTargetObjectAsRecipient(true);
                    mail.setTemplateId(et.Id);
                    mail.setSubject(subjectMap.get(caseRec.Id) +' '+ caseRec.CaseNumber);  
                    String htmlBody = getEmailbody(caseRec,et.HtmlValue,url);
                    mail.setHtmlBody(htmlBody);
                    mail.setSaveAsActivity(false);
                    try{
                        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                    }catch(Exception ex){
                        system.debug(LoggingLevel.WARN,ex.getMessage());
                }
               }
           }
        }
      } 
        /**
         * @description getEmailbody
         * @param caseRec
         * @param htmlBody
         * @param url
         * @return string
         */  
         
       public static string getEmailbody(Case caseRec, String htmlBody, string url){ 
                htmlBody = htmlBody.replace('{!Case.Link}', '<a href= '+ url +''+ caseRec.ID  +'>'+caseRec.CaseNumber+'</a>' );
                htmlBody = htmlBody.replace('{!Case.CaseNumber}', caseRec.CaseNumber); 
                htmlBody = htmlBody.replace('{!Case.CaseNumber}', caseRec.CaseNumber);
                htmlBody = caseRec.Subject != null? htmlBody.replace('{!Case.Subject}', caseRec.Subject): htmlBody.replace('{!Case.Subject}',  ' ');
                htmlBody = caseRec.Priority != null? htmlBody.replace('{!Case.Priority}', caseRec.Priority): htmlBody.replace('{!Case.Priority}',  ' ');
                htmlBody = caseRec.Account != null? htmlBody.replace('{!Case.Account}', caseRec.Account.name): htmlBody.replace('{!Case.Account}',  ' ');
                htmlBody = caseRec.Contact != null? htmlBody.replace('{!Case.Contact}', caseRec.Contact.name): htmlBody.replace('{!Case.Contact}',  ' ');
                htmlBody = caseRec.ownerId != null? htmlBody.replace('{!Case.OwnerFullName}', caseRec.owner.name): htmlBody.replace('{!Case.OwnerFullName}',  ' ');
                htmlBody = caseRec.Product__c != null? htmlBody.replace('{!Case.Product}', caseRec.Product__c): htmlBody.replace('{!Case.Product}',  ' ');
                htmlBody = caseRec.Description != null? htmlBody.replace('{!Case.Description}', caseRec.Description): htmlBody.replace('{!Case.Description}',  ' ');
                htmlBody = caseRec.Status != null? htmlBody.replace('{!Case.Status}', caseRec.Status): htmlBody.replace('{!Case.Status}',  ' ');
            return htmlBody;
            }
}