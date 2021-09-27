/***********************************************************************************************
Purpose      : Test class for BatchForCaseEscaletion_Scheduler class 
Developed By : TCS Offshore
Date         : 01/05/2017
Changed Log  :
************************************************************************************************/
@istest
private class BatchForCaseEscaletion_Scheduler_Test{
    public static testmethod void callBatchCaseEsclSch(){

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
        BatchForCaseEscaletion_Scheduler batchCaseEsclSch = new BatchForCaseEscaletion_Scheduler();
        String sch = '0 00 00 * * ?';
        System.schedule('My batch Job', sch, batchCaseEsclSch);
        Test.StopTest();
    }
}