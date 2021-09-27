/**
 * Util class to make REST Callouts, Notify owner about Error & log the Error details in Integration_Logger__c custom Obj
 *
 * @author  TCS/Sreenu Daram
 * @version 2017-05-26
 */

/**
 * CHANGE HISTORY
 * =============================================================================
 * Date         Name                    Description
 * 2017-05-26   Sreenu                     Created                                                                
 * =============================================================================
 */
 
public without sharing class CorpOrderSubmissionCalloutUtil {
    
     
    
    public static HTTPResponse sendCorpRequest(CorpCreateOrderRequest oReq, string errMsg, string objName, string wsName, string reqMethod, string contentType, Id orderId,Decimal retryCount) {
        Httprequest req = new httprequest();
        HTTPResponse res = new HTTPResponse();
        try {
             WebServiceSettings__c oWebServiceSettings = AppUtil.getWebServiceSettings(wsName);             
             /*req.setEndpoint('callout:My_Named_Credential');
             req.setHeader('Content-Type', contentType);            
             req.setBody(JSON.serialize(oReq));
             req.setmethod(reqMethod);*/
             req.setEndpoint('CallOut:'+wsName);
             req.setHeader('Content-Type', contentType);            
             req.setBody(JSON.serialize(oReq));
             req.setmethod(reqMethod);
             blob  headerValue = Blob.valueOf(oWebServiceSettings.Username__c + ':' + oWebServiceSettings.Password__c);
             String authorizationHeader = 'Basic '+ EncodingUtil.base64Encode(headerValue);
             //req.setHeader('Authorization', authorizationHeader);
             req.setHeader(string.escapesinglequotes('Authorization'), authorizationHeader);
             system.debug('request body...'+JSON.serialize(oReq));
             system.debug('request...'+req);
             Http http = new Http();             
             if(!Test.isRunningTest()) 
                 res = http.send(req);
             System.debug('response...'+res);             
        }
        catch(Exception ex){    
            System.debug('Something went wrong'+ex.getMessage()+ex.getLineNumber()); 
            logException(req.getBody(), errMsg, objName, False, orderId,retryCount);          
        }
        return res;
    }
    
    public static void sendEmailtoQuoteOwner(HTTpResponse res, string recName, string ownerEmail, string subBody, string sub, string errMsg, string objName, Id orderId,Decimal retryCount){
        if(res.getStatusCode()!=200) {
            // call method to log the request
            logException(res.getbody(), errMsg, objName, False, orderId,retryCount);
            List<Messaging.SingleEmailMessage> lstMsgsToSend = new List<Messaging.SingleEmailMessage>();
            Messaging.SingleEmailMessage emailToSend = new Messaging.SingleEmailMessage();
            emailToSend.setToAddresses(new List<String>{ownerEmail});
            emailToSend.setPlainTextBody(subBody+recName);
            emailToSend.setSubject(sub);
            lstMsgsToSend.add(emailToSend);                
            Messaging.sendEmail(lstMsgsToSend);
        }
        else
            logException(res.getbody(), errMsg, objName, True, orderId,retryCount);
        System.debug('res.getbody()...'+res.getbody());            
     }
     
     public static void logException(string reqBody, string error, string objName, boolean isSuccess, Id recId,Decimal retryCount) {
        if(retryCount>=1){
      system.debug('Order Queue ESI LogException Retry COunt ::'+retryCount);
      List<Integration_Logger__c> intLogList =new List<Integration_Logger__c>() ;
      if(Schema.sObjectType.Integration_Logger__c.isAccessible() && Schema.sObjectType.Integration_Logger__c.isQueryable() ){
      intLogList=[Select Id from Integration_Logger__c where Order__c=:recId];
      }
      system.debug('intLogList :: '+intLogList);
      if(intLogList!=null && intLogList.size()==1){
        IntegrationLogger.updateMessage(intLogList[0].Id, false,error);
      }
    }else{
      system.debug('else part of LogException Retry COunt :: '+retryCount);
      IntegrationLogger.OCAddMessage(error,'', 'Quote/Proposal', reqBody, 'Outbound','OrderSubmission',false,recId);
         
    } 
    }
    
  }