public with sharing class opportunityProductDetailTriggerHandler{
    public class MyException extends Exception {}
  
    public static void checkQuantities(Set<String> itemIds){
        List<OpportunityProductDetail__c> details= [
            Select Opportunity_Line_Item_Id__c
            From OpportunityProductDetail__c 
            Where Opportunity_Line_Item_Id__c IN :itemIds
          ];
        
        List<OpportunityLineItem> itemsToUpdate = new List<OpportunityLineItem>();
        Map<String, Integer> quantities = new Map<String, Integer>();
        
        for(OpportunityProductDetail__c detail: details){
            //if(detail.Opportunity_Line_Item_Id__c != '' && detail.Opportunity_Line_Item_Id__c != null){
              if(itemIds.contains(detail.Opportunity_Line_Item_Id__c) ){
                if(quantities.containsKey(detail.Opportunity_Line_Item_Id__c)){
                  Integer q = quantities.get(detail.Opportunity_Line_Item_Id__c);
                  q++;
                  quantities.put(detail.Opportunity_Line_Item_Id__c, q);
                }else{
                  quantities.put(detail.Opportunity_Line_Item_Id__c, 1);
                }
              }
            //}  
        }
        
    for(String key : quantities.keySet()){
      
      OpportunityLineItem item = new OpportunityLineItem(ID=key);
      item.Quantity_Detail__c = quantities.get(key);
      itemsToUpdate.add(item);
      
      if(itemsToUpdate.size() == 200){
       
        update itemsToUpdate;
        itemsToUpdate.clear();
      }
    }
    
    if(itemsToUpdate.size() > 0){
     try{
         update itemsToUpdate;
      }
     catch(exception e){
     }
      itemsToUpdate.clear();
    }
  } 
    
    //IM02026011 - LatAm Ticket 
    public static void updatePrimaryQuote(List<OpportunityProductDetail__c> newopdLst){        
        
        Set<Id> OppIdSET= new Set<Id>();
        Map<id,id> OppIdPrimaryQuoteIdMap=new Map<id,id>();
        for(OpportunityProductDetail__c opd: newopdLst){
            OppIdSET.add(opd.Opportunity__c);
        }
        
        List<Quote> quoteLst= [SELECT id,OpportunityId,Primary_Quote__c FROM QUOTE WHERE OpportunityId IN:OppIdSET and primary_Quote__C= true ];
        if(!quoteLst.isEmpty()){
            for(Quote q: quoteLst){
                OppIdPrimaryQuoteIdMap.put(q.OpportunityId,q.id);
            }
        }
        
        if(!newopdLst.isEmpty()){
            for(OpportunityProductDetail__c opd: newopdLst){
                if(OppIdPrimaryQuoteIdMap!= null){
                    opd.Primary_Quote__c =  OppIdPrimaryQuoteIdMap.get(opd.Opportunity__c); 
                    system.debug('****OppIdPrimaryQuoteIdMap::'+OppIdPrimaryQuoteIdMap);
                }
            }
        }
    }  
    
 public static void updSalesTotalPrice(Set<String> itemIds){
        Map<String, Decimal> mapOLITotalSalesPrice = new Map<String, Decimal>();
        for(OpportunityLineItem oOppLineItem : [select id, TotalPrice from OpportunityLineItem where ID IN:itemIds]){
           // mapOLITotalSalesPrice.put(String.valueOf(oOppLineItem.Id).substring(0, 15), oOppLineItem.TotalPrice);
           mapOLITotalSalesPrice.put(String.valueOf(oOppLineItem.Id), oOppLineItem.TotalPrice);
         }    
        system.debug('$$$mapOLITotalSalesPrice'+mapOLITotalSalesPrice);  
        List<OpportunityProductDetail__c> opdList = new List<OpportunityProductDetail__c>();
        if(!mapOLITotalSalesPrice.isEmpty()){
            opdList = [select id, Sales_Total_Price__c, Opportunity_Line_Item_Id__c from OpportunityProductDetail__c where Opportunity_Line_Item_Id__c IN:mapOLITotalSalesPrice.keyset()];
        }
        system.debug('$$$opdList '+opdList );
        List<OpportunityProductDetail__c> opdListUpd = new List<OpportunityProductDetail__c>();
        if(opdList != null){
            for(OpportunityProductDetail__c opdRec: opdList ){
                opdRec.Sales_Total_Price__c = mapOLITotalSalesPrice.get(opdRec.Opportunity_Line_Item_Id__c);  
                opdListUpd.add(opdRec);
            }
        }
        
        if(opdListUpd.size() > 0){
            update opdListUpd;
        }       
    
    } 
    
}