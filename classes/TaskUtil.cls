/**
* Contains methods for Task Trigger
* Creates the events on Account whenever new tasks are created on Training Event
* Updates the events on Account whenever new tasks are updated on Training Event
* Deletes the events on Account whenever new tasks are deleted on Training Event
*
* @author  Srikanth Kuruva
* @version  2012-04-06
*/
/**
* CHANGE HISTORY
* =============================================================================
* Date         Name                    Description
* 2012-06-15   Srikanth Kuruva     Updated the trigger to fix the issue-IM3547703
* 2012-08-02   Nandita Shet        Added methods UpdateNextCallDateOnOpp/
*                                   UpdateNextCallDateOnLead for
*                                  Next Call Date update on Leads and Opportunities
* 2013-02-22   Anshita Sharma      Updated 'copyTaskAfterInserted' method to avoid 
*                                  duplication of task on account.
* 2014-10-29   Shawn Gray          Removed the future for the updatenextcall date because of failor
*                                  in a glance call from a batch process
* 2015-06-18   Harika/Satyajit     User Story 33 pull the Task activity into Account and Contact
* 2017-11-06   Harika Kalidindi    CRM-11169 Added updatewhatId methods to replace what Id before Inserting tasks 
* 2018-01-10   Harika Kalidindi    CRM-10938 Added updateWhatIdinReminderTask  methods to replace what Id before Inserting tasks 
* 2018-04-17   Harika Kalidindi    CRM -12068 Bug Added code for defaulting the Activity Type to 'Email Outbound' when task is created after clicking on standard Send Email Button
* 2018-10-16   Jason Flippen       CRM-13127 Added processLeadActivityCountStageInserts method.
* =============================================================================
*/ 
public without sharing class TaskUtil
{
    /* public static void embargoedAccounts(List<Task> listInsertedTasks){
Map<Task, Id> insertedTaskMap = new Map<Task, Id>();
Map<Id, Account> relAccountMap;
for(Task t: listInsertedTasks){
String whatIDStr = String.valueOf(t.whatId);
if(whatIDStr.left(3) == '001'){
insertedTaskMap.put(t, t.whatId);
}
}
if(insertedTaskMap.size() > 0){
relAccountMap = new Map<Id, Account>([SELECT Id FROM Account WHERE Is_GLI__c = true AND Embargoed_Account__c = true AND Sanctioned_Status__c IN ('Pending', 'Sanctioned') AND Id IN : insertedTaskMap.values()]);
}
if(relAccountMap.size() > 0){
for(Task t: listInsertedTasks){
if(relAccountMap.keySet().contains(t.whatId)){
t.addError(Label.Embargoed_Account_Task_Error);
}
}
}
}*/
    public static void copyTaskAfterInserted(List<Task> listInsertedTasks)
    {
        //Start of code - added by saloni for Legal CRM project for November release
        boolean execute = true;
        
        for(Task t : listInsertedTasks)
        {
            if(LCRMGenericComponent.validateUserBU(t.LCRM_Sub_BU__c)){
                execute = false;
                break;
            }
        }
        
        if(execute){ 
            //End of code added by Saloni   
            List<Id> listRelatedId = new List<Id>();
            List<Id> listRelatedConId= new List<Id>();
            
            for(Task t : listInsertedTasks)
            {
                listRelatedId.add(t.WhatId);
                listRelatedConId.add(t.WhoId);
            }
            Map<Id, Training_Event__c> mapTrainingEvent = new Map<Id, Training_Event__c>();
            if(!listRelatedId.isEmpty())
            {
                mapTrainingEvent = new Map<Id, Training_Event__c>([select Id, Name from Training_Event__c where Id in :listRelatedId]);
            }
            List<Training_Event_Account__c> listTrainingEventAccount = new List<Training_Event_Account__c>();
            if(!listRelatedId.isEmpty())
            {
                if(Schema.sObjectType.Training_Event_Account__c.isAccessible()){
                listTrainingEventAccount = [select Training_Event__c, Account__c, Name from Training_Event_Account__c where Training_Event__c in :listRelatedId];
            }
                
            }
            Map<Id,Contact> mapContactAccnts = new Map<Id,Contact>();
            if(!listRelatedConId.isEmpty())
            {
                mapContactAccnts = new Map<Id, Contact>([Select Id,AccountId from Contact where id in:listRelatedConId]);
            }
            List<Task> listClonedTasks = new List<Task>();
            system.debug('SIZE@@@@ '+listTrainingEventAccount.size());
            system.debug('SIZE@@@@ '+listInsertedTasks.size());
            if(!listTrainingEventAccount.isEmpty())
            {
                for(Task t : listInsertedTasks)
                {
                    for(Training_Event_Account__c tTrainingEventAccountSingle : listTrainingEventAccount)
                    {
                        if(tTrainingEventAccountSingle.Training_Event__c == t.WhatId)
                        {
                            if(!mapContactAccnts.isEmpty())
                            { 
                                if(tTrainingEventAccountSingle.Account__c != mapContactAccnts.get(t.WhoId).AccountId)
                                {
                                    Task[] ClonedTask = (new Task[]{t}).deepClone(false);
                                    ClonedTask[0].WhoId = null;
                                    ClonedTask[0].Training_Event_Id__c = mapTrainingEvent.get(t.WhatId).Id;
                                    ClonedTask[0].Training_Event_Name__c = mapTrainingEvent.get(t.WhatId).Name;
                                    ClonedTask[0].WhatId = tTrainingEventAccountSingle.Account__c;
                                    ClonedTask[0].ParentActivityId__c = t.Id;
                                    ClonedTask[0].IsReminderSet = false;
                                    listClonedTasks.add(ClonedTask[0]);
                                } 
                            }  
                            else
                            {
                                Task[] ClonedTask = (new Task[]{t}).deepClone(false);
                                ClonedTask[0].WhoId = null;
                                ClonedTask[0].Training_Event_Id__c = mapTrainingEvent.get(t.WhatId).Id;
                                ClonedTask[0].Training_Event_Name__c = mapTrainingEvent.get(t.WhatId).Name;
                                ClonedTask[0].WhatId = tTrainingEventAccountSingle.Account__c;
                                ClonedTask[0].ParentActivityId__c = t.Id;
                                ClonedTask[0].IsReminderSet = false;
                                listClonedTasks.add(ClonedTask[0]);      
                            } 
                        }
                    }
                }
            }
            System.debug('@@@@@@'+listClonedTasks.size()+'----'+listClonedTasks);
            if(!listClonedTasks.isEmpty())
            {
                if (Schema.sObjectType.Task.isCreateable()) {
                insert listClonedTasks;
            }
        }
    }
    }
    
    
    public static void copyTaskAfterUpdated(map<Id,Task> mapUpdatedTasks)
    {
        List<Id> listRelatedId = new List<Id>();
        for(Task t : mapUpdatedTasks.values())
        {
            listRelatedId.add(t.WhatId);
        }
        List<Training_Event_Account__c> listTrainingEventAccount = new List<Training_Event_Account__c>();
        if(!listRelatedId.isEmpty())
        {
            listTrainingEventAccount = [select Training_Event__c, Account__c from Training_Event_Account__c where Training_Event__c in :listRelatedId];
        }
        List<Task> listUpdateTasks = new List<Task>();
        if(!listTrainingEventAccount.isEmpty())
        {
            List<Id> AccountIds = new List<Id>();
            List<String> ParentActivityIds = new List<String>();
            for(Training_Event_Account__c tTrainingEventAccountSingle : listTrainingEventAccount)
            {
                AccountIds.add(tTrainingEventAccountSingle.Account__c);
            }
            for(Task t : mapUpdatedTasks.values())
            {
                ParentActivityIds.add((String)t.Id);
            }
            for(Task t : [select Id, Owner_Group__c, Type, Description, ActivityDate, Status, Subject, Priority, Tracking_Code__c, ReminderDateTime, IsReminderSet, ParentActivityId__c from Task where WhatId in : AccountIds and ParentActivityId__c in : ParentActivityIds])
            {
                Task UpdatedTask = mapUpdatedTasks.get((Id)t.ParentActivityId__c);
                if(t.Owner_Group__c != UpdatedTask.Owner_Group__c || t.Type != UpdatedTask.Type ||
                   t.Description != UpdatedTask.Description || t.ActivityDate != UpdatedTask.ActivityDate ||
                   t.Status != UpdatedTask.Status || t.Subject != UpdatedTask.Subject ||
                   t.Priority != UpdatedTask.Priority || t.Tracking_Code__c != UpdatedTask.Tracking_Code__c ||
                   t.ReminderDateTime != UpdatedTask.ReminderDateTime )
                {
                    t.Owner_Group__c = UpdatedTask.Owner_Group__c;
                    t.Type = UpdatedTask.Type;
                    t.Description = UpdatedTask.Description;
                    t.ActivityDate = UpdatedTask.ActivityDate;
                    t.Status = UpdatedTask.Status;
                    t.Subject = UpdatedTask.Subject;
                    t.Priority = UpdatedTask.Priority;
                    t.Tracking_Code__c = UpdatedTask.Tracking_Code__c;
                    t.ReminderDateTime = UpdatedTask.ReminderDateTime;
                    listUpdateTasks.add(t);
                }
            }
            if(!listUpdateTasks.isEmpty())
            {
                if (Schema.sObjectType.Task.isUpdateable()) {
                update listUpdateTasks;
            }
                
            }
        } 
    }
    
    public static void deleteRelatedTasks(List<Task> listDeletedTasks)
    {
        List<String> ParentActivityIds = new List<String>();
        for(Task t : listDeletedTasks)
        {
            ParentActivityIds.add((String)t.Id);
        }
        List<Task> listDeleteTasks = [select Id, Owner_Group__c, Type, Description, ActivityDate, Status, Subject, Priority, Tracking_Code__c, ReminderDateTime, IsReminderSet, ParentActivityId__c from Task where ParentActivityId__c != null and ParentActivityId__c in : ParentActivityIds];
        if(!listDeleteTasks.isEmpty()){
            
            if(Schema.sObjectType.Task.isDeletable()){
            delete listDeleteTasks;
        }
            
        }
    }
    
    
    
    public static void updateTaskOwnerGroup(List<Task> listTask){
        Map<Task,Id> mapTaskOwnerId = new Map<Task,Id>();
        Map<Task,String> mapTaskMarketSegment = new Map<Task,String>();
        
        
        for(Task otask : listTask){
            if(!mapTaskOwnerId.containsKey(otask)){
                mapTaskOwnerId.put(otask,otask.ownerId);
            }
        }
        
        Map<Id,User> mapUser =new Map<Id,User>([Select Sales_Force_Description__c,Market_Segment_Description__c from User where ID IN : mapTaskOwnerId.values()]);
        
        for(Task oTask : mapTaskOwnerId.KeySet()){
            if(!mapTaskMarketSegment.containskey(oTask)){
                if(mapUser.get(oTask.OwnerId).Market_Segment_Description__c!=null && mapUser.get(oTask.OwnerId).Market_Segment_Description__c!=''
                   && mapUser.get(oTask.OwnerId).Sales_Force_Description__c!=null
                   && mapUser.get(oTask.OwnerId).Sales_Force_Description__c!='')
                {
                    String MarketSegmentName = '';
                    MarketSegmentName = mapUser.get(oTask.OwnerId).Market_Segment_Description__c.trim()+'-'+mapUser.get(oTask.OwnerId).Sales_Force_Description__c.trim();
                    if(MarketSegmentName.length()<= Integer.valueof(label.LCRM_MarketSegmentName)){
                        mapTaskMarketSegment.put(oTask,MarketSegmentName);
                    }
                }else{
                    mapTaskMarketSegment.put(oTask,'');
                }
            }
        }
        
        for(Task oTask : mapTaskMarketSegment.keySet()){
            
            if(mapTaskMarketSegment.containskey(oTask) && OwnerGroup__c.getinstance(mapTaskMarketSegment.get(oTask))!=null){
                OwnerGroup__c oOwnerGroup = OwnerGroup__c.getinstance(mapTaskMarketSegment.get(oTask));
                oTask.Owner_Group__c = oOwnerGroup.Channel__c;
                
            }
            else{
                oTask.Owner_Group__c = 'Other';
            }
            
        }
        
    }
    
    
    @future
    public static void UpdateNextCallDate_Future(List<ID> listInsertedActivityIds,String Objectname){
        UpdateNextCallDate(listInsertedActivityIds,Objectname);
    }
    
    
    /* @future */
    public static void UpdateNextCallDate(List<ID> listInsertedActivityIds,String Objectname){
        
        //Start of code - added by saloni for Legal CRM project for November release
        boolean execute = true;
        
        List<Task> insertedTasks = new List<Task>();
        if(Schema.sObjectType.Task.isAccessible()){
        insertedTasks = [SELECT Id,LCRM_Sub_BU__c FROM Task WHERE Id in :listInsertedActivityIds];
        }
        
        
        List<Event> insertedEvents = new List<Event>();
        if(Schema.sObjectType.Event.isAccessible()){
            insertedEvents = [SELECT Id,LCRM_Sub_BU__c FROM Event WHERE Id in :listInsertedActivityIds];
        }
        
        
        if(!insertedTasks.isEmpty())
        {
            for(Task t : insertedTasks)
            {
                if(t.LCRM_Sub_BU__c == 'UKI')
                {
                    execute = false;
                    break;
                }
            }
        }
        //Added as part of CRM-17952 (INC1299396)
        if(!insertedEvents.isEmpty())
        {
            for(Event objeve : insertedEvents)
            {
                if(objeve.LCRM_Sub_BU__c == 'UKI')
                {
                    execute = false;
                    break;
                }
                
            }
        }
        
        if(execute){  
            //End of code added by Saloni  
            List<Id> listRelatedOptyId = new List<Id>();
            List<Id> listRelatedLeadId = new List<Id>();
            List<Task> listTasks = new List<Task>();
            List<Event> listEvents = new List<Event>();
            List<Opportunity> listOpportunity = new List<Opportunity>();
            List<Opportunity> listOpportunityToUpdate = new List<Opportunity>();
            List<Lead> listLeads = new List<Lead>();
            List<Lead> listLeadsToUpdate = new List<Lead>();
            Datetime oDateNow = System.now();
            Schema.DescribeSobjectResult  sdr_opp = Schema.SObjectType.Opportunity;
            Schema.DescribeSobjectResult  sdr_lead = Schema.SObjectType.Lead;
            
            String sTaskQuery = 'Select Id,WhatId,WhoId,ActivityDate from Task where Status IN (\'In Progress\',\'Pending\') ';
            String sEventQuery = 'Select Id,WhatId,WhoId,ActivityDate from Event where ActivityDatetime > : oDateNow ';
            
            if(listInsertedActivityIds!=null && !listInsertedActivityIds.isEmpty()) {
                if(Objectname== 'Task'){
                    List<Task> taskList = [Select Id,WhatId,WhoId from Task where Id IN : listInsertedActivityIds];
                    for(Task otask : taskList)
                    {
                        if(!AppUtil.IsEmpty(otask.WhatId) && sdr_opp.keyPrefix == String.valueOf(otask.WhatId).left(3)){
                            listRelatedOptyId.add(otask.WhatId);
                        }
                        if(!AppUtil.IsEmpty(otask.WhoId) && sdr_lead.keyPrefix == String.valueOf(otask.WhoId).left(3)){
                            listRelatedLeadId.add(otask.WhoId);
                        }
                    }
                    
                }else if(Objectname== 'Event'){
                    
                    for(Event oEvent : [Select Id,WhatId,WhoId from Event where Id IN : listInsertedActivityIds])
                    {
                        if(!AppUtil.IsEmpty(oEvent.WhatId) && sdr_opp.keyPrefix == String.valueOf(oEvent.WhatId).left(3)){
                            listRelatedOptyId.add(oEvent.WhatId);
                        }
                        if(!AppUtil.IsEmpty(oEvent.WhoId) && sdr_lead.keyPrefix == String.valueOf(oEvent.WhoId).left(3)){
                            listRelatedLeadId.add(oEvent.WhoId);
                        }
                    }
                }
            }
            
            if(!listRelatedOptyId.isEmpty())
            {
                
                if(Schema.sObjectType.Opportunity.isAccessible()){
                listOpportunity  = [Select Id ,Name ,Next_Call_Date__c from Opportunity where Id in :listRelatedOptyId and StageName Not IN ('Contract Signed','Order Complete','Closed Lost','95%','100%')];
                }                
                if(!listOpportunity.isEmpty()){
                    sTaskQuery += 'and (WhatId IN : listRelatedOptyId ';
                    sEventQuery += 'and (WhatId IN : listRelatedOptyId ';
                }
            }
            
            if(!listRelatedLeadId.isEmpty()){
                if(Schema.sObjectType.Lead.isAccessible()){
                listLeads  = [Select Id ,Name ,Next_Call_Date__c from Lead where Id in :listRelatedLeadId];
                }
                
                if(!listLeads.isEmpty()){
                    if(!listOpportunity.isEmpty()){
                        sTaskQuery += ' or WhoId IN : listRelatedLeadId ';
                        sEventQuery += 'or WhoId IN : listRelatedLeadId ';
                    }else{
                        sTaskQuery += 'and (WhoId IN : listRelatedLeadId ';
                        sEventQuery += 'and (WhoId IN : listRelatedLeadId ';
                        
                    }
                }
                // sTaskQuery += ') ';
                // sEventQuery += ') ';
            }
            
            sTaskQuery += ') ';
            sEventQuery += ') ';
            
            
            System.debug(sTaskQuery + '******'+sEventQuery);
            if(!listOpportunity.isEmpty() || !listLeads.isEmpty()){
                listTasks = Database.query(sTaskQuery);
                listEvents = Database.query(sEventQuery);
            }
            
            
            
            
            Map<Id,List<Date>> mapOpportunityDueDate =  new Map<Id,List<Date>>();
            Map<Id,Date> mapOpportunityNextCallDate =  new Map<Id,Date>();
            Map<Id,List<Date>> mapLeadDueDate =  new Map<Id,List<Date>>();
            Map<Id,Date> mapLeadNextCallDate =  new Map<Id,Date>();
            
            for(Task otask : listTasks){
                if(otask.ActivityDate!=null){
                    if(!AppUtil.IsEmpty(otask.WhatId)){
                        if(mapOpportunityDueDate.containsKey(otask.WhatID)){
                            mapOpportunityDueDate.get(otask.WhatID).add(otask.ActivityDate);
                        }else{
                            List<Date> ListDueDate = new List<Date>();
                            ListDueDate.add(otask.ActivityDate);
                            mapOpportunityDueDate.put(otask.WhatID,ListDueDate);
                            
                        }
                    }
                    
                    if(!AppUtil.IsEmpty(otask.WhoId)){
                        
                        if(mapLeadDueDate.containsKey(otask.WhoId)){
                            mapLeadDueDate.get(otask.WhoId).add(otask.ActivityDate);
                        }else{
                            List<Date> ListDueDate = new List<Date>();
                            ListDueDate.add(otask.ActivityDate);
                            mapLeadDueDate.put(otask.WhoId,ListDueDate);
                            
                        }
                    }
                }
            }
            
            
            for(Event oEvent : listEvents){
                if(oEvent.ActivityDate!=null){
                    if(!AppUtil.IsEmpty(oEvent.WhatId)){
                        if(mapOpportunityDueDate.containsKey(oEvent.WhatID)){
                            mapOpportunityDueDate.get(oEvent.WhatID).add(oEvent.ActivityDate);
                        }else{
                            List<Date> ListDueDate = new List<Date>();
                            ListDueDate.add(oEvent.ActivityDate);
                            mapOpportunityDueDate.put(oEvent.WhatID,ListDueDate);
                            
                        }
                    } 
                    
                    if(!AppUtil.IsEmpty(oEvent.WhoId)){
                        if(mapLeadDueDate.containsKey(oEvent.WhoId)){
                            mapLeadDueDate.get(oEvent.WhoId).add(oEvent.ActivityDate);
                        }else{
                            List<Date> ListDueDate = new List<Date>();
                            ListDueDate.add(oEvent.ActivityDate);
                            mapLeadDueDate.put(oEvent.WhoId,ListDueDate);
                            
                        }
                    }
                }
            }
            
            for(Id OppId : mapOpportunityDueDate.Keyset()){
                List<Date> duedates = mapOpportunityDueDate.get(OppId);
                duedates.sort();
                mapOpportunityNextCallDate.put(OppId,duedates[0]);
            }
            
            // added condition to check the values are changed or not
            for(Opportunity oOpportunity : listOpportunity){
                // system.debug('Opp Next Call Date..'+oOpportunity.Next_Call_Date__c);
                // system.debug('map next call date..'+mapOpportunityNextCallDate.get(oOpportunity.Id));
                if(mapOpportunityNextCallDate.containsKey(oOpportunity.Id))
                {
                    if(oOpportunity.Next_Call_Date__c != mapOpportunityNextCallDate.get(oOpportunity.Id))
                    { 
                        oOpportunity.Next_Call_Date__c =  mapOpportunityNextCallDate.get(oOpportunity.Id);
                        listOpportunityToUpdate.add(oOpportunity); 
                    }                      
                }
                else
                {
                    oOpportunity.Next_Call_Date__c =  null;
                    listOpportunityToUpdate.add(oOpportunity); 
                }
            }
            //added if condion to check the size
            if(!listOpportunityToUpdate.Isempty()) {
                
                if(Schema.sObjectType.Opportunity.isUpdateable()) {
                 update listOpportunityToUpdate;
                }
                }
            
            for(Id LeadId : mapLeadDueDate.Keyset()){
                List<Date> duedates = mapLeadDueDate.get(LeadId);
                duedates.sort();
                mapLeadNextCallDate.put(LeadId,duedates[0]);
            }
            
            for(Lead oLead : listLeads){
                oLead.Next_Call_Date__c = mapLeadNextCallDate.containsKey(oLead.Id)?mapLeadNextCallDate.get(oLead.Id):null;
                listLeadsToUpdate.add(oLead);  
                
            }
            if(Schema.sObjectType.Lead.isUpdateable()){
            update listLeadsToUpdate;
        }
            
        }
    }
    
    @future
    public static void UpdateNextCallDateOnDelete(List<ID> listActivityIds,List<ID> listRelatedOptyId ,List<Id> listRelatedLeadId,String Objectname){
        
        
        List<Task> listTasks = new List<Task>();
        List<Event> listEvents = new List<Event>();
        List<Opportunity> listOpportunity = new List<Opportunity>();
        List<Opportunity> listOpportunityToUpdate = new List<Opportunity>();
        List<Lead> listLeads = new List<Lead>();
        List<Lead> listLeadsToUpdate = new List<Lead>();
        Datetime oDateNow = System.now();
        String sTaskQuery = 'Select Id,WhatId,WhoId,ActivityDate from Task where Status IN (\'In Progress\',\'Pending\') ';
        String sEventQuery = 'Select Id,WhatId,WhoId,ActivityDate from Event where ActivityDatetime > : oDateNow ';
        
        
        
        if(!listRelatedOptyId.isEmpty())
        {
            listOpportunity  = [Select Id ,Name ,Next_Call_Date__c from Opportunity where Id in :listRelatedOptyId and StageName Not IN ('Contract Signed','Order Complete','Closed Lost','95%','100%')];
            if(!listOpportunity.isEmpty()){
                sTaskQuery += 'and(WhatId IN : listRelatedOptyId ';
                sEventQuery += 'and (WhatId IN : listRelatedOptyId ';
            }
        }
        
        if(!listRelatedLeadId.isEmpty()){
            listLeads  = [Select Id ,Name ,Next_Call_Date__c from Lead where Id in :listRelatedLeadId];
            if(!listLeads.isEmpty()){
                if(!listOpportunity.isEmpty()){
                    sTaskQuery += ' or WhoId IN : listRelatedLeadId ';
                    sEventQuery += 'or WhoId IN : listRelatedLeadId ';
                }else{
                    sTaskQuery += 'and (WhoId IN : listRelatedLeadId ';
                    sEventQuery += 'and (WhoId IN : listRelatedLeadId ';
                    
                }
            }
            
        }
        sTaskQuery += ') ';
        sEventQuery += ') ';
        
        /*   
if(!listActivityIds.isEmpty()){
if(Objectname == 'Task'){
sTaskQuery += ' and Id NOT IN : listActivityIds';
}
else if(Objectname == 'Event'){
sEventQuery += 'and Id NOT IN : listActivityIds';
}  
sTaskQuery += ') ';
sEventQuery += ') ';
}

*/
        
        System.debug(sTaskQuery + '******'+sEventQuery);
        
        if(!listOpportunity.isEmpty() || !listLeads.isEmpty()){
            listTasks = Database.query(sTaskQuery);
            listEvents = Database.query(sEventQuery);
            
        }
        
        
        Map<Id,List<Date>> mapOpportunityDueDate =  new Map<Id,List<Date>>();
        Map<Id,Date> mapOpportunityNextCallDate =  new Map<Id,Date>();
        Map<Id,List<Date>> mapLeadDueDate =  new Map<Id,List<Date>>();
        Map<Id,Date> mapLeadNextCallDate =  new Map<Id,Date>();
        
        for(Task otask : listTasks){
            if(otask.ActivityDate!=null){
                if(!AppUtil.IsEmpty(otask.WhatId)){
                    if(mapOpportunityDueDate.containsKey(otask.WhatID)){
                        mapOpportunityDueDate.get(otask.WhatID).add(otask.ActivityDate);
                    }else{
                        List<Date> ListDueDate = new List<Date>();
                        ListDueDate.add(otask.ActivityDate);
                        mapOpportunityDueDate.put(otask.WhatID,ListDueDate);
                        
                    }
                }
                
                if(!AppUtil.IsEmpty(otask.WhoId)){
                    
                    if(mapLeadDueDate.containsKey(otask.WhoId)){
                        mapLeadDueDate.get(otask.WhoId).add(otask.ActivityDate);
                    }else{
                        List<Date> ListDueDate = new List<Date>();
                        ListDueDate.add(otask.ActivityDate);
                        mapLeadDueDate.put(otask.WhoId,ListDueDate);
                        
                    }
                }
            }
        }
        
        
        for(Event oEvent : listEvents){
            if(oEvent.ActivityDate!=null){
                if(!AppUtil.IsEmpty(oEvent.WhatId)){
                    if(mapOpportunityDueDate.containsKey(oEvent.WhatID)){
                        mapOpportunityDueDate.get(oEvent.WhatID).add(oEvent.ActivityDate);
                    }else{
                        List<Date> ListDueDate = new List<Date>();
                        ListDueDate.add(oEvent.ActivityDate);
                        mapOpportunityDueDate.put(oEvent.WhatID,ListDueDate);
                        
                    }
                } 
                
                if(!AppUtil.IsEmpty(oEvent.WhoId)){
                    if(mapLeadDueDate.containsKey(oEvent.WhoId)){
                        mapLeadDueDate.get(oEvent.WhoId).add(oEvent.ActivityDate);
                    }else{
                        List<Date> ListDueDate = new List<Date>();
                        ListDueDate.add(oEvent.ActivityDate);
                        mapLeadDueDate.put(oEvent.WhoId,ListDueDate);
                        
                    }
                }
            }
        }
        
        for(Id OppId : mapOpportunityDueDate.Keyset()){
            List<Date> duedates = mapOpportunityDueDate.get(OppId);
            duedates.sort();
            mapOpportunityNextCallDate.put(OppId,duedates[0]);
        }
        
        //Added condition to prevent updating the Same value
        for(Opportunity oOpportunity : listOpportunity){
            
            if(mapOpportunityNextCallDate.containsKey(oOpportunity.Id))
            { 
                if(oOpportunity.Next_Call_Date__c !=  mapOpportunityNextCallDate.get(oOpportunity.Id))
                {
                    oOpportunity.Next_Call_Date__c = mapOpportunityNextCallDate.get(oOpportunity.Id);
                    listOpportunityToUpdate.add(oOpportunity); 
                } 
            }
            else{
                oOpportunity.Next_Call_Date__c = null ;
                listOpportunityToUpdate.add(oOpportunity);
                
            }
            
        }
        
        //Added condition to prevent updating the Same value
        if(!listOpportunityToUpdate.isEmpty() && listOpportunityToUpdate.size()>0)
        {
            if (Schema.sObjectType.Opportunity.isUpdateable()) {
            update listOpportunityToUpdate;
            }
            }
        
        for(Id LeadId : mapLeadDueDate.Keyset()){
            List<Date> duedates = mapLeadDueDate.get(LeadId);
            duedates.sort();
            mapLeadNextCallDate.put(LeadId,duedates[0]);
        }
        
        for(Lead oLead : listLeads){
            oLead.Next_Call_Date__c = mapLeadNextCallDate.containsKey(oLead.Id)?mapLeadNextCallDate.get(oLead.Id):null;
            listLeadsToUpdate.add(oLead);  
            
        }
        update listLeadsToUpdate;
    }
    //added for JIRA US #33
    /* public static void pullTasksToAccountLeadActivities(List<Task> newTaskList,map<id,Task> newMap,map<id,task> oldMap,boolean isAfter,boolean isInsert,boolean isUpdate,boolean isDelete){

if(isAfter){
List<Lead> leadsForTasks= new List<Lead>();
Map<Id,id> taskLeadMap=new Map<Id,id> ();
Map<Id,id> leadAccountMap=new Map<Id,id> ();      
if(isInsert){
List<AccountLeadActivity__c> alcListInsert=new List<AccountLeadActivity__c>();

for(Task t:newTaskList){
taskLeadMap.put(t.id,t.whoId);
}
leadsForTasks = [SELECT Account__c,id from LEAD WHERE id IN:taskLeadMap.Values()];

for(lead l: leadsForTasks){
leadAccountMap.put(l.id,l.Account__c);
}
for(task t:newTaskList){

//if(t.whoId != null && t.whoId.getSobjectType() == Schema.Lead.sObjectType){
if(t.whoId.getSobjectType() == Schema.Lead.sObjectType){
AccountLeadActivity__c acctLeadActivity=new AccountLeadActivity__c();
acctLeadActivity.Call_Type__c = t.CallType;
acctLeadActivity.due_date__c= t.ActivityDate;
acctLeadActivity.Status__c= t.Status;
system.debug('*****t.whatid'+t.whatid);
system.debug('*****acctLeadActivity.Related_To_Account__c '+acctLeadActivity.Related_To_Account__c);                   
acctLeadActivity.Related_To_Account__c = leadAccountMap.get(t.whoId);                   
acctLeadActivity.Subject__c = t.Subject;
acctLeadActivity.Lead__c= t.whoId;
acctLeadActivity.TaskId__c= t.id;
alcListInsert.add(acctLeadActivity);  
}
}
system.debug('****alcListInsert' + alcListInsert);
if(alcListInsert != null && alcListInsert.size()>0)
insert alcListInsert;

}
if(isUpdate){
system.debug('****Inside the Update operation********' ); 
Map<string,AccountLeadActivity__c> TaskAcctLeadActMap= new Map<string,AccountLeadActivity__c>();
List<AccountLeadActivity__c>  alcListUpdate = new List<AccountLeadActivity__c>();
List<AccountLeadActivity__c> acctLeadActivitiesForUpdate=
[SELECT Call_Type__c,due_date__c,Status__c,Related_To_Account__c,Subject__c,Lead__c,TaskId__c FROM AccountLeadActivity__c
WHERE TaskId__c IN:newMap.keyset()];
system.debug('****acctLeadActivitiesForUpdate:: ' + acctLeadActivitiesForUpdate);

for(AccountLeadActivity__c ala : acctLeadActivitiesForUpdate){
//if(newMap.get(ala.TaskId__c).whoId != null && newMap.get(ala.TaskId__c).whoId.getSobjectType() == Schema.Lead.sObjectType){                  
system.debug('****newMap1:: ' + newMap.get(ala.TaskId__c).CallType);
ala.Call_Type__c = newMap.get(ala.TaskId__c).CallType;
system.debug('****newMap1:: ' + newMap.get(ala.TaskId__c).ActivityDate);
ala.due_date__c= newMap.get(ala.TaskId__c).ActivityDate;
system.debug('****newMap1:: ' + newMap.get(ala.TaskId__c).Subject);
ala.Subject__c = newMap.get(ala.TaskId__c).Subject;
system.debug('****newMap1:: ' + newMap.get(ala.TaskId__c).Status);
ala.Status__c = newMap.get(ala.Status__c).Status;
system.debug('****alcListUpdate:: ' + alcListUpdate);
system.debug('****ala:: ' + ala );                              
alcListUpdate.add(ala);  
// }   
}

for(AccountLeadActivity__c ala: acctLeadActivitiesForUpdate){
TaskAcctLeadActMap.put(ala.TaskId__c,ala);

}                

if(alcListUpdate!= null && alcListUpdate.size() >0)
Update alcListUpdate;
}
}  

}*/
    
    public static void pullTasksToAccountContactLeadActivities(List<Task> newTaskList,map<id,Task> newMap,map<id,task> oldMap,boolean isAfter,boolean isInsert,boolean isUpdate,boolean isDelete){
        
        if(isAfter){ 
            
            List<Lead> leadsForTasks= new List<Lead>();
            Map<Id,id> taskLeadMap=new Map<Id,id> ();
            Map<Id,id> leadAccountMap=new Map<Id,id> (); 
            Map<Id,id> leadContactMap=new Map<Id,id> ();            
            if(isInsert){
                
                List<AccountLeadActivity__c> alcListInsert=new List<AccountLeadActivity__c>();
                List<ContactLeadActivity__c> clcListInsert=new List<ContactLeadActivity__c>();
                
                for(Task t:newTaskList){
                    taskLeadMap.put(t.id,t.whoId);
                    
                }
                if(Schema.sObjectType.LEAD.isAccessible()){
                leadsForTasks = [SELECT Account__c,Contact__c,id from LEAD WHERE id IN:taskLeadMap.Values()];
                }
                
                system.debug('****Investigating' + taskLeadMap +' ' +leadsForTasks);
                for(lead l: leadsForTasks){
                    leadAccountMap.put(l.id,l.Account__c);
                    leadContactMap.put(l.id,l.Contact__c);
                }
                system.debug('****leadAccountMap' +leadAccountMap);
                for(task t:newTaskList){
                    if(t.whoId!= null && t.whoId.getSobjectType() == Schema.Lead.sObjectType){
                        AccountLeadActivity__c acctLeadActivity=new AccountLeadActivity__c();
                        acctLeadActivity.Call_Type__c = t.CallType;
                        acctLeadActivity.due_date__c= t.ActivityDate;
                        acctLeadActivity.Status__c= t.Status;
                        system.debug('*****t.whatid'+t.whatid);
                        system.debug('*****acctLeadActivity.Related_To_Account__c '+acctLeadActivity.Related_To_Account__c);                    
                        acctLeadActivity.Related_To_Account__c = leadAccountMap.get(t.whoId);                    
                        acctLeadActivity.Subject__c = t.Subject;
                        acctLeadActivity.Lead__c= t.whoId;
                        acctLeadActivity.TaskId__c= t.id;
                        acctLeadActivity.Comments__c= t.description;
                        acctLeadActivity.type__c= t.type;
                        acctLeadActivity.Activity_owner__c= t.ownerId;
                        acctLeadActivity.owner_group__c= t.owner_group__c;
                        system.debug(acctLeadActivity);
                        alcListInsert.add(acctLeadActivity); 
                        
                        ContactLeadActivity__c conLeadActivity = new ContactLeadActivity__c();
                        conLeadActivity.Call_Type__c = t.CallType;
                        conLeadActivity.due_date__c= t.ActivityDate;
                        conLeadActivity.Status__c= t.Status;
                        system.debug('*****t.whatid::'+t.whatid);
                        //system.debug('*****conLeadActivity.Related_To_Contact__c:: '+ conLeadActivity.Related_To_Contact__c);                    
                        conLeadActivity.Related_To_Contact__c = leadContactMap.get(t.whoId);                    
                        conLeadActivity.Subject__c = t.Subject;
                        conLeadActivity.Lead__c= t.whoId;
                        conLeadActivity.TaskId__c= t.id;
                        conLeadActivity.Comments__c= t.description;
                        conLeadActivity.Type__c= t.type;
                        conLeadActivity.Activity_Owner__c= t.ownerId;
                        conLeadActivity.owner_group__c= t.owner_group__c;
                        system.debug('*****conLeadActivity:: '+ conLeadActivity);
                        clcListInsert.add(conLeadActivity);   
                        
                    }
                }
                system.debug('****alcListInsert' + alcListInsert);
                if(alcListInsert != null && alcListInsert.size()>0){
                    try{
                        if(Schema.sObjectType.AccountLeadActivity__c.isCreateable()){
                        insert alcListInsert;
                    }
                       
                    }
                    catch(Exception ex){                        
                        system.debug('***Lead Account Insert Exception:: ' + ex.getMessage() + ex.getLineNumber());
                    }
                    
                }
                if(clcListInsert != null && clcListInsert.size()>0){
                    try{
                        if(Schema.sObjectType.ContactLeadActivity__c.isCreateable()){
                        insert clcListInsert;
                    }
                    }
                    catch(Exception ex){                        
                        system.debug('***Lead Contact Insert Exception ' + ex.getMessage() + ex.getLineNumber());
                    }
                }
                
            }
            if(isUpdate){
                system.debug('*****in update');
                Map<string,AccountLeadActivity__c> TaskAcctLeadActMap= new Map<string,AccountLeadActivity__c>();
                List<AccountLeadActivity__c>  alcListUpdate = new List<AccountLeadActivity__c>();
                List<AccountLeadActivity__c> acctLeadActivitiesForUpdate= new List<AccountLeadActivity__c>();
                
                if(Schema.sObjectType.AccountLeadActivity__c.isAccessible()){
                     acctLeadActivitiesForUpdate = [SELECT Call_Type__c,due_date__c,Status__c,Related_To_Account__c,Subject__c,Lead__c,TaskId__c FROM AccountLeadActivity__c 
                     WHERE TaskId__c IN:newMap.keyset()];
                }

                
                for(AccountLeadActivity__c ala : acctLeadActivitiesForUpdate){
                    //if(newMap.get(ala.TaskId__c).whoId.getSobjectType() == Schema.Lead.sObjectType){                   
                    ala.Call_Type__c = newMap.get(ala.TaskId__c).CallType;
                    ala.due_date__c= newMap.get(ala.TaskId__c).ActivityDate; 
                    ala.Subject__c = newMap.get(ala.TaskId__c).Subject; 
                    ala.Status__c= newMap.get(ala.TaskId__c).Status;
                    ala.Comments__c= newMap.get(ala.TaskId__c).Description; 
                    ala.Type__c= newMap.get(ala.TaskId__c).Type;
                    //ala.Related_To_Account__c = leadAccountMap.get(newMap.get(ala.TaskId__c).whoId); 
                    //ala.Lead__c= newMap.get(ala.TaskId__c).whoId;                        
                    ala.Activity_owner__c= newMap.get(ala.TaskId__c).ownerId;
                    ala.owner_group__c= newMap.get(ala.TaskId__c).owner_group__c; 
                    alcListUpdate.add(ala);   
                    //}    
                }
                
                for(AccountLeadActivity__c ala: acctLeadActivitiesForUpdate){
                    TaskAcctLeadActMap.put(ala.TaskId__c,ala);
                    
                }                 
                
                if(alcListUpdate!= null && alcListUpdate.size() >0){}
                try{
                    if(Schema.sObjectType.AccountLeadActivity__c.isUpdateable()){
                    Update alcListUpdate;
                }
                    
                }
                catch(Exception ex){                        
                    system.debug('***Lead Account Update Exception:: ' + ex.getMessage() + ex.getLineNumber());
                }
                
            }
            
            Map<string,ContactLeadActivity__c> TaskConLeadActMap= new Map<string,ContactLeadActivity__c>();
            List<ContactLeadActivity__c>  conLeadListUpdate = new List<ContactLeadActivity__c>();
            List<ContactLeadActivity__c> conLeadActivitiesForUpdate= new List<ContactLeadActivity__c>();
            if(Schema.sObjectType.ContactLeadActivity__c.isAccessible()){
             conLeadActivitiesForUpdate =  [SELECT due_date__c,Status__c,Related_To_Contact__c,Subject__c,Lead__c,TaskId__c FROM ContactLeadActivity__c 
                 WHERE TaskId__c IN:newMap.keyset()];
            }
              
            system.debug('*****conLeadActivitiesForUpdate:: '+ conLeadActivitiesForUpdate);
            for(ContactLeadActivity__c cla : conLeadActivitiesForUpdate){
                //if(newMap.get(ala.TaskId__c).whoId.getSobjectType() == Schema.Lead.sObjectType){                   
                cla.Call_Type__c = newMap.get(cla.TaskId__c).CallType;
                cla.Due_Date__c= newMap.get(cla.TaskId__c).ActivityDate; 
                cla.Subject__c = newMap.get(cla.TaskId__c).Subject;
                cla.Status__c= newMap.get(cla.TaskId__c).Status;
                cla.Comments__c= newMap.get(cla.TaskId__c).Description; 
                cla.Type__c= newMap.get(cla.TaskId__c).Type; 
                //cla.Related_To_Contact__c = leadContactMap.get(newMap.get(cla.TaskId__c).whoId); 
                //cla.Lead__c= newMap.get(cla.TaskId__c).whoId;
                cla.Activity_owner__c= newMap.get(cla.TaskId__c).ownerId;
                cla.owner_group__c= newMap.get(cla.TaskId__c).owner_group__c;                
                
                conLeadListUpdate.add(cla);   
                //}    
            }                
            for(ContactLeadActivity__c cla: conLeadActivitiesForUpdate){
                TaskConLeadActMap.put(cla.TaskId__c,cla);
                
            }  
            if(conLeadListUpdate!= null && conLeadListUpdate.size() >0)
                try{
                    if (Schema.sObjectType.ContactLeadActivity__c.isUpdateable()) {
                    Update conLeadListUpdate;
                }
                }
            catch(Exception ex){                        
                system.debug('***Lead Contact Update Exception ' + ex.getMessage() + ex.getLineNumber());
            }
        }
    }   
    
    
    public static void deleteTasksToAccountLeadActivities(List<Task> newTaskList,map<id,Task> newMap,map<id,task> oldMap,boolean isBefore,boolean isDelete){
        /* if(isBefore){
List<AccountLeadActivity__c> toDeleteList = [Select id FROM AccountLeadActivity__c WHERE Taskid__c IN : newMap.keySet()];
if(toDeleteList !=null && toDeleteList.size()>0){
DELETE toDeleteList;
}

}*/
    }
    
    
    
    public static void deleteTasksToContactLeadActivities(List<Task> newTaskList,map<id,Task> newMap,map<id,task> oldMap,boolean isBefore,boolean isDelete){
        /*if(isBefore){
List<ContactLeadActivity__c> toDeleteList = [Select id FROM ContactLeadActivity__c WHERE Taskid__c IN : newMap.keySet()];
if(toDeleteList !=null && toDeleteList.size()>0){
DELETE toDeleteList;
}

}*/
    }
    /*
*CRM -11169
*Description : Updates whatid of the task created before sending trial/non trial Email
* @param  listInsertedTasks  List<Task> of tasks
*/
    public static void updatewhatId(List<Task> listInsertedTasks)
    {
        List<Id> listRelatedId = new List<Id>();
        
        if(!listInsertedTasks.isEmpty())
        {
            for(Task t : listInsertedTasks)
            {
                listRelatedId.add(t.WhatId);
            }
            
            Map<Id, Incentive_Password__c> mapIncentivePwd = new  Map<Id, Incentive_Password__c>();
            if(!listRelatedId.isEmpty())
            {
                mapIncentivePwd = new Map<Id, Incentive_Password__c>([Select Id,LCRM_Training_Event__c,LCRM_Opportunity__c,LCRM_Account__c from Incentive_Password__c where Id in :listRelatedId]);
            }
            
            for(Task t : listInsertedTasks)
            {
                if(!mapIncentivePwd .isEmpty())
                {
                    if(mapIncentivePwd .containsKey(t.WhatId))
                    {
                        if(IncentivePasswordController.Trainingeventtask)
                        {
                            t.WhatId =mapIncentivePwd .get(t.WhatId).LCRM_Training_Event__c;
                            t.LCRM_Sub_BU__c= IncentivePasswordController.LCRMSubBu;
                        }
                        else if(IncentivePasswordController.Accounttask)
                        {
                            t.WhatId =mapIncentivePwd .get(t.WhatId).LCRM_Account__c;
                            t.LCRM_Sub_BU__c= IncentivePasswordController.LCRMSubBu;
                        }
                        else if(IncentivePasswordControllerOpty.opptytask)
                        {
                            t.WhatId =mapIncentivePwd .get(t.WhatId).LCRM_Opportunity__c;
                            t.LCRM_Sub_BU__c= IncentivePasswordControllerOpty.LCRMSubBu;
                        }    
                    } 
                }       
                t.Type ='Email';
                t.LCRM_Activity_Type__c ='Email Outbound';
            }
        }
    }
    
    /*CRM -10938
*Description : Updates whatid of the task created before sending  usl reminder  Email
* @param  listInsertedTasks  List<Task> of tasks
*/
    public static void updateWhatIdinReminderTask(List<Task> listInsertedTasks)
    {
        
        List<Id> listRelatedId = new List<Id>();
        
        if(!listInsertedTasks.isEmpty())
        {
            for(Task t : listInsertedTasks)
            {
                listRelatedId.add(t.WhatId);
            }
            
            Map<Id, Training_Event_Contact__c> maptrainingeventcon = new   Map<Id, Training_Event_Contact__c>();
            if(!listRelatedId.isEmpty())
            {
                maptrainingeventcon = new Map<Id, Training_Event_Contact__c>([Select Id,Training_Event__c from Training_Event_Contact__c where Id in :listRelatedId]);
            }
            
            for(Task t : listInsertedTasks)
            {
                
                t.WhatId =maptrainingeventcon .get(t.WhatId).Training_Event__c;
                t.LCRM_Sub_BU__c='USL';
                
            }
        }
    }
    
    /*CRM -11533
*Description : Updates the activity type and status  of the task created before sending    survey Email
* @param  listInsertedTasks  List<Task> of tasks
*/
    public static void updateACTypeforsurveyemail(List<Task> listInsertedTasks)
    {
        
        
        for(Task otask : listInsertedTasks)
        {
            oTask.LCRM_Activity_Type__c = 'Training';
            oTask.Status= 'Completed';
            oTask.Status__c= 'Completed';
            oTask.LCRM_Sub_BU__c =LCRMMassEditTrainingContacts.mysubBu;
        }
    }
    
    
    
    /*Harika 
*Description : Moved the whole logic in trigger (i.e isinsert) into TaskUtil class as per EQA Comments
* @param  listInsertedTasks  List<Task> of tasks
*/
    public static void beforeinsertmethod(List<Task> listInsertedTasks)
    {
        Id GliTaskRecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('GLI Record Type').getRecordTypeId();
        //Added as part of CRM -11169 To update thE related to field*/
        if(IncentivePasswordController.Trainingeventtask || IncentivePasswordController.Accounttask || IncentivePasswordControllerOpty.opptytask)
        {
            updatewhatId(listInsertedTasks);
        }
        //Added as part of  CRM-11533 to update the Status and Activity Type
        if(LCRMMassEditTrainingContacts.surveyEmail)
        {
            updateACTypeforsurveyemail(listInsertedTasks);
        }
        //Added as part of  CRM-10938 to update the what id
        if(LCRMMassEditTrainingContacts.uslreminderEmail )
        {
            updateWhatIdinReminderTask(listInsertedTasks);
        }
        //CRM -11169
        //Updated for CRM-6244 & CRM-6243
        if(!IncentivePasswordController.sendEmailcheck)
        {
            if(!IncentivePasswordControllerOpty.sendEmailcheck)
            {
                //Updated for CRM-11533 
                if(!LCRMMassEditTrainingContacts.surveyEmail)
                {
                    //Updated for CRM-10938
                    if(!LCRMMassEditTrainingContacts.uslreminderEmail )
                    {
                        system.debug('after if');
                        if(Boolean.valueOf(System.Label.Legal_CRM_Switch) == True)
                        { 
                            TaskHandler.PopulateActivityTypeonEmail(listInsertedTasks); //Pratik code for LCRM project
                             if(!LCRMGenericComponent.isLotusUser()){
                            LCRMGenericComponent.populateSubbu(listInsertedTasks);//tejas code to update subbu
                        }
                            
                        }
                        for(Task otask : listInsertedTasks)
                        {
                            //PL First Sale Onboarding - Activity Creation
                            if((oTask.Description!=null && oTask.Description.contains('Offer Code 704330') ) && (oTask.subject=='30-Day Onboarding' || oTask.subject=='60-Day Onboarding' || oTask.subject=='90-Day Onboarding'))
                            {
                                oTask.Type= 'To Do';
                                oTask.Activity_Category__c = 'Touch Point';
                            }
                            //CRM -12068 Bug Added code for defaulting the Activity Type to 'Email Outbound' when task is created after clicking on standard Send Email Button
                            else if(otask.Status =='Completed' && otask.subject != null && otask.subject != ''  && otask.RecordTypeId == GliTaskRecordTypeId)
                            {
                                if(otask.subject.Contains('Email:'))
                                {
                                    oTask.LCRM_Activity_Type__c = 'Email Outbound';
                                    oTask.Status__c= 'Completed';
                                    oTask.Status= 'Completed';
                                }
                            }
                        }
                    }
                }
            }
            
        }
        
    }
    
    /**
*   {Purpose} - Method to insert Lead Ids into the Lead Activity Count Stage
*               table, which will have their Completed Activity Count refreshed.
*
*   CHANGE HISTORY
*   =============================================================================
*   Date            Name                    Description
*   20181016        Jason Flippen           Created
*   =============================================================================
**/
    public static void processLeadActivityCountStageInserts(Set<Id> leadIdSet) {
        
        // Grab a Set of Lead (Id) records that have already queued for refresh.
        Set<Id> excludeLeadIdSet = new Set<Id>();
        for (Lead_Activity_Count_Stage__c lacs : [SELECT Lead__c
                                                  FROM   Lead_Activity_Count_Stage__c
                                                  WHERE  Lead__c IN :leadIdSet]) {
                                                      excludeLeadIdSet.add(lacs.Lead__c);
                                                  }
        
        // Grab a List of Lead Activity Count Stage records to be inserted.
        List<Lead_Activity_Count_Stage__c> insertLACSList = new List<Lead_Activity_Count_Stage__c>();
        for (Id leadId : leadIdSet) {
            
            // We don't need to add a Lead Id if it's already queued for refresh.
            if (!excludeLeadIdSet.contains(leadId)) {
                Lead_Activity_Count_Stage__c insertLACS = new Lead_Activity_Count_Stage__c(Lead__c = leadId);
                insertLACSList.add(insertLACS);
            }
            
        }
        
        // If we have records to insert, insert them.
        if (!insertLACSList.isEmpty()) {
            if(Schema.sObjectType.Lead_Activity_Count_Stage__c.isCreateable()){
            insert insertLACSList;
        }
        
    }
    
}    
}