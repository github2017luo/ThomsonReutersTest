/********************************************************************************
Class Name : DCPCartService 
@description :  Rest Service for DCP Cart. Handles a customised request and provides a standardised response.
********************************************************************************
CHANGE HISTORY
===============================================================================
Date                          Developer                 Description
03-06-2021                  Vishnu Santhosh            DCP-1781 | Initial Creation
04-06-2021                  Vishnu Santhosh            DCP-1781 | Added validateRequest method
09-08-2021                  Vishnu Santhosh            DCP- 3541| Removed validateRequest method as part of bug raised
*********************************************************************************/ 

@RestResource(urlMapping='/digital/renewal/cart')
global without sharing class DCPCartRestService {
    
    /**
    @description POST Method    
    @return Returns the response(status) for Update Cart Service
    */
    @HttpPost
    global static DCPServiceResponse post() {

        RestRequest req = RestContext.request;
        DCPServiceResponse response = new DCPServiceResponse();

        try{
            String updateStatus;
            DCPUpdateCartRequest updateDetails = (DCPUpdateCartRequest)JSON.deserialize(req.requestBody.toString(), DCPUpdateCartRequest.class);
            System.debug(LoggingLevel.DEBUG, '*** DEBUGGING FROM DCPCartRestService *** >> Update Details'+ updateDetails);
            
            updateStatus = DCPUpdateCart.updateCart(updateDetails);
            if(updateStatus == 'cartUpdated'){
                response.status = 'Success';
                response.response = 'Cart updated';
                response.code = 200;
            }
            else{
                    response.status = 'Failed';
                    response.response = updateStatus;
                    response.code = 400;
            }
        }
        catch(Exception ex){
            
            response.status='Failed';
            response.response='Invalid Request Format';
            response.code=400;
        }
        return response;
    }
}