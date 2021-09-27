@istest(seeAllData=false)
private class productSelectionController_Test{
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
        
        OpportunityLineItem testLineItem1 = new OpportunityLineItem(opportunityId=testOpp1.id,PricebookEntryId=testEntry1.id,unitprice=100,Quantity=1, Revenue_Type__c ='Renewal');
        //testLineItem.RenewalCheck__c = true;
        testLineItem1.Activity_Type__c = 'Renewed';
        testlineItem1.Cancel_Reason__c = null;
        insert testLineItem1;
        
        Quote testQuote = New Quote ();
        testQuote.OpportunityId = testOpp1.id;
        testQuote.Pricebook2Id = customPB.Id;
        testQuote.Name = 'Test Quote';
        testQuote.RecordTypeId = Schema.SObjectType.Quote.getRecordTypeInfosByName().get('LATAM Renewal Quote').getRecordTypeId();
        insert testQuote;
        
        QuoteLineItem testquoteLineItem = new QuoteLineItem() ;
        testquoteLineItem.QuoteId = testQuote.id;
        testquoteLineItem.PricebookEntryId = testentry1.Id;
        testquoteLineItem.Quantity = 1;
        testquotelineItem.UnitPrice = 200;
        insert testQuoteLineItem;
        
        productSelectionController.LATAMPRODUCT oLatamPro = new productSelectionController.LATAMPRODUCT(testLineItem,true);
        oLatamPro.productName = testLineItem.Product2.Name;
        oLatamPro.materialCode = testLineItem.product2.ProductCode;      
                
        list<productSelectionController.LATAMPRODUCT> latamProductList = new list<productSelectionController.LATAMPRODUCT>();
        latamProductList.add(oLatamPro);
        
        productSelectionController.LATAMPRODUCT oLatamPro1 = new productSelectionController.LATAMPRODUCT(testLineItem1,true);
        oLatamPro1.productName = testLineItem1.Product2.Name;
        oLatamPro1.materialCode = testLineItem1.product2.ProductCode;        
        latamProductList.add(oLatamPro1);        
        
        list<OpportunityLineItem> lstUnselectedOLI = new list<OpportunityLineItem>();
        lstUnselectedOLI.add(testLineItem);
        
        Test.startTest();
        PageReference pref=Page.ProductSelection;
        pref.getParameters().put('id',testOpp1.Id);
        pref.getParameters().put('index','0');
        Test.setCurrentPage(pref);
        productSelectionController con = new productSelectionController();
        con.getMaterialTypeSelectList();
        con.getActivePricebookList();
        con.getMediahighLevelSelectList();
        con.getBusinessChannelList();
        con.matrlType = '';
        con.medHighLvl = '';
        con.prodBusinesschannel = '';
        con.renewalOpty =false;
        con.showWarning=false;
        con.boolChckPartlCncl1=false;
        con.AddProduct();
        //con.AddProduct();
        //con.AddProduct();
        con.delRow();
        productSelectionController.searchProdut('Unit Test Product','','','Custom Pricebook','USD','',false);
        //con.SaveClose();
        con.SaveAndValidate();
        con.deleteExistinglines();
        con.cancel();
        con.getReasonTypeList();
        con.objOpportunityLI = testLineItem1;
        con.cancelComments = 'test';
        con.partialOLICancel();
        Test.stopTest();
        
    }
    //added to increase code coverage:negative senario
    
    static testMethod void testControllerOpportunity_negative(){
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
        testcontact.LastName = 'testContact1';
        testcontact.FirstName = 'testContact1';
        testcontact.AccountId = testAcc.Id;
        testcontact.email = 'testfirst1.testlast@thomson.com';
        insert testcontact;
        
        opportunity testOpp2 = UnitTest.getOpportunityInstance(testAcc.Id);
        testOpp2.Renewal_Flag__c = false;
        testOpp2.Selling_Organization__c = 'FSCO';
        testOpp2.currencyIsoCode = 'USD';
        testOpp2.recordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('LATAM Renewal Opportunity').getRecordTypeId();
        insert testOpp2;
        
       
        
        Product2 testProd =UnitTest.getProductInstance();
        insert testProd;
        
        PricebookEntry testEntry = new PricebookEntry(CurrencyIsoCode='USD',isactive=true,Pricebook2id=Test.getStandardPricebookId(),Product2Id=testProd.id,unitprice=1,UseStandardPrice=false);
        insert testEntry;
        
        PricebookEntry testEntry1 = new PricebookEntry(CurrencyIsoCode='USD',isactive=true,Pricebook2id=customPB.Id,Product2Id=testProd.id,unitprice=1,UseStandardPrice=false);
        insert testEntry1;
        
        OpportunityLineItem testLineItem = new OpportunityLineItem(opportunityId=testOpp2.id,PricebookEntryId=testEntry1.id,unitprice=100,Quantity=1, Revenue_Type__c ='Renewal');
        //testLineItem.RenewalCheck__c = true;
        testLineItem.Activity_Type__c = 'Renewed';        
        insert testLineItem;
        
        OpportunityLineItem testLineItem1 = new OpportunityLineItem(opportunityId=testOpp2.id,PricebookEntryId=testEntry1.id,unitprice=90,Quantity=1, Revenue_Type__c ='Renewal');
        //testLineItem.RenewalCheck__c = true;
      //  testLineItem1.Activity_Type__c = 'Renewed';
        testLineItem1.Activity_Type__c = 'Cancelled';
        insert testLineItem1;
        
        OpportunityLineItem testLineItem2 = new OpportunityLineItem(opportunityId=testOpp2.id,PricebookEntryId=testEntry1.id,unitprice=170,Quantity=1, Revenue_Type__c ='Renewal');
        //testLineItem.RenewalCheck__c = true;
        testLineItem2.Activity_Type__c = 'Renewed';  
        testLineItem2.Cancel_Reason__c = 'Abandoned';
        insert testLineItem2;
        
        Quote testQuote = New Quote ();
        testQuote.OpportunityId = testOpp2.id;
        testQuote.Pricebook2Id = customPB.Id;
        testQuote.Name = 'Test Quote';
        testQuote.RecordTypeId = Schema.SObjectType.Quote.getRecordTypeInfosByName().get('LATAM Renewal Quote').getRecordTypeId();
        insert testQuote;
        
        QuoteLineItem testquoteLineItem = new QuoteLineItem() ;
        testquoteLineItem.QuoteId = testQuote.id;
        testquoteLineItem.PricebookEntryId = testentry1.Id;
        testquoteLineItem.Quantity = 1;
        testquotelineItem.UnitPrice = 200;
        insert testQuoteLineItem;
        
        productSelectionController.LATAMPRODUCT oLatamPro = new productSelectionController.LATAMPRODUCT(testLineItem,true);
        oLatamPro.productName = testLineItem.Product2.Name;
        oLatamPro.materialCode = testLineItem.product2.ProductCode;      
                
        list<productSelectionController.LATAMPRODUCT> latamProductList = new list<productSelectionController.LATAMPRODUCT>();
        latamProductList.add(oLatamPro);
        
        productSelectionController.LATAMPRODUCT oLatamPro1 = new productSelectionController.LATAMPRODUCT(testLineItem1,false);
        oLatamPro1.productName = testLineItem1.Product2.Name;
        oLatamPro1.materialCode = testLineItem1.product2.ProductCode;        
        latamProductList.add(oLatamPro1);        
        
        productSelectionController.LATAMPRODUCT oLatamPro2 = new productSelectionController.LATAMPRODUCT(testLineItem2,true);
        oLatamPro1.productName = testLineItem2.Product2.Name;
        oLatamPro1.materialCode = testLineItem2.product2.ProductCode;        
        latamProductList.add(oLatamPro2);  
        
        list<OpportunityLineItem> lstUnselectedOLI = new list<OpportunityLineItem>();
        lstUnselectedOLI.add(testLineItem);
        
        list<productSelectionController.LATAMPRODUCT> productListNotCancelledTest = new list<productSelectionController.LATAMPRODUCT>(); 
        productListNotCancelledTest.add(oLatamPro);       
        productListNotCancelledTest.add(oLatamPro1); 
        productListNotCancelledTest.add(oLatamPro2); 
              
        Test.startTest();
        PageReference pref=Page.ProductSelection;
        pref.getParameters().put('id',testOpp2.Id);
        pref.getParameters().put('index','0');
        Test.setCurrentPage(pref);
        productSelectionController con = new productSelectionController();
        con.redirectId = testOpp2.Id;
        con.getMaterialTypeSelectList();
        con.getActivePricebookList();
        con.getMediahighLevelSelectList();
        con.getBusinessChannelList();
        con.matrlType = '';
        con.medHighLvl = '';
        con.prodBusinesschannel = '';
        con.renewalOpty =false;
        con.showWarning=false;
        con.boolChckPartlCncl1=false;
        con.AddProduct();
        con.AddProduct();
        con.AddProduct();
        con.delRow();
        productSelectionController.searchProdut('Unit Test Product','','','Custom Pricebook','USD','',false);
        //con.SaveClose();
        con.SaveAndValidate();
        con.deleteExistinglines();
        con.cancel();
        con.getReasonTypeList();
        con.cancelComments = 'test';
        con.latamProductList  = latamProductList;
        con.productListNotCancelled  = productListNotCancelledTest;
        con.objOpportunityLI = testLineItem2;
        con.partialOLICancel();
        Test.stopTest();
        
    } 
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
        
        QuoteLineItem testquoteLineItem1 = new QuoteLineItem() ;
        testquoteLineItem1.QuoteId = testQuote.id;
        testquoteLineItem1.PricebookEntryId = testentry1.Id;
        testquoteLineItem1.Quantity = 1;
        testquotelineItem1.UnitPrice = 200;
        testquotelineItem1.Item_Activity_Type__c = 'Renewed';
        insert testQuoteLineItem1;
        ////////////////////////Added
        
        productSelectionController.LATAMPRODUCT oLatamPro = new productSelectionController.LATAMPRODUCT(testquoteLineItem,true);
        oLatamPro.productName = testLineItem.Product2.Name;
        oLatamPro.materialCode = testLineItem.product2.ProductCode;        
        list<productSelectionController.LATAMPRODUCT> latamProductListTest = new list<productSelectionController.LATAMPRODUCT>();
        latamProductListTest.add(oLatamPro);
        
        productSelectionController.LATAMPRODUCT oLatamPro1 = new productSelectionController.LATAMPRODUCT(testQuoteLineItem1,true);
        oLatamPro1.productName = testLineItem1.Product2.Name;
        oLatamPro1.materialCode = testLineItem1.product2.ProductCode;    
        
        latamProductListTest.add(oLatamPro1);        
        
        /////////////////////Added
        Test.startTest();
        PageReference pref=Page.ProductSelection;
        pref.getParameters().put('id',testQuote.Id);
        pref.getParameters().put('index','2');
        Test.setCurrentPage(pref);
        productSelectionController con = new productSelectionController();
        con.getActivePricebookList();
        con.AddProduct();
        con.AddProduct();
        con.AddProduct();
        con.AddProduct();
        con.delRow();
       // con.LoadData();
        productSelectionController.searchProdut('Unit Test Product','','','Custom Pricebook','USD','',false);
        con.SaveClose();
        con.SaveAndValidate();
        con.deleteExistinglines();
        con.cancel();
        //////////////Added
        con.partialQLICancel();      

        Test.stopTest();       
        
    } 
    static testMethod Void testControllerQuotepartialQLICancel(){
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
        
       /* Sales_Area_Product_Info__c salesAreaProductInfo = new Sales_Area_Product_Info__c();
        salesAreaProductInfo.Product__c = testEntry1.Product2Id;
        salesAreaProductInfo.D_Chain_Material_Status__c ='ZO';
        salesAreaProductInfo.Sales_Org__c = customPB.Sales_Org__c;
        salesAreaProductInfo.SAPExtId__c = 'test';
        insert salesAreaProductInfo;*/
        
        Opportunity testOpp1 = UnitTest.getOpportunityInstance(testAcc.Id);
        testOpp1.Renewal_Flag__c = true;
        testOpp1.Selling_Organization__c = 'LRA';
        testopp1.Sub_Category__c = 'Renewal';
        testOpp1.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('LATAM Renewal Opportunity').getRecordTypeId();
        insert testOpp1;
        
        OpportunityLineItem testLineItem = new OpportunityLineItem(opportunityId=testOpp1.id,PricebookEntryId=testEntry1.id,unitprice=100,Quantity=1, Revenue_Type__c ='Renewal',Activity_Type__c = 'Cancelled');
        testLineItem.Activity_Type__c = 'Cancelled';
        insert testLineItem;
        OpportunityLineItem testLineItem1 = new OpportunityLineItem(opportunityId=testOpp1.id,PricebookEntryId=testEntry1.id,unitprice=100,Quantity=1, Revenue_Type__c ='Incremental');
        testLineItem1.Activity_Type__c = 'Renewed';
        testLineItem1.Cancel_Reason__c = 'Abandoned';
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
        
        QuoteLineItem testquoteLineItem1 = new QuoteLineItem() ;
        testquoteLineItem1.QuoteId = testQuote.id;
        testquoteLineItem1.PricebookEntryId = testentry1.Id;
        testquoteLineItem1.Quantity = 1;
        testquotelineItem1.UnitPrice = 200;
        testquotelineItem1.Item_Activity_Type__c = 'Renewed';
        insert testQuoteLineItem1;
        
        QuoteLineItem testquoteLineItem2 = new QuoteLineItem() ;
        testquoteLineItem2.QuoteId = testQuote.id;
        testquoteLineItem2.PricebookEntryId = testentry1.Id;
        testquoteLineItem2.Quantity = 1;
        testquoteLineItem2.UnitPrice = 200;
        testquoteLineItem2.Item_Activity_Type__c = 'Renewed';
        insert testquoteLineItem2;
        
        QuoteLineItem testquoteLineItem3 = new QuoteLineItem() ;
        testquoteLineItem3.QuoteId = testQuote.id;
        testquoteLineItem3.PricebookEntryId = testentry1.Id;
        testquoteLineItem3.Quantity = 1;
        testquoteLineItem3.UnitPrice = 200;
        testquoteLineItem3.Item_Activity_Type__c = 'Renewed';
        insert testquoteLineItem3;
        
        ////////////////////////Added
        
        productSelectionController.LATAMPRODUCT oLatamPro = new productSelectionController.LATAMPRODUCT(testquoteLineItem,false);
        oLatamPro.productName = testLineItem.Product2.Name;
        oLatamPro.materialCode = testLineItem.product2.ProductCode;        
        list<productSelectionController.LATAMPRODUCT> latamProductListTest = new list<productSelectionController.LATAMPRODUCT>();
        latamProductListTest.add(oLatamPro);
        
        productSelectionController.LATAMPRODUCT oLatamPro1 = new productSelectionController.LATAMPRODUCT(testQuoteLineItem1,false);
        oLatamPro1.productName = testLineItem1.Product2.Name;
        oLatamPro1.materialCode = testLineItem1.product2.ProductCode;    
        
        latamProductListTest.add(oLatamPro1);        
        
        list<productSelectionController.LATAMPRODUCT> productListNotCancelledTest = new list<productSelectionController.LATAMPRODUCT>();
        
        productSelectionController.LATAMPRODUCT productNotCancelledTest1 = new productSelectionController.LATAMPRODUCT(testquoteLineItem2,true );
        productNotCancelledTest1.productName = testLineItem1.Product2.Name;
        productNotCancelledTest1.materialCode = testLineItem1.product2.ProductCode;     
        
        productSelectionController.LATAMPRODUCT productNotCancelledTest2 = new productSelectionController.LATAMPRODUCT(testQuoteLineItem1,true );
        productNotCancelledTest2.productName = testLineItem1.Product2.Name;
        productNotCancelledTest2.materialCode = testLineItem1.product2.ProductCode;

        productSelectionController.LATAMPRODUCT productNotCancelledTest3 = new productSelectionController.LATAMPRODUCT(testquoteLineItem3,false );
        productNotCancelledTest3.productName = testLineItem1.Product2.Name;
        productNotCancelledTest3.materialCode = testLineItem1.product2.ProductCode;
         
        productListNotCancelledTest.add(productNotCancelledTest1);       
        productListNotCancelledTest.add(productNotCancelledTest2);       
        productListNotCancelledTest.add(productNotCancelledTest3);       
        /////////////////////Added
        Test.startTest();
        PageReference pref=Page.ProductSelection;
        pref.getParameters().put('id',testQuote.Id);
        pref.getParameters().put('index','2');
        Test.setCurrentPage(pref);
        productSelectionController con = new productSelectionController();
        con.getActivePricebookList();
        con.AddProduct();
        con.AddProduct();
        con.AddProduct();
        con.AddProduct();
        con.delRow();
      
        productSelectionController.searchProdut('Unit Test Product','test','test','Custom Pricebook','USD','test',false);
        //////////////Added
        con.latamProductList  = latamProductListTest;
        con.productListNotCancelled  = productListNotCancelledTest;
        con.objOpportunityLI = testLineItem1;
        con.cancelComments = 'test';
        con.partialQLICancel();
        

        Test.stopTest();
        
        
    }
    static testMethod Void testControllerQuotepartialQLICancelSizeOne(){
        
        
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
        
        QuoteLineItem testquoteLineItem1 = new QuoteLineItem() ;
        testquoteLineItem1.QuoteId = testQuote.id;
        testquoteLineItem1.PricebookEntryId = testentry1.Id;
        testquoteLineItem1.Quantity = 1;
        testquotelineItem1.UnitPrice = 200;
        testquotelineItem1.Item_Activity_Type__c = 'Renewed';
        insert testQuoteLineItem1;
        
        ////////////////////////Added
        
        productSelectionController.LATAMPRODUCT oLatamPro = new productSelectionController.LATAMPRODUCT(testquoteLineItem,false);
        oLatamPro.productName = testLineItem.Product2.Name;
        oLatamPro.materialCode = testLineItem.product2.ProductCode;        
        list<productSelectionController.LATAMPRODUCT> latamProductListTest = new list<productSelectionController.LATAMPRODUCT>();
        latamProductListTest.add(oLatamPro);
        
        productSelectionController.LATAMPRODUCT oLatamPro1 = new productSelectionController.LATAMPRODUCT(testQuoteLineItem1,false);
        oLatamPro1.productName = testLineItem1.Product2.Name;
        oLatamPro1.materialCode = testLineItem1.product2.ProductCode;    
        
        latamProductListTest.add(oLatamPro1);        
        
        list<productSelectionController.LATAMPRODUCT> productListNotCancelledTest = new list<productSelectionController.LATAMPRODUCT>();
        
    
        
        productSelectionController.LATAMPRODUCT productNotCancelledTest2 = new productSelectionController.LATAMPRODUCT(testQuoteLineItem1,true );
        productNotCancelledTest2.productName = testLineItem1.Product2.Name;
        productNotCancelledTest2.materialCode = testLineItem1.product2.ProductCode;


         
             
        productListNotCancelledTest.add(productNotCancelledTest2);       
         
        /////////////////////Added
        Test.startTest();
        PageReference pref=Page.ProductSelection;
        pref.getParameters().put('id',testQuote.Id);
        pref.getParameters().put('index','2');
        Test.setCurrentPage(pref);
        productSelectionController con = new productSelectionController();
        con.getActivePricebookList();
        con.AddProduct();
        con.AddProduct();
        con.AddProduct();
        con.AddProduct();
        con.delRow();
      
        productSelectionController.searchProdut('Unit Test Product','','','Custom Pricebook','USD','',false);
        //////////////Added
        con.latamProductList  = latamProductListTest;
        con.productListNotCancelled  = productListNotCancelledTest;
        con.objOpportunityLI = testLineItem1;
        con.cancelComments = '';
        con.partialQLICancel();
        

        Test.stopTest();
        
        
    }
  static testMethod Void testControllerQuotepartialQLICancelNotequalsSize(){
        
        
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
        testLineItem1.Activity_Type__c = 'Renewed';
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
        
        QuoteLineItem testquoteLineItem1 = new QuoteLineItem() ;
        testquoteLineItem1.QuoteId = testQuote.id;
        testquoteLineItem1.PricebookEntryId = testentry1.Id;
        testquoteLineItem1.Quantity = 1;
        testquotelineItem1.UnitPrice = 200;
        testquotelineItem1.Item_Activity_Type__c = 'Renewed';
        insert testQuoteLineItem1;
        
        QuoteLineItem testquoteLineItem2 = new QuoteLineItem() ;
        testquoteLineItem2.QuoteId = testQuote.id;
        testquoteLineItem2.PricebookEntryId = testentry1.Id;
        testquoteLineItem2.Quantity = 1;
        testquoteLineItem2.UnitPrice = 200;
        testquoteLineItem2.Item_Activity_Type__c = 'Renewed';
        insert testquoteLineItem2;
        
        QuoteLineItem testquoteLineItem3 = new QuoteLineItem() ;
        testquoteLineItem3.QuoteId = testQuote.id;
        testquoteLineItem3.PricebookEntryId = testentry1.Id;
        testquoteLineItem3.Quantity = 1;
        testquoteLineItem3.UnitPrice = 200;
        testquoteLineItem3.Item_Activity_Type__c = 'Renewed';
        insert testquoteLineItem3;
        
        ////////////////////////Added
        
        productSelectionController.LATAMPRODUCT oLatamPro = new productSelectionController.LATAMPRODUCT(testquoteLineItem,false);
        oLatamPro.productName = testLineItem.Product2.Name;
        oLatamPro.materialCode = testLineItem.product2.ProductCode;        
        list<productSelectionController.LATAMPRODUCT> latamProductListTest = new list<productSelectionController.LATAMPRODUCT>();
        latamProductListTest.add(oLatamPro);
        
        productSelectionController.LATAMPRODUCT oLatamPro1 = new productSelectionController.LATAMPRODUCT(testQuoteLineItem1,false);
        oLatamPro1.productName = testLineItem1.Product2.Name;
        oLatamPro1.materialCode = testLineItem1.product2.ProductCode;    
        
        latamProductListTest.add(oLatamPro1);  
        
        productSelectionController.LATAMPRODUCT oLatamPro2 = new productSelectionController.LATAMPRODUCT(testQuoteLineItem1,true);
        oLatamPro2.productName = testLineItem1.Product2.Name;
        oLatamPro2.materialCode = testLineItem1.product2.ProductCode;    
        
        latamProductListTest.add(oLatamPro2);
        
        list<productSelectionController.LATAMPRODUCT> productListNotCancelledTest = new list<productSelectionController.LATAMPRODUCT>();
        
        productSelectionController.LATAMPRODUCT productNotCancelledTest1 = new productSelectionController.LATAMPRODUCT(testquoteLineItem2,true );
        productNotCancelledTest1.productName = testLineItem1.Product2.Name;
        productNotCancelledTest1.materialCode = testLineItem1.product2.ProductCode;     
        
        productSelectionController.LATAMPRODUCT productNotCancelledTest2 = new productSelectionController.LATAMPRODUCT(testQuoteLineItem1,true );
        productNotCancelledTest2.productName = testLineItem1.Product2.Name;
        productNotCancelledTest2.materialCode = testLineItem1.product2.ProductCode;

        productSelectionController.LATAMPRODUCT productNotCancelledTest3 = new productSelectionController.LATAMPRODUCT(testquoteLineItem3,true );
        productNotCancelledTest3.productName = testLineItem1.Product2.Name;
        productNotCancelledTest3.materialCode = testLineItem1.product2.ProductCode;
         
        productListNotCancelledTest.add(productNotCancelledTest1);       
        productListNotCancelledTest.add(productNotCancelledTest2);       
        productListNotCancelledTest.add(productNotCancelledTest3);       
        
        System.debug('$$$$latamProductListTest'+latamProductListTest);
        /////////////////////Added
        Test.startTest();
        PageReference pref=Page.ProductSelection;
        pref.getParameters().put('id',testQuote.Id);
        pref.getParameters().put('index','2');
        Test.setCurrentPage(pref);
        productSelectionController con = new productSelectionController();
        con.getActivePricebookList();
        con.AddProduct();
        con.AddProduct();
        con.AddProduct();
        con.AddProduct();
        con.delRow();
      
        productSelectionController.searchProdut('Unit Test Product','','','Custom Pricebook','USD','',false);
        //////////////Added
        con.latamProductList  = latamProductListTest;
        con.productListNotCancelled  = productListNotCancelledTest;
        con.partialQLICancel();
        Test.stopTest();
    }
    static testMethod void testControllerQuotepartialOLICancel(){
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
        testcontact.LastName = 'testContact1';
        testcontact.FirstName = 'testContact1';
        testcontact.AccountId = testAcc.Id;
        testcontact.email = 'testfirst1.testlast@thomson.com';
        insert testcontact;
        
        opportunity testOpp2 = UnitTest.getOpportunityInstance(testAcc.Id);
        testOpp2.Renewal_Flag__c = false;
        testOpp2.Selling_Organization__c = 'FSCO';
        testOpp2.currencyIsoCode = 'USD';
        testOpp2.recordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('LATAM Renewal Opportunity').getRecordTypeId();
        insert testOpp2;
        
       
        
        Product2 testProd =UnitTest.getProductInstance();
        insert testProd;
        
        PricebookEntry testEntry = new PricebookEntry(CurrencyIsoCode='USD',isactive=true,Pricebook2id=Test.getStandardPricebookId(),Product2Id=testProd.id,unitprice=1,UseStandardPrice=false);
        insert testEntry;
        
        PricebookEntry testEntry1 = new PricebookEntry(CurrencyIsoCode='USD',isactive=true,Pricebook2id=customPB.Id,Product2Id=testProd.id,unitprice=1,UseStandardPrice=false);
        insert testEntry1;
        
        OpportunityLineItem testLineItem = new OpportunityLineItem(opportunityId=testOpp2.id,PricebookEntryId=testEntry1.id,unitprice=100,Quantity=1, Revenue_Type__c ='Renewal');
        //testLineItem.RenewalCheck__c = true;
        testLineItem.Activity_Type__c = 'Renewed';        
        insert testLineItem;
        
        OpportunityLineItem testLineItem1 = new OpportunityLineItem(opportunityId=testOpp2.id,PricebookEntryId=testEntry1.id,unitprice=90,Quantity=1, Revenue_Type__c ='Renewal');
        //testLineItem.RenewalCheck__c = true;
      //  testLineItem1.Activity_Type__c = 'Renewed';
        testLineItem1.Activity_Type__c = 'Cancelled';
        insert testLineItem1;
        
        OpportunityLineItem testLineItem2 = new OpportunityLineItem(opportunityId=testOpp2.id,PricebookEntryId=testEntry1.id,unitprice=170,Quantity=1, Revenue_Type__c ='Renewal');
        //testLineItem.RenewalCheck__c = true;
        testLineItem2.Activity_Type__c = 'Renewed';  
        testLineItem2.Cancel_Reason__c = 'Abandoned';
        insert testLineItem2;
        
        Quote testQuote = New Quote ();
        testQuote.OpportunityId = testOpp2.id;
        testQuote.Pricebook2Id = customPB.Id;
        testQuote.Name = 'Test Quote';
        testQuote.RecordTypeId = Schema.SObjectType.Quote.getRecordTypeInfosByName().get('LATAM Renewal Quote').getRecordTypeId();
        insert testQuote;
        
        QuoteLineItem testquoteLineItem = new QuoteLineItem() ;
        testquoteLineItem.QuoteId = testQuote.id;
        testquoteLineItem.PricebookEntryId = testentry1.Id;
        testquoteLineItem.Quantity = 1;
        testquotelineItem.UnitPrice = 200;
        insert testQuoteLineItem;
        
        productSelectionController.LATAMPRODUCT oLatamPro = new productSelectionController.LATAMPRODUCT(testLineItem,true);
        oLatamPro.productName = testLineItem.Product2.Name;
        oLatamPro.materialCode = testLineItem.product2.ProductCode;      
                
        list<productSelectionController.LATAMPRODUCT> latamProductList = new list<productSelectionController.LATAMPRODUCT>();
        latamProductList.add(oLatamPro);
        
        productSelectionController.LATAMPRODUCT oLatamPro1 = new productSelectionController.LATAMPRODUCT(testLineItem1,false);
        oLatamPro1.productName = testLineItem1.Product2.Name;
        oLatamPro1.materialCode = testLineItem1.product2.ProductCode;        
        latamProductList.add(oLatamPro1);        
        
        productSelectionController.LATAMPRODUCT oLatamPro2 = new productSelectionController.LATAMPRODUCT(testLineItem2,true);
        oLatamPro1.productName = testLineItem2.Product2.Name;
        oLatamPro1.materialCode = testLineItem2.product2.ProductCode;        
        latamProductList.add(oLatamPro2);  
        
        list<OpportunityLineItem> lstUnselectedOLI = new list<OpportunityLineItem>();
        lstUnselectedOLI.add(testLineItem);
        
        list<productSelectionController.LATAMPRODUCT> productListNotCancelledTest = new list<productSelectionController.LATAMPRODUCT>(); 
        productListNotCancelledTest.add(oLatamPro);       
        productListNotCancelledTest.add(oLatamPro1); 
        productListNotCancelledTest.add(oLatamPro2); 
              
        Test.startTest();
        PageReference pref=Page.ProductSelection;
        pref.getParameters().put('id',testOpp2.Id);
        pref.getParameters().put('index','0');
        Test.setCurrentPage(pref);
        productSelectionController con = new productSelectionController();
        con.redirectId = testOpp2.Id;
        con.getMaterialTypeSelectList();
        con.getActivePricebookList();
        con.getMediahighLevelSelectList();
        con.getBusinessChannelList();
        con.matrlType = '';
        con.medHighLvl = '';
        con.prodBusinesschannel = '';
        con.renewalOpty =false;
        con.showWarning=false;
        con.boolChckPartlCncl1=false;
        con.AddProduct();
        con.AddProduct();
        con.AddProduct();
        con.delRow();
        productSelectionController.searchProdut('Unit Test Product','','','Custom Pricebook','USD','',false);
        //con.SaveClose();
        con.SaveAndValidate();
        con.deleteExistinglines();
        con.cancel();
        con.getReasonTypeList();
        con.cancelComments = '';
        con.latamProductList  = latamProductList;
        con.productListNotCancelled  = productListNotCancelledTest;
        con.objOpportunityLI = testLineItem2;
        con.partialOLICancel();
        Test.stopTest();
        
    }
}