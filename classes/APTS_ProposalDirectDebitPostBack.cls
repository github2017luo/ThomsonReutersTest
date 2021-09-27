/**
 * Post Back class for Proposal Direct Debit details
 *
 * @author  TCS
 * @version 2019-10-24
 */
global class APTS_ProposalDirectDebitPostBack{
   //Define an object in apex that is exposed in apex web service
   global class DirectDebitInfo{
      webservice String AccountNumber;
      webservice String RoutingNumber;
      webservice String BankName;
      webservice Id proposalID;  
      webservice String PaymentStatus;  
   }
    webservice static string getTokenInfo(DirectDebitInfo vToken){   
       try{
           Apttus_Proposal__Proposal__c quote = [SELECT Id,APTS_Bank_Account_Number__c,APTS_Bank_Routing_Number__c,APTS_Bank_Name__c,Payment_Status__c FROM Apttus_Proposal__Proposal__c WHERE id=:vToken.proposalID LIMIT 1];
           if(quote != Null){  
               system.debug('vtoken'+vToken);
               quote.APTS_Bank_Account_Number__c = vToken.AccountNumber;
               quote.APTS_Bank_Routing_Number__c = vToken.RoutingNumber;
               quote.APTS_Bank_Name__c = vToken.BankName;
               quote.Payment_Status__c = vToken.PaymentStatus;
               update quote;
               return 'Success';                                   
           }
           else{
               return 'Matched record not found';
           }    
       }
       catch (Exception ex){
           system.debug('exception...'+ex.getMessage()+ex.getLineNumber());
           return 'Exception while updating the Proposal'; 
       }        
    }
}