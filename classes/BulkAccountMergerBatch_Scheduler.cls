/***********************************************************************************************
Purpose      : Scheduler class for BulkAccountMergerBatch class 
Developed By : TCS Offshore
Date         : 11/23/2016
Changed Log  :
************************************************************************************************/
global class BulkAccountMergerBatch_Scheduler implements Schedulable{

    global void execute(SchedulableContext sc) {
        BulkAccountMergerBatch bulkAccMergeBatch = new BulkAccountMergerBatch();
        Database.executeBatch(bulkAccMergeBatch,1);          
    }
}