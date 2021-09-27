/* Class: TRStore_ReviewOrderDetailsTest
* Purpose: Coverage for  Class TRStore_ReviewOrderDetails (Rest API Service to bring the cart line item details for Order Summary page)
* Created: 06/02/2020
* Author: Ameeta Antonio
* 
* CHANGE HISTORY
* =============================================================================
* Date         Name             JIRA        Description
* 2020-06-02   Ameeta           DUE-2947   Test Coverage Started
* =============================================================================
*/
@isTest(seeAllData = False)
public class TRStore_ReviewOrderDetailsTest {
    
    public static testmethod void createTestData(){
        
         product2 pd1 = new product2();
         pd1.Name = 'Test Product';
         pd1.ProductCode = '98765';
         pd1.Description = 'Test Desc';
         pd1.Service_Number__c = '87654';
         pd1.Apttus_Filter_Brand__c = 'Test';
         pd1.Apttus_Filter_Jurisdiction__c = 'Colorado';
         pd1.LCRM_Sub_Bu__c = 'USL';
         pd1.Format__c= 'Format';
         pd1.IsActive = true;
         pd1.CPD_Sellable_Description__c ='Display and Sell';
         insert pd1;
        
        Apttus_Config2__ProductConfiguration__c prodConfigObj = new Apttus_Config2__ProductConfiguration__c();
        insert prodConfigObj;
        
        List<Apttus_Config2__LineItem__c> lineItemList = new List<Apttus_Config2__LineItem__c>();
        Apttus_Config2__LineItem__c cli = new Apttus_Config2__LineItem__c();
        cli.Apttus_Config2__ConfigurationId__c = prodConfigObj.id;
        cli.Apttus_Config2__ProductId__c = pd1.id;
        cli.Apttus_Config2__ItemSequence__c = 1;
        cli.Apttus_Config2__LineNumber__c = 1;
        lineItemList.add(cli);
        insert lineItemList;
        
        List<Apttus_Config2__SummaryGroup__c> summaryList = new List<Apttus_Config2__SummaryGroup__c>();
        Apttus_Config2__SummaryGroup__c sg = new Apttus_Config2__SummaryGroup__c();
        sg.Name = 'Total (Monthly)';
        sg.Apttus_Config2__ConfigurationId__c = prodConfigObj.id;
        sg.Apttus_Config2__NetPrice__c = 45;
        sg.Apttus_Config2__ItemSequence__c = 1;
        sg.Apttus_Config2__LineNumber__c = 1;
        summaryList.add(sg);
        insert summaryList;
        
        RestRequest req = new RestRequest();
         req.params.put('cartId',prodConfigObj.id);
         req.requestURI = '/services/apexrest/GetReviewOrderDetails'; 
         req.httpMethod = 'GET';
         req.addHeader('Content-Type', 'application/json');
         RestContext.request = req;
         RestResponse res = new RestResponse();
         RestContext.response = res;
         TRStore_ReviewOrderDetails.getReviewOrderDetails();
        System.assertNotEquals(null,RestContext.response.responseBody);
        
        RestRequest req1 = new RestRequest();
         //req.params.put('CartId','009');
         req1.requestURI = '/services/apexrest/GetReviewOrderDetails'; 
         req1.httpMethod = 'GET';
         req1.addHeader('Content-Type', 'application/json');
         RestContext.request = req1;
         RestResponse res1 = new RestResponse();
         RestContext.response = res1;
         TRStore_ReviewOrderDetails.getReviewOrderDetails();
    }

}