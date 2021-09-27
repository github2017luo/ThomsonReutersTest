/*
===============================================================================
* Contains methods for  all Payment Trigger and  generate credit card token class
* Generate the encrypted customfield for Paymentgateway Url
===============================================================================

PURPOSE: clear the values in credit card detail section while inserting new quote

COMMENTS:

CHANGE HISTORY
===============================================================================
DATE            NAME                    DESC
2017-01-31     Pathra                  Created                                          
===============================================================================
*/
public with sharing class Credit_IncreaseTriggerHelper {
    

    public static void updateCreditcarddetails(List<Apttus_Proposal__Proposal__c> listNewObjects){
        if(Static_Values__c.getAll().get('skiptoNullifyCreditCardDetails') != null){
            if(!UserInfo.getUserType().equalsIgnoreCase(Static_Values__c.getAll().get('skiptoNullifyCreditCardDetails').Value__c)){
               for(Apttus_Proposal__Proposal__c quote:listNewObjects){
                    quote.APTS_Card_Expiration_Date__c = null;
                    quote.APTS_Credit_Card_Token__c = null; 
                    quote.APTS_Authorization_Number__c = null;
                    quote.APTS_Card_Type__c = null;
                    quote.APTS_Authorization_Transaction__c = null;
                    quote.APTS_Amount__c = null;
                    quote.CreditincreaseEmailButton__c = false;
                    quote.Payment_Status__c = null;
                    //quote.AutopaymentEmailButton__c = false;
                    
                }
           }         
       }         
    }
    
    public static void updatePaymentStatus(List<Apttus_Proposal__Proposal__c> listNewObjects){
       for(Apttus_Proposal__Proposal__c quote:listNewObjects){
           system.debug('KS--> quote.APTS_Payment_Option_Diff__c '+quote.APTS_Payment_Option_Diff__c);
           system.debug('KS--> quote.Payment_Status__c '+quote.Payment_Status__c);
            if(((quote.APTS_Payment_Option__c == 'Auto Charge') || (quote.APTS_Payment_Option__c == 'Auto EFT/Auto Charge')||(quote.APTS_Payment_Option__c == 'Payment Express Auto EFT/Auto Charge')|| (quote.APTS_Payment_Option__c == 'One Time EFT'))
               &&quote.Apttus_Proposal__Approval_Stage__c=='Accepted'
               &&(quote.Payment_Status__c==null||quote.Payment_Status__c=='')){
                if(quote.APTS_Proposal_Business_Unit__c=='Tax Professional' 
                   && quote.APTS_Payment_Option_Diff__c==false){
                    continue;
                }
                quote.Payment_Status__c = 'Status Requested';
            }
            //quote.AutopaymentEmailButton__c = false;
        }
    }
}