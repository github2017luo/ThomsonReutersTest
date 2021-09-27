@isTest
public class Ecom_StoreService_Test {

    public static String mainCategoryId;
    public static String pBookId;
    public static Integer errorCode = 4000;
    public static String storeName = '';

    @isTest
    public static void storeService() {
        Test.startTest();
        Apttus_Config2__PriceList__c priceList = DCTestData.createPriceList('Thomson Reuters Master - US Legal');
        insert priceList;
        pBookId = priceList.Id;

        Product2 p1 = DCTestData.createProduct('WestLaw Product', '23456', '23456', 'Minnesota');
        createCategories(p1.Id);

        Ecom_StoreResponse resp = Ecom_StoreService.getStoreDetails('Corp', new List < String > ());

        APTSECOM_Store__c store = DCTestData.createStore('Small Law', mainCategoryId);
        List < New_Sales_Contract_Term_Setting__c > terms = createContractTerms(store.id, mainCategoryId);

        List < APTSECOM_Store_Price_Adjustment__c > storePrices = new List < APTSECOM_Store_Price_Adjustment__c > ();

        List < Apttus_Config2__ClassificationHierarchy__c > categories = [
            SELECT id FROM Apttus_Config2__ClassificationHierarchy__c
            WHERE Apttus_Config2__PrimordialId__c =: mainCategoryId AND Apttus_Config2__Level__c = 1
        ];

        for (Apttus_Config2__ClassificationHierarchy__c hierarchy: categories) {
            APTSECOM_Store_Price_Adjustment__c sp = createStorePriceAdjustments(store.Id, hierarchy.Id, 1);
            storePrices.add(sp);
        }
        insert storePrices;

        DCTestData.createProductPlan(p1.Id, '234456', '3456776');
        Test.stopTest();

        Ecom_StoreService.getStoreDetails(store.Name, new List < String > ());
        Ecom_StoreResponse strResponse = Ecom_StoreService.getStoreDetails('Small Law', new List < String > ());

        createStorePromo(Store.Id, '% Discount', 20.00);
        List < String > jurisdiction = new List < String > ();
        jurisdiction.add('Texas');

        Ecom_StoreResponse strResponse1 = Ecom_StoreService.getStoreDetails('Small Law', jurisdiction);
        System.AssertEquals(errorCode, strResponse.responseCode, 'Expected Response');
    }

    @isTest
    public static void response() {
        Test.startTest();
        try {
            Ecom_StoreResponse.testParse();
        } catch (Exception ex) {
            System.debug('Exception >> ' + ex);
            System.AssertEquals(String.isEmpty(ex.getMessage()), false, 'Expected Response');
        }
        Test.stopTest();
    }

    @isTest
    public static void productService() {
        String result = 'updated successfully';

        Test.startTest();
        Apttus_Config2__PriceList__c priceList = DCTestData.createPriceList('Thomson Reuters Master - US Legal');
        insert priceList;

        pBookId = priceList.Id;
        Product2 p1 = DCTestData.createProduct('WestLaw Product', '23456', '23456', 'Minnesota');
        createCategories(p1.Id);

        APTSECOM_Store__c store = DCTestData.createStore('Small Law', mainCategoryId);
        DCTestData.createProductPlan(p1.Id, '234456', '3456776');

        Test.stopTest();

        String response = Ecom_ProductService.updatePricesOnStore(store.Id);
        System.AssertEquals(result, response, 'Expected Response');
    }

    @isTest
    public static void bundleMethodTest() {
        Apttus_Config2__PriceList__c priceList = DCTestData.createPriceList('Thomson Reuters Master - US Legal');
        insert priceList;
        pBookId = priceList.Id;

        Product2 p1 = DCTestData.createProduct('WestLaw Bundle', '12121212', '12121212', 'General');
        p1.Apttus_Config2__ConfigurationType__c = 'Bundle';
        p1.APTS_Module_Points__c = 2;
        update p1;
        createCategories(p1.Id);

        Apttus_Config2__PriceMatrixEntry__c pme = [
            SELECT Apttus_Config2__PriceMatrixId__r.Apttus_Config2__PriceListItemId__r.Apttus_Config2__ProductId__c,
            Apttus_Config2__Dimension1Value__c, Apttus_Config2__Dimension2Value__c, Apttus_Config2__AdjustmentAmount__c,
            Apttus_Config2__AdjustmentType__c
            FROM Apttus_Config2__PriceMatrixEntry__c
            WHERE Apttus_Config2__PriceMatrixId__r.Apttus_Config2__PriceListItemId__r.Apttus_Config2__ProductId__c =: p1.Id LIMIT 1
        ];

        pme.Apttus_Config2__Dimension1Value__c = '2';
        pme.Apttus_Config2__Dimension2Value__c = '5';
        update pme;

        APTSECOM_Store__c store = DCTestData.createStore('Corporate Westlaw', mainCategoryId);
        store.Ecom_Has_Bundles__c = true;
        update store;
        List < New_Sales_Contract_Term_Setting__c > terms = createContractTerms(store.id, mainCategoryId);

        List < APTSECOM_Store_Price_Adjustment__c > storePrices = new List < APTSECOM_Store_Price_Adjustment__c > ();

        List < Apttus_Config2__ClassificationHierarchy__c > categories = [
            SELECT id FROM Apttus_Config2__ClassificationHierarchy__c
            WHERE Apttus_Config2__PrimordialId__c =: mainCategoryId AND Apttus_Config2__Level__c = 1
        ];

        for (Apttus_Config2__ClassificationHierarchy__c hierarchy: categories) {
            APTSECOM_Store_Price_Adjustment__c sp = createStorePriceAdjustments(store.Id, hierarchy.Id, 5);
            storePrices.add(sp);
        }
        insert storePrices;

        DCTestData.createProductPlan(p1.Id, '12121212', '12121212');

        Set < Id > productIdSet = new Set < Id > ();
        Id bundleProdId = [SELECT Id FROM Product2 WHERE Apttus_Config2__ConfigurationType__c = 'Bundle'
            LIMIT 1
        ].Id;
        productIdSet.add(bundleProdId);
        System.debug('productIdSet >> ' + productIdSet);

        Ecom_StoreService sService = new Ecom_StoreService();

        Test.startTest();
        Ecom_StoreResponse res = Ecom_StoreService.getStoreDetails('Corporate Westlaw', new List < String > {});
        System.AssertEquals(p1.Apttus_Config2__ConfigurationType__c, 'Bundle', 'Expected Response');
        Test.stopTest();
    }

    // createStorePriceAdjustments
    public static APTSECOM_Store_Price_Adjustment__c createStorePriceAdjustments(String store, String category, Decimal adjustmentamount) {
        APTSECOM_Store_Price_Adjustment__c storePrice = new APTSECOM_Store_Price_Adjustment__c();
        storePrice.APTSECOM_Store__c = store;
        storePrice.APTSECOM_Category_Hierarchy__c = category;
        storePrice.APTSECOM_Adjustment_Amount__c = adjustmentamount;
        storePrice.APTSECOM_Adjustment_Type__c = '% Discount';
        return storePrice;
    }

    // createStorePromo
    public static APTSECOM_Store_Promotion__c createStorePromo(String id, String adjustmentType, Decimal adjustmentAmount) {
        APTSECOM_Store_Promotion__c promo = new APTSECOM_Store_Promotion__c();
        promo.APTSECOM_Promo_Code__c = 'Bobo 2010';
        promo.APTSECOM_Store__c = id;
        promo.APTSECOM_Adjustment_Amount__c = adjustmentAmount;
        promo.APTSECOM_Adjustment_Type__c = adjustmentType;
        promo.APTSECOM_Is_Active__c = true;
        promo.APTSECOM_Start_Date__c = date.today();
        promo.APTSECOM_End_Date__c = date.today();
        insert promo;

        return promo;
    }

    // createContractTerms
    public static List < New_Sales_Contract_Term_Setting__c > createContractTerms(String store, String category) {
        List < New_Sales_Contract_Term_Setting__c > contractTerms = new List < New_Sales_Contract_Term_Setting__c > ();
        New_Sales_Contract_Term_Setting__c term1 = new New_Sales_Contract_Term_Setting__c(
            Related_Store__c = store,
            Adjustment_Amount__c = 2,
            Adjustment_Type__c = '% Markup',
            Markup_Percentage__c = 7,
            YoY_1__c = 7, YoY_2__c = 7,
            Contract_Term__c = '1 Year',
            Related_Category_Hierarchy__c = category
        );
        New_Sales_Contract_Term_Setting__c term2 = new New_Sales_Contract_Term_Setting__c(
            Related_Store__c = store,
            Adjustment_Amount__c = 4,
            Adjustment_Type__c = '% Markup',
            Markup_Percentage__c = 5,
            YoY_1__c = 5,
            YoY_2__c = 5,
            Contract_Term__c = '2 Years',
            Related_Category_Hierarchy__c = category
        );
        New_Sales_Contract_Term_Setting__c term3 = new New_Sales_Contract_Term_Setting__c(
            Related_Store__c = store,
            Adjustment_Amount__c = 2,
            Adjustment_Type__c = '% Discount',
            Markup_Percentage__c = 2,
            YoY_1__c = 2,
            YoY_2__c = 2,
            Contract_Term__c = '3 Years',
            Related_Category_Hierarchy__c = category
        );
        contractTerms.add(term1);
        contractTerms.add(term2);
        contractTerms.add(term3);
        insert contractTerms;
        return contractTerms;
    }

    public static String createCategories(String productId) {
        Apttus_Config2__ClassificationName__c mainCategory = new Apttus_Config2__ClassificationName__c();
        mainCategory.Apttus_Config2__HierarchyLabel__c = 'Digital Configurator';
        mainCategory.Name = 'Digital Configurator';
        insert mainCategory;

        Apttus_Config2__ClassificationHierarchy__c hierMain = new Apttus_Config2__ClassificationHierarchy__c();
        hierMain.Apttus_Config2__HierarchyId__c = mainCategory.Id;
        hierMain.Name = 'Digital Configurator';
        hierMain.Apttus_Config2__Label__c = 'Digital Configurator';
        hierMain.Apttus_Config2__Level__c = 0;
        insert hierMain;
        mainCategoryId = hierMain.Id;

        Apttus_Config2__ClassificationHierarchy__c hierPL = new Apttus_Config2__ClassificationHierarchy__c();
        hierPL.Apttus_Config2__Level__c = 1;
        hierPL.Apttus_Config2__AncestorId__c = hierMain.Id;
        hierPL.Apttus_Config2__HierarchyId__c = mainCategory.Id;
        hierPL.Apttus_Config2__PrimordialId__c = hierMain.Id;
        hierPL.Name = 'Primary Law';
        hierPL.Apttus_Config2__Label__c = 'Primary Law';
        hierPL.DC_Sequence_No__c = 1;

        List < Apttus_Config2__ClassificationHierarchy__c > level1HierList = new List < Apttus_Config2__ClassificationHierarchy__c > ();
        level1HierList.add(hierPL);

        Apttus_Config2__ClassificationHierarchy__c hierAN = new Apttus_Config2__ClassificationHierarchy__c();
        hierAN.Apttus_Config2__AncestorId__c = hierMain.Id;
        hierAN.Apttus_Config2__HierarchyId__c = mainCategory.Id;
        hierAN.Apttus_Config2__PrimordialId__c = hierMain.Id;
        hierAN.Name = 'Primary Law';
        hierAN.Apttus_Config2__Label__c = 'Analytical';
        hierAN.DC_Sequence_No__c = 2;
        hierPL.Apttus_Config2__Level__c = 1;
        level1HierList.add(hierAN);

        Apttus_Config2__ClassificationHierarchy__c hierLI = new Apttus_Config2__ClassificationHierarchy__c();
        hierLI.Apttus_Config2__AncestorId__c = hierMain.Id;
        hierLI.Apttus_Config2__HierarchyId__c = mainCategory.Id;
        hierLI.Apttus_Config2__PrimordialId__c = hierMain.Id;
        hierLI.Name = 'Primary Law';
        hierLI.Apttus_Config2__Label__c = 'Litigation';
        hierLI.DC_Sequence_No__c = 3;
        hierLI.Apttus_Config2__Level__c = 1;
        level1HierList.add(hierLI);
        insert level1HierList;

        Apttus_Config2__ClassificationHierarchy__c hierPLYourState = new Apttus_Config2__ClassificationHierarchy__c();
        hierPLYourState.Apttus_Config2__AncestorId__c = level1HierList[0].Id;
        hierPLYourState.Apttus_Config2__HierarchyId__c = mainCategory.Id;
        hierPLYourState.Apttus_Config2__PrimordialId__c = hierMain.Id;
        hierPLYourState.Name = 'Your State / All States';
        hierPLYourState.Apttus_Config2__Label__c = 'Your State / All States';
        hierPLYourState.DC_Sequence_No__c = 1;
        hierPLYourState.Apttus_Config2__Level__c = 2;

        List < Apttus_Config2__ClassificationHierarchy__c > level2HierList = new List < Apttus_Config2__ClassificationHierarchy__c > ();
        level2HierList.add(hierPLYourState);

        Apttus_Config2__ClassificationHierarchy__c hierPLYourCircuit = new Apttus_Config2__ClassificationHierarchy__c();
        hierPLYourCircuit.Apttus_Config2__AncestorId__c = level1HierList[0].Id;
        hierPLYourCircuit.Apttus_Config2__HierarchyId__c = mainCategory.Id;
        hierPLYourCircuit.Apttus_Config2__PrimordialId__c = hierMain.Id;
        hierPLYourCircuit.Name = 'Your Circuit / All Federal';
        hierPLYourCircuit.Apttus_Config2__Label__c = 'Your Circuit / All Federal';
        hierPLYourCircuit.DC_Sequence_No__c = 2;
        hierPLYourCircuit.Apttus_Config2__Level__c = 2;
        level2HierList.add(hierPLYourCircuit);

        Apttus_Config2__ClassificationHierarchy__c hierANYourAllNational = new Apttus_Config2__ClassificationHierarchy__c();
        hierANYourAllNational.Apttus_Config2__AncestorId__c = level1HierList[1].Id;
        hierANYourAllNational.Apttus_Config2__HierarchyId__c = mainCategory.Id;
        hierANYourAllNational.Apttus_Config2__PrimordialId__c = hierMain.Id;
        hierANYourAllNational.Name = 'Your State / All States / National';
        hierANYourAllNational.Apttus_Config2__Label__c = 'Your State / All States / National';
        hierANYourAllNational.DC_Sequence_No__c = 1;
        hierANYourAllNational.Apttus_Config2__Level__c = 2;
        level2HierList.add(hierANYourAllNational);

        Apttus_Config2__ClassificationHierarchy__c hierLIJuryV = new Apttus_Config2__ClassificationHierarchy__c();
        hierLIJuryV.Apttus_Config2__AncestorId__c = level1HierList[2].Id;
        hierLIJuryV.Apttus_Config2__HierarchyId__c = mainCategory.Id;
        hierLIJuryV.Apttus_Config2__PrimordialId__c = hierMain.Id;
        hierLIJuryV.Name = 'Jury verdicts';
        hierLIJuryV.Apttus_Config2__Label__c = 'Jury verdicts';
        hierLIJuryV.DC_Sequence_No__c = 1;
        hierLIJuryV.Apttus_Config2__Level__c = 2;
        level2HierList.add(hierLIJuryV);

        Apttus_Config2__ClassificationHierarchy__c hierLITrialCourtOrders = new Apttus_Config2__ClassificationHierarchy__c();
        hierLITrialCourtOrders.Apttus_Config2__AncestorId__c = level1HierList[2].Id;
        hierLITrialCourtOrders.Apttus_Config2__HierarchyId__c = mainCategory.Id;
        hierLITrialCourtOrders.Apttus_Config2__PrimordialId__c = hierMain.Id;
        hierLITrialCourtOrders.Name = 'Trial court orders';
        hierLITrialCourtOrders.Apttus_Config2__Label__c = 'Trial court orders';
        hierLITrialCourtOrders.DC_Sequence_No__c = 2;
        hierLITrialCourtOrders.Apttus_Config2__Level__c = 2;
        level2HierList.add(hierLITrialCourtOrders);

        Apttus_Config2__ClassificationHierarchy__c hierLITrialCourtFilings = new Apttus_Config2__ClassificationHierarchy__c();
        hierLITrialCourtFilings.Apttus_Config2__AncestorId__c = level1HierList[2].Id;
        hierLITrialCourtFilings.Apttus_Config2__HierarchyId__c = mainCategory.Id;
        hierLITrialCourtFilings.Apttus_Config2__PrimordialId__c = hierMain.Id;
        hierLITrialCourtFilings.Name = 'Trial Court filings';
        hierLITrialCourtFilings.Apttus_Config2__Label__c = 'Trial Court filings';
        hierLITrialCourtFilings.DC_Sequence_No__c = 3;
        hierLITrialCourtFilings.Apttus_Config2__Level__c = 2;
        level2HierList.add(hierLITrialCourtFilings);

        Apttus_Config2__ClassificationHierarchy__c hierLIAppellate = new Apttus_Config2__ClassificationHierarchy__c();
        hierLIAppellate.Apttus_Config2__AncestorId__c = level1HierList[2].Id;
        hierLIAppellate.Apttus_Config2__HierarchyId__c = mainCategory.Id;
        hierLIAppellate.Apttus_Config2__PrimordialId__c = hierMain.Id;
        hierLIAppellate.Name = 'Appellate briefs';
        hierLIAppellate.Apttus_Config2__Label__c = 'Appellate briefs';
        hierLIAppellate.DC_Sequence_No__c = 4;
        hierLIAppellate.Apttus_Config2__Level__c = 2;
        level2HierList.add(hierLIAppellate);
        insert level2HierList;

        Apttus_Config2__ProductClassification__c prodClass = new Apttus_Config2__ProductClassification__c();
        prodClass.Apttus_Config2__ProductId__c = productId;
        prodClass.Apttus_Config2__ClassificationId__c = level2HierList[0].Id;
        prodClass.DC_Product_Title__c = 'Test';
        prodClass.DC_Product_Jurisdiction__c = 'Minnesota';
        prodClass.DC_Product_Description__c = 'test';
        prodClass.Apttus_Config2__Sequence__c = 1;
        insert prodClass;

        Apttus_Config2__ProductClassification__c prodClass1 = new Apttus_Config2__ProductClassification__c();
        prodClass1.Apttus_Config2__ProductId__c = productId;
        prodClass1.Apttus_Config2__ClassificationId__c = level2HierList[1].Id;
        prodClass1.DC_Product_Title__c = 'Test';
        prodClass1.DC_Product_Jurisdiction__c = 'Your State / All States / National';
        prodClass1.DC_Product_Description__c = 'test';
        prodClass.Apttus_Config2__Sequence__c = 1;
        insert prodClass1;

        Apttus_Config2__PriceListItem__c pli = DCTestData.createPriceListItem(pBookId, productId);
        Apttus_Config2__PriceMatrix__c priceMatrix = DCTestData.createPriceMatix(pli.Id);
        Apttus_Config2__PriceMatrixEntry__c entry = DCTestData.createPriceMatrixEntry(priceMatrix.id, '1');
        DCTestData.createPriceMatrixEntry(priceMatrix.id, '50');
        return hierMain.Id;
    }
}