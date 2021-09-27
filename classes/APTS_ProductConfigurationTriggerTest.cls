@isTest
private class APTS_ProductConfigurationTriggerTest {
    
    @isTest static void testcreateDynamicBundles() {
        
        List<APTS_Segment_Threshold__c> segthrList= new List<APTS_Segment_Threshold__c>();
        //Add Segment threshold
        APTS_Segment_Threshold__c seg1 = new APTS_Segment_Threshold__c();
        seg1.APTS_Approval_Required__c=True;
        seg1.APTS_Segment__c='Small Law';
        seg1.APTS_Customer_Category__c='0';
        seg1.APTS_Term_in_years__c=Integer.ValueOf('2');
        seg1.APTS_Minimum_OY_Increase__c=Integer.ValueOf('5');
        String myNumber = '15.00';
        String myTruncatedNumber = myNumber.subString(0,myNumber.indexOf('.')+3);
        Decimal d = Decimal.valueOf(myTruncatedNumber);
        System.debug(d);
        seg1.APTS_Minimum_Incremental_Growth__c=d;
        segthrList.add(seg1);
        
        APTS_Segment_Threshold__c seg2 = new APTS_Segment_Threshold__c();
        seg2.APTS_Approval_Required__c=True;
        seg2.APTS_Segment__c='Corporate';
        seg2.APTS_Customer_Category__c='0';
        seg2.APTS_Term_in_years__c=Integer.ValueOf('2');
        seg2.APTS_Minimum_OY_Increase__c=Integer.ValueOf('5');
        
        String myNumber2 = '15.00';
        String myTruncatedNumber2 = myNumber2.subString(0,myNumber2.indexOf('.')+3);
        Decimal d2 = Decimal.valueOf(myTruncatedNumber2);
        System.debug(d);
        seg2.APTS_Minimum_Incremental_Growth__c=d2;
        segthrList.add(seg2);
        
        
        APTS_Segment_Threshold__c seg3 = new APTS_Segment_Threshold__c();
        seg3.APTS_Approval_Required__c=True;
        seg3.APTS_Segment__c='Government';
        seg3.APTS_Customer_Category__c='0';
        seg3.APTS_Term_in_years__c=Integer.ValueOf('2');
        seg3.APTS_Minimum_OY_Increase__c=Integer.ValueOf('5');
        String myNumber3 = '15.00';
        String myTruncatedNumber3 = myNumber3.subString(0,myNumber3.indexOf('.')+3);
        Decimal d3 = Decimal.valueOf(myTruncatedNumber3);
        System.debug(d);
        seg3.APTS_Minimum_Incremental_Growth__c=d3;
        segthrList.add(seg3);
        
        APTS_Segment_Threshold__c seg4 = new APTS_Segment_Threshold__c();
        seg4.APTS_Approval_Required__c=True;
        // seg4.APTS_Product_Family__c='CLEAR';
        seg4.APTS_Segment__c='Small Law';
        seg4.APTS_Promo_Minimum_Incremental_Growth__c = 1;
        seg4.APTS_Customer_Category__c='0';
        seg4.APTS_Term_in_years__c=Integer.ValueOf('2');
        seg4.APTS_Minimum_OY_Increase__c=Integer.ValueOf('5');
        // String myNumber = '15.00';
        // String myTruncatedNumber = myNumber.subString(0,myNumber.indexOf('.')+3);
        //Decimal d = Decimal.valueOf(myTruncatedNumber);
        // System.debug(d);
        //seg4.APTS_Minimum_Incremental_Growth__c=d;
        segthrList.add(seg4);
        
        
        APTS_Segment_Threshold__c seg5 = new APTS_Segment_Threshold__c();
        seg5.APTS_Approval_Required__c=True;
        //seg5.APTS_Product_Family__c='Not CLEAR';
        seg5.APTS_Segment__c='Corporate';
        seg5.APTS_Promo_Minimum_Incremental_Growth__c = 1;
        seg5.APTS_Customer_Category__c='0';
        seg5.APTS_Term_in_years__c=Integer.ValueOf('2');
        seg5.APTS_Minimum_OY_Increase__c=Integer.ValueOf('5');
        // String myNumber = '15.00';
        // String myTruncatedNumber = myNumber.subString(0,myNumber.indexOf('.')+3);
        //Decimal d = Decimal.valueOf(myTruncatedNumber);
        // System.debug(d);
        //seg4.APTS_Minimum_Incremental_Growth__c=d;
        segthrList.add(seg5); 
        
        APTS_Segment_Threshold__c seg6 = new APTS_Segment_Threshold__c();
        seg6.APTS_Approval_Required__c=True;
        //seg5.APTS_Product_Family__c='Not CLEAR';
        seg6.APTS_Segment__c='Government';
        seg6.APTS_Promo_Minimum_Incremental_Growth__c = 1;
        seg6.APTS_Customer_Category__c='0';
        seg6.APTS_Term_in_years__c=Integer.ValueOf('2');
        seg6.APTS_Minimum_OY_Increase__c=Integer.ValueOf('5');
        // String myNumber = '15.00';
        // String myTruncatedNumber = myNumber.subString(0,myNumber.indexOf('.')+3);
        //Decimal d = Decimal.valueOf(myTruncatedNumber);
        // System.debug(d);
        //seg4.APTS_Minimum_Incremental_Growth__c=d;
        segthrList.add(seg6); 
        
        APTS_Segment_Threshold__c seg7 = new APTS_Segment_Threshold__c();
        seg7.APTS_Approval_Required__c=True;
        seg7.APTS_Product_Family__c='PRINT LEGAL SOLUTIONS';
        seg7.APTS_Segment__c='Government';
        seg7.APTS_Promo_Minimum_Incremental_Growth__c = 1;
        seg7.APTS_Customer_Category__c='0';
        seg7.APTS_Term_in_years__c=Integer.ValueOf('2');
        seg7.APTS_Minimum_OY_Increase__c=Integer.ValueOf('5');
        // Sring myNumber = '15.00';
        // String myTruncatedNumber = myNumber.subString(0,myNumber.indexOf('.')+3);
        //Decimal d = Decimal.valueOf(myTruncatedNumber);
        // System.debug(d);
        //seg4.APTS_Minimum_Incremental_Growth__c=d;
        segthrList.add(seg7);
        insert segthrList;
        
        Apttus_Config2__PriceList__c priceList = APTS_TestDataFactory.createPriceList('Thomson Reuters Master - US Legal');
        insert priceList;
        
        
        WebServiceSettings__c oWebServiceSettings = new WebServiceSettings__c();
        oWebServiceSettings.Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable'; 
        oWebServiceSettings.Name = 'PaymentCreditIncrease'; 
        oWebServiceSettings.Timeout__c = 120; 
        oWebServiceSettings.Endpoint__c = 'https://dev.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease'; 
        oWebServiceSettings.Active__c = true;
        insert oWebServiceSettings;
        
        //Inserting keyvaluestore
        List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c=System.Label.APTS_OC_Test_Id),
        new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other'),
        new KeyValueListStore__c(Name='LCRMDisableStrikeIronServices',TextValue__c='false')};
        insert keyvaluestore;
        
        //Inserting record list 
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
        
        Account a = APTS_TestDataFactory.createAccount('Test Account');
        insert a;
        
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();
        Source_System_Detail__c accountSSD= new Source_System_Detail__c();
        accountSSD.RecordtypeId=ssdRecorType;
        accountSSD.Name='ABC';
        accountSSD.Source_System_Name__c='ABC';
        accountSSD.Account_Name__c=a.ID;
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
        insert proposal;
        Apttus_Config2__ProductConfiguration__c prodConfig = APTS_TestDataFactory.createProductConfiguration(proposal.Id);
        insert prodConfig;
        
        Apttus_Config2__ProductConfiguration__c prodConfig2 = APTS_TestDataFactory.createProductConfiguration(proposal.Id);
        insert prodConfig2;
        
        Product2 prod3 = new Product2(Name='Sreenu Product Test3', ProductCode = '41055956',APTS_Corporate_Select__c='Primary',APTS_Media_High_Level_Code__c='21', Apttus_Config2__Uom__c = 'Seats',APTS_Product_Pricing_Model__c ='Per Seat');
        //insert prod3;
         Product2 prodprof = new Product2(Name='Sreenu Product Test4', ProductCode = '40666420',APTS_Corporate_Select__c='Primary',APTS_Media_High_Level_Code__c='21', Apttus_Config2__Uom__c = 'Seats',APTS_Product_Pricing_Model__c ='Per Seat');
       // insert prod3;
        Product2 prod4 = new Product2(Name='Sreenu Product Test5', ProductCode = '42521805',APTS_Corporate_Select__c='Primary',APTS_Media_High_Level_Code__c='21', Apttus_Config2__Uom__c = 'Seats',APTS_Product_Pricing_Model__c ='Per Seat');
        insert prod3;
        insert prod4;
        insert prodprof ;
        List<Apttus_Config2__LineItem__c> listOfLineItems = New List<Apttus_Config2__LineItem__c>();
        List<Apttus_Config2__ProductAttributeValue__c> listofPAVs = new List<Apttus_Config2__ProductAttributeValue__c>(); 
         Apttus_Config2__AssetLineItem__c asset1 = new Apttus_Config2__AssetLineItem__c(Name = 'Test asset', APTS_Info_PlanType__c = 'S00', APTS_SAP_MLA_Agreement_Number__c='3424343',
                                                                                    Apttus_Config2__ProductId__c=prodprof.id,   
                                                                                      Apttus_Config2__NetPrice__c = 10.00, APTS_SSD_Bill_To__c = accountSSD.Id,
                                                                                      APTS_SSD_Sold_To__c = accountSSD.Id,
                                                                                      Apttus_Config2__assetstatus__c='Activated',
                                                                                      Apttus_Config2__IsInactive__c =false,
                                                                                      Apttus_QPConfig__ProposalId__c =proposal.id,APTS_Proposal_Business_Unit__c = 'SCS',Apttus_Config2__NetUnitPrice__c=100,
                                                                                      APTS_Info_RenewalDate__c = System.today().addDays(-80),Apttus_Config2__BasePriceMethod__c = 'Per Unit');
        
        APTS_Group__c proposalGroup =new APTS_Group__c();
        proposalGroup.APTS_GrossAmount__c = 0;
        proposalGroup.APTS_Group_Name_Original__c ='Online/Software Bundle A';
        proposalGroup.APTS_Group_Name__c ='Online/Software Bundle A';
        proposalGroup.APTS_NetAmount__c=0;
        proposalGroup.APTS_Existing_Agreement_Product_Code__c='Not null';
        insert proposalGroup;
        
        Apttus_Config2__SummaryGroup__c summaryGroup1 = new Apttus_Config2__SummaryGroup__c(
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Name = 'WEST PROFLEX Bundle A - Test group',
            Apttus_Config2__LineType__c = 'Group Total',
            Apttus_Config2__ItemSequence__c = 1,
            Apttus_Config2__LineNumber__c = 1
        );
        insert summaryGroup1;
                test.startTest();
        Apttus_Config2__LineItem__c li3 = new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c=prodConfig.id , Apttus_Config2__ProductId__c=prodprof.id);
        li3.Apttus_Config2__AssetLineItemId__c=asset1.id; 
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
        li3.CurrencyIsoCode = 'USD';
        li3.APTS_Product_Family__c = 'WESTLAW';
        li3.APTS_Contract_Term__c = '2 Years';
        li3.APTS_Years_2_Plus_Adjustment__c = '4';
        li3.APTS_Product_Delivery__c = 'Online/Internet';
        li3.Apttus_Config2__Quantity__c = 1;
        li3.Apttus_Config2__SummaryGroupId__c = summaryGroup1.id;
            li3.APTS_Proposal_Group__c = proposalGroup.Id;
            li3.APTS_Group__c = proposalGroup.APTS_Group_Name__c;
            
        listOfLineItems.add(li3);
       
        Apttus_Config2__LineItem__c li4 = new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c=prodConfig.id , Apttus_Config2__ProductId__c=prodprof.id);
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
        li4.CurrencyIsoCode = 'USD';
        li4.APTS_Product_Family__c = 'WESTLAW';
        li4.APTS_Contract_Term__c = '2 Years';
        li4.APTS_Years_2_Plus_Adjustment__c = '4';
        li4.APTS_Product_Delivery__c = 'Online/Internet';
        li4.Apttus_Config2__Quantity__c = 1;
        //li4.APTS_Bundle__c='West Proflex Bundle A';
        li4.APTS_is_Primary_in_Bundle__c=true;
            li4.Apttus_Config2__SummaryGroupId__c = summaryGroup1.id;
            li4.APTS_Proposal_Group__c = proposalGroup.Id;
            li4.APTS_Group__c = proposalGroup.APTS_Group_Name__c;
            li4.APTS_Bridge__c='7 Months';
            li4.APTS_Keep_Terms__c=true;
            li4.APTS_MLA__c=true;
            li4.APTS_Group_Primary_Material__c='40666420';
        listOfLineItems.add(li4);
        Apttus_Config2__LineItem__c li5 = new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c=prodConfig.id , Apttus_Config2__ProductId__c=prod3.id);
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
        li5.APTS_Yr_1_Renewal_Adjustment__c ='1';
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
        li5.CurrencyIsoCode = 'USD';
        li5.APTS_Product_Family__c = 'WESTLAW';
        li5.APTS_Contract_Term__c = '2 Years';
        li5.APTS_Years_2_Plus_Adjustment__c = '4';
        li5.APTS_Product_Delivery__c = 'Online/Internet';
        li5.Apttus_Config2__Quantity__c = 1;
        li5.APTS_Bridge__c='7 Months';
            li5.Apttus_Config2__SummaryGroupId__c = summaryGroup1.id;
            li5.APTS_Proposal_Group__c = proposalGroup.Id;
            li5.APTS_Group__c = proposalGroup.APTS_Group_Name__c;
            
        listOfLineItems.add(li5);
        Apttus_Config2__LineItem__c linObj1 = new Apttus_Config2__LineItem__c(
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Product/Service',
            Apttus_Config2__LineNumber__c = 1, 
            
            Apttus_Config2__LineStatus__c = 'New',
            // APTS_Media_High_Level_Code__c = '07',
            //APTS_Media_High_Level_Code__c = '21',
            Apttus_Config2__ItemSequence__c = 1,
            Apttus_Config2__ProductId__c=prod3.id,            
            Apttus_Config2__IncentiveCode__c = '02',
            APTS_Bridge__c = '1 Month',
            Apttus_Config2__BasePrice__c=10.0,
            Apttus_Config2__BaseExtendedPrice__c = 10.0,
            Apttus_Config2__AdjustedPrice__c = 10.0,
            Apttus_Config2__OptionPrice__c = 5.0,
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring',
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            APTS_Contract_Term__c='3 Months',
            //APTS_Group__c='Bundle B',
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Deal_Number__c = 1234,
            Apttus_Config2__SummaryGroupId__c = summaryGroup1.id,
            APTS_Proposal_Group__c = proposalGroup.Id,
            APTS_Group__c ='',
            Apttus_Config2__NetPrice__c=1); 
        //listOfLineItems.add(linObj1);
        
        Apttus_Config2__LineItem__c linObj2 = new Apttus_Config2__LineItem__c(
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Product/Service',
            Apttus_Config2__LineNumber__c = 1, 
            Apttus_Config2__LineStatus__c = 'Amended',
            // APTS_Media_High_Level_Code__c = '07',
            //APTS_Media_High_Level_Code__c = '21',
            Apttus_Config2__ItemSequence__c = 1,
            Apttus_Config2__ProductId__c=prod3.id,            
            Apttus_Config2__IncentiveCode__c = '02',
            APTS_Bridge__c = '1 Month',
            Apttus_Config2__BasePrice__c=10.0,
            Apttus_Config2__BaseExtendedPrice__c = 10.0,
            Apttus_Config2__AdjustedPrice__c = 10.0,
            Apttus_Config2__OptionPrice__c = 5.0,
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring',
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            APTS_Contract_Term__c='3 Months',
            //APTS_Group__c='Bundle B',
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Deal_Number__c = 1234,
            Apttus_Config2__SummaryGroupId__c = summaryGroup1.id,
            APTS_Proposal_Group__c = proposalGroup.Id,
            APTS_Group__c =proposalGroup.APTS_Group_Name__c,
            Apttus_Config2__NetPrice__c=1); 
        //listOfLineItems.add(linObj2);
        
        Apttus_Config2__LineItem__c linObj3 = new Apttus_Config2__LineItem__c(
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Product/Service',
            Apttus_Config2__LineNumber__c = 1, 
            Apttus_Config2__LineStatus__c = 'Amended',
            // APTS_Media_High_Level_Code__c = '07',
            //APTS_Media_High_Level_Code__c = '21',
            Apttus_Config2__ItemSequence__c = 1,
            Apttus_Config2__ProductId__c=prod3.id,            
            Apttus_Config2__IncentiveCode__c = '02',
            APTS_Bridge__c = '1 Month',
            Apttus_Config2__BasePrice__c=10.0,
            Apttus_Config2__BaseExtendedPrice__c = 10.0,
            Apttus_Config2__AdjustedPrice__c = 10.0,
            Apttus_Config2__OptionPrice__c = 5.0,
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring',
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            APTS_Contract_Term__c='3 Months',
            //APTS_Group__c='Bundle B',
            Apttus_Config2__PriceAdjustment__c=0,APTS_Deal_Number__c = 1234,
            Apttus_Config2__SummaryGroupId__c = summaryGroup1.id,
            APTS_Proposal_Group__c = proposalGroup.Id,
            APTS_Group__c ='',
            Apttus_Config2__NetPrice__c=1); 
        //listOfLineItems.add(linObj3);
        
        Apttus_Config2__LineItem__c linObj4 = new Apttus_Config2__LineItem__c(
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Product/Service',
            Apttus_Config2__LineNumber__c = 1, 
            Apttus_Config2__LineStatus__c = 'Amended',
            // APTS_Media_High_Level_Code__c = '07',
            //APTS_Media_High_Level_Code__c = '21',
            Apttus_Config2__ItemSequence__c = 1,
            Apttus_Config2__ProductId__c=prod3.id,            
            Apttus_Config2__IncentiveCode__c = '02',
            APTS_Bridge__c = '1 Month',
            Apttus_Config2__BasePrice__c=10.0,
            Apttus_Config2__BaseExtendedPrice__c = 10.0,
            Apttus_Config2__AdjustedPrice__c = 10.0,
            Apttus_Config2__OptionPrice__c = 5.0,
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring',
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            APTS_Contract_Term__c='3 Months',
            //APTS_Group__c='Bundle B',
            Apttus_Config2__PriceAdjustment__c=0,APTS_Deal_Number__c = 1234,
            Apttus_Config2__SummaryGroupId__c = summaryGroup1.id,
            APTS_Proposal_Group__c = proposalGroup.Id,
            APTS_Group__c ='kkr',
            Apttus_Config2__NetPrice__c=1); 
        //listOfLineItems.add(linObj4);
        
        Apttus_Config2__LineItem__c linObj5 = new Apttus_Config2__LineItem__c(
            Apttus_Config2__Quantity__c=1,
            APTS_Contract_Term__c = 'Short Term Trial',
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Product/Service',
            Apttus_Config2__LineNumber__c = 1, 
            Apttus_Config2__LineStatus__c = 'New',
            // APTS_Media_High_Level_Code__c = '07',
            //APTS_Media_High_Level_Code__c = '21',
            Apttus_Config2__ItemSequence__c = 1,
            Apttus_Config2__ProductId__c=prod3.id,            
            APTS_Bridge__c = '1 Month',
            Apttus_Config2__BasePrice__c=10.0,
            Apttus_Config2__BaseExtendedPrice__c = 10.0,
            Apttus_Config2__AdjustedPrice__c = 10.0,
            Apttus_Config2__OptionPrice__c = 5.0,
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring',
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
           Apttus_Config2__PriceAdjustment__c=0,APTS_Deal_Number__c = 1234,
            Apttus_Config2__SummaryGroupId__c = summaryGroup1.id,
            APTS_Proposal_Group__c = proposalGroup.Id,
            APTS_Group__c ='kkr',
            Apttus_Config2__NetPrice__c=1); 
        //listOfLineItems.add(linObj5);
        
        Apttus_Config2__LineItem__c linObj6 = new Apttus_Config2__LineItem__c(
            Apttus_Config2__Quantity__c=1,
            APTS_Contract_Term__c = 'Short Term Trial',
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Product/Service',
            Apttus_Config2__LineNumber__c = 1, 
            Apttus_Config2__LineStatus__c = 'Cancelled',
            // APTS_Media_High_Level_Code__c = '07',
            //APTS_Media_High_Level_Code__c = '21',
            Apttus_Config2__ItemSequence__c = 1,
            Apttus_Config2__ProductId__c=prod3.id,            
           // Apttus_Config2__IncentiveCode__c = '02',
            APTS_Bridge__c = '1 Month',
            Apttus_Config2__BasePrice__c=10.0,
            Apttus_Config2__BaseExtendedPrice__c = 10.0,
            Apttus_Config2__AdjustedPrice__c = 10.0,
            Apttus_Config2__OptionPrice__c = 5.0,
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring',
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            //APTS_Contract_Term__c='3 Months',
            //APTS_Group__c='Bundle B',
            Apttus_Config2__PriceAdjustment__c=0,APTS_Deal_Number__c = 1234,
            Apttus_Config2__SummaryGroupId__c = summaryGroup1.id,
            APTS_Proposal_Group__c = proposalGroup.Id,
            APTS_Group__c ='kkr',
            Apttus_Config2__NetPrice__c=1); 
        //listOfLineItems.add(linObj6);
        
        Apttus_Config2__LineItem__c linObj7 = new Apttus_Config2__LineItem__c(
            Apttus_Config2__Quantity__c=1,
            APTS_Contract_Term__c = 'Short Term Trial',
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Product/Service',
            Apttus_Config2__LineNumber__c = 1, 
            Apttus_Config2__LineStatus__c = 'Cancelled',
            // APTS_Media_High_Level_Code__c = '07',
            //APTS_Media_High_Level_Code__c = '21',
            Apttus_Config2__ItemSequence__c = 1,
            Apttus_Config2__ProductId__c=prod3.id,            
            //Apttus_Config2__IncentiveCode__c = '02',
            APTS_Bridge__c = '1 Month',
            Apttus_Config2__BasePrice__c=10.0,
            Apttus_Config2__BaseExtendedPrice__c = 10.0,
            Apttus_Config2__AdjustedPrice__c = 10.0,
            Apttus_Config2__OptionPrice__c = 5.0,
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring',
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            //APTS_Contract_Term__c='3 Months',
            //APTS_Group__c='Bundle B',
            Apttus_Config2__PriceAdjustment__c=0,APTS_Deal_Number__c = 1234,
            Apttus_Config2__SummaryGroupId__c = summaryGroup1.id,
            APTS_Proposal_Group__c = proposalGroup.Id,
            APTS_Group__c ='kkr',
            Apttus_Config2__IncentiveCode__c='not null',
            Apttus_Config2__NetPrice__c=1); 
        //listOfLineItems.add(linObj7);
        
        Apttus_Config2__LineItem__c linObj8 = new Apttus_Config2__LineItem__c(
            Apttus_Config2__Quantity__c=1,
            APTS_Contract_Term__c = 'Short Term Trial',
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Product/Service',
            Apttus_Config2__LineNumber__c = 1, 
            // APTS_Bridge_Length__c = 1 ,
            // APTS_Contract_Term__c = 'Not Short Term Trial',
            Apttus_Config2__LineStatus__c = 'Cancelled',
            // APTS_Media_High_Level_Code__c = '07',
            //APTS_Media_High_Level_Code__c = '21',
            // APTS_Program_ID__c = 'WCMP',
            APTS_Group_Primary_Material__c= '40666420',
           Apttus_Config2__ItemSequence__c = 1,
            Apttus_Config2__ProductId__c=prod3.id,            
            //Apttus_Config2__IncentiveCode__c = '02',
            APTS_Bridge__c = '1 Month',
                APTS_Group_Primary_Material_Name__c ='Test',
            Apttus_Config2__BasePrice__c=10.0,
            Apttus_Config2__BaseExtendedPrice__c = 10.0,
            Apttus_Config2__AdjustedPrice__c = 10.0,
            Apttus_Config2__OptionPrice__c = 5.0,
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring',
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            //APTS_Contract_Term__c='3 Months',
            //APTS_Group__c='Bundle B',
            Apttus_Config2__PriceAdjustment__c=0,// APTS_Bridge_Length__c =1,
            APTS_Deal_Number__c = 1234,
            Apttus_Config2__SummaryGroupId__c = summaryGroup1.id,
            APTS_Proposal_Group__c = proposalGroup.Id,
            APTS_Group__c ='kkr',
            Apttus_Config2__IncentiveCode__c='not null',
            APTS_Keep_Terms__c = false,
            Apttus_Config2__NetPrice__c=1);
            
        //listOfLineItems.add(linObj8);
        
        List<APTS_Group__c> grouplist= new List<APTS_Group__c>();
        
        APTS_Group__c proposalGroup1 =new APTS_Group__c();
        proposalGroup1.APTS_GrossAmount__c = 0;
        proposalGroup1.APTS_Group_Name_Original__c ='Online/Software Bundle A';
        proposalGroup1.APTS_Group_Name__c ='Online/Software Bundle';
        proposalGroup1.APTS_NetAmount__c=0;
        proposalGroup1.APTS_Existing_Agreement_Product_Code__c ='58';
        proposalGroup1.APTS_ProductConfiguration__c=prodConfig.id;
        grouplist.add(proposalGroup1);
        
        Apttus_Config2__LineItem__c linObj9 = new Apttus_Config2__LineItem__c(
            Apttus_Config2__Quantity__c=1,
            APTS_Contract_Term__c = 'Short Term Trial',
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Product/Service',
            Apttus_Config2__LineNumber__c = 1, 
            // APTS_Bridge_Length__c = 1 ,
            // APTS_Contract_Term__c = 'Not Short Term Trial',
            Apttus_Config2__LineStatus__c = 'Cancelled',
            // APTS_Media_High_Level_Code__c = '07',
            //APTS_Media_High_Level_Code__c = '21',
            // APTS_Program_ID__c = 'WCMP',
            APTS_Group_Primary_Material__c= '40666420',
            Apttus_Config2__ItemSequence__c = 1,
            APTS_Deal_Number__c = 1234,
            Apttus_Config2__SummaryGroupId__c = summaryGroup1.id,
            APTS_Proposal_Group__c = grouplist[0].id,
            APTS_Group__c ='kkr',
            Apttus_Config2__IncentiveCode__c='not null',
            Apttus_Config2__NetPrice__c=1); 
       // listOfLineItems.add(linObj9);
        
        Apttus_Config2__LineItem__c linObj10 = new Apttus_Config2__LineItem__c(
            Apttus_Config2__Quantity__c=1,
            APTS_Contract_Term__c = 'Short Term Trial',
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Product/Service',
            Apttus_Config2__LineNumber__c = 1, 
            // APTS_Bridge_Length__c = 1 ,
            // APTS_Contract_Term__c = 'Not Short Term Trial',
            Apttus_Config2__LineStatus__c = 'Cancelled',
            // APTS_Media_High_Level_Code__c = '07',
            //APTS_Media_High_Level_Code__c = '21',
            // APTS_Program_ID__c = 'WCMP',
            APTS_Group_Primary_Material__c= '40666420',
            Apttus_Config2__ItemSequence__c = 1,
            APTS_Deal_Number__c = 1234,
            Apttus_Config2__SummaryGroupId__c = summaryGroup1.id,
            APTS_Proposal_Group__c = grouplist[0].id,
            APTS_Group__c ='kkr',
            Apttus_Config2__IncentiveCode__c='not null',
            Apttus_Config2__NetPrice__c=1); 
        //listOfLineItems.add(linObj10);
        
        Apttus_Config2__SummaryGroup__c summaryGroup2 = new Apttus_Config2__SummaryGroup__c(
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Name = 'WEST PROFLEX Bundle A - Test group 2',
            Apttus_Config2__LineType__c = 'Group Total',
            Apttus_Config2__ItemSequence__c = 2,
            Apttus_Config2__LineNumber__c = 1
        );
        insert summaryGroup2;
        
        Apttus_Config2__LineItem__c linObj11 = new Apttus_Config2__LineItem__c(
            Apttus_Config2__Quantity__c=1,
            APTS_Deal_Type__c='WCMP',
            APTS_Contract_Term__c = 'Short Term Trial',
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Product/Service',
            Apttus_Config2__LineNumber__c = 1, 
            // APTS_Bridge_Length__c = 1 ,
            // APTS_Contract_Term__c = 'Not Short Term Trial',
            Apttus_Config2__LineStatus__c = 'Amended',
            // APTS_Media_High_Level_Code__c = '07',
            //APTS_Media_High_Level_Code__c = '21',
            // APTS_Program_ID__c = 'WCMP',
            APTS_Group_Primary_Material__c= '40666420',
            Apttus_Config2__ItemSequence__c = 1,
            APTS_Deal_Number__c = 1234,
            Apttus_Config2__SummaryGroupId__c = summaryGroup2.id,
            APTS_Proposal_Group__c = grouplist[0].id,
            APTS_Group__c ='kkr',
            Apttus_Config2__IncentiveCode__c='not null',
            Apttus_Config2__NetPrice__c=1); 
        //listOfLineItems.add(linObj11);
        
        
        
        insert grouplist;
        insert listOfLineItems;
        
        //changed old account soldto to new soldto ssd
        List<Apttus_Config2__LineItem__c> lineItemsList = [SELECT Id, Name, Apttus_Config2__ProductId__c, Apttus_Config2__ConfigurationId__c, Apttus_Config2__ConfigurationId__r.APTS_SSD_Sold_To__c, Apttus_Config2__LineNumber__c,
                                                           Apttus_Config2__ItemSequence__c, Apttus_Config2__LineType__c, Apttus_Config2__LineStatus__c 
                                                           FROM Apttus_Config2__LineItem__c 
                                                           WHERE Apttus_Config2__ConfigurationId__c = :prodConfig.id];      
        
        System.assert(lineItemsList!= null && lineItemsList.size()>0);      
        
        
        //APTS_ProductConfigurationTriggerHandler.afterUpdate = false;
        prodConfig.Apttus_Config2__Status__c = 'New';
        prodConfig.APTS_Least_Contract_Term__c=2;
        //prodConfig.APTS_Customer_Category__c='Not null';
        update prodConfig;
        
        APTS_ProductConfigurationTriggerHandler.afterUpdate = false;
        checkRecursive.afterUpdate = True;
        prodConfig.Apttus_Config2__Status__c = 'Finalized';
        prodConfig.Apttus_Config2__FinalizedDate__c=system.today();
        update prodConfig;
        
        prodConfig.Apttus_Config2__FinalizedDate__c= datetime.newInstance(2020, 9, 15, 12, 30, 0);
        update prodConfig;
        // prodConfig2.APTS_Incremental_Growth_violated__c= 'Approval';
        //  prodConfig2.APTS_Incremental_Growth_Formula__c=1;
        // prodConfig2.APTS_Attorney_Count_Reduced__c = TRUE;
        update prodConfig2;
        
        list<APTS_Dynamic_Bundle__c> pplList = [SELECT Id,APTS_Keep_Terms__c FROM APTS_Dynamic_Bundle__c WHERE APTS_Quote_Proposal__c = :proposal.Id ];
        //System.assert(pplList!= null && pplList.size()>0);
        for(integer i=0;i<pplList.size();i++)
        {
            pplList[i].APTS_Keep_Terms__c= TRUE;
        }
        update pplList;
        
        
        
        
        update pplList;
        
        test.stopTest();
        
        
        //update prodConfig;
        
    }
    
        @isTest static void testcreateDynamicBundlesTK() {
        
        List<APTS_Segment_Threshold__c> segthrList= new List<APTS_Segment_Threshold__c>();
        //Add Segment threshold
        APTS_Segment_Threshold__c seg1 = new APTS_Segment_Threshold__c();
        seg1.APTS_Approval_Required__c=True;
        seg1.APTS_Segment__c='Small Law';
        seg1.APTS_Customer_Category__c='0';
        seg1.APTS_Term_in_years__c=Integer.ValueOf('2');
        seg1.APTS_Minimum_OY_Increase__c=Integer.ValueOf('5');
        String myNumber = '15.00';
        String myTruncatedNumber = myNumber.subString(0,myNumber.indexOf('.')+3);
        Decimal d = Decimal.valueOf(myTruncatedNumber);
        System.debug(d);
        seg1.APTS_Minimum_Incremental_Growth__c=d;
        segthrList.add(seg1);
        
        APTS_Segment_Threshold__c seg2 = new APTS_Segment_Threshold__c();
        seg2.APTS_Approval_Required__c=True;
        seg2.APTS_Segment__c='Corporate';
        seg2.APTS_Customer_Category__c='0';
        seg2.APTS_Term_in_years__c=Integer.ValueOf('2');
        seg2.APTS_Minimum_OY_Increase__c=Integer.ValueOf('5');
        
        String myNumber2 = '15.00';
        String myTruncatedNumber2 = myNumber2.subString(0,myNumber2.indexOf('.')+3);
        Decimal d2 = Decimal.valueOf(myTruncatedNumber2);
        System.debug(d);
        seg2.APTS_Minimum_Incremental_Growth__c=d2;
        segthrList.add(seg2);
        
        
        APTS_Segment_Threshold__c seg3 = new APTS_Segment_Threshold__c();
        seg3.APTS_Approval_Required__c=True;
        seg3.APTS_Segment__c='Government';
        seg3.APTS_Customer_Category__c='0';
        seg3.APTS_Term_in_years__c=Integer.ValueOf('2');
        seg3.APTS_Minimum_OY_Increase__c=Integer.ValueOf('5');
        String myNumber3 = '15.00';
        String myTruncatedNumber3 = myNumber3.subString(0,myNumber3.indexOf('.')+3);
        Decimal d3 = Decimal.valueOf(myTruncatedNumber3);
        System.debug(d);
        seg3.APTS_Minimum_Incremental_Growth__c=d3;
        segthrList.add(seg3);
        
        APTS_Segment_Threshold__c seg4 = new APTS_Segment_Threshold__c();
        seg4.APTS_Approval_Required__c=True;
        // seg4.APTS_Product_Family__c='CLEAR';
        seg4.APTS_Segment__c='Small Law';
        seg4.APTS_Promo_Minimum_Incremental_Growth__c = 1;
        seg4.APTS_Customer_Category__c='0';
        seg4.APTS_Term_in_years__c=Integer.ValueOf('2');
        seg4.APTS_Minimum_OY_Increase__c=Integer.ValueOf('5');
        // String myNumber = '15.00';
        // String myTruncatedNumber = myNumber.subString(0,myNumber.indexOf('.')+3);
        //Decimal d = Decimal.valueOf(myTruncatedNumber);
        // System.debug(d);
        //seg4.APTS_Minimum_Incremental_Growth__c=d;
        segthrList.add(seg4);
        
        
        APTS_Segment_Threshold__c seg5 = new APTS_Segment_Threshold__c();
        seg5.APTS_Approval_Required__c=True;
        //seg5.APTS_Product_Family__c='Not CLEAR';
        seg5.APTS_Segment__c='Corporate';
        seg5.APTS_Promo_Minimum_Incremental_Growth__c = 1;
        seg5.APTS_Customer_Category__c='0';
        seg5.APTS_Term_in_years__c=Integer.ValueOf('2');
        seg5.APTS_Minimum_OY_Increase__c=Integer.ValueOf('5');
        // String myNumber = '15.00';
        // String myTruncatedNumber = myNumber.subString(0,myNumber.indexOf('.')+3);
        //Decimal d = Decimal.valueOf(myTruncatedNumber);
        // System.debug(d);
        //seg4.APTS_Minimum_Incremental_Growth__c=d;
        segthrList.add(seg5); 
        
        APTS_Segment_Threshold__c seg6 = new APTS_Segment_Threshold__c();
        seg6.APTS_Approval_Required__c=True;
        //seg5.APTS_Product_Family__c='Not CLEAR';
        seg6.APTS_Segment__c='Government';
        seg6.APTS_Promo_Minimum_Incremental_Growth__c = 1;
        seg6.APTS_Customer_Category__c='0';
        seg6.APTS_Term_in_years__c=Integer.ValueOf('2');
        seg6.APTS_Minimum_OY_Increase__c=Integer.ValueOf('5');
        // String myNumber = '15.00';
        // String myTruncatedNumber = myNumber.subString(0,myNumber.indexOf('.')+3);
        //Decimal d = Decimal.valueOf(myTruncatedNumber);
        // System.debug(d);
        //seg4.APTS_Minimum_Incremental_Growth__c=d;
        segthrList.add(seg6); 
        
        APTS_Segment_Threshold__c seg7 = new APTS_Segment_Threshold__c();
        seg7.APTS_Approval_Required__c=True;
        seg7.APTS_Product_Family__c='PRINT LEGAL SOLUTIONS';
        seg7.APTS_Segment__c='Government';
        seg7.APTS_Promo_Minimum_Incremental_Growth__c = 1;
        seg7.APTS_Customer_Category__c='0';
        seg7.APTS_Term_in_years__c=Integer.ValueOf('2');
        seg7.APTS_Minimum_OY_Increase__c=Integer.ValueOf('5');
        // Sring myNumber = '15.00';
        // String myTruncatedNumber = myNumber.subString(0,myNumber.indexOf('.')+3);
        //Decimal d = Decimal.valueOf(myTruncatedNumber);
        // System.debug(d);
        //seg4.APTS_Minimum_Incremental_Growth__c=d;
        segthrList.add(seg7);
        insert segthrList;
        
        Apttus_Config2__PriceList__c priceList = APTS_TestDataFactory.createPriceList('Thomson Reuters Master - US Legal');
        insert priceList;
        
        
        WebServiceSettings__c oWebServiceSettings = new WebServiceSettings__c();
        oWebServiceSettings.Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable'; 
        oWebServiceSettings.Name = 'PaymentCreditIncrease'; 
        oWebServiceSettings.Timeout__c = 120; 
        oWebServiceSettings.Endpoint__c = 'https://dev.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease'; 
        oWebServiceSettings.Active__c = true;
        insert oWebServiceSettings;
        
        //Inserting keyvaluestore
        List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c=System.Label.APTS_OC_Test_Id),
        new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other'),
        new KeyValueListStore__c(Name='LCRMDisableStrikeIronServices',TextValue__c='false')};
        insert keyvaluestore;
        
        //Inserting record list 
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
        
        Account a = APTS_TestDataFactory.createAccount('Test Account');
        insert a;
        
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();
        Source_System_Detail__c accountSSD= new Source_System_Detail__c();
        accountSSD.RecordtypeId=ssdRecorType;
        accountSSD.Name='ABC';
        accountSSD.Source_System_Name__c='ABC';
        accountSSD.Account_Name__c=a.ID;
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
        insert proposal;
        Apttus_Config2__ProductConfiguration__c prodConfig = APTS_TestDataFactory.createProductConfiguration(proposal.Id);
        insert prodConfig;
        
        Apttus_Config2__ProductConfiguration__c prodConfig2 = APTS_TestDataFactory.createProductConfiguration(proposal.Id);
        insert prodConfig2;
        
        Product2 prod3 = new Product2(Name='Sreenu Product Test3', ProductCode = '41055956',APTS_Corporate_Select__c='Primary',APTS_Media_High_Level_Code__c='21', Apttus_Config2__Uom__c = 'Seats',APTS_Product_Pricing_Model__c ='Per Seat');
        //insert prod3;
         Product2 prodprof = new Product2(Name='Sreenu Product Test4', ProductCode = '40666420',APTS_Corporate_Select__c='Primary',APTS_Media_High_Level_Code__c='21', Apttus_Config2__Uom__c = 'Seats',APTS_Product_Pricing_Model__c ='Per Seat');
       // insert prod3;
        Product2 prod4 = new Product2(Name='Sreenu Product Test5', ProductCode = '42521805',APTS_Corporate_Select__c='Primary',APTS_Media_High_Level_Code__c='21', Apttus_Config2__Uom__c = 'Seats',APTS_Product_Pricing_Model__c ='Per Seat');
        insert prod3;
        insert prod4;
        insert prodprof ;
        List<Apttus_Config2__LineItem__c> listOfLineItems = New List<Apttus_Config2__LineItem__c>();
        List<Apttus_Config2__ProductAttributeValue__c> listofPAVs = new List<Apttus_Config2__ProductAttributeValue__c>(); 
         Apttus_Config2__AssetLineItem__c asset1 = new Apttus_Config2__AssetLineItem__c(Name = 'Test asset', APTS_Info_PlanType__c = 'S00', APTS_SAP_MLA_Agreement_Number__c='3424343',
                                                                                    Apttus_Config2__ProductId__c=prodprof.id,   
                                                                                      Apttus_Config2__NetPrice__c = 10.00, APTS_SSD_Bill_To__c = accountSSD.Id,
                                                                                      APTS_SSD_Sold_To__c = accountSSD.Id,
                                                                                      Apttus_Config2__assetstatus__c='Activated',
                                                                                      Apttus_Config2__IsInactive__c =false,
                                                                                      Apttus_QPConfig__ProposalId__c =proposal.id,APTS_Proposal_Business_Unit__c = 'SCS',Apttus_Config2__NetUnitPrice__c=100,
                                                                                      APTS_Info_RenewalDate__c = System.today().addDays(-80),Apttus_Config2__BasePriceMethod__c = 'Per Unit');
        
        APTS_Group__c proposalGroup =new APTS_Group__c();
        proposalGroup.APTS_GrossAmount__c = 0;
        proposalGroup.APTS_Group_Name_Original__c ='Online/Software Bundle A';
        proposalGroup.APTS_Group_Name__c ='Online/Software Bundle A';
        proposalGroup.APTS_NetAmount__c=0;
        proposalGroup.APTS_Existing_Agreement_Product_Code__c='Not null';
        insert proposalGroup;
        
        APTS_Group__c proposalGroup11 =new APTS_Group__c();
        proposalGroup11.APTS_GrossAmount__c = 0;
        proposalGroup11.APTS_Group_Name_Original__c ='Online/Software Bundle A';
        proposalGroup11.APTS_Group_Name__c ='Online/Software Bundle A';
        proposalGroup11.APTS_NetAmount__c=0;
        proposalGroup11.APTS_Existing_Agreement_Product_Code__c='Not null';
        insert proposalGroup11;
        
        Apttus_Config2__SummaryGroup__c summaryGroup1 = new Apttus_Config2__SummaryGroup__c(
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Name = 'WEST PROFLEX Bundle A - Test group',
            Apttus_Config2__LineType__c = 'Group Total',
            Apttus_Config2__ItemSequence__c = 1,
            Apttus_Config2__LineNumber__c = 1
        );
        insert summaryGroup1;
                test.startTest();
        Apttus_Config2__LineItem__c li3 = new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c=prodConfig.id , Apttus_Config2__ProductId__c=prodprof.id);
        li3.Apttus_Config2__AssetLineItemId__c=asset1.id; 
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
        li3.CurrencyIsoCode = 'USD';
        li3.APTS_Product_Family__c = 'WESTLAW';
        li3.APTS_Contract_Term__c = '2 Years';
        li3.APTS_Years_2_Plus_Adjustment__c = '4';
        li3.APTS_Product_Delivery__c = 'Online/Internet';
        li3.Apttus_Config2__Quantity__c = 1;
        li3.Apttus_Config2__SummaryGroupId__c = summaryGroup1.id;
            li3.APTS_Proposal_Group__c = proposalGroup11.Id;
            li3.APTS_Group__c = proposalGroup11.APTS_Group_Name__c;
            
        listOfLineItems.add(li3);
        Apttus_Config2__LineItem__c li4 = new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c=prodConfig.id , Apttus_Config2__ProductId__c=prodprof.id);
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
        li4.Apttus_Config2__LineStatus__c = 'Amended';
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
        li4.CurrencyIsoCode = 'USD';
        li4.APTS_Product_Family__c = 'WESTLAW';
        li4.APTS_Contract_Term__c = '2 Years';
        li4.APTS_Years_2_Plus_Adjustment__c = '4';
        li4.APTS_Product_Delivery__c = 'Online/Internet';
        li4.Apttus_Config2__Quantity__c = 1;
        //li4.APTS_Bundle__c='West Proflex Bundle A';
        li4.APTS_is_Primary_in_Bundle__c=true;
            li4.Apttus_Config2__SummaryGroupId__c = summaryGroup1.id;
            li4.APTS_Proposal_Group__c = proposalGroup.Id;
            li4.APTS_Group__c = proposalGroup.APTS_Group_Name__c;
            li4.APTS_Bridge__c='7 Months';
            li4.APTS_Keep_Terms__c=true;
        listOfLineItems.add(li4);
        Apttus_Config2__LineItem__c li5 = new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c=prodConfig.id , Apttus_Config2__ProductId__c=prod3.id);
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
        li5.APTS_Yr_1_Renewal_Adjustment__c ='1';
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
        li5.CurrencyIsoCode = 'USD';
        li5.APTS_Product_Family__c = 'WESTLAW';
        li5.APTS_Contract_Term__c = '2 Years';
        li5.APTS_Years_2_Plus_Adjustment__c = '4';
        li5.APTS_Product_Delivery__c = 'Online/Internet';
        li5.Apttus_Config2__Quantity__c = 1;
        li5.APTS_Bridge__c='7 Months';
            li5.Apttus_Config2__SummaryGroupId__c = summaryGroup1.id;
            li5.APTS_Proposal_Group__c = proposalGroup.Id;
            li5.APTS_Group__c = proposalGroup.APTS_Group_Name__c;
            
        listOfLineItems.add(li5);
        Apttus_Config2__LineItem__c linObj1 = new Apttus_Config2__LineItem__c(
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Product/Service',
            Apttus_Config2__LineNumber__c = 1, 
            
            Apttus_Config2__LineStatus__c = 'New',
            // APTS_Media_High_Level_Code__c = '07',
            //APTS_Media_High_Level_Code__c = '21',
            Apttus_Config2__ItemSequence__c = 1,
            Apttus_Config2__ProductId__c=prod3.id,            
            Apttus_Config2__IncentiveCode__c = '02',
            APTS_Bridge__c = '1 Month',
            Apttus_Config2__BasePrice__c=10.0,
            Apttus_Config2__BaseExtendedPrice__c = 10.0,
            Apttus_Config2__AdjustedPrice__c = 10.0,
            Apttus_Config2__OptionPrice__c = 5.0,
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring',
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            APTS_Contract_Term__c='3 Months',
            //APTS_Group__c='Bundle B',
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Deal_Number__c = 1234,
            Apttus_Config2__SummaryGroupId__c = summaryGroup1.id,
            APTS_Proposal_Group__c = proposalGroup.Id,
            APTS_Group__c ='',
            Apttus_Config2__NetPrice__c=1); 
        //listOfLineItems.add(linObj1);
        
        Apttus_Config2__LineItem__c linObj2 = new Apttus_Config2__LineItem__c(
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Product/Service',
            Apttus_Config2__LineNumber__c = 1, 
            Apttus_Config2__LineStatus__c = 'Amended',
            // APTS_Media_High_Level_Code__c = '07',
            //APTS_Media_High_Level_Code__c = '21',
            Apttus_Config2__ItemSequence__c = 1,
            Apttus_Config2__ProductId__c=prod3.id,            
            Apttus_Config2__IncentiveCode__c = '02',
            APTS_Bridge__c = '1 Month',
            Apttus_Config2__BasePrice__c=10.0,
            Apttus_Config2__BaseExtendedPrice__c = 10.0,
            Apttus_Config2__AdjustedPrice__c = 10.0,
            Apttus_Config2__OptionPrice__c = 5.0,
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring',
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            APTS_Contract_Term__c='3 Months',
            //APTS_Group__c='Bundle B',
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Deal_Number__c = 1234,
            Apttus_Config2__SummaryGroupId__c = summaryGroup1.id,
            APTS_Proposal_Group__c = proposalGroup.Id,
            APTS_Group__c =proposalGroup.APTS_Group_Name__c,
            Apttus_Config2__NetPrice__c=1); 
        //listOfLineItems.add(linObj2);
        
        Apttus_Config2__LineItem__c linObj3 = new Apttus_Config2__LineItem__c(
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Product/Service',
            Apttus_Config2__LineNumber__c = 1, 
            Apttus_Config2__LineStatus__c = 'Amended',
            // APTS_Media_High_Level_Code__c = '07',
            //APTS_Media_High_Level_Code__c = '21',
            Apttus_Config2__ItemSequence__c = 1,
            Apttus_Config2__ProductId__c=prod3.id,            
            Apttus_Config2__IncentiveCode__c = '02',
            APTS_Bridge__c = '1 Month',
            Apttus_Config2__BasePrice__c=10.0,
            Apttus_Config2__BaseExtendedPrice__c = 10.0,
            Apttus_Config2__AdjustedPrice__c = 10.0,
            Apttus_Config2__OptionPrice__c = 5.0,
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring',
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            APTS_Contract_Term__c='3 Months',
            //APTS_Group__c='Bundle B',
            Apttus_Config2__PriceAdjustment__c=0,APTS_Deal_Number__c = 1234,
            Apttus_Config2__SummaryGroupId__c = summaryGroup1.id,
            APTS_Proposal_Group__c = proposalGroup.Id,
            APTS_Group__c ='',
            Apttus_Config2__NetPrice__c=1); 
        //listOfLineItems.add(linObj3);
        
        Apttus_Config2__LineItem__c linObj4 = new Apttus_Config2__LineItem__c(
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Product/Service',
            Apttus_Config2__LineNumber__c = 1, 
            Apttus_Config2__LineStatus__c = 'Amended',
            // APTS_Media_High_Level_Code__c = '07',
            //APTS_Media_High_Level_Code__c = '21',
            Apttus_Config2__ItemSequence__c = 1,
            Apttus_Config2__ProductId__c=prod3.id,            
            Apttus_Config2__IncentiveCode__c = '02',
            APTS_Bridge__c = '1 Month',
            Apttus_Config2__BasePrice__c=10.0,
            Apttus_Config2__BaseExtendedPrice__c = 10.0,
            Apttus_Config2__AdjustedPrice__c = 10.0,
            Apttus_Config2__OptionPrice__c = 5.0,
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring',
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            APTS_Contract_Term__c='3 Months',
            //APTS_Group__c='Bundle B',
            Apttus_Config2__PriceAdjustment__c=0,APTS_Deal_Number__c = 1234,
            Apttus_Config2__SummaryGroupId__c = summaryGroup1.id,
            APTS_Proposal_Group__c = proposalGroup.Id,
            APTS_Group__c ='kkr',
            Apttus_Config2__NetPrice__c=1); 
        //listOfLineItems.add(linObj4);
        
        Apttus_Config2__LineItem__c linObj5 = new Apttus_Config2__LineItem__c(
            Apttus_Config2__Quantity__c=1,
            APTS_Contract_Term__c = 'Short Term Trial',
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Product/Service',
            Apttus_Config2__LineNumber__c = 1, 
            Apttus_Config2__LineStatus__c = 'New',
            // APTS_Media_High_Level_Code__c = '07',
            //APTS_Media_High_Level_Code__c = '21',
            Apttus_Config2__ItemSequence__c = 1,
            Apttus_Config2__ProductId__c=prod3.id,            
            APTS_Bridge__c = '1 Month',
            Apttus_Config2__BasePrice__c=10.0,
            Apttus_Config2__BaseExtendedPrice__c = 10.0,
            Apttus_Config2__AdjustedPrice__c = 10.0,
            Apttus_Config2__OptionPrice__c = 5.0,
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring',
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
           Apttus_Config2__PriceAdjustment__c=0,APTS_Deal_Number__c = 1234,
            Apttus_Config2__SummaryGroupId__c = summaryGroup1.id,
            APTS_Proposal_Group__c = proposalGroup.Id,
            APTS_Group__c ='kkr',
            Apttus_Config2__NetPrice__c=1); 
        //listOfLineItems.add(linObj5);
        
        Apttus_Config2__LineItem__c linObj6 = new Apttus_Config2__LineItem__c(
            Apttus_Config2__Quantity__c=1,
            APTS_Contract_Term__c = 'Short Term Trial',
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Product/Service',
            Apttus_Config2__LineNumber__c = 1, 
            Apttus_Config2__LineStatus__c = 'Cancelled',
            // APTS_Media_High_Level_Code__c = '07',
            //APTS_Media_High_Level_Code__c = '21',
            Apttus_Config2__ItemSequence__c = 1,
            Apttus_Config2__ProductId__c=prod3.id,            
           // Apttus_Config2__IncentiveCode__c = '02',
            APTS_Bridge__c = '1 Month',
            Apttus_Config2__BasePrice__c=10.0,
            Apttus_Config2__BaseExtendedPrice__c = 10.0,
            Apttus_Config2__AdjustedPrice__c = 10.0,
            Apttus_Config2__OptionPrice__c = 5.0,
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring',
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            //APTS_Contract_Term__c='3 Months',
            //APTS_Group__c='Bundle B',
            Apttus_Config2__PriceAdjustment__c=0,APTS_Deal_Number__c = 1234,
            Apttus_Config2__SummaryGroupId__c = summaryGroup1.id,
            APTS_Proposal_Group__c = proposalGroup.Id,
            APTS_Group__c ='kkr',
            Apttus_Config2__NetPrice__c=1); 
        //listOfLineItems.add(linObj6);
        
        Apttus_Config2__LineItem__c linObj7 = new Apttus_Config2__LineItem__c(
            Apttus_Config2__Quantity__c=1,
            APTS_Contract_Term__c = 'Short Term Trial',
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Product/Service',
            Apttus_Config2__LineNumber__c = 1, 
            Apttus_Config2__LineStatus__c = 'Cancelled',
            // APTS_Media_High_Level_Code__c = '07',
            //APTS_Media_High_Level_Code__c = '21',
            Apttus_Config2__ItemSequence__c = 1,
            Apttus_Config2__ProductId__c=prod3.id,            
            //Apttus_Config2__IncentiveCode__c = '02',
            APTS_Bridge__c = '1 Month',
            Apttus_Config2__BasePrice__c=10.0,
            Apttus_Config2__BaseExtendedPrice__c = 10.0,
            Apttus_Config2__AdjustedPrice__c = 10.0,
            Apttus_Config2__OptionPrice__c = 5.0,
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring',
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            //APTS_Contract_Term__c='3 Months',
            //APTS_Group__c='Bundle B',
            Apttus_Config2__PriceAdjustment__c=0,APTS_Deal_Number__c = 1234,
            Apttus_Config2__SummaryGroupId__c = summaryGroup1.id,
            APTS_Proposal_Group__c = proposalGroup.Id,
            APTS_Group__c ='kkr',
            Apttus_Config2__IncentiveCode__c='not null',
            Apttus_Config2__NetPrice__c=1); 
        //listOfLineItems.add(linObj7);
        
        Apttus_Config2__LineItem__c linObj8 = new Apttus_Config2__LineItem__c(
            Apttus_Config2__Quantity__c=1,
            APTS_Contract_Term__c = 'Short Term Trial',
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Product/Service',
            Apttus_Config2__LineNumber__c = 1, 
            // APTS_Bridge_Length__c = 1 ,
            // APTS_Contract_Term__c = 'Not Short Term Trial',
            Apttus_Config2__LineStatus__c = 'Cancelled',
            // APTS_Media_High_Level_Code__c = '07',
            //APTS_Media_High_Level_Code__c = '21',
            // APTS_Program_ID__c = 'WCMP',
            APTS_Group_Primary_Material__c= '40666420',
           Apttus_Config2__ItemSequence__c = 1,
            Apttus_Config2__ProductId__c=prod3.id,            
            //Apttus_Config2__IncentiveCode__c = '02',
            APTS_Bridge__c = '1 Month',
                APTS_Group_Primary_Material_Name__c ='Test',
            Apttus_Config2__BasePrice__c=10.0,
            Apttus_Config2__BaseExtendedPrice__c = 10.0,
            Apttus_Config2__AdjustedPrice__c = 10.0,
            Apttus_Config2__OptionPrice__c = 5.0,
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring',
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            //APTS_Contract_Term__c='3 Months',
            //APTS_Group__c='Bundle B',
            Apttus_Config2__PriceAdjustment__c=0,// APTS_Bridge_Length__c =1,
            APTS_Deal_Number__c = 1234,
            Apttus_Config2__SummaryGroupId__c = summaryGroup1.id,
            APTS_Proposal_Group__c = proposalGroup.Id,
            APTS_Group__c ='kkr',
            Apttus_Config2__IncentiveCode__c='not null',
            APTS_Keep_Terms__c = false,
            Apttus_Config2__NetPrice__c=1);
            
        //listOfLineItems.add(linObj8);
        
        List<APTS_Group__c> grouplist= new List<APTS_Group__c>();
        
        APTS_Group__c proposalGroup1 =new APTS_Group__c();
        proposalGroup1.APTS_GrossAmount__c = 0;
        proposalGroup1.APTS_Group_Name_Original__c ='Online/Software Bundle A';
        proposalGroup1.APTS_Group_Name__c ='Online/Software Bundle';
        proposalGroup1.APTS_NetAmount__c=0;
        proposalGroup1.APTS_Existing_Agreement_Product_Code__c ='58';
        proposalGroup1.APTS_ProductConfiguration__c=prodConfig.id;
        grouplist.add(proposalGroup1);
        
        Apttus_Config2__LineItem__c linObj9 = new Apttus_Config2__LineItem__c(
            Apttus_Config2__Quantity__c=1,
            APTS_Contract_Term__c = 'Short Term Trial',
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Product/Service',
            Apttus_Config2__LineNumber__c = 1, 
            // APTS_Bridge_Length__c = 1 ,
            // APTS_Contract_Term__c = 'Not Short Term Trial',
            Apttus_Config2__LineStatus__c = 'Cancelled',
            // APTS_Media_High_Level_Code__c = '07',
            //APTS_Media_High_Level_Code__c = '21',
            // APTS_Program_ID__c = 'WCMP',
            APTS_Group_Primary_Material__c= '40666420',
            Apttus_Config2__ItemSequence__c = 1,
            APTS_Deal_Number__c = 1234,
            Apttus_Config2__SummaryGroupId__c = summaryGroup1.id,
            APTS_Proposal_Group__c = grouplist[0].id,
            APTS_Group__c ='kkr',
            Apttus_Config2__IncentiveCode__c='not null',
            Apttus_Config2__NetPrice__c=1); 
       // listOfLineItems.add(linObj9);
        
        Apttus_Config2__LineItem__c linObj10 = new Apttus_Config2__LineItem__c(
            Apttus_Config2__Quantity__c=1,
            APTS_Contract_Term__c = 'Short Term Trial',
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Product/Service',
            Apttus_Config2__LineNumber__c = 1, 
            // APTS_Bridge_Length__c = 1 ,
            // APTS_Contract_Term__c = 'Not Short Term Trial',
            Apttus_Config2__LineStatus__c = 'Cancelled',
            // APTS_Media_High_Level_Code__c = '07',
            //APTS_Media_High_Level_Code__c = '21',
            // APTS_Program_ID__c = 'WCMP',
            APTS_Group_Primary_Material__c= '40666420',
            Apttus_Config2__ItemSequence__c = 1,
            APTS_Deal_Number__c = 1234,
            Apttus_Config2__SummaryGroupId__c = summaryGroup1.id,
            APTS_Proposal_Group__c = grouplist[0].id,
            APTS_Group__c ='kkr',
            Apttus_Config2__IncentiveCode__c='not null',
            Apttus_Config2__NetPrice__c=1); 
        //listOfLineItems.add(linObj10);
        
        Apttus_Config2__SummaryGroup__c summaryGroup2 = new Apttus_Config2__SummaryGroup__c(
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Name = 'WEST PROFLEX Bundle A - Test group 2',
            Apttus_Config2__LineType__c = 'Group Total',
            Apttus_Config2__ItemSequence__c = 2,
            Apttus_Config2__LineNumber__c = 1
        );
        insert summaryGroup2;
        
        Apttus_Config2__LineItem__c linObj11 = new Apttus_Config2__LineItem__c(
            Apttus_Config2__Quantity__c=1,
            APTS_Deal_Type__c='WCMP',
            APTS_Contract_Term__c = 'Short Term Trial',
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Product/Service',
            Apttus_Config2__LineNumber__c = 1, 
            // APTS_Bridge_Length__c = 1 ,
            // APTS_Contract_Term__c = 'Not Short Term Trial',
            Apttus_Config2__LineStatus__c = 'Amended',
            // APTS_Media_High_Level_Code__c = '07',
            //APTS_Media_High_Level_Code__c = '21',
            // APTS_Program_ID__c = 'WCMP',
            APTS_Group_Primary_Material__c= '40666420',
            Apttus_Config2__ItemSequence__c = 1,
            APTS_Deal_Number__c = 1234,
            Apttus_Config2__SummaryGroupId__c = summaryGroup2.id,
            APTS_Proposal_Group__c = grouplist[0].id,
            APTS_Group__c ='kkr',
            Apttus_Config2__IncentiveCode__c='not null',
            Apttus_Config2__NetPrice__c=1); 
        //listOfLineItems.add(linObj11);
        
        
        
        insert grouplist;
        insert listOfLineItems;
        
        //changed old account soldto to new soldto ssd
        List<Apttus_Config2__LineItem__c> lineItemsList = [SELECT Id, Name, Apttus_Config2__ProductId__c, Apttus_Config2__ConfigurationId__c, Apttus_Config2__ConfigurationId__r.APTS_SSD_Sold_To__c, Apttus_Config2__LineNumber__c,
                                                           Apttus_Config2__ItemSequence__c, Apttus_Config2__LineType__c, Apttus_Config2__LineStatus__c 
                                                           FROM Apttus_Config2__LineItem__c 
                                                           WHERE Apttus_Config2__ConfigurationId__c = :prodConfig.id];      
        
        System.assert(lineItemsList!= null && lineItemsList.size()>0);      
        
        
        //APTS_ProductConfigurationTriggerHandler.afterUpdate = false;
        prodConfig.Apttus_Config2__Status__c = 'New';
        prodConfig.APTS_Least_Contract_Term__c=2;
        //prodConfig.APTS_Customer_Category__c='Not null';
        update prodConfig;
        
        APTS_ProductConfigurationTriggerHandler.afterUpdate = false;
        checkRecursive.afterUpdate = True;
        prodConfig.Apttus_Config2__Status__c = 'Finalized';
        update prodConfig;
        
        // prodConfig2.APTS_Incremental_Growth_violated__c= 'Approval';
        //  prodConfig2.APTS_Incremental_Growth_Formula__c=1;
        // prodConfig2.APTS_Attorney_Count_Reduced__c = TRUE;
        update prodConfig2;
        
        list<APTS_Dynamic_Bundle__c> pplList = [SELECT Id,APTS_Keep_Terms__c FROM APTS_Dynamic_Bundle__c WHERE APTS_Quote_Proposal__c = :proposal.Id ];
        //System.assert(pplList!= null && pplList.size()>0);
        for(integer i=0;i<pplList.size();i++)
        {
            pplList[i].APTS_Keep_Terms__c= TRUE;
        }
        update pplList;
        
        
        
        
        update pplList;
        
        test.stopTest();
        
        
        //update prodConfig;
        
    }
    
    @isTest static void testcreateAccountMirrorPicklist() {
        
        
        List<APTS_Segment_Threshold__c> segthrList= new List<APTS_Segment_Threshold__c>();
        //Add Segment threshold
        APTS_Segment_Threshold__c seg1 = new APTS_Segment_Threshold__c();
        seg1.APTS_Approval_Required__c=True;
        seg1.APTS_Segment__c='Small Law';
        seg1.APTS_Customer_Category__c='0';
        seg1.APTS_Term_in_years__c=Integer.ValueOf('2');
        seg1.APTS_Minimum_OY_Increase__c=Integer.ValueOf('5');
        String myNumber = '15.00';
        String myTruncatedNumber = myNumber.subString(0,myNumber.indexOf('.')+3);
        Decimal d = Decimal.valueOf(myTruncatedNumber);
        System.debug(d);
        seg1.APTS_Minimum_Incremental_Growth__c=d;
        segthrList.add(seg1);
        
        APTS_Segment_Threshold__c seg2 = new APTS_Segment_Threshold__c();
        seg2.APTS_Approval_Required__c=True;
        seg2.APTS_Segment__c='Corporate';
        seg2.APTS_Customer_Category__c='0';
        seg2.APTS_Term_in_years__c=Integer.ValueOf('2');
        seg2.APTS_Minimum_OY_Increase__c=Integer.ValueOf('5');
        
        String myNumber2 = '15.00';
        String myTruncatedNumber2 = myNumber2.subString(0,myNumber2.indexOf('.')+3);
        Decimal d2 = Decimal.valueOf(myTruncatedNumber2);
        System.debug(d);
        seg2.APTS_Minimum_Incremental_Growth__c=d2;
        segthrList.add(seg2);
        
        
        APTS_Segment_Threshold__c seg3 = new APTS_Segment_Threshold__c();
        seg3.APTS_Approval_Required__c=True;
        seg3.APTS_Segment__c='Government';
        seg3.APTS_Customer_Category__c='0';
        seg3.APTS_Term_in_years__c=Integer.ValueOf('2');
        seg3.APTS_Minimum_OY_Increase__c=Integer.ValueOf('5');
        String myNumber3 = '15.00';
        String myTruncatedNumber3 = myNumber3.subString(0,myNumber3.indexOf('.')+3);
        Decimal d3 = Decimal.valueOf(myTruncatedNumber3);
        System.debug(d);
        seg3.APTS_Minimum_Incremental_Growth__c=d3;
        segthrList.add(seg3);
        insert segthrList;
        Apttus_Config2__PriceList__c priceList = APTS_TestDataFactory.createPriceList('Thomson Reuters Master - US Legal');
        insert priceList;
        
        
        WebServiceSettings__c oWebServiceSettings = new WebServiceSettings__c();
        oWebServiceSettings.Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable'; 
        oWebServiceSettings.Name = 'PaymentCreditIncrease'; 
        oWebServiceSettings.Timeout__c = 120; 
        oWebServiceSettings.Endpoint__c = 'https://dev.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease'; 
        oWebServiceSettings.Active__c = true;
        insert oWebServiceSettings;
        
        //Inserting keyvaluestore
        List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c=System.Label.APTS_OC_Test_Id),
        new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other'),
        new KeyValueListStore__c(Name='LCRMDisableStrikeIronServices',TextValue__c='false')};
        insert keyvaluestore;
        
        //Inserting record list 
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
        
        
        Account a = APTS_TestDataFactory.createAccount('Test Account2');
        insert a;
        
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();
        Source_System_Detail__c accountSSD= new Source_System_Detail__c();
        accountSSD.RecordtypeId=ssdRecorType;
        accountSSD.Name='ABC';
        accountSSD.Source_System_Name__c='ABC';
        accountSSD.Account_Name__c=a.ID;
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
        insert proposal;
         proposal.APTS_Approval_Segment__c = 'Government';
        update proposal;
        
        Apttus_Config2__ProductConfiguration__c prodConfig = APTS_TestDataFactory.createProductConfiguration(proposal.Id);
        insert prodConfig;
        prodConfig.APTS_Least_Contract_Term__c=2;
        System.assertEquals(prodConfig.APTS_Least_Contract_Term__c,2);
        update prodConfig;
    }
    
    @isTest 
    static void testupdateTally() {
        
        
        
        List<APTS_Segment_Threshold__c> segthrList= new List<APTS_Segment_Threshold__c>();
        //Add Segment threshold
        APTS_Segment_Threshold__c seg1 = new APTS_Segment_Threshold__c();
        seg1.APTS_Approval_Required__c=True;
        seg1.APTS_Segment__c='Small Law';
        seg1.APTS_Customer_Category__c='0';
        seg1.APTS_Term_in_years__c=Integer.ValueOf('2');
        seg1.APTS_Minimum_OY_Increase__c=Integer.ValueOf('5');
        String myNumber = '15.00';
        String myTruncatedNumber = myNumber.subString(0,myNumber.indexOf('.')+3);
        Decimal d = Decimal.valueOf(myTruncatedNumber);
        System.debug(d);
        seg1.APTS_Minimum_Incremental_Growth__c=d;
        segthrList.add(seg1);
        
        APTS_Segment_Threshold__c seg2 = new APTS_Segment_Threshold__c();
        seg2.APTS_Approval_Required__c=True;
        seg2.APTS_Segment__c='Corporate';
        seg2.APTS_Customer_Category__c='0';
        seg2.APTS_Term_in_years__c=Integer.ValueOf('2');
        seg2.APTS_Minimum_OY_Increase__c=Integer.ValueOf('5');
        
        String myNumber2 = '15.00';
        String myTruncatedNumber2 = myNumber2.subString(0,myNumber2.indexOf('.')+3);
        Decimal d2 = Decimal.valueOf(myTruncatedNumber2);
        System.debug(d);
        seg2.APTS_Minimum_Incremental_Growth__c=d2;
        segthrList.add(seg2);
        
        
        APTS_Segment_Threshold__c seg3 = new APTS_Segment_Threshold__c();
        seg3.APTS_Approval_Required__c=True;
        seg3.APTS_Segment__c='Government';
        seg3.APTS_Customer_Category__c='0';
        seg3.APTS_Term_in_years__c=Integer.ValueOf('2');
        seg3.APTS_Minimum_OY_Increase__c=Integer.ValueOf('5');
        String myNumber3 = '15.00';
        String myTruncatedNumber3 = myNumber3.subString(0,myNumber3.indexOf('.')+3);
        Decimal d3 = Decimal.valueOf(myTruncatedNumber3);
        System.debug(d);
        seg3.APTS_Minimum_Incremental_Growth__c=d3;
        segthrList.add(seg3);
        insert segthrList;
        
        
        Apttus_Config2__PriceList__c priceList = APTS_TestDataFactory.createPriceList('Thomson Reuters Master - US Legal');
        insert priceList;
        
        Apttus_Config2__PriceListItem__c pliSO = new Apttus_Config2__PriceListItem__c();
        pliSO.Apttus_Config2__Active__c = true;
        pliSO.Apttus_Config2__PriceListId__c = priceList.Id;
        pliSO.APTS_Max_Fill_Up_Price__c = 5;
        insert pliSO;
        
        
        WebServiceSettings__c oWebServiceSettings = new WebServiceSettings__c();
        oWebServiceSettings.Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable'; 
        oWebServiceSettings.Name = 'PaymentCreditIncrease'; 
        oWebServiceSettings.Timeout__c = 120; 
        oWebServiceSettings.Endpoint__c = 'https://dev.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease'; 
        oWebServiceSettings.Active__c = true;
        insert oWebServiceSettings;
        
        //Inserting keyvaluestore
        List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c=System.Label.APTS_OC_Test_Id),
        new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other'),
        new KeyValueListStore__c(Name='LCRMDisableStrikeIronServices',TextValue__c='false')};
        insert keyvaluestore;
        
        //Inserting record list 
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
        
        
        Account a = APTS_TestDataFactory.createAccount('Test Account');
        insert a;
        
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();
        Source_System_Detail__c accountSSD= new Source_System_Detail__c();
        accountSSD.RecordtypeId=ssdRecorType;
        accountSSD.Name='ABC';
        accountSSD.Source_System_Name__c='ABC';
        accountSSD.Account_Name__c=a.ID;
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
        insert proposal;
         Apttus_Config2__ProductConfiguration__c prodConfig = APTS_TestDataFactory.createProductConfiguration(proposal.Id);
        insert prodConfig;
        
        Product2 prod = new Product2(Name = 'Test prod', 
                                     Family = 'Hardware',
                                     APTS_Media_High_Level_Code__c= '07'
                                    );
        insert prod; 
        
        System.debug('prod+++++' + prod);
        
        
        proposal.APTS_Approval_Segment__c = 'Small Law';
        update proposal;
        update prodConfig;
        
        
        
        List<Apttus_Config2__LineItem__c> listOfLineItems = New List<Apttus_Config2__LineItem__c>();
        List<Apttus_Config2__ProductAttributeValue__c> listofPAVs = new List<Apttus_Config2__ProductAttributeValue__c>(); 
        
        Apttus_Config2__SummaryGroup__c summaryGroup1 = new Apttus_Config2__SummaryGroup__c(
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Name = 'WEST PROFLEX Bundle A - Test group',
            Apttus_Config2__LineType__c = 'Group Total',
            Apttus_Config2__ItemSequence__c = 1,
            Apttus_Config2__LineNumber__c = 1
        );
        insert summaryGroup1;
        
        Apttus_Config2__LineItem__c linObj = new Apttus_Config2__LineItem__c(
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Product/Service',
            Apttus_Config2__LineNumber__c = 1, 
            Apttus_Config2__ItemSequence__c = 1,
            Apttus_Config2__SummaryGroupId__c = summaryGroup1.id,
            //Apttus_Config2__NetPrice__c=1,
            APTS_Contract_Term__c = 'Short Term Trial',
            Apttus_Config2__IncentiveCode__c = '02',
            APTS_Bridge__c = '1 Month',
            Apttus_Config2__NetPrice__c=10.0,
            Apttus_Config2__BasePrice__c=10.0,
            Apttus_Config2__BaseExtendedPrice__c = 10.0,
            Apttus_Config2__AdjustedPrice__c = 10.0,
            Apttus_Config2__OptionPrice__c = 5.0,
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring',
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__PriceAdjustment__c=0); 
        
        listOfLineItems.add(linObj);
        
        Apttus_Config2__SummaryGroup__c summaryGroup2 = new Apttus_Config2__SummaryGroup__c(
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Name = 'WEST PROFLEX Bundle A - Test group 2',
            Apttus_Config2__LineType__c = 'Group Total',
            Apttus_Config2__ItemSequence__c = 2,
            Apttus_Config2__LineNumber__c = 1
        );
        insert summaryGroup2;
        
        /*linObj = new Apttus_Config2__LineItem__c(
Apttus_Config2__Quantity__c=1,
Apttus_Config2__ConfigurationId__c = prodConfig.id, 
Apttus_Config2__LineType__c = 'Product/Service',
Apttus_Config2__LineNumber__c = 1, 
Apttus_Config2__ItemSequence__c = 2,
APTS_Contract_Term__c = 'Short Term Trial',
Apttus_Config2__IncentiveCode__c = '02',
Apttus_Config2__SummaryGroupId__c = summaryGroup2.id,
//Apttus_Config2__LineStatus__c = 'Cancelled',
APTS_Bridge__c = '1 Month',
//Apttus_Config2__ProductId__c = prod.Id,
Apttus_Config2__NetPrice__c=1); 


listOfLineItems.add(linObj);*/
        
        insert listOfLineItems;
        
        //changed old account soldto to new soldto ssd
        List<Apttus_Config2__LineItem__c> lineItemsList = [SELECT Id, Name, Apttus_Config2__ProductId__c, Apttus_Config2__ConfigurationId__c, Apttus_Config2__ConfigurationId__r.APTS_SSD_Sold_To__c, Apttus_Config2__LineNumber__c,
                                                           Apttus_Config2__ItemSequence__c, Apttus_Config2__LineType__c, Apttus_Config2__LineStatus__c 
                                                           FROM Apttus_Config2__LineItem__c 
                                                           WHERE Apttus_Config2__ConfigurationId__c = :prodConfig.id];      
        
        System.assert(lineItemsList!= null && lineItemsList.size()>0);      
        
        Test.startTest();
        //APTS_ProductConfigurationTriggerHandler.afterUpdate = false;
        prodConfig.Apttus_Config2__Status__c = 'New';
        update prodConfig;
        
        APTS_ProductConfigurationTriggerHandler.afterUpdate = false;
        checkRecursive.afterUpdate = True;
        prodConfig.Apttus_Config2__Status__c = 'Finalized';
        prodConfig.APTS_Least_Contract_Term__c=2;
        update prodConfig;
        Test.stopTest();
        
        list<APTS_Dynamic_Bundle__c> pplList = [SELECT Id FROM APTS_Dynamic_Bundle__c WHERE APTS_Quote_Proposal__c = :proposal.Id ];
        //System.assert(pplList!= null && pplList.size()>0);
        
    }
    @isTest
    static void testApprovalCheck() {
        
        
        
        List<APTS_Segment_Threshold__c> segthrList= new List<APTS_Segment_Threshold__c>();
        //Add Segment threshold
        APTS_Segment_Threshold__c seg1 = new APTS_Segment_Threshold__c();
        seg1.APTS_Approval_Required__c=True;
        seg1.APTS_Segment__c='Small Law';
        seg1.APTS_Customer_Category__c='0';
        seg1.APTS_Term_in_years__c=Integer.ValueOf('2');
        seg1.APTS_Minimum_OY_Increase__c=Integer.ValueOf('5');
        String myNumber = '15.00';
        String myTruncatedNumber = myNumber.subString(0,myNumber.indexOf('.')+3);
        Decimal d = Decimal.valueOf(myTruncatedNumber);
        System.debug(d);
        seg1.APTS_Minimum_Incremental_Growth__c=d;
        segthrList.add(seg1);
        
        APTS_Segment_Threshold__c seg2 = new APTS_Segment_Threshold__c();
        seg2.APTS_Approval_Required__c=True;
        seg2.APTS_Segment__c='Corporate';
        seg2.APTS_Customer_Category__c='0';
        seg2.APTS_Term_in_years__c=Integer.ValueOf('2');
        seg2.APTS_Minimum_OY_Increase__c=Integer.ValueOf('5');
        
        String myNumber2 = '15.00';
        String myTruncatedNumber2 = myNumber2.subString(0,myNumber2.indexOf('.')+3);
        Decimal d2 = Decimal.valueOf(myTruncatedNumber2);
        System.debug(d);
        seg2.APTS_Minimum_Incremental_Growth__c=d2;
        segthrList.add(seg2);
        
        
        APTS_Segment_Threshold__c seg3 = new APTS_Segment_Threshold__c();
        seg3.APTS_Approval_Required__c=True;
        seg3.APTS_Segment__c='Government';
        seg3.APTS_Customer_Category__c='0';
        seg3.APTS_Term_in_years__c=Integer.ValueOf('2');
        seg3.APTS_Minimum_OY_Increase__c=Integer.ValueOf('5');
        String myNumber3 = '15.00';
        String myTruncatedNumber3 = myNumber3.subString(0,myNumber3.indexOf('.')+3);
        Decimal d3 = Decimal.valueOf(myTruncatedNumber3);
        System.debug(d);
        seg3.APTS_Minimum_Incremental_Growth__c=d3;
        segthrList.add(seg3);
        insert segthrList;
        
        
        Apttus_Config2__PriceList__c priceList = APTS_TestDataFactory.createPriceList('Thomson Reuters Master - US Legal');
        insert priceList;
        
        Apttus_Config2__PriceListItem__c pliSO = new Apttus_Config2__PriceListItem__c();
        pliSO.Apttus_Config2__Active__c = true;
        pliSO.Apttus_Config2__PriceListId__c = priceList.Id;
        pliSO.APTS_Max_Fill_Up_Price__c = 5;
        insert pliSO;
        
        
        WebServiceSettings__c oWebServiceSettings = new WebServiceSettings__c();
        oWebServiceSettings.Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable'; 
        oWebServiceSettings.Name = 'PaymentCreditIncrease'; 
        oWebServiceSettings.Timeout__c = 120; 
        oWebServiceSettings.Endpoint__c = 'https://dev.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease'; 
        oWebServiceSettings.Active__c = true;
        insert oWebServiceSettings;
        //Inserting keyvaluestore
        List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c=System.Label.APTS_OC_Test_Id),
        new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other'),
        new KeyValueListStore__c(Name='LCRMDisableStrikeIronServices',TextValue__c='false')};
        insert keyvaluestore;
        
        //Inserting record list 
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
        
        
        Account a = APTS_TestDataFactory.createAccount('Test Account');
        insert a;
        
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();
        Source_System_Detail__c accountSSD= new Source_System_Detail__c();
        accountSSD.RecordtypeId=ssdRecorType;
        accountSSD.Name='ABC';
        accountSSD.Source_System_Name__c='ABC';
        accountSSD.Account_Name__c=a.ID;
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
        proposal.APTS_Approval_Segment__c = 'Government';
        insert proposal;
         Apttus_Config2__ProductConfiguration__c prodConfig = APTS_TestDataFactory.createProductConfiguration(proposal.Id);
        insert prodConfig;
        
        Product2 prod = new Product2(Name = 'Test prod', 
                                     Family = 'Hardware',
                                     APTS_Media_High_Level_Code__c= '07'
                                    );
        insert prod; 
        
        proposal.APTS_Approval_Segment__c = 'Medium Law';
        update proposal;
        update prodConfig;
        
        
        List<Apttus_Config2__LineItem__c> listOfLineItems = New List<Apttus_Config2__LineItem__c>();
        List<Apttus_Config2__ProductAttributeValue__c> listofPAVs = new List<Apttus_Config2__ProductAttributeValue__c>(); 
        
        Apttus_Config2__SummaryGroup__c summaryGroup1 = new Apttus_Config2__SummaryGroup__c(
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Name = 'WEST PROFLEX Bundle A - Test group',
            Apttus_Config2__LineType__c = 'Group Total',
            Apttus_Config2__ItemSequence__c = 1,
            Apttus_Config2__LineNumber__c = 1
        );
        insert summaryGroup1;
        
        Apttus_Config2__LineItem__c linObj = new Apttus_Config2__LineItem__c(
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Product/Service',
            Apttus_Config2__LineNumber__c = 1, 
            Apttus_Config2__ItemSequence__c = 1,
            Apttus_Config2__SummaryGroupId__c = summaryGroup1.id,
            //Apttus_Config2__NetPrice__c=1,
            APTS_Contract_Term__c = 'Short Term Trial',
            Apttus_Config2__IncentiveCode__c = '02',
            APTS_Bridge__c = '1 Month',
            Apttus_Config2__NetPrice__c=10.0,
            Apttus_Config2__BasePrice__c=10.0,
            Apttus_Config2__BaseExtendedPrice__c = 10.0,
            Apttus_Config2__AdjustedPrice__c = 10.0,
            Apttus_Config2__OptionPrice__c = 5.0,
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring',
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__PriceAdjustment__c=0); 
        
        listOfLineItems.add(linObj);
        
        Apttus_Config2__SummaryGroup__c summaryGroup2 = new Apttus_Config2__SummaryGroup__c(
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Name = 'WEST PROFLEX Bundle A - Test group 2',
            Apttus_Config2__LineType__c = 'Group Total',
            Apttus_Config2__ItemSequence__c = 2,
            Apttus_Config2__LineNumber__c = 1
        );
        insert summaryGroup2;
        
        
        insert listOfLineItems;
        
        //changed old account soldto to new soldto ssd
        List<Apttus_Config2__LineItem__c> lineItemsList = [SELECT Id, Name, Apttus_Config2__ProductId__c, Apttus_Config2__ConfigurationId__c, Apttus_Config2__ConfigurationId__r.APTS_SSD_Sold_To__c, Apttus_Config2__LineNumber__c,
                                                           Apttus_Config2__ItemSequence__c, Apttus_Config2__LineType__c, Apttus_Config2__LineStatus__c 
                                                           FROM Apttus_Config2__LineItem__c 
                                                           WHERE Apttus_Config2__ConfigurationId__c = :prodConfig.id];      
        
        System.assert(lineItemsList!= null && lineItemsList.size()>0);      
        
        Test.startTest();
        //APTS_ProductConfigurationTriggerHandler.afterUpdate = false;
        prodConfig.Apttus_Config2__Status__c = 'New';
        update prodConfig;
        
        APTS_ProductConfigurationTriggerHandler.afterUpdate = false;
        checkRecursive.afterUpdate = True;
        prodConfig.Apttus_Config2__Status__c = 'Finalized';
        prodConfig.APTS_Least_Contract_Term__c=2;
        update prodConfig;
        Test.stopTest();
        
        list<APTS_Dynamic_Bundle__c> pplList = [SELECT Id FROM APTS_Dynamic_Bundle__c WHERE APTS_Quote_Proposal__c = :proposal.Id ];
        
        
    }
    
    @isTest
    static void testTK() {
        
        
        
        List<APTS_Segment_Threshold__c> segthrList= new List<APTS_Segment_Threshold__c>();
        //Add Segment threshold
        APTS_Segment_Threshold__c seg1 = new APTS_Segment_Threshold__c();
        seg1.APTS_Approval_Required__c=True;
        seg1.APTS_Segment__c='Small Law';
        seg1.APTS_Customer_Category__c='0';
        seg1.APTS_Term_in_years__c=Integer.ValueOf('2');
        seg1.APTS_Minimum_OY_Increase__c=Integer.ValueOf('5');
        String myNumber = '15.00';
        String myTruncatedNumber = myNumber.subString(0,myNumber.indexOf('.')+3);
        Decimal d = Decimal.valueOf(myTruncatedNumber);
        System.debug(d);
        seg1.APTS_Minimum_Incremental_Growth__c=d;
        segthrList.add(seg1);
        
        APTS_Segment_Threshold__c seg2 = new APTS_Segment_Threshold__c();
        seg2.APTS_Approval_Required__c=True;
        seg2.APTS_Segment__c='Corporate';
        seg2.APTS_Customer_Category__c='0';
        seg2.APTS_Term_in_years__c=Integer.ValueOf('2');
        seg2.APTS_Minimum_OY_Increase__c=Integer.ValueOf('5');
        
        String myNumber2 = '15.00';
        String myTruncatedNumber2 = myNumber2.subString(0,myNumber2.indexOf('.')+3);
        Decimal d2 = Decimal.valueOf(myTruncatedNumber2);
        System.debug(d);
        seg2.APTS_Minimum_Incremental_Growth__c=d2;
        segthrList.add(seg2);
        
        
        APTS_Segment_Threshold__c seg3 = new APTS_Segment_Threshold__c();
        seg3.APTS_Approval_Required__c=True;
        seg3.APTS_Segment__c='Government';
        seg3.APTS_Customer_Category__c='0';
        seg3.APTS_Term_in_years__c=Integer.ValueOf('2');
        seg3.APTS_Minimum_OY_Increase__c=Integer.ValueOf('5');
        String myNumber3 = '15.00';
        String myTruncatedNumber3 = myNumber3.subString(0,myNumber3.indexOf('.')+3);
        Decimal d3 = Decimal.valueOf(myTruncatedNumber3);
        System.debug(d);
        seg3.APTS_Minimum_Incremental_Growth__c=d3;
        segthrList.add(seg3);
        insert segthrList;
        
        
        Apttus_Config2__PriceList__c priceList = APTS_TestDataFactory.createPriceList('Thomson Reuters Master - US Legal');
        insert priceList;
        
        Apttus_Config2__PriceListItem__c pliSO = new Apttus_Config2__PriceListItem__c();
        pliSO.Apttus_Config2__Active__c = true;
        pliSO.Apttus_Config2__PriceListId__c = priceList.Id;
        pliSO.APTS_Max_Fill_Up_Price__c = 5;
        insert pliSO;
        
        
        WebServiceSettings__c oWebServiceSettings = new WebServiceSettings__c();
        oWebServiceSettings.Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable'; 
        oWebServiceSettings.Name = 'PaymentCreditIncrease'; 
        oWebServiceSettings.Timeout__c = 120; 
        oWebServiceSettings.Endpoint__c = 'https://dev.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease'; 
        oWebServiceSettings.Active__c = true;
        insert oWebServiceSettings;
        //Inserting keyvaluestore
        List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c=System.Label.APTS_OC_Test_Id),
        new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other'),
        new KeyValueListStore__c(Name='LCRMDisableStrikeIronServices',TextValue__c='false')};
        insert keyvaluestore;
        
        //Inserting record list 
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
        
        
        Account a = APTS_TestDataFactory.createAccount('Test Account');
        insert a;
        
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();
        Source_System_Detail__c accountSSD= new Source_System_Detail__c();
        accountSSD.RecordtypeId=ssdRecorType;
        accountSSD.Name='ABC';
        accountSSD.Source_System_Name__c='ABC';
        accountSSD.Account_Name__c=a.ID;
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
        proposal.APTS_Approval_Segment__c = 'Government';
        proposal.APTS_Proposal_Business_Unit__c ='SCS';
        insert proposal;
         Apttus_Config2__ProductConfiguration__c prodConfig = APTS_TestDataFactory.createProductConfiguration(proposal.Id);
        insert prodConfig;
        
        Product2 prod = new Product2(Name = 'Test prod', 
                                     Family = 'Hardware',
                                     APTS_Media_High_Level_Code__c= '07',APTS_CAT_L3__c='L3_L030_FP',
                                     APTS_CAT_L2__c=System.Label.APTS_Clear_Product_Family,
                                     Media_High_Level__c  = 'Software'
                                    );
        insert prod; 
        Product2 prodprof = new Product2(Name='Sreenu Product Test4', ProductCode = '40666420',APTS_Corporate_Select__c='Primary',APTS_Media_High_Level_Code__c='21', Apttus_Config2__Uom__c = 'Seats',APTS_Product_Pricing_Model__c ='Per Seat');
        insert prodprof;
        proposal.APTS_Approval_Segment__c = 'Medium Law';
        update proposal;
        
        update prodConfig;
        
        Apttus_Config2__AssetLineItem__c asset1 = new Apttus_Config2__AssetLineItem__c(Name = 'Test asset', APTS_Info_PlanType__c = 'S00', APTS_SAP_MLA_Agreement_Number__c='3424343',
                                                                                    Apttus_Config2__ProductId__c=prodprof.id,   
                                                                                      Apttus_Config2__NetPrice__c = 10.00, APTS_SSD_Bill_To__c = accountSSD.Id,
                                                                                      APTS_SSD_Sold_To__c = accountSSD.Id,
                                                                                      Apttus_Config2__assetstatus__c='Activated',
                                                                                      Apttus_Config2__IsInactive__c =false,
                                                                                      Apttus_QPConfig__ProposalId__c =proposal.id,APTS_Proposal_Business_Unit__c = 'SCS',Apttus_Config2__NetUnitPrice__c=100,
                                                                                      APTS_Info_RenewalDate__c = System.today().addDays(-80),Apttus_Config2__BasePriceMethod__c = 'Per Unit');        
        List<Apttus_Config2__LineItem__c> listOfLineItems = New List<Apttus_Config2__LineItem__c>();
        List<Apttus_Config2__ProductAttributeValue__c> listofPAVs = new List<Apttus_Config2__ProductAttributeValue__c>(); 
        
        Apttus_Config2__SummaryGroup__c summaryGroup1 = new Apttus_Config2__SummaryGroup__c(
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Name = 'WEST PROFLEX Bundle A - Test group',
            Apttus_Config2__LineType__c = 'Group Total',
            Apttus_Config2__ItemSequence__c = 1,
            Apttus_Config2__LineNumber__c = 1
        );
        insert summaryGroup1;
        
        Apttus_Config2__LineItem__c linObj = new Apttus_Config2__LineItem__c(
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c = prod.id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Product/Service',
            Apttus_Config2__LineNumber__c = 1, 
            Apttus_Config2__ItemSequence__c = 1,
            Apttus_Config2__SummaryGroupId__c = summaryGroup1.id,
            //Apttus_Config2__NetPrice__c=1,
            APTS_Contract_Term__c = 'Short Term Trial',
            Apttus_Config2__IncentiveCode__c = '02',
            APTS_Bridge__c = '1 Month',
            Apttus_Config2__NetPrice__c=10.0,
            Apttus_Config2__BasePrice__c=10.0,
            Apttus_Config2__BaseExtendedPrice__c = 10.0,
            Apttus_Config2__AdjustedPrice__c = 10.0,
            Apttus_Config2__OptionPrice__c = 5.0,
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring',
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            APTS_Product_Family__c = 'CLEAR',
            APTS_Group__c = 'Bundle A',
            APTS_is_Primary_in_Bundle__c = true,
            apttus_config2__linestatus__c = 'Amended',
            Apttus_Config2__PriceAdjustment__c=0); 
        
        listOfLineItems.add(linObj);
        
            Apttus_Config2__LineItem__c linObj1 = new Apttus_Config2__LineItem__c(
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__AssetLineItemId__c=asset1.id,
            Apttus_Config2__ProductId__c = prod.id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Product/Service',
            Apttus_Config2__LineNumber__c = 1, 
            Apttus_Config2__ItemSequence__c = 1,
            Apttus_Config2__SummaryGroupId__c = summaryGroup1.id,
            //Apttus_Config2__NetPrice__c=1,
            APTS_Contract_Term__c = 'Short Term Trial',
            Apttus_Config2__IncentiveCode__c = '02',
            APTS_Bridge__c = '1 Month',
            Apttus_Config2__NetPrice__c=10.0,
            Apttus_Config2__BasePrice__c=10.0,
            Apttus_Config2__BaseExtendedPrice__c = 10.0,
            Apttus_Config2__AdjustedPrice__c = 10.0,
            Apttus_Config2__OptionPrice__c = 5.0,
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring',
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            APTS_Product_Family__c = 'CLEAR',
            APTS_Group__c = 'Bundle A',
            APTS_is_Primary_in_Bundle__c = true,
            apttus_config2__linestatus__c = 'Amended',
            Apttus_Config2__PriceAdjustment__c=0); 
        
        listOfLineItems.add(linObj1);
        
        Apttus_Config2__SummaryGroup__c summaryGroup2 = new Apttus_Config2__SummaryGroup__c(
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Name = 'WEST PROFLEX Bundle A - Test group 2',
            Apttus_Config2__LineType__c = 'Group Total',
            Apttus_Config2__ItemSequence__c = 2,
            Apttus_Config2__LineNumber__c = 1
        );
        insert summaryGroup2;
        
        
        insert listOfLineItems;
        
        //changed old account soldto to new soldto ssd
        List<Apttus_Config2__LineItem__c> lineItemsList = [SELECT Id, Name, Apttus_Config2__ProductId__c, Apttus_Config2__ConfigurationId__c, Apttus_Config2__ConfigurationId__r.APTS_SSD_Sold_To__c, Apttus_Config2__LineNumber__c,
                                                           Apttus_Config2__ItemSequence__c, Apttus_Config2__LineType__c, Apttus_Config2__LineStatus__c 
                                                           FROM Apttus_Config2__LineItem__c 
                                                           WHERE Apttus_Config2__ConfigurationId__c = :prodConfig.id];      
        
        System.assert(lineItemsList!= null && lineItemsList.size()>0);      
        
        Test.startTest();
        //APTS_ProductConfigurationTriggerHandler.afterUpdate = false;
        prodConfig.Apttus_Config2__Status__c = 'New';
        update prodConfig;
        
        APTS_ProductConfigurationTriggerHandler.afterUpdate = false;
        checkRecursive.afterUpdate = True;
        prodConfig.Apttus_Config2__Status__c = 'Finalized';
        prodConfig.APTS_Least_Contract_Term__c=2;
        update prodConfig;
        Test.stopTest();
        
        list<APTS_Dynamic_Bundle__c> pplList = [SELECT Id FROM APTS_Dynamic_Bundle__c WHERE APTS_Quote_Proposal__c = :proposal.Id ];
        
        
    }
    
    @isTest
    static void testTK1() {
        
        
        
        List<APTS_Segment_Threshold__c> segthrList= new List<APTS_Segment_Threshold__c>();
        //Add Segment threshold
        APTS_Segment_Threshold__c seg1 = new APTS_Segment_Threshold__c();
        seg1.APTS_Approval_Required__c=True;
        seg1.APTS_Segment__c='Small Law';
        seg1.APTS_Customer_Category__c='0';
        seg1.APTS_Term_in_years__c=Integer.ValueOf('2');
        seg1.APTS_Minimum_OY_Increase__c=Integer.ValueOf('5');
        String myNumber = '15.00';
        String myTruncatedNumber = myNumber.subString(0,myNumber.indexOf('.')+3);
        Decimal d = Decimal.valueOf(myTruncatedNumber);
        System.debug(d);
        seg1.APTS_Minimum_Incremental_Growth__c=d;
        segthrList.add(seg1);
        
        APTS_Segment_Threshold__c seg2 = new APTS_Segment_Threshold__c();
        seg2.APTS_Approval_Required__c=True;
        seg2.APTS_Segment__c='Corporate';
        seg2.APTS_Customer_Category__c='0';
        seg2.APTS_Term_in_years__c=Integer.ValueOf('2');
        seg2.APTS_Minimum_OY_Increase__c=Integer.ValueOf('5');
        
        String myNumber2 = '15.00';
        String myTruncatedNumber2 = myNumber2.subString(0,myNumber2.indexOf('.')+3);
        Decimal d2 = Decimal.valueOf(myTruncatedNumber2);
        System.debug(d);
        seg2.APTS_Minimum_Incremental_Growth__c=d2;
        segthrList.add(seg2);
        
        
        APTS_Segment_Threshold__c seg3 = new APTS_Segment_Threshold__c();
        seg3.APTS_Approval_Required__c=True;
        seg3.APTS_Segment__c='Government';
        seg3.APTS_Customer_Category__c='0';
        seg3.APTS_Term_in_years__c=Integer.ValueOf('2');
        seg3.APTS_Minimum_OY_Increase__c=Integer.ValueOf('5');
        String myNumber3 = '15.00';
        String myTruncatedNumber3 = myNumber3.subString(0,myNumber3.indexOf('.')+3);
        Decimal d3 = Decimal.valueOf(myTruncatedNumber3);
        System.debug(d);
        seg3.APTS_Minimum_Incremental_Growth__c=d3;
        segthrList.add(seg3);
        insert segthrList;
        
        
        Apttus_Config2__PriceList__c priceList = APTS_TestDataFactory.createPriceList('Thomson Reuters Master - US Legal');
        insert priceList;
        
        Apttus_Config2__PriceListItem__c pliSO = new Apttus_Config2__PriceListItem__c();
        pliSO.Apttus_Config2__Active__c = true;
        pliSO.Apttus_Config2__PriceListId__c = priceList.Id;
        pliSO.APTS_Max_Fill_Up_Price__c = 5;
        insert pliSO;
        
        
        WebServiceSettings__c oWebServiceSettings = new WebServiceSettings__c();
        oWebServiceSettings.Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable'; 
        oWebServiceSettings.Name = 'PaymentCreditIncrease'; 
        oWebServiceSettings.Timeout__c = 120; 
        oWebServiceSettings.Endpoint__c = 'https://dev.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease'; 
        oWebServiceSettings.Active__c = true;
        insert oWebServiceSettings;
        //Inserting keyvaluestore
        List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c=System.Label.APTS_OC_Test_Id),
        new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other'),
        new KeyValueListStore__c(Name='LCRMDisableStrikeIronServices',TextValue__c='false')};
        insert keyvaluestore;
        
        //Inserting record list 
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
        
        
        Account a = APTS_TestDataFactory.createAccount('Test Account');
        insert a;
        
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();
        Source_System_Detail__c accountSSD= new Source_System_Detail__c();
        accountSSD.RecordtypeId=ssdRecorType;
        accountSSD.Name='ABC';
        accountSSD.Source_System_Name__c='ABC';
        accountSSD.Account_Name__c=a.ID;
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
        proposal.APTS_Approval_Segment__c = 'Government';
        proposal.APTS_Proposal_Business_Unit__c ='SCS';
        proposal.APTS_LMS_Catalog__c = true;
        insert proposal;
         Apttus_Config2__ProductConfiguration__c prodConfig = APTS_TestDataFactory.createProductConfiguration(proposal.Id);
        insert prodConfig;
        
        Product2 prod = new Product2(Name = 'Test prod', 
                                     Family = 'Hardware',
                                     APTS_Media_High_Level_Code__c= '07',APTS_Cat_L3__c = System.Label.APTS_Ediscovery_Product_Family,
                                     Media_High_Level__c  = 'Software'
                                    );
        insert prod; 
        
        proposal.APTS_Approval_Segment__c = 'Medium Law';
        update proposal;
        update prodConfig;
        
        
        List<Apttus_Config2__LineItem__c> listOfLineItems = New List<Apttus_Config2__LineItem__c>();
        List<Apttus_Config2__ProductAttributeValue__c> listofPAVs = new List<Apttus_Config2__ProductAttributeValue__c>(); 
        
        Apttus_Config2__SummaryGroup__c summaryGroup1 = new Apttus_Config2__SummaryGroup__c(
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Name = 'WEST PROFLEX Bundle A - Test group',
            Apttus_Config2__LineType__c = 'Group Total',
            Apttus_Config2__ItemSequence__c = 1,
            Apttus_Config2__LineNumber__c = 1
        );
        insert summaryGroup1;
        
        Apttus_Config2__LineItem__c linObj = new Apttus_Config2__LineItem__c(
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c = prod.id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Product/Service',
            Apttus_Config2__LineNumber__c = 1, 
            Apttus_Config2__ItemSequence__c = 1,
            Apttus_Config2__SummaryGroupId__c = summaryGroup1.id,
            //Apttus_Config2__NetPrice__c=1,
            APTS_Contract_Term__c = 'Short Term Trial',
            Apttus_Config2__IncentiveCode__c = '02',
            APTS_Bridge__c = '1 Month',
            Apttus_Config2__NetPrice__c=10.0,
            Apttus_Config2__BasePrice__c=10.0,
            Apttus_Config2__BaseExtendedPrice__c = 10.0,
            Apttus_Config2__AdjustedPrice__c = 10.0,
            Apttus_Config2__OptionPrice__c = 5.0,
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring',
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            APTS_Product_Family__c = 'CLEAR',
            Apttus_Config2__PriceAdjustment__c=0); 
        
        listOfLineItems.add(linObj);
        
        Apttus_Config2__SummaryGroup__c summaryGroup2 = new Apttus_Config2__SummaryGroup__c(
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Name = 'WEST PROFLEX Bundle A - Test group 2',
            Apttus_Config2__LineType__c = 'Group Total',
            Apttus_Config2__ItemSequence__c = 2,
            Apttus_Config2__LineNumber__c = 1
        );
        insert summaryGroup2;
        
        
        insert listOfLineItems;
        
        //changed old account soldto to new soldto ssd
        List<Apttus_Config2__LineItem__c> lineItemsList = [SELECT Id, Name, Apttus_Config2__ProductId__c, Apttus_Config2__ConfigurationId__c, Apttus_Config2__ConfigurationId__r.APTS_SSD_Sold_To__c, Apttus_Config2__LineNumber__c,
                                                           Apttus_Config2__ItemSequence__c, Apttus_Config2__LineType__c, Apttus_Config2__LineStatus__c 
                                                           FROM Apttus_Config2__LineItem__c 
                                                           WHERE Apttus_Config2__ConfigurationId__c = :prodConfig.id];      
        
        System.assert(lineItemsList!= null && lineItemsList.size()>0);      
        
        Test.startTest();
        //APTS_ProductConfigurationTriggerHandler.afterUpdate = false;
        prodConfig.Apttus_Config2__Status__c = 'New';
        update prodConfig;
        
        APTS_ProductConfigurationTriggerHandler.afterUpdate = false;
        checkRecursive.afterUpdate = True;
        prodConfig.Apttus_Config2__Status__c = 'Finalized';
        prodConfig.APTS_Least_Contract_Term__c=2;
        update prodConfig;
        Test.stopTest();
        
        list<APTS_Dynamic_Bundle__c> pplList = [SELECT Id FROM APTS_Dynamic_Bundle__c WHERE APTS_Quote_Proposal__c = :proposal.Id ];
        
        
    }
    
     @isTest
    static void testTK2() {
        
        
        
        List<APTS_Segment_Threshold__c> segthrList= new List<APTS_Segment_Threshold__c>();
        //Add Segment threshold
        APTS_Segment_Threshold__c seg1 = new APTS_Segment_Threshold__c();
        seg1.APTS_Approval_Required__c=True;
        seg1.APTS_Segment__c='Small Law';
        seg1.APTS_Customer_Category__c='0';
        seg1.APTS_Term_in_years__c=Integer.ValueOf('2');
        seg1.APTS_Minimum_OY_Increase__c=Integer.ValueOf('5');
        String myNumber = '15.00';
        String myTruncatedNumber = myNumber.subString(0,myNumber.indexOf('.')+3);
        Decimal d = Decimal.valueOf(myTruncatedNumber);
        System.debug(d);
        seg1.APTS_Minimum_Incremental_Growth__c=d;
        segthrList.add(seg1);
        
        APTS_Segment_Threshold__c seg2 = new APTS_Segment_Threshold__c();
        seg2.APTS_Approval_Required__c=True;
        seg2.APTS_Segment__c='Corporate';
        seg2.APTS_Customer_Category__c='0';
        seg2.APTS_Term_in_years__c=Integer.ValueOf('2');
        seg2.APTS_Minimum_OY_Increase__c=Integer.ValueOf('5');
        
        String myNumber2 = '15.00';
        String myTruncatedNumber2 = myNumber2.subString(0,myNumber2.indexOf('.')+3);
        Decimal d2 = Decimal.valueOf(myTruncatedNumber2);
        System.debug(d);
        seg2.APTS_Minimum_Incremental_Growth__c=d2;
        segthrList.add(seg2);
        
        
        APTS_Segment_Threshold__c seg3 = new APTS_Segment_Threshold__c();
        seg3.APTS_Approval_Required__c=True;
        seg3.APTS_Segment__c='Government';
        seg3.APTS_Customer_Category__c='0';
        seg3.APTS_Term_in_years__c=Integer.ValueOf('2');
        seg3.APTS_Minimum_OY_Increase__c=Integer.ValueOf('5');
        String myNumber3 = '15.00';
        String myTruncatedNumber3 = myNumber3.subString(0,myNumber3.indexOf('.')+3);
        Decimal d3 = Decimal.valueOf(myTruncatedNumber3);
        System.debug(d);
        seg3.APTS_Minimum_Incremental_Growth__c=d3;
        segthrList.add(seg3);
        insert segthrList;
        
        
        Apttus_Config2__PriceList__c priceList = APTS_TestDataFactory.createPriceList('Thomson Reuters Master - US Legal');
        insert priceList;
        
        Apttus_Config2__PriceListItem__c pliSO = new Apttus_Config2__PriceListItem__c();
        pliSO.Apttus_Config2__Active__c = true;
        pliSO.Apttus_Config2__PriceListId__c = priceList.Id;
        pliSO.APTS_Max_Fill_Up_Price__c = 5;
        insert pliSO;
        
        
        WebServiceSettings__c oWebServiceSettings = new WebServiceSettings__c();
        oWebServiceSettings.Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable'; 
        oWebServiceSettings.Name = 'PaymentCreditIncrease'; 
        oWebServiceSettings.Timeout__c = 120; 
        oWebServiceSettings.Endpoint__c = 'https://dev.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease'; 
        oWebServiceSettings.Active__c = true;
        insert oWebServiceSettings;
        //Inserting keyvaluestore
        List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c=System.Label.APTS_OC_Test_Id),
        new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other'),
        new KeyValueListStore__c(Name='LCRMDisableStrikeIronServices',TextValue__c='false')};
        insert keyvaluestore;
        
        //Inserting record list 
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
        
        
        Account a = APTS_TestDataFactory.createAccount('Test Account');
        insert a;
        
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();
        Source_System_Detail__c accountSSD= new Source_System_Detail__c();
        accountSSD.RecordtypeId=ssdRecorType;
        accountSSD.Name='ABC';
        accountSSD.Source_System_Name__c='ABC';
        accountSSD.Account_Name__c=a.ID;
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
        proposal.APTS_Approval_Segment__c = 'Government';
        proposal.APTS_Proposal_Business_Unit__c ='SCS';
        proposal.APTS_LMS_Catalog__c = true;
        insert proposal;
         Apttus_Config2__ProductConfiguration__c prodConfig = APTS_TestDataFactory.createProductConfiguration(proposal.Id);
        insert prodConfig;
        
        Product2 prod = new Product2(Name = 'Test prod', 
                                     Family = 'Hardware',
                                     APTS_Media_High_Level_Code__c= '07',APTS_Cat_L3__c = System.Label.APTS_Ediscovery_Product_Family,
                                     Media_High_Level__c  = 'Software'
                                    );
        insert prod; 
        
        proposal.APTS_Approval_Segment__c = 'Medium Law';
        update proposal;
        update prodConfig;
        
        
        List<Apttus_Config2__LineItem__c> listOfLineItems = New List<Apttus_Config2__LineItem__c>();
        List<Apttus_Config2__ProductAttributeValue__c> listofPAVs = new List<Apttus_Config2__ProductAttributeValue__c>(); 
        
        Apttus_Config2__SummaryGroup__c summaryGroup1 = new Apttus_Config2__SummaryGroup__c(
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Name = 'WEST PROFLEX Bundle A - Test group',
            Apttus_Config2__LineType__c = 'Group Total',
            Apttus_Config2__ItemSequence__c = 1,
            Apttus_Config2__LineNumber__c = 1
        );
        insert summaryGroup1;
        
        Apttus_Config2__LineItem__c linObj = new Apttus_Config2__LineItem__c(
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c = prod.id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Product/Service',
            Apttus_Config2__LineNumber__c = 1, 
            Apttus_Config2__ItemSequence__c = 1,
            Apttus_Config2__SummaryGroupId__c = summaryGroup1.id,
            //Apttus_Config2__NetPrice__c=1,
            APTS_Contract_Term__c = 'Short Term Trial',
            Apttus_Config2__IncentiveCode__c = '02',
            APTS_Bridge__c = '1 Month',
            Apttus_Config2__NetPrice__c=10.0,
            Apttus_Config2__BasePrice__c=10.0,
            Apttus_Config2__BaseExtendedPrice__c = 10.0,
            Apttus_Config2__AdjustedPrice__c = 10.0,
            Apttus_Config2__OptionPrice__c = 5.0,
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring',
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            APTS_Product_Family__c = 'CLEAR',
            apttus_config2__linestatus__c = 'Renewed',
            Apttus_Config2__PriceAdjustment__c=0); 
        
        listOfLineItems.add(linObj);
        
        Apttus_Config2__SummaryGroup__c summaryGroup2 = new Apttus_Config2__SummaryGroup__c(
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Name = 'WEST PROFLEX Bundle A - Test group 2',
            Apttus_Config2__LineType__c = 'Group Total',
            Apttus_Config2__ItemSequence__c = 2,
            Apttus_Config2__LineNumber__c = 1
        );
        insert summaryGroup2;
        
        
        insert listOfLineItems;
        
        //changed old account soldto to new soldto ssd
        List<Apttus_Config2__LineItem__c> lineItemsList = [SELECT Id, Name, Apttus_Config2__ProductId__c, Apttus_Config2__ConfigurationId__c, Apttus_Config2__ConfigurationId__r.APTS_SSD_Sold_To__c, Apttus_Config2__LineNumber__c,
                                                           Apttus_Config2__ItemSequence__c, Apttus_Config2__LineType__c, Apttus_Config2__LineStatus__c 
                                                           FROM Apttus_Config2__LineItem__c 
                                                           WHERE Apttus_Config2__ConfigurationId__c = :prodConfig.id];      
        
        System.assert(lineItemsList!= null && lineItemsList.size()>0);      
        
        Test.startTest();
        //APTS_ProductConfigurationTriggerHandler.afterUpdate = false;
        prodConfig.Apttus_Config2__Status__c = 'New';
        update prodConfig;
        
        APTS_ProductConfigurationTriggerHandler.afterUpdate = false;
        checkRecursive.afterUpdate = True;
        prodConfig.Apttus_Config2__Status__c = 'Finalized';
        prodConfig.APTS_Least_Contract_Term__c=2;
        update prodConfig;
        Test.stopTest();
        
        list<APTS_Dynamic_Bundle__c> pplList = [SELECT Id FROM APTS_Dynamic_Bundle__c WHERE APTS_Quote_Proposal__c = :proposal.Id ];
        
        
    }
    @isTest
    static void testpromoCheck() {
        
        
        
        List<APTS_Segment_Threshold__c> segthrList= new List<APTS_Segment_Threshold__c>();
        //Add Segment threshold
        APTS_Segment_Threshold__c seg1 = new APTS_Segment_Threshold__c();
        seg1.APTS_Approval_Required__c=True;
        seg1.APTS_Segment__c='Small Law';
        seg1.APTS_Customer_Category__c='0';
        seg1.APTS_Term_in_years__c=Integer.ValueOf('2');
        seg1.APTS_Minimum_OY_Increase__c=Integer.ValueOf('5');
        String myNumber = '15.00';
        String myTruncatedNumber = myNumber.subString(0,myNumber.indexOf('.')+3);
        Decimal d = Decimal.valueOf(myTruncatedNumber);
        System.debug(d);
        seg1.APTS_Minimum_Incremental_Growth__c=d;
        segthrList.add(seg1);
        
        APTS_Segment_Threshold__c seg2 = new APTS_Segment_Threshold__c();
        seg2.APTS_Approval_Required__c=True;
        seg2.APTS_Segment__c='Corporate';
        seg2.APTS_Customer_Category__c='0';
        seg2.APTS_Term_in_years__c=Integer.ValueOf('2');
        seg2.APTS_Minimum_OY_Increase__c=Integer.ValueOf('5');
        
        String myNumber2 = '15.00';
        String myTruncatedNumber2 = myNumber2.subString(0,myNumber2.indexOf('.')+3);
        Decimal d2 = Decimal.valueOf(myTruncatedNumber2);
        System.debug(d);
        seg2.APTS_Minimum_Incremental_Growth__c=d2;
        segthrList.add(seg2);
        
        
        APTS_Segment_Threshold__c seg3 = new APTS_Segment_Threshold__c();
        seg3.APTS_Approval_Required__c=True;
        seg3.APTS_Segment__c='Government';
        seg3.APTS_Customer_Category__c='0';
        seg3.APTS_Term_in_years__c=Integer.ValueOf('2');
        seg3.APTS_Minimum_OY_Increase__c=Integer.ValueOf('5');
        String myNumber3 = '15.00';
        String myTruncatedNumber3 = myNumber3.subString(0,myNumber3.indexOf('.')+3);
        Decimal d3 = Decimal.valueOf(myTruncatedNumber3);
        System.debug(d);
        seg3.APTS_Minimum_Incremental_Growth__c=d3;
        segthrList.add(seg3);
        insert segthrList;
        
        
        Apttus_Config2__PriceList__c priceList = APTS_TestDataFactory.createPriceList('Thomson Reuters Master - US Legal');
        insert priceList;
        
        Apttus_Config2__PriceListItem__c pliSO = new Apttus_Config2__PriceListItem__c();
        pliSO.Apttus_Config2__Active__c = true;
        pliSO.Apttus_Config2__PriceListId__c = priceList.Id;
        pliSO.APTS_Max_Fill_Up_Price__c = 5;
        insert pliSO;
        
        
        WebServiceSettings__c oWebServiceSettings = new WebServiceSettings__c();
        oWebServiceSettings.Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable'; 
        oWebServiceSettings.Name = 'PaymentCreditIncrease'; 
        oWebServiceSettings.Timeout__c = 120; 
        oWebServiceSettings.Endpoint__c = 'https://dev.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease'; 
        oWebServiceSettings.Active__c = true;
        insert oWebServiceSettings;
        //Inserting keyvaluestore
        KeyValueListStore__c keyvaluestore=new  KeyValueListStore__c();
        keyvaluestore.Name='ANZUsersProfileId';
        keyvaluestore.TextValue__c=System.Label.APTS_OC_Test_Id;
        insert keyvaluestore;
        //Inserting record list 
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
        
        
        Account a = APTS_TestDataFactory.createAccount('Test Account');
        insert a;
        
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();
        Source_System_Detail__c accountSSD= new Source_System_Detail__c();
        accountSSD.RecordtypeId=ssdRecorType;
        accountSSD.Name='ABC';
        accountSSD.Source_System_Name__c='ABC';
        accountSSD.Account_Name__c=a.ID;
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
        insert proposal;
        Apttus_Config2__ProductConfiguration__c prodConfig = APTS_TestDataFactory.createProductConfiguration(proposal.Id);
        insert prodConfig;
        
        Product2 prod = new Product2(Name = 'Test prod', 
                                     Family = 'Hardware',
                                     APTS_Media_High_Level_Code__c= '07'
                                    );
        insert prod; 
        
        System.debug('prod+++++' + prod);
        
        
        proposal.APTS_Approval_Segment__c = 'Government';
        update proposal;
        update prodConfig;
        
        
        
        List<Apttus_Config2__LineItem__c> listOfLineItems = New List<Apttus_Config2__LineItem__c>();
        List<Apttus_Config2__ProductAttributeValue__c> listofPAVs = new List<Apttus_Config2__ProductAttributeValue__c>(); 
        
        Apttus_Config2__SummaryGroup__c summaryGroup1 = new Apttus_Config2__SummaryGroup__c(
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Name = 'WEST PROFLEX Bundle A - Test group',
            Apttus_Config2__LineType__c = 'Group Total',
            Apttus_Config2__ItemSequence__c = 1,
            Apttus_Config2__LineNumber__c = 1
        );
        insert summaryGroup1;
        
        Apttus_Config2__LineItem__c linObj = new Apttus_Config2__LineItem__c(
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Product/Service',
            Apttus_Config2__LineNumber__c = 1, 
            Apttus_Config2__ItemSequence__c = 1,
            Apttus_Config2__SummaryGroupId__c = summaryGroup1.id,
            //Apttus_Config2__NetPrice__c=1,
            APTS_Contract_Term__c = 'Short Term Trial',
            Apttus_Config2__IncentiveCode__c = '02',
            APTS_Bridge__c = '1 Month',
            Apttus_Config2__NetPrice__c=10.0,
            Apttus_Config2__BasePrice__c=10.0,
            Apttus_Config2__BaseExtendedPrice__c = 10.0,
            Apttus_Config2__AdjustedPrice__c = 10.0,
            Apttus_Config2__OptionPrice__c = 5.0,
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring',
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__PriceAdjustment__c=0); 
        
        
        
        listOfLineItems.add(linObj);
        insert listOfLineItems;
        
        proposal.APTS_Approval_Segment__c ='Medium Law';
        update proposal;
        update prodConfig;
        
        Apttus_Config2__SummaryGroup__c summaryGroup2 = new Apttus_Config2__SummaryGroup__c(
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Name = 'WEST PROFLEX Bundle A - Test group 2',
            Apttus_Config2__LineType__c = 'Group Total',
            Apttus_Config2__ItemSequence__c = 2,
            Apttus_Config2__LineNumber__c = 1
        );
        insert summaryGroup2;
        
        List <Apttus_Config2__Incentive__c> incentiveList = New List<Apttus_Config2__Incentive__c >();
        Apttus_Config2__Incentive__c incentive1 = new Apttus_Config2__Incentive__c(Name = 'Test Promo1',Apttus_Config2__Sequence__c =1,Minimum_Incremental_override__c =3,Impacted_Approvals__c ='Minimum Incremental Growth');
        Apttus_Config2__Incentive__c incentive2 = new Apttus_Config2__Incentive__c(Name = 'Test Promo2',Apttus_Config2__Sequence__c =1,Minimum_Incremental_override__c =4,Impacted_Approvals__c ='Minimum Incremental Growth');
        Apttus_Config2__Incentive__c incentive3 = new Apttus_Config2__Incentive__c(Name = 'Test Promo3',Apttus_Config2__Sequence__c =1,Minimum_Incremental_override__c =5,Impacted_Approvals__c ='Minimum Incremental Growth');
        
        incentiveList.add(incentive1);
        incentiveList.add(incentive2);
        incentiveList.add(incentive3);
        
        insert incentiveList;
        
        List<Apttus_Config2__AdjustmentLineItem__c> adjustmentLi = New List<Apttus_Config2__AdjustmentLineItem__c>();
        Apttus_Config2__AdjustmentLineItem__c adLi1 = new Apttus_Config2__AdjustmentLineItem__c(Apttus_Config2__LineItemId__c= linObj.id,Apttus_Config2__LineNumber__c = linObj.Apttus_Config2__LineNumber__c , Apttus_Config2__IncentiveCode__c = incentive1.Name , Apttus_Config2__IncentiveId__c = incentive1.id);
        Apttus_Config2__AdjustmentLineItem__c adLi2 = new Apttus_Config2__AdjustmentLineItem__c(Apttus_Config2__LineItemId__c= linObj.id,Apttus_Config2__LineNumber__c = linObj.Apttus_Config2__LineNumber__c , Apttus_Config2__IncentiveCode__c = incentive2.Name , Apttus_Config2__IncentiveId__c = incentive2.id);
        Apttus_Config2__AdjustmentLineItem__c adLi3 = new Apttus_Config2__AdjustmentLineItem__c(Apttus_Config2__LineItemId__c= linObj.id,Apttus_Config2__LineNumber__c = linObj.Apttus_Config2__LineNumber__c , Apttus_Config2__IncentiveCode__c = incentive3.Name , Apttus_Config2__IncentiveId__c = incentive3.id);
        
        
        
        adjustmentLi.add(adLi1);
        adjustmentLi.add(adLi2);
        adjustmentLi.add(adLi3);
        
        insert adjustmentLi;
        
        
        //changed old account soldto to new soldto ssd
        List<Apttus_Config2__LineItem__c> lineItemsList = [SELECT Id, Name, Apttus_Config2__ProductId__c, Apttus_Config2__ConfigurationId__c, Apttus_Config2__ConfigurationId__r.APTS_SSD_Sold_To__c, Apttus_Config2__LineNumber__c,
                                                           Apttus_Config2__ItemSequence__c, Apttus_Config2__LineType__c, Apttus_Config2__LineStatus__c 
                                                           FROM Apttus_Config2__LineItem__c 
                                                           WHERE Apttus_Config2__ConfigurationId__c = :prodConfig.id];      
        
        System.assert(lineItemsList!= null && lineItemsList.size()>0);      
        
        Test.startTest();
        //APTS_ProductConfigurationTriggerHandler.afterUpdate = false;
        prodConfig.Apttus_Config2__Status__c = 'New';
        update prodConfig;
        
        APTS_ProductConfigurationTriggerHandler.afterUpdate = false;
        checkRecursive.afterUpdate = True;
        prodConfig.Apttus_Config2__Status__c = 'Finalized';
        prodConfig.APTS_Least_Contract_Term__c=2;
        update prodConfig;
        
        Test.stopTest();
        
        
        list<APTS_Dynamic_Bundle__c> pplList = [SELECT Id FROM APTS_Dynamic_Bundle__c WHERE APTS_Quote_Proposal__c = :proposal.Id ];
        //System.assert(pplList!= null && pplList.size()>0);
        
    }
    @isTest
    static void testApprovalCheckCanada() {
        
        
        
        List<APTS_Segment_Threshold__c> segthrList= new List<APTS_Segment_Threshold__c>();
        //Add Segment threshold
        APTS_Segment_Threshold__c seg1 = new APTS_Segment_Threshold__c();
        seg1.APTS_Approval_Required__c=True;
        seg1.APTS_Segment__c='Small Law';
        seg1.APTS_Customer_Category__c='0';
        seg1.APTS_Term_in_years__c=Integer.ValueOf('2');
        seg1.APTS_Minimum_OY_Increase__c=Integer.ValueOf('5');
        seg1.APTS_Product_Family__c='CLEAR';
        String myNumber = '15.00';
        String myTruncatedNumber = myNumber.subString(0,myNumber.indexOf('.')+3);
        Decimal d = Decimal.valueOf(myTruncatedNumber);
        System.debug(d);
        seg1.APTS_Minimum_Incremental_Growth__c=d;
        segthrList.add(seg1);
        
        APTS_Segment_Threshold__c seg2 = new APTS_Segment_Threshold__c();
        seg2.APTS_Approval_Required__c=True;
        seg2.APTS_Segment__c='Corporate';
        seg2.APTS_Customer_Category__c='0';
        seg2.APTS_Term_in_years__c=Integer.ValueOf('2');
        seg2.APTS_Minimum_OY_Increase__c=Integer.ValueOf('5');
        
        String myNumber2 = '15.00';
        String myTruncatedNumber2 = myNumber2.subString(0,myNumber2.indexOf('.')+3);
        Decimal d2 = Decimal.valueOf(myTruncatedNumber2);
        System.debug(d);
        seg2.APTS_Minimum_Incremental_Growth__c=d2;
        segthrList.add(seg2);
        
        
        APTS_Segment_Threshold__c seg3 = new APTS_Segment_Threshold__c();
        seg3.APTS_Approval_Required__c=True;
        seg3.APTS_Segment__c='Government';
        seg3.APTS_Customer_Category__c='0';
        seg3.APTS_Term_in_years__c=Integer.ValueOf('2');
        seg3.APTS_Minimum_OY_Increase__c=Integer.ValueOf('5');
        String myNumber3 = '15.00';
        String myTruncatedNumber3 = myNumber3.subString(0,myNumber3.indexOf('.')+3);
        Decimal d3 = Decimal.valueOf(myTruncatedNumber3);
        System.debug(d);
        seg3.APTS_Minimum_Incremental_Growth__c=d3;
        segthrList.add(seg3);
        insert segthrList;
        
        Apttus_Config2__PriceList__c priceList = APTS_TestDataFactory.createPriceList('Thomson Reuters Master - US Legal');
        insert priceList;
        
        Apttus_Config2__PriceListItem__c pliSO = new Apttus_Config2__PriceListItem__c();
        pliSO.Apttus_Config2__Active__c = true;
        pliSO.Apttus_Config2__PriceListId__c = priceList.Id;
        pliSO.APTS_Max_Fill_Up_Price__c = 5;
        insert pliSO;
        
        
        WebServiceSettings__c oWebServiceSettings = new WebServiceSettings__c();
        oWebServiceSettings.Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable'; 
        oWebServiceSettings.Name = 'PaymentCreditIncrease'; 
        oWebServiceSettings.Timeout__c = 120; 
        oWebServiceSettings.Endpoint__c = 'https://dev.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease'; 
        oWebServiceSettings.Active__c = true;
        insert oWebServiceSettings;
        //Inserting keyvaluestore
        List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c=System.Label.APTS_OC_Test_Id),
        new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other'),
        new KeyValueListStore__c(Name='LCRMDisableStrikeIronServices',TextValue__c='false')};
        insert keyvaluestore;
        
        //Inserting record list 
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
        
        Account a = APTS_TestDataFactory.createAccount('Test Account');
        insert a;
        
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();
        Source_System_Detail__c accountSSD= new Source_System_Detail__c();
        accountSSD.RecordtypeId=ssdRecorType;
        accountSSD.Name='ABC';
        accountSSD.Source_System_Name__c='ABC';
        accountSSD.Account_Name__c=a.ID;
        accountSSD.Account_Inactive__c=false;
        accountSSD.LCRM_Sales_Org__c='CARS';
        insert accountSSD;
        
        Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        Opportunity oppty=APTS_TestDataFactory.createOpportunity('abc',a.id,'Needs Analysis',Date.Today());
        oppty.RecordtypeId=opptyRecorType;
        oppty.Source_System_Detail__c=accountSSD.id;
        oppty.Account=a;
        insert oppty;
        
        Apttus_Proposal__Proposal__c proposal = APTS_TestDataFactory.createProposal(oppty.id, accountSSD.Id);
        proposal.APTS_Approval_Segment__c = 'Canada';
        proposal.APTS_Proposal_Business_Unit__c ='Canada' ;
        insert proposal;
        Apttus_Config2__ProductConfiguration__c prodConfig = APTS_TestDataFactory.createProductConfiguration(proposal.Id);
        insert prodConfig;
        
        List<Product2> listOfProducts=new List<Product2>(); 
        Product2 prod1 = new Product2(Name='Sreenu Product Test', ProductCode = '41055954',APTS_Corporate_Select__c='Primary',APTS_Media_Lower_Level_Code__c = 'I9',APTS_Media_High_Level_Code__c='06', Apttus_Config2__Uom__c = 'Attorneys',APTS_Product_Pricing_Model__c ='BENEFITGRP');
        Product2 prod2 = new Product2(Name='Sreenu Product Test2', ProductCode = '41055955',APTS_Corporate_Select__c='Primary',APTS_Media_High_Level_Code__c='07', Apttus_Config2__Uom__c = 'Attorneys',APTS_Product_Pricing_Model__c ='Banded');
        Product2 prod3 = new Product2(Name='Sreenu Product Test3', ProductCode = '41055956',APTS_Corporate_Select__c='Primary',APTS_Media_High_Level_Code__c='21', Apttus_Config2__Uom__c = 'Seats',APTS_Product_Pricing_Model__c ='Per Seat');
        listOfProducts.add(prod1);
        listOfProducts.add(prod2);
        listOfProducts.add(prod3);       
        
        insert listOfProducts;
        
        proposal.APTS_Approval_Segment__c = 'Medium Law';
        update proposal;
        update prodConfig;
        
        List<Apttus_Config2__LineItem__c> listOfLineItems = New List<Apttus_Config2__LineItem__c>();
        
        Apttus_Config2__LineItem__c linObj1 = new Apttus_Config2__LineItem__c(
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Product/Service',
            Apttus_Config2__LineNumber__c = 1, 
            Apttus_Config2__ItemSequence__c = 1,
            Apttus_Config2__ProductId__c=prod1.id,
            APTS_Contract_Term__c = 'Short Term Trial',
            Apttus_Config2__IncentiveCode__c = '02',
            APTS_Bridge__c = '1 Month',
            Apttus_Config2__NetPrice__c=10.0,
            Apttus_Config2__BasePrice__c=10.0,
            Apttus_Config2__BaseExtendedPrice__c = 10.0,
            Apttus_Config2__AdjustedPrice__c = 10.0,
            Apttus_Config2__OptionPrice__c = 5.0,
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring',
            Apttus_Config2__ChargeType__c = 'Subscription Fee',            
            Apttus_Config2__PriceAdjustment__c=0); 
        
        listOfLineItems.add(linObj1);
        
        
        Apttus_Config2__LineItem__c linObj2 = new Apttus_Config2__LineItem__c(
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Product/Service',
            Apttus_Config2__LineNumber__c = 1, 
            Apttus_Config2__ItemSequence__c = 1,
            Apttus_Config2__ProductId__c=prod2.id,
            APTS_Contract_Term__c = 'Short Term Trial',
            Apttus_Config2__IncentiveCode__c = '02',
            APTS_Bridge__c = '1 Month',
            Apttus_Config2__NetPrice__c=10.0,
            Apttus_Config2__BasePrice__c=10.0,
            Apttus_Config2__BaseExtendedPrice__c = 10.0,
            Apttus_Config2__AdjustedPrice__c = 10.0,
            Apttus_Config2__OptionPrice__c = 5.0,
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring',
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            //APTS_Group__c='Bundle A',
            Apttus_Config2__PriceAdjustment__c=0);         
        listOfLineItems.add(linObj2);
               
        Apttus_Config2__LineItem__c linObj3 = new Apttus_Config2__LineItem__c(
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Product/Service',
            Apttus_Config2__LineNumber__c = 1, 
            Apttus_Config2__ItemSequence__c = 1,
            Apttus_Config2__ProductId__c=prod3.id,            
            APTS_Contract_Term__c = 'Short Term Trial',
            Apttus_Config2__IncentiveCode__c = '02',
            APTS_Bridge__c = '1 Month',
            Apttus_Config2__NetPrice__c=10.0,
            Apttus_Config2__BasePrice__c=10.0,
            Apttus_Config2__BaseExtendedPrice__c = 10.0,
            Apttus_Config2__AdjustedPrice__c = 10.0,
            Apttus_Config2__OptionPrice__c = 5.0,
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring',
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            //APTS_Group__c='Bundle B',
            Apttus_Config2__PriceAdjustment__c=0); 
        
        listOfLineItems.add(linObj3); 
            insert listOfLineItems;
        
        //changed old account soldto to new soldto ssd
        List<Apttus_Config2__LineItem__c> lineItemsList = [SELECT Id, Name, Apttus_Config2__ProductId__c, Apttus_Config2__ConfigurationId__c, Apttus_Config2__ConfigurationId__r.APTS_SSD_Sold_To__c, Apttus_Config2__LineNumber__c,
                                                           Apttus_Config2__ItemSequence__c, Apttus_Config2__LineType__c, Apttus_Config2__LineStatus__c 
                                                           FROM Apttus_Config2__LineItem__c 
                                                           WHERE Apttus_Config2__ConfigurationId__c = :prodConfig.id];      
        
        System.assert(lineItemsList!= null && lineItemsList.size()>0);      
        
        Test.startTest();
        prodConfig.Apttus_Config2__Status__c = 'New';
        update prodConfig;
        
        APTS_ProductConfigurationTriggerHandler.afterUpdate = false;
        checkRecursive.afterUpdate = True;
        prodConfig.APTS_Incremental_Growth__c= -1;
        prodConfig.Apttus_Config2__Status__c = 'Finalized';
        update prodConfig;
        Test.stopTest();
    }
   
     @isTest
    static void testapprovalsegmentSmallLaw() {
    
        List<APTS_Segment_Threshold__c> segthrList= new List<APTS_Segment_Threshold__c>();
        //Add Segment threshold
        APTS_Segment_Threshold__c seg1 = new APTS_Segment_Threshold__c();
        seg1.APTS_Approval_Required__c=True;
        seg1.APTS_Segment__c='Small Law';
        seg1.APTS_Customer_Category__c='0';
        seg1.APTS_Term_in_years__c=Integer.ValueOf('2');
        seg1.APTS_Minimum_OY_Increase__c=Integer.ValueOf('5');
        String myNumber = '15.00';
        String myTruncatedNumber = myNumber.subString(0,myNumber.indexOf('.')+3);
        Decimal d = Decimal.valueOf(myTruncatedNumber);
        System.debug(d);
        seg1.APTS_Minimum_Incremental_Growth__c=d;
        segthrList.add(seg1);
        
        APTS_Segment_Threshold__c seg2 = new APTS_Segment_Threshold__c();
        seg2.APTS_Approval_Required__c=True;
        seg2.APTS_Segment__c='Corporate';
        seg2.APTS_Customer_Category__c='0';
        seg2.APTS_Term_in_years__c=Integer.ValueOf('2');
        seg2.APTS_Minimum_OY_Increase__c=Integer.ValueOf('5');
        
        String myNumber2 = '15.00';
        String myTruncatedNumber2 = myNumber2.subString(0,myNumber2.indexOf('.')+3);
        Decimal d2 = Decimal.valueOf(myTruncatedNumber2);
        System.debug(d);
        seg2.APTS_Minimum_Incremental_Growth__c=d2;
        segthrList.add(seg2);
        
        
        APTS_Segment_Threshold__c seg3 = new APTS_Segment_Threshold__c();
        seg3.APTS_Approval_Required__c=True;
        seg3.APTS_Segment__c='Government';
        seg3.APTS_Customer_Category__c='0';
        seg3.APTS_Term_in_years__c=Integer.ValueOf('2');
        seg3.APTS_Minimum_OY_Increase__c=Integer.ValueOf('5');
        String myNumber3 = '15.00';
        String myTruncatedNumber3 = myNumber3.subString(0,myNumber3.indexOf('.')+3);
        Decimal d3 = Decimal.valueOf(myTruncatedNumber3);
        System.debug(d);
        seg3.APTS_Minimum_Incremental_Growth__c=d3;
        segthrList.add(seg3);
        insert segthrList;
        
        Apttus_Config2__PriceList__c priceList = APTS_TestDataFactory.createPriceList('Thomson Reuters Master - US Legal');
        insert priceList;
        
        Apttus_Config2__PriceListItem__c pliSO = new Apttus_Config2__PriceListItem__c();
        pliSO.Apttus_Config2__Active__c = true;
        pliSO.Apttus_Config2__PriceListId__c = priceList.Id;
        pliSO.APTS_Max_Fill_Up_Price__c = 5;
        insert pliSO;
        
        
        WebServiceSettings__c oWebServiceSettings = new WebServiceSettings__c();
        oWebServiceSettings.Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable'; 
        oWebServiceSettings.Name = 'PaymentCreditIncrease'; 
        oWebServiceSettings.Timeout__c = 120; 
        oWebServiceSettings.Endpoint__c = 'https://dev.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease'; 
        oWebServiceSettings.Active__c = true;
        insert oWebServiceSettings;
        //Inserting keyvaluestore
        List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c=System.Label.APTS_OC_Test_Id),
        new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other'),
        new KeyValueListStore__c(Name='LCRMDisableStrikeIronServices',TextValue__c='false')};
        insert keyvaluestore;
        
        //Inserting record list 
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

        User findlawUser4=new User(username='testuser24@acme.com',
        lastname='testuser',
        Alias='testuser',
        Email='testuser4@tcs.com',
        Sub_Bu__c='Findlaw',
        TimeZoneSidKey = 'GMT',
        ProfileId = profileId.id,
        LanguageLocaleKey = 'en_US',
        EmailEncodingKey = 'UTF-8',
        LocaleSidKey = 'en_US',
        Default_Catalog__c ='Findlaw');
        insert FindlawUser4;
      
        Account a = APTS_TestDataFactory.createAccount('Test Account');
        insert a;
        
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();
        Source_System_Detail__c accountSSD= new Source_System_Detail__c();
        accountSSD.RecordtypeId=ssdRecorType;
        accountSSD.Name='ABC';
        accountSSD.Source_System_Name__c='ABC';
        accountSSD.Account_Name__c=a.ID;
        accountSSD.Account_Inactive__c=false;
        accountSSD.LCRM_Sales_Org__c='WEST';
        accountSSD.APTS_Customer_Category__c='1';
        insert accountSSD;
        
        Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        Opportunity oppty=APTS_TestDataFactory.createOpportunity('abc',a.id,'Needs Analysis',Date.Today());
        oppty.RecordtypeId=opptyRecorType;
        oppty.Source_System_Detail__c=accountSSD.id;
        oppty.Account=a;
        insert oppty;
      
        Apttus_Proposal__Proposal__c proposal = APTS_TestDataFactory.createProposal(oppty.id, accountSSD.Id);
        proposal.APTS_Approval_Segment__c = 'Small Law';
        proposal.APTS_Proposal_Business_Unit__c ='Findlaw' ;
        System.runAs(FindlawUser4){
        insert proposal;
        }
        Apttus_Config2__ProductConfiguration__c prodConfig = APTS_TestDataFactory.createProductConfiguration(proposal.Id);
        prodConfig.APTS_Incremental_Growth__c=0;
        prodConfig.APTS_Rutter_Approval__c=False;
        insert prodConfig;
        
        List<Product2> listOfProducts=new List<Product2>(); 
        Product2 prod1 = new Product2(Name='Sreenu Product Test', ProductCode = '41055954',APTS_Corporate_Select__c='Primary',APTS_Media_Lower_Level_Code__c = 'I9',APTS_Media_High_Level_Code__c='06', Apttus_Config2__Uom__c = 'Attorneys',APTS_Product_Pricing_Model__c ='BENEFITGRP');
        Product2 prod2 = new Product2(Name='Sreenu Product Test2', ProductCode = '41055955',APTS_Corporate_Select__c='Primary',APTS_Media_High_Level_Code__c='07', Apttus_Config2__Uom__c = 'Attorneys',APTS_Product_Pricing_Model__c ='Banded');
        Product2 prod3 = new Product2(Name='Sreenu Product Test3', ProductCode = '41055956',APTS_Corporate_Select__c='Primary',APTS_Media_High_Level_Code__c='21', Apttus_Config2__Uom__c = 'Seats',APTS_Product_Pricing_Model__c ='Per Seat');
        listOfProducts.add(prod1);
        listOfProducts.add(prod2);
        listOfProducts.add(prod3);       
        
        insert listOfProducts;
        
        //proposal.APTS_Approval_Segment__c = 'Corporate SMB';
        //update proposal;
        //update prodConfig;
        
        List<Apttus_Config2__LineItem__c> listOfLineItems = New List<Apttus_Config2__LineItem__c>();
        
        Apttus_Config2__LineItem__c linObj1 = new Apttus_Config2__LineItem__c(
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Product/Service',
            Apttus_Config2__LineNumber__c = 1, 
            Apttus_Config2__ItemSequence__c = 1,
            Apttus_Config2__ProductId__c=prod1.id,
           
            Apttus_Config2__IncentiveCode__c = '02',
            APTS_Bridge__c = '1 Month',
            Apttus_Config2__NetPrice__c=10.0,
            Apttus_Config2__BasePrice__c=10.0,
            Apttus_Config2__BaseExtendedPrice__c = 10.0,
            Apttus_Config2__AdjustedPrice__c = 10.0,
            Apttus_Config2__OptionPrice__c = 5.0,
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring',
            Apttus_Config2__ChargeType__c = 'Subscription Fee',  
            APTS_Contract_Term__c='3 Months',
            Apttus_Config2__PriceAdjustment__c=0); 
        
        listOfLineItems.add(linObj1);
        
        
        Apttus_Config2__LineItem__c linObj2 = new Apttus_Config2__LineItem__c(
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Product/Service',
            Apttus_Config2__LineNumber__c = 1, 
            Apttus_Config2__ItemSequence__c = 1,
            Apttus_Config2__ProductId__c=prod2.id,
         
            Apttus_Config2__IncentiveCode__c = '02',
            APTS_Bridge__c = '1 Month',
            Apttus_Config2__NetPrice__c=10.0,
            Apttus_Config2__BasePrice__c=10.0,
            Apttus_Config2__BaseExtendedPrice__c = 10.0,
            Apttus_Config2__AdjustedPrice__c = 10.0,
            Apttus_Config2__OptionPrice__c = 5.0,
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring',
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            APTS_Contract_Term__c='3 Months',
            //APTS_Group__c='Bundle A',
            Apttus_Config2__PriceAdjustment__c=0);         
        listOfLineItems.add(linObj2);
               
        Apttus_Config2__LineItem__c linObj3 = new Apttus_Config2__LineItem__c(
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Product/Service',
            Apttus_Config2__LineNumber__c = 1, 
            Apttus_Config2__ItemSequence__c = 1,
            Apttus_Config2__ProductId__c=prod3.id,            
            
            Apttus_Config2__IncentiveCode__c = '02',
            APTS_Bridge__c = '1 Month',
            Apttus_Config2__NetPrice__c=10.0,
            Apttus_Config2__BasePrice__c=10.0,
            Apttus_Config2__BaseExtendedPrice__c = 10.0,
            Apttus_Config2__AdjustedPrice__c = 10.0,
            Apttus_Config2__OptionPrice__c = 5.0,
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring',
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            APTS_Contract_Term__c='3 Months',
            //APTS_Group__c='Bundle B',
            Apttus_Config2__PriceAdjustment__c=0); 
        
        listOfLineItems.add(linObj3); 
            insert listOfLineItems;
        
        //changed old account soldto to new soldto ssd
        List<Apttus_Config2__LineItem__c> lineItemsList = [SELECT Id, Name, Apttus_Config2__ProductId__c, Apttus_Config2__ConfigurationId__c, Apttus_Config2__ConfigurationId__r.APTS_SSD_Sold_To__c, Apttus_Config2__LineNumber__c,
                                                           Apttus_Config2__ItemSequence__c, Apttus_Config2__LineType__c, Apttus_Config2__LineStatus__c 
                                                           FROM Apttus_Config2__LineItem__c 
                                                           WHERE Apttus_Config2__ConfigurationId__c = :prodConfig.id];      
        
        System.assert(lineItemsList!= null && lineItemsList.size()>0);      
        
        Test.startTest();
        prodConfig.Apttus_Config2__Status__c = 'New';
        update prodConfig;
        
        APTS_ProductConfigurationTriggerHandler.afterUpdate = false;
        checkRecursive.afterUpdate = True;
        prodConfig.Apttus_Config2__Status__c = 'Finalized';
        update prodConfig;
        Test.stopTest();
    }
    
    @isTest
    static void testapprovalsegmentSmallLawTK() {
    
        List<APTS_Segment_Threshold__c> segthrList= new List<APTS_Segment_Threshold__c>();
        //Add Segment threshold
        APTS_Segment_Threshold__c seg1 = new APTS_Segment_Threshold__c();
        seg1.APTS_Approval_Required__c=True;
        seg1.APTS_Segment__c='Small Law';
        seg1.APTS_Customer_Category__c='0';
        seg1.APTS_Term_in_years__c=Integer.ValueOf('2');
        seg1.APTS_Minimum_OY_Increase__c=Integer.ValueOf('5');
        String myNumber = '15.00';
        String myTruncatedNumber = myNumber.subString(0,myNumber.indexOf('.')+3);
        Decimal d = Decimal.valueOf(myTruncatedNumber);
        System.debug(d);
        seg1.APTS_Minimum_Incremental_Growth__c=d;
        segthrList.add(seg1);
        
        APTS_Segment_Threshold__c seg2 = new APTS_Segment_Threshold__c();
        seg2.APTS_Approval_Required__c=True;
        seg2.APTS_Segment__c='Corporate';
        seg2.APTS_Customer_Category__c='0';
        seg2.APTS_Term_in_years__c=Integer.ValueOf('2');
        seg2.APTS_Minimum_OY_Increase__c=Integer.ValueOf('5');
        
        String myNumber2 = '15.00';
        String myTruncatedNumber2 = myNumber2.subString(0,myNumber2.indexOf('.')+3);
        Decimal d2 = Decimal.valueOf(myTruncatedNumber2);
        System.debug(d);
        seg2.APTS_Minimum_Incremental_Growth__c=d2;
        segthrList.add(seg2);
        
        
        APTS_Segment_Threshold__c seg3 = new APTS_Segment_Threshold__c();
        seg3.APTS_Approval_Required__c=True;
        seg3.APTS_Segment__c='Government';
        seg3.APTS_Customer_Category__c='0';
        seg3.APTS_Term_in_years__c=Integer.ValueOf('2');
        seg3.APTS_Minimum_OY_Increase__c=Integer.ValueOf('5');
        String myNumber3 = '15.00';
        String myTruncatedNumber3 = myNumber3.subString(0,myNumber3.indexOf('.')+3);
        Decimal d3 = Decimal.valueOf(myTruncatedNumber3);
        System.debug(d);
        seg3.APTS_Minimum_Incremental_Growth__c=d3;
        segthrList.add(seg3);
        insert segthrList;
        
        Apttus_Config2__PriceList__c priceList = APTS_TestDataFactory.createPriceList('Thomson Reuters Master - US Legal');
        insert priceList;
        
        Apttus_Config2__PriceListItem__c pliSO = new Apttus_Config2__PriceListItem__c();
        pliSO.Apttus_Config2__Active__c = true;
        pliSO.Apttus_Config2__PriceListId__c = priceList.Id;
        pliSO.APTS_Max_Fill_Up_Price__c = 5;
        insert pliSO;
        
        
        WebServiceSettings__c oWebServiceSettings = new WebServiceSettings__c();
        oWebServiceSettings.Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable'; 
        oWebServiceSettings.Name = 'PaymentCreditIncrease'; 
        oWebServiceSettings.Timeout__c = 120; 
        oWebServiceSettings.Endpoint__c = 'https://dev.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease'; 
        oWebServiceSettings.Active__c = true;
        insert oWebServiceSettings;
        //Inserting keyvaluestore
        List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c=System.Label.APTS_OC_Test_Id),
        new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other'),
        new KeyValueListStore__c(Name='LCRMDisableStrikeIronServices',TextValue__c='false')};
        insert keyvaluestore;
        
        //Inserting record list 
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

        User findlawUser4=new User(username='testuser24@acme.com',
        lastname='testuser',
        Alias='testuser',
        Email='testuser4@tcs.com',
        Sub_Bu__c='Findlaw',
        TimeZoneSidKey = 'GMT',
        ProfileId = profileId.id,
        LanguageLocaleKey = 'en_US',
        EmailEncodingKey = 'UTF-8',
        LocaleSidKey = 'en_US',
        Default_Catalog__c ='Findlaw');
        insert FindlawUser4;
      
        Account a = APTS_TestDataFactory.createAccount('Test Account');
        insert a;
        
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();
        Source_System_Detail__c accountSSD= new Source_System_Detail__c();
        accountSSD.RecordtypeId=ssdRecorType;
        accountSSD.Name='ABC';
        accountSSD.Source_System_Name__c='ABC';
        accountSSD.Account_Name__c=a.ID;
        accountSSD.Account_Inactive__c=false;
        accountSSD.LCRM_Sales_Org__c='WEST';
        accountSSD.APTS_Customer_Category__c='1';
        insert accountSSD;
        
        Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        Opportunity oppty=APTS_TestDataFactory.createOpportunity('abc',a.id,'Needs Analysis',Date.Today());
        oppty.RecordtypeId=opptyRecorType;
        oppty.Source_System_Detail__c=accountSSD.id;
        oppty.Account=a;
        insert oppty;
      
        Apttus_Proposal__Proposal__c proposal = APTS_TestDataFactory.createProposal(oppty.id, accountSSD.Id);
        proposal.APTS_Approval_Segment__c = 'Small Law';
        proposal.APTS_Proposal_Business_Unit__c ='Findlaw' ;
        System.runAs(FindlawUser4){
        insert proposal;
        }
        Apttus_Config2__ProductConfiguration__c prodConfig = APTS_TestDataFactory.createProductConfiguration(proposal.Id);
        prodConfig.APTS_Incremental_Growth__c=0;
        prodConfig.APTS_Rutter_Approval__c=False;
        insert prodConfig;
        
        List<Product2> listOfProducts=new List<Product2>(); 
        Product2 prod1 = new Product2(Name='Sreenu Product Test', ProductCode = '41055954',APTS_Corporate_Select__c='Primary',APTS_Media_Lower_Level_Code__c = 'I9',APTS_Media_High_Level_Code__c='06', Apttus_Config2__Uom__c = 'Attorneys',APTS_Product_Pricing_Model__c ='BENEFITGRP');
        Product2 prod2 = new Product2(Name='Sreenu Product Test2', ProductCode = '41055955',APTS_Corporate_Select__c='Primary',APTS_Media_High_Level_Code__c='08', Apttus_Config2__Uom__c = 'Attorneys',APTS_Product_Pricing_Model__c ='Banded');
        Product2 prod3 = new Product2(Name='Sreenu Product Test3', ProductCode = '41055956',APTS_Corporate_Select__c='Primary',APTS_Media_High_Level_Code__c='21', Apttus_Config2__Uom__c = 'Seats',APTS_Product_Pricing_Model__c ='Per Seat');
        listOfProducts.add(prod1);
        listOfProducts.add(prod2);
        listOfProducts.add(prod3);       
        
        insert listOfProducts;
        
        //proposal.APTS_Approval_Segment__c = 'Corporate SMB';
        //update proposal;
        //update prodConfig;
        
        List<Apttus_Config2__LineItem__c> listOfLineItems = New List<Apttus_Config2__LineItem__c>();
        
        Apttus_Config2__LineItem__c linObj1 = new Apttus_Config2__LineItem__c(
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Product/Service',
            Apttus_Config2__LineNumber__c = 1, 
            Apttus_Config2__ItemSequence__c = 1,
            Apttus_Config2__ProductId__c=prod1.id,
           
            Apttus_Config2__IncentiveCode__c = '02',
            APTS_Bridge__c = '1 Month',
            Apttus_Config2__NetPrice__c=10.0,
            Apttus_Config2__BasePrice__c=10.0,
            Apttus_Config2__BaseExtendedPrice__c = 10.0,
            Apttus_Config2__AdjustedPrice__c = 10.0,
            Apttus_Config2__OptionPrice__c = 5.0,
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring',
            Apttus_Config2__ChargeType__c = 'Subscription Fee',  
            APTS_Contract_Term__c='3 Months',
            Apttus_Config2__PriceAdjustment__c=0); 
        
        listOfLineItems.add(linObj1);
        
        
        Apttus_Config2__LineItem__c linObj2 = new Apttus_Config2__LineItem__c(
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Product/Service',
            Apttus_Config2__LineNumber__c = 1, 
            Apttus_Config2__ItemSequence__c = 1,
            Apttus_Config2__ProductId__c=prod2.id,
         
            Apttus_Config2__IncentiveCode__c = '02',
            APTS_Bridge__c = '1 Month',
            Apttus_Config2__NetPrice__c=10.0,
            Apttus_Config2__BasePrice__c=10.0,
            Apttus_Config2__BaseExtendedPrice__c = 10.0,
            Apttus_Config2__AdjustedPrice__c = 10.0,
            Apttus_Config2__OptionPrice__c = 5.0,
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring',
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            APTS_Contract_Term__c='3 Months',
            //APTS_Group__c='Bundle A',
            Apttus_Config2__PriceAdjustment__c=0);         
        listOfLineItems.add(linObj2);
               
        Apttus_Config2__LineItem__c linObj3 = new Apttus_Config2__LineItem__c(
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Product/Service',
            Apttus_Config2__LineNumber__c = 1, 
            Apttus_Config2__ItemSequence__c = 1,
            Apttus_Config2__ProductId__c=prod3.id,            
            
            Apttus_Config2__IncentiveCode__c = '02',
            APTS_Bridge__c = '1 Month',
            Apttus_Config2__NetPrice__c=10.0,
            Apttus_Config2__BasePrice__c=10.0,
            Apttus_Config2__BaseExtendedPrice__c = 10.0,
            Apttus_Config2__AdjustedPrice__c = 10.0,
            Apttus_Config2__OptionPrice__c = 5.0,
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring',
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            APTS_Contract_Term__c='3 Months',
            //APTS_Group__c='Bundle B',
            Apttus_Config2__PriceAdjustment__c=0); 
        
        listOfLineItems.add(linObj3); 
            insert listOfLineItems;
        
        //changed old account soldto to new soldto ssd
        List<Apttus_Config2__LineItem__c> lineItemsList = [SELECT Id, Name, Apttus_Config2__ProductId__c, Apttus_Config2__ConfigurationId__c, Apttus_Config2__ConfigurationId__r.APTS_SSD_Sold_To__c, Apttus_Config2__LineNumber__c,
                                                           Apttus_Config2__ItemSequence__c, Apttus_Config2__LineType__c, Apttus_Config2__LineStatus__c 
                                                           FROM Apttus_Config2__LineItem__c 
                                                           WHERE Apttus_Config2__ConfigurationId__c = :prodConfig.id];      
        
        System.assert(lineItemsList!= null && lineItemsList.size()>0);      
        
        Test.startTest();
        prodConfig.Apttus_Config2__Status__c = 'New';
        update prodConfig;
        
        APTS_ProductConfigurationTriggerHandler.afterUpdate = false;
        checkRecursive.afterUpdate = True;
        prodConfig.Apttus_Config2__Status__c = 'Finalized';
        update prodConfig;
        Test.stopTest();
    }
    
    @isTest
    static void testapprovalSegmentCorporate() {
    
        List<APTS_Segment_Threshold__c> segthrList= new List<APTS_Segment_Threshold__c>();
        //Add Segment threshold
        APTS_Segment_Threshold__c seg1 = new APTS_Segment_Threshold__c();
        seg1.APTS_Approval_Required__c=True;
        seg1.APTS_Segment__c='Small Law';
        seg1.APTS_Customer_Category__c='0';
        seg1.APTS_Term_in_years__c=Integer.ValueOf('2');
        seg1.APTS_Minimum_OY_Increase__c=Integer.ValueOf('5');
        String myNumber = '15.00';
        String myTruncatedNumber = myNumber.subString(0,myNumber.indexOf('.')+3);
        Decimal d = Decimal.valueOf(myTruncatedNumber);
        System.debug(d);
        seg1.APTS_Minimum_Incremental_Growth__c=d;
        segthrList.add(seg1);
        
        APTS_Segment_Threshold__c seg2 = new APTS_Segment_Threshold__c();
        seg2.APTS_Approval_Required__c=True;
        seg2.APTS_Segment__c='Corporate';
        seg2.APTS_Customer_Category__c='0';
        seg2.APTS_Term_in_years__c=Integer.ValueOf('2');
        seg2.APTS_Minimum_OY_Increase__c=Integer.ValueOf('5');
        
        String myNumber2 = '15.00';
        String myTruncatedNumber2 = myNumber2.subString(0,myNumber2.indexOf('.')+3);
        Decimal d2 = Decimal.valueOf(myTruncatedNumber2);
        System.debug(d);
        seg2.APTS_Minimum_Incremental_Growth__c=d2;
        segthrList.add(seg2);
        
        
        APTS_Segment_Threshold__c seg3 = new APTS_Segment_Threshold__c();
        seg3.APTS_Approval_Required__c=True;
        seg3.APTS_Segment__c='Government';
        seg3.APTS_Customer_Category__c='0';
        seg3.APTS_Term_in_years__c=Integer.ValueOf('2');
        seg3.APTS_Minimum_OY_Increase__c=Integer.ValueOf('5');
        String myNumber3 = '15.00';
        String myTruncatedNumber3 = myNumber3.subString(0,myNumber3.indexOf('.')+3);
        Decimal d3 = Decimal.valueOf(myTruncatedNumber3);
        System.debug(d);
        seg3.APTS_Minimum_Incremental_Growth__c=d3;
        segthrList.add(seg3);
        insert segthrList;
        
        Apttus_Config2__PriceList__c priceList = APTS_TestDataFactory.createPriceList('Thomson Reuters Master - US Legal');
        insert priceList;
        
        Apttus_Config2__PriceListItem__c pliSO = new Apttus_Config2__PriceListItem__c();
        pliSO.Apttus_Config2__Active__c = true;
        pliSO.Apttus_Config2__PriceListId__c = priceList.Id;
        pliSO.APTS_Max_Fill_Up_Price__c = 5;
        insert pliSO;
        
        
        WebServiceSettings__c oWebServiceSettings = new WebServiceSettings__c();
        oWebServiceSettings.Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable'; 
        oWebServiceSettings.Name = 'PaymentCreditIncrease'; 
        oWebServiceSettings.Timeout__c = 120; 
        oWebServiceSettings.Endpoint__c = 'https://dev.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease'; 
        oWebServiceSettings.Active__c = true;
        insert oWebServiceSettings;
        //Inserting keyvaluestore
        List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c=System.Label.APTS_OC_Test_Id),
        new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other'),
        new KeyValueListStore__c(Name='LCRMDisableStrikeIronServices',TextValue__c='false')};
        insert keyvaluestore;
        
        //Inserting record list 
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

        User findlawUser1=new User(username='testuser25@acme.com',
        lastname='testuser',
        Alias='testuser',
        Email='testuser1@tcs.com',
        Sub_Bu__c='Findlaw',
        TimeZoneSidKey = 'GMT',
        ProfileId = profileId.id,
        LanguageLocaleKey = 'en_US',
        EmailEncodingKey = 'UTF-8',
        LocaleSidKey = 'en_US',
        Default_Catalog__c ='Findlaw');
        insert FindlawUser1;
      
        Account a = APTS_TestDataFactory.createAccount('Test Account');
        insert a;
        
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();
        Source_System_Detail__c accountSSD= new Source_System_Detail__c();
        accountSSD.RecordtypeId=ssdRecorType;
        accountSSD.Name='ABC';
        accountSSD.Source_System_Name__c='ABC';
        accountSSD.Account_Name__c=a.ID;
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
        proposal.APTS_Approval_Segment__c = 'Corporate SMB';
        proposal.APTS_Proposal_Business_Unit__c ='Findlaw' ;
        System.runAs(FindlawUser1){
        insert proposal;
        }
        Apttus_Config2__ProductConfiguration__c prodConfig = APTS_TestDataFactory.createProductConfiguration(proposal.Id);
        prodConfig.APTS_Incremental_Growth__c=0;
        prodConfig.APTS_Rutter_Approval__c=False;
        insert prodConfig;
        
        List<Product2> listOfProducts=new List<Product2>(); 
        Product2 prod1 = new Product2(Name='Sreenu Product Test', ProductCode = '41055954',APTS_Corporate_Select__c='Primary',APTS_Media_Lower_Level_Code__c = 'I9',APTS_Media_High_Level_Code__c='06', Apttus_Config2__Uom__c = 'Attorneys',APTS_Product_Pricing_Model__c ='BENEFITGRP');
        Product2 prod2 = new Product2(Name='Sreenu Product Test2', ProductCode = '41055955',APTS_Corporate_Select__c='Primary',APTS_Media_High_Level_Code__c='07', Apttus_Config2__Uom__c = 'Attorneys',APTS_Product_Pricing_Model__c ='Banded');
        Product2 prod3 = new Product2(Name='Sreenu Product Test3', ProductCode = '41055956',APTS_Corporate_Select__c='Primary',APTS_Media_High_Level_Code__c='21', Apttus_Config2__Uom__c = 'Seats',APTS_Product_Pricing_Model__c ='Per Seat');
        listOfProducts.add(prod1);
        listOfProducts.add(prod2);
        listOfProducts.add(prod3);       
        
        insert listOfProducts;
        
        //proposal.APTS_Approval_Segment__c = 'Corporate SMB';
        //update proposal;
        //update prodConfig;
        
        List<Apttus_Config2__LineItem__c> listOfLineItems = New List<Apttus_Config2__LineItem__c>();
        
        Apttus_Config2__LineItem__c linObj1 = new Apttus_Config2__LineItem__c(
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Product/Service',
            Apttus_Config2__LineNumber__c = 1, 
            Apttus_Config2__ItemSequence__c = 1,
            Apttus_Config2__ProductId__c=prod1.id,
           
            Apttus_Config2__IncentiveCode__c = '02',
            APTS_Bridge__c = '1 Month',
            Apttus_Config2__NetPrice__c=10.0,
            Apttus_Config2__BasePrice__c=10.0,
            Apttus_Config2__BaseExtendedPrice__c = 10.0,
            Apttus_Config2__AdjustedPrice__c = 10.0,
            Apttus_Config2__OptionPrice__c = 5.0,
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring',
            Apttus_Config2__ChargeType__c = 'Subscription Fee',  
            APTS_Contract_Term__c='3 Months',
            Apttus_Config2__PriceAdjustment__c=0); 
        
        listOfLineItems.add(linObj1);
        
        
        Apttus_Config2__LineItem__c linObj2 = new Apttus_Config2__LineItem__c(
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Product/Service',
            Apttus_Config2__LineNumber__c = 1, 
            Apttus_Config2__ItemSequence__c = 1,
            Apttus_Config2__ProductId__c=prod2.id,
         
            Apttus_Config2__IncentiveCode__c = '02',
            APTS_Bridge__c = '1 Month',
            Apttus_Config2__NetPrice__c=10.0,
            Apttus_Config2__BasePrice__c=10.0,
            Apttus_Config2__BaseExtendedPrice__c = 10.0,
            Apttus_Config2__AdjustedPrice__c = 10.0,
            Apttus_Config2__OptionPrice__c = 5.0,
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring',
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            APTS_Contract_Term__c='3 Months',
            //APTS_Group__c='Bundle A',
            Apttus_Config2__PriceAdjustment__c=0);         
        listOfLineItems.add(linObj2);
               
        Apttus_Config2__LineItem__c linObj3 = new Apttus_Config2__LineItem__c(
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Product/Service',
            Apttus_Config2__LineNumber__c = 1, 
            Apttus_Config2__ItemSequence__c = 1,
            Apttus_Config2__ProductId__c=prod3.id,            
            
            Apttus_Config2__IncentiveCode__c = '02',
            APTS_Bridge__c = '1 Month',
            Apttus_Config2__NetPrice__c=10.0,
            Apttus_Config2__BasePrice__c=10.0,
            Apttus_Config2__BaseExtendedPrice__c = 10.0,
            Apttus_Config2__AdjustedPrice__c = 10.0,
            Apttus_Config2__OptionPrice__c = 5.0,
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring',
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            APTS_Contract_Term__c='3 Months',
            //APTS_Group__c='Bundle B',
            Apttus_Config2__PriceAdjustment__c=0); 
        
        listOfLineItems.add(linObj3); 
            insert listOfLineItems;
        
        //changed old account soldto to new soldto ssd
        List<Apttus_Config2__LineItem__c> lineItemsList = [SELECT Id, Name, Apttus_Config2__ProductId__c, Apttus_Config2__ConfigurationId__c, Apttus_Config2__ConfigurationId__r.APTS_SSD_Sold_To__c, Apttus_Config2__LineNumber__c,
                                                           Apttus_Config2__ItemSequence__c, Apttus_Config2__LineType__c, Apttus_Config2__LineStatus__c 
                                                           FROM Apttus_Config2__LineItem__c 
                                                           WHERE Apttus_Config2__ConfigurationId__c = :prodConfig.id];      
        
        System.assert(lineItemsList!= null && lineItemsList.size()>0);      
        
        Test.startTest();
        prodConfig.Apttus_Config2__Status__c = 'New';
        update prodConfig;
        
        APTS_ProductConfigurationTriggerHandler.afterUpdate = false;
        checkRecursive.afterUpdate = True;
        prodConfig.Apttus_Config2__Status__c = 'Finalized';
        update prodConfig;
        Test.stopTest();
    }
   @isTest
    static void testapprovalsegmentMediumLaw() {
    
        List<APTS_Segment_Threshold__c> segthrList= new List<APTS_Segment_Threshold__c>();
        //Add Segment threshold
        APTS_Segment_Threshold__c seg1 = new APTS_Segment_Threshold__c();
        seg1.APTS_Approval_Required__c=True;
        seg1.APTS_Segment__c='Small Law';
        seg1.APTS_Customer_Category__c='0';
        seg1.APTS_Term_in_years__c=Integer.ValueOf('2');
        seg1.APTS_Minimum_OY_Increase__c=Integer.ValueOf('5');
        String myNumber = '15.00';
        String myTruncatedNumber = myNumber.subString(0,myNumber.indexOf('.')+3);
        Decimal d = Decimal.valueOf(myTruncatedNumber);
        System.debug(d);
        seg1.APTS_Minimum_Incremental_Growth__c=d;
        segthrList.add(seg1);
        
        APTS_Segment_Threshold__c seg2 = new APTS_Segment_Threshold__c();
        seg2.APTS_Approval_Required__c=True;
        seg2.APTS_Segment__c='Corporate';
        seg2.APTS_Customer_Category__c='0';
        seg2.APTS_Term_in_years__c=Integer.ValueOf('2');
        seg2.APTS_Minimum_OY_Increase__c=Integer.ValueOf('5');
        
        String myNumber2 = '15.00';
        String myTruncatedNumber2 = myNumber2.subString(0,myNumber2.indexOf('.')+3);
        Decimal d2 = Decimal.valueOf(myTruncatedNumber2);
        System.debug(d);
        seg2.APTS_Minimum_Incremental_Growth__c=d2;
        segthrList.add(seg2);
        
        
        APTS_Segment_Threshold__c seg3 = new APTS_Segment_Threshold__c();
        seg3.APTS_Approval_Required__c=True;
        seg3.APTS_Segment__c='Government';
        seg3.APTS_Customer_Category__c='0';
        seg3.APTS_Term_in_years__c=Integer.ValueOf('2');
        seg3.APTS_Minimum_OY_Increase__c=Integer.ValueOf('5');
        String myNumber3 = '15.00';
        String myTruncatedNumber3 = myNumber3.subString(0,myNumber3.indexOf('.')+3);
        Decimal d3 = Decimal.valueOf(myTruncatedNumber3);
        System.debug(d);
        seg3.APTS_Minimum_Incremental_Growth__c=d3;
        segthrList.add(seg3);
        insert segthrList;
        
        Apttus_Config2__PriceList__c priceList = APTS_TestDataFactory.createPriceList('Thomson Reuters Master - US Legal');
        insert priceList;
        
        Apttus_Config2__PriceListItem__c pliSO = new Apttus_Config2__PriceListItem__c();
        pliSO.Apttus_Config2__Active__c = true;
        pliSO.Apttus_Config2__PriceListId__c = priceList.Id;
        pliSO.APTS_Max_Fill_Up_Price__c = 5;
        insert pliSO;
        
        
        WebServiceSettings__c oWebServiceSettings = new WebServiceSettings__c();
        oWebServiceSettings.Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable'; 
        oWebServiceSettings.Name = 'PaymentCreditIncrease'; 
        oWebServiceSettings.Timeout__c = 120; 
        oWebServiceSettings.Endpoint__c = 'https://dev.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease'; 
        oWebServiceSettings.Active__c = true;
        insert oWebServiceSettings;
        //Inserting keyvaluestore
        List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c=System.Label.APTS_OC_Test_Id),
        new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other'),
        new KeyValueListStore__c(Name='LCRMDisableStrikeIronServices',TextValue__c='false')};
        insert keyvaluestore;
        
        //Inserting record list 
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

        User findlawUser2=new User(username='testuser26@acme.com',
        lastname='testuser',
        Alias='testuser',
        Email='testuser2@tcs.com',
        Sub_Bu__c='Findlaw',
        TimeZoneSidKey = 'GMT',
        ProfileId = profileId.id,
        LanguageLocaleKey = 'en_US',
        EmailEncodingKey = 'UTF-8',
        LocaleSidKey = 'en_US',
        Default_Catalog__c ='Findlaw');
        insert FindlawUser2;
      
        Account a = APTS_TestDataFactory.createAccount('Test Account');
        insert a;
        
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();
        Source_System_Detail__c accountSSD= new Source_System_Detail__c();
        accountSSD.RecordtypeId=ssdRecorType;
        accountSSD.Name='ABC';
        accountSSD.Source_System_Name__c='ABC';
        accountSSD.Account_Name__c=a.ID;
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
        proposal.APTS_Approval_Segment__c = 'Medium Law';
        proposal.APTS_Proposal_Business_Unit__c ='Findlaw' ;
        System.runAs(FindlawUser2){
        insert proposal;
        }
        Apttus_Config2__ProductConfiguration__c prodConfig = APTS_TestDataFactory.createProductConfiguration(proposal.Id);
        prodConfig.APTS_Incremental_Growth__c=0;
        prodConfig.APTS_Rutter_Approval__c=False;
        insert prodConfig;
        
        List<Product2> listOfProducts=new List<Product2>(); 
        Product2 prod1 = new Product2(Name='Sreenu Product Test', ProductCode = '41055954',APTS_Corporate_Select__c='Primary',APTS_Media_Lower_Level_Code__c = 'I9',APTS_Media_High_Level_Code__c='06', Apttus_Config2__Uom__c = 'Attorneys',APTS_Product_Pricing_Model__c ='BENEFITGRP');
        Product2 prod2 = new Product2(Name='Sreenu Product Test2', ProductCode = '41055955',APTS_Corporate_Select__c='Primary',APTS_Media_High_Level_Code__c='07', Apttus_Config2__Uom__c = 'Attorneys',APTS_Product_Pricing_Model__c ='Banded');
        Product2 prod3 = new Product2(Name='Sreenu Product Test3', ProductCode = '41055956',APTS_Corporate_Select__c='Primary',APTS_Media_High_Level_Code__c='21', Apttus_Config2__Uom__c = 'Seats',APTS_Product_Pricing_Model__c ='Per Seat');
        listOfProducts.add(prod1);
        listOfProducts.add(prod2);
        listOfProducts.add(prod3);       
        
        insert listOfProducts;
        
        //proposal.APTS_Approval_Segment__c = 'Corporate SMB';
        //update proposal;
        //update prodConfig;
        
        List<Apttus_Config2__LineItem__c> listOfLineItems = New List<Apttus_Config2__LineItem__c>();
        
        Apttus_Config2__LineItem__c linObj1 = new Apttus_Config2__LineItem__c(
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Product/Service',
            Apttus_Config2__LineNumber__c = 1, 
            Apttus_Config2__ItemSequence__c = 1,
            Apttus_Config2__ProductId__c=prod1.id,
           
            Apttus_Config2__IncentiveCode__c = '02',
            APTS_Bridge__c = '1 Month',
            Apttus_Config2__NetPrice__c=10.0,
            Apttus_Config2__BasePrice__c=10.0,
            Apttus_Config2__BaseExtendedPrice__c = 10.0,
            Apttus_Config2__AdjustedPrice__c = 10.0,
            Apttus_Config2__OptionPrice__c = 5.0,
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring',
            Apttus_Config2__ChargeType__c = 'Subscription Fee',  
            APTS_Contract_Term__c='3 Months',
            Apttus_Config2__PriceAdjustment__c=0); 
        
        listOfLineItems.add(linObj1);
        
        
        Apttus_Config2__LineItem__c linObj2 = new Apttus_Config2__LineItem__c(
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Product/Service',
            Apttus_Config2__LineNumber__c = 1, 
            Apttus_Config2__ItemSequence__c = 1,
            Apttus_Config2__ProductId__c=prod2.id,
         
            Apttus_Config2__IncentiveCode__c = '02',
            APTS_Bridge__c = '1 Month',
            Apttus_Config2__NetPrice__c=10.0,
            Apttus_Config2__BasePrice__c=10.0,
            Apttus_Config2__BaseExtendedPrice__c = 10.0,
            Apttus_Config2__AdjustedPrice__c = 10.0,
            Apttus_Config2__OptionPrice__c = 5.0,
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring',
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            APTS_Contract_Term__c='3 Months',
            //APTS_Group__c='Bundle A',
            Apttus_Config2__PriceAdjustment__c=0);         
        listOfLineItems.add(linObj2);
               
        Apttus_Config2__LineItem__c linObj3 = new Apttus_Config2__LineItem__c(
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Product/Service',
            Apttus_Config2__LineNumber__c = 1, 
            Apttus_Config2__ItemSequence__c = 1,
            Apttus_Config2__ProductId__c=prod3.id,            
            
            Apttus_Config2__IncentiveCode__c = '02',
            APTS_Bridge__c = '1 Month',
            Apttus_Config2__NetPrice__c=10.0,
            Apttus_Config2__BasePrice__c=10.0,
            Apttus_Config2__BaseExtendedPrice__c = 10.0,
            Apttus_Config2__AdjustedPrice__c = 10.0,
            Apttus_Config2__OptionPrice__c = 5.0,
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring',
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            APTS_Contract_Term__c='3 Months',
            //APTS_Group__c='Bundle B',
            Apttus_Config2__PriceAdjustment__c=0); 
        
        listOfLineItems.add(linObj3); 
            insert listOfLineItems;
        
        //changed old account soldto to new soldto ssd
        List<Apttus_Config2__LineItem__c> lineItemsList = [SELECT Id, Name, Apttus_Config2__ProductId__c, Apttus_Config2__ConfigurationId__c, Apttus_Config2__ConfigurationId__r.APTS_SSD_Sold_To__c, Apttus_Config2__LineNumber__c,
                                                           Apttus_Config2__ItemSequence__c, Apttus_Config2__LineType__c, Apttus_Config2__LineStatus__c 
                                                           FROM Apttus_Config2__LineItem__c 
                                                           WHERE Apttus_Config2__ConfigurationId__c = :prodConfig.id];      
        
        System.assert(lineItemsList!= null && lineItemsList.size()>0);      
        
        Test.startTest();
        prodConfig.Apttus_Config2__Status__c = 'New';
        update prodConfig;
        
        APTS_ProductConfigurationTriggerHandler.afterUpdate = false;
        checkRecursive.afterUpdate = True;
        prodConfig.Apttus_Config2__Status__c = 'Finalized';
        update prodConfig;
        Test.stopTest();
    } 
    @isTest
    static void testapprovalsegmentGovernment() {
    
        List<APTS_Segment_Threshold__c> segthrList= new List<APTS_Segment_Threshold__c>();
        //Add Segment threshold
        APTS_Segment_Threshold__c seg1 = new APTS_Segment_Threshold__c();
        seg1.APTS_Approval_Required__c=True;
        seg1.APTS_Segment__c='Medium Law';
        seg1.APTS_Customer_Category__c='0';
        seg1.APTS_Term_in_years__c=Integer.ValueOf('2');
        seg1.APTS_Minimum_OY_Increase__c=Integer.ValueOf('5');
        String myNumber = '15.00';
        String myTruncatedNumber = myNumber.subString(0,myNumber.indexOf('.')+3);
        Decimal d = Decimal.valueOf(myTruncatedNumber);
        System.debug(d);
        seg1.APTS_Minimum_Incremental_Growth__c=d;
        segthrList.add(seg1);
        
        APTS_Segment_Threshold__c seg2 = new APTS_Segment_Threshold__c();
        seg2.APTS_Approval_Required__c=True;
        seg2.APTS_Segment__c='Corporate';
        seg2.APTS_Customer_Category__c='0';
        seg2.APTS_Term_in_years__c=Integer.ValueOf('2');
        seg2.APTS_Minimum_OY_Increase__c=Integer.ValueOf('5');
        
        String myNumber2 = '15.00';
        String myTruncatedNumber2 = myNumber2.subString(0,myNumber2.indexOf('.')+3);
        Decimal d2 = Decimal.valueOf(myTruncatedNumber2);
        System.debug(d);
        seg2.APTS_Minimum_Incremental_Growth__c=d2;
        segthrList.add(seg2);
        
        
        APTS_Segment_Threshold__c seg3 = new APTS_Segment_Threshold__c();
        seg3.APTS_Approval_Required__c=True;
        seg3.APTS_Segment__c='Government';
        seg3.APTS_Customer_Category__c='0';
        seg3.APTS_Term_in_years__c=Integer.ValueOf('2');
        seg3.APTS_Minimum_OY_Increase__c=Integer.ValueOf('5');
        String myNumber3 = '15.00';
        String myTruncatedNumber3 = myNumber3.subString(0,myNumber3.indexOf('.')+3);
        Decimal d3 = Decimal.valueOf(myTruncatedNumber3);
        System.debug(d);
        seg3.APTS_Minimum_Incremental_Growth__c=d3;
        segthrList.add(seg3);
        insert segthrList;
        
        Apttus_Config2__PriceList__c priceList = APTS_TestDataFactory.createPriceList('Thomson Reuters Master - US Legal');
        insert priceList;
        
        Apttus_Config2__PriceListItem__c pliSO = new Apttus_Config2__PriceListItem__c();
        pliSO.Apttus_Config2__Active__c = true;
        pliSO.Apttus_Config2__PriceListId__c = priceList.Id;
        pliSO.APTS_Max_Fill_Up_Price__c = 5;
        insert pliSO;
        
        
        WebServiceSettings__c oWebServiceSettings = new WebServiceSettings__c();
        oWebServiceSettings.Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable'; 
        oWebServiceSettings.Name = 'PaymentCreditIncrease'; 
        oWebServiceSettings.Timeout__c = 120; 
        oWebServiceSettings.Endpoint__c = 'https://dev.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease'; 
        oWebServiceSettings.Active__c = true;
        insert oWebServiceSettings;
        //Inserting keyvaluestore
        List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c=System.Label.APTS_OC_Test_Id),
        new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other'),
        new KeyValueListStore__c(Name='LCRMDisableStrikeIronServices',TextValue__c='false')};
        insert keyvaluestore;
        
        //Inserting record list 
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

        User findlawUser3=new User(username='testuser27@acme.com',
        lastname='testuser',
        Alias='testuser',
        Email='testuser3@tcs.com',
        Sub_Bu__c='Findlaw',
        TimeZoneSidKey = 'GMT',
        ProfileId = profileId.id,
        LanguageLocaleKey = 'en_US',
        EmailEncodingKey = 'UTF-8',
        LocaleSidKey = 'en_US',
        Default_Catalog__c ='Findlaw');
        insert FindlawUser3;
      
        Account a = APTS_TestDataFactory.createAccount('Test Account');
        insert a;
        
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();
        Source_System_Detail__c accountSSD= new Source_System_Detail__c();
        accountSSD.RecordtypeId=ssdRecorType;
        accountSSD.Name='ABC';
        accountSSD.Source_System_Name__c='ABC';
        accountSSD.Account_Name__c=a.ID;
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
        proposal.APTS_Approval_Segment__c = 'Government';
        proposal.APTS_Proposal_Business_Unit__c ='Findlaw' ;
        System.runAs(FindlawUser3){
        insert proposal;
        }
        Apttus_Config2__ProductConfiguration__c prodConfig = APTS_TestDataFactory.createProductConfiguration(proposal.Id);
        prodConfig.APTS_Incremental_Growth__c=0;
        prodConfig.APTS_Rutter_Approval__c=False;
        insert prodConfig;
        
        List<Product2> listOfProducts=new List<Product2>(); 
        Product2 prod1 = new Product2(Name='Sreenu Product Test', ProductCode = '41055954',APTS_Corporate_Select__c='Primary',APTS_Media_Lower_Level_Code__c = 'I9',APTS_Media_High_Level_Code__c='06', Apttus_Config2__Uom__c = 'Attorneys',APTS_Product_Pricing_Model__c ='BENEFITGRP');
        Product2 prod2 = new Product2(Name='Sreenu Product Test2', ProductCode = '41055955',APTS_Corporate_Select__c='Primary',APTS_Media_High_Level_Code__c='07', Apttus_Config2__Uom__c = 'Attorneys',APTS_Product_Pricing_Model__c ='Banded');
        Product2 prod3 = new Product2(Name='Sreenu Product Test3', ProductCode = '41055956',APTS_Corporate_Select__c='Primary',APTS_Media_High_Level_Code__c='21', Apttus_Config2__Uom__c = 'Seats',APTS_Product_Pricing_Model__c ='Per Seat');
        listOfProducts.add(prod1);
        listOfProducts.add(prod2);
        listOfProducts.add(prod3);       
        
        insert listOfProducts;
        
        //proposal.APTS_Approval_Segment__c = 'Corporate SMB';
        //update proposal;
        //update prodConfig;
        
        List<Apttus_Config2__LineItem__c> listOfLineItems = New List<Apttus_Config2__LineItem__c>();
        
        Apttus_Config2__LineItem__c linObj1 = new Apttus_Config2__LineItem__c(
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Product/Service',
            Apttus_Config2__LineNumber__c = 1, 
            Apttus_Config2__ItemSequence__c = 1,
            Apttus_Config2__ProductId__c=prod1.id,
           
            Apttus_Config2__IncentiveCode__c = '02',
            APTS_Bridge__c = '1 Month',
            Apttus_Config2__NetPrice__c=10.0,
            Apttus_Config2__BasePrice__c=10.0,
            Apttus_Config2__BaseExtendedPrice__c = 10.0,
            Apttus_Config2__AdjustedPrice__c = 10.0,
            Apttus_Config2__OptionPrice__c = 5.0,
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring',
            Apttus_Config2__ChargeType__c = 'Subscription Fee',  
            APTS_Contract_Term__c='3 Months',
            Apttus_Config2__PriceAdjustment__c=0); 
        
        listOfLineItems.add(linObj1);
        
        
        Apttus_Config2__LineItem__c linObj2 = new Apttus_Config2__LineItem__c(
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Product/Service',
            Apttus_Config2__LineNumber__c = 1, 
            Apttus_Config2__ItemSequence__c = 1,
            Apttus_Config2__ProductId__c=prod2.id,
         
            Apttus_Config2__IncentiveCode__c = '02',
            APTS_Bridge__c = '1 Month',
            Apttus_Config2__NetPrice__c=10.0,
            Apttus_Config2__BasePrice__c=10.0,
            Apttus_Config2__BaseExtendedPrice__c = 10.0,
            Apttus_Config2__AdjustedPrice__c = 10.0,
            Apttus_Config2__OptionPrice__c = 5.0,
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring',
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            APTS_Contract_Term__c='3 Months',
            //APTS_Group__c='Bundle A',
            Apttus_Config2__PriceAdjustment__c=0);         
        listOfLineItems.add(linObj2);
               
        Apttus_Config2__LineItem__c linObj3 = new Apttus_Config2__LineItem__c(
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Product/Service',
            Apttus_Config2__LineNumber__c = 1, 
            Apttus_Config2__ItemSequence__c = 1,
            Apttus_Config2__ProductId__c=prod3.id,            
            
            Apttus_Config2__IncentiveCode__c = '02',
            APTS_Bridge__c = '1 Month',
            Apttus_Config2__NetPrice__c=10.0,
            Apttus_Config2__BasePrice__c=10.0,
            Apttus_Config2__BaseExtendedPrice__c = 10.0,
            Apttus_Config2__AdjustedPrice__c = 10.0,
            Apttus_Config2__OptionPrice__c = 5.0,
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring',
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            APTS_Contract_Term__c='3 Months',
            //APTS_Group__c='Bundle B',
            Apttus_Config2__PriceAdjustment__c=0); 
        
        listOfLineItems.add(linObj3); 
            insert listOfLineItems;
        
        //changed old account soldto to new soldto ssd
        List<Apttus_Config2__LineItem__c> lineItemsList = [SELECT Id, Name, Apttus_Config2__ProductId__c, Apttus_Config2__ConfigurationId__c, Apttus_Config2__ConfigurationId__r.APTS_SSD_Sold_To__c, Apttus_Config2__LineNumber__c,
                                                           Apttus_Config2__ItemSequence__c, Apttus_Config2__LineType__c, Apttus_Config2__LineStatus__c 
                                                           FROM Apttus_Config2__LineItem__c 
                                                           WHERE Apttus_Config2__ConfigurationId__c = :prodConfig.id];      
        
        System.assert(lineItemsList!= null && lineItemsList.size()>0);      
        
        Test.startTest();
        prodConfig.Apttus_Config2__Status__c = 'New';
        update prodConfig;
        
        APTS_ProductConfigurationTriggerHandler.afterUpdate = false;
        checkRecursive.afterUpdate = True;
        prodConfig.Apttus_Config2__Status__c = 'Finalized';
        update prodConfig;
        Test.stopTest();
    }
    @isTest
    static void testapprovalSCS() {
        List<APTS_Segment_Threshold__c> segthrList= new List<APTS_Segment_Threshold__c>();
        //Add Segment threshold
        APTS_Segment_Threshold__c seg1 = new APTS_Segment_Threshold__c();
        seg1.APTS_Approval_Required__c=True;
        seg1.APTS_Segment__c='Medium Law';
        seg1.APTS_Customer_Category__c='0';
        seg1.APTS_Term_in_years__c=Integer.ValueOf('2');
        seg1.APTS_Minimum_OY_Increase__c=Integer.ValueOf('5');
        String myNumber = '15.00';
        String myTruncatedNumber = myNumber.subString(0,myNumber.indexOf('.')+3);
        Decimal d = Decimal.valueOf(myTruncatedNumber);
        System.debug(d);
        seg1.APTS_Minimum_Incremental_Growth__c=d;
        segthrList.add(seg1);
        APTS_Segment_Threshold__c seg2 = new APTS_Segment_Threshold__c();
        seg2.APTS_Approval_Required__c=True;
        seg2.APTS_Segment__c='Corporate';
        seg2.APTS_Customer_Category__c='0';
        seg2.APTS_Term_in_years__c=Integer.ValueOf('2');
        seg2.APTS_Minimum_OY_Increase__c=Integer.ValueOf('5');
        String myNumber2 = '15.00';
        String myTruncatedNumber2 = myNumber2.subString(0,myNumber2.indexOf('.')+3);
        Decimal d2 = Decimal.valueOf(myTruncatedNumber2);
        System.debug(d);
        seg2.APTS_Minimum_Incremental_Growth__c=d2;
        segthrList.add(seg2);
        APTS_Segment_Threshold__c seg3 = new APTS_Segment_Threshold__c();
        seg3.APTS_Approval_Required__c=True;
        seg3.APTS_Segment__c='Government';
        seg3.APTS_Customer_Category__c='0';
        seg3.APTS_Term_in_years__c=Integer.ValueOf('2');
        seg3.APTS_Minimum_OY_Increase__c=Integer.ValueOf('5');
        String myNumber3 = '15.00';
        String myTruncatedNumber3 = myNumber3.subString(0,myNumber3.indexOf('.')+3);
        Decimal d3 = Decimal.valueOf(myTruncatedNumber3);
        System.debug(d);
        seg3.APTS_Minimum_Incremental_Growth__c=d3;
        segthrList.add(seg3);
        insert segthrList;
        Apttus_Config2__PriceList__c priceList = APTS_TestDataFactory.createPriceList('Thomson Reuters Master - US Legal');
        insert priceList;
        Apttus_Config2__PriceListItem__c pliSO = new Apttus_Config2__PriceListItem__c();
        pliSO.Apttus_Config2__Active__c = true;
        pliSO.Apttus_Config2__PriceListId__c = priceList.Id;
        pliSO.APTS_Max_Fill_Up_Price__c = 5;
        insert pliSO;
        WebServiceSettings__c oWebServiceSettings = new WebServiceSettings__c();
        oWebServiceSettings.Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable'; 
        oWebServiceSettings.Name = 'PaymentCreditIncrease'; 
        oWebServiceSettings.Timeout__c = 120; 
        oWebServiceSettings.Endpoint__c = 'https://dev.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease'; 
        oWebServiceSettings.Active__c = true;
        insert oWebServiceSettings;
        //Inserting keyvaluestore
        List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c=System.Label.APTS_OC_Test_Id),
        new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other'),
        new KeyValueListStore__c(Name='LCRMDisableStrikeIronServices',TextValue__c='false')};
        insert keyvaluestore;
        //Inserting record list 
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
        User findlawUser3=new User(username='testuser27@acme.com',
        lastname='testuser',
        Alias='testuser',
        Email='testuser3@tcs.com',
        Sub_Bu__c='Findlaw',
        TimeZoneSidKey = 'GMT',
        ProfileId = profileId.id,
        LanguageLocaleKey = 'en_US',
        EmailEncodingKey = 'UTF-8',
        LocaleSidKey = 'en_US',
        Default_Catalog__c ='Findlaw');
        insert FindlawUser3;
        Account a = APTS_TestDataFactory.createAccount('Test Account');
        insert a;
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();
        Source_System_Detail__c accountSSD= new Source_System_Detail__c();
        accountSSD.RecordtypeId=ssdRecorType;
        accountSSD.Name='ABC';
        accountSSD.Source_System_Name__c='ABC';
        accountSSD.Account_Name__c=a.ID;
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
        proposal.APTS_Approval_Segment__c = 'Government';
        proposal.APTS_Proposal_Business_Unit__c ='SCS' ;
        System.runAs(FindlawUser3){
        insert proposal;
        }
        Apttus_Config2__ProductConfiguration__c prodConfig = APTS_TestDataFactory.createProductConfiguration(proposal.Id);
        //prodConfig.APTS_Incremental_Growth_GLP__c=0;
        prodConfig.APTS_Rutter_Approval__c=False;
        insert prodConfig;
        List<Product2> listOfProducts=new List<Product2>(); 
        Product2 prod1 = new Product2(Name='Sreenu Product Test', ProductCode = '41055954',APTS_Corporate_Select__c='Primary',APTS_Media_Lower_Level_Code__c = 'AR',APTS_Media_High_Level_Code__c='06', Apttus_Config2__Uom__c = 'Attorneys',APTS_Product_Pricing_Model__c ='BENEFITGRP');
        Product2 prod2 = new Product2(Name='Sreenu Product Test2', ProductCode = '41055955',APTS_Corporate_Select__c='Primary',APTS_Media_High_Level_Code__c='13', Apttus_Config2__Uom__c = 'Attorneys',APTS_Product_Pricing_Model__c ='Banded');
        Product2 prod3 = new Product2(Name='Sreenu Product Test3', ProductCode = '41055956',APTS_Corporate_Select__c='Primary',APTS_Media_Lower_Level_Code__c = 'E1',APTS_Media_High_Level_Code__c='05', Apttus_Config2__Uom__c = 'Seats',APTS_Product_Pricing_Model__c ='Per Seat');
        listOfProducts.add(prod1);
        listOfProducts.add(prod2);
        listOfProducts.add(prod3);       
        insert listOfProducts;
        //proposal.APTS_Approval_Segment__c = 'Corporate SMB';
        //update proposal;
        //update prodConfig;
        List<Apttus_Config2__LineItem__c> listOfLineItems = New List<Apttus_Config2__LineItem__c>();
        Apttus_Config2__LineItem__c linObj1 = new Apttus_Config2__LineItem__c(
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Product/Service',
            Apttus_Config2__LineNumber__c = 1, 
            Apttus_Config2__ItemSequence__c = 1,
            Apttus_Config2__ProductId__c=prod1.id,
            Apttus_Config2__IncentiveCode__c = '02',
            APTS_Bridge__c = '1 Month',
            Apttus_Config2__NetPrice__c=10.0,
            Apttus_Config2__BasePrice__c=10.0,
            Apttus_Config2__BaseExtendedPrice__c = 10.0,
            Apttus_Config2__AdjustedPrice__c = 10.0,
            Apttus_Config2__OptionPrice__c = 5.0,
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring',
            Apttus_Config2__ChargeType__c = 'Subscription Fee',  
            APTS_Contract_Term__c='3 Months',
            Apttus_Config2__PriceAdjustment__c=0); 
        listOfLineItems.add(linObj1);
        Apttus_Config2__LineItem__c linObj2 = new Apttus_Config2__LineItem__c(
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Product/Service',
            Apttus_Config2__LineNumber__c = 1, 
            Apttus_Config2__ItemSequence__c = 1,
            Apttus_Config2__ProductId__c=prod2.id,
            Apttus_Config2__IncentiveCode__c = '02',
            APTS_Bridge__c = '1 Month',
            Apttus_Config2__NetPrice__c=10.0,
            Apttus_Config2__BasePrice__c=10.0,
            Apttus_Config2__BaseExtendedPrice__c = 10.0,
            Apttus_Config2__AdjustedPrice__c = 10.0,
            Apttus_Config2__OptionPrice__c = 5.0,
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring',
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            APTS_Contract_Term__c='3 Months',
            //APTS_Group__c='Bundle A',
            Apttus_Config2__PriceAdjustment__c=0);         
        listOfLineItems.add(linObj2);
        Apttus_Config2__LineItem__c linObj3 = new Apttus_Config2__LineItem__c(
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Product/Service',
            Apttus_Config2__LineNumber__c = 1, 
            Apttus_Config2__ItemSequence__c = 1,
            Apttus_Config2__ProductId__c=prod3.id,            
            Apttus_Config2__IncentiveCode__c = '02',
            APTS_Bridge__c = '1 Month',
            Apttus_Config2__NetPrice__c=10.0,
            Apttus_Config2__BasePrice__c=10.0,
            Apttus_Config2__BaseExtendedPrice__c = 10.0,
            Apttus_Config2__AdjustedPrice__c = 10.0,
            Apttus_Config2__OptionPrice__c = 5.0,
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring',
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            APTS_Contract_Term__c='3 Months',
            //APTS_Group__c='Bundle B',
            Apttus_Config2__PriceAdjustment__c=0); 
        listOfLineItems.add(linObj3);
        Apttus_Config2__LineItem__c linObj4 = new Apttus_Config2__LineItem__c(
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Product/Service',
            Apttus_Config2__LineNumber__c = 1, 
            Apttus_Config2__ItemSequence__c = 1,
            Apttus_Config2__ProductId__c=prod3.id,            
            Apttus_Config2__IncentiveCode__c = '02',
            APTS_Bridge__c = '1 Month',
            Apttus_Config2__NetPrice__c=10.0,
            Apttus_Config2__BasePrice__c=10.0,
            Apttus_Config2__BaseExtendedPrice__c = 10.0,
            Apttus_Config2__AdjustedPrice__c = 10.0,
            Apttus_Config2__OptionPrice__c = 5.0,
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring',
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            APTS_Contract_Term__c='3 Months',
            //APTS_Group__c='Bundle B',
            Apttus_Config2__PriceAdjustment__c=0); 
        listOfLineItems.add(linObj4);   
        Apttus_Config2__LineItem__c linObj5 = new Apttus_Config2__LineItem__c(
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Product/Service',
            Apttus_Config2__LineNumber__c = 1, 
            Apttus_Config2__ItemSequence__c = 1,
            Apttus_Config2__ProductId__c=prod3.id,            
            Apttus_Config2__IncentiveCode__c = '02',
            APTS_Bridge__c = '1 Month',
            Apttus_Config2__NetPrice__c=10.0,
            Apttus_Config2__BasePrice__c=10.0,
            Apttus_Config2__BaseExtendedPrice__c = 10.0,
            Apttus_Config2__AdjustedPrice__c = 10.0,
            Apttus_Config2__OptionPrice__c = 5.0,
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring',
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            APTS_Contract_Term__c='3 Months',
            //APTS_Group__c='Bundle B',
            Apttus_Config2__PriceAdjustment__c=0); 
        listOfLineItems.add(linObj5);
            insert listOfLineItems;
            
        Apttus_Config2__ProductAttributeValue__c pav1 = new Apttus_Config2__ProductAttributeValue__c(Purchase_Option_Bundle_Print__c='Ship & Entitle - APP',Apttus_Config2__LineItemId__c=linObj1.Id);
        Apttus_Config2__ProductAttributeValue__c pav2 = new Apttus_Config2__ProductAttributeValue__c(Purchase_Option_Bundle_Print__c='Ship & Entitle Sub',Apttus_Config2__LineItemId__c=linObj2.Id);
        Apttus_Config2__ProductAttributeValue__c pav3 = new Apttus_Config2__ProductAttributeValue__c(Purchase_Option_Bundle_Print__c='Sub Only APP',Apttus_Config2__LineItemId__c=linObj3.Id);
        Apttus_Config2__ProductAttributeValue__c pav4 = new Apttus_Config2__ProductAttributeValue__c(Purchase_Option_Bundle_Print__c='Sub Only',Apttus_Config2__LineItemId__c=linObj4.Id);
        Apttus_Config2__ProductAttributeValue__c pav5 = new Apttus_Config2__ProductAttributeValue__c(Purchase_Option_Bundle_Print__c='Ship & Entitle Only',Apttus_Config2__LineItemId__c=linObj5.Id);
        
        List<Apttus_Config2__ProductAttributeValue__c> listpavs = new List<Apttus_Config2__ProductAttributeValue__c>{pav1,pav2,pav3,pav4,pav5};
        insert listpavs;
        
        //changed old account soldto to new soldto ssd
        List<Apttus_Config2__LineItem__c> lineItemsList = [SELECT Id, Name, Apttus_Config2__ProductId__c, Apttus_Config2__ConfigurationId__c, Apttus_Config2__ConfigurationId__r.APTS_SSD_Sold_To__c, Apttus_Config2__LineNumber__c,
                                                           Apttus_Config2__ItemSequence__c, Apttus_Config2__LineType__c, Apttus_Config2__LineStatus__c 
                                                           FROM Apttus_Config2__LineItem__c 
                                                           WHERE Apttus_Config2__ConfigurationId__c = :prodConfig.id];      
        System.assert(lineItemsList!= null && lineItemsList.size()>0);      
        Test.startTest();
        prodConfig.Apttus_Config2__Status__c = 'New';
        update prodConfig;
        APTS_ProductConfigurationTriggerHandler.afterUpdate = false;
        checkRecursive.afterUpdate = True;
        prodConfig.Apttus_Config2__Status__c = 'Finalized';
        update prodConfig;
        Test.stopTest();
    }
    }