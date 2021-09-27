/*
======================================================================================================================
TEST CLASS NAME: RenewalsOpptyMgmtType_Batch_Test
======================================================================================================================
PURPOSE: Validates the functionality provided by the RenewalsOpptyMgmtType_Batch class.

CHANGE HISTORY:
======================================================================================================================
DATE             NAME           DESC
31/03/2017       Gunaseelan K   Optimized the code as per JIRA STORY: PS0-1
======================================================================================================================
*/
@istest (SeeAllData=false)
private class RenewalsOpptyMgmtType_Batch_Test{
    public static testmethod void callRenOpptyMgmtTypeSch(){         
        UnitTest.createTestData();
        Product2 testProd =UnitTest.getProductInstance();
        insert testProd;        
        //Standard PricebookEntry 
        PricebookEntry testEntry = new PricebookEntry(CurrencyIsoCode='USD',isactive=true,Pricebook2id=Test.getStandardPricebookId(),Product2Id=testProd.id,unitprice=1,UseStandardPrice=false);
        insert testEntry;        
        Pricebook2 customPB = new Pricebook2(Name='Custom Pricebook', isActive=true);
        insert customPB;        
        //Custom PricebookEntry
        PricebookEntry testEntry1 = new PricebookEntry(CurrencyIsoCode='USD',isactive=true,Pricebook2id=customPB.Id,Product2Id=testProd.id,unitprice=1,UseStandardPrice=false);
        insert testEntry1;        
        //Account data
        Account testAcc = UnitTest.getAccountInstance();
        insert testAcc;        
        //Contact data
        Contact testcontact= UnitTest.getContactInstance(testAcc.Id);
        testcontact.LastName = 'testContact';
        testcontact.FirstName = 'testContact';
        testcontact.AccountId = testAcc.Id;
        testcontact.email = 'testfirst.testlast@thomson.com';
        insert testcontact;        
        //Opportunity data: set1(standard pricebook)
        Opportunity testOpp1 = UnitTest.getOpportunityInstance(testAcc.Id);
        testOpp1.Name = 'Test Opp1';
        testOpp1.Renewal_Flag__c = true;
        testOpp1.Selling_Organization__c = 'LRA';
        testOpp1.currencyIsoCode = 'USD';
        testOpp1.Pricebook2Id = testEntry.Pricebook2Id;
        testOpp1.Sales_Org__c = 'TSL';
        //testOpp1.RecordTypeId = RecordtypeIds__c.getInstance('LATAM Renewal Opportunity').recTypeId__c;
        testOpp1.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('LATAM Renewal Opportunity').getRecordTypeId();
        insert testOpp1;        
        //Opportunity data: set2(custom pricebook)
        Opportunity testOpp2 = UnitTest.getOpportunityInstance(testAcc.Id);
        testOpp2.Name = 'Test Opp2';
        testOpp2.Renewal_Flag__c = true;
        testOpp2.Selling_Organization__c = 'LRA';
        testOpp2.currencyIsoCode = 'USD';
        testOpp2.Pricebook2Id = customPB.Id;
        testOpp2.Sales_Org__c = 'TSL';
        //testOpp2.RecordTypeId = RecordtypeIds__c.getInstance('LATAM Renewal Opportunity').recTypeId__c;
        testOpp2.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('LATAM Renewal Opportunity').getRecordTypeId();
        insert testOpp2;        
        //OpportunityLineItem data: set1(standard pricebook)
        OpportunityLineItem testLineItem = new OpportunityLineItem(opportunityId=testOpp1.id,PricebookEntryId=testEntry.id,unitprice=100,Quantity=1, Revenue_Type__c ='Renewal');
        testLineItem.Previous_Year_s_SFDC_Quote_No__c = '1234';                
        insert testLineItem;        
        //OpportunityLineItem data: set2(custom pricebook)
        OpportunityLineItem testLineItem1 = new OpportunityLineItem(opportunityId=testOpp2.id,PricebookEntryId=testEntry1.id,unitprice=100,Quantity=1, Revenue_Type__c ='Renewal');        
        testLineItem1.Previous_Year_s_SFDC_Quote_No__c = '1234';
        insert testLineItem1;        
        //Quote data(custom pricebook)
        Quote testQuote = New Quote ();
        testQuote.OpportunityId = testOpp1.id;
        testQuote.Pricebook2Id = testEntry.Pricebook2Id;
        testQuote.Name = 'Test Quote';
        //testQuote.RecordTypeId = RecordtypeIds__c.getInstance('LATAM Renewal Quote').recTypeId__c;
        testQuote.RecordTypeId = Schema.SObjectType.Quote.getRecordTypeInfosByName().get('LATAM Renewal Quote').getRecordTypeId();
        insert testQuote;        
        //Batch class scheduler
        /*RenewalsOpptyMgmtType_Scheduler renOppSch = new RenewalsOpptyMgmtType_Scheduler();
        String sched = '0 00 00 * * ?';
        System.schedule('My batch Job', sched, renOppSch);*/        
        RenewalsOpptyMgmtType_Batch renOppMgmtType = new RenewalsOpptyMgmtType_Batch();
        Database.executeBatch(renOppMgmtType,200);      
    }
}