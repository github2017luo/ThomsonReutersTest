trigger triggerOpportunityProductDetail on OpportunityProductDetail__c (after delete, after update, after insert, after undelete) {
    Set<String> itemsToProcess = new Set<String>();
    Set<String> oliIdSet = new Set<String>();
    
    if(trigger.isDelete){
        for(OpportunityProductDetail__c detail: trigger.old){
            itemsToProcess.add(detail.Opportunity_Line_Item_Id__c);
        }
    }else{
        for(OpportunityProductDetail__c detail: trigger.new){
            itemsToProcess.add(detail.Opportunity_Line_Item_Id__c);
        }
    }
    
    if(itemsToProcess.size() > 0){
        opportunityProductDetailTriggerHandler.checkQuantities(itemsToProcess);
    }
    
    if(trigger.isInsert){
      for(OpportunityProductDetail__c opdRec: trigger.new){
            oliIdSet.add(opdRec.Opportunity_Line_Item_Id__c);
        } 
      if(oliIdSet != null){
        opportunityProductDetailTriggerHandler.updSalesTotalPrice(oliIdSet);
      }     
    
    }
}