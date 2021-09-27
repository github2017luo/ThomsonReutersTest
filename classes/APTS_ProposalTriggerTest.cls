@isTest 
private class APTS_ProposalTriggerTest {
    public static final string USL_RECORDTPYE='USL_Source_Systems';   
    
   // This test method tests the condition of a new proposal without a price list. The priceListUpdate Trigger is supposed to populate the price list with 'Thomson Reuters Master - US Legal'
    /*static testMethod void validatePriceListUpdateWithNoPriceList() {
       Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
       Account a = new Account(RecordTypeId=accRecordTypeId,name='test-sg',sales_org__c='ABEP',customer_group__c='Academic',customer_type__c='Organization',customer_class_c__c='Academic Lecturer');
       insert a;
       
       Date todaysDate = system.today();
       Id oppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
       Opportunity o = new Opportunity(RecordTypeId=oppRecordTypeId,  Name='tst-opp', stagename='25%',closedate=todaysDate,forecastcategoryname='Omitted',accountId=a.id);
       insert o;
              
       Id devRecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Proposal').getRecordTypeId();
       Apttus_Proposal__Proposal__c p = new Apttus_Proposal__Proposal__c(RecordTypeId=devRecordTypeId, Apttus_Proposal__Proposal_Name__c='TST-10', CurrencyIsoCode='USD', Apttus_Proposal__Opportunity__c=o.id, Apttus_Proposal__Approval_Stage__c='Draft', Apttus_Proposal__Proposal_Category__c='Quote', Apttus_Proposal__ReadyToGenerate__c = true, Apttus_Proposal__ReadyToPresent__c= true);
       System.debug('PriceList before inserting new proposal: ' + p.Apttus_QPConfig__PriceListId__c);

       insert p;
       
       Apttus_Config2__PriceList__c priceListObj = new Apttus_Config2__PriceList__c();
       priceListObj.Name = 'Thomson Reuters Master - US Legal';
       insert priceListObj;       
    
       // Retrieve the new proposal
       p = [SELECT Apttus_QPConfig__PriceListId__c FROM Apttus_Proposal__Proposal__c WHERE Id =:p.Id];
       System.debug('PriceList after trigger fired: ' + p.Apttus_QPConfig__PriceListId__c);

       // Test that the trigger correctly updated the pricelist
       Apttus_Config2__PriceList__c PriceList;
       PriceList = [SELECT Id FROM Apttus_Config2__PriceList__c WHERE Name = 'Thomson Reuters Master - US Legal' limit 1];       
       System.assertEquals(PriceList.id, p.Apttus_QPConfig__PriceListId__c);
    }*/
    
    
    // This test method tests the condition of a new proposal with a price list. The priceListUpdate Trigger is not supposed to change the price list.
    static testMethod void validatePriceListUpdateWithPriceList() {
    
        

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
        
       Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
       Account a = new Account(RecordTypeId=accRecordTypeId,name='test-sg',sales_org__c='ABEP',customer_group__c='Academic',customer_type__c='Organization',customer_class_c__c='Academic Lecturer');
       insert a;
       System.assertequals('test-sg',a.Name,'Success');
        Id accRecordTypeIdSSD=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByDeveloperName().get(USL_RECORDTPYE).getRecordTypeId();
        Source_System_Detail__c accountSSD= new Source_System_Detail__c();
        accountSSD.Name='ABC';
        accountSSD.Source_System_Name__c='ABC';
        accountSSD.Account_Name__c=a.ID;
        accountSSD.LCRM_Customer_Group__c='Academic';
        accountSSD.Account_Inactive__c=false;
        accountSSD.LCRM_Sales_Org__c='WEST';
        insert accountSSD;
       
       Date todaysDate = system.today();
       Id oppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
       Opportunity o = new Opportunity(RecordTypeId=oppRecordTypeId, Name='tst-opp', stagename='25%',closedate=todaysDate,forecastcategoryname='Omitted',accountId=a.id,Source_System_Detail__c=accountSSD.Id);
       insert o;
       
       Apttus_Config2__PriceList__c pl =new Apttus_Config2__PriceList__c(name='tst-pl', apttus_config2__active__c=true);
       insert pl;

       Id devRecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Proposal').getRecordTypeId();
       Apttus_Proposal__Proposal__c p = new Apttus_Proposal__Proposal__c(RecordTypeId=devRecordTypeId, Apttus_Proposal__Proposal_Name__c='TST-10', Apttus_Proposal__Account__c =a.id,APTS_SSD_Sold_To__c = accountSSD.Id, Apttus_Proposal__Opportunity__c=o.id, Apttus_Proposal__Approval_Stage__c='Draft', Apttus_Proposal__Proposal_Category__c='Quote', Apttus_Proposal__ReadyToGenerate__c = true, Apttus_Proposal__ReadyToPresent__c= true, Apttus_QPConfig__PriceListId__c=pl.id);
       System.debug('PriceList before inserting new proposal: ' + p.Apttus_QPConfig__PriceListId__c);

       // Insert proposal
       insert p;
    
       // Retrieve the new proposal
       Apttus_Proposal__Proposal__c proposal = [SELECT Apttus_QPConfig__PriceListId__c FROM Apttus_Proposal__Proposal__c WHERE Id =:p.Id];
       System.debug('PriceList after trigger fired: ' + proposal.Apttus_QPConfig__PriceListId__c);

       // Test that the trigger did not change the pricelist       
       System.assertEquals(p.Apttus_QPConfig__PriceListId__c, proposal.Apttus_QPConfig__PriceListId__c);
    }
    
    // This test method tests the condition of populating bill to and ship to with account info when they are null.
    static testMethod void validateNewBillToAndShipTo() {
    
        

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
       Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
       Account a = new Account(RecordTypeId=accRecordTypeId,name='test-sg',sales_org__c='ABEP',customer_group__c='Academic',customer_type__c='Organization',customer_class_c__c='Academic Lecturer');
       insert a;
       System.assertequals('test-sg',a.Name,'Success');
       
       Date todaysDate = system.today();
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByDeveloperName().get(USL_RECORDTPYE).getRecordTypeId();
         Source_System_Detail__c accountSSD=APTS_TestDataFactory.createSourceSystem(a);
        accountSSD.RecordtypeId=ssdRecorType;
        accountSSD.Account_Inactive__c=false;
        accountSSD.Name='ABC';
        accountSSD.Source_System_Name__c='ABC';
        accountSSD.Account_Name__c=a.ID;
        accountSSD.Account_Inactive__c=false;
        accountSSD.LCRM_Sales_Org__c='WEST';
        insert accountSSD;
       
       Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        Opportunity oppty=APTS_TestDataFactory.createOpportunity('Test Opty',a.id,'10%',Date.Today());
        oppty.RecordtypeId=opptyRecorType;
        oppty.Source_System_Detail__c=accountSSD.id;
        oppty.Account=a;
        insert oppty;
              

       Id devRecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Proposal').getRecordTypeId();
       Apttus_Proposal__Proposal__c p = new Apttus_Proposal__Proposal__c(RecordTypeId=devRecordTypeId, Apttus_Proposal__Proposal_Name__c='TST-10', Apttus_Proposal__Opportunity__c=oppty.id, Apttus_Proposal__Account__c=a.id,APTS_SSD_Sold_To__c = accountSSD.Id,APTS_SSD_bill_to__c= accountSSD.Id, APTS_SSD_ship_to__c= accountSSD.Id, Apttus_Proposal__Approval_Stage__c='Draft', Apttus_Proposal__Proposal_Category__c='Quote', Apttus_Proposal__ReadyToGenerate__c = true, Apttus_Proposal__ReadyToPresent__c= true);
       System.debug('Bill To before inserting new proposal: ' + p.APTS_SSD_bill_to__c);
       System.debug('Ship To before inserting new proposal: ' + p.APTS_SSD_ship_to__c);

       // Insert proposal
       insert p;
    
       // Retrieve the new proposal
       Apttus_Proposal__Proposal__c proposal = [SELECT APTS_SSD_bill_to__c, APTS_SSD_ship_to__c FROM Apttus_Proposal__Proposal__c WHERE Id =:p.Id];
       System.debug('Bill To before inserting new proposal: ' + proposal.APTS_SSD_bill_to__c);
       System.debug('Ship To before inserting new proposal: ' + proposal.APTS_SSD_ship_to__c);

       // Test that the trigger updated billTo and shipTo fields.
       System.assertEquals(accountSSD.id, proposal.APTS_SSD_bill_to__c);
       System.assertEquals(accountSSD.id, proposal.APTS_SSD_ship_to__c);
    }
    
    
    /*
    // This test method tests the condition of not overwriting bill to and ship to with account info when they are filled.
    static testMethod void validateExistingBillToAndShipTo() {
       Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
       Account a = new Account(RecordTypeId=accRecordTypeId,name='test-sg',sales_org__c='ABEP',customer_group__c='Academic',customer_type__c='Organization',customer_class_c__c='Academic Lecturer');
       insert a;

       Account a1 = new Account(RecordTypeId=accRecordTypeId,name='test-sg1',sales_org__c='ABEP',customer_group__c='Academic',customer_type__c='Organization',customer_class_c__c='Academic Lecturer');
       insert a1;
       
       Date todaysDate = system.today();
       Id oppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Pipeline Opportunity').getRecordTypeId();
       Opportunity o = new Opportunity(RecordTypeId=oppRecordTypeId, Name='tst-opp', stagename='25%',closedate=todaysDate,forecastcategoryname='Omitted',accountId=a.id);
       insert o;

       Id devRecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Proposal').getRecordTypeId();
       Apttus_Proposal__Proposal__c p = new Apttus_Proposal__Proposal__c(RecordTypeId=devRecordTypeId, Apttus_Proposal__Proposal_Name__c='TST-10', Apttus_Proposal__Opportunity__c=o.id, Apttus_Proposal__Account__c=a.id, Apttus_Proposal__Approval_Stage__c='Draft', Apttus_Proposal__Proposal_Category__c='Quote', Apttus_Proposal__ReadyToGenerate__c = true, Apttus_Proposal__ReadyToPresent__c= true, APTS_SSD_bill_to__c=a1.id, APTS_SSD_ship_to__c=a1.id);
       System.debug('Bill To before inserting new proposal: ' + p.APTS_SSD_bill_to__c);
       System.debug('Ship To before inserting new proposal: ' + p.APTS_SSD_ship_to__c);

       // Insert proposal
       insert p;
    
       // Retrieve the new proposal
       //Changed new ssd lookup fields instead of account lookup
       Apttus_Proposal__Proposal__c proposal = [SELECT APTS_SSD_bill_to__c, APTS_SSD_ship_to__c FROM Apttus_Proposal__Proposal__c WHERE Id =:p.Id];
       System.debug('Bill To after inserting new proposal: ' + proposal.APTS_SSD_bill_to__c);
       System.debug('Ship To after inserting new proposal: ' + proposal.APTS_SSD_ship_to__c);

       // Test that the trigger did not change billTo and shipTo fields.
       System.assertEquals(a1.id, proposal.APTS_SSD_bill_to__c);
       System.assertEquals(a1.id, proposal.APTS_SSD_ship_to__c);
    }
    */
    
    
    static testMethod void validateOpptyStageForGenProposals(){
    
        

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
       Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
       Account a = new Account(RecordTypeId=accRecordTypeId,name='test-sg',sales_org__c='ABEP',customer_group__c='Academic',customer_type__c='Organization',customer_class_c__c='Academic Lecturer');
       insert a;
       System.assertequals('test-sg',a.Name,'Success');
       Id accRecordTypeIdSSD=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByDeveloperName().get(USL_RECORDTPYE).getRecordTypeId();
       Source_System_Detail__c accountSSD= new Source_System_Detail__c();
        accountSSD.Name='ABC';
        accountSSD.Source_System_Name__c='ABC';
        accountSSD.Account_Name__c=a.ID;
        accountSSD.LCRM_Customer_Group__c='Academic';
        accountSSD.Account_Inactive__c=false;
        accountSSD.LCRM_Sales_Org__c='WEST';
        insert accountSSD;
       
       Date todaysDate = system.today();
       Id oppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
       Opportunity o = new Opportunity(RecordTypeId=oppRecordTypeId, Name='tst-opp', stagename='Appointment Scheduled',closedate=todaysDate,forecastcategoryname='Omitted',accountId=a.id,Source_System_Detail__c=accountSSD.Id);
       insert o;

       Id devRecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Proposal').getRecordTypeId();
       Apttus_Proposal__Proposal__c p = new Apttus_Proposal__Proposal__c(RecordTypeId=devRecordTypeId,Apttus_Proposal__Primary__c =true, Apttus_Proposal__Proposal_Name__c='TST-10', Apttus_Proposal__Opportunity__c=o.id, Apttus_Proposal__Account__c=a.id,APTS_SSD_Sold_To__c = accountSSD.Id, Apttus_Proposal__Approval_Stage__c='Draft', Apttus_Proposal__Proposal_Category__c='Quote', Apttus_Proposal__ReadyToGenerate__c = true, Apttus_Proposal__ReadyToPresent__c= true);

       // Insert proposal
       insert p;
       checkRecursive.propsaltrgr_updateOpportunityStage  = true;
       p.Apttus_Proposal__Approval_Stage__c = 'Generated';
       update p;
       
       Opportunity opp = [SELECT stagename FROM Opportunity WHERE id=:o.id];
       //System.assertEquals(opp.stagename, 'Generate Contract'); 
    }
    
    static testMethod void validateOpptyStageForPresentedProposals(){
    
    

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
        
       Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
       Account a = new Account(RecordTypeId=accRecordTypeId,name='test-sg',sales_org__c='ABEP',customer_group__c='Academic',customer_type__c='Organization',customer_class_c__c='Academic Lecturer');
       insert a;
       System.assertequals('test-sg',a.Name,'Success');
       Id accRecordTypeIdSSD=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByDeveloperName().get(USL_RECORDTPYE).getRecordTypeId();
       Source_System_Detail__c accountSSD= new Source_System_Detail__c();
        accountSSD.Name='ABC';
        accountSSD.Source_System_Name__c='ABC';
        accountSSD.Account_Name__c=a.ID;
        accountSSD.LCRM_Customer_Group__c='Academic';
        accountSSD.Account_Inactive__c=false;
        accountSSD.LCRM_Sales_Org__c='WEST';
        insert accountSSD;
       
       Date todaysDate = system.today();
       Id oppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
       Opportunity o = new Opportunity(RecordTypeId=oppRecordTypeId, Name='tst-opp', stagename='Appointment Scheduled',closedate=todaysDate,forecastcategoryname='Omitted',accountId=a.id,Source_System_Detail__c=accountSSD.Id);
       insert o;

       Id devRecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Proposal').getRecordTypeId();
       Apttus_Proposal__Proposal__c p = new Apttus_Proposal__Proposal__c(RecordTypeId=devRecordTypeId,Apttus_Proposal__Primary__c =true, Apttus_Proposal__Proposal_Name__c='TST-10', Apttus_Proposal__Opportunity__c=o.id, Apttus_Proposal__Account__c=a.id,APTS_SSD_Sold_To__c = accountSSD.Id, Apttus_Proposal__Approval_Stage__c='Draft', Apttus_Proposal__Proposal_Category__c='Quote', Apttus_Proposal__ReadyToGenerate__c = true, Apttus_Proposal__ReadyToPresent__c= true);

       // Insert proposal
       insert p;
       checkRecursive.propsaltrgr_updateOpportunityStage  = true; 
       p.Apttus_Proposal__Approval_Stage__c = 'Presented';
       update p;
       
       Opportunity opp1 = [SELECT stagename FROM Opportunity WHERE id=:o.id];
       //System.assertEquals(opp1.stagename, '90%'); 
    }
    
    
    static testMethod void validateOpptyStageForAcceptedProposals(){
    
    

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
        
       Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
       Account a = new Account(RecordTypeId=accRecordTypeId,name='test-sg',sales_org__c='ABEP',customer_group__c='Academic',customer_type__c='Organization',customer_class_c__c='Academic Lecturer');
       insert a;
       System.assertequals('test-sg',a.Name,'Success');
        Id accRecordTypeIdSSD=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByDeveloperName().get(USL_RECORDTPYE).getRecordTypeId();
        Source_System_Detail__c accountSSD= new Source_System_Detail__c();
        accountSSD.Name='ABC';
        accountSSD.Source_System_Name__c='ABC';
        accountSSD.Account_Name__c=a.ID;
        accountSSD.LCRM_Customer_Group__c='Academic';
        accountSSD.Account_Inactive__c=false;
        accountSSD.LCRM_Sales_Org__c='WEST';
        insert accountSSD;
       
       Date todaysDate = system.today();
       Id oppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
       Opportunity o = new Opportunity(RecordTypeId=oppRecordTypeId, Name='tst-opp', stagename='5%',closedate=todaysDate,forecastcategoryname='Omitted',accountId=a.id,Source_System_Detail__c=accountSSD.Id);
       insert o;

       Id devRecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Proposal').getRecordTypeId();
       Apttus_Proposal__Proposal__c p = new Apttus_Proposal__Proposal__c(RecordTypeId=devRecordTypeId,Apttus_Proposal__Primary__c =true, Apttus_Proposal__Proposal_Name__c='TST-10', Apttus_Proposal__Opportunity__c=o.id, Apttus_Proposal__Account__c=a.id,APTS_SSD_Sold_To__c = accountSSD.Id, Apttus_Proposal__Approval_Stage__c='Draft', Apttus_Proposal__Proposal_Category__c='Quote', Apttus_Proposal__ReadyToGenerate__c = true, Apttus_Proposal__ReadyToPresent__c= true);

       // Insert proposal
       insert p;    
         checkRecursive.propsaltrgr_updateOpportunityStage  = true;
       //p.Apttus_Proposal__Approval_Stage__c = '95%';
       test.startTest();        
       p.Apttus_Proposal__Approval_Stage__c ='Accepted';        
        update p;
        update p;
       test.stoptest();
              
       Opportunity opp2 = [SELECT stagename FROM Opportunity WHERE id=:o.id];
      // System.assertEquals(opp2.stagename, 'Contract Signed');  
    } 
    
    /*static testMethod void validateUpdateApprovalSegment(){
       Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
       Account a = new Account(RecordTypeId=accRecordTypeId,name='test-sg',sales_org__c='ABEP',customer_group__c='Academic',customer_type__c='Organization',customer_class_c__c='Academic Lecturer');
       insert a;
       
       Date todaysDate = system.today();
       Id oppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
       Opportunity o = new Opportunity(RecordTypeId=oppRecordTypeId, Name='tst-opp', stagename='5%',closedate=todaysDate,forecastcategoryname='Omitted',accountId=a.id);
       insert o;
       
       Profile profile = [SELECT Id FROM Profile WHERE Name='TR Legal FindLaw User'];
        
       User u1 = new User(Alias = 'standt1',Country='United Kingdom',Email='demo1@randomdemodomain.com',EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',LocaleSidKey='en_US',ProfileId = profile.Id,TimeZoneSidKey='America/Los_Angeles', UserName='dprobertdemo1@camfed.org');
       insert u1;

       System.runAs(u1){
           Id devRecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Proposal').getRecordTypeId();
           Apttus_Proposal__Proposal__c p = new Apttus_Proposal__Proposal__c(RecordTypeId=devRecordTypeId, Apttus_Proposal__Proposal_Name__c='TST-10', Apttus_Proposal__Opportunity__c=o.id, Apttus_Proposal__Account__c=a.id, Apttus_Proposal__Approval_Stage__c='Draft', Apttus_Proposal__Proposal_Category__c='Quote', Apttus_Proposal__ReadyToGenerate__c = true, Apttus_Proposal__ReadyToPresent__c= true);
           System.debug('Approval segment before inserting new proposal: ' + p.APTS_Approval_Segment__c);
       
           // Insert proposal
           insert p;
           
           Apttus_Proposal__Proposal__c proposal = [SELECT APTS_Approval_Segment__c, APTS_Approval_Segment_Default__c FROM Apttus_Proposal__Proposal__c WHERE id=:p.id];
           System.assertEquals(proposal.APTS_Approval_Segment__c, proposal.APTS_Approval_Segment_Default__c);
        }
    }*/
    
    static testMethod void updateTmpOrderConfirmationContactTest() {
    
    

LTS_Disable_Application_Automation__c ltstemp = new LTS_Disable_Application_Automation__c();
        ltstemp.LTS_Disable_Process_Builders__c = true;
        ltstemp.LTS_Disable_Triggers__c = true;
        ltstemp.LTS_Disable_Validation_Rules__c = true;
        ltstemp.LTS_Disable_Workflow_Rules__c = true;
        ltstemp.Name = 'temp';
        ltstemp.SetupOwnerId = userinfo.getuserid();
        insert ltstemp;
    
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
       Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
       Account a = new Account(RecordTypeId=accRecordTypeId,name='test-sg',sales_org__c='ABEP',customer_group__c='Academic',customer_type__c='Organization',customer_class_c__c='Academic Lecturer',Is_GLI__c=true);
       insert a;
        System.assertequals('test-sg',a.Name,'Success');
        
          
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
       Id accRecordTypeIdSSD=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByDeveloperName().get(USL_RECORDTPYE).getRecordTypeId();
       Source_System_Detail__c accountSSD= new Source_System_Detail__c();
        accountSSD.Name='ABC';
        accountSSD.Source_System_Name__c='ABC';
        accountSSD.Account_Name__c=a.ID;
        accountSSD.LCRM_Customer_Group__c='Academic';
        accountSSD.Account_Inactive__c=false;
        accountSSD.LCRM_Sales_Org__c='WEST';
        insert accountSSD;
       
       Contact con =  new Contact(FirstName = 'FirstName', LastName = 'LastTest', AccountId = a.Id);
       insert con;
       
       Contact con1 =  new Contact(FirstName = 'FirstName1', LastName = 'LastTest1', AccountId = a.Id);
       insert con1;
       
       Date todaysDate = system.today();
       Id oppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
       Opportunity o = new Opportunity(RecordTypeId=oppRecordTypeId, Name='tst-opp', stagename='25%',closedate=todaysDate,forecastcategoryname='Omitted',accountId=a.id,Source_System_Detail__c=accountSSD.Id);
       insert o;
       
       Apttus_Config2__PriceList__c pl =new Apttus_Config2__PriceList__c(name='tst-pl', apttus_config2__active__c=true);
       insert pl;

       Id devRecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Proposal').getRecordTypeId();
       Apttus_Proposal__Proposal__c p = new Apttus_Proposal__Proposal__c(RecordTypeId=devRecordTypeId, Apttus_Proposal__Proposal_Name__c='TST-10', 
                                                                        Apttus_Proposal__Account__c =a.id,APTS_SSD_Sold_To__c = accountSSD.Id, Apttus_Proposal__Opportunity__c=o.id, 
                                                                        Apttus_Proposal__Approval_Stage__c='Draft', Apttus_Proposal__Proposal_Category__c='Quote', 
                                                                        Apttus_Proposal__ReadyToGenerate__c = true, Apttus_Proposal__ReadyToPresent__c= true, 
                                                                        Apttus_QPConfig__PriceListId__c=pl.id);
       System.debug('PriceList before inserting new proposal: ' + p.Apttus_QPConfig__PriceListId__c);

       // Insert proposal
       insert p;
       
       p.APTS_Order_Confirmation_Contact__c = con.Id;
       p.APTS_Proposal_Business_Unit__c = 'SCS';
       p.APTS_LMS_Catalog__c = true;
       update p;
    
       // Retrieve the new proposal
       Apttus_Proposal__Proposal__c proposal = [SELECT Apttus_QPConfig__PriceListId__c FROM Apttus_Proposal__Proposal__c WHERE Id =:p.Id];
       System.debug('PriceList after trigger fired: ' + proposal.Apttus_QPConfig__PriceListId__c);

       // Test that the trigger did not change the pricelist       
       System.assertEquals(p.Apttus_QPConfig__PriceListId__c, proposal.Apttus_QPConfig__PriceListId__c);
    }
    
    /* Author -Dinesh Kumar Voonna
      Purpose - For Coverage of Digital_SecondaryQuoteExpiration method in APTS_ProposalTriggerHelper Class
      Created Date - 16-May-2017
      jira Number - DLT-283 
      Project - CX Digital MVP-A Sprint 1 */
      
    static testMethod void updateDigitalQuoteExpirationTest() {
    
    

LTS_Disable_Application_Automation__c ltstemp = new LTS_Disable_Application_Automation__c();
        ltstemp.LTS_Disable_Process_Builders__c = true;
        ltstemp.LTS_Disable_Triggers__c = true;
        ltstemp.LTS_Disable_Validation_Rules__c = true;
        ltstemp.LTS_Disable_Workflow_Rules__c = true;
        ltstemp.Name = 'temp';
        ltstemp.SetupOwnerId = userinfo.getuserid();
        insert ltstemp;
    
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
        Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
        Account a = new Account(RecordTypeId=accRecordTypeId,name='test-sg',sales_org__c='WEST',customer_group__c='FIRM',customer_type__c='Organization',customer_class_c__c='Academic Lecturer');
        
        insert a;
        System.assertequals('test-sg',a.Name,'Success');
        
        
          
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
        Id accRecordTypeIdSSD=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByDeveloperName().get(USL_RECORDTPYE).getRecordTypeId();
        Source_System_Detail__c accountSSD= new Source_System_Detail__c();
        accountSSD.Name='ABC';
        accountSSD.Source_System_Name__c='ABC';
        accountSSD.Account_Name__c=a.ID;
        accountSSD.LCRM_Customer_Group__c='Academic';
        accountSSD.Account_Inactive__c=false;
        accountSSD.LCRM_Sales_Org__c='WEST';
        insert accountSSD;
             
        Contact con1 =  new Contact(FirstName = 'FirstName1', LastName = 'LastTest1', Email = 'test.test@gmail.com', AccountId = a.Id);
        insert con1;
       
       Date todaysDate = system.today();
        Id oppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        Opportunity o = new Opportunity(RecordTypeId=oppRecordTypeId, isdigitalspearhead__c = TRUE, Name='tst-opp', stagename='25%',closedate=todaysDate,forecastcategoryname='Omitted',accountId=a.id,Source_System_Detail__c=accountSSD.Id);
       insert o;
       
        Opportunity o1 = new Opportunity(RecordTypeId=oppRecordTypeId,Source_System_Detail__c=accountSSD.Id, isdigitalspearhead__c = TRUE, Name='tst-opp one', stagename='25%',closedate=todaysDate,forecastcategoryname='Omitted',accountId=a.id);
        insert o1;
        
        Apttus_Config2__PriceList__c pl =new Apttus_Config2__PriceList__c(name='Thomson Reuters Master - US Legal', apttus_config2__active__c=true);
        insert pl;

       Id devRecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Proposal').getRecordTypeId();
       List<Apttus_Proposal__Proposal__c> prop = new List<Apttus_Proposal__Proposal__c>();
       Apttus_Proposal__Proposal__c p = new Apttus_Proposal__Proposal__c(RecordTypeId=devRecordTypeId, Apttus_Proposal__Proposal_Name__c='TST-10', 
                                                                        Apttus_Proposal__Account__c =a.id,APTS_SSD_Sold_To__c = accountSSD.Id, Apttus_Proposal__Opportunity__c=o.id, 
                                                                        Apttus_Proposal__Approval_Stage__c='Draft', Apttus_Proposal__Proposal_Category__c='Quote', 
                                                                        Apttus_Proposal__ReadyToGenerate__c = true, Apttus_Proposal__ReadyToPresent__c= true, 
                                                                        Apttus_QPConfig__PriceListId__c=pl.id);
        System.debug('PriceList before inserting new proposal: ' + p.Apttus_QPConfig__PriceListId__c);
        p.APTS_Order_Confirmation_Contact__c = con1.Id;
        // Insert proposal
        prop.add(p);
       
       Apttus_Proposal__Proposal__c p2 = new Apttus_Proposal__Proposal__c(RecordTypeId=devRecordTypeId, Apttus_Proposal__Proposal_Name__c='TST-10', 
                                                                        Apttus_Proposal__Account__c =a.id,APTS_SSD_Sold_To__c = accountSSD.Id, Apttus_Proposal__Opportunity__c=o.id, 
                                                                        Apttus_Proposal__Approval_Stage__c='Draft', Apttus_Proposal__Proposal_Category__c='Quote', 
                                                                        Apttus_Proposal__ReadyToGenerate__c = true, Apttus_Proposal__ReadyToPresent__c= true, 
                                                                        Apttus_QPConfig__PriceListId__c=pl.id);
        System.debug('PriceList before inserting new proposal: ' + p.Apttus_QPConfig__PriceListId__c);
        p2.APTS_Order_Confirmation_Contact__c = con1.Id;
        prop.add(p2);
        insert prop;
        // Insert proposal
       test.starttest();
        // create a proposal for the second opportunity       
        Apttus_Proposal__Proposal__c p3 = new Apttus_Proposal__Proposal__c(RecordTypeId=devRecordTypeId, Apttus_Proposal__Proposal_Name__c = 'TST-10', 
                                                                        Apttus_Proposal__Account__c = a.id, Apttus_Proposal__Opportunity__c = o1.id, 
                                                                        Apttus_Proposal__Approval_Stage__c = 'Draft', Apttus_Proposal__Proposal_Category__c = 'Quote', 
                                                                        Apttus_Proposal__ReadyToGenerate__c = true, Apttus_Proposal__ReadyToPresent__c = true,
                                                                        Digital_Quote_Type__c = 'Best Value',
                                                                        Apttus_QPConfig__PriceListId__c = pl.id);
        insert p3;
        
        // create opportunity Pricing record
        Opportunity_Product_Type__c op1 = new Opportunity_Product_Type__c(Opportunity__c = o1.id,
                                           Product_Category__c = 'WestlawNext', Product_Type__c = 'ProFlex', Renewal_Amount__c = 0);
        insert op1;                 
                
        // Set mock callout class for Envelope response
        Test.setMock(HttpCalloutMock.class, new HttpResponseMock());
         Digital_Exception_Log__c ex= new Digital_Exception_Log__c();
        insert ex;
        List<Apttus_Proposal__Proposal__c> quoteListUpdate = new list<Apttus_Proposal__Proposal__c>();
        p2.Apttus_Proposal__Approval_Stage__c = 'Accepted';
        quoteListUpdate.add(p2);
        p3.Apttus_Proposal__Approval_Stage__c = 'Accepted';
        quoteListUpdate.add(p3);
        
        checkRecursive.propsaltrgr_updateOpportunityStage  = true;
        checkRecursive.propsaltrgr_Digital_SecondaryQuoteExpiration=true;
        APTS_ProposalTriggerHandler.beforeUpdate = false;
        APTS_ProposalTriggerHandler.afterUpdate = false;
    
        Map<Id,Apttus_Proposal__Proposal__c> mapNew = new Map<Id,Apttus_Proposal__Proposal__c>();
        Map<Id,Apttus_Proposal__Proposal__c> mapOld = new Map<Id,Apttus_Proposal__Proposal__c>();
        APTS_ProposalTriggerHelper.updateAPTSOnlineContactsValidation(mapNew,quoteListUpdate,mapOld);
        APTS_ProposalTriggerHelper.defaultApprovalSegment(quoteListUpdate);
        update quoteListUpdate;
        
        test.stoptest();

    }
    
    // test method for Setting Quote/Proposal Approval Status
    static testMethod void updateDigitalStageTest() {
    
    

LTS_Disable_Application_Automation__c ltstemp = new LTS_Disable_Application_Automation__c();
        ltstemp.LTS_Disable_Process_Builders__c = true;
        ltstemp.LTS_Disable_Triggers__c = true;
        ltstemp.LTS_Disable_Validation_Rules__c = true;
        ltstemp.LTS_Disable_Workflow_Rules__c = true;
        ltstemp.Name = 'temp';
        ltstemp.SetupOwnerId = userinfo.getuserid();
        insert ltstemp;
          
          list<KeyValueListStore__c> kvListStore = new list<KeyValueListStore__c>();
        KeyValueListStore__c oStore1 = new  KeyValueListStore__c();
        oStore1.Name='ANZUsersProfileId';
        oStore1.TextValue__c=System.Label.APTS_OC_Test_Id;
        kvListStore.add(oStore1);
        KeyValueListStore__c oStore2 = new  KeyValueListStore__c();
        oStore2.Name='AptsOpportunityWinLoss';
        oStore2.TextValue__c='Won';
        kvListStore.add(oStore2);
        KeyValueListStore__c oStore3 = new  KeyValueListStore__c();
        oStore3.Name='AptsOpportunityCompetitor';
        oStore3.TextValue__c='Unknown';
        kvListStore.add(oStore3);
        KeyValueListStore__c oStore4 = new  KeyValueListStore__c();
        oStore4.Name='AptsOpportunityReason';
        oStore4.TextValue__c='Other';
        kvListStore.add(oStore4);
         KeyValueListStore__c LCRMStrikeIronFlagINS1 = new KeyValueListStore__c();
        LCRMStrikeIronFlagINS1.Name='LCRMDisableStrikeIronServices';
        LCRMStrikeIronFlagINS1.TextValue__c='True';
         kvListStore.add(LCRMStrikeIronFlagINS1);
         KeyValueListStore__c keyval = new KeyValueListStore__c();
        keyval.Name='ReasonWithCompetitor';
        keyval.TextValue__c='Price';
        kvListStore.add(keyval);
        insert kvListStore;
        Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
        Account acct = new Account(RecordTypeId=accRecordTypeId,name='test-sg',sales_org__c='WEST',customer_group__c='FIRM',customer_type__c='Organization',customer_class_c__c='Academic Lecturer');
        insert acct;
        System.assertequals('test-sg',acct.Name,'Success');     
        
        Contact con1 =  new Contact(FirstName = 'FirstName1', LastName = 'LastTest1', Email = 'test.test@gmail.com', AccountId = acct.Id);
        insert con1;
                  
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
        
        Id accRecordTypeIdSSD=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByDeveloperName().get(USL_RECORDTPYE).getRecordTypeId();
        Source_System_Detail__c accountSSD= new Source_System_Detail__c();
        accountSSD.Name='ABC';
        accountSSD.Source_System_Name__c='ABC';
        accountSSD.Account_Name__c=acct.ID;
        accountSSD.LCRM_Customer_Group__c='Academic';
        accountSSD.Account_Inactive__c=false;
        accountSSD.LCRM_Sales_Org__c='WEST';
        insert accountSSD;
       
        Date todaysDate = system.today();
        Id oppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Pipeline Opportunity').getRecordTypeId();
        Opportunity opp = new Opportunity(RecordTypeId=oppRecordTypeId, Source_System_Detail__c=accountSSD.Id,isdigitalspearhead__c = TRUE, Name='tst-opp', stagename='25%',closedate=todaysDate,forecastcategoryname='Omitted',accountId=acct.id);
        insert opp;
       
        Apttus_Config2__PriceList__c price =new Apttus_Config2__PriceList__c(name='tst-pl', apttus_config2__active__c=true);
        insert price;

        
        // prepare Proposals
        List<Apttus_Proposal__Proposal__c> quoteList = new list<Apttus_Proposal__Proposal__c>();
        Id devRecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Proposal').getRecordTypeId();
        // Proposal to Set stage to Expired
        Apttus_Proposal__Proposal__c prop1 = new Apttus_Proposal__Proposal__c(RecordTypeId=devRecordTypeId, Apttus_Proposal__Proposal_Name__c = 'TST-10', 
                                                 Apttus_Proposal__Account__c = acct.id, Apttus_Proposal__Opportunity__c = opp.id, 
                                                 Apttus_Proposal__Approval_Stage__c = 'Presented', Apttus_Proposal__Proposal_Category__c = 'Quote', 
                                                 Apttus_Proposal__ReadyToGenerate__c = true, Apttus_Proposal__ReadyToPresent__c = true,
                                                 Apttus_QPConfig__PriceListId__c = price.id, APTS_Order_Confirmation_Contact__c = con1.Id,
                                                 DocuSign_Envelope_ID__c = 'envtestid1');
        quoteList.add(Prop1);  
       
        // Proposal to Set stage to Denied
        Apttus_Proposal__Proposal__c prop2 = new Apttus_Proposal__Proposal__c(RecordTypeId=devRecordTypeId, Apttus_Proposal__Proposal_Name__c = 'TST-10', 
                                                 Apttus_Proposal__Account__c = acct.id, Apttus_Proposal__Opportunity__c = opp.id, 
                                                 Apttus_Proposal__Approval_Stage__c = 'Presented', Apttus_Proposal__Proposal_Category__c = 'Quote', 
                                                 Apttus_Proposal__ReadyToGenerate__c = true, Apttus_Proposal__ReadyToPresent__c = true,
                                                 Apttus_QPConfig__PriceListId__c = price.id, APTS_Order_Confirmation_Contact__c = con1.Id,
                                                 DocuSign_Envelope_ID__c = 'envtestid2');
        quoteList.add(Prop2);        

        // Proposal to update env id to the quote
        Apttus_Proposal__Proposal__c prop3 = new Apttus_Proposal__Proposal__c(RecordTypeId=devRecordTypeId, Apttus_Proposal__Proposal_Name__c = 'TST-10', 
                                                 Apttus_Proposal__Account__c = acct.id, Apttus_Proposal__Opportunity__c = opp.id, 
                                                 Apttus_Proposal__Approval_Stage__c = 'Presented', Apttus_Proposal__Proposal_Category__c = 'Quote', 
                                                 Apttus_Proposal__ReadyToGenerate__c = true, Apttus_Proposal__ReadyToPresent__c = true,
                                                 Apttus_QPConfig__PriceListId__c = price.id, APTS_Order_Confirmation_Contact__c = con1.Id,
                                                 DocuSign_Envelope_ID__c = '');
        quoteList.add(Prop3);   
        

        // Proposal to Set stage to Denied
        Apttus_Proposal__Proposal__c prop4 = new Apttus_Proposal__Proposal__c(RecordTypeId=devRecordTypeId, Apttus_Proposal__Proposal_Name__c = 'TST-10', 
                                                 Apttus_Proposal__Account__c = acct.id, Apttus_Proposal__Opportunity__c = opp.id, 
                                                 Apttus_Proposal__Approval_Stage__c = 'Generated', Apttus_Proposal__Proposal_Category__c = 'Quote', 
                                                 Apttus_Proposal__ReadyToGenerate__c = true, Apttus_Proposal__ReadyToPresent__c = true,
                                                 Apttus_QPConfig__PriceListId__c = price.id, APTS_Order_Confirmation_Contact__c = con1.Id,
                                                 DocuSign_Envelope_ID__c = 'envtestid4');
        quoteList.add(Prop4);           
        insert quoteList;

        
        // create envelope records for docusign
        List<Apttus_DocuApi__DocuSignEnvelope__c> envList = new list<Apttus_DocuApi__DocuSignEnvelope__c>();
        Apttus_DocuApi__DocuSignEnvelope__c Env1 = new Apttus_DocuApi__DocuSignEnvelope__c();
        Env1.APTTUS_DOCUAPI__STATUS__C = 'voided'; 
        Env1.Apttus_QPDSign__QuoteProposal__c = prop1.Id;
        Env1.Apttus_DocuApi__ParentId__c = prop1.Id;
        Env1.Apttus_DocuApi__EnvelopeId__c = 'envtestid1'; 
        Env1.APTTUS_DOCUAPI__RECALLREASON__C = '';
        envList.add(Env1);
        
        Apttus_DocuApi__DocuSignEnvelope__c Env2 = new Apttus_DocuApi__DocuSignEnvelope__c();
        Env2.APTTUS_DOCUAPI__STATUS__C = 'voided'; 
        Env2.Apttus_QPDSign__QuoteProposal__c = prop2.Id;
        Env2.Apttus_DocuApi__ParentId__c = prop2.Id;
        Env2.Apttus_DocuApi__EnvelopeId__c = 'envtestid2'; 
        Env2.APTTUS_DOCUAPI__RECALLREASON__C = 'Test Void Reason';
        envList.add(Env2);    
             
        Apttus_DocuApi__DocuSignEnvelope__c Env3 = new Apttus_DocuApi__DocuSignEnvelope__c();
        Env3.APTTUS_DOCUAPI__STATUS__C = 'sent'; 
        Env3.Apttus_QPDSign__QuoteProposal__c = prop3.Id;
        Env3.Apttus_DocuApi__ParentId__c = prop3.Id;
        Env3.Apttus_DocuApi__EnvelopeId__c = 'envtestid3'; 
        Env3.APTTUS_DOCUAPI__RECALLREASON__C = '';
        envList.add(Env3);
        
        Apttus_DocuApi__DocuSignEnvelope__c Env4 = new Apttus_DocuApi__DocuSignEnvelope__c();
        Env4.APTTUS_DOCUAPI__STATUS__C = 'sent'; 
        Env4.Apttus_QPDSign__QuoteProposal__c = prop4.Id;
        Env4.Apttus_DocuApi__ParentId__c = prop4.Id;
        Env4.Apttus_DocuApi__EnvelopeId__c = 'envtestid4'; 
        Env4.APTTUS_DOCUAPI__RECALLREASON__C = '';
        envList.add(Env4); 
                     
        insert envList;
        
        List<String> proposalIds = new List<String>();
        proposalIds.add(quoteList[0].Id);
        proposalIds.add(quoteList[1].Id);
        List<Apttus_DocuApi__DocuSignEnvelope__c> envelopeList = [SELECT Id, Apttus_QPDSign__QuoteProposal__c, Apttus_DocuApi__EnvelopeId__c, Apttus_DocuApi__Status__c, APTTUS_DOCUAPI__RECALLREASON__C
            FROM Apttus_DocuApi__DocuSignEnvelope__c WHERE Apttus_QPDSign__QuoteProposal__c IN: proposalIds order by Apttus_DocuApi__ParentId__c, Apttus_QPDSign__QuoteProposal__c, createdDate ASC
        ];
        
        System.assertEquals(2, envelopeList.size());
    
        // Set mock callout class for Envelope response
        Test.setMock(HttpCalloutMock.class, new HttpResponseMock());
        
        test.starttest();
                
        List<Apttus_Proposal__Proposal__c> quoteListUpdate = new list<Apttus_Proposal__Proposal__c>();
        prop1.Digital_Quote_Type__c = 'Best Value';
         prop1.Apttus_Proposal__Approval_Stage__c='Accepted';
        quoteListUpdate.add(prop1);
        prop2.Digital_Quote_Type__c = 'Best Value';
        quoteListUpdate.add(prop2);
        prop3.Digital_Quote_Type__c = 'Best Value';
        quoteListUpdate.add(prop3);
        prop4.Digital_Quote_Type__c = 'Best Value';
        prop4.Apttus_Proposal__Approval_Stage__c='Accepted';
        quoteListUpdate.add(prop4);
        
        checkRecursive.propsaltrgr_updateOpportunityStage  = true; //Added by Poorva 
        checkRecursive.propsaltrgr_DigitalUpdateToProposal = true;
        
        update QuoteListUpdate;
        delete QuoteListUpdate[0];
        test.stoptest();

    }

static testMethod void updateLegalLangTest() {

    

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
        
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByDeveloperName().get(USL_RECORDTPYE).getRecordTypeId();
        
        Source_System_Detail__c accountSSD=APTS_TestDataFactory.createSourceSystem(a);
        accountSSD.RecordtypeId=ssdRecorType;
        accountSSD.Account_Inactive__c=false;
        accountSSD.Name='ABC';
        accountSSD.Source_System_Name__c='ABC';
        accountSSD.Account_Name__c=a.ID;
        accountSSD.Account_Inactive__c=false;
        accountSSD.LCRM_Sales_Org__c='WEST';
        insert accountSSD;
        
        Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        Opportunity oppty=APTS_TestDataFactory.createOpportunity('Test Opty',a.id,'10%',Date.Today());
        oppty.RecordtypeId=opptyRecorType;
        oppty.Source_System_Detail__c=accountSSD.id;
        oppty.Account=a;
        insert oppty;
        
        List<Apttus_Proposal__Proposal__c> proposallist = new List<Apttus_Proposal__Proposal__c >();        
        
        
        Apttus_Proposal__Proposal__c proposal = new Apttus_Proposal__Proposal__c();
        proposal.APTS_Proposal_Business_Unit__c = 'FindLaw';
        proposal.Apttus_Proposal__Account__c=a.id;
        proposal.Apttus_Proposal__Opportunity__c=oppty.id;
        proposallist.add(proposal);

        Insert proposallist;
       

       Apttus_Config2__ProductConfiguration__c prodConfig = APTS_TestDataFactory.createProductConfiguration(proposal.Id);
        prodConfig.Apttus_Config2__BusinessObjectId__c = proposal.Id;
        prodConfig.Apttus_Config2__BusinessObjectType__c = 'Proposal';
        prodConfig.APTS_SSD_bill_to__c = accountSSD.Id;
        prodConfig.APTS_SSD_ship_to__c = accountSSD.Id;

        prodConfig.Apttus_Config2__AccountId__c = a.Id;
        prodConfig.Apttus_Config2__PriceListId__c = priceList.Id;
        prodConfig.Apttus_Config2__Status__c = 'New';
        insert prodConfig;
      
      
          List<Apttus_Proposal__Proposal_Line_Item__c> lineItemList1 = new List<Apttus_Proposal__Proposal_Line_Item__c>();
          Apttus_Proposal__Proposal_Line_Item__c plItem2 = new Apttus_Proposal__Proposal_Line_Item__c(          
          Apttus_Proposal__Quantity__c=1,
          APTS_Proposal_Business_Unit__c ='FindLaw',          
          APTS_Contract_Term__c = '4 Years',
          Apttus_QPConfig__PriceType__c='Recurring',
          Apttus_QPConfig__ChargeType__c='Subscription fee',
          Apttus_QPConfig__ConfigurationId__c = prodConfig.id, 
          Apttus_QPConfig__LineType__c = 'Product/Service',
          Apttus_QPConfig__LineNumber__c = 1,          
          Apttus_QPConfig__NetPrice__c=1,
          Apttus_QPConfig__LineStatus__c = 'New',
          Apttus_Proposal__Proposal__c=proposallist[0].id);
          lineItemList1.add(plItem2);
             
          Product2 prod1=new Product2(Name ='FirmSite 111C',ProductCode = '40483693',Product_Level_2__c = 'RISK SOLUTIONS');
          Product2 prod2=new Product2(Name ='FirmSite 222C',ProductCode = '40483696');  
          Product2 prod3=new Product2(Name ='FirmSite 333C',ProductCode = '40483699'); 
          Product2 prod4=new Product2(Name ='1SRC NRA Banner Interface',ProductCode = '41318361',APTS_Product_Pricing_Model__c = 'TRUST TAX',APTS_FL_Renewal_Only_Clone__c = 'No',Product_Level_2__c = 'ACRITAS');    
          Product2 prod5=new Product2(Name ='1SRC NRA Banner Interface',ProductCode = '30081375',APTS_Product_Pricing_Model__c = 'TRUST TAX'); 
          Product2 prod6=new Product2(Name ='1SRC NRA Banner Interface',ProductCode = '30081375',APTS_FL_Renewal_Only_Clone__c = 'Yes');          
          List<Product2> productList=new List<Product2>{prod1,prod2,prod3,prod4,prod5,prod6};
          insert productList;
          
          APTS_Product_Legal_Language_FL_Settings__c settings1=new APTS_Product_Legal_Language_FL_Settings__c(name='PI-LL-111C',APTS_Product_Codes__c='40483693',APTS_Product_Names__c='FirmSite 111C',APTS_Short_Term_Applicable__c=true,APTS_Short_Term_Not_Applicable__c=false); 
          APTS_Product_Legal_Language_FL_Settings__c settings2=new APTS_Product_Legal_Language_FL_Settings__c(name='PI-LL-222C',APTS_Product_Codes__c='40483696',APTS_Product_Names__c='FirmSite 222C',APTS_Short_Term_Applicable__c=false,APTS_Short_Term_Not_Applicable__c=false); 
          APTS_Product_Legal_Language_FL_Settings__c settings3=new APTS_Product_Legal_Language_FL_Settings__c(name='PI-LL-333C',APTS_Product_Codes__c='40483699',APTS_Product_Names__c='FirmSite 333C',APTS_Short_Term_Applicable__c=false,APTS_Short_Term_Not_Applicable__c=true); 
          List<APTS_Product_Legal_Language_FL_Settings__c> legalLanguageSettingsList=new List<APTS_Product_Legal_Language_FL_Settings__c>{settings1,settings2,settings3};
          insert legalLanguageSettingsList;
          
          CORPMaterialNumber__c matno =new CORPMaterialNumber__c(Name = '30080246',MaterialNumber__c = '30080246');
          insert matno;
          
           CORPMaterialNumber__c matno1 =new CORPMaterialNumber__c(Name = '30081375',MaterialNumber__c = '30081375');       
          insert matno1;
          
          Apttus_Proposal__Proposal_Line_Item__c plItem3 = new Apttus_Proposal__Proposal_Line_Item__c(          
          Apttus_Proposal__Quantity__c=1,
          APTS_Proposal_Business_Unit__c ='FindLaw',          
          APTS_Contract_Term__c = '1 Year',
          Apttus_QPConfig__PriceType__c='Recurring',
          Apttus_QPConfig__ChargeType__c='Subscription fee',
          Apttus_QPConfig__ConfigurationId__c = prodConfig.id, 
          Apttus_QPConfig__LineType__c = 'Product/Service',
          Apttus_QPConfig__LineNumber__c = 1,          
          Apttus_QPConfig__NetPrice__c=1,
          Apttus_QPConfig__LineStatus__c = 'New',
          Apttus_Proposal__Proposal__c=proposallist[0].id);  
          lineItemList1.add(plItem3);
          
          Apttus_Proposal__Proposal_Line_Item__c plItem4 = new Apttus_Proposal__Proposal_Line_Item__c(          
          Apttus_Proposal__Quantity__c=1,
          APTS_Proposal_Business_Unit__c ='FindLaw',          
          APTS_Contract_Term__c = '1 Year',
          Apttus_QPConfig__PriceType__c='Recurring',
          Apttus_QPConfig__ChargeType__c='Subscription fee',
          Apttus_QPConfig__ConfigurationId__c = prodConfig.id, 
          Apttus_QPConfig__LineType__c = 'Product/Service',
          Apttus_QPConfig__LineNumber__c = 1,          
          Apttus_QPConfig__NetPrice__c=1,
          Apttus_Proposal__Product__c=prod1.Id,
          Apttus_QPConfig__LineStatus__c = 'New',
          Apttus_Proposal__Proposal__c=proposallist[0].id);  
          lineItemList1.add(plItem4);
             
          Apttus_Proposal__Proposal_Line_Item__c plItem5 = new Apttus_Proposal__Proposal_Line_Item__c(          
          Apttus_Proposal__Quantity__c=1,
          APTS_Proposal_Business_Unit__c ='FindLaw',          
          APTS_Contract_Term__c = '2 Years',
          Apttus_QPConfig__PriceType__c='Recurring',
          Apttus_QPConfig__ChargeType__c='Subscription fee',
          Apttus_QPConfig__ConfigurationId__c = prodConfig.id, 
          Apttus_QPConfig__LineType__c = 'Product/Service',
          Apttus_QPConfig__LineNumber__c = 1,          
          Apttus_QPConfig__NetPrice__c=1,
          Apttus_Proposal__Product__c=prod2.Id,
          Apttus_QPConfig__LineStatus__c = 'New',
          Apttus_Proposal__Proposal__c=proposallist[0].id);  
          lineItemList1.add(plItem5);
           
          Apttus_Proposal__Proposal_Line_Item__c plItem6 = new Apttus_Proposal__Proposal_Line_Item__c(          
          Apttus_Proposal__Quantity__c=1,
          APTS_Proposal_Business_Unit__c ='FindLaw',          
          APTS_Contract_Term__c = '3 Years',
          Apttus_QPConfig__PriceType__c='Recurring',
          Apttus_QPConfig__ChargeType__c='Subscription fee',
          Apttus_QPConfig__ConfigurationId__c = prodConfig.id, 
          Apttus_QPConfig__LineType__c = 'Product/Service',
          Apttus_QPConfig__LineNumber__c = 1,
          Apttus_QPConfig__NetPrice__c=1,
          Apttus_Proposal__Product__c=prod3.id,
          Apttus_QPConfig__LineStatus__c = 'New',
          Apttus_Proposal__Proposal__c=proposallist[0].id);  
          lineItemList1.add(plItem6);  
             
          Apttus_Proposal__Proposal_Line_Item__c plItem7 = new Apttus_Proposal__Proposal_Line_Item__c(          
          Apttus_Proposal__Quantity__c=1,
          APTS_Proposal_Business_Unit__c ='FindLaw',          
          APTS_Contract_Term__c = '3 Years',
          Apttus_QPConfig__PriceType__c='Recurring',
          Apttus_QPConfig__ChargeType__c='Subscription fee',
          Apttus_QPConfig__ConfigurationId__c = prodConfig.id, 
          Apttus_QPConfig__LineType__c = 'Product/Service',
          APTS_Online_Contacts_Validation__c=true,
          Apttus_QPConfig__LineNumber__c = 1,
          Apttus_QPConfig__NetPrice__c=1,
          Apttus_Proposal__Product__c=prod1.id,
          Apttus_QPConfig__LineStatus__c = 'Renewed',
          Apttus_Proposal__Proposal__c=proposallist[0].id);  
          lineItemList1.add(plItem7); 
          
          Apttus_Proposal__Proposal_Line_Item__c plItem8 = new Apttus_Proposal__Proposal_Line_Item__c(          
          Apttus_Proposal__Quantity__c=1,
          APTS_Proposal_Business_Unit__c ='Corp OneOTC US',          
          APTS_Contract_Term__c = '1 Year',
          Apttus_QPConfig__PriceType__c='Recurring',
          Apttus_QPConfig__ChargeType__c='Subscription fee',
          Apttus_QPConfig__ConfigurationId__c = prodConfig.id, 
          Apttus_QPConfig__LineType__c = 'Product/Service',
          Apttus_QPConfig__LineNumber__c = 1,
          Apttus_QPConfig__NetPrice__c=1,
          Apttus_Proposal__Product__c=prod3.id,
          Apttus_QPConfig__LineStatus__c = 'New',
          APTS_Renewal_Type__c = 'Auto Renew',
          APTS_Term_Type__c = '',
          APTS_Item_Category_Group__c = 'ZT04',
          APTS_Contract_Term_Number__c = 12,
          APTS_WLEC_Product_Category__c = 'PS',
          Apttus_Proposal__Proposal__c=proposallist[0].id);  
          lineItemList1.add(plItem8);  
          
          Apttus_Proposal__Proposal_Line_Item__c plItem9 = new Apttus_Proposal__Proposal_Line_Item__c(          
          Apttus_Proposal__Quantity__c=1,
          APTS_Proposal_Business_Unit__c ='Corp OneOTC US',          
          APTS_Contract_Term__c = '1 Year',
          Apttus_QPConfig__PriceType__c='Recurring',
          Apttus_QPConfig__ChargeType__c='Subscription fee',
          Apttus_QPConfig__ConfigurationId__c = prodConfig.id, 
          Apttus_QPConfig__LineType__c = 'Product/Service',
          Apttus_QPConfig__LineNumber__c = 1,
          Apttus_QPConfig__NetPrice__c=1,
          Apttus_Proposal__Product__c=prod4.id,
          Apttus_QPConfig__LineStatus__c = 'New',
          APTS_Renewal_Type__c = 'Evergreen',
          APTS_Term_Type__c = null,
          APTS_Item_Category_Group__c = 'ZT07',
          APTS_Contract_Term_Number__c = 24,
          APTS_WLEC_Product_Category__c = 'PS',
          Apttus_Proposal__Proposal__c=proposallist[0].id);  
          lineItemList1.add(plItem9);  
          
           Apttus_Proposal__Proposal_Line_Item__c plItem0 = new Apttus_Proposal__Proposal_Line_Item__c(          
          Apttus_Proposal__Quantity__c=1,
          APTS_Proposal_Business_Unit__c ='Corp OneOTC US',          
          APTS_Contract_Term__c = '1 Year',
          Apttus_QPConfig__PriceType__c='Recurring',
          Apttus_QPConfig__ChargeType__c='Subscription fee',
          Apttus_QPConfig__ConfigurationId__c = prodConfig.id, 
          Apttus_QPConfig__LineType__c = 'Product/Service',
          Apttus_QPConfig__LineNumber__c = 1,
          Apttus_QPConfig__NetPrice__c=1,
          Apttus_Proposal__Product__c=prod5.id,
          Apttus_QPConfig__LineStatus__c = 'New',
          APTS_Renewal_Type__c = 'Auto Renew',
          APTS_Term_Type__c = null,
          APTS_Item_Category_Group__c = 'ZT07',
          APTS_Contract_Term_Number__c = 12,
          APTS_WLEC_Product_Category__c = 'PS',
          Apttus_Proposal__Proposal__c=proposallist[0].id);  
          lineItemList1.add(plItem0);  
          
           Apttus_Proposal__Proposal_Line_Item__c plItem01 = new Apttus_Proposal__Proposal_Line_Item__c(          
          Apttus_Proposal__Quantity__c=1,
          APTS_Proposal_Business_Unit__c ='Corp OneOTC US',          
          APTS_Contract_Term__c = '2 Year',
          Apttus_QPConfig__PriceType__c='Recurring',
          Apttus_QPConfig__ChargeType__c='Subscription fee',
          Apttus_QPConfig__ConfigurationId__c = prodConfig.id, 
          Apttus_QPConfig__LineType__c = 'Product/Service',
          Apttus_QPConfig__LineNumber__c = 1,
          Apttus_QPConfig__NetPrice__c=1,
          Apttus_Proposal__Product__c=prod5.id,
          Apttus_QPConfig__LineStatus__c = 'New',
          APTS_Renewal_Type__c = 'Auto Renew',
          APTS_Term_Type__c = null,
          APTS_Item_Category_Group__c = 'ZT07',
          APTS_Contract_Term_Number__c = 24,
          APTS_WLEC_Product_Category__c = 'PS',
          Apttus_Proposal__Proposal__c=proposallist[0].id);  
          lineItemList1.add(plItem01);  
          
           Apttus_Proposal__Proposal_Line_Item__c plItem02 = new Apttus_Proposal__Proposal_Line_Item__c(          
          Apttus_Proposal__Quantity__c=1,
          APTS_Proposal_Business_Unit__c ='Corp OneOTC US',          
          APTS_Contract_Term__c = '2 Year',
          Apttus_QPConfig__PriceType__c='Recurring',
          Apttus_QPConfig__ChargeType__c='Subscription fee',
          Apttus_QPConfig__ConfigurationId__c = prodConfig.id, 
          Apttus_QPConfig__LineType__c = 'Product/Service',
          Apttus_QPConfig__LineNumber__c = 1,
          Apttus_QPConfig__NetPrice__c=1,
          Apttus_Proposal__Product__c=prod5.id,
          Apttus_QPConfig__LineStatus__c = 'New',
          APTS_Renewal_Type__c = 'Term Commitment',
          APTS_Term_Type__c = null,
          APTS_Item_Category_Group__c = 'ZT07',
          APTS_Contract_Term_Number__c = 24,
          APTS_WLEC_Product_Category__c = 'PS',
          Apttus_Proposal__Proposal__c=proposallist[0].id);  
          lineItemList1.add(plItem02);  
          
          Apttus_Proposal__Proposal_Line_Item__c plItem10 = new Apttus_Proposal__Proposal_Line_Item__c(          
          Apttus_Proposal__Quantity__c=1,
          APTS_Proposal_Business_Unit__c ='Corp OneOTC US',          
          APTS_Contract_Term__c = '1 Year',
          Apttus_QPConfig__PriceType__c='Recurring',
          Apttus_QPConfig__ChargeType__c='Subscription fee',
          Apttus_QPConfig__ConfigurationId__c = prodConfig.id, 
          Apttus_QPConfig__LineType__c = 'Product/Service',
          Apttus_QPConfig__LineNumber__c = 1,
          Apttus_QPConfig__NetPrice__c=1,
          Apttus_Proposal__Product__c=prod4.id,
          Apttus_QPConfig__LineStatus__c = 'New',
          APTS_Renewal_Type__c = 'Auto Renew',
          APTS_Term_Type__c = '',
          APTS_Item_Category_Group__c = 'ZT07',
          APTS_Contract_Term_Number__c = 24,
          APTS_WLEC_Product_Category__c = 'PS',
          APTS_Media_High_Level_Code__c = '02',
          APTS_Media_Lower_Level_Code__c = 'AQ',
          Apttus_Proposal__Proposal__c=proposallist[0].id);  
          lineItemList1.add(plItem10);  
          
          Apttus_Proposal__Proposal_Line_Item__c plItem11 = new Apttus_Proposal__Proposal_Line_Item__c(          
          Apttus_Proposal__Quantity__c=1,
          APTS_Proposal_Business_Unit__c ='Corp OneOTC US',          
          APTS_Contract_Term__c = '1 Year',
          Apttus_QPConfig__PriceType__c='Recurring',
          Apttus_QPConfig__ChargeType__c='Subscription fee',
          Apttus_QPConfig__ConfigurationId__c = prodConfig.id, 
          Apttus_QPConfig__LineType__c = 'Product/Service',
          Apttus_QPConfig__LineNumber__c = 1,
          Apttus_QPConfig__NetPrice__c=1,
          Apttus_Proposal__Product__c=prod4.id,
          Apttus_QPConfig__LineStatus__c = 'New',
          APTS_Renewal_Type__c = 'Term Commitment',
          APTS_Term_Type__c = '',
          APTS_Item_Category_Group__c = 'ZT07',
          APTS_Contract_Term_Number__c = 24,
          APTS_WLEC_Product_Category__c = 'PS',
          Apttus_Proposal__Proposal__c=proposallist[0].id);  
          lineItemList1.add(plItem11);  
          
          Apttus_Proposal__Proposal_Line_Item__c plItem12 = new Apttus_Proposal__Proposal_Line_Item__c(          
          Apttus_Proposal__Quantity__c=1,
          APTS_Proposal_Business_Unit__c ='Corp OneOTC US',          
          APTS_Contract_Term__c = '1 Year',
          Apttus_QPConfig__PriceType__c='One Time',
          Apttus_QPConfig__ChargeType__c='Subscription fee',
          Apttus_QPConfig__ConfigurationId__c = prodConfig.id, 
          Apttus_QPConfig__LineType__c = 'Product/Service',
          Apttus_QPConfig__LineNumber__c = 1,
          Apttus_QPConfig__NetPrice__c=1,
          Apttus_Proposal__Product__c=prod4.id,
          Apttus_QPConfig__LineStatus__c = 'New',
          APTS_Term_Type__c = '',
          APTS_WLEC_Product_Category__c = 'PS',
          Apttus_Proposal__Proposal__c=proposallist[0].id);  
          lineItemList1.add(plItem12); 

          Apttus_Proposal__Proposal_Line_Item__c plItem13 = new Apttus_Proposal__Proposal_Line_Item__c(          
          Apttus_Proposal__Quantity__c=1,
          APTS_Proposal_Business_Unit__c ='Corp OneOTC US',          
          APTS_Contract_Term__c = '1 Year',
          Apttus_QPConfig__PriceType__c='Recurring',
          Apttus_QPConfig__ChargeType__c='Subscription fee',
          Apttus_QPConfig__ConfigurationId__c = prodConfig.id, 
          Apttus_QPConfig__LineType__c = 'Product/Service',
          Apttus_QPConfig__LineNumber__c = 1,
          Apttus_QPConfig__NetPrice__c=1,
          Apttus_Proposal__Product__c=prod4.id,
          Apttus_QPConfig__LineStatus__c = 'New',
          APTS_Renewal_Type__c = 'Auto Renew',
          APTS_Term_Type__c = '',
          APTS_Item_Category_Group__c = 'ZT07',
          APTS_Contract_Term_Number__c = 12,
          APTS_WLEC_Product_Category__c = 'PS',
          Apttus_Proposal__Proposal__c=proposallist[0].id);  
          lineItemList1.add(plItem13);

          Apttus_Proposal__Proposal_Line_Item__c plItem14 = new Apttus_Proposal__Proposal_Line_Item__c(          
          Apttus_Proposal__Quantity__c=1,
          APTS_Proposal_Business_Unit__c ='Corp OneOTC US',          
          APTS_Contract_Term__c = '1 Year',
          Apttus_QPConfig__PriceType__c='Recurring',
          Apttus_QPConfig__ChargeType__c='Subscription fee',
          Apttus_QPConfig__ConfigurationId__c = prodConfig.id, 
          Apttus_QPConfig__LineType__c = 'Product/Service',
          Apttus_QPConfig__LineNumber__c = 1,
          Apttus_QPConfig__NetPrice__c=1,
          Apttus_Proposal__Product__c=prod4.id,
          Apttus_QPConfig__LineStatus__c = 'New',
          APTS_Renewal_Type__c = 'Auto Renew',
          APTS_Availability_Date__c = Date.Today(),
          APTS_Term_Type__c = '',
          APTS_Contract_Term_Number__c = 12,
          Apttus_Proposal__Proposal__c=proposallist[0].id);  
          lineItemList1.add(plItem14);  
          
          Apttus_Proposal__Proposal_Line_Item__c plItem15 = new Apttus_Proposal__Proposal_Line_Item__c(          
          Apttus_Proposal__Quantity__c=1,
          APTS_Proposal_Business_Unit__c ='Corp OneOTC US',          
          APTS_Contract_Term__c = '1 Year',
          Apttus_QPConfig__PriceType__c='Recurring',
          Apttus_QPConfig__ChargeType__c='Subscription fee',
          Apttus_QPConfig__ConfigurationId__c = prodConfig.id, 
          Apttus_QPConfig__LineType__c = 'Product/Service',
          Apttus_QPConfig__LineNumber__c = 1,
          Apttus_QPConfig__NetPrice__c=1,
          Apttus_Proposal__Product__c=prod4.id,
          Apttus_QPConfig__LineStatus__c = 'New',
          APTS_Renewal_Type__c = 'Evergreen',
          APTS_Availability_Date__c = Date.Today(),
          APTS_Term_Type__c = '',
          Apttus_Proposal__Proposal__c=proposallist[0].id);  
          lineItemList1.add(plItem15);  
          
          Apttus_Proposal__Proposal_Line_Item__c plItem16 = new Apttus_Proposal__Proposal_Line_Item__c(          
          Apttus_Proposal__Quantity__c=1,
          APTS_Proposal_Business_Unit__c ='Corp OneOTC US',          
          APTS_Contract_Term__c = '1 Year',
          Apttus_QPConfig__PriceType__c='Recurring',
          Apttus_QPConfig__ChargeType__c='Subscription fee',
          Apttus_QPConfig__ConfigurationId__c = prodConfig.id, 
          Apttus_QPConfig__LineType__c = 'Product/Service',
          Apttus_QPConfig__LineNumber__c = 1,
          Apttus_QPConfig__NetPrice__c=1,
          Apttus_Proposal__Product__c=prod4.id,
          Apttus_QPConfig__LineStatus__c = 'New',
          APTS_Renewal_Type__c = 'Auto Renew',
          APTS_Availability_Date__c = Date.Today(),
          APTS_Term_Type__c = '',
          APTS_Contract_Term_Number__c = 24,
          Apttus_Proposal__Proposal__c=proposallist[0].id);  
          lineItemList1.add(plItem16);  
          
          Apttus_Proposal__Proposal_Line_Item__c plItem17 = new Apttus_Proposal__Proposal_Line_Item__c(          
          Apttus_Proposal__Quantity__c=1,
          APTS_Proposal_Business_Unit__c ='Corp OneOTC US',          
          APTS_Contract_Term__c = '1 Year',
          Apttus_QPConfig__PriceType__c='Recurring',
          Apttus_QPConfig__ChargeType__c='Subscription fee',
          Apttus_QPConfig__ConfigurationId__c = prodConfig.id, 
          Apttus_QPConfig__LineType__c = 'Product/Service',
          Apttus_QPConfig__LineNumber__c = 1,
          Apttus_QPConfig__NetPrice__c=1,
          Apttus_Proposal__Product__c=prod4.id,
          Apttus_QPConfig__LineStatus__c = 'New',
          APTS_Renewal_Type__c = 'Term Commitment',
          APTS_Availability_Date__c = Date.Today(),
          APTS_Term_Type__c = '',
          Apttus_Proposal__Proposal__c=proposallist[0].id);  
          lineItemList1.add(plItem17);
          
          Apttus_Proposal__Proposal_Line_Item__c plItem18 = new Apttus_Proposal__Proposal_Line_Item__c(          
          Apttus_Proposal__Quantity__c=1,
          APTS_Proposal_Business_Unit__c ='Corp OneOTC US',          
          APTS_Contract_Term__c = '1 Year',
          Apttus_QPConfig__PriceType__c='Recurring',
          Apttus_QPConfig__ChargeType__c='Subscription fee',
          Apttus_QPConfig__ConfigurationId__c = prodConfig.id, 
          Apttus_QPConfig__LineType__c = 'Product/Service',
          Apttus_QPConfig__LineNumber__c = 1,
          Apttus_QPConfig__NetPrice__c=1,
          Apttus_Proposal__Product__c=prod4.id,
          Apttus_QPConfig__LineStatus__c = 'New',
          APTS_Renewal_Type__c = 'Auto Renew',
          APTS_Term_Type__c = '',
          APTS_Contract_Term_Number__c = 12,
          Apttus_Proposal__Proposal__c=proposallist[0].id);  
          lineItemList1.add(plItem18);  
          
          Apttus_Proposal__Proposal_Line_Item__c plItem19 = new Apttus_Proposal__Proposal_Line_Item__c(          
          Apttus_Proposal__Quantity__c=1,
          APTS_Proposal_Business_Unit__c ='Corp OneOTC US',          
          APTS_Contract_Term__c = '1 Year',
          Apttus_QPConfig__PriceType__c='Recurring',
          Apttus_QPConfig__ChargeType__c='Subscription fee',
          Apttus_QPConfig__ConfigurationId__c = prodConfig.id, 
          Apttus_QPConfig__LineType__c = 'Product/Service',
          Apttus_QPConfig__LineNumber__c = 1,
          Apttus_QPConfig__NetPrice__c=1,
          Apttus_Proposal__Product__c=prod4.id,
          Apttus_QPConfig__LineStatus__c = 'New',
          APTS_Renewal_Type__c = 'Evergreen',
          APTS_Term_Type__c = '',
          APTS_Contract_Term_Number__c = 24,
          Apttus_Proposal__Proposal__c=proposallist[0].id);  
          lineItemList1.add(plItem19);  
          
          Apttus_Proposal__Proposal_Line_Item__c plItem20 = new Apttus_Proposal__Proposal_Line_Item__c(          
          Apttus_Proposal__Quantity__c=1,
          APTS_Proposal_Business_Unit__c ='Corp OneOTC US',          
          APTS_Contract_Term__c = '1 Year',
          Apttus_QPConfig__PriceType__c='Recurring',
          Apttus_QPConfig__ChargeType__c='Subscription fee',
          Apttus_QPConfig__ConfigurationId__c = prodConfig.id, 
          Apttus_QPConfig__LineType__c = 'Product/Service',
          Apttus_QPConfig__LineNumber__c = 1,
          Apttus_QPConfig__NetPrice__c=1,
          Apttus_Proposal__Product__c=prod4.id,
          Apttus_QPConfig__LineStatus__c = 'New',
          APTS_Renewal_Type__c = 'Auto Renew',
          APTS_Term_Type__c = '',
          APTS_Contract_Term_Number__c = 24,
          Apttus_Proposal__Proposal__c=proposallist[0].id);  
          lineItemList1.add(plItem20);  
          
          Apttus_Proposal__Proposal_Line_Item__c plItem21 = new Apttus_Proposal__Proposal_Line_Item__c(          
          Apttus_Proposal__Quantity__c=1,
          APTS_Proposal_Business_Unit__c ='Corp OneOTC US',          
          APTS_Contract_Term__c = '1 Year',
          Apttus_QPConfig__PriceType__c='Recurring',
          Apttus_QPConfig__ChargeType__c='Subscription fee',
          Apttus_QPConfig__ConfigurationId__c = prodConfig.id, 
          Apttus_QPConfig__LineType__c = 'Product/Service',
          Apttus_QPConfig__LineNumber__c = 1,
          Apttus_QPConfig__NetPrice__c=1,
          Apttus_Proposal__Product__c=prod4.id,
          Apttus_QPConfig__LineStatus__c = 'New',
          APTS_Renewal_Type__c = 'Term Commitment',
          APTS_Term_Type__c = '',
          Apttus_Proposal__Proposal__c=proposallist[0].id);  
          lineItemList1.add(plItem21);
          
          Apttus_Proposal__Proposal_Line_Item__c plItem22 = new Apttus_Proposal__Proposal_Line_Item__c(          
          Apttus_Proposal__Quantity__c=1,
          APTS_Proposal_Business_Unit__c ='Corp OneOTC US',          
          APTS_Contract_Term__c = '1 Year',
          Apttus_QPConfig__PriceType__c='Recurring',
          Apttus_QPConfig__ChargeType__c='Subscription fee',
          Apttus_QPConfig__ConfigurationId__c = prodConfig.id, 
          Apttus_QPConfig__LineType__c = 'Product/Service',
          Apttus_QPConfig__LineNumber__c = 1,
          Apttus_QPConfig__NetPrice__c=1,
          Apttus_Proposal__Product__c=prod4.id,
          Apttus_QPConfig__LineStatus__c = 'New',
          APTS_Renewal_Type__c = 'Auto Renew',
          APTS_Term_Type__c = 'Co-Term',
          APTS_Contract_Term_Number__c = 12,
          Apttus_Proposal__Proposal__c=proposallist[0].id);  
          lineItemList1.add(plItem22);  
          
          Apttus_Proposal__Proposal_Line_Item__c plItem23 = new Apttus_Proposal__Proposal_Line_Item__c(          
          Apttus_Proposal__Quantity__c=1,
          APTS_Proposal_Business_Unit__c ='Corp OneOTC US',          
          APTS_Contract_Term__c = '1 Year',
          Apttus_QPConfig__PriceType__c='Recurring',
          Apttus_QPConfig__ChargeType__c='Subscription fee',
          Apttus_QPConfig__ConfigurationId__c = prodConfig.id, 
          Apttus_QPConfig__LineType__c = 'Product/Service',
          Apttus_QPConfig__LineNumber__c = 1,
          Apttus_QPConfig__NetPrice__c=1,
          Apttus_Proposal__Product__c=prod4.id,
          Apttus_QPConfig__LineStatus__c = 'New',
          APTS_Renewal_Type__c = 'Evergreen',
          APTS_Term_Type__c = 'Co-Term',
          Apttus_Proposal__Proposal__c=proposallist[0].id);  
          lineItemList1.add(plItem23);  
          
          Apttus_Proposal__Proposal_Line_Item__c plItem24 = new Apttus_Proposal__Proposal_Line_Item__c(          
          Apttus_Proposal__Quantity__c=1,
          APTS_Proposal_Business_Unit__c ='Corp OneOTC US',          
          APTS_Contract_Term__c = '1 Year',
          Apttus_QPConfig__PriceType__c='Recurring',
          Apttus_QPConfig__ChargeType__c='Subscription fee',
          Apttus_QPConfig__ConfigurationId__c = prodConfig.id, 
          Apttus_QPConfig__LineType__c = 'Product/Service',
          Apttus_QPConfig__LineNumber__c = 1,
          Apttus_QPConfig__NetPrice__c=1,
          Apttus_Proposal__Product__c=prod4.id,
          Apttus_QPConfig__LineStatus__c = 'New',
          APTS_Renewal_Type__c = 'Auto Renew',
          APTS_Term_Type__c = 'Co-Term',
          APTS_Contract_Term_Number__c = 24,
          Apttus_Proposal__Proposal__c=proposallist[0].id);  
          lineItemList1.add(plItem24);  
          
          Apttus_Proposal__Proposal_Line_Item__c plItem25 = new Apttus_Proposal__Proposal_Line_Item__c(          
          Apttus_Proposal__Quantity__c=1,
          APTS_Proposal_Business_Unit__c ='Corp OneOTC US',          
          APTS_Contract_Term__c = '1 Year',
          Apttus_QPConfig__PriceType__c='Recurring',
          Apttus_QPConfig__ChargeType__c='Subscription fee',
          Apttus_QPConfig__ConfigurationId__c = prodConfig.id, 
          Apttus_QPConfig__LineType__c = 'Product/Service',
          Apttus_QPConfig__LineNumber__c = 1,
          Apttus_QPConfig__NetPrice__c=1,
          Apttus_Proposal__Product__c=prod4.id,
          Apttus_QPConfig__LineStatus__c = 'New',
          APTS_Renewal_Type__c = 'Term Commitment',
          APTS_Term_Type__c = 'Co-Term',
          Apttus_Proposal__Proposal__c=proposallist[0].id);  
          lineItemList1.add(plItem25);
          
          Apttus_Proposal__Proposal_Line_Item__c plItem26 = new Apttus_Proposal__Proposal_Line_Item__c(          
          Apttus_Proposal__Quantity__c=1,
          APTS_Proposal_Business_Unit__c ='Corp OneOTC US',          
          APTS_Contract_Term__c = '1 Year',
          Apttus_QPConfig__PriceType__c='Recurring',
          Apttus_QPConfig__ChargeType__c='Subscription fee',
          Apttus_QPConfig__ConfigurationId__c = prodConfig.id, 
          Apttus_QPConfig__LineType__c = 'Product/Service',
          Apttus_QPConfig__LineNumber__c = 1,
          Apttus_QPConfig__NetPrice__c=1,
          Apttus_Proposal__Product__c=prod4.id,
          Apttus_QPConfig__LineStatus__c = 'New',
          APTS_Renewal_Type__c = 'Auto Renew',
          APTS_Term_Type__c = 'ProRate',
          APTS_Contract_Term_Number__c = 12,
          Apttus_Proposal__Proposal__c=proposallist[0].id);  
          lineItemList1.add(plItem26);  
          
          Apttus_Proposal__Proposal_Line_Item__c plItem27 = new Apttus_Proposal__Proposal_Line_Item__c(          
          Apttus_Proposal__Quantity__c=1,
          APTS_Proposal_Business_Unit__c ='Corp OneOTC US',          
          APTS_Contract_Term__c = '1 Year',
          Apttus_QPConfig__PriceType__c='Recurring',
          Apttus_QPConfig__ChargeType__c='Subscription fee',
          Apttus_QPConfig__ConfigurationId__c = prodConfig.id, 
          Apttus_QPConfig__LineType__c = 'Product/Service',
          Apttus_QPConfig__LineNumber__c = 1,
          Apttus_QPConfig__NetPrice__c=1,
          Apttus_Proposal__Product__c=prod4.id,
          Apttus_QPConfig__LineStatus__c = 'New',
          APTS_Renewal_Type__c = 'Evergreen',
          APTS_Term_Type__c = 'ProRate',
          Apttus_Proposal__Proposal__c=proposallist[0].id);  
          lineItemList1.add(plItem27);  
          
          Apttus_Proposal__Proposal_Line_Item__c plItem28 = new Apttus_Proposal__Proposal_Line_Item__c(          
          Apttus_Proposal__Quantity__c=1,
          APTS_Proposal_Business_Unit__c ='Corp OneOTC US',          
          APTS_Contract_Term__c = '1 Year',
          Apttus_QPConfig__PriceType__c='Recurring',
          Apttus_QPConfig__ChargeType__c='Subscription fee',
          Apttus_QPConfig__ConfigurationId__c = prodConfig.id, 
          Apttus_QPConfig__LineType__c = 'Product/Service',
          Apttus_QPConfig__LineNumber__c = 1,
          Apttus_QPConfig__NetPrice__c=1,
          Apttus_Proposal__Product__c=prod4.id,
          Apttus_QPConfig__LineStatus__c = 'New',
          APTS_Renewal_Type__c = 'Auto Renew',
          APTS_Term_Type__c = 'ProRate',
          APTS_Contract_Term_Number__c = 24,
          Apttus_Proposal__Proposal__c=proposallist[0].id);  
          lineItemList1.add(plItem28);  
          
          Apttus_Proposal__Proposal_Line_Item__c plItem29 = new Apttus_Proposal__Proposal_Line_Item__c(          
          Apttus_Proposal__Quantity__c=1,
          APTS_Proposal_Business_Unit__c ='Corp OneOTC US',          
          APTS_Contract_Term__c = '1 Year',
          Apttus_QPConfig__PriceType__c='Recurring',
          Apttus_QPConfig__ChargeType__c='Subscription fee',
          Apttus_QPConfig__ConfigurationId__c = prodConfig.id, 
          Apttus_QPConfig__LineType__c = 'Product/Service',
          Apttus_QPConfig__LineNumber__c = 1,
          Apttus_QPConfig__NetPrice__c=1,
          Apttus_Proposal__Product__c=prod4.id,
          Apttus_QPConfig__LineStatus__c = 'New',
          APTS_Renewal_Type__c = 'Term Commitment',
          APTS_Term_Type__c = 'ProRate',
          Apttus_Proposal__Proposal__c=proposallist[0].id);  
          lineItemList1.add(plItem29);
          
          Apttus_Proposal__Proposal_Line_Item__c plItem30 = new Apttus_Proposal__Proposal_Line_Item__c(          
          Apttus_Proposal__Quantity__c=1,
          APTS_Proposal_Business_Unit__c ='Corp OneOTC US',          
          APTS_Contract_Term__c = '1 Year',
          Apttus_QPConfig__PriceType__c='Recurring',
          Apttus_QPConfig__ChargeType__c='Subscription fee',
          Apttus_QPConfig__ConfigurationId__c = prodConfig.id, 
          Apttus_QPConfig__LineType__c = 'Product/Service',
          Apttus_QPConfig__LineNumber__c = 1,
          Apttus_QPConfig__NetPrice__c=1,
          Apttus_Proposal__Product__c=prod4.id,
          Apttus_QPConfig__LineStatus__c = 'New',
          APTS_Renewal_Type__c = 'Auto Renew',
          APTS_Term_Type__c = 'Co-Term and ProRate',
          APTS_Contract_Term_Number__c = 12,
          Apttus_Proposal__Proposal__c=proposallist[0].id);  
          lineItemList1.add(plItem30);  
          
          Apttus_Proposal__Proposal_Line_Item__c plItem31 = new Apttus_Proposal__Proposal_Line_Item__c(          
          Apttus_Proposal__Quantity__c=1,
          APTS_Proposal_Business_Unit__c ='Corp OneOTC US',          
          APTS_Contract_Term__c = '1 Year',
          Apttus_QPConfig__PriceType__c='Recurring',
          Apttus_QPConfig__ChargeType__c='Subscription fee',
          Apttus_QPConfig__ConfigurationId__c = prodConfig.id, 
          Apttus_QPConfig__LineType__c = 'Product/Service',
          Apttus_QPConfig__LineNumber__c = 1,
          Apttus_QPConfig__NetPrice__c=1,
          Apttus_Proposal__Product__c=prod4.id,
          Apttus_QPConfig__LineStatus__c = 'New',
          APTS_Renewal_Type__c = 'Evergreen',
          APTS_Term_Type__c = 'Co-Term and ProRate',
          Apttus_Proposal__Proposal__c=proposallist[0].id);  
          lineItemList1.add(plItem31);  
          
          Apttus_Proposal__Proposal_Line_Item__c plItem32 = new Apttus_Proposal__Proposal_Line_Item__c(          
          Apttus_Proposal__Quantity__c=1,
          APTS_Proposal_Business_Unit__c ='Corp OneOTC US',          
          APTS_Contract_Term__c = '1 Year',
          Apttus_QPConfig__PriceType__c='Recurring',
          Apttus_QPConfig__ChargeType__c='Subscription fee',
          Apttus_QPConfig__ConfigurationId__c = prodConfig.id, 
          Apttus_QPConfig__LineType__c = 'Product/Service',
          Apttus_QPConfig__LineNumber__c = 1,
          Apttus_QPConfig__NetPrice__c=1,
          Apttus_Proposal__Product__c=prod4.id,
          Apttus_QPConfig__LineStatus__c = 'New',
          APTS_Renewal_Type__c = 'Auto Renew',
          APTS_Term_Type__c = 'Co-Term and ProRate',
          APTS_Contract_Term_Number__c = 24,
          Apttus_Proposal__Proposal__c=proposallist[0].id);  
          lineItemList1.add(plItem32);  
          
          Apttus_Proposal__Proposal_Line_Item__c plItem33 = new Apttus_Proposal__Proposal_Line_Item__c(          
          Apttus_Proposal__Quantity__c=1,
          APTS_Proposal_Business_Unit__c ='Corp OneOTC US',          
          APTS_Contract_Term__c = '1 Year',
          Apttus_QPConfig__PriceType__c='Recurring',
          Apttus_QPConfig__ChargeType__c='Subscription fee',
          Apttus_QPConfig__ConfigurationId__c = prodConfig.id, 
          Apttus_QPConfig__LineType__c = 'Product/Service',
          Apttus_QPConfig__LineNumber__c = 1,
          Apttus_QPConfig__NetPrice__c=1,
          Apttus_Proposal__Product__c=prod4.id,
          Apttus_QPConfig__LineStatus__c = 'New',
          APTS_Renewal_Type__c = 'Term Commitment',
          APTS_Term_Type__c = 'Co-Term and ProRate',
          Apttus_Proposal__Proposal__c=proposallist[0].id);  
          lineItemList1.add(plItem33);
          
          Apttus_Proposal__Proposal_Line_Item__c plItem34 = new Apttus_Proposal__Proposal_Line_Item__c(          
          Apttus_Proposal__Quantity__c=1,
          APTS_Proposal_Business_Unit__c ='Corp OneOTC US',          
          APTS_Contract_Term__c = '1 Year',
          Apttus_QPConfig__PriceType__c='Recurring',
          Apttus_QPConfig__ChargeType__c='Subscription fee',
          Apttus_QPConfig__ConfigurationId__c = prodConfig.id, 
          Apttus_QPConfig__LineType__c = 'Product/Service',
          Apttus_QPConfig__LineNumber__c = 1,
          Apttus_QPConfig__NetPrice__c=1,
          Apttus_Proposal__Product__c=prod4.id,
          Apttus_QPConfig__LineStatus__c = 'New',
          APTS_Renewal_Type__c = 'Auto Renew',
          APTS_Term_Type__c = 'Delivery Date',
          APTS_Contract_Term_Number__c = 12,
          Apttus_Proposal__Proposal__c=proposallist[0].id);  
          lineItemList1.add(plItem34);  
          
          Apttus_Proposal__Proposal_Line_Item__c plItem35 = new Apttus_Proposal__Proposal_Line_Item__c(          
          Apttus_Proposal__Quantity__c=1,
          APTS_Proposal_Business_Unit__c ='Corp OneOTC US',          
          APTS_Contract_Term__c = '1 Year',
          Apttus_QPConfig__PriceType__c='Recurring',
          Apttus_QPConfig__ChargeType__c='Subscription fee',
          Apttus_QPConfig__ConfigurationId__c = prodConfig.id, 
          Apttus_QPConfig__LineType__c = 'Product/Service',
          Apttus_QPConfig__LineNumber__c = 1,
          Apttus_QPConfig__NetPrice__c=1,
          Apttus_Proposal__Product__c=prod4.id,
          Apttus_QPConfig__LineStatus__c = 'New',
          APTS_Renewal_Type__c = 'Evergreen',
          APTS_Term_Type__c = 'Delivery Date',
          Apttus_Proposal__Proposal__c=proposallist[0].id);  
          lineItemList1.add(plItem35);  
          
          Apttus_Proposal__Proposal_Line_Item__c plItem36 = new Apttus_Proposal__Proposal_Line_Item__c(          
          Apttus_Proposal__Quantity__c=1,
          APTS_Proposal_Business_Unit__c ='Corp OneOTC US',          
          APTS_Contract_Term__c = '1 Year',
          Apttus_QPConfig__PriceType__c='Recurring',
          Apttus_QPConfig__ChargeType__c='Subscription fee',
          Apttus_QPConfig__ConfigurationId__c = prodConfig.id, 
          Apttus_QPConfig__LineType__c = 'Product/Service',
          Apttus_QPConfig__LineNumber__c = 1,
          Apttus_QPConfig__NetPrice__c=1,
          Apttus_Proposal__Product__c=prod4.id,
          Apttus_QPConfig__LineStatus__c = 'New',
          APTS_Renewal_Type__c = 'Auto Renew',
          APTS_Term_Type__c = 'Delivery Date',
          APTS_Contract_Term_Number__c = 24,
          Apttus_Proposal__Proposal__c=proposallist[0].id);  
          lineItemList1.add(plItem36);  
          
          Apttus_Proposal__Proposal_Line_Item__c plItem37 = new Apttus_Proposal__Proposal_Line_Item__c(          
          Apttus_Proposal__Quantity__c=1,
          APTS_Proposal_Business_Unit__c ='Corp OneOTC US',          
          APTS_Contract_Term__c = '1 Year',
          Apttus_QPConfig__PriceType__c='Recurring',
          Apttus_QPConfig__ChargeType__c='Subscription fee',
          Apttus_QPConfig__ConfigurationId__c = prodConfig.id, 
          Apttus_QPConfig__LineType__c = 'Product/Service',
          Apttus_QPConfig__LineNumber__c = 1,
          Apttus_QPConfig__NetPrice__c=1,
          Apttus_Proposal__Product__c=prod4.id,
          Apttus_QPConfig__LineStatus__c = 'New',
          APTS_Renewal_Type__c = 'Term Commitment',
          APTS_Term_Type__c = 'Delivery Date',
          Apttus_Proposal__Proposal__c=proposallist[0].id);  
          lineItemList1.add(plItem37);
          
          Apttus_Proposal__Proposal_Line_Item__c plItem38 = new Apttus_Proposal__Proposal_Line_Item__c(          
          Apttus_Proposal__Quantity__c=1,
          APTS_Proposal_Business_Unit__c ='Corp OneOTC US',          
          APTS_Contract_Term__c = '1 Year',
          Apttus_QPConfig__PriceType__c='Recurring',
          Apttus_QPConfig__ChargeType__c='Subscription fee',
          Apttus_QPConfig__ConfigurationId__c = prodConfig.id, 
          Apttus_QPConfig__LineType__c = 'Product/Service',
          Apttus_QPConfig__LineNumber__c = 1,
          Apttus_QPConfig__NetPrice__c=1,
          Apttus_Proposal__Product__c=prod4.id,
          Apttus_QPConfig__LineStatus__c = 'Renewed',
          APTS_Renewal_Type__c = 'Auto Renew',
          APTS_Contract_Term_Number__c = 12,
          Apttus_Proposal__Proposal__c=proposallist[0].id);  
          lineItemList1.add(plItem38);  
          
          Apttus_Proposal__Proposal_Line_Item__c plItem39 = new Apttus_Proposal__Proposal_Line_Item__c(          
          Apttus_Proposal__Quantity__c=1,
          APTS_Proposal_Business_Unit__c ='Corp OneOTC US',          
          APTS_Contract_Term__c = '1 Year',
          Apttus_QPConfig__PriceType__c='Recurring',
          Apttus_QPConfig__ChargeType__c='Subscription fee',
          Apttus_QPConfig__ConfigurationId__c = prodConfig.id, 
          Apttus_QPConfig__LineType__c = 'Product/Service',
          Apttus_QPConfig__LineNumber__c = 1,
          Apttus_QPConfig__NetPrice__c=1,
          Apttus_Proposal__Product__c=prod4.id,
          Apttus_QPConfig__LineStatus__c = 'Renewed',
          APTS_Renewal_Type__c = 'Evergreen',
          Apttus_Proposal__Proposal__c=proposallist[0].id);  
          lineItemList1.add(plItem39);  
          
          Apttus_Proposal__Proposal_Line_Item__c plItem40 = new Apttus_Proposal__Proposal_Line_Item__c(          
          Apttus_Proposal__Quantity__c=1,
          APTS_Proposal_Business_Unit__c ='Corp OneOTC US',          
          APTS_Contract_Term__c = '1 Year',
          Apttus_QPConfig__PriceType__c='Recurring',
          Apttus_QPConfig__ChargeType__c='Subscription fee',
          Apttus_QPConfig__ConfigurationId__c = prodConfig.id, 
          Apttus_QPConfig__LineType__c = 'Product/Service',
          Apttus_QPConfig__LineNumber__c = 1,
          Apttus_QPConfig__NetPrice__c=1,
          Apttus_Proposal__Product__c=prod4.id,
          Apttus_QPConfig__LineStatus__c = 'Renewed',
          APTS_Renewal_Type__c = 'Auto Renew',
          APTS_Contract_Term_Number__c = 24,
          Apttus_Proposal__Proposal__c=proposallist[0].id);  
          lineItemList1.add(plItem40);  
          
          Apttus_Proposal__Proposal_Line_Item__c plItem41 = new Apttus_Proposal__Proposal_Line_Item__c(          
          Apttus_Proposal__Quantity__c=1,
          APTS_Proposal_Business_Unit__c ='Corp OneOTC US',          
          APTS_Contract_Term__c = '1 Year',
          Apttus_QPConfig__PriceType__c='Recurring',
          Apttus_QPConfig__ChargeType__c='Subscription fee',
          Apttus_QPConfig__ConfigurationId__c = prodConfig.id, 
          Apttus_QPConfig__LineType__c = 'Product/Service',
          Apttus_QPConfig__LineNumber__c = 1,
          Apttus_QPConfig__NetPrice__c=1,
          Apttus_Proposal__Product__c=prod4.id,
          Apttus_QPConfig__LineStatus__c = 'Renewed',
          APTS_Renewal_Type__c = 'Term Commitment',
          Apttus_Proposal__Proposal__c=proposallist[0].id);  
          lineItemList1.add(plItem41);
          
          Apttus_Proposal__Proposal_Line_Item__c plItems = new Apttus_Proposal__Proposal_Line_Item__c(          
          Apttus_Proposal__Quantity__c=1,
          APTS_Proposal_Business_Unit__c ='Corp OneOTC US',          
          APTS_Contract_Term__c = '1 Year',
          Apttus_QPConfig__PriceType__c='Recurring',
          Apttus_QPConfig__ChargeType__c='Subscription fee',
          Apttus_QPConfig__ConfigurationId__c = prodConfig.id, 
          Apttus_QPConfig__LineType__c = 'Product/Service',
          Apttus_QPConfig__LineNumber__c = 1,
          Apttus_QPConfig__NetPrice__c=1,
          Apttus_Proposal__Product__c=prod5.id,
          Apttus_QPConfig__LineStatus__c = 'New',
          APTS_Renewal_Type__c = 'Evergreen',
          APTS_Term_Type__c = '',
          APTS_Item_Category_Group__c = 'ZT07',
          APTS_Contract_Term_Number__c = 24,
          APTS_WLEC_Product_Category__c = 'PS',
          Apttus_Proposal__Proposal__c=proposallist[0].id);  
          lineItemList1.add(plItems); 

          Apttus_Proposal__Proposal_Line_Item__c plItems42 = new Apttus_Proposal__Proposal_Line_Item__c(          
          Apttus_Proposal__Quantity__c=1,
          APTS_Proposal_Business_Unit__c ='Corp OneOTC US',          
          APTS_Contract_Term__c = '1 Year',
          Apttus_QPConfig__PriceType__c='Recurring',
          Apttus_QPConfig__ChargeType__c='Subscription fee',
          Apttus_QPConfig__ConfigurationId__c = prodConfig.id, 
          Apttus_QPConfig__LineType__c = 'Product/Service',
          Apttus_QPConfig__LineNumber__c = 1,
          Apttus_QPConfig__NetPrice__c=1,
          Apttus_Proposal__Product__c=prod6.id,
          Apttus_QPConfig__LineStatus__c = 'New',
          APTS_Item_Category_Group__c = 'ZT07',
          APTS_Product_Pricing_Model__c = 'TAX INFORMATION REPORTING',
          APTS_Term_Type__c = '',
          Apttus_Proposal__Proposal__c=proposallist[0].id);  
          lineItemList1.add(plItems42);
          
          Apttus_Proposal__Proposal_Line_Item__c plItems43 = new Apttus_Proposal__Proposal_Line_Item__c(          
          Apttus_Proposal__Quantity__c=1,
          APTS_Proposal_Business_Unit__c ='Corp OneOTC US',          
          APTS_Contract_Term__c = '1 Year',
          Apttus_QPConfig__PriceType__c='Recurring',
          Apttus_QPConfig__ChargeType__c='Subscription fee',
          Apttus_QPConfig__ConfigurationId__c = prodConfig.id, 
          Apttus_QPConfig__LineType__c = 'Product/Service',
          Apttus_QPConfig__LineNumber__c = 1,
          Apttus_QPConfig__NetPrice__c=1,
          Apttus_Proposal__Product__c=prod6.id,
          Apttus_QPConfig__LineStatus__c = 'New',
          APTS_Pricing_Quantity__c = 10,
          Apttus_Proposal__Proposal__c=proposallist[0].id);  
          lineItemList1.add(plItems43);
          
          Apttus_Proposal__Proposal_Line_Item__c plItems44 = new Apttus_Proposal__Proposal_Line_Item__c(          
          Apttus_Proposal__Quantity__c=1,
          APTS_Proposal_Business_Unit__c ='Corp OneOTC US',          
          APTS_Contract_Term__c = '1 Year',
          Apttus_QPConfig__PriceType__c='Recurring',
          Apttus_QPConfig__ChargeType__c='Subscription fee',
          Apttus_QPConfig__ConfigurationId__c = prodConfig.id, 
          Apttus_QPConfig__LineType__c = 'Product/Service',
          Apttus_QPConfig__LineNumber__c = 1,
          Apttus_QPConfig__NetPrice__c=1,
          Apttus_Proposal__Product__c=prod6.id,
          Apttus_QPConfig__LineStatus__c = 'Renewed',
          APTS_Pricing_Quantity__c = 10,
          Apttus_Proposal__Proposal__c=proposallist[0].id);  
          lineItemList1.add(plItems44);
          
          Apttus_Proposal__Proposal_Line_Item__c plItems45 = new Apttus_Proposal__Proposal_Line_Item__c(          
          Apttus_Proposal__Quantity__c=1,
          APTS_Proposal_Business_Unit__c ='Corp OneOTC US',          
          APTS_Contract_Term__c = '5 Years',
          Apttus_QPConfig__PriceType__c='Recurring',
          Apttus_QPConfig__ChargeType__c='Subscription fee',
          Apttus_QPConfig__ConfigurationId__c = prodConfig.id, 
          Apttus_QPConfig__LineType__c = 'Product/Service',
          Apttus_QPConfig__LineNumber__c = 1,
          Apttus_QPConfig__NetPrice__c=1,
          Apttus_Proposal__Product__c=prod6.id,
          Apttus_QPConfig__LineStatus__c = 'Renewed',
          APTS_Calculated_Year_2__c = 100,
          APTS_Calculated_Year_3__c = 200,
          APTS_Calculated_Year_4__c = 300,
          APTS_Calculated_Year_5__c = 400,
          APTS_Pricing_Quantity__c = 10,
          Apttus_Proposal__Proposal__c=proposallist[0].id); 
          lineItemList1.add(plItems45);          
          
          Apttus_Proposal__Proposal_Line_Item__c plItems46 = new Apttus_Proposal__Proposal_Line_Item__c(          
          Apttus_Proposal__Quantity__c=1,
          APTS_Proposal_Business_Unit__c ='Corp OneOTC US',          
          APTS_Contract_Term__c = '5 Years',
          Apttus_QPConfig__PriceType__c='Recurring',
          Apttus_QPConfig__ChargeType__c='Subscription fee',
          Apttus_QPConfig__ConfigurationId__c = prodConfig.id, 
          Apttus_QPConfig__LineType__c = 'Product/Service',
          Apttus_QPConfig__LineNumber__c = 1,
          Apttus_QPConfig__NetPrice__c=1,
          Apttus_Proposal__Product__c=prod6.id,
          Apttus_QPConfig__LineStatus__c = 'New',
          APTS_Calculated_Year_2__c = 100,
          APTS_Calculated_Year_3__c = 200,
          APTS_Calculated_Year_4__c = 300,
          APTS_Calculated_Year_5__c = 400,
          APTS_Pricing_Quantity__c = 10,
          Apttus_Proposal__Proposal__c=proposallist[0].id);  
          lineItemList1.add(plItems46);
          
          Apttus_Proposal__Proposal_Line_Item__c plItems47 = new Apttus_Proposal__Proposal_Line_Item__c(          
          Apttus_Proposal__Quantity__c=1,
          APTS_Proposal_Business_Unit__c ='Canada',          
          APTS_Contract_Term__c = '5 Years',
          Apttus_QPConfig__PriceType__c='Recurring',
          Apttus_QPConfig__ChargeType__c='Subscription fee',
          Apttus_QPConfig__ConfigurationId__c = prodConfig.id, 
          Apttus_QPConfig__LineType__c = 'Product/Service',
          Apttus_QPConfig__LineNumber__c = 1,
          Apttus_QPConfig__NetPrice__c=1,
          Apttus_Proposal__Product__c=prod6.id,
          Apttus_QPConfig__LineStatus__c = 'New',
          APTS_Item_Category_Group__c = 'ZVAM',
          APTS_Media_High_Level_Code__c = '07',
          Apttus_Proposal__Proposal__c=proposallist[0].id);  
          
          lineItemList1.add(plItems47);
          
          Apttus_Proposal__Proposal_Line_Item__c plItems48 = new Apttus_Proposal__Proposal_Line_Item__c(          
          Apttus_Proposal__Quantity__c=1,
          APTS_Proposal_Business_Unit__c ='Corp OneOTC US',          
          APTS_Contract_Term__c = '5 Years',
          Apttus_QPConfig__PriceType__c='Recurring',
          Apttus_QPConfig__ChargeType__c='Subscription fee',
          Apttus_QPConfig__ConfigurationId__c = prodConfig.id, 
          Apttus_QPConfig__LineType__c = 'Product/Service',
          Apttus_QPConfig__LineNumber__c = 1,
          Apttus_QPConfig__NetPrice__c=1,
          Apttus_Proposal__Product__c=prod6.id,
          Apttus_QPConfig__LineStatus__c = 'New',
          APTS_FL_Renewal_Only_Clone__c = 'Yes',
          Apttus_Proposal__Proposal__c=proposallist[0].id);  
          
          lineItemList1.add(plItems48);
          
          Apttus_Proposal__Proposal_Line_Item__c plItem49 = new Apttus_Proposal__Proposal_Line_Item__c(          
          Apttus_Proposal__Quantity__c=1,
          APTS_Proposal_Business_Unit__c ='FindLaw',          
          APTS_Contract_Term__c = '4 Years',
          Apttus_QPConfig__PriceType__c='Recurring',
          Apttus_QPConfig__ChargeType__c='Subscription fee',
          Apttus_QPConfig__ConfigurationId__c = prodConfig.id, 
          Apttus_QPConfig__LineType__c = 'Product/Service',
          APTS_Online_Contacts_Validation__c=true,
          Apttus_QPConfig__LineNumber__c = 1,
          Apttus_QPConfig__NetPrice__c=1,
          Apttus_Proposal__Product__c=prod1.id,
          Apttus_QPConfig__LineStatus__c = 'New',
          Apttus_Proposal__Proposal__c=proposallist[0].id);  
          lineItemList1.add(plItem49);

          Apttus_Proposal__Proposal_Line_Item__c plItem50 = new Apttus_Proposal__Proposal_Line_Item__c(          
          Apttus_Proposal__Quantity__c=1,
          APTS_Proposal_Business_Unit__c ='FindLaw',          
          APTS_Contract_Term__c = '1 Year',
          Apttus_QPConfig__PriceType__c='One Time',
          Apttus_QPConfig__ChargeType__c='Subscription fee',
          Apttus_QPConfig__ConfigurationId__c = prodConfig.id, 
          Apttus_QPConfig__LineType__c = 'Product/Service',
          APTS_Online_Contacts_Validation__c=true,
          Apttus_QPConfig__LineNumber__c = 1,
          Apttus_QPConfig__NetPrice__c=1,
          Apttus_Proposal__Product__c=prod1.id,
          Apttus_QPConfig__LineStatus__c = 'New',
          Apttus_Proposal__Proposal__c=proposallist[0].id);  
          lineItemList1.add(plItem50);
          insert lineItemList1;
                 
          test.starttest();
          System.debug('$$$$$$$'+lineItemList1);  
          System.debug('$$$$$$$'+proposalList);
          checkRecursive.isFirstTime = true;                      
          APTS_ProposalTriggerHelper.updateLegalLanguage(proposalList);          
          test.stoptest();
    }
    
    // test method for Setting Quote/Proposal Approval Status
    static testMethod void displayApprovalDashboard() {
    
        

LTS_Disable_Application_Automation__c ltstemp = new LTS_Disable_Application_Automation__c();
        ltstemp.LTS_Disable_Process_Builders__c = true;
        ltstemp.LTS_Disable_Triggers__c = true;
        ltstemp.LTS_Disable_Validation_Rules__c = true;
        ltstemp.LTS_Disable_Workflow_Rules__c = true;
        ltstemp.Name = 'temp';
        ltstemp.SetupOwnerId = userinfo.getuserid();
        insert ltstemp;
          
        list<KeyValueListStore__c> kvListStore = new list<KeyValueListStore__c>();
        KeyValueListStore__c oStore1 = new  KeyValueListStore__c();
        oStore1.Name='ANZUsersProfileId';
        oStore1.TextValue__c=System.Label.APTS_OC_Test_Id;
        kvListStore.add(oStore1);
        KeyValueListStore__c oStore2 = new  KeyValueListStore__c();
        oStore2.Name='AptsOpportunityWinLoss';
        oStore2.TextValue__c='Won';
        kvListStore.add(oStore2);
        KeyValueListStore__c oStore3 = new  KeyValueListStore__c();
        oStore3.Name='AptsOpportunityCompetitor';
        oStore3.TextValue__c='Unknown';
        kvListStore.add(oStore3);
        KeyValueListStore__c oStore4 = new  KeyValueListStore__c();
        oStore4.Name='AptsOpportunityReason';
        oStore4.TextValue__c='Other';
        kvListStore.add(oStore4);
         KeyValueListStore__c LCRMStrikeIronFlagINS1 = new KeyValueListStore__c();
        LCRMStrikeIronFlagINS1.Name='LCRMDisableStrikeIronServices';
        LCRMStrikeIronFlagINS1.TextValue__c='True';
         kvListStore.add(LCRMStrikeIronFlagINS1);
        KeyValueListStore__c keyval = new KeyValueListStore__c();
        keyval.Name='ReasonWithCompetitor';
        keyval.TextValue__c='Price';
        kvListStore.add(keyval);
        insert kvListStore;
        Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
        Account acct = new Account(RecordTypeId=accRecordTypeId,name='test-sg',sales_org__c='WEST',customer_group__c='FIRM',customer_type__c='Organization',customer_class_c__c='Academic Lecturer');
        insert acct;
        System.assertequals('test-sg',acct.Name,'Success');
             
        Contact con1 =  new Contact(FirstName = 'FirstName1', LastName = 'LastTest1', Email = 'test.test@gmail.com', AccountId = acct.Id);
        insert con1;
                  
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
        
        Id accRecordTypeIdSSD=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByDeveloperName().get(USL_RECORDTPYE).getRecordTypeId();
        Source_System_Detail__c accountSSD= new Source_System_Detail__c();
        accountSSD.Name='ABC';
        accountSSD.Source_System_Name__c='ABC';
        accountSSD.Account_Name__c=acct.ID;
        accountSSD.LCRM_Customer_Group__c='Academic';
        accountSSD.Account_Inactive__c=false;
        accountSSD.LCRM_Sales_Org__c='WEST';
        insert accountSSD;
       
        Date todaysDate = system.today();
        Id oppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Pipeline Opportunity').getRecordTypeId();
        Opportunity opp = new Opportunity(RecordTypeId=oppRecordTypeId, Source_System_Detail__c=accountSSD.Id,isdigitalspearhead__c = TRUE, Name='tst-opp', stagename='25%',closedate=todaysDate,forecastcategoryname='Omitted',accountId=acct.id);
        insert opp;
       
        Apttus_Config2__PriceList__c price =new Apttus_Config2__PriceList__c(name='tst-pl', apttus_config2__active__c=true);
        insert price;

        
        // prepare Proposals
        List<Apttus_Proposal__Proposal__c> quoteList = new list<Apttus_Proposal__Proposal__c>();
        Id devRecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Proposal').getRecordTypeId();
        // Proposal to Set stage to Expired
        Apttus_Proposal__Proposal__c prop1 = new Apttus_Proposal__Proposal__c(RecordTypeId=devRecordTypeId, Apttus_Proposal__Proposal_Name__c = 'TST-10', 
                                                 Apttus_Proposal__Account__c = acct.id, Apttus_Proposal__Opportunity__c = opp.id, 
                                                 Apttus_Proposal__Approval_Stage__c = 'Presented', Apttus_Proposal__Proposal_Category__c = 'Quote', 
                                                 Apttus_Proposal__ReadyToGenerate__c = true, Apttus_Proposal__ReadyToPresent__c = true,
                                                 Apttus_QPConfig__PriceListId__c = price.id, APTS_Order_Confirmation_Contact__c = con1.Id,
                                                 DocuSign_Envelope_ID__c = 'envtestid1');
        quoteList.add(Prop1);          
         
        insert quoteList;
        
        Apttus_Config2__ProductConfiguration__c prodConfig = APTS_TestDataFactory.createProductConfiguration(quoteList[0].Id);
        prodConfig.Apttus_Config2__BusinessObjectId__c = quoteList[0].Id;
        prodConfig.Apttus_Config2__BusinessObjectType__c = 'Proposal';
        //prodConfig.Apttus_Config2__BillToAccountId__c = a.Id;
        prodConfig.APTS_SSD_bill_to__c= accountSSD.id;
        prodConfig.APTS_SSD_ship_to__c= accountSSD.id; 
        //prodConfig.Apttus_Config2__ShipToAccountId__c = a.Id;
        prodConfig.Apttus_Config2__AccountId__c = acct.Id;
        prodConfig.Apttus_Config2__PriceListId__c = price.Id;
        prodConfig.Apttus_Config2__Status__c = 'New';
        insert prodConfig;

        Apttus_Config2__TempObject__c objTemp = new Apttus_Config2__TempObject__c();
        objTemp.Apttus_Config2__ConfigurationId__c = prodConfig.Id;
        insert objTemp;
        
        test.starttest();
                
        prodConfig.Apttus_Config2__Status__c = 'Finalized';
        update prodConfig;
        
        Apttus_Config2__ProductConfiguration__c config1 = [select id,Apttus_Config2__Status__c  from Apttus_Config2__ProductConfiguration__c where id = :prodConfig.ID limit 1];
        system.debug('Configuration - '+ config1.Apttus_Config2__Status__c);
        
        APTS_ProposalTriggerHandler.beforeUpdate = false;
        quoteList[0].Apttus_Proposal__Approval_Stage__c = 'Accepted';
       
        checkRecursive.propsaltrgr_updateOpportunityStage  = true; //Added By Poorva
        checkRecursive.approvalDashboard = true;
        update quoteList[0];
         
        test.stoptest();

    }
   
    
   
     // test method for Setting Quote/Proposal Approval Status
    static testMethod void sendNaciFormTest() {
      Profile profileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
      User usr = new User(LastName = 'testcoverage',
                           FirstName='coverage123',
                           Alias = 'jliv',
                           Email = 'testcoverage123@asdf.com',
                           Username = 'testcoverage123@asdf.com',
                           ProfileId = profileId.id,
                           TimeZoneSidKey = 'GMT',
                           LanguageLocaleKey = 'en_US',
                           EmailEncodingKey = 'UTF-8',
                           LocaleSidKey = 'en_US',
                           Sub_Bu__c=label.SALESORGCAN
                           );
        insert usr;
        LTS_Disable_Application_Automation__c ltstemp = new LTS_Disable_Application_Automation__c();
        ltstemp.LTS_Disable_Process_Builders__c = true;
        ltstemp.LTS_Disable_Triggers__c = true;
        ltstemp.LTS_Disable_Validation_Rules__c = true;
        ltstemp.LTS_Disable_Workflow_Rules__c = true;
        ltstemp.Name = 'temp';
        ltstemp.SetupOwnerId = userinfo.getuserid();
        insert ltstemp;
        
        Apttus_Config2__PriceList__c priceList  = new Apttus_Config2__PriceList__c(Name =Label.CanadaPriceList);
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
        
        Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
        Account a = new Account(RecordTypeId=accRecordTypeId,name='test-sg',sales_org__c='ABEP',customer_group__c='Academic',customer_type__c='Organization',customer_class_c__c='Academic Lecturer');
        insert a;
        System.assertequals('test-sg',a.Name,'Success');
        Contact cont = new Contact(FirstName='Mansi',LastName='N',AccountId=a.Id,ESC_tocLanguage__c = 'English');
        insert cont;
        Id accRecordTypeIdSSD=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByDeveloperName().get(USL_RECORDTPYE).getRecordTypeId();
        Source_System_Detail__c accountSSD= new Source_System_Detail__c();
        accountSSD.Name='ABC';
        accountSSD.Source_System_Name__c='ABC';
        accountSSD.Account_Name__c=a.ID;
        accountSSD.LCRM_Customer_Group__c='Academic';
        accountSSD.Account_Inactive__c=false;
        accountSSD.LCRM_Sales_Org__c='CARS';
        insert accountSSD;
       
       Date todaysDate = system.today();
       Id oppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
       Opportunity o = new Opportunity(RecordTypeId=oppRecordTypeId, Name='tst-opp', stagename='5%',closedate=todaysDate,forecastcategoryname='Omitted',accountId=a.id,Source_System_Detail__c=accountSSD.Id);
       insert o;
       
        List<Apttus_Proposal__Proposal__c> proposalList=new List<Apttus_Proposal__Proposal__c>();
        Apttus_Proposal__Proposal__c prop =APTS_TestDataFactory.createProposal(o.id, accountSSD.Id);
        prop .Apttus_Proposal__Proposal_Name__c ='Proposal Test';
        prop .Apttus_Proposal__Primary__c =true;
        prop .Apttus_Proposal__Account__c=a.Id;
        prop .APTS_Payment_Option__c='Bill To Account';
        prop .APTS_Order_Confirmation_Contact__c=cont.id;
        prop .Digital_Quote_Type__c='Manual';
        prop .APTS_PaymentGateway_URL__c='www';
        prop.ownerid=usr.id;
        prop.APTS_SSD_Sold_To__c=accountSSD.Id;
        prop.Apttus_Proposal__Approval_Stage__c='Draft';
        prop.apts_proposal_business_unit__c=Label.SalesorgCan;
        proposalList.add(prop);
        Apttus_Proposal__Proposal__c prop1 =APTS_TestDataFactory.createProposal(o.id, accountSSD.Id);
        prop1 .Apttus_Proposal__Proposal_Name__c ='Proposal Test1';
        prop1 .Apttus_Proposal__Account__c=a.Id;
        prop1 .APTS_Payment_Option__c='Bill To Account';
        //prop1 .APTS_Order_Confirmation_Contact__c=cont.id;
        prop1 .Digital_Quote_Type__c='Manual';
        prop1 .APTS_PaymentGateway_URL__c='www';
        prop1.ownerid=usr.id;
        prop1.APTS_SSD_Sold_To__c=accountSSD.Id;
        prop1.Apttus_Proposal__Approval_Stage__c='Draft';
        prop1.apts_proposal_business_unit__c=Label.SalesorgCan;
        proposalList.add(prop1);
        Apttus_Proposal__Proposal__c prop2 =APTS_TestDataFactory.createProposal(o.id, accountSSD.Id);
        prop2 .Apttus_Proposal__Proposal_Name__c ='Proposal Test2';
        prop2 .Apttus_Proposal__Account__c=a.Id;
        prop2 .APTS_Payment_Option__c='Bill To Account';
        prop2 .APTS_Order_Confirmation_Contact__c=cont.id;
        prop2 .Digital_Quote_Type__c='Manual';
        prop2 .APTS_PaymentGateway_URL__c='www';
        prop2.ownerid=usr.id;
        prop2.APTS_SSD_Sold_To__c=accountSSD.Id;
        prop2.Apttus_Proposal__Approval_Stage__c='Draft';
        prop2.apts_proposal_business_unit__c=Label.SalesorgCan;
        proposalList.add(prop2);
        Apttus_Proposal__Proposal__c prop3 =APTS_TestDataFactory.createProposal(o.id, accountSSD.Id);
        prop3 .Apttus_Proposal__Proposal_Name__c ='Proposal Test3';
        prop3 .Apttus_Proposal__Account__c=a.Id;
        prop3 .APTS_Payment_Option__c='Bill To Account';
        prop3 .APTS_Order_Confirmation_Contact__c=cont.id;
        prop3 .Digital_Quote_Type__c='Manual';
        prop3 .APTS_PaymentGateway_URL__c='www';
        prop3.ownerid=usr.id;
        prop3.APTS_SSD_Sold_To__c=accountSSD.Id;
        prop3.Apttus_Proposal__Approval_Stage__c='Draft';
        prop3.apts_proposal_business_unit__c=Label.SalesorgCan;
        proposalList.add(prop3);
       // Insert proposal
       insert proposalList;  
       
       List<Apttus_Config2__ProductConfiguration__c> prodconfigList    =new List<Apttus_Config2__ProductConfiguration__c>();
        Apttus_Config2__ProductConfiguration__c prodConfig = APTS_TestDataFactory.createProductConfiguration(proposallist[0].Id);
        prodConfig.Apttus_Config2__BusinessObjectId__c = proposallist[0].Id;
        prodConfig.Apttus_Config2__BusinessObjectType__c = 'Proposal';
        prodConfig.APTS_SSD_bill_to__c = accountSSD.Id;
        prodConfig.APTS_SSD_ship_to__c = accountSSD.Id;

        prodConfig.Apttus_Config2__AccountId__c = a.Id;
        prodConfig.Apttus_Config2__PriceListId__c = priceList.Id;
        prodConfig.Apttus_Config2__Status__c = 'New';
       prodconfigList.add(prodConfig);
       Apttus_Config2__ProductConfiguration__c prodConfig1 = APTS_TestDataFactory.createProductConfiguration(proposallist[1].Id);
       prodConfig1.Apttus_Config2__BusinessObjectId__c = proposallist[1].Id;
        prodConfig1.Apttus_Config2__BusinessObjectType__c = 'Proposal';
        prodConfig1.APTS_SSD_bill_to__c = accountSSD.Id;
        prodConfig1.APTS_SSD_ship_to__c = accountSSD.Id;

        prodConfig1.Apttus_Config2__AccountId__c = a.Id;
        prodConfig1.Apttus_Config2__PriceListId__c = priceList.Id;
        prodConfig1.Apttus_Config2__Status__c = 'New';
       prodconfigList.add(prodConfig1);
       Apttus_Config2__ProductConfiguration__c prodConfig2 = APTS_TestDataFactory.createProductConfiguration(proposallist[2].Id);
       prodConfig2.Apttus_Config2__BusinessObjectId__c = proposallist[2].Id;
        prodConfig2.Apttus_Config2__BusinessObjectType__c = 'Proposal';
        prodConfig2.APTS_SSD_bill_to__c = accountSSD.Id;
        prodConfig2.APTS_SSD_ship_to__c = accountSSD.Id;

        prodConfig2.Apttus_Config2__AccountId__c = a.Id;
        prodConfig2.Apttus_Config2__PriceListId__c = priceList.Id;
        prodConfig2.Apttus_Config2__Status__c = 'New';
       prodconfigList.add(prodConfig2);
       Apttus_Config2__ProductConfiguration__c prodConfig3 = APTS_TestDataFactory.createProductConfiguration(proposallist[3].Id);
       prodConfig3.Apttus_Config2__BusinessObjectId__c = proposallist[3].Id;
        prodConfig3.Apttus_Config2__BusinessObjectType__c = 'Proposal';
        prodConfig3.APTS_SSD_bill_to__c = accountSSD.Id;
        prodConfig3.APTS_SSD_ship_to__c = accountSSD.Id;

        prodConfig3.Apttus_Config2__AccountId__c = a.Id;
        prodConfig3.Apttus_Config2__PriceListId__c = priceList.Id;
        prodConfig3.Apttus_Config2__Status__c = 'New';
       prodconfigList.add(prodConfig3);
       insert prodconfigList;
       List<Apttus_Proposal__Proposal_Line_Item__c> lineItemList1 = new List<Apttus_Proposal__Proposal_Line_Item__c>();
       List<Apttus_Proposal__Proposal_Line_Item__c> lineItemList2 = new List<Apttus_Proposal__Proposal_Line_Item__c>();
       List<Apttus_Proposal__Proposal_Line_Item__c> lineItemList3 = new List<Apttus_Proposal__Proposal_Line_Item__c>();
       List<Apttus_Proposal__Proposal_Line_Item__c> lineItemList4 = new List<Apttus_Proposal__Proposal_Line_Item__c>();
       
          Apttus_Proposal__Proposal_Line_Item__c plItem1 = new Apttus_Proposal__Proposal_Line_Item__c(          
          Apttus_Proposal__Quantity__c=1,
          APTS_Proposal_Business_Unit__c =Label.SALESORGCAN,          
          APTS_Contract_Term__c = '4 Years',
          Apttus_QPConfig__PriceType__c='Recurring',
          Apttus_QPConfig__Frequency__c ='Monthly',
          Apttus_QPConfig__ChargeType__c='Subscription fee',
          Apttus_QPConfig__ConfigurationId__c = prodConfig.id, 
          Apttus_QPConfig__LineType__c = 'Product/Service',
          Apttus_QPConfig__LineNumber__c = 1,          
          Apttus_QPConfig__NetPrice__c=400,
          Apttus_QPConfig__LineStatus__c = 'New',
          Apttus_Proposal__Proposal__c=proposallist[0].id);
          lineItemList1.add(plItem1);
          insert lineItemList1;
          Apttus_Proposal__Proposal_Line_Item__c plItem2 = new Apttus_Proposal__Proposal_Line_Item__c(          
          Apttus_Proposal__Quantity__c=1,
          APTS_Proposal_Business_Unit__c =Label.SALESORGCAN,          
          APTS_Contract_Term__c = '4 Years',
          Apttus_QPConfig__PriceType__c='Recurring',
          Apttus_QPConfig__Frequency__c ='Yearly',
          Apttus_QPConfig__ChargeType__c='Subscription fee',
          Apttus_QPConfig__ConfigurationId__c = prodConfig1.id, 
          Apttus_QPConfig__LineType__c = 'Product/Service',
          Apttus_QPConfig__LineNumber__c = 1,          
          Apttus_QPConfig__NetPrice__c=5000,
          Apttus_QPConfig__LineStatus__c = 'New',
          Apttus_Proposal__Proposal__c=proposallist[1].id);
          lineItemList2.add(plItem2);
          insert lineItemList2;
          Apttus_Proposal__Proposal_Line_Item__c plItem3 = new Apttus_Proposal__Proposal_Line_Item__c(          
          Apttus_Proposal__Quantity__c=1,
          APTS_Proposal_Business_Unit__c =Label.SALESORGCAN,          
          APTS_Contract_Term__c = '4 Years',
          Apttus_QPConfig__PriceType__c='One Time',
          Apttus_QPConfig__ChargeType__c='Subscription fee',
          Apttus_QPConfig__ConfigurationId__c = prodConfig2.id, 
          Apttus_QPConfig__LineType__c = 'Product/Service',
          Apttus_QPConfig__LineNumber__c = 1,          
          Apttus_QPConfig__NetPrice__c=5000,
          Apttus_QPConfig__LineStatus__c = 'New',
          Apttus_Proposal__Proposal__c=proposallist[2].id);
          lineItemList3.add(plItem3);
          insert lineItemList3;
          Apttus_Proposal__Proposal_Line_Item__c plItem4 = new Apttus_Proposal__Proposal_Line_Item__c(          
          Apttus_Proposal__Quantity__c=1,
          APTS_Proposal_Business_Unit__c =Label.SALESORGCAN,          
          APTS_Contract_Term__c = '4 Years',
          Apttus_QPConfig__PriceType__c='Recurring',
          Apttus_QPConfig__Frequency__c ='Monthly',
          Apttus_QPConfig__ChargeType__c='Subscription fee',
          Apttus_QPConfig__ConfigurationId__c = prodConfig3.id, 
          Apttus_QPConfig__LineType__c = 'Product/Service',
          Apttus_QPConfig__LineNumber__c = 1,          
          Apttus_QPConfig__NetPrice__c=400,
          Apttus_QPConfig__LineStatus__c = 'New',
          Apttus_Proposal__Proposal__c=proposallist[3].id);
          lineItemList4.add(plItem4);
          
          Apttus_Proposal__Proposal_Line_Item__c plItem5 = new Apttus_Proposal__Proposal_Line_Item__c(          
          Apttus_Proposal__Quantity__c=1,
          APTS_Proposal_Business_Unit__c =Label.SALESORGCAN,          
          APTS_Contract_Term__c = '4 Years',
          Apttus_QPConfig__PriceType__c='Recurring',
          Apttus_QPConfig__Frequency__c ='Yearly',
          Apttus_QPConfig__ChargeType__c='Subscription fee',
          Apttus_QPConfig__ConfigurationId__c = prodConfig3.id, 
          Apttus_QPConfig__LineType__c = 'Product/Service',
          Apttus_QPConfig__LineNumber__c = 2,          
          Apttus_QPConfig__NetPrice__c=3700,   
          Apttus_QPConfig__LineStatus__c = 'New',
          Apttus_Proposal__Proposal__c=proposallist[3].id);
          lineItemList4.add(plItem5);
          insert lineItemList4;
          proposallist[0].APTS_Payment_Option__c='Bill to Account';
          proposallist[1].APTS_Payment_Option__c='Bill to Account';
          proposallist[2].APTS_Payment_Option__c='Bill to Account';
          proposallist[3].APTS_Payment_Option__c='Bill to Account';
          update proposallist;
          Test.startTest();
          Map<Id,Boolean> map1=APTS_ProposalTriggerHelper.sendNaciForm(proposallist[0],lineItemList1);
          Map<Id,Boolean> map2=APTS_ProposalTriggerHelper.sendNaciForm(proposallist[1],lineItemList2);
          Map<Id,Boolean> map3=APTS_ProposalTriggerHelper.sendNaciForm(proposallist[2],lineItemList3);
          Map<Id,Boolean> map4=APTS_ProposalTriggerHelper.sendNaciForm(proposallist[3],lineItemList4);  
          System.assertEquals(map1.get(proposallist[0].id), true);
          System.assertEquals(map2.get(proposallist[1].id), true);
          System.assertEquals(map3.get(proposallist[2].id), true);
          System.assertEquals(map4.get(proposallist[3].id), true);
          Test.stopTest();
    }
    static testMethod void displayApprovalDashboardTK() {
    
        

LTS_Disable_Application_Automation__c ltstemp = new LTS_Disable_Application_Automation__c();
        ltstemp.LTS_Disable_Process_Builders__c = true;
        ltstemp.LTS_Disable_Triggers__c = true;
        ltstemp.LTS_Disable_Validation_Rules__c = true;
        ltstemp.LTS_Disable_Workflow_Rules__c = true;
        ltstemp.Name = 'temp';
        ltstemp.SetupOwnerId = userinfo.getuserid();
        insert ltstemp;
          
        list<KeyValueListStore__c> kvListStore = new list<KeyValueListStore__c>();
        KeyValueListStore__c oStore1 = new  KeyValueListStore__c();
        oStore1.Name='ANZUsersProfileId';
        oStore1.TextValue__c=System.Label.APTS_OC_Test_Id;
        kvListStore.add(oStore1);
        KeyValueListStore__c oStore2 = new  KeyValueListStore__c();
        oStore2.Name='AptsOpportunityWinLoss';
        oStore2.TextValue__c='Won';
        kvListStore.add(oStore2);
        KeyValueListStore__c oStore3 = new  KeyValueListStore__c();
        oStore3.Name='AptsOpportunityCompetitor';
        oStore3.TextValue__c='Unknown';
        kvListStore.add(oStore3);
        KeyValueListStore__c oStore4 = new  KeyValueListStore__c();
        oStore4.Name='AptsOpportunityReason';
        oStore4.TextValue__c='Other';
        kvListStore.add(oStore4);
         KeyValueListStore__c LCRMStrikeIronFlagINS1 = new KeyValueListStore__c();
        LCRMStrikeIronFlagINS1.Name='LCRMDisableStrikeIronServices';
        LCRMStrikeIronFlagINS1.TextValue__c='True';
         kvListStore.add(LCRMStrikeIronFlagINS1);
        KeyValueListStore__c keyval = new KeyValueListStore__c();
        keyval.Name='ReasonWithCompetitor';
        keyval.TextValue__c='Price';
        kvListStore.add(keyval);
        insert kvListStore;
        Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
        Account acct = new Account(RecordTypeId=accRecordTypeId,name='test-sg',sales_org__c='WEST',customer_group__c='FIRM',customer_type__c='Organization',customer_class_c__c='Academic Lecturer');
        insert acct;
        System.assertequals('test-sg',acct.Name,'Success');
             
        Contact con1 =  new Contact(FirstName = 'FirstName1', LastName = 'LastTest1', Email = 'test.test@gmail.com', AccountId = acct.Id);
        insert con1;
                  
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
        
        Id accRecordTypeIdSSD=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByDeveloperName().get(USL_RECORDTPYE).getRecordTypeId();
        Source_System_Detail__c accountSSD= new Source_System_Detail__c();
        accountSSD.Name='ABC';
        accountSSD.Source_System_Name__c='ABC';
        accountSSD.Account_Name__c=acct.ID;
        accountSSD.LCRM_Customer_Group__c='Academic';
        accountSSD.Account_Inactive__c=false;
        accountSSD.LCRM_Sales_Org__c='WEST';
        insert accountSSD;
       
        Date todaysDate = system.today();
        Id oppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Pipeline Opportunity').getRecordTypeId();
        Opportunity opp = new Opportunity(RecordTypeId=oppRecordTypeId, Source_System_Detail__c=accountSSD.Id,isdigitalspearhead__c = TRUE, Name='tst-opp', stagename='25%',closedate=todaysDate,forecastcategoryname='Omitted',accountId=acct.id);
        insert opp;
       
        Apttus_Config2__PriceList__c price =new Apttus_Config2__PriceList__c(name='tst-pl', apttus_config2__active__c=true);
        insert price;

        
        // prepare Proposals
        List<Apttus_Proposal__Proposal__c> quoteList = new list<Apttus_Proposal__Proposal__c>();
        Id devRecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Proposal').getRecordTypeId();
        // Proposal to Set stage to Expired
        Apttus_Proposal__Proposal__c prop1 = new Apttus_Proposal__Proposal__c(RecordTypeId=devRecordTypeId, Apttus_Proposal__Proposal_Name__c = 'TST-10', 
                                                 Apttus_Proposal__Account__c = acct.id, Apttus_Proposal__Opportunity__c = opp.id, 
                                                 Apttus_Proposal__Approval_Stage__c = 'Presented', Apttus_Proposal__Proposal_Category__c = 'Quote', 
                                                 Apttus_Proposal__ReadyToGenerate__c = true, Apttus_Proposal__ReadyToPresent__c = true,
                                                 Apttus_QPConfig__PriceListId__c = price.id, APTS_Order_Confirmation_Contact__c = con1.Id,
                                                 DocuSign_Envelope_ID__c = 'envtestid1',APTS_Proposal_Business_Unit__c='Findlaw');
        quoteList.add(Prop1);          
         
        insert quoteList;
        
        Apttus_Config2__ProductConfiguration__c prodConfig = APTS_TestDataFactory.createProductConfiguration(quoteList[0].Id);
        prodConfig.Apttus_Config2__BusinessObjectId__c = quoteList[0].Id;
        prodConfig.Apttus_Config2__BusinessObjectType__c = 'Proposal';
        //prodConfig.Apttus_Config2__BillToAccountId__c = a.Id;
        prodConfig.APTS_SSD_bill_to__c= accountSSD.id;
        prodConfig.APTS_SSD_ship_to__c= accountSSD.id; 
        //prodConfig.Apttus_Config2__ShipToAccountId__c = a.Id;
        prodConfig.Apttus_Config2__AccountId__c = acct.Id;
        prodConfig.Apttus_Config2__PriceListId__c = price.Id;
        prodConfig.Apttus_Config2__Status__c = 'New';
        insert prodConfig;

        Apttus_Config2__TempObject__c objTemp = new Apttus_Config2__TempObject__c();
        objTemp.Apttus_Config2__ConfigurationId__c = prodConfig.Id;
        insert objTemp;
        
        test.starttest();
                
        prodConfig.Apttus_Config2__Status__c = 'Finalized';
        update prodConfig;
        
        Apttus_Config2__ProductConfiguration__c config1 = [select id,Apttus_Config2__Status__c  from Apttus_Config2__ProductConfiguration__c where id = :prodConfig.ID limit 1];
        system.debug('Configuration - '+ config1.Apttus_Config2__Status__c);
        
        APTS_ProposalTriggerHandler.beforeUpdate = false;
        quoteList[0].Apttus_Proposal__Approval_Stage__c = 'Accepted';
       
        checkRecursive.propsaltrgr_updateOpportunityStage  = true; //Added By Poorva
        checkRecursive.approvalDashboard = true;
        update quoteList[0];
         
        test.stoptest();

    }
    static testMethod void updateproposal() {
     LTS_Disable_Application_Automation__c ltstemp = new LTS_Disable_Application_Automation__c();
        ltstemp.LTS_Disable_Process_Builders__c = true;
        ltstemp.LTS_Disable_Triggers__c = true;
        ltstemp.LTS_Disable_Validation_Rules__c = true;
        ltstemp.LTS_Disable_Workflow_Rules__c = true;
        ltstemp.Name = 'temp';
        ltstemp.SetupOwnerId = userinfo.getuserid();
        insert ltstemp;
        
        list<KeyValueListStore__c> kvListStore = new list<KeyValueListStore__c>();
        KeyValueListStore__c oStore1 = new  KeyValueListStore__c();
        oStore1.Name='ANZUsersProfileId';
        oStore1.TextValue__c=System.Label.APTS_OC_Test_Id;
        kvListStore.add(oStore1);
        KeyValueListStore__c oStore2 = new  KeyValueListStore__c();
        oStore2.Name='AptsOpportunityWinLoss';
        oStore2.TextValue__c='Won';
        kvListStore.add(oStore2);
        KeyValueListStore__c oStore3 = new  KeyValueListStore__c();
        oStore3.Name='AptsOpportunityCompetitor';
        oStore3.TextValue__c='Unknown';
        kvListStore.add(oStore3);
        KeyValueListStore__c oStore4 = new  KeyValueListStore__c();
        oStore4.Name='AptsOpportunityReason';
        oStore4.TextValue__c='Other';
        kvListStore.add(oStore4);
            KeyValueListStore__c LCRMStrikeIronFlagINS1 = new KeyValueListStore__c();
        LCRMStrikeIronFlagINS1.Name='LCRMDisableStrikeIronServices';
        LCRMStrikeIronFlagINS1.TextValue__c='True';
         kvListStore.add(LCRMStrikeIronFlagINS1);
        KeyValueListStore__c keyval = new KeyValueListStore__c();
        keyval.Name='ReasonWithCompetitor';
        keyval.TextValue__c='Price';
        kvListStore.add(keyval);
        insert kvListStore;
           
           Profile profile = [SELECT Id FROM profile WHERE name='System Administrator'];
            
           User u1 = new User(Alias = 'standt1',Country='US',Email='demo1@randomdemodomain.com',EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',LocaleSidKey='en_US',ProfileId = profile.Id,TimeZoneSidKey='America/Los_Angeles', UserName='dprobertdemo1545@camfed.org', Segment__c = 'Professional Tax');
           insert u1;


            Apttus_Config2__PriceList__c priceList = APTS_TestDataFactory.createPriceList('Thomson Reuters Master - US Legal');

            insert priceList;
            
            Schema.DescribeFieldResult fieldResultMarket = Apttus_Config2__ProductConfiguration__c.APTS_AccountMirror_Picklist__c.getDescribe();
            String valueMarket = fieldResultMarket.getPicklistValues().get(0).getValue();
            
            List<KeyValueListStore__c> keyvaluestoreList=new List<KeyValueListStore__c>();
            KeyValueListStore__c keyvaluestore=new  KeyValueListStore__c();
            keyvaluestore.Name='ANZUsersProfileId';
            keyvaluestore.TextValue__c=System.Label.APTS_OC_Test_Id;
            
            KeyValueListStore__c LCRMStrikeIronFlagINS2 = new KeyValueListStore__c();
            LCRMStrikeIronFlagINS2.Name='LCRMDisableStrikeIronServices';
            LCRMStrikeIronFlagINS2.TextValue__c='True';
            keyvaluestoreList.add(LCRMStrikeIronFlagINS2 );
            keyvaluestoreList.add(keyvaluestore);
            
            KeyValueListStore__c keyval2 = new KeyValueListStore__c();
            keyval2.Name='ReasonWithCompetitor';
            keyval2.TextValue__c='Price';
            keyvaluestoreList.add(keyval2);
            
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
            
           
          
            Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
            Account a = new Account(RecordTypeId=accRecordTypeId,name='test-sg',sales_org__c='ABEP',customer_group__c='Academic',customer_type__c='Organization',customer_class_c__c='Academic Lecturer');
            insert a;
            System.assertequals('test-sg',a.Name,'Success');
            Id accRecordTypeIdSSD=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByDeveloperName().get(USL_RECORDTPYE).getRecordTypeId();
            
            
            
            Source_System_Detail__c accountSSD= new Source_System_Detail__c();
            accountSSD.Name='ABC';
            accountSSD.Source_System_Name__c='ABC';
            accountSSD.Account_Name__c=a.ID;
            accountSSD.LCRM_Customer_Group__c='Academic';
            accountSSD.LCRM_Frozen_Market_Segment__c = valueMarket;
            accountSSD.Account_Inactive__c=false;
            accountSSD.LCRM_Sales_Org__c='S100';
            accountSSD.Billing_Currency__c = 'USD';
            
            insert accountSSD;
            
           
           //System.runAs(u1){ 
           
           Date todaysDate = system.today();
           Id oppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
           List<Opportunity> oppList = new List<Opportunity>();
           Opportunity o = new Opportunity(RecordTypeId=oppRecordTypeId, Name='tst-opp1', stagename='Appointment Scheduled',closedate=todaysDate,forecastcategoryname='pipeline',accountId=a.id,Source_System_Detail__c=accountSSD.Id);
           oppList.add(o);
           
           Opportunity oppRandom1 = new Opportunity(RecordTypeId=oppRecordTypeId,isdigitalspearhead__c = TRUE,Name='tst-opp2', stagename='Appointment Scheduled',closedate=todaysDate,forecastcategoryname='pipeline',accountId=a.id,Source_System_Detail__c=accountSSD.Id);
           oppList.add(oppRandom1);
           
           Opportunity oppRandom2 = new Opportunity(RecordTypeId=oppRecordTypeId, Name='tst-op3', stagename='Appointment Scheduled',closedate=todaysDate,forecastcategoryname='pipeline',accountId=a.id,Source_System_Detail__c=accountSSD.Id);
           oppList.add(oppRandom2);
           
           insert oppList;
            
            Id devRecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Proposal').getRecordTypeId();
            
           List<Apttus_Proposal__Proposal__c> propList = new List<Apttus_Proposal__Proposal__c>();
       List<Apttus_Proposal__Proposal__c> updatepropList = new List<Apttus_Proposal__Proposal__c>();
       List < Apttus_Proposal__Proposal__c > digitalProposals = new List < Apttus_Proposal__Proposal__c > ();
       
           
           Apttus_Proposal__Proposal__c prop1 = new Apttus_Proposal__Proposal__c(RecordTypeId=devRecordTypeId,Apttus_Proposal__Primary__c =true,
                Apttus_Proposal__Proposal_Name__c='TST-10', Apttus_Proposal__Opportunity__c=o.id, Apttus_Proposal__Account__c=a.id,
                APTS_SSD_Sold_To__c = accountSSD.Id, Apttus_Proposal__Approval_Stage__c='Draft', Apttus_Proposal__Proposal_Category__c='Quote',
                 Apttus_Proposal__ReadyToGenerate__c = true, Apttus_Proposal__ReadyToPresent__c= true,APTS_Proposal_Business_Unit__c = 'Tax Professional',
                 APTS_Approval_Segment__c='Government', Apttus_QPConfig__PriceListId__c=priceList.id);

           propList.add(prop1);
           Apttus_Proposal__Proposal__c prop2 = new Apttus_Proposal__Proposal__c(RecordTypeId=devRecordTypeId,Apttus_Proposal__Primary__c =true,
                Apttus_Proposal__Proposal_Name__c='TST-10', Apttus_Proposal__Opportunity__c=oppRandom1.id, Apttus_Proposal__Account__c=a.id,
                APTS_SSD_Sold_To__c = accountSSD.Id, Apttus_Proposal__Approval_Stage__c='Draft', Apttus_Proposal__Proposal_Category__c='Quote',
                 Apttus_Proposal__ReadyToGenerate__c = true, Apttus_Proposal__ReadyToPresent__c= true,APTS_Proposal_Business_Unit__c = 'Tax Professional',
                 APTS_Approval_Segment__c='Government',SAP_Credit_Check_Status__c='Fail',Apttus_QPConfig__PriceListId__c=priceList.id);

           propList.add(prop2);
           Apttus_Proposal__Proposal__c prop3 = new Apttus_Proposal__Proposal__c(RecordTypeId=devRecordTypeId,Apttus_Proposal__Primary__c =true,
                Apttus_Proposal__Proposal_Name__c='TST-10', Apttus_Proposal__Opportunity__c=oppRandom2.id, Apttus_Proposal__Account__c=a.id,
                APTS_SSD_Sold_To__c = accountSSD.Id, Apttus_Proposal__Approval_Stage__c='Draft', Apttus_Proposal__Proposal_Category__c='Quote',
                 Apttus_Proposal__ReadyToGenerate__c = true, Apttus_Proposal__ReadyToPresent__c= true,APTS_Proposal_Business_Unit__c = 'Tax Professional',
                 APTS_Approval_Segment__c='Government',Latam_APTS_Win_Loss__c='Won',Latam_APTS_Reason__c='Brand',Apttus_QPConfig__PriceListId__c=priceList.id,DocuSign_Envelope_ID__c = 'envtestid3');

           propList.add(prop3);
           
                Apttus_Proposal__Proposal__c prop4 = new Apttus_Proposal__Proposal__c(RecordTypeId=devRecordTypeId,Apttus_Proposal__Primary__c =true,
                Apttus_Proposal__Proposal_Name__c='TST-10', Apttus_Proposal__Opportunity__c=oppRandom2.id, Apttus_Proposal__Account__c=a.id,
                APTS_SSD_Sold_To__c = accountSSD.Id, Apttus_Proposal__Approval_Stage__c='Draft', Apttus_Proposal__Proposal_Category__c='Quote',
                 Apttus_Proposal__ReadyToGenerate__c = true, Apttus_Proposal__ReadyToPresent__c= true, APTS_Proposal_Business_Unit__c = 'Tax Professional',
                 APTS_Approval_Segment__c='Government',Latam_APTS_Win_Loss__c='Won',Latam_APTS_Reason__c='Brand',Apttus_QPConfig__PriceListId__c=priceList.id,DocuSign_Envelope_ID__c = 'envtestid4');

           propList.add(prop4);
           insert propList;
            
      List<Apttus_Config2__ProductConfiguration__c> confList = new List<Apttus_Config2__ProductConfiguration__c>();
            Apttus_Config2__ProductConfiguration__c conf=new Apttus_Config2__ProductConfiguration__c(
            Name='ABC', Apttus_QPConfig__Proposald__c=prop3.id,
            Apttus_Config2__Status__c='Finalized',Apttus_Config2__PriceListId__c=priceList.id);
            confList.add(conf);
      //insert conf;
            
            Apttus_Config2__ProductConfiguration__c conf1=new Apttus_Config2__ProductConfiguration__c(
            Name='ABC', Apttus_QPConfig__Proposald__c=prop4.id,
            Apttus_Config2__Status__c='Finalized',Apttus_Config2__PriceListId__c=priceList.id);
      confList.add(conf1);
            //insert conf1;
      insert confList;
            
            Product2 prod=new Product2(Name='TEst', IsActive=true, Apttus_Config2__ConfigurationType__c='standalone', APTS_Eligibility_All__c=true,
            ProductCode='ABC123');
            insert prod;
            
            Apttus_Config2__PriceListItem__c pli=new Apttus_Config2__PriceListItem__c(Apttus_Config2__Active__c=true,
            Apttus_Config2__ProductId__c=prod.id,
            Apttus_Config2__PriceListId__c=priceList.id);
            insert pli;
            
      List<Apttus_Config2__LineItem__c> liList1 = new List<Apttus_Config2__LineItem__c>();
            Apttus_Config2__LineItem__c lineItem=new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c=conf.id,
            Apttus_Config2__LineType__c='Product/Service',Apttus_Config2__ProductId__c=prod.id, 
            Apttus_Config2__PriceListId__c=priceList.id, Apttus_Config2__PriceListItemId__c=pli.id, Apttus_Config2__ItemSequence__c = 1, Apttus_Config2__LineNumber__c = 1);
            liList1.add(lineItem);
            //insert lineItem;
            
            Apttus_Config2__LineItem__c lineItem1=new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c=conf1.id,
            Apttus_Config2__LineType__c='Product/Service',Apttus_Config2__ProductId__c=prod.id, 
            Apttus_Config2__PriceListId__c=priceList.id, Apttus_Config2__PriceListItemId__c=pli.id, Apttus_Config2__ItemSequence__c = 1, Apttus_Config2__LineNumber__c = 1);
      liList1.add(lineItem1);            
            //insert lineItem1;
      insert liList1;
            
      List<Apttus_Proposal__Proposal_Line_Item__c> pliList1 = new List<Apttus_Proposal__Proposal_Line_Item__c>();
            Apttus_Proposal__Proposal_Line_Item__c propLiI=new Apttus_Proposal__Proposal_Line_Item__c(
            APTS_Proposal_Business_Unit__c='Tax Professional', Apttus_Proposal__Proposal__c=prop3.id, APTS_Renewal_Type__c='Auto Renew', Apttus_QPConfig__LineStatus__c = 'Renewed');
            pliList1.add(propLiI);
           // insert propLiI;
            
            Apttus_Proposal__Proposal_Line_Item__c propLiI1=new Apttus_Proposal__Proposal_Line_Item__c(
            APTS_Proposal_Business_Unit__c='Tax Professional', Apttus_Proposal__Proposal__c=prop4.id, APTS_Renewal_Type__c='Term Commitment', Apttus_QPConfig__LineStatus__c = 'Renewed');
            pliList1.add(propLiI1);
            //insert propLiI1;
      insert pliList1;
            
      List<Apttus_Config2__AssetLineItem__c> aliList1= new List<Apttus_Config2__AssetLineItem__c>();
            Apttus_Config2__AssetLineItem__c aLI=new Apttus_Config2__AssetLineItem__c(Name='ABC', Apttus_QPConfig__ProposalId__c=prop3.id,
            Apttus_Config2__ProductId__c=prod.id, APTS_SSD_Sold_To__c=accountSSD.id, Apttus_Config2__AssetStatus__c='Activated', 
            APTS_Renewal_Type__c='Auto Renew', Apttus_QPConfig__ProposalLineItemId__c=propLiI.id,APTS_Proposal_Business_Unit__c='Tax Professional');
            aliList1.add(aLI);
            //insert aLI;
            
            Apttus_Config2__AssetLineItem__c aLI1=new Apttus_Config2__AssetLineItem__c(Name='ABC', Apttus_QPConfig__ProposalId__c=prop4.id,
            Apttus_Config2__ProductId__c=prod.id, APTS_SSD_Sold_To__c=accountSSD.id, Apttus_Config2__AssetStatus__c='Activated', 
            APTS_Renewal_Type__c='Term Commitment', Apttus_QPConfig__ProposalLineItemId__c=propLiI1.id,APTS_Proposal_Business_Unit__c='Tax Professional');
            aliList1.add(aLI1);
            insert aliList1;
            
            
            test.startTest();
     
            checkRecursive.propsaltrgr_createOrderAndAssetLineItems=true;
            prop3.Apttus_Proposal__Approval_Stage__c ='Accepted'; 
            updatepropList.add(prop3);
            //update prop3;
            prop4.Apttus_Proposal__Approval_Stage__c ='Accepted';
            updatepropList.add(prop4);
            //update prop4;
            update updatepropList;
            
            
        List<Apttus_DocuApi__DocuSignEnvelope__c> envList = new list<Apttus_DocuApi__DocuSignEnvelope__c>();     
        Apttus_DocuApi__DocuSignEnvelope__c Env3 = new Apttus_DocuApi__DocuSignEnvelope__c();
        Env3.APTTUS_DOCUAPI__STATUS__C = 'sent'; 
        Env3.Apttus_QPDSign__QuoteProposal__c = prop3.Id;
        Env3.Apttus_DocuApi__ParentId__c = prop3.Id;
        Env3.Apttus_DocuApi__EnvelopeId__c = 'envtestid3'; 
        Env3.APTTUS_DOCUAPI__RECALLREASON__C = '';
        envList.add(Env3);
        
        Apttus_DocuApi__DocuSignEnvelope__c Env4 = new Apttus_DocuApi__DocuSignEnvelope__c();
        Env4.APTTUS_DOCUAPI__STATUS__C = 'sent'; 
        Env4.Apttus_QPDSign__QuoteProposal__c = prop4.Id;
        Env4.Apttus_DocuApi__ParentId__c = prop4.Id;
        Env4.Apttus_DocuApi__EnvelopeId__c = 'envtestid4'; 
        Env4.APTTUS_DOCUAPI__RECALLREASON__C = '';
        envList.add(Env4); 
                     
        insert envList;

            
            
            
        test.stoptest();
            
    
       //}

    }
    static testMethod void updateDigitalDT() {
    
    

LTS_Disable_Application_Automation__c ltstemp = new LTS_Disable_Application_Automation__c();
        ltstemp.LTS_Disable_Process_Builders__c = true;
        ltstemp.LTS_Disable_Triggers__c = true;
        ltstemp.LTS_Disable_Validation_Rules__c = true;
        ltstemp.LTS_Disable_Workflow_Rules__c = true;
        ltstemp.Name = 'temp';
        ltstemp.SetupOwnerId = userinfo.getuserid();
        insert ltstemp;
          
          list<KeyValueListStore__c> kvListStore = new list<KeyValueListStore__c>();
        KeyValueListStore__c oStore1 = new  KeyValueListStore__c();
        oStore1.Name='ANZUsersProfileId';
        oStore1.TextValue__c=System.Label.APTS_OC_Test_Id;
        kvListStore.add(oStore1);
        KeyValueListStore__c oStore2 = new  KeyValueListStore__c();
        oStore2.Name='AptsOpportunityWinLoss';
        oStore2.TextValue__c='Won';
        kvListStore.add(oStore2);
        KeyValueListStore__c oStore3 = new  KeyValueListStore__c();
        oStore3.Name='AptsOpportunityCompetitor';
        oStore3.TextValue__c='Unknown';
        kvListStore.add(oStore3);
        KeyValueListStore__c oStore4 = new  KeyValueListStore__c();
        oStore4.Name='AptsOpportunityReason';
        oStore4.TextValue__c='Other';
        kvListStore.add(oStore4);
         KeyValueListStore__c LCRMStrikeIronFlagINS1 = new KeyValueListStore__c();
        LCRMStrikeIronFlagINS1.Name='LCRMDisableStrikeIronServices';
        LCRMStrikeIronFlagINS1.TextValue__c='True';
         kvListStore.add(LCRMStrikeIronFlagINS1);
         KeyValueListStore__c keyval = new KeyValueListStore__c();
        keyval.Name='ReasonWithCompetitor';
        keyval.TextValue__c='Price';
        kvListStore.add(keyval);
        insert kvListStore;
        Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
        Account acct = new Account(RecordTypeId=accRecordTypeId,name='test-sg',sales_org__c='WEST',customer_group__c='FIRM',customer_type__c='Organization',customer_class_c__c='Academic Lecturer');
        insert acct;
        System.assertequals('test-sg',acct.Name,'Success');     
        
        Contact con1 =  new Contact(FirstName = 'FirstName1', LastName = 'LastTest1', Email = 'test.test@gmail.com', AccountId = acct.Id);
        insert con1;
                  
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
        
        Id accRecordTypeIdSSD=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByDeveloperName().get(USL_RECORDTPYE).getRecordTypeId();
        Source_System_Detail__c accountSSD= new Source_System_Detail__c();
        accountSSD.Name='ABC';
        accountSSD.Source_System_Name__c='ABC';
        accountSSD.Account_Name__c=acct.ID;
        accountSSD.LCRM_Customer_Group__c='Academic';
        accountSSD.Account_Inactive__c=false;
        accountSSD.LCRM_Sales_Org__c='WEST';
        insert accountSSD;
    
       
        Date todaysDate = system.today();
        Id oppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Pipeline Opportunity').getRecordTypeId();
        Opportunity opp1 = new Opportunity(RecordTypeId=oppRecordTypeId, Source_System_Detail__c=accountSSD.Id,APTS_Proposal_Business_Unit__c='FindLaw',isdigitalspearhead__c = TRUE, Name='tst-opp', stagename='25%',closedate=todaysDate,forecastcategoryname='Omitted',accountId=acct.id);
        insert opp1;
       
        Apttus_Config2__PriceList__c price =new Apttus_Config2__PriceList__c(name='tst-pl', apttus_config2__active__c=true);
        insert price;

        
        // prepare Proposals
       
        Id devRecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Proposal').getRecordTypeId();
        
        // Proposal to Set stage to Expired
       
    Apttus_Proposal__Proposal__c prop2 = new Apttus_Proposal__Proposal__c(RecordTypeId=devRecordTypeId, Apttus_Proposal__Proposal_Name__c = 'TST-10', 
                                                 Apttus_Proposal__Account__c = acct.id, Apttus_Proposal__Opportunity__c = opp1.id, 
                                                 Apttus_Proposal__Approval_Stage__c = 'Draft', Apttus_Proposal__Proposal_Category__c = 'Quote', 
                                                 Apttus_Proposal__ReadyToGenerate__c = true, Apttus_Proposal__ReadyToPresent__c = true,
                                                 Apttus_QPConfig__PriceListId__c = price.id, APTS_Order_Confirmation_Contact__c = con1.Id);
                                                 
                                                 
        
        insert prop2;
    System.debug(prop2.APTS_Proposal_Business_Unit__c);
    prop2.APTS_Proposal_Business_Unit__c='FindLaw';
    update prop2;
        
    }

      static testMethod void updateDigitalDT1() {
    
    
LTS_Disable_Application_Automation__c ltstemp = new LTS_Disable_Application_Automation__c();
        ltstemp.LTS_Disable_Process_Builders__c = true;
        ltstemp.LTS_Disable_Triggers__c = true;
        ltstemp.LTS_Disable_Validation_Rules__c = true;
        ltstemp.LTS_Disable_Workflow_Rules__c = true;
        ltstemp.Name = 'temp';
        ltstemp.SetupOwnerId = userinfo.getuserid();
        insert ltstemp;
          
          list<KeyValueListStore__c> kvListStore = new list<KeyValueListStore__c>();
        KeyValueListStore__c oStore1 = new  KeyValueListStore__c();
        oStore1.Name='ANZUsersProfileId';
        oStore1.TextValue__c=System.Label.APTS_OC_Test_Id;
        kvListStore.add(oStore1);
        KeyValueListStore__c oStore2 = new  KeyValueListStore__c();
        oStore2.Name='AptsOpportunityWinLoss';
        oStore2.TextValue__c='Won';
        kvListStore.add(oStore2);
        KeyValueListStore__c oStore3 = new  KeyValueListStore__c();
        oStore3.Name='AptsOpportunityCompetitor';
        oStore3.TextValue__c='Unknown';
        kvListStore.add(oStore3);
        KeyValueListStore__c oStore4 = new  KeyValueListStore__c();
        oStore4.Name='AptsOpportunityReason';
        oStore4.TextValue__c='Other';
        kvListStore.add(oStore4);
         KeyValueListStore__c LCRMStrikeIronFlagINS1 = new KeyValueListStore__c();
        LCRMStrikeIronFlagINS1.Name='LCRMDisableStrikeIronServices';
        LCRMStrikeIronFlagINS1.TextValue__c='True';
         kvListStore.add(LCRMStrikeIronFlagINS1);
         KeyValueListStore__c keyval = new KeyValueListStore__c();
        keyval.Name='ReasonWithCompetitor';
        keyval.TextValue__c='Price';
        kvListStore.add(keyval);
        insert kvListStore;
        Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
        Account acct = new Account(RecordTypeId=accRecordTypeId,name='test-sg',sales_org__c='WEST',customer_group__c='FIRM',customer_type__c='Organization',customer_class_c__c='Academic Lecturer');
        insert acct;
        System.assertequals('test-sg',acct.Name,'Success');     
        
        Contact con1 =  new Contact(FirstName = 'FirstName1', LastName = 'LastTest1', Email = 'test.test@gmail.com', AccountId = acct.Id);
        insert con1;
                  
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
        
        Id accRecordTypeIdSSD=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByDeveloperName().get(USL_RECORDTPYE).getRecordTypeId();
        Source_System_Detail__c accountSSD= new Source_System_Detail__c();
        accountSSD.Name='ABC';
        accountSSD.Source_System_Name__c='ABC';
        accountSSD.Account_Name__c=acct.ID;
        accountSSD.LCRM_Customer_Group__c='Academic';
        accountSSD.Account_Inactive__c=false;
        accountSSD.LCRM_Sales_Org__c='CARS';
        insert accountSSD;
    
       
        Date todaysDate = system.today();
        Id oppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Pipeline Opportunity').getRecordTypeId();
        Opportunity opp = new Opportunity(RecordTypeId=oppRecordTypeId, Source_System_Detail__c=accountSSD.Id,APTS_Proposal_Business_Unit__c='SCS', Name='tst-opp', stagename='25%',closedate=todaysDate,forecastcategoryname='Omitted',accountId=acct.id);
        insert opp;
       
        Apttus_Config2__PriceList__c price =new Apttus_Config2__PriceList__c(name='tst-pl', apttus_config2__active__c=true);
        insert price;

        
        // prepare Proposals
       
        Id devRecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Proposal').getRecordTypeId();
        
        // Proposal to Set stage to Expired
       
    Apttus_Proposal__Proposal__c prop1 = new Apttus_Proposal__Proposal__c(RecordTypeId=devRecordTypeId, Apttus_Proposal__Proposal_Name__c = 'TST-10', 
                                                 Apttus_Proposal__Account__c = acct.id, Apttus_Proposal__Opportunity__c = opp.id, 
                                                 Apttus_Proposal__Approval_Stage__c = 'Draft', Apttus_Proposal__Proposal_Category__c = 'Quote', 
                                                 Apttus_Proposal__ReadyToGenerate__c = true, Apttus_Proposal__ReadyToPresent__c = true,
                                                 Apttus_QPConfig__PriceListId__c = price.id, APTS_Order_Confirmation_Contact__c = con1.Id);
                                                 
                                                 
        
    insert prop1;
    
    
    prop1.APTS_Proposal_Business_Unit__c='Canada';
    update prop1;
        
    }
     static testMethod void updateDigitalDTNew() {
    
    

LTS_Disable_Application_Automation__c ltstemp = new LTS_Disable_Application_Automation__c();
        ltstemp.LTS_Disable_Process_Builders__c = true;
        ltstemp.LTS_Disable_Triggers__c = true;
        ltstemp.LTS_Disable_Validation_Rules__c = true;
        ltstemp.LTS_Disable_Workflow_Rules__c = true;
        ltstemp.Name = 'temp';
        ltstemp.SetupOwnerId = userinfo.getuserid();
        insert ltstemp;
          
          list<KeyValueListStore__c> kvListStore = new list<KeyValueListStore__c>();
        KeyValueListStore__c oStore1 = new  KeyValueListStore__c();
        oStore1.Name='ANZUsersProfileId';
        oStore1.TextValue__c=System.Label.APTS_OC_Test_Id;
        kvListStore.add(oStore1);
        KeyValueListStore__c oStore2 = new  KeyValueListStore__c();
        oStore2.Name='AptsOpportunityWinLoss';
        oStore2.TextValue__c='Won';
        kvListStore.add(oStore2);
        KeyValueListStore__c oStore3 = new  KeyValueListStore__c();
        oStore3.Name='AptsOpportunityCompetitor';
        oStore3.TextValue__c='Unknown';
        kvListStore.add(oStore3);
        KeyValueListStore__c oStore4 = new  KeyValueListStore__c();
        oStore4.Name='AptsOpportunityReason';
        oStore4.TextValue__c='Other';
        kvListStore.add(oStore4);
        KeyValueListStore__c LCRMStrikeIronFlagINS1 = new KeyValueListStore__c();
        LCRMStrikeIronFlagINS1.Name='LCRMDisableStrikeIronServices';
        LCRMStrikeIronFlagINS1.TextValue__c='True';
        kvListStore.add(LCRMStrikeIronFlagINS1);
        KeyValueListStore__c keyval = new KeyValueListStore__c();
        keyval.Name='ReasonWithCompetitor';
        keyval.TextValue__c='Price';
        kvListStore.add(keyval);
        insert kvListStore;
        Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
        Account acct = new Account(RecordTypeId=accRecordTypeId,name='test-sg',sales_org__c='TRFR',customer_group__c='FIRM',customer_type__c='Organization',customer_class_c__c='Academic Lecturer');
        insert acct;

        System.assertequals('test-sg',acct.Name,'Success');     
        
        Contact con1 =  new Contact(FirstName = 'FirstName1', LastName = 'LastTest1', Email = 'test.test@gmail.com', AccountId = acct.Id);
        insert con1;
                  
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
        
        Id accRecordTypeIdSSD=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByDeveloperName().get(USL_RECORDTPYE).getRecordTypeId();
        Source_System_Detail__c accountSSD= new Source_System_Detail__c();
        accountSSD.Name='ABC';
        accountSSD.Source_System_Name__c='ABC';
        accountSSD.Account_Name__c=acct.ID;
        accountSSD.LCRM_Customer_Group__c='Academic';
        accountSSD.Account_Inactive__c=false;
        accountSSD.LCRM_Sales_Org__c='TRFR';
        insert accountSSD;
    
       
        Date todaysDate = system.today();
        Id oppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        Opportunity opp1 = new Opportunity(RecordTypeId=oppRecordTypeId, Source_System_Detail__c=accountSSD.Id,APTS_Proposal_Business_Unit__c='SouthKorea-DUZON',isdigitalspearhead__c = TRUE, Name='tst-opp', stagename='25%',closedate=todaysDate,forecastcategoryname='Omitted',accountId=acct.id);
        insert opp1;
        Opportunity opp2 = new Opportunity(RecordTypeId=oppRecordTypeId, Source_System_Detail__c=accountSSD.Id,APTS_Proposal_Business_Unit__c='Russia-1S',isdigitalspearhead__c = TRUE, Name='tst-opp', stagename='25%',closedate=todaysDate,forecastcategoryname='Omitted',accountId=acct.id);
        insert opp2;
        Opportunity opp3 = new Opportunity(RecordTypeId=oppRecordTypeId, Source_System_Detail__c=accountSSD.Id,APTS_Proposal_Business_Unit__c='Dofiscal',isdigitalspearhead__c = TRUE, Name='tst-opp', stagename='25%',closedate=todaysDate,forecastcategoryname='Omitted',accountId=acct.id);
        insert opp3;
        
       
        Apttus_Config2__PriceList__c price =new Apttus_Config2__PriceList__c(name='tst-pl', apttus_config2__active__c=true);
        insert price;

        
        // prepare Proposals
       
        Id devRecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Proposal').getRecordTypeId();
        
        // Proposal to Set stage to Expired
        List<Apttus_Proposal__Proposal__c>updateProp=New List<Apttus_Proposal__Proposal__c>();
       
        Apttus_Proposal__Proposal__c prop2 = new Apttus_Proposal__Proposal__c(RecordTypeId=devRecordTypeId, Apttus_Proposal__Proposal_Name__c = 'TST-10', 
                                                 Apttus_Proposal__Account__c = acct.id, Apttus_Proposal__Opportunity__c = opp1.id, 
                                                 Apttus_Proposal__Approval_Stage__c = 'Draft', Apttus_Proposal__Proposal_Category__c = 'Quote', 
                                                 Apttus_Proposal__ReadyToGenerate__c = true, Apttus_Proposal__ReadyToPresent__c = true,
                                                 Apttus_QPConfig__PriceListId__c = price.id, APTS_Order_Confirmation_Contact__c = con1.Id);
                                                 
                                                 
        
        updateProp.add(prop2);
        Apttus_Proposal__Proposal__c prop3 = new Apttus_Proposal__Proposal__c(RecordTypeId=devRecordTypeId, Apttus_Proposal__Proposal_Name__c = 'TST-10', 
                                                 Apttus_Proposal__Account__c = acct.id, Apttus_Proposal__Opportunity__c = opp2.id, 
                                                 Apttus_Proposal__Approval_Stage__c = 'Draft', Apttus_Proposal__Proposal_Category__c = 'Quote', 
                                                 Apttus_Proposal__ReadyToGenerate__c = true, Apttus_Proposal__ReadyToPresent__c = true,
                                                 Apttus_QPConfig__PriceListId__c = price.id, APTS_Order_Confirmation_Contact__c = con1.Id);
                                                 
                                                 
        
        updateProp.add(prop3);
        Apttus_Proposal__Proposal__c prop4 = new Apttus_Proposal__Proposal__c(RecordTypeId=devRecordTypeId, Apttus_Proposal__Proposal_Name__c = 'TST-10', 
                                                 Apttus_Proposal__Account__c = acct.id, Apttus_Proposal__Opportunity__c = opp3.id, 
                                                 Apttus_Proposal__Approval_Stage__c = 'Draft', Apttus_Proposal__Proposal_Category__c = 'Quote', 
                                                 Apttus_Proposal__ReadyToGenerate__c = true, Apttus_Proposal__ReadyToPresent__c = true,
                                                 Apttus_QPConfig__PriceListId__c = price.id, APTS_Order_Confirmation_Contact__c = con1.Id);
                                                 
                                                 
        
        updateProp.add(prop4);
        insert updateProp;
    System.debug(prop2.APTS_Proposal_Business_Unit__c);
    prop2.APTS_Proposal_Business_Unit__c='SouthKorea-DUZON';
    prop3.APTS_Proposal_Business_Unit__c='Russia-1S';
    prop4.APTS_Proposal_Business_Unit__c='Dofiscal';
    
    update prop2;
    update prop3;
    update prop4;
    update updateProp;
        
    }
    

}