/**********************************************************************************************
Class: OmniBoomiTokenGeneration
Purpose: To retrive OAuth Token for all the Dellboomi Webservices and hand over the token to the
calling webservice class.
Project/JIRA: DEP-Migrate to Boomi Middleware Platform/ BMP-809.
Author: Surendra Kamma

Date            Modified By          JIRA/Descriprion

***********************************************************************************************/
/**
* @description
*/
public with sharing class OmniBoomiTokenGeneration {
    
    public static DellBoomiRequestResponse accessTokenRes;
    public Static long currentTime = System.currentTimeMillis();
    public static String serviceName = 'OmniBoomiToken';
    public static Boolean sendGrantTypeinBody = true;
    public static String authPrefix = 'Basic ';
    public Static Cache.OrgPartition part= Cache.Org.getPartition('local.OAuthToken');
    /**
* @description
*/
    public class MyException extends Exception{}
    
    /**
* @description
*/
    public static String accessToken{set;get;} 
    
    
    
    
    
    /******************************************************************************************************************************
getAuthToken method gets the token from the DellBoomi using clients credentials stored in custom settings.
It checks the token in cache and if it's valid. Token if returned from cache instead of fetching new token from Dellboomi.
Validity of the DellBoomi token is 1 hour.
******************************************************************************************************************************/
    
    /**
* @description
* @return 
*/
    public Static string getAuthToken(){
        
        //accessToken= OmniBoomiTokenGeneration.retrieveFromCache(serviceName.replaceAll(' ',''));
        //System.debug(LoggingLevel.DEBUG, 'accessToken : '+accessToken);
        //if(accessToken!=null){
        //    return accessToken;
        //}
        //else{
            WebServiceSettings__c ws = WebServiceSettings__c.getValues(serviceName);
            
            Http hp = new Http();
            HttpRequest req = new HttpRequest();
            HttpResponse res = new HttpResponse();
            
            req.setMethod('POST');
            req.setEndpoint(ws.Endpoint__c);
            if(sendGrantTypeinBody == false){
                req.setHeader('Content-Type','application/x-www-form-urlencoded');
                req.setHeader('grant_type', 'client_credentials');
                req.setHeader('Content-Length','0');
            }else{
                req.setBody('grant_type=client_credentials&Content-Type=application/x-www-form-urlencoded');
            }
            //System.debug(LoggingLevel.DEBUG,ws.Password__c);
            Blob accessLogin = Blob.valueOf(ws.Username__c+':'+ws.Password__c);
            String accessLoginBase64 = authPrefix + EncodingUtil.base64Encode(accessLogin);
            system.debug(LoggingLevel.DEBUG,accessLoginBase64);        
            req.setHeader(Label.CalloutHeader, accessLoginBase64);
            
            res = hp.send(req);
            system.debug(LoggingLevel.DEBUG, 'Response : '+res);
            handleResponse(res);
            
            return ((accessTokenRes.access_token!=null)?accessTokenRes.access_token: null);
        //}
    }
    
    /**
* @description 
* @param res
* 
*/
    public static void handleResponse(HttpResponse res){
        if (res.getStatusCode() == 200) {
            //system.debug(LoggingLevel.DEBUG, 'Response Body : '+res.getbody());
            accessTokenRes = (DellBoomiRequestResponse)JSON.deserialize(res.getbody(), DellBoomiRequestResponse.class);            
            OmniBoomiTokenGeneration.addToCache(accessTokenRes, serviceName.replaceAll(' ',''));
            
        }else if(res.getStatusCode() == 401 || res.getStatusCode() == 400){
            accessTokenRes = (DellBoomiRequestResponse)JSON.deserialize(res.getbody(), DellBoomiRequestResponse.class);  
            throw new MyException('Status Code ='+res.getStatusCode()+', Error Code ='+accessTokenRes.errorCode+', Error ='+accessTokenRes.error+'.') ;
            
        }else{
            throw  new MyException('Status Code ='+res.getStatusCode()+',  Status ='+res.getStatus()+'.');
        }   
        
        //return ((accessTokenRes.access_token!=null)?accessTokenRes.access_token: null);
    }
    
    
    
    
    
    
    /************************************************************************
retrieveFromCache method retrives the token from the cache
***********************************************************************/
    
    /**
* @description
* @param key
* @return 
*/
/*
    public Static String retrieveFromCache(String key)
    {
        try{
            if(part.contains(key)) {
                DellBoomiRequestResponse des= (DellBoomiRequestResponse)part.get(key);    
                if(des.issued_at==null){
                    des.issued_at = String.valueOf(currentTime);  
                }
                long expiryTime = long.valueOf(des.issued_at) + long.valueof(des.expires_in)*1000; 
                
                return (currentTime<expiryTime)?des.access_token:removeKey(key);   
            }
        }catch(Exception e){System.debug(LoggingLevel.DEBUG ,'Exception : '+e.getStackTraceString());}
        return null; 
    }   
  */  
    /*********************************************************************************************
addToCache method adds the dellboomi token to the platform cache if new token if fetched.
*********************************************************************************************/
    
    /**
* @description 
* @param res
* @param key
*/
    public static void addToCache(DellBoomiRequestResponse res, String key)
    {          
        part.put(key, res);          
    } 
    
    /*********************************************************************************************
removeKey method removes the invalid or expired token from the platform cache.
*********************************************************************************************/   
    
    /**
* @description
* @param key
* @return 
*/
    public static string removeKey(String key)
    {
        part.remove(key);
        return null;
    } 
    
    /**
* @description 
*/
    public class DellBoomiRequestResponse 
    {
        // class to deserialize the Json response
        public String api_product_list;
        public String issued_at;
        public String access_token;
        public String expires_in;
        public String token_type;
        public String errorCode;
        public String error;
        
    }
    
}