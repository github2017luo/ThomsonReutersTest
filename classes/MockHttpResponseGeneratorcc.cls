@isTest
global class MockHttpResponseGeneratorcc implements HttpCalloutMock {
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {
        // Optionally, only send a mock response for a specific endpoint
        // and method.
       
        System.assertEquals('GET', req.getMethod());
        
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"HTPURL":"https://qa.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/Tokenization/RLQUKZEH21D2NUJLZH6EAWSA1ITPB4QB?Styles=color:blue\u0026PlaceHolder=Enter Credit Card Number\u0026ProdId=esca\u0026ReferenceNumber=","SessionID":"RLQUKZEH21D2NUJLZH6EAWSA1ITPB4QB","ReferenceNumber":null,"Success":true,"Error":""}');
        res.setStatusCode(200);
        return res;
    }
}