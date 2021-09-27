@isTest
public class TestLCRMOptyStatusChangeCtrl{
    /*
@@Description: TestMyLCRMOptyStatusChangeCtrl method is used to test updateStatus and chekc opportunity 
*/
    
    @isTest Private Static void TestMyLCRMOptyStatusChangeCtrl(){
        Test.startTest();
        
        PageReference pageRef = Page.LCRMOptyStatusChange;
        Test.setCurrentPage(pageRef);    
        
        testOpptydata();
        opportunity opptest = [Select ID, Name,OwnerId, LCRM_Sub_BU__c,  Is_GLI__c, Renewal_Flag__c, LCRM_Status__c  FROM OPPORTUNITY Where Name = 'TestNameDataOppty' LIMIT 1];
        System.debug('opptest'+opptest);
        System.debug('opptest ID'+opptest.id);    
        
        
        ApexPages.currentPage().getParameters().put('Id',opptest.id);
        
        ApexPages.StandardController sc = new ApexPages.StandardController(opptest);
        LCRMOptyStatusChangeCtrl opptyIns = new LCRMOptyStatusChangeCtrl(sc);
        PageReference pageRef1 = opptyIns.updateStatus();
        System.debug('pageRef1'+pageRef1);
        String urltest = pageref1.getUrl();
        System.assertEquals(true, urltest.contains(opptest.id));
        PageReference pageRef2 = opptyIns.gotoOpty();
        String urltest2 = pageref2.getUrl();
        System.assertEquals(true, urltest2.contains(opptest.id));
        System.debug('pageRef1'+pageRef2);
        
        Test.stopTest();
        
    }
    /*
@@Description: Negative scenario of TestMyLCRMOptyStatusChangeCtrl method 
*/
    @isTest Private Static void TestMyLCRMOptyStatusChangeCtrllockRecord(){
        
        //User runningUser = createTestUser();
        Profile stdProfile = [SELECT Id,name FROM Profile WHERE Name='System Administrator'];
        User testUser = new User(
            Alias = 'standt', 
            Email='abc1@testorg.com',
            EmailEncodingKey='UTF-8', 
            LastName='Testing', 
            LanguageLocaleKey='en_US',
            LocaleSidKey='en_US', 
            ProfileId = stdProfile.Id,
            TimeZoneSidKey='America/Los_Angeles',
            Sub_Bu__c ='UKI',
            Sales_Org__c = 'GLI',
            UserName='abc1@testorg.com'
            
        );  
        insert testUser;
        User testUserApp = new User(
            Alias = 'standt', 
            Email='abc1@testorg.com',
            EmailEncodingKey='UTF-8', 
            LastName='Testing', 
            LanguageLocaleKey='en_US',
            LocaleSidKey='en_US', 
            ProfileId = stdProfile.Id,
            TimeZoneSidKey='America/Los_Angeles',
            Sub_Bu__c ='UKI',
            Sales_Org__c = 'GLI',
            UserName='abc1@testorg123.com',
            ManagerId = testUser.Id
            
        ); 
        insert testUserApp;
        System.debug('RECORD TYPE**** RunASUSER'+testUserApp.id);
        Test.startTest();
        System.runAs(testUserApp){
            
            PageReference pageRef = Page.LCRMOptyStatusChange;
            Test.setCurrentPage(pageRef);    
            
            testOpptydata();                 
            
            opportunity opptest = [Select ID, Name,OwnerId,LCRM_Sub_BU__c,  Is_GLI__c, Renewal_Flag__c, LCRM_Status__c  FROM OPPORTUNITY Where Name = 'TestNameDataOppty'  LIMIT 1 FOR UPDATE];
            opptest.Expiration_Date__c = System.today() + 5;            
            update opptest;
            System.debug('opptest ID'+opptest.id);
            
            ApexPages.StandardController sc = new ApexPages.StandardController(opptest);
            LCRMOptyStatusChangeCtrl opptyIns = new LCRMOptyStatusChangeCtrl(sc);
            
            //Submit opportunity for Approval
            Approval.ProcessSubmitRequest app = new Approval.ProcessSubmitRequest();
            app.setObjectId(opptest.id);
            Approval.ProcessResult result = Approval.process(app);
            ApexPages.currentPage().getParameters().put('Id',opptest.id);
            
            
            PageReference pageRef1 = opptyIns.updateStatus();
            System.debug('pageRef1'+pageRef1);      
            System.assertEquals(null, pageRef1);
            
        }
        Test.stopTest();       
        
    }
    /*Data setup method*/
    @TestSetup
    public static void testOpptydata(){
        
        KeyValueListStore__c customSett = new KeyValueListStore__c();
        customSett.Name = 'ANZUsersProfileId';
        customSett.TextValue__c = System.Label.Digital_ANZ_User_Profile_Id;
        insert customsett;
        System.debug('customsett'+customsett);
        
        //RecordtypeId custom setting for OpportunityAfterEventListener
        RecordtypeIds__c testRecordtypeSetting= new RecordtypeIds__c();
        testRecordtypeSetting.name = 'Pipeline Opportunities';
        testRecordtypeSetting.recTypeId__c = System.Label.Digital_Pipeline_Record_Type_ID; 
        insert testRecordtypeSetting;
        
        RecordtypeIds__c testRecordtypeSetting2 = new RecordtypeIds__c();
        testRecordtypeSetting2.name = 'Pre-Pipeline Opportunities';
        testRecordtypeSetting2.recTypeId__c = System.Label.Digital_Pre_Pipeline_Record_Type_Id; 
        insert testRecordtypeSetting2;
        
        Id RecordTypeIdOppty = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        System.debug('RecordTypeIdOppty'+RecordTypeIdOppty);
        RecordtypeIds__c testRecordtypeSetting3= new RecordtypeIds__c();
        testRecordtypeSetting3.name = 'GLI Pipeline Opportunity';
        testRecordtypeSetting3.recTypeId__c = RecordTypeIdOppty; 
        insert testRecordtypeSetting3;
        
        Id RecordTypeIdAccount = Schema.SObjectType.Account.getRecordTypeInfosByName().get('GLI Account').getRecordTypeId();       
        
        Account acc = new Account();
        acc.NAME = 'TestLCRMOptyStatusChangeCtrl';
        acc.Type = 'Source System';
        acc.BillingCity = 'San francisco';
        acc.BillingCountry = 'US';
        acc.BillingPostalCode = '91324-45677';
        acc.BillingState = 'IL';
        acc.is_gli__c = true;        
        acc.RecordTypeId = RecordTypeIdAccount;
        insert acc;
        
        System.debug('acc'+acc.id);
        Account ac1 = [SELECT Id, ownerId, Name,recordtypeId, Is_GLI__c FROM Account WHERE Id =: acc.id Limit 1];
        System.debug('RECORD TYPE**** '+ac1);
        
        Opportunity opp = new Opportunity();
        opp.accountId = acc.id;
        opp.Name = 'TestNameDataOppty';
        opp.LCRM_Sub_BU__c = 'UKI';
        opp.Is_GLI__c = true;
        opp.Renewal_Flag__c = true;
        opp.LCRM_Status__c = 'Open';
        opp.StageName = 'Needs Analysis';
        opp.RecordTypeId = RecordTypeIdOppty;        
        opp.CloseDate = System.Today() + 5;        
        insert opp;
        
        Opportunity opps = [SELECT Id, ownerId, accountId,recordtypeId FROM Opportunity WHERE Id =: opp.id Limit 1];
        System.debug('RECORD TYPE**** '+opps);
        
        
    }  
    
    
}