@IsTest(SeeAllData=false)
global class MockUSLARController implements HttpCalloutMock{
    global HTTPResponse respond(HTTPRequest req) {
            
        
                 
    String JSONResponse             = '{'+
        '  \"totalOpenItemAmount\" : 1192.23,'+
        '  \"totalOpenItemAmountInvoiced\" : 1192.23,'+
        '  \"pastDueBalance\" : 1192.23,'+
        '  \"clearedItems\" : [ {'+
        '    \"account\" : {'+
        '      \"currency\" : \"USD\"'+
        '    },'+
        '    \"referencekey\" : null,'+
        '    \"postingDate\" : \"06/25/2017\",'+
        '    \"amount\" : \"183.36\",'+
        '    \"dueDate\" : \"06/25/2017\",'+
        '    \"reasonCode\" : null,'+
        '    \"debitCreditInd\" : \"H\",'+
        '    \"dunningArea\" : null,'+
        '    \"allocationNumber\" : \"000010716\",'+
        '    \"clearingDate\" : \"06/25/2017\",'+
        '    \"clearingDocumentNumber\" : \"1100416887\",'+
        '    \"dunningBlock\" : null,'+
        '    \"dunningLevel\" : \"0\",'+
        '    \"paymentMethod\" : null,'+
        '    \"netArrers\" : \"0\",'+
        '    \"specialGeneralLedgerInd\" : null,'+
        '    \"document\" : {'+
        '      \"type\" : \"DU\",'+
        '      \"account\" : {'+
        '        \"sourceOrTargetReference\" : [ {'+
        '          \"referenceID\" : null'+
        '        } ]'+
        '      },'+
        '      \"docNumber\" : \"1100416887\",'+
        '      \"docDate\" : \"06/25/2017\",'+
        '      \"referenceNumber\" : \"000010716\",'+
        '      \"additionalPdfDocumentId\" : \"1100416887\"'+
        '    },'+
        '    \"shortDescription\" : \"From Lockbox, Ref 6115277163\",'+
        '    \"longDescription\" : \"PAYMENT RECEIVED - THANK YOU \",'+
        '    \"baselineDate\" : \"06/25/2017\"'+
        '  },'+
        '{'+
        '    \"account\" : {'+
        '      \"currency\" : \"USD\"'+
        '    },'+
        '    \"referencekey\" : null,'+
        '    \"postingDate\" : \"06/25/2017\",'+
        '    \"amount\" : \"183.36\",'+
        '    \"dueDate\" : \"06/25/2017\",'+
        '    \"reasonCode\" : null,'+
        '    \"debitCreditInd\" : \"H\",'+
        '    \"dunningArea\" : null,'+
        '    \"allocationNumber\" : \"000010717\",'+
        '    \"clearingDate\" : \"06/25/2017\",'+
        '    \"clearingDocumentNumber\" : \"1100416888\",'+
        '    \"dunningBlock\" : null,'+
        '    \"dunningLevel\" : \"0\",'+
        '    \"paymentMethod\" : null,'+
        '    \"netArrers\" : \"0\",'+
        '    \"specialGeneralLedgerInd\" : null,'+
        '    \"document\" : {'+
        '      \"type\" : \"DU\",'+
        '      \"account\" : {'+
        '        \"sourceOrTargetReference\" : [ {'+
        '          \"referenceID\" : null'+
        '        } ]'+
        '      },'+
        '      \"docNumber\" : \"1100416888\",'+
        '      \"docDate\" : \"06/25/2017\",'+
        '      \"referenceNumber\" : \"000010717\",'+
        '      \"additionalPdfDocumentId\" : \"1100416888\"'+
        '    },'+
        '    \"shortDescription\" : \"From Lockbox, Ref 6115277163\",'+
        '    \"longDescription\" : \"PAYMENT RECEIVED - THANK YOU \",'+
        '    \"baselineDate\" : \"06/25/2017\"'+
        '  }],'+
        '  \"openedItems\" : [ {'+
        '    \"referencekey\" : \"0837170321\",'+
        '    \"postingDate\" : \"01/11/2017\",'+
        '    \"amount\" : \"98.62\",'+
        '    \"lineNumber\" : \"001\",'+
        '    \"reasonCode\" : null,'+
        '    \"debitCreditInd\" : \"S\",'+
        '    \"dunningArea\" : null,'+
        '    \"dunningBlock\" : null,'+
        '    \"shipTo\" : null,'+
        '    \"servicesRenderedDate\" : \"11/30/2017\",'+
        '    \"pdfLinkInd\" : \"X\",'+
        '    \"netArrers\" : \"188\",'+
        '    \"document\" : {'+
        '      \"type\" : \"YC\",'+
        '      \"docNumber\" : \"6118005220\",'+
        '      \"docDate\" : \"11/01/2017\",'+
        '      \"additionalPdfDocumentId\" : \"6118005220\"'+
        '    },'+
        '    \"shortDescription\" : \"PRODOC CD TX OFFICE PRACTICE LIBRARY SUB\",'+
        '    \"longDescription\" : \"PRODOC CD TX OFFICE PRACTICE LIBRARY SUB \",'+
        '    \"baselineDate\" : \"11/04/2017\",'+
        '    \"pastDueFlag\" : \"1\",'+
        '    \"processingStatus\" : null'+
        '  }, '+
        '{'+
        '    \"referencekey\" : \"0837170322\",'+
        '    \"postingDate\" : \"01/11/2017\",'+
        '    \"amount\" : \"98.62\",'+
        '    \"lineNumber\" : \"001\",'+
        '    \"reasonCode\" : null,'+
        '    \"debitCreditInd\" : \"S\",'+
        '    \"dunningArea\" : null,'+
        '    \"dunningBlock\" : null,'+
        '    \"shipTo\" : null,'+
        '    \"servicesRenderedDate\" : \"11/30/2017\",'+
        '    \"pdfLinkInd\" : \"X\",'+
        '    \"netArrers\" : \"188\",'+
        '    \"document\" : {'+
        '      \"type\" : \"YC\",'+
        '      \"docNumber\" : \"6118005221\",'+
        '      \"docDate\" : \"11/01/2017\",'+
        '      \"additionalPdfDocumentId\" : \"6118005221\"'+
        '    },'+
        '    \"shortDescription\" : \"PRODOC CD TX OFFICE PRACTICE LIBRARY SUB\",'+
        '    \"longDescription\" : \"PRODOC CD TX OFFICE PRACTICE LIBRARY SUB \",'+
        '    \"baselineDate\" : \"11/04/2017\",'+
        '    \"pastDueFlag\" : \"1\",'+
        '    \"processingStatus\" : null'+
        '  }]'+        
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
        
       global MockUSLARController (){}
    

}