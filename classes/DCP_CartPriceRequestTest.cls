/* Class: DCP_CartPriceRequestTest
* Purpose: Coverage for  Class DCP_CartPriceRequest
* Created: 01-June-2021
* Author: Kanishk
* 
* CHANGE HISTORY
* =============================================================================
* Date         Name             JIRA        Description
* 01-June-2021  Kanishk        DCP-1671   Test Coverage Started
* =============================================================================
*/
@isTest(seeAllData = False)
/** 
 * @description : This is the test class to coverage DCP_CartPriceRequest 
 */ 
public class DCP_CartPriceRequestTest {
/** 
 * @description : This is the test method to coverage DCP_CartPriceRequest 
 */ 
    public static testMethod void testData() {
        
        LIST<Static_Values__c> staticCSList = new LIST<Static_Values__c>{new Static_Values__c(name='OrderProcessSupportEmail', value__c='kanishk.singhvi@thomsonreuters.com'),
            new Static_Values__c(name='DCPCartRequestVersion',value__c='v1')};
        insert staticCSList;
        
        // insert acc
        Account acc =new account();
        acc.Name='Test';
        insert acc;
        system.assert(acc.Name=='Test','Good to Proceed');
      
        Apttus_Config2__PriceList__c plSO = APTS_TestDataFactory.createPriceList('Thomson Reuters Master - US Legal');
        insert plSO;
        
        Product2 prodObj = new Product2();
        prodObj.Name = 'Test Product';
        prodObj.ProductCode = '98765';
        prodObj.Description = 'Test Desc';
        prodObj.Service_Number__c = '87654';
        prodObj.Apttus_Filter_Brand__c = 'Test';
        prodObj.Apttus_Filter_Jurisdiction__c = 'Colorado';
        prodObj.LCRM_Sub_Bu__c = 'USL';
        prodObj.Format__c= 'Format';
        prodObj.IsActive = true;
        prodObj.Apttus_Config2__HasOptions__c = true;
        prodObj.Apttus_Config2__HasAttributes__c = true;
        prodObj.Apttus_Config2__HasDefaults__c = false;
        prodObj.CPD_Sellable_Description__c ='Display and Sell';
        insert prodObj; 
        
        Apttus_Config2__PriceListItem__c pliSO = new Apttus_Config2__PriceListItem__c();
        pliSO.Apttus_Config2__Active__c = true;
        pliSO.Apttus_Config2__ChargeType__c = 'MRC';
        pliSO.Apttus_Config2__PriceListId__c = plSO.Id;
        pliSO.Apttus_Config2__ProductId__c = prodObj.id;
        pliSO.Apttus_Config2__PriceType__c = 'One time';
        pliSO.Apttus_Config2__Frequency__c = 'One time';
        pliSO.Apttus_Config2__ListPrice__c = 250;
        database.insert(pliSO,true);
        
        Apttus_Proposal__Proposal__c propObj = new Apttus_Proposal__Proposal__c();
        propObj.Apttus_QPConfig__PriceListId__c = plSO.Id;
        propObj.Customer_Group__c = 'Law Firm';
        propObj.Apttus_Proposal__Account__c = acc.id;
        insert propObj;
        
        Apttus_Config2__ProductConfiguration__c prodConfigObj = new Apttus_Config2__ProductConfiguration__c();
        prodConfigObj.Apttus_QPConfig__Proposald__c = propObj.ID;
        prodConfigObj.Apttus_Config2__Status__c = 'New';
        prodConfigObj.Apttus_Config2__BusinessObjectId__c = propObj.Id;
        prodConfigObj.Apttus_Config2__BusinessObjectType__c = 'Proposal';
        prodConfigObj.Apttus_Config2__PriceListId__c = plSO.Id;
        prodConfigObj.Apttus_Config2__AccountId__c = acc.Id;
        insert prodConfigObj;
        
        Apttus_Config2__LineItem__c lineSO = new Apttus_Config2__LineItem__c();
                lineSO.Apttus_Config2__ConfigurationId__c = prodConfigObj.Id;
                lineSO.Apttus_Config2__PricingStatus__c = 'Pending';
                lineSO.Mark_Removed__c = true;
                lineSO.Apttus_Config2__LineNumber__c = 1;
                lineSO.Apttus_Config2__PrimaryLineNumber__c=  lineSO.Apttus_Config2__LineNumber__c;
                lineSO.Apttus_Config2__ItemSequence__c =  lineSO.Apttus_Config2__LineNumber__c;
                lineSO.Apttus_Config2__IsPrimaryLine__c = true;
        insert lineSO;
        
        /*
       String JsonMsg = '{"cartItemDetails":{"cartId":"a6p55000000CkWSAA0","actionParams":"Cart","doPricing": false,"productDetailList":[{"productRequestType": "Add","productCode": "30843862","productId": "01t4O0000087HT8","quantity": "2.0","listPrice": "2513","promoCode": "","hasAttribute": true,"attributeDetailList":[{"attributeName": "SCS_Print_Purchase_Options__c","attributeValue": "Ship & Enter Sub"}]}]}}';
       */
       /* DCP_CartPriceRequest.cartDetail reqst= new DCP_CartPriceRequest.cartDetail();
        reqst.cartId = prodConfigObj.Id;
        reqst.actionParams = 'Cart';
        
        List<DCP_CartPriceRequest.attributeDetail> adList = new List<DCP_CartPriceRequest.attributeDetail>();
        DCP_CartPriceRequest.attributeDetail ad = new DCP_CartPriceRequest.attributeDetail();
        ad.attributeName = 'SCS_Print_Purchase_Options__c';
        ad.attributeValue ='Ship & Enter Sub';
        adList.add(ad);
        
        List<DCP_CartPriceRequest.productDetail> pdList = new List<DCP_CartPriceRequest.productDetail>();
        DCP_CartPriceRequest.productDetail pd = new DCP_CartPriceRequest.productDetail();
        pd.productRequestType = 'Add';
        pd.productCode = '98765';
        pd.productId = prodObj.Id;
        pd.lineItemNumber = '1';
        pd.site = 'Canada';
        pd.quantity = '1.0';
        pd.hasAttribute= false;
        pd.listPrice ='1234';
        pd.attributeDetailList = adList;
        pdList.add(pd);
        
        reqst.productDetailList = pdList;
        DCP_CartPriceRequest.cartResponse resp = new DCP_CartPriceRequest.cartResponse();
        resp = DCP_CartPriceRequest.processCart (reqst);*/
        
        DCP_CartPriceRequest.cartDetail reqst4= new DCP_CartPriceRequest.cartDetail();
        reqst4.cartId = prodConfigObj.Id;
        reqst4.actionParams = 'Dummy';
        
        List<DCP_CartPriceRequest.attributeDetail> adList4 = new List<DCP_CartPriceRequest.attributeDetail>();
        DCP_CartPriceRequest.attributeDetail ad4 = new DCP_CartPriceRequest.attributeDetail();
        ad4.attributeName = 'SCS_Print_Purchase_Options__c';
        ad4.attributeValue ='Ship & Enter Sub';
        adList4.add(ad4);
        
        List<DCP_CartPriceRequest.productDetail> pdList4 = new List<DCP_CartPriceRequest.productDetail>();
        DCP_CartPriceRequest.productDetail pd4 = new DCP_CartPriceRequest.productDetail();
        pd4.productRequestType = 'Add';
        pd4.lineItemId = '98765';
        pd4.productId = prodObj.Id;
        pd4.site = 'Canada';
        pd4.quantity = '1.0';
        pd4.hasAttribute= true;
        pd4.listPrice ='1234';
        pd4.attributeDetailList = adList4;
        pdList4.add(pd4);
        
        reqst4.productDetailList = pdList4;
     
        DCP_CartPriceRequest.cartResponse resp4 = new DCP_CartPriceRequest.cartResponse();
        resp4 = DCP_CartPriceRequest.processCart (reqst4);
        
        
         DCP_CartPriceRequest.cartDetail reqst8= new DCP_CartPriceRequest.cartDetail();
        reqst8.cartId = prodConfigObj.Id;
        reqst8.actionParams = 'Cart';
        
        List<DCP_CartPriceRequest.attributeDetail> adList8 = new List<DCP_CartPriceRequest.attributeDetail>();
        DCP_CartPriceRequest.attributeDetail ad8 = new DCP_CartPriceRequest.attributeDetail();
        ad8.attributeName = 'SCS_Print_Purchase_Options__c';
        ad8.attributeValue ='Ship & Enter Sub';
        adList8.add(ad8);
        
        List<DCP_CartPriceRequest.lineItemArray> liArrList1 = new List<DCP_CartPriceRequest.lineItemArray>();
        DCP_CartPriceRequest.lineItemArray liArr1 = new DCP_CartPriceRequest.lineItemArray();
        liArr1.contractTerm = '1 Year';
        liArr1.billingFrequency = 'Monthly';
        liArr1.adjustmentAmount = '10.0';
        liArr1.yoY1 = '0';
        liArr1.yoY2 = '0';
        liArr1.segment = 'Corporation';
        liArrList1.add(liArr1);
        
        List<DCP_CartPriceRequest.productDetail> pdList8 = new List<DCP_CartPriceRequest.productDetail>();
        DCP_CartPriceRequest.productDetail pd8 = new DCP_CartPriceRequest.productDetail();
        pd8.productRequestType = 'Add';
        pd8.lineItemId = lineSO.id;
        pd8.productId = prodObj.Id;
        pd8.site = 'Canada';
        pd8.quantity = '1.0';
        pd8.hasAttribute= true;
        pd8.listPrice ='1234';
        pd8.lineItemArray = liArr1;
        pd8.attributeDetailList = adList8;
        pdList8.add(pd8);
        
        reqst8.productDetailList = pdList8;
        DCP_CartPriceRequest.cartResponse resp8 = new DCP_CartPriceRequest.cartResponse();
        resp8 = DCP_CartPriceRequest.processCart (reqst8);
        
        
        //Update
         DCP_CartPriceRequest.cartDetail reqst1= new DCP_CartPriceRequest.cartDetail();
        reqst1.cartId = prodConfigObj.Id;
        reqst1.actionParams = 'Cart';
        
        List<DCP_CartPriceRequest.attributeDetail> adList1 = new List<DCP_CartPriceRequest.attributeDetail>();
        DCP_CartPriceRequest.attributeDetail ad1 = new DCP_CartPriceRequest.attributeDetail();
        ad1.attributeName = 'SCS_Print_Purchase_Options__c';
        ad1.attributeValue ='Ship & Enter Sub';
        adList1.add(ad1);
        
        
        List<DCP_CartPriceRequest.productDetail> pdList1 = new List<DCP_CartPriceRequest.productDetail>();
        DCP_CartPriceRequest.productDetail pd1 = new DCP_CartPriceRequest.productDetail();
        pd1.productRequestType = 'Update';
        pd1.lineItemId = lineSO.Id;
        pd1.productId = prodObj.Id;
        pd1.site = 'Canada';
        pd1.quantity = '3.0';
        pd1.hasAttribute= true;
        pd1.listPrice ='1234';
        pd1.lineItemArray = liArr1;
        pd1.attributeDetailList = adList1;
        pdList1.add(pd1);
        
        reqst1.productDetailList = pdList1;
        DCP_CartPriceRequest.cartResponse resp1 = new DCP_CartPriceRequest.cartResponse();
        resp1 = DCP_CartPriceRequest.processCart (reqst1);
        
        //Reprice
         DCP_CartPriceRequest.cartDetail reqst3= new DCP_CartPriceRequest.cartDetail();
        reqst3.cartId = prodConfigObj.Id;
        reqst3.actionParams = 'Reprice';
        
        List<DCP_CartPriceRequest.attributeDetail> adList3 = new List<DCP_CartPriceRequest.attributeDetail>();
        DCP_CartPriceRequest.attributeDetail ad3 = new DCP_CartPriceRequest.attributeDetail();
        ad3.attributeName = '';
        ad3.attributeValue ='';
        adList3.add(ad3);
        
        List<DCP_CartPriceRequest.productDetail> pdList3 = new List<DCP_CartPriceRequest.productDetail>();
        DCP_CartPriceRequest.productDetail pd3 = new DCP_CartPriceRequest.productDetail();
        pd3.productRequestType = 'Update';
        pd3.lineItemId = lineSO.Id;
        pd3.productId = prodObj.Id;
        pd3.quantity = '3.0';
        pd3.site = 'Canada';
        pd3.hasAttribute= true;
        pd3.listPrice ='1234';
        pd3.attributeDetailList = adList3;
        pdList3.add(pd3);
        
        reqst3.productDetailList = pdList3;
        DCP_CartPriceRequest.cartResponse resp3 = new DCP_CartPriceRequest.cartResponse();
        resp3 = DCP_CartPriceRequest.processCart (reqst3);
        
        
        //Remove
         DCP_CartPriceRequest.cartDetail reqst2= new DCP_CartPriceRequest.cartDetail();
        reqst2.cartId = prodConfigObj.Id;
        reqst2.actionParams = 'Cart';
        
        List<DCP_CartPriceRequest.attributeDetail> adList2 = new List<DCP_CartPriceRequest.attributeDetail>();
        DCP_CartPriceRequest.attributeDetail ad2 = new DCP_CartPriceRequest.attributeDetail();
        ad2.attributeName = '';
        ad2.attributeValue ='';
        adList2.add(ad2);
        
        List<DCP_CartPriceRequest.productDetail> pdList2 = new List<DCP_CartPriceRequest.productDetail>();
        DCP_CartPriceRequest.productDetail pd2 = new DCP_CartPriceRequest.productDetail();
        pd2.productRequestType = 'Remove';
        pd2.lineItemId = lineSO.Id;
        pd2.productId = prodObj.Id;
        pd2.quantity = '3.0';
        pd2.site = 'Canada';
        pd2.hasAttribute= true;
        pd2.listPrice ='1234';
        pd2.attributeDetailList = adList2;
        pdList2.add(pd2);
        
        reqst2.productDetailList = pdList2;
        DCP_CartPriceRequest.cartResponse resp2 = new DCP_CartPriceRequest.cartResponse();
        resp2 = DCP_CartPriceRequest.processCart (reqst2);
        
        //Undo
         DCP_CartPriceRequest.cartDetail reqsts2= new DCP_CartPriceRequest.cartDetail();
        reqsts2.cartId = prodConfigObj.Id;
        reqsts2.actionParams = 'Cart';
        
        List<DCP_CartPriceRequest.attributeDetail> adLists2 = new List<DCP_CartPriceRequest.attributeDetail>();
        DCP_CartPriceRequest.attributeDetail ads2 = new DCP_CartPriceRequest.attributeDetail();
        ads2.attributeName = '';
        ads2.attributeValue ='';
        adLists2.add(ads2);
        
        List<DCP_CartPriceRequest.productDetail> pdLists2 = new List<DCP_CartPriceRequest.productDetail>();
        DCP_CartPriceRequest.productDetail pds2 = new DCP_CartPriceRequest.productDetail();
        pds2.productRequestType = 'Undo';
        pds2.lineItemId = lineSO.Id;
        pds2.productId = prodObj.Id;
        pds2.quantity = '3.0';
        pds2.site = 'Canada';
        pds2.hasAttribute= true;
        pds2.listPrice ='1234';
        pds2.attributeDetailList = adLists2;
        pdLists2.add(pds2);
        
        reqsts2.productDetailList = pdLists2;
        DCP_CartPriceRequest.cartResponse resps2 = new DCP_CartPriceRequest.cartResponse();
        resps2 = DCP_CartPriceRequest.processCart (reqsts2);
        
        
        
        //Reprice
         DCP_CartPriceRequest.cartDetail reqst5= new DCP_CartPriceRequest.cartDetail();
        reqst5.cartId = prodConfigObj.Id;
        reqst5.actionParams = 'Cart';
        
        List<DCP_CartPriceRequest.attributeDetail> adList5 = new List<DCP_CartPriceRequest.attributeDetail>();
        DCP_CartPriceRequest.attributeDetail ad5 = new DCP_CartPriceRequest.attributeDetail();
        ad5.attributeName = '';
        ad5.attributeValue ='';
        adList5.add(ad5);
        
        List<DCP_CartPriceRequest.productDetail> pdList5 = new List<DCP_CartPriceRequest.productDetail>();
        DCP_CartPriceRequest.productDetail pd5 = new DCP_CartPriceRequest.productDetail();
        pd5.productRequestType = 'Remove';
        pd5.lineItemId = 'abc';
        pd5.productId = prodObj.Id;
        pd5.site = 'Canada';
        pd5.quantity = '3.0';
        pd5.hasAttribute= true;
        pd5.listPrice ='1234';
        pd5.attributeDetailList = adList5;
        pdList5.add(pd5);
        
        reqst5.productDetailList = pdList5;
        DCP_CartPriceRequest.cartResponse resp5 = new DCP_CartPriceRequest.cartResponse();
        resp5 = DCP_CartPriceRequest.processCart (reqst5);
        
        
        //Remove
         DCP_CartPriceRequest.cartDetail reqst6= new DCP_CartPriceRequest.cartDetail();
        reqst6.cartId = prodConfigObj.Id;
        reqst6.actionParams = 'Reprice';
        
        List<DCP_CartPriceRequest.attributeDetail> adList6 = new List<DCP_CartPriceRequest.attributeDetail>();
        DCP_CartPriceRequest.attributeDetail ad6 = new DCP_CartPriceRequest.attributeDetail();
        ad6.attributeName = '';
        ad6.attributeValue ='';
        adList6.add(ad6);
        
        List<DCP_CartPriceRequest.productDetail> pdList6 = new List<DCP_CartPriceRequest.productDetail>();
        DCP_CartPriceRequest.productDetail pd6 = new DCP_CartPriceRequest.productDetail();
        pd6.productRequestType = 'Remove';
        pd6.lineItemId = lineSO.Id;
        pd6.productId = prodObj.Id;
        pd6.site = 'Canada';
        pd6.quantity = '3.0';
        pd6.hasAttribute= true;
        pd6.listPrice ='1234';
        pd6.attributeDetailList = adList6;
        pdList6.add(pd6);
        
        reqst6.productDetailList = pdList6;
        DCP_CartPriceRequest.cartResponse resp6 = new DCP_CartPriceRequest.cartResponse();
        resp6 = DCP_CartPriceRequest.processCart (reqst6);
        
    //UNDO
         DCP_CartPriceRequest.cartDetail reqst61= new DCP_CartPriceRequest.cartDetail();
        reqst61.cartId = prodConfigObj.Id;
        reqst61.actionParams = 'Cart';
        
        List<DCP_CartPriceRequest.attributeDetail> adList61 = new List<DCP_CartPriceRequest.attributeDetail>();
        DCP_CartPriceRequest.attributeDetail ad61 = new DCP_CartPriceRequest.attributeDetail();
        ad61.attributeName = '';
        ad61.attributeValue ='';
        adList61.add(ad61);
        
        List<DCP_CartPriceRequest.productDetail> pdList61 = new List<DCP_CartPriceRequest.productDetail>();
        DCP_CartPriceRequest.productDetail pd61 = new DCP_CartPriceRequest.productDetail();
        pd61.productRequestType = 'Undo';
        pd61.lineItemId = lineSO.Id;
        pd61.productId = prodObj.Id;
        pd61.site = 'Canada';
        pd61.quantity = '3.0';
        pd61.hasAttribute= true;
        pd61.listPrice ='1234';
        pd61.attributeDetailList = adList61;
        pdList61.add(pd61);
        
        reqst61.productDetailList = pdList61;
        DCP_CartPriceRequest.cartResponse resp61 = new DCP_CartPriceRequest.cartResponse();
        resp61 = DCP_CartPriceRequest.processCart (reqst61);
        
        
        //Reprice
         DCP_CartPriceRequest.cartDetail reqst7= new DCP_CartPriceRequest.cartDetail();
        reqst7.cartId = '';
        reqst7.actionParams = 'Reprice';
        
        List<DCP_CartPriceRequest.attributeDetail> adList7 = new List<DCP_CartPriceRequest.attributeDetail>();
        DCP_CartPriceRequest.attributeDetail ad7 = new DCP_CartPriceRequest.attributeDetail();
        ad7.attributeName = '';
        ad7.attributeValue ='';
        adList7.add(ad7);
        
        List<DCP_CartPriceRequest.productDetail> pdList7 = new List<DCP_CartPriceRequest.productDetail>();
        DCP_CartPriceRequest.productDetail pd7 = new DCP_CartPriceRequest.productDetail();
        pd7.productRequestType = '';
        pd7.lineItemId = '';
        pd7.productId = prodObj.Id;
        pd7.site = 'Canada';
        pd7.quantity = '3.0';
        pd7.hasAttribute= true;
        pd7.listPrice ='1234';
        pd7.attributeDetailList = adList7;
        pdList7.add(pd7);
        
        reqst7.productDetailList = pdList7;
        DCP_CartPriceRequest.cartResponse resp7 = new DCP_CartPriceRequest.cartResponse();
        resp7 = DCP_CartPriceRequest.processCart (reqst7);
          
        //Reprice
         DCP_CartPriceRequest.cartDetail reqst9= new DCP_CartPriceRequest.cartDetail();
        reqst9.cartId = prodConfigObj.Id;
        reqst9.actionParams = 'Cart';
        
        List<DCP_CartPriceRequest.attributeDetail> adList9 = new List<DCP_CartPriceRequest.attributeDetail>();
        DCP_CartPriceRequest.attributeDetail ad9 = new DCP_CartPriceRequest.attributeDetail();
        ad9.attributeName = '';
        ad9.attributeValue ='';
        adList9.add(ad9);
        
        List<DCP_CartPriceRequest.productDetail> pdList9 = new List<DCP_CartPriceRequest.productDetail>();
        DCP_CartPriceRequest.productDetail pd9 = new DCP_CartPriceRequest.productDetail();
        pd9.productRequestType = 'ADA';
        pd9.lineItemId = lineSO.Id;
        pd9.productId = prodObj.Id;
        pd9.site = 'Canada';
        pd9.quantity = '3.0';
        pd9.hasAttribute= true;
        pd9.listPrice ='1234';
        pd9.attributeDetailList = adList9;
        pdList9.add(pd9);
        
        reqst9.productDetailList = pdList9;
        DCP_CartPriceRequest.cartResponse resp9 = new DCP_CartPriceRequest.cartResponse();
        resp9 = DCP_CartPriceRequest.processCart (reqst9);   
    }

    /** 
     * @description : This is the test method to coverage DCP_CartPriceRequest 
     */ 
     public static testMethod void testData2() {
        
        LIST<Static_Values__c> staticCSList = new LIST<Static_Values__c>{new Static_Values__c(name='OrderProcessSupportEmail', value__c='kanishk.singhvi@thomsonreuters.com'),
            new Static_Values__c(name='DCPCartRequestVersion',value__c='v1')};
        insert staticCSList;
        
        // insert acc
        Account acc =new account();
        acc.Name='Test';
        insert acc;
        system.assert(acc.Name=='Test','Good to Proceed');
      
        Apttus_Config2__PriceList__c plSO = APTS_TestDataFactory.createPriceList('Thomson Reuters Master - US Legal');
        insert plSO;
        
        Product2 prodObj = new Product2();
        prodObj.Name = 'Test Product';
        prodObj.ProductCode = '98765';
        prodObj.Description = 'Test Desc';
        prodObj.Service_Number__c = '87654';
        prodObj.Apttus_Filter_Brand__c = 'Test';
        prodObj.Apttus_Filter_Jurisdiction__c = 'Colorado';
        prodObj.LCRM_Sub_Bu__c = 'USL';
        prodObj.Format__c= 'Format';
        prodObj.IsActive = true;
        prodObj.Apttus_Config2__HasOptions__c = true;
        prodObj.Apttus_Config2__HasAttributes__c = true;
        prodObj.Apttus_Config2__HasDefaults__c = false;
        prodObj.CPD_Sellable_Description__c ='Display and Sell';
        insert prodObj; 
        
        Apttus_Config2__PriceListItem__c pliSO = new Apttus_Config2__PriceListItem__c();
        pliSO.Apttus_Config2__Active__c = true;
        pliSO.Apttus_Config2__ChargeType__c = 'MRC';
        pliSO.Apttus_Config2__PriceListId__c = plSO.Id;
        pliSO.Apttus_Config2__ProductId__c = prodObj.id;
        pliSO.Apttus_Config2__PriceType__c = 'One time';
        pliSO.Apttus_Config2__Frequency__c = 'One time';
        pliSO.Apttus_Config2__ListPrice__c = 250;
        database.insert(pliSO,true);
        
        Apttus_Proposal__Proposal__c propObj = new Apttus_Proposal__Proposal__c();
        propObj.Apttus_QPConfig__PriceListId__c = plSO.Id;
        propObj.Customer_Group__c = 'Law Firm';
        propObj.Apttus_Proposal__Account__c = acc.id;
        insert propObj;
        
        Apttus_Config2__ProductConfiguration__c prodConfigObj = new Apttus_Config2__ProductConfiguration__c();
        prodConfigObj.Apttus_QPConfig__Proposald__c = propObj.ID;
        prodConfigObj.Apttus_Config2__Status__c = 'New';
        prodConfigObj.Apttus_Config2__BusinessObjectId__c = propObj.Id;
        prodConfigObj.Apttus_Config2__BusinessObjectType__c = 'Proposal';
        prodConfigObj.Apttus_Config2__PriceListId__c = plSO.Id;
        prodConfigObj.Apttus_Config2__AccountId__c = acc.Id;
        insert prodConfigObj;
        
        Apttus_Config2__LineItem__c lineSO = new Apttus_Config2__LineItem__c();
                lineSO.Apttus_Config2__ConfigurationId__c = prodConfigObj.Id;
                lineSO.Apttus_Config2__PricingStatus__c = 'Pending';
                lineSO.Mark_Removed__c = true;
                lineSO.Apttus_Config2__LineNumber__c = 11;
                lineSO.Apttus_Config2__PrimaryLineNumber__c=  lineSO.Apttus_Config2__LineNumber__c;
                lineSO.Apttus_Config2__ItemSequence__c =  lineSO.Apttus_Config2__LineNumber__c;
                lineSO.Apttus_Config2__IsPrimaryLine__c = true;
        insert lineSO;
        
            //Reprice 11 1111th june 20211
         
        DCP_CartPriceRequest.cartDetail reqst11= new DCP_CartPriceRequest.cartDetail();
        reqst11.cartId = prodConfigObj.Id;
        reqst11.actionParams = 'Cart';
        
        List<DCP_CartPriceRequest.attributeDetail> adList11 = new List<DCP_CartPriceRequest.attributeDetail>();
        DCP_CartPriceRequest.attributeDetail ad11 = new DCP_CartPriceRequest.attributeDetail();
        ad11.attributeName = '';
        ad11.attributeValue ='';
        adList11.add(ad11);
        
        List<DCP_CartPriceRequest.lineItemArray> liArrList1 = new List<DCP_CartPriceRequest.lineItemArray>();
        DCP_CartPriceRequest.lineItemArray liArr1 = new DCP_CartPriceRequest.lineItemArray();
        liArr1.contractTerm = '1 Year';
        liArr1.billingFrequency = 'Monthly';
        liArr1.adjustmentAmount = '10.0';
        liArr1.yoY1 = '0';
        liArr1.yoY2 = '0';
        liArr1.segment = 'Corporation';
        liArrList1.add(liArr1);
        
        List<DCP_CartPriceRequest.productDetail> pdList11 = new List<DCP_CartPriceRequest.productDetail>();
        DCP_CartPriceRequest.productDetail pd11 = new DCP_CartPriceRequest.productDetail();
        pd11.productRequestType = 'Undo';
        pd11.lineItemId = lineSO.Id;
        pd11.productId = prodObj.Id;
        pd11.site = 'Canada';
        pd11.quantity = '3.0';
        pd11.hasAttribute= true;
        pd11.listPrice ='11234';
        pd11.lineItemArray = liArr1 ;
        pd11.attributeDetailList = adList11;
        pdList11.add(pd11);
        
        reqst11.productDetailList = pdList11;
        DCP_CartPriceRequest.cartResponse resp11 = new DCP_CartPriceRequest.cartResponse();
        resp11 = DCP_CartPriceRequest.processCart (reqst11);  
         //Reprice 10 11th june 2021
         DCP_CartPriceRequest.cartDetail reqst10= new DCP_CartPriceRequest.cartDetail();
        reqst10.cartId = prodConfigObj.Id;
        reqst10.actionParams = 'Cart';
        
        List<DCP_CartPriceRequest.attributeDetail> adList10 = new List<DCP_CartPriceRequest.attributeDetail>();
        DCP_CartPriceRequest.attributeDetail ad10 = new DCP_CartPriceRequest.attributeDetail();
        ad10.attributeName = '';
        ad10.attributeValue ='';
        adList10.add(ad10);
        
        List<DCP_CartPriceRequest.productDetail> pdList10 = new List<DCP_CartPriceRequest.productDetail>();
        DCP_CartPriceRequest.productDetail pd10 = new DCP_CartPriceRequest.productDetail();
        pd10.productRequestType = 'Remove';
        pd10.lineItemId = lineSO.Id;
        pd10.productId = prodObj.Id;
        pd10.site = 'Canada';
        pd10.quantity = '3.0';
        pd10.hasAttribute= true;
        pd10.listPrice ='1234';
        pd10.attributeDetailList = adList10;
        pdList10.add(pd10);
        
        reqst10.productDetailList = pdList10;
        DCP_CartPriceRequest.cartResponse resp10 = new DCP_CartPriceRequest.cartResponse();
        resp10 = DCP_CartPriceRequest.processCart (reqst10);
         
    }

    /** 
     * @description : This is the test method to coverage DCP_CartPriceRequest 
     */ 
    public static testMethod void testData3() {
        
        LIST<Static_Values__c> staticCSList = new LIST<Static_Values__c>{new Static_Values__c(name='OrderProcessSupportEmail', value__c='kanishk.singhvi@thomsonreuters.com'),
                                                                        new Static_Values__c(name='DCPCartRequestVersion',value__c='v2'),
                                                                        new Static_Values__c(name='LineItemHalf',value__c='1'),
                                                                        new Static_Values__c(name='LineItemLimit',value__c='2') };
        insert staticCSList;
        
        // insert acc
        Account acc =new account();
        acc.Name='Test';
        insert acc;
        system.assert(acc.Name=='Test','Good to Proceed');
      
        Apttus_Config2__PriceList__c plSO = APTS_TestDataFactory.createPriceList('Thomson Reuters Master - US Legal');
        insert plSO;
        
        Product2 prodObj = new Product2();
        prodObj.Name = 'Test Product';
        prodObj.ProductCode = '98765';
        prodObj.Description = 'Test Desc';
        prodObj.Service_Number__c = '87654';
        prodObj.Apttus_Filter_Brand__c = 'Test';
        prodObj.Apttus_Filter_Jurisdiction__c = 'Colorado';
        prodObj.LCRM_Sub_Bu__c = 'USL';
        prodObj.Format__c= 'Format';
        prodObj.IsActive = true;
        prodObj.Apttus_Config2__HasOptions__c = true;
        prodObj.Apttus_Config2__HasAttributes__c = true;
        prodObj.Apttus_Config2__HasDefaults__c = false;
        prodObj.CPD_Sellable_Description__c ='Display and Sell';
        insert prodObj; 
        
        Apttus_Config2__PriceListItem__c pliSO = new Apttus_Config2__PriceListItem__c();
        pliSO.Apttus_Config2__Active__c = true;
        pliSO.Apttus_Config2__ChargeType__c = 'MRC';
        pliSO.Apttus_Config2__PriceListId__c = plSO.Id;
        pliSO.Apttus_Config2__ProductId__c = prodObj.id;
        pliSO.Apttus_Config2__PriceType__c = 'One time';
        pliSO.Apttus_Config2__Frequency__c = 'One time';
        pliSO.Apttus_Config2__ListPrice__c = 250;
        database.insert(pliSO,true);
        
        Apttus_Proposal__Proposal__c propObj = new Apttus_Proposal__Proposal__c();
        propObj.Apttus_QPConfig__PriceListId__c = plSO.Id;
        propObj.Customer_Group__c = 'Law Firm';
        propObj.Apttus_Proposal__Account__c = acc.id;
        insert propObj;
        
        Apttus_Config2__ProductConfiguration__c prodConfigObj = new Apttus_Config2__ProductConfiguration__c();
        prodConfigObj.Apttus_QPConfig__Proposald__c = propObj.ID;
        prodConfigObj.Apttus_Config2__Status__c = 'New';
        prodConfigObj.Apttus_Config2__BusinessObjectId__c = propObj.Id;
        prodConfigObj.Apttus_Config2__BusinessObjectType__c = 'Proposal';
        prodConfigObj.Apttus_Config2__PriceListId__c = plSO.Id;
        prodConfigObj.Apttus_Config2__AccountId__c = acc.Id;
        insert prodConfigObj;
        
        Apttus_Config2__LineItem__c lineSO = new Apttus_Config2__LineItem__c();
                lineSO.Apttus_Config2__ConfigurationId__c = prodConfigObj.Id;
                lineSO.Apttus_Config2__PricingStatus__c = 'Pending';
                lineSO.Mark_Removed__c = true;
                lineSO.Apttus_Config2__LineNumber__c = 11;
                lineSO.Apttus_Config2__PrimaryLineNumber__c=  lineSO.Apttus_Config2__LineNumber__c;
                lineSO.Apttus_Config2__ItemSequence__c =  lineSO.Apttus_Config2__LineNumber__c;
                lineSO.Apttus_Config2__IsPrimaryLine__c = true;
        insert lineSO;
       List<DCP_CartPriceRequest.lineItemArray> liArrList1 = new List<DCP_CartPriceRequest.lineItemArray>();
        DCP_CartPriceRequest.lineItemArray liArr1 = new DCP_CartPriceRequest.lineItemArray();
        liArr1.contractTerm = '1 Year';
        liArr1.billingFrequency = 'Monthly';
        liArr1.adjustmentAmount = '10.0';
        liArr1.yoY1 = '0';
        liArr1.yoY2 = '0';
        liArrList1.add(liArr1);
        
        UE_proposal__c pros = new UE_Proposal__c(lineitemId__c = lineSo.Id,isLineActive__c = true,type_of_Line__c='US Legal');
        insert pros;
        
            //Reprice 11 1111th june 20211
         DCP_CartPriceRequest.cartDetail reqst12= new DCP_CartPriceRequest.cartDetail();
        reqst12.cartId = prodConfigObj.Id;
        reqst12.actionParams = 'Cart';
        
        List<DCP_CartPriceRequest.attributeDetail> adList12 = new List<DCP_CartPriceRequest.attributeDetail>();
        DCP_CartPriceRequest.attributeDetail ad12 = new DCP_CartPriceRequest.attributeDetail();
        ad12.attributeName = '';
        ad12.attributeValue ='';
        adList12.add(ad12);
        
        List<DCP_CartPriceRequest.productDetail> pdList12 = new List<DCP_CartPriceRequest.productDetail>();
        DCP_CartPriceRequest.productDetail pd12 = new DCP_CartPriceRequest.productDetail();
        pd12.productRequestType = 'Add';
        pd12.lineItemId = lineSO.Id;
        pd12.productId = prodObj.Id;
        pd12.baseProduct = prodObj.Id;
        pd12.site = 'US Legal';
        pd12.quantity = '3.0';
        pd12.hasAttribute= true;
        pd12.lineNumber ='10';
        pd12.listPrice ='11234';
        pd12.lineItemArray = liArr1;
        pd12.attributeDetailList = adList12;
        pdList12.add(pd12);
        
        reqst12.productDetailList = pdList12;
        DCP_CartPriceRequest.cartResponse resp12 = new DCP_CartPriceRequest.cartResponse();
        resp12 = DCP_CartPriceRequest.processCart (reqst12);  
         //Reprice 10 11th june 2021
         DCP_CartPriceRequest.cartDetail reqst10= new DCP_CartPriceRequest.cartDetail();
        reqst10.cartId = prodConfigObj.Id;
        reqst10.actionParams = 'Cart';
        
        List<DCP_CartPriceRequest.attributeDetail> adList10 = new List<DCP_CartPriceRequest.attributeDetail>();
        DCP_CartPriceRequest.attributeDetail ad10 = new DCP_CartPriceRequest.attributeDetail();
        ad10.attributeName = '';
        ad10.attributeValue ='';
        adList10.add(ad10);
        
        List<DCP_CartPriceRequest.productDetail> pdList10 = new List<DCP_CartPriceRequest.productDetail>();
        DCP_CartPriceRequest.productDetail pd10 = new DCP_CartPriceRequest.productDetail();
        pd10.productRequestType = 'Update';
        pd10.lineItemId = lineSO.Id;
        pd10.productId = prodObj.Id;
        pd10.baseProduct ='';
        pd10.site = 'US Legal';
        pd10.quantity = '3.0';
        pd10.hasAttribute= true;
        pd10.lineNumber ='10';
        pd10.listPrice ='1234';
        pd10.attributeDetailList = adList10;
        pdList10.add(pd10);
        
        reqst10.productDetailList = pdList10;
        DCP_CartPriceRequest.cartResponse resp10 = new DCP_CartPriceRequest.cartResponse();
        resp10 = DCP_CartPriceRequest.processCart (reqst10);

        DCP_CartPriceRequest.cartDetail reqst11= new DCP_CartPriceRequest.cartDetail();
        reqst11.cartId = prodConfigObj.Id;
        reqst11.actionParams = 'Cart';
        
        List<DCP_CartPriceRequest.attributeDetail> adList11 = new List<DCP_CartPriceRequest.attributeDetail>();
        DCP_CartPriceRequest.attributeDetail ad11 = new DCP_CartPriceRequest.attributeDetail();
        ad11.attributeName = '';
        ad11.attributeValue ='';
        adList11.add(ad11);
        
        List<DCP_CartPriceRequest.productDetail> pdList11 = new List<DCP_CartPriceRequest.productDetail>();
        DCP_CartPriceRequest.productDetail pd11 = new DCP_CartPriceRequest.productDetail();
        pd11.productRequestType = 'Remove';
        pd11.lineItemId = lineSO.Id;
        pd11.productId = prodObj.Id;
        pd11.baseProduct ='';
        pd11.site = 'US Legal';
        pd11.quantity = '3.0';
        pd11.lineNumber ='10';
        pd11.hasAttribute= true;
        pd11.listPrice ='11234';
        pd11.attributeDetailList = adList11;
        pdList11.add(pd11);
        
        reqst11.productDetailList = pdList11;
        DCP_CartPriceRequest.cartResponse resp11 = new DCP_CartPriceRequest.cartResponse();
        resp11 = DCP_CartPriceRequest.processCart (reqst11);  
       DCP_CartPriceRequest.cartDetail reqst13= new DCP_CartPriceRequest.cartDetail();
        reqst13.cartId = prodConfigObj.Id;
        reqst13.actionParams = 'Cart';
        
        List<DCP_CartPriceRequest.attributeDetail> adList13 = new List<DCP_CartPriceRequest.attributeDetail>();
        DCP_CartPriceRequest.attributeDetail ad13 = new DCP_CartPriceRequest.attributeDetail();
        ad13.attributeName = '';
        ad13.attributeValue ='';
        adList13.add(ad13);
        
        List<DCP_CartPriceRequest.productDetail> pdList13 = new List<DCP_CartPriceRequest.productDetail>();
        DCP_CartPriceRequest.productDetail pd13 = new DCP_CartPriceRequest.productDetail();
        pd13.productRequestType = 'Add';
        pd13.lineItemId = lineSO.Id;
        pd13.productId = prodObj.Id;
        pd13.site = 'US Legal';
        pd13.quantity = '3.0';
        pd13.hasAttribute= true;
        pd13.lineNumber ='10';
        pd13.baseProduct = prodObj.Id;
        pd13.listPrice ='11234';
        pd13.lineItemArray = liArr1;
        pd13.attributeDetailList = adList13;
        pdList13.add(pd13);
        
        reqst13.productDetailList = pdList13;
        DCP_CartPriceRequest.cartResponse resp13 = new DCP_CartPriceRequest.cartResponse();
        resp13 = DCP_CartPriceRequest.processCart (reqst13);  
        Map<String,String> errorHandlerMap = new Map<String,String>{'objectName'=>'Quote/Proposal'};
        DCPCartMultiProductRequestUtility.logException(errorHandlerMap);
         
    }
    
    /** 
     * @description : This is the test method to coverage DCP_CartPriceRequest 
     */
    public static testMethod void testSegments(){
        String plan = 'WestLaw';
        Product2 prodObj = new Product2();
        prodObj.Name = 'Test Product';
        prodObj.ProductCode = '98765';
        prodObj.Description = 'Test Desc';
        prodObj.Service_Number__c = '87654';
        prodObj.Apttus_Filter_Brand__c = 'Test';
        prodObj.Apttus_Filter_Jurisdiction__c = 'Colorado';
        prodObj.LCRM_Sub_Bu__c = 'USL';
        prodObj.Format__c= 'Format';
        prodObj.IsActive = true;
        prodObj.Family = 'WESTLAW';
        prodObj.Apttus_Config2__HasOptions__c = true;
        prodObj.Apttus_Config2__HasAttributes__c = true;
        prodObj.Apttus_Config2__HasDefaults__c = false;
        prodObj.CPD_Sellable_Description__c ='Display and Sell';
        insert prodObj;
        Test.startTest();
        DCPCartMultiProductRequestUtility.validateSegment('Corporate SMB',prodObj.Id,'Corporation');
        DCPCartMultiProductRequestUtility.validateSegment('Small Law',prodObj.Id,'Law Firm');
        DCPCartMultiProductRequestUtility.validateSegment('Government',prodObj.Id,'Government');
        prodObj.Family = 'PRACTICAL LAW';
        update prodObj;
        DCPCartMultiProductRequestUtility.validateSegment('Small Law',prodObj.Id,'Law Firm');
        
        system.assert(plan=='Westlaw','Westlaw Plan');
        
        Test.stopTest();
        
    }
    
}