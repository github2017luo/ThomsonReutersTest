@isTest
global class ESC_WriteOfFormMockExceptionClass implements HttpCalloutMock{
    
    global HTTPResponse respond(HTTPRequest req) {            
       String json ='{'+'\"InvoiceDetail\" : {'+
        '    \"writeOffReferenceNumber\" : \" \",'+
        '    \"statusDetails\" : ['+
        '      {'+
        '        \"statusCode\" : \"S\",'+
        '        \"statusDescription\" : \"Document: 079000000095 can not be written off(payment specification)\",'+
        '        \"statusMssage\" : \"Document: 079000000095 can not be written off(payment specification)\"'+
        '      }'+
        '    ]'+
        '  }'+
        '}';

            system.debug('Mock webservice callout');
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
           // res.setEndpoint('http://api.salesforce.com/foo/bar');
            res.setBody(json);
            res.setStatusCode(200);
            system.debug('res....'+res);
            return res;
        }
        
    }