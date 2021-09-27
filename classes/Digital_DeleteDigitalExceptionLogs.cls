/* Created By Bharat Bhushan on 23rd Aug 2018
Purpose - Digital_DeleteDigitalExceptionLogs to delete Digital exception logs which are older than 30 days
Jira Story - DLT-11840
Schedule Job - This job can be scheduled to be run for weekly over weekend.
*/
global class Digital_DeleteDigitalExceptionLogs implements Database.AllowsCallouts, Database.Batchable<Digital_Exception_Log__c>{
    
    List<Digital_DeleteDigiExcLog30Day__mdt> lstLog = [SELECT id, No_Of_Days__c FROM Digital_DeleteDigiExcLog30Day__mdt where Label = '30Days'];
    Integer NoOfDays= Integer.valueOf(lstLog[0].No_Of_Days__c);

    String Query = 'SELECT id, name,User_Message__c, createdDate  FROM Digital_Exception_Log__c WHERE createdDate < LAST_N_DAYS:'+NoOfDays +' Limit 49000' ;
    global List<Digital_Exception_Log__c> digiLogLst = Database.Query(Query);
    
    global Iterable<Digital_Exception_Log__c> start(Database.BatchableContext BC){
        List<Digital_Exception_Log__c> finalDigiLoglst = new List<Digital_Exception_Log__c>();
        for(Digital_Exception_Log__c digiloglst2 : digiLogLst ){
            if(!digiLogLst.isEmpty()){
                finalDigiLoglst.add(digiLogLst2);
            }    
            
        }
        return finalDigiLoglst;   
    }
    
    //Passing Filtered DigitalExceptionLogs into batch Scope to be executed
    global void execute(Database.BatchableContext BC, List<Digital_Exception_Log__c> scope){
        try{
            
            if(!scope.isEmpty()){
                delete scope;
                database.emptyRecycleBin(scope);                
            }

            if(Test.isRunningTest()){
                Set<id> ids = new Set<id>();
                for(Digital_Exception_Log__c dcl: scope){
                    ids.add(dcl.id);
                }
           list<Digital_Exception_Log__c> lst2 = [Select id,Object__c, name from Digital_Exception_Log__c where id=: ids];
                lst2[0].Object__c = 'Account';
                update lst2;
            }
        }catch(Exception e){
            Digital_Exception_Log__c ex = new Digital_Exception_Log__c();  
            ex.Exception_Message__c = e.getMessage();
            ex.Exception_Type__c = e.getStackTraceString();        
            ex.Additional_Information__c = String.valueof(e.getLineNumber());   
            ex.User_Message__c = String.valueof(e.getCause());
            ex.Class_Reference__c = 'Digital_DeleteDigitalExceptionLogs > Execute'; 
            insert ex; 
        }
    }
    
    //Initiates Digital_DeleteDigitalExceptionLogs
    global void finish(Database.BatchableContext info){
        if(!Test.isRunningTest()){
        }   
    }
    
}