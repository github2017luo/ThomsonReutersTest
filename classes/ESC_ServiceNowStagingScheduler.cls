global class ESC_ServiceNowStagingScheduler implements Schedulable{  

  global void execute(SchedulableContext ctx){ 
     try{  
        List<AsyncApexJob> lstApexJob = [SELECT id from AsyncApexJob 
                                 Where ApexClassID IN (SELECT id FROM 
                                 ApexClass WHERE Name = 'ESC_ServiceNowStagingBatch') 
                                 AND (Status IN ('Queued','Processing','Preparing','Holding'))
                                 Limit 1 ];         
             
        if(lstApexJob.isempty()){                          
                ESC_ServiceNowStagingBatch ServiceNowStagingBatch = new ESC_ServiceNowStagingBatch();
                ESC_ServiceNow_Scheduler_Settings__c SNSettings = ESC_ServiceNow_Scheduler_Settings__c.getInstance('ServiceNowSettings');
                    ServiceNowStagingBatch.idcron = ctx.getTriggerId();          
                        database.executebatch(ServiceNowStagingBatch,Integer.valueOf(SNSettings.ESC_BatchSize__c));
        }
        else{
            System.abortJob(ctx.getTriggerId()); 
        }
    }    
    catch(exception ex){         
             System.abortJob(ctx.getTriggerId());
    }  
    
  }
}