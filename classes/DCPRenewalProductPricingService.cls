/**
    @description REST Service for DCP Renewals.
    CHANGE HISTORY
    ================================================
    Date            Developer           Description
    2021-07-01      Benjamin Her        DCP-2266 Initial Creation
 */
@RestResource(urlMapping='/digital/renewal/productpricing')
global without sharing class DCPRenewalProductPricingService{
    private static final string STR_PROPID = 'proposalId';
    private static final string STR_QUANTITY = 'quantity';

    /**
        @description GET method
        @return Returns the renewal offer details
     */
    @HttpGet
    global static DCPRenewalProductResponse getProductPrice(){

        RestRequest req = RestContext.request;
        System.debug(LoggingLevel.DEBUG,'REQUEST>>>'+req);
        
        DCPRenewalProductResponse response = new DCPRenewalProductResponse();
        try{
            //Calls main logic in DCPGetRenewal to get response data.
            response.data = callPriceService(req.params);
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

    private static DCPRenewalProductResponse.DCPProductData callPriceService(Map<String, String> reqParameter){
        string proposalId;
        string quantity;
        List<Apttus_Proposal__Proposal__c> propList = new List<Apttus_Proposal__Proposal__c>();
        List<Apttus_Config2__ProductConfiguration__c> cartList = new List<Apttus_Config2__ProductConfiguration__c>();
        Map<String,Apttus_Config2__ProductConfiguration__c> proposalIdToCartMap = new Map<String,Apttus_Config2__ProductConfiguration__c>();

        if(reqParameter.containsKey(STR_PROPID) && String.isNotBlank(reqParameter.get(STR_PROPID))
            && reqParameter.containsKey(STR_QUANTITY) && String.isNotBlank(reqParameter.get(STR_QUANTITY))){

            proposalId = reqParameter.get(STR_PROPID);
            quantity = reqParameter.get(STR_QUANTITY);
            propList = DCPProposal.getProposal(new List<Id>{proposalId});
            cartList = DCPCart.getFinalizeCartFromProposal(propList);
            for(Apttus_Config2__ProductConfiguration__c cart : cartList){
                proposalIDToCartMap.put(cart.Apttus_QPConfig__Proposald__c, cart);
            }

            return DCPRenewalGetProductPricing.getPricing(proposalIDToCartMap,quantity);
        }
        else{
            throw new DCCustomException('Error with request parameter. Parameter is missing or blank');
        }
    }
}