/*
======================================================================================================================
CLASS NAME:  Display_AccTerritory_Batch
======================================================================================================================
PURPOSE:  A new batch needs to be written to load TMS Territory and Account Territory from Territory. Refresh periodically after the informatica job runs.
Technical Details:  A new batch class needs to be created in SFDC to populate TMS Territory and Account Territory Objects
JIRA story: CRM-11669 Display Territories in GLI - SFDC Batch classes
CHANGE HISTORY:

======================================================================================================================
DATE           Developer NAME              DESC
8/12/2017      Radhika Pawar     
======================================================================================================================
*/

//Commenting out as a part of removal of TM1.0 components
global class Display_AccTerritory_Batch implements Database.Batchable<SObject>, Database.Stateful{ 
    private String Query;
   /* private Datetime TMSJobStartedDate;
    public DateTime currentDateTime;
     
    *Start Method
    *1. Use Custom setting to stored the GLI Account record type ID 
    *2. SOQL: GLI Account*/
    
    global Database.QueryLocator start(Database.BatchableContext BcthCon){
         //To bypass test coverage at the time of deployment after removing all functionality
        Query = 'select id from Account limit 1';    
        /*Set<Id> GLIaccountRec = new Set<ID>();        
        currentDateTime= DateTime.now();
        for(GLI_Record_type_Ids__c GLIRecordtypeId:GLI_Record_type_Ids__c.getall().values()){
        GLIaccountRec.add(GLIRecordtypeId.GLI_Account_RecordTypeId__c);
        }
        System.debug('GLIaccountRec:-'+GLIaccountRec);
        
        The Account Job will be executed after TMS Territory Job. 
        GLI_Load_Tracker__c gli_tracker = [select id,name,JobCompletedDate__c,AccountTerritoryJobStartedDate__c, TerritoryJobStartedDate__c from GLI_Load_Tracker__c where name='Informatica Territory Load'];
        TMSJobStartedDate = gli_tracker.AccountTerritoryJobStartedDate__c;
        
        if(!GLIaccountRec.isempty()){
            
            if(TMSJobStartedDate==null){
            Query ='Select id,Account__c,Account__r.RecordtypeId,Territory_ID__c,TMS_Sales_Force_Code__c,TMS_Market_Segment_Code__c,TMS_Ref_Function_Code__c from TMS_Territory__c where TMS_Sales_Force_Code__c !=null and TMS_Market_Segment_Code__c != null and TMS_Ref_Function_Code__c !=null and Territory_ID__c != null and Account__r.RecordtypeId IN :GLIaccountRec';
            System.debug('TMS Territory Query - Full :-'+Query);
            }else{
            Query ='Select id,Account__c,Territory_ID__c,TMS_Sales_Force_Code__c,TMS_Market_Segment_Code__c,TMS_Ref_Function_Code__c from TMS_Territory__c where lastmodifieddate>=:TMSJobStartedDate and TMS_Sales_Force_Code__c !=null and TMS_Market_Segment_Code__c != null and TMS_Ref_Function_Code__c !=null and Territory_ID__c != null and Account__r.RecordtypeId IN :GLIaccountRec';
            System.debug('TMS Territory Query - LastModified By:-'+Query);
            }
        }
        System.debug('Database.getQueryLocator(Query)***'+Database.getQueryLocator(Query));
        */
        return Database.getQueryLocator(Query);
    }
    
    
    //*In execute method, using the helper class for performing the Delta functionality for Account territory.
   
    global void execute(Database.BatchableContext bcContext, List<sobject> listTMSTerrRecs){
       /*  system.debug('++++ TMS Terr Size '+ listTMSTerrRecs.size()); 
         Call the below method for updating and creating the accountTerritoty
         if(!listTMSTerrRecs.isempty()){ 
             AccountTerritoriesHandler.AccountTerrCreationandUpdation(listTMSTerrRecs);         
         } */
     } 
     
    global void finish(Database.BatchableContext bcContext) {
        /* System.debug('currentDateTime**'+currentDateTime);
        GLI_Load_Tracker__c gli_tracker = [select id,name,JobCompletedDate__c,TerritoryJobStartedDate__c from GLI_Load_Tracker__c where name='Informatica Territory Load'];       
        gli_tracker.AccountTerritoryJobStartedDate__c= currentDateTime; 
        update gli_tracker;  
        */
    }
    
}