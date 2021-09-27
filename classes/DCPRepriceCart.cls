/********************************************************************************
Class Name : DCPRepriceCart 
@description : This class is used to Reprice the cart. 
********************************************************************************
CHANGE HISTORY
===============================================================================
Date                           Developer                    Description
13-05-2021                  Vishnu Santhosh            DCP-1780 | Initial Creation
*/ 


public without sharing class DCPRepriceCart {
    private static Apttus_Config2__ProductConfiguration__c cartWithLineItems;
    
    /**
    @description To reprice the cart using Conga method API
    @param requestBody It contains cartId as parameter
    @return Returns string in case of repricing succesfully and throws exception in case of failure.
    */
    public static String repriceCart(Map<String,String> requestBody){

        Boolean continueRepricing = false;
        
        if(requestBody.containsKey('cartId') && !String.isBlank(requestBody.get('cartId'))){

            try{
                cartWithLineItems = DCPCart.getCart(new List<Id>{requestBody.get('cartId')})[0];
                for(Apttus_Config2__LineItem__c lineItem : cartWithLineItems.Apttus_Config2__LineItems__r){
                    if(lineItem.Apttus_Config2__PricingStatus__c == 'Pending'){
                        continueRepricing = true;
                        break;
                    }
                } 
                if(continueRepricing){
                    return performRepricing(requestBody);
                }  
                return 'No Repricing';  
            } 
            catch(Exception ex){
                throw new  DCCustomException(ex.getStackTraceString());
            }
        }
        else{     
            throw new DCCustomException('Request format is Invalid');
        }
        
    }

    private static String performRepricing(Map<String,String> requestBody) {

        Boolean isPending;
        Apttus_CPQApi.CPQ.UpdatePriceRequestDO request = new Apttus_CPQApi.CPQ.UpdatePriceRequestDO();
        request.cartId = requestBody.get('cartId');
        Apttus_CpqApi.CPQ.UpdatePriceResponseDO response = Apttus_CpqApi.CPQWebService.updatePriceForCart(request);
        isPending = response.IsPricePending;
        if(isPending){
            return 'Pending';
        }
        return 'Success';      
    }

}