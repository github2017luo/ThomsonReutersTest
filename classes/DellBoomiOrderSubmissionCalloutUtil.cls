/**
 * Util class to make REST Callouts, Notify owner about Error & log the Error details in Integration_Logger__c custom Obj
 *
 *
 */

/**
 * CHANGE HISTORY
 * =============================================================================
 * Date         Name                    Description
 * 2019-05-26   Gokila                    Created       
 * 2019-11-07   Roma                      oAuth Implementation                                                         
 * =============================================================================
 */
 
public without sharing class DellBoomiOrderSubmissionCalloutUtil {
    
     
    
    public static HTTPResponse sendS4Request(CreateS4HANAOrderRequest oReq, string errMsg, string objName, string wsName, string reqMethod, string contentType1, Id orderId,Decimal retryCount) {
        Httprequest req = new httprequest();
        HTTPResponse res = new HTTPResponse();
        try{
            WebServiceSettings__c oWebServiceSettings = AppUtil.getWebServiceSettings(wsName);  
             String requestBodyStringSafe = JSON.serialize(oReq);
             requestBodyStringSafe =requestBodyStringSafe.replaceAll('\"currency_x\":', '\"currency\":');
             requestBodyStringSafe =requestBodyStringSafe.replaceAll('\"number_x\":', '\"number\":');           
             /*req.setEndpoint('callout:My_Named_Credential');
             req.setHeader('Content-Type', contentType);            
             req.setBody(JSON.serialize(oReq));
             req.setmethod(reqMethod);*/
             /*String requestBodyStringSafe = JSON.serialize(oReq);
             requestBodyStringSafe =requestBodyStringSafe.replaceAll('\"currency_x\":', '\"currency\":');
             req.setEndpoint(oWebServiceSettings.Endpoint__c);
             req.setHeader('Content-Type', contentType);            
             req.setBody(requestBodyStringSafe );
             req.setmethod(reqMethod);
             blob  headerValue = Blob.valueOf(oWebServiceSettings.Username__c + ':' + oWebServiceSettings.Password__c);
             String authorizationHeader = 'Basic '+ EncodingUtil.base64Encode(headerValue);
             req.setHeader('Authorization', authorizationHeader);
             system.debug('request body...'+requestBodyStringSafe );
             system.debug('request...'+req);
             Http http = new Http();             
             if(!Test.isRunningTest()) 
                 res = http.send(req);
             System.debug('response...'+res);*/
                String grantType = 'client_credentials';
                String contentType= 'application/x-www-form-urlencoded';
            
                /* oAuth Code */
               /*
                String endPt = 'https://dev.api.apigarden-qa.thomsonreuters.com/dep/ordermanagement/v1/orders';
                String clientId = 'iXUUv4fZbR46SkPnoaZJISXuMwDaaqgV';
                String clientSecret = 'bLvRDkppV1IsJRG8';
                String grantType = 'client_credentials';
                String contentType= 'application/x-www-form-urlencoded';
                String reqBody = 'grant_type='+grantType+'&client_id='+clientId+'&client_secret='+clientSecret;
                String accessToken ='https://dev.api.apigarden-qa.thomsonreuters.com/boomi/oauth2/token';
                Http http = new Http();
                HttpRequest request = new HttpRequest();
                request.setBody(reqbody);
                request.setMethod('POST');
                request.setEndpoint(accessToken);
                
                 HttpResponse response;
                 
                if(!Test.isRunningTest()) 
                  {
                      response = http.send(request);
                  }
                
                

                OAuth2 objAuthenticationInfo = (OAuth2)JSON.deserialize(response.getbody(), OAuth2.class);
                //RequestWrapper reqst=new RequestWrapper();
                    */
                
                  String accessToken;
                  if(!Test.isRunningTest()){
                      accessToken = DellBoomiTokenGeneration.getAuthToken();
                  }else{
                      accessToken = 'DtOdJzb5sjdWBpqcvWyGTmGdRYTR';
                  }System.debug('oAUTH responseBody**** : '+accessToken);
                    
                    Http h1;
                    HttpRequest request1;

                if(accessToken !=null){
                     h1 = new Http();
                     request1 = new HttpRequest();
                    }
                
                    request1.setEndpoint(oWebServiceSettings.Endpoint__c);
                    request1.setMethod('POST');
                    request1.setTimeout(120000);    
                    request1.setHeader('Authorization','Bearer '+accessToken);
                    
                    request1.setHeader('Content-Type', contentType);
                    request1.setHeader('grant_type', grantType);
                    //request1.setHeader('client_id', clientId);
                    //request1.setHeader('client_secret', clientSecret);
                    request1.setBody(requestBodyStringSafe);
                    System.debug('Http request'+request1); 
               
                
                /* Oauth Ends */
                HttpResponse response1;
                
                if(!Test.isRunningTest()){                
                    res = h1.send(request1);
                }
                
                system.debug('request...'+req);
                System.debug('response...'+res);
                   
        }
        catch(Exception ex){    
            System.debug('Something went wrong'+ex.getMessage()+' : '+ex.getStackTraceString()); 
            logException(req.getBody(), errMsg+'\nException Occured :'+ex.getMessage()+'\nTrace : '+ex.getStackTraceString(), objName, False, orderId,retryCount);          
        }
        return res;
    }
    
    public static void sendEmailtoQuoteOwner(String requestBody, HTTpResponse res, string recName, string ownerEmail, string subBody, string sub, string errMsg, string objName, Id orderId,Decimal retryCount){
        if(res.getStatusCode()!=200) {
            // call method to log the request
            logException(requestBody, errMsg+':\n'+res.getbody(), objName, False, orderId,retryCount);
            List<Messaging.SingleEmailMessage> lstMsgsToSend = new List<Messaging.SingleEmailMessage>();
            Messaging.SingleEmailMessage emailToSend = new Messaging.SingleEmailMessage();
            emailToSend.setToAddresses(new List<String>{ownerEmail});
            emailToSend.setPlainTextBody(subBody+recName);
            emailToSend.setSubject(sub);
            lstMsgsToSend.add(emailToSend);                
            Messaging.sendEmail(lstMsgsToSend);
        }
        else
            logException(requestBody, res.getbody(), objName, True, orderId,retryCount);
        System.debug('res.getbody()...'+res.getbody());            
     }
     
     public static void logException(string reqBody, string error, string objName, boolean isSuccess, Id recId,Decimal retryCount) {
        //if(retryCount>=1){
        system.debug('Order Queue BOOMI LogException Retry COunt ::'+retryCount);
        List<Integration_Logger__c> intLogList =new List<Integration_Logger__c>() ;
        if(Schema.sObjectType.Integration_Logger__c.isAccessible() && Schema.sObjectType.Integration_Logger__c.isQueryable() ){
            intLogList=[Select Id from Integration_Logger__c where Service_Name__c = 'OrderSubmission' and Order__c=:recId];
        }
        system.debug('intLogList :: '+intLogList);
        if(intLogList!=null && intLogList.size()==1){
            IntegrationLogger.TaxupdateMessage(intLogList[0].Id, isSuccess,splitString(error),splitString(reqBody));
            system.debug('else part of LogException Retry COunt :: '+retryCount+' : '+error);
           //}
        }else{
            system.debug('else part of LogException Retry COunt :: '+retryCount);
            IntegrationLogger.OCAddMessage(splitString(error), recId, 'Quote/Proposal', splitString(reqBody), 'Outbound','OrderSubmission',isSuccess,recId);
        } 
        
    }
    
    public static String splitString(String error){
        String finalError = '';
        if(error.length()>=131000){
            finalError = error.subString(0,131000)+'\nTruncated too long.';
        }else{
            finalError = error;
        }
        system.debug('finalError : '+finalError);
        return finalError;
    }
    
      public class OAuth2{
         public String id{get;set;}
         public String issued_at{get;set;}
         public String instance_url{get;set;}
         public String signature{get;set;}
         public String access_token{get;set;}    
        }
    
  }