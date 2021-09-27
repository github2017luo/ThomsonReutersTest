/*
 * CHANGE HISTORY
 * ==============================================================================================================================
 * Date         Name                    Description
 * 2018-05-31   Rajan Tatuskar          DLT-9839 - [SLF] Reassign users link on Confirmation page (up-sell only)
 * 2018-08-09   Rajan Tatuskar        DLT-11652 - Merge services performCartUpdate, DCAddRemoveAddOns and DCAddRemoveOnlineContacts
 * 2018-10-16   Rajan Tatuskar        DLT-12938 - Fixed issue : Number of Users not getting updated correctly on confirmation page
 * 2018-10-19   Rajan Tatuskar        DLT-12934 - Handle Exception for "DCAddRemoveOnlineContacts" and "DCAddRemoveAddOns" 
 * 2019-06-25   Pavithra              DLT-16916- [Tech Story] [Code Scan] - Fix code scan MINOR issues in DCAddOnProducts, DCAddRemoveAddOns, DCAddRemoveAddOns_Test, DCAddRemoveOnlineContacts, DCAddRemoveOnlineContacts_Test
 * 2019-06-24   Srikanth kota         DLT-16787- [Code Scan] -Fix code scan MAJOR issues in this DCAcceptQuoteTest ,DCAddRemoveAddOns, DCAddRemoveOnlineContacts
 * 2020-03-31   Brenda Shields        DLT-19862 - Add logic to use Product configuration type and PLI Subscription Number Override to correctly set OLCs
===============================================================================================================================
 */

@isTest
public class DCAddRemoveOnlineContacts_Test {
    
    @testSetup static void setupData(){
       DCTestData.createData();
       Test.startTest();
       DCTestData.createQuote();      
       Test.stopTest();
    }
    
    public static testmethod void testUpdateOnlineContacts(){
        //setupData();
        
        //System.debug('----Inside TestUpdateOnlineContacts----DCTestData.bQuoteId -----------'+ DCTestData.bQuoteId);
        //System.debug('----Inside TestUpdateOnlineContacts----DCTestData.accountId -----------'+ DCTestData.accountId);
        Account testAcc = [select id from Account where Name = 'Test Account' limit 1];
        Apttus_Proposal__Proposal__c testQuote = [select id from Apttus_Proposal__Proposal__c where Apttus_Proposal__Proposal_Name__c = 'Quote 1' limit 1];
        Product2 testProduct = [select id from Product2 where Name = 'SL California Analytical (Westlaw PRO™)' limit 1];
        //*** START :: Added by Rajan :: DLT-12934 - Handle Exception for "DCAddRemoveOnlineContacts" and "DCAddRemoveAddOns"
        testProduct.APTS_Product_Pricing_Model__c = 'Per Seat';
        //*** END :: Added by Rajan :: DLT-12934 - Handle Exception for "DCAddRemoveOnlineContacts" and "DCAddRemoveAddOns"
        update testProduct;
        
        List<Online_Contacts__c> ocList = DCTestData.createOnline(testQuote.Id,testAcc.Id);
        ocList[0].ProductId__c = testProduct.Id;
        ocList[1].ProductId__c = testProduct.Id;
        update ocList;
        
        //*** START :: Added by Rajan :: DLT-12934 - Handle Exception for "DCAddRemoveOnlineContacts" and "DCAddRemoveAddOns"
        List<Apttus_Config2__LineItem__c> lineItemList = [select id, name from Apttus_Config2__LineItem__c where Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__c = : testQuote.id ] ;
        //*** END :: Added by Rajan :: DLT-12934 - Handle Exception for "DCAddRemoveOnlineContacts" and "DCAddRemoveAddOns"
        
        System.debug('----Inside TestUpdateOnlineContacts----testQuote.Id -----------'+ testQuote.Id);
        System.debug('----Inside TestUpdateOnlineContacts----testAcc.Id -----------'+ testAcc.Id);
        System.debug('----Inside TestUpdateOnlineContacts----testProduct.Id -----------'+ testProduct.Id);
        System.debug('----Inside TestUpdateOnlineContacts----ocList -----------'+ ocList);
        System.debug('----Inside TestUpdateOnlineContacts----lineItemList -----------'+ lineItemList);
        
        List<DCAddRemoveOnlineContacts.OnlineContacts> olist = new List<DCAddRemoveOnlineContacts.OnlineContacts>();
        DCAddRemoveOnlineContacts.OnlineContacts o1 = new DCAddRemoveOnlineContacts.OnlineContacts();
        o1.firstName ='Test FirstName';
        o1.lastName = 'Test LastName';
        olist.add(o1);
        
        List<DCAddRemoveOnlineContacts.ProductDetails> prodList = new List<DCAddRemoveOnlineContacts.ProductDetails>();
        DCAddRemoveOnlineContacts.ProductDetails prod1 = new DCAddRemoveOnlineContacts.ProductDetails();
        //*** START :: Added by Rajan :: DLT-12934 - Handle Exception for "DCAddRemoveOnlineContacts" and "DCAddRemoveAddOns"
        prod1.productId = lineItemList[0].id;
        //*** END :: Added by Rajan :: DLT-12934 - Handle Exception for "DCAddRemoveOnlineContacts" and "DCAddRemoveAddOns"
        prod1.productQuantity = 5;
        prodList.add(prod1);
        
        
        List<DCAddRemoveOnlineContacts.ProductDetails> notprodList = new List<DCAddRemoveOnlineContacts.ProductDetails>();
        DCAddRemoveOnlineContacts.ProductDetails prod2 = new DCAddRemoveOnlineContacts.ProductDetails();
        //*** START :: Added by Rajan :: DLT-12934 - Handle Exception for "DCAddRemoveOnlineContacts" and "DCAddRemoveAddOns"
        prod2.productId = testAcc.id;
        //*** END :: Added by Rajan :: DLT-12934 - Handle Exception for "DCAddRemoveOnlineContacts" and "DCAddRemoveAddOns"
        prod2.productQuantity = 5;
        notprodList.add(prod1);
    
        //DCAddRemoveOnlineContacts.OLCRequest updateDetails = null;
        DCAddRemoveOnlineContacts.OLCRequest data = new DCAddRemoveOnlineContacts.OLCRequest();
        data.quoteId = testQuote.Id;
        //data.materialNumber = ocList[0].Material__c;
        data.onlineContacts = olist;
        data.productDetails = prodList;
        
        DCAddRemoveOnlineContacts.OLCRequest data1 = new DCAddRemoveOnlineContacts.OLCRequest();
        data1.quoteId = testQuote.Id;
        //data1.materialNumber = ocList[0].Material__c;
        //data1.onlineContacts = new List<DCAddRemoveOnlineContacts.OnlineContacts>();
        data1.onlineContacts = null;
        
        DCAddRemoveOnlineContacts.OLCRequest data2 = new DCAddRemoveOnlineContacts.OLCRequest();
        data2.quoteId = '@!#';
        //data2.materialNumber = '<>?::*&';
        //data1.onlineContacts = new List<DCAddRemoveOnlineContacts.OnlineContacts>();
        data2.onlineContacts = null;
        
        
        DCAddRemoveOnlineContacts.OLCRequest data3 = new DCAddRemoveOnlineContacts.OLCRequest();
        data3.quoteId = null;
        //data3.materialNumber = null;
        data3.onlineContacts = olist;
        data3.productDetails = notprodList;
        
        DCAddRemoveOnlineContacts.OLCRequest data4 = new DCAddRemoveOnlineContacts.OLCRequest();
        data4.quoteId = null;
        //data4.materialNumber = null;
        data4.onlineContacts = null;
        data4.productDetails = null;
      String orgId = UserInfo.getOrganizationId();
      String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
      Profile pro = [SELECT Id FROM Profile WHERE Name='System Administrator Read Only']; 
      User usr = new User(Alias = 'standt', Email='user'+dateString+'@'+orgId+'testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = pro.Id, 
      TimeZoneSidKey='America/Los_Angeles', UserName='userid'+dateString+'@'+orgId+'testorg.com');

      System.runAs(usr) {
         // The following code runs as user 'u' 
         DCAddRemoveOnlineContacts.OLCResponse response = DCAddRemoveOnlineContacts.addRemoveOnlineContacts(data);
      }
        
        
        Test.startTest();
        //exception
        DCAddRemoveOnlineContacts.addRemoveOnlineContacts(data3);
        //exception
        DCAddRemoveOnlineContacts.addRemoveOnlineContacts(data4);
        
        //Pass OLC list empty
        DCAddRemoveOnlineContacts.addRemoveOnlineContacts(data1);
        
        //generate exception
        DCAddRemoveOnlineContacts.addRemoveOnlineContacts(data2);
        
    
         //Pass All Data Correct
        DCAddRemoveOnlineContacts.OLCResponse response = DCAddRemoveOnlineContacts.addRemoveOnlineContacts(data);
        
        Test.stopTest();
        
        //System.assertEquals(response.responseCode,200);
        
    }
    
    public static testmethod void testUpdateOLCNegative(){

        Test.startTest();
        DCAddRemoveOnlineContacts.OLCRequest updateDetails = null;
        //Pass updateDetails null
        DCAddRemoveOnlineContacts.addRemoveOnlineContacts(updateDetails);
        
        //Pass updateDetails empty
        updateDetails = new DCAddRemoveOnlineContacts.OLCRequest(); 
        DCAddRemoveOnlineContacts.OLCResponse response = DCAddRemoveOnlineContacts.addRemoveOnlineContacts(updateDetails);
        Test.stopTest();
        
        System.assertEquals(response.responseCode,400);
    }
    
    public static testmethod void testBundleOnlineContacts(){
        
        Account testAcc = [select id from Account where Name = 'Test Account' limit 1];
        Apttus_Proposal__Proposal__c testQuote = [select id from Apttus_Proposal__Proposal__c where Apttus_Proposal__Proposal_Name__c = 'Quote 1' limit 1];


        Product2 testProduct = [select id from Product2 where Name = 'SL California Analytical (Westlaw PRO™)' limit 1]; 
        testProduct.APTS_Product_Pricing_Model__c = null;
        testProduct.Apttus_Config2__ConfigurationType__c = 'Bundle';
        update testProduct;
        
        List<Online_Contacts__c> ocList = DCTestData.createOnline(testQuote.Id,testAcc.Id);
        ocList[0].ProductId__c = testProduct.Id;
        ocList[1].ProductId__c = testProduct.Id;
        update ocList;
        
        Apttus_Proposal__Proposal_Line_Item__c testPLIs = [Select Id, Apttus_Proposal__Product__c, APTS_Service_Number_Override__c 
                                                    FROM Apttus_Proposal__Proposal_Line_Item__c 
                                                    WHERE Apttus_Proposal__Proposal__c =: testQuote.Id limit 1];
        testPLIs.APTS_Service_Number_Override__c = '41091348';
        update testPLIs;                                                                                                    
                                                    
        List<Apttus_Config2__LineItem__c> lineItemList = [select id, name from Apttus_Config2__LineItem__c where Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__c = : testQuote.id ] ;
                
        System.debug('----Inside TestUpdateOnlineContacts----testQuote.Id -----------'+ testQuote.Id);
        System.debug('----Inside TestUpdateOnlineContacts----testAcc.Id -----------'+ testAcc.Id);
        System.debug('----Inside TestUpdateOnlineContacts----testProduct.Id -----------'+ testProduct.Id);
        System.debug('----Inside TestUpdateOnlineContacts----ocList -----------'+ ocList);
        System.debug('----Inside TestUpdateOnlineContacts----lineItemList -----------'+ lineItemList);
        
        List<DCAddRemoveOnlineContacts.OnlineContacts> olist = new List<DCAddRemoveOnlineContacts.OnlineContacts>();
        DCAddRemoveOnlineContacts.OnlineContacts o1 = new DCAddRemoveOnlineContacts.OnlineContacts();
        o1.firstName ='Test FirstName';
        o1.lastName = 'Test LastName';
        olist.add(o1);
        
        List<DCAddRemoveOnlineContacts.ProductDetails> prodList = new List<DCAddRemoveOnlineContacts.ProductDetails>();
        DCAddRemoveOnlineContacts.ProductDetails prod1 = new DCAddRemoveOnlineContacts.ProductDetails();
        prod1.productId = testProduct.id;
        prod1.productQuantity = 5;
        prodList.add(prod1);
    
        //DCAddRemoveOnlineContacts.OLCRequest updateDetails = null;
        DCAddRemoveOnlineContacts.OLCRequest data = new DCAddRemoveOnlineContacts.OLCRequest();
        data.quoteId = testQuote.Id;
        //data.materialNumber = ocList[0].Material__c;
        data.onlineContacts = olist;
        data.productDetails = prodList;
        


        String orgId = UserInfo.getOrganizationId();
        String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
        Profile pro = [SELECT Id FROM Profile WHERE Name='System Administrator Read Only']; 
        User usr = new User(Alias = 'standt', Email='user'+dateString+'@'+orgId+'testorg.com', 
        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = pro.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='userid'+dateString+'@'+orgId+'testorg.com');

        System.runAs(usr) {
         // The following code runs as user 'u' 
           DCAddRemoveOnlineContacts.OLCResponse response = DCAddRemoveOnlineContacts.addRemoveOnlineContacts(data);
        }
            
        Test.startTest();
        
        //Pass All Data Correct
        DCAddRemoveOnlineContacts.OLCResponse response = DCAddRemoveOnlineContacts.addRemoveOnlineContacts(data);
       
        Test.stopTest();
        //System.assertEquals(response.responseCode,200);
        
    }  
      
}