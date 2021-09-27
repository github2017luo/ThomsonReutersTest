trigger OrderAfterEventListener on Order__c (after insert, after update){
    List<Id> listQuoteIds = new List<Id>();
    if(trigger.isInsert){
        for(Order__c oOrder : Trigger.new){
            listQuoteIds.add(oOrder.Quote__c);
        }
    }
    if(trigger.isUpdate){
        for(Order__c oOrder : Trigger.new){
            if(oOrder.Order_Status__c != trigger.oldMap.get(oOrder.Id).Order_Status__c)
                listQuoteIds.add(oOrder.Quote__c);
        }
    }
    if(!listQuoteIds.isEmpty()){
        OrderHandler.updateOpportunity(listQuoteIds);
    }    
    
}