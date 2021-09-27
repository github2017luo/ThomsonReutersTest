@isTest
public class DCAddRemoveAddOns_Test {
   
    @testSetup static void setupData(){
        DCTestData.createData();
        Test.startTest();
        DCTestData.createQuote();      
        Test.stopTest();
        DCTestData.createOnline(DCTestData.bQuoteId,DCTestData.accountId);
        
        Product2 testProduct2 = [select id from Product2 where Name = 'SL California Analytical (Westlaw PRO™)' limit 1];
        testProduct2.APTS_Product_Pricing_Model__c = 'Banded';
        update testProduct2;

        List<Online_Contacts__c> olcList =  DCTestData.createOnline(DCTestData.bQuoteId,DCTestData.accountId);
        olcList[0].ProductId__c = DCTestData.productId;
        olcList[1].ProductId__c = DCTestData.productId;
        update olcList;
        
        List<Online_Contacts__c> olcList1 =  DCTestData.createOnline(DCTestData.cQuoteId,DCTestData.accountId);
        olcList1[0].ProductId__c = DCTestData.productId;
        olcList1[1].ProductId__c = DCTestData.productId;
        update olcList1;
        
        Product2 prod2 = DCTestData.createProduct('SL Louisiana Analytical (Westlaw PRO™)', '42009566', '42009619');
        Apttus_Config2__PriceListItem__c pli = DCTestData.createPriceListItem(DCTestData.pBookId, DCTestData.productId);
        Apttus_Config2__PriceMatrix__c priceMatrix = DCTestData.createPriceMatix(pli.Id);
        Apttus_Config2__PriceMatrixEntry__c entry = DCTestData.createPriceMatrixEntry( priceMatrix.id, '1');
        
        Product2 prod3 = DCTestData.createProduct('Drafting Assistant (Westlaw&trade PRO)', '42072689', '42072689');
        Apttus_Config2__PriceListItem__c pli1 = DCTestData.createPriceListItem(DCTestData.pBookId, prod3.Id);
        Apttus_Config2__PriceMatrix__c priceMatrix1 = DCTestData.createPriceMatix(pli1.Id);
        Apttus_Config2__PriceMatrixEntry__c entry1 = DCTestData.createPriceMatrixEntry( priceMatrix1.id, '1');
        
    }
    
    public static testmethod void performUpdateLanding(){
        // removed select specific named quote  Apttus_Proposal__Proposal_Name__c = 'Quote 1' AND 
        Apttus_Proposal__Proposal__c cQuoteRec = [select id from Apttus_Proposal__Proposal__c 
                where Digital_Quote_Type__c = 'Best Value+Config' limit 1];
        
        Apttus_Proposal__Proposal__c bQuoteRec = [select id from Apttus_Proposal__Proposal__c 
                where Digital_Quote_Type__c = 'Best Value' limit 1];
        
        List<String> prodNameList = new List<String>{'SL California Analytical (Westlaw PRO™)', 'SL Louisiana Analytical (Westlaw PRO™)', 'Drafting Assistant (Westlaw&trade PRO)'};
        
        List<Product2> testProductList = [select id,IsActive from Product2 where Name IN : prodNameList];
        
        List<DCAddRemoveAddOns.OnlineContacts> olist = new List<DCAddRemoveAddOns.OnlineContacts>();
        
        DCAddRemoveAddOns.OnlineContacts o1 = new DCAddRemoveAddOns.OnlineContacts();
        o1.firstName ='Test FirstName';
        o1.lastName = 'Test LastName';
        olist.add(o1);
        
        DCAddRemoveAddOns.ProductDetails p1 = new DCAddRemoveAddOns.ProductDetails();
        p1.productId = testProductList[0].id;
        p1.noOfUsers = 2;
        p1.isSelected = true; 
        p1.onlineContacts = olist;
        
        DCAddRemoveAddOns.ProductDetails p2 = new DCAddRemoveAddOns.ProductDetails();
        p2.productId = testProductList[1].id;
        p2.noOfUsers = 2;
        p2.isSelected = true; 
        p2.onlineContacts =olist; 
        
        DCAddRemoveAddOns.ProductDetails p3 = new DCAddRemoveAddOns.ProductDetails();
        p3.productId = testProductList[2].id;
        p3.noOfUsers = 2;
        p3.isSelected = true; 
        p3.onlineContacts =olist; 
        
        
        DCAddRemoveAddOns.ProductDetails p4 = new DCAddRemoveAddOns.ProductDetails();
        p4.productId = testProductList[2].id;
        p4.noOfUsers = 2;
        p4.isSelected = false; 
        p4.onlineContacts = null;
        
        DCAddRemoveAddOns.QuoteUpdateRequest data = new DCAddRemoveAddOns.QuoteUpdateRequest();
        data.quoteId = bQuoteRec.Id;
        data.quantity = 2;
        data.contractTerm = '1 Year';
        data.productDetails = new List<DCAddRemoveAddOns.ProductDetails>{p1,p2,p3}; 
        
        DCAddRemoveAddOns.QuoteUpdateRequest data1 = new DCAddRemoveAddOns.QuoteUpdateRequest();
        data1.quoteId = cQuoteRec.Id;
        data1.quantity = 2;
        data1.contractTerm = '1 Year';
        data1.productDetails = new List<DCAddRemoveAddOns.ProductDetails>{p1,p2,p3,p4}; 
        
    Apttus_Config2__ProductConfiguration__c cart =[select id,Apttus_QPConfig__Proposald__c,Apttus_QPConfig__Proposald__r.APTS_SSD_Sold_To__c from Apttus_Config2__ProductConfiguration__c limit 1];



    List<String> removalProductIdList = new List<String>();
    removalProductIdList.add('1');
    removalProductIdList.add('2');
    List<String> addProductIdList = new List<String>();
    addProductIdList.add(testProductList[0].id);
       
        
        Test.startTest();
        List<DCAddRemoveAddOns.QuoteUpdateRequest> updateDetails = new List<DCAddRemoveAddOns.QuoteUpdateRequest>();  
        //DCAddRemoveAddOns.addRemoveAddOns(updateDetails);
        updateDetails.add(data); 
        updateDetails.add(data1); 
        DCQuoteUpdate.QuoteUpdateResponse response = DCAddRemoveAddOns.addRemoveAddOns(updateDetails); 
        
        
        DCAddRemoveAddOns.updateOCRequestInstance (cart,new List<DCAddRemoveAddOns.ProductDetails>{p1,p2,p3,p4},addProductIdList);
        Test.stopTest();
        
        System.assertEquals(testProductList[0].IsActive,true,'Assert failed');
       
    }
    
    public static testmethod void performUpdateNegative(){
      
      Product2 testProduct = [select id from Product2 Limit 1];
        Test.startTest();
        List<DCAddRemoveAddOns.QuoteUpdateRequest> updateDetails = new List<DCAddRemoveAddOns.QuoteUpdateRequest>();  
        DCQuoteUpdate.QuoteUpdateResponse response = DCAddRemoveAddOns.addRemoveAddOns(updateDetails); 
        
    DCAddRemoveAddOns.QuoteUpdateRequest data = new DCAddRemoveAddOns.QuoteUpdateRequest();
        data.quoteId = null;
        data.quantity = 2;
        data.contractTerm = '1 Year';
        data.productDetails = new List<DCAddRemoveAddOns.ProductDetails>{};
    
    updateDetails = new List<DCAddRemoveAddOns.QuoteUpdateRequest>();
    updateDetails.add(data); 
        DCQuoteUpdate.QuoteUpdateResponse response1 = DCAddRemoveAddOns.addRemoveAddOns(updateDetails); 
        //updateDetails.add(data); 
    
    DCAddRemoveAddOns.QuoteUpdateRequest data1 = new DCAddRemoveAddOns.QuoteUpdateRequest();
        data1.quoteId = '';
        data1.quantity = 2;
        data1.contractTerm = '1 Year';
        data1.productDetails = new List<DCAddRemoveAddOns.ProductDetails>{};
    
    updateDetails = new List<DCAddRemoveAddOns.QuoteUpdateRequest>();
    updateDetails.add(data1); 
        DCQuoteUpdate.QuoteUpdateResponse response2 = DCAddRemoveAddOns.addRemoveAddOns(updateDetails); 
   
    
    Test.stopTest();
        
        System.assertEquals(response.responseCode,400,'Assert failed');
    }
    
}