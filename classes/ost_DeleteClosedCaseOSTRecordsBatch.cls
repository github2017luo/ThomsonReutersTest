/**
 *  ost_DeleteClosedCaseOSTRecordsBatch.cls
 *
 *  @description
 *      Class for cleaning out old OST Time Logs
 *
 *  @date - 19/JUNE/2015
 *  @author - Dan Reich: Traction on Demand
 */
global class ost_DeleteClosedCaseOSTRecordsBatch implements Database.Batchable<sObject> {
    Datetime maxCaseClosedDate;
    String query;
    
    global ost_DeleteClosedCaseOSTRecordsBatch() {
        OST_CleanUpConfig__c conf = OST_CleanUpConfig__c.getInstance();
        maxCaseClosedDate = System.today().addDays( Math.round( conf.Days_To_Store_After_Case_Closure__c ) );
        query = 'SELECT Id FROM Time_Log__c WHERE Case__r.IsClosed = true AND Case__r.ClosedDate < :maxCaseClosedDate';
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<sObject> scope) {
        delete scope;
        DataBase.emptyRecycleBin(scope); 
    }
    
    global void finish(Database.BatchableContext BC) {
        
    }
    
    public static void executeBatch() {
        Database.executeBatch( new ost_DeleteClosedCaseOSTRecordsBatch(), 2000 );
    }
}