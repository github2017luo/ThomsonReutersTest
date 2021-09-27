/***********************************************************************************************
Purpose      : Test class for CaseMgmtBatch_Scheduler class 
Developed By : Anshu Thakur
Date         : 12/20/2016
Changed Log  :
************************************************************************************************/
@istest
private class CaseMgmtBatch_Scheduler_Test{
    public static testmethod void callCaseMgmtBatchSch(){

        //Caling method from UnitTest class to prepare test data for Custom Settings
        UnitTest.createTestData();

        //Preparing Case data
        Case objCase = new Case();
        objCase.Status = 'On Hold';
        objCase.CurrencyIsoCode = 'USD';
        objCase.Origin = 'Fax';
        INSERT objCase;

        //Preparing Batch class scheduler
        Test.StartTest();
        CaseMgmtBatch_Scheduler caseMgmtBthSch = new CaseMgmtBatch_Scheduler();
        String sch = '0 00 00 * * ?';
        System.schedule('My batch Job', sch, caseMgmtBthSch);
        Test.StopTest();
    }
}