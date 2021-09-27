/*
@Author: Radhika Pawar
@JIRA Story: CRM-6978
@Purpose: This Page is used for Displying the Credential and IP Address Restriction Webservices Response. 
          Credential Information Page Block Section which is returning the response from ESI external system when callout is made to ‘Credential’ and IP Address Restrictionwebservice 
@Version: 2017-10-18

* CHANGE HISTORY
* =============================================================================
* Date         Name                    Description
*                                                         
* =============================================================================

*/
@isTest
global class MockLCRMIPRestrictionTest implements HttpCalloutMock {
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {
        // Optionally, only send a mock response for a specific endpoint
        // and method.
        System.assertEquals('https://esi-dev.thomsonreuters.com/osb/GetIPRestrictionService/GetIPRestriction_RestService/GetIPRestriction', req.getEndpoint());
      //  System.assertEquals('GET', req.getMethod());
        
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"GetIPRestrictionResponse": {"IPRestrictionItem": [ { "accountNumber": "3008049939",  "groupType": "EE","groupID": 2000012201, "IPRestrictionType": "SI", "IPRestrictionDesc": "Single IP",  "IPAddress": "123.255.255.255",  "IPUpper": "123.255.255.255","countryCode": null, "countryDesc": null,"effectiveBegDate": "2009-07-23",  "effectiveEndDate": "2009-12-31" }, { "accountNumber": "3008049939",  "groupType": "EE",    "groupID": 2000012201,    "IPRestrictionType": "SI",    "IPRestrictionDesc": "Single IP",    "IPAddress": "123.255.255.255",     "IPUpper": "123.255.255.255",      "countryCode": null,      "countryDesc": null,      "effectiveBegDate": "2009-08-04",      "effectiveEndDate": "2009-12-31"   },      {      "accountNumber": "3008049939",      "groupType": "FF",      "groupID": 2000011975,      "IPRestrictionType": "IR",      "IPRestrictionDesc": "IP Range",      "IPAddress": "123.255.255.111",      "IPUpper": "124.255.255.112",      "countryCode": null,      "countryDesc": null,      "effectiveBegDate": "2009-07-15",      "effectiveEndDate": "2010-12-31"   },      {      "accountNumber": "3008049939",      "groupType": "FF",      "groupID": 2000011975,      "IPRestrictionType": "IR",      "IPRestrictionDesc": "IP Range",      "IPAddress": "123.255.255.111",      "IPUpper": "124.255.255.113",      "countryCode": null,      "countryDesc": null,      "effectiveBegDate": "2009-07-15",      "effectiveEndDate": "2010-12-31"   },      {      "accountNumber": "3008049939",      "groupType": "FF",      "groupID": 2000011975,      "IPRestrictionType": "IR",      "IPRestrictionDesc": "IP Range",      "IPAddress": "222.222.222.222",      "IPUpper": "222.222.222.224",      "countryCode": null,      "countryDesc": null,      "effectiveBegDate": "2009-08-14",      "effectiveEndDate": "2009-12-31"   }]}}');
       //es.setBody('{  "GetIPRestrictionResponse" : {    "IPRestrictionItem" : [ {      "accountNumber" : "1000000846",      "groupType" : "FF",      "groupID" : 2000012252,      "IPRestrictionType" : "NR",      "IPRestrictionDesc" : "Not Restricted",      "IPAddress" : null,      "IPUpper" : null,      "countryCode" : null,      "countryDesc" : null,      "effectiveBegDate" : "2009-08-12",      "effectiveEndDate" : "9999-12-31",      "responseStatus" : null,      "responseStatusDescription" : null    } ]  }}');
        res.setStatusCode(200);
        return res;
    }
}