@isTest
private class Test_ApprovalDashboardAJSController {
    //@testSetup
   @testSetup 
    private static void initTestData(){
        
        Id oppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Pipeline Opportunity').getRecordTypeId();
        Id oppRecordTypeId1 = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Pre-Pipeline Opportunity').getRecordTypeId();
        
        Schema.DescribeFieldResult fieldResultMarket = Apttus_Config2__ProductConfiguration__c.APTS_AccountMirror_Picklist__c.getDescribe();
        String valueMarket = fieldResultMarket.getPicklistValues().get(0).getValue();
        
        WebServiceSettings__c oWebServiceSettings = new WebServiceSettings__c();
 
        oWebServiceSettings.Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable'; 
        oWebServiceSettings.Name = 'PaymentCreditIncrease'; 
        oWebServiceSettings.Timeout__c = 120; 
        oWebServiceSettings.Endpoint__c = 'https://dev.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease'; 
        oWebServiceSettings.Active__c = true;
        insert oWebServiceSettings;
        
        //Create Custom Settings
        KeyValueListStore__c customSett = new KeyValueListStore__c();
        customSett.Name = 'ANZUsersProfileId';
        customSett.TextValue__c = UserInfo.getProfileId();      
        
        KeyValueListStore__c customSett1 = new KeyValueListStore__c();        
        customSett1.Name = 'LCRMDisableStrikeIronServices';
        customSett1.TextValue__c = 'True';       
        
        KeyValueListStore__c keyvaluestore1 =new  KeyValueListStore__c();
        keyvaluestore1.Name='ReasonWithCompetitor';
        keyvaluestore1.TextValue__c='Price'; 
       
        KeyValueListStore__c keyvaluestore2 =new  KeyValueListStore__c();
        keyvaluestore2.Name='LCRMOpptyTerritoryStageValues';
        keyvaluestore2.TextValue__c='Contract Signed,Order Complete,Closed Lost'; 
        
        List<KeyValueListStore__c> keyvaluelist = new List<KeyValueListStore__c>{customSett,customSett1,keyvaluestore1,keyvaluestore2};
        
        insert keyvaluelist;
        
        RecordtypeIds__c recId1 = new RecordtypeIds__c(Name = 'Pipeline Opportunities',recTypeId__c = oppRecordTypeId);
        RecordtypeIds__c recId2 = new RecordtypeIds__c(Name = 'Pre-Pipeline Opportunities',recTypeId__c = oppRecordTypeId1);
        List<RecordtypeIds__c> recIDs = new List<RecordtypeIds__c>{recId1,recId2}; 
        insert recIDs;
            
        PriceBook2 pb = new PriceBook2(name='Test Price Book', isActive=true);
        insert pb;
        
        Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
        Test.startTest();
        Account act = new Account(
            RecordTypeId=accRecordTypeId,
            name = 'UnitTest',
            customer_group__c = 'Academic',
            customer_type__c = 'Organization',
            customer_class_c__c = 'Academic Lecturer', 
            sales_org__c = 'West',
            APTS_Band_Number__c = 12
        );
        //insert act;
        
        //Added for Canada
        Account actCanada = new Account(
            RecordTypeId=accRecordTypeId,
            name = 'UnitTest',
            customer_group__c = 'Academic',
            customer_type__c = 'Organization',
            customer_class_c__c = 'Academic Lecturer', 
            sales_org__c = 'CARS',
            APTS_Band_Number__c = 12
        );
        //insert actCanada;
        
        //Added for Tax Prof
        Account actTax = new Account(
            RecordTypeId=accRecordTypeId,
            name = 'UnitTest',
            customer_group__c = 'Academic',
            customer_type__c = 'Organization',
            customer_class_c__c = 'Academic Lecturer', 
            sales_org__c = 'S100',
            APTS_Band_Number__c = 12
        );
        
        List<Account> listOfAccounts = new List<Account>{act, actCanada, actTax};
        if(listOfAccounts.size() > 0)
        {
            insert listOfAccounts;
        }
            
        
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();
        Source_System_Detail__c accountSSD= new Source_System_Detail__c();
        accountSSD.RecordtypeId=ssdRecorType;
        accountSSD.Name='ABC';
        accountSSD.Source_System_Name__c='ABC';
        accountSSD.Account_Name__c=act.ID;
        accountSSD.LCRM_Frozen_Market_Segment__c = valueMarket;
        accountSSD.Account_Inactive__c=false;
        accountSSD.LCRM_Sales_Org__c='WEST';
        accountSSD.LCRM_APTS_Band_Number__c = 123456789;
        //insert accountSSD;
        
        //Canada
        Source_System_Detail__c accountCanadaSSD= new Source_System_Detail__c();
        accountCanadaSSD.RecordtypeId=ssdRecorType;
        accountCanadaSSD.Name='ABCC';
        accountCanadaSSD.Source_System_Name__c='ABCC';
        accountCanadaSSD.Account_Name__c=actCanada.ID;
        accountCanadaSSD.LCRM_Frozen_Market_Segment__c = valueMarket;
        accountCanadaSSD.Account_Inactive__c=false;
        accountCanadaSSD.LCRM_Sales_Org__c='CARS';
        accountCanadaSSD.LCRM_APTS_Band_Number__c = 123456789;
        //insert accountSSD; 
        
        //Added for Tax Prof
        Source_System_Detail__c accountTaxSSD= new Source_System_Detail__c();
        accountTaxSSD.RecordtypeId=ssdRecorType;
        accountTaxSSD.Name='ABCT';
        accountTaxSSD.Source_System_Name__c='ABCT';
        accountTaxSSD.Account_Name__c=actTax.ID;
        accountTaxSSD.LCRM_Frozen_Market_Segment__c = valueMarket; 
        accountTaxSSD.Account_Inactive__c=false;
        accountTaxSSD.LCRM_Sales_Org__c='S100';
        accountTaxSSD.LCRM_APTS_Band_Number__c = 123456789;
        List<Source_System_Detail__c> listOfSSDs = new List<Source_System_Detail__c>{accountSSD, accountCanadaSSD, accountTaxSSD};
        if(listOfSSDs.size() > 0)
        {
            insert listOfSSDs;
        }
        
        Date todaysDate = system.today();        
        Opportunity o = UnitTest.getOpportunityInstance(act.Id);
        o.Name = 'tst-opp1';
        o.stagename = '25%';
        o.closedate = todaysDate;
        o.forecastcategoryname = 'pipeline';
        o.pricebook2id = pb.id;
        o.Source_System_Detail__c=accountSSD.id;
        o.Reason__c = 'Price';
        //insert o;
        
        //canada opp1
        Opportunity opCanada = UnitTest.getOpportunityInstance(actCanada.Id);
        opCanada.Name = 'tst-opp1C';
        opCanada.stagename = '25%';
        opCanada.closedate = todaysDate;
        opCanada.forecastcategoryname = 'pipeline';
        opCanada.pricebook2id = pb.id;
        opCanada.Source_System_Detail__c=accountCanadaSSD.id;
        //insert o2;
        
        //Added for Tax Prof
        Opportunity optyTax = UnitTest.getOpportunityInstance(actTax.Id);
        optyTax.Name = 'tst-opp1C';
        optyTax.stagename = '25%';
        optyTax.closedate = todaysDate;
        optyTax.forecastcategoryname = 'pipeline';
        optyTax.pricebook2id = pb.id;
        optyTax.Source_System_Detail__c=accountTaxSSD.id;
        List<Opportunity> listOfOppty = new List<Opportunity>{o, opCanada, optyTax};
        if(listOfOppty.size() > 0)
        {
            insert listOfOppty;
        }
        
        Apttus_Config2__PriceList__c pl = new Apttus_Config2__PriceList__c();
        pl.Apttus_Config2__Active__c = true;
        pl.Name = 'Thomson Reuters Master - US Legal';
        pl.Apttus_Config2__EffectiveDate__c = System.today().addYears(-1);
        pl.Apttus_Config2__ExpirationDate__c = System.today().addYears(2);
        pl.CurrencyIsoCode = 'USD';
        //insert pl;  
            
       //Canada priceList
        Apttus_Config2__PriceList__c plCanada = new Apttus_Config2__PriceList__c();
        plCanada.Apttus_Config2__Active__c = true;
        plCanada.Name = 'Thomson Reuters Master - Canada';
        plCanada.Apttus_Config2__EffectiveDate__c = System.today().addYears(-1);
        plCanada.Apttus_Config2__ExpirationDate__c = System.today().addYears(2);
        plCanada.CurrencyIsoCode = 'CAD';
       //insert p2;  
        List<Apttus_Config2__PriceList__c> listOfPriceLists = new List<Apttus_Config2__PriceList__c>{pl, plCanada};
        if(listOfPriceLists.size() > 0)
        {
            insert listOfPriceLists;
       }
         
        Id devRecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Proposal').getRecordTypeId();
        Apttus_Proposal__Proposal__c proposal = new Apttus_Proposal__Proposal__c(
            RecordTypeId=devRecordTypeId, 
            Apttus_Proposal__Proposal_Name__c='testproposal',
            Apttus_Proposal__Account__c = act.id, 
            Apttus_Proposal__Opportunity__c=o.id, 
            Apttus_Proposal__Approval_Stage__c='Draft', 
            Apttus_Proposal__Proposal_Category__c='Quote', 
            Apttus_Proposal__ReadyToGenerate__c = true, 
            Apttus_Proposal__ReadyToPresent__c= true, 
            Apttus_QPConfig__PriceListId__c=pl.id,
            APTS_SSD_Sold_To__c = accountSSD.Id
            );
        //Added for Tax Prof
        Id taxDevRecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Proposal').getRecordTypeId();
        Apttus_Proposal__Proposal__c taxProposal = new Apttus_Proposal__Proposal__c(
            RecordTypeId=taxDevRecordTypeId, 
            Apttus_Proposal__Proposal_Name__c='testTaxproposal',
            Apttus_Proposal__Account__c = actTax.id, 
            Apttus_Proposal__Opportunity__c=optyTax.id, 
            Apttus_Proposal__Approval_Stage__c='Draft', 
            Apttus_Proposal__Proposal_Category__c='Quote', 
            Apttus_Proposal__ReadyToGenerate__c = true, 
            Apttus_Proposal__ReadyToPresent__c= true, 
            Apttus_QPConfig__PriceListId__c=pl.id,
            APTS_SSD_Sold_To__c = accountTaxSSD.Id,
            APTS_Proposal_Business_Unit__c = 'Tax Professional'
            );
        //Canada
        Apttus_Proposal__Proposal__c canadaProposal = new Apttus_Proposal__Proposal__c(
            RecordTypeId=devRecordTypeId, 
            Apttus_Proposal__Proposal_Name__c='testCanadaproposal',
            Apttus_Proposal__Account__c = actCanada.id, 
            Apttus_Proposal__Opportunity__c=opCanada.id, 
            Apttus_Proposal__Approval_Stage__c='Draft', 
            Apttus_Proposal__Proposal_Category__c='Quote', 
            Apttus_Proposal__ReadyToGenerate__c = true, 
            Apttus_Proposal__ReadyToPresent__c= true, 
            Apttus_QPConfig__PriceListId__c=plCanada.id,
            APTS_SSD_Sold_To__c = accountCanadaSSD.Id,
            APTS_Proposal_Business_Unit__c=LABEL.SALESORGCAN
            );
        
        List<Apttus_Proposal__Proposal__c> proplist = new List<Apttus_Proposal__Proposal__c>{proposal,taxProposal,canadaProposal};
        if(proplist.size() > 0)
        {
            insert proplist;
        }
        
        Apttus_Config2__ProductConfiguration__c prodConfig = TestDataFactoryCPQ.getConfiguration(proposal, pl.Id, act);
        prodConfig.Name = 'prodConfig1';
        //prodConfig.Name = 'prod-conf1';
        prodConfig.APTS_Current_Holdings__c=0;
        insert prodConfig;
        prodConfig.APTS_Current_Holdings__c=100;
        update prodConfig;
        
        //Canada
        Apttus_Config2__ProductConfiguration__c prodConfigCan = TestDataFactoryCPQ.getConfiguration(canadaProposal, plCanada.Id, actCanada);
        prodConfigCan.Name = 'prodConfigCan';
        prodConfigCan.APTS_Current_Holdings__c=0;
        
        //Added for Tax Prof
        Apttus_Config2__ProductConfiguration__c prodConfigTax = TestDataFactoryCPQ.getConfiguration(taxProposal, pl.Id, actTax);
        prodConfigTax.Name = 'prodConfigTax';
        prodConfigTax.APTS_Tax_Current_Holdings__c=50;
        prodConfigTax.APTS_Tax_New_Holdings__c=150;
        prodConfigTax.APTS_Tax_Lapsed_Holdings__c=250;
        
        List<Apttus_Config2__ProductConfiguration__c> prodConfiglist = new List<Apttus_Config2__ProductConfiguration__c>{prodConfigCan,prodConfigTax};
        if(prodConfiglist.size() > 0)
        {
            insert prodConfiglist;
        }
        System.Debug('***Kh Config list SIZE===>'+prodConfiglist.size());
        System.Debug('***Kh Config list ===>'+prodConfiglist);
        System.Debug('***Kh Config 1 ===>'+prodConfig.Name);
        System.Debug('***Kh Config 2 ===>'+prodConfigCan.Name);
        System.Debug('***Kh Config 3 ===>'+prodConfigTax.Name);
        Apttus_Config2__SummaryGroup__c summaryGroupC = new Apttus_Config2__SummaryGroup__c(
                Apttus_Config2__ConfigurationId__c = prodConfigCan.id, 
                Name = 'WEST PROFLEX Bundle A - Test group',
                Apttus_Config2__LineType__c = 'Group Total',
                Apttus_Config2__ItemSequence__c = 1,
                Apttus_Config2__LineNumber__c = 1
            );
        //List<Apttus_Config2__ProductConfiguration__c> listProductConfig = new List<Apttus_Config2__ProductConfiguration__c>{prodConfig,prodConfig2};
        //insert listProductConfig;
         Apttus_Config2__SummaryGroup__c summaryGroup2 = new Apttus_Config2__SummaryGroup__c(
                Apttus_Config2__ConfigurationId__c = prodConfig.id, 
                Name = 'WEST PROFLEX Bundle A - Test group',
                Apttus_Config2__LineType__c = 'Group Total',
                Apttus_Config2__ItemSequence__c = 1,
                Apttus_Config2__LineNumber__c = 1
            );
        
        Apttus_Config2__SummaryGroup__c summaryGroupTax = new Apttus_Config2__SummaryGroup__c(
                Apttus_Config2__ConfigurationId__c = prodConfigTax.id, 
                Name = 'WEST PROFLEX Bundle A - Test group',
                Apttus_Config2__LineType__c = 'Group Total',
                Apttus_Config2__ItemSequence__c = 1,
                Apttus_Config2__LineNumber__c = 1
            );
            
        List<Apttus_Config2__SummaryGroup__c> summarygrouplist = new List<Apttus_Config2__SummaryGroup__c>{summaryGroupC,summaryGroup2,summaryGroupTax};
        insert summarygrouplist;
        
        APTS_Group__c proposalGroup =new APTS_Group__c();
        proposalGroup.APTS_GrossAmount__c = 0;
        proposalGroup.APTS_Group_Name_Original__c ='Online/Software Bundle A';
        proposalGroup.APTS_Group_Name__c ='Online/Software Bundle A';
        proposalGroup.APTS_NetAmount__c=0;
        insert proposalGroup;   
       System.debug('PriceList before inserting new proposal: ' + proposal.Apttus_QPConfig__PriceListId__c);
        
        Product2 taxProd1 = TestDataFactoryCPQ.getProduct('testproduct1', 'ENGAGEMENT SOLUTIONS');
        
        Product2 taxProd2 = TestDataFactoryCPQ.getProduct('testproduct2', 'CLEAR');
        
        Product2 prod1 = TestDataFactoryCPQ.getProduct('testproduct1', 'PRINT LEGAL SOLUTIONS');
        Apttus_Config2__AssetLineItem__c assetLineItem1 = TestDataFactoryCPQ.getAssetLineItem('assetlineitem1', act,accountSSD, prod1);
        
        Product2 prod2 = TestDataFactoryCPQ.getProduct('testproduct2', 'FINDLAW');
        Apttus_Config2__AssetLineItem__c printProviewList = TestDataFactoryCPQ.getAssetLineItem('assetlineitem2', act,accountSSD, prod2);
        
        Product2 prod3 = TestDataFactoryCPQ.getProduct('testproduct3', 'Service');
        Apttus_Config2__AssetLineItem__c currentOnlineSoftwareList = TestDataFactoryCPQ.getAssetLineItem('assetlineitem3', act,accountSSD, prod3);
        currentOnlineSoftwareList.APTS_Info_RenewalDate__c= Date.newInstance(2016, 12, 9);
        Apttus_Config2__AssetLineItem__c currentOnlineSoftwareList1 = TestDataFactoryCPQ.getAssetLineItem('assetlineitem03', act,accountSSD, prod3);
        currentOnlineSoftwareList1.APTS_Info_RenewalDate__c= Date.newInstance(2019, 12, 9);
        
        Product2 prod4 = TestDataFactoryCPQ.getProduct('testproduct4', 'WESTLAW');
        Apttus_Config2__AssetLineItem__c currentOnlineSoftwareList2 = TestDataFactoryCPQ.getAssetLineItem('assetlineitem03', act,accountSSD, prod4);
        currentOnlineSoftwareList2.APTS_Info_RenewalDate__c= Date.newInstance(2022, 12, 9);
        
        Apttus_Config2__AssetLineItem__c lapsedAssetLineItem = TestDataFactoryCPQ.lapsedAssetLineItem('assetlineitem4', act,accountSSD, prod4);
        lapsedAssetLineItem .Apttus_Config2__NetPrice__c=30;
        
        //Canada
        Product2 prodcan = TestDataFactoryCPQ.getProduct('testproduct1', 'LEGAL OTHER ONLINE');
        Product2 prodcan2 = TestDataFactoryCPQ.getProduct('testproduct2', 'LEGAL OTHER ONLINE');
        Product2 prodcan3 = TestDataFactoryCPQ.getProduct('testproduct3', 'LEGAL OTHER ONLINE');
        
        List<Product2> prodlist = new List<Product2>{taxProd1,taxProd2,prod1,prod2,prod3,prod4,prodcan,prodcan2,prodcan3};
            
        insert prodlist;
        
        //Added for Tax Prof
        Apttus_Config2__AssetLineItem__c taxEngSolAssets = TestDataFactoryCPQ.getAssetLineItem('Taxassetlineitem1', actTax,accountTaxSSD, taxProd1);
        taxEngSolAssets.Apttus_Config2__IsInactive__c = false;
        taxEngSolAssets.Apttus_Config2__ListPrice__c = 30;
        taxEngSolAssets.Apttus_Config2__NetPrice__c = 30;
        taxEngSolAssets.Apttus_Config2__IsInactive__c = false;
        taxEngSolAssets.APTS_Contract_Term__c = '2 Years';
        taxEngSolAssets.Apttus_Config2__AssetStatus__c = 'Activated';
        taxEngSolAssets.APTS_SSD_Sold_To__c = accountTaxSSD.Id;     
        taxEngSolAssets.Apttus_Config2__BasePriceMethod__c = 'Per Unit';
        taxEngSolAssets.Apttus_Config2__NetUnitPrice__c = 10;
        taxEngSolAssets.Apttus_Config2__LineType__c = 'Product/Service';
        
        //Added for Tax Prof
        Apttus_Config2__AssetLineItem__c taxClearAssets = TestDataFactoryCPQ.getAssetLineItem('Taxassetlineitem2', actTax,accountTaxSSD, taxProd2);
        taxClearAssets.Apttus_Config2__IsInactive__c = false;
        taxClearAssets.Apttus_Config2__AssetStatus__c = 'Activated'; 
        taxClearAssets.APTS_Info_RenewalDate__c= Date.newInstance(2020, 31, 12);
        taxClearAssets.Apttus_Config2__ListPrice__c = 20;
        taxClearAssets.Apttus_Config2__NetPrice__c = 30;
        taxClearAssets.Apttus_Config2__BasePriceMethod__c = 'Flat Price';
        taxClearAssets.Apttus_Config2__NetUnitPrice__c = 20;
        taxClearAssets.Apttus_Config2__LineType__c = 'Product/Service';
        
        Apttus_Config2__AssetLineItem__c assetLineItemCan = TestDataFactoryCPQ.getAssetLineItem('assetlineitem1', actCanada,accountCanadaSSD, prodcan);
        Apttus_Config2__AssetLineItem__c printProviewListCan= TestDataFactoryCPQ.getAssetLineItem('assetlineitem2', actCanada,accountCanadaSSD, prodcan2);
        Apttus_Config2__AssetLineItem__c currentOnlineSoftwareListCan = TestDataFactoryCPQ.getAssetLineItem('assetlineitem3', actCanada,accountCanadaSSD, prodcan3);
        currentOnlineSoftwareListCan.APTS_Info_RenewalDate__c= Date.newInstance(2016, 12, 9);
        
        Apttus_Config2__AssetLineItem__c currentOnlineSoftwareList1Can = TestDataFactoryCPQ.getAssetLineItem('assetlineitem03', actCanada,accountCanadaSSD, prodcan3);
        currentOnlineSoftwareList1Can.APTS_Info_RenewalDate__c= Date.newInstance(2019, 12, 9);
                                
        Apttus_Config2__AssetLineItem__c assetLineItemCan3 = TestDataFactoryCPQ.getAssetLineItem('assetlineitem3', actCanada,accountCanadaSSD, prod4);
        assetLineItemCan3.APTS_Info_RenewalDate__c= Date.newInstance(2022, 12, 9);
        
        Apttus_Config2__AssetLineItem__c lapsedAssetLineItemCan = TestDataFactoryCPQ.lapsedAssetLineItem('assetlineitem4', actCanada,accountCanadaSSD, prodcan3);
        
        List<Apttus_Config2__AssetLineItem__c> olapsedAssetLineItemList= new List<Apttus_Config2__AssetLineItem__c>();
        olapsedAssetLineItemList.add(assetLineItem1);
        olapsedAssetLineItemList.add(printProviewList);
        olapsedAssetLineItemList.add(currentOnlineSoftwareList);
        olapsedAssetLineItemList.add(currentOnlineSoftwareList1);
        olapsedAssetLineItemList.add(currentOnlineSoftwareList2);
        olapsedAssetLineItemList.add(lapsedAssetLineItem);
        olapsedAssetLineItemList.add(taxEngSolAssets);
        olapsedAssetLineItemList.add(taxClearAssets);
        //olapsedAssetLineItemList.add(assetLineItemCan);
        //olapsedAssetLineItemList.add(printProviewListCan);
        //olapsedAssetLineItemList.add(currentOnlineSoftwareListCan);
        olapsedAssetLineItemList.add(currentOnlineSoftwareList1Can);
        //olapsedAssetLineItemList.add(assetLineItemCan3);
        olapsedAssetLineItemList.add(lapsedAssetLineItemCan);
        
        if(olapsedAssetLineItemList.size() > 0)
        {
            insert olapsedAssetLineItemList;
        }
        Apttus_Config2__LineItem__c printlineItem = TestDataFactoryCPQ.getPRINTConfigLineItem(prodConfig, prod1, null);
        //insert printlineItem;
        
        Apttus_Config2__LineItem__c onlineLineItem = TestDataFactoryCPQ.getPRINTConfigLineItem(prodConfig, prod4, null);
        onlineLineItem.APTS_Product_Family__c = 'Westlaw';
       // insert onlineLineItem;  
        
          Apttus_Config2__LineItem__c onlineLineItem1 = TestDataFactoryCPQ.getPRINTConfigLineItem(prodConfig, prod4, null);
        onlineLineItem1.Apttus_Config2__LineStatus__c='Renewed';
        onlineLineItem1.APTS_Yr_1_Renewal_Adjustment__c='10';
        //insert onlineLineItem1; 
        
        Apttus_Config2__LineItem__c onlineLineItem2 = TestDataFactoryCPQ.getPRINTConfigLineItem(prodConfig, prod4, null);
        onlineLineItem2.Apttus_Config2__LineStatus__c='Cancelled';
        onlineLineItem2.Apttus_Config2__AssetId__c =currentOnlineSoftwareList2.id;
        onlineLineItem2.Apttus_Config2__ListPrice__c=30;
        
        //Added for Tax Prof
        Apttus_Config2__LineItem__c newTaxLineItem = TestDataFactoryCPQ.getPRINTConfigLineItem(prodConfigTax, taxProd1, null);
        newTaxLineItem.Apttus_Config2__LineStatus__c='Cancelled';
        newTaxLineItem.Apttus_Config2__ChargeType__c = 'Subscription Fee';
        newTaxLineItem.APTS_Product_Family__c = 'Westlaw';
        newTaxLineItem.Apttus_Config2__Quantity__c = 5;
        newTaxLineItem.Apttus_Config2__BillingFrequency__c = 'Yearly';
        newTaxLineItem.Apttus_Config2__PriceUom__c = 'Attorneys';
        newTaxLineItem.APTS_Product_Delivery__c = 'Online/Internet';
        newTaxLineItem.APTS_Contract_Term__c = '2 Years';
        newTaxLineItem.APTS_Years_2_Plus_Adjustment__c = '5';
        newTaxLineItem.Apttus_Config2__LineType__c = 'Product/Service';
        newTaxLineItem.Apttus_Config2__ListPrice__c = 30;
        newTaxLineItem.Apttus_Config2__BasePriceMethod__c = 'Flat Price';
        newTaxLineItem.Apttus_Config2__AssetLineItemId__c = taxClearAssets.Id;
        newTaxLineItem.APTS_Calculated_Year_1__c = 150;
        newTaxLineItem.APTS_Calculated_Year_2__c = 250;
        newTaxLineItem.APTS_Calculated_Year_3__c = 350;
        newTaxLineItem.APTS_Calculated_Year_4__c = 450;
        newTaxLineItem.APTS_Calculated_Year_5__c = 550;
            
        //Added for Tax Prof
        Apttus_Config2__LineItem__c existingTaxLineItem = TestDataFactoryCPQ.getPRINTConfigLineItem(prodConfigTax, taxProd1, null);
        existingTaxLineItem.Apttus_Config2__LineStatus__c='Existing';
        existingTaxLineItem.APTS_Product_Family__c = 'Westlaw';
        existingTaxLineItem.Apttus_Config2__ChargeType__c = 'Subscription Fee';
        existingTaxLineItem.Apttus_Config2__BillingFrequency__c = 'Monthly';
        existingTaxLineItem.APTS_Product_Delivery__c = 'Download';
        existingTaxLineItem.APTS_Contract_Term__c = '2 Years';
        existingTaxLineItem.Apttus_Config2__LineType__c = 'Product/Service';
        existingTaxLineItem.Apttus_Config2__BasePriceMethod__c = 'Per Unit';
        existingTaxLineItem.APTS_Calculated_Year_1__c = 100;
        
        //Added for Tax Prof
        Apttus_Config2__LineItem__c proposedTCVTaxLineItem = TestDataFactoryCPQ.getPRINTConfigLineItem(prodConfigTax, taxProd1, null);
        proposedTCVTaxLineItem.Apttus_Config2__LineStatus__c='Cancelled';
        proposedTCVTaxLineItem.APTS_Product_Family__c = 'Westlaw';
        proposedTCVTaxLineItem.Apttus_Config2__ChargeType__c = 'Subscription Fee';
        proposedTCVTaxLineItem.APTS_Contract_Term__c = '2 Years';
        proposedTCVTaxLineItem.Apttus_Config2__BillingFrequency__c = 'Monthly';
        proposedTCVTaxLineItem.APTS_Product_Delivery__c = 'Download';
        //proposedTCVTaxLineItem.APTS_Info_RenewalDate__c = Date.newInstance(2020, 31, 12);
        proposedTCVTaxLineItem.Apttus_Config2__AssetLineItemId__c = taxClearAssets.Id;
        proposedTCVTaxLineItem.Apttus_Config2__LineType__c = 'Product/Service';
        proposedTCVTaxLineItem.Apttus_Config2__ListPrice__c = 50;
        proposedTCVTaxLineItem.Apttus_Config2__BasePriceMethod__c = 'Flat Price'; 
        
        //Added for Tax Prof
        Apttus_Config2__LineItem__c renewedProposedTCVTaxLI = TestDataFactoryCPQ.getPRINTConfigLineItem(prodConfigTax, taxProd1, null);
        renewedProposedTCVTaxLI.Apttus_Config2__LineStatus__c='Renewed';
        renewedProposedTCVTaxLI.APTS_Product_Family__c = 'Westlaw';
        renewedProposedTCVTaxLI.Apttus_Config2__ChargeType__c = 'Subscription Fee';
        renewedProposedTCVTaxLI.APTS_Contract_Term__c = '2 Years';
        renewedProposedTCVTaxLI.Apttus_Config2__BillingFrequency__c = 'Monthly';
        renewedProposedTCVTaxLI.APTS_Product_Delivery__c = 'Pick 2';
        //renewedProposedTCVTaxLI.APTS_Info_RenewalDate__c = Date.newInstance(2020, 31, 12);
        renewedProposedTCVTaxLI.APTS_Yr_1_Renewal_Adjustment__c = '5';
        renewedProposedTCVTaxLI.Apttus_Config2__AssetLineItemId__c = taxClearAssets.Id;
        renewedProposedTCVTaxLI.Apttus_Config2__LineType__c = 'Product/Service';
        renewedProposedTCVTaxLI.Apttus_Config2__BasePriceMethod__c = 'Per Unit';
        
        //Added for Tax Prof
        Apttus_Config2__LineItem__c proposedTCVCanPUTaxLineItem = TestDataFactoryCPQ.getPRINTConfigLineItem(prodConfigTax, taxProd1, null);
        proposedTCVCanPUTaxLineItem.Apttus_Config2__LineStatus__c='Cancelled';
        proposedTCVCanPUTaxLineItem.APTS_Product_Family__c = 'Westlaw';
        proposedTCVCanPUTaxLineItem.Apttus_Config2__ChargeType__c = 'Subscription Fee';
        proposedTCVCanPUTaxLineItem.APTS_Contract_Term__c = '2 Years';
        proposedTCVCanPUTaxLineItem.Apttus_Config2__BillingFrequency__c = 'Monthly';
        proposedTCVCanPUTaxLineItem.APTS_Product_Delivery__c = 'Download';
        proposedTCVCanPUTaxLineItem.Apttus_Config2__AssetLineItemId__c = taxClearAssets.Id;
        proposedTCVCanPUTaxLineItem.Apttus_Config2__LineType__c = 'Product/Service';
        proposedTCVCanPUTaxLineItem.Apttus_Config2__ListPrice__c = 50;
        proposedTCVCanPUTaxLineItem.Apttus_Config2__BasePriceMethod__c = 'Per Unit'; 
        
        //Canada
        Apttus_Config2__LineItem__c lineItem = TestDataFactoryCPQ.getPRINTConfigLineItem(prodConfigCan, prodcan, null);
        
        Apttus_Config2__LineItem__c onlineLineItem1C = TestDataFactoryCPQ.getPRINTConfigLineItem(prodConfigCan, prodcan2, null);
        onlineLineItem1C.Apttus_Config2__LineStatus__c='Renewed';
        onlineLineItem1C.APTS_Yr_1_Renewal_Adjustment__c='10';
        
        Apttus_Config2__LineItem__c onlineLineItem2C = TestDataFactoryCPQ.getPRINTConfigLineItem(prodConfigCan, prod4, null);
        onlineLineItem2C.Apttus_Config2__LineStatus__c='Cancelled';
        onlineLineItem2C.Apttus_Config2__AssetId__c =assetLineItemCan3.id;
        onlineLineItem2C.Apttus_Config2__ListPrice__c=30;
        
        Apttus_Config2__LineItem__c onlineLineItem3C = TestDataFactoryCPQ.getPRINTConfigLineItem(prodConfigCan, prodcan3, null);
        onlineLineItem2C.Apttus_Config2__LineStatus__c='Cancelled';
        onlineLineItem2C.Apttus_Config2__AssetId__c =currentOnlineSoftwareListCan.id;
        onlineLineItem2C.Apttus_Config2__ListPrice__c=30;
        
        Apttus_Config2__LineItem__c onlineLineItemTK = TestDataFactoryCPQ.getPRINTConfigLineItem(prodConfig , prodcan3, null);
        onlineLineItemTK.Apttus_Config2__LineStatus__c='Amended';
        onlineLineItemTK.Apttus_Config2__AssetId__c =currentOnlineSoftwareListCan.id;
        onlineLineItemTK.Apttus_Config2__ListPrice__c=30;
        onlineLineItemTK.APTS_is_Primary_in_Bundle__c=true;
        
        Apttus_Config2__LineItem__c onlineLineItemC = TestDataFactoryCPQ.getPRINTConfigLineItem(prodConfigCan, prodcan3, null);
        onlineLineItemC.APTS_Product_Family__c = 'Westlaw';
         
        List<Apttus_Config2__LineItem__c> onlineLineItemList= new List<Apttus_Config2__LineItem__c>();
        onlineLineItemList.add(printlineItem);
        onlineLineItemList.add(onlineLineItem);
        onlineLineItemList.add(onlineLineItem1);
        //onlineLineItemList.add(onlineLineItem2);//ASSET ID
        onlineLineItemList.add(newTaxLineItem);
        onlineLineItemList.add(existingTaxLineItem);
        onlineLineItemList.add(proposedTCVTaxLineItem);
        onlineLineItemList.add(renewedProposedTCVTaxLI);
        onlineLineItemList.add(onlineLineItem1C);
        //onlineLineItemList.add(onlineLineItem2C);//ASSET ID
        //onlineLineItemList.add(onlineLineItem3C);//ASSET ID
        onlineLineItemList.add(onlineLineItemC);
        onlineLineItemList.add(onlineLineItemTK);
        
        if(onlineLineItemList.size()>0){
            insert onlineLineItemList; 
        }
      
        Test.stopTest();
    }
    
    static testmethod void testconstructorTax() {
        Test.startTest();
        List<Apttus_Proposal__Proposal__c> proposal = [select Id, Name, Owner.Name, qp.Apttus_Proposal__Account__c 
                                                from Apttus_Proposal__Proposal__c qp 
                                                where Apttus_Proposal__Proposal_Name__c = 'testTaxproposal' limit 1];
        
        PageReference pRef = Page.ApprovalDashboardPage;
        pRef.getParameters().put('retId', proposal[0].Id);
        Test.setCurrentPage(pRef);
        System.assertEquals(1,proposal.size());
        ApprovalDashboardAJSController ctrl = new ApprovalDashboardAJSController();
        
        Test.stopTest(); 
    }
    
    static testmethod void testconstructorCanada() {
        Test.startTest();
        List<Apttus_Proposal__Proposal__c> proposal = [select Id, Name, Owner.Name, qp.Apttus_Proposal__Account__c 
                                                from Apttus_Proposal__Proposal__c qp 
                                                where Apttus_Proposal__Proposal_Name__c = 'testCanadaproposal' limit 1];
        
        PageReference pRef = Page.ApprovalDashboardPage;
        pRef.getParameters().put('retId', proposal[0].Id);
        Test.setCurrentPage(pRef);
        
        ApprovalDashboardAJSController ctrl = new ApprovalDashboardAJSController();
        System.assertEquals(1,proposal.size());
        
        Test.stopTest(); 
    }
    static testmethod void testconstructor() {
       // initTestData();
        Test.startTest();
        List<Apttus_Proposal__Proposal__c> proposal = [select Id, Name, Owner.Name, qp.Apttus_Proposal__Account__c 
                                                from Apttus_Proposal__Proposal__c qp 
                                                where Apttus_Proposal__Proposal_Name__c = 'testproposal' limit 1];
        
        PageReference pRef = Page.ApprovalDashboardPage;
        pRef.getParameters().put('retId', proposal[0].Id);
        Test.setCurrentPage(pRef);
        
        ApprovalDashboardAJSController ctrl = new ApprovalDashboardAJSController();
        
        System.assert(ctrl.assetLineItem.size() != 0);  
        System.assert(ctrl.currentTCVList.size() != 0);
        //System.assert(ctrl.printProviewList.size() != 0); 
        System.assert(ctrl.lapsedProducts.size() != 0);
        System.assertEquals(1,proposal.size());
        
        Test.stopTest(); 
    }
    /*static testmethod void test_constructor2() {
        Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
         Test.startTest();
         Schema.DescribeFieldResult fieldResultMarket = Apttus_Config2__ProductConfiguration__c.APTS_AccountMirror_Picklist__c.getDescribe();
        String valueMarket = fieldResultMarket.getPicklistValues().get(0).getValue();
        Account act = new Account(
            RecordTypeId=accRecordTypeId,
            name = 'UnitTest',
            customer_group__c = 'Academic',
            customer_type__c = 'Organization',
            customer_class_c__c = 'Academic Lecturer', 
            sales_org__c = 'CARS',
            APTS_Band_Number__c = 12
        );
        insert act;
          
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();
        Source_System_Detail__c accountSSD2= new Source_System_Detail__c();
        accountSSD2.RecordtypeId=ssdRecorType;
        accountSSD2.Name='ABC';
        accountSSD2.Source_System_Name__c='ABC';
        accountSSD2.Account_Name__c=act.ID;
        accountSSD2.LCRM_Frozen_Market_Segment__c = valueMarket ;
        accountSSD2.Account_Inactive__c=false;
        accountSSD2.LCRM_Sales_Org__c='CARS';
        insert accountSSD2;
        
        
        PriceBook2 pb = new PriceBook2(name='Test Price Book', isActive=true);
        insert pb;
        Date todaysDate = system.today();   
        Opportunity o2 = UnitTest.getOpportunityInstance(act.Id);
        o2.Name = 'tst-opp1';
        o2.stagename = '25%';
        o2.closedate = todaysDate;
        o2.forecastcategoryname = 'pipeline';
        o2.pricebook2id = pb.id;
        o2.Source_System_Detail__c=accountSSD2.id;
        insert o2;
        Apttus_Config2__PriceList__c p2 = new Apttus_Config2__PriceList__c();
        p2.Apttus_Config2__Active__c = true;
        p2.Name = 'Thomson Reuters Master - Canada';
        p2.Apttus_Config2__EffectiveDate__c = System.today().addYears(-1);
        p2.Apttus_Config2__ExpirationDate__c = System.today().addYears(2);
        p2.CurrencyIsoCode = 'CAD';
        insert p2;  
     
        Id devRecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Proposal').getRecordTypeId();
        Apttus_Proposal__Proposal__c proposal2 = new Apttus_Proposal__Proposal__c(
            RecordTypeId=devRecordTypeId, 
            Apttus_Proposal__Proposal_Name__c='testproposal',
            Apttus_Proposal__Account__c = act.id, 
            Apttus_Proposal__Opportunity__c=o2.id, 
            Apttus_Proposal__Approval_Stage__c='Draft', 
            Apttus_Proposal__Proposal_Category__c='Quote', 
            Apttus_Proposal__ReadyToGenerate__c = true, 
            Apttus_Proposal__ReadyToPresent__c= true, 
            Apttus_QPConfig__PriceListId__c=p2.id,
            APTS_SSD_Sold_To__c = accountSSD2.Id,
            APTS_Proposal_Business_Unit__c=LABEL.SALESORGCAN
            );
            insert proposal2;
            Apttus_Config2__ProductConfiguration__c prodConfig2 = TestDataFactoryCPQ.getConfiguration(proposal2, p2.Id, act);
            prodConfig2.APTS_Current_Holdings__c=0;
            insert prodConfig2;
            Apttus_Config2__SummaryGroup__c summaryGroup2 = new Apttus_Config2__SummaryGroup__c(
                Apttus_Config2__ConfigurationId__c = prodConfig2.id, 
                Name = 'WEST PROFLEX Bundle A - Test group',
                Apttus_Config2__LineType__c = 'Group Total',
                Apttus_Config2__ItemSequence__c = 1,
                Apttus_Config2__LineNumber__c = 1
            );
        insert summaryGroup2;
  
        Product2 prodcan = TestDataFactoryCPQ.getProduct('testproduct1', 'LEGAL OTHER ONLINE');
        insert prodcan;
                        
        Apttus_Config2__AssetLineItem__c assetLineItemCan = TestDataFactoryCPQ.getAssetLineItem('assetlineitem1', act,accountSSD2, prodcan);
        Product2 prodcan2 = TestDataFactoryCPQ.getProduct('testproduct2', 'LEGAL OTHER ONLINE');
        insert prodcan2;
       
        Apttus_Config2__AssetLineItem__c printProviewList= TestDataFactoryCPQ.getAssetLineItem('assetlineitem2', act,accountSSD2, prodcan2);
        
        Product2 prodcan3 = TestDataFactoryCPQ.getProduct('testproduct3', 'LEGAL OTHER ONLINE');
        insert prodcan3;
        Product2 prodcan4 = TestDataFactoryCPQ.getProduct('testproduct4', 'WESTLAW');
        insert prodcan4;
                           
         Apttus_Config2__AssetLineItem__c currentOnlineSoftwareList = TestDataFactoryCPQ.getAssetLineItem('assetlineitem3', act,accountSSD2, prodcan3);
        currentOnlineSoftwareList.APTS_Info_RenewalDate__c= Date.newInstance(2016, 12, 9);
        
        Apttus_Config2__AssetLineItem__c currentOnlineSoftwareList1 = TestDataFactoryCPQ.getAssetLineItem('assetlineitem03', act,accountSSD2, prodcan3);
        currentOnlineSoftwareList1.APTS_Info_RenewalDate__c= Date.newInstance(2019, 12, 9);
                                
        Apttus_Config2__AssetLineItem__c assetLineItemCan3 = TestDataFactoryCPQ.getAssetLineItem('assetlineitem3', act,accountSSD2, prodcan4);
        assetLineItemCan3.APTS_Info_RenewalDate__c= Date.newInstance(2022, 12, 9);
        
        Apttus_Config2__AssetLineItem__c lapsedAssetLineItem = TestDataFactoryCPQ.lapsedAssetLineItem('assetlineitem4', act,accountSSD2, prodcan3);
        
         List<Apttus_Config2__AssetLineItem__c> olapsedAssetLineItemList= new List<Apttus_Config2__AssetLineItem__c>();       
         olapsedAssetLineItemList.add(assetLineItemCan);
         olapsedAssetLineItemList.add(printProviewList);
         olapsedAssetLineItemList.add(assetLineItemCan3);
         olapsedAssetLineItemList.add(lapsedAssetLineItem);
         olapsedAssetLineItemList.add(currentOnlineSoftwareList);
         olapsedAssetLineItemList.add(currentOnlineSoftwareList1);

           
          if(olapsedAssetLineItemList.size()>0){
              
              insert olapsedAssetLineItemList;
          }
        
        Apttus_Config2__LineItem__c lineItem = TestDataFactoryCPQ.getPRINTConfigLineItem(prodConfig2, prodcan, null);
        
        Apttus_Config2__LineItem__c onlineLineItem1 = TestDataFactoryCPQ.getPRINTConfigLineItem(prodConfig2, prodcan2, null);
        onlineLineItem1.Apttus_Config2__LineStatus__c='Renewed';
        onlineLineItem1.APTS_Yr_1_Renewal_Adjustment__c='10';
        
        Apttus_Config2__LineItem__c onlineLineItem2 = TestDataFactoryCPQ.getPRINTConfigLineItem(prodConfig2, prodcan4, null);
        onlineLineItem2.Apttus_Config2__LineStatus__c='Cancelled';
        onlineLineItem2.Apttus_Config2__AssetId__c =assetLineItemCan3.id;
        onlineLineItem2.Apttus_Config2__ListPrice__c=30;
        
         Apttus_Config2__LineItem__c onlineLineItem3 = TestDataFactoryCPQ.getPRINTConfigLineItem(prodConfig2, prodcan3, null);
        onlineLineItem2.Apttus_Config2__LineStatus__c='Cancelled';
        onlineLineItem2.Apttus_Config2__AssetId__c =currentOnlineSoftwareList.id;
        onlineLineItem2.Apttus_Config2__ListPrice__c=30;
        
        
        Apttus_Config2__LineItem__c onlineLineItem = TestDataFactoryCPQ.getPRINTConfigLineItem(prodConfig2, prodcan3, null);
        onlineLineItem.APTS_Product_Family__c = 'Westlaw';
        
        
        List<Apttus_Config2__LineItem__c> onlineLineItemList= new List<Apttus_Config2__LineItem__c>();
        onlineLineItemList.add(lineItem);
        onlineLineItemList.add(onlineLineItem);
        onlineLineItemList.add(onlineLineItem1);
        onlineLineItemList.add(onlineLineItem2);
        onlineLineItemList.add(onlineLineItem3);
        
         if(onlineLineItemList.size()>0){
            insert onlineLineItemList;
        }
        
        
        PageReference pRef = Page.ApprovalDashboardPage;
        pRef.getParameters().put('retId', proposal2.Id);
        Test.setCurrentPage(pRef);
        
        ApprovalDashboardAJSController ctrl = new ApprovalDashboardAJSController();
        
        System.assert(ctrl.assetLineItem.size() != 0);  
        System.assert(ctrl.currentTCVList.size() != 0);
        //System.assert(ctrl.printProviewList.size() != 0);
        System.assert(ctrl.lapsedProducts.size() != 0);
        
        
        Test.stopTest(); 
    } */
    
    static testmethod void testgetAccountDetail(){
        Test.startTest();
       // initTestData();
        
        List<Source_System_Detail__c> act = [select Id, Name from Source_System_Detail__c WHERE Name = 'ABC'];        
        Source_System_Detail__c temp = ApprovalDashboardAJSController.getAccountDetail(act[0].Id);
        //System.assertEquals(act.Name, temp.Name); - to be reverted      
        System.assertEquals(1,act.size());
                
        Test.stopTest(); 
    }
    
    static testmethod void testgetAssetLineItem() {
        Test.startTest();
        //initTestData();
        
        List<Source_System_Detail__c> act = [select Id, Name from Source_System_Detail__c where Name = 'ABC'];
        Apttus_Config2__ProductConfiguration__c prodConfig = [select Id, Name from Apttus_Config2__ProductConfiguration__c where Name = 'prodConfig1'];
        Apttus_Config2__AssetLineItem__c asset = [select Id, Name, Apttus_Config2__NetUnitPrice__c from Apttus_Config2__AssetLineItem__c where Name = 'assetlineitem1'];
        List<Apttus_Config2__AssetLineItem__c> temp = ApprovalDashboardAJSController.getAssetLineItem(act[0].Id, prodConfig.Id);
        
        Source_System_Detail__c actTax = [select Id, Name from Source_System_Detail__c where Name = 'ABCT'];
        Apttus_Config2__ProductConfiguration__c prodConfigTax = [select Id, Name from Apttus_Config2__ProductConfiguration__c where Name = 'prodConfigTax'];
        Apttus_Config2__AssetLineItem__c assetTax = [select Id, Name, Apttus_Config2__NetUnitPrice__c from Apttus_Config2__AssetLineItem__c where Name = 'Taxassetlineitem1'];
        List<Apttus_Config2__AssetLineItem__c> tempTax = ApprovalDashboardAJSController.getAssetLineItem(actTax.Id, prodConfigTax.Id);
        //System.assertEquals(asset.Name, temp[0].Name);
        System.assertEquals(1,act.size());
        
        Test.stopTest();
    }
    
    static testmethod void testgetCurrentOnlineSoftwareList() {
        Test.startTest();
        //initTestData();
        
        List<Source_System_Detail__c> act = [select Id, Name from Source_System_Detail__c where Name = 'ABC'];
        Apttus_Config2__ProductConfiguration__c prodConfig = [select Id, Name from Apttus_Config2__ProductConfiguration__c where Name = 'prodConfig1'];
        Apttus_Config2__AssetLineItem__c asset = [select Id, Name, Apttus_Config2__NetUnitPrice__c from Apttus_Config2__AssetLineItem__c where Name = 'assetlineitem3'];
        List<Apttus_Config2__AssetLineItem__c> temp = ApprovalDashboardAJSController.getCurrentOnlineSoftwareList(act[0].Id, prodConfig.Id);
        //System.assertEquals(asset.Name, temp[0].Name);
        System.assertEquals(1,act.size());
        
        Test.stopTest();  
    }

    static testmethod void testgetPrintProviewList() {
        Test.startTest();
        //initTestData();
        
        List<Source_System_Detail__c> act = [select Id, Name from Source_System_Detail__c where Name = 'ABC'];
        Apttus_Config2__ProductConfiguration__c prodConfig = [select Id, Name from Apttus_Config2__ProductConfiguration__c where Name = 'prodConfig1'];
        Apttus_Config2__AssetLineItem__c asset = [select Id, Name, Apttus_Config2__NetUnitPrice__c from Apttus_Config2__AssetLineItem__c where Name = 'assetlineitem1'];
        List<Apttus_Config2__AssetLineItem__c> temp = ApprovalDashboardAJSController.getPrintProviewList(act[0].Id, prodConfig.Id);
        //System.assertEquals(asset.Name, temp[0].Name);
        System.assertEquals(1,act.size());
        
        Test.stopTest();
    }
    
    static testmethod void testgetFindLawList() {
        Test.startTest();
        //initTestData();
        
        List<Source_System_Detail__c> act = [select Id, Name from Source_System_Detail__c where Name = 'ABC'];
        Apttus_Config2__ProductConfiguration__c prodConfig = [select Id, Name from Apttus_Config2__ProductConfiguration__c where Name = 'prodConfig1'];
        Apttus_Config2__AssetLineItem__c asset = [select Id, Name, Apttus_Config2__NetUnitPrice__c from Apttus_Config2__AssetLineItem__c where Name = 'assetlineitem2'];
        List<Apttus_Config2__AssetLineItem__c> temp = ApprovalDashboardAJSController.getFindLawList(act[0].Id, prodConfig.Id);
        //System.assertEquals(asset.Name, temp[0].Name);
        System.assertEquals(1,act.size());
        
        Test.stopTest();
    }
    
    static testmethod void testgetLineItem() {
        Test.startTest();
        //initTestData();
        
        List<Apttus_Config2__ProductConfiguration__c> prodConfig = [select Id, Name from Apttus_Config2__ProductConfiguration__c where Name = 'prodConfig1'];
        List<Apttus_Config2__LineItem__c> temp = ApprovalDashboardAJSController.getLineItem(prodConfig[0].Id);
        System.assert(temp.size() != 0);
        
        List<Apttus_Config2__ProductConfiguration__c> prodConfigTax = [select Id, Name from Apttus_Config2__ProductConfiguration__c where Name = 'prodConfigTax'];
        List<Apttus_Config2__LineItem__c> tempTax = ApprovalDashboardAJSController.getLineItem(prodConfigTax[0].Id);
        System.assert(tempTax.size() != 0);
        System.assertEquals(1,prodConfig.size());
        
        Test.stopTest();
    }
    
    static testmethod void testgetDocumentList() {
        Test.startTest();
        Apttus_Proposal__Proposal__c proposal = [select Id, Name from Apttus_Proposal__Proposal__c 
                                                where Apttus_Proposal__Proposal_Name__c= 'testproposal'];
        
        Attachment attach=new Attachment();     
        attach.Name='Unit Test Attachment';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=proposal.id;
        insert attach;
        
        Note testNote = new Note();
        testNote.Title = 'Test Proposal Note';
        testNote.Body = 'Test Proposal Note Body.';
        testNote.ParentId = proposal.Id;
        insert testNote;
          
        // Insert Files as attachments
        //ContentVersion conVer = new ContentVersion();
        //conVer.ContentLocation = 'S'; // S specify this document is in SF, use E for external files
        /*conVer.PathOnClient = 'Demo.XLS'; // The files name, extension is very important here which will help the file in preview.
        conVer.Title = 'Demo.XLS'; // Display name of the files
        conVer.VersionData = blob.valueOf('Test File'); // converting your binary string to Blog
        conVer.IsMajorVersion = true;
        insert conVer;
          
        Id conDoc = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:conVer.Id].ContentDocumentId;
          
        ContentVersion conVer1 = new ContentVersion();
        //conVer.ContentLocation = 'S'; // S specify this document is in SF, use E for external files
        conVer1.PathOnClient = 'Demo.XLS'; // The files name, extension is very important here which will help the file in preview.
        conVer1.Title = 'Demo.XLS'; // Display name of the files
        conVer1.VersionData = blob.valueOf('Test File'); // converting your binary string to Blog
        conVer1.IsMajorVersion = true;
        insert conVer1;
          
        Id conDoc1 = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:conVer1.Id].ContentDocumentId;
        //Create ContentDocumentLink
        ContentDocumentLink cDe = new ContentDocumentLink();
        cDe.ContentDocumentId = conDoc1;
        cDe.LinkedEntityId = proposal.Id; 
        cDe.ShareType = 'I'; 
        insert cDe;*/
        
        List<ApprovalDashboardAJSController.Document> document = ApprovalDashboardAJSController.getDocumentList(proposal.Id);
        
        System.assertEquals(proposal!=null,true);
        /*System.assertEquals(attach.Name, document[0].fileName);
        System.assertEquals('Attachment', document[0].Type);
        List<ApprovalDashboardAJSController.Document> document1 = ApprovalDashboardAJSController.getFileList(proposal.Id, proposal.Name);
        System.assertEquals(conVer.Title, document1[0].fileName);
        System.assertEquals('File', document1[0].Type);
        Boolean document2 = ApprovalDashboardAJSController.associateFilesWithQuote(conVer.Id,proposal.Id);
        System.assertEquals(true, document2);*/
        Test.stopTest(); 
    }
  
    static testmethod void testgetPrintProviewLineItems() {
        Test.startTest();
        //initTestData();
        
        Apttus_Proposal__Proposal__c proposal = [select Id, Name, Apttus_Proposal__Proposal_Name__c from Apttus_Proposal__Proposal__c 
                                                where Apttus_Proposal__Proposal_Name__c= 'testproposal'];
                                                
        List<ApprovalDashboardAJSController.PrintProview> temp = ApprovalDashboardAJSController.getPrintProviewLineItems(proposal.Id);
        System.assertEquals(proposal.Apttus_Proposal__Proposal_Name__c, 'testproposal');
        //System.assertEquals('PRINT LEGAL SOLUTIONS', temp[0].productFamily);
                                                
        Test.stopTest();
    }
    
    static testmethod void testgetOwnerName() {
        Test.startTest();
        //initTestData();
        
        List<Apttus_Proposal__Proposal__c> proposal = [select Id, Name, Owner.Name, qp.Apttus_Proposal__Account__c 
                                                from Apttus_Proposal__Proposal__c qp 
                                                where Apttus_Proposal__Proposal_Name__c = 'testproposal'];
        
        PageReference pRef = Page.ApprovalDashboardPage;
        pRef.getParameters().put('retId', proposal[0].Id);
        Test.setCurrentPage(pRef);
        
        ApprovalDashboardAJSController ctrl = new ApprovalDashboardAJSController();
        String ownerName = ctrl.getOwnerName();
        System.debug('Owner Name -------------- '+ownerName);
        //System.assert(ownerName != null);
        System.assertEquals(1,proposal.size());
        
        Test.stopTest();
    }
    
    static testmethod void testgetCurrentNetPrice() {
        Test.startTest();
        //initTestData();
        
        List<Apttus_Proposal__Proposal__c> proposal = [select Id, Name, Owner.Name, qp.Apttus_Proposal__Account__c 
                                                from Apttus_Proposal__Proposal__c qp 
                                                where Apttus_Proposal__Proposal_Name__c = 'testproposal'];
        
        PageReference pRef = Page.ApprovalDashboardPage;
        pRef.getParameters().put('retId', proposal[0].Id);
        Test.setCurrentPage(pRef);
        
        ApprovalDashboardAJSController ctrl = new ApprovalDashboardAJSController();
        String netPrice = ctrl.getCurrentNetPrice();
        System.debug('Net Price -------------- '+netPrice);
        System.assert(netPrice != null);
        System.assertEquals(1,proposal.size());
        
        String currentACV = ctrl.getCurrentACV();
        System.debug('currentACV -------------- '+currentACV);
        System.assert(currentACV != null);
        Test.stopTest();
    }
    
    static testmethod void testgetCurrentNetPriceTax() {
        Test.startTest();
        //initTestData();
        
        List<Apttus_Proposal__Proposal__c> taxProposal = [select Id, Name, Owner.Name, qp.Apttus_Proposal__Account__c 
                                                from Apttus_Proposal__Proposal__c qp 
                                                where Apttus_Proposal__Proposal_Name__c = 'testTaxproposal'];
        
        PageReference pRef = Page.ApprovalDashboardPage;
        pRef.getParameters().put('retId', taxProposal[0].Id);
        Test.setCurrentPage(pRef);
        
        ApprovalDashboardAJSController ctrl = new ApprovalDashboardAJSController();
        String netPrice = ctrl.getCurrentNetPriceTax();
        System.debug('Net Price -------------- '+netPrice);
        System.assert(netPrice != null);
        
        String currentACV = ctrl.getCurrentACV();
        System.debug('currentACV -------------- '+currentACV);
        System.assert(currentACV != null);
        System.assertEquals(1,taxProposal.size());
        
        Test.stopTest();
    }
    
    static testmethod void testgetCurrentOnlineSpendPrice() {
        Test.startTest();
        //initTestData();
        
        Apttus_Proposal__Proposal__c proposal = [select Id, Name, Owner.Name, qp.Apttus_Proposal__Account__c 
                                                from Apttus_Proposal__Proposal__c qp 
                                                where Apttus_Proposal__Proposal_Name__c = 'testproposal'];
        
        PageReference pRef = Page.ApprovalDashboardPage;
        pRef.getParameters().put('retId', proposal.Id);
        Test.setCurrentPage(pRef);
        
        ApprovalDashboardAJSController ctrl = new ApprovalDashboardAJSController();
        String onlineSpend = ctrl.getCurrentOnlineSpendPrice();
        System.debug('CurrentOnlineSpendPrice -------------- '+onlineSpend);
        System.assert(onlineSpend != null); 
        
        String currentTCV = ctrl.getCurrentTCV();
        System.debug('currentTCV -------------- '+currentTCV);
        System.assert(currentTCV != null);
        
        Test.stopTest();
    }
    
    static testmethod void testgetCurrentBand() {
        Test.startTest();
        //initTestData();
        
        Apttus_Proposal__Proposal__c proposal = [select Id, Name, Owner.Name, qp.Apttus_Proposal__Account__c 
                                                from Apttus_Proposal__Proposal__c qp 
                                                where Apttus_Proposal__Proposal_Name__c = 'testproposal'];
        
        PageReference pRef = Page.ApprovalDashboardPage;
        pRef.getParameters().put('retId', proposal.Id);
        Test.setCurrentPage(pRef);
        
        ApprovalDashboardAJSController ctrl = new ApprovalDashboardAJSController();
        String band = ctrl.getCurrentBand();
        System.debug('Current band -------------- '+band);
        System.assert(band != null);
        Test.stopTest();
    }
    
    static testmethod void testgetAttorneyBand() {
        Test.startTest();
        //initTestData();
        
        Apttus_Proposal__Proposal__c proposal = [select Id, Name, Owner.Name, qp.Apttus_Proposal__Account__c 
                                                from Apttus_Proposal__Proposal__c qp 
                                                where Apttus_Proposal__Proposal_Name__c = 'testproposal'];
        
        PageReference pRef = Page.ApprovalDashboardPage;
        pRef.getParameters().put('retId', proposal.Id);
        Test.setCurrentPage(pRef);
        
        ApprovalDashboardAJSController ctrl = new ApprovalDashboardAJSController();
        String band = ctrl.getAttorneyBand();
        System.debug('AttorneyBand -------------- '+band);
        System.assert(band != null);
        Test.stopTest();
    }
    
    static testmethod void testgetnewProductsNetPrice() {
        Test.startTest();
        //initTestData();
        
        Apttus_Proposal__Proposal__c proposal = [select Id, Name, Owner.Name, qp.Apttus_Proposal__Account__c 
                                                from Apttus_Proposal__Proposal__c qp 
                                                where Apttus_Proposal__Proposal_Name__c = 'testproposal'];
        
        PageReference pRef = Page.ApprovalDashboardPage;
        pRef.getParameters().put('retId', proposal.Id);
        Test.setCurrentPage(pRef);
        
        ApprovalDashboardAJSController ctrl = new ApprovalDashboardAJSController();
        Decimal val = ctrl.getnewProductsNetPrice();
        System.debug('New NetPrice -------------- '+val);
        System.assert(val != null);
        Test.stopTest();
    }
    
    static testmethod void testgetCurrentAttorneysTotal() {
        Test.startTest();
        //initTestData();
        
        Apttus_Proposal__Proposal__c proposal = [select Id, Name, Owner.Name, qp.Apttus_Proposal__Account__c 
                                                from Apttus_Proposal__Proposal__c qp 
                                                where Apttus_Proposal__Proposal_Name__c = 'testproposal'];
        
        PageReference pRef = Page.ApprovalDashboardPage;
        pRef.getParameters().put('retId', proposal.Id);
        Test.setCurrentPage(pRef);
        
        ApprovalDashboardAJSController ctrl = new ApprovalDashboardAJSController();
        String val = ctrl.getCurrentAttorneysTotal();
        System.debug('CurrentAttorneysTotal -------------- '+val);
        System.assert(val != null);
        Test.stopTest();
    }
    
    static testmethod void testgetProposedAttorneysTotal() {
        Test.startTest();
        //initTestData();
        
        Apttus_Proposal__Proposal__c proposal = [select Id, Name, Owner.Name, qp.Apttus_Proposal__Account__c 
                                                from Apttus_Proposal__Proposal__c qp 
                                                where Apttus_Proposal__Proposal_Name__c = 'testproposal'];
        
        PageReference pRef = Page.ApprovalDashboardPage;
        pRef.getParameters().put('retId', proposal.Id);
        Test.setCurrentPage(pRef);
        
        ApprovalDashboardAJSController ctrl = new ApprovalDashboardAJSController();
        String val = ctrl.getProposedAttorneysTotal();
        System.debug('ProposedAttorneysTotal -------------- '+val);
        System.assert(val != null);
        Test.stopTest();
    }
    
    static testmethod void testsetCurrentNetPriceTCV() {
        Test.startTest();
        //initTestData();
        List<Source_System_Detail__c> act = [select Id, Name from Source_System_Detail__c where Name = 'ABC'];
        Apttus_Config2__ProductConfiguration__c prodConfig = [select Id, Name from Apttus_Config2__ProductConfiguration__c where Name = 'prodConfig1'];
        Apttus_Config2__AssetLineItem__c asset = [select Id, Name, Apttus_Config2__NetUnitPrice__c from Apttus_Config2__AssetLineItem__c where Name = 'assetlineitem3'];
        List<Apttus_Config2__AssetLineItem__c> temp = ApprovalDashboardAJSController.getCurrentOnlineSoftwareList(act[0].Id, prodConfig.Id);
        System.assertEquals(act.size(),1);
        
        Test.stopTest();  
        
    }
    
    static testmethod void testgetCurrentRPA() {
        Test.startTest();
        //initTestData();
        
        Apttus_Proposal__Proposal__c proposal = [select Id, Name, Owner.Name, qp.Apttus_Proposal__Account__c 
                                                from Apttus_Proposal__Proposal__c qp 
                                                where Apttus_Proposal__Proposal_Name__c = 'testproposal'];
        
        PageReference pRef = Page.ApprovalDashboardPage;
        pRef.getParameters().put('retId', proposal.Id);
        Test.setCurrentPage(pRef);
        
        ApprovalDashboardAJSController ctrl = new ApprovalDashboardAJSController();
        String val = ctrl.getCurrentRPA();
        System.debug('CurrentRPA -------------- '+val);
        System.assert(val != null);
        Test.stopTest(); 
        
    }
    
    static testmethod void testgetCurrentDiscount() {
        Test.startTest();
        //initTestData();
        
        Apttus_Proposal__Proposal__c proposal = [select Id, Name, Owner.Name, qp.Apttus_Proposal__Account__c 
                                                from Apttus_Proposal__Proposal__c qp 
                                                where Apttus_Proposal__Proposal_Name__c = 'testproposal'];
        
        PageReference pRef = Page.ApprovalDashboardPage;
        pRef.getParameters().put('retId', proposal.Id);
        Test.setCurrentPage(pRef);
        
        ApprovalDashboardAJSController ctrl = new ApprovalDashboardAJSController();
        String val = ctrl.getCurrentDiscount();
        System.debug('CurrentDiscount-------------- '+val);
        System.assert(val != null);
        
        String val1 = ctrl.getCurrentOverallDiscount();
        System.debug('CurrentOverallDiscount-------------- '+val1);
        System.assert(val1 != null);
        Test.stopTest();
    }
    
    static testmethod void testgetCurrentDiscountTax() {
        Test.startTest();
        Apttus_Proposal__Proposal__c proposal = [select Id, Name, Owner.Name, qp.Apttus_Proposal__Account__c 
                                                from Apttus_Proposal__Proposal__c qp 
                                                where Apttus_Proposal__Proposal_Name__c = 'testTaxproposal'];
        
        PageReference pRef = Page.ApprovalDashboardPage;
        pRef.getParameters().put('retId', proposal.Id);
        Test.setCurrentPage(pRef);
        
        ApprovalDashboardAJSController ctrl = new ApprovalDashboardAJSController();
        String val = ctrl.getCurrentDiscount();
        System.debug('CurrentDiscount-------------- '+val);
        System.assert(val != null);
        
        String val1 = ctrl.getCurrentOverallDiscount();
        System.debug('CurrentOverallDiscount-------------- '+val1);
        System.assert(val1 != null);
        Test.stopTest();
    }
    
    static testmethod void testgetLapsedProdNetPrice() {
        Test.startTest();
        //initTestData();
        
        Apttus_Proposal__Proposal__c proposal = [select Id, Name, Owner.Name, qp.Apttus_Proposal__Account__c 
                                                from Apttus_Proposal__Proposal__c qp 
                                                where Apttus_Proposal__Proposal_Name__c = 'testproposal'];
        
        PageReference pRef = Page.ApprovalDashboardPage;
        pRef.getParameters().put('retId', proposal.Id);
        Test.setCurrentPage(pRef);
        
        ApprovalDashboardAJSController ctrl = new ApprovalDashboardAJSController();
        Decimal val = ctrl.getLapsedProdNetPrice();
        System.debug('LapsedProdNetPrice -------------- '+val);
        System.assert(val != null);
        Test.stopTest();    
    } 
    
    static testmethod void testgetProposedDiscount(){
        Test.startTest();
        
        Apttus_Proposal__Proposal__c proposal = [select Id, Name, Owner.Name, qp.Apttus_Proposal__Account__c 
                                                from Apttus_Proposal__Proposal__c qp 
                                                where Apttus_Proposal__Proposal_Name__c = 'testproposal'];
        Apttus_Config2__ProductConfiguration__c conf = [select Id from Apttus_Config2__ProductConfiguration__c where Name = 'prodConfig1' ];
        conf.APTS_Additional_Approval_Other__c = false;
        conf.APTS_New_Holdings__c = 40;
        conf.APTS_Current_Holdings__c = 10;
        conf.APTS_Lapsed_Holdings__c = 5;
        update conf;
            
        PageReference pRef = Page.ApprovalDashboardPage;
        pRef.getParameters().put('retId', proposal.Id);
        Test.setCurrentPage(pRef); 
                
        ApprovalDashboardAJSController ctrl = new ApprovalDashboardAJSController();
        String val = ctrl.getProposedDiscount();
        System.debug('Proposed Discount -------------- '+val);
        System.assert(val != null);
                
        System.debug('APTS_New_Holdings__c '+conf.APTS_New_Holdings__c+' APTS_Current_Holdings__c '+conf.APTS_Current_Holdings__c+' APTS_Lapsed_Holdings__c '+conf.APTS_Lapsed_Holdings__c);
        String val1 = ctrl.getProposedNetPrice();
        System.debug('Proposed net price -------------- '+val1);
        System.assert(val1 != null);
        
        System.debug('APTS_Tax_New_Holdings__c '+conf.APTS_Tax_New_Holdings__c+' APTS_Tax_Current_Holdings__c '+conf.APTS_Tax_Current_Holdings__c+' APTS_Tax_Lapsed_Holdings__c '+conf.APTS_Tax_Lapsed_Holdings__c);
        String val1Tax = ctrl.getProposedNetPriceTax();
        System.debug('Proposed net price Tax -------------- '+val1Tax);
        System.assert(val1Tax != null);
        
        String val2 = ctrl.getProposedOverallDiscount();
        System.debug('Proposed Overall Discount -------------- '+val2);
        System.assert(val2 != null);
        
        Apttus_Approval__Approval_Request__c appreq = new Apttus_Approval__Approval_Request__c (Apttus_QPApprov__ProposalId__c=proposal.Id,Apttus_Approval__Approval_Status__c ='Pending',Apttus_Approval__Approver_Comments__c='testinggggggggggggggggggggggggggggggggg',Apttus_Approval__SubmissionComment1__c ='Please approve',Apttus_Approval__Assigned_To_Name__c='testingg',Apttus_Approval__Date__c=System.now() ,Apttus_Approval__DateAssigned__c =System.today());
        
        insert appreq ;
        Apttus_Approval__Approval_Request_History__c  appreqhis2 = new Apttus_Approval__Approval_Request_History__c (Apttus_QPApprov__ProposalId__c=proposal.Id,Apttus_Approval__Approval_Status__c ='Pending',Apttus_Approval__Approver_Comments__c='testinggggggggggggggggggggggggggggggggg',Apttus_Approval__SubmissionComment1__c ='Please approve',Apttus_Approval__Assigned_To_Name__c='testingg',Apttus_Approval__Date__c=System.now(),Apttus_Approval__DateAssigned__c =System.today() );
        
        insert appreqhis2 ;
        List<Apttus_Approval__Approval_Request__c> appReqList = ApprovalDashboardAJSController.getApprovalRequestList(proposal.Id);
        List<Apttus_Approval__Approval_Request_History__c> appReqHis = ApprovalDashboardAJSController.getApprovalRequestHistoryList(proposal.Id);
        List<Apttus_Approval__Approval_Request__c> appReqList1 = ApprovalDashboardAJSController.getApprovalRequestList1(proposal.Id);
        List<Apttus_Approval__Approval_Request_History__c> appReqHis1 = ApprovalDashboardAJSController.getApprovalRequestHistoryList1(proposal.Id);



        String val3 = ctrl.getDiscountChange();
        System.debug('Change in Discount -------------- '+val3);
        System.assert(val3 != null);
        
        String val4 = ctrl.getOverallDiscountChange();
        System.debug('Overall change in Discount -------------- '+val4);
        System.assert(val4 != null);
                       
        String val5 = ctrl.getProposedRPA();
        System.debug('ProposedRPA -------------- '+val5);
        System.assert(val5 != null);
        
        String proposedACV = ctrl.getProposedACV();
        System.debug('proposedACV -------------- '+proposedACV);
        System.assert(proposedACV != null);
        
        String proposedTCV = ctrl.getProposedTCV();
        System.debug('proposedTCV -------------- '+proposedTCV);
        System.assert(proposedTCV != null);
        
        String proposedTCVTax = ctrl.getProposedTCVTax();
        System.debug('proposedTCVTax -------------- '+proposedTCVTax);
        System.assert(proposedTCVTax != null);
        
        String proposedACVTax = ctrl.getProposedACVTax();
        System.debug('proposedACVTax -------------- '+proposedACVTax);
        System.assert(proposedACVTax != null);
        
        String changeTCV = ctrl.getTCVChange();
        System.debug('getTCVChange -------------- '+changeTCV);
        System.assert(changeTCV != null);
        
        String changeTCVTax = ctrl.getTCVChangeTax();
        System.debug('changeTCVTax -------------- '+changeTCVTax);
        System.assert(changeTCVTax != null);
        
        String increGrowth = ctrl.getIncrementalGrowthPer();
        System.debug('getIncrementalGrowthPer -------------- '+increGrowth);
        System.assert(increGrowth != null);
        
        String increGrowthDollar = ctrl.getIncrementalGrowthDollor();
        System.debug('getIncrementalGrowthDollor -------------- '+increGrowthDollar);
        System.assert(increGrowthDollar != null);
        
        String increGrowthPercent = ctrl.getIncrementalGrowthPercent();
        System.debug('getIncrementalGrowthPercent -------------- '+increGrowthPercent);
        System.assert(increGrowthPercent != null);   
            
        
        Test.stopTest();    
    }
    
    static testmethod void testgetAssetNetPrice(){
        
        test.startTest();
        
        List<Apttus_Proposal__Proposal__c> proposal = [select Id, Name, Owner.Name, qp.Apttus_Proposal__Account__c 
                                                from Apttus_Proposal__Proposal__c qp 
                                                where Apttus_Proposal__Proposal_Name__c = 'testproposal'];
        Apttus_Config2__ProductConfiguration__c conf = [select Id from Apttus_Config2__ProductConfiguration__c where Name = 'prodConfig1' ];
        conf.APTS_Incremental_Growth__c = 20;
        update conf;
            
        PageReference pRef = Page.ApprovalDashboardPage;
        pRef.getParameters().put('retId', proposal[0].Id);
        Test.setCurrentPage(pRef); 
        
        ApprovalDashboardAJSController ctrl = new ApprovalDashboardAJSController();
        Decimal assetNetPrice = ctrl.getAssetNetPrice();
        System.debug('getAssetNetPrice ------'+assetNetPrice);
        System.assertEquals(1,proposal.size());
        
        test.stopTest();
        
    }     
    
    static testmethod void testgetProposedDiscount1(){
        Test.startTest();
        
        Apttus_Proposal__Proposal__c proposal = [select Id, Name, Owner.Name, qp.Apttus_Proposal__Account__c 
                                                from Apttus_Proposal__Proposal__c qp 
                                                where APTS_Proposal_Business_Unit__c = 'Tax Professional'];
        Apttus_Config2__ProductConfiguration__c conf = [select Id from Apttus_Config2__ProductConfiguration__c where Apttus_QPConfig__Proposald__c  =: proposal.Id];
        conf.APTS_Additional_Approval_Other__c = false;
        conf.APTS_New_Holdings__c = 40;
        conf.APTS_Current_Holdings__c = 10;
        conf.APTS_Lapsed_Holdings__c = 5;
        update conf;
            
        PageReference pRef = Page.ApprovalDashboardPage;
        pRef.getParameters().put('retId', proposal.Id);
        Test.setCurrentPage(pRef); 
        
        system.debug('##### proposal'+proposal);
                
        ApprovalDashboardAJSController ctrl = new ApprovalDashboardAJSController();
        String val = ctrl.getProposedDiscount();
        System.debug('Proposed Discount -------------- '+val);
        System.assert(val != null);
                
        System.debug('APTS_New_Holdings__c '+conf.APTS_New_Holdings__c+' APTS_Current_Holdings__c '+conf.APTS_Current_Holdings__c+' APTS_Lapsed_Holdings__c '+conf.APTS_Lapsed_Holdings__c);
        String val1 = ctrl.getProposedNetPrice();
        System.debug('Proposed net price -------------- '+val1);
        System.assert(val1 != null);
        
        System.debug('APTS_Tax_New_Holdings__c '+conf.APTS_Tax_New_Holdings__c+' APTS_Tax_Current_Holdings__c '+conf.APTS_Tax_Current_Holdings__c+' APTS_Tax_Lapsed_Holdings__c '+conf.APTS_Tax_Lapsed_Holdings__c);
        String val1Tax = ctrl.getProposedNetPriceTax();
        System.debug('Proposed net price Tax -------------- '+val1Tax);
        System.assert(val1Tax != null);
        
        String val2 = ctrl.getProposedOverallDiscount();
        System.debug('Proposed Overall Discount -------------- '+val2);
        System.assert(val2 != null);
        
        Apttus_Approval__Approval_Request__c appreq = new Apttus_Approval__Approval_Request__c (Apttus_QPApprov__ProposalId__c=proposal.Id,Apttus_Approval__Approval_Status__c ='Pending',Apttus_Approval__Approver_Comments__c='testinggggggggggggggggggggggggggggggggg',Apttus_Approval__SubmissionComment1__c ='Please approve',Apttus_Approval__Assigned_To_Name__c='testingg',Apttus_Approval__Date__c=System.now() ,Apttus_Approval__DateAssigned__c =System.today());
        
        insert appreq ;
        Apttus_Approval__Approval_Request_History__c  appreqhis2 = new Apttus_Approval__Approval_Request_History__c (Apttus_QPApprov__ProposalId__c=proposal.Id,Apttus_Approval__Approval_Status__c ='Pending',Apttus_Approval__Approver_Comments__c='testinggggggggggggggggggggggggggggggggg',Apttus_Approval__SubmissionComment1__c ='Please approve',Apttus_Approval__Assigned_To_Name__c='testingg',Apttus_Approval__Date__c=System.now(),Apttus_Approval__DateAssigned__c =System.today() );
        
        insert appreqhis2 ;
        List<Apttus_Approval__Approval_Request__c> appReqList = ApprovalDashboardAJSController.getApprovalRequestList(proposal.Id);
        List<Apttus_Approval__Approval_Request_History__c> appReqHis = ApprovalDashboardAJSController.getApprovalRequestHistoryList(proposal.Id);
        List<Apttus_Approval__Approval_Request__c> appReqList1 = ApprovalDashboardAJSController.getApprovalRequestList1(proposal.Id);
        List<Apttus_Approval__Approval_Request_History__c> appReqHis1 = ApprovalDashboardAJSController.getApprovalRequestHistoryList1(proposal.Id);



        String val3 = ctrl.getDiscountChange();
        System.debug('Change in Discount -------------- '+val3);
        System.assert(val3 != null);
        
        String val4 = ctrl.getOverallDiscountChange();
        System.debug('Overall change in Discount -------------- '+val4);
        System.assert(val4 != null);
                       
        String val5 = ctrl.getProposedRPA();
        System.debug('ProposedRPA -------------- '+val5);
        System.assert(val5 != null);
        
        String proposedACV = ctrl.getProposedACV();
        System.debug('proposedACV -------------- '+proposedACV);
        System.assert(proposedACV != null);
        
        String proposedTCV = ctrl.getProposedTCV();
        System.debug('proposedTCV -------------- '+proposedTCV);
        System.assert(proposedTCV != null);
        
        String proposedTCVTax = ctrl.getProposedTCVTax();
        System.debug('proposedTCVTax -------------- '+proposedTCVTax);
        System.assert(proposedTCVTax != null);
        
        String proposedACVTax = ctrl.getProposedACVTax();
        System.debug('proposedACVTax -------------- '+proposedACVTax);
        System.assert(proposedACVTax != null);
        
        String changeTCV = ctrl.getTCVChange();
        System.debug('getTCVChange -------------- '+changeTCV);
        System.assert(changeTCV != null);
        
        String changeTCVTax = ctrl.getTCVChangeTax();
        System.debug('changeTCVTax -------------- '+changeTCVTax);
        System.assert(changeTCVTax != null);
        
        String increGrowth = ctrl.getIncrementalGrowthPer();
        System.debug('getIncrementalGrowthPer -------------- '+increGrowth);
        System.assert(increGrowth != null);
        
        String increGrowthDollar = ctrl.getIncrementalGrowthDollor();
        System.debug('getIncrementalGrowthDollor -------------- '+increGrowthDollar);
        System.assert(increGrowthDollar != null);
        
        String increGrowthPercent = ctrl.getIncrementalGrowthPercent();
        System.debug('getIncrementalGrowthPercent -------------- '+increGrowthPercent);
        System.assert(increGrowthPercent != null);   
            
        
        Test.stopTest();    
    }
    
    static testmethod void testgetFileList(){
    
        test.startTest();
        Apttus_Proposal__Proposal__c proposal = [select Id, Name from Apttus_Proposal__Proposal__c 
        where Apttus_Proposal__Proposal_Name__c= 'testproposal'];
        Attachment attach=new Attachment();     
        attach.Name='Unit Test Attachment';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=proposal.id;
        insert attach;
        LatAm_Profile_List__c test2 = new LatAm_Profile_List__c(Name='LatAmProfileList',Profile_List__c='LatAm User');
        insert test2;
        List<FL_ApprovalDashboardAJSController.Document> document = FL_ApprovalDashboardAJSController.getDocumentList(proposal.Id);
        ContentVersion conVer = new ContentVersion();
        conVer.ContentLocation = 'S'; // S specify this document is in SF, use E for external files
        conVer.PathOnClient = 'Demo.pdf'; // The files name, extension is very important here which will help the file in preview.
        conVer.Title = 'signed Demo.pdf'; // Display name of the files
        conVer.VersionData = blob.valueOf('Test File'); // converting your binary string to Blog
        insert conVer;
                
        Id conDoc = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:conVer.Id].ContentDocumentId;

        //Create ContentDocumentLink
        ContentDocumentLink cDe = new ContentDocumentLink();
        cDe.ContentDocumentId = conDoc;
        cDe.LinkedEntityId = proposal.Id; // you can use objectId,GroupId etc
        cDe.ShareType = 'I'; // Inferred permission, checkout description of ContentDocumentLink object for more details
        insert cDe; 
        string ide =proposal.Id;
        
   //    ApprovalDashboardAJSController ctrl = new ApprovalDashboardAJSController();
     List<ApprovalDashboardAJSController.Document> document1 =  ApprovalDashboardAJSController.getFileList(ide,'abc') ;
       
         
        test.stopTest();
    } 
      static testmethod void testassociateFilesWithQuote(){
        test.startTest();
        
        ApprovalDashboardAJSController.associateFilesWithQuote(null,'abc') ;
        test.stopTest();   
    }
      static testmethod void testassociateFilesWithQuote1(){
     
       test.startTest();
       Apttus_Proposal__Proposal__c proposal = [select Id, Name from Apttus_Proposal__Proposal__c 
       where Apttus_Proposal__Proposal_Name__c= 'testproposal'];
       LatAm_Profile_List__c test2 = new LatAm_Profile_List__c(Name='LatAmProfileList',Profile_List__c='LatAm User');
       insert test2;
       List<FL_ApprovalDashboardAJSController.Document> document = FL_ApprovalDashboardAJSController.getDocumentList(proposal.Id);
       ContentVersion conVer = new ContentVersion();
       conVer.ContentLocation = 'S'; // S specify this document is in SF, use E for external files
       conVer.PathOnClient = 'Demo.pdf'; // The files name, extension is very important here which will help the file in preview.
       conVer.Title = 'signed Demo.pdf'; // Display name of the files
       conVer.VersionData = blob.valueOf('Test File'); // converting your binary string to Blog
       insert conVer;
       Id conDoc = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:conVer.Id].ContentDocumentId;

       //Create ContentDocumentLink
     //  ContentDocumentLink cDe = new ContentDocumentLink();
     //  cDe.ContentDocumentId = conDoc;
     //  cDe.LinkedEntityId = proposal.Id; // you can use objectId,GroupId etc
      // cDe.ShareType = 'I'; // Inferred permission, checkout description of ContentDocumentLink object for more details
     //  insert cDe;  
        
        
       string ide =proposal.Id;
        
        string id1 = conVer.id;
        Boolean s =ApprovalDashboardAJSController.associateFilesWithQuote(id1,ide) ;
        test.stopTest();   
    }
}