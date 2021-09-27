global class DeleteMARecordsScheduled implements Schedulable{
    global void execute(SchedulableContext SC) {
        String query = 'select Id FROM ELOQUA__Marketing_Activity__c WHERE createddate != LAST_N_DAYS:13';
        
        DeleteMArecord delMA = new DeleteMArecord(query);
        Id BatchProcessId = Database.ExecuteBatch(delMA);
    }
}