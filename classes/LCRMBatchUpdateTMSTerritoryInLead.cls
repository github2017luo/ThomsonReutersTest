//Commenting out as a part of removal of TM1.0 components

global class LCRMBatchUpdateTMSTerritoryInLead implements Database.Batchable<SObject> {
    //Map<Id,User> mapOfIntegrationUsers = new Map<Id,User>();
    
    global Database.QueryLocator start (Database.BatchableContext BC){
        String query = 'select id from lead limit 1';
        /*mapOfIntegrationUsers = LCRMLeadTerritoryService.getIntegartionUsersDetails();
        List<String> ListOfleadStatus = new list<String>{'Converted','Discarded','Disqualified'};
        //Datetime maxstampDate;    
        Datetime LCRMLeadStartDate;
        
       *List<aggregateResult> ListOfLeadForMaxValue = [select Max(LCRM_Territory_Update_Timestamp__c)  from Lead WHERE Is_GLI__c = true AND  
                                        Status not IN: ListOfleadStatus AND LastModifiedById IN: mapOfIntegrationUsers.keyset() ];
              
       
        if(!ListOfLeadForMaxValue.isEmpty()){
            for (aggregateResult ar : ListOfLeadForMaxValue){
                System.debug('LCRM_Territory_Update_Timestamp__c:: '+ar.get('expr0'));
                maxstampDate = Date.valueOf(ar.get('expr0'));
            }
        }*
            GLI_Load_Tracker__c gli_tracker = [select id,name,JobCompletedDate__c, LCRMOpportunityStartDate__c from GLI_Load_Tracker__c
            where name='Lead Assignment'];
            LCRMLeadStartDate = gli_tracker.LCRMOpportunityStartDate__c ;
            System.debug('@@LCRMLeadStartDate'+LCRMLeadStartDate);
            
            Set<Id> SetOfkeys = mapOfIntegrationUsers.keyset();// This set is needed for to build dynamic query because keySet() is not working directly

            query ='SELECT Id , Is_GLI__c,Status,LCRM_Mass_Load_Indicator__c,Account__c,Ownerid,LCRM_Lead_Owner_TMS_Territory__c, Name ,LastModifiedById,lastmodifieddate from Lead ';
            query += ' where Is_GLI__c = true ';
            query += ' AND Account__c != null ';            
            //query += ' AND (lastmodifieddate >: maxstampDate OR LCRM_Territory_Update_Timestamp__c = null)';
            query += ' AND (lastmodifieddate > : LCRMLeadStartDate)';
            query += ' AND LCRM_Mass_Load_Indicator__c = true';
            query +=' AND LastModifiedById IN: SetOfkeys';
            query +=' AND Status NOT IN: ListOfleadStatus';
            
               system.debug('@@@the final query'+query);*/
        
        return Database.getQueryLocator(query);
    }
    
    global void execute (Database.BatchableContext BC, List<Lead> scope){
       /*list<Lead> listOfLeadToBeProcessed = new list<Lead>();
       system.debug('@@the scope is size'+scope.size());
       system.debug('@@the scope is'+scope );
       
       
       // Processing the records - assigning the territory number to lead.
       LCRMLeadTerritoryService.stopTrigger();//Restrict executing LCRMLeadTerritoryService class functionality twice through trigger while lead records are processing through batch.
       LCRMLeadTerritoryService.updateLeadTerritoryNumber(scope);
       system.debug('@@scope after processing'+scope);
        try{
             if(scope.size()>0){
                 system.debug('@@@@@@LCRMLeadTerritoryService.allowTriggerHandlerToRun'+LCRMLeadTerritoryService.allowTriggerHandlerToRun);
                 Database.SaveResult[] srList = Database.Update(scope,false);
             }
         }Catch(Exception e){
             System.debug('Exception is'+e);             
             
         }  */      
    }
    global void finish(Database.BatchableContext BC){
        /*GLI_Load_Tracker__c gli_tracker_finish = [select id,name,JobCompletedDate__c,TerritoryJobStartedDate__c,LCRMOpportunityStartDate__c from GLI_Load_Tracker__c where name='Lead Assignment'];
         gli_tracker_finish.LCRMOpportunityStartDate__c = Datetime.now();
        Update gli_tracker_finish;
        
        system.debug('STOP**');*/
    }

}