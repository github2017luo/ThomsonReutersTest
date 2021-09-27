@isTest
public class DCConfiguratorUpdateService_Test {
  @testSetup static void setupData(){
        DCTestData.createData();
        Test.startTest();
        DCTestData.createQuote();      
        Test.stopTest();
        DCTestData.createProductPlan(DCTestData.productId,'42009567', '42009617');
        DCTestData.createPriceListItem(DCTestData.pBookId,DCTestData.productId);
        DCTestData.createPriceMatix(DCTestData.priceListItemid);
        DCTestData.createPriceMatrixEntry(DCTestData.priceMatrixid, '1');
        List<Online_Contacts__c> olcList = DCTestData.createOnline(DCTestData.bQuoteId,DCTestData.accountId);
        
        List<Online_Contacts__c> olcList1 = DCTestData.createOnline(DCTestData.cQuoteId,DCTestData.accountId);
        olcList1[0].Material__c = '42009566';
        olcList1[1].Material__c = '42009566';
        update olcList;
         List<Product_Account_Detail__c> listOfPad = new List<Product_Account_Detail__c>();
        Product_Account_Detail__c pad= new Product_Account_Detail__c(
            ZP_Cust_Number__c = '1004284494',
            Campaign_Code__c = 'ABCDEF',
            Renewal_Date__c = Date.today().addDays(90),
            Type__c = 'Straight',
            Current_Subscription__c = '42009617',
            Actual_New_Service__c = '40974107',
            Digital_Firm__c = 'Small Law',
            Current_Term_Length__c = 1);
        Product_Account_Detail__c pad1= new Product_Account_Detail__c(
            ZP_Cust_Number__c = '1004284494',
            Campaign_Code__c = 'ABCDEF',
            Renewal_Date__c = Date.today().addDays(90),
            Type__c = 'Plus',
            Add_on_Type__c ='Plus',
            Contract_Type__c ='New Mid Contract',
            Add_On_Sub__c = '42005016',
            Add_On_Svc__c = '42005003',
            Current_Subscription__c = '42009617',
            Actual_New_Service__c = '40974107',
            Digital_Firm__c = 'Small Law',
            Current_Term_Length__c = 1);
        listOfPad.add(pad);
        listOfPad.add(pad1);
        insert listOfPad;
        Apttus_Config2__SummaryGroup__c summary = DCTestData.createSummaryGroup(DCTestData.bCartId,'Test Summary');
        
        Apttus_Config2__AdHocGroup__c adhoc = new Apttus_Config2__AdHocGroup__c();
        adhoc.Apttus_Config2__ConfigurationId__c = DCTestData.bCartId;
        insert adhoc;
        
        Apttus_Config2__SummaryGroup__c summary1 = DCTestData.createSummaryGroup(DCTestData.cCartId,'Test Summary');
        
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
        
        
        DCConfigdetails response;
        try{
            response = DCConfiguratorUpdateService.configupdation(products,'2 Years',3,cQuoteRec.Id,bQuoteRec.Id);
           
        }catch(Exception ex){
            system.debug('Exceptons '+ex.getMessage());
        }
        
        //System.assertEquals(response.responseCode,200);
        Test.stopTest();
    }
    
    public static testmethod void addToCartTestNullvalue(){
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
        
        
        DCConfigdetails response;
        try{
            response  = DCConfiguratorUpdateService.configupdation(products,'2 Years',3,null,null);
            
        }catch(Exception ex){
            system.debug('Exceptons '+ex.getMessage());
        }
        
        System.assertEquals(response.responseCode,400);
        Test.stopTest();
    }
    
    public static testmethod void repriceByQuoteIdTest(){
        Test.startTest();
        Apttus_Proposal__Proposal__c cQuoteRec = [select id from Apttus_Proposal__Proposal__c where Apttus_Proposal__Proposal_Name__c = 'Quote 1' AND Digital_Quote_Type__c = 'Best Value+Config' limit 1];
        Apttus_Proposal__Proposal__c bQuoteRec = [select id from Apttus_Proposal__Proposal__c where Apttus_Proposal__Proposal_Name__c = 'Quote 1' AND Digital_Quote_Type__c = 'Best Value' limit 1];
        DCConfigdetails response;
        try{
            response = DCConfigRepriceCart.configreprice(cQuoteRec.id, bQuoteRec.id);
           
        }catch(Exception ex){
            system.debug('Exceptons '+ex.getMessage());
        }
        System.assertEquals(response.responseCode,200);
        Test.stopTest();
    }
    public static testmethod void repriceByQuoteIdTestNull(){
        Test.startTest();
        Apttus_Proposal__Proposal__c cQuoteRec = [select id from Apttus_Proposal__Proposal__c where Apttus_Proposal__Proposal_Name__c = 'Quote 1' AND Digital_Quote_Type__c = 'Best Value+Config' limit 1];
        Apttus_Proposal__Proposal__c bQuoteRec = [select id from Apttus_Proposal__Proposal__c where Apttus_Proposal__Proposal_Name__c = 'Quote 1' AND Digital_Quote_Type__c = 'Best Value' limit 1];
        DCConfigdetails response;
        try{
            response = DCConfigRepriceCart.configreprice(null, bQuoteRec.id);
           
        }catch(Exception ex){
            system.debug('Exceptons '+ex.getMessage());
        }
        System.assertEquals(response.responseCode,400);
        Test.stopTest();
    }
    
    public static testmethod void cloneTest(){
       Apttus_Proposal__Proposal__c cQuoteRec = [select id from Apttus_Proposal__Proposal__c where Apttus_Proposal__Proposal_Name__c = 'Quote 1' AND Digital_Quote_Type__c = 'Best Value+Config' limit 1];
        
        Apttus_Proposal__Proposal__c bQuoteRec = [select id from Apttus_Proposal__Proposal__c where Apttus_Proposal__Proposal_Name__c = 'Quote 1' AND Digital_Quote_Type__c = 'Best Value' limit 1];
        
        Test.startTest();
        DCQuoteUpdate.QuoteUpdateResponse resp;
        try{
            resp = DCConfigResetService.configreprice(cQuoteRec.Id,bQuoteRec.Id);
        }catch(Exception ex){
            system.debug('Exceptons '+ex.getMessage());
        }
        
        Test.stopTest();
        System.assertEquals(resp.responseCode,200);
        
    } 
    public static testmethod void cloneTestNull(){
       Apttus_Proposal__Proposal__c cQuoteRec = [select id from Apttus_Proposal__Proposal__c where Apttus_Proposal__Proposal_Name__c = 'Quote 1' AND Digital_Quote_Type__c = 'Best Value+Config' limit 1];
        
        Apttus_Proposal__Proposal__c bQuoteRec = [select id from Apttus_Proposal__Proposal__c where Apttus_Proposal__Proposal_Name__c = 'Quote 1' AND Digital_Quote_Type__c = 'Best Value' limit 1];
        
        Test.startTest();
        DCQuoteUpdate.QuoteUpdateResponse resp;
        try{
            resp = DCConfigResetService.configreprice(cQuoteRec.Id,null);
        }catch(Exception ex){
            system.debug('Exceptons '+ex.getMessage());
        }
        
        Test.stopTest();
        System.assertEquals(resp.responseCode,400);
        
    } 
    public static testmethod void trackLogTest(){
        Product2 prodRec = DCTestData.createProduct('SL Louisiana Analytical (Westlaw PRO™)', '42009566', '41409998');
        
        Product2 testProduct2 = [select id from Product2 where Name = 'SL California Analytical (Westlaw PRO™)' limit 1];
        testProduct2.APTS_Product_Pricing_Model__c = 'Banded';
        update testProduct2;
        
        List<String> products = new List<String>{prodRec.id,testProduct2.id};
        Apttus_Proposal__Proposal__c cQuoteRec = [select id from Apttus_Proposal__Proposal__c where Apttus_Proposal__Proposal_Name__c = 'Quote 1' AND Digital_Quote_Type__c = 'Best Value+config' limit 1];
        
        Apttus_Proposal__Proposal__c bQuoteRec = [select id from Apttus_Proposal__Proposal__c where Apttus_Proposal__Proposal_Name__c = 'Quote 1' AND Digital_Quote_Type__c = 'Best Value' limit 1];
        
        Test.startTest();
        list<Apttus_Config2__ProductConfiguration__c> prdclst = [select Apttus_Config2__Status__c from Apttus_Config2__ProductConfiguration__c where Apttus_QPConfig__Proposald__c =: cQuoteRec.id];
        for(Apttus_Config2__ProductConfiguration__c prdc: prdclst){
            prdc.Apttus_Config2__Status__c = 'New';
        }
        update prdclst;
        DCConfigdetails response;
        try{
            Decimal m = 10/0;
        }catch(Exception e){
            Integer f = -100;
            //response = DCConfiguratorUpdateService.configupdation(products,'2 Years',3,cQuoteRec.Id,bQuoteRec.Id);
            //DCConfigRepriceCart.configreprice(cQuoteRec.Id,bQuoteRec.Id);
            //DCConfigResetService.configreprice(cQuoteRec.Id,bQuoteRec.Id);
        }
        //Digital_Exception_Log__c logRec = [select id, name, Exception_Message__c, Class_Reference__c from Digital_Exception_Log__c where Class_Reference__c like 'DCConfig%'limit 1];
        test.stopTest();
        //System.assertNotEquals(response.responseCode,400);
    }
    
}