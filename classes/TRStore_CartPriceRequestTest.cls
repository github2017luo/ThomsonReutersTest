/* Class: TRStore_CartPriceRequestTest
* Purpose: Coverage for  Class TRStore_CartPriceRequest
* Created: 20-May-2020
* Author: Kanishk
* 
* CHANGE HISTORY
* =============================================================================
* Date         Name             JIRA        Description
* 20-May-2020  Kanishk          DUE-2299   Test Coverage Started
* 2020-06-22   Avudaiappan A    DUE-3631   Added lineItemNumber as an additional param
* 2020-07-10   Avudaiappan A    DUE-3883   Added TRStore Site/ site as a param
* 2020-08-07   Avudaiappan A     DUE-4362   Removed Add call & In update call to update lineitem with product & create ProdAttr
* 2020-12-28   Avudaiappan A     DUE-7653   Added the changes for UNDO CART
* =============================================================================
*/
@isTest(seeAllData = False)
/** 
 * @description : This is the test class to coverage TRStore_CartPriceRequest 
 */ 
public class TRStore_CartPriceRequestTest {
    /** 
 * @description : This is the test method to coverage TRStore_CartPriceRequest 
 */ 
    public static testMethod void testData() {
        
        LIST<Static_Values__c> staticCSList = new LIST<Static_Values__c>{new Static_Values__c(name='OrderProcessSupportEmail', value__c='kanishk.singhvi@thomsonreuters.com') };
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
       /* TRStore_CartPriceRequest.cartDetail reqst= new TRStore_CartPriceRequest.cartDetail();
        reqst.cartId = prodConfigObj.Id;
        reqst.actionParams = 'Cart';
        
        List<TRStore_CartPriceRequest.attributeDetail> adList = new List<TRStore_CartPriceRequest.attributeDetail>();
        TRStore_CartPriceRequest.attributeDetail ad = new TRStore_CartPriceRequest.attributeDetail();
        ad.attributeName = 'SCS_Print_Purchase_Options__c';
        ad.attributeValue ='Ship & Enter Sub';
        adList.add(ad);
        
        List<TRStore_CartPriceRequest.productDetail> pdList = new List<TRStore_CartPriceRequest.productDetail>();
        TRStore_CartPriceRequest.productDetail pd = new TRStore_CartPriceRequest.productDetail();
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
        TRStore_CartPriceRequest.cartResponse resp = new TRStore_CartPriceRequest.cartResponse();
        resp = TRStore_CartPriceRequest.processCart (reqst);*/
        
        TRStore_CartPriceRequest.cartDetail reqst4= new TRStore_CartPriceRequest.cartDetail();
        reqst4.cartId = prodConfigObj.Id;
        reqst4.actionParams = 'Dummy';
        
        List<TRStore_CartPriceRequest.attributeDetail> adList4 = new List<TRStore_CartPriceRequest.attributeDetail>();
        TRStore_CartPriceRequest.attributeDetail ad4 = new TRStore_CartPriceRequest.attributeDetail();
        ad4.attributeName = 'SCS_Print_Purchase_Options__c';
        ad4.attributeValue ='Ship & Enter Sub';
        adList4.add(ad4);
        
        List<TRStore_CartPriceRequest.productDetail> pdList4 = new List<TRStore_CartPriceRequest.productDetail>();
        TRStore_CartPriceRequest.productDetail pd4 = new TRStore_CartPriceRequest.productDetail();
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
        TRStore_CartPriceRequest.cartResponse resp4 = new TRStore_CartPriceRequest.cartResponse();
        resp4 = TRStore_CartPriceRequest.processCart (reqst4);
        
        
         TRStore_CartPriceRequest.cartDetail reqst8= new TRStore_CartPriceRequest.cartDetail();
        reqst8.cartId = prodConfigObj.Id;
        reqst8.actionParams = 'Cart';
        
        List<TRStore_CartPriceRequest.attributeDetail> adList8 = new List<TRStore_CartPriceRequest.attributeDetail>();
        TRStore_CartPriceRequest.attributeDetail ad8 = new TRStore_CartPriceRequest.attributeDetail();
        ad8.attributeName = 'SCS_Print_Purchase_Options__c';
        ad8.attributeValue ='Ship & Enter Sub';
        adList8.add(ad8);
        
        List<TRStore_CartPriceRequest.productDetail> pdList8 = new List<TRStore_CartPriceRequest.productDetail>();
        TRStore_CartPriceRequest.productDetail pd8 = new TRStore_CartPriceRequest.productDetail();
        pd8.productRequestType = 'Add';
        pd8.lineItemId = lineSO.id;
        pd8.productId = prodObj.Id;
        pd8.site = 'Canada';
        pd8.quantity = '1.0';
        pd8.hasAttribute= true;
        pd8.listPrice ='1234';
        pd8.attributeDetailList = adList8;
        pdList8.add(pd8);
        
        reqst8.productDetailList = pdList8;
        TRStore_CartPriceRequest.cartResponse resp8 = new TRStore_CartPriceRequest.cartResponse();
        resp8 = TRStore_CartPriceRequest.processCart (reqst8);
        
        
        //Update
         TRStore_CartPriceRequest.cartDetail reqst1= new TRStore_CartPriceRequest.cartDetail();
        reqst1.cartId = prodConfigObj.Id;
        reqst1.actionParams = 'Cart';
        
        List<TRStore_CartPriceRequest.attributeDetail> adList1 = new List<TRStore_CartPriceRequest.attributeDetail>();
        TRStore_CartPriceRequest.attributeDetail ad1 = new TRStore_CartPriceRequest.attributeDetail();
        ad1.attributeName = 'SCS_Print_Purchase_Options__c';
        ad1.attributeValue ='Ship & Enter Sub';
        adList1.add(ad1);
        
        List<TRStore_CartPriceRequest.productDetail> pdList1 = new List<TRStore_CartPriceRequest.productDetail>();
        TRStore_CartPriceRequest.productDetail pd1 = new TRStore_CartPriceRequest.productDetail();
        pd1.productRequestType = 'Update';
        pd1.lineItemId = lineSO.Id;
        pd1.productId = prodObj.Id;
        pd1.site = 'Canada';
        pd1.quantity = '3.0';
        pd1.hasAttribute= false;
        pd1.listPrice ='1234';
        pd1.attributeDetailList = adList1;
        pdList1.add(pd1);
        
        reqst1.productDetailList = pdList1;
        TRStore_CartPriceRequest.cartResponse resp1 = new TRStore_CartPriceRequest.cartResponse();
        resp1 = TRStore_CartPriceRequest.processCart (reqst1);
        
        //Reprice
         TRStore_CartPriceRequest.cartDetail reqst3= new TRStore_CartPriceRequest.cartDetail();
        reqst3.cartId = prodConfigObj.Id;
        reqst3.actionParams = 'Reprice';
        
        List<TRStore_CartPriceRequest.attributeDetail> adList3 = new List<TRStore_CartPriceRequest.attributeDetail>();
        TRStore_CartPriceRequest.attributeDetail ad3 = new TRStore_CartPriceRequest.attributeDetail();
        ad3.attributeName = '';
        ad3.attributeValue ='';
        adList3.add(ad3);
        
        List<TRStore_CartPriceRequest.productDetail> pdList3 = new List<TRStore_CartPriceRequest.productDetail>();
        TRStore_CartPriceRequest.productDetail pd3 = new TRStore_CartPriceRequest.productDetail();
        pd3.productRequestType = 'Update';
        pd3.lineItemId = lineSO.Id;
        pd3.productId = prodObj.Id;
        pd3.quantity = '3.0';
        pd3.site = 'Canada';
        pd3.hasAttribute= false;
        pd3.listPrice ='1234';
        pd3.attributeDetailList = adList3;
        pdList3.add(pd3);
        
        reqst3.productDetailList = pdList3;
        TRStore_CartPriceRequest.cartResponse resp3 = new TRStore_CartPriceRequest.cartResponse();
        resp3 = TRStore_CartPriceRequest.processCart (reqst3);
        
        
        //Remove
         TRStore_CartPriceRequest.cartDetail reqst2= new TRStore_CartPriceRequest.cartDetail();
        reqst2.cartId = prodConfigObj.Id;
        reqst2.actionParams = 'Cart';
        
        List<TRStore_CartPriceRequest.attributeDetail> adList2 = new List<TRStore_CartPriceRequest.attributeDetail>();
        TRStore_CartPriceRequest.attributeDetail ad2 = new TRStore_CartPriceRequest.attributeDetail();
        ad2.attributeName = '';
        ad2.attributeValue ='';
        adList2.add(ad2);
        
        List<TRStore_CartPriceRequest.productDetail> pdList2 = new List<TRStore_CartPriceRequest.productDetail>();
        TRStore_CartPriceRequest.productDetail pd2 = new TRStore_CartPriceRequest.productDetail();
        pd2.productRequestType = 'Remove';
        pd2.lineItemId = lineSO.Id;
        pd2.productId = prodObj.Id;
        pd2.quantity = '3.0';
        pd2.site = 'Canada';
        pd2.hasAttribute= false;
        pd2.listPrice ='1234';
        pd2.attributeDetailList = adList2;
        pdList2.add(pd2);
        
        reqst2.productDetailList = pdList2;
        TRStore_CartPriceRequest.cartResponse resp2 = new TRStore_CartPriceRequest.cartResponse();
        resp2 = TRStore_CartPriceRequest.processCart (reqst2);
        
        //Undo
         TRStore_CartPriceRequest.cartDetail reqsts2= new TRStore_CartPriceRequest.cartDetail();
        reqsts2.cartId = prodConfigObj.Id;
        reqsts2.actionParams = 'Cart';
        
        List<TRStore_CartPriceRequest.attributeDetail> adLists2 = new List<TRStore_CartPriceRequest.attributeDetail>();
        TRStore_CartPriceRequest.attributeDetail ads2 = new TRStore_CartPriceRequest.attributeDetail();
        ads2.attributeName = '';
        ads2.attributeValue ='';
        adLists2.add(ads2);
        
        List<TRStore_CartPriceRequest.productDetail> pdLists2 = new List<TRStore_CartPriceRequest.productDetail>();
        TRStore_CartPriceRequest.productDetail pds2 = new TRStore_CartPriceRequest.productDetail();
        pds2.productRequestType = 'Undo';
        pds2.lineItemId = lineSO.Id;
        pds2.productId = prodObj.Id;
        pds2.quantity = '3.0';
        pds2.site = 'Canada';
        pds2.hasAttribute= false;
        pds2.listPrice ='1234';
        pds2.attributeDetailList = adLists2;
        pdLists2.add(pds2);
        
        reqsts2.productDetailList = pdLists2;
        TRStore_CartPriceRequest.cartResponse resps2 = new TRStore_CartPriceRequest.cartResponse();
        resps2 = TRStore_CartPriceRequest.processCart (reqsts2);
        
        
        
        //Reprice
         TRStore_CartPriceRequest.cartDetail reqst5= new TRStore_CartPriceRequest.cartDetail();
        reqst5.cartId = prodConfigObj.Id;
        reqst5.actionParams = 'Cart';
        
        List<TRStore_CartPriceRequest.attributeDetail> adList5 = new List<TRStore_CartPriceRequest.attributeDetail>();
        TRStore_CartPriceRequest.attributeDetail ad5 = new TRStore_CartPriceRequest.attributeDetail();
        ad5.attributeName = '';
        ad5.attributeValue ='';
        adList5.add(ad5);
        
        List<TRStore_CartPriceRequest.productDetail> pdList5 = new List<TRStore_CartPriceRequest.productDetail>();
        TRStore_CartPriceRequest.productDetail pd5 = new TRStore_CartPriceRequest.productDetail();
        pd5.productRequestType = 'Remove';
        pd5.lineItemId = 'abc';
        pd5.productId = prodObj.Id;
        pd5.site = 'Canada';
        pd5.quantity = '3.0';
        pd5.hasAttribute= false;
        pd5.listPrice ='1234';
        pd5.attributeDetailList = adList5;
        pdList5.add(pd5);
        
        reqst5.productDetailList = pdList5;
        TRStore_CartPriceRequest.cartResponse resp5 = new TRStore_CartPriceRequest.cartResponse();
        resp5 = TRStore_CartPriceRequest.processCart (reqst5);
        
        
        //Remove
         TRStore_CartPriceRequest.cartDetail reqst6= new TRStore_CartPriceRequest.cartDetail();
        reqst6.cartId = prodConfigObj.Id;
        reqst6.actionParams = 'Reprice';
        
        List<TRStore_CartPriceRequest.attributeDetail> adList6 = new List<TRStore_CartPriceRequest.attributeDetail>();
        TRStore_CartPriceRequest.attributeDetail ad6 = new TRStore_CartPriceRequest.attributeDetail();
        ad6.attributeName = '';
        ad6.attributeValue ='';
        adList6.add(ad6);
        
        List<TRStore_CartPriceRequest.productDetail> pdList6 = new List<TRStore_CartPriceRequest.productDetail>();
        TRStore_CartPriceRequest.productDetail pd6 = new TRStore_CartPriceRequest.productDetail();
        pd6.productRequestType = 'Remove';
        pd6.lineItemId = lineSO.Id;
        pd6.productId = prodObj.Id;
        pd6.site = 'Canada';
        pd6.quantity = '3.0';
        pd6.hasAttribute= false;
        pd6.listPrice ='1234';
        pd6.attributeDetailList = adList6;
        pdList6.add(pd6);
        
        reqst6.productDetailList = pdList6;
        TRStore_CartPriceRequest.cartResponse resp6 = new TRStore_CartPriceRequest.cartResponse();
        resp6 = TRStore_CartPriceRequest.processCart (reqst6);
        
    //UNDO
         TRStore_CartPriceRequest.cartDetail reqst61= new TRStore_CartPriceRequest.cartDetail();
        reqst61.cartId = prodConfigObj.Id;
        reqst61.actionParams = 'Cart';
        
        List<TRStore_CartPriceRequest.attributeDetail> adList61 = new List<TRStore_CartPriceRequest.attributeDetail>();
        TRStore_CartPriceRequest.attributeDetail ad61 = new TRStore_CartPriceRequest.attributeDetail();
        ad61.attributeName = '';
        ad61.attributeValue ='';
        adList61.add(ad61);
        
        List<TRStore_CartPriceRequest.productDetail> pdList61 = new List<TRStore_CartPriceRequest.productDetail>();
        TRStore_CartPriceRequest.productDetail pd61 = new TRStore_CartPriceRequest.productDetail();
        pd61.productRequestType = 'Undo';
        pd61.lineItemId = lineSO.Id;
        pd61.productId = prodObj.Id;
        pd61.site = 'Canada';
        pd61.quantity = '3.0';
        pd61.hasAttribute= false;
        pd61.listPrice ='1234';
        pd61.attributeDetailList = adList61;
        pdList61.add(pd61);
        
        reqst61.productDetailList = pdList61;
        TRStore_CartPriceRequest.cartResponse resp61 = new TRStore_CartPriceRequest.cartResponse();
        resp61 = TRStore_CartPriceRequest.processCart (reqst61);
        
        
        //Reprice
         TRStore_CartPriceRequest.cartDetail reqst7= new TRStore_CartPriceRequest.cartDetail();
        reqst7.cartId = '';
        reqst7.actionParams = 'Reprice';
        
        List<TRStore_CartPriceRequest.attributeDetail> adList7 = new List<TRStore_CartPriceRequest.attributeDetail>();
        TRStore_CartPriceRequest.attributeDetail ad7 = new TRStore_CartPriceRequest.attributeDetail();
        ad7.attributeName = '';
        ad7.attributeValue ='';
        adList7.add(ad7);
        
        List<TRStore_CartPriceRequest.productDetail> pdList7 = new List<TRStore_CartPriceRequest.productDetail>();
        TRStore_CartPriceRequest.productDetail pd7 = new TRStore_CartPriceRequest.productDetail();
        pd7.productRequestType = '';
        pd7.lineItemId = '';
        pd7.productId = prodObj.Id;
        pd7.site = 'Canada';
        pd7.quantity = '3.0';
        pd7.hasAttribute= false;
        pd7.listPrice ='1234';
        pd7.attributeDetailList = adList7;
        pdList7.add(pd7);
        
        reqst7.productDetailList = pdList7;
        TRStore_CartPriceRequest.cartResponse resp7 = new TRStore_CartPriceRequest.cartResponse();
        resp7 = TRStore_CartPriceRequest.processCart (reqst7);
          
        //Reprice
         TRStore_CartPriceRequest.cartDetail reqst9= new TRStore_CartPriceRequest.cartDetail();
        reqst9.cartId = prodConfigObj.Id;
        reqst9.actionParams = 'Cart';
        
        List<TRStore_CartPriceRequest.attributeDetail> adList9 = new List<TRStore_CartPriceRequest.attributeDetail>();
        TRStore_CartPriceRequest.attributeDetail ad9 = new TRStore_CartPriceRequest.attributeDetail();
        ad9.attributeName = '';
        ad9.attributeValue ='';
        adList9.add(ad9);
        
        List<TRStore_CartPriceRequest.productDetail> pdList9 = new List<TRStore_CartPriceRequest.productDetail>();
        TRStore_CartPriceRequest.productDetail pd9 = new TRStore_CartPriceRequest.productDetail();
        pd9.productRequestType = 'ADA';
        pd9.lineItemId = lineSO.Id;
        pd9.productId = prodObj.Id;
        pd9.site = 'Canada';
        pd9.quantity = '3.0';
        pd9.hasAttribute= false;
        pd9.listPrice ='1234';
        pd9.attributeDetailList = adList9;
        pdList9.add(pd9);
        
        reqst9.productDetailList = pdList9;
        TRStore_CartPriceRequest.cartResponse resp9 = new TRStore_CartPriceRequest.cartResponse();
        resp9 = TRStore_CartPriceRequest.processCart (reqst9);   
    }
}