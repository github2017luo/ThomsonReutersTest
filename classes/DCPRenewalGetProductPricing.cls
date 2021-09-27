/********************************************************************************
Class Name : DCPRenewalGetPriceMatrix 
@description : This class is used to pull pricing for carts
********************************************************************************
CHANGE HISTORY
===============================================================================
Date                            Developer                   Description
7-9-2021                       Benajmin Her                DCP-2266 Initial Creation
7-23-2021                      Kavya S                     DCP-3193 Added qualifier tag
*********************************************************************************/ 
public without sharing class DCPRenewalGetProductPricing{
    private static final String STR_STRAIGHT_RENEWAL = 'Straight Renewal';
    //private static List<DCPRenewalPricingResponse.DCPProductPricing> productPricingDetail = new List<DCPRenewalPricingResponse.DCPProductPricing>();

    /**
        @description Populates DCPPricingMatrix
        @param proposalIDToCartMap Map of proposal id to its cart
        @param quantityRequest Quantity that we want to pull price for
        @return Returns a list of pricing information
     */
    public static DCPRenewalProductResponse.DCPProductData getPricing(Map<String,Apttus_Config2__ProductConfiguration__c> proposalIDToCartMap, String quantityRequest){
        
        DCPRenewalProductResponse.DCPProductData data = new DCPRenewalProductResponse.DCPProductData();

        if(DCPRenewalSetting.renewalSettings == null || DCPRenewalSetting.renewalSettings.isEmpty()){
            DCPRenewalSetting.getRenewalSetting();
        }
        //Queries and build the pricing matrices for a product and its quanity and amount per quantity
        Map<String,Map<String,Decimal>> productToQuantityToAmountMap = DCPRenewalGetPricingHelper.queryPriceMatrix(proposalIDToCartMap);

        data.offerProductDetail = buildOfferProductDetail(proposalIDToCartMap,quantityRequest,productToQuantityToAmountMap);

        return data;
    }

    //Builds the offer pricing detail for the response
    private static List<DCPRenewalProductResponse.DCPOfferProductDetail> buildOfferProductDetail(Map<String,Apttus_Config2__ProductConfiguration__c> proposalIDToCartMap,
        String quantityRequest,Map<String,Map<String,Decimal>> productToQuantityToAmountMap){

        List<DCPRenewalProductResponse.DCPOfferProductDetail> offerProductDetail = new List<DCPRenewalProductResponse.DCPOfferProductDetail>();

        //Iterates over all possible carts and buid response
        for(String proposalId : proposalIDToCartMap.keySet()){

            Apttus_Config2__ProductConfiguration__c cart = proposalIDToCartMap.get(proposalId);

            DCPRenewalProductResponse.DCPOfferProductDetail offerdetail = new DCPRenewalProductResponse.DCPOfferProductDetail();
            offerdetail.proposalId = proposalId;
            offerdetail.proposalType = cart.Apttus_QPConfig__Proposald__r.Digital_Quote_Type__c;
            offerdetail.productDetail = getProductDetail(cart,quantityRequest,productToQuantityToAmountMap);

            offerProductDetail.add(offerDetail);
        }
        return offerProductDetail;
    }

    //Builds the productDetail part of response
    private static List<DCPRenewalProductResponse.DCPProductDetail> getProductDetail(Apttus_Config2__ProductConfiguration__c cart,
        String quantityRequest, Map<String,Map<String,Decimal>> productToQuantityToAmountMap){

        List<DCPRenewalProductResponse.DCPProductDetail> productDetailList = new List<DCPRenewalProductResponse.DCPProductDetail>();

        //Iterate over all line items in cart and build response
        for(Apttus_Config2__LineItem__c lineItem : cart.Apttus_Config2__LineItems__r){
            DCPRenewalProductResponse.DCPProductDetail productDetail = new DCPRenewalProductResponse.DCPProductDetail();
            productDetail.productName = lineItem.APTS_Product_Name__c;
            productDetail.materialNumber = lineItem.Apttus_Config2__ProductId__r.ProductCode;
            productDetail.productId = lineItem.Apttus_Config2__ProductId__c;
            productDetail.quantity = Integer.valueOf(quantityRequest);
            productDetail.amount = getProductPricing(lineItem,quantityRequest,productToQuantityToAmountMap);
            productDetail.qualifier = lineItem.APTS_Product_Pricing_Model__c;
            productDetailList.add(productDetail);
        }

        return productDetailList;
    }

    //Gets the product pricing for the given amount.
    private static Decimal getProductPricing(Apttus_Config2__LineItem__c lineItem, String quantityRequest,
        Map<String,Map<String,Decimal>> productToQuantityToAmountMap){

        Decimal productPricing = 0;
        Decimal adjustmentAmount = lineItem.Apttus_Config2__AdjustmentAmount__c;
        String adjustmentType = lineItem.Apttus_Config2__AdjustmentType__c;

        //If Product has a price matrix and the requested quantity exits, then pull, adjust and round the amount, then set to map.
        if(productToQuantityToAmountMap.containsKey(lineItem.Apttus_Config2__ProductId__c)
            && productToQuantityToAmountMap.get(lineItem.Apttus_Config2__ProductId__c).containsKey(quantityRequest)){
            
            Decimal price = productToQuantityToAmountMap.get(lineItem.Apttus_Config2__ProductId__c).get(quantityRequest);
            price = getAdjustedPricing(price,adjustmentAmount,adjustmentType);
            price = price.setScale(2, RoundingMode.HALF_UP);
            productPricing = price;
        }

        return productPricing;
    }
    
    //Apply adjustments to a given amount
    private static Decimal getAdjustedPricing(Decimal price,Decimal adjustmentAmount,String adjustmentType){
        if(adjustmentAmount == null || String.isBlank(adjustmentType)){
            return price;
        }
        
        Decimal adjustedPrice = price;
        if(adjustmentType.equals('% Discount')){
            adjustedPrice = price - ((price * adjustmentAmount) / 100);
        }
        else if(adjustmentType.equals('% Markup')){
            adjustedPrice = price + ((price * adjustmentAmount) / 100);
        }

        return adjustedPrice;
    }
}