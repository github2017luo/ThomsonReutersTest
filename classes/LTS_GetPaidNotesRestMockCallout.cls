/********************************************************************** 
Name: LTS_GetPaidNotesRestMockCallout
====================================================== 
Req:Mock Callout class for getpaid note rest service
====================================================== 
The service is triggered from SSD level/get paid Button on 'GLI' layout

Method Type : POST
====================================================== 
History 
------- 
VERSION    AUTHOR             DATE             DETAIL            JIRA STory Number
1.0        Niket Kapasi    08/04/2019  Initial Development         DPS-4006
***********************************************************************/
@isTest global class LTS_GetPaidNotesRestMockCallout implements HttpCalloutMock {
    Boolean isException;
    public LTS_GetPaidNotesRestMockCallout(Boolean isExceptiontest){
       isException  = isExceptiontest;
        System.debug(isException);
    }
    

        // Implement this interface method
        global HTTPResponse respond(HTTPRequest req) {
            // Optionally, only send a mock response for a specific endpoint
            // and method.
            //System.assertEquals('http://example.com/example/test', req.getEndpoint());
            System.assertEquals('POST', req.getMethod());
        
            LTS_GetPaidNotesRestService.ResponseWrapper restest = new LTS_GetPaidNotesRestService.ResponseWrapper();
            LTS_GetPaidNotesRestService.StatusResponse statest = new LTS_GetPaidNotesRestService.StatusResponse();
            LTS_GetPaidNotesRestService.StatusDetails statdettest = new LTS_GetPaidNotesRestService.StatusDetails();
            List<LTS_GetPaidNotesRestService.GetPaidNotesResponses> listtest = new List<LTS_GetPaidNotesRestService.GetPaidNotesResponses>();
            LTS_GetPaidNotesRestService.GetPaidNotesResponses testresrec = new LTS_GetPaidNotesRestService.GetPaidNotesResponses();

            testresrec.collectorCode='100';
            testresrec.collectorName='Cop';
            testresrec.createDt='2017-12-21 13:23:48.0';
            testresrec.modifyDt='2017-12-22 03:32:35.0';
            testresrec.note='Test Note';
            listtest.add(testresrec);
            restest.getPaidNotesResponses = listtest;
            
            statdettest.statusCode = '200';
            statdettest.statusDescription = 'SUCCESS';
            statdettest.statusDetailMessage='SUCCESS';
            statest.statusDetails = statdettest;
            
            restest.statusResponse = statest;
            
            String jsonresponsestring = Json.serialize(restest);
             HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            //res.setBody(' { "statusResponse" : { "statusDetails" : {"statusCode" : "200","statusDescription" : "SUCCESS","statusDetailMessage" : "SUCCESS"}},"getPaidNotesResponses" : [{"collectorCode" : "021", "collectorName" : "Jonathan Padilla","createDt" : "2017-12-21 13:23:48.0","modifyDt" : "2017-12-22 03:32:35.0","note" : "Changed follow-up without call or strategic correspondence\nInvoice# ( 6117821085-001 )\nmove credit out"},{"collectorCode" : "021","collectorName" : "West Accounts Receivable","createDt" : "2017-12-11 06:49:55.0","modifyDt" : "2017-12-12 03:15:50.0","note" : "Sent  Fax 222. Dunning Letter 1 "}]}');
            res.setBody(jsonresponsestring);
             System.debug(isException);
            if(isException){
            res.setStatusCode(400);
            res.setStatus('ERROR');
                 System.debug(isException);
            }
            else{
                 res.setStatusCode(200);
            res.setStatus('SUCCESS');
                 System.debug(isException);
            }
            // Create a fake response

        
            System.debug('Response'+res);
            return res;
        }
    
    
    
    }