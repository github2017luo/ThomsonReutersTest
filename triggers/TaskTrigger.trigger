trigger TaskTrigger on Task (after insert, after update, after delete) 
{
      //LTS_6268 : Exclusion framework
      System.debug('LTS_ApplicationAutomationUtility.checkTriggerApplicability()** '+LTS_ApplicationAutomationUtility.checkTriggerApplicability());
      If(LTS_ApplicationAutomationUtility.checkTriggerApplicability())
      {return;}
  
    List<Id> listTaskIds = new List<Id>();
    Schema.DescribeSobjectResult  sdr_opp = Schema.SObjectType.Opportunity;
    Schema.DescribeSobjectResult  sdr_lead = Schema.SObjectType.Lead;
    public static boolean isExecute= true;
    private static final String STATUS_COMPLETED = 'Completed';

    // Insert Event calls
    if(trigger.isInsert)
    {
     //Updated for CRM-11533
    if(!LCRMMassEditTrainingContacts.surveyEmail)
    {
            TaskUtil.copyTaskAfterInserted(trigger.new);
     
        for(Task oTask : trigger.new){
          if(!AppUtil.IsEmpty(oTask.Id)){
            listTaskIds.add(oTask.Id);
          }
            
        }
         if(!listTaskIds.IsEmpty()){
             If(System.isFuture() || System.isBatch()){
                TaskUtil.UpdateNextCallDate(listTaskIds,'Task'); 
             }else{
                 TaskUtil.UpdateNextCallDate_Future(listTaskIds,'Task');
             }
            
        }
        
        
        
        /*List<Id> listRelatedId = new List<Id>();
        for(Task t : Trigger.new)
        {
            listRelatedId.add(t.WhatId);
        }
        List<Training_Event_Account__c> listTrainingEventAccount = new List<Training_Event_Account__c>();
        if(!listRelatedId.isEmpty())
        {
            listTrainingEventAccount = [select Training_Event__c, Account__c from Training_Event_Account__c where Training_Event__c in :listRelatedId];
        }
        List<Task> listClonedTasks = new List<Task>();
        if(!listTrainingEventAccount.isEmpty())
        {
            for(Task t : Trigger.new)
            {
                for(Training_Event_Account__c tTrainingEventAccountSingle : listTrainingEventAccount)
                {
                    if(tTrainingEventAccountSingle.Training_Event__c == t.WhatId)
                    {
                        Task[] ClonedTask = (new Task[]{t}).deepClone(false);
                        ClonedTask[0].WhoId = null;
                        ClonedTask[0].WhatId = tTrainingEventAccountSingle.Account__c;
                        ClonedTask[0].ParentActivityId__c = t.Id;
                        ClonedTask[0].IsReminderSet = false;
                        listClonedTasks.add(ClonedTask[0]);
                    }
                }
            }
        }
        if(!listClonedTasks.isEmpty())
        {
            insert listClonedTasks;
        }*/
    }

        // 20181016 - Jason Flippen - Added for Jira Story CRM-13127.
        Set<Id> leadIdSet = new Set<Id>();
        for (Task t : Trigger.new) {
            if (!AppUtil.IsEmpty(t.WhoId) &&
                String.valueOf(t.WhoId).left(3) == sdr_lead.keyPrefix &&
                t.Status == STATUS_COMPLETED) {
                leadIdSet.add(t.WhoId);
            }
        }
        if (!leadIdSet.isEmpty()) {
            // We only want to refresh the Completed Activity Count
            // for GLI Leads that haven't yet been converted.
            Map<Id,Lead> leadMap = new Map<Id,Lead>([SELECT Id
                                                     FROM   Lead
                                                     WHERE  Id IN :leadIdSet
                                                     AND    Is_GLI__c = true
                                                     AND    IsConverted = false]);
            TaskUtil.processLeadActivityCountStageInserts(leadMap.keySet());
        }
        
    }
    
    
    // UPDATE EVENT CALLS
    if(trigger.isUpdate)
    {
        if(LCRMConvertLeadController.lcrmConvertLeadFlag){ //Added for CRM-17836
            TaskUtil.copyTaskAfterUpdated(trigger.newMap);
            }
    //    TaskUtil.UpdateNextCallDateOnOpp(trigger.new,null,'Update');
       // TaskUtil.UpdateNextCallDateOnLead(trigger.new,null,'Update');
       
       for(Task oTask : trigger.new){
          if(!AppUtil.IsEmpty(oTask.Id)&& (oTask.ActivityDate!=trigger.oldmap.get(oTask.Id).ActivityDate
                                            || oTask.Status !=trigger.oldmap.get(oTask.Id).Status 
                                            || oTask.WhatId !=trigger.oldmap.get(oTask.Id).WhatId
                                            || oTask.WhoId !=trigger.oldmap.get(oTask.Id).WhoId)){
            listTaskIds.add(oTask.Id);
          }
            
       }
         if(!listTaskIds.IsEmpty()){
            //if(LCRMConvertLeadController.lcrmConvertLeadFlag){ //Added for CRM-17836
                //TaskUtil.UpdateNextCallDate(listTaskIds,'Task');
             //TaskUtil.UpdateNextCallDate_Future(listTaskIds,'Task');
             If(System.isFuture() || System.isBatch()){
                TaskUtil.UpdateNextCallDate(listTaskIds,'Task'); 
             }else{
                 TaskUtil.UpdateNextCallDate_Future(listTaskIds,'Task');
             }
             //}
        }
        
        // 20181016 - Jason Flippen - Added for Jira Story CRM-13127.
        Set<Id> leadIdSet = new Set<Id>();
        for (Task t : Trigger.new) {
            if (!AppUtil.IsEmpty(t.WhoId) &&
                String.valueOf(t.WhoId).left(3) == sdr_lead.keyPrefix &&
                t.Status != Trigger.oldMap.get(t.Id).Status &&
                t.Status == STATUS_COMPLETED) {
                leadIdSet.add(t.WhoId);
            }
        }
        if (!leadIdSet.isEmpty()) {
            // We only want to refresh the Completed Activity Count
            // for GLI Leads that haven't yet been converted.
            Map<Id,Lead> leadMap = new Map<Id,Lead>([SELECT Id
                                                     FROM   Lead
                                                     WHERE  Id IN :leadIdSet
                                                     AND    Is_GLI__c = true
                                                     AND    IsConverted = false]);
            TaskUtil.processLeadActivityCountStageInserts(leadMap.keySet());
        }
        
        /*List<Id> listRelatedId = new List<Id>();
        for(Task t : Trigger.new)
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
            for(Task t : Trigger.new)
            {
                ParentActivityIds.add((String)t.Id);
            }
            for(Task t : [select Id, Owner_Group__c, Type, Description, ActivityDate, Status, Subject, Priority, Tracking_Code__c, ReminderDateTime, IsReminderSet, ParentActivityId__c from Task where WhatId in : AccountIds and ParentActivityId__c in : ParentActivityIds])
            {
                Task UpdatedTask = trigger.newMap.get((Id)t.ParentActivityId__c);
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
                update listUpdateTasks;
            }
        }*/
    }
    
    
    // DELETE EVENT CALLS
    if(trigger.isDelete)
    {
        TaskUtil.deleteRelatedTasks(Trigger.old);
     //   TaskUtil.UpdateNextCallDateOnOpp(trigger.old,null,'Delete');
      //  TaskUtil.UpdateNextCallDateOnLead(trigger.old,null,'Delete');  
      
      
        List<Id> listRelatedOppId =  new List<Id>();
        List<Id> listRelatedLeadId = new List<Id>();
         for(Task oTask : trigger.old){
          if(!AppUtil.IsEmpty(oTask.Id)){
            listTaskIds.add(oTask.Id);
            if(!AppUtil.IsEmpty(oTask.WhatId) && sdr_opp.keyPrefix == String.valueOf(oTask.WhatId).left(3))
                listRelatedOppId.add(oTask.WhatId);
            
            if(!AppUtil.IsEmpty(oTask.WhoId) && sdr_lead.keyPrefix == String.valueOf(oTask.WhoId).left(3))
                listRelatedLeadId.add(oTask.WhoId);
          }
            
       }
         if(!listTaskIds.IsEmpty()){
             TaskUtil.UpdateNextCallDateOnDelete(listTaskIds,listRelatedOppId,listRelatedLeadId,'Task');
        }
      
        // 20181016 - Jason Flippen - Added for Jira Story CRM-13127.
        Set<Id> leadIdSet = new Set<Id>();
        for (Task t : Trigger.old) {
            if (!AppUtil.IsEmpty(t.WhoId) &&
                String.valueOf(t.WhoId).left(3) == sdr_lead.keyPrefix &&
                t.Status__c == STATUS_COMPLETED) {
                leadIdSet.add(t.WhoId);
            }
        }
        if (!leadIdSet.isEmpty()) {
            // We only want to refresh the Completed Activity Count
            // for GLI Leads that haven't yet been converted.
            Map<Id,Lead> leadMap = new Map<Id,Lead>([SELECT Id
                                                     FROM   Lead
                                                     WHERE  Id IN :leadIdSet
                                                     AND    Is_GLI__c = true
                                                     AND    IsConverted = false]);
            TaskUtil.processLeadActivityCountStageInserts(leadMap.keySet());
        }
        
       // TaskUtil_nand.UpdateNextCallDate(trigger.old,null,'Delete');      
        /*List<String> ParentActivityIds = new List<String>();
        for(Task t : Trigger.old)
        {
            ParentActivityIds.add((String)t.Id);
        }
        List<Task> listDeleteTasks = [select Id, Owner_Group__c, Type, Description, ActivityDate, Status, Subject, Priority, Tracking_Code__c, ReminderDateTime, IsReminderSet, ParentActivityId__c from Task where ParentActivityId__c in : ParentActivityIds];
        if(!listDeleteTasks.isEmpty())
        {
            delete listDeleteTasks;
        }*/
        
    }
     // User Story #33 To pull the Task Activity into Account and Contact. Start Here
     if(Trigger.isAfter && (Trigger.isInsert || Trigger.IsUpdate)){
           if(checkRecursive.runTaskTriggerOnce())
           {            
             TaskUtil.pullTasksToAccountContactLeadActivities(Trigger.new,Trigger.newMap,Trigger.oldMap,Trigger.isAfter,Trigger.isInsert,Trigger.isUpdate,Trigger.isDelete);
             //TaskUtil.pullTasksToContactLeadActivities(Trigger.new,Trigger.newMap,Trigger.oldMap,Trigger.isAfter,Trigger.isInsert,Trigger.isUpdate,Trigger.isDelete);
           }
     }     

     
     
    // User Story # 33 : End Here 
}