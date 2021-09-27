trigger APTS_ProposalProductAttributeValueTrigger on Apttus_QPConfig__ProposalProductAttributeValue__c (Before Insert, After Insert, Before Update, After Update) {
    
    APTS_ProposalAttrValTriggerHandler triggerHandler = new APTS_ProposalAttrValTriggerHandler();
    if(Trigger.isInsert && Trigger.isAfter){
        triggerHandler.onAfterInsert(Trigger.New);
    }
}