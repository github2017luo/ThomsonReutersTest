@isTest
private with sharing class APTS_CORP_Validation_CallbackHelperTest {
    //private static final string USL_RECORDTPYE='USL_Source_Systems';
    @isTest static void testMethodCORP(){
        Apttus_Config2__PriceList__c priceList = APTS_TestDataFactory.createPriceList('Thomson Reuters Master - US Legal');
        insert priceList;
        
        Schema.DescribeFieldResult fieldResultMarket = Apttus_Config2__ProductConfiguration__c.APTS_AccountMirror_Picklist__c.getDescribe();
        String valueMarket = fieldResultMarket.getPicklistValues().get(0).getValue();
        
        List<KeyValueListStore__c> keyValueList=new List<KeyValueListStore__c>();
        KeyValueListStore__c keyvaluestore=new  KeyValueListStore__c();
        keyvaluestore.Name='ANZUsersProfileId';
        keyvaluestore.TextValue__c=System.Label.APTS_OC_Test_Id;
        keyValueList.add(keyvaluestore);
        KeyValueListStore__c keyval = new KeyValueListStore__c();
        keyval.Name='ReasonWithCompetitor';
        keyval.TextValue__c='Price';
        keyValueList.add(keyval);
        insert keyValueList;
        
        insertStaticValues();
        WebServiceSettings__c oWebServiceSettings = new WebServiceSettings__c();
        oWebServiceSettings.Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable'; 
        oWebServiceSettings.Name = 'PaymentCreditIncrease'; 
        oWebServiceSettings.Timeout__c = 120; 
        oWebServiceSettings.Endpoint__c = 'https://dev.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease'; 
        oWebServiceSettings.Active__c = true;
        insert oWebServiceSettings;               
        
        List<RecordtypeIds__c> recordlist=new List<RecordtypeIds__c>();
        RecordtypeIds__c recordtype=new RecordtypeIds__c();
        recordtype.Name='Pre-Pipeline Opportunities';
        recordtype.recTypeId__c=System.Label.APTS_OC_Test_Id;
        recordlist.add(recordtype);
        
        RecordtypeIds__c recordtype1=new RecordtypeIds__c();
        recordtype1.Name='Pipeline Opportunities';
        recordtype1.recTypeId__c=System.Label.APTS_OC_Test_Id;
        recordlist.add(recordtype1);
        insert recordlist;
        
        Profile profileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        
        User CorpUser=new User(username='testuser23corp@acme.com',
                               lastname='testuser',
                               Alias='testuser',
                               Email='testuser@tcs.com',
                               Sub_Bu__c='US',
                               TimeZoneSidKey = 'GMT',
                               ProfileId = profileId.id,
                               LanguageLocaleKey = 'en_US',
                               EmailEncodingKey = 'UTF-8',
                               LocaleSidKey = 'en_US',
                               Segment__c = 'Corporate',
                               Default_Catalog__c ='');
        insert CorpUser;
        
        Account a = APTS_TestDataFactory.createAccount('Test Account');
        a.FrozenMarketSegment__c = valueMarket;
        insert a;
        
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();
        Source_System_Detail__c accountSSD=APTS_TestDataFactory.createSourceSystem(a);
        accountSSD.RecordtypeId=ssdRecorType;
        accountSSD.Name='ABC';
        accountSSD.Source_System_Name__c='ABC';
        accountSSD.Account_Name__c=a.ID;
        accountSSD.LCRM_Frozen_Market_Segment__c = valueMarket;
        accountSSD.Account_Inactive__c=false;
        accountSSD.LCRM_Sales_Org__c='TA78';
        insert accountSSD;
        
        Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        Opportunity oppty=APTS_TestDataFactory.createOpportunity('abc',a.id,'Needs Analysis',Date.Today());
        oppty.RecordtypeId=opptyRecorType;
        oppty.Source_System_Detail__c=accountSSD.id;
        oppty.Account=a;
        insert oppty;
        
        /*Apttus_Proposal__Proposal__c proposal = APTS_TestDataFactory.createProposal(oppty.id, accountSSD.Id);
        proposal.APTS_Proposal_Business_Unit__c = 'Corp OneOTC US';    
        System.runAs(CorpUser) {
            insert proposal;
        } */   
        Id devRecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Proposal').getRecordTypeId();
        Apttus_Proposal__Proposal__c proposal = new Apttus_Proposal__Proposal__c(
            RecordTypeId=devRecordTypeId, 
            Apttus_Proposal__Proposal_Name__c='testproposal',
            Apttus_Proposal__Account__c = a.id, 
            Apttus_Proposal__Opportunity__c=oppty.id, 
            Apttus_Proposal__Approval_Stage__c='Draft', 
            Apttus_Proposal__Proposal_Category__c='Quote', 
            Apttus_Proposal__ReadyToGenerate__c = true, 
            Apttus_Proposal__ReadyToPresent__c= true, 
            Apttus_QPConfig__PriceListId__c=priceList.id,
            APTS_SSD_Sold_To__c = accountSSD.Id,
            APTS_Proposal_Business_Unit__c = 'Corp OneOTC US'            
        );
        insert proposal;

        Apttus_Config2__ProductConfiguration__c prodConfig = APTS_TestDataFactory.createProductConfiguration(proposal.Id);
        insert prodConfig;
        ID cartID = prodConfig.Id;
        
        List<Product2> productsList=new List<Product2>();
        Product2 prodObj = new Product2();
        prodObj.Name = 'Network Services 1.0';
        prodObj.APTS_Media_Lower_Level_Code__c = '2Q';
        prodObj.APTS_Availability_Date__c= Date.newInstance(2018, 1, 1);   
        prodObj.APTS_FL_Renewal_Only_Clone__c = 'Yes';  
        prodObj.APTS_Price_Call__c=true;        
        productsList.add(prodObj);  
        Product2 prodObj1 = new Product2();
        prodObj1.Name = 'Network Services 1.0';
        prodObj1.APTS_Media_Lower_Level_Code__c = '2Q';
        prodObj1.APTS_Availability_Date__c= Date.newInstance(2018, 1, 1);   
        prodObj1.APTS_FL_Renewal_Only_Clone__c = 'Yes';  
        prodObj1.APTS_Price_Call__c=true;
        productsList.add(prodObj1);
        insert productsList;
        
        Apttus_Config2__PriceListItem__c pliSO = new Apttus_Config2__PriceListItem__c();
        pliSO.Apttus_Config2__Active__c = true;
        pliSO.Apttus_Config2__PriceListId__c = priceList.Id;
        pliSO.APTS_Max_Fill_Up_Price__c = 5;
        insert pliSO;
        
        
        List<Apttus_Config2__LineItem__c> lineItemList=new List<Apttus_Config2__LineItem__c>();
        Apttus_Config2__LineItem__c linObj = new Apttus_Config2__LineItem__c(
            Apttus_Config2__Quantity__c=7,
            Apttus_Config2__ProductId__c=prodObj.id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Product/Service',
            Apttus_Config2__LineNumber__c = 1, 
            Apttus_Config2__ItemSequence__c = 1,
            Apttus_Config2__NetPrice__c=10.0,
            Apttus_Config2__BasePrice__c=null,
            Apttus_Config2__BaseExtendedPrice__c = 10.0,
            Apttus_Config2__AdjustedPrice__c = 10.0,
            Apttus_Config2__OptionPrice__c = 5.0,
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',
            Apttus_Config2__ChargeType__c = 'Subscription Fee',          
            Apttus_Config2__LineStatus__c = 'Cancelled',   
            Apttus_Config2__PriceListItemId__c = pliSO.id); 
        
        Apttus_Config2__LineItem__c linObj1 = new Apttus_Config2__LineItem__c(
            Apttus_Config2__Quantity__c=7,
            Apttus_Config2__ProductId__c=prodObj1.id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Product/Service',
            Apttus_Config2__LineNumber__c = 1, 
            Apttus_Config2__ItemSequence__c = 1,
            Apttus_Config2__NetPrice__c=10.0,
            Apttus_Config2__BasePrice__c=null,
            Apttus_Config2__BaseExtendedPrice__c = 10.0,
            Apttus_Config2__AdjustedPrice__c = 10.0,
            Apttus_Config2__OptionPrice__c = 5.0,
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',
            Apttus_Config2__ChargeType__c = 'Subscription Fee',          
            Apttus_Config2__LineStatus__c = 'Cancelled',   
            Apttus_Config2__PriceListItemId__c = pliSO.id); 
        
        lineItemList.add(linObj);
        lineItemList.add(linObj1);
        insert lineItemList;
        
        APTS_ConfigBundlePageSettings__c bundlePageSettings = new APTS_ConfigBundlePageSettings__c();
        bundlePageSettings.Name = 'Bundle Page Properties';
        bundlePageSettings.Banded_Products_MLL__c = '2Q,49,72,BA,J9,L2,LB,M4,P7,Q3,WA,LB,PX';
        insert bundlePageSettings;
        
        List<Apttus_Config2__LineItem__c> lineItemsList = [SELECT Id, Name, Apttus_Config2__ProductId__c, Apttus_Config2__ProductId__r.APTS_FL_Renewal_Only_Clone__c,
                                                           APTS_Proposal_Group__c,APTS_Renewal_Type__c,APTS_Proposal_Business_Unit__c,
                                                           Apttus_Config2__LineType__c, Apttus_Config2__LineStatus__c, APTS_Contract_Term__c,APTS_Contract_Term_Number__c
                                                           FROM Apttus_Config2__LineItem__c 
                                                           WHERE Id = :linObj.Id];      
        
        System.debug('APTS_Proposal_Group__c'+lineItemsList.get(0).APTS_Proposal_Group__c);                             
        System.debug('RK --> Proposal BU '+lineItemsList.get(0).APTS_Proposal_Business_Unit__c);                           
        Test.startTest();
        Apttus_Config2.CallbackTester.testValidationCallback
            ( cartID
             , lineItemsList
             , null
             , new APTS_Validation_Callback ());   
        Test.stopTest();                                              
    }
    
    @isTest static void testMethodCORP_Evergreen(){
        Apttus_Config2__PriceList__c priceList = APTS_TestDataFactory.createPriceList('Thomson Reuters Master - US Legal');
        insert priceList;
        
        List<KeyValueListStore__c> keyValueList=new List<KeyValueListStore__c>();
        KeyValueListStore__c keyvaluestore=new  KeyValueListStore__c();
        keyvaluestore.Name='ANZUsersProfileId';
        keyvaluestore.TextValue__c=System.Label.APTS_OC_Test_Id;
        keyValueList.add(keyvaluestore);
        KeyValueListStore__c keyval = new KeyValueListStore__c();
        keyval.Name='ReasonWithCompetitor';
        keyval.TextValue__c='Price';
        keyValueList.add(keyval);
        insert keyValueList;
        
        Schema.DescribeFieldResult fieldResultMarket = Apttus_Config2__ProductConfiguration__c.APTS_AccountMirror_Picklist__c.getDescribe();
        String valueMarket = fieldResultMarket.getPicklistValues().get(0).getValue();
        
        insertStaticValues();
        WebServiceSettings__c oWebServiceSettings = new WebServiceSettings__c();
        oWebServiceSettings.Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable'; 
        oWebServiceSettings.Name = 'PaymentCreditIncrease'; 
        oWebServiceSettings.Timeout__c = 120; 
        oWebServiceSettings.Endpoint__c = 'https://dev.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease'; 
        oWebServiceSettings.Active__c = true;
        insert oWebServiceSettings;
        
        
        
        List<RecordtypeIds__c> recordlist=new List<RecordtypeIds__c>();
        RecordtypeIds__c recordtype=new RecordtypeIds__c();
        recordtype.Name='Pre-Pipeline Opportunities';
        recordtype.recTypeId__c=System.Label.APTS_OC_Test_Id;
        recordlist.add(recordtype);
        
        RecordtypeIds__c recordtype1=new RecordtypeIds__c();
        recordtype1.Name='Pipeline Opportunities';
        recordtype1.recTypeId__c=System.Label.APTS_OC_Test_Id;
        recordlist.add(recordtype1);
        insert recordlist;
        
        Profile profileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        
        User CorpUser=new User(username='testuser23corp1@acme.com',
                               lastname='testuser',
                               Alias='testuser',
                               Email='testuser@tcs.com',
                               Sub_Bu__c='US',
                               Segment__c ='Corporate',
                               TimeZoneSidKey = 'GMT',
                               ProfileId = profileId.id,
                               LanguageLocaleKey = 'en_US',
                               EmailEncodingKey = 'UTF-8',
                               LocaleSidKey = 'en_US',
                               Default_Catalog__c ='USL');
        insert CorpUser;
        
        Account a = APTS_TestDataFactory.createAccount('Test Account');
        a.FrozenMarketSegment__c = valueMarket;
        insert a;
        
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();
        Source_System_Detail__c accountSSD=APTS_TestDataFactory.createSourceSystem(a);
        accountSSD.RecordtypeId=ssdRecorType;
        accountSSD.Name='ABC';
        accountSSD.Source_System_Name__c='ABC';
        accountSSD.Account_Name__c=a.ID;
        accountSSD.LCRM_Frozen_Market_Segment__c = valueMarket;
        accountSSD.Account_Inactive__c=false;
        accountSSD.LCRM_Sales_Org__c='TA78';
        insert accountSSD;
        
        Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        Opportunity oppty=APTS_TestDataFactory.createOpportunity('abc',a.id,'Needs Analysis',Date.Today());
        oppty.RecordtypeId=opptyRecorType;
        oppty.Source_System_Detail__c=accountSSD.id;
        oppty.Account=a;
        insert oppty;
        
        /*Apttus_Proposal__Proposal__c proposal = APTS_TestDataFactory.createProposal(oppty.id, accountSSD.Id);
        proposal.APTS_Proposal_Business_Unit__c = 'Corp OneOTC US';    
        System.runAs(CorpUser) {
            insert proposal;
        }  */  
        Id devRecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Proposal').getRecordTypeId();
        Apttus_Proposal__Proposal__c proposal = new Apttus_Proposal__Proposal__c(
            RecordTypeId=devRecordTypeId, 
            Apttus_Proposal__Proposal_Name__c='testproposal',
            Apttus_Proposal__Account__c = a.id, 
            Apttus_Proposal__Opportunity__c=oppty.id, 
            Apttus_Proposal__Approval_Stage__c='Draft', 
            Apttus_Proposal__Proposal_Category__c='Quote', 
            Apttus_Proposal__ReadyToGenerate__c = true, 
            Apttus_Proposal__ReadyToPresent__c= true, 
            Apttus_QPConfig__PriceListId__c=priceList.id,
            APTS_SSD_Sold_To__c = accountSSD.Id,
            APTS_Proposal_Business_Unit__c = 'Corp OneOTC US'            
        );
        insert proposal;
        
        Apttus_Config2__ProductConfiguration__c prodConfig = APTS_TestDataFactory.createProductConfiguration(proposal.Id);
        insert prodConfig;
        ID cartID = prodConfig.Id;
        
        Product2 prodObj = new Product2();
        prodObj.Name = 'Network Services 1.0';
        prodObj.APTS_Media_Lower_Level_Code__c = '2Q';
        prodObj.APTS_Availability_Date__c= Date.newInstance(2018, 1, 1);   
        prodObj.APTS_FL_Renewal_Only_Clone__c = 'No'; 
        insert prodObj; 
        
        Apttus_Config2__PriceListItem__c pliSO = new Apttus_Config2__PriceListItem__c();
        pliSO.Apttus_Config2__Active__c = true;
        pliSO.Apttus_Config2__PriceListId__c = priceList.Id;
        pliSO.APTS_Max_Fill_Up_Price__c = 5;
        insert pliSO;
        
        Apttus_Config2__LineItem__c linObj = new Apttus_Config2__LineItem__c(
            Apttus_Config2__Quantity__c=7,
            Apttus_Config2__ProductId__c=prodObj.id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Product/Service',
            Apttus_Config2__LineNumber__c = 1, 
            Apttus_Config2__ItemSequence__c = 1,
            Apttus_Config2__NetPrice__c=10.0,
            Apttus_Config2__BasePrice__c=10.0,
            Apttus_Config2__BaseExtendedPrice__c = 10.0,
            Apttus_Config2__AdjustedPrice__c = 10.0,
            Apttus_Config2__OptionPrice__c = 5.0,
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='4 Years',
            Apttus_Config2__ChargeType__c = 'Subscription Fee',          
            Apttus_Config2__LineStatus__c = 'Cancelled',   
            APTS_Renewal_Type__c = 'Evergreen',
            Apttus_Config2__PriceListItemId__c = pliSO.id); 
        
        insert linObj;
        
        APTS_ConfigBundlePageSettings__c bundlePageSettings = new APTS_ConfigBundlePageSettings__c();
        bundlePageSettings.Name = 'Bundle Page Properties';
        bundlePageSettings.Banded_Products_MLL__c = '2Q,49,72,BA,J9,L2,LB,M4,P7,Q3,WA,LB,PX';
        insert bundlePageSettings;
        
        List<Apttus_Config2__LineItem__c> lineItemsList = [SELECT Id, Name, Apttus_Config2__ProductId__c, Apttus_Config2__ProductId__r.APTS_FL_Renewal_Only_Clone__c,
                                                           APTS_Proposal_Group__c,APTS_Renewal_Type__c,APTS_Proposal_Business_Unit__c,
                                                           Apttus_Config2__LineType__c, Apttus_Config2__LineStatus__c, APTS_Contract_Term__c,APTS_Contract_Term_Number__c
                                                           FROM Apttus_Config2__LineItem__c 
                                                           WHERE Id = :linObj.Id];      
        
        System.debug('APTS_Proposal_Group__c'+lineItemsList.get(0).APTS_Proposal_Group__c);  
        System.debug('RK --> 2 Proposal BU '+lineItemsList.get(0).APTS_Proposal_Business_Unit__c);                           
        
        Test.startTest();
        Apttus_Config2.CallbackTester.testValidationCallback
            ( cartID
             , lineItemsList
             , null
             , new APTS_Validation_Callback ());   
        Test.stopTest();                                              
    }
    @isTest static void testMethodMultiTieredPricing3(){
        Apttus_Config2__PriceList__c priceList = APTS_TestDataFactory.createPriceList('Thomson Reuters Master - US Legal');
        insert priceList;
        
        List<KeyValueListStore__c> keyValueList=new List<KeyValueListStore__c>();
        KeyValueListStore__c keyvaluestore=new  KeyValueListStore__c();
        keyvaluestore.Name='ANZUsersProfileId';
        keyvaluestore.TextValue__c=System.Label.APTS_OC_Test_Id;
        keyValueList.add(keyvaluestore);
        KeyValueListStore__c keyval = new KeyValueListStore__c();
        keyval.Name='ReasonWithCompetitor';
        keyval.TextValue__c='Price';
        keyValueList.add(keyval);
        insert keyValueList;
        
        Schema.DescribeFieldResult fieldResultMarket = Apttus_Config2__ProductConfiguration__c.APTS_AccountMirror_Picklist__c.getDescribe();
        String valueMarket = fieldResultMarket.getPicklistValues().get(0).getValue();
        
        insertStaticValues();
        WebServiceSettings__c oWebServiceSettings = new WebServiceSettings__c();
        oWebServiceSettings.Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable'; 
        oWebServiceSettings.Name = 'PaymentCreditIncrease'; 
        oWebServiceSettings.Timeout__c = 120; 
        oWebServiceSettings.Endpoint__c = 'https://dev.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease'; 
        oWebServiceSettings.Active__c = true;
        insert oWebServiceSettings;
        
        
        
        
        List<RecordtypeIds__c> recordlist=new List<RecordtypeIds__c>();
        RecordtypeIds__c recordtype=new RecordtypeIds__c();
        recordtype.Name='Pre-Pipeline Opportunities';
        recordtype.recTypeId__c=System.Label.APTS_OC_Test_Id;
        recordlist.add(recordtype);
        
        RecordtypeIds__c recordtype1=new RecordtypeIds__c();
        recordtype1.Name='Pipeline Opportunities';
        recordtype1.recTypeId__c=System.Label.APTS_OC_Test_Id;
        recordlist.add(recordtype1);
        insert recordlist;
        
        Profile profileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        
        User CorpUser=new User(username='testuser23corp44@acme.com',
                               lastname='testuser',
                               Alias='testuser',
                               Email='testuser@tcs.com',
                               Sub_Bu__c='US',
                               TimeZoneSidKey = 'GMT',
                               ProfileId = profileId.id,
                               LanguageLocaleKey = 'en_US',
                               EmailEncodingKey = 'UTF-8',
                               LocaleSidKey = 'en_US',
                               Default_Catalog__c ='USL');
        insert CorpUser;
        
        Account a = APTS_TestDataFactory.createAccount('Test Account');
        a.FrozenMarketSegment__c = valueMarket;
        insert a;
        
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();
        Source_System_Detail__c accountSSD=APTS_TestDataFactory.createSourceSystem(a);
        accountSSD.RecordtypeId=ssdRecorType;
        accountSSD.Name='ABC';
        accountSSD.Source_System_Name__c='ABC';
        accountSSD.Account_Name__c=a.ID;
        accountSSD.LCRM_Frozen_Market_Segment__c = valueMarket;
        accountSSD.Account_Inactive__c=false;
        accountSSD.LCRM_Sales_Org__c='TA78';
        insert accountSSD;
        
        Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        Opportunity oppty=APTS_TestDataFactory.createOpportunity('abc',a.id,'Needs Analysis',Date.Today());
        oppty.RecordtypeId=opptyRecorType;
        oppty.Source_System_Detail__c=accountSSD.id;
        oppty.Account=a;
        insert oppty;
        
        Apttus_Proposal__Proposal__c proposal = APTS_TestDataFactory.createProposal(oppty.id, accountSSD.Id);
        proposal.APTS_Proposal_Business_Unit__c = 'Corp OneOTC US';    
        System.runAs(CorpUser) {
            insert proposal;
        }    
        
        Apttus_Config2__ProductConfiguration__c prodConfig = APTS_TestDataFactory.createProductConfiguration(proposal.Id);
        insert prodConfig;
        ID cartID = prodConfig.Id;
        
        List<Product2> productsList=new List<Product2>();
        Product2 prodObj = new Product2();
        prodObj.Name = 'Network Services 1.0';
        prodObj.APTS_Media_Lower_Level_Code__c = '2Q';
        prodObj.APTS_Availability_Date__c= Date.newInstance(2018, 1, 1);   
        productsList.add(prodObj);  
        Product2 prodObj1 = new Product2();
        prodObj1.Name = 'Network Services 2.0';
        prodObj1.APTS_Media_Lower_Level_Code__c = '2Q';
        prodObj1.APTS_Availability_Date__c= Date.newInstance(2018, 1, 1);   
        productsList.add(prodObj1);
        insert productsList;
        
        Apttus_Config2__PriceListItem__c pliSO = new Apttus_Config2__PriceListItem__c();
        pliSO.Apttus_Config2__Active__c = true;
        pliSO.Apttus_Config2__PriceListId__c = priceList.Id;
        pliSO.APTS_Max_Fill_Up_Price__c = 5;
        insert pliSO;
        
        List<Apttus_Config2__LineItem__c> lineItemList=new List<Apttus_Config2__LineItem__c>();
        Apttus_Config2__LineItem__c linObj = new Apttus_Config2__LineItem__c(
            Apttus_Config2__Quantity__c=7,
            Apttus_Config2__ProductId__c=prodObj.id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Product/Service',
            Apttus_Config2__LineNumber__c = 1, 
            Apttus_Config2__ItemSequence__c = 1,
            Apttus_Config2__NetPrice__c=10.0,
            Apttus_Config2__BasePrice__c=10.0,
            Apttus_Config2__BaseExtendedPrice__c = 10.0,
            Apttus_Config2__AdjustedPrice__c = 10.0,
            Apttus_Config2__OptionPrice__c = 5.0,
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',
            APTS_Yr_2_Amount__c=15.0,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',          
            Apttus_Config2__LineStatus__c = 'New',   
            Apttus_Config2__PriceListItemId__c = pliSO.id);  
        
        lineItemList.add(linObj);   
        insert lineItemList; 
                                    
        
        Test.startTest();
        Apttus_Config2.CallbackTester.testValidationCallback
            ( cartID
             , lineItemList
             , null
             , new APTS_Validation_Callback ());   
        Test.stopTest();                                              
    }
    @isTest static void testMethodMultiTieredPricing4(){
        Apttus_Config2__PriceList__c priceList = APTS_TestDataFactory.createPriceList('Thomson Reuters Master - US Legal');
        insert priceList;
        
        List<KeyValueListStore__c> keyValueList=new List<KeyValueListStore__c>();
        KeyValueListStore__c keyvaluestore=new  KeyValueListStore__c();
        keyvaluestore.Name='ANZUsersProfileId';
        keyvaluestore.TextValue__c=System.Label.APTS_OC_Test_Id;
        keyValueList.add(keyvaluestore);
        KeyValueListStore__c keyval = new KeyValueListStore__c();
        keyval.Name='ReasonWithCompetitor';
        keyval.TextValue__c='Price';
        keyValueList.add(keyval);
        insert keyValueList;
        
        Schema.DescribeFieldResult fieldResultMarket = Apttus_Config2__ProductConfiguration__c.APTS_AccountMirror_Picklist__c.getDescribe();
        String valueMarket = fieldResultMarket.getPicklistValues().get(0).getValue();
        
        insertStaticValues();
        WebServiceSettings__c oWebServiceSettings = new WebServiceSettings__c();
        oWebServiceSettings.Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable'; 
        oWebServiceSettings.Name = 'PaymentCreditIncrease'; 
        oWebServiceSettings.Timeout__c = 120; 
        oWebServiceSettings.Endpoint__c = 'https://dev.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease'; 
        oWebServiceSettings.Active__c = true;
        insert oWebServiceSettings;
        
        
        List<RecordtypeIds__c> recordlist=new List<RecordtypeIds__c>();
        RecordtypeIds__c recordtype=new RecordtypeIds__c();
        recordtype.Name='Pre-Pipeline Opportunities';
        recordtype.recTypeId__c=System.Label.APTS_OC_Test_Id;
        recordlist.add(recordtype);
        
        RecordtypeIds__c recordtype1=new RecordtypeIds__c();
        recordtype1.Name='Pipeline Opportunities';
        recordtype1.recTypeId__c=System.Label.APTS_OC_Test_Id;
        recordlist.add(recordtype1);
        insert recordlist;
        
        Profile profileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        
        User CorpUser=new User(username='testuser23corp123@acme.com',
                               lastname='testuser',
                               Alias='testuser',
                               Email='testuser@tcs.com',
                               Sub_Bu__c='US',
                               TimeZoneSidKey = 'GMT',
                               ProfileId = profileId.id,
                               LanguageLocaleKey = 'en_US',
                               EmailEncodingKey = 'UTF-8',
                               LocaleSidKey = 'en_US',
                               Default_Catalog__c ='USL');
        insert CorpUser;
        
        Account a = APTS_TestDataFactory.createAccount('Test Account');
        a.FrozenMarketSegment__c = valueMarket;
        insert a;
        
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();
        Source_System_Detail__c accountSSD=APTS_TestDataFactory.createSourceSystem(a);
        accountSSD.RecordtypeId=ssdRecorType;
        accountSSD.Name='ABC';
        accountSSD.Source_System_Name__c='ABC';
        accountSSD.Account_Name__c=a.ID;
        accountSSD.LCRM_Frozen_Market_Segment__c = valueMarket;
        accountSSD.Account_Inactive__c=false;
        accountSSD.LCRM_Sales_Org__c='WEST';
        insert accountSSD;
        
        Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        Opportunity oppty=APTS_TestDataFactory.createOpportunity('abc',a.id,'Needs Analysis',Date.Today());
        oppty.RecordtypeId=opptyRecorType;
        oppty.Source_System_Detail__c=accountSSD.id;
        oppty.Account=a;
        insert oppty;
        
        Apttus_Proposal__Proposal__c proposal = APTS_TestDataFactory.createProposal(oppty.id, accountSSD.Id);
        proposal.APTS_Proposal_Business_Unit__c = 'Corp OneOTC US';    
        System.runAs(CorpUser) {
            insert proposal;
        }    
        
        Apttus_Config2__ProductConfiguration__c prodConfig = APTS_TestDataFactory.createProductConfiguration(proposal.Id);
        insert prodConfig;
        ID cartID = prodConfig.Id;
        
        List<Product2> productsList=new List<Product2>();
        Product2 prodObj = new Product2();
        prodObj.Name = 'Network Services 1.0';
        prodObj.APTS_Media_Lower_Level_Code__c = '2Q';
        prodObj.APTS_Availability_Date__c= Date.newInstance(2018, 1, 1);   
        productsList.add(prodObj);  
        Product2 prodObj1 = new Product2();
        prodObj1.Name = 'Network Services 2.0';
        prodObj1.APTS_Media_Lower_Level_Code__c = '2Q';
        prodObj1.APTS_Availability_Date__c= Date.newInstance(2018, 1, 1);   
        productsList.add(prodObj1);
        insert productsList;
        
        Apttus_Config2__PriceListItem__c pliSO = new Apttus_Config2__PriceListItem__c();
        pliSO.Apttus_Config2__Active__c = true;
        pliSO.Apttus_Config2__PriceListId__c = priceList.Id;
        pliSO.APTS_Max_Fill_Up_Price__c = 5;
        insert pliSO;
        
        List<Apttus_Config2__LineItem__c> lineItemList=new List<Apttus_Config2__LineItem__c>();        
        Apttus_Config2__LineItem__c linObj1 = new Apttus_Config2__LineItem__c(
            Apttus_Config2__Quantity__c=7,
            Apttus_Config2__ProductId__c=prodObj1.id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Product/Service',
            Apttus_Config2__LineNumber__c = 1, 
            Apttus_Config2__ItemSequence__c = 1,
            Apttus_Config2__NetPrice__c=10.0,
            Apttus_Config2__BasePrice__c=10.0,
            APTS_Yr_2_Amount__c=15.0,
            Apttus_Config2__BaseExtendedPrice__c = 10.0,
            Apttus_Config2__AdjustedPrice__c = 10.0,
            Apttus_Config2__OptionPrice__c = 5.0,
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='4 Years',
            Apttus_Config2__ChargeType__c = 'Subscription Fee',          
            Apttus_Config2__LineStatus__c = 'New',   
            Apttus_Config2__PriceListItemId__c = pliSO.id); 
        
        lineItemList.add(linObj1);
        insert lineItemList;
        
        Test.startTest();
        Apttus_Config2.CallbackTester.testValidationCallback
            ( cartID
             , lineItemList
             , null
             , new APTS_Validation_Callback ());   
        Test.stopTest();                                              
    }
    @isTest static void testMethodMultiTieredPricing5(){
        Apttus_Config2__PriceList__c priceList = APTS_TestDataFactory.createPriceList('Thomson Reuters Master - US Legal');
        insert priceList;
        
        List<KeyValueListStore__c> keyValueList=new List<KeyValueListStore__c>();
        KeyValueListStore__c keyvaluestore=new  KeyValueListStore__c();
        keyvaluestore.Name='ANZUsersProfileId';
        keyvaluestore.TextValue__c=System.Label.APTS_OC_Test_Id;
        keyValueList.add(keyvaluestore);
        KeyValueListStore__c keyval = new KeyValueListStore__c();
        keyval.Name='ReasonWithCompetitor';
        keyval.TextValue__c='Price';
        keyValueList.add(keyval);
        insert keyValueList;
        
        Schema.DescribeFieldResult fieldResultMarket = Apttus_Config2__ProductConfiguration__c.APTS_AccountMirror_Picklist__c.getDescribe();
        String valueMarket = fieldResultMarket.getPicklistValues().get(0).getValue();
        
        insertStaticValues();
        WebServiceSettings__c oWebServiceSettings = new WebServiceSettings__c();
        oWebServiceSettings.Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable'; 
        oWebServiceSettings.Name = 'PaymentCreditIncrease'; 
        oWebServiceSettings.Timeout__c = 120; 
        oWebServiceSettings.Endpoint__c = 'https://dev.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease'; 
        oWebServiceSettings.Active__c = true;
        insert oWebServiceSettings;
        
        
        List<RecordtypeIds__c> recordlist=new List<RecordtypeIds__c>();
        RecordtypeIds__c recordtype=new RecordtypeIds__c();
        recordtype.Name='Pre-Pipeline Opportunities';
        recordtype.recTypeId__c=System.Label.APTS_OC_Test_Id;
        recordlist.add(recordtype);
        
        RecordtypeIds__c recordtype1=new RecordtypeIds__c();
        recordtype1.Name='Pipeline Opportunities';
        recordtype1.recTypeId__c=System.Label.APTS_OC_Test_Id;
        recordlist.add(recordtype1);
        insert recordlist;
        
        Profile profileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        
        User CorpUser=new User(username='testuser23corp83@acme.com',
                               lastname='testuser',
                               Alias='testuser',
                               Email='testuser@tcs.com',
                               Sub_Bu__c='US',
                               TimeZoneSidKey = 'GMT',
                               ProfileId = profileId.id,
                               LanguageLocaleKey = 'en_US',
                               EmailEncodingKey = 'UTF-8',
                               LocaleSidKey = 'en_US',
                               Default_Catalog__c ='USL');
        insert CorpUser;
        
        Account a = APTS_TestDataFactory.createAccount('Test Account');
        a.FrozenMarketSegment__c = valueMarket;
        insert a;
        
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();
        Source_System_Detail__c accountSSD=APTS_TestDataFactory.createSourceSystem(a);
        accountSSD.RecordtypeId=ssdRecorType;
        accountSSD.Name='ABC';
        accountSSD.Source_System_Name__c='ABC';
        accountSSD.Account_Name__c=a.ID;
        accountSSD.LCRM_Frozen_Market_Segment__c = valueMarket;
        accountSSD.Account_Inactive__c=false;
        accountSSD.LCRM_Sales_Org__c='TA78';
        insert accountSSD;
        
        Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        Opportunity oppty=APTS_TestDataFactory.createOpportunity('abc',a.id,'Needs Analysis',Date.Today());
        oppty.RecordtypeId=opptyRecorType;
        oppty.Source_System_Detail__c=accountSSD.id;
        oppty.Account=a;
        insert oppty;
        
        Apttus_Proposal__Proposal__c proposal = APTS_TestDataFactory.createProposal(oppty.id, accountSSD.Id);
        proposal.APTS_Proposal_Business_Unit__c = 'Corp OneOTC US';    
        System.runAs(CorpUser) {
            insert proposal;
        }    
        
        Apttus_Config2__ProductConfiguration__c prodConfig = APTS_TestDataFactory.createProductConfiguration(proposal.Id);
        insert prodConfig;
        ID cartID = prodConfig.Id;
        
        List<Product2> productsList=new List<Product2>();
        Product2 prodObj = new Product2();
        prodObj.Name = 'Network Services 1.0';
        prodObj.APTS_Media_Lower_Level_Code__c = '2Q';
        prodObj.APTS_Availability_Date__c= Date.newInstance(2018, 1, 1);   
        productsList.add(prodObj);  
        Product2 prodObj1 = new Product2();
        prodObj1.Name = 'Network Services 2.0';
        prodObj1.APTS_Media_Lower_Level_Code__c = '2Q';
        prodObj1.APTS_Availability_Date__c= Date.newInstance(2018, 1, 1);   
        productsList.add(prodObj1);
        insert productsList;
        
        Apttus_Config2__PriceListItem__c pliSO = new Apttus_Config2__PriceListItem__c();
        pliSO.Apttus_Config2__Active__c = true;
        pliSO.Apttus_Config2__PriceListId__c = priceList.Id;
        pliSO.APTS_Max_Fill_Up_Price__c = 5;
        insert pliSO;
        
        List<Apttus_Config2__LineItem__c> lineItemList=new List<Apttus_Config2__LineItem__c>();     
        Apttus_Config2__LineItem__c linObj2 = new Apttus_Config2__LineItem__c(
            Apttus_Config2__Quantity__c=7,
            Apttus_Config2__ProductId__c=prodObj1.id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Product/Service',
            Apttus_Config2__LineNumber__c = 1, 
            Apttus_Config2__ItemSequence__c = 1,
            Apttus_Config2__NetPrice__c=10.0,
            Apttus_Config2__BasePrice__c=10.0,
            APTS_Yr_2_Amount__c=15.0,
            Apttus_Config2__BaseExtendedPrice__c = 10.0,
            Apttus_Config2__AdjustedPrice__c = 10.0,
            Apttus_Config2__OptionPrice__c = 5.0,
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='4 Years',
            Apttus_Config2__ChargeType__c = 'Subscription Fee',          
            Apttus_Config2__LineStatus__c = 'New',   
            Apttus_Config2__PriceListItemId__c = pliSO.id); 
        lineItemList.add(linObj2);
        
        Apttus_Config2__LineItem__c linObj3 = new Apttus_Config2__LineItem__c(
            Apttus_Config2__Quantity__c=7,
            Apttus_Config2__ProductId__c=prodObj1.id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Product/Service',
            Apttus_Config2__LineNumber__c = 1, 
            Apttus_Config2__ItemSequence__c = 1,
            Apttus_Config2__NetPrice__c=10.0,
            Apttus_Config2__BasePrice__c=10.0,
            APTS_Yr_3_Amount__c=15.0,
            Apttus_Config2__BaseExtendedPrice__c = 10.0,
            Apttus_Config2__AdjustedPrice__c = 10.0,
            Apttus_Config2__OptionPrice__c = 5.0,
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='5 Years',
            Apttus_Config2__ChargeType__c = 'Subscription Fee',          
            Apttus_Config2__LineStatus__c = 'New',   
            Apttus_Config2__PriceListItemId__c = pliSO.id); 
        lineItemList.add(linObj3);
        
        Apttus_Config2__LineItem__c linObj4 = new Apttus_Config2__LineItem__c(
            Apttus_Config2__Quantity__c=7,
            Apttus_Config2__ProductId__c=prodObj1.id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Product/Service',
            Apttus_Config2__LineNumber__c = 1, 
            Apttus_Config2__ItemSequence__c = 1,
            Apttus_Config2__NetPrice__c=10.0,
            Apttus_Config2__BasePrice__c=10.0,
            APTS_Yr_4_Amount__c=15.0,
            Apttus_Config2__BaseExtendedPrice__c = 10.0,
            Apttus_Config2__AdjustedPrice__c = 10.0,
            Apttus_Config2__OptionPrice__c = 5.0,
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='5 Years',
            Apttus_Config2__ChargeType__c = 'Subscription Fee',          
            Apttus_Config2__LineStatus__c = 'New',   
            Apttus_Config2__PriceListItemId__c = pliSO.id); 
        lineItemList.add(linObj4);
        
        Apttus_Config2__LineItem__c linObj5 = new Apttus_Config2__LineItem__c(
            Apttus_Config2__Quantity__c=7,
            Apttus_Config2__ProductId__c=prodObj1.id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Product/Service',
            Apttus_Config2__LineNumber__c = 1, 
            Apttus_Config2__ItemSequence__c = 1,
            Apttus_Config2__NetPrice__c=10.0,
            Apttus_Config2__BasePrice__c=10.0,
            APTS_Yr_5_Amount__c=15.0,
            Apttus_Config2__BaseExtendedPrice__c = 10.0,
            Apttus_Config2__AdjustedPrice__c = 10.0,
            Apttus_Config2__OptionPrice__c = 5.0,
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='5 Years',
            Apttus_Config2__ChargeType__c = 'Subscription Fee',          
            Apttus_Config2__LineStatus__c = 'New',   
            Apttus_Config2__PriceListItemId__c = pliSO.id); 
        lineItemList.add(linObj5);
        
        Apttus_Config2__LineItem__c linObj6 = new Apttus_Config2__LineItem__c(
            Apttus_Config2__Quantity__c=7,
            Apttus_Config2__ProductId__c=prodObj1.id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Product/Service',
            Apttus_Config2__LineNumber__c = 1, 
            Apttus_Config2__ItemSequence__c = 1,
            Apttus_Config2__NetPrice__c=10.0,
            Apttus_Config2__BasePrice__c=10.0,
            APTS_Yr_2_Amount__c=15.0,
            APTS_Yr_3_Amount__c=15.0,
            Apttus_Config2__BaseExtendedPrice__c = 10.0,
            Apttus_Config2__AdjustedPrice__c = 10.0,
            Apttus_Config2__OptionPrice__c = 5.0,
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='5 Years',
            Apttus_Config2__ChargeType__c = 'Subscription Fee',          
            Apttus_Config2__LineStatus__c = 'New',   
            Apttus_Config2__PriceListItemId__c = pliSO.id); 
        lineItemList.add(linObj6);
        
        Apttus_Config2__LineItem__c linObj7 = new Apttus_Config2__LineItem__c(
            Apttus_Config2__Quantity__c=7,
            Apttus_Config2__ProductId__c=prodObj1.id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Product/Service',
            Apttus_Config2__LineNumber__c = 1, 
            Apttus_Config2__ItemSequence__c = 1,
            Apttus_Config2__NetPrice__c=10.0,
            Apttus_Config2__BasePrice__c=10.0,
            APTS_Yr_3_Amount__c=15.0,
            APTS_Yr_4_Amount__c=15.0,
            Apttus_Config2__BaseExtendedPrice__c = 10.0,
            Apttus_Config2__AdjustedPrice__c = 10.0,
            Apttus_Config2__OptionPrice__c = 5.0,
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='5 Years',
            Apttus_Config2__ChargeType__c = 'Subscription Fee',          
            Apttus_Config2__LineStatus__c = 'New',   
            Apttus_Config2__PriceListItemId__c = pliSO.id); 
        lineItemList.add(linObj7);
        
        Apttus_Config2__LineItem__c linObj8 = new Apttus_Config2__LineItem__c(
            Apttus_Config2__Quantity__c=7,
            Apttus_Config2__ProductId__c=prodObj1.id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Product/Service',
            Apttus_Config2__LineNumber__c = 1, 
            Apttus_Config2__ItemSequence__c = 1,
            Apttus_Config2__NetPrice__c=10.0,
            Apttus_Config2__BasePrice__c=10.0,
            APTS_Yr_4_Amount__c=15.0,
            APTS_Yr_5_Amount__c=15.0,
            Apttus_Config2__BaseExtendedPrice__c = 10.0,
            Apttus_Config2__AdjustedPrice__c = 10.0,
            Apttus_Config2__OptionPrice__c = 5.0,
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='5 Years',
            Apttus_Config2__ChargeType__c = 'Subscription Fee',          
            Apttus_Config2__LineStatus__c = 'New',   
            Apttus_Config2__PriceListItemId__c = pliSO.id); 
        lineItemList.add(linObj8);
        
        Apttus_Config2__LineItem__c linObj9 = new Apttus_Config2__LineItem__c(
            Apttus_Config2__Quantity__c=7,
            Apttus_Config2__ProductId__c=prodObj1.id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Product/Service',
            Apttus_Config2__LineNumber__c = 1, 
            Apttus_Config2__ItemSequence__c = 1,
            Apttus_Config2__NetPrice__c=10.0,
            Apttus_Config2__BasePrice__c=10.0,
            APTS_Yr_2_Amount__c=15.0,
            APTS_Yr_5_Amount__c=15.0,
            Apttus_Config2__BaseExtendedPrice__c = 10.0,
            Apttus_Config2__AdjustedPrice__c = 10.0,
            Apttus_Config2__OptionPrice__c = 5.0,
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='5 Years',
            Apttus_Config2__ChargeType__c = 'Subscription Fee',          
            Apttus_Config2__LineStatus__c = 'New',   
            Apttus_Config2__PriceListItemId__c = pliSO.id); 
        lineItemList.add(linObj9);
        
        Apttus_Config2__LineItem__c linObj10 = new Apttus_Config2__LineItem__c(
            Apttus_Config2__Quantity__c=7,
            Apttus_Config2__ProductId__c=prodObj1.id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Product/Service',
            Apttus_Config2__LineNumber__c = 1, 
            Apttus_Config2__ItemSequence__c = 1,
            Apttus_Config2__NetPrice__c=10.0,
            Apttus_Config2__BasePrice__c=10.0,
            APTS_Yr_3_Amount__c=15.0,
            APTS_Yr_5_Amount__c=15.0,
            Apttus_Config2__BaseExtendedPrice__c = 10.0,
            Apttus_Config2__AdjustedPrice__c = 10.0,
            Apttus_Config2__OptionPrice__c = 5.0,
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='5 Years',
            Apttus_Config2__ChargeType__c = 'Subscription Fee',          
            Apttus_Config2__LineStatus__c = 'New',   
            Apttus_Config2__PriceListItemId__c = pliSO.id); 
        lineItemList.add(linObj10);
        
        Apttus_Config2__LineItem__c linObj11 = new Apttus_Config2__LineItem__c(
            Apttus_Config2__Quantity__c=7,
            Apttus_Config2__ProductId__c=prodObj1.id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Product/Service',
            Apttus_Config2__LineNumber__c = 1, 
            Apttus_Config2__ItemSequence__c = 1,
            Apttus_Config2__NetPrice__c=10.0,
            Apttus_Config2__BasePrice__c=10.0,
            APTS_Yr_2_Amount__c=15.0,
            APTS_Yr_3_Amount__c=15.0,
            APTS_Yr_4_Amount__c=15.0,
            Apttus_Config2__BaseExtendedPrice__c = 10.0,
            Apttus_Config2__AdjustedPrice__c = 10.0,
            Apttus_Config2__OptionPrice__c = 5.0,
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='5 Years',
            Apttus_Config2__ChargeType__c = 'Subscription Fee',          
            Apttus_Config2__LineStatus__c = 'New',   
            Apttus_Config2__PriceListItemId__c = pliSO.id); 
        lineItemList.add(linObj11);
        
        Apttus_Config2__LineItem__c linObj12 = new Apttus_Config2__LineItem__c(
            Apttus_Config2__Quantity__c=7,
            Apttus_Config2__ProductId__c=prodObj1.id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Product/Service',
            Apttus_Config2__LineNumber__c = 1, 
            Apttus_Config2__ItemSequence__c = 1,
            Apttus_Config2__NetPrice__c=10.0,
            Apttus_Config2__BasePrice__c=10.0,
            APTS_Yr_3_Amount__c=15.0,
            APTS_Yr_4_Amount__c=15.0,
            APTS_Yr_5_Amount__c=15.0,
            Apttus_Config2__BaseExtendedPrice__c = 10.0,
            Apttus_Config2__AdjustedPrice__c = 10.0,
            Apttus_Config2__OptionPrice__c = 5.0,
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='5 Years',
            Apttus_Config2__ChargeType__c = 'Subscription Fee',          
            Apttus_Config2__LineStatus__c = 'New',   
            Apttus_Config2__PriceListItemId__c = pliSO.id); 
        lineItemList.add(linObj12);
        
        Apttus_Config2__LineItem__c linObj13 = new Apttus_Config2__LineItem__c(
            Apttus_Config2__Quantity__c=7,
            Apttus_Config2__ProductId__c=prodObj1.id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Product/Service',
            Apttus_Config2__LineNumber__c = 1, 
            Apttus_Config2__ItemSequence__c = 1,
            Apttus_Config2__NetPrice__c=10.0,
            Apttus_Config2__BasePrice__c=10.0,
            APTS_Yr_2_Amount__c=15.0,
            APTS_Yr_3_Amount__c=15.0,
            APTS_Yr_5_Amount__c=15.0,
            Apttus_Config2__BaseExtendedPrice__c = 10.0,
            Apttus_Config2__AdjustedPrice__c = 10.0,
            Apttus_Config2__OptionPrice__c = 5.0,
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='5 Years',
            Apttus_Config2__ChargeType__c = 'Subscription Fee',          
            Apttus_Config2__LineStatus__c = 'New',   
            Apttus_Config2__PriceListItemId__c = pliSO.id); 
        lineItemList.add(linObj13);
        insert lineItemList;
        
        Test.startTest();
        Apttus_Config2.CallbackTester.testValidationCallback
            ( cartID
             , lineItemList
             , null
             , new APTS_Validation_Callback ());   
        Test.stopTest();                                              
    }
    
    /*
@isTest static void testMethodMultiTieredPricing6(){
Apttus_Config2__PriceList__c priceList = APTS_TestDataFactory.createPriceList('Thomson Reuters Master - US Legal');
insert priceList;

LTS_Disable_Application_Automation__c ltstemp = new LTS_Disable_Application_Automation__c();
ltstemp.LTS_Disable_Process_Builders__c = true;
ltstemp.LTS_Disable_Triggers__c = true;
ltstemp.LTS_Disable_Validation_Rules__c = true;
ltstemp.LTS_Disable_Workflow_Rules__c = true;
ltstemp.Name = 'temp';
ltstemp.SetupOwnerId = userinfo.getuserid();
insert ltstemp;

List<KeyValueListStore__c> keyValueList=new List<KeyValueListStore__c>();
KeyValueListStore__c keyval = new KeyValueListStore__c();
keyval.Name='ReasonWithCompetitor';
keyval.TextValue__c='Price';
keyValueList.add(keyval);

Schema.DescribeFieldResult fieldResultMarket = Apttus_Config2__ProductConfiguration__c.APTS_AccountMirror_Picklist__c.getDescribe();
String valueMarket = fieldResultMarket.getPicklistValues().get(0).getValue();

insertStaticValues();
WebServiceSettings__c oWebServiceSettings = new WebServiceSettings__c();
oWebServiceSettings.Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable'; 
oWebServiceSettings.Name = 'PaymentCreditIncrease'; 
oWebServiceSettings.Timeout__c = 120; 
oWebServiceSettings.Endpoint__c = 'https://dev.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease'; 
oWebServiceSettings.Active__c = true;
insert oWebServiceSettings;


KeyValueListStore__c keyvaluestore=new  KeyValueListStore__c();
keyvaluestore.Name='ANZUsersProfileId';
keyvaluestore.TextValue__c=System.Label.APTS_OC_Test_Id;
insert keyvaluestore;

List<RecordtypeIds__c> recordlist=new List<RecordtypeIds__c>();
RecordtypeIds__c recordtype=new RecordtypeIds__c();
recordtype.Name='Pre-Pipeline Opportunities';
recordtype.recTypeId__c=System.Label.APTS_OC_Test_Id;
recordlist.add(recordtype);

RecordtypeIds__c recordtype1=new RecordtypeIds__c();
recordtype1.Name='Pipeline Opportunities';
recordtype1.recTypeId__c=System.Label.APTS_OC_Test_Id;
recordlist.add(recordtype1);
insert recordlist;

Profile profileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];

User CorpUser=new User(username='testuser23@acme.com',
lastname='testuser',
Alias='testuser',
Email='testuser@tcs.com',
Sub_Bu__c='US',
TimeZoneSidKey = 'GMT',
ProfileId = profileId.id,
LanguageLocaleKey = 'en_US',
EmailEncodingKey = 'UTF-8',
LocaleSidKey = 'en_US',
Default_Catalog__c ='USL');
insert CorpUser;

Account a = APTS_TestDataFactory.createAccount('Test Account');
a.FrozenMarketSegment__c = valueMarket;
insert a;

Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();
Source_System_Detail__c accountSSD=APTS_TestDataFactory.createSourceSystem(a);
accountSSD.RecordtypeId=ssdRecorType;
accountSSD.Name='ABC';
accountSSD.Source_System_Name__c='ABC';
accountSSD.Account_Name__c=a.ID;
accountSSD.LCRM_Frozen_Market_Segment__c = valueMarket;
accountSSD.Account_Inactive__c=false;
accountSSD.LCRM_Sales_Org__c='WEST';
insert accountSSD;

Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
Opportunity oppty=APTS_TestDataFactory.createOpportunity('abc',a.id,'Needs Analysis',Date.Today());
oppty.RecordtypeId=opptyRecorType;
oppty.Source_System_Detail__c=accountSSD.id;
oppty.Account=a;
insert oppty;

Apttus_Proposal__Proposal__c proposal = APTS_TestDataFactory.createProposal(oppty.id, accountSSD.Id);
proposal.APTS_Proposal_Business_Unit__c = 'Tax Professional';    
System.runAs(CorpUser) {
insert proposal;
}    

Apttus_Config2__ProductConfiguration__c prodConfig = APTS_TestDataFactory.createProductConfiguration(proposal.Id);
insert prodConfig;
ID cartID = prodConfig.Id;

List<Product2> productsList=new List<Product2>();
Product2 prodObj = new Product2();
prodObj.Name = 'Network Services 1.0';
prodObj.APTS_Media_Lower_Level_Code__c = '2Q';
prodObj.APTS_Availability_Date__c= Date.newInstance(2018, 1, 1);   
productsList.add(prodObj);  
Product2 prodObj1 = new Product2();
prodObj1.Name = 'Network Services 2.0';
prodObj1.APTS_Media_Lower_Level_Code__c = '2Q';
prodObj1.APTS_Availability_Date__c= Date.newInstance(2018, 1, 1);   
productsList.add(prodObj1);
insert productsList;

Apttus_Config2__PriceListItem__c pliSO = new Apttus_Config2__PriceListItem__c();
pliSO.Apttus_Config2__Active__c = true;
pliSO.Apttus_Config2__PriceListId__c = priceList.Id;
pliSO.APTS_Max_Fill_Up_Price__c = 5;
insert pliSO;

List<Apttus_Config2__LineItem__c> lineItemList=new List<Apttus_Config2__LineItem__c>();     
Apttus_Config2__LineItem__c linObj2 = new Apttus_Config2__LineItem__c(

Apttus_Config2__Quantity__c=7,
Apttus_Config2__ProductId__c=prodObj1.id,
Apttus_Config2__ConfigurationId__c = prodConfig.id, 
Apttus_Config2__LineType__c = 'Product/Service',
Apttus_Config2__LineNumber__c = 1, 
Apttus_Config2__ItemSequence__c = 1,
Apttus_Config2__NetPrice__c=10.0,
Apttus_Config2__BasePrice__c=10.0,
APTS_Yr_2_Amount__c=15.0,
Apttus_Config2__BaseExtendedPrice__c = 10.0,
Apttus_Config2__AdjustedPrice__c = 10.0,
Apttus_Config2__OptionPrice__c = 5.0,
Apttus_Config2__Frequency__c = 'Monthly',
Apttus_Config2__PriceType__c = 'Recurring', 
Apttus_Config2__PriceAdjustment__c=0,
APTS_Contract_Term__c ='5 Years',
Apttus_Config2__ChargeType__c = 'Subscription Fee',          
Apttus_Config2__LineStatus__c = 'New',   
Apttus_Config2__PriceListItemId__c = pliSO.id); 
lineItemList.add(linObj2);

Apttus_Config2__LineItem__c linObj3 = new Apttus_Config2__LineItem__c(
Apttus_Config2__Quantity__c=7,
Apttus_Config2__ProductId__c=prodObj1.id,
Apttus_Config2__ConfigurationId__c = prodConfig.id, 
Apttus_Config2__LineType__c = 'Product/Service',
Apttus_Config2__LineNumber__c = 1, 
Apttus_Config2__ItemSequence__c = 1,
Apttus_Config2__NetPrice__c=10.0,
Apttus_Config2__BasePrice__c=10.0,
APTS_Yr_3_Amount__c=15.0,
Apttus_Config2__BaseExtendedPrice__c = 10.0,
Apttus_Config2__AdjustedPrice__c = 10.0,
Apttus_Config2__OptionPrice__c = 5.0,
Apttus_Config2__Frequency__c = 'Monthly',
Apttus_Config2__PriceType__c = 'Recurring', 
Apttus_Config2__PriceAdjustment__c=0,
APTS_Contract_Term__c ='5 Years',
Apttus_Config2__ChargeType__c = 'Subscription Fee',          
Apttus_Config2__LineStatus__c = 'New',   
Apttus_Config2__PriceListItemId__c = pliSO.id); 
lineItemList.add(linObj3);

Apttus_Config2__LineItem__c linObj4 = new Apttus_Config2__LineItem__c(
Apttus_Config2__Quantity__c=7,
Apttus_Config2__ProductId__c=prodObj1.id,
Apttus_Config2__ConfigurationId__c = prodConfig.id, 
Apttus_Config2__LineType__c = 'Product/Service',
Apttus_Config2__LineNumber__c = 1, 
Apttus_Config2__ItemSequence__c = 1,
Apttus_Config2__NetPrice__c=10.0,
Apttus_Config2__BasePrice__c=10.0,
APTS_Yr_4_Amount__c=15.0,
Apttus_Config2__BaseExtendedPrice__c = 10.0,
Apttus_Config2__AdjustedPrice__c = 10.0,
Apttus_Config2__OptionPrice__c = 5.0,
Apttus_Config2__Frequency__c = 'Monthly',
Apttus_Config2__PriceType__c = 'Recurring', 
Apttus_Config2__PriceAdjustment__c=0,
APTS_Contract_Term__c ='5 Years',
Apttus_Config2__ChargeType__c = 'Subscription Fee',          
Apttus_Config2__LineStatus__c = 'New',   
Apttus_Config2__PriceListItemId__c = pliSO.id); 
lineItemList.add(linObj4);

Apttus_Config2__LineItem__c linObj5 = new Apttus_Config2__LineItem__c(
Apttus_Config2__Quantity__c=7,
Apttus_Config2__ProductId__c=prodObj1.id,
Apttus_Config2__ConfigurationId__c = prodConfig.id, 
Apttus_Config2__LineType__c = 'Product/Service',
Apttus_Config2__LineNumber__c = 1, 
Apttus_Config2__ItemSequence__c = 1,
Apttus_Config2__NetPrice__c=10.0,
Apttus_Config2__BasePrice__c=10.0,
APTS_Yr_5_Amount__c=15.0,
Apttus_Config2__BaseExtendedPrice__c = 10.0,
Apttus_Config2__AdjustedPrice__c = 10.0,
Apttus_Config2__OptionPrice__c = 5.0,
Apttus_Config2__Frequency__c = 'Monthly',
Apttus_Config2__PriceType__c = 'Recurring', 
Apttus_Config2__PriceAdjustment__c=0,
APTS_Contract_Term__c ='5 Years',
Apttus_Config2__ChargeType__c = 'Subscription Fee',          
Apttus_Config2__LineStatus__c = 'New',   
Apttus_Config2__PriceListItemId__c = pliSO.id); 
lineItemList.add(linObj5);

Apttus_Config2__LineItem__c linObj6 = new Apttus_Config2__LineItem__c(
Apttus_Config2__Quantity__c=7,
Apttus_Config2__ProductId__c=prodObj1.id,
Apttus_Config2__ConfigurationId__c = prodConfig.id, 
Apttus_Config2__LineType__c = 'Product/Service',
Apttus_Config2__LineNumber__c = 1, 
Apttus_Config2__ItemSequence__c = 1,
Apttus_Config2__NetPrice__c=10.0,
Apttus_Config2__BasePrice__c=10.0,
APTS_Yr_2_Amount__c=15.0,
APTS_Yr_3_Amount__c=15.0,
Apttus_Config2__BaseExtendedPrice__c = 10.0,
Apttus_Config2__AdjustedPrice__c = 10.0,
Apttus_Config2__OptionPrice__c = 5.0,
Apttus_Config2__Frequency__c = 'Monthly',
Apttus_Config2__PriceType__c = 'Recurring', 
Apttus_Config2__PriceAdjustment__c=0,
APTS_Contract_Term__c ='5 Years',
Apttus_Config2__ChargeType__c = 'Subscription Fee',          
Apttus_Config2__LineStatus__c = 'New',   
Apttus_Config2__PriceListItemId__c = pliSO.id); 
lineItemList.add(linObj6);

Apttus_Config2__LineItem__c linObj7 = new Apttus_Config2__LineItem__c(
Apttus_Config2__Quantity__c=7,
Apttus_Config2__ProductId__c=prodObj1.id,
Apttus_Config2__ConfigurationId__c = prodConfig.id, 
Apttus_Config2__LineType__c = 'Product/Service',
Apttus_Config2__LineNumber__c = 1, 
Apttus_Config2__ItemSequence__c = 1,
Apttus_Config2__NetPrice__c=10.0,
Apttus_Config2__BasePrice__c=10.0,
APTS_Yr_3_Amount__c=15.0,
APTS_Yr_4_Amount__c=15.0,
Apttus_Config2__BaseExtendedPrice__c = 10.0,
Apttus_Config2__AdjustedPrice__c = 10.0,
Apttus_Config2__OptionPrice__c = 5.0,
Apttus_Config2__Frequency__c = 'Monthly',
Apttus_Config2__PriceType__c = 'Recurring', 
Apttus_Config2__PriceAdjustment__c=0,
APTS_Contract_Term__c ='5 Years',
Apttus_Config2__ChargeType__c = 'Subscription Fee',          
Apttus_Config2__LineStatus__c = 'New',   
Apttus_Config2__PriceListItemId__c = pliSO.id); 
lineItemList.add(linObj7);

Apttus_Config2__LineItem__c linObj8 = new Apttus_Config2__LineItem__c(
Apttus_Config2__Quantity__c=7,
Apttus_Config2__ProductId__c=prodObj1.id,
Apttus_Config2__ConfigurationId__c = prodConfig.id, 
Apttus_Config2__LineType__c = 'Product/Service',
Apttus_Config2__LineNumber__c = 1, 
Apttus_Config2__ItemSequence__c = 1,
Apttus_Config2__NetPrice__c=10.0,
Apttus_Config2__BasePrice__c=10.0,
APTS_Yr_4_Amount__c=15.0,
APTS_Yr_5_Amount__c=15.0,
Apttus_Config2__BaseExtendedPrice__c = 10.0,
Apttus_Config2__AdjustedPrice__c = 10.0,
Apttus_Config2__OptionPrice__c = 5.0,
Apttus_Config2__Frequency__c = 'Monthly',
Apttus_Config2__PriceType__c = 'Recurring', 
Apttus_Config2__PriceAdjustment__c=0,
APTS_Contract_Term__c ='5 Years',
Apttus_Config2__ChargeType__c = 'Subscription Fee',          
Apttus_Config2__LineStatus__c = 'New',   
Apttus_Config2__PriceListItemId__c = pliSO.id); 
lineItemList.add(linObj8);

Apttus_Config2__LineItem__c linObj9 = new Apttus_Config2__LineItem__c(
Apttus_Config2__Quantity__c=7,
Apttus_Config2__ProductId__c=prodObj1.id,
Apttus_Config2__ConfigurationId__c = prodConfig.id, 
Apttus_Config2__LineType__c = 'Product/Service',
Apttus_Config2__LineNumber__c = 1, 
Apttus_Config2__ItemSequence__c = 1,
Apttus_Config2__NetPrice__c=10.0,
Apttus_Config2__BasePrice__c=10.0,
APTS_Yr_2_Amount__c=15.0,
APTS_Yr_5_Amount__c=15.0,
Apttus_Config2__BaseExtendedPrice__c = 10.0,
Apttus_Config2__AdjustedPrice__c = 10.0,
Apttus_Config2__OptionPrice__c = 5.0,
Apttus_Config2__Frequency__c = 'Monthly',
Apttus_Config2__PriceType__c = 'Recurring', 
Apttus_Config2__PriceAdjustment__c=0,
APTS_Contract_Term__c ='5 Years',
Apttus_Config2__ChargeType__c = 'Subscription Fee',          
Apttus_Config2__LineStatus__c = 'New',   
Apttus_Config2__PriceListItemId__c = pliSO.id); 
lineItemList.add(linObj9);

Apttus_Config2__LineItem__c linObj10 = new Apttus_Config2__LineItem__c(
Apttus_Config2__Quantity__c=7,
Apttus_Config2__ProductId__c=prodObj1.id,
Apttus_Config2__ConfigurationId__c = prodConfig.id, 
Apttus_Config2__LineType__c = 'Product/Service',
Apttus_Config2__LineNumber__c = 1, 
Apttus_Config2__ItemSequence__c = 1,
Apttus_Config2__NetPrice__c=10.0,
Apttus_Config2__BasePrice__c=10.0,
APTS_Yr_3_Amount__c=15.0,
APTS_Yr_5_Amount__c=15.0,
Apttus_Config2__BaseExtendedPrice__c = 10.0,
Apttus_Config2__AdjustedPrice__c = 10.0,
Apttus_Config2__OptionPrice__c = 5.0,
Apttus_Config2__Frequency__c = 'Monthly',
Apttus_Config2__PriceType__c = 'Recurring', 
Apttus_Config2__PriceAdjustment__c=0,
APTS_Contract_Term__c ='5 Years',
Apttus_Config2__ChargeType__c = 'Subscription Fee',          
Apttus_Config2__LineStatus__c = 'New',   
Apttus_Config2__PriceListItemId__c = pliSO.id); 
lineItemList.add(linObj10);

Apttus_Config2__LineItem__c linObj11 = new Apttus_Config2__LineItem__c(
Apttus_Config2__Quantity__c=7,
Apttus_Config2__ProductId__c=prodObj1.id,
Apttus_Config2__ConfigurationId__c = prodConfig.id, 
Apttus_Config2__LineType__c = 'Product/Service',
Apttus_Config2__LineNumber__c = 1, 
Apttus_Config2__ItemSequence__c = 1,
Apttus_Config2__NetPrice__c=10.0,
Apttus_Config2__BasePrice__c=10.0,
APTS_Yr_2_Amount__c=15.0,
APTS_Yr_3_Amount__c=15.0,
APTS_Yr_4_Amount__c=15.0,
Apttus_Config2__BaseExtendedPrice__c = 10.0,
Apttus_Config2__AdjustedPrice__c = 10.0,
Apttus_Config2__OptionPrice__c = 5.0,
Apttus_Config2__Frequency__c = 'Monthly',
Apttus_Config2__PriceType__c = 'Recurring', 
Apttus_Config2__PriceAdjustment__c=0,
APTS_Contract_Term__c ='5 Years',
Apttus_Config2__ChargeType__c = 'Subscription Fee',          
Apttus_Config2__LineStatus__c = 'New',   
Apttus_Config2__PriceListItemId__c = pliSO.id); 
lineItemList.add(linObj11);

Apttus_Config2__LineItem__c linObj12 = new Apttus_Config2__LineItem__c(
Apttus_Config2__Quantity__c=7,
Apttus_Config2__ProductId__c=prodObj1.id,
Apttus_Config2__ConfigurationId__c = prodConfig.id, 
Apttus_Config2__LineType__c = 'Product/Service',
Apttus_Config2__LineNumber__c = 1, 
Apttus_Config2__ItemSequence__c = 1,
Apttus_Config2__NetPrice__c=10.0,
Apttus_Config2__BasePrice__c=10.0,
APTS_Yr_3_Amount__c=15.0,
APTS_Yr_4_Amount__c=15.0,
APTS_Yr_5_Amount__c=15.0,
Apttus_Config2__BaseExtendedPrice__c = 10.0,
Apttus_Config2__AdjustedPrice__c = 10.0,
Apttus_Config2__OptionPrice__c = 5.0,
Apttus_Config2__Frequency__c = 'Monthly',
Apttus_Config2__PriceType__c = 'Recurring', 
Apttus_Config2__PriceAdjustment__c=0,
APTS_Contract_Term__c ='5 Years',
Apttus_Config2__ChargeType__c = 'Subscription Fee',          
Apttus_Config2__LineStatus__c = 'New',   
Apttus_Config2__PriceListItemId__c = pliSO.id); 
lineItemList.add(linObj12);

Apttus_Config2__LineItem__c linObj13 = new Apttus_Config2__LineItem__c(
Apttus_Config2__Quantity__c=7,
Apttus_Config2__ProductId__c=prodObj1.id,
Apttus_Config2__ConfigurationId__c = prodConfig.id, 
Apttus_Config2__LineType__c = 'Product/Service',
Apttus_Config2__LineNumber__c = 1, 
Apttus_Config2__ItemSequence__c = 1,
Apttus_Config2__NetPrice__c=10.0,
Apttus_Config2__BasePrice__c=10.0,
APTS_Yr_2_Amount__c=15.0,
APTS_Yr_3_Amount__c=15.0,
APTS_Yr_5_Amount__c=15.0,
Apttus_Config2__BaseExtendedPrice__c = 10.0,
Apttus_Config2__AdjustedPrice__c = 10.0,
Apttus_Config2__OptionPrice__c = 5.0,
Apttus_Config2__Frequency__c = 'Monthly',
Apttus_Config2__PriceType__c = 'Recurring', 
Apttus_Config2__PriceAdjustment__c=0,
APTS_Contract_Term__c ='5 Years',
Apttus_Config2__ChargeType__c = 'Subscription Fee',          
Apttus_Config2__LineStatus__c = 'New',   
Apttus_Config2__PriceListItemId__c = pliSO.id); 
lineItemList.add(linObj13);
insert lineItemList;

Test.startTest();
Apttus_Config2.CallbackTester.testValidationCallback
( cartID
, lineItemList
, null
, new APTS_Validation_Callback ());   
Test.stopTest();                                              
}*/
    
    @isTest static void testMethodMultiTieredPricing7(){
        Apttus_Config2__PriceList__c priceList = APTS_TestDataFactory.createPriceList('Thomson Reuters Master - US Legal');
        insert priceList;
        
        
        List<KeyValueListStore__c> keyValueList=new List<KeyValueListStore__c>();
        KeyValueListStore__c keyvaluestore=new  KeyValueListStore__c();
        keyvaluestore.Name='ANZUsersProfileId';
        keyvaluestore.TextValue__c=System.Label.APTS_OC_Test_Id;
        keyValueList.add(keyvaluestore);
        KeyValueListStore__c keyval = new KeyValueListStore__c();
        keyval.Name='ReasonWithCompetitor';
        keyval.TextValue__c='Price';
        keyValueList.add(keyval);
        insert keyValueList;
        
        Schema.DescribeFieldResult fieldResultMarket = Apttus_Config2__ProductConfiguration__c.APTS_AccountMirror_Picklist__c.getDescribe();
        String valueMarket = fieldResultMarket.getPicklistValues().get(0).getValue();
        
        insertStaticValues();
        WebServiceSettings__c oWebServiceSettings = new WebServiceSettings__c();
        oWebServiceSettings.Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable'; 
        oWebServiceSettings.Name = 'PaymentCreditIncrease'; 
        oWebServiceSettings.Timeout__c = 120; 
        oWebServiceSettings.Endpoint__c = 'https://dev.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease'; 
        oWebServiceSettings.Active__c = true;
        insert oWebServiceSettings;
        
        
        
        List<RecordtypeIds__c> recordlist=new List<RecordtypeIds__c>();
        RecordtypeIds__c recordtype=new RecordtypeIds__c();
        recordtype.Name='Pre-Pipeline Opportunities';
        recordtype.recTypeId__c=System.Label.APTS_OC_Test_Id;
        recordlist.add(recordtype);
        
        RecordtypeIds__c recordtype1=new RecordtypeIds__c();
        recordtype1.Name='Pipeline Opportunities';
        recordtype1.recTypeId__c=System.Label.APTS_OC_Test_Id;
        recordlist.add(recordtype1);
        insert recordlist;
        
        Profile profileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        
        User CorpUser=new User(username='testuser23corp55@acme.com',
                               lastname='testuser',
                               Alias='testuser',
                               Email='testuser@tcs.com',
                               Sub_Bu__c='US',
                               Segment__c='Professional Tax',
                               TimeZoneSidKey = 'GMT',
                               ProfileId = profileId.id,
                               LanguageLocaleKey = 'en_US',
                               EmailEncodingKey = 'UTF-8',
                               LocaleSidKey = 'en_US',
                               Default_Catalog__c ='USL');
        insert CorpUser;
        
        Account a = APTS_TestDataFactory.createAccount('Test Account');
        a.FrozenMarketSegment__c = valueMarket;
        insert a;
        
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();
        Source_System_Detail__c accountSSD=APTS_TestDataFactory.createSourceSystem(a);
        accountSSD.RecordtypeId=ssdRecorType;
        accountSSD.Name='ABC';
        accountSSD.Source_System_Name__c='ABC';
        accountSSD.Account_Name__c=a.ID;
        accountSSD.LCRM_Frozen_Market_Segment__c = valueMarket;
        accountSSD.Account_Inactive__c=false;
        accountSSD.LCRM_Sales_Org__c='WEST';
        insert accountSSD;
        
        Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        Opportunity oppty=APTS_TestDataFactory.createOpportunity('abc',a.id,'Needs Analysis',Date.Today());
        oppty.RecordtypeId=opptyRecorType;
        oppty.Source_System_Detail__c=accountSSD.id;
        oppty.Account=a;
        insert oppty;
        
        /*Apttus_Proposal__Proposal__c proposal = APTS_TestDataFactory.createProposal(oppty.id, accountSSD.Id);
proposal.APTS_Proposal_Business_Unit__c = 'Tax Professional';    

insert proposal;*/
        
        Id devRecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Proposal').getRecordTypeId();
        Apttus_Proposal__Proposal__c proposal = new Apttus_Proposal__Proposal__c(
            /*RecordTypeId=devRecordTypeId,*/ 
            Apttus_Proposal__Proposal_Name__c='testproposal',
            Apttus_Proposal__Account__c = a.id, 
            Apttus_Proposal__Opportunity__c=oppty.id, 
            Apttus_Proposal__Approval_Stage__c='Draft', 
            Apttus_Proposal__Proposal_Category__c='Quote', 
            Apttus_Proposal__ReadyToGenerate__c = true, 
            Apttus_Proposal__ReadyToPresent__c= true, 
            Apttus_QPConfig__PriceListId__c=priceList.id,
            APTS_SSD_Sold_To__c = accountSSD.Id
        );
        insert proposal;
        Apttus_Proposal__Proposal__c proposal2 = new Apttus_Proposal__Proposal__c(
            RecordTypeId=devRecordTypeId, 
            Apttus_Proposal__Proposal_Name__c='testproposal2',
            Apttus_Proposal__Account__c = a.id, 
            Apttus_Proposal__Opportunity__c=oppty.id, 
            Apttus_Proposal__Approval_Stage__c='Draft', 
            Apttus_Proposal__Proposal_Category__c='Quote', 
            Apttus_Proposal__ReadyToGenerate__c = true, 
            Apttus_Proposal__ReadyToPresent__c= true, 
            Apttus_QPConfig__PriceListId__c=priceList.id,
            APTS_SSD_Sold_To__c = accountSSD.Id,
            APTS_Proposal_Business_Unit__c = 'Tax Professional'
        );
        insert proposal2;
        
        
        Apttus_Config2__ProductConfiguration__c prodConfig = APTS_TestDataFactory.createProductConfiguration(proposal2.Id);
        insert prodConfig;
        Apttus_Config2__ProductConfiguration__c prodConfig1 = APTS_TestDataFactory.createProductConfiguration(proposal2.Id);
        insert prodConfig1;
        Apttus_Config2__ProductConfiguration__c prodConfig2 = APTS_TestDataFactory.createProductConfiguration(proposal2.Id);
        insert prodConfig2;
        Apttus_Config2__ProductConfiguration__c prodConfig3 = APTS_TestDataFactory.createProductConfiguration(proposal2.Id);
        insert prodConfig3;
        ID cartID = prodConfig.Id;
        ID cartID1 = prodConfig1.Id;
        ID cartID2 = prodConfig2.Id;
        ID cartID3 = prodConfig3.Id;
        
        List<Product2> productsList=new List<Product2>();
        Product2 prodObj = new Product2();
        prodObj.Name = 'Network Services 1.0';
        prodObj.APTS_Media_Lower_Level_Code__c = '2Q';
        prodObj.APTS_Availability_Date__c= Date.newInstance(2018, 1, 1);   
        productsList.add(prodObj);  
        Product2 prodObj1 = new Product2();
        prodObj1.Name = 'Network Services 2.0';
        prodObj1.APTS_Media_Lower_Level_Code__c = '2Q';
        prodObj1.APTS_Availability_Date__c= Date.newInstance(2018, 1, 1);   
        productsList.add(prodObj1);
        insert productsList;
        
        Apttus_Config2__PriceListItem__c pliSO = new Apttus_Config2__PriceListItem__c();
        pliSO.Apttus_Config2__Active__c = true;
        pliSO.Apttus_Config2__PriceListId__c = priceList.Id;
        pliSO.APTS_Max_Fill_Up_Price__c = 5;
        insert pliSO;
        
        List<Apttus_Config2__LineItem__c> lineItemList=new List<Apttus_Config2__LineItem__c>();     
        Apttus_Config2__LineItem__c linObj2 = new Apttus_Config2__LineItem__c(
            
            Apttus_Config2__Quantity__c=7,
            Apttus_Config2__ProductId__c=prodObj1.id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Product/Service',
            Apttus_Config2__LineNumber__c = 1, 
            Apttus_Config2__ItemSequence__c = 1,
            Apttus_Config2__NetPrice__c=10.0,
            Apttus_Config2__BasePrice__c=10.0,
            APTS_Yr_2_Amount__c=15.0,
            Apttus_Config2__BaseExtendedPrice__c = 10.0,
            Apttus_Config2__AdjustedPrice__c = 10.0,
            Apttus_Config2__OptionPrice__c = 5.0,
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='1 Year',
            Apttus_Config2__ChargeType__c = 'Subscription Fee',          
            Apttus_Config2__LineStatus__c = 'New',   
            Apttus_Config2__PriceListItemId__c = pliSO.id); 
        lineItemList.add(linObj2);
        
        Apttus_Config2__LineItem__c linObj3 = new Apttus_Config2__LineItem__c(
            Apttus_Config2__Quantity__c=7,
            Apttus_Config2__ProductId__c=prodObj1.id,
            Apttus_Config2__ConfigurationId__c = prodConfig1.id, 
            Apttus_Config2__LineType__c = 'Product/Service',
            Apttus_Config2__LineNumber__c = 1, 
            Apttus_Config2__ItemSequence__c = 1,
            Apttus_Config2__NetPrice__c=10.0,
            Apttus_Config2__BasePrice__c=10.0,
            APTS_Yr_3_Amount__c=15.0,
            Apttus_Config2__BaseExtendedPrice__c = 10.0,
            Apttus_Config2__AdjustedPrice__c = 10.0,
            Apttus_Config2__OptionPrice__c = 5.0,
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='2 Years',
            Apttus_Config2__ChargeType__c = 'Subscription Fee',          
            Apttus_Config2__LineStatus__c = 'New',   
            Apttus_Config2__PriceListItemId__c = pliSO.id); 
        lineItemList.add(linObj3);
        
        Apttus_Config2__LineItem__c linObj4 = new Apttus_Config2__LineItem__c(
            Apttus_Config2__Quantity__c=7,
            Apttus_Config2__ProductId__c=prodObj1.id,
            Apttus_Config2__ConfigurationId__c = prodConfig2.id, 
            Apttus_Config2__LineType__c = 'Product/Service',
            Apttus_Config2__LineNumber__c = 1, 
            Apttus_Config2__ItemSequence__c = 1,
            Apttus_Config2__NetPrice__c=10.0,
            Apttus_Config2__BasePrice__c=10.0,
            APTS_Yr_4_Amount__c=15.0,
            Apttus_Config2__BaseExtendedPrice__c = 10.0,
            Apttus_Config2__AdjustedPrice__c = 10.0,
            Apttus_Config2__OptionPrice__c = 5.0,
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',
            Apttus_Config2__ChargeType__c = 'Subscription Fee',          
            Apttus_Config2__LineStatus__c = 'New',   
            Apttus_Config2__PriceListItemId__c = pliSO.id); 
        lineItemList.add(linObj4);
        
        Apttus_Config2__LineItem__c linObj5 = new Apttus_Config2__LineItem__c(
            Apttus_Config2__Quantity__c=7,
            Apttus_Config2__ProductId__c=prodObj1.id,
            Apttus_Config2__ConfigurationId__c = prodConfig3.id, 
            Apttus_Config2__LineType__c = 'Product/Service',
            Apttus_Config2__LineNumber__c = 1, 
            Apttus_Config2__ItemSequence__c = 1,
            Apttus_Config2__NetPrice__c=10.0,
            Apttus_Config2__BasePrice__c=10.0,
            APTS_Yr_5_Amount__c=15.0,
            Apttus_Config2__BaseExtendedPrice__c = 10.0,
            Apttus_Config2__AdjustedPrice__c = 10.0,
            Apttus_Config2__OptionPrice__c = 5.0,
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='5 Years',
            Apttus_Config2__ChargeType__c = 'Subscription Fee',          
            Apttus_Config2__LineStatus__c = 'New',   
            Apttus_Config2__PriceListItemId__c = pliSO.id); 
        lineItemList.add(linObj5);
        
        Apttus_Config2__LineItem__c linObj6 = new Apttus_Config2__LineItem__c(
            Apttus_Config2__Quantity__c=7,
            Apttus_Config2__ProductId__c=prodObj1.id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Product/Service',
            Apttus_Config2__LineNumber__c = 1, 
            Apttus_Config2__ItemSequence__c = 1,
            Apttus_Config2__NetPrice__c=10.0,
            Apttus_Config2__BasePrice__c=10.0,
            APTS_Yr_2_Amount__c=15.0,
            APTS_Yr_3_Amount__c=15.0,
            Apttus_Config2__BaseExtendedPrice__c = 10.0,
            Apttus_Config2__AdjustedPrice__c = 10.0,
            Apttus_Config2__OptionPrice__c = 5.0,
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='5 Years',
            Apttus_Config2__ChargeType__c = 'Subscription Fee',          
            Apttus_Config2__LineStatus__c = 'New',   
            Apttus_Config2__PriceListItemId__c = pliSO.id); 
        lineItemList.add(linObj6);
        
        Apttus_Config2__LineItem__c linObj7 = new Apttus_Config2__LineItem__c(
            Apttus_Config2__Quantity__c=7,
            Apttus_Config2__ProductId__c=prodObj1.id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Product/Service',
            Apttus_Config2__LineNumber__c = 1, 
            Apttus_Config2__ItemSequence__c = 1,
            Apttus_Config2__NetPrice__c=10.0,
            Apttus_Config2__BasePrice__c=10.0,
            APTS_Yr_3_Amount__c=15.0,
            APTS_Yr_4_Amount__c=15.0,
            Apttus_Config2__BaseExtendedPrice__c = 10.0,
            Apttus_Config2__AdjustedPrice__c = 10.0,
            Apttus_Config2__OptionPrice__c = 5.0,
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='5 Years',
            Apttus_Config2__ChargeType__c = 'Subscription Fee',          
            Apttus_Config2__LineStatus__c = 'New',   
            Apttus_Config2__PriceListItemId__c = pliSO.id); 
        lineItemList.add(linObj7);
        
        Apttus_Config2__LineItem__c linObj8 = new Apttus_Config2__LineItem__c(
            Apttus_Config2__Quantity__c=7,
            Apttus_Config2__ProductId__c=prodObj1.id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Product/Service',
            Apttus_Config2__LineNumber__c = 1, 
            Apttus_Config2__ItemSequence__c = 1,
            Apttus_Config2__NetPrice__c=10.0,
            Apttus_Config2__BasePrice__c=10.0,
            APTS_Yr_4_Amount__c=15.0,
            APTS_Yr_5_Amount__c=15.0,
            Apttus_Config2__BaseExtendedPrice__c = 10.0,
            Apttus_Config2__AdjustedPrice__c = 10.0,
            Apttus_Config2__OptionPrice__c = 5.0,
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='5 Years',
            Apttus_Config2__ChargeType__c = 'Subscription Fee',          
            Apttus_Config2__LineStatus__c = 'New',   
            Apttus_Config2__PriceListItemId__c = pliSO.id); 
        lineItemList.add(linObj8);
        
        Apttus_Config2__LineItem__c linObj9 = new Apttus_Config2__LineItem__c(
            Apttus_Config2__Quantity__c=7,
            Apttus_Config2__ProductId__c=prodObj1.id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Product/Service',
            Apttus_Config2__LineNumber__c = 1, 
            Apttus_Config2__ItemSequence__c = 1,
            Apttus_Config2__NetPrice__c=10.0,
            Apttus_Config2__BasePrice__c=10.0,
            APTS_Yr_2_Amount__c=15.0,
            APTS_Yr_5_Amount__c=15.0,
            Apttus_Config2__BaseExtendedPrice__c = 10.0,
            Apttus_Config2__AdjustedPrice__c = 10.0,
            Apttus_Config2__OptionPrice__c = 5.0,
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='5 Years',
            Apttus_Config2__ChargeType__c = 'Subscription Fee',          
            Apttus_Config2__LineStatus__c = 'New',   
            Apttus_Config2__PriceListItemId__c = pliSO.id); 
        lineItemList.add(linObj9);
        
        Apttus_Config2__LineItem__c linObj10 = new Apttus_Config2__LineItem__c(
            Apttus_Config2__Quantity__c=7,
            Apttus_Config2__ProductId__c=prodObj1.id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Product/Service',
            Apttus_Config2__LineNumber__c = 1, 
            Apttus_Config2__ItemSequence__c = 1,
            Apttus_Config2__NetPrice__c=10.0,
            Apttus_Config2__BasePrice__c=10.0,
            APTS_Yr_3_Amount__c=15.0,
            APTS_Yr_5_Amount__c=15.0,
            Apttus_Config2__BaseExtendedPrice__c = 10.0,
            Apttus_Config2__AdjustedPrice__c = 10.0,
            Apttus_Config2__OptionPrice__c = 5.0,
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='5 Years',
            Apttus_Config2__ChargeType__c = 'Subscription Fee',          
            Apttus_Config2__LineStatus__c = 'New',   
            Apttus_Config2__PriceListItemId__c = pliSO.id); 
        lineItemList.add(linObj10);
        
        Apttus_Config2__LineItem__c linObj11 = new Apttus_Config2__LineItem__c(
            Apttus_Config2__Quantity__c=7,
            Apttus_Config2__ProductId__c=prodObj1.id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Product/Service',
            Apttus_Config2__LineNumber__c = 1, 
            Apttus_Config2__ItemSequence__c = 1,
            Apttus_Config2__NetPrice__c=10.0,
            Apttus_Config2__BasePrice__c=10.0,
            APTS_Yr_2_Amount__c=15.0,
            APTS_Yr_3_Amount__c=15.0,
            APTS_Yr_4_Amount__c=15.0,
            Apttus_Config2__BaseExtendedPrice__c = 10.0,
            Apttus_Config2__AdjustedPrice__c = 10.0,
            Apttus_Config2__OptionPrice__c = 5.0,
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='5 Years',
            Apttus_Config2__ChargeType__c = 'Subscription Fee',          
            Apttus_Config2__LineStatus__c = 'New',   
            Apttus_Config2__PriceListItemId__c = pliSO.id); 
        lineItemList.add(linObj11);
        
        Apttus_Config2__LineItem__c linObj12 = new Apttus_Config2__LineItem__c(
            Apttus_Config2__Quantity__c=7,
            Apttus_Config2__ProductId__c=prodObj1.id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Product/Service',
            Apttus_Config2__LineNumber__c = 1, 
            Apttus_Config2__ItemSequence__c = 1,
            Apttus_Config2__NetPrice__c=10.0,
            Apttus_Config2__BasePrice__c=10.0,
            APTS_Yr_3_Amount__c=15.0,
            APTS_Yr_4_Amount__c=15.0,
            APTS_Yr_5_Amount__c=15.0,
            Apttus_Config2__BaseExtendedPrice__c = 10.0,
            Apttus_Config2__AdjustedPrice__c = 10.0,
            Apttus_Config2__OptionPrice__c = 5.0,
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='5 Years',
            Apttus_Config2__ChargeType__c = 'Subscription Fee',          
            Apttus_Config2__LineStatus__c = 'New',   
            Apttus_Config2__PriceListItemId__c = pliSO.id); 
        lineItemList.add(linObj12);
        
        Apttus_Config2__LineItem__c linObj13 = new Apttus_Config2__LineItem__c(
            Apttus_Config2__Quantity__c=7,
            Apttus_Config2__ProductId__c=prodObj1.id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Product/Service',
            Apttus_Config2__LineNumber__c = 1, 
            Apttus_Config2__ItemSequence__c = 1,
            Apttus_Config2__NetPrice__c=10.0,
            Apttus_Config2__BasePrice__c=10.0,
            APTS_Yr_2_Amount__c=15.0,
            APTS_Yr_3_Amount__c=15.0,
            APTS_Yr_5_Amount__c=15.0,
            Apttus_Config2__BaseExtendedPrice__c = 10.0,
            Apttus_Config2__AdjustedPrice__c = 10.0,
            Apttus_Config2__OptionPrice__c = 5.0,
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='5 Years',
            Apttus_Config2__ChargeType__c = 'Subscription Fee',          
            Apttus_Config2__LineStatus__c = 'New',   
            Apttus_Config2__PriceListItemId__c = pliSO.id); 
        lineItemList.add(linObj13);
        
        insert lineItemList;
        
        Test.startTest();
        /*Apttus_Config2.CallbackTester.testValidationCallback
            ( cartID
             , lineItemList
             , null
             , new APTS_Validation_Callback ()); */
             
        List<Apttus_Config2__LineItem__c> lineItemsList1 = [SELECT Id, Name, Apttus_Config2__ProductId__c, Apttus_Config2__ConfigurationId__c, Apttus_Config2__ConfigurationId__r.APTS_SSD_Sold_To__c, Apttus_Config2__LineNumber__c,
                                                            Apttus_Config2__ItemSequence__c, Apttus_Config2__LineType__c, Apttus_Config2__LineStatus__c, Apttus_Config2__PriceListItemId__r.APTS_Max_Fill_Up_Price__c, Apttus_Config2__NetPrice__c, APTS_Contract_Term__c,
                                                            APTS_Years_2_Plus_Default__c, APTS_Years_2_Plus_Adjustment__c, Apttus_Config2__Quantity__c, Apttus_Config2__BasePrice__c, APTS_Proposal_Group__c, APTS_Group__c, APTS_Bridge__c,APTS_Contract_Term_Number__c        
                                                            FROM Apttus_Config2__LineItem__c 
                                                            WHERE Id = :linObj2.Id];   
        Apttus_Config2.CallbackTester.testValidationCallback
            ( cartID
             , lineItemsList1
             , null
             , new APTS_Validation_Callback ()); 
             
        List<Apttus_Config2__LineItem__c> lineItemsList2 = [SELECT Id, Name, Apttus_Config2__ProductId__c, Apttus_Config2__ConfigurationId__c, Apttus_Config2__ConfigurationId__r.APTS_SSD_Sold_To__c, Apttus_Config2__LineNumber__c,
                                                            Apttus_Config2__ItemSequence__c, Apttus_Config2__LineType__c, Apttus_Config2__LineStatus__c, Apttus_Config2__PriceListItemId__r.APTS_Max_Fill_Up_Price__c, Apttus_Config2__NetPrice__c, APTS_Contract_Term__c,
                                                            APTS_Years_2_Plus_Default__c, APTS_Years_2_Plus_Adjustment__c, Apttus_Config2__Quantity__c, Apttus_Config2__BasePrice__c, APTS_Proposal_Group__c, APTS_Group__c, APTS_Bridge__c,APTS_Contract_Term_Number__c        
                                                            FROM Apttus_Config2__LineItem__c 
                                                            WHERE Id = :linObj3.Id];   
        Apttus_Config2.CallbackTester.testValidationCallback
            ( cartID1
             , lineItemsList2
             , null
             , new APTS_Validation_Callback ());  
             
        List<Apttus_Config2__LineItem__c> lineItemsList3 = [SELECT Id, Name, Apttus_Config2__ProductId__c, Apttus_Config2__ConfigurationId__c, Apttus_Config2__ConfigurationId__r.APTS_SSD_Sold_To__c, Apttus_Config2__LineNumber__c,
                                                            Apttus_Config2__ItemSequence__c, Apttus_Config2__LineType__c, Apttus_Config2__LineStatus__c, Apttus_Config2__PriceListItemId__r.APTS_Max_Fill_Up_Price__c, Apttus_Config2__NetPrice__c, APTS_Contract_Term__c,
                                                            APTS_Years_2_Plus_Default__c, APTS_Years_2_Plus_Adjustment__c, Apttus_Config2__Quantity__c, Apttus_Config2__BasePrice__c, APTS_Proposal_Group__c, APTS_Group__c, APTS_Bridge__c,APTS_Contract_Term_Number__c        
                                                            FROM Apttus_Config2__LineItem__c 
                                                            WHERE Id = :linObj4.Id];   
        Apttus_Config2.CallbackTester.testValidationCallback
            ( cartID2
             , lineItemsList3
             , null
             , new APTS_Validation_Callback ());  
             
        List<Apttus_Config2__LineItem__c> lineItemsList4= [SELECT Id, Name, Apttus_Config2__ProductId__c, Apttus_Config2__ConfigurationId__c, Apttus_Config2__ConfigurationId__r.APTS_SSD_Sold_To__c, Apttus_Config2__LineNumber__c,
                                                            Apttus_Config2__ItemSequence__c, Apttus_Config2__LineType__c, Apttus_Config2__LineStatus__c, Apttus_Config2__PriceListItemId__r.APTS_Max_Fill_Up_Price__c, Apttus_Config2__NetPrice__c, APTS_Contract_Term__c,
                                                            APTS_Years_2_Plus_Default__c, APTS_Years_2_Plus_Adjustment__c, Apttus_Config2__Quantity__c, Apttus_Config2__BasePrice__c, APTS_Proposal_Group__c, APTS_Group__c, APTS_Bridge__c,APTS_Contract_Term_Number__c        
                                                            FROM Apttus_Config2__LineItem__c 
                                                            WHERE Id = :linObj5.Id];   
        Apttus_Config2.CallbackTester.testValidationCallback
            ( cartID3
             , lineItemsList4
             , null
             , new APTS_Validation_Callback ());  


 
  
        Test.stopTest();                                              
    }
    
    @isTest static void insertStaticValues(){
        
        LIST<Static_Values__c> staticCSList = new LIST<Static_Values__c>{  new Static_Values__c(name='skiptoNullifyCreditCardDetails', value__c='Guest')
            
            };
                
                insert staticCSList ;
        
    }
    
    @isTest static void testMethodForTaxProf(){
        
        
        Apttus_Config2__PriceList__c priceList = APTS_TestDataFactory.createPriceList('Thomson Reuters Master - US Legal');
        insert priceList;
        
        List<KeyValueListStore__c> keyValueList=new List<KeyValueListStore__c>();
        KeyValueListStore__c keyvaluestore=new  KeyValueListStore__c();
        keyvaluestore.Name='ANZUsersProfileId';
        keyvaluestore.TextValue__c=System.Label.APTS_OC_Test_Id;
        keyValueList.add(keyvaluestore);
        KeyValueListStore__c keyval = new KeyValueListStore__c();
        keyval.Name='ReasonWithCompetitor';
        keyval.TextValue__c='Price';
        keyValueList.add(keyval);
        insert keyValueList;
        
        Schema.DescribeFieldResult fieldResultMarket = Apttus_Config2__ProductConfiguration__c.APTS_AccountMirror_Picklist__c.getDescribe();
        String valueMarket = fieldResultMarket.getPicklistValues().get(0).getValue();
        
        insertStaticValues();
        WebServiceSettings__c oWebServiceSettings = new WebServiceSettings__c();
        oWebServiceSettings.Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable'; 
        oWebServiceSettings.Name = 'PaymentCreditIncrease'; 
        oWebServiceSettings.Timeout__c = 120; 
        oWebServiceSettings.Endpoint__c = 'https://dev.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease'; 
        oWebServiceSettings.Active__c = true;
        insert oWebServiceSettings;
        
        
        List<RecordtypeIds__c> recordlist=new List<RecordtypeIds__c>();
        RecordtypeIds__c recordtype=new RecordtypeIds__c();
        recordtype.Name='Pre-Pipeline Opportunities';
        recordtype.recTypeId__c=System.Label.APTS_OC_Test_Id;
        recordlist.add(recordtype);
        
        RecordtypeIds__c recordtype1=new RecordtypeIds__c();
        recordtype1.Name='Pipeline Opportunities';
        recordtype1.recTypeId__c=System.Label.APTS_OC_Test_Id;
        recordlist.add(recordtype1);
        insert recordlist;
        
        Profile profileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        
        User CorpUser=new User(username='testuser23corp83@acme.com',
                               lastname='testuser',
                               Alias='testuser',
                               Email='testuser@tcs.com',
                               Sub_Bu__c='US',
                               TimeZoneSidKey = 'GMT',
                               ProfileId = profileId.id,
                               LanguageLocaleKey = 'en_US',
                               EmailEncodingKey = 'UTF-8',
                               LocaleSidKey = 'en_US',
                               Default_Catalog__c ='USL');
        insert CorpUser;
        
        Account a = APTS_TestDataFactory.createAccount('Test Account');
        a.FrozenMarketSegment__c = valueMarket;
        insert a;
        
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();
        Source_System_Detail__c accountSSD=APTS_TestDataFactory.createSourceSystem(a);
        accountSSD.RecordtypeId=ssdRecorType;
        accountSSD.Name='ABC';
        accountSSD.Source_System_Name__c='ABC';
        accountSSD.Account_Name__c=a.ID;
        accountSSD.LCRM_Frozen_Market_Segment__c = valueMarket;
        accountSSD.Account_Inactive__c=false;
        accountSSD.LCRM_Sales_Org__c='S100';
        insert accountSSD;
        
        Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        Opportunity oppty=APTS_TestDataFactory.createOpportunity('abc',a.id,'Needs Analysis',Date.Today());
        oppty.RecordtypeId=opptyRecorType;
        oppty.Source_System_Detail__c=accountSSD.id;
        oppty.Account=a;
        insert oppty;
        
        Apttus_Proposal__Proposal__c proposal = APTS_TestDataFactory.createProposal(oppty.id, accountSSD.Id);
        proposal.APTS_Proposal_Business_Unit__c = 'Tax Professional';    
        //System.runAs(CorpUser) {
        insert proposal;
        //}    
        
        List<Apttus_Config2__ProductConfiguration__c> cartList = new List<Apttus_Config2__ProductConfiguration__c>();
        Apttus_Config2__ProductConfiguration__c prodConfig = APTS_TestDataFactory.createProductConfiguration(proposal.Id);
        cartList.add(prodConfig);
        Apttus_Config2__ProductConfiguration__c prodConfig1 = APTS_TestDataFactory.createProductConfiguration(proposal.Id);
        cartList.add(prodConfig1);
        Apttus_Config2__ProductConfiguration__c prodConfig2 = APTS_TestDataFactory.createProductConfiguration(proposal.Id);
        cartList.add(prodConfig2);
        Apttus_Config2__ProductConfiguration__c prodConfig3 = APTS_TestDataFactory.createProductConfiguration(proposal.Id);
        cartList.add(prodConfig3);
        Apttus_Config2__ProductConfiguration__c prodConfig4 = APTS_TestDataFactory.createProductConfiguration(proposal.Id);
        cartList.add(prodConfig4);
        Apttus_Config2__ProductConfiguration__c prodConfig5 = APTS_TestDataFactory.createProductConfiguration(proposal.Id);
        cartList.add(prodConfig5);
        insert cartList;
        
        ID cartID = prodConfig.Id;
        ID cartID1 = prodConfig1.Id;
        ID cartID2 = prodConfig2.Id;
        ID cartID3 = prodConfig3.Id;
        ID cartID4 = prodConfig4.Id;
        ID cartID5 = prodConfig5.Id;
        
        List<Product2> productsList=new List<Product2>();
        Product2 prodObj = new Product2();
        prodObj.Name = 'Network Services 1.0';
        prodObj.APTS_Media_Lower_Level_Code__c = '';
        prodObj.APTS_Availability_Date__c= Date.newInstance(2018, 1, 1);   
        productsList.add(prodObj);  
        Product2 prodObj1 = new Product2();
        prodObj1.Name = 'Network Services 2.0';
        prodObj1.APTS_Media_Lower_Level_Code__c = '';
        prodObj1.APTS_Availability_Date__c= Date.newInstance(2018, 1, 1);   
        productsList.add(prodObj1);
        insert productsList;
        
        Apttus_Config2__PriceListItem__c pliSO = new Apttus_Config2__PriceListItem__c();
        pliSO.Apttus_Config2__Active__c = true;
        pliSO.Apttus_Config2__PriceListId__c = priceList.Id;
        pliSO.APTS_Max_Fill_Up_Price__c = 5;
        insert pliSO;
        
        List<Apttus_Config2__LineItem__c> lineItemList=new List<Apttus_Config2__LineItem__c>();     
        Apttus_Config2__LineItem__c linObj2 = new Apttus_Config2__LineItem__c(
            
            Apttus_Config2__Quantity__c=7,
            Apttus_Config2__ProductId__c=prodObj1.id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Product/Service',
            Apttus_Config2__LineNumber__c = 1, 
            Apttus_Config2__ItemSequence__c = 1,
            Apttus_Config2__NetPrice__c=10.0,
            Apttus_Config2__BasePrice__c=10.0,
            APTS_Yr_2_Amount__c=15.0,
            Apttus_Config2__BaseExtendedPrice__c = 10.0,
            Apttus_Config2__AdjustedPrice__c = 10.0,
            Apttus_Config2__OptionPrice__c = 5.0,
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='5 Years',
            Apttus_Config2__ChargeType__c = 'Standard Fee',          
            Apttus_Config2__LineStatus__c = 'New', 
            Apttus_Config2__PriceListItemId__c = pliSO.id); 
        lineItemList.add(linObj2);
        
        Apttus_Config2__LineItem__c linObj3 = new Apttus_Config2__LineItem__c(
            Apttus_Config2__Quantity__c=7,
            Apttus_Config2__ProductId__c=prodObj1.id,
            Apttus_Config2__ConfigurationId__c = prodConfig1.id, 
            Apttus_Config2__LineType__c = 'Product/Service',
            Apttus_Config2__LineNumber__c = 1, 
            Apttus_Config2__ItemSequence__c = 1,
            Apttus_Config2__NetPrice__c=10.0,
            Apttus_Config2__BasePrice__c=10.0,
            APTS_Yr_3_Amount__c=15.0,
            Apttus_Config2__BaseExtendedPrice__c = 10.0,
            Apttus_Config2__AdjustedPrice__c = 10.0,
            Apttus_Config2__OptionPrice__c = 5.0,
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='1 Year',
            Apttus_Config2__ChargeType__c = 'Subscription Fee',          
            Apttus_Config2__LineStatus__c = 'New', 
            Apttus_Config2__PriceListItemId__c = pliSO.id); 
        lineItemList.add(linObj3);
        
        Apttus_Config2__LineItem__c linObj4 = new Apttus_Config2__LineItem__c(
            Apttus_Config2__Quantity__c=7,
            Apttus_Config2__ProductId__c=prodObj1.id,
            Apttus_Config2__ConfigurationId__c = prodConfig2.id, 
            Apttus_Config2__LineType__c = 'Product/Service',
            Apttus_Config2__LineNumber__c = 1, 
            Apttus_Config2__ItemSequence__c = 1,
            Apttus_Config2__NetPrice__c=10.0,
            Apttus_Config2__BasePrice__c=10.0,
            APTS_Yr_4_Amount__c=15.0,
            Apttus_Config2__BaseExtendedPrice__c = 10.0,
            Apttus_Config2__AdjustedPrice__c = 10.0,
            Apttus_Config2__OptionPrice__c = 5.0,
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='2 Years',
            Apttus_Config2__ChargeType__c = 'Subscription Fee',          
            Apttus_Config2__LineStatus__c = 'New',   
            Apttus_Config2__PriceListItemId__c = pliSO.id); 
        lineItemList.add(linObj4);
        
        Apttus_Config2__LineItem__c linObj5 = new Apttus_Config2__LineItem__c(
            Apttus_Config2__Quantity__c=7,
            Apttus_Config2__ProductId__c=prodObj1.id,
            Apttus_Config2__ConfigurationId__c = prodConfig3.id, 
            Apttus_Config2__LineType__c = 'Product/Service',
            Apttus_Config2__LineNumber__c = 1, 
            Apttus_Config2__ItemSequence__c = 1,
            Apttus_Config2__NetPrice__c=10.0,
            Apttus_Config2__BasePrice__c=10.0,
            APTS_Yr_5_Amount__c=15.0,
            Apttus_Config2__BaseExtendedPrice__c = 10.0,
            Apttus_Config2__AdjustedPrice__c = 10.0,
            Apttus_Config2__OptionPrice__c = 5.0,
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',
            Apttus_Config2__ChargeType__c = 'Subscription Fee',          
            Apttus_Config2__LineStatus__c = 'New',   
            APTS_Yr_2_Amount__c = 10,
            Apttus_Config2__PriceListItemId__c = pliSO.id); 
        lineItemList.add(linObj5);
        
        Apttus_Config2__LineItem__c linObj6 = new Apttus_Config2__LineItem__c(
            Apttus_Config2__Quantity__c=7,
            Apttus_Config2__ProductId__c=prodObj1.id,
            Apttus_Config2__ConfigurationId__c = prodConfig4.id, 
            Apttus_Config2__LineType__c = 'Product/Service',
            Apttus_Config2__LineNumber__c = 1, 
            Apttus_Config2__ItemSequence__c = 1,
            Apttus_Config2__NetPrice__c=10.0,
            Apttus_Config2__BasePrice__c=10.0,
            APTS_Yr_2_Amount__c=15.0,
            APTS_Yr_3_Amount__c=15.0,
            Apttus_Config2__BaseExtendedPrice__c = 10.0,
            Apttus_Config2__AdjustedPrice__c = 10.0,
            Apttus_Config2__OptionPrice__c = 5.0,
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='4 Years',
            Apttus_Config2__ChargeType__c = 'Subscription Fee',          
            Apttus_Config2__LineStatus__c = 'New', 
            Apttus_Config2__PriceListItemId__c = pliSO.id); 
        lineItemList.add(linObj6);
        
        //Newly added
        Apttus_Config2__LineItem__c linObj7 = new Apttus_Config2__LineItem__c(
            Apttus_Config2__Quantity__c=7,
            Apttus_Config2__ProductId__c=prodObj1.id,
            Apttus_Config2__ConfigurationId__c = prodConfig5.id, 
            Apttus_Config2__LineType__c = 'Product/Service',
            Apttus_Config2__LineNumber__c = 1, 
            Apttus_Config2__ItemSequence__c = 1,
            Apttus_Config2__NetPrice__c=10.0,
            Apttus_Config2__BasePrice__c=10.0,
            APTS_Yr_2_Amount__c=15.0,
            APTS_Yr_3_Amount__c=15.0,
            Apttus_Config2__BaseExtendedPrice__c = 10.0,
            Apttus_Config2__AdjustedPrice__c = 10.0,
            Apttus_Config2__OptionPrice__c = 5.0,
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='5 Years',
            Apttus_Config2__ChargeType__c = 'Subscription Fee',          
            Apttus_Config2__LineStatus__c = 'New', 
            Apttus_Config2__PriceListItemId__c = pliSO.id); 
        lineItemList.add(linObj7);
        
        insert lineItemList;
        
        Test.startTest();
        
        List<Apttus_Config2__LineItem__c> lineItemsList1 = [SELECT Id, Name, Apttus_Config2__ProductId__c, Apttus_Config2__ConfigurationId__c, Apttus_Config2__ConfigurationId__r.APTS_SSD_Sold_To__c, Apttus_Config2__LineNumber__c,
                                                            Apttus_Config2__ItemSequence__c, Apttus_Config2__LineType__c, Apttus_Config2__LineStatus__c, Apttus_Config2__PriceListItemId__r.APTS_Max_Fill_Up_Price__c, Apttus_Config2__NetPrice__c, APTS_Contract_Term__c,
                                                            APTS_Years_2_Plus_Default__c, APTS_Years_2_Plus_Adjustment__c, Apttus_Config2__Quantity__c, Apttus_Config2__BasePrice__c, APTS_Proposal_Group__c, APTS_Group__c, APTS_Bridge__c        
                                                            FROM Apttus_Config2__LineItem__c 
                                                            WHERE Id = :linObj2.Id];   
        Apttus_Config2.CallbackTester.testValidationCallback
            ( cartID
             , lineItemsList1
             , null
             , new APTS_Validation_Callback ());  
        
        List<Apttus_Config2__LineItem__c> lineItemsList2 = [SELECT Id, Name, Apttus_Config2__ProductId__c, Apttus_Config2__ConfigurationId__c, Apttus_Config2__ConfigurationId__r.APTS_SSD_Sold_To__c, Apttus_Config2__LineNumber__c,
                                                            Apttus_Config2__ItemSequence__c, Apttus_Config2__LineType__c, Apttus_Config2__LineStatus__c, Apttus_Config2__PriceListItemId__r.APTS_Max_Fill_Up_Price__c, Apttus_Config2__NetPrice__c, APTS_Contract_Term__c,
                                                            APTS_Years_2_Plus_Default__c, APTS_Years_2_Plus_Adjustment__c, Apttus_Config2__Quantity__c, Apttus_Config2__BasePrice__c, APTS_Proposal_Group__c, APTS_Group__c, APTS_Bridge__c        
                                                            FROM Apttus_Config2__LineItem__c 
                                                            WHERE Id = :linObj3.Id];
        Apttus_Config2.CallbackTester.testValidationCallback
            ( cartID1
             , lineItemsList2
             , null
             , new APTS_Validation_Callback ()); 
        
        List<Apttus_Config2__LineItem__c> lineItemsList3 = [SELECT Id, Name, Apttus_Config2__ProductId__c, Apttus_Config2__ConfigurationId__c, Apttus_Config2__ConfigurationId__r.APTS_SSD_Sold_To__c, Apttus_Config2__LineNumber__c,
                                                            Apttus_Config2__ItemSequence__c, Apttus_Config2__LineType__c, Apttus_Config2__LineStatus__c, Apttus_Config2__PriceListItemId__r.APTS_Max_Fill_Up_Price__c, Apttus_Config2__NetPrice__c, APTS_Contract_Term__c,
                                                            APTS_Years_2_Plus_Default__c, APTS_Years_2_Plus_Adjustment__c, Apttus_Config2__Quantity__c, Apttus_Config2__BasePrice__c, APTS_Proposal_Group__c, APTS_Group__c, APTS_Bridge__c        
                                                            FROM Apttus_Config2__LineItem__c 
                                                            WHERE Id = :linObj4.Id];
        Apttus_Config2.CallbackTester.testValidationCallback
            ( cartID2
             , lineItemsList3
             , null
             , new APTS_Validation_Callback ()); 
        
        List<Apttus_Config2__LineItem__c> lineItemsList4 = [SELECT Id, Name, Apttus_Config2__ProductId__c, Apttus_Config2__ConfigurationId__c, Apttus_Config2__ConfigurationId__r.APTS_SSD_Sold_To__c, Apttus_Config2__LineNumber__c,
                                                            Apttus_Config2__ItemSequence__c, Apttus_Config2__LineType__c, Apttus_Config2__LineStatus__c, Apttus_Config2__PriceListItemId__r.APTS_Max_Fill_Up_Price__c, Apttus_Config2__NetPrice__c, APTS_Contract_Term__c,
                                                            APTS_Years_2_Plus_Default__c, APTS_Years_2_Plus_Adjustment__c, Apttus_Config2__Quantity__c, Apttus_Config2__BasePrice__c, APTS_Proposal_Group__c, APTS_Group__c, APTS_Bridge__c        
                                                            FROM Apttus_Config2__LineItem__c 
                                                            WHERE Id = :linObj5.Id]; 
        Apttus_Config2.CallbackTester.testValidationCallback
            ( cartID3
             , lineItemsList4
             , null
             , new APTS_Validation_Callback ()); 
        
        List<Apttus_Config2__LineItem__c> lineItemsList5 = [SELECT Id, Name, Apttus_Config2__ProductId__c, Apttus_Config2__ConfigurationId__c, Apttus_Config2__ConfigurationId__r.APTS_SSD_Sold_To__c, Apttus_Config2__LineNumber__c,
                                                            Apttus_Config2__ItemSequence__c, Apttus_Config2__LineType__c, Apttus_Config2__LineStatus__c, Apttus_Config2__PriceListItemId__r.APTS_Max_Fill_Up_Price__c, Apttus_Config2__NetPrice__c, APTS_Contract_Term__c,
                                                            APTS_Years_2_Plus_Default__c, APTS_Years_2_Plus_Adjustment__c, Apttus_Config2__Quantity__c, Apttus_Config2__BasePrice__c, APTS_Proposal_Group__c, APTS_Group__c, APTS_Bridge__c        
                                                            FROM Apttus_Config2__LineItem__c 
                                                            WHERE Id = :linObj6.Id]; 
        Apttus_Config2.CallbackTester.testValidationCallback
            ( cartID4
             , lineItemsList5
             , null
             , new APTS_Validation_Callback ());
             
        List<Apttus_Config2__LineItem__c> lineItemsList6 = [SELECT Id, Name, Apttus_Config2__ProductId__c, Apttus_Config2__ConfigurationId__c, Apttus_Config2__ConfigurationId__r.APTS_SSD_Sold_To__c, Apttus_Config2__LineNumber__c,
                                                            Apttus_Config2__ItemSequence__c, Apttus_Config2__LineType__c, Apttus_Config2__LineStatus__c, Apttus_Config2__PriceListItemId__r.APTS_Max_Fill_Up_Price__c, Apttus_Config2__NetPrice__c, APTS_Contract_Term__c,
                                                            APTS_Years_2_Plus_Default__c, APTS_Years_2_Plus_Adjustment__c, Apttus_Config2__Quantity__c, Apttus_Config2__BasePrice__c, APTS_Proposal_Group__c, APTS_Group__c, APTS_Bridge__c        
                                                            FROM Apttus_Config2__LineItem__c 
                                                            WHERE Id = :linObj7.Id]; 
        Apttus_Config2.CallbackTester.testValidationCallback
            ( cartID5
             , lineItemsList6
             , null
             , new APTS_Validation_Callback ());
        
        
        Test.stopTest();                                                    
    }
    @isTest static void testMethodForTaxProfcartvalidation1(){
        
        
        Apttus_Config2__PriceList__c priceList = APTS_TestDataFactory.createPriceList('Thomson Reuters Master - US Legal');
        insert priceList;
        
        List<KeyValueListStore__c> keyValueList=new List<KeyValueListStore__c>();
        KeyValueListStore__c keyvaluestore=new  KeyValueListStore__c();
        keyvaluestore.Name='ANZUsersProfileId';
        keyvaluestore.TextValue__c=System.Label.APTS_OC_Test_Id;
        keyValueList.add(keyvaluestore);
        KeyValueListStore__c keyval = new KeyValueListStore__c();
        keyval.Name='ReasonWithCompetitor';
        keyval.TextValue__c='Price';
        keyValueList.add(keyval);
        insert keyValueList;
        
        Schema.DescribeFieldResult fieldResultMarket = Apttus_Config2__ProductConfiguration__c.APTS_AccountMirror_Picklist__c.getDescribe();
        String valueMarket = fieldResultMarket.getPicklistValues().get(0).getValue();
        
        insertStaticValues();
        WebServiceSettings__c oWebServiceSettings = new WebServiceSettings__c();
        oWebServiceSettings.Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable'; 
        oWebServiceSettings.Name = 'PaymentCreditIncrease'; 
        oWebServiceSettings.Timeout__c = 120; 
        oWebServiceSettings.Endpoint__c = 'https://dev.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease'; 
        oWebServiceSettings.Active__c = true;
        insert oWebServiceSettings;
        
        
        List<RecordtypeIds__c> recordlist=new List<RecordtypeIds__c>();
        RecordtypeIds__c recordtype=new RecordtypeIds__c();
        recordtype.Name='Pre-Pipeline Opportunities';
        recordtype.recTypeId__c=System.Label.APTS_OC_Test_Id;
        recordlist.add(recordtype);
        
        RecordtypeIds__c recordtype1=new RecordtypeIds__c();
        recordtype1.Name='Pipeline Opportunities';
        recordtype1.recTypeId__c=System.Label.APTS_OC_Test_Id;
        recordlist.add(recordtype1);
        insert recordlist;
        
        Profile profileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        
        User CorpUser=new User(username='testuser23corp83@acme.com',
                               lastname='testuser',
                               Alias='testuser',
                               Email='testuser@tcs.com',
                               Sub_Bu__c='US',
                               TimeZoneSidKey = 'GMT',
                               ProfileId = profileId.id,
                               LanguageLocaleKey = 'en_US',
                               EmailEncodingKey = 'UTF-8',
                               LocaleSidKey = 'en_US',
                               Default_Catalog__c ='USL');
        insert CorpUser;
        
        Account a = APTS_TestDataFactory.createAccount('Test Account');
        a.FrozenMarketSegment__c = valueMarket;
        insert a;
        
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();
        Source_System_Detail__c accountSSD=APTS_TestDataFactory.createSourceSystem(a);
        accountSSD.RecordtypeId=ssdRecorType;
        accountSSD.Name='ABC';
        accountSSD.Source_System_Name__c='ABC';
        accountSSD.Account_Name__c=a.ID;
        accountSSD.LCRM_Frozen_Market_Segment__c = valueMarket;
        accountSSD.Account_Inactive__c=false;
        accountSSD.LCRM_Sales_Org__c='S100';
        insert accountSSD;
        
        Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        Opportunity oppty=APTS_TestDataFactory.createOpportunity('abc',a.id,'Needs Analysis',Date.Today());
        oppty.RecordtypeId=opptyRecorType;
        oppty.Source_System_Detail__c=accountSSD.id;
        oppty.Account=a;
        insert oppty;
        
        Apttus_Proposal__Proposal__c proposal = APTS_TestDataFactory.createProposal(oppty.id, accountSSD.Id);
        proposal.APTS_Proposal_Business_Unit__c = 'Tax Professional';    
        insert proposal;
        
        List<Apttus_Config2__ProductConfiguration__c> cartList = new List<Apttus_Config2__ProductConfiguration__c>();
        Apttus_Config2__ProductConfiguration__c prodConfig = APTS_TestDataFactory.createProductConfiguration(proposal.Id);
        cartList.add(prodConfig);
        Apttus_Config2__ProductConfiguration__c prodConfig1 = APTS_TestDataFactory.createProductConfiguration(proposal.Id);
        cartList.add(prodConfig1);
        Apttus_Config2__ProductConfiguration__c prodConfig2 = APTS_TestDataFactory.createProductConfiguration(proposal.Id);
        cartList.add(prodConfig2);
        insert cartList;
        
        ID cartID = prodConfig.Id;
        ID cartID1 = prodConfig1.Id;
        ID cartID2 = prodConfig2.Id;
        
        List<Product2> productsList=new List<Product2>();
        Product2 prodObj = new Product2();
        prodObj.Name = 'Network Services 1.0';
        prodObj.APTS_Media_Lower_Level_Code__c = '';
        prodObj.APTS_Availability_Date__c= Date.newInstance(2018, 1, 1);   
        productsList.add(prodObj);  
        Product2 prodObj1 = new Product2();
        prodObj1.Name = 'Network Services 2.0';
        prodObj1.APTS_Media_Lower_Level_Code__c = '';
        prodObj1.APTS_Availability_Date__c= Date.newInstance(2018, 1, 1);   
        productsList.add(prodObj1);
        insert productsList;
        
        Apttus_Config2__PriceListItem__c pliSO = new Apttus_Config2__PriceListItem__c();
        pliSO.Apttus_Config2__Active__c = true;
        pliSO.Apttus_Config2__PriceListId__c = priceList.Id;
        pliSO.APTS_Max_Fill_Up_Price__c = 5;
        insert pliSO;
        
        List<Apttus_Config2__LineItem__c> lineItemList=new List<Apttus_Config2__LineItem__c>();     
        Apttus_Config2__LineItem__c linObj1 = new Apttus_Config2__LineItem__c(
            Apttus_Config2__Quantity__c=7,
            Apttus_Config2__ProductId__c=prodObj1.id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Product/Service',
            Apttus_Config2__LineNumber__c = 1, 
            Apttus_Config2__ItemSequence__c = 1,
            Apttus_Config2__NetPrice__c=10.0,
            Apttus_Config2__BasePrice__c=10.0,
            Apttus_Config2__BaseExtendedPrice__c = 10.0,
            Apttus_Config2__AdjustedPrice__c = 10.0,
            Apttus_Config2__OptionPrice__c = 5.0,
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='4 Years',
            Apttus_Config2__ChargeType__c = 'Subscription Fee',          
            Apttus_Config2__LineStatus__c = 'New', 
            Apttus_Config2__PriceListItemId__c = pliSO.id,APTS_Term_Type__c = 'Co-Term',APTS_Bridge__c = '1 Month',Apttus_Config2__StartDate__c = System.Date.Today(),Apttus_Config2__EndDate__c = System.Date.Today().addmonths(10)); 
        lineItemList.add(linObj1);
        
        Apttus_Config2__LineItem__c linObj2 = new Apttus_Config2__LineItem__c(
            Apttus_Config2__Quantity__c=7,
            Apttus_Config2__ProductId__c=prodObj1.id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Product/Service',
            Apttus_Config2__LineNumber__c = 1, 
            Apttus_Config2__ItemSequence__c = 1,
            Apttus_Config2__NetPrice__c=10.0,
            Apttus_Config2__BasePrice__c=10.0,
            Apttus_Config2__BaseExtendedPrice__c = 10.0,
            Apttus_Config2__AdjustedPrice__c = 10.0,
            Apttus_Config2__OptionPrice__c = 5.0,
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='4 Years',
            Apttus_Config2__ChargeType__c = 'Subscription Fee',          
            Apttus_Config2__LineStatus__c = 'New', 
            Apttus_Config2__PriceListItemId__c = pliSO.id,APTS_Term_Type__c = 'Future Start Date and Co-Term',APTS_Bridge__c = '4 Months',Apttus_Config2__StartDate__c = System.Date.Today(),Apttus_Config2__EndDate__c = System.Date.Today().addmonths(10)); 
        lineItemList.add(linObj2);
        
        insert lineItemList;
        
        Test.startTest();
        
        List<Apttus_Config2__LineItem__c> lineItemsList1 = [SELECT Id, Name, Apttus_Config2__ProductId__c, Apttus_Config2__ConfigurationId__c, Apttus_Config2__ConfigurationId__r.APTS_SSD_Sold_To__c, Apttus_Config2__LineNumber__c,
                                                            Apttus_Config2__ItemSequence__c, Apttus_Config2__LineType__c, Apttus_Config2__LineStatus__c, Apttus_Config2__PriceListItemId__r.APTS_Max_Fill_Up_Price__c, Apttus_Config2__NetPrice__c, APTS_Contract_Term__c,
                                                            APTS_Years_2_Plus_Default__c, APTS_Years_2_Plus_Adjustment__c, Apttus_Config2__Quantity__c, Apttus_Config2__BasePrice__c, APTS_Proposal_Group__c, APTS_Group__c, APTS_Bridge__c,APTS_Term_Type__c,Apttus_Config2__StartDate__c,Apttus_Config2__EndDate__c,APTS_Proposal_Business_Unit__c       
                                                            FROM Apttus_Config2__LineItem__c 
                                                            WHERE Id = :linObj1.Id]; 
        Apttus_Config2.CallbackTester.testValidationCallback
            ( cartID
             , lineItemsList1
             , null
             , new APTS_Validation_Callback ());
        
        List<Apttus_Config2__LineItem__c> lineItemsList2 = [SELECT Id, Name, Apttus_Config2__ProductId__c, Apttus_Config2__ConfigurationId__c, Apttus_Config2__ConfigurationId__r.APTS_SSD_Sold_To__c, Apttus_Config2__LineNumber__c,
                                                            Apttus_Config2__ItemSequence__c, Apttus_Config2__LineType__c, Apttus_Config2__LineStatus__c, Apttus_Config2__PriceListItemId__r.APTS_Max_Fill_Up_Price__c, Apttus_Config2__NetPrice__c, APTS_Contract_Term__c,
                                                            APTS_Years_2_Plus_Default__c, APTS_Years_2_Plus_Adjustment__c, Apttus_Config2__Quantity__c, Apttus_Config2__BasePrice__c, APTS_Proposal_Group__c, APTS_Group__c, APTS_Bridge__c,APTS_Term_Type__c,Apttus_Config2__StartDate__c,Apttus_Config2__EndDate__c,APTS_Proposal_Business_Unit__c        
                                                            FROM Apttus_Config2__LineItem__c 
                                                            WHERE Id = :linObj2.Id]; 
        Apttus_Config2.CallbackTester.testValidationCallback
            ( cartID
             , lineItemsList2
             , null
             , new APTS_Validation_Callback ());
        
        Test.stopTest();                                                    
    }
    @isTest static void testMethodForTaxProfcartvalidation2(){
        
        
        Apttus_Config2__PriceList__c priceList = APTS_TestDataFactory.createPriceList('Thomson Reuters Master - US Legal');
        insert priceList;
        
        List<KeyValueListStore__c> keyValueList=new List<KeyValueListStore__c>();
        KeyValueListStore__c keyvaluestore=new  KeyValueListStore__c();
        keyvaluestore.Name='ANZUsersProfileId';
        keyvaluestore.TextValue__c=System.Label.APTS_OC_Test_Id;
        keyValueList.add(keyvaluestore);
        KeyValueListStore__c keyval = new KeyValueListStore__c();
        keyval.Name='ReasonWithCompetitor';
        keyval.TextValue__c='Price';
        keyValueList.add(keyval);
        insert keyValueList;
        
        Schema.DescribeFieldResult fieldResultMarket = Apttus_Config2__ProductConfiguration__c.APTS_AccountMirror_Picklist__c.getDescribe();
        String valueMarket = fieldResultMarket.getPicklistValues().get(0).getValue();
        
        insertStaticValues();
        WebServiceSettings__c oWebServiceSettings = new WebServiceSettings__c();
        oWebServiceSettings.Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable'; 
        oWebServiceSettings.Name = 'PaymentCreditIncrease'; 
        oWebServiceSettings.Timeout__c = 120; 
        oWebServiceSettings.Endpoint__c = 'https://dev.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease'; 
        oWebServiceSettings.Active__c = true;
        insert oWebServiceSettings;
        
        
        List<RecordtypeIds__c> recordlist=new List<RecordtypeIds__c>();
        RecordtypeIds__c recordtype=new RecordtypeIds__c();
        recordtype.Name='Pre-Pipeline Opportunities';
        recordtype.recTypeId__c=System.Label.APTS_OC_Test_Id;
        recordlist.add(recordtype);
        
        RecordtypeIds__c recordtype1=new RecordtypeIds__c();
        recordtype1.Name='Pipeline Opportunities';
        recordtype1.recTypeId__c=System.Label.APTS_OC_Test_Id;
        recordlist.add(recordtype1);
        insert recordlist;
        
        Profile profileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        
        User CorpUser=new User(username='testuser23corp83@acme.com',
                               lastname='testuser',
                               Alias='testuser',
                               Email='testuser@tcs.com',
                               Sub_Bu__c='US',
                               TimeZoneSidKey = 'GMT',
                               ProfileId = profileId.id,
                               LanguageLocaleKey = 'en_US',
                               EmailEncodingKey = 'UTF-8',
                               LocaleSidKey = 'en_US',
                               Default_Catalog__c ='USL');
        insert CorpUser;
        
        Account a = APTS_TestDataFactory.createAccount('Test Account');
        a.FrozenMarketSegment__c = valueMarket;
        insert a;
        
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();
        Source_System_Detail__c accountSSD=APTS_TestDataFactory.createSourceSystem(a);
        accountSSD.RecordtypeId=ssdRecorType;
        accountSSD.Name='ABC';
        accountSSD.Source_System_Name__c='ABC';
        accountSSD.Account_Name__c=a.ID;
        accountSSD.LCRM_Frozen_Market_Segment__c = valueMarket;
        accountSSD.Account_Inactive__c=false;
        accountSSD.LCRM_Sales_Org__c='S100';
        insert accountSSD;
        
        Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        Opportunity oppty=APTS_TestDataFactory.createOpportunity('abc',a.id,'Needs Analysis',Date.Today());
        oppty.RecordtypeId=opptyRecorType;
        oppty.Source_System_Detail__c=accountSSD.id;
        oppty.Account=a;
        insert oppty;
        
        Apttus_Proposal__Proposal__c proposal = APTS_TestDataFactory.createProposal(oppty.id, accountSSD.Id);
        proposal.APTS_Proposal_Business_Unit__c = 'Tax Professional';    
        insert proposal;
        
        List<Apttus_Config2__ProductConfiguration__c> cartList = new List<Apttus_Config2__ProductConfiguration__c>();
        Apttus_Config2__ProductConfiguration__c prodConfig = APTS_TestDataFactory.createProductConfiguration(proposal.Id);
        cartList.add(prodConfig);
        Apttus_Config2__ProductConfiguration__c prodConfig1 = APTS_TestDataFactory.createProductConfiguration(proposal.Id);
        cartList.add(prodConfig1);
        Apttus_Config2__ProductConfiguration__c prodConfig2 = APTS_TestDataFactory.createProductConfiguration(proposal.Id);
        cartList.add(prodConfig2);
        insert cartList;
        
        ID cartID = prodConfig.Id;
        ID cartID1 = prodConfig1.Id;
        ID cartID2 = prodConfig2.Id;
        
        List<Product2> productsList=new List<Product2>();
        Product2 prodObj = new Product2();
        prodObj.Name = 'Network Services 1.0';
        prodObj.APTS_Media_Lower_Level_Code__c = '';
        prodObj.APTS_Availability_Date__c= Date.newInstance(2018, 1, 1);   
        productsList.add(prodObj);  
        Product2 prodObj1 = new Product2();
        prodObj1.Name = 'Network Services 2.0';
        prodObj1.APTS_Media_Lower_Level_Code__c = '';
        prodObj1.APTS_Availability_Date__c= Date.newInstance(2018, 1, 1);   
        productsList.add(prodObj1);
        insert productsList;
        
        Apttus_Config2__PriceListItem__c pliSO = new Apttus_Config2__PriceListItem__c();
        pliSO.Apttus_Config2__Active__c = true;
        pliSO.Apttus_Config2__PriceListId__c = priceList.Id;
        pliSO.APTS_Max_Fill_Up_Price__c = 5;
        insert pliSO;
        
        List<Apttus_Config2__LineItem__c> lineItemList=new List<Apttus_Config2__LineItem__c>();     
        
        Apttus_Config2__LineItem__c linObj1 = new Apttus_Config2__LineItem__c(
            Apttus_Config2__Quantity__c=7,
            Apttus_Config2__ProductId__c=prodObj1.id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Product/Service',
            Apttus_Config2__LineNumber__c = 1, 
            Apttus_Config2__ItemSequence__c = 1,
            Apttus_Config2__NetPrice__c=10.0,
            Apttus_Config2__BasePrice__c=10.0,
            Apttus_Config2__BaseExtendedPrice__c = 10.0,
            Apttus_Config2__AdjustedPrice__c = 10.0,
            Apttus_Config2__OptionPrice__c = 5.0,
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='4 Years',
            Apttus_Config2__ChargeType__c = 'Subscription Fee',          
            Apttus_Config2__LineStatus__c = 'New', 
            Apttus_Config2__PriceListItemId__c = pliSO.id,APTS_Term_Type__c = 'Future Start Date and Co-Term',APTS_Bridge__c = '10 Months',Apttus_Config2__StartDate__c = System.Date.Today(),Apttus_Config2__EndDate__c = System.Date.Today().addmonths(15)); 
        lineItemList.add(linObj1);
        
        Apttus_Config2__LineItem__c linObj2 = new Apttus_Config2__LineItem__c(
            Apttus_Config2__Quantity__c=7,
            Apttus_Config2__ProductId__c=prodObj1.id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Product/Service',
            Apttus_Config2__LineNumber__c = 1, 
            Apttus_Config2__ItemSequence__c = 1,
            Apttus_Config2__NetPrice__c=10.0,
            Apttus_Config2__BasePrice__c=10.0,
            Apttus_Config2__BaseExtendedPrice__c = 10.0,
            Apttus_Config2__AdjustedPrice__c = 10.0,
            Apttus_Config2__OptionPrice__c = 5.0,
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='4 Years',
            Apttus_Config2__ChargeType__c = 'Subscription Fee',          
            Apttus_Config2__LineStatus__c = 'New', 
            Apttus_Config2__PriceListItemId__c = pliSO.id,APTS_Term_Type__c = 'Future Start Date and Co-Term',APTS_Bridge__c = NULL,Apttus_Config2__StartDate__c = System.Date.Today(),Apttus_Config2__EndDate__c = System.Date.Today().addmonths(15)); 
        lineItemList.add(linObj2);
        
        insert lineItemList;
        
        Test.startTest();
        
        List<Apttus_Config2__LineItem__c> lineItemsList1 = [SELECT Id, Name, Apttus_Config2__ProductId__c, Apttus_Config2__ConfigurationId__c, Apttus_Config2__ConfigurationId__r.APTS_SSD_Sold_To__c, Apttus_Config2__LineNumber__c,
                                                            Apttus_Config2__ItemSequence__c, Apttus_Config2__LineType__c, Apttus_Config2__LineStatus__c, Apttus_Config2__PriceListItemId__r.APTS_Max_Fill_Up_Price__c, Apttus_Config2__NetPrice__c, APTS_Contract_Term__c,
                                                            APTS_Years_2_Plus_Default__c, APTS_Years_2_Plus_Adjustment__c, Apttus_Config2__Quantity__c, Apttus_Config2__BasePrice__c, APTS_Proposal_Group__c, APTS_Group__c, APTS_Bridge__c,APTS_Term_Type__c,Apttus_Config2__StartDate__c,Apttus_Config2__EndDate__c,APTS_Proposal_Business_Unit__c       
                                                            FROM Apttus_Config2__LineItem__c 
                                                            WHERE Id = :linObj1.Id]; 
        Apttus_Config2.CallbackTester.testValidationCallback
            ( cartID
             , lineItemsList1
             , null
             , new APTS_Validation_Callback ());
        
        List<Apttus_Config2__LineItem__c> lineItemsList2 = [SELECT Id, Name, Apttus_Config2__ProductId__c, Apttus_Config2__ConfigurationId__c, Apttus_Config2__ConfigurationId__r.APTS_SSD_Sold_To__c, Apttus_Config2__LineNumber__c,
                                                            Apttus_Config2__ItemSequence__c, Apttus_Config2__LineType__c, Apttus_Config2__LineStatus__c, Apttus_Config2__PriceListItemId__r.APTS_Max_Fill_Up_Price__c, Apttus_Config2__NetPrice__c, APTS_Contract_Term__c,
                                                            APTS_Years_2_Plus_Default__c, APTS_Years_2_Plus_Adjustment__c, Apttus_Config2__Quantity__c, Apttus_Config2__BasePrice__c, APTS_Proposal_Group__c, APTS_Group__c, APTS_Bridge__c,APTS_Term_Type__c,Apttus_Config2__StartDate__c,Apttus_Config2__EndDate__c,APTS_Proposal_Business_Unit__c        
                                                            FROM Apttus_Config2__LineItem__c 
                                                            WHERE Id = :linObj2.Id]; 
        Apttus_Config2.CallbackTester.testValidationCallback
            ( cartID
             , lineItemsList2
             , null
             , new APTS_Validation_Callback ()); 
        
        Test.stopTest();                                                    
    } 
    
    @isTest static void testMethodForTaxProfcartvalidation3(){        
        
        Apttus_Config2__PriceList__c priceList = APTS_TestDataFactory.createPriceList('Thomson Reuters Master - US Legal');
        insert priceList;
        
        List<KeyValueListStore__c> keyValueList=new List<KeyValueListStore__c>();
        KeyValueListStore__c keyvaluestore=new  KeyValueListStore__c();
        keyvaluestore.Name='ANZUsersProfileId';
        keyvaluestore.TextValue__c=System.Label.APTS_OC_Test_Id;
        keyValueList.add(keyvaluestore);
        KeyValueListStore__c keyval = new KeyValueListStore__c();
        keyval.Name='ReasonWithCompetitor';
        keyval.TextValue__c='Price';
        keyValueList.add(keyval);
        insert keyValueList;
        
        Schema.DescribeFieldResult fieldResultMarket = Apttus_Config2__ProductConfiguration__c.APTS_AccountMirror_Picklist__c.getDescribe();
        String valueMarket = fieldResultMarket.getPicklistValues().get(0).getValue();
        
        insertStaticValues();
        WebServiceSettings__c oWebServiceSettings = new WebServiceSettings__c();
        oWebServiceSettings.Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable'; 
        oWebServiceSettings.Name = 'PaymentCreditIncrease'; 
        oWebServiceSettings.Timeout__c = 120; 
        oWebServiceSettings.Endpoint__c = 'https://dev.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease'; 
        oWebServiceSettings.Active__c = true;
        insert oWebServiceSettings;
        
        List<RecordtypeIds__c> recordlist=new List<RecordtypeIds__c>();
        RecordtypeIds__c recordtype=new RecordtypeIds__c();
        recordtype.Name='Pre-Pipeline Opportunities';
        recordtype.recTypeId__c=System.Label.APTS_OC_Test_Id;
        recordlist.add(recordtype);
        
        RecordtypeIds__c recordtype1=new RecordtypeIds__c();
        recordtype1.Name='Pipeline Opportunities';
        recordtype1.recTypeId__c=System.Label.APTS_OC_Test_Id;
        recordlist.add(recordtype1);
        insert recordlist;
        
        Profile profileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        
        User CorpUser=new User(username='testuser23corp83@acme.com',
                               lastname='testuser',
                               Alias='testuser',
                               Email='testuser@tcs.com',
                               Sub_Bu__c='US',
                               TimeZoneSidKey = 'GMT',
                               ProfileId = profileId.id,
                               LanguageLocaleKey = 'en_US',
                               EmailEncodingKey = 'UTF-8',
                               LocaleSidKey = 'en_US',
                               Default_Catalog__c ='USL');
        insert CorpUser;
        
        Account a = APTS_TestDataFactory.createAccount('Test Account');
        a.FrozenMarketSegment__c = valueMarket;
        insert a;
        
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();
        Source_System_Detail__c accountSSD=APTS_TestDataFactory.createSourceSystem(a);
        accountSSD.RecordtypeId=ssdRecorType;
        accountSSD.Name='ABC';
        accountSSD.Source_System_Name__c='ABC';
        accountSSD.Account_Name__c=a.ID;
        accountSSD.LCRM_Frozen_Market_Segment__c = valueMarket;
        accountSSD.Account_Inactive__c=false;
        accountSSD.LCRM_Sales_Org__c='S100';
        insert accountSSD;
        
        Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        Opportunity oppty=APTS_TestDataFactory.createOpportunity('abc',a.id,'Needs Analysis',Date.Today());
        oppty.RecordtypeId=opptyRecorType;
        oppty.Source_System_Detail__c=accountSSD.id;
        oppty.Account=a;
        insert oppty;
        
        Apttus_Proposal__Proposal__c proposal = APTS_TestDataFactory.createProposal(oppty.id, accountSSD.Id);
        proposal.APTS_Proposal_Business_Unit__c = 'Tax Professional';    
        insert proposal;
        
        List<Apttus_Config2__ProductConfiguration__c> cartList = new List<Apttus_Config2__ProductConfiguration__c>();
        Apttus_Config2__ProductConfiguration__c prodConfig = APTS_TestDataFactory.createProductConfiguration(proposal.Id);
        cartList.add(prodConfig);
        Apttus_Config2__ProductConfiguration__c prodConfig1 = APTS_TestDataFactory.createProductConfiguration(proposal.Id);
        cartList.add(prodConfig1);
        Apttus_Config2__ProductConfiguration__c prodConfig2 = APTS_TestDataFactory.createProductConfiguration(proposal.Id);
        cartList.add(prodConfig2);
        insert cartList;
        
        ID cartID = prodConfig.Id;
        ID cartID1 = prodConfig1.Id;
        ID cartID2 = prodConfig2.Id;
        
        List<Product2> productsList=new List<Product2>();
        Product2 prodObj = new Product2();
        prodObj.Name = 'Network Services 1.0';
        prodObj.APTS_Media_Lower_Level_Code__c = '';
        prodObj.APTS_Availability_Date__c= Date.newInstance(2018, 1, 1);   
        productsList.add(prodObj);  
        Product2 prodObj1 = new Product2();
        prodObj1.Name = 'Network Services 2.0';
        prodObj1.APTS_Media_Lower_Level_Code__c = '';
        prodObj1.APTS_Availability_Date__c= Date.newInstance(2018, 1, 1);   
        productsList.add(prodObj1);
        insert productsList;
        
        Apttus_Config2__PriceListItem__c pliSO = new Apttus_Config2__PriceListItem__c();
        pliSO.Apttus_Config2__Active__c = true;
        pliSO.Apttus_Config2__PriceListId__c = priceList.Id;
        pliSO.APTS_Max_Fill_Up_Price__c = 5;
        insert pliSO;
        
        List<Apttus_Config2__LineItem__c> lineItemList=new List<Apttus_Config2__LineItem__c>();     
        
        Apttus_Config2__LineItem__c linObj1 = new Apttus_Config2__LineItem__c(
            Apttus_Config2__Quantity__c=7,
            Apttus_Config2__ProductId__c=prodObj1.id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Product/Service',
            Apttus_Config2__LineNumber__c = 1, 
            Apttus_Config2__ItemSequence__c = 1,
            Apttus_Config2__NetPrice__c=10.0,
            Apttus_Config2__BasePrice__c=10.0,
            Apttus_Config2__BaseExtendedPrice__c = 10.0,
            Apttus_Config2__AdjustedPrice__c = 10.0,
            Apttus_Config2__OptionPrice__c = 5.0,
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='4 Years',
            Apttus_Config2__ChargeType__c = 'Subscription Fee',          
            Apttus_Config2__LineStatus__c = 'New', 
            Apttus_Config2__PriceListItemId__c = pliSO.id,APTS_Term_Type__c = 'Future Start Date and Co-Term',APTS_Bridge__c = '',Apttus_Config2__StartDate__c = System.Date.Today(),Apttus_Config2__EndDate__c = System.Date.Today().addmonths(15)); 
        lineItemList.add(linObj1);
        
        Apttus_Config2__LineItem__c linObj2 = new Apttus_Config2__LineItem__c(
            Apttus_Config2__Quantity__c=7,
            Apttus_Config2__ProductId__c=prodObj1.id,
            Apttus_Config2__ConfigurationId__c = prodConfig1.id, 
            Apttus_Config2__LineType__c = 'Product/Service',
            Apttus_Config2__LineNumber__c = 1, 
            Apttus_Config2__ItemSequence__c = 1,
            Apttus_Config2__NetPrice__c=10.0,
            Apttus_Config2__BasePrice__c=10.0,
            Apttus_Config2__BaseExtendedPrice__c = 10.0,
            Apttus_Config2__AdjustedPrice__c = 10.0,
            Apttus_Config2__OptionPrice__c = 5.0,
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='4 Years',
            Apttus_Config2__ChargeType__c = 'Subscription Fee',          
            Apttus_Config2__LineStatus__c = 'New', 
            Apttus_Config2__PriceListItemId__c = pliSO.id,APTS_Term_Type__c = 'Future Start Date and Co-Term',APTS_Bridge__c = '4 Months',Apttus_Config2__StartDate__c = System.Date.Today(),Apttus_Config2__EndDate__c = System.Date.Today().addmonths(15)); 
        lineItemList.add(linObj2);
        
        Apttus_Config2__LineItem__c linObj3 = new Apttus_Config2__LineItem__c(
            Apttus_Config2__Quantity__c=7,
            Apttus_Config2__ProductId__c=prodObj1.id,
            Apttus_Config2__ConfigurationId__c = prodConfig2.id, 
            Apttus_Config2__LineType__c = 'Product/Service',
            Apttus_Config2__LineNumber__c = 3, 
            Apttus_Config2__ItemSequence__c = 3,
            Apttus_Config2__NetPrice__c=10.0,
            Apttus_Config2__BasePrice__c=10.0,
            Apttus_Config2__BaseExtendedPrice__c = 10.0,
            Apttus_Config2__AdjustedPrice__c = 10.0,
            Apttus_Config2__OptionPrice__c = 5.0,
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='4 Years',
            Apttus_Config2__ChargeType__c = 'Subscription Fee',          
            Apttus_Config2__LineStatus__c = 'New', 
            Apttus_Config2__PriceListItemId__c = pliSO.id,APTS_Term_Type__c = 'Future Start Date and Co-Term',APTS_Bridge__c = '14 Days',
            APTS_Bridge_Eligibility__c = 'Yes',
            Apttus_Config2__StartDate__c = System.Date.Today(),Apttus_Config2__EndDate__c = System.Date.Today().addmonths(15)); 
        lineItemList.add(linObj3);
        
        insert lineItemList;
        
        Test.startTest();
        
        List<Apttus_Config2__LineItem__c> lineItemsList1 = [SELECT Id, Name, Apttus_Config2__ProductId__c, Apttus_Config2__ConfigurationId__c, Apttus_Config2__ConfigurationId__r.APTS_SSD_Sold_To__c, Apttus_Config2__LineNumber__c,
                                                            Apttus_Config2__ItemSequence__c, Apttus_Config2__LineType__c, Apttus_Config2__LineStatus__c, Apttus_Config2__PriceListItemId__r.APTS_Max_Fill_Up_Price__c, Apttus_Config2__NetPrice__c, APTS_Contract_Term__c,
                                                            APTS_Years_2_Plus_Default__c, APTS_Years_2_Plus_Adjustment__c, Apttus_Config2__Quantity__c, Apttus_Config2__BasePrice__c, APTS_Proposal_Group__c, APTS_Group__c, APTS_Bridge__c,APTS_Term_Type__c,Apttus_Config2__StartDate__c,Apttus_Config2__EndDate__c,APTS_Proposal_Business_Unit__c       
                                                            FROM Apttus_Config2__LineItem__c 
                                                            WHERE Id = :linObj1.Id]; 
        Apttus_Config2.CallbackTester.testValidationCallback
            ( cartID
             , lineItemsList1
             , null
             , new APTS_Validation_Callback ());
        
        List<Apttus_Config2__LineItem__c> lineItemsList2 = [SELECT Id, Name, Apttus_Config2__ProductId__c, Apttus_Config2__ConfigurationId__c, Apttus_Config2__ConfigurationId__r.APTS_SSD_Sold_To__c, Apttus_Config2__LineNumber__c,
                                                            Apttus_Config2__ItemSequence__c, Apttus_Config2__LineType__c, Apttus_Config2__LineStatus__c, Apttus_Config2__PriceListItemId__r.APTS_Max_Fill_Up_Price__c, Apttus_Config2__NetPrice__c, APTS_Contract_Term__c,
                                                            APTS_Years_2_Plus_Default__c, APTS_Years_2_Plus_Adjustment__c, Apttus_Config2__Quantity__c, Apttus_Config2__BasePrice__c, APTS_Proposal_Group__c, APTS_Group__c, APTS_Bridge__c,APTS_Term_Type__c,Apttus_Config2__StartDate__c,Apttus_Config2__EndDate__c,APTS_Proposal_Business_Unit__c        
                                                            FROM Apttus_Config2__LineItem__c 
                                                            WHERE Apttus_Config2__ConfigurationId__c = : prodConfig2.id]; 
        Apttus_Config2.CallbackTester.testValidationCallback
            ( cartID1
             , lineItemsList2
             , null
             , new APTS_Validation_Callback ()); 
        
        Test.stopTest();                                                    
    }    
        
     @isTest static void testMethodTaxProf_BridgeMonthVal(){       
        
        Apttus_Config2__PriceList__c priceList = APTS_TestDataFactory.createPriceList('Thomson Reuters Master - US Legal');
        insert priceList;
        
        List<KeyValueListStore__c> keyValueList=new List<KeyValueListStore__c>();
        KeyValueListStore__c keyvaluestore=new  KeyValueListStore__c();
        keyvaluestore.Name='ANZUsersProfileId';
        keyvaluestore.TextValue__c=System.Label.APTS_OC_Test_Id;
        keyValueList.add(keyvaluestore);
        KeyValueListStore__c keyval = new KeyValueListStore__c();
        keyval.Name='ReasonWithCompetitor';
        keyval.TextValue__c='Price';
        keyValueList.add(keyval);
        insert keyValueList;
        
        Schema.DescribeFieldResult fieldResultMarket = Apttus_Config2__ProductConfiguration__c.APTS_AccountMirror_Picklist__c.getDescribe();
        String valueMarket = fieldResultMarket.getPicklistValues().get(0).getValue();
        
        insertStaticValues();
        WebServiceSettings__c oWebServiceSettings = new WebServiceSettings__c();
        oWebServiceSettings.Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable'; 
        oWebServiceSettings.Name = 'PaymentCreditIncrease'; 
        oWebServiceSettings.Timeout__c = 120; 
        oWebServiceSettings.Endpoint__c = 'https://dev.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease'; 
        oWebServiceSettings.Active__c = true;
        insert oWebServiceSettings;
        
        List<RecordtypeIds__c> recordlist=new List<RecordtypeIds__c>();
        RecordtypeIds__c recordtype=new RecordtypeIds__c();
        recordtype.Name='Pre-Pipeline Opportunities';
        recordtype.recTypeId__c=System.Label.APTS_OC_Test_Id;
        recordlist.add(recordtype);
        
        RecordtypeIds__c recordtype1=new RecordtypeIds__c();
        recordtype1.Name='Pipeline Opportunities';
        recordtype1.recTypeId__c=System.Label.APTS_OC_Test_Id;
        recordlist.add(recordtype1);
        insert recordlist;
        
        Profile profileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        
        User CorpUser=new User(username='testuser23corp83@acme.com',
                               lastname='testuser',
                               Alias='testuser',
                               Email='testuser@tcs.com',
                               Sub_Bu__c='US',
                               TimeZoneSidKey = 'GMT',
                               ProfileId = profileId.id,
                               LanguageLocaleKey = 'en_US',
                               EmailEncodingKey = 'UTF-8',
                               LocaleSidKey = 'en_US',
                               Default_Catalog__c ='USL');
        insert CorpUser;
        
        Account a = APTS_TestDataFactory.createAccount('Test Account');
        a.FrozenMarketSegment__c = valueMarket;
        insert a;
        
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();
        Source_System_Detail__c accountSSD=APTS_TestDataFactory.createSourceSystem(a);
        accountSSD.RecordtypeId=ssdRecorType;
        accountSSD.Name='ABC';
        accountSSD.Source_System_Name__c='ABC';
        accountSSD.Account_Name__c=a.ID;
        accountSSD.LCRM_Frozen_Market_Segment__c = valueMarket;
        accountSSD.Account_Inactive__c=false;
        accountSSD.LCRM_Sales_Org__c='S100';
        insert accountSSD;
        
        Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        Opportunity oppty=APTS_TestDataFactory.createOpportunity('abc',a.id,'Needs Analysis',Date.Today());
        oppty.RecordtypeId=opptyRecorType;
        oppty.Source_System_Detail__c=accountSSD.id;
        oppty.Account=a;
        insert oppty;
        
        Apttus_Proposal__Proposal__c proposal = APTS_TestDataFactory.createProposal(oppty.id, accountSSD.Id);
        proposal.APTS_Proposal_Business_Unit__c = 'Tax Professional'; 
        insert proposal;
        
        List<Apttus_Config2__ProductConfiguration__c> cartList = new List<Apttus_Config2__ProductConfiguration__c>();
        Apttus_Config2__ProductConfiguration__c prodConfig = APTS_TestDataFactory.createProductConfiguration(proposal.Id);
        cartList.add(prodConfig);        
        insert cartList;
        
        ID cartID = prodConfig.Id;
               
        List<Product2> productsList=new List<Product2>();
        Product2 prodObj = new Product2();
        prodObj.Name = 'Network Services 1.0';
        prodObj.APTS_Media_Lower_Level_Code__c = '';
        prodObj.APTS_Availability_Date__c= Date.newInstance(2018, 1, 1);   
        productsList.add(prodObj);  
        Product2 prodObj1 = new Product2();
        prodObj1.Name = 'Network Services 2.0';
        prodObj1.APTS_Media_Lower_Level_Code__c = '';
        prodObj1.APTS_Availability_Date__c= Date.newInstance(2018, 1, 1);   
        productsList.add(prodObj1);
        insert productsList;
        
        Apttus_Config2__PriceListItem__c pliSO = new Apttus_Config2__PriceListItem__c();
        pliSO.Apttus_Config2__Active__c = true;
        pliSO.Apttus_Config2__PriceListId__c = priceList.Id;
        pliSO.APTS_Max_Fill_Up_Price__c = 5;
        insert pliSO;
        
        List<Apttus_Config2__LineItem__c> lineItemList=new List<Apttus_Config2__LineItem__c>();     
        Apttus_Config2__LineItem__c linObj2 = new Apttus_Config2__LineItem__c(
            
            Apttus_Config2__Quantity__c=7,
            Apttus_Config2__ProductId__c=prodObj1.id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Product/Service',
            Apttus_Config2__LineNumber__c = 1, 
            Apttus_Config2__ItemSequence__c = 1,
            Apttus_Config2__NetPrice__c=10.0,
            Apttus_Config2__BasePrice__c=10.0,
            APTS_Yr_2_Amount__c=15.0,
            Apttus_Config2__BaseExtendedPrice__c = 10.0,
            Apttus_Config2__AdjustedPrice__c = 10.0,
            Apttus_Config2__OptionPrice__c = 5.0,
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='5 Years',
            Apttus_Config2__ChargeType__c = 'Standard Fee',          
            Apttus_Config2__LineStatus__c = 'New', 
            APTS_Bridge__c = '14 Days',APTS_Bridge_Eligibility__c = 'Yes',
            Apttus_Config2__PriceListItemId__c = pliSO.id); 
        lineItemList.add(linObj2);
        
        insert lineItemList;
        
        Test.startTest();
        
        List<Apttus_Config2__LineItem__c> lineItemsList1 = [SELECT Id, Name, Apttus_Config2__ProductId__c, Apttus_Config2__ConfigurationId__c, Apttus_Config2__ConfigurationId__r.APTS_SSD_Sold_To__c, Apttus_Config2__LineNumber__c,
                                                            Apttus_Config2__ItemSequence__c, Apttus_Config2__LineType__c, Apttus_Config2__LineStatus__c, Apttus_Config2__PriceListItemId__r.APTS_Max_Fill_Up_Price__c, Apttus_Config2__NetPrice__c, APTS_Contract_Term__c,
                                                            APTS_Years_2_Plus_Default__c, APTS_Years_2_Plus_Adjustment__c, Apttus_Config2__Quantity__c, Apttus_Config2__BasePrice__c, APTS_Proposal_Group__c, APTS_Group__c, APTS_Bridge__c        
                                                            FROM Apttus_Config2__LineItem__c 
                                                            WHERE Id = :linObj2.Id];   
        Apttus_Config2.CallbackTester.testValidationCallback
            ( cartID
             , lineItemsList1
             , null
             , new APTS_Validation_Callback ());  
        Test.stopTest();                                                    
    }
    
    @isTest static void testMethodCorpUS5(){
        Apttus_Config2__PriceList__c priceList = APTS_TestDataFactory.createPriceList('Thomson Reuters Master - US Legal');
        insert priceList;
        
        List<KeyValueListStore__c> keyValueList=new List<KeyValueListStore__c>();
        KeyValueListStore__c keyvaluestore=new  KeyValueListStore__c();
        keyvaluestore.Name='ANZUsersProfileId';
        keyvaluestore.TextValue__c=System.Label.APTS_OC_Test_Id;
        keyValueList.add(keyvaluestore);
        KeyValueListStore__c keyval = new KeyValueListStore__c();
        keyval.Name='ReasonWithCompetitor';
        keyval.TextValue__c='Price';
        keyValueList.add(keyval);
        insert keyValueList;
        
        Schema.DescribeFieldResult fieldResultMarket = Apttus_Config2__ProductConfiguration__c.APTS_AccountMirror_Picklist__c.getDescribe();
        String valueMarket = fieldResultMarket.getPicklistValues().get(0).getValue();
        
        insertStaticValues();
        WebServiceSettings__c oWebServiceSettings = new WebServiceSettings__c();
        oWebServiceSettings.Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable'; 
        oWebServiceSettings.Name = 'PaymentCreditIncrease'; 
        oWebServiceSettings.Timeout__c = 120; 
        oWebServiceSettings.Endpoint__c = 'https://dev.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease'; 
        oWebServiceSettings.Active__c = true;
        insert oWebServiceSettings;
        
        
        
        List<RecordtypeIds__c> recordlist=new List<RecordtypeIds__c>();
        RecordtypeIds__c recordtype=new RecordtypeIds__c();
        recordtype.Name='Pre-Pipeline Opportunities';
        recordtype.recTypeId__c=System.Label.APTS_OC_Test_Id;
        recordlist.add(recordtype);
        
        RecordtypeIds__c recordtype1=new RecordtypeIds__c();
        recordtype1.Name='Pipeline Opportunities';
        recordtype1.recTypeId__c=System.Label.APTS_OC_Test_Id;
        recordlist.add(recordtype1);
        insert recordlist;
        
        Profile profileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        
        User CorpUser=new User(username='testuser23corp1@acme.com',
                               lastname='testuser',
                               Alias='testuser',
                               Email='testuser@tcs.com',
                               Sub_Bu__c='US',
                               Segment__c ='Global',
                               TimeZoneSidKey = 'GMT',
                               ProfileId = profileId.id,
                               LanguageLocaleKey = 'en_US',
                               EmailEncodingKey = 'UTF-8',
                               LocaleSidKey = 'en_US',
                               Default_Catalog__c ='USL');
        insert CorpUser;
        
        Account a = APTS_TestDataFactory.createAccount('Test Account');
        a.FrozenMarketSegment__c = valueMarket;
        insert a;
        
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();
        Source_System_Detail__c accountSSD=APTS_TestDataFactory.createSourceSystem(a);
        accountSSD.RecordtypeId=ssdRecorType;
        accountSSD.Name='ABC';
        accountSSD.Source_System_Name__c='ABC';
        accountSSD.Account_Name__c=a.ID;
        accountSSD.LCRM_Frozen_Market_Segment__c = valueMarket;
        accountSSD.Account_Inactive__c=false;
        accountSSD.LCRM_Sales_Org__c='TA78';
        insert accountSSD;
        
        Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        Opportunity oppty=APTS_TestDataFactory.createOpportunity('abc',a.id,'Needs Analysis',Date.Today());
        oppty.RecordtypeId=opptyRecorType;
        oppty.Source_System_Detail__c=accountSSD.id;
        oppty.Account=a;
        insert oppty;
        
        /*Apttus_Proposal__Proposal__c proposal = APTS_TestDataFactory.createProposal(oppty.id, accountSSD.Id);
        proposal.APTS_Proposal_Business_Unit__c = 'Corp OneOTC US';    
        System.runAs(CorpUser) {
            insert proposal;
        }  */  
        Id devRecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Proposal').getRecordTypeId();
        Apttus_Proposal__Proposal__c proposal = new Apttus_Proposal__Proposal__c(
            RecordTypeId=devRecordTypeId, 
            Apttus_Proposal__Proposal_Name__c='testproposal',
            Apttus_Proposal__Account__c = a.id, 
            Apttus_Proposal__Opportunity__c=oppty.id, 
            Apttus_Proposal__Approval_Stage__c='Draft', 
            Apttus_Proposal__Proposal_Category__c='Quote', 
            Apttus_Proposal__ReadyToGenerate__c = true, 
            Apttus_Proposal__ReadyToPresent__c= true, 
            Apttus_QPConfig__PriceListId__c=priceList.id,
            APTS_SSD_Sold_To__c = accountSSD.Id,
            APTS_Proposal_Business_Unit__c = 'Corp OneOTC US'           
        );
        insert proposal;
        
        Apttus_Config2__ProductConfiguration__c prodConfig = APTS_TestDataFactory.createProductConfiguration(proposal.Id);
        insert prodConfig;
        ID cartID = prodConfig.Id;
        
        Product2 prodObj = new Product2();
        prodObj.Name = 'Network Services 1.0';
        prodObj.APTS_Media_Lower_Level_Code__c = '2Q';
        prodObj.APTS_Availability_Date__c= Date.newInstance(2018, 1, 1);   
        prodObj.APTS_FL_Renewal_Only_Clone__c = 'No'; 
        insert prodObj; 
        
        Apttus_Config2__PriceListItem__c pliSO = new Apttus_Config2__PriceListItem__c();
        pliSO.Apttus_Config2__Active__c = true;
        pliSO.Apttus_Config2__PriceListId__c = priceList.Id;
        pliSO.APTS_Max_Fill_Up_Price__c = 5;
        insert pliSO;
        
        Apttus_Config2__LineItem__c linObj = new Apttus_Config2__LineItem__c(
            Apttus_Config2__Quantity__c=7,
            Apttus_Config2__ProductId__c=prodObj.id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Product/Service',
            Apttus_Config2__LineNumber__c = 1, 
            Apttus_Config2__ItemSequence__c = 1,
            Apttus_Config2__NetPrice__c=10.0,
            Apttus_Config2__BasePrice__c=10.0,
            Apttus_Config2__BaseExtendedPrice__c = 10.0,
            Apttus_Config2__AdjustedPrice__c = 10.0,
            Apttus_Config2__OptionPrice__c = 5.0,
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='5 Years',
            Apttus_Config2__ChargeType__c = 'Subscription Fee',          
            Apttus_Config2__LineStatus__c = 'New',   
            /*APTS_Term_Type__c = 'Delivery Date',*/
            APTS_Yr_2_Amount__c = 15.0,
            Apttus_Config2__PriceListItemId__c = pliSO.id); 
        
        insert linObj;
        
        APTS_ConfigBundlePageSettings__c bundlePageSettings = new APTS_ConfigBundlePageSettings__c();
        bundlePageSettings.Name = 'Bundle Page Properties';
        bundlePageSettings.Banded_Products_MLL__c = '2Q,49,72,BA,J9,L2,LB,M4,P7,Q3,WA,LB,PX';
        insert bundlePageSettings;
        
        List<Apttus_Config2__LineItem__c> lineItemsList = [SELECT Id, Name, Apttus_Config2__ProductId__c, Apttus_Config2__ProductId__r.APTS_FL_Renewal_Only_Clone__c,
                                                           APTS_Proposal_Group__c,APTS_Renewal_Type__c,APTS_Proposal_Business_Unit__c,APTS_Term_Type__c,APTS_Start_Date__c,
                                                           Apttus_Config2__LineType__c, Apttus_Config2__LineStatus__c, APTS_Contract_Term__c,APTS_Contract_Term_Number__c,APTS_Yr_2_Amount__c
                                                           FROM Apttus_Config2__LineItem__c 
                                                           WHERE Id = :linObj.Id];      
        
        System.debug('RK --> Year2 = '+lineItemsList.get(0).APTS_Yr_2_Amount__c+'\n Contract Term No. = '+lineItemsList.get(0).APTS_Contract_Term_Number__c);  
        System.debug('RK --> 2 Proposal BU '+lineItemsList.get(0).APTS_Proposal_Business_Unit__c);
                                   
        
        Test.startTest();
        Apttus_Config2.CallbackTester.testValidationCallback
            ( cartID
             , lineItemsList
             , null
             , new APTS_Validation_Callback ());   
        Test.stopTest();                                              
    }
     @isTest static void testMethodSCSCan5(){
        Apttus_Config2__PriceList__c priceList = APTS_TestDataFactory.createPriceList('Thomson Reuters Master - US Legal');
        insert priceList;
        
        List<KeyValueListStore__c> keyValueList=new List<KeyValueListStore__c>();
        KeyValueListStore__c keyvaluestore=new  KeyValueListStore__c();
        keyvaluestore.Name='ANZUsersProfileId';
        keyvaluestore.TextValue__c=System.Label.APTS_OC_Test_Id;
        keyValueList.add(keyvaluestore);
        KeyValueListStore__c keyval = new KeyValueListStore__c();
        keyval.Name='ReasonWithCompetitor';
        keyval.TextValue__c='Price';
        keyValueList.add(keyval);
        insert keyValueList;
        
        Schema.DescribeFieldResult fieldResultMarket = Apttus_Config2__ProductConfiguration__c.APTS_AccountMirror_Picklist__c.getDescribe();
        String valueMarket = fieldResultMarket.getPicklistValues().get(0).getValue();
        
        insertStaticValues();
        WebServiceSettings__c oWebServiceSettings = new WebServiceSettings__c();
        oWebServiceSettings.Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable'; 
        oWebServiceSettings.Name = 'PaymentCreditIncrease'; 
        oWebServiceSettings.Timeout__c = 120; 
        oWebServiceSettings.Endpoint__c = 'https://dev.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease'; 
        oWebServiceSettings.Active__c = true;
        insert oWebServiceSettings;
        
        
        
        List<RecordtypeIds__c> recordlist=new List<RecordtypeIds__c>();
        RecordtypeIds__c recordtype=new RecordtypeIds__c();
        recordtype.Name='Pre-Pipeline Opportunities';
        recordtype.recTypeId__c=System.Label.APTS_OC_Test_Id;
        recordlist.add(recordtype);
        
        RecordtypeIds__c recordtype1=new RecordtypeIds__c();
        recordtype1.Name='Pipeline Opportunities';
        recordtype1.recTypeId__c=System.Label.APTS_OC_Test_Id;
        recordlist.add(recordtype1);
        insert recordlist;
        
        Profile profileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        
        User CorpUser=new User(username='testuser23corp1@acme.com',
                               lastname='testuser',
                               Alias='testuser',
                               Email='testuser@tcs.com',
                               Sub_Bu__c='US',
                               Segment__c ='Global',
                               TimeZoneSidKey = 'GMT',
                               ProfileId = profileId.id,
                               LanguageLocaleKey = 'en_US',
                               EmailEncodingKey = 'UTF-8',
                               LocaleSidKey = 'en_US',
                               Default_Catalog__c ='USL');
        insert CorpUser;
        
        Account a = APTS_TestDataFactory.createAccount('Test Account');
        a.FrozenMarketSegment__c = valueMarket;
        insert a;
        
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();
        Source_System_Detail__c accountSSD=APTS_TestDataFactory.createSourceSystem(a);
        accountSSD.RecordtypeId=ssdRecorType;
        accountSSD.Name='ABC';
        accountSSD.Source_System_Name__c='ABC';
        accountSSD.Account_Name__c=a.ID;
        accountSSD.LCRM_Frozen_Market_Segment__c = valueMarket;
        accountSSD.Account_Inactive__c=false;
        accountSSD.LCRM_Sales_Org__c='WEST';
        insert accountSSD;
        
        Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        Opportunity oppty=APTS_TestDataFactory.createOpportunity('abc',a.id,'Needs Analysis',Date.Today());
        oppty.RecordtypeId=opptyRecorType;
        oppty.Source_System_Detail__c=accountSSD.id;
        oppty.Account=a;
        insert oppty;
        
        /*Apttus_Proposal__Proposal__c proposal = APTS_TestDataFactory.createProposal(oppty.id, accountSSD.Id);
        proposal.APTS_Proposal_Business_Unit__c = 'Corp OneOTC US';    
        System.runAs(CorpUser) {
            insert proposal;
        }  */  
        Id devRecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Proposal').getRecordTypeId();
        Apttus_Proposal__Proposal__c proposal = new Apttus_Proposal__Proposal__c(
            RecordTypeId=devRecordTypeId, 
            Apttus_Proposal__Proposal_Name__c='testproposal',
            Apttus_Proposal__Account__c = a.id, 
            Apttus_Proposal__Opportunity__c=oppty.id, 
            Apttus_Proposal__Approval_Stage__c='Draft', 
            Apttus_Proposal__Proposal_Category__c='Quote', 
            Apttus_Proposal__ReadyToGenerate__c = true, 
            Apttus_Proposal__ReadyToPresent__c= true, 
            Apttus_QPConfig__PriceListId__c=priceList.id,
            APTS_SSD_Sold_To__c = accountSSD.Id,
            APTS_Proposal_Business_Unit__c = 'Corp OneOTC US'           
        );
        insert proposal;
        
        Apttus_Config2__ProductConfiguration__c prodConfig = APTS_TestDataFactory.createProductConfiguration(proposal.Id);
        insert prodConfig;
        ID cartID = prodConfig.Id;
        
        Product2 prodObj = new Product2();
        prodObj.Name = 'Network Services 1.0';
        prodObj.APTS_Media_Lower_Level_Code__c = '2Q';
        prodObj.APTS_Availability_Date__c= Date.newInstance(2018, 1, 1);   
        prodObj.APTS_FL_Renewal_Only_Clone__c = 'No'; 
        insert prodObj; 
        
        Apttus_Config2__PriceListItem__c pliSO = new Apttus_Config2__PriceListItem__c();
        pliSO.Apttus_Config2__Active__c = true;
        pliSO.Apttus_Config2__PriceListId__c = priceList.Id;
        pliSO.APTS_Max_Fill_Up_Price__c = 5;
        insert pliSO;
        
        Apttus_Config2__LineItem__c linObj = new Apttus_Config2__LineItem__c(
            Apttus_Config2__Quantity__c=7,
            Apttus_Config2__ProductId__c=prodObj.id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Product/Service',
            Apttus_Config2__LineNumber__c = 1, 
            Apttus_Config2__ItemSequence__c = 1,
            Apttus_Config2__NetPrice__c=10.0,
            Apttus_Config2__BasePrice__c=10.0,
            Apttus_Config2__BaseExtendedPrice__c = 10.0,
            Apttus_Config2__AdjustedPrice__c = 10.0,
            Apttus_Config2__OptionPrice__c = 5.0,
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='5 Years',
            Apttus_Config2__ChargeType__c = 'Subscription Fee',          
            Apttus_Config2__LineStatus__c = 'New',   
            /*APTS_Term_Type__c = 'Delivery Date',*/
            APTS_Yr_2_Amount__c = 15.0,
            Apttus_Config2__PriceListItemId__c = pliSO.id); 
        
        insert linObj;
        
        APTS_ConfigBundlePageSettings__c bundlePageSettings = new APTS_ConfigBundlePageSettings__c();
        bundlePageSettings.Name = 'Bundle Page Properties';
        bundlePageSettings.Banded_Products_MLL__c = '2Q,49,72,BA,J9,L2,LB,M4,P7,Q3,WA,LB,PX';
        insert bundlePageSettings;
        
        List<Apttus_Config2__LineItem__c> lineItemsList = [SELECT Id, Name, Apttus_Config2__ProductId__c, Apttus_Config2__ProductId__r.APTS_FL_Renewal_Only_Clone__c,
                                                           APTS_Proposal_Group__c,APTS_Renewal_Type__c,APTS_Proposal_Business_Unit__c,APTS_Term_Type__c,APTS_Start_Date__c,
                                                           Apttus_Config2__LineType__c, Apttus_Config2__LineStatus__c, APTS_Contract_Term__c,APTS_Contract_Term_Number__c,APTS_Yr_2_Amount__c
                                                           FROM Apttus_Config2__LineItem__c 
                                                           WHERE Id = :linObj.Id];      
        
        System.debug('RK --> Year2 = '+lineItemsList.get(0).APTS_Yr_2_Amount__c+'\n Contract Term No. = '+lineItemsList.get(0).APTS_Contract_Term_Number__c);  
        System.debug('RK --> 2 Proposal BU '+lineItemsList.get(0).APTS_Proposal_Business_Unit__c);
                                   
        
        Test.startTest();
        Apttus_Config2.CallbackTester.testValidationCallback
            ( cartID
             , lineItemsList
             , null
             , new APTS_Validation_Callback ());   
        Test.stopTest();                                              
    }
    @isTest static void testMethodSCSCan3(){
        Apttus_Config2__PriceList__c priceList = APTS_TestDataFactory.createPriceList('Thomson Reuters Master - US Legal');
        insert priceList;
        
        List<KeyValueListStore__c> keyValueList=new List<KeyValueListStore__c>();
        KeyValueListStore__c keyvaluestore=new  KeyValueListStore__c();
        keyvaluestore.Name='ANZUsersProfileId';
        keyvaluestore.TextValue__c=System.Label.APTS_OC_Test_Id;
        keyValueList.add(keyvaluestore);
        KeyValueListStore__c keyval = new KeyValueListStore__c();
        keyval.Name='ReasonWithCompetitor';
        keyval.TextValue__c='Price';
        keyValueList.add(keyval);
        insert keyValueList;
        
        Schema.DescribeFieldResult fieldResultMarket = Apttus_Config2__ProductConfiguration__c.APTS_AccountMirror_Picklist__c.getDescribe();
        String valueMarket = fieldResultMarket.getPicklistValues().get(0).getValue();
        
        insertStaticValues();
        WebServiceSettings__c oWebServiceSettings = new WebServiceSettings__c();
        oWebServiceSettings.Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable'; 
        oWebServiceSettings.Name = 'PaymentCreditIncrease'; 
        oWebServiceSettings.Timeout__c = 120; 
        oWebServiceSettings.Endpoint__c = 'https://dev.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease'; 
        oWebServiceSettings.Active__c = true;
        insert oWebServiceSettings;
        
        
        
        List<RecordtypeIds__c> recordlist=new List<RecordtypeIds__c>();
        RecordtypeIds__c recordtype=new RecordtypeIds__c();
        recordtype.Name='Pre-Pipeline Opportunities';
        recordtype.recTypeId__c=System.Label.APTS_OC_Test_Id;
        recordlist.add(recordtype);
        
        RecordtypeIds__c recordtype1=new RecordtypeIds__c();
        recordtype1.Name='Pipeline Opportunities';
        recordtype1.recTypeId__c=System.Label.APTS_OC_Test_Id;
        recordlist.add(recordtype1);
        insert recordlist;
        
        Profile profileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        
        User CorpUser=new User(username='testuser23corp1@acme.com',
                               lastname='testuser',
                               Alias='testuser',
                               Email='testuser@tcs.com',
                               Sub_Bu__c='US',
                               Segment__c ='Global',
                               TimeZoneSidKey = 'GMT',
                               ProfileId = profileId.id,
                               LanguageLocaleKey = 'en_US',
                               EmailEncodingKey = 'UTF-8',
                               LocaleSidKey = 'en_US',
                               Default_Catalog__c ='USL');
        insert CorpUser;
        
        Account a = APTS_TestDataFactory.createAccount('Test Account');
        a.FrozenMarketSegment__c = valueMarket;
        insert a;
        
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();
        Source_System_Detail__c accountSSD=APTS_TestDataFactory.createSourceSystem(a);
        accountSSD.RecordtypeId=ssdRecorType;
        accountSSD.Name='ABC';
        accountSSD.Source_System_Name__c='ABC';
        accountSSD.Account_Name__c=a.ID;
        accountSSD.LCRM_Frozen_Market_Segment__c = valueMarket;
        accountSSD.Account_Inactive__c=false;
        accountSSD.LCRM_Sales_Org__c='WEST';
        insert accountSSD;
        
        Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        Opportunity oppty=APTS_TestDataFactory.createOpportunity('abc',a.id,'Needs Analysis',Date.Today());
        oppty.RecordtypeId=opptyRecorType;
        oppty.Source_System_Detail__c=accountSSD.id;
        oppty.Account=a;
        insert oppty;
        
        /*Apttus_Proposal__Proposal__c proposal = APTS_TestDataFactory.createProposal(oppty.id, accountSSD.Id);
        proposal.APTS_Proposal_Business_Unit__c = 'Corp OneOTC US';    
        System.runAs(CorpUser) {
            insert proposal;
        }  */  
        Id devRecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Proposal').getRecordTypeId();
        Apttus_Proposal__Proposal__c proposal = new Apttus_Proposal__Proposal__c(
            RecordTypeId=devRecordTypeId, 
            Apttus_Proposal__Proposal_Name__c='testproposal',
            Apttus_Proposal__Account__c = a.id, 
            Apttus_Proposal__Opportunity__c=oppty.id, 
            Apttus_Proposal__Approval_Stage__c='Draft', 
            Apttus_Proposal__Proposal_Category__c='Quote', 
            Apttus_Proposal__ReadyToGenerate__c = true, 
            Apttus_Proposal__ReadyToPresent__c= true, 
            Apttus_QPConfig__PriceListId__c=priceList.id,
            APTS_SSD_Sold_To__c = accountSSD.Id,
            APTS_Proposal_Business_Unit__c = 'Corp OneOTC US'           
        );
        insert proposal;
        
        Apttus_Config2__ProductConfiguration__c prodConfig = APTS_TestDataFactory.createProductConfiguration(proposal.Id);
        insert prodConfig;
        ID cartID = prodConfig.Id;
        
        Product2 prodObj = new Product2();
        prodObj.Name = 'Network Services 1.0';
        prodObj.APTS_Media_Lower_Level_Code__c = '2Q';
        prodObj.APTS_Availability_Date__c= Date.newInstance(2018, 1, 1);   
        prodObj.APTS_FL_Renewal_Only_Clone__c = 'No'; 
        insert prodObj; 
        
        Apttus_Config2__PriceListItem__c pliSO = new Apttus_Config2__PriceListItem__c();
        pliSO.Apttus_Config2__Active__c = true;
        pliSO.Apttus_Config2__PriceListId__c = priceList.Id;
        pliSO.APTS_Max_Fill_Up_Price__c = 5;
        insert pliSO;
        
        Apttus_Config2__LineItem__c linObj = new Apttus_Config2__LineItem__c(
            Apttus_Config2__Quantity__c=7,
            Apttus_Config2__ProductId__c=prodObj.id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Product/Service',
            Apttus_Config2__LineNumber__c = 1, 
            Apttus_Config2__ItemSequence__c = 1,
            Apttus_Config2__NetPrice__c=10.0,
            Apttus_Config2__BasePrice__c=10.0,
            Apttus_Config2__BaseExtendedPrice__c = 10.0,
            Apttus_Config2__AdjustedPrice__c = 10.0,
            Apttus_Config2__OptionPrice__c = 5.0,
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',
            Apttus_Config2__ChargeType__c = 'Subscription Fee',          
            Apttus_Config2__LineStatus__c = 'New',   
            /*APTS_Term_Type__c = 'Delivery Date',*/
            APTS_Yr_2_Amount__c = 15.0,
            APTS_Years_2_Plus_Adjustment__c = '5',
            Apttus_Config2__PriceListItemId__c = pliSO.id); 
        
        insert linObj;
        
        APTS_ConfigBundlePageSettings__c bundlePageSettings = new APTS_ConfigBundlePageSettings__c();
        bundlePageSettings.Name = 'Bundle Page Properties';
        bundlePageSettings.Banded_Products_MLL__c = '2Q,49,72,BA,J9,L2,LB,M4,P7,Q3,WA,LB,PX';
        insert bundlePageSettings;
        
        List<Apttus_Config2__LineItem__c> lineItemsList = [SELECT Id, Name, Apttus_Config2__ProductId__c, Apttus_Config2__ProductId__r.APTS_FL_Renewal_Only_Clone__c,
                                                           APTS_Proposal_Group__c,APTS_Renewal_Type__c,APTS_Proposal_Business_Unit__c,APTS_Term_Type__c,APTS_Start_Date__c,
                                                           Apttus_Config2__LineType__c, Apttus_Config2__LineStatus__c, APTS_Contract_Term__c,APTS_Contract_Term_Number__c,APTS_Yr_2_Amount__c
                                                           FROM Apttus_Config2__LineItem__c 
                                                           WHERE Id = :linObj.Id];      
        
        System.debug('RK --> Year2 = '+lineItemsList.get(0).APTS_Yr_2_Amount__c+'\n Contract Term No. = '+lineItemsList.get(0).APTS_Contract_Term_Number__c);  
        System.debug('RK --> 2 Proposal BU '+lineItemsList.get(0).APTS_Proposal_Business_Unit__c);
                                   
        
        Test.startTest();
        Apttus_Config2.CallbackTester.testValidationCallback
            ( cartID
             , lineItemsList
             , null
             , new APTS_Validation_Callback ());   
        Test.stopTest();                                              
    }    
}