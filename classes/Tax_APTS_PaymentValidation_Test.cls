/*
* Test Class for Tax_APTS_PaymentValidationController
* Change History
==========================================================
Date            Name        Description
2019-12-07       Roma      Test Class made for tax Proffessional Payment Option Validation for Existing and New Customer
==========================================================
*
*/
@isTest
public class Tax_APTS_PaymentValidation_Test{ 
   
@isTest
    public static void getPaymentMethod() {
              
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
        
        KeyValueListStore__c keyvaluestore1=new  KeyValueListStore__c();
        keyvaluestore1.Name='LatamGGOProductId';
        keyvaluestore1.TextValue__c='SF07';
        insert keyvaluestore1;
        
        
        List<RecordtypeIds__c> recordlist=new List<RecordtypeIds__c>();
        RecordtypeIds__c recordtype=new RecordtypeIds__c();
        recordtype.Name='Pre-Pipeline Opportunities';
        recordtype.recTypeId__c=System.Label.APTS_OC_Test_Id;
        recordlist.add(recordtype);
        
        RecordtypeIds__c recordtype1=new RecordtypeIds__c();
        recordtype1.Name='Pipeline Opportunities';
        recordtype1.recTypeId__c=System.Label.APTS_OC_Test_Id;
        recordlist.add(recordtype1);
        
        RecordtypeIds__c recordtype2=new RecordtypeIds__c();
        recordtype2.Name='GLI Pipeline Opportunity';
        recordtype2.recTypeId__c=System.Label.APTS_OC_Test_Id;
        recordlist.add(recordtype2);
        
        insert recordlist;
         profile_list__c plist = new profile_list__c(name = 'Partner Portal User',Profile_Name__c='Partner Portal User',ProfileId__c = System.Label.APTS_OC_Test_Id);
        insert plist;
        
        Account a = APTS_TestDataFactory.createAccount('Testing Account');
        a.Customer_Group__c = 'Customer Class';
        insert a;
        system.debug('@@@@@@@@Account'+a);
        
        Contact cont=APTS_TestDataFactory.createContact('lastNAme',a.id);
        cont.FirstName='FirstNAme';
        cont.Email='abc@gmail.com';
        cont.Phone='1234567890';
        insert cont;
        system.debug('@@@@@@@@Contact'+cont);
        
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();
        Source_System_Detail__c accountSSD= new Source_System_Detail__c();
        accountSSD.RecordtypeId=ssdRecorType;
        accountSSD.Name='ABC';
        accountSSD.Source_System_Name__c='ABC';
        accountSSD.Account_Name__c=a.ID;
        accountSSD.Account_Inactive__c=false;
        accountSSD.LCRM_Sales_Org__c='BEJE';
        accountSSD.Source_System_Account_Number__c='123647';
        accountSSD.APTS_ZPEND_Flag__c = True;
        insert accountSSD;
        
        Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        Opportunity oppty=APTS_TestDataFactory.createOpportunity('abc',a.id,'Needs Analysis',Date.Today());
        oppty.RecordtypeId=opptyRecorType;
        oppty.Source_System_Detail__c=accountSSD.id;
        oppty.Email__c='abc@tcs.com';
        oppty.Account=a;
        insert oppty;
        
        Apttus_Config2__PriceList__c pl= APTS_TestDataFactory.createPriceList('Test Price List 1');
        insert pl;
        
        Id propRecorType=Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Proposal').getRecordTypeId();
        system.debug('$$$$$$$'+accountSSD);
        Apttus_Proposal__Proposal__c proposal = APTS_TestDataFactory.createProposal(oppty.id,a.Id);
        proposal.Apttus_Proposal__Approval_Stage__c='Draft';
        proposal.Apttus_Proposal__Account__c = a.Id;
        proposal.APTS_Proposal_Business_Unit__c='Tax Professional';
        proposal.RecordtypeId = propRecorType;
        proposal.Apttus_Proposal__Opportunity__c = oppty.id;
        proposal.CurrencyIsoCode = 'ARS';
        proposal.APTS_SSD_Sold_To__c = accountSSD.Id;
        proposal.Apttus_Proposal__Account__c = a.Id;
        proposal.Apttus_Proposal__Primary__c = true;
        insert proposal;    
        
        Apttus_Config2__ProductConfiguration__c prodConf2 = new Apttus_Config2__ProductConfiguration__c(Name='prod-conf2', CurrencyIsoCode = 'USD', Apttus_QPConfig__Proposald__c=proposal.id, APTS_SSD_ship_to__c=accountSSD.Id,APTS_SSD_bill_to__c=accountSSD.Id);
        insert prodConf2;
        
        Product2 prod = new Product2(name='prod1', Media_High_Level__c='Online', CurrencyIsoCode = 'USD',APTS_Cat_L2__c=Label.APTS_Clear_Product_Family);
        prod.APTS_Approval_Always_Required__c = true;
        insert prod;
        
         Apttus_Config2__ConfigSystemProperties__c configSetting=new Apttus_Config2__ConfigSystemProperties__c(Name='System Properties',Apttus_Config2__DisableConstraintRules__c=true);
        insert configSetting;
        
        List<Apttus_Config2__LineItem__c> listOfLineItems = new List<Apttus_Config2__LineItem__c>();        
        
        Apttus_Config2__LineItem__c li6 = new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c=prodConf2.id , Apttus_Config2__ProductId__c=prod.id);
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
        listOfLineItems.add(li7);
        
        insert listOfLineItems;
        
        prodConf2.Apttus_Config2__Status__c = 'Finalized';
        update prodConf2;
        
        List<Apttus_Proposal__Proposal__c> oProposalafter = [Select Id, 
                     Name,
                     recordType.Name,
                     APTS_SSD_Sold_To__c,
                     APTS_Proposal_Business_Unit__c, 
                     Tax_Payment_Option__c,
                     APTS_SSD_Sold_To__r.Source_System_Account_Number__c,
                     APTS_SSD_Sold_To__r.Number_Street__c,
                     APTS_SSD_Sold_To__r.Name,
                     APTS_SSD_Sold_To__r.State__c,
                     APTS_SSD_Sold_To__r.Country__c,
                     APTS_SSD_Sold_To__r.City__c,
                     APTS_SSD_Sold_To__r.LCRM_Phone__c,
                     APTS_SSD_Sold_To__r.Postal_Code__c,
                     APTS_Quote_Value__c,
                     Apttus_Proposal__Account__r.SAPAccountNumber__c,
                     Apttus_Proposal__Account__r.Name,
                     APTS_Sold_To_SAP_Account_Number__c,
                     Apttus_Proposal__Amount__c,
                     APTS_Payer__c,
                     APTS_Tax_Payment_Selection__c,
                     APTS_Payment_Option__c
                    from Apttus_Proposal__Proposal__c where id=:proposal.Id];
         Test.startTest();
        
            PageReference pref=Page.AutopaymentButton;
            pref.getParameters().put('id',proposal.Id);
            Test.setCurrentPage(pref);
            ApexPages.standardController sc = new ApexPages.standardController(proposal);
            Tax_APTS_PaymentValidationController con = new Tax_APTS_PaymentValidationController(sc);
            con.pay ='Payment Express Auto EFT/Auto Charge';
            con.getPayName();
            con.save();
            System.assertEquals(oProposalafter.size(),1);
            
        Test.stopTest();
        
    }
        
    @isTest
    public static void getPaymentMethod1() {
              
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
        
        KeyValueListStore__c keyvaluestore1=new  KeyValueListStore__c();
        keyvaluestore1.Name='LatamGGOProductId';
        keyvaluestore1.TextValue__c='SF07';
        insert keyvaluestore1;
        
        List<RecordtypeIds__c> recordlist=new List<RecordtypeIds__c>();
        RecordtypeIds__c recordtype=new RecordtypeIds__c();
        recordtype.Name='Pre-Pipeline Opportunities';
        recordtype.recTypeId__c=System.Label.APTS_OC_Test_Id;
        recordlist.add(recordtype);
        
        RecordtypeIds__c recordtype1=new RecordtypeIds__c();
        recordtype1.Name='Pipeline Opportunities';
        recordtype1.recTypeId__c=System.Label.APTS_OC_Test_Id;
        recordlist.add(recordtype1);
        
        RecordtypeIds__c recordtype2=new RecordtypeIds__c();
        recordtype2.Name='GLI Pipeline Opportunity';
        recordtype2.recTypeId__c=System.Label.APTS_OC_Test_Id;
        recordlist.add(recordtype2);
        
        insert recordlist;
         profile_list__c plist = new profile_list__c(name = 'Partner Portal User',Profile_Name__c='Partner Portal User',ProfileId__c = System.Label.APTS_OC_Test_Id);
        insert plist;
        
        Account a = APTS_TestDataFactory.createAccount('Testing Account');
        a.Customer_Group__c = 'Customer Class';
        insert a;
        system.debug('@@@@@@@@Account'+a);
        
        Contact cont=APTS_TestDataFactory.createContact('Kaur',a.id);
        cont.FirstName='Navpreet';
        cont.Email='abc@gmail.com';
        cont.Phone='9873337890';
        insert cont;
        system.debug('@@@@@@@@Contact'+cont);
        
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();
        Source_System_Detail__c accountSSD= new Source_System_Detail__c();
        accountSSD.RecordtypeId=ssdRecorType;
        accountSSD.Name='ABC';
        accountSSD.Source_System_Name__c='ABC';
        accountSSD.Account_Name__c=a.ID;
        accountSSD.Account_Inactive__c=false;
        accountSSD.LCRM_Sales_Org__c='BEJE';
        accountSSD.Source_System_Account_Number__c='';
        accountSSD.APTS_Is_Customer__c = false;
        insert accountSSD;
        
        Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        Opportunity oppty=APTS_TestDataFactory.createOpportunity('abc',a.id,'Needs Analysis',Date.Today());
        oppty.RecordtypeId=opptyRecorType;
        oppty.Source_System_Detail__c=accountSSD.id;
        oppty.Email__c='abc@tcs.com';
        oppty.Account=a;
        insert oppty;
        
        Apttus_Config2__PriceList__c pl= APTS_TestDataFactory.createPriceList('Test Price List 1');
        insert pl;
        
        Id propRecorType=Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Proposal').getRecordTypeId();
        system.debug('$$$$$$$'+accountSSD);
        Apttus_Proposal__Proposal__c proposal = APTS_TestDataFactory.createProposal(oppty.id,a.Id);
        proposal.Apttus_Proposal__Approval_Stage__c='Draft';
        proposal.Apttus_Proposal__Account__c = a.Id;
        proposal.APTS_Proposal_Business_Unit__c='Tax Professional';
        proposal.RecordtypeId = propRecorType;
        proposal.Apttus_Proposal__Opportunity__c = oppty.id;
        proposal.CurrencyIsoCode = 'ARS';
        proposal.APTS_SSD_Sold_To__c = accountSSD.Id;
        proposal.Apttus_Proposal__Account__c = a.Id;
        proposal.Apttus_Proposal__Primary__c = true;
        proposal.Tax_Payment_Option__c = '';
        proposal.APTS_ZPEND_Check__c=true;
        insert proposal;    
        
        Apttus_Config2__ProductConfiguration__c prodConf2 = new Apttus_Config2__ProductConfiguration__c(Name='prod-conf2', CurrencyIsoCode = 'USD', Apttus_QPConfig__Proposald__c=proposal.id, APTS_SSD_ship_to__c=accountSSD.Id,APTS_SSD_bill_to__c=accountSSD.Id);
        insert prodConf2;
        
        Product2 prod = new Product2(name='prod1', Media_High_Level__c='Online', CurrencyIsoCode = 'USD');
        prod.APTS_Approval_Always_Required__c = true;
        insert prod;
        
         Apttus_Config2__ConfigSystemProperties__c configSetting=new Apttus_Config2__ConfigSystemProperties__c(Name='System Properties',Apttus_Config2__DisableConstraintRules__c=true);
        insert configSetting;
        
        List<Apttus_Config2__LineItem__c> listOfLineItems = new List<Apttus_Config2__LineItem__c>();        
        
        Apttus_Config2__LineItem__c li6 = new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c=prodConf2.id , Apttus_Config2__ProductId__c=prod.id);
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
        listOfLineItems.add(li7);
        
        insert listOfLineItems;
        
        prodConf2.Apttus_Config2__Status__c = 'Finalized';
        update prodConf2;
        
        List<Apttus_Config2__PriceListItem__c> listPli= new  List<Apttus_Config2__PriceListItem__c>();
        
        Apttus_Config2__PriceListItem__c pli= new Apttus_Config2__PriceListItem__c();
        pli.Apttus_Config2__PriceListId__c=pl.id;
        pli.Apttus_Config2__ProductId__c=prod.id;
        pli.Apttus_Config2__ListPrice__c=200;
        //pli.Apttus_QPConfig__PriceType__c = 'One Time'
        listPli.add(pli);
        
        Apttus_Config2__PriceListItem__c pli1= new Apttus_Config2__PriceListItem__c();
        pli1.Apttus_Config2__PriceListId__c=pl.id;
        pli1.Apttus_Config2__ProductId__c=prod.id;
        pli1.Apttus_Config2__ListPrice__c=200;
        listPli.add(pli1);
            
        insert listPli;
        
        List<Apttus_Proposal__Proposal_Line_Item__c> listOfProposalLis = new List<Apttus_Proposal__Proposal_Line_Item__c >();
         Apttus_Proposal__Proposal_Line_Item__c  oProposalLi = new Apttus_Proposal__Proposal_Line_Item__c ();
         oProposalLi.Apttus_QPConfig__LineStatus__c ='New';
         oProposalLi.Apttus_Proposal__Proposal__c = proposal.id;
         oProposalLi.Apttus_Proposal__Product__c = prod.Id;
         oProposalLi.Apttus_QPConfig__PriceType__c = 'One Time';
         oProposalLi.Apttus_QPConfig__ChargeType__c ='Standard Price';
         oProposalLi.Apttus_QPConfig__StartDate__c = System.today() ;
         oProposalLi.Apttus_QPConfig__EndDate__c = System.today() + 50 ;
         listOfProposalLis.add(oProposalLi);
         insert listOfProposalLis;
        
        List<Apttus_Proposal__Proposal__c> oProposalafter = [Select Id, 
                     Name,
                     recordType.Name,
                     APTS_SSD_Sold_To__c,
                     APTS_Proposal_Business_Unit__c, 
                     Tax_Payment_Option__c,
                                                       APTS_SSD_Sold_To__r.APTS_Is_Customer__c,
                     APTS_SSD_Sold_To__r.Source_System_Account_Number__c,
                     APTS_SSD_Sold_To__r.Number_Street__c,
                     APTS_SSD_Sold_To__r.Name,
                     APTS_SSD_Sold_To__r.State__c,
                     APTS_SSD_Sold_To__r.Country__c,
                     APTS_SSD_Sold_To__r.City__c,
                     APTS_SSD_Sold_To__r.LCRM_Phone__c,
                     APTS_SSD_Sold_To__r.Postal_Code__c,
                     APTS_Quote_Value__c,
                     Apttus_Proposal__Account__r.SAPAccountNumber__c,
                     Apttus_Proposal__Account__r.Name,
                     APTS_Sold_To_SAP_Account_Number__c,
                     Apttus_Proposal__Amount__c,
                     APTS_Payer__c,
                     APTS_ZPEND_Check__c,
                     APTS_Tax_Payment_Selection__c,
                     APTS_Payment_Option__c
                    from Apttus_Proposal__Proposal__c where id=:proposal.Id];
           Apttus_Proposal__Proposal_Line_Item__c pLineItem = [select ID,Apttus_Proposal__Product__c,Apttus_QPConfig__PriceType__c,Apttus_QPConfig__ChargeType__c,
                                                               Apttus_QPConfig__LineType__c,Apttus_QPConfig__OptionId__c,Apttus_Proposal__Proposal__c, 
                                                               Apttus_Proposal__Proposal__r.Tax_Payment_Option__c,Apttus_Proposal__Proposal__r.APTS_Tax_Payment_Selection__c,Apttus_Proposal__Proposal__r.APTS_Quote_Value__c,Related_Quote_Proposal__c,
                                                               Apttus_QPConfig__AssetLineItemId__c,Apttus_QPConfig__LineStatus__c
                                                               from Apttus_Proposal__Proposal_Line_Item__c 
                                                               where Apttus_Proposal__Proposal__c =: proposal.Id limit 2]; 
                                                               
                                                               
             List<Apttus_Proposal__Proposal_Line_Item__c> subsPLIs= new List<Apttus_Proposal__Proposal_Line_Item__c>();
             subsPLIs.add(pLineItem);
            // List<Apttus_Proposal__Proposal_Line_Item__c> oneTypePLIs= new List<Apttus_Proposal__Proposal_Line_Item__c>(Id oProposalLi);  
         Test.startTest();
            System.assertEquals(1,oProposalafter.size());
            PageReference pref=Page.AutopaymentButton;
            pref.getParameters().put('id',proposal.Id);
            Test.setCurrentPage(pref);
            ApexPages.standardController sc = new ApexPages.standardController(proposal);
            Tax_APTS_PaymentValidationController con = new Tax_APTS_PaymentValidationController(sc);
            con.pay ='Payment Express Auto EFT/Auto Charge';
            Decimal amount = 250.50;
            con.getPayName();
            con.save();
            List<SelectOption> lst = con.getPayName();
        Test.stopTest();
        
    }
    
    @isTest
    public static void getPaymentMethod2() {
              
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
        
        KeyValueListStore__c keyvaluestore1=new  KeyValueListStore__c();
        keyvaluestore1.Name='LatamGGOProductId';
        keyvaluestore1.TextValue__c='SF07';
        insert keyvaluestore1;
        
        List<RecordtypeIds__c> recordlist=new List<RecordtypeIds__c>();
        RecordtypeIds__c recordtype=new RecordtypeIds__c();
        recordtype.Name='Pre-Pipeline Opportunities';
        recordtype.recTypeId__c=System.Label.APTS_OC_Test_Id;
        recordlist.add(recordtype);
        
        RecordtypeIds__c recordtype1=new RecordtypeIds__c();
        recordtype1.Name='Pipeline Opportunities';
        recordtype1.recTypeId__c=System.Label.APTS_OC_Test_Id;
        recordlist.add(recordtype1);
        
        RecordtypeIds__c recordtype2=new RecordtypeIds__c();
        recordtype2.Name='GLI Pipeline Opportunity';
        recordtype2.recTypeId__c=System.Label.APTS_OC_Test_Id;
        recordlist.add(recordtype2);
        
        insert recordlist;
         profile_list__c plist = new profile_list__c(name = 'Partner Portal User',Profile_Name__c='Partner Portal User',ProfileId__c = System.Label.APTS_OC_Test_Id);
        insert plist;
        
        Account a = APTS_TestDataFactory.createAccount('Testing Account');
        a.Customer_Group__c = 'Customer Class';
        insert a;
        system.debug('@@@@@@@@Account'+a);
        
        Contact cont=APTS_TestDataFactory.createContact('Kaur',a.id);
        cont.FirstName='Navpreet';
        cont.Email='abc@gmail.com';
        cont.Phone='9873337890';
        insert cont;
        system.debug('@@@@@@@@Contact'+cont);
        
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();
        Source_System_Detail__c accountSSD= new Source_System_Detail__c();
        accountSSD.RecordtypeId=ssdRecorType;
        accountSSD.Name='ABC';
        accountSSD.Source_System_Name__c='ABC';
        accountSSD.Account_Name__c=a.ID;
        accountSSD.Account_Inactive__c=false;
        accountSSD.LCRM_Sales_Org__c='BEJE';
        accountSSD.Source_System_Account_Number__c='';
        accountSSD.APTS_Is_Customer__c = false;
        insert accountSSD;
        
        Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        Opportunity oppty=APTS_TestDataFactory.createOpportunity('abc',a.id,'Needs Analysis',Date.Today());
        oppty.RecordtypeId=opptyRecorType;
        oppty.Source_System_Detail__c=accountSSD.id;
        oppty.Email__c='abc@tcs.com';
        oppty.Account=a;
        insert oppty;
        
        Apttus_Config2__PriceList__c pl= APTS_TestDataFactory.createPriceList('Test Price List 1');
        insert pl;
        
        Id propRecorType=Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Proposal').getRecordTypeId();
        system.debug('$$$$$$$'+accountSSD);
        Apttus_Proposal__Proposal__c proposal = APTS_TestDataFactory.createProposal(oppty.id,a.Id);
        proposal.Apttus_Proposal__Approval_Stage__c='Draft';
        proposal.Apttus_Proposal__Account__c = a.Id;
        proposal.APTS_Proposal_Business_Unit__c='Tax Professional';
        proposal.RecordtypeId = propRecorType;
        proposal.Apttus_Proposal__Opportunity__c = oppty.id;
        proposal.CurrencyIsoCode = 'ARS';
        proposal.APTS_SSD_Sold_To__c = accountSSD.Id;
        proposal.APTS_Payer__c = accountSSD.Id;
        proposal.Apttus_Proposal__Account__c = a.Id;
        proposal.Apttus_Proposal__Primary__c = true;
        proposal.Tax_Payment_Option__c = '';
        proposal.APTS_ZPEND_Check__c=true;
        insert proposal;    
        
        Apttus_Config2__ProductConfiguration__c prodConf2 = new Apttus_Config2__ProductConfiguration__c(Name='prod-conf2', CurrencyIsoCode = 'USD', Apttus_QPConfig__Proposald__c=proposal.id, APTS_SSD_ship_to__c=accountSSD.Id,APTS_SSD_bill_to__c=accountSSD.Id);
        insert prodConf2;
        
        Product2 prod = new Product2(name='prod1', Media_High_Level__c='Online', CurrencyIsoCode = 'USD');
        prod.APTS_Approval_Always_Required__c = true;
        insert prod;
        
         Apttus_Config2__ConfigSystemProperties__c configSetting=new Apttus_Config2__ConfigSystemProperties__c(Name='System Properties',Apttus_Config2__DisableConstraintRules__c=true);
        insert configSetting;
        
        List<Apttus_Config2__LineItem__c> listOfLineItems = new List<Apttus_Config2__LineItem__c>();        
        
        Apttus_Config2__LineItem__c li6 = new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c=prodConf2.id , Apttus_Config2__ProductId__c=prod.id);
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
        li6.Apttus_Config2__NetPrice__c = 850;
        li6.Apttus_Config2__NetUnitPrice__c = 50;
        li6.Apttus_Config2__OptionSequence__c = 0;        
        li6.Apttus_Config2__PriceMethod__c = 'Per Unit';
        li6.Apttus_Config2__PriceType__c = 'Recurring';
        li6.Apttus_Config2__PriceUom__c = 'Attorneys';
        li6.Apttus_Config2__PricingStatus__c = 'Complete';       
        li6.APTS_Product_Family__c='RUTTER';
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
        listOfLineItems.add(li7);
        
        insert listOfLineItems;
        
        prodConf2.Apttus_Config2__Status__c = 'Finalized';
        update prodConf2;
        
        List<Apttus_Config2__PriceListItem__c> listPli= new  List<Apttus_Config2__PriceListItem__c>();
        
        Apttus_Config2__PriceListItem__c pli= new Apttus_Config2__PriceListItem__c();
        pli.Apttus_Config2__PriceListId__c=pl.id;
        pli.Apttus_Config2__ProductId__c=prod.id;
        pli.Apttus_Config2__ListPrice__c=1000;
        //pli.Apttus_QPConfig__PriceType__c = 'One Time'
        listPli.add(pli);
        
        Apttus_Config2__PriceListItem__c pli1= new Apttus_Config2__PriceListItem__c();
        pli1.Apttus_Config2__PriceListId__c=pl.id;
        pli1.Apttus_Config2__ProductId__c=prod.id;
        pli1.Apttus_Config2__ListPrice__c=20000;
        listPli.add(pli1);
            
        insert listPli;
        
        List<Apttus_Proposal__Proposal_Line_Item__c> listOfProposalLis = new List<Apttus_Proposal__Proposal_Line_Item__c >();
         Apttus_Proposal__Proposal_Line_Item__c  oProposalLi = new Apttus_Proposal__Proposal_Line_Item__c ();
         oProposalLi.Apttus_QPConfig__LineStatus__c ='New';
         oProposalLi.Apttus_Proposal__Proposal__c = proposal.id;
         oProposalLi.Apttus_Proposal__Product__c = prod.Id;
         oProposalLi.Apttus_QPConfig__PriceType__c = 'Recurring';
         oProposalLi.Apttus_QPConfig__ChargeType__c ='Subscription Fee';
         oProposalLi.Apttus_QPConfig__StartDate__c = System.today() ;
         oProposalLi.Apttus_QPConfig__EndDate__c = System.today() + 50 ;
         listOfProposalLis.add(oProposalLi);
         insert listOfProposalLis;
        
        List<Apttus_Proposal__Proposal__c> oProposalafter = [Select Id, 
                     Name,
                     recordType.Name,
                     APTS_SSD_Sold_To__c,
                     APTS_Proposal_Business_Unit__c, 
                     Tax_Payment_Option__c,
                                                       APTS_SSD_Sold_To__r.APTS_Is_Customer__c,
                     APTS_SSD_Sold_To__r.Source_System_Account_Number__c,
                     APTS_SSD_Sold_To__r.Number_Street__c,
                     APTS_SSD_Sold_To__r.Name,
                     APTS_SSD_Sold_To__r.State__c,
                     APTS_SSD_Sold_To__r.Country__c,
                     APTS_SSD_Sold_To__r.City__c,
                     APTS_SSD_Sold_To__r.LCRM_Phone__c,
                     APTS_SSD_Sold_To__r.Postal_Code__c,
                     APTS_Quote_Value__c,
                     Apttus_Proposal__Account__r.SAPAccountNumber__c,
                     Apttus_Proposal__Account__r.Name,
                     APTS_Sold_To_SAP_Account_Number__c,
                     Apttus_Proposal__Amount__c,
                     APTS_Payer__c,
                     APTS_ZPEND_Check__c,
                     APTS_Tax_Payment_Selection__c,
                     APTS_Payment_Option__c
                    from Apttus_Proposal__Proposal__c where id=:proposal.Id];
           Apttus_Proposal__Proposal_Line_Item__c pLineItem = [select ID,Apttus_Proposal__Product__c,Apttus_QPConfig__PriceType__c,Apttus_QPConfig__ChargeType__c,
                                                               Apttus_QPConfig__LineType__c,Apttus_QPConfig__OptionId__c,Apttus_Proposal__Proposal__c, 
                                                               Apttus_Proposal__Proposal__r.Tax_Payment_Option__c,Apttus_Proposal__Proposal__r.APTS_Tax_Payment_Selection__c,Apttus_Proposal__Proposal__r.APTS_Quote_Value__c,Related_Quote_Proposal__c,
                                                               Apttus_QPConfig__AssetLineItemId__c,Apttus_QPConfig__LineStatus__c
                                                               from Apttus_Proposal__Proposal_Line_Item__c 
                                                               where Apttus_Proposal__Proposal__c =: proposal.Id limit 2]; 
                                                               
                                                               
             List<Apttus_Proposal__Proposal_Line_Item__c> subsPLIs= new List<Apttus_Proposal__Proposal_Line_Item__c>();
             subsPLIs.add(pLineItem);
         Test.startTest();
        
            PageReference pref=Page.AutopaymentButton;
            pref.getParameters().put('id',proposal.Id);
            Test.setCurrentPage(pref);
            ApexPages.standardController sc = new ApexPages.standardController(proposal);
            Tax_APTS_PaymentValidationController con = new Tax_APTS_PaymentValidationController(sc);
            con.pay ='Payment Express Auto EFT/Auto Charge';
            Decimal amount = 750.50;
            con.getPayName();
            con.save();
            List<SelectOption> lst = con.getPayName();
            System.assertEquals(1,oProposalafter.size());
            
        Test.stopTest();
    }

     @isTest
    public static void getPaymentMethodExistingCustomer() {
        
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
        
        KeyValueListStore__c keyvaluestore1=new  KeyValueListStore__c();
        keyvaluestore1.Name='LatamGGOProductId';
        keyvaluestore1.TextValue__c='SF07';
        insert keyvaluestore1;
                
        List<RecordtypeIds__c> recordlist=new List<RecordtypeIds__c>();
        RecordtypeIds__c recordtype=new RecordtypeIds__c();
        recordtype.Name='Pre-Pipeline Opportunities';
        recordtype.recTypeId__c=System.Label.APTS_OC_Test_Id;
        recordlist.add(recordtype);
        
        RecordtypeIds__c recordtype1=new RecordtypeIds__c();
        recordtype1.Name='Pipeline Opportunities';
        recordtype1.recTypeId__c=System.Label.APTS_OC_Test_Id;
        recordlist.add(recordtype1);
        
        RecordtypeIds__c recordtype2=new RecordtypeIds__c();
        recordtype2.Name='GLI Pipeline Opportunity';
        recordtype2.recTypeId__c=System.Label.APTS_OC_Test_Id;
        recordlist.add(recordtype2);
        
        insert recordlist;
        profile_list__c plist = new profile_list__c(name = 'Partner Portal User',Profile_Name__c='Partner Portal User',ProfileId__c = System.Label.APTS_OC_Test_Id);
        insert plist;
        
        Account a = APTS_TestDataFactory.createAccount('Testing Account');
        a.Customer_Group__c = 'Customer Class';
        insert a;
        system.debug('@@@@@@@@Account'+a);
        
        Contact cont=APTS_TestDataFactory.createContact('Kaur',a.id);
        cont.FirstName='Navpreet';
        cont.Email='abc@gmail.com';
        cont.Phone='9873337890';
        insert cont;
        system.debug('@@@@@@@@Contact'+cont);
        
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();
        Source_System_Detail__c accountSSD= new Source_System_Detail__c();
        accountSSD.RecordtypeId=ssdRecorType;
        accountSSD.Name='ABC';
        accountSSD.Source_System_Name__c='ABC';
        accountSSD.Account_Name__c=a.ID;
        accountSSD.Account_Inactive__c=false;
        accountSSD.LCRM_Sales_Org__c='BEJE';
        accountSSD.Source_System_Account_Number__c='1234567890';
        accountSSD.APTS_Is_Customer__c = true;
        accountSSD.Default_Payment_Method__c = 'Payment Express Auto EFT/Auto Charge';
        insert accountSSD;
        
        Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        Opportunity oppty=APTS_TestDataFactory.createOpportunity('abc',a.id,'Needs Analysis',Date.Today());
        oppty.RecordtypeId=opptyRecorType;
        oppty.Source_System_Detail__c=accountSSD.id;
        oppty.Email__c='abc@tcs.com';
        oppty.Account=a;
        insert oppty;
        
        Apttus_Config2__PriceList__c pl= APTS_TestDataFactory.createPriceList('Test Price List 1');
        insert pl;
        
        Id propRecorType=Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Proposal').getRecordTypeId();
        system.debug('$$$$$$$'+accountSSD);
        Apttus_Proposal__Proposal__c proposal = APTS_TestDataFactory.createProposal(oppty.id,a.Id);
        proposal.Apttus_Proposal__Approval_Stage__c='Draft';
        proposal.Apttus_Proposal__Account__c = a.Id;
        proposal.APTS_Proposal_Business_Unit__c='Tax Professional';
        proposal.RecordtypeId = propRecorType;
        proposal.Apttus_Proposal__Opportunity__c = oppty.id;
        proposal.CurrencyIsoCode = 'ARS';
        proposal.APTS_SSD_Sold_To__c = accountSSD.Id;
        proposal.Apttus_Proposal__Account__c = a.Id;
        proposal.Apttus_Proposal__Primary__c = true;
        proposal.Tax_Payment_Option__c = '';        
        proposal.APTS_Payment_Option__c ='Credit Card';
        insert proposal; 
         
        Apttus_Proposal__Proposal__c proposal2 = APTS_TestDataFactory.createProposal(oppty.id,a.Id);
        proposal2.Apttus_Proposal__Approval_Stage__c='Presented';
        proposal2.Apttus_Proposal__Account__c = a.Id;
        proposal2.APTS_Proposal_Business_Unit__c='Tax Professional';
        proposal2.RecordtypeId = propRecorType;
        proposal2.Apttus_Proposal__Opportunity__c = oppty.id;
        proposal2.CurrencyIsoCode = 'ARS';
        proposal2.APTS_SSD_Sold_To__c = accountSSD.Id;
        proposal2.Apttus_Proposal__Account__c = a.Id;
        proposal2.Apttus_Proposal__Primary__c = false;        
        insert proposal2; 
        
        Apttus_Config2__ProductConfiguration__c prodConf2 = new Apttus_Config2__ProductConfiguration__c(Name='prod-conf2', CurrencyIsoCode = 'USD', Apttus_QPConfig__Proposald__c=proposal.id, APTS_SSD_ship_to__c=accountSSD.Id,APTS_SSD_bill_to__c=accountSSD.Id);
        insert prodConf2;
                
        Product2 prod = new Product2(name='prod1', Media_High_Level__c='Online', CurrencyIsoCode = 'USD');
        prod.APTS_Approval_Always_Required__c = true;
        insert prod;
        
        Apttus_Config2__ConfigSystemProperties__c configSetting=new Apttus_Config2__ConfigSystemProperties__c(Name='System Properties',Apttus_Config2__DisableConstraintRules__c=true);
        insert configSetting;
                       
        prodConf2.Apttus_Config2__Status__c = 'Finalized';
        update prodConf2;
               
        List<Apttus_Proposal__Proposal_Line_Item__c> listOfProposalLis = new List<Apttus_Proposal__Proposal_Line_Item__c >();
        Apttus_Proposal__Proposal_Line_Item__c  oProposalLi = new Apttus_Proposal__Proposal_Line_Item__c ();
        oProposalLi.Apttus_QPConfig__LineStatus__c ='New';
        oProposalLi.Apttus_Proposal__Proposal__c = proposal.id;
        oProposalLi.Apttus_Proposal__Product__c = prod.Id;
        oProposalLi.Apttus_QPConfig__PriceType__c = 'One Time';
        oProposalLi.Apttus_QPConfig__ChargeType__c ='Standard Price';
        oProposalLi.Apttus_QPConfig__StartDate__c = System.today() ;
        oProposalLi.Apttus_QPConfig__EndDate__c = System.today() + 50 ;
        listOfProposalLis.add(oProposalLi);
        insert listOfProposalLis;
        
        List<Apttus_Proposal__Proposal__c> oProposalafter = [Select Id, 
                                                       Name,
                                                       recordType.Name,
                                                       APTS_SSD_Sold_To__c,
                                                       APTS_Proposal_Business_Unit__c, 
                                                       Tax_Payment_Option__c,               
                                                       APTS_SSD_Sold_To__r.APTS_Is_Customer__c,
                                                       APTS_SSD_Sold_To__r.Source_System_Account_Number__c,
                                                       APTS_SSD_Sold_To__r.Number_Street__c,
                                                       APTS_SSD_Sold_To__r.Name,
                                                       APTS_SSD_Sold_To__r.State__c,
                                                       APTS_SSD_Sold_To__r.Country__c,
                                                       APTS_SSD_Sold_To__r.City__c,
                                                       APTS_SSD_Sold_To__r.LCRM_Phone__c,
                                                       APTS_SSD_Sold_To__r.Postal_Code__c,
                                                       APTS_Quote_Value__c,
                                                       Apttus_Proposal__Account__r.SAPAccountNumber__c,
                                                       Apttus_Proposal__Account__r.Name,
                                                       APTS_Sold_To_SAP_Account_Number__c,
                                                       Apttus_Proposal__Amount__c,
                                                       APTS_Payer__c,
                                                       APTS_ZPEND_Check__c,
                                                       APTS_Tax_Payment_Selection__c,
                                                       APTS_Payment_Option__c
                                                       from Apttus_Proposal__Proposal__c where id=:proposal.Id];
        Apttus_Proposal__Proposal_Line_Item__c pLineItem = [select ID,Apttus_Proposal__Product__c,Apttus_QPConfig__PriceType__c,Apttus_QPConfig__ChargeType__c,
                                                            Apttus_QPConfig__LineType__c,Apttus_QPConfig__OptionId__c,Apttus_Proposal__Proposal__c, 
                                                            Apttus_Proposal__Proposal__r.Tax_Payment_Option__c,Apttus_Proposal__Proposal__r.APTS_Tax_Payment_Selection__c,Apttus_Proposal__Proposal__r.APTS_Quote_Value__c,Related_Quote_Proposal__c,
                                                            Apttus_QPConfig__AssetLineItemId__c,Apttus_QPConfig__LineStatus__c
                                                            from Apttus_Proposal__Proposal_Line_Item__c 
                                                            where Apttus_Proposal__Proposal__c =: proposal.Id limit 2]; 
        

        List<Apttus_Proposal__Proposal_Line_Item__c> subsPLIs= new List<Apttus_Proposal__Proposal_Line_Item__c>();
        subsPLIs.add(pLineItem);
        // List<Apttus_Proposal__Proposal_Line_Item__c> oneTypePLIs= new List<Apttus_Proposal__Proposal_Line_Item__c>(Id oProposalLi);  
        Test.startTest();
        System.assertEquals(1,oProposalafter.size());
        PageReference pref=Page.AutopaymentButton;
        pref.getParameters().put('id',proposal.Id);
        Test.setCurrentPage(pref);
        ApexPages.standardController sc = new ApexPages.standardController(proposal);
        Tax_APTS_PaymentValidationController con = new Tax_APTS_PaymentValidationController(sc);
        con.pay ='Payment Express Auto EFT/Auto Charge';
        Decimal amount = 250.50;
        con.getPayName();
        con.save();
        List<SelectOption> lst = con.getPayName();      
        
        accountSSD.Default_Payment_Method__c = '';
        update accountSSD;
        Tax_APTS_PaymentValidationController con2 = new Tax_APTS_PaymentValidationController(sc);
        amount = 250.50;
        con2.getPayName();
        con2.save();
        lst = con2.getPayName();
        
        ApexPages.standardController sc2 = new ApexPages.standardController(proposal2);
        Tax_APTS_PaymentValidationController con3 = new Tax_APTS_PaymentValidationController(sc2);
        con3.getPayName();
        con3.save();
        Test.stopTest();
        
    }
  }