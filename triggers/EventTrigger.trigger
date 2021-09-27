trigger EventTrigger on Event (after insert, after update, after delete) 
{
    //LTS_6301 : Exclusion framework
System.debug('LTS_ApplicationAutomationUtility.checkTriggerApplicability()** '+LTS_ApplicationAutomationUtility.checkTriggerApplicability());
If(LTS_ApplicationAutomationUtility.checkTriggerApplicability())
{return;}
    
    
    List<Id> listEventIds = new List<Id>();
    Schema.DescribeSobjectResult  sdr_opp = Schema.SObjectType.Opportunity;
    Schema.DescribeSobjectResult  sdr_lead = Schema.SObjectType.Lead;
    private static final String STATUS_COMPLETED = 'Completed';

    // INSERT EVENTS CALL
    if(trigger.isInsert)
    {
        EventUtil.copyEventAfterInserted(Trigger.new);
       // TaskUtil.UpdateNextCallDateOnOpp(null,trigger.new,'Insert');
  
       //TaskUtil.UpdateNextCallDateOnLead(null,trigger.new,'Insert');
       
        
       for(Event oEvent : trigger.new){
          if(!AppUtil.IsEmpty(oEvent.Id)){
            listEventIds.add(oEvent.Id);
          }
            
       } 
       if(!listEventIds.IsEmpty()){
       //  if(!System.IsFuture()){
       // SKG added !System.isbatch() for glance batch process to not call future 12/18/2014
         if(!System.IsFuture() && !System.isBatch()){
         
             TaskUtil.UpdateNextCallDate_Future(listEventIds,'Event');
         }else if(System.IsFuture()){
            TaskUtil.UpdateNextCallDate(listEventIds,'Event');
            }
       } 
        
        // 20181016 - Jason Flippen - Added for Jira Story CRM-13127.
        Set<Id> leadIdSet = new Set<Id>();
        for (Event e : Trigger.new) {
            if (!AppUtil.IsEmpty(e.WhoId) &&
                String.valueOf(e.WhoId).left(3) == sdr_lead.keyPrefix &&
                e.Status__c == STATUS_COMPLETED) {
                leadIdSet.add(e.WhoId);
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
        for(Event t : Trigger.new)
        {
            listRelatedId.add(t.WhatId);
        }
        List<Training_Event_Account__c> listTrainingEventAccount = new List<Training_Event_Account__c>();
        if(!listRelatedId.isEmpty())
        {
            listTrainingEventAccount = [select Training_Event__c, Account__c from Training_Event_Account__c where Training_Event__c in :listRelatedId];
        }
        List<Event> listClonedEvents = new List<Event>();
        if(!listTrainingEventAccount.isEmpty())
        {
            for(Event t : Trigger.new)
            {
                for(Training_Event_Account__c tTrainingEventAccountSingle : listTrainingEventAccount)
                {
                    if(tTrainingEventAccountSingle.Training_Event__c == t.WhatId)
                    {
                        Event[] ClonedEvent = (new Event[]{t}).deepClone(false);
                        ClonedEvent[0].WhoId = null;
                        ClonedEvent[0].WhatId = tTrainingEventAccountSingle.Account__c;
                        ClonedEvent[0].ParentActivityId__c = t.Id;
                        ClonedEvent[0].IsReminderSet = false;
                        listClonedEvents.add(ClonedEvent[0]);
                    }
                }
            }
        }
        if(!listClonedEvents.isEmpty())
        {
            insert listClonedEvents;
        }*/
    }
    
    //UPDATE EVENT CALLS
    if(trigger.isUpdate)
    {
        if(LCRMConvertLeadController.lcrmConvertLeadFlag){ //Added for CRM-17836
            EventUtil.copyEventAfterUpdated(Trigger.newMap);
        }
        
        for(Event oEvent : trigger.new){
          if(!AppUtil.IsEmpty(oEvent.Id)&& (oEvent.ActivityDate!=trigger.oldmap.get(oEvent.Id).ActivityDate
                                            || oEvent.WhatId !=trigger.oldmap.get(oEvent.Id).WhatId
                                            || oEvent.WhoId !=trigger.oldmap.get(oEvent.Id).WhoId)){
            listEventIds.add(oEvent.Id);
          }
            
       }
         if(!listEventIds.IsEmpty()){
            if(LCRMConvertLeadController.lcrmConvertLeadFlag){ //Added for CRM-17836
                TaskUtil.UpdateNextCallDate(listEventIds,'Event');
            }
        }
       
        // 20181016 - Jason Flippen - Added for Jira Story CRM-13127.
        Set<Id> leadIdSet = new Set<Id>();
        for (Event e : Trigger.new) {
            if (!AppUtil.IsEmpty(e.WhoId) &&
                String.valueOf(e.WhoId).left(3) == sdr_lead.keyPrefix &&
                e.Status__c != Trigger.oldMap.get(e.Id).Status__c &&
                e.Status__c == STATUS_COMPLETED) {
                leadIdSet.add(e.WhoId);
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
        
     //   TaskUtil.UpdateNextCallDateOnOpp(null,trigger.new,'Update');
       
      //  TaskUtil.UpdateNextCallDateOnLead(null,trigger.new,'Update');
       
        /*List<Id> listRelatedId = new List<Id>();
        for(Event t : Trigger.new)
        {
            listRelatedId.add(t.WhatId);
        }
        List<Training_Event_Account__c> listTrainingEventAccount = new List<Training_Event_Account__c>();
        if(!listRelatedId.isEmpty())
        {
            listTrainingEventAccount = [select Training_Event__c, Account__c from Training_Event_Account__c where Training_Event__c in :listRelatedId];
        }
        List<Event> listUpdateEvents = new List<Event>();
        if(!listTrainingEventAccount.isEmpty())
        {
            List<Id> AccountIds = new List<Id>();
            List<String> ParentActivityIds = new List<String>();
            for(Training_Event_Account__c tTrainingEventAccountSingle : listTrainingEventAccount)
            {
                AccountIds.add(tTrainingEventAccountSingle.Account__c);
            }
            for(Event t : Trigger.new)
            {
                ParentActivityIds.add((String)t.Id);
            }
            for(Event t : [select Id, Owner_Group__c, Type, Description, ActivityDate, status__c, Subject, Tracking_Code__c, ReminderDateTime, IsReminderSet, ParentActivityId__c, IsAllDayEvent, StartDateTime, EndDateTime, Comments__c from Event where WhatId in : AccountIds and ParentActivityId__c in : ParentActivityIds])
            {
                Event UpdatedEvent = trigger.newMap.get((Id)t.ParentActivityId__c);
                if(t.Owner_Group__c != UpdatedEvent.Owner_Group__c || t.Type != UpdatedEvent.Type ||
                t.Description != UpdatedEvent.Description || t.ActivityDate != UpdatedEvent.ActivityDate ||
                t.status__c != UpdatedEvent.status__c || t.Subject != UpdatedEvent.Subject ||
                t.Tracking_Code__c != UpdatedEvent.Tracking_Code__c || t.ReminderDateTime != UpdatedEvent.ReminderDateTime || 
                t.IsAllDayEvent != UpdatedEvent.IsAllDayEvent || t.StartDateTime != UpdatedEvent.StartDateTime || 
                t.EndDateTime != UpdatedEvent.EndDateTime || t.Comments__c != UpdatedEvent.Comments__c ||
                t.Tracking_Code__c != UpdatedEvent.Tracking_Code__c)
                {
                    t.Owner_Group__c = UpdatedEvent.Owner_Group__c;
                    t.Type = UpdatedEvent.Type;
                    t.Description = UpdatedEvent.Description;
                    t.ActivityDate = UpdatedEvent.ActivityDate;
                    t.status__c = UpdatedEvent.status__c;
                    t.Subject = UpdatedEvent.Subject;
                    t.Tracking_Code__c = UpdatedEvent.Tracking_Code__c;
                    t.ReminderDateTime = UpdatedEvent.ReminderDateTime;
                    t.IsAllDayEvent = UpdatedEvent.IsAllDayEvent;
                    t.StartDateTime = UpdatedEvent.StartDateTime;
                    t.EndDateTime = UpdatedEvent.EndDateTime;
                    t.Comments__c = UpdatedEvent.Comments__c;
                    t.Tracking_Code__c = UpdatedEvent.Tracking_Code__c;
                    listUpdateEvents.add(t);
                    
                }
            }
            if(!listUpdateEvents.isEmpty())
            {
                update listUpdateEvents;
            }
        }*/        
    }
    
    // DELETE EVENT CALLS
    if(trigger.isDelete)
    {
        EventUtil.deleteRelatedEvents(Trigger.old);
        
        List<Id> listRelatedOppId =  new List<Id>();
        List<Id> listRelatedLeadId = new List<Id>();
         for(Event oEvent : trigger.old){
          if(!AppUtil.IsEmpty(oEvent.Id)){
            listEventIds.add(oEvent.Id);
            if(!AppUtil.IsEmpty(oEvent.WhatId) && sdr_opp.keyPrefix == String.valueOf(oEvent.WhatId).left(3))
                listRelatedOppId.add(oEvent.WhatId);
            
            if(!AppUtil.IsEmpty(oEvent.WhoId)&& sdr_lead.keyPrefix == String.valueOf(oEvent.WhoId).left(3))
                listRelatedLeadId.add(oEvent.WhoId);
          }
            
       }
         if(!listEventIds.IsEmpty()){
             TaskUtil.UpdateNextCallDateOnDelete(listEventIds,listRelatedOppId,listRelatedLeadId,'Event');
        }
        
        // 20181016 - Jason Flippen - Added for Jira Story CRM-13127.
        Set<Id> leadIdSet = new Set<Id>();
        for (Event e : Trigger.old) {
            if (!AppUtil.IsEmpty(e.WhoId) &&
                String.valueOf(e.WhoId).left(3) == sdr_lead.keyPrefix &&
                e.Status__c == STATUS_COMPLETED) {
                leadIdSet.add(e.WhoId);
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
        
   //     TaskUtil.UpdateNextCallDateOnOpp(null,trigger.old,'Delete');
     //   TaskUtil.UpdateNextCallDateOnLead(null,trigger.old,'Delete');
        
        /*List<String> ParentActivityIds = new List<String>();
        for(Event t : Trigger.old)
        {
            ParentActivityIds.add((String)t.Id);
        }
        List<Event> listDeleteEvents = [select Id, Owner_Group__c, Type, Description, ActivityDate, status__c, Subject, Tracking_Code__c, ReminderDateTime, IsReminderSet, ParentActivityId__c from Event where ParentActivityId__c in : ParentActivityIds];
        if(!listDeleteEvents.isEmpty())
        {
            delete listDeleteEvents;
        }*/
    }
      if(Trigger.isAfter && (Trigger.isInsert || Trigger.IsUpdate)){
           if(checkRecursive.runEventTriggerOnce())
           {            
             EventUtil.pullEventsToAccountLeadActivities(Trigger.new,Trigger.newMap,Trigger.oldMap,Trigger.isAfter,Trigger.isInsert,Trigger.isUpdate,Trigger.isDelete);
            
           }
     }   
    
}