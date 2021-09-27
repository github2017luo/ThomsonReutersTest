public without sharing class TRStoreDeleteOrphancartsUtilitySchedule implements Schedulable {
    
    
    
    public void execute(SchedulableContext ctx) {
        
         
        //Calling Batch Apex class to delete 30 days prior microsite records 
       id batchJobId = Database.executeBatch(new TRStoreDeleteOrphancartsUtility(), 200);
         
         
         
         // Schedule this deletion Cart records ids . 
         // Based on this schedule 90 days prior records will delete from DB
       /* 
         TRStoreDeleteOrphancartsUtilitySchedule m = new TRStoreDeleteOrphancartsUtilitySchedule();
         if(Static_Values__c.getAll().containskey('cartDeleteTimeFrame')){
             String sch = Static_Values__c.getAll().get('cartDeleteTimeFrame').Value__c ; //'0 0 21 ? * MON-FRI *';
             if(!test.isRunningTest())
                 String jobID = system.schedule('Delete Orphan Carts', sch, m);
         
         }
         */
    }


}