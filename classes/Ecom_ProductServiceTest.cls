@isTest
public class Ecom_ProductServiceTest{

    @testSetup
    static void setup(){
 
    Apttus_Config2__PriceList__c priceList = DCTestData.createPriceList('Thomson Reuters Master - US Legal');
    insert priceList;
    Product2 prd = DCTestData.createProduct('Test Product','12345','67890');
    prd.DC_Jurisdiction__c = 'Minnesota';
    update prd;
    DCTestData.createCategories(prd.id);
    Apttus_Config2__PriceListItem__c pli = DCTestData.createPriceListItem(pricelist.id, prd.id);
    Apttus_Config2__PriceMatrix__c priceMatrix = DCTestData.createPriceMatix(pli.Id);
    Apttus_Config2__PriceMatrixEntry__c entry = DCTestData.createPriceMatrixEntry( priceMatrix.id, '1');
    Apttus_Config2__ClassificationHierarchy__c  mainCategory = [SELECT id FROM Apttus_Config2__ClassificationHierarchy__c  WHERE Name = 'Digital Configurator'];
    APTSECOM_Store__c store = DCTestData.createStore('Test Store', mainCategory.id);
    }

    @isTest
    public static void updatePricesOnStoreTestSuccess(){
        APTSECOM_Store__c store = [SELECT id FROM APTSECOM_Store__c WHERE Name = 'Test Store'];
        Test.startTest();
        String output = Ecom_ProductService.updatePricesOnStore(store.id);
        System.assertEquals('updated successfully',output);
        System.debug('!!!!!Webservice Returned!!!!!!'+output);
        Test.stopTest();
    }
    
    @isTest
    public static void updatePricesOnStoreTestError(){
        APTSECOM_Store__c store = [SELECT id, APTSECOM_Category_Hierarchy__c FROM APTSECOM_Store__c WHERE Name = 'Test Store'];
        store.APTSECOM_Category_Hierarchy__c = null;
        update store;
        Test.startTest();
        String output = Ecom_ProductService.updatePricesOnStore(store.id);
        System.assertEquals('Please check the errors or contact admin',output);
        System.debug('!!!!!Webservice Returned!!!!!!'+output);
        Test.stopTest();
    }    
    
    @isTest
    public static void updatePricesOnStoreTestNoProduct(){
        APTSECOM_Store__c store = new APTSECOM_Store__c();
        store.name = 'Store';
        store.APTSECOM_Store_Title__c = 'Store';
        store.APTSECOM_Max_No_Of_PerSeatUsers__c = 10;
        store.APTSECOM_Adjustment_Amount__c = 1;
        store.APTSECOM_Adjustment_Type__c = '% Discount';
        store.APTSECOM_Max_No_Of_Attorneys__c = 5;
        store.APTSECOM_Customer_Pricing_Segment__c = 'Law Firm';
        insert store;      
        store.APTSECOM_Category_Hierarchy__c = 'a5813000000YHoQAAW';
        update store;
        Test.startTest();
        String output = Ecom_ProductService.updatePricesOnStore(store.id);
        System.assertEquals('Nothing to update since Products are not associated with store',output);
        System.debug('!!!!!Webservice Returned!!!!!!'+output);
        Test.stopTest();
    }
        
    @isTest
    public static void getDiscountedPriceTest(){
        Test.startTest();
        Ecom_ProductService prodservice = new Ecom_ProductService();
        Decimal discount = prodservice.getDiscountedPrice(1.0);
        System.debug('!!!!!Discount Returned!!!!!' + discount);
        Test.stopTest();
    }
    
    @isTest
    public static void updateLeastPriceByCatStateTest(){
        String state = 'State';
        String cat = 'Cat';
        Ecom_StoreResponse.PriceMatrix matrix = new Ecom_StoreResponse.PriceMatrix();
        matrix.quantity = 1;
        matrix.amount = 1;
        Map<String, Decimal> mapstrdec = new Map<String, Decimal>();
        mapstrdec.put(state,1.0);
        Map<Integer, Map<String,Decimal>> mapintmap = new Map<Integer, Map<String,Decimal>>();
        mapintmap.put(1,mapstrdec);
        Map<String, Map<Integer,Map<String,Decimal>>> mapstringmap = new Map<String, Map<Integer,Map<String,Decimal>>>();
        mapstringmap.put(cat,mapintmap);
        
        Test.startTest();
        /*Ecom_ProductService.updateLeastPriceListParameter Parameter = New Ecom_ProductService.updateLeastPriceListParameter();
                            Parameter.state = state;
                            Parameter.cat = cat;
                            Parameter.leastPriceByCatState = mapstringmap;
                            Parameter.matrix = matrix;
                            Ecom_ProductService.updateLeastPriceByCatState(Parameter); */
        Ecom_ProductService.updateLeastPriceByCatState(state, cat, mapstringmap, matrix);
        Test.stopTest();

    }


}