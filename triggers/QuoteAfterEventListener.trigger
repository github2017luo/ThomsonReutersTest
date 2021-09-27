/**
 * This trigger will handle the after events on the quote.
 *
 * @author  Srikanth Kuruva
 * @version  2013-09-01

 * CHANGE HISTORY
 * =============================================================================
 * Date         Name                    Description
 * 2013-09-01   Srikanth Kuruva          Created
 * 2016-07-20   Satyaki                  Added RenewalQuoteSync
 * 2017-03-31   Karthi                  Optimized the code as per JIRA STORY: PS0-1
 * =============================================================================
 */
trigger QuoteAfterEventListener on Quote (after insert, after update,after delete) {

//LTS_6300 : Exclusion framework
      System.debug('LTS_ApplicationAutomationUtility.checkTriggerApplicability()** '+LTS_ApplicationAutomationUtility.checkTriggerApplicability());
      If(LTS_ApplicationAutomationUtility.checkTriggerApplicability())
      {return;}
      
     Boolean blnRenewalChck = false;
     Boolean blnremoveRenewalChck = false;
     Boolean syncBoolean = false; // MCL-2126
     Id remRenRecordTypeId = Schema.SObjectType.Quote.getRecordTypeInfosByName().get('LATAM Remove Renewal Quote').getRecordTypeId();
        
     if(trigger.new != null && !trigger.new.isEmpty()){
         for(Quote quo : trigger.new){
             if(quo.Renewal_Flag_Formula__c == true && RecordtypeIds__c.getInstance('LATAM Renewal Quote') != NULL && quo.RecordTypeId== RecordtypeIds__c.getInstance('LATAM Renewal Quote').recTypeId__c )
                  blnRenewalChck = true;
             else
                  blnRenewalChck = false; 
             if(quo.RecordTypeId == remRenRecordTypeId)
                  blnremoveRenewalChck = true;
             else
                  blnremoveRenewalChck = false;        
         }
     }
    if(Trigger.isInsert && trigger.isAfter){
        Boolean boolSplitBill = false;
        for(Quote quo : trigger.new){
            if(quo.Oppty_Mgmt_Type__c == 'Split Billing'){
                boolSplitBill = TRUE;
            }
        }
        if((blnRenewalChck && boolSplitBill) || !blnRenewalChck){
            QuoteTriggerHandler.MapOpportunityfieldsonQuote(trigger.new);
        }
    }
    
    if(Trigger.isUpdate && trigger.isAfter){
        QuoteTriggerHandler.MasterQuoteChildQuoteSync(trigger.newMap,trigger.oldMap);
      //  QuoteTriggerHandler.QuoteSync(trigger.newMap, trigger.oldMap);
        //Start For Renewals- Satyaki
     //   if(checkRecursive.runRenewalQuoteSyncOnce()) {
         if(blnRenewalChck){
            QuoteTriggerHandler.RenewalQuoteSync(trigger.newMap,trigger.oldMap);
      //    }
        }
        //End For Renewals-Satyaki
        
        if(stoprecurssion.runonce() && !blnRenewalChck && !blnremoveRenewalChck){
            QuoteTriggerHandler.QuoteOpptySync(trigger.oldMap,trigger.newMap);
        }
        
        //TDD No = 3.4.8, Full Cancel Renewal Process
        //Method is called for creating a new case when manager approve the Quote for Cancellation request.
        //if(blnRenewalChck)   {
        //  System.debug('Trigger.new='+trigger.new);
            QuoteTriggerHandler.createCaseOnManagerAcceptance(trigger.newMap, trigger.oldMap);
        //}
            QuoteTriggerHandler.updateQuotePaymentMethodTermsOpty(trigger.new, trigger.oldMap);//MCL-1560: Added by Mrinmoy 12/27/2016
    }
    
    if(trigger.isInsert || trigger.isUpdate){ 
        list<Quote> listUpdateIDOConQuotes = new list<Quote>();
        map<id,id> quoteSet = new map<id,id>();
      //  map<id,id> mapQuoteSet_Renewals = new map<id,id>();
        map<id,id> opptyQuote= new map<id,id>();
        map<id,datetime> opptyMapToDate = new map<id,datetime>();
        set<string> quoteSETForOppStage= new set <string> (); 
        set<id> setOpptyIds = new set<id>();
          
         for(Quote oQuote : trigger.new){
            //check for blank SAP IDOC number
            if(trigger.isInsert && oQuote.Primary_Quote__c){
                listUpdateIDOConQuotes.add(oQuote);
            }
            else if(trigger.isUpdate && oQuote.Primary_Quote__c
                    && trigger.oldmap.get(oQuote.Id).Primary_Quote__c != oQuote.Primary_Quote__c){
                listUpdateIDOConQuotes.add(oQuote);  
                  
            }
            else if(trigger.isUpdate 
                    && trigger.oldmap.get(oQuote.Id).status != oQuote.status){                                     
                        quoteSETForOppStage.add(oQuote.Id);
                        if(oQuote.status == 'Submitted for Processing' && oQuote.Primary_Quote__c == true){
                            opptyMapToDate.put(oQuote.OpportunityId,oQuote.Purchase_Order_Date__c);
                        }else if(oQuote.status == 'Order Completed' && oQuote.Primary_Quote__c){
                            //set<id> setOpptyIds = new set<id>();
                            setOpptyIds.add(oQuote.OpportunityId);
                        }
            }
           
             if((Trigger.isInsert && oQuote.Primary_Quote__c==true) || (Trigger.isUpdate && oQuote.Primary_Quote__c && Trigger.oldmap.get(oQuote.Id).Primary_Quote__c != oQuote.Primary_Quote__c )){           
                opptyQuote.put(oQuote.OpportunityId,oQuote.Id);
            }
            
            if((Trigger.isInsert && oQuote.Primary_Quote__c==true && oQuote.Is_Child_Quote_MSaf__c!=true && oQuote.Renewal_Flag_Formula__c != TRUE && RecordtypeIds__c.getInstance('LATAM Renewal Quote') != NULL && oQuote.RecordTypeId != RecordtypeIds__c.getInstance('LATAM Renewal Quote').recTypeId__c) 
           // || (Trigger.isInsert && oQuote.Primary_Quote__c==true && oQuote.Renewal_Flag_Formula__c == TRUE && RecordtypeIds__c.getInstance('LATAM Renewal Quote') != NULL && oQuote.RecordTypeId == RecordtypeIds__c.getInstance('LATAM Renewal Quote').recTypeId__c && oQuote.Oppty_Mgmt_Type__c=='Split Billing') 
            || (Trigger.isUpdate && oQuote.Primary_Quote__c && oQuote.Is_Child_Quote_MSaf__c!=true && Trigger.oldmap.get(oQuote.Id).Primary_Quote__c != oQuote.Primary_Quote__c && oQuote.Renewal_Flag_Formula__c != TRUE && RecordtypeIds__c.getInstance('LATAM Renewal Quote') != NULL && oQuote.RecordTypeId != RecordtypeIds__c.getInstance('LATAM Renewal Quote').recTypeId__c))
             { //SFD-458
                   
                quoteSet.put(oQuote.OpportunityId,oQuote.Id);
           //   System.debug('Inside Quoteset for old'+quoteSet);
            }  
            
           /* **********************************************************************************************************************
            Added as part of Renewals [Rajashree]  Not needed anymore,RenewalsQuoteSyncLoad batch class is in place -->
           **********************************************************************************************************************        
           if(Trigger.isInsert && oQuote.Primary_Quote__c==true && oQuote.Renewal_Flag_Formula__c == TRUE && RecordtypeIds__c.getInstance('LATAM Renewal Quote') != NULL && oQuote.RecordTypeId == RecordtypeIds__c.getInstance('LATAM Renewal Quote').recTypeId__c && oQuote.Oppty_Mgmt_Type__c!='Split Billing') {
                mapQuoteSet_Renewals.put(oQuote.OpportunityId,oQuote.Id);
                System.debug('Inside new Quoteset size'+quoteSet);  
            }     
           */
           /**  END **/
        }
        if(!opptyMapToDate.isEmpty())
            QuotePrimaryQuoteUpdation.syncPurchasedOrderDate(opptyMapToDate);
        if(!setOpptyIds.isEmpty()){
          //  system.debug('ready to call updateOpptyStage');
            QuotePrimaryQuoteUpdation.updateOpptyStage(setOpptyIds);
        }
       // system.debug('$$$$listUpdateIDOConQuotes'+listUpdateIDOConQuotes);
        if(!listUpdateIDOConQuotes.isEmpty() && QuoteTriggerHandler.callOnce){
         if(!blnRenewalChck){
            syncBoolean = true; // MCL-2126
            QuoteTriggerHandler.updateSAPIDOCNumber(listUpdateIDOConQuotes);
          }
        }
        
        if(!quoteSet.isEmpty() && QuoteTriggerHandler.callOnce){
         // System.debug('@@@@@@Calling the method updateSynCQuoteList');
          //  QuoteTriggerHandler.updateSynCQuoteList(quoteSet);
            QuoteTriggerHandler.updateSynCQuoteList(quoteSet, syncBoolean); // MCL-2126
        }       
   
      /* RenewalsQuoteSyncLoad batch class is in place , this is not needed anymore[Rajashree] 
      if(!mapQuoteSet_Renewals.isEmpty() && QuoteTriggerHandler.callOnce){
          System.debug('@@@@@@ Calling the method updateSynCQuoteList_Renewals 2');
          QuoteTriggerHandler.updateSynCQuoteList_Renewals(mapQuoteSet_Renewals); //Added as part of Renewals [Rajashree]
         
        }     */   
       if(!quoteSETForOppStage.isEmpty()){
           // system.debug('**point1');
            QuoteTriggerHandler.updateOppStageForLatAm(quoteSETForOppStage);
       }
       //commented by satyajit for test
       if(!opptyQuote.isEmpty()){
          // system.debug('opptyQuote is not empty');
           QuotePrimaryQuoteUpdation.updatePrimaryQuote(opptyQuote);
       } 
       //QuoteTriggerHandler.validateChangesOnChildQuote(trigger.newMap);                     
    }  
}