/*
======================================================================================================================
TEST CLASS NAME: QuotePrimaryQuoteUpdation_Test
======================================================================================================================
PURPOSE:    Validates the functionality provided by the QuotePrimaryQuoteUpdation class.

CHANGE HISTORY:
======================================================================================================================
  DATE                  NAME                           DESC
                                                 
2017-03-31            Karthi                     Optimized the coverage as per JIRA STORY: PS0-1
======================================================================================================================
*/
@isTest

public with sharing class QuotePrimaryQuoteUpdation_Test
{
    public static testMethod void testQuotePrimaryQuoteUpdation()
    {  

        Profile p = [SELECT Id FROM profile WHERE name='LatAm User'];   
        User u1 = new User(alias = 'newUser', email='user@mydomain.com', 
        emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
        localesidkey='en_US', profileid = p.Id, employeenumber='0144020',
        timezonesidkey='America/Los_Angeles', username='user@mydomain.com');        
        insert u1;  
        
                
        KeyValueListStore__c kvs= new KeyValueListStore__c();
        kvs.name= 'ANZUsersProfileId';

        kvs.TextValue__C = '00e30000001ZUki';        
        insert kvs;
        
        RecordtypeIds__c recT= new RecordtypeIds__c();
        recT.name= 'Pre-Pipeline Opportunities';
        recT.recTypeId__C = '012a0000001ZJxn';        
        insert recT;
        
        RecordtypeIds__c recT1= new RecordtypeIds__c();
        recT1.Name= 'Pipeline Opportunities';
        recT1.recTypeId__C = '012a0000001ZJxn';
        insert recT1;
        system.runAs(u1){
            Account testAcc = UnitTest.getAccountInstance();
            testAcc.Sales_Org__c = 'LLEY'; // Fixing Sales Org Validation Issue
            insert testAcc;
            
            Contact testcontact= UnitTest.getContactInstance(testAcc.Id);
            testcontact.LastName = 'testContact';
            testcontact.FirstName = 'testContact';
            testcontact.AccountId = testAcc.Id;
            testcontact.email = 'testfirst.testlast@thomson.com';
            insert testcontact;    
        
            Opportunity testOpp1 = UnitTest.getOpportunityInstance(testacc.Id);
            testOpp1.Renewal_Flag__c = true;
            testOpp1.Selling_Organization__c = 'LRA';
            testopp1.Pricebook2Id = Test.getStandardPricebookId();
            insert testOpp1;
            
            Quote oquote = new quote();
            oquote.name = 'test';
            oquote.OpportunityId= Testopp1.id;
            oquote.Primary_Quote__c=true;
            oQuote.status = 'Accepted';
            insert oQuote;
            
            
            /*Product2 testProd =UnitTest.getProductInstance();
            insert testProd; 
            PricebookEntry testEntry = new PricebookEntry(isactive=true,Pricebook2id=Test.getStandardPricebookId(),Product2Id=testProd.id,unitprice=1,UseStandardPrice=false);
            insert testEntry;            
            OpportunityLineItem testLineItem = new OpportunityLineItem(opportunityId=testOpp1.id,PricebookEntryId=testEntry.id,unitprice=100,Quantity=1, Revenue_Type__c ='Renewal');
            insert testLineItem; 
            OpportunityProductDetail__c d = new OpportunityProductDetail__c();
            d.Opportunity_Line_Item_Id__c = (((String)testLineItem.ID).substring(0,15));
            d.Opportunity__c = testOpp1.id;
            d.Contact__c = testcontact.id;
            d.Product__c = testProd.id;
            insert d;*/
            
            Test.StartTest();
            
            OpportunityProductDetail__c oopptyprod = new OpportunityProductDetail__c(
                                                        Opportunity__c=testOpp1.Id,
                                                        Primary_Quote__c=oQuote.Id);
            insert oopptyprod ;
            id id1=oQuote.Id;
            id id2=testOpp1.Id;
            map<id,id> map1=new map<id,id>();
            map1.put(id2,id1);
            
            // <-- S2E Opti code changes START -- PSO-1 --Karthi -->
            
            DateTime tod = System.today();
            set<id> set1 =new set<id>();
            set1.add(id2);
            map<Id,DateTime> map2 = new map<ID,DateTime>();
            map2.put(id2,tod);
            
            // <-- S2E Opti code changes END -- PSO-1 --Karthi -->
            
            oQuote.status = 'Submitted for Processing';
            try{
                update oQuote;
            }
            catch(exception ex){
            }
           
            oQuote.status = 'Order Completed';
            try{
                update oQuote;
            }
            catch(exception ex){
            }
           
            try{
                QuotePrimaryQuoteUpdation.updatePrimaryQuote(map1);
                
                 // <-- S2E Opti code changes START -- PSO-1 --Karthi -->
                 
                QuotePrimaryQuoteUpdation.updateOpptyStage(set1);
                QuotePrimaryQuoteUpdation.syncPurchasedOrderDate(map2);
                
                 // <-- S2E Opti code changes END -- PSO-1 --Karthi -->
            }
            catch(exception ex){
            }            
            
            Test.StopTest();
           
                
        }
        
    }
}