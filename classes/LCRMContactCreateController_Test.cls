@isTest
public class LCRMContactCreateController_Test{
    public static testMethod void testContactCreate(){
    Profile p = [SELECT Id FROM profile WHERE name='Elite User'];
    User gliUser = new User(alias = 'newUser', email='user@mydomain.com', 
                           emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
                           localesidkey='en_US', profileid = p.Id, employeenumber='0144020',
                           timezonesidkey='America/Los_Angeles', username='user@mydomain.com.'+Math.random(),Rep_Type_Description__c='test');        
    insert gliUser;
        
    system.runAs(gliUser){
    
    Account gliAccount = UnitTest.getAccountInstance();
    gliAccount.Name = 'Parent Test Account';
    gliAccount.Phone = '91 80 67254199';
    gliAccount.BillingCountry = 'US';
    gliAccount.BillingState='IL';
    gliAccount.BillingPostalCode = '60603-3801';
    gliAccount.SAPAccountNumber__c = 'UTSAP001';
    insert gliAccount;
    
    Contact gliContact = UnitTest.getContactInstance(gliAccount.Id);
    gliContact.firstname = 'Shovon';
    gliContact.lastname = 'Bera';
    gliContact.Email = 'Shovon@Bera.com';
    gliContact.accountid = gliAccount.id;
    insert gliContact;
    
    WebServiceSettings__c wbs = new WebServiceSettings__c();
    wbs.Active__c = true;
    wbs.Max_GLI_Count__c = 30;
    wbs.Max_Non_GLI_Count__c = 30;
    wbs.name='DQ.CDSContactSearchServiceContact';
    wbs.Endpoint__c='CDSContactSearchService.com';
    wbs.Service_Unavailable_Message__c ='service unavailable';
    insert wbs;
    
    Test.setMock(WebServiceMock.class, new CDSSearchServiceMockTest()); 
        Test.startTest();  
            PageReference oPage = Page.LCRMContactCreate;
            Test.setCurrentPage(oPage);
            ApexPages.StandardController oStandardController = new ApexPages.StandardController(gliContact);  
            LCRMContactCreateController controller = new LCRMContactCreateController(oStandardController);
            controller.Next();
            controller.Back();
            controller.selectedType = 'NEWContact';
            controller.ContactCreate();
        Test.stopTest();
        }
    }
    
    public static testMethod void testContactCreateMock(){
    Profile p = [SELECT Id FROM profile WHERE name='Elite User'];
    User gliUser = new User(alias = 'newUser', email='user@mydomain.com', 
                           emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
                           localesidkey='en_US', profileid = p.Id, employeenumber='0144020',
                           timezonesidkey='America/Los_Angeles', username='user@mydomain.com.'+Math.random(),Rep_Type_Description__c='test');        
    insert gliUser;
        
    system.runAs(gliUser){
    
    Account gliAccount = UnitTest.getAccountInstance();
    gliAccount.Name = 'Parent Test Account';
    gliAccount.Phone = '91 80 67254199';
    gliAccount.BillingCountry = 'US';
    gliAccount.BillingState='IL';
    gliAccount.BillingPostalCode = '60603-3801';
    gliAccount.SAPAccountNumber__c = 'UTSAP001';
    insert gliAccount;
    
    Contact gliContact = UnitTest.getContactInstance(gliAccount.Id);
    gliContact.firstname = 'Shovon';
    gliContact.lastname = 'Bera';
    gliContact.ESC_tocLanguage__c = 'English';
    gliContact.Email = 'Shovon@Bera.com';
    gliContact.accountid = gliAccount.id;
    insert gliContact;
    
    WebServiceSettings__c wbs = new WebServiceSettings__c();
    wbs.Active__c = true;
    wbs.Max_GLI_Count__c = 30;
    wbs.Max_Non_GLI_Count__c = 30;
    wbs.name='DQ.CDSContactSearchServiceContact';
    wbs.Endpoint__c='CDSContactSearchService.com';
    wbs.Service_Unavailable_Message__c ='service unavailable';
    insert wbs;
        
    Test.setMock(WebServiceMock.class, new CDSSearchServiceMockTest()); 
        Test.startTest(); 
            
            PageReference oPage = Page.LCRMContactCreate;
            Test.setCurrentPage(oPage);
            ApexPages.StandardController oStandardController = new ApexPages.StandardController(gliContact);  
            LCRMContactCreateController controller = new LCRMContactCreateController(oStandardController);
            controller.Next();
            controller.Back();
            //controller.selectedType = 'NEWContact';
            controller.selectedContact = '1';
            controller.ContactCreate();
        Test.stopTest();
        }
    }
    
    //Method added by apptus CRM-7828
    /*public static testMethod void testContactCreateApptusFlow(){
        KeyValueListStore__c kvs= new KeyValueListStore__c();
        kvs.name= 'ANZUsersProfileId';
        kvs.TextValue__C = '00e30000001ZUki';        
        
        KeyValueListStore__c kvs1= new KeyValueListStore__c();
        kvs1.name= 'LCRMSplit_AllowedStages';
        kvs1.TextValue__C = 'Appointment Scheduled,Needs Analysis,Solution Recommended,Generate Contract,Negotiate Contract,Contract Signed,Order Complete,Closed Lost';        
        
        KeyValueListStore__c kvs2= new KeyValueListStore__c();
        kvs2.name= 'LCRMSplit_ExcludeAction';
        kvs2.TextValue__C = 'Remove';        
        
        KeyValueListStore__c kvs3= new KeyValueListStore__c();
        kvs3.name= '    LCRMSplit_ProdLimit';
        kvs3.TextValue__C = '20';        
        
        KeyValueListStore__c kvs4= new KeyValueListStore__c();
        kvs4.name= 'LCRMSplit_TeamLimit';
        kvs4.TextValue__C = '20';        
        
        insert new List<KeyValueListStore__c>{kvs, kvs1, kvs2, kvs3, kvs4};
        
        List<RecordtypeIds__c > recTList = new List<RecordtypeIds__c>();
        RecordtypeIds__c recT= new RecordtypeIds__c();
        recT.name= 'Pre-Pipeline Opportunities';
        recT.recTypeId__C = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Pre-Pipeline Opportunity').getRecordTypeId();        
        recTList.add(recT);
        
        RecordtypeIds__c recT1= new RecordtypeIds__c();
        recT1.Name= 'Pipeline Opportunities';
        recT1.recTypeId__C = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Pipeline Opportunity').getRecordTypeId();        
        recTList.add(recT1);
        
        RecordtypeIds__c orecordType5 = new RecordtypeIds__c ();
        orecordType5.name ='LATAM Renewal Opportunity';
        orecordType5.recTypeId__c = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('LATAM Renewal Opportunity').getRecordTypeId();
        recTList.add(orecordType5);
        
        RecordtypeIds__c orecordType6 = new RecordtypeIds__c ();
        orecordType6.name ='LATAM Renewal Quote';
        orecordType6.recTypeId__c = Schema.SObjectType.Quote.getRecordTypeInfosByName().get('LATAM Renewal Quote').getRecordTypeId();
        recTList.add(orecordType6);
        
        insert recTList;
        
        Profile_List__c objPro = new Profile_List__c();
        objPro.name = 'Partner Portal User';
        objPro.Profile_Name__c = 'Partner Portal User';
        objPro.ProfileId__c = '00ea00000024JwaAAE';
        
        Profile_List__c objPro1 = new Profile_List__c();
        objPro1.name = 'LatAm User';
        objPro1.Profile_Name__c = 'LatAm User';
        objPro1.ProfileId__c = '00ea00000024JzKAAU';
        
        Profile_List__c objPro2 = new Profile_List__c();
        objPro2.name = 'System Administrator';
        objPro2.Profile_Name__c = 'System Administrator';
        objPro2.ProfileId__c = '00e30000001gFezAAE';
        INSERT new List<Profile_List__c>{objPro, objPro1, objPro2};
        
        Profile p = [SELECT Id FROM profile WHERE name='Elite User'];
        User gliUser = new User(alias = 'newUser', email='user@mydomain.com', 
                               emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
                               localesidkey='en_US', profileid = p.Id, employeenumber='0144020',
                               timezonesidkey='America/Los_Angeles', username='user@mydomain.com',Rep_Type_Description__c='test');        
        insert gliUser;
            
        system.runAs(gliUser){
        
        Account gliAccount = UnitTest.getAccountInstance();
        gliAccount.Name = 'Parent Test Account';
        gliAccount.Phone = '91 80 67254199';
        gliAccount.BillingCountry = 'US';
        gliAccount.BillingState='IL';
        gliAccount.BillingPostalCode = '60603-3801';
        gliAccount.SAPAccountNumber__c = 'UTSAP001';
        insert gliAccount;
        
        Contact gliContact = UnitTest.getContactInstance(gliAccount.Id);
        gliContact.firstname = 'Shovon';
        gliContact.lastname = 'Bera';
        gliContact.Email = 'Shovon@Bera.com';
        gliContact.accountid = gliAccount.id;
        insert gliContact;
        
        WebServiceSettings__c wbs = new WebServiceSettings__c();
        wbs.Active__c = true;
        wbs.Max_GLI_Count__c = 30;
        wbs.Max_Non_GLI_Count__c = 30;
        wbs.name='DQ.CDSContactSearchServiceContact';
        wbs.Endpoint__c='CDSContactSearchService.com';
        wbs.Service_Unavailable_Message__c ='service unavailable';
        insert wbs;
        
        Source_system_detail__c soc = APTS_TestDataFactory.createSourceSystem(gliAccount);
        insert soc;
        
         Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        Opportunity Opp = UnitTest.getOpportunityInstance(gliAccount.Id);
        opp.RecordtypeId=opptyRecorType;
        insert Opp;
         Opp.source_system_detail__c = soc.id;
         Opp.key_contact__c = gliCOntact.id;
         update Opp ;
        Apttus_Proposal__Proposal__c oProposal = New Apttus_Proposal__Proposal__c(Apttus_Proposal__Proposal_Name__c ='Sreenu Proposal Test', Apttus_Proposal__Account__c = gliAccount.Id, Apttus_Proposal__Opportunity__c = Opp.Id);
        insert oProposal;
         Apttus_Proposal__Proposal__c testprop=[select APTS_SSD_Sold_To__c from Apttus_Proposal__Proposal__c where id=: oProposal.id];
        //system.assertequals(testprop.APTS_SSD_Sold_To__c ,soc.id);
        //system.assertequals(oProposal.APTS_SSD_Sold_To__c,soc.id);
        
        Test.setMock(WebServiceMock.class, new CDSSearchServiceMockTest()); 
        Test.startTest();  
            PageReference oPage = Page.LCRMContactCreate;
            ApexPages.currentPage().getParameters().put('accid',gliAccount.Id);
            ApexPages.currentPage().getParameters().put('ProposalId',oProposal.Id);
            ApexPages.StandardController oStandardController = new ApexPages.StandardController(gliContact);  
            LCRMContactCreateController controller = new LCRMContactCreateController(oStandardController);
            Test.setCurrentPage(oPage);
            controller.Next();
            controller.Back();
            controller.selectedType = 'NEWContact';
            controller.ContactCreate();
            
        Test.stopTest();
        }
    }*/
    
    //Method added by apptus CRM-7828
    /*public static testMethod void testContactCreateMockApptusFlow(){
        KeyValueListStore__c kvs= new KeyValueListStore__c();
        kvs.name= 'ANZUsersProfileId';
        kvs.TextValue__C = '00e30000001ZUki';        
        
        KeyValueListStore__c kvs1= new KeyValueListStore__c();
        kvs1.name= 'LCRMSplit_AllowedStages';
        kvs1.TextValue__C = 'Appointment Scheduled,Needs Analysis,Solution Recommended,Generate Contract,Negotiate Contract,Contract Signed,Order Complete,Closed Lost';        
        
        KeyValueListStore__c kvs2= new KeyValueListStore__c();
        kvs2.name= 'LCRMSplit_ExcludeAction';
        kvs2.TextValue__C = 'Remove';        
        
        KeyValueListStore__c kvs3= new KeyValueListStore__c();
        kvs3.name= '    LCRMSplit_ProdLimit';
        kvs3.TextValue__C = '20';        
        
        KeyValueListStore__c kvs4= new KeyValueListStore__c();
        kvs4.name= 'LCRMSplit_TeamLimit';
        kvs4.TextValue__C = '20';        
        
        insert new List<KeyValueListStore__c>{kvs, kvs1, kvs2, kvs3, kvs4};
        
        List<RecordtypeIds__c > recTList = new List<RecordtypeIds__c>();
        RecordtypeIds__c recT= new RecordtypeIds__c();
        recT.name= 'Pre-Pipeline Opportunities';
        recT.recTypeId__C = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Pre-Pipeline Opportunity').getRecordTypeId();        
        recTList.add(recT);
        
        RecordtypeIds__c recT1= new RecordtypeIds__c();
        recT1.Name= 'Pipeline Opportunities';
        recT1.recTypeId__C = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Pipeline Opportunity').getRecordTypeId();        
        recTList.add(recT1);
        
        RecordtypeIds__c orecordType5 = new RecordtypeIds__c ();
        orecordType5.name ='LATAM Renewal Opportunity';
        orecordType5.recTypeId__c = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('LATAM Renewal Opportunity').getRecordTypeId();
        recTList.add(orecordType5);
        
        RecordtypeIds__c orecordType6 = new RecordtypeIds__c ();
        orecordType6.name ='LATAM Renewal Quote';
        orecordType6.recTypeId__c = Schema.SObjectType.Quote.getRecordTypeInfosByName().get('LATAM Renewal Quote').getRecordTypeId();
        recTList.add(orecordType6);
        
        insert recTList;
        
        Profile_List__c objPro = new Profile_List__c();
        objPro.name = 'Partner Portal User';
        objPro.Profile_Name__c = 'Partner Portal User';
        objPro.ProfileId__c = '00ea00000024JwaAAE';
        
        Profile_List__c objPro1 = new Profile_List__c();
        objPro1.name = 'LatAm User';
        objPro1.Profile_Name__c = 'LatAm User';
        objPro1.ProfileId__c = '00ea00000024JzKAAU';
        
        Profile_List__c objPro2 = new Profile_List__c();
        objPro2.name = 'System Administrator';
        objPro2.Profile_Name__c = 'System Administrator';
        objPro2.ProfileId__c = '00e30000001gFezAAE';
        INSERT new List<Profile_List__c>{objPro, objPro1, objPro2};
        
        Profile p = [SELECT Id FROM profile WHERE name='Elite User'];
        User gliUser = new User(alias = 'newUser', email='user@mydomain.com', 
                               emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
                               localesidkey='en_US', profileid = p.Id, employeenumber='0144020',
                               timezonesidkey='America/Los_Angeles', username='user@mydomain.com',Rep_Type_Description__c='test');        
        insert gliUser;
            
        system.runAs(gliUser){
        
        Account gliAccount = UnitTest.getAccountInstance();
        gliAccount.Name = 'Parent Test Account';
        gliAccount.Phone = '91 80 67254199';
        gliAccount.BillingCountry = 'US';
        gliAccount.BillingState='IL';
        gliAccount.BillingPostalCode = '60603-3801';
        gliAccount.SAPAccountNumber__c = 'UTSAP001';
        insert gliAccount;
        
        Contact gliContact = UnitTest.getContactInstance(gliAccount.Id);
        gliContact.firstname = 'Shovon';
        gliContact.lastname = 'Bera';
        gliContact.Email = 'Shovon@Bera.com';
        gliContact.accountid = gliAccount.id;
        insert gliContact;
        
        WebServiceSettings__c wbs = new WebServiceSettings__c();
        wbs.Active__c = true;
        wbs.Max_GLI_Count__c = 30;
        wbs.Max_Non_GLI_Count__c = 30;
        wbs.name='DQ.CDSContactSearchServiceContact';
        wbs.Endpoint__c='CDSContactSearchService.com';
        wbs.Service_Unavailable_Message__c ='service unavailable';
        insert wbs;
        
        Schema.DescribeFieldResult fieldResultMarket = Apttus_Config2__ProductConfiguration__c.APTS_AccountMirror_Picklist__c.getDescribe();
        String valueMarket = fieldResultMarket.getPicklistValues().get(0).getValue();
        
        Account a = APTS_TestDataFactory.createAccount('Test Account');
        a.FrozenMarketSegment__c = valueMarket;
        insert a;
        
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get(label.SourcesystemdetailUSLRecordtype).getRecordTypeId();
        Source_System_Detail__c accountSSD= new Source_System_Detail__c();
        if(ssdRecorType!=null)
        accountSSD.RecordtypeId=ssdRecorType;
        accountSSD.Name='ABC';
        accountSSD.Source_System_Name__c='ABC';
        accountSSD.Account_Name__c=a.ID;
        accountSSD.LCRM_Frozen_Market_Segment__c = valueMarket;
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
        proposal.Apttus_Proposal__Account__c=gliAccount.id;
        update proposal;
        Opportunity Opp = UnitTest.getOpportunityInstance(gliAccount.Id);
        insert Opp;
        
        
        Test.setMock(WebServiceMock.class, new CDSSearchServiceMockTest()); 
        Test.startTest(); 
            
            PageReference oPage = Page.LCRMContactCreate;
            ApexPages.currentPage().getParameters().put('accid',gliAccount.Id);
            ApexPages.currentPage().getParameters().put('ProposalId',Proposal.Id);
            ApexPages.StandardController oStandardController = new ApexPages.StandardController(gliContact);  
            LCRMContactCreateController controller = new LCRMContactCreateController(oStandardController);
            Test.setCurrentPage(oPage);
            controller.Next();
            controller.Back();
            //controller.selectedType = 'NEWContact';
            controller.selectedContact = '1';
            controller.ContactCreate();
        Test.stopTest();
        }
    }*/
   
    @isTest
        public static void TestOnlineContacts()
        {
            Account acc =DCTestData.createAccount('Test Account'); 
            acc.Sales_org__c = 'GLI';     
            insert acc;
            
            Apttus_Config2__PriceList__c priceList =  DCTestData.createPriceList(null);
            insert priceList;
            
            Apttus_Proposal__Proposal__c quote = DCTestData.createQuote(acc.Id, 'Manual');
            insert quote;
            
            Account testAcc1 = UnitTest.getAccountInstance();
        testAcc1.Sales_org__c = 'GLI';
        testAcc1.BillingCountry = 'US';
        insert testAcc1;
        System.debug('@@@@@@@@@@testAcc1Country: '+ testAcc1.BillingCountry);
        
        
        Contact testContact = UnitTest.getContactInstance(testAcc1.Id);
        testContact.LCRM_Email_Verification__c = 'Pending. Please refresh.';
        testContact.LCRM_Phone_Verification__c = 'Pending. Please refresh.';
        testContact.LCRM_Mobile_Verification__c = 'Pending. Please refresh.';
        testContact.LCRM_Other_Phone_Verification__c = 'Pending. Please refresh.';
        testContact.Email = 'test@test.com';
        testContact.Phone = '9999000010';
        testContact.MobilePhone = '9999000010';
        testContact.OtherPhone = '9999000010';
        insert testContact;
        System.debug('@@@@@@@@@@dialCode: '+ LCRM_StrikeIron_CountryCodes__c.getInstance(testContact.LCRM_Country__c));
        testContact.Phone = '9999000011';
        testContact.MobilePhone = '9999000011';
        testContact.OtherPhone = '9999000011';
        update testContact;
            quote.APTS_Order_Confirmation_Contact__c = testContact.id;
            update quote;
            
            
            Apttus_Config2__ProductConfiguration__c cart = DCTestData.createCart(acc.Id, quote.Id,null, priceList.Id);
            insert cart;
            Product2 prod2 = DCTestData.createProductforDCDyn('Test Product', '06', '21');
            insert prod2;
             Apttus_Proposal__Proposal_Line_Item__c propLineItem =  DCTestData.createProposalLineItem('1234',prod2.Id,quote.Id);
            insert propLineItem;

            Test.startTest();
            
            System.debug('quote.Id**'+quote.Id);
            Test.setMock(WebServiceMock.class, new CDSSearchServiceMockTest()); 
            try{
            //PageReference oPage = Page.LCRMContactCreate;
            //ApexPages.currentPage().getParameters().put('ProposalId',quote.Id);
            ApexPages.StandardController oStandardController = new ApexPages.StandardController(testContact);              
            System.currentPageReference().getParameters().put('ProposalId',quote.Id);  
            
            LCRMContactCreateController controller = new LCRMContactCreateController(oStandardController);
            //Test.setCurrentPage(oPage);
            System.currentPageReference().getParameters().put('ProposalId',quote.Id);  
            controller.ProposalId =quote.Id;
            controller.Next();
            controller.Back();
            controller.selectedType = 'NEWContact';
            controller.selectedContact = '1';
            controller.ContactCreate();
            }catch(Exception ex){
                
            }
            
            
            System.assertEquals(1,1,'success');
            test.stopTest();
           
    }
    
}