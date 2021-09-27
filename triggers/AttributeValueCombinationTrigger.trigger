/*==========================================================================================================
    Purpose: To populate lookup to text on Attirbute Value Combination object - To Avoid Selecting Query - TRIGGER.
    
    Change History: created
    
    Developer : Shailesh Patel 

    Modification History: NA
    
===============================================================================================================*/

trigger AttributeValueCombinationTrigger on APTS_Attribute_Value_Combination__c (before insert, before update) {
    
    // Before trigger logic
    if (Trigger.IsBefore )
    {
        //Before Insert
        if (Trigger.IsInsert){
            AttributeValueCombTrigHandler.BeforeInsert(trigger.new);
        }

        //Before Update
        if (Trigger.IsUpdate){
            AttributeValueCombTrigHandler.BeforeUpdate(trigger.newMap, trigger.oldMap);
        }

    }
    
}