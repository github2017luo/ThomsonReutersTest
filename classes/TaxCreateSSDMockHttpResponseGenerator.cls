@isTest
global class TaxCreateSSDMockHttpResponseGenerator implements HttpCalloutMock {
    // Implement this interface method
    public static Integer statusCode = 200;
    public static String respBody = '{"BOOMIHeader":{"applicationId":"SF12"},"customerNumber":"1005215581","prevAcct":null,"access_token": "DtOdJzb5sjdWBpqcvWyGTmGdRYTR","expires_in": "3599","token_type": "Bearer" ,"StatusDetails ":[{"statusCode1 ":"300","statusDescription":"Success","statusMessage":"string"}]}';
    //public static Integer statusCode1 = 300;
    //public static String respBody1 = '{"APTS_CreateSSDJSON2ApexResponseBOOMI ":{"applicationId":"SF22"},"customerNumber":"1005215582","prevAcct":null,"access_token": "DtOdJzb5sjdWBpqcvWyGTmGdRYTS","expires_in": "3598","token_type": "Bearer" ,"StatusDetails ":[{"statusCode":"200","statusDescription":"Success","statusMessage":"string"}]}';
   // public static String respBody = '{"BOOMIHeader":{"applicationId":"SF12"},"customerNumber":"1005215581","prevAcct":null,"StatusDetails ":[{"statusCode":"200","statusDescription":"Success","statusMessage":"string"}]}';
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