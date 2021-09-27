trigger QuoteLineItemTrigger on QuoteLineItem (after insert,After Update,before insert, before update) {
    System.debug('****newMapq1'+ trigger.new);
    System.debug('****oldMapq1'+ trigger.old);
    Boolean RenewalChck = false;
    System.debug('****newMapq2'+ trigger.new);
    System.debug('****oldMapq2'+ trigger.old);
    //if(trigger.newMap != NULL && !trigger.newMap.isEmpty()){
         for(QuoteLineItem qli : trigger.new){
                 if(qli.RenewalCheckQLI__c )
                      RenewalChck = true;
                 else
                      RenewalChck = false;        
             }
  //    }
   
    if(Trigger.isInsert && trigger.isAfter){
        if(RenewalChck == false){
            QuoteLineItemTriggerHandler.MapValuesOfQuoteLineItem(trigger.new);
            System.debug('****newMapq3'+ trigger.new);
            System.debug('****oldMapq3'+ trigger.old);
        }
        if(RenewalChck == true){
            QuoteLineItemTriggerHandler.RenewalQLISyncOnInsert(trigger.newmap, trigger.new); //Added as part of Renewals [Rajashree]
            System.debug('****newMapq4'+ trigger.new);
            System.debug('****oldMapq4'+ trigger.old);
        }
        //QuoteLineItemTriggerHandler.getCurrencydecimalPlaces(trigger.new);// Moved to After for SFD-512
        
    }
    
    //Added 27-2-2016 to update currency decimal places
    if(trigger.isinsert && trigger.IsBefore){   //modified to after SFD-512   
        //QuoteLineItemTriggerHandler.getCurrencydecimalPlaces(trigger.new);//SFD-49
        System.debug('######## RenewalChck'+RenewalChck);
        if(RenewalChck == true){
            QuoteLineItemTriggerHandler.getCurrencydecimalPlaces(trigger.new,false);//SFD-1068
        }
        if(RenewalChck == False){
            QuoteLineItemTriggerHandler.SyncQuoteLIValueFromOppLIonInsert(trigger.new);
        }
        System.debug('****newMapq5'+ trigger.new);
        System.debug('****oldMapq5'+ trigger.old);
    }
    if(trigger.isUpdate && trigger.Isbefore){        
        List<QuoteLineItem> qliLst= new List<QuoteLineItem>();
        for(QuoteLineItem qli: trigger.new){
            if(qli.Decimal_Places_for_Currency__C == null){
                qliLst.add(qli);
            }
            system.debug('***qliLst' +qliLst);
        }
        if(qliLst!= null && qliLst.size() >0){
            //if(RenewalChck == false){
                QuoteLineItemTriggerHandler.getCurrencydecimalPlaces(trigger.new,false);//SFD-49
                System.debug('****newMapq6'+ trigger.new);
                System.debug('****oldMapq6'+ trigger.old);
            //}
        }
    }
    //Ends here
    
    If(trigger.isAfter && trigger.isUpdate && !checkRecursive.hasAlreadyRunBeforeUpdateQuote() && 
     !OpportunityLineItemTriggerHandler.syncOpptytoQuote_methodcalled && !QuoteLineItemTriggerHandler.syncQuotetoOppty_methodcalled){
        checkRecursive.setAlreadyRunBeforeUpdateQuote();
        if(RenewalChck == false){
            QuoteLineItemTriggerHandler.SyncQuoteLIValueToOppLI(trigger.new,trigger.oldmap);
            System.debug('****newMapq7'+ trigger.new);
            System.debug('****oldMapq7'+ trigger.old);
        }
    }
    if(trigger.isUpdate && trigger.IsBefore){
      //  QuoteLineItemTriggerHandler.QuoteLineItemLock(trigger.new, trigger.old);
    }
    if(trigger.isUpdate && trigger.isAfter){
         
        //Start For Renewals-Satyaki
       //if(checkRecursive.runRenewalQLISyncOnce()) {
           System.debug('Step 1########## RenewalChck'+RenewalChck );
           if(RenewalChck == true){
              QuoteLineItemTriggerHandler.RenewalQLISync(trigger.newMap,trigger.oldmap);
              System.debug('****newMapq8'+ trigger.new);
              System.debug('****oldMapq8'+ trigger.old);
           }
       //}
        //End For Renewals-Satyaki  
    }
}