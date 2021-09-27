/*************************************************************
@Name:           LATAM_ScheduleBatchToCreateIndicator
@Author:         Kruti Shah
@CreateDate:     08/09/2019
@Description:	 Schedulable class to call indicator batch class
************************************************************/
global without sharing class LATAM_ScheduleBatchToCreateIndicator implements Schedulable{
    global void execute(SchedulableContext sc){
        Database.executeBatch(new LATAM_BatchToCreateindicator(),150);
    }
}