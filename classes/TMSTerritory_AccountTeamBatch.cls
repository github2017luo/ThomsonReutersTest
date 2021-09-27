/*
======================================================================================================================
CLASS NAME:  TMSTerritory_AccountTeamBatch
======================================================================================================================
PURPOSE:  A new batch needs to be written to load TMS Territory and Account Territory from Territory. Refresh periodically after the informatica job runs.
Technical Details:  A new batch class needs to be created in SFDC to populate TMS Territory and Account Territory Objects
JIRA story: CRM-11669 Display Territories in GLI - SFDC Batch classes
CHANGE HISTORY:

======================================================================================================================
DATE           Developer NAME              DESC
24/07/2018      Radhika Pawar     
======================================================================================================================
*/

//Commenting out as a part of removal of TM1.0 components

global class TMSTerritory_AccountTeamBatch implements Database.Batchable<SObject>, Database.Stateful{
    
    private String Query;
    /*private Datetime TMSJobStartedDate;
    public DateTime currentDateTime;*/
    
    // Start Method
    global Database.QueryLocator start(Database.BatchableContext BcthCon){ 
        //To bypass test coverage at the time of deployment after removing all functionality
        Query = 'select id from Account limit 1';
        /*currentDateTime= DateTime.now();
        System.debug('currentDateTime**'+currentDateTime);
        Set<Id> GLIaccountRec = new Set<ID>();        
        for(GLI_Record_type_Ids__c GLIRecordtypeId:GLI_Record_type_Ids__c.getall().values()){
            GLIaccountRec.add(GLIRecordtypeId.GLI_Account_RecordTypeId__c);
        }       
        
        GLI_Load_Tracker__c gli_tracker = [select id,name,JobCompletedDate__c,AccountTeamJobStartedDate__c from GLI_Load_Tracker__c where name='Informatica Territory Load'];

        TMSJobStartedDate = gli_tracker.AccountTeamJobStartedDate__c;
        System.debug('TMSJobStartedDate***'+TMSJobStartedDate);
        System.debug('GLIaccountRec Record type IDS**'+GLIaccountRec);
        if(!GLIaccountRec.isempty()){
            if(TMSJobStartedDate==null){
            Query ='SELECT Id, AccountId,Account.RecordTypeId, UserId, TeamMemberRole, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, IsDeleted FROM AccountTeamMember where Account.RecordTypeId IN :GLIaccountRec';
            System.debug('Account Query:-'+Query);
            }else{
            Query ='SELECT Id, AccountId,Account.RecordTypeId, UserId, TeamMemberRole, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, IsDeleted FROM AccountTeamMember where LastModifiedDate>:TMSJobStartedDate and Account.RecordTypeId IN :GLIaccountRec';
            System.debug('Account Query:-'+Query);
            }
        }
        System.debug('Database.getQueryLocator(Query)**'+Database.getQueryLocator(Query));*/
        return Database.getQueryLocator(Query);
    }

    global void execute(Database.BatchableContext bcContext, List<sObject> scope){
         /*System.debug('scope***'+scope.size());
         if(!scope.isempty()){                      
             TMSTerritoryBatchHelper.CreateTMSTerritory(scope);
         }*/
        
    } 
    global void finish(Database.BatchableContext bcContext) {
        /*System.debug('***Finish Method Started **');
        System.debug('currentDateTime***'+currentDateTime);        
        GLI_Load_Tracker__c gli_tracker = [select id,name,JobCompletedDate__c,AccountTeamJobStartedDate__c from GLI_Load_Tracker__c where name='Informatica Territory Load'];       
        
        gli_tracker.AccountTeamJobStartedDate__c = currentDateTime;
        update gli_tracker;   
        
        LCRM_BatchsizeDefine__c objGame = LCRM_BatchsizeDefine__c.getValues('TMSTerritory_TerritoryBatch');
        System.debug('objGame:-'+objGame);
        System.debug('Batch_Size__c'+objGame.Batch_Size__c);
        
        TMSTerritory_TerritoryBatch UpdateTerritoryLoad = new TMSTerritory_TerritoryBatch();
         if(!Test.isRunningTest()){            
            Database.executeBatch(UpdateTerritoryLoad,integer.valueof(objGame.Batch_Size__c));      
           } */        
    }
    
}