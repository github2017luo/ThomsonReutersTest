/********************************************************************************
Class Name : DCPRenewalGetPriceMatrix 
@description : This class is used to pull pricing for carts
********************************************************************************
CHANGE HISTORY
===============================================================================
Date                            Developer                   Description
6-29-2021                       Benajmin Her                DCP-2265 Initial Creation
7-19-2021                       Kavya S                     DCP-2654 Initial Creation
*********************************************************************************/ 
public without sharing class DCPRenewalGetPricing{
    private static final String STR_STRAIGHT_RENEWAL = 'Straight Renewal';

    /**
        @description Populates DCPPricingMatrix
        @param proposalIDToCartMap Map of proposal id to its cart
        @return Returns a list of pricing information
     */
    public static DCPRenewalPricingResponse.DCPPricingObject getPricing(Map<String,Apttus_Config2__ProductConfiguration__c> proposalIDToCartMap){
        
        DCPRenewalPricingResponse.DCPPricingObject data = new DCPRenewalPricingResponse.DCPPricingObject();
        List<DCPRenewalPricingResponse.DCPOfferPricing> offerPricingDetail = new List<DCPRenewalPricingResponse.DCPOfferPricing>();

        if(DCPRenewalSetting.renewalSettings == null || DCPRenewalSetting.renewalSettings.isEmpty()){
            DCPRenewalSetting.getRenewalSetting();
        }
        //Queries and build the pricing matrices for a product and its quanity and amount per quantity
        Map<String,Map<String,Decimal>> productToQuantityToAmountMap = DCPRenewalGetPricingHelper.queryPriceMatrix(proposalIDToCartMap);

        Map<String,List<DCPRenewalPricingResponse.DCPPricingMatrix>> proposalToPricingMatrixMap = populatePriceMatrix(proposalIDToCartMap,productToQuantityToAmountMap);
        Map<String,List<DCPRenewalPricingResponse.DCPSavingMatrix>> proposalToSavingMatrixMap = DCPRenewalGetSaving.populateSavingMatrix(proposalIDToCartMap, proposalToPricingMatrixMap);
        
        for(String proposalId : proposalToPricingMatrixMap.keySet()){
            Apttus_Config2__ProductConfiguration__c cart = proposalIDToCartMap.get(proposalId);
            DCPRenewalPricingResponse.DCPOfferPricing pricingDetail = new DCPRenewalPricingResponse.DCPOfferPricing();
            pricingDetail.proposalId = proposalId;
            pricingDetail.proposalType = cart.Apttus_QPConfig__Proposald__r.Digital_Quote_Type__c;
            pricingDetail.priceMatrix = proposalToPricingMatrixMap.get(proposalId);
            pricingDetail.savingMatrix = proposalToSavingMatrixMap.get(proposalId);
            offerPricingDetail.add(pricingDetail);
        }

        data.offerPricingDetail = offerPricingDetail;

        return data;
    }

    private static Map<String,List<DCPRenewalPricingResponse.DCPPricingMatrix>> populatePriceMatrix(Map<String,Apttus_Config2__ProductConfiguration__c> proposalIDToCartMap,
        Map<String,Map<String,Decimal>> productToQuantityToAmountMap){
        Map<String,List<DCPRenewalPricingResponse.DCPPricingMatrix>> proposalToPricingMatrixMap = new Map<String,List<DCPRenewalPricingResponse.DCPPricingMatrix>>();

        //Iterate over map key to get cart
        for(String proposalId : proposalIDToCartMap.keySet()){
            
            Apttus_Config2__ProductConfiguration__c cart = proposalIDToCartMap.get(proposalId);
            List<DCPRenewalPricingResponse.DCPPricingMatrix> priceMatrices = new List<DCPRenewalPricingResponse.DCPPricingMatrix>();
            
            priceMatrices = buildProposalPricingMatrix(cart,productToQuantityToAmountMap);

            proposalToPricingMatrixMap.put(proposalId,priceMatrices);

        }
        return proposalToPricingMatrixMap;
    }

    private static List<DCPRenewalPricingResponse.DCPPricingMatrix> buildProposalPricingMatrix(Apttus_Config2__ProductConfiguration__c cart,
        Map<String,Map<String,Decimal>> productToQuantityToAmountMap){
        
        List<DCPRenewalPricingResponse.DCPPricingMatrix> priceMatrices = new List<DCPRenewalPricingResponse.DCPPricingMatrix>();

        //For straight renewals, the displayed price is different based on the contract term due to YOY calculation
        if(cart.Apttus_QPConfig__Proposald__r.Digital_Quote_Type__c.equals(STR_STRAIGHT_RENEWAL)){
            DCPRenewalPricingResponse.DCPPricingMatrix priceMatrix = new DCPRenewalPricingResponse.DCPPricingMatrix();
            priceMatrix.quantity = Integer.valueOf(cart.Apttus_Config2__LineItems__r[0].Apttus_Config2__Quantity__c);
            priceMatrix.contractTermPricing = getContractTermPricing(cart,cart.Rollup_Net_Price__c);
            priceMatrices.add(priceMatrix);
        }
        else{
            Map<String,Decimal> quantityToTotalPriceMap = new Map<String,Decimal>();
            quantityToTotalPriceMap = buildQuantityToTotalPriceMap(cart,productToQuantityToAmountMap);

            for(String quantityKey : quantityToTotalPriceMap.keySet()){
                DCPRenewalPricingResponse.DCPPricingMatrix priceMatrix = new DCPRenewalPricingResponse.DCPPricingMatrix();
                priceMatrix.quantity = Integer.valueOf(quantityKey);
                priceMatrix.contractTermPricing = getContractTermPricing(cart,quantityToTotalPriceMap.get(quantityKey));
                priceMatrices.add(priceMatrix);
            }
        }

        return priceMatrices;
    }

    private static Map<String,Decimal> buildQuantityToTotalPriceMap(Apttus_Config2__ProductConfiguration__c cart,
        Map<String,Map<String,Decimal>> productToQuantityToAmountMap){
        
        Map<String,Decimal> quantityToTotalPriceMap = new Map<String,Decimal>();
    
        for(Apttus_Config2__LineItem__c lineItem : cart.Apttus_Config2__LineItems__r){
            if(productToQuantityToAmountMap.containsKey(lineItem.Apttus_Config2__ProductId__c)){
                Map<String,Decimal> quantityToAmountMap = productToQuantityToAmountMap.get(lineItem.Apttus_Config2__ProductId__c);
                for(String quantityKey : quantityToAmountMap.keySet()){
                    if(quantityToTotalPriceMap.containsKey(quantityKey)){
                        Decimal quantityTotalPrice = quantityToTotalPriceMap.get(quantityKey);
                        quantityTotalPrice += quantityToAmountMap.get(quantityKey);
                        quantityToTotalPriceMap.put(quantityKey,quantityTotalPrice);
                    }
                    else{
                        quantityToTotalPriceMap.put(quantityKey,quantityToAmountMap.get(quantityKey));
                    }
                }
            }
        }

        return quantityToTotalPriceMap;
    }
    
    private static Map<String,Decimal> getContractTermPricing(Apttus_Config2__ProductConfiguration__c cart,Decimal totalPrice){
        Map<String,Decimal> contractTermPricing = new Map<String,Decimal>();
        Decimal adjustmentAmount = cart.Apttus_Config2__LineItems__r[0].Apttus_Config2__AdjustmentAmount__c;
        String adjustmentType = cart.Apttus_Config2__LineItems__r[0].Apttus_Config2__AdjustmentType__c;
        //For straight renewals, the displayed price is different based on the contract term due to YOY calculation
        if(cart.Apttus_QPConfig__Proposald__r.Digital_Quote_Type__c.equals(STR_STRAIGHT_RENEWAL)){
            contractTermPricing = getRenewalPricing(cart,totalPrice);
        }
        else{ //For non-straight renewals, there is no displayed price difference between different contract terms.
            Decimal adjustedTotalPrice = getAdjustedPricing(totalPrice,adjustmentAmount,adjustmentType);
            adjustedTotalPrice = adjustedTotalPrice.setScale(2, RoundingMode.HALF_UP);
            contractTermPricing.put('1',adjustedTotalPrice);
            contractTermPricing.put('2',adjustedTotalPrice);
            contractTermPricing.put('3',adjustedTotalPrice);
        }

        return contractTermPricing;
    }

    private static Decimal getAdjustedPricing(Decimal totalPrice,Decimal adjustmentAmount,String adjustmentType){
        if(adjustmentAmount == null || String.isBlank(adjustmentType)){
            return totalPrice;
        }
        
        Decimal adjustedTotalPrice = totalPrice;
        if(adjustmentType.equals('% Discount')){
            adjustedTotalPrice = totalPrice - ((totalPrice * adjustmentAmount) / 100);
        }
        else if(adjustmentType.equals('% Markup')){
            adjustedTotalPrice = totalPrice + ((totalPrice * adjustmentAmount) / 100);
        }

        return adjustedTotalPrice;
    }
    private static Map<String,Decimal> getRenewalPricing(Apttus_Config2__ProductConfiguration__c cart,Decimal totalPrice){
        
        Map<String,Decimal> contractTermPricing = new Map<String,Decimal>();

        //Iterates 3 times since we can have atmost term lengths of 3 years
        for(Integer termLength=1; termLength<=3; termLength++){

            String contractTerm = termLength == 1 ? '1 Year' : termLength + ' Years';
            Decimal yearOnYearRate;
            Decimal yoyPricing;

            //Populates offerDetails based on cart data or defaulted data
            if(isSelectedTerm(cart.Apttus_Config2__LineItems__r[0].APTS_Contract_Term__c,contractTerm)){
                String offerYOYRate = contractTerm == '1 Year' ? cart.Apttus_Config2__LineItems__r[0].APTS_Yr_1_Renewal_Adjustment__c
                    : cart.Apttus_Config2__LineItems__r[0].APTS_Years_2_Plus_Adjustment__c;

                yearOnYearRate = Decimal.valueOf(offerYOYRate);
            }
            else if(termLength == 1){
                yearOnYearRate = Decimal.valueOf(DCPRenewalSetting.getValue('Default_Renewal_Rate'));    
            }else if (termLength == 2){ 
                yearOnYearRate = Decimal.valueOf(DCPRenewalSetting.getValue('Default_Renewal_Rate_2_Year'));
            }else{
                yearOnYearRate = Decimal.valueOf(DCPRenewalSetting.getValue('Default_Renewal_Rate_3_Year'));
            }
            
            yoyPricing = ((totalPrice * yearOnYearRate) / 100) + totalPrice ;
            yoyPricing = yoyPricing.setScale(2, RoundingMode.HALF_UP);
            contractTermPricing.put(String.valueOf(termLength),yoyPricing);
        }

        return contractTermPricing;
    }

    /**
        @description Determines if the contract term of the cart matches the built offer
        @param aptsContractTerm Contract term of the cart
        @param offerContractTerm Contract term of the offer
        @return Returns boolean
     */
    public static boolean isSelectedTerm(String aptsContractTerm , String offerContractTerm ){
        
        if(aptsContractTerm == offerContractTerm){
            return true;
        }else{
            return false;
        }
    }
}