/*
===============================================================================
OpportunityLineItemTriggerHandler
===============================================================================

PURPOSE: Trigger Handler Class for OpportunityProducts     

COMMENTS:

CHANGE HISTORY
===============================================================================
DATE            NAME                    DESC
2014-06-10     Srikanth                Moved the Incremental/Renewal Amount calculation to after trigger
2018-05-25     Seema                   Updated for CRM-14346        
===============================================================================
*/
trigger OpportunityLineItemTrigger on OpportunityLineItem (before insert, before update, after delete) {


//LTS_6300 : Exclusion framework
      System.debug('LTS_ApplicationAutomationUtility.checkTriggerApplicability()** '+LTS_ApplicationAutomationUtility.checkTriggerApplicability());
      If(LTS_ApplicationAutomationUtility.checkTriggerApplicability())
      {return;}

     
     Boolean RenewalChck = false;
     if(Boolean.valueOf(System.Label.LCRMGLIOpportunityLoadTriggerFlag) == False){       //Added for CRM-14346
         if(!trigger.isDelete) {
            for(OpportunityLineItem oli : trigger.new){
              System.debug('####******oli.RenewalCheck__c'+oli.RenewalCheck__c);
                  if(oli.RenewalCheck__c) 
                       RenewalChck = true;
                  else
                     RenewalChck = false;        
           }
           }
      
        // Commented Out for temperory fix (MCL-195)
        if(trigger.isinsert && trigger.Isbefore){
          //  OpportunityLineItemTriggerHandler.errorForNewOpportunities(trigger.new);
              //Commented out for LatAM SFD-512
            //OpportunityLineItemTriggerHandler.getCurrencydecimalPlaces(trigger.new);//SFD-49
            
           System.debug('####******RenewalChck'+RenewalChck);
           if(RenewalChck == TRUE){ 
               OpportunityLineItemTriggerHandler.getCurrencydecimalPlaces(trigger.new,false);//SFD-1068 
           }
           if(RenewalChck == FALSE){
               OpportunityLineItemTriggerHandler.SyncOppLIValueFromQuoteLIonBeforeInsert(trigger.new);//SFD-831 ,[Rajashree] Restricting this for Renewals
          }  //Had to uncomment as part of MCL-1689
           
           
           System.debug('****newMap11'+ trigger.new);
           System.debug('****oldMap11'+ trigger.old); 
        }
        
        if(trigger.isInsert){
            //OpportunityLineItemTriggerHandler.updateRenewal_IncrAmounts(trigger.new);
            
        }
        if(trigger.isUpdate){
            //OpportunityLineItemTriggerHandler.updateRenewal_IncrAmounts(trigger.new);
            List<OpportunityLineItem> oliLst= new List<OpportunityLineItem>();
            for(OpportunityLineItem oli: trigger.new){
                if(oli.Decimal_Places_for_Currency__C == null){
                    oliLst.add(oli);
                }
                system.debug('***oliLst' +oliLst);
            }
            if(oliLst!= null && oliLst.size() >0){
                OpportunityLineItemTriggerHandler.getCurrencydecimalPlaces(trigger.new,false);//SFD-49
                System.debug('****newMap12'+ trigger.new);
                System.debug('****oldMap12'+ trigger.old);
            }
        }
        if(trigger.isAfter && trigger.isDelete){
            OpportunityLineItemTriggerHandler.deleteOppProdDetails(trigger.old);
            System.debug('****newMap13'+ trigger.new);
           System.debug('****oldMap13'+ trigger.old);
            OpportunityLineItemTriggerHandler.updateBillingAccountSubtotal(trigger.old);
            System.debug('****newMap14'+ trigger.new);
           System.debug('****oldMap14'+ trigger.old);
        }
        
        if(trigger.isBefore && trigger.isInsert){
            OpportunityLineItemTriggerHandler.LatamProductCheck(trigger.new);
            System.debug('****newMap15'+ trigger.new);
           System.debug('****oldMap15'+ trigger.old);
        }
        if(trigger.isBefore && trigger.isUpdate){
            //OpportunityLineItemTriggerHandler.OpportunityLineItemLock(trigger.new, trigger.old);
        } 
    }
}