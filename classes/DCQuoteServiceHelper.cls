/*
 * This class has all service related to Digital configurations like Loading data using opportunity, add/Remove product from Cart. 
 * 
 * CHANGE HISTORY
 * ==================================================================================================================================
 *  Date            Name                    Description
 *  2020-09-23      Benjamin Her            DLT-20827 Creation of class. PMD fix of DCGetQuoteDetails/DCQuoteService
 *  2021-03-22      Brenda Shields          DLT-21507 - [INC3914849][SFDC][Renewals] - Invalid asset data being picked up in west proflex sub prod call
 *  2021-05-14		Ameeta A				DLT-21653 - [INC3971496][SFDC] - Condition to check to see if sub-products is outside of the 450 days window
 *  2021-05-18		Ameeta A				DLT-21747 - [SFDC][ALL SEGMENTS][REN]- Correct West Proflex Product From Displaying
 *  2021-07-02		Ameeta A				DLT-21990 - [Renewals][SFDC][INC4091482]- Incorrect attorney count showing on landing page
 * ==================================================================================================================================
 */
/** 
 * @description : Helper methods for service related to Digital configurations
 */  
public without sharing class DCQuoteServiceHelper{
    
    private static final String QUOTE_TYPE_STRAIGHT_RENEWAL = 'Straight Renewal';
    private static final String WEST_PROFLEX = 'West Proflex';
    private static final String QUOTE_TYPE_MANUAL = 'Manual';

    //getYOYValues() method
    /** 
     * @description : Populates the 'objYoy' variable with the YoY values from Digital Subscription
     * @param yoyValues : YOY values
     * @param pad : Product Account Detail
     * @param isUpdate : Is this and Update
     * @return : DCQuoteService yoy values
     */     
    public static DCQuoteService.YOYValues getYOYValues(DCQuoteService.YOYValues yoyValues, Product_Account_Detail__c pad, boolean isUpdate){
        DCQuoteService.YOYValues objYoy = yoyValues;

        if(!isUpdate || (isUpdate && pad.Current_Term_Length__c!= null)){
            //YOY values for Straigt proposal
            if(pad.Current_Subscription__c!= null && (pad.Year1_YoYvalue__c!= null || pad.Year2_YoYvalue__c!= null || pad.Year3_YoYvalue__c!= null)){
                objYoy.arrYoyStraight[0] = getYOY(pad.Year1_YoYvalue__c);
                objYoy.arrYoyStraight[1] = getYOY(pad.Year2_YoYvalue__c);
                objYoy.arrYoyStraight[2] = getYOY(pad.Year3_YoYvalue__c);
            }
            //YOY values for Best proposal
            else if(pad.Actual_New_Subscription__c!= null && (pad.Year1_YoYvalue__c!= null || pad.Year2_YoYvalue__c!= null || pad.Year3_YoYvalue__c!= null)){
                objYoy.arrYoyBest[0] = getYOY(pad.Year1_YoYvalue__c);
                objYoy.arrYoyBest[1] = getYOY(pad.Year2_YoYvalue__c);
                objYoy.arrYoyBest[2] = getYOY(pad.Year3_YoYvalue__c);
            }
            //YOY values for Premium proposal
            else if(pad.Premium_New_Subscription__c!= null && (pad.Year1_YoYvalue__c!= null || pad.Year2_YoYvalue__c!= null || pad.Year3_YoYvalue__c!= null)){
                objYoy.arrYoyPremium[0] = getYOY(pad.Year1_YoYvalue__c);
                objYoy.arrYoyPremium[1] = getYOY(pad.Year2_YoYvalue__c);
                objYoy.arrYoyPremium[2] = getYOY(pad.Year3_YoYvalue__c);
            }
        }

        return objYoy;
    }//end of getYOYValues() method
    
    private static decimal getYOY(decimal yoyValue){
        if(yoyValue != null){
            return yoyValue;
        }
        else{
            return 0.0;
        }
    }

    //getWestProflexSubproduct() method
    /** 
     * @description : Get West Proflex Sub Products
     * @param quoteLineItemList : List of Quote Line Items
     * @param quote : Quote
     * @return : List<DCQuoteDetails.LineItem> with West Proflex subproduct information, if applicable
     */     
    public static List<DCQuoteDetails.LineItem> getWestProflexSubproduct(List<DCQuoteDetails.LineItem> quoteLineItemList, Apttus_Config2__ProductConfiguration__c quote) {
        
        if(quote.Apttus_QPConfig__Proposald__r.Digital_Quote_Type__c.equalsIgnoreCase(QUOTE_TYPE_STRAIGHT_RENEWAL) || quote.Apttus_QPConfig__Proposald__r.Digital_Quote_Type__c.equalsIgnoreCase(QUOTE_TYPE_MANUAL)){
            for(Apttus_Config2__LineItem__c lineItem : quote.Apttus_Config2__LineItems__r){
                //If West Proflex exists, return updated values with West Proflex subproduct
                if(lineItem.Apttus_Config2__ProductId__r.Name.equalsIgnoreCase(WEST_PROFLEX) && lineItem.Apttus_Config2__LineStatus__c != 'Amended')
                {   
                    return addWestProflexSubproduct(quoteLineItemList, lineItem, quote);
                }
            }
        }

        //Returns original list if West Proflex is not found.
        return quoteLineItemList;

    }//end of getWestProflexSubproduct() method

    
    //addWestProflexSubproduct()
    //Returns an updated List<DCQuoteDetails.LineItem> if any West Proflex subproduct is missing
    private static List<DCQuoteDetails.LineItem> addWestProflexSubproduct(List<DCQuoteDetails.LineItem> quoteLineItemList, Apttus_Config2__LineItem__c westProflex, Apttus_Config2__ProductConfiguration__c quote){
        
        List<DCQuoteDetails.LineItem> updatedLineItemList = quoteLineItemList;        
        List<Apttus_Config2__AssetLineItem__c> assetLineItemList = new List<Apttus_Config2__AssetLineItem__c>();

        //missingDigitalSubs contains a set of all Subscription Numbers found in DS that are NOT in the cart
        Set<String> missingDigitalSubs = DCLandingServiceHelper.getMissingCurrentDigitalSubNumber(quote);

        if (!(Schema.sObjectType.Apttus_Config2__AssetLineItem__c.isQueryable()
            && Schema.sObjectType.Product2.isQueryable())){
            return quoteLineItemList;
        }
        
        if(quote.Apttus_QPConfig__Proposald__r.Digital_Quote_Type__c.equalsIgnoreCase(QUOTE_TYPE_STRAIGHT_RENEWAL)){
		// DLT-21507 - update query to exclude assets with an invalid Renewal Date (null or < today)
		// and only include assets where the Allowed Actions field is set to "Amend; Cancel"
            assetLineItemList = [
                                SELECT id, Apttus_Config2__ProductId__c,Apttus_Config2__ProductId__r.Id,
                                Apttus_Config2__ProductId__r.APTS_Product_Pricing_Model__c,Apttus_Config2__OptionId__c,
                				Apttus_Config2__OptionId__r.Name,Apttus_Config2__OptionId__r.Id,Apttus_Config2__Quantity__c, APTS_Number_of_Attorneys__c
                                FROM Apttus_Config2__AssetLineItem__c 
                                WHERE APTS_Subscription_Number__c IN: missingDigitalSubs
                                AND APTS_Info_RenewalDate__c > today AND APTS_Info_RenewalDate__c<=NEXT_N_DAYS:450
                                AND Apttus_Config2__AllowedActions__c IN ('Amend; Cancel')
                                AND APTS_SSD_Bill_To__r.Source_System_Account_Number__c =: quote.APTS_SSD_bill_to__r.Source_System_Account_Number__c
                                AND Apttus_Config2__AssetStatus__c IN ('Activated', 'Pending Activation')
                                ];
        }else if(quote.Apttus_QPConfig__Proposald__r.Digital_Quote_Type__c.equalsIgnoreCase(QUOTE_TYPE_MANUAL)){
        	assetLineItemList = [
                            SELECT id, Apttus_Config2__ProductId__c,Apttus_Config2__ProductId__r.Id,
                            Apttus_Config2__ProductId__r.APTS_Product_Pricing_Model__c,Apttus_Config2__OptionId__c,
                			Apttus_Config2__OptionId__r.Name,Apttus_Config2__OptionId__r.Id,Apttus_Config2__Quantity__c, APTS_Number_of_Attorneys__c
                            FROM Apttus_Config2__AssetLineItem__c 
                            WHERE APTS_Info_RenewalDate__c =: westProflex.Apttus_Config2__AssetLineItemId__r.APTS_Info_RenewalDate__c
                			AND APTS_Info_RenewalDate__c > today 
                            AND Apttus_Config2__AllowedActions__c IN ('Amend; Cancel')
                            AND APTS_SSD_Bill_To__r.Source_System_Account_Number__c =: quote.APTS_SSD_bill_to__r.Source_System_Account_Number__c
                            AND Apttus_Config2__AssetStatus__c IN ('Activated', 'Pending Activation')
                            ];    
        }
        
        //Iterates through all asset line items that have not been added to the cart
        for(Apttus_Config2__AssetLineItem__c asset : assetLineItemList){
            updatedLineItemList.add(getWestProflexSubproductValues(asset, westProflex));
        }

        return updatedLineItemList;

    }//end of addWestProflexSubproduct() method

    //getWestProflexSubproductValues() method
    /** 
     * @description : Get West Proflex Sub Products
     * @param subProduct : Asset Line Item
     * @param westProflex : Config Line Item
     * @return : a West Proflex Subproduct as a DCQuoteDetails.LineItem data structure
     */       
    public static DCQuoteDetails.LineItem getWestProflexSubproductValues(Apttus_Config2__AssetLineItem__c subProduct, Apttus_Config2__LineItem__c westProflex){
        DCQuoteDetails.LineItem quoteLineItem = new DCQuoteDetails.LineItem();
        quoteLineItem.productId = subProduct.Apttus_Config2__ProductId__r.id;
        quoteLineItem.optionProductId = subProduct.Apttus_Config2__OptionId__r.Id;
        quoteLineItem.category = null;
        quoteLineItem.price = 0.00;
        // DLT-21990 - if Banded, use the number of attorneys else use quantity
        if (subProduct.Apttus_Config2__ProductId__r.APTS_Product_Pricing_Model__c == 'Banded') {
        	quoteLineItem.quantity = Integer.valueOf(subProduct.APTS_Number_of_Attorneys__c);
        } else {
        	quoteLineItem.quantity = Integer.valueOf(subProduct.Apttus_Config2__Quantity__c);
        }
        quoteLineItem.pricingModel = subProduct.Apttus_Config2__ProductId__r.APTS_Product_Pricing_Model__c;
        quoteLineItem.matrices = null;
        quoteLineItem.basePrice = 0.00;

        return quoteLineItem;
    }//end of getWestProflexSubproductValues() method
        
    //getManualContractTermDetails() method
    //Added DLT-15149
    /** 
     * @description : Grabs contract term details from cart data instead of automation settings
     * @param cart : Cart record
     * @return : a list of Contract Term Details
     */      
    public static List<DCQuoteDetails.ContractTermDetail> getManualContractTermDetails(Apttus_Config2__ProductConfiguration__c cart){
        List<DCQuoteDetails.ContractTermDetail> contractTermDetails = new List<DCQuoteDetails.ContractTermDetail>();
        DCQuoteDetails.ContractTermDetail detail = new DCQuoteDetails.ContractTermDetail();

        for(Apttus_Config2__LineItem__c line : cart.Apttus_Config2__LineItems__r){ 
            if(line.Apttus_Config2__LineType__c != 'Option') {  
                detail.term = line.APTS_Contract_Term__c;
                detail.yearOnYearRenewal = (line.APTS_Yr_1_Renewal_Adjustment__c != null) ? Decimal.valueOf(line.APTS_Yr_1_Renewal_Adjustment__c) : null;
                detail.yearOnYearTwoPlus = (line.APTS_Years_2_Plus_Adjustment__c != null) ? Decimal.valueOf(line.APTS_Years_2_Plus_Adjustment__c) : null;
                detail.markupPercentage = (line.Apttus_Config2__AdjustmentType__c=='% Markup') ? line.Apttus_Config2__AdjustmentAmount__c : 0; 
                detail.adjustmentType =  line.Apttus_Config2__AdjustmentType__c;
                detail.adjustmentAmount = line.Apttus_Config2__AdjustmentAmount__c;
            }
        }

        detail.isBestValue = true;
        detail.isVisible = true;
        detail.isEditable = true;

        contractTermDetails.add(detail);

        return contractTermDetails;
    }

    /** 
     * @description : Gets Access Permission
     * @param detail : Quote Detail - contract term detail
     * @param termObj : term object
     * @param termCurrent : current term
     * @return : Contract Term Details
     */ 
    public static DCQuoteDetails.ContractTermDetail getAccessPermission(DCQuoteDetails.ContractTermDetail detail,DC_Contract_Term_V2__mdt termObj,Integer termCurrent){
        
        DCQuoteDetails.ContractTermDetail contractTermDetail = detail;  

        //Setting the contractTermDetail visibility and editability.
        if(termCurrent == 1){//For 1 year current term
            contractTermDetail = getAccessPermissionCurrentTerm1(contractTermDetail, termObj);
        }
        else if(termCurrent == 2){// For 2 year current term
            contractTermDetail = getAccessPermissionCurrentTerm2(contractTermDetail, termObj);
        }
        else if(termCurrent >= 3 || termCurrent == null){//For 3 year or none
            contractTermDetail = getAccessPermissionCurrentTerm3(contractTermDetail, termObj);
        }
        return contractTermDetail;
    }

    private static DCQuoteDetails.ContractTermDetail getAccessPermissionCurrentTerm1(DCQuoteDetails.ContractTermDetail detail,DC_Contract_Term_V2__mdt termObj){
        DCQuoteDetails.ContractTermDetail contractTermDetail = detail;  
        if(termObj.Contract_Term__c == '1 Year' || termObj.Contract_Term__c == '2 Years' || termObj.Contract_Term__c == '3 Years'){
            contractTermDetail.isVisible = true;
            contractTermDetail.isEditable = true;
        }  
        return contractTermDetail;
    }
    
    private static DCQuoteDetails.ContractTermDetail getAccessPermissionCurrentTerm2(DCQuoteDetails.ContractTermDetail detail,DC_Contract_Term_V2__mdt termObj){
        DCQuoteDetails.ContractTermDetail contractTermDetail = detail;
        if(termObj.Contract_Term__c == '1 Year'){// For 1 year contract term
            contractTermDetail.isVisible = false;
            contractTermDetail.isEditable = false;
        }
        //For 2 or 3 Years Contract Term
        else if(termObj.Contract_Term__c == '2 Years' || termObj.Contract_Term__c == '3 Years'){
            contractTermDetail.isVisible = true;
            contractTermDetail.isEditable = true;
        } 
        return contractTermDetail;
    }
    
    private static DCQuoteDetails.ContractTermDetail getAccessPermissionCurrentTerm3(DCQuoteDetails.ContractTermDetail detail,DC_Contract_Term_V2__mdt termObj){
        DCQuoteDetails.ContractTermDetail contractTermDetail = detail;  
        if(termObj.Contract_Term__c == '1 Year' || termObj.Contract_Term__c == '3 Years'){
            contractTermDetail.isVisible = true;
            contractTermDetail.isEditable = false;
        }
        //For 2 Years Contract Term
        else if(termObj.Contract_Term__c == '2 Years'){
            contractTermDetail.isVisible = false;
            contractTermDetail.isEditable = false;
        }
        return contractTermDetail;
    }

}