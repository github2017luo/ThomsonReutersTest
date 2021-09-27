/********************************************************************** 
Name: LTS_ToNotifySalesRepForOpportunity
====================================================== 
Req: LTS 3273 [Sales & Marketing - Opportunity Notification] Opportunities that have not been updated in 90 days to automatically notify owning Sales Rep.
====================================================== 
Purpose: Notify Sales Rep with email
====================================================== 
History 
------- 
VERSION    AUTHOR                           DATE           DETAIL 
1.0        TCS Developer             05/01/2019     Initial Development  
***********************************************************************/

public without sharing class LTS_ToNotifySalesRepForOpportunity {
    Map<Id, User> userMap =new Map<Id, User>();
    List<LCRM_Exception_Log__c> exceptionList = new List<LCRM_Exception_Log__c>();//used to store exceptions
    public LTS_ToNotifySalesRepForOpportunity(){
        
        List<String> informaticaUsersList = new List<String>();
        Set<String> informaticaUserSet = new Set<String>();
        
        KeyValueListStore__c informaticaUsersValueStore = KeyValueListStore__c.getValues('LTS_InformaticaUsers');
        system.debug('informaticaUsersValueStore '+informaticaUsersValueStore );
        if(informaticaUsersValueStore !=null && informaticaUsersValueStore .TextValue__c !=null && informaticaUsersValueStore .TextValue__c !=''){
            informaticaUsersList = informaticaUsersValueStore .TextValue__c.split(',');
        }               
        for(String stageins : informaticaUsersList){            
            informaticaUserSet.add(stageins);
        }
        
        if(informaticaUserSet.size()>0){
            userMap = new Map<Id, User>([Select id FROM User Where Name in : informaticaUserSet]);
        }
    }
    
    //This method is used to filter the opportunity records for sending the email
    Public void filterOpptyRecords(List<Opportunity> batchOpptyList){
        
        Map<ID, List<Task>> OpptyTasks = new Map<ID, List<Task>>();
        Map<ID, List<Event>> OpptyEvents = new Map<ID, List<Event>>();
        
        List<Task> taskList = new List<Task>();
        List<Event> eventList = new List<Event>();
        
        Map<id,id> emailOpptyMap = new Map<id,id>();
        System.debug('batchOpptyList size'+batchOpptyList.size());
        System.debug('batchOpptyList list'+batchOpptyList);
    try{
            if(!batchOpptyList.isEmpty()){
                for(Opportunity oppRec : batchOpptyList){   
                    //Informatica GLI Integration,Test Informatica GLI Integration,Informatica User
                    boolean userCheck = checkInformaticaUser(oppRec.OwnerId);                    
                    if(!userCheck){
                        System.debug(''+oppRec.id+''+oppRec.OwnerId);
                        System.debug('**** OWNER NAME**** '+oppRec.owner.name);
                        System.debug('**** OWNER Id**** '+oppRec.Id);
                        if(oppRec.owner.isactive == true){
                            emailOpptyMap.put(oppRec.id,oppRec.OwnerId);
                        }
                        else if(oppRec.owner.ManagerId != null){
                            oppRec.ownerid = oppRec.owner.ManagerId;
                            emailOpptyMap.put(oppRec.id,oppRec.OwnerId);
                        }
                        if(!((oppRec.tasks).isEmpty())){
                            System.debug('Opportunity Tasks');                            
                            for(Task taskOpprec : oppRec.tasks){
                                taskList.add(taskOpprec);
                            }                          
                        }
                        if(!((oppRec.events).isEmpty())){
                            System.debug('Opportunity Events');                            
                            for(Event eventOpprec : oppRec.events){
                                eventList.add(eventOpprec);
                            }                            
                            
                        }                        
                    }
                }           
                
                
            }
            KeyValueListStore__c numberOfDays = KeyValueListStore__c.getValues('LTS_Noofdaystonotify');
            Integer count = numberOfDays!= null ? Integer.valueOf(numberOfDays.TextValue__c): 90;            
            Integer daysBefore = count != null ? count : 90;
            Integer taskeventDate = -daysBefore;
            System.debug('taskeventDate'+taskeventDate);
            //Task Logic
            if(taskList.size() > 0){
                for(Task taskRec : taskList){
                    if(taskRec.LastModifiedDate > Date.today().addDays(taskeventDate) && taskRec.owner.isactive == true){
                        system.debug(''+taskRec.WhatId+''+taskRec.OwnerId);
                        // emailOpptyMap.put(taskRec.WhatId,taskRec.OwnerId);
                        if(emailOpptyMap.containsKey(taskRec.WhatId))
                            emailOpptyMap.remove(taskRec.WhatId);
                    }
                    
                }
            }System.debug('emailOpptyMap***'+emailOpptyMap);
            //Event Logic
            if(eventList.size() > 0){
                for(Event eventRec : eventList){
                    if(eventRec.LastModifiedDate > Date.today().addDays(taskeventDate) && eventRec.Owner.isactive == true ){
                        system.debug(''+eventRec.WhatId+''+eventRec.OwnerId);
                        //emailOpptyMap.put(eventRec.WhatId,eventRec.OwnerId);
                        if(emailOpptyMap.containsKey(eventRec.WhatId))
                            emailOpptyMap.remove(eventRec.WhatId);
                    }
                    
                }
            }
            System.debug('**SIZE**'+emailOpptyMap.size());      
            if(emailOpptyMap.size() > 0){
                sendEmailtoOpptyOwner(emailOpptyMap,batchOpptyList);
                system.debug('Map Values' +emailOpptyMap);
            }
            
        }Catch(Exception e ){
            LCRM_Exception_Log__c lcrmError = new LCRM_Exception_Log__c(LCRM_Exception_Message__c = e.getMessage(),LCRM_Exception_Type__c = e.getTypeName(),LCRM_Exception_Trace__c = e.getStackTraceString());
            /*lcrmError.LCRM_Exception_Message__c = e.getMessage();
            lcrmError.LCRM_Exception_Type__c = e.getTypeName();lcrmError.LCRM_Exception_Trace__c = e.getStackTraceString();*/
            exceptionList.add(lcrmError);
        }
        if(exceptionList.size() > 0){
             LTSStoreErrors.customLTSException(exceptionList);
        }
        
    }
    
    /*Email Logic*/
    @TestVisible  private void sendEmailtoOpptyOwner(Map<Id,Id>OpptyEmailMap,List<Opportunity> OpptyList){       
        
        Map<Id,Id>whatAndWhoIdMap = new Map<Id,Id>(); 
        List<Messaging.SingleEmailMessage> mailsList = new List<Messaging.SingleEmailMessage>();
        EmailTemplate notifySalesRepUserTemp;
        KeyValueListStore__c templateName = KeyValueListStore__c.getValues('LTS_EmailToNotifyOpptyOwner');
        String ltsTemplateName = templateName.TextValue__c != null?templateName.TextValue__c: 'LTS_EmailToNotifyOpptyOwner';
        if(EmailTemplate.sObjectType.getDescribe().IsAccessible())
            notifySalesRepUserTemp = [SELECT Id, Name, TemplateType FROM EmailTemplate WHERE Name =: ltsTemplateName];
        
        for(opportunity opptyIns : OpptyList){
            
            if(OpptyEmailMap.containskey(opptyIns.Id)){
                
                
                whatAndWhoIdMap.put(OpptyEmailMap.get(opptyIns.Id),opptyIns.Id);        
            }
            
        }
        System.debug('Call ****LTS_SendCustomEmailUtilityClass****');
        LTS_SendCustomEmailUtilityClass utilityIns = new LTS_SendCustomEmailUtilityClass();
        utilityIns.sendSingleEmailMsg(whatAndWhoIdMap,notifySalesRepUserTemp.Id,System.label.LTS_EmailSenderDisplayName);
        //Messaging.sendEmail(mailsList);
        if(LTS_SendCustomEmailUtilityClass.successCheck){
            createTask(whatAndWhoIdMap);
        }
        
        
        
    }
    
    Public boolean checkInformaticaUser(id opptyOwnerId){
        
        
        if(userMap.containsKey(opptyOwnerId)){
            return true;
        }
        else{
            return false;
        }        
        
        
    }
    
    @TestVisible private void createTask(Map<Id,Id>ownerandOpptyIdMap){
        List<Task> tasksToInsertList = new List<Task>();
        List<LCRM_Exception_Log__c> excepObjList = new List<LCRM_Exception_Log__c>();
        
        //GLI_Record_Type
        //Id taskRecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('GLI Record Type').getRecordTypeId();
        Id taskRecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByDeveloperName().get('GLI_Record_Type').getRecordTypeId();
        if(ownerandOpptyIdMap.size() > 0 && taskRecordTypeId != null){
            for(Id ownId : ownerandOpptyIdMap.keyset()){
                Task taskIns = new Task();
                taskIns.WhatId = ownerandOpptyIdMap.get(ownId);
                taskIns.OwnerId = ownId;
                taskIns.Subject = 'Follow Up Email';
                taskIns.LCRM_Activity_Type__c = 'Email Outbound';
                taskIns.ActivityDate = System.Today();
                taskIns.Activity_Category__c = 'Follow Up';
                taskIns.Description   = System.label.LTS_TaskDescription;
                taskIns.Status__c = 'Pending';
                taskIns.RecordTypeId = taskRecordTypeId;
                tasksToInsertList.add(taskIns);
            }
            if(tasksToInsertList.size() > 0){
                
                Database.SaveResult[] srList = Database.insert(tasksToInsertList, false);
                
                // Iterate through each returned result
                for (Database.SaveResult sr : srList) {
                    if (sr.isSuccess()) {
                        // Operation was successful, so get the ID of the record that was processed
                        System.debug('Successfully inserted task. task ID: ' + sr.getId());
                    }
                    else {
                        // Operation failed, so get all errors                
                        for(Database.Error err : sr.getErrors()) {
                            
                            LCRM_Exception_Log__c testIns = new LCRM_Exception_Log__c(LCRM_Exception_Message__c = 'MESSAGE :: '+err.getMessage(),LCRM_Exception_Type__c = 'STATUS CODE :: '+err.getStatusCode(),LCRM_Exception_Trace__c = 'FIELDS AFFECTED :: '+err.getFields());
                            /*testIns.LCRM_Exception_Message__c = 'MESSAGE :: '+err.getMessage();
                            testIns.LCRM_Exception_Type__c = 'STATUS CODE :: '+err.getStatusCode();
                            testIns.LCRM_Exception_Trace__c = 'FIELDS AFFECTED :: '+err.getFields();*/
                            excepObjList.add(testIns);
                        }
                    }
                }
                if(excepObjList.size() > 0){
                    LTSStoreErrors.customLTSException(excepObjList);
                    
                }
            }
        }
        
        
        
    }
    
    
    
    
}