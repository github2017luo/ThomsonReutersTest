@isTest
private class responseWrapperTest{
    static testmethod void method1(){
        ResponseWrapper.CanvasURL canvas = new ResponseWrapper.CanvasURL();
        canvas.HTPURL = 'http://test.com';
        canvas.SessionID = '3434456sfdfd';
        canvas.ReferenceNumber = '234454';
        canvas.Success = true;
        canvas.error = 'test';
        ResponseWrapper.postmessageResponse postmsg = new ResponseWrapper.postmessageResponse();
        postmsg.hash = '35454656gdf';
        ResponseWrapper.payload payload = new ResponseWrapper.payload();
        Payload.Token = '45rfdrr6tutgfg';
        Payload.success = 'true';
        Payload.SesssionID = '54656454545';
        Payload.Error = 'false';
        Payload.CustomerRefNumber = '43rere';
        Payload.ClientIP = 'test';
        Payload.Brand = 'visa';
        ResponseWrapper.Error err = new ResponseWrapper.Error();
        err.success = 'true';
        err.error = 'test';
    }
}