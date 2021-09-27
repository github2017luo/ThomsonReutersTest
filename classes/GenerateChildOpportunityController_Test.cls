@isTest

public with sharing class GenerateChildOpportunityController_Test
{
    public static testMethod void testPopulateChildOppties()
    {  

        Profile p = [SELECT Id FROM profile WHERE name='LatAm User'];   
        User u1 = new User(alias = 'newUser', email='usertest@mydomain.com', 
        emailencodingkey='UTF-8', lastname='Testing1', languagelocalekey='en_US', 
        localesidkey='en_US', profileid = p.Id, employeenumber='0144020',
        timezonesidkey='America/Los_Angeles', username='usertest46@mydomain.com');        
        // insert u1;
      
        List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c='00e30000001ZUki'),
        new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other'),
        new KeyValueListStore__c(Name='LCRMDisableStrikeIronServices',TextValue__c='True')};
        insert keyvaluestore;
        
        
        RecordtypeIds__c recT= new RecordtypeIds__c();
        recT.name= 'Pre-Pipeline Opportunities';
        recT.recTypeId__C = '012a0000001ZJxn';        
        insert recT;
        
        RecordtypeIds__c recT1= new RecordtypeIds__c();
        recT1.Name= 'Pipeline Opportunities';
        recT1.recTypeId__C = '012a0000001ZJxn';
        insert recT1;
        
        RecordtypeIds__c recT2= new RecordtypeIds__c();
        recT2.Name= 'LATAM Renewal Opportunity';
        recT2.recTypeId__C = '012a0000001ZJxn';
        insert recT2;        
        
        RecordtypeIds__c orecordType4 = new RecordtypeIds__c ();
        orecordType4.name ='Customer';
        orecordType4.recTypeId__c = '01230000001MA4a';
        insert orecordType4;
        
            Id pricebookId = Test.getStandardPricebookId();

            Pricebook2 pb = new Pricebook2();
            pb.IsActive =true;
            pb.Name ='Price Book';
            insert pb;
            
            Product2 pr = new Product2();
            pr.Name ='Product';
            insert pr;

            PricebookEntry spe = new PricebookEntry ();
            spe.IsActive=true;
            spe.Pricebook2Id=pricebookId;
            spe.Product2Id=pr.Id;
            spe.UnitPrice =0;
            insert spe;            
            
            PricebookEntry pe = new PricebookEntry ();
            pe.IsActive=true;
            pe.Pricebook2Id=pb.Id;
            pe.Product2Id=pr.Id;
            pe.UnitPrice =10;
            insert pe;        
        
        //system.runAs(u1){
            Account testAcc = new Account();
            testAcc = UnitTest.getAccountInstance();
            testAcc.RecordTypeId = RecordtypeIds__c.getValues('Customer').recTypeId__c; 
            testAcc.SAPAccountNumber__c = '1004879124';       
            insert testAcc;  
            
            Contact testcontact= UnitTest.getContactInstance(testAcc.Id);
            testcontact.LastName = 'testContact';
            testcontact.FirstName = 'testContact';
            testcontact.AccountId = testAcc.Id;
            testcontact.email = 'testfirst.testlast@thomson.com';
            testcontact.Work_Direct__c= '1234567891';
            insert testcontact;    
        
            Opportunity testOpp1 = UnitTest.getOpportunityInstance(testacc.Id);
            testOpp1.Renewal_Flag__c = true;
            testOpp1.Selling_Organization__c = 'LRA';
            testopp1.Pricebook2Id = pb.Id;
            //testopp1.Pricebook2Id = Test.getStandardPricebookId();
            testopp1.stageName= '90%';
            testopp1.is_Master_Opportunity__c = true;
            testopp1.CurrencyIsoCode='USD';
            insert testOpp1;

            OpportunityLineItem oli = new OpportunityLineItem();
            oli.OpportunityId = testOpp1.Id;
            oli.Quantity = 1;
            oli.List_Price__c = 100;
            oli.PricebookEntryId =pe.Id;
            oli.MOLI_id__c='1111';
            insert oli;
            
            Opportunity testOpp2 = UnitTest.getOpportunityInstance(testacc.Id);
            testOpp2.Renewal_Flag__c = true;
            testOpp2.Selling_Organization__c = 'LRA';
            testopp1.Pricebook2Id = pb.Id;
            //testopp1.Pricebook2Id = Test.getStandardPricebookId();
            testOpp2.stageName= '90%';
            testOpp2.Master_Opportunity__c = testOpp1.Id;
            testopp2.CurrencyIsoCode='ARS';
            insert testOpp2;            
            
            Quote oquote = new quote();
            oquote.name = 'test';
            oquote.OpportunityId= Testopp1.id;
            oquote.Primary_Quote__c=true;
            oQuote.status = 'Prevalidate for Final Approval';
            oQuote.Is_Master_Quote__c = true;
            insert oQuote;
            
            
            
            List<Billing_Account_Split__c> lstBA1 = new List<Billing_Account_Split__c>();
            Billing_Account_Split__c testBA1 = new Billing_Account_Split__c();
            testBA1.Account__c = testAcc.Id;
            testBA1.child_Opportunity__c = testOpp2.Id;
            testBA1.Master_Opportunity__c = testOpp1.Id;
            testBA1.Product_1_Sales_Price__c = 2.000;
            testBA1.Product_2_Sales_Price__c = 3.000;
            testBA1.Product_3_Sales_Price__c = 4.000;
            testBA1.E_Billing_Contact__c = testcontact.Id;
            testBA1.Boleto_Contact__c = testcontact.Id;     
            testBA1.PO_Number__c = '12345';   
            testBA1.CurrencyIsoCode='ARS';
            testBA1.OLI_id_1__c=String.valueOf(oli.Id);
            lstBA1.add(testBA1);
            insert lstBA1;

           
            Test.StartTest();
            
            PageReference pref=Page.GenerateBAChildOpportunity;
            pref.getParameters().put('id',testOpp1.Id);  
            pref.getParameters().put('recs',lstBA1[0].id); 
            Test.setCurrentPage(pref);     
            ApexPages.StandardSetController stdSetController = new ApexPages.StandardSetController(lstBA1);
            stdSetController.setSelected(lstBA1);
            GenerateBAChildOpportunityController con = new GenerateBAChildOpportunityController(stdSetController);
            con.PopulateChildOppties(); 
            con.goBackToOppty();
            con.getOpptyCurrencyEquivalantValue(1.5,'USD','ARS');
            List<Opportunity> opptyList = new List<Opportunity>();
            opptyList.add(testOpp2);
            String jString = JSON.serialize(opptyList);
            GenerateBAChildOpportunityController.futureSyncOptyList(jString);
            con.currentPageURL = 'eer';
            con.isSales = true;
            Test.StopTest();

    }
    
    public static testMethod void testPopulateChildOppties1()
    {  

        Profile p = [SELECT Id FROM profile WHERE name='LatAm User'];   
        User u1 = new User(alias = 'newUser', email='usertest@mydomain.com', 
        emailencodingkey='UTF-8', lastname='Testing1', languagelocalekey='en_US', 
        localesidkey='en_US', profileid = p.Id, employeenumber='0144020',
        timezonesidkey='America/Los_Angeles', username='usertest46@mydomain.com');        
        // insert u1;
      
        List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c='00e30000001ZUki'),
        new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other'),
        new KeyValueListStore__c(Name='LCRMDisableStrikeIronServices',TextValue__c='True')};
        insert keyvaluestore;
        
        
        RecordtypeIds__c recT= new RecordtypeIds__c();
        recT.name= 'Pre-Pipeline Opportunities';
        recT.recTypeId__C = '012a0000001ZJxn';        
        insert recT;
        
        RecordtypeIds__c recT1= new RecordtypeIds__c();
        recT1.Name= 'Pipeline Opportunities';
        recT1.recTypeId__C = '012a0000001ZJxn';
        insert recT1;
        
        RecordtypeIds__c recT2= new RecordtypeIds__c();
        recT2.Name= 'LATAM Renewal Opportunity';
        recT2.recTypeId__C = '012a0000001ZJxn';
        insert recT2;        
        
        RecordtypeIds__c orecordType4 = new RecordtypeIds__c ();
        orecordType4.name ='Customer';
        orecordType4.recTypeId__c = '01230000001MA4a';
        insert orecordType4;
        
            Id pricebookId = Test.getStandardPricebookId();

            Pricebook2 pb = new Pricebook2();
            pb.IsActive =true;
            pb.Name ='Price Book';
            insert pb;
            
            Product2 pr = new Product2();
            pr.Name ='Product';
            insert pr;

            PricebookEntry spe = new PricebookEntry ();
            spe.IsActive=true;
            spe.Pricebook2Id=pricebookId;
            spe.Product2Id=pr.Id;
            spe.UnitPrice =0;
            insert spe;            
            
            PricebookEntry pe = new PricebookEntry ();
            pe.IsActive=true;
            pe.Pricebook2Id=pb.Id;
            pe.Product2Id=pr.Id;
            pe.UnitPrice =10;
            insert pe;        
        
        //system.runAs(u1){
            Account testAcc = new Account();
            testAcc = UnitTest.getAccountInstance();
            testAcc.RecordTypeId = RecordtypeIds__c.getValues('Customer').recTypeId__c; 
            testAcc.SAPAccountNumber__c = '1004879124';       
            insert testAcc;  
            
            Contact testcontact= UnitTest.getContactInstance(testAcc.Id);
            testcontact.LastName = 'testContact';
            testcontact.FirstName = 'testContact';
            testcontact.AccountId = testAcc.Id;
            testcontact.email = 'testfirst.testlast@thomson.com';
            testcontact.Work_Direct__c= '1234567891';
            insert testcontact;    
        
            Opportunity testOpp1 = UnitTest.getOpportunityInstance(testacc.Id);
            testOpp1.Renewal_Flag__c = false;
            testOpp1.Selling_Organization__c = 'LRA';
            testopp1.Pricebook2Id = pb.Id;
            //testopp1.Pricebook2Id = Test.getStandardPricebookId();
            testopp1.stageName= '90%';
            testopp1.is_Master_Opportunity__c = true;
            testopp1.CurrencyIsoCode='USD';
            insert testOpp1;

            OpportunityLineItem oli = new OpportunityLineItem();
            oli.OpportunityId = testOpp1.Id;
            oli.Quantity = 1;
            oli.List_Price__c = 100;
            oli.PricebookEntryId =pe.Id;
            oli.MOLI_id__c='1111';
            insert oli;
            
            Opportunity testOpp2 = UnitTest.getOpportunityInstance(testacc.Id);
            testOpp2.Renewal_Flag__c = false;
            testOpp2.Selling_Organization__c = 'LRA';
            testopp1.Pricebook2Id = pb.Id;
            //testopp1.Pricebook2Id = Test.getStandardPricebookId();
            testOpp2.stageName= '90%';
            testOpp2.Master_Opportunity__c = testOpp1.Id;
            testopp2.CurrencyIsoCode='USD';
            insert testOpp2;            
            
            Quote oquote = new quote();
            oquote.name = 'test';
            oquote.OpportunityId= Testopp1.id;
            oquote.Primary_Quote__c=true;
            oQuote.status = 'Prevalidate for Final Approval';
            oQuote.Is_Master_Quote__c = true;
            insert oQuote;
            
            
            
            List<Billing_Account_Split__c> lstBA1 = new List<Billing_Account_Split__c>();
            Billing_Account_Split__c testBA1 = new Billing_Account_Split__c();
            testBA1.Account__c = testAcc.Id;
            testBA1.child_Opportunity__c = testOpp2.Id;
            testBA1.Master_Opportunity__c = testOpp1.Id;
            testBA1.Product_1_Sales_Price__c = 2.000;
            testBA1.Product_2_Sales_Price__c = 3.000;
            testBA1.Product_3_Sales_Price__c = 4.000;
            testBA1.E_Billing_Contact__c = testcontact.Id;
            testBA1.Boleto_Contact__c = testcontact.Id;     
            testBA1.PO_Number__c = '12345';   
            testBA1.CurrencyIsoCode='ARS';
            testBA1.OLI_id_1__c=String.valueOf(oli.Id);
            lstBA1.add(testBA1);
            insert lstBA1;

           
            Test.StartTest();
            
            PageReference pref=Page.GenerateBAChildOpportunity;
            pref.getParameters().put('id',testOpp1.Id);  
            pref.getParameters().put('recs',lstBA1[0].id); 
            Test.setCurrentPage(pref);     
            ApexPages.StandardSetController stdSetController = new ApexPages.StandardSetController(lstBA1);
            stdSetController.setSelected(lstBA1);
            GenerateBAChildOpportunityController con = new GenerateBAChildOpportunityController(stdSetController);
            con.PopulateChildOppties(); 
            con.goBackToOppty();
            con.getOpptyCurrencyEquivalantValue(1.5,'USD','ARS');
            List<Opportunity> opptyList = new List<Opportunity>();
            opptyList.add(testOpp2);
            String jString = JSON.serialize(opptyList);
            GenerateBAChildOpportunityController.futureSyncOptyList(jString);
            con.currentPageURL = 'eer';
            con.isSales = true;
            Test.StopTest();

    }
}