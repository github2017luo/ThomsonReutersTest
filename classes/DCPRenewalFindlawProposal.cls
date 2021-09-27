/********************************************************************************
Class Name : DCPRenewalFindlawProposal
@description : This class is used by DCPGetRenewal class to populate findlaw proposal JSON data.
***************************************************************************************

Modification Details
Date              Description                                                               Owner
08/11/2021        DCP-3498 Class Created                                                    Benjamin Her
*********************************************************************************/

public without sharing class DCPRenewalFindlawProposal{

    /**
        @description Populates proposal data that is required in Findlaw scenario
        @param cart Cart data of the offer
        @param proposalWrapper Proposal Response to be updated with Findlaw exclusive data
     */
    public static void populateFindLawProposal(Apttus_Config2__ProductConfiguration__c cart,DCPRenewalProposalWrapper proposalWrapper){

        if(cart.APTS_Proposal_Business_Unit__c != 'FindLaw'){
            return;
        }

        updateFindLawPrice(cart,proposalWrapper);
        updateFindLawOfferDetail(cart, proposalWrapper);
    }
    
    private static void updateFindLawPrice(Apttus_Config2__ProductConfiguration__c cart,DCPRenewalProposalWrapper proposalWrapper){
        proposalWrapper.newMonthlyPrice = getFLNewPrice(cart,proposalWrapper);
        proposalWrapper.currentMonthlyPrice = getFLCurrentPrice(cart);

        //Only get retailPrice AFTER getting updated currentMonthlyPrice
        proposalWrapper.retailPrice = getRetailPrice(cart,proposalWrapper);
    }

    //Gets the newMonthlyPrice for Findlaw.
    /*
    In CXD, when a cart is created, a default discount is applied to each line item based on the contract term for the cart.
    This method recalculates the newMonthlyPrice as a value that is NOT modified by a default discount.
    */
    private static Decimal getFLNewPrice(Apttus_Config2__ProductConfiguration__c cart,DCPRenewalProposalWrapper proposalWrapper){
        Decimal newPrice =0.0;
        Decimal defaultDiscount = getFLDefaultDiscount(proposalWrapper.selectedContractTerm);

        for(Apttus_Config2__LineItem__c lineItem : cart.Apttus_Config2__LineItems__r){

            //Get net price from the asset as the current price
            if(lineItem.Apttus_Config2__AssetLineItemId__c != null){
                
                Decimal adjustedPrice = lineItem.Apttus_Config2__BasePrice__c;
                Decimal adjustment = (lineItem.Apttus_Config2__AdjustmentAmount__c != null) ? lineItem.Apttus_Config2__AdjustmentAmount__c : 0;
                if(lineItem.Apttus_Config2__AdjustmentType__c == '% Markup'){
                    adjustment = adjustment + defaultDiscount;
                    adjustedPrice = adjustedPrice * (1 + (adjustment/100));
                }
                else{
                    adjustment = adjustment - defaultDiscount;
                    adjustedPrice = adjustedPrice * (1 - (adjustment/100));
                }

                newPrice += adjustedPrice;
            }
        }
        return newPrice.setScale(2, RoundingMode.HALF_UP);

    }
    
    //Sets the currentMonthlyPrice for Findlaw offers
    private static Decimal getFLCurrentPrice(Apttus_Config2__ProductConfiguration__c cart){
        decimal currentPrice =0.0;

        for(Apttus_Config2__LineItem__c lineItem : cart.Apttus_Config2__LineItems__r){

            //Get net price from the asset as the current price
            if(lineItem.Apttus_Config2__AssetLineItemId__c != null){

                currentPrice += lineItem.Apttus_Config2__AssetLineItemId__r.Apttus_Config2__NetPrice__c; 
            }
        }
        return currentPrice.setScale(2, RoundingMode.HALF_UP);
    }

    //Sets the retail price of the offer
    private static Decimal getRetailPrice(Apttus_Config2__ProductConfiguration__c cart,DCPRenewalProposalWrapper proposalWrapper){
        
        Decimal offerPrice = proposalWrapper.currentMonthlyPrice;

        Decimal staticIncrease = Decimal.valueOf(DCPRenewalSetting.getValue('FindLaw_Static_MTM_Increase'));
        Decimal staticIncreasePrice = offerPrice + staticIncrease;

        Decimal percentIncrease = Decimal.valueOf(DCPRenewalSetting.getValue('FindLaw_Percent_MTM_Increase'));
        Decimal percentIncreasePrice = offerPrice * (1 + (percentIncrease/100));

        /*
        Retail Price is the lowest of the three possible values:
        1. Sum of the List Price for all line items
        2. Net Price of the cart plus a static amount increase
        3. Net Price of the cart plus a percent amount increase
        */
        Decimal retailPrice = 0;
        for(Apttus_Config2__LineItem__c lineItem : cart.Apttus_Config2__LineItems__r){
            retailPrice += lineItem.Apttus_Config2__ListPrice__c;
        }
        if(retailPrice >= staticIncreasePrice){
            retailPrice = staticIncreasePrice;
        }

        if(retailPrice >= percentIncreasePrice){
            retailPrice = percentIncreasePrice;
        }

        return retailPrice.setScale(2, RoundingMode.HALF_UP);
    }
    
    private static void updateFindLawOfferDetail(Apttus_Config2__ProductConfiguration__c cart,DCPRenewalProposalWrapper proposalWrapper){
        getFindlawPricing(cart, proposalWrapper);
        getFindLawSaving(proposalWrapper);
    }

    private static void getFindlawPricing(Apttus_Config2__ProductConfiguration__c cart,DCPRenewalProposalWrapper proposalWrapper){
        
        //Iterate over DCPOfferDetails and set the "pricing".
        //FindLaw does NOT use YOY calculation, but does have default discount based on the contract term.
        for(DCPOfferDetails offer : proposalWrapper.offerDetails){

            Decimal offerPrice = getFindLawOfferPrice(cart,proposalWrapper,offer);
            for(DCPOfferDetails.DCPPricingDetails priceDetails : offer.pricing){
                priceDetails.price = offerPrice.setScale(2, RoundingMode.HALF_UP);
            }
        }
    }

    private static Decimal getFindLawOfferPrice(Apttus_Config2__ProductConfiguration__c cart,DCPRenewalProposalWrapper proposalWrapper,DCPOfferDetails offer){
        
        Decimal defaultDiscount = getFLDefaultDiscount(proposalWrapper.selectedContractTerm);
        Decimal contractTermDiscount = getFLDefaultDiscount(offer.contractTerm);
        Decimal offerPrice = 0.0;
        for(Apttus_Config2__LineItem__c lineItem : cart.Apttus_Config2__LineItems__r){

            //Get net price from the asset as the current price
            if(lineItem.Apttus_Config2__AssetLineItemId__c != null){
                
                Decimal adjustedPrice = lineItem.Apttus_Config2__BasePrice__c;
                Decimal adjustment = (lineItem.Apttus_Config2__AdjustmentAmount__c != null) ? lineItem.Apttus_Config2__AdjustmentAmount__c : 0;
                if(lineItem.Apttus_Config2__AdjustmentType__c == '% Markup'){
                    adjustment = adjustment - (contractTermDiscount - defaultDiscount);
                    adjustedPrice = adjustedPrice * (1 + (adjustment/100));
                }
                else{
                    adjustment = adjustment + (contractTermDiscount - defaultDiscount);
                    adjustedPrice = adjustedPrice * (1 - (adjustment/100));
                }

                offerPrice += adjustedPrice;
            }
        }

        return offerPrice.setScale(2, RoundingMode.HALF_UP);
    }
    
    private static void getFindLawSaving(DCPRenewalProposalWrapper proposalWrapper){
        //Iterate over DCPOfferdetails to get hightest price and total yearly price per contract term
        for(DCPOfferDetails offer : proposalWrapper.offerDetails){
            Integer contractTerm = Integer.valueOf(offer.contractTerm.left(1));
            Decimal saving = (proposalWrapper.retailPrice - offer.pricing[0].price) * 12 * contractTerm;
            offer.savingPrice = saving.setScale(2, RoundingMode.HALF_UP);
        }
    }

    private static Decimal getFLDefaultDiscount(String contractTerm){

        switch on contractTerm{
            when '3 Years'{
                return Decimal.valueOf(DCPRenewalSetting.getValue('FindLaw_3_Year_Discount'));
            }
            when '2 Years'{
                return Decimal.valueOf(DCPRenewalSetting.getValue('FindLaw_2_Year_Discount'));
            }
            when else{
                return 0.0;
            }
        }
    }
}