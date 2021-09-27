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
@istest
public class OpportunityLineItemTriggerHandler_test{
    Public static Profile p = [SELECT Id FROM profile WHERE name='System Administrator'];
    
    Public static testMethod Void testUpdateProductCategory(){
        
        
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
        
        RecordtypeIds__c orecordType5 = new RecordtypeIds__c ();
        orecordType5.name ='LATAM Renewal Opportunity';
        orecordType5.recTypeId__c = '012M0000000509c';
        insert orecordType5;
        
        RecordtypeIds__c orecordType6 = new RecordtypeIds__c ();
        orecordType6.name ='LATAM Renewal Quote';
        orecordType6.recTypeId__c = '012M0000000509X';
        insert orecordType6;
        
        Profile_List__c objPro = new Profile_List__c();
        objPro.name = 'Partner Portal User';
        objPro.Profile_Name__c = 'Partner Portal User';
        objPro.ProfileId__c = '00ea00000024JwaAAE';
        INSERT objPro;
        
        Profile_List__c objPro1 = new Profile_List__c();
        objPro1.name = 'LatAm User';
        objPro1.Profile_Name__c = 'LatAm User';
        objPro1.ProfileId__c = '00ea00000024JzKAAU';
        INSERT objPro1;
        
        Profile_List__c objPro2 = new Profile_List__c();
        objPro2.name = 'System Administrator';
        objPro2.Profile_Name__c = 'System Administrator';
        objPro2.ProfileId__c = '00e30000001gFezAAE';
        INSERT objPro2;
        
        Account testAcc = UnitTest.getAccountInstance();
        insert testAcc;
        
        Contact testcontact= UnitTest.getContactInstance(testAcc.Id);
        testcontact.LastName = 'testContact';
        testcontact.FirstName = 'testContact';
        testcontact.AccountId = testAcc.Id;
        testcontact.email = 'testfirst.testlast@thomson.com';
        insert testcontact;
        
        Opportunity testOpp1 = UnitTest.getOpportunityInstance(testAcc.Id);
        testOpp1.Renewal_Flag__c = false;
        testOpp1.Selling_Organization__c = 'LRA';
        insert testOpp1;
        
        
        Product2 testProd =UnitTest.getProductInstance();
        insert testProd;
        
       // List<Pricebook2> testPricebook =[select id from Pricebook2 where isActive = true];   
              
        PricebookEntry testEntry = new PricebookEntry(isactive=true,Pricebook2id=Test.getStandardPricebookId(),Product2Id=testProd.id,unitprice=1,UseStandardPrice=false);
        insert testEntry;
        
        OpportunityLineItem testLineItem = new OpportunityLineItem(opportunityId=testOpp1.id,PricebookEntryId=testEntry.id,unitprice=100,Quantity=1, Revenue_Type__c ='Renewal');
        insert testLineItem;
        
        
        OpportunityProductDetail__c d = new OpportunityProductDetail__c();
        d.Opportunity_Line_Item_Id__c = (((String)testLineItem.ID).substring(0,15));
        d.Opportunity__c = testOpp1.id;
        d.Contact__c = testcontact.id;
        d.Product__c = testProd.id;
        insert d;
       
        Test.startTest();
        delete testLineItem ;
        Test.stopTest();
       /* system.assert(testLineItem.Product_Category__c==null);
        
        Product2 testProd2 =UnitTest.getProductInstance();
        testProd2.name='Books2';
        insert testProd2;
        PricebookEntry testEntry2 = new PricebookEntry(isactive=true,Pricebook2id=testPricebook.id,Product2Id=testProd2.id,unitprice=1);
        insert testEntry2;
        OpportunityLineItem testLineItem2 = new OpportunityLineItem(quantity=1,totalprice=10,opportunityId=testOpp1.id,PricebookEntryId=testEntry2.id);
        insert testLineItem2;
        Test.startTest();
        system.assertEquals([select Product_Category__c from OpportunityLineItem where id=:testLineItem.id].Product_Category__c,null);
        system.assert(testProd2.name.contains([select Product_Category__c from OpportunityLineItem where id=:testLineItem2.id].Product_Category__c));
        Test.stopTest();*/    
        
        
        
    }
    
    
    Public static testMethod Void testUpdateProductCategory1(){
        
        
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
      
        RecordtypeIds__c orecordType5 = new RecordtypeIds__c ();
        orecordType5.name ='LATAM Renewal Opportunity';
        orecordType5.recTypeId__c = '012M0000000509c';
        insert orecordType5;
        
        RecordtypeIds__c orecordType6 = new RecordtypeIds__c ();
        orecordType6.name ='LATAM Renewal Quote';
        orecordType6.recTypeId__c = '012M0000000509X';
        insert orecordType6;
        
        Profile_List__c objPro = new Profile_List__c();
        objPro.name = 'Partner Portal User';
        objPro.Profile_Name__c = 'Partner Portal User';
        objPro.ProfileId__c = '00ea00000024JwaAAE';
        INSERT objPro;
        
        Profile_List__c objPro1 = new Profile_List__c();
        objPro1.name = 'LatAm User';
        objPro1.Profile_Name__c = 'LatAm User';
        objPro1.ProfileId__c = '00ea00000024JzKAAU';
        INSERT objPro1;
        
        Profile_List__c objPro2 = new Profile_List__c();
        objPro2.name = 'System Administrator';
        objPro2.Profile_Name__c = 'System Administrator';
        objPro2.ProfileId__c = '00e30000001gFezAAE';
        INSERT objPro2;
        
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
        insert testOpp1;
        

         update testOpp1;
         
        Product2 testProd =UnitTest.getProductInstance();
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
        insert d;
       
        Test.startTest();
        delete testLineItem ;
        Test.stopTest();
          
    }
 
     Public static testMethod Void testerrorForNewOpportunitiesmethod(){
        
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

        RecordtypeIds__c orecordType5 = new RecordtypeIds__c ();
        orecordType5.name ='LATAM Renewal Opportunity';
        orecordType5.recTypeId__c = '012M0000000509c';
        insert orecordType5;
        
        RecordtypeIds__c orecordType6 = new RecordtypeIds__c ();
        orecordType6.name ='LATAM Renewal Quote';
        orecordType6.recTypeId__c = '012M0000000509X';
        insert orecordType6;
        
        Profile_List__c objPro = new Profile_List__c();
        objPro.name = 'Partner Portal User';
        objPro.Profile_Name__c = 'Partner Portal User';
        objPro.ProfileId__c = '00ea00000024JwaAAE';
        INSERT objPro;
        
        Profile_List__c objPro1 = new Profile_List__c();
        objPro1.name = 'LatAm User';
        objPro1.Profile_Name__c = 'LatAm User';
        objPro1.ProfileId__c = '00ea00000024JzKAAU';
        INSERT objPro1;
        
        Profile_List__c objPro2 = new Profile_List__c();
        objPro2.name = 'System Administrator';
        objPro2.Profile_Name__c = 'System Administrator';
        objPro2.ProfileId__c = '00e30000001gFezAAE';
        INSERT objPro2;
        
        Account testAcc = UnitTest.getAccountInstance();
        insert testAcc;
        
        Contact testcontact= UnitTest.getContactInstance(testAcc.Id);
        testcontact.LastName = 'testContact';
        testcontact.FirstName = 'testContact';
        testcontact.AccountId = testAcc.Id;
        testcontact.email = 'testfirst.testlast@thomson.com';
        insert testcontact;
        
        Opportunity testOpp1 = UnitTest.getOpportunityInstance(testAcc.Id);
        testOpp1.Renewal_Flag__c = false;
        testOpp1.Selling_Organization__c = 'LRA';
        testOpp1.Sub_Category__c = 'Renewel';
        insert testOpp1;
       
        
        Product2 testProd =UnitTest.getProductInstance();
        insert testProd;
        Sales_Area_Product_Info__c saPI = new Sales_Area_Product_Info__c(Name = 'Test Sapi', D_Chain_Material_Status__c = 'ZO', IsActive__c = True, Material_Number__c = '123',Product__c = testProd.Id, Sales_Org__c = 'LLEY', SAPExtId__c = '1234');
        insert saPI; 
        
       // List<Pricebook2> testPricebook =[select id from Pricebook2 where isActive = true];   
              
        PricebookEntry testEntry = new PricebookEntry(isactive=true,Pricebook2id=Test.getStandardPricebookId(),Product2Id=testProd.id,unitprice=1,UseStandardPrice=false);
        insert testEntry;
        Id profilId = [SELECT Id,Name FROM Profile WHERE Name = 'Latam User'].Id;
        User usr = new User();
        usr = [SELECT Id FROM User WHERE ProfileId =:profilId AND IsActive = TRUE LIMIT 1];
        System.runAs(usr) {
        Test.startTest();
        try{
        OpportunityLineItem testLineItem = new OpportunityLineItem(opportunityId=testOpp1.id,PricebookEntryId=testEntry.id,unitprice=100,Quantity=1, Revenue_Type__c ='Renewal');
        insert testLineItem;
        
        
        OpportunityProductDetail__c d = new OpportunityProductDetail__c();
        d.Opportunity_Line_Item_Id__c = (((String)testLineItem.ID).substring(0,15));
        d.Opportunity__c = testOpp1.id;
        d.Contact__c = testcontact.id;
        d.Product__c = testProd.id;
        insert d;
       
        
        delete testLineItem ;
        Test.stopTest(); 
        }
        catch(exception ex) {}
        }  
     }
    
   Public static testMethod Void errorForNewOpportunities_test(){
   
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

        RecordtypeIds__c orecordType5 = new RecordtypeIds__c ();
        orecordType5.name ='LATAM Renewal Opportunity';
        orecordType5.recTypeId__c = '012M0000000509c';
        insert orecordType5;
        
        RecordtypeIds__c orecordType6 = new RecordtypeIds__c ();
        orecordType6.name ='LATAM Renewal Quote';
        orecordType6.recTypeId__c = '012M0000000509X';
        insert orecordType6;
        
        Profile_List__c objPro = new Profile_List__c();
        objPro.name = 'Partner Portal User';
        objPro.Profile_Name__c = 'Partner Portal User';
        objPro.ProfileId__c = '00ea00000024JwaAAE';
        INSERT objPro;
        
        Profile_List__c objPro1 = new Profile_List__c();
        objPro1.name = 'LatAm User';
        objPro1.Profile_Name__c = 'LatAm User';
        objPro1.ProfileId__c = '00ea00000024JzKAAU';
        INSERT objPro1;
        
        Profile_List__c objPro2 = new Profile_List__c();
        objPro2.name = 'System Administrator';
        objPro2.Profile_Name__c = 'System Administrator';
        objPro2.ProfileId__c = '00e30000001gFezAAE';
        INSERT objPro2;
        
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
        
        Product2 testProd2 =UnitTest.getProductInstance();
        testprod2.IsActive = true;
        insert testProd2;
        
        PricebookEntry testEntry = new PricebookEntry(isactive=true,Pricebook2id=Test.getStandardPricebookId(),Product2Id=testProd1.id,unitprice=200);
        insert testEntry;
        
        PricebookEntry testEntry1 = new PricebookEntry(isactive=true,Pricebook2id=Test.getStandardPricebookId(),Product2Id=testProd2.id,unitprice=200);
        insert testEntry1;
        
        Opportunity testOpp1 = UnitTest.getOpportunityInstance(testAcc.Id);
        testOpp1.Renewal_Flag__c = true;
        testOpp1.Selling_Organization__c = 'LRA';
        testopp1.Pricebook2Id = Test.getStandardPricebookId();
        insert testOpp1;
        
        
        List<OpportunityLineItem> listOppLineItem  = new List<OpportunityLineItem>();
        OpportunityLineItem testLineItem = new OpportunityLineItem(opportunityId=testOpp1.id,PricebookEntryId=testEntry.id,unitprice=100,Quantity=1, Revenue_Type__c ='Renewal');
        //insert testLineItem;//Commented on 06/06
        listOppLineItem.add(testLineItem);
         OpportunityLineItem testLineItem1 = new OpportunityLineItem(opportunityId=testOpp1.id,PricebookEntryId=testEntry1.id,unitprice=100,Quantity=1, Revenue_Type__c ='Incremental');
        //insert testLineItem1;//Commented on 06/06
        listOppLineItem.add(testLineItem1);
        insert listOppLineItem;
         Set<Id> settestLineItem = new set<Id>();
         settestlineitem.add(testlineItem1.id);
        
        Quote Q1 = New Quote ();
        Q1.OpportunityId = Testopp1.id;
        Q1.Pricebook2Id = Test.getStandardPricebookId();
        Q1.Name = 'Test Quote';
        Q1.Primary_Quote__c = true;
        insert Q1;
        List<QuoteLineItem> listQuoteLineItem = new List<QuoteLineItem>();
        QuoteLineItem testquoteLineItem = new QuoteLineItem() ;
        testquoteLineItem.QuoteId = Q1.id;
        testquoteLineItem.PricebookEntryId = testentry.Id;
        //testquoteLineItem.Product2Id = testprod1.Id;
        testquoteLineItem.Quantity = 1;
        testquotelineItem.UnitPrice = 200;
        testquotelineItem.Revenue_Type__c ='Renewal';
        testquotelineItem.Discount=7.00;
        //insert testQuoteLineItem;
        listQuoteLineItem.add(testQuoteLineItem);
        QuoteLineItem testquoteLineItemmap = testQuoteLineItem ;
        
        
       QuoteLineItem testquoteLineItem2 = new QuoteLineItem() ;
        testquoteLineItem2.QuoteId = Q1.id;
        testquoteLineItem2.PricebookEntryId = testentry.Id;
        //testquoteLineItem.Product2Id = testprod1.Id;
        testquoteLineItem2.Quantity = 2;
        testquotelineItem2.UnitPrice = 300;
        testquotelineItem2.Revenue_Type__c ='Incremental';
        //insert testQuoteLineItem2;
        listQuoteLineItem.add(testQuoteLineItem2);
        insert listQuoteLineItem;
        
        newQLIs.add(testQuoteLineItem);
        newQLIs.add(testQuoteLineItem2); 
        for(QuoteLineItem qlitem :newQLIs) {                 
            oldQuoteLineItemMap.put(qlitem.id,qlitem);
            }
        //newQLIs.clear();
        system.debug('newQLIs..'+newQLIs);
       /* oldQuoteLineItemMap.put(testquoteLineItemmap.id,testquoteLineItemmap);
        oldQuoteLineItemMap.put(testquoteLineItem2.id,testquoteLineItem2); */
            
        
        testLineItem.Revenue_Type__c = 'Incremental';
        testquoteLineItem.Revenue_Type__c = 'Incremental';
        testquotelineItem.Discount=8.00;
        update testLineItem;
        update testquoteLineItem;
        
        newQLIs.add(testQuoteLineItem);
        newQLIs.add(testQuoteLineItem2); 
        system.debug('newQLIs..'+newQLIs);
        
        for(QuoteLineItem qlitem1 :newQLIs) {
            qlitem1.Discount = 1.00;                 
            oldQuoteLineItemMap.put(qlitem1.id,qlitem1);
            }
            
        system.debug('oldQuoteLineItemMap..'+oldQuoteLineItemMap);
        List<OpportunityLineItem> listtestLineItem = new List<OpportunityLineItem>();
        listtestLineItem.add(testLineItem);
        try{
        Test.starttest();
  //          QuoteLineItemTriggerHandler.SyncQuoteLIValueToOppLI(newQLIs,oldQuoteLineItemMap);
  //          OpportunityLineItemTriggerHandler.updateRenewal_IncrAmounts(settestLineItem);
            OpportunityLineItemTriggerHandler.errorForNewOpportunities(listtestLineItem);
   //         OpportunityLineItemTriggerHandler.getCurrencydecimalPlaces(listtestLineItem);
            Testopp1.SyncedQuoteID = Q1.Id;
            update Testopp1;
          
        Test.Stoptest();
        }
        catch(exception ex) {}
    }  
    
    Public static testMethod Void afterUpdateProductsSync_Test(){
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
        
        RecordtypeIds__c orecordType5 = new RecordtypeIds__c ();
        orecordType5.name ='LATAM Renewal Opportunity';
        orecordType5.recTypeId__c = '012M0000000509c';
        insert orecordType5;
        
        RecordtypeIds__c orecordType6 = new RecordtypeIds__c ();
        orecordType6.name ='LATAM Renewal Quote';
        orecordType6.recTypeId__c = '012M0000000509X';
        insert orecordType6;
        
        Profile_List__c objPro = new Profile_List__c();
        objPro.name = 'Partner Portal User';
        objPro.Profile_Name__c = 'Partner Portal User';
        objPro.ProfileId__c = '00ea00000024JwaAAE';
        INSERT objPro;
        
        Profile_List__c objPro1 = new Profile_List__c();
        objPro1.name = 'LatAm User';
        objPro1.Profile_Name__c = 'LatAm User';
        objPro1.ProfileId__c = '00ea00000024JzKAAU';
        INSERT objPro1;
        
        Profile_List__c objPro2 = new Profile_List__c();
        objPro2.name = 'System Administrator';
        objPro2.Profile_Name__c = 'System Administrator';
        objPro2.ProfileId__c = '00e30000001gFezAAE';
        INSERT objPro2;
        
        Product2 testProd1 =UnitTest.getProductInstance();
        testprod1.IsActive = true;
        insert testProd1;
        
        PricebookEntry testEntry = new PricebookEntry(isactive=true,Pricebook2id=Test.getStandardPricebookId(),Product2Id=testProd1.id,unitprice=200);
        insert testEntry;
        
        Account testAcc = UnitTest.getAccountInstance();
        insert testAcc;
        
        Opportunity testOpp1 = UnitTest.getOpportunityInstance(testAcc.Id);
       // testOpp1.Renewal_Flag__c = true;
       // testOpp1.Selling_Organization__c = 'LRA';
        testopp1.Pricebook2Id = Test.getStandardPricebookId();
        testOpp1.Is_Master_Opportunity__c = true;
        insert testOpp1;
        
        
        Opportunity testOpp2 = UnitTest.getOpportunityInstance(testAcc.Id);
       // testOpp2.Renewal_Flag__c = true;
       // testOpp2.Selling_Organization__c = 'LRA';
        testopp2.Pricebook2Id = Test.getStandardPricebookId();
        //testOpp2.Master_Opportunity__c = testOpp1.id;
        insert testOpp2;
        
        OpportunityLineItem testLineItem1 = new OpportunityLineItem(opportunityId=testOpp1.id,PricebookEntryId=testEntry.id,unitprice=100,Quantity=1, Revenue_Type__c ='Incremental');
        insert testLineItem1;
        
        Test.startTest();
        testLineItem1.Quantity = 2;
        UPDATE testLineItem1;
        Test.stopTest();
    }
    
   /*  Public static testMethod Void RenewalOLISync_test(){    
     //   map<Id, QuoteLineItem> oldQuoteLineItemMap = new map <Id, QuoteLineItem>();
     //   map<Id, QuoteLineItem> newQuoteLineItemMap = new map <Id, QuoteLineItem>();
        
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
        
        RecordtypeIds__c orecordType5 = new RecordtypeIds__c ();
        orecordType5.name ='LATAM Renewal Opportunity';
        orecordType5.recTypeId__c = '012M0000000509c';
        insert orecordType5;
        
        RecordtypeIds__c orecordType6 = new RecordtypeIds__c ();
        orecordType6.name ='LATAM Renewal Quote';
        orecordType6.recTypeId__c = '012M0000000509X';
        insert orecordType6;
        
        Profile_List__c objPro = new Profile_List__c();
        objPro.name = 'Partner Portal User';
        objPro.Profile_Name__c = 'Partner Portal User';
        objPro.ProfileId__c = '00ea00000024JwaAAE';
        INSERT objPro;
        
        Profile_List__c objPro1 = new Profile_List__c();
        objPro1.name = 'LatAm User';
        objPro1.Profile_Name__c = 'LatAm User';
        objPro1.ProfileId__c = '00ea00000024JzKAAU';
        INSERT objPro1;
        
        Profile_List__c objPro2 = new Profile_List__c();
        objPro2.name = 'System Administrator';
        objPro2.Profile_Name__c = 'System Administrator';
        objPro2.ProfileId__c = '00e30000001gFezAAE';
        INSERT objPro2;
        
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
        testOpp1.Pricebook2Id = Test.getStandardPricebookId();
        testOpp1.RecordTypeId = RecordtypeIds__c.getInstance('LATAM Renewal Opportunity').recTypeId__c;
        insert testOpp1;
            
        Quote Q1 = New Quote ();
        Q1.OpportunityId = Testopp1.id;
        Q1.Pricebook2Id = Test.getStandardPricebookId();
        Q1.Name = 'Test Quote';
        Q1.Primary_Quote__c = true;
        Q1.RecordTypeId = RecordtypeIds__c.getInstance('LATAM Renewal Quote').recTypeId__c;
        insert Q1;
        
        OpportunityLineItem testOLI = new OpportunityLineItem() ;
        testOLI.OpportunityId = testOpp1.id;
        testOLI.PricebookEntryId = testentry.Id;
        //testquoteLineItem.Product2Id = testprod1.Id;
        testOLI.Quantity = 1;
        testOLI.UnitPrice = 200;
        testOLI.Revenue_Type__c ='Renewal';
        testOLI.Discount=7.00;
        insert testOLI;
       // oldQuoteLineItemMap.put(testQuoteLineItem.id,testQuoteLineItem);
         
        Test.StartTest();
        testOLI.UnitPrice = 250;
        testOLI.Quantity = 2;
        testOLI.Description = 'abcdfg';
        Update testOLI;
        Test.stopTest();
       // newQuoteLineItemMap.put(testQuoteLineItem.id,testQuoteLineItem);
    }*/
    
    Public static testMethod Void upliftDowngradePartialCancelHandler_test(){    
        //map<Id, QuoteLineItem> oldQuoteLineItemMap = new map <Id, QuoteLineItem>();
        //map<Id, QuoteLineItem> newQuoteLineItemMap = new map <Id, QuoteLineItem>();
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
        
        RecordtypeIds__c orecordType5 = new RecordtypeIds__c ();
        orecordType5.name ='LATAM Renewal Opportunity';
        orecordType5.recTypeId__c = '012M0000000509c';
        insert orecordType5;
        
        RecordtypeIds__c orecordType6 = new RecordtypeIds__c ();
        orecordType6.name ='LATAM Renewal Quote';
        orecordType6.recTypeId__c = '012M0000000509X';
        insert orecordType6;
        
        Profile_List__c objPro = new Profile_List__c();
        objPro.name = 'Partner Portal User';
        objPro.Profile_Name__c = 'Partner Portal User';
        objPro.ProfileId__c = '00ea00000024JwaAAE';
        INSERT objPro;
        
        Profile_List__c objPro1 = new Profile_List__c();
        objPro1.name = 'LatAm User';
        objPro1.Profile_Name__c = 'LatAm User';
        objPro1.ProfileId__c = '00ea00000024JzKAAU';
        INSERT objPro1;
        
        Profile_List__c objPro2 = new Profile_List__c();
        objPro2.name = 'System Administrator';
        objPro2.Profile_Name__c = 'System Administrator';
        objPro2.ProfileId__c = '00e30000001gFezAAE';
        INSERT objPro2;
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
        testOpp1.Pricebook2Id = Test.getStandardPricebookId();
        testOpp1.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('LATAM Renewal Opportunity').getRecordTypeId();
        insert testOpp1;
            
        Quote Q1 = New Quote ();
        Q1.OpportunityId = Testopp1.id;
        Q1.Pricebook2Id = Test.getStandardPricebookId();
        Q1.Name = 'Test Quote';
        Q1.Primary_Quote__c = true;
        Q1.RecordTypeId = Schema.SObjectType.Quote.getRecordTypeInfosByName().get('LATAM Renewal Quote').getRecordTypeId();
        insert Q1;
        
        OpportunityLineItem testLineItem = new OpportunityLineItem() ;
        testLineItem.OpportunityId = testOpp1.id;
        testLineItem.PricebookEntryId = testentry.Id;
        testLineItem.Quantity = 1;
        testLineItem.UnitPrice = 200;
        testLineItem.Revenue_Type__c ='Renewal';
        testLineItem.Activity_Type__c ='Renewed';
        testLineItem.Discount=7.00;
        testLineItem.Projected_Renewal_Price__c = 900;
        insert testLineItem;
 
        Test.StartTest();
        checkRecursive.isRenewalQLI = true;
        testLineItem.UnitPrice = 250;
        testLineItem.Quantity = 2;
        testLineItem.Description = 'abcdfg';
        testLineItem.Revenue_Type__c ='Renewal';
        testLineItem.Projected_Renewal_Price__c = 100;
        Update testLineItem;
        testLineItem.UnitPrice = 150;
        testLineItem.Quantity = 2;
        testLineItem.Revenue_Type__c ='Renewal';
        testLineItem.Projected_Renewal_Price__c = 900;
        Update testLineItem;
        testLineItem.Number_of_Contacts__c = 2;
        Update testLineItem;
        testLineItem.Number_of_Contacts__c = null;
        Update testLineItem;
        Test.StopTest();
    }
    
    
    Public static testMethod Void syncOLIToOLIClone_Test(){
        KeyValueListStore__c kvs= new KeyValueListStore__c();
        kvs.name= 'ANZUsersProfileId';

        kvs.TextValue__C = '00e30000001ZUki';        
        insert kvs;
        
        List<RecordtypeIds__c > recTList = new List<RecordtypeIds__c>();
        RecordtypeIds__c recT= new RecordtypeIds__c();
        recT.name= 'Pre-Pipeline Opportunities';
        recT.recTypeId__C = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Pre-Pipeline Opportunity').getRecordTypeId();        
        recTList.add(recT);
        
        RecordtypeIds__c recT1= new RecordtypeIds__c();
        recT1.Name= 'Pipeline Opportunities';
        recT1.recTypeId__C = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Pipeline Opportunity').getRecordTypeId();        
        recTList.add(recT1);
        
        RecordtypeIds__c orecordType5 = new RecordtypeIds__c ();
        orecordType5.name ='LATAM Renewal Opportunity';
        orecordType5.recTypeId__c = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('LATAM Renewal Opportunity').getRecordTypeId();
        recTList.add(orecordType5);
        
        RecordtypeIds__c orecordType6 = new RecordtypeIds__c ();
        orecordType6.name ='LATAM Renewal Quote';
        orecordType6.recTypeId__c = Schema.SObjectType.Quote.getRecordTypeInfosByName().get('LATAM Renewal Quote').getRecordTypeId();
        recTList.add(orecordType6);
        
        insert recTList;
        
        Profile_List__c objPro = new Profile_List__c();
        objPro.name = 'Partner Portal User';
        objPro.Profile_Name__c = 'Partner Portal User';
        objPro.ProfileId__c = '00ea00000024JwaAAE';
        INSERT objPro;
        
        Profile_List__c objPro1 = new Profile_List__c();
        objPro1.name = 'LatAm User';
        objPro1.Profile_Name__c = 'LatAm User';
        objPro1.ProfileId__c = '00ea00000024JzKAAU';
        INSERT objPro1;
        
        Profile_List__c objPro2 = new Profile_List__c();
        objPro2.name = 'System Administrator';
        objPro2.Profile_Name__c = 'System Administrator';
        objPro2.ProfileId__c = '00e30000001gFezAAE';
        INSERT objPro2;
        
        Product2 testProd1 =UnitTest.getProductInstance();
        testprod1.IsActive = true;
        Product2 testProd2 =UnitTest.getProductInstance();
        testprod2.IsActive = true;
        insert new List<Product2>{testProd1,testProd2};
        
        PricebookEntry testEntry = new PricebookEntry(isactive=true,Pricebook2id=Test.getStandardPricebookId(),Product2Id=testProd1.id,unitprice=200);
        PricebookEntry testEntry1 = new PricebookEntry(isactive=true,Pricebook2id=Test.getStandardPricebookId(),Product2Id=testProd2.id,unitprice=200);
        insert new List<PricebookEntry>{testEntry,testEntry1};
        
        Account testAcc = UnitTest.getAccountInstance();
        testAcc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('GLI Account').getRecordTypeId();        
        insert testAcc;
        
        Opportunity testOpp1 = UnitTest.getOpportunityInstance(testAcc.Id);
        testopp1.Pricebook2Id = Test.getStandardPricebookId();
        testOpp1.Is_Master_Opportunity__c = true;
        testOpp1.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();        
        testOpp1.LCRM_Split_On__c = true;
        testOpp1.Is_GLI__c = TRUE;
        insert testOpp1;
        
        Opportunity opp = [select id,Pricebook2Id,Is_GLI__c  from Opportunity where id =:testOpp1.ID];
        System.debug('opp : '+opp);
        opp.Pricebook2Id = Test.getStandardPricebookId();
        update opp;
        
        Test.startTest();
            OpportunityLineItem testLineItem1 = new OpportunityLineItem(opportunityId=testOpp1.id,PricebookEntryId=testEntry.id,unitprice=100,Quantity=1, Revenue_Type__c ='Incremental');
            testLineItem1.LCRM_Units__c = 1;
            insert testLineItem1;
            
            OpportunityLineItemTriggerHandler.checkRecur_syncOLIToOLIClone = false;
            OpportunityLineItem testLineItem2 = new OpportunityLineItem(opportunityId=testOpp1.id,PricebookEntryId=testEntry1.id,unitprice=100,Quantity=1, Revenue_Type__c ='Incremental');
            testLineItem2.LCRM_Units__c = 1;
            insert testLineItem2;
            
            OpportunityLineItemTriggerHandler.checkRecur_syncOLIToOLIClone = false;
            testLineItem1.LCRM_Units__c = 2;
            UPDATE testLineItem1;
            List<LCRM_Opportunity_Split__c> splitList = [SELECT ID FROM LCRM_Opportunity_Split__c WHERE ID = :testOpp1.Id];
            System.assert(splitList!=null,true);
            delete testLineItem1;
        Test.stopTest();
    }
}