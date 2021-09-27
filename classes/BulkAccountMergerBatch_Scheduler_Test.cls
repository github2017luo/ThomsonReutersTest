/***********************************************************************************************
Purpose      : Test class for BulkAccountMergerBatch_Scheduler class 
Developed By : TCS Offshore
Date         : 11/23/2016
Changed Log  :
************************************************************************************************/
@istest
private class BulkAccountMergerBatch_Scheduler_Test{
    public static testmethod void callBulkAccMergeBatchSch(){

        //Caling method from UnitTest class to prepare test data for Custom Settings
        UnitTest.createTestData();

        //Preparing Account data
        Account objAcc = UnitTest.getAccountInstance();
        INSERT objAcc;

        //Preparing Batch class scheduler
        Test.StartTest();
        BulkAccountMergerBatch_Scheduler bulkAccMergeSch = new BulkAccountMergerBatch_Scheduler();
        String sch = '0 00 00 * * ?';
        System.schedule('My batch Job', sch, bulkAccMergeSch);
        Test.StopTest();
    }
}