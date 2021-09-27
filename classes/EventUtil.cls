/**
 * Contains methods for Event Trigger
 * Creates the events on Account whenever new events are created on Training Event
 * Updates the events on Account whenever new events are updated on Training Event
 * Deletes the events on Account whenever new events are deleted on Training Event
 *
 * @author  Srikanth Kuruva
 * @version  2012-04-06
 */
 /**
 * CHANGE HISTORY
 * =============================================================================
 * Date         Name                    Description
 * 2012-06-15   Srikanth Kuruva     Updated the trigger to fix the issue-IM3547703
 * 2013-02-22   Anshita Sharma      Updated 'copyEventAfterInserted' method to avoid 
 *                                  duplication of event on account.
 * 2017-09-22   Seema Nagdev        Added 'pullEventsToAccountLeadActivities'method 
                                    as a part of CRM-7710
 * =============================================================================
 */ 
 public without sharing class EventUtil{
    public static void copyEventAfterInserted(List<Event> listInsertedEvents)
    {
        List<Id> listRelatedId = new List<Id>();
        List<Id> listRelatedConId= new List<Id>();
        for(Event t : listInsertedEvents)
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
            listTrainingEventAccount = [select Training_Event__c, Account__c from Training_Event_Account__c where Training_Event__c in :listRelatedId];
         }
        Map<Id,Contact> mapContactAccnts = new Map<Id,Contact>();
        if(!listRelatedConId.isEmpty())
        {
            mapContactAccnts = new Map<Id, Contact>([Select Id,AccountId from Contact where id in:listRelatedConId]);
        }
        List<Event> listClonedEvents = new List<Event>();
        if(!listTrainingEventAccount.isEmpty())
        {
            for(Event t : listInsertedEvents)
            {
                for(Training_Event_Account__c tTrainingEventAccountSingle : listTrainingEventAccount)
                {
                    if(tTrainingEventAccountSingle.Training_Event__c == t.WhatId)
                    {
                        if(!mapContactAccnts.isEmpty())
                        {
                            if(tTrainingEventAccountSingle.Account__c != mapContactAccnts.get(t.WhoId).AccountId)
                            {
                                Event[] ClonedEvent = (new Event[]{t}).deepClone(false);
                                ClonedEvent[0].WhoId = null;
                                ClonedEvent[0].Training_Event_Id__c = mapTrainingEvent.get(t.WhatId).Id;
                                ClonedEvent[0].Training_Event_Name__c = mapTrainingEvent.get(t.WhatId).Name;
                                ClonedEvent[0].WhatId = tTrainingEventAccountSingle.Account__c;
                                ClonedEvent[0].ParentActivityId__c = t.Id;
                                ClonedEvent[0].IsReminderSet = false;
                                listClonedEvents.add(ClonedEvent[0]);
                            }
                        }
                        else
                        {
                            Event[] ClonedEvent = (new Event[]{t}).deepClone(false);
                            ClonedEvent[0].WhoId = null;
                            ClonedEvent[0].Training_Event_Id__c = mapTrainingEvent.get(t.WhatId).Id;
                            ClonedEvent[0].Training_Event_Name__c = mapTrainingEvent.get(t.WhatId).Name;
                            ClonedEvent[0].WhatId = tTrainingEventAccountSingle.Account__c;
                            ClonedEvent[0].ParentActivityId__c = t.Id;
                            ClonedEvent[0].IsReminderSet = false;
                            listClonedEvents.add(ClonedEvent[0]); 
                        } 
                    }
                }
            }
        }
        if(!listClonedEvents.isEmpty())
        {
            insert listClonedEvents;
        }
    }
    
    
      /*  public static void UpdateNextCallDateOnOpp(List<Task> listInsertedTasks,List<Event> ListInsertedEvents, String triggerEvent){
        List<Id> listRelatedId = new List<Id>();
        List<Task> listTasks = new List<Task>();
        List<Event> listEvents = new List<Event>();
        List<Opportunity> listOpportunity = new List<Opportunity>();
        List<Opportunity> listOpportunityToUpdate = new List<Opportunity>();
        
        if(listInsertedTasks != null) {
            for(Task t : listInsertedTasks)
            {
                listRelatedId.add(t.WhatId);
            }
        }
        
        if(ListInsertedEvents != null){
            for(Event oEvent : ListInsertedEvents)
            {
                listRelatedId.add(oEvent.WhatId);
            }
        }
        
        if(!listRelatedId.isEmpty())
        {
            listOpportunity  = [Select Id ,Name ,Next_Call_Date__c from Opportunity where Id in :listRelatedId];
            if(!listOpportunity.isEmpty()){
                if(triggerEvent=='Update' || triggerEvent=='Insert'){
                    listTasks = [Select Id,WhatId,ActivityDate from Task where WhatId IN : listRelatedId and Status IN ('In Progress','Pending')];
                    listEvents = [Select Id,WhatId,ActivityDate from Event where WhatId IN : listRelatedId and ActivityDatetime > : System.now()];
    
                }
                else if(triggerEvent == 'Delete'){
                    if(listInsertedTasks!= null){
                      listTasks = [Select Id,WhatId,ActivityDate from Task where WhatId IN : listRelatedId and Status IN ('In Progress','Pending') and Id NOT IN : listInsertedTasks];
                      listEvents = [Select Id,WhatId,ActivityDate from Event where WhatId IN : listRelatedId and ActivityDatetime > : System.now()];
                    }
                    if(listInsertedEvents!= null){
                    listTasks = [Select Id,WhatId,ActivityDate from Task where WhatId IN : listRelatedId and Status IN ('In Progress','Pending')];
                      listEvents = [Select Id,WhatId,ActivityDate from Event where WhatId IN : listRelatedId and ActivityDatetime > : System.now() and Id NOT IN : listInsertedEvents];
                    }  
                }
            }
        }
        
        Map<Id,List<Date>> mapOpportunityDueDate =  new Map<Id,List<Date>>();
        Map<Id,Date> mapOpportunityNextCallDate =  new Map<Id,Date>();
        
        for(Task t : listTasks){
       
            if(mapOpportunityDueDate.containsKey(t.WhatID)){
              mapOpportunityDueDate.get(t.WhatID).add(t.ActivityDate);
            }else{
                List<Date> ListDueDate = new List<Date>();
                ListDueDate.add(t.ActivityDate);
                mapOpportunityDueDate.put(t.WhatID,ListDueDate);
            
            }
        }
        
        for(Event oEvent : listEvents){
           
            if(mapOpportunityDueDate.containsKey(oEvent.WhatID)){
              mapOpportunityDueDate.get(oEvent.WhatID).add(oEvent.ActivityDate);
            }else{
                List<Date> ListDueDate = new List<Date>();
                ListDueDate.add(oEvent.ActivityDate);
                mapOpportunityDueDate.put(oEvent.WhatID,ListDueDate);
            
            }
        }
        
        for(Id OppId : mapOpportunityDueDate.Keyset()){
                List<Date> duedates = mapOpportunityDueDate.get(OppId);
                duedates.sort();
                mapOpportunityNextCallDate.put(OppId,duedates[0]);
        }
        
        for(Opportunity oOpportunity : listOpportunity){
            if(oOpportunity.Next_Call_Date__c!=null && triggerEvent!= 'Delete'){
                oOpportunity.Next_Call_Date__c =  mapOpportunityNextCallDate.get(oOpportunity.Id);

                listOpportunityToUpdate.add(oOpportunity);
            }else if(oOpportunity.Next_Call_Date__c == null || triggerEvent== 'Delete'){     
                oOpportunity.Next_Call_Date__c =  mapOpportunityNextCallDate.get(oOpportunity.Id);
                listOpportunityToUpdate.add(oOpportunity);  
            }
        }
        update listOpportunityToUpdate;
    }
    
        
    
   
        public static void UpdateNextCallDateOnLead(List<Task> listInsertedTasks,List<Event> ListInsertedEvents, String triggerEvent){
        List<Id> listRelatedId = new List<Id>();
        List<Task> listTasks = new List<Task>();
        List<Event> listEvents = new List<Event>();
        List<Lead> listLeads = new List<Lead>();
        List<Lead> listLeadsToUpdate = new List<Lead>();
        
        if(listInsertedTasks != null) {
            for(Task t : listInsertedTasks)
            {
                listRelatedId.add(t.WhoId);
            }
        }
        
        if(ListInsertedEvents != null){
            for(Event oEvent : ListInsertedEvents)
            {
                listRelatedId.add(oEvent.WhoId);
            }
        }
        
        if(!listRelatedId.isEmpty())
        {
            listLeads  = [Select Id ,Name ,Next_Call_Date__c from Lead where Id in :listRelatedId];
            if(!listLeads.isEmpty()){
                if(triggerEvent=='Update' || triggerEvent=='Insert'){
                    listTasks = [Select Id,WhoId,ActivityDate from Task where WhoId IN : listRelatedId and Status IN ('In Progress','Pending')];
                    listEvents = [Select Id,WhoId,ActivityDatetime from Event where WhoId IN : listRelatedId and ActivityDatetime > : System.now()];
    
                }
                else if(triggerEvent == 'Delete'){
                    if(listInsertedTasks!= null){
                      listTasks = [Select Id,WhoId,ActivityDate from Task where WhoId IN : listRelatedId and Status IN ('In Progress','Pending') and Id NOT IN : listInsertedTasks];
                      listEvents = [Select Id,WhoId,ActivityDate from Event where WhoId IN : listRelatedId and ActivityDatetime > : System.now()];
                    }
                    if(listInsertedEvents!= null){
                      listTasks = [Select Id,WhoId,ActivityDate from Task where WhoId IN : listRelatedId and Status IN ('In Progress','Pending')];
                      listEvents = [Select Id,WhoId,ActivityDate from Event where WhoId IN : listRelatedId and ActivityDatetime > : System.now() and Id NOT IN : listInsertedEvents];
                    }  
                }
          }
        }
        
        
        Map<Id,List<Date>> mapLeadDueDate =  new Map<Id,List<Date>>();
        Map<Id,Date> mapLeadNextCallDate =  new Map<Id,Date>();
        
        for(Task t : listTasks){
       
            if(mapLeadDueDate.containsKey(t.WhoId)){
              mapLeadDueDate.get(t.WhoId).add(t.ActivityDate);
            }else{
                List<Date> ListDueDate = new List<Date>();
                ListDueDate.add(t.ActivityDate);
                mapLeadDueDate.put(t.WhoId,ListDueDate);
            
            }
        }
        
        for(Event oEvent : listEvents){
           
            if(mapLeadDueDate.containsKey(oEvent.WhoId)){
              mapLeadDueDate.get(oEvent.WhoId).add(oEvent.ActivityDate);
            }else{
                List<Date> ListDueDate = new List<Date>();
                ListDueDate.add(oEvent.ActivityDate);
                mapLeadDueDate.put(oEvent.WhoId,ListDueDate);
            
            }
        }
        
        for(Id LeadId : mapLeadDueDate.Keyset()){
                List<Date> duedates = mapLeadDueDate.get(LeadId);
                duedates.sort();
                mapLeadNextCallDate.put(LeadId,duedates[0]);
        }
        
        for(Lead oLead : listLeads){
            if(oLead.Next_Call_Date__c!=null && triggerEvent!= 'Delete'){
                oLead.Next_Call_Date__c =  mapLeadNextCallDate.get(oLead.Id);

                listLeadsToUpdate.add(oLead);
            }else if(oLead.Next_Call_Date__c == null || triggerEvent== 'Delete'){     
                oLead.Next_Call_Date__c =  mapLeadNextCallDate.get(oLead.Id);
                listLeadsToUpdate.add(oLead);  
            }
        }
        update listLeadsToUpdate;
    }*/
    

    public static void copyEventAfterUpdated(map<Id,Event> mapUpdatedEvents)
    {
        List<Id> listRelatedId = new List<Id>();
        for(Event t : mapUpdatedEvents.values())
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
            for(Event t : mapUpdatedEvents.values())
            {
                ParentActivityIds.add((String)t.Id);
            }
            for(Event t : [select Id, Owner_Group__c, Type, Description, ActivityDate, status__c, Subject, Tracking_Code__c, ReminderDateTime, IsReminderSet, ParentActivityId__c, IsAllDayEvent, StartDateTime, EndDateTime, Comments__c from Event where WhatId in : AccountIds and ParentActivityId__c in : ParentActivityIds])
            {
                Event UpdatedEvent = mapUpdatedEvents.get((Id)t.ParentActivityId__c);
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
        }
    }
    public static void deleteRelatedEvents(List<Event> listDeletedEvents)
    {
        List<String> ParentActivityIds = new List<String>();
        for(Event t : listDeletedEvents)
        {
            ParentActivityIds.add((String)t.Id);
        }
        List<Event> listDeleteEvents = [select Id, Owner_Group__c, Type, Description, ActivityDate, status__c, Subject, Tracking_Code__c, ReminderDateTime, IsReminderSet, ParentActivityId__c from Event where ParentActivityId__c != null and ParentActivityId__c in : ParentActivityIds];
        if(!listDeleteEvents.isEmpty())
        {
            delete listDeleteEvents;
        }
    }
    
    //Start:Added for CRM-7710 to display  Lead Events on Account under AccountLeadActivites
    public static void pullEventsToAccountLeadActivities(List<Event> newEventList,map<id,Event> newMap,map<id,event> oldMap,boolean isAfter,boolean isInsert,boolean isUpdate,boolean isDelete){
       
        if(isAfter){
            List<Lead> leadsForEventslist= new List<Lead>();
            Map<Id,id> eventLeadMap=new Map<Id,id> ();
            Map<Id,id> leadAccountMap=new Map<Id,id> ();   
            
            if(isInsert){
                List<AccountLeadActivity__c> alcListInsert=new List<AccountLeadActivity__c>();
                if(!newEventList.isEmpty()){
                    for(Event e:newEventList){
                        eventLeadMap.put(e.id,e.whoId);
                    }
                     leadsForEventslist = [SELECT Account__c,id from LEAD WHERE id IN:eventLeadMap.Values() and RecordType.Name = :Label.LCRMEventRecType];
                    
                    if(!leadsForEventslist.isEmpty()){
                        for(lead l: leadsForEventslist){
                            leadAccountMap.put(l.id,l.Account__c);
                         }
                        for(Event e:newEventList){
                       if(e.whoId != null &&e.whoId.getSobjectType() == Schema.Lead.sObjectType){
                            AccountLeadActivity__c acctLeadActivity=new AccountLeadActivity__c();
                            acctLeadActivity.Call_Type__c = e.Activity_Category__c;
                            acctLeadActivity.due_date__c= e.StartDateTime;
                            acctLeadActivity.Status__c= e.Status__c;
                            system.debug('*****e.whatid'+e.whatid);
                            system.debug('*****acctLeadActivity.Related_To_Account__c '+acctLeadActivity.Related_To_Account__c);                    
                            acctLeadActivity.Related_To_Account__c = leadAccountMap.get(e.whoId);                    
                            acctLeadActivity.Subject__c = e.Subject;
                            acctLeadActivity.Lead__c= e.whoId;
                            acctLeadActivity.TaskId__c= e.id;
                            acctLeadActivity.Comments__c= e.description;
                            acctLeadActivity.type__c= e.LCRM_Activity_Type__c;
                            acctLeadActivity.Activity_owner__c= e.ownerId;
                            acctLeadActivity.owner_group__c= e.owner_group__c;
                            system.debug(acctLeadActivity);
                            alcListInsert.add(acctLeadActivity);   
                        }
                     }
                    system.debug('****alcListInsert' + alcListInsert);
                    try{
                        if(alcListInsert != null && alcListInsert.size()>0)
                        insert alcListInsert;
                    } catch(Exception ex){
                          ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMEssage())); 
                        }
                    }
                    
                }
            }
            if(isUpdate){
                system.debug('****Inside the Update operation********' ); 
                Map<string,AccountLeadActivity__c> EventAcctLeadActMap= new Map<string,AccountLeadActivity__c>();
                List<AccountLeadActivity__c>  alcListUpdate = new List<AccountLeadActivity__c>();
                List<AccountLeadActivity__c> acctLeadActivitiesForUpdate=
                                    [SELECT Call_Type__c,due_date__c,Status__c,Related_To_Account__c,Subject__c,Lead__c,TaskId__c FROM AccountLeadActivity__c 
                                     WHERE TaskId__c IN:newMap.keyset()];
               system.debug('****acctLeadActivitiesForUpdate:: ' + acctLeadActivitiesForUpdate);
               
                if(!acctLeadActivitiesForUpdate.isEmpty()){
                  for(AccountLeadActivity__c ala : acctLeadActivitiesForUpdate){
                        ala.Call_Type__c = newMap.get(ala.TaskId__c).Activity_Category__c;
                        ala.due_date__c= newMap.get(ala.TaskId__c).StartDateTime; 
                        ala.Subject__c = newMap.get(ala.TaskId__c).Subject; 
                        ala.Status__c= newMap.get(ala.TaskId__c).Status__c ;
                        ala.Comments__c= newMap.get(ala.TaskId__c).Description; 
                        ala.Type__c= newMap.get(ala.TaskId__c).LCRM_Activity_Type__c;                
                        ala.Activity_owner__c= newMap.get(ala.TaskId__c).ownerId;
                        ala.owner_group__c= newMap.get(ala.TaskId__c).owner_group__c; 
                        alcListUpdate.add(ala);  
                    }
                    for(AccountLeadActivity__c ala: acctLeadActivitiesForUpdate){
                        EventAcctLeadActMap.put(ala.TaskId__c,ala);
                    } 
                    try{
                         if(alcListUpdate!= null && alcListUpdate.size() >0)
                         update alcListUpdate;
                    } catch(Exception ex){
                         ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMEssage())); 
                    }
                }  
            }
        }  
    
    }
     //End:Added for CRM-7710 to display  Lead Events on Account under AccountLeadActivites

    
    
    public static void updateEventOwnerGroup(List<Event> listEvent){
       Map<Event,Id> mapEventOwnerId = new Map<Event,Id>();
       Map<Event,String> mapEventMarketSegment = new Map<Event,String>();
      
       
       for(Event oEvent : listEvent){
           if(!mapEventOwnerId.containsKey(oEvent)){
             mapEventOwnerId.put(oEvent,oEvent.ownerId);
           }
       }
       
       Map<Id,User> mapUser =new Map<Id,User>([Select Sales_Force_Description__c,Market_Segment_Description__c from User where ID IN : mapEventOwnerId.values()]);
       
       for(Event oEvent : mapEventOwnerId.KeySet()){
           if(!mapEventMarketSegment.containskey(oEvent)){
             if(mapUser.get(oEvent.OwnerId).Market_Segment_Description__c!=null && mapUser.get(oEvent.OwnerId).Market_Segment_Description__c!=''
                     && mapUser.get(oEvent.OwnerId).Sales_Force_Description__c!=null
                     && mapUser.get(oEvent.OwnerId).Sales_Force_Description__c!=''){
                 String MarketSegmentName = '';
                 MarketSegmentName = mapUser.get(oEvent.OwnerId).Market_Segment_Description__c.trim() + '-'+mapUser.get(oEvent.OwnerId).Sales_Force_Description__c;
                 system.debug('LCRM_MarketSegmentName**'+Integer.valueof(label.LCRM_MarketSegmentName));
                 system.debug('**MarketSegmentName.length()**'+MarketSegmentName.length());
                 if(MarketSegmentName.length()<= Integer.valueof(label.LCRM_MarketSegmentName)){
                     mapEventMarketSegment.put(oEvent,MarketSegmentName);                     
                 }
             
             }else{
                 mapEventMarketSegment.put(oEvent,'');                 
             }
           }
       }
       
       for(Event oEvent: mapEventMarketSegment.keySet()){

           if(mapEventMarketSegment.containskey(oEvent) && OwnerGroup__c.getinstance(mapEventMarketSegment.get(oEvent))!=null){
               OwnerGroup__c oOwnerGroup = OwnerGroup__c.getinstance(mapEventMarketSegment.get(oEvent));
               
               oEvent.Owner_Group__c = oOwnerGroup.Channel__c;
           }
           else{
                          
               oEvent.Owner_Group__c = 'Other';
           }
           
       }
   
    }
}