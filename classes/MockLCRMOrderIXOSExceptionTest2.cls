@isTest
global class MockLCRMOrderIXOSExceptionTest2 implements HttpCalloutMock{
     global HTTPResponse respond(HTTPRequest req) {
       System.assertEquals('https://esi-dev.thomsonreuters.com/osb/DocumentService/DocumentService_Rest', req.getEndpoint());
       HttpResponse res = new HttpResponse();
       res.setHeader('Content-Type', 'application/json');
       res.setBody('{ "errorMessage" : "Translation Failure.Failed to translate XML to JSON. Cannot write start element: getDocumentDetailsRequestThe data does not conform to the NXSDschema.Please correct the problem.", "errorCode" : "OSB-382000" }');
       res.setStatusCode(500);
      return res;
    }


}