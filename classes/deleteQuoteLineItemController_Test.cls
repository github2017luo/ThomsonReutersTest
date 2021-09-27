@istest(seeAllData=false)
private class deleteQuoteLineItemController_Test{
    static testMethod Void testControllerQuote(){        
        
        UnitTest.createTestData();
        //Id recId = RecordtypeIds__c.getInstance('LATAM Renewal Opportunity').recTypeId__c;
        Material_Type__c oMaterial = new Material_Type__c ();
        oMaterial.name = 'ZFNV';
        insert oMaterial;
        
        Product_Media_high_Level__c oPMHL = new Product_Media_high_Level__c();
        oPMHL.name ='Audio';
        insert oPMHL;
        
        Pro_Business_Channel__c oPBC = new Pro_Business_Channel__c();
        oPBC.name = 'GBL-Legal';
        insert oPBC;
        
        
        /*User testUser = UnitTest.getUserInstance();
        testUser.Username ='Test@test.com';
        testUser.Sales_Org__c = 'SFWS';
        testUser.ProfileId = '00e30000001gFezAAE';
        insert testUser;*/
         
         // Create a custom price book
        Pricebook2 customPB = new Pricebook2(Name='Custom Pricebook', isActive=true);
        customPB.Sales_Org__c ='SFWS';
        insert customPB;
        
        Account testAcc = UnitTest.getAccountInstance();
        insert testAcc;
        
        Contact testcontact= UnitTest.getContactInstance(testAcc.Id);
        testcontact.LastName = 'testContact';
        testcontact.FirstName = 'testContact';
        testcontact.AccountId = testAcc.Id;
        testcontact.email = 'testfirst.testlast@thomson.com';
        insert testcontact;
        
        Product2 testProd1 =UnitTest.getProductInstance();
        testprod1.IsActive = true;
        insert testProd1;
        
        PricebookEntry testEntry = new PricebookEntry(isactive=true,Pricebook2id=Test.getStandardPricebookId(),Product2Id=testProd1.id,unitprice=200);
        insert testEntry;
        
        PricebookEntry testEntry1 = new PricebookEntry(isactive=true,Pricebook2id=customPB.Id,Product2Id=testProd1.id,unitprice=200);
        insert testEntry1;
        
        Opportunity testOpp1 = UnitTest.getOpportunityInstance(testAcc.Id);
        testOpp1.Renewal_Flag__c = true;
        testOpp1.Selling_Organization__c = 'LRA';
        testopp1.Pricebook2Id = customPB.Id;
        testopp1.Sub_Category__c = 'Renewal';
        testOpp1.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('LATAM Renewal Opportunity').getRecordTypeId();
        //testOpp1.ownerId = testUser.Id;
        insert testOpp1;
        
        OpportunityLineItem testLineItem = new OpportunityLineItem(opportunityId=testOpp1.id,PricebookEntryId=testEntry1.id,unitprice=100,Quantity=1, Revenue_Type__c ='Renewal',Activity_Type__c = 'Cancelled');
        testLineItem.Activity_Type__c = 'Cancelled';
        insert testLineItem;
        OpportunityLineItem testLineItem1 = new OpportunityLineItem(opportunityId=testOpp1.id,PricebookEntryId=testEntry1.id,unitprice=100,Quantity=1, Revenue_Type__c ='Incremental');
        testLineItem.Activity_Type__c = 'Renewed';
        insert testLineItem1;
        
        
        Quote testQuote = New Quote ();        
        testQuote.OpportunityId = Testopp1.id;
        testQuote.Pricebook2Id = customPB.Id;
        testQuote.Name = 'Test Quote';
        testQuote.RecordTypeId = Schema.SObjectType.Quote.getRecordTypeInfosByName().get('LATAM Renewal Quote').getRecordTypeId();
        insert testQuote;
        
        QuoteLineItem testquoteLineItem = new QuoteLineItem() ;
        testquoteLineItem.QuoteId = testQuote.id;
        testquoteLineItem.PricebookEntryId = testentry1.Id;
        testquoteLineItem.Quantity = 1;
        testquotelineItem.UnitPrice = 200;
        testquotelineItem.Item_Activity_Type__c = 'Cancelled';
        insert testQuoteLineItem;
        
        Test.startTest();
        PageReference pref=Page.deleteQuoteLineItem;
        ApexPages.StandardController stdController = new ApexPages.StandardController(testQuoteLineItem);
        //stdController.setSelected(testLineItem);
        deleteQuoteLineItemController objDelQLI = new deleteQuoteLineItemController(stdController);        
        objDelQLI.restrictDelete();
        objDelQLI.returntoQuote();
        Test.stopTest();
    }
}