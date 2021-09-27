/*
 * CHANGE HISTORY 
 * ==================================================================================================================================
 * Date           Name                    Description
 * 2018-06-12   Rajan Tatuskar        DLT-9759 - Updates Account/Contact reference For Add On Product classes
 * 2018-10-18   Rajan Tatuskar        DLT-12594 - Recommendations reason from Automation file for Add-Ons
 * 2019-05-14   Navleen Kaur          DLT-16421 - Added plans
 * 2019-06-24   Navleen Kaur          DLT-16914 - Add one more method for corporate for test coverage 
 * 2020-01-02   Srikanth Kota         DLT-18979 - AddOns page for the Plus proposal (regular renewal) is picking up the amount from the Mid Contract Plus proposal (which is expired).
 * 2021-05-24   Kavya S               DLT-21405 - PMD FIX
 * ==================================================================================================================================   
 */
@isTest
private class DCAddOnProducts_Test {
    
    @testSetup 
    static void setupData(){

        // added this for Deployment  error in QA 
        KeyValueListStore__C reasonWithCompetitor = new KeyValueListStore__c(Name= 'ReasonWithCompetitor',TextValue__c= 'Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other');
        insert reasonWithCompetitor;
        
        DCTestData.createData();
        Test.startTest();
        DCTestData.createQuote();      
        Test.stopTest();
        DCTestData.createProductPlan(DCTestData.productId,'42009567', '42009617');
        DCTestData.createPriceListItem(DCTestData.pBookId,DCTestData.productId);
        DCTestData.createPriceMatix(DCTestData.priceListItemid);
        DCTestData.createPriceMatrixEntry(DCTestData.priceMatrixid, '1');
        
        List<Online_Contacts__c> olcList =  DCTestData.createOnline(DCTestData.bQuoteId,DCTestData.accountId);
        olcList[0].ProductId__c = DCTestData.productId;
        olcList[1].ProductId__c = DCTestData.productId;
        update olcList;
        
        Date tday = system.today();
        
    //*** START :: Added by Rajan :: DLT-12594 - Recommendations reason from Automation file for Add-Ons
        Product_Account_Detail__c digitalSub = DCTestData.createDigitalSubscriptions('42009567', '42009617','plus','1004284494',tday,'1004284494');
        digitalSub.Add_On_Text_Code__c = 'ANCILLARY_USAGE';
        digitalSub.Contract_Type__c = 'New Mid Contract';
        update digitalSub;
    //*** END :: Added by Rajan :: DLT-12594 - Recommendations reason from Automation file for Add-Ons
        Digital_Product_Plans__c dpp = new Digital_Product_Plans__c();
        dpp.Material_Number__c = '42009567';
        dpp.Material_Description__c = 'Some Description';
        dpp.SLF_Help_Text__c = 'Some Text';
        dpp.DB_Category__c = 'Some Category';
        dpp.DB_Category_Sort_Order__c = 1;
        dpp.Subscription_Number__c = '42009617';
        dpp.SLF_Jurisdiction__c = 'J';
        dpp.DB_Group_Sort_Order__c = 1;
        dpp.Additional_Help_Text__c = 'Some Text';
        insert dpp;
        
        Opportunity op = new Opportunity();
        op.Id = DCTestData.oppId;
        op.Renewal_Date__c = tday;
        op.Campaign_Code__c = '1004284494';
        update op;
        // addedd by Navleen as part of DLT-16421
        Product2 prod = [SELECT id, Service_Number__c, Subscription_Number__c FROM Product2 WHERE Name = 'SL California Analytical (Westlaw PRO™)'];
        DCTestData.createProductPlan(prod.id,prod.Service_Number__c, prod.Subscription_Number__c);
        //DLT-18979 Updated Approval Stage for new code.
        Apttus_Proposal__Proposal__c bQuote = new Apttus_Proposal__Proposal__c();
        bQuote.id = DCTestData.bQuoteId;
        bQuote.Apttus_Proposal__Approval_Stage__c ='Presented';
        update bQuote;
        Apttus_Proposal__Proposal__c cQuote = new Apttus_Proposal__Proposal__c();
        cQuote.Id = DCTestData.cQuoteId;
        cQuote.Apttus_Proposal__Approval_Stage__c ='Presented';
        update cQuote;
        
    }
    
    private static testmethod void testLandingLoadApi(){
        Account testAcc = [select id from Account where Name = 'Test Account' limit 1];
        Opportunity testOpp = [select id from Opportunity where AccountId =: testAcc.Id limit 1];
        Product2 testProduct = [select id from Product2 where Name = 'SL California Analytical (Westlaw PRO™)' limit 1];
        
        Test.startTest();
        DCAddOnProducts.AddOnResponse response = DCAddOnProducts.api(testOpp.Id,'Best Value');
        Test.stopTest();
        System.assertEquals(response.responseCode,200,'');
        
    }
    
    private static testmethod void testLandingAPINegative(){
        Test.startTest();
        DCAddOnProducts.AddOnResponse response = DCAddOnProducts.api(null,'Best Value');
        Test.stopTest();
        System.assertEquals(response.responseCode,400,'');
    }
    private static testmethod void testLandingAPICorporate(){
        Account testAcc = [select id from Account where Name = 'Test Account' limit 1];
        Opportunity testOpp = [select id from Opportunity where AccountId =: testAcc.Id limit 1];
        Product2 testProduct = [select id from Product2 where Name = 'SL California Analytical (Westlaw PRO™)' limit 1];
        Product_Account_Detail__c pdc = [select id from Product_Account_Detail__c limit 1];
        pdc.Digital_Firm__c = 'Corporate';
        update pdc;
        Test.startTest();
        DCAddOnProducts.AddOnResponse response = DCAddOnProducts.api(testOpp.Id,'Best Value');
        Test.stopTest();
        System.assertEquals(response.responseCode,200,'');
    }
    
}