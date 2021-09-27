/*
 * CHANGE HISTORY
 * ===============================================================================
 * Date                Name                         Description
 * 2017-10-13     Harika Devi Kalidindi       Sharing Training Event record with training Event Team.Created as a part of CRM - 6180
 * 2017-10-30     Harika Devi Kalidindi       Sending Notification to training event Team member CRM - 11010
 * ===============================================================================
 */
trigger TrainingEventShare on Training_Event_Team__c (before delete,after insert,before update)
{ 
    if(trigger.isAfter && trigger.isInsert)
    {
          TrainingEventsUtil.afterInsertTrainingTeam(Trigger.new);
    }

    if(trigger.isUpdate && trigger.isBefore)
    {
        TrainingEventsUtil.beforeupdateTrainingTeam(Trigger.new,Trigger.old);
    }
    
    if(trigger.isDelete && trigger.isBefore)
    {
        TrainingEventsUtil.beforedeleteteteam(Trigger.old);
    }

}