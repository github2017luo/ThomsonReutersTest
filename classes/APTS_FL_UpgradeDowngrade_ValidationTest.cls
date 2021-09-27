@isTest
public class APTS_FL_UpgradeDowngrade_ValidationTest {

   @isTest static void validateUpgradeDowngradeErrorTestMethod1(){
       
       Apttus_Config2__PriceList__c priceList = APTS_TestDataFactory.createPriceList('Thomson Reuters Master - US Legal');
       insert priceList;
       insertStaticValues();
        WebServiceSettings__c oWebServiceSettings = new WebServiceSettings__c();
        oWebServiceSettings.Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable'; 
        oWebServiceSettings.Name = 'PaymentCreditIncrease'; 
        oWebServiceSettings.Timeout__c = 120; 
        oWebServiceSettings.Endpoint__c = 'https://dev.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease'; 
        oWebServiceSettings.Active__c = true;
        
        WebServiceSettings__c oWebServiceSettings1 = new WebServiceSettings__c();
        oWebServiceSettings1.Service_Unavailable_Message__c = 'Auto Payment Service is Currently unavailable'; 
        oWebServiceSettings1.Name = 'Payment AutoCharge'; 
        oWebServiceSettings1.Timeout__c = 6000; 
        oWebServiceSettings1.Endpoint__c = 'https://stg.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentAutoCharge'; 
        oWebServiceSettings1.Active__c = true;
        List<WebServiceSettings__c> webServiceList=new List<WebServiceSettings__c>{oWebServiceSettings,oWebServiceSettings1};
        insert webServiceList;

        Account a = APTS_TestDataFactory.createAccount('Test Account');
        insert a;
        
        
        List<RecordtypeIds__c> recordlist=new List<RecordtypeIds__c>();
        RecordtypeIds__c recordtype=new RecordtypeIds__c();
        recordtype.Name='Pre-Pipeline Opportunities';
        recordtype.recTypeId__c='01230000001MA4c';
        recordlist.add(recordtype);
        
        RecordtypeIds__c recordtype1=new RecordtypeIds__c();
        recordtype1.Name='Pipeline Opportunities';
        recordtype1.recTypeId__c='01230000001MA4c';
        recordlist.add(recordtype1);
        insert recordlist;
        
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get(label.SourcesystemdetailUSLRecordtype).getRecordTypeId();
        Source_System_Detail__c accountSSD= APTS_TestDataFactory.createSourceSystem(a);
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
        proposal.APTS_Proposal_Business_Unit__c  ='FindLaw';
        proposal.APTS_Approval_Segment__c  ='FindLaw';
        insert proposal;

        Apttus_Config2__ProductConfiguration__c prodConfig = APTS_TestDataFactory.createProductConfiguration(proposal.Id);
        insert prodConfig;
        ID cartID = prodConfig.Id;
        
        Product2 prod1 = new Product2(name='prod1', Media_High_Level__c='Online', CurrencyIsoCode = 'USD',ProductCode = '404836',APTS_Upgrade_Downgrade_Eligible__c=true);
        Product2 prod2 = new Product2(name='prod2', Media_High_Level__c='Online', CurrencyIsoCode = 'USD',ProductCode='404855');
        Product2 prod3 = new Product2(name='prod3', Media_High_Level__c='Online', CurrencyIsoCode = 'USD',ProductCode='404836');
        Product2 prod4 = new Product2(name='prod4', Media_High_Level__c='Online', CurrencyIsoCode = 'USD',ProductCode='404836');
        Product2 prod5 = new Product2(name='prod5', Media_High_Level__c='Online', CurrencyIsoCode = 'USD',ProductCode='419156',APTS_Upgrade_Downgrade_Eligible__c=true);
        Product2 prod6 = new Product2(name='prod6', Media_High_Level__c='Online', CurrencyIsoCode = 'USD',ProductCode='418928');
        Product2 prod7 = new Product2(name='prod7', Media_High_Level__c='Online', CurrencyIsoCode = 'USD',ProductCode='417671');
        Product2 prod8 = new Product2(name='prod8', Media_High_Level__c='Online', CurrencyIsoCode = 'USD',ProductCode='421240',APTS_Upgrade_Downgrade_Eligible__c=true);
        Product2 prod9 = new Product2(name='prod9', Media_High_Level__c='Online', CurrencyIsoCode = 'USD',ProductCode='418227');
        Product2 prod10 = new Product2(name='prod10', Media_High_Level__c='Online', CurrencyIsoCode = 'USD',ProductCode='417777');
     
        List<Product2> productList=new List<Product2>{prod1,prod2,prod3,prod4,prod5,prod6,prod7,prod8,prod9,prod10};
        insert productList;
        
        Apttus_Config2__PriceListItem__c pliSO = new Apttus_Config2__PriceListItem__c();
          pliSO.Apttus_Config2__Active__c = true;
          pliSO.Apttus_Config2__PriceListId__c = priceList.Id;
          pliSO.APTS_Max_Fill_Up_Price__c = 5;
        insert pliSO;
        
        APTS_Mutually_Exclusive_Rule__c rule1=new APTS_Mutually_Exclusive_Rule__c(name='Rule1',APTS_Product__c=prod1.id,APTS_Mutually_Exclusive_Product__c=prod2.id,APTS_Active__c=true);
        APTS_Mutually_Exclusive_Rule__c rule2=new APTS_Mutually_Exclusive_Rule__c(name='Rule2',APTS_Product__c=prod1.id,APTS_Mutually_Exclusive_Product__c=prod3.id,APTS_Active__c=true);
        APTS_Mutually_Exclusive_Rule__c rule3=new APTS_Mutually_Exclusive_Rule__c(name='Rule3',APTS_Product__c=prod1.id,APTS_Mutually_Exclusive_Product__c=prod4.id);
        APTS_Mutually_Exclusive_Rule__c rule4=new APTS_Mutually_Exclusive_Rule__c(name='Rule4',APTS_Product__c=prod5.id,APTS_Mutually_Exclusive_Product__c=prod6.id);
        APTS_Mutually_Exclusive_Rule__c rule5=new APTS_Mutually_Exclusive_Rule__c(name='Rule5',APTS_Product__c=prod5.id,APTS_Mutually_Exclusive_Product__c=prod7.id);
        APTS_Mutually_Exclusive_Rule__c rule6=new APTS_Mutually_Exclusive_Rule__c(name='Rule6',APTS_Product__c=prod8.id,APTS_Mutually_Exclusive_Product__c=prod9.id);
        APTS_Mutually_Exclusive_Rule__c rule7=new APTS_Mutually_Exclusive_Rule__c(name='Rule7',APTS_Product__c=prod8.id,APTS_Mutually_Exclusive_Product__c=prod10.id);
        
        List<APTS_Mutually_Exclusive_Rule__c> exclusionRulesList=new List<APTS_Mutually_Exclusive_Rule__c>{rule1,rule2,rule3,rule4,rule5,rule6,rule7};      
        insert exclusionRulesList;
        
        
        Apttus_Config2__AssetLineItem__c asset1=new Apttus_Config2__AssetLineItem__c(Apttus_Config2__ProductId__c=prod2.id,Apttus_Config2__Quantity__c=5,Apttus_Config2__AssetStatus__c ='Activated',Apttus_Config2__LineType__c  ='Product/Service',APTS_SSD_Sold_To__c = accountSSD.Id,Apttus_QPConfig__ProposalId__c =proposal.id,Apttus_Config2__EndDate__c=system.today()+20,Apttus_Config2__NetPrice__c=10.0);
        Apttus_Config2__AssetLineItem__c asset2=new Apttus_Config2__AssetLineItem__c(Apttus_Config2__ProductId__c=prod2.id,Apttus_Config2__Quantity__c=5,Apttus_Config2__AssetStatus__c ='Activated',Apttus_Config2__LineType__c  ='Product/Service',APTS_SSD_Sold_To__c = accountSSD.Id,Apttus_QPConfig__ProposalId__c =proposal.id,Apttus_Config2__EndDate__c=system.today()+20,Apttus_Config2__NetPrice__c=10.0);
        Apttus_Config2__AssetLineItem__c asset3=new Apttus_Config2__AssetLineItem__c(Apttus_Config2__ProductId__c=prod3.id,Apttus_Config2__Quantity__c=5,Apttus_Config2__AssetStatus__c ='Activated',Apttus_Config2__LineType__c  ='Product/Service',APTS_SSD_Sold_To__c = accountSSD.Id,Apttus_QPConfig__ProposalId__c =proposal.id,Apttus_Config2__EndDate__c=system.today()+20,Apttus_Config2__NetPrice__c=10.0);
        Apttus_Config2__AssetLineItem__c asset4=new Apttus_Config2__AssetLineItem__c(Apttus_Config2__ProductId__c=prod4.id,Apttus_Config2__Quantity__c=5,Apttus_Config2__AssetStatus__c ='Activated',Apttus_Config2__LineType__c  ='Product/Service',APTS_SSD_Sold_To__c = accountSSD.Id,Apttus_QPConfig__ProposalId__c =proposal.id,Apttus_Config2__EndDate__c=system.today()+20,Apttus_Config2__NetPrice__c=10.0);
        Apttus_Config2__AssetLineItem__c asset5=new Apttus_Config2__AssetLineItem__c(Apttus_Config2__ProductId__c=prod4.id,Apttus_Config2__Quantity__c=5,Apttus_Config2__AssetStatus__c ='Pending Cancellation',Apttus_Config2__LineType__c  ='Product/Service',APTS_SSD_Sold_To__c = accountSSD.Id,Apttus_QPConfig__ProposalId__c =proposal.id,Apttus_Config2__EndDate__c=system.today()+20,Apttus_Config2__NetPrice__c=10.0);
        
        List<Apttus_Config2__AssetLineItem__c> assetLinesList = New List<Apttus_Config2__AssetLineItem__c>{asset1,asset2,asset3,asset4,asset5};
        insert assetLinesList;
        
        Apttus_Config2__LineItem__c lineItem1=new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c=prodConfig.id , Apttus_Config2__ProductId__c=prod1.id,Apttus_Config2__LineType__c ='Product/Service',APTS_SSD_ship_to__c=accountSSD.id,Apttus_Config2__LineStatus__c = 'New',Apttus_Config2__ChargeType__c = 'Subscription Fee',Apttus_Config2__ItemSequence__c = 1,Apttus_Config2__LineNumber__c = 1,Apttus_Config2__ListPrice__c = 100,Apttus_Config2__NetAdjustmentPercent__c = -50,Apttus_Config2__NetPrice__c = 50,Apttus_Config2__NetUnitPrice__c = 50,Apttus_Config2__AdjustedPrice__c = 50,Apttus_Config2__AdjustmentAmount__c = 50,Apttus_Config2__AdjustmentType__c = '% Discount',Apttus_Config2__AddedBy__c = 'User',CurrencyIsoCode = 'USD',Apttus_Config2__EndDate__c=system.today()+20,Apttus_Config2__PriceListItemId__c = pliSO.id);     
        Apttus_Config2__LineItem__c lineItem2=new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c=prodConfig.id , Apttus_Config2__ProductId__c=prod5.id,Apttus_Config2__LineType__c ='Product/Service',APTS_SSD_ship_to__c=accountSSD.id,Apttus_Config2__LineStatus__c = 'New',Apttus_Config2__ChargeType__c = 'Subscription Fee',Apttus_Config2__ItemSequence__c = 1,Apttus_Config2__LineNumber__c = 1,Apttus_Config2__ListPrice__c = 100,Apttus_Config2__NetAdjustmentPercent__c = -50,Apttus_Config2__NetPrice__c = 50,Apttus_Config2__NetUnitPrice__c = 50,Apttus_Config2__AdjustedPrice__c = 50,Apttus_Config2__AdjustmentAmount__c = 50,Apttus_Config2__AdjustmentType__c = '% Discount',Apttus_Config2__AddedBy__c = 'User',CurrencyIsoCode = 'USD',Apttus_Config2__EndDate__c=system.today()+20,Apttus_Config2__PriceListItemId__c = pliSO.id);
        Apttus_Config2__LineItem__c lineItem3=new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c=prodConfig.id , Apttus_Config2__ProductId__c=prod6.id,Apttus_Config2__LineType__c ='Product/Service',APTS_SSD_ship_to__c=accountSSD.id,Apttus_Config2__LineStatus__c = 'New',Apttus_Config2__ChargeType__c = 'Subscription Fee',Apttus_Config2__ItemSequence__c = 1,Apttus_Config2__LineNumber__c = 1,Apttus_Config2__ListPrice__c = 100,Apttus_Config2__NetAdjustmentPercent__c = -50,Apttus_Config2__NetPrice__c = 50,Apttus_Config2__NetUnitPrice__c = 50,Apttus_Config2__AdjustedPrice__c = 50,Apttus_Config2__AdjustmentAmount__c = 50,Apttus_Config2__AdjustmentType__c = '% Discount',Apttus_Config2__AddedBy__c = 'User',CurrencyIsoCode = 'USD',Apttus_Config2__EndDate__c=system.today()+20,Apttus_Config2__PriceListItemId__c = pliSO.id);
        Apttus_Config2__LineItem__c lineItem4=new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c=prodConfig.id , Apttus_Config2__ProductId__c=prod7.id,Apttus_Config2__LineType__c ='Product/Service',APTS_SSD_ship_to__c=accountSSD.id,Apttus_Config2__LineStatus__c = 'New',Apttus_Config2__ChargeType__c = 'Subscription Fee',Apttus_Config2__ItemSequence__c = 1,Apttus_Config2__LineNumber__c = 1,Apttus_Config2__ListPrice__c = 100,Apttus_Config2__NetAdjustmentPercent__c = -50,Apttus_Config2__NetPrice__c = 50,Apttus_Config2__NetUnitPrice__c = 50,Apttus_Config2__AdjustedPrice__c = 50,Apttus_Config2__AdjustmentAmount__c = 50,Apttus_Config2__AdjustmentType__c = '% Discount',Apttus_Config2__AddedBy__c = 'User',CurrencyIsoCode = 'USD',Apttus_Config2__EndDate__c=system.today()+20,Apttus_Config2__PriceListItemId__c = pliSO.id);
        Apttus_Config2__LineItem__c lineItem5=new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c=prodConfig.id , Apttus_Config2__ProductId__c=prod8.id,Apttus_Config2__LineType__c ='Product/Service',APTS_SSD_ship_to__c=accountSSD.id,Apttus_Config2__LineStatus__c = 'New',Apttus_Config2__ChargeType__c = 'Subscription Fee',Apttus_Config2__ItemSequence__c = 1,Apttus_Config2__LineNumber__c = 1,Apttus_Config2__ListPrice__c = 100,Apttus_Config2__NetAdjustmentPercent__c = -50,Apttus_Config2__NetPrice__c = 50,Apttus_Config2__NetUnitPrice__c = 50,Apttus_Config2__AdjustedPrice__c = 50,Apttus_Config2__AdjustmentAmount__c = 50,Apttus_Config2__AdjustmentType__c = '% Discount',Apttus_Config2__AddedBy__c = 'User',CurrencyIsoCode = 'USD',Apttus_Config2__EndDate__c=system.today()+20,Apttus_Config2__PriceListItemId__c = pliSO.id);
        Apttus_Config2__LineItem__c lineItem6=new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c=prodConfig.id , Apttus_Config2__ProductId__c=prod1.id,Apttus_Config2__LineType__c ='Product/Service',APTS_SSD_ship_to__c=accountSSD.id,Apttus_Config2__LineStatus__c = 'New',Apttus_Config2__ChargeType__c = 'Subscription Fee',Apttus_Config2__ItemSequence__c = 1,Apttus_Config2__LineNumber__c = 1,Apttus_Config2__ListPrice__c = 100,Apttus_Config2__NetAdjustmentPercent__c = -50,Apttus_Config2__NetPrice__c = 50,Apttus_Config2__NetUnitPrice__c = 50,Apttus_Config2__AdjustedPrice__c = 50,Apttus_Config2__AdjustmentAmount__c = 50,Apttus_Config2__AdjustmentType__c = '% Discount',Apttus_Config2__AddedBy__c = 'User',CurrencyIsoCode = 'USD',Apttus_Config2__EndDate__c=system.today()+20,Apttus_Config2__PriceListItemId__c = pliSO.id);
        Apttus_Config2__LineItem__c lineItem7=new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c=prodConfig.id , Apttus_Config2__ProductId__c=prod2.id,Apttus_Config2__LineType__c ='Product/Service',APTS_SSD_ship_to__c=accountSSD.id,Apttus_Config2__LineStatus__c = 'New',Apttus_Config2__ChargeType__c = 'Subscription Fee',Apttus_Config2__ItemSequence__c = 1,Apttus_Config2__LineNumber__c = 1,Apttus_Config2__ListPrice__c = 100,Apttus_Config2__NetAdjustmentPercent__c = -50,Apttus_Config2__NetPrice__c = 50,Apttus_Config2__NetUnitPrice__c = 50,Apttus_Config2__AdjustedPrice__c = 50,Apttus_Config2__AdjustmentAmount__c = 50,Apttus_Config2__AdjustmentType__c = '% Discount',Apttus_Config2__AddedBy__c = 'User',CurrencyIsoCode = 'USD',Apttus_Config2__EndDate__c=system.today()+20,Apttus_Config2__PriceListItemId__c = pliSO.id);
     
        List<Apttus_Config2__LineItem__c> lineItemsList=new List<Apttus_Config2__LineItem__c>{lineItem1,lineItem2,lineItem3,lineItem4,lineItem6,lineItem7};      
        insert lineItemsList; 
        
        
        Test.startTest();
         Apttus_Config2.CallbackTester.testValidationCallback
                                              ( cartID
                                              , lineItemsList
                                              , null
                                              , new APTS_Validation_Callback ());   
        Test.stopTest(); 
   }
@isTest static void validateUpgradeDowngradeErrorTestMethod2(){
       
       Apttus_Config2__PriceList__c priceList = APTS_TestDataFactory.createPriceList('Thomson Reuters Master - US Legal');
       insert priceList;
       
       insertStaticValues();
        WebServiceSettings__c oWebServiceSettings = new WebServiceSettings__c();
        oWebServiceSettings.Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable'; 
        oWebServiceSettings.Name = 'PaymentCreditIncrease'; 
        oWebServiceSettings.Timeout__c = 120; 
        oWebServiceSettings.Endpoint__c = 'https://dev.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease'; 
        oWebServiceSettings.Active__c = true;
        
        WebServiceSettings__c oWebServiceSettings1 = new WebServiceSettings__c();
        oWebServiceSettings1.Service_Unavailable_Message__c = 'Auto Payment Service is Currently unavailable'; 
        oWebServiceSettings1.Name = 'Payment AutoCharge'; 
        oWebServiceSettings1.Timeout__c = 6000; 
        oWebServiceSettings1.Endpoint__c = 'https://stg.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentAutoCharge'; 
        oWebServiceSettings1.Active__c = true;
        List<WebServiceSettings__c> webServiceList=new List<WebServiceSettings__c>{oWebServiceSettings,oWebServiceSettings1};
        insert webServiceList;

        Account a = APTS_TestDataFactory.createAccount('Test Account');
        insert a;
        
        
        List<RecordtypeIds__c> recordlist=new List<RecordtypeIds__c>();
        RecordtypeIds__c recordtype=new RecordtypeIds__c();
        recordtype.Name='Pre-Pipeline Opportunities';
        recordtype.recTypeId__c='01230000001MA4c';
        recordlist.add(recordtype);
        
        RecordtypeIds__c recordtype1=new RecordtypeIds__c();
        recordtype1.Name='Pipeline Opportunities';
        recordtype1.recTypeId__c='01230000001MA4c';
        recordlist.add(recordtype1);
        insert recordlist;
        
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get(label.SourcesystemdetailUSLRecordtype).getRecordTypeId();
        Source_System_Detail__c accountSSD= APTS_TestDataFactory.createSourceSystem(a);
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
        proposal.APTS_Proposal_Business_Unit__c  ='FindLaw';
        proposal.APTS_Approval_Segment__c  ='FindLaw';
        insert proposal;

        Apttus_Config2__ProductConfiguration__c prodConfig = APTS_TestDataFactory.createProductConfiguration(proposal.Id);
        insert prodConfig;
        ID cartID = prodConfig.Id;
        
        Product2 prod1 = new Product2(name='prod1', Media_High_Level__c='Online', CurrencyIsoCode = 'USD',ProductCode = '404836',APTS_Upgrade_Downgrade_Eligible__c=true);
        Product2 prod2 = new Product2(name='prod2', Media_High_Level__c='Online', CurrencyIsoCode = 'USD',ProductCode='404855');
        Product2 prod3 = new Product2(name='prod3', Media_High_Level__c='Online', CurrencyIsoCode = 'USD',ProductCode='404836');
        Product2 prod4 = new Product2(name='prod4', Media_High_Level__c='Online', CurrencyIsoCode = 'USD',ProductCode='404836');
        Product2 prod5 = new Product2(name='prod5', Media_High_Level__c='Online', CurrencyIsoCode = 'USD',ProductCode='419156',APTS_Upgrade_Downgrade_Eligible__c=true);
        Product2 prod6 = new Product2(name='prod6', Media_High_Level__c='Online', CurrencyIsoCode = 'USD',ProductCode='418928');
        Product2 prod7 = new Product2(name='prod7', Media_High_Level__c='Online', CurrencyIsoCode = 'USD',ProductCode='417671');
        Product2 prod8 = new Product2(name='prod8', Media_High_Level__c='Online', CurrencyIsoCode = 'USD',ProductCode='421240',APTS_Upgrade_Downgrade_Eligible__c=true);
        Product2 prod9 = new Product2(name='prod9', Media_High_Level__c='Online', CurrencyIsoCode = 'USD',ProductCode='418227');
        Product2 prod10 = new Product2(name='prod10', Media_High_Level__c='Online', CurrencyIsoCode = 'USD',ProductCode='417777');
     
        List<Product2> productList=new List<Product2>{prod1,prod2,prod3,prod4,prod5,prod6,prod7,prod8,prod9,prod10};
        insert productList;
        
        Apttus_Config2__PriceListItem__c pliSO = new Apttus_Config2__PriceListItem__c();
          pliSO.Apttus_Config2__Active__c = true;
          pliSO.Apttus_Config2__PriceListId__c = priceList.Id;
          pliSO.APTS_Max_Fill_Up_Price__c = 5;
        insert pliSO;
        
        APTS_Mutually_Exclusive_Rule__c rule1=new APTS_Mutually_Exclusive_Rule__c(name='Rule1',APTS_Product__c=prod1.id,APTS_Mutually_Exclusive_Product__c=prod2.id,APTS_Active__c=true);
        APTS_Mutually_Exclusive_Rule__c rule2=new APTS_Mutually_Exclusive_Rule__c(name='Rule2',APTS_Product__c=prod1.id,APTS_Mutually_Exclusive_Product__c=prod3.id,APTS_Active__c=true);
        APTS_Mutually_Exclusive_Rule__c rule3=new APTS_Mutually_Exclusive_Rule__c(name='Rule3',APTS_Product__c=prod1.id,APTS_Mutually_Exclusive_Product__c=prod4.id);
        APTS_Mutually_Exclusive_Rule__c rule4=new APTS_Mutually_Exclusive_Rule__c(name='Rule4',APTS_Product__c=prod5.id,APTS_Mutually_Exclusive_Product__c=prod6.id);
        APTS_Mutually_Exclusive_Rule__c rule5=new APTS_Mutually_Exclusive_Rule__c(name='Rule5',APTS_Product__c=prod5.id,APTS_Mutually_Exclusive_Product__c=prod7.id);
        APTS_Mutually_Exclusive_Rule__c rule6=new APTS_Mutually_Exclusive_Rule__c(name='Rule6',APTS_Product__c=prod8.id,APTS_Mutually_Exclusive_Product__c=prod9.id);
        APTS_Mutually_Exclusive_Rule__c rule7=new APTS_Mutually_Exclusive_Rule__c(name='Rule7',APTS_Product__c=prod8.id,APTS_Mutually_Exclusive_Product__c=prod10.id);
        
        List<APTS_Mutually_Exclusive_Rule__c> exclusionRulesList=new List<APTS_Mutually_Exclusive_Rule__c>{rule1,rule2,rule3,rule4,rule5,rule6,rule7};      
        insert exclusionRulesList;
        
        
        Apttus_Config2__AssetLineItem__c asset1=new Apttus_Config2__AssetLineItem__c(Apttus_Config2__ProductId__c=prod2.id,Apttus_Config2__Quantity__c=5,Apttus_Config2__AssetStatus__c ='Activated',Apttus_Config2__LineType__c  ='Product/Service',APTS_SSD_Sold_To__c = accountSSD.Id,Apttus_QPConfig__ProposalId__c =proposal.id,Apttus_Config2__EndDate__c=system.today()+20,Apttus_Config2__NetPrice__c=10.0);
        Apttus_Config2__AssetLineItem__c asset2=new Apttus_Config2__AssetLineItem__c(Apttus_Config2__ProductId__c=prod2.id,Apttus_Config2__Quantity__c=5,Apttus_Config2__AssetStatus__c ='Activated',Apttus_Config2__LineType__c  ='Product/Service',APTS_SSD_Sold_To__c = accountSSD.Id,Apttus_QPConfig__ProposalId__c =proposal.id,Apttus_Config2__EndDate__c=system.today()+20,Apttus_Config2__NetPrice__c=10.0);
        Apttus_Config2__AssetLineItem__c asset3=new Apttus_Config2__AssetLineItem__c(Apttus_Config2__ProductId__c=prod3.id,Apttus_Config2__Quantity__c=5,Apttus_Config2__AssetStatus__c ='Activated',Apttus_Config2__LineType__c  ='Product/Service',APTS_SSD_Sold_To__c = accountSSD.Id,Apttus_QPConfig__ProposalId__c =proposal.id,Apttus_Config2__EndDate__c=system.today()+20,Apttus_Config2__NetPrice__c=10.0);
        Apttus_Config2__AssetLineItem__c asset4=new Apttus_Config2__AssetLineItem__c(Apttus_Config2__ProductId__c=prod4.id,Apttus_Config2__Quantity__c=5,Apttus_Config2__AssetStatus__c ='Activated',Apttus_Config2__LineType__c  ='Product/Service',APTS_SSD_Sold_To__c = accountSSD.Id,Apttus_QPConfig__ProposalId__c =proposal.id,Apttus_Config2__EndDate__c=system.today()+20,Apttus_Config2__NetPrice__c=10.0);
        Apttus_Config2__AssetLineItem__c asset5=new Apttus_Config2__AssetLineItem__c(Apttus_Config2__ProductId__c=prod4.id,Apttus_Config2__Quantity__c=5,Apttus_Config2__AssetStatus__c ='Pending Cancellation',Apttus_Config2__LineType__c  ='Product/Service',APTS_SSD_Sold_To__c = accountSSD.Id,Apttus_QPConfig__ProposalId__c =proposal.id,Apttus_Config2__EndDate__c=system.today()+20,Apttus_Config2__NetPrice__c=10.0);
        
        List<Apttus_Config2__AssetLineItem__c> assetLinesList = New List<Apttus_Config2__AssetLineItem__c>{asset1,asset2,asset3,asset4,asset5};
        insert assetLinesList;
        
        Apttus_Config2__LineItem__c lineItem1=new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c=prodConfig.id , Apttus_Config2__ProductId__c=prod1.id,Apttus_Config2__LineType__c ='Product/Service',APTS_SSD_ship_to__c=accountSSD.id,Apttus_Config2__LineStatus__c = 'New',Apttus_Config2__ChargeType__c = 'Subscription Fee',Apttus_Config2__ItemSequence__c = 1,Apttus_Config2__LineNumber__c = 1,Apttus_Config2__ListPrice__c = 100,Apttus_Config2__NetAdjustmentPercent__c = -50,Apttus_Config2__NetPrice__c = 50,Apttus_Config2__NetUnitPrice__c = 50,Apttus_Config2__AdjustedPrice__c = 50,Apttus_Config2__AdjustmentAmount__c = 50,Apttus_Config2__AdjustmentType__c = '% Discount',Apttus_Config2__AddedBy__c = 'User',CurrencyIsoCode = 'USD',Apttus_Config2__EndDate__c=system.today()+20,Apttus_Config2__PriceListItemId__c = pliSO.id);     
        Apttus_Config2__LineItem__c lineItem2=new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c=prodConfig.id , Apttus_Config2__ProductId__c=prod5.id,Apttus_Config2__LineType__c ='Product/Service',APTS_SSD_ship_to__c=accountSSD.id,Apttus_Config2__LineStatus__c = 'New',Apttus_Config2__ChargeType__c = 'Subscription Fee',Apttus_Config2__ItemSequence__c = 1,Apttus_Config2__LineNumber__c = 1,Apttus_Config2__ListPrice__c = 100,Apttus_Config2__NetAdjustmentPercent__c = -50,Apttus_Config2__NetPrice__c = 50,Apttus_Config2__NetUnitPrice__c = 50,Apttus_Config2__AdjustedPrice__c = 50,Apttus_Config2__AdjustmentAmount__c = 50,Apttus_Config2__AdjustmentType__c = '% Discount',Apttus_Config2__AddedBy__c = 'User',CurrencyIsoCode = 'USD',Apttus_Config2__EndDate__c=system.today()+20,Apttus_Config2__PriceListItemId__c = pliSO.id);
        Apttus_Config2__LineItem__c lineItem3=new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c=prodConfig.id , Apttus_Config2__ProductId__c=prod6.id,Apttus_Config2__LineType__c ='Product/Service',APTS_SSD_ship_to__c=accountSSD.id,Apttus_Config2__LineStatus__c = 'New',Apttus_Config2__ChargeType__c = 'Subscription Fee',Apttus_Config2__ItemSequence__c = 1,Apttus_Config2__LineNumber__c = 1,Apttus_Config2__ListPrice__c = 100,Apttus_Config2__NetAdjustmentPercent__c = -50,Apttus_Config2__NetPrice__c = 50,Apttus_Config2__NetUnitPrice__c = 50,Apttus_Config2__AdjustedPrice__c = 50,Apttus_Config2__AdjustmentAmount__c = 50,Apttus_Config2__AdjustmentType__c = '% Discount',Apttus_Config2__AddedBy__c = 'User',CurrencyIsoCode = 'USD',Apttus_Config2__EndDate__c=system.today()+20,Apttus_Config2__PriceListItemId__c = pliSO.id);
        Apttus_Config2__LineItem__c lineItem4=new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c=prodConfig.id , Apttus_Config2__ProductId__c=prod7.id,Apttus_Config2__LineType__c ='Product/Service',APTS_SSD_ship_to__c=accountSSD.id,Apttus_Config2__LineStatus__c = 'New',Apttus_Config2__ChargeType__c = 'Subscription Fee',Apttus_Config2__ItemSequence__c = 1,Apttus_Config2__LineNumber__c = 1,Apttus_Config2__ListPrice__c = 100,Apttus_Config2__NetAdjustmentPercent__c = -50,Apttus_Config2__NetPrice__c = 50,Apttus_Config2__NetUnitPrice__c = 50,Apttus_Config2__AdjustedPrice__c = 50,Apttus_Config2__AdjustmentAmount__c = 50,Apttus_Config2__AdjustmentType__c = '% Discount',Apttus_Config2__AddedBy__c = 'User',CurrencyIsoCode = 'USD',Apttus_Config2__EndDate__c=system.today()+20,Apttus_Config2__PriceListItemId__c = pliSO.id);
        Apttus_Config2__LineItem__c lineItem5=new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c=prodConfig.id , Apttus_Config2__ProductId__c=prod8.id,Apttus_Config2__LineType__c ='Product/Service',APTS_SSD_ship_to__c=accountSSD.id,Apttus_Config2__LineStatus__c = 'New',Apttus_Config2__ChargeType__c = 'Subscription Fee',Apttus_Config2__ItemSequence__c = 1,Apttus_Config2__LineNumber__c = 1,Apttus_Config2__ListPrice__c = 100,Apttus_Config2__NetAdjustmentPercent__c = -50,Apttus_Config2__NetPrice__c = 50,Apttus_Config2__NetUnitPrice__c = 50,Apttus_Config2__AdjustedPrice__c = 50,Apttus_Config2__AdjustmentAmount__c = 50,Apttus_Config2__AdjustmentType__c = '% Discount',Apttus_Config2__AddedBy__c = 'User',CurrencyIsoCode = 'USD',Apttus_Config2__EndDate__c=system.today()+20,Apttus_Config2__PriceListItemId__c = pliSO.id);
        Apttus_Config2__LineItem__c lineItem6=new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c=prodConfig.id , Apttus_Config2__ProductId__c=prod1.id,Apttus_Config2__LineType__c ='Product/Service',APTS_SSD_ship_to__c=accountSSD.id,Apttus_Config2__LineStatus__c = 'New',Apttus_Config2__ChargeType__c = 'Subscription Fee',Apttus_Config2__ItemSequence__c = 1,Apttus_Config2__LineNumber__c = 1,Apttus_Config2__ListPrice__c = 100,Apttus_Config2__NetAdjustmentPercent__c = -50,Apttus_Config2__NetPrice__c = 50,Apttus_Config2__NetUnitPrice__c = 50,Apttus_Config2__AdjustedPrice__c = 50,Apttus_Config2__AdjustmentAmount__c = 50,Apttus_Config2__AdjustmentType__c = '% Discount',Apttus_Config2__AddedBy__c = 'User',CurrencyIsoCode = 'USD',Apttus_Config2__EndDate__c=system.today()+20,Apttus_Config2__PriceListItemId__c = pliSO.id);
        Apttus_Config2__LineItem__c lineItem7=new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c=prodConfig.id , Apttus_Config2__ProductId__c=prod2.id,Apttus_Config2__LineType__c ='Product/Service',APTS_SSD_ship_to__c=accountSSD.id,Apttus_Config2__LineStatus__c = 'New',Apttus_Config2__ChargeType__c = 'Subscription Fee',Apttus_Config2__ItemSequence__c = 1,Apttus_Config2__LineNumber__c = 1,Apttus_Config2__ListPrice__c = 100,Apttus_Config2__NetAdjustmentPercent__c = -50,Apttus_Config2__NetPrice__c = 50,Apttus_Config2__NetUnitPrice__c = 50,Apttus_Config2__AdjustedPrice__c = 50,Apttus_Config2__AdjustmentAmount__c = 50,Apttus_Config2__AdjustmentType__c = '% Discount',Apttus_Config2__AddedBy__c = 'User',CurrencyIsoCode = 'USD',Apttus_Config2__EndDate__c=system.today()+20,Apttus_Config2__PriceListItemId__c = pliSO.id);
        Apttus_Config2__LineItem__c lineItem8=new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c=prodConfig.id , Apttus_Config2__ProductId__c=prod2.id,Apttus_Config2__LineType__c ='Product/Service',APTS_SSD_ship_to__c=accountSSD.id,Apttus_Config2__LineStatus__c = 'Cancelled',Apttus_Config2__ChargeType__c = 'Subscription Fee',Apttus_Config2__ItemSequence__c = 1,Apttus_Config2__LineNumber__c = 1,Apttus_Config2__ListPrice__c = 100,Apttus_Config2__NetAdjustmentPercent__c = -50,Apttus_Config2__NetPrice__c = 50,Apttus_Config2__NetUnitPrice__c = 50,Apttus_Config2__AdjustedPrice__c = 50,Apttus_Config2__AdjustmentAmount__c = 50,Apttus_Config2__AdjustmentType__c = '% Discount',Apttus_Config2__AddedBy__c = 'User',CurrencyIsoCode = 'USD',Apttus_Config2__EndDate__c=system.today()+20,Apttus_Config2__PriceListItemId__c = pliSO.id);
       
        List<Apttus_Config2__LineItem__c> lineItemsList=new List<Apttus_Config2__LineItem__c>{lineItem1,lineItem2,lineItem3,lineItem4,lineItem6,lineItem7,lineItem8};      
        insert lineItemsList; 
        
        
        Test.startTest();
         Apttus_Config2.CallbackTester.testValidationCallback
                                              ( cartID
                                              , lineItemsList
                                              , null
                                              , new APTS_Validation_Callback ());   
        Test.stopTest(); 
   }
@isTest static void validateUpgradeDowngradeErrorTestMethod3(){
       
       Apttus_Config2__PriceList__c priceList = APTS_TestDataFactory.createPriceList('Thomson Reuters Master - US Legal');
       insert priceList;
       
        insertStaticValues();
        WebServiceSettings__c oWebServiceSettings = new WebServiceSettings__c();
        oWebServiceSettings.Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable'; 
        oWebServiceSettings.Name = 'PaymentCreditIncrease'; 
        oWebServiceSettings.Timeout__c = 120; 
        oWebServiceSettings.Endpoint__c = 'https://dev.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease'; 
        oWebServiceSettings.Active__c = true;
        
        WebServiceSettings__c oWebServiceSettings1 = new WebServiceSettings__c();
        oWebServiceSettings1.Service_Unavailable_Message__c = 'Auto Payment Service is Currently unavailable'; 
        oWebServiceSettings1.Name = 'Payment AutoCharge'; 
        oWebServiceSettings1.Timeout__c = 6000; 
        oWebServiceSettings1.Endpoint__c = 'https://stg.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentAutoCharge'; 
        oWebServiceSettings1.Active__c = true;
        List<WebServiceSettings__c> webServiceList=new List<WebServiceSettings__c>{oWebServiceSettings,oWebServiceSettings1};
        insert webServiceList;

        Account a = APTS_TestDataFactory.createAccount('Test Account');
        insert a;
        
        
        List<RecordtypeIds__c> recordlist=new List<RecordtypeIds__c>();
        RecordtypeIds__c recordtype=new RecordtypeIds__c();
        recordtype.Name='Pre-Pipeline Opportunities';
        recordtype.recTypeId__c='01230000001MA4c';
        recordlist.add(recordtype);
        
        RecordtypeIds__c recordtype1=new RecordtypeIds__c();
        recordtype1.Name='Pipeline Opportunities';
        recordtype1.recTypeId__c='01230000001MA4c';
        recordlist.add(recordtype1);
        insert recordlist;
        
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get(label.SourcesystemdetailUSLRecordtype).getRecordTypeId();
        Source_System_Detail__c accountSSD= APTS_TestDataFactory.createSourceSystem(a);
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
        proposal.APTS_Proposal_Business_Unit__c  ='FindLaw';
        proposal.APTS_Approval_Segment__c  ='FindLaw';
        insert proposal;

        Apttus_Config2__ProductConfiguration__c prodConfig = APTS_TestDataFactory.createProductConfiguration(proposal.Id);
        insert prodConfig;
        ID cartID = prodConfig.Id;
        
        Product2 prod1 = new Product2(name='prod1', Media_High_Level__c='Online', CurrencyIsoCode = 'USD',ProductCode = '404836',APTS_Upgrade_Downgrade_Eligible__c=true);
        Product2 prod2 = new Product2(name='prod2', Media_High_Level__c='Online', CurrencyIsoCode = 'USD',ProductCode='404855');
        Product2 prod3 = new Product2(name='prod3', Media_High_Level__c='Online', CurrencyIsoCode = 'USD',ProductCode='404836');
        Product2 prod4 = new Product2(name='prod4', Media_High_Level__c='Online', CurrencyIsoCode = 'USD',ProductCode='404836');
        Product2 prod5 = new Product2(name='prod5', Media_High_Level__c='Online', CurrencyIsoCode = 'USD',ProductCode='419156',APTS_Upgrade_Downgrade_Eligible__c=true);
        Product2 prod6 = new Product2(name='prod6', Media_High_Level__c='Online', CurrencyIsoCode = 'USD',ProductCode='418928');
        Product2 prod7 = new Product2(name='prod7', Media_High_Level__c='Online', CurrencyIsoCode = 'USD',ProductCode='417671');
        Product2 prod8 = new Product2(name='prod8', Media_High_Level__c='Online', CurrencyIsoCode = 'USD',ProductCode='421240',APTS_Upgrade_Downgrade_Eligible__c=true);
        Product2 prod9 = new Product2(name='prod9', Media_High_Level__c='Online', CurrencyIsoCode = 'USD',ProductCode='418227');
        Product2 prod10 = new Product2(name='prod10', Media_High_Level__c='Online', CurrencyIsoCode = 'USD',ProductCode='417777');
     
        List<Product2> productList=new List<Product2>{prod1,prod2,prod3,prod4,prod5,prod6,prod7,prod8,prod9,prod10};
        insert productList;
        
        Apttus_Config2__PriceListItem__c pliSO = new Apttus_Config2__PriceListItem__c();
          pliSO.Apttus_Config2__Active__c = true;
          pliSO.Apttus_Config2__PriceListId__c = priceList.Id;
          pliSO.APTS_Max_Fill_Up_Price__c = 5;
        insert pliSO;
        
        APTS_Mutually_Exclusive_Rule__c rule1=new APTS_Mutually_Exclusive_Rule__c(name='Rule1',APTS_Product__c=prod1.id,APTS_Mutually_Exclusive_Product__c=prod2.id,APTS_Active__c=true);
        APTS_Mutually_Exclusive_Rule__c rule2=new APTS_Mutually_Exclusive_Rule__c(name='Rule2',APTS_Product__c=prod1.id,APTS_Mutually_Exclusive_Product__c=prod3.id,APTS_Active__c=true);
        APTS_Mutually_Exclusive_Rule__c rule3=new APTS_Mutually_Exclusive_Rule__c(name='Rule3',APTS_Product__c=prod1.id,APTS_Mutually_Exclusive_Product__c=prod4.id);
        APTS_Mutually_Exclusive_Rule__c rule4=new APTS_Mutually_Exclusive_Rule__c(name='Rule4',APTS_Product__c=prod5.id,APTS_Mutually_Exclusive_Product__c=prod6.id);
        APTS_Mutually_Exclusive_Rule__c rule5=new APTS_Mutually_Exclusive_Rule__c(name='Rule5',APTS_Product__c=prod5.id,APTS_Mutually_Exclusive_Product__c=prod7.id);
        APTS_Mutually_Exclusive_Rule__c rule6=new APTS_Mutually_Exclusive_Rule__c(name='Rule6',APTS_Product__c=prod8.id,APTS_Mutually_Exclusive_Product__c=prod9.id);
        APTS_Mutually_Exclusive_Rule__c rule7=new APTS_Mutually_Exclusive_Rule__c(name='Rule7',APTS_Product__c=prod8.id,APTS_Mutually_Exclusive_Product__c=prod10.id);
        
        List<APTS_Mutually_Exclusive_Rule__c> exclusionRulesList=new List<APTS_Mutually_Exclusive_Rule__c>{rule1,rule2,rule3,rule4,rule5,rule6,rule7};      
        insert exclusionRulesList;
        
        
        Apttus_Config2__AssetLineItem__c asset1=new Apttus_Config2__AssetLineItem__c(Apttus_Config2__ProductId__c=prod2.id,Apttus_Config2__Quantity__c=5,Apttus_Config2__AssetStatus__c ='Activated',Apttus_Config2__LineType__c  ='Product/Service',APTS_SSD_Sold_To__c = accountSSD.Id,Apttus_QPConfig__ProposalId__c =proposal.id,Apttus_Config2__EndDate__c=system.today()+20,Apttus_Config2__NetPrice__c=10.0);
        Apttus_Config2__AssetLineItem__c asset2=new Apttus_Config2__AssetLineItem__c(Apttus_Config2__ProductId__c=prod2.id,Apttus_Config2__Quantity__c=5,Apttus_Config2__AssetStatus__c ='Activated',Apttus_Config2__LineType__c  ='Product/Service',APTS_SSD_Sold_To__c = accountSSD.Id,Apttus_QPConfig__ProposalId__c =proposal.id,Apttus_Config2__EndDate__c=system.today()+20,Apttus_Config2__NetPrice__c=10.0);
        Apttus_Config2__AssetLineItem__c asset3=new Apttus_Config2__AssetLineItem__c(Apttus_Config2__ProductId__c=prod3.id,Apttus_Config2__Quantity__c=5,Apttus_Config2__AssetStatus__c ='Activated',Apttus_Config2__LineType__c  ='Product/Service',APTS_SSD_Sold_To__c = accountSSD.Id,Apttus_QPConfig__ProposalId__c =proposal.id,Apttus_Config2__EndDate__c=system.today()+20,Apttus_Config2__NetPrice__c=10.0);
        Apttus_Config2__AssetLineItem__c asset4=new Apttus_Config2__AssetLineItem__c(Apttus_Config2__ProductId__c=prod4.id,Apttus_Config2__Quantity__c=5,Apttus_Config2__AssetStatus__c ='Activated',Apttus_Config2__LineType__c  ='Product/Service',APTS_SSD_Sold_To__c = accountSSD.Id,Apttus_QPConfig__ProposalId__c =proposal.id,Apttus_Config2__EndDate__c=system.today()+20,Apttus_Config2__NetPrice__c=10.0);
        Apttus_Config2__AssetLineItem__c asset5=new Apttus_Config2__AssetLineItem__c(Apttus_Config2__ProductId__c=prod4.id,Apttus_Config2__Quantity__c=5,Apttus_Config2__AssetStatus__c ='Pending Cancellation',Apttus_Config2__LineType__c  ='Product/Service',APTS_SSD_Sold_To__c = accountSSD.Id,Apttus_QPConfig__ProposalId__c =proposal.id,Apttus_Config2__EndDate__c=system.today()+20,Apttus_Config2__NetPrice__c=10.0);
        
        List<Apttus_Config2__AssetLineItem__c> assetLinesList = New List<Apttus_Config2__AssetLineItem__c>{asset1,asset2,asset3,asset4,asset5};
        insert assetLinesList;
        
        Apttus_Config2__LineItem__c lineItem1=new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c=prodConfig.id , Apttus_Config2__ProductId__c=prod1.id,Apttus_Config2__LineType__c ='Product/Service',APTS_SSD_ship_to__c=accountSSD.id,Apttus_Config2__LineStatus__c = 'New',Apttus_Config2__ChargeType__c = 'Subscription Fee',Apttus_Config2__ItemSequence__c = 1,Apttus_Config2__LineNumber__c = 1,Apttus_Config2__ListPrice__c = 100,Apttus_Config2__NetAdjustmentPercent__c = -50,Apttus_Config2__NetPrice__c = 50,Apttus_Config2__NetUnitPrice__c = 50,Apttus_Config2__AdjustedPrice__c = 50,Apttus_Config2__AdjustmentAmount__c = 50,Apttus_Config2__AdjustmentType__c = '% Discount',Apttus_Config2__AddedBy__c = 'User',CurrencyIsoCode = 'USD',Apttus_Config2__EndDate__c=system.today()+20,Apttus_Config2__PriceListItemId__c = pliSO.id);     
        Apttus_Config2__LineItem__c lineItem2=new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c=prodConfig.id , Apttus_Config2__ProductId__c=prod5.id,Apttus_Config2__LineType__c ='Product/Service',APTS_SSD_ship_to__c=accountSSD.id,Apttus_Config2__LineStatus__c = 'New',Apttus_Config2__ChargeType__c = 'Subscription Fee',Apttus_Config2__ItemSequence__c = 1,Apttus_Config2__LineNumber__c = 1,Apttus_Config2__ListPrice__c = 100,Apttus_Config2__NetAdjustmentPercent__c = -50,Apttus_Config2__NetPrice__c = 50,Apttus_Config2__NetUnitPrice__c = 50,Apttus_Config2__AdjustedPrice__c = 50,Apttus_Config2__AdjustmentAmount__c = 50,Apttus_Config2__AdjustmentType__c = '% Discount',Apttus_Config2__AddedBy__c = 'User',CurrencyIsoCode = 'USD',Apttus_Config2__EndDate__c=system.today()+20,Apttus_Config2__PriceListItemId__c = pliSO.id);
        Apttus_Config2__LineItem__c lineItem3=new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c=prodConfig.id , Apttus_Config2__ProductId__c=prod6.id,Apttus_Config2__LineType__c ='Product/Service',APTS_SSD_ship_to__c=accountSSD.id,Apttus_Config2__LineStatus__c = 'New',Apttus_Config2__ChargeType__c = 'Subscription Fee',Apttus_Config2__ItemSequence__c = 1,Apttus_Config2__LineNumber__c = 1,Apttus_Config2__ListPrice__c = 100,Apttus_Config2__NetAdjustmentPercent__c = -50,Apttus_Config2__NetPrice__c = 50,Apttus_Config2__NetUnitPrice__c = 50,Apttus_Config2__AdjustedPrice__c = 50,Apttus_Config2__AdjustmentAmount__c = 50,Apttus_Config2__AdjustmentType__c = '% Discount',Apttus_Config2__AddedBy__c = 'User',CurrencyIsoCode = 'USD',Apttus_Config2__EndDate__c=system.today()+20,Apttus_Config2__PriceListItemId__c = pliSO.id);
        Apttus_Config2__LineItem__c lineItem4=new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c=prodConfig.id , Apttus_Config2__ProductId__c=prod7.id,Apttus_Config2__LineType__c ='Product/Service',APTS_SSD_ship_to__c=accountSSD.id,Apttus_Config2__LineStatus__c = 'New',Apttus_Config2__ChargeType__c = 'Subscription Fee',Apttus_Config2__ItemSequence__c = 1,Apttus_Config2__LineNumber__c = 1,Apttus_Config2__ListPrice__c = 100,Apttus_Config2__NetAdjustmentPercent__c = -50,Apttus_Config2__NetPrice__c = 50,Apttus_Config2__NetUnitPrice__c = 50,Apttus_Config2__AdjustedPrice__c = 50,Apttus_Config2__AdjustmentAmount__c = 50,Apttus_Config2__AdjustmentType__c = '% Discount',Apttus_Config2__AddedBy__c = 'User',CurrencyIsoCode = 'USD',Apttus_Config2__EndDate__c=system.today()+20,Apttus_Config2__PriceListItemId__c = pliSO.id);
        Apttus_Config2__LineItem__c lineItem5=new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c=prodConfig.id , Apttus_Config2__ProductId__c=prod8.id,Apttus_Config2__LineType__c ='Product/Service',APTS_SSD_ship_to__c=accountSSD.id,Apttus_Config2__LineStatus__c = 'New',Apttus_Config2__ChargeType__c = 'Subscription Fee',Apttus_Config2__ItemSequence__c = 1,Apttus_Config2__LineNumber__c = 1,Apttus_Config2__ListPrice__c = 100,Apttus_Config2__NetAdjustmentPercent__c = -50,Apttus_Config2__NetPrice__c = 50,Apttus_Config2__NetUnitPrice__c = 50,Apttus_Config2__AdjustedPrice__c = 50,Apttus_Config2__AdjustmentAmount__c = 50,Apttus_Config2__AdjustmentType__c = '% Discount',Apttus_Config2__AddedBy__c = 'User',CurrencyIsoCode = 'USD',Apttus_Config2__EndDate__c=system.today()+20,Apttus_Config2__PriceListItemId__c = pliSO.id);
        Apttus_Config2__LineItem__c lineItem6=new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c=prodConfig.id , Apttus_Config2__ProductId__c=prod1.id,Apttus_Config2__LineType__c ='Product/Service',APTS_SSD_ship_to__c=accountSSD.id,Apttus_Config2__LineStatus__c = 'New',Apttus_Config2__ChargeType__c = 'Subscription Fee',Apttus_Config2__ItemSequence__c = 1,Apttus_Config2__LineNumber__c = 1,Apttus_Config2__ListPrice__c = 100,Apttus_Config2__NetAdjustmentPercent__c = -50,Apttus_Config2__NetPrice__c = 50,Apttus_Config2__NetUnitPrice__c = 50,Apttus_Config2__AdjustedPrice__c = 50,Apttus_Config2__AdjustmentAmount__c = 50,Apttus_Config2__AdjustmentType__c = '% Discount',Apttus_Config2__AddedBy__c = 'User',CurrencyIsoCode = 'USD',Apttus_Config2__EndDate__c=system.today()+20,Apttus_Config2__PriceListItemId__c = pliSO.id);
     
        List<Apttus_Config2__LineItem__c> lineItemsList=new List<Apttus_Config2__LineItem__c>{lineItem1,lineItem2,lineItem3,lineItem4,lineItem6};      
        insert lineItemsList; 
        
        
        Test.startTest();
         Apttus_Config2.CallbackTester.testValidationCallback
                                              ( cartID
                                              , lineItemsList
                                              , null
                                              , new APTS_Validation_Callback ());   
        Test.stopTest(); 
   }
@isTest static void validateUpgradeDowngradeErrorTestMethod4(){
       
       Apttus_Config2__PriceList__c priceList = APTS_TestDataFactory.createPriceList('Thomson Reuters Master - US Legal');
       insert priceList;
        insertStaticValues();
        WebServiceSettings__c oWebServiceSettings = new WebServiceSettings__c();
        oWebServiceSettings.Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable'; 
        oWebServiceSettings.Name = 'PaymentCreditIncrease'; 
        oWebServiceSettings.Timeout__c = 120; 
        oWebServiceSettings.Endpoint__c = 'https://dev.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease'; 
        oWebServiceSettings.Active__c = true;
        
        WebServiceSettings__c oWebServiceSettings1 = new WebServiceSettings__c();
        oWebServiceSettings1.Service_Unavailable_Message__c = 'Auto Payment Service is Currently unavailable'; 
        oWebServiceSettings1.Name = 'Payment AutoCharge'; 
        oWebServiceSettings1.Timeout__c = 6000; 
        oWebServiceSettings1.Endpoint__c = 'https://stg.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentAutoCharge'; 
        oWebServiceSettings1.Active__c = true;
        List<WebServiceSettings__c> webServiceList=new List<WebServiceSettings__c>{oWebServiceSettings,oWebServiceSettings1};
        insert webServiceList;

        Account a = APTS_TestDataFactory.createAccount('Test Account');
        insert a;
        
        
        List<RecordtypeIds__c> recordlist=new List<RecordtypeIds__c>();
        RecordtypeIds__c recordtype=new RecordtypeIds__c();
        recordtype.Name='Pre-Pipeline Opportunities';
        recordtype.recTypeId__c='01230000001MA4c';
        recordlist.add(recordtype);
        
        RecordtypeIds__c recordtype1=new RecordtypeIds__c();
        recordtype1.Name='Pipeline Opportunities';
        recordtype1.recTypeId__c='01230000001MA4c';
        recordlist.add(recordtype1);
        insert recordlist;
        
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get(label.SourcesystemdetailUSLRecordtype).getRecordTypeId();
        Source_System_Detail__c accountSSD= APTS_TestDataFactory.createSourceSystem(a);
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
        proposal.APTS_Proposal_Business_Unit__c  ='FindLaw';
        proposal.APTS_Approval_Segment__c  ='FindLaw';
        insert proposal;

        Apttus_Config2__ProductConfiguration__c prodConfig = APTS_TestDataFactory.createProductConfiguration(proposal.Id);
        insert prodConfig;
        ID cartID = prodConfig.Id;
        
        Product2 prod1 = new Product2(name='prod1', Media_High_Level__c='Online', CurrencyIsoCode = 'USD',ProductCode = '404836',APTS_Upgrade_Downgrade_Eligible__c=true);
        Product2 prod2 = new Product2(name='prod2', Media_High_Level__c='Online', CurrencyIsoCode = 'USD',ProductCode='404855');
        Product2 prod3 = new Product2(name='prod3', Media_High_Level__c='Online', CurrencyIsoCode = 'USD',ProductCode='404836');
        Product2 prod4 = new Product2(name='prod4', Media_High_Level__c='Online', CurrencyIsoCode = 'USD',ProductCode='404836');
        Product2 prod5 = new Product2(name='prod5', Media_High_Level__c='Online', CurrencyIsoCode = 'USD',ProductCode='419156',APTS_Upgrade_Downgrade_Eligible__c=true);
        Product2 prod6 = new Product2(name='prod6', Media_High_Level__c='Online', CurrencyIsoCode = 'USD',ProductCode='418928');
        Product2 prod7 = new Product2(name='prod7', Media_High_Level__c='Online', CurrencyIsoCode = 'USD',ProductCode='417671');
        Product2 prod8 = new Product2(name='prod8', Media_High_Level__c='Online', CurrencyIsoCode = 'USD',ProductCode='421240',APTS_Upgrade_Downgrade_Eligible__c=true);
        Product2 prod9 = new Product2(name='prod9', Media_High_Level__c='Online', CurrencyIsoCode = 'USD',ProductCode='418227');
        Product2 prod10 = new Product2(name='prod10', Media_High_Level__c='Online', CurrencyIsoCode = 'USD',ProductCode='417777');
     
        List<Product2> productList=new List<Product2>{prod1,prod2,prod3,prod4,prod5,prod6,prod7,prod8,prod9,prod10};
        insert productList;
        
        Apttus_Config2__PriceListItem__c pliSO = new Apttus_Config2__PriceListItem__c();
          pliSO.Apttus_Config2__Active__c = true;
          pliSO.Apttus_Config2__PriceListId__c = priceList.Id;
          pliSO.APTS_Max_Fill_Up_Price__c = 5;
        insert pliSO;
        
        APTS_Mutually_Exclusive_Rule__c rule1=new APTS_Mutually_Exclusive_Rule__c(name='Rule1',APTS_Product__c=prod1.id,APTS_Mutually_Exclusive_Product__c=prod2.id,APTS_Active__c=true);
        APTS_Mutually_Exclusive_Rule__c rule2=new APTS_Mutually_Exclusive_Rule__c(name='Rule2',APTS_Product__c=prod1.id,APTS_Mutually_Exclusive_Product__c=prod3.id,APTS_Active__c=true);
        APTS_Mutually_Exclusive_Rule__c rule3=new APTS_Mutually_Exclusive_Rule__c(name='Rule3',APTS_Product__c=prod1.id,APTS_Mutually_Exclusive_Product__c=prod4.id);
        APTS_Mutually_Exclusive_Rule__c rule4=new APTS_Mutually_Exclusive_Rule__c(name='Rule4',APTS_Product__c=prod5.id,APTS_Mutually_Exclusive_Product__c=prod6.id);
        APTS_Mutually_Exclusive_Rule__c rule5=new APTS_Mutually_Exclusive_Rule__c(name='Rule5',APTS_Product__c=prod5.id,APTS_Mutually_Exclusive_Product__c=prod7.id);
        APTS_Mutually_Exclusive_Rule__c rule6=new APTS_Mutually_Exclusive_Rule__c(name='Rule6',APTS_Product__c=prod8.id,APTS_Mutually_Exclusive_Product__c=prod9.id);
        APTS_Mutually_Exclusive_Rule__c rule7=new APTS_Mutually_Exclusive_Rule__c(name='Rule7',APTS_Product__c=prod8.id,APTS_Mutually_Exclusive_Product__c=prod10.id);
        
        List<APTS_Mutually_Exclusive_Rule__c> exclusionRulesList=new List<APTS_Mutually_Exclusive_Rule__c>{rule1,rule2,rule3,rule4,rule5,rule6,rule7};      
        insert exclusionRulesList;
        
        
        Apttus_Config2__AssetLineItem__c asset1=new Apttus_Config2__AssetLineItem__c(Apttus_Config2__ProductId__c=prod2.id,Apttus_Config2__Quantity__c=5,Apttus_Config2__AssetStatus__c ='Activated',Apttus_Config2__LineType__c  ='Product/Service',APTS_SSD_Sold_To__c = accountSSD.Id,Apttus_QPConfig__ProposalId__c =proposal.id,Apttus_Config2__EndDate__c=system.today()+20,Apttus_Config2__NetPrice__c=10.0);
        Apttus_Config2__AssetLineItem__c asset2=new Apttus_Config2__AssetLineItem__c(Apttus_Config2__ProductId__c=prod2.id,Apttus_Config2__Quantity__c=5,Apttus_Config2__AssetStatus__c ='Activated',Apttus_Config2__LineType__c  ='Product/Service',APTS_SSD_Sold_To__c = accountSSD.Id,Apttus_QPConfig__ProposalId__c =proposal.id,Apttus_Config2__EndDate__c=system.today()+20,Apttus_Config2__NetPrice__c=10.0);
        Apttus_Config2__AssetLineItem__c asset3=new Apttus_Config2__AssetLineItem__c(Apttus_Config2__ProductId__c=prod3.id,Apttus_Config2__Quantity__c=5,Apttus_Config2__AssetStatus__c ='Activated',Apttus_Config2__LineType__c  ='Product/Service',APTS_SSD_Sold_To__c = accountSSD.Id,Apttus_QPConfig__ProposalId__c =proposal.id,Apttus_Config2__EndDate__c=system.today()+20,Apttus_Config2__NetPrice__c=10.0);
        Apttus_Config2__AssetLineItem__c asset4=new Apttus_Config2__AssetLineItem__c(Apttus_Config2__ProductId__c=prod4.id,Apttus_Config2__Quantity__c=5,Apttus_Config2__AssetStatus__c ='Activated',Apttus_Config2__LineType__c  ='Product/Service',APTS_SSD_Sold_To__c = accountSSD.Id,Apttus_QPConfig__ProposalId__c =proposal.id,Apttus_Config2__EndDate__c=system.today()+20,Apttus_Config2__NetPrice__c=10.0);
        Apttus_Config2__AssetLineItem__c asset5=new Apttus_Config2__AssetLineItem__c(Apttus_Config2__ProductId__c=prod4.id,Apttus_Config2__Quantity__c=5,Apttus_Config2__AssetStatus__c ='Pending Cancellation',Apttus_Config2__LineType__c  ='Product/Service',APTS_SSD_Sold_To__c = accountSSD.Id,Apttus_QPConfig__ProposalId__c =proposal.id,Apttus_Config2__EndDate__c=system.today()+20,Apttus_Config2__NetPrice__c=10.0);
        
        List<Apttus_Config2__AssetLineItem__c> assetLinesList = New List<Apttus_Config2__AssetLineItem__c>{asset1,asset2,asset3,asset4,asset5};
        insert assetLinesList;
        
        Apttus_Config2__LineItem__c lineItem1=new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c=prodConfig.id , Apttus_Config2__ProductId__c=prod1.id,Apttus_Config2__LineType__c ='Product/Service',APTS_SSD_ship_to__c=accountSSD.id,Apttus_Config2__LineStatus__c = 'New',Apttus_Config2__ChargeType__c = 'Subscription Fee',Apttus_Config2__ItemSequence__c = 1,Apttus_Config2__LineNumber__c = 1,Apttus_Config2__ListPrice__c = 100,Apttus_Config2__NetAdjustmentPercent__c = -50,Apttus_Config2__NetPrice__c = 50,Apttus_Config2__NetUnitPrice__c = 50,Apttus_Config2__AdjustedPrice__c = 50,Apttus_Config2__AdjustmentAmount__c = 50,Apttus_Config2__AdjustmentType__c = '% Discount',Apttus_Config2__AddedBy__c = 'User',CurrencyIsoCode = 'USD',Apttus_Config2__EndDate__c=system.today()+20,Apttus_Config2__PriceListItemId__c = pliSO.id);     
        Apttus_Config2__LineItem__c lineItem2=new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c=prodConfig.id , Apttus_Config2__ProductId__c=prod5.id,Apttus_Config2__LineType__c ='Product/Service',APTS_SSD_ship_to__c=accountSSD.id,Apttus_Config2__LineStatus__c = 'New',Apttus_Config2__ChargeType__c = 'Subscription Fee',Apttus_Config2__ItemSequence__c = 1,Apttus_Config2__LineNumber__c = 1,Apttus_Config2__ListPrice__c = 100,Apttus_Config2__NetAdjustmentPercent__c = -50,Apttus_Config2__NetPrice__c = 50,Apttus_Config2__NetUnitPrice__c = 50,Apttus_Config2__AdjustedPrice__c = 50,Apttus_Config2__AdjustmentAmount__c = 50,Apttus_Config2__AdjustmentType__c = '% Discount',Apttus_Config2__AddedBy__c = 'User',CurrencyIsoCode = 'USD',Apttus_Config2__EndDate__c=system.today()+20,Apttus_Config2__PriceListItemId__c = pliSO.id);
        Apttus_Config2__LineItem__c lineItem3=new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c=prodConfig.id , Apttus_Config2__ProductId__c=prod6.id,Apttus_Config2__LineType__c ='Product/Service',APTS_SSD_ship_to__c=accountSSD.id,Apttus_Config2__LineStatus__c = 'New',Apttus_Config2__ChargeType__c = 'Subscription Fee',Apttus_Config2__ItemSequence__c = 1,Apttus_Config2__LineNumber__c = 1,Apttus_Config2__ListPrice__c = 100,Apttus_Config2__NetAdjustmentPercent__c = -50,Apttus_Config2__NetPrice__c = 50,Apttus_Config2__NetUnitPrice__c = 50,Apttus_Config2__AdjustedPrice__c = 50,Apttus_Config2__AdjustmentAmount__c = 50,Apttus_Config2__AdjustmentType__c = '% Discount',Apttus_Config2__AddedBy__c = 'User',CurrencyIsoCode = 'USD',Apttus_Config2__EndDate__c=system.today()+20,Apttus_Config2__PriceListItemId__c = pliSO.id);
        Apttus_Config2__LineItem__c lineItem4=new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c=prodConfig.id , Apttus_Config2__ProductId__c=prod7.id,Apttus_Config2__LineType__c ='Product/Service',APTS_SSD_ship_to__c=accountSSD.id,Apttus_Config2__LineStatus__c = 'New',Apttus_Config2__ChargeType__c = 'Subscription Fee',Apttus_Config2__ItemSequence__c = 1,Apttus_Config2__LineNumber__c = 1,Apttus_Config2__ListPrice__c = 100,Apttus_Config2__NetAdjustmentPercent__c = -50,Apttus_Config2__NetPrice__c = 50,Apttus_Config2__NetUnitPrice__c = 50,Apttus_Config2__AdjustedPrice__c = 50,Apttus_Config2__AdjustmentAmount__c = 50,Apttus_Config2__AdjustmentType__c = '% Discount',Apttus_Config2__AddedBy__c = 'User',CurrencyIsoCode = 'USD',Apttus_Config2__EndDate__c=system.today()+20,Apttus_Config2__PriceListItemId__c = pliSO.id);
        Apttus_Config2__LineItem__c lineItem5=new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c=prodConfig.id , Apttus_Config2__ProductId__c=prod8.id,Apttus_Config2__LineType__c ='Product/Service',APTS_SSD_ship_to__c=accountSSD.id,Apttus_Config2__LineStatus__c = 'New',Apttus_Config2__ChargeType__c = 'Subscription Fee',Apttus_Config2__ItemSequence__c = 1,Apttus_Config2__LineNumber__c = 1,Apttus_Config2__ListPrice__c = 100,Apttus_Config2__NetAdjustmentPercent__c = -50,Apttus_Config2__NetPrice__c = 50,Apttus_Config2__NetUnitPrice__c = 50,Apttus_Config2__AdjustedPrice__c = 50,Apttus_Config2__AdjustmentAmount__c = 50,Apttus_Config2__AdjustmentType__c = '% Discount',Apttus_Config2__AddedBy__c = 'User',CurrencyIsoCode = 'USD',Apttus_Config2__EndDate__c=system.today()+20,Apttus_Config2__PriceListItemId__c = pliSO.id);
        Apttus_Config2__LineItem__c lineItem6=new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c=prodConfig.id , Apttus_Config2__ProductId__c=prod1.id,Apttus_Config2__LineType__c ='Product/Service',APTS_SSD_ship_to__c=accountSSD.id,Apttus_Config2__LineStatus__c = 'New',Apttus_Config2__ChargeType__c = 'Subscription Fee',Apttus_Config2__ItemSequence__c = 1,Apttus_Config2__LineNumber__c = 1,Apttus_Config2__ListPrice__c = 100,Apttus_Config2__NetAdjustmentPercent__c = -50,Apttus_Config2__NetPrice__c = 50,Apttus_Config2__NetUnitPrice__c = 50,Apttus_Config2__AdjustedPrice__c = 50,Apttus_Config2__AdjustmentAmount__c = 50,Apttus_Config2__AdjustmentType__c = '% Discount',Apttus_Config2__AddedBy__c = 'User',CurrencyIsoCode = 'USD',Apttus_Config2__EndDate__c=system.today()+20,Apttus_Config2__PriceListItemId__c = pliSO.id);
        Apttus_Config2__LineItem__c lineItem7=new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c=prodConfig.id , Apttus_Config2__ProductId__c=prod2.id,Apttus_Config2__LineType__c ='Product/Service',APTS_SSD_ship_to__c=accountSSD.id,Apttus_Config2__LineStatus__c = 'Cancelled',Apttus_Config2__ChargeType__c = 'Subscription Fee',Apttus_Config2__ItemSequence__c = 1,Apttus_Config2__LineNumber__c = 1,Apttus_Config2__ListPrice__c = 100,Apttus_Config2__NetAdjustmentPercent__c = -50,Apttus_Config2__NetPrice__c = 50,Apttus_Config2__NetUnitPrice__c = 50,Apttus_Config2__AdjustedPrice__c = 50,Apttus_Config2__AdjustmentAmount__c = 50,Apttus_Config2__AdjustmentType__c = '% Discount',Apttus_Config2__AddedBy__c = 'User',CurrencyIsoCode = 'USD',Apttus_Config2__EndDate__c=system.today()+20,Apttus_Config2__PriceListItemId__c = pliSO.id);
        Apttus_Config2__LineItem__c lineItem8=new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c=prodConfig.id , Apttus_Config2__ProductId__c=prod2.id,Apttus_Config2__LineType__c ='Product/Service',APTS_SSD_ship_to__c=accountSSD.id,Apttus_Config2__LineStatus__c = 'Cancelled',Apttus_Config2__ChargeType__c = 'Subscription Fee',Apttus_Config2__ItemSequence__c = 1,Apttus_Config2__LineNumber__c = 1,Apttus_Config2__ListPrice__c = 100,Apttus_Config2__NetAdjustmentPercent__c = -50,Apttus_Config2__NetPrice__c = 50,Apttus_Config2__NetUnitPrice__c = 50,Apttus_Config2__AdjustedPrice__c = 50,Apttus_Config2__AdjustmentAmount__c = 50,Apttus_Config2__AdjustmentType__c = '% Discount',Apttus_Config2__AddedBy__c = 'User',CurrencyIsoCode = 'USD',Apttus_Config2__EndDate__c=system.today()+20,Apttus_Config2__PriceListItemId__c = pliSO.id);
       
        List<Apttus_Config2__LineItem__c> lineItemsList=new List<Apttus_Config2__LineItem__c>{lineItem1,lineItem2,lineItem3,lineItem4,lineItem6,lineItem7,lineItem8};      
        insert lineItemsList; 
        
        
        Test.startTest();
         Apttus_Config2.CallbackTester.testValidationCallback
                                              ( cartID
                                              , lineItemsList
                                              , null
                                              , new APTS_Validation_Callback ());   
        Test.stopTest(); 
   }
   @isTest static void validateUpgradeDowngradeErrorTestMethod5(){
       
       Apttus_Config2__PriceList__c priceList = APTS_TestDataFactory.createPriceList('Thomson Reuters Master - US Legal');
       insert priceList;
      insertStaticValues();
        WebServiceSettings__c oWebServiceSettings = new WebServiceSettings__c();
        oWebServiceSettings.Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable'; 
        oWebServiceSettings.Name = 'PaymentCreditIncrease'; 
        oWebServiceSettings.Timeout__c = 120; 
        oWebServiceSettings.Endpoint__c = 'https://dev.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease'; 
        oWebServiceSettings.Active__c = true;
        
        WebServiceSettings__c oWebServiceSettings1 = new WebServiceSettings__c();
        oWebServiceSettings1.Service_Unavailable_Message__c = 'Auto Payment Service is Currently unavailable'; 
        oWebServiceSettings1.Name = 'Payment AutoCharge'; 
        oWebServiceSettings1.Timeout__c = 6000; 
        oWebServiceSettings1.Endpoint__c = 'https://stg.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentAutoCharge'; 
        oWebServiceSettings1.Active__c = true;
        List<WebServiceSettings__c> webServiceList=new List<WebServiceSettings__c>{oWebServiceSettings,oWebServiceSettings1};
        insert webServiceList;

        Account a = APTS_TestDataFactory.createAccount('Test Account');
        insert a;
        
        
        
        List<RecordtypeIds__c> recordlist=new List<RecordtypeIds__c>();
        RecordtypeIds__c recordtype=new RecordtypeIds__c();
        recordtype.Name='Pre-Pipeline Opportunities';
        recordtype.recTypeId__c='01230000001MA4c';
        recordlist.add(recordtype);
        
        RecordtypeIds__c recordtype1=new RecordtypeIds__c();
        recordtype1.Name='Pipeline Opportunities';
        recordtype1.recTypeId__c='01230000001MA4c';
        recordlist.add(recordtype1);
        insert recordlist;
        
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get(label.SourcesystemdetailUSLRecordtype).getRecordTypeId();
        Source_System_Detail__c accountSSD= APTS_TestDataFactory.createSourceSystem(a);
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
        proposal.APTS_Proposal_Business_Unit__c  ='FindLaw';
        proposal.APTS_Approval_Segment__c  ='FindLaw';
        insert proposal;

        Apttus_Config2__ProductConfiguration__c prodConfig = APTS_TestDataFactory.createProductConfiguration(proposal.Id);
        insert prodConfig;
        ID cartID = prodConfig.Id;
        
        Product2 prod1 = new Product2(name='prod1', Media_High_Level__c='Online', CurrencyIsoCode = 'USD',ProductCode = '404836',APTS_Upgrade_Downgrade_Eligible__c=true);
        Product2 prod2 = new Product2(name='prod2', Media_High_Level__c='Online', CurrencyIsoCode = 'USD',ProductCode='404855');
        Product2 prod3 = new Product2(name='prod3', Media_High_Level__c='Online', CurrencyIsoCode = 'USD',ProductCode='404836');
        Product2 prod4 = new Product2(name='prod4', Media_High_Level__c='Online', CurrencyIsoCode = 'USD',ProductCode='404836');
        
        List<Product2> productList=new List<Product2>{prod1,prod2,prod3,prod4};
        insert productList;
        
        Apttus_Config2__PriceListItem__c pliSO = new Apttus_Config2__PriceListItem__c();
          pliSO.Apttus_Config2__Active__c = true;
          pliSO.Apttus_Config2__PriceListId__c = priceList.Id;
          pliSO.APTS_Max_Fill_Up_Price__c = 5;
        insert pliSO;
        
        APTS_Mutually_Exclusive_Rule__c rule1=new APTS_Mutually_Exclusive_Rule__c(name='Rule1',APTS_Product__c=prod1.id,APTS_Mutually_Exclusive_Product__c=prod2.id,APTS_Active__c=true);
        APTS_Mutually_Exclusive_Rule__c rule2=new APTS_Mutually_Exclusive_Rule__c(name='Rule2',APTS_Product__c=prod1.id,APTS_Mutually_Exclusive_Product__c=prod3.id,APTS_Active__c=true);
        APTS_Mutually_Exclusive_Rule__c rule3=new APTS_Mutually_Exclusive_Rule__c(name='Rule3',APTS_Product__c=prod1.id,APTS_Mutually_Exclusive_Product__c=prod4.id);
       
        List<APTS_Mutually_Exclusive_Rule__c> exclusionRulesList=new List<APTS_Mutually_Exclusive_Rule__c>{rule1,rule2,rule3};      
        insert exclusionRulesList;
        
        
        Apttus_Config2__LineItem__c lineItem1=new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c=prodConfig.id , Apttus_Config2__ProductId__c=prod1.id,Apttus_Config2__LineType__c ='Product/Service',APTS_SSD_ship_to__c=accountSSD.id,Apttus_Config2__LineStatus__c = 'New',Apttus_Config2__ChargeType__c = 'Subscription Fee',Apttus_Config2__ItemSequence__c = 1,Apttus_Config2__LineNumber__c = 1,Apttus_Config2__ListPrice__c = 100,Apttus_Config2__NetAdjustmentPercent__c = -50,Apttus_Config2__NetPrice__c = 50,Apttus_Config2__NetUnitPrice__c = 50,Apttus_Config2__AdjustedPrice__c = 50,Apttus_Config2__AdjustmentAmount__c = 50,Apttus_Config2__AdjustmentType__c = '% Discount',Apttus_Config2__AddedBy__c = 'User',CurrencyIsoCode = 'USD',Apttus_Config2__EndDate__c=system.today()+20,Apttus_Config2__PriceListItemId__c = pliSO.id);         
        List<Apttus_Config2__LineItem__c> lineItemsList=new List<Apttus_Config2__LineItem__c>{lineItem1};      
        insert lineItemsList; 
        
        
        Test.startTest();
         Apttus_Config2.CallbackTester.testValidationCallback
                                              ( cartID
                                              , lineItemsList
                                              , null
                                              , new APTS_Validation_Callback ());   
        Test.stopTest(); 
   }
    static void insertStaticValues(){
    
        LIST<Static_Values__c> staticCSList = new LIST<Static_Values__c>{  new Static_Values__c(name='skiptoNullifyCreditCardDetails', value__c='Guest')};
        insert staticCSList ;
        List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c='00e30000001ZUki'),
        new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other'),
        new KeyValueListStore__c(Name='LCRMDisableStrikeIronServices',TextValue__c='True')};
        insert keyvaluestore;
    }
}