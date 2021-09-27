/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 06-09-2021
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log 
 * Ver   Date         Author                               Modification
 * 1.0   06-09-2021   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
**/
@isTest
public class OmniBoomiTokenGeneration_Test{
@isTest static void testCallout(){  
Test.setMock(HttpCalloutMock.class, new DellBoomiCalloutMock());
//OmniBoomiTokenGeneration_Test.TestData td= new OmniBoomiTokenGeneration_Test.TestData();
//WebServiceSettings__c ws =td.webserviceinsert();
 WebServiceSettings__c  wb = new WebServiceSettings__c ();
        wb.Name = 'OmniBoomiToken';
        wb.CurrencyIsoCode = 'USD';
        wb.Active__c = true;
        wb.password__c='s2esandboxESI12c';
        wb.Endpoint__c = 'https://api-uat.thomsonreuters.com/ebs/entitlement/uat/getEntitlements' ;
        wb.Service_Unavailable_Message__c ='ODTGenericEntitlement Service used to fetch online contacts from OLC';
        wb.Timeout__c = 120 ; 
    insert wb;
Test.StartTest();
String accessToken=OmniBoomiTokenGeneration.getAuthToken();
System.assertEquals(accessToken,'6f6VEGEmDHn98wKBlX3FWlOfBpB4','SUCCESS');
String accessToken2=OmniBoomiTokenGeneration.getAuthToken();
system.debug(LoggingLevel.DEBUG,accessToken2);
//String token=OmniBoomiTokenGeneration.retrieveFromCache();
OmniBoomiTokenGeneration.removeKey('CacheObject');
Test.setMock(HttpCalloutMock.class, new DellBoomiCalloutMock2());
try{ 
String accessToken3=OmniBoomiTokenGeneration.getAuthToken();
system.debug(LoggingLevel.DEBUG,accessToken3);
}Catch(Exception e){
    System.debug(LoggingLevel.DEBUG,e.getMessage());
}
Test.setMock(HttpCalloutMock.class, new DellBoomiCalloutMock3());
try{
String accessToken4=OmniBoomiTokenGeneration.getAuthToken();
System.debug(LoggingLevel.DEBUG,accessToken4);
}Catch(Exception e){
    System.debug(LoggingLevel.DEBUG,e.getMessage());
}
Test.StopTest();
}


/**
 * @description 
 */

public class DellBoomiCalloutMock implements HttpCalloutMock{
/**
 * @description 
 * @param req
 * @return res
 */
    public HttpResponse respond(HttpRequest req){
HttpResponse res= new HttpResponse();
res.setHeader('Content-Type','application/json');
res.setBody('{ "api_product_list": "[Boomi-MW_SFDC_Legal]", "issued_at": "1570708120029", "access_token": "6f6VEGEmDHn98wKBlX3FWlOfBpB4", "expires_in": "3599", "token_type": "Bearer" }');
res.setStatusCode(200);
return res;
}
}

/**
 * @description
 */
public class DellBoomiCalloutMock2 implements HttpCalloutMock{
    /**
 * @description 
 * @param req
 * @return res
 */
public HttpResponse respond(HttpRequest req){
HttpResponse res= new HttpResponse();
res.setHeader('Content-Type','application/json');
res.setBody('{"ErrorCode" : "invalid_client", "Error" :"Client identifier is required"}');
res.setStatusCode(401);
return res;
}
}

/**
 * @description
 */
public class DellBoomiCalloutMock3 implements HttpCalloutMock{
    /**
 * @description 
 * @param req
 * @return res
 */
public HttpResponse respond(HttpRequest req){
HttpResponse res= new HttpResponse();
res.setHeader('Content-Type','application/json');
res.setBody('');
res.setStatusCode(404);
res.setStatus('Not Found');
return res;
}
}

/**
 * @description
 */
public class TestData{
    /**
     * @description
     * @return ws
     */
public WebServiceSettings__c webserviceinsert(){
    WebServiceSettings__c ws= new WebServiceSettings__c();
    ws.Name='Dellboomi SFDC Legal';
    ws.Username__c='Username';
    ws.Password__c='Password';
    ws.Endpoint__c='https://dev.api.apigarden-qa.thomsonreuters.com/boomi/oauth2/token';
    ws.Service_Unavailable_Message__c='Service_Unavailable';
    
    insert ws;
    return ws;
}
}

}