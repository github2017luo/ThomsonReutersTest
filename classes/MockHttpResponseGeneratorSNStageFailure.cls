@isTest
global class MockHttpResponseGeneratorSNStageFailure implements HttpCalloutMock {
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {
        // Optionally, only send a mock response for a specific endpoint
        // and method.
       
        //System.assertEquals('GET', req.getMethod());
          String JSONResponse = '{'+

    '\"ServiceRequestResponse\": {'+

    '\"statusCode\": \"500\",'+

    '\"statusMessage\": \"Server is Unavailable\",'+

    '\"serviceRequest\": \"\",'+

    '\"taskNumber\": \"\"'+

  '}'+

'}';
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody(JSONResponse);
        res.setStatusCode(500);
        return res;
    }
    
   global  MockHttpResponseGeneratorSNStageFailure (){}
}