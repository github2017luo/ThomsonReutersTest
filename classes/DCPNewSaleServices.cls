/**
    @description REST Service for DCP Projects. Handles a standardized request and provides a standarized response.

    CHANGE HISTORY
    ================================================
    Date            Developer           Description
    2021-05-18      Avudaiappan A        DCP-1820 Initial Creation
 */
@RestResource(urlMapping='/newsale/*')
/** 
 * @description : This is the class to handle the new sale rest request and map output response 
 */ 
global without sharing class DCPNewSaleServices{


    /**
        @description POST method
        @return Returns the response for the appropriate service
     */
    @HttpPost
    global static DCPProductRequestDeclaration.ProductPlanResponse productService(){

        RestRequest req = RestContext.request;
        System.debug(LoggingLevel.DEBUG,'Request Body:'+req.requestBody.toString());
        Map<String,String> requestBody = (Map<String,String>)JSON.deserialize(req.requestBody.toString(),Map<String,String>.class);
        DCPProductRequestDeclaration.ProductPlanResponse resp;
                
        System.debug(LoggingLevel.DEBUG,'REQUEST>>>'+req);
        //Splits the URI and stores the third and fourth element to determine which service is being called
        List<String> uriParts = req.requestURI.split('/');
        String customerExp = uriParts.size() > 1 ? uriParts.get(1) : '';
        String serviceRequest = uriParts.size() > 2 ? uriParts.get(2) : '';
        
        //Redirects to the appropriate service based on the URI request
        try{
            resp = trackHandler(customerExp, serviceRequest,requestBody);
        }
        catch(Exception ex){
            //If any exceptions are thrown, fail the request and provide exception message.
           resp.response.status = 'Failed';
           resp.response.statusCode = '400';

        }

        //Return response to the request.
        System.debug(LoggingLevel.DEBUG,'RESPONSE>>>'+JSON.serialize(resp));
        return resp;
    }
     
    //Overloaded Method - Handles POST request
    private static DCPProductRequestDeclaration.ProductPlanResponse trackHandler(String customerExp, String serviceRequest,Map<String,String> requestBody){
        DCPProductRequestDeclaration.ProductPlanResponse resp = new DCPProductRequestDeclaration.ProductPlanResponse();
        switch on serviceRequest {
            //Calls renewal service
            when 'DCPProductPlanService' {
                resp = DCPProductRequestHandler.handleRequest(requestBody);
                return resp;
            }
            when 'DCPProductDetailService'{
                resp = DCPProductDetailRequestHandler.handleRequest(requestBody);
                return resp;
            }
            when else {
                //throw new DCCustomException('No POST service for "'+RestContext.request.requestURI+'"');
                resp.response= DCPNewSaleUtilityCls.responseMethod(DCPNewSaleUtilityCls.errorCode,'No POST URI Found',DCPNewSaleUtilityCls.failureStatus);
                return resp;
            }
        }
    }   
 }