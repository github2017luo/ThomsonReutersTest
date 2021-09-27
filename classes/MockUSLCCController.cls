@IsTest(SeeAllData=false)
global class MockUSLCCController implements HttpCalloutMock{
    global HTTPResponse respond(HTTPRequest req) {                    
                 
    String JSONResponse= '{'+
                     ' \"details\" : [ {'+
                      '  \"invoiceHeader\" : {'+
                       '   \"amount\" : \"98.62\",'+
                        '  \"netAmount\" : \"91.1\",'+
                         ' \"taxAmount\" : \" 7.52\"'+
                       ' },'+
                       ' \"invoiceLines\" : [ {'+
                        '  \"description\" : \"PRODOC CD TX OFFICE PRACTICE LIBRARY SUB\",'+
                       '   \"quantity\" : \"1.0\",'+
                        '  \"netPrice\" : \"91.1\",'+
                        '  \"taxAmount\" : \"7.52\",'+
                        '  \"PONumber\" : \"000010\",'+
                        '  \"lineNumber\" : \"1\",'+
                        '  \"document\" : {'+
                       '     \"number\" : \"6121456285\"'+
                        '  },'+
                        '  \"netPerUnitDocCurr\" : \"91.1\",'+
                        '  \"taxPerUnitDocCurr\" : \"7.52\",'+
                        '  \"materialNumber\" : \"000000000030007302\",'+
                        '  \"serviceDate\" : \"05/31/2018\"'+
                        '} ]'+
                      '},'+
                      '{'+
                      '  \"invoiceHeader\" : {'+
                       '   \"amount\" : \"98.62\",'+
                        '  \"netAmount\" : \"91.1\",'+
                         ' \"taxAmount\" : \" 7.52\"'+
                       ' },'+
                       ' \"invoiceLines\" : [ {'+
                        '  \"description\" : \"PRODOC CD TX OFFICE PRACTICE LIBRARY SUB\",'+
                       '   \"quantity\" : \"1.0\",'+
                        '  \"netPrice\" : \"91.1\",'+
                        '  \"taxAmount\" : \"7.52\",'+
                        '  \"PONumber\" : \"000010\",'+
                        '  \"lineNumber\" : \"1\",'+
                        '  \"document\" : {'+
                       '     \"docnumber\" : \"6121456285\"'+
                        '  },'+
                        '  \"netPerUnitDocCurr\" : \"91.1\",'+
                        '  \"taxPerUnitDocCurr\" : \"7.52\",'+
                        '  \"materialNumber\" : \"000000000030007302\",'+
                        '  \"serviceDate\" : \"05/31/2018\"'+
                        '} ]'+
                      '}]'+
                    '}';
                
           system.debug('Mock webservice callout');
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
           // res.setEndpoint('http://api.salesforce.com/foo/bar');
            res.setBody(JSONResponse);
            res.setStatusCode(200);
            system.debug('res....'+res);
            return res;
        }
        
       global MockUSLCCController (){}
    

}