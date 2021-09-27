/**********************************************************************************************************************
Change History
***********************************************************************************************************************
Name                    Date            JIRA            Description
Benjami Her             2020-11-04      DLT-20755       Initial Creation. PMD fix
************************************************************************************************************************************/

/**
    @description Helper method for Digital_CartCreationCommonCode
 */
public without sharing class Digital_CartCreationHelper{

    /**
        @description addCustomFieldsYOY1() method adds line item custom fields to a List
        @return Return a list of strings of line item fields
     */
    public static List<String> addCustomFieldsYOY1() {
        List<String> customFields= new List<String>();
        customFields.add('APTS_Contract_Term__c');
        customFields.add('APTS_Yr_1_Renewal_Adjustment__c');
        customFields.add('APTS_Years_2_Plus_Adjustment__c');
        customFields.add('Apttus_Config2__SellingTerm__c'); 
        customFields.add('Apttus_Config2__Comments__c'); 
        customFields.add('Apttus_Config2__BillingFrequency__c');
        customFields.add('Apttus_Config2__SellingFrequency__c');
        customFields.add('Apttus_Config2__PriceType__c');
        customFields.add('Apttus_Config2__Frequency__c');
        customFields.add('Apttus_Config2__PriceListItemId__c');
        customFields.add('Apttus_Config2__ChargeType__c');
        customFields.add('Apttus_Config2__PriceUom__c');
        customFields.add('Apttus_Config2__PriceMethod__c');
        customFields.add('Apttus_Config2__AdjustmentType__c');
        customFields.add('Apttus_Config2__AdjustmentAmount__c');
        customFields.add('DC_Is_Add_On__c');    // DLT-16116 Added for New Mid Contract by SK
        return customFields;
    }
    /**
        @description Updates the line item fields based on the values contained in corresponding Apttus SelectedProductDO
        @param cartId Id of cart
        @param selectedProducts Apttus product request object
     * --------------------------NOTE-----------------------------
     * This code has been added as a workaround due to Apttus Summer '19 package having a known issue with addMultiProducts api.
     * Apttus has developed a fix for the issues in Summer '19 package that is in their Winter '19 package.
     * Once Apttus Winter '19 package is used in all environments, this code should be removed.
     * -----------------------------------------------------------
     */
    public static void updateLineItemFields(Id cartId, List<Apttus_CPQApi.CPQ.SelectedProductDO> selectedProducts){

        Map<id, Apttus_CPQApi.CPQ.SelectedProductDO> productIDtoApttusProductMap = new Map<id, Apttus_CPQApi.CPQ.SelectedProductDO>();

        //Stores a map of product IDs to its corresponding Apttus product request.
        for(Apttus_CPQApi.CPQ.SelectedProductDO apttusProduct : selectedProducts){
            productIDtoApttusProductMap.put(apttusProduct.ProductID, apttusProduct);
        }

        //CRUD Validation
        if(!Schema.sObjectType.Apttus_Config2__LineItem__c.isAccessible() 
            || !Schema.sObjectType.Apttus_Config2__LineItem__c.isUpdateable()) {

            return;
        }

        //Query all new, standalone line items that are in the cart
        List<Apttus_Config2__LineItem__c> lineItemList = 
            [SELECT APTS_Contract_Term__c, APTS_Yr_1_Renewal_Adjustment__c,APTS_Years_2_Plus_Adjustment__c,
                Apttus_Config2__SellingTerm__c,Apttus_Config2__Comments__c,Apttus_Config2__BillingFrequency__c,
                Apttus_Config2__SellingFrequency__c,Apttus_Config2__PriceType__c,Apttus_Config2__Frequency__c,
                Apttus_Config2__PriceListItemId__c,Apttus_Config2__ChargeType__c,Apttus_Config2__PriceUom__c,
                Apttus_Config2__PriceMethod__c,Apttus_Config2__AdjustmentType__c,Apttus_Config2__AdjustmentAmount__c,
                APTS_Combination_Key__c,Apttus_Config2__IsCustomPricing__c,Apttus_Config2__Quantity__c,
                Apttus_Config2__ProductId__c
            FROM Apttus_Config2__LineItem__c 
            WHERE Apttus_Config2__ConfigurationId__c =: cartId 
            AND Apttus_Config2__LineStatus__c = 'New'
            AND Apttus_Config2__ProductId__r.Apttus_Config2__ConfigurationType__c = 'Standalone'];

        System.debug(LoggingLevel.DEBUG,'lineItemList BEFORE FIELD UPDATE:::::::::::::::::'+lineItemList);
        for(Apttus_Config2__LineItem__c lineItem : lineItemList){

            if(productIDtoApttusProductMap.containsKey(lineItem.Apttus_Config2__ProductId__c)){
                Apttus_CPQApi.CPQ.SelectedProductDO apttusTemp = productIDtoApttusProductMap.get(lineItem.Apttus_Config2__ProductId__c);
                lineItem.APTS_Contract_Term__c = apttusTemp.CustomData.APTS_Contract_Term__c;
                lineItem.APTS_Yr_1_Renewal_Adjustment__c = apttusTemp.CustomData.APTS_Yr_1_Renewal_Adjustment__c;
                lineItem.APTS_Years_2_Plus_Adjustment__c = apttusTemp.CustomData.APTS_Years_2_Plus_Adjustment__c;
                lineItem.Apttus_Config2__SellingTerm__c = apttusTemp.CustomData.Apttus_Config2__SellingTerm__c;
                lineItem.Apttus_Config2__Comments__c = apttusTemp.CustomData.Apttus_Config2__Comments__c;
                lineItem.Apttus_Config2__BillingFrequency__c = apttusTemp.CustomData.Apttus_Config2__BillingFrequency__c;
                lineItem.Apttus_Config2__SellingFrequency__c = apttusTemp.CustomData.Apttus_Config2__SellingFrequency__c;
                lineItem.Apttus_Config2__PriceType__c = apttusTemp.CustomData.Apttus_Config2__PriceType__c;
                lineItem.Apttus_Config2__Frequency__c = apttusTemp.CustomData.Apttus_Config2__Frequency__c;
                lineItem.Apttus_Config2__PriceListItemId__c = apttusTemp.CustomData.Apttus_Config2__PriceListItemId__c;
                lineItem.Apttus_Config2__ChargeType__c = apttusTemp.CustomData.Apttus_Config2__ChargeType__c;
                lineItem.Apttus_Config2__PriceUom__c = apttusTemp.CustomData.Apttus_Config2__PriceUom__c;
                lineItem.Apttus_Config2__PriceMethod__c = apttusTemp.CustomData.Apttus_Config2__PriceMethod__c;
                lineItem.Apttus_Config2__AdjustmentType__c = apttusTemp.CustomData.Apttus_Config2__AdjustmentType__c;
                lineItem.Apttus_Config2__AdjustmentAmount__c = apttusTemp.CustomData.Apttus_Config2__AdjustmentAmount__c;
                lineItem.APTS_Combination_Key__c = apttusTemp.CustomData.APTS_Combination_Key__c;
                lineItem.Apttus_Config2__IsCustomPricing__c = apttusTemp.CustomData.Apttus_Config2__IsCustomPricing__c;
                lineItem.DC_Is_Add_On__c = apttusTemp.CustomData.DC_Is_Add_On__c;

                //Renewals use SelectedProductDO's Quantity, NSE does not.
                if(apttusTemp.Quantity != null){
                    lineItem.Apttus_Config2__Quantity__c = apttusTemp.Quantity;
                }
                else{
                    lineItem.Apttus_Config2__Quantity__c = apttusTemp.CustomData.Apttus_Config2__Quantity__c;
                }
            }
        }
        System.debug(LoggingLevel.DEBUG,'lineItemList AFTER FIELD UPDATE:::::::::::::::::'+lineItemList);
        update lineItemList;
    }
    
    /**
        @description Call the Apttus API for modifying assets.
        @param cartId Id of the cart
        @param assetActionList Apttus object of assets for line item creation
        @return Apttus response
     */
    public static Apttus_CPQApi.CPQ.ModifyAssetResponseDO callApttusModifyAssetAPI(Id cartId, List<Apttus_CPQApi.CPQ.AssetActionDO> assetActionList){

        //Declare Apttus Modify Asset Request
        Apttus_CPQApi.CPQ.ModifyAssetRequestDO modifyRequest1 = new Apttus_CPQApi.CPQ.ModifyAssetRequestDO();
        modifyRequest1.CartId = cartId;
        modifyRequest1.AssetActions = assetActionList;

        //Call and stores Apttus Modify Asset Response
        Apttus_CPQApi.CPQ.ModifyAssetResponseDO modifyReponse1 = Apttus_CPQApi.CPQWebservice.modifyAsset(modifyRequest1);
        System.debug(LoggingLevel.DEBUG,modifyReponse1);
        List<Apttus_CPQApi.CPQ.AssetActionDO> assetList = modifyReponse1.AssetActions.clone();

        //Recalls Apttus Modify Asset API if there are any pending assets.
        Boolean bIsPending;
        Integer iCounter = 0;
        while (iCounter < 1000) {
            bIsPending = false;
            //Loops through response and check for pending assets
            for (Apttus_CPQApi.CPQ.AssetActionDO objAsset : modifyReponse1.AssetActions) {
                if (objAsset.Pending == true) {
                    bIsPending = true;
                }
                else{
                    //Remove non-pending asset from the list
                    assetList.remove(assetList.indexOf(objAsset));
                }
            }

            //If asset Action is pending execute the following loop
            if (bIsPending == true) {
                modifyRequest1.AssetActions = assetList;
                modifyReponse1 = Apttus_CPQApi.CPQWebservice.modifyAsset(modifyRequest1);
                assetList = modifyReponse1.AssetActions.clone();
            } else {
                break;
            }
            iCounter++;
        } 

        return modifyReponse1;
    }//end of callApttusModifyAssetAPI() method

    /**
        @description Call the Apttus API for adding products to a cart.
        @param cartId Id of cart
        @param selectedProducts Apttus request for product line item creation
        @return Apttus response
     */
    public static Apttus_CPQApi.CPQ.AddMultiProductResponseDO callApttusAddMultipleProductAPI(Id cartId, List<Apttus_CPQApi.CPQ.SelectedProductDO> selectedProducts){
        Apttus_CPQApi.CPQ.AddMultiProductRequestDO modifyRequest = new Apttus_CPQApi.CPQ.AddMultiProductRequestDO();
        modifyRequest.CartId = cartId;
        modifyRequest.SelectedProducts = selectedProducts;

        Apttus_CPQApi.CPQ.AddMultiProductResponseDO modifyResponse = Apttus_CPQApi.CPQWebservice.addMultiProducts(modifyRequest);
        System.debug(LoggingLevel.DEBUG,
            'APTTUS:Number of Queries used in this apex code so far addMultiProducts: ' 
            + Limits.getQueries()
        );

        return modifyResponse;
    }//end of callApttusAddMultipleProductAPI() method

    /**
        @description Call the Apttus API for cancelling assets
        @param cartId Id of cart
        @param cancelledAssetList List of asset id to be cancelled
        @param cancellationDate Date of when asset are cancelled
        @return Apttus response
    */
    public static Apttus_Config2.CPQStruct.CancelAssetsResponseDO callApttusCancelAssetAPI(Id cartId, List<id> cancelledAssetList, Date cancellationDate){
        // create and populate request object
        System.debug(LoggingLevel.DEBUG,'Remove request:');
        Apttus_Config2.CPQStruct.CancelAssetsRequestDO request = new Apttus_Config2.CPQStruct.CancelAssetsRequestDO();
        request.CancelDate = cancellationDate;
        request.AssetIds = cancelledAssetList;
        request.CartId = cartId;
        // call cancelAssets API
        Apttus_Config2.CPQStruct.CancelAssetsResponseDO response = Apttus_Config2.AssetService.cancelAssets(request);
        System.debug(LoggingLevel.DEBUG,'Remove Response:' + response);
        return response;
    } //end of callApttusCancelAssetAPI() method

    /**
        @description Checks if asset is found in DS
        @param soldToAssets Asset to be checked
        @param currentsub DS to be checked
        @return TRUE if valid asset, else false
     */
    public static Boolean checkAssetsAgainstDS(Apttus_Config2__AssetLineItem__c soldToAssets, Product_Account_Detail__c currentsub) {      

        if (isLawFirmAsset(soldToAssets,currentsub)) {
            return true;
        } else if (isCorpAsset(soldToAssets,currentsub)) {
            return true;
        } else if (isGovAsset(soldToAssets,currentsub)) {
            return true;
        } else if (isFindlawAsset(soldToAssets,currentsub)) {
            return true;
        } else {
            return false;
        }
    }
    private static boolean isLawFirmAsset(Apttus_Config2__AssetLineItem__c soldToAssets, Product_Account_Detail__c currentsub){
        Boolean prodSubMatchesCurSub = (soldToAssets.Apttus_Config2__ProductId__r.Subscription_Number__c == currentsub.Current_Subscription__c);
        Boolean contNumMatchesDsContNum = (soldToAssets.APTS_Contract_Number__c == currentsub.DC_Contract_Number__c);
        String digiFirm = currentsub.Digital_Firm__c;
        if(Digital_CartCreationCommonVariables.LAW_FIRMS.contains(digiFirm) && prodSubMatchesCurSub && (contNumMatchesDsContNum || currentsub.DC_Contract_Number__c == null)){
            return true;
        }
        else{
            return false;
        }
    }
    private static boolean isCorpAsset(Apttus_Config2__AssetLineItem__c soldToAssets, Product_Account_Detail__c currentsub){
        Boolean prodSubMatchesCurSub = (soldToAssets.Apttus_Config2__ProductId__r.Subscription_Number__c == currentsub.Current_Subscription__c);
        Boolean optSubMatchesCurSub = (soldToAssets.Apttus_Config2__OptionId__r.Subscription_Number__c == currentsub.Current_Subscription__c);
        Boolean hasOptions = soldToAssets.Apttus_Config2__ProductId__r.Apttus_Config2__HasOptions__c;

        String configType = soldToAssets.Apttus_Config2__ProductId__r.Apttus_Config2__ConfigurationType__c;
        String digiFirm = currentsub.Digital_Firm__c;
        if(digiFirm.equalsIgnoreCase('Corporate') && (prodSubMatchesCurSub || optSubMatchesCurSub || (hasOptions && configType == 'Bundle'))){
            return true;
        }
        else{
            return false;
        }
    }
    private static boolean isGovAsset(Apttus_Config2__AssetLineItem__c soldToAssets, Product_Account_Detail__c currentsub){
        Boolean prodSubMatchesCurSub = (soldToAssets.Apttus_Config2__ProductId__r.Subscription_Number__c == currentsub.Current_Subscription__c);

        String digiFirm = currentsub.Digital_Firm__c;
        if(digiFirm.equalsIgnoreCase('Government') && prodSubMatchesCurSub){
            return true;
        }
        else{
            return false;
        }
    }
    private static boolean isFindlawAsset(Apttus_Config2__AssetLineItem__c soldToAssets, Product_Account_Detail__c currentsub){
        Boolean prodCodeMatchesCurSub = (soldToAssets.Apttus_Config2__ProductId__r.ProductCode == currentsub.Current_Subscription__c);
        Boolean contNumMatchesDsContNum = (soldToAssets.APTS_Contract_Number__c == currentsub.DC_Contract_Number__c);

        String digiFirm = currentsub.Digital_Firm__c;
        if(digiFirm.equalsIgnoreCase('FindLaw') && prodCodeMatchesCurSub && contNumMatchesDsContNum){
            return true;
        }
        else{
            return false;
        }
    }
    
    /**
        @description If the digital subscriptions is marked for a 1 Year Experience, update the Line Item to 1 year.
        @param liso Line Item object to be updated
        @param boolOneYearExp Boolean if one year experience
        @param adjustmentAmount Adjustment value
        @return Returns line item object
     */
    public static Apttus_Config2__LineItem__c updateLineItemToOneYearExperience(Apttus_Config2__LineItem__c liso, boolean boolOneYearExp, decimal  adjustmentAmount){
        
        Apttus_Config2__LineItem__c lineItem = liso;

        //If 1 Year Experience flag is true, update contract term and ensure only digital sub adjustment is applied.
        if(boolOneYearExp){
            liso.APTS_Contract_Term__c = '1 Year';

            //Modify adjustment amount if it isn't null, else do not modify and keep original value (which is 0.0)
            if(adjustmentAmount!=null && adjustmentAmount < 0){
                    liso.Apttus_Config2__AdjustmentType__c = '% Markup';
                    liso.Apttus_Config2__AdjustmentAmount__c = (-1) * adjustmentAmount;
            }
            else if(adjustmentAmount!=null && adjustmentAmount >= 0){
                liso.Apttus_Config2__AdjustmentType__c = '% Discount';
                liso.Apttus_Config2__AdjustmentAmount__c = adjustmentAmount;
            }
        }

        return lineItem;

    }//end of updateLineItemToOneYearExperience() method

    /**
        @description Update total points under productattributeValue of bundleproduct line item 
        @param bundleProdToPointsMap Map of bundle products to its points
        @param lineItemIdSET Set of line item ids
     */
    public static void updatePointsOnProductAttributeValue(Map<String, Decimal> bundleProdToPointsMap, Set<Id> lineItemIdSET){
        System.debug(LoggingLevel.DEBUG,'lineItemIdSET::' + lineItemIdSET);
        if (Schema.sObjectType.Apttus_Config2__ProductAttributeValue__c.isAccessible() 
            && Schema.sObjectType.Apttus_Config2__ProductAttributeValue__c.isUpdateable()) {
            list<Apttus_Config2__ProductAttributeValue__c > pAttrbtList = [
                SELECT Id, APTS_Total_Number_of_Points__c, Apttus_Config2__LineItemId__r.Apttus_Config2__ProductId__c
                FROM Apttus_Config2__ProductAttributeValue__c 
                WHERE Apttus_Config2__LineItemId__c IN :lineItemIdSET
            ];

            if (!pAttrbtList.isEmpty()) {
                System.debug(LoggingLevel.DEBUG,'pAttrbtList size() ::' + pAttrbtList.size());   
                for (Apttus_Config2__ProductAttributeValue__c att:pAttrbtList) {
                    att.APTS_Total_Number_of_Points__c = bundleProdToPointsMap.get(att.Apttus_Config2__LineItemId__r.Apttus_Config2__ProductId__c);
                }
                update pAttrbtList;
            }
        }
    }

    /**
        @description Sets the line item's contract term, called from populateYOY1()
        @param lineItem Line item object
        @param acctToPrds Digital subscription for given line item
        @param defaultByAccFirmMap Map of digital firm to default contract terms
        @return Updated line item object
     */
    public static Apttus_Config2__LineItem__c setLineItemContractTermYOY1(Apttus_Config2__LineItem__c lineItem,Product_Account_Detail__c acctToPrds,Map<String, DC_Contract_Term_V2__mdt> defaultByAccFirmMap){
        Apttus_Config2__LineItem__c liSO1 = lineItem;

        if (acctToPrds.Digital_Firm__c != null && acctToPrds.Digital_Firm__c != 'none' && !defaultByAccFirmMap.isEmpty() 
                && defaultByAccFirmMap.get(acctToPrds.Digital_Firm__c) != null) {
            liSO1.APTS_Contract_Term__c = defaultByAccFirmMap.get(acctToPrds.Digital_Firm__c).Contract_Term__c;
        }
        
        return liSO1;
    }    
    
    /**
        @description Sets the line item's year on year values, called from populateYOY1()
        @param lineItem Line item object
        @param acctToPrds Digital subscription for given line item
        @param defaultByAccFirmMap Map of digital firm to default contract terms
        @return Updated line item object
     */
    public static Apttus_Config2__LineItem__c setYearOnYearValuesYOY1(Apttus_Config2__LineItem__c lineItem,Product_Account_Detail__c acctToPrds,Map<String, DC_Contract_Term_V2__mdt> defaultByAccFirmMap){
        Apttus_Config2__LineItem__c liSO1 = lineItem;

        // Start DLT-10763
        if (acctToPrds.Year3_YoYvalue__c != null) {          
            liso1.APTS_Years_2_Plus_Adjustment__c = (acctToPrds.Year3_YoYvalue__c != null) ? 
                String.Valueof(acctToPrds.Year3_YoYvalue__c.intValue()) : '0';
            //DLT-14032 YOY1 is only for  Straight AND YOY2 for all
            // end DLT- 10763
        } else if (acctToPrds.Digital_Firm__c != null && acctToPrds.Digital_Firm__c != 'none' 
                && !defaultByAccFirmMap.isEmpty() && defaultByAccFirmMap.get(acctToPrds.Digital_Firm__c) != null) {
            if (defaultByAccFirmMap.get(acctToPrds.Digital_Firm__c).YoY_1_Renewal__c != null) {
                liSO1.APTS_Yr_1_Renewal_Adjustment__c = String.Valueof(
                    defaultByAccFirmMap.get(acctToPrds.Digital_Firm__c).YoY_1_Renewal__c.intValue()
                );
            }
            if(defaultByAccFirmMap.get(acctToPrds.Digital_Firm__c).DC_Years_2_Plus_Adjustment__c != null ){
                liSO1.APTS_Years_2_Plus_Adjustment__c = String.Valueof(
                    defaultByAccFirmMap.get(acctToPrds.Digital_Firm__c).DC_Years_2_Plus_Adjustment__c.intValue()
                );
            }
        }
        
        return liSO1;
    }    

    /**
        @description Add DC Contract Term to default map if metadata is set as default value
        @param dcConTerm DC Contract Term object
        @param defaultAccountMap Map of segment to dc contract term
        @return Updated defaultAccountMap
     */
    public static Map<String, DC_Contract_Term_V2__mdt> addTodDefaultByAccFirmMap(DC_Contract_Term_V2__mdt dcConTerm, Map<String, DC_Contract_Term_V2__mdt> defaultAccountMap ){
        Map<String, DC_Contract_Term_V2__mdt> defaultByAccFirmMap = defaultAccountMap;
        
        if (dcConTerm.Default_Customer_Category__c == true) {
            defaultByAccFirmMap.put(dcConTerm.Segment__c, dcConTerm);
        }

        return defaultByAccFirmMap;
    }

    /**
        @description Populates addToTempAccFirmByContractTerm
        @param dcConTerm DC Contract Term object
        @param tempAccountFirmToContractMap Map of Account to Customer Category to DC Contract Term object
        @return Updated tempAccFirmByContractTermMap
     */
    public static Map<String, Map<Integer, DC_Contract_Term_V2__mdt>> addToTempAccFirmByContractTerm(DC_Contract_Term_V2__mdt dcConTerm, Map<String, Map<Integer, DC_Contract_Term_V2__mdt>> tempAccountFirmToContractMap ){
        
        Map<String, Map<Integer, DC_Contract_Term_V2__mdt>> tempAccFirmByContractTermMap = tempAccountFirmToContractMap;
        
        if (!tempAccFirmByContractTermMap.containsKey(dcConTerm.Segment__c)) {
            tempAccFirmByContractTermMap.put(dcConTerm.Segment__c, new Map<Integer, DC_Contract_Term_V2__mdt>());
        }

        Map<Integer, DC_Contract_Term_V2__mdt> tempContractTermMap = new Map<Integer, DC_Contract_Term_V2__mdt>();
        tempContractTermMap.put(Integer.Valueof(dcConTerm.Customer_Category__c), dcConTerm);
        tempAccFirmByContractTermMap.get(dcConTerm.Segment__c).putAll(tempContractTermMap);

        return tempAccFirmByContractTermMap;

    }    
    
    /**
        @description Create Cart List for proposals. 
        @param quoteProposalIdList list of proposal ids
        @param quoteSoldToAccMap Map of proposal to SSD
        @param mapPropOwner Map of proposal to owner
        @return List of carts to be inserted
     */  
    public static List<Apttus_Config2__ProductConfiguration__c> prepareCartList(List<Id> quoteProposalIdList, Map<Id, Id> quoteSoldToAccMap, Map<Id, Id> mapPropOwner){
        
        List<Apttus_Config2__ProductConfiguration__c> cartList = new List<Apttus_Config2__ProductConfiguration__c>();
        
        for (Id proposalId : quoteProposalIdList) {
            Apttus_Config2__ProductConfiguration__c cart = new Apttus_Config2__ProductConfiguration__c(Apttus_QPConfig__Proposald__c = proposalId);
            //preparing cart data
            cart.Apttus_Config2__BusinessObjectType__c = 'Proposal';
            cart.Apttus_Config2__BusinessObjectRefId__c = proposalId;
            cart.Apttus_Config2__SummaryGroupType__c = 'Ad Hoc';
            cart.Apttus_Config2__PriceListId__c = Digital_CartCreationCommonVariables.plNameList[0].Id;
            cart.APTS_SSD_bill_to__c = quoteSoldToAccMap.get(proposalId);
            cart.APTS_SSD_ship_to__c = quoteSoldToAccMap.get(proposalId);
            // DLT-9536 - Set the cart owner to the Proposal owner 
            cart.OwnerID = mapPropOwner.get(proposalId);
            cart.createdById = mapPropOwner.get(proposalId); 
            cart.Apttus_Config2__EffectivePriceListId__c = Digital_CartCreationCommonVariables.plNameList[0].Id;
            cart.Apttus_Config2__VersionNumber__c = 1;
            cart.Apttus_Config2__IsPricePending__c = true;
            cart.Apttus_CQApprov__Approval_Preview_Status__c = 'Complete';
            cart.Digital_Pending_Cart__c = true;
            
            cartList.add(cart);
        }

        return cartList;
    }
    
    /**
        @description Returns the adjustment amount and also default discount based on DC_Contract_Term_V2__mdt, if applicable.
        @param acctDSmap Map of account to list of DS
        @param soldToAssets Asset
        @return Adjustment amount
     */
    public static double addStraightAdjustmentAmount(Map<String, List<Product_Account_Detail__c>> acctDSmap,Apttus_Config2__AssetLineItem__c soldToAssets){
        
        double adjustmentAmount = 0.0;

        //If defaultByAccFirmMap contains key-value pair and the pair is the default contract term
        if (Digital_CartCreationCommonVariables.defaultByAccFirmMap != null && !Digital_CartCreationCommonVariables.defaultByAccFirmMap.isEmpty() 
                && acctDSMap.containsKey(soldToAssets.APTS_SSD_Sold_To__c)
                && Digital_CartCreationCommonVariables.defaultByAccFirmMap.containsKey(acctDSmap.get(soldToAssets.APTS_SSD_Sold_To__c)[0].Digital_Firm__c)
                && Digital_CartCreationCommonVariables.defaultByAccFirmMap.get(acctDSmap.get(soldToAssets.APTS_SSD_Sold_To__c)[0].Digital_Firm__c).Default_Contract_Term__c == true) {
            
            String defaultContractTerm = Digital_CartCreationCommonVariables.defaultByAccFirmMap.get(acctDSmap.get(soldToAssets.APTS_SSD_Sold_To__c)[0].Digital_Firm__c).Contract_Term__c;

            //Set adjustmentAmount to Discount value found in DS, otherwise leave as 0.0
            if(acctDSmap.get(soldToAssets.APTS_SSD_Sold_To__c)[0].Offer_Price__c != null){
                adjustmentAmount = acctDSmap.get(soldToAssets.APTS_SSD_Sold_To__c)[0].Offer_Price__c;
            }

            //Adds a default discount to adjustmentAmount based on the default contract term's value.
            if (defaultContractTerm.equalsIgnoreCase('3 Years')) {
                adjustmentAmount = adjustmentAmount + Digital_CartCreationCommonVariables.defaultByAccFirmMap.get(acctDSmap.get(soldToAssets.APTS_SSD_Sold_To__c)[0].Digital_Firm__c).DC_Years_2_Plus_Adjustment__c.intValue();
            }
            else if(defaultContractTerm.equalsIgnoreCase('2 Years')) {
                adjustmentAmount = adjustmentAmount + Digital_CartCreationCommonVariables.defaultByAccFirmMap.get(acctDSmap.get(soldToAssets.APTS_SSD_Sold_To__c)[0].Digital_Firm__c).YoY_1_Renewal__c.intValue();
            }
        }

        return adjustmentAmount;

    }//end of addStraightAdjustmentAmount() method

    /**
        @description Updates adjustment values for Straight Renewals
        @param lineItem Line item object to be updated
        @param soldToAssets Asset of line item
        @param acctDSmap Map of account to list of DS
        @return Updated line item object
     */
    public static Apttus_Config2__LineItem__c updateStraightRenewalAdjustments(Apttus_Config2__LineItem__c lineItem, Apttus_Config2__AssetLineItem__c soldToAssets,Map<String, List<Product_Account_Detail__c>> acctDSmap){
        Apttus_Config2__LineItem__c liSO = lineItem;

        if (acctDSmap.get(soldToAssets.APTS_SSD_Sold_To__c)[0].Offer_Price__c < 0 
                && acctDSmap.get(soldToAssets.APTS_SSD_Sold_To__c)[0].Offer_Price__c != null) {
            liso.Apttus_Config2__AdjustmentType__c = '% Markup';

            if(acctDSmap.get(soldToAssets.APTS_SSD_Sold_To__c)[0].Digital_Firm__c=='FindLaw'){ //DLT-19023
                liso = getFindLawStraightAdjustmentValue(liso,acctDSmap,soldToAssets);
            }
            else{
                liso.Apttus_Config2__AdjustmentAmount__c = (-1) * (acctDSmap.get(soldToAssets.APTS_SSD_Sold_To__c)[0].Offer_Price__c);
            }
        } else {
            liso.Apttus_Config2__AdjustmentType__c = '% Discount';
            liso.Apttus_Config2__AdjustmentAmount__c = addStraightAdjustmentAmount(acctDSmap,soldToAssets);
        }

        return liSO;
    }

    /**
        @description Returns updated FindLaw Apttus_Config2__LineItem__c
        @param liso Line item object
        @param acctDSmap Map of account to list of DS
        @param soldToAssets Asset of line item
        @return Returns updated line item
     */
    public static Apttus_Config2__LineItem__c getFindLawStraightAdjustmentValue(Apttus_Config2__LineItem__c liso, Map<String, List<Product_Account_Detail__c>> acctDSmap,Apttus_Config2__AssetLineItem__c soldToAssets){
        Apttus_Config2__LineItem__c templiso = liso;
        
        templiso.Apttus_Config2__AdjustmentAmount__c = addStraightAdjustmentAmount(acctDSmap,soldToAssets);
        templiso.Apttus_Config2__AdjustmentAmount__c *= (-1);

        if(templiso.Apttus_Config2__AdjustmentAmount__c < 0){  
            templiso.Apttus_Config2__AdjustmentType__c = '% Discount';
            templiso.Apttus_Config2__AdjustmentAmount__c = Math.abs(liso.Apttus_Config2__AdjustmentAmount__c);
        }

        return templiso;
    }//end of getFindLawStraightAdjustmentValue() method
    
    /**
        @description Sets the line item contract term, called from popuateYOY2() method
        @param lineItem Line item object
        @param acctDSmap Map of account to list of DS
        @param soldToAssets Asset of line item
        @return Returns updated line item
     */
    public static Apttus_Config2__LineItem__c setLineItemContractTermYOY2(Apttus_Config2__LineItem__c lineItem,Map<String, List<Product_Account_Detail__c>> acctDSmap, Apttus_Config2__AssetLineItem__c soldToAssets){
        Apttus_Config2__LineItem__c liSO1 = lineItem;

        liso1.Apttus_Config2__PricingStatus__c = 'Pending';  // DLT-15692 update to pending FROM Complete AND update price Findlaw DLT-15692
        
        if (acctDSmap != null && !acctDSmap.isEmpty() && !acctDSmap.get(soldToAssets.APTS_SSD_Sold_To__c).isEmpty() 
                && acctDSmap.get(soldToAssets.APTS_SSD_Sold_To__c)[0].Digital_Firm__c != null 
                && acctDSmap.get(soldToAssets.APTS_SSD_Sold_To__c)[0].Digital_Firm__c != 'none') {
            //if(acctDSmap.get(soldToAssets.APTS_SSD_Sold_To__c)[0].Digital_Firm__c!='FindLaw') {
            liso1.APTS_Contract_Term__c = Digital_CartCreationCommonVariables.defaultByAccFirmMap.get(acctDSmap.get(soldToAssets.APTS_SSD_Sold_To__c)[0].Digital_Firm__c).Contract_Term__c;  //FL update imct all 
            // DLT-16401 changed for multi-year pricing AND used Custom Metadata Type DC Contract Term V2 Setting
            //}
        }
        
        return liSO1;
    }   

    /**
        @description Sets the line item pricing details, called from popuateYOY1() method
        @param lineItem Line item object
        @param acctToPrds DS record for account
        @param priceListMap2 Map of product to its price list item
        @return Line item object
     */
    public static Apttus_Config2__LineItem__c setPricingDetailsYOY1(Apttus_Config2__LineItem__c lineItem,Product_Account_Detail__c acctToPrds,Map<Id,Apttus_Config2__PriceListItem__c> priceListMap2){
        Apttus_Config2__LineItem__c liSO1 = lineItem;

        if (priceListMap2 != null && acctToPrds != null && (acctToPrds.Actual_New_Subscription_Product__c != null) 
                && (priceListMap2.get(acctToPrds.Actual_New_Subscription_Product__c) != null)) {
            liSO1.Apttus_Config2__SellingFrequency__c = priceListMap2.get(acctToPrds.Actual_New_Subscription_Product__c).Apttus_Config2__Frequency__c != null ? 
                priceListMap2.get(acctToPrds.Actual_New_Subscription_Product__c).Apttus_Config2__Frequency__c : '';

            liSO1.Apttus_Config2__PriceType__c = priceListMap2.get(acctToPrds.Actual_New_Subscription_Product__c).Apttus_Config2__PriceType__c;
            liSO1.Apttus_Config2__Frequency__c = priceListMap2.get(acctToPrds.Actual_New_Subscription_Product__c).Apttus_Config2__Frequency__c != null ? 
                priceListMap2.get(acctToPrds.Actual_New_Subscription_Product__c).Apttus_Config2__Frequency__c : '';

            liSO1.Apttus_Config2__PriceListItemId__c = priceListMap2.get(acctToPrds.Actual_New_Subscription_Product__c).Id;
            liSO1.Apttus_Config2__ChargeType__c = priceListMap2.get(acctToPrds.Actual_New_Subscription_Product__c).Apttus_Config2__ChargeType__c;
            liSO1.Apttus_Config2__PriceUom__c = priceListMap2.get(acctToPrds.Actual_New_Subscription_Product__c).Apttus_Config2__PriceUom__c;
            liSO1.Apttus_Config2__PriceMethod__c = priceListMap2.get(acctToPrds.Actual_New_Subscription_Product__c).Apttus_Config2__PriceMethod__c;    

            
            System.debug(LoggingLevel.DEBUG,'test remove' + acctToPrds.Contract_Type__c + priceListMap2 + acctToPrds.Default_Add_On__c);
            
            liSO1 = setPricingDetailsNewMidContract(liSO1,acctToPrds,priceListMap2);

        }
        
        return liSO1;
    }

    /**
        @description Sets the pricing details for new mid contract line items
        @param lineItem Line item object
        @param acctToPrds DS record for account
        @param priceListMap2 Map of product to its price list item
        @return Line item object
     */
    public static Apttus_Config2__LineItem__c setPricingDetailsNewMidContract(Apttus_Config2__LineItem__c lineItem,Product_Account_Detail__c acctToPrds,Map<Id,Apttus_Config2__PriceListItem__c> priceListMap2){
 
        Apttus_Config2__LineItem__c liSO1 = lineItem;

        if(acctToPrds.Contract_Type__c == 'New Mid Contract' 
                && priceListMap2.get(Digital_CartCreationCommonVariables.mapOfProductIds.get(acctToPrds.Add_On_Svc__c)) != null 
                && acctToPrds.Default_Add_On__c == true) {
            liSO1.Apttus_Config2__SellingFrequency__c = priceListMap2.get(Digital_CartCreationCommonVariables.mapOfProductIds.get(acctToPrds.Add_On_Svc__c)).Apttus_Config2__Frequency__c != null ? 
                priceListMap2.get(acctToPrds.Actual_New_Subscription_Product__c).Apttus_Config2__Frequency__c : '';

            liSO1.Apttus_Config2__PriceType__c = priceListMap2.get(Digital_CartCreationCommonVariables.mapOfProductIds.get(acctToPrds.Add_On_Svc__c)).Apttus_Config2__PriceType__c;
            liSO1.Apttus_Config2__Frequency__c = priceListMap2.get(Digital_CartCreationCommonVariables.mapOfProductIds.get(acctToPrds.Add_On_Svc__c)).Apttus_Config2__Frequency__c != null ? 
                priceListMap2.get(acctToPrds.Actual_New_Subscription_Product__c).Apttus_Config2__Frequency__c : '';

            liSO1.Apttus_Config2__PriceListItemId__c = priceListMap2.get(Digital_CartCreationCommonVariables.mapOfProductIds.get(acctToPrds.Add_On_Svc__c)).Id;
            liSO1.Apttus_Config2__ChargeType__c = priceListMap2.get(Digital_CartCreationCommonVariables.mapOfProductIds.get(acctToPrds.Add_On_Svc__c)).Apttus_Config2__ChargeType__c;
            liSO1.Apttus_Config2__PriceUom__c = priceListMap2.get(Digital_CartCreationCommonVariables.mapOfProductIds.get(acctToPrds.Add_On_Svc__c)).Apttus_Config2__PriceUom__c;
            liSO1.Apttus_Config2__PriceMethod__c = priceListMap2.get(Digital_CartCreationCommonVariables.mapOfProductIds.get(acctToPrds.Add_On_Svc__c)).Apttus_Config2__PriceMethod__c;
        }

        return liSO1;
    }
    
    /**
        @description Check if DS YOY 3 is populated
        @param acctDSmap Map of Account to list of DS
        @param soldToAssets Asset for the account
        @return Boolean
     */
    public static boolean isPopulatedYearThreeYOYDigitalSubcription(Map<String, List<Product_Account_Detail__c>> acctDSmap,Apttus_Config2__AssetLineItem__c soldToAssets){
        if(acctDSmap != null && !acctDSmap.isEmpty() && acctDSmap.containsKey(soldToAssets.APTS_SSD_Sold_To__c) && !acctDSmap.get(soldToAssets.APTS_SSD_Sold_To__c).isEmpty() 
                && acctDSmap.get(soldToAssets.APTS_SSD_Sold_To__c)[0].Digital_Firm__c != 'FindLaw' 
                && (acctDSmap.get(soldToAssets.APTS_SSD_Sold_To__c)[0] != null) 
                && (acctDSmap.get(soldToAssets.APTS_SSD_Sold_To__c)[0].Year3_YoYvalue__c != null)){
            return true;
        }
        else{
            return false;
        }
    }

    /**
        @description Check if account's digital firm is found in contract term settings
        @param soldToAssets Asset for the account
        @param contractTermsMap Map of account to customer category to contract term settings
        @return Boolean
     */
    public static boolean isAccountDigitalFirmToContractTermExist(Apttus_Config2__AssetLineItem__c soldToAssets,Map<String, Map<Integer, DC_Contract_Term_V2__mdt>> contractTermsMap){
        if(soldToAssets.APTS_SSD_ship_to__r.APTS_Customer_Category__c != null && Digital_CartCreationCommonVariables.dgfirmap != null 
                && isDigitalFirmMapValueExist(soldToAssets)
                && isContractTermsMapValueExist(soldToAssets,contractTermsMap)){
            return true;
        }
        else{
            return false;
        }
    }

    /**
        @description Check if account is found in list of digitla firms
        @param soldToAssets Asset for the account
        @return Boolean
     */
    private static boolean isDigitalFirmMapValueExist(Apttus_Config2__AssetLineItem__c soldToAssets){
        if(Digital_CartCreationCommonVariables.dgfirmap.get(soldToAssets.APTS_SSD_Ship_to__r.Source_System_Account_Number__c) != null 
            && Digital_CartCreationCommonVariables.dgfirmap.get(soldToAssets.APTS_SSD_Ship_to__r.Source_System_Account_Number__c) != 'FindLaw' 
            && Digital_CartCreationCommonVariables.dgfirmap.get(soldToAssets.APTS_SSD_Ship_to__r.Source_System_Account_Number__c) != 'none' ){
            return true;
        }
        else{
            return false;
        }
    }

    /**
        @description Check if account's digital firm is found in contract term settings
        @param soldToAssets Asset for the account
        @param contractTermsMap Map of account to customer category to contract term settings
        @return Boolean
     */
    private static boolean isContractTermsMapValueExist(Apttus_Config2__AssetLineItem__c soldToAssets,Map<String, Map<Integer, DC_Contract_Term_V2__mdt>> contractTermsMap){
        if(contractTermsMap != null && contractTermsMap.size() > 0 
            && contractTermsMap.get(Digital_CartCreationCommonVariables.dgfirmap.get(soldToAssets.APTS_SSD_Ship_to__r.Source_System_Account_Number__c)) != null 
            && contractTermsMap.get(Digital_CartCreationCommonVariables.dgfirmap.get(soldToAssets.APTS_SSD_Ship_to__r.Source_System_Account_Number__c)).get(Integer.Valueof(soldToAssets.APTS_SSD_ship_to__r.APTS_Customer_Category__c)) != null){
            return true;
        }
        else{
            return false;
        }
    }

    /**
        @description Check if account's digital firm is found in default contract term settings
        @param soldToAssets Asset for the account
        @return Boolean
     */
    public static boolean isDigitalFirmToDefaultContractTermExist(Apttus_Config2__AssetLineItem__c soldToAssets){
        if(Digital_CartCreationCommonVariables.dgfirmap != null && !Digital_CartCreationCommonVariables.dgfirmap.isEmpty() && Digital_CartCreationCommonVariables.defaultByAccFirmMap != null 
                && !Digital_CartCreationCommonVariables.defaultByAccFirmMap.isEmpty() && Digital_CartCreationCommonVariables.dgfirmap.get(soldToAssets.APTS_SSD_Ship_to__r.Source_System_Account_Number__c) != null 
                && Digital_CartCreationCommonVariables.dgfirmap.get(soldToAssets.APTS_SSD_Ship_to__r.Source_System_Account_Number__c) != 'FindLaw' 
                && Digital_CartCreationCommonVariables.dgfirmap.get(soldToAssets.APTS_SSD_Ship_to__r.Source_System_Account_Number__c) != 'none'){
            return true;
        }
        else{
            return false;
        }
    }
    
    private static boolean isNotBundleDigitalSub(Product_Account_Detail__c pdc){
        if(pdc.Bundle_Id__c == null || pdc.Bundle_Id__c == ''){
            return true;
        }
        else{
            return false;
        }
    }
    private static boolean isNotEmptyDigitalSub(Product_Account_Detail__c pdc){
        if((pdc.Actual_New_Service__c != null && pdc.Actual_New_Subscription__c != null) 
            || pdc.Current_Subscription__c != null 
            || (pdc.Add_on_Type__c == 'Plus' && pdc.Add_On_Sub__c != null 
            && pdc.Contract_Type__c == 'New Mid Contract' && pdc.Default_Add_On__c == true)){
            return true;
        }
        else{
            return false;
        }
    }
    
    /**
        @description Add DS for straight renewl quotes
        @param quoteName Digital Quote Type being created
        @param pdc Digital subscription to be added
        @param padList List of DS records
     */
    public static void addStraightpadList(String quoteName,Product_Account_Detail__c pdc,List<Product_Account_Detail__c> padList){
        if (quoteName == 'Straight Renewal' && pdc.Current_Subscription__c != null) {
            padList = addTopadListHelper(padList,pdc);
        }  
    }

    /**
        @description Add DS for straight renewl quotes
        @param quoteName Digital Quote Type being created
        @param pdc Digital subscription to be added
        @param padList List of DS records
     */
    public static void addBestpadList(String quoteName,Product_Account_Detail__c pdc,List<Product_Account_Detail__c> padList){
       // DLT-17793 excluded option product digital subscriptions
        if (quoteName == 'Best Value' 
            && ( Digital_CartCreationHelper.isNotBundleDigitalSub(pdc) ) 
            && ( Digital_CartCreationHelper.isNotEmptyDigitalSub(pdc) ) 
            && (pdc.Type__c == 'Plus' || pdc.Type__c =='Config' || pdc.Type__c =='Premium') ) {
                    
            padList = addTopadListHelper(padList,pdc);    
        }
    }

    /**
        @description Add DS for straight renewl quotes
        @param quoteName Digital Quote Type being created
        @param pdc Digital subscription to be added
        @param padList List of DS records
     */
    public static void addPremiumpadList(String quoteName,Product_Account_Detail__c pdc,List<Product_Account_Detail__c> padList){
        if (quoteName == 'Premium'&& (pdc.Bundle_Id__c == null || pdc.Bundle_Id__c == '') 
                && pdc.Type__c == 'Premium' && pdc.Type__c != 'Config' 
                && ((pdc.Premium_New_Service__c != null && pdc.Premium_New_Subscription__c != null) 
                || pdc.Current_Subscription__c != null)) {
                    
            padList = addTopadListHelper(padList,pdc);
        }
    }
    /**
        @description Populates 'priceListMap'
        @param productToDSMap Map of products to its price list item
        @return Updated productToDSMap
     */
    public static Map<Id, Apttus_Config2__PriceListItem__c> getPriceListMap(Map<String, Product_Account_Detail__c> productToDSMap){
        Map<Id, Apttus_Config2__PriceListItem__c> priceListMap = new Map<Id, Apttus_Config2__PriceListItem__c>();

        if (productToDSMap != null && !productToDSMap.isEmpty()) {
            for (Apttus_Config2__PriceListItem__c priceList : [
                    SELECT Id, Apttus_Config2__ProductId__c, Apttus_Config2__ChargeType__c, 
                        Apttus_Config2__PriceType__c, Apttus_Config2__Frequency__c, 
                        Apttus_Config2__PriceMethod__c, Apttus_Config2__PriceUom__c 
                    FROM Apttus_Config2__PriceListItem__c 
                    WHERE Apttus_Config2__ProductId__c IN :productToDSMap.keyset() 
                    AND Apttus_Config2__PriceListId__c = :Digital_CartCreationCommonVariables.plNameList[0].Id AND Apttus_Config2__Active__c = true 
                    AND Apttus_Config2__ProductActive__c = true ]) {

                priceListMap.put(priceList.Apttus_Config2__ProductId__c, priceList);
            }
        }

        return priceListMap;
    }

    /**
        @description Set adjustments for default addon line items
        @param liSO1 Line item object
        @param acctToPrds DS of line item
     */
    public static void setYOY1AdjustmentForDefaultAddon(Apttus_Config2__LineItem__c liSO1,Product_Account_Detail__c acctToPrds){
        
        liSO1.DC_Is_Add_On__c = false;
        if (acctToPrds.Contract_Type__c == 'New Mid Contract' && acctToPrds.Add_On_Type__c == 'Plus' 
                && acctToPrds.Add_On_Sub__c != null && acctToPrds.Default_Add_On__c == true 
                && Digital_CartCreationCommonVariables.discountAdjAmountMap != null && !Digital_CartCreationCommonVariables.discountAdjAmountMap.isEmpty()) {   //DLT-16116  Moved offer check below sometime Dissount not there for New Mid Contract by SK
            liSO1.Apttus_Config2__AdjustmentType__c = '% Discount';
            liSO1.Apttus_Config2__AdjustmentAmount__c =Digital_CartCreationCommonVariables.discountAdjAmountMap.get(acctToPrds.ZP_Cust_Number__c);
            liSO1.DC_Is_Add_On__c = true; //DLT-16116 Added for New Mid Contract by SK
        }
    }
    /**
        @description Set adjustments for line items
        @param liSO1 Line item object
        @param bestValueProductToDSMap Map of product to DS
        @param acctToPrds DS record
     */
    public static void setYOY1Adjustments(Apttus_Config2__LineItem__c liSO1,Map<String,Product_Account_Detail__c> bestValueProductToDSMap,Product_Account_Detail__c acctToPrds){
        if (bestValueProductToDSMap.get(acctToPrds.Actual_New_Subscription_Product__c).Offer_Price__c >= 0 
        && bestValueProductToDSMap.get(acctToPrds.Actual_New_Subscription_Product__c).Offer_Price__c <= 100) {     
            liSO1.Apttus_Config2__AdjustmentType__c = '% Discount';
            liSO1.Apttus_Config2__AdjustmentAmount__c = bestValueProductToDSMap.get(acctToPrds.Actual_New_Subscription_Product__c).Offer_Price__c;
            //added as part of DLT-16234 by navleen
            Digital_CartCreationCommonVariables.discountAdjAmountMap.put(
                acctToPrds.ZP_Cust_Number__c,
                bestValueProductToDSMap.get(acctToPrds.Actual_New_Subscription_Product__c).Offer_Price__c
            );
        } else {
            liSO1.Apttus_Config2__AdjustmentType__c = '% Markup';
            liSO1.Apttus_Config2__AdjustmentAmount__c = (-1) * (bestValueProductToDSMap.get(acctToPrds.Actual_New_Subscription_Product__c).Offer_Price__c);
        }
    }
    //addTopadListHelper() method
    //Add product account detail to list based on midcontrct information
    private static List<Product_Account_Detail__c> addTopadListHelper(List<Product_Account_Detail__c> productAccountDetailList, Product_Account_Detail__c pdc){
        List<Product_Account_Detail__c> padList = productAccountDetailList;

        //DLT-12193 if Mid Contract is denied, add only midcontract false DS records
        if ((pdc.Contract_Type__c != 'Old Mid Contract') 
            && !Digital_CartCreationCommonCode.setSSDOpptyMidConDenied.isEmpty() && Digital_CartCreationCommonCode.setSSDOpptyMidConDenied.contains(pdc.AccountSSD__c)) {
            padList.add(pdc);
        }
        //Add if Mid-Contract is not denied (or not a Mid-Contract offer, see buildSSDOpportunityMidContractMaps() method)
        if (!Digital_CartCreationCommonCode.setSSDOpptyMidConNotDenied.isEmpty() && Digital_CartCreationCommonCode.setSSDOpptyMidConNotDenied.contains(pdc.AccountSSD__c)) {
            padList.add(pdc);
        }   //DLT-12193 Ends

        return padList;
    }    

    /**
        @description Checks if asset is actionable asset
        @param addedAssetSet Set of assets already processed
        @param soldToAssets Asset being checked
        @param digiFirm Digital firm
        @return Boolean
     */
    public static boolean isValidAsset(Set<Id> addedAssetSet,Apttus_Config2__AssetLineItem__c soldToAssets,string digiFirm){
        if(!addedAssetSet.contains(soldToAssets.Id) && (soldToAssets.Apttus_Config2__OptionId__c == null)
                &&(digiFirm != Digital_CartCreationCommonVariables.SEGMENT_FINDLAW
                &&( soldToAssets.Apttus_Config2__AllowedActions__c == 'Renew' 
                || soldToAssets.Apttus_Config2__AllowedActions__c == null 
                || soldToAssets.Apttus_Config2__AllowedActions__c == '')) 
                || (digiFirm == Digital_CartCreationCommonVariables.SEGMENT_FINDLAW)){
            return true;
        }
        else{
            return false;
        }
    }
}