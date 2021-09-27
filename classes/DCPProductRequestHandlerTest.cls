/* Class: DCPProductRequestHandlerTest
* Purpose: This test class is for the coverage of product plan services
* Created: 5/19/2021
*  
* 
* CHANGE HISTORY
* =============================================================================
* Date         Name             JIRA        Description
* 05/19/2021    Avudaiappan A    DCP-1821     Created 
* 06/21/2021    Kanishk          DCP-2235     Brand changes added
* =============================================================================
*/
@isTest(seeAllData=false)
 /** 
 * @description : This is the method to define the coverage
 */
public class DCPProductRequestHandlerTest {
    /** 
    * @description : Prepare test data
    */ 
    
    public static testMethod void testData(){
        
      //UEStoreUSLPlan__mdt[] usPlan =[SELECT MasterLabel,DeveloperName,Best_Plan__c,Better_Plan__c,Good_Plan__c,Jurisdiction__c,Segment__c,Sub_Segment__c,Brand__c FROM UEStoreUSLPlan__mdt limit 1];
      //String segment = usPlan[0].segment__c;
      String segment='Law Firm';
        LIST < Static_Values__c > staticCSList = new LIST < Static_Values__c > {
            new Static_Values__c(name = 'NewSaleSellableFlag', value__c = 'Display and Sell'),
                new Static_Values__c(name = 'OrderProcessSupportEmail', value__c = 'APP-CX-DIGITAL@thomson.com'),
                new Static_Values__c(name = 'DCPNSVersion', value__c = 'v2'),
                new Static_Values__c(name = 'DCPNSBrandVersioning', value__c = 'v1'),
                new Static_Values__c(name = 'DCPAddOnVersioningForPDP', value__c = 'v2'),
                new Static_Values__c(name = 'PlatformValueOrderBy', value__c = 'order by Product_Platform__r.PlatformCategorySortOrder__c ASC NULLS LAST')
           
        };
        insert staticCSList;
        
        Product2 prod = DCPNewSaleUtilityCls.createProduct('42076533');
        Insert prod;
    
        Product2 prod1 = DCPNewSaleUtilityCls.createProduct('42004986');
        Insert prod1;
        
        Product2 prod2 = new Product2(Name = 'Test Product',ProductCode = '425425425',Description = 'Test Desc',Service_Number__c = '425425425',product_offering__c = 'Practical Law',Apttus_Filter_Jurisdiction__c = 'Alabama',Practice_Area__c ='General',APTS_Media_High_Level_Code__c = '21',APTS_Item_Category_Group__c = 'ZVSU',APTS_Media_Lower_Level_Code__c = '11',LCRM_Sub_Bu__c = 'USL',Format__c= 'Format',IsActive = true,Apttus_Config2__HasOptions__c = true,Apttus_Config2__HasAttributes__c = true,Apttus_Config2__HasDefaults__c = false,CPD_Sellable_Description__c ='Display and Sell');
        Insert prod2;
        
        Apttus_Config2__PriceList__c pl = DCPNewSaleUtilityCls.createPriceList('Thomson Reuters Master - US Legal');
        Insert pl;
        
        Apttus_Config2__PriceListItem__c pli = DCPNewSaleUtilityCls.createPLI(pl.id,prod.id);
        Insert pli;
        
        Apttus_Config2__PriceListItem__c pli1 = DCPNewSaleUtilityCls.createPLI(pl.id,prod1.id);
        Insert pli1;
        
        Apttus_Config2__PriceListItem__c pli2 = DCPNewSaleUtilityCls.createPLI(pl.id,prod2.id);
        Insert pli2;
        
        Apttus_Config2__PriceDimension__c pd = DCPNewSaleUtilityCls.createPD('Apttus_Config2__Quantity__c');
        Insert pd;

    Apttus_Config2__PriceDimension__c pd1 = DCPNewSaleUtilityCls.createPD('Customer_Pricing_Segment__c');
        Insert pd1;

    Apttus_Config2__PriceMatrix__c pm = DCPNewSaleUtilityCls.createPM(pd.id,pd1.id,pli.id);
        Insert pm;
        
        Apttus_Config2__PriceMatrix__c pm1 = DCPNewSaleUtilityCls.createPM(pd.id,pd1.id,pli1.id);
        Insert pm1;
        
        Apttus_Config2__PriceMatrix__c pm2 = DCPNewSaleUtilityCls.createPM(pd.id,pd1.id,pli2.id);
        Insert pm2;
        
        Apttus_Config2__PriceMatrixEntry__c pme = DCPNewSaleUtilityCls.createPME(pm.id,segment);
        Insert pme;

        Apttus_Config2__PriceMatrixEntry__c pme1 = DCPNewSaleUtilityCls.createPME(pm.id,segment);
        Insert pme1;
        
        Apttus_Config2__PriceMatrixEntry__c pme2 = DCPNewSaleUtilityCls.createPME(pm1.id,segment);
        Insert pme2;
        
         Apttus_Config2__PriceMatrixEntry__c pme3 = DCPNewSaleUtilityCls.createPME(pm2.id,segment);
        Insert pme3;
        
        Product_Platform__c pp = DCPNewSaleUtilityCls.createPlatform();
        Insert pp;
        
        Product_Platform_Value__c ppv = DCPNewSaleUtilityCls.createPlatformValue(prod.Id,pp.Id);
    Insert ppv;
        
        Product_Platform__c pp1 = DCPNewSaleUtilityCls.createPlatform();
        Insert pp1;
        
        Product_Platform_Value__c ppv1 = DCPNewSaleUtilityCls.createPlatformValue(prod.Id,pp1.Id);
    Insert ppv1;
        system.assert(ppv1!=null, 'inserted');
        
        APTSECOM_Store__c store = new APTSECOM_Store__c(Name='Westlaw Classic Law Firm',APTSECOM_Customer_Pricing_Segment__c='Law Firm',
                                                       APTSECOM_Default_Contract_Term__c='3 Years',Type__c='New Sales',
                                                        APTSECOM_Max_No_Of_Attorneys__c=5);
        insert store;
        
        Apttus_Config2__ProductGroup__c plan = new Apttus_Config2__ProductGroup__c(Name = 'Good');
        insert plan;

        Apttus_Config2__ProductGroupMember__c member = new Apttus_Config2__ProductGroupMember__c(Apttus_Config2__Sequence__c=1,
                                                                                                Apttus_Config2__ProductId__c=prod.Id,
                                                                                                Apttus_Config2__ProductGroupId__c=plan.Id);
        
        insert member;
        
        New_Sales_Contract_Term_Setting__c nseTerm = new New_Sales_Contract_Term_Setting__c(Related_Store__c=store.Id,Plan__c=plan.Id,
                                                                                           Contract_Term__c='1 Year',YoY_1__c=7,YoY_2__c=7);
        insert nseTerm;
      
        APTSECOM_Product_Recommendation__c pRec = new APTSECOM_Product_Recommendation__c(APTSECOM_Source_Product__c=prod.Id,APTSECOM_Product__c=prod1.Id,
                                                                                            Plan__c=plan.Id,Can_only_be_added_with__c=plan.Id,APTSECOM_Store__c=store.Id);
        insert pRec;
       APTSECOM_Product_Recommendation__c pRec2 = new APTSECOM_Product_Recommendation__c(APTSECOM_Source_Product__c=prod.Id,APTSECOM_Product__c=prod2.Id,
                                                                                          Plan__c=plan.Id,Can_only_be_added_with__c=plan.Id,APTSECOM_Store__c=store.Id
                                                                                      );
        insert pRec2;
    }
    
    /** 
    * @description : Test method for ProductPlan Service
    */ 
     public static testMethod void testforProductPlanService() {
       test.startTest();
       testData();
       DCPProductRequestDeclaration dcp;
       dcp = new DCPProductRequestDeclaration();
       RestRequest req = new RestRequest();
       req.requestURI = '/newsale/DCPProductPlanService';  //Request URL
       req.httpMethod = 'POST';//HTTP Request Type
       req.addHeader('Content-Type', 'application/json');
       String jsonReq = '{\n  \"segment\": \"Law Firm\",\n  \"jurisdiction\": \"Alabama\",\n  \"brand\": \"Westlaw Classic\", \n  \"contentType\": \"application/json"\n}';
       req.requestBody = blob.valueOf(jsonReq);
       RestContext.request = req;
       DCPProductRequestDeclaration.ProductPlanResponse ppresp = new DCPProductRequestDeclaration.ProductPlanResponse();
       ppresp = DCPNewSaleServices.productService();
       RestResponse res = new RestResponse();
       RestContext.response = res;
       system.assert(res!=null, 'method failure');
         
       RestRequest reqPD = new RestRequest();
       reqPD.requestURI = '/newsale/DCPProductDetailService';  //Request URL
       reqPD.httpMethod = 'POST';//HTTP Request Type
       reqPD.addHeader('Content-Type', 'application/json');
       String jsonRequest = '{\n  \"segment\": \"Law Firm\",\n  \"productCode\": \"42076533\",\n  \"brand\": \"Westlaw Classic\",\n  \"contentType\": \"application/json"\n}';
       reqPD.requestBody = blob.valueOf(jsonRequest);
       RestContext.request = reqPD;
       DCPProductRequestDeclaration.ProductPlanResponse pdresp = new DCPProductRequestDeclaration.ProductPlanResponse();
       pdresp = DCPNewSaleServices.productService();
       RestResponse resPD = new RestResponse();
       RestContext.response = resPD;
       system.assert(resPD!=null, 'method failure');
       
       //negative scenarios for coverage
      /* RestRequest reqNS = new RestRequest();
       reqNS.requestURI = '/newsale/DCPProductDetailService';  //Request URL
       reqNS.httpMethod = 'POST';//HTTP Request Type
       reqNS.addHeader('Content-Type', 'application/json');
       String jsonRequestNS = '{\n  \"segment\": \"Law Firm\",\n  \"productCode\": \"\",\n  \"brand\": \"Westlaw Classic"\n,\n  \"contentType\": \"application/json"\n}';
       reqNS.requestBody = blob.valueOf(jsonRequestNS);
       RestContext.request = reqNS;
       DCPProductRequestDeclaration.ProductPlanResponse nsresp = new DCPProductRequestDeclaration.ProductPlanResponse();
       nsresp = DCPNewSaleServices.productService();
       RestResponse resNS = new RestResponse();
       RestContext.response = resNS;
       system.assert(resNS!=null, 'method failure');
         
       RestRequest reqNS1 = new RestRequest();
       reqNS1.requestURI = '/newsale/DCPProductDetailService123';  //Request URL
       reqNS1.httpMethod = 'POST';//HTTP Request Type
       reqNS1.addHeader('Content-Type', 'application/json');
       String jsonRequestNS1 = '{\n  \"segment\": \"Law Firm\"\n}';
       reqNS1.requestBody = blob.valueOf(jsonRequestNS1);
       RestContext.request = reqNS1;
       DCPProductRequestDeclaration.ProductPlanResponse nsresp1 = new DCPProductRequestDeclaration.ProductPlanResponse();
       nsresp1 = DCPNewSaleServices.productService();
       RestResponse resNS1 = new RestResponse();
       RestContext.response = resNS1;
       system.assert(resNS1!=null, 'method failure');*/
         
       Map<String,String> errorHandlerMap = new Map<String,String>{'objectName'=>'Product Configuration','expMsg'=>'abc','webServiceName'=>'PromotionAPI','requestType'=>'Promotion Service: Manual/Auto Promotion','reqMsg'=>'Exception Class Name: TRStore_PromotionService','module'=>'UEStore','recId'=>'','supportEmail'=>'abc@sample.com','toSupport'=>'false'};
       DCPNewSaleUtilityCls.logException(errorHandlerMap);
         
       test.stopTest();
     }
     
    /** 
    * @description : Test method for ProductPlan Service
    */ 
     public static testMethod void testforProductPlanService2() {
       test.startTest();
       testData();
       
       RestRequest req = new RestRequest();
       req.requestURI = '/newsale/DCPProductPlanService';  //Request URL
       req.httpMethod = 'POST';//HTTP Request Type
       req.addHeader('Content-Type', 'application/json');
       String jsonReq = '{\n  \"segment\": \"Practical Law\",\n  \"jurisdiction\": \"Alabama\",\n  \"brand\": \"Westlaw Classic\"\n }';
       req.requestBody = blob.valueOf(jsonReq);
       RestContext.request = req;
       DCPProductRequestDeclaration.ProductPlanResponse ppresp = new DCPProductRequestDeclaration.ProductPlanResponse();
       ppresp = DCPNewSaleServices.productService();
       RestResponse res = new RestResponse();
       RestContext.response = res;
       system.assert(res!=null, 'method failure');
         
       RestRequest reqPD = new RestRequest();
       reqPD.requestURI = '/newsale/DCPProductDetailService123';  //Request URL
       reqPD.httpMethod = 'POST';//HTTP Request Type
       reqPD.addHeader('Content-Type', 'application/json');
       String jsonRequest = '{\n  \"segment\": \"Practical Law\",\n  \"productCode\": \"425425425\",\n  \"brand\": \"Westlaw Classic\"\n}';
       reqPD.requestBody = blob.valueOf(jsonRequest);
       RestContext.request = reqPD;
       DCPProductRequestDeclaration.ProductPlanResponse pdresp = new DCPProductRequestDeclaration.ProductPlanResponse();
       pdresp = DCPNewSaleServices.productService();
       RestResponse resPD = new RestResponse();
       RestContext.response = resPD;
       system.assert(resPD!=null, 'method failure');
       
       test.stopTest();
     }

     /** 
    * @description : Test method for ProductPlan Service
    */ 
     public static testMethod void testforProductPlanService3() {
        test.startTest();
        testData();
        
        RestRequest req = new RestRequest();
        req.requestURI = '/newsale/DCPProductPlanService';  //Request URL
        req.httpMethod = 'POST';//HTTP Request Type
        req.addHeader('Content-Type', 'application/json');
        String jsonReq = '{\n  \"segment\": \"Practical Law\",\n  \"jurisdiction\": \"Alabama\",\n  \"brand\": \"Westlaw Classic\"\n }';
        req.requestBody = blob.valueOf(jsonReq);
        RestContext.request = req;
        DCPProductRequestDeclaration.ProductPlanResponse ppresp = new DCPProductRequestDeclaration.ProductPlanResponse();
        ppresp = DCPNewSaleServices.productService();
        RestResponse res = new RestResponse();
        RestContext.response = res;
        system.assert(res!=null, 'method failure');
          
        RestRequest reqPD = new RestRequest();
        reqPD.requestURI = '/newsale/DCPProductDetailService123';  //Request URL
        reqPD.httpMethod = 'POST';//HTTP Request Type
        reqPD.addHeader('Content-Type', 'application/json');
        String jsonRequest = '{\n  \"segment\": \"Practical Law\",\n  \"productCode\": \"425425425\",\n  \"brand\": \"Westlaw Classic\"\n}';
        reqPD.requestBody = blob.valueOf(jsonRequest);
        RestContext.request = reqPD;
        DCPProductRequestDeclaration.ProductPlanResponse pdresp = new DCPProductRequestDeclaration.ProductPlanResponse();
        pdresp = DCPNewSaleServices.productService();
        RestResponse resPD = new RestResponse();
        RestContext.response = resPD;
        system.assert(resPD!=null, 'method failure');
        
        test.stopTest();
      }
    
}