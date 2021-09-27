@isTest
private class APTS_LineItemTriggerTest {
    
    static testMethod void bridgeApprovalTest() {
        List<KeyValueListStore__c> keyvaluestoreList = new List<KeyValueListStore__c>();
        KeyValueListStore__c keyvaluestore=new  KeyValueListStore__c();
        keyvaluestore.Name='ANZUsersProfileId';
        keyvaluestore.TextValue__c=System.Label.APTS_OC_Test_Id;
        keyvaluestoreList.add(keyvaluestore); 
        KeyValueListStore__c keyval = new KeyValueListStore__c();
        keyval.Name='ReasonWithCompetitor';
        keyval.TextValue__c='Price';
        keyvaluestoreList.add(keyval);
        insert keyvaluestoreList;
        
        WebServiceSettings__c oWebServiceSettings = new WebServiceSettings__c();
        oWebServiceSettings.Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable'; 
        oWebServiceSettings.Name = 'PaymentCreditIncrease'; 
        oWebServiceSettings.Timeout__c = 120; 
        oWebServiceSettings.Endpoint__c = 'https://dev.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease'; 
        oWebServiceSettings.Active__c = true;
        insert oWebServiceSettings;
        List<WebServiceSettings__c> webserviceList = new List<WebServiceSettings__c>{new WebServiceSettings__c(Name='EnterpriseWSDL',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
           new WebServiceSettings__c(Name='StatusPostbackLocation',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
           new WebServiceSettings__c(Name='PostbackLocation',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
           new WebServiceSettings__c(Name='Payment AutoCharge',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available')};
        insert WebserviceList;
        //Inserting recordLists
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
        
        List<APTS_Segment_Threshold__c> segthrList= new List<APTS_Segment_Threshold__c>();
        //Add Segment threshold
        APTS_Segment_Threshold__c seg1 = new APTS_Segment_Threshold__c();
        seg1.APTS_Approval_Required__c=True;
        seg1.APTS_Segment__c='Small Law';
        seg1.APTS_Customer_Category__c='5';
        seg1.APTS_Term_in_years__c=Integer.ValueOf('2');
        seg1.APTS_Minimum_OY_Increase__c=Integer.ValueOf('15');
        seg1.APTS_Minimum_Incremental_Growth__c=Integer.ValueOf('15');
        seg1.APTS_Product_Family__c = 'CLEAR';
        seg1.APTS_Promo_Codes__c = '13843014';
        seg1.APTS_Promo_Minimum_OY_Increase__c = 17;        
        segthrList.add(seg1);
        
        APTS_Segment_Threshold__c seg2 = new APTS_Segment_Threshold__c();
        seg2.APTS_Approval_Required__c=True;
        seg2.APTS_Segment__c='Corporate';
        seg2.APTS_Customer_Category__c='5';
        seg2.APTS_Term_in_years__c=Integer.ValueOf('2');
        seg2.APTS_Minimum_OY_Increase__c=Integer.ValueOf('15');
        seg2.APTS_Minimum_Incremental_Growth__c=Integer.ValueOf('15');
        seg2.APTS_Product_Family__c = 'CLEAR';
        seg2.APTS_Promo_Codes__c = '13843013';
        seg2.APTS_Promo_Minimum_OY_Increase__c = 16;        
        segthrList.add(seg2);
                
        APTS_Segment_Threshold__c seg3 = new APTS_Segment_Threshold__c();
        seg3.APTS_Approval_Required__c=True;
        seg3.APTS_Segment__c='Corporate';
        seg3.APTS_Customer_Category__c='5';
        seg3.APTS_Term_in_years__c=Integer.ValueOf('2');
        seg3.APTS_Minimum_OY_Increase__c=Integer.ValueOf('15');
        seg3.APTS_Minimum_Incremental_Growth__c=Integer.ValueOf('15');
        segthrList.add(seg3);       
      
        APTS_Segment_Threshold__c seg4 = new APTS_Segment_Threshold__c();
        seg4.APTS_Approval_Required__c=True;
        seg4.APTS_Segment__c='Government';
        seg4.APTS_Customer_Category__c='5';
        seg4.APTS_Term_in_years__c=Integer.ValueOf('2');
        seg4.APTS_Minimum_OY_Increase__c=Integer.ValueOf('15');
        seg4.APTS_Minimum_Incremental_Growth__c=Integer.ValueOf('15');
        seg4.APTS_Product_Family__c = 'CLEAR';
        seg4.APTS_Promo_Codes__c = '13843012';
        seg4.APTS_Promo_Minimum_OY_Increase__c = 15;        
        segthrList.add(seg4);
        
        insert segthrList;
        
        Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
        Account a = new Account(RecordTypeId=accRecordTypeId,name='test-sg',sales_org__c='ABEP',customer_group__c='Academic',customer_type__c='Organization',customer_class_c__c='Academic Lecturer');
        a.APTS_Customer_Category__c = '5';
        a.Is_GLI__c = True;
        insert a;        
        
        Schema.DescribeFieldResult fieldResultMarket = Apttus_Config2__ProductConfiguration__c.APTS_AccountMirror_Picklist__c.getDescribe();
        String valueMarket = fieldResultMarket.getPicklistValues().get(0).getValue();
        
        //Inserting SourceSystemDetail
        List<Source_System_Detail__c> listOfSSD = new List<Source_System_Detail__c>();
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();
        
        Source_System_Detail__c accountSSD2= new Source_System_Detail__c();
        accountSSD2.RecordtypeId=ssdRecorType;
        accountSSD2.Name='ABC';
        accountSSD2.Source_System_Name__c='ABC';
        accountSSD2.Account_Name__c=a.ID;
        accountSSD2.APTS_Customer_Category__c='1';
        accountSSD2.LCRM_Customer_Group__c='Academic';
        accountSSD2.LCRM_Frozen_Market_Segment__c = valueMarket;
        accountSSD2.Account_Inactive__c=false;
        accountSSD2.LCRM_Sales_Org__c='WEST';
        accountSSD2.APTS_Has_Online_Assets__c=true;        
        listOfSSD.add(accountSSD2);
        insert listOfSSD;
        Profile p = [SELECT Id FROM profile WHERE name='System Administrator']; 
        User u1 = new User(alias = 'User_3', email='user@mydomain.com', 
        emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
        localesidkey='en_US', profileid = p.Id, employeenumber='0144020',
        timezonesidkey='America/Los_Angeles', username='user_3@mydomain.com',Sub_Bu__c='US');        
        insert u1;
        System.runAs(u1){
        Date todaysDate = system.today();
        Id oppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Pipeline Opportunity').getRecordTypeId();
        Opportunity o = new Opportunity(RecordTypeId=oppRecordTypeId,  Name='tst-opp', stagename='25%',closedate=todaysDate,forecastcategoryname='pipeline',accountId=a.id);
        insert o;
        System.assertEquals(o.Name,'tst-opp');
        
        List<Apttus_Proposal__Proposal__c > listofProposals=new List<Apttus_Proposal__Proposal__c >();
        Id devRecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Proposal').getRecordTypeId();
        Apttus_Proposal__Proposal__c p2 = new Apttus_Proposal__Proposal__c(RecordTypeId=devRecordTypeId, CurrencyIsoCode = 'USD', Apttus_Proposal__Account__c=a.id,
            Apttus_Proposal__Proposal_Name__c='Corporate Proposal for approval',  Apttus_Proposal__Opportunity__c=o.id, 
            Apttus_Proposal__Approval_Stage__c='Draft', Apttus_Proposal__Proposal_Category__c='Quote', Apttus_Proposal__ReadyToGenerate__c = true, 
            Apttus_Proposal__ReadyToPresent__c= true,APTS_SSD_Sold_To__c=accountSSD2.Id,APTS_SSD_ship_to__c=accountSSD2.Id,
            APTS_SSD_bill_to__c=accountSSD2.Id);
        p2.APTS_Proposal_Business_Unit__c = 'SCS';
        p2.APTS_Approval_Segment__c = 'Medium Law';
        listofProposals.add(p2);
        
        Apttus_Proposal__Proposal__c p3 = new Apttus_Proposal__Proposal__c(RecordTypeId=devRecordTypeId, CurrencyIsoCode = 'USD', Apttus_Proposal__Account__c=a.id,
            Apttus_Proposal__Proposal_Name__c='Corporate Proposal for approval',  Apttus_Proposal__Opportunity__c=o.id, 
            Apttus_Proposal__Approval_Stage__c='Draft', Apttus_Proposal__Proposal_Category__c='Quote', Apttus_Proposal__ReadyToGenerate__c = true, 
            Apttus_Proposal__ReadyToPresent__c= true,APTS_SSD_Sold_To__c=accountSSD2.Id,APTS_SSD_ship_to__c=accountSSD2.Id,
            APTS_SSD_bill_to__c=accountSSD2.Id);
        p3.APTS_Proposal_Business_Unit__c = 'SCS';
        p3.APTS_Approval_Segment__c = 'Government';
        listofProposals.add(p3);
        insert listofProposals;
        
        List<Apttus_Config2__ProductConfiguration__c> listofProdconfig = new List<Apttus_Config2__ProductConfiguration__c >();       
        Apttus_Config2__ProductConfiguration__c prodConf2 = new Apttus_Config2__ProductConfiguration__c(Name='prod-conf2', CurrencyIsoCode = 'USD', Apttus_QPConfig__Proposald__c=p2.id, APTS_SSD_ship_to__c=accountSSD2.Id,APTS_SSD_bill_to__c=accountSSD2.Id);
        listofProdconfig.add(prodConf2);
        Apttus_Config2__ProductConfiguration__c prodConf3 = new Apttus_Config2__ProductConfiguration__c(Name='prod-conf2', CurrencyIsoCode = 'USD', Apttus_QPConfig__Proposald__c=p3.id, APTS_SSD_ship_to__c=accountSSD2.Id,APTS_SSD_bill_to__c=accountSSD2.Id);
        listofProdconfig.add(prodConf3);
        insert listofProdconfig;
        
        List<Product2 > listofProd=new List<Product2 > ();
        Product2 prod2 = new Product2(name='prod1', Media_High_Level__c='Online', CurrencyIsoCode = 'USD',APTS_Media_High_Level_Code__c='06',APTS_Media_Lower_Level_Code__c='49',APTS_Cat_L2__c = System.Label.APTS_Print_Product_Family,APTS_CAT_L3__c='L3_L030_FP');
        prod2.APTS_Approval_Always_Required__c = true;
        listofProd.add( prod2);
        Product2 prod = new Product2(name='prod2', Media_High_Level__c='Online', CurrencyIsoCode = 'USD',APTS_Media_High_Level_Code__c='06',APTS_Media_Lower_Level_Code__c='49',APTS_CAT_L2__c=System.Label.APTS_Clear_Product_Family,APTS_CAT_L3__c='L3_L030_FP');
        prod.APTS_Approval_Always_Required__c = true;
        listofProd.add( prod);
        insert listofProd;
        Apttus_Config2__ConfigSystemProperties__c configSetting=new Apttus_Config2__ConfigSystemProperties__c(Name='System Properties',Apttus_Config2__DisableConstraintRules__c=true);
        insert configSetting;

        test.startTest();
        List<Apttus_Config2__LineItem__c> listOfLineItems = new List<Apttus_Config2__LineItem__c>();        
        
        Apttus_Config2__LineItem__c li6 = new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c=prodConf3.id , Apttus_Config2__ProductId__c=prod.id);
        li6.Apttus_Config2__AddedBy__c = 'User';
        li6.Apttus_Config2__AdjustedPrice__c = 50;
        li6.Apttus_Config2__AdjustmentAmount__c = 50;
        li6.Apttus_Config2__AdjustmentType__c = '% Discount';
        li6.Apttus_Config2__AllocateGroupAdjustment__c = TRUE;
        li6.Apttus_Config2__AllowableAction__c = 'Unrestricted';
        li6.Apttus_Config2__AllowManualAdjustment__c = TRUE;
        li6.Apttus_Config2__AllowProration__c = FALSE;
        li6.Apttus_Config2__AllowRemoval__c = TRUE;
        li6.Apttus_Config2__AutoRenew__c = FALSE;
        li6.Apttus_Config2__BaseExtendedCost__c = 0;
        li6.Apttus_Config2__BaseExtendedPrice__c = 100;
        li6.Apttus_Config2__BasePrice__c = 100;
        li6.Apttus_Config2__BasePriceMethod__c = 'Per Unit';
        li6.Apttus_Config2__BillingFrequency__c = 'Monthly';
        li6.Apttus_Config2__ChargeType__c = 'Subscription Fee';
        li6.Apttus_Config2__ConfigStatus__c = 'Complete';
        li6.Apttus_Config2__ConstraintCheckStatus__c = 'NA';
        li6.Apttus_Config2__Customizable__c = FALSE;
        li6.Apttus_Config2__DeltaPrice__c = 50;
        li6.Apttus_Config2__DeltaQuantity__c = 1;
        li6.Apttus_Config2__Description__c = 'Westlaw Flex Plan $100/500';
        li6.Apttus_Config2__ExtendedCost__c = 0;
        li6.Apttus_Config2__ExtendedPrice__c = 100;
        li6.Apttus_Config2__Frequency__c = 'Monthly';
        li6.Apttus_Config2__Guidance__c = 'Red';       
        li6.Apttus_Config2__IsPrimaryLine__c = TRUE;        
        li6.Apttus_Config2__ItemSequence__c = 1;
        li6.Apttus_Config2__LineNumber__c = 1;
        li6.Apttus_Config2__LineSequence__c = 1;
        li6.Apttus_Config2__LineStatus__c = 'New';
        li6.APTS_Yr_1_Renewal_Adjustment__c='1';
        li6.Apttus_Config2__LineType__c = 'Product/Service';
        li6.Apttus_Config2__ListPrice__c = 100;
        li6.Apttus_Config2__NetAdjustmentPercent__c = -50;
        li6.Apttus_Config2__NetPrice__c = 50;
        li6.Apttus_Config2__NetUnitPrice__c = 50;
        li6.Apttus_Config2__OptionSequence__c = 0;        
        li6.Apttus_Config2__PriceMethod__c = 'Per Unit';
        li6.Apttus_Config2__PriceType__c = 'Recurring';
        li6.Apttus_Config2__PriceUom__c = 'Attorneys';
        li6.Apttus_Config2__PricingStatus__c = 'Complete';       
        //li6.APTS_Cat_L2__c = System.Label.APTS_Clear_Product_Family;
        li6.Apttus_Config2__Quantity__c = 1;
        li6.Apttus_Config2__RollupPriceToBundle__c = TRUE;
        li6.Apttus_Config2__SellingFrequency__c = 'Monthly';
        li6.Apttus_Config2__SellingTerm__c = 1;        
        li6.Apttus_Config2__Taxable__c = FALSE;
        li6.Apttus_Config2__TaxInclusive__c = FALSE;
        li6.Apttus_Config2__Term__c = 1;
        li6.Apttus_Config2__TotalQuantity__c = 1;
        li6.Apttus_Config2__Uom__c = 'Each';        
        li6.CurrencyIsoCode = 'CAD';
        li6.APTS_Product_Family__c = 'CLEAR';
        li6.APTS_Contract_Term__c = '2 Years';
        li6.APTS_Years_2_Plus_Adjustment__c = '5';
        li6.Apttus_Config2__IncentiveCode__c = '13843012,13843012';
        li6.APTS_Bridge__c='1 Month';  
        listOfLineItems.add(li6);
        
        Apttus_Config2__LineItem__c li7 = new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c=prodConf2.id , Apttus_Config2__ProductId__c=prod.id);
        li7.Apttus_Config2__AddedBy__c = 'User';        
        li7.Apttus_Config2__BasePrice__c = 100;
        li7.Apttus_Config2__BasePriceMethod__c = 'Per Unit';
        li7.Apttus_Config2__BillingFrequency__c = 'Monthly';
        li7.Apttus_Config2__ChargeType__c = 'Subscription Fee';
        li7.Apttus_Config2__ConfigStatus__c = 'Complete';        
        li7.Apttus_Config2__Frequency__c = 'Monthly';        
        li7.Apttus_Config2__IsPrimaryLine__c = TRUE;        
        li7.Apttus_Config2__ItemSequence__c = 1;
        li7.Apttus_Config2__LineNumber__c = 1;
        li7.Apttus_Config2__LineSequence__c = 1;
        li7.Apttus_Config2__LineStatus__c = 'New';
        li7.APTS_Yr_1_Renewal_Adjustment__c='1';
        li7.Apttus_Config2__LineType__c = 'Product/Service';
        li7.Apttus_Config2__ListPrice__c = 100;        
        li7.Apttus_Config2__NetPrice__c = 50;
        li7.Apttus_Config2__NetUnitPrice__c = 50;        
        li7.Apttus_Config2__PriceMethod__c = 'Per Unit';
        li7.Apttus_Config2__PriceType__c = 'Recurring';
        li7.Apttus_Config2__PriceUom__c = 'Each';
        li7.Apttus_Config2__PricingStatus__c = 'Complete';
        li7.Apttus_Config2__PrimaryLineNumber__c = 1;
        li7.Apttus_Config2__ProductVersion__c = 1;        
        li7.Apttus_Config2__Quantity__c = 1;
        li7.Apttus_Config2__RollupPriceToBundle__c = TRUE;
        li7.Apttus_Config2__SellingFrequency__c = 'Monthly';
        li7.Apttus_Config2__SellingTerm__c = 1;                               
        li7.Apttus_Config2__TotalQuantity__c = 1;
        li7.Apttus_Config2__Uom__c = 'Each';
        li7.Apttus_CQApprov__Approval_Status__c = 'Pending Approval';
        li7.CurrencyIsoCode = 'USD';
        li7.APTS_Product_Family__c = 'CLEAR';
        li7.APTS_Contract_Term__c = '1 Year';
        li7.APTS_Years_2_Plus_Adjustment__c = '5';
        li7.APTS_Bridge__c = '2 Months';
        //li7.APTS_Cat_L2__c = System.Label.APTS_Clear_Product_Family;
        listOfLineItems.add(li7);
                
        Apttus_Config2__LineItem__c li8 = new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c=prodConf2.id , Apttus_Config2__ProductId__c=prod2.id);
        li8.Apttus_Config2__AddedBy__c = 'User';       
        li8.Apttus_Config2__BaseExtendedCost__c = 0;
        li8.Apttus_Config2__BaseExtendedPrice__c = 100;
        li8.Apttus_Config2__BasePrice__c = 100;
        li8.Apttus_Config2__BasePriceMethod__c = 'Per Unit';
        li8.Apttus_Config2__BillingFrequency__c = 'Monthly';
        li8.Apttus_Config2__ChargeType__c = 'Subscription Fee';
        li8.Apttus_Config2__ConfigStatus__c = 'Complete';
        li8.Apttus_Config2__ConstraintCheckStatus__c = 'NA';
        li8.Apttus_Config2__Customizable__c = FALSE;
        li8.Apttus_Config2__DeltaPrice__c = 50;
        li8.Apttus_Config2__DeltaQuantity__c = 1;
        li8.Apttus_Config2__Description__c = 'Westlaw Flex Plan $100/500';
        li8.Apttus_Config2__ExtendedCost__c = 0;
        li8.Apttus_Config2__ExtendedPrice__c = 100;
        li8.Apttus_Config2__Frequency__c = 'Monthly';
        li8.Apttus_Config2__Guidance__c = 'Red';       
        li8.Apttus_Config2__IsPrimaryLine__c = TRUE;        
        li8.Apttus_Config2__ItemSequence__c = 1;
        li8.Apttus_Config2__LineNumber__c = 1;
        li8.Apttus_Config2__LineSequence__c = 1;
        li8.Apttus_Config2__LineStatus__c = 'New';
        li8.APTS_Yr_1_Renewal_Adjustment__c='1';
        li8.Apttus_Config2__LineType__c = 'Product/Service';
        li8.Apttus_Config2__ListPrice__c = 100;
        li8.Apttus_Config2__NetAdjustmentPercent__c = -50;
        li8.Apttus_Config2__NetPrice__c = 50;
        li8.Apttus_Config2__NetUnitPrice__c = 50;
        li8.Apttus_Config2__OptionSequence__c = 0;        
        li8.Apttus_Config2__PriceMethod__c = 'Per Unit';
        li8.Apttus_Config2__PriceType__c = 'Recurring';
        li8.Apttus_Config2__PriceUom__c = 'Attorneys';
        li8.Apttus_Config2__PricingStatus__c = 'Complete';
        li8.Apttus_Config2__Quantity__c = 1;
        li8.Apttus_Config2__RollupPriceToBundle__c = TRUE;
        li8.Apttus_Config2__SellingFrequency__c = 'Monthly';
        li8.Apttus_Config2__SellingTerm__c = 1;        
        li8.Apttus_Config2__Taxable__c = FALSE;
        li8.Apttus_Config2__TaxInclusive__c = FALSE;
        li8.Apttus_Config2__Term__c = 1;
        li8.Apttus_Config2__TotalQuantity__c = 1;
        li8.Apttus_Config2__Uom__c = 'Each';        
        li8.CurrencyIsoCode = 'USD';
        li8.APTS_Product_Family__c = 'PRINT LEGAL SOLUTIONS';
        li8.APTS_Contract_Term__c = '2 Years';
        li8.APTS_Years_2_Plus_Adjustment__c = '5';        
        li8.APTS_Bridge__c='3 Months';  
        //li8.APTS_Cat_L2__c = System.Label.APTS_Print_Product_Family;                 
        listOfLineItems.add(li8);

        Apttus_Config2__LineItem__c li9 = new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c=prodConf2.id , Apttus_Config2__ProductId__c=prod.id);
        li9.Apttus_Config2__AddedBy__c = 'User';
        li9.Apttus_Config2__AdjustedPrice__c = 50;
        li9.Apttus_Config2__AdjustmentAmount__c = 50;
        li9.Apttus_Config2__AdjustmentType__c = '% Discount';
        li9.Apttus_Config2__AllocateGroupAdjustment__c = TRUE;
        li9.Apttus_Config2__AllowableAction__c = 'Unrestricted';
        li9.Apttus_Config2__AllowManualAdjustment__c = TRUE;
        li9.Apttus_Config2__AllowProration__c = FALSE;
        li9.Apttus_Config2__AllowRemoval__c = TRUE;
        li9.Apttus_Config2__AutoRenew__c = FALSE;
        li9.Apttus_Config2__BaseExtendedCost__c = 0;
        li9.Apttus_Config2__BaseExtendedPrice__c = 100;
        li9.Apttus_Config2__BasePrice__c = 100;
        li9.Apttus_Config2__BasePriceMethod__c = 'Per Unit';
        li9.Apttus_Config2__BillingFrequency__c = 'Monthly';
        li9.Apttus_Config2__ChargeType__c = 'Subscription Fee';
        li9.Apttus_Config2__ConfigStatus__c = 'Complete';
        li9.Apttus_Config2__ConstraintCheckStatus__c = 'NA';
        li9.Apttus_Config2__Customizable__c = FALSE;
        li9.Apttus_Config2__DeltaPrice__c = 50;
        li9.Apttus_Config2__DeltaQuantity__c = 1;
        li9.Apttus_Config2__Description__c = 'Westlaw Flex Plan $100/500';
        li9.Apttus_Config2__ExtendedCost__c = 0;
        li9.Apttus_Config2__ExtendedPrice__c = 100;
        li9.Apttus_Config2__Frequency__c = 'Monthly';
        li9.Apttus_Config2__Guidance__c = 'Red';       
        li9.Apttus_Config2__IsPrimaryLine__c = TRUE;        
        li9.Apttus_Config2__ItemSequence__c = 1;
        li9.Apttus_Config2__LineNumber__c = 1;
        li9.Apttus_Config2__LineSequence__c = 1;
        li9.Apttus_Config2__LineStatus__c = 'New';
        li9.APTS_Yr_1_Renewal_Adjustment__c='1';
        li9.Apttus_Config2__LineType__c = 'Product/Service';
        li9.Apttus_Config2__ListPrice__c = 100;
        li9.Apttus_Config2__NetAdjustmentPercent__c = -50;
        li9.Apttus_Config2__NetPrice__c = 50;
        li9.Apttus_Config2__NetUnitPrice__c = 50;
        li9.Apttus_Config2__OptionSequence__c = 0;        
        li9.Apttus_Config2__PriceMethod__c = 'Per Unit';
        li9.Apttus_Config2__PriceType__c = 'Recurring';
        li9.Apttus_Config2__PriceUom__c = 'Attorneys';
        li9.Apttus_Config2__PricingStatus__c = 'Complete';               
        li9.Apttus_Config2__Quantity__c = 1;
        li9.Apttus_Config2__RollupPriceToBundle__c = TRUE;
        li9.Apttus_Config2__SellingFrequency__c = 'Monthly';
        li9.Apttus_Config2__SellingTerm__c = 1;        
        li9.Apttus_Config2__Taxable__c = FALSE;
        li9.Apttus_Config2__TaxInclusive__c = FALSE;
        li9.Apttus_Config2__Term__c = 1;
        li9.Apttus_Config2__TotalQuantity__c = 1;
        li9.Apttus_Config2__Uom__c = 'Each';        
        li9.CurrencyIsoCode = 'USD';
        li9.APTS_Product_Family__c = 'CLEAR';
        li9.APTS_Contract_Term__c = '1 Year';
        li9.APTS_Years_2_Plus_Adjustment__c = '5';        
        li9.APTS_Bridge__c='2 Months'; 
        //li9.APTS_Cat_L2__c=System.Label.APTS_Clear_Product_Family;                  
        listOfLineItems.add(li9);
        
        Apttus_Config2__LineItem__c li10 = new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c=prodConf2.id , Apttus_Config2__ProductId__c=prod.id);
        li10.Apttus_Config2__AddedBy__c = 'User';
        li10.Apttus_Config2__AdjustedPrice__c = 50;
        li10.Apttus_Config2__AdjustmentAmount__c = 50;
        li10.Apttus_Config2__AdjustmentType__c = '% Discount';
        li10.Apttus_Config2__AllocateGroupAdjustment__c = TRUE;
        li10.Apttus_Config2__AllowableAction__c = 'Unrestricted';
        li10.Apttus_Config2__AllowManualAdjustment__c = TRUE;
        li10.Apttus_Config2__AllowProration__c = FALSE;
        li10.Apttus_Config2__AllowRemoval__c = TRUE;
        li10.Apttus_Config2__AutoRenew__c = FALSE;
        li10.Apttus_Config2__BaseExtendedCost__c = 0;
        li10.Apttus_Config2__BaseExtendedPrice__c = 100;
        li10.Apttus_Config2__BasePrice__c = 100;
        li10.Apttus_Config2__BasePriceMethod__c = 'Per Unit';
        li10.Apttus_Config2__BillingFrequency__c = 'Monthly';
        li10.Apttus_Config2__ChargeType__c = 'Subscription Fee';
        li10.Apttus_Config2__ConfigStatus__c = 'Complete';
        li10.Apttus_Config2__ConstraintCheckStatus__c = 'NA';
        li10.Apttus_Config2__Customizable__c = FALSE;
        li10.Apttus_Config2__DeltaPrice__c = 50;
        li10.Apttus_Config2__DeltaQuantity__c = 1;
        li10.Apttus_Config2__Description__c = 'Westlaw Flex Plan $100/500';
        li10.Apttus_Config2__ExtendedCost__c = 0;
        li10.Apttus_Config2__ExtendedPrice__c = 100;
        li10.Apttus_Config2__Frequency__c = 'Monthly';
        li10.Apttus_Config2__Guidance__c = 'Red';       
        li10.Apttus_Config2__IsPrimaryLine__c = TRUE;        
        li10.Apttus_Config2__ItemSequence__c = 1;
        li10.Apttus_Config2__LineNumber__c = 1;
        li10.Apttus_Config2__LineSequence__c = 1;
        li10.Apttus_Config2__LineStatus__c = 'New';
        li10.APTS_Yr_1_Renewal_Adjustment__c='1';
        li10.Apttus_Config2__LineType__c = 'Product/Service';
        li10.Apttus_Config2__ListPrice__c = 100;
        li10.Apttus_Config2__NetAdjustmentPercent__c = -50;
        li10.Apttus_Config2__NetPrice__c = 50;
        li10.Apttus_Config2__NetUnitPrice__c = 50;
        li10.Apttus_Config2__OptionSequence__c = 0;        
        li10.Apttus_Config2__PriceMethod__c = 'Per Unit';
        li10.Apttus_Config2__PriceType__c = 'Recurring';
        li10.Apttus_Config2__PriceUom__c = 'Attorneys';
        li10.Apttus_Config2__PricingStatus__c = 'Complete';               
        li10.Apttus_Config2__Quantity__c = 1;
        li10.Apttus_Config2__RollupPriceToBundle__c = TRUE;
        li10.Apttus_Config2__SellingFrequency__c = 'Monthly';
        li10.Apttus_Config2__SellingTerm__c = 1;        
        li10.Apttus_Config2__Taxable__c = FALSE;
        li10.Apttus_Config2__TaxInclusive__c = FALSE;
        li10.Apttus_Config2__Term__c = 1;
        li10.Apttus_Config2__TotalQuantity__c = 1;
        li10.Apttus_Config2__Uom__c = 'Each';        
        li10.CurrencyIsoCode = 'USD';
        li10.APTS_Product_Family__c = 'CLEAR';
        li10.APTS_Contract_Term__c = '1 Year';
        li10.APTS_Years_2_Plus_Adjustment__c = '5';        
        li10.APTS_Bridge__c='2 Months';   
        li10.APTS_New_Bridge_Discount__c=100;  
        //li10.APTS_Cat_L2__c=System.Label.APTS_Clear_Product_Family;
        listOfLineItems.add(li10);
      
        Apttus_Config2__LineItem__c li12 = new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c=prodConf2.id , Apttus_Config2__ProductId__c=prod.id);
        li12.Apttus_Config2__AddedBy__c = 'User';
        li12.Apttus_Config2__AdjustedPrice__c = 50;
        li12.Apttus_Config2__AdjustmentAmount__c = 50;
        li12.Apttus_Config2__AdjustmentType__c = '% Discount';
        li12.Apttus_Config2__AllocateGroupAdjustment__c = TRUE;
        li12.Apttus_Config2__AllowableAction__c = 'Unrestricted';
        li12.Apttus_Config2__AllowManualAdjustment__c = TRUE;
        li12.Apttus_Config2__AllowProration__c = FALSE;
        li12.Apttus_Config2__AllowRemoval__c = TRUE;
        li12.Apttus_Config2__AutoRenew__c = FALSE;
        li12.Apttus_Config2__BaseExtendedCost__c = 0;
        li12.Apttus_Config2__BaseExtendedPrice__c = 100;
        li12.Apttus_Config2__BasePrice__c = 100;
        li12.Apttus_Config2__BasePriceMethod__c = 'Per Unit';
        li12.Apttus_Config2__BillingFrequency__c = 'Monthly';
        li12.Apttus_Config2__ChargeType__c = 'Subscription Fee';
        li12.Apttus_Config2__ConfigStatus__c = 'Complete';
        li12.Apttus_Config2__ConstraintCheckStatus__c = 'NA';
        li12.Apttus_Config2__Customizable__c = FALSE;
        li12.Apttus_Config2__DeltaPrice__c = 50;
        li12.Apttus_Config2__DeltaQuantity__c = 1;
        li12.Apttus_Config2__Description__c = 'Westlaw Flex Plan $100/500';
        li12.Apttus_Config2__ExtendedCost__c = 0;
        li12.Apttus_Config2__ExtendedPrice__c = 100;
        li12.Apttus_Config2__Frequency__c = 'Monthly';
        li12.Apttus_Config2__Guidance__c = 'Red';       
        li12.Apttus_Config2__IsPrimaryLine__c = TRUE;        
        li12.Apttus_Config2__ItemSequence__c = 1;
        li12.Apttus_Config2__LineNumber__c = 1;
        li12.Apttus_Config2__LineSequence__c = 1;
        li12.Apttus_Config2__LineStatus__c = 'New';
        li12.APTS_Yr_1_Renewal_Adjustment__c='1';
        li12.Apttus_Config2__LineType__c = 'Product/Service';
        li12.Apttus_Config2__ListPrice__c = 100;
        li12.Apttus_Config2__NetAdjustmentPercent__c = -50;
        li12.Apttus_Config2__NetPrice__c = 50;
        li12.Apttus_Config2__NetUnitPrice__c = 50;
        li12.Apttus_Config2__OptionSequence__c = 0;        
        li12.Apttus_Config2__PriceMethod__c = 'Per Unit';
        li12.Apttus_Config2__PriceType__c = 'Recurring';
        li12.Apttus_Config2__PriceUom__c = 'Attorneys';
        li12.Apttus_Config2__PricingStatus__c = 'Complete';               
        li12.Apttus_Config2__Quantity__c = 1;
        li12.Apttus_Config2__RollupPriceToBundle__c = TRUE;
        li12.Apttus_Config2__SellingFrequency__c = 'Monthly';
        li12.Apttus_Config2__SellingTerm__c = 1;        
        li12.Apttus_Config2__Taxable__c = FALSE;
        li12.Apttus_Config2__TaxInclusive__c = FALSE;
        li12.Apttus_Config2__Term__c = 1;
        li12.Apttus_Config2__TotalQuantity__c = 1;
        li12.Apttus_Config2__Uom__c = 'Each';        
        li12.CurrencyIsoCode = 'USD';
        li12.APTS_Product_Family__c = 'CLEAR';
        li12.APTS_Contract_Term__c = '1 Year';
        li12.APTS_Years_2_Plus_Adjustment__c = '5';        
        li12.APTS_Bridge__c='1 Month';   
        li12.APTS_New_Bridge_Discount__c=100;  
        //li12.APTS_Cat_L2__c=System.Label.APTS_Clear_Product_Family;              
        listOfLineItems.add(li12);
        Apttus_Config2__LineItem__c li11 = new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c=prodConf2.id , Apttus_Config2__ProductId__c=prod.id);
        li11.Apttus_Config2__AddedBy__c = 'User';
        li11.Apttus_Config2__AdjustedPrice__c = 50;
        li11.Apttus_Config2__AdjustmentAmount__c = 50;
        li11.Apttus_Config2__AdjustmentType__c = '% Discount';
        li11.Apttus_Config2__AllocateGroupAdjustment__c = TRUE;
        li11.Apttus_Config2__AllowableAction__c = 'Unrestricted';
        li11.Apttus_Config2__AllowManualAdjustment__c = TRUE;
        li11.Apttus_Config2__AllowProration__c = FALSE;
        li11.Apttus_Config2__AllowRemoval__c = TRUE;
        li11.Apttus_Config2__AutoRenew__c = FALSE;
        li11.Apttus_Config2__BaseExtendedCost__c = 0;
        li11.Apttus_Config2__BaseExtendedPrice__c = 100;
        li11.Apttus_Config2__BasePrice__c = 100;
        li11.Apttus_Config2__BasePriceMethod__c = 'Per Unit';
        li11.Apttus_Config2__BillingFrequency__c = 'Monthly';
        li11.Apttus_Config2__ChargeType__c = 'Subscription Fee';
        li11.Apttus_Config2__ConfigStatus__c = 'Complete';
        li11.Apttus_Config2__ConstraintCheckStatus__c = 'NA';
        li11.Apttus_Config2__Customizable__c = FALSE;
        li11.Apttus_Config2__DeltaPrice__c = 50;
        li11.Apttus_Config2__DeltaQuantity__c = 1;
        li11.Apttus_Config2__Description__c = 'Westlaw Flex Plan $100/500';
        li11.Apttus_Config2__ExtendedCost__c = 0;
        li11.Apttus_Config2__ExtendedPrice__c = 100;
        li11.Apttus_Config2__Frequency__c = 'Monthly';
        li11.Apttus_Config2__Guidance__c = 'Red';       
        li11.Apttus_Config2__IsPrimaryLine__c = TRUE;        
        li11.Apttus_Config2__ItemSequence__c = 1;
        li11.Apttus_Config2__LineNumber__c = 1;
        li11.Apttus_Config2__LineSequence__c = 1;
        li11.Apttus_Config2__LineStatus__c = 'Cancelled';
        li11.APTS_Yr_1_Renewal_Adjustment__c='1';
        li11.Apttus_Config2__LineType__c = 'Product/Service';
        li11.Apttus_Config2__ListPrice__c = 100;
        li11.Apttus_Config2__NetAdjustmentPercent__c = -50;
        li11.Apttus_Config2__NetPrice__c = 50;
        li11.Apttus_Config2__NetUnitPrice__c = 50;
        li11.Apttus_Config2__OptionSequence__c = 0;        
        li11.Apttus_Config2__PriceMethod__c = 'Per Unit';
        li11.Apttus_Config2__PriceType__c = 'Recurring';
        li11.Apttus_Config2__PriceUom__c = 'Attorneys';
        li11.Apttus_Config2__PricingStatus__c = 'Complete';               
        li11.Apttus_Config2__Quantity__c = 1;
        li11.Apttus_Config2__RollupPriceToBundle__c = TRUE;
        li11.Apttus_Config2__SellingFrequency__c = 'Monthly';
        li11.Apttus_Config2__SellingTerm__c = 1;        
        li11.Apttus_Config2__Taxable__c = FALSE;
        li11.Apttus_Config2__TaxInclusive__c = FALSE;
        li11.Apttus_Config2__Term__c = 1;
        li11.Apttus_Config2__TotalQuantity__c = 1;
        li11.Apttus_Config2__Uom__c = 'Each';        
        li11.CurrencyIsoCode = 'USD';
        li11.APTS_Product_Family__c = 'CLEAR';
        li11.APTS_Contract_Term__c = '1 Year';
        li11.APTS_Years_2_Plus_Adjustment__c = '5';        
        li11.APTS_Bridge__c='1 Month';   
        li11.APTS_New_Bridge_Discount__c=100;  
        //li11.APTS_Cat_L2__c=System.Label.APTS_Clear_Product_Family;              
        listOfLineItems.add(li11);
        insert listOfLineItems;        
        
             
        li7.APTS_Contract_Term__c= '1 Year';
        li7.APTS_Bridge__c='6 Months';       
        li8.APTS_Contract_Term__c = '2 Years';
        li8.APTS_Bridge__c='3 Months';  
        li9.APTS_Contract_Term__c = '5 Years';
        li9.APTS_Bridge__c='3 Months';
        li11.APTS_Bridge__c='3 Months';                
        update listOfLineItems;
        APTS_LineItemTriggerHelper.populateAllApprovalRequiredCB(listOfLineItems);
        Test.stopTest();
        }        
    }
   // This test method tests the calculation of incremental growth
static testMethod void validateIncrementalGrowth() {
        
        WebServiceSettings__c oWebServiceSettings = new WebServiceSettings__c(
            Active__c = true,
            Name = 'Payment AutoCharge',
            Service_Unavailable_Message__c = 'Auto Payment Service is Currently unavailable',        
            Endpoint__c = 'https://stg.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentAutoCharge');
        insert oWebServiceSettings ;
        
        WebServiceSettings__c o1WebServiceSettings = new WebServiceSettings__c(
            Active__c = true,
            Name = 'PaymentCreditIncrease',
            Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable',        
            Endpoint__c = 'https://qa.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease');
        insert o1WebServiceSettings ;
        
        Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
        
        Apttus_Config2__PriceList__c priceList = APTS_TestDataFactory.createPriceList('Thomson Reuters Master - US Legal');
        insert priceList;        
        
        Schema.DescribeFieldResult fieldResultMarket = Apttus_Config2__ProductConfiguration__c.APTS_AccountMirror_Picklist__c.getDescribe();
        String valueMarket = fieldResultMarket.getPicklistValues().get(0).getValue();
        
        Account a = new Account(RecordTypeId=accRecordTypeId,FrozenMarketSegment__c = valueMarket,name='test-sg',sales_org__c='ABEP',customer_group__c='Academic',customer_type__c='Organization',customer_class_c__c='Academic Lecturer');
        a.APTS_Customer_Category__c = '';
        a.Is_GLI__c = True;
        insert a;
        
        //Inserting SourceSystemDetail
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();
        List<Source_System_Detail__c> ssdList = new List<Source_System_Detail__c>();
        Source_System_Detail__c accountSSD= new Source_System_Detail__c();
        accountSSD.RecordtypeId=ssdRecorType;
        accountSSD.Name='ABC';
        accountSSD.Source_System_Name__c='ABC';
        accountSSD.Account_Name__c=a.ID;
        accountSSD.APTS_Customer_Category__c='1';
        accountSSD.LCRM_Customer_Group__c='Academic';
        accountSSD.LCRM_Frozen_Market_Segment__c = valueMarket;
        accountSSD.Account_Inactive__c=false;
        accountSSD.LCRM_Sales_Org__c='WEST';
        accountSSD.APTS_Has_Online_Assets__c=true;
        ssdList.add(accountSSD);
        
        Source_System_Detail__c accountSSD1= new Source_System_Detail__c();
        accountSSD1.RecordtypeId=ssdRecorType;
        accountSSD1.Name='ABC';
        accountSSD1.Source_System_Name__c='ABC';
        accountSSD1.Account_Name__c=a.ID;
        accountSSD1.APTS_Customer_Category__c='1';
        accountSSD1.LCRM_Customer_Group__c='Academic';
        accountSSD1.LCRM_Frozen_Market_Segment__c = valueMarket;
        accountSSD1.Account_Inactive__c=false;
        accountSSD1.LCRM_Sales_Org__c='S100';
        accountSSD1.APTS_Has_Online_Assets__c=true;
        ssdList.add(accountSSD1);
        
        insert ssdList;
        
        //Added by Chirag 1/10/18
        /*Apttus_Config2__AssetLineItem__c asset = new Apttus_Config2__AssetLineItem__c(Name = 'Test asset', APTS_Info_PlanType__c = 'S00', 
        Apttus_Config2__NetPrice__c = 10.00, APTS_SSD_Bill_To__c = accountSSD.Id,
        APTS_Info_RenewalDate__c = System.today().addDays(150));
        insert asset; */
        
        Profile prof = [SELECT Id FROM Profile WHERE Name='System Administrator'];   
        
        User u = new User(Alias = 'sattudt', Email='sattu@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='chan', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = prof.Id,
                          TimeZoneSidKey='America/Los_Angeles', UserName='sattu@testorg.com', Sub_Bu__c = 'LMS');
        insert u; 
        
        //Inserting KeyValueStore
        List<KeyValueListStore__c> keyvaluestoreList = new List<KeyValueListStore__c>();
        KeyValueListStore__c keyvaluestore=new  KeyValueListStore__c();
        keyvaluestore.Name='ANZUsersProfileId';
        keyvaluestore.TextValue__c=System.Label.APTS_OC_Test_Id;
        keyvaluestoreList.add(keyvaluestore); 
        KeyValueListStore__c keyval = new KeyValueListStore__c();
        keyval.Name='ReasonWithCompetitor';
        keyval.TextValue__c='Price';
        keyvaluestoreList.add(keyval);
        insert keyvaluestoreList;
        
        //Inserting recordLists
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
                
        Date todaysDate = system.today();
        Id oppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Pipeline Opportunity').getRecordTypeId();
        Opportunity o = new Opportunity(RecordTypeId=oppRecordTypeId,  Name='tst-opp', stagename='25%',closedate=todaysDate,forecastcategoryname='pipeline',accountId=a.id,Source_System_Detail__c=accountSSD.id);
        insert o;
        
        Id devRecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Proposal').getRecordTypeId();
        List<Apttus_Proposal__Proposal__c> proposalList = new List<Apttus_Proposal__Proposal__c >();
        Apttus_Proposal__Proposal__c p = new Apttus_Proposal__Proposal__c(RecordTypeId=devRecordTypeId, CurrencyIsoCode = 'USD', Apttus_Proposal__Proposal_Name__c='TST-10', Apttus_Proposal__Opportunity__c=o.id, Apttus_Proposal__Approval_Stage__c='Draft', Apttus_Proposal__Proposal_Category__c='Quote', Apttus_Proposal__ReadyToGenerate__c = true, Apttus_Proposal__ReadyToPresent__c= true,APTS_SSD_Sold_To__c=accountSSD.Id,APTS_SSD_ship_to__c=accountSSD.Id,APTS_SSD_bill_to__c=accountSSD.Id,APTS_Proposal_Business_Unit__c ='Tax Professional');
        p.APTS_Approval_Segment__c = 'Medium Law';
        p.APTS_LMS_Catalog__c =  True;
        proposalList.add(p);
        
        Apttus_Proposal__Proposal__c p1 = new Apttus_Proposal__Proposal__c(RecordTypeId=devRecordTypeId, CurrencyIsoCode = 'USD', Apttus_Proposal__Proposal_Name__c='TST-11', Apttus_Proposal__Opportunity__c=o.id, Apttus_Proposal__Approval_Stage__c='Draft', Apttus_Proposal__Proposal_Category__c='Quote', Apttus_Proposal__ReadyToGenerate__c = true, Apttus_Proposal__ReadyToPresent__c= true,APTS_SSD_Sold_To__c=accountSSD1.Id,APTS_SSD_ship_to__c=accountSSD1.Id,APTS_SSD_bill_to__c=accountSSD1.Id,APTS_Proposal_Business_Unit__c ='SCS');
        //p.APTS_Approval_Segment__c = 'Medium Law';
        p1.APTS_LMS_Catalog__c = True;
        proposalList.add(p1);
        insert proposalList;
        system.debug(' p PBU = '+p.APTS_Proposal_Business_Unit__c);
        system.debug(' p1 PBU = '+p1.APTS_Proposal_Business_Unit__c);
        
        List<Apttus_Config2__ProductConfiguration__c> pconfigList = new List<Apttus_Config2__ProductConfiguration__c >();
        Apttus_Config2__ProductConfiguration__c prodConf = new Apttus_Config2__ProductConfiguration__c(Name='prod-conf1', CurrencyIsoCode = 'USD', Apttus_QPConfig__Proposald__c=p.id,APTS_SSD_ship_to__c=accountSSD.Id,APTS_SSD_bill_to__c=accountSSD.Id);
        pconfigList.add(prodConf);
        
        Apttus_Config2__ProductConfiguration__c prodConf1 = new Apttus_Config2__ProductConfiguration__c(Name='prod-conf1', CurrencyIsoCode = 'USD', Apttus_QPConfig__Proposald__c=p1.id,APTS_SSD_ship_to__c=accountSSD1.Id,APTS_SSD_bill_to__c=accountSSD1.Id);
        pconfigList.add(prodConf1);
        insert pconfigList;
        System.debug('Config1 PBU'+prodConf1.APTS_Proposal_Business_Unit__c);
        Product2    prod = new Product2(name='prod1', Media_High_Level__c='Online', CurrencyIsoCode = 'USD',APTS_Cat_L3__c = System.Label.APTS_Ediscovery_Product_Family, Family = 'Ediscovery Point',APTS_CAT_L2__c='L3_L030_FP');
        Product2 prodlog = new Product2(name='prod1', Media_High_Level__c='Online', CurrencyIsoCode = 'USD',APTS_Cat_L3__c = System.Label.APTS_Case_Logistix_Product_Family,APTS_CAT_L2__c='L3_L030_FP');

        Product2 prod1 = new Product2(name='prod2', Media_High_Level__c='Online', CurrencyIsoCode = 'USD',APTS_Media_High_Level_Code__c='05',APTS_Media_Lower_Level_Code__c='E2',APTS_CAT_L2__c='L3_L030_FP');
        prod1.APTS_Approval_Always_Required__c = true;

        Product2 prod2 = new Product2(name='prod3', Media_High_Level__c='Online', CurrencyIsoCode = 'USD',APTS_Cat_L2__c='L2_L012_FP',Family='CLEAR',APTS_Cat_L3__c='L3_L033_FP');
        prod2.APTS_Approval_Always_Required__c = true;
        
        Product2 prod3 = new Product2(name='prod4', Media_High_Level__c='Online', CurrencyIsoCode = 'USD',APTS_Cat_L2__c=System.Label.APTS_Proview_Product_Family,Family='CLEAR',APTS_Cat_L3__c='L3_L033_FP');
        prod3.APTS_Approval_Always_Required__c = true;
        Product2 prod4 = new Product2(name='prod5', Media_High_Level__c='Online', CurrencyIsoCode = 'USD',APTS_Cat_L2__c=System.Label.APTS_Proview_Product_Family,Family='CLEAR',APTS_Cat_L3__c='L3_L033_FP');
        prod4.APTS_Approval_Always_Required__c = true;
        Product2  prod5 = new Product2(name='prod6', Media_High_Level__c='Online', CurrencyIsoCode = 'USD',APTS_Media_High_Level_Code__c='05',APTS_Cat_L3__c = System.Label.APTS_Case_Logistix_Product_Family, Family = 'Ediscovery Point',APTS_CAT_L2__c='L3_L030_FP');
        
        List<Product2> prdlist = new List<Product2>{prod,prod1,prod2,prod3,prod5};
        insert prdlist;
        
        //Apttus_Config2__ConfigSystemProperties__c configSetting = [SELECT Id, Name, Apttus_Config2__DisableConstraintRules__c FROM Apttus_Config2__ConfigSystemProperties__c WHERE Name = 'System Properties'];
        //configSetting.Apttus_Config2__DisableConstraintRules__c = True;
        //update configSetting;
        Apttus_Config2__ConfigSystemProperties__c configSetting=new Apttus_Config2__ConfigSystemProperties__c(Name='System Properties',Apttus_Config2__DisableConstraintRules__c=true);
        insert configSetting;
        List<Apttus_Config2__AssetLineItem__c> assetList = new List<Apttus_Config2__AssetLineItem__c >();
        Apttus_Config2__AssetLineItem__c asset = new Apttus_Config2__AssetLineItem__c(Name = 'Test asset', APTS_Info_PlanType__c = 'S00', 
                                                                                      Apttus_Config2__ProductId__c=prod.id,
                                                                                      Apttus_Config2__NetPrice__c = 10.00,
                                                                                      APTS_SSD_Bill_To__c = accountSSD1.Id,
                                                                                      APTS_SSD_Sold_To__c = accountSSD1.Id,
                                                                                      Apttus_Config2__assetstatus__c='Activated',
                                                                                      Apttus_Config2__IsInactive__c =false,
                                                                                      Apttus_Config2__ListPrice__c =0,
                                                                                      Apttus_Config2__ChargeType__c='Subscription Fee',
                                                                                      Apttus_Config2__PriceType__c = 'One Time',
                                                                                      Apttus_QPConfig__ProposalId__c =p.id,APTS_Proposal_Business_Unit__c = 'Tax Professional',Apttus_Config2__NetUnitPrice__c = 100,
                                                                                      APTS_Info_RenewalDate__c = System.today().addDays(150),Apttus_Config2__BasePriceMethod__c = 'Flat Price');
        assetList.add(asset);

        Apttus_Config2__AssetLineItem__c assetBN = new Apttus_Config2__AssetLineItem__c(Name = 'Test asset', APTS_Info_PlanType__c = 'S00', 
        Apttus_Config2__ProductId__c=prod5.id,
        Apttus_Config2__NetPrice__c = 10.00,
        APTS_SSD_Bill_To__c = accountSSD1.Id,
        APTS_SSD_Sold_To__c = accountSSD1.Id,
        Apttus_Config2__assetstatus__c='Activated',
        Apttus_Config2__IsInactive__c =false,
        Apttus_Config2__ListPrice__c =0,
        Apttus_Config2__ChargeType__c='Subscription Fee',
        Apttus_Config2__PriceType__c = 'One Time',
        Apttus_QPConfig__ProposalId__c =p.id,APTS_Proposal_Business_Unit__c = 'Tax Professional',Apttus_Config2__NetUnitPrice__c = 100,
        APTS_Info_RenewalDate__c = System.today().addDays(150),Apttus_Config2__BasePriceMethod__c = 'Per Unit');
        assetList.add(assetBN);

        Apttus_Config2__AssetLineItem__c assetTax = new Apttus_Config2__AssetLineItem__c(Name = 'Test asset Tax', APTS_Info_PlanType__c = 'S00', 
                                                                                      Apttus_Config2__ProductId__c=prod2.id,
                                                                                      Apttus_Config2__NetPrice__c = 10.00,
                                                                                      APTS_SSD_Bill_To__c = accountSSD1.Id,
                                                                                      APTS_SSD_Sold_To__c = accountSSD1.Id,
                                                                                      Apttus_Config2__assetstatus__c='Activated',
                                                                                      Apttus_Config2__IsInactive__c =false,
                                                                                      Apttus_Config2__ListPrice__c =0,
                                                                                      Apttus_Config2__ChargeType__c='Standard Price',
                                                                                      Apttus_Config2__PriceType__c = 'One Time',
                                                                                      Apttus_QPConfig__ProposalId__c =p.id,APTS_Proposal_Business_Unit__c = 'Tax Professional',Apttus_Config2__NetUnitPrice__c = 100,
                                                                                      APTS_Info_RenewalDate__c = System.today().addDays(150),Apttus_Config2__BasePriceMethod__c = 'Flat Price');
        assetList.add(assetTax);
        Apttus_Config2__AssetLineItem__c asset1 = new Apttus_Config2__AssetLineItem__c(Name = 'Test asset', APTS_Info_PlanType__c = 'S00', 
                                                                                    Apttus_Config2__ProductId__c=prod2.id,   
                                                                                      Apttus_Config2__NetPrice__c = 10.00, APTS_SSD_Bill_To__c = accountSSD.Id,
                                                                                      APTS_SSD_Sold_To__c = accountSSD.Id,
                                                                                      Apttus_Config2__assetstatus__c='Activated',
                                                                                      Apttus_Config2__IsInactive__c =false,
                                                                                      Apttus_QPConfig__ProposalId__c =p1.id,APTS_Proposal_Business_Unit__c = 'SCS',Apttus_Config2__NetUnitPrice__c=100,
                                                                                      APTS_Info_RenewalDate__c = System.today().addDays(-80),Apttus_Config2__BasePriceMethod__c = 'Per Unit');
        assetList.add(asset1);
    Apttus_Config2__AssetLineItem__c asset2 = new Apttus_Config2__AssetLineItem__c(Name = 'Test asset', APTS_Info_PlanType__c = 'S00', 
                                                                                      Apttus_Config2__ProductId__c=prod.id,                     
                                                                                      Apttus_Config2__NetPrice__c = 10.00, APTS_SSD_Bill_To__c = accountSSD.Id,
                                                                                      APTS_SSD_Sold_To__c = accountSSD.Id,
                                                                                      Apttus_Config2__assetstatus__c='Activated',
                                                                                      Apttus_Config2__IsInactive__c =false,
                                                                                      Apttus_QPConfig__ProposalId__c =p1.id,APTS_Proposal_Business_Unit__c = 'SCS',Apttus_Config2__NetUnitPrice__c=100,
                                                                                      APTS_Info_RenewalDate__c = System.today().addDays(-181),Apttus_Config2__BasePriceMethod__c = 'Per Unit');
        assetList.add(asset2);
        Apttus_Config2__AssetLineItem__c asset3 = new Apttus_Config2__AssetLineItem__c(Name = 'Test asset', APTS_Info_PlanType__c = 'S00', 
                                                                                      Apttus_Config2__ProductId__c=prod3.id,                     
                                                                                      Apttus_Config2__NetPrice__c = 10.00, APTS_SSD_Bill_To__c = accountSSD.Id,
                                                                                      APTS_SSD_Sold_To__c = accountSSD.Id,
                                                                                      Apttus_Config2__assetstatus__c='Activated',
                                                                                      Apttus_Config2__IsInactive__c =false,
                                                                                      Apttus_QPConfig__ProposalId__c =p1.id,APTS_Proposal_Business_Unit__c = 'SCS',Apttus_Config2__NetUnitPrice__c=100,
                                                                                      APTS_Info_RenewalDate__c = System.today().addDays(-181),Apttus_Config2__BasePriceMethod__c = 'Per Unit');
        assetList.add(asset3);
        Apttus_Config2__AssetLineItem__c asset4 = new Apttus_Config2__AssetLineItem__c(Name = 'Test asset', APTS_Info_PlanType__c = 'S00', 
                                                                                      Apttus_Config2__ProductId__c=prod3.id,                     
                                                                                      Apttus_Config2__NetPrice__c = 10.00, APTS_SSD_Bill_To__c = accountSSD.Id,
                                                                                      APTS_SSD_Sold_To__c = accountSSD.Id,
                                                                                      Apttus_Config2__assetstatus__c='Activated',
                                                                                      Apttus_Config2__IsInactive__c =false,
                                                                                      Apttus_QPConfig__ProposalId__c =p1.id,APTS_Proposal_Business_Unit__c = 'SCS',Apttus_Config2__NetUnitPrice__c=100,
                                                                                      APTS_Info_RenewalDate__c = System.today().addDays(-181),Apttus_Config2__BasePriceMethod__c = 'Per Unit');
        assetList.add(asset4);
        Apttus_Config2__AssetLineItem__c asset5 = new Apttus_Config2__AssetLineItem__c(Name = 'Test asset', APTS_Info_PlanType__c = 'S00', 
                                                                                      Apttus_Config2__ProductId__c=prod4.id,                     
                                                                                      Apttus_Config2__NetPrice__c = 10.00, APTS_SSD_Bill_To__c = accountSSD.Id,
                                                                                      APTS_SSD_Sold_To__c = accountSSD.Id,
                                                                                      Apttus_Config2__assetstatus__c='Activated',
                                                                                      Apttus_Config2__IsInactive__c =false,
                                                                                      Apttus_QPConfig__ProposalId__c =p1.id,APTS_Proposal_Business_Unit__c = 'SCS',Apttus_Config2__NetUnitPrice__c=100,
                                                                                      APTS_Info_RenewalDate__c = System.today().addDays(-181),Apttus_Config2__BasePriceMethod__c = 'Per Unit');
        assetList.add(asset5);
        insert assetList;
        Apttus_Config2__LineItem__c li = new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c=prodConf.id , Apttus_Config2__ProductId__c=prod.id,Apttus_Config2__Quantity__c=1, Apttus_Config2__NetPrice__c=100.00,Apttus_Config2__ItemSequence__c=1, Apttus_Config2__LineNumber__c=1, APTS_Contract_Term__c = '2 Years' );
        li.Apttus_Config2__LineStatus__c = 'New';
        insert li;
        
        List<Apttus_Config2__LineItem__c> lineItemNew = new List<Apttus_Config2__LineItem__c >();
        //li.APTS_Contract_Term__c = '3 Years';       
        //update li;

        Apttus_Config2__LineItem__c liBN = new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c=prodConf.id , Apttus_Config2__ProductId__c=prod4.id);
        liBN.Apttus_Config2__AddedBy__c = 'User';
        liBN.Apttus_Config2__AdjustedPrice__c = 50;
        liBN.Apttus_Config2__AdjustmentAmount__c = 50;
        liBN.Apttus_Config2__AdjustmentType__c = '% Discount';
        liBN.Apttus_Config2__AllocateGroupAdjustment__c = TRUE;
        liBN.Apttus_Config2__AllowableAction__c = 'Unrestricted';
        liBN.Apttus_Config2__BaseExtendedPrice__c = 100;
        liBN.Apttus_Config2__BasePrice__c = 100;
        liBN.Apttus_Config2__BasePriceMethod__c = 'Per Unit';
        liBN.Apttus_Config2__BillingFrequency__c = 'Monthly';
        liBN.Apttus_Config2__ChargeType__c = 'Subscription Fee';
        liBN.Apttus_Config2__ItemSequence__c = 1;
        liBN.Apttus_Config2__LineNumber__c = 1;
        liBN.Apttus_Config2__LineSequence__c = 1;
        liBN.Apttus_Config2__LineStatus__c = 'Cancelled';
        liBN.Apttus_Config2__LineType__c = 'Product/Service';
        liBN.Apttus_Config2__ListPrice__c = 100;
        liBN.Apttus_Config2__NetAdjustmentPercent__c = -50;
        liBN.Apttus_Config2__NetPrice__c = 50;
        liBN.Apttus_Config2__NetUnitPrice__c = 50;
        liBN.Apttus_Config2__OptionSequence__c = 0;
        liBN.Apttus_Config2__PriceIncludedInBundle__c = FALSE;
        liBN.Apttus_Config2__PriceMethod__c = 'Per Unit';
        liBN.Apttus_Config2__PriceType__c = 'Recurring';
        liBN.CurrencyIsoCode = 'USD';
        liBN.APTS_Product_Family__c = 'WESTLAW';
        liBN.APTS_Contract_Term__c = '2 Years';
        liBN.APTS_Years_2_Plus_Adjustment__c = '4';
        liBN.Apttus_Config2__AssetLineItemId__c = asset5.Id;
        liBN.APTS_Product_Delivery__c = 'Online/Internet';
        liBN.Apttus_Config2__Quantity__c = 1;
        liBN.APTS_Yr_1_Renewal_Adjustment__c = '3';
        //liBN.APTS_Proposal_Business_Unit__c='Tax Professional';
        liBN.Apttus_Config2__AssetLineItemId__c= assetBN.Id;
        lineItemNew.add(liBN);

        Apttus_Config2__LineItem__c li2 = new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c=prodConf.id , Apttus_Config2__ProductId__c=prod.id);
        li2.Apttus_Config2__AddedBy__c = 'User';
        li2.Apttus_Config2__AdjustedPrice__c = 50;
        li2.Apttus_Config2__AdjustmentAmount__c = 50;
        li2.Apttus_Config2__AdjustmentType__c = '% Discount';
        li2.Apttus_Config2__AllocateGroupAdjustment__c = TRUE;
        li2.Apttus_Config2__AllowableAction__c = 'Unrestricted';
        li2.Apttus_Config2__AllowManualAdjustment__c = TRUE;
        li2.Apttus_Config2__AllowProration__c = FALSE;
        li2.Apttus_Config2__AllowRemoval__c = TRUE;
        li2.Apttus_Config2__AutoRenew__c = FALSE;
        li2.Apttus_Config2__BaseExtendedCost__c = 0;
        li2.Apttus_Config2__BaseExtendedPrice__c = 100;
        li2.Apttus_Config2__BasePrice__c = 100;
        li2.Apttus_Config2__BasePriceMethod__c = 'Per Unit';
        li2.Apttus_Config2__BillingFrequency__c = 'Monthly';
        li2.Apttus_Config2__ChargeType__c = 'Subscription Fee';
        li2.Apttus_Config2__ConfigStatus__c = 'Complete';
        li2.Apttus_Config2__ConstraintCheckStatus__c = 'NA';
        li2.Apttus_Config2__Customizable__c = FALSE;
        li2.Apttus_Config2__DeltaPrice__c = 50;
        li2.Apttus_Config2__DeltaQuantity__c = 1;
        li2.Apttus_Config2__Description__c = 'Westlaw Flex Plan $100/500';
        li2.Apttus_Config2__ExtendedCost__c = 0;
        li2.Apttus_Config2__ExtendedPrice__c = 100;
        li2.Apttus_Config2__Frequency__c = 'Monthly';
        li2.Apttus_Config2__Guidance__c = 'Red';
        li2.Apttus_Config2__HasAttributes__c = FALSE;
        li2.Apttus_Config2__HasBaseProduct__c = FALSE;
        li2.Apttus_Config2__HasDefaults__c = FALSE;
        li2.Apttus_Config2__HasIncentives__c = FALSE;
        li2.Apttus_Config2__HasOptions__c = FALSE;
        li2.Apttus_Config2__HasTieredPrice__c = FALSE;
        li2.Apttus_Config2__HideCopyAction__c = FALSE;
        li2.Apttus_Config2__HideInvoiceDisplay__c = FALSE;
        li2.Apttus_Config2__IsAssetPricing__c = FALSE;
        li2.Apttus_Config2__IsCustomPricing__c = FALSE;
        li2.Apttus_Config2__IsHidden__c = FALSE;
        li2.Apttus_Config2__IsOptionRollupLine__c = FALSE;
        li2.Apttus_Config2__IsPrimaryLine__c = TRUE;
        li2.Apttus_Config2__IsPrimaryRampLine__c = FALSE;
        li2.Apttus_Config2__IsQuantityModifiable__c = FALSE;
        li2.Apttus_Config2__IsReadOnly__c = FALSE;
        li2.Apttus_Config2__IsSellingTermReadOnly__c = FALSE;
        li2.Apttus_Config2__IsUsageTierModifiable__c = FALSE;
        li2.Apttus_Config2__ItemSequence__c = 1;
        li2.Apttus_Config2__LineNumber__c = 1;
        li2.Apttus_Config2__LineSequence__c = 1;
        li2.Apttus_Config2__LineStatus__c = 'New';
        li2.Apttus_Config2__LineType__c = 'Product/Service';
        li2.Apttus_Config2__ListPrice__c = 100;
        li2.Apttus_Config2__NetAdjustmentPercent__c = -50;
        li2.Apttus_Config2__NetPrice__c = 50;
        li2.Apttus_Config2__NetUnitPrice__c = 50;
        li2.Apttus_Config2__OptionSequence__c = 0;
        li2.Apttus_Config2__PriceIncludedInBundle__c = FALSE;
        li2.Apttus_Config2__PriceMethod__c = 'Per Unit';
        li2.Apttus_Config2__PriceType__c = 'Recurring';
        li2.Apttus_Config2__PriceUom__c = 'Each';
        li2.Apttus_Config2__PricingStatus__c = 'Complete';
        li2.Apttus_Config2__PrimaryLineNumber__c = 1;
        li2.Apttus_Config2__ProductVersion__c = 1;
        li2.Apttus_Config2__Quantity__c = 1;
        li2.Apttus_Config2__RollupPriceToBundle__c = TRUE;
        li2.Apttus_Config2__SellingFrequency__c = 'Monthly';
        li2.Apttus_Config2__SellingTerm__c = 1;
        li2.Apttus_Config2__SyncStatus__c = 'Pending';
        li2.Apttus_Config2__Taxable__c = FALSE;
        li2.Apttus_Config2__TaxInclusive__c = FALSE;
        li2.Apttus_Config2__Term__c = 1;
        li2.Apttus_Config2__TotalQuantity__c = 1;
        li2.Apttus_Config2__Uom__c = 'Each';
        li2.Apttus_CQApprov__Approval_Status__c = 'Pending Approval';
        li2.CurrencyIsoCode = 'USD';
        li2.APTS_Product_Family__c = 'WESTLAW';
        li2.APTS_Contract_Term__c = '2 Years';
        li2.APTS_Years_2_Plus_Adjustment__c = '4';
        li2.Apttus_Config2__AssetLineItemId__c = asset.Id;
        li2.APTS_Bridge__c='2 Months';
        li2.APTS_Product_Delivery__c='Online/Internet';
        li2.Apttus_Config2__Quantity__c = 1;
        lineItemNew.add(li2);
        
        Apttus_Config2__LineItem__c li3C = new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c=prodConf.id , Apttus_Config2__ProductId__c=prod2.id);
        li3C.Apttus_Config2__AssetLineItemId__c=asset2.id;
        li3C.Apttus_Config2__AddedBy__c = 'User';
        li3C.Apttus_Config2__AdjustedPrice__c = 50;
        li3C.Apttus_Config2__AdjustmentAmount__c = 50;
        li3C.Apttus_Config2__AdjustmentType__c = '% Discount';
        li3C.Apttus_Config2__AllocateGroupAdjustment__c = TRUE;
        li3C.Apttus_Config2__AllowableAction__c = 'Unrestricted';
        li3C.Apttus_Config2__AllowManualAdjustment__c = TRUE;
        li3C.Apttus_Config2__AllowProration__c = FALSE;
        li3C.Apttus_Config2__AllowRemoval__c = TRUE;
        li3C.Apttus_Config2__AutoRenew__c = FALSE;
        li3C.Apttus_Config2__BaseExtendedCost__c = 0;
        li3C.Apttus_Config2__BaseExtendedPrice__c = 100;
        li3C.Apttus_Config2__BasePrice__c = 100;
        li3C.Apttus_Config2__BasePriceMethod__c = 'Per Unit';
        li3C.Apttus_Config2__BillingFrequency__c = 'Monthly';
        li3C.Apttus_Config2__ChargeType__c = 'Subscription Fee';
        li3C.Apttus_Config2__ConfigStatus__c = 'Complete';
        li3C.Apttus_Config2__ConstraintCheckStatus__c = 'NA';
        li3C.Apttus_Config2__Customizable__c = FALSE;
        li3C.Apttus_Config2__DeltaPrice__c = 50;
        li3C.Apttus_Config2__DeltaQuantity__c = 1;
        li3C.Apttus_Config2__Description__c = 'Westlaw Flex Plan $100/500';
        li3C.Apttus_Config2__ExtendedCost__c = 0;
        li3C.Apttus_Config2__ExtendedPrice__c = 100;
        li3C.Apttus_Config2__Frequency__c = 'Monthly';
        li3C.Apttus_Config2__Guidance__c = 'Red';
        li3C.Apttus_Config2__HasAttributes__c = FALSE;
        li3C.Apttus_Config2__HasBaseProduct__c = FALSE;
        li3C.Apttus_Config2__HasDefaults__c = FALSE;
        li3C.Apttus_Config2__HasIncentives__c = FALSE;
        li3C.Apttus_Config2__HasOptions__c = FALSE;
        li3C.Apttus_Config2__HasTieredPrice__c = FALSE;
        li3C.Apttus_Config2__HideCopyAction__c = FALSE;
        li3C.Apttus_Config2__HideInvoiceDisplay__c = FALSE;
        li3C.Apttus_Config2__IsAssetPricing__c = FALSE;
        li3C.Apttus_Config2__IsCustomPricing__c = FALSE;
        li3C.Apttus_Config2__IsHidden__c = FALSE;
        li3C.Apttus_Config2__IsOptionRollupLine__c = FALSE;
        li3C.Apttus_Config2__IsPrimaryLine__c = TRUE;
        li3C.Apttus_Config2__IsPrimaryRampLine__c = FALSE;
        li3C.Apttus_Config2__IsQuantityModifiable__c = FALSE;
        li3C.Apttus_Config2__IsReadOnly__c = FALSE;
        li3C.Apttus_Config2__IsSellingTermReadOnly__c = FALSE;
        li3C.Apttus_Config2__IsUsageTierModifiable__c = FALSE;
        li3C.Apttus_Config2__ItemSequence__c = 1;
        li3C.Apttus_Config2__LineNumber__c = 1;
        li3C.Apttus_Config2__LineSequence__c = 1;
        li3C.Apttus_Config2__LineStatus__c = 'Cancelled';
        li3C.APTS_Yr_1_Renewal_Adjustment__c ='1';
        li3C.Apttus_Config2__LineType__c = 'Product/Service';
        li3C.Apttus_Config2__ListPrice__c = 100;
        li3C.Apttus_Config2__NetAdjustmentPercent__c = -50;
        li3C.Apttus_Config2__NetPrice__c = 50;
        li3C.Apttus_Config2__NetUnitPrice__c = 50;
        li3C.Apttus_Config2__OptionSequence__c = 0;
        li3C.Apttus_Config2__PriceIncludedInBundle__c = FALSE;
        li3C.Apttus_Config2__PriceMethod__c = 'Per Unit';
        li3C.Apttus_Config2__PriceType__c = 'Recurring';
        li3C.Apttus_Config2__PriceUom__c = 'Each';
        li3C.Apttus_Config2__PricingStatus__c = 'Complete';
        li3C.Apttus_Config2__PrimaryLineNumber__c = 1;
        li3C.Apttus_Config2__ProductVersion__c = 1;
        li3C.Apttus_Config2__Quantity__c = 1;
        li3C.Apttus_Config2__RollupPriceToBundle__c = TRUE;
        li3C.Apttus_Config2__SellingFrequency__c = 'Monthly';
        li3C.Apttus_Config2__SellingTerm__c = 1;
        li3C.Apttus_Config2__SyncStatus__c = 'Pending';
        li3C.Apttus_Config2__Taxable__c = FALSE;
        li3C.Apttus_Config2__TaxInclusive__c = FALSE;
        li3C.Apttus_Config2__Term__c = 1;
        li3C.Apttus_Config2__TotalQuantity__c = 1;
        li3C.Apttus_Config2__Uom__c = 'Each';
        li3C.Apttus_CQApprov__Approval_Status__c = 'Pending Approval';
        li3C.CurrencyIsoCode = 'USD';
        li3C.APTS_Product_Family__c = 'WESTLAW';
        li3C.APTS_Contract_Term__c = '2 Years';
        li3C.APTS_Years_2_Plus_Adjustment__c = '4';
        li3C.Apttus_Config2__AssetLineItemId__c = asset.Id;
        li3C.APTS_Product_Delivery__c = 'Online/Internet';
        li3C.Apttus_Config2__Quantity__c = 1;
        
        lineItemNew.add(li3C);

        Apttus_Config2__LineItem__c li3R = new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c=prodConf.id , Apttus_Config2__ProductId__c=prod2.id);
        li3R.Apttus_Config2__AddedBy__c = 'User';
        li3R.Apttus_Config2__AdjustedPrice__c = 50;
        li3R.Apttus_Config2__AdjustmentAmount__c = 50;
        li3R.Apttus_Config2__AdjustmentType__c = '% Discount';
        li3R.Apttus_Config2__AllocateGroupAdjustment__c = TRUE;
        li3R.Apttus_Config2__AllowableAction__c = 'Unrestricted';
        li3R.Apttus_Config2__AllowManualAdjustment__c = TRUE;
        li3R.Apttus_Config2__AllowProration__c = FALSE;
        li3R.Apttus_Config2__AllowRemoval__c = TRUE;
        li3R.Apttus_Config2__AutoRenew__c = FALSE;
        li3R.Apttus_Config2__BaseExtendedCost__c = 0;
        li3R.Apttus_Config2__BaseExtendedPrice__c = 100;
        li3R.Apttus_Config2__BasePrice__c = 100;
        li3R.Apttus_Config2__BasePriceMethod__c = 'Per Unit';
        li3R.Apttus_Config2__BillingFrequency__c = 'Monthly';
        li3R.Apttus_Config2__ChargeType__c = 'Subscription Fee';
        li3R.Apttus_Config2__ConfigStatus__c = 'Complete';
        li3R.Apttus_Config2__ConstraintCheckStatus__c = 'NA';
        li3R.Apttus_Config2__Customizable__c = FALSE;
        li3R.Apttus_Config2__DeltaPrice__c = 50;
        li3R.Apttus_Config2__DeltaQuantity__c = 1;
        li3R.Apttus_Config2__Description__c = 'Westlaw Flex Plan $100/500';
        li3R.Apttus_Config2__ExtendedCost__c = 0;
        li3R.Apttus_Config2__ExtendedPrice__c = 100;
        li3R.Apttus_Config2__Frequency__c = 'Monthly';
        li3R.Apttus_Config2__Guidance__c = 'Red';
        li3R.Apttus_Config2__HasAttributes__c = FALSE;
        li3R.Apttus_Config2__HasBaseProduct__c = FALSE;
        li3R.Apttus_Config2__HasDefaults__c = FALSE;
        li3R.Apttus_Config2__HasIncentives__c = FALSE;
        li3R.Apttus_Config2__HasOptions__c = FALSE;
        li3R.Apttus_Config2__HasTieredPrice__c = FALSE;
        li3R.Apttus_Config2__HideCopyAction__c = FALSE;
        li3R.Apttus_Config2__HideInvoiceDisplay__c = FALSE;
        li3R.Apttus_Config2__IsAssetPricing__c = FALSE;
        li3R.Apttus_Config2__IsCustomPricing__c = FALSE;
        li3R.Apttus_Config2__IsHidden__c = FALSE;
        li3R.Apttus_Config2__IsOptionRollupLine__c = FALSE;
        li3R.Apttus_Config2__IsPrimaryLine__c = TRUE;
        li3R.Apttus_Config2__IsPrimaryRampLine__c = FALSE;
        li3R.Apttus_Config2__IsQuantityModifiable__c = FALSE;
        li3R.Apttus_Config2__IsReadOnly__c = FALSE;
        li3R.Apttus_Config2__IsSellingTermReadOnly__c = FALSE;
        li3R.Apttus_Config2__IsUsageTierModifiable__c = FALSE;
        li3R.Apttus_Config2__ItemSequence__c = 1;
        li3R.Apttus_Config2__LineNumber__c = 1;
        li3R.Apttus_Config2__LineSequence__c = 1;
        li3R.Apttus_Config2__LineStatus__c = 'Renewed';
        li3R.APTS_Yr_1_Renewal_Adjustment__c ='1';
        li3R.Apttus_Config2__LineType__c = 'Product/Service';
        li3R.Apttus_Config2__ListPrice__c = 100;
        li3R.Apttus_Config2__NetAdjustmentPercent__c = -50;
        li3R.Apttus_Config2__NetPrice__c = 50;
        li3R.Apttus_Config2__NetUnitPrice__c = 50;
        li3R.Apttus_Config2__OptionSequence__c = 0;
        li3R.Apttus_Config2__PriceIncludedInBundle__c = FALSE;
        li3R.Apttus_Config2__PriceMethod__c = 'Per Unit';
        li3R.Apttus_Config2__PriceType__c = 'Recurring';
        li3R.Apttus_Config2__PriceUom__c = 'Each';
        li3R.Apttus_Config2__PricingStatus__c = 'Complete';
        li3R.Apttus_Config2__PrimaryLineNumber__c = 1;
        li3R.Apttus_Config2__ProductVersion__c = 1;
        li3R.Apttus_Config2__Quantity__c = 1;
        li3R.Apttus_Config2__RollupPriceToBundle__c = TRUE;
        li3R.Apttus_Config2__SellingFrequency__c = 'Monthly';
        li3R.Apttus_Config2__SellingTerm__c = 1;
        li3R.Apttus_Config2__SyncStatus__c = 'Pending';
        li3R.Apttus_Config2__Taxable__c = FALSE;
        li3R.Apttus_Config2__TaxInclusive__c = FALSE;
        li3R.Apttus_Config2__Term__c = 1;
        li3R.Apttus_Config2__TotalQuantity__c = 1;
        li3R.Apttus_Config2__Uom__c = 'Each';
        li3R.Apttus_CQApprov__Approval_Status__c = 'Pending Approval';
        li3R.CurrencyIsoCode = 'USD';
        li3R.APTS_Product_Family__c = 'WESTLAW';
        li3R.APTS_Contract_Term__c = '2 Years';
        li3R.APTS_Years_2_Plus_Adjustment__c = '4';
        li3R.Apttus_Config2__AssetLineItemId__c = asset.Id;
        li3R.APTS_Product_Delivery__c = 'Online/Internet';
        li3R.Apttus_Config2__Quantity__c = 1;
        
        lineItemNew.add(li3R);
        Apttus_Config2__LineItem__c li4 = new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c=prodConf.id , Apttus_Config2__ProductId__c=prod2.id);
        li4.Apttus_Config2__AddedBy__c = 'User';
        li4.Apttus_Config2__AdjustedPrice__c = 50;
        li4.Apttus_Config2__AdjustmentAmount__c = 50;
        li4.Apttus_Config2__AdjustmentType__c = '% Discount';
        li4.Apttus_Config2__AllocateGroupAdjustment__c = TRUE;
        li4.Apttus_Config2__AllowableAction__c = 'Unrestricted';
        li4.Apttus_Config2__AllowManualAdjustment__c = TRUE;
        li4.Apttus_Config2__AllowProration__c = FALSE;
        li4.Apttus_Config2__AllowRemoval__c = TRUE;
        li4.Apttus_Config2__AutoRenew__c = FALSE;
        li4.Apttus_Config2__BaseExtendedCost__c = 0;
        li4.Apttus_Config2__BaseExtendedPrice__c = 100;
        li4.Apttus_Config2__BasePrice__c = 100;
        li4.Apttus_Config2__BasePriceMethod__c = 'Per Unit';
        li4.Apttus_Config2__BillingFrequency__c = 'Monthly';
        li4.Apttus_Config2__ChargeType__c = 'Subscription Fee';
        li4.Apttus_Config2__ConfigStatus__c = 'Complete';
        li4.Apttus_Config2__ConstraintCheckStatus__c = 'NA';
        li4.Apttus_Config2__Customizable__c = FALSE;
        li4.Apttus_Config2__DeltaPrice__c = 50;
        li4.Apttus_Config2__DeltaQuantity__c = 1;
        li4.Apttus_Config2__Description__c = 'Westlaw Flex Plan $100/500';
        li4.Apttus_Config2__ExtendedCost__c = 0;
        li4.Apttus_Config2__ExtendedPrice__c = 100;
        li4.Apttus_Config2__Frequency__c = 'Monthly';
        li4.Apttus_Config2__Guidance__c = 'Red';
        li4.Apttus_Config2__HasAttributes__c = FALSE;
        li4.Apttus_Config2__HasBaseProduct__c = FALSE;
        li4.Apttus_Config2__HasDefaults__c = FALSE;
        li4.Apttus_Config2__HasIncentives__c = FALSE;
        li4.Apttus_Config2__HasOptions__c = FALSE;
        li4.Apttus_Config2__HasTieredPrice__c = FALSE;
        li4.Apttus_Config2__HideCopyAction__c = FALSE;
        li4.Apttus_Config2__HideInvoiceDisplay__c = FALSE;
        li4.Apttus_Config2__IsAssetPricing__c = FALSE;
        li4.Apttus_Config2__IsCustomPricing__c = FALSE;
        li4.Apttus_Config2__IsHidden__c = FALSE;
        li4.Apttus_Config2__IsOptionRollupLine__c = FALSE;
        li4.Apttus_Config2__IsPrimaryLine__c = TRUE;
        li4.Apttus_Config2__IsPrimaryRampLine__c = FALSE;
        li4.Apttus_Config2__IsQuantityModifiable__c = FALSE;
        li4.Apttus_Config2__IsReadOnly__c = FALSE;
        li4.Apttus_Config2__IsSellingTermReadOnly__c = FALSE;
        li4.Apttus_Config2__IsUsageTierModifiable__c = FALSE;
        li4.Apttus_Config2__ItemSequence__c = 1;
        li4.Apttus_Config2__LineNumber__c = 1;
        li4.Apttus_Config2__LineSequence__c = 1;
        li4.Apttus_Config2__LineStatus__c = 'Renewed';
        li4.APTS_Yr_1_Renewal_Adjustment__c ='1';
        li4.Apttus_Config2__LineType__c = 'Product/Service';
        li4.Apttus_Config2__ListPrice__c = 100;
        li4.Apttus_Config2__NetAdjustmentPercent__c = -50;
        li4.Apttus_Config2__NetPrice__c = 50;
        li4.Apttus_Config2__NetUnitPrice__c = 50;
        li4.Apttus_Config2__OptionSequence__c = 0;
        li4.Apttus_Config2__PriceIncludedInBundle__c = FALSE;
        li4.Apttus_Config2__PriceMethod__c = 'Per Unit';
        li4.Apttus_Config2__PriceType__c = 'Recurring';
        li4.Apttus_Config2__PriceUom__c = 'Each';
        li4.Apttus_Config2__PricingStatus__c = 'Complete';
        li4.Apttus_Config2__PrimaryLineNumber__c = 1;
        li4.Apttus_Config2__ProductVersion__c = 1;
        li4.Apttus_Config2__Quantity__c = 1;
        li4.Apttus_Config2__RollupPriceToBundle__c = TRUE;
        li4.Apttus_Config2__SellingFrequency__c = 'Monthly';
        li4.Apttus_Config2__SellingTerm__c = 1;
        li4.Apttus_Config2__SyncStatus__c = 'Pending';
        li4.Apttus_Config2__Taxable__c = FALSE;
        li4.Apttus_Config2__TaxInclusive__c = FALSE;
        li4.Apttus_Config2__Term__c = 1;
        li4.Apttus_Config2__TotalQuantity__c = 1;
        li4.Apttus_Config2__Uom__c = 'Each';
        li4.Apttus_CQApprov__Approval_Status__c = 'Pending Approval';
        li4.CurrencyIsoCode = 'USD';
        li4.APTS_Product_Family__c = 'WESTLAW';
        li4.APTS_Contract_Term__c = '2 Years';
        li4.APTS_Years_2_Plus_Adjustment__c = '4';
        li4.Apttus_Config2__AssetLineItemId__c = asset.Id;
        li4.APTS_Product_Delivery__c = 'Online/Internet';
        li4.Apttus_Config2__Quantity__c = 1;
        
        lineItemNew.add(li4);

        //Uncommenting start
        Apttus_Config2__LineItem__c li5 = new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c=prodConf.id , Apttus_Config2__ProductId__c=prod.id);
        li5.Apttus_Config2__AddedBy__c = 'User';
        li5.Apttus_Config2__AdjustedPrice__c = 50;
        li5.Apttus_Config2__AdjustmentAmount__c = 50;
        li5.Apttus_Config2__AdjustmentType__c = '% Discount';
        li5.Apttus_Config2__AllocateGroupAdjustment__c = TRUE;
        li5.Apttus_Config2__AllowableAction__c = 'Unrestricted';
        li5.Apttus_Config2__AllowManualAdjustment__c = TRUE;
        li5.Apttus_Config2__AllowProration__c = FALSE;
        li5.Apttus_Config2__AllowRemoval__c = TRUE;
        li5.Apttus_Config2__AutoRenew__c = FALSE;
        li5.Apttus_Config2__BaseExtendedCost__c = 0;
        li5.Apttus_Config2__BaseExtendedPrice__c = 100;
        li5.Apttus_Config2__BasePrice__c = 100;
        li5.Apttus_Config2__BasePriceMethod__c = 'Per Unit';
        li5.Apttus_Config2__BillingFrequency__c = 'Monthly';
        li5.Apttus_Config2__ChargeType__c = 'Subscription Fee';
        li5.Apttus_Config2__ConfigStatus__c = 'Complete';
        li5.Apttus_Config2__ConstraintCheckStatus__c = 'NA';
        li5.Apttus_Config2__Customizable__c = FALSE;
        li5.Apttus_Config2__DeltaPrice__c = 50;
        li5.Apttus_Config2__DeltaQuantity__c = 1;
        li5.Apttus_Config2__Description__c = 'Westlaw Flex Plan $100/500';
        li5.Apttus_Config2__ExtendedCost__c = 0;
        li5.Apttus_Config2__ExtendedPrice__c = 100;
        li5.Apttus_Config2__Frequency__c = 'Monthly';
        li5.Apttus_Config2__Guidance__c = 'Red';
        li5.Apttus_Config2__HasAttributes__c = FALSE;
        li5.Apttus_Config2__HasBaseProduct__c = FALSE;
        li5.Apttus_Config2__HasDefaults__c = FALSE;
        li5.Apttus_Config2__HasIncentives__c = FALSE;
        li5.Apttus_Config2__HasOptions__c = FALSE;
        li5.Apttus_Config2__HasTieredPrice__c = FALSE;
        li5.Apttus_Config2__HideCopyAction__c = FALSE;
        li5.Apttus_Config2__HideInvoiceDisplay__c = FALSE;
        li5.Apttus_Config2__IsAssetPricing__c = FALSE;
        li5.Apttus_Config2__IsCustomPricing__c = FALSE;
        li5.Apttus_Config2__IsHidden__c = FALSE;
        li5.Apttus_Config2__IsOptionRollupLine__c = FALSE;
        li5.Apttus_Config2__IsPrimaryLine__c = TRUE;
        li5.Apttus_Config2__IsPrimaryRampLine__c = FALSE;
        li5.Apttus_Config2__IsQuantityModifiable__c = FALSE;
        li5.Apttus_Config2__IsReadOnly__c = FALSE;
        li5.Apttus_Config2__IsSellingTermReadOnly__c = FALSE;
        li5.Apttus_Config2__IsUsageTierModifiable__c = FALSE;
        li5.Apttus_Config2__ItemSequence__c = 1;
        li5.Apttus_Config2__LineNumber__c = 1;
        li5.Apttus_Config2__LineSequence__c = 1;
        li5.Apttus_Config2__LineStatus__c = 'New';
        li5.Apttus_Config2__LineType__c = 'Product/Service';
        li5.Apttus_Config2__ListPrice__c = 100;
        li5.Apttus_Config2__NetAdjustmentPercent__c = -50;
        li5.Apttus_Config2__NetPrice__c = 50;
        li5.Apttus_Config2__NetUnitPrice__c = 50;
        li5.Apttus_Config2__OptionSequence__c = 0;
        li5.Apttus_Config2__PriceIncludedInBundle__c = FALSE;
        li5.Apttus_Config2__PriceMethod__c = 'Per Unit';
        li5.Apttus_Config2__PriceType__c = 'Recurring';
        li5.Apttus_Config2__PriceUom__c = 'Each';
        li5.Apttus_Config2__PricingStatus__c = 'Complete';
        li5.Apttus_Config2__PrimaryLineNumber__c = 1;
        li5.Apttus_Config2__ProductVersion__c = 1;
        //  li5.APTS_Print_Purchase_Options__c = 'Ship & Enter Sub APP';
        li5.Apttus_Config2__Quantity__c = 1;
        li5.Apttus_Config2__RollupPriceToBundle__c = TRUE;
        li5.Apttus_Config2__SellingFrequency__c = 'Monthly';
        li5.Apttus_Config2__SellingTerm__c = 1;
        li5.Apttus_Config2__SyncStatus__c = 'Pending';
        li5.Apttus_Config2__Taxable__c = FALSE;
        li5.Apttus_Config2__TaxInclusive__c = FALSE;
        li5.Apttus_Config2__Term__c = 1;
        li5.Apttus_Config2__TotalQuantity__c = 1;
        li5.Apttus_Config2__Uom__c = 'Each';
        li5.Apttus_CQApprov__Approval_Status__c = 'Pending Approval';
        li5.CurrencyIsoCode = 'USD';
        li5.APTS_Product_Family__c = 'WESTLAW';
        li5.APTS_Contract_Term__c = '2 Years';
        li5.APTS_Years_2_Plus_Adjustment__c = '4';
        li5.Apttus_Config2__AssetLineItemId__c = asset.Id;
        li5.APTS_Product_Delivery__c = 'Online/Internet';
        li5.Apttus_Config2__Quantity__c = 1;
        lineItemNew.add(li5);
        
        Apttus_Config2__LineItem__c li6 = new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c=prodConf.id , Apttus_Config2__ProductId__c=prod.id);
        li6.Apttus_Config2__AddedBy__c = 'User';
        li6.Apttus_Config2__AdjustedPrice__c = 50;
        li6.Apttus_Config2__AdjustmentAmount__c = 50;
        li6.Apttus_Config2__AdjustmentType__c = '% Discount';
        li6.Apttus_Config2__AllocateGroupAdjustment__c = TRUE;
        li6.Apttus_Config2__AllowableAction__c = 'Unrestricted';
        li6.Apttus_Config2__BaseExtendedPrice__c = 100;
        li6.Apttus_Config2__BasePrice__c = 100;
        li6.Apttus_Config2__BasePriceMethod__c = 'Per Unit';
        li6.Apttus_Config2__BillingFrequency__c = 'Monthly';
        li6.Apttus_Config2__ChargeType__c = 'Subscription Fee';
        li6.Apttus_Config2__ItemSequence__c = 1;
        li6.Apttus_Config2__LineNumber__c = 1;
        li6.Apttus_Config2__LineSequence__c = 1;
        li6.Apttus_Config2__LineStatus__c = 'New';
        li6.Apttus_Config2__LineType__c = 'Product/Service';
        li6.Apttus_Config2__ListPrice__c = 100;
        li6.Apttus_Config2__NetAdjustmentPercent__c = -50;
        li6.Apttus_Config2__NetPrice__c = 50;
        li6.Apttus_Config2__NetUnitPrice__c = 50;
        li6.Apttus_Config2__OptionSequence__c = 0;
        li6.Apttus_Config2__PriceIncludedInBundle__c = FALSE;
        li6.Apttus_Config2__PriceMethod__c = 'Per Unit';
        li6.Apttus_Config2__PriceType__c = 'Recurring';
        li6.CurrencyIsoCode = 'USD';
        li6.APTS_Product_Family__c = 'WESTLAW';
        li6.APTS_Contract_Term__c = '2 Years';
        li6.APTS_Years_2_Plus_Adjustment__c = '4';
        li6.Apttus_Config2__AssetLineItemId__c = asset.Id;
        li6.APTS_Product_Delivery__c = 'Online/Internet';
        li6.Apttus_Config2__Quantity__c = 1;
        lineItemNew.add(li6);
        
        Apttus_Config2__LineItem__c li7 = new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c=prodConf.id , Apttus_Config2__ProductId__c=prod.id);
        li7.Apttus_Config2__BasePriceMethod__c = 'Flat Price';
        li7.Apttus_Config2__BillingFrequency__c = 'Monthly';
        li7.Apttus_Config2__ChargeType__c = 'Subscription Fee';
        li7.Apttus_Config2__LineStatus__c = 'New';
        li7.Apttus_Config2__ItemSequence__c = 1;
        li7.Apttus_Config2__LineNumber__c = 1;
        li7.Apttus_Config2__LineSequence__c = 1;
        li7.Apttus_Config2__LineStatus__c = 'New';
        li7.Apttus_Config2__LineType__c = 'Product/Service';
        li7.Apttus_Config2__ListPrice__c = 100;
        li7.Apttus_Config2__NetPrice__c = 50;
        li7.Apttus_Config2__NetUnitPrice__c = 50;
        li7.Apttus_Config2__PriceMethod__c = 'Per Unit';
        li7.Apttus_Config2__PriceType__c = 'Recurring';
        li7.APTS_Product_Family__c = 'WESTLAW';
        li7.APTS_Contract_Term__c = '2 Years';
        li7.APTS_Years_2_Plus_Adjustment__c = '4';
        li7.Apttus_Config2__AssetLineItemId__c = asset1.Id;
        li7.APTS_Product_Delivery__c = 'Online/Internet';
        li7.Apttus_Config2__Quantity__c = 1;
        //li7.APTS_Proposal_Business_Unit__c = 'Tax Professional';
        lineItemNew.add(li7);

    Apttus_Config2__LineItem__c li9 = new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c=prodConf.id , Apttus_Config2__ProductId__c=prod1.id);
        li9.Apttus_Config2__AddedBy__c = 'User';        
        li9.Apttus_Config2__BasePrice__c = 100;
        li9.Apttus_Config2__BasePriceMethod__c = 'Per Unit';
        li9.Apttus_Config2__BillingFrequency__c = 'Monthly';
        li9.Apttus_Config2__ChargeType__c = 'Subscription Fee';
        li9.Apttus_Config2__ConfigStatus__c = 'Complete';        
        li9.Apttus_Config2__Frequency__c = 'Monthly';        
        li9.Apttus_Config2__IsPrimaryLine__c = TRUE;        
        li9.Apttus_Config2__ItemSequence__c = 1;
        li9.Apttus_Config2__LineNumber__c = 1;
        li9.Apttus_Config2__LineSequence__c = 1;
        li9.Apttus_Config2__LineStatus__c = 'New';
        li9.APTS_Yr_1_Renewal_Adjustment__c='1';
        li9.Apttus_Config2__LineType__c = 'Product/Service';
        li9.Apttus_Config2__ListPrice__c = 100;        
        li9.Apttus_Config2__NetPrice__c = 50;
        li9.Apttus_Config2__NetUnitPrice__c = 50;        
        li9.Apttus_Config2__PriceMethod__c = 'Per Unit';
        li9.Apttus_Config2__PriceType__c = 'Recurring';
        li9.Apttus_Config2__PriceUom__c = 'Each';
        li9.Apttus_Config2__PricingStatus__c = 'Complete';
        li9.Apttus_Config2__PrimaryLineNumber__c = 1;
        li9.Apttus_Config2__ProductVersion__c = 1;        
        li9.Apttus_Config2__Quantity__c = 1;
        li9.Apttus_Config2__RollupPriceToBundle__c = TRUE;
        li9.Apttus_Config2__SellingFrequency__c = 'Monthly';
        li9.Apttus_Config2__BillingFrequency__c = 'Monthly';
        li9.Apttus_Config2__SellingTerm__c = 1;                               
        li9.Apttus_Config2__TotalQuantity__c = 1;
        li9.Apttus_Config2__Uom__c = 'Each';
        li9.Apttus_CQApprov__Approval_Status__c = 'Pending Approval';
        li9.CurrencyIsoCode = 'USD';
        li9.APTS_Product_Family__c = 'CLEAR';
        //li8.APTS_Cat_L2__c = System.Label.APTS_Clear_Product_Family;
        li9.APTS_Contract_Term__c = '1 Year';
        li9.APTS_Years_2_Plus_Adjustment__c = '1';
        li9.APTS_Group__c='Bundle A';
        lineItemNew.add(li9);

    Apttus_Config2__LineItem__c li8 = new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c=prodConf.id , Apttus_Config2__ProductId__c=prod2.id);
        li8.Apttus_Config2__AddedBy__c = 'User';        
        li8.Apttus_Config2__BasePrice__c = 100;
        li8.Apttus_Config2__BasePriceMethod__c = 'Per Unit';
        li8.Apttus_Config2__BillingFrequency__c = 'Monthly';
        li8.Apttus_Config2__ChargeType__c = 'Subscription Fee';
        li8.Apttus_Config2__ConfigStatus__c = 'Complete';        
        li8.Apttus_Config2__Frequency__c = 'Monthly';        
        li8.Apttus_Config2__IsPrimaryLine__c = TRUE;        
        li8.Apttus_Config2__ItemSequence__c = 1;
        li8.Apttus_Config2__LineNumber__c = 1;
        li8.Apttus_Config2__LineSequence__c = 1;
        li8.Apttus_Config2__LineStatus__c = 'New';
        li8.APTS_Yr_1_Renewal_Adjustment__c='1';
        li8.Apttus_Config2__LineType__c = 'Product/Service';
        li8.Apttus_Config2__ListPrice__c = 100;        
        li8.Apttus_Config2__NetPrice__c = 50;
        li8.Apttus_Config2__NetUnitPrice__c = 50;        
        li8.Apttus_Config2__PriceMethod__c = 'Per Unit';
        li8.Apttus_Config2__PriceType__c = 'Recurring';
        li8.Apttus_Config2__PriceUom__c = 'Each';
        li8.Apttus_Config2__PricingStatus__c = 'Complete';
        li8.Apttus_Config2__PrimaryLineNumber__c = 1;
        li8.Apttus_Config2__ProductVersion__c = 1;        
        li8.Apttus_Config2__Quantity__c = 1;
        li8.Apttus_Config2__RollupPriceToBundle__c = TRUE;
        li8.Apttus_Config2__SellingFrequency__c = 'Monthly';
        li8.Apttus_Config2__BillingFrequency__c = 'Monthly';
        li8.Apttus_Config2__SellingTerm__c = 1;                               
        li8.Apttus_Config2__TotalQuantity__c = 1;
        li8.Apttus_Config2__Uom__c = 'Each';
        li8.Apttus_CQApprov__Approval_Status__c = 'Pending Approval';
        li8.CurrencyIsoCode = 'USD';
        li8.APTS_Product_Family__c = 'CLEAR';
        //li8.APTS_Cat_L2__c = System.Label.APTS_Clear_Product_Family;
        li8.APTS_Contract_Term__c = '1 Year';
        li8.APTS_Years_2_Plus_Adjustment__c = '1';
        li8.APTS_Group__c='Bundle A';
    li8.Apttus_Config2__AssetLineItemId__c=asset2.Id;
        lineItemNew.add(li8);
        
        Apttus_Config2__LineItem__c liGP1 = new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c=prodConf.id , Apttus_Config2__ProductId__c=prod3.id);
        liGP1.Apttus_Config2__AddedBy__c = 'User';
        liGP1.Apttus_Config2__AdjustedPrice__c = 50;
        liGP1.Apttus_Config2__AdjustmentAmount__c = 50;
        liGP1.Apttus_Config2__AdjustmentType__c = '% Discount';
        liGP1.Apttus_Config2__AllocateGroupAdjustment__c = TRUE;
        liGP1.Apttus_Config2__AllowableAction__c = 'Unrestricted';
        liGP1.Apttus_Config2__BaseExtendedPrice__c = 100;
        liGP1.Apttus_Config2__BasePrice__c = 100;
        liGP1.Apttus_Config2__BasePriceMethod__c = 'Per Unit';
        liGP1.Apttus_Config2__BillingFrequency__c = 'Monthly';
        liGP1.Apttus_Config2__ChargeType__c = 'Subscription Fee';
        liGP1.Apttus_Config2__ItemSequence__c = 1;
        liGP1.Apttus_Config2__LineNumber__c = 1;
        liGP1.Apttus_Config2__LineSequence__c = 1;
        liGP1.Apttus_Config2__LineStatus__c = 'New';
        liGP1.Apttus_Config2__LineType__c = 'Product/Service';
        liGP1.Apttus_Config2__ListPrice__c = 100;
        liGP1.Apttus_Config2__NetAdjustmentPercent__c = -50;
        liGP1.Apttus_Config2__NetPrice__c = 50;
        liGP1.Apttus_Config2__NetUnitPrice__c = 50;
        liGP1.Apttus_Config2__OptionSequence__c = 0;
        liGP1.Apttus_Config2__PriceIncludedInBundle__c = FALSE;
        liGP1.Apttus_Config2__PriceMethod__c = 'Per Unit';
        liGP1.Apttus_Config2__PriceType__c = 'Recurring';
        liGP1.CurrencyIsoCode = 'USD';
        liGP1.APTS_Product_Family__c = 'WESTLAW';
        liGP1.APTS_Contract_Term__c = '2 Years';
        liGP1.APTS_Years_2_Plus_Adjustment__c = '4';
        liGP1.APTS_Product_Delivery__c = 'Online/Internet';
        liGP1.Apttus_Config2__Quantity__c = 1;
        lineItemNew.add(liGP1);
        
        Apttus_Config2__LineItem__c liGP2 = new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c=prodConf.id , Apttus_Config2__ProductId__c=prod3.id);
        liGP2.Apttus_Config2__AddedBy__c = 'User';
        liGP2.Apttus_Config2__AdjustedPrice__c = 50;
        liGP2.Apttus_Config2__AdjustmentAmount__c = 50;
        liGP2.Apttus_Config2__AdjustmentType__c = '% Discount';
        liGP2.Apttus_Config2__AllocateGroupAdjustment__c = TRUE;
        liGP2.Apttus_Config2__AllowableAction__c = 'Unrestricted';
        liGP2.Apttus_Config2__BaseExtendedPrice__c = 100;
        liGP2.Apttus_Config2__BasePrice__c = 100;
        liGP2.Apttus_Config2__BasePriceMethod__c = 'Per Unit';
        liGP2.Apttus_Config2__BillingFrequency__c = 'Monthly';
        liGP2.Apttus_Config2__ChargeType__c = 'Subscription Fee';
        liGP2.Apttus_Config2__ItemSequence__c = 1;
        liGP2.Apttus_Config2__LineNumber__c = 1;
        liGP2.Apttus_Config2__LineSequence__c = 1;
        liGP2.Apttus_Config2__LineStatus__c = 'Renewed';
        liGP2.Apttus_Config2__LineType__c = 'Product/Service';
        liGP2.Apttus_Config2__ListPrice__c = 100;
        liGP2.Apttus_Config2__NetAdjustmentPercent__c = -50;
        liGP2.Apttus_Config2__NetPrice__c = 50;
        liGP2.Apttus_Config2__NetUnitPrice__c = 50;
        liGP2.Apttus_Config2__OptionSequence__c = 0;
        liGP2.Apttus_Config2__PriceIncludedInBundle__c = FALSE;
        liGP2.Apttus_Config2__PriceMethod__c = 'Per Unit';
        liGP2.Apttus_Config2__PriceType__c = 'Recurring';
        liGP2.CurrencyIsoCode = 'USD';
        liGP2.APTS_Product_Family__c = 'WESTLAW';
        liGP2.APTS_Contract_Term__c = '2 Years';
        liGP2.APTS_Years_2_Plus_Adjustment__c = '4';
        liGP2.APTS_Product_Delivery__c = 'Online/Internet';
        liGP2.Apttus_Config2__Quantity__c = 1;
        liGP2.Apttus_Config2__AssetLineItemId__c=asset3.Id;
        lineItemNew.add(liGP2);
        
        Apttus_Config2__LineItem__c liGP3 = new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c=prodConf.id , Apttus_Config2__ProductId__c=prod3.id);
        liGP3.Apttus_Config2__AddedBy__c = 'User';
        liGP3.Apttus_Config2__AdjustedPrice__c = 50;
        liGP3.Apttus_Config2__AdjustmentAmount__c = 50;
        liGP3.Apttus_Config2__AdjustmentType__c = '% Discount';
        liGP3.Apttus_Config2__AllocateGroupAdjustment__c = TRUE;
        liGP3.Apttus_Config2__AllowableAction__c = 'Unrestricted';
        liGP3.Apttus_Config2__BaseExtendedPrice__c = 100;
        liGP3.Apttus_Config2__BasePrice__c = 100;
        liGP3.Apttus_Config2__BasePriceMethod__c = 'Per Unit';
        liGP3.Apttus_Config2__BillingFrequency__c = 'Monthly';
        liGP3.Apttus_Config2__ChargeType__c = 'Subscription Fee';
        liGP3.Apttus_Config2__ItemSequence__c = 1;
        liGP3.Apttus_Config2__LineNumber__c = 1;
        liGP3.Apttus_Config2__LineSequence__c = 1;
        liGP3.Apttus_Config2__LineStatus__c = 'Cancelled';
        liGP3.Apttus_Config2__LineType__c = 'Product/Service';
        liGP3.Apttus_Config2__ListPrice__c = 100;
        liGP3.Apttus_Config2__NetAdjustmentPercent__c = -50;
        liGP3.Apttus_Config2__NetPrice__c = 50;
        liGP3.Apttus_Config2__NetUnitPrice__c = 50;
        liGP3.Apttus_Config2__OptionSequence__c = 0;
        liGP3.Apttus_Config2__PriceIncludedInBundle__c = FALSE;
        liGP3.Apttus_Config2__PriceMethod__c = 'Per Unit';
        liGP3.Apttus_Config2__PriceType__c = 'Recurring';
        liGP3.CurrencyIsoCode = 'USD';
        liGP3.APTS_Product_Family__c = 'WESTLAW';
        liGP3.APTS_Contract_Term__c = '2 Years';
        liGP3.APTS_Years_2_Plus_Adjustment__c = '4';
        liGP3.APTS_Product_Delivery__c = 'Online/Internet';
        liGP3.Apttus_Config2__Quantity__c = 1;
        liGP3.Apttus_Config2__AssetLineItemId__c=asset4.Id;
        lineItemNew.add(liGP3);
        
        Apttus_Config2__LineItem__c liGP4 = new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c=prodConf.id , Apttus_Config2__ProductId__c=prod4.id);
        liGP4.Apttus_Config2__AddedBy__c = 'User';
        liGP4.Apttus_Config2__AdjustedPrice__c = 50;
        liGP4.Apttus_Config2__AdjustmentAmount__c = 50;
        liGP4.Apttus_Config2__AdjustmentType__c = '% Discount';
        liGP4.Apttus_Config2__AllocateGroupAdjustment__c = TRUE;
        liGP4.Apttus_Config2__AllowableAction__c = 'Unrestricted';
        liGP4.Apttus_Config2__BaseExtendedPrice__c = 100;
        liGP4.Apttus_Config2__BasePrice__c = 100;
        liGP4.Apttus_Config2__BasePriceMethod__c = 'Per Unit';
        liGP4.Apttus_Config2__BillingFrequency__c = 'Monthly';
        liGP4.Apttus_Config2__ChargeType__c = 'Subscription Fee';
        liGP4.Apttus_Config2__ItemSequence__c = 1;
        liGP4.Apttus_Config2__LineNumber__c = 1;
        liGP4.Apttus_Config2__LineSequence__c = 1;
        liGP4.Apttus_Config2__LineStatus__c = 'Renewed';
        liGP4.Apttus_Config2__LineType__c = 'Product/Service';
        liGP4.Apttus_Config2__ListPrice__c = 100;
        liGP4.Apttus_Config2__NetAdjustmentPercent__c = -50;
        liGP4.Apttus_Config2__NetPrice__c = 50;
        liGP4.Apttus_Config2__NetUnitPrice__c = 50;
        liGP4.Apttus_Config2__OptionSequence__c = 0;
        liGP4.Apttus_Config2__PriceIncludedInBundle__c = FALSE;
        liGP4.Apttus_Config2__PriceMethod__c = 'Per Unit';
        liGP4.Apttus_Config2__PriceType__c = 'Recurring';
        liGP4.CurrencyIsoCode = 'USD';
        liGP4.APTS_Product_Family__c = 'WESTLAW';
        liGP4.APTS_Contract_Term__c = '2 Years';
        liGP4.APTS_Years_2_Plus_Adjustment__c = '4';
        liGP4.Apttus_Config2__AssetLineItemId__c = asset5.Id;
        liGP4.APTS_Product_Delivery__c = 'Online/Internet';
        liGP4.Apttus_Config2__Quantity__c = 1;
        liGP4.APTS_Yr_1_Renewal_Adjustment__c = '3';
        lineItemNew.add(liGP4);
        
        Apttus_Config2__LineItem__c li3Tax = new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c=prodConf1.id , Apttus_Config2__ProductId__c=prod2.id);
        li3Tax.Apttus_Config2__AssetLineItemId__c=asset.id;
        li3Tax.Apttus_Config2__AddedBy__c = 'User';
        li3Tax.Apttus_Config2__AdjustedPrice__c = 50;
        li3Tax.Apttus_Config2__AdjustmentAmount__c = 50;
        li3Tax.Apttus_Config2__AdjustmentType__c = '% Discount';
        li3Tax.Apttus_Config2__AllocateGroupAdjustment__c = TRUE;
        li3Tax.Apttus_Config2__AllowableAction__c = 'Unrestricted';
        li3Tax.Apttus_Config2__AllowManualAdjustment__c = TRUE;
        li3Tax.Apttus_Config2__AllowProration__c = FALSE;
        li3Tax.Apttus_Config2__AllowRemoval__c = TRUE;
        li3Tax.Apttus_Config2__AutoRenew__c = FALSE;
        li3Tax.Apttus_Config2__BaseExtendedCost__c = 0;
        li3Tax.Apttus_Config2__BaseExtendedPrice__c = 100;
        li3Tax.Apttus_Config2__BasePrice__c = 100;
        li3Tax.Apttus_Config2__BasePriceMethod__c = 'Per Unit';
        li3Tax.Apttus_Config2__BillingFrequency__c = 'Monthly';
        li3Tax.Apttus_Config2__ChargeType__c = 'Subscription Fee';
        li3Tax.Apttus_Config2__ConfigStatus__c = 'Complete';
        li3Tax.Apttus_Config2__ConstraintCheckStatus__c = 'NA';
        li3Tax.Apttus_Config2__Customizable__c = FALSE;
        li3Tax.Apttus_Config2__DeltaPrice__c = 50;
        li3Tax.Apttus_Config2__DeltaQuantity__c = 1;
        li3Tax.Apttus_Config2__Description__c = 'Westlaw Flex Plan $100/500';
        li3Tax.Apttus_Config2__ExtendedCost__c = 0;
        li3Tax.Apttus_Config2__ExtendedPrice__c = 100;
        li3Tax.Apttus_Config2__Frequency__c = 'Monthly';
        li3Tax.Apttus_Config2__Guidance__c = 'Red';
        li3Tax.Apttus_Config2__HasAttributes__c = FALSE;
        li3Tax.Apttus_Config2__HasBaseProduct__c = FALSE;
        li3Tax.Apttus_Config2__HasDefaults__c = FALSE;
        li3Tax.Apttus_Config2__HasIncentives__c = FALSE;
        li3Tax.Apttus_Config2__HasOptions__c = FALSE;
        li3Tax.Apttus_Config2__HasTieredPrice__c = FALSE;
        li3Tax.Apttus_Config2__HideCopyAction__c = FALSE;
        li3Tax.Apttus_Config2__HideInvoiceDisplay__c = FALSE;
        li3Tax.Apttus_Config2__IsAssetPricing__c = FALSE;
        li3Tax.Apttus_Config2__IsCustomPricing__c = FALSE;
        li3Tax.Apttus_Config2__IsHidden__c = FALSE;
        li3Tax.Apttus_Config2__IsOptionRollupLine__c = FALSE;
        li3Tax.Apttus_Config2__IsPrimaryLine__c = TRUE;
        li3Tax.Apttus_Config2__IsPrimaryRampLine__c = FALSE;
        li3Tax.Apttus_Config2__IsQuantityModifiable__c = FALSE;
        li3Tax.Apttus_Config2__IsReadOnly__c = FALSE;
        li3Tax.Apttus_Config2__IsSellingTermReadOnly__c = FALSE;
        li3Tax.Apttus_Config2__IsUsageTierModifiable__c = FALSE;
        li3Tax.Apttus_Config2__ItemSequence__c = 1;
        li3Tax.Apttus_Config2__LineNumber__c = 1;
        li3Tax.Apttus_Config2__LineSequence__c = 1;
        li3Tax.Apttus_Config2__LineStatus__c = 'Cancelled';
        li3Tax.APTS_Yr_1_Renewal_Adjustment__c ='1';
        li3Tax.Apttus_Config2__LineType__c = 'Product/Service';
        li3Tax.Apttus_Config2__ListPrice__c = 100;
        li3Tax.Apttus_Config2__NetAdjustmentPercent__c = -50;
        li3Tax.Apttus_Config2__NetPrice__c = 50;
        li3Tax.Apttus_Config2__NetUnitPrice__c = 50;
        li3Tax.Apttus_Config2__OptionSequence__c = 0;
        li3Tax.Apttus_Config2__PriceIncludedInBundle__c = FALSE;
        li3Tax.Apttus_Config2__PriceMethod__c = 'Per Unit';
        li3Tax.Apttus_Config2__PriceType__c = 'Recurring';
        li3Tax.Apttus_Config2__PriceUom__c = 'Each';
        li3Tax.Apttus_Config2__PricingStatus__c = 'Complete';
        li3Tax.Apttus_Config2__PrimaryLineNumber__c = 1;
        li3Tax.Apttus_Config2__ProductVersion__c = 1;
        li3Tax.Apttus_Config2__Quantity__c = 1;
        li3Tax.Apttus_Config2__RollupPriceToBundle__c = TRUE;
        li3Tax.Apttus_Config2__SellingFrequency__c = 'Monthly';
        li3Tax.Apttus_Config2__SellingTerm__c = 1;
        li3Tax.Apttus_Config2__SyncStatus__c = 'Pending';
        li3Tax.Apttus_Config2__Taxable__c = FALSE;
        li3Tax.Apttus_Config2__TaxInclusive__c = FALSE;
        li3Tax.Apttus_Config2__Term__c = 1;
        li3Tax.Apttus_Config2__TotalQuantity__c = 1;
        li3Tax.Apttus_Config2__Uom__c = 'Each';
        li3Tax.Apttus_CQApprov__Approval_Status__c = 'Pending Approval';
        li3Tax.CurrencyIsoCode = 'USD';
        li3Tax.APTS_Product_Family__c = 'WESTLAW';
        li3Tax.APTS_Contract_Term__c = '2 Years';
        li3Tax.APTS_Years_2_Plus_Adjustment__c = '4';
        li3Tax.Apttus_Config2__AssetLineItemId__c = asset.Id;
        li3Tax.APTS_Product_Delivery__c = 'Online/Internet';
        li3Tax.Apttus_Config2__Quantity__c = 1;
        lineItemNew.add(li3Tax);
              
        List<Apttus_Config2__LineItem__c > listUpdate = new List<Apttus_Config2__LineItem__c >();
        System.runAs(u){
                       
        insert lineItemNew;
        System.debug('PBU L7='+li7.APTS_Proposal_Business_Unit__c+'PD L7='+li7.APTS_Product_Delivery__c);
        System.debug('PBU L6='+li6.APTS_Proposal_Business_Unit__c+'PD L6='+li6.APTS_Product_Delivery__c);
        System.debug('PBU L5='+li5.APTS_Proposal_Business_Unit__c+'PD L5='+li5.APTS_Product_Delivery__c);
        System.debug('PBU L4='+li4.APTS_Proposal_Business_Unit__c+'PD L4='+li4.APTS_Product_Delivery__c);
        
        Test.startTest();
        li2.APTS_Product_Family__c ='CASE LOGISTIX';  
        //li2.APTS_Cat_L3__c = System.Label.APTS_Case_Logistix_Product_Family;     
        li2.APTS_Contract_Term__c = '1 Year';           
        li2.Apttus_Config2__LineStatus__c = 'Renewed';
        li2.APTS_Yr_1_Renewal_Adjustment__c= '1';
        li2.Apttus_Config2__NetPrice__c = 50;            
        listUpdate.add(li2);
        li5.Apttus_Config2__NetPrice__c = 50;
        li5.Apttus_Config2__LineStatus__c = 'Cancelled';    
        listUpdate.add(li5);
        li6.APTS_Product_Delivery__c = 'Download';
        listUpdate.add(li6);
        li7.APTS_Product_Delivery__c = 'Download';
        listUpdate.add(li7);
        update listUpdate ;
        
        delete li2;
        }
        
        a.APTS_Customer_Category__c = '5';
        update a;
        accountSSD.APTS_Customer_Category__c = '5';
        update accountSSD;
        p.APTS_Approval_Segment__c = 'Corporate Large';
        update p;
        
        
        Apttus_Config2__LineItem__c li3 = new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c=prodConf1.id , Apttus_Config2__ProductId__c=prod.id);
        li3.Apttus_Config2__AddedBy__c = 'User';
        li3Tax.Apttus_Config2__AssetLineItemId__c = asset.Id;
        li3.Apttus_Config2__AdjustedPrice__c = 50;
        li3.Apttus_Config2__AdjustmentAmount__c = 50;
        li3.Apttus_Config2__AdjustmentType__c = '% Discount';
        li3.Apttus_Config2__AllocateGroupAdjustment__c = TRUE;
        li3.Apttus_Config2__AllowableAction__c = 'Unrestricted';
        li3.Apttus_Config2__AllowManualAdjustment__c = TRUE;
        li3.Apttus_Config2__AllowProration__c = FALSE;
        li3.Apttus_Config2__AllowRemoval__c = TRUE;
        li3.Apttus_Config2__AutoRenew__c = FALSE;
        li3.Apttus_Config2__BaseExtendedCost__c = 0;
        li3.Apttus_Config2__BaseExtendedPrice__c = 100;
        li3.Apttus_Config2__BasePrice__c = 100;
        li3.Apttus_Config2__BasePriceMethod__c = 'Per Unit';
        li3.Apttus_Config2__BillingFrequency__c = 'Monthly';
        li3.Apttus_Config2__ChargeType__c = 'Subscription Fee';
        li3.Apttus_Config2__ConfigStatus__c = 'Complete';
        li3.Apttus_Config2__ConstraintCheckStatus__c = 'NA';
        li3.Apttus_Config2__Customizable__c = FALSE;
        li3.Apttus_Config2__DeltaPrice__c = 50;
        li3.Apttus_Config2__DeltaQuantity__c = 1;
        li3.Apttus_Config2__Description__c = 'Westlaw Flex Plan $100/500';
        li3.Apttus_Config2__ExtendedCost__c = 0;
        li3.Apttus_Config2__ExtendedPrice__c = 100;
        li3.Apttus_Config2__Frequency__c = 'Monthly';
        li3.Apttus_Config2__Guidance__c = 'Red';
        li3.Apttus_Config2__HasAttributes__c = FALSE;
        li3.Apttus_Config2__HasBaseProduct__c = FALSE;
        li3.Apttus_Config2__HasDefaults__c = FALSE;
        li3.Apttus_Config2__HasIncentives__c = FALSE;
        li3.Apttus_Config2__HasOptions__c = FALSE;
        li3.Apttus_Config2__HasTieredPrice__c = FALSE;
        li3.Apttus_Config2__HideCopyAction__c = FALSE;
        li3.Apttus_Config2__HideInvoiceDisplay__c = FALSE;
        li3.Apttus_Config2__IsAssetPricing__c = FALSE;
        li3.Apttus_Config2__IsCustomPricing__c = FALSE;
        li3.Apttus_Config2__IsHidden__c = FALSE;
        li3.Apttus_Config2__IsOptionRollupLine__c = FALSE;
        li3.Apttus_Config2__IsPrimaryLine__c = TRUE;
        li3.Apttus_Config2__IsPrimaryRampLine__c = FALSE;
        li3.Apttus_Config2__IsQuantityModifiable__c = FALSE;
        li3.Apttus_Config2__IsReadOnly__c = FALSE;
        li3.Apttus_Config2__IsSellingTermReadOnly__c = FALSE;
        li3.Apttus_Config2__IsUsageTierModifiable__c = FALSE;
        li3.Apttus_Config2__ItemSequence__c = 1;
        li3.Apttus_Config2__LineNumber__c = 1;
        li3.Apttus_Config2__LineSequence__c = 1;
        li3.Apttus_Config2__LineStatus__c = 'Cancelled';
        li3.Apttus_Config2__LineType__c = 'Product/Service';
        li3.Apttus_Config2__ListPrice__c = 100;
        li3.Apttus_Config2__NetAdjustmentPercent__c = -50;
        li3.Apttus_Config2__NetPrice__c = 50;
        li3.Apttus_Config2__NetUnitPrice__c = 50;
        li3.Apttus_Config2__OptionSequence__c = 0;
        li3.Apttus_Config2__PriceIncludedInBundle__c = FALSE;
        li3.Apttus_Config2__PriceMethod__c = 'Per Unit';
        li3.Apttus_Config2__PriceType__c = 'Recurring';
        li3.Apttus_Config2__PriceUom__c = 'Each';
        li3.Apttus_Config2__PricingStatus__c = 'Complete';
        li3.Apttus_Config2__PrimaryLineNumber__c = 1;
        li3.Apttus_Config2__ProductVersion__c = 1;
        li3.Apttus_Config2__Quantity__c = 1;
        li3.Apttus_Config2__RollupPriceToBundle__c = TRUE;
        li3.Apttus_Config2__SellingFrequency__c = 'Monthly';
        li3.Apttus_Config2__SellingTerm__c = 1;
        li3.Apttus_Config2__SyncStatus__c = 'Pending';
        li3.Apttus_Config2__Taxable__c = FALSE;
        li3.Apttus_Config2__TaxInclusive__c = FALSE;
        li3.Apttus_Config2__Term__c = 1;
        li3.Apttus_Config2__TotalQuantity__c = 1;
        li3.Apttus_Config2__Uom__c = 'Each';
        li3.APTS_Product_Delivery__c='Online/Internet';
        li3.Apttus_CQApprov__Approval_Status__c = 'Pending Approval';
        li3.CurrencyIsoCode = 'USD';
        li3.APTS_Product_Family__c = 'PRINT LEGAL SOLUTIONS';
        //li3.APTS_Cat_L2__c=System.Label.APTS_Print_Product_Family;
        li3.APTS_Contract_Term__c = '2 Years';
        li3.APTS_Years_2_Plus_Adjustment__c = '5';
        
        insert li3;       
        Test.stopTest();        
        configSetting.Apttus_Config2__DisableConstraintRules__c = False;
        update configSetting;     
        APTS_LineItemTriggerHelper.calculateIncrementGrowth(prodConf.id);
        APTS_LineItemTriggerHelper.calculateIncrementGrowth(prodConf1.id);
        APTS_LineItemTriggerHelper.populateAllApprovalRequiredCB(lineItemNew);
        System.assertEquals(null, prodConf.APTS_Incremental_Growth__c);        
    }

    static testMethod void validateTruncate() {
        decimal d = APTS_LineItemTriggerHelper.truncate(100.1267, 3);
        System.assertEquals(100.126, d);
    }

    static testMethod void smallLawApprovalTest() {
        
       List<KeyValueListStore__c> keyvaluestoreList = new List<KeyValueListStore__c>();
        KeyValueListStore__c keyvaluestore=new  KeyValueListStore__c();
        keyvaluestore.Name='ANZUsersProfileId';
        keyvaluestore.TextValue__c=System.Label.APTS_OC_Test_Id;
        keyvaluestoreList.add(keyvaluestore); 
        KeyValueListStore__c keyval = new KeyValueListStore__c();
        keyval.Name='ReasonWithCompetitor';
        keyval.TextValue__c='Price';
        keyvaluestoreList.add(keyval);
        insert keyvaluestoreList;
        
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

        List<APTS_Segment_Threshold__c> segthrList= new List<APTS_Segment_Threshold__c>();
        //Add Segment threshold
        APTS_Segment_Threshold__c seg1 = new APTS_Segment_Threshold__c();
        seg1.APTS_Approval_Required__c=True;
        seg1.APTS_Segment__c='Small Law';
        seg1.APTS_Customer_Category__c='5';
        seg1.APTS_Term_in_years__c=Integer.ValueOf('2');
        seg1.APTS_Minimum_OY_Increase__c=Integer.ValueOf('15');
        seg1.APTS_Promo_Codes__c = '13843012';        
        segthrList.add(seg1);
        
        APTS_Segment_Threshold__c seg2 = new APTS_Segment_Threshold__c();
        seg2.APTS_Approval_Required__c=True;
        seg2.APTS_Segment__c='Corporate';
        seg2.APTS_Customer_Category__c='5';
        seg2.APTS_Term_in_years__c=Integer.ValueOf('2');
        seg2.APTS_Minimum_OY_Increase__c=Integer.ValueOf('15');
        seg2.APTS_Promo_Codes__c = '13843012';
        segthrList.add(seg2);       
        
        System.assertEquals(seg2.APTS_Promo_Codes__c, '13843012');
        
        APTS_Segment_Threshold__c seg3 = new APTS_Segment_Threshold__c();
        seg3.APTS_Approval_Required__c=True;
        seg3.APTS_Segment__c='Small Law';
        seg3.APTS_Customer_Category__c='5';
        seg3.APTS_Term_in_years__c=Integer.ValueOf('2');
        seg3.APTS_Minimum_OY_Increase__c=Integer.ValueOf('15');
        seg3.APTS_Promo_Codes__c = '13843013';
        seg3.APTS_Promo_Minimum_OY_Increase__c = 16;        
        segthrList.add(seg3);
        insert segthrList;               
        
        Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
        Account a = new Account(RecordTypeId=accRecordTypeId,name='test-sg',sales_org__c='ABEP',customer_group__c='Academic',customer_type__c='Organization',customer_class_c__c='Academic Lecturer');
        a.APTS_Customer_Category__c = '5';
        a.Is_GLI__c = True;
        insert a;
        
        Schema.DescribeFieldResult fieldResultMarket = Apttus_Config2__ProductConfiguration__c.APTS_AccountMirror_Picklist__c.getDescribe();
        String valueMarket = fieldResultMarket.getPicklistValues().get(0).getValue();
        
        //Inserting SourceSystemDetail
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();
        Source_System_Detail__c accountSSD= new Source_System_Detail__c();
        accountSSD.RecordtypeId=ssdRecorType;
        accountSSD.Name='ABC';
        accountSSD.Source_System_Name__c='ABC';
        accountSSD.Account_Name__c=a.ID;
        accountSSD.APTS_Customer_Category__c='1';
        accountSSD.LCRM_Customer_Group__c='Academic';
        accountSSD.LCRM_Frozen_Market_Segment__c = valueMarket;
        accountSSD.Account_Inactive__c=false;
        accountSSD.LCRM_Sales_Org__c='WEST';
        insert accountSSD;
        
        Date todaysDate = system.today();
        Id oppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Pipeline Opportunity').getRecordTypeId();
        Opportunity o = new Opportunity(RecordTypeId=oppRecordTypeId,  Name='tst-opp', stagename='25%',closedate=todaysDate,forecastcategoryname='pipeline',accountId=a.id);
        insert o;
        
        Id devRecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Proposal').getRecordTypeId();
        Apttus_Proposal__Proposal__c p = new Apttus_Proposal__Proposal__c(RecordTypeId=devRecordTypeId, CurrencyIsoCode = 'USD',Apttus_Proposal__Account__c=a.id, Apttus_Proposal__Proposal_Name__c='TST-10', APTS_SSD_Sold_To__c=accountSSD.Id,APTS_SSD_ship_to__c=accountSSD.Id,APTS_SSD_bill_to__c=accountSSD.Id, Apttus_Proposal__Opportunity__c=o.id, Apttus_Proposal__Approval_Stage__c='Draft', Apttus_Proposal__Proposal_Category__c='Quote', Apttus_Proposal__ReadyToGenerate__c = true, Apttus_Proposal__ReadyToPresent__c= true);
        p.APTS_Approval_Segment__c = 'Small Law';        
        insert p;
        
        Apttus_Proposal__Proposal__c p1 = new Apttus_Proposal__Proposal__c(RecordTypeId=devRecordTypeId, CurrencyIsoCode = 'USD',Apttus_Proposal__Account__c=a.id, Apttus_Proposal__Proposal_Name__c='TST-10', APTS_SSD_Sold_To__c=accountSSD.Id,APTS_SSD_ship_to__c=accountSSD.Id,APTS_SSD_bill_to__c=accountSSD.Id, Apttus_Proposal__Opportunity__c=o.id, Apttus_Proposal__Approval_Stage__c='Draft', Apttus_Proposal__Proposal_Category__c='Quote', Apttus_Proposal__ReadyToGenerate__c = true, Apttus_Proposal__ReadyToPresent__c= true);
        p1.APTS_Proposal_Business_Unit__c= 'SCS';        
        insert p1;
        
        Apttus_Config2__ProductConfiguration__c prodConf = new Apttus_Config2__ProductConfiguration__c(Name='prod-conf1', CurrencyIsoCode = 'USD', Apttus_QPConfig__Proposald__c=p.id, APTS_SSD_ship_to__c=accountSSD.Id,APTS_SSD_bill_to__c=accountSSD.Id);
        insert prodConf;
        Apttus_Config2__ProductConfiguration__c prodConf1 = new Apttus_Config2__ProductConfiguration__c(Name='prod-conf1', CurrencyIsoCode = 'USD', Apttus_QPConfig__Proposald__c=p1.id, APTS_SSD_ship_to__c=accountSSD.Id,APTS_SSD_bill_to__c=accountSSD.Id);
        insert prodConf1;  
        
        
        Product2 prod = new Product2(name='prod1', Media_High_Level__c='Online', CurrencyIsoCode = 'USD',APTS_CAT_L2__c=System.Label.APTS_Clear_Product_Family,APTS_CAT_L3__c='L3_L030_FP');
        insert prod;
        
        Product2 prod2 = new Product2(name='prod1', Media_High_Level__c='Online', CurrencyIsoCode = 'USD',Family='PRINT LEGAL SOLUTIONS',APTS_Cat_L2__c=System.Label.APTS_Print_Product_Family,APTS_CAT_L3__c='L3_L030_FP' );
        insert prod2;
        
        Apttus_Config2__AssetLineItem__c asset1 = new Apttus_Config2__AssetLineItem__c(Name = 'Test asset', APTS_Info_PlanType__c = 'S00', 
                                                                                      Apttus_Config2__NetPrice__c = 10.00, APTS_SSD_Bill_To__c = accountSSD.Id,
                                                                                      Apttus_QPConfig__ProposalId__c =p1.id,
                                                                                      APTS_Info_RenewalDate__c = System.today().addDays(150),Apttus_Config2__BasePriceMethod__c = 'Per Unit');
        insert asset1;
        
        Apttus_Config2__ConfigSystemProperties__c configSetting=new Apttus_Config2__ConfigSystemProperties__c(Name='System Properties',Apttus_Config2__DisableConstraintRules__c=true);
        insert configSetting;
        List<Apttus_Config2__LineItem__c> insertList=new List<Apttus_Config2__LineItem__c>();
        List<Apttus_Config2__LineItem__c> updateList=new List<Apttus_Config2__LineItem__c>();
        
        test.startTest();
        Apttus_Config2__LineItem__c li3 = new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c=prodConf.id , Apttus_Config2__ProductId__c=prod.id);
        li3.Apttus_Config2__AddedBy__c = 'User';
        li3.Apttus_Config2__AdjustedPrice__c = 50;
        li3.Apttus_Config2__AdjustmentAmount__c = 50;
        li3.Apttus_Config2__AdjustmentType__c = '% Discount';
        li3.Apttus_Config2__AllocateGroupAdjustment__c = TRUE;
        li3.Apttus_Config2__AllowableAction__c = 'Unrestricted';
        li3.Apttus_Config2__AllowManualAdjustment__c = TRUE;
        li3.Apttus_Config2__AllowProration__c = FALSE;
        li3.Apttus_Config2__AllowRemoval__c = TRUE;
        li3.Apttus_Config2__AutoRenew__c = FALSE;
        li3.Apttus_Config2__BaseExtendedCost__c = 0;
        li3.Apttus_Config2__BaseExtendedPrice__c = 100;
        li3.Apttus_Config2__BasePrice__c = 100;
        li3.Apttus_Config2__BasePriceMethod__c = 'Per Unit';
        li3.Apttus_Config2__BillingFrequency__c = 'Monthly';
        li3.Apttus_Config2__ChargeType__c = 'Subscription Fee';
        li3.Apttus_Config2__ConfigStatus__c = 'Complete';
        li3.Apttus_Config2__ConstraintCheckStatus__c = 'NA';
        li3.Apttus_Config2__Customizable__c = FALSE;
        li3.Apttus_Config2__DeltaPrice__c = 50;
        li3.Apttus_Config2__DeltaQuantity__c = 1;
        li3.Apttus_Config2__Description__c = 'Westlaw Flex Plan $100/500';
        li3.Apttus_Config2__ExtendedCost__c = 0;
        li3.Apttus_Config2__ExtendedPrice__c = 100;
        li3.Apttus_Config2__Frequency__c = 'Monthly';
        li3.Apttus_Config2__Guidance__c = 'Red';
        li3.Apttus_Config2__HasAttributes__c = FALSE;
        li3.Apttus_Config2__HasBaseProduct__c = FALSE;
        li3.Apttus_Config2__HasDefaults__c = FALSE;
        li3.Apttus_Config2__HasIncentives__c = FALSE;
        li3.Apttus_Config2__HasOptions__c = FALSE;
        li3.Apttus_Config2__HasTieredPrice__c = FALSE;
        li3.Apttus_Config2__HideCopyAction__c = FALSE;
        li3.Apttus_Config2__HideInvoiceDisplay__c = FALSE;
        li3.Apttus_Config2__IsAssetPricing__c = FALSE;
        li3.Apttus_Config2__IsCustomPricing__c = FALSE;
        li3.Apttus_Config2__IsHidden__c = FALSE;
        li3.Apttus_Config2__IsOptionRollupLine__c = FALSE;
        li3.Apttus_Config2__IsPrimaryLine__c = TRUE;
        li3.Apttus_Config2__IsPrimaryRampLine__c = FALSE;
        li3.Apttus_Config2__IsQuantityModifiable__c = FALSE;
        li3.Apttus_Config2__IsReadOnly__c = FALSE;
        li3.Apttus_Config2__IsSellingTermReadOnly__c = FALSE;
        li3.Apttus_Config2__IsUsageTierModifiable__c = FALSE;
        li3.Apttus_Config2__ItemSequence__c = 1;
        li3.Apttus_Config2__LineNumber__c = 1;
        li3.Apttus_Config2__LineSequence__c = 1;
        li3.Apttus_Config2__LineStatus__c = 'Renewed';
        li3.Apttus_Config2__LineType__c = 'Product/Service';
        li3.Apttus_Config2__ListPrice__c = 100;
        li3.Apttus_Config2__NetAdjustmentPercent__c = -50;
        li3.Apttus_Config2__NetPrice__c = 50;
        li3.Apttus_Config2__NetUnitPrice__c = 50;
        li3.Apttus_Config2__OptionSequence__c = 0;
        li3.Apttus_Config2__PriceIncludedInBundle__c = FALSE;
        li3.Apttus_Config2__PriceMethod__c = 'Per Unit';
        li3.Apttus_Config2__PriceType__c = 'Recurring';
        li3.Apttus_Config2__PriceUom__c = 'Each';
        li3.Apttus_Config2__PricingStatus__c = 'Complete';
        li3.Apttus_Config2__PrimaryLineNumber__c = 1;
        li3.Apttus_Config2__ProductVersion__c = 1;
        li3.Apttus_Config2__Quantity__c = 1;
        li3.Apttus_Config2__RollupPriceToBundle__c = TRUE;
        li3.Apttus_Config2__SellingFrequency__c = 'Monthly';
        li3.Apttus_Config2__SellingTerm__c = 1;
        li3.Apttus_Config2__SyncStatus__c = 'Pending';
        li3.Apttus_Config2__Taxable__c = FALSE;
        li3.Apttus_Config2__TaxInclusive__c = FALSE;
        li3.Apttus_Config2__Term__c = 1;
        li3.Apttus_Config2__TotalQuantity__c = 1;
        li3.Apttus_Config2__Uom__c = 'Each';
        li3.Apttus_CQApprov__Approval_Status__c = 'Pending Approval';
        li3.CurrencyIsoCode = 'USD';
        li3.APTS_Product_Family__c = 'Non-Clear';
        li3.APTS_Contract_Term__c = '2 Years';
        li3.APTS_Years_2_Plus_Adjustment__c = '5';
        li3.APTS_Contract_Term__c='1 Year';
        insertList.add(li3);
        
        Apttus_Config2__LineItem__c liCancel = new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c=prodConf.id , Apttus_Config2__ProductId__c=prod.id);
        liCancel.Apttus_Config2__AddedBy__c = 'User';
        liCancel.Apttus_Config2__AdjustedPrice__c = 50;
        liCancel.Apttus_Config2__AssetLineItemId__c = asset1.Id;
        liCancel.Apttus_Config2__AdjustmentAmount__c = 50;
        liCancel.Apttus_Config2__AdjustmentType__c = '% Discount';
        liCancel.Apttus_Config2__AllocateGroupAdjustment__c = TRUE;
        liCancel.Apttus_Config2__AllowableAction__c = 'Unrestricted';
        liCancel.Apttus_Config2__AllowManualAdjustment__c = TRUE;
        liCancel.Apttus_Config2__AllowProration__c = FALSE;
        liCancel.Apttus_Config2__AllowRemoval__c = TRUE;
        liCancel.Apttus_Config2__AutoRenew__c = FALSE;
        liCancel.Apttus_Config2__BaseExtendedCost__c = 0;
        liCancel.Apttus_Config2__BaseExtendedPrice__c = 100;
        liCancel.Apttus_Config2__BasePrice__c = 100;
        liCancel.Apttus_Config2__BasePriceMethod__c = 'Per Unit';
        liCancel.Apttus_Config2__BillingFrequency__c = 'Monthly';
        liCancel.Apttus_Config2__ChargeType__c = 'Subscription Fee';
        liCancel.Apttus_Config2__ConfigStatus__c = 'Complete';
        liCancel.Apttus_Config2__ConstraintCheckStatus__c = 'NA';
        liCancel.Apttus_Config2__Customizable__c = FALSE;
        liCancel.Apttus_Config2__DeltaPrice__c = 50;
        liCancel.Apttus_Config2__DeltaQuantity__c = 1;
        liCancel.Apttus_Config2__Description__c = 'Westlaw Flex Plan $100/500';
        liCancel.Apttus_Config2__ExtendedCost__c = 0;
        liCancel.Apttus_Config2__ExtendedPrice__c = 100;
        liCancel.Apttus_Config2__Frequency__c = 'Monthly';
        liCancel.Apttus_Config2__Guidance__c = 'Red';
        liCancel.Apttus_Config2__HasAttributes__c = FALSE;
        liCancel.Apttus_Config2__HasBaseProduct__c = FALSE;
        liCancel.Apttus_Config2__HasDefaults__c = FALSE;
        liCancel.Apttus_Config2__HasIncentives__c = FALSE;
        liCancel.Apttus_Config2__HasOptions__c = FALSE;
        liCancel.Apttus_Config2__HasTieredPrice__c = FALSE;
        liCancel.Apttus_Config2__HideCopyAction__c = FALSE;
        liCancel.Apttus_Config2__HideInvoiceDisplay__c = FALSE;
        liCancel.Apttus_Config2__IsAssetPricing__c = FALSE;
        liCancel.Apttus_Config2__IsCustomPricing__c = FALSE;
        liCancel.Apttus_Config2__IsHidden__c = FALSE;
        liCancel.Apttus_Config2__IsOptionRollupLine__c = FALSE;
        liCancel.Apttus_Config2__IsPrimaryLine__c = TRUE;
        liCancel.Apttus_Config2__IsPrimaryRampLine__c = FALSE;
        liCancel.Apttus_Config2__IsQuantityModifiable__c = FALSE;
        liCancel.Apttus_Config2__IsReadOnly__c = FALSE;
        liCancel.Apttus_Config2__IsSellingTermReadOnly__c = FALSE;
        liCancel.Apttus_Config2__IsUsageTierModifiable__c = FALSE;
        liCancel.Apttus_Config2__ItemSequence__c = 1;
        liCancel.Apttus_Config2__LineNumber__c = 1;
        liCancel.Apttus_Config2__LineSequence__c = 1;
        liCancel.Apttus_Config2__LineStatus__c = 'Renewed';
        liCancel.APTS_Yr_1_Renewal_Adjustment__c='1';
        liCancel.Apttus_Config2__LineType__c = 'Product/Service';
        liCancel.Apttus_Config2__ListPrice__c = 100;
        liCancel.Apttus_Config2__NetAdjustmentPercent__c = -50;
        liCancel.Apttus_Config2__NetPrice__c = 50;
        liCancel.Apttus_Config2__NetUnitPrice__c = 50;
        liCancel.Apttus_Config2__OptionSequence__c = 0;
        liCancel.Apttus_Config2__PriceIncludedInBundle__c = FALSE;
        liCancel.Apttus_Config2__PriceMethod__c = 'Per Unit';
        liCancel.Apttus_Config2__PriceType__c = 'Recurring';
        liCancel.Apttus_Config2__PriceUom__c = 'Each';
        liCancel.Apttus_Config2__PricingStatus__c = 'Complete';
        liCancel.Apttus_Config2__PrimaryLineNumber__c = 1;
        liCancel.Apttus_Config2__ProductVersion__c = 1;
        liCancel.APTS_Product_Family__c='RUTTER';
        //liCancel.APTS_Cat_L3__c = System.Label.APTS_Rutter_Product_Family;
        liCancel.Apttus_Config2__Quantity__c = 1;
        liCancel.Apttus_Config2__RollupPriceToBundle__c = TRUE;
        liCancel.Apttus_Config2__SellingFrequency__c = 'Monthly';
        liCancel.Apttus_Config2__SellingTerm__c = 1;
        liCancel.Apttus_Config2__SyncStatus__c = 'Pending';
        liCancel.Apttus_Config2__Taxable__c = FALSE;
        liCancel.Apttus_Config2__TaxInclusive__c = FALSE;
        //liCancel.Apttus_Config2__Term__c = 1;
        liCancel.Apttus_Config2__TotalQuantity__c = 1;
        liCancel.Apttus_Config2__Uom__c = 'Each';
        //liCancel.Apttus_CQApprov__Approval_Status__c = 'Pending Approval';
        liCancel.CurrencyIsoCode = 'CAD';
        liCancel.APTS_Product_Family__c = 'CLEAR';
        //liCancel.APTS_Cat_L2__c = System.Label.APTS_Clear_Product_Family;
        liCancel.APTS_Contract_Term__c = '1 Year';
        liCancel.APTS_Years_2_Plus_Adjustment__c = '5';
        liCancel.APTS_Bridge__c = '2 Months';
        insertList.add(liCancel);
                
        Apttus_Config2__ConfigSystemProperties__c configSetting2 = [SELECT Id, Name, Apttus_Config2__DisableConstraintRules__c FROM Apttus_Config2__ConfigSystemProperties__c WHERE Name = 'System Properties'];
        configSetting2.Apttus_Config2__DisableConstraintRules__c = True;
        update configSetting2;
        // test.startTest();
        Apttus_Config2__LineItem__c li4 = new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c=prodConf.id , Apttus_Config2__ProductId__c=prod2.id);
        li4.Apttus_Config2__AddedBy__c = 'User';
        li4.Apttus_Config2__AdjustedPrice__c = 50;
        li4.Apttus_Config2__AdjustmentAmount__c = 50;
        li4.Apttus_Config2__AdjustmentType__c = '% Discount';
        li4.Apttus_Config2__AllocateGroupAdjustment__c = TRUE;
        li4.Apttus_Config2__AllowableAction__c = 'Unrestricted';
        li4.Apttus_Config2__AllowManualAdjustment__c = TRUE;
        li4.Apttus_Config2__AllowProration__c = FALSE;
        li4.Apttus_Config2__AllowRemoval__c = TRUE;
        li4.Apttus_Config2__AutoRenew__c = FALSE;
        li4.Apttus_Config2__BaseExtendedCost__c = 0;
        li4.Apttus_Config2__BaseExtendedPrice__c = 100;
        li4.Apttus_Config2__BasePrice__c = 100;
        li4.Apttus_Config2__BasePriceMethod__c = 'Per Unit';
        li4.Apttus_Config2__BillingFrequency__c = 'Monthly';
        li4.Apttus_Config2__ChargeType__c = 'Subscription Fee';
        li4.Apttus_Config2__ConfigStatus__c = 'Complete';
        li4.Apttus_Config2__ConstraintCheckStatus__c = 'NA';
        li4.Apttus_Config2__Customizable__c = FALSE;
        li4.Apttus_Config2__DeltaPrice__c = 50;
        li4.Apttus_Config2__DeltaQuantity__c = 1;
        li4.Apttus_Config2__Description__c = 'Westlaw Flex Plan $100/500';
        li4.Apttus_Config2__ExtendedCost__c = 0;
        li4.Apttus_Config2__ExtendedPrice__c = 100;
        li4.Apttus_Config2__Frequency__c = 'Monthly';
        li4.Apttus_Config2__Guidance__c = 'Red';
        li4.Apttus_Config2__HasAttributes__c = FALSE;
        li4.Apttus_Config2__HasBaseProduct__c = FALSE;
        li4.Apttus_Config2__HasDefaults__c = FALSE;
        li4.Apttus_Config2__HasIncentives__c = FALSE;
        li4.Apttus_Config2__HasOptions__c = FALSE;
        li4.Apttus_Config2__HasTieredPrice__c = FALSE;
        li4.Apttus_Config2__HideCopyAction__c = FALSE;
        li4.Apttus_Config2__HideInvoiceDisplay__c = FALSE;
        li4.Apttus_Config2__IsAssetPricing__c = FALSE;
        li4.Apttus_Config2__IsCustomPricing__c = FALSE;
        li4.Apttus_Config2__IsHidden__c = FALSE;
        li4.Apttus_Config2__IsOptionRollupLine__c = FALSE;
        li4.Apttus_Config2__IsPrimaryLine__c = TRUE;
        li4.Apttus_Config2__IsPrimaryRampLine__c = FALSE;
        li4.Apttus_Config2__IsQuantityModifiable__c = FALSE;
        li4.Apttus_Config2__IsReadOnly__c = FALSE;
        li4.Apttus_Config2__IsSellingTermReadOnly__c = FALSE;
        li4.Apttus_Config2__IsUsageTierModifiable__c = FALSE;
        li4.Apttus_Config2__ItemSequence__c = 1;
        li4.Apttus_Config2__LineNumber__c = 1;
        li4.Apttus_Config2__LineSequence__c = 1;
        li4.Apttus_Config2__LineStatus__c = 'Renewed';
        li4.Apttus_Config2__LineType__c = 'Product/Service';
        li4.Apttus_Config2__ListPrice__c = 100;
        li4.Apttus_Config2__NetAdjustmentPercent__c = -50;
        li4.Apttus_Config2__NetPrice__c = 50;
        li4.Apttus_Config2__NetUnitPrice__c = 50;
        li4.Apttus_Config2__OptionSequence__c = 0;
        li4.Apttus_Config2__PriceIncludedInBundle__c = FALSE;
        li4.Apttus_Config2__PriceMethod__c = 'Per Unit';
        li4.Apttus_Config2__PriceType__c = 'Recurring';
        li4.Apttus_Config2__PriceUom__c = 'Each';
        li4.Apttus_Config2__PricingStatus__c = 'Complete';
        li4.Apttus_Config2__PrimaryLineNumber__c = 1;
        li4.Apttus_Config2__ProductVersion__c = 1;
        li4.Apttus_Config2__Quantity__c = 1;
        li4.Apttus_Config2__RollupPriceToBundle__c = TRUE;
        li4.Apttus_Config2__SellingFrequency__c = 'Monthly';
        li4.Apttus_Config2__SellingTerm__c = 1;
        li4.Apttus_Config2__SyncStatus__c = 'Pending';
        li4.Apttus_Config2__Taxable__c = FALSE;
        li4.Apttus_Config2__TaxInclusive__c = FALSE;
        li4.Apttus_Config2__Term__c = 1;
        li4.Apttus_Config2__TotalQuantity__c = 1;
        li4.Apttus_Config2__Uom__c = 'Each';
        li4.Apttus_CQApprov__Approval_Status__c = 'Pending Approval';
        li4.CurrencyIsoCode = 'USD';
        li4.APTS_Product_Family__c = 'Non-Clear';
        li4.APTS_Contract_Term__c = '2 Years';
        li4.APTS_Years_2_Plus_Adjustment__c = '5';
        
        insertList.add(li4);
        insert insertList;
        li4.Apttus_Config2__IncentiveCode__c = '13843013';
        updateList.add(li4);
        li3.APTS_Bridge__c='1 Month';
        li3.APTS_Contract_Term__c='Short Term Trial';
        updateList.add(li3);
        update updateList;
        APTS_LineItemTriggerHelper.populateAllApprovalRequiredCB(updateList);
        System.assertEquals(li3.APTS_Bridge__c, '1 Month');         
        Test.stopTest();        
    } 

    static testMethod void corporateApprovalTest() {
        
        List<KeyValueListStore__c> keyvaluestoreList = new List<KeyValueListStore__c>();
        KeyValueListStore__c keyvaluestore=new  KeyValueListStore__c();
        keyvaluestore.Name='ANZUsersProfileId';
        keyvaluestore.TextValue__c=System.Label.APTS_OC_Test_Id;
        keyvaluestoreList.add(keyvaluestore); 
        KeyValueListStore__c keyval = new KeyValueListStore__c();
        keyval.Name='ReasonWithCompetitor';
        keyval.TextValue__c='Price';
        keyvaluestoreList.add(keyval);
        insert keyvaluestoreList;
        
        //Inserting recordLists
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
        
        List<APTS_Segment_Threshold__c> segthrList= new List<APTS_Segment_Threshold__c>();
        //Add Segment threshold
        APTS_Segment_Threshold__c seg1 = new APTS_Segment_Threshold__c();
        seg1.APTS_Approval_Required__c=True;
        seg1.APTS_Segment__c='Small Law';
        seg1.APTS_Customer_Category__c='5';
        seg1.APTS_Term_in_years__c=Integer.ValueOf('2');
        seg1.APTS_Minimum_OY_Increase__c=Integer.ValueOf('15');
        seg1.APTS_Product_Family__c = 'Non-Clear';
        seg1.APTS_Promo_Codes__c = '13843013';
        seg1.APTS_Promo_Minimum_OY_Increase__c = 16;        
        segthrList.add(seg1);
        
        APTS_Segment_Threshold__c seg2 = new APTS_Segment_Threshold__c();
        seg2.APTS_Approval_Required__c=True;
        seg2.APTS_Segment__c='Corporate';
        seg2.APTS_Customer_Category__c='5';
        seg2.APTS_Term_in_years__c=Integer.ValueOf('2');
        seg2.APTS_Minimum_OY_Increase__c=Integer.ValueOf('15');
        seg2.APTS_Minimum_Incremental_Growth__c=100.00;
        seg2.APTS_Product_Family__c = 'Non-Clear';
        seg2.APTS_Promo_Codes__c = '13843013';
        seg2.APTS_Promo_Minimum_OY_Increase__c = 16;
        segthrList.add(seg2);
        
        System.assertEquals(seg2.APTS_Promo_Codes__c, '13843013');
        
        APTS_Segment_Threshold__c seg3 = new APTS_Segment_Threshold__c();
        seg3.APTS_Approval_Required__c=True;
        seg3.APTS_Segment__c='Government';
        seg3.APTS_Customer_Category__c='5';
        seg3.APTS_Term_in_years__c=Integer.ValueOf('2');
        seg3.APTS_Minimum_OY_Increase__c=Integer.ValueOf('15');        
        seg3.APTS_Product_Family__c = 'Non-Clear';
        seg3.APTS_Promo_Codes__c = '13843013';
        seg3.APTS_Promo_Minimum_OY_Increase__c = 16;
        
        segthrList.add(seg3);
        
        insert segthrList;
        
        Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
        Account a = new Account(RecordTypeId=accRecordTypeId,name='test-sg',sales_org__c='ABEP',customer_group__c='Academic',customer_type__c='Organization',customer_class_c__c='Academic Lecturer');
        a.APTS_Customer_Category__c = '5';
        a.Is_GLI__c = True;
        insert a;        
        
        Schema.DescribeFieldResult fieldResultMarket = Apttus_Config2__ProductConfiguration__c.APTS_AccountMirror_Picklist__c.getDescribe();
        String valueMarket = fieldResultMarket.getPicklistValues().get(0).getValue();
        
        //Inserting SourceSystemDetail
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();
        Source_System_Detail__c accountSSD= new Source_System_Detail__c();
        accountSSD.RecordtypeId=ssdRecorType;
        accountSSD.Name='ABC';
        accountSSD.Source_System_Name__c='ABC';
        accountSSD.Account_Name__c=a.ID;
        accountSSD.APTS_Customer_Category__c='1';
        accountSSD.LCRM_Customer_Group__c='Academic';
        accountSSD.LCRM_Frozen_Market_Segment__c = valueMarket;
        accountSSD.Account_Inactive__c=false;
        accountSSD.LCRM_Sales_Org__c='WEST';
        accountSSD.APTS_Has_Online_Assets__c=true;
        insert accountSSD;
        
        
        Date todaysDate = system.today();
        Id oppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Pipeline Opportunity').getRecordTypeId();
        Opportunity o = new Opportunity(RecordTypeId=oppRecordTypeId,  Name='tst-opp', stagename='25%',closedate=todaysDate,forecastcategoryname='pipeline',accountId=a.id);
        insert o;
        
        Id devRecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Proposal').getRecordTypeId();
        Apttus_Proposal__Proposal__c p = new Apttus_Proposal__Proposal__c(RecordTypeId=devRecordTypeId, CurrencyIsoCode = 'USD', Apttus_Proposal__Proposal_Name__c='TST-10',Apttus_Proposal__Account__c=a.id  ,Apttus_Proposal__Opportunity__c=o.id, Apttus_Proposal__Approval_Stage__c='Draft', Apttus_Proposal__Proposal_Category__c='Quote', Apttus_Proposal__ReadyToGenerate__c = true, Apttus_Proposal__ReadyToPresent__c= true,APTS_SSD_Sold_To__c=accountSSD.Id,APTS_SSD_ship_to__c=accountSSD.Id,APTS_SSD_bill_to__c=accountSSD.Id);
        p.APTS_Approval_Segment__c = 'Corporate Large';        
        insert p;
        
        Apttus_Config2__ProductConfiguration__c prodConf = new Apttus_Config2__ProductConfiguration__c(Name='prod-conf1', CurrencyIsoCode = 'USD', Apttus_QPConfig__Proposald__c=p.id, APTS_SSD_ship_to__c=accountSSD.Id,APTS_SSD_bill_to__c=accountSSD.Id,    
                                              APTS_Least_Contract_Term__c=Integer.ValueOf('2'),APTS_Incremental_Growth__c=100.00);
        insert prodConf;
        
        Product2 prod = new Product2(name='prod1', Media_High_Level__c='Online', CurrencyIsoCode = 'USD');
        insert prod;
        Product2 prod2 = new Product2(name='prod1', Media_High_Level__c='Online', CurrencyIsoCode = 'USD');
        insert prod2;
        
        Apttus_Config2__ConfigSystemProperties__c configSetting=new Apttus_Config2__ConfigSystemProperties__c(Name='System Properties',Apttus_Config2__DisableConstraintRules__c=true);
        insert configSetting;

        test.startTest();
        Apttus_Config2__LineItem__c li3 = new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c=prodConf.id , Apttus_Config2__ProductId__c=prod.id);
        li3.Apttus_Config2__AddedBy__c = 'User';
        li3.Apttus_Config2__AdjustedPrice__c = 50;
        li3.Apttus_Config2__AdjustmentAmount__c = 50;
        li3.Apttus_Config2__AdjustmentType__c = '% Discount';
        li3.Apttus_Config2__AllocateGroupAdjustment__c = TRUE;
        li3.Apttus_Config2__AllowableAction__c = 'Unrestricted';
        li3.Apttus_Config2__AllowManualAdjustment__c = TRUE;
        li3.Apttus_Config2__AllowProration__c = FALSE;
        li3.Apttus_Config2__AllowRemoval__c = TRUE;
        li3.Apttus_Config2__AutoRenew__c = FALSE;
        li3.Apttus_Config2__BaseExtendedCost__c = 0;
        li3.Apttus_Config2__BaseExtendedPrice__c = 100;
        li3.Apttus_Config2__BasePrice__c = 100;
        li3.Apttus_Config2__BasePriceMethod__c = 'Per Unit';
        li3.Apttus_Config2__BillingFrequency__c = 'Monthly';
        li3.Apttus_Config2__ChargeType__c = 'Subscription Fee';
        li3.Apttus_Config2__ConfigStatus__c = 'Complete';
        li3.Apttus_Config2__ConstraintCheckStatus__c = 'NA';
        li3.Apttus_Config2__Customizable__c = FALSE;
        li3.Apttus_Config2__DeltaPrice__c = 50;
        li3.Apttus_Config2__DeltaQuantity__c = 1;
        li3.Apttus_Config2__Description__c = 'Westlaw Flex Plan $100/500';
        li3.Apttus_Config2__ExtendedCost__c = 0;
        li3.Apttus_Config2__ExtendedPrice__c = 100;
        li3.Apttus_Config2__Frequency__c = 'Monthly';
        li3.Apttus_Config2__Guidance__c = 'Red';
        li3.Apttus_Config2__HasAttributes__c = FALSE;
        li3.Apttus_Config2__HasBaseProduct__c = FALSE;
        li3.Apttus_Config2__HasDefaults__c = FALSE;
        li3.Apttus_Config2__HasIncentives__c = FALSE;
        li3.Apttus_Config2__HasOptions__c = FALSE;
        li3.Apttus_Config2__HasTieredPrice__c = FALSE;
        li3.Apttus_Config2__HideCopyAction__c = FALSE;
        li3.Apttus_Config2__HideInvoiceDisplay__c = FALSE;
        li3.Apttus_Config2__IsAssetPricing__c = FALSE;
        li3.Apttus_Config2__IsCustomPricing__c = FALSE;
        li3.Apttus_Config2__IsHidden__c = FALSE;
        li3.Apttus_Config2__IsOptionRollupLine__c = FALSE;
        li3.Apttus_Config2__IsPrimaryLine__c = TRUE;
        li3.Apttus_Config2__IsPrimaryRampLine__c = FALSE;
        li3.Apttus_Config2__IsQuantityModifiable__c = FALSE;
        li3.Apttus_Config2__IsReadOnly__c = FALSE;
        li3.Apttus_Config2__IsSellingTermReadOnly__c = FALSE;
        li3.Apttus_Config2__IsUsageTierModifiable__c = FALSE;
        li3.Apttus_Config2__ItemSequence__c = 1;
        li3.Apttus_Config2__LineNumber__c = 1;
        li3.Apttus_Config2__LineSequence__c = 1;
        li3.Apttus_Config2__LineStatus__c = 'Renewed';
        li3.Apttus_Config2__LineType__c = 'Product/Service';
        li3.Apttus_Config2__ListPrice__c = 100;
        li3.Apttus_Config2__NetAdjustmentPercent__c = -50;
        li3.Apttus_Config2__NetPrice__c = 50;
        li3.Apttus_Config2__NetUnitPrice__c = 50;
        li3.Apttus_Config2__OptionSequence__c = 0;
        li3.Apttus_Config2__PriceIncludedInBundle__c = FALSE;
        li3.Apttus_Config2__PriceMethod__c = 'Per Unit';
        li3.Apttus_Config2__PriceType__c = 'Recurring';
        li3.Apttus_Config2__PriceUom__c = 'Each';
        li3.Apttus_Config2__PricingStatus__c = 'Complete';
        li3.Apttus_Config2__PrimaryLineNumber__c = 1;
        li3.Apttus_Config2__ProductVersion__c = 1;
        li3.Apttus_Config2__Quantity__c = 1;
        li3.Apttus_Config2__RollupPriceToBundle__c = TRUE;
        li3.Apttus_Config2__SellingFrequency__c = 'Monthly';
        li3.Apttus_Config2__SellingTerm__c = 1;
        li3.Apttus_Config2__SyncStatus__c = 'Pending';
        li3.Apttus_Config2__Taxable__c = FALSE;
        li3.Apttus_Config2__TaxInclusive__c = FALSE;
        li3.Apttus_Config2__Term__c = 1;
        li3.Apttus_Config2__TotalQuantity__c = 1;
        li3.Apttus_Config2__Uom__c = 'Each';
        li3.Apttus_CQApprov__Approval_Status__c = 'Pending Approval';
        li3.CurrencyIsoCode = 'USD';
        li3.APTS_Product_Family__c = 'Non-Clear';
        li3.APTS_Contract_Term__c = '2 Years';
        li3.APTS_Years_2_Plus_Adjustment__c = '5';
        
        insert li3;
        
        Apttus_Config2__LineItem__c li4 = new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c=prodConf.id , Apttus_Config2__ProductId__c=prod.id);
        li4.Apttus_Config2__AddedBy__c = 'User';
        li4.Apttus_Config2__AdjustedPrice__c = 50;
        li4.Apttus_Config2__AdjustmentAmount__c = 50;
        li4.Apttus_Config2__AdjustmentType__c = '% Discount';
        li4.Apttus_Config2__AllocateGroupAdjustment__c = TRUE;
        li4.Apttus_Config2__AllowableAction__c = 'Unrestricted';
        li4.Apttus_Config2__AllowManualAdjustment__c = TRUE;
        li4.Apttus_Config2__AllowProration__c = FALSE;
        li4.Apttus_Config2__AllowRemoval__c = TRUE;
        li4.Apttus_Config2__AutoRenew__c = FALSE;
        li4.Apttus_Config2__BaseExtendedCost__c = 0;
        li4.Apttus_Config2__BaseExtendedPrice__c = 100;
        li4.Apttus_Config2__BasePrice__c = 100;
        li4.Apttus_Config2__BasePriceMethod__c = 'Per Unit';
        li4.Apttus_Config2__BillingFrequency__c = 'Monthly';
        li4.Apttus_Config2__ChargeType__c = 'Subscription Fee';
        li4.Apttus_Config2__ConfigStatus__c = 'Complete';
        li4.Apttus_Config2__ConstraintCheckStatus__c = 'NA';
        li4.Apttus_Config2__Customizable__c = FALSE;
        li4.Apttus_Config2__DeltaPrice__c = 50;
        li4.Apttus_Config2__DeltaQuantity__c = 1;
        li4.Apttus_Config2__Description__c = 'Westlaw Flex Plan $100/500';
        li4.Apttus_Config2__ExtendedCost__c = 0;
        li4.Apttus_Config2__ExtendedPrice__c = 100;
        li4.Apttus_Config2__Frequency__c = 'Monthly';
        li4.Apttus_Config2__Guidance__c = 'Red';
        li4.Apttus_Config2__HasAttributes__c = FALSE;
        li4.Apttus_Config2__HasBaseProduct__c = FALSE;
        li4.Apttus_Config2__HasDefaults__c = FALSE;
        li4.Apttus_Config2__HasIncentives__c = FALSE;
        li4.Apttus_Config2__HasOptions__c = FALSE;
        li4.Apttus_Config2__HasTieredPrice__c = FALSE;
        li4.Apttus_Config2__HideCopyAction__c = FALSE;
        li4.Apttus_Config2__HideInvoiceDisplay__c = FALSE;
        li4.Apttus_Config2__IsAssetPricing__c = FALSE;
        li4.Apttus_Config2__IsCustomPricing__c = FALSE;
        li4.Apttus_Config2__IsHidden__c = FALSE;
        li4.Apttus_Config2__IsOptionRollupLine__c = FALSE;
        li4.Apttus_Config2__IsPrimaryLine__c = TRUE;
        li4.Apttus_Config2__IsPrimaryRampLine__c = FALSE;
        li4.Apttus_Config2__IsQuantityModifiable__c = FALSE;
        li4.Apttus_Config2__IsReadOnly__c = FALSE;
        li4.Apttus_Config2__IsSellingTermReadOnly__c = FALSE;
        li4.Apttus_Config2__IsUsageTierModifiable__c = FALSE;
        li4.Apttus_Config2__ItemSequence__c = 1;
        li4.Apttus_Config2__LineNumber__c = 1;
        li4.Apttus_Config2__LineSequence__c = 1;
        li4.Apttus_Config2__LineStatus__c = 'Renewed';
        li4.Apttus_Config2__LineType__c = 'Product/Service';
        li4.Apttus_Config2__ListPrice__c = 100;
        li4.Apttus_Config2__NetAdjustmentPercent__c = -50;
        li4.Apttus_Config2__NetPrice__c = 50;
        li4.Apttus_Config2__NetUnitPrice__c = 50;
        li4.Apttus_Config2__OptionSequence__c = 0;
        li4.Apttus_Config2__PriceIncludedInBundle__c = FALSE;
        li4.Apttus_Config2__PriceMethod__c = 'Per Unit';
        li4.Apttus_Config2__PriceType__c = 'Recurring';
        li4.Apttus_Config2__PriceUom__c = 'Each';
        li4.Apttus_Config2__PricingStatus__c = 'Complete';
        li4.Apttus_Config2__PrimaryLineNumber__c = 1;
        li4.Apttus_Config2__ProductVersion__c = 1;
        li4.Apttus_Config2__Quantity__c = 1;
        li4.Apttus_Config2__RollupPriceToBundle__c = TRUE;
        li4.Apttus_Config2__SellingFrequency__c = 'Monthly';
        li4.Apttus_Config2__SellingTerm__c = 1;
        li4.Apttus_Config2__SyncStatus__c = 'Pending';
        li4.Apttus_Config2__Taxable__c = FALSE;
        li4.Apttus_Config2__TaxInclusive__c = FALSE;
        li4.Apttus_Config2__Term__c = 1;
        li4.Apttus_Config2__TotalQuantity__c = 1;
        li4.Apttus_Config2__Uom__c = 'Each';
        li4.Apttus_CQApprov__Approval_Status__c = 'Pending Approval';
        li4.CurrencyIsoCode = 'USD';
        li4.APTS_Contract_Term__c = '2 Years';
        li4.APTS_Years_2_Plus_Adjustment__c = '5';
        
        insert li4;
        
        li3.Apttus_Config2__IncentiveCode__c = '13843013';
        update li3;
        li3.APTS_Bridge__c='1 Month';
        li3.APTS_Contract_Term__c='Short Term Trial';
        update li3;
        li4.APTS_Product_Family__c = 'PRINT LEGAL SOLUTIONS';
        //li4.APTS_Cat_L2__c = System.Label.APTS_Print_Product_Family;
        update li4;
        
                
        Test.stopTest();        
    } 

    static testMethod void printApprovalTest() {
        
        List<KeyValueListStore__c> keyvaluestoreList = new List<KeyValueListStore__c>();
        KeyValueListStore__c keyvaluestore=new  KeyValueListStore__c();
        keyvaluestore.Name='ANZUsersProfileId';
        keyvaluestore.TextValue__c=System.Label.APTS_OC_Test_Id;
        keyvaluestoreList.add(keyvaluestore); 
        KeyValueListStore__c keyval = new KeyValueListStore__c();
        keyval.Name='ReasonWithCompetitor';
        keyval.TextValue__c='Price';
        keyvaluestoreList.add(keyval);
        insert keyvaluestoreList;
        
        //Inserting recordLists
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
        
        List<APTS_Segment_Threshold__c> segthrList= new List<APTS_Segment_Threshold__c>();
        //Add Segment threshold
        APTS_Segment_Threshold__c seg1 = new APTS_Segment_Threshold__c();
        seg1.APTS_Approval_Required__c=True;
        seg1.APTS_Segment__c='Small Law';
        seg1.APTS_Customer_Category__c='5';
        seg1.APTS_Term_in_years__c=Integer.ValueOf('2');
        seg1.APTS_Minimum_OY_Increase__c=Integer.ValueOf('15');
        seg1.APTS_Product_Family__c = System.Label.APTS_Print_Product_Family_Value;
        seg1.APTS_Promo_Codes__c = '13843013';
        seg1.APTS_Promo_Minimum_OY_Increase__c = 16;        
        segthrList.add(seg1);
        
        APTS_Segment_Threshold__c seg2 = new APTS_Segment_Threshold__c();
        seg2.APTS_Approval_Required__c=True;
        seg2.APTS_Segment__c='Corporate';
        seg2.APTS_Customer_Category__c='5';
        seg2.APTS_Term_in_years__c=Integer.ValueOf('2');
        seg2.APTS_Minimum_OY_Increase__c=Integer.ValueOf('15');        
        seg2.APTS_Product_Family__c = System.Label.APTS_Print_Product_Family_Value;
        seg2.APTS_Promo_Codes__c = '13843013';
        seg2.APTS_Promo_Minimum_OY_Increase__c = 16;        
        segthrList.add(seg2);        
        System.assertEquals(seg2.APTS_Promo_Codes__c, '13843013');
        
        APTS_Segment_Threshold__c seg3 = new APTS_Segment_Threshold__c();
        seg3.APTS_Approval_Required__c=True;
        seg3.APTS_Segment__c='Government';
        seg3.APTS_Customer_Category__c='5';
        seg3.APTS_Term_in_years__c=Integer.ValueOf('2');
        seg3.APTS_Minimum_OY_Increase__c=Integer.ValueOf('15');        
        seg3.APTS_Product_Family__c = System.Label.APTS_Print_Product_Family_Value;
        seg3.APTS_Promo_Codes__c = '13843013';
        seg3.APTS_Promo_Minimum_OY_Increase__c = 16;
        
        segthrList.add(seg3);
        
        insert segthrList;
        
        Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
        Account a = new Account(RecordTypeId=accRecordTypeId,name='test-sg',sales_org__c='ABEP',customer_group__c='Academic',customer_type__c='Organization',customer_class_c__c='Academic Lecturer');
        a.APTS_Customer_Category__c = '5';
        a.Is_GLI__c = True;
        insert a;
        
        Schema.DescribeFieldResult fieldResultMarket = Apttus_Config2__ProductConfiguration__c.APTS_AccountMirror_Picklist__c.getDescribe();
        String valueMarket = fieldResultMarket.getPicklistValues().get(0).getValue();
        
        //Inserting SourceSystemDetail
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();
        Source_System_Detail__c accountSSD= new Source_System_Detail__c();
        accountSSD.RecordtypeId=ssdRecorType;
        accountSSD.Name='ABC';
        accountSSD.Source_System_Name__c='ABC';
        accountSSD.Account_Name__c=a.ID;
        accountSSD.APTS_Customer_Category__c='1';
        accountSSD.LCRM_Customer_Group__c='Academic';
        accountSSD.LCRM_Frozen_Market_Segment__c = valueMarket;
        accountSSD.Account_Inactive__c=false;
        accountSSD.LCRM_Sales_Org__c='WEST';
        accountSSD.APTS_Has_Online_Assets__c=true;
        insert accountSSD;
        
        Date todaysDate = system.today();
        Id oppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Pipeline Opportunity').getRecordTypeId();
        Opportunity o = new Opportunity(RecordTypeId=oppRecordTypeId,  Name='tst-opp', stagename='25%',closedate=todaysDate,forecastcategoryname='pipeline',accountId=a.id);
        insert o;
        
        Id devRecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Proposal').getRecordTypeId();
        Apttus_Proposal__Proposal__c p = new Apttus_Proposal__Proposal__c(RecordTypeId=devRecordTypeId, CurrencyIsoCode = 'USD',Apttus_Proposal__Account__c=a.id, Apttus_Proposal__Proposal_Name__c='TST-10',  Apttus_Proposal__Opportunity__c=o.id, Apttus_Proposal__Approval_Stage__c='Draft', Apttus_Proposal__Proposal_Category__c='Quote', Apttus_Proposal__ReadyToGenerate__c = true, Apttus_Proposal__ReadyToPresent__c= true,APTS_SSD_Sold_To__c=accountSSD.Id,APTS_SSD_ship_to__c=accountSSD.Id,APTS_SSD_bill_to__c=accountSSD.Id);
        p.APTS_Approval_Segment__c = 'Government';        
        insert p;
        
        Apttus_Proposal__Proposal__c p2 = new Apttus_Proposal__Proposal__c(RecordTypeId=devRecordTypeId, CurrencyIsoCode = 'USD',Apttus_Proposal__Account__c=a.id, Apttus_Proposal__Proposal_Name__c='TST-10',  Apttus_Proposal__Opportunity__c=o.id, Apttus_Proposal__Approval_Stage__c='Draft', Apttus_Proposal__Proposal_Category__c='Quote', Apttus_Proposal__ReadyToGenerate__c = true, Apttus_Proposal__ReadyToPresent__c= true,APTS_SSD_Sold_To__c=accountSSD.Id,APTS_SSD_ship_to__c=accountSSD.Id,APTS_SSD_bill_to__c=accountSSD.Id);
        p2.APTS_Approval_Segment__c = 'Canada';        
        insert p2;

        Apttus_Proposal__Proposal__c p3 = new Apttus_Proposal__Proposal__c(RecordTypeId=devRecordTypeId, CurrencyIsoCode = 'USD',APTS_Proposal_Business_Unit__c='Canada',Apttus_Proposal__Account__c=a.id, Apttus_Proposal__Proposal_Name__c='TST-10',  Apttus_Proposal__Opportunity__c=o.id, Apttus_Proposal__Approval_Stage__c='Draft', Apttus_Proposal__Proposal_Category__c='Quote', Apttus_Proposal__ReadyToGenerate__c = true, Apttus_Proposal__ReadyToPresent__c= true,APTS_SSD_Sold_To__c=accountSSD.Id,APTS_SSD_ship_to__c=accountSSD.Id,APTS_SSD_bill_to__c=accountSSD.Id);
        p3.APTS_Approval_Segment__c = 'LMS Channel';        
        insert p3;
        
        Apttus_Config2__ProductConfiguration__c prodConf = new Apttus_Config2__ProductConfiguration__c(Name='prod-conf1', CurrencyIsoCode = 'USD', Apttus_QPConfig__Proposald__c=p.id, APTS_SSD_ship_to__c=accountSSD.Id,APTS_SSD_bill_to__c=accountSSD.Id);
        insert prodConf;
        
        Apttus_Config2__ProductConfiguration__c prodConf2 = new Apttus_Config2__ProductConfiguration__c(Name='prod-conf1', CurrencyIsoCode = 'USD', Apttus_QPConfig__Proposald__c=p2.id, APTS_SSD_ship_to__c=accountSSD.Id,APTS_SSD_bill_to__c=accountSSD.Id);
        insert prodConf2;

        Apttus_Config2__ProductConfiguration__c prodConf3 = new Apttus_Config2__ProductConfiguration__c(Name='prod-conf1', CurrencyIsoCode = 'USD', Apttus_QPConfig__Proposald__c=p3.id, APTS_SSD_ship_to__c=accountSSD.Id,APTS_SSD_bill_to__c=accountSSD.Id);
        insert prodConf3;
                
        Product2 prod = new Product2(name='prod1', Media_High_Level__c='Online', CurrencyIsoCode = 'USD', Family='PRINT LEGAL SOLUTIONS', APTS_Cat_L2__c = System.Label.APTS_Print_Product_Family,APTS_CAT_L3__c='L3_L030_FP');
        insert prod;
        
        Product2 prod1 = new Product2(name='prod1', Media_High_Level__c='Online', CurrencyIsoCode = 'USD', Family='RUTTER', APTS_Cat_L3__c = System.Label.APTS_Rutter_Product_Family,APTS_CAT_L2__c='L3_L030_FP');
        insert prod1;

        Product2 prod2 = new Product2(name='prod1', Media_High_Level__c='Online', CurrencyIsoCode = 'USD', Family='RUTTER', APTS_Cat_L3__c = System.Label.APTS_Case_Logistix_Product_Family,APTS_CAT_L2__c='L3_L030_FP');
        insert prod2;

        
        Apttus_Config2__ConfigSystemProperties__c configSetting=new Apttus_Config2__ConfigSystemProperties__c(Name='System Properties',Apttus_Config2__DisableConstraintRules__c=true);
        insert configSetting;
        test.startTest();

        Apttus_Config2__LineItem__c li3B = new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c=prodConf3.id , Apttus_Config2__ProductId__c=prod2.id);
        li3B.APTS_Group__c=null;
        li3B.Apttus_Config2__AddedBy__c = 'User';
        li3B.Apttus_Config2__AdjustedPrice__c = 50;
        li3B.Apttus_Config2__AdjustmentAmount__c = 50;
        li3B.Apttus_Config2__AdjustmentType__c = '% Discount';
        li3B.Apttus_Config2__AllocateGroupAdjustment__c = TRUE;
        li3B.Apttus_Config2__AllowableAction__c = 'Unrestricted';
        li3B.Apttus_Config2__AllowManualAdjustment__c = TRUE;
        li3B.Apttus_Config2__AllowProration__c = FALSE;
        li3B.Apttus_Config2__AllowRemoval__c = TRUE;
        li3B.Apttus_Config2__AutoRenew__c = FALSE;
        li3B.Apttus_Config2__BaseExtendedCost__c = 0;
        li3B.Apttus_Config2__BaseExtendedPrice__c = 100;
        li3B.Apttus_Config2__BasePrice__c = 100;
        li3B.Apttus_Config2__BasePriceMethod__c = 'Per Unit';
        li3B.Apttus_Config2__BillingFrequency__c = 'Monthly';
        li3B.Apttus_Config2__ChargeType__c = 'Subscription Fee';
        li3B.Apttus_Config2__ConfigStatus__c = 'Complete';
        li3B.Apttus_Config2__ConstraintCheckStatus__c = 'NA';
        li3B.Apttus_Config2__Customizable__c = FALSE;
        li3B.Apttus_Config2__DeltaPrice__c = 50;
        li3B.Apttus_Config2__DeltaQuantity__c = 1;
        li3B.Apttus_Config2__Description__c = 'Westlaw Flex Plan $100/500';
        li3B.Apttus_Config2__ExtendedCost__c = 0;
        li3B.Apttus_Config2__ExtendedPrice__c = 100;
        li3B.Apttus_Config2__Frequency__c = 'Monthly';
        li3B.Apttus_Config2__Guidance__c = 'Red';
        li3B.Apttus_Config2__HasAttributes__c = FALSE;
        li3B.Apttus_Config2__HasBaseProduct__c = FALSE;
        li3B.Apttus_Config2__HasDefaults__c = FALSE;
        li3B.Apttus_Config2__HasIncentives__c = FALSE;
        li3B.Apttus_Config2__HasOptions__c = FALSE;
        li3B.Apttus_Config2__HasTieredPrice__c = FALSE;
        li3B.Apttus_Config2__HideCopyAction__c = FALSE;
        li3B.Apttus_Config2__HideInvoiceDisplay__c = FALSE;
        li3B.Apttus_Config2__IsAssetPricing__c = FALSE;
        li3B.Apttus_Config2__IsCustomPricing__c = FALSE;
        li3B.Apttus_Config2__IsHidden__c = FALSE;
        li3B.Apttus_Config2__IsOptionRollupLine__c = FALSE;
        li3B.Apttus_Config2__IsPrimaryLine__c = TRUE;
        li3B.Apttus_Config2__IsPrimaryRampLine__c = FALSE;
        li3B.Apttus_Config2__IsQuantityModifiable__c = FALSE;
        li3B.Apttus_Config2__IsReadOnly__c = FALSE;
        li3B.Apttus_Config2__IsSellingTermReadOnly__c = FALSE;
        li3B.Apttus_Config2__IsUsageTierModifiable__c = FALSE;
        li3B.Apttus_Config2__ItemSequence__c = 1;
        li3B.Apttus_Config2__LineNumber__c = 1;
        li3B.Apttus_Config2__LineSequence__c = 1;
        li3B.Apttus_Config2__LineStatus__c = 'Renewed';
        li3B.Apttus_Config2__LineType__c = 'Product/Service';
        li3B.Apttus_Config2__ListPrice__c = 100;
        li3B.Apttus_Config2__NetAdjustmentPercent__c = -50;
        li3B.Apttus_Config2__NetPrice__c = 50;
        li3B.Apttus_Config2__NetUnitPrice__c = 50;
        li3B.Apttus_Config2__OptionSequence__c = 0;
        li3B.Apttus_Config2__PriceIncludedInBundle__c = FALSE;
        li3B.Apttus_Config2__PriceMethod__c = 'Per Unit';
        li3B.Apttus_Config2__PriceType__c = 'Recurring';
        li3B.Apttus_Config2__PriceUom__c = 'Each';
        li3B.Apttus_Config2__PricingStatus__c = 'Complete';
        li3B.Apttus_Config2__PrimaryLineNumber__c = 1;
        li3B.Apttus_Config2__ProductVersion__c = 1;
        li3B.Apttus_Config2__Quantity__c = 1;
        li3B.Apttus_Config2__RollupPriceToBundle__c = TRUE;
        li3B.Apttus_Config2__SellingFrequency__c = 'Monthly';
        li3B.Apttus_Config2__SellingTerm__c = 1;
        li3B.Apttus_Config2__SyncStatus__c = 'Pending';
        li3B.Apttus_Config2__Taxable__c = FALSE;
        li3B.Apttus_Config2__TaxInclusive__c = FALSE;
        li3B.Apttus_Config2__Term__c = 1;
        li3B.Apttus_Config2__TotalQuantity__c = 1;
        li3B.Apttus_Config2__Uom__c = 'Each';
        li3B.Apttus_CQApprov__Approval_Status__c = 'Pending Approval';
        li3B.CurrencyIsoCode = 'USD';
        li3B.APTS_Product_Family__c = 'PRINT LEGAL SOLUTIONS';
        li3B.APTS_Contract_Term__c = '3 Years';
        li3B.APTS_Years_2_Plus_Adjustment__c = '5';
        //li3.APTS_Cat_L2__c = System.Label.APTS_Print_Product_Family;
        insert li3B;

        Apttus_Config2__LineItem__c li3 = new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c=prodConf.id , Apttus_Config2__ProductId__c=prod.id);
        li3.Apttus_Config2__AddedBy__c = 'User';
        li3.Apttus_Config2__AdjustedPrice__c = 50;
        li3.Apttus_Config2__AdjustmentAmount__c = 50;
        li3.Apttus_Config2__AdjustmentType__c = '% Discount';
        li3.Apttus_Config2__AllocateGroupAdjustment__c = TRUE;
        li3.Apttus_Config2__AllowableAction__c = 'Unrestricted';
        li3.Apttus_Config2__AllowManualAdjustment__c = TRUE;
        li3.Apttus_Config2__AllowProration__c = FALSE;
        li3.Apttus_Config2__AllowRemoval__c = TRUE;
        li3.Apttus_Config2__AutoRenew__c = FALSE;
        li3.Apttus_Config2__BaseExtendedCost__c = 0;
        li3.Apttus_Config2__BaseExtendedPrice__c = 100;
        li3.Apttus_Config2__BasePrice__c = 100;
        li3.Apttus_Config2__BasePriceMethod__c = 'Per Unit';
        li3.Apttus_Config2__BillingFrequency__c = 'Monthly';
        li3.Apttus_Config2__ChargeType__c = 'Subscription Fee';
        li3.Apttus_Config2__ConfigStatus__c = 'Complete';
        li3.Apttus_Config2__ConstraintCheckStatus__c = 'NA';
        li3.Apttus_Config2__Customizable__c = FALSE;
        li3.Apttus_Config2__DeltaPrice__c = 50;
        li3.Apttus_Config2__DeltaQuantity__c = 1;
        li3.Apttus_Config2__Description__c = 'Westlaw Flex Plan $100/500';
        li3.Apttus_Config2__ExtendedCost__c = 0;
        li3.Apttus_Config2__ExtendedPrice__c = 100;
        li3.Apttus_Config2__Frequency__c = 'Monthly';
        li3.Apttus_Config2__Guidance__c = 'Red';
        li3.Apttus_Config2__HasAttributes__c = FALSE;
        li3.Apttus_Config2__HasBaseProduct__c = FALSE;
        li3.Apttus_Config2__HasDefaults__c = FALSE;
        li3.Apttus_Config2__HasIncentives__c = FALSE;
        li3.Apttus_Config2__HasOptions__c = FALSE;
        li3.Apttus_Config2__HasTieredPrice__c = FALSE;
        li3.Apttus_Config2__HideCopyAction__c = FALSE;
        li3.Apttus_Config2__HideInvoiceDisplay__c = FALSE;
        li3.Apttus_Config2__IsAssetPricing__c = FALSE;
        li3.Apttus_Config2__IsCustomPricing__c = FALSE;
        li3.Apttus_Config2__IsHidden__c = FALSE;
        li3.Apttus_Config2__IsOptionRollupLine__c = FALSE;
        li3.Apttus_Config2__IsPrimaryLine__c = TRUE;
        li3.Apttus_Config2__IsPrimaryRampLine__c = FALSE;
        li3.Apttus_Config2__IsQuantityModifiable__c = FALSE;
        li3.Apttus_Config2__IsReadOnly__c = FALSE;
        li3.Apttus_Config2__IsSellingTermReadOnly__c = FALSE;
        li3.Apttus_Config2__IsUsageTierModifiable__c = FALSE;
        li3.Apttus_Config2__ItemSequence__c = 1;
        li3.Apttus_Config2__LineNumber__c = 1;
        li3.Apttus_Config2__LineSequence__c = 1;
        li3.Apttus_Config2__LineStatus__c = 'Renewed';
        li3.Apttus_Config2__LineType__c = 'Product/Service';
        li3.Apttus_Config2__ListPrice__c = 100;
        li3.Apttus_Config2__NetAdjustmentPercent__c = -50;
        li3.Apttus_Config2__NetPrice__c = 50;
        li3.Apttus_Config2__NetUnitPrice__c = 50;
        li3.Apttus_Config2__OptionSequence__c = 0;
        li3.Apttus_Config2__PriceIncludedInBundle__c = FALSE;
        li3.Apttus_Config2__PriceMethod__c = 'Per Unit';
        li3.Apttus_Config2__PriceType__c = 'Recurring';
        li3.Apttus_Config2__PriceUom__c = 'Each';
        li3.Apttus_Config2__PricingStatus__c = 'Complete';
        li3.Apttus_Config2__PrimaryLineNumber__c = 1;
        li3.Apttus_Config2__ProductVersion__c = 1;
        li3.Apttus_Config2__Quantity__c = 1;
        li3.Apttus_Config2__RollupPriceToBundle__c = TRUE;
        li3.Apttus_Config2__SellingFrequency__c = 'Monthly';
        li3.Apttus_Config2__SellingTerm__c = 1;
        li3.Apttus_Config2__SyncStatus__c = 'Pending';
        li3.Apttus_Config2__Taxable__c = FALSE;
        li3.Apttus_Config2__TaxInclusive__c = FALSE;
        li3.Apttus_Config2__Term__c = 1;
        li3.Apttus_Config2__TotalQuantity__c = 1;
        li3.Apttus_Config2__Uom__c = 'Each';
        li3.Apttus_CQApprov__Approval_Status__c = 'Pending Approval';
        li3.CurrencyIsoCode = 'USD';
        li3.APTS_Product_Family__c = 'PRINT LEGAL SOLUTIONS';
        li3.APTS_Contract_Term__c = '2 Years';
        li3.APTS_Years_2_Plus_Adjustment__c = '5';
        //li3.APTS_Cat_L2__c = System.Label.APTS_Print_Product_Family;
        insert li3;
        
        Apttus_Config2__LineItem__c li4 = new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c=prodConf.id , Apttus_Config2__ProductId__c=prod1.id);
        li4.Apttus_Config2__AddedBy__c = 'User';
        li4.Apttus_Config2__AdjustedPrice__c = 50;
        li4.Apttus_Config2__AdjustmentAmount__c = 50;
        li4.Apttus_Config2__AdjustmentType__c = '% Discount';
        li4.Apttus_Config2__AllocateGroupAdjustment__c = TRUE;
        li4.Apttus_Config2__AllowableAction__c = 'Unrestricted';
        li4.Apttus_Config2__AllowManualAdjustment__c = TRUE;
        li4.Apttus_Config2__AllowProration__c = FALSE;
        li4.Apttus_Config2__AllowRemoval__c = TRUE;
        li4.Apttus_Config2__AutoRenew__c = FALSE;
        li4.Apttus_Config2__BaseExtendedCost__c = 0;
        li4.Apttus_Config2__BaseExtendedPrice__c = 100;
        li4.Apttus_Config2__BasePrice__c = 100;
        li4.Apttus_Config2__BasePriceMethod__c = 'Per Unit';
        li4.Apttus_Config2__BillingFrequency__c = 'Monthly';
        li4.Apttus_Config2__ChargeType__c = 'Subscription Fee';
        li4.Apttus_Config2__ConfigStatus__c = 'Complete';
        li4.Apttus_Config2__ConstraintCheckStatus__c = 'NA';
        li4.Apttus_Config2__Customizable__c = FALSE;
        li4.Apttus_Config2__DeltaPrice__c = 50;
        li4.Apttus_Config2__DeltaQuantity__c = 1;
        li4.Apttus_Config2__Description__c = 'Westlaw Flex Plan $100/500';
        li4.Apttus_Config2__ExtendedCost__c = 0;
        li4.Apttus_Config2__ExtendedPrice__c = 100;
        li4.Apttus_Config2__Frequency__c = 'Monthly';
        li4.Apttus_Config2__Guidance__c = 'Red';
        li4.Apttus_Config2__HasAttributes__c = FALSE;
        li4.Apttus_Config2__HasBaseProduct__c = FALSE;
        li4.Apttus_Config2__HasDefaults__c = FALSE;
        li4.Apttus_Config2__HasIncentives__c = FALSE;
        li4.Apttus_Config2__HasOptions__c = FALSE;
        li4.Apttus_Config2__HasTieredPrice__c = FALSE;
        li4.Apttus_Config2__HideCopyAction__c = FALSE;
        li4.Apttus_Config2__HideInvoiceDisplay__c = FALSE;
        li4.Apttus_Config2__IsAssetPricing__c = FALSE;
        li4.Apttus_Config2__IsCustomPricing__c = FALSE;
        li4.Apttus_Config2__IsHidden__c = FALSE;
        li4.Apttus_Config2__IsOptionRollupLine__c = FALSE;
        li4.Apttus_Config2__IsPrimaryLine__c = TRUE;
        li4.Apttus_Config2__IsPrimaryRampLine__c = FALSE;
        li4.Apttus_Config2__IsQuantityModifiable__c = FALSE;
        li4.Apttus_Config2__IsReadOnly__c = FALSE;
        li4.Apttus_Config2__IsSellingTermReadOnly__c = FALSE;
        li4.Apttus_Config2__IsUsageTierModifiable__c = FALSE;
        li4.Apttus_Config2__ItemSequence__c = 1;
        li4.Apttus_Config2__LineNumber__c = 1;
        li4.Apttus_Config2__LineSequence__c = 1;
        li4.Apttus_Config2__LineStatus__c = 'Renewed';
        li4.Apttus_Config2__LineType__c = 'Product/Service';
        li4.Apttus_Config2__ListPrice__c = 100;
        li4.Apttus_Config2__NetAdjustmentPercent__c = -50;
        li4.Apttus_Config2__NetPrice__c = 50;
        li4.Apttus_Config2__NetUnitPrice__c = 50;
        li4.Apttus_Config2__OptionSequence__c = 0;
        li4.Apttus_Config2__PriceIncludedInBundle__c = FALSE;
        li4.Apttus_Config2__PriceMethod__c = 'Per Unit';
        li4.Apttus_Config2__PriceType__c = 'Recurring';
        li4.Apttus_Config2__PriceUom__c = 'Each';
        li4.Apttus_Config2__PricingStatus__c = 'Complete';
        li4.Apttus_Config2__PrimaryLineNumber__c = 1;
        li4.Apttus_Config2__ProductVersion__c = 1;
        li4.Apttus_Config2__Quantity__c = 1;
        li4.Apttus_Config2__RollupPriceToBundle__c = TRUE;
        li4.Apttus_Config2__SellingFrequency__c = 'Monthly';
        li4.Apttus_Config2__SellingTerm__c = 1;
        li4.Apttus_Config2__SyncStatus__c = 'Pending';
        li4.Apttus_Config2__Taxable__c = FALSE;
        li4.Apttus_Config2__TaxInclusive__c = FALSE;
        li4.Apttus_Config2__Term__c = 1;
        li4.Apttus_Config2__TotalQuantity__c = 1;
        li4.Apttus_Config2__Uom__c = 'Each';
        li4.Apttus_CQApprov__Approval_Status__c = 'Pending Approval';
        li4.CurrencyIsoCode = 'USD';
        li4.APTS_Product_Family__c = 'PRINT LEGAL SOLUTIONS';
        li4.APTS_Contract_Term__c = '2 Years';
        li4.APTS_Years_2_Plus_Adjustment__c = '5';
        //li4.APTS_Cat_L2__c = Sysem.Label.APTS_Print_Product_Family;
        insert li4;
        
        Apttus_Config2__LineItem__c li5 = new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c=prodConf2.id , Apttus_Config2__ProductId__c=prod.id);
        li5.Apttus_Config2__AddedBy__c = 'User';
        li5.Apttus_Config2__AdjustedPrice__c = 50;
        li5.Apttus_Config2__AdjustmentAmount__c = 50;
        li5.Apttus_Config2__AdjustmentType__c = '% Discount';
        li5.Apttus_Config2__AllocateGroupAdjustment__c = TRUE;
        li5.Apttus_Config2__AllowableAction__c = 'Unrestricted';
        li5.Apttus_Config2__AllowManualAdjustment__c = TRUE;
        li5.Apttus_Config2__AllowProration__c = FALSE;
        li5.Apttus_Config2__AllowRemoval__c = TRUE;
        li5.Apttus_Config2__AutoRenew__c = FALSE;
        li5.Apttus_Config2__BaseExtendedCost__c = 0;
        li5.Apttus_Config2__BaseExtendedPrice__c = 100;
        li5.Apttus_Config2__BasePrice__c = 100;
        li5.Apttus_Config2__BasePriceMethod__c = 'Per Unit';
        li5.Apttus_Config2__BillingFrequency__c = 'Monthly';
        li5.Apttus_Config2__ChargeType__c = 'Subscription Fee';
        li5.Apttus_Config2__ConfigStatus__c = 'Complete';
        li5.Apttus_Config2__ConstraintCheckStatus__c = 'NA';
        li5.Apttus_Config2__Customizable__c = FALSE;
        li5.Apttus_Config2__DeltaPrice__c = 50;
        li5.Apttus_Config2__DeltaQuantity__c = 1;
        li5.Apttus_Config2__Description__c = 'Westlaw Flex Plan $100/500';
        li5.Apttus_Config2__ExtendedCost__c = 0;
        li5.Apttus_Config2__ExtendedPrice__c = 100;
        li5.Apttus_Config2__Frequency__c = 'Monthly';
        li5.Apttus_Config2__Guidance__c = 'Red';
        li5.Apttus_Config2__HasAttributes__c = FALSE;
        li5.Apttus_Config2__HasBaseProduct__c = FALSE;
        li5.Apttus_Config2__HasDefaults__c = FALSE;
        li5.Apttus_Config2__HasIncentives__c = FALSE;
        li5.Apttus_Config2__HasOptions__c = FALSE;
        li5.Apttus_Config2__HasTieredPrice__c = FALSE;
        li5.Apttus_Config2__HideCopyAction__c = FALSE;
        li5.Apttus_Config2__HideInvoiceDisplay__c = FALSE;
        li5.Apttus_Config2__IsAssetPricing__c = FALSE;
        li5.Apttus_Config2__IsCustomPricing__c = FALSE;
        li5.Apttus_Config2__IsHidden__c = FALSE;
        li5.Apttus_Config2__IsOptionRollupLine__c = FALSE;
        li5.Apttus_Config2__IsPrimaryLine__c = TRUE;
        li5.Apttus_Config2__IsPrimaryRampLine__c = FALSE;
        li5.Apttus_Config2__IsQuantityModifiable__c = FALSE;
        li5.Apttus_Config2__IsReadOnly__c = FALSE;
        li5.Apttus_Config2__IsSellingTermReadOnly__c = FALSE;
        li5.Apttus_Config2__IsUsageTierModifiable__c = FALSE;
        li5.Apttus_Config2__ItemSequence__c = 1;
        li5.Apttus_Config2__LineNumber__c = 1;
        li5.Apttus_Config2__LineSequence__c = 1;
        li5.Apttus_Config2__LineStatus__c = 'Renewed';
        li5.Apttus_Config2__LineType__c = 'Product/Service';
        li5.Apttus_Config2__ListPrice__c = 100;
        li5.Apttus_Config2__NetAdjustmentPercent__c = -50;
        li5.Apttus_Config2__NetPrice__c = 50;
        li5.Apttus_Config2__NetUnitPrice__c = 50;
        li5.Apttus_Config2__OptionSequence__c = 0;
        li5.Apttus_Config2__PriceIncludedInBundle__c = FALSE;
        li5.Apttus_Config2__PriceMethod__c = 'Per Unit';
        li5.Apttus_Config2__PriceType__c = 'Recurring';
        li5.Apttus_Config2__PriceUom__c = 'Each';
        li5.Apttus_Config2__PricingStatus__c = 'Complete';
        li5.Apttus_Config2__PrimaryLineNumber__c = 1;
        li5.Apttus_Config2__ProductVersion__c = 1;
        li5.Apttus_Config2__Quantity__c = 1;
        li5.Apttus_Config2__RollupPriceToBundle__c = TRUE;
        li5.Apttus_Config2__SellingFrequency__c = 'Monthly';
        li5.Apttus_Config2__SellingTerm__c = 1;
        li5.Apttus_Config2__SyncStatus__c = 'Pending';
        li5.Apttus_Config2__Taxable__c = FALSE;
        li5.Apttus_Config2__TaxInclusive__c = FALSE;
        li5.Apttus_Config2__Term__c = 1;
        li5.Apttus_Config2__TotalQuantity__c = 1;
        li5.Apttus_Config2__Uom__c = 'Each';
        li5.Apttus_CQApprov__Approval_Status__c = 'Pending Approval';
        li5.CurrencyIsoCode = 'USD';
        li5.APTS_Product_Family__c = 'PRINT LEGAL SOLUTIONS';
        li5.APTS_Contract_Term__c = '2 Years';
        li5.APTS_Years_2_Plus_Adjustment__c = '5';
        //li5.APTS_Cat_L2__c = System.Label.APTS_Print_Product_Family;
        insert li5;
        
        
        li3.Apttus_Config2__IncentiveCode__c = '13843013';
        update li3;
        li3.APTS_Deal_Type__c = 'APP';
        li3.Apttus_Config2__LineStatus__c = 'Amended';
        li3.APTS_Bridge__c='1 Month';
        li3.APTS_Contract_Term__c='Short Term Trial';
        update li3;
        li5.APTS_Contract_Term__c='Short Term Trial';
        update li5;
        
                
        Test.stopTest();        
    }


    static testMethod void governmentApprovalTest() {
        APTS_TestDataFactory.createFLTrephCodes();
        Map<String,List<String>> flcodeMap=new Map<String,List<String>>(); 
        List<APTS_TREPH_FINDLAW_CODES__c> flcodes= APTS_TREPH_FINDLAW_CODES__c.getAll().values();
        for(APTS_TREPH_FINDLAW_CODES__c pb :flcodes){    
            String flvalue= pb.value__c;               
            flcodeMap.put(pb.name,pb.value__c.split(','));
        }
        List<KeyValueListStore__c> keyvaluestoreList = new List<KeyValueListStore__c>();
        KeyValueListStore__c keyvaluestore=new  KeyValueListStore__c();
        keyvaluestore.Name='ANZUsersProfileId';
        keyvaluestore.TextValue__c=System.Label.APTS_OC_Test_Id;
        keyvaluestoreList.add(keyvaluestore); 
        KeyValueListStore__c keyval = new KeyValueListStore__c();
        keyval.Name='ReasonWithCompetitor';
        keyval.TextValue__c='Price';
        keyvaluestoreList.add(keyval);
        insert keyvaluestoreList;
        
        //Inserting recordLists
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
        
        List<APTS_Segment_Threshold__c> segthrList= new List<APTS_Segment_Threshold__c>();
        //Add Segment threshold
        APTS_Segment_Threshold__c seg1 = new APTS_Segment_Threshold__c();
        seg1.APTS_Approval_Required__c=True;
        seg1.APTS_Segment__c='Small Law';
        seg1.APTS_Customer_Category__c='5';
        seg1.APTS_Term_in_years__c=Integer.ValueOf('2');
        seg1.APTS_Minimum_OY_Increase__c=Integer.ValueOf('15');
        seg1.APTS_Minimum_Incremental_Growth__c=Integer.ValueOf('15');
        seg1.APTS_Product_Family__c = 'CLEAR';
        seg1.APTS_Promo_Codes__c = '13843014';
        seg1.APTS_Promo_Minimum_OY_Increase__c = 17;        
        segthrList.add(seg1);
        
        APTS_Segment_Threshold__c seg2 = new APTS_Segment_Threshold__c();
        seg2.APTS_Approval_Required__c=True;
        seg2.APTS_Segment__c='Corporate';
        seg2.APTS_Customer_Category__c='5';
        seg2.APTS_Term_in_years__c=Integer.ValueOf('2');
        seg2.APTS_Minimum_OY_Increase__c=Integer.ValueOf('15');
        seg2.APTS_Minimum_Incremental_Growth__c=Integer.ValueOf('15');
        seg2.APTS_Product_Family__c = 'CLEAR';
        seg2.APTS_Promo_Codes__c = '13843013';
        seg2.APTS_Promo_Minimum_OY_Increase__c = 16;        
        segthrList.add(seg2);
        System.assertEquals(seg2.APTS_Promo_Codes__c,'13843013');
                
        APTS_Segment_Threshold__c seg3 = new APTS_Segment_Threshold__c();
        seg3.APTS_Approval_Required__c=True;
        seg3.APTS_Segment__c='Government';
        seg3.APTS_Customer_Category__c='5';
        seg3.APTS_Term_in_years__c=Integer.ValueOf('2');
        seg3.APTS_Minimum_OY_Increase__c=Integer.ValueOf('15');
        seg3.APTS_Minimum_Incremental_Growth__c=Integer.ValueOf('15');
        segthrList.add(seg3);
        
        //Added by Chirag 1/10/18
        APTS_Segment_Threshold__c seg4 = new APTS_Segment_Threshold__c();
        seg4.APTS_Approval_Required__c=True;
        seg4.APTS_Segment__c='Government';
        seg4.APTS_Customer_Category__c='5';
        seg4.APTS_Term_in_years__c=Integer.ValueOf('2');
        seg4.APTS_Minimum_OY_Increase__c=Integer.ValueOf('15');
        seg4.APTS_Minimum_Incremental_Growth__c=Integer.ValueOf('15');
        seg4.APTS_Product_Family__c = 'CLEAR';
        seg4.APTS_Promo_Codes__c = '13843012';
        seg4.APTS_Promo_Minimum_OY_Increase__c = 15;        
        segthrList.add(seg4);
        
        insert segthrList;
        
        Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
        Account a = new Account(RecordTypeId=accRecordTypeId,name='test-sg',sales_org__c='ABEP',customer_group__c='Academic',customer_type__c='Organization',customer_class_c__c='Academic Lecturer');
        a.APTS_Customer_Category__c = '5';
        a.Is_GLI__c = True;
        insert a;        
        
        Schema.DescribeFieldResult fieldResultMarket = Apttus_Config2__ProductConfiguration__c.APTS_AccountMirror_Picklist__c.getDescribe();
        String valueMarket = fieldResultMarket.getPicklistValues().get(0).getValue();
        
        //Inserting SourceSystemDetail
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();
        Source_System_Detail__c accountSSD= new Source_System_Detail__c();
        accountSSD.RecordtypeId=ssdRecorType;
        accountSSD.Name='ABC';
        accountSSD.Source_System_Name__c='ABC';
        accountSSD.Account_Name__c=a.ID;
        accountSSD.APTS_Customer_Category__c='1';
        accountSSD.LCRM_Customer_Group__c='Academic';
        accountSSD.LCRM_Frozen_Market_Segment__c = valueMarket;
        accountSSD.Account_Inactive__c=false;
        accountSSD.LCRM_Sales_Org__c='WEST';
        accountSSD.APTS_Has_Online_Assets__c=true;
        insert accountSSD;
        
        Date todaysDate = system.today();
        Id oppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Pipeline Opportunity').getRecordTypeId();
        Opportunity o = new Opportunity(RecordTypeId=oppRecordTypeId,  Name='tst-opp', stagename='25%',closedate=todaysDate,forecastcategoryname='pipeline',accountId=a.id);
        insert o;
        
        List <Apttus_Proposal__Proposal__c > listofProposals = new List <Apttus_Proposal__Proposal__c >();
        Id devRecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Proposal').getRecordTypeId();
        Apttus_Proposal__Proposal__c p = new Apttus_Proposal__Proposal__c(RecordTypeId=devRecordTypeId, CurrencyIsoCode = 'USD', Apttus_Proposal__Account__c=a.id,Apttus_Proposal__Proposal_Name__c='TST-10',  Apttus_Proposal__Opportunity__c=o.id, Apttus_Proposal__Approval_Stage__c='Draft', Apttus_Proposal__Proposal_Category__c='Quote', Apttus_Proposal__ReadyToGenerate__c = true, Apttus_Proposal__ReadyToPresent__c= true,APTS_SSD_Sold_To__c=accountSSD.Id,APTS_SSD_ship_to__c=accountSSD.Id,APTS_SSD_bill_to__c=accountSSD.Id);
        p.APTS_Approval_Segment__c = 'Government';
        p.APTS_Proposal_Business_Unit__c='FindLaw';
        listofProposals.add(p);
    
        Apttus_Proposal__Proposal__c p1 = new Apttus_Proposal__Proposal__c(RecordTypeId=devRecordTypeId, CurrencyIsoCode = 'USD', Apttus_Proposal__Account__c=a.id,Apttus_Proposal__Proposal_Name__c='TST-10',  Apttus_Proposal__Opportunity__c=o.id, Apttus_Proposal__Approval_Stage__c='Draft', Apttus_Proposal__Proposal_Category__c='Quote', Apttus_Proposal__ReadyToGenerate__c = true, Apttus_Proposal__ReadyToPresent__c= true,APTS_SSD_Sold_To__c=accountSSD.Id,APTS_SSD_ship_to__c=accountSSD.Id,APTS_SSD_bill_to__c=accountSSD.Id);
        p1.APTS_Approval_Segment__c = 'Government';
        p1.APTS_Proposal_Business_Unit__c='SCS';
        listofProposals.add(p1);
        insert listofProposals;
        
        Apttus_Config2__ProductConfiguration__c prodConf = new Apttus_Config2__ProductConfiguration__c(Name='prod-conf1', CurrencyIsoCode = 'USD', Apttus_QPConfig__Proposald__c=p.id, APTS_SSD_ship_to__c=accountSSD.Id,APTS_SSD_bill_to__c=accountSSD.Id);
        insert prodConf;
        
        Apttus_Config2__ProductConfiguration__c prodConf1 = new Apttus_Config2__ProductConfiguration__c(Name='prod-conf1', CurrencyIsoCode = 'USD', Apttus_QPConfig__Proposald__c=p1.id, APTS_SSD_ship_to__c=accountSSD.Id,APTS_SSD_bill_to__c=accountSSD.Id);
        insert prodConf1;
        
        Product2 prod = new Product2(name='prod1', Media_High_Level__c='Online', CurrencyIsoCode = 'USD',APTS_CAT_L2__c=System.Label.APTS_Clear_Product_Family,APTS_CAT_L3__c='L3_L030_FP');
        prod.APTS_Approval_Always_Required__c = true;
        insert prod;
        
        Apttus_Config2__ConfigSystemProperties__c configSetting=new Apttus_Config2__ConfigSystemProperties__c(Name='System Properties',Apttus_Config2__DisableConstraintRules__c=true);
        insert configSetting;


        Apttus_Config2__AssetLineItem__c asset = new Apttus_Config2__AssetLineItem__c(Name = 'Test asset', APTS_Info_PlanType__c = 'S00', 
                                                                                              Apttus_Config2__NetPrice__c = 10.00, APTS_SSD_Bill_To__c = accountSSD.Id,
                                                                                              Apttus_QPConfig__ProposalId__c =p.id,
                                                                                              APTS_Info_RenewalDate__c = System.today().addDays(-180));
         insert asset;
          Apttus_Config2__AssetLineItem__c asset1 = new Apttus_Config2__AssetLineItem__c(Name = 'Test asset', APTS_Info_PlanType__c = 'S00', 
                                                                                              Apttus_Config2__NetPrice__c = 10.00, APTS_SSD_Bill_To__c = accountSSD.Id,
                                                                                              Apttus_QPConfig__ProposalId__c =p.id,
                                                                                              APTS_Info_RenewalDate__c = System.today().addDays(200));
         insert asset1;
        test.startTest();
        Apttus_Config2__LineItem__c li3 = new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c=prodConf.id , Apttus_Config2__ProductId__c=prod.id);
        li3.Apttus_Config2__AddedBy__c = 'User';
        li3.Apttus_Config2__AdjustedPrice__c = 50;
        li3.Apttus_Config2__AdjustmentAmount__c = 50;
        li3.Apttus_Config2__AdjustmentType__c = '% Discount';
        li3.Apttus_Config2__AllocateGroupAdjustment__c = TRUE;
        li3.Apttus_Config2__AllowableAction__c = 'Unrestricted';
        li3.Apttus_Config2__AllowManualAdjustment__c = TRUE;
        li3.Apttus_Config2__AllowProration__c = FALSE;
        li3.Apttus_Config2__AllowRemoval__c = TRUE;
        li3.Apttus_Config2__AutoRenew__c = FALSE;
        li3.Apttus_Config2__BaseExtendedCost__c = 0;
        li3.Apttus_Config2__BaseExtendedPrice__c = 100;
        li3.Apttus_Config2__BasePrice__c = 100;
        li3.Apttus_Config2__BasePriceMethod__c = 'Per Unit';
        li3.Apttus_Config2__BillingFrequency__c = 'Monthly';
        li3.Apttus_Config2__ChargeType__c = 'Subscription Fee';
        li3.Apttus_Config2__ConfigStatus__c = 'Complete';
        li3.Apttus_Config2__ConstraintCheckStatus__c = 'NA';
        li3.Apttus_Config2__Customizable__c = FALSE;
        li3.Apttus_Config2__DeltaPrice__c = 50;
        li3.Apttus_Config2__DeltaQuantity__c = 1;
        li3.Apttus_Config2__Description__c = 'Westlaw Flex Plan $100/500';
        li3.Apttus_Config2__ExtendedCost__c = 0;
        li3.Apttus_Config2__ExtendedPrice__c = 100;
        li3.Apttus_Config2__Frequency__c = 'Monthly';
        li3.Apttus_Config2__Guidance__c = 'Red';
        li3.Apttus_Config2__HasAttributes__c = FALSE;
        li3.Apttus_Config2__HasBaseProduct__c = FALSE;
        li3.Apttus_Config2__HasDefaults__c = FALSE;
        li3.Apttus_Config2__HasIncentives__c = FALSE;
        li3.Apttus_Config2__HasOptions__c = FALSE;
        li3.Apttus_Config2__HasTieredPrice__c = FALSE;
        li3.Apttus_Config2__HideCopyAction__c = FALSE;
        li3.Apttus_Config2__HideInvoiceDisplay__c = FALSE;
        li3.Apttus_Config2__IsAssetPricing__c = FALSE;
        li3.Apttus_Config2__IsCustomPricing__c = FALSE;
        li3.Apttus_Config2__IsHidden__c = FALSE;
        li3.Apttus_Config2__IsOptionRollupLine__c = FALSE;
        li3.Apttus_Config2__IsPrimaryLine__c = TRUE;
        li3.Apttus_Config2__IsPrimaryRampLine__c = FALSE;
        li3.Apttus_Config2__IsQuantityModifiable__c = FALSE;
        li3.Apttus_Config2__IsReadOnly__c = FALSE;
        li3.Apttus_Config2__IsSellingTermReadOnly__c = FALSE;
        li3.Apttus_Config2__IsUsageTierModifiable__c = FALSE;
        li3.Apttus_Config2__ItemSequence__c = 1;
        li3.Apttus_Config2__LineNumber__c = 1;
        li3.Apttus_Config2__LineSequence__c = 1;
        li3.Apttus_Config2__LineStatus__c = 'Renewed';
        li3.APTS_Yr_1_Renewal_Adjustment__c='1';
        li3.Apttus_Config2__LineType__c = 'Product/Service';
        li3.Apttus_Config2__ListPrice__c = 100;
        li3.Apttus_Config2__NetAdjustmentPercent__c = -50;
        li3.Apttus_Config2__NetPrice__c = 50;
        li3.Apttus_Config2__NetUnitPrice__c = 50;
        li3.Apttus_Config2__OptionSequence__c = 0;
        li3.Apttus_Config2__PriceIncludedInBundle__c = FALSE;
        li3.Apttus_Config2__PriceMethod__c = 'Per Unit';
        li3.Apttus_Config2__PriceType__c = 'Recurring';
        li3.Apttus_Config2__PriceUom__c = 'Each';
        li3.Apttus_Config2__PricingStatus__c = 'Complete';
        li3.Apttus_Config2__PrimaryLineNumber__c = 1;
        li3.Apttus_Config2__ProductVersion__c = 1;
        li3.APTS_Product_Family__c='RUTTER';
        //li3.APTS_Cat_L3__c = System.Label.APTS_Rutter_Product_Family;
        li3.Apttus_Config2__Quantity__c = 1;
        li3.Apttus_Config2__RollupPriceToBundle__c = TRUE;
        li3.Apttus_Config2__SellingFrequency__c = 'Monthly';
        li3.Apttus_Config2__SellingTerm__c = 1;
        li3.Apttus_Config2__SyncStatus__c = 'Pending';
        li3.Apttus_Config2__Taxable__c = FALSE;
        li3.Apttus_Config2__TaxInclusive__c = FALSE;
        li3.Apttus_Config2__Term__c = 1;
        li3.Apttus_Config2__TotalQuantity__c = 1;
        li3.Apttus_Config2__Uom__c = 'Each';
        li3.Apttus_CQApprov__Approval_Status__c = 'Pending Approval';
        li3.CurrencyIsoCode = 'USD';
        li3.APTS_Product_Family__c = 'CLEAR';
        //li3.APTS_Cat_L2__c = System.Label.APTS_Clear_Product_Family;
        li3.APTS_Contract_Term__c = '2 Years';
        li3.APTS_Years_2_Plus_Adjustment__c = '5';
        li3.Apttus_Config2__AssetLineItemId__c = asset.Id;
        insert li3;
        
        Apttus_Config2__LineItem__c li4 = new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c=prodConf.id , Apttus_Config2__ProductId__c=prod.id);
        li4.Apttus_Config2__AddedBy__c = 'User';
        li4.Apttus_Config2__AdjustedPrice__c = 50;
        li4.Apttus_Config2__AdjustmentAmount__c = 50;
        li4.Apttus_Config2__AdjustmentType__c = '% Discount';
        li4.Apttus_Config2__AllocateGroupAdjustment__c = TRUE;
        li4.Apttus_Config2__AllowableAction__c = 'Unrestricted';
        li4.Apttus_Config2__AllowManualAdjustment__c = TRUE;
        li4.Apttus_Config2__AllowProration__c = FALSE;
        li4.Apttus_Config2__AllowRemoval__c = TRUE;
        li4.Apttus_Config2__AutoRenew__c = FALSE;
        li4.Apttus_Config2__BaseExtendedCost__c = 0;
        li4.Apttus_Config2__BaseExtendedPrice__c = 100;
        li4.Apttus_Config2__BasePrice__c = 100;
        li4.Apttus_Config2__BasePriceMethod__c = 'Per Unit';
        li4.Apttus_Config2__BillingFrequency__c = 'Monthly';
        li4.Apttus_Config2__ChargeType__c = 'Subscription Fee';
        li4.Apttus_Config2__ConfigStatus__c = 'Complete';
        li4.Apttus_Config2__ConstraintCheckStatus__c = 'NA';
        li4.Apttus_Config2__Customizable__c = FALSE;
        li4.Apttus_Config2__DeltaPrice__c = 50;
        li4.Apttus_Config2__DeltaQuantity__c = 1;
        li4.Apttus_Config2__Description__c = 'Westlaw Flex Plan $100/500';
        li4.Apttus_Config2__ExtendedCost__c = 0;
        li4.Apttus_Config2__ExtendedPrice__c = 100;
        li4.Apttus_Config2__Frequency__c = 'Monthly';
        li4.Apttus_Config2__Guidance__c = 'Red';
        li4.Apttus_Config2__HasAttributes__c = FALSE;
        li4.Apttus_Config2__HasBaseProduct__c = FALSE;
        li4.Apttus_Config2__HasDefaults__c = FALSE;
        li4.Apttus_Config2__HasIncentives__c = FALSE;
        li4.Apttus_Config2__HasOptions__c = FALSE;
        li4.Apttus_Config2__HasTieredPrice__c = FALSE;
        li4.Apttus_Config2__HideCopyAction__c = FALSE;
        li4.Apttus_Config2__HideInvoiceDisplay__c = FALSE;
        li4.Apttus_Config2__IsAssetPricing__c = FALSE;
        li4.Apttus_Config2__IsCustomPricing__c = FALSE;
        li4.Apttus_Config2__IsHidden__c = FALSE;
        li4.Apttus_Config2__IsOptionRollupLine__c = FALSE;
        li4.Apttus_Config2__IsPrimaryLine__c = TRUE;
        li4.Apttus_Config2__IsPrimaryRampLine__c = FALSE;
        li4.Apttus_Config2__IsQuantityModifiable__c = FALSE;
        li4.Apttus_Config2__IsReadOnly__c = FALSE;
        li4.Apttus_Config2__IsSellingTermReadOnly__c = FALSE;
        li4.Apttus_Config2__IsUsageTierModifiable__c = FALSE;
        li4.Apttus_Config2__ItemSequence__c = 1;
        li4.Apttus_Config2__LineNumber__c = 1;
        li4.Apttus_Config2__LineSequence__c = 1;
        li4.Apttus_Config2__LineStatus__c = 'New';
        li4.APTS_Yr_1_Renewal_Adjustment__c='1';
        li4.Apttus_Config2__LineType__c = 'Product/Service';
        li4.Apttus_Config2__ListPrice__c = 100;
        li4.Apttus_Config2__NetAdjustmentPercent__c = -50;
        li4.Apttus_Config2__NetPrice__c = 50;
        li4.Apttus_Config2__NetUnitPrice__c = 50;
        li4.Apttus_Config2__OptionSequence__c = 0;
        li4.Apttus_Config2__PriceIncludedInBundle__c = FALSE;
        li4.Apttus_Config2__PriceMethod__c = 'Per Unit';
        li4.Apttus_Config2__PriceType__c = 'Recurring';
        li4.Apttus_Config2__PriceUom__c = 'Attorneys';
        li4.Apttus_Config2__PricingStatus__c = 'Complete';
        li4.Apttus_Config2__PrimaryLineNumber__c = 1;
        li4.Apttus_Config2__ProductVersion__c = 1;
        li4.APTS_Product_Family__c='RUTTER';
        //li4.APTS_Cat_L3__c = System.Label.APTS_Rutter_Product_Family;
        li4.Apttus_Config2__Quantity__c = 1;
        li4.Apttus_Config2__RollupPriceToBundle__c = TRUE;
        li4.Apttus_Config2__SellingFrequency__c = 'Monthly';
        li4.Apttus_Config2__SellingTerm__c = 1;
        li4.Apttus_Config2__SyncStatus__c = 'Pending';
        li4.Apttus_Config2__Taxable__c = FALSE;
        li4.Apttus_Config2__TaxInclusive__c = FALSE;
        li4.Apttus_Config2__Term__c = 1;
        li4.Apttus_Config2__TotalQuantity__c = 1;
        li4.Apttus_Config2__Uom__c = 'Each';
        li4.Apttus_CQApprov__Approval_Status__c = 'Pending Approval';
        li4.CurrencyIsoCode = 'USD';
        li4.APTS_Product_Family__c = 'CLEAR';
        //li4.APTS_Cat_L2__c = System.Label.APTS_Clear_Product_Family;
        li4.APTS_Contract_Term__c = '2 Years';
        li4.APTS_Years_2_Plus_Adjustment__c = '5';
        li4.Apttus_Config2__IncentiveCode__c = '13843012,13843012';
        li4.APTS_Bridge__c='1 Month';        
        li4.APTS_Contract_Term__c='Short Term Trial'; 
        li4.Apttus_Config2__AssetLineItemId__c = asset.Id;
        insert li4;
        
        Apttus_Config2__LineItem__c li5 = new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c=prodConf.id , Apttus_Config2__ProductId__c=prod.id);
        li5.Apttus_Config2__AddedBy__c = 'User';
        li5.Apttus_Config2__AdjustedPrice__c = 50;
        li5.Apttus_Config2__AdjustmentAmount__c = 50;
        li5.Apttus_Config2__AdjustmentType__c = '% Discount';
        li5.Apttus_Config2__AllocateGroupAdjustment__c = TRUE;
        li5.Apttus_Config2__AllowableAction__c = 'Unrestricted';
        li5.Apttus_Config2__AllowManualAdjustment__c = TRUE;
        li5.Apttus_Config2__AllowProration__c = FALSE;
        li5.Apttus_Config2__AllowRemoval__c = TRUE;
        li5.Apttus_Config2__AutoRenew__c = FALSE;
        li5.Apttus_Config2__BaseExtendedCost__c = 0;
        li5.Apttus_Config2__BaseExtendedPrice__c = 100;
        li5.Apttus_Config2__BasePrice__c = 100;
        li5.Apttus_Config2__BasePriceMethod__c = 'Per Unit';
        li5.Apttus_Config2__BillingFrequency__c = 'Monthly';
        li5.Apttus_Config2__ChargeType__c = 'Subscription Fee';
        li5.Apttus_Config2__ConfigStatus__c = 'Complete';
        li5.Apttus_Config2__ConstraintCheckStatus__c = 'NA';
        li5.Apttus_Config2__Customizable__c = FALSE;
        li5.Apttus_Config2__DeltaPrice__c = 50;
        li5.Apttus_Config2__DeltaQuantity__c = 1;
        li5.Apttus_Config2__Description__c = 'Westlaw Flex Plan $100/500';
        li5.Apttus_Config2__ExtendedCost__c = 0;
        li5.Apttus_Config2__ExtendedPrice__c = 100;
        li5.Apttus_Config2__Frequency__c = 'Monthly';
        li5.Apttus_Config2__Guidance__c = 'Red';       
        li5.Apttus_Config2__IsPrimaryLine__c = TRUE;        
        li5.Apttus_Config2__ItemSequence__c = 1;
        li5.Apttus_Config2__LineNumber__c = 1;
        li5.Apttus_Config2__LineSequence__c = 1;
        li5.Apttus_Config2__LineStatus__c = 'New';
        li5.APTS_Yr_1_Renewal_Adjustment__c='1';
        li5.Apttus_Config2__LineType__c = 'Product/Service';
        li5.Apttus_Config2__ListPrice__c = 100;
        li5.Apttus_Config2__NetAdjustmentPercent__c = -50;
        li5.Apttus_Config2__NetPrice__c = 50;
        li5.Apttus_Config2__NetUnitPrice__c = 50;
        li5.Apttus_Config2__OptionSequence__c = 0;        
        li5.Apttus_Config2__PriceMethod__c = 'Per Unit';
        li5.Apttus_Config2__PriceType__c = 'Recurring';
        li5.Apttus_Config2__PriceUom__c = 'Attorneys';
        li5.Apttus_Config2__PricingStatus__c = 'Complete';       
        li5.Apttus_Config2__Quantity__c = 1;
        li5.Apttus_Config2__RollupPriceToBundle__c = TRUE;
        li5.Apttus_Config2__SellingFrequency__c = 'Monthly';
        li5.Apttus_Config2__SellingTerm__c = 1;        
        li5.Apttus_Config2__Taxable__c = FALSE;
        li5.Apttus_Config2__TaxInclusive__c = FALSE;
        li5.Apttus_Config2__Term__c = 1;
        li5.Apttus_Config2__TotalQuantity__c = 1;
        li5.Apttus_Config2__Uom__c = 'Each';        
        li5.CurrencyIsoCode = 'USD';
        li5.APTS_Product_Family__c = 'CLEAR';
        //li4.APTS_Cat_L2__c = System.Label.APTS_Clear_Product_Family;
        li5.APTS_Contract_Term__c = '2 Years';
        li5.APTS_Years_2_Plus_Adjustment__c = '5';
        li5.Apttus_Config2__IncentiveCode__c = '13843012,13843012';
        li5.APTS_Bridge__c='1 Month'; 
        li5.Apttus_Config2__AssetLineItemId__c = asset.Id;                  
        insert li5;
        
        li3.Apttus_Config2__IncentiveCode__c = '13843012,13843012';
        update li3;
        li3.APTS_Bridge__c='1 Month';
        li3.APTS_Contract_Term__c='Short Term Trial';
        update li3;   
        li4.Apttus_Config2__LineStatus__c ='Cancelled';
        update li4;    
        
        Test.stopTest();        
    }

    static testMethod void fsiMApprovalRequiredtest(){
        List<KeyValueListStore__c> keyvaluestoreList = new List<KeyValueListStore__c>();
        KeyValueListStore__c keyvaluestore=new  KeyValueListStore__c();
        keyvaluestore.Name='ANZUsersProfileId';
        keyvaluestore.TextValue__c=System.Label.APTS_OC_Test_Id;
        keyvaluestoreList.add(keyvaluestore); 
        KeyValueListStore__c keyval = new KeyValueListStore__c();
        keyval.Name='ReasonWithCompetitor';
        keyval.TextValue__c='Price';
        keyvaluestoreList.add(keyval);
        insert keyvaluestoreList;
        
        //Inserting recordLists
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
        
        Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
        Account a = new Account(RecordTypeId=accRecordTypeId,name='test-sg',sales_org__c='ABEP',customer_group__c='Academic',customer_type__c='Organization',customer_class_c__c='Academic Lecturer');
        a.APTS_Customer_Category__c = '5';
        a.Is_GLI__c = True;
        insert a;
                
        Schema.DescribeFieldResult fieldResultMarket = Apttus_Config2__ProductConfiguration__c.APTS_AccountMirror_Picklist__c.getDescribe();
        String valueMarket = fieldResultMarket.getPicklistValues().get(0).getValue();
        
        //Inserting SourceSystemDetail
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();
        Source_System_Detail__c accountSSD= new Source_System_Detail__c();
        accountSSD.RecordtypeId=ssdRecorType;
        accountSSD.Name='ABC';
        accountSSD.Source_System_Name__c='ABC';
        accountSSD.Account_Name__c=a.ID;
        accountSSD.APTS_Customer_Category__c='1';
        accountSSD.LCRM_Customer_Group__c='Academic';
        accountSSD.LCRM_Frozen_Market_Segment__c = valueMarket;
        accountSSD.Account_Inactive__c=false;
        accountSSD.LCRM_Sales_Org__c='WEST';
        accountSSD.LCRM_FL_Annual_Spend__c=100;
        accountSSD.APTS_Has_Online_Assets__c=true;
        insert accountSSD;
        
        Date todaysDate = system.today();
        Id oppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Pipeline Opportunity').getRecordTypeId();
        Opportunity o = new Opportunity(RecordTypeId=oppRecordTypeId,  Name='tst-opp', stagename='25%',closedate=todaysDate,forecastcategoryname='pipeline',accountId=a.id);
        insert o;
        
        Id devRecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Proposal').getRecordTypeId();
        Apttus_Proposal__Proposal__c p = new Apttus_Proposal__Proposal__c(RecordTypeId=devRecordTypeId, CurrencyIsoCode = 'USD', Apttus_Proposal__Account__c=a.id,Apttus_Proposal__Proposal_Name__c='TST-10',  Apttus_Proposal__Opportunity__c=o.id, Apttus_Proposal__Approval_Stage__c='Draft', Apttus_Proposal__Proposal_Category__c='Quote', Apttus_Proposal__ReadyToGenerate__c = true, Apttus_Proposal__ReadyToPresent__c= true,APTS_SSD_Sold_To__c=accountSSD.Id,APTS_SSD_ship_to__c=accountSSD.Id,APTS_SSD_bill_to__c=accountSSD.Id);
        p.APTS_Approval_Segment__c = 'FindLaw';
        insert p;
        
        Apttus_Config2__ProductConfiguration__c prodConf = new Apttus_Config2__ProductConfiguration__c(Name='prod-conf1', CurrencyIsoCode = 'USD', Apttus_QPConfig__Proposald__c=p.id, APTS_SSD_ship_to__c=accountSSD.Id,APTS_SSD_bill_to__c=accountSSD.Id);
        insert prodConf;
        
        List<Product2> productList=new List<Product2>();
        Product2 prod1 = new Product2(name='prod1', Media_High_Level__c='Online', CurrencyIsoCode = 'USD',ProductCode = '40483699');
        Product2 prod2 = new Product2(name='prod2', Media_High_Level__c='Online', CurrencyIsoCode = 'USD',ProductCode='40485592');
        Product2 prod3 = new Product2(name='prod3', Media_High_Level__c='Online', CurrencyIsoCode = 'USD',ProductCode='40483696');
        Product2 prod4 = new Product2(name='prod4', Media_High_Level__c='Online', CurrencyIsoCode = 'USD',ProductCode='40483693');
        Product2 prod5 = new Product2(name='prod5', Media_High_Level__c='Online', CurrencyIsoCode = 'USD',ProductCode='41915678');
        Product2 prod6 = new Product2(name='prod6', Media_High_Level__c='Online', CurrencyIsoCode = 'USD',ProductCode='41892830');
        Product2 prod7 = new Product2(name='prod7', Media_High_Level__c='Online', CurrencyIsoCode = 'USD',ProductCode='41767150');
        Product2 prod8 = new Product2(name='prod8', Media_High_Level__c='Online', CurrencyIsoCode = 'USD',ProductCode='42124052');
        Product2 prod9 = new Product2(name='prod9', Media_High_Level__c='Online', CurrencyIsoCode = 'USD',ProductCode='41822784');
        Product2 prod10 = new Product2(name='prod10', Media_High_Level__c='Online', CurrencyIsoCode = 'USD',ProductCode='41777796');
        productList.add(prod1);
        productList.add(prod2);
        productList.add(prod3);
        productList.add(prod4);
        productList.add(prod5);
        productList.add(prod6);
        productList.add(prod7);
        productList.add(prod8);
        productList.add(prod9);
        productList.add(prod10);
        insert productList;
        System.assertEquals(prod1.Name, 'prod1');
        List<Apttus_Config2__LineItem__c> insertList=new List<Apttus_Config2__LineItem__c>();
        List<Apttus_Config2__LineItem__c> updateList=new List<Apttus_Config2__LineItem__c>();
        
        Apttus_Config2__LineItem__c lineItem1=new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c=prodConf.id , Apttus_Config2__ProductId__c=prod1.id,Apttus_Config2__LineType__c ='Product/Service',Apttus_Config2__LineStatus__c = 'New',Apttus_Config2__ChargeType__c = 'Subscription Fee',Apttus_Config2__ItemSequence__c = 1,Apttus_Config2__LineNumber__c = 1,Apttus_Config2__ListPrice__c = 100,Apttus_Config2__NetAdjustmentPercent__c = -50,Apttus_Config2__NetPrice__c = 50,Apttus_Config2__NetUnitPrice__c = 50,Apttus_Config2__AdjustedPrice__c = 50,Apttus_Config2__AdjustmentAmount__c = 50,Apttus_Config2__AdjustmentType__c = '% Discount',Apttus_Config2__AddedBy__c = 'User',CurrencyIsoCode = 'USD');
        Apttus_Config2__LineItem__c lineItem2=new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c=prodConf.id , Apttus_Config2__ProductId__c=prod2.id,Apttus_Config2__LineType__c ='Product/Service',Apttus_Config2__LineStatus__c = 'New',Apttus_Config2__ChargeType__c = 'Subscription Fee',Apttus_Config2__ItemSequence__c = 1,Apttus_Config2__LineNumber__c = 1,Apttus_Config2__ListPrice__c = 100,Apttus_Config2__NetAdjustmentPercent__c = -50,Apttus_Config2__NetPrice__c = 50,Apttus_Config2__NetUnitPrice__c = 50,Apttus_Config2__AdjustedPrice__c = 50,Apttus_Config2__AdjustmentAmount__c = 50,Apttus_Config2__AdjustmentType__c = '% Discount',Apttus_Config2__AddedBy__c = 'User',CurrencyIsoCode = 'USD');
        Apttus_Config2__LineItem__c lineItem3=new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c=prodConf.id , Apttus_Config2__ProductId__c=prod3.id,Apttus_Config2__LineType__c ='Product/Service',Apttus_Config2__LineStatus__c = 'New',Apttus_Config2__ChargeType__c = 'Subscription Fee',Apttus_Config2__ItemSequence__c = 1,Apttus_Config2__LineNumber__c = 1,Apttus_Config2__ListPrice__c = 100,Apttus_Config2__NetAdjustmentPercent__c = -50,Apttus_Config2__NetPrice__c = 50,Apttus_Config2__NetUnitPrice__c = 50,Apttus_Config2__AdjustedPrice__c = 50,Apttus_Config2__AdjustmentAmount__c = 50,Apttus_Config2__AdjustmentType__c = '% Discount',Apttus_Config2__AddedBy__c = 'User',CurrencyIsoCode = 'USD');
        Apttus_Config2__LineItem__c lineItem4=new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c=prodConf.id , Apttus_Config2__ProductId__c=prod4.id,Apttus_Config2__LineType__c ='Product/Service',Apttus_Config2__LineStatus__c = 'New',Apttus_Config2__ChargeType__c = 'Subscription Fee',Apttus_Config2__ItemSequence__c = 1,Apttus_Config2__LineNumber__c = 1,Apttus_Config2__ListPrice__c = 100,Apttus_Config2__NetAdjustmentPercent__c = -50,Apttus_Config2__NetPrice__c = 50,Apttus_Config2__NetUnitPrice__c = 50,Apttus_Config2__AdjustedPrice__c = 50,Apttus_Config2__AdjustmentAmount__c = 50,Apttus_Config2__AdjustmentType__c = '% Discount',Apttus_Config2__AddedBy__c = 'User',CurrencyIsoCode = 'USD');
        Apttus_Config2__LineItem__c lineItem5=new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c=prodConf.id , Apttus_Config2__ProductId__c=prod5.id,Apttus_Config2__LineType__c ='Product/Service',Apttus_Config2__LineStatus__c = 'New',Apttus_Config2__ChargeType__c = 'Subscription Fee',Apttus_Config2__ItemSequence__c = 1,Apttus_Config2__LineNumber__c = 1,Apttus_Config2__ListPrice__c = 100,Apttus_Config2__NetAdjustmentPercent__c = -50,Apttus_Config2__NetPrice__c = 50,Apttus_Config2__NetUnitPrice__c = 50,Apttus_Config2__AdjustedPrice__c = 50,Apttus_Config2__AdjustmentAmount__c = 50,Apttus_Config2__AdjustmentType__c = '% Discount',Apttus_Config2__AddedBy__c = 'User',CurrencyIsoCode = 'USD');
        Apttus_Config2__LineItem__c lineItem6=new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c=prodConf.id , Apttus_Config2__ProductId__c=prod6.id,Apttus_Config2__LineType__c ='Product/Service',Apttus_Config2__LineStatus__c = 'New',Apttus_Config2__ChargeType__c = 'Subscription Fee',Apttus_Config2__ItemSequence__c = 1,Apttus_Config2__LineNumber__c = 1,Apttus_Config2__ListPrice__c = 100,Apttus_Config2__NetAdjustmentPercent__c = -50,Apttus_Config2__NetPrice__c = 50,Apttus_Config2__NetUnitPrice__c = 50,Apttus_Config2__AdjustedPrice__c = 50,Apttus_Config2__AdjustmentAmount__c = 50,Apttus_Config2__AdjustmentType__c = '% Discount',Apttus_Config2__AddedBy__c = 'User',CurrencyIsoCode = 'USD');
        Apttus_Config2__LineItem__c lineItem7=new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c=prodConf.id , Apttus_Config2__ProductId__c=prod7.id,Apttus_Config2__LineType__c ='Product/Service',Apttus_Config2__LineStatus__c = 'New',Apttus_Config2__ChargeType__c = 'Subscription Fee',Apttus_Config2__ItemSequence__c = 1,Apttus_Config2__LineNumber__c = 1,Apttus_Config2__ListPrice__c = 100,Apttus_Config2__NetAdjustmentPercent__c = -50,Apttus_Config2__NetPrice__c = 50,Apttus_Config2__NetUnitPrice__c = 50,Apttus_Config2__AdjustedPrice__c = 50,Apttus_Config2__AdjustmentAmount__c = 50,Apttus_Config2__AdjustmentType__c = '% Discount',Apttus_Config2__AddedBy__c = 'User',CurrencyIsoCode = 'USD');
        Apttus_Config2__LineItem__c lineItem8=new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c=prodConf.id , Apttus_Config2__ProductId__c=prod8.id,Apttus_Config2__LineType__c ='Product/Service',Apttus_Config2__LineStatus__c ='New',Apttus_Config2__ChargeType__c = 'Subscription Fee',Apttus_Config2__ItemSequence__c = 1,Apttus_Config2__LineNumber__c = 1,Apttus_Config2__ListPrice__c = 100,Apttus_Config2__NetAdjustmentPercent__c = -50,Apttus_Config2__NetPrice__c = 50,Apttus_Config2__NetUnitPrice__c = 50,Apttus_Config2__AdjustedPrice__c = 50,Apttus_Config2__AdjustmentAmount__c = 50,Apttus_Config2__AdjustmentType__c = '% Discount',Apttus_Config2__AddedBy__c = 'User',CurrencyIsoCode = 'USD');
        Apttus_Config2__LineItem__c lineItem9=new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c=prodConf.id , Apttus_Config2__ProductId__c=prod9.id,Apttus_Config2__LineType__c ='Product/Service',Apttus_Config2__LineStatus__c = 'New',Apttus_Config2__ChargeType__c = 'Subscription Fee',Apttus_Config2__ItemSequence__c = 1,Apttus_Config2__LineNumber__c = 1,Apttus_Config2__ListPrice__c = 100,Apttus_Config2__NetAdjustmentPercent__c = -50,Apttus_Config2__NetPrice__c = 50,Apttus_Config2__NetUnitPrice__c = 50,Apttus_Config2__AdjustedPrice__c = 50,Apttus_Config2__AdjustmentAmount__c = 50,Apttus_Config2__AdjustmentType__c = '% Discount',Apttus_Config2__AddedBy__c = 'User',CurrencyIsoCode = 'USD');
        Apttus_Config2__LineItem__c lineItem10=new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c=prodConf.id , Apttus_Config2__ProductId__c=prod10.id,Apttus_Config2__LineType__c ='Product/Service',Apttus_Config2__LineStatus__c = 'New',Apttus_Config2__ChargeType__c = 'Subscription Fee',Apttus_Config2__ItemSequence__c = 1,Apttus_Config2__LineNumber__c = 1,Apttus_Config2__ListPrice__c = 100,Apttus_Config2__NetAdjustmentPercent__c = -50,Apttus_Config2__NetPrice__c = 50,Apttus_Config2__NetUnitPrice__c = 50,Apttus_Config2__AdjustedPrice__c = 50,Apttus_Config2__AdjustmentAmount__c = 50,Apttus_Config2__AdjustmentType__c = '% Discount',Apttus_Config2__AddedBy__c = 'User',CurrencyIsoCode = 'USD');
        insertList.add(lineItem1);
        insertList.add(lineItem2);
        insertList.add(lineItem3);
        insertList.add(lineItem4);
        insertList.add(lineItem5);
        insertList.add(lineItem6);
        insertList.add(lineItem7);
        insertList.add(lineItem8);
        insertList.add(lineItem9);
        insertList.add(lineItem10);
        insert insertList;
        
        Apttus_Config2__AssetLineItem__c asset=new Apttus_Config2__AssetLineItem__c(Apttus_Config2__ProductId__c=prod1.id,Apttus_Config2__Quantity__c=5,Apttus_Config2__AssetStatus__c ='Activated',Apttus_Config2__LineType__c  ='Product/Service',Apttus_QPConfig__ProposalId__c =p.id);
        insert asset;
        
        List<Apttus_Config2__AssetAttributeValue__c> attributesList=new List<Apttus_Config2__AssetAttributeValue__c>();
        Apttus_Config2__AssetAttributeValue__c attribute1=new Apttus_Config2__AssetAttributeValue__c(APTS_PPC_Type__c='New PPC',APTS_PPC_Language_Selection__c='English', APTS_PPC_Website_Selection__c='LawInfo',Apttus_Config2__AssetLineItemId__c=asset.id);
        Apttus_Config2__AssetAttributeValue__c attribute2=new Apttus_Config2__AssetAttributeValue__c(APTS_PPC_Type__c='New PPC',APTS_PPC_Language_Selection__c='Español', APTS_PPC_Website_Selection__c='LawInfo',Apttus_Config2__AssetLineItemId__c=asset.id);
        attributesList.add(attribute1);
        attributesList.add(attribute2);
        insert attributesList;
        
        List<Apttus_Config2__AssetLineItem__c> assetLinesList = New List<Apttus_Config2__AssetLineItem__c>();
        Apttus_Config2__AssetLineItem__c asset1=new Apttus_Config2__AssetLineItem__c(Apttus_Config2__ProductId__c=prod1.id,Apttus_Config2__Quantity__c=5,Apttus_Config2__AssetStatus__c ='Activated',Apttus_Config2__LineType__c  ='Product/Service',APTS_SSD_ship_to__c=accountSSD.id,Apttus_Config2__AttributeValueId__c=attribute1.id,Apttus_QPConfig__ProposalId__c =p.id);
        Apttus_Config2__AssetLineItem__c asset2=new Apttus_Config2__AssetLineItem__c(Apttus_Config2__ProductId__c=prod2.id,Apttus_Config2__Quantity__c=5,Apttus_Config2__AssetStatus__c ='Activated',Apttus_Config2__LineType__c  ='Product/Service',APTS_SSD_ship_to__c=accountSSD.id,Apttus_Config2__AttributeValueId__c=attribute1.id,Apttus_QPConfig__ProposalId__c =p.id);
        Apttus_Config2__AssetLineItem__c asset3=new Apttus_Config2__AssetLineItem__c(Apttus_Config2__ProductId__c=prod3.id,Apttus_Config2__Quantity__c=5,Apttus_Config2__AssetStatus__c ='Activated',Apttus_Config2__LineType__c  ='Product/Service',APTS_SSD_ship_to__c=accountSSD.id,Apttus_Config2__AttributeValueId__c=attribute1.id,Apttus_QPConfig__ProposalId__c =p.id);
        Apttus_Config2__AssetLineItem__c asset4=new Apttus_Config2__AssetLineItem__c(Apttus_Config2__ProductId__c=prod4.id,Apttus_Config2__Quantity__c=5,Apttus_Config2__AssetStatus__c ='Activated',Apttus_Config2__LineType__c  ='Product/Service',APTS_SSD_ship_to__c=accountSSD.id,Apttus_Config2__AttributeValueId__c=attribute1.id,Apttus_QPConfig__ProposalId__c =p.id);
        Apttus_Config2__AssetLineItem__c asset5=new Apttus_Config2__AssetLineItem__c(Apttus_Config2__ProductId__c=prod5.id,Apttus_Config2__Quantity__c=5,Apttus_Config2__AssetStatus__c ='Activated',Apttus_Config2__LineType__c  ='Product/Service',APTS_SSD_ship_to__c=accountSSD.id,Apttus_Config2__AttributeValueId__c=attribute1.id,Apttus_QPConfig__ProposalId__c =p.id);
        Apttus_Config2__AssetLineItem__c asset6=new Apttus_Config2__AssetLineItem__c(Apttus_Config2__ProductId__c=prod6.id,Apttus_Config2__Quantity__c=5,Apttus_Config2__AssetStatus__c ='Activated',Apttus_Config2__LineType__c  ='Product/Service',APTS_SSD_ship_to__c=accountSSD.id,Apttus_Config2__AttributeValueId__c=attribute2.id,Apttus_QPConfig__ProposalId__c =p.id);
        Apttus_Config2__AssetLineItem__c asset7=new Apttus_Config2__AssetLineItem__c(Apttus_Config2__ProductId__c=prod7.id,Apttus_Config2__Quantity__c=5,Apttus_Config2__AssetStatus__c ='Activated',Apttus_Config2__LineType__c  ='Product/Service',APTS_SSD_ship_to__c=accountSSD.id,Apttus_Config2__AttributeValueId__c=attribute2.id,Apttus_QPConfig__ProposalId__c =p.id);
        Apttus_Config2__AssetLineItem__c asset8=new Apttus_Config2__AssetLineItem__c(Apttus_Config2__ProductId__c=prod8.id,Apttus_Config2__Quantity__c=5,Apttus_Config2__AssetStatus__c ='Activated',Apttus_Config2__LineType__c  ='Product/Service',APTS_SSD_ship_to__c=accountSSD.id,Apttus_Config2__AttributeValueId__c=attribute2.id,Apttus_QPConfig__ProposalId__c =p.id);
        Apttus_Config2__AssetLineItem__c asset9=new Apttus_Config2__AssetLineItem__c(Apttus_Config2__ProductId__c=prod9.id,Apttus_Config2__Quantity__c=5,Apttus_Config2__AssetStatus__c ='Activated',Apttus_Config2__LineType__c  ='Product/Service',APTS_SSD_ship_to__c=accountSSD.id,Apttus_Config2__AttributeValueId__c=attribute2.id,Apttus_QPConfig__ProposalId__c =p.id);
        Apttus_Config2__AssetLineItem__c asset10=new Apttus_Config2__AssetLineItem__c(Apttus_Config2__ProductId__c=prod10.id,Apttus_Config2__Quantity__c=5,Apttus_Config2__AssetStatus__c ='Activated',Apttus_Config2__LineType__c  ='Product/Service',APTS_SSD_ship_to__c=accountSSD.id,Apttus_Config2__AttributeValueId__c=attribute2.id,Apttus_QPConfig__ProposalId__c =p.id);
        assetLinesList.add(asset1);
        assetLinesList.add(asset2);
        assetLinesList.add(asset3);
        assetLinesList.add(asset4);
        assetLinesList.add(asset5);
        assetLinesList.add(asset6);
        assetLinesList.add(asset7);
        assetLinesList.add(asset8);
        assetLinesList.add(asset9);
        assetLinesList.add(asset10);
        insert assetLinesList;
        
        test.startTest();     
        APTS_LineItemTriggerHelper.populateAllApprovalRequiredCB(insertList);       
        test.stopTest();       
        
    }
    
    static testMethod void mediumLawApprovalTest() {
        
       List<KeyValueListStore__c> keyvaluestoreList = new List<KeyValueListStore__c>();
        KeyValueListStore__c keyvaluestore=new  KeyValueListStore__c();
        keyvaluestore.Name='ANZUsersProfileId';
        keyvaluestore.TextValue__c=System.Label.APTS_OC_Test_Id;
        keyvaluestoreList.add(keyvaluestore); 
        KeyValueListStore__c keyval = new KeyValueListStore__c();
        keyval.Name='ReasonWithCompetitor';
        keyval.TextValue__c='Price';
        keyvaluestoreList.add(keyval);
        insert keyvaluestoreList;
        
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
        List<APTS_Segment_Threshold__c> segthrList= new List<APTS_Segment_Threshold__c>();
        //Add Segment threshold
        APTS_Segment_Threshold__c seg1 = new APTS_Segment_Threshold__c();
        seg1.APTS_Approval_Required__c=True;
        seg1.APTS_Segment__c='Medium Law';
        seg1.APTS_Customer_Category__c='5';
        seg1.APTS_Term_in_years__c=Integer.ValueOf('2');
        seg1.APTS_Minimum_OY_Increase__c=Integer.ValueOf('15');
        seg1.APTS_Promo_Codes__c = '13843012';        
        segthrList.add(seg1);
        
        APTS_Segment_Threshold__c seg2 = new APTS_Segment_Threshold__c();
        seg2.APTS_Approval_Required__c=True;
        seg2.APTS_Segment__c='Corporate';
        seg2.APTS_Customer_Category__c='5';
        seg2.APTS_Term_in_years__c=Integer.ValueOf('2');
        seg2.APTS_Minimum_OY_Increase__c=Integer.ValueOf('15');
        seg2.APTS_Promo_Codes__c = '13843012';        
        segthrList.add(seg2);     
        System.assertEquals(seg2.APTS_Promo_Codes__c, '13843012');   
        
        APTS_Segment_Threshold__c seg3 = new APTS_Segment_Threshold__c();
        seg3.APTS_Approval_Required__c=True;
        seg3.APTS_Segment__c='Medium Law';
        seg3.APTS_Customer_Category__c='5';
        seg3.APTS_Term_in_years__c=Integer.ValueOf('2');
        seg3.APTS_Minimum_OY_Increase__c=Integer.ValueOf('15');
        seg3.APTS_Promo_Codes__c = '13843013';
        seg3.APTS_Promo_Minimum_OY_Increase__c = 16;        
        segthrList.add(seg3);
        
        APTS_Segment_Threshold__c seg4 = new APTS_Segment_Threshold__c();
        seg4.APTS_Approval_Required__c=True;
        seg4.APTS_Segment__c='Medium Law';
        seg4.APTS_Customer_Category__c='5';
        seg4.APTS_Product_Family__c = System.Label.APTS_Proview_Product_Family_Value;
        seg4.APTS_Term_in_years__c=Integer.ValueOf('2');
        seg4.APTS_Minimum_OY_Increase__c=Integer.ValueOf('15');
        seg4.APTS_Promo_Codes__c = '13843012';        
        segthrList.add(seg4);
        
        APTS_Segment_Threshold__c seg5 = new APTS_Segment_Threshold__c();
        seg5.APTS_Approval_Required__c=True;
        seg5.APTS_Segment__c='Medium Law';
        seg5.APTS_Customer_Category__c='5';
        seg5.APTS_Product_Family__c = System.Label.APTS_Proview_Product_Family_Value;
        seg5.APTS_Term_in_years__c=Integer.ValueOf('2');
        seg5.APTS_Minimum_OY_Increase__c=Integer.ValueOf('15');
        seg5.APTS_Promo_Minimum_OY_Increase__c =Integer.ValueOf('15');
        seg5.APTS_Promo_Codes__c = '13843012';        
        segthrList.add(seg5);
        insert segthrList;                  
                
        Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
        Account a = new Account(RecordTypeId=accRecordTypeId,name='test-sg',sales_org__c='ABEP',customer_group__c='Academic',customer_type__c='Organization',customer_class_c__c='Academic Lecturer');
        a.APTS_Customer_Category__c = '5';
        a.Is_GLI__c = True;
        insert a;
        
        Schema.DescribeFieldResult fieldResultMarket = Apttus_Config2__ProductConfiguration__c.APTS_AccountMirror_Picklist__c.getDescribe();
        String valueMarket = fieldResultMarket.getPicklistValues().get(0).getValue();
        
        //Inserting SourceSystemDetail
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();
        Source_System_Detail__c accountSSD= new Source_System_Detail__c();
        accountSSD.RecordtypeId=ssdRecorType;
        accountSSD.Name='ABC';
        accountSSD.Source_System_Name__c='ABC';
        accountSSD.Account_Name__c=a.ID;
        accountSSD.APTS_Customer_Category__c='1';
        accountSSD.LCRM_Customer_Group__c='Academic';
        accountSSD.LCRM_Frozen_Market_Segment__c = valueMarket;
        accountSSD.Account_Inactive__c=false;
        accountSSD.LCRM_Sales_Org__c='WEST';
        insert accountSSD;
        
        Date todaysDate = system.today();
        Id oppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Pipeline Opportunity').getRecordTypeId();
        Opportunity o = new Opportunity(RecordTypeId=oppRecordTypeId,  Name='tst-opp', stagename='25%',closedate=todaysDate,forecastcategoryname='pipeline',accountId=a.id);
        insert o;
        
        Id devRecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Proposal').getRecordTypeId();
        Apttus_Proposal__Proposal__c p = new Apttus_Proposal__Proposal__c(RecordTypeId=devRecordTypeId, CurrencyIsoCode = 'USD',Apttus_Proposal__Account__c=a.id, Apttus_Proposal__Proposal_Name__c='TST-10', APTS_SSD_Sold_To__c=accountSSD.Id,APTS_SSD_ship_to__c=accountSSD.Id,APTS_SSD_bill_to__c=accountSSD.Id, Apttus_Proposal__Opportunity__c=o.id, Apttus_Proposal__Approval_Stage__c='Draft', Apttus_Proposal__Proposal_Category__c='Quote', Apttus_Proposal__ReadyToGenerate__c = true, Apttus_Proposal__ReadyToPresent__c= true);
        p.APTS_Approval_Segment__c = 'Medium Law';        
        insert p;
        
        Apttus_Config2__ProductConfiguration__c prodConf = new Apttus_Config2__ProductConfiguration__c(Name='prod-conf1', CurrencyIsoCode = 'USD', Apttus_QPConfig__Proposald__c=p.id, APTS_SSD_ship_to__c=accountSSD.Id,APTS_SSD_bill_to__c=accountSSD.Id);
        insert prodConf;               
        
        Product2 prod = new Product2(name='prod1', Media_High_Level__c='Online', CurrencyIsoCode = 'USD');
        insert prod;
        
        Product2 prod2 = new Product2(name='prod1', Media_High_Level__c='Online', CurrencyIsoCode = 'USD',Family='PRINT LEGAL SOLUTIONS', APTS_Approval_Always_Required__c=true, APTS_Cat_L2__c = System.Label.APTS_Print_Product_Family,APTS_CAT_L3__c='L3_L030_FP');
        insert prod2;
        
        Product2 prod3 = new Product2(name='prod1', Media_High_Level__c='Online', APTS_Approval_Always_Required__c=true,CurrencyIsoCode = 'USD',Family='PRINT LEGAL SOLUTIONS', APTS_Cat_L2__c = System.Label.APTS_Print_Product_Family,APTS_CAT_L3__c='L3_L030_FP');
        insert prod3;
        
        Apttus_Config2__ConfigSystemProperties__c configSetting=new Apttus_Config2__ConfigSystemProperties__c(Name='System Properties',Apttus_Config2__DisableConstraintRules__c=true);
        insert configSetting;
        List<Apttus_Config2__LineItem__c> insertList=new List<Apttus_Config2__LineItem__c>();
        List<Apttus_Config2__LineItem__c> updateList=new List<Apttus_Config2__LineItem__c>();
        
        test.startTest();
        Apttus_Config2__LineItem__c li3 = new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c=prodConf.id , Apttus_Config2__ProductId__c=prod.id);
        li3.Apttus_Config2__AddedBy__c = 'User';
        li3.Apttus_Config2__AdjustedPrice__c = 50;
        li3.Apttus_Config2__AdjustmentAmount__c = 50;
        li3.Apttus_Config2__AdjustmentType__c = '% Discount';
        li3.Apttus_Config2__AllocateGroupAdjustment__c = TRUE;
        li3.Apttus_Config2__AllowableAction__c = 'Unrestricted';
        li3.Apttus_Config2__AllowManualAdjustment__c = TRUE;
        li3.Apttus_Config2__AllowProration__c = FALSE;
        li3.Apttus_Config2__AllowRemoval__c = TRUE;
        li3.Apttus_Config2__AutoRenew__c = FALSE;
        li3.Apttus_Config2__BaseExtendedCost__c = 0;
        li3.Apttus_Config2__BaseExtendedPrice__c = 100;
        li3.Apttus_Config2__BasePrice__c = 100;
        li3.Apttus_Config2__BasePriceMethod__c = 'Per Unit';
        li3.Apttus_Config2__BillingFrequency__c = 'Monthly';
        li3.Apttus_Config2__ChargeType__c = 'Subscription Fee';
        li3.Apttus_Config2__ConfigStatus__c = 'Complete';
        li3.Apttus_Config2__ConstraintCheckStatus__c = 'NA';
        li3.Apttus_Config2__Customizable__c = FALSE;
        li3.Apttus_Config2__DeltaPrice__c = 50;
        li3.Apttus_Config2__DeltaQuantity__c = 1;
        li3.Apttus_Config2__Description__c = 'Westlaw Flex Plan $100/500';
        li3.Apttus_Config2__ExtendedCost__c = 0;
        li3.Apttus_Config2__ExtendedPrice__c = 100;
        li3.Apttus_Config2__Frequency__c = 'Monthly';
        li3.Apttus_Config2__Guidance__c = 'Red';
        li3.Apttus_Config2__HasAttributes__c = FALSE;
        li3.Apttus_Config2__HasBaseProduct__c = FALSE;
        li3.Apttus_Config2__HasDefaults__c = FALSE;
        li3.Apttus_Config2__HasIncentives__c = FALSE;
        li3.Apttus_Config2__HasOptions__c = FALSE;
        li3.Apttus_Config2__HasTieredPrice__c = FALSE;
        li3.Apttus_Config2__HideCopyAction__c = FALSE;
        li3.Apttus_Config2__HideInvoiceDisplay__c = FALSE;
        li3.Apttus_Config2__IsAssetPricing__c = FALSE;
        li3.Apttus_Config2__IsCustomPricing__c = FALSE;
        li3.Apttus_Config2__IsHidden__c = FALSE;
        li3.Apttus_Config2__IsOptionRollupLine__c = FALSE;
        li3.Apttus_Config2__IsPrimaryLine__c = TRUE;
        li3.Apttus_Config2__IsPrimaryRampLine__c = FALSE;
        li3.Apttus_Config2__IsQuantityModifiable__c = FALSE;
        li3.Apttus_Config2__IsReadOnly__c = FALSE;
        li3.Apttus_Config2__IsSellingTermReadOnly__c = FALSE;
        li3.Apttus_Config2__IsUsageTierModifiable__c = FALSE;
        li3.Apttus_Config2__ItemSequence__c = 1;
        li3.Apttus_Config2__LineNumber__c = 1;
        li3.Apttus_Config2__LineSequence__c = 1;
        li3.Apttus_Config2__LineStatus__c = 'Renewed';
        li3.Apttus_Config2__LineType__c = 'Product/Service';
        li3.Apttus_Config2__ListPrice__c = 100;
        li3.Apttus_Config2__NetAdjustmentPercent__c = -50;
        li3.Apttus_Config2__NetPrice__c = 50;
        li3.Apttus_Config2__NetUnitPrice__c = 50;
        li3.Apttus_Config2__OptionSequence__c = 0;
        li3.Apttus_Config2__PriceIncludedInBundle__c = FALSE;
        li3.Apttus_Config2__PriceMethod__c = 'Per Unit';
        li3.Apttus_Config2__PriceType__c = 'Recurring';
        li3.Apttus_Config2__PriceUom__c = 'Each';
        li3.Apttus_Config2__PricingStatus__c = 'Complete';
        li3.Apttus_Config2__PrimaryLineNumber__c = 1;
        li3.Apttus_Config2__ProductVersion__c = 1;
        li3.Apttus_Config2__Quantity__c = 1;
        li3.Apttus_Config2__RollupPriceToBundle__c = TRUE;
        li3.Apttus_Config2__SellingFrequency__c = 'Monthly';
        li3.Apttus_Config2__SellingTerm__c = 1;
        li3.Apttus_Config2__SyncStatus__c = 'Pending';
        li3.Apttus_Config2__Taxable__c = FALSE;
        li3.Apttus_Config2__TaxInclusive__c = FALSE;
        li3.Apttus_Config2__Term__c = 1;
        li3.Apttus_Config2__TotalQuantity__c = 1;
        li3.Apttus_Config2__Uom__c = 'Each';
        li3.Apttus_CQApprov__Approval_Status__c = 'Pending Approval';
        li3.CurrencyIsoCode = 'USD';
        li3.APTS_Product_Family__c = 'Non-Clear';
        li3.APTS_Contract_Term__c = '2 Years';
        li3.APTS_Years_2_Plus_Adjustment__c = '5';        
        
        insertList.add(li3);
        
        
        Apttus_Config2__ConfigSystemProperties__c configSetting2 = [SELECT Id, Name, Apttus_Config2__DisableConstraintRules__c FROM Apttus_Config2__ConfigSystemProperties__c WHERE Name = 'System Properties'];
        configSetting2.Apttus_Config2__DisableConstraintRules__c = True;
        update configSetting2;
        // test.startTest();
        Apttus_Config2__LineItem__c li4 = new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c=prodConf.id , Apttus_Config2__ProductId__c=prod2.id);
        li4.Apttus_Config2__AddedBy__c = 'User';
        li4.Apttus_Config2__AdjustedPrice__c = 50;
        li4.Apttus_Config2__AdjustmentAmount__c = 50;
        li4.Apttus_Config2__AdjustmentType__c = '% Discount';
        li4.Apttus_Config2__AllocateGroupAdjustment__c = TRUE;
        li4.Apttus_Config2__AllowableAction__c = 'Unrestricted';
        li4.Apttus_Config2__AllowManualAdjustment__c = TRUE;
        li4.Apttus_Config2__AllowProration__c = FALSE;
        li4.Apttus_Config2__AllowRemoval__c = TRUE;
        li4.Apttus_Config2__AutoRenew__c = FALSE;
        li4.Apttus_Config2__BaseExtendedCost__c = 0;
        li4.Apttus_Config2__BaseExtendedPrice__c = 100;
        li4.Apttus_Config2__BasePrice__c = 100;
        li4.Apttus_Config2__BasePriceMethod__c = 'Per Unit';
        li4.Apttus_Config2__BillingFrequency__c = 'Monthly';
        li4.Apttus_Config2__ChargeType__c = 'Subscription Fee';
        li4.Apttus_Config2__ConfigStatus__c = 'Complete';
        li4.Apttus_Config2__ConstraintCheckStatus__c = 'NA';
        li4.Apttus_Config2__Customizable__c = FALSE;
        li4.Apttus_Config2__DeltaPrice__c = 50;
        li4.Apttus_Config2__DeltaQuantity__c = 1;
        li4.Apttus_Config2__Description__c = 'Westlaw Flex Plan $100/500';
        li4.Apttus_Config2__ExtendedCost__c = 0;
        li4.Apttus_Config2__ExtendedPrice__c = 100;
        li4.Apttus_Config2__Frequency__c = 'Monthly';
        li4.Apttus_Config2__Guidance__c = 'Red';
        li4.Apttus_Config2__HasAttributes__c = FALSE;
        li4.Apttus_Config2__HasBaseProduct__c = FALSE;
        li4.Apttus_Config2__HasDefaults__c = FALSE;
        li4.Apttus_Config2__HasIncentives__c = FALSE;
        li4.Apttus_Config2__HasOptions__c = FALSE;
        li4.Apttus_Config2__HasTieredPrice__c = FALSE;
        li4.Apttus_Config2__HideCopyAction__c = FALSE;
        li4.Apttus_Config2__HideInvoiceDisplay__c = FALSE;
        li4.Apttus_Config2__IsAssetPricing__c = FALSE;
        li4.Apttus_Config2__IsCustomPricing__c = FALSE;
        li4.Apttus_Config2__IsHidden__c = FALSE;
        li4.Apttus_Config2__IsOptionRollupLine__c = FALSE;
        li4.Apttus_Config2__IsPrimaryLine__c = TRUE;
        li4.Apttus_Config2__IsPrimaryRampLine__c = FALSE;
        li4.Apttus_Config2__IsQuantityModifiable__c = FALSE;
        li4.Apttus_Config2__IsReadOnly__c = FALSE;
        li4.Apttus_Config2__IsSellingTermReadOnly__c = FALSE;
        li4.Apttus_Config2__IsUsageTierModifiable__c = FALSE;
        li4.Apttus_Config2__ItemSequence__c = 1;
        li4.Apttus_Config2__LineNumber__c = 1;
        li4.Apttus_Config2__LineSequence__c = 1;
        li4.Apttus_Config2__LineStatus__c = 'Renewed';
        li4.Apttus_Config2__LineType__c = 'Product/Service';
        li4.Apttus_Config2__ListPrice__c = 100;
        li4.Apttus_Config2__NetAdjustmentPercent__c = -50;
        li4.Apttus_Config2__NetPrice__c = 50;
        li4.Apttus_Config2__NetUnitPrice__c = 50;
        li4.Apttus_Config2__OptionSequence__c = 0;
        li4.Apttus_Config2__PriceIncludedInBundle__c = FALSE;
        li4.Apttus_Config2__PriceMethod__c = 'Per Unit';
        li4.Apttus_Config2__PriceType__c = 'Recurring';
        li4.Apttus_Config2__PriceUom__c = 'Each';
        li4.Apttus_Config2__PricingStatus__c = 'Complete';
        li4.Apttus_Config2__PrimaryLineNumber__c = 1;
        li4.Apttus_Config2__ProductVersion__c = 1;
        li4.Apttus_Config2__Quantity__c = 1;
        li4.Apttus_Config2__RollupPriceToBundle__c = TRUE;
        li4.Apttus_Config2__SellingFrequency__c = 'Monthly';
        li4.Apttus_Config2__SellingTerm__c = 1;
        li4.Apttus_Config2__SyncStatus__c = 'Pending';
        li4.Apttus_Config2__Taxable__c = FALSE;
        li4.Apttus_Config2__TaxInclusive__c = FALSE;
        li4.Apttus_Config2__Term__c = 1;
        li4.Apttus_Config2__TotalQuantity__c = 1;
        li4.Apttus_Config2__Uom__c = 'Each';
        li4.Apttus_CQApprov__Approval_Status__c = 'Pending Approval';
        li4.CurrencyIsoCode = 'USD';
        li4.APTS_Product_Family__c = 'Non-Clear';
        li4.APTS_Contract_Term__c = '2 Years';
        li4.APTS_Years_2_Plus_Adjustment__c = '5';
        
        insertList.add(li4);
        insert insertList;
        li4.Apttus_Config2__IncentiveCode__c = '13843013';
        updateList.add(li4);
        li3.APTS_Bridge__c='1 Month';
        li3.APTS_Contract_Term__c='Short Term Trial';
        updateList.add(li3);
        update updateList;
        APTS_LineItemTriggerHelper.populateAllApprovalRequiredCB(updateList);
        
                
        Test.stopTest();        
    } 

    static testMethod void promotions (){
    WebServiceSettings__c oWebServiceSettings = new WebServiceSettings__c(
        Active__c = true,
        Name = 'Payment AutoCharge',
        Service_Unavailable_Message__c = 'Auto Payment Service is Currently unavailable',        
        Endpoint__c = 'https://stg.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentAutoCharge');
    insert oWebServiceSettings ;
    
    WebServiceSettings__c o1WebServiceSettings = new WebServiceSettings__c(
        Active__c = true,
        Name = 'PaymentCreditIncrease',
        Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable',        
        Endpoint__c = 'https://qa.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease');
    insert o1WebServiceSettings ;

    List<KeyValueListStore__c> keyvaluestoreList = new List<KeyValueListStore__c>();
        KeyValueListStore__c keyvaluestore=new  KeyValueListStore__c();
        keyvaluestore.Name='ANZUsersProfileId';
        keyvaluestore.TextValue__c=System.Label.APTS_OC_Test_Id;
        keyvaluestoreList.add(keyvaluestore); 
        KeyValueListStore__c keyval = new KeyValueListStore__c();
        keyval.Name='ReasonWithCompetitor';
        keyval.TextValue__c='Price';
        keyvaluestoreList.add(keyval);
        insert keyvaluestoreList;
        
    //Inserting recordLists
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
    
    Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
    Account a = new Account(RecordTypeId=accRecordTypeId,name='test-sg',sales_org__c='ABEP',customer_group__c='Academic',customer_type__c='Organization',customer_class_c__c='Academic Lecturer');
    a.APTS_Customer_Category__c = '5';
    a.Is_GLI__c = True;
    insert a;        
        
    Schema.DescribeFieldResult fieldResultMarket = Apttus_Config2__ProductConfiguration__c.APTS_AccountMirror_Picklist__c.getDescribe();
    String valueMarket = fieldResultMarket.getPicklistValues().get(0).getValue();
    
    //Inserting SourceSystemDetail
    Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();
    Source_System_Detail__c accountSSD= new Source_System_Detail__c();
    accountSSD.RecordtypeId=ssdRecorType;
    accountSSD.Name='ABC';
    accountSSD.Source_System_Name__c='ABC';
    accountSSD.Account_Name__c=a.ID;
    accountSSD.APTS_Customer_Category__c='1';
    accountSSD.LCRM_Customer_Group__c='Academic';
    accountSSD.LCRM_Frozen_Market_Segment__c = valueMarket;
    accountSSD.Account_Inactive__c=false;
    accountSSD.LCRM_Sales_Org__c='WEST';
    accountSSD.LCRM_FL_Annual_Spend__c=100;
    insert accountSSD;
        
    Date todaysDate = system.today();
    Id oppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Pipeline Opportunity').getRecordTypeId();
    Opportunity o = new Opportunity(RecordTypeId=oppRecordTypeId,  Name='tst-opp', stagename='25%',closedate=todaysDate,forecastcategoryname='pipeline',accountId=a.id);
    insert o;
    
    Id devRecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Proposal').getRecordTypeId();
    Apttus_Proposal__Proposal__c p = new Apttus_Proposal__Proposal__c(RecordTypeId=devRecordTypeId, CurrencyIsoCode = 'USD', Apttus_Proposal__Account__c=a.id,Apttus_Proposal__Proposal_Name__c='TST-10',  Apttus_Proposal__Opportunity__c=o.id, Apttus_Proposal__Approval_Stage__c='Draft', Apttus_Proposal__Proposal_Category__c='Quote', Apttus_Proposal__ReadyToGenerate__c = true, Apttus_Proposal__ReadyToPresent__c= true,APTS_SSD_Sold_To__c=accountSSD.Id,APTS_SSD_ship_to__c=accountSSD.Id,APTS_SSD_bill_to__c=accountSSD.Id);
    p.APTS_Approval_Segment__c ='Small Law';
    insert p;
    
    Apttus_Config2__ProductConfiguration__c prodConf = new Apttus_Config2__ProductConfiguration__c(Name='prod-conf1', CurrencyIsoCode = 'USD', Apttus_QPConfig__Proposald__c=p.id, APTS_SSD_ship_to__c=accountSSD.Id,APTS_SSD_bill_to__c=accountSSD.Id);
    insert prodConf;
    
    List<Product2> productList=new List<Product2>();
    Product2 prod1 = new Product2(name='prod1', Media_High_Level__c='Online', CurrencyIsoCode = 'USD',ProductCode = '40483699');
    Product2 prod2 = new Product2(name='prod2', Media_High_Level__c='Online', CurrencyIsoCode = 'USD',ProductCode='40485592');
    Product2 prod3 = new Product2(name='prod3', Media_High_Level__c='Online', CurrencyIsoCode = 'USD',ProductCode='40483696');
    Product2 prod4 = new Product2(name='prod4', Media_High_Level__c='Online', CurrencyIsoCode = 'USD',ProductCode='40483693');
    Product2 prod5 = new Product2(name='prod5', Media_High_Level__c='Online', CurrencyIsoCode = 'USD',ProductCode='41915678');
    Product2 prod6 = new Product2(name='prod6', Media_High_Level__c='Online', CurrencyIsoCode = 'USD',ProductCode='41892830');
    Product2 prod7 = new Product2(name='prod7', Media_High_Level__c='Online', CurrencyIsoCode = 'USD',ProductCode='41767150');
    Product2 prod8 = new Product2(name='prod8', Media_High_Level__c='Online', CurrencyIsoCode = 'USD',ProductCode='42124052');
    Product2 prod9 = new Product2(name='prod9', Media_High_Level__c='Online', CurrencyIsoCode = 'USD',ProductCode='41822784');
    Product2 prod10 = new Product2(name='prod10', Media_High_Level__c='Online', CurrencyIsoCode = 'USD',ProductCode='41777796');
    productList.add(prod1);
    productList.add(prod2);
    productList.add(prod3);
    productList.add(prod4);
    productList.add(prod5);
    productList.add(prod6);
    productList.add(prod7);
    productList.add(prod8);
    productList.add(prod9);
    productList.add(prod10);
    insert productList;
    system.assertEquals(prod10.Name, 'prod10');
    
    List<Apttus_Config2__LineItem__c> insertList=new List<Apttus_Config2__LineItem__c>();
    List<Apttus_Config2__LineItem__c> updateList=new List<Apttus_Config2__LineItem__c>();
    
    Apttus_Config2__LineItem__c lineItem1=new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c=prodConf.id , Apttus_Config2__ProductId__c=prod1.id,Apttus_Config2__LineType__c ='Product/Service',Apttus_Config2__LineStatus__c = 'New',Apttus_Config2__ChargeType__c = 'Subscription Fee',Apttus_Config2__ItemSequence__c = 1,Apttus_Config2__LineNumber__c = 1,Apttus_Config2__ListPrice__c = 100,Apttus_Config2__NetAdjustmentPercent__c = -50,Apttus_Config2__NetPrice__c = 50,Apttus_Config2__NetUnitPrice__c = 50,Apttus_Config2__AdjustedPrice__c = 50,Apttus_Config2__AdjustmentAmount__c = 50,Apttus_Config2__AdjustmentType__c = '% Discount',Apttus_Config2__AddedBy__c = 'User',CurrencyIsoCode = 'USD' ,APTS_Bridge__c  ='1 Month',APTS_Years_2_Plus_Adjustment__c='6');
    Apttus_Config2__LineItem__c lineItem2=new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c=prodConf.id , Apttus_Config2__ProductId__c=prod2.id,Apttus_Config2__LineType__c ='Product/Service',Apttus_Config2__LineStatus__c = 'New',Apttus_Config2__ChargeType__c = 'Subscription Fee',Apttus_Config2__ItemSequence__c = 1,Apttus_Config2__LineNumber__c = 1,Apttus_Config2__ListPrice__c = 100,Apttus_Config2__NetAdjustmentPercent__c = -50,Apttus_Config2__NetPrice__c = 50,Apttus_Config2__NetUnitPrice__c = 50,Apttus_Config2__AdjustedPrice__c = 50,Apttus_Config2__AdjustmentAmount__c = 50,Apttus_Config2__AdjustmentType__c = '% Discount',Apttus_Config2__AddedBy__c = 'User',CurrencyIsoCode = 'USD',APTS_Bridge__c  ='3 Months');
    Apttus_Config2__LineItem__c lineItem3=new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c=prodConf.id , Apttus_Config2__ProductId__c=prod3.id,Apttus_Config2__LineType__c ='Product/Service',Apttus_Config2__LineStatus__c = 'New',Apttus_Config2__ChargeType__c = 'Subscription Fee',Apttus_Config2__ItemSequence__c = 1,Apttus_Config2__LineNumber__c = 1,Apttus_Config2__ListPrice__c = 100,Apttus_Config2__NetAdjustmentPercent__c = -50,Apttus_Config2__NetPrice__c = 50,Apttus_Config2__NetUnitPrice__c = 50,Apttus_Config2__AdjustedPrice__c = 50,Apttus_Config2__AdjustmentAmount__c = 50,Apttus_Config2__AdjustmentType__c = '% Discount',Apttus_Config2__AddedBy__c = 'User',CurrencyIsoCode = 'USD');
    Apttus_Config2__LineItem__c lineItem4=new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c=prodConf.id , Apttus_Config2__ProductId__c=prod4.id,Apttus_Config2__LineType__c ='Product/Service',Apttus_Config2__LineStatus__c = 'New',Apttus_Config2__ChargeType__c = 'Subscription Fee',Apttus_Config2__ItemSequence__c = 1,Apttus_Config2__LineNumber__c = 1,Apttus_Config2__ListPrice__c = 100,Apttus_Config2__NetAdjustmentPercent__c = -50,Apttus_Config2__NetPrice__c = 50,Apttus_Config2__NetUnitPrice__c = 50,Apttus_Config2__AdjustedPrice__c = 50,Apttus_Config2__AdjustmentAmount__c = 50,Apttus_Config2__AdjustmentType__c = '% Discount',Apttus_Config2__AddedBy__c = 'User',CurrencyIsoCode = 'USD');
    Apttus_Config2__LineItem__c lineItem5=new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c=prodConf.id , Apttus_Config2__ProductId__c=prod5.id,Apttus_Config2__LineType__c ='Product/Service',Apttus_Config2__LineStatus__c = 'New',Apttus_Config2__ChargeType__c = 'Subscription Fee',Apttus_Config2__ItemSequence__c = 1,Apttus_Config2__LineNumber__c = 1,Apttus_Config2__ListPrice__c = 100,Apttus_Config2__NetAdjustmentPercent__c = -50,Apttus_Config2__NetPrice__c = 50,Apttus_Config2__NetUnitPrice__c = 50,Apttus_Config2__AdjustedPrice__c = 50,Apttus_Config2__AdjustmentAmount__c = 50,Apttus_Config2__AdjustmentType__c = '% Discount',Apttus_Config2__AddedBy__c = 'User',CurrencyIsoCode = 'USD');
    Apttus_Config2__LineItem__c lineItem6=new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c=prodConf.id , Apttus_Config2__ProductId__c=prod6.id,Apttus_Config2__LineType__c ='Product/Service',Apttus_Config2__LineStatus__c = 'New',Apttus_Config2__ChargeType__c = 'Subscription Fee',Apttus_Config2__ItemSequence__c = 1,Apttus_Config2__LineNumber__c = 1,Apttus_Config2__ListPrice__c = 100,Apttus_Config2__NetAdjustmentPercent__c = -50,Apttus_Config2__NetPrice__c = 50,Apttus_Config2__NetUnitPrice__c = 50,Apttus_Config2__AdjustedPrice__c = 50,Apttus_Config2__AdjustmentAmount__c = 50,Apttus_Config2__AdjustmentType__c = '% Discount',Apttus_Config2__AddedBy__c = 'User',CurrencyIsoCode = 'USD');
    Apttus_Config2__LineItem__c lineItem7=new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c=prodConf.id , Apttus_Config2__ProductId__c=prod7.id,Apttus_Config2__LineType__c ='Product/Service',Apttus_Config2__LineStatus__c = 'New',Apttus_Config2__ChargeType__c = 'Subscription Fee',Apttus_Config2__ItemSequence__c = 1,Apttus_Config2__LineNumber__c = 1,Apttus_Config2__ListPrice__c = 100,Apttus_Config2__NetAdjustmentPercent__c = -50,Apttus_Config2__NetPrice__c = 50,Apttus_Config2__NetUnitPrice__c = 50,Apttus_Config2__AdjustedPrice__c = 50,Apttus_Config2__AdjustmentAmount__c = 50,Apttus_Config2__AdjustmentType__c = '% Discount',Apttus_Config2__AddedBy__c = 'User',CurrencyIsoCode = 'USD');
    Apttus_Config2__LineItem__c lineItem8=new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c=prodConf.id , Apttus_Config2__ProductId__c=prod8.id,Apttus_Config2__LineType__c ='Product/Service',Apttus_Config2__LineStatus__c ='New',Apttus_Config2__ChargeType__c = 'Subscription Fee',Apttus_Config2__ItemSequence__c = 1,Apttus_Config2__LineNumber__c = 1,Apttus_Config2__ListPrice__c = 100,Apttus_Config2__NetAdjustmentPercent__c = -50,Apttus_Config2__NetPrice__c = 50,Apttus_Config2__NetUnitPrice__c = 50,Apttus_Config2__AdjustedPrice__c = 50,Apttus_Config2__AdjustmentAmount__c = 50,Apttus_Config2__AdjustmentType__c = '% Discount',Apttus_Config2__AddedBy__c = 'User',CurrencyIsoCode = 'USD');
    Apttus_Config2__LineItem__c lineItem9=new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c=prodConf.id , Apttus_Config2__ProductId__c=prod9.id,Apttus_Config2__LineType__c ='Product/Service',Apttus_Config2__LineStatus__c = 'New',Apttus_Config2__ChargeType__c = 'Subscription Fee',Apttus_Config2__ItemSequence__c = 1,Apttus_Config2__LineNumber__c = 1,Apttus_Config2__ListPrice__c = 100,Apttus_Config2__NetAdjustmentPercent__c = -50,Apttus_Config2__NetPrice__c = 50,Apttus_Config2__NetUnitPrice__c = 50,Apttus_Config2__AdjustedPrice__c = 50,Apttus_Config2__AdjustmentAmount__c = 50,Apttus_Config2__AdjustmentType__c = '% Discount',Apttus_Config2__AddedBy__c = 'User',CurrencyIsoCode = 'USD');
    Apttus_Config2__LineItem__c lineItem10=new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c=prodConf.id , Apttus_Config2__ProductId__c=prod10.id,Apttus_Config2__LineType__c ='Product/Service',Apttus_Config2__LineStatus__c = 'New',Apttus_Config2__ChargeType__c = 'Subscription Fee',Apttus_Config2__ItemSequence__c = 1,Apttus_Config2__LineNumber__c = 1,Apttus_Config2__ListPrice__c = 100,Apttus_Config2__NetAdjustmentPercent__c = -50,Apttus_Config2__NetPrice__c = 50,Apttus_Config2__NetUnitPrice__c = 50,Apttus_Config2__AdjustedPrice__c = 50,Apttus_Config2__AdjustmentAmount__c = 50,Apttus_Config2__AdjustmentType__c = '% Discount',Apttus_Config2__AddedBy__c = 'User',CurrencyIsoCode = 'USD');
    insertList.add(lineItem1);
    insertList.add(lineItem2);
    insertList.add(lineItem3);
    insertList.add(lineItem4);
    insertList.add(lineItem5);
    insertList.add(lineItem6);
    insertList.add(lineItem7);
    insertList.add(lineItem8);
    insertList.add(lineItem9);
    insertList.add(lineItem10);
    insert insertList;
    
    Apttus_Config2__AssetLineItem__c asset=new Apttus_Config2__AssetLineItem__c(Apttus_Config2__ProductId__c=prod1.id,Apttus_Config2__Quantity__c=5,Apttus_Config2__AssetStatus__c ='Activated',Apttus_Config2__LineType__c  ='Product/Service',Apttus_QPConfig__ProposalId__c =p.id);
    insert asset;
    
    List<Apttus_Config2__AssetAttributeValue__c> attributesList=new List<Apttus_Config2__AssetAttributeValue__c>();
    Apttus_Config2__AssetAttributeValue__c attribute1=new Apttus_Config2__AssetAttributeValue__c(APTS_PPC_Type__c='New PPC',APTS_PPC_Language_Selection__c='English', APTS_PPC_Website_Selection__c='LawInfo',Apttus_Config2__AssetLineItemId__c=asset.id);
    Apttus_Config2__AssetAttributeValue__c attribute2=new Apttus_Config2__AssetAttributeValue__c(APTS_PPC_Type__c='New PPC',APTS_PPC_Language_Selection__c='Español', APTS_PPC_Website_Selection__c='LawInfo',Apttus_Config2__AssetLineItemId__c=asset.id);
    attributesList.add(attribute1);
    attributesList.add(attribute2);
    insert attributesList;
    
    List<Apttus_Config2__AssetLineItem__c> assetLinesList = New List<Apttus_Config2__AssetLineItem__c>();
    Apttus_Config2__AssetLineItem__c asset1=new Apttus_Config2__AssetLineItem__c(Apttus_Config2__ProductId__c=prod1.id,Apttus_Config2__Quantity__c=5,Apttus_Config2__AssetStatus__c ='Activated',Apttus_Config2__LineType__c  ='Product/Service',APTS_SSD_ship_to__c=accountSSD.id,Apttus_Config2__AttributeValueId__c=attribute1.id,Apttus_QPConfig__ProposalId__c =p.id);
    Apttus_Config2__AssetLineItem__c asset2=new Apttus_Config2__AssetLineItem__c(Apttus_Config2__ProductId__c=prod2.id,Apttus_Config2__Quantity__c=5,Apttus_Config2__AssetStatus__c ='Activated',Apttus_Config2__LineType__c  ='Product/Service',APTS_SSD_ship_to__c=accountSSD.id,Apttus_Config2__AttributeValueId__c=attribute1.id,Apttus_QPConfig__ProposalId__c =p.id);
    Apttus_Config2__AssetLineItem__c asset3=new Apttus_Config2__AssetLineItem__c(Apttus_Config2__ProductId__c=prod3.id,Apttus_Config2__Quantity__c=5,Apttus_Config2__AssetStatus__c ='Activated',Apttus_Config2__LineType__c  ='Product/Service',APTS_SSD_ship_to__c=accountSSD.id,Apttus_Config2__AttributeValueId__c=attribute1.id,Apttus_QPConfig__ProposalId__c =p.id);
    Apttus_Config2__AssetLineItem__c asset4=new Apttus_Config2__AssetLineItem__c(Apttus_Config2__ProductId__c=prod4.id,Apttus_Config2__Quantity__c=5,Apttus_Config2__AssetStatus__c ='Activated',Apttus_Config2__LineType__c  ='Product/Service',APTS_SSD_ship_to__c=accountSSD.id,Apttus_Config2__AttributeValueId__c=attribute1.id,Apttus_QPConfig__ProposalId__c =p.id);
    Apttus_Config2__AssetLineItem__c asset5=new Apttus_Config2__AssetLineItem__c(Apttus_Config2__ProductId__c=prod5.id,Apttus_Config2__Quantity__c=5,Apttus_Config2__AssetStatus__c ='Activated',Apttus_Config2__LineType__c  ='Product/Service',APTS_SSD_ship_to__c=accountSSD.id,Apttus_Config2__AttributeValueId__c=attribute1.id,Apttus_QPConfig__ProposalId__c =p.id);
    Apttus_Config2__AssetLineItem__c asset6=new Apttus_Config2__AssetLineItem__c(Apttus_Config2__ProductId__c=prod6.id,Apttus_Config2__Quantity__c=5,Apttus_Config2__AssetStatus__c ='Activated',Apttus_Config2__LineType__c  ='Product/Service',APTS_SSD_ship_to__c=accountSSD.id,Apttus_Config2__AttributeValueId__c=attribute2.id,Apttus_QPConfig__ProposalId__c =p.id);
    Apttus_Config2__AssetLineItem__c asset7=new Apttus_Config2__AssetLineItem__c(Apttus_Config2__ProductId__c=prod7.id,Apttus_Config2__Quantity__c=5,Apttus_Config2__AssetStatus__c ='Activated',Apttus_Config2__LineType__c  ='Product/Service',APTS_SSD_ship_to__c=accountSSD.id,Apttus_Config2__AttributeValueId__c=attribute2.id,Apttus_QPConfig__ProposalId__c =p.id);
    Apttus_Config2__AssetLineItem__c asset8=new Apttus_Config2__AssetLineItem__c(Apttus_Config2__ProductId__c=prod8.id,Apttus_Config2__Quantity__c=5,Apttus_Config2__AssetStatus__c ='Activated',Apttus_Config2__LineType__c  ='Product/Service',APTS_SSD_ship_to__c=accountSSD.id,Apttus_Config2__AttributeValueId__c=attribute2.id,Apttus_QPConfig__ProposalId__c =p.id);
    Apttus_Config2__AssetLineItem__c asset9=new Apttus_Config2__AssetLineItem__c(Apttus_Config2__ProductId__c=prod9.id,Apttus_Config2__Quantity__c=5,Apttus_Config2__AssetStatus__c ='Activated',Apttus_Config2__LineType__c  ='Product/Service',APTS_SSD_ship_to__c=accountSSD.id,Apttus_Config2__AttributeValueId__c=attribute2.id,Apttus_QPConfig__ProposalId__c =p.id);
    Apttus_Config2__AssetLineItem__c asset10=new Apttus_Config2__AssetLineItem__c(Apttus_Config2__ProductId__c=prod10.id,Apttus_Config2__Quantity__c=5,Apttus_Config2__AssetStatus__c ='Activated',Apttus_Config2__LineType__c  ='Product/Service',APTS_SSD_ship_to__c=accountSSD.id,Apttus_Config2__AttributeValueId__c=attribute2.id,Apttus_QPConfig__ProposalId__c =p.id);
    assetLinesList.add(asset1);
    assetLinesList.add(asset2);
    assetLinesList.add(asset3);
    assetLinesList.add(asset4);
    assetLinesList.add(asset5);
    assetLinesList.add(asset6);
    assetLinesList.add(asset7);
    assetLinesList.add(asset8);
    assetLinesList.add(asset9);
    assetLinesList.add(asset10);
    insert assetLinesList;
        
      List <Apttus_Config2__Incentive__c> incentiveList = New List<Apttus_Config2__Incentive__c >();
      
      Apttus_Config2__Incentive__c incentive1 = new Apttus_Config2__Incentive__c(Name = 'Test Promo1',Apttus_Config2__Sequence__c =1,Bridge_override__c =3,Impacted_Approvals__c ='Bridges');
      Apttus_Config2__Incentive__c incentive2 = new Apttus_Config2__Incentive__c(Name = 'Test Promo2',Apttus_Config2__Sequence__c =1,Bridge_override__c =4,Impacted_Approvals__c ='Bridges');
      Apttus_Config2__Incentive__c incentive3 = new Apttus_Config2__Incentive__c(Name = 'Test Promo3',Apttus_Config2__Sequence__c =1,Minimum_YOY_override__c =3,Impacted_Approvals__c ='Minimum YOY Increase');
      Apttus_Config2__Incentive__c incentive4 = new Apttus_Config2__Incentive__c(Name = 'Test Promo4',Apttus_Config2__Sequence__c =1,Minimum_YOY_override__c =2,Impacted_Approvals__c ='Minimum YOY Increase');
      Apttus_Config2__Incentive__c incentive5 = new Apttus_Config2__Incentive__c(Name = 'Test Promo5',Apttus_Config2__Sequence__c =1,Bridge_override__c =3,Impacted_Approvals__c ='Short Term Trials');
      Apttus_Config2__Incentive__c incentive6 = new Apttus_Config2__Incentive__c(Name = 'Test Promo6',Apttus_Config2__Sequence__c =1,Bridge_override__c =4,Impacted_Approvals__c ='Short Term Trials');
      incentiveList.add(incentive1);
      incentiveList.add(incentive2);
      incentiveList.add(incentive3);
      incentiveList.add(incentive4);
      incentiveList.add(incentive5);
      incentiveList.add(incentive6);
      insert incentiveList;
      
      List<Apttus_Config2__AdjustmentLineItem__c> adjustmentLi = New List<Apttus_Config2__AdjustmentLineItem__c>();
      Apttus_Config2__AdjustmentLineItem__c adLi1 = new Apttus_Config2__AdjustmentLineItem__c(Apttus_Config2__LineItemId__c= lineItem1.id,Apttus_Config2__LineNumber__c = lineItem1.Apttus_Config2__LineNumber__c , Apttus_Config2__IncentiveCode__c = incentive1.Name , Apttus_Config2__IncentiveId__c = incentive1.id);
      Apttus_Config2__AdjustmentLineItem__c adLi2 = new Apttus_Config2__AdjustmentLineItem__c(Apttus_Config2__LineItemId__c= lineItem1.id,Apttus_Config2__LineNumber__c = lineItem1.Apttus_Config2__LineNumber__c , Apttus_Config2__IncentiveCode__c = incentive2.Name , Apttus_Config2__IncentiveId__c = incentive2.id);
      Apttus_Config2__AdjustmentLineItem__c adLi3 = new Apttus_Config2__AdjustmentLineItem__c(Apttus_Config2__LineItemId__c= lineItem1.id,Apttus_Config2__LineNumber__c = lineItem1.Apttus_Config2__LineNumber__c , Apttus_Config2__IncentiveCode__c = incentive3.Name , Apttus_Config2__IncentiveId__c = incentive3.id);
      Apttus_Config2__AdjustmentLineItem__c adLi4 = new Apttus_Config2__AdjustmentLineItem__c(Apttus_Config2__LineItemId__c= lineItem1.id,Apttus_Config2__LineNumber__c = lineItem1.Apttus_Config2__LineNumber__c , Apttus_Config2__IncentiveCode__c = incentive4.Name , Apttus_Config2__IncentiveId__c = incentive4.id);
      Apttus_Config2__AdjustmentLineItem__c adLi5 = new Apttus_Config2__AdjustmentLineItem__c(Apttus_Config2__LineItemId__c= lineItem2.id,Apttus_Config2__LineNumber__c = lineItem2.Apttus_Config2__LineNumber__c , Apttus_Config2__IncentiveCode__c = incentive5.Name , Apttus_Config2__IncentiveId__c = incentive5.id);
      Apttus_Config2__AdjustmentLineItem__c adLi6 = new Apttus_Config2__AdjustmentLineItem__c(Apttus_Config2__LineItemId__c= lineItem2.id,Apttus_Config2__LineNumber__c = lineItem2.Apttus_Config2__LineNumber__c , Apttus_Config2__IncentiveCode__c = incentive6.Name , Apttus_Config2__IncentiveId__c = incentive6.id);
      
      adjustmentLi.add(adLi1);
      adjustmentLi.add(adLi2);
      adjustmentLi.add(adLi3);
      adjustmentLi.add(adLi4);
      adjustmentLi.add(adLi5);
      adjustmentLi.add(adLi6);
      insert adjustmentLi;     
              
      test.startTest();     
      APTS_LineItemTriggerHelper.populateAllApprovalRequiredCB(insertList);       
      test.stopTest();              
    }

    static testMethod void corpOneOTC (){
        WebServiceSettings__c oWebServiceSettings = new WebServiceSettings__c(
            Active__c = true,
            Name = 'Payment AutoCharge',
            Service_Unavailable_Message__c = 'Auto Payment Service is Currently unavailable',        
            Endpoint__c = 'https://stg.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentAutoCharge');
        insert oWebServiceSettings ;
        
        WebServiceSettings__c o1WebServiceSettings = new WebServiceSettings__c(
            Active__c = true,
            Name = 'PaymentCreditIncrease',
            Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable',        
            Endpoint__c = 'https://qa.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease');
        insert o1WebServiceSettings ;
        
        List<KeyValueListStore__c> keyvaluestoreList = new List<KeyValueListStore__c>();
        KeyValueListStore__c keyvaluestore=new  KeyValueListStore__c();
        keyvaluestore.Name='ANZUsersProfileId';
        keyvaluestore.TextValue__c=System.Label.APTS_OC_Test_Id;
        keyvaluestoreList.add(keyvaluestore); 
        KeyValueListStore__c keyval = new KeyValueListStore__c();
        keyval.Name='ReasonWithCompetitor';
        keyval.TextValue__c='Price';
        keyvaluestoreList.add(keyval);
        insert keyvaluestoreList;
        
        //Inserting recordLists
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
        
        Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
        Account a = new Account(RecordTypeId=accRecordTypeId,name='test-sg',sales_org__c='ABEP',customer_group__c='Academic',customer_type__c='Organization',customer_class_c__c='Academic Lecturer');
        a.APTS_Customer_Category__c = '5';
        a.Is_GLI__c = True;
        insert a;        
        
        Schema.DescribeFieldResult fieldResultMarket = Apttus_Config2__ProductConfiguration__c.APTS_AccountMirror_Picklist__c.getDescribe();
        String valueMarket = fieldResultMarket.getPicklistValues().get(0).getValue();
        
        //Inserting SourceSystemDetail
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();
        List<Source_System_Detail__c> ssdList = new List<Source_System_Detail__c>();
        Source_System_Detail__c accountSSD= new Source_System_Detail__c();
        accountSSD.RecordtypeId=ssdRecorType;
        accountSSD.Name='ABC';
        accountSSD.Source_System_Name__c='ABC';
        accountSSD.Account_Name__c=a.ID;
        accountSSD.APTS_Customer_Category__c='1';
        accountSSD.LCRM_Customer_Group__c='Academic';
        accountSSD.LCRM_Frozen_Market_Segment__c = valueMarket;
        accountSSD.Account_Inactive__c=false;
        accountSSD.LCRM_Sales_Org__c='TA78';
        accountSSD.LCRM_FL_Annual_Spend__c=100;
        //accountSSD.APTS_Has_Online_Assets__c=true;
        ssdList.add(accountSSD);
        
        //Added today
        Source_System_Detail__c accountSSD1= new Source_System_Detail__c();
        accountSSD1.RecordtypeId=ssdRecorType;
        accountSSD1.Name='ABC';
        accountSSD1.Source_System_Name__c='ABC';
        accountSSD1.Account_Name__c=a.ID;
        accountSSD1.APTS_Customer_Category__c='1';
        accountSSD1.LCRM_Customer_Group__c='Academic';
        accountSSD1.LCRM_Frozen_Market_Segment__c = valueMarket;
        accountSSD1.Account_Inactive__c=false;
        accountSSD1.LCRM_Sales_Org__c='S100';
        accountSSD1.APTS_Has_Online_Assets__c=true;
        ssdList.add(accountSSD1);
        
        Source_System_Detail__c accountSSD2= new Source_System_Detail__c();
        accountSSD2.RecordtypeId=ssdRecorType;
        accountSSD2.Name='ABC';
        accountSSD2.Source_System_Name__c='ABC';
        accountSSD2.Account_Name__c=a.ID;
        accountSSD2.APTS_Customer_Category__c='1';
        accountSSD2.LCRM_Customer_Group__c='Academic';
        accountSSD2.LCRM_Frozen_Market_Segment__c = valueMarket;
        accountSSD2.Account_Inactive__c=false;
        accountSSD2.LCRM_Sales_Org__c='S100';
        accountSSD2.APTS_Has_Online_Assets__c=true;
        ssdList.add(accountSSD2);
        
        insert ssdList;
        //End
        //insert accountSSD;
        
        Date todaysDate = system.today();
        Id oppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Pipeline Opportunity').getRecordTypeId();
        Opportunity o = new Opportunity(RecordTypeId=oppRecordTypeId,  Name='tst-opp', stagename='25%',closedate=todaysDate,forecastcategoryname='pipeline',accountId=a.id);
        insert o;
        
        Id devRecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Proposal').getRecordTypeId();
        List<Apttus_Proposal__Proposal__c> proposalList = new List<Apttus_Proposal__Proposal__c >();
        Apttus_Proposal__Proposal__c p = new Apttus_Proposal__Proposal__c(RecordTypeId=devRecordTypeId,APTS_Proposal_Business_Unit__c='Corp OneOTC US', CurrencyIsoCode = 'USD', Apttus_Proposal__Account__c=a.id,Apttus_Proposal__Proposal_Name__c='TST-10',  Apttus_Proposal__Opportunity__c=o.id, Apttus_Proposal__Approval_Stage__c='Draft', Apttus_Proposal__Proposal_Category__c='Quote', Apttus_Proposal__ReadyToGenerate__c = true, Apttus_Proposal__ReadyToPresent__c= true,APTS_SSD_Sold_To__c=accountSSD.Id,APTS_SSD_ship_to__c=accountSSD.Id,APTS_SSD_bill_to__c=accountSSD.Id);
        p.APTS_Approval_Segment__c ='Corporate Large';
        proposalList.add(p);
        
        Apttus_Proposal__Proposal__c p1 = new Apttus_Proposal__Proposal__c(RecordTypeId=devRecordTypeId,APTS_Proposal_Business_Unit__c='Tax Professional', CurrencyIsoCode = 'USD', Apttus_Proposal__Account__c=a.id,Apttus_Proposal__Proposal_Name__c='TST-11',  Apttus_Proposal__Opportunity__c=o.id, Apttus_Proposal__Approval_Stage__c='Draft', Apttus_Proposal__Proposal_Category__c='Quote', Apttus_Proposal__ReadyToGenerate__c = true, Apttus_Proposal__ReadyToPresent__c= true,APTS_SSD_Sold_To__c=accountSSD1.Id,APTS_SSD_ship_to__c=accountSSD1.Id,APTS_SSD_bill_to__c=accountSSD1.Id);
        //p.APTS_Approval_Segment__c ='Corporate Large';
        proposalList.add(p1);
        
        Apttus_Proposal__Proposal__c p2 = new Apttus_Proposal__Proposal__c(RecordTypeId=devRecordTypeId,APTS_Proposal_Business_Unit__c='SCS', CurrencyIsoCode = 'USD', Apttus_Proposal__Account__c=a.id,Apttus_Proposal__Proposal_Name__c='TST-11',  Apttus_Proposal__Opportunity__c=o.id, Apttus_Proposal__Approval_Stage__c='Draft', Apttus_Proposal__Proposal_Category__c='Quote', Apttus_Proposal__ReadyToGenerate__c = true, Apttus_Proposal__ReadyToPresent__c= true,APTS_SSD_Sold_To__c=accountSSD2.Id,APTS_SSD_ship_to__c=accountSSD2.Id,APTS_SSD_bill_to__c=accountSSD2.Id);
        //p.APTS_Approval_Segment__c ='Corporate Large';
        proposalList.add(p2);
        insert proposalList;
        //insert p;
        
        List<Apttus_Config2__ProductConfiguration__c> prodConfigList = new List<Apttus_Config2__ProductConfiguration__c >();
        Apttus_Config2__ProductConfiguration__c prodConf = new Apttus_Config2__ProductConfiguration__c(Name='prod-conf1', CurrencyIsoCode = 'USD', Apttus_QPConfig__Proposald__c=p.id, APTS_SSD_ship_to__c=accountSSD.Id,APTS_SSD_bill_to__c=accountSSD.Id);
        prodConfigList.add(prodConf);
        
        Apttus_Config2__ProductConfiguration__c prodConf1 = new Apttus_Config2__ProductConfiguration__c(Name='prod-conf2', CurrencyIsoCode = 'USD', Apttus_QPConfig__Proposald__c=p1.id, APTS_SSD_ship_to__c=accountSSD1.Id,APTS_SSD_bill_to__c=accountSSD1.Id);
        prodConfigList.add(prodConf1);
        //insert prodConfigList;
        
        Apttus_Config2__ProductConfiguration__c prodConf2 = new Apttus_Config2__ProductConfiguration__c(Name='prod-conf2', CurrencyIsoCode = 'USD', Apttus_QPConfig__Proposald__c=p2.id, APTS_SSD_ship_to__c=accountSSD2.Id,APTS_SSD_bill_to__c=accountSSD2.Id);
        prodConfigList.add(prodConf2);
        insert prodConfigList;
        
        List<Product2> productList=new List<Product2>();
        Product2 prod1 = new Product2(name='prod1', Media_High_Level__c='Online', CurrencyIsoCode = 'USD',ProductCode = '40483699',sales_Org__c='TA78');
        Product2 prod2 = new Product2(name='prod2', Media_High_Level__c='Online', CurrencyIsoCode = 'USD',ProductCode='40485592',sales_Org__c='TA78');
        Product2 prod3 = new Product2(name='prod3', Media_High_Level__c='Online', CurrencyIsoCode = 'USD',ProductCode='40483696',sales_Org__c='TA78');
        Product2 prod11 = new Product2(name='prod11', Media_High_Level__c='Online', CurrencyIsoCode = 'USD',ProductCode='40483696',sales_Org__c='TA78');
        Product2 prod4 = new Product2(name='prod4', Media_High_Level__c='Online', CurrencyIsoCode = 'USD',ProductCode='40483693',sales_Org__c='TA78');
        Product2 prod5 = new Product2(name='prod5', Media_High_Level__c='Online', CurrencyIsoCode = 'USD',ProductCode='41915678',sales_Org__c='TA78');
        Product2 prod6 = new Product2(name='prod6', Media_High_Level__c='Online', CurrencyIsoCode = 'USD',ProductCode='41892830',sales_Org__c='TA78');
        Product2 prod7 = new Product2(name='prod7', Media_High_Level__c='Online', CurrencyIsoCode = 'USD',ProductCode='41767150',sales_Org__c='TA78');
        Product2 prod8 = new Product2(name='prod8', Media_High_Level__c='QASVC', CurrencyIsoCode = 'USD',ProductCode='42124052',sales_Org__c='TA78',APTS_Approval_Always_Required__c=true,WLEC_Product_Category__c='PS');
        Product2 prod9 = new Product2(name='prod9', Media_High_Level__c='QASVC', CurrencyIsoCode = 'USD',ProductCode='41822784',sales_Org__c='TA78',APTS_Approval_Always_Required__c=true,WLEC_Product_Category__c='PS');
        Product2 prod10 = new Product2(name='prod10', Media_High_Level__c='QASVC', CurrencyIsoCode = 'USD',ProductCode='41777796',sales_Org__c='TA78',APTS_Approval_Always_Required__c=true,WLEC_Product_Category__c='PS');
        //Product2 prod11 = new Product2(name='prod11', Media_High_Level__c='QASVC', CurrencyIsoCode = 'USD',ProductCode='41777796',sales_Org__c='TA78',APTS_Approval_Always_Required__c=true,WLEC_Product_Category__c='PS');
        productList.add(prod1);
        productList.add(prod2);
        productList.add(prod3);
        productList.add(prod4);
        productList.add(prod5);
        productList.add(prod6);
        productList.add(prod7);
        productList.add(prod8);
        productList.add(prod9);
        productList.add(prod10);
        insert productList;
        system.assertEquals(prod10.Name,'prod10');

        List<Apttus_Config2__LineItem__c> insertList=new List<Apttus_Config2__LineItem__c>();
        List<Apttus_Config2__LineItem__c> updateList=new List<Apttus_Config2__LineItem__c>();
        
        Apttus_Config2__LineItem__c lineItem1=new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c=prodConf.id , Apttus_Config2__ProductId__c=prod1.id,Apttus_Config2__LineType__c ='Product/Service',Apttus_Config2__LineStatus__c = 'New',Apttus_Config2__ChargeType__c = 'Subscription Fee',Apttus_Config2__ItemSequence__c = 1,Apttus_Config2__LineNumber__c = 1,Apttus_Config2__ListPrice__c = 100,Apttus_Config2__NetAdjustmentPercent__c = -50,Apttus_Config2__NetPrice__c = 50,Apttus_Config2__NetUnitPrice__c = 50,Apttus_Config2__AdjustedPrice__c = 50,Apttus_Config2__AdjustmentAmount__c = 50,Apttus_Config2__AdjustmentType__c = '% Discount',Apttus_Config2__AddedBy__c = 'User',CurrencyIsoCode = 'USD',APTS_Bridge__c  ='1 Month',APTS_Years_2_Plus_Adjustment__c='6');
        Apttus_Config2__LineItem__c lineItem2=new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c=prodConf.id , Apttus_Config2__ProductId__c=prod2.id,Apttus_Config2__LineType__c ='Product/Service',Apttus_Config2__LineStatus__c = 'New',Apttus_Config2__ChargeType__c = 'Subscription Fee',Apttus_Config2__ItemSequence__c = 1,Apttus_Config2__LineNumber__c = 1,Apttus_Config2__ListPrice__c = 100,Apttus_Config2__NetAdjustmentPercent__c = -50,Apttus_Config2__NetPrice__c = 50,Apttus_Config2__NetUnitPrice__c = 50,Apttus_Config2__AdjustedPrice__c = 50,Apttus_Config2__AdjustmentAmount__c = 50,Apttus_Config2__AdjustmentType__c = '% Discount',Apttus_Config2__AddedBy__c = 'User',CurrencyIsoCode = 'USD',APTS_Years_2_Plus_Adjustment__c='1');
        Apttus_Config2__LineItem__c lineItem3=new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c=prodConf.id , Apttus_Config2__ProductId__c=prod3.id,Apttus_Config2__LineType__c ='Product/Service',Apttus_Config2__LineStatus__c = 'New',Apttus_Config2__ChargeType__c = 'Subscription Fee',Apttus_Config2__ItemSequence__c = 1,Apttus_Config2__LineNumber__c = 1,Apttus_Config2__ListPrice__c = 100,Apttus_Config2__NetAdjustmentPercent__c = -50,Apttus_Config2__NetPrice__c = 50,Apttus_Config2__NetUnitPrice__c = 50,Apttus_Config2__AdjustedPrice__c = 50,Apttus_Config2__AdjustmentAmount__c = 50,Apttus_Config2__AdjustmentType__c = '% Discount',Apttus_Config2__AddedBy__c = 'User',CurrencyIsoCode = 'USD',APTS_Years_2_Plus_Adjustment__c='1');
        
        Apttus_Config2__LineItem__c lineItem4=new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c=prodConf.id , Apttus_Config2__ProductId__c=prod4.id,Apttus_Config2__LineType__c ='Product/Service',Apttus_Config2__LineStatus__c = 'New',Apttus_Config2__ChargeType__c = 'Subscription Fee',Apttus_Config2__ItemSequence__c = 1,Apttus_Config2__LineNumber__c = 1,Apttus_Config2__ListPrice__c = 100,Apttus_Config2__NetAdjustmentPercent__c = -50,Apttus_Config2__NetPrice__c = 50,Apttus_Config2__NetUnitPrice__c = 50,Apttus_Config2__AdjustedPrice__c = 50,Apttus_Config2__AdjustmentAmount__c = 50,Apttus_Config2__AdjustmentType__c = '% Discount',Apttus_Config2__AddedBy__c = 'User',CurrencyIsoCode = 'USD',APTS_Years_2_Plus_Adjustment__c='1');
        Apttus_Config2__LineItem__c lineItem5=new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c=prodConf.id , Apttus_Config2__ProductId__c=prod5.id,Apttus_Config2__LineType__c ='Product/Service',Apttus_Config2__LineStatus__c = 'New',Apttus_Config2__ChargeType__c = 'Subscription Fee',Apttus_Config2__ItemSequence__c = 1,Apttus_Config2__LineNumber__c = 1,Apttus_Config2__ListPrice__c = 100,Apttus_Config2__NetAdjustmentPercent__c = -50,Apttus_Config2__NetPrice__c = 50,Apttus_Config2__NetUnitPrice__c = 50,Apttus_Config2__AdjustedPrice__c = 50,Apttus_Config2__AdjustmentAmount__c = 50,Apttus_Config2__AdjustmentType__c = '% Discount',Apttus_Config2__AddedBy__c = 'User',CurrencyIsoCode = 'USD',APTS_Years_2_Plus_Adjustment__c='1');
        Apttus_Config2__LineItem__c lineItem6=new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c=prodConf.id , Apttus_Config2__ProductId__c=prod6.id,Apttus_Config2__LineType__c ='Product/Service',Apttus_Config2__LineStatus__c = 'New',Apttus_Config2__ChargeType__c = 'Subscription Fee',Apttus_Config2__ItemSequence__c = 1,Apttus_Config2__LineNumber__c = 1,Apttus_Config2__ListPrice__c = 100,Apttus_Config2__NetAdjustmentPercent__c = -50,Apttus_Config2__NetPrice__c = 50,Apttus_Config2__NetUnitPrice__c = 50,Apttus_Config2__AdjustedPrice__c = 50,Apttus_Config2__AdjustmentAmount__c = 50,Apttus_Config2__AdjustmentType__c = '% Discount',Apttus_Config2__AddedBy__c = 'User',CurrencyIsoCode = 'USD',APTS_Years_2_Plus_Adjustment__c='1');
        Apttus_Config2__LineItem__c lineItem7=new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c=prodConf.id , Apttus_Config2__ProductId__c=prod7.id,Apttus_Config2__LineType__c ='Product/Service',Apttus_Config2__LineStatus__c = 'New',Apttus_Config2__ChargeType__c = 'Subscription Fee',Apttus_Config2__ItemSequence__c = 1,Apttus_Config2__LineNumber__c = 1,Apttus_Config2__ListPrice__c = 100,Apttus_Config2__NetAdjustmentPercent__c = -50,Apttus_Config2__NetPrice__c = 50,Apttus_Config2__NetUnitPrice__c = 50,Apttus_Config2__AdjustedPrice__c = 50,Apttus_Config2__AdjustmentAmount__c = 50,Apttus_Config2__AdjustmentType__c = '% Discount',Apttus_Config2__AddedBy__c = 'User',CurrencyIsoCode = 'USD',APTS_Years_2_Plus_Adjustment__c='1');
        Apttus_Config2__LineItem__c lineItem8=new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c=prodConf.id , Apttus_Config2__ProductId__c=prod8.id,Apttus_Config2__LineType__c ='Product/Service',Apttus_Config2__LineStatus__c ='New',Apttus_Config2__ChargeType__c = 'Subscription Fee',Apttus_Config2__ItemSequence__c = 1,Apttus_Config2__LineNumber__c = 1,Apttus_Config2__ListPrice__c = 100,Apttus_Config2__NetAdjustmentPercent__c = -50,Apttus_Config2__NetPrice__c = 50,Apttus_Config2__NetUnitPrice__c = 50,Apttus_Config2__AdjustedPrice__c = 50,Apttus_Config2__AdjustmentAmount__c = 50,Apttus_Config2__AdjustmentType__c = '% Discount',Apttus_Config2__AddedBy__c = 'User',CurrencyIsoCode = 'USD',APTS_Years_2_Plus_Adjustment__c='1');
        Apttus_Config2__LineItem__c lineItem9=new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c=prodConf.id , Apttus_Config2__ProductId__c=prod9.id,Apttus_Config2__LineType__c ='Product/Service',Apttus_Config2__LineStatus__c = 'New',Apttus_Config2__ChargeType__c = 'Subscription Fee',Apttus_Config2__ItemSequence__c = 1,Apttus_Config2__LineNumber__c = 1,Apttus_Config2__ListPrice__c = 100,Apttus_Config2__NetAdjustmentPercent__c = -50,Apttus_Config2__NetPrice__c = 50,Apttus_Config2__NetUnitPrice__c = 50,Apttus_Config2__AdjustedPrice__c = 50,Apttus_Config2__AdjustmentAmount__c = 50,Apttus_Config2__AdjustmentType__c = '% Discount',Apttus_Config2__AddedBy__c = 'User',CurrencyIsoCode = 'USD',APTS_Years_2_Plus_Adjustment__c='1');
        Apttus_Config2__LineItem__c lineItem10=new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c=prodConf.id , Apttus_Config2__ProductId__c=prod10.id,Apttus_Config2__LineType__c ='Product/Service',Apttus_Config2__LineStatus__c = 'New',Apttus_Config2__ChargeType__c = 'Subscription Fee',Apttus_Config2__ItemSequence__c = 1,Apttus_Config2__LineNumber__c = 1,Apttus_Config2__ListPrice__c = 100,Apttus_Config2__NetAdjustmentPercent__c = -50,Apttus_Config2__NetPrice__c = 50,Apttus_Config2__NetUnitPrice__c = 50,Apttus_Config2__AdjustedPrice__c = 50,Apttus_Config2__AdjustmentAmount__c = 50,Apttus_Config2__AdjustmentType__c = '% Discount',Apttus_Config2__AddedBy__c = 'User',CurrencyIsoCode = 'USD',APTS_Years_2_Plus_Adjustment__c='1');
        Apttus_Config2__LineItem__c lineItem11=new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c=prodConf1.id , Apttus_Config2__ProductId__c=prod10.id,Apttus_Config2__LineType__c ='Product/Service',Apttus_Config2__LineStatus__c = 'New',Apttus_Config2__ChargeType__c = 'Subscription Fee',Apttus_Config2__ItemSequence__c = 1,Apttus_Config2__LineNumber__c = 1,Apttus_Config2__ListPrice__c = 100,Apttus_Config2__NetAdjustmentPercent__c = -50,Apttus_Config2__NetPrice__c = 50,Apttus_Config2__NetUnitPrice__c = 50,Apttus_Config2__AdjustedPrice__c = 50,Apttus_Config2__AdjustmentAmount__c = 50,Apttus_Config2__AdjustmentType__c = '% Discount',Apttus_Config2__AddedBy__c = 'User',CurrencyIsoCode = 'USD',APTS_Years_2_Plus_Adjustment__c='1',Apttus_Config2__BasePriceMethod__c = 'Flat Price',APTS_Product_Delivery__c = 'Online/Internet',Apttus_Config2__Quantity__c = 1,Apttus_Config2__SellingTerm__c = 1);
        Apttus_Config2__LineItem__c lineItem12=new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c=prodConf1.id , Apttus_Config2__ProductId__c=prod10.id,Apttus_Config2__LineType__c ='Product/Service',Apttus_Config2__LineStatus__c = 'New',Apttus_Config2__ChargeType__c = 'Subscription Fee',Apttus_Config2__ItemSequence__c = 1,Apttus_Config2__LineNumber__c = 1,Apttus_Config2__ListPrice__c = 100,Apttus_Config2__NetAdjustmentPercent__c = -50,Apttus_Config2__NetPrice__c = 50,Apttus_Config2__NetUnitPrice__c = 50,Apttus_Config2__AdjustedPrice__c = 50,Apttus_Config2__AdjustmentAmount__c = 50,Apttus_Config2__AdjustmentType__c = '% Discount',Apttus_Config2__AddedBy__c = 'User',CurrencyIsoCode = 'USD',APTS_Years_2_Plus_Adjustment__c='1',Apttus_Config2__BasePriceMethod__c = 'Flat Price',APTS_Product_Delivery__c = 'Download',Apttus_Config2__Quantity__c = 1,Apttus_Config2__SellingTerm__c = 1,APTS_Calculated_Min_YOY__c = 1);
        Apttus_Config2__LineItem__c lineItem13=new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c=prodConf1.id , Apttus_Config2__ProductId__c=prod10.id,Apttus_Config2__LineType__c ='Product/Service',Apttus_Config2__LineStatus__c = 'Cancelled',Apttus_Config2__ChargeType__c = 'Subscription Fee',Apttus_Config2__ItemSequence__c = 1,Apttus_Config2__LineNumber__c = 1,Apttus_Config2__ListPrice__c = 100,Apttus_Config2__NetAdjustmentPercent__c = -50,Apttus_Config2__NetPrice__c = 50,Apttus_Config2__NetUnitPrice__c = 50,Apttus_Config2__AdjustedPrice__c = 50,Apttus_Config2__AdjustmentAmount__c = 50,Apttus_Config2__AdjustmentType__c = '% Discount',Apttus_Config2__AddedBy__c = 'User',CurrencyIsoCode = 'USD',APTS_Years_2_Plus_Adjustment__c='1',Apttus_Config2__BasePriceMethod__c = 'Flat Price',APTS_Product_Delivery__c = 'Download',Apttus_Config2__Quantity__c = 1,Apttus_Config2__SellingTerm__c = 1);
        Apttus_Config2__LineItem__c lineItem14=new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c=prodConf2.id , Apttus_Config2__ProductId__c=prod11.id,Apttus_Config2__LineType__c ='Product/Service',Apttus_Config2__LineStatus__c = 'Cancelled',Apttus_Config2__ChargeType__c = 'Subscription Fee',Apttus_Config2__ItemSequence__c = 1,Apttus_Config2__LineNumber__c = 1,Apttus_Config2__ListPrice__c = 100,Apttus_Config2__NetAdjustmentPercent__c = -50,Apttus_Config2__NetPrice__c = 50,Apttus_Config2__NetUnitPrice__c = 50,Apttus_Config2__AdjustedPrice__c = 50,Apttus_Config2__AdjustmentAmount__c = 50,Apttus_Config2__AdjustmentType__c = '% Discount',Apttus_Config2__AddedBy__c = 'User',CurrencyIsoCode = 'USD',APTS_Years_2_Plus_Adjustment__c='1',Apttus_Config2__BasePriceMethod__c = 'Flat Price',APTS_Product_Delivery__c = 'Download',Apttus_Config2__Quantity__c = 1,Apttus_Config2__SellingTerm__c = 1);
        insertList.add(lineItem1);
        insertList.add(lineItem2);
        insertList.add(lineItem3);
        insertList.add(lineItem4);
        insertList.add(lineItem5);
        insertList.add(lineItem6);
        insertList.add(lineItem7);
        insertList.add(lineItem8);
        insertList.add(lineItem9);
        insertList.add(lineItem10);
        insertList.add(lineItem11);
        insertList.add(lineItem12);
        insertList.add(lineItem13);
        insertList.add(lineItem14);
        
        Apttus_Config2__AssetLineItem__c asset=new Apttus_Config2__AssetLineItem__c(Apttus_Config2__ProductId__c=prod1.id,Apttus_Config2__Quantity__c=5,Apttus_Config2__AssetStatus__c ='Activated',Apttus_Config2__LineType__c  ='Product/Service',Apttus_Config2__NetPrice__c=240,APTS_SSD_Sold_To__c=accountSSD.id,Apttus_QPConfig__ProposalId__c =p.id);
        insert asset;
        
        
        List<Apttus_Config2__AssetLineItem__c> assetLinesList = New List<Apttus_Config2__AssetLineItem__c>();
        Apttus_Config2__AssetLineItem__c asset1=new Apttus_Config2__AssetLineItem__c(Apttus_Config2__ProductId__c=prod1.id,Apttus_Config2__Quantity__c=5,Apttus_Config2__AssetStatus__c ='Activated',Apttus_Config2__LineType__c  ='Product/Service',Apttus_Config2__NetPrice__c=240,APTS_SSD_Sold_To__c=accountSSD.id,Apttus_QPConfig__ProposalId__c =p.id);
        Apttus_Config2__AssetLineItem__c asset2=new Apttus_Config2__AssetLineItem__c(Apttus_Config2__ProductId__c=prod2.id,Apttus_Config2__Quantity__c=5,Apttus_Config2__AssetStatus__c ='Activated',Apttus_Config2__LineType__c  ='Product/Service',Apttus_Config2__NetPrice__c=240,APTS_SSD_Sold_To__c=accountSSD.id,Apttus_QPConfig__ProposalId__c =p.id);
        Apttus_Config2__AssetLineItem__c asset3=new Apttus_Config2__AssetLineItem__c(Apttus_Config2__ProductId__c=prod3.id,Apttus_Config2__Quantity__c=5,Apttus_Config2__AssetStatus__c ='Activated',Apttus_Config2__LineType__c  ='Product/Service',Apttus_Config2__NetPrice__c=240,APTS_SSD_Sold_To__c=accountSSD.id,Apttus_QPConfig__ProposalId__c =p.id);
        Apttus_Config2__AssetLineItem__c asset4=new Apttus_Config2__AssetLineItem__c(Apttus_Config2__ProductId__c=prod4.id,Apttus_Config2__Quantity__c=5,Apttus_Config2__AssetStatus__c ='Activated',Apttus_Config2__LineType__c  ='Product/Service',Apttus_Config2__NetPrice__c=240,APTS_SSD_Sold_To__c=accountSSD.id,Apttus_QPConfig__ProposalId__c =p.id);
        Apttus_Config2__AssetLineItem__c asset5=new Apttus_Config2__AssetLineItem__c(Apttus_Config2__ProductId__c=prod5.id,Apttus_Config2__Quantity__c=5,Apttus_Config2__AssetStatus__c ='Activated',Apttus_Config2__LineType__c  ='Product/Service',Apttus_Config2__NetPrice__c=240,APTS_SSD_Sold_To__c=accountSSD.id,Apttus_QPConfig__ProposalId__c =p.id);
        Apttus_Config2__AssetLineItem__c asset6=new Apttus_Config2__AssetLineItem__c(Apttus_Config2__ProductId__c=prod6.id,Apttus_Config2__Quantity__c=5,Apttus_Config2__AssetStatus__c ='Activated',Apttus_Config2__LineType__c  ='Product/Service',Apttus_Config2__NetPrice__c=240,APTS_SSD_Sold_To__c=accountSSD.id,Apttus_QPConfig__ProposalId__c =p.id);
        Apttus_Config2__AssetLineItem__c asset7=new Apttus_Config2__AssetLineItem__c(Apttus_Config2__ProductId__c=prod7.id,Apttus_Config2__Quantity__c=5,Apttus_Config2__AssetStatus__c ='Activated',Apttus_Config2__LineType__c  ='Product/Service',Apttus_Config2__NetPrice__c=240,APTS_SSD_Sold_To__c=accountSSD.id,Apttus_QPConfig__ProposalId__c =p.id);
        Apttus_Config2__AssetLineItem__c asset8=new Apttus_Config2__AssetLineItem__c(Apttus_Config2__ProductId__c=prod8.id,Apttus_Config2__Quantity__c=5,Apttus_Config2__AssetStatus__c ='Activated',Apttus_Config2__LineType__c  ='Product/Service',Apttus_Config2__NetPrice__c=240,APTS_SSD_Sold_To__c=accountSSD.id,Apttus_QPConfig__ProposalId__c =p.id);
        Apttus_Config2__AssetLineItem__c asset9=new Apttus_Config2__AssetLineItem__c(Apttus_Config2__ProductId__c=prod9.id,Apttus_Config2__Quantity__c=5,Apttus_Config2__AssetStatus__c ='Activated',Apttus_Config2__LineType__c  ='Product/Service',Apttus_Config2__NetPrice__c=240,APTS_SSD_Sold_To__c=accountSSD.id,Apttus_QPConfig__ProposalId__c =p.id);
        Apttus_Config2__AssetLineItem__c asset10=new Apttus_Config2__AssetLineItem__c(Apttus_Config2__ProductId__c=prod10.id,Apttus_Config2__Quantity__c=5,Apttus_Config2__AssetStatus__c ='Activated',Apttus_Config2__LineType__c  ='Product/Service',Apttus_Config2__NetPrice__c=240,APTS_SSD_Sold_To__c=accountSSD.id,Apttus_QPConfig__ProposalId__c =p.id);
        Apttus_Config2__AssetLineItem__c asset11=new Apttus_Config2__AssetLineItem__c(Apttus_Config2__ProductId__c=prod10.id,Apttus_Config2__Quantity__c=5,Apttus_Config2__AssetStatus__c ='Activated',Apttus_Config2__LineType__c  ='Product/Service',Apttus_Config2__NetPrice__c=240,APTS_SSD_Sold_To__c=accountSSD1.id,Apttus_QPConfig__ProposalId__c =p1.id,Apttus_Config2__BasePriceMethod__c = 'Flat Price',Apttus_Config2__NetUnitPrice__c = 20);
        Apttus_Config2__AssetLineItem__c asset12=new Apttus_Config2__AssetLineItem__c(Apttus_Config2__ProductId__c=prod10.id,Apttus_Config2__Quantity__c=5,Apttus_Config2__AssetStatus__c ='Activated',Apttus_Config2__LineType__c  ='Product/Service',Apttus_Config2__NetPrice__c=240,APTS_SSD_Sold_To__c=accountSSD1.id,Apttus_QPConfig__ProposalId__c =p1.id,Apttus_Config2__BasePriceMethod__c = 'Per Unit',Apttus_Config2__NetUnitPrice__c = 20);
        Apttus_Config2__AssetLineItem__c asset13=new Apttus_Config2__AssetLineItem__c(Apttus_Config2__ProductId__c=prod11.id,Apttus_Config2__Quantity__c=5,Apttus_Config2__AssetStatus__c ='Activated',Apttus_Config2__LineType__c  ='Product/Service',Apttus_Config2__NetPrice__c=240,APTS_SSD_Sold_To__c=accountSSD1.id,Apttus_QPConfig__ProposalId__c =p2.id,Apttus_Config2__BasePriceMethod__c = 'Per Unit',Apttus_Config2__NetUnitPrice__c = 20, APTS_Info_RenewalDate__c = System.Date.Today().addDays(-20));
        assetLinesList.add(asset1);
        assetLinesList.add(asset2);
        assetLinesList.add(asset3);
        assetLinesList.add(asset4);
        assetLinesList.add(asset5);
        assetLinesList.add(asset6);
        assetLinesList.add(asset7);
        assetLinesList.add(asset8);
        assetLinesList.add(asset9);
        assetLinesList.add(asset10);
        assetLinesList.add(asset11);
        assetLinesList.add(asset12);
        assetLinesList.add(asset13);
        insert assetLinesList;
        
        
        insert insertList;
        
        List<Apttus_Config2__LineItem__c> insertNewList = New List<Apttus_Config2__LineItem__c>();
        Apttus_Config2__LineItem__c lineItem18=new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c=prodConf1.id , Apttus_Config2__ProductId__c=prod10.id,Apttus_Config2__LineType__c ='Product/Service',Apttus_Config2__LineStatus__c = 'Cancelled',Apttus_Config2__ChargeType__c = 'Subscription Fee',Apttus_Config2__ItemSequence__c = 1,Apttus_Config2__LineNumber__c = 1,Apttus_Config2__ListPrice__c = 100,Apttus_Config2__NetAdjustmentPercent__c = -50,Apttus_Config2__NetPrice__c = 50,Apttus_Config2__NetUnitPrice__c = 50,Apttus_Config2__AdjustedPrice__c = 50,Apttus_Config2__AdjustmentAmount__c = 50,Apttus_Config2__AdjustmentType__c = '% Discount',Apttus_Config2__AddedBy__c = 'User',CurrencyIsoCode = 'USD',APTS_Years_2_Plus_Adjustment__c='1',Apttus_Config2__BasePriceMethod__c = 'Flat Price',APTS_Product_Delivery__c = 'Download',Apttus_Config2__Quantity__c = 1,Apttus_Config2__SellingTerm__c = 1,Apttus_Config2__AssetLineItemId__c = asset11.id);
        insertNewList.add(lineItem18);
        
        Apttus_Config2__LineItem__c lineItem15=new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c=prodConf1.id , Apttus_Config2__ProductId__c=prod10.id,Apttus_Config2__LineType__c ='Product/Service',Apttus_Config2__LineStatus__c = 'Cancelled',Apttus_Config2__ChargeType__c = 'Subscription Fee',Apttus_Config2__ItemSequence__c = 1,Apttus_Config2__LineNumber__c = 1,Apttus_Config2__ListPrice__c = 100,Apttus_Config2__NetAdjustmentPercent__c = -50,Apttus_Config2__NetPrice__c = 50,Apttus_Config2__NetUnitPrice__c = 50,Apttus_Config2__AdjustedPrice__c = 50,Apttus_Config2__AdjustmentAmount__c = 50,Apttus_Config2__AdjustmentType__c = '% Discount',Apttus_Config2__AddedBy__c = 'User',CurrencyIsoCode = 'USD',APTS_Years_2_Plus_Adjustment__c='1',Apttus_Config2__BasePriceMethod__c = 'Per Unit',APTS_Product_Delivery__c = 'Download',Apttus_Config2__Quantity__c = 1,Apttus_Config2__SellingTerm__c = 1,Apttus_Config2__AssetLineItemId__c = asset12.id);
        insertNewList.add(lineItem15);
        
        insert insertNewList;
        system.debug('PBU CorpMethode L11= '+lineItem11.APTS_Proposal_Business_Unit__c);
        //lineItem2.APTS_Years_2_Plus_Adjustment__c='2';
        //lineItem3.APTS_Years_2_Plus_Adjustment__c='2';
        lineItem2.Apttus_Config2__AddedBy__c = 'User';
        lineItem2.Apttus_Config2__AdjustedPrice__c = 50;
        lineItem2.Apttus_Config2__AdjustmentAmount__c = 50;
        lineItem2.Apttus_Config2__AdjustmentType__c = '% Discount';
        lineItem2.Apttus_Config2__AllocateGroupAdjustment__c = TRUE;
        lineItem2.Apttus_Config2__AllowableAction__c = 'Unrestricted';
        lineItem2.Apttus_Config2__AllowManualAdjustment__c = TRUE;
        lineItem2.Apttus_Config2__AllowProration__c = FALSE;
        lineItem2.Apttus_Config2__AllowRemoval__c = TRUE;
        lineItem2.Apttus_Config2__AutoRenew__c = FALSE;
        lineItem2.Apttus_Config2__BaseExtendedCost__c = 0;
        lineItem2.Apttus_Config2__BaseExtendedPrice__c = 100;
        lineItem2.Apttus_Config2__BasePrice__c = 100;
        lineItem2.Apttus_Config2__BasePriceMethod__c = 'Per Unit';
        lineItem2.Apttus_Config2__BillingFrequency__c = 'Monthly';
        lineItem2.Apttus_Config2__ChargeType__c = 'Subscription Fee';
        lineItem2.Apttus_Config2__ConfigStatus__c = 'Complete';
        lineItem2.Apttus_Config2__ConstraintCheckStatus__c = 'NA';
        lineItem2.Apttus_Config2__Customizable__c = FALSE;
        lineItem2.Apttus_Config2__DeltaPrice__c = 50;
        lineItem2.Apttus_Config2__DeltaQuantity__c = 1;
        lineItem2.Apttus_Config2__Description__c = 'Westlaw Flex Plan $100/500';
        lineItem2.Apttus_Config2__ExtendedCost__c = 0;
        lineItem2.Apttus_Config2__ExtendedPrice__c = 100;
        lineItem2.Apttus_Config2__Frequency__c = 'Monthly';
        lineItem2.Apttus_Config2__Guidance__c = 'Red';        
        lineItem2.Apttus_Config2__IsOptionRollupLine__c = FALSE;
        lineItem2.Apttus_Config2__IsPrimaryLine__c = TRUE;
        lineItem2.Apttus_Config2__IsPrimaryRampLine__c = FALSE;
        lineItem2.Apttus_Config2__IsQuantityModifiable__c = FALSE;
        lineitem2.Apttus_Config2__IsReadOnly__c = FALSE;
        lineitem2.Apttus_Config2__IsSellingTermReadOnly__c = FALSE;
        lineitem2.Apttus_Config2__IsUsageTierModifiable__c = FALSE;
        lineitem2.Apttus_Config2__ItemSequence__c = 1;
        lineitem2.Apttus_Config2__LineNumber__c = 1;
        lineitem2.Apttus_Config2__LineSequence__c = 1;
        lineitem2.Apttus_Config2__LineStatus__c = 'New';
        lineitem2.Apttus_Config2__LineType__c = 'Product/Service';
        lineitem2.Apttus_Config2__ListPrice__c = 100;
        lineitem2.Apttus_Config2__NetAdjustmentPercent__c = -50;
        lineitem2.Apttus_Config2__NetPrice__c = 50;
        lineitem2.Apttus_Config2__NetUnitPrice__c = 50;
        lineitem2.Apttus_Config2__OptionSequence__c = 0;
        lineitem2.Apttus_Config2__PriceIncludedInBundle__c = FALSE;
        lineitem2.Apttus_Config2__PriceMethod__c = 'Per Unit';
        lineitem2.Apttus_Config2__PriceType__c = 'Recurring';
        lineitem2.Apttus_Config2__PriceUom__c = 'Each';
        lineitem2.Apttus_Config2__PricingStatus__c = 'Complete';
        lineitem2.Apttus_Config2__PrimaryLineNumber__c = 1;
        lineitem2.Apttus_Config2__ProductVersion__c = 1;
        lineitem2.Apttus_Config2__Quantity__c = 1;
        lineitem2.Apttus_Config2__RollupPriceToBundle__c = TRUE;
        lineitem2.Apttus_Config2__SellingFrequency__c = 'Monthly';
        lineitem2.Apttus_Config2__SellingTerm__c = 1;
        lineitem2.Apttus_Config2__SyncStatus__c = 'Pending';
        lineitem2.Apttus_Config2__Taxable__c = FALSE;
        lineitem2.Apttus_Config2__TaxInclusive__c = FALSE;
        lineitem2.Apttus_Config2__Term__c = 1;
        lineitem2.Apttus_Config2__TotalQuantity__c = 1;
        lineitem2.Apttus_Config2__Uom__c = 'Each';
        lineitem2.Apttus_CQApprov__Approval_Status__c = 'Pending Approval';
        lineitem2.CurrencyIsoCode = 'USD';
        lineitem2.APTS_Product_Family__c = 'Non-Clear';
        lineitem2.APTS_Contract_Term__c = '2 Years';
        lineitem2.APTS_Years_2_Plus_Adjustment__c = '2';
        updateList.add(lineItem2);
        
        lineitem8.Apttus_Config2__AddedBy__c = 'User';
        lineitem8.Apttus_Config2__AdjustedPrice__c = 50;
        lineitem8.Apttus_Config2__AdjustmentAmount__c = 50;
        lineitem8.Apttus_Config2__AdjustmentType__c = '% Discount';
        lineitem8.Apttus_Config2__AllocateGroupAdjustment__c = TRUE;
        lineitem8.Apttus_Config2__AllowableAction__c = 'Unrestricted';
        lineitem8.Apttus_Config2__AllowManualAdjustment__c = TRUE;
        lineitem8.Apttus_Config2__AllowProration__c = FALSE;
        lineitem8.Apttus_Config2__AllowRemoval__c = TRUE;
        lineitem8.Apttus_Config2__AutoRenew__c = FALSE;
        lineitem8.Apttus_Config2__BaseExtendedCost__c = 0;
        lineitem8.Apttus_Config2__BaseExtendedPrice__c = 100;
        lineitem8.Apttus_Config2__BasePrice__c = 100;
        lineitem8.Apttus_Config2__BasePriceMethod__c = 'Per Unit';
        lineitem8.Apttus_Config2__BillingFrequency__c = 'Monthly';
        lineitem8.Apttus_Config2__ChargeType__c = 'Subscription Fee';
        lineitem8.Apttus_Config2__ConfigStatus__c = 'Complete';
        lineitem8.Apttus_Config2__ConstraintCheckStatus__c = 'NA';
        lineitem8.Apttus_Config2__Customizable__c = FALSE;
        lineitem8.Apttus_Config2__DeltaPrice__c = 50;
        lineitem8.Apttus_Config2__DeltaQuantity__c = 1;
        lineitem8.Apttus_Config2__Description__c = 'Westlaw Flex Plan $100/500';
        lineitem8.Apttus_Config2__ExtendedCost__c = 0;
        lineitem8.Apttus_Config2__ExtendedPrice__c = 100;
        lineitem8.Apttus_Config2__Frequency__c = 'Monthly';
        lineitem8.Apttus_Config2__Guidance__c = 'Red';       
        lineitem8.Apttus_Config2__IsOptionRollupLine__c = FALSE;
        lineitem8.Apttus_Config2__IsPrimaryLine__c = TRUE;
        lineitem8.Apttus_Config2__IsPrimaryRampLine__c = FALSE;
        lineitem8.Apttus_Config2__IsQuantityModifiable__c = FALSE;
        lineitem8.Apttus_Config2__IsReadOnly__c = FALSE;
        lineitem8.Apttus_Config2__IsSellingTermReadOnly__c = FALSE;
        lineitem8.Apttus_Config2__IsUsageTierModifiable__c = FALSE;
        lineitem8.Apttus_Config2__ItemSequence__c = 1;
        lineitem8.Apttus_Config2__LineNumber__c = 1;
        lineitem8.Apttus_Config2__LineSequence__c = 1;
        lineitem8.Apttus_Config2__LineStatus__c = 'New';
        lineitem8.Apttus_Config2__LineType__c = 'Product/Service';
        lineitem8.Apttus_Config2__ListPrice__c = 100;
        lineitem8.Apttus_Config2__NetAdjustmentPercent__c = -50;
        lineitem8.Apttus_Config2__NetPrice__c = 50;
        lineitem8.Apttus_Config2__NetUnitPrice__c = 50;
        lineitem8.Apttus_Config2__OptionSequence__c = 0;
        lineitem8.Apttus_Config2__PriceIncludedInBundle__c = FALSE;
        lineitem8.Apttus_Config2__PriceMethod__c = 'Per Unit';
        lineitem8.Apttus_Config2__PriceType__c = 'Recurring';
        lineitem8.Apttus_Config2__PriceUom__c = 'Each';
        lineitem8.Apttus_Config2__PricingStatus__c = 'Complete';
        lineitem8.Apttus_Config2__PrimaryLineNumber__c = 1;
        lineitem8.Apttus_Config2__ProductVersion__c = 1;
        lineitem8.Apttus_Config2__Quantity__c = 1;
        lineitem8.Apttus_Config2__RollupPriceToBundle__c = TRUE;
        lineitem8.Apttus_Config2__SellingFrequency__c = 'Monthly';
        lineitem8.Apttus_Config2__SellingTerm__c = 1;
        lineitem8.Apttus_Config2__SyncStatus__c = 'Pending';
        lineitem8.Apttus_Config2__Taxable__c = FALSE;
        lineitem8.Apttus_Config2__TaxInclusive__c = FALSE;
        lineitem8.Apttus_Config2__Term__c = 1;
        lineitem8.Apttus_Config2__TotalQuantity__c = 1;
        lineitem8.Apttus_Config2__Uom__c = 'Each';
        lineitem8.Apttus_CQApprov__Approval_Status__c = 'Pending Approval';
        lineitem8.CurrencyIsoCode = 'USD';
        lineitem8.APTS_Product_Family__c = 'Non-Clear';
        lineitem8.APTS_Contract_Term__c = '2 Years';
        lineitem8.APTS_Years_2_Plus_Adjustment__c = '2';         
        updateList.add(lineItem8);
        
        /*lineitem11.APTS_Product_Delivery__c = 'Bundle';
        updateList.add(lineItem11);
        
        lineitem12.APTS_Product_Delivery__c = 'Pick 2';
        updateList.add(lineItem12);*/
        
        update updateList;
        System.debug('@@@@@@@'+p.APTS_Proposal_Business_Unit__c+'^^^^^^^^^'+lineitem8.APTS_Approval_Always_Required__c+lineitem2.APTS_Years_2_Plus_Adjustment__c+lineitem3.APTS_Years_2_Plus_Adjustment__c+lineitem4.APTS_Years_2_Plus_Adjustment__c+lineitem9.APTS_Approval_Always_Required__c);
        test.startTest();  
        APTS_LineItemTriggerHelper.calculateIncrementGrowth(prodConf.id);
        APTS_LineItemTriggerHelper.calculateIncrementGrowth(prodConf1.id);
        APTS_LineItemTriggerHelper.calculateIncrementGrowth(prodConf2.id);
        APTS_LineItemTriggerHelper.populateAllApprovalRequiredCB(insertList);       
        test.stopTest();        
        
    }

   static testMethod void canadaApprovalTest() {
        
        List<KeyValueListStore__c> keyvaluestoreList = new List<KeyValueListStore__c>();
        KeyValueListStore__c keyvaluestore=new  KeyValueListStore__c();
        keyvaluestore.Name='ANZUsersProfileId';
        keyvaluestore.TextValue__c=System.Label.APTS_OC_Test_Id;
        keyvaluestoreList.add(keyvaluestore); 
        KeyValueListStore__c keyval = new KeyValueListStore__c();
        keyval.Name='ReasonWithCompetitor';
        keyval.TextValue__c='Price';
        keyvaluestoreList.add(keyval);
        insert keyvaluestoreList;
        
        //Inserting recordLists
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
        
        List<APTS_Segment_Threshold__c> segthrList= new List<APTS_Segment_Threshold__c>();
        //Add Segment threshold
        APTS_Segment_Threshold__c seg1 = new APTS_Segment_Threshold__c();
        seg1.APTS_Approval_Required__c=True;
        seg1.APTS_Segment__c='Small Law';
        seg1.APTS_Customer_Category__c='5';
        seg1.APTS_Term_in_years__c=Integer.ValueOf('2');
        seg1.APTS_Minimum_OY_Increase__c=Integer.ValueOf('15');
        seg1.APTS_Minimum_Incremental_Growth__c=Integer.ValueOf('15');
        seg1.APTS_Product_Family__c = 'CLEAR';
        seg1.APTS_Promo_Codes__c = '13843014';
        seg1.APTS_Promo_Minimum_OY_Increase__c = 17;        
        segthrList.add(seg1);
        
        APTS_Segment_Threshold__c seg2 = new APTS_Segment_Threshold__c();
        seg2.APTS_Approval_Required__c=True;
        seg2.APTS_Segment__c='Corporate';
        seg2.APTS_Customer_Category__c='5';
        seg2.APTS_Term_in_years__c=Integer.ValueOf('2');
        seg2.APTS_Minimum_OY_Increase__c=Integer.ValueOf('15');
        seg2.APTS_Minimum_Incremental_Growth__c=Integer.ValueOf('15');
        seg2.APTS_Product_Family__c = 'CLEAR';
        seg2.APTS_Promo_Codes__c = '13843013';
        seg2.APTS_Promo_Minimum_OY_Increase__c = 16;        
        segthrList.add(seg2);
        system.assertEquals(seg2.APTS_Promo_Codes__c,'13843013');

        APTS_Segment_Threshold__c seg3 = new APTS_Segment_Threshold__c();
        seg3.APTS_Approval_Required__c=True;
        seg3.APTS_Segment__c='Corporate';
        seg3.APTS_Customer_Category__c='5';
        seg3.APTS_Term_in_years__c=Integer.ValueOf('2');
        seg3.APTS_Minimum_OY_Increase__c=Integer.ValueOf('15');
        seg3.APTS_Minimum_Incremental_Growth__c=Integer.ValueOf('15');
        segthrList.add(seg3);       
      
        APTS_Segment_Threshold__c seg4 = new APTS_Segment_Threshold__c();
        seg4.APTS_Approval_Required__c=True;
        seg4.APTS_Segment__c='Government';
        seg4.APTS_Customer_Category__c='5';
        seg4.APTS_Term_in_years__c=Integer.ValueOf('2');
        seg4.APTS_Minimum_OY_Increase__c=Integer.ValueOf('15');
        seg4.APTS_Minimum_Incremental_Growth__c=Integer.ValueOf('15');
        seg4.APTS_Product_Family__c = 'CLEAR';
        seg4.APTS_Promo_Codes__c = '13843012';
        seg4.APTS_Promo_Minimum_OY_Increase__c = 15;        
        segthrList.add(seg4);
        
        insert segthrList;
        
        Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
        Account a = new Account(RecordTypeId=accRecordTypeId,name='test-sg',sales_org__c='ABEP',customer_group__c='Academic',customer_type__c='Organization',customer_class_c__c='Academic Lecturer');
        a.APTS_Customer_Category__c = '5';
        a.Is_GLI__c = True;
        insert a;        
        
        Schema.DescribeFieldResult fieldResultMarket = Apttus_Config2__ProductConfiguration__c.APTS_AccountMirror_Picklist__c.getDescribe();
        String valueMarket = fieldResultMarket.getPicklistValues().get(0).getValue();
        
        //Inserting SourceSystemDetail
        List<Source_System_Detail__c> listOfSSD = new List<Source_System_Detail__c>();
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();
        Source_System_Detail__c accountSSD= new Source_System_Detail__c();
        accountSSD.RecordtypeId=ssdRecorType;
        accountSSD.Name='ABC';
        accountSSD.Source_System_Name__c='ABC';
        accountSSD.Account_Name__c=a.ID;
        accountSSD.APTS_Customer_Category__c='1';
        accountSSD.LCRM_Customer_Group__c='Academic';
        accountSSD.LCRM_Frozen_Market_Segment__c = valueMarket;
        accountSSD.Account_Inactive__c=false;
        accountSSD.LCRM_Sales_Org__c='CARS';
        accountSSD.APTS_Has_Online_Assets__c=false;        
        listOfSSD.add(accountSSD);

        Source_System_Detail__c accountSSD2= new Source_System_Detail__c();
        accountSSD2.RecordtypeId=ssdRecorType;
        accountSSD2.Name='ABC';
        accountSSD2.Source_System_Name__c='ABC';
        accountSSD2.Account_Name__c=a.ID;
        accountSSD2.APTS_Customer_Category__c='1';
        accountSSD2.LCRM_Customer_Group__c='Academic';
        accountSSD2.LCRM_Frozen_Market_Segment__c = valueMarket;
        accountSSD2.Account_Inactive__c=false;
        accountSSD2.LCRM_Sales_Org__c='CARS';
        accountSSD2.APTS_Has_Online_Assets__c=true;        
        listOfSSD.add(accountSSD2);
        insert listOfSSD;
        
        Date todaysDate = system.today();
        Id oppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Pipeline Opportunity').getRecordTypeId();
        Opportunity o = new Opportunity(RecordTypeId=oppRecordTypeId,  Name='tst-opp', stagename='25%',closedate=todaysDate,forecastcategoryname='pipeline',accountId=a.id);
        insert o;
        
        List<Apttus_Proposal__Proposal__c > listofProposals=new List<Apttus_Proposal__Proposal__c >();
        Id devRecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Proposal').getRecordTypeId();
        Apttus_Proposal__Proposal__c p = new Apttus_Proposal__Proposal__c(RecordTypeId=devRecordTypeId, CurrencyIsoCode = 'CAD', APTS_Approval_Segment__c='Canada',Apttus_Proposal__Account__c=a.id,Apttus_Proposal__Proposal_Name__c='TST-10',  Apttus_Proposal__Opportunity__c=o.id, Apttus_Proposal__Approval_Stage__c='Draft', Apttus_Proposal__Proposal_Category__c='Quote', Apttus_Proposal__ReadyToGenerate__c = true, Apttus_Proposal__ReadyToPresent__c= true,APTS_SSD_Sold_To__c=accountSSD.Id,APTS_SSD_ship_to__c=accountSSD.Id,APTS_SSD_bill_to__c=accountSSD.Id);
        p.APTS_Proposal_Business_Unit__c = 'Canada';
        p.APTS_Approval_Segment__c = 'Small Law';
        listofProposals.add(p);
        
        Apttus_Proposal__Proposal__c p2 = new Apttus_Proposal__Proposal__c(RecordTypeId=devRecordTypeId, CurrencyIsoCode = 'USD', Apttus_Proposal__Account__c=a.id,APTS_Approval_Segment__c='Canada',
            Apttus_Proposal__Proposal_Name__c='Corporate Proposal for approval',  Apttus_Proposal__Opportunity__c=o.id, 
            Apttus_Proposal__Approval_Stage__c='Draft', Apttus_Proposal__Proposal_Category__c='Quote', Apttus_Proposal__ReadyToGenerate__c = true, 
            Apttus_Proposal__ReadyToPresent__c= true,APTS_SSD_Sold_To__c=accountSSD2.Id,APTS_SSD_ship_to__c=accountSSD2.Id,
            APTS_SSD_bill_to__c=accountSSD2.Id);
        p2.APTS_Proposal_Business_Unit__c = 'Canada';
        p2.APTS_Approval_Segment__c = 'Medium Law';
        listofProposals.add(p2);
        
        Apttus_Proposal__Proposal__c p3 = new Apttus_Proposal__Proposal__c(RecordTypeId=devRecordTypeId, CurrencyIsoCode = 'CAD', Apttus_Proposal__Account__c=a.id,Apttus_Proposal__Proposal_Name__c='TST-10',  Apttus_Proposal__Opportunity__c=o.id, APTS_Approval_Segment__c='Canada',Apttus_Proposal__Approval_Stage__c='Draft', Apttus_Proposal__Proposal_Category__c='Quote', Apttus_Proposal__ReadyToGenerate__c = true, Apttus_Proposal__ReadyToPresent__c= true,APTS_SSD_Sold_To__c=accountSSD.Id,APTS_SSD_ship_to__c=accountSSD.Id,APTS_SSD_bill_to__c=accountSSD.Id);
        p3.APTS_Proposal_Business_Unit__c = 'SCS';
        p3.APTS_Approval_Segment__c = 'Small Law';
        listofProposals.add(p3);
        
        insert listofProposals;
        
        List<Apttus_Config2__ProductConfiguration__c> listofProdconfig = new List<Apttus_Config2__ProductConfiguration__c >();
        Apttus_Config2__ProductConfiguration__c prodConf = new Apttus_Config2__ProductConfiguration__c(Name='prod-conf1', CurrencyIsoCode = 'CAD', Apttus_QPConfig__Proposald__c=p.id, APTS_SSD_ship_to__c=accountSSD.Id,APTS_SSD_bill_to__c=accountSSD.Id);
        listofProdconfig.add(prodConf);
        Apttus_Config2__ProductConfiguration__c prodConf2 = new Apttus_Config2__ProductConfiguration__c(Name='prod-conf2', CurrencyIsoCode = 'CAD', Apttus_QPConfig__Proposald__c=p2.id, APTS_SSD_ship_to__c=accountSSD2.Id,APTS_SSD_bill_to__c=accountSSD2.Id);
        listofProdconfig.add(prodConf2);
        Apttus_Config2__ProductConfiguration__c prodConf3 = new Apttus_Config2__ProductConfiguration__c(Name='prod-conf2', CurrencyIsoCode = 'USD', Apttus_QPConfig__Proposald__c=p3.id, APTS_SSD_ship_to__c=accountSSD.Id,APTS_SSD_bill_to__c=accountSSD.Id);
        listofProdconfig.add(prodConf3);
        insert listofProdconfig;
        List<Product2 > listofProd=new List<Product2 > ();
        Product2 prod = new Product2(name='prod1', Media_High_Level__c='Online', CurrencyIsoCode = 'CAD',APTS_Media_High_Level_Code__c='06',APTS_Media_Lower_Level_Code__c='49',APTS_Cat_L2__c = System.Label.APTS_Print_Product_Family,APTS_CAT_L3__c='L3_L030_FP');
        prod.APTS_Approval_Always_Required__c = true;
        listofProd.add( prod);
        Product2 prod2 = new Product2(name='prod2', Media_High_Level__c='Online', CurrencyIsoCode = 'CAD',APTS_Media_High_Level_Code__c='06',APTS_Media_Lower_Level_Code__c='49',APTS_CAT_L2__c=System.Label.APTS_Clear_Product_Family,APTS_CAT_L3__c='L3_L030_FP');
        prod2.APTS_Approval_Always_Required__c = true;
        listofProd.add( prod2);
        insert listofProd;
        
        Apttus_Config2__ConfigSystemProperties__c configSetting=new Apttus_Config2__ConfigSystemProperties__c(Name='System Properties',Apttus_Config2__DisableConstraintRules__c=true);
        insert configSetting;

        test.startTest();
        List<Apttus_Config2__LineItem__c> listOfLineItems = new List<Apttus_Config2__LineItem__c>();
        
        Apttus_Config2__LineItem__c li3 = new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c=prodConf.id , Apttus_Config2__ProductId__c=prod2.id);
        li3.Apttus_Config2__AddedBy__c = 'User';
        li3.Apttus_Config2__AdjustedPrice__c = 50;
        
        li3.Apttus_Config2__AdjustmentAmount__c = 50;
        li3.Apttus_Config2__AdjustmentType__c = '% Discount';
        li3.Apttus_Config2__AllocateGroupAdjustment__c = TRUE;
        li3.Apttus_Config2__AllowableAction__c = 'Unrestricted';
        li3.Apttus_Config2__AllowManualAdjustment__c = TRUE;
        li3.Apttus_Config2__AllowProration__c = FALSE;
        li3.Apttus_Config2__AllowRemoval__c = TRUE;
        li3.Apttus_Config2__AutoRenew__c = FALSE;
        li3.Apttus_Config2__BaseExtendedCost__c = 0;
        li3.Apttus_Config2__BaseExtendedPrice__c = 100;
        li3.Apttus_Config2__BasePrice__c = 100;
        li3.Apttus_Config2__BasePriceMethod__c = 'Per Unit';
        li3.Apttus_Config2__BillingFrequency__c = 'Monthly';
        li3.Apttus_Config2__ChargeType__c = 'Subscription Fee';
        li3.Apttus_Config2__ConfigStatus__c = 'Complete';
        li3.Apttus_Config2__ConstraintCheckStatus__c = 'NA';
        li3.Apttus_Config2__Customizable__c = FALSE;
        li3.Apttus_Config2__DeltaPrice__c = 50;
        li3.Apttus_Config2__DeltaQuantity__c = 1;
        li3.Apttus_Config2__Description__c = 'Westlaw Flex Plan $100/500';
        li3.Apttus_Config2__ExtendedCost__c = 0;
        li3.Apttus_Config2__ExtendedPrice__c = 100;
        li3.Apttus_Config2__Frequency__c = 'Monthly';
        li3.Apttus_Config2__Guidance__c = 'Red';
        li3.Apttus_Config2__HasAttributes__c = FALSE;
        li3.Apttus_Config2__HasBaseProduct__c = FALSE;
        li3.Apttus_Config2__HasDefaults__c = FALSE;
        li3.Apttus_Config2__HasIncentives__c = FALSE;
        li3.Apttus_Config2__HasOptions__c = FALSE;
        li3.Apttus_Config2__HasTieredPrice__c = FALSE;
        li3.Apttus_Config2__HideCopyAction__c = FALSE;
        li3.Apttus_Config2__HideInvoiceDisplay__c = FALSE;
        li3.Apttus_Config2__IsAssetPricing__c = FALSE;
        li3.Apttus_Config2__IsCustomPricing__c = FALSE;
        li3.Apttus_Config2__IsHidden__c = FALSE;
        li3.Apttus_Config2__IsOptionRollupLine__c = FALSE;
        li3.Apttus_Config2__IsPrimaryLine__c = TRUE;
        li3.Apttus_Config2__IsPrimaryRampLine__c = FALSE;
        li3.Apttus_Config2__IsQuantityModifiable__c = FALSE;
        li3.Apttus_Config2__IsReadOnly__c = FALSE;
        li3.Apttus_Config2__IsSellingTermReadOnly__c = FALSE;
        li3.Apttus_Config2__IsUsageTierModifiable__c = FALSE;
        li3.Apttus_Config2__ItemSequence__c = 1;
        li3.Apttus_Config2__LineNumber__c = 1;
        li3.Apttus_Config2__LineSequence__c = 1;
        li3.Apttus_Config2__LineStatus__c = 'Renewed';
        li3.APTS_Yr_1_Renewal_Adjustment__c='1';
        li3.Apttus_Config2__LineType__c = 'Product/Service';
        li3.Apttus_Config2__ListPrice__c = 100;
        li3.Apttus_Config2__NetAdjustmentPercent__c = -50;
        li3.Apttus_Config2__NetPrice__c = 50;
        li3.Apttus_Config2__NetUnitPrice__c = 50;
        li3.Apttus_Config2__OptionSequence__c = 0;
        li3.Apttus_Config2__PriceIncludedInBundle__c = FALSE;
        li3.Apttus_Config2__PriceMethod__c = 'Per Unit';
        li3.Apttus_Config2__PriceType__c = 'Recurring';
        li3.Apttus_Config2__PriceUom__c = 'Each';
        li3.Apttus_Config2__PricingStatus__c = 'Complete';
        li3.Apttus_Config2__PrimaryLineNumber__c = 1;
        li3.Apttus_Config2__ProductVersion__c = 1;
        li3.APTS_Product_Family__c='RUTTER';
        //li3.APTS_Cat_L3__c = System.Label.APTS_Rutter_Product_Family;
        li3.Apttus_Config2__Quantity__c = 1;
        li3.Apttus_Config2__RollupPriceToBundle__c = TRUE;
        li3.Apttus_Config2__SellingFrequency__c = 'Monthly';
        li3.Apttus_Config2__SellingTerm__c = 1;
        li3.Apttus_Config2__SyncStatus__c = 'Pending';
        li3.Apttus_Config2__Taxable__c = FALSE;
        li3.Apttus_Config2__TaxInclusive__c = FALSE;
        //li3.Apttus_Config2__Term__c = 1;
        li3.Apttus_Config2__TotalQuantity__c = 1;
        li3.Apttus_Config2__Uom__c = 'Each';
        //li3.Apttus_CQApprov__Approval_Status__c = 'Pending Approval';
        li3.CurrencyIsoCode = 'CAD';
        li3.APTS_Product_Family__c = 'CLEAR';
        //li3.APTS_Cat_L2__c = System.Label.APTS_Clear_Product_Family;
        li3.APTS_Contract_Term__c = '1 Year';
        li3.APTS_Years_2_Plus_Adjustment__c = '5';
        li3.APTS_Bridge__c = '2 Months';
        listOfLineItems.add(li3);
        
        Apttus_Config2__AssetLineItem__c asset = new Apttus_Config2__AssetLineItem__c(Name = 'Test asset', APTS_Info_PlanType__c = 'S00', 
                                                                                      Apttus_Config2__NetPrice__c = 10.00, APTS_SSD_Bill_To__c = accountSSD.Id,
                                                                                      Apttus_QPConfig__ProposalId__c =p3.id,
                                                                                      APTS_Info_RenewalDate__c = System.today().addDays(-150),Apttus_Config2__BasePriceMethod__c = 'Flat Price');
         insert asset;                                                                             
        
        
                
        Apttus_Config2__LineItem__c li4 = new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c=prodConf.id , Apttus_Config2__ProductId__c=prod2.id);
        li4.Apttus_Config2__AddedBy__c = 'User';
        li4.Apttus_Config2__AdjustedPrice__c = 50;
        li4.Apttus_Config2__AdjustmentAmount__c = 50;
        li4.Apttus_Config2__AdjustmentType__c = '% Discount';
        li4.Apttus_Config2__AllocateGroupAdjustment__c = TRUE;
        li4.Apttus_Config2__AllowableAction__c = 'Unrestricted';
        li4.Apttus_Config2__AllowManualAdjustment__c = TRUE;
        li4.Apttus_Config2__AllowProration__c = FALSE;
        li4.Apttus_Config2__AllowRemoval__c = TRUE;
        li4.Apttus_Config2__AutoRenew__c = FALSE;
        li4.Apttus_Config2__BaseExtendedCost__c = 0;
        li4.Apttus_Config2__BaseExtendedPrice__c = 100;
        li4.Apttus_Config2__BasePrice__c = 100;
        li4.Apttus_Config2__BasePriceMethod__c = 'Per Unit';
        li4.Apttus_Config2__BillingFrequency__c = 'Monthly';
        li4.Apttus_Config2__ChargeType__c = 'Subscription Fee';
        li4.Apttus_Config2__ConfigStatus__c = 'Complete';
        li4.Apttus_Config2__ConstraintCheckStatus__c = 'NA';
        li4.Apttus_Config2__Customizable__c = FALSE;
        li4.Apttus_Config2__DeltaPrice__c = 50;
        li4.Apttus_Config2__DeltaQuantity__c = 1;
        li4.Apttus_Config2__Description__c = 'Westlaw Flex Plan $100/500';
        li4.Apttus_Config2__ExtendedCost__c = 0;
        li4.Apttus_Config2__ExtendedPrice__c = 100;
        li4.Apttus_Config2__Frequency__c = 'Monthly';
        li4.Apttus_Config2__Guidance__c = 'Red';       
        li4.Apttus_Config2__IsPrimaryLine__c = TRUE;        
        li4.Apttus_Config2__ItemSequence__c = 1;
        li4.Apttus_Config2__LineNumber__c = 1;
        li4.Apttus_Config2__LineSequence__c = 1;
        li4.Apttus_Config2__LineStatus__c = 'New';
        li4.APTS_Yr_1_Renewal_Adjustment__c='1';
        li4.Apttus_Config2__LineType__c = 'Product/Service';
        li4.Apttus_Config2__ListPrice__c = 100;
        li4.Apttus_Config2__NetAdjustmentPercent__c = -50;
        li4.Apttus_Config2__NetPrice__c = 50;
        li4.Apttus_Config2__NetUnitPrice__c = 50;
        li4.Apttus_Config2__OptionSequence__c = 0;        
        li4.Apttus_Config2__PriceMethod__c = 'Per Unit';
        li4.Apttus_Config2__PriceType__c = 'Recurring';
        li4.Apttus_Config2__PriceUom__c = 'Attorneys';
        li4.Apttus_Config2__PricingStatus__c = 'Complete';       
        li4.APTS_Product_Family__c='RUTTER';
        //li4.APTS_Cat_L3__c = System.Label.APTS_Rutter_Product_Family;
        li4.Apttus_Config2__Quantity__c = 1;
        li4.Apttus_Config2__RollupPriceToBundle__c = TRUE;
        li4.Apttus_Config2__SellingFrequency__c = 'Monthly';
        li4.Apttus_Config2__SellingTerm__c = 1;        
        li4.Apttus_Config2__Taxable__c = FALSE;
        li4.Apttus_Config2__TaxInclusive__c = FALSE;
        li4.Apttus_Config2__Term__c = 1;
        li4.Apttus_Config2__TotalQuantity__c = 1;
        li4.Apttus_Config2__Uom__c = 'Each';        
        li4.CurrencyIsoCode = 'CAD';
        li4.APTS_Product_Family__c = 'CLEAR';
        //li4.APTS_Cat_L2__c = System.Label.APTS_Clear_Product_Family;
        li4.APTS_Contract_Term__c = '2 Years';
        li4.APTS_Years_2_Plus_Adjustment__c = '5';
        li4.Apttus_Config2__IncentiveCode__c = '13843012,13843012';
        li4.APTS_Bridge__c='1 Month';                   
        listOfLineItems.add(li4);

        Apttus_Config2__LineItem__c li5 = new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c=prodConf.id , Apttus_Config2__ProductId__c=prod2.id);
        li5.Apttus_Config2__AddedBy__c = 'User';
        li5.Apttus_Config2__AdjustedPrice__c = 50;
        li5.Apttus_Config2__AdjustmentAmount__c = 50;
        li5.Apttus_Config2__AdjustmentType__c = '% Discount';
        li5.Apttus_Config2__AllocateGroupAdjustment__c = TRUE;
        li5.Apttus_Config2__AllowableAction__c = 'Unrestricted';
        li5.Apttus_Config2__AllowManualAdjustment__c = TRUE;
        li5.Apttus_Config2__AllowProration__c = FALSE;
        li5.Apttus_Config2__AllowRemoval__c = TRUE;
        li5.Apttus_Config2__AutoRenew__c = FALSE;
        li5.Apttus_Config2__BaseExtendedCost__c = 0;
        li5.Apttus_Config2__BaseExtendedPrice__c = 100;
        li5.Apttus_Config2__BasePrice__c = 100;
        li5.Apttus_Config2__BasePriceMethod__c = 'Per Unit';
        li5.Apttus_Config2__BillingFrequency__c = 'Monthly';
        li5.Apttus_Config2__ChargeType__c = 'Subscription Fee';
        li5.Apttus_Config2__ConfigStatus__c = 'Complete';
        li5.Apttus_Config2__ConstraintCheckStatus__c = 'NA';
        li5.Apttus_Config2__Customizable__c = FALSE;
        li5.Apttus_Config2__DeltaPrice__c = 50;
        li5.Apttus_Config2__DeltaQuantity__c = 1;
        li5.Apttus_Config2__Description__c = 'Westlaw Flex Plan $100/500';
        li5.Apttus_Config2__ExtendedCost__c = 0;
        li5.Apttus_Config2__ExtendedPrice__c = 100;
        li5.Apttus_Config2__Frequency__c = 'Monthly';
        li5.Apttus_Config2__Guidance__c = 'Red';       
        li5.Apttus_Config2__IsPrimaryLine__c = TRUE;        
        li5.Apttus_Config2__ItemSequence__c = 1;
        li5.Apttus_Config2__LineNumber__c = 1;
        li5.Apttus_Config2__LineSequence__c = 1;
        li5.Apttus_Config2__LineStatus__c = 'New';
        li5.APTS_Yr_1_Renewal_Adjustment__c='1';
        li5.Apttus_Config2__LineType__c = 'Product/Service';
        li5.Apttus_Config2__ListPrice__c = 100;
        li5.Apttus_Config2__NetAdjustmentPercent__c = -50;
        li5.Apttus_Config2__NetPrice__c = 50;
        li5.Apttus_Config2__NetUnitPrice__c = 50;
        li5.Apttus_Config2__OptionSequence__c = 0;        
        li5.Apttus_Config2__PriceMethod__c = 'Per Unit';
        li5.Apttus_Config2__PriceType__c = 'Recurring';
        li5.Apttus_Config2__PriceUom__c = 'Attorneys';
        li5.Apttus_Config2__PricingStatus__c = 'Complete';       
        li5.APTS_Product_Family__c='RUTTER';
        //li5.APTS_Cat_L3__c = System.Label.APTS_Rutter_Product_Family;
        li5.Apttus_Config2__Quantity__c = 1;
        li5.Apttus_Config2__RollupPriceToBundle__c = TRUE;
        li5.Apttus_Config2__SellingFrequency__c = 'Monthly';
        li5.Apttus_Config2__SellingTerm__c = 1;        
        li5.Apttus_Config2__Taxable__c = FALSE;
        li5.Apttus_Config2__TaxInclusive__c = FALSE;
        li5.Apttus_Config2__Term__c = 1;
        li5.Apttus_Config2__TotalQuantity__c = 1;
        li5.Apttus_Config2__Uom__c = 'Each';        
        li5.CurrencyIsoCode = 'CAD';
        li5.APTS_Product_Family__c = 'CLEAR';
       // li5.APTS_Cat_L2__c = System.Label.APTS_Clear_Product_Family;
        li5.APTS_Contract_Term__c = '2 Years';
        li5.APTS_Years_2_Plus_Adjustment__c = '5';
        li5.Apttus_Config2__IncentiveCode__c = '13843012,13843012';
        li5.APTS_Bridge__c='1 Month';                   
        listOfLineItems.add(li5);

        Apttus_Config2__LineItem__c li6 = new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c=prodConf.id , Apttus_Config2__ProductId__c=prod2.id);
        li6.Apttus_Config2__AddedBy__c = 'User';
        li6.Apttus_Config2__AdjustedPrice__c = 50;
        li6.Apttus_Config2__AdjustmentAmount__c = 50;
        li6.Apttus_Config2__AdjustmentType__c = '% Discount';
        li6.Apttus_Config2__AllocateGroupAdjustment__c = TRUE;
        li6.Apttus_Config2__AllowableAction__c = 'Unrestricted';
        li6.Apttus_Config2__AllowManualAdjustment__c = TRUE;
        li6.Apttus_Config2__AllowProration__c = FALSE;
        li6.Apttus_Config2__AllowRemoval__c = TRUE;
        li6.Apttus_Config2__AutoRenew__c = FALSE;
        li6.Apttus_Config2__BaseExtendedCost__c = 0;
        li6.Apttus_Config2__BaseExtendedPrice__c = 100;
        li6.Apttus_Config2__BasePrice__c = 100;
        li6.Apttus_Config2__BasePriceMethod__c = 'Per Unit';
        li6.Apttus_Config2__BillingFrequency__c = 'Monthly';
        li6.Apttus_Config2__ChargeType__c = 'Subscription Fee';
        li6.Apttus_Config2__ConfigStatus__c = 'Complete';
        li6.Apttus_Config2__ConstraintCheckStatus__c = 'NA';
        li6.Apttus_Config2__Customizable__c = FALSE;
        li6.Apttus_Config2__DeltaPrice__c = 50;
        li6.Apttus_Config2__DeltaQuantity__c = 1;
        li6.Apttus_Config2__Description__c = 'Westlaw Flex Plan $100/500';
        li6.Apttus_Config2__ExtendedCost__c = 0;
        li6.Apttus_Config2__ExtendedPrice__c = 100;
        li6.Apttus_Config2__Frequency__c = 'Monthly';
        li6.Apttus_Config2__Guidance__c = 'Red';       
        li6.Apttus_Config2__IsPrimaryLine__c = TRUE;        
        li6.Apttus_Config2__ItemSequence__c = 1;
        li6.Apttus_Config2__LineNumber__c = 1;
        li6.Apttus_Config2__LineSequence__c = 1;
        li6.Apttus_Config2__LineStatus__c = 'New';
        li6.APTS_Yr_1_Renewal_Adjustment__c='1';
        li6.Apttus_Config2__LineType__c = 'Product/Service';
        li6.Apttus_Config2__ListPrice__c = 100;
        li6.Apttus_Config2__NetAdjustmentPercent__c = -50;
        li6.Apttus_Config2__NetPrice__c = 50;
        li6.Apttus_Config2__NetUnitPrice__c = 50;
        li6.Apttus_Config2__OptionSequence__c = 0;        
        li6.Apttus_Config2__PriceMethod__c = 'Per Unit';
        li6.Apttus_Config2__PriceType__c = 'Recurring';
        li6.Apttus_Config2__PriceUom__c = 'Attorneys';
        li6.Apttus_Config2__PricingStatus__c = 'Complete';       
        li6.APTS_Product_Family__c='RUTTER';
        //li6.APTS_Cat_L3__c = System.Label.APTS_Rutter_Product_Family;
        li6.Apttus_Config2__Quantity__c = 1;
        li6.Apttus_Config2__RollupPriceToBundle__c = TRUE;
        li6.Apttus_Config2__SellingFrequency__c = 'Monthly';
        li6.Apttus_Config2__SellingTerm__c = 1;        
        li6.Apttus_Config2__Taxable__c = FALSE;
        li6.Apttus_Config2__TaxInclusive__c = FALSE;
        li6.Apttus_Config2__Term__c = 1;
        li6.Apttus_Config2__TotalQuantity__c = 1;
        li6.Apttus_Config2__Uom__c = 'Each';        
        li6.CurrencyIsoCode = 'CAD';
        li6.APTS_Product_Family__c = 'CLEAR';
        //li6.APTS_Cat_L2__c = System.Label.APTS_Clear_Product_Family;
        li6.APTS_Contract_Term__c = '2 Years';
        li6.APTS_Years_2_Plus_Adjustment__c = '5';
        li6.Apttus_Config2__IncentiveCode__c = '13843012,13843012';
        li6.APTS_Bridge__c='1 Month';                  
        listOfLineItems.add(li6);
        
        Apttus_Config2__LineItem__c li7 = new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c=prodConf2.id , Apttus_Config2__ProductId__c=prod2.id);
        li7.Apttus_Config2__AddedBy__c = 'User';        
        li7.Apttus_Config2__BasePrice__c = 100;
        li7.Apttus_Config2__BasePriceMethod__c = 'Per Unit';
        li7.Apttus_Config2__BillingFrequency__c = 'Monthly';
        li7.Apttus_Config2__ChargeType__c = 'Subscription Fee';
        li7.Apttus_Config2__ConfigStatus__c = 'Complete';        
        li7.Apttus_Config2__Frequency__c = 'Monthly';        
        li7.Apttus_Config2__IsPrimaryLine__c = TRUE;        
        li7.Apttus_Config2__ItemSequence__c = 1;
        li7.Apttus_Config2__LineNumber__c = 1;
        li7.Apttus_Config2__LineSequence__c = 1;
        li7.Apttus_Config2__LineStatus__c = 'New';
        li7.APTS_Yr_1_Renewal_Adjustment__c='1';
        li7.Apttus_Config2__LineType__c = 'Product/Service';
        li7.Apttus_Config2__ListPrice__c = 100;        
        li7.Apttus_Config2__NetPrice__c = 50;
        li7.Apttus_Config2__NetUnitPrice__c = 50;        
        li7.Apttus_Config2__PriceMethod__c = 'Per Unit';
        li7.Apttus_Config2__PriceType__c = 'Recurring';
        li7.Apttus_Config2__PriceUom__c = 'Each';
        li7.Apttus_Config2__PricingStatus__c = 'Complete';
        li7.Apttus_Config2__PrimaryLineNumber__c = 1;
        li7.Apttus_Config2__ProductVersion__c = 1;        
        li7.Apttus_Config2__Quantity__c = 1;
        li7.Apttus_Config2__RollupPriceToBundle__c = TRUE;
        li7.Apttus_Config2__SellingFrequency__c = 'Monthly';
        li7.Apttus_Config2__SellingTerm__c = 1;                               
        li7.Apttus_Config2__TotalQuantity__c = 1;
        li7.Apttus_Config2__Uom__c = 'Each';
        li7.Apttus_CQApprov__Approval_Status__c = 'Pending Approval';
        li7.CurrencyIsoCode = 'USD';
        li7.APTS_Product_Family__c = 'CLEAR';
        //li7.APTS_Cat_L2__c = System.Label.APTS_Clear_Product_Family;
        li7.APTS_Contract_Term__c = '1 Year';
        li7.APTS_Years_2_Plus_Adjustment__c = '5';
        li7.APTS_Bridge__c = '2 Months';
        listOfLineItems.add(li7);
        
                 
        Apttus_Config2__LineItem__c li8 = new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c=prodConf3.id , Apttus_Config2__ProductId__c=prod.id);
        li8.Apttus_Config2__AddedBy__c = 'User';       
        li8.Apttus_Config2__BaseExtendedCost__c = 0;
        li8.Apttus_Config2__BaseExtendedPrice__c = 100;
        li8.Apttus_Config2__BasePrice__c = 100;
        li8.Apttus_Config2__BasePriceMethod__c = 'Per Unit';
        li8.Apttus_Config2__BillingFrequency__c = 'Monthly';
        li8.Apttus_Config2__ChargeType__c = 'Subscription Fee';
        li8.Apttus_Config2__ConfigStatus__c = 'Complete';
        li8.Apttus_Config2__ConstraintCheckStatus__c = 'NA';
        li8.Apttus_Config2__Customizable__c = FALSE;
        li8.Apttus_Config2__DeltaPrice__c = 50;
        li8.Apttus_Config2__DeltaQuantity__c = 1;
        li8.Apttus_Config2__Description__c = 'Westlaw Flex Plan $100/500';
        li8.Apttus_Config2__ExtendedCost__c = 0;
        li8.Apttus_Config2__ExtendedPrice__c = 100;
        li8.Apttus_Config2__Frequency__c = 'Monthly';
        li8.Apttus_Config2__Guidance__c = 'Red';       
        li8.Apttus_Config2__IsPrimaryLine__c = TRUE;        
        li8.Apttus_Config2__ItemSequence__c = 1;
        li8.Apttus_Config2__LineNumber__c = 1;
        li8.Apttus_Config2__LineSequence__c = 1;
        li8.Apttus_Config2__LineStatus__c = 'New';
        li8.APTS_Yr_1_Renewal_Adjustment__c='1';
        li8.Apttus_Config2__LineType__c = 'Product/Service';
        li8.Apttus_Config2__ListPrice__c = 100;
        li8.Apttus_Config2__NetAdjustmentPercent__c = -50;
        li8.Apttus_Config2__NetPrice__c = 50;
        li8.Apttus_Config2__NetUnitPrice__c = 50;
        li8.Apttus_Config2__OptionSequence__c = 0;        
        li8.Apttus_Config2__PriceMethod__c = 'Per Unit';
        li8.Apttus_Config2__PriceType__c = 'Recurring';
        li8.Apttus_Config2__PriceUom__c = 'Attorneys';
        li8.Apttus_Config2__PricingStatus__c = 'Complete';
        li8.Apttus_Config2__Quantity__c = 1;
        li8.Apttus_Config2__RollupPriceToBundle__c = TRUE;
        li8.Apttus_Config2__SellingFrequency__c = 'Monthly';
        li8.Apttus_Config2__SellingTerm__c = 1;        
        li8.Apttus_Config2__Taxable__c = FALSE;
        li8.Apttus_Config2__TaxInclusive__c = FALSE;
        li8.Apttus_Config2__Term__c = 1;
        li8.Apttus_Config2__TotalQuantity__c = 1;
        li8.Apttus_Config2__Uom__c = 'Each';        
        li8.CurrencyIsoCode = 'USD';
        li8.APTS_Product_Family__c = 'PRINT LEGAL SOLUTIONS';
        //li8.APTS_Cat_L2__c = System.Label.APTS_Print_Product_Family;
        li8.APTS_Contract_Term__c = '2 Years';
        li8.APTS_Years_2_Plus_Adjustment__c = '5';        
        li8.APTS_Bridge__c='3 Months';                   
        listOfLineItems.add(li8);

       
        insert listOfLineItems;
          
             
        li3.APTS_Contract_Term__c = '3 Years';
        li3.APTS_Bridge__c='6 Months';       
        li4.APTS_Contract_Term__c = '1 Year';
        li4.APTS_Bridge__c='3 Months';  
        li5.APTS_Contract_Term__c = '4 Years';
        li5.APTS_Bridge__c='7 Months';  
        li6.APTS_Contract_Term__c = '5 Years';
        li6.APTS_Bridge__c='3 Months'; 
        li7.APTS_Contract_Term__c = '1 Year';
        li7.APTS_Bridge__c='2 Months'; 
        li8.APTS_Contract_Term__c = '1 Year';
        li8.APTS_Bridge__c='3 Months'; 

        update listOfLineItems;
        APTS_LineItemTriggerHelper.populateAllApprovalRequiredCB(listOfLineItems);
        Test.stopTest();        
    }
    static testMethod void corpAppSegApprovalTest() {
        
        List<KeyValueListStore__c> keyvaluestoreList = new List<KeyValueListStore__c>();
        KeyValueListStore__c keyvaluestore=new  KeyValueListStore__c();
        keyvaluestore.Name='ANZUsersProfileId';
        keyvaluestore.TextValue__c=System.Label.APTS_OC_Test_Id;
        keyvaluestoreList.add(keyvaluestore); 
        KeyValueListStore__c keyval = new KeyValueListStore__c();
        keyval.Name='ReasonWithCompetitor';
        keyval.TextValue__c='Price';
        keyvaluestoreList.add(keyval);
        insert keyvaluestoreList;
        
        //Inserting recordLists
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
        
        List<APTS_Segment_Threshold__c> segthrList= new List<APTS_Segment_Threshold__c>();
        //Add Segment threshold
        APTS_Segment_Threshold__c seg1 = new APTS_Segment_Threshold__c();
        seg1.APTS_Approval_Required__c=True;
        seg1.APTS_Segment__c='Small Law';
        seg1.APTS_Customer_Category__c='5';
        seg1.APTS_Term_in_years__c=Integer.ValueOf('2');
        seg1.APTS_Minimum_OY_Increase__c=Integer.ValueOf('15');
        seg1.APTS_Minimum_Incremental_Growth__c=Integer.ValueOf('15');
        seg1.APTS_Product_Family__c = 'CLEAR';
        seg1.APTS_Promo_Codes__c = '13843014';
        seg1.APTS_Promo_Minimum_OY_Increase__c = 17;        
        segthrList.add(seg1);
        
        APTS_Segment_Threshold__c seg2 = new APTS_Segment_Threshold__c();
        seg2.APTS_Approval_Required__c=True;
        seg2.APTS_Segment__c='Corporate';
        seg2.APTS_Customer_Category__c='5';
        seg2.APTS_Term_in_years__c=Integer.ValueOf('2');
        seg2.APTS_Minimum_OY_Increase__c=Integer.ValueOf('15');
        seg2.APTS_Minimum_Incremental_Growth__c=Integer.ValueOf('15');
        seg2.APTS_Product_Family__c = 'CLEAR';
        seg2.APTS_Promo_Codes__c = '13843013';
        seg2.APTS_Promo_Minimum_OY_Increase__c = 16;        
        segthrList.add(seg2);
        system.assertEquals(seg2.APTS_Promo_Codes__c,'13843013');

        APTS_Segment_Threshold__c seg3 = new APTS_Segment_Threshold__c();
        seg3.APTS_Approval_Required__c=True;
        seg3.APTS_Segment__c='Corporate';
        seg3.APTS_Customer_Category__c='5';
        seg3.APTS_Term_in_years__c=Integer.ValueOf('2');
        seg3.APTS_Minimum_OY_Increase__c=Integer.ValueOf('15');
        seg3.APTS_Minimum_Incremental_Growth__c=Integer.ValueOf('15');
        segthrList.add(seg3);       
      
        APTS_Segment_Threshold__c seg4 = new APTS_Segment_Threshold__c();
        seg4.APTS_Approval_Required__c=True;
        seg4.APTS_Segment__c='Government';
        seg4.APTS_Customer_Category__c='5';
        seg4.APTS_Term_in_years__c=Integer.ValueOf('2');
        seg4.APTS_Minimum_OY_Increase__c=Integer.ValueOf('15');
        seg4.APTS_Minimum_Incremental_Growth__c=Integer.ValueOf('15');
        seg4.APTS_Product_Family__c = 'CLEAR';
        seg4.APTS_Promo_Codes__c = '13843012';
        seg4.APTS_Promo_Minimum_OY_Increase__c = 15;        
        segthrList.add(seg4);
        
        insert segthrList;
        
        Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
        Account a = new Account(RecordTypeId=accRecordTypeId,name='test-sg',sales_org__c='ABEP',customer_group__c='Academic',customer_type__c='Organization',customer_class_c__c='Academic Lecturer');
        a.APTS_Customer_Category__c = '5';
        a.Is_GLI__c = True;
        insert a;        
        
        Schema.DescribeFieldResult fieldResultMarket = Apttus_Config2__ProductConfiguration__c.APTS_AccountMirror_Picklist__c.getDescribe();
        String valueMarket = fieldResultMarket.getPicklistValues().get(0).getValue();
        
        //Inserting SourceSystemDetail
        List<Source_System_Detail__c> listOfSSD = new List<Source_System_Detail__c>();
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();
        Source_System_Detail__c accountSSD= new Source_System_Detail__c();
        accountSSD.RecordtypeId=ssdRecorType;
        accountSSD.Name='ABC';
        accountSSD.Source_System_Name__c='ABC';
        accountSSD.Account_Name__c=a.ID;
        accountSSD.APTS_Customer_Category__c='1';
        accountSSD.LCRM_Customer_Group__c='Academic';
        accountSSD.LCRM_Frozen_Market_Segment__c = valueMarket;
        accountSSD.Account_Inactive__c=false;
        accountSSD.LCRM_Sales_Org__c='TA78';
        accountSSD.APTS_Has_Online_Assets__c=false;        
        listOfSSD.add(accountSSD);

        Source_System_Detail__c accountSSD2= new Source_System_Detail__c();
        accountSSD2.RecordtypeId=ssdRecorType;
        accountSSD2.Name='ABC';
        accountSSD2.Source_System_Name__c='ABC';
        accountSSD2.Account_Name__c=a.ID;
        accountSSD2.APTS_Customer_Category__c='1';
        accountSSD2.LCRM_Customer_Group__c='Academic';
        accountSSD2.LCRM_Frozen_Market_Segment__c = valueMarket;
        accountSSD2.Account_Inactive__c=false;
        accountSSD2.LCRM_Sales_Org__c='WEST';
        accountSSD2.APTS_Has_Online_Assets__c=true;        
        listOfSSD.add(accountSSD2);
        insert listOfSSD;
        
        Date todaysDate = system.today();
        Id oppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Pipeline Opportunity').getRecordTypeId();
        Opportunity o = new Opportunity(RecordTypeId=oppRecordTypeId,  Name='tst-opp', stagename='25%',closedate=todaysDate,forecastcategoryname='pipeline',accountId=a.id);
        insert o;
        
        List<Apttus_Proposal__Proposal__c > listofProposals=new List<Apttus_Proposal__Proposal__c >();
        Id devRecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Proposal').getRecordTypeId();
        Apttus_Proposal__Proposal__c p = new Apttus_Proposal__Proposal__c(RecordTypeId=devRecordTypeId, CurrencyIsoCode = 'CAD', Apttus_Proposal__Account__c=a.id,Apttus_Proposal__Proposal_Name__c='TST-10',  Apttus_Proposal__Opportunity__c=o.id, Apttus_Proposal__Approval_Stage__c='Draft', Apttus_Proposal__Proposal_Category__c='Quote', Apttus_Proposal__ReadyToGenerate__c = true, Apttus_Proposal__ReadyToPresent__c= true,APTS_SSD_Sold_To__c=accountSSD.Id,APTS_SSD_ship_to__c=accountSSD.Id,APTS_SSD_bill_to__c=accountSSD.Id);
        p.APTS_Proposal_Business_Unit__c = 'SCS';
        p.APTS_Approval_Segment__c = 'Corporate';
        listofProposals.add(p);
        
        Apttus_Proposal__Proposal__c p2 = new Apttus_Proposal__Proposal__c(RecordTypeId=devRecordTypeId, CurrencyIsoCode = 'USD', Apttus_Proposal__Account__c=a.id,
            Apttus_Proposal__Proposal_Name__c='Corporate Proposal for approval',  Apttus_Proposal__Opportunity__c=o.id, 
            Apttus_Proposal__Approval_Stage__c='Draft', Apttus_Proposal__Proposal_Category__c='Quote', Apttus_Proposal__ReadyToGenerate__c = true, 
            Apttus_Proposal__ReadyToPresent__c= true,APTS_SSD_Sold_To__c=accountSSD2.Id,APTS_SSD_ship_to__c=accountSSD2.Id,
            APTS_SSD_bill_to__c=accountSSD2.Id);
        p2.APTS_Proposal_Business_Unit__c = 'SCS';
        p2.APTS_Approval_Segment__c = 'Medium Law';
        listofProposals.add(p2);
        
        Apttus_Proposal__Proposal__c p3 = new Apttus_Proposal__Proposal__c(RecordTypeId=devRecordTypeId, CurrencyIsoCode = 'CAD', Apttus_Proposal__Account__c=a.id,Apttus_Proposal__Proposal_Name__c='TST-10',  Apttus_Proposal__Opportunity__c=o.id, APTS_Approval_Segment__c='Canada',Apttus_Proposal__Approval_Stage__c='Draft', Apttus_Proposal__Proposal_Category__c='Quote', Apttus_Proposal__ReadyToGenerate__c = true, Apttus_Proposal__ReadyToPresent__c= true,APTS_SSD_Sold_To__c=accountSSD.Id,APTS_SSD_ship_to__c=accountSSD.Id,APTS_SSD_bill_to__c=accountSSD.Id);
        p3.APTS_Proposal_Business_Unit__c = 'SCS';
        p3.APTS_Approval_Segment__c = 'Small Law';
        listofProposals.add(p3);
        
        insert listofProposals;
        
        List<Apttus_Config2__ProductConfiguration__c> listofProdconfig = new List<Apttus_Config2__ProductConfiguration__c >();
        Apttus_Config2__ProductConfiguration__c prodConf = new Apttus_Config2__ProductConfiguration__c(Name='prod-conf1', CurrencyIsoCode = 'CAD', Apttus_QPConfig__Proposald__c=p.id, APTS_SSD_ship_to__c=accountSSD.Id,APTS_SSD_bill_to__c=accountSSD.Id);
        listofProdconfig.add(prodConf);
        Apttus_Config2__ProductConfiguration__c prodConf2 = new Apttus_Config2__ProductConfiguration__c(Name='prod-conf2', CurrencyIsoCode = 'CAD', Apttus_QPConfig__Proposald__c=p2.id, APTS_SSD_ship_to__c=accountSSD2.Id,APTS_SSD_bill_to__c=accountSSD2.Id);
        listofProdconfig.add(prodConf2);
        Apttus_Config2__ProductConfiguration__c prodConf3 = new Apttus_Config2__ProductConfiguration__c(Name='prod-conf2', CurrencyIsoCode = 'USD', Apttus_QPConfig__Proposald__c=p3.id, APTS_SSD_ship_to__c=accountSSD.Id,APTS_SSD_bill_to__c=accountSSD.Id);
        listofProdconfig.add(prodConf3);
        insert listofProdconfig;
        List<Product2 > listofProd=new List<Product2 > ();
        Product2 prod = new Product2(name='prod1', Media_High_Level__c='Online', CurrencyIsoCode = 'CAD',APTS_Media_High_Level_Code__c='06',APTS_Media_Lower_Level_Code__c='49',APTS_Cat_L2__c = 'L2_L011_FP',APTS_CAT_L3__c='L3_L030_FP');
        prod.APTS_Approval_Always_Required__c = true;
        listofProd.add( prod);
        Product2 prod2 = new Product2(name='prod2', Media_High_Level__c='Online', CurrencyIsoCode = 'CAD',APTS_Media_High_Level_Code__c='06',APTS_Media_Lower_Level_Code__c='49',APTS_CAT_L3__c='L2_L011_FP',APTS_CAT_L2__c='L3_L030_FP');
        prod2.APTS_Approval_Always_Required__c = true;
        listofProd.add( prod2);
        insert listofProd;
        
        Apttus_Config2__ConfigSystemProperties__c configSetting=new Apttus_Config2__ConfigSystemProperties__c(Name='System Properties',Apttus_Config2__DisableConstraintRules__c=true);
        insert configSetting;

        test.startTest();
        List<Apttus_Config2__LineItem__c> listOfLineItems = new List<Apttus_Config2__LineItem__c>();
        
        Apttus_Config2__LineItem__c li3 = new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c=prodConf.id , Apttus_Config2__ProductId__c=prod2.id);
        li3.Apttus_Config2__AddedBy__c = 'User';
        li3.Apttus_Config2__AdjustedPrice__c = 50;
        
        li3.Apttus_Config2__AdjustmentAmount__c = 50;
        li3.Apttus_Config2__AdjustmentType__c = '% Discount';
        li3.Apttus_Config2__AllocateGroupAdjustment__c = TRUE;
        li3.Apttus_Config2__AllowableAction__c = 'Unrestricted';
        li3.Apttus_Config2__AllowManualAdjustment__c = TRUE;
        li3.Apttus_Config2__AllowProration__c = FALSE;
        li3.Apttus_Config2__AllowRemoval__c = TRUE;
        li3.Apttus_Config2__AutoRenew__c = FALSE;
        li3.Apttus_Config2__BaseExtendedCost__c = 0;
        li3.Apttus_Config2__BaseExtendedPrice__c = 100;
        li3.Apttus_Config2__BasePrice__c = 100;
        li3.Apttus_Config2__BasePriceMethod__c = 'Per Unit';
        li3.Apttus_Config2__BillingFrequency__c = 'Monthly';
        li3.Apttus_Config2__ChargeType__c = 'Subscription Fee';
        li3.Apttus_Config2__ConfigStatus__c = 'Complete';
        li3.Apttus_Config2__ConstraintCheckStatus__c = 'NA';
        li3.Apttus_Config2__Customizable__c = FALSE;
        li3.Apttus_Config2__DeltaPrice__c = 50;
        li3.Apttus_Config2__DeltaQuantity__c = 1;
        li3.Apttus_Config2__Description__c = 'Westlaw Flex Plan $100/500';
        li3.Apttus_Config2__ExtendedCost__c = 0;
        li3.Apttus_Config2__ExtendedPrice__c = 100;
        li3.Apttus_Config2__Frequency__c = 'Monthly';
        li3.Apttus_Config2__Guidance__c = 'Red';
        li3.Apttus_Config2__HasAttributes__c = FALSE;
        li3.Apttus_Config2__HasBaseProduct__c = FALSE;
        li3.Apttus_Config2__HasDefaults__c = FALSE;
        li3.Apttus_Config2__HasIncentives__c = FALSE;
        li3.Apttus_Config2__HasOptions__c = FALSE;
        li3.Apttus_Config2__HasTieredPrice__c = FALSE;
        li3.Apttus_Config2__HideCopyAction__c = FALSE;
        li3.Apttus_Config2__HideInvoiceDisplay__c = FALSE;
        li3.Apttus_Config2__IsAssetPricing__c = FALSE;
        li3.Apttus_Config2__IsCustomPricing__c = FALSE;
        li3.Apttus_Config2__IsHidden__c = FALSE;
        li3.Apttus_Config2__IsOptionRollupLine__c = FALSE;
        li3.Apttus_Config2__IsPrimaryLine__c = TRUE;
        li3.Apttus_Config2__IsPrimaryRampLine__c = FALSE;
        li3.Apttus_Config2__IsQuantityModifiable__c = FALSE;
        li3.Apttus_Config2__IsReadOnly__c = FALSE;
        li3.Apttus_Config2__IsSellingTermReadOnly__c = FALSE;
        li3.Apttus_Config2__IsUsageTierModifiable__c = FALSE;
        li3.Apttus_Config2__ItemSequence__c = 1;
        li3.Apttus_Config2__LineNumber__c = 1;
        li3.Apttus_Config2__LineSequence__c = 1;
        li3.Apttus_Config2__LineStatus__c = 'Renewed';
        li3.APTS_Yr_1_Renewal_Adjustment__c='1';
        li3.Apttus_Config2__LineType__c = 'Product/Service';
        li3.Apttus_Config2__ListPrice__c = 100;
        li3.Apttus_Config2__NetAdjustmentPercent__c = -50;
        li3.Apttus_Config2__NetPrice__c = 50;
        li3.Apttus_Config2__NetUnitPrice__c = 50;
        li3.Apttus_Config2__OptionSequence__c = 0;
        li3.Apttus_Config2__PriceIncludedInBundle__c = FALSE;
        li3.Apttus_Config2__PriceMethod__c = 'Per Unit';
        li3.Apttus_Config2__PriceType__c = 'Recurring';
        li3.Apttus_Config2__PriceUom__c = 'Each';
        li3.Apttus_Config2__PricingStatus__c = 'Complete';
        li3.Apttus_Config2__PrimaryLineNumber__c = 1;
        li3.Apttus_Config2__ProductVersion__c = 1;
        li3.APTS_Product_Family__c='RUTTER';
        //li3.APTS_Cat_L3__c = System.Label.APTS_Rutter_Product_Family;
        li3.Apttus_Config2__Quantity__c = 1;
        li3.Apttus_Config2__RollupPriceToBundle__c = TRUE;
        li3.Apttus_Config2__SellingFrequency__c = 'Monthly';
        li3.Apttus_Config2__SellingTerm__c = 1;
        li3.Apttus_Config2__SyncStatus__c = 'Pending';
        li3.Apttus_Config2__Taxable__c = FALSE;
        li3.Apttus_Config2__TaxInclusive__c = FALSE;
        //li3.Apttus_Config2__Term__c = 1;
        li3.Apttus_Config2__TotalQuantity__c = 1;
        li3.Apttus_Config2__Uom__c = 'Each';
        //li3.Apttus_CQApprov__Approval_Status__c = 'Pending Approval';
        li3.CurrencyIsoCode = 'CAD';
        li3.APTS_Product_Family__c = 'CLEAR';
        //li3.APTS_Cat_L2__c = System.Label.APTS_Clear_Product_Family;
        li3.APTS_Contract_Term__c = '1 Year';
        li3.APTS_Years_2_Plus_Adjustment__c = '5';
        li3.APTS_Bridge__c = '2 Months';
        listOfLineItems.add(li3);
        
        Apttus_Config2__AssetLineItem__c asset = new Apttus_Config2__AssetLineItem__c(Name = 'Test asset', APTS_Info_PlanType__c = 'S00', 
                                                                                      Apttus_Config2__NetPrice__c = 10.00, APTS_SSD_Bill_To__c = accountSSD.Id,
                                                                                      Apttus_QPConfig__ProposalId__c =p3.id,
                                                                                      APTS_Info_RenewalDate__c = System.today().addDays(-150),Apttus_Config2__BasePriceMethod__c = 'Flat Price');
         insert asset;                                                                             
        
        
                
        Apttus_Config2__LineItem__c li4 = new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c=prodConf.id , Apttus_Config2__ProductId__c=prod2.id);
        li4.Apttus_Config2__AddedBy__c = 'User';
        li4.Apttus_Config2__AdjustedPrice__c = 50;
        li4.Apttus_Config2__AdjustmentAmount__c = 50;
        li4.Apttus_Config2__AdjustmentType__c = '% Discount';
        li4.Apttus_Config2__AllocateGroupAdjustment__c = TRUE;
        li4.Apttus_Config2__AllowableAction__c = 'Unrestricted';
        li4.Apttus_Config2__AllowManualAdjustment__c = TRUE;
        li4.Apttus_Config2__AllowProration__c = FALSE;
        li4.Apttus_Config2__AllowRemoval__c = TRUE;
        li4.Apttus_Config2__AutoRenew__c = FALSE;
        li4.Apttus_Config2__BaseExtendedCost__c = 0;
        li4.Apttus_Config2__BaseExtendedPrice__c = 100;
        li4.Apttus_Config2__BasePrice__c = 100;
        li4.Apttus_Config2__BasePriceMethod__c = 'Per Unit';
        li4.Apttus_Config2__BillingFrequency__c = 'Monthly';
        li4.Apttus_Config2__ChargeType__c = 'Subscription Fee';
        li4.Apttus_Config2__ConfigStatus__c = 'Complete';
        li4.Apttus_Config2__ConstraintCheckStatus__c = 'NA';
        li4.Apttus_Config2__Customizable__c = FALSE;
        li4.Apttus_Config2__DeltaPrice__c = 50;
        li4.Apttus_Config2__DeltaQuantity__c = 1;
        li4.Apttus_Config2__Description__c = 'Westlaw Flex Plan $100/500';
        li4.Apttus_Config2__ExtendedCost__c = 0;
        li4.Apttus_Config2__ExtendedPrice__c = 100;
        li4.Apttus_Config2__Frequency__c = 'Monthly';
        li4.Apttus_Config2__Guidance__c = 'Red';       
        li4.Apttus_Config2__IsPrimaryLine__c = TRUE;        
        li4.Apttus_Config2__ItemSequence__c = 1;
        li4.Apttus_Config2__LineNumber__c = 1;
        li4.Apttus_Config2__LineSequence__c = 1;
        li4.Apttus_Config2__LineStatus__c = 'New';
        li4.APTS_Yr_1_Renewal_Adjustment__c='1';
        li4.Apttus_Config2__LineType__c = 'Product/Service';
        li4.Apttus_Config2__ListPrice__c = 100;
        li4.Apttus_Config2__NetAdjustmentPercent__c = -50;
        li4.Apttus_Config2__NetPrice__c = 50;
        li4.Apttus_Config2__NetUnitPrice__c = 50;
        li4.Apttus_Config2__OptionSequence__c = 0;        
        li4.Apttus_Config2__PriceMethod__c = 'Per Unit';
        li4.Apttus_Config2__PriceType__c = 'Recurring';
        li4.Apttus_Config2__PriceUom__c = 'Attorneys';
        li4.Apttus_Config2__PricingStatus__c = 'Complete';       
        li4.APTS_Product_Family__c='RUTTER';
        //li4.APTS_Cat_L3__c = System.Label.APTS_Rutter_Product_Family;
        li4.Apttus_Config2__Quantity__c = 1;
        li4.Apttus_Config2__RollupPriceToBundle__c = TRUE;
        li4.Apttus_Config2__SellingFrequency__c = 'Monthly';
        li4.Apttus_Config2__SellingTerm__c = 1;        
        li4.Apttus_Config2__Taxable__c = FALSE;
        li4.Apttus_Config2__TaxInclusive__c = FALSE;
        li4.Apttus_Config2__Term__c = 1;
        li4.Apttus_Config2__TotalQuantity__c = 1;
        li4.Apttus_Config2__Uom__c = 'Each';        
        li4.CurrencyIsoCode = 'CAD';
        li4.APTS_Product_Family__c = 'CLEAR';
        //li4.APTS_Cat_L2__c = System.Label.APTS_Clear_Product_Family;
        li4.APTS_Contract_Term__c = '2 Years';
        li4.APTS_Years_2_Plus_Adjustment__c = '5';
        li4.Apttus_Config2__IncentiveCode__c = '13843012,13843012';
        li4.APTS_Bridge__c='1 Month';                   
        listOfLineItems.add(li4);

        Apttus_Config2__LineItem__c li5 = new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c=prodConf.id , Apttus_Config2__ProductId__c=prod2.id);
        li5.Apttus_Config2__AddedBy__c = 'User';
        li5.Apttus_Config2__AdjustedPrice__c = 50;
        li5.Apttus_Config2__AdjustmentAmount__c = 50;
        li5.Apttus_Config2__AdjustmentType__c = '% Discount';
        li5.Apttus_Config2__AllocateGroupAdjustment__c = TRUE;
        li5.Apttus_Config2__AllowableAction__c = 'Unrestricted';
        li5.Apttus_Config2__AllowManualAdjustment__c = TRUE;
        li5.Apttus_Config2__AllowProration__c = FALSE;
        li5.Apttus_Config2__AllowRemoval__c = TRUE;
        li5.Apttus_Config2__AutoRenew__c = FALSE;
        li5.Apttus_Config2__BaseExtendedCost__c = 0;
        li5.Apttus_Config2__BaseExtendedPrice__c = 100;
        li5.Apttus_Config2__BasePrice__c = 100;
        li5.Apttus_Config2__BasePriceMethod__c = 'Per Unit';
        li5.Apttus_Config2__BillingFrequency__c = 'Monthly';
        li5.Apttus_Config2__ChargeType__c = 'Subscription Fee';
        li5.Apttus_Config2__ConfigStatus__c = 'Complete';
        li5.Apttus_Config2__ConstraintCheckStatus__c = 'NA';
        li5.Apttus_Config2__Customizable__c = FALSE;
        li5.Apttus_Config2__DeltaPrice__c = 50;
        li5.Apttus_Config2__DeltaQuantity__c = 1;
        li5.Apttus_Config2__Description__c = 'Westlaw Flex Plan $100/500';
        li5.Apttus_Config2__ExtendedCost__c = 0;
        li5.Apttus_Config2__ExtendedPrice__c = 100;
        li5.Apttus_Config2__Frequency__c = 'Monthly';
        li5.Apttus_Config2__Guidance__c = 'Red';       
        li5.Apttus_Config2__IsPrimaryLine__c = TRUE;        
        li5.Apttus_Config2__ItemSequence__c = 1;
        li5.Apttus_Config2__LineNumber__c = 1;
        li5.Apttus_Config2__LineSequence__c = 1;
        li5.Apttus_Config2__LineStatus__c = 'New';
        li5.APTS_Yr_1_Renewal_Adjustment__c='1';
        li5.Apttus_Config2__LineType__c = 'Product/Service';
        li5.Apttus_Config2__ListPrice__c = 100;
        li5.Apttus_Config2__NetAdjustmentPercent__c = -50;
        li5.Apttus_Config2__NetPrice__c = 50;
        li5.Apttus_Config2__NetUnitPrice__c = 50;
        li5.Apttus_Config2__OptionSequence__c = 0;        
        li5.Apttus_Config2__PriceMethod__c = 'Per Unit';
        li5.Apttus_Config2__PriceType__c = 'Recurring';
        li5.Apttus_Config2__PriceUom__c = 'Attorneys';
        li5.Apttus_Config2__PricingStatus__c = 'Complete';       
        li5.APTS_Product_Family__c='RUTTER';
        //li5.APTS_Cat_L3__c = System.Label.APTS_Rutter_Product_Family;
        li5.Apttus_Config2__Quantity__c = 1;
        li5.Apttus_Config2__RollupPriceToBundle__c = TRUE;
        li5.Apttus_Config2__SellingFrequency__c = 'Monthly';
        li5.Apttus_Config2__SellingTerm__c = 1;        
        li5.Apttus_Config2__Taxable__c = FALSE;
        li5.Apttus_Config2__TaxInclusive__c = FALSE;
        li5.Apttus_Config2__Term__c = 1;
        li5.Apttus_Config2__TotalQuantity__c = 1;
        li5.Apttus_Config2__Uom__c = 'Each';        
        li5.CurrencyIsoCode = 'CAD';
        li5.APTS_Product_Family__c = 'CLEAR';
       // li5.APTS_Cat_L2__c = System.Label.APTS_Clear_Product_Family;
        li5.APTS_Contract_Term__c = '2 Years';
        li5.APTS_Years_2_Plus_Adjustment__c = '5';
        li5.Apttus_Config2__IncentiveCode__c = '13843012,13843012';
        li5.APTS_Bridge__c='1 Month';                   
        listOfLineItems.add(li5);

        Apttus_Config2__LineItem__c li6 = new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c=prodConf.id , Apttus_Config2__ProductId__c=prod2.id);
        li6.Apttus_Config2__AddedBy__c = 'User';
        li6.Apttus_Config2__AdjustedPrice__c = 50;
        li6.Apttus_Config2__AdjustmentAmount__c = 50;
        li6.Apttus_Config2__AdjustmentType__c = '% Discount';
        li6.Apttus_Config2__AllocateGroupAdjustment__c = TRUE;
        li6.Apttus_Config2__AllowableAction__c = 'Unrestricted';
        li6.Apttus_Config2__AllowManualAdjustment__c = TRUE;
        li6.Apttus_Config2__AllowProration__c = FALSE;
        li6.Apttus_Config2__AllowRemoval__c = TRUE;
        li6.Apttus_Config2__AutoRenew__c = FALSE;
        li6.Apttus_Config2__BaseExtendedCost__c = 0;
        li6.Apttus_Config2__BaseExtendedPrice__c = 100;
        li6.Apttus_Config2__BasePrice__c = 100;
        li6.Apttus_Config2__BasePriceMethod__c = 'Per Unit';
        li6.Apttus_Config2__BillingFrequency__c = 'Monthly';
        li6.Apttus_Config2__ChargeType__c = 'Subscription Fee';
        li6.Apttus_Config2__ConfigStatus__c = 'Complete';
        li6.Apttus_Config2__ConstraintCheckStatus__c = 'NA';
        li6.Apttus_Config2__Customizable__c = FALSE;
        li6.Apttus_Config2__DeltaPrice__c = 50;
        li6.Apttus_Config2__DeltaQuantity__c = 1;
        li6.Apttus_Config2__Description__c = 'Westlaw Flex Plan $100/500';
        li6.Apttus_Config2__ExtendedCost__c = 0;
        li6.Apttus_Config2__ExtendedPrice__c = 100;
        li6.Apttus_Config2__Frequency__c = 'Monthly';
        li6.Apttus_Config2__Guidance__c = 'Red';       
        li6.Apttus_Config2__IsPrimaryLine__c = TRUE;        
        li6.Apttus_Config2__ItemSequence__c = 1;
        li6.Apttus_Config2__LineNumber__c = 1;
        li6.Apttus_Config2__LineSequence__c = 1;
        li6.Apttus_Config2__LineStatus__c = 'New';
        li6.APTS_Yr_1_Renewal_Adjustment__c='1';
        li6.Apttus_Config2__LineType__c = 'Product/Service';
        li6.Apttus_Config2__ListPrice__c = 100;
        li6.Apttus_Config2__NetAdjustmentPercent__c = -50;
        li6.Apttus_Config2__NetPrice__c = 50;
        li6.Apttus_Config2__NetUnitPrice__c = 50;
        li6.Apttus_Config2__OptionSequence__c = 0;        
        li6.Apttus_Config2__PriceMethod__c = 'Per Unit';
        li6.Apttus_Config2__PriceType__c = 'Recurring';
        li6.Apttus_Config2__PriceUom__c = 'Attorneys';
        li6.Apttus_Config2__PricingStatus__c = 'Complete';       
        li6.APTS_Product_Family__c='RUTTER';
        //li6.APTS_Cat_L3__c = System.Label.APTS_Rutter_Product_Family;
        li6.Apttus_Config2__Quantity__c = 1;
        li6.Apttus_Config2__RollupPriceToBundle__c = TRUE;
        li6.Apttus_Config2__SellingFrequency__c = 'Monthly';
        li6.Apttus_Config2__SellingTerm__c = 1;        
        li6.Apttus_Config2__Taxable__c = FALSE;
        li6.Apttus_Config2__TaxInclusive__c = FALSE;
        li6.Apttus_Config2__Term__c = 1;
        li6.Apttus_Config2__TotalQuantity__c = 1;
        li6.Apttus_Config2__Uom__c = 'Each';        
        li6.CurrencyIsoCode = 'CAD';
        li6.APTS_Product_Family__c = 'CLEAR';
        //li6.APTS_Cat_L2__c = System.Label.APTS_Clear_Product_Family;
        li6.APTS_Contract_Term__c = '2 Years';
        li6.APTS_Years_2_Plus_Adjustment__c = '5';
        li6.Apttus_Config2__IncentiveCode__c = '13843012,13843012';
        li6.APTS_Bridge__c='1 Month';                  
        listOfLineItems.add(li6);
        
        Apttus_Config2__LineItem__c li7 = new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c=prodConf2.id , Apttus_Config2__ProductId__c=prod2.id);
        li7.Apttus_Config2__AddedBy__c = 'User';        
        li7.Apttus_Config2__BasePrice__c = 100;
        li7.Apttus_Config2__BasePriceMethod__c = 'Per Unit';
        li7.Apttus_Config2__BillingFrequency__c = 'Monthly';
        li7.Apttus_Config2__ChargeType__c = 'Subscription Fee';
        li7.Apttus_Config2__ConfigStatus__c = 'Complete';        
        li7.Apttus_Config2__Frequency__c = 'Monthly';        
        li7.Apttus_Config2__IsPrimaryLine__c = TRUE;        
        li7.Apttus_Config2__ItemSequence__c = 1;
        li7.Apttus_Config2__LineNumber__c = 1;
        li7.Apttus_Config2__LineSequence__c = 1;
        li7.Apttus_Config2__LineStatus__c = 'New';
        li7.APTS_Yr_1_Renewal_Adjustment__c='1';
        li7.Apttus_Config2__LineType__c = 'Product/Service';
        li7.Apttus_Config2__ListPrice__c = 100;        
        li7.Apttus_Config2__NetPrice__c = 50;
        li7.Apttus_Config2__NetUnitPrice__c = 50;        
        li7.Apttus_Config2__PriceMethod__c = 'Per Unit';
        li7.Apttus_Config2__PriceType__c = 'Recurring';
        li7.Apttus_Config2__PriceUom__c = 'Each';
        li7.Apttus_Config2__PricingStatus__c = 'Complete';
        li7.Apttus_Config2__PrimaryLineNumber__c = 1;
        li7.Apttus_Config2__ProductVersion__c = 1;        
        li7.Apttus_Config2__Quantity__c = 1;
        li7.Apttus_Config2__RollupPriceToBundle__c = TRUE;
        li7.Apttus_Config2__SellingFrequency__c = 'Monthly';
        li7.Apttus_Config2__SellingTerm__c = 1;                               
        li7.Apttus_Config2__TotalQuantity__c = 1;
        li7.Apttus_Config2__Uom__c = 'Each';
        li7.Apttus_CQApprov__Approval_Status__c = 'Pending Approval';
        li7.CurrencyIsoCode = 'USD';
        li7.APTS_Product_Family__c = 'CLEAR';
        //li7.APTS_Cat_L2__c = System.Label.APTS_Clear_Product_Family;
        li7.APTS_Contract_Term__c = '1 Year';
        li7.APTS_Years_2_Plus_Adjustment__c = '5';
        li7.APTS_Bridge__c = '2 Months';
        listOfLineItems.add(li7);
        
                 
        Apttus_Config2__LineItem__c li8 = new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c=prodConf3.id , Apttus_Config2__ProductId__c=prod.id);
        li8.Apttus_Config2__AddedBy__c = 'User';       
        li8.Apttus_Config2__BaseExtendedCost__c = 0;
        li8.Apttus_Config2__BaseExtendedPrice__c = 100;
        li8.Apttus_Config2__BasePrice__c = 100;
        li8.Apttus_Config2__BasePriceMethod__c = 'Per Unit';
        li8.Apttus_Config2__BillingFrequency__c = 'Monthly';
        li8.Apttus_Config2__ChargeType__c = 'Subscription Fee';
        li8.Apttus_Config2__ConfigStatus__c = 'Complete';
        li8.Apttus_Config2__ConstraintCheckStatus__c = 'NA';
        li8.Apttus_Config2__Customizable__c = FALSE;
        li8.Apttus_Config2__DeltaPrice__c = 50;
        li8.Apttus_Config2__DeltaQuantity__c = 1;
        li8.Apttus_Config2__Description__c = 'Westlaw Flex Plan $100/500';
        li8.Apttus_Config2__ExtendedCost__c = 0;
        li8.Apttus_Config2__ExtendedPrice__c = 100;
        li8.Apttus_Config2__Frequency__c = 'Monthly';
        li8.Apttus_Config2__Guidance__c = 'Red';       
        li8.Apttus_Config2__IsPrimaryLine__c = TRUE;        
        li8.Apttus_Config2__ItemSequence__c = 1;
        li8.Apttus_Config2__LineNumber__c = 1;
        li8.Apttus_Config2__LineSequence__c = 1;
        li8.Apttus_Config2__LineStatus__c = 'New';
        li8.APTS_Yr_1_Renewal_Adjustment__c='1';
        li8.Apttus_Config2__LineType__c = 'Product/Service';
        li8.Apttus_Config2__ListPrice__c = 100;
        li8.Apttus_Config2__NetAdjustmentPercent__c = -50;
        li8.Apttus_Config2__NetPrice__c = 50;
        li8.Apttus_Config2__NetUnitPrice__c = 50;
        li8.Apttus_Config2__OptionSequence__c = 0;        
        li8.Apttus_Config2__PriceMethod__c = 'Per Unit';
        li8.Apttus_Config2__PriceType__c = 'Recurring';
        li8.Apttus_Config2__PriceUom__c = 'Attorneys';
        li8.Apttus_Config2__PricingStatus__c = 'Complete';
        li8.Apttus_Config2__Quantity__c = 1;
        li8.Apttus_Config2__RollupPriceToBundle__c = TRUE;
        li8.Apttus_Config2__SellingFrequency__c = 'Monthly';
        li8.Apttus_Config2__SellingTerm__c = 1;        
        li8.Apttus_Config2__Taxable__c = FALSE;
        li8.Apttus_Config2__TaxInclusive__c = FALSE;
        li8.Apttus_Config2__Term__c = 1;
        li8.Apttus_Config2__TotalQuantity__c = 1;
        li8.Apttus_Config2__Uom__c = 'Each';        
        li8.CurrencyIsoCode = 'USD';
        li8.APTS_Product_Family__c = 'PRINT LEGAL SOLUTIONS';
        //li8.APTS_Cat_L2__c = System.Label.APTS_Print_Product_Family;
        li8.APTS_Contract_Term__c = '2 Years';
        li8.APTS_Years_2_Plus_Adjustment__c = '5';        
        li8.APTS_Bridge__c='3 Months';                   
        listOfLineItems.add(li8);

       
        insert listOfLineItems;
          
             
        li3.APTS_Contract_Term__c = '3 Years';
        li3.APTS_Bridge__c='6 Months';       
        li4.APTS_Contract_Term__c = '1 Year';
        li4.APTS_Bridge__c='3 Months';  
        li5.APTS_Contract_Term__c = '4 Years';
        li5.APTS_Bridge__c='7 Months';  
        li6.APTS_Contract_Term__c = '5 Years';
        li6.APTS_Bridge__c='3 Months'; 
        li7.APTS_Contract_Term__c = '1 Year';
        li7.APTS_Bridge__c='2 Months'; 
        li8.APTS_Contract_Term__c = '1 Year';
        li8.APTS_Bridge__c='3 Months'; 

        update listOfLineItems;
        APTS_LineItemTriggerHelper.populateAllApprovalRequiredCB(listOfLineItems);
        Test.stopTest();        
    }
    static testMethod void canadaAnnualProflexTest() {
        
        List<KeyValueListStore__c> keyvaluestoreList = new List<KeyValueListStore__c>();
        KeyValueListStore__c keyvaluestore=new  KeyValueListStore__c();
        keyvaluestore.Name='ANZUsersProfileId';
        keyvaluestore.TextValue__c=System.Label.APTS_OC_Test_Id;
        keyvaluestoreList.add(keyvaluestore); 
        KeyValueListStore__c keyval = new KeyValueListStore__c();
        keyval.Name='ReasonWithCompetitor';
        keyval.TextValue__c='Price';
        keyvaluestoreList.add(keyval);
        insert keyvaluestoreList; 
        
        //Inserting recordLists
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
        
        List<APTS_Segment_Threshold__c> segthrList= new List<APTS_Segment_Threshold__c>();
        //Add Segment threshold
        APTS_Segment_Threshold__c seg1 = new APTS_Segment_Threshold__c();
        seg1.APTS_Approval_Required__c=True;
        seg1.APTS_Segment__c='Small Law';
        seg1.APTS_Customer_Category__c='5';
        seg1.APTS_Term_in_years__c=Integer.ValueOf('2');
        seg1.APTS_Minimum_OY_Increase__c=Integer.ValueOf('15');
        seg1.APTS_Minimum_Incremental_Growth__c=Integer.ValueOf('15');
        seg1.APTS_Product_Family__c = 'CLEAR';
        seg1.APTS_Promo_Codes__c = '13843014';
        seg1.APTS_Promo_Minimum_OY_Increase__c = 17;        
        segthrList.add(seg1);
        
        APTS_Segment_Threshold__c seg2 = new APTS_Segment_Threshold__c();
        seg2.APTS_Approval_Required__c=True;
        seg2.APTS_Segment__c='Corporate';
        seg2.APTS_Customer_Category__c='5';
        seg2.APTS_Term_in_years__c=Integer.ValueOf('2');
        seg2.APTS_Minimum_OY_Increase__c=Integer.ValueOf('15');
        seg2.APTS_Minimum_Incremental_Growth__c=Integer.ValueOf('15');
        seg2.APTS_Product_Family__c = 'CLEAR';
        seg2.APTS_Promo_Codes__c = '13843013';
        seg2.APTS_Promo_Minimum_OY_Increase__c = 16;        
        segthrList.add(seg2);
        system.assertEquals(seg2.APTS_Promo_Codes__c,'13843013');
                
        APTS_Segment_Threshold__c seg3 = new APTS_Segment_Threshold__c();
        seg3.APTS_Approval_Required__c=True;
        seg3.APTS_Segment__c='Corporate';
        seg3.APTS_Customer_Category__c='5';
        seg3.APTS_Term_in_years__c=Integer.ValueOf('2');
        seg3.APTS_Minimum_OY_Increase__c=Integer.ValueOf('15');
        seg3.APTS_Minimum_Incremental_Growth__c=Integer.ValueOf('15');
        segthrList.add(seg3);       
      
        APTS_Segment_Threshold__c seg4 = new APTS_Segment_Threshold__c();
        seg4.APTS_Approval_Required__c=True;
        seg4.APTS_Segment__c='Government';
        seg4.APTS_Customer_Category__c='5';
        seg4.APTS_Term_in_years__c=Integer.ValueOf('2');
        seg4.APTS_Minimum_OY_Increase__c=Integer.ValueOf('15');
        seg4.APTS_Minimum_Incremental_Growth__c=Integer.ValueOf('15');
        seg4.APTS_Product_Family__c = 'CLEAR';
        seg4.APTS_Promo_Codes__c = '13843012';
        seg4.APTS_Promo_Minimum_OY_Increase__c = 15;        
        segthrList.add(seg4);
        
        insert segthrList;
        
        Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
        Account a = new Account(RecordTypeId=accRecordTypeId,name='test-sg',sales_org__c='ABEP',customer_group__c='Academic',customer_type__c='Organization',customer_class_c__c='Academic Lecturer');
        a.APTS_Customer_Category__c = '5';
        a.Is_GLI__c = True;
        insert a;        
        
        Schema.DescribeFieldResult fieldResultMarket = Apttus_Config2__ProductConfiguration__c.APTS_AccountMirror_Picklist__c.getDescribe();
        String valueMarket = fieldResultMarket.getPicklistValues().get(0).getValue();
        
        //Inserting SourceSystemDetail
        List<Source_System_Detail__c> listOfSSD = new List<Source_System_Detail__c>();
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();
        
        Source_System_Detail__c accountSSD2= new Source_System_Detail__c();
        accountSSD2.RecordtypeId=ssdRecorType;
        accountSSD2.Name='ABC';
        accountSSD2.Source_System_Name__c='ABC';
        accountSSD2.Account_Name__c=a.ID;
        accountSSD2.APTS_Customer_Category__c='1';
        accountSSD2.LCRM_Customer_Group__c='Corporation';
        accountSSD2.LCRM_Frozen_Market_Segment__c = valueMarket;
        accountSSD2.Account_Inactive__c=false;
        accountSSD2.LCRM_Sales_Org__c='WEST';
        accountSSD2.APTS_Has_Online_Assets__c=true;        
        listOfSSD.add(accountSSD2);
        insert listOfSSD;
        
        Date todaysDate = system.today();
        Id oppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Pipeline Opportunity').getRecordTypeId();
        Opportunity o = new Opportunity(RecordTypeId=oppRecordTypeId,  Name='tst-opp', stagename='25%',closedate=todaysDate,forecastcategoryname='pipeline',accountId=a.id);
        insert o;
        
        List<Apttus_Proposal__Proposal__c > listofProposals=new List<Apttus_Proposal__Proposal__c >();
        Id devRecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Proposal').getRecordTypeId();
        Apttus_Proposal__Proposal__c p2 = new Apttus_Proposal__Proposal__c(RecordTypeId=devRecordTypeId, CurrencyIsoCode = 'USD', Apttus_Proposal__Account__c=a.id,APTS_Approval_Segment__c='Canada',
            Apttus_Proposal__Proposal_Name__c='Corporate Proposal for approval',  Apttus_Proposal__Opportunity__c=o.id, 
            Apttus_Proposal__Approval_Stage__c='Draft', Apttus_Proposal__Proposal_Category__c='Quote', Apttus_Proposal__ReadyToGenerate__c = true, 
            Apttus_Proposal__ReadyToPresent__c= true,APTS_SSD_Sold_To__c=accountSSD2.Id,APTS_SSD_ship_to__c=accountSSD2.Id,
            APTS_SSD_bill_to__c=accountSSD2.Id);
        p2.APTS_Proposal_Business_Unit__c = 'SCS';
        p2.APTS_Approval_Segment__c = 'Medium Law';
        listofProposals.add(p2);
        
        Apttus_Proposal__Proposal__c p3 = new Apttus_Proposal__Proposal__c(RecordTypeId=devRecordTypeId, CurrencyIsoCode = 'USD', Apttus_Proposal__Account__c=a.id,APTS_Approval_Segment__c='Canada',
            Apttus_Proposal__Proposal_Name__c='Corporate Proposal for approval',  Apttus_Proposal__Opportunity__c=o.id, 
            Apttus_Proposal__Approval_Stage__c='Draft', Apttus_Proposal__Proposal_Category__c='Quote', Apttus_Proposal__ReadyToGenerate__c = true, 
            Apttus_Proposal__ReadyToPresent__c= true,APTS_SSD_Sold_To__c=accountSSD2.Id,APTS_SSD_ship_to__c=accountSSD2.Id,
            APTS_SSD_bill_to__c=accountSSD2.Id);
        p3.APTS_Proposal_Business_Unit__c = 'SCS';
        p3.APTS_Approval_Segment__c = 'Government';
        listofProposals.add(p3);
        Apttus_Proposal__Proposal__c p4 = new Apttus_Proposal__Proposal__c(RecordTypeId=devRecordTypeId, CurrencyIsoCode = 'USD', Apttus_Proposal__Account__c=a.id,APTS_Approval_Segment__c='Canada',
            Apttus_Proposal__Proposal_Name__c='Corporate Proposal for approval',  Apttus_Proposal__Opportunity__c=o.id, 
            Apttus_Proposal__Approval_Stage__c='Draft', Apttus_Proposal__Proposal_Category__c='Quote', Apttus_Proposal__ReadyToGenerate__c = true, 
            Apttus_Proposal__ReadyToPresent__c= true,APTS_SSD_Sold_To__c=accountSSD2.Id,APTS_SSD_ship_to__c=accountSSD2.Id,
            APTS_SSD_bill_to__c=accountSSD2.Id);
        p4.APTS_Proposal_Business_Unit__c = 'Canada';
        p4.APTS_Approval_Segment__c = 'Canada';
        listofProposals.add(p4);
        insert listofProposals;
        
        List<Apttus_Config2__ProductConfiguration__c> listofProdconfig = new List<Apttus_Config2__ProductConfiguration__c >();       
        Apttus_Config2__ProductConfiguration__c prodConf2 = new Apttus_Config2__ProductConfiguration__c(Name='prod-conf2', CurrencyIsoCode = 'USD', Apttus_QPConfig__Proposald__c=p2.id, APTS_SSD_ship_to__c=accountSSD2.Id,APTS_SSD_bill_to__c=accountSSD2.Id);
        listofProdconfig.add(prodConf2);
        Apttus_Config2__ProductConfiguration__c prodConf3 = new Apttus_Config2__ProductConfiguration__c(Name='prod-conf2', CurrencyIsoCode = 'USD', Apttus_QPConfig__Proposald__c=p3.id, APTS_SSD_ship_to__c=accountSSD2.Id,APTS_SSD_bill_to__c=accountSSD2.Id);
        listofProdconfig.add(prodConf3);
        Apttus_Config2__ProductConfiguration__c prodConf4 = new Apttus_Config2__ProductConfiguration__c(Name='prod-conf2', CurrencyIsoCode = 'CAD', Apttus_QPConfig__Proposald__c=p4.id, APTS_SSD_ship_to__c=accountSSD2.Id,APTS_SSD_bill_to__c=accountSSD2.Id);
        listofProdconfig.add(prodConf4);
        insert listofProdconfig;
        
        Product2 prod = new Product2(name='prod1', Media_High_Level__c='Online', CurrencyIsoCode = 'USD',APTS_Media_High_Level_Code__c='06',ProductCode = '13234');
        prod.APTS_Approval_Always_Required__c = true;

        Product2 prod1 = new Product2(name='prod2', Media_High_Level__c='Online', CurrencyIsoCode = 'USD',APTS_Media_High_Level_Code__c='05',APTS_Media_Lower_Level_Code__c='E2',ProductCode = '13234');
        prod1.APTS_Approval_Always_Required__c = true;

    Product2 prod2 = new Product2(name='prod3', Media_High_Level__c='Online', CurrencyIsoCode = 'USD',APTS_Cat_L2__c='L2_L045_FP',ProductCode = '13234');
        prod2.APTS_Approval_Always_Required__c = true;
        
        List<Product2> prdlist = new List<Product2>{prod,prod1,prod2};
        insert prdlist;
        
        Apttus_Config2__ConfigSystemProperties__c configSetting=new Apttus_Config2__ConfigSystemProperties__c(Name='System Properties',Apttus_Config2__DisableConstraintRules__c=true);
        insert configSetting;

        test.startTest();
        List<Apttus_Config2__LineItem__c> listOfLineItems = new List<Apttus_Config2__LineItem__c>();        
        
        Apttus_Config2__LineItem__c li6 = new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c=prodConf3.id , Apttus_Config2__ProductId__c=prod.id);
        li6.Apttus_Config2__AddedBy__c = 'User';
        li6.Apttus_Config2__AdjustedPrice__c = 50;
        li6.Apttus_Config2__AdjustmentAmount__c = 50;
        li6.Apttus_Config2__AdjustmentType__c = '% Discount';
        li6.Apttus_Config2__AllocateGroupAdjustment__c = TRUE;
        li6.Apttus_Config2__AllowableAction__c = 'Unrestricted';
        li6.Apttus_Config2__AllowManualAdjustment__c = TRUE;
        li6.Apttus_Config2__AllowProration__c = FALSE;
        li6.Apttus_Config2__AllowRemoval__c = TRUE;
        li6.Apttus_Config2__AutoRenew__c = FALSE;
        li6.Apttus_Config2__BaseExtendedCost__c = 0;
        li6.Apttus_Config2__BaseExtendedPrice__c = 100;
        li6.Apttus_Config2__BasePrice__c = 100;
        li6.Apttus_Config2__BasePriceMethod__c = 'Per Unit';
        li6.Apttus_Config2__BillingFrequency__c = 'Monthly';
        li6.Apttus_Config2__ChargeType__c = 'Subscription Fee';
        li6.Apttus_Config2__ConfigStatus__c = 'Complete';
        li6.Apttus_Config2__ConstraintCheckStatus__c = 'NA';
        li6.Apttus_Config2__Customizable__c = FALSE;
        li6.Apttus_Config2__DeltaPrice__c = 50;
        li6.Apttus_Config2__DeltaQuantity__c = 1;
        li6.Apttus_Config2__Description__c = 'Westlaw Flex Plan $100/500';
        li6.Apttus_Config2__ExtendedCost__c = 0;
        li6.Apttus_Config2__ExtendedPrice__c = 100;
        li6.Apttus_Config2__Frequency__c = 'Monthly';
        li6.Apttus_Config2__Guidance__c = 'Red';       
        li6.Apttus_Config2__IsPrimaryLine__c = TRUE;        
        li6.Apttus_Config2__ItemSequence__c = 1;
        li6.Apttus_Config2__LineNumber__c = 1;
        li6.Apttus_Config2__LineSequence__c = 1;
        li6.Apttus_Config2__LineStatus__c = 'New';
        li6.APTS_Yr_1_Renewal_Adjustment__c='1';
        li6.Apttus_Config2__LineType__c = 'Product/Service';
        li6.Apttus_Config2__ListPrice__c = 100;
        li6.Apttus_Config2__NetAdjustmentPercent__c = -50;
        li6.Apttus_Config2__NetPrice__c = 50;
        li6.Apttus_Config2__NetUnitPrice__c = 50;
        li6.Apttus_Config2__OptionSequence__c = 0;        
        li6.Apttus_Config2__PriceMethod__c = 'Per Unit';
        li6.Apttus_Config2__PriceType__c = 'Recurring';
        li6.Apttus_Config2__PriceUom__c = 'Attorneys';
        li6.Apttus_Config2__PricingStatus__c = 'Complete';       
        li6.APTS_Product_Family__c='RUTTER';
       // li6.APTS_Cat_L3__c = System.Label.APTS_Rutter_Product_Family;
        li6.Apttus_Config2__Quantity__c = 1;
        li6.Apttus_Config2__RollupPriceToBundle__c = TRUE;
        li6.Apttus_Config2__SellingFrequency__c = 'Monthly';
        li6.Apttus_Config2__BillingFrequency__c = 'Monthly';
        li6.Apttus_Config2__SellingTerm__c = 1;        
        li6.Apttus_Config2__Taxable__c = FALSE;
        li6.Apttus_Config2__TaxInclusive__c = FALSE;
        li6.Apttus_Config2__Term__c = 1;
        li6.Apttus_Config2__TotalQuantity__c = 1;
        li6.Apttus_Config2__Uom__c = 'Each';        
        li6.CurrencyIsoCode = 'CAD';
        li6.APTS_Product_Family__c = 'CLEAR';
        //li6.APTS_Cat_L2__c = System.Label.APTS_Clear_Product_Family;
        li6.APTS_Contract_Term__c = '2 Years';
        li6.APTS_Years_2_Plus_Adjustment__c = '5';
        listOfLineItems.add(li6);
        
        Apttus_Config2__LineItem__c li7 = new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c=prodConf2.id , Apttus_Config2__ProductId__c=prod.id);
        li7.Apttus_Config2__AddedBy__c = 'User';        
        li7.Apttus_Config2__BasePrice__c = 100;
        li7.Apttus_Config2__BasePriceMethod__c = 'Per Unit';
        li7.Apttus_Config2__BillingFrequency__c = 'Monthly';
        li7.Apttus_Config2__ChargeType__c = 'Subscription Fee';
        li7.Apttus_Config2__ConfigStatus__c = 'Complete';        
        li7.Apttus_Config2__Frequency__c = 'Monthly';        
        li7.Apttus_Config2__IsPrimaryLine__c = TRUE;        
        li7.Apttus_Config2__ItemSequence__c = 1;
        li7.Apttus_Config2__LineNumber__c = 1;
        li7.Apttus_Config2__LineSequence__c = 1;
        li7.Apttus_Config2__LineStatus__c = 'New';
        li7.APTS_Yr_1_Renewal_Adjustment__c='1';
        li7.Apttus_Config2__LineType__c = 'Product/Service';
        li7.Apttus_Config2__ListPrice__c = 100;        
        li7.Apttus_Config2__NetPrice__c = 50;
        li7.Apttus_Config2__NetUnitPrice__c = 50;        
        li7.Apttus_Config2__PriceMethod__c = 'Per Unit';
        li7.Apttus_Config2__PriceType__c = 'Recurring';
        li7.Apttus_Config2__PriceUom__c = 'Each';
        li7.Apttus_Config2__PricingStatus__c = 'Complete';
        li7.Apttus_Config2__PrimaryLineNumber__c = 1;
        li7.Apttus_Config2__ProductVersion__c = 1;        
        li7.Apttus_Config2__Quantity__c = 1;
        li7.Apttus_Config2__RollupPriceToBundle__c = TRUE;
        li7.Apttus_Config2__SellingFrequency__c = 'Monthly';
        li7.Apttus_Config2__BillingFrequency__c = 'Monthly';
        li7.Apttus_Config2__SellingTerm__c = 1;                               
        li7.Apttus_Config2__TotalQuantity__c = 1;
        li7.Apttus_Config2__Uom__c = 'Each';
        li7.Apttus_CQApprov__Approval_Status__c = 'Pending Approval';
        li7.CurrencyIsoCode = 'USD';
        li7.APTS_Product_Family__c = 'CLEAR';
        //li7.APTS_Cat_L2__c = System.Label.APTS_Clear_Product_Family;
        li7.APTS_Contract_Term__c = '1 Year';
        li7.APTS_Years_2_Plus_Adjustment__c = '5';
        li7.APTS_Group__c='Bundle A';
        listOfLineItems.add(li7);
        
        Apttus_Config2__LineItem__c li8 = new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c=prodConf4.id , Apttus_Config2__ProductId__c=prod.id);
        li8.Apttus_Config2__AddedBy__c = 'User';        
        li8.Apttus_Config2__BasePrice__c = 100;
        li8.Apttus_Config2__BasePriceMethod__c = 'Per Unit';
        li8.Apttus_Config2__BillingFrequency__c = 'Monthly';
        li8.Apttus_Config2__ChargeType__c = 'Subscription Fee';
        li8.Apttus_Config2__ConfigStatus__c = 'Complete';        
        li8.Apttus_Config2__Frequency__c = 'Monthly';        
        li8.Apttus_Config2__IsPrimaryLine__c = TRUE;        
        li8.Apttus_Config2__ItemSequence__c = 1;
        li8.Apttus_Config2__LineNumber__c = 1;
        li8.Apttus_Config2__LineSequence__c = 1;
        li8.Apttus_Config2__LineStatus__c = 'New';
        li8.APTS_Yr_1_Renewal_Adjustment__c='1';
        li8.Apttus_Config2__LineType__c = 'Product/Service';
        li8.Apttus_Config2__ListPrice__c = 100;        
        li8.Apttus_Config2__NetPrice__c = 50;
        li8.Apttus_Config2__NetUnitPrice__c = 50;        
        li8.Apttus_Config2__PriceMethod__c = 'Per Unit';
        li8.Apttus_Config2__PriceType__c = 'Recurring';
        li8.Apttus_Config2__PriceUom__c = 'Each';
        li8.Apttus_Config2__PricingStatus__c = 'Complete';
        li8.Apttus_Config2__PrimaryLineNumber__c = 1;
        li8.Apttus_Config2__ProductVersion__c = 1;        
        li8.Apttus_Config2__Quantity__c = 1;
        li8.Apttus_Config2__RollupPriceToBundle__c = TRUE;
        li8.Apttus_Config2__SellingFrequency__c = 'Monthly';
        li8.Apttus_Config2__BillingFrequency__c = 'Monthly';
        li8.Apttus_Config2__SellingTerm__c = 1;                               
        li8.Apttus_Config2__TotalQuantity__c = 1;
        li8.Apttus_Config2__Uom__c = 'Each';
        li8.Apttus_CQApprov__Approval_Status__c = 'Pending Approval';
        li8.CurrencyIsoCode = 'USD';
        li8.APTS_Product_Family__c = 'CLEAR';
        //li8.APTS_Cat_L2__c = System.Label.APTS_Clear_Product_Family;
        li8.APTS_Contract_Term__c = '1 Year';
        li8.APTS_Years_2_Plus_Adjustment__c = '1';
        li8.APTS_Group__c='Bundle A';
        listOfLineItems.add(li8);
        
        Apttus_Config2__LineItem__c li9 = new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c=prodConf4.id , Apttus_Config2__ProductId__c=prod1.id);
        li9.Apttus_Config2__AddedBy__c = 'User';        
        li9.Apttus_Config2__BasePrice__c = 100;
        li9.Apttus_Config2__BasePriceMethod__c = 'Per Unit';
        li9.Apttus_Config2__BillingFrequency__c = 'Monthly';
        li9.Apttus_Config2__ChargeType__c = 'Subscription Fee';
        li9.Apttus_Config2__ConfigStatus__c = 'Complete';        
        li9.Apttus_Config2__Frequency__c = 'Monthly';        
        li9.Apttus_Config2__IsPrimaryLine__c = TRUE;        
        li9.Apttus_Config2__ItemSequence__c = 1;
        li9.Apttus_Config2__LineNumber__c = 1;
        li9.Apttus_Config2__LineSequence__c = 1;
        li9.Apttus_Config2__LineStatus__c = 'New';
        li9.APTS_Yr_1_Renewal_Adjustment__c='1';
        li9.Apttus_Config2__LineType__c = 'Product/Service';
        li9.Apttus_Config2__ListPrice__c = 100;        
        li9.Apttus_Config2__NetPrice__c = 50;
        li9.Apttus_Config2__NetUnitPrice__c = 50;        
        li9.Apttus_Config2__PriceMethod__c = 'Per Unit';
        li9.Apttus_Config2__PriceType__c = 'Recurring';
        li9.Apttus_Config2__PriceUom__c = 'Each';
        li9.Apttus_Config2__PricingStatus__c = 'Complete';
        li9.Apttus_Config2__PrimaryLineNumber__c = 1;
        li9.Apttus_Config2__ProductVersion__c = 1;        
        li9.Apttus_Config2__Quantity__c = 1;
        li9.Apttus_Config2__RollupPriceToBundle__c = TRUE;
        li9.Apttus_Config2__SellingFrequency__c = 'Monthly';
        li9.Apttus_Config2__BillingFrequency__c = 'Monthly';
        li9.Apttus_Config2__SellingTerm__c = 1;                               
        li9.Apttus_Config2__TotalQuantity__c = 1;
        li9.Apttus_Config2__Uom__c = 'Each';
        li9.Apttus_CQApprov__Approval_Status__c = 'Pending Approval';
        li9.CurrencyIsoCode = 'USD';
        li9.APTS_Product_Family__c = 'CLEAR';
        //li8.APTS_Cat_L2__c = System.Label.APTS_Clear_Product_Family;
        li9.APTS_Contract_Term__c = '1 Year';
        li9.APTS_Years_2_Plus_Adjustment__c = '1';
        li9.APTS_Group__c='Bundle A';
        listOfLineItems.add(li9);

    Apttus_Config2__LineItem__c li5 = new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c=prodConf4.id , Apttus_Config2__ProductId__c=prod2.id);
        li5.Apttus_Config2__AddedBy__c = 'User';        
        li5.Apttus_Config2__BasePrice__c = 100;
        li5.Apttus_Config2__BasePriceMethod__c = 'Per Unit';
        li5.Apttus_Config2__BillingFrequency__c = 'Monthly';
        li5.Apttus_Config2__ChargeType__c = 'Subscription Fee';
        li5.Apttus_Config2__ConfigStatus__c = 'Complete';        
        li5.Apttus_Config2__Frequency__c = 'Monthly';        
        li5.Apttus_Config2__IsPrimaryLine__c = TRUE;        
        li5.Apttus_Config2__ItemSequence__c = 1;
        li5.Apttus_Config2__LineNumber__c = 1;
        li5.Apttus_Config2__LineSequence__c = 1;
        li5.Apttus_Config2__LineStatus__c = 'New';
        li5.APTS_Yr_1_Renewal_Adjustment__c='1';
        li5.Apttus_Config2__LineType__c = 'Product/Service';
        li5.Apttus_Config2__ListPrice__c = 100;        
        li5.Apttus_Config2__NetPrice__c = 50;
        li5.Apttus_Config2__NetUnitPrice__c = 50;        
        li5.Apttus_Config2__PriceMethod__c = 'Per Unit';
        li5.Apttus_Config2__PriceType__c = 'Recurring';
        li5.Apttus_Config2__PriceUom__c = 'Each';
        li5.Apttus_Config2__PricingStatus__c = 'Complete';
        li5.Apttus_Config2__PrimaryLineNumber__c = 1;
        li5.Apttus_Config2__ProductVersion__c = 1;        
        li5.Apttus_Config2__Quantity__c = 1;
        li5.Apttus_Config2__RollupPriceToBundle__c = TRUE;
        li5.Apttus_Config2__SellingFrequency__c = 'Monthly';
        li5.Apttus_Config2__BillingFrequency__c = 'Monthly';
        li5.Apttus_Config2__SellingTerm__c = 1;                               
        li5.Apttus_Config2__TotalQuantity__c = 1;
        li5.Apttus_Config2__Uom__c = 'Each';
        li5.Apttus_CQApprov__Approval_Status__c = 'Pending Approval';
        li5.CurrencyIsoCode = 'USD';
        li5.APTS_Product_Family__c = 'CLEAR';
        //li8.APTS_Cat_L2__c = System.Label.APTS_Clear_Product_Family;
        li5.APTS_Contract_Term__c = '1 Year';
        li5.APTS_Years_2_Plus_Adjustment__c = '1';
        li5.APTS_Group__c='Bundle A';
        listOfLineItems.add(li5);
        insert listOfLineItems;        
             
        li6.Apttus_Config2__BillingFrequency__c= 'Yearly';
        li7.Apttus_Config2__BillingFrequency__c='Yearly';       
        
               
        update listOfLineItems;
        APTS_LineItemTriggerHelper.populateAllApprovalRequiredCB(listOfLineItems);
        
        Test.stopTest();
        
        }
        
static testMethod void bridgeApprovalTestCanada() {
        
        List<KeyValueListStore__c> keyvaluestoreList = new List<KeyValueListStore__c>();
        KeyValueListStore__c keyvaluestore=new  KeyValueListStore__c();
        keyvaluestore.Name='ANZUsersProfileId';
        keyvaluestore.TextValue__c=System.Label.APTS_OC_Test_Id;
        keyvaluestoreList.add(keyvaluestore); 
        KeyValueListStore__c keyval = new KeyValueListStore__c();
        keyval.Name='ReasonWithCompetitor';
        keyval.TextValue__c='Price';
        keyvaluestoreList.add(keyval);
        insert keyvaluestoreList;
        WebServiceSettings__c oWebServiceSettings = new WebServiceSettings__c();
        oWebServiceSettings.Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable'; 
        oWebServiceSettings.Name = 'PaymentCreditIncrease'; 
        oWebServiceSettings.Timeout__c = 120; 
        oWebServiceSettings.Endpoint__c = 'https://dev.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease'; 
        oWebServiceSettings.Active__c = true;
        insert oWebServiceSettings;
        List<WebServiceSettings__c> webserviceList = new List<WebServiceSettings__c>{new WebServiceSettings__c(Name='EnterpriseWSDL',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
           new WebServiceSettings__c(Name='StatusPostbackLocation',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
           new WebServiceSettings__c(Name='PostbackLocation',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
           new WebServiceSettings__c(Name='Payment AutoCharge',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available')};
        insert webserviceList;  
        //Inserting recordLists
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
        
        List<APTS_Segment_Threshold__c> segthrList= new List<APTS_Segment_Threshold__c>();
        //Add Segment threshold
        APTS_Segment_Threshold__c seg1 = new APTS_Segment_Threshold__c();
        seg1.APTS_Approval_Required__c=True;
        seg1.APTS_Segment__c='Small Law';
        seg1.APTS_Customer_Category__c='5';
        seg1.APTS_Term_in_years__c=Integer.ValueOf('2');
        seg1.APTS_Minimum_OY_Increase__c=Integer.ValueOf('15');
        seg1.APTS_Minimum_Incremental_Growth__c=Integer.ValueOf('15');
        seg1.APTS_Product_Family__c = 'CLEAR';
        seg1.APTS_Promo_Codes__c = '13843014';
        seg1.APTS_Promo_Minimum_OY_Increase__c = 17;        
        segthrList.add(seg1);
        
        APTS_Segment_Threshold__c seg2 = new APTS_Segment_Threshold__c();
        seg2.APTS_Approval_Required__c=True;
        seg2.APTS_Segment__c='Corporate';
        seg2.APTS_Customer_Category__c='5';
        seg2.APTS_Term_in_years__c=Integer.ValueOf('2');
        seg2.APTS_Minimum_OY_Increase__c=Integer.ValueOf('15');
        seg2.APTS_Minimum_Incremental_Growth__c=Integer.ValueOf('15');
        seg2.APTS_Product_Family__c = 'CLEAR';
        seg2.APTS_Promo_Codes__c = '13843013';
        seg2.APTS_Promo_Minimum_OY_Increase__c = 16;        
        segthrList.add(seg2);
        system.assertEquals(seg2.APTS_Promo_Codes__c,'13843013');
                
        APTS_Segment_Threshold__c seg3 = new APTS_Segment_Threshold__c();
        seg3.APTS_Approval_Required__c=True;
        seg3.APTS_Segment__c='Corporate';
        seg3.APTS_Customer_Category__c='5';
        seg3.APTS_Term_in_years__c=Integer.ValueOf('2');
        seg3.APTS_Minimum_OY_Increase__c=Integer.ValueOf('15');
        seg3.APTS_Minimum_Incremental_Growth__c=Integer.ValueOf('15');
        segthrList.add(seg3);       
      
        APTS_Segment_Threshold__c seg4 = new APTS_Segment_Threshold__c();
        seg4.APTS_Approval_Required__c=True;
        seg4.APTS_Segment__c='Government';
        seg4.APTS_Customer_Category__c='5';
        seg4.APTS_Term_in_years__c=Integer.ValueOf('2');
        seg4.APTS_Minimum_OY_Increase__c=Integer.ValueOf('15');
        seg4.APTS_Minimum_Incremental_Growth__c=Integer.ValueOf('15');
        seg4.APTS_Product_Family__c = 'CLEAR';
        seg4.APTS_Promo_Codes__c = '13843012';
        seg4.APTS_Promo_Minimum_OY_Increase__c = 15;        
        segthrList.add(seg4);
        
        insert segthrList;
        
        Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
        Account a = new Account(RecordTypeId=accRecordTypeId,name='test-sg',sales_org__c='ABEP',customer_group__c='Academic',customer_type__c='Organization',customer_class_c__c='Academic Lecturer');
        a.APTS_Customer_Category__c = '5';
        a.Is_GLI__c = True;
        insert a;        
        
        Schema.DescribeFieldResult fieldResultMarket = Apttus_Config2__ProductConfiguration__c.APTS_AccountMirror_Picklist__c.getDescribe();
        String valueMarket = fieldResultMarket.getPicklistValues().get(0).getValue();
        
        //Inserting SourceSystemDetail
        List<Source_System_Detail__c> listOfSSD = new List<Source_System_Detail__c>();
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();
        
        Source_System_Detail__c accountSSD2= new Source_System_Detail__c();
        accountSSD2.RecordtypeId=ssdRecorType;
        accountSSD2.Name='ABC';
        accountSSD2.Source_System_Name__c='ABC';
        accountSSD2.Account_Name__c=a.ID;
        accountSSD2.APTS_Customer_Category__c='1';
        accountSSD2.LCRM_Customer_Group__c='Academic';
        accountSSD2.LCRM_Frozen_Market_Segment__c = valueMarket;
        accountSSD2.Account_Inactive__c=false;
        accountSSD2.LCRM_Sales_Org__c='CARS';
        accountSSD2.APTS_Has_Online_Assets__c=true;        
        listOfSSD.add(accountSSD2);
        insert listOfSSD;
        
        Date todaysDate = system.today();
        Id oppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Pipeline Opportunity').getRecordTypeId();
        Opportunity o = new Opportunity(RecordTypeId=oppRecordTypeId,  Name='tst-opp', stagename='25%',closedate=todaysDate,forecastcategoryname='pipeline',accountId=a.id);
        insert o;
        
        List<Apttus_Proposal__Proposal__c > listofProposals=new List<Apttus_Proposal__Proposal__c >();
        Id devRecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Proposal').getRecordTypeId();
        Apttus_Proposal__Proposal__c p2 = new Apttus_Proposal__Proposal__c(RecordTypeId=devRecordTypeId, CurrencyIsoCode = 'USD', Apttus_Proposal__Account__c=a.id,
            Apttus_Proposal__Proposal_Name__c='Corporate Proposal for approval',  Apttus_Proposal__Opportunity__c=o.id, 
            Apttus_Proposal__Approval_Stage__c='Draft', Apttus_Proposal__Proposal_Category__c='Quote', Apttus_Proposal__ReadyToGenerate__c = true, APTS_Approval_Segment__c='Canada',
            Apttus_Proposal__ReadyToPresent__c= true,APTS_SSD_Sold_To__c=accountSSD2.Id,APTS_SSD_ship_to__c=accountSSD2.Id,
            APTS_SSD_bill_to__c=accountSSD2.Id);
        p2.APTS_Proposal_Business_Unit__c = 'Canada';
        p2.APTS_Approval_Segment__c = 'Canada';
        listofProposals.add(p2);
        
        Apttus_Proposal__Proposal__c p3 = new Apttus_Proposal__Proposal__c(RecordTypeId=devRecordTypeId, CurrencyIsoCode = 'USD', Apttus_Proposal__Account__c=a.id,APTS_Approval_Segment__c='Canada',
            Apttus_Proposal__Proposal_Name__c='Corporate Proposal for approval',  Apttus_Proposal__Opportunity__c=o.id, 
            Apttus_Proposal__Approval_Stage__c='Draft', Apttus_Proposal__Proposal_Category__c='Quote', Apttus_Proposal__ReadyToGenerate__c = true, 
            Apttus_Proposal__ReadyToPresent__c= true,APTS_SSD_Sold_To__c=accountSSD2.Id,APTS_SSD_ship_to__c=accountSSD2.Id,
            APTS_SSD_bill_to__c=accountSSD2.Id);
        p3.APTS_Proposal_Business_Unit__c = 'Canada';
        p3.APTS_Approval_Segment__c = 'Canada';
        listofProposals.add(p3);
        insert listofProposals;
        
        List<Apttus_Config2__ProductConfiguration__c> listofProdconfig = new List<Apttus_Config2__ProductConfiguration__c >();       
        Apttus_Config2__ProductConfiguration__c prodConf2 = new Apttus_Config2__ProductConfiguration__c(Name='prod-conf2', CurrencyIsoCode = 'USD', Apttus_QPConfig__Proposald__c=p2.id, APTS_SSD_ship_to__c=accountSSD2.Id,APTS_SSD_bill_to__c=accountSSD2.Id);
        listofProdconfig.add(prodConf2);
        Apttus_Config2__ProductConfiguration__c prodConf3 = new Apttus_Config2__ProductConfiguration__c(Name='prod-conf2', CurrencyIsoCode = 'USD', Apttus_QPConfig__Proposald__c=p3.id, APTS_SSD_ship_to__c=accountSSD2.Id,APTS_SSD_bill_to__c=accountSSD2.Id);
        listofProdconfig.add(prodConf3);
        insert listofProdconfig;
        
        List<Product2 > listofProd=new List<Product2 > ();
        Product2 prod2 = new Product2(name='prod1', Media_High_Level__c='Online', CurrencyIsoCode = 'USD',APTS_Media_High_Level_Code__c='06',APTS_Media_Lower_Level_Code__c='49',APTS_Cat_L2__c = System.Label.APTS_Print_Product_Family,APTS_CAT_L3__c='L3_L030_FP');
        prod2.APTS_Approval_Always_Required__c = true;
        listofProd.add( prod2);
        Product2 prod = new Product2(name='prod2', Media_High_Level__c='Online', CurrencyIsoCode = 'USD',APTS_Media_High_Level_Code__c='06',APTS_Media_Lower_Level_Code__c='49',APTS_CAT_L2__c=System.Label.APTS_Clear_Product_Family,APTS_CAT_L3__c='L3_L030_FP');
        prod.APTS_Approval_Always_Required__c = true;
        listofProd.add( prod);
        insert listofProd;
        
        Apttus_Config2__ConfigSystemProperties__c configSetting=new Apttus_Config2__ConfigSystemProperties__c(Name='System Properties',Apttus_Config2__DisableConstraintRules__c=true);
        insert configSetting;

        test.startTest();
        List<Apttus_Config2__LineItem__c> listOfLineItems = new List<Apttus_Config2__LineItem__c>();        
        
        Apttus_Config2__LineItem__c li6 = new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c=prodConf3.id , Apttus_Config2__ProductId__c=prod.id);
        li6.Apttus_Config2__AddedBy__c = 'User';
        li6.Apttus_Config2__AdjustedPrice__c = 50;
        li6.Apttus_Config2__AdjustmentAmount__c = 50;
        li6.Apttus_Config2__AdjustmentType__c = '% Discount';
        li6.Apttus_Config2__AllocateGroupAdjustment__c = TRUE;
        li6.Apttus_Config2__AllowableAction__c = 'Unrestricted';
        li6.Apttus_Config2__AllowManualAdjustment__c = TRUE;
        li6.Apttus_Config2__AllowProration__c = FALSE;
        li6.Apttus_Config2__AllowRemoval__c = TRUE;
        li6.Apttus_Config2__AutoRenew__c = FALSE;
        li6.Apttus_Config2__BaseExtendedCost__c = 0;
        li6.Apttus_Config2__BaseExtendedPrice__c = 100;
        li6.Apttus_Config2__BasePrice__c = 100;
        li6.Apttus_Config2__BasePriceMethod__c = 'Per Unit';
        li6.Apttus_Config2__BillingFrequency__c = 'Monthly';
        li6.Apttus_Config2__ChargeType__c = 'Subscription Fee';
        li6.Apttus_Config2__ConfigStatus__c = 'Complete';
        li6.Apttus_Config2__ConstraintCheckStatus__c = 'NA';
        li6.Apttus_Config2__Customizable__c = FALSE;
        li6.Apttus_Config2__DeltaPrice__c = 50;
        li6.Apttus_Config2__DeltaQuantity__c = 1;
        li6.Apttus_Config2__Description__c = 'Westlaw Flex Plan $100/500';
        li6.Apttus_Config2__ExtendedCost__c = 0;
        li6.Apttus_Config2__ExtendedPrice__c = 100;
        li6.Apttus_Config2__Frequency__c = 'Monthly';
        li6.Apttus_Config2__Guidance__c = 'Red';       
        li6.Apttus_Config2__IsPrimaryLine__c = TRUE;        
        li6.Apttus_Config2__ItemSequence__c = 1;
        li6.Apttus_Config2__LineNumber__c = 1;
        li6.Apttus_Config2__LineSequence__c = 1;
        li6.Apttus_Config2__LineStatus__c = 'New';
        li6.APTS_Yr_1_Renewal_Adjustment__c='1';
        li6.Apttus_Config2__LineType__c = 'Product/Service';
        li6.Apttus_Config2__ListPrice__c = 100;
        li6.Apttus_Config2__NetAdjustmentPercent__c = -50;
        li6.Apttus_Config2__NetPrice__c = 50;
        li6.Apttus_Config2__NetUnitPrice__c = 50;
        li6.Apttus_Config2__OptionSequence__c = 0;        
        li6.Apttus_Config2__PriceMethod__c = 'Per Unit';
        li6.Apttus_Config2__PriceType__c = 'Recurring';
        li6.Apttus_Config2__PriceUom__c = 'Attorneys';
        li6.Apttus_Config2__PricingStatus__c = 'Complete';       
        li6.APTS_Product_Family__c='RUTTER';
        //li6.APTS_Cat_L3__c = System.Label.APTS_Rutter_Product_Family;
        li6.Apttus_Config2__Quantity__c = 1;
        li6.Apttus_Config2__RollupPriceToBundle__c = TRUE;
        li6.Apttus_Config2__SellingFrequency__c = 'Monthly';
        li6.Apttus_Config2__SellingTerm__c = 1;        
        li6.Apttus_Config2__Taxable__c = FALSE;
        li6.Apttus_Config2__TaxInclusive__c = FALSE;
        li6.Apttus_Config2__Term__c = 1;
        li6.Apttus_Config2__TotalQuantity__c = 1;
        li6.Apttus_Config2__Uom__c = 'Each';        
        li6.CurrencyIsoCode = 'CAD';
        li6.APTS_Product_Family__c = 'CLEAR';
       // li6.APTS_Cat_L2__c = System.Label.APTS_Clear_Product_Family;
        li6.APTS_Contract_Term__c = '2 Years';
        li6.APTS_Years_2_Plus_Adjustment__c = '5';
        li6.Apttus_Config2__IncentiveCode__c = '13843012,13843012';
        li6.APTS_Bridge__c='1 Month';                  
        listOfLineItems.add(li6);
        
        Apttus_Config2__LineItem__c li7 = new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c=prodConf2.id , Apttus_Config2__ProductId__c=prod.id);
        li7.Apttus_Config2__AddedBy__c = 'User';        
        li7.Apttus_Config2__BasePrice__c = 100;
        li7.Apttus_Config2__BasePriceMethod__c = 'Per Unit';
        li7.Apttus_Config2__BillingFrequency__c = 'Monthly';
        li7.Apttus_Config2__ChargeType__c = 'Subscription Fee';
        li7.Apttus_Config2__ConfigStatus__c = 'Complete';        
        li7.Apttus_Config2__Frequency__c = 'Monthly';        
        li7.Apttus_Config2__IsPrimaryLine__c = TRUE;        
        li7.Apttus_Config2__ItemSequence__c = 1;
        li7.Apttus_Config2__LineNumber__c = 1;
        li7.Apttus_Config2__LineSequence__c = 1;
        li7.Apttus_Config2__LineStatus__c = 'New';
        li7.APTS_Yr_1_Renewal_Adjustment__c='1';
        li7.Apttus_Config2__LineType__c = 'Product/Service';
        li7.Apttus_Config2__ListPrice__c = 100;        
        li7.Apttus_Config2__NetPrice__c = 50;
        li7.Apttus_Config2__NetUnitPrice__c = 50;        
        li7.Apttus_Config2__PriceMethod__c = 'Per Unit';
        li7.Apttus_Config2__PriceType__c = 'Recurring';
        li7.Apttus_Config2__PriceUom__c = 'Each';
        li7.Apttus_Config2__PricingStatus__c = 'Complete';
        li7.Apttus_Config2__PrimaryLineNumber__c = 1;
        li7.Apttus_Config2__ProductVersion__c = 1;        
        li7.Apttus_Config2__Quantity__c = 1;
        li7.Apttus_Config2__RollupPriceToBundle__c = TRUE;
        li7.Apttus_Config2__SellingFrequency__c = 'Monthly';
        li7.Apttus_Config2__SellingTerm__c = 1;                               
        li7.Apttus_Config2__TotalQuantity__c = 1;
        li7.Apttus_Config2__Uom__c = 'Each';
        li7.Apttus_CQApprov__Approval_Status__c = 'Pending Approval';
        li7.CurrencyIsoCode = 'USD';
        li7.APTS_Product_Family__c = 'CLEAR';
        //li7.APTS_Cat_L2__c = System.Label.APTS_Clear_Product_Family;
        li7.APTS_Contract_Term__c = '1 Year';
        li7.APTS_Years_2_Plus_Adjustment__c = '5';
        li7.APTS_Bridge__c = '2 Months';
        listOfLineItems.add(li7);
                
        Apttus_Config2__LineItem__c li8 = new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c=prodConf2.id , Apttus_Config2__ProductId__c=prod2.id);
        li8.Apttus_Config2__AddedBy__c = 'User';       
        li8.Apttus_Config2__BaseExtendedCost__c = 0;
        li8.Apttus_Config2__BaseExtendedPrice__c = 100;
        li8.Apttus_Config2__BasePrice__c = 100;
        li8.Apttus_Config2__BasePriceMethod__c = 'Per Unit';
        li8.Apttus_Config2__BillingFrequency__c = 'Monthly';
        li8.Apttus_Config2__ChargeType__c = 'Subscription Fee';
        li8.Apttus_Config2__ConfigStatus__c = 'Complete';
        li8.Apttus_Config2__ConstraintCheckStatus__c = 'NA';
        li8.Apttus_Config2__Customizable__c = FALSE;
        li8.Apttus_Config2__DeltaPrice__c = 50;
        li8.Apttus_Config2__DeltaQuantity__c = 1;
        li8.Apttus_Config2__Description__c = 'Westlaw Flex Plan $100/500';
        li8.Apttus_Config2__ExtendedCost__c = 0;
        li8.Apttus_Config2__ExtendedPrice__c = 100;
        li8.Apttus_Config2__Frequency__c = 'Monthly';
        li8.Apttus_Config2__Guidance__c = 'Red';       
        li8.Apttus_Config2__IsPrimaryLine__c = TRUE;        
        li8.Apttus_Config2__ItemSequence__c = 1;
        li8.Apttus_Config2__LineNumber__c = 1;
        li8.Apttus_Config2__LineSequence__c = 1;
        li8.Apttus_Config2__LineStatus__c = 'New';
        li8.APTS_Yr_1_Renewal_Adjustment__c='1';
        li8.Apttus_Config2__LineType__c = 'Product/Service';
        li8.Apttus_Config2__ListPrice__c = 100;
        li8.Apttus_Config2__NetAdjustmentPercent__c = -50;
        li8.Apttus_Config2__NetPrice__c = 50;
        li8.Apttus_Config2__NetUnitPrice__c = 50;
        li8.Apttus_Config2__OptionSequence__c = 0;        
        li8.Apttus_Config2__PriceMethod__c = 'Per Unit';
        li8.Apttus_Config2__PriceType__c = 'Recurring';
        li8.Apttus_Config2__PriceUom__c = 'Attorneys';
        li8.Apttus_Config2__PricingStatus__c = 'Complete';
        li8.Apttus_Config2__Quantity__c = 1;
        li8.Apttus_Config2__RollupPriceToBundle__c = TRUE;
        li8.Apttus_Config2__SellingFrequency__c = 'Monthly';
        li8.Apttus_Config2__SellingTerm__c = 1;        
        li8.Apttus_Config2__Taxable__c = FALSE;
        li8.Apttus_Config2__TaxInclusive__c = FALSE;
        li8.Apttus_Config2__Term__c = 1;
        li8.Apttus_Config2__TotalQuantity__c = 1;
        li8.Apttus_Config2__Uom__c = 'Each';        
        li8.CurrencyIsoCode = 'USD';
        li8.APTS_Product_Family__c = 'PRINT LEGAL SOLUTIONS';
        //li8.APTS_Cat_L2__c = System.Label.APTS_Print_Product_Family;
        li8.APTS_Contract_Term__c = '2 Years';
        li8.APTS_Years_2_Plus_Adjustment__c = '5';        
        li8.APTS_Bridge__c='3 Months';                   
        listOfLineItems.add(li8);

        Apttus_Config2__LineItem__c li9 = new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c=prodConf2.id , Apttus_Config2__ProductId__c=prod.id);
        li9.Apttus_Config2__AddedBy__c = 'User';
        li9.Apttus_Config2__AdjustedPrice__c = 50;
        li9.Apttus_Config2__AdjustmentAmount__c = 50;
        li9.Apttus_Config2__AdjustmentType__c = '% Discount';
        li9.Apttus_Config2__AllocateGroupAdjustment__c = TRUE;
        li9.Apttus_Config2__AllowableAction__c = 'Unrestricted';
        li9.Apttus_Config2__AllowManualAdjustment__c = TRUE;
        li9.Apttus_Config2__AllowProration__c = FALSE;
        li9.Apttus_Config2__AllowRemoval__c = TRUE;
        li9.Apttus_Config2__AutoRenew__c = FALSE;
        li9.Apttus_Config2__BaseExtendedCost__c = 0;
        li9.Apttus_Config2__BaseExtendedPrice__c = 100;
        li9.Apttus_Config2__BasePrice__c = 100;
        li9.Apttus_Config2__BasePriceMethod__c = 'Per Unit';
        li9.Apttus_Config2__BillingFrequency__c = 'Monthly';
        li9.Apttus_Config2__ChargeType__c = 'Subscription Fee';
        li9.Apttus_Config2__ConfigStatus__c = 'Complete';
        li9.Apttus_Config2__ConstraintCheckStatus__c = 'NA';
        li9.Apttus_Config2__Customizable__c = FALSE;
        li9.Apttus_Config2__DeltaPrice__c = 50;
        li9.Apttus_Config2__DeltaQuantity__c = 1;
        li9.Apttus_Config2__Description__c = 'Westlaw Flex Plan $100/500';
        li9.Apttus_Config2__ExtendedCost__c = 0;
        li9.Apttus_Config2__ExtendedPrice__c = 100;
        li9.Apttus_Config2__Frequency__c = 'Monthly';
        li9.Apttus_Config2__Guidance__c = 'Red';       
        li9.Apttus_Config2__IsPrimaryLine__c = TRUE;        
        li9.Apttus_Config2__ItemSequence__c = 1;
        li9.Apttus_Config2__LineNumber__c = 1;
        li9.Apttus_Config2__LineSequence__c = 1;
        li9.Apttus_Config2__LineStatus__c = 'New';
        li9.APTS_Yr_1_Renewal_Adjustment__c='1';
        li9.Apttus_Config2__LineType__c = 'Product/Service';
        li9.Apttus_Config2__ListPrice__c = 100;
        li9.Apttus_Config2__NetAdjustmentPercent__c = -50;
        li9.Apttus_Config2__NetPrice__c = 50;
        li9.Apttus_Config2__NetUnitPrice__c = 50;
        li9.Apttus_Config2__OptionSequence__c = 0;        
        li9.Apttus_Config2__PriceMethod__c = 'Per Unit';
        li9.Apttus_Config2__PriceType__c = 'Recurring';
        li9.Apttus_Config2__PriceUom__c = 'Attorneys';
        li9.Apttus_Config2__PricingStatus__c = 'Complete';               
        li9.Apttus_Config2__Quantity__c = 1;
        li9.Apttus_Config2__RollupPriceToBundle__c = TRUE;
        li9.Apttus_Config2__SellingFrequency__c = 'Monthly';
        li9.Apttus_Config2__SellingTerm__c = 1;        
        li9.Apttus_Config2__Taxable__c = FALSE;
        li9.Apttus_Config2__TaxInclusive__c = FALSE;
        li9.Apttus_Config2__Term__c = 1;
        li9.Apttus_Config2__TotalQuantity__c = 1;
        li9.Apttus_Config2__Uom__c = 'Each';        
        li9.CurrencyIsoCode = 'USD';
        li9.APTS_Product_Family__c = 'CLEAR';
        //li9.APTS_Cat_L2__c = System.Label.APTS_Clear_Product_Family;
        li9.APTS_Contract_Term__c = '1 Year';
        li9.APTS_Years_2_Plus_Adjustment__c = '5';        
        li9.APTS_Bridge__c='2 Months';                   
        listOfLineItems.add(li9);
        
        Apttus_Config2__LineItem__c li10 = new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c=prodConf2.id , Apttus_Config2__ProductId__c=prod.id);
        li10.Apttus_Config2__AddedBy__c = 'User';
        li10.Apttus_Config2__AdjustedPrice__c = 50;
        li10.Apttus_Config2__AdjustmentAmount__c = 50;
        li10.Apttus_Config2__AdjustmentType__c = '% Discount';
        li10.Apttus_Config2__AllocateGroupAdjustment__c = TRUE;
        li10.Apttus_Config2__AllowableAction__c = 'Unrestricted';
        li10.Apttus_Config2__AllowManualAdjustment__c = TRUE;
        li10.Apttus_Config2__AllowProration__c = FALSE;
        li10.Apttus_Config2__AllowRemoval__c = TRUE;
        li10.Apttus_Config2__AutoRenew__c = FALSE;
        li10.Apttus_Config2__BaseExtendedCost__c = 0;
        li10.Apttus_Config2__BaseExtendedPrice__c = 100;
        li10.Apttus_Config2__BasePrice__c = 100;
        li10.Apttus_Config2__BasePriceMethod__c = 'Per Unit';
        li10.Apttus_Config2__BillingFrequency__c = 'Monthly';
        li10.Apttus_Config2__ChargeType__c = 'Subscription Fee';
        li10.Apttus_Config2__ConfigStatus__c = 'Complete';
        li10.Apttus_Config2__ConstraintCheckStatus__c = 'NA';
        li10.Apttus_Config2__Customizable__c = FALSE;
        li10.Apttus_Config2__DeltaPrice__c = 50;
        li10.Apttus_Config2__DeltaQuantity__c = 1;
        li10.Apttus_Config2__Description__c = 'Westlaw Flex Plan $100/500';
        li10.Apttus_Config2__ExtendedCost__c = 0;
        li10.Apttus_Config2__ExtendedPrice__c = 100;
        li10.Apttus_Config2__Frequency__c = 'Monthly';
        li10.Apttus_Config2__Guidance__c = 'Red';       
        li10.Apttus_Config2__IsPrimaryLine__c = TRUE;        
        li10.Apttus_Config2__ItemSequence__c = 1;
        li10.Apttus_Config2__LineNumber__c = 1;
        li10.Apttus_Config2__LineSequence__c = 1;
        li10.Apttus_Config2__LineStatus__c = 'New';
        li10.APTS_Yr_1_Renewal_Adjustment__c='1';
        li10.Apttus_Config2__LineType__c = 'Product/Service';
        li10.Apttus_Config2__ListPrice__c = 100;
        li10.Apttus_Config2__NetAdjustmentPercent__c = -50;
        li10.Apttus_Config2__NetPrice__c = 50;
        li10.Apttus_Config2__NetUnitPrice__c = 50;
        li10.Apttus_Config2__OptionSequence__c = 0;        
        li10.Apttus_Config2__PriceMethod__c = 'Per Unit';
        li10.Apttus_Config2__PriceType__c = 'Recurring';
        li10.Apttus_Config2__PriceUom__c = 'Attorneys';
        li10.Apttus_Config2__PricingStatus__c = 'Complete';               
        li10.Apttus_Config2__Quantity__c = 1;
        li10.Apttus_Config2__RollupPriceToBundle__c = TRUE;
        li10.Apttus_Config2__SellingFrequency__c = 'Monthly';
        li10.Apttus_Config2__SellingTerm__c = 1;        
        li10.Apttus_Config2__Taxable__c = FALSE;
        li10.Apttus_Config2__TaxInclusive__c = FALSE;
        li10.Apttus_Config2__Term__c = 1;
        li10.Apttus_Config2__TotalQuantity__c = 1;
        li10.Apttus_Config2__Uom__c = 'Each';        
        li10.CurrencyIsoCode = 'USD';
        li10.APTS_Product_Family__c = 'CLEAR';
        //li10.APTS_Cat_L2__c = System.Label.APTS_Clear_Product_Family;
        li10.APTS_Contract_Term__c = '1 Year';
        li10.APTS_Years_2_Plus_Adjustment__c = '5';        
        li10.APTS_Bridge__c='1 Month';   
        li10.APTS_New_Bridge_Discount__c=100;                
        listOfLineItems.add(li10);
      
      
        Apttus_Config2__LineItem__c li11 = new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c=prodConf2.id , Apttus_Config2__ProductId__c=prod.id);
        li11.Apttus_Config2__AddedBy__c = 'User';
        li11.Apttus_Config2__AdjustedPrice__c = 50;
        li11.Apttus_Config2__AdjustmentAmount__c = 50;
        li11.Apttus_Config2__AdjustmentType__c = '% Discount';
        li11.Apttus_Config2__AllocateGroupAdjustment__c = TRUE;
        li11.Apttus_Config2__AllowableAction__c = 'Unrestricted';
        li11.Apttus_Config2__AllowManualAdjustment__c = TRUE;
        li11.Apttus_Config2__AllowProration__c = FALSE;
        li11.Apttus_Config2__AllowRemoval__c = TRUE;
        li11.Apttus_Config2__AutoRenew__c = FALSE;
        li11.Apttus_Config2__BaseExtendedCost__c = 0;
        li11.Apttus_Config2__BaseExtendedPrice__c = 100;
        li11.Apttus_Config2__BasePrice__c = 100;
        li11.Apttus_Config2__BasePriceMethod__c = 'Per Unit';
        li11.Apttus_Config2__BillingFrequency__c = 'Monthly';
        li11.Apttus_Config2__ChargeType__c = 'Subscription Fee';
        li11.Apttus_Config2__ConfigStatus__c = 'Complete';
        li11.Apttus_Config2__ConstraintCheckStatus__c = 'NA';
        li11.Apttus_Config2__Customizable__c = FALSE;
        li11.Apttus_Config2__DeltaPrice__c = 50;
        li11.Apttus_Config2__DeltaQuantity__c = 1;
        li11.Apttus_Config2__Description__c = 'Westlaw Flex Plan $100/500';
        li11.Apttus_Config2__ExtendedCost__c = 0;
        li11.Apttus_Config2__ExtendedPrice__c = 100;
        li11.Apttus_Config2__Frequency__c = 'Monthly';
        li11.Apttus_Config2__Guidance__c = 'Red';       
        li11.Apttus_Config2__IsPrimaryLine__c = TRUE;        
        li11.Apttus_Config2__ItemSequence__c = 1;
        li11.Apttus_Config2__LineNumber__c = 1;
        li11.Apttus_Config2__LineSequence__c = 1;
        li11.Apttus_Config2__LineStatus__c = 'New';
        li11.APTS_Yr_1_Renewal_Adjustment__c='1';
        li11.Apttus_Config2__LineType__c = 'Product/Service';
        li11.Apttus_Config2__ListPrice__c = 100;
        li11.Apttus_Config2__NetAdjustmentPercent__c = -50;
        li11.Apttus_Config2__NetPrice__c = 50;
        li11.Apttus_Config2__NetUnitPrice__c = 50;
        li11.Apttus_Config2__OptionSequence__c = 0;        
        li11.Apttus_Config2__PriceMethod__c = 'Per Unit';
        li11.Apttus_Config2__PriceType__c = 'Recurring';
        li11.Apttus_Config2__PriceUom__c = 'Attorneys';
        li11.Apttus_Config2__PricingStatus__c = 'Complete';               
        li11.Apttus_Config2__Quantity__c = 1;
        li11.Apttus_Config2__RollupPriceToBundle__c = TRUE;
        li11.Apttus_Config2__SellingFrequency__c = 'Monthly';
        li11.Apttus_Config2__SellingTerm__c = 1;        
        li11.Apttus_Config2__Taxable__c = FALSE;
        li11.Apttus_Config2__TaxInclusive__c = FALSE;
        li11.Apttus_Config2__Term__c = 1;
        li11.Apttus_Config2__TotalQuantity__c = 1;
        li11.Apttus_Config2__Uom__c = 'Each';        
        li11.CurrencyIsoCode = 'USD';
        li11.APTS_Product_Family__c = 'CLEAR';
        //li11.APTS_Cat_L2__c = System.Label.APTS_Clear_Product_Family;
        li11.APTS_Contract_Term__c = '1 Year';
        li11.APTS_Years_2_Plus_Adjustment__c = '5';        
        li11.APTS_Bridge__c='2 Months';   
        li11.APTS_New_Bridge_Discount__c=100;                
        listOfLineItems.add(li11);
        insert listOfLineItems;        
          
        accountSSD2.APTS_Has_Online_Assets__c=false;        
        
        update accountSSD2;     
        li7.APTS_Contract_Term__c= '2 Years';
        li7.APTS_Bridge__c='6 Months';       
        li8.APTS_Contract_Term__c = '3 Years';
        li8.APTS_Bridge__c='7 Months';  
        li9.APTS_Contract_Term__c = '1 Year';
        li9.APTS_Bridge__c='3 Months';
               
        update listOfLineItems;
        APTS_LineItemTriggerHelper.populateAllApprovalRequiredCB(listOfLineItems);
        
        Test.stopTest();        
    }
    
    //Coverage for Tax Professional Code
    static testMethod void bridgeApprovalTestTax() {
        
        LTS_Disable_Application_Automation__c ltstemp = new LTS_Disable_Application_Automation__c();
        ltstemp.LTS_Disable_Process_Builders__c = true;
        ltstemp.LTS_Disable_Triggers__c = true;
        ltstemp.LTS_Disable_Validation_Rules__c = true;
        ltstemp.LTS_Disable_Workflow_Rules__c = true;
        ltstemp.Name = 'temp';
        ltstemp.SetupOwnerId = userinfo.getuserid();
        insert ltstemp;
        
        KeyValueListStore__c keyvaluestore=new  KeyValueListStore__c();
        keyvaluestore.Name='ANZUsersProfileId';
        keyvaluestore.TextValue__c=System.Label.APTS_OC_Test_Id;
        insert keyvaluestore; 
        WebServiceSettings__c oWebServiceSettings = new WebServiceSettings__c();
        oWebServiceSettings.Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable'; 
        oWebServiceSettings.Name = 'PaymentCreditIncrease'; 
        oWebServiceSettings.Timeout__c = 120; 
        oWebServiceSettings.Endpoint__c = 'https://dev.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease'; 
        oWebServiceSettings.Active__c = true;
        insert oWebServiceSettings;
        List<WebServiceSettings__c> webserviceList = new List<WebServiceSettings__c>{new WebServiceSettings__c(Name='EnterpriseWSDL',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
           new WebServiceSettings__c(Name='StatusPostbackLocation',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
           new WebServiceSettings__c(Name='PostbackLocation',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
           new WebServiceSettings__c(Name='Payment AutoCharge',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available')};
        insert webserviceList;  
        //Inserting recordLists
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
        
        List<APTS_Segment_Threshold__c> segthrList= new List<APTS_Segment_Threshold__c>();
        //Add Segment threshold
        APTS_Segment_Threshold__c seg1 = new APTS_Segment_Threshold__c();
        seg1.APTS_Approval_Required__c=True;
        seg1.APTS_Segment__c='Small Law';
        seg1.APTS_Customer_Category__c='5';
        seg1.APTS_Term_in_years__c=Integer.ValueOf('2');
        seg1.APTS_Minimum_OY_Increase__c=Integer.ValueOf('15');
        seg1.APTS_Minimum_Incremental_Growth__c=Integer.ValueOf('15');
        seg1.APTS_Product_Family__c = 'CLEAR';
        seg1.APTS_Promo_Codes__c = '13843014';
        seg1.APTS_Promo_Minimum_OY_Increase__c = 17;        
        segthrList.add(seg1);
        
        APTS_Segment_Threshold__c seg2 = new APTS_Segment_Threshold__c();
        seg2.APTS_Approval_Required__c=True;
        seg2.APTS_Segment__c='Corporate';
        seg2.APTS_Customer_Category__c='5';
        seg2.APTS_Term_in_years__c=Integer.ValueOf('2');
        seg2.APTS_Minimum_OY_Increase__c=Integer.ValueOf('15');
        seg2.APTS_Minimum_Incremental_Growth__c=Integer.ValueOf('15');
        seg2.APTS_Product_Family__c = 'CLEAR';
        seg2.APTS_Promo_Codes__c = '13843013';
        seg2.APTS_Promo_Minimum_OY_Increase__c = 16;        
        segthrList.add(seg2);
        system.assertEquals(seg2.APTS_Promo_Codes__c,'13843013');

        APTS_Segment_Threshold__c seg3 = new APTS_Segment_Threshold__c();
        seg3.APTS_Approval_Required__c=True;
        seg3.APTS_Segment__c='Corporate';
        seg3.APTS_Customer_Category__c='5';
        seg3.APTS_Term_in_years__c=Integer.ValueOf('2');
        seg3.APTS_Minimum_OY_Increase__c=Integer.ValueOf('15');
        seg3.APTS_Minimum_Incremental_Growth__c=Integer.ValueOf('15');
        segthrList.add(seg3);       
      
        APTS_Segment_Threshold__c seg4 = new APTS_Segment_Threshold__c();
        seg4.APTS_Approval_Required__c=True;
        seg4.APTS_Segment__c='Government';
        seg4.APTS_Customer_Category__c='5';
        seg4.APTS_Term_in_years__c=Integer.ValueOf('2');
        seg4.APTS_Minimum_OY_Increase__c=Integer.ValueOf('15');
        seg4.APTS_Minimum_Incremental_Growth__c=Integer.ValueOf('15');
        seg4.APTS_Product_Family__c = 'CLEAR';
        seg4.APTS_Promo_Codes__c = '13843012';
        seg4.APTS_Promo_Minimum_OY_Increase__c = 15;        
        segthrList.add(seg4);
        
        insert segthrList;
        
        Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
        Account a = new Account(RecordTypeId=accRecordTypeId,name='test-sg',sales_org__c='ABEP',customer_group__c='Academic',customer_type__c='Organization',customer_class_c__c='Academic Lecturer');
        a.APTS_Customer_Category__c = '5';
        a.Is_GLI__c = True;
        insert a;        
        
        Schema.DescribeFieldResult fieldResultMarket = Apttus_Config2__ProductConfiguration__c.APTS_AccountMirror_Picklist__c.getDescribe();
        String valueMarket = fieldResultMarket.getPicklistValues().get(0).getValue();
        
        //Inserting SourceSystemDetail
        List<Source_System_Detail__c> listOfSSD = new List<Source_System_Detail__c>();
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();
        
        Source_System_Detail__c accountSSD2= new Source_System_Detail__c();
        accountSSD2.RecordtypeId=ssdRecorType;
        accountSSD2.Name='ABC';
        accountSSD2.Source_System_Name__c='ABC';
        accountSSD2.Account_Name__c=a.ID;
        accountSSD2.APTS_Customer_Category__c='1';
        accountSSD2.LCRM_Customer_Group__c='Academic';
        accountSSD2.LCRM_Frozen_Market_Segment__c = valueMarket;
        accountSSD2.Account_Inactive__c=false;
        accountSSD2.LCRM_Sales_Org__c='S100';
        accountSSD2.APTS_Has_Online_Assets__c=false;        
        listOfSSD.add(accountSSD2);
        insert listOfSSD;
        
        Date todaysDate = system.today();
        Id oppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Pipeline Opportunity').getRecordTypeId();
        Opportunity o = new Opportunity(RecordTypeId=oppRecordTypeId,  Name='tst-opp', stagename='25%',closedate=todaysDate,forecastcategoryname='pipeline',accountId=a.id);
        insert o;
        
        List<Apttus_Proposal__Proposal__c > listofProposals=new List<Apttus_Proposal__Proposal__c >();
        Id devRecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Proposal').getRecordTypeId();
        Apttus_Proposal__Proposal__c p2 = new Apttus_Proposal__Proposal__c(RecordTypeId=devRecordTypeId, CurrencyIsoCode = 'USD', Apttus_Proposal__Account__c=a.id,
            Apttus_Proposal__Proposal_Name__c='Corporate Proposal for approval',  Apttus_Proposal__Opportunity__c=o.id, 
            Apttus_Proposal__Approval_Stage__c='Draft', Apttus_Proposal__Proposal_Category__c='Quote', Apttus_Proposal__ReadyToGenerate__c = true, 
            Apttus_Proposal__ReadyToPresent__c= true,APTS_SSD_Sold_To__c=accountSSD2.Id,APTS_SSD_ship_to__c=accountSSD2.Id,
            APTS_SSD_bill_to__c=accountSSD2.Id);
        p2.APTS_Proposal_Business_Unit__c = 'Tax Professional';
        p2.APTS_Approval_Segment__c = 'Tax Prof–Small–Mid Tax';
        listofProposals.add(p2);
        
        insert listofProposals;
        
        List<Apttus_Config2__ProductConfiguration__c> listofProdconfig = new List<Apttus_Config2__ProductConfiguration__c >();       
        Apttus_Config2__ProductConfiguration__c prodConf2 = new Apttus_Config2__ProductConfiguration__c(Name='prod-conf2', CurrencyIsoCode = 'USD', Apttus_QPConfig__Proposald__c=p2.id, APTS_SSD_ship_to__c=accountSSD2.Id,APTS_SSD_bill_to__c=accountSSD2.Id);
        listofProdconfig.add(prodConf2);
        
        insert listofProdconfig;
        
        Product2 prod = new Product2(name='prod1', Media_High_Level__c='Online', CurrencyIsoCode = 'USD',APTS_CAT_L2__c=System.Label.APTS_Clear_Product_Family,APTS_CAT_L3__c='L3_L030_FP');
        prod.APTS_Approval_Always_Required__c = true;
        insert prod;

        
        Apttus_Config2__ConfigSystemProperties__c configSetting=new Apttus_Config2__ConfigSystemProperties__c(Name='System Properties',Apttus_Config2__DisableConstraintRules__c=true);
        insert configSetting;

        test.startTest();
        List<Apttus_Config2__LineItem__c> listOfLineItems = new List<Apttus_Config2__LineItem__c>();        
        
        Apttus_Config2__LineItem__c li1 = new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c=prodConf2.id , Apttus_Config2__ProductId__c=prod.id);
        li1.Apttus_Config2__AddedBy__c = 'User';
        li1.Apttus_Config2__AdjustedPrice__c = 50;
        li1.Apttus_Config2__AdjustmentAmount__c = 50;
        li1.Apttus_Config2__AdjustmentType__c = '% Discount';
        li1.Apttus_Config2__AllocateGroupAdjustment__c = TRUE;
        li1.Apttus_Config2__AllowableAction__c = 'Unrestricted';
        li1.Apttus_Config2__AllowManualAdjustment__c = TRUE;
        li1.Apttus_Config2__AllowProration__c = FALSE;
        li1.Apttus_Config2__AllowRemoval__c = TRUE;
        li1.Apttus_Config2__AutoRenew__c = FALSE;
        li1.Apttus_Config2__BaseExtendedCost__c = 0;
        li1.Apttus_Config2__BaseExtendedPrice__c = 100;
        li1.Apttus_Config2__BasePrice__c = 100;
        li1.Apttus_Config2__BasePriceMethod__c = 'Per Unit';
        li1.Apttus_Config2__BillingFrequency__c = 'Monthly';
        li1.Apttus_Config2__ChargeType__c = 'Subscription Fee';
        li1.Apttus_Config2__ConfigStatus__c = 'Complete';
        li1.Apttus_Config2__ConstraintCheckStatus__c = 'NA';
        li1.Apttus_Config2__Customizable__c = FALSE;
        li1.Apttus_Config2__DeltaPrice__c = 50;
        li1.Apttus_Config2__DeltaQuantity__c = 1;
        li1.Apttus_Config2__Description__c = 'Westlaw Flex Plan $100/500';
        li1.Apttus_Config2__ExtendedCost__c = 0;
        li1.Apttus_Config2__ExtendedPrice__c = 100;
        li1.Apttus_Config2__Frequency__c = 'Monthly';
        li1.Apttus_Config2__Guidance__c = 'Red';       
        li1.Apttus_Config2__IsPrimaryLine__c = TRUE;        
        li1.Apttus_Config2__ItemSequence__c = 1;
        li1.Apttus_Config2__LineNumber__c = 1;
        li1.Apttus_Config2__LineSequence__c = 1;
        li1.Apttus_Config2__LineStatus__c = 'New';
        li1.APTS_Yr_1_Renewal_Adjustment__c='1';
        li1.Apttus_Config2__LineType__c = 'Product/Service';
        li1.Apttus_Config2__ListPrice__c = 100;
        li1.Apttus_Config2__NetAdjustmentPercent__c = -50;
        li1.Apttus_Config2__NetPrice__c = 50;
        li1.Apttus_Config2__NetUnitPrice__c = 50;
        li1.Apttus_Config2__OptionSequence__c = 0;        
        li1.Apttus_Config2__PriceMethod__c = 'Per Unit';
        li1.Apttus_Config2__PriceType__c = 'Recurring';
        li1.Apttus_Config2__PriceUom__c = 'Attorneys';
        li1.Apttus_Config2__PricingStatus__c = 'Complete';       
        li1.APTS_Product_Family__c='RUTTER';
        //li1.APTS_Cat_L3__c = System.Label.APTS_Rutter_Product_Family;
        li1.Apttus_Config2__Quantity__c = 1;
        li1.Apttus_Config2__RollupPriceToBundle__c = TRUE;
        li1.Apttus_Config2__SellingFrequency__c = 'Monthly';
        li1.Apttus_Config2__SellingTerm__c = 1;        
        li1.Apttus_Config2__Taxable__c = FALSE;
        li1.Apttus_Config2__TaxInclusive__c = FALSE;
        li1.Apttus_Config2__Term__c = 1;
        li1.Apttus_Config2__TotalQuantity__c = 1;
        li1.Apttus_Config2__Uom__c = 'Each';        
        li1.CurrencyIsoCode = 'USD';
        li1.APTS_Product_Family__c = 'CLEAR';
        //li1.APTS_Cat_L2__c = System.Label.APTS_Clear_Product_Family;
        li1.APTS_Contract_Term__c = '1 Year';
        li1.APTS_Years_2_Plus_Adjustment__c = '2';
        li1.Apttus_Config2__IncentiveCode__c = '13843012,13843012';
        li1.APTS_Bridge__c='2 Months';
        
        li1.APTS_Calculated_Min_YOY__c=2;
       
        insert li1;
        
        Apttus_Config2__LineItem__c li11 = new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c=prodConf2.id , Apttus_Config2__ProductId__c=prod.id);
        li11.Apttus_Config2__AddedBy__c = 'User';
        li11.Apttus_Config2__AdjustedPrice__c = 50;
        li11.Apttus_Config2__AdjustmentAmount__c = 50;
        li11.Apttus_Config2__AdjustmentType__c = '% Discount';
        li11.Apttus_Config2__AllocateGroupAdjustment__c = TRUE;
        li11.Apttus_Config2__AllowableAction__c = 'Unrestricted';
        li11.Apttus_Config2__AllowManualAdjustment__c = TRUE;
        li11.Apttus_Config2__AllowProration__c = FALSE;
        li11.Apttus_Config2__AllowRemoval__c = TRUE;
        li11.Apttus_Config2__AutoRenew__c = FALSE;
        li11.Apttus_Config2__BaseExtendedCost__c = 0;
        li11.Apttus_Config2__BaseExtendedPrice__c = 100;
        li11.Apttus_Config2__BasePrice__c = 100;
        li11.Apttus_Config2__BasePriceMethod__c = 'Per Unit';
        li11.Apttus_Config2__BillingFrequency__c = 'Monthly';
        li11.Apttus_Config2__ChargeType__c = 'Subscription Fee';
        li11.Apttus_Config2__ConfigStatus__c = 'Complete';
        li11.Apttus_Config2__ConstraintCheckStatus__c = 'NA';
        li11.Apttus_Config2__Customizable__c = FALSE;
        li11.Apttus_Config2__DeltaPrice__c = 50;
        li11.Apttus_Config2__DeltaQuantity__c = 1;
        li11.Apttus_Config2__Description__c = 'Westlaw Flex Plan $100/500';
        li11.Apttus_Config2__ExtendedCost__c = 0;
        li11.Apttus_Config2__ExtendedPrice__c = 100;
        li11.Apttus_Config2__Frequency__c = 'Monthly';
        li11.Apttus_Config2__Guidance__c = 'Red';       
        li11.Apttus_Config2__IsPrimaryLine__c = TRUE;        
        li11.Apttus_Config2__ItemSequence__c = 1;
        li11.Apttus_Config2__LineNumber__c = 1;
        li11.Apttus_Config2__LineSequence__c = 1;
        li11.Apttus_Config2__LineStatus__c = 'New';
        li11.APTS_Yr_1_Renewal_Adjustment__c='1';
        li11.Apttus_Config2__LineType__c = 'Product/Service';
        li11.Apttus_Config2__ListPrice__c = 100;
        li11.Apttus_Config2__NetAdjustmentPercent__c = -50;
        li11.Apttus_Config2__NetPrice__c = 50;
        li11.Apttus_Config2__NetUnitPrice__c = 50;
        li11.Apttus_Config2__OptionSequence__c = 0;        
        li11.Apttus_Config2__PriceMethod__c = 'Per Unit';
        li11.Apttus_Config2__PriceType__c = 'Recurring';
        li11.Apttus_Config2__PriceUom__c = 'Attorneys';
        li11.Apttus_Config2__PricingStatus__c = 'Complete';       
        li11.APTS_Product_Family__c='RUTTER';
        //li1.APTS_Cat_L3__c = System.Label.APTS_Rutter_Product_Family;
        li11.Apttus_Config2__Quantity__c = 1;
        li11.Apttus_Config2__RollupPriceToBundle__c = TRUE;
        li11.Apttus_Config2__SellingFrequency__c = 'Monthly';
        li11.Apttus_Config2__SellingTerm__c = 1;        
        li11.Apttus_Config2__Taxable__c = FALSE;
        li11.Apttus_Config2__TaxInclusive__c = FALSE;
        li11.Apttus_Config2__Term__c = 1;
        li11.Apttus_Config2__TotalQuantity__c = 1;
        li11.Apttus_Config2__Uom__c = 'Each';        
        li11.CurrencyIsoCode = 'USD';
        li11.APTS_Product_Family__c = 'CLEAR';
        //li1.APTS_Cat_L2__c = System.Label.APTS_Clear_Product_Family;
        li11.APTS_Contract_Term__c = '1 Year';
        li11.APTS_Years_2_Plus_Adjustment__c = '2';
        li11.Apttus_Config2__IncentiveCode__c = '13843012,13843012';
        li11.APTS_Bridge__c='2 Months'; 
        li11.APTS_Calculated_Min_YOY__c = 2;
        insert li11;
        
          
        accountSSD2.APTS_Has_Online_Assets__c=false; 
        update accountSSD2;     
        
        Apttus_Config2__LineItem__c li2 = new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c=prodConf2.id , Apttus_Config2__ProductId__c=prod.id);
        li2.Apttus_Config2__AddedBy__c = 'User';
        li2.Apttus_Config2__AdjustedPrice__c = 50;
        li2.Apttus_Config2__AdjustmentAmount__c = 50;
        li2.Apttus_Config2__AdjustmentType__c = '% Discount';
        li2.Apttus_Config2__AllocateGroupAdjustment__c = TRUE;
        li2.Apttus_Config2__AllowableAction__c = 'Unrestricted';
        li2.Apttus_Config2__AllowManualAdjustment__c = TRUE;
        li2.Apttus_Config2__AllowProration__c = FALSE;
        li2.Apttus_Config2__AllowRemoval__c = TRUE;
        li2.Apttus_Config2__AutoRenew__c = FALSE;
        li2.Apttus_Config2__BaseExtendedCost__c = 0;
        li2.Apttus_Config2__BaseExtendedPrice__c = 100;
        li2.Apttus_Config2__BasePrice__c = 100;
        li2.Apttus_Config2__BasePriceMethod__c = 'Per Unit';
        li2.Apttus_Config2__BillingFrequency__c = 'Monthly';
        li2.Apttus_Config2__ChargeType__c = 'Subscription Fee';
        li2.Apttus_Config2__ConfigStatus__c = 'Complete';
        li2.Apttus_Config2__ConstraintCheckStatus__c = 'NA';
        li2.Apttus_Config2__Customizable__c = FALSE;
        li2.Apttus_Config2__DeltaPrice__c = 50;
        li2.Apttus_Config2__DeltaQuantity__c = 1;
        li2.Apttus_Config2__Description__c = 'Westlaw Flex Plan $100/500';
        li2.Apttus_Config2__ExtendedCost__c = 0;
        li2.Apttus_Config2__ExtendedPrice__c = 100;
        li2.Apttus_Config2__Frequency__c = 'Monthly';
        li2.Apttus_Config2__Guidance__c = 'Red';       
        li2.Apttus_Config2__IsPrimaryLine__c = TRUE;        
        li2.Apttus_Config2__ItemSequence__c = 1;
        li2.Apttus_Config2__LineNumber__c = 1;
        li2.Apttus_Config2__LineSequence__c = 1;
        li2.Apttus_Config2__LineStatus__c = 'New';
        li2.APTS_Yr_1_Renewal_Adjustment__c='1';
        li2.Apttus_Config2__LineType__c = 'Product/Service';
        li2.Apttus_Config2__ListPrice__c = 100;
        li2.Apttus_Config2__NetAdjustmentPercent__c = -50;
        li2.Apttus_Config2__NetPrice__c = 50;
        li2.Apttus_Config2__NetUnitPrice__c = 50;
        li2.Apttus_Config2__OptionSequence__c = 0;        
        li2.Apttus_Config2__PriceMethod__c = 'Per Unit';
        li2.Apttus_Config2__PriceType__c = 'Recurring';
        li2.Apttus_Config2__PriceUom__c = 'Attorneys';
        li2.Apttus_Config2__PricingStatus__c = 'Complete';       
        li2.APTS_Product_Family__c='RUTTER';
        //li2.APTS_Cat_L3__c = System.Label.APTS_Rutter_Product_Family;
        li2.Apttus_Config2__Quantity__c = 1;
        li2.Apttus_Config2__RollupPriceToBundle__c = TRUE;
        li2.Apttus_Config2__SellingFrequency__c = 'Monthly';
        li2.Apttus_Config2__SellingTerm__c = 1;        
        li2.Apttus_Config2__Taxable__c = FALSE;
        li2.Apttus_Config2__TaxInclusive__c = FALSE;
        li2.Apttus_Config2__Term__c = 1;
        li2.Apttus_Config2__TotalQuantity__c = 1;
        li2.Apttus_Config2__Uom__c = 'Each';        
        li2.CurrencyIsoCode = 'USD';
        li2.APTS_Product_Family__c = 'CLEAR';
        //li2.APTS_Cat_L2__c = System.Label.APTS_Clear_Product_Family;
        li2.APTS_Contract_Term__c = '2 Years';
        li2.APTS_Calculated_Min_YOY__c = 2;
        li2.Apttus_Config2__IncentiveCode__c = '13843012,13843012';
        li2.APTS_Bridge__c='3 Months';
        listOfLineItems.add(li2);
        
        Apttus_Config2__LineItem__c li3 = new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c=prodConf2.id , Apttus_Config2__ProductId__c=prod.id);
        li3.Apttus_Config2__AddedBy__c = 'User';
        li3.Apttus_Config2__AdjustedPrice__c = 50;
        li3.Apttus_Config2__AdjustmentAmount__c = 50;
        li3.Apttus_Config2__AdjustmentType__c = '% Discount';
        li3.Apttus_Config2__AllocateGroupAdjustment__c = TRUE;
        li3.Apttus_Config2__AllowableAction__c = 'Unrestricted';
        li3.Apttus_Config2__AllowManualAdjustment__c = TRUE;
        li3.Apttus_Config2__AllowProration__c = FALSE;
        li3.Apttus_Config2__AllowRemoval__c = TRUE;
        li3.Apttus_Config2__AutoRenew__c = FALSE;
        li3.Apttus_Config2__BaseExtendedCost__c = 0;
        li3.Apttus_Config2__BaseExtendedPrice__c = 100;
        li3.Apttus_Config2__BasePrice__c = 100;
        li3.Apttus_Config2__BasePriceMethod__c = 'Per Unit';
        li3.Apttus_Config2__BillingFrequency__c = 'Monthly';
        li3.Apttus_Config2__ChargeType__c = 'Subscription Fee';
        li3.Apttus_Config2__ConfigStatus__c = 'Complete';
        li3.Apttus_Config2__ConstraintCheckStatus__c = 'NA';
        li3.Apttus_Config2__Customizable__c = FALSE;
        li3.Apttus_Config2__DeltaPrice__c = 50;
        li3.Apttus_Config2__DeltaQuantity__c = 1;
        li3.Apttus_Config2__Description__c = 'Westlaw Flex Plan $100/500';
        li3.Apttus_Config2__ExtendedCost__c = 0;
        li3.Apttus_Config2__ExtendedPrice__c = 100;
        li3.Apttus_Config2__Frequency__c = 'Monthly';
        li3.Apttus_Config2__Guidance__c = 'Red';       
        li3.Apttus_Config2__IsPrimaryLine__c = TRUE;        
        li3.Apttus_Config2__ItemSequence__c = 1;
        li3.Apttus_Config2__LineNumber__c = 1;
        li3.Apttus_Config2__LineSequence__c = 1;
        li3.Apttus_Config2__LineStatus__c = 'New';
        li3.APTS_Yr_1_Renewal_Adjustment__c='1';
        li3.Apttus_Config2__LineType__c = 'Product/Service';
        li3.Apttus_Config2__ListPrice__c = 100;
        li3.Apttus_Config2__NetAdjustmentPercent__c = -50;
        li3.Apttus_Config2__NetPrice__c = 50;
        li3.Apttus_Config2__NetUnitPrice__c = 50;
        li3.Apttus_Config2__OptionSequence__c = 0;        
        li3.Apttus_Config2__PriceMethod__c = 'Per Unit';
        li3.Apttus_Config2__PriceType__c = 'Recurring';
        li3.Apttus_Config2__PriceUom__c = 'Attorneys';
        li3.Apttus_Config2__PricingStatus__c = 'Complete';       
        li3.APTS_Product_Family__c='RUTTER';
        //li3.APTS_Cat_L3__c = System.Label.APTS_Rutter_Product_Family;
        li3.Apttus_Config2__Quantity__c = 1;
        li3.Apttus_Config2__RollupPriceToBundle__c = TRUE;
        li3.Apttus_Config2__SellingFrequency__c = 'Monthly';
        li3.Apttus_Config2__SellingTerm__c = 1;        
        li3.Apttus_Config2__Taxable__c = FALSE;
        li3.Apttus_Config2__TaxInclusive__c = FALSE;
        li3.Apttus_Config2__Term__c = 1;
        li3.Apttus_Config2__TotalQuantity__c = 1;
        li3.Apttus_Config2__Uom__c = 'Each';        
        li3.CurrencyIsoCode = 'USD';
        li3.APTS_Product_Family__c = 'CLEAR';
       // li3.APTS_Cat_L2__c = System.Label.APTS_Clear_Product_Family;
        li3.APTS_Contract_Term__c = '3 Years';
        li3.APTS_Years_2_Plus_Adjustment__c = '2';
        li3.Apttus_Config2__IncentiveCode__c = '13843012,13843012';
        li3.APTS_Bridge__c='4 Months';  
        listOfLineItems.add(li3);
        
        Apttus_Config2__LineItem__c li4 = new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c=prodConf2.id , Apttus_Config2__ProductId__c=prod.id);
        li4.Apttus_Config2__AddedBy__c = 'User';
        li4.Apttus_Config2__AdjustedPrice__c = 50;
        li4.Apttus_Config2__AdjustmentAmount__c = 50;
        li4.Apttus_Config2__AdjustmentType__c = '% Discount';
        li4.Apttus_Config2__AllocateGroupAdjustment__c = TRUE;
        li4.Apttus_Config2__AllowableAction__c = 'Unrestricted';
        li4.Apttus_Config2__AllowManualAdjustment__c = TRUE;
        li4.Apttus_Config2__AllowProration__c = FALSE;
        li4.Apttus_Config2__AllowRemoval__c = TRUE;
        li4.Apttus_Config2__AutoRenew__c = FALSE;
        li4.Apttus_Config2__BaseExtendedCost__c = 0;
        li4.Apttus_Config2__BaseExtendedPrice__c = 100;
        li4.Apttus_Config2__BasePrice__c = 100;
        li4.Apttus_Config2__BasePriceMethod__c = 'Per Unit';
        li4.Apttus_Config2__BillingFrequency__c = 'Monthly';
        li4.Apttus_Config2__ChargeType__c = 'Subscription Fee';
        li4.Apttus_Config2__ConfigStatus__c = 'Complete';
        li4.Apttus_Config2__ConstraintCheckStatus__c = 'NA';
        li4.Apttus_Config2__Customizable__c = FALSE;
        li4.Apttus_Config2__DeltaPrice__c = 50;
        li4.Apttus_Config2__DeltaQuantity__c = 1;
        li4.Apttus_Config2__Description__c = 'Westlaw Flex Plan $100/500';
        li4.Apttus_Config2__ExtendedCost__c = 0;
        li4.Apttus_Config2__ExtendedPrice__c = 100;
        li4.Apttus_Config2__Frequency__c = 'Monthly';
        li4.Apttus_Config2__Guidance__c = 'Red';       
        li4.Apttus_Config2__IsPrimaryLine__c = TRUE;        
        li4.Apttus_Config2__ItemSequence__c = 1;
        li4.Apttus_Config2__LineNumber__c = 1;
        li4.Apttus_Config2__LineSequence__c = 1;
        li4.Apttus_Config2__LineStatus__c = 'New';
        li4.APTS_Yr_1_Renewal_Adjustment__c='1';
        li4.Apttus_Config2__LineType__c = 'Product/Service';
        li4.Apttus_Config2__ListPrice__c = 100;
        li4.Apttus_Config2__NetAdjustmentPercent__c = -50;
        li4.Apttus_Config2__NetPrice__c = 50;
        li4.Apttus_Config2__NetUnitPrice__c = 50;
        li4.Apttus_Config2__OptionSequence__c = 0;        
        li4.Apttus_Config2__PriceMethod__c = 'Per Unit';
        li4.Apttus_Config2__PriceType__c = 'Recurring';
        li4.Apttus_Config2__PriceUom__c = 'Attorneys';
        li4.Apttus_Config2__PricingStatus__c = 'Complete';       
        li4.APTS_Product_Family__c='RUTTER';
        //li4.APTS_Cat_L3__c = System.Label.APTS_Rutter_Product_Family;
        li4.Apttus_Config2__Quantity__c = 1;
        li4.Apttus_Config2__RollupPriceToBundle__c = TRUE;
        li4.Apttus_Config2__SellingFrequency__c = 'Monthly';
        li4.Apttus_Config2__SellingTerm__c = 1;        
        li4.Apttus_Config2__Taxable__c = FALSE;
        li4.Apttus_Config2__TaxInclusive__c = FALSE;
        li4.Apttus_Config2__Term__c = 1;
        li4.Apttus_Config2__TotalQuantity__c = 1;
        li4.Apttus_Config2__Uom__c = 'Each';        
        li4.CurrencyIsoCode = 'USD';
        li4.APTS_Product_Family__c = 'CLEAR';
        //li4.APTS_Cat_L2__c = System.Label.APTS_Clear_Product_Family;
        li4.APTS_Contract_Term__c = '4 Years';
        li4.APTS_Years_2_Plus_Adjustment__c = '2';
        li4.Apttus_Config2__IncentiveCode__c = '13843012,13843012';
        li4.APTS_Bridge__c='5 Months';     
        listOfLineItems.add(li4);
        Apttus_Config2__LineItem__c li5 = new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c=prodConf2.id , Apttus_Config2__ProductId__c=prod.id);
        li5.Apttus_Config2__AddedBy__c = 'User';
        li5.Apttus_Config2__AdjustedPrice__c = 50;
        li5.Apttus_Config2__AdjustmentAmount__c = 50;
        li5.Apttus_Config2__AdjustmentType__c = '% Discount';
        li5.Apttus_Config2__AllocateGroupAdjustment__c = TRUE;
        li5.Apttus_Config2__AllowableAction__c = 'Unrestricted';
        li5.Apttus_Config2__AllowManualAdjustment__c = TRUE;
        li5.Apttus_Config2__AllowProration__c = FALSE;
        li5.Apttus_Config2__AllowRemoval__c = TRUE;
        li5.Apttus_Config2__AutoRenew__c = FALSE;
        li5.Apttus_Config2__BaseExtendedCost__c = 0;
        li5.Apttus_Config2__BaseExtendedPrice__c = 100;
        li5.Apttus_Config2__BasePrice__c = 100;
        li5.Apttus_Config2__BasePriceMethod__c = 'Per Unit';
        li5.Apttus_Config2__BillingFrequency__c = 'Monthly';
        li5.Apttus_Config2__ChargeType__c = 'Subscription Fee';
        li5.Apttus_Config2__ConfigStatus__c = 'Complete';
        li5.Apttus_Config2__ConstraintCheckStatus__c = 'NA';
        li5.Apttus_Config2__Customizable__c = FALSE;
        li5.Apttus_Config2__DeltaPrice__c = 50;
        li5.Apttus_Config2__DeltaQuantity__c = 1;
        li5.Apttus_Config2__Description__c = 'Westlaw Flex Plan $100/500';
        li5.Apttus_Config2__ExtendedCost__c = 0;
        li5.Apttus_Config2__ExtendedPrice__c = 100;
        li5.Apttus_Config2__Frequency__c = 'Monthly';
        li5.Apttus_Config2__Guidance__c = 'Red';       
        li5.Apttus_Config2__IsPrimaryLine__c = TRUE;        
        li5.Apttus_Config2__ItemSequence__c = 1;
        li5.Apttus_Config2__LineNumber__c = 1;
        li5.Apttus_Config2__LineSequence__c = 1;
        li5.Apttus_Config2__LineStatus__c = 'New'; 
        li5.APTS_Yr_1_Renewal_Adjustment__c='1';
        li5.Apttus_Config2__LineType__c = 'Product/Service';
        li5.Apttus_Config2__ListPrice__c = 100;
        li5.Apttus_Config2__NetAdjustmentPercent__c = -50;
        li5.Apttus_Config2__NetPrice__c = 50;
        li5.Apttus_Config2__NetUnitPrice__c = 50;
        li5.Apttus_Config2__OptionSequence__c = 0;        
        li5.Apttus_Config2__PriceMethod__c = 'Per Unit';
        li5.Apttus_Config2__PriceType__c = 'Recurring';
        li5.Apttus_Config2__PriceUom__c = 'Attorneys';
        li5.Apttus_Config2__PricingStatus__c = 'Complete';       
        li5.APTS_Product_Family__c='RUTTER';
        //li5.APTS_Cat_L3__c = System.Label.APTS_Rutter_Product_Family;
        li5.Apttus_Config2__Quantity__c = 1;
        li5.Apttus_Config2__RollupPriceToBundle__c = TRUE;
        li5.Apttus_Config2__SellingFrequency__c = 'Monthly';
        li5.Apttus_Config2__SellingTerm__c = 1;        
        li5.Apttus_Config2__Taxable__c = FALSE;
        li5.Apttus_Config2__TaxInclusive__c = FALSE;
        li5.Apttus_Config2__Term__c = 1;
        li5.Apttus_Config2__TotalQuantity__c = 1;
        li5.Apttus_Config2__Uom__c = 'Each';        
        li5.CurrencyIsoCode = 'USD';
        li5.APTS_Product_Family__c = 'CLEAR';
        //li5.APTS_Cat_L2__c = System.Label.APTS_Print_Product_Family;
        li5.APTS_Contract_Term__c = '1 Year';
        li5.APTS_Years_2_Plus_Adjustment__c = '2';
        li5.Apttus_Config2__IncentiveCode__c = '13843012,13843012';
        li5.APTS_Bridge__c='2 Months';          
        listOfLineItems.add(li5);
               
        insert listOfLineItems;
        
        List<Apttus_Config2__ProductAttributeValue__c> prodattr =new List<Apttus_Config2__ProductAttributeValue__c>();
        
            Apttus_Config2__ProductAttributeValue__c pavObj; 
            for (Apttus_Config2__LineItem__c lineItem : ListOfLineItems ){
                pavObj = new Apttus_Config2__ProductAttributeValue__c(
                APTS_Product_Delivery__c = 'Online/Web',
                Apttus_Config2__LineItemId__c = li1.id
                );
         
                prodattr.add(pavObj); 
            }
        
           Apttus_Config2__ProductAttributeValue__c pavObj1; 
           for (Apttus_Config2__LineItem__c lineItem : listOfLineItems ){
                pavObj1 = new Apttus_Config2__ProductAttributeValue__c(
                APTS_Product_Delivery__c = 'Download',
                Apttus_Config2__LineItemId__c = li2.id
                );
         
               prodattr.add(pavObj1);
           }
           insert prodattr;
        li1.Apttus_Config2__Description__c = 'Test1';
        
        li2.Apttus_Config2__Description__c = 'Test2';
        update listOfLineItems;
        Test.stopTest();        
    }
        
    
    static testMethod void shortTermTrial() {
        List<KeyValueListStore__c> keyvaluestoreList = new List<KeyValueListStore__c>();
        KeyValueListStore__c keyvaluestore=new  KeyValueListStore__c();
        keyvaluestore.Name='ANZUsersProfileId';
        keyvaluestore.TextValue__c=System.Label.APTS_OC_Test_Id;
        keyvaluestoreList.add(keyvaluestore); 
        KeyValueListStore__c keyval = new KeyValueListStore__c();
        keyval.Name='ReasonWithCompetitor';
        keyval.TextValue__c='Price';
        keyvaluestoreList.add(keyval);
        insert keyvaluestoreList;
        
        WebServiceSettings__c oWebServiceSettings = new WebServiceSettings__c();
        oWebServiceSettings.Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable'; 
        oWebServiceSettings.Name = 'PaymentCreditIncrease'; 
        oWebServiceSettings.Timeout__c = 120; 
        oWebServiceSettings.Endpoint__c = 'https://dev.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease'; 
        oWebServiceSettings.Active__c = true;
        insert oWebServiceSettings;
        List<WebServiceSettings__c> webserviceList = new List<WebServiceSettings__c>{new WebServiceSettings__c(Name='EnterpriseWSDL',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
           new WebServiceSettings__c(Name='StatusPostbackLocation',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
           new WebServiceSettings__c(Name='PostbackLocation',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
           new WebServiceSettings__c(Name='Payment AutoCharge',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available')};
        insert webserviceList;
        //Inserting recordLists
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
        
        List<APTS_Segment_Threshold__c> segthrList= new List<APTS_Segment_Threshold__c>();
        //Add Segment threshold
        APTS_Segment_Threshold__c seg1 = new APTS_Segment_Threshold__c();
        seg1.APTS_Approval_Required__c=True;
        seg1.APTS_Segment__c='Small Law';
        seg1.APTS_Customer_Category__c='5';
        seg1.APTS_Term_in_years__c=Integer.ValueOf('2');
        seg1.APTS_Minimum_OY_Increase__c=Integer.ValueOf('15');
        seg1.APTS_Minimum_Incremental_Growth__c=Integer.ValueOf('15');
        seg1.APTS_Product_Family__c = 'CLEAR';
        seg1.APTS_Promo_Codes__c = '13843014';
        seg1.APTS_Promo_Minimum_OY_Increase__c = 17;        
        segthrList.add(seg1);
        
        APTS_Segment_Threshold__c seg2 = new APTS_Segment_Threshold__c();
        seg2.APTS_Approval_Required__c=True;
        seg2.APTS_Segment__c='Corporate';
        seg2.APTS_Customer_Category__c='5';
        seg2.APTS_Term_in_years__c=Integer.ValueOf('2');
        seg2.APTS_Minimum_OY_Increase__c=Integer.ValueOf('15');
        seg2.APTS_Minimum_Incremental_Growth__c=Integer.ValueOf('15');
        seg2.APTS_Product_Family__c = 'CLEAR';
        seg2.APTS_Promo_Codes__c = '13843013';
        seg2.APTS_Promo_Minimum_OY_Increase__c = 16;        
        segthrList.add(seg2);
        system.assertEquals(seg2.APTS_Promo_Codes__c,'13843013');
                
        APTS_Segment_Threshold__c seg3 = new APTS_Segment_Threshold__c();
        seg3.APTS_Approval_Required__c=True;
        seg3.APTS_Segment__c='Corporate';
        seg3.APTS_Customer_Category__c='5';
        seg3.APTS_Term_in_years__c=Integer.ValueOf('2');
        seg3.APTS_Minimum_OY_Increase__c=Integer.ValueOf('15');
        seg3.APTS_Minimum_Incremental_Growth__c=Integer.ValueOf('15');
        segthrList.add(seg3);       
      
        APTS_Segment_Threshold__c seg4 = new APTS_Segment_Threshold__c();
        seg4.APTS_Approval_Required__c=True;
        seg4.APTS_Segment__c='Government';
        seg4.APTS_Customer_Category__c='5';
        seg4.APTS_Term_in_years__c=Integer.ValueOf('2');
        seg4.APTS_Minimum_OY_Increase__c=Integer.ValueOf('15');
        seg4.APTS_Minimum_Incremental_Growth__c=Integer.ValueOf('15');
        seg4.APTS_Product_Family__c = 'CLEAR';
        seg4.APTS_Promo_Codes__c = '13843012';
        seg4.APTS_Promo_Minimum_OY_Increase__c = 15;        
        segthrList.add(seg4);
        
        insert segthrList;
        
        Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
        Account a = new Account(RecordTypeId=accRecordTypeId,name='test-sg',sales_org__c='ABEP',customer_group__c='Academic',customer_type__c='Organization',customer_class_c__c='Academic Lecturer');
        a.APTS_Customer_Category__c = '5';
        a.Is_GLI__c = True;
        insert a;        
        
        Schema.DescribeFieldResult fieldResultMarket = Apttus_Config2__ProductConfiguration__c.APTS_AccountMirror_Picklist__c.getDescribe();
        String valueMarket = fieldResultMarket.getPicklistValues().get(0).getValue();
        
        //Inserting SourceSystemDetail
        List<Source_System_Detail__c> listOfSSD = new List<Source_System_Detail__c>();
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();
        
        Source_System_Detail__c accountSSD2= new Source_System_Detail__c();
        accountSSD2.RecordtypeId=ssdRecorType;
        accountSSD2.Name='ABC';
        accountSSD2.Source_System_Name__c='ABC';
        accountSSD2.Account_Name__c=a.ID;
        accountSSD2.APTS_Customer_Category__c='1';
        accountSSD2.LCRM_Customer_Group__c='Academic';
        accountSSD2.LCRM_Frozen_Market_Segment__c = valueMarket;
        accountSSD2.Account_Inactive__c=false;
        accountSSD2.LCRM_Sales_Org__c='WEST';
        accountSSD2.APTS_Has_Online_Assets__c=true;        
        listOfSSD.add(accountSSD2);
        insert listOfSSD;
        Profile p = [SELECT Id FROM profile WHERE name='System Administrator']; 
        User u1 = new User(alias = 'User_3', email='user@mydomain.com', 
        emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
        localesidkey='en_US', profileid = p.Id, employeenumber='0144020',
        timezonesidkey='America/Los_Angeles', username='user_3@mydomain.com',Sub_Bu__c='US');        
        insert u1;
        System.runAs(u1){
        Date todaysDate = system.today();
        Id oppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Pipeline Opportunity').getRecordTypeId();
        Opportunity o = new Opportunity(RecordTypeId=oppRecordTypeId,  Name='tst-opp', stagename='25%',closedate=todaysDate,forecastcategoryname='pipeline',accountId=a.id);
        insert o;
        
        List<Apttus_Proposal__Proposal__c > listofProposals=new List<Apttus_Proposal__Proposal__c >();
        Id devRecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Proposal').getRecordTypeId();
        Apttus_Proposal__Proposal__c p2 = new Apttus_Proposal__Proposal__c(RecordTypeId=devRecordTypeId, CurrencyIsoCode = 'USD', Apttus_Proposal__Account__c=a.id,
            Apttus_Proposal__Proposal_Name__c='Corporate Proposal for approval',  Apttus_Proposal__Opportunity__c=o.id, 
            Apttus_Proposal__Approval_Stage__c='Draft', Apttus_Proposal__Proposal_Category__c='Quote', Apttus_Proposal__ReadyToGenerate__c = true, 
            Apttus_Proposal__ReadyToPresent__c= true,APTS_SSD_Sold_To__c=accountSSD2.Id,APTS_SSD_ship_to__c=accountSSD2.Id,
            APTS_SSD_bill_to__c=accountSSD2.Id);
        p2.APTS_Proposal_Business_Unit__c = 'SCS';
        p2.APTS_Approval_Segment__c = 'Medium Law';
        listofProposals.add(p2);
        
        Apttus_Proposal__Proposal__c p4 = new Apttus_Proposal__Proposal__c(RecordTypeId=devRecordTypeId, CurrencyIsoCode = 'USD', Apttus_Proposal__Account__c=a.id,
            Apttus_Proposal__Proposal_Name__c='Corporate Proposal for approval',  Apttus_Proposal__Opportunity__c=o.id, 
            Apttus_Proposal__Approval_Stage__c='Draft', Apttus_Proposal__Proposal_Category__c='Quote', Apttus_Proposal__ReadyToGenerate__c = true, 
            Apttus_Proposal__ReadyToPresent__c= true,APTS_SSD_Sold_To__c=accountSSD2.Id,APTS_SSD_ship_to__c=accountSSD2.Id,
            APTS_SSD_bill_to__c=accountSSD2.Id);
        p4.APTS_Proposal_Business_Unit__c = 'SCS';
        p4.APTS_Approval_Segment__c = 'Corporate SMB';
        listofProposals.add(p4);
        
        Apttus_Proposal__Proposal__c p3 = new Apttus_Proposal__Proposal__c(RecordTypeId=devRecordTypeId, CurrencyIsoCode = 'USD', Apttus_Proposal__Account__c=a.id,
            Apttus_Proposal__Proposal_Name__c='Corporate Proposal for approval',  Apttus_Proposal__Opportunity__c=o.id, 
            Apttus_Proposal__Approval_Stage__c='Draft', Apttus_Proposal__Proposal_Category__c='Quote', Apttus_Proposal__ReadyToGenerate__c = true, 
            Apttus_Proposal__ReadyToPresent__c= true,APTS_SSD_Sold_To__c=accountSSD2.Id,APTS_SSD_ship_to__c=accountSSD2.Id,
            APTS_SSD_bill_to__c=accountSSD2.Id);
        p3.APTS_Proposal_Business_Unit__c = 'SCS';
        p3.APTS_Approval_Segment__c = 'Government';
        listofProposals.add(p3);
        
        Apttus_Proposal__Proposal__c p6 = new Apttus_Proposal__Proposal__c(RecordTypeId=devRecordTypeId, CurrencyIsoCode = 'USD', Apttus_Proposal__Account__c=a.id,
            Apttus_Proposal__Proposal_Name__c='Corporate Proposal for approval',  Apttus_Proposal__Opportunity__c=o.id, 
            Apttus_Proposal__Approval_Stage__c='Draft', Apttus_Proposal__Proposal_Category__c='Quote', Apttus_Proposal__ReadyToGenerate__c = true, 
            Apttus_Proposal__ReadyToPresent__c= true,APTS_SSD_Sold_To__c=accountSSD2.Id,APTS_SSD_ship_to__c=accountSSD2.Id,
            APTS_SSD_bill_to__c=accountSSD2.Id);
        p6.APTS_Proposal_Business_Unit__c = 'SCS';
        p6.APTS_Approval_Segment__c = 'Canada';
        listofProposals.add(p6);
        
        Apttus_Proposal__Proposal__c p5 = new Apttus_Proposal__Proposal__c(RecordTypeId=devRecordTypeId, CurrencyIsoCode = 'USD', Apttus_Proposal__Account__c=a.id,
            Apttus_Proposal__Proposal_Name__c='Corporate Proposal for approval',  Apttus_Proposal__Opportunity__c=o.id, 
            Apttus_Proposal__Approval_Stage__c='Draft', Apttus_Proposal__Proposal_Category__c='Quote', Apttus_Proposal__ReadyToGenerate__c = true, 
            Apttus_Proposal__ReadyToPresent__c= true,APTS_SSD_Sold_To__c=accountSSD2.Id,APTS_SSD_ship_to__c=accountSSD2.Id,
            APTS_SSD_bill_to__c=accountSSD2.Id);
        p5.APTS_Proposal_Business_Unit__c = 'SCS';
        p5.APTS_Approval_Segment__c = 'Large Law';
        listofProposals.add(p5);
        insert listofProposals;
        
        List<Apttus_Config2__ProductConfiguration__c> listofProdconfig = new List<Apttus_Config2__ProductConfiguration__c >();       
        Apttus_Config2__ProductConfiguration__c prodConf2 = new Apttus_Config2__ProductConfiguration__c(Name='prod-conf2', CurrencyIsoCode = 'USD', Apttus_QPConfig__Proposald__c=p2.id, APTS_SSD_ship_to__c=accountSSD2.Id,APTS_SSD_bill_to__c=accountSSD2.Id);
        listofProdconfig.add(prodConf2);
        Apttus_Config2__ProductConfiguration__c prodConf3 = new Apttus_Config2__ProductConfiguration__c(Name='prod-conf2', CurrencyIsoCode = 'USD', Apttus_QPConfig__Proposald__c=p3.id, APTS_SSD_ship_to__c=accountSSD2.Id,APTS_SSD_bill_to__c=accountSSD2.Id);
        listofProdconfig.add(prodConf3);
        Apttus_Config2__ProductConfiguration__c prodConf4 = new Apttus_Config2__ProductConfiguration__c(Name='prod-conf4', CurrencyIsoCode = 'USD', Apttus_QPConfig__Proposald__c=p4.id, APTS_SSD_ship_to__c=accountSSD2.Id,APTS_SSD_bill_to__c=accountSSD2.Id);
        listofProdconfig.add(prodConf4);
        Apttus_Config2__ProductConfiguration__c prodConf5 = new Apttus_Config2__ProductConfiguration__c(Name='prod-conf4', CurrencyIsoCode = 'USD', Apttus_QPConfig__Proposald__c=p5.id, APTS_SSD_ship_to__c=accountSSD2.Id,APTS_SSD_bill_to__c=accountSSD2.Id);
        listofProdconfig.add(prodConf5);
        Apttus_Config2__ProductConfiguration__c prodConf6 = new Apttus_Config2__ProductConfiguration__c(Name='prod-conf4', CurrencyIsoCode = 'USD', Apttus_QPConfig__Proposald__c=p6.id, APTS_SSD_ship_to__c=accountSSD2.Id,APTS_SSD_bill_to__c=accountSSD2.Id);
        listofProdconfig.add(prodConf6);
        insert listofProdconfig;
        
        Product2 prod = new Product2(name='prod1', Media_High_Level__c='Online', CurrencyIsoCode = 'USD',APTS_CAT_L2__c=System.Label.APTS_Clear_Product_Family,APTS_CAT_L3__c='L3_L030_FP');
        prod.APTS_Approval_Always_Required__c = true;
        insert prod;
        
        Product2 prod1 = new Product2(name='prod1', Media_High_Level__c='Online', CurrencyIsoCode = 'USD', Family='PRINT LEGAL SOLUTIONS', APTS_Cat_L2__c = System.Label.APTS_Print_Product_Family,APTS_CAT_L3__c='L3_L030_FP');
        prod1.APTS_Approval_Always_Required__c = true;
        insert prod1;
                
        Apttus_Config2__ConfigSystemProperties__c configSetting=new Apttus_Config2__ConfigSystemProperties__c(Name='System Properties',Apttus_Config2__DisableConstraintRules__c=true);
        insert configSetting;

        test.startTest();
        List<Apttus_Config2__LineItem__c> listOfLineItems = new List<Apttus_Config2__LineItem__c>();        
        
        Apttus_Config2__LineItem__c li1 = new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c=prodConf2.id , Apttus_Config2__ProductId__c=prod.id);
        li1.Apttus_Config2__AddedBy__c = 'User';
        li1.Apttus_Config2__AdjustedPrice__c = 50;
        li1.Apttus_Config2__AdjustmentAmount__c = 50;
        li1.Apttus_Config2__AdjustmentType__c = '% Discount';
        li1.Apttus_Config2__AllocateGroupAdjustment__c = TRUE;
        li1.Apttus_Config2__AllowableAction__c = 'Unrestricted';
        li1.Apttus_Config2__AllowManualAdjustment__c = TRUE;
        li1.Apttus_Config2__AllowProration__c = FALSE;
        li1.Apttus_Config2__AllowRemoval__c = TRUE;
        li1.Apttus_Config2__AutoRenew__c = FALSE;
        li1.Apttus_Config2__BaseExtendedCost__c = 0;
        li1.Apttus_Config2__BaseExtendedPrice__c = 100;
        li1.Apttus_Config2__BasePrice__c = 100;
        li1.Apttus_Config2__BasePriceMethod__c = 'Per Unit';
        li1.Apttus_Config2__BillingFrequency__c = 'Monthly';
        li1.Apttus_Config2__ChargeType__c = 'Subscription Fee';
        li1.Apttus_Config2__ConfigStatus__c = 'Complete';
        li1.Apttus_Config2__ConstraintCheckStatus__c = 'NA';
        li1.Apttus_Config2__Customizable__c = FALSE;
        li1.Apttus_Config2__DeltaPrice__c = 50;
        li1.Apttus_Config2__DeltaQuantity__c = 1;
        li1.Apttus_Config2__Description__c = 'Westlaw Flex Plan $100/500';
        li1.Apttus_Config2__ExtendedCost__c = 0;
        li1.Apttus_Config2__ExtendedPrice__c = 100;
        li1.Apttus_Config2__Frequency__c = 'Monthly';
        li1.Apttus_Config2__Guidance__c = 'Red';       
        li1.Apttus_Config2__IsPrimaryLine__c = TRUE;        
        li1.Apttus_Config2__ItemSequence__c = 1;
        li1.Apttus_Config2__LineNumber__c = 1;
        li1.Apttus_Config2__LineSequence__c = 1;
        li1.Apttus_Config2__LineStatus__c = 'New';
        li1.APTS_Yr_1_Renewal_Adjustment__c='1';
        li1.Apttus_Config2__LineType__c = 'Product/Service';
        li1.Apttus_Config2__ListPrice__c = 100;
        li1.Apttus_Config2__NetAdjustmentPercent__c = -50;
        li1.Apttus_Config2__NetPrice__c = 50;
        li1.Apttus_Config2__NetUnitPrice__c = 50;
        li1.Apttus_Config2__OptionSequence__c = 0;        
        li1.Apttus_Config2__PriceMethod__c = 'Per Unit';
        li1.Apttus_Config2__PriceType__c = 'Recurring';
        li1.Apttus_Config2__PriceUom__c = 'Attorneys';
        li1.Apttus_Config2__PricingStatus__c = 'Complete';       
        li1.APTS_Product_Family__c='RUTTER';
       // li1.APTS_Cat_L3__c = System.Label.APTS_Rutter_Product_Family;
        li1.Apttus_Config2__Quantity__c = 1;
        li1.Apttus_Config2__RollupPriceToBundle__c = TRUE;
        li1.Apttus_Config2__SellingFrequency__c = 'Monthly';
        li1.Apttus_Config2__SellingTerm__c = 1;        
        li1.Apttus_Config2__Taxable__c = FALSE;
        li1.Apttus_Config2__TaxInclusive__c = FALSE;
        li1.Apttus_Config2__Term__c = 1;
        li1.Apttus_Config2__TotalQuantity__c = 1;
        li1.Apttus_Config2__Uom__c = 'Each';        
        li1.CurrencyIsoCode = 'CAD';
        li1.APTS_Product_Family__c = 'CLEAR';
        //li1.APTS_Cat_L2__c = System.Label.APTS_Clear_Product_Family;
        li1.APTS_Contract_Term__c = '2 Years';
        li1.APTS_Years_2_Plus_Adjustment__c = '5';
        li1.Apttus_Config2__IncentiveCode__c = '13843012,13843012';
        li1.APTS_Bridge__c='1 Month';             
        li1.APTS_Contract_Term__c = 'Short Term Trial';     
        listOfLineItems.add(li1);
        
        
        Apttus_Config2__LineItem__c li2 = new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c=prodConf3.id , Apttus_Config2__ProductId__c=prod.id);
        li2.Apttus_Config2__AddedBy__c = 'User';
        li2.Apttus_Config2__AdjustedPrice__c = 50;
        li2.Apttus_Config2__AdjustmentAmount__c = 50;
        li2.Apttus_Config2__AdjustmentType__c = '% Discount';
        li2.Apttus_Config2__AllocateGroupAdjustment__c = TRUE;
        li2.Apttus_Config2__AllowableAction__c = 'Unrestricted';
        li2.Apttus_Config2__AllowManualAdjustment__c = TRUE;
        li2.Apttus_Config2__AllowProration__c = FALSE;
        li2.Apttus_Config2__AllowRemoval__c = TRUE;
        li2.Apttus_Config2__AutoRenew__c = FALSE;
        li2.Apttus_Config2__BaseExtendedCost__c = 0;
        li2.Apttus_Config2__BaseExtendedPrice__c = 100;
        li2.Apttus_Config2__BasePrice__c = 100;
        li2.Apttus_Config2__BasePriceMethod__c = 'Per Unit';
        li2.Apttus_Config2__BillingFrequency__c = 'Monthly';
        li2.Apttus_Config2__ChargeType__c = 'Subscription Fee';
        li2.Apttus_Config2__ConfigStatus__c = 'Complete';
        li2.Apttus_Config2__ConstraintCheckStatus__c = 'NA';
        li2.Apttus_Config2__Customizable__c = FALSE;
        li2.Apttus_Config2__DeltaPrice__c = 50;
        li2.Apttus_Config2__DeltaQuantity__c = 1;
        li2.Apttus_Config2__Description__c = 'Westlaw Flex Plan $100/500';
        li2.Apttus_Config2__ExtendedCost__c = 0;
        li2.Apttus_Config2__ExtendedPrice__c = 100;
        li2.Apttus_Config2__Frequency__c = 'Monthly';
        li2.Apttus_Config2__Guidance__c = 'Red';       
        li2.Apttus_Config2__IsPrimaryLine__c = TRUE;        
        li2.Apttus_Config2__ItemSequence__c = 1;
        li2.Apttus_Config2__LineNumber__c = 1;
        li2.Apttus_Config2__LineSequence__c = 1;
        li2.Apttus_Config2__LineStatus__c = 'New';
        li2.APTS_Yr_1_Renewal_Adjustment__c='1';
        li2.Apttus_Config2__LineType__c = 'Product/Service';
        li2.Apttus_Config2__ListPrice__c = 100;
        li2.Apttus_Config2__NetAdjustmentPercent__c = -50;
        li2.Apttus_Config2__NetPrice__c = 50;
        li2.Apttus_Config2__NetUnitPrice__c = 50;
        li2.Apttus_Config2__OptionSequence__c = 0;        
        li2.Apttus_Config2__PriceMethod__c = 'Per Unit';
        li2.Apttus_Config2__PriceType__c = 'Recurring';
        li2.Apttus_Config2__PriceUom__c = 'Attorneys';
        li2.Apttus_Config2__PricingStatus__c = 'Complete';       
        li2.APTS_Product_Family__c='RUTTER';
        //li2.APTS_Cat_L3__c = System.Label.APTS_Rutter_Product_Family;
        li2.Apttus_Config2__Quantity__c = 1;
        li2.Apttus_Config2__RollupPriceToBundle__c = TRUE;
        li2.Apttus_Config2__SellingFrequency__c = 'Monthly';
        li2.Apttus_Config2__SellingTerm__c = 1;        
        li2.Apttus_Config2__Taxable__c = FALSE;
        li2.Apttus_Config2__TaxInclusive__c = FALSE;
        li2.Apttus_Config2__Term__c = 1;
        li2.Apttus_Config2__TotalQuantity__c = 1;
        li2.Apttus_Config2__Uom__c = 'Each';        
        li2.CurrencyIsoCode = 'CAD';
        li2.APTS_Product_Family__c = 'CLEAR';
        //li2.APTS_Cat_L2__c = System.Label.APTS_Clear_Product_Family;
        li2.APTS_Contract_Term__c = '2 Years';
        li2.APTS_Years_2_Plus_Adjustment__c = '5';
        li2.Apttus_Config2__IncentiveCode__c = '13843012,13843012';
        li2.APTS_Bridge__c='1 Month';             
        li2.APTS_Contract_Term__c = 'Short Term Trial';     
        listOfLineItems.add(li2);
        
        Apttus_Config2__LineItem__c li3 = new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c=prodConf4.id , Apttus_Config2__ProductId__c=prod.id);
        li3.Apttus_Config2__AddedBy__c = 'User';
        li3.Apttus_Config2__AdjustedPrice__c = 50;
        li3.Apttus_Config2__AdjustmentAmount__c = 50;
        li3.Apttus_Config2__AdjustmentType__c = '% Discount';
        li3.Apttus_Config2__AllocateGroupAdjustment__c = TRUE;
        li3.Apttus_Config2__AllowableAction__c = 'Unrestricted';
        li3.Apttus_Config2__AllowManualAdjustment__c = TRUE;
        li3.Apttus_Config2__AllowProration__c = FALSE;
        li3.Apttus_Config2__AllowRemoval__c = TRUE;
        li3.Apttus_Config2__AutoRenew__c = FALSE;
        li3.Apttus_Config2__BaseExtendedCost__c = 0;
        li3.Apttus_Config2__BaseExtendedPrice__c = 100;
        li3.Apttus_Config2__BasePrice__c = 100;
        li3.Apttus_Config2__BasePriceMethod__c = 'Per Unit';
        li3.Apttus_Config2__BillingFrequency__c = 'Monthly';
        li3.Apttus_Config2__ChargeType__c = 'Subscription Fee';
        li3.Apttus_Config2__ConfigStatus__c = 'Complete';
        li3.Apttus_Config2__ConstraintCheckStatus__c = 'NA';
        li3.Apttus_Config2__Customizable__c = FALSE;
        li3.Apttus_Config2__DeltaPrice__c = 50;
        li3.Apttus_Config2__DeltaQuantity__c = 1;
        li3.Apttus_Config2__Description__c = 'Westlaw Flex Plan $100/500';
        li3.Apttus_Config2__ExtendedCost__c = 0;
        li3.Apttus_Config2__ExtendedPrice__c = 100;
        li3.Apttus_Config2__Frequency__c = 'Monthly';
        li3.Apttus_Config2__Guidance__c = 'Red';       
        li3.Apttus_Config2__IsPrimaryLine__c = TRUE;        
        li3.Apttus_Config2__ItemSequence__c = 1;
        li3.Apttus_Config2__LineNumber__c = 1;
        li3.Apttus_Config2__LineSequence__c = 1;
        li3.Apttus_Config2__LineStatus__c = 'New';
        li3.APTS_Yr_1_Renewal_Adjustment__c='1';
        li3.Apttus_Config2__LineType__c = 'Product/Service';
        li3.Apttus_Config2__ListPrice__c = 100;
        li3.Apttus_Config2__NetAdjustmentPercent__c = -50;
        li3.Apttus_Config2__NetPrice__c = 50;
        li3.Apttus_Config2__NetUnitPrice__c = 50;
        li3.Apttus_Config2__OptionSequence__c = 0;        
        li3.Apttus_Config2__PriceMethod__c = 'Per Unit';
        li3.Apttus_Config2__PriceType__c = 'Recurring';
        li3.Apttus_Config2__PriceUom__c = 'Attorneys';
        li3.Apttus_Config2__PricingStatus__c = 'Complete';       
        li3.APTS_Product_Family__c='RUTTER';
        //li3.APTS_Cat_L3__c = System.Label.APTS_Rutter_Product_Family;
        li3.Apttus_Config2__Quantity__c = 1;
        li3.Apttus_Config2__RollupPriceToBundle__c = TRUE;
        li3.Apttus_Config2__SellingFrequency__c = 'Monthly';
        li3.Apttus_Config2__SellingTerm__c = 1;        
        li3.Apttus_Config2__Taxable__c = FALSE;
        li3.Apttus_Config2__TaxInclusive__c = FALSE;
        li3.Apttus_Config2__Term__c = 1;
        li3.Apttus_Config2__TotalQuantity__c = 1;
        li3.Apttus_Config2__Uom__c = 'Each';        
        li3.CurrencyIsoCode = 'CAD';
        li3.APTS_Product_Family__c = 'CLEAR';
       // li3.APTS_Cat_L2__c = System.Label.APTS_Clear_Product_Family;
        li3.APTS_Contract_Term__c = '2 Years';
        li3.APTS_Years_2_Plus_Adjustment__c = '5';
        li3.Apttus_Config2__IncentiveCode__c = '13843012,13843012';
        li3.APTS_Bridge__c='1 Month';             
        li3.APTS_Contract_Term__c = 'Short Term Trial';     
        listOfLineItems.add(li3);
        
        Apttus_Config2__LineItem__c li4 = new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c=prodConf5.id , Apttus_Config2__ProductId__c=prod.id);
        li4.Apttus_Config2__AddedBy__c = 'User';
        li4.Apttus_Config2__AdjustedPrice__c = 50;
        li4.Apttus_Config2__AdjustmentAmount__c = 50;
        li4.Apttus_Config2__AdjustmentType__c = '% Discount';
        li4.Apttus_Config2__AllocateGroupAdjustment__c = TRUE;
        li4.Apttus_Config2__AllowableAction__c = 'Unrestricted';
        li4.Apttus_Config2__AllowManualAdjustment__c = TRUE;
        li4.Apttus_Config2__AllowProration__c = FALSE;
        li4.Apttus_Config2__AllowRemoval__c = TRUE;
        li4.Apttus_Config2__AutoRenew__c = FALSE;
        li4.Apttus_Config2__BaseExtendedCost__c = 0;
        li4.Apttus_Config2__BaseExtendedPrice__c = 100;
        li4.Apttus_Config2__BasePrice__c = 100;
        li4.Apttus_Config2__BasePriceMethod__c = 'Per Unit';
        li4.Apttus_Config2__BillingFrequency__c = 'Monthly';
        li4.Apttus_Config2__ChargeType__c = 'Subscription Fee';
        li4.Apttus_Config2__ConfigStatus__c = 'Complete';
        li4.Apttus_Config2__ConstraintCheckStatus__c = 'NA';
        li4.Apttus_Config2__Customizable__c = FALSE;
        li4.Apttus_Config2__DeltaPrice__c = 50;
        li4.Apttus_Config2__DeltaQuantity__c = 1;
        li4.Apttus_Config2__Description__c = 'Westlaw Flex Plan $100/500';
        li4.Apttus_Config2__ExtendedCost__c = 0;
        li4.Apttus_Config2__ExtendedPrice__c = 100;
        li4.Apttus_Config2__Frequency__c = 'Monthly';
        li4.Apttus_Config2__Guidance__c = 'Red';       
        li4.Apttus_Config2__IsPrimaryLine__c = TRUE;        
        li4.Apttus_Config2__ItemSequence__c = 1;
        li4.Apttus_Config2__LineNumber__c = 1;
        li4.Apttus_Config2__LineSequence__c = 1;
        li4.Apttus_Config2__LineStatus__c = 'New';
        li4.APTS_Yr_1_Renewal_Adjustment__c='1';
        li4.Apttus_Config2__LineType__c = 'Product/Service';
        li4.Apttus_Config2__ListPrice__c = 100;
        li4.Apttus_Config2__NetAdjustmentPercent__c = -50;
        li4.Apttus_Config2__NetPrice__c = 50;
        li4.Apttus_Config2__NetUnitPrice__c = 50;
        li4.Apttus_Config2__OptionSequence__c = 0;        
        li4.Apttus_Config2__PriceMethod__c = 'Per Unit';
        li4.Apttus_Config2__PriceType__c = 'Recurring';
        li4.Apttus_Config2__PriceUom__c = 'Attorneys';
        li4.Apttus_Config2__PricingStatus__c = 'Complete';       
        li4.APTS_Product_Family__c='RUTTER';
        //li6.APTS_Cat_L3__c = System.Label.APTS_Rutter_Product_Family;
        li4.Apttus_Config2__Quantity__c = 1;
        li4.Apttus_Config2__RollupPriceToBundle__c = TRUE;
        li4.Apttus_Config2__SellingFrequency__c = 'Monthly';
        li4.Apttus_Config2__SellingTerm__c = 1;        
        li4.Apttus_Config2__Taxable__c = FALSE;
        li4.Apttus_Config2__TaxInclusive__c = FALSE;
        li4.Apttus_Config2__Term__c = 1;
        li4.Apttus_Config2__TotalQuantity__c = 1;
        li4.Apttus_Config2__Uom__c = 'Each';        
        li4.CurrencyIsoCode = 'CAD';
        li4.APTS_Product_Family__c = 'CLEAR';
        //li4.APTS_Cat_L2__c = System.Label.APTS_Clear_Product_Family;
        li4.APTS_Contract_Term__c = '2 Years';
        li4.APTS_Years_2_Plus_Adjustment__c = '5';
        li4.Apttus_Config2__IncentiveCode__c = '13843012,13843012';
        li4.APTS_Bridge__c='1 Month';             
        li4.APTS_Contract_Term__c = 'Short Term Trial';     
        listOfLineItems.add(li4);
        //insert listOfLineItems;
        
        Apttus_Config2__LineItem__c li5 = new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c=prodConf6.id , Apttus_Config2__ProductId__c=prod1.id);
        li5.Apttus_Config2__AddedBy__c = 'User';
        li5.Apttus_Config2__AdjustedPrice__c = 50;
        li5.Apttus_Config2__AdjustmentAmount__c = 50;
        li5.Apttus_Config2__AdjustmentType__c = '% Discount';
        li5.Apttus_Config2__AllocateGroupAdjustment__c = TRUE;
        li5.Apttus_Config2__AllowableAction__c = 'Unrestricted';
        li5.Apttus_Config2__AllowManualAdjustment__c = TRUE;
        li5.Apttus_Config2__AllowProration__c = FALSE;
        li5.Apttus_Config2__AllowRemoval__c = TRUE;
        li5.Apttus_Config2__AutoRenew__c = FALSE;
        li5.Apttus_Config2__BaseExtendedCost__c = 0;
        li5.Apttus_Config2__BaseExtendedPrice__c = 100;
        li5.Apttus_Config2__BasePrice__c = 100;
        li5.Apttus_Config2__BasePriceMethod__c = 'Per Unit';
        li5.Apttus_Config2__BillingFrequency__c = 'Monthly';
        li5.Apttus_Config2__ChargeType__c = 'Subscription Fee';
        li5.Apttus_Config2__ConfigStatus__c = 'Complete';
        li5.Apttus_Config2__ConstraintCheckStatus__c = 'NA';
        li5.Apttus_Config2__Customizable__c = FALSE;
        li5.Apttus_Config2__DeltaPrice__c = 50;
        li5.Apttus_Config2__DeltaQuantity__c = 1;
        li5.Apttus_Config2__Description__c = 'Westlaw Flex Plan $100/500';
        li5.Apttus_Config2__ExtendedCost__c = 0;
        li5.Apttus_Config2__ExtendedPrice__c = 100;
        li5.Apttus_Config2__Frequency__c = 'Monthly';
        li5.Apttus_Config2__Guidance__c = 'Red';       
        li5.Apttus_Config2__IsPrimaryLine__c = TRUE;        
        li5.Apttus_Config2__ItemSequence__c = 1;
        li5.Apttus_Config2__LineNumber__c = 1;
        li5.Apttus_Config2__LineSequence__c = 1;
        li5.Apttus_Config2__LineStatus__c = 'New';
        li5.APTS_Yr_1_Renewal_Adjustment__c='1';
        li5.Apttus_Config2__LineType__c = 'Product/Service';
        li5.Apttus_Config2__ListPrice__c = 100;
        li5.Apttus_Config2__NetAdjustmentPercent__c = -50;
        li5.Apttus_Config2__NetPrice__c = 50;
        li5.Apttus_Config2__NetUnitPrice__c = 50;
        li5.Apttus_Config2__OptionSequence__c = 0;        
        li5.Apttus_Config2__PriceMethod__c = 'Per Unit';
        li5.Apttus_Config2__PriceType__c = 'Recurring';
        li5.Apttus_Config2__PriceUom__c = 'Attorneys';
        li5.Apttus_Config2__PricingStatus__c = 'Complete';       
        li5.APTS_Product_Family__c='RUTTER';
        //li5.APTS_Cat_L3__c = System.Label.APTS_Rutter_Product_Family;
        li5.Apttus_Config2__Quantity__c = 1;
        li5.Apttus_Config2__RollupPriceToBundle__c = TRUE;
        li5.Apttus_Config2__SellingFrequency__c = 'Monthly';
        li5.Apttus_Config2__SellingTerm__c = 1;        
        li5.Apttus_Config2__Taxable__c = FALSE;
        li5.Apttus_Config2__TaxInclusive__c = FALSE;
        li5.Apttus_Config2__Term__c = 1;
        li5.Apttus_Config2__TotalQuantity__c = 1;
        li5.Apttus_Config2__Uom__c = 'Each';        
        li5.CurrencyIsoCode = 'CAD';
        li5.APTS_Product_Family__c = 'CLEAR';
        //li5.APTS_Cat_L2__c = System.Label.APTS_Clear_Product_Family;
        li5.APTS_Contract_Term__c = '2 Years';
        li5.APTS_Years_2_Plus_Adjustment__c = '5';
        li5.Apttus_Config2__IncentiveCode__c = '13843012,13843012';
        li5.APTS_Bridge__c='1 Month';             
        li5.APTS_Contract_Term__c = 'Short Term Trial';     
        listOfLineItems.add(li5);
        
        Apttus_Config2__LineItem__c li6 = new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c=prodConf5.id , Apttus_Config2__ProductId__c=prod.id);
        li6.Apttus_Config2__AddedBy__c = 'User';
        li6.Apttus_Config2__AdjustedPrice__c = 50;
        li6.Apttus_Config2__AdjustmentAmount__c = 50;
        li6.Apttus_Config2__AdjustmentType__c = '% Discount';
        li6.Apttus_Config2__AllocateGroupAdjustment__c = TRUE;
        li6.Apttus_Config2__AllowableAction__c = 'Unrestricted';
        li6.Apttus_Config2__AllowManualAdjustment__c = TRUE;
        li6.Apttus_Config2__AllowProration__c = FALSE;
        li6.Apttus_Config2__AllowRemoval__c = TRUE;
        li6.Apttus_Config2__AutoRenew__c = FALSE;
        li6.Apttus_Config2__BaseExtendedCost__c = 0;
        li6.Apttus_Config2__BaseExtendedPrice__c = 100;
        li6.Apttus_Config2__BasePrice__c = 100;
        li6.Apttus_Config2__BasePriceMethod__c = 'Per Unit';
        li6.Apttus_Config2__BillingFrequency__c = 'Monthly';
        li6.Apttus_Config2__ChargeType__c = 'Subscription Fee';
        li6.Apttus_Config2__ConfigStatus__c = 'Complete';
        li6.Apttus_Config2__ConstraintCheckStatus__c = 'NA';
        li6.Apttus_Config2__Customizable__c = FALSE;
        li6.Apttus_Config2__DeltaPrice__c = 50;
        li6.Apttus_Config2__DeltaQuantity__c = 1;
        li6.Apttus_Config2__Description__c = 'Westlaw Flex Plan $100/500';
        li6.Apttus_Config2__ExtendedCost__c = 0;
        li6.Apttus_Config2__ExtendedPrice__c = 100;
        li6.Apttus_Config2__Frequency__c = 'Monthly';
        li6.Apttus_Config2__Guidance__c = 'Red';       
        li6.Apttus_Config2__IsPrimaryLine__c = TRUE;        
        li6.Apttus_Config2__ItemSequence__c = 1;
        li6.Apttus_Config2__LineNumber__c = 1;
        li6.Apttus_Config2__LineSequence__c = 1;
        li6.Apttus_Config2__LineStatus__c = 'New';
        li6.APTS_Yr_1_Renewal_Adjustment__c='1';
        li6.Apttus_Config2__LineType__c = 'Product/Service';
        li6.Apttus_Config2__ListPrice__c = 100;
        li6.Apttus_Config2__NetAdjustmentPercent__c = -50;
        li6.Apttus_Config2__NetPrice__c = 50;
        li6.Apttus_Config2__NetUnitPrice__c = 50;
        li6.Apttus_Config2__OptionSequence__c = 0;        
        li6.Apttus_Config2__PriceMethod__c = 'Per Unit';
        li6.Apttus_Config2__PriceType__c = 'Recurring';
        li6.Apttus_Config2__PriceUom__c = 'Attorneys';
        li6.Apttus_Config2__PricingStatus__c = 'Complete';       
        li6.APTS_Product_Family__c='RUTTER';
       // li6.APTS_Cat_L3__c = System.Label.APTS_Rutter_Product_Family;
        li6.Apttus_Config2__Quantity__c = 1;
        li6.Apttus_Config2__RollupPriceToBundle__c = TRUE;
        li6.Apttus_Config2__SellingFrequency__c = 'Monthly';
        li6.Apttus_Config2__SellingTerm__c = 1;        
        li6.Apttus_Config2__Taxable__c = FALSE;
        li6.Apttus_Config2__TaxInclusive__c = FALSE;
        li6.Apttus_Config2__Term__c = 1;
        li6.Apttus_Config2__TotalQuantity__c = 1;
        li6.Apttus_Config2__Uom__c = 'Each';        
        li6.CurrencyIsoCode = 'CAD';
        li6.APTS_Product_Family__c = 'CLEAR';
        //li6.APTS_Cat_L2__c = System.Label.APTS_Clear_Product_Family;
        li6.APTS_Contract_Term__c = '2 Years';
        li6.APTS_Years_2_Plus_Adjustment__c = '5';
        li6.Apttus_Config2__IncentiveCode__c = '13843012,13843012';
        li6.APTS_Bridge__c='1 Month';             
        li6.APTS_Contract_Term__c = 'Short Term Trial';     
        listOfLineItems.add(li6);
        
        insert listOfLineItems;
        
        List<Apttus_Config2__LineItem__c> liToUpdate = new List<Apttus_Config2__LineItem__c>();   
        li1.Apttus_Config2__Description__c = 'Test1';
        li2.Apttus_Config2__Description__c = 'Test1';
        li3.Apttus_Config2__Description__c = 'Test1';
        li4.Apttus_Config2__Description__c = 'Test1';
        li5.Apttus_Config2__Description__c = 'Test1';
        li6.Apttus_Config2__Description__c = 'Test1';
        liToUpdate.add(li1);
        liToUpdate.add(li2);
        liToUpdate.add(li3);
        liToUpdate.add(li4);
        liToUpdate.add(li5);
        liToUpdate.add(li6);
        update liToUpdate;
        
        String str1 = 'Test1,Test2';
        String str2 = 'Test1,Test2';
        APTS_LineItemTriggerHelper.matchPromo(str1,str2);
        
        Test.stopTest();
        }        
    }
    
    static testMethod void approvaltest1() {
        
        WebServiceSettings__c oWebServiceSettings = new WebServiceSettings__c(
            Active__c = true,
            Name = 'Payment AutoCharge',
            Service_Unavailable_Message__c = 'Auto Payment Service is Currently unavailable',        
            Endpoint__c = 'https://stg.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentAutoCharge');
        insert oWebServiceSettings ;
        
        WebServiceSettings__c o1WebServiceSettings = new WebServiceSettings__c(
            Active__c = true,
            Name = 'PaymentCreditIncrease',
            Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable',        
            Endpoint__c = 'https://qa.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease');
        insert o1WebServiceSettings ;
        
        Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
        
        Apttus_Config2__PriceList__c priceList = APTS_TestDataFactory.createPriceList('Thomson Reuters Master - US Legal');
        insert priceList;        
        
        Schema.DescribeFieldResult fieldResultMarket = Apttus_Config2__ProductConfiguration__c.APTS_AccountMirror_Picklist__c.getDescribe();
        String valueMarket = fieldResultMarket.getPicklistValues().get(0).getValue();
        
        Account a = new Account(RecordTypeId=accRecordTypeId,FrozenMarketSegment__c = valueMarket,name='test-sg',sales_org__c='ABEP',customer_group__c='Academic',customer_type__c='Organization',customer_class_c__c='Academic Lecturer');
        a.APTS_Customer_Category__c = '';
        a.Is_GLI__c = True;
        insert a;
        
        //Inserting SourceSystemDetail
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();
        List<Source_System_Detail__c> ssdList = new List<Source_System_Detail__c>();
        Source_System_Detail__c accountSSD= new Source_System_Detail__c();
        accountSSD.RecordtypeId=ssdRecorType;
        accountSSD.Name='ABC';
        accountSSD.Source_System_Name__c='ABC';
        accountSSD.Account_Name__c=a.ID;
        accountSSD.APTS_Customer_Category__c='1';
        accountSSD.LCRM_Customer_Group__c='Academic';
        accountSSD.LCRM_Frozen_Market_Segment__c = valueMarket;
        accountSSD.Account_Inactive__c=false;
        accountSSD.LCRM_Sales_Org__c='WEST';
        accountSSD.APTS_Has_Online_Assets__c=true;
        ssdList.add(accountSSD);
        
        Source_System_Detail__c accountSSD1= new Source_System_Detail__c();
        accountSSD1.RecordtypeId=ssdRecorType;
        accountSSD1.Name='ABC';
        accountSSD1.Source_System_Name__c='ABC';
        accountSSD1.Account_Name__c=a.ID;
        accountSSD1.APTS_Customer_Category__c='1';
        accountSSD1.LCRM_Customer_Group__c='Academic';
        accountSSD1.LCRM_Frozen_Market_Segment__c = valueMarket;
        accountSSD1.Account_Inactive__c=false;
        accountSSD1.LCRM_Sales_Org__c='S100';
        accountSSD1.APTS_Has_Online_Assets__c=true;
        ssdList.add(accountSSD1);
        
        insert ssdList;
        
        //Added by Chirag 1/10/18
        /*Apttus_Config2__AssetLineItem__c asset = new Apttus_Config2__AssetLineItem__c(Name = 'Test asset', APTS_Info_PlanType__c = 'S00', 
        Apttus_Config2__NetPrice__c = 10.00, APTS_SSD_Bill_To__c = accountSSD.Id,
        APTS_Info_RenewalDate__c = System.today().addDays(150));
        insert asset; */
        
        Profile prof = [SELECT Id, Name FROM Profile WHERE Name='System Administrator'];   
        
        User u = new User(Alias = 'sattudt', Email='sattu@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='chan', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = prof.Id,
                          TimeZoneSidKey='America/Los_Angeles', UserName='sattu@testorg.com', Sub_Bu__c = 'LMS');
        insert u; 
        System.AssertEquals(prof.Name, 'System Administrator');
        
        //Inserting KeyValueStore
        List<KeyValueListStore__c> keyvaluestoreList = new List<KeyValueListStore__c>();
        KeyValueListStore__c keyvaluestore=new  KeyValueListStore__c();
        keyvaluestore.Name='ANZUsersProfileId';
        keyvaluestore.TextValue__c=System.Label.APTS_OC_Test_Id;
        keyvaluestoreList.add(keyvaluestore); 
        KeyValueListStore__c keyval = new KeyValueListStore__c();
        keyval.Name='ReasonWithCompetitor';
        keyval.TextValue__c='Price';
        keyvaluestoreList.add(keyval);
        insert keyvaluestoreList;
        
        //Inserting recordLists
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
                
        Date todaysDate = system.today();
        Id oppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Pipeline Opportunity').getRecordTypeId();
        Opportunity o = new Opportunity(RecordTypeId=oppRecordTypeId,  Name='tst-opp', stagename='25%',closedate=todaysDate,forecastcategoryname='pipeline',accountId=a.id,Source_System_Detail__c=accountSSD.id);
        insert o;
        
        Id devRecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Proposal').getRecordTypeId();
        List<Apttus_Proposal__Proposal__c> proposalList = new List<Apttus_Proposal__Proposal__c >();
        Apttus_Proposal__Proposal__c p = new Apttus_Proposal__Proposal__c(RecordTypeId=devRecordTypeId, CurrencyIsoCode = 'USD', Apttus_Proposal__Proposal_Name__c='TST-10', Apttus_Proposal__Opportunity__c=o.id, Apttus_Proposal__Approval_Stage__c='Draft', Apttus_Proposal__Proposal_Category__c='Quote', Apttus_Proposal__ReadyToGenerate__c = true, Apttus_Proposal__ReadyToPresent__c= true,APTS_SSD_Sold_To__c=accountSSD.Id,APTS_SSD_ship_to__c=accountSSD.Id,APTS_SSD_bill_to__c=accountSSD.Id,APTS_Proposal_Business_Unit__c ='SCS');
        p.APTS_Approval_Segment__c = 'Medium Law';
        p.APTS_LMS_Catalog__c =  True;
        proposalList.add(p);
        
        Apttus_Proposal__Proposal__c p1 = new Apttus_Proposal__Proposal__c(RecordTypeId=devRecordTypeId, CurrencyIsoCode = 'USD', Apttus_Proposal__Proposal_Name__c='TST-11', Apttus_Proposal__Opportunity__c=o.id, Apttus_Proposal__Approval_Stage__c='Draft', Apttus_Proposal__Proposal_Category__c='Quote', Apttus_Proposal__ReadyToGenerate__c = true, Apttus_Proposal__ReadyToPresent__c= true,APTS_SSD_Sold_To__c=accountSSD1.Id,APTS_SSD_ship_to__c=accountSSD1.Id,APTS_SSD_bill_to__c=accountSSD1.Id,APTS_Proposal_Business_Unit__c ='Canada');
        //p.APTS_Approval_Segment__c = 'Medium Law';
        p1.APTS_LMS_Catalog__c = True;
        proposalList.add(p1);
        insert proposalList;
        system.debug(' p PBU = '+p.APTS_Proposal_Business_Unit__c);
        system.debug(' p1 PBU = '+p1.APTS_Proposal_Business_Unit__c);
        
        List<Apttus_Config2__ProductConfiguration__c> pconfigList = new List<Apttus_Config2__ProductConfiguration__c >();
        Apttus_Config2__ProductConfiguration__c prodConf = new Apttus_Config2__ProductConfiguration__c(Name='prod-conf1', CurrencyIsoCode = 'USD', Apttus_QPConfig__Proposald__c=p.id,APTS_SSD_ship_to__c=accountSSD.Id,APTS_SSD_bill_to__c=accountSSD.Id);
        pconfigList.add(prodConf);
        
        Apttus_Config2__ProductConfiguration__c prodConf1 = new Apttus_Config2__ProductConfiguration__c(Name='prod-conf1', CurrencyIsoCode = 'USD', Apttus_QPConfig__Proposald__c=p1.id,APTS_SSD_ship_to__c=accountSSD1.Id,APTS_SSD_bill_to__c=accountSSD1.Id);
        pconfigList.add(prodConf1);
        insert pconfigList;
        System.debug('Config1 PBU'+prodConf1.APTS_Proposal_Business_Unit__c);
        Product2 prod = new Product2(name='prod1', Media_High_Level__c='Online', CurrencyIsoCode = 'USD',APTS_Cat_L3__c = System.Label.APTS_Ediscovery_Product_Family, Family = 'Ediscovery Point');
        insert prod;
        
        //Apttus_Config2__ConfigSystemProperties__c configSetting = [SELECT Id, Name, Apttus_Config2__DisableConstraintRules__c FROM Apttus_Config2__ConfigSystemProperties__c WHERE Name = 'System Properties'];
        //configSetting.Apttus_Config2__DisableConstraintRules__c = True;
        //update configSetting;
        Apttus_Config2__ConfigSystemProperties__c configSetting=new Apttus_Config2__ConfigSystemProperties__c(Name='System Properties',Apttus_Config2__DisableConstraintRules__c=true);
        insert configSetting;
         List<Apttus_Config2__LineItem__c> lstToUpdate = new List<Apttus_Config2__LineItem__c>(); 
        
        List<Apttus_Config2__AssetLineItem__c> assetList = new List<Apttus_Config2__AssetLineItem__c >();
        Apttus_Config2__AssetLineItem__c asset = new Apttus_Config2__AssetLineItem__c(Name = 'Test asset', APTS_Info_PlanType__c = 'S00', 
                                                                                      Apttus_Config2__ProductId__c=prod.id,
                                                                                      Apttus_Config2__NetPrice__c = 10.00,
                                                                                      APTS_SSD_Bill_To__c = accountSSD1.Id,
                                                                                      APTS_SSD_Sold_To__c = accountSSD1.Id,
                                                                                      Apttus_Config2__assetstatus__c='Activated',
                                                                                      Apttus_Config2__IsInactive__c =false,
                                                                                      Apttus_Config2__ListPrice__c =0,
                                                                                      Apttus_Config2__ChargeType__c='Standard Price',
                                                                                      Apttus_Config2__PriceType__c = 'One Time',
                                                                                      Apttus_Config2__BillingFrequency__c = 'Yearly',
                                                                                      Apttus_QPConfig__ProposalId__c =p.id,APTS_Proposal_Business_Unit__c = 'Canada',Apttus_Config2__NetUnitPrice__c = 100,
                                                                                      APTS_Info_RenewalDate__c = System.today().addDays(150),Apttus_Config2__BasePriceMethod__c = 'Per Unit');
        assetList.add(asset);
        
        Apttus_Config2__AssetLineItem__c asset1 = new Apttus_Config2__AssetLineItem__c(Name = 'Test asset', APTS_Info_PlanType__c = 'S00', 
                                                                                      Apttus_Config2__ProductId__c=prod.id,
                                                                                      Apttus_Config2__NetPrice__c = 10.00,
                                                                                      APTS_SSD_Bill_To__c = accountSSD1.Id,
                                                                                      APTS_SSD_Sold_To__c = accountSSD1.Id,
                                                                                      Apttus_Config2__assetstatus__c='Activated',
                                                                                      Apttus_Config2__IsInactive__c =false,
                                                                                      Apttus_Config2__ListPrice__c =0,
                                                                                      Apttus_Config2__ChargeType__c='Standard Price',
                                                                                      Apttus_Config2__PriceType__c = 'One Time',
                                                                                      Apttus_Config2__BillingFrequency__c = 'Monthly',
                                                                                      Apttus_QPConfig__ProposalId__c =p.id,APTS_Proposal_Business_Unit__c = 'Canada',Apttus_Config2__NetUnitPrice__c = 100,
                                                                                      APTS_Info_RenewalDate__c = System.today().addDays(150),Apttus_Config2__BasePriceMethod__c = 'Per Unit');
        assetList.add(asset1);
        
        Apttus_Config2__AssetLineItem__c asset2 = new Apttus_Config2__AssetLineItem__c(Name = 'Test asset', APTS_Info_PlanType__c = 'S00', 
                                                                                      Apttus_Config2__ProductId__c=prod.id,
                                                                                      Apttus_Config2__NetPrice__c = 10.00,
                                                                                      APTS_SSD_Bill_To__c = accountSSD1.Id,
                                                                                      APTS_SSD_Sold_To__c = accountSSD1.Id,
                                                                                      Apttus_Config2__assetstatus__c='Activated',
                                                                                      Apttus_Config2__IsInactive__c =false,
                                                                                      Apttus_Config2__ListPrice__c =0,
                                                                                      Apttus_Config2__ChargeType__c='Standard Price',
                                                                                      Apttus_Config2__PriceType__c = 'One Time',
                                                                                      Apttus_Config2__BillingFrequency__c = 'Monthly',
                                                                                      Apttus_QPConfig__ProposalId__c =p.id,APTS_Proposal_Business_Unit__c = 'Canada',Apttus_Config2__NetUnitPrice__c = 100,
                                                                                      APTS_Info_RenewalDate__c = System.today().addDays(150),Apttus_Config2__BasePriceMethod__c = 'Per Unit');
        assetList.add(asset2);
        
        Apttus_Config2__AssetLineItem__c asset3 = new Apttus_Config2__AssetLineItem__c(Name = 'Test asset', APTS_Info_PlanType__c = 'S00', 
                                                                                      Apttus_Config2__ProductId__c=prod.id,
                                                                                      Apttus_Config2__NetPrice__c = 10.00,
                                                                                      APTS_SSD_Bill_To__c = accountSSD1.Id,
                                                                                      APTS_SSD_Sold_To__c = accountSSD1.Id,
                                                                                      Apttus_Config2__assetstatus__c='Activated',
                                                                                      Apttus_Config2__IsInactive__c =false,
                                                                                      Apttus_Config2__ListPrice__c =0,
                                                                                      Apttus_Config2__ChargeType__c='Standard Price',
                                                                                      Apttus_Config2__PriceType__c = 'One Time',
                                                                                      Apttus_Config2__BillingFrequency__c = 'Daily',
                                                                                      Apttus_QPConfig__ProposalId__c =p.id,APTS_Proposal_Business_Unit__c = 'Canada',Apttus_Config2__NetUnitPrice__c = 100,
                                                                                      APTS_Info_RenewalDate__c = System.today().addDays(150),Apttus_Config2__BasePriceMethod__c = 'Per Unit');
        assetList.add(asset3);
        insert assetList;
        
        Apttus_Config2__LineItem__c li = new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c=prodConf.id , Apttus_Config2__ProductId__c=prod.id,Apttus_Config2__Quantity__c=1, Apttus_Config2__NetPrice__c=100.00,Apttus_Config2__ItemSequence__c=1, Apttus_Config2__LineNumber__c=1, APTS_Contract_Term__c = '2 Years' );
        li.Apttus_Config2__LineStatus__c = 'New';
        insert li;
        
        List<Apttus_Config2__LineItem__c> lineItemNew = new List<Apttus_Config2__LineItem__c >();
        //li.APTS_Contract_Term__c = '3 Years';       
        //update li;
        Apttus_Config2__LineItem__c li2 = new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c=prodConf.id , Apttus_Config2__ProductId__c=prod.id);
        li2.Apttus_Config2__AddedBy__c = 'User';
        li2.Apttus_Config2__AdjustedPrice__c = 50;
        li2.APTS_Yr_2_Amount__c = 20;
        li2.Apttus_Config2__AdjustmentAmount__c = 50;
        li2.Apttus_Config2__AdjustmentType__c = '% Discount';
        li2.Apttus_Config2__AllocateGroupAdjustment__c = TRUE;
        li2.Apttus_Config2__AllowableAction__c = 'Unrestricted';
        li2.Apttus_Config2__AllowManualAdjustment__c = TRUE;
        li2.Apttus_Config2__AllowProration__c = FALSE;
        li2.Apttus_Config2__AllowRemoval__c = TRUE;
        li2.Apttus_Config2__AutoRenew__c = FALSE;
        li2.Apttus_Config2__BaseExtendedCost__c = 0;
        li2.Apttus_Config2__BaseExtendedPrice__c = 100;
        li2.Apttus_Config2__BasePrice__c = 100;
        li2.Apttus_Config2__BasePriceMethod__c = 'Per Unit';
        li2.Apttus_Config2__BillingFrequency__c = 'Monthly';
        li2.Apttus_Config2__ChargeType__c = 'Subscription Fee';
        li2.Apttus_Config2__ConfigStatus__c = 'Complete';
        li2.Apttus_Config2__ConstraintCheckStatus__c = 'NA';
        li2.Apttus_Config2__Customizable__c = FALSE;
        li2.Apttus_Config2__DeltaPrice__c = 50;
        li2.Apttus_Config2__DeltaQuantity__c = 1;
        li2.Apttus_Config2__Description__c = 'Westlaw Flex Plan $100/500';
        li2.Apttus_Config2__ExtendedCost__c = 0;
        li2.Apttus_Config2__ExtendedPrice__c = 100;
        li2.Apttus_Config2__Frequency__c = 'Monthly';
        li2.Apttus_Config2__Guidance__c = 'Red';
        li2.Apttus_Config2__HasAttributes__c = FALSE;
        li2.Apttus_Config2__HasBaseProduct__c = FALSE;
        li2.Apttus_Config2__HasDefaults__c = FALSE;
        li2.Apttus_Config2__HasIncentives__c = FALSE;
        li2.Apttus_Config2__HasOptions__c = FALSE;
        li2.Apttus_Config2__HasTieredPrice__c = FALSE;
        li2.Apttus_Config2__HideCopyAction__c = FALSE;
        li2.Apttus_Config2__HideInvoiceDisplay__c = FALSE;
        li2.Apttus_Config2__IsAssetPricing__c = FALSE;
        li2.Apttus_Config2__IsCustomPricing__c = FALSE;
        li2.Apttus_Config2__IsHidden__c = FALSE;
        li2.Apttus_Config2__IsOptionRollupLine__c = FALSE;
        li2.Apttus_Config2__IsPrimaryLine__c = TRUE;
        li2.Apttus_Config2__IsPrimaryRampLine__c = FALSE;
        li2.Apttus_Config2__IsQuantityModifiable__c = FALSE;
        li2.Apttus_Config2__IsReadOnly__c = FALSE;
        li2.Apttus_Config2__IsSellingTermReadOnly__c = FALSE;
        li2.Apttus_Config2__IsUsageTierModifiable__c = FALSE;
        li2.Apttus_Config2__ItemSequence__c = 1;
        li2.Apttus_Config2__LineNumber__c = 1;
        li2.Apttus_Config2__LineSequence__c = 1;
        li2.Apttus_Config2__LineStatus__c = 'New';
        li2.Apttus_Config2__LineType__c = 'Product/Service';
        li2.Apttus_Config2__ListPrice__c = 100;
        li2.Apttus_Config2__NetAdjustmentPercent__c = -50;
        li2.Apttus_Config2__NetPrice__c = 50;
        li2.Apttus_Config2__NetUnitPrice__c = 50;
        li2.Apttus_Config2__OptionSequence__c = 0;
        li2.Apttus_Config2__PriceIncludedInBundle__c = FALSE;
        li2.Apttus_Config2__PriceMethod__c = 'Per Unit';
        li2.Apttus_Config2__PriceType__c = 'Recurring';
        li2.Apttus_Config2__PriceUom__c = 'Each';
        li2.Apttus_Config2__PricingStatus__c = 'Complete';
        li2.Apttus_Config2__PrimaryLineNumber__c = 1;
        li2.Apttus_Config2__ProductVersion__c = 1;
        li2.Apttus_Config2__Quantity__c = 1;
        li2.Apttus_Config2__RollupPriceToBundle__c = TRUE;
        li2.Apttus_Config2__SellingFrequency__c = 'Monthly';
        li2.Apttus_Config2__SellingTerm__c = 1;
        li2.Apttus_Config2__SyncStatus__c = 'Pending';
        li2.Apttus_Config2__Taxable__c = FALSE;
        li2.Apttus_Config2__TaxInclusive__c = FALSE;
        li2.Apttus_Config2__Term__c = 1;
        li2.Apttus_Config2__TotalQuantity__c = 1;
        li2.Apttus_Config2__Uom__c = 'Each';
        li2.Apttus_CQApprov__Approval_Status__c = 'Pending Approval';
        li2.CurrencyIsoCode = 'USD';
        li2.APTS_Product_Family__c = 'WESTLAW';
        li2.APTS_Contract_Term__c = '2 Years';
        li2.APTS_Years_2_Plus_Adjustment__c = '4';
        li2.APTS_Bridge__c='2 Months';
        li2.APTS_Product_Delivery__c='Online/Internet';
        li2.Apttus_Config2__Quantity__c = 1;
        li2.Apttus_Config2__AssetLineItemId__c = asset.Id;
        li2.Apttus_Config2__BillingFrequency__c='Monthly';
        lineItemNew.add(li2);
        
        Apttus_Config2__LineItem__c li3 = new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c=prodConf.id , Apttus_Config2__ProductId__c=prod.id);
        li3.Apttus_Config2__AddedBy__c = 'User';
        li3.Apttus_Config2__AdjustedPrice__c = 50;
        li3.APTS_Yr_2_Amount__c = 20;
        li3.Apttus_Config2__AdjustmentAmount__c = 50;
        li3.Apttus_Config2__AdjustmentType__c = '% Discount';
        li3.Apttus_Config2__AllocateGroupAdjustment__c = TRUE;
        li3.Apttus_Config2__AllowableAction__c = 'Unrestricted';
        li3.Apttus_Config2__AllowManualAdjustment__c = TRUE;
        li3.Apttus_Config2__AllowProration__c = FALSE;
        li3.Apttus_Config2__AllowRemoval__c = TRUE;
        li3.Apttus_Config2__AutoRenew__c = FALSE;
        li3.Apttus_Config2__BaseExtendedCost__c = 0;
        li3.Apttus_Config2__BaseExtendedPrice__c = 100;
        li3.Apttus_Config2__BasePrice__c = 100;
        li3.Apttus_Config2__BasePriceMethod__c = 'Per Unit';
        li3.Apttus_Config2__BillingFrequency__c = 'Monthly';
        li3.Apttus_Config2__ChargeType__c = 'Subscription Fee';
        li3.Apttus_Config2__ConfigStatus__c = 'Complete';
        li3.Apttus_Config2__ConstraintCheckStatus__c = 'NA';
        li3.Apttus_Config2__Customizable__c = FALSE;
        li3.Apttus_Config2__DeltaPrice__c = 50;
        li3.Apttus_Config2__DeltaQuantity__c = 1;
        li3.Apttus_Config2__Description__c = 'Westlaw Flex Plan $100/500';
        li3.Apttus_Config2__ExtendedCost__c = 0;
        li3.Apttus_Config2__ExtendedPrice__c = 100;
        li3.Apttus_Config2__Frequency__c = 'Monthly';
        li3.Apttus_Config2__Guidance__c = 'Red';
        li3.Apttus_Config2__HasAttributes__c = FALSE;
        li3.Apttus_Config2__HasBaseProduct__c = FALSE;
        li3.Apttus_Config2__HasDefaults__c = FALSE;
        li3.Apttus_Config2__HasIncentives__c = FALSE;
        li3.Apttus_Config2__HasOptions__c = FALSE;
        li3.Apttus_Config2__HasTieredPrice__c = FALSE;
        li3.Apttus_Config2__HideCopyAction__c = FALSE;
        li3.Apttus_Config2__HideInvoiceDisplay__c = FALSE;
        li3.Apttus_Config2__IsAssetPricing__c = FALSE;
        li3.Apttus_Config2__IsCustomPricing__c = FALSE;
        li3.Apttus_Config2__IsHidden__c = FALSE;
        li3.Apttus_Config2__IsOptionRollupLine__c = FALSE;
        li3.Apttus_Config2__IsPrimaryLine__c = TRUE;
        li3.Apttus_Config2__IsPrimaryRampLine__c = FALSE;
        li3.Apttus_Config2__IsQuantityModifiable__c = FALSE;
        li3.Apttus_Config2__IsReadOnly__c = FALSE;
        li3.Apttus_Config2__IsSellingTermReadOnly__c = FALSE;
        li3.Apttus_Config2__IsUsageTierModifiable__c = FALSE;
        li3.Apttus_Config2__ItemSequence__c = 1;
        li3.Apttus_Config2__LineNumber__c = 1;
        li3.Apttus_Config2__LineSequence__c = 1;
        li3.Apttus_Config2__LineStatus__c = 'New';
        li3.Apttus_Config2__LineType__c = 'Product/Service';
        li3.Apttus_Config2__ListPrice__c = 100;
        li3.Apttus_Config2__NetAdjustmentPercent__c = -50;
        li3.Apttus_Config2__NetPrice__c = 50;
        li3.Apttus_Config2__NetUnitPrice__c = 50;
        li3.Apttus_Config2__OptionSequence__c = 0;
        li3.Apttus_Config2__PriceIncludedInBundle__c = FALSE;
        li3.Apttus_Config2__PriceMethod__c = 'Per Unit';
        li3.Apttus_Config2__PriceType__c = 'Recurring';
        li3.Apttus_Config2__PriceUom__c = 'Each';
        li3.Apttus_Config2__PricingStatus__c = 'Complete';
        li3.Apttus_Config2__PrimaryLineNumber__c = 1;
        li3.Apttus_Config2__ProductVersion__c = 1;
        li3.Apttus_Config2__Quantity__c = 1;
        li3.Apttus_Config2__RollupPriceToBundle__c = TRUE;
        li3.Apttus_Config2__SellingFrequency__c = 'Monthly';
        li3.Apttus_Config2__SellingTerm__c = 1;
        li3.Apttus_Config2__SyncStatus__c = 'Pending';
        li3.Apttus_Config2__Taxable__c = FALSE;
        li3.Apttus_Config2__TaxInclusive__c = FALSE;
        li3.Apttus_Config2__Term__c = 1;
        li3.Apttus_Config2__TotalQuantity__c = 1;
        li3.Apttus_Config2__Uom__c = 'Each';
        li3.Apttus_CQApprov__Approval_Status__c = 'Pending Approval';
        li3.CurrencyIsoCode = 'USD';
        li3.APTS_Product_Family__c = 'WESTLAW';
        li3.APTS_Contract_Term__c = '3 Years';
        li3.APTS_Years_2_Plus_Adjustment__c = '4';
        li3.APTS_Bridge__c='2 Months';
        li3.APTS_Product_Delivery__c='Online/Internet';
        li3.Apttus_Config2__Quantity__c = 1;
        li3.Apttus_Config2__AssetLineItemId__c = asset1.Id;
        li3.Apttus_Config2__BillingFrequency__c='Monthly';
        lineItemNew.add(li3);
        
        Apttus_Config2__LineItem__c li4 = new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c=prodConf.id , Apttus_Config2__ProductId__c=prod.id);
        li4.Apttus_Config2__AddedBy__c = 'User';
        li4.Apttus_Config2__AdjustedPrice__c = 50;
        li4.APTS_Yr_2_Amount__c = 20;
        li4.Apttus_Config2__AdjustmentAmount__c = 50;
        li4.Apttus_Config2__AdjustmentType__c = '% Discount';
        li4.Apttus_Config2__AllocateGroupAdjustment__c = TRUE;
        li4.Apttus_Config2__AllowableAction__c = 'Unrestricted';
        li4.Apttus_Config2__AllowManualAdjustment__c = TRUE;
        li4.Apttus_Config2__AllowProration__c = FALSE;
        li4.Apttus_Config2__AllowRemoval__c = TRUE;
        li4.Apttus_Config2__AutoRenew__c = FALSE;
        li4.Apttus_Config2__BaseExtendedCost__c = 0;
        li4.Apttus_Config2__BaseExtendedPrice__c = 100;
        li4.Apttus_Config2__BasePrice__c = 100;
        li4.Apttus_Config2__BasePriceMethod__c = 'Per Unit';
        li4.Apttus_Config2__BillingFrequency__c = 'Monthly';
        li4.Apttus_Config2__ChargeType__c = 'Subscription Fee';
        li4.Apttus_Config2__ConfigStatus__c = 'Complete';
        li4.Apttus_Config2__ConstraintCheckStatus__c = 'NA';
        li4.Apttus_Config2__Customizable__c = FALSE;
        li4.Apttus_Config2__DeltaPrice__c = 50;
        li4.Apttus_Config2__DeltaQuantity__c = 1;
        li4.Apttus_Config2__Description__c = 'Westlaw Flex Plan $100/500';
        li4.Apttus_Config2__ExtendedCost__c = 0;
        li4.Apttus_Config2__ExtendedPrice__c = 100;
        li4.Apttus_Config2__Frequency__c = 'Monthly';
        li4.Apttus_Config2__Guidance__c = 'Red';
        li4.Apttus_Config2__HasAttributes__c = FALSE;
        li4.Apttus_Config2__HasBaseProduct__c = FALSE;
        li4.Apttus_Config2__HasDefaults__c = FALSE;
        li4.Apttus_Config2__HasIncentives__c = FALSE;
        li4.Apttus_Config2__HasOptions__c = FALSE;
        li4.Apttus_Config2__HasTieredPrice__c = FALSE;
        li4.Apttus_Config2__HideCopyAction__c = FALSE;
        li4.Apttus_Config2__HideInvoiceDisplay__c = FALSE;
        li4.Apttus_Config2__IsAssetPricing__c = FALSE;
        li4.Apttus_Config2__IsCustomPricing__c = FALSE;
        li4.Apttus_Config2__IsHidden__c = FALSE;
        li4.Apttus_Config2__IsOptionRollupLine__c = FALSE;
        li4.Apttus_Config2__IsPrimaryLine__c = TRUE;
        li4.Apttus_Config2__IsPrimaryRampLine__c = FALSE;
        li4.Apttus_Config2__IsQuantityModifiable__c = FALSE;
        li4.Apttus_Config2__IsReadOnly__c = FALSE;
        li4.Apttus_Config2__IsSellingTermReadOnly__c = FALSE;
        li4.Apttus_Config2__IsUsageTierModifiable__c = FALSE;
        li4.Apttus_Config2__ItemSequence__c = 1;
        li4.Apttus_Config2__LineNumber__c = 1;
        li4.Apttus_Config2__LineSequence__c = 1;
        li4.Apttus_Config2__LineStatus__c = 'New';
        li4.Apttus_Config2__LineType__c = 'Product/Service';
        li4.Apttus_Config2__ListPrice__c = 100;
        li4.Apttus_Config2__NetAdjustmentPercent__c = -50;
        li4.Apttus_Config2__NetPrice__c = 50;
        li4.Apttus_Config2__NetUnitPrice__c = 50;
        li4.Apttus_Config2__OptionSequence__c = 0;
        li4.Apttus_Config2__PriceIncludedInBundle__c = FALSE;
        li4.Apttus_Config2__PriceMethod__c = 'Per Unit';
        li4.Apttus_Config2__PriceType__c = 'Recurring';
        li4.Apttus_Config2__PriceUom__c = 'Each';
        li4.Apttus_Config2__PricingStatus__c = 'Complete';
        li4.Apttus_Config2__PrimaryLineNumber__c = 1;
        li4.Apttus_Config2__ProductVersion__c = 1;
        li4.Apttus_Config2__Quantity__c = 1;
        li4.Apttus_Config2__RollupPriceToBundle__c = TRUE;
        li4.Apttus_Config2__SellingFrequency__c = 'Monthly';
        li4.Apttus_Config2__SellingTerm__c = 1;
        li4.Apttus_Config2__SyncStatus__c = 'Pending';
        li4.Apttus_Config2__Taxable__c = FALSE;
        li4.Apttus_Config2__TaxInclusive__c = FALSE;
        li4.Apttus_Config2__Term__c = 1;
        li4.Apttus_Config2__TotalQuantity__c = 1;
        li4.Apttus_Config2__Uom__c = 'Each';
        li4.Apttus_CQApprov__Approval_Status__c = 'Pending Approval';
        li4.CurrencyIsoCode = 'USD';
        li4.APTS_Product_Family__c = 'WESTLAW';
        li4.APTS_Contract_Term__c = '3 Years';
        li4.APTS_Years_2_Plus_Adjustment__c = '4';
        li4.APTS_Bridge__c='2 Months';
        li4.APTS_Product_Delivery__c='Online/Internet';
        li4.Apttus_Config2__Quantity__c = 1;
        li4.Apttus_Config2__AssetLineItemId__c = asset2.Id;
        li4.Apttus_Config2__BillingFrequency__c='Yearly';
        lineItemNew.add(li4);
        
        Apttus_Config2__LineItem__c li5 = new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c=prodConf.id , Apttus_Config2__ProductId__c=prod.id);
        li5.Apttus_Config2__AddedBy__c = 'User';
        li5.Apttus_Config2__AdjustedPrice__c = 50;
        li5.APTS_Yr_2_Amount__c = 20;
        li5.Apttus_Config2__AdjustmentAmount__c = 50;
        li5.Apttus_Config2__AdjustmentType__c = '% Discount';
        li5.Apttus_Config2__AllocateGroupAdjustment__c = TRUE;
        li5.Apttus_Config2__AllowableAction__c = 'Unrestricted';
        li5.Apttus_Config2__AllowManualAdjustment__c = TRUE;
        li5.Apttus_Config2__AllowProration__c = FALSE;
        li5.Apttus_Config2__AllowRemoval__c = TRUE;
        li5.Apttus_Config2__AutoRenew__c = FALSE;
        li5.Apttus_Config2__BaseExtendedCost__c = 0;
        li5.Apttus_Config2__BaseExtendedPrice__c = 100;
        li5.Apttus_Config2__BasePrice__c = 100;
        li5.Apttus_Config2__BasePriceMethod__c = 'Per Unit';
        li5.Apttus_Config2__BillingFrequency__c = 'Monthly';
        li5.Apttus_Config2__ChargeType__c = 'Subscription Fee';
        li5.Apttus_Config2__ConfigStatus__c = 'Complete';
        li5.Apttus_Config2__ConstraintCheckStatus__c = 'NA';
        li5.Apttus_Config2__Customizable__c = FALSE;
        li5.Apttus_Config2__DeltaPrice__c = 50;
        li5.Apttus_Config2__DeltaQuantity__c = 1;
        li5.Apttus_Config2__Description__c = 'Westlaw Flex Plan $100/500';
        li5.Apttus_Config2__ExtendedCost__c = 0;
        li5.Apttus_Config2__ExtendedPrice__c = 100;
        li5.Apttus_Config2__Frequency__c = 'Monthly';
        li5.Apttus_Config2__Guidance__c = 'Red';
        li5.Apttus_Config2__HasAttributes__c = FALSE;
        li5.Apttus_Config2__HasBaseProduct__c = FALSE;
        li5.Apttus_Config2__HasDefaults__c = FALSE;
        li5.Apttus_Config2__HasIncentives__c = FALSE;
        li5.Apttus_Config2__HasOptions__c = FALSE;
        li5.Apttus_Config2__HasTieredPrice__c = FALSE;
        li5.Apttus_Config2__HideCopyAction__c = FALSE;
        li5.Apttus_Config2__HideInvoiceDisplay__c = FALSE;
        li5.Apttus_Config2__IsAssetPricing__c = FALSE;
        li5.Apttus_Config2__IsCustomPricing__c = FALSE;
        li5.Apttus_Config2__IsHidden__c = FALSE;
        li5.Apttus_Config2__IsOptionRollupLine__c = FALSE;
        li5.Apttus_Config2__IsPrimaryLine__c = TRUE;
        li5.Apttus_Config2__IsPrimaryRampLine__c = FALSE;
        li5.Apttus_Config2__IsQuantityModifiable__c = FALSE;
        li5.Apttus_Config2__IsReadOnly__c = FALSE;
        li5.Apttus_Config2__IsSellingTermReadOnly__c = FALSE;
        li5.Apttus_Config2__IsUsageTierModifiable__c = FALSE;
        li5.Apttus_Config2__ItemSequence__c = 1;
        li5.Apttus_Config2__LineNumber__c = 1;
        li5.Apttus_Config2__LineSequence__c = 1;
        li5.Apttus_Config2__LineStatus__c = 'New';
        li5.Apttus_Config2__LineType__c = 'Product/Service';
        li5.Apttus_Config2__ListPrice__c = 100;
        li5.Apttus_Config2__NetAdjustmentPercent__c = -50;
        li5.Apttus_Config2__NetPrice__c = 50;
        li5.Apttus_Config2__NetUnitPrice__c = 50;
        li5.Apttus_Config2__OptionSequence__c = 0;
        li5.Apttus_Config2__PriceIncludedInBundle__c = FALSE;
        li5.Apttus_Config2__PriceMethod__c = 'Per Unit';
        li5.Apttus_Config2__PriceType__c = 'Recurring';
        li5.Apttus_Config2__PriceUom__c = 'Each';
        li5.Apttus_Config2__PricingStatus__c = 'Complete';
        li5.Apttus_Config2__PrimaryLineNumber__c = 1;
        li5.Apttus_Config2__ProductVersion__c = 1;
        li5.Apttus_Config2__Quantity__c = 1;
        li5.Apttus_Config2__RollupPriceToBundle__c = TRUE;
        li5.Apttus_Config2__SellingFrequency__c = 'Monthly';
        li5.Apttus_Config2__SellingTerm__c = 1;
        li5.Apttus_Config2__SyncStatus__c = 'Pending';
        li5.Apttus_Config2__Taxable__c = FALSE;
        li5.Apttus_Config2__TaxInclusive__c = FALSE;
        li5.Apttus_Config2__Term__c = 1;
        li5.Apttus_Config2__TotalQuantity__c = 1;
        li5.Apttus_Config2__Uom__c = 'Each';
        li5.Apttus_CQApprov__Approval_Status__c = 'Pending Approval';
        li5.CurrencyIsoCode = 'USD';
        li5.APTS_Product_Family__c = 'WESTLAW';
        li5.APTS_Contract_Term__c = '4 Years';
        li5.APTS_Years_2_Plus_Adjustment__c = '4';
        li5.APTS_Bridge__c='2 Months';
        li5.APTS_Product_Delivery__c='Online/Internet';
        li5.Apttus_Config2__Quantity__c = 1;
        li5.Apttus_Config2__AssetLineItemId__c = asset3.Id;
        li5.Apttus_Config2__BillingFrequency__c='Daily';
        lineItemNew.add(li5);
        
        Apttus_Config2__LineItem__c li6 = new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c=prodConf.id , Apttus_Config2__ProductId__c=prod.id);
        li6.Apttus_Config2__AddedBy__c = 'User';
        li6.Apttus_Config2__AdjustedPrice__c = 50;
        li6.APTS_Yr_2_Amount__c = 20;
        li6.Apttus_Config2__AdjustmentAmount__c = 50;
        li6.Apttus_Config2__AdjustmentType__c = '% Discount';
        li6.Apttus_Config2__AllocateGroupAdjustment__c = TRUE;
        li6.Apttus_Config2__AllowableAction__c = 'Unrestricted';
        li6.Apttus_Config2__AllowManualAdjustment__c = TRUE;
        li6.Apttus_Config2__AllowProration__c = FALSE;
        li6.Apttus_Config2__AllowRemoval__c = TRUE;
        li6.Apttus_Config2__AutoRenew__c = FALSE;
        li6.Apttus_Config2__BaseExtendedCost__c = 0;
        li6.Apttus_Config2__BaseExtendedPrice__c = 100;
        li6.Apttus_Config2__BasePrice__c = 100;
        li6.Apttus_Config2__BasePriceMethod__c = 'Per Unit';
        li6.Apttus_Config2__BillingFrequency__c = 'Monthly';
        li6.Apttus_Config2__ChargeType__c = 'Subscription Fee';
        li6.Apttus_Config2__ConfigStatus__c = 'Complete';
        li6.Apttus_Config2__ConstraintCheckStatus__c = 'NA';
        li6.Apttus_Config2__Customizable__c = FALSE;
        li6.Apttus_Config2__DeltaPrice__c = 50;
        li6.Apttus_Config2__DeltaQuantity__c = 1;
        li6.Apttus_Config2__Description__c = 'Westlaw Flex Plan $100/500';
        li6.Apttus_Config2__ExtendedCost__c = 0;
        li6.Apttus_Config2__ExtendedPrice__c = 100;
        li6.Apttus_Config2__Frequency__c = 'Monthly';
        li6.Apttus_Config2__Guidance__c = 'Red';
        li6.Apttus_Config2__HasAttributes__c = FALSE;
        li6.Apttus_Config2__HasBaseProduct__c = FALSE;
        li6.Apttus_Config2__HasDefaults__c = FALSE;
        li6.Apttus_Config2__HasIncentives__c = FALSE;
        li6.Apttus_Config2__HasOptions__c = FALSE;
        li6.Apttus_Config2__HasTieredPrice__c = FALSE;
        li6.Apttus_Config2__HideCopyAction__c = FALSE;
        li6.Apttus_Config2__HideInvoiceDisplay__c = FALSE;
        li6.Apttus_Config2__IsAssetPricing__c = FALSE;
        li6.Apttus_Config2__IsCustomPricing__c = FALSE;
        li6.Apttus_Config2__IsHidden__c = FALSE;
        li6.Apttus_Config2__IsOptionRollupLine__c = FALSE;
        li6.Apttus_Config2__IsPrimaryLine__c = TRUE;
        li6.Apttus_Config2__IsPrimaryRampLine__c = FALSE;
        li6.Apttus_Config2__IsQuantityModifiable__c = FALSE;
        li6.Apttus_Config2__IsReadOnly__c = FALSE;
        li6.Apttus_Config2__IsSellingTermReadOnly__c = FALSE;
        li6.Apttus_Config2__IsUsageTierModifiable__c = FALSE;
        li6.Apttus_Config2__ItemSequence__c = 1;
        li6.Apttus_Config2__LineNumber__c = 1;
        li6.Apttus_Config2__LineSequence__c = 1;
        li6.Apttus_Config2__LineStatus__c = 'New';
        li6.Apttus_Config2__LineType__c = 'Product/Service';
        li6.Apttus_Config2__ListPrice__c = 100;
        li6.Apttus_Config2__NetAdjustmentPercent__c = -50;
        li6.Apttus_Config2__NetPrice__c = 50;
        li6.Apttus_Config2__NetUnitPrice__c = 50;
        li6.Apttus_Config2__OptionSequence__c = 0;
        li6.Apttus_Config2__PriceIncludedInBundle__c = FALSE;
        li6.Apttus_Config2__PriceMethod__c = 'Per Unit';
        li6.Apttus_Config2__PriceType__c = 'Recurring';
        li6.Apttus_Config2__PriceUom__c = 'Each';
        li6.Apttus_Config2__PricingStatus__c = 'Complete';
        li6.Apttus_Config2__PrimaryLineNumber__c = 1;
        li6.Apttus_Config2__ProductVersion__c = 1;
        li6.Apttus_Config2__Quantity__c = 1;
        li6.Apttus_Config2__RollupPriceToBundle__c = TRUE;
        li6.Apttus_Config2__SellingFrequency__c = 'Monthly';
        li6.Apttus_Config2__SellingTerm__c = 1;
        li6.Apttus_Config2__SyncStatus__c = 'Pending';
        li6.Apttus_Config2__Taxable__c = FALSE;
        li6.Apttus_Config2__TaxInclusive__c = FALSE;
        li6.Apttus_Config2__Term__c = 1;
        li6.Apttus_Config2__TotalQuantity__c = 1;
        li6.Apttus_Config2__Uom__c = 'Each';
        li6.Apttus_CQApprov__Approval_Status__c = 'Pending Approval';
        li6.CurrencyIsoCode = 'USD';
        li6.APTS_Product_Family__c = 'WESTLAW';
        li6.APTS_Contract_Term__c = '5 Years';
        li6.APTS_Years_2_Plus_Adjustment__c = '4';
        li6.APTS_Bridge__c='2 Months';
        li6.APTS_Product_Delivery__c='Online/Internet';
        li6.Apttus_Config2__Quantity__c = 1;
        lineItemNew.add(li6);
        
        Apttus_Config2__LineItem__c li7 = new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c=prodConf.id , Apttus_Config2__ProductId__c=prod.id);
        li7.Apttus_Config2__AddedBy__c = 'User';
        li7.Apttus_Config2__AdjustedPrice__c = 50;
        li7.APTS_Yr_2_Amount__c = 20;
        li7.Apttus_Config2__AdjustmentAmount__c = 50;
        li7.Apttus_Config2__AdjustmentType__c = '% Discount';
        li7.Apttus_Config2__AllocateGroupAdjustment__c = TRUE;
        li7.Apttus_Config2__AllowableAction__c = 'Unrestricted';
        li7.Apttus_Config2__AllowManualAdjustment__c = TRUE;
        li7.Apttus_Config2__AllowProration__c = FALSE;
        li7.Apttus_Config2__AllowRemoval__c = TRUE;
        li7.Apttus_Config2__AutoRenew__c = FALSE;
        li7.Apttus_Config2__BaseExtendedCost__c = 0;
        li7.Apttus_Config2__BaseExtendedPrice__c = 100;
        li7.Apttus_Config2__BasePrice__c = 100;
        li7.Apttus_Config2__BasePriceMethod__c = 'Per Unit';
        li7.Apttus_Config2__BillingFrequency__c = 'Monthly';
        li7.Apttus_Config2__ChargeType__c = 'Subscription Fee';
        li7.Apttus_Config2__ConfigStatus__c = 'Complete';
        li7.Apttus_Config2__ConstraintCheckStatus__c = 'NA';
        li7.Apttus_Config2__Customizable__c = FALSE;
        li7.Apttus_Config2__DeltaPrice__c = 50;
        li7.Apttus_Config2__DeltaQuantity__c = 1;
        li7.Apttus_Config2__Description__c = 'Westlaw Flex Plan $100/500';
        li7.Apttus_Config2__ExtendedCost__c = 0;
        li7.Apttus_Config2__ExtendedPrice__c = 100;
        li7.Apttus_Config2__Frequency__c = 'Monthly';
        li7.Apttus_Config2__Guidance__c = 'Red';
        li7.Apttus_Config2__HasAttributes__c = FALSE;
        li7.Apttus_Config2__HasBaseProduct__c = FALSE;
        li7.Apttus_Config2__HasDefaults__c = FALSE;
        li7.Apttus_Config2__HasIncentives__c = FALSE;
        li7.Apttus_Config2__HasOptions__c = FALSE;
        li7.Apttus_Config2__HasTieredPrice__c = FALSE;
        li7.Apttus_Config2__HideCopyAction__c = FALSE;
        li7.Apttus_Config2__HideInvoiceDisplay__c = FALSE;
        li7.Apttus_Config2__IsAssetPricing__c = FALSE;
        li7.Apttus_Config2__IsCustomPricing__c = FALSE;
        li7.Apttus_Config2__IsHidden__c = FALSE;
        li7.Apttus_Config2__IsOptionRollupLine__c = FALSE;
        li7.Apttus_Config2__IsPrimaryLine__c = TRUE;
        li7.Apttus_Config2__IsPrimaryRampLine__c = FALSE;
        li7.Apttus_Config2__IsQuantityModifiable__c = FALSE;
        li7.Apttus_Config2__IsReadOnly__c = FALSE;
        li7.Apttus_Config2__IsSellingTermReadOnly__c = FALSE;
        li7.Apttus_Config2__IsUsageTierModifiable__c = FALSE;
        li7.Apttus_Config2__ItemSequence__c = 1;
        li7.Apttus_Config2__LineNumber__c = 1;
        li7.Apttus_Config2__LineSequence__c = 1;
        li7.Apttus_Config2__LineStatus__c = 'New';
        li7.Apttus_Config2__LineType__c = 'Product/Service';
        li7.Apttus_Config2__ListPrice__c = 100;
        li7.Apttus_Config2__NetAdjustmentPercent__c = -50;
        li7.Apttus_Config2__NetPrice__c = 50;
        li7.Apttus_Config2__NetUnitPrice__c = 50;
        li7.Apttus_Config2__OptionSequence__c = 0;
        li7.Apttus_Config2__PriceIncludedInBundle__c = FALSE;
        li7.Apttus_Config2__PriceMethod__c = 'Per Unit';
        li7.Apttus_Config2__PriceType__c = 'Recurring';
        li7.Apttus_Config2__PriceUom__c = 'Each';
        li7.Apttus_Config2__PricingStatus__c = 'Complete';
        li7.Apttus_Config2__PrimaryLineNumber__c = 1;
        li7.Apttus_Config2__ProductVersion__c = 1;
        li7.Apttus_Config2__Quantity__c = 1;
        li7.Apttus_Config2__RollupPriceToBundle__c = TRUE;
        li7.Apttus_Config2__SellingFrequency__c = 'Monthly';
        li7.Apttus_Config2__SellingTerm__c = 1;
        li7.Apttus_Config2__SyncStatus__c = 'Pending';
        li7.Apttus_Config2__Taxable__c = FALSE;
        li7.Apttus_Config2__TaxInclusive__c = FALSE;
        li7.Apttus_Config2__Term__c = 1;
        li7.Apttus_Config2__TotalQuantity__c = 1;
        li7.Apttus_Config2__Uom__c = 'Each';
        li7.Apttus_CQApprov__Approval_Status__c = 'Pending Approval';
        li7.CurrencyIsoCode = 'USD';
        li7.APTS_Product_Family__c = 'WESTLAW';
        li7.APTS_Contract_Term__c = '4 Years';
        li7.APTS_Years_2_Plus_Adjustment__c = '4';
        li7.APTS_Bridge__c='2 Months';
        li7.APTS_Product_Delivery__c='Online/Internet';
        li7.Apttus_Config2__Quantity__c = 1;
        lineItemNew.add(li7);
        
        Apttus_Config2__LineItem__c li8 = new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c=prodConf.id , Apttus_Config2__ProductId__c=prod.id);
        li8.Apttus_Config2__AddedBy__c = 'User';
        li8.Apttus_Config2__AdjustedPrice__c = 50;
        li8.APTS_Yr_2_Amount__c = 20;
        li8.Apttus_Config2__AdjustmentAmount__c = 50;
        li8.Apttus_Config2__AdjustmentType__c = '% Discount';
        li8.Apttus_Config2__AllocateGroupAdjustment__c = TRUE;
        li8.Apttus_Config2__AllowableAction__c = 'Unrestricted';
        li8.Apttus_Config2__AllowManualAdjustment__c = TRUE;
        li8.Apttus_Config2__AllowProration__c = FALSE;
        li8.Apttus_Config2__AllowRemoval__c = TRUE;
        li8.Apttus_Config2__AutoRenew__c = FALSE;
        li8.Apttus_Config2__BaseExtendedCost__c = 0;
        li8.Apttus_Config2__BaseExtendedPrice__c = 100;
        li8.Apttus_Config2__BasePrice__c = 100;
        li8.Apttus_Config2__BasePriceMethod__c = 'Per Unit';
        li8.Apttus_Config2__BillingFrequency__c = 'Monthly';
        li8.Apttus_Config2__ChargeType__c = 'Subscription Fee';
        li8.Apttus_Config2__ConfigStatus__c = 'Complete';
        li8.Apttus_Config2__ConstraintCheckStatus__c = 'NA';
        li8.Apttus_Config2__Customizable__c = FALSE;
        li8.Apttus_Config2__DeltaPrice__c = 50;
        li8.Apttus_Config2__DeltaQuantity__c = 1;
        li8.Apttus_Config2__Description__c = 'Westlaw Flex Plan $100/500';
        li8.Apttus_Config2__ExtendedCost__c = 0;
        li8.Apttus_Config2__ExtendedPrice__c = 100;
        li8.Apttus_Config2__Frequency__c = 'Monthly';
        li8.Apttus_Config2__Guidance__c = 'Red';
        li8.Apttus_Config2__HasAttributes__c = FALSE;
        li8.Apttus_Config2__HasBaseProduct__c = FALSE;
        li8.Apttus_Config2__HasDefaults__c = FALSE;
        li8.Apttus_Config2__HasIncentives__c = FALSE;
        li8.Apttus_Config2__HasOptions__c = FALSE;
        li8.Apttus_Config2__HasTieredPrice__c = FALSE;
        li8.Apttus_Config2__HideCopyAction__c = FALSE;
        li8.Apttus_Config2__HideInvoiceDisplay__c = FALSE;
        li8.Apttus_Config2__IsAssetPricing__c = FALSE;
        li8.Apttus_Config2__IsCustomPricing__c = FALSE;
        li8.Apttus_Config2__IsHidden__c = FALSE;
        li8.Apttus_Config2__IsOptionRollupLine__c = FALSE;
        li8.Apttus_Config2__IsPrimaryLine__c = TRUE;
        li8.Apttus_Config2__IsPrimaryRampLine__c = FALSE;
        li8.Apttus_Config2__IsQuantityModifiable__c = FALSE;
        li8.Apttus_Config2__IsReadOnly__c = FALSE;
        li8.Apttus_Config2__IsSellingTermReadOnly__c = FALSE;
        li8.Apttus_Config2__IsUsageTierModifiable__c = FALSE;
        li8.Apttus_Config2__ItemSequence__c = 1;
        li8.Apttus_Config2__LineNumber__c = 1;
        li8.Apttus_Config2__LineSequence__c = 1;
        li8.Apttus_Config2__LineStatus__c = 'New';
        li8.Apttus_Config2__LineType__c = 'Product/Service';
        li8.Apttus_Config2__ListPrice__c = 100;
        li8.Apttus_Config2__NetAdjustmentPercent__c = -50;
        li8.Apttus_Config2__NetPrice__c = 50;
        li8.Apttus_Config2__NetUnitPrice__c = 50;
        li8.Apttus_Config2__OptionSequence__c = 0;
        li8.Apttus_Config2__PriceIncludedInBundle__c = FALSE;
        li8.Apttus_Config2__PriceMethod__c = 'Per Unit';
        li8.Apttus_Config2__PriceType__c = 'Recurring';
        li8.Apttus_Config2__PriceUom__c = 'Each';
        li8.Apttus_Config2__PricingStatus__c = 'Complete';
        li8.Apttus_Config2__PrimaryLineNumber__c = 1;
        li8.Apttus_Config2__ProductVersion__c = 1;
        li8.Apttus_Config2__Quantity__c = 1;
        li8.Apttus_Config2__RollupPriceToBundle__c = TRUE;
        li8.Apttus_Config2__SellingFrequency__c = 'Monthly';
        li8.Apttus_Config2__SellingTerm__c = 1;
        li8.Apttus_Config2__SyncStatus__c = 'Pending';
        li8.Apttus_Config2__Taxable__c = FALSE;
        li8.Apttus_Config2__TaxInclusive__c = FALSE;
        li8.Apttus_Config2__Term__c = 1;
        li8.Apttus_Config2__TotalQuantity__c = 1;
        li8.Apttus_Config2__Uom__c = 'Each';
        li8.Apttus_CQApprov__Approval_Status__c = 'Pending Approval';
        li8.CurrencyIsoCode = 'USD';
        li8.APTS_Product_Family__c = 'WESTLAW';
        li8.APTS_Contract_Term__c = '5 Years';
        li8.APTS_Years_2_Plus_Adjustment__c = '4';
        li8.APTS_Bridge__c='2 Months';
        li8.APTS_Product_Delivery__c='Online/Internet';
        li8.Apttus_Config2__Quantity__c = 1;
        lineItemNew.add(li8);
        
        insert lineItemNew;
        
        Test.startTest();      
       
        li2.Apttus_Config2__LineStatus__c = 'Renewed';
        li2.APTS_Yr_1_Renewal_Adjustment__c= '1';
        li2.Apttus_Config2__NetPrice__c = 50;            
        li2.APTS_Yr_2_Amount__c = 30; 
        li2.APTS_Calculated_Year_3__c= 40;
        li2.APTS_Calculated_Year_4__c =45;
        li2.APTS_Calculated_Year_5__c = 50;
        lstToUpdate.add(li2);
        li3.Apttus_Config2__LineStatus__c = 'Renewed';
        li3.APTS_Yr_1_Renewal_Adjustment__c= '1';
        li3.Apttus_Config2__NetPrice__c = 50;            
        li3.APTS_Yr_2_Amount__c = 30;
        li3.APTS_Yr_3_Amount__c = 10; 
        li3.APTS_Calculated_Year_3__c= 40;
        li3.APTS_Calculated_Year_4__c =45;
        li3.APTS_Calculated_Year_5__c = 50;
        lstToUpdate.add(li3);
        li4.Apttus_Config2__LineStatus__c = 'Renewed';
        li4.APTS_Yr_1_Renewal_Adjustment__c= '1';
        li4.Apttus_Config2__NetPrice__c = 50;            
        lstToUpdate.add(li4);
        li5.Apttus_Config2__LineStatus__c = 'Renewed';
        li5.APTS_Yr_1_Renewal_Adjustment__c= '1';
        li5.Apttus_Config2__NetPrice__c = 50;            
        li5.APTS_Yr_2_Amount__c = 30;
        li5.APTS_Yr_3_Amount__c = 10; 
        li5.APTS_Calculated_Year_3__c= 40;
        li5.APTS_Calculated_Year_4__c =45;
        li5.APTS_Calculated_Year_5__c = 50;
        lstToUpdate.add(li5);
        li6.Apttus_Config2__LineStatus__c = 'Renewed';
        li6.APTS_Yr_1_Renewal_Adjustment__c= '1';
        li6.Apttus_Config2__NetPrice__c = 50;            
        li6.APTS_Yr_2_Amount__c = 30;
        li6.APTS_Yr_3_Amount__c = 10; 
        li6.APTS_Yr_4_Amount__c = 10;
        li6.APTS_Yr_5_Amount__c =10;
        li6.APTS_Calculated_Year_3__c= 40;
        li6.APTS_Calculated_Year_4__c =45;
        li6.APTS_Calculated_Year_5__c = 50;
        lstToUpdate.add(li6);
        li7.Apttus_Config2__LineStatus__c = 'Renewed';
        li7.APTS_Yr_1_Renewal_Adjustment__c= '1';
        li7.Apttus_Config2__NetPrice__c = 50;            
        li7.APTS_Yr_2_Amount__c = 30;
        li7.APTS_Yr_3_Amount__c = 10; 
        li7.APTS_Yr_4_Amount__c =10;
        li7.APTS_Calculated_Year_3__c= 40;
        li7.APTS_Calculated_Year_4__c =45;
        li7.APTS_Calculated_Year_5__c = 50;
        lstToUpdate.add(li7);
        li8.Apttus_Config2__LineStatus__c = 'Renewed';
        li8.APTS_Yr_1_Renewal_Adjustment__c= '1';
        li8.Apttus_Config2__NetPrice__c = 50;            
        li8.APTS_Yr_2_Amount__c = null;
        li8.APTS_Yr_3_Amount__c = null; 
        li8.APTS_Yr_4_Amount__c =null;
        li8.APTS_Yr_5_Amount__c =null;
        li8.APTS_Calculated_Year_3__c= 40;
        li8.APTS_Calculated_Year_4__c =45;
        li8.APTS_Calculated_Year_5__c = 50;
        lstToUpdate.add(li8);
        update lstToUpdate;
        Test.stopTest();        
       
    }
    
    
// This test method tests the calculation of incremental growth
   static testMethod void checkGPPProductBN() {
        
    WebServiceSettings__c oWebServiceSettings = new WebServiceSettings__c(
        Active__c = true,
        Name = 'Payment AutoCharge',
        Service_Unavailable_Message__c = 'Auto Payment Service is Currently unavailable',        
        Endpoint__c = 'https://stg.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentAutoCharge');
    insert oWebServiceSettings ;
    
    WebServiceSettings__c o1WebServiceSettings = new WebServiceSettings__c(
        Active__c = true,
        Name = 'PaymentCreditIncrease',
        Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable',        
        Endpoint__c = 'https://qa.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease');
    insert o1WebServiceSettings ;
    
    Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
    
    Apttus_Config2__PriceList__c priceList = APTS_TestDataFactory.createPriceList('Thomson Reuters Master - US Legal');
    insert priceList;        
    
    Schema.DescribeFieldResult fieldResultMarket = Apttus_Config2__ProductConfiguration__c.APTS_AccountMirror_Picklist__c.getDescribe();
    String valueMarket = fieldResultMarket.getPicklistValues().get(0).getValue();
    
    Account a = new Account(RecordTypeId=accRecordTypeId,FrozenMarketSegment__c = valueMarket,name='test-sg',sales_org__c='ABEP',customer_group__c='Academic',customer_type__c='Organization',customer_class_c__c='Academic Lecturer');
    a.APTS_Customer_Category__c = '';
    a.Is_GLI__c = True;
    insert a;
    
    //Inserting SourceSystemDetail
    Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();
    List<Source_System_Detail__c> ssdList = new List<Source_System_Detail__c>();
    Source_System_Detail__c accountSSD= new Source_System_Detail__c();
    accountSSD.RecordtypeId=ssdRecorType;
    accountSSD.Name='ABC';
    accountSSD.Source_System_Name__c='ABC';
    accountSSD.Account_Name__c=a.ID;
    accountSSD.APTS_Customer_Category__c='1';
    accountSSD.LCRM_Customer_Group__c='Academic';
    accountSSD.LCRM_Frozen_Market_Segment__c = valueMarket;
    accountSSD.Account_Inactive__c=false;
    accountSSD.LCRM_Sales_Org__c='WEST';
    accountSSD.APTS_Has_Online_Assets__c=true;
    ssdList.add(accountSSD);
    
    Source_System_Detail__c accountSSD1= new Source_System_Detail__c();
    accountSSD1.RecordtypeId=ssdRecorType;
    accountSSD1.Name='ABC';
    accountSSD1.Source_System_Name__c='ABC';
    accountSSD1.Account_Name__c=a.ID;
    accountSSD1.APTS_Customer_Category__c='1';
    accountSSD1.LCRM_Customer_Group__c='Academic';
    accountSSD1.LCRM_Frozen_Market_Segment__c = valueMarket;
    accountSSD1.Account_Inactive__c=false;
    accountSSD1.LCRM_Sales_Org__c='CARS';
    accountSSD1.APTS_Has_Online_Assets__c=true;
    ssdList.add(accountSSD1);
    
    insert ssdList;
    
    //Added by Chirag 1/10/18
    /*Apttus_Config2__AssetLineItem__c asset = new Apttus_Config2__AssetLineItem__c(Name = 'Test asset', APTS_Info_PlanType__c = 'S00', 
    Apttus_Config2__NetPrice__c = 10.00, APTS_SSD_Bill_To__c = accountSSD.Id,
    APTS_Info_RenewalDate__c = System.today().addDays(150));
    insert asset; */
    
    Profile prof = [SELECT Id FROM Profile WHERE Name='System Administrator'];   
    
    User u = new User(Alias = 'sattudt', Email='sattu@testorg.com', 
                      EmailEncodingKey='UTF-8', LastName='chan', LanguageLocaleKey='en_US', 
                      LocaleSidKey='en_US', ProfileId = prof.Id,
                      TimeZoneSidKey='America/Los_Angeles', UserName='sattu@testorg.com', Sub_Bu__c = 'LMS');
    insert u; 
    
    //Inserting KeyValueStore
    List<KeyValueListStore__c> keyvaluestoreList = new List<KeyValueListStore__c>();
    KeyValueListStore__c keyvaluestore=new  KeyValueListStore__c();
    keyvaluestore.Name='ANZUsersProfileId';
    keyvaluestore.TextValue__c=System.Label.APTS_OC_Test_Id;
    keyvaluestoreList.add(keyvaluestore); 
    KeyValueListStore__c keyval = new KeyValueListStore__c();
    keyval.Name='ReasonWithCompetitor';
    keyval.TextValue__c='Price';
    keyvaluestoreList.add(keyval);
    insert keyvaluestoreList;
    
    //Inserting recordLists
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
            
    Date todaysDate = system.today();
    Id oppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Pipeline Opportunity').getRecordTypeId();
    Opportunity o = new Opportunity(RecordTypeId=oppRecordTypeId,  Name='tst-opp', stagename='25%',closedate=todaysDate,forecastcategoryname='pipeline',accountId=a.id,Source_System_Detail__c=accountSSD.id);
    insert o;
    
    Id devRecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Proposal').getRecordTypeId();
    
List<Apttus_Proposal__Proposal__c> proposalList = new List<Apttus_Proposal__Proposal__c >();
    
Apttus_Proposal__Proposal__c p1 = new Apttus_Proposal__Proposal__c(RecordTypeId=devRecordTypeId, CurrencyIsoCode = 'USD', Apttus_Proposal__Proposal_Name__c='TST-11', Apttus_Proposal__Opportunity__c=o.id, Apttus_Proposal__Approval_Stage__c='Draft', Apttus_Proposal__Proposal_Category__c='Quote', Apttus_Proposal__ReadyToGenerate__c = true, Apttus_Proposal__ReadyToPresent__c= true,APTS_SSD_Sold_To__c=accountSSD.Id,APTS_SSD_ship_to__c=accountSSD.Id,APTS_SSD_bill_to__c=accountSSD.Id,APTS_Proposal_Business_Unit__c ='SCS');
    proposalList.add(p1);

Apttus_Proposal__Proposal__c p2 = new Apttus_Proposal__Proposal__c(RecordTypeId=devRecordTypeId, CurrencyIsoCode = 'USD', Apttus_Proposal__Proposal_Name__c='TST-12', Apttus_Proposal__Opportunity__c=o.id, Apttus_Proposal__Approval_Stage__c='Draft', Apttus_Proposal__Proposal_Category__c='Quote', Apttus_Proposal__ReadyToGenerate__c = true, Apttus_Proposal__ReadyToPresent__c= true,APTS_SSD_Sold_To__c=accountSSD1.Id,APTS_SSD_ship_to__c=accountSSD1.Id,APTS_SSD_bill_to__c=accountSSD1.Id,APTS_Proposal_Business_Unit__c ='Canada');
    proposalList.add(p2);

    insert proposalList;
       
 
    
    List<Apttus_Config2__ProductConfiguration__c> pconfigList = new List<Apttus_Config2__ProductConfiguration__c >();
    
    Apttus_Config2__ProductConfiguration__c prodConf1 = new Apttus_Config2__ProductConfiguration__c(Name='prod-conf1', CurrencyIsoCode = 'USD', Apttus_QPConfig__Proposald__c=p1.id,APTS_SSD_ship_to__c=accountSSD.Id,APTS_SSD_bill_to__c=accountSSD.Id);
    pconfigList.add(prodConf1);

    Apttus_Config2__ProductConfiguration__c prodConf2 = new Apttus_Config2__ProductConfiguration__c(Name='prod-conf2', CurrencyIsoCode = 'USD', Apttus_QPConfig__Proposald__c=p2.id,APTS_SSD_ship_to__c=accountSSD1.Id,APTS_SSD_bill_to__c=accountSSD1.Id);
    pconfigList.add(prodConf2);

    insert pconfigList;
    System.debug('Config1 PBU'+prodConf1.APTS_Proposal_Business_Unit__c);


    Product2 prod1 = new Product2(name='prod1', Media_High_Level__c='Online', CurrencyIsoCode = 'USD',APTS_Cat_L2__c='L2_L012_FP',/*APTS_Cat_L2__c=System.Label.APTS_Proview_Product_Family,*/Family='CLEAR',APTS_Cat_L3__c='L3_L033_FP',APTS_Media_High_Level_Code__c = '21',APTS_Media_Lower_Level_Code__c= 'F4',APTS_Item_Category_Group__c = 'ZPR2');
    prod1.APTS_Approval_Always_Required__c = true;

    Product2 prod2 = new Product2(name='prod2', Media_High_Level__c='Online', CurrencyIsoCode = 'USD',APTS_Cat_L2__c=System.Label.APTS_Proview_Product_Family,Family='CLEAR',APTS_Cat_L3__c='L3_L033_FP',APTS_Media_High_Level_Code__c = '21',APTS_Media_Lower_Level_Code__c= 'F4',APTS_Item_Category_Group__c = 'ZPR2');
    prod2.APTS_Approval_Always_Required__c = true;
    
    Product2 prod3 = new Product2(name='prod3',ProductCode='509299', Media_High_Level__c='Online', CurrencyIsoCode = 'USD',APTS_Cat_L2__c=System.Label.APTS_Proview_Product_Family,Family='CLEAR',APTS_Cat_L3__c='L3_L033_FP',APTS_Media_High_Level_Code__c = '21',APTS_Media_Lower_Level_Code__c= 'F4',APTS_Item_Category_Group__c = 'ZPR2');
    prod3.APTS_Approval_Always_Required__c = true;

    List<Product2> prdlist = new List<Product2>{prod1,prod2,prod3};
    insert prdlist;
    
    //Apttus_Config2__ConfigSystemProperties__c configSetting = [SELECT Id, Name, Apttus_Config2__DisableConstraintRules__c FROM Apttus_Config2__ConfigSystemProperties__c WHERE Name = 'System Properties'];
    //configSetting.Apttus_Config2__DisableConstraintRules__c = True;
    //update configSetting;
    Apttus_Config2__ConfigSystemProperties__c configSetting=new Apttus_Config2__ConfigSystemProperties__c(Name='System Properties',Apttus_Config2__DisableConstraintRules__c=true);
    insert configSetting;


    List<Apttus_Config2__AssetLineItem__c> assetList = new List<Apttus_Config2__AssetLineItem__c >();
   
    Apttus_Config2__AssetLineItem__c asset1 = new Apttus_Config2__AssetLineItem__c(Name = 'Test asset', APTS_Info_PlanType__c = 'S00', 
                                                                                Apttus_Config2__ProductId__c=prod1.id,   
                                                                                  Apttus_Config2__NetPrice__c = 10.00, APTS_SSD_Bill_To__c = accountSSD.Id,
                                                                                  APTS_SSD_Sold_To__c = accountSSD.Id,
                                                                                  Apttus_Config2__assetstatus__c='Activated',
                                                                                  Apttus_Config2__IsInactive__c =false,
                                                                                  Apttus_QPConfig__ProposalId__c =p1.id,APTS_Proposal_Business_Unit__c = 'SCS',Apttus_Config2__NetUnitPrice__c=100,
                                                                                  APTS_Info_RenewalDate__c = System.today().addDays(-80),Apttus_Config2__BasePriceMethod__c = 'Per Unit');
    assetList.add(asset1);

    
    Apttus_Config2__AssetLineItem__c asset2 = new Apttus_Config2__AssetLineItem__c(Name = 'Test asset', APTS_Info_PlanType__c = 'S00', 
                                                                                Apttus_Config2__ProductId__c=prod2.id,   
                                                                                  Apttus_Config2__NetPrice__c = 10.00, APTS_SSD_Bill_To__c = accountSSD.Id,
                                                                                  APTS_SSD_Sold_To__c = accountSSD.Id,
                                                                                  Apttus_Config2__assetstatus__c='Activated',
                                                                                  Apttus_Config2__IsInactive__c =false,
                                                                                  Apttus_QPConfig__ProposalId__c =p1.id,APTS_Proposal_Business_Unit__c = 'SCS',Apttus_Config2__NetUnitPrice__c=100,
                                                                                  APTS_Info_RenewalDate__c = System.today().addDays(-80),Apttus_Config2__BasePriceMethod__c = 'Per Unit');
    assetList.add(asset2); 

    Apttus_Config2__AssetLineItem__c asset3 = new Apttus_Config2__AssetLineItem__c(Name = 'Test asset', APTS_Info_PlanType__c = 'S00', 
                                                                                Apttus_Config2__ProductId__c=prod3.id,   
                                                                                  Apttus_Config2__NetPrice__c = 10.00, APTS_SSD_Bill_To__c = accountSSD.Id,
                                                                                  APTS_SSD_Sold_To__c = accountSSD.Id,
                                                                                  Apttus_Config2__assetstatus__c='Activated',
                                                                                  Apttus_Config2__IsInactive__c =false,
                                                                                  Apttus_QPConfig__ProposalId__c =p1.id,APTS_Proposal_Business_Unit__c = 'SCS',Apttus_Config2__NetUnitPrice__c=100,
                                                                                  APTS_Info_RenewalDate__c = System.today().addDays(-80),Apttus_Config2__BasePriceMethod__c = 'Per Unit');
    assetList.add(asset3);

    insert assetList;
       

    Apttus_Config2__PriceListItem__c PriceLst=new Apttus_Config2__PriceListItem__c(Apttus_Config2__PriceListId__c=priceList.id, Apttus_Config2__ProductId__c=prod3.id,Apttus_Config2__ListPrice__c=280);

    insert PriceLst;

    
    List<Apttus_Config2__LineItem__c> lineItemNew = new List<Apttus_Config2__LineItem__c >();
    
    
    Apttus_Config2__LineItem__c li3C = new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c=prodConf1.id , Apttus_Config2__ProductId__c=prod1.id);
    li3C.Apttus_Config2__AssetLineItemId__c=asset1.id;
    li3C.Apttus_Config2__AddedBy__c = 'User';
    li3C.Apttus_Config2__AdjustedPrice__c = 50;
    li3C.Apttus_Config2__AdjustmentAmount__c = 50;
    li3C.Apttus_Config2__AdjustmentType__c = '% Discount';
    li3C.Apttus_Config2__AllocateGroupAdjustment__c = TRUE;
    li3C.Apttus_Config2__AllowableAction__c = 'Unrestricted';
    li3C.Apttus_Config2__AllowManualAdjustment__c = TRUE;
    li3C.Apttus_Config2__AllowProration__c = FALSE;
    li3C.Apttus_Config2__AllowRemoval__c = TRUE;
    li3C.Apttus_Config2__AutoRenew__c = FALSE;
    li3C.Apttus_Config2__BaseExtendedCost__c = 0;
    li3C.Apttus_Config2__BaseExtendedPrice__c = 100;
    li3C.Apttus_Config2__BasePrice__c = 100;
    li3C.Apttus_Config2__BasePriceMethod__c = 'Per Unit';
    li3C.Apttus_Config2__BillingFrequency__c = 'Monthly';
    li3C.Apttus_Config2__ChargeType__c = 'Subscription Fee';
    li3C.Apttus_Config2__ConfigStatus__c = 'Complete';
    li3C.Apttus_Config2__ConstraintCheckStatus__c = 'NA';
    li3C.Apttus_Config2__Customizable__c = FALSE;
    li3C.Apttus_Config2__DeltaPrice__c = 50;
    li3C.Apttus_Config2__DeltaQuantity__c = 1;
    li3C.Apttus_Config2__Description__c = 'Westlaw Flex Plan $100/500';
    li3C.Apttus_Config2__ExtendedCost__c = 0;
    li3C.Apttus_Config2__ExtendedPrice__c = 100;
    li3C.Apttus_Config2__Frequency__c = 'Monthly';
    li3C.Apttus_Config2__Guidance__c = 'Red';
    li3C.Apttus_Config2__HasAttributes__c = FALSE;
    li3C.Apttus_Config2__HasBaseProduct__c = FALSE;
    li3C.Apttus_Config2__HasDefaults__c = FALSE;
    li3C.Apttus_Config2__HasIncentives__c = FALSE;
    li3C.Apttus_Config2__HasOptions__c = FALSE;
    li3C.Apttus_Config2__HasTieredPrice__c = FALSE;
    li3C.Apttus_Config2__HideCopyAction__c = FALSE;
    li3C.Apttus_Config2__HideInvoiceDisplay__c = FALSE;
    li3C.Apttus_Config2__IsAssetPricing__c = FALSE;
    li3C.Apttus_Config2__IsCustomPricing__c = FALSE;
    li3C.Apttus_Config2__IsHidden__c = FALSE;
    li3C.Apttus_Config2__IsOptionRollupLine__c = FALSE;
    li3C.Apttus_Config2__IsPrimaryLine__c = TRUE;
    li3C.Apttus_Config2__IsPrimaryRampLine__c = FALSE;
    li3C.Apttus_Config2__IsQuantityModifiable__c = FALSE;
    li3C.Apttus_Config2__IsReadOnly__c = FALSE;
    li3C.Apttus_Config2__IsSellingTermReadOnly__c = FALSE;
    li3C.Apttus_Config2__IsUsageTierModifiable__c = FALSE;
    li3C.Apttus_Config2__ItemSequence__c = 1;
    li3C.Apttus_Config2__LineNumber__c = 1;
    li3C.Apttus_Config2__LineSequence__c = 1;
    li3C.Apttus_Config2__LineStatus__c = 'Cancelled';
    li3C.APTS_Yr_1_Renewal_Adjustment__c ='1';
    li3C.Apttus_Config2__LineType__c = 'Product/Service';
    li3C.Apttus_Config2__ListPrice__c = 100;
    li3C.Apttus_Config2__NetAdjustmentPercent__c = -50;
    li3C.Apttus_Config2__NetPrice__c = 50;
    li3C.Apttus_Config2__NetUnitPrice__c = 50;
    li3C.Apttus_Config2__OptionSequence__c = 0;
    li3C.Apttus_Config2__PriceIncludedInBundle__c = FALSE;
    li3C.Apttus_Config2__PriceMethod__c = 'Per Unit';
    li3C.Apttus_Config2__PriceType__c = 'Recurring';
    li3C.Apttus_Config2__PriceUom__c = 'Each';
    li3C.Apttus_Config2__PricingStatus__c = 'Complete';
    li3C.Apttus_Config2__PrimaryLineNumber__c = 1;
    li3C.Apttus_Config2__ProductVersion__c = 1;
    li3C.Apttus_Config2__Quantity__c = 1;
    li3C.Apttus_Config2__RollupPriceToBundle__c = TRUE;
    li3C.Apttus_Config2__SellingFrequency__c = 'Monthly';
    li3C.Apttus_Config2__SellingTerm__c = 1;
    li3C.Apttus_Config2__SyncStatus__c = 'Pending';
    li3C.Apttus_Config2__Taxable__c = FALSE;
    li3C.Apttus_Config2__TaxInclusive__c = FALSE;
    li3C.Apttus_Config2__Term__c = 1;
    li3C.Apttus_Config2__TotalQuantity__c = 1;
    li3C.Apttus_Config2__Uom__c = 'Each';
    li3C.Apttus_CQApprov__Approval_Status__c = 'Pending Approval';
    li3C.CurrencyIsoCode = 'USD';
    li3C.APTS_Product_Family__c = 'WESTLAW';
    li3C.APTS_Contract_Term__c = '2 Years';
    li3C.APTS_Years_2_Plus_Adjustment__c = '4';
    li3C.APTS_Product_Delivery__c = 'Online/Internet';
    li3C.Apttus_Config2__Quantity__c = 1;
    
    lineItemNew.add(li3C);  
    
    Apttus_Config2__LineItem__c li3 = new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c=prodConf1.id , Apttus_Config2__ProductId__c=prod2.id);
    li3.Apttus_Config2__AssetLineItemId__c=asset2.id;
    li3.Apttus_Config2__AddedBy__c = 'User';
    li3.Apttus_Config2__AdjustedPrice__c = 50;
    li3.Apttus_Config2__AdjustmentAmount__c = 50;
    li3.Apttus_Config2__AdjustmentType__c = '% Discount';
    li3.Apttus_Config2__AllocateGroupAdjustment__c = TRUE;
    li3.Apttus_Config2__AllowableAction__c = 'Unrestricted';
    li3.Apttus_Config2__AllowManualAdjustment__c = TRUE;
    li3.Apttus_Config2__AllowProration__c = FALSE;
    li3.Apttus_Config2__AllowRemoval__c = TRUE;
    li3.Apttus_Config2__AutoRenew__c = FALSE;
    li3.Apttus_Config2__BaseExtendedCost__c = 0;
    li3.Apttus_Config2__BaseExtendedPrice__c = 100;
    li3.Apttus_Config2__BasePrice__c = 100;
    li3.Apttus_Config2__BasePriceMethod__c = 'Per Unit';
    li3.Apttus_Config2__BillingFrequency__c = 'Monthly';
    li3.Apttus_Config2__ChargeType__c = 'Subscription Fee';
    li3.Apttus_Config2__ConfigStatus__c = 'Complete';
    li3.Apttus_Config2__ConstraintCheckStatus__c = 'NA';
    li3.Apttus_Config2__Customizable__c = FALSE;
    li3.Apttus_Config2__DeltaPrice__c = 50;
    li3.Apttus_Config2__DeltaQuantity__c = 1;
    li3.Apttus_Config2__Description__c = 'Westlaw Flex Plan $100/500';
    li3.Apttus_Config2__ExtendedCost__c = 0;
    li3.Apttus_Config2__ExtendedPrice__c = 100;
    li3.Apttus_Config2__Frequency__c = 'Monthly';
    li3.Apttus_Config2__Guidance__c = 'Red';
    li3.Apttus_Config2__HasAttributes__c = FALSE;
    li3.Apttus_Config2__HasBaseProduct__c = FALSE;
    li3.Apttus_Config2__HasDefaults__c = FALSE;
    li3.Apttus_Config2__HasIncentives__c = FALSE;
    li3.Apttus_Config2__HasOptions__c = FALSE;
    li3.Apttus_Config2__HasTieredPrice__c = FALSE;
    li3.Apttus_Config2__HideCopyAction__c = FALSE;
    li3.Apttus_Config2__HideInvoiceDisplay__c = FALSE;
    li3.Apttus_Config2__IsAssetPricing__c = FALSE;
    li3.Apttus_Config2__IsCustomPricing__c = FALSE;
    li3.Apttus_Config2__IsHidden__c = FALSE;
    li3.Apttus_Config2__IsOptionRollupLine__c = FALSE;
    li3.Apttus_Config2__IsPrimaryLine__c = TRUE;
    li3.Apttus_Config2__IsPrimaryRampLine__c = FALSE;
    li3.Apttus_Config2__IsQuantityModifiable__c = FALSE;
    li3.Apttus_Config2__IsReadOnly__c = FALSE;
    li3.Apttus_Config2__IsSellingTermReadOnly__c = FALSE;
    li3.Apttus_Config2__IsUsageTierModifiable__c = FALSE;
    li3.Apttus_Config2__ItemSequence__c = 1;
    li3.Apttus_Config2__LineNumber__c = 1;
    li3.Apttus_Config2__LineSequence__c = 1;
    li3.Apttus_Config2__LineStatus__c = 'Cancelled';
    li3.APTS_Yr_1_Renewal_Adjustment__c ='1';
    li3.Apttus_Config2__LineType__c = 'Product/Service';
    li3.Apttus_Config2__ListPrice__c = 100;
    li3.Apttus_Config2__NetAdjustmentPercent__c = -50;
    li3.Apttus_Config2__NetPrice__c = 50;
    li3.Apttus_Config2__NetUnitPrice__c = 50;
    li3.Apttus_Config2__OptionSequence__c = 0;
    li3.Apttus_Config2__PriceIncludedInBundle__c = FALSE;
    li3.Apttus_Config2__PriceMethod__c = 'Per Unit';
    li3.Apttus_Config2__PriceType__c = 'Recurring';
    li3.Apttus_Config2__PriceUom__c = 'Each';
    li3.Apttus_Config2__PricingStatus__c = 'Complete';
    li3.Apttus_Config2__PrimaryLineNumber__c = 1;
    li3.Apttus_Config2__ProductVersion__c = 1;
    li3.Apttus_Config2__Quantity__c = 1;
    li3.Apttus_Config2__RollupPriceToBundle__c = TRUE;
    li3.Apttus_Config2__SellingFrequency__c = 'Monthly';
    li3.Apttus_Config2__SellingTerm__c = 1;
    li3.Apttus_Config2__SyncStatus__c = 'Pending';
    li3.Apttus_Config2__Taxable__c = FALSE;
    li3.Apttus_Config2__TaxInclusive__c = FALSE;
    li3.Apttus_Config2__Term__c = 1;
    li3.Apttus_Config2__TotalQuantity__c = 1;
    li3.Apttus_Config2__Uom__c = 'Each';
    li3.Apttus_CQApprov__Approval_Status__c = 'Pending Approval';
    li3.CurrencyIsoCode = 'USD';
    li3.APTS_Product_Family__c = 'WESTLAW';
    li3.APTS_Contract_Term__c = '2 Years';
    li3.APTS_Years_2_Plus_Adjustment__c = '4';
    li3.APTS_Product_Delivery__c = 'Online/Internet';
    li3.Apttus_Config2__Quantity__c = 1;
    
    lineItemNew.add(li3);
    
    System.runAs(u){
                   
    insert lineItemNew;
           
    Test.startTest();        
    }
       
    Test.stopTest();        
    configSetting.Apttus_Config2__DisableConstraintRules__c = False;
    update configSetting;     
    APTS_LineItemTriggerHelper.calculateIncrementGrowth(prodConf1.id);
    APTS_LineItemTriggerHelper.calculateIncrementGrowth(prodConf2.id);

    //APTS_LineItemTriggerHelper1.populateAllApprovalRequiredCB(lineItemNew);
    //System.assertEquals(null, prodConf.APTS_Incremental_Growth__c);        
} 

        
}