@isTest
global class MockHttpResponseGeneratorSNStage implements HttpCalloutMock {
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {
        // Optionally, only send a mock response for a specific endpoint
        // and method.
       
        //System.assertEquals('GET', req.getMethod());
          String JSONResponse = '{'+

    '\"ServiceRequestResponse\": {'+

    '\"statusCode\": \"200\",'+

    '\"statusMessage\": \"Success\",'+

    '\"serviceRequest\": \"RITM2363500\",'+

    '\"taskNumber\": \"TASK2150982\"'+

  '}'+

'}';
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody(JSONResponse);
        res.setStatusCode(200);
        return res;
    }
    
   global  MockHttpResponseGeneratorSNStage (){}
}