/* Class: TRStore_CreateProposalAPITest
* Purpose: Test Coverage for Rest API Service to create proposal records for three different sites like USL, Tax Professional, Canada
* Created: 05/04/2020
* Author: Avudaiappan A
* 
* CHANGE HISTORY
* =============================================================================
* Date         Name             JIRA        Description
* 2020-05-04   Avudaiappan A     DUE-2307   Test Coverage Started
* 2020-06-01   Avudaiappan A     DUE-2952   Test Coverage for Queueable Apex TRStore_CreateProposalApexQueue
* 2020-08-07   Avudaiappan A     DUE-4362   Test Coverage modified for new parameters like lno, cartId
* =============================================================================
*/

@isTest(seeAllData = False)
public class TRStore_CreateProposalAPITest {
    /**
    @description createTestData
    */
    public static testmethod void createTestData(){
        Apttus_Config2__PriceList__c plSO = APTS_TestDataFactory.createPriceList('Thomson Reuters Master - US Legal');
        insert plSO;
        
        Apttus_Config2__PriceList__c plSO1 = APTS_TestDataFactory.createPriceList('Thomson Reuters Master - Canada');
        insert plSO1;
        
        LIST<Static_Values__c> staticCSList = new LIST<Static_Values__c>{new Static_Values__c(name='PriceListName', value__c='Thomson Reuters Master - US Legal'),
            new Static_Values__c(name='TRStorePricelistCA', value__c='Thomson Reuters Master - Canada'),
            new Static_Values__c(name='TRStorePricelistUS', value__c='Thomson Reuters Master - US Legal'),
            new Static_Values__c(name='thresholdLimit' , value__c='2'),
            new Static_Values__c(name='halfPointLimit' , value__c='1'),
            new Static_Values__c(name='ProposalBusinessUnitCA', value__c='Canada'),
            new Static_Values__c(name='OrderProcessSupportEmail', value__c='sample@thomsonreuters.com'),
            new Static_Values__c(name='ProposalBusinessUnitUSL', value__c='SCS'),
            new Static_Values__c(name='ProposalBusinessUnitTP', value__c='Tax Professional')};
            
        insert staticCSList;
        
        Apttus_Proposal__Proposal__c propObj = new Apttus_Proposal__Proposal__c();
        propObj.Apttus_QPConfig__PriceListId__c = plSO1.Id;
        insert propObj;
        
        Apttus_Config2__ProductConfiguration__c prodConfigObj = new Apttus_Config2__ProductConfiguration__c();
        prodConfigObj.Apttus_QPConfig__Proposald__c = propObj.ID;
        prodConfigObj.Apttus_Config2__Status__c = 'New';
        prodConfigObj.Apttus_Config2__BusinessObjectId__c = propObj.Id;
        prodConfigObj.Apttus_Config2__BusinessObjectType__c = 'Proposal';
        prodConfigObj.Apttus_Config2__PriceListId__c = plSO1.Id;
        insert prodConfigObj;

		Apttus_Config2__LineItem__c lineSO = new Apttus_Config2__LineItem__c();
                lineSO.Apttus_Config2__ConfigurationId__c = prodConfigObj.Id;
                lineSO.Apttus_Config2__PricingStatus__c = 'Pending';
                lineSO.Mark_Removed__c = false;
                lineSO.Apttus_Config2__LineNumber__c = 1;
                lineSO.Apttus_Config2__PrimaryLineNumber__c=  lineSO.Apttus_Config2__LineNumber__c;
                lineSO.Apttus_Config2__ItemSequence__c =  lineSO.Apttus_Config2__LineNumber__c;
                lineSO.Apttus_Config2__IsPrimaryLine__c = true;
        		
        insert lineSO;
        
        UE_Proposal__c oQ = new UE_Proposal__c(quoteId__c=propObj.Id, cartId__c=prodConfigObj.Id,lineitemId__c=lineSo.Id,appId__c='UECAPR');
        insert oQ;
        system.assert(oQ.QuoteId__c!='abc','Good to Proceed');
        
        RestRequest req = new RestRequest();
         req.params.put('appId','UECAPR');
         req.params.put('cartId','');
         req.params.put('lno','');
         req.requestURI = '/services/apexrest/createProposalAPI';  //Request URL
         req.httpMethod = 'GET';//HTTP Request Type
         req.addHeader('Content-Type', 'application/json');
         RestContext.request = req;
         RestResponse res = new RestResponse();
         RestContext.response = res;
         TRStore_CreateProposalAPI.createProposalData();
        
        
        RestRequest req0 = new RestRequest();
         req0.params.put('appId','UECAPR');
         req0.params.put('cartId','');
         req0.params.put('lno','');
         req0.requestURI = '/services/apexrest/createProposalAPI';  //Request URL
         req0.httpMethod = 'GET';//HTTP Request Type
         req0.addHeader('Content-Type', 'application/json');
         RestContext.request = req0;
         RestResponse res0 = new RestResponse();
         RestContext.response = res0;
         TRStore_CreateProposalAPI.createProposalData();
         test.StartTest();
         System.enqueueJob(new TRStore_CreateProposalApexQueue('All'));
         test.StopTest();
        
         RestRequest req1 = new RestRequest();
         req1.params.put('appId','C');
         req1.params.put('cartId','');
         req1.params.put('lno','');
         req1.requestURI = '/services/apexrest/createProposalAPI';  //Request URL
         req1.httpMethod = 'GET';//HTTP Request Type
         req1.addHeader('Content-Type', 'application/json');
         RestContext.request = req1;
         RestResponse res1 = new RestResponse();
         RestContext.response = res1;
         TRStore_CreateProposalAPI.createProposalData();
         
         RestRequest req2 = new RestRequest();
         req2.params.put('appId','UECAPR');
         req2.params.put('cartId',prodConfigObj.Id);
         req2.params.put('lno','2');
         req2.requestURI = '/services/apexrest/createProposalAPI';  //Request URL
         req2.httpMethod = 'GET';//HTTP Request Type
         req2.addHeader('Content-Type', 'application/json');
         RestContext.request = req2;
         RestResponse res2 = new RestResponse();
         RestContext.response = res2;
         TRStore_CreateProposalAPI.createProposalData();
        
         RestRequest req3 = new RestRequest();
         req3.params.put('appId','');
         req3.params.put('cartId',prodConfigObj.Id);
         req3.params.put('lno','');
         req3.requestURI = '/services/apexrest/createProposalAPI';  //Request URL
         req3.httpMethod = 'GET';//HTTP Request Type
         req3.addHeader('Content-Type', 'application/json');
         RestContext.request = req3;
         RestResponse res3 = new RestResponse();
         RestContext.response = res3;
         TRStore_CreateProposalAPI.createProposalData();

		oQ.InActive__c = true;
        Database.update(oQ,false);
		
        RestRequest req4 = new RestRequest();
         req4.params.put('appId','UECAPR');
         req4.params.put('cartId',prodConfigObj.Id);
         req4.params.put('lno','');
         req4.requestURI = '/services/apexrest/createProposalAPI';  //Request URL
         req4.httpMethod = 'GET';//HTTP Request Type
         req4.addHeader('Content-Type', 'application/json');
         RestContext.request = req4;
         RestResponse res4 = new RestResponse();
         RestContext.response = res4;
         TRStore_CreateProposalAPI.createProposalData();

    }

}