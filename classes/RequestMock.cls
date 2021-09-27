@isTest
global class RequestMock implements HttpCalloutMock {
        protected String  body;

        global RequestMock(String body) {
            this.body = body;
        }
        // Implement this interface method
        global HTTPResponse respond(HTTPRequest req) {
        // Create a fake response
        	HttpResponse res = new HttpResponse();
        	res.setHeader('Content-Type', 'application/json');
        	res.setBody(body);
        	res.setStatusCode(200);
        	return res;
        }
}