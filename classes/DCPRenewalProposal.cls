/********************************************************************************
Class Name : DCPRenewalProposal
@description : This class is used by DCPGetRenewal class to populate Proposal JSON data.
***************************************************************************************

Modification Details
Date             Description                                                              Owner
15/04/2021        Class Created                                                            By Herin Acharya
22/04/2021        Updated getDCPProposalDetails method                                     Vishnu Santhosh
28/04/2021        Changed instance names to follow Apex pmd rules                          Vishnu Santhosh
05/05/2021        DCP-1114|Added the Renewal End date calculation                          Vishnu Santhosh
06/05/2021        DCP-1124|Added the selected Contract term                                Herin Acharya
14/06/2021        DCP-1111|Added the getProductDetails method                              Vishnu Santhosh
14/06/2021        DCP-1705|Added 'isEditable' logic                                        Benjamin Her
14/07/2021        DCP-2215|Added the additional flag 'Edge'logic                           Sudhanshu Upadhayay
15/07/2021        DCP-2144|Migrated 'getProductDetails' method to DCPRenewalProduct Class  Vishnu Santhosh
16/07/2021        DCP-2144|Added 'prop' to the method in proposalWrapper.products          Vishnu Santhosh
26/07/2021        DCP-2682|Added check for NTO(New To Online)                              Himanshu Sharma
08/09/2021        DCP-4671|Fix marketSegment assignment for Findlaw                        Benjamin Her
*********************************************************************************/

public without sharing class DCPRenewalProposal{
    
    /**
@description Gets the list of populated proposal wrapper objects
@param propList List of proposal ids to query
@param proposalIDToCartMap Map of Proposal Id : Cart value pairs for querying corresponding cart data.
@param opp Opportunity Object to calculate the Renewal End Date
@return Returns list of populated Proposal Wrapper Objects
*/
    public static List<DCPRenewalProposalWrapper> getProposalDetails(List<Apttus_Proposal__Proposal__c> propList,Map<String,Apttus_Config2__ProductConfiguration__c> proposalIDToCartMap,Opportunity opp){  
        
        List<DCPRenewalProposalWrapper> wrapperList = new List<DCPRenewalProposalWrapper>();
        
        for(Apttus_Proposal__Proposal__c prop : propList){
            wrapperList.add(populateProposalDetail(prop,proposalIDToCartMap, opp));
        }      
        return wrapperList;
        
    }
    
    //Populates the response wrapper
    private static DCPRenewalProposalWrapper populateProposalDetail(Apttus_Proposal__Proposal__c prop,Map<String,Apttus_Config2__ProductConfiguration__c> proposalIDToCartMap,Opportunity opp){
        
        Apttus_Config2__ProductConfiguration__c cart = proposalIDToCartMap.get(prop.Id);
        // Initialize Proposal Wrapper
        DCPRenewalProposalWrapper proposalWrapper = new DCPRenewalProposalWrapper(); 
        proposalWrapper.proposalId = prop.id;
        proposalWrapper.defaultRenewalRate = Decimal.valueOf(DCPRenewalSetting.getValue('Default_Renewal_Rate'));
        proposalWrapper.isPrimary = prop.Apttus_Proposal__Primary__c;
        proposalWrapper.proposalType = prop.Digital_Quote_Type__c;
        proposalWrapper.marketSegment = (cart.APTS_Proposal_Business_Unit__c == 'FindLaw') ? cart.APTS_Proposal_Business_Unit__c : prop.APTS_Approval_Segment__c;
        proposalWrapper.paymentMethod = prop.APTS_Payment_Option__c;
        proposalWrapper.currencyCode = prop.CurrencyIsoCode;
        proposalWrapper.docusignid = prop.DocuSign_Envelope_ID__c; //Added by priyanka
        proposalWrapper.quantity = Integer.valueOf((cart).Apttus_Config2__LineItems__r[0].Apttus_Config2__Quantity__c);
        proposalWrapper.cartId = cart.id;
        //Checks and use line item billing frequency field else set to 'Monthly'
        if(String.isNotBlank((cart).Apttus_Config2__LineItems__r[0].Apttus_Config2__BillingFrequency__c)){
            proposalWrapper.billingFrequency = (cart).Apttus_Config2__LineItems__r[0].Apttus_Config2__BillingFrequency__c;
        }
        else{
            proposalWrapper.billingFrequency = 'Monthly';
        }
        
        // Added "selectedCotractTerm" parameter - Herin Acharya
        if(String.isNotBlank((cart).Apttus_Config2__LineItems__r[0].APTS_Contract_Term__c)){
            proposalWrapper.selectedContractTerm = (cart).Apttus_Config2__LineItems__r[0].APTS_Contract_Term__c;
        }
        
        proposalWrapper.isEditable = getIsEditable(prop,proposalIDToCartMap);
        
        Decimal currentMonthlyPrice= (cart).APTS_Current_Holdings__c;
        proposalWrapper.currentMonthlyPrice = currentMonthlyPrice; 
        
       //Decimal newMonthlyPrice = (cart).Rollup_Net_Price__c;


        if(proposalIDToCartMap.containsKey(prop.Id)){
            proposalWrapper.offerDetails = getOfferDetails(cart,opp);
            proposalWrapper.products = DCPRenewalProduct.getProductDetails(cart,prop);
        }
        
       
        proposalWrapper = calculateTotalPrice(proposalWrapper, prop, proposalIDToCartMap);
    
        
        //DCP-2682 starts
        // To identify the contract type of the offer (New Mid Contract, Old Mid Contract, Ingelligible, NTO)
        if(DCPUtility.isNTOCustomer(cart)){
             proposalWrapper.contractType = 'NTO';
        }
        else{
            proposalWrapper.contractType = cart.Apttus_QPConfig__Proposald__r.Contract_Type__c;
        }
        //DCP-2682 ends
        
        DCPRenewalFindlawProposal.populateFindLawProposal(cart,proposalWrapper);
        
        return proposalWrapper;
    }
    
    private static DCPRenewalProposalWrapper calculateTotalPrice(DCPRenewalProposalWrapper proposalWrapper, Apttus_Proposal__Proposal__c prop,Map<String,Apttus_Config2__ProductConfiguration__c> proposalIDToCartMap){
        
        
        Decimal newMonthlyPrice = (proposalIDToCartMap.get(prop.Id)).Rollup_Net_Price__c;
        
        if(proposalWrapper.proposalType == 'Manual' && proposalIDToCartMap.get(prop.Id).Apttus_Config2__LineItems__r.size()>0
           && proposalIDToCartMap.get(prop.Id).Apttus_Config2__LineItems__r[0].Apttus_Config2__LineStatus__c == 'Renewed' 
          ){
              Apttus_Config2__ProductConfiguration__c cartForProp = proposalIDToCartMap.get(prop.Id);
              
              if(cartForProp.Apttus_Config2__LineItems__r[0].APTS_Contract_Term__c != null){
                  String offerYOYRateC = cartForProp.Apttus_Config2__LineItems__r[0].APTS_Contract_Term__c == '1 Year' ? cartForProp.Apttus_Config2__LineItems__r[0].APTS_Yr_1_Renewal_Adjustment__c: cartForProp.Apttus_Config2__LineItems__r[0].APTS_Years_2_Plus_Adjustment__c;
                  
                  Decimal yearlyRate = Decimal.valueOf(offerYOYRateC);
                  newMonthlyPrice = ((newMonthlyPrice * yearlyRate) / 100) + newMonthlyPrice ;// for price calculation  
              }
              
              
          }
        proposalWrapper.newMonthlyPrice = newMonthlyPrice ; 
        
        return proposalWrapper;   
    }
    
    //Method determines if offer is editable based on its contract term
    private static Boolean getIsEditable(Apttus_Proposal__Proposal__c prop,Map<String,Apttus_Config2__ProductConfiguration__c> proposalIDToCartMap){
        //Offer is not editable if contract term is '3 Years'.
        if(proposalIDToCartMap.containsKey(prop.id) 
           && proposalIDToCartMap.get(prop.Id).Apttus_Config2__LineItems__r[0].APTS_Contract_Term__c == '3 Years'){
               
               return false;
           }
        return true;
    }
    
    //Populates the offer details response
    private static List<DCPOfferdetails> getOfferDetails(Apttus_Config2__ProductConfiguration__c cart,Opportunity opp){

        List<DCPOfferdetails> offerDetails = new List <DCPOfferdetails>();
        System.debug(LoggingLevel.DEBUG, '*** DEBUGGING FROM DEV *** >> Cart First Line Item  :  '+ cart.Apttus_Config2__LineItems__r[0]);
        //Iterates 3 times since we can have atmost term lengths of 3 years
        for(Integer termLength=1; termLength<=3; termLength++){
            
            DCPOfferDetails offerDetail = populateOfferDetails(termLength,cart);
            offerDetail.renewalEndDate = opp.Renewal_Date__c.addYears(termLength);                        
            offerDetails.add(offerDetail);
        }
        
        offerDetails = calculateSavingPrice(offerDetails);
        //Round off all the pricing at the end to ensure smaller pricing discrepanices
        offerDetails = roundPricing(offerDetails);
        return offerDetails;
    }
    
    /* created this method to make code more redable. 
This method will return true if the selected term and apptus contrcat term is same.
- by Herin Acharya */
    
    private static boolean isSelectedTerm(String aptsContractTerm , String offerContractTerm ){
        
        if(aptsContractTerm == offerContractTerm){
            return true;
        }else{
            return false;
        }
    }
    
    /**
@description Calculation of Saving Prices for Year 1, Year 2 and Year 3 Contract Terms
@param offDetails List of Offer Details for calculation
@return Returns Offer Details List with Saving price value populated.
*/
    private static List<DCPOfferdetails> calculateSavingPrice(list<DCPOfferDetails> offDetails){
        
        List<DCPOfferdetails> offerDetails = offDetails;
        decimal highestPrice = 0;
        Map<String, decimal> contractTermToPriceMap = new Map<String, decimal>();
        
        //Iterate over DCPOfferdetails to get hightest price and total yearly price per contract term
        for(DCPOfferDetails offer : offerDetails){
            decimal offerTotalMonthlyPrice = 0;
            decimal totalYearlyPrice;
            for(DCPOfferDetails.DCPPricingDetails dcpprice : offer.pricing){
                offerTotalMonthlyPrice += dcpprice.price;
            }
            
            totalYearlyPrice = offerTotalMonthlyPrice  * 12;
            contractTermToPriceMap.put(offer.contractTerm, totalYearlyPrice);
            if(totalYearlyPrice > highestPrice){
                highestPrice = totalYearlyPrice ;
            }
        }
        
        //Iteratte over DCPOfferdetails to populate the savingPrice
        for(DCPOfferDetails offer : offerDetails){
            offer.savingPrice = highestPrice - contractTermToPriceMap.get(offer.contractTerm);
        }
        
        return offerDetails;
    }
    
    private static List<DCPOfferdetails> roundPricing(list<DCPOfferDetails> offDetails){
        
        List<DCPOfferdetails> offerDetails = offDetails;
        for(DCPOfferDetails offer : offerDetails){
            offer.savingPrice = offer.savingPrice.setScale(2, RoundingMode.HALF_UP);
            for(DCPOfferDetails.DCPPricingDetails dcpprice : offer.pricing){
                dcpprice.price = dcpprice.price.setScale(2, RoundingMode.HALF_UP);
            }
        }
        return offerDetails;
        
    }
    private static list<DCPOfferDetails.DCPPricingDetails> getDCPPricingDetails(decimal currentMonthlyPrice , decimal yearlyRate){
        
        DCPOfferDetails.DCPPricingDetails pricingDetails;   
        list<DCPOfferDetails.DCPPricingDetails> pricingDetailsList = new list<DCPOfferDetails.DCPPricingDetails> (); 
        
        
        for(Integer termLength = 1 ; termLength <= 3; termLength++){
            pricingDetails = new DCPOfferDetails.DCPPricingDetails();
            currentMonthlyPrice = ((currentMonthlyPrice * YearlyRate) / 100) + currentMonthlyPrice ;
            pricingDetails.year = termLength;
            pricingDetails.price = currentMonthlyPrice;
            pricingDetailsList.add(pricingDetails);                  
        }
        
        return pricingDetailsList ;      
    }
    
    // populateYearOnYearRate() - created by Herin Acharya to fix PMD violations for deployment of DCP-2743
    private static Decimal populateYearOnYearRate(Integer termLength){
        
        switch on termLength{
            when 1 {        // when block 1
                return Decimal.valueOf(DCPRenewalSetting.getValue('Default_Renewal_Rate'));
            }
            when 2 {        // when block 2
                return Decimal.valueOf(DCPRenewalSetting.getValue('Default_Renewal_Rate_2_Year'));
            }
            when else {        // when else 
                return Decimal.valueOf(DCPRenewalSetting.getValue('Default_Renewal_Rate_3_Year'));
            }
        }
    }
    
    // populateOfferDetails() - created by Herin Acharya to fix PMD violations for deployment of DCP-2743
    private static DCPOfferDetails populateOfferDetails(Integer termLength ,Apttus_Config2__ProductConfiguration__c cart){
        
        DCPOfferDetails offerDetail = new DCPOfferDetails();
        offerDetail.contractTerm = termLength == 1 ? '1 Year' : termLength + ' Years';
        offerDetail.isSelectedTerm = false;
        
        //Populates offerDetails based on cart data or defaulted data
        if(isSelectedTerm(cart.Apttus_Config2__LineItems__r[0].APTS_Contract_Term__c,offerDetail.contractTerm)){
            
            System.debug(LoggingLevel.DEBUG, '*** DEBUGGING FROM DEV *** >> Contract Term :  '+ cart.Apttus_Config2__LineItems__r[0].APTS_Contract_Term__c+', Offerdetails contract term : ' +offerDetail.contractTerm+', termlength :'+termLength);
            String offerYOYRate = offerDetail.contractTerm == '1 Year' ? cart.Apttus_Config2__LineItems__r[0].APTS_Yr_1_Renewal_Adjustment__c: cart.Apttus_Config2__LineItems__r[0].APTS_Years_2_Plus_Adjustment__c;
            if(String.isblank(offerYOYRate)){
                 offerDetail.yearOnYearRate = 0;
            }else{
                offerDetail.yearOnYearRate = Decimal.valueOf(offerYOYRate);
            }
            offerDetail.isSelectedTerm = true;
        }else{         
            offerDetail.yearOnYearRate = populateYearOnYearRate(termLength);    
        }

        offerDetail.pricing = getDCPPricingDetails(cart.Rollup_Net_Price__c, offerDetail.yearOnYearRate);
        
        return offerDetail;

    } 
}