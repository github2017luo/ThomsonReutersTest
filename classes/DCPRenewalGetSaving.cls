/********************************************************************************
Class Name : DCPRenewalGetSaving
@description : This class is used to pull savings for carts
********************************************************************************
CHANGE HISTORY
===============================================================================
Date                            Developer                   Description
6-29-2021                       Benajmin Her                DCP-2654 Initial Creation
7-19-2021                       Kavya S                     DCP-2654  Saving Matrix Implementation
*********************************************************************************/ 
public without sharing class DCPRenewalGetSaving{

    private static final String STR_STRAIGHT_RENEWAL = 'Straight Renewal';
    /**
        @description Builds the saving matrices for the offer
        @param proposalIDToCartMap Map of proposal id to cart
        @param proposalToPricingMatrixMap Map of proposal id to its pricing matrices
        @return Returns a map of a proposal id to its saving matrices
     */
    public static Map<String,List<DCPRenewalPricingResponse.DCPSavingMatrix>> populateSavingMatrix(Map<String,Apttus_Config2__ProductConfiguration__c> proposalIDToCartMap, 
        Map<String,List<DCPRenewalPricingResponse.DCPPricingMatrix>> proposalToPricingMatrixMap){

        Map<String,List<DCPRenewalPricingResponse.DCPSavingMatrix>> proposalToSavingMatrixMap = new  Map<String,List<DCPRenewalPricingResponse.DCPSavingMatrix>>();

        //Iterate over map key to get cart
        for(String proposalId : proposalIDToCartMap.keySet()){
            
            Apttus_Config2__ProductConfiguration__c cart = proposalIDToCartMap.get(proposalId);
            List<DCPRenewalPricingResponse.DCPPricingMatrix> pricingMatrices = proposalToPricingMatrixMap.get(proposalId);

            List<DCPRenewalPricingResponse.DCPSavingMatrix> savingMatrices = new List<DCPRenewalPricingResponse.DCPSavingMatrix>();
            
            savingMatrices = buildProposalSavingMatrix(cart,pricingMatrices);

            proposalToSavingMatrixMap.put(proposalId,savingMatrices);

        }

        return proposalToSavingMatrixMap;
    }

    private static List<DCPRenewalPricingResponse.DCPSavingMatrix> buildProposalSavingMatrix(Apttus_Config2__ProductConfiguration__c cart,
        List<DCPRenewalPricingResponse.DCPPricingMatrix> pricingMatrices){

        List<DCPRenewalPricingResponse.DCPSavingMatrix> savingMatrices = new List<DCPRenewalPricingResponse.DCPSavingMatrix>();
        Map<String,Decimal> contractTermToYOYRateMap = getYOYRateForCart(cart);

        for(DCPRenewalPricingResponse.DCPPricingMatrix pricematrix : pricingMatrices){
            DCPRenewalPricingResponse.DCPSavingMatrix savingMatrix = new DCPRenewalPricingResponse.DCPSavingMatrix();
            savingMatrix.quantity = pricematrix.quantity;
            if(cart.Apttus_QPConfig__Proposald__r.Digital_Quote_Type__c.equals(STR_STRAIGHT_RENEWAL)){
                Map<String,Decimal> straightRenewalPrice = new Map<String,Decimal>{'1'=>cart.Rollup_Net_Price__c,'2'=>cart.Rollup_Net_Price__c,'3'=>cart.Rollup_Net_Price__c};
                savingMatrix.contractTermSaving = getContractTermSaving(contractTermToYOYRateMap,straightRenewalPrice);
            }
            else{
                savingMatrix.contractTermSaving = getContractTermSaving(contractTermToYOYRateMap,pricematrix.contractTermPricing);
            }

            savingMatrices.add(savingMatrix);
        }

        return savingMatrices;
    }

    private static Map<String,Decimal> getContractTermSaving(Map<String,Decimal> contractTermToYOYRateMap,Map<String,Decimal> contractTermPricing){
        
        Map<String,Decimal> contractTermSaving = new Map<String,Decimal>();
        Decimal highestRate = getHighestRate(contractTermToYOYRateMap);
        highestRate = (1+(highestRate/100));

        for(String contractTerm : contractTermToYOYRateMap.keySet()){
            Decimal yoyRate = (1+(contractTermToYOYRateMap.get(contractTerm)/100));
            Decimal yearlyPrice = contractTermPricing.get(contractTerm)*12;

            //Calculates the saving by finding difference of the price totaled over 3 years with a % increase wth the highest percentage vs current percentage
            Decimal saving = yearlyPrice * ((highestRate+highestRate.pow(2)+highestRate.pow(3)) - (yoyRate+yoyRate.pow(2)+yoyRate.pow(3)));
            saving = saving.setScale(2, RoundingMode.HALF_UP);
            contractTermSaving.put(contractTerm,saving);
        }

        return contractTermSaving;
    }

    private static Decimal getHighestRate(Map<String,Decimal> contractTermToYOYRateMap){
        Decimal highestRate = 0;
        for(String contractTerm : contractTermToYOYRateMap.keySet()){
            if(highestRate <= contractTermToYOYRateMap.get(contractTerm)){
                highestRate = contractTermToYOYRateMap.get(contractTerm);
            }
        }
        return highestRate;
    }

    private static Map<String,Decimal> getYOYRateForCart(Apttus_Config2__ProductConfiguration__c cart){

        Map<String,Decimal> contractTermToYOYRateMap = new Map<String,Decimal>();

        //Iterates 3 times since we can have atmost term lengths of 3 years
        for(Integer termLength=1; termLength<=3; termLength++){

            String contractTerm = termLength == 1 ? '1 Year' : termLength + ' Years';
            Decimal yearOnYearRate;

            //Populates offerDetails based on cart data or defaulted data
            if(DCPRenewalGetPricing.isSelectedTerm(cart.Apttus_Config2__LineItems__r[0].APTS_Contract_Term__c,contractTerm)){
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
            
            contractTermToYOYRateMap.put(String.valueOf(termLength),yearOnYearRate);
        }

        return contractTermToYOYRateMap;
    }
}