/* This trigger will handle the before events on the quote.
 *
* @author  Cirrius Solutions - Sarbello
* @version 2016-3-4

 * CHANGE HISTORY
 * =============================================================================
 * Date         Name                           Description
*  2016-3-4    Cirrius Solutions - Sarbello    Created
*  2017-03-31  Karthi                          Optimized the code as per JIRA STORY: PS0-1
 * =============================================================================
 */
trigger QuoteBeforeEventListener on Quote (before insert, before update, before delete) {

//LTS_6300 : Exclusion framework
      System.debug('LTS_ApplicationAutomationUtility.checkTriggerApplicability()** '+LTS_ApplicationAutomationUtility.checkTriggerApplicability());
      If(LTS_ApplicationAutomationUtility.checkTriggerApplicability())
      {return;}
      
   Boolean blnRenewalChck = false;
     if(trigger.new != null && !trigger.new.isEmpty()){
         for(Quote quo : trigger.new){
             if(quo.Renewal_Flag_Formula__c == true && RecordtypeIds__c.getInstance('LATAM Renewal Quote') != NULL && quo.RecordTypeId== RecordtypeIds__c.getInstance('LATAM Renewal Quote').recTypeId__c )
                  blnRenewalChck = true;
             else
                  blnRenewalChck = false;        
         }
     }
    if(Trigger.isUpdate && trigger.isBefore){
        if(!blnRenewalChck){
            QuoteTriggerHandler.UpdateQuoteFieldsFromOppotunity(Trigger.oldMap, Trigger.newMap);
        }
       // QuoteTriggerHandler.QuoteLock(Trigger.newMap, Trigger.oldMap);  
       for(Quote q:Trigger.New){
            if(((q.status == 'In Review' && q.Approval_Status__c == 'Pending Pricing Approval') || (q.status == 'MGT Approval – Pending Review' && q.Approval_Status__c == 'Pending Manager Approval')) && (Trigger.OldMap.get(q.ID).Approval_Status__c != 'Pending Manager Approval') && q.Short_Term_Sub__c == false && q.Annual_Price_countBlank__c != q.LineItemCount){
                q.addError(System.Label.ShortTermApprovalCheckMsg2);
            }
            if(((q.status == 'In Review' && q.Approval_Status__c == 'Pending Pricing Approval') || (q.status == 'MGT Approval – Pending Review' && q.Approval_Status__c == 'Pending Manager Approval')) && (Trigger.OldMap.get(q.ID).Approval_Status__c != 'Pending Manager Approval') && q.Short_Term_Sub__c == true && q.Annual_Price_countBlank__c > 0){
                q.addError(System.Label.ShortTermApprovalCheckMsg1);
            }
        }           
    }
    //Commenting this method as part of DPS-17684
    /*
    if(Trigger.isInsert && trigger.isBefore){
        QuoteTriggerHandler.updateReservationMngAndHisMng(Trigger.new); // Added by Shovon for SFD-497
    } */ 
    
    if((Trigger.isInsert || Trigger.isUpdate) && !QuoteTriggerHandler.checkRecursion){
        QuoteTriggerHandler.BillingPreferencesSynch(Trigger.new);
    }
    
    if(Trigger.isUpdate && trigger.isBefore){
           QuoteTriggerHandler.ValidateCreateToken(Trigger.new);// Added by Dibya for Proview Tokenisation
       
    }
}