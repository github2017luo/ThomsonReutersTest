/********************************************************************** 
Name: LTS_SendCustomEmailUtilityClass
====================================================== 
Req: Email Utility Class to send Emails 
====================================================== 
Purpose: Notify Rep with email
====================================================== 
History 
------- 
VERSION    AUTHOR           DATE           DETAIL 
1.0        TCS Developer    09/01/2019    Initial Development  
***********************************************************************/
public class LTS_SendCustomEmailUtilityClass {
    Public static boolean successCheck = false;
    List<LCRM_Exception_Log__c> excepObjList = new List<LCRM_Exception_Log__c>();
    public boolean sendSingleEmailMsg(Map<Id,Id>targetObjectandWhatId, Id templateId,String senderDisplayName){
        
        try{
            SYSTEM.debug('*** Inside LTS_SendCustomEmailUtilityClass ***');
            List<Messaging.SingleEmailMessage> mailsList = new List<Messaging.SingleEmailMessage>();
            for(Id whatId : targetObjectandWhatId.keyset()){
                System.debug('whatId** '+whatId);
                System.debug('WhoId** '+targetObjectandWhatId.get(whatId));
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage(); 
                mail.setTargetObjectId(whatId);    
                mail.setWhatId(targetObjectandWhatId.get(whatId)); 
                // The email template ID used for the email 
                mail.setTemplateId(templateId); 
                mail.setSaveAsActivity(false);
                mail.setSenderDisplayName(senderDisplayName); 
                mailsList.add(mail);
            }
            //Messaging.sendEmail(mailsList);     
            Messaging.SendEmailResult[] results = Messaging.sendEmail(mailsList,false);
            if (results[0].success) {
                System.debug('The email was sent successfully.');
                successCheck = true;
            } else {
                System.debug('The email failed to send: '+ results[0].errors[0].message);
                successCheck = false;
            }
        }
        Catch(Exception err){}        
        return successCheck;
    }
}