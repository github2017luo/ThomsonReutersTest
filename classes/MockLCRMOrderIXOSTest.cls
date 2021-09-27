@isTest
global class MockLCRMOrderIXOSTest implements HttpCalloutMock{

    global HTTPResponse respond(HTTPRequest req) {
       System.assertEquals('https://esi-dev.thomsonreuters.com/osb/DocumentService/DocumentService_Rest', req.getEndpoint());
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');     
        res.setBody('{"getDocumentDetailsResponse":  {"documentDetails":  [{"documentHeader":  {"referenceObject":      "VBRK"  ,"documentDescription":     "Billing Summary"   ,"documentType":    [ "ZBWAIMAGE" ] ,"endDate":     "2008-04-03"    ,"documentUrl":     "http://opentextqa.int.thomsonreuters.com:8080/archive?get&pVersion=0045&contRep=T1&docId=47F4FEEFEC6E01C1E1008000A3E7533B" ,"archiveDocumentId":  "47F4FEEFEC6E01C1E1008000A3E7533B"   ,"blockStatus":     null    ,"billDate":    "2007-08-04"    ,"archiveId":   "T1"    ,"referenceNumber":  "6239141926"   ,"account":     {   "accountNumber":    "1000022762"     }  ,"objectId":    "6239141926 2009151843" ,"startDate":   "2008-04-03"    ,"billPeriod":      "200707"}}],"statusDetails":  {"statusDescription":     "SUCCESS"   ,"statusCode":      "200"}}}');
        res.setStatusCode(200);
      return res;
    }
}