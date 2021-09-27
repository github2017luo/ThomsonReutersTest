/********************************************************************************
Class Name : DCPRenewalGetPriceMatrix 
@description : This class is used to pull pricing for carts
********************************************************************************
CHANGE HISTORY
===============================================================================
Date                            Developer                   Description
6-29-2021                      Benajmin Her                DCP-2265 Initial Creation
*********************************************************************************/ 
public without sharing class DCPRenewalGetPricingHelper{

    private static final String STR_DIMENSION1_NAME = 'Quantity';

    /**
        @description Queries all price matrix entries for all products in the provided carts
        @param proposalIDToCartMap Map of proposalId to Cart
        @return Returns a map of product Id to a map of its quantity->Price
     */
    public static Map<String,Map<String,Decimal>> queryPriceMatrix(Map<String,Apttus_Config2__ProductConfiguration__c> proposalIDToCartMap){

        Set<Id> cartProductIdSet = new Set<Id>();
        String customerPricingSegment;
        String digitalFirm;
        Set<String> attorneyCount = new Set<String>();
        List<Apttus_Config2__PriceMatrixEntry__c> priceMatrixEntries;
        
        //Iterate and store the cart's line items' product ID
        for(String proposalId : proposalIDToCartMap.keySet()){
            for(Apttus_Config2__LineItem__c lineItem : proposalIDToCartMap.get(proposalId).Apttus_Config2__LineItems__r){
                cartProductIdSet.add(lineItem.Apttus_Config2__ProductId__c);
            }

            //Gets fields from the SSD. This value should be the same for all proposals/carts that have been passed in.
            customerPricingSegment = proposalIDToCartMap.get(proposalId).APTS_SSD_bill_to__r.APTS_Apttus_Customer_Pricing_Segment__c;
            digitalFirm = proposalIDToCartMap.get(proposalId).APTS_SSD_bill_to__r.Digital_Firm__c;
        }

        //Gets a list of the incremental count from min to max attorney, used to pull Price Matrix Entries
        attorneyCount = getAttorneyCount(digitalFirm);

        priceMatrixEntries = 
            [SELECT Apttus_Config2__PriceMatrixId__r.Apttus_Config2__PriceListItemId__r.Apttus_Config2__ProductId__c,
                Apttus_Config2__PriceMatrixId__r.Apttus_Config2__PriceListItemId__r.Apttus_Config2__ProductId__r.ProductCode, 
                Apttus_Config2__Dimension1Value__c, Apttus_Config2__AdjustmentAmount__c, Apttus_Config2__AdjustmentType__c
            FROM  Apttus_Config2__PriceMatrixEntry__c   
            WHERE Apttus_Config2__PriceMatrixId__r.Apttus_Config2__Dimension1Id__r.name = :STR_DIMENSION1_NAME  
            AND Apttus_Config2__PriceMatrixId__r.Apttus_Config2__PriceListItemId__r.Apttus_Config2__ProductId__c IN :cartProductIdSet 
            AND Apttus_Config2__Dimension1Value__c IN : attorneyCount
            AND Apttus_Config2__Dimension2Value__c =: customerPricingSegment 
            WITH SECURITY_ENFORCED];

        Map<String,Map<String,Decimal>> productToQuantityToAmountMap = buildProductPriceMatrix(priceMatrixEntries);

        //Gets final, complete version of the product to quanity to quantity price map.
        productToQuantityToAmountMap = updateMissingPriceEntries(productToQuantityToAmountMap,digitalFirm);

        return productToQuantityToAmountMap;
    }

    //Builds a complex map that maps product Id to a map of the product's quantity to  product's price for that quantity
    private static Map<String,Map<String,Decimal>> buildProductPriceMatrix(List<Apttus_Config2__PriceMatrixEntry__c> priceMatrixEntries){

        Map<String,Map<String,Decimal>> productToQuantityToAmountMap = new Map<String,Map<String,Decimal>>();
        Map<String,String> productToMaterialNumberMap = new Map<String,String>();

        //Iterate over all price matrix entries and build productToQuantityToAmountMap
        for(Apttus_Config2__PriceMatrixEntry__c priceMatrixEntry : priceMatrixEntries){
            String productId = priceMatrixEntry.Apttus_Config2__PriceMatrixId__r.Apttus_Config2__PriceListItemId__r.Apttus_Config2__ProductId__c;
            String materialNumber = priceMatrixEntry.Apttus_Config2__PriceMatrixId__r.Apttus_Config2__PriceListItemId__r.Apttus_Config2__ProductId__r.ProductCode;
            String quantity = priceMatrixEntry.Apttus_Config2__Dimension1Value__c;
            Decimal amount = priceMatrixEntry.Apttus_Config2__AdjustmentAmount__c;
            //If productToQuantityToAmountMap contains a key, add new price entry to its quantityToAmount map
            if(productToQuantityToAmountMap.containsKey(productId)){
                productToQuantityToAmountMap.get(productId).put(quantity,amount);
            }
            else{ //Add new key-value for product and instantiate a new quantityToAmount map with price entry values
                productToQuantityToAmountMap.put(productId,new Map<String,Decimal>{quantity=>amount});
            }

            productToMaterialNumberMap.put(productId,materialNumber);
        }

        //Build response for product pricing while looping over price matrix entries
        //buildProductPricingResponse(productToQuantityToAmountMap,productToMaterialNumberMap);

        return productToQuantityToAmountMap;
    }

    //Populates any missing quantity/price in the map due to range pricing.
    private static Map<String,Map<String,Decimal>> updateMissingPriceEntries(Map<String,Map<String,Decimal>> productToQuantityToAmountMap, String digitalFirm){
        Integer minAttorney = Integer.valueOf(DCPRenewalSetting.getValue(digitalFirm + ' Minimum Attorneys'));
        Integer maxAttorney = Integer.valueOf(DCPRenewalSetting.getValue(digitalFirm + ' Maximum Attorneys'));

        if (productToQuantityToAmountMap == null){
            return productToQuantityToAmountMap;
        }

        //Iterate over all productIds found in the map key set
        for(String productId : productToQuantityToAmountMap.keySet()){
            Decimal ceilingAmount;
            //Iterate down over all attorney counts, starting from the highest
            for(Integer i = maxAttorney; i >= minAttorney; i--) {
                String quantity = String.valueOf(i);
                //If attorney count does not exist for the given price matrix quantity, use values equal to ceiling amount
                if(!productToQuantityToAmountMap.get(productId).containsKey(quantity)) {
                    //If no ceiling amount exists, set 'amount' to 0
                    if(ceilingAmount == null) {
                        ceilingAmount = 0;
                    }
                    productToQuantityToAmountMap.get(productId).put(quantity,ceilingAmount);
                }

                //Set 'ceilingAmount' as a the current price matrix
                ceilingAmount = productToQuantityToAmountMap.get(productId).get(quantity);
            }
        }

        return productToQuantityToAmountMap;
    }

    private static Set<String> getAttorneyCount(String digitalFirm){

        Set<String> attorneyCount = new Set<String>();
        Integer minAttorney = Integer.valueOf(DCPRenewalSetting.getValue(digitalFirm + ' Minimum Attorneys'));
        Integer maxAttorney = Integer.valueOf(DCPRenewalSetting.getValue(digitalFirm + ' Maximum Attorneys'));

        //Adding attorneys
        for(Integer i=minAttorney; i<= maxAttorney; i++){
            attorneyCount.add(String.valueOf(i));
        }//End of For loop
        System.debug(LOGGINGLEVEL.DEBUG,'attorneyCount:::'+attorneyCount);

        return attorneyCount;
    }
    
}