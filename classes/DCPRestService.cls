/**
    @description REST Service for DCP Projects. Handles a standardized request and provides a standarized response.

    CHANGE HISTORY
    ================================================
    Date            Developer           Description
    2021-04-14      Benjamin Her        DCP-1414 Initial Creation
 */
@RestResource(urlMapping='/digital/*/*')
global without sharing class DCPRestService{

    /**
        @description GET method
        @return Returns the response for the appropriate service
     */
    @HttpGet
    global static DCPServiceResponse get(){

        RestRequest req = RestContext.request;
        //System.debug(LoggingLevel.DEBUG,'REQUEST>>>'+req);

        DCPServiceResponse response = new DCPServiceResponse();
                
        //Splits the URI and stores the third and fourth element to determine which service is being called
        List<String> uriParts = req.requestURI.split('/');
        String customerExp = uriParts.size() > 2 ? uriParts.get(2) : '';
        String serviceRequest = uriParts.size() > 3 ? uriParts.get(3) : '';
        
        //Redirects to the appropriate service based on the URI request
        try{
            response = trackHandler(customerExp, serviceRequest);
        }
        catch(Exception ex){
            //If any exceptions are thrown, fail the request and provide exception message.
            response.status = 'Failed';
            response.code = 400;
            response.response= ex.getMessage();
        }

        //Return response to the request.
        //System.debug(LoggingLevel.DEBUG,'RESPONSE>>>'+JSON.serialize(response));
        return response;
    }

    /**
        @description POST method
        @return Returns the response for the appropriate service
     */
    @HttpPost
    global static DCPServiceResponse post(){

        RestRequest req = RestContext.request;
        Map<String,String> requestBody = (Map<String,String>)JSON.deserialize(req.requestBody.toString(),Map<String,String>.class);
        DCPServiceResponse response = new DCPServiceResponse();
                
        System.debug(LoggingLevel.DEBUG,'REQUEST>>>'+req);
        //Splits the URI and stores the third and fourth element to determine which service is being called
        List<String> uriParts = req.requestURI.split('/');
        String customerExp = uriParts.size() > 2 ? uriParts.get(2) : '';
        String serviceRequest = uriParts.size() > 3 ? uriParts.get(3) : '';
        
        //Redirects to the appropriate service based on the URI request
        try{
            response = trackHandler(customerExp, serviceRequest,requestBody);
        }
        catch(Exception ex){
            //If any exceptions are thrown, fail the request and provide exception message.
            response.status = 'Failed';
            response.code = 400;
            response.response= ex.getMessage();
        }

        //Return response to the request.
        //System.debug(LoggingLevel.DEBUG,'RESPONSE>>>'+JSON.serialize(response));
        return response;
    }
    /**
        @description PUT method
        @return Returns the response for the appropriate service
     */
     
    @HttpPut
    global static DCPServiceResponse put(){

        RestRequest req = RestContext.request;
        Map<String,String> requestBody = (Map<String,String>)JSON.deserialize(req.requestBody.toString(),Map<String,String>.class);
        DCPServiceResponse response = new DCPServiceResponse();
                
        //System.debug(LoggingLevel.DEBUG,'REQUEST>>>'+req);
        //Splits the URI and stores the third and fourth element to determine which service is being called
        List<String> uriParts = req.requestURI.split('/');
        String customerExp = uriParts.size() > 2 ? uriParts.get(2) : '';
        String serviceRequest = uriParts.size() > 3 ? uriParts.get(3) : '';
        
        //Redirects to the appropriate service based on the URI request
        try{
            response = trackHandlerPUT(customerExp, serviceRequest,requestBody);
        }
        catch(Exception ex){
            //If any exceptions are thrown, fail the request and provide exception message.
            response.status = 'Failed';
            response.code = 400;
            response.response= ex.getMessage();
        }

        //Return response to the request.
        //System.debug(LoggingLevel.DEBUG,'RESPONSE>>>'+JSON.serialize(response));
        return response;
    }
     
    //Overloaded Method - Handles GET request
    private static DCPServiceResponse trackHandler(String customerExp, String serviceRequest ){
        switch on customerExp {
            //Calls renewal service
            when 'renewal' {
                return DCPRenewalRestHandler.serviceHandler(serviceRequest);
            }
            /*
            when 'newsale' {
                return newsaleServiceHandler(serviceRequest);
            }
            when 'trial' {
                return trialServiceHandler(serviceRequest);
            }
            */
            //Throw exception if no matching service is found
            when else {
                throw new DCCustomException('No GET service for "'+RestContext.request.requestURI+'"');
            }
        }
    }
    
    //Overloaded Method - Handles POST request
    private static DCPServiceResponse trackHandler(String customerExp, String serviceRequest,Map<String,String> requestBody){
        switch on customerExp {
            //Calls renewal service
            when 'renewal' {
                return DCPRenewalRestHandler.serviceHandler(serviceRequest,requestBody);
            }
            /*
            when 'newsale' {
                return newsaleServiceHandler(serviceRequest,requestBody);
            }
            when 'trial' {
                return trialServiceHandler(serviceRequest,requestBody);
            }
            */
            //Throw exception if no matching service is found
            when else {
                throw new DCCustomException('No POST service for "'+RestContext.request.requestURI+'"');
            }
        }
    }      
    //Overloaded Method - Handles PUT request
    private static DCPServiceResponse trackHandlerPUT(String customerExp, String serviceRequest,Map<String,String> requestBody){
        switch on customerExp {
            //Calls renewal service
            when 'renewal' {
                return DCPRenewalRestHandler.serviceHandlerPUT(serviceRequest,requestBody);
            }
            /*
            when 'newsale' {
                return newsaleServiceHandler(serviceRequest,requestBody);
            }
            when 'trial' {
                return trialServiceHandler(serviceRequest,requestBody);
            }
            */
            //Throw exception if no matching service is found
            when else {
                throw new DCCustomException('No POST service for "'+RestContext.request.requestURI+'"');
            }
        }
    }  
}