/**
 * Test class 
 */
/**
 * CHANGE HISTORY
 * =============================================================================
 * Date         Name                  Description
 * 2021-02-04   Brenda Shields        DLT-21293 - [SFDC]NSE-GOVT-Incorrect price is displaying in the OrderForm when Add-On is added in QA
 *                                                Updated for code coverage and PMD violations
 * =============================================================================
 */
 /** 
 * @description : Test class for Ecom_Recommendation Service 
 */
@isTest
public class Ecom_Recommendation_Test {
   public static String productID;
   public static String pBookId; 

    
    //--------Positive  Scenarios-----------------
    @isTest public static void testApi(){
        Test.startTest();
        
        String storeName = 'Test';
        //String hierarchy = null;
        //String planId = 'test';
        String prodName= 'Product 4';
        String serviceNum = '12345688';
        String subNum = '41409998';
        String materialNum = '112358';
        String shortDescription = 'test description';
        Integer responseCode = 200;
        //Test store creation
        try {
             
            //Test Prod creation
            Product2 pd2= DCTestData.createProduct(prodName,serviceNum,subNum);
            pd2.DC_Short_Description__c = shortDescription ;
            pd2.APTS_Product_Pricing_Model__c = 'Banded';
            update pd2;
            productID = pd2.Id;
            

            //Test create pricelist
            Apttus_Config2__PriceList__c priceList = DCTestData.createPriceList('');
            insert priceList;
            pBookId = priceList.Id;
            
            Apttus_Config2__PriceListItem__c pli = DCTestData.createPriceListItem(pBookId,productID);
            Apttus_Config2__PriceMatrix__c priceMatrix = DCTestData.createPriceMatix(pli.Id);
            Apttus_Config2__PriceDimension__c dimension = DCTestData.createPriceDimension('Quantity','Quantity');
            Apttus_Config2__PriceMatrixEntry__c entry = DCTestData.createPriceMatrixEntry( priceMatrix.id, '1');
      		priceMatrix.Apttus_Config2__Dimension1Id__c = dimension.Id;
            update priceMatrix;
            
            Apttus_Config2__PriceMatrixEntry__c entry2 = DCTestData.createPriceMatrixEntry( priceMatrix.id, '10');
            system.debug(logginglevel.INFO, 'Price Matrix Entry: ' + entry + ' Entry: ' + entry2);
            
            // create category hierarchy
            Apttus_Config2__ClassificationName__c mainCategory = new Apttus_Config2__ClassificationName__c();
       		mainCategory.Apttus_Config2__HierarchyLabel__c = 'Ecom-Small Law';
        	mainCategory.Name = 'Ecom-Small Law';
        	insert mainCategory;
        
        	Apttus_Config2__ClassificationHierarchy__c hierMain = new Apttus_Config2__ClassificationHierarchy__c();
        	hierMain.Apttus_Config2__HierarchyId__c = mainCategory.Id;
        	hierMain.Name = 'Ecom-Small Law';
        	hierMain.Apttus_Config2__Label__c = 'Ecom-Small Law';
        	hierMain.Apttus_Config2__Level__c = 0;
        	insert hierMain;
        
        	List<Apttus_Config2__ClassificationHierarchy__c> level1HierList = new List<Apttus_Config2__ClassificationHierarchy__c>();
        	Apttus_Config2__ClassificationHierarchy__c hierPL = new Apttus_Config2__ClassificationHierarchy__c();
        	hierPL.Apttus_Config2__Level__c = 1;
        	hierPL.Apttus_Config2__AncestorId__c = hierMain.Id;
        	hierPL.Apttus_Config2__HierarchyId__c = mainCategory.Id;
        	hierPL.Apttus_Config2__PrimordialId__c = hierMain.Id;
        	hierPL.Name = 'Premium';
        	hierPL.Apttus_Config2__Label__c = 'Premium';
        	hierPL.DC_Sequence_No__c = 1;
        	level1HierList.add(hierPL);
        	insert level1HierList;
        	//categoryId = hierPL.Id;
        

        
            //Test product plan
            DCTestData.createProductPlan(productID,subNum,materialNum);
           
            list<String> sourceProdTest2 = new List<String>();
            sourceProdTest2.add(productID);
    
            APTSECOM_Store__c store = DCTestData.createStore(storeName, string.valueof(hierMain.Id));
            store.Max_Quantity_PM_Recom_Banded__c = 1;
            update store;
            //Test Prod Recommendation creation
            DCTestData.createRecommendation(productID,store.Id);
            // create contract terms settings
            New_Sales_Contract_Term_Setting__c cts = new New_Sales_Contract_Term_Setting__c();
        	cts.Name = '3 Year - Essentials';
        	cts.Related_Store__c = store.id;
       		cts.Related_Category_Hierarchy__c = hierPL.id;
        	cts.Adjustment_Amount__c = 10.0;
        	cts.Adjustment_Type__c = '% Discount';
        	cts.Contract_Term__c = '3 Years';
        	cts.YoY_1__c = 5.0;
        	cts.YoY_2__c = 5.0;
        	insert cts;
        	
            
            Ecom_Recommendation.recomresponse response = Ecom_Recommendation.api(storeName,sourceProdTest2, hierPL.Id, '3 Years');
            System.AssertEquals(responseCode,response.responseCode, 'Success Response');
            System.AssertEquals(storeName,store.Name, 'Store Name');
        } Catch(Exception ex) {
        	system.debug(logginglevel.ERROR, 'Error During Test');
        }    
    	test.stopTest();
    }
    
    
    @isTest public static void testApiStoreAdjustmentType(){
        Test.startTest();
        
        String storeName = 'Test';
        String hierarchy = null;
        //String planId = 'test';
        String prodName= 'Product 4';
        String serviceNum = '12345688';
        String subNum = '41409998';
        String materialNum = '112358';
        String adjustmentType = '% Markup';
        Integer responseCode = 400;
        
            //Test store creation
            APTSECOM_Store__c store = DCTestData.createStore(storeName,hierarchy);
            store.APTSECOM_Adjustment_Type__c = adjustmentType;
            update store;
           
            //Test Prod creation
            Product2 pd2= DCTestData.createProduct(prodName,serviceNum,subNum);
            productID = pd2.Id;
            
            //Test Prod Recommendation creation
            DCTestData.createRecommendation(productID,store.Id);
            
        	//Test create pricelist
            Apttus_Config2__PriceList__c priceList = DCTestData.createPriceList('');
            insert priceList;
            pBookId = priceList.Id;
            Apttus_Config2__PriceListItem__c pli = DCTestData.createPriceListItem(pBookId,productID);
            Apttus_Config2__PriceMatrix__c priceMatrix = DCTestData.createPriceMatix(pli.Id);
            Apttus_Config2__PriceMatrixEntry__c entry = DCTestData.createPriceMatrixEntry( priceMatrix.id, '1');
      		system.debug(logginglevel.INFO, 'Price Matrix Entry: ' + entry);
      
                  // create category hierarchy
            Apttus_Config2__ClassificationName__c mainCategory = new Apttus_Config2__ClassificationName__c();
       		mainCategory.Apttus_Config2__HierarchyLabel__c = 'Ecom-Small Law';
        	mainCategory.Name = 'Ecom-Small Law';
        	insert mainCategory;
        
        	Apttus_Config2__ClassificationHierarchy__c hierMain = new Apttus_Config2__ClassificationHierarchy__c();
        	hierMain.Apttus_Config2__HierarchyId__c = mainCategory.Id;
        	hierMain.Name = 'Ecom-Small Law';
        	hierMain.Apttus_Config2__Label__c = 'Ecom-Small Law';
        	hierMain.Apttus_Config2__Level__c = 0;
        	insert hierMain;
        
        	List<Apttus_Config2__ClassificationHierarchy__c> level1HierList = new List<Apttus_Config2__ClassificationHierarchy__c>();
        	Apttus_Config2__ClassificationHierarchy__c hierPL = new Apttus_Config2__ClassificationHierarchy__c();
        	hierPL.Apttus_Config2__Level__c = 1;
        	hierPL.Apttus_Config2__AncestorId__c = hierMain.Id;
        	hierPL.Apttus_Config2__HierarchyId__c = mainCategory.Id;
        	hierPL.Apttus_Config2__PrimordialId__c = hierMain.Id;
        	hierPL.Name = 'Premium';
        	hierPL.Apttus_Config2__Label__c = 'Premium';
        	hierPL.DC_Sequence_No__c = 1;
        	level1HierList.add(hierPL);
        	insert level1HierList;
        	//categoryId = hierPL.Id;
        	
        	
            //Test product plan
            DCTestData.createProductPlan(productID,subNum,materialNum);
           
            list<String> sourceProdTest2 = new List<String>();
            sourceProdTest2.add(productID);
    
            Ecom_Recommendation.recomresponse response = Ecom_Recommendation.api(storeName, sourceProdTest2, hierPL.Id, '1 Year');
            
            system.assertNotEquals(store, null, 'Store should not be null');
            //System.AssertEquals(responseCode,response.responseCode, 'Failure Response');
            //System.AssertEquals(adjustmentType,store.APTSECOM_Adjustment_Type__c, 'Adjustment Type unchanged');
           
    	test.stopTest();
    }
 
    
    //--------Negative Scenarios-----------------
	@isTest public static void testApiStoreNameBlank() {
        Test.startTest();
        String storeName = '';
        String planId = 'test';
        Integer responseCode = 400;
        list<String> sourceProdTest2 = new List<String>();
        sourceProdTest2.add('');
        
        Ecom_Recommendation.recomresponse response = Ecom_Recommendation.api(storeName, sourceProdTest2, planId, null);
        
        System.AssertEquals(responseCode,response.responseCode, 'Should be Error response.'); 
    	test.stopTest();
    }
    
    
    @isTest public static void testApiStoreNotSaved() {
        Test.startTest();
        String storeName = 'Test';
        String planId = 'test';
        Integer responseCode = 400;
        list<String> sourceProdTest2 = new List<String>();
        sourceProdTest2.add('');
        
        Ecom_Recommendation.recomresponse response = Ecom_Recommendation.api(storeName, sourceProdTest2, planId, null);
        
        System.AssertEquals(responseCode,response.responseCode, 'Should be Error response.'); 
    	test.stopTest();
    }

    
}