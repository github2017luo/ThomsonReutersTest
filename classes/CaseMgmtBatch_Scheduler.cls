/***********************************************************************************************
Purpose      : Scheduler class for CaseMgmtBatch class 
Developed By : Anshu Thakur
Date         : 12/15/2016
Changed Log  :
************************************************************************************************/
global class CaseMgmtBatch_Scheduler implements Schedulable{

    global void execute(SchedulableContext sc) {
        CaseMgmtBatch objCaseMgmtBatch = new CaseMgmtBatch();
        Database.executeBatch(objCaseMgmtBatch,200);          
    }
}