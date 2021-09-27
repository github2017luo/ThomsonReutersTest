/*

Class name   : LcrmOpptyTerrIdUpdateBatch
Purpose      : Calls 'LCRMOpportunityTerritoryService' class and updates opportunity field  named 'territoryid'
of the respective owner of the opportunity
Developed By : TCS
Date         : 20-03-2018

*/

global class LcrmOpptyTerrIdUpdateBatch implements Database.Batchable<SObject> {
    //Commenting out as a part of removal of TM1.0 components
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        
        //To bypass test coverage at the time of deployment after removing all functionality
        String query = 'select id from Opportunity limit 1';
        /*Final String oppStatus = 'Open';
        
        Datetime maxstampDate;
        
        Datetime GLITrackerCompletionDate;
        Datetime LCRMOpportunityStartDate;
        
        Id InformaticaUserId;
        Set<Id> InformaticaUserSetId = new Set<Id>();
        String InformaticaGLIUser = Label.LCRM_Informatica_GLI_Integration;
        System.debug('InformaticaGLIUser@@'+InformaticaGLIUser);
         List<String> nameList = new List<String>();
        
        
        
        
        
        List<String> stageList = new List<String>();
        Set<String> stageSet = new Set<String>();
        
         if(String.isnotempty(InformaticaGLIUser) && String.isnotblank(InformaticaGLIUser)){
            nameList = InformaticaGLIUser.split(',');
        }
        System.debug('nameSet@@'+nameList);
        
        
        Map<Id, User> userMap = new Map<Id, User>([Select id FROM User Where Name in : nameList]);
        System.debug('userMap'+userMap);
        System.debug('userMap'+userMap.size());
        InformaticaUserSetId = userMap.keyset();
        //InformaticaUserId = [Select id FROM User Where name =: InformaticaGLIUser].id;
        //InformaticaUserSetId.add(InformaticaUserId);
        
    
        //Contract Signed, Order Complete, Closed Lost
        KeyValueListStore__c tempStageValueStore = KeyValueListStore__c.getValues('LCRMOpptyTerritoryStageValues');
        system.debug('tempStageValueStore'+tempStageValueStore);
        if(tempStageValueStore !=null && tempStageValueStore.TextValue__c !=null && tempStageValueStore.TextValue__c !=''){
            stageList = tempStageValueStore.TextValue__c.split(',');
        }               
        for(String stageins : stageList){            
            stageSet.add(stageins);
        } 
        
        
        *

Purpose: We have used max aggregate of 'LCRM_Territory_Update_Timestamp__c' opportunity field to fetch the opportunities which are last updated or created in 
24 hours. The fetched opportunities are furthers processed with the help of service class and territory id is assigned to the opportunity.

*
        if(!InformaticaUserSetId.isEmpty()){
           * List<aggregateResult> results = [select Max(LCRM_Territory_Update_Timestamp__c) from opportunity WHERE Is_GLI__c = true AND lastmodifiedbyId IN : InformaticaUserSetId AND LCRM_Territory_Update_Timestamp__c != null AND CreatedDate < LAST_N_DAYS:7];
            
            if(!results.isEmpty()){
                for (aggregateResult ar : results){
                    
                    maxstampDate = Date.valueOf(ar.get('expr0'));
                }
                
            }*
            
            GLI_Load_Tracker__c gli_tracker = [select id,name,JobCompletedDate__c,TerritoryJobStartedDate__c,LCRMOpportunityStartDate__c from GLI_Load_Tracker__c where name='Opportunity Assignment'];
            GLITrackerCompletionDate = gli_tracker.JobCompletedDate__c;
            LCRMOpportunityStartDate = gli_tracker.LCRMOpportunityStartDate__c;
            System.debug('GLITrackerCompletionDate'+GLITrackerCompletionDate);
            
        }
        
        
        System.debug('maxstampDate :: '+maxstampDate);      
         System.debug('GLITrackerCompletionDate'+GLITrackerCompletionDate);
        *
        query = 'SELECT Id,accountid,Name,StageName,Is_GLI__c,LCRM_Status__c,ownerId,lastmodifieddate,lastmodifiedbyid,lastmodifiedby.name,';
        query += ' territoryid,LCRM_Territory_Update_Timestamp__c FROM Opportunity WHERE Is_GLI__c = true ';
        query += ' AND StageName NOT IN : stageSet'; 
        query += ' AND  lastmodifiedbyId IN : InformaticaUserSetId';
        query += ' AND (lastmodifieddate >: maxstampDate OR LCRM_Territory_Update_Timestamp__c = null)';
        System.debug('query'+query);
        System.debug('Database.getQueryLocator(query)**'+Database.getQueryLocator(query));
        *
        query = 'SELECT Id,accountid,Name,StageName,Is_GLI__c,LCRM_Status__c,ownerId,lastmodifieddate,lastmodifiedbyid,lastmodifiedby.name,';
        query += ' territoryid,LCRM_Territory_Update_Timestamp__c FROM Opportunity WHERE Is_GLI__c = true ';
        query += ' AND StageName NOT IN : stageSet'; 
        query += ' AND  lastmodifiedbyId IN : InformaticaUserSetId';
        query += ' AND (lastmodifieddate > : LCRMOpportunityStartDate)';
        System.debug('query'+query);
        System.debug('Database.getQueryLocator(query)**'+Database.getQueryLocator(query));*/
        //'LCRMOpportunityStartDate' field is used to fetch the new records.
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext BC, List<Opportunity> scope) {
        
        
        /*LCRMOpportunityTerritoryService.updateOppTerritoryId(false, scope);*/
        
    }
    global void finish(Database.BatchableContext BC) {
        
        /*GLI_Load_Tracker__c gli_tracker_finish = [select id,name,JobCompletedDate__c,TerritoryJobStartedDate__c,LCRMOpportunityStartDate__c from GLI_Load_Tracker__c where name='Opportunity Assignment'];
         gli_tracker_finish.LCRMOpportunityStartDate__c = Datetime.now();
        Update gli_tracker_finish;
        
        system.debug('STOP**');*/
    }
    
}