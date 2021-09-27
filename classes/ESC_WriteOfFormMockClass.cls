@isTest
global class ESC_WriteOfFormMockClass implements HttpCalloutMock{
    
    global HTTPResponse respond(HTTPRequest req) {            
       String json ='{'+'\"InvoiceDetail\" : {'+
        '    \"writeOffReferenceNumber\" : \" \",'+
        '    \"statusDetails\" : ['+
        '      {'+
        '        \"statusCode\" : \"E\",'+
        '        \"statusDescription\" : \"Document: 079000000095 and Line Item: 0010 can not be written off(payment specification)\",'+
        '        \"statusMssage\" : \"Document: 079000000095 and Line Item: 0010 can not be written off(payment specification)\"'+
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