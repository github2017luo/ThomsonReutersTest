@IsTest
private class ManageBillingAccountsController_Test {    
   
    private static testMethod void testManageBillingAccountsController() {
        Decimal decSubAmt = 100.000;
        Decimal decAmt = 10.000;
        List<OpportunityLineItem> lstOppLineItem = new List<OpportunityLineItem>();          
                
        KeyValueListStore__c oKeyValue = new KeyValueListStore__c();
        oKeyValue.name = 'ANZUsersProfileId';
        oKeyValue.TextValue__c = '00e30000001ZUki';
        insert oKeyValue;
        
        RecordtypeIds__c orecordType = new RecordtypeIds__c ();
        orecordType.name ='ANZ Case';
        orecordType.recTypeId__c = '012a0000001ZJxn';
        insert orecordType;
        
        Product2 oProduct1 = new Product2();
        oProduct1.Name = 'Unit Test Product';
        oProduct1.isActive = true;
        insert oProduct1;
        
        Product2 oProduct2 = new Product2();
        oProduct2.Name = 'Unit Test Product';
        oProduct2.isActive = true;
        insert oProduct2;
        
        Product2 oProduct3 = new Product2();
        oProduct3.Name = 'Unit Test Product';
        oProduct3.isActive = true;
        insert oProduct3;
        
        RecordtypeIds__c orecordType1 = new RecordtypeIds__c ();
        orecordType1.name ='Pipeline Opportunities';
        orecordType1.recTypeId__c = '01230000001MA4g';
        insert orecordType1;
        
        RecordtypeIds__c orecordType2 = new RecordtypeIds__c ();
        orecordType2.name ='Pre-Pipeline Opportunities';
        orecordType2.recTypeId__c = '01230000001MA4h';
        insert orecordType2;
        
        RecordtypeIds__c orecordType3 = new RecordtypeIds__c ();
        orecordType3.name ='Prospect';
        orecordType3.recTypeId__c = '01230000001MA4c';
        insert orecordType3;
        
        RecordtypeIds__c orecordType4 = new RecordtypeIds__c ();
        orecordType4.name ='Customer';
        orecordType4.recTypeId__c = '01230000001MA4a';
        insert orecordType4;
        
        Account testAcc = new Account();
        testAcc = UnitTest.getAccountInstance();
        testAcc.RecordTypeId = RecordtypeIds__c.getValues('Customer').recTypeId__c; 
        testAcc.SAPAccountNumber__c = '1004879124';       
        insert testAcc; 

        Contact testCon = new Contact();
        testCon = UnitTest.getContactInstance(testAcc.id);
        testCon.SAP_Contact_ID__c = '';
        testCon.Work_Direct__c = '1234567890';
        testCon.Email = 'abc@gmail.com';
        INSERT testCon;
        
        Opportunity testOpp1 = new Opportunity();
        testOpp1 = UnitTest.getOpportunityInstance(testAcc.Id);
        testOpp1.RecordTypeId = RecordtypeIds__c.getValues('Pre-Pipeline Opportunities').recTypeId__c;
     // testOpp1.RecordTypeId = '01230000001MA4h';        
     // testOpp1.RecordType.Name = 'Pipeline_Opportunity';
        
        testOpp1.Oppty_Mgmt_Type__c = 'Split Billing';
        testOpp1.Amount = decAmt;
        //temp skg
        //testOpp1.ForecastCategoryName = 'Potential/Swing';
        testOpp1.ForecastCategoryName = 'Pipeline';
        testOpp1.currencyIsoCode = 'USD';        
        insert testOpp1;
        
        Opportunity testOpp2 = new Opportunity();
        testOpp2 = UnitTest.getOpportunityInstance(testAcc.Id);
        testOpp2.RecordTypeId = RecordtypeIds__c.getValues('Pre-Pipeline Opportunities').recTypeId__c;
     
        testOpp2.Oppty_Mgmt_Type__c = 'Split Billing';
        testOpp2.Amount = decAmt;        
        testOpp2.ForecastCategoryName = 'Pipeline';
        testOpp2.currencyIsoCode = 'USD';        
        insert testOpp2;
        
        Opportunity testOpp3 = new Opportunity();
        testOpp3 = UnitTest.getOpportunityInstance(testAcc.Id);
        testOpp3.RecordTypeId = RecordtypeIds__c.getValues('Pre-Pipeline Opportunities').recTypeId__c;
     
        testOpp3.Oppty_Mgmt_Type__c = 'Split Billing';
        testOpp3.Amount = decAmt;        
        testOpp3.ForecastCategoryName = 'Pipeline';
        testOpp3.currencyIsoCode = 'USD';        
        insert testOpp3;
        
        List<Billing_Account_Split__c> lstBA1 = new List<Billing_Account_Split__c>();
        Billing_Account_Split__c testBA1 = new Billing_Account_Split__c();
        testBA1.Account__c = testAcc.Id;
        testBA1.Master_Opportunity__c = testOpp1.Id;
        testBA1.Product_1__c = oProduct1.Id;
        testBA1.Product_2__c = oProduct2.Id;
        testBA1.Product_3__c = oProduct3.Id;
        testBA1.Product_1_Sales_Price__c = 2.000;
        testBA1.Product_2_Sales_Price__c = 3.000;
        testBA1.Product_3_Sales_Price__c = 4.000;
        testBA1.E_Billing_Contact__c = testCon.id;
        testBA1.Boleto_Contact__c = testCon.id;
        lstBA1.add(testBA1);
        insert lstBA1;
        
        List<Billing_Account_Split__c> lstBA2 = new List<Billing_Account_Split__c>();
        Billing_Account_Split__c testBA2 = new Billing_Account_Split__c();
        testBA2.Account__c = testAcc.Id;
        testBA2.Master_Opportunity__c = testOpp2.Id;
        //testBA2.Product_1__c = null;
        testBA2.Product_2__c = oProduct2.Id;
        testBA2.Product_3__c = oProduct3.Id;
        //testBA2.Product_1_Sales_Price__c = 2.000;
        testBA2.Product_2_Sales_Price__c = 3.000;
        testBA2.Product_3_Sales_Price__c = 4.000;
        testBA2.E_Billing_Contact__c = testCon.id;
        testBA2.Boleto_Contact__c = testCon.id;
        lstBA2.add(testBA2);
        insert lstBA2;
        
        List<Billing_Account_Split__c> lstBA3 = new List<Billing_Account_Split__c>();
        Billing_Account_Split__c testBA3 = new Billing_Account_Split__c();
        testBA3.Account__c = testAcc.Id;
        testBA3.Master_Opportunity__c = testOpp3.Id;
        testBA3.Product_1__c = oProduct1.Id;
        //testBA3.Product_2__c = oProduct2.Id;
        testBA3.Product_3__c = oProduct3.Id;
        testBA3.Product_1_Sales_Price__c = 2.000;
        //testBA3.Product_2_Sales_Price__c = 3.000;
        testBA3.Product_3_Sales_Price__c = 4.000;
        testBA3.E_Billing_Contact__c = testCon.id;
        testBA3.Boleto_Contact__c = testCon.id;
        lstBA3.add(testBA3);
        insert lstBA3;        
        
        List<Billing_Account_Split__c> lstBA4 = new List<Billing_Account_Split__c>();
        
        Pricebook2 customPB = new Pricebook2(Name='Custom Pricebook', isActive=true);
        insert customPB;
        
        Pricebook2 customPB1 = new Pricebook2(Name='Custom Pricebook', isActive=true);
        insert customPB1;

        /*Product2 testProd =UnitTest.getProductInstance();
        insert testProd;
        
        Product2 testProd1 =UnitTest.getProductInstance();
        insert testProd1;
        
        Product2 testProd2 =UnitTest.getProductInstance();
        insert testProd2;*/
        
        PricebookEntry testEntry = new PricebookEntry(CurrencyIsoCode='USD',isactive=true,Pricebook2id=Test.getStandardPricebookId(),Product2Id=oProduct1.id,unitprice=1,UseStandardPrice=false);
        insert testEntry;
        
        PricebookEntry testEntry1 = new PricebookEntry(CurrencyIsoCode='USD',isactive=true,Pricebook2id=Test.getStandardPricebookId(),Product2Id=oProduct2.id,unitprice=1); //,UseStandardPrice=false);
        insert testEntry1;
        
        PricebookEntry testEntry2 = new PricebookEntry(CurrencyIsoCode='USD',isactive=true,Pricebook2id=Test.getStandardPricebookId(),Product2Id=oProduct3.id,unitprice=1); //,UseStandardPrice=false);
        insert testEntry2;
        
        OpportunityLineItem testLineItem1 = new OpportunityLineItem(opportunityId=testOpp1.id,PricebookEntryId=testEntry.id,unitprice=100,Quantity=1, Revenue_Type__c ='Renewal');
        //insert testLineItem1; 
        
        OpportunityLineItem testLineItem2 = new OpportunityLineItem(opportunityId=testOpp1.id,PricebookEntryId=testEntry1.id,unitprice=100,Quantity=1, Revenue_Type__c ='Renewal');
        //insert testLineItem2; 
        
        OpportunityLineItem testLineItem3 = new OpportunityLineItem(opportunityId=testOpp1.id,PricebookEntryId=testEntry2.id,unitprice=100,Quantity=1, Revenue_Type__c ='Renewal');
        //insert testLineItem3;     
        
        lstOppLineItem.add(testLineItem1); 
        lstOppLineItem.add(testLineItem2); 
        lstOppLineItem.add(testLineItem3);
        insert lstOppLineItem;
        
        try{
            Test.startTest();
            PageReference pref=Page.ManageBillingAccounts;
            pref.getParameters().put('id',testOpp1.Id);
            pref.getParameters().put('rowNum' , '1');
           // pref.getParameters().put('index','0');
            Test.setCurrentPage(pref);
           // Billing_Account_Split__c testBA = new Billing_Account_Split__c(Account__c = testAcc.Id, Master_Opportunity__c = testOpp1.Id);        
            ApexPages.StandardSetController stdSetController = new ApexPages.StandardSetController(lstBA1);
            stdSetController.setSelected(lstBA1);            
            ManageBillingAccountsController con = new ManageBillingAccountsController(stdSetController);
            con.addBillAcct();
            con.saveBillAccts();
            con.saveCloseBillAccts();
            con.deleteBillAcct(); 
            
            ApexPages.StandardSetController stdSetController1 = new ApexPages.StandardSetController(lstBA2);
            stdSetController1.setSelected(lstBA2);
            ManageBillingAccountsController con1 = new ManageBillingAccountsController(stdSetController1);
            con1.addBillAcct();
            con1.saveBillAccts();
            con1.saveCloseBillAccts();
            con1.deleteBillAcct();
            
            ApexPages.StandardSetController stdSetController2 = new ApexPages.StandardSetController(lstBA3);
            stdSetController2.setSelected(lstBA3);
            ManageBillingAccountsController con2 = new ManageBillingAccountsController(stdSetController2);
            //con2.addBillAcct();
            con2.saveBillAccts();
            con2.saveCloseBillAccts();
            con2.deleteBillAcct();   
            
            ApexPages.StandardSetController stdSetController3 = new ApexPages.StandardSetController(lstBA4);
            stdSetController3.setSelected(lstBA4);
            ManageBillingAccountsController con3 = new ManageBillingAccountsController(stdSetController3);
            //con3.addBillAcct();
            con3.saveBillAccts();
            con3.saveCloseBillAccts();
            //con3.deleteBillAcct();   
                
            Test.stopTest();
            
            
        }
        catch(Exception ex){}
    } 
    
    
}