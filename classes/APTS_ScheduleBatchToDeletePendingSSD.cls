/**********************************************************************

Copyright © 2017 TATA CONSULTANCY SERVICES.

---------------------------------------------------------------------------------------

Req: CRM-10886 : Develop - Parameters for deleting pending customer only in Salesforce

----------------------------------------------------------------------------------------

Purpose : Scheduling Batch class to Delete all Pending SSD records 

----------------------------------------------------------------------------------------

History :

1.0     Tejaswi Nissankula      01/04/2018
1.1     Gayatri                 23/01/2019    SOC-9697 PMD fix added
**********************************************************************/

global without sharing class APTS_ScheduleBatchToDeletePendingSSD implements Schedulable{

    global void execute(SchedulableContext sc){
        Database.executeBatch(new APTS_BatchToDeletePendingAccounts());
    }

}