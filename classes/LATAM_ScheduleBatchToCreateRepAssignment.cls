/**********************************************************************
Copyright © 2018 TATA CONSULTANCY SERVICES.
---------------------------------------------------------------------------------------
Author, Kruti Shah
----------------------------------------------------------------------------------------
Purpose : Schedulable class for Batch Class LATAM_BatchToCreateRepAssignment
**********************************************************************/
global without sharing class LATAM_ScheduleBatchToCreateRepAssignment implements Schedulable{
    global void execute(SchedulableContext sc){
        Database.executeBatch(new LATAM_BatchToCreateRepAssignment());
    }
}