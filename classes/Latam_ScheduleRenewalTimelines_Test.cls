@isTest
private class Latam_ScheduleRenewalTimelines_Test {
    private static testMethod void schedulerTest2_Canada() {
        String CRON_EXP = '0 0 0 15 3 ? *';
        
        // Create your test data
        KeyValueListStore__c keyvaluestore=new  KeyValueListStore__c();
        keyvaluestore.Name='ANZUsersProfileId';
        keyvaluestore.TextValue__c='00e30000001ZUki';
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
        
        Account a1 = APTS_TestDataFactory.createAccount('Testing Account');       
        insert a1;
        system.debug('@@@@@@@@Account'+a1);        
        
        Contact cont=APTS_TestDataFactory.createContact('LastName',a1.id);
        cont.FirstName='FirstName';
        cont.Email='abc@gmail.com';
        cont.Phone='1234567890';
        insert cont;
        system.debug('@@@@@@@@Contact'+cont);
        
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();
        Source_System_Detail__c accountSSD= new Source_System_Detail__c();
        accountSSD.RecordtypeId=ssdRecorType;
        accountSSD.Name='ABC';
        accountSSD.Source_System_Name__c='ABC';
        accountSSD.Account_Name__c=a1.ID;
        accountSSD.Account_Inactive__c=false;
        accountSSD.LCRM_Sales_Org__c='BEJE';
        insert accountSSD;
        
        Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        Opportunity oppty=APTS_TestDataFactory.createOpportunity('abc',a1.id,'Needs Analysis',Date.Today());
        oppty.RecordtypeId=opptyRecorType;
        oppty.Source_System_Detail__c=accountSSD.id;
        oppty.Email__c='abc@tcs.com';
        oppty.Account=a1;
        insert oppty;
        
        Apttus_Config2__PriceList__c pl= APTS_TestDataFactory.createPriceList('Thomson Reuters Master - Canada');
        insert pl;
        
        List<Product2> productList =new List<Product2>();        
        Product2 productRec1= APTS_TestDataFactory.createProduct('Test Product1', null);
        productRec1.APTS_Media_High_Level_Code__c ='06';
        productList.add(productRec1);
        Product2 productRec2= APTS_TestDataFactory.createProduct('Test Product2', null);
        productList.add(productRec2);
        insert productList;
        
        List<Apttus_Config2__PriceListItem__c> ListPli= new  List<Apttus_Config2__PriceListItem__c>();        
        Apttus_Config2__PriceListItem__c pli= new Apttus_Config2__PriceListItem__c();
        pli.Apttus_Config2__PriceListId__c=pl.id;
        pli.Apttus_Config2__ProductId__c=productRec1.id;
        pli.Apttus_Config2__ListPrice__c=200;
        ListPli.add(pli);
        
        Apttus_Config2__PriceListItem__c pli1= new Apttus_Config2__PriceListItem__c();
        pli1.Apttus_Config2__PriceListId__c=pl.id;
        pli1.Apttus_Config2__ProductId__c=productRec2.id;
        pli1.Apttus_Config2__ListPrice__c=200;
        ListPli.add(pli1);        
        insert ListPli;
        
        Id propRecorType=Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Proposal').getRecordTypeId();
        system.debug('$$$$$$$'+accountSSD);
        Apttus_Proposal__Proposal__c proposal = APTS_TestDataFactory.createProposal(oppty.id,a1.Id);
        proposal.Apttus_Proposal__Approval_Stage__c='Draft';
        proposal.Apttus_Proposal__Account__c = a1.Id;
        proposal.APTS_Proposal_Business_Unit__c='Canada';
        proposal.RecordtypeId = propRecorType;
        proposal.Apttus_Proposal__Opportunity__c = oppty.id;
        proposal.APTS_SSD_Sold_To__c = accountSSD.Id;
        proposal.Apttus_Proposal__Account__c = a1.Id;
        proposal.Apttus_Proposal__Primary__c = true;                    
        insert proposal; 
        
        Apttus_Config2__ProductConfiguration__c pcon=new Apttus_Config2__ProductConfiguration__c (Apttus_QPConfig__Proposald__c =proposal.id);
        insert pcon;
        
        List<Apttus_Config2__AssetLineItem__c> listOfAssetLineItems = new List<Apttus_Config2__AssetLineItem__c>();        
        Apttus_Config2__AssetLineItem__c asli1 = new Apttus_Config2__AssetLineItem__c();                
        asli1 .Name='Test_Canada_1';
        asli1.Apttus_Config2__AssetStatus__c='Activated';
        asli1.APTS_Proposal_Business_Unit__c='Canada';
        asli1.Apttus_QPConfig__ProposalId__c=proposal.id;
        asli1.Apttus_Config2__AccountId__c=a1.id; 
        asli1.Apttus_Config2__EndDate__c = date.today()+5;
        asli1.Apttus_Config2__ProductId__c = productRec1.Id;
        listOfAssetLineItems.add(asli1);        
        
        Apttus_Config2__AssetLineItem__c asli2 = new Apttus_Config2__AssetLineItem__c();                
        asli2 .Name='Canada ProFlex';
        asli2 .Apttus_QPConfig__ProposalId__c=proposal.id;        
        asli2.Apttus_Config2__AssetStatus__c='Activated';
        asli2.APTS_Proposal_Business_Unit__c='Canada';
        asli2.Apttus_Config2__AccountId__c=a1.Id;            
        asli2.Apttus_Config2__EndDate__c = date.today()+5;        
        listOfAssetLineItems.add(asli2);        
        insert listOfAssetLineItems;
        
        Test.startTest();
        
        String jobId =System.schedule('ScheduleApexClassTest',  CRON_EXP, new Latam_ScheduleRenewalBAtchForTimelines());
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];
        System.assertEquals(CRON_EXP, ct.CronExpression);
        System.assertEquals(0, ct.TimesTriggered);
        
        Test.stopTest();        
    }
}