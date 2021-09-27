@isTest
public class DCCartServiceV2_Test {

    @testSetup static void setupData(){
        DCTestData.createData();
        Test.startTest();
        DCTestData.createQuote();      
        Test.stopTest();
        DCTestData.createProductPlan(DCTestData.productId,'42009567', '42009617');
        DCTestData.createPriceListItem(DCTestData.pBookId,DCTestData.productId);
        DCTestData.createPriceMatix(DCTestData.priceListItemid);
        DCTestData.createPriceMatrixEntry(DCTestData.priceMatrixid, '1');
        DCTestData.createDigitalSubscriptions('40974108','42009614', 'Best Value+Config', '1004284494', System.Today().addDays(integer.valueof(label.Digital_Max_Asset_Days.trim())), '00237KI');
        Apttus_Config2__ProductConfiguration__c cart = [select id from Apttus_Config2__ProductConfiguration__c Limit 1];
        cart.APTS_SSD_bill_to__c = DCTestData.accssdid;
        update cart;
        /*
        Product2 product = DCTestData.createProduct('SL Louisiana Analytical (Westlaw PRO™)', '42009566', '42009619');
        product.APTS_Product_Pricing_Model__c = 'Banded';
        update product;
        
        Product2 productRec = DCTestData.createProduct('Essentials Library — Florida (Westlaw PRO™)','40982845','40974107');
        productRec.APTS_Product_Pricing_Model__c = 'Banded';
        update productRec;
        */
        List<Online_Contacts__c> olcList = DCTestData.createOnline(DCTestData.bQuoteId,DCTestData.accountId);
        
        List<Online_Contacts__c> olcList1 = DCTestData.createOnline(DCTestData.cQuoteId,DCTestData.accountId);
        olcList1[0].Material__c = '42009566';
        olcList1[1].Material__c = '42009566';
        update olcList;
        
        //Apttus_Config2__SummaryGroup__c summary = DCTestData.createSummaryGroup(DCTestData.bCartId,'Test Summary');
        
        Apttus_Config2__AdHocGroup__c adhoc = new Apttus_Config2__AdHocGroup__c();
        adhoc.Apttus_Config2__ConfigurationId__c = DCTestData.bCartId;
        insert adhoc;
        
        //Apttus_Config2__SummaryGroup__c summary1 = DCTestData.createSummaryGroup(DCTestData.cCartId,'Test Summary');
        
        Apttus_Config2__AdHocGroup__c adhoc1 = new Apttus_Config2__AdHocGroup__c();
        adhoc1.Apttus_Config2__ConfigurationId__c = DCTestData.cCartId;
        insert adhoc1;
        
    }
    
    public static testmethod void addToCartTest(){
        Test.startTest();
        Product2 prodRec = DCTestData.createProduct('SL Louisiana Analytical (Westlaw PRO™)', '42009566', '41409998');
        
        /*prodRec.APTS_Product_Pricing_Model__c = 'Banded';
        //update prodRec;
        //List<String> prodNameList = new List<String>{'SL California Analytical (Westlaw PRO™)','SL Louisiana Analytical (Westlaw PRO™)'};
        //List<Product2> testProductList = [select id from Product2 where Name IN : prodNameList];
        */
        Product2 testProduct2 = [select id from Product2 where Name = 'SL California Analytical (Westlaw PRO™)' limit 1];
        testProduct2.APTS_Product_Pricing_Model__c = 'Banded';
        update testProduct2;
        
        List<String> products = new List<String>{prodRec.id};
        Apttus_Proposal__Proposal__c cQuoteRec = [select id from Apttus_Proposal__Proposal__c where Apttus_Proposal__Proposal_Name__c = 'Quote 1' AND Digital_Quote_Type__c = 'Best Value+Config' limit 1];
        
        Apttus_Proposal__Proposal__c bQuoteRec = [select id from Apttus_Proposal__Proposal__c where Apttus_Proposal__Proposal_Name__c = 'Quote 1' AND Digital_Quote_Type__c = 'Best Value' limit 1];
        
        
        DCMessage response;
        try{
            response = DCCartServiceV2.addToCart(products,'2 Years',3,cQuoteRec.Id,bQuoteRec.Id);
        }catch(Exception ex){
            system.debug('Exceptons '+ex.getMessage());
        }
        
        System.assertEquals(response.code,200);
        Test.stopTest();
    }
    
    public static testmethod void repriceByQuoteIdTest(){
        Test.startTest();
        Apttus_Proposal__Proposal__c cQuoteRec = [select id from Apttus_Proposal__Proposal__c where Apttus_Proposal__Proposal_Name__c = 'Quote 1' AND Digital_Quote_Type__c = 'Best Value+Config' limit 1];
        DCMessage response;
        try{
            response = DCCartServiceV2.repriceByQuoteId(cQuoteRec.Id);  
        }catch(Exception ex){
            system.debug('Exceptons '+ex.getMessage());
        }
        System.assertEquals(response.code,200);
        Test.stopTest();
    }
    
    public static testmethod void trackLogTest(){
        Test.startTest();
        DCMessage response;
        try{
            Decimal m = 10/0;
        }catch(Exception e){
            DCCartServiceV2.trackLog(e,'DCCartService','trackLog');
        }
        Digital_Exception_Log__c logRec = [select id, name, Exception_Message__c, Class_Reference__c from Digital_Exception_Log__c where Class_Reference__c like '%DCCartService%'limit 1];
        test.stopTest();
        System.assertNotEquals(logRec,null);
    }
    
    public static testmethod void cloneTest(){
       Apttus_Proposal__Proposal__c cQuoteRec = [select id from Apttus_Proposal__Proposal__c where Apttus_Proposal__Proposal_Name__c = 'Quote 1' AND Digital_Quote_Type__c = 'Best Value+Config' limit 1];
        
        Apttus_Proposal__Proposal__c bQuoteRec = [select id from Apttus_Proposal__Proposal__c where Apttus_Proposal__Proposal_Name__c = 'Quote 1' AND Digital_Quote_Type__c = 'Best Value' limit 1];
        
        Test.startTest();
        Boolean isReset;
        try{
            isReset = DCCartServiceV2.resetQuote(cQuoteRec.Id,bQuoteRec.Id);
        }catch(Exception ex){
            system.debug('Exceptons '+ex.getMessage());
        }
        
        Test.stopTest();
        System.assertNotEquals(isReset,true);
        
    } 

    public static testmethod void resetQuotes(){
        Apttus_Proposal__Proposal__c cQuoteRec = [select id from Apttus_Proposal__Proposal__c where Apttus_Proposal__Proposal_Name__c = 'Quote 1' AND Digital_Quote_Type__c = 'Best Value+Config' limit 1];
        
        Apttus_Proposal__Proposal__c bQuoteRec = [select id from Apttus_Proposal__Proposal__c where Apttus_Proposal__Proposal_Name__c = 'Quote 1' AND Digital_Quote_Type__c = 'Best Value' limit 1];
        
        Test.startTest();
        DCQuoteUpdate.QuoteUpdateResponse response;
        try{
            response = DCConfigResetService.configreprice(cQuoteRec.Id,bQuoteRec.Id);
        }catch(Exception ex){
            system.debug('Exceptons '+ex.getMessage());
        }
        Test.stopTest();
        System.assertNotEquals(response,null);
        
        
    }
    
}