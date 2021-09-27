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
*2021-05-24   Avudaiappan A     DCP-1982   Code Refactoring for USL Support and PMD
* =============================================================================
*/

@isTest(seeAllData = False)
public class DCPCreateProposalAPITest {
    
    /**@description createTestData - to cover the test coverage */
    @testSetup  static void createTestData(){
        Apttus_Config2__PriceList__c plSO = APTS_TestDataFactory.createPriceList('Thomson Reuters Master - US Legal');
        insert plSO;
        
        Apttus_Config2__PriceList__c plSO1 = APTS_TestDataFactory.createPriceList('Thomson Reuters Master - Canada');
        insert plSO1;
        

        LIST<Static_Values__c> staticCSList = new LIST<Static_Values__c>{new Static_Values__c(name='PriceListName', value__c='Thomson Reuters Master - US Legal'),
            new Static_Values__c(name='TRStorePricelistCA', value__c='Thomson Reuters Master - Canada'),
            new Static_Values__c(name='TRStorePricelistUS', value__c='Thomson Reuters Master - US Legal'),
            new Static_Values__c(name='thresholdLimit' , value__c='3'),
            new Static_Values__c(name='halfPointLimit' , value__c='2'),
            new Static_Values__c(name='ProposalBusinessUnitCA', value__c='Canada'),
            new Static_Values__c(name='OrderProcessSupportEmail', value__c='sample@thomsonreuters.com'),
            new Static_Values__c(name='ProposalBusinessUnitUSL', value__c='SCS'),
            new Static_Values__c(name='ProposalBusinessUnitTP', value__c='Tax Professional'),
            new Static_Values__c(name='UEUSPR', value__c='DCP New Sales')};
            
        insert staticCSList;

        Product2 prod = DCPNewSaleUtilityCls.createProduct('42015055');
        insert prod;
        
        
        Apttus_Proposal__Proposal__c propObj = new Apttus_Proposal__Proposal__c();
        propObj.Apttus_QPConfig__PriceListId__c = plSO.Id;
        insert propObj;
        
        Apttus_Proposal__Proposal__c propObj1 = new Apttus_Proposal__Proposal__c();
        propObj1.Apttus_QPConfig__PriceListId__c = plSO.Id;
        insert propObj1;
        
        /*Apttus_Proposal__Proposal__c propObj2 = new Apttus_Proposal__Proposal__c();
        propObj2.Apttus_QPConfig__PriceListId__c = plSO.Id;
        insert propObj2;*/
        
        Apttus_Config2__ProductConfiguration__c prodConfigObj = new Apttus_Config2__ProductConfiguration__c();
        prodConfigObj.Apttus_QPConfig__Proposald__c = propObj.ID;
        prodConfigObj.Apttus_Config2__Status__c = 'New';
        prodConfigObj.Apttus_Config2__BusinessObjectId__c = propObj.Id;
        prodConfigObj.Apttus_Config2__BusinessObjectType__c = 'Proposal';
        prodConfigObj.Apttus_Config2__PriceListId__c = plSO.Id;
        insert prodConfigObj;

        Apttus_Config2__ProductConfiguration__c prodConfigObj1 = new Apttus_Config2__ProductConfiguration__c();
        prodConfigObj.Apttus_QPConfig__Proposald__c = propObj1.ID;
        prodConfigObj.Apttus_Config2__Status__c = 'New';
        prodConfigObj.Apttus_Config2__BusinessObjectId__c = propObj1.Id;
        prodConfigObj.Apttus_Config2__BusinessObjectType__c = 'Proposal';
        prodConfigObj.Apttus_Config2__PriceListId__c = plSO.Id;
        insert prodConfigObj1;
        
        /*Apttus_Config2__ProductConfiguration__c prodConfigObj2 = new Apttus_Config2__ProductConfiguration__c();
        prodConfigObj.Apttus_QPConfig__Proposald__c = propObj2.ID;
        prodConfigObj.Apttus_Config2__Status__c = 'New';
        prodConfigObj.Apttus_Config2__BusinessObjectId__c = propObj2.Id;
        prodConfigObj.Apttus_Config2__BusinessObjectType__c = 'Proposal';
        prodConfigObj.Apttus_Config2__PriceListId__c = plSO.Id;
        insert prodConfigObj2;*/
        
        Apttus_Config2__LineItem__c lineSO = new Apttus_Config2__LineItem__c();
                lineSO.Apttus_Config2__ConfigurationId__c = prodConfigObj.Id;
                lineSO.Apttus_Config2__PricingStatus__c = 'Pending';
                lineSO.Mark_Removed__c = true;
                lineSO.Apttus_Config2__LineNumber__c = 1;
                lineSO.Apttus_Config2__PrimaryLineNumber__c=  lineSO.Apttus_Config2__LineNumber__c;
                lineSO.Apttus_Config2__ItemSequence__c =  lineSO.Apttus_Config2__LineNumber__c;
                lineSO.Apttus_Config2__IsPrimaryLine__c = true;
        insert lineSO;
        
        Apttus_Config2__LineItem__c lineSO1 = new Apttus_Config2__LineItem__c();
                lineSO1.Apttus_Config2__ConfigurationId__c = prodConfigObj1.Id;
                lineSO1.Apttus_Config2__PricingStatus__c = 'Pending';
                lineSO1.Mark_Removed__c = true;
                lineSO1.Apttus_Config2__LineNumber__c = 1;
                lineSO1.Apttus_Config2__ProductId__c = prod.Id;
                lineSO1.Apttus_Config2__PrimaryLineNumber__c=  lineSO1.Apttus_Config2__LineNumber__c;
                lineSO1.Apttus_Config2__ItemSequence__c =  lineSO1.Apttus_Config2__LineNumber__c;
                lineSO1.Apttus_Config2__IsPrimaryLine__c = true;
        insert lineSO1;
        
        /*Apttus_Config2__LineItem__c lineSO2 = new Apttus_Config2__LineItem__c();
                lineSO2.Apttus_Config2__ConfigurationId__c = prodConfigObj2.Id;
                lineSO2.Apttus_Config2__PricingStatus__c = 'Pending';
                lineSO2.Mark_Removed__c = true;
                lineSO2.Apttus_Config2__LineNumber__c = 1;
                lineSO2.Apttus_Config2__PrimaryLineNumber__c=  lineSO2.Apttus_Config2__LineNumber__c;
                lineSO2.Apttus_Config2__ItemSequence__c =  lineSO2.Apttus_Config2__LineNumber__c;
                lineSO2.Apttus_Config2__IsPrimaryLine__c = true;
        insert lineSO2;*/
        
        UE_Proposal__c oQ = new UE_Proposal__c(quoteId__c=propObj.Id, cartId__c=prodConfigObj.Id,lineitemId__c=lineSO.Id,appId__c='UEUSPR');
        insert oQ;
        
        UE_Proposal__c oQ1 = new UE_Proposal__c(quoteId__c=propObj1.Id, cartId__c=prodConfigObj1.Id,lineitemId__c=lineSO1.Id,appId__c='UEUSPR',Inactive__c=true);
        insert oQ1;
        
        /*UE_Proposal__c oQ2 = new UE_Proposal__c(quoteId__c=propObj2.Id, cartId__c=prodConfigObj2.Id,lineitemId__c=lineSO2.Id,appId__c='UEUSPR',Inactive__c=false);
        insert oQ2;*/
        
        //system.assert(oQ.QuoteId__c==propObj.Id,'Good to Proceed');
    }

/**@description createTestMethod - to cover the test coverage */
    public static testmethod void createTestMethod(){ 
        Apttus_Config2__ProductConfiguration__c  prodConfigObj = [Select id from Apttus_Config2__ProductConfiguration__c order by Id DESC limit 1];
        UE_Proposal__c oQ = [Select id,inActive__c,cartId__c from UE_Proposal__c where cartId__c=:prodConfigObj.Id limit 1];
        RestRequest req = new RestRequest();
         req.params.put('appId','UEUSPR');
         req.params.put('cartId','');
         req.params.put('lno','');
         req.requestURI = '/services/apexrest/newsale/DCPCreateProposalService';  //Request URL
         req.httpMethod = 'GET';//HTTP Request Type
         req.addHeader('Content-Type', 'application/json');
         RestContext.request = req;
         RestResponse res = new RestResponse();
         RestContext.response = res;
         DCPCreateProposalAPI.createProposalData();
         system.assert(req!=null,'Good to Proceed');
        
        RestRequest req0 = new RestRequest();
         req0.params.put('appId','UEUSPR');
         req0.params.put('cartId','');
         req0.params.put('lno','');
         req0.requestURI = '/services/apexrest/newsale/DCPCreateProposalService';  //Request URL
         req0.httpMethod = 'GET';//HTTP Request Type
         req0.addHeader('Content-Type', 'application/json');
         RestContext.request = req0;
         RestResponse res0 = new RestResponse();
         RestContext.response = res0;
         DCPCreateProposalAPI.createProposalData();
         test.StartTest();
         System.enqueueJob(new TRStore_CreateProposalApexQueue('All'));
         test.StopTest();
        
         RestRequest req1 = new RestRequest();
         req1.params.put('appId','C');
         req1.params.put('cartId','');
         req1.params.put('lno','');
         req1.requestURI = '/services/apexrest/newsale/DCPCreateProposalService';  //Request URL
         req1.httpMethod = 'GET';//HTTP Request Type
         req1.addHeader('Content-Type', 'application/json');
         RestContext.request = req1;
         RestResponse res1 = new RestResponse();
         RestContext.response = res1;
         DCPCreateProposalAPI.createProposalData();
         
         RestRequest req2 = new RestRequest();
         req2.params.put('appId','UEUSPR');
         req2.params.put('cartId',prodConfigObj.Id);
         req2.params.put('lno','2');
         req2.requestURI = '/services/apexrest/newsale/DCPCreateProposalService';  //Request URL
         req2.httpMethod = 'GET';//HTTP Request Type
         req2.addHeader('Content-Type', 'application/json');
         RestContext.request = req2;
         RestResponse res2 = new RestResponse();
         RestContext.response = res2;
         DCPCreateProposalAPI.createProposalData();
        
         RestRequest req3 = new RestRequest();
         req3.params.put('appId','');
         req3.params.put('cartId',prodConfigObj.Id);
         req3.params.put('lno','');
         req3.requestURI = '/services/apexrest/newsale/DCPCreateProposalService';  //Request URL
         req3.httpMethod = 'GET';//HTTP Request Type
         req3.addHeader('Content-Type', 'application/json');
         RestContext.request = req3;
         RestResponse res3 = new RestResponse();
         RestContext.response = res3;
         DCPCreateProposalAPI.createProposalData();

        oQ.InActive__c = true;
        Database.update(oQ,false);
        
        RestRequest req4 = new RestRequest();
         req4.params.put('appId','UEUSPR');
         req4.params.put('cartId',prodConfigObj.Id);
         req4.params.put('lno','');
         req4.requestURI = '/services/apexrest/newsale/DCPCreateProposalService';  //Request URL
         req4.httpMethod = 'GET';//HTTP Request Type
         req4.addHeader('Content-Type', 'application/json');
         RestContext.request = req4;
         RestResponse res4 = new RestResponse();
         RestContext.response = res4;
         DCPCreateProposalAPI.createProposalData();
        
         

    }


/**@description createTestMethod1 - to cover the test coverage */
    public static testmethod void createTestMethod1(){ 
        List<Apttus_Config2__ProductConfiguration__c>  prodConfigObj1 = [Select id from Apttus_Config2__ProductConfiguration__c order by Id DESC];
        RestRequest req5 = new RestRequest();
         req5.params.put('appId','UEUSPR');
         req5.params.put('cartId',prodConfigObj1[1].Id);
         req5.params.put('lno','2');
         req5.requestURI = '/services/apexrest/newsale/DCPCreateProposalService';  //Request URL
         req5.httpMethod = 'GET';//HTTP Request Type
         req5.addHeader('Content-Type', 'application/json');
         RestContext.request = req5;
         RestResponse res5 = new RestResponse();
         RestContext.response = res5;
         DCPCreateProposalAPI.createProposalData();
        test.StartTest();
         System.enqueueJob(new TRStore_CreateProposalApexQueue('UEUSPR'));
         test.StopTest();
         system.assert(req5!=null,'Good to Proceed');
        
        RestRequest req6 = new RestRequest();
         req6.params.put('appId','UEUSPR');
         req6.params.put('cartId','');
         req6.params.put('lno','2');
         req6.requestURI = '/services/apexrest/newsale/DCPCreateProposalService123';  //Request URL
         req6.httpMethod = 'GET';//HTTP Request Type
         req6.addHeader('Content-Type', 'application/json');
         RestContext.request = req6;
         RestResponse res6 = new RestResponse();
         RestContext.response = res6;
         DCPCreateProposalAPI.createProposalData();
    }
    //DCPCreateProposalAPIHandler.deleteCart(3,'UEUSPR','sample@sample.com');
    //}

}