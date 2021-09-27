/* Class: DCPNewSaleUtilityClsTest
* Purpose: This test class is for the coverage of reusable codes and constant for new sale codes
* Created: 5/19/2021
*  
* 
* CHANGE HISTORY
* =============================================================================
* Date         Name             JIRA        Description
* 05/19/2021    Avudaiappan A    DCP-1821     Created 
* =============================================================================
*/
@isTest(seeAllData=false)
/** 
 * @description : This is the class to define the test method for DCPNewSaleUtilityCls
 */
public class DCPNewSaleUtilityClsTest {
    /** 
 * @description : This is the method to define the test method for coverage
 */
    public static testMethod void testConstants(){
         /*String success_status = DCPNewSaleUtilityCls.SUCCESS_STATUS;
         String success_code = DCPNewSaleUtilityCls.SUCCESS_CODE;
         String error_code = DCPNewSaleUtilityCls.ERROR_CODE;
         String failure_status = DCPNewSaleUtilityCls.FAILURESTATUS;
         String not_AVAILABLE = DCPNewSaleUtilityCls.NOT_AVAILABLE;
         String lead_success = DCPNewSaleUtilityCls.SUCCESS_LEAD_FETCH_DETAILS;
         String lead_error_code = DCPNewSaleUtilityCls.ERROR_STATUS;
         String lead_failure_status = DCPNewSaleUtilityCls.ERROR_LEAD_FETCH_DETAILS;
         String reqd_field = DCPNewSaleUtilityCls.REQUIREDFIELDSMISSING;*/
           DCPTestDataFactory.disableApplicationAutomation();
          LIST < Static_Values__c > staticCSList = new LIST < Static_Values__c > {
             new Static_Values__c(name = 'OrderProcessSupportEmail', value__c = 'APP-CX-DIGITAL@thomson.com')
           
        };
        insert staticCSList;
        
         DCPNewSaleUtilityCls.responseMethod(DCPNewSaleUtilityCls.errorCode,DCPNewSaleUtilityCls.requiredFieldMissing,DCPNewSaleUtilityCls.failureStatus);
         Map<String,String> errorHandlerMap = new Map<String,String>{'objectName'=>'Product Configuration','expMsg'=>'abc','webServiceName'=>'PromotionAPI','requestType'=>'Promotion Service: Manual/Auto Promotion','reqMsg'=>'Exception Class Name: TRStore_PromotionService','module'=>'UEStore','recId'=>'','supportEmail'=>'abc@sample.com','toSupport'=>'false'};
         DCPNewSaleUtilityCls.logException(errorHandlerMap);
         system.assert(errorHandlerMap!=null, 'inserted');
        
          Pricebook2 pbook = new Pricebook2();
        pbook.name =  'GLI Price Book - US Legal/LMS';        
        pbook.IsActive = true;
        insert pbook;
        
        Apttus_Config2__PriceList__c priceListObj = new Apttus_Config2__PriceList__c();
        priceListObj.Name = 'Thomson Reuters Master - US Legal';
        insert priceListObj;
        
        Apttus_Proposal__Proposal__c propObj = new Apttus_Proposal__Proposal__c();
        propObj.Apttus_QPConfig__PriceListId__c = priceListObj.ID;
        insert propObj;
        
        Apttus_Config2__ProductConfiguration__c prodConfigObj = new Apttus_Config2__ProductConfiguration__c();
        prodConfigObj.Apttus_QPConfig__Proposald__c = propObj.ID;
        prodConfigObj.Apttus_Config2__BusinessObjectRefId__c =propObj.ID;
        prodConfigObj.Apttus_Config2__BusinessObjectType__c = 'Proposal';
        insert prodConfigObj;
        
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
        
        Apttus_Config2__PriceMatrixEntry__c pme = DCPNewSaleUtilityCls.createPME(pm.id,'law firm');
        Insert pme;

        Apttus_Config2__PriceMatrixEntry__c pme1 = DCPNewSaleUtilityCls.createPME(pm.id,'law firm');
        Insert pme1;
        
        Apttus_Config2__PriceMatrixEntry__c pme2 = DCPNewSaleUtilityCls.createPME(pm1.id,'law firm');
        Insert pme2;
        
        Product_Platform__c pp = DCPNewSaleUtilityCls.createPlatform();
        Insert pp;
        
        Product_Platform_Value__c ppv = DCPNewSaleUtilityCls.createPlatformValue(prod.Id,pp.Id);
        Insert ppv;
        
        Product_Platform__c pp1 = DCPNewSaleUtilityCls.createPlatform();
        Insert pp1;
        
        Product_Platform_Value__c ppv1 = DCPNewSaleUtilityCls.createPlatformValue(prod.Id,pp1.Id);
        Insert ppv1;
        
        DCPNewSaleUtilityCls.handleEmptyString('abc','abc');
        
        DCPNewSaleUtilityCls.finalizeCart(prodConfigObj.Id);
        DCPNewSaleUtilityCls.repriceCart(prodConfigObj.Id);
        
    }

}