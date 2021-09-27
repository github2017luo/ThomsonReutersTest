global class ESC_ServiceNowStagingBatch implements Database.Batchable <SObject>,Database.Stateful,Database.AllowsCallouts{

    private String query;
    public id idcron ; 
    public List<ESC_ServiceNow_Staging__c> UpdateStagingList = new List<ESC_ServiceNow_Staging__c>();
    public ESC_ServiceNow_Scheduler_Settings__c SNSettings = ESC_ServiceNow_Scheduler_Settings__c.getInstance('ServiceNowSettings');
    global static List<Id> DataErrorRecords= new List<Id>();
    global List<Id> DataErrorRecords1;
    public String DBError;
    
    global Database.QueryLocator start(Database.BatchableContext BcthCon) { 
        DataErrorRecords1 = new List<Id>();
        DBError='';
        String Status = 'Success';
        Integer NoOfRetries = Integer.valueOf(SNSettings.ESC_No_Of_Retries__c);
        Integer QLimit = Integer.valueOf(SNSettings.ESC_Query_Limit__c);
        query = 'SELECT ESC_AssignmentGroup__c,ESC_BusinessArea__c,ESC_CaseNumber__c,ESC_CustomerNumber__c,ESC_AuditResult__c,ESC_SourceLink__c,ESC_QuoteNumber__c,ESC_Description__c,ESC_Feed_Comment__c,ESC_ID__c,ESC_Key__c,ESC_Last_comment_from_SNOW__c,ESC_Last_status_from_SNOW__c,ESC_log__c,ESC_No_Of_Retries__c,ESC_ReportKey__c,ESC_RequestType__c,ESC_SLA__c,ESC_SNOW_ID__c,ESC_Source__c,ESC_SLAJustification__c,ESC_SourceSystem__c,ESC_Staging_Status__c,ESC_SystemIdentifier__c,ESC_Time_Stamp_Sent__c,ESC_Transmit_Status__c,ESC_Value__c,ESC_External_Task_Reference_Number__c,ESC_Case_Status__c,ESC_Employee_Number__c,ESC_Case_Id__c from ESC_ServiceNow_Staging__c where ESC_Transmit_Status__c !=:status and (ESC_No_Of_Retries__c<=:NoOfRetries OR ESC_No_Of_Retries__c=null) LIMIT '+QLimit+'';
        System.debug('@@Start query ' + query);
        return Database.getQueryLocator(query);
     }

    global void execute(Database.BatchableContext BtchCon, List<SObject> StgList){
        System.debug('@@Scope data '+StgList);
        try{
        if(StgList.size()>0){
            UpdateStagingList = ESC_ServiceNowStagingHelper.SNOWCallout(StgList);
            
         System.debug('Failed records '+DataErrorRecords);
            if(UpdateStagingList.size() >0)
            Update UpdateStagingList;
        } 
        }
        catch(exception e){
            DBError = e.getmessage();
        }
        if(DataErrorRecords.size()>0){
            DataErrorRecords1.addall(DataErrorRecords);
        }
        System.debug('Failed records DataErrorRecords--'+DataErrorRecords1);
    }

    global void finish(Database.BatchableContext BtchCon){
        System.debug('Failed records DataErrorRecords1'+DataErrorRecords1);
         if(DataErrorRecords1.size()>0 || DBError!=''){
            
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            String[] toAddresses = SNSettings.ESC_To_Address__c.split(',');
            OrgWideEmailAddress[] oOrgWideEmail = [SELECT DisplayName, Address, Id FROM OrgWideEmailAddress where DisplayName =:SNSettings.ESC_From_Address__c];
                if(oOrgWideEmail.size() >0)
                {
                    mail.setOrgWideEmailAddressId(oOrgWideEmail.get(0).Id);
                }
            mail.setToAddresses(toAddresses);
            mail.setSubject(SNSettings.ESC_Subject__c);
            String emailbody = '';
            if(DBError!=''){
                emailbody ='The Job failed internally  due to the following error \r\n'+DBError;
            }
            else{
            if(SNSettings.ESC_EmailBody__c !='' && SNSettings.ESC_EmailBody__c!=null){
                emailbody=SNSettings.ESC_EmailBody__c+'\r\n';
            }
            for(Id FailedId: DataErrorRecords1){
                emailbody+='\r\n'+URL.getSalesforceBaseUrl().toExternalForm() +'/'+FailedId;
            }
            }
            mail.setHtmlBody(emailbody);
            System.debug('mail '+mail);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }
   
        ESC_ServiceNowStagingScheduler ServiceNowScheduler = new ESC_ServiceNowStagingScheduler();       
        Datetime dt = DateTime.now();
        
        dt = dt.addMinutes(Integer.valueOf(SNSettings.ESC_BatchSchedule_Interval__c));     
        String sch = String.valueOf( dt.second() ) + ' ' + String.valueOf( dt.minute()   ) + ' ' + String.valueOf( dt.hour() ) + ' '  + String.valueOf( dt.day() ) +  ' ' + String.valueOf( dt.month() ) + ' '  + '? ' + String.valueOf( dt.Year());
                
        List<CronTrigger> cronTgr1 = [SELECT id FROM CronTrigger WHERE id =: idcron or id=: SNSettings.ESC_Current_Job_ID__c];  
            if(!cronTgr1.isempty()){
                for(CronTrigger crnTgr: cronTgr1){                
                    system.abortjob(crnTgr.Id);  
                }        
            }            
            
            SNSettings.ESC_Current_Job_ID__c = system.schedule('ESCServiceNowStaging'+ String.valueof(dt),sch,ServiceNowScheduler);
            update SNSettings; 
    }
}