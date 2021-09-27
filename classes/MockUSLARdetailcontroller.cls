@isTest
global class MockUSLARdetailcontroller implements HttpCalloutMock{
    
    global HTTPResponse respond(HTTPRequest req) {            
           // System.assertEquals('http://api.salesforce.com/foo/bar', req.getEndpoint());
           // System.assertEquals('GET', req.getMethod());
            //String JSONResponse= '{"sessionid": "AQIC5wM2LY4Sfcwl4eiX0wgyba4NxTtRxtIduREEhm3Eof0=@AAJTSQACMTAAAlNLABM1MzgwMjI5ODUyMjk0MTI2MDAzAAJTMQACMDM=#", "uuid": "EPA-DD7748784C06DE5CAC13","IdleTime": "56","MaxIdleTime": "1800","MaxSessionTime": "60","TimeLeft": "3544"}';
            //String JSONResponse= '{"Accountref:[sourceOrTargetRef=null]","010717","75.0","",}';
        String json = '{'+
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
		'      \"additionalPdfDocumentId\" : null'+
		'    },'+
		'    \"shortDescription\" : \"From Lockbox, Ref 6115277163\",'+
		'    \"longDescription\" : \"PAYMENT RECEIVED - THANK YOU \",'+
		'    \"baselineDate\" : \"06/25/2017\"'+
		'  } ],'+
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
		'  } ]'+
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