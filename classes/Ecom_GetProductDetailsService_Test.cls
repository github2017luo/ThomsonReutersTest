@isTest
public class Ecom_GetProductDetailsService_Test {
    
    public static String mainCategoryId;
    public static String pBookId;
    public static Integer errorCode = 4000;
    public static String storename='';  
    @isTest
    public static void getProductDetailsService(){
        Test.startTest();
        
        Apttus_Config2__PriceList__c priceList = DCTestData.createPriceList('Thomson Reuters Master - US Legal');
        insert priceList;
        pBookId = priceList.Id;
        
        Product2 p1 = DCTestData.createProduct('WestLaw Product', '23456','23456','Minasota');
        createCategories(p1.Id);
        
        //Product2 p2 = DCTestData.createProduct('WestLaw Product', '2345336','2345312','Minasota');
        //createCategories(p2.Id);
        
        //Ecom_GetProductDetails_Response resp = Ecom_GetProductDetailsService.getProducts('Corp', new List<String>());
        //System.assertequals(resp.responseCode,errorCode);
        
        APTSECOM_Store__c store = DCTestData.createStore('Small Law', mainCategoryId);
        List<New_Sales_Contract_Term_Setting__c> terms= createcontractterms(store.id,mainCategoryId);
        List<APTSECOM_Store_Promotion__c> promo = new List<APTSECOM_Store_Promotion__c>();
        List<APTSECOM_Store_Price_Adjustment__c> storePrices = new List<APTSECOM_Store_Price_Adjustment__c>();
        //List<Apttus_Config2__ClassificationHierarchy__c> categories = [select id from Apttus_Config2__ClassificationHierarchy__c where Apttus_Config2__PrimordialId__c =: mainCategoryId and Apttus_Config2__Level__c = 1];
        
        List<Apttus_Config2__ClassificationHierarchy__c> categories = [select id,Name from Apttus_Config2__ClassificationHierarchy__c where Name =: Label.Ecom_CustomPlanName and Apttus_Config2__Level__c = 1 LIMIT 1];
        
        
        for(Apttus_Config2__ClassificationHierarchy__c hierarchy : categories){
            APTSECOM_Store_Price_Adjustment__c sp = createStorePriceAdjustments(store.Id, hierarchy.Id, '% Discount', 1);
            storePrices.add(sp);
        }
        
        insert storePrices;
        DCTestData.createProductPlan(p1.Id,'23456','23456');
        //DCTestData.createProductPlan(p2.Id,'2345312','2345336');
        
        Test.stopTest();
        
       /*
        List<Apttus_Config2__ProductClassification__c> prodClassificationSelectionList = [Select Id,name,Apttus_Config2__ClassificationId__c, Apttus_Config2__ClassificationId__r.Name, Apttus_Config2__ProductId__c,Apttus_Config2__ProductId__r.ProductCode, Apttus_Config2__ProductId__r.Subscription_Number__c from Apttus_Config2__ProductClassification__c
                                   where  Apttus_Config2__ClassificationId__r.Name =: Label.Ecom_CustomPlanName 
                                   AND Apttus_Config2__ProductId__r.Subscription_Number__c != NULL
                                   AND Apttus_Config2__ProductId__r.ProductCode != NULL LIMIT 10];
       */
        
        List<Ecom_GetProductDetails_Request.cls_products> prodList = new List<Ecom_GetProductDetails_Request.cls_products>();
        Ecom_GetProductDetails_Request.cls_products prod1 = new Ecom_GetProductDetails_Request.cls_products();
       // prod1.materialNumber = prodClassificationSelectionList[0].Apttus_Config2__ProductId__r.ProductCode;  
      //  prod1.subscriptionNumber = prodClassificationSelectionList[0].Apttus_Config2__ProductId__r.Subscription_Number__c;  
        prod1.materialNumber = '23456';
        prod1.subscriptionNumber = '23456';
        
        prodList.add(prod1);
        
        /*Ecom_GetProductDetails_Request.cls_products prod2 = new Ecom_GetProductDetails_Request.cls_products();
        prod2.materialNumber = '2345312';
        prod2.subscriptionNumber = '2345336';
        prodList.add(prod2);*/
        
        Ecom_GetProductDetails_Request request = new Ecom_GetProductDetails_Request('Small Law',prodList);
        //request.storeName = 'Small Law';
        //request.products = prodList;
        
        
        
        Ecom_GetProductDetails_Response strResponse=  Ecom_GetProductDetailsService.getProductDetails(request);
        //createStorepromo(Store.Id,'Bobo 2010','% Discount',20.00); 
        
      //  prodList[0].materialNumber='';
        //Ecom_GetProductDetails_Request request1 = new Ecom_GetProductDetails_Request('Small Law',prodList);
        //Ecom_GetProductDetailsService.getProductDetails(request1); 
        
        //Ecom_GetProductDetails_Request request2 = new Ecom_GetProductDetails_Request('',prodList);
        //Ecom_GetProductDetailsService.getProductDetails(request2);
        //List<String> jurisdiction = new List<String>();
        //jurisdiction.add('Texas');
        
        //Ecom_GetProductDetails_Response strResponse1=  Ecom_GetProductDetailsService.getProductDetails('Small Law', jurisdiction);
        //System.AssertEquals(errorCode,strResponse.responseCode);
        
    }

 @isTest
    public static void response(){
        Test.startTest();
        try{
            Ecom_GetProductDetails_Response.testParse();
        }Catch(Exception ex){}
        Test.stopTest();
    }
    

 
 
 
   public static APTSECOM_Store_Price_Adjustment__c createStorePriceAdjustments(String store, String category, String adjustmentType, Decimal adjustmentAmount){
        APTSECOM_Store_Price_Adjustment__c storePrice = new APTSECOM_Store_Price_Adjustment__c();
        storePrice.APTSECOM_Store__c = store;
        storePrice.APTSECOM_Category_Hierarchy__c = category;
        storePrice.APTSECOM_Adjustment_Amount__c = adjustmentAmount;
        storePrice.APTSECOM_Adjustment_Type__c = adjustmentType;
        return storePrice;  
    }



 public static List<New_Sales_Contract_Term_Setting__c> createcontractterms(String store,String category){
       List<New_Sales_Contract_Term_Setting__c> contract_terms=new List<New_Sales_Contract_Term_Setting__c>();
       New_Sales_Contract_Term_Setting__c term1=new New_Sales_Contract_Term_Setting__c(Related_Store__c=store,Adjustment_Amount__c= 2,Adjustment_Type__c='% Markup',Markup_Percentage__c=7,YoY_1__c=7,YoY_2__c=7,Contract_Term__c='1 Year',Related_Category_Hierarchy__c=category);
       New_Sales_Contract_Term_Setting__c term2=new New_Sales_Contract_Term_Setting__c(Related_Store__c=store,Adjustment_Amount__c= 4,Adjustment_Type__c='% Markup',Markup_Percentage__c=5,YoY_1__c=5,YoY_2__c=5,Contract_Term__c='2 Years',Related_Category_Hierarchy__c=category);
       New_Sales_Contract_Term_Setting__c term3=new New_Sales_Contract_Term_Setting__c(Related_Store__c=store,Adjustment_Amount__c= 2,Adjustment_Type__c='% Discount',Markup_Percentage__c=2,YoY_1__c=2,YoY_2__c=2,Contract_Term__c='3 Years',Related_Category_Hierarchy__c=category);
       contract_terms.add(term1);
       contract_terms.add(term2);
       contract_terms.add(term3);
       insert contract_terms;
       return contract_terms;
    } 
 
 public static void createCategories(String productId) {
        
        Apttus_Config2__ClassificationName__c mainCategory = new Apttus_Config2__ClassificationName__c();
        mainCategory.Apttus_Config2__HierarchyLabel__c = Label.Ecom_CustomPlanName;
        mainCategory.Name = Label.Ecom_CustomPlanName;
        Insert mainCategory;
        
        Apttus_Config2__ClassificationHierarchy__c hierMain = new Apttus_Config2__ClassificationHierarchy__c();
        
        hierMain.Apttus_Config2__HierarchyId__c = mainCategory.Id;
        hierMain.Name = Label.Ecom_CustomPlanName;
        hierMain.Apttus_Config2__Label__c = Label.Ecom_CustomPlanName;
        hierMain.Apttus_Config2__Level__c = 0;
        Insert hierMain;
        
        mainCategoryId = hierMain.Id;
        List<Apttus_Config2__ClassificationHierarchy__c> level1HierList = new List<Apttus_Config2__ClassificationHierarchy__c>();
        Apttus_Config2__ClassificationHierarchy__c hierPL = new Apttus_Config2__ClassificationHierarchy__c();
        hierPL.Apttus_Config2__Level__c = 1;
        hierPL.Apttus_Config2__AncestorId__c = hierMain.Id;
        hierPL.Apttus_Config2__HierarchyId__c = mainCategory.Id;
        hierPL.Apttus_Config2__PrimordialId__c = hierMain.Id;
        hierPL.Name = Label.Ecom_CustomPlanName;
        hierPL.Apttus_Config2__Label__c = Label.Ecom_CustomPlanName;
        hierPL.DC_Sequence_No__c = 1;
        
        level1HierList.add(hierPL);
        
        Apttus_Config2__ClassificationHierarchy__c hierAN = new Apttus_Config2__ClassificationHierarchy__c();
        
        hierAN.Apttus_Config2__AncestorId__c = hierMain.Id;
        hierAN.Apttus_Config2__HierarchyId__c = mainCategory.Id;
        hierAN.Apttus_Config2__PrimordialId__c = hierMain.Id;
        hierAN.Name = Label.Ecom_CustomPlanName;
        hierAN.Apttus_Config2__Label__c = 'Analytical';
        hierAN.DC_Sequence_No__c = 2;
        hierPL.Apttus_Config2__Level__c = 1;
        level1HierList.add(hierAN);
        
        Apttus_Config2__ClassificationHierarchy__c hierLI = new Apttus_Config2__ClassificationHierarchy__c();
        
        hierLI.Apttus_Config2__AncestorId__c = hierMain.Id;
        hierLI.Apttus_Config2__HierarchyId__c = mainCategory.Id;
        hierLI.Apttus_Config2__PrimordialId__c = hierMain.Id;
        hierLI.Name = Label.Ecom_CustomPlanName;
        hierLI.Apttus_Config2__Label__c = 'Litigation';
        hierLI.DC_Sequence_No__c = 3;
        hierLI.Apttus_Config2__Level__c = 1;
        level1HierList.add(hierLI);
        Insert level1HierList;
        
        List<Apttus_Config2__ClassificationHierarchy__c> level2HierList = new List<Apttus_Config2__ClassificationHierarchy__c>();
        Apttus_Config2__ClassificationHierarchy__c hierPLYourState = new Apttus_Config2__ClassificationHierarchy__c();
        
        hierPLYourState.Apttus_Config2__AncestorId__c = level1HierList[0].Id;
        hierPLYourState.Apttus_Config2__HierarchyId__c = mainCategory.Id;
        hierPLYourState.Apttus_Config2__PrimordialId__c = hierMain.Id;
        hierPLYourState.Name = Label.Ecom_CustomPlanName;
        hierPLYourState.Apttus_Config2__Label__c = 'Your State / All States';
        hierPLYourState.DC_Sequence_No__c = 1;
        hierPLYourState.Apttus_Config2__Level__c = 2;
        level2HierList.add(hierPLYourState);
        
        Apttus_Config2__ClassificationHierarchy__c hierPLYourCircuit = new Apttus_Config2__ClassificationHierarchy__c();
        
        hierPLYourCircuit.Apttus_Config2__AncestorId__c = level1HierList[0].Id;
        hierPLYourCircuit.Apttus_Config2__HierarchyId__c = mainCategory.Id;
        hierPLYourCircuit.Apttus_Config2__PrimordialId__c = hierMain.Id;
        hierPLYourCircuit.Name = Label.Ecom_CustomPlanName;
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
        hierLIJuryV.Name = Label.Ecom_CustomPlanName;
        hierLIJuryV.Apttus_Config2__Label__c = 'Jury verdicts';
        hierLIJuryV.DC_Sequence_No__c = 1;
        hierLIJuryV.Apttus_Config2__Level__c = 2;
        level2HierList.add(hierLIJuryV);
        
        Apttus_Config2__ClassificationHierarchy__c hierLITrialCourtOrders = new Apttus_Config2__ClassificationHierarchy__c();
        
        hierLITrialCourtOrders.Apttus_Config2__AncestorId__c = level1HierList[2].Id;
        hierLITrialCourtOrders.Apttus_Config2__HierarchyId__c = mainCategory.Id;
        hierLITrialCourtOrders.Apttus_Config2__PrimordialId__c = hierMain.Id;
        hierLITrialCourtOrders.Name = Label.Ecom_CustomPlanName;
        hierLITrialCourtOrders.Apttus_Config2__Label__c = 'Trial court orders';
        hierLITrialCourtOrders.DC_Sequence_No__c = 2;
        hierLITrialCourtOrders.Apttus_Config2__Level__c = 2;
        level2HierList.add(hierLITrialCourtOrders);
        
        Apttus_Config2__ClassificationHierarchy__c hierLITrialCourtFilings = new Apttus_Config2__ClassificationHierarchy__c();
        
        hierLITrialCourtFilings.Apttus_Config2__AncestorId__c = level1HierList[2].Id;
        hierLITrialCourtFilings.Apttus_Config2__HierarchyId__c = mainCategory.Id;
        hierLITrialCourtFilings.Apttus_Config2__PrimordialId__c = hierMain.Id;
        hierLITrialCourtFilings.Name = Label.Ecom_CustomPlanName;
        hierLITrialCourtFilings.Apttus_Config2__Label__c = 'Trial Court filings';
        hierLITrialCourtFilings.DC_Sequence_No__c = 3;
        hierLITrialCourtFilings.Apttus_Config2__Level__c = 2;
        level2HierList.add(hierLITrialCourtFilings);
        
        Apttus_Config2__ClassificationHierarchy__c hierLIAppellate = new Apttus_Config2__ClassificationHierarchy__c();
        
        hierLIAppellate.Apttus_Config2__AncestorId__c = level1HierList[2].Id;
        hierLIAppellate.Apttus_Config2__HierarchyId__c = mainCategory.Id;
        hierLIAppellate.Apttus_Config2__PrimordialId__c = hierMain.Id;
        hierLIAppellate.Name = Label.Ecom_CustomPlanName;
        hierLIAppellate.Apttus_Config2__Label__c = 'Appellate briefs';
        hierLIAppellate.DC_Sequence_No__c = 4;
        hierLIAppellate.Apttus_Config2__Level__c = 2;
        level2HierList.add(hierLIAppellate);
        
        Insert level2HierList;
        
        Apttus_Config2__ProductClassification__c prodClass = new Apttus_Config2__ProductClassification__c();
        prodClass.Apttus_Config2__ProductId__c = productId;
        prodClass.Apttus_Config2__ClassificationId__c = level2HierList[0].Id;
        prodClass.DC_Product_Title__c = 'Test';
        prodClass.DC_Product_Jurisdiction__c = 'California';
        prodClass.DC_Product_Description__c = 'test';
        prodClass.Apttus_Config2__Sequence__c = 1;
        Insert prodClass;
        
        Apttus_Config2__ProductClassification__c prodClass1 = new Apttus_Config2__ProductClassification__c();
        prodClass1.Apttus_Config2__ProductId__c = productId;
        prodClass1.Apttus_Config2__ClassificationId__c = level2HierList[1].Id;
        prodClass1.DC_Product_Title__c = 'Test';
        prodClass1.DC_Product_Jurisdiction__c = 'Your State / All States / National';
        prodClass1.DC_Product_Description__c = 'test';
        prodClass.Apttus_Config2__Sequence__c = 1;
        Insert prodClass1;
        
        Apttus_Config2__PriceListItem__c pli = DCTestData.createPriceListItem(pBookId, productId);
        Apttus_Config2__PriceMatrix__c priceMatrix = DCTestData.createPriceMatix(pli.Id);
        Apttus_Config2__PriceMatrixEntry__c entry = DCTestData.createPriceMatrixEntry( priceMatrix.id, '1');
        DCTestData.createPriceMatrixEntry( priceMatrix.id, '50');
    } 
    
  
    
    }