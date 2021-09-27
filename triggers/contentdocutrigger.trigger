/*
* JIRA Details: DPS-18603: No Deleting Docs on Opportunities Stage 95% or 100%
* CHANGE HISTORY
* =============================================================================
* Date         Name                    Description
* 2020-10-29   Miriam Ghosh            Created     
* =============================================================================
*/

trigger contentdocutrigger on ContentDocument(after insert,before delete, before update) 
{

    //Prevent Deletion of File and Notes if Opportunity stage is 0, 95 or 100%
    ContentDocuDelRestrictionHandler.onBeforeDeleteContentDocu(Trigger.isDelete, Trigger.oldMap);  
    
    //Before update - Prevent updation of File and Notes if Opportunity stage is 0, 95 or 100%
    ContentDocuDelRestrictionHandler.onBeforeUpdateContentDocu(Trigger.isBefore, Trigger.isUpdate, Trigger.newMap);
    
    //After Insert -- If document is added to Archived Account then  Unarchive Account.   
    LCRMGenericComponent.onAfterInsertContentDocument(Trigger.isAfter, Trigger.isInsert,Trigger.NewMap);
}