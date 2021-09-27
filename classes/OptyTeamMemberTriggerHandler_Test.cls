/**
 * Class for the Opportunity Team Member trigger methods
 *
 *
 * @author  Raul Haynes
 * @version 2013-03-04
 */

/**
 * CHANGE HISTORY
 * =============================================================================
 * Date         Name                Description
 * 2013-03-04   Raul Haynes       Created
 *                                                
 * =============================================================================
 */


@IsTest//(seeAllData=true)

public without sharing class OptyTeamMemberTriggerHandler_Test {
 public static User u1,u2;

 public static testmethod void optyTeamMemberTriggerHandlerTestMethod(){
     List<User> listtestUsers = new List<User>();
     
     Profile p = [SELECT Id FROM profile WHERE name='System Administrator'];   
       UserRole role1 = [Select Id,ParentRoleId from UserRole where ParentRoleId!='' and Name = 'LatAm Order Fulfillment' limit 1];
       
       u1 = new User(alias = 'newUser1', email='user1@mydomain.com', 
            emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
            localesidkey='en_US', profileid = p.Id, employeenumber='0143564',
            timezonesidkey='America/Los_Angeles', username='user12@mydomain.com',UserRoleId=role1.Id);        
       listtestUsers.add(u1);
       
       u2 = new User(alias = 'newUser2', email='user1@mydomain.com', 
            emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
            localesidkey='en_US', profileid = p.Id, employeenumber='0143565',
            timezonesidkey='America/Los_Angeles', username='user13@mydomain.com',UserRoleId=role1.ParentRoleId);        
       listtestUsers.add(u2);
       insert listtestUsers;
       System.assertEquals(u2.email, 'user1@mydomain.com');
       System.RunAs(u1){
       
       Test.StartTest();
       
         SyncQuotaTestmethod();
       Test.StopTest();
       }
 
 }
 
 
 @future
 public static void syncQuotaTestmethod(){
      
      //Below line added on 1309
      UnitTest.createTestData();
        
      List<UserQuota__c> listtestUserQuota = new List<UserQuota__c>();
       
      UserQuota__c testUserQuota1 = new UserQuota__c(External_Id__c=String.valueof(u1.id)+'Aug 2013',
                                         User__c=u1.Id,Fiscal_Month__c='Aug 2013');
      listtestUserQuota.add(TestUserQuota1);                                         
                                         
      UserQuota__c testUserQuota2 = new UserQuota__c(External_Id__c=String.valueof(u2.id)+'Sep 2013',
                                         User__c=u2.Id,Fiscal_Month__c='Sep 2013');    
      listtestUserQuota.add(TestUserQuota2);                                                                           
     
      insert listtestUserQuota;
       
      Account testAcc = UnitTest.getAccountInstance();
      insert testAcc;
      
      Opportunity testOpp1 = UnitTest.getOpportunityInstance(testAcc.Id);
         testOpp1.CloseDate = date.valueOf('2013-08-08 00:00:00');
      insert testOpp1;
        
      OpportunityTeamMember testMember = new OpportunityTeamMember(OpportunityId=testOpp1.Id,UserId=u1.Id, Sales_Percentage__c=10);
      Insert TestMember;

      OpportunityTeamMember testMember2 = new OpportunityTeamMember(OpportunityId=testOpp1.Id,UserId=u1.Id, Sales_Percentage__c=90);
      Insert TestMember2;

       testOpp1 = [Select id,User_Quota__c,Manager_Quotas__c from Opportunity where Id =: testOpp1.Id];
       System.assertEquals(testOpp1.User_Quota__c ,TestUserQuota1.Id,'Error');
       
       TestMember = [Select id,User_Quota__c, Sales_Percentage__c from OpportunityTeamMember where Id =: TestMember.Id];
       System.assertEquals(TestMember.User_Quota__c ,TestUserQuota1.Id,'Error');
       
       testOpp1.CloseDate = date.valueOf('2013-09-08 00:00:00');
       
       update testOpp1;
       testOpp1 = [Select id,User_Quota__c,Manager_Quotas__c from Opportunity where Id =: testOpp1.Id];
       //System.assertEquals(testOpp1.User_Quota__c,null,'Error');
     
       OptyTeamMemberTriggerHandler.bflag = false;
       
       update TestMember;
       
       TestMember = [Select id,User_Quota__c from OpportunityTeamMember where Id =: TestMember.Id];
       
       System.assertEquals(TestMember.User_Quota__c ,null,'Error');

   }
   
   Public static testMethod Void syncOppTeamToOppTeamCloneTest(){
        
        KeyValueListStore__c kvs= new KeyValueListStore__c();
        kvs.name= 'ANZUsersProfileId';

        //kvs.TextValue__C = '00e30000001ZUki';     
        kvs.TextValue__C = [Select ID from Profile where Name='ANZ Users'].ID;   
        insert kvs;
        
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
        //objPro.ProfileId__c = '00ea00000024JwaAAE';
        objPro.ProfileId__c = [Select ID from Profile where Name='Partner Portal User'].ID;
        //INSERT objPro;
        
        Profile_List__c objPro1 = new Profile_List__c();
        objPro1.name = 'LatAm User';
        objPro1.Profile_Name__c = 'LatAm User';
        //objPro1.ProfileId__c = '00ea00000024JzKAAU';
        objPro1.ProfileId__c = [Select ID from Profile where Name='LatAm User'].ID;
        //INSERT objPro1;
        
        Profile_List__c objPro2 = new Profile_List__c();
        objPro2.name = 'System Administrator';
        objPro2.Profile_Name__c = 'System Administrator';
        //objPro2.ProfileId__c = '00e30000001gFezAAE';
        objPro2.ProfileId__c = [Select ID from Profile where Name='System Administrator'].ID;
        //INSERT objPro2;
        INSERT new List<Profile_List__c>{objPro, objPro1, objPro2};
        
        Product2 testProd1 =UnitTest.getProductInstance();
        testprod1.IsActive = true;
        Product2 testProd2 =UnitTest.getProductInstance();
        testprod2.IsActive = true;
        insert new List<Product2>{testProd1,testProd2};
        
        PricebookEntry testEntry = new PricebookEntry(isactive=true,Pricebook2id=Test.getStandardPricebookId(),Product2Id=testProd1.id,unitprice=200);
        PricebookEntry testEntry1 = new PricebookEntry(isactive=true,Pricebook2id=Test.getStandardPricebookId(),Product2Id=testProd2.id,unitprice=200);
        insert new List<PricebookEntry>{testEntry,testEntry1};
        
        Account testAcc = UnitTest.getAccountInstance();
        testAcc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('GLI Account').getRecordTypeId();        
        insert testAcc;
        
        Opportunity testOpp1 = UnitTest.getOpportunityInstance(testAcc.Id);
        testopp1.Pricebook2Id = Test.getStandardPricebookId();
        testOpp1.Is_Master_Opportunity__c = true;
        testOpp1.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();        
        testOpp1.LCRM_Split_On__c = true;
        testOpp1.Is_GLI__c = TRUE;
        insert testOpp1;
        
        Opportunity opp = [select id,Pricebook2Id,Is_GLI__c  from Opportunity where id =:testOpp1.ID];
        System.debug('opp : '+opp);
        opp.Pricebook2Id = Test.getStandardPricebookId();
        update opp;
        
        Test.startTest();
            OpportunityLineItem testLineItem1 = new OpportunityLineItem(opportunityId=testOpp1.id,PricebookEntryId=testEntry.id,unitprice=100,Quantity=1, Revenue_Type__c ='Incremental');
            testLineItem1.LCRM_Units__c = 1;
            insert testLineItem1;
            
            List<User> userList = [SELECT ID from User Where IsActive = true LIMIT 5];
            OpportunityTeamMember oTeam = new OpportunityTeamMember();
            oTeam.OpportunityId = testOpp1.ID;
            oTeam.TeamMemberRole = '';
            oTeam.UserID = userList[0].Id;
            insert oTeam;
            oTeam.TeamMemberRole = 'Sales Manager';
            update oTeam;
            List<LCRM_Opportunity_Split__c> splitList = [SELECT ID FROM LCRM_Opportunity_Split__c WHERE ID = :testOpp1.Id];
            System.assert(splitList!=null,true);
            delete oTeam;
            
        Test.stopTest();
    }
 
    Public static testMethod Void salesPercentageValidationTest(){
      //KeyValueListStore__c keyValue = new KeyValueListStore__c(name='ANZUsersProfileId', TextValue__c = '00e30000001ZUki');
      KeyValueListStore__c keyValue = new KeyValueListStore__c(name='ANZUsersProfileId', TextValue__c = [Select ID from Profile where Name='ANZ Users'].ID);
        insert keyValue;
        //RecordtypeIds__c rt = new RecordtypeIds__c(name = 'Pre-Pipeline Opportunities', recTypeId__c='01230000001MA4hAAG');
        RecordtypeIds__c rt = new RecordtypeIds__c(name = 'Pre-Pipeline Opportunities', recTypeId__c=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Pre-Pipeline Opportunity').getRecordTypeId());
        insert rt;
        //RecordtypeIds__c rt1 = new RecordtypeIds__c(name = 'Pipeline Opportunities', recTypeId__c='01230000001MA4gAAG');
        RecordtypeIds__c rt1 = new RecordtypeIds__c(name = 'Pipeline Opportunities', recTypeId__c=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Pipeline Opportunity').getRecordTypeId());
        insert rt1;
        //RecordtypeIds__c rt2 = new RecordtypeIds__c(name = 'LATAM Renewal Opportunity', recTypeId__c='01213000000AXGKAA4');
        RecordtypeIds__c rt2 = new RecordtypeIds__c(name = 'LATAM Renewal Opportunity', recTypeId__c=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('LATAM Renewal Opportunity').getRecordTypeId());
        insert rt2;
        //RecordtypeIds__c rt3 = new RecordtypeIds__c(name = 'GLI Pipeline Opportunity', recTypeId__c='012e00000000wRJAAY');
        RecordtypeIds__c rt3 = new RecordtypeIds__c(name = 'GLI Pipeline Opportunity', recTypeId__c=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId());
        insert rt3;
        
        //profile_list__c plist = new profile_list__c(name = 'Partner Portal User',Profile_Name__c='Partner Portal User',ProfileId__c = '00ea00000024JwaAAE');
        profile_list__c plist = new profile_list__c(name = 'Partner Portal User',Profile_Name__c='Partner Portal User',ProfileId__c = [Select ID from Profile where Name='Partner Portal User'].ID);
        insert plist;
        
        ConvertedLeadStatus__c cl = new ConvertedLeadStatus__c(name = 'true', value__c='Sales Qualified');
        insert cl;
        
        ConvertedLeadStatus__c cl1 = new ConvertedLeadStatus__c(name = 'false', value__c='Converted');
        insert cl1;
        
        TRWaySales__Opp_Stage_Ack_Field_Config__c optyStage = new TRWaySales__Opp_Stage_Ack_Field_Config__c(name = 'Appointment Scheduled' , TRWaySales__Opp_Ack_Field_API_Name__c = 'Appointment_Scheduled_Ack__c');
        insert optyStage;
        
        TRWaySales__Opp_Stage_Ack_Field_Config__c optyStage1 = new TRWaySales__Opp_Stage_Ack_Field_Config__c(name = 'Generate Contract' , TRWaySales__Opp_Ack_Field_API_Name__c = 'Generate_Contract_Ack__c');
        insert optyStage1;
        
        TRWaySales__Exit_Criteria_and_I_Ack_Config__c exitConfig = new TRWaySales__Exit_Criteria_and_I_Ack_Config__c(name = 'Criteria and I Ack Settings',TRWaySales__Display_Exit_Criteria_for_Non_Sequential__c = true,TRWaySales__I_acknowledge_exception__c = 'BU Head,Sales Head',
                                                     TRWaySales__I_acknowledge_required__c = true);
    
        insert exitConfig;
        
      Account testAcc = UnitTest.getAccountInstance();
      insert testAcc;
      
      Opportunity testOpp1 = UnitTest.getOpportunityInstance(testAcc.Id);
      insert testOpp1;
      
      List<User> userList = [SELECT ID from User Where IsActive = true LIMIT 2];
       
      OpportunityTeamMember testMember = new OpportunityTeamMember(OpportunityId=testOpp1.Id,UserId=userList[0].Id, Sales_Percentage__c=10);
      Insert TestMember;

      OpportunityTeamMember testMember2 = new OpportunityTeamMember(OpportunityId=testOpp1.Id,UserId=userList[1].Id, Sales_Percentage__c=80);
      Insert TestMember2;
      
      Test.startTest();
          TestMember.Sales_Percentage__c = 20;
          System.assert(TestMember.Sales_Percentage__c == 20,true);
          update TestMember;
      Test.stopTest();
    }
    
    Public static testMethod Void validatePartnerRoleDuplicateTest(){
        
        KeyValueListStore__c keyValue = new KeyValueListStore__c(name='ANZUsersProfileId', TextValue__c = [Select ID from Profile where Name='ANZ Users'].ID);
        insert keyValue;
        RecordtypeIds__c rt = new RecordtypeIds__c(name = 'Pre-Pipeline Opportunities', recTypeId__c=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Pre-Pipeline Opportunity').getRecordTypeId());
        insert rt;
        RecordtypeIds__c rt1 = new RecordtypeIds__c(name = 'Pipeline Opportunities', recTypeId__c=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Pipeline Opportunity').getRecordTypeId());
        insert rt1;
        RecordtypeIds__c rt2 = new RecordtypeIds__c(name = 'LATAM Renewal Opportunity', recTypeId__c=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('LATAM Renewal Opportunity').getRecordTypeId());
        insert rt2;
        RecordtypeIds__c rt3 = new RecordtypeIds__c(name = 'GLI Pipeline Opportunity', recTypeId__c=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId());
        insert rt3;
        
        profile_list__c plist = new profile_list__c(name = 'Partner Portal User',Profile_Name__c='Partner Portal User',ProfileId__c = [Select ID from Profile where Name='Partner Portal User'].ID);
        insert plist;
        
        ConvertedLeadStatus__c cl = new ConvertedLeadStatus__c(name = 'true', value__c='Sales Qualified');
        insert cl;
        
        ConvertedLeadStatus__c cl1 = new ConvertedLeadStatus__c(name = 'false', value__c='Converted');
        insert cl1;
        
        TRWaySales__Opp_Stage_Ack_Field_Config__c optyStage = new TRWaySales__Opp_Stage_Ack_Field_Config__c(name = 'Appointment Scheduled' , TRWaySales__Opp_Ack_Field_API_Name__c = 'Appointment_Scheduled_Ack__c');
        insert optyStage;
        
        TRWaySales__Opp_Stage_Ack_Field_Config__c optyStage1 = new TRWaySales__Opp_Stage_Ack_Field_Config__c(name = 'Generate Contract' , TRWaySales__Opp_Ack_Field_API_Name__c = 'Generate_Contract_Ack__c');
        insert optyStage1;
        
        TRWaySales__Exit_Criteria_and_I_Ack_Config__c exitConfig = new TRWaySales__Exit_Criteria_and_I_Ack_Config__c(name = 'Criteria and I Ack Settings',TRWaySales__Display_Exit_Criteria_for_Non_Sequential__c = true,TRWaySales__I_acknowledge_exception__c = 'BU Head,Sales Head',
                                             TRWaySales__I_acknowledge_required__c = true);
        
        insert exitConfig;
        
        Account testAcc = UnitTest.getAccountInstance();
        insert testAcc;
        
        Opportunity testOpp1 = UnitTest.getOpportunityInstance(testAcc.Id);
        insert testOpp1;
        
        List<User> userList = [SELECT ID from User Where IsActive = true LIMIT 2];
        
        OpportunityTeamMember testMember = new OpportunityTeamMember(OpportunityId=testOpp1.Id,UserId=userList[0].Id, Sales_Percentage__c=10, Partner_Role__c = 'Partner Pre-Sales');
        Insert TestMember;
        
        OpportunityTeamMember testMember2 = new OpportunityTeamMember(OpportunityId=testOpp1.Id,UserId=userList[1].Id, Sales_Percentage__c=80,  Partner_Role__c = 'Partner Deal Closer');
        Insert TestMember2;
        
        System.assertEquals(TestMember2.Id != null, true);
        
    }
}