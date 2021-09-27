trigger OpportunityLineItemAfterEventListener on OpportunityLineItem (after insert, after update, after delete) {

//LTS_6300 : Exclusion framework
      System.debug('LTS_ApplicationAutomationUtility.checkTriggerApplicability()** '+LTS_ApplicationAutomationUtility.checkTriggerApplicability());
      If(LTS_ApplicationAutomationUtility.checkTriggerApplicability())
      {return;}


 /* Adding the below method to put a check on the below methods, if they should be called for Renewals and masterSafRenewals or not [Rajashree] */
   Boolean RenewalChck = false;
   System.debug('****newMap'+ trigger.new);
   System.debug('****oldMap'+ trigger.old);
   if(Boolean.valueOf(System.Label.LCRMGLIOpportunityLoadTriggerFlag) == False){   //Added for CRM-14346
        if(trigger.newMap != NULL && !trigger.newMap.isEmpty()){
                   for(OpportunityLineItem oli : trigger.new){
                       if(oli.RenewalCheck__c) 
                          RenewalChck = true;
                       else
                          RenewalChck = false;        
                 }
        }
       
        if(trigger.isDelete){
            OpportunityLineItemTriggerHandler.deleteOppProdDetails(trigger.old);
            System.debug('****newMap1'+ trigger.new);
           System.debug('****oldMap1'+ trigger.old);
            if(RenewalChck == false){
                OpportunityLineItemTriggerHandler.updateOppRenewal_IncrAmounts(trigger.oldMap,null);
                System.debug('****newMap2'+ trigger.new);
           System.debug('****oldMap2'+ trigger.old);
            }
            //CRM-81: start
            System.debug('delete : syncOLIToOLIClone : '+OpportunityLineItemTriggerHandler.checkRecur_syncOLIToOLIClone);
            //if(OpportunityLineItemTriggerHandler.checkRecur_syncOLIToOLIClone == false){
                OpportunityLineItemTriggerHandler.syncOLIToOLIClone('delete',Trigger.OldMap.keySet());
            //    OpportunityLineItemTriggerHandler.checkRecur_syncOLIToOLIClone = true;
            //}
            //CRM-81: end
        }
        else if(trigger.isInsert){
            OpportunityLineItemTriggerHandler.isInsert  = true;
           // if(RenewalChck == FALSE){
                OpportunityLineItemTriggerHandler.SyncOppLIValueFromQuoteLIonInsert(trigger.new);//SFD-831 ,[Rajashree] Restricting this for Renewals
           // }
            if(!OpportunityLineItemTriggerHandler.updateRenewal_IncrAmounts_methodCalled){
                list<OpportunityLineItem> liOLI = new list<OpportunityLineItem>();
                for(OpportunityLineItem oOLI : trigger.new){
                    liOLI.add(oOLI);
                }

                //update opportunity products' renewal/Incremental amounts with total price
                if(RenewalChck == false){
                    OpportunityLineItemTriggerHandler.updateRenewal_IncrAmounts(trigger.newMap.keySet());
                    System.debug('****newMap3'+ trigger.new);
                   System.debug('****oldMap3'+ trigger.old); 
                    OpportunityLineItemTriggerHandler.updateOppRenewal_IncrAmounts(trigger.newMap, null);
                    System.debug('****newMap4'+ trigger.new);
                   System.debug('****oldMap4'+ trigger.old);
                }
                if(RenewalChck == true){
                   OpportunityLineItemTriggerHandler.RenewalOLISyncOnInsert(trigger.newMap, trigger.new);  // [Rajashree] Added as part of Renewals Sync           
                    System.debug('****newMap5'+ trigger.new);
                   System.debug('****oldMap5'+ trigger.old);
                }
                //update opportunity renewal/Incremental amounts with opplineitem renewal/Incremental amounts
                
               // OpportunityLineItemTriggerHandler.getCurrencydecimalPlaces(trigger.new);//SFD-49 moved to after from before SFD-512
            }
            //CRM-81: start
            System.debug('insert : syncOLIToOLIClone : '+OpportunityLineItemTriggerHandler.checkRecur_syncOLIToOLIClone);
            //if(OpportunityLineItemTriggerHandler.checkRecur_syncOLIToOLIClone == false){
                OpportunityLineItemTriggerHandler.syncOLIToOLIClone('insert',Trigger.NewMap.keySet());
                OpportunityLineItemTriggerHandler.checkRecur_syncOLIToOLIClone = true;
            //}
            //CRM-81: end
        }
        else if(trigger.isUpdate){
           //if(checkRecursive.runRenewalOLISyncOnce()){       
               OpportunityLineItemTriggerHandler.afterUpdateProductsSync(trigger.newMap,trigger.oldMap);
               System.debug('****newMap6'+ trigger.new);
               System.debug('****oldMap6'+ trigger.old);
           //}
           //if(checkRecursive.runRenewalOLISyncOnce()){
               if(RenewalChck == true){
                   System.debug('****newMap7 v1'+ trigger.new);
                   System.debug('****oldMap7 v1'+ trigger.old);
                   OpportunityLineItemTriggerHandler.afterUpdateRenewalProductsSync(trigger.newMap,trigger.oldMap); // [Rajashree] Added as part of Renewals Sync
                   System.debug('****newMap7'+ trigger.new);
                   System.debug('****oldMap7'+ trigger.old);
               }
            //}
           OpportunityLineItemTriggerHandler.isInsert  = false;
            Map<Id, OpportunityLineItem> mapOppLineItems = new Map<Id, OpportunityLineItem>();
            
            for(OpportunityLineItem oOppLineItem : trigger.new){
                if(oOppLineItem.Renewal_Amount__c != trigger.oldMap.get(oOppLineItem.Id).Renewal_Amount__c
                 ||oOppLineItem.Incremental_Amount__c != trigger.oldMap.get(oOppLineItem.Id).Incremental_Amount__c
                 ||oOppLineItem.Revenue_Type__c != trigger.oldMap.get(oOppLineItem.Id).Revenue_Type__c
                 ||oOppLineItem.TotalPrice != trigger.oldMap.get(oOppLineItem.Id).TotalPrice){
                     mapOppLineItems.put(oOppLineItem.Id, oOppLineItem);
                 }
            }
            //Below method won't be invoked for Renewals
            if(!mapOppLineItems.Values().isEmpty()){
                if(!OpportunityLineItemTriggerHandler.updateRenewal_IncrAmounts_methodCalled){
                    //update opportunity products' renewal/Incremental amounts with total price
                   if(RenewalChck == false){
                        OpportunityLineItemTriggerHandler.updateRenewal_IncrAmounts(mapOppLineItems.keySet());
                         System.debug('****newMap8'+ trigger.new);
                           System.debug('****oldMap8'+ trigger.old);
                         OpportunityLineItemTriggerHandler.updateOppRenewal_IncrAmounts(mapOppLineItems, null);
                    System.debug('****newMap9'+ trigger.new);
                   System.debug('****oldMap9'+ trigger.old);
                    }
                   
                }
                
            }
            //CRM-81: start
            System.debug('update : syncOLIToOLIClone : '+OpportunityLineItemTriggerHandler.checkRecur_syncOLIToOLIClone);
            if(OpportunityLineItemTriggerHandler.checkRecur_syncOLIToOLIClone == false){
                Set<ID> newOLIs = new Set<ID>();
                for(OpportunityLineItem oliNew : Trigger.New){
                    OpportunityLineItem oliOld = Trigger.OldMap.get(oliNew.ID);
                    if(oliNew.LCRM_Action__c != oliOld.LCRM_Action__c || 
                       oliNew.LCRM_Current_ACV__c != oliOld.LCRM_Current_ACV__c ||
                       oliNew.LCRM_New_ACV_SalesPrice__c != oliOld.LCRM_New_ACV_SalesPrice__c ||
                       oliNew.LCRM_Product_Segment__c != oliOld.LCRM_Product_Segment__c){
                        newOLIs.add(oliNew.ID);
                    }
                }
                OpportunityLineItemTriggerHandler.syncOLIToOLIClone('update',newOLIs);
                OpportunityLineItemTriggerHandler.checkRecur_syncOLIToOLIClone = true;
            }
            //CRM-81: end
            
             // Changes as part of FSC-136           
            Map<String, Decimal> mapOLITotalSalesPrice = new Map<String, Decimal>();
            for(OpportunityLineItem oOppLineItem : trigger.new){
                if(oOppLineItem.TotalPrice != trigger.oldMap.get(oOppLineItem.Id).TotalPrice){
                   //  mapOLITotalSalesPrice.put(String.valueOf(oOppLineItem.Id).substring(0, 15), oOppLineItem.TotalPrice);
                   mapOLITotalSalesPrice.put(String.valueOf(oOppLineItem.Id), oOppLineItem.TotalPrice);
                 }
            }
            if(!mapOLITotalSalesPrice.isEmpty()){
                OpportunityLineItemTriggerHandler.updateTotalPriceOnOptyProdDtl(mapOLITotalSalesPrice); 
            }      
            
        }
        
        If(Trigger.isUpdate && Trigger.isAfter && !checkRecursive.hasAlreadyRunBeforeUpdateOppLI() &&
         !OpportunityLineItemTriggerHandler.syncOpptytoQuote_methodcalled && !QuoteLineItemTriggerHandler.syncQuotetoOppty_methodcalled
         ){
            checkRecursive.setAlreadyRunBeforeUpdateOppLI();
            if(RenewalChck == false){
                OpportunityLineItemTriggerHandler.SyncOppLineItemToQuoteLineItem(trigger.new, trigger.OldMap);
                System.debug('****newMap10'+ trigger.new);
               System.debug('****oldMap10'+ trigger.old);
            }
        }
    }
}