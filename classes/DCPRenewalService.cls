/**
    @description REST Service for DCP Renewals.
    CHANGE HISTORY
    ================================================
    Date            Developer           Description
    2021-04-14      Benjamin Her        DCP-1414 Initial Creation
 */
@RestResource(urlMapping='/digital/renewal')
global without sharing class DCPRenewalService{

    /**
        @description GET method
        @return Returns the renewal offer details
     */
    @HttpGet
    global static DCPRenewalResponse getRenewal(){

        RestRequest req = RestContext.request;
        System.debug(LoggingLevel.DEBUG,'REQUEST>>>'+req);
        
        DCPRenewalResponse response = new DCPRenewalResponse ();
        try{
            //Calls main logic in DCPGetRenewal to get response data.
            response = DCPGetRenewal.getDCPRenewalResponse(req.params);
            response.status = 'Success';
            response.code = 200;
        }
        catch(Exception ex){    
            //If any exceptions are thrown, fail the request and provide exception message.
            response.status = 'Failed';
            response.code = 400;
            response.message = ex.getMessage();
        }

        //Return response to the request.
        System.debug(LoggingLevel.DEBUG,'RESPONSE>>>'+JSON.serialize(response));
        return response;
    }
}