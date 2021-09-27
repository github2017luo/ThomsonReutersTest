/**********************************************************************************************
Class: DellBoomiTokenGenerationApigee 
Purpose: To retrive OAuth Token for all the Dellboomi Webservices with new APIGEE Token URL and hand over the token to the
         calling webservice class.
Project/JIRA: ESC SN Integration
Author: Mousumi Panda
Date            Modified By          JIRA/Descriprion

***********************************************************************************************/
public with sharing class DellBoomiTokenGenerationApigee {
        
    public class MyException extends Exception{}
    public static DellBoomiRequestResponse accessTokenRes;
    public static String accessToken{set;get;}
    public Static Cache.OrgPartition part= Cache.Org.getPartition('local.OAuthToken');
    public Static long currentTime = System.currentTimeMillis();
    public static final String SERVICENAME = 'DellboomiSFDCLegalAPIGEE';
    
/******************************************************************************************************************************
getAuthToken method gets the token from the DellBoomi using clients credentials stored in custom settings.
It checks the token in cache and if it's valid. Token if returned from cache instead of fetching new token from Dellboomi.
Validity of the DellBoomi token is 8 hour.
******************************************************************************************************************************/
    
public Static string getAuthToken(){

    accessToken=DellBoomiTokenGenerationApigee.retrieveFromCache();
    //system.debug('accessToken*******'+accessToken);
    if(accessToken!=null){
        return accessToken;
    }
    else{
    WebServiceSettings__c ws = WebServiceSettings__c.getValues(SERVICENAME);
    Http hp = new Http();
    HttpRequest req = new HttpRequest();
    HttpResponse res = new HttpResponse();
    req.setMethod('POST');
    req.setEndpoint(ws.Endpoint__c);
    //req.setHeader('Content-Type','application/x-www-form-urlencoded');
    //req.setHeader('grant_type', 'client_credentials');
    string sBody = 'grant_type=client_credentials&Content-Type=application/x-www-form-urlencoded';
    req.setBody(sBody);
    Blob accessLogin = Blob.valueOf(ws.Username__c+':'+ws.Password__c);
    String accessLoginBase64 = 'Basic '+EncodingUtil.base64Encode(accessLogin);
    system.debug(accessLoginBase64);        
    req.setHeader('authorization',+accessLoginBase64);
    system.debug(req);
    res = hp.send(req);
    system.debug(res);
    if (res.getStatusCode() == 200) {
        
        accessTokenRes = (DellBoomiRequestResponse)JSON.deserialize(res.getbody(), DellBoomiRequestResponse.class); 
        accessTokenRes.issued_at  =String.valueOf(currentTime);    
        DellBoomiTokenGenerationApigee.addToCache(accessTokenRes);
 
    }else if(res.getStatusCode() == 401 || res.getStatusCode() == 400){
        accessTokenRes = (DellBoomiRequestResponse)JSON.deserialize(res.getbody(), DellBoomiRequestResponse.class);  
        throw new MyException('Status Code ='+res.getStatusCode()+', Error Code ='+accessTokenRes.ErrorCode+', Error ='+accessTokenRes.Error+'.') ;
        
    }else{
        throw  new MyException('Status Code ='+res.getStatusCode()+',  Status ='+res.getStatus()+'.');
    }  

    return ((accessTokenRes.access_token!=null)?accessTokenRes.access_token: null);
    }
}
    
/************************************************************************
retrieveFromCache method retrives the token from the cache
***********************************************************************/
    
public Static String retrieveFromCache()
{
    system.debug('part*******'+part);
    if(part.contains('CacheObjectApigee')) {
      DellBoomiRequestResponse des= (DellBoomiRequestResponse)part.get('CacheObjectApigee');   
      system.debug('des*****'+des); 
      long expiryTime = long.valueOf(des.issued_at) + long.valueof(des.expires_in)*1000; 
       //system.debug('currentTime<expiryTim:'+expiryTime+'currentTime:'+currentTime+'des.access_token:'+des.access_token);
      return (currentTime<expiryTime)?des.access_token:removeKey('CacheObjectApigee');   
    }
    
    return null; 
}   
    
/*********************************************************************************************
addToCache method adds the dellboomi token to the platform cache if new token if fetched.
*********************************************************************************************/
  
public static void addToCache(DellBoomiRequestResponse res)
{          
 system.debug('res*******CacheObjectApigee'+res);
  part.put('CacheObjectApigee', res); 
   system.debug('part*******CacheObjectApigee'+part);        
} 
 
/*********************************************************************************************
removeKey method removes the invalid or expired token from the platform cache.
*********************************************************************************************/   

public static string removeKey(String key)
{
    part.remove(key);
    return null;
} 
    
public class DellBoomiRequestResponse 
{
// class to deserialize the Json response
    public String api_product_list;
    public String issued_at;
    public String access_token;
    public String expires_in;
    public String token_type;
    public String ErrorCode;
    public String Error;
  
}

}