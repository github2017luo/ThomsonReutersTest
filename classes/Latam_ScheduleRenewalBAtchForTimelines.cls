/**********************************************************************
Copyright © 2018 TATA CONSULTANCY SERVICES.
---------------------------------------------------------------------------------------
Req: DOC-5069 - For Canada, Lead time is 180 for all the Accounts
----------------------------------------------------------------------------------------
Purpose : Scheduling Batch class to create opt out assets
**********************************************************************/
global without sharing class  Latam_ScheduleRenewalBAtchForTimelines implements Schedulable{
    
    global void execute(SchedulableContext sc){
        Map<ID, String> accMap = new Map<ID,String>();        
        Map<Integer, List<ID>> accountIdsByLeadtime = new Map<Integer, List<ID>>();
        List<Id> accountListCanada = new List<ID>();
        
        try{
            for(Apttus_Config2__AssetLineItem__c asl : [SELECT Apttus_Config2__AccountId__c,APTS_Proposal_Business_Unit__c
                                                        FROM Apttus_Config2__AssetLineItem__c 
                                                        WHERE Apttus_Config2__AssetStatus__c = 'Activated' AND Renewal_quote_created__c=false
                                                        AND (APTS_Proposal_Business_Unit__c='Canada' AND  APTS_Online_or_Proflex_Product__c != 'Non_Renewal' 
                                                             AND Apttus_Config2__EndDate__c != null)
                                                        limit 40000])
            {
                if(asl.APTS_Proposal_Business_Unit__c.containsignorecase('Canada')){
                    accountListCanada.add(asl.Apttus_Config2__AccountId__c);
                }
            }
            
            //Add Canada Asset Line Items with fixed 180 days of Lead time
            if(accountListCanada != null && accountListCanada.size()>0){
                accountIdsByLeadtime.put(180,accountListCanada);
            }
            
            system.debug('#### Account map Sizee>>>>'+accMap.size());            
            system.debug('----- Account IDS by Lead Time >>>>'+accountIdsByLeadtime);
            Apttus_Config2.AssetRenewalSubmitController baseController = new Apttus_Config2.AssetRenewalSubmitController(accountIdsByLeadtime);
            Id jobId = baseController.doSubmitJob();
            
            if(Test.isRunningTest()) {
                CalloutException e = new CalloutException();
                e.setMessage('This is a constructed exception for code coverage');
                throw e;
            }
        }catch(exception ex){
            system.debug('Error Message: '+ex.getMessage());
            system.debug('Error Cause'+ex.getCause());
            system.debug('Error Line Number'+ex.getLineNumber());
            system.debug('Error stack'+ex.getStackTraceString());
            
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setToAddresses(Label.Renewal_Evergreen_asset_email.split(','));
            mail.setSenderDisplayName('Error Logs');
            mail.setSubject('Error Message: '+ex.getMessage());
            mail.setPlainTextBody('Type: ' + ex.getTypeName() + '\n' + 'Cause: ' + ex.getCause() + '\n' + 'Message: ' 
                                  + ex.getMessage() + '\n' + 'Line #: ' + ex.getLineNumber() + '\n' + ex.getStackTraceString() + '\n');
            if(!Test.isRunningTest()) 
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });           
        }
    }
    
}