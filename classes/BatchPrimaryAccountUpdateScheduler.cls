global class BatchPrimaryAccountUpdateScheduler implements Schedulable{
    global void execute(SchedulableContext sc){
        Integer batchSize = 200;
        try{
            batchSize = Integer.valueOF(KeyValueListStore__c.getInstance('BatchPrimaryAccountUpdate').TextValue__c);
            batchSize = (batchSize==null || batchSize==0)?200:batchSize;
        }catch(Exception e){}
        Database.executeBatch(new BatchPrimaryAccountUpdate(), batchSize);
    }
}