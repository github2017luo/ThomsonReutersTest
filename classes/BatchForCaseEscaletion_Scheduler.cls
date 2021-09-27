/***********************************************************************************************
Purpose      : Scheduler class for BatchForCaseEscaletion class 
Developed By : TCS Offshore
Date         : 01/05/2017
Changed Log  :
************************************************************************************************/
global class BatchForCaseEscaletion_Scheduler implements Schedulable{

    global void execute(SchedulableContext sc) {
        BatchForCaseEscaletion batchCaseEscl = new BatchForCaseEscaletion();
        Database.executeBatch(batchCaseEscl,200);          
    }
}