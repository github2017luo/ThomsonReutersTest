@isTest
public class DellBoomiTokenGeneration_Test{
@isTest static void testCallout(){
Test.setMock(HttpCalloutMock.class, new DellBoomiCalloutMock());
DellBoomiTokenGeneration_Test.TestData td= new DellBoomiTokenGeneration_Test.TestData();
WebServiceSettings__c ws =td.webserviceinsert();
Test.StartTest();
String accessToken=DellBoomiTokenGeneration.getAuthToken();
System.assertEquals(accessToken,'6f6VEGEmDHn98wKBlX3FWlOfBpB4');
String accessToken2=DellBoomiTokenGeneration.getAuthToken();
//String token=DellBoomiTokenGeneration.retrieveFromCache();
DellBoomiTokenGeneration.removeKey('CacheObject');
Test.setMock(HttpCalloutMock.class, new DellBoomiCalloutMock2());
try{
String accessToken3=DellBoomiTokenGeneration.getAuthToken();
}Catch(Exception e){
    System.debug(e.getMessage());
}
Test.setMock(HttpCalloutMock.class, new DellBoomiCalloutMock3());
try{
String accessToken4=DellBoomiTokenGeneration.getAuthToken();
}Catch(Exception e){
    System.debug(e.getMessage());
}
Test.StopTest();
}



public class DellBoomiCalloutMock implements HttpCalloutMock{
public HttpResponse respond(HttpRequest req){
HttpResponse res= new HttpResponse();
res.setHeader('Content-Type','application/json');
res.setBody('{ "api_product_list": "[Boomi-MW_SFDC_Legal]", "issued_at": "1570708120029", "access_token": "6f6VEGEmDHn98wKBlX3FWlOfBpB4", "expires_in": "3599", "token_type": "Bearer" }');
res.setStatusCode(200);
return res;
}
}

public class DellBoomiCalloutMock2 implements HttpCalloutMock{
public HttpResponse respond(HttpRequest req){
HttpResponse res= new HttpResponse();
res.setHeader('Content-Type','application/json');
res.setBody('{"ErrorCode" : "invalid_client", "Error" :"Client identifier is required"}');
res.setStatusCode(401);
return res;
}
}

public class DellBoomiCalloutMock3 implements HttpCalloutMock{
public HttpResponse respond(HttpRequest req){
HttpResponse res= new HttpResponse();
res.setHeader('Content-Type','application/json');
res.setBody('');
res.setStatusCode(404);
res.setStatus('Not Found');
return res;
}
}

public class TestData{
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