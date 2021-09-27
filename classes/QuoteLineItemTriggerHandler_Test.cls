/**
 * Contains testmethod OpportunityLineItemTriggerHandler and OpportunityLineItemTrigger 
 *
 * @author  
 * @version  
 */
 /**
 * CHANGE HISTORY
 * =============================================================================
 * Date         Name                    Description
 * 2012-06-15   Srikanth Kuruva     Commented the test method as it the trigger is no
 *                                  longer needed. the apex class OpportunityLineItemTriggerHandler
 *                                  is staying as is for now.
 * 2013-07-15   Anshita Sharma      Updated to cover E-Reader Changes
 * =============================================================================
 */ 
@istest(seeAllData=true)
public class QuoteLineItemTriggerHandler_Test{
  /*     
   Public static testMethod Void MapValuesOfQuoteLineItem_test(){
        list<QuoteLineItem> newQLIs = new list <QuoteLineItem>();
        map<Id, QuoteLineItem> oldQuoteLineItemMap = new map <Id, QuoteLineItem>();
        
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
        
        Opportunity testOpp1 = UnitTest.getOpportunityInstance(testAcc.Id);
        testOpp1.Renewal_Flag__c = true;
        testOpp1.Selling_Organization__c = 'LRA';
        testopp1.Pricebook2Id = Test.getStandardPricebookId();
        insert testOpp1;
        
        string strRecordTypeId= [SELECT id,name from RecordType Where name='LatAm New Quote'].Id;
        
        Quote Q1 = New Quote ();
        Q1.OpportunityId = Testopp1.id;
        Q1.Pricebook2Id = Test.getStandardPricebookId();
        Q1.Name = 'Test Quote';
        Q1.Primary_Quote__c = true;
        Q1.RecordTypeId = strRecordTypeId;
        insert Q1;
        
        OpportunityLineItem testLineItem = new OpportunityLineItem(opportunityId=testOpp1.id,PricebookEntryId=testEntry.id,unitprice=100,Quantity=1, Revenue_Type__c ='Renewal');
        insert testLineItem;
         
        Set<Id> settestLineItem = new set<Id>();
        settestlineitem.add(testlineItem.id);
        
        QuoteLineItem testquoteLineItem = new QuoteLineItem() ;
        testquoteLineItem.QuoteId = Q1.id;
        testquoteLineItem.PricebookEntryId = testentry.Id;
        //testquoteLineItem.Product2Id = testprod1.Id;
        testquoteLineItem.Quantity = 1;
        testquotelineItem.UnitPrice = 200;
        testquotelineItem.Revenue_Type__c ='Renewal';
        testquotelineItem.Discount=7.00;
        insert testQuoteLineItem;
 //       QuoteLineItem testquoteLineItemmap = testQuoteLineItem ;
        
        
       QuoteLineItem testquoteLineItem2 = new QuoteLineItem() ;
        testquoteLineItem2.QuoteId = Q1.id;
        testquoteLineItem2.PricebookEntryId = testentry.Id;
        //testquoteLineItem.Product2Id = testprod1.Id;
        testquoteLineItem2.Quantity = 2;
        testquotelineItem2.UnitPrice = 300;
        testquotelineItem2.Revenue_Type__c ='Incremental';
        insert testQuoteLineItem2;
        testQuoteLineItem2.Discount= 8;
        update testQuoteLineItem2;       
        oldQuoteLineItemMap.put(testQuoteLineItem.id,testQuoteLineItem);
        oldQuoteLineItemMap.put(testquoteLineItem2.id,testquoteLineItem2);         
               
        testLineItem.Revenue_Type__c = 'Incremental';
        testquoteLineItem.Revenue_Type__c = 'Incremental';
        testquotelineItem.Discount=8.00;
        update testLineItem;
        update testquoteLineItem;
        
        newQLIs.add(testQuoteLineItem);
        newQLIs.add(testQuoteLineItem2); 
        
        system.debug('newQLIs..'+newQLIs);        
            
        system.debug('oldQuoteLineItemMap..'+oldQuoteLineItemMap);
        
        Test.starttest();
           
            QuoteLineItemTriggerHandler.MapValuesOfQuoteLineItem(newQLIs);                       
          
        Test.Stoptest();
    }  
  */
  Public static testMethod Void getCurrencydecimalPlaces_test(){
       list<QuoteLineItem> newQLIs = new list <QuoteLineItem>();
        map<Id, QuoteLineItem> oldQuoteLineItemMap = new map <Id, QuoteLineItem>();
        set<Id> ids = new Set<Id>();
        
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
        
        system.debug('testProd1.id::'+ testProd1.id);
        PricebookEntry testEntry = new PricebookEntry(isactive=true,Pricebook2id=Test.getStandardPricebookId(),Product2Id=testProd1.id,unitprice=200);
        insert testEntry;
        
        Opportunity testOpp1 = UnitTest.getOpportunityInstance(testAcc.Id);
        testOpp1.Renewal_Flag__c = true;
        testOpp1.Selling_Organization__c = 'LRA';
        testopp1.Pricebook2Id = Test.getStandardPricebookId();
        insert testOpp1;
        
        OpportunityLineItem testLineItem = new OpportunityLineItem(opportunityId=testOpp1.id,PricebookEntryId=testEntry.id,unitprice=100,Quantity=1, Revenue_Type__c ='Renewal');
        insert testLineItem;
        
        system.debug('testLineItem.MOLI_id__c::'+testLineItem.MOLI_id__c);
        system.debug('testLineItem.product2Id::'+testLineItem.product2Id);
        
         Set<Id> settestLineItem = new set<Id>();
         settestlineitem.add(testlineItem.id);
         
        string strRecordTypeId= [SELECT id,name from RecordType Where name='LatAm New Quote'].Id;
        
        Quote Q1 = New Quote ();
        Q1.OpportunityId = Testopp1.id;
        Q1.Pricebook2Id = Test.getStandardPricebookId();
        Q1.Name = 'Test Quote';
        Q1.Primary_Quote__c = true;
        Q1.RecordTypeId = strRecordTypeId;
        insert Q1;
        
        QuoteLineItem testquoteLineItem = new QuoteLineItem() ;
        testquoteLineItem.QuoteId = Q1.id;
        testquoteLineItem.PricebookEntryId = testentry.Id;
        //testquoteLineItem.Product2Id = testprod1.Id;
        testquoteLineItem.Quantity = 1;
        testquotelineItem.UnitPrice = 200;
        testquotelineItem.Revenue_Type__c ='Renewal';
        testquotelineItem.Discount=7.00;
        testquotelineItem.Item_Activity_Type__c = 'New';
        insert testQuoteLineItem;
        ids.add(testQuoteLineItem.id);
 //       QuoteLineItem testquoteLineItemmap = testQuoteLineItem ;
        
        system.debug('testquotelineItem.OpportunityLineId__c::'+testquotelineItem.OpportunityLineId__c);
        system.debug('testquotelineItem.product2Id::'+testquotelineItem.product2Id);
        
       QuoteLineItem testquoteLineItem2 = new QuoteLineItem() ;
        testquoteLineItem2.QuoteId = Q1.id;
        testquoteLineItem2.PricebookEntryId = testentry.Id;
        //testquoteLineItem.Product2Id = testprod1.Id;
        testquoteLineItem2.Quantity = 2;
        testquotelineItem2.UnitPrice = 300;
        testquotelineItem2.Revenue_Type__c ='Incremental';
        insert testQuoteLineItem2;
        ids.add(testQuoteLineItem2.id);
        newQLIs = [Select id,MOLI_id__c,OpportunityLineId__c,quantity,unitprice,discount,Revenue_Type__c,Surcharge_Prct__c ,Number_of_Contacts__c,Renewal_Amount__c ,Description ,Monthly_Charge__c,Incremental_Amount__c ,Product2id,quote.Opportunityid,quote.Primary_Quote__c,Annual_Price__c from QuoteLineItem where Id IN :ids];
        system.debug('newQLIs..'+newQLIs);  
        QuoteLineItemTriggerHandler.SyncQuoteLIValueFromOppLIonInsert(newQLIs);                       
        
        oldQuoteLineItemMap.put(testQuoteLineItem.id,testQuoteLineItem);
        oldQuoteLineItemMap.put(testquoteLineItem2.id,testquoteLineItem2);         
               
 //       testLineItem.Revenue_Type__c = 'Incremental';
        testquoteLineItem.Revenue_Type__c = 'Incremental';
        testquotelineItem.Item_Activity_Type__c = 'Uplift';
        testquotelineItem.Discount=8.00;
 //       update testLineItem;
        update testquoteLineItem;
        
        /*newQLIs.add(testQuoteLineItem);
        newQLIs.add(testQuoteLineItem2); */
        
            
        system.debug('oldQuoteLineItemMap..'+oldQuoteLineItemMap);
        
        Test.starttest();
        Map<Id, QuoteLineItem> newQliMap = new Map<Id, QuoteLineItem>();
        for(QuoteLineItem qli: [Select id,MOLI_id__c,OpportunityLineId__c,quantity,unitprice,discount,Revenue_Type__c,Surcharge_Prct__c ,Number_of_Contacts__c,Renewal_Amount__c ,Description ,Monthly_Charge__c,Incremental_Amount__c ,Product2id,quote.Opportunityid,quote.Primary_Quote__c,Annual_Price__c from QuoteLineItem where Id IN :ids])
            newQliMap.put(qli.Id, qli);    
        
        QuoteLineItemTriggerHandler.RenewalQLISync(newQliMap, oldQuoteLineItemMap);    
        QuoteLineItemTriggerHandler.SyncQuoteLIValueFromOppLIonInsert(newQLIs);            
          
        Test.Stoptest(); 
    }  
    
   Public static testMethod Void SyncOppLineItemToQuoteLineItem_test(){
        list<QuoteLineItem> newQLIs = new list <QuoteLineItem>();
        map<Id, QuoteLineItem> oldQuoteLineItemMap = new map <Id, QuoteLineItem>();
        
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
        
        Opportunity testOpp1 = UnitTest.getOpportunityInstance(testAcc.Id);
        testOpp1.Renewal_Flag__c = true;
        testOpp1.Selling_Organization__c = 'LRA';
        testopp1.Pricebook2Id = Test.getStandardPricebookId();
        insert testOpp1;
            
        Quote Q1 = New Quote ();
        Q1.OpportunityId = Testopp1.id;
        Q1.Pricebook2Id = Test.getStandardPricebookId();
        Q1.Name = 'Test Quote';
        Q1.Primary_Quote__c = true;
        insert Q1;
        
        QuoteLineItem testquoteLineItem = new QuoteLineItem() ;
        testquoteLineItem.QuoteId = Q1.id;
        testquoteLineItem.PricebookEntryId = testentry.Id;
        //testquoteLineItem.Product2Id = testprod1.Id;
        testquoteLineItem.Quantity = 1;
        testquotelineItem.UnitPrice = 200;
        testquotelineItem.Revenue_Type__c ='Renewal';
        testquotelineItem.Discount=7.00;
        insert testQuoteLineItem;
 //       QuoteLineItem testquoteLineItemmap = testQuoteLineItem ;
        
        
       QuoteLineItem testquoteLineItem2 = new QuoteLineItem() ;
        testquoteLineItem2.QuoteId = Q1.id;
        testquoteLineItem2.PricebookEntryId = testentry.Id;
        //testquoteLineItem.Product2Id = testprod1.Id;
        testquoteLineItem2.Quantity = 2;
        testquotelineItem2.UnitPrice = 300;
        testquotelineItem2.Revenue_Type__c ='Incremental';
        insert testQuoteLineItem2;
               
        oldQuoteLineItemMap.put(testQuoteLineItem.id,testQuoteLineItem);
        oldQuoteLineItemMap.put(testquoteLineItem2.id,testquoteLineItem2);         
               
  
        testquoteLineItem.Revenue_Type__c = 'Incremental';
        testquotelineItem.Discount=8.00;
  
        update testquoteLineItem;
        
        system.debug('testquoteLineItem.Revenue_Type__c'+testquoteLineItem.Revenue_Type__c);
        system.debug('testquotelineItem.Discount'+testquotelineItem.Discount);
        
        newQLIs.add(testQuoteLineItem);
        newQLIs.add(testQuoteLineItem2); 
        
        system.debug('newQLIs..'+newQLIs);        
            
        system.debug('oldQuoteLineItemMap..'+oldQuoteLineItemMap);
        
        Test.starttest();
            QuoteLineItemTriggerHandler.SyncQuoteLIValueToOppLI(newQLIs,oldQuoteLineItemMap);          
          
        Test.Stoptest(); 
    }     
    
}