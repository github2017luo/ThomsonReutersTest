/* 
 *@author Original : Tejaswi Nissankula (UX010800)
 *@date Original   : 06 June 2018
 *@description     : Created to send mock resopnse to ordersubmission callouts
*/
@isTest
global  class OrderSubmissionMocKCallout implements HttpCalloutMock{

    public static HTTPResponse respond(HTTPRequest req){
    
        HTTPResponse res=new HTTPResponse();
        res.setbody('{ "CreateOrderResponse":{"Status" :{"Code" :"200","Description" :"Successfully received the order request" }}}');
        res.setStatusCode(200);
        return res;
        
    }

}