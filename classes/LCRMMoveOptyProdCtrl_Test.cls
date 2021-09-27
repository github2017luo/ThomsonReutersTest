/**
 * Test Class for the LCRMMoveOptyProdCtrl
 *
 *
 * @author  TCS
 */

/**
 * CHANGE HISTORY
 * =============================================================================
 * Date         Name                Description
 * 2017-07-15   TCS                 Created
 *                                                
 * =============================================================================
 */
 @IsTest
public class LCRMMoveOptyProdCtrl_Test{
    @testSetup static void testDataSetUp() {
        KeyValueListStore__c kvs= new KeyValueListStore__c();
        kvs.name= 'ANZUsersProfileId';
        kvs.TextValue__C = '00e30000001ZUki';        
        
        KeyValueListStore__c kvs1= new KeyValueListStore__c();
        kvs1.name= 'LCRMMergeOpportunityPageSize';
        kvs1.TextValue__C = '20'; 
         
        KeyValueListStore__c kvs2= new KeyValueListStore__c();
        kvs2.name= 'LCRMMergeOpportunityExcludeStage';
        kvs2.TextValue__C = 'Contract Signed,Order Complete,Closed Lost';  
        
        insert new List<KeyValueListStore__c>{kvs,kvs1,kvs2};
        
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
        testopp1.stageName = 'Appointment Scheduled';
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
    }
    
    //methods to test constructor
    public static testMethod Void LCRMMoveOptyProdCtrl_Test(){
        Opportunity testOpp1 = [SELECT ID FROM Opportunity WHERE ID in (SELECT OpportunityId from OpportunityLineItem) LIMIT 1];
        Opportunity testTargetOpp1 = [SELECT ID FROM Opportunity WHERE ID <> :testOpp1.ID LIMIT 1];
        Test.startTest();
            ApexPages.StandardController oTestController = new ApexPages.StandardController(testOpp1);
            //test error condition
            LCRMMoveOptyProdCtrl oController = new LCRMMoveOptyProdCtrl(oTestController);
            Test.setcurrentPage(page.LCRMMoveOptyProd);
            
            ApexPages.currentPage().getParameters().put('id',testOpp1.Id);
            oController = new LCRMMoveOptyProdCtrl(oTestController);
            Test.setcurrentPage(page.LCRMMoveOptyProd);
            System.assert(oController.opp.ID==testOpp1.Id,true);
            oController.showProducts();
            oController.getOppProdList();
            oController.transferProds();
            oController.pagOppObj.selectOpp = testTargetOpp1.ID;
            oController.getSelOppDetails();
            oController.getSelOppProdDetails();
            oController.transferProds();
            oController.pagOppObj.getOppWrapList();
            oController.pagOppObj.selectOpp();
            Boolean testBoolean = oController.pagOppObj.hasNext;
            testBoolean = oController.pagOppObj.hasPrevious;
            Integer pgNum = oController.pagOppObj.pageNumber;
            oController.pagOppObj.first();
            oController.pagOppObj.last();
            oController.pagOppObj.previous();
            oController.pagOppObj.next();
            oController.pagOppObj.cancel();
            testBoolean = oController.pagOppObj.AllowMovePrev;
            testBoolean = oController.pagOppObj.AllowMoveNext;
        Test.stopTest();
    }
    
    //methods to test negative
    public static testMethod Void LCRMMoveOptyProdCtrl_TestNegative(){
        Opportunity testOpp1 = [SELECT ID,(SELECT ID, PricebookEntryId FROM OpportunityLineItems) FROM Opportunity WHERE ID in (SELECT OpportunityId from OpportunityLineItem) LIMIT 1];
        System.debug('testOpp1 : '+testOpp1);
        System.debug('testOpp12 : '+testOpp1.OpportunityLineItems);
        Opportunity testTargetOpp1 = [SELECT ID FROM Opportunity WHERE ID <> :testOpp1.ID LIMIT 1];
        Test.startTest();
            ApexPages.StandardController oTestController = new ApexPages.StandardController(testOpp1);
            //test error condition
            ApexPages.currentPage().getParameters().put('id',testOpp1.Id);
            LCRMMoveOptyProdCtrl oController = new LCRMMoveOptyProdCtrl(oTestController);
            Test.setcurrentPage(page.LCRMMoveOptyProd);
            System.assert(oController.opp.ID==testOpp1.Id,true);
            oController.pagOppObj.selectOpp = testTargetOpp1.ID;
            PriceBookEntry etr = [SELECT ID, Product2ID FROM PriceBookEntry WHERE id= :testOpp1.OpportunityLineItems[0].PricebookEntryId ];
            Product2 prod = [SELECT ID, IsActive FROM Product2 WHERE ID = :etr.Product2ID ];
            prod.IsActive = false;
            update prod;
            oController.transferProds();
            
        Test.stopTest();
    }
}