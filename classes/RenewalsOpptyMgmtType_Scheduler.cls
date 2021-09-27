global class RenewalsOpptyMgmtType_Scheduler implements Schedulable{

    global void execute(SchedulableContext sc) {

        RenewalsOpptyMgmtType_Batch renOppMgmtType = new RenewalsOpptyMgmtType_Batch();
        Database.executeBatch(renOppMgmtType,200);           
    }
}