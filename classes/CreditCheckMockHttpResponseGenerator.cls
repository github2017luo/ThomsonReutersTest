@isTest
global class CreditCheckMockHttpResponseGenerator implements HttpCalloutMock {
    // Implement this interface method
    public static Integer statusCode = 200;
    public static String respBody = '{"CreditCheckResponse":{"segment":"test","requireAttention":"test","endDate":"test","accountBlocked":"test","creditStatus":"Pending","checkingDescription":"asdd","accountNumber":"1234567"},"BOOMIHeader":{"applicationId":"SF12","transactionId":"test","messageId":"test","messageHistory":"test","tracingId":"test","timeStamp":"test","instanceId":"test","companyId":"test","configGroup":"test","payloadVersion":"test","postBackURL":"test","profileId":"test"}}';
    public static HTTPResponse respond(HTTPRequest req) {
        // Optionally, only send a mock response for a specific endpoint
        // and method.
        //System.assertEquals('https://api.thomsonreuters.com/ebs/account/qa/createAccount', req.getEndpoint());
        System.assertEquals('POST', req.getMethod());
        
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody(respBody);
        res.setStatusCode(statusCode);
        return res;
    }
}