/**********************************************************************************************
Class: DellBoomiTokenGeneration
Purpose: To retrive OAuth Token for all the Dellboomi Webservices and hand over the token to the
         calling webservice class.
Project/JIRA: DEP-Migrate to Boomi Middleware Platform/ BMP-809.
Author: Surendra Kamma

Date            Modified By          JIRA/Descriprion

***********************************************************************************************/
public with sharing class DellBoomiTokenGeneration {
        
    public class MyException extends Exception{}
    public static DellBoomiRequestResponse accessTokenRes;
    public static String accessToken{set;get;}
    public Static Cache.OrgPartition part= Cache.Org.getPartition('local.OAuthToken');
    public Static long currentTime = System.currentTimeMillis();
    public static final String SERVICENAME = 'Dellboomi SFDC Legal';
    
/******************************************************************************************************************************
getAuthToken method gets the token from the DellBoomi using clients credentials stored in custom settings.
It checks the token in cache and if it's valid. Token if returned from cache instead of fetching new token from Dellboomi.
Validity of the DellBoomi token is 1 hour.
******************************************************************************************************************************/
    
public Static string getAuthToken(){

    accessToken=DellBoomiTokenGeneration.retrieveFromCache();
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
    req.setHeader('Content-Type','application/x-www-form-urlencoded');
    req.setHeader('grant_type', 'client_credentials');
    Blob accessLogin = Blob.valueOf(ws.Username__c+':'+ws.Password__c);
    String accessLoginBase64 = EncodingUtil.base64Encode(accessLogin);
    system.debug(accessLoginBase64);        
    req.setHeader('authorization',+accessLoginBase64);
    req.setHeader('Content-Length','0');
    res = hp.send(req);
    system.debug(res);
    if (res.getStatusCode() == 200) {
        
        accessTokenRes = (DellBoomiRequestResponse)JSON.deserialize(res.getbody(), DellBoomiRequestResponse.class);            
        DellBoomiTokenGeneration.addToCache(accessTokenRes);
 
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
    
    if(part.contains('CacheObject')) {
      DellBoomiRequestResponse des= (DellBoomiRequestResponse)part.get('CacheObject');    
      long expiryTime = long.valueOf(des.issued_at) + long.valueof(des.expires_in)*1000; 
        
      return (currentTime<expiryTime)?des.access_token:removeKey('CacheObject');   
    }
    
    return null; 
}   
    
/*********************************************************************************************
addToCache method adds the dellboomi token to the platform cache if new token if fetched.
*********************************************************************************************/
  
public static void addToCache(DellBoomiRequestResponse res)
{          
  part.put('CacheObject', res);          
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
    public final String api_product_list;
    public final String issued_at;
    public final String access_token;
    public final String expires_in;
    public final String token_type;
    public final String ErrorCode;
    public final String Error;
    
}

}