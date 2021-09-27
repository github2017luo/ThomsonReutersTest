/*
 * This class has all service related to Digital configurations like Loading data using opportunity, add/Remove product from Cart. 
 * 
 * CHANGE HISTORY
 * ==================================================================================================================================
 *  Date            Name                    Description
 *  2020-09-23      Benjamin Her            DLT-20827 Creation of class. PMD fix of DCGetQuoteDetails/DCQuoteService
 *  2020-10-01      Benjamin Her            DLT-20895 Send isPublicAddon flag for WestProflex subproduct scenario.
 *  2020-12-31      Kavya S                 DLT-21264 [SFDC][ALL][NTO]- NTO logic update - canceled asset  
 *  2021-03-03      Benjamin Her            DLT-21424 Rep Driven Handle option products as valid sub-products of West Proflex bundles
 *  2021-03-11      Benjamin Her            DLT-21481 Do not Consider Findlaw and Print Legal Solutions products to determine NTO customer
 *  2021-03-22      Brenda Shields          DLT-21507 - [INC3914849][SFDC][Renewals] - Invalid asset data being picked up in west proflex sub prod call
 *  2021-05-14		Ameeta A				DLT-21653 - [INC3971496][SFDC] - Condition to check to see if sub-products is outside of the 450 days window
 *  2021-05-18		Ameeta A				DLT-21747 - [SFDC][ALL SEGMENTS][REN]- Correct West Proflex Product From Displaying
 ==================================================================================================================================

 */
/**
    @description Helper class for DCGetQuoteDetails
 */
public without sharing class DCGetQuoteDetailsHelper {

    private static final String DIGITAL_QUOTE_TYPE_PREMIUM = 'Premium';
    private static final String DIGITAL_QUOTE_TYPE_PLUS = 'Best Value';
    private static final String DIGITAL_QUOTE_TYPE_MANUAL = 'Manual';
    private static final String DIGITAL_QUOTE_TYPE_STRAIGHT = 'Straight Renewal'; //DLT-16970
    private static final List<String> PRINT_PRODUCTS = System.Label.Digital_Print_Product_Family.split(',');
    private static final List<String> FINDLAW_PRODUCTS = System.Label.Digital_FindLaw_Product.split(',');

    private static String publicProducts;

    /**
        @description Method that is called to execute logic for populating West Prolfex subproducts
        @param quoteLineItemList List of quote line items that contains product details
        @param quote Cart record
        @return List<QuoteDetailsResponse.QuoteLineItems> with West Proflex subproduct information, if applicable
     */
    public static List < QuoteDetailsResponse.QuoteLineItems > getWestProflexSubproduct(List < QuoteDetailsResponse.QuoteLineItems > quoteLineItemList, Apttus_Config2__ProductConfiguration__c quote) {

        if (quote.Apttus_QPConfig__Proposald__r.Digital_Quote_Type__c.equalsIgnoreCase(DIGITAL_QUOTE_TYPE_STRAIGHT) || quote.Apttus_QPConfig__Proposald__r.Digital_Quote_Type__c.equalsIgnoreCase(DIGITAL_QUOTE_TYPE_MANUAL)) {
            for (Apttus_Config2__LineItem__c lineItem: quote.Apttus_Config2__LineItems__r) {
                //If West Proflex exists, return updated values with West Proflex subproduct
                if (lineItem.Apttus_Config2__ProductId__r.Name.equalsIgnoreCase('West Proflex') && lineItem.Apttus_Config2__LineStatus__c != 'Amended') {
                    return addWestProflexSubproduct(quoteLineItemList, lineItem, quote);
                }
            }
        }

        //Returns original list if West Proflex is not found.
        return quoteLineItemList;

    } //end of getWestProflexSubproduct() method


    //addWestProflexSubproduct() method
    //Returns an updated List<QuoteDetailsResponse.QuoteLineItems> if there are any missing West Proflex subproducts
    private static List < QuoteDetailsResponse.QuoteLineItems > addWestProflexSubproduct(List < QuoteDetailsResponse.QuoteLineItems > quoteLineItemList, Apttus_Config2__LineItem__c westProflex, Apttus_Config2__ProductConfiguration__c quote) {

        List < QuoteDetailsResponse.QuoteLineItems > updatedLineItemList = quoteLineItemList;
        List < Apttus_Config2__AssetLineItem__c > assetLineItemList = new List < Apttus_Config2__AssetLineItem__c > ();

        //missingDigitalSubs contains a set of all Subscription Numbers found in DS that are NOT in the cart
        Set < String > missingDigitalSubs = DCLandingServiceHelper.getMissingCurrentDigitalSubNumber(quote);

        if (!Schema.sObjectType.Apttus_Config2__AssetLineItem__c.isQueryable() &&
            !Schema.sObjectType.Product2.isQueryable()) {
            return quoteLineItemList;
        }
		
        if(quote.Apttus_QPConfig__Proposald__r.Digital_Quote_Type__c.equalsIgnoreCase(DIGITAL_QUOTE_TYPE_STRAIGHT)){
           
        // DLT-21507 - update query to exclude assets with an invalid Renewal Date (null or < today)
        // and only include assets where the Allowed Actions field is set to "Amend; Cancel"
            assetLineItemList = [
                SELECT id, Apttus_Config2__ProductId__c, Apttus_Config2__ProductId__r.Id, Apttus_Config2__ProductId__r.ProductCode, Apttus_Config2__ProductId__r.Name,
                Apttus_Config2__ProductId__r.Digital_Description__c, Apttus_Config2__ProductId__r.DC_Short_Description__c,
                Apttus_Config2__ProductId__r.DC_Long_Description__c, Apttus_Config2__ProductId__r.APTS_Product_Pricing_Model__c,
                Apttus_Config2__ProductId__r.Subscription_Number__c, Apttus_Config2__ProductId__r.Family,
                Apttus_Config2__ProductId__r.Service_Number__c,Apttus_Config2__OptionId__c,Apttus_Config2__OptionId__r.Name,Apttus_Config2__OptionId__r.Id,Apttus_Config2__OptionId__r.Description
                FROM Apttus_Config2__AssetLineItem__c
                WHERE APTS_Subscription_Number__c IN: missingDigitalSubs
                AND APTS_Info_RenewalDate__c > today AND APTS_Info_RenewalDate__c<=NEXT_N_DAYS:450
                AND Apttus_Config2__AllowedActions__c IN ('Amend; Cancel')
                AND APTS_SSD_Bill_To__r.Source_System_Account_Number__c =: quote.APTS_SSD_bill_to__r.Source_System_Account_Number__c
                AND Apttus_Config2__AssetStatus__c IN('Activated', 'Pending Activation')
            ];
        }else if(quote.Apttus_QPConfig__Proposald__r.Digital_Quote_Type__c.equalsIgnoreCase(DIGITAL_QUOTE_TYPE_MANUAL)){            
        	assetLineItemList = [                
                SELECT id, Apttus_Config2__ProductId__c, Apttus_Config2__ProductId__r.Id, Apttus_Config2__ProductId__r.ProductCode, Apttus_Config2__ProductId__r.Name,
                Apttus_Config2__ProductId__r.Digital_Description__c, Apttus_Config2__ProductId__r.DC_Short_Description__c,
                Apttus_Config2__ProductId__r.DC_Long_Description__c, Apttus_Config2__ProductId__r.APTS_Product_Pricing_Model__c,
                Apttus_Config2__ProductId__r.Subscription_Number__c, Apttus_Config2__ProductId__r.Family,
                Apttus_Config2__ProductId__r.Service_Number__c,Apttus_Config2__OptionId__c,Apttus_Config2__OptionId__r.Name,Apttus_Config2__OptionId__r.Id,Apttus_Config2__OptionId__r.Description
                FROM Apttus_Config2__AssetLineItem__c
                WHERE APTS_Info_RenewalDate__c =: westProflex.Apttus_Config2__AssetLineItemId__r.APTS_Info_RenewalDate__c
                AND APTS_Info_RenewalDate__c > today 
                AND Apttus_Config2__AllowedActions__c IN ('Amend; Cancel')
                AND APTS_SSD_Bill_To__r.Source_System_Account_Number__c =: quote.APTS_SSD_bill_to__r.Source_System_Account_Number__c
                AND Apttus_Config2__AssetStatus__c IN('Activated', 'Pending Activation')
            ];    
        }
        
        Map < String, List < QuoteDetailsResponse.Material >> productToMaterialMap = getDigitalProductPlan(assetLineItemList);
        getPublicRecords();
		
        //Iterates through all asset line items that have not been added to the cart
        for (Apttus_Config2__AssetLineItem__c asset: assetLineItemList) {
            updatedLineItemList.add(getWestProflexSubproductValues(asset, westProflex, productToMaterialMap.get(asset.Apttus_Config2__ProductId__r.Id)));
        }
		System.debug('@@@@@updatedLineItemList'+updatedLineItemList.size());
        return updatedLineItemList;

    } //end of addWestProflexSubproduct() method

    /**
        @description Populates the subproduct details
        @param subProduct Asset subproduct
        @param westProflex West Proflex asset
        @param digitalProductPlans List of digital product plans
        @return Returns a populated subproduct detail
     */
    //getWestProflexSubproductValues() method
    //Returns a West Proflex Subproduct as a QuoteDetailsResponse.QuoteLineItems data structure
    public static QuoteDetailsResponse.QuoteLineItems getWestProflexSubproductValues(Apttus_Config2__AssetLineItem__c subProduct, Apttus_Config2__LineItem__c westProflex, List < QuoteDetailsResponse.Material > digitalProductPlans) {

        //Creates a quotelineitem for West Proflex subproduct.
        QuoteDetailsResponse.QuoteLineItems quoteLineItem = new QuoteDetailsResponse.QuoteLineItems();
        quoteLineItem.lineId = null;
        quoteLineItem.ProductId = subProduct.Apttus_Config2__ProductId__r.id;
        quoteLineItem.optionProductId = subProduct.Apttus_Config2__OptionId__r.Id;
        quoteLineItem.isIndigo = null;
        quoteLineItem.material = digitalProductPlans;
        quoteLineItem.productName = subProduct.Apttus_Config2__ProductId__r.Name;
        quoteLineItem.optionProductName = subProduct.Apttus_Config2__OptionId__r.Name;
        quoteLineItem.optionProductDescription = subProduct.Apttus_Config2__OptionId__r.Description;
        quoteLineItem.digitalDescription = subProduct.Apttus_Config2__ProductId__r.Digital_Description__c;
        quoteLineItem.status = westProflex.Apttus_Config2__LineStatus__c;
        quoteLineItem.format = westProflex.APTS_Format__c;
        quoteLineItem.billingFrequency = westProflex.Apttus_Config2__BillingFrequency__c;
        quoteLineItem.shortDescription = subProduct.Apttus_Config2__ProductId__r.DC_Short_Description__c;
        quoteLineItem.longDescription = subProduct.Apttus_Config2__ProductId__r.DC_Long_Description__c;
        quoteLineItem.pricingModel = subProduct.Apttus_Config2__ProductId__r.APTS_Product_Pricing_Model__c;
        quoteLineItem.firmSize = westProflex.Apttus_Config2__Quantity__c;
        quoteLineItem.isAddOn = westProflex.DC_Is_Add_On__c;
        quoteLineItem.price = 0.00;
        quoteLineItem.autoRenewalTerm = westProflex.Apttus_Config2__AutoRenewalTerm__c;
        quoteLineItem.subscriptionNumber = subProduct.Apttus_Config2__ProductId__r.Subscription_Number__c;
        quoteLineItem.startDate = westProflex.Apttus_Config2__StartDate__c;
        quoteLineItem.attorney = westProflex.APTS_Number_of_Attorneys__c;
        quoteLineItem.contractTerm = westProflex.APTS_Contract_Term__c;
        quoteLineItem.renewalAdjustment = westProflex.APTS_Yr_1_Renewal_Adjustment__c;
        quoteLineItem.YearOnYearAdjustment = westProflex.APTS_Years_2_Plus_Adjustment__c;
        if (westProflex.Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.Digital_Quote_Type__c == 'Manual') {
            quoteLineItem.bandNumber = Integer.valueOf(westProflex.Apttus_Config2__Quantity__c);
        } else {
            quoteLineItem.bandNumber = Integer.valueOf(westProflex.APTS_SSD_ship_to__r.LCRM_APTS_Band_Number__c);
        }
        quoteLineItem.isPublicAddon = checkIfPublicRecord(subProduct);
        quoteLineItem.productFamily = subProduct.Apttus_Config2__ProductId__r.Family;
        quoteLineItem.basePrice = 0.00;
        quoteLineItem.OriginalQuantity = westProflex.APTS_Original_Quantity__c;
        quoteLineItem.onlineContacts = null;
        quoteLineItem.PA = null;
        quoteLineItem.Geo = null;

        return quoteLineItem;

    } //end of getWestProflexSubproductValues() method

    /**
        @description Gets a map of digital product plans for each asset passed
        @param assetLineItemList List of asset line items
        @return Returns map of product to digital product plan
     */
    //Returns a map between Product ID and List<QuoteDetailsResponse.Material>
    public static Map < String, List < QuoteDetailsResponse.Material >> getDigitalProductPlan(List < Apttus_Config2__AssetLineItem__c > assetLineItemList) {

        Map < String, List < QuoteDetailsResponse.Material >> productToDigitalProductPlanMap = new Map < String, List < QuoteDetailsResponse.Material >> ();
        Set < String > productIdSet = new Set < String > ();

        for (Apttus_Config2__AssetLineItem__c asset: assetLineItemList) {
            productIdSet.add(asset.Apttus_Config2__ProductId__r.Id);
        }

        if (!Schema.sObjectType.Digital_Product_Plans__c.isQueryable()) {
            throw new DCCustomException('Digital_Product_Plans__c is not queryable.');
        }
        List < Digital_Product_Plans__c > digitalProductPlanList = [
            SELECT id, name, Material_Number__c, Material_Description__c,
            Product__c, Subscription_Number__c, SLF_Jurisdiction__c,
            DB_Group__c, DB_Group_Sort_Order__c, DB_Category__c,
            DB_Category_Sort_Order__c, SLF_Help_Text__c, Additional_Help_Text__c
            FROM Digital_Product_Plans__c
            WHERE Product__c IN: productIdSet
        ];

        for (Digital_Product_Plans__c digitalProductPlan: digitalProductPlanList) {
            QuoteDetailsResponse.Material material = new QuoteDetailsResponse.Material();
            material.materialId = digitalProductPlan.Id;
            material.materialNumber = digitalProductPlan.Material_Number__c;
            material.materialDescription = digitalProductPlan.Material_Description__c;
            material.internalDescription = digitalProductPlan.SLF_Help_Text__c;
            material.classificationValue = digitalProductPlan.DB_Category__c;
            material.classificationValueSortOrder = Integer.valueOf(digitalProductPlan.DB_Category_Sort_Order__c);
            material.subscriptionNumber = digitalProductPlan.Subscription_Number__c;
            material.jurisdiction = digitalProductPlan.SLF_Jurisdiction__c;
            material.productPlanId = digitalProductPlan.Product__c;
            material.productGroup = digitalProductPlan.DB_Group__c;
            material.productGroupSortOrder = Integer.valueOf(digitalProductPlan.DB_Group_Sort_Order__c);
            material.additionalInternalDescription = digitalProductPlan.Additional_Help_Text__c;

            if (!(productToDigitalProductPlanMap.containsKey(digitalProductPlan.Product__c))) {
                productToDigitalProductPlanMap.put(digitalProductPlan.Product__c, new List < QuoteDetailsResponse.Material > ());
            }
            productToDigitalProductPlanMap.get(digitalProductPlan.Product__c).add(material);
        }

        return productToDigitalProductPlanMap;
    } //end of getDigitalProductPlan()

    /**
        @description Determines if a customer is new to online (NTO)
        NTO Customer Critera: No account number exists OR account number exists but all assets are Print products
        @param cart Cart record
        @return Returns true/false depending on whether the customer is considered an NTO customer
     */
    public static boolean isNTOCustomer(Apttus_Config2__ProductConfiguration__c cart) {
        List<String> findLawProducts = new List<String>();
        for(String str : FINDLAW_PRODUCTS){
            str = '%'+str+'%';
            findLawProducts.add(str);
        }
        Integer nonPrintAssetCount = [
            SELECT count() FROM Apttus_Config2__AssetLineItem__c
            WHERE APTS_SSD_Bill_To__r.id =: cart.Apttus_QPConfig__Proposald__r.APTS_SSD_bill_to__c
            AND Apttus_Config2__AssetStatus__c = 'Activated'
            AND Apttus_Config2__ProductId__r.Family NOT IN: PRINT_PRODUCTS
            AND (NOT Apttus_Config2__ProductId__r.Name LIKE: findLawProducts)
            Limit 1
            
        ]; // DLT-21264 added the asset status condition

        //If account number exists and the account contains an asset for a non-Print product, return FALSE
        if (String.isNotBlank(cart.Apttus_QPConfig__Proposald__r.APTS_SSD_bill_to__r.Source_System_Account_Number__c) &&
            nonPrintAssetCount > 0) {
            return false;
        }

        //Return true as customer is considered NTO customer.
        return true;

    } //end of isNTOCustomer() method

    /**
        @description Determines if Line Item is indigo product
        @param indigoProducts List of indigop products
        @param lineItem Line item to be checked if indigo product
        @param digitalQuoteType Quote type for line item
        @return Returns boolean based on whether line item is an indigo product
     */
    public static boolean checkIsIndigo(String indigoProducts, Apttus_Config2__LineItem__c lineItem, String digitalQuoteType) {
        if (String.isNotBlank(indigoProducts) &&
            (DIGITAL_QUOTE_TYPE_PREMIUM.equals(digitalQuoteType) ||
                DIGITAL_QUOTE_TYPE_PLUS.equals(digitalQuoteType) ||
                DIGITAL_QUOTE_TYPE_MANUAL.equals(digitalQuoteType)) &&
            String.isNotBlank(lineItem.Apttus_Config2__ProductId__r.Service_Number__c) &&
            indigoProducts.contains(lineItem.Apttus_Config2__ProductId__r.Service_Number__c)) {

            return true;
        }
        return false;
    } //end of checkIsIndigo() method

    private static boolean checkIfPublicRecord(Apttus_Config2__AssetLineItem__c subProduct) {
        if ((subProduct.Apttus_Config2__ProductId__r.Name).toLowerCase().Contains('public records') ||
            (String.isNotBlank(publicProducts) 
            && String.isNotBlank(subProduct.Apttus_Config2__ProductId__r.Service_Number__c) 
            && publicProducts.contains(subProduct.Apttus_Config2__ProductId__r.Service_Number__c))) { //DLT-16262   -Added OR condition                           
            return true;
        }

        return false;

    }

    private static void getPublicRecords() {
        if (DCGetQuoteDetails.globalSettings != null) {
            for (DC_Global_Settings__mdt dcgs: DCGetQuoteDetails.globalSettings) {
                if (String.isNotBlank(dcgs.public_addon_products__c)) {
                    publicProducts = dcgs.public_addon_products__c;
                }
            }
        }
        System.debug(LoggingLevel.DEBUG,'Public Records:::' + publicProducts);
    }

}