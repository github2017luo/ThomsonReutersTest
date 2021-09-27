public without sharing class  TRStoremicrositeLeadDeleteSchedule implements Schedulable {
    
    
    
    public void execute(SchedulableContext ctx) {
        
        integer noOfrecords = 200;
        
        if(Static_Values__c.getAll().containsKey('micrositesNoOfRecordstoDelete')){
            String noOfRec = Static_Values__c.getAll().get('micrositesNoOfRecordstoDelete').Value__c ;
            noOfrecords = integer.valueOf(noOfRec);
        }
        
        //Calling Batch Apex class to delete 30 days prior microsite records != null
        id batchJobId = Database.executeBatch(new TRStoremicrositeLeadDeleteBatch(), noOfrecords);
         
         
         
         // Schedule this deletion of TRStore Microsite leads for every business day. 
         // Based on this schedule 30 days prior records will delete from DB
        
         TRStoremicrositeLeadDeleteSchedule m = new TRStoremicrositeLeadDeleteSchedule();
         String sch = Static_Values__c.getAll().get('micrositesToDeleteTimeFrame').Value__c ; //'0 0 21 ? * MON-FRI *';
         if(!test.isRunningTest())
             String jobID = system.schedule('Delete Microsite Leads', sch, m);
         

    }


}