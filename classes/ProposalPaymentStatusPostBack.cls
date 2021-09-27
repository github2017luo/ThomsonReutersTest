/**
 * Post Back class for Proposal payment Status
 *
 * @author  TCS
 * @version 2017-04-27
 */

/**
 * CHANGE HISTORY
 * =============================================================================
 * Date         Name                    Description
 * 2017-04-27   Pathra                  Created                                                                   
 * =============================================================================
 */
global class ProposalPaymentStatusPostBack 
{
   //Define an object in apex that is exposed in apex web service
   global class PaymentStatusInfo
   {
      webservice String Status;
      webservice Id proposalID;    
   }
       
   webservice static string fetchStatusInfo(PaymentStatusInfo vToken) 
   {   
       try
       {
             Apttus_Proposal__Proposal__c quote = [SELECT Id,Name,Payment_Status__c FROM Apttus_Proposal__Proposal__c WHERE id=:vToken.proposalID LIMIT 1];
              
        
        
            if(quote != Null)
            {  
                system.debug('vtoken'+vToken);
                quote.Payment_Status__c = vToken.Status;


                update quote;
                return 'Success';           
                                    
             }
            else
            {
                return 'Matched record not found';
            }
            
       }
       catch (Exception ex)
       {
           system.debug('exception...'+ex.getMessage()+ex.getLineNumber());
           return 'Exception while updating the Proposal'; 
       }        
  }
}