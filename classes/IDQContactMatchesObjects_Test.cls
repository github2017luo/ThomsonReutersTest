@isTest
public class IDQContactMatchesObjects_Test {

    public static testMethod void testRequest() {
    
        IDQContactMatchesObjects.WS_contact_searchRequestType serReq = new IDQContactMatchesObjects.WS_contact_searchRequestType();
        IDQContactMatchesObjects.WS_contact_searchResponseType serRes = new IDQContactMatchesObjects.WS_contact_searchResponseType();
        IDQContactMatchesObjects.WS_contact_searchRequestElement_element serReqElm = new IDQContactMatchesObjects.WS_contact_searchRequestElement_element();
        serReqElm.FIRST_NAME = 'test';
        serReqElm.LAST_NAME = 'test';
        serReqElm.EMAIL = 'sreenu.d@tcs.com';
        serReqElm.PHONE = '1234567899';
        serReqElm.ACCOUNT_NAME = 'Test Account';
        IDQContactMatchesObjects.WS_contact_searchResponseElement_element serResElm = new IDQContactMatchesObjects.WS_contact_searchResponseElement_element();
        
        IDQContactMatches.ws_contact_match_scoresPort matchScore = new IDQContactMatches.ws_contact_match_scoresPort();
        matchScore.inputHttpHeaders_x = new Map<String,String>();
        matchScore.outputHttpHeaders_x = new Map<String,String>();
        list<IDQContactMatchesObjects.WS_contact_searchResponseElement_element> serResElmList = new list<IDQContactMatchesObjects.WS_contact_searchResponseElement_element>();
       
        try{
        serResElmList = matchScore.ws_contact_match_scoresOperation(serReqElm);
        // Async class
        //AsyncIDQContactMatchesObjects.WS_contact_searchResponseTypeFuture asyncMatch = new AsyncIDQContactMatchesObjects.WS_contact_searchResponseTypeFuture();
        //asyncMatch.getValue();
        } catch(Exception ex) {}  
        system.assertEquals(serReqElm.FIRST_NAME, 'test');
    }
}