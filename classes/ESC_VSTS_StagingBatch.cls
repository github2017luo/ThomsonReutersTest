global class ESC_VSTS_StagingBatch implements Database.Batchable <SObject>,Database.Stateful,Database.AllowsCallouts{
    
    private String query;
    public id idcron ; 
    global static List<Id> DataErrorRecords= new List<Id>();
    public List<ESC_VSTS_Staging__c> UpdateStagingList = new List<ESC_VSTS_Staging__c>();
    public ESC_ServiceNow_Scheduler_Settings__c VSTSSettings= ESC_ServiceNow_Scheduler_Settings__c.getInstance('VSTS Scheduler Settings');
    global List<Id> DataErrorRecords1;
    public String DBError;
    
    global Database.QueryLocator start(Database.BatchableContext BcthCon) { 
        DataErrorRecords1 = new List<Id>();
        DBError='';
        Integer QLimit = Integer.valueOf(VSTSSettings.ESC_Query_Limit__c);
        String Status = '\'Success\'';
        String Status2 = '\'Inbound\'';
        query='Select ESC_Account_Name__c, ESC_Case_Created_Date__c, ESC_Case_Description__c,ESC_Case_Diagnosis__c,ESC_Case_Number__c,ESC_Case_Owner__c,ESC_Case_Priority__c,ESC_Case_Product__c,ESC_Case_Product_Complement__c,ESC_Case_Product_Version__c,ESC_Case_Severity__c,ESC_Case_Subject__c,ESC_Error_Log__c,ESC_Feed_Comment__c,ESC_IsAllowRepDB__c, ESC_Is_Customer__c,ESC_Referral_Id__c,ESC_RequestType__c,ESC_SAP_Account_Num__c,ESC_Time_Stamp_Sent__c,ESC_Value__c,ESC_Staging_Status__c from ESC_VSTS_Staging__c where ESC_Staging_Status__c NOT IN('+Status+','+Status2+') LIMIT '+QLimit+'';
        System.debug('@@Start query ' + query);
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BtchCon, List<SObject> StgList){
    
          System.debug('@@Scope data '+StgList);
        try{
        if(StgList.size()>0){
           UpdateStagingList = ESC_SCIntegrationHelperToVSTS.VSTSCallout(StgList);
            
         System.debug('Failed records '+DataErrorRecords);
            //if(UpdateStagingList.size() >0)
            //Update UpdateStagingList;
        } 
        }
        catch(exception e){
            DBError = e.getmessage();
        }
        //Added for DSS-5235
         if(UpdateStagingList.size() >0)
            Update UpdateStagingList;
        if(DataErrorRecords.size()>0){
            DataErrorRecords1.addall(DataErrorRecords);
        }
        System.debug('Failed records DataErrorRecords--'+DataErrorRecords1);
       
           
    }
    
    global void finish(Database.BatchableContext BtchCon){
    
     system.debug('VSTS to:>>>' +VSTSSettings.ESC_To_Address__c);
     if(VSTSSettings.ESC_To_Address__c !=Null && VSTSSettings.ESC_To_Address__c !=''){
     if(DataErrorRecords1.size()>0 || DBError!=''){
            System.debug('Failed records DataErrorRecords1'+DataErrorRecords1);
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            String[] toAddresses = VSTSSettings.ESC_To_Address__c.split(',');
            OrgWideEmailAddress[] oOrgWideEmail = [SELECT DisplayName, Address, Id FROM OrgWideEmailAddress where DisplayName =:VSTSSettings.ESC_From_Address__c];
                if(oOrgWideEmail.size() >0)
                {
                    mail.setOrgWideEmailAddressId(oOrgWideEmail.get(0).Id);
                }
            mail.setToAddresses(toAddresses);
            mail.setSubject(VSTSSettings.ESC_Subject__c);
            String emailbody = '';
            if(DBError!=''){
                emailbody ='The Job failed internally  due to the following error \r\n'+DBError;
            }
            else{
            if(VSTSSettings.ESC_EmailBody__c !='' && VSTSSettings.ESC_EmailBody__c!=null){
                emailbody=VSTSSettings.ESC_EmailBody__c+'\r\n';
            }
            for(Id FailedId: DataErrorRecords1){
                emailbody+='\r\n'+URL.getSalesforceBaseUrl().toExternalForm() +'/'+FailedId;
            }
            }
            
            mail.setHtmlBody(emailbody);
            System.debug('mail '+mail);
            if(!Test.isRunningTest())
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }
        }
   
        ESC_VSTSStagingScheduler VSTSScheduler = new ESC_VSTSStagingScheduler();       
        Datetime dt = DateTime.now();
        
        dt = dt.addMinutes(Integer.valueOf(VSTSSettings.ESC_BatchSchedule_Interval__c));     
        String sch = String.valueOf( dt.second() ) + ' ' + String.valueOf( dt.minute()   ) + ' ' + String.valueOf( dt.hour() ) + ' '  + String.valueOf( dt.day() ) +  ' ' + String.valueOf( dt.month() ) + ' '  + '? ' + String.valueOf( dt.Year());
                
        List<CronTrigger> cronTgr1 = [SELECT id FROM CronTrigger WHERE id =: idcron or id=: VSTSSettings.ESC_Current_Job_ID__c];  
            if(!cronTgr1.isempty()){
                for(CronTrigger crnTgr: cronTgr1){                
                    system.abortjob(crnTgr.Id);  
                }        
            }            
            
            VSTSSettings.ESC_Current_Job_ID__c = system.schedule('ESCVSTSStaging'+ String.valueof(dt),sch,VSTSScheduler);
            update VSTSSettings; 
    }
        
    }