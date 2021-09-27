/* Class: DCPNewSalesYoYTest
* Purpose: Test class for DCPNewSalesDataUtil, DCPNewSalesPlanUtility, DCPNewSalesStoreUtility and DCPNewSalesYoYUtil
* Created: 5/18/2021
*/
@IsTest
public class DCPNewSalesYoYTest {
    
    /** 
    * @description : class properties
    */
    private static List<Product2> prodList;
    private static List<Apttus_Config2__PriceMatrixEntry__c> priceMatrixEntryList;
    private static Set<Id> prodIds = new Set<Id>();
    
    /** 
    * @description : initializing the properties
    */
    static {
        loadData();
    }
    
    /** 
    * @description : Prepare test data
    */
    @TestSetup private static void setup(){
        
        String segment='Law Firm';
        LIST < Static_Values__c > staticCSList = new LIST < Static_Values__c > {
            new Static_Values__c(name = 'NewSaleSellableFlag', value__c = 'Display and Sell'),  new Static_Values__c(name = 'OrderProcessSupportEmail', value__c = 'APP-CX-DIGITAL@thomson.com')
           
        };
        insert staticCSList;
        
        Product2 prod = DCPNewSaleUtilityCls.createProduct('42076533');
        Insert prod;
        
        Product2 prod1 = DCPNewSaleUtilityCls.createProduct('42004986');
        Insert prod1;
        
        Apttus_Config2__PriceList__c pl = DCPNewSaleUtilityCls.createPriceList('Thomson Reuters Master - US Legal');
        Insert pl;
        
        Apttus_Config2__PriceListItem__c pli = DCPNewSaleUtilityCls.createPLI(pl.id,prod.id);
        Insert pli;
        
        Apttus_Config2__PriceListItem__c pli1 = DCPNewSaleUtilityCls.createPLI(pl.id,prod1.id);
        Insert pli1;
        
        Apttus_Config2__PriceDimension__c pd = DCPNewSaleUtilityCls.createPD('Apttus_Config2__Quantity__c');
        Insert pd;
        
        Apttus_Config2__PriceDimension__c pd1 = DCPNewSaleUtilityCls.createPD('Customer_Pricing_Segment__c');
        Insert pd1;
        
        Apttus_Config2__PriceMatrix__c pm = DCPNewSaleUtilityCls.createPM(pd.id,pd1.id,pli.id);
        Insert pm;
        
        Apttus_Config2__PriceMatrix__c pm1 = DCPNewSaleUtilityCls.createPM(pd.id,pd1.id,pli1.id);
        Insert pm1;
        
        Apttus_Config2__PriceMatrixEntry__c pme = DCPNewSaleUtilityCls.createPME(pm.id,segment);
        Insert pme;
        
        Apttus_Config2__PriceMatrixEntry__c pme1 = DCPNewSaleUtilityCls.createPME(pm.id,segment);
        Insert pme1;
        
        Apttus_Config2__PriceMatrixEntry__c pme2 = DCPNewSaleUtilityCls.createPME(pm1.id,segment);
        Insert pme2;
        
        APTSECOM_Store__c store = new APTSECOM_Store__c(Name='Westlaw Classic',APTSECOM_Customer_Pricing_Segment__c='Law Firm',
                                                       APTSECOM_Default_Contract_Term__c='3 Years',Type__c='New Sales',
                                                        APTSECOM_Max_No_Of_Attorneys__c=5);
        insert store;
        
        Apttus_Config2__ProductGroup__c plan = new Apttus_Config2__ProductGroup__c(Name = 'Good');
        insert plan;

        Apttus_Config2__ProductGroupMember__c member = new Apttus_Config2__ProductGroupMember__c(Apttus_Config2__Sequence__c=1,
                                                                                                Apttus_Config2__ProductId__c=prod.Id,
                                                                                                Apttus_Config2__ProductGroupId__c=plan.Id);
        
        insert member;
        
        Apttus_Config2__ProductGroupMember__c member1 = new Apttus_Config2__ProductGroupMember__c(Apttus_Config2__Sequence__c=2,
                                                                                                Apttus_Config2__ProductId__c=prod1.Id,
                                                                                                Apttus_Config2__ProductGroupId__c=plan.Id);
        
        insert member1;
        
        New_Sales_Contract_Term_Setting__c nseTerm = new New_Sales_Contract_Term_Setting__c(Related_Store__c=store.Id,Plan__c=plan.Id,Adjustment_Type__c='% Markup',
                                                                                           Adjustment_Amount__c=10.0,Contract_Term__c='1 Year',YoY_1__c=7,YoY_2__c=7);
        insert nseTerm;
        New_Sales_Contract_Term_Setting__c nseTerm1 = new New_Sales_Contract_Term_Setting__c(Related_Store__c=store.Id,Plan__c=plan.Id,Adjustment_Type__c='% Discount',
                                                                                           Adjustment_Amount__c=20.0,Contract_Term__c='2 Years',YoY_1__c=6,YoY_2__c=6);
        
        Insert nseTerm1;
    }
    
    /** 
    * @description : Testing the logic
    */
    @IsTest private static void testYoY(){
        Test.startTest();
       DCPNewSalesDataUtil wrap;
       wrap = new DCPNewSalesDataUtil();
       DCPNewSalesYoYUtil.YoYRequestWrapper youWrap = new DCPNewSalesYoYUtil.YoYRequestWrapper();
        prodIds.add(prodList[0].Id);
        prodIds.add(prodList[1].Id);
        youWrap.productIds = prodIds;
        youWrap.storeName = 'Westlaw Classic';
        youWrap.storeType = 'New Sales';
        youWrap.customerSegment = 'Law Firm';
        system.assert(youWrap.customerSegment!=null, 'Law Firm');
        List<DCPNewSalesYoYUtil.PriceMatrix> priceMatrixList = new List<DCPNewSalesYoYUtil.PriceMatrix>();
        DCPNewSalesYoYUtil yoy = new DCPNewSalesYoYUtil();
        DCPNewSalesStoreUtility.StoreWrapper storeData = DCPNewSalesStoreUtility.getStoreDetails(youWrap.StoreName, youWrap.customerSegment, youWrap.storeType);
        yoy.termWrapper = DCPNewSalesPlanUtility.getContractPlans(storeData, youWrap.productIds);
        for(Apttus_Config2__PriceMatrixEntry__c entry : priceMatrixEntryList){
               yoy.getYoyMatrixData(entry.Apttus_Config2__PriceMatrixId__r.Apttus_Config2__PriceListItemId__r.Apttus_Config2__ProductId__c, entry, priceMatrixList);
            }
    Map<String,String> errorHandlerMap = new Map<String,String>{'objectName'=>'Product Configuration','expMsg'=>'abc','webServiceName'=>'PromotionAPI','requestType'=>'Promotion Service: Manual/Auto Promotion','reqMsg'=>'Exception Class Name: TRStore_PromotionService','module'=>'UEStore','recId'=>'','supportEmail'=>'abc@sample.com','toSupport'=>'false'};
        DCPNewSalesPlanUtility.logExceptions(errorHandlerMap);
        Test.stopTest();
    }
    
    /** 
    * @description : Fetcing the data for class properties
    */
    private static void loadData(){
        if(prodList == null){
            prodList = [Select Id, productCode from product2];
        }
        if(PriceMatrixEntryList == null){
          priceMatrixEntryList  = [SELECT Id,Apttus_Config2__Sequence__c, Apttus_Config2__PriceMatrixId__r.Apttus_Config2__PriceListItemId__c,
                                                             Apttus_Config2__PriceMatrixId__r.Apttus_Config2__PriceListItemId__r.Apttus_Config2__PriceListId__c,
                                                             Apttus_Config2__PriceMatrixId__r.Apttus_Config2__PriceListItemId__r.CurrencyIsoCode,
                                                             Apttus_Config2__PriceMatrixId__r.Apttus_Config2__PriceListItemId__r.Apttus_Config2__ProductId__c,
                                                             Apttus_Config2__PriceMatrixId__r.Apttus_Config2__PriceListItemId__r.Apttus_Config2__Frequency__c,
                                                             Apttus_Config2__PriceMatrixId__r.Apttus_Config2__PriceListItemId__r.Apttus_Config2__ProductId__r.productCode,Apttus_Config2__Dimension1Value__c, 
                                                             Apttus_Config2__Dimension2Value__c, Apttus_Config2__AdjustmentAmount__c,Apttus_Config2__AdjustmentType__c 
                                                             FROM Apttus_Config2__PriceMatrixEntry__c];
                                                             //WHERE Apttus_Config2__PriceMatrixId__r.Apttus_Config2__PriceListItemId__r.Apttus_Config2__ProductId__c in :prodIds  
                                                             //AND Apttus_Config2__Dimension2Value__c ='Law Firm' 
                                                             //AND Apttus_Config2__Dimension1Value__c IN ('1','2','3') order by Id DESC];
        }
    }
    
    /** 
    * @description : Testing the logic
    */
    @IsTest private static void testNegativeYoY(){
        DCPNewSalesStoreUtility.StoreWrapper sw = new DCPNewSalesStoreUtility.StoreWrapper();
        DCPNewSalesPlanUtility.getContractPlans(sw,null);
        system.assert(sw!=null, 'Negative Check');
    }
    
    
}