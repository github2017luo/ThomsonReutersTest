/* Class: TRStore_UpdateCartServiceTest
* Purpose: Coverage for  Class TRStore_UpdateCartService 
* Created: 10/11/2020
* Author: Ameeta A
* 
* CHANGE HISTORY
* =============================================================================
* Date         Name             JIRA        Description
* 2020-11-10   Ameeta A     DLT-21056   Test Coverage Started
* =============================================================================
*/
@isTest(seeAllData = False)
public class TRStore_UpdateCartServiceTest {
    
    public static testMethod void testData(){
        
        // insert static value
        LIST<Static_Values__c> staticCSList = new LIST<Static_Values__c>{new Static_Values__c(name='LeadSupportEmail', value__c='ameeta.antonio2thomsonreuters.com')};
        insert staticCSList;
        
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
        
        RestRequest req = new RestRequest();
        req.requestURI = '/services/apexrest/TRStoreCartUpdateAPI';  //Request URL
        req.httpMethod = 'POST';//HTTP Request Type
        req.addHeader('Content-Type', 'application/json');
        RestContext.request = req;
        RestResponse res = new RestResponse();
        RestContext.response = res;
        TRStore_UpdateCartService.TRStore_PromotionRequestClass cReq = new TRStore_UpdateCartService.TRStore_PromotionRequestClass();
        List<String> promos = new List<String>{'TRTEST01'};
        cReq.promoCode = promos[0];
        cReq.cartId = prodConfigObj.Id;
        TRStore_UpdateCartService.updateCart(cReq);
        promos.clear();
        //TRStore_UpdateCartService.updateCart(cReq);
        
        
        TRStore_UpdateCartService.TRStore_PromotionRequestClass cReq1 = new TRStore_UpdateCartService.TRStore_PromotionRequestClass();
        promos.add('TRTEST02');
        cReq1.promoCode = promos[0];
        cReq1.cartId = '5267asdhvhfsf';
        System.assertNotEquals(null,cReq1);
        promos.clear();
        TRStore_UpdateCartService.updateCart(cReq1);
        
        TRStore_UpdateCartService.TRStore_PromotionRequestClass cReq2 = new TRStore_UpdateCartService.TRStore_PromotionRequestClass();
        promos.add('TRTEST03');
        cReq2.promoCode = promos[0];
        cReq2.cartId = null;
        TRStore_UpdateCartService.updateCart(cReq2);
    }
}