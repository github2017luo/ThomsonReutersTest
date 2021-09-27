@isTest
public class Ecom_FLStoreService_Test {

    @isTest
    public static void storeService() {
        Ecom_FLStoreService.StoreRequest req = new Ecom_FLStoreService.StoreRequest();
        req.storeName = 'FindLaw';
        req.attributeValue0 = '';
        req.attributeValue1 = '';
        req.attributeValue2 = '1';
        Product2 p1 = DCTestData.createProduct('WestLaw Product', '234456', '3456776', 'Minasota');
        String categoryId = createCategories(p1.Id);

        APTSECOM_Store__c store = DCTestData.createStore('FindLaw', categoryId);
        Apttus_Config2__ClassificationHierarchy__c ch = [SELECT Id FROM Apttus_Config2__ClassificationHierarchy__c
            WHERE Apttus_Config2__PrimordialId__c =: categoryId
            AND Apttus_Config2__Level__c = 1
            Limit 1
        ];
        createcontractterms(store.Id, ch.Id);
        DCTestData.createProductPlan(p1.Id, '234456', '3456776');

        APTS_Attribute_Value__c attributevalue4 = new APTS_Attribute_Value__c();
        attributevalue4.Name = '0-2';
        attributevalue4.APTS_Attribute_Name__c = 'State';
        //attributevalue.APTS_Parent_Attribute__c=attributesetting;
        attributevalue4.APTS_Product__c = p1.id;
        Insert attributevalue4;

        APTS_Attribute_Value_Combination__c attributecombination = new APTS_Attribute_Value_Combination__c();
        attributecombination.Name = 'Marshall-General';
        attributecombination.APTS_Attribute_Value2__c = attributevalue4.id;
        attributecombination.APTS_Product__c = p1.id;
        attributecombination.APTS_Price__c = 100;
        insert attributecombination;

        Ecom_FLStoreService.getStoreDetails(req);
        System.assertEquals(attributevalue4.Name,'0-2', 'Expected attribute Value');
    }

    public static List < New_Sales_Contract_Term_Setting__c > createcontractterms(String store, String category) {

        List < New_Sales_Contract_Term_Setting__c > contractterms = new List < New_Sales_Contract_Term_Setting__c > ();
        New_Sales_Contract_Term_Setting__c term1 = new New_Sales_Contract_Term_Setting__c(Related_Store__c = store, Adjustment_Amount__c = 2, Adjustment_Type__c = '% Markup', Markup_Percentage__c = 7, YoY_1__c = 7, YoY_2__c = 7, Contract_Term__c = '1 Year', Related_Category_Hierarchy__c = category);
        New_Sales_Contract_Term_Setting__c term2 = new New_Sales_Contract_Term_Setting__c(Related_Store__c = store, Adjustment_Amount__c = 4, Adjustment_Type__c = '% Markup', Markup_Percentage__c = 5, YoY_1__c = 5, YoY_2__c = 5, Contract_Term__c = '2 Years', Related_Category_Hierarchy__c = category);
        New_Sales_Contract_Term_Setting__c term3 = new New_Sales_Contract_Term_Setting__c(Related_Store__c = store, Adjustment_Amount__c = 2, Adjustment_Type__c = '% Discount', Markup_Percentage__c = 2, YoY_1__c = 2, YoY_2__c = 2, Contract_Term__c = '3 Years', Related_Category_Hierarchy__c = category);
        contractterms.add(term1);
        contractterms.add(term2);
        contractterms.add(term3);
        insert contractterms;
        return contractterms;
    }


    public static String createCategories(String productId) {

        Apttus_Config2__ClassificationName__c mainCategory = new Apttus_Config2__ClassificationName__c();
        mainCategory.Apttus_Config2__HierarchyLabel__c = 'Digital Configurator';
        mainCategory.Name = 'Digital Configurator';
        Insert mainCategory;

        Apttus_Config2__ClassificationHierarchy__c hierMain = new Apttus_Config2__ClassificationHierarchy__c();
        hierMain.Apttus_Config2__HierarchyId__c = mainCategory.Id;
        hierMain.Name = 'Digital Configurator';
        hierMain.Apttus_Config2__Label__c = 'Digital Configurator';
        hierMain.Apttus_Config2__Level__c = 0;
        Insert hierMain;

        List < Apttus_Config2__ClassificationHierarchy__c > level1HierList = new List < Apttus_Config2__ClassificationHierarchy__c > ();
        Apttus_Config2__ClassificationHierarchy__c hierPL = new Apttus_Config2__ClassificationHierarchy__c();
        hierPL.Apttus_Config2__Level__c = 1;
        hierPL.Apttus_Config2__AncestorId__c = hierMain.Id;
        hierPL.Apttus_Config2__HierarchyId__c = mainCategory.Id;
        hierPL.Apttus_Config2__PrimordialId__c = hierMain.Id;
        hierPL.Name = 'Primary Law';
        hierPL.Apttus_Config2__Label__c = 'Primary Law';
        hierPL.DC_Sequence_No__c = 1;
        level1HierList.add(hierPL);
        Insert level1HierList;

        Apttus_Config2__ProductClassification__c prodClass = new Apttus_Config2__ProductClassification__c();
        prodClass.Apttus_Config2__ProductId__c = productId;
        prodClass.Apttus_Config2__ClassificationId__c = level1HierList[0].Id;
        prodClass.DC_Product_Title__c = 'Test';
        prodClass.DC_Product_Jurisdiction__c = 'California';
        prodClass.DC_Product_Description__c = 'test';
        prodClass.Apttus_Config2__Sequence__c = 1;
        Insert prodClass;
        return hierMain.Id;
    }

}