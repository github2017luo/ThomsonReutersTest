/**
 * Post Back class for Proposal CC Token details
 *
 * @author  TCS
 * @version 2016-12-08
 */

/**
 * CHANGE HISTORY
 * =============================================================================
 * Date         Name                    Description
 * 2016-12-08   Pathra/Sreenu D                     Created                                                                   
 * =============================================================================
 */
/**
    * @description
    *  
    */
global class ProposalCCTokenPostBack 
{
   //Define an object in apex that is exposed in apex web service
   /**
    * @description
    *  
    */
   global class CreditCardInfo
   {
      webservice String AuthorizationNumber;
      webservice String TokenizationNumber;
      webservice String ExpirationDate;
      webservice String TransactionId;
      webservice String CardType;
      webservice String Amount;
      webservice Id proposalID;    
      webservice String VisaMessageType;
      webservice String VisaTransNumber;      
      webservice String caseNumber;
      webservice String paymentDate;
      webservice String status;
      webservice String bankrouting;
      webservice String bankaccount;
      webservice String applicationid;     
      webservice invlist[] invoicelist;
   }
   global class invlist
   { 
       webservice String invoice;
   }
   /**
        * @description
    * @param vToken
    *  @return 
    */
   webservice static string fetchTokenInfo(CreditCardInfo vToken) 
   {   
       try
       {    system.debug(LoggingLevel.WARN,'vtoken'+vToken);
       if(vToken.caseNumber != null){
             ESC_Case_Form_Extension__c cfe = new ESC_Case_Form_Extension__c();
             List<ESC_Case_Form_Extension_Line_Item__c> cfli = new List<ESC_Case_Form_Extension_Line_Item__c>();
             if(Schema.sObjectType.ESC_Case_Form_Extension__c.isQueryable()){
                cfe = [Select id,name,USL_Payment_Date__c,USL_Transaction_Date__c,ESC_Credit_Card_Type__c,ESC_Credit_Card_Number__c,USL_Total_Amount__c,ESC_Bank_Routing_Number__c,Bank_Account_Number__c,ESC_CreditCard_Details__c,ESC_Invoice_Number__c,ESC_Payment_Type__c from ESC_Case_Form_Extension__c WHERE ESC_Case__r.caseNumber=:vToken.caseNumber and ESC_Form__r.name =: 'CreditCard/Debit Payment' LIMIT 1];
             }
             
             //if(Schema.sObjectType.ESC_Case_Form_Extension_Line_Item__c.isQueryable()){
             //cfli = [ Select id,name,Invoice_Number__c from ESC_Case_Form_Extension_Line_Item__c where ESC_Case_Form_Extension__c =: cfe.id];
             //}
             if(cfe != null && vToken.status != 'Error'){
                system.debug(LoggingLevel.WARN,'vtoken'+vToken);
                string temp1;
                
                String fmTransDate = vToken.ExpirationDate;
                List<String> fmDate = fmTransDate.split(' ');
                cfe.USL_Transaction_Date__c = (cfe.USL_Transaction_Date__c == null || cfe.USL_Transaction_Date__c == '') ? fmDate[0] : cfe.USL_Transaction_Date__c+', '+ fmDate[0];
                if(vToken.CardType != '' && vToken.CardType !=null){
                    temp1 = vToken.CardType + '/'+ vToken.VisaTransNumber+'/ $'+ decimal.valueof(vToken.Amount);
                    //cfe.ESC_Credit_Card_Type__c = vToken.CardType ;
                    
                    /*
                    if(cfe.ESC_Payment_Type__c != null && cfe.ESC_Payment_Type__c == 'Credit')
                    {
                        cfe.ESC_Payment_Type__c = 'Credit';
                    }
                    else
                    {
                        cfe.ESC_Payment_Type__c = 'Both';
                    }
					*/
                    if(cfe.ESC_Payment_Type__c == null || cfe.ESC_Payment_Type__c == '')
                    {
                        cfe.ESC_Payment_Type__c = 'Credit';
                    }
                    else
                    {
                    if(cfe.ESC_Payment_Type__c != 'Credit'){
                        cfe.ESC_Payment_Type__c = 'Both';
                        }
                    }
                }
                else{
                    temp1 = vToken.bankrouting +'/'+vToken.bankaccount +'/ $'+decimal.valueof(vToken.Amount);
                    //cfe.ESC_Bank_Routing_Number__c = vToken.bankrouting;
                    /*
                    if(cfe.ESC_Payment_Type__c != null && cfe.ESC_Payment_Type__c == 'Debit')
                    {
                        cfe.ESC_Payment_Type__c = 'Debit';
                    }
                    else
                    {
                        cfe.ESC_Payment_Type__c = 'Both';
                    }
					*/
                    if(cfe.ESC_Payment_Type__c == null || cfe.ESC_Payment_Type__c == '')
                    {
                        cfe.ESC_Payment_Type__c = 'Debit';
                    }
                    else
                    {
                    if(cfe.ESC_Payment_Type__c != 'Debit'){
                        cfe.ESC_Payment_Type__c = 'Both';
                        }
                    }
                }
                
                cfe.ESC_CreditCard_Details__c = (cfe.ESC_CreditCard_Details__c == null || cfe.ESC_CreditCard_Details__c == '') ? temp1 : cfe.ESC_CreditCard_Details__c + ', '+temp1;
                
                for(invlist inv : vToken.invoicelist){
                        if(cfe.ESC_Invoice_Number__c == null || cfe.ESC_Invoice_Number__c == '')
                        {
                            cfe.ESC_Invoice_Number__c = inv.invoice;
                        }
                        else if(!cfe.ESC_Invoice_Number__c.contains(inv.invoice)){
                            cfe.ESC_Invoice_Number__c = cfe.ESC_Invoice_Number__c + ',' + inv.invoice;
                        }
                 }
                
                
                if(Schema.sObjectType.ESC_Case_Form_Extension__c.isUpdateable()){
                update cfe;}
                return 'Success'; 
                }          
                else
                {
                    return 'Matched record not found';
                }
            }
            else{
              Apttus_Proposal__Proposal__c quote = new Apttus_Proposal__Proposal__c();
              if(Schema.sObjectType.Apttus_Proposal__Proposal__c.isQueryable()){
              
            //            Apttus_Proposal__Proposal__c quote = [SELECT Id,Name,APTS_Amount__c,APTS_Quote_Value__c,APTS_Card_Type__c,APTS_Authorization_Transaction__c,APTS_Card_Expiration_Date__c,APTS_Authorization_Number__c,APTS_TokenizationNumber__c FROM Apttus_Proposal__Proposal__c WHERE id=:vToken.proposalID LIMIT 1];
              quote = [SELECT Id,Name,APTS_Amount__c,APTS_Quote_Value__c,APTS_Card_Type__c,APTS_Authorization_Transaction__c,APTS_Card_Expiration_Date__c,APTS_Authorization_Number__c,APTS_Credit_Card_Token__c,APTS_VisaMessageType__c,APTS_VisaTransNumber__c FROM Apttus_Proposal__Proposal__c WHERE id=:vToken.proposalID LIMIT 1];      
            }
            if(quote != Null)
            {  
                system.debug(LoggingLevel.WARN,'vtoken'+vToken);
                List <String> dateParts = vToken.ExpirationDate.split('/');
                Date tempDate = date.parse(dateParts[0]+'/'+dateParts[1]+'/'+dateParts[2]);
                quote.APTS_Card_Expiration_Date__c = tempDate;
                quote.APTS_Credit_Card_Token__c = vToken.TokenizationNumber; 
                quote.APTS_Authorization_Number__c = vToken.AuthorizationNumber;
                //quote.APTS_Credit_Card_Token__c  = vToken.AuthorizationNumber;
                quote.APTS_Card_Type__c = vToken.CardType;
                quote.APTS_Authorization_Transaction__c = vToken.TransactionId;
                quote.APTS_Amount__c = decimal.valueof(vToken.Amount);
                quote.APTS_VisaMessageType__c = vToken.VisaMessageType;
                quote.APTS_VisaTransNumber__c = vToken.VisaTransNumber;
                
                if(Schema.sObjectType.Apttus_Proposal__Proposal__c.isUpdateable()){
                update quote;}
                return 'Success';           
            }
            else
            {
                return 'Matched record not found';
            }
            }
       }
       catch (Exception ex)
       {
           system.debug(LoggingLevel.WARN,'exception...'+ex.getMessage()+ex.getLineNumber());
           return 'Exception while updating the Proposal'; 
       }        
  }
}