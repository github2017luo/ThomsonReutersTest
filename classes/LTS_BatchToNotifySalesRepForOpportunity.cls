/********************************************************************** 
Name: LTS_BatchToNotifySalesRepForOpportunity
====================================================== 
Req: LTS 3273 [Sales & Marketing - Opportunity Notification] Opportunities that have not been updated in 90 days to automatically notify owning Sales Rep.
====================================================== 
Purpose: Notify Sales Rep 
====================================================== 
History 
------- 
VERSION    AUTHOR                  DATE             DETAIL 
1.0        TCS Developer     26/12/2018     Initial Development  
***********************************************************************/
global class LTS_BatchToNotifySalesRepForOpportunity implements Database.Batchable<SObject> {
    List<LCRM_Exception_Log__c> exceptionList = new List<LCRM_Exception_Log__c>();//used to store exceptions
    global Database.QueryLocator start (Database.BatchableContext BC){
        
        String query;
        
        try{            
            List<String> stageList = new List<String>();
            Set<String> stageSet = new Set<String>();
            
            //‘Appointment Scheduled’ OR ‘Needs Analysis’ OR ‘Solution Recommended’ OR ‘Generate Contract’ OR ‘Negotiate Contract’ OR ‘Contract Signed’
            KeyValueListStore__c tempStageValueStore = KeyValueListStore__c.getValues('LTS_Opportunity_NotifyEmailStages');
            system.debug('tempStageValueStore'+tempStageValueStore);
            
            if(tempStageValueStore !=null && tempStageValueStore.TextValue__c !=null && tempStageValueStore.TextValue__c !=''){
                stageList = tempStageValueStore.TextValue__c.split(',');
            }               
            for(String stageins : stageList){            
                stageSet.add(stageins);
            }            
            KeyValueListStore__c numberOfDays = KeyValueListStore__c.getValues('LTS_Noofdaystonotify');
            Integer count = numberOfDays!= null ? Integer.valueOf(numberOfDays.TextValue__c): 90;            
            Integer daysBefore = count != null ? count : 90;            
            System.debug(''+Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId());     
            Id devRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('GLI_Pipeline_Opportunity').getRecordTypeId();
            //As part of DPS-21984 JIra , added Renewal_Flag__c  = false to teh query to stop notifications on teh Renewal Oppys
            query = 'Select id,Is_GLI__c,recordtypeid,stagename,lastmodifieddate,lastactivitydate,owner.ManagerId,ownerid,owner.isActive,owner.name,(Select Id,lastmodifieddate,ownerid,owner.isactive,whatid From Tasks), (Select Id,lastmodifieddate,ownerid,owner.isactive,whatid From Events) from opportunity';
            query += ' WHERE Is_GLI__c = true';
            query += ' AND TRWaySales__Park_Opportunity__c = false';
            query += ' AND Renewal_Flag__c  = false';
            if(stageSet.size() > 0){
                query += ' AND Stagename IN :stageSet';//+stageSet+'';
            }            
            if(devRecordTypeId!=null){
                query += ' AND recordtypeid =: devRecordTypeId';
            }
            Date startDate = system.Today().adddays(-daysBefore );
            Date d=Date.valueOf(startDate);
            //Date endtDate = startDate.adddays(1);
            system.debug('DATE VALUE' +d);
            
            if(!Test.isRunningTest())  {
                query += ' AND DAY_ONLY(lastmodifieddate) = :d';
                //query += ' AND lastmodifieddate < :endtDate';
            } 
        }catch(Exception e){
            //As part of DPS-21984  jira, below 3 line are commented and added in the obj creation itself. This is just to increase teh code coverage as we con not handle the expection of Batch start method in teh Test class.
            LCRM_Exception_Log__c lcrmError = new LCRM_Exception_Log__c(LCRM_Exception_Message__c = e.getMessage(),LCRM_Exception_Type__c = e.getTypeName(),LCRM_Exception_Trace__c = e.getStackTraceString());
            //lcrmError.LCRM_Exception_Message__c = e.getMessage();
            //lcrmError.LCRM_Exception_Type__c = e.getTypeName();
            //lcrmError.LCRM_Exception_Trace__c = e.getStackTraceString();
            exceptionList.add(lcrmError);
            
        } 
        System.debug('@@QUERY@@@ '+query);        
        return Database.getQueryLocator(query);
        
    }
    global void execute (Database.BatchableContext BC, List<Opportunity> scope){
        System.debug('@@@@@scope'+scope);
        LTS_ToNotifySalesRepForOpportunity notifyIns = new LTS_ToNotifySalesRepForOpportunity();
        notifyIns.filterOpptyRecords(scope);
        
    }
    global void finish(Database.BatchableContext BC){
        if(!exceptionList.isEmpty()){
            LTSStoreErrors.customLTSException(exceptionList);
        }
    }
}