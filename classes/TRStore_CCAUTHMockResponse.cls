@isTest
global class TRStore_CCAUTHMockResponse implements HttpCalloutMock {
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {
        // Optionally, only send a mock response for a specific endpoint
        // and method.
        System.assertEquals('POST', req.getMethod());
        
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{\"response\":{\"status\":\"Authorization successful\",\"statusCode\":\"SUCCESS\",\"authNumber\":\"tst204\",\"pnRefNum\":\"204954856\",\"txnNumber\":\"f2ca99e9-4569-4592-afd8-ec8a355ec92b\",\"ccVendorTransactId\":null,\"transactionMessageType\":\"CSTO\"}}');
        res.setStatusCode(200);
        res.setStatus('OK');
        return res;
    }

}