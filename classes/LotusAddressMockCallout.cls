@isTest
global with sharing class LotusAddressMockCallout implements HttpCalloutMock {
    global HttpResponse respond(HTTPRequest req){

        HttpResponse res = new HttpResponse();
        res.setStatus('OK');
        res.setStatusCode(200);
        res.setBody('The specified address may not be valid');  
        return res;

    }
}