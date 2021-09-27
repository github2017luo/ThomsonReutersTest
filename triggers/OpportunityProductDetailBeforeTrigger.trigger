trigger OpportunityProductDetailBeforeTrigger on OpportunityProductDetail__c (before insert) {
    
    //IM02026011 - LatAm Ticket
    if(trigger.isInsert && trigger.isBefore){
        opportunityProductDetailTriggerHandler.updatePrimaryQuote(trigger.new);    
    }
}