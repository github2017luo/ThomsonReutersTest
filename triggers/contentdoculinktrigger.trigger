/**
* JIRA Details: DPS-18603: No Deleting Docs on Opportunities Stage 95% or 100%
* CHANGE HISTORY
* =============================================================================
* Date         Name                    Description
* 2020-10-28   Miriam Ghosh            Created     
* =============================================================================
*/

trigger contentdoculinktrigger on ContentDocumentLink (after insert,before delete) 
{
    //Commented to remove PMD violation- Avoid logic in triggers (rule: Best Practices-AvoidLogicInTrigger)
    //if(Trigger.isBefore && Trigger.isDelete){}
      ContentDocuDelRestrictionHandler.onBeforeDeleteContentDocuLink(Trigger.isDelete, Trigger.oldMap);
      
    //After Insert -- If document is added to Archived Account then  Unarchive Account.   
    LCRMGenericComponent.onAfterInsertContentDocuLink(Trigger.isAfter, Trigger.isInsert,Trigger.NewMap);


}