/**
* This class is responsible for handling the incoming mails from Workflow rules.
* It parses the subject line and accordingly passes the control to the appropriate class.
*/

global class SAPCustomerQuoteCreationServiceHandler implements Messaging.InboundEmailHandler {
    global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope) {
        Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();  
        String sub = email.subject;
        String Body = email.plainTextBody;
        if(sub!=null)
        {  
            if(sub.contains('CreateQuoteFrmOpp:>'))
            {
                String sfdcOppId = sub.substring(sub.indexOf(':>')+2);
                System.debug('Create Quote for Opp Id: '+sfdcOppId);
                //Call createQuote cls method
                String success = createQuote.triggerQuoteCreationFrmOpp(sfdcOppId);
                system.debug('triggerQuoteCreationFrmOpp Result:='+success );
            } 
            else if(sub.contains('CreateQuoteFrmAccount:>'))
            {
                String sfdcAccId = sub.substring(sub.indexOf(':>')+2);
                system.debug('Creating Customer for AccId: '+sfdcAccId );
                //Call createQuote cls method
                createQuote.triggerQuoteCreationFrmAcc(sfdcAccId);
            }       
            else if(sub.contains('CreateCustomer:>'))
            {   
                string sfdcAccId = sub.subString(sub.indexOf(':>')+2);
               //Call create Customer cls method
               CreateCustomer.triggerCustomerCreation(sfdcAccId);
            }
        }         
        result.success = true;
        return result;
    }     
}