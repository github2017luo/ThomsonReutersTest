/**
 * @description       : 
 * @author            : TCS Develoer
 * @group             : 
 * @last modified on  : 05-19-2021
 * @last modified by  : TCS Developer
 * Modifications Log 
 * Ver   Date         Author                               Modification
 * 1.0   05-19-2021   TCS Developer						   Initial Version
**/

/**
* @description OmniMockHttpResponseGeneratorMock
*/
@isTest
public class OmniMockHttpResponseGeneratorMock implements HTTPCalloutMock {
   /**
* @description mock respond
* @return res
* @param req
*/
    public HTTPResponse respond(HttpRequest req){

        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json;charset=UTF-8');
        string body = OmniCalloutMockResponseGenerator.jsonGenerator();
        res.setStatusCode(200);
        res.setBody(body);
        return res;
    }
    
     
}