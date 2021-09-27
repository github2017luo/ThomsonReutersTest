/********************************************************************************
Class Name : DCPUpdateCart 
@description : This class is used to Update the Cart 
********************************************************************************
CHANGE HISTORY
===============================================================================
Date                           Developer                 Description
28-05-2021                  Vishnu Santhosh            DCP-1781 | Initial Creation
09-08-2021                  Vishnu Santhosh            DCP-3541 | Added populateMap method
*********************************************************************************/ 
@SuppressWarnings('PMD.ApexCRUDViolation')
public without sharing class DCPUpdateCart {

    private static Map<String,Integer> lineItemIdToQuantityMap = new Map<String,Integer>();
    private static List<String> lineItemIds = new List<String>();

    /**
    @description To update the cart
    @param updateDetails contains the request for cart update.
    @return Returns the status whether the cart is updated or not.
    */
    public static String updateCart(DCPUpdateCartRequest updateDetails) {

        Apttus_Config2__ProductConfiguration__c cart = new Apttus_Config2__ProductConfiguration__c();
        List<Apttus_Config2__LineItem__c> lineItems = new List<Apttus_Config2__LineItem__c>();
        List<Apttus_Config2__LineItem__c> updatedLineItems = new List<Apttus_Config2__LineItem__c>();

        try{
            cart = DCPCart.getCart(new List<Id>{updateDetails.cartId})[0]; 
            lineItems = DCPCart.getCartLineItems(cart.Id);

            //Populate LineItemIds List  - Used to validate the requested 'Per Seat' Line Item
            for(Apttus_Config2__LineItem__c lineItem : lineItems) { 
                lineItemIds.add(lineItem.Name);
            }
            
            //Build Map : LineItemName(Id) : perSeatQuantity
            if(updateDetails.perSeatProducts != null){
                String mapStatus = populateMap(updateDetails);
                if(mapStatus!='Success'){
                    return mapStatus;
                }            
            }
            System.debug(LoggingLevel.DEBUG, '*** DEBUGGING FROM DEV *** >> lineItemIdToQuantityMap'+ lineItemIdToQuantityMap);

            //Each line item associated to cart is updated and added to the 'updatedLineItems' List.
            for(Apttus_Config2__LineItem__c lineItem : lineItems) { 
                updatedLineItems.add(updateLineItemValues(lineItem, updateDetails)); 
            }
            System.debug(LoggingLevel.FINE, '*** DEBUGGING FROM DEV *** >> Updated Line Items : '+ updatedLineItems); 
            
            //DML - Update Line Items and set Cart Status as 'New'
             if((!updatedlineItems.isEmpty()) && Schema.SObjectType.Apttus_Config2__LineItem__c.isUpdateable()) {
                update updatedlineItems;
            }
            cart.Apttus_Config2__Status__c = 'New';
            
            //False positive PMD Violation here, Suppressing Warnings         
            if(Schema.SObjectType.Apttus_Config2__ProductConfiguration__c.isUpdateable()) {
                update cart;
            }
            //End of DML

            return 'cartUpdated' ;
        }
        catch(Exception ex){
            return 'Failed to Update Cart';
        }
    }

    //Return the Updated line item from this class
    @TestVisible 
    private static Apttus_Config2__LineItem__c updateLineItemValues(Apttus_Config2__LineItem__c lineItemToUpdate, DCPUpdateCartRequest updateDetails) {

        if(lineItemToUpdate.APTS_Product_Pricing_Model__c.equalsIgnoreCase('Banded') && (updateDetails.bandedQuantity!=null || String.isNotBlank(String.valueOf(updateDetails.bandedQuantity)))){
            lineItemToUpdate.Apttus_Config2__Quantity__c = updateDetails.bandedQuantity;
        }
        else if(lineItemToUpdate.APTS_Product_Pricing_Model__c.equalsIgnoreCase('Per Seat') && 
                lineItemIdToQuantityMap.containsKey(lineItemToUpdate.Name)) {
                    lineItemToUpdate.Apttus_Config2__Quantity__c = lineItemIdToQuantityMap.get(lineItemToUpdate.Name);
        }

        if(updateDetails.contractTerm!=null || String.isNotBlank(updateDetails.contractTerm)){
            lineItemToUpdate.APTS_Contract_Term__c = updateDetails.contractTerm;
        }

        lineItemToUpdate.Apttus_Config2__PricingStatus__c = 'Pending';        
        
        return lineItemToUpdate;
    }


    private static String populateMap(DCPUpdateCartRequest updateDetails){
        for(DCPUpdateCartRequest.PerSeatProductDetails lineItemToUpdate : updateDetails.perSeatProducts) {   

            if( lineItemToUpdate.lineItemId!=null && 
                String.isNotBlank(lineItemToUpdate.lineItemId) &&
                lineItemToUpdate.perSeatQuantity!=null && 
                String.isNotBlank(String.valueOf(lineItemToUpdate.perSeatQuantity))) {

                    if(lineItemIds.contains(lineItemToUpdate.lineItemId)) {
                        lineItemIdToQuantityMap.put(lineItemToUpdate.lineItemId, lineItemToUpdate.perSeatQuantity);
                    }
                    else{  
                        return 'lineItemInvalid';
                    }   
            }
            else{
                return 'Null values in lineItemId/perSeatQuantity' ;
            }    
        }
        return 'Success';
    }
}