@IsTest
public class APTS_AssetLineItemTriggerHandler_Test { 
    static testmethod void updateAutoNumber(){
        Test.startTest();
        /*
        Latam_AssetItemAutoNumber__c autoNumberObject = new Latam_AssetItemAutoNumber__c();
        autoNumberObject.Auto_Format__c ='-';
        autoNumberObject.Latam_Latest_Number__c=0;
        autoNumberObject.Starting_Number__c = 0;
        insert autoNumberObject;
        */
        Apttus_Config2__AssetLineItem__c oAssetLi = new Apttus_Config2__AssetLineItem__c(Apttus_Config2__EndDate__c =Date.Today());            
        insert oAssetLi;
        
        Test.stopTest();
    }
    
    static testmethod void updateRenewalQuoteCreatedFlag(){
            Test.startTest();
        /*
            Latam_AssetItemAutoNumber__c autoNumberObject = new Latam_AssetItemAutoNumber__c();
            autoNumberObject.Auto_Format__c ='-';
            autoNumberObject.Starting_Number__c = 0;
            insert autoNumberObject; 
        */
            Apttus_Config2__AssetLineItem__c oAssetLi = new Apttus_Config2__AssetLineItem__c(Apttus_Config2__EndDate__c =Date.Today());            
            insert oAssetLi;
            Apttus_Config2__AssetLineItem__c ali = new Apttus_Config2__AssetLineItem__c();
            ali.APTS_Proposal_Business_Unit__c = 'Tax Professional';
            ali.Apttus_Config2__Description__c = '';
            ali.Apttus_Config2__AssetStatus__c = 'Pending Renewal';
            ali.Apttus_Config2__EndDate__c = Date.Today();
            ali.Renewal_quote_created__c = true;
            insert ali;
            
            ali.Apttus_Config2__AssetStatus__c = 'Activated';
        ali.APTS_MYR_Start_Date__c = date.today();
        ali.APTS_MYR_End_Date__c = date.today().addDays(365);
            update ali;
          
            Test.stopTest();
    }
  
    //Start: Added by Kruti Shah(DOC-8840)
    @testSetup static void setupTestData() {
        Test.startTest(); 
        
        LTS_Disable_Application_Automation__c ltstemp = new LTS_Disable_Application_Automation__c();
        ltstemp.LTS_Disable_Process_Builders__c = true;
        ltstemp.LTS_Disable_Triggers__c = true;
        ltstemp.LTS_Disable_Validation_Rules__c = true;
        ltstemp.LTS_Disable_Workflow_Rules__c = true;
        ltstemp.Name = 'temp';
        ltstemp.SetupOwnerId = userinfo.getuserid();
        insert ltstemp;
        
        List<KeyValueListStore__c> keyvaluestoreList =  new List<KeyValueListStore__c>();
        KeyValueListStore__c keyvaluestore=new  KeyValueListStore__c();
        keyvaluestore.Name='ANZUsersProfileId';
        keyvaluestore.TextValue__c='00e30000001ZUki';
        keyvaluestoreList.add(keyvaluestore);
        
        KeyValueListStore__c keyval = new KeyValueListStore__c();
        keyval.Name='ReasonWithCompetitor';
        keyval.TextValue__c='Price';
        keyvaluestoreList.add(keyval);
        insert keyvaluestoreList;
        
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
        
        Account a = APTS_TestDataFactory.createAccount('Testing Account');
        a.Customer_Group__c = 'Customer Class';
        insert a;
        system.debug('@@@@@@@@Account'+a);
        
        Contact cont=APTS_TestDataFactory.createContact('lastName',a.id);
        cont.FirstName='firstName';
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
        insert accountSSD;
        
        PriceBook2 pb_Canada=new PriceBook2(Name ='TR Pricebook');
        insert pb_Canada;
                
        Id oppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Pipeline Opportunity').getRecordTypeId();
        Opportunity oppty = new Opportunity();
        oppty.AccountId = a.Id;
        oppty.Name = 'Renew_TAX Professional_Oppty';
        oppty.CloseDate = System.Today() + 5;
        oppty.StageName = 'Prospect';       
        oppty.Sales_Org__c='LLEY';
        oppty.Source_System_Detail__c=accountSSD.id;
        oppty.Category__c='SUSCRIPCION';
        oppty.Pricebook2Id =pb_Canada.Id;
        oppty.RecordtypeId=oppRecordTypeId;
        oppty.OwnerId = UserInfo.getUserId();
        oppty.Probability = 10;
        oppty.Latam_Is_System_Generated__c = true;
        oppty.Was_There_a_Competitor__c = 'No';
        oppty.Reason__c = 'Relationship / Existing Customer';
        insert oppty;
        
        Apttus_Config2__PriceList__c pl= APTS_TestDataFactory.createPriceList('Thomson Reuters Master - US Legal');
        insert pl;
        
        Id propRecorType=Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Proposal').getRecordTypeId();
        system.debug('$$$$$$$'+accountSSD);
        Apttus_Proposal__Proposal__c oProposal = APTS_TestDataFactory.createProposal(oppty.id,a.Id);
        oProposal.Apttus_Proposal__Approval_Stage__c='Draft';
        oProposal.Apttus_Proposal__Account__c = a.Id;
        oProposal.APTS_Proposal_Business_Unit__c='Tax Professional';
        oProposal.RecordtypeId = propRecorType;
        oProposal.Apttus_Proposal__Opportunity__c = oppty.id;
        oProposal.APTS_SSD_Sold_To__c = accountSSD.Id;
        oProposal.Apttus_Proposal__Account__c = a.Id;
        oProposal.Apttus_Proposal__Primary__c = false;

        oproposal.APTS_Order_Confirmation_Contact__c =cont.Id;
        oproposal.Apttus_Proposal__Primary_Contact__c=cont.Id;
        oproposal.APTS_SSD_bill_to__c=accountSSD.Id;
        oproposal.CurrencyIsoCode='USD';
        oproposal.Auto_Renewal_Quote__c=true; 
        oproposal.Apttus_Proposal__ExpectedStartDate__c= System.today()-100;
        oproposal.APTS_SSD_Ship_to__c=accountSSD.Id;        
        oproposal.Apttus_QPConfig__IsSystemGenerated__c =True;
        oproposal.Apttus_Proposal__Proposal_Name__c='Renew_Tax Professional';       
        oproposal.APTS_Temp_Order_Confirmation_Contact__c=cont.Id;
        oproposal.Apttus_Proposal__Payment_Term__c = 'P030 - Brazil Net 30 days';
        oproposal.APTS_Ground_Shipping__c = 'Ground Shipping - U.S. Only';
        oproposal.Apttus_QPConfig__PONumber__c='a001';
        oproposal.OwnerId = UserInfo.getUserId();
        oProposal.Latam_APTS_Reason__c = 'Account/Relationship Management';
        oProposal.Apttus_Proposal__Proposal_Category__c='Quote';
        insert oProposal;
        
        Apttus_Config2__ProductConfiguration__c prodConfig = new Apttus_Config2__ProductConfiguration__c();
        prodConfig.Apttus_QPConfig__Proposald__c = oProposal.Id;
        prodConfig.Name = 'Product Config - Renew:-Tax Professional,S100,a9d2f0000008a10,USD,2019-12-31,';
        prodConfig.Apttus_Config2__BusinessObjectType__c = 'Proposal';
        prodConfig.Apttus_Config2__Status__c = 'Finalized';
        prodConfig.Apttus_Config2__PriceListId__c = pl.ID;
        insert prodConfig;   
        
        Latam_AssetItemAutoNumber__c autoNumberObject = new Latam_AssetItemAutoNumber__c();
        autoNumberObject.Auto_Format__c ='-';
        autoNumberObject.Starting_Number__c = 0;
        insert autoNumberObject;
        
        Apttus_Config2__AssetLineItem__c oAssetLi = new Apttus_Config2__AssetLineItem__c(Apttus_Config2__EndDate__c =Date.Today());            
        oAssetLi.Renewal_quote_created__c = true;
        oAssetLi.Apttus_Config2__AssetStatus__c = 'Activated';
        oAssetLi.APTS_Proposal_Business_Unit__c = 'Tax Professional';
        insert oAssetLi;
        
        Apttus_Config2__AssetLineItem__c ali = new Apttus_Config2__AssetLineItem__c();
        ali.APTS_Proposal_Business_Unit__c = 'Tax Professional';
        ali.Apttus_Config2__Description__c = '';
        ali.Apttus_Config2__AssetStatus__c = 'Activated';
        ali.Apttus_Config2__EndDate__c = Date.Today();
        ali.Renewal_quote_created__c = true;
        insert ali;
        
        Apttus_Config2__TempRenewAssetGroup__c trag = new Apttus_Config2__TempRenewAssetGroup__c();
        trag.Apttus_Config2__ConfigurationId__c  = prodConfig.ID;
        trag.Apttus_Config2__EndDate__c = date.today().addDays(365);
        trag.Apttus_Config2__ExecutionMode__c = 'OnDemand';
        trag.Apttus_Config2__GroupFieldValues__c = 'Tax Professional,S100,a9d2f0000008a10,USD,2019-12-31,Auto Renew,Poorva Sinha';
        trag.Apttus_Config2__PriceListId__c = pl.Id;
        trag.Apttus_Config2__StartDate__c = date.today();
        trag.Apttus_Config2__Status__c='Complete';        
        insert trag;
        
        List<Apttus_Config2__TempRenewAssetLineItem__c> trALIlist = new List<Apttus_Config2__TempRenewAssetLineItem__c>();
        Apttus_Config2__TempRenewAssetLineItem__c trALI1 = new Apttus_Config2__TempRenewAssetLineItem__c();
        trALI1.Apttus_Config2__RenewAssetGroupId__c = trag.ID;
        trALI1.Apttus_Config2__AssetLineItemId__c = ali.ID;
        trALI1.Apttus_Config2__Status__c = 'New';
        trALIlist.add(trALI1);
        Apttus_Config2__TempRenewAssetLineItem__c trALI2 = new Apttus_Config2__TempRenewAssetLineItem__c();
        trALI2.Apttus_Config2__RenewAssetGroupId__c = trag.ID;
        trALI2.Apttus_Config2__AssetLineItemId__c = oAssetLi.ID;
        trALI2.Apttus_Config2__Status__c = 'New';
        trALIlist.add(trALI2);
        
        insert trALIlist;
        Test.stopTest();
    }    
    
    static testmethod void updateRenewalQuoteToExpired(){
        Test.startTest();
        checkRecursive.propsaltrgr_updateOpportunityStage  = true;
        Apttus_Config2__AssetLineItem__c ali = [select Id,Name,Apttus_Config2__EndDate__c from Apttus_Config2__AssetLineItem__c limit 1];
        ali.Apttus_Config2__EndDate__c = date.today().addDays(365);
        update ali;
        Test.stopTest();
    }
    //End: Added by Kruti Shah(DOC-8840)
    
    @isTest static void testflowflassetupdate(){
        Apttus_Config2__PriceList__c priceList = APTS_TestDataFactory.createPriceList('Thomson Reuters Master - US Legal');
        insert priceList;
        
        WebServiceSettings__c oWebServiceSettings = new WebServiceSettings__c();
        oWebServiceSettings.Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable'; 
        oWebServiceSettings.Name = 'PaymentCreditIncrease'; 
        oWebServiceSettings.Timeout__c = 120; 
        oWebServiceSettings.Endpoint__c = 'https://dev.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease'; 
        oWebServiceSettings.Active__c = true;
        insert oWebServiceSettings;

        Account a = APTS_TestDataFactory.createAccount('Test Account');
        insert a;
        
        List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c='00e30000001ZUki'),new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other')};
         insert keyvaluestore;     
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
        
        LTS_Disable_Application_Automation__c ds = new LTS_Disable_Application_Automation__c(LTS_Disable_Process_Builders__c=false);
        insert ds;
        
        CrossSelling_Pricebooks__c pr = new CrossSelling_Pricebooks__c(FindlawPricebookId__c='9876987679079',SCSPriceBookID__c='85867890');
        insert pr;
        
        Id ssdRecorType=SObjectType.Source_System_Detail__c.getRecordTypeInfosByDeveloperName().get('USL_Source_Systems').getRecordTypeId();
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
        oppty.APTS_Proposal_Business_Unit__c='FindLaw';
        insert oppty;
        
        Product2 prod = new Product2();
        prod.Name = 'Network Services 1.0';
        prod.APTS_Media_High_Level_Code__c = '08';
        prod.APTS_Media_Lower_Level_Code__c = 'BB';
        prod.APTS_Corporate_Select__c = 'Primary Essentials';
        prod.ProductCode='41076128';
        insert prod;
        
        Apttus_Proposal__Proposal__c proposal = APTS_TestDataFactory.createProposal(oppty.id, accountSSD.Id);
        proposal.APTS_Proposal_Business_Unit__c  ='FindLaw';
        proposal.APTS_Approval_Segment__c  ='FindLaw';
        proposal.Customer_Group__c = 'ACADEMIC';
        insert proposal;
        
        proposal.Customer_Group__c = 'CORPORATION';
        update proposal;
        
        Apttus_Config2__AssetLineItem__c as1 = new Apttus_Config2__AssetLineItem__c(name='test',APTS_Proposal_Business_Unit__c='FindLaw',Apttus_Config2__ProductId__c=prod.id,APTS_SSD_Sold_To__c = accountSSD.Id,Apttus_Config2__AssetStatus__c='Activated',APTS_Subscription_Number__c='40656551',Apttus_Config2__ChargeType__c='Standard Price',Apttus_Config2__PriceType__c='One Time',APTS_Info_PlanType__c='S00',Apttus_Config2__StartDate__c= Date.newInstance(2018, 1, 1),Apttus_Config2__Quantity__c=1);
        insert as1;
    }   
}