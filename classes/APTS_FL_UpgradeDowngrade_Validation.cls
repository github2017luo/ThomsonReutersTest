public class APTS_FL_UpgradeDowngrade_Validation {

public static Apttus_Config2.CustomClass.ValidationResult validateUpgradeDowngradeError(List<Apttus_Config2__LineItem__c> lineItemsList,List<Apttus_Config2__AssetLineItem__c> assetLineItemsList) {

     Apttus_Config2.CustomClass.ValidationResult result= new Apttus_Config2.CustomClass.ValidationResult(true); 
     Set<id> productIdSet=new Set<id>();
     Set<id> assetLineItemProductsSet=new Set<id>();     
     Map<Id,Set<Id>> productsWithProductGroupMap=new Map<Id,Set<Id>>();
     Map<Id,Set<String>> lineItemsProductswithStatus=new Map<id,Set<String>>();
     Map<Id,List<String>> lineItemsProductswithCancelledStatus=new Map<id,List<String>>();
     Map<Id,List<String>> assetProductswithCancelledStatus=new Map<id,List<String>>();
     Map<Id,String> productIdwithNameMap=new Map<Id,String>();
     
     for(Apttus_Config2__LineItem__c lineItem:lineItemsList){
        Set<String> statusList;
        List<String> cancelledList;
        if(lineItem.Apttus_Config2__ProductId__r.APTS_Upgrade_Downgrade_Eligible__c && lineItem.Apttus_Config2__LineStatus__c=='New')
           productIdSet.add(lineItem.Apttus_Config2__ProductId__c);
        if(lineItemsProductswithStatus.containsKey(lineItem.Apttus_Config2__ProductId__c)){
           statusList=lineItemsProductswithStatus.get(lineItem.Apttus_Config2__ProductId__c);
           statusList.add(lineItem.Apttus_Config2__LineStatus__c);
         }else{
           statusList=new Set<String>();
           statusList.add(lineItem.Apttus_Config2__LineStatus__c);
         }
         if(lineItem.Apttus_Config2__LineStatus__c=='Cancelled'){
           if(lineItemsProductswithCancelledStatus.containsKey(lineItem.Apttus_Config2__ProductId__c)){
             cancelledList=lineItemsProductswithCancelledStatus.get(lineItem.Apttus_Config2__ProductId__c);
             cancelledList.add(lineItem.Apttus_Config2__LineStatus__c);
           }else{
             cancelledList=new List<String>();
             cancelledList.add(lineItem.Apttus_Config2__LineStatus__c);             
           }
           lineItemsProductswithCancelledStatus.put(lineItem.Apttus_Config2__ProductId__c,cancelledList);
         }
         lineItemsProductswithStatus.put(lineItem.Apttus_Config2__ProductId__c,statusList);
     }
     system.debug('lineItemsProductswithStatus--'+lineItemsProductswithStatus);
     system.debug('lineItemsProductswithCancelledStatus--'+lineItemsProductswithCancelledStatus);
     for(Apttus_Config2__AssetLineItem__c assetLineItem:assetLineItemsList){
       if(assetLineItem.Apttus_Config2__AssetStatus__c!='Pending Cancellation'){
           List<String> cancelledList;
           //if(!(lineItemsProductswithStatus.containsKey(assetLineItem.Apttus_Config2__ProductId__c) && lineItemsProductswithStatus.get(assetLineItem.Apttus_Config2__ProductId__c).contains('Cancelled')))
           assetLineItemProductsSet.add(assetLineItem.Apttus_Config2__ProductId__c);
           if(assetProductswithCancelledStatus.containsKey(assetLineItem.Apttus_Config2__ProductId__c)){
             cancelledList=assetProductswithCancelledStatus.get(assetLineItem.Apttus_Config2__ProductId__c);
             cancelledList.add(assetLineItem.Apttus_Config2__AssetStatus__c);
           }else{
             cancelledList=new List<String>();
             cancelledList.add(assetLineItem.Apttus_Config2__AssetStatus__c);             
           }
           assetProductswithCancelledStatus.put(assetLineItem.Apttus_Config2__ProductId__c,cancelledList);
       }
     }
     system.debug('assetLineItemProductsSet--'+assetLineItemProductsSet);
     system.debug('assetProductswithCancelledStatus--'+assetProductswithCancelledStatus);
     for(Id productId:lineItemsProductswithCancelledStatus.keySet()){
        if(assetProductswithCancelledStatus.containsKey(productId)){
           if(lineItemsProductswithCancelledStatus.get(productId).size()==assetProductswithCancelledStatus.get(productId).size())
             assetLineItemProductsSet.remove(productId);
        }
     }
     for(APTS_Mutually_Exclusive_Rule__c exclusionRule:[select name,APTS_Mutually_Exclusive_Product__c,APTS_Product__c,APTS_Mutually_Exclusive_Product__r.name,APTS_Product__r.name from APTS_Mutually_Exclusive_Rule__c where APTS_Product__c IN :productIdSet AND APTS_Active__c=true]){
         Set<id> productGroup;
         productIdwithNameMap.put(exclusionRule.APTS_Mutually_Exclusive_Product__c,exclusionRule.APTS_Mutually_Exclusive_Product__r.name);
         if(!productIdwithNameMap.containsKey(exclusionRule.APTS_Product__c))
            productIdwithNameMap.put(exclusionRule.APTS_Product__c,exclusionRule.APTS_Product__r.name);
         if(productsWithProductGroupMap.containsKey(exclusionRule.APTS_Product__c )){
           productGroup=productsWithProductGroupMap.get(exclusionRule.APTS_Product__c);
           productGroup.add(exclusionRule.APTS_Mutually_Exclusive_Product__c);
         }else{
           productGroup=new Set<id>();
           productGroup.add(exclusionRule.APTS_Mutually_Exclusive_Product__c);
         }
         productsWithProductGroupMap.put(exclusionRule.APTS_Product__c,productGroup);
     }
      for(Id baseProduct:productsWithProductGroupMap.keySet()){
          Set<id> productGroup;
          if(lineItemsProductswithStatus.containsKey(baseProduct)){
               productGroup=productsWithProductGroupMap.get(baseProduct);
               for(Id productId:productGroup){
                  Set<String> statusList;
                  if(lineItemsProductswithStatus.containsKey(productId)){
                     statusList=lineItemsProductswithStatus.get(productId);
                     if(statusList.size()>1 && statusList.contains('Cancelled')){
                       result.Messages.add(new ApexPages.Message(ApexPages.Severity.Error,'\''+productIdwithNameMap.get(baseProduct)+ '\' is mutually exclusive with products in your cart and/or current subscriptions \''+ productIdwithNameMap.get(productId)+'\'. Please lapse/remove any conflicting products if you wish to move forward with the items in your cart.'));
                       result.isSuccess = false;                  
                       return result; 
                     }else if(statusList.size()==1 && !statusList.contains('Cancelled')){
                       result.Messages.add(new ApexPages.Message(ApexPages.Severity.Error,'\''+productIdwithNameMap.get(baseProduct)+ '\' is mutually exclusive with products in your cart and/or current subscriptions \''+ productIdwithNameMap.get(productId)+'\'. Please lapse/remove any conflicting products if you wish to move forward with the items in your cart.'));
                       result.isSuccess = false;                  
                       return result; 
                     }
                  }
                  if(assetLineItemProductsSet.contains(productId)){
                    result.Messages.add(new ApexPages.Message(ApexPages.Severity.Error,'\''+productIdwithNameMap.get(baseProduct)+ '\' is mutually exclusive with products in your cart and/or current subscriptions \''+ productIdwithNameMap.get(productId)+'\'. Please lapse/remove any conflicting products if you wish to move forward with the items in your cart.'));
                    result.isSuccess = false;                  
                    return result; 
                  }
              }
          }          
      }
     return result;
     
}


}