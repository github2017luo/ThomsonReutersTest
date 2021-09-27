@isTest
private class Test_FL_ApprovalDashboardAJSController {

   @testSetup
    private static void initTestData(){
         APTS_TestDataFactory.createFLTrephCodes();
        Map<String,List<String>> flcodeMap=new Map<String,List<String>>(); 
        List<APTS_TREPH_FINDLAW_CODES__c> flcodes= APTS_TREPH_FINDLAW_CODES__c.getAll().values();
        for(APTS_TREPH_FINDLAW_CODES__c pb :flcodes){    
            String flvalue= pb.value__c;               
            flcodeMap.put(pb.name,pb.value__c.split(','));
        }
        List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c=System.Label.APTS_OC_Test_Id),
        new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other'),
        new KeyValueListStore__c(Name='LCRMDisableStrikeIronServices',TextValue__c='True')};
        insert keyvaluestore;
         
        Id oppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Pipeline Opportunity').getRecordTypeId();
        Id oppRecordTypeId1 = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Pre-Pipeline Opportunity').getRecordTypeId();
        
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
        insert act;
        
        
            Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get(label.SourcesystemdetailUSLRecordtype).getRecordTypeId();
        Source_System_Detail__c accountSSD= new Source_System_Detail__c();
        accountSSD.RecordtypeId=ssdRecorType;
        accountSSD.Name='ABC';
        accountSSD.Source_System_Name__c='ABC';
        accountSSD.Account_Name__c=act.ID;
        accountSSD.Account_Inactive__c=false;
        accountSSD.LCRM_Sales_Org__c='WEST';
        accountSSD.LCRM_APTS_Band_Number__c =80;
        insert accountSSD;
               
        Date todaysDate = system.today();        
        Opportunity o = UnitTest.getOpportunityInstance(act.Id);
        o.Name = 'tst-opp1';
        o.stagename = '25%';
        o.closedate = todaysDate;
        o.forecastcategoryname = 'Omitted';
        o.pricebook2id = pb.id;
        o.Source_System_Detail__c=accountSSD.id;
        insert o;
        
        Apttus_Config2__PriceList__c pl = new Apttus_Config2__PriceList__c();
        pl.Apttus_Config2__Active__c = true;
        pl.Name = 'Thomson Reuters Master - US Legal';
        pl.Apttus_Config2__EffectiveDate__c = System.today().addYears(-1);
        pl.Apttus_Config2__ExpirationDate__c = System.today().addYears(2);
        pl.CurrencyIsoCode = 'USD';
        insert pl;        
        
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
            APTS_SSD_Sold_To__c = accountSSD.Id,
            APTS_Proposal_Business_Unit__c = 'FindLaw'
            );
            insert proposal;
            proposal.APTS_Proposal_Business_Unit__c ='FindLaw';
            update Proposal;
            
        
        /*Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        Opportunity oppty=APTS_TestDataFactory.createOpportunity('abc',act.id,'Needs Analysis',Date.Today());
        oppty.RecordtypeId=opptyRecorType;
        oppty.Source_System_Detail__c=accountSSD.id;
        oppty.Account=act;
        insert oppty;
        
         Apttus_Proposal__Proposal__c proposal = APTS_TestDataFactory.createProposal(oppty.id, accountSSD.Id);
        insert proposal;*/
        
       System.debug('PriceList before inserting new proposal: ' + proposal.Apttus_QPConfig__PriceListId__c);
        
                
        Apttus_Config2__ProductConfiguration__c prodConfig = TestDataFactoryCPQ.getConfiguration(proposal, pl.Id, act);
        prodConfig.APTS_Current_Holdings__c=0;
        insert prodConfig;
                
        APTS_Group__c proposalGroup =new APTS_Group__c();
        proposalGroup.APTS_GrossAmount__c = 0;
        proposalGroup.APTS_Group_Name_Original__c ='Online/Software Bundle A';
        proposalGroup.APTS_Group_Name__c ='Online/Software Bundle A';
        proposalGroup.APTS_NetAmount__c=0;
        insert proposalGroup;
                
        Apttus_Config2__SummaryGroup__c summaryGroup1 = new Apttus_Config2__SummaryGroup__c(
                Apttus_Config2__ConfigurationId__c = prodConfig.id, 
                Name = 'WEST PROFLEX Bundle A - Test group',
                Apttus_Config2__LineType__c = 'Group Total',
                Apttus_Config2__ItemSequence__c = 1,
                Apttus_Config2__LineNumber__c = 1
            );
        insert summaryGroup1;
        
        Product2 prod1 = TestDataFactoryCPQ.getProduct('testproduct1', Label.APTS_Print_Product_Family_Value);
        insert prod1;
                        
        Apttus_Config2__AssetLineItem__c assetLineItem1 = TestDataFactoryCPQ.getAssetLineItem('assetlineitem1', act,accountSSD, prod1);
        assetLineItem1.APTS_Proposal_Business_Unit__c = 'FindLaw';
        assetLineItem1.Apttus_Config2__LineType__c = 'Product/Service'; 
        //insert assetLineItem1;
        
        Product2 prod2 = TestDataFactoryCPQ.getProduct('testproduct2', 'FINDLAW');
        insert prod2;
                                
        Apttus_Config2__AssetLineItem__c printProviewList = TestDataFactoryCPQ.getAssetLineItem('assetlineitem2', act,accountSSD, prod2);
        printProviewList.APTS_Proposal_Business_Unit__c = 'FindLaw';
        printProviewList.Apttus_Config2__LineType__c = 'Product/Service'; 
        //insert printProviewList;
        
        Product2 prod3 = TestDataFactoryCPQ.getProduct('testproduct3', 'Service');
        insert prod3;
                                
        Apttus_Config2__AssetLineItem__c currentOnlineSoftwareList = TestDataFactoryCPQ.getAssetLineItem('assetlineitem3', act,accountSSD, prod3);
        currentOnlineSoftwareList.APTS_Info_RenewalDate__c= Date.newInstance(2016, 12, 9);
        currentOnlineSoftwareList.APTS_Proposal_Business_Unit__c = 'FindLaw';
        currentOnlineSoftwareList.Apttus_Config2__LineType__c = 'Product/Service'; 
         currentOnlineSoftwareList.Apttus_Config2__NetPrice__c=110;
         currentOnlineSoftwareList.APTS_Contract_Term__c='5 Months';
        //insert  currentOnlineSoftwareList; 
        
        Apttus_Config2__AssetLineItem__c currentOnlineSoftwareList1 = TestDataFactoryCPQ.getAssetLineItem('assetlineitem03', act,accountSSD, prod3);
        currentOnlineSoftwareList1.APTS_Info_RenewalDate__c= Date.newInstance(2019, 12, 9);
        currentOnlineSoftwareList1.APTS_Proposal_Business_Unit__c = 'FindLaw';
        currentOnlineSoftwareList1.Apttus_Config2__LineType__c = 'Product/Service'; 
         currentOnlineSoftwareList1.APTS_Contract_Term__c=Null;
       // insert currentOnlineSoftwareList1;
        
        Product2 prod4 = TestDataFactoryCPQ.getProduct('testproduct4', 'WESTLAW');
        insert prod4;
                                
        Apttus_Config2__AssetLineItem__c lapsedAssetLineItem = TestDataFactoryCPQ.lapsedAssetLineItem('assetlineitem4', act,accountSSD, prod4);
        lapsedAssetLineItem.APTS_Proposal_Business_Unit__c = 'FindLaw';
        lapsedAssetLineItem.Apttus_Config2__LineType__c = 'Product/Service'; 
        //insert  lapsedAssetLineItem;        
        
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
        onlineLineItem2.Apttus_Config2__ListPrice__c=30;
        //insert onlineLineItem2;
       List<Apttus_Config2__AssetLineItem__c> olapsedAssetLineItemList= new List<Apttus_Config2__AssetLineItem__c>();
       olapsedAssetLineItemList.add(currentOnlineSoftwareList);
       olapsedAssetLineItemList.add(currentOnlineSoftwareList1);
       olapsedAssetLineItemList.add(lapsedAssetLineItem);
       olapsedAssetLineItemList.add(printProviewList);
       olapsedAssetLineItemList.add(assetLineItem1);
          
          if(olapsedAssetLineItemList.size()>0){
              
              insert olapsedAssetLineItemList;
          }
        
        List<Apttus_Config2__LineItem__c> onlineLineItemList= new List<Apttus_Config2__LineItem__c>();
        onlineLineItemList.add(printlineItem);
        onlineLineItemList.add(onlineLineItem);
        onlineLineItemList.add(onlineLineItem1);
        onlineLineItemList.add(onlineLineItem2);
        
        if(onlineLineItemList.size()>0){
            insert onlineLineItemList;
        }
        List<Apttus_Config2__ProductAttributeValue__c > lsprodAttrVal=new List<Apttus_Config2__ProductAttributeValue__c >();
        Apttus_Config2__ProductAttributeValue__c prodAttrVal = new Apttus_Config2__ProductAttributeValue__c(
            SCS_Print_Purchase_Options__c= 'Ship & Enter Sub',
            Apttus_Config2__LineItemId__c = printlineItem.ID
        );
        lsprodAttrVal.add(prodAttrVal );
        Apttus_Config2__ProductAttributeValue__c prodAttrVal2 = new Apttus_Config2__ProductAttributeValue__c(
            eBook_Purchase_Options__c= 'APP',
            Apttus_Config2__LineItemId__c = printlineItem.ID
        );
        lsprodAttrVal.add(prodAttrVal2 );
        insert lsprodAttrVal;  
        Test.stopTest();
    }
    
    static testmethod void testconstructor() {
        List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c=System.Label.APTS_OC_Test_Id),
        new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other'),
        new KeyValueListStore__c(Name='LCRMDisableStrikeIronServices',TextValue__c='True')};
        insert keyvaluestore;
         
       // initTestData();
        Test.startTest();
        
      
        Apttus_Proposal__Proposal__c proposal = [select Id, Name, Owner.Name, qp.Apttus_Proposal__Account__c 
                                                from Apttus_Proposal__Proposal__c qp 
                                                where Apttus_Proposal__Proposal_Name__c = 'testproposal' limit 1];
        
        PageReference pRef = Page.FL_ApprovalDashboardPage;
        pRef.getParameters().put('retId', proposal.Id);
        Test.setCurrentPage(pRef);
        
        FL_ApprovalDashboardAJSController ctrl = new FL_ApprovalDashboardAJSController();
        
        System.assert(ctrl.assetLineItem.size() != 0);  
        System.assert(ctrl.currentTCVList.size() != 0);
        System.assert(ctrl.printProviewList.size() != 0);
        System.assert(ctrl.lapsedProducts.size() != 0); 
        
        Test.stopTest(); 
    }
   
    static testmethod void testgetAccountDetail(){
     List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c=System.Label.APTS_OC_Test_Id),
        new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other'),
        new KeyValueListStore__c(Name='LCRMDisableStrikeIronServices',TextValue__c='True')};
        insert keyvaluestore;
         
        Test.startTest();
       // initTestData();
        
        Source_System_Detail__c act = [select Id, Name from Source_System_Detail__c WHERE Name = 'ABC'];        
        Source_System_Detail__c temp = FL_ApprovalDashboardAJSController.getAccountDetail(act.Id);
        System.assert(act !=null);         
        Test.stopTest(); 
    }
    
    static testmethod void testgetAssetLineItem() {
     List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c=System.Label.APTS_OC_Test_Id),
        new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other'),
        new KeyValueListStore__c(Name='LCRMDisableStrikeIronServices',TextValue__c='True')};
        insert keyvaluestore;
         
        Test.startTest();
        //initTestData();
        
        Source_System_Detail__c act = [select Id, Name from Source_System_Detail__c where Name = 'ABC'];
        Apttus_Config2__ProductConfiguration__c prodConfig = [select Id, Name from Apttus_Config2__ProductConfiguration__c where Name = 'prod-conf1'];
        Apttus_Config2__AssetLineItem__c asset = [select Id, Name from Apttus_Config2__AssetLineItem__c where Name = 'assetlineitem1' and APTS_Proposal_Business_Unit__c = 'FindLaw'];
        List<Apttus_Config2__AssetLineItem__c> temp = FL_ApprovalDashboardAJSController.getAssetLineItem(act.Id, prodConfig.Id);
        System.assert(asset!=null);
        Test.stopTest();
    }
    
    static testmethod void testgetCurrentOnlineSoftwareList() {
     List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c=System.Label.APTS_OC_Test_Id),
        new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other'),
        new KeyValueListStore__c(Name='LCRMDisableStrikeIronServices',TextValue__c='True')};
        insert keyvaluestore;
         
        Test.startTest();
        //initTestData();
        
        Source_System_Detail__c act = [select Id, Name from Source_System_Detail__c where Name = 'ABC'];
        Apttus_Config2__ProductConfiguration__c prodConfig = [select Id, Name from Apttus_Config2__ProductConfiguration__c where Name = 'prod-conf1'];
        Apttus_Config2__AssetLineItem__c asset = [select Id, Name from Apttus_Config2__AssetLineItem__c where Name = 'assetlineitem3' and APTS_Proposal_Business_Unit__c = 'FindLaw'];
        List<Apttus_Config2__AssetLineItem__c> temp = FL_ApprovalDashboardAJSController.getCurrentOnlineSoftwareList(act.Id, prodConfig.Id);
        System.assert(asset!=null);
        Test.stopTest();  
    }
    
 
    static testmethod void testgetPrintProviewList() {
     List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c=System.Label.APTS_OC_Test_Id),
        new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other'),
        new KeyValueListStore__c(Name='LCRMDisableStrikeIronServices',TextValue__c='True')};
        insert keyvaluestore;
         
        Test.startTest();
        //initTestData();
        
        Source_System_Detail__c act = [select Id, Name from Source_System_Detail__c where Name = 'ABC'];
        Apttus_Config2__ProductConfiguration__c prodConfig = [select Id, Name,Apttus_QPConfig__Proposald__c from Apttus_Config2__ProductConfiguration__c where Name = 'prod-conf1'];
        Apttus_Config2__AssetLineItem__c asset = [select Id, Name from Apttus_Config2__AssetLineItem__c where Name = 'assetlineitem1' and APTS_Proposal_Business_Unit__c = 'FindLaw'];
        List<Apttus_Config2__AssetLineItem__c> temp = FL_ApprovalDashboardAJSController.getPrintProviewList(act.Id, prodConfig.Id);
        System.assert(asset!=null);
        PageReference pRef = Page.FL_ApprovalDashboardPage;
        pRef.getParameters().put('retId', prodConfig.Apttus_QPConfig__Proposald__c );
        Test.setCurrentPage(pRef);
        FL_ApprovalDashboardAJSController fl=new FL_ApprovalDashboardAJSController();
        fl.setCurrentNetPriceTCV();
        Test.stopTest();
    }
    
    static testmethod void testgetFindLawList() {
     List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c=System.Label.APTS_OC_Test_Id),
        new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other'),
        new KeyValueListStore__c(Name='LCRMDisableStrikeIronServices',TextValue__c='True')};
        insert keyvaluestore;
         
        Test.startTest();
        //initTestData();
        
        Source_System_Detail__c act = [select Id, Name from Source_System_Detail__c where Name = 'ABC'];
        Apttus_Config2__ProductConfiguration__c prodConfig = [select Id, Name from Apttus_Config2__ProductConfiguration__c where Name = 'prod-conf1'];
        Apttus_Config2__AssetLineItem__c asset = [select Id, Name from Apttus_Config2__AssetLineItem__c where Name = 'assetlineitem2'];
        List<Apttus_Config2__AssetLineItem__c> temp = FL_ApprovalDashboardAJSController.getFindLawList(act.Id, prodConfig.Id);
        System.assert(asset!=null);
        Test.stopTest();
    }
    
    static testmethod void testgetLineItem() {
     List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c=System.Label.APTS_OC_Test_Id),
        new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other'),
        new KeyValueListStore__c(Name='LCRMDisableStrikeIronServices',TextValue__c='True')};
        insert keyvaluestore;
         
        Test.startTest();
        //initTestData();
        
        Apttus_Config2__ProductConfiguration__c prodConfig = [select Id, Name from Apttus_Config2__ProductConfiguration__c where Name = 'prod-conf1'];
        List<Apttus_Config2__LineItem__c> temp = FL_ApprovalDashboardAJSController.getLineItem(prodConfig.Id);
        System.assert(temp.size() != 0);
        Test.stopTest();
    }
    /*
    static testmethod void test_getDocumentList() {
        Test.startTest();
        //initTestData();
        
        Apttus_Proposal__Proposal__c proposal = [select Id, Name from Apttus_Proposal__Proposal__c 
                                                where Apttus_Proposal__Proposal_Name__c= 'testproposal'];
        
        Attachment attach=new Attachment();     
        attach.Name='Unit Test Attachment';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=proposal.id;
        insert attach;
        
        List<FL_ApprovalDashboardAJSController.Document> document = FL_ApprovalDashboardAJSController.getDocumentList(proposal.Id);
        System.assertEquals(attach.Name, document[0].fileName);
        System.assertEquals('Attachment', document[0].Type);
        
        Test.stopTest();
    }
    */
      static testmethod void testgetDocumentList() {
      List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c=System.Label.APTS_OC_Test_Id),
        new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other'),
        new KeyValueListStore__c(Name='LCRMDisableStrikeIronServices',TextValue__c='True')};
        insert keyvaluestore;
        Test.startTest();
        //initTestData();
        
        Apttus_Proposal__Proposal__c proposal = [select Id, Name from Apttus_Proposal__Proposal__c 
                                                where Apttus_Proposal__Proposal_Name__c= 'testproposal'];
        
        Attachment attach=new Attachment();     
        attach.Name='Unit Test Attachment';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=proposal.id;
        insert attach;
        
        List<FL_ApprovalDashboardAJSController.Document> document = FL_ApprovalDashboardAJSController.getDocumentList(proposal.Id);
        System.assertEquals(attach.Name, document[0].fileName);
        System.assertEquals('Attachment', document[0].Type);
        
        Test.stopTest();
    }
    
    static testmethod void testgetPrintProviewLineItems() {
     List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c=System.Label.APTS_OC_Test_Id),
        new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other'),
        new KeyValueListStore__c(Name='LCRMDisableStrikeIronServices',TextValue__c='True')};
        insert keyvaluestore;
         
        Test.startTest();
        //initTestData();
        
        Apttus_Proposal__Proposal__c proposal = [select Id, Name from Apttus_Proposal__Proposal__c 
                                                where Apttus_Proposal__Proposal_Name__c= 'testproposal'];
                                                
        List<FL_ApprovalDashboardAJSController.PrintProview> temp = FL_ApprovalDashboardAJSController.getPrintProviewLineItems(proposal.Id);
        System.assert(temp.size() != 0);
        System.assertEquals(Label.APTS_Print_Product_Family_Value, temp[0].productFamily);
                                                
        Test.stopTest();
    }
    
    static testmethod void testgetOwnerName() {
     List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c=System.Label.APTS_OC_Test_Id),
        new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other'),
        new KeyValueListStore__c(Name='LCRMDisableStrikeIronServices',TextValue__c='True')};
        insert keyvaluestore;
         
        Test.startTest();
        //initTestData();
        
        Apttus_Proposal__Proposal__c proposal = [select Id, Name, Owner.Name, qp.Apttus_Proposal__Account__c 
                                                from Apttus_Proposal__Proposal__c qp 
                                                where Apttus_Proposal__Proposal_Name__c = 'testproposal'];
        
        PageReference pRef = Page.FL_ApprovalDashboardPage;
        pRef.getParameters().put('retId', proposal.Id);
        Test.setCurrentPage(pRef);
        
        FL_ApprovalDashboardAJSController ctrl = new FL_ApprovalDashboardAJSController();
        String ownerName = ctrl.getOwnerName();
        System.debug('Owner Name -------------- '+ownerName);
        System.assert(proposal != null);
        Test.stopTest();
    }
    
    static testmethod void testgetCurrentNetPrice() {
     List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c=System.Label.APTS_OC_Test_Id),
        new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other'),
        new KeyValueListStore__c(Name='LCRMDisableStrikeIronServices',TextValue__c='True')};
        insert keyvaluestore;
         
        Test.startTest();
        //initTestData();
        
        Apttus_Proposal__Proposal__c proposal = [select Id, Name, Owner.Name, qp.Apttus_Proposal__Account__c 
                                                from Apttus_Proposal__Proposal__c qp 
                                                where Apttus_Proposal__Proposal_Name__c = 'testproposal'];
        
        PageReference pRef = Page.FL_ApprovalDashboardPage;
        pRef.getParameters().put('retId', proposal.Id);
        Test.setCurrentPage(pRef);
        
        FL_ApprovalDashboardAJSController ctrl = new FL_ApprovalDashboardAJSController();
        String netPrice = ctrl.getCurrentNetPrice();
        System.debug('Net Price -------------- '+netPrice);
        System.assert(netPrice != null);
        
        String currentACV = ctrl.getCurrentACV();
        System.debug('currentACV -------------- '+currentACV);
        System.assert(currentACV != null);
        Test.stopTest();
    }
    
    static testmethod void testgetCurrentOnlineSpendPrice() {
     List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c=System.Label.APTS_OC_Test_Id),
        new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other'),
        new KeyValueListStore__c(Name='LCRMDisableStrikeIronServices',TextValue__c='True')};
        insert keyvaluestore;
         
        Test.startTest();
        //initTestData();
        
        Apttus_Proposal__Proposal__c proposal = [select Id, Name, Owner.Name, qp.Apttus_Proposal__Account__c 
                                                from Apttus_Proposal__Proposal__c qp 
                                                where Apttus_Proposal__Proposal_Name__c = 'testproposal'];
        
        PageReference pRef = Page.FL_ApprovalDashboardPage;
        pRef.getParameters().put('retId', proposal.Id);
        Test.setCurrentPage(pRef);
        
        FL_ApprovalDashboardAJSController ctrl = new FL_ApprovalDashboardAJSController();
        String onlineSpend = ctrl.getCurrentOnlineSpendPrice();
        System.debug('CurrentOnlineSpendPrice -------------- '+onlineSpend);
        System.assert(onlineSpend != null); 
        
        String currentTCV = ctrl.getCurrentTCV();
        System.debug('currentTCV -------------- '+currentTCV);
        System.assert(currentTCV != null);
        
        Test.stopTest();
    }
    
    static testmethod void testgetCurrentBand() {
     List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c=System.Label.APTS_OC_Test_Id),
        new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other'),
        new KeyValueListStore__c(Name='LCRMDisableStrikeIronServices',TextValue__c='True')};
        insert keyvaluestore;
         
        Test.startTest();
        //initTestData();
        
        Apttus_Proposal__Proposal__c proposal = [select Id, Name, Owner.Name, qp.Apttus_Proposal__Account__c 
                                                from Apttus_Proposal__Proposal__c qp 
                                                where Apttus_Proposal__Proposal_Name__c = 'testproposal'];
        
        PageReference pRef = Page.FL_ApprovalDashboardPage;
        pRef.getParameters().put('retId', proposal.Id);
        Test.setCurrentPage(pRef);
        
        FL_ApprovalDashboardAJSController ctrl = new FL_ApprovalDashboardAJSController();
        String band = ctrl.getCurrentBand();
        System.debug('Current band -------------- '+band);
        System.assert(band != null);
        Test.stopTest();
    }
    
    static testmethod void testgetAttorneyBand() {
     List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c=System.Label.APTS_OC_Test_Id),
        new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other'),
        new KeyValueListStore__c(Name='LCRMDisableStrikeIronServices',TextValue__c='True')};
        insert keyvaluestore;
         
        Test.startTest();
        //initTestData();
        
        Apttus_Proposal__Proposal__c proposal = [select Id, Name, Owner.Name, qp.Apttus_Proposal__Account__c 
                                                from Apttus_Proposal__Proposal__c qp 
                                                where Apttus_Proposal__Proposal_Name__c = 'testproposal'];
        
        PageReference pRef = Page.FL_ApprovalDashboardPage;
        pRef.getParameters().put('retId', proposal.Id);
        Test.setCurrentPage(pRef);
        
        FL_ApprovalDashboardAJSController ctrl = new FL_ApprovalDashboardAJSController();
        String band = ctrl.getAttorneyBand();
        System.debug('AttorneyBand -------------- '+band);
        System.assert(band != null);
        Test.stopTest();
    }
    
    static testmethod void testgetnewProductsNetPrice() {
     List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c=System.Label.APTS_OC_Test_Id),
        new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other'),
        new KeyValueListStore__c(Name='LCRMDisableStrikeIronServices',TextValue__c='True')};
        insert keyvaluestore;
         
        Test.startTest();
        //initTestData();
        
        Apttus_Proposal__Proposal__c proposal = [select Id, Name, Owner.Name, qp.Apttus_Proposal__Account__c 
                                                from Apttus_Proposal__Proposal__c qp 
                                                where Apttus_Proposal__Proposal_Name__c = 'testproposal'];
        
        PageReference pRef = Page.FL_ApprovalDashboardPage;
        pRef.getParameters().put('retId', proposal.Id);
        Test.setCurrentPage(pRef);
        
        FL_ApprovalDashboardAJSController ctrl = new FL_ApprovalDashboardAJSController();
        Decimal val = ctrl.getnewProductsNetPrice();
        System.debug('New NetPrice -------------- '+val);
        System.assert(val != null);
        Test.stopTest();
    }
    
    static testmethod void testgetCurrentAttorneysTotal() {
     List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c=System.Label.APTS_OC_Test_Id),
        new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other'),
        new KeyValueListStore__c(Name='LCRMDisableStrikeIronServices',TextValue__c='True')};
        insert keyvaluestore;
         
        Test.startTest();
        //initTestData();
        
        Apttus_Proposal__Proposal__c proposal = [select Id, Name, Owner.Name, qp.Apttus_Proposal__Account__c 
                                                from Apttus_Proposal__Proposal__c qp 
                                                where Apttus_Proposal__Proposal_Name__c = 'testproposal'];
        
        PageReference pRef = Page.FL_ApprovalDashboardPage;
        pRef.getParameters().put('retId', proposal.Id);
        Test.setCurrentPage(pRef);
        
        FL_ApprovalDashboardAJSController ctrl = new FL_ApprovalDashboardAJSController();
        String val = ctrl.getCurrentAttorneysTotal();
        System.debug('CurrentAttorneysTotal -------------- '+val);
        System.assert(val != null);
        Test.stopTest();
    }
    
    static testmethod void testgetProposedAttorneysTotal() {
     List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c=System.Label.APTS_OC_Test_Id),
        new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other'),
        new KeyValueListStore__c(Name='LCRMDisableStrikeIronServices',TextValue__c='True')};
        insert keyvaluestore;
         
        Test.startTest();
        //initTestData();
        
        Apttus_Proposal__Proposal__c proposal = [select Id, Name, Owner.Name, qp.Apttus_Proposal__Account__c 
                                                from Apttus_Proposal__Proposal__c qp 
                                                where Apttus_Proposal__Proposal_Name__c = 'testproposal'];
        
        PageReference pRef = Page.FL_ApprovalDashboardPage;
        pRef.getParameters().put('retId', proposal.Id);
        Test.setCurrentPage(pRef);
        
        FL_ApprovalDashboardAJSController ctrl = new FL_ApprovalDashboardAJSController();
        String val = ctrl.getProposedAttorneysTotal();
        System.debug('ProposedAttorneysTotal -------------- '+val);
        System.assert(val != null);
        Test.stopTest();
    }
    
    static testmethod void testsetCurrentNetPriceTCV() {
     List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c=System.Label.APTS_OC_Test_Id),
        new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other'),
        new KeyValueListStore__c(Name='LCRMDisableStrikeIronServices',TextValue__c='True')};
        insert keyvaluestore;
         
        Test.startTest();
        //initTestData();
        Source_System_Detail__c act = [select Id, Name from Source_System_Detail__c where Name = 'ABC'];
        Apttus_Config2__ProductConfiguration__c prodConfig = [select Id, Name from Apttus_Config2__ProductConfiguration__c where Name = 'prod-conf1'];
        Apttus_Config2__AssetLineItem__c asset = [select Id, Name from Apttus_Config2__AssetLineItem__c where Name = 'assetlineitem3'];
        List<Apttus_Config2__AssetLineItem__c> temp = FL_ApprovalDashboardAJSController.getCurrentOnlineSoftwareList(act.Id, prodConfig.Id);
        //System.assertEquals(asset.Name, temp[0].Name);
        system.assert(asset !=null);       
        
        Test.stopTest();  
        
    }
    
    static testmethod void testgetCurrentRPA() {
     List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c=System.Label.APTS_OC_Test_Id),
        new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other'),
        new KeyValueListStore__c(Name='LCRMDisableStrikeIronServices',TextValue__c='True')};
        insert keyvaluestore;
         
        Test.startTest();
        //initTestData();
        
        Apttus_Proposal__Proposal__c proposal = [select Id, Name, Owner.Name, qp.Apttus_Proposal__Account__c 
                                                from Apttus_Proposal__Proposal__c qp 
                                                where Apttus_Proposal__Proposal_Name__c = 'testproposal'];
        
        PageReference pRef = Page.FL_ApprovalDashboardPage;
        pRef.getParameters().put('retId', proposal.Id);
        Test.setCurrentPage(pRef);
        
        FL_ApprovalDashboardAJSController ctrl = new FL_ApprovalDashboardAJSController();
        String val = ctrl.getCurrentRPA();
        System.debug('CurrentRPA -------------- '+val);
        System.assert(val != null);
        Test.stopTest(); 
        
    }
    
    static testmethod void testgetCurrentDiscount() {
     List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c=System.Label.APTS_OC_Test_Id),
        new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other'),
        new KeyValueListStore__c(Name='LCRMDisableStrikeIronServices',TextValue__c='True')};
        insert keyvaluestore;
        Test.startTest();
        //initTestData();
        
        Apttus_Proposal__Proposal__c proposal = [select Id, Name, Owner.Name, qp.Apttus_Proposal__Account__c 
                                                from Apttus_Proposal__Proposal__c qp 
                                                where Apttus_Proposal__Proposal_Name__c = 'testproposal'];
        
        PageReference pRef = Page.FL_ApprovalDashboardPage;
        pRef.getParameters().put('retId', proposal.Id);
        Test.setCurrentPage(pRef);
        
        FL_ApprovalDashboardAJSController ctrl = new FL_ApprovalDashboardAJSController();
        String val = ctrl.getCurrentDiscount();
        System.debug('CurrentDiscount-------------- '+val);
        System.assert(val != null);
        
        String val1 = ctrl.getCurrentOverallDiscount();
        System.debug('CurrentOverallDiscount-------------- '+val1);
        System.assert(val1 != null);
        Test.stopTest();
    }
    
    static testmethod void testgetLapsedProdNetPrice() {
     List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c=System.Label.APTS_OC_Test_Id),
        new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other'),
        new KeyValueListStore__c(Name='LCRMDisableStrikeIronServices',TextValue__c='True')};
        insert keyvaluestore;
         
        Test.startTest();
        //initTestData();
        
        Apttus_Proposal__Proposal__c proposal = [select Id, Name, Owner.Name, qp.Apttus_Proposal__Account__c 
                                                from Apttus_Proposal__Proposal__c qp 
                                                where Apttus_Proposal__Proposal_Name__c = 'testproposal'];
        
        PageReference pRef = Page.FL_ApprovalDashboardPage;
        pRef.getParameters().put('retId', proposal.Id);
        Test.setCurrentPage(pRef);
        
        FL_ApprovalDashboardAJSController ctrl = new FL_ApprovalDashboardAJSController();
        Decimal val = ctrl.getLapsedProdNetPrice();
        System.debug('LapsedProdNetPrice -------------- '+val);
        System.assert(val != null);
        Test.stopTest();    
    } 
    
    static testmethod void testgetProposedDiscount(){
     List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c=System.Label.APTS_OC_Test_Id),
        new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other'),
        new KeyValueListStore__c(Name='LCRMDisableStrikeIronServices',TextValue__c='True')};
        insert keyvaluestore;
         
        Test.startTest();
            
        Product2 prod=new Product2(Name='TEst', IsActive=true, Apttus_Config2__ConfigurationType__c='standalone', APTS_Eligibility_All__c=true,ProductCode='ABC123');
        insert prod;
        
        Apttus_Config2__PriceList__c priceList = APTS_TestDataFactory.createPriceList('Thomson Reuters Master - US Legal');
        insert priceList;
            
        Apttus_Config2__PriceListItem__c pli=new Apttus_Config2__PriceListItem__c(Apttus_Config2__Active__c=true,Apttus_Config2__ProductId__c=prod.id,Apttus_Config2__PriceListId__c=priceList.id);
        insert pli;
        
        Apttus_Proposal__Proposal__c proposal = [select Id, Name, Owner.Name, qp.Apttus_Proposal__Account__c,APTS_Proposal_Business_Unit__c 
                                                from Apttus_Proposal__Proposal__c qp 
                                                where Apttus_Proposal__Proposal_Name__c = 'testproposal'];
        Apttus_Config2__ProductConfiguration__c conf = [select Id from Apttus_Config2__ProductConfiguration__c];
        conf.APTS_Additional_Approval_Other__c = false;
        conf.APTS_New_Holdings__c = 40;
        conf.APTS_Current_Holdings__c = 10;
        conf.APTS_Lapsed_Holdings__c = 5;
        update conf;
        
        List<Apttus_Config2__LineItem__c> liList = new List<Apttus_Config2__LineItem__c>();
        Apttus_Config2__LineItem__c lineItem=new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c=conf.id,Apttus_Config2__LineType__c='Product/Service',Apttus_Config2__ProductId__c=prod.id,Apttus_Config2__PriceListId__c=priceList.id, Apttus_Config2__PriceListItemId__c=pli.id, Apttus_Config2__ItemSequence__c = 1, Apttus_Config2__LineNumber__c = 1,Apttus_Config2__ChargeType__c = 'Subscription Fee',Apttus_Config2__LineStatus__c = 'New',Apttus_Config2__NetPrice__c = 100,APTS_FL_Qty__c = 10,Apttus_Config2__ListPrice__c = 10,Apttus_Config2__BasePrice__c = 10,Apttus_Config2__Quantity__c = 2);
        liList.add(lineItem);
            
        Apttus_Config2__LineItem__c lineItem1=new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c=conf.id,Apttus_Config2__LineType__c='Product/Service',Apttus_Config2__ProductId__c=prod.id, Apttus_Config2__PriceListId__c=priceList.id, Apttus_Config2__PriceListItemId__c=pli.id, Apttus_Config2__ItemSequence__c = 1, Apttus_Config2__LineNumber__c = 1,Apttus_Config2__ChargeType__c = 'Subscription Fee',Apttus_Config2__LineStatus__c = 'Renewed',Apttus_Config2__NetPrice__c = 200,Apttus_Config2__Quantity__c = 2);
        liList.add(lineItem1); 
         Apttus_Config2__LineItem__c lineItem2=new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c=conf.id,Apttus_Config2__LineType__c='Product/Service',Apttus_Config2__ProductId__c=prod.id,Apttus_Config2__PriceListId__c=priceList.id, Apttus_Config2__PriceListItemId__c=pli.id, Apttus_Config2__ItemSequence__c = 1, Apttus_Config2__LineNumber__c = 1,Apttus_Config2__ChargeType__c = 'Subscription Fee',Apttus_Config2__LineStatus__c = 'New',Apttus_Config2__NetPrice__c = 100,APTS_FL_Qty__c = 10,Apttus_Config2__ListPrice__c = 10,Apttus_Config2__BasePrice__c = 10,Apttus_Config2__Quantity__c = 2,APTS_Contract_Term__c='5 Months');
        liList.add(lineItem2);
        insert liList;
            
        PageReference pRef = Page.FL_ApprovalDashboardPage;
        pRef.getParameters().put('retId', proposal.Id);
        Test.setCurrentPage(pRef); 
        
        FL_ApprovalDashboardAJSController ctrl = new FL_ApprovalDashboardAJSController();
        Decimal pr = ctrl.getnewProductsNetPrice();
        String val = ctrl.getProposedDiscount();
        System.debug('Proposed Discount -------------- '+val);
        System.assert(val != null);
                
        System.debug('APTS_New_Holdings__c '+conf.APTS_New_Holdings__c+' APTS_Current_Holdings__c '+conf.APTS_Current_Holdings__c+' APTS_Lapsed_Holdings__c '+conf.APTS_Lapsed_Holdings__c);
        String val1 = ctrl.getProposedNetPrice();
        System.debug('Proposed net price -------------- '+val1);
        System.assert(val1 != null);
        
        String val2 = ctrl.getProposedOverallDiscount();
        System.debug('Proposed Overall Discount -------------- '+val2);
        System.assert(val2 != null);

        List<Apttus_Approval__Approval_Request__c> appReqList = FL_ApprovalDashboardAJSController.getApprovalRequestList(proposal.Id);
        List<Apttus_Approval__Approval_Request_History__c> appReqHis = FL_ApprovalDashboardAJSController.getApprovalRequestHistoryList(proposal.Id);

        String val3 = ctrl.getDiscountChange();
        System.debug('Change in Discount -------------- '+val3);
        System.assert(val3 != null);
        
        String val4 = ctrl.getOverallDiscountChange();
        System.debug('Overall change in Discount -------------- '+val4);
        System.assert(val4 != null);
                       
        String val5 = ctrl.getProposedRPA();
        System.debug('ProposedRPA -------------- '+val5);
        System.assert(val5 != null);
        String val6 = ctrl.getProposedAttorneysTotal();
        
        String proposedACV = ctrl.getProposedACV();
        System.debug('proposedACV -------------- '+proposedACV);
        System.assert(proposedACV != null);
        
        String proposedTCV = ctrl.getProposedTCV();
        System.debug('proposedTCV -------------- '+proposedTCV);
        System.assert(proposedTCV != null);
        
        String changeTCV = ctrl.getTCVChange();
        System.debug('getTCVChange -------------- '+changeTCV);
        System.assert(changeTCV != null);
        
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
     List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c=System.Label.APTS_OC_Test_Id),
        new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other'),
        new KeyValueListStore__c(Name='LCRMDisableStrikeIronServices',TextValue__c='True')};
        insert keyvaluestore;
        
        test.startTest();
        
        Apttus_Proposal__Proposal__c proposal = [select Id, Name, Owner.Name, qp.Apttus_Proposal__Account__c 
                                                from Apttus_Proposal__Proposal__c qp 
                                                where Apttus_Proposal__Proposal_Name__c = 'testproposal'];
        Apttus_Config2__ProductConfiguration__c conf = [select Id from Apttus_Config2__ProductConfiguration__c];
        conf.APTS_Incremental_Growth__c = 20;
        update conf;
            
        PageReference pRef = Page.FL_ApprovalDashboardPage;
        pRef.getParameters().put('retId', proposal.Id);
        Test.setCurrentPage(pRef); 
        
        FL_ApprovalDashboardAJSController ctrl = new FL_ApprovalDashboardAJSController();
        Decimal assetNetPrice = ctrl.getAssetNetPrice();
        System.debug('getAssetNetPrice ------'+assetNetPrice);
        system.assert(proposal !=null);       
        test.stopTest();
        
    }
    static testmethod void testgetFileList(){
        List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c=System.Label.APTS_OC_Test_Id),
        new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other'),
        new KeyValueListStore__c(Name='LCRMDisableStrikeIronServices',TextValue__c='True')};
        insert keyvaluestore;
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
        
   //    FL_ApprovalDashboardAJSController ctrl = new FL_ApprovalDashboardAJSController();
     List<FL_ApprovalDashboardAJSController.Document> document1 =  FL_ApprovalDashboardAJSController.getFileList(ide,'abc') ;
       
         
        test.stopTest();
    } 
     static testmethod void testassociateFilesWithQuote(){
        test.startTest();
        
        FL_ApprovalDashboardAJSController.associateFilesWithQuote(null,'abc') ;
        test.stopTest();   
    }
      static testmethod void testassociateFilesWithQuote1(){
        List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c=System.Label.APTS_OC_Test_Id),
        new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other'),
        new KeyValueListStore__c(Name='LCRMDisableStrikeIronServices',TextValue__c='True')};
        insert keyvaluestore;
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
        Boolean s =FL_ApprovalDashboardAJSController.associateFilesWithQuote(id1,ide) ;
        test.stopTest();   
    }
        
}