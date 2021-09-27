/*
======================================================================================================================
TEST CLASS NAME: 
======================================================================================================================
PURPOSE: Validates the functionality provided by the AccountDetailController class.

CHANGE HISTORY:
======================================================================================================================
DATE             NAME           DESC
31/03/2017       Gunaseelan K   Optimized the code as per JIRA STORY: PS0-1
======================================================================================================================
*/
@isTest// (SeeAllData=true)
public class OpportunityTerritoryUpdate_test {

    
    @testSetup static void setup() {
   
        TRWaySales__Exit_Criteria_and_I_Ack_Config__c panaroma= new TRWaySales__Exit_Criteria_and_I_Ack_Config__c();
        panaroma.Name='Criteria and I Ack Settings';
        panaroma.TRWaySales__Display_Exit_Criteria_for_Non_Sequential__c=true;
        panaroma.TRWaySales__I_acknowledge_exception__c='TR Legal Sales Rep';
        panaroma.TRWaySales__I_acknowledge_required__c=true;
        insert panaroma;
        
        KeyValueListStore__c kv1= new KeyValueListStore__c();
        kv1.Name='ANZUsersProfileId';
        kv1.TextValue__c='00e30000001ZUki';
        insert kv1;
        
        RecordtypeIds__c recT= new RecordtypeIds__c();
        recT.name= 'Pre-Pipeline Opportunities';
        recT.recTypeId__C = '012a0000001ZJxn';        
        insert recT;
        
        RecordtypeIds__c recT1= new RecordtypeIds__c();
        recT1.Name= 'Pipeline Opportunities';
        recT1.recTypeId__C = '012a0000001ZJxn';
        insert recT1;
        
        RecordtypeIds__c orecordType5 = new RecordtypeIds__c ();
        orecordType5.name ='LATAM Renewal Opportunity';
        orecordType5.recTypeId__c = '012M0000000509c';
        insert orecordType5;
        
        RecordtypeIds__c orecordType6 = new RecordtypeIds__c ();
        orecordType6.name ='LATAM Renewal Quote';
        orecordType6.recTypeId__c = '012M0000000509X';
        insert orecordType6;
        
        Profile_List__c objPro = new Profile_List__c();
        objPro.name = 'Partner Portal User';
        objPro.Profile_Name__c = 'Partner Portal User';
        objPro.ProfileId__c = '00ea00000024JwaAAE';
        INSERT objPro;
        
        Profile_List__c objPro1 = new Profile_List__c();
        objPro1.name = 'LatAm User';
        objPro1.Profile_Name__c = 'LatAm User';
        objPro1.ProfileId__c = '00ea00000024JzKAAU';
        INSERT objPro1;
        
        Profile_List__c objPro2 = new Profile_List__c();
        objPro2.name = 'System Administrator';
        objPro2.Profile_Name__c = 'System Administrator';
        objPro2.ProfileId__c = '00e30000001gFezAAE';
        INSERT objPro2;
        
        Id accRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect').getRecordTypeId();
        Account acc= UnitTest.getAccountInstance();
        acc.RecordTypeId=accRecTypeId;
        insert acc;
        contact cont = UnitTest.getContactInstance(acc.Id);
        insert cont; 
        Id oppRecTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Pipeline Opportunity').getRecordTypeId();
        Opportunity opp= UnitTest.getOpportunityInstance(acc.Id);
        opp.StageName='Qualifying';
        opp.RecordTypeId=oppRecTypeId;
        opp.Reservation_Number__c = null;
        opp.CloseDate=System.Today();
        opp.OwnerId=userinfo.getUserId();
        insert opp;
        
        Product2 prod= UnitTest.getProductInstance();
        prod.ProductCode='12345678';
        insert prod;
        
        Id Pricebook2Id = Test.getStandardPricebookId();
        PricebookEntry teststandardEntry = new PricebookEntry(isactive=true,Pricebook2id=Pricebook2Id,Product2Id=prod.id,unitprice=200,UseStandardPrice = false);
        insert teststandardEntry ;
        
        Pricebook2 testpb = new Pricebook2();
        testpb.Name = 'US Legal/LMS';
        testpb.IsActive= true;
        insert testpb;
        
        PricebookEntry testEntry = new PricebookEntry();
        testEntry.isActive = true;
        testEntry.Pricebook2id = testpb.id;
        testEntry.Product2Id=prod.id;
        testEntry.unitprice=200;
        testEntry.UseStandardPrice = false;
        insert testEntry;
    }
 
    static testMethod void testOpportunityTerritoryUpdate(){  
        /*    Set<Id> OptyIds = new Set<ID>();
set<Id> ownerIds = new set<ID>();
set<Id> TerritoryIds = new set<ID>();
set<ID> userterritoryids=new set<ID>();

Profile p = [SELECT Id FROM profile WHERE name='System Administrator'];   
User u1 = new User(alias = 'newUser', email='user@mydomain.com', 
emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
localesidkey='en_US', profileid = p.Id, employeenumber='0144020',
timezonesidkey='America/Los_Angeles', username='user@mydomain.com',IsActive=true);        
insert u1;


System.runAs(u1){

List<Opportunity> listOpportunity = new List<Opportunity>();

List<Account> oAccount = new List<Account>();
oAccount = [SELECT Id FROM Account];
Territory ut1=new Territory(name='Test');
Ut1.ForecastUserId=u1.Id; 


insert ut1;


/*  
//Test Records for Positive test
for (Integer i = 1; i<10; i++){
Opportunity oOpportunity = new Opportunity(Account='test');

listOpportunity.add(oOpportunity);
OwnerIds.add(oOpportunity.OwnerID);
TerritoryIds.add(oOpportunity.TerritoryId);

}
insert listOpportunity;

List<Opportunity> lstOpp = new List<Opportunity>();
lstOpp = [SELECT Id, OwnerID, TerritoryId from Opportunity where AccountId IN: oAccount and  CloseDate >= : system.today()];
for(Opportunity oOpp : lstOpp){
OptyIds.add(oOpp.Id);      
}


List<UserTerritory> myList = [SELECT Id, UserId, TerritoryId FROM UserTerritory WHERE Id = '04Sa0000003cjpfEAA'];
Test.StartTest();
OpportunityTerritoryUpdate oOpp = new OpportunityTerritoryUpdate();
ID batchprocessid = Database.executeBatch(oOpp);
Test.StopTest();  

//Positive Test 
AsyncApexJob OAsyncApexJob = [Select NumberOfErrors,JobItemsProcessed,TotalJobItems From AsyncApexJob where Id =:batchprocessid];
System.assertEquals(0,OAsyncApexJob.NumberOfErrors);
//system.debug('size***********'+RecordIds.size());
for(Id TestId : OptyIds){     
System.debug('TestId '+TestId);
//System.assertEquals(true,OpportunityTerritorySync.RecordIds.contains(TestId));
}

for(Id TestId1 : ownerIds){     
System.debug('TestId '+TestId1);
//System.assertEquals(false,OpportunityTerritorySync.RecordIds.contains(TestId1));

}
for(Id TestId2 : TerritoryIds){     
System.debug('TestId '+TestId2);
//System.assertEquals(false,OpportunityTerritorySync.RecordIds.contains(TestId2));

}
}
}


   

// Test Method
/*static testMethod void test_ScheduledOpportunityTerritorySync(){
Test.startTest();       
ScheduledOpportunityTerritorySync TestScheduler = new ScheduledOpportunityTerritorySync();
SchedulableContext sc;
TestScheduler.execute(sc);
Test.stopTest();    
}*/
        
        list<Territory2Type> terriType   = [SELECT id, DeveloperName from Territory2Type];
        Territory2Model terrModel = new Territory2Model();
        terrModel.DeveloperName = 'TestterritoryModel';
        terrModel.Name = 'TestterritoryModel';
        insert terrModel;
        
        Territory2 testterr = new Territory2();
        testterr.AccountAccessLevel = 'Read';
        testterr.Territory2ModelId = terrModel.Id;
        testterr.Territory2TypeId = terriType[0].Id;
        testterr.Name = 'testterritory2';
        testterr.DeveloperName = 'testterritory2';
        insert testterr;
        
        UserTerritory2Association utterr = new UserTerritory2Association();
        utterr.userId = userinfo.getUserId();
        utterr.Territory2Id = testterr.Id;
        insert utterr;
    /*   
UserTerritory2Association userterr = [SELECT Id, UserId, Territory2Id FROM UserTerritory2Association WHERE IsActive=true limit 1];
User u1 = [SELECT Id FROM User WHERE Id =: userterr.UserId];
System.runAs(u1){

Account oAccount = UnitTest.getAccountInstance();     
insert oAccount;

Opportunity oOpportunity = UnitTest.getOpportunityInstance(oAccount.Id);
insert oOpportunity;
*/
        
        Test.StartTest();
        OpportunityTerritoryUpdate oOpp = new OpportunityTerritoryUpdate();
        ID batchprocessid = Database.executeBatch(oOpp);       
        Test.StopTest();  
      //}
    }
    
    static testMethod void test_ScheduledOpportunityTerritoryUpdate(){
        Test.startTest();       
        ScheduledOpportunityTerritoryUpdate TestScheduler = new ScheduledOpportunityTerritoryUpdate();
        SchedulableContext sc;
        TestScheduler.execute(sc);
        Test.stopTest();    
    }
    
        @istest static void flowCoverageTest(){
        //coverage for the flow : LCRM_Create_Task_When_Oppty_is_Closed_Won_Order_Complete
        //coverage for the flow: Post_to_chatter_Opportunity_Team_Member_details
        //coverage for the flow: LCRM_Post_to_Chatter_Negotiate_Contract_Notification
        Test.startTest();
        Profile adminProfile = [SELECT Id FROM profile WHERE name='System Administrator'];
        User gliUser;
        gliUser = UnitTest.getUserInstance();
        gliUser.Username = 'TestUser1@TR.com';
        gliUser.profileid = adminProfile.Id;
        gliUser.Email='testuser@thomsonreuters.com';
        gliUser.Alias = 'igli';
        gliUser.FirstName='Informatica';
        gliUser.LastName='GLI Integration';
        gliUser.EmailEncodingKey='UTF-8';
        gliUser.LocaleSidKey='en_US';
        gliUser.LanguageLocaleKey='en_US';
        gliUser.TimeZoneSidKey='America/Los_Angeles';
        gliUser.Sub_Bu__c = 'USL';
        
        insert gliUser; 
        
        Opportunity opp=[Select ID,AccountId, Name,StageName,Is_GLI__c,LCRM_Sub_BU__c,Owner.Id from Opportunity where Name='Unit Test Opportuntiy' limit 1];
        
        opp.StageName='Order Complete';
        opp.Reason__c = 'Brand';
        opp.Was_There_a_Competitor__c='No';
        opp.Is_GLI__c=true;
        opp.LCRM_Sub_BU__c='UKI';
        update opp;
        
        OpportunityTeamMember TestMember = new OpportunityTeamMember(OpportunityId=opp.Id,UserId=gliUser.Id, Sales_Percentage__c=10);
        Insert TestMember;
        
        Opportunity opp2= UnitTest.getOpportunityInstance(opp.AccountId);
        opp2.StageName='Negotiate Contract';
        opp2.Renewal_Flag__c=true;
        opp2.Is_GLI__c=true;
        opp2.LCRM_Sub_BU__c='UKI';
        
        insert opp2;
        Test.stopTest();
        }
}