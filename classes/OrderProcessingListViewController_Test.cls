/*
======================================================================================================================
TEST CLASS NAME: OrderProcessingListViewController_Test
======================================================================================================================
PURPOSE: Validates the functionality provided by the OrderProcessingListViewController class.

CHANGE HISTORY:
======================================================================================================================
DATE              NAME           DESC
31/03/2017        Karthi G       Optimized the code as per JIRA STORY: PS0-1
======================================================================================================================
*/
@isTest
Public Class OrderProcessingListViewController_Test
{

    Public Static testmethod void callOrderProcessingList()
    {
        
        
        try{
            
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
            
            LatamGeneral__c l1g= new LatamGeneral__c();
            l1g.Name= 'Opp Stage 0';
            l1g.Value__C = '0%';
            insert l1g;
            LatamGeneral__c l1g1= new LatamGeneral__c();
            l1g1.Name= 'Submitted for Processing';
            l1g1.Value__C = 'Submitted for Processing';
            insert l1g1;
            LatamGeneral__c l1g2= new LatamGeneral__c();
            l1g2.Name= 'Sales Admin Pending Review';
            l1g2.Value__C = 'Sales Admin - Pending Review';
            insert l1g2;
            LatamGeneral__c l1g3= new LatamGeneral__c();
            l1g3.Name= 'OP Rejected';
            l1g3.Value__C = 'OP Rejected';
            insert l1g3;
            
            
            string strFieldSetNAme=Schema.SObjectType.Quote.fieldSets.getMap().values()[0].getName();
            
            List<OrderProcessingListView__c> lstOPLW = new List<OrderProcessingListView__c>();
            
            
            
           /* lstOPLW.add(opCS);
            
            opCS = new OrderProcessingListView__c();
            opCS.Name= 'Accept Quotes-Brazil';
            opCS.ListView_FieldSet_Name__C = strFieldSetNAme;
            opCS.ListView_Query__c = 'Where op_owner__c = null';
            
            lstOPLW.add(opCS);
            
            opCS = new OrderProcessingListView__c();
            opCS.Name= 'Accept Quotes-S LatAm';
            opCS.ListView_FieldSet_Name__C = strFieldSetNAme;
            opCS.ListView_Query__c = 'Where op_owner__c = null';
            lstOPLW.add(opCS);
            
            insert lstOPLW;*/
            
            
            system.runAs(u1){
                UnitTest.createTestData();//01/06/2016 : Mrinmoy Sarkar - Added for MCL-1560
                Account testAcc = UnitTest.getAccountInstance();
                testAcc.Sales_Org__c = 'LLEY'; // Fixing Sales Org Validation Issue
                insert testAcc;
                system.assertequals('LLEY',testAcc.Sales_Org__c);
                
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
                //01/06/2016 : Mrinmoy Sarkar - Added for MCL-1560
                testopp1.RecordTypeId = RecordtypeIds__c.getValues('Pipeline Opportunities').recTypeId__c;
                insert testOpp1;
                 
                 // inserted Opportunity Contact role cover QuoteTriggerHandler Class.
                 
                /*OpportunityContactRole ocr1 = new OpportunityContactRole(Role='Boleto',opportunityid=testopp1.id,contactid=testcontact.id,IsPrimary=true);
                insert ocr1; */ // commented and to separate this to repective test class
                
                Quote Q1 = New Quote ();
                Q1.OpportunityId = Testopp1.id;
                Q1.Pricebook2Id = Test.getStandardPricebookId();
                Q1.Name = 'TEST123';
                Q1.Status = 'Submitted for Processing';
                
                insert Q1;
                
                
                Q1.Status = 'Sales Admin Pending Review';
                Update Q1;   
                
                Product2 testProd =UnitTest.getProductInstance();
                insert testProd; 
                PricebookEntry testEntry = new PricebookEntry(isactive=true,Pricebook2id=Test.getStandardPricebookId(),Product2Id=testProd.id,unitprice=1,UseStandardPrice=false);
                insert testEntry;            
                OpportunityLineItem testLineItem = new OpportunityLineItem(opportunityId=testOpp1.id,PricebookEntryId=testEntry.id,unitprice=100,Quantity=1, Revenue_Type__c ='Renewal');
                insert testLineItem;  // commented and to separate this to repective test class
                OpportunityProductDetail__c d = new OpportunityProductDetail__c();
                d.Opportunity_Line_Item_Id__c = (((String)testLineItem.ID).substring(0,15));
                d.Opportunity__c = testOpp1.id;
                d.Contact__c = testcontact.id;
                d.Product__c = testProd.id;
               // insert d;   //commented to prevent 101 soql error.
                            
                Q1.Primary_Quote__c= true;
                Update Q1;
                
                LatamGeneral__c lg= new LatamGeneral__c();
                lg.Name= 'Submitted for Processing';
                lg.Value__C = 'Submitted for Processing';
                insert lg; 
                
                Test.StartTest(); 
                system.runAs(u1){
                insert d;
                OrderProcessingListView__c opCS = new OrderProcessingListView__c();
                opCS.Name= 'TEST123';
                opCS.ListView_FieldSet_Name__C = strFieldSetNAme;
                opCS.ListView_Query__c = 'WHERE QuoteNumber !=null';
                opCS.ListView_Query2__c = '';
                // opcs.Sales_Org__c='LatAm';
                // opcs.Order__c=1;
                insert opCS;
                
                OrderProcessingListView__c opCS1 = new OrderProcessingListView__c();
                opCS1.Name= 'Accept Quotes - Brazil';
                opCS1.ListView_FieldSet_Name__C = 'Pending_Order_Processing';
                opCS1.ListView_Query__c = 'WHERE QuoteNumber !=null';
                opCS1.ListView_Query2__c = 'Order By Owner';
                opcs1.Sales_Org__c='LatAm';
                opcs1.Order__c=1;
                insert opCS1;
                
                OrderProcessingListView__c opCS2 = new OrderProcessingListView__c();
                opCS2.Name= 'Accept Quotes - S LatAm';
                opCS2.ListView_FieldSet_Name__C = 'Pending_Order_Processing';
                opCS2.ListView_Query__c = 'WHERE QuoteNumber !=null ';
                opCS2.ListView_Query2__c = 'Order By Owner';
                opcs2.Sales_Org__c='LatAm';
                opcs1.Order__c=1;
                insert opCS2;
                ApexPages.StandardController sc = new ApexPages.StandardController(Q1);
                OrderProcessingListViewController OrderProcess = new OrderProcessingListViewController(sc);
                OrderProcessingListViewController OrderProcess1 = new OrderProcessingListViewController(sc);
                OrderProcessingListViewController.wrapQuote wp; 
                OrderProcess.LoadData();
                OrderProcess.receiveSalesOrg();
                
              //  orderProcess.SelectedFilter = 'TEST123';
                orderProcess.strSelectedFilter = 'TEST123';
                OrderProcess.LoadData();
                OrderProcess.getFields();
                OrderProcess.setSortDirection('ASC');
                OrderProcess.getSortDirection();
                OrderProcess.setSelectedFilter('TEST123');    
                OrderProcess.getselectedfilter();
                OrderProcess.strFieldLabel1 = 'ABC';
                
                
                
             //  OrderProcess.quoteError= false;
               // OrderProcess.SelectedFilter='Accept Quotes - Brazil';
                OrderProcess.LoadData();
                OrderProcess.receiveSalesOrg();
                OrderProcess.ProcessSelected();
                OrderProcess.cancel();
                OrderProcess.strFieldLabelName = 'Quote Number';
                OrderProcess.getFilters();
                //OrderProcess.receiveSalesOrg();
                OrderProcess.getCurrentQuotePageMapSize();
                OrderProcess.getQuoteMapSize();
                OrderProcess.getQuoteMapKeySetSize();
                OrderProcess.first();
                OrderProcess.next();
                OrderProcess.previous();
                OrderProcess.last();
                OrderProcess.first();
                OrderProcess.currentQuotePage=2;
                OrderProcess.next();
                OrderProcess.previous();
                OrderProcess.last();
                OrderProcess.selectedSalesORG='None';
                OrderProcess.Go();
                OrderProcess.LoadData();
                
                orderProcess.strSelectedFilter = '';
                OrderProcess.LoadData();
                OrderProcess.getFields();
                OrderProcess.setSortDirection('ASC');
                OrderProcess.getSortDirection();
                OrderProcess.setSelectedFilter('');    
                OrderProcess.getselectedfilter();
                OrderProcess.strFieldLabel1 = 'ABC';
                
           //     OrderProcess.quoteError= false;
               // OrderProcess.SelectedFilter='Accept Quotes - Brazil';
                OrderProcess.LoadData();
                OrderProcess.receiveSalesOrg();
                OrderProcess.ProcessSelected();
                OrderProcess.cancel();
                OrderProcess.strFieldLabelName = 'Quote Number';
                OrderProcess.getFilters();
                //OrderProcess.receiveSalesOrg();
                OrderProcess.getCurrentQuotePageMapSize();
                OrderProcess.getQuoteMapSize();
                OrderProcess.getQuoteMapKeySetSize();
                OrderProcess.first();
                OrderProcess.next();
                OrderProcess.previous();
                OrderProcess.last();
                OrderProcess.first();
                OrderProcess.currentQuotePage=2;
                OrderProcess.next();
                OrderProcess.previous();
                OrderProcess.last();
                OrderProcess.selectedSalesORG='None';
                OrderProcess.Go();
                OrderProcess.LoadData();
                
                
                OrderProcess1.strSelectedFilter = 'Accept Quotes - Brazil';  
                OrderProcess1.LoadData();
                OrderProcess1.receiveSalesOrg();
                //system.debug('*** test set clling');
                OrderProcess1.getFields();
                OrderProcess1.getSortDirection();
                OrderProcess1.setSortDirection('ASC');
                OrderProcess1.setSelectedFilter('Accept Quotes - Brazil');    
                OrderProcess1.getselectedfilter();
                OrderProcess1.receiveSalesOrg();
                OrderProcess1.LoadData(); 
             //   OrderProcess1.quoteError= false;
                OrderProcess1.strFieldLabelName = 'Quote Number';
                OrderProcess1.ProcessSelected();
                OrderProcess1.getFilters();
                OrderProcess1.receiveSalesOrg();
                OrderProcess1.getCurrentQuotePageMapSize();
                OrderProcess1.getQuoteMapKeySetSize();
                OrderProcess1.LoadData();
                OrderProcess1.selectedSalesORG='None';
                OrderProcess1.Go();
            
              
                OrderProcess1.strSelectedFilter = null;  
                OrderProcess1.LoadData();
                OrderProcess1.receiveSalesOrg(); 
              
            }            
        
        } 
               
    
       Test.StopTest();
    }
   // Test.StopTest();
    Catch(Exception ex){
            
                system.debug('**Error occured in Test Class::' + ex.getMEssage());
                throw ex;
            
        }   
    
    }
}