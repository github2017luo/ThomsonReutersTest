@isTest
global class MockLCRMOrderIXOSExceptionTest implements HttpCalloutMock{
     global HTTPResponse respond(HTTPRequest req) {
       System.assertEquals('https://esi-dev.thomsonreuters.com/osb/DocumentService/DocumentService_Rest', req.getEndpoint());
       HttpResponse res = new HttpResponse();
       res.setHeader('Content-Type', 'application/json');
       res.setBody('{  "getDocumentDetailsResponse" : {    "statusDetails" : {      "statusDescription" : "Mandatory Elements are Missing",      "statusCode" : "400",      "statusDetailMessage" : "Missing Mandatory Elements. Please Send Valid Inputs"    }  }}');
       res.setStatusCode(200);
      return res;
    }


}