/**
* @author Kunal Mishra
* @date 22/06/2021
* @description class to handle resubmission scenarios of failed Quotes
*/
@SuppressWarnings('PMD.ApexDoc')
public without sharing class RenewalResubmitFailedQuotes{
             @invocablemethod(label='Update Failed Records From List')
             public static void resubmitFailedRenewalQuotesFromList(List<List<Renewal_Quote__c>> listOfFailedQuotes){
             
             list<Renewal_Quote__c> listOfQuotesToUpdate = new list<Renewal_Quote__c>();
             if(!listOfFailedQuotes.isEmpty()){
                 for(list<Renewal_Quote__c> listOfRenQuotes: listOfFailedQuotes){
                 for(Renewal_Quote__c processQuote : listOfRenQuotes){
                     processQuote.Status__c = 'In Progress';
                     listOfQuotesToUpdate.add(processQuote);
                     }
                 }
                }
              if(!listOfQuotesToUpdate.isEmpty() && Renewal_Quote__c.sObjectType.getDescribe().isUpdateable()){
                  update listOfQuotesToUpdate;} RenewalQuoteTriggerHelper.processUpdate();
              
             }
  }