/*
======================================================================================================================
TEST CLASS NAME: OpportunityTerritorySync_Test
======================================================================================================================
PURPOSE: Validates the functionality provided by the OpportunityTerritorySync class.

CHANGE HISTORY:
======================================================================================================================
DATE             NAME           DESC
2012-10-10       Nandita        Created
31/03/2017       Gunaseelan K   Optimized the code as per JIRA STORY: PS0-1

======================================================================================================================
*/
@isTest
Public class OpportunityTerritorySync_Test{
    
    
   
 @testSetup static void setup() {
        list<Territory2Type> terriType   = [SELECT id, DeveloperName from Territory2Type];
        Territory2Model terrModel = [select id FROM Territory2Model WHERE State = 'Active' ];
        /* Territory2Model terrModel = new Territory2Model();
terrModel.DeveloperName = 'TestterritoryModel';
terrModel.Name = 'TestterritoryModel';
terrModel.State = 'Active';
insert terrModel;*/
       
        Territory2 testterr = new Territory2();
        testterr.AccountAccessLevel = 'Read';
        testterr.DeveloperName = 'testterr78';
        testterr.Territory2ModelId = terrModel.Id;
        testterr.Territory2TypeId = terriType[0].Id;
        testterr.Name = 'testterritory2';
        testterr.TMS_Terr_Num__c = '123';
        insert testterr;
       
        Profile adminProfile = [SELECT Id FROM profile WHERE name='System Administrator'];
        User gliUser;
        gliUser = new User();
        gliUser.Username = 'TestUser1@TR.com'+math.random();
        gliUser.profileid = adminProfile.Id;
        gliUser.Email='testuser'+math.random()+'@thomsonreuters.com';
        gliUser.Alias = 'i';
        //gliUser.FirstName='Informatica';
        gliUser.LastName='Integration';
        gliUser.EmailEncodingKey='UTF-8';
        gliUser.LocaleSidKey='en_US';
        gliUser.LanguageLocaleKey='en_US';
        gliUser.TimeZoneSidKey='America/Los_Angeles';
        gliUser.Sub_Bu__c = 'USL';
       
       
        insert gliUser;
        Territory2 terr2 = [select Id FRoM territory2 WHERE name ='testterritory2' Limit 1];
       
        UserTerritory2Association uta = new UserTerritory2Association();
        uta.Territory2Id = terr2.Id;      
        uta.UserId = gliUser.Id;  
       
        insert uta;
       
        //Insert Account
       
       
        //Insert Opportunity
        //
        ////
       
       
    }


    static testMethod void test_ScheduledOpportunityTerritorySync(){
        Test.startTest();       
        ScheduledOpportunityTerritorySync TestScheduler = new ScheduledOpportunityTerritorySync();
        SchedulableContext sc;
        TestScheduler.execute(sc);
        Test.stopTest();

        }
        
    public static testmethod void OpportunityTerritory_Test(){
        KeyValueListStore__c kvc = new KeyValueListStore__c();
        kvc.name='ANZUsersProfileId';
        kvc.TextValue__c='00e30000001ZUki';
        insert kvc;
        KeyValueListStore__c kvc2 = new KeyValueListStore__c();
        kvc2.name='ReasonWithCompetitor';
        kvc2.TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other';
        insert kvc2;
        RecordtypeIds__c rt = new RecordtypeIds__c();
        rt.name = 'Pre-Pipeline Opportunities';
        rt.recTypeId__c = '01230000001MA4h';
        insert rt;
        RecordtypeIds__c rt2 = new RecordtypeIds__c();
        rt2.name = 'Pipeline Opportunities';
        rt2.recTypeId__c = '01230000001MA4g';
        insert rt2;
        
        Profile adminProfile = [SELECT Id FROM profile WHERE name='System Administrator'];
        Profile gliProfile = [SELECT Id FROM profile WHERE name='GLI Sales User'];
        
        User usr1 = new User();
        usr1.Username = 'TestUser1@TR.com'+math.random();
        usr1.profileid = adminProfile.Id;
        usr1.Email='testuser@thomsonreuters.com';
        usr1.Alias = 'igli';
        usr1.CommunityNickname ='test'+math.random();
        usr1.LastName='Integration';
        usr1.EmailEncodingKey='UTF-8';
        usr1.LocaleSidKey='en_US';
        usr1.LanguageLocaleKey='en_US';
        usr1.TimeZoneSidKey='America/Los_Angeles';
        usr1.Sub_Bu__c = 'USL';
        insert usr1; 

        User usr2 = new User();
        usr2.Username = '_TestJayanth25@TR.com';
        usr2.profileid = gliProfile.Id;
        usr2.Email='test_Jayanth52@thomsonreuters.com';
        usr2.Alias = 'iglii';
        usr2.CommunityNickname = 'Testing'+math.random();
        usr2.LastName='_JayanthIntegration25';
        usr2.EmailEncodingKey='UTF-8';
        usr2.LocaleSidKey='en_US';
        usr2.LanguageLocaleKey='en_US';
        usr2.TimeZoneSidKey='America/Los_Angeles';
        usr2.Sub_Bu__c = 'UKI';
        insert usr2; 
        
        System.runAs(usr2){
        
        list<Territory2Type> terriType   = [SELECT id, DeveloperName from Territory2Type];
        Territory2Model terrModel = [select id FROM Territory2Model WHERE State = 'Active' ];
        
        Territory2 testterr = new Territory2();
        testterr.AccountAccessLevel = 'Read';
        testterr.DeveloperName = 'testterr';
        testterr.Territory2ModelId = terrModel.Id;
        testterr.Territory2TypeId = terriType[0].Id;
        testterr.Name = 'testterritory2';
        testterr.TMS_Terr_Num__c = '123';
        insert testterr;
        
        UserTerritory2Association uta = new UserTerritory2Association();
        uta.Territory2Id = testterr.Id;       
        uta.UserId = usr1.Id;   
        
        insert uta;
    }
  
        System.runAs(usr1){
            Account accObj = new Account();
            accObj.name = 'test acc';
            accObj.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('GLI Account').getRecordTypeId();  
            accObj.BU_Region__c = 'Canada';
            accObj.Bu_Segment__c = 'Professional Tax';
            accObj.Is_GLI__c = true;
            insert accObj;
            
            UserTerritory2Association oUserTerritory = [SELECT Id, Territory2Id, UserId FROM UserTerritory2Association WHERE IsActive=true AND UserId !=null  LIMIT 1];
            UserTerritory2Association oUserTerritory2 = [SELECT Id, Territory2Id, UserId FROM UserTerritory2Association WHERE Id !=:oUserTerritory.Id AND IsActive=true AND UserId != null LIMIT 1];
            
            User oUser = [SELECT Id, Name FROM User WHERE Id=:oUserTerritory.UserId];
            oUser.isActive = true;
            update oUser;
            
            
            Territory2 oTerritory = [SELECT Id, Name FROM Territory2 WHERE Id=:oUserTerritory.Territory2Id];           
            Territory2 oTerritory2 = [SELECT Id, Name FROM Territory2 WHERE Id=:oUserTerritory2.Territory2Id];
            
            Group oGroup = [SELECT Id, RelatedId FROM Group WHERE RelatedId=:oTerritory.Id  LIMIT 1];
            Group oGroup2 = [SELECT Id, RelatedId FROM Group WHERE RelatedId=:oTerritory2.Id LIMIT 1];
            
            
            set<ID> oTerritoryID = new set<ID>();
            oTerritoryID.add(oTerritory.Id);
            oTerritoryID.add(oTerritory2.Id);
            
            List<AccountShare> accountsharelist = new List<AccountShare>();
            AccountShare oAccountShareA = new AccountShare();
            oAccountShareA.AccountId = accObj.Id;
            oAccountShareA.UserOrGroupId = oGroup.Id;
            oAccountShareA.AccountAccessLevel='Edit';
            oAccountShareA.OpportunityAccessLevel='Edit';
            accountsharelist.add(oAccountShareA);
            if(accountsharelist.size()>0){
                insert accountsharelist; 
            }
            
            Opportunity testOpportunity = UnitTest.getOpportunityInstance(accObj.Id);
            testOpportunity.Renewal_Flag__c = false;
            testOpportunity.Selling_Organization__c = 'LRA';
            testOpportunity.Expiration_Date__c = Date.Today().adddays(300);
            testOpportunity.Expected_Revenue_Date__c = date.today();
            testOpportunity.OwnerId = usr1.Id;
            insert testOpportunity;           
        }
        test.starttest(); 
        OpportunityTerritorySync oOpp = new OpportunityTerritorySync();
        ID batchprocessid = Database.executeBatch(oOpp); 
        test.stoptest();
    }
}