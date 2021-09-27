@istest(seeAllData=false)
private class deleteOpportunityProdController_Test{
    static testMethod void testControllerOpportunity(){
        
        UnitTest.createTestData();
        Material_Type__c oMaterial = new Material_Type__c ();
        oMaterial.name = 'ZFNV';
        insert oMaterial;
        
        Product_Media_high_Level__c oPMHL = new Product_Media_high_Level__c();
        oPMHL.name ='Audio';
        insert oPMHL;
        
        Pro_Business_Channel__c oPBC = new Pro_Business_Channel__c();
        oPBC.name = 'GBL-Legal';
        insert oPBC;
        
        
        Pricebook2 customPB = new Pricebook2(Name='Custom Pricebook', isActive=true);
        insert customPB;
        
        
        Account testAcc = UnitTest.getAccountInstance();
        insert testAcc;
        
        Contact testcontact= UnitTest.getContactInstance(testAcc.Id);
        testcontact.LastName = 'testContact';
        testcontact.FirstName = 'testContact';
        testcontact.AccountId = testAcc.Id;
        testcontact.email = 'testfirst.testlast@thomson.com';
        insert testcontact;
        
        Opportunity testOpp1 = UnitTest.getOpportunityInstance(testAcc.Id);
        testOpp1.Renewal_Flag__c = true;
        testOpp1.Selling_Organization__c = 'LRA';
        testOpp1.currencyIsoCode = 'USD';
        testOpp1.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('LATAM Renewal Opportunity').getRecordTypeId();
        insert testOpp1;
        
        Product2 testProd =UnitTest.getProductInstance();
        insert testProd;
        
        PricebookEntry testEntry = new PricebookEntry(CurrencyIsoCode='USD',isactive=true,Pricebook2id=Test.getStandardPricebookId(),Product2Id=testProd.id,unitprice=1,UseStandardPrice=false);
        insert testEntry;
        
        PricebookEntry testEntry1 = new PricebookEntry(CurrencyIsoCode='USD',isactive=true,Pricebook2id=customPB.Id,Product2Id=testProd.id,unitprice=1,UseStandardPrice=false);
        insert testEntry1;
        
        OpportunityLineItem testLineItem = new OpportunityLineItem(opportunityId=testOpp1.id,PricebookEntryId=testEntry1.id,unitprice=100,Quantity=1, Revenue_Type__c ='Renewal');
        //testLineItem.RenewalCheck__c = true;
        testLineItem.Activity_Type__c = 'Cancelled';        
        insert testLineItem;
        
        Test.startTest();
        PageReference pref=Page.deleteOpportunityProd;
        ApexPages.StandardController stdController = new ApexPages.StandardController(testLineItem);
        //stdController.setSelected(testLineItem);
        deleteOpportunityProdController objDelOLI = new deleteOpportunityProdController(stdController);        
        objDelOLI.restrictDelete();
        objDelOLI.returntoOppty();
    }
}