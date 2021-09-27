/** CHANGE HISTORY
 * ==================================================================================================================================
 * Date          Name                JIRA        Description
 * 2018-02-19    Ramesh Reddy        DLT-7674    [New Customer] Initial Pricing on Landing Page load
 * 2018-03-26    Ramesh Reddy        DLT-8177    Ability to Set different Discount values across new Customer Plans
 * 2018-05-23    Samreen Ali         DLT-8733    Return contract terms as part of Store details   
 * 2018-07-13    Ramesh Reddy        DLT-10257 & 10287   [new CUSTOMER - View Plans SL/CP] Apply Dynamic Discounts/Markups to Plans per Term & Category
 * 2018-07-20    Prashob             DLT-10963   [Code Scan] Fix Ecom_StoreService
 * 2018-09-09    Raviteja Murukutla  DLT-11466   Create BAR2018 Promo Code
 * 2018-10-26    Ramesh Reddy        DLT-13185   Update PriceMatrix logic
 * 2019-01-04    Ramesh Reddy        DLT-14332   [Tech Story] Change getStore response structure
 * 2019-01-24    Raviteja Murukutla  DLT-14322   [Tech story] [PMD Code Scan Fix]
 * 2020-02-17    David Hoel          DLT-19135   [NSE] CORP -WL Add option products in cart
 * 2020-07-10    Benjamin Her        DLT-20331   Update class to handle no jurisdiction for Small Law store
 * ==================================================================================================================================*/
@RestResource(urlMapping = '/digitalconfigurator/getStore/*')
global with sharing class Ecom_StoreService {
    public String storeId;
    public String leastPriceJson;
    public String mainCategory = '';
    public String customerPricingSegment;
    public String adjustmentType = Label.DC_PERCENT_DISCOUNT;
    public Decimal adjustmentAmount = 0;
    public Integer maxNoOfAttorneys = 0;
    public Boolean hasBundles = false;
    public Id priceList;

    public Set < Id > selectionProductIdSet;
    public Set < Id > selBundleProductIdSet;
    public Set < Id > selNonBundleProductIdSet;
    public List < String > jurisdictions = new List < String > ();
    public List < Apttus_Config2__ClassificationHierarchy__c > categoryList = new List < Apttus_Config2__ClassificationHierarchy__c > ();

    public Map < String, List < Ecom_StoreResponse.PriceMatrix >> categoryToMatrix = new Map < String, List < Ecom_StoreResponse.PriceMatrix >> ();
    public Map < Id, List < Apttus_Config2__ProductClassification__c >> categoryProdClassificationMap;
    public Map < String, List < Ecom_StoreResponse.PriceMatrix >> productToPriceMatricesMap = new Map < String, List < Ecom_StoreResponse.PriceMatrix >> ();
    public Map < String, Map < String, List < Ecom_StoreResponse.Material >>> productIdToMaterial = new Map < String, Map < String, List < Ecom_StoreResponse.Material >>> ();
    public Map < String, Map < String, Ecom_StoreResponse.Adjustments >> categoryToContractTermDiscount = new Map < String, Map < String, Ecom_StoreResponse.Adjustments >> ();

    Map < String, List < Ecom_StoreResponse.PriceMatrix >> categoryToQuantityToPriceMatrixMap = new Map < String, List < Ecom_StoreResponse.PriceMatrix >> ();
    Map < String, Map < Integer, Map < String, Ecom_StoreResponse.PriceMatrix >>> productToQuantityToPriceMatrixMap = new Map < String, Map < Integer, Map < String, Ecom_StoreResponse.PriceMatrix >>> ();

    /**
     * this method is used to send/receive the information over Rest-API
     */
    @HttpPost
    global static Ecom_StoreResponse getStoreDetails(String storeName, List < String > jurisdiction) {
        Ecom_StoreResponse response = new Ecom_StoreResponse();

        if (String.isBlank(storeName)) {
            response.responseCode = 4000;
            response.responseMessage = 'Store Name should not be empty';
            return response;
        }

        try {
            Ecom_StoreService service = new Ecom_StoreService();
            Ecom_StoreResponse.cls_storeDetails ss = service.getStore(storeName, jurisdiction);
            response.storeDetails = new List < Ecom_StoreResponse.cls_storeDetails > {
                ss
            };
            response.responseCode = 200;
            response.responseMessage = 'Success';
            System.debug('<Success>' + Json.serialize(response));
        } catch (Exception ex) {
            DCUtils.trackLog(ex, 'Ecom_StoreService', 'getStoreDetails');
            response.responseCode = 4000;
            response.responseMessage = ex.getMessage();
        }

        return response;
    }

    /**
     * get a Store details by Name.
     */
    public Ecom_StoreResponse.cls_storeDetails getStore(String storeName, List < String > jurisdiction) {
        List < APTSECOM_Store__c > stores = getStoreList(storeName);

        if (stores.isEmpty()) {
            throw new DCCustomException('Store Name does not exist anymore');
        }

        if (jurisdiction == null) {
            throw new DCCustomException('Jurisdiction should not be null');
        }

        Ecom_StoreResponse.cls_storeDetails storeDetail = new Ecom_StoreResponse.cls_storeDetails();

        for (APTSECOM_Store__c store: stores) {
            storeDetail.storeName = store.APTSECOM_Store_Title__c;
            storeDetail.storeId = store.Id;
            storeDetail.maxNoOfAttorneys = Integer.valueOf(store.APTSECOM_Max_No_Of_Attorneys__c);
            storeDetail.defaultContractTerm = store.APTSECOM_Default_Contract_Term__c; // store.APTSECOM_Store_Title__c;
            storeDetail.productCatalog = new Ecom_StoreResponse.cls_productCatalog();
            storeDetail.maxNoOfPerSeatUsers = Integer.valueOf(store.APTSECOM_Max_No_Of_PerSeatUsers__c);

            hasBundles = store.Ecom_Has_Bundles__c; // DLT-19135
            priceList = store.APTSECOM_Price_List__c; // DLT-19135

            if (jurisdiction != null) {
                storeDetail.jurisdictionRequested = jurisdiction.clone();
            }
            storeDetail.quantityRequested = null;
            storeDetail.adjustmentType = store.APTSECOM_Adjustment_Type__c;
            storeDetail.adjustmentAmount = store.APTSECOM_Adjustment_Amount__c;

            List < APTSECOM_Product_Recommendation__c > recommendationList = store.Product_Recommendations__r;
            storeDetail.noOfRecommendations = (recommendationList != null) ? recommendationList.size() : 0;

            storeId = store.Id;
            System.debug('jurisdiction > ' + jurisdiction);

            jurisdictions = jurisdiction;
            maxNoOfAttorneys = Integer.valueOf(store.APTSECOM_Max_No_Of_Attorneys__c);

            if (String.isNotBlank(store.APTSECOM_Adjustment_Type__c)) {
                adjustmentType = store.APTSECOM_Adjustment_Type__c;
            }

            if (store.APTSECOM_Adjustment_Amount__c != null) {
                adjustmentAmount = store.APTSECOM_Adjustment_Amount__c;
            }

            leastPriceJson = store.APTSECOM_Least_Prices__c;
            customerPricingSegment = store.APTSECOM_Customer_Pricing_Segment__c;
            mainCategory = store.APTSECOM_Category_Hierarchy__c;

            System.debug('adjustmentAmount > ' + adjustmentAmount);
        }

        if (Schema.sObjectType.Apttus_Config2__ClassificationHierarchy__c.isAccessible()) {
            categoryList = [
                SELECT Id, Name, DC_Is_Title_Visible__c, Apttus_Config2__Label__c, DC_Sequence_No__c, Apttus_Config2__ProductCount__c,
                Apttus_Config2__AncestorId__c, Apttus_Config2__PrimordialId__c, Apttus_Config2__Level__c
                FROM Apttus_Config2__ClassificationHierarchy__c WHERE Apttus_Config2__PrimordialId__c =: mainCategory
                ORDER BY Apttus_Config2__Level__c, DC_Sequence_No__c
            ];
        }

        adjustmentAmount = (adjustmentAmount != null) ? adjustmentAmount : 0.0;
        storeDetail.promotions = new List < Ecom_StoreResponse.cls_promoCode > ();
        storeDetail.promotions = getpromoCode();

        if (String.isNotBlank(leastPriceJson)) {
            categoryToMatrix = (Map < String, List < Ecom_StoreResponse.PriceMatrix >> ) Json.deserialize(leastPriceJson, Map < String, List < Ecom_StoreResponse.PriceMatrix >> .class);
        }

        if (String.isBlank(mainCategory) && categoryList.isEmpty()) {
            throw new DCCustomException('There is No Category Hierarchy associated with the Store');
        }

        if (maxNoOfAttorneys < 1) {
            throw new DCCustomException('Max No of Attorneys should be more than 0');
        }

        storeDetail.contractTermDetails = getContractTerm(storeName);
        getProducts();
        getDigitalProductsBySelectedProducts(selectionProductIdSet);

        // DLT-19135 : get price matrices for plans with bundle products
        if (hasBundles) {
            if (!Schema.sObjectType.Product2.isQueryable()) {
                throw new DCCustomException('Product2 is not queryable');
            }

            // DLT-19135 : get matrices for bundled products and options
            if (!selBundleProductIdSet.isEmpty()) {
                productToPriceMatricesMap = getPriceMatrix(storeDetail.maxNoOfAttorneys);
            }

            // DLT-19135 : get matrices for any remaining products not found in bundle
            if (!selNonBundleProductIdSet.isEmpty()) {
                productToPriceMatricesMap.putAll(getPriceMatrixV2(selNonBundleProductIdSet, storeDetail.maxNoOfAttorneys, customerPricingSegment));
            }
        } else {
            productToPriceMatricesMap = getPriceMatrixV2(selectionProductIdSet, storeDetail.maxNoOfAttorneys, customerPricingSegment);
        }

        storeDetail.productCatalog.sections = new List < Ecom_StoreResponse.cls_sections > ();
        storeDetail.productCatalog.sections = getCategoryHierarchy();

        return storeDetail;
    }

    // calc sum module points for bundles
    public Integer getModulePoints(Set < Id > productIdSet) {
        // sum module points by products
        AggregateResult[] groupedResults = [SELECT SUM(APTS_Module_Points__c) FROM Product2 WHERE Id IN: productIdSet];
        Integer modulePoints = Integer.valueOf(groupedResults[0].get('expr0'));

        if (modulePoints == null) {
            modulePoints = 0;
        }

        System.debug('modulePoints > ' + modulePoints);
        return modulePoints;
    }

    /**
     *   filterBundleProdIdSet
     *   Find any Bundle products in passed Set and return Set with BundleId and Option products found in Bundle.
     */
    public Set < Id > filterBundleProdIdSet(Set < Id > productIdSet) {
        Set < Id > bundleProdIdSet = new Set < Id > ();
        System.debug('productIdSet> ' + productIdSet);

        Id bundleProdId;
        if (!productIdSet.isEmpty()) {
            bundleProdId = [SELECT Id FROM Product2 WHERE Id IN: productIdSet AND Apttus_Config2__ConfigurationType__c = 'Bundle'
                LIMIT 1
            ].Id;
        }

        if (bundleProdId != null) {
            bundleProdIdSet.add(bundleProdId);

            if (Schema.sObjectType.Apttus_Config2__ProductOptionComponent__c.isQueryable()) {
                List < Apttus_Config2__ProductOptionComponent__c > bundleOptionComponents = [
                    SELECT Id, Apttus_Config2__ComponentProductId__c, Apttus_Config2__ParentProductId__c
                    FROM Apttus_Config2__ProductOptionComponent__c
                    WHERE Apttus_Config2__ParentProductId__c =: bundleProdId AND Apttus_Config2__ComponentProductId__c IN: productIdSet
                ];

                for (Apttus_Config2__ProductOptionComponent__c poc: bundleOptionComponents) {
                    bundleProdIdSet.add(poc.Apttus_Config2__ComponentProductId__c);
                }
            } else {
                throw new DCCustomException('Apttus_Config2__ProductOptionComponent__c is not queryable');
            }
        }

        return bundleProdIdSet;
    }

    //Get details of new Sales contract terms
    private List < Ecom_StoreResponse.cls_ContractTermDetails > getContractTerm(String storeName) {

        List < New_Sales_Contract_Term_Setting__c > nsContractTerms = null;
        Map < String, List < Ecom_StoreResponse.ContractTermDetail >> planToContractTerms = new Map < String, List < Ecom_StoreResponse.ContractTermDetail >> ();
        if (Schema.sObjectType.New_Sales_Contract_Term_Setting__c.isQueryable()) {
            nsContractTerms = [
                SELECT Markup_Percentage__c, Contract_Term__c, YoY_1__c, YoY_2__c, Related_Category_Hierarchy__c, Related_Category_Hierarchy__r.Name
                FROM New_Sales_Contract_Term_Setting__c WHERE Related_Store__r.Name =: storeName
            ];
        }

        for (New_Sales_Contract_Term_Setting__c term: nsContractTerms) {
            Ecom_StoreResponse.ContractTermDetail termDetail = new Ecom_StoreResponse.ContractTermDetail();
            termDetail.markupPercentage = term.Markup_Percentage__c;
            termDetail.planID = term.Related_Category_Hierarchy__c;
            termDetail.planName = term.Related_Category_Hierarchy__r.Name;
            termDetail.term = term.Contract_Term__c;
            termDetail.yearOnYearRenewal = term.YoY_1__c;
            termDetail.yearOnYearTwoPlus = term.YoY_2__c;

            if (planToContractTerms.get(term.Related_Category_Hierarchy__c) == null) {
                planToContractTerms.put(term.Related_Category_Hierarchy__c, new List < Ecom_StoreResponse.ContractTermDetail > ());
            }
            planToContractTerms.get(term.Related_Category_Hierarchy__c).add(termDetail);
        }

        List < Ecom_StoreResponse.cls_ContractTermDetails > contractTermDetails = new List < Ecom_StoreResponse.cls_ContractTermDetails > ();

        for (String key: planToContractTerms.keyset()) {
            Ecom_StoreResponse.cls_ContractTermDetails details = new Ecom_StoreResponse.cls_ContractTermDetails();
            details.categoryId = key;
            details.terms = planToContractTerms.get(key);
            contractTermDetails.add(details);
        }

        return contractTermDetails;
    }

    /**
     * get all products by categoryHierarchy which on store object.
     * create a Map, CategoryHierarchy as key AND List of ProductClassfication as a Value.
     */
    public void getProducts() {
        List < DC_State_Circuit_Mapping__mdt > stCircuitMappingList;
        List < Apttus_Config2__ProductClassification__c > prodClassificationSelectionList;

        if (Schema.sObjectType.DC_State_Circuit_Mapping__mdt.isAccessible()) {
            stCircuitMappingList = [SELECT Circuit__c FROM DC_State_Circuit_Mapping__mdt WHERE State__c IN: jurisdictions];
        }

        for (DC_State_Circuit_Mapping__mdt circuit: stCircuitMappingList) {
            jurisdictions.add(circuit.Circuit__c);
        }

        if (Schema.sObjectType.Apttus_Config2__ProductClassification__c.isAccessible()) {
            prodClassificationSelectionList = [
                SELECT Id, Name, Apttus_Config2__ClassificationId__c, Apttus_Config2__ProductId__r.DC_Jurisdiction__c,
                Apttus_Config2__ClassificationId__r.Apttus_Config2__AncestorId__c, Apttus_Config2__ClassificationId__r.Name,
                Apttus_Config2__ProductId__c, Apttus_Config2__ProductId__r.DC_Long_Description__c,
                Apttus_Config2__ProductId__r.DC_Short_Description__c, Apttus_Config2__ProductId__r.DC_Product_Title__c,
                Apttus_Config2__ProductId__r.APTS_Product_Pricing_Model__c, Apttus_Config2__ProductId__r.Subscription_Number__c,
                Apttus_Config2__ProductId__r.List_Price__c, Apttus_Config2__ProductId__r.Name, Apttus_Config2__ProductId__r.Description,
                Apttus_Config2__Sequence__c, Apttus_Config2__ProductId__r.Apttus_Config2__ConfigurationType__c
                FROM Apttus_Config2__ProductClassification__c
                WHERE Apttus_Config2__ClassificationId__r.Apttus_Config2__PrimordialId__c =: mainCategory
                AND(Apttus_Config2__ProductId__r.DC_Jurisdiction__c IN: jurisdictions OR Apttus_Config2__ProductId__r.DC_Jurisdiction__c = null)
            ];

            if (jurisdictions.isEmpty()) {
                prodClassificationSelectionList = [
                    SELECT Id, Name, Apttus_Config2__ClassificationId__c, Apttus_Config2__ClassificationId__r.Apttus_Config2__AncestorId__c,
                    Apttus_Config2__ClassificationId__r.Name, Apttus_Config2__ProductId__c, Apttus_Config2__ProductId__r.DC_Long_Description__c,
                    Apttus_Config2__ProductId__r.DC_Short_Description__c, Apttus_Config2__ProductId__r.DC_Product_Title__c,
                    Apttus_Config2__ProductId__r.APTS_Product_Pricing_Model__c, Apttus_Config2__ProductId__r.DC_Jurisdiction__c,
                    Apttus_Config2__ProductId__r.Subscription_Number__c, Apttus_Config2__ProductId__r.List_Price__c,
                    Apttus_Config2__ProductId__r.Name, Apttus_Config2__ProductId__r.Description, Apttus_Config2__Sequence__c,
                    Apttus_Config2__ProductId__r.Apttus_Config2__ConfigurationType__c
                    FROM Apttus_Config2__ProductClassification__c
                    WHERE Apttus_Config2__ClassificationId__r.Apttus_Config2__PrimordialId__c =: mainCategory
                ];
            }

            System.debug('prodClassificationSelectionList > ' + prodClassificationSelectionList);
        }

        Map < String, String > productToCategory = new Map < String, String > ();
        categoryProdClassificationMap = new Map < Id, List < Apttus_Config2__ProductClassification__c >> ();
        selectionProductIdSet = new Set < Id > ();

        for (Apttus_Config2__ProductClassification__c prodClassification: prodClassificationSelectionList) {
            if (categoryProdClassificationMap.containsKey(prodClassification.Apttus_Config2__ClassificationId__c)) {
                List < Apttus_Config2__ProductClassification__c > prodClassificationList = categoryProdClassificationMap.get(prodClassification.Apttus_Config2__ClassificationId__c);
                prodClassificationList.add(prodClassification);
                categoryProdClassificationMap.put(prodClassification.Apttus_Config2__ClassificationId__c, prodClassificationList);
            } else {
                List < Apttus_Config2__ProductClassification__c > prodClassificationList = new List < Apttus_Config2__ProductClassification__c > ();
                prodClassificationList.add(prodClassification);
                categoryProdClassificationMap.put(prodClassification.Apttus_Config2__ClassificationId__c, prodClassificationList);
            }
            productToCategory.put(prodClassification.Apttus_Config2__ProductId__c, prodClassification.Apttus_Config2__ClassificationId__c);

            selectionProductIdSet.add(prodClassification.Apttus_Config2__ProductId__c);
        }

        // DLT-19135 : seperate bundle product Id's from standalones
        if (hasBundles) {
            selBundleProductIdSet = filterBundleProdIdSet(selectionProductIdSet);

            selNonBundleProductIdSet = selectionProductIdSet.clone();
            selNonBundleProductIdSet.removeAll(selBundleProductIdSet);
        }
    }

    // Set adjustments for each category to calculate prices  154.      
    // Updated the method reg : DLT-10257
    private void setDiscountForEveryCategory(List < Apttus_Config2__ClassificationHierarchy__c > categoryList) {
        // create a map to hold the plan level discount
        Map < String, Ecom_StoreResponse.Adjustments > categoryToDiscount = new Map < String, Ecom_StoreResponse.Adjustments > ();
        List < APTSECOM_Store__c > adjustments;

        if (Schema.sObjectType.APTSECOM_Store__c.isQueryable()) {
            adjustments = [
                SELECT Id, Name,
                (SELECT Id, Name, Adjustment_Amount__c, Adjustment_Type__c, Related_Category_Hierarchy__c, Contract_Term__c FROM New_Sales_Contract_Term_Settings__r),
                (SELECT Id, APTSECOM_Category_Hierarchy__c, APTSECOM_Adjustment_Type__c, APTSECOM_Adjustment_Amount__c FROM Store_Price_Adjustments__r)
                FROM APTSECOM_Store__c WHERE Id =: storeId WITH SECURITY_ENFORCED
            ];
        }

        // Itarate plan level adjustments AND add to map
        for (APTSECOM_Store_Price_Adjustment__c adjustment: adjustments[0].Store_Price_Adjustments__r) {
            Ecom_StoreResponse.Adjustments ads = new Ecom_StoreResponse.Adjustments();
            ads.adjustmentType = adjustment.APTSECOM_Adjustment_Type__c;
            ads.adjustmentAmount = adjustment.APTSECOM_Adjustment_Amount__c;

            // Update to default values if values are empty
            if (String.isBlank(adjustment.APTSECOM_Adjustment_Type__c) || adjustment.APTSECOM_Adjustment_Amount__c == null) {
                ads.adjustmentType = Label.DC_PERCENT_DISCOUNT;
                ads.adjustmentAmount = 0;
            }
            categoryToDiscount.put(adjustment.APTSECOM_Category_Hierarchy__c, ads);
        }

        // top level category is used for iterate the categories FROM high to low level
        Integer topLevel = 0;
        Map < String, String > childToParent = new Map < String, String > ();
        Map < String, List < String >> parentToChilds = new Map < String, List < String >> ();
        Map < Integer, List < String >> levelToHierarchy = new Map < Integer, List < String >> ();

        // iterate category list, add child category as a key AND parent category as a value AND vice-versa
        for (Apttus_Config2__ClassificationHierarchy__c hierarchy: categoryList) {
            childToParent.put(hierarchy.Id, hierarchy.Apttus_Config2__AncestorId__c);
            if (parentToChilds.get(hierarchy.Apttus_Config2__AncestorId__c) == null) {
                parentToChilds.put(hierarchy.Apttus_Config2__AncestorId__c, new List < String > ());
            }
            parentToChilds.get(hierarchy.Apttus_Config2__AncestorId__c).add(hierarchy.Id);

            // to know category level
            Integer level = Integer.valueOf(hierarchy.Apttus_Config2__Level__c);
            if (topLevel < level) {
                topLevel = level;
            }

            if (levelToHierarchy.get(level) == null) {
                levelToHierarchy.put(level, new List < String > ());
            }
            levelToHierarchy.get(level).add(hierarchy.Id);
        }
        // add adjustments to low level categories

        // iterate contract term adjustments
        for (New_Sales_Contract_Term_Setting__c contractTerm: adjustments[0].New_Sales_Contract_Term_Settings__r) {
            // Id,Name,Adjustment_Amount__c,Adjustment_Type__c,Related_Category_Hierarchy__c,Contract_Term__c

            if (categoryToContractTermDiscount.get(contractTerm.Related_Category_Hierarchy__c) == null) {
                categoryToContractTermDiscount.put(contractTerm.Related_Category_Hierarchy__c, new Map < String, Ecom_StoreResponse.Adjustments > ());
            }

            if (String.isBlank(contractTerm.Contract_Term__c)) {
                continue;
            }

            Ecom_StoreResponse.Adjustments ads = categoryToDiscount.get(contractTerm.Related_Category_Hierarchy__c);
            if (ads == null || String.isBlank(ads.adjustmentType) || ads.adjustmentAmount == null) {
                ads = new Ecom_StoreResponse.Adjustments();
                ads.adjustmentType = Label.DC_PERCENT_DISCOUNT;
                ads.adjustmentAmount = 0;
            }
            Ecom_StoreResponse.Adjustments newAdjustment = calculateAdjustment(contractTerm.Adjustment_Amount__c, contractTerm.Adjustment_Type__c, ads.adjustmentAmount, ads.adjustmentType);

            if (categoryToContractTermDiscount.get(contractTerm.Related_Category_Hierarchy__c).get(contractTerm.Contract_Term__c) == null) {
                categoryToContractTermDiscount.get(contractTerm.Related_Category_Hierarchy__c).put(contractTerm.Contract_Term__c, newAdjustment);
            }
        }

        // add adjustments to low level categories
        for (Integer level = 1; topLevel >= level; level++) {
            for (String category: levelToHierarchy.get(level)) {
                if (level > 1) {
                    categoryToContractTermDiscount.put(category, categoryToContractTermDiscount.get(childToParent.get(category)));
                } else {
                    Map < String, Ecom_StoreResponse.Adjustments > adjMap = categoryToContractTermDiscount.get(category);
                    Ecom_StoreResponse.Adjustments defaultPlanlevel = categoryToDiscount.get(category);

                    // if plan does not have any adjustments then Set default values which should not impact the price
                    if (defaultPlanlevel == null || String.isBlank(defaultPlanlevel.adjustmentType) || defaultPlanlevel.adjustmentAmount == null) {
                        defaultPlanlevel = new Ecom_StoreResponse.Adjustments();
                        defaultPlanlevel.adjustmentType = Label.DC_PERCENT_DISCOUNT;
                        defaultPlanlevel.adjustmentAmount = 0;
                    }

                    // if we donot have contract term discount then default will have a plan level discount.
                    if (adjMap == null) {
                        adjMap = new Map < String, Ecom_StoreResponse.Adjustments > {
                            'default' => defaultPlanlevel
                        };
                    } else {
                        adjMap.put('default', defaultPlanlevel);
                    }
                    categoryToContractTermDiscount.put(category, adjMap);
                }
            }
        }
        System.debug('categoryToContractTermDiscount 2 > ' + Json.serialize(categoryToContractTermDiscount));
    }

    // DLT-10257
    // calculate the plan level adjustments AND contractterm level adjustments
    public static Ecom_StoreResponse.Adjustments calculateAdjustment(Decimal newAdjustmentAmount, String newAdjustmentType, Decimal defaultAdjustmentAmount, String defaultAdjustmentType) {
        // check if new adjustments are empty then Set to defaults
        if (newAdjustmentAmount == null) {
            newAdjustmentAmount = 0;
        } {
            if (String.isBlank(newAdjustmentType)) {
                newAdjustmentType = Label.DC_PERCENT_DISCOUNT;
            }
        }

        // discount - markup calculation
        if (defaultAdjustmentType == Label.DC_PERCENT_DISCOUNT) {
            if (newAdjustmentType == Label.DC_PERCENT_DISCOUNT) {
                newAdjustmentAmount = defaultAdjustmentAmount + newAdjustmentAmount;
            } else if (newAdjustmentType == Label.DC_PERCENT_MARKUP) {
                newAdjustmentAmount = defaultAdjustmentAmount - newAdjustmentAmount;
            }
        } else if (defaultAdjustmentType == Label.DC_PERCENT_MARKUP) {
            if (newAdjustmentType == Label.DC_PERCENT_DISCOUNT) {
                newAdjustmentAmount = (newAdjustmentAmount - defaultAdjustmentAmount);
                // newAdjustmentAmount is greater then zero then Set defaultAdjustmentType to same as newAdjustmentType     
                // since we are returning defaultAdjustmentType
                if (newAdjustmentAmount > 0) {
                    defaultAdjustmentType = Label.DC_PERCENT_DISCOUNT;
                }
            } else if (newAdjustmentType == Label.DC_PERCENT_MARKUP) {
                newAdjustmentAmount = defaultAdjustmentAmount + newAdjustmentAmount;
            }
        }

        if (newAdjustmentAmount < 0) {
            newAdjustmentAmount = newAdjustmentAmount * (-1);
            newAdjustmentType = Label.DC_PERCENT_MARKUP;
        } else {
            if (newAdjustmentAmount > 100) {
                newAdjustmentAmount = 100;
            } {
                newAdjustmentType = defaultAdjustmentType;
            }
        }

        // create a wrapper to return calculated adjustments
        Ecom_StoreResponse.Adjustments newAdjustment = new Ecom_StoreResponse.Adjustments();
        newAdjustment.adjustmentAmount = newAdjustmentAmount;
        newAdjustment.adjustmentType = newAdjustmentType;

        return newAdjustment;
    }

    /**
     *   create a list of Category as a tree structure based on categoryHierarchy which is on Store object.
     */
    private List < Ecom_StoreResponse.cls_sections > getCategoryHierarchy() {

        Map < Id, Ecom_StoreResponse.cls_sections > mapCatIdSection = new Map < Id, Ecom_StoreResponse.cls_sections > ();
        Set < Id > parentCategorySet = new Set < Id > ();
        Set < Id > topLevelCategoryIdSet = new Set < Id > ();
        setDiscountForEveryCategory(categoryList);

        //Loop AND check top level categories 
        //Also add cart Items wherever there are products within a category
        for (Apttus_Config2__ClassificationHierarchy__c category: categoryList) {
            Ecom_StoreResponse.cls_sections section = createSectionForCategory(category);
            if (section.hasProducts) {
                List < Ecom_StoreResponse.cls_products > items = getProductsForCategory(category.Id);
                section.products = items;
                section.hasProducts = (items == null || items.isEmpty()) ? false : true;

                List < Ecom_StoreResponse.PriceMatrix > prices = getPriceMatricesByCategory(productToQuantityToPriceMatrixMap.get(category.Id));
                categoryToQuantityToPriceMatrixMap.put(category.Id, prices);
                section.priceMatrix = prices;
            }
            mapCatIdSection.put(category.Id, section);

            if (category.Apttus_Config2__Level__c == 1) {
                topLevelCategoryIdSet.add(category.Id);
            }
        }

        //Associate Parent sections with child sections
        for (Apttus_Config2__ClassificationHierarchy__c category: categoryList) {
            if (!topLevelCategoryIdSet.contains(category.Id)) {
                Ecom_StoreResponse.cls_sections parentSection = mapCatIdSection.get(category.Apttus_Config2__AncestorId__c);
                if (parentSection != null && parentSection.sections == null) {
                    parentSection.sections = new List < Ecom_StoreResponse.cls_sections > ();
                } {
                    if (parentSection != null && parentSection.sections != null) {
                        parentSection.sections.add(mapCatIdSection.get(category.Id));
                    }
                }

                List < Ecom_StoreResponse.PriceMatrix > matrices = categoryToQuantityToPriceMatrixMap.get(category.Id);
                sumUpPriceMatrixByCategory(matrices, category.Apttus_Config2__AncestorId__c);

                mapCatIdSection.put(category.Apttus_Config2__AncestorId__c, parentSection);
            }
        }

        //Create hierarchy for the top level categories
        List < Ecom_StoreResponse.cls_sections > sectionList = new List < Ecom_StoreResponse.cls_sections > ();
        for (Apttus_Config2__ClassificationHierarchy__c category: categoryList) {
            if (topLevelCategoryIdSet.contains(category.Id)) {
                List < Ecom_StoreResponse.PriceMatrix > prices = getPriceMatricesByCategory(productToQuantityToPriceMatrixMap.get(category.Id));
                categoryToQuantityToPriceMatrixMap.put(category.Id, prices);
                mapCatIdSection.get(category.Id).priceMatrix = prices;
                sectionList.add(mapCatIdSection.get(category.Id));
            }
        }

        return sectionList;
    }

    /**
     *   getpromoCode
     */
    public List < Ecom_StoreResponse.cls_promoCode > getpromoCode() {
        List < APTSECOM_Store_Promotion__c > promoCodeList;
        List < Ecom_StoreResponse.cls_promoCode > promoCodes = new List < Ecom_StoreResponse.cls_promoCode > ();

        if (Schema.sObjectType.APTSECOM_Store_Promotion__c.isAccessible()) {
            promoCodeList = [
                SELECT Id, APTSECOM_Adjustment_Amount__c, APTSECOM_Adjustment_Type__c, APTSECOM_Description__c, APTSECOM_End_Date__c,
                APTSECOM_Is_Active__c, APTSECOM_Max_Quantity__c, APTSECOM_Min_Quantity__c, APTSECOM_Promo_Code__c, APTSECOM_Start_Date__c,
                APTSECOM_Valid_Contract_Terms__c, APTSECOM_Valid_Jurisdiction__c
                FROM APTSECOM_Store_Promotion__c
                WHERE APTSECOM_Store__c =: storeId AND APTSECOM_Is_Active__c = true
            ];

            for (APTSECOM_Store_Promotion__c promoCode: promoCodeList) {
                Ecom_StoreResponse.cls_promoCode promo = new Ecom_StoreResponse.cls_promoCode();
                promo.Id = promoCode.Id;
                promo.promoCode = promoCode.APTSECOM_Promo_Code__c;
                promo.adjustmentAmount = promoCode.APTSECOM_Adjustment_Amount__c;
                promo.adjustmentType = promoCode.APTSECOM_Adjustment_Type__c;
                promo.description = promoCode.APTSECOM_Description__c;
                promo.endDate = promoCode.APTSECOM_End_Date__c;
                promo.isActive = promoCode.APTSECOM_Is_Active__c;
                promo.maxQuantity = promoCode.APTSECOM_Max_Quantity__c;
                promo.minQuantity = promoCode.APTSECOM_Min_Quantity__c;
                promo.startDate = promoCode.APTSECOM_Start_Date__c;
                promo.validContractTerms = promoCode.APTSECOM_Valid_Contract_Terms__c;
                promo.validJurisdiction = promoCode.APTSECOM_Valid_Jurisdiction__c;
                promoCodes.add(promo);
            }
        }

        return promoCodes;
    }

    /**
     *   Creates List of Cart Items for the category passed as parameter.
     *   The Category passed to this method should have underlying Products.
     */
    public List < Ecom_StoreResponse.cls_products > getProductsForCategory(Id categoryId) {

        List < Ecom_StoreResponse.cls_products > itemsList = new List < Ecom_StoreResponse.cls_products > ();
        Map < String, Ecom_StoreResponse.Adjustments > contractTermAdjustments = categoryToContractTermDiscount.get(categoryId);

        List < Apttus_Config2__ProductClassification__c > prodDetailsList;
        if (categoryProdClassificationMap.containsKey(categoryId)) {
            prodDetailsList = categoryProdClassificationMap.get(categoryId);
        } else {
            prodDetailsList = new List < Apttus_Config2__ProductClassification__c > ();
        }

        Decimal selectedSeqNumber = 0;
        for (Apttus_Config2__ProductClassification__c prodDetail: prodDetailsList) {

            Ecom_StoreResponse.cls_products item = new Ecom_StoreResponse.cls_products();
            item.productId = prodDetail.Apttus_Config2__ProductId__c;
            item.productName = prodDetail.Apttus_Config2__ProductId__r.Name;
            item.productTitle = prodDetail.Apttus_Config2__ProductId__r.DC_Product_Title__c;
            item.jurisdiction = prodDetail.Apttus_Config2__ProductId__r.DC_Jurisdiction__c;
            item.longDescription = prodDetail.Apttus_Config2__ProductId__r.DC_Long_Description__c;
            item.shortDescription = prodDetail.Apttus_Config2__ProductId__r.DC_Short_Description__c;
            item.pricingModel = prodDetail.Apttus_Config2__ProductId__r.APTS_Product_Pricing_Model__c;
            item.cType = prodDetail.Apttus_Config2__ProductId__r.Apttus_Config2__ConfigurationType__c;

            List < Ecom_StoreResponse.PriceMatrix > matrices = productToPriceMatricesMap.get(String.valueOf(categoryId) + prodDetail.Apttus_Config2__ProductId__c);
            List < Ecom_StoreResponse.PriceMatrix > matrices1 = new List < Ecom_StoreResponse.PriceMatrix > ();

            if (matrices != null) {
                matrices1 = getDiscountedPriceByPriceMatrix(matrices, contractTermAdjustments);
            }

            item.priceMatrix = matrices1; // check
            sumUpPriceMatrixByCategory(matrices1, categoryId);
            item.material = new List < Ecom_StoreResponse.Material > ();

            if (productIdToMaterial.get(prodDetail.Apttus_Config2__ProductId__c) != null &&
                productIdToMaterial.get(prodDetail.Apttus_Config2__ProductId__c).get(prodDetail.Apttus_Config2__ProductId__r.Subscription_Number__c) != null) {
                item.material = productIdToMaterial.get(prodDetail.Apttus_Config2__ProductId__c).get(prodDetail.Apttus_Config2__ProductId__r.Subscription_Number__c);
            }
            itemsList.add(item);
        }

        return itemsList;
    }

    /**
     *   sumUpPriceMatrixByCategory
     */
    private void sumUpPriceMatrixByCategory(List < Ecom_StoreResponse.PriceMatrix > matrices, String categoryId) {
        // , Map<String, Map<Integer, Ecom_StoreResponse.PriceMatrix>> idToquantityToPriceMatrixMap
        for (Ecom_StoreResponse.PriceMatrix matrix: matrices) {
            if (productToQuantityToPriceMatrixMap.get(categoryId) != null &&
                productToQuantityToPriceMatrixMap.get(categoryId).get(matrix.quantity) != null &&
                productToQuantityToPriceMatrixMap.get(categoryId).get(matrix.quantity).get(matrix.contractTerm) != null) {
                if (matrix.amount != null) {
                    Ecom_StoreResponse.PriceMatrix value = productToQuantityToPriceMatrixMap.get(categoryId).get(matrix.quantity).get(matrix.contractTerm);

                    if (value.amount == null) {
                        value.amount = 0;
                    } {
                        value.amount += matrix.amount;
                    }
                    // leastPriceByCatState.get(cat).get(matrix.quantity).put(state,value);
                }
            } else {
                if (productToQuantityToPriceMatrixMap.get(categoryId) == null) {
                    productToQuantityToPriceMatrixMap.put(categoryId, new Map < Integer, Map < String, Ecom_StoreResponse.PriceMatrix >> ());
                    productToQuantityToPriceMatrixMap.get(categoryId).put(matrix.quantity, new Map < String, Ecom_StoreResponse.PriceMatrix > ());
                    productToQuantityToPriceMatrixMap.get(categoryId).get(matrix.quantity).put(matrix.contractTerm, matrix.clone());
                } else if (productToQuantityToPriceMatrixMap.get(categoryId) != null &&
                    productToQuantityToPriceMatrixMap.get(categoryId).get(matrix.quantity) == null) {
                    productToQuantityToPriceMatrixMap.get(categoryId).put(matrix.quantity, new Map < String, Ecom_StoreResponse.PriceMatrix > ());
                    productToQuantityToPriceMatrixMap.get(categoryId).get(matrix.quantity).put(matrix.contractTerm, matrix.clone());
                } else if (productToQuantityToPriceMatrixMap.get(categoryId) != null &&
                    productToQuantityToPriceMatrixMap.get(categoryId).get(matrix.quantity) != null && productToQuantityToPriceMatrixMap.get(categoryId).get(matrix.quantity).get(matrix.contractTerm) == null) {
                    productToQuantityToPriceMatrixMap.get(categoryId).get(matrix.quantity).put(matrix.contractTerm, matrix.clone());
                }
            }
        }
    }

    /**
     *   getPriceMatricesByCategory
     */
    private List < Ecom_StoreResponse.PriceMatrix > getPriceMatricesByCategory(Map < Integer, Map < String, Ecom_StoreResponse.PriceMatrix >> quantityToContractTermPrice) {
        List < Ecom_StoreResponse.PriceMatrix > priceMatrices = new List < Ecom_StoreResponse.PriceMatrix > ();

        if (quantityToContractTermPrice == null) {
            return priceMatrices;
        }

        for (Integer quantity: quantityToContractTermPrice.keySet()) {
            priceMatrices.addAll(quantityToContractTermPrice.get(quantity).values());
        }

        return priceMatrices;
    }

    /**
     * Creates Section for the Category record passed as parameter
     */
    private Ecom_StoreResponse.cls_sections createSectionForCategory(Apttus_Config2__ClassificationHierarchy__c category) {
        Ecom_StoreResponse.cls_sections section = new Ecom_StoreResponse.cls_sections();
        if (category != null) {
            Map < String, Ecom_StoreResponse.Adjustments > contractTermAdjustments = categoryToContractTermDiscount.get(category.Id);
            section.categoryId = category.Id;
            section.sectionLevel = (category.Apttus_Config2__Level__c != null) ? category.Apttus_Config2__Level__c.intValue() : null;
            section.sectionTitle = category.Apttus_Config2__Label__c;
            section.sectionName = category.Name;

            List < Ecom_StoreResponse.PriceMatrix > minPriceMatrices = categoryToMatrix.get(category.Id);
            List < Ecom_StoreResponse.PriceMatrix > matrices1 = new List < Ecom_StoreResponse.PriceMatrix > ();

            if (minPriceMatrices != null) {
                matrices1 = getDiscountedPriceByPriceMatrix(minPriceMatrices, contractTermAdjustments);
            }

            section.minPriceMatrix = matrices1;
            section.sequenceNo = category.DC_Sequence_No__c != null ? category.DC_Sequence_No__c.intValue() : null;
            section.hasProducts = ((category.Apttus_Config2__ProductCount__c != null) && (category.Apttus_Config2__ProductCount__c > 0)) ? true : false;
        }

        return section;
    }

    /**
     * will get the Materials by Opporunity : Digital Product Plans (DBCats)
     */
    public Map < String, Map < String, List < Ecom_StoreResponse.Material >>> getDigitalProductsBySelectedProducts(Set < Id > productIdSet) {
        List < Digital_Product_Plans__c > plans;
        if (Schema.sObjectType.Digital_Product_Plans__c.isAccessible()) {
            plans = [
                SELECT Id, Name, Material_Number__c, Material_Description__c, Product__c, Subscription_Number__c, SLF_Jurisdiction__c,
                DB_Group__c, DB_Group_Sort_Order__c, DB_Category__c, DB_Category_Sort_Order__c, SLF_Help_Text__c
                FROM Digital_Product_Plans__c WHERE Product__c IN: productIdSet
            ];
        }

        for (Digital_Product_Plans__c plan: plans) {
            Ecom_StoreResponse.Material material = new Ecom_StoreResponse.Material();
            material.materialId = plan.Id;
            material.materialNumber = plan.Material_Number__c;
            material.materialDescription = plan.Material_Description__c;
            material.internalDescription = plan.SLF_Help_Text__c;
            material.classificationValue = plan.DB_Category__c;
            material.classificationValueSortOrder = Integer.valueOf(plan.DB_Category_Sort_Order__c);
            material.subscriptionNumber = plan.Subscription_Number__c;
            material.jurisdiction = plan.SLF_Jurisdiction__c;
            material.productPlanId = plan.Product__c;
            material.productGroup = plan.DB_Group__c;
            material.productGroupSortOrder = Integer.valueOf(plan.DB_Group_Sort_Order__c);

            if (productIdToMaterial.get(plan.Product__c) == null) {
                productIdToMaterial.put(plan.Product__c, new Map < String, List < Ecom_StoreResponse.Material >> ());
            }

            if (productIdToMaterial.get(plan.Product__c).get(plan.Subscription_Number__c) == null) {
                productIdToMaterial.get(plan.Product__c).put(plan.Subscription_Number__c, new List < Ecom_StoreResponse.Material > ());
            }

            productIdToMaterial.get(plan.Product__c).get(plan.Subscription_Number__c).add(material);
        }

        return productIdToMaterial;
    }

    /**
     * Prepares Pricing map for Products using the Product Matrix based on the Products, Quantity AND Customer Pricing Segment
     * passed as parameter. STANDALONE
     */
    public Map < String, List < Ecom_StoreResponse.PriceMatrix >> getPriceMatrixV2(Set < Id > productIdSet, Integer maxNoOfAttorneys, String customerPricingSegment) {
        Set < String > attorneys = new Set < String > ();

        for (Integer i = 1; i <= maxNoOfAttorneys; i++) {
            attorneys.add(String.valueOf(i));
        }

        Set < Id > clonedProductset = productIdSet.clone();
        Map < String, Ecom_StoreResponse.PriceMatrix > defaultProductToPriceMatrix = new Map < String, Ecom_StoreResponse.PriceMatrix > ();
        Map < String, List < Ecom_StoreResponse.PriceMatrix >> productToPriceMatrices = new Map < String, List < Ecom_StoreResponse.PriceMatrix >> ();

        List < Apttus_Config2__PriceMatrixEntry__c > matrixEntryList = new List < Apttus_Config2__PriceMatrixEntry__c > ();
        if (Schema.sObjectType.Apttus_Config2__PriceMatrixEntry__c.isQueryable()) {
            matrixEntryList = [SELECT Apttus_Config2__PriceMatrixId__r.Apttus_Config2__PriceListItemId__r.Apttus_Config2__ProductId__c, Apttus_Config2__Dimension1Value__c, Ecom_Dimension1Value__c, Apttus_Config2__AdjustmentAmount__c, Apttus_Config2__AdjustmentType__c
                FROM Apttus_Config2__PriceMatrixEntry__c
                WHERE Apttus_Config2__PriceMatrixId__r.Apttus_Config2__PriceListItemId__r.Apttus_Config2__ProductId__c IN: productIdSet
                AND Apttus_Config2__Dimension1Value__c NOT IN: attorneys AND Ecom_Dimension1Value__c != 0
                AND Apttus_Config2__Dimension2Value__c =: customerPricingSegment
                ORDER BY Ecom_Dimension1Value__c ASC
            ];
        }
        for (Apttus_Config2__ClassificationHierarchy__c category: categoryList) {
            for (Apttus_Config2__PriceMatrixEntry__c matrixEntry: matrixEntryList) {

                String productId = matrixEntry.Apttus_Config2__PriceMatrixId__r.Apttus_Config2__PriceListItemId__r.Apttus_Config2__ProductId__c;
                if (!clonedProductset.contains(productId)) {
                    continue;
                }

                Ecom_StoreResponse.PriceMatrix matrix = new Ecom_StoreResponse.PriceMatrix();
                matrix.ProductId = productId;

                if (matrixEntry.Apttus_Config2__AdjustmentAmount__c != null) {
                    matrix.amount = matrixEntry.Apttus_Config2__AdjustmentAmount__c;
                }

                matrix.quantity = Integer.valueOf(matrixEntry.Apttus_Config2__Dimension1Value__c);
                defaultProductToPriceMatrix.put(productId, matrix);
                clonedProductset.remove(productId);

                if (clonedProductset.isEmpty()) {
                    break;
                }
            }

            Map < String, Map < Integer, Ecom_StoreResponse.PriceMatrix >> quantityPriceMatrixMap = new Map < String, Map < Integer, Ecom_StoreResponse.PriceMatrix >> ();

            List < Apttus_Config2__PriceMatrixEntry__c > matrixEntryList2 = new List < Apttus_Config2__PriceMatrixEntry__c > ();
            if (Schema.sObjectType.Apttus_Config2__PriceMatrixEntry__c.isQueryable()) {
                matrixEntryList2 = [
                    SELECT Apttus_Config2__PriceMatrixId__r.Apttus_Config2__PriceListItemId__r.Apttus_Config2__ProductId__c,
                    Apttus_Config2__Dimension1Value__c, Apttus_Config2__AdjustmentAmount__c, Apttus_Config2__AdjustmentType__c
                    FROM Apttus_Config2__PriceMatrixEntry__c
                    WHERE Apttus_Config2__PriceMatrixId__r.Apttus_Config2__PriceListItemId__r.Apttus_Config2__ProductId__c IN: productIdSet
                    AND Apttus_Config2__Dimension1Value__c IN: attorneys AND Apttus_Config2__Dimension2Value__c =: customerPricingSegment
                ];
            }
            for (Apttus_Config2__PriceMatrixEntry__c matrixEntry: matrixEntryList2) {

                Ecom_StoreResponse.PriceMatrix matrix = new Ecom_StoreResponse.PriceMatrix();
                String productId = matrixEntry.Apttus_Config2__PriceMatrixId__r.Apttus_Config2__PriceListItemId__r.Apttus_Config2__ProductId__c;
                matrix.ProductId = productId;

                if (matrixEntry.Apttus_Config2__AdjustmentAmount__c != null) {
                    matrix.amount = matrixEntry.Apttus_Config2__AdjustmentAmount__c;
                }
                matrix.quantity = Integer.valueOf(matrixEntry.Apttus_Config2__Dimension1Value__c);

                if (quantityPriceMatrixMap.get(productId) == null) {
                    quantityPriceMatrixMap.put(productId, new Map < Integer, Ecom_StoreResponse.PriceMatrix > ());
                }
                quantityPriceMatrixMap.get(productId).put(matrix.quantity, matrix);
            }

            for (String prodId: quantityPriceMatrixMap.keySet()) {
                Ecom_StoreResponse.PriceMatrix prevMatrix = null;

                for (Integer i = maxNoOfAttorneys; i >= 1; i--) {
                    if (!quantityPriceMatrixMap.get(prodId).keySet().contains(i)) {
                        if (prevMatrix == null) {
                            prevMatrix = new Ecom_StoreResponse.PriceMatrix();
                            prevMatrix.amount = defaultProductToPriceMatrix.get(prodId).amount;
                            prevMatrix.ProductId = prodId;
                        }
                        prevMatrix.quantity = i;
                        quantityPriceMatrixMap.get(prodId).put(i, prevMatrix.clone());
                    }
                    prevMatrix = quantityPriceMatrixMap.get(prodId).get(i).clone();
                }
            }

            for (String prodId: quantityPriceMatrixMap.keySet()) {
                productToPriceMatrices.put(String.valueOf(category.Id) + prodId, sortMap(quantityPriceMatrixMap.get(prodId), 'ASC').values());
            }
        }

        System.debug(JSON.serialize(productToPriceMatrices));
        return productToPriceMatrices;
    }

    /**
     * Prepares Pricing map for Products using the Product Matrix based on the Products, Quantity AND Module Points
     * passed as parameter. BUNDLE
     */
    // public Map<String, List<Ecom_StoreResponse.PriceMatrix>> getPriceMatrix(Set<Id> productIdSet, Integer maxNoOfAttorneys, String modulePoints) {
    public Map < String, List < Ecom_StoreResponse.PriceMatrix >> getPriceMatrix(Integer maxNoOfAttorneys) {
        Set < String > attorneys = new Set < String > ();
        for (Integer i = 1; i <= maxNoOfAttorneys; i++) {
            attorneys.add(String.valueOf(i));
        }

        Map < String, List < Ecom_StoreResponse.PriceMatrix >> productToPriceMatrices = new Map < String, List < Ecom_StoreResponse.PriceMatrix >> ();
        Map < String, Map < Integer, Ecom_StoreResponse.PriceMatrix >> quantityPriceMatrixMap = new Map < String, Map < Integer, Ecom_StoreResponse.PriceMatrix >> ();

        String modulePoints;

        for (Apttus_Config2__ClassificationHierarchy__c category: categoryList) {
            // Construct Map<ProductId, ModulePoints>
            Set < Id > productIdSet = new Set < Id > ();
            String bundleId = '';

            List < Ecom_StoreResponse.cls_products > categoryProductList = getProductsForCategory(Category.Id);
            for (Ecom_StoreResponse.cls_products product: categoryProductList) {
                productIdSet.add(product.productId);
                if (product.cType == 'Bundle') {
                    bundleId = product.productId;
                }
            }
            modulePoints = String.valueOf(getModulePoints(productIdSet));

            List < Apttus_Config2__PriceMatrixEntry__c > matrixEntryList = new List < Apttus_Config2__PriceMatrixEntry__c > ();
            if (Schema.sObjectType.Apttus_Config2__PriceMatrixEntry__c.isQueryable()) {
                matrixEntryList = [SELECT Apttus_Config2__PriceMatrixId__r.Apttus_Config2__PriceListItemId__r.Apttus_Config2__ProductId__c,
                    Apttus_Config2__Dimension1Value__c, Apttus_Config2__Dimension2Value__c, Apttus_Config2__AdjustmentAmount__c,
                    Apttus_Config2__AdjustmentType__c
                    FROM Apttus_Config2__PriceMatrixEntry__c
                    WHERE Apttus_Config2__PriceMatrixId__r.Apttus_Config2__PriceListItemId__r.Apttus_Config2__ProductId__c =: bundleId
                    AND Apttus_Config2__Dimension1Value__c =: modulePoints
                    AND Apttus_Config2__Dimension2Value__c IN: attorneys
                ];
            }
            for (Apttus_Config2__PriceMatrixEntry__c matrixEntry: matrixEntryList) {

                Ecom_StoreResponse.PriceMatrix matrix = new Ecom_StoreResponse.PriceMatrix();
                String productId = matrixEntry.Apttus_Config2__PriceMatrixId__r.Apttus_Config2__PriceListItemId__r.Apttus_Config2__ProductId__c;
                matrix.ProductId = productId;

                if (matrixEntry.Apttus_Config2__AdjustmentAmount__c != null) {
                    matrix.amount = matrixEntry.Apttus_Config2__AdjustmentAmount__c;
                }
                matrix.quantity = Integer.valueOf(matrixEntry.Apttus_Config2__Dimension2Value__c);

                if (quantityPriceMatrixMap.get(productId) == null) {
                    quantityPriceMatrixMap.put(productId, new Map < Integer, Ecom_StoreResponse.PriceMatrix > ());
                }
                quantityPriceMatrixMap.get(productId).put(matrix.quantity, matrix);
            }

            for (String prodId: quantityPriceMatrixMap.keySet()) {
                Ecom_StoreResponse.PriceMatrix prevMatrix = null;

                for (Integer i = maxNoOfAttorneys; i >= 1; i--) {

                    if (!quantityPriceMatrixMap.get(prodId).keySet().contains(i)) {
                        if (prevMatrix == null) {
                            prevMatrix = new Ecom_StoreResponse.PriceMatrix();
                            prevMatrix.amount = 0;
                            prevMatrix.ProductId = prodId;
                        }
                        prevMatrix.quantity = i;
                        quantityPriceMatrixMap.get(prodId).put(i, prevMatrix.clone());
                    }
                    prevMatrix = quantityPriceMatrixMap.get(prodId).get(i).clone();
                }
            }

            for (String prodId: quantityPriceMatrixMap.keySet()) {
                productToPriceMatrices.put(String.valueOf(category.Id) + prodId, sortMap(quantityPriceMatrixMap.get(prodId), 'ASC').values());
            }
        }

        System.debug(JSON.serialize(productToPriceMatrices));
        return productToPriceMatrices;
    }

    /*
     *   Prepares Sort priceMap based on priceMap, Order passed as parameters.
     */
    private Map < Integer, Ecom_StoreResponse.PriceMatrix > sortMap(Map < Integer, Ecom_StoreResponse.PriceMatrix > theMap, String theOrder) {
        //create the return map
        Map < Integer, Ecom_StoreResponse.PriceMatrix > returnMap = new Map < Integer, Ecom_StoreResponse.PriceMatrix > ();

        //get the Set of the keys of the map we want to sort
        Set < Integer > keySet = theMap.keySet();

        //create a list AND add all the keys FROM the Set to sort
        List < Integer > keyList = new List < Integer > ();
        keyList.addAll(keySet);

        //sort the list ascending (predefined behaviour)
        keyList.sort();
        if (theOrder == 'DESC') {
            //iterate FROM the last to the first key over the ascending ordered key list
            for (Integer i = (keyList.size() - 1); i >= 0; i--) {
                returnMap.put(keyList[i], theMap.get(keyList[i]));
            }
        } else {
            //iterate FROM the first to the last key over the ascending ordered key list
            for (Integer i = 0; i < keyList.size(); i++) {
                returnMap.put(keyList[i], theMap.get(keyList[i]));
            }
        }

        return returnMap;
    }

    /** 
     *   calculate the amount based contractTerm AND category adjustments AND return list of priceMatrix wrapper
     */
    public List < Ecom_StoreResponse.PriceMatrix > getDiscountedPriceByPriceMatrix(List < Ecom_StoreResponse.PriceMatrix > matrices, Map < String, Ecom_StoreResponse.Adjustments > contractTermAdjustments) {

        // create the return List
        List < Ecom_StoreResponse.PriceMatrix > cloneMatrices = new List < Ecom_StoreResponse.PriceMatrix > ();

        // iterate price matix to update the discount prices
        for (Ecom_StoreResponse.PriceMatrix matrix: matrices) {

            if (contractTermAdjustments == null) {
                continue;
            }

            // iterate contractTermAdjustments to add prices for contactTerm level
            for (String contractTerm: contractTermAdjustments.keySet()) {
                Ecom_StoreResponse.Adjustments adjustment = contractTermAdjustments.get(contractTerm);

                Ecom_StoreResponse.PriceMatrix clone = matrix.clone();
                clone.amount = getDiscountedPrice(clone.amount, adjustment.adjustmentAmount, adjustment.adjustmentType);
                clone.contractTerm = contractTerm;
                cloneMatrices.add(clone);
            }
        }

        return cloneMatrices;
    }

    /** 
     *   calculate the price AND return
     */
    private Decimal getDiscountedPrice(Decimal adjustedPrice, Decimal adjustmentAmount, String adjustmentType) {
        //Check whether % discount is required or % markup
        if (adjustmentType == Label.DC_PERCENT_DISCOUNT) {
            adjustedPrice = adjustedPrice * ((100 - adjustmentAmount) / 100);
        } else {
            if (adjustmentType == Label.DC_PERCENT_MARKUP) {
                adjustedPrice = adjustedPrice * ((100 + adjustmentAmount) / 100);
            }
        }

        return adjustedPrice;
    }

    /** 
     *   getStoreList
     */
    public static List < APTSECOM_Store__c > getStoreList(String storeName) {
        List < APTSECOM_Store__c > stores;
        if (!Schema.sObjectType.APTSECOM_Store__c.isQueryable()) {
            throw new DCCustomException('APTSECOM_Store__c is not queryable');
        }

        return [
            SELECT Id, Name, APTSECOM_Store_Title__c, APTSECOM_Max_No_Of_PerSeatUsers__c, APTSECOM_Adjustment_Amount__c,
            APTSECOM_Adjustment_Type__c, APTSECOM_Max_No_Of_Attorneys__c, APTSECOM_Category_Hierarchy__c, APTSECOM_Price_List__c,
            APTSECOM_Default_Contract_Term__c, Ecom_Has_Bundles__c, APTSECOM_Customer_Pricing_Segment__c, APTSECOM_Least_Prices__c,
            (SELECT Id, Name, APTSECOM_Product__c, APTSECOM_Recommendation_Type__c, APTSECOM_Source_Product__c, APTSECOM_Store__c FROM Product_Recommendations__r)
            FROM APTSECOM_Store__c WHERE Name =: storeName WITH SECURITY_ENFORCED LIMIT 1
        ];
    }
}