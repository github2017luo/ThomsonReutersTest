/*
@Author: Radhika Pawar
@JIRA Story: CRM-6978
@Purpose: This Page is used for Displying the Credential and IP Address Restriction Webservices Response. 
          Credential Information Page Block Section which is returning the response from ESI external system when callout is made to ‘Credential’ and IP Address Restrictionwebservice (Exception Status of Credentialing)
@Version: 2017-09-15

* CHANGE HISTORY
* =============================================================================
* Date         Name                    Description
*                                                         
* =============================================================================

*/
@isTest
global class MockLCRMIPRestrictionExceptionTest implements HttpCalloutMock {
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {
        // Optionally, only send a mock response for a specific endpoint
        // and method.
        System.assertEquals('https://esi-dev.thomsonreuters.com/osb/GetIPRestrictionService/GetIPRestriction_RestService/GetIPRestriction', req.getEndpoint());
      //  System.assertEquals('GET', req.getMethod());
        
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{  "getCredentialInfoResponse" : {    "statusDetails" : {      "statusCode" : "400",      "statusDescription" : "DOMAIN_NOT_FOUND",     "statusDetailMessage" : null    }  }}');
        res.setStatusCode(500);
        return res;
    }
}