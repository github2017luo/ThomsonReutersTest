/* Class: DCPNewSalesAddONRequestTest
* Purpose: This test class is for the coverage of product Addon service
* Created: 9/7/2021
*  
* 
* CHANGE HISTORY
* =============================================================================
* Date         Name             JIRA        Description
* 09/07/2021    Avudaiappan A    DCP-4656     Created 
* =============================================================================
*/
@isTest(seeAllData=false)
 /** 
 * @description : This is the method to define the coverage
 */
public class DCPNewSalesAddONRequestTest {
    /** 
    * @description : Prepare test data
    */ 
    @istest static void testData(){
        
      //UEStoreUSLPlan__mdt[] usPlan =[SELECT MasterLabel,DeveloperName,Best_Plan__c,Better_Plan__c,Good_Plan__c,Jurisdiction__c,Segment__c,Sub_Segment__c,Brand__c FROM UEStoreUSLPlan__mdt limit 1];
      //String segment = usPlan[0].segment__c;
      String segment='Law Firm';
        LIST < Static_Values__c > staticCSList = new LIST < Static_Values__c > {
            new Static_Values__c(name = 'NewSaleSellableFlag', value__c = 'Display and Sell'),
                new Static_Values__c(name = 'OrderProcessSupportEmail', value__c = 'APP-CX-DIGITAL@thomson.com'),
                new Static_Values__c(name = 'DCPNSVersion', value__c = 'v2'),
                new Static_Values__c(name = 'DCPNSBrandVersioning', value__c = 'v1'),
                new Static_Values__c(name = 'DCPAddOnVersioningForPDP', value__c = 'v2')
           
        };
        insert staticCSList;
        
        Product2 prod = DCPNewSaleUtilityCls.createProduct('42076533');
        Insert prod;
    
        Product2 prod1 = DCPNewSaleUtilityCls.createProduct('42004986');
        Insert prod1;

        Product_Relationship__c pr = new Product_Relationship__c (product_From__c=prod.Id,product_To__c=prod1.Id,Relationship_Type__c='Accessory Product',Relationship_Link_Type__c='Add-on',Segment__c='Law Firm');
        Insert pr;
        
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
     @isTest static void testforProductAddOnService() {
       test.startTest();
       testData();
       DCPNewSalesAddOnRequest dcp;
       dcp = new DCPNewSalesAddOnRequest();
       RestRequest req = new RestRequest();
       req.requestURI = '/newsale/DCPAddOnService';  //Request URL
       req.httpMethod = 'POST';//HTTP Request Type
       req.addHeader('Content-Type', 'application/json');
       String jsonReq = '{\n  \"segment\": \"Law Firm\",\n  \"productCode\": \"42076533\"\n}';
       req.requestBody = blob.valueOf(jsonReq);
       RestContext.request = req;
       DCPNewSalesAddOnRequest.ProductAddOnResponse ppresp = new DCPNewSalesAddOnRequest.ProductAddOnResponse();
       ppresp = DCPNewSalesAddOnRequest.addONService();
         RestResponse res = new RestResponse();
       RestContext.response = res;
       system.assert(res!=null, 'method failure');
         
       RestRequest reqPD = new RestRequest();
       reqPD.requestURI = '/newsale/DCPAddOnService';  //Request URL
       reqPD.httpMethod = 'POST';//HTTP Request Type
       reqPD.addHeader('Content-Type', 'application/json');
       String jsonRequest = '{\n  \"segment\": \"Law Firm\",\n  \"productCode\": \"\"\n}';
       reqPD.requestBody = blob.valueOf(jsonRequest);
       RestContext.request = reqPD;
       DCPNewSalesAddOnRequest.ProductAddOnResponse pdresp = new DCPNewSalesAddOnRequest.ProductAddOnResponse();
        pdresp = DCPNewSalesAddOnRequest.addONService();
       RestResponse resPD = new RestResponse();
       RestContext.response = resPD;
       
       Map<String,String> errorHandlerMap = new Map<String,String>{'objectName'=>'Product Configuration','expMsg'=>'abc','webServiceName'=>'PromotionAPI','requestType'=>'Promotion Service: Manual/Auto Promotion','reqMsg'=>'Exception Class Name: TRStore_PromotionService','module'=>'UEStore','recId'=>'','supportEmail'=>'abc@sample.com','toSupport'=>'false'};
       DCPNewSaleUtilityCls.logException(errorHandlerMap);
         
       test.stopTest();
     }
     
    
}