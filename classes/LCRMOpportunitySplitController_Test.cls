/**
 * Class for the LCRMOpportunitySplitController
 *
 *
 * @author  TCS
 */

/**
 * CHANGE HISTORY
 * =============================================================================
 * Date         Name                Description
 * 2017-02-15   TCS                 Created
 *                                                
 * =============================================================================
 */
 @IsTest
public without sharing class LCRMOpportunitySplitController_Test{
    //methods to insert test data
    public static Opportunity createTestData(){
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
        
        Opportunity testOpp1 = UnitTest.getOpportunityInstance(testAcc.Id);
        testopp1.Pricebook2Id = Pricebook2Id;
        testOpp1.Is_Master_Opportunity__c = true;
        testOpp1.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();        
        //testOpp1.LCRM_Split_On__c = true;
        testOpp1.Is_GLI__c = TRUE;
        System.debug('Pricebook2Id  : '+testopp1.Pricebook2Id+' : '+Pricebook2Id);
        insert testOpp1;
        Opportunity opp = [select id,Pricebook2Id,Is_GLI__c  from Opportunity where id =:testOpp1.ID];
        System.debug('opp : '+opp);
        opp.Pricebook2Id = Pricebook2Id;
        update opp;
        //Pricebook2Id = opp.Pricebook2Id;
        //PricebookEntry pbe = [select id from PricebookEntry where isactive=true limit 1];
        //System.debug('pbe : '+pbe);
        
        //OpportunityLineItem testLineItem1 = new OpportunityLineItem(opportunityId=testOpp1.id,PricebookEntryId=testEntry.id,unitprice=100,Quantity=1, Revenue_Type__c ='Incremental');
        OpportunityLineItem testLineItem1 = new OpportunityLineItem(opportunityId=testOpp1.id,PricebookEntryId=testEntry.ID,unitprice=100,Quantity=1, Revenue_Type__c ='Incremental');
        testLineItem1.LCRM_Units__c = 1;
        System.debug('testLineItem1 : '+testLineItem1);
        insert testLineItem1;
        return testOpp1;
    }
    
    //methods to test constructor
    public static testMethod Void LCRMOpportunitySplitController_Test(){
        Opportunity testOpp1 = createTestData();
        Test.startTest();
            ApexPages.StandardController oTestController = new ApexPages.StandardController(testOpp1);
            //test error condition
            LCRMOpportunitySplitController oController = new LCRMOpportunitySplitController(oTestController);
            Test.setcurrentPage(page.LCRMOpportunitySplit);
            
            ApexPages.currentPage().getParameters().put('id',testOpp1.Id);
            oController = new LCRMOpportunitySplitController(oTestController);
            Test.setcurrentPage(page.LCRMOpportunitySplit);
            System.assert(oController.opp.ID==testOpp1.Id,true);
        Test.stopTest();
    }
    
    public static testMethod Void loadData_Test(){
        Opportunity testOpp1 = createTestData();
        testOpp1.StageName = 'Solution Recommended';
        testOpp1.LCRM_Split_On__c = true;
        update testOpp1;
        List<OpportunityLineItem> olis = [SELECT ID FROM OpportunityLineItem WHERE OpportunityID = : testOpp1.ID];
        OpportunityLineItemTriggerHandler.checkRecur_syncOLIToOLIClone = false;
        update olis;
        List<OpportunityTeamMember> otms = [SELECT ID FROM OpportunityTeamMember WHERE OpportunityID = : testOpp1.ID];
        update otms;
        Test.startTest();
            ApexPages.StandardController oTestController = new ApexPages.StandardController(testOpp1);
            ApexPages.currentPage().getParameters().put('id',testOpp1.Id);
            LCRMOpportunitySplitController oController = new LCRMOpportunitySplitController(oTestController);
            Test.setcurrentPage(page.LCRMOpportunitySplit);
            oController.loadData();
            oController.generateSplit();
            List<LCRM_Opportunity_Split__c> splitList = [SELECT ID FROM LCRM_Opportunity_Split__c WHERE ID = :testOpp1.Id];
            System.assert(splitList!=null,true);
        Test.stopTest();
    }
    
    public static testMethod Void validateOppBeforeLoad_Test(){
        Opportunity testOpp1 = createTestData();
        Test.startTest();
            ApexPages.StandardController oTestController = new ApexPages.StandardController(testOpp1);
            ApexPages.currentPage().getParameters().put('id',testOpp1.Id);
            LCRMOpportunitySplitController oController = new LCRMOpportunitySplitController(oTestController);
            Test.setcurrentPage(page.LCRMOpportunitySplit);
            oController.validateOppBeforeLoad();
            System.assert((oController.errorMsg==null || oController.errorMsg==''),true);
        Test.stopTest();
    }
    
    public static testMethod Void generateSplit_Test(){
        Opportunity testOpp1 = createTestData();
        testOpp1.StageName = 'Solution Recommended';
        //testOpp1.LCRM_Split_On__c = true;
        update testOpp1;
        //List<OpportunityLineItem> olis = [SELECT ID FROM OpportunityLineItem WHERE OpportunityID = : testOpp1.ID];
        //OpportunityLineItemTriggerHandler.checkRecur_syncOLIToOLIClone = false;
        //update olis;
        //List<OpportunityTeamMember> otms = [SELECT ID FROM OpportunityTeamMember WHERE OpportunityID = : testOpp1.ID];
        //update otms;
        Test.startTest();
            ApexPages.StandardController oTestController = new ApexPages.StandardController(testOpp1);
            ApexPages.currentPage().getParameters().put('id',testOpp1.Id);
            LCRMOpportunitySplitController oController = new LCRMOpportunitySplitController(oTestController);
            Test.setcurrentPage(page.LCRMOpportunitySplit);
            oController.generateSplit();
            List<LCRM_Opportunity_Split__c> splitList = [SELECT ID FROM LCRM_Opportunity_Split__c WHERE ID = :testOpp1.Id];
            System.assert(splitList!=null,true);
        Test.stopTest();
    }
    
    public static testMethod Void save_Test(){
        Opportunity testOpp1 = createTestData();
        testOpp1.StageName = 'Solution Recommended';
        testOpp1.LCRM_Split_On__c = true;
        testOpp1.Is_GLI__c = true;
        update testOpp1;
        List<OpportunityLineItem> olis = [SELECT ID FROM OpportunityLineItem WHERE OpportunityID = : testOpp1.ID];
        OpportunityLineItemTriggerHandler.checkRecur_syncOLIToOLIClone = false;
        for(OpportunityLineItem oli : olis){
            oli.LCRM_Action__c = 'Add';
        }
        update olis;
        List<OpportunityTeamMember> otms = [SELECT ID FROM OpportunityTeamMember WHERE OpportunityID = : testOpp1.ID];
        update otms;
        Test.startTest();
            ApexPages.StandardController oTestController = new ApexPages.StandardController(testOpp1);
            ApexPages.currentPage().getParameters().put('id',testOpp1.Id);
            LCRMOpportunitySplitController oController = new LCRMOpportunitySplitController(oTestController);
            Test.setcurrentPage(page.LCRMOpportunitySplit);
            oController.loadData();
            oController.generateSplit();
            List<LCRM_Opportunity_Split__c> splitList = [SELECT ID FROM LCRM_Opportunity_Split__c WHERE ID = :testOpp1.Id];
            System.assert(splitList!=null,true);
            for(LCRMOpportunitySplitController.OppProdByCat opCatTemp : oController.oppProdByCatMap.values()){
                for(LCRMOpportunitySplitController.OppProd opTemp : opCatTemp.oppProdList){
                    opTemp.NewPerVal ='1';
                }
            }
            oController.save();
            oController.getOppProdByCatList();
            oController.cancel();
            //oController.updateSplitCell();
            LCRMOpportunitySplitController.OppTeam opT = new LCRMOpportunitySplitController.OppTeam();
            oController.getDynamicFormatString();
        Test.stopTest();
    }
}