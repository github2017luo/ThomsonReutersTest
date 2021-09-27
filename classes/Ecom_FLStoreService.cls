/*
 * CHANGE HISTORY
 * ==================================================================================================================================
 * Date         Name                    Description
 * 2019-03-28   Ramesh Reddy          DLT-15507 - [NSE FL]  Tech Story Create Store Service for Findlaw products
 * 2020-16-11   Rahul Natarajan       DLT-20761 - [SFDC] [NSE] Critical and Blocker Code scan issue - Store Services
 * ==================================================================================================================================   
 */
@RestResource(urlMapping = '/ecom/flstore/*')
Global with sharing class Ecom_FLStoreService {

    @HTTPPost
    Global static FLStoreResponse getStoreDetails(StoreRequest request) {
        FLStoreResponse response = new FLStoreResponse();
        system.debug('request >' + Json.serialize(request));
        try {
            Ecom_FLStoreService service = new Ecom_FLStoreService();
            response = service.getStore(request);
        }
        Catch(Exception ex) {
            DCUtils.trackLog(ex, 'Ecom_FLStoreService', 'getStoreDetails');
            throw new DCCustomException(ex);
        }
        return response;
    }

    public String subCategoryId;
    public Map < String, Map < String, List < Ecom_StoreResponse.Material >>> productIdToMaterial = new Map < String, Map < String, List < Ecom_StoreResponse.Material >>> ();

    public FLStoreResponse getStore(StoreRequest request) {
        FLStoreResponse response = new FLStoreResponse();

        List < APTSECOM_Store__c > stores = getStoreList(request.storeName);
        if (stores.isEmpty()) {
            throw new DCCustomException('Store Name does not exist anymore');
        }
        String categoryHierarchy = stores[0].APTSECOM_Category_Hierarchy__c;
        subCategoryId = getSubCategory(categoryHierarchy);
        List < Apttus_Config2__ProductClassification__c > prodClassificationSelectionList = new List < Apttus_Config2__ProductClassification__c > ();
        if (Schema.sObjectType.Apttus_Config2__ProductClassification__c.isAccessible()) {
            prodClassificationSelectionList = [Select Id, name, Apttus_Config2__ClassificationId__c,
                Apttus_Config2__ClassificationId__r.Apttus_Config2__AncestorId__c,
                Apttus_Config2__ClassificationId__r.Name, Apttus_Config2__ProductId__c,
                Apttus_Config2__ProductId__r.DC_Long_Description__c,
                Apttus_Config2__ProductId__r.DC_Short_Description__c,
                Apttus_Config2__ProductId__r.DC_Product_Title__c,
                Apttus_Config2__ProductId__r.APTS_Product_Pricing_Model__c,
                Apttus_Config2__ProductId__r.DC_Jurisdiction__c,
                Apttus_Config2__ProductId__r.Subscription_Number__c,
                Apttus_Config2__ProductId__r.List_Price__c, Apttus_Config2__ProductId__r.Name,
                Apttus_Config2__ProductId__r.Description, Apttus_Config2__Sequence__c,
                Apttus_Config2__ProductId__r.Apttus_Config2__ConfigurationType__c
                From Apttus_Config2__ProductClassification__c
                Where Apttus_Config2__ClassificationId__r.Apttus_Config2__PrimordialId__c =: categoryHierarchy
            ];
        }
        Map < String, Apttus_Config2__ProductClassification__c > productIdToProdClassificationMap = new Map < String, Apttus_Config2__ProductClassification__c > ();
        for (Apttus_Config2__ProductClassification__c pc: prodClassificationSelectionList) {
            productIdToProdClassificationMap.put(pc.Apttus_Config2__ProductId__c, pc);
        }
        List < Ecom_StoreResponse.cls_ContractTermDetails > contractTermDetails = getContractTermDiscounts(stores[0]);
        getDigitalProductsBySelectedProducts(productIdToProdClassificationMap.keySet());
        response = prepareProductResponse(productIdToProdClassificationMap.keyset(), prodClassificationSelectionList, request);
        response.contractTermDetails = contractTermDetails;
        return response;
    }

    public FLStoreResponse prepareProductResponse(Set < String > productIds, List < Apttus_Config2__ProductClassification__c > productClassfication, StoreRequest request) {
        FLStoreResponse response = new FLStoreResponse();
        List < Ecom_StoreResponse.PriceMatrix > priceMatrices = getPrice(subcategoryId, productIds, request);
        List < cls_products > products = new List < cls_products > ();

        for (Apttus_Config2__ProductClassification__c prodDetail: productClassfication) {
            cls_products item = new cls_products();
            item.productId = prodDetail.Apttus_Config2__ProductId__c;
            item.productName = prodDetail.Apttus_Config2__ProductId__r.Name;
            item.productTitle = prodDetail.Apttus_Config2__ProductId__r.DC_Product_Title__c;
            item.jurisdiction = prodDetail.Apttus_Config2__ProductId__r.DC_Jurisdiction__c;
            item.longDescription = prodDetail.Apttus_Config2__ProductId__r.DC_Long_Description__c;
            item.shortDescription = prodDetail.Apttus_Config2__ProductId__r.DC_Short_Description__c;
            item.pricingModel = prodDetail.Apttus_Config2__ProductId__r.APTS_Product_Pricing_Model__c;
            item.cType = prodDetail.Apttus_Config2__ProductId__r.Apttus_Config2__ConfigurationType__c;
            item.attributeValueCombination = productIdToAVCombinationMap.get(prodDetail.Apttus_Config2__ProductId__c);
            item.priceMatrix = priceMatrices;

            // priceMatrices 
            item.material = new List < Ecom_StoreResponse.Material > ();
            if (productIdToMaterial.get(prodDetail.Apttus_Config2__ProductId__c) != null && productIdToMaterial.get(prodDetail.Apttus_Config2__ProductId__c).get(prodDetail.Apttus_Config2__ProductId__r.Subscription_Number__c) != null) {
                item.material = productIdToMaterial.get(prodDetail.Apttus_Config2__ProductId__c).get(prodDetail.Apttus_Config2__ProductId__r.Subscription_Number__c);
            }
            products.add(item);
        }
        response.products = products;
        response.priceMatrix = priceMatrices;
        return response;
    }
    public string getSubCategory(string categoryId) {
        String subCategoryId = '';
        if (Schema.sObjectType.Apttus_Config2__ClassificationHierarchy__c.isAccessible()) {
            Apttus_Config2__ClassificationHierarchy__c subCategory = [SELECT Id
                FROM Apttus_Config2__ClassificationHierarchy__c
                WHERE Apttus_Config2__PrimordialId__c =: categoryId
                AND Apttus_Config2__Level__c = 1
                Limit 1
            ];
            subCategoryId = subCategory.Id;
        }

        return subCategoryId;
    }

    Map < String, String > productIdToAVCombinationMap = new Map < String, String > ();
    Map < String, Map < String, Ecom_StoreResponse.Adjustments >> categoryToContractTermDiscount = new Map < String, Map < String, Ecom_StoreResponse.Adjustments >> ();
    public List < Ecom_StoreResponse.PriceMatrix > getPrice(String subcategoryId, Set < String > productIds, StoreRequest request) {
        List < Ecom_StoreResponse.PriceMatrix > priceMatrices = new List < Ecom_StoreResponse.PriceMatrix > ();
        Integer quantity = Integer.valueOf(request.attributeValue2);
        String productId;
        String attributeValueCombinationId;
        List < APTS_Attribute_Value_Combination__c > attributeValueCombinationsList = new List < APTS_Attribute_Value_Combination__c > ();
        if (Schema.sObjectType.APTS_Attribute_Value_Combination__c.isQueryable()) {
            attributeValueCombinationsList = [SELECT Id, APTS_Product__c,
                APTS_Price__c
                FROM APTS_Attribute_Value_Combination__c
                WHERE APTS_Product__c In: productIds
                AND APTS_Attribute_Value0__r.name =: request.attributeValue0
                AND APTS_Attribute_Value1__r.name =: request.attributeValue1
                AND APTS_Attribute_Value2__r.Ecom_Min_Attorney__c <=: quantity
                AND APTS_Attribute_Value2__r.Ecom_Max_Attorney__c >=: quantity
            ];
        }
        Map < String, Decimal > productIdToPriceMap = new Map < String, Decimal > ();

        for (APTS_Attribute_Value_Combination__c avc: attributeValueCombinationsList) {
            productIdToPriceMap.put(avc.APTS_Product__c, avc.APTS_Price__c);
            productIdToAVCombinationMap.put(avc.APTS_Product__c, avc.Id);
            productId = avc.APTS_Product__c;
            attributeValueCombinationId = avc.Id;
        }
        system.debug('subcategoryId ' + subcategoryId);
        for (String contractTerm: categoryToContractTermDiscount.get(subcategoryId).keyset()) {
            Ecom_StoreResponse.Adjustments adjustment = categoryToContractTermDiscount.get(subcategoryId).get(contractTerm);
            Ecom_StoreResponse.PriceMatrix pm = new Ecom_StoreResponse.PriceMatrix();
            pm.contractTerm = contractTerm;
            pm.quantity = quantity;
            pm.amount = getDiscountedPrice(productIdToPriceMap.get(productId), adjustment.adjustmentAmount, adjustment.adjustmentType);
            priceMatrices.add(pm);
        }
        return priceMatrices;
    }

    public List < Ecom_StoreResponse.cls_ContractTermDetails > getContractTermDiscounts(APTSECOM_Store__c store) {
        Map < String, Ecom_StoreResponse.Adjustments > categoryToDiscount = new Map < String, Ecom_StoreResponse.Adjustments > ();
        Map < String, List < Ecom_StoreResponse.ContractTermDetail >> planToContractterms = new Map < String, List < Ecom_StoreResponse.ContractTermDetail >> ();
        for (APTSECOM_Store_Price_Adjustment__c adjustment: store.Store_Price_Adjustments__r) {
            Ecom_StoreResponse.Adjustments ads = new Ecom_StoreResponse.Adjustments();
            ads.adjustmentType = adjustment.APTSECOM_Adjustment_Type__c;
            ads.adjustmentAmount = adjustment.APTSECOM_Adjustment_Amount__c;
            if (String.isBlank(adjustment.APTSECOM_Adjustment_Type__c) || adjustment.APTSECOM_Adjustment_Amount__c == null) {
                ads.adjustmentType = Label.DC_PERCENT_DISCOUNT;
                ads.adjustmentAmount = 0;
            }
            categoryToDiscount.put(adjustment.APTSECOM_Category_Hierarchy__c, ads);
        }

        for (New_Sales_Contract_Term_Setting__c contractTerm: store.New_Sales_Contract_Term_Settings__r) {

            if (categoryToContractTermDiscount.get(contractTerm.Related_Category_Hierarchy__c) == null) {
                categoryToContractTermDiscount.put(contractTerm.Related_Category_Hierarchy__c, New Map < String, Ecom_StoreResponse.Adjustments > ());
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
            Ecom_StoreResponse.Adjustments newAdjustment = Ecom_StoreService.calculateAdjustment(contractTerm.Adjustment_Amount__c, contractTerm.Adjustment_Type__c, ads.adjustmentAmount, ads.adjustmentType);

            if (categoryToContractTermDiscount.get(contractTerm.Related_Category_Hierarchy__c).get(contractTerm.Contract_Term__c) == null) {
                categoryToContractTermDiscount.get(contractTerm.Related_Category_Hierarchy__c).put(contractTerm.Contract_Term__c, newAdjustment);
            }
            Ecom_StoreResponse.ContractTermDetail termDetail = new Ecom_StoreResponse.ContractTermDetail();
            termDetail.markupPercentage = contractTerm.Markup_Percentage__c;
            termDetail.planID = contractTerm.Related_Category_Hierarchy__c;
            termDetail.planName = contractTerm.Related_Category_Hierarchy__r.name;
            termDetail.term = contractTerm.Contract_Term__c;
            termDetail.yearOnYearRenewal = contractTerm.YoY_1__c;
            termDetail.yearOnYearTwoPlus = contractTerm.YoY_2__c;
            if (planToContractterms.get(contractTerm.Related_Category_Hierarchy__c) == null) {
                planToContractterms.put(contractTerm.Related_Category_Hierarchy__c, new List < Ecom_StoreResponse.ContractTermDetail > ());
            }
            planToContractterms.get(contractTerm.Related_Category_Hierarchy__c).add(termDetail);
        }
        system.debug('categoryToContractTermDiscount ' + categoryToContractTermDiscount);
        List < Ecom_StoreResponse.cls_ContractTermDetails > contractTermDetails = new List < Ecom_StoreResponse.cls_ContractTermDetails > ();
        for (String key: planToContractterms.keyset()) {
            Ecom_StoreResponse.cls_ContractTermDetails details = new Ecom_StoreResponse.cls_ContractTermDetails();
            details.categoryId = key;
            details.terms = planToContractterms.get(key);
            contractTermDetails.add(details);
        }
        return contractTermDetails;
    }
    // calculate the price and return
    private Decimal getDiscountedPrice(Decimal price, Decimal adjustmentAmount, String adjustmentType) {
        //Check whether % discount is required or % markup
        if (adjustmentType == Label.DC_PERCENT_DISCOUNT) {
            price = price * ((100 - adjustmentAmount) / 100);
        } else {
            if (adjustmentType == Label.DC_PERCENT_MARKUP) {
                price = price * ((100 + adjustmentAmount) / 100);
            }
        }
        return price;
    }

    public Map < String, Map < String, List < Ecom_StoreResponse.Material >>> getDigitalProductsBySelectedProducts(Set < String > productIdSet) {
        List < Digital_Product_Plans__c > plans;
        if (Schema.sObjectType.Digital_Product_Plans__c.isAccessible()) {
            plans = [Select id, name, Material_Number__c, Material_Description__c, Product__c, Subscription_Number__c, SLF_Jurisdiction__c, DB_Group__c, DB_Group_Sort_Order__c, DB_Category__c, DB_Category_Sort_Order__c, SLF_Help_Text__c
                from Digital_Product_Plans__c
                where Product__c in: productIdSet
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
                productIdToMaterial.get(plan.Product__c).put(plan.Subscription_Number__c, New List < Ecom_StoreResponse.Material > ());
            }
            productIdToMaterial.get(plan.Product__c).get(plan.Subscription_Number__c).add(material);
        }
        return productIdToMaterial;
    }

    public static List < APTSECOM_Store__c > getStoreList(String storeName) {
        List < APTSECOM_Store__c > stores = new List < APTSECOM_Store__c > ();
        if (Schema.sObjectType.APTSECOM_Store__c.isQueryable()) {
            stores = [Select Id, name, APTSECOM_Store_Title__c, APTSECOM_Max_No_Of_PerSeatUsers__c,
                APTSECOM_Adjustment_Type__c, APTSECOM_Max_No_Of_Attorneys__c,
                APTSECOM_Price_List__c, APTSECOM_Default_Contract_Term__c,
                Ecom_Has_Bundles__c, APTSECOM_Category_Hierarchy__c,
                APTSECOM_Customer_Pricing_Segment__c,
                APTSECOM_Least_Prices__c, APTSECOM_Adjustment_Amount__c,
                (SELECT id, Name, APTSECOM_Product__c,
                    APTSECOM_Recommendation_Type__c, APTSECOM_Source_Product__c, APTSECOM_Store__c FROM Product_Recommendations__r),
                (Select id, name, Adjustment_Amount__c, Markup_Percentage__c,
                    Adjustment_Type__c, Related_Category_Hierarchy__c, Contract_Term__c,
                    YoY_1__c, YoY_2__c, Related_Category_Hierarchy__r.name From New_Sales_Contract_Term_Settings__r),
                (Select id, APTSECOM_Category_Hierarchy__c, APTSECOM_Adjustment_Type__c, APTSECOM_Adjustment_Amount__c From Store_Price_Adjustments__r)
                From APTSECOM_Store__c
                Where name =: storeName WITH SECURITY_ENFORCED Limit 1
            ];
        } else {
            throw new DCCustomException('APTSECOM_Store__c is not queryable');
        }
        return stores;
    }

    global class StoreRequest {
        public string storeName;
        public string attributeValue0;
        public string attributeValue1;
        public string attributeValue2;
        public string attributeValue3;
    }
    global class FLStoreResponse {
        public cls_products[] products;
        public List < Ecom_StoreResponse.cls_ContractTermDetails > contractTermDetails;
        public List < Ecom_StoreResponse.PriceMatrix > priceMatrix;
    }
    public class cls_products {
        public String shortDescription;
        public String productTitle;
        public String productName;
        public String productId;
        public String pricingModel;
        public String jurisdiction;
        public String longDescription;
        public String cType;
        public String attributeValueCombination;
        public List < Ecom_StoreResponse.Material > material;
        public List < Ecom_StoreResponse.PriceMatrix > priceMatrix;
    }
}