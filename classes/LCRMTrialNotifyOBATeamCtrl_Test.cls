@IsTest
public class LCRMTrialNotifyOBATeamCtrl_Test{
    @testSetup static void testDataSetUp() {
        
        KeyValueListStore__c kvs= new KeyValueListStore__c();
        kvs.name= 'ANZUsersProfileId';
        kvs.TextValue__C = '00e30000001ZUki';        
        
        KeyValueListStore__c kvs1= new KeyValueListStore__c();
        kvs1.name= 'LCRMTrialNotifyOBA_ExcludeStages';
        kvs1.TextValue__C = 'Closed Lost,Order Complete';  
        KeyValueListStore__c kvs2= new KeyValueListStore__c();
        kvs2.name= 'LCRMTrialNotifyOBA_NotifyTypes';
        kvs2.TextValue__C = 'New Trial,Update Trial';  
        KeyValueListStore__c kvs3= new KeyValueListStore__c();
        kvs3.name= 'LCRMTrialNotifyOBA_EmailTemp';
        //Commented as the custom setting value is updated as a part of DPS-442
        //kvs3.TextValue__C = 'LCRMTrialNotifyOBAHTMLNewTrailEmail,LCRMTrialNotifyOBAHTMLUpdateTrailEmail';
        kvs3.TextValue__C = 'LCRMTrialNotifyOBAHTMLNewTrailEmailVF,LCRMTrialNotifyOBAHTMLUpdateTrailEmailVF';  
        KeyValueListStore__c kvs4= new KeyValueListStore__c();
        kvs4.name= 'LCRMTrialNotifyOBA_EmailGroup';
        kvs4.TextValue__C = 'test@test.com';  
        KeyValueListStore__c kvs5= new KeyValueListStore__c();
        kvs5.name= 'LCRMTrialNotifyOBA_LookupPageSize';
        kvs5.TextValue__C = '10';  
        KeyValueListStore__c kvs6= new KeyValueListStore__c();
        
        insert new List<KeyValueListStore__c>{kvs,kvs1,kvs2,kvs3,kvs4,kvs5};
        
        TRWaySales__Exit_Criteria_and_I_Ack_Config__c  exitConfig = new TRWaySales__Exit_Criteria_and_I_Ack_Config__c(name = 'Criteria and I Ack Settings',TRWaySales__Display_Exit_Criteria_for_Non_Sequential__c = true,TRWaySales__I_acknowledge_exception__c = 'BU Head,Sales Head',
                                                     TRWaySales__I_acknowledge_required__c = true);
    
        insert exitConfig;
        
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
        
        Product2 testProd1 =UnitTest.getProductInstance();
        testprod1.IsActive = true;
        Product2 testProd2 =UnitTest.getProductInstance();
        testprod2.IsActive = true;
        insert new List<Product2>{testProd1,testProd2};
        
        Id Pricebook2Id = Test.getStandardPricebookId();
        PricebookEntry testEntry = new PricebookEntry(isactive=true,Pricebook2id=Pricebook2Id,Product2Id=testProd1.id,unitprice=200,UseStandardPrice = false);
        System.debug('testEntry : '+testEntry);
        insert new List<PricebookEntry>{testEntry};
        
        Account testAcc = UnitTest.getAccountInstance();
        testAcc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('GLI Account').getRecordTypeId();    
        testAcc.Is_GLI__c = true;    
        insert testAcc;
        
        Contact gliContact = UnitTest.getContactInstance(testAcc.Id);
        gliContact.firstname = 'Shovon';
        gliContact.lastname = 'Bera';
        gliContact.Email = 'Shovon@Bera.com';
        gliContact.accountid = testAcc.id;
        insert gliContact;
        
        Opportunity testOpp1 = UnitTest.getOpportunityInstance(testAcc.Id);
        testopp1.Key_Contact__c = gliContact.id;
        testopp1.stageName = 'Appointment Scheduled';
        testopp1.Pricebook2Id = Pricebook2Id;
        testOpp1.Is_Master_Opportunity__c = true;
        testOpp1.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();        
        testOpp1.Is_GLI__c = TRUE;
        testOpp1.LCRM_Sub_BU__c = 'Elite';
        testOpp1.Expected_End_Date__c = Date.Today();
        testOpp1.CurrencyIsoCode = 'USD';
        testOpp1.LCRM_Split_On__c = false;
        testOpp1.Expiration_Date__c = Date.Today();
        System.debug('Pricebook2Id  : '+testopp1.Pricebook2Id+' : '+Pricebook2Id);
        
        Opportunity testOpp2 = UnitTest.getOpportunityInstance(testAcc.Id);
        testopp2.stageName = 'Appointment Scheduled';
        testopp2.Pricebook2Id = Pricebook2Id;
        testOpp2.Is_Master_Opportunity__c = true;
        testOpp2.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();        
        testOpp2.Is_GLI__c = TRUE;
        testOpp2.LCRM_Sub_BU__c = 'Elite';
        testOpp2.Expected_End_Date__c = Date.Today();
        testOpp2.CurrencyIsoCode = 'USD';
        testOpp2.LCRM_Split_On__c = false;
        Date expDate = Date.Today().addDays(62);
        testOpp2.Expiration_Date__c = expDate;
        insert new List<Opportunity>{testOpp1,testOpp2};
        
        Opportunity opp = [select id,Pricebook2Id,Is_GLI__c  from Opportunity where id =:testOpp1.ID];
        System.debug('opp : '+opp);
        opp.Pricebook2Id = Pricebook2Id;
        update opp;
        
        OpportunityLineItem testLineItem1 = new OpportunityLineItem(opportunityId=testOpp1.id,PricebookEntryId=testEntry.ID,unitprice=100,Quantity=1,LCRM_New_ACV_SalesPrice__c=1,LCRM_Units__c=1, Revenue_Type__c ='Incremental');
        testLineItem1.LCRM_Units__c = 1;
        System.debug('testLineItem1 : '+testLineItem1);
        insert testLineItem1; 
        
        Contract contractObj = new Contract();
        contractObj.AccountId = testAcc.Id;
        //contractObj.TRWay_Retention__Primary_Contact__c = opp.Key_Contact__c;
        contractObj.Status = 'Draft';
        contractObj.LCRM_Transaction_Type__c = 'Unpaid Trial';
        contractObj.LCRM_Originating_Opportunity__c = testOpp1.id;
        contractObj.StartDate = Date.Today();
        contractObj.TR_Retention__Contract_End_Date__c= Date.Today()+14;
        //contractObj.ownerid = opp.ownerid;
        insert contractObj;
        contractObj.Status = 'Activated';
        update contractObj;
    }
    
    //methods to test constructor
    public static testMethod Void LCRMTrialNotifyOBATeamCtrl_TestError(){
        Opportunity testOpp = [SELECT ID,StageName FROM Opportunity WHERE ID not in (SELECT OpportunityId from OpportunityLineItem) LIMIT 1];
        //testOpp.StageName = 'Closed Lost';
        //update testOpp;
        System.debug('testOpp : '+testOpp);
        Opportunity testOpp1 = [SELECT ID FROM Opportunity WHERE ID in (SELECT OpportunityId from OpportunityLineItem) LIMIT 1];
        System.debug('testOpp1 : '+testOpp1);
        Test.startTest();
            ApexPages.StandardController oTestController = new ApexPages.StandardController(testOpp);
            //test error condition
            LCRMTrialNotifyOBATeamCtrl oController = new LCRMTrialNotifyOBATeamCtrl(oTestController);
            Test.setcurrentPage(page.LCRMTrialNotifyOBATeamPage);
            
            KeyValueListStore__c kvs1 = [select id, TextValue__C  from KeyValueListStore__c  where name = 'LCRMTrialNotifyOBA_ExcludeStages'];
            kvs1.TextValue__C = 'Appointment Scheduled,Closed Lost,Order Complete';  
            update kvs1;
            
            oTestController = new ApexPages.StandardController(testOpp);
            //test error condition
            oController = new LCRMTrialNotifyOBATeamCtrl(oTestController);
            Test.setcurrentPage(page.LCRMTrialNotifyOBATeamPage);
        Test.stopTest();
    }
    
    //methods to test constructor
    public static testMethod Void LCRMTrialNotifyOBATeamCtrl_Test(){
        Opportunity testOpp1 = [SELECT ID FROM Opportunity WHERE ID in (SELECT OpportunityId from OpportunityLineItem) LIMIT 1];
        System.debug('testOpp1 : '+testOpp1);
        Test.startTest();
            ApexPages.StandardController oTestController = new ApexPages.StandardController(testOpp1);
            LCRMTrialNotifyOBATeamCtrl oController = new LCRMTrialNotifyOBATeamCtrl(oTestController);
            Test.setcurrentPage(page.LCRMTrialNotifyOBATeamPage);
            ApexPages.currentPage().getParameters().put('id',testOpp1.Id);
            oController.getNotifyTypesList();
            oController.selectNotifyType();
            oController.notifyType = 'New Trial';
            oController.selectNotifyType();
            oController.notifyType = 'Update Trial';
            oController.selectNotifyType();
            Contract cont = [select id from contract where LCRM_Originating_Opportunity__c = :testOpp1.id limit 1];
            oController.contractId = cont.ID;
            oController.emailTemplateObj.addToAdd = 'test@test.com;test1@test.com';
            oController.emailTemplateObj.ccAdd = 'test@test.com;test1@test.com';
            oController.emailTemplateObj.bccAdd = 'test@test.com;test1@test.com';
            oController.sendEmail();
            KeyValueListStore__c kvs1 = [select id, Name, TextValue__C  from KeyValueListStore__c  where name = 'LCRMTrialNotifyOBA_EmailGroup'];
            kvs1.Name = 'LCRMTrialNotifyOBA_EmailGroups';  
            update kvs1;
            oController.getNotifyTypesList();
        Test.stopTest();
    }
}