/**
* {Purpose}  Application utility methods which are reusable across various parts with in the application.
*        Specifc to API version 14
*
* @author   David Sarbello 
* @version  2014.10.21
*/
  
/** 
* CHANGE HISTORY
* =============================================================================
* Date          Name                            Description
* 2014.10.21    David Sarbello                Created
*2015-08-19 Glen Cunningham     added contentType, result handling, error handling
*2015-08-20 Glen Cunningham     added Authorize header so we can implement OAuth
* 2017-01-12 Denis Mitropolsky    Removed @future from saveToken() because of errors on clients side
* =============================================================================
*/
public class CNAppUtils_14 { 
    public static HttpResponse oHttpResponse;  //Used in test context. Test method will set the expected value on this variable
    public static string AUTHTOKEN{get;set;}
    public static integer tokenExpires{get;set;}
    public static string token{get;set;}          
    //
    public static HttpResponse getResponse(String sUrl, Decimal dcTimeoutInSeconds, String sVerb, String sBody, String authorizationHeader, String contentType, String OAuthToken) {
        System.debug('invoking ' + sVerb + ': ' + sUrl);       
        Http oHttp = new Http();
        HttpRequest oReq = new HttpRequest();
        HttpResponse oRes = new HttpResponse();         
        oReq.setTimeout(dcTimeoutInSeconds.intValue() * 1000); 
        oReq.setEndpoint(sUrl);
        oReq.setMethod(sVerb);           
        if(authorizationHeader!=null){
            oReq.setHeader('Authorization', authorizationHeader); //this is our authentication header   
        }
        if(AUTHTOKEN!=null){
            //this is the authorization token from IDS /connect/token
            // this is probably a good place to renew and/or save
            string authHeader = 'Bearer ' + AUTHTOKEN; 
            system.debug('authHeader header=' + authHeader);
            oReq.setHeader('Authorization', authHeader);
        }
        if (sBody != '') oReq.setBody(sBody);
        //oReq.setCompressed(true);
        try {
            oRes = oHttp.send(oReq);
            System.debug('****result of call  ' + oRes);
            System.debug('****BODY: '+oRes.getBody()); 
            System.debug('****STATUS:'+oRes.getStatus()); 
            System.debug('****STATUS_CODE:'+oRes.getStatusCode());              
            //check if we failed to log in
            if(oRes.getBody().contains('invalid')==true || oRes.getStatusCode() != 200){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Failed to connect to API Service error=' + oRes));
                return null;
            }
           
        } catch(System.CalloutException e) {
            System.debug('****Callout error: '+ e);
            System.debug('****request call:  ' + oReq.toString());
            System.debug('****result of call:  ' + oRes);
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Failed to connect to API Service error=' + oRes));
            return null;
        }
        return oRes;      
    }    
    // disabled because of problen in client's environment
    // @future
    public static void saveToken(){
        User u = [SELECT BDP_OAuth_Expires_At__c, BDP_OAuth_Token__c FROM User where id=:UserInfo.getUserId()];
        u.BDP_OAuth_Token__c = CNAppUtils_14.AUTHTOKEN;
        //calculate expiration time from int value
        DateTime dt = System.now();
        if(CNAppUtils_14.tokenExpires!=null){ 
            u.BDP_OAuth_Expires_At__c = dt.addHours(CNAppUtils_14.tokenExpires/600);
        }       
        update u;
    } 
    
}