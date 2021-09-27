/**
    @description REST Service for DCP Renewals.
    CHANGE HISTORY
    ================================================
    Date            Developer           Description
    2021-07-01      Benjamin Her        DCP-2265 Initial Creation
 */
@RestResource(urlMapping='/digital/renewal/pricing')
global without sharing class DCPRenewalPricingService{
    private static final string STR_OPPID = 'oppId';
    private static final string STR_SSDID = 'ssdId';

    /**
        @description GET method
        @return Returns the renewal offer details
     */
    @HttpGet
    global static DCPRenewalPricingResponse getPricing(){

        RestRequest req = RestContext.request;
        System.debug(LoggingLevel.DEBUG,'REQUEST>>>'+req);
        
        DCPRenewalPricingResponse response = new DCPRenewalPricingResponse ();
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

    private static DCPRenewalPricingResponse.DCPPricingObject callPriceService(Map<String, String> reqParameter){
        string oppId;
        string ssdId;
        List<Apttus_Proposal__Proposal__c> propList = new List<Apttus_Proposal__Proposal__c>();
        List<Apttus_Config2__ProductConfiguration__c> cartList = new List<Apttus_Config2__ProductConfiguration__c>();
        Map<String,Apttus_Config2__ProductConfiguration__c> proposalIdToCartMap = new Map<String,Apttus_Config2__ProductConfiguration__c>();

        if(reqParameter.containsKey(STR_OPPID) && String.isNotBlank(reqParameter.get(STR_OPPID))
            && reqParameter.containsKey(STR_SSDID) && String.isNotBlank(reqParameter.get(STR_SSDID))){

            oppId = reqParameter.get(STR_OPPID);
            ssdId = reqParameter.get(STR_SSDID);
            propList = DCPProposal.getPresentedProposal(oppId,ssdId);
            cartList = DCPCart.getFinalizeCartFromProposal(propList);
            for(Apttus_Config2__ProductConfiguration__c cart : cartList){
                proposalIDToCartMap.put(cart.Apttus_QPConfig__Proposald__c, cart);
            }

            return DCPRenewalGetPricing.getPricing(proposalIDToCartMap);

        }
        else{
            throw new DCCustomException('Error with request parameter. Parameter is missing or blank');
        }
    }
}