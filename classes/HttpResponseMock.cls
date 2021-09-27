//This class sends mock response for callouts made from DigitalDocuSignEnvelopeCreation

@isTest
global class HttpResponseMock implements HttpCalloutMock {

// implementation of respond method of Interface
    global HTTPResponse respond(HTTPRequest req) {
           
// Checks if it is a GET request (for Envelope URL) or Post request (for Envelope ID) and sends the response accordingly    
// return multiple DocuSign accounts for code coverage           
        if (req.getMethod()=='GET') { 
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"loginAccounts": [{"name": "TestAccount", "accountId": "1970775", ' +
                '"baseUrl": "https://demo.docusign.net/restapi/v2/accounts/1970775", "isDefault": "true", "userName": "Test User",' +
                '"userId": "78f6118b-abcd-1a23-b124-60e4cd196047", "email": "test.user@tr.com", "siteDescription": ""},' +
                '{"name": "TestAccount2", "accountId": "1234555", ' +
                '"baseUrl": "https://demo.docusign.net/restapi/v2/accounts/1234555", "isDefault": "false", "userName": "Test User 2",' +
                '"userId": "78f6118b-abcd-1a23-b124-60e4cd196048", "email": "test.user2@tr.com", "siteDescription": ""}]}');
            res.setStatusCode(200);
            return res;
        } else {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"envelopeId": "fabcdec6-ef83-1234-bb37-6d341e109c4f", "uri": "/envelopes/fabcdec6-ef83-1234-bb37-6d341e109c4f", "statusDateTime": "2017-03-23T12:12:19.5100000Z",  "status": "created"}');
            res.setStatusCode(200);
            return res;
        }
    }


    public class failToConnectTest implements HttpCalloutMock {
        // Implement this interface method
        public HTTPResponse respond(HTTPRequest req) {
            // Create a fake response
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"exmaple":"test"}');
            res.setStatusCode(400);
            return res;
        }
    }
    
    public class failToCreatEnvelope implements HttpCalloutMock {
        // Implement this interface method
        public HTTPResponse respond(HTTPRequest req) {
            // Create a fake response
            HttpResponse res = new HttpResponse();
            if (req.getMethod() == 'GET') {
                res.setHeader('Content-Type', 'application/json');
                res.setBody('{"accountId":"1970775", "baseUrl": "https://na2.docusign.net/restapi/v2/accounts/1970775",}');
                res.setStatusCode(200);
                return res;
            } else {
                res.setHeader('Content-Type', 'application/json');
                res.setBody('{"example":"test"}');
                res.setStatusCode(404);
                return res;
            }
        }
    }
     
    public class docusignEnvelopeStatus_Voided implements HttpCalloutMock {
        // Implement this interface method - GET response for voided information
        public HTTPResponse respond(HTTPRequest req) {
            // Create a fake response
            HttpResponse res = new HttpResponse();
            //if(req.getEndPoint().equals('https://demo.docusign.net/restapi/v2/login_information')){
            if(!req.getEndPoint().contains('/envelopes/')) {
                res.setHeader('Content-Type', 'application/json');
                res.setBody('{"accountId":"1970775", "baseUrl": "https://demo.docusign.net/restapi/v2/accounts/1970775",}');
                res.setStatusCode(200);
                return res;
            } else{
                res.setHeader('Content-Type', 'application/json');
                res.setBody('{"status":"voided","example":"test", "voidedDateTime":"2018-04-01", "voidedReason":"test expiration"}');
                res.setStatusCode(200);
                return res;
            }
        }
    }
         
    public class docusignEnvelopeStatus_Accepted implements HttpCalloutMock {
        // Implement this interface method - GET response for voided information
        public HTTPResponse respond(HTTPRequest req) {
            // Create a fake response
            HttpResponse res = new HttpResponse();
            //if(req.getEndPoint().equals('https://demo.docusign.net/restapi/v2/login_information')){
            if(!req.getEndPoint().contains('/envelopes/')) {
                res.setHeader('Content-Type', 'application/json');
                res.setBody('{"accountId":"1970775", "baseUrl": "https://demo.docusign.net/restapi/v2/accounts/1970775",}');
                res.setStatusCode(200);
                return res;
            } else{
                res.setHeader('Content-Type', 'application/json');
                res.setBody('{"status":"completed","example":"test", "voidedDateTime":"2018-04-01", "voidedReason":"test expiration"}');
                res.setStatusCode(200);
                return res;
            }
        }
    }
 
     public class docusignFailureStatus implements HttpCalloutMock {
        // Implement this interface method - GET response for voided information
        public HTTPResponse respond(HTTPRequest req) {
            // Create a fake response
            HttpResponse res = new HttpResponse();
            //if(req.getEndPoint().equals('https://demo.docusign.net/restapi/v2/login_information')){
            if(!req.getEndPoint().contains('/envelopes/')) {
                res.setHeader('Content-Type', 'application/json');
                res.setBody('{"accountId":"1970775", "baseUrl": "https://demo.docusign.net/restapi/v2/accounts/1970775",}');
                res.setStatusCode(200);
                return res;
            } else{
                res.setHeader('Content-Type', 'application/json');
                res.setBody('{"example":"test", "voidedDateTime":"2018-04-01", "voidedReason":"test expiration"}');
                res.setStatusCode(400);
                return res;
            }
        }
    }
    
    public class docusignProdFailureStatus implements HttpCalloutMock {
        // Implement this interface method - GET response for voided information
        public HTTPResponse respond(HTTPRequest req) {
            // Create a fake response
            HttpResponse res = new HttpResponse();
            //if(req.getEndPoint().equals('https://demo.docusign.net/restapi/v2/login_information')){
            if(!req.getEndPoint().contains('/envelopes/')) {
                res.setHeader('Content-Type', 'application/json');
                res.setBody('{"accountId":"1970775", "baseUrl": "https://docusign.net/restapi/v2/accounts/1970775",}');
                res.setStatusCode(200);
                return res;
            } else{
                res.setHeader('Content-Type', 'application/json');
                res.setBody('{"example":"test", "voidedDateTime":"2018-04-01", "voidedReason":"test expiration"}');
                res.setStatusCode(400);
                return res;
            }
        }
    }
    
    public class documentCreationSuccess implements HttpCalloutMock {
        // Response for Document Creation Batch Class
        public HTTPResponse respond(HTTPRequest req) {
            // Create a fake response
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'text/xml;charset=UTF-8');
            res.setHeader('SOAPAction', 'login');
            res.setBody('<?xml version="1.0" encoding="UTF-8"?><soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns="urn:partner.soap.sforce.com" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><soapenv:Body><loginResponse><result><metadataServerUrl>https://cs65.salesforce.com/services/Soap/m/40.0/00D0m0000000NsO</metadataServerUrl><passwordExpired>false</passwordExpired><sandbox>true</sandbox><serverUrl>https://cs65.salesforce.com/services/Soap/u/40.0/00D0m0000000NsO</serverUrl><sessionId>SESSION_ID_REMOVED</sessionId><userId>0050m000000IbIKAA0</userId><userInfo><accessibilityMode>false</accessibilityMode><chatterExternal>false</chatterExternal><currencySymbol xsi:nil="true"/><orgAttachmentFileSizeLimit>5242880</orgAttachmentFileSizeLimit><orgDefaultCurrencyIsoCode xsi:nil="true"/><orgDefaultCurrencyLocale xsi:nil="true"/><orgDisallowHtmlAttachments>false</orgDisallowHtmlAttachments><orgHasPersonAccounts>false</orgHasPersonAccounts><organizationId>00D0m0000000NsOEAU</organizationId><organizationMultiCurrency>true</organizationMultiCurrency><organizationName>TRP Core Legal</organizationName><profileId>00e30000001gFezAAE</profileId><roleId>00E13000002ICC4EAO</roleId><sessionSecondsValid>14400</sessionSecondsValid><userDefaultCurrencyIsoCode>USD</userDefaultCurrencyIsoCode><userEmail>ramesh.munagala@forsysinc.com</userEmail><userFullName>Aravind Maara</userFullName><userId>0050m000000IbIKAA0</userId><userLanguage>en_US</userLanguage><userLocale>en_US</userLocale><userName>aravind.maara@forsysinc.com</userName><userTimeZone>America/Los_Angeles</userTimeZone><userType>Standard</userType><userUiSkin>Theme3</userUiSkin></userInfo></result></loginResponse></soapenv:Body></soapenv:Envelope>');
            res.setStatusCode(200);
            return res;
        }
    }
    
    public class documentCreationFailure implements HttpCalloutMock {
        // Response for Document Creation Batch Class
        public HTTPResponse respond(HTTPRequest req) {
            // Create a fake response
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'text/xml;charset=UTF-8');
            res.setHeader('SOAPAction', 'login');
            res.setBody('<?xml version="1.0" encoding="UTF-8"?><soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns="urn:partner.soap.sforce.com" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><soapenv:Body><loginResponse><result><metadataServerUrl>https://cs65.salesforce.com/services/Soap/m/40.0/00D0m0000000NsO</metadataServerUrl><passwordExpired>false</passwordExpired><sandbox>true</sandbox><serverUrl>https://cs65.salesforce.com/services/Soap/u/40.0/00D0m0000000NsO</serverUrl><sessionId>SESSION_ID_REMOVED</sessionId><userId>0050m000000IbIKAA0</userId><userInfo><accessibilityMode>false</accessibilityMode><chatterExternal>false</chatterExternal><currencySymbol xsi:nil="true"/><orgAttachmentFileSizeLimit>5242880</orgAttachmentFileSizeLimit><orgDefaultCurrencyIsoCode xsi:nil="true"/><orgDefaultCurrencyLocale xsi:nil="true"/><orgDisallowHtmlAttachments>false</orgDisallowHtmlAttachments><orgHasPersonAccounts>false</orgHasPersonAccounts><organizationId>00D0m0000000NsOEAU</organizationId><organizationMultiCurrency>true</organizationMultiCurrency><organizationName>TRP Core Legal</organizationName><profileId>00e30000001gFezAAE</profileId><roleId>00E13000002ICC4EAO</roleId><sessionSecondsValid>14400</sessionSecondsValid><userDefaultCurrencyIsoCode>USD</userDefaultCurrencyIsoCode><userEmail>ramesh.munagala@forsysinc.com</userEmail><userFullName>Aravind Maara</userFullName><userId>0050m000000IbIKAA0</userId><userLanguage>en_US</userLanguage><userLocale>en_US</userLocale><userName>aravind.maara@forsysinc.com</userName><userTimeZone>America/Los_Angeles</userTimeZone><userType>Standard</userType><userUiSkin>Theme3</userUiSkin></userInfo></result></loginResponse></soapenv:Body></soapenv:Envelope>');
            res.setStatusCode(500);
            return res;
        }
    }
    
}