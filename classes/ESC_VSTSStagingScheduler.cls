global class ESC_VSTSStagingScheduler implements Schedulable{  

  global void execute(SchedulableContext ctx){ 
     try{  
        List<AsyncApexJob> lstApexJob = [SELECT id from AsyncApexJob 
                                 Where ApexClassID IN (SELECT id FROM 
                                 ApexClass WHERE Name = 'ESC_VSTSStagingBatch') 
                                 AND (Status IN ('Queued','Processing','Preparing','Holding'))
                                 Limit 1 ];         
             
        if(lstApexJob.isempty()){                          
                ESC_VSTS_StagingBatch VSTSStagingBatch = new ESC_VSTS_StagingBatch();
                ESC_ServiceNow_Scheduler_Settings__c VSTSSettings= ESC_ServiceNow_Scheduler_Settings__c.getInstance('VSTS Scheduler Settings');
                VSTSStagingBatch.idcron = ctx.getTriggerId();          
                database.executebatch(VSTSStagingBatch,Integer.valueOf(VSTSSettings.ESC_BatchSize__c));
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