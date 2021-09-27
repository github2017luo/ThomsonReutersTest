/*
======================================================================================================================
CLASS NAME:  TMSTerritory_TerritoryBatch 
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

global class TMSTerritory_TerritoryBatch implements Database.Batchable<SObject>, Database.Stateful{ 
    
    private String Query;
    /*private Datetime TMSJobStartedDate;
    public DateTime TerritorycurrentDateTime;*/
    // Start Method
    global Database.QueryLocator start(Database.BatchableContext BcthCon){  
    
    //To bypass test coverage at the time of deployment after removing all functionality
        Query = 'select id from Account limit 1';     
        /*System.debug('**Territories_Batch started***');
        TerritorycurrentDateTime = DateTime.now();
        System.debug('TerritorycurrentDateTime **'+TerritorycurrentDateTime );
        GLI_Load_Tracker__c gli_tracker = [select id,name,JobCompletedDate__c,TerritoryJobStartedDate__c from GLI_Load_Tracker__c where name='Informatica Territory Load'];

        TMSJobStartedDate = gli_tracker.TerritoryJobStartedDate__c ;
        System.debug('TMSJobStartedDate***'+TMSJobStartedDate);
        set<Id> TerritoryIDS = new set<Id>();
        if(TMSJobStartedDate != null){
            for(Territory terrRec:[SELECT Id,name,LastModifiedDate FROM Territory where LastModifiedDate>:TMSJobStartedDate]){
                TerritoryIDS.add(terrRec.Id);
            }
        }else{
            for(Territory terrRec:[SELECT Id,name,LastModifiedDate FROM Territory]){
                TerritoryIDS.add(terrRec.Id);
            }
        }
        Set<Id> GLIaccountRec = new Set<ID>();        
        for(RecordType GLIRecordtypeId:[SELECT Id, Name, DeveloperName, NamespacePrefix, Description, BusinessProcessId, SobjectType, IsActive FROM RecordType where SobjectType='Account' and Name like '%GLI%']){
            GLIaccountRec.add(GLIRecordtypeId.id);
        }
        System.debug('GLIaccountRec**'+GLIaccountRec);
        if(!GLIaccountRec.isempty()){
             query ='SELECT Id, Name, RestrictOpportunityTransfer__c, ParentTerritory__c, DeveloperName__c, ForecastUser__c, MayForecastManagerShare__c, Region__c, TMS_Market_Segment_Desc__c, TMS_Market_Segment_ID__c, TMS_New_Sales_Quota_Curr_Yr__c, TMS_Parent_Territory_ID__c, TMS_Renewal_Sales_Quota_Curr_Yr__c, TMS_Rep_Function_Desc__c, TMS_Rep_Function_ID__c, TMS_Sales_Force_Desc__c, TMS_Sales_Force_ID__c, TMS_Territory_ID__c, TMS_Territory_Number__c, Account__c,Account__r.IS_GLI__c, Territory_ID__c, District__c, AccountAccessLevel__c, CaseAccessLevel__c, ContactAccessLevel__c, Description__c, OpportunityAccessLevel__c, TMS_Sales_Force_Code__c, TMS_Market_Segment_Code__c, TMS_Ref_Function_Code__c,Channel__c,LCRM_AccountTeamMemberUserId__c FROM TMS_Territory__c where Account__r.RecordTypeId IN :GLIaccountRec';
            if(!TerritoryIDS.isEmpty()){
                Query +=' and Territory_ID__c IN :TerritoryIDS';
            }else{
                Query +=' limit 1';
          }
       }
        
       system.debug('Query**'+Query);*/
       return Database.getQueryLocator(Query);
    }

    global void execute(Database.BatchableContext bcContext, List<sObject> scope){
         /*System.debug('**Territory Executed**');
         if(!scope.isempty()){         
             TMSTerritoryBatchHelper.UpdateTMSTerritory(scope);
         }*/
        
    } 
    global void finish(Database.BatchableContext bcContext) {
        /*System.debug('***Finish Method Started **');
        System.debug('currentDateTime***'+TerritorycurrentDateTime);        
        GLI_Load_Tracker__c gli_tracker = [select id,name,JobCompletedDate__c,TerritoryJobStartedDate__c from GLI_Load_Tracker__c where name='Informatica Territory Load'];       
        gli_tracker.TerritoryJobStartedDate__c= TerritorycurrentDateTime;
        update gli_tracker; 
        LCRM_BatchsizeDefine__c objGame = LCRM_BatchsizeDefine__c.getValues('Display_AccTerritory_Batch');
        System.debug('objGame:-'+objGame);
        System.debug('Batch_Size__c'+objGame.Batch_Size__c);
        
        if(objGame.Batch_Size__c!=null && !Test.isRunningTest()){             
            //Temp code by Arpit
            Display_AccTerritory_Batch AccountTerritoryLoad = new Display_AccTerritory_Batch();
            Database.executeBatch(AccountTerritoryLoad,integer.valueof(objGame.Batch_Size__c)); 
        }*/
    }
    
}