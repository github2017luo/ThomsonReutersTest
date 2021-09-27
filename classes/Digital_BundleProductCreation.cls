/**********************************************************************************************************************
Change History
***********************************************************************************************************************
Name                    Date            JIRA            Description
Benjami Her             2020-11-04      DLT-20755       Initial Creation. PMD fix
************************************************************************************************************************************/

public without sharing class Digital_BundleProductCreation{
 
    private static Map<Id, Apttus_Config2__PriceListItem__c> priceListMap = new Map<Id, Apttus_Config2__PriceListItem__c>();
    private static Map<Id, Apttus_Config2__ProductOptionComponent__c> avaialbleOptionsMap;
    private static Set<String> setSubNum = new Set<String>();
    private static Set<String> bundleProdIdSet = new Set<String>();
    private static List<Product_Account_Detail__c> dsOptionPordList = new List<Product_Account_Detail__c>();
    private static Map<String, Product_Account_Detail__c> prodToPADetailMap = new Map<String, Product_Account_Detail__c>();
    private static Map<String, List<Product_Account_Detail__c>> bundleprodToOptionsMap = new Map<String, List<Product_Account_Detail__c>>();
    private static Map<String, Decimal> bundleprodToPointsMap = new Map<String, Decimal>();
    private static List<Product_Account_Detail__c> optionsProdDetailsList;
    
    // addOptionsandPerformBundling
    public static void addOptionsandPerformBundling(Id cartId, String dcQuoteType,List<Product_Account_Detail__c> dSubList) {
        
       
        // Get Subscription numbers for best AND premium 
        for (product_Account_Detail__c pad : dSubList) {
            if(String.isBlank(pad.Bundle_Id__c)){
                continue;
            }
                 
            if (dcQuoteType=='Best Value' && pad.Actual_New_Subscription__c != null) {
                setSubNum.add(pad.Actual_New_Subscription__c); 
                populateBundleData(pad);
            } else if (dcQuoteType=='Premium' && pad.premium_New_Subscription__c != null) {
                setSubNum.add(pad.premium_New_Subscription__c );
                populateBundleData(pad);
            }
        }

        for (Apttus_Config2__PriceListItem__c priceList : [
                SELECT Id, Apttus_Config2__ProductId__c, Apttus_Config2__ChargeType__c, Apttus_Config2__PriceType__c, 
                    Apttus_Config2__Frequency__c, Apttus_Config2__PriceMethod__c, Apttus_Config2__PriceUom__c 
                FROM Apttus_Config2__PriceListItem__c 
                WHERE (Apttus_Config2__ProductId__c IN :prodToPADetailMap.keyset() OR Apttus_Config2__ProductId__c IN :bundleprodToOptionsMap.keyset()) 
                AND Apttus_Config2__PriceListId__c = :Digital_CartCreationCommonVariables.plNameList[0].Id AND Apttus_Config2__Active__c = true 
                AND Apttus_Config2__ProductActive__c = true ]) {

            priceListMap.put(priceList.Apttus_Config2__ProductId__c,priceList);
        }        
        
        System.debug('Filters ::' + setSubNum + bundleProdIdSet + dsOptionPordList);

        if (Schema.sObjectType.Apttus_Config2__ProductOptionComponent__c.isQueryable()) {
            avaialbleOptionsMap = new Map<Id,Apttus_Config2__ProductOptionComponent__c>([
                SELECT Id, Apttus_Config2__ComponentProductId__c, Apttus_Config2__Required__c, 
                    Apttus_Config2__DefaultQuantity__c, Apttus_Config2__ComponentProductId__r.Name, 
                    Apttus_Config2__ParentProductId__r.Id, Apttus_Config2__ComponentProductId__r.Subscription_Number__c 
                FROM Apttus_Config2__ProductOptionComponent__c 
                WHERE Apttus_Config2__ComponentProductId__r.Subscription_Number__c IN :setSubNum 
                AND Apttus_Config2__ParentProductId__r.Id IN :bundleProdIdSet]);
        }
        System.debug('avaialbleOptionsMap keyset:' + avaialbleOptionsMap.keyset());

        if(avaialbleOptionsMap.isEmpty()){
            System.debug('No Bundle Product Found');
            return;
        }

        createBundleAndOptions(cartId);
        
        Set<Id> lineItemIdSET = new Set<Id>();
            //Updated List in it , not as soql //DLT-18962
        for (Apttus_Config2__LineItem__c line : 
                [SELECT Id 
                FROM Apttus_Config2__LineItem__c 
                WHERE Apttus_Config2__ConfigurationId__c = :cartId 
                AND Apttus_Config2__HasOptions__c = true 
                AND Apttus_Config2__ProductId__c IN :bundleProdToPointsMap.keySet()]) {
                    
            lineItemIdSET.add(line.Id);
        }
        //Update total points under productattributeValue of bundleproduct line item 
        Digital_CartCreationHelper.updatePointsOnProductAttributeValue(bundleprodToPointsMap, lineItemIdSET);
    
    }

    //createBundleAndOptions() method
    //Creates Apttus request fro bundle/option products
    private static void createBundleAndOptions(Id cartId){

        for (String bProdId: bundleprodToOptionsMap.keySet()) {
            Apttus_CPQApi.CPQ.AddBundleRequestDO request = new Apttus_CPQApi.CPQ.AddBundleRequestDO(); 
            request.cartId = cartId;
            request.SelectedBundle = new Apttus_CPQApi.CPQ.SelectedBundleDO();
            request.SelectedBundle.SelectedProduct = new Apttus_CPQApi.CPQ.SelectedProductDO();
            request.SelectedBundle.SelectedProduct.ProductId = bProdId;
            request.SelectedBundle.SelectedProduct.Quantity = bundleprodToOptionsMap.get(bProdId)[0].Quantity__c; 
            request.SelectedBundle.SelectedProduct.SellingTerm = 1;
            request.SelectedBundle.SelectedProduct.comments = 'Inserted via CXD Renewals Automation';
        
            List<String> customFields = new List<String>();
            customFields = Digital_CartCreationHelper.addCustomFieldsYOY1();

            Apttus_Config2__LineItem__c newliSO = new Apttus_Config2__LineItem__c();                
                                                
            System.debug('bundleprodToOptionsMap' + bundleprodToOptionsMap);
            newliSO = Digital_CartCreationCommonCode.populateConfigLineItemYOY1(bundleprodToOptionsMap.get(bProdId)[0], prodToPADetailMap, priceListMap); 
            System.debug('newliSO ' + newliSO + newliSO.Apttus_Config2__BillingFrequency__c );
                
            request.SelectedBundle.SelectedProduct.CustomFields = customFields;
            request.SelectedBundle.SelectedProduct.CustomData = newliSO;
            System.debug('bundleprodToOptionsMap.get(bProdId)[0]::' + bundleprodToOptionsMap.get(bProdId)[0]);

            List<Product_Account_Detail__c> padOptionsListForBundle = bundleprodToOptionsMap.get(bProdId);
            List<Apttus_CPQApi.CPQ.SelectedOptionDO> options = new List<Apttus_CPQApi.CPQ.SelectedOptionDO>();

            for (Product_Account_Detail__c pad : padOptionsListForBundle) {
                
                options.add(getOption(pad,prodToPADetailMap));
            }
            request.SelectedBundle.SelectedOptions.addAll(options);
            System.debug('bundle request:::'+request);
            System.debug('after options' );

            if (!Test.isRunningTest()) {
                Apttus_CPQApi.CPQ.AddBundleResponseDO response = Apttus_CPQApi.CPQWebService.addBundle(request);
                
            } else {
                Apttus_CPQApi.CPQ.AddBundleResponseDO response = null;
            }
        } 
    }

    //populateBundleData() method
    //Populates variables needed to create bundle/option products
    public static void populateBundleData(Product_Account_Detail__c pad){

        bundleProdIdSet.add(pad.Bundle_Id__c);
        dsOptionPordList.add(pad);
        prodToPADetailMap.put(pad.Actual_New_Subscription_Product__c, pad); 
        
        if (bundleprodToOptionsMap != null && bundleprodToOptionsMap.get(pad.Bundle_Id__c) != null) {
            List<product_Account_Detail__c> availabledsopProdList = bundleprodToOptionsMap.get(pad.Bundle_Id__c);
            availabledsopProdList.add(pad);
            bundleprodToOptionsMap.put(pad.Bundle_Id__c,availabledsopProdList);
        } else {
            optionsProdDetailsList = new List<Product_Account_Detail__c>();
            optionsProdDetailsList.add(pad);
            bundleprodToOptionsMap.put(pad.Bundle_Id__c,optionsProdDetailsList);
        }

        if(bundleprodToPointsMap != null && bundleprodToPointsMap.get(pad.Bundle_Id__c) != null && pad.Actual_New_Subscription_Product__r.APTS_Module_Points__c != null) {
            system.debug('values::'+bundleprodToPointsMap.get(pad.Bundle_Id__c) + pad.Actual_New_Subscription_Product__c);
            Decimal points = bundleprodToPointsMap.get(pad.Bundle_Id__c) + pad.Actual_New_Subscription_Product__r.APTS_Module_Points__c;
            bundleprodToPointsMap.put(pad.Bundle_Id__c,points);
        } else if(pad.Actual_New_Subscription_Product__r.APTS_Module_Points__c != null){
            bundleprodToPointsMap.put(
                pad.Bundle_Id__c,
                pad.Actual_New_Subscription_Product__r.APTS_Module_Points__c
            );
            
            if (Test.isRunningTest()) {
                bundleprodToPointsMap.put(pad.Bundle_Id__c, 1.0);
            }
        }
    }
        
    // getOption
    private static Apttus_CPQApi.CPQ.SelectedOptionDO getOption(Product_Account_Detail__c pad,Map<String, Product_Account_Detail__c> prodToPADetailMap) {
        List<Apttus_Config2__ProductOptionComponent__c> availableOptionsInBundleList;
        Apttus_CPQApi.CPQ.SelectedOptionDO objSelectedOptionDO = new Apttus_CPQApi.CPQ.SelectedOptionDO();
        Apttus_CPQApi.CPQ.ProductOptionGroupSearchResultDO result = Apttus_CPQApi.CPQWebService.getOptionGroupsForPriceListProduct(Digital_CartCreationCommonVariables.plNameList[0].Id,pad.Bundle_Id__c);
        List<Apttus_CPQApi.CPQ.ProductOptionGroupDO> prodOptGrpDOList = result.OptionGroups;
        
        // only one group 
        for (Apttus_CPQApi.CPQ.ProductOptionGroupDO prodOptGrpDO : prodOptGrpDOList) {
            if (avaialbleOptionsMap != null && prodOptGrpDO.HasOptionComponents) {
                List<Apttus_CPQApi.CPQ.ProductOptionComponentDO> prodOptCompDOList = new List<Apttus_CPQApi.CPQ.ProductOptionComponentDO>();
                prodOptCompDOList = prodOptGrpDO.OptionComponents; 
                for (Apttus_CPQApi.CPQ.ProductOptionComponentDO prodOptCompDO : prodOptCompDOList) {
                    System.debug('prodOptCompDO ::' + prodOptCompDO);
                    System.debug('pad data:' + pad.current_subscription__c + ' ' + avaialbleOptionsMap.get(prodOptCompDO.ComponentId)+ ' '+ prodOptCompDO.ComponentId);
                    
                    objSelectedOptionDO = createOptionProduct(pad,prodOptCompDO.ComponentId,prodOptCompDO.ComponentProductId);
                    //If option product request was created successfully ComponentId is not null so return options product request, else continue looping
                    if(objSelectedOptionDO.ComponentId != null){
                        return objSelectedOptionDO;
                    }
                }
            }
        }
        
        return objSelectedOptionDO;
    }
    
    //createOptionProduct() method
    //Returns Apttus_CPQApi.CPQ.SelectedOptionDO if options product matches DS record
    //Else return null value that will be handled in getOption() method
    public static Apttus_CPQApi.CPQ.SelectedOptionDO createOptionProduct(Product_Account_Detail__c pad,id compId, id compProductId){
        
        Apttus_CPQApi.CPQ.SelectedOptionDO objSelectedOptionDO = new Apttus_CPQApi.CPQ.SelectedOptionDO();
        
        if (avaialbleOptionsMap.get(compId) != null 
                && ( (pad.Actual_New_Subscription_Product__c != null 
                && pad.Actual_New_Subscription_Product__c == avaialbleOptionsMap.get(compId).Apttus_Config2__ComponentProductId__r.Id) 
                || (pad.current_subscription__c != null 
                && pad.current_subscription__c == avaialbleOptionsMap.get(compId).Apttus_Config2__ComponentProductId__r.Subscription_Number__c)) 
                && avaialbleOptionsMap.get(compId).Apttus_Config2__ParentProductId__r.Id == pad.Bundle_Id__c) {

            objSelectedOptionDO.ComponentId = compId;
            objSelectedOptionDO.ComponentProductId = compProductId;
            objSelectedOptionDO.Quantity = 1;

            Apttus_Config2__LineItem__c newliSOOptions = new Apttus_Config2__LineItem__c();

            List<String> customFields = new List<String>();
            customFields = Digital_CartCreationHelper.addCustomFieldsYOY1();
            newliSOOptions = Digital_CartCreationCommonCode.populateConfigLineItemYOY1(pad,prodToPADetailMap,priceListMap);
            System.debug('newliSOOptions:' + newliSOOptions);

            objSelectedOptionDO.CustomFields = customFields;//DLT-19093
            objSelectedOptionDO.CustomData = newliSOOptions;
        }

        return objSelectedOptionDO;
    }

}