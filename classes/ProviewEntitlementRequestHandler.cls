/**
 * CHANGE HISTORY
 * =================================================================================================================
 * Date             Name                    Description
 * 2017-18-07       Rajashree               Created the Email Handler class to call ProviewEntitlementCallOut class
                                            as part of Proview Tokenisation Project.                                            
 * =================================================================================================================
 */


global class ProviewEntitlementRequestHandler implements Messaging.InboundEmailHandler {
    global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope) {
        Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();  
        String sub = email.subject;
        String Body = email.plainTextBody;
        if(sub != null && sub != '')
        {  
            if(sub.contains('SendForEntitlement:>'))
            {
                String sfdcQuoId = sub.substring(sub.indexOf(':>')+2);
                System.debug('SendForEntitlement: '+sfdcQuoId);
                ProviewEntitlementCallOut.SendRequest(sfdcQuoId);
            } 
        }
        result.success = true;
        return result;
    }
 }