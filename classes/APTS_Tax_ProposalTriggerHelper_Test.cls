@isTest
public class APTS_Tax_ProposalTriggerHelper_Test 
{
    @isTest 
    static void testmethodTest1()
    {
        LTS_Disable_Application_Automation__c ltstemp = new LTS_Disable_Application_Automation__c();
        ltstemp.LTS_Disable_Process_Builders__c = true;
        ltstemp.LTS_Disable_Triggers__c = true;
        ltstemp.LTS_Disable_Validation_Rules__c = true;
        ltstemp.LTS_Disable_Workflow_Rules__c = true;
        ltstemp.Name = 'temp';
        ltstemp.SetupOwnerId = userinfo.getuserid();
        insert ltstemp;  
        
        map<id,Apttus_Proposal__Proposal__c>  mapOldProposals =new map<id,Apttus_Proposal__Proposal__c>();
        map<id,Apttus_Proposal__Proposal__c>  mapNewProposals =new map<id,Apttus_Proposal__Proposal__c>();
        set <id> ids=new set<id>();
        
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
        
        Account a = APTS_TestDataFactory.createAccount('Testing Account');
        a.Customer_Group__c = 'Customer Class';
        insert a;
        system.debug('@@@@@@@@Account'+a);
        
        System.assertequals('Testing Account',a.Name,'Success');
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
        insert accountSSD;
        
        Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        Opportunity oppty=APTS_TestDataFactory.createOpportunity('abc',a.id,'Needs Analysis',Date.Today());
        oppty.RecordtypeId=opptyRecorType;
        oppty.Source_System_Detail__c=accountSSD.id;
        oppty.Email__c='abc@tcs.com';
        oppty.Sales_Org__c = 'S100';
        oppty.Win_Loss__c= 'Won';
        oppty.Reason__c= 'Low Usage';
        oppty.Was_There_a_Competitor__c='No';
        oppty.CurrencyIsoCode = 'USD';
        oppty.Account=a;
        insert oppty;
        
        Apttus_Config2__PriceList__c pl= APTS_TestDataFactory.createPriceList('Test Price List 1');
        insert pl;
        Apttus_Config2__PriceList__c pl0= APTS_TestDataFactory.createPriceList('Test Price List 2');
        insert pl0;
        
        Id propRecorType=Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Proposal').getRecordTypeId();
        list<Apttus_Proposal__Proposal__c> listNewProposals=new list<Apttus_Proposal__Proposal__c>();
        
        Apttus_Proposal__Proposal__c proposal2 = APTS_TestDataFactory.createProposal(oppty.id,a.Id);
        proposal2.Apttus_Proposal__Approval_Stage__c='Presented';
        proposal2.Apttus_Proposal__Account__c = a.Id;
        proposal2.APTS_Proposal_Business_Unit__c='Tax Professional';
        proposal2.RecordtypeId = propRecorType;
        proposal2.Apttus_Proposal__Opportunity__c = oppty.id;
        proposal2.APTS_SSD_Sold_To__c = accountSSD.Id;
        proposal2.Apttus_Proposal__Account__c = a.Id;
        proposal2.Latam_APTS_Win_Loss__c= oppty.Win_Loss__c;
        proposal2.Latam_APTS_Reason__c= oppty.Reason__c;            
        listNewProposals.add(proposal2);
        
        Apttus_Proposal__Proposal__c proposal= APTS_TestDataFactory.createProposal(oppty.id,a.Id);
        proposal.Apttus_Proposal__Proposal_Name__c='Renew:-Tax Professional,Term Commitment';
        proposal.Apttus_Proposal__Approval_Stage__c='Draft';
        proposal.Apttus_Proposal__Account__c = a.Id;
        proposal.APTS_Proposal_Business_Unit__c='Tax Professional';
        proposal.LATAM_APTS_Quote_Type__c='Renewals';
        //proposal.Asset_end_date__c = Date.Today();
        proposal.RecordtypeId = propRecorType;
        proposal.Apttus_Proposal__Opportunity__c = oppty.id;
        proposal.APTS_SSD_Sold_To__c = accountSSD.Id;
        proposal.Apttus_Proposal__Account__c = a.Id;
        proposal.Latam_APTS_Win_Loss__c= oppty.Win_Loss__c;
        proposal.Latam_APTS_Reason__c= oppty.Reason__c;
        proposal.Renewal_Approval_Status__c='Pending Grace Approval';
        proposal.Tax_GP_End_date__c = Date.Today();
        
        listNewProposals.add(proposal);
        insert listNewProposals;
        ids.add(proposal2.id);
        List<Product2> productList =new List<Product2>();
        
        Product2 product= APTS_TestDataFactory.createProduct('Test Product1', null);
        productList.add(product);
        
        Product2 product1= APTS_TestDataFactory.createProduct('Test Product2', null);
        productList.add(product1);
        insert productList;
        
        List<Apttus_Config2__PriceListItem__c> ListPli= new  List<Apttus_Config2__PriceListItem__c>();
        
        Apttus_Config2__PriceListItem__c pli= new Apttus_Config2__PriceListItem__c();
        pli.Apttus_Config2__PriceListId__c=pl.id;
        pli.Apttus_Config2__ProductId__c=product.id;
        pli.Apttus_Config2__ListPrice__c=200;
        ListPli.add(pli);
        
        Apttus_Config2__PriceListItem__c pli1= new Apttus_Config2__PriceListItem__c();
        pli1.Apttus_Config2__PriceListId__c=pl.id;
        pli1.Apttus_Config2__ProductId__c=product.id;
        pli1.Apttus_Config2__ListPrice__c=200;
        ListPli.add(pli1);
        
        insert ListPli;
        
        List<Apttus_Proposal__Proposal_Line_Item__c> plit = new List<Apttus_Proposal__Proposal_Line_Item__c >();
        Apttus_Proposal__Proposal_Line_Item__c  plio = new Apttus_Proposal__Proposal_Line_Item__c ();
        plio.Apttus_QPConfig__LineStatus__c ='New';
        plio.Apttus_Proposal__Proposal__c=proposal2.id;
        plit.add(plio);
        insert plit;
        
        List<Apttus_Config2__AssetLineItem__c> listOfAssetsLineItems =new List<Apttus_Config2__AssetLineItem__c>();
        Apttus_Config2__AssetLineItem__c ali = new Apttus_Config2__AssetLineItem__c();             
        ali.Apttus_QPConfig__ProposalId__c =proposal2.id;
        ali.APTS_Proposal_Business_Unit__c ='Tax Professional';
        ali.Apttus_Config2__AssetStatus__c ='Activated';
        ali.Apttus_QPConfig__ProposalLineItemId__c =plio.id;
        ali.Apttus_Config2__EndDate__c=system.today();
        ali.Latam_GP_End_Date__c= system.today().addDays(30);
        listOfAssetsLineItems.add(ali);
        insert listOfAssetsLineItems;
        
        Apttus_Proposal__Proposal_Line_Item__c  plio2 = new Apttus_Proposal__Proposal_Line_Item__c();
        plio2.Apttus_QPConfig__LineStatus__c ='Renewed';
        plio2.Apttus_Proposal__Proposal__c=proposal.id;
        plio2.Apttus_QPConfig__AssetLineItemId__c=ali.id;
        insert plio2;       
          
        test.startTest();          
        proposal.Apttus_Proposal__Proposal_Name__c='Renew:-Tax Professional,Term Commitment';
        proposal.Apttus_Proposal__Approval_Stage__c='Draft';        
        proposal.Renewal_Approval_Status__c='';
        update proposal;
        
        APTS_ProposalTriggerHandler.beforeUpdate = true;
        APTS_ProposalTriggerHandler.afterUpdate = true;
                
        System.debug('@@@@@@---------@@@@@@@NEW'+proposal2.id);
        test.stopTest();
        
    }
    
    @isTest 
    static void testupdateWinLostReason()
    {
        LTS_Disable_Application_Automation__c ltstemp = new LTS_Disable_Application_Automation__c();
        ltstemp.LTS_Disable_Process_Builders__c = true;
        ltstemp.LTS_Disable_Triggers__c = true;
        ltstemp.LTS_Disable_Validation_Rules__c = true;
        ltstemp.LTS_Disable_Workflow_Rules__c = true;
        ltstemp.Name = 'temp';
        ltstemp.SetupOwnerId = userinfo.getuserid();
        insert ltstemp;  
        
        map<id,Apttus_Proposal__Proposal__c>  mapOldProposals =new map<id,Apttus_Proposal__Proposal__c>();
        map<id,Apttus_Proposal__Proposal__c>  mapNewProposals =new map<id,Apttus_Proposal__Proposal__c>();
        set <id> ids=new set<id>();
        
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
        
        Account a = APTS_TestDataFactory.createAccount('Testing Account');
        a.Customer_Group__c = 'Customer Class';
        insert a;
        
        System.assertequals('Testing Account',a.Name,'Success');
        
        Contact cont=APTS_TestDataFactory.createContact('Kaur',a.id);
        cont.FirstName='Test';
        cont.Email='abc@gmail.com';
        cont.Phone='9876543290';
        insert cont;
        
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();
        Source_System_Detail__c accountSSD= new Source_System_Detail__c();
        accountSSD.RecordtypeId=ssdRecorType;
        accountSSD.Name='ABC';
        accountSSD.Source_System_Name__c='ABC';
        accountSSD.Account_Name__c=a.ID;
        accountSSD.Account_Inactive__c=false;
        accountSSD.LCRM_Sales_Org__c='BEJE';
        insert accountSSD;
        
        Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        Opportunity autoRenewOppty=APTS_TestDataFactory.createOpportunity('abc',a.id,'Needs Analysis',Date.Today());
        autoRenewOppty.RecordtypeId=opptyRecorType;
        autoRenewOppty.Source_System_Detail__c=accountSSD.id;
        autoRenewOppty.Email__c='abc@tcs.com';
        autoRenewOppty.Sales_Org__c = 'S100';
        autoRenewOppty.Win_Loss__c= 'Won';
        autoRenewOppty.Was_There_a_Competitor__c='No';
        autoRenewOppty.CurrencyIsoCode = 'USD';
        autoRenewOppty.Account=a;
        insert autoRenewOppty;
        
        Id opptyRecorType1=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        Opportunity termCommitOppty=APTS_TestDataFactory.createOpportunity('abc',a.id,'Needs Analysis',Date.Today());
        termCommitOppty.RecordtypeId=opptyRecorType1;
        termCommitOppty.Source_System_Detail__c=accountSSD.id;
        termCommitOppty.Email__c='abc@tcs.com';
        termCommitOppty.Sales_Org__c = 'S100';
        termCommitOppty.Win_Loss__c= 'Won';
        termCommitOppty.Was_There_a_Competitor__c='No';
        termCommitOppty.CurrencyIsoCode = 'USD';
        termCommitOppty.Account=a;
        insert termCommitOppty;
        
        Id opptyRecorType2=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        Opportunity creditCheckOppty=APTS_TestDataFactory.createOpportunity('abc',a.id,'Needs Analysis',Date.Today());
        creditCheckOppty.RecordtypeId=opptyRecorType2;
        creditCheckOppty.Source_System_Detail__c=accountSSD.id;
        creditCheckOppty.Email__c='abc@tcs.com';
        creditCheckOppty.Sales_Org__c = 'S100';
        creditCheckOppty.Win_Loss__c= 'Won';
        creditCheckOppty.Was_There_a_Competitor__c='No';
        creditCheckOppty.CurrencyIsoCode = 'USD';
        creditCheckOppty.Account=a;
        insert creditCheckOppty;
        
        Apttus_Config2__PriceList__c pl= APTS_TestDataFactory.createPriceList('Test Price List 1');
        insert pl;
        Apttus_Config2__PriceList__c pl0= APTS_TestDataFactory.createPriceList('Test Price List 2');
        insert pl0;
        
        Id propRecorType=Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Proposal').getRecordTypeId();
        list<Apttus_Proposal__Proposal__c> listNewProposals=new list<Apttus_Proposal__Proposal__c>();
        
        Apttus_Proposal__Proposal__c autoRenewProposal = APTS_TestDataFactory.createProposal(autoRenewOppty.id,a.Id);
        autoRenewProposal.Apttus_Proposal__Proposal_Name__c='Auto Renew Proposal';
        autoRenewProposal.Apttus_Proposal__Approval_Stage__c='Cancelled';
        autoRenewProposal.Apttus_Proposal__Account__c = a.Id;
        autoRenewProposal.APTS_Proposal_Business_Unit__c='Tax Professional';
        autoRenewProposal.RecordtypeId = propRecorType;
        autoRenewProposal.Apttus_Proposal__Opportunity__c = autoRenewOppty.id;
        autoRenewProposal.APTS_SSD_Sold_To__c = accountSSD.Id;
        autoRenewProposal.Apttus_Proposal__Account__c = a.Id;
        autoRenewProposal.Latam_APTS_Win_Loss__c= autoRenewOppty.Win_Loss__c;
        autoRenewProposal.Latam_APTS_Reason__c= 'Relationship';
        autoRenewProposal.Apttus_QPConfig__IsSystemGenerated__c = true;
        autoRenewProposal.Apttus_Proposal__Primary__c = true;
        autoRenewProposal.LATAM_APTS_Quote_Type__c='Renewals';
        //autoRenewProposal.APTS_Renewal_Type__c = 'Auto Renew';
        listNewProposals.add(autoRenewProposal);
        
        Apttus_Proposal__Proposal__c termCommitProposal= APTS_TestDataFactory.createProposal(termCommitOppty.id,a.Id);
        termCommitProposal.Apttus_Proposal__Proposal_Name__c='Term Commitment Proposal';
        termCommitProposal.Apttus_Proposal__Approval_Stage__c='Expired';
        termCommitProposal.Apttus_Proposal__Account__c = a.Id;
        termCommitProposal.APTS_Proposal_Business_Unit__c='Tax Professional';
        //termCommitProposal.Asset_end_date__c = Date.Today();
        termCommitProposal.RecordtypeId = propRecorType;
        termCommitProposal.Apttus_Proposal__Opportunity__c = termCommitOppty.id;
        termCommitProposal.APTS_SSD_Sold_To__c = accountSSD.Id;
        termCommitProposal.Apttus_Proposal__Account__c = a.Id;
        termCommitProposal.Latam_APTS_Win_Loss__c= termCommitOppty.Win_Loss__c;
        termCommitProposal.Latam_APTS_Reason__c= 'Relationship';
        termCommitProposal.Apttus_QPConfig__IsSystemGenerated__c = true;
        termCommitProposal.Apttus_Proposal__Primary__c = true;
        termCommitProposal.LATAM_APTS_Quote_Type__c='Renewals';
        //termCommitProposal.APTS_Renewal_Type__c = 'Term Commitment';
        listNewProposals.add(termCommitProposal);
        
        Apttus_Proposal__Proposal__c creditCheckProposal = APTS_TestDataFactory.createProposal(creditCheckOppty.id,a.Id);
        creditCheckProposal.Apttus_Proposal__Proposal_Name__c='Credit Check Proposal';
        creditCheckProposal.Apttus_Proposal__Approval_Stage__c='Cancelled';
        creditCheckProposal.Apttus_Proposal__Account__c = a.Id;
        creditCheckProposal.APTS_Proposal_Business_Unit__c='Tax Professional';
        creditCheckProposal.RecordtypeId = propRecorType;
        creditCheckProposal.Apttus_Proposal__Opportunity__c = creditCheckOppty.id;
        creditCheckProposal.APTS_SSD_Sold_To__c = accountSSD.Id;
        creditCheckProposal.Apttus_Proposal__Account__c = a.Id;
        creditCheckProposal.Latam_APTS_Win_Loss__c= creditCheckOppty.Win_Loss__c;
        creditCheckProposal.Apttus_Proposal__Primary__c = true;
        creditCheckProposal.Latam_APTS_Reason__c= 'Relationship';
        creditCheckProposal.SAP_Credit_Check_Status__c = 'Fail';
        listNewProposals.add(creditCheckProposal);
        
        Apttus_Proposal__Proposal__c nonAutoRenewProposal = APTS_TestDataFactory.createProposal(autoRenewOppty.id,a.Id);
        nonAutoRenewProposal.Apttus_Proposal__Proposal_Name__c='Non Auto Renew Proposal';
        nonAutoRenewProposal.Apttus_Proposal__Approval_Stage__c='Cancelled';
        nonAutoRenewProposal.Apttus_Proposal__Account__c = a.Id;
        nonAutoRenewProposal.APTS_Proposal_Business_Unit__c='Tax Professional';
        nonAutoRenewProposal.RecordtypeId = propRecorType;
        nonAutoRenewProposal.Apttus_Proposal__Opportunity__c = autoRenewOppty.id;
        nonAutoRenewProposal.APTS_SSD_Sold_To__c = accountSSD.Id;
        nonAutoRenewProposal.Apttus_Proposal__Account__c = a.Id;
        nonAutoRenewProposal.Latam_APTS_Win_Loss__c= autoRenewOppty.Win_Loss__c;
        nonAutoRenewProposal.Latam_APTS_Reason__c= 'Relationship';
        nonAutoRenewProposal.Apttus_QPConfig__IsSystemGenerated__c = true;
        nonAutoRenewProposal.Apttus_Proposal__Primary__c = true;
        nonAutoRenewProposal.LATAM_APTS_Quote_Type__c='Renewals';
        //nonAutoRenewProposal.APTS_Renewal_Type__c = 'test';
        listNewProposals.add(nonAutoRenewProposal);
        
        Apttus_Proposal__Proposal__c creditCheckPendingProposal = APTS_TestDataFactory.createProposal(creditCheckOppty.id,a.Id);
        creditCheckPendingProposal.Apttus_Proposal__Proposal_Name__c='Credit Check Pending Proposal';
        creditCheckPendingProposal.Apttus_Proposal__Approval_Stage__c='Cancelled';
        creditCheckPendingProposal.Apttus_Proposal__Account__c = a.Id;
        creditCheckPendingProposal.APTS_Proposal_Business_Unit__c='Tax Professional';
        creditCheckPendingProposal.RecordtypeId = propRecorType;
        creditCheckPendingProposal.Apttus_Proposal__Opportunity__c = creditCheckOppty.id;
        creditCheckPendingProposal.APTS_SSD_Sold_To__c = accountSSD.Id;
        creditCheckPendingProposal.Apttus_Proposal__Account__c = a.Id;
        creditCheckPendingProposal.Latam_APTS_Win_Loss__c= creditCheckOppty.Win_Loss__c;
        creditCheckPendingProposal.Apttus_Proposal__Primary__c = true;
        creditCheckPendingProposal.Latam_APTS_Reason__c= 'Relationship';
        creditCheckPendingProposal.SAP_Credit_Check_Status__c = 'Pending';
        listNewProposals.add(creditCheckPendingProposal);
        
        Apttus_Proposal__Proposal__c newSaleProposal = APTS_TestDataFactory.createProposal(creditCheckOppty.id,a.Id);
        newSaleProposal.Apttus_Proposal__Proposal_Name__c='New Sale Proposal';
        newSaleProposal.Apttus_Proposal__Approval_Stage__c='Cancelled';
        newSaleProposal.Apttus_Proposal__Account__c = a.Id;
        newSaleProposal.APTS_Proposal_Business_Unit__c='Tax Professional';
        newSaleProposal.RecordtypeId = propRecorType;
        newSaleProposal.Apttus_Proposal__Opportunity__c = creditCheckOppty.id; 
        newSaleProposal.APTS_SSD_Sold_To__c = accountSSD.Id;
        newSaleProposal.Apttus_Proposal__Account__c = a.Id;
        newSaleProposal.Latam_APTS_Win_Loss__c= creditCheckOppty.Win_Loss__c; 
        newSaleProposal.Apttus_Proposal__Primary__c = true;
        newSaleProposal.Latam_APTS_Reason__c= 'Relationship';
        //newSaleProposal.SAP_Credit_Check_Status__c = 'Fail';  
        listNewProposals.add(newSaleProposal);
        
        if(!listNewProposals.isEmpty() && listNewProposals.SIZE() > 0)
        {
            insert listNewProposals;
        }
        
        
        List<Product2> productList =new List<Product2>();
        
        Product2 product= APTS_TestDataFactory.createProduct('Test Product1', null);
        productList.add(product);
        
        Product2 product1= APTS_TestDataFactory.createProduct('Test Product2', null);
        productList.add(product1);
        insert productList;
        
        List<Apttus_Config2__PriceListItem__c> ListPli= new  List<Apttus_Config2__PriceListItem__c>();
        
        Apttus_Config2__PriceListItem__c pli= new Apttus_Config2__PriceListItem__c();
        pli.Apttus_Config2__PriceListId__c=pl.id;
        pli.Apttus_Config2__ProductId__c=product.id;
        pli.Apttus_Config2__ListPrice__c=200;
        ListPli.add(pli);
        
        Apttus_Config2__PriceListItem__c pli1= new Apttus_Config2__PriceListItem__c();
        pli1.Apttus_Config2__PriceListId__c=pl.id;
        pli1.Apttus_Config2__ProductId__c=product.id;
        pli1.Apttus_Config2__ListPrice__c=200;
        ListPli.add(pli1);
        
        insert ListPli;
        
        test.startTest();          
        autoRenewProposal.Apttus_Proposal__Proposal_Name__c='Renew:-Tax Professional,Auto Renewal';
        update autoRenewProposal;
        
        termCommitProposal.Apttus_Proposal__Proposal_Name__c='Renew:-Tax Professional,Term Commitment';
        update termCommitProposal;
        
        creditCheckProposal.Apttus_Proposal__Proposal_Name__c='Credit Check updated';
        update creditCheckProposal;
        
        nonAutoRenewProposal.Apttus_Proposal__Proposal_Name__c='Non Auto Renew Proposal updated';
        update nonAutoRenewProposal;
        
        nonAutoRenewProposal.Apttus_Proposal__Proposal_Name__c='Credit Check Pending Proposal updated';
        update nonAutoRenewProposal;
        
        newSaleProposal.Apttus_Proposal__Proposal_Name__c='New Sale Proposal updated';
        update newSaleProposal;
        
        APTS_ProposalTriggerHandler.beforeUpdate = true;
        APTS_ProposalTriggerHandler.afterUpdate = true;
        
        test.stopTest();
        
    }
    
    @isTest 
    static void updatePaymentDetailsforExisting()
    {
    LTS_Disable_Application_Automation__c ltstemp = new LTS_Disable_Application_Automation__c();
    ltstemp.LTS_Disable_Process_Builders__c = true;
    ltstemp.LTS_Disable_Triggers__c = true;
    ltstemp.LTS_Disable_Validation_Rules__c = true;
    ltstemp.LTS_Disable_Workflow_Rules__c = true;
    ltstemp.Name = 'temp';
    ltstemp.SetupOwnerId = userinfo.getuserid();
    insert ltstemp;    
    map<id,Apttus_Proposal__Proposal__c>  mapOldProposals =new map<id,Apttus_Proposal__Proposal__c>();
    map<id,Apttus_Proposal__Proposal__c>  mapNewProposals =new map<id,Apttus_Proposal__Proposal__c>();
    set <id> ids=new set<id>();
    boolean taxFlag = true;
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
    
    Account a = APTS_TestDataFactory.createAccount('Testing Account');
    a.Customer_Group__c = 'Customer Class';
    insert a;
    system.debug('@@@@@@@@Account'+a);
    
    System.assertequals('Testing Account',a.Name,'Success');
    
    Contact cont=APTS_TestDataFactory.createContact('Kaur',a.id);
    cont.FirstName='Navpreet';
    cont.Email='abc@gmail.com';
    cont.Phone='9873337890';
    insert cont;
    system.debug('@@@@@@@@Contact'+cont);
    
    Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();
    list<Source_System_Detail__c> listSSDs = new list<Source_System_Detail__c>();
    Source_System_Detail__c accountSSD= new Source_System_Detail__c();
    accountSSD.RecordtypeId=ssdRecorType;
    accountSSD.Name='ABC';
    accountSSD.Source_System_Name__c='ABC';
    accountSSD.Account_Name__c=a.ID;
    accountSSD.Account_Inactive__c=false;
    accountSSD.LCRM_Sales_Org__c='BEJE';
    accountSSD.APTS_Is_Customer__c = true;
    accountSSD.Source_System_Account_Number__c ='2000000584';
    accountSSD.Card_Number__c = 'XXXX-XXXX-XXXX-0004';
    accountSSD.Card_Type__c = 'VISA';
    accountSSD.Expiry_Date__c = System.today();
    accountSSD.Default_Payment_Method__c = 'Auto EFT/Auto Charge';
    
    listSSDs.add(accountSSD);
    
    Source_System_Detail__c accountSSD1= new Source_System_Detail__c();
    accountSSD1.RecordtypeId=ssdRecorType;
    accountSSD1.Name='ABC';
    accountSSD1.Source_System_Name__c='ABC';
    accountSSD1.Account_Name__c=a.ID;
    accountSSD1.Account_Inactive__c=false;
    accountSSD1.LCRM_Sales_Org__c='BEJE';
    accountSSD1.APTS_Is_Customer__c = false;
    accountSSD1.Source_System_Account_Number__c ='';
    accountSSD1.Card_Number__c = '';
    accountSSD1.Card_Type__c = '';
    //accountSSD1.Expiry_Date__c = '';
    accountSSD1.Default_Payment_Method__c = '';
    
     listSSDs.add(accountSSD1);
     
    Source_System_Detail__c accountSSD2= new Source_System_Detail__c();
    accountSSD2.RecordtypeId=ssdRecorType;
    accountSSD2.Name='ABC';
    accountSSD2.Source_System_Name__c='ABC';
    accountSSD2.Account_Name__c=a.ID;
    accountSSD2.Account_Inactive__c=false;
    accountSSD2.LCRM_Sales_Org__c='BEJE';
    accountSSD2.APTS_Is_Customer__c = true;
    accountSSD2.Source_System_Account_Number__c ='2000000584';
    accountSSD2.Bank_Account_Number__c = 'XXXX-XXXX-XXXX-0004';
    accountSSD2.Bank_Name__c= 'SBI';
    accountSSD2.Bank_Routing_Number__c= '1234';
    accountSSD2.Default_Payment_Method__c = 'Auto EFT/Auto Charge';
    
   //insert accountSSD;
    
    listSSDs.add(accountSSD2);
     
    insert listSSDs;
    
    Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
    Opportunity oppty=APTS_TestDataFactory.createOpportunity('abc',a.id,'Needs Analysis',Date.Today());
    oppty.RecordtypeId=opptyRecorType;
    oppty.Source_System_Detail__c=accountSSD.id;
    oppty.Email__c='abc@tcs.com';    
    oppty.Sales_Org__c = 'S100';
    oppty.Win_Loss__c= 'Won';
    oppty.Reason__c= 'Low Usage';
    oppty.Was_There_a_Competitor__c='No';
    oppty.CurrencyIsoCode = 'USD';    
    oppty.Account=a;
    insert oppty;
    
    Apttus_Config2__PriceList__c pl= APTS_TestDataFactory.createPriceList('Test Price List 1');
    insert pl;
    Apttus_Config2__PriceList__c pl0= APTS_TestDataFactory.createPriceList('Test Price List 2');
    insert pl0;
    Id propRecorType=Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Proposal').getRecordTypeId();
    list<Apttus_Proposal__Proposal__c> listNewProposals=new list<Apttus_Proposal__Proposal__c>();
    
    Apttus_Proposal__Proposal__c proposal2 = APTS_TestDataFactory.createProposal(oppty.id,a.Id);
    proposal2.Apttus_Proposal__Approval_Stage__c='Draft';
    proposal2.Apttus_Proposal__Account__c = a.Id;
    proposal2.APTS_Proposal_Business_Unit__c='Tax Professional';
    proposal2.RecordtypeId = propRecorType;
    proposal2.Apttus_Proposal__Opportunity__c = oppty.id;
    proposal2.APTS_SSD_Sold_To__c = accountSSD1.Id;
    proposal2.Apttus_Proposal__Account__c = a.Id;
    proposal2.Latam_APTS_Win_Loss__c= oppty.Win_Loss__c;
    
    proposal2.Tax_Payment_Option__c ='';
    proposal2.Latam_APTS_Reason__c= oppty.Reason__c;
    // proposal2.Was_There_a_Competitor__c =  oppty.Was_There_a_Competitor__c;
    //proposal2.LATAM_APTS_Payment_Method__c = 'Bank Account Debit';
    //proposal2.Renewal_Approval_Status__c='Pending Grace Approval';
    proposal2.APTS_Payment_Option__c= 'Payment Express Auto EFT/Auto Charge'; 
    insert proposal2;
    listNewProposals.add(proposal2);
    
    Apttus_Proposal__Proposal__c proposal= APTS_TestDataFactory.createProposal(oppty.id,a.Id);
    proposal.Apttus_Proposal__Approval_Stage__c='Draft';
    proposal.Apttus_Proposal__Account__c = a.Id;
    proposal.APTS_Proposal_Business_Unit__c='Tax Professional';
    proposal.RecordtypeId = propRecorType;
    proposal.Apttus_Proposal__Opportunity__c = oppty.id;
    proposal.APTS_SSD_Sold_To__c = accountSSD.Id;
    proposal.Apttus_Proposal__Account__c = a.Id;
    //proposal.APTS_Agreement_Language__c = 'English';
    proposal.Latam_APTS_Win_Loss__c= oppty.Win_Loss__c;
    proposal.Latam_APTS_Reason__c= oppty.Reason__c;
    proposal.Tax_Payment_Option__c = 'Auto EFT/Auto Charge';
    proposal.APTS_Credit_Card_Token__c =  accountSSD.Card_Number__c;
    proposal.APTS_Card_Type__c = accountSSD.Card_Type__c;
    proposal.APTS_Card_Expiration_Date__c = accountSSD.Expiry_Date__c;                                         
    proposal.APTS_Payment_Option__c= accountSSD.Default_Payment_Method__c;
    
    insert proposal;
    listNewProposals.add(proposal);
    
    Apttus_Proposal__Proposal__c proposal3= APTS_TestDataFactory.createProposal(oppty.id,a.Id);
    proposal3.Apttus_Proposal__Approval_Stage__c='Draft';
    proposal3.Apttus_Proposal__Account__c = a.Id;
    proposal3.APTS_Proposal_Business_Unit__c='Tax Professional';
    proposal3.RecordtypeId = propRecorType;
    proposal3.Apttus_Proposal__Opportunity__c = oppty.id;
    proposal3.APTS_SSD_Sold_To__c = accountSSD2.Id;
    proposal3.Apttus_Proposal__Account__c = a.Id;
    //proposal.APTS_Agreement_Language__c = 'English';
    proposal3.Latam_APTS_Win_Loss__c= oppty.Win_Loss__c;
    proposal3.Latam_APTS_Reason__c= oppty.Reason__c;
    proposal3.Tax_Payment_Option__c = 'Auto EFT/Auto Charge';
    proposal3.APTS_Bank_Account_Number__c =  accountSSD2.Bank_Account_Number__c;
    proposal3.APTS_Bank_Name__c = accountSSD2.Bank_Name__c;
    proposal3.APTS_Bank_Routing_Number__c = accountSSD2.Bank_Routing_Number__c;                                         
    proposal3.APTS_Payment_Option__c= accountSSD2.Default_Payment_Method__c;
    insert proposal3;
    listNewProposals.add(proposal3);
    
    //insert listNewProposals;
    ids.add(proposal2.id);
    List<Product2> productList =new List<Product2>();
    
    Product2 product= APTS_TestDataFactory.createProduct('Test Product1', null);
    productList.add(product);
        
    Product2 product1= APTS_TestDataFactory.createProduct('Test Product2', null);
    productList.add(product1);
    insert productList;
    
    List<Apttus_Config2__PriceListItem__c> ListPli= new  List<Apttus_Config2__PriceListItem__c>();
    
    Apttus_Config2__PriceListItem__c pli= new Apttus_Config2__PriceListItem__c();
    pli.Apttus_Config2__PriceListId__c=pl.id;
    pli.Apttus_Config2__ProductId__c=product.id;
    pli.Apttus_Config2__ListPrice__c=200;
    ListPli.add(pli);
    
    Apttus_Config2__PriceListItem__c pli1= new Apttus_Config2__PriceListItem__c();
    pli1.Apttus_Config2__PriceListId__c=pl.id;
    pli1.Apttus_Config2__ProductId__c=product.id;
    pli1.Apttus_Config2__ListPrice__c=200;
    ListPli.add(pli1);
    
    insert ListPli;    
    
    List<Apttus_Proposal__Proposal_Line_Item__c> plit = new List<Apttus_Proposal__Proposal_Line_Item__c >();
    Apttus_Proposal__Proposal_Line_Item__c  plio = new Apttus_Proposal__Proposal_Line_Item__c ();
    plio.Apttus_QPConfig__LineStatus__c ='New';
    plio.Related_Quote_Proposal__c = proposal2.id;
    plio.Apttus_Proposal__Proposal__c=proposal2.id;
    plit.add(plio);
    insert plit;
    
    mapOldProposals.put(proposal2.id,proposal2);  
    test.startTest();
    
    FeedItem post = new FeedItem();
    post.ParentId = proposal.Id;
    post.Body='SoldTo SSD was changed on Proposal. Newly mapped SSD is existing customer which enabled additional Payment Options. Please discuss Payment Options with Customer again.';
    insert post;
        
    proposal2.Apttus_Proposal__Approval_Stage__c='Draft';
    proposal2.APTS_SSD_Sold_To__c = accountSSD.id;
    update proposal2;
    
    mapNewProposals.put(proposal2.id, proposal2); 
    
    APTS_ProposalTriggerHandler.beforeUpdate = true;
    APTS_ProposalTriggerHandler.afterUpdate = true;
        
    System.debug('@@@@@@---------@@@@@@@NEW'+proposal2.id);
        
    test.stopTest();
    
    }
static testMethod void templateFieldUpdateTest() {

    

        LTS_Disable_Application_Automation__c ltstemp = new LTS_Disable_Application_Automation__c();
        ltstemp.LTS_Disable_Process_Builders__c = true;
        ltstemp.LTS_Disable_Triggers__c = true;
        ltstemp.LTS_Disable_Validation_Rules__c = true;
        ltstemp.LTS_Disable_Workflow_Rules__c = true;
        ltstemp.Name = 'temp';
        ltstemp.SetupOwnerId = userinfo.getuserid();
        insert ltstemp;
             
        Apttus_Config2__PriceList__c priceList = APTS_TestDataFactory.createPriceList('Thomson Reuters Master - US Legal');
        insert priceList;

        
        List<KeyValueListStore__c> keyvaluestoreList=new List<KeyValueListStore__c>();
        KeyValueListStore__c keyvaluestore=new  KeyValueListStore__c();
        keyvaluestore.Name='ANZUsersProfileId';
        keyvaluestore.TextValue__c=System.Label.APTS_OC_Test_Id;
        
          KeyValueListStore__c LCRMStrikeIronFlagINS1 = new KeyValueListStore__c();
        LCRMStrikeIronFlagINS1.Name='LCRMDisableStrikeIronServices';
        LCRMStrikeIronFlagINS1.TextValue__c='True';
        keyvaluestoreList.add(LCRMStrikeIronFlagINS1 );
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

        Account a = APTS_TestDataFactory.createAccount('Test Account');
        insert a;        
        
        System.assertequals('Test Account',a.Name,'Success');
        
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();
        //Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByDeveloperName().get(USL_Source_Systems).getRecordTypeId();
        
        List<Source_System_Detail__c> ssdlist = new List<Source_System_Detail__c>();
        Source_System_Detail__c accountSSD=APTS_TestDataFactory.createSourceSystem(a);
        accountSSD.RecordtypeId=ssdRecorType;
        accountSSD.Account_Inactive__c=false;
        accountSSD.Name='ABC';
        accountSSD.Source_System_Name__c='ABC';
        accountSSD.Account_Name__c=a.ID;
        accountSSD.Account_Inactive__c=false;
        accountSSD.LCRM_Sales_Org__c='S100';
        ssdlist.add(accountSSD);
        
        Source_System_Detail__c accountSSDSCS=APTS_TestDataFactory.createSourceSystem(a);
        accountSSDSCS.RecordtypeId=ssdRecorType;
        accountSSDSCS.Account_Inactive__c=false;
        accountSSDSCS.Name='ABCSCS';
        accountSSDSCS.Source_System_Name__c='ABC';
        accountSSDSCS.Account_Name__c=a.ID;
        accountSSDSCS.Account_Inactive__c=false;
        accountSSDSCS.LCRM_Sales_Org__c='WEST';
        ssdlist.add(accountSSDSCS);
        
        Source_System_Detail__c accountSSDRisk=APTS_TestDataFactory.createSourceSystem(a);
        accountSSDRisk.RecordtypeId=ssdRecorType;
        accountSSDRisk.Account_Inactive__c=false;
        accountSSDRisk.Name='ABCSCS';
        accountSSDRisk.Source_System_Name__c='ABC';
        accountSSDRisk.Account_Name__c=a.ID;
        accountSSDRisk.Account_Inactive__c=false;
        accountSSDRisk.LCRM_Sales_Org__c='SMGE';
        ssdlist.add(accountSSDRisk);
        
        insert ssdlist;

        
        Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        
        List<Opportunity> optylist = new List<Opportunity>();
        Opportunity oppty=APTS_TestDataFactory.createOpportunity('Test Opty',a.id,'10%',Date.Today());
        oppty.RecordtypeId=opptyRecorType;
        oppty.Source_System_Detail__c=accountSSD.id;
        oppty.Account=a;
        optylist.add(oppty);
        
        Opportunity opptySCS=APTS_TestDataFactory.createOpportunity('Test OptySCS',a.id,'10%',Date.Today());
        opptySCS.RecordtypeId=opptyRecorType;
        opptySCS.Source_System_Detail__c=accountSSDSCS.id;
        opptySCS.Account=a;
        optylist.add(opptySCS);        
        
        Opportunity opptyRisk=APTS_TestDataFactory.createOpportunity('Test OptyRisk',a.id,'10%',Date.Today());
        opptyRisk.RecordtypeId=opptyRecorType;
        opptyRisk.Source_System_Detail__c=accountSSDRisk.id;
        opptyRisk.Account=a;
        optylist.add(opptyRisk);        
        
        insert optylist;
        
        List<Apttus_Proposal__Proposal__c> proposallist = new List<Apttus_Proposal__Proposal__c >();        
        
        
        Apttus_Proposal__Proposal__c proposal = new Apttus_Proposal__Proposal__c();
        proposal.APTS_Proposal_Business_Unit__c = 'Tax Professional';
        proposal.Apttus_Proposal__Account__c=a.id;
        proposal.Apttus_Proposal__Opportunity__c=oppty.id;
        proposallist.add(proposal);
        
        Apttus_Proposal__Proposal__c proposalSCS = new Apttus_Proposal__Proposal__c();
        proposalSCS.APTS_Proposal_Business_Unit__c = 'SCS';
        proposalSCS.Apttus_Proposal__Account__c=a.id;
        proposalSCS.Apttus_Proposal__Opportunity__c=opptySCS.id;
        proposallist.add(proposalSCS);
        
        Apttus_Proposal__Proposal__c proposalRisk = new Apttus_Proposal__Proposal__c();
        proposalRisk.APTS_Proposal_Business_Unit__c = 'SMGE';
        proposalRisk.Apttus_Proposal__Account__c=a.id;
        proposalRisk.Apttus_Proposal__Opportunity__c=opptyRisk.id;
        proposallist.add(proposalRisk);

        Insert proposallist;
       
        List<Apttus_Config2__ProductConfiguration__c> prodConfiglist = new List<Apttus_Config2__ProductConfiguration__c>();
        
        Apttus_Config2__ProductConfiguration__c prodConfig = APTS_TestDataFactory.createProductConfiguration(proposal.Id);
        prodConfig.Apttus_Config2__BusinessObjectId__c = proposal.Id;
        prodConfig.Apttus_Config2__BusinessObjectType__c = 'Proposal';
        prodConfig.APTS_SSD_bill_to__c = accountSSD.Id;
        prodConfig.APTS_SSD_ship_to__c = accountSSD.Id;
        prodConfig.Apttus_Config2__AccountId__c = a.Id;
        prodConfig.Apttus_Config2__PriceListId__c = priceList.Id;
        prodConfig.Apttus_Config2__Status__c = 'New';
        prodConfiglist.add(prodConfig);
        
        Apttus_Config2__ProductConfiguration__c prodConfigSCS = APTS_TestDataFactory.createProductConfiguration(proposalSCS.Id);
        prodConfigSCS.Apttus_Config2__BusinessObjectId__c = proposalSCS.Id;
        prodConfigSCS.Apttus_Config2__BusinessObjectType__c = 'Proposal';
        prodConfigSCS.APTS_SSD_bill_to__c = accountSSDSCS.Id;
        prodConfigSCS.APTS_SSD_ship_to__c = accountSSDSCS.Id;
        prodConfigSCS.Apttus_Config2__AccountId__c = a.Id;
        prodConfigSCS.Apttus_Config2__PriceListId__c = priceList.Id;
        prodConfigSCS.Apttus_Config2__Status__c = 'New';
        prodConfiglist.add(prodConfigSCS);
        
        //Added
        Apttus_Config2__ProductConfiguration__c prodConfigRisk = APTS_TestDataFactory.createProductConfiguration(proposalRisk.Id);
        prodConfigRisk.Apttus_Config2__BusinessObjectId__c = proposalRisk.Id;
        prodConfigRisk.Apttus_Config2__BusinessObjectType__c = 'Proposal';
        prodConfigRisk.APTS_SSD_bill_to__c = accountSSDRisk.Id;
        prodConfigRisk.APTS_SSD_ship_to__c = accountSSDRisk.Id;
        prodConfigRisk.Apttus_Config2__AccountId__c = a.Id;
        prodConfigRisk.Apttus_Config2__PriceListId__c = priceList.Id;
        prodConfigRisk.Apttus_Config2__Status__c = 'New';
        prodConfiglist.add(prodConfigRisk);

        insert prodConfiglist;
      
      
          List<Apttus_Proposal__Proposal_Line_Item__c> lineItemList1 = new List<Apttus_Proposal__Proposal_Line_Item__c>();
          Apttus_Proposal__Proposal_Line_Item__c plItem2 = new Apttus_Proposal__Proposal_Line_Item__c(          
          Apttus_Proposal__Quantity__c=1,
          APTS_Proposal_Business_Unit__c ='Tax Professional',          
          APTS_Contract_Term__c = '3 Years',
          Apttus_QPConfig__PriceType__c='Recurring',
          Apttus_QPConfig__ChargeType__c='Subscription fee',
          Apttus_QPConfig__ConfigurationId__c = prodConfig.id, 
          Apttus_QPConfig__LineType__c = 'Product/Service',
          Apttus_QPConfig__LineNumber__c = 1,          
          Apttus_QPConfig__NetPrice__c=1,
          Apttus_QPConfig__NetUnitPrice__c=1,
          Apttus_QPConfig__LineStatus__c = 'New',
          Apttus_QPConfig__BillingFrequency__c = 'Yearly',
          Apttus_Proposal__Proposal__c=proposallist[0].id);
          lineItemList1.add(plItem2);
          
          Apttus_Proposal__Proposal_Line_Item__c plItem3 = new Apttus_Proposal__Proposal_Line_Item__c(          
          Apttus_Proposal__Quantity__c=1,
          APTS_Proposal_Business_Unit__c ='Tax Professional',          
          APTS_Contract_Term__c = '3 Years',
          Apttus_QPConfig__PriceType__c='Recurring',
          Apttus_QPConfig__ChargeType__c='Subscription fee',
          Apttus_QPConfig__ConfigurationId__c = prodConfig.id, 
          Apttus_QPConfig__LineType__c = 'Product/Service',
          Apttus_QPConfig__LineNumber__c = 1,          
          Apttus_QPConfig__NetPrice__c=1,
          Apttus_QPConfig__NetUnitPrice__c=1,
          Apttus_QPConfig__LineStatus__c = 'New',
          Apttus_QPConfig__BillingFrequency__c = 'Monthly',
          Apttus_Proposal__Proposal__c=proposallist[0].id);
          lineItemList1.add(plItem3);
          
          Apttus_Proposal__Proposal_Line_Item__c plItem4 = new Apttus_Proposal__Proposal_Line_Item__c(          
          Apttus_Proposal__Quantity__c=1,
          APTS_Proposal_Business_Unit__c ='Tax Professional',          
          APTS_Contract_Term__c = '3 Years',
          Apttus_QPConfig__PriceType__c='OneTime',
          Apttus_QPConfig__ChargeType__c='Subscription fee',
          Apttus_QPConfig__ConfigurationId__c = prodConfig.id, 
          Apttus_QPConfig__LineType__c = 'Product/Service',
          Apttus_QPConfig__LineNumber__c = 1,          
          Apttus_QPConfig__NetPrice__c=1,
          Apttus_QPConfig__NetUnitPrice__c=1,
          Apttus_QPConfig__LineStatus__c = 'New',
          Apttus_QPConfig__BillingFrequency__c = 'Yearly',
          Apttus_Proposal__Proposal__c=proposallist[0].id);
          lineItemList1.add(plItem4);
          
          
          Apttus_Proposal__Proposal_Line_Item__c plItem5 = new Apttus_Proposal__Proposal_Line_Item__c(          
          Apttus_Proposal__Quantity__c=1,
          APTS_Proposal_Business_Unit__c ='Tax Professional',          
          APTS_Contract_Term__c = '3 Years',
          Apttus_QPConfig__PriceType__c='OneTime',
          Apttus_QPConfig__ChargeType__c='Standard Price',
          Apttus_QPConfig__ConfigurationId__c = prodConfig.id, 
          Apttus_QPConfig__LineType__c = 'Product/Service',
          Apttus_QPConfig__LineNumber__c = 1,          
          Apttus_QPConfig__NetPrice__c=1,
          Apttus_QPConfig__NetUnitPrice__c=1,
          Apttus_QPConfig__LineStatus__c = 'New',
          //Apttus_QPConfig__BillingFrequency__c = 'Yearly',
          Apttus_Proposal__Proposal__c=proposallist[0].id);
          lineItemList1.add(plItem5);
          
          Apttus_Proposal__Proposal_Line_Item__c plItem6 = new Apttus_Proposal__Proposal_Line_Item__c(          
          Apttus_Proposal__Quantity__c=1,
          APTS_Proposal_Business_Unit__c ='Tax Professional',          
          APTS_Contract_Term__c = '3 Years',
          Apttus_QPConfig__PriceType__c='Recurring',
          Apttus_QPConfig__ChargeType__c='Subscription fee',
          Apttus_QPConfig__ConfigurationId__c = prodConfig.id, 
          Apttus_QPConfig__LineType__c = 'Product/Service',
          Apttus_QPConfig__LineNumber__c = 1,          
          Apttus_QPConfig__NetPrice__c=1,
          Apttus_QPConfig__NetUnitPrice__c=1,
          Apttus_QPConfig__LineStatus__c = 'Renewed',
          Apttus_QPConfig__BillingFrequency__c = 'Yearly',
          Apttus_Proposal__Proposal__c=proposallist[0].id);
          lineItemList1.add(plItem6);
          
          Apttus_Proposal__Proposal_Line_Item__c plItem7 = new Apttus_Proposal__Proposal_Line_Item__c(          
          Apttus_Proposal__Quantity__c=1,
          APTS_Proposal_Business_Unit__c ='Tax Professional',          
          APTS_Contract_Term__c = '3 Years',
          Apttus_QPConfig__PriceType__c='Recurring',
          Apttus_QPConfig__ChargeType__c='Subscription fee',
          Apttus_QPConfig__ConfigurationId__c = prodConfig.id, 
          Apttus_QPConfig__LineType__c = 'Product/Service',
          Apttus_QPConfig__LineNumber__c = 1,          
          Apttus_QPConfig__NetPrice__c=1,
          Apttus_QPConfig__NetUnitPrice__c=1,
          Apttus_QPConfig__LineStatus__c = 'Renewed',
          Apttus_QPConfig__BillingFrequency__c = 'Monthly',
          Apttus_Proposal__Proposal__c=proposallist[0].id);
          lineItemList1.add(plItem7);
          
          Apttus_Proposal__Proposal_Line_Item__c plItem8 = new Apttus_Proposal__Proposal_Line_Item__c(          
          Apttus_Proposal__Quantity__c=1,
          APTS_Proposal_Business_Unit__c ='Tax Professional',          
          APTS_Contract_Term__c = '3 Years',
          Apttus_QPConfig__PriceType__c='Recurring',
          Apttus_QPConfig__ChargeType__c='Subscription fee',
          Apttus_QPConfig__ConfigurationId__c = prodConfig.id, 
          Apttus_QPConfig__LineType__c = 'Product/Service',
          Apttus_QPConfig__LineNumber__c = 1,          
          Apttus_QPConfig__NetPrice__c=1,
          Apttus_QPConfig__NetUnitPrice__c=1,
          Apttus_QPConfig__LineStatus__c = 'Amended',
          Apttus_QPConfig__BillingFrequency__c = 'Monthly',
          Apttus_Proposal__Proposal__c=proposallist[0].id);
          lineItemList1.add(plItem8);
          
          Apttus_Proposal__Proposal_Line_Item__c plItem9 = new Apttus_Proposal__Proposal_Line_Item__c(          
          Apttus_Proposal__Quantity__c=1,
          APTS_Proposal_Business_Unit__c ='Tax Professional',          
          APTS_Contract_Term__c = '3 Years',
          Apttus_QPConfig__PriceType__c='Recurring',
          Apttus_QPConfig__ChargeType__c='Subscription fee',
          Apttus_QPConfig__ConfigurationId__c = prodConfig.id, 
          Apttus_QPConfig__LineType__c = 'Product/Service',
          Apttus_QPConfig__LineNumber__c = 1,          
          Apttus_QPConfig__NetPrice__c=1,
          Apttus_QPConfig__NetUnitPrice__c=1,
          Apttus_QPConfig__LineStatus__c = 'Amended',
          Apttus_QPConfig__BillingFrequency__c = 'Yearly',
          Apttus_Proposal__Proposal__c=proposallist[0].id);
          lineItemList1.add(plItem9);
          
          Apttus_Proposal__Proposal_Line_Item__c plItem10 = new Apttus_Proposal__Proposal_Line_Item__c(          
          Apttus_Proposal__Quantity__c=1,
          APTS_Proposal_Business_Unit__c ='Tax Professional',          
          APTS_Contract_Term__c = '3 Years',
          Apttus_QPConfig__PriceType__c='Recurring',
          Apttus_QPConfig__ChargeType__c='Subscription fee',
          Apttus_QPConfig__ConfigurationId__c = prodConfig.id, 
          Apttus_QPConfig__LineType__c = 'Product/Service',
          Apttus_QPConfig__LineNumber__c = 1,          
          Apttus_QPConfig__NetPrice__c=1,
          Apttus_QPConfig__NetUnitPrice__c=1,
          Apttus_QPConfig__LineStatus__c = 'New',
          APTS_Term_Type__c = 'Co-Term',
          Apttus_QPConfig__BillingFrequency__c = 'Yearly',
          Apttus_Proposal__Proposal__c=proposallist[0].id);
          lineItemList1.add(plItem10);
          
          Apttus_Proposal__Proposal_Line_Item__c plItem11 = new Apttus_Proposal__Proposal_Line_Item__c(          
          Apttus_Proposal__Quantity__c=1,
          APTS_Proposal_Business_Unit__c ='SCS',          
          APTS_Contract_Term__c = '3 Years',
          Apttus_QPConfig__PriceType__c='Recurring',
          Apttus_QPConfig__ChargeType__c='Subscription fee',
          Apttus_QPConfig__ConfigurationId__c = prodConfigSCS.id, 
          Apttus_QPConfig__LineType__c = 'Product/Service',
          Apttus_QPConfig__LineNumber__c = 1,          
          Apttus_QPConfig__NetPrice__c=1,
          Apttus_QPConfig__NetUnitPrice__c=1,
          Apttus_QPConfig__LineStatus__c = 'New',
          APTS_Media_High_Level_Code__c = '05',
          APTS_Media_Lower_Level_Code__c = 'E9',          
          Apttus_Proposal__Proposal__c=proposallist[0].id);
          lineItemList1.add(plItem11);
          
          Apttus_Proposal__Proposal_Line_Item__c plItem12 = new Apttus_Proposal__Proposal_Line_Item__c(          
          Apttus_Proposal__Quantity__c=1,
          APTS_Proposal_Business_Unit__c ='SCS',          
          APTS_Contract_Term__c = '3 Years',
          Apttus_QPConfig__PriceType__c='Recurring',
          Apttus_QPConfig__ChargeType__c='Subscription fee',
          Apttus_QPConfig__ConfigurationId__c = prodConfigSCS.id, 
          Apttus_QPConfig__LineType__c = 'Product/Service',
          Apttus_QPConfig__LineNumber__c = 1,          
          Apttus_QPConfig__NetPrice__c=1,
          Apttus_QPConfig__NetUnitPrice__c=1,
          Apttus_QPConfig__LineStatus__c = 'New',
          APTS_Media_High_Level_Code__c = '05',
          APTS_Media_Lower_Level_Code__c = 'NZ',          
          Apttus_Proposal__Proposal__c=proposallist[0].id);
          lineItemList1.add(plItem12);
          
          Apttus_Proposal__Proposal_Line_Item__c plItem13 = new Apttus_Proposal__Proposal_Line_Item__c(          
          Apttus_Proposal__Quantity__c=1,
          APTS_Proposal_Business_Unit__c ='SCS',          
          APTS_Contract_Term__c = '3 Years',
          Apttus_QPConfig__PriceType__c='One Time',
          Apttus_QPConfig__ChargeType__c='Standard Price',
          Apttus_QPConfig__ConfigurationId__c = prodConfigSCS.id, 
          Apttus_QPConfig__LineType__c = 'Product/Service',
          Apttus_QPConfig__LineNumber__c = 1,          
          Apttus_QPConfig__NetPrice__c=1,
          Apttus_QPConfig__NetUnitPrice__c=1,
          Apttus_QPConfig__LineStatus__c = 'New',
          APTS_Media_High_Level_Code__c = '05',
          APTS_Media_Lower_Level_Code__c = '',         
          Apttus_Proposal__Proposal__c=proposallist[0].id);
          lineItemList1.add(plItem13);       
          
          //Added
          Apttus_Proposal__Proposal_Line_Item__c plItem14 = new Apttus_Proposal__Proposal_Line_Item__c(          
          Apttus_Proposal__Quantity__c=1,
          APTS_Proposal_Business_Unit__c ='SMGE',          
          APTS_Contract_Term__c = '3 Years',
          Apttus_QPConfig__PriceType__c='Recurring',
          Apttus_QPConfig__ChargeType__c='Subscription fee',
          Apttus_QPConfig__ConfigurationId__c = prodConfigRisk.id, 
          Apttus_QPConfig__LineType__c = 'Product/Service',
          Apttus_QPConfig__LineNumber__c = 1,          
          Apttus_QPConfig__NetPrice__c=1,
          Apttus_QPConfig__NetUnitPrice__c=1,
          Apttus_QPConfig__LineStatus__c = 'New',
          APTS_Media_High_Level_Code__c = '05',
          APTS_Media_Lower_Level_Code__c = 'E9',         
          Apttus_Proposal__Proposal__c=proposallist[0].id);
          lineItemList1.add(plItem14);   
          insert lineItemList1;
                 
          test.starttest();
          System.debug('$$$$$$$'+lineItemList1);  
          System.debug('$$$$$$$'+proposalList);
          APTS_Tax_ProposalTriggerHelper.templateFieldUpdate(proposal.id);
          test.stoptest();
    }
  
}