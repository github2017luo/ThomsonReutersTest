/**
* Test Class for 'LCRM_Update_Source_Oppty_For_Pro_Data_Type' Process Builder
*
*/

/**
* CHANGE HISTORY
* =============================================================================
* Date         Name                    Description
* 2020-07-07   Miriam Ghosh            Created     
* =============================================================================
*/

@isTest
public class LCRMUpdateSourceOpptyForProDataType_Test {
    
    public static testmethod void updateopptyforprodatattypeTest(){
    
        Test.startTest();
        
        List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c='00e30000001ZUki'),
        new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other'),
        new KeyValueListStore__c(Name='LCRMDisableStrikeIronServices',TextValue__c='True')};
        insert keyvaluestore;
    
    
        RecordtypeIds__c recT= new RecordtypeIds__c();
        recT.name= 'Pre-Pipeline Opportunities';
        recT.recTypeId__C = '012a0000001ZJxn';        
        insert recT;
    
        RecordtypeIds__c recT1= new RecordtypeIds__c();
        recT1.Name= 'Pipeline Opportunities';
        recT1.recTypeId__C = '012a0000001ZJxn';
        insert recT1;
    
        RecordtypeIds__c recT2= new RecordtypeIds__c();
        recT2.Name= 'LATAM Renewal Opportunity';
        recT2.recTypeId__C = '012a0000001ZJxn';
        insert recT2;        
    
        RecordtypeIds__c orecordType4 = new RecordtypeIds__c ();
        orecordType4.name ='Customer';
        orecordType4.recTypeId__c = '01230000001MA4a';
        insert orecordType4;
    
        Id pricebookId = Test.getStandardPricebookId();
    
        Pricebook2 pb = new Pricebook2();
        pb.IsActive =true;
        pb.Name ='Price Book';
        insert pb;
    
        Product2 pr = new Product2();
        pr.Name ='Product';
        insert pr;
    
        PricebookEntry spe = new PricebookEntry ();
        spe.IsActive=true;
        spe.Pricebook2Id=pricebookId;
        spe.Product2Id=pr.Id;
        spe.UnitPrice =0;
        insert spe;            
    
        PricebookEntry pe = new PricebookEntry ();
        pe.IsActive=true;
        pe.Pricebook2Id=pb.Id;
        pe.Product2Id=pr.Id;
        pe.UnitPrice =10;
        insert pe;   
        
        LTS_Disable_Application_Automation__c ltstemp = new LTS_Disable_Application_Automation__c();
        ltstemp.LTS_Disable_Process_Builders__c = false;
        ltstemp.LTS_Disable_Triggers__c = true;
        ltstemp.LTS_Disable_Validation_Rules__c = true;
        ltstemp.LTS_Disable_Workflow_Rules__c = true;
        ltstemp.Name = 'temp';
        ltstemp.SetupOwnerId = userinfo.getuserid();
        insert ltstemp;
    
       
        Account testAcc = new Account();
        //testAcc = UnitTest.getAccountInstance();
        testAcc.SAPAccountNumber__c = '1004879124';  
        testAcc.Is_GLI__c = true;
        testAcc.Name = 'Test Account123';
        insert testAcc;  
    
        //Contact testcontact= UnitTest.getContactInstance(testAcc.Id);
        Contact testcontact = new Contact();
        testcontact.AccountId = testAcc.id;
        testcontact.LastName = 'testContact';
        testcontact.FirstName = 'testContact';
        testcontact.AccountId = testAcc.Id;
        testcontact.email = 'testfirst.testlast@thomson.com';
        testcontact.Work_Direct__c= '1234567891';
        insert testcontact;    
    
        Opportunity testOpp1 = UnitTest.getOpportunityInstance(testacc.Id);
        testOpp1.AccountId = testAcc.id;
        testOpp1.Renewal_Flag__c = true;
        testOpp1.Selling_Organization__c = 'LRA';
        testopp1.Pricebook2Id = pb.Id;
        testopp1.stageName= '10%';
        testopp1.CurrencyIsoCode='USD';
        testopp1.LCRM_Sub_BU__c = 'UKI';
        testopp1.ContactId = testcontact.id;
        testopp1.Expected_Revenue_Date__c = System.today().adddays(1);
        testopp1.Expiration_Date__c = System.today().adddays(7);
        testopp1.Is_GLI__c = true;
        insert testOpp1;
        
        Opportunity oppty1 = [select id, isclosed, is_gli__c, Renewal_Flag__c, LCRM_Target_Opportunity__c from opportunity where id = : testOpp1.Id ];
    	system.debug('opportunity oppty1'+oppty1);
        
        OpportunityLineItem oli = new OpportunityLineItem();
        oli.OpportunityId = testOpp1.Id;
        oli.Quantity = 1;
        oli.List_Price__c = 100;
        oli.PricebookEntryId =pe.Id;
        oli.MOLI_id__c='1111';
        insert oli;
    
        Opportunity testOpp2 = UnitTest.getOpportunityInstance(testacc.Id);
        //Opportunity testOpp2 = new Opportunity();
        testOpp2.AccountId = testAcc.Id;
        testOpp2.Renewal_Flag__c = true;
        testOpp2.Selling_Organization__c = 'LRA';
        testopp1.Pricebook2Id = pb.Id;
        testOpp2.stageName= '10%';
        testOpp2.Master_Opportunity__c = testOpp1.Id;
        testopp2.CurrencyIsoCode='ARS';
        testopp2.LCRM_Sub_BU__c = 'UKI';
        testopp2.LCRM_Target_Opportunity__c = testOpp1.Id;
        testopp2.Expected_Revenue_Date__c = System.today().adddays(1);
        testopp2.Expiration_Date__c = System.today().adddays(7);
        testopp2.Is_GLI__c = true;
        insert testOpp2; 
        
        testopp1.Expiration_Date__c = Date.today()+5;
        testopp1.LCRM_Transaction_Type__c = 'Pro-Rata';
        update testopp1;
        
        Opportunity oppty2 = [select id, isclosed, is_gli__c, Renewal_Flag__c, LCRM_Target_Opportunity__c from opportunity where id = : testOpp2.Id ];
    	system.debug('opportunity oppty2'+oppty2);
        
        Test.stopTest();

    }

}