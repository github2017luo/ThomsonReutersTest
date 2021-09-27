/**************************************************************************************************************
*Modification Log::                                                                             
*Release              JIRA             ModifiedBy                     Descrption    
*Aug-2021           DPS-19686   TCS_DEV_TEAM          Commented Unnecessary Logic to Improve the Performace
**************************************************************************************************************/
global class batchLMSLAEmails implements Database.Batchable<sObject>
{
    global final String Query;
    global final boolean isAccept;
    global final boolean isConvert;
    List<Messaging.SingleEmailMessage> EmailsList;
    List<EmailTemplate> EmailTemplates;
    private static string debuglog='';
    public static OrgWideEmailAddress[] owea;
    Map<String, Id>  fromEmailAddressMap = new Map<String, Id>();
    
    
    //constructor
    global  batchLMSLAEmails(String q, boolean isAcpt, boolean isCnvrt){
        Query = q + ' AND (owner.profile.Name IN :ILMProfilesSet OR owner.Name IN:LMQueueSet)' ;
        isAccept = isAcpt;
        isConvert= isCnvrt; 
    
    } 
    
    public static void log(string msg){
        debuglog+=msg+'\n';
        system.debug(logginglevel.info,msg);
    } 
    
    //Forms the email which will be added to a list
    
    public static Messaging.SingleEmailMessage FormEmail(List<string> ToAdresses, List<String> CCAdresses, string subject,string body,Lead l,Map<String, Id>  fromEmailAddressMap){
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();   
        mail.setHtmlBody(body);
        mail.setSubject(subject);              
        //mail.setTemplateId(templateId);
        //mail.setTargetObjectId(leadId);
        /* commented as part of MCL 2193 
        if ( owea.size() > 0 ) {
            mail.setOrgWideEmailAddressId(owea.get(0).Id); 
            system.debug('***OrgWideaddress' +  owea.get(0).Id);          
        } */
        
      //  if(l.createdbyid == label.ANZEloquaId){   
        if(l.Sales_Org__c == 'BKRS' || l.Sales_Org__c == 'LRA'){
            mail.setOrgWideEmailAddressId(fromEmailAddressMap.get('eloquaintegration.emails@thomsonreuters.com'));          
                    
        }else{      
           mail.setOrgWideEmailAddressId(fromEmailAddressMap.get('tlr.miscrmoperations@thomsonreuters.com'));       
        }
        //ToAdresses.add('harikasai.pothamsetty@thomsonreuters.com');
        mail.setToAddresses(ToAdresses);
        if(CCAdresses!= null && CCAdresses.size()>0)
            mail.setCCAddresses(CCAdresses);        
        return mail;    
    }
    global Database.QueryLocator start(Database.BatchableContext BC)
    {  
        //Adding profile check
        LIST<String> ILMProfilesList= new LIST<String>(); 
        SET<String> ILMProfilesSet= new SET<String>(); 
        ILMProfilesList= ILMGeneral__c.getValues('AllowedProfilesForSLAEmails').value__c.split('\n');
        
        //Lead Management Queues Check
        SET<String>  LMQueueSet= new SET<String>();
        List<QueueSObject> lstLMQuesList= [Select Id, SobjectType, QueueId,Queue.Name from QueueSobject where SobjectType = 'LEAD' AND Queue.Name LIKE 'LM%'];
        For(QueueSobject q: lstLMQuesList){
            LMQueueSet.add(q.Queue.Name);    
        }
      
        for(String s:ILMProfilesList){
        ILMProfilesSet.add(s.trim());
        }   
        
        //system.debug('**LMQueueSet' + LMQueueSet + '***ILMProfilesSet' +ILMProfilesSet); commented as part of DPS-19686
        //system.debug('**Query' + query );commented as part of DPS-19686
        return Database.getQueryLocator(query);
    }
   
    global void execute(Database.BatchableContext BC, List<Lead> scope)
    
    {
        /*START-Commented thr below code as part of DPS-19686, to fix the CPU Time limit issue and imptove the performace of teh code. We are not using below query results anywhere in the Batch
        system.debug('****LeadList' +scope);
        Map<string,EmailTemplate > TemplateNAmeToIdMAp= new Map<string,EmailTemplate >();
        EmailTemplates= [SELECT Id,Name,body,developername FROM EmailTemplate where IsActive=:true];
        for(EmailTEmplate t: EmailTemplates){
         TemplateNAmeToIdMAp.put(t.developername,t);             
        }
        End of code chanegs as part DPS-19686*/
        
        // Getting From Email Address
        /* commented as part of MCL 2193
        string OrgEmailAddress= Label.LM_SLA_Orgwide_Address;
        owea = [select Id from OrgWideEmailAddress where Address = :OrgEmailAddress]; */
        
        List<string> OrgEmailAddressList = Label.LM_SLA_Orgwide_Address.split(';');     
        List<OrgWideEmailAddress> owdEmailList = [select Id, Address from OrgWideEmailAddress where Address IN :OrgEmailAddressList];       
        for(OrgWideEmailAddress owdAddRec :owdEmailList){       
            fromEmailAddressMap.put(owdAddRec.Address, owdAddRec.Id);
        }
        //GEtting REgional MAnager emails
        SET<ID> leadIdSet= new SET<ID>();
        for(Lead l:scope){
            //leadIdSet.add(l.Id);
            leadIdSet.add(l.Regional_Manager__c);      
        }  
        
        MAP<Id,User> userMap= new MAP<Id,User>([SELECT id,Email,name From User WHERE ID IN :leadIdSet]);    
        if(isAccept == true){ 
         EmailsList= new List<Messaging.SingleEmailMessage>(); 
         //For WArning
         for(Lead l:Scope){    
             if(l.Accept_SLA_Warning_Date__c <= System.TODAY() && System.TODAY() < l.Accept_By_Date__c){
                 string managerEMail;
                 if(userMAp!= null && userMap.get(l.Regional_Manager__c)!= null)
                     managerEMail= userMap.get(l.Regional_Manager__c).Email;
                 //system.debug('***Email' + managerEMail);commented as part of DPS-19686
                 List<string> toAddresses= new List<string>();
                 List<string> ccAddresses= new List<string>();
                 toAddresses.add(l.Owner.Email);
                 if(managerEMail!= null && managerEMail!= '')
                     ccAddresses.add(managerEMail);
                 Messaging.SingleEmailMessage currentEmail = new Messaging.SingleEmailMessage();
                 string subject='UNWORKED SFDC LEAD – Please ACCEPT by '+ l.Accept_By__c;
                 string str= System.URL.getSalesforceBaseUrl().toExternalForm() + '/'+ l.Id;
                 string body= '<html>You are receiving this email because this lead ' + '<a href="'+ str + '">' + l.name+ '</a> needs to be ACCEPTED by ' + l.Accept_By__c +'.</html>'; 
                 currentEmail = FormEmail(toAddresses ,ccAddresses,subject,body,l,fromEmailAddressMap);                     
                 EmailsList.add(currentEmail);          
             }
         }
         if(EmailsList!=null && EmailsList.size()>0){
                   try{
                        
                        Messaging.sendEmail(EmailsList);
                        //system.debug('**Mail Sent' + EmailsList.size()); Commented as part of DPS-19686
                        
                   }
                   catch(Exception e){
                       log('Error occurred:'+e.getMessage());
                   }
          }
            
         // For Violation
         for(Lead l : scope)
         {
             EmailsList= new List<Messaging.SingleEmailMessage>();
             // the following if was added for MCL-1401 by SKG
             if(l.Accept_By_Date__c <= System.TODAY()){
             l.Acceptance_SLA_Violation__c = true;
             }
             if(l.Accept_By_Date__c <= System.TODAY() && System.TODAY() <= l.Accept_SLA_Violation_End_Date__c){
                 string managerEMail;
                 if(userMAp!= null && userMap.get(l.Regional_Manager__c)!= null)
                     managerEMail= userMap.get(l.Regional_Manager__c).Email;                     
                 List<string> toAddresses= new List<string>();
                 List<string> ccAddresses= new List<string>();
                 toAddresses.add(l.Owner.Email);
                 if(managerEMail!= null && managerEMail!= '')
                     ccAddresses.add(managerEMail);
                 Messaging.SingleEmailMessage currentEmail = new Messaging.SingleEmailMessage();
                 string subject='ALERT - EXPIRED SFDC LEAD - The agreed timeframe to ACCEPT a lead has EXPIRED – Please address immediately';
                 string str= System.URL.getSalesforceBaseUrl().toExternalForm() + '/'+ l.Id;
                 string body= '<html>ALERT - You are receiving this email because the agreed-upon time for you to ACCEPT the following lead '+ '<a href="'+ str + '">' + l.name+
                 ' </a> has passed.  Please work this lead  ASAP to ensure the lead is given proper attention and is not reassigned to someone else.';
                 currentEmail = FormEmail(toAddresses ,ccAddresses,subject,body,l,fromEmailAddressMap);
                 EmailsList.add(currentEmail);
                // system.debug('***EmailsList1' +EmailsList); commented as part of DPS-19686
                 if(EmailsList!=null && EmailsList.size()>0){
                   try{                            
                        Messaging.sendEmail(EmailsList);
                       // system.debug('**Mail Sent' + EmailsList.size());commented as part of DPS-19686
                        
                   }
                   catch(Exception e){
                        log('Error occurred:'+e.getMessage());
                    }
                }
                l.Acceptance_SLA_Violation__c = true;
             }
                 
         }
         update scope;
        }
        
        if(isConvert == true){ 
         EmailsList= new List<Messaging.SingleEmailMessage>(); 
         //For WArning
         for(Lead l:Scope){    
             if(l.Convert_SLA_Warning_Date__c <= System.TODAY() && System.TODAY() < l.Convert_By_Date__c){
                 string managerEMail;
                 if(userMAp!= null && userMap.get(l.Regional_Manager__c)!= null)
                     managerEMail= userMap.get(l.Regional_Manager__c).Email;
                // system.debug('***Email' + managerEMail); commented as part of DPS-19686
                 List<string> toAddresses= new List<string>();
                 List<string> ccAddresses= new List<string>();
                 toAddresses.add(l.Owner.Email);
                 if(managerEMail!= null && managerEMail!= '')
                     ccAddresses.add(managerEMail);
                 Messaging.SingleEmailMessage currentEmail = new Messaging.SingleEmailMessage();
                 string subject='UNCONVERTED SFDC LEAD - Please CONVERT or DISCARD by ' + l.Convert_By__c +'.';
                 string str= System.URL.getSalesforceBaseUrl().toExternalForm() + '/'+ l.Id;                     
                 string body= '<html>You are receiving this email because this lead ' + '<a href="'+ str + '">' + l.name+ '</a> needs to be CONVERTED or DISCARDED by ' + l.Convert_By__c +'.</html>'; 
                 currentEmail = FormEmail(toAddresses ,ccAddresses,subject,body,l,fromEmailAddressMap);                     
                 EmailsList.add(currentEmail);          
             }
         }
         if(EmailsList!=null && EmailsList.size()>0){
                   try{
                        
                        Messaging.sendEmail(EmailsList);
                        //system.debug('**Mail Sent' + EmailsList.size()); commented as part of DPS-19686
                        
                   }
                   catch(Exception e){
                       log('Error occurred:'+e.getMessage());
                   }
          }
            
         // For Violation
         for(Lead l : scope)
         {
             EmailsList= new List<Messaging.SingleEmailMessage>();
             // the following if was added for MCL-1401 by SKG
             if(l.Convert_By_Date__c <= System.TODAY()){
             l.Convert_SLA_Violation__c = true;
             }
             if(l.Convert_By_Date__c <= System.TODAY() && System.TODAY() <= l.Convert_SLA_Violation_End_Date__c){
                 string managerEMail;
                 if(userMAp!= null && userMap.get(l.Regional_Manager__c)!= null)
                     managerEMail= userMap.get(l.Regional_Manager__c).Email;                     
                 List<string> toAddresses= new List<string>();
                 List<string> ccAddresses= new List<string>();
                 toAddresses.add(l.Owner.Email);
                 if(managerEMail!= null && managerEMail!= '')
                     ccAddresses.add(managerEMail);
                 Messaging.SingleEmailMessage currentEmail = new Messaging.SingleEmailMessage();
                 string subject='EXPIRED SFDC LEAD - The agreed timeframe to CONVERT or DISCARD a lead has EXPIRED – Please address immediately';
                 string str= System.URL.getSalesforceBaseUrl().toExternalForm() + '/'+ l.Id;                     
                 string body= '<html>ALERT - You are receiving this email because the agreed-upon time for you to CONVERT or DISCARD the following lead '+ '<a href="'+ str + '">' + l.name+
                 ' </a> has passed.  Please work this lead ASAP to ensure the lead is given proper attention and is not reassigned to someone else.';
                 currentEmail = FormEmail(toAddresses ,ccAddresses,subject,body,l,fromEmailAddressMap);
                 EmailsList.add(currentEmail);
                 //system.debug('***EmailsList1' +EmailsList); commented as part of DPS-19686
                 if(EmailsList!=null && EmailsList.size()>0){
                    try{                            
                        Messaging.sendEmail(EmailsList);
                       // system.debug('**Mail Sent' + EmailsList.size());commented as part of DPS-19686
                        
                       }
                    catch(Exception e){
                        log('Error occurred:'+e.getMessage());
                    }
                }
                l.Convert_SLA_Violation__c = true;
             }
                 
         }
         update scope;
        }
    }   
    global void finish(Database.BatchableContext BC)
    {
        log('****SLA is Success');
        
    }
}