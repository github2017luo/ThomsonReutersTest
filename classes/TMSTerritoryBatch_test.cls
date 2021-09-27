/*
======================================================================================================================
CLASS NAME:  TMSTerritoryBatch_test
======================================================================================================================
PURPOSE:  code coverage for newly created Trigger GLILoadTrackerAfterEventListener.This class is used for to code coverage for TMS Territory and Account territory creation and updation functionality. 

JIRA story: CRM-11669 Display Territories in GLI - SFDC Batch classes
[SSDF JIRA DTC] (CRM-11892) Display Territories in GLI - SFDC batch class dependency framework


Referenced by : DisplayTerritoriesonAccount_Batch()
CHANGE HISTORY:
Classes coved:
1.TMSTerritory_AccountTeamBatch
2.TMSTerritory_TerritoryBatch 
3.TMSTerritoryBatchHelper
4.Display_AccTerritory_Batch 
5.AccountTerritoriesHandler
======================================================================================================================
DATE           Developer NAME              DESC
/0247/2018      Vaishali Nagar    
======================================================================================================================
*/

//Commenting out as a part of removal of TM1.0 components
@isTest( seeAllData = false)
public class TMSTerritoryBatch_test{ 

//To bypass test coverage at the time of deployment after removing all functionality
  @isTest static void testBatchTerritory() {
  AccountTerritoriesHandler obj1=new AccountTerritoriesHandler();
  TMSTerritoryBatchHelper obj2 = new TMSTerritoryBatchHelper();
  Test.starttest();
      List<Account> lstAccount= new List<Account>();
        for(Integer i=0 ;i <200;i++)
        {
            Account acc = new Account();
            acc.Name ='Name'+i;
            lstAccount.add(acc);
        }
        
        insert lstAccount;

  TMSTerritory_AccountTeamBatch obj3 = new TMSTerritory_AccountTeamBatch();
  Database.executebatch(obj3,1);
      TMSTerritory_TerritoryBatch obj4 = new TMSTerritory_TerritoryBatch();
      Database.executeBatch(obj4,1);
      Display_AccTerritory_Batch obj5 = new Display_AccTerritory_Batch();
      Database.executeBatch(obj5, 1);
   Test.stoptest();
  }
        /*create user data
        Profile profileId = [Select id from profile where name = 'System Administrator'];
        User testUser = new User(
            Alias = 'sUser', 
            Email='abc1@testorg.com',
            EmailEncodingKey='UTF-8', 
            LastName='Testing', 
            LanguageLocaleKey='en_US',
            LocaleSidKey='en_US', 
            ProfileId = profileId.id,
            Sales_Org__c = 'WEST',
            Sub_Bu__c='USL',
            TimeZoneSidKey='America/Los_Angeles', 
            UserName='abc123@testorg.com'
        );
        insert testUser;
        
        //create account data
        System.runAs(testUser) {
            List<RecordType> RecordtypeIDs=[SELECT Id,DeveloperName,IsActive FROM RecordType WHERE DeveloperName LIKE '%GLI%' AND SobjectType = 'Account' and IsActive =true];
            List<GLI_Record_type_Ids__c> ListofRecordtype = new List<GLI_Record_type_Ids__c>();
            GLI_Record_type_Ids__c OAccRecordtype = new GLI_Record_type_Ids__c ();
            OAccRecordtype.name ='GLI Account';       
            OAccRecordtype.GLI_Account_RecordTypeId__c = RecordtypeIDs[0].Id;
            ListofRecordtype.add(OAccRecordtype);
            
            GLI_Record_type_Ids__c AccRecordtype = new GLI_Record_type_Ids__c ();
            AccRecordtype.name ='GLI Account ECM';       
            AccRecordtype.GLI_Account_RecordTypeId__c = RecordtypeIDs[1].Id;
            ListofRecordtype.add(AccRecordtype);
            
            GLI_Record_type_Ids__c AccRecordtypeValue = new GLI_Record_type_Ids__c ();
            AccRecordtypeValue.name ='GLI_Archive';       
            AccRecordtypeValue.GLI_Account_RecordTypeId__c = RecordtypeIDs[1].Id;
            ListofRecordtype.add(AccRecordtypeValue);
            
            if(ListofRecordtype.size()>0){
                insert ListofRecordtype;            
            }
            List<Account> Accountlst = new List<Account>();
            Account oAccountA = UnitTest.getAccountInstance();
            oAccountA.Is_GLI__c=true;
            Accountlst.add(oAccountA);
            
            Account oAccountB = UnitTest.getAccountInstance();
            oAccountB.Is_GLI__c=true;
            Accountlst.add(oAccountB);
            
            if(Accountlst.size()>0){
                insert Accountlst;
            }
            
            //create GLI Load tracked Data
            GLI_Load_Tracker__c gliloadtracker = new GLI_Load_Tracker__c();
            gliloadtracker.name = 'Informatica Territory Load';
            gliloadtracker.AccountTeamJobStartedDate__c = datetime.now() - 2;
            gliloadtracker.TerritoryJobStartedDate__c = datetime.now() - 30;
            gliloadtracker.JobCompletedDate__c= datetime.newInstance(2017, 9, 15, 12, 30, 0);
            Insert gliloadtracker;
            
            UserTerritory2Association oUserTerritory = [SELECT Id, Territory2Id, UserId FROM UserTerritory2Association WHERE IsActive=true and UserId!=null LIMIT 1];
            UserTerritory2Association oUserTerritory2 = [SELECT Id, Territory2Id, UserId FROM UserTerritory2Association WHERE Id !=:oUserTerritory.Id AND IsActive=true and UserId!=null LIMIT 1];
            
            User oUser = [SELECT Id, Name FROM User WHERE Id=:oUserTerritory.UserId];
            oUser.isActive = true;
            update oUser;
            
            User oUser01 = [SELECT Id, Name FROM User WHERE Id=:oUserTerritory2.UserId];
            oUser01.isActive = true;
            update oUser01;
            
            Territory2 oTerritory = [SELECT Id, Name,TMS_Territory_Team_Role__c,District__c,ParentTerritory2Id, Description,
             AccountAccessLevel, OpportunityAccessLevel, CaseAccessLevel, ContactAccessLevel,  
              CurrencyIsoCode,  DeveloperName,TMS_Market_Segment_Desc__c, TMS_Market_Segment_ID__c, 
              TMS_Parent_Territory_ID__c, TMS_Rep_Function_Desc__c, TMS_Rep_Function_ID__c, TMS_Sales_Force_Desc__c, 
              TMS_Sales_Force_ID__c, TMS_Terr_Num__c, TMS_Territory_ID__c, TMS_New_Sales_Quota_Curr_Yr__c, 
              TMS_Renewal_Sales_Quota_Curr_Yr__c, Region__c, TMS_Sales_Force_Code__c, TMS_Market_Segment_Code__c, 
              TMS_Ref_Function_Code__c FROM Territory2 WHERE Id=:oUserTerritory.Territory2Id limit 1];
            System.debug('oTerritory**'+oTerritory);
            Territory2 oTerritory2 = [SELECT Id, Name,District__c,TMS_Territory_Team_Role__c,ParentTerritory2Id, Description,
             AccountAccessLevel, OpportunityAccessLevel, CaseAccessLevel, ContactAccessLevel,  
              CurrencyIsoCode,  DeveloperName,TMS_Market_Segment_Desc__c, TMS_Market_Segment_ID__c,
               TMS_Parent_Territory_ID__c, TMS_Rep_Function_Desc__c, TMS_Rep_Function_ID__c, TMS_Sales_Force_Desc__c,
                TMS_Sales_Force_ID__c, TMS_Terr_Num__c, TMS_Territory_ID__c, TMS_New_Sales_Quota_Curr_Yr__c, 
                TMS_Renewal_Sales_Quota_Curr_Yr__c, Region__c, TMS_Sales_Force_Code__c, TMS_Market_Segment_Code__c, 
                TMS_Ref_Function_Code__c FROM Territory2 WHERE Id=:oUserTerritory2.Territory2Id limit 1];
            System.debug('oTerritory2**'+oTerritory2);
            set<ID> oTerritoryID = new set<ID>();
            oTerritoryID.add(oTerritory.Id);
            oTerritoryID.add(oTerritory2.Id);
            system.assertEquals(oTerritoryID.size(),1);
            Group oGroup = [SELECT Id, RelatedId FROM Group WHERE RelatedId=:oTerritory.Id AND Type='Territory' LIMIT 1];
            Group oGroup2 = [SELECT Id, RelatedId FROM Group WHERE RelatedId=:oTerritory2.Id AND Type='Territory' LIMIT 1];
            
            
            //System.assertEquals(gliContact.AccountId, gliAccount.id);
            List<AccountShare> accountsharelist = new List<AccountShare>();
            AccountShare oAccountShareA = new AccountShare();
            oAccountShareA.AccountId = Accountlst[0].Id;
            oAccountShareA.UserOrGroupId = oGroup.Id;
            accountsharelist.add(oAccountShareA);
            if(accountsharelist.size()>0){
                //insert accountsharelist;            
            }
            
            List<AccountTeamMember> members = new list<AccountTeamMember>();
            members.add(New AccountTeamMember(AccountId = Accountlst[0].id, TeamMemberRole = 'ACC-Team-Mem', UserId= testUser.Id));
            members.add(New AccountTeamMember(AccountId = Accountlst[1].id, TeamMemberRole = 'ACC-Team-Mem', UserId= testUser.Id));
            members.add(New AccountTeamMember(AccountId = Accountlst[0].id, TeamMemberRole = oTerritory.TMS_Territory_Team_Role__c, UserId= oUser.Id));
            members.add(New AccountTeamMember(AccountId = Accountlst[1].id, TeamMemberRole = oTerritory.TMS_Territory_Team_Role__c, UserId= oUser.Id));
            
            insert members;
            System.debug('members**'+members);
            //define batch size
            List<LCRM_BatchsizeDefine__c> batchsizelst = new List<LCRM_BatchsizeDefine__c>();
            LCRM_BatchsizeDefine__c cs = new LCRM_BatchsizeDefine__c();
            cs.Name ='TMSTerritory_TerritoryBatch';
            cs.Object__c ='TMS Territory';
            cs.Batch_Size__c = 10 ;
            batchsizelst.add(cs);
            
            LCRM_BatchsizeDefine__c cs0 = new LCRM_BatchsizeDefine__c();
            cs0.Name ='TMSTerritory_AccountTeamBatch';
            cs0.Object__c ='TMS Territory';
            cs0.Batch_Size__c = 10 ;
            batchsizelst.add(cs0);
            
            LCRM_BatchsizeDefine__c cs1 = new LCRM_BatchsizeDefine__c();
            cs1.Name ='Display_AccTerritory_Batch';
            cs1.Object__c ='Account Territory';
            cs1.Batch_Size__c = 10 ;
            batchsizelst.add(cs1);
           if(batchsizelst.size()>0){
                insert batchsizelst;
            }
            
            Test.StartTest(); 
                TMSTerritory_TerritoryBatch UpdateTerritoryLoad = new TMSTerritory_TerritoryBatch();                
                Database.executeBatch(UpdateTerritoryLoad,100);    
               Test.StopTest();
            
            }
            
            
    
    }
    
  @isTest static void testUpdateTMSTerritory() {
   
   Profile profileId = [Select id from profile where name = 'System Administrator'];
    //create user data
        User testUser = new User(
            Alias = 'sUser', 
            Email='abc1@testorg.com',
            EmailEncodingKey='UTF-8', 
            LastName='Testing', 
            LanguageLocaleKey='en_US',
            LocaleSidKey='en_US', 
            ProfileId = profileId.id,
            Sales_Org__c = 'WEST',
            Sub_Bu__c='USL',
            TimeZoneSidKey='America/Los_Angeles', 
            UserName='abc123@testorg.com'
        );
        insert testUser;
        
        //create account data
        System.runAs(testUser) {
            List<RecordType> RecordtypeIDs=[SELECT Id,DeveloperName,IsActive FROM RecordType WHERE DeveloperName LIKE '%GLI%' AND SobjectType = 'Account' and IsActive =true];
            List<GLI_Record_type_Ids__c> ListofRecordtype = new List<GLI_Record_type_Ids__c>();
            GLI_Record_type_Ids__c OAccRecordtype = new GLI_Record_type_Ids__c ();
            OAccRecordtype.name ='GLI Account';       
            OAccRecordtype.GLI_Account_RecordTypeId__c = RecordtypeIDs[0].Id;
            ListofRecordtype.add(OAccRecordtype);
            
            GLI_Record_type_Ids__c AccRecordtype = new GLI_Record_type_Ids__c ();
            AccRecordtype.name ='GLI Account ECM';       
            AccRecordtype.GLI_Account_RecordTypeId__c = RecordtypeIDs[1].Id;
            ListofRecordtype.add(AccRecordtype);
            
            GLI_Record_type_Ids__c AccRecordtypeValue = new GLI_Record_type_Ids__c ();
            AccRecordtypeValue.name ='GLI_Archive';       
            AccRecordtypeValue.GLI_Account_RecordTypeId__c = RecordtypeIDs[1].Id;
            ListofRecordtype.add(AccRecordtypeValue);
            
            if(ListofRecordtype.size()>0){
                insert ListofRecordtype;            
            }
            List<Account> Accountlst = new List<Account>();
            Account oAccountA = UnitTest.getAccountInstance();
            oAccountA.Is_GLI__c=true;
            Accountlst.add(oAccountA);
            
            Account oAccountB = UnitTest.getAccountInstance();
            oAccountB.Is_GLI__c=true;
            Accountlst.add(oAccountB);
            
            if(Accountlst.size()>0){
                insert Accountlst;
            }
            
            GLI_Load_Tracker__c gliloadtracker = new GLI_Load_Tracker__c();
            gliloadtracker.name = 'Informatica Territory Load';
            gliloadtracker.AccountTeamJobStartedDate__c = datetime.now() - 2;
            gliloadtracker.TerritoryJobStartedDate__c = datetime.now() - 30;
            gliloadtracker.JobCompletedDate__c =datetime.now();
            Insert gliloadtracker;
                
            
            UserTerritory2Association oUserTerritory = [SELECT Id, Territory2Id, UserId FROM UserTerritory2Association WHERE IsActive=true and UserId!=null LIMIT 1];
            //UserTerritory oUserTerritory2 = [SELECT Id, TerritoryId, UserId FROM UserTerritory WHERE Id !=:oUserTerritory.Id AND IsActive=true LIMIT 1];
            
            User oUser = [SELECT Id, Name FROM User WHERE Id=:oUserTerritory.UserId];
            oUser.isActive = true;
            update oUser;
            
            Territory2 oTerritory = [SELECT Id, Name,District__c,TMS_Territory_Team_Role__c,ParentTerritory2Id, 
            Description, AccountAccessLevel, OpportunityAccessLevel, CaseAccessLevel, ContactAccessLevel, 
              CurrencyIsoCode,  DeveloperName,TMS_Market_Segment_Desc__c, TMS_Market_Segment_ID__c, TMS_Parent_Territory_ID__c,
               TMS_Rep_Function_Desc__c, TMS_Rep_Function_ID__c, TMS_Sales_Force_Desc__c, TMS_Sales_Force_ID__c, TMS_Terr_Num__c, 
               TMS_Territory_ID__c, TMS_New_Sales_Quota_Curr_Yr__c, TMS_Renewal_Sales_Quota_Curr_Yr__c, Region__c, 
               TMS_Sales_Force_Code__c, TMS_Market_Segment_Code__c, TMS_Ref_Function_Code__c FROM Territory2
                WHERE Id=:oUserTerritory.Territory2Id LIMIT 1];
            oTerritory.TMS_Sales_Force_Code__c = 'HO';
            oTerritory.TMS_Market_Segment_Code__c= 'FII';
            oTerritory.TMS_Ref_Function_Code__c= 'AM';
            //Territory oTerritory2 = [SELECT Id, Name,District__c,ParentTerritoryId, Description, AccountAccessLevel, OpportunityAccessLevel, CaseAccessLevel, ContactAccessLevel,   CurrencyIsoCode,  DeveloperName,TMS_Market_Segment_Desc__c, TMS_Market_Segment_ID__c, TMS_Parent_Territory_ID__c, TMS_Rep_Function_Desc__c, TMS_Rep_Function_ID__c, TMS_Sales_Force_Desc__c, TMS_Sales_Force_ID__c, TMS_Terr_Num__c, TMS_Territory_ID__c, TMS_New_Sales_Quota_Curr_Yr__c, TMS_Renewal_Sales_Quota_Curr_Yr__c, Region__c, TMS_Sales_Force_Code__c, TMS_Market_Segment_Code__c, TMS_Ref_Function_Code__c FROM Territory WHERE Id=:oUserTerritory2.TerritoryId];
            set<ID> oTerritoryID = new set<ID>();
            oTerritoryID.add(oTerritory.Id);
            //oTerritoryID.add(oTerritory2.Id);
            system.assertEquals(oTerritoryID.size(),1);
            Group oGroup = [SELECT Id, RelatedId FROM Group WHERE RelatedId=:oTerritory.Id AND Type='Territory' LIMIT 1];
            //Group oGroup2 = [SELECT Id, RelatedId FROM Group WHERE RelatedId=:oTerritory2.Id AND Type='Territory' LIMIT 1];
            
            
            //System.assertEquals(gliContact.AccountId, gliAccount.id);
            List<AccountShare> accountsharelist = new List<AccountShare>();
            AccountShare oAccountShareA = new AccountShare();
            oAccountShareA.AccountId = Accountlst[0].Id;
            oAccountShareA.UserOrGroupId = oGroup.Id;
            accountsharelist.add(oAccountShareA);
            if(accountsharelist.size()>0){
               // insert accountsharelist;            
            }
            
            List<AccountTeamMember> members = new list<AccountTeamMember>();
            members.add(New AccountTeamMember(AccountId = Accountlst[0].id, TeamMemberRole = 'ACC-Team-Mem', UserId= testUser.Id));
            //members.add(New AccountTeamMember(AccountId = Accountlst[1].id, TeamMemberRole = 'ACC-Team-Mem', UserId= testUser.Id));
            members.add(New AccountTeamMember(AccountId = Accountlst[0].id, TeamMemberRole = oTerritory.TMS_Territory_Team_Role__c, UserId= oUser.Id));
            //members.add(New AccountTeamMember(AccountId = Accountlst[1].id, TeamMemberRole = 'ACC-Team-Mem1', UserId= oUser.Id));
            
            insert members;
            
            //define batch size
            List<LCRM_BatchsizeDefine__c> batchsizelst = new List<LCRM_BatchsizeDefine__c>();
            LCRM_BatchsizeDefine__c cs = new LCRM_BatchsizeDefine__c();
            cs.Name ='TMSTerritory_AccountTeamBatch';
            cs.Object__c ='TMS Territory';
            cs.Batch_Size__c = 10 ;
            batchsizelst.add(cs);
            
            LCRM_BatchsizeDefine__c cs01 = new LCRM_BatchsizeDefine__c();
            cs01.Name ='TMSTerritory_TerritoryBatch';
            cs01.Object__c ='TMS Territory';
            cs01.Batch_Size__c = 10 ;
            batchsizelst.add(cs01);
            
            LCRM_BatchsizeDefine__c cs1 = new LCRM_BatchsizeDefine__c();
            cs1.Name ='Display_AccTerritory_Batch';
            cs1.Object__c ='Account Territory';
            cs1.Batch_Size__c = 10 ;
            batchsizelst.add(cs1);
            
           if(batchsizelst.size()>0){
                insert batchsizelst;
            }
            
            TMS_Territory__c TMSTerr = new TMS_Territory__c();
            //Create custom setting 
            List<Account_Territory_Creation__c > CustomSettingAccTerritory= new List<Account_Territory_Creation__c>();
            Account_Territory_Creation__c accAMterritory = new Account_Territory_Creation__c();
            accAMterritory.name = '1';
            accAMterritory.Account_Territory_Fields__c='AM_Territory__c';
            accAMterritory.Terr_Combine_code__c = 'NT-FGOV-AM';
            CustomSettingAccTerritory.add(accAMterritory);
            Account_Territory_Creation__c accAMIterritory = new Account_Territory_Creation__c();
            accAMIterritory.name = '2';
            accAMIterritory.Terr_Combine_code__c = 'HO-FII-AM'; 
            accAMIterritory.Account_Territory_Fields__c = 'AMI_Territory__c';
            CustomSettingAccTerritory.add(accAMIterritory);
            Account_Territory_Creation__c accFieldSalesterritory = new Account_Territory_Creation__c();
            accFieldSalesterritory.name = '3';
            accFieldSalesterritory.Terr_Combine_code__c = 'NT-CE-AE';   
            accFieldSalesterritory.Account_Territory_Fields__c = 'Field_Sales_Territory__c';
            CustomSettingAccTerritory.add(accFieldSalesterritory);
            
            if(CustomSettingAccTerritory.size()>0){
                insert CustomSettingAccTerritory;
                
            }//End size checking
            
            TMS_Territory__c TMS_Terr =new TMS_Territory__c();
            TMS_Terr.Name = 'Test_created by SystemAdmin';
            TMS_Terr.Account__c = Accountlst[0].id;
            //TMS_Terr.ForecastUser__c=gliUser.Id;
            TMS_Terr.TMS_Sales_Force_Desc__c ='ACC';
            TMS_Terr.TMS_Market_Segment_Desc__c='Team';
            TMS_Terr.TMS_Rep_Function_Desc__c ='Mem';
            TMS_Terr.Territory_ID__c =oTerritory.id;
            TMS_Terr.TMS_Territory_Number__c ='1234';
            TMS_Terr.TMS_Sales_Force_Code__c = '123';
            TMS_terr.TMS_Market_Segment_Code__c = '1234';
            TMS_Terr.TMS_Ref_Function_Code__c = '1234';
            insert TMS_Terr; 
            
            Account_Territory__c accterritory = new Account_Territory__c();
            accterritory.AMI_Territory__c=TMSTerr.id;
            accterritory.AM_Territory__c=TMS_Terr.id;
            accterritory.Account__c = oAccountA.id;
            accterritory.Field_Sales_Territory__c =TMS_Terr.id; 
            
            insert accterritory;
             
               
               Test.StartTest(); 
            gliloadtracker.JobCompletedDate__c= datetime.now() + 2;
            UPDATE gliloadtracker;      
            Test.StopTest();
               if(oTerritoryID.size()>0){
            List<TMS_Territory__c> TMs_Territorylst = [SELECT Id, Name,  ParentTerritory__c, DeveloperName__c, ForecastUser__c,  Region__c, TMS_Market_Segment_Desc__c, TMS_Market_Segment_ID__c, TMS_New_Sales_Quota_Curr_Yr__c, TMS_Parent_Territory_ID__c, TMS_Renewal_Sales_Quota_Curr_Yr__c, TMS_Rep_Function_Desc__c, TMS_Rep_Function_ID__c, TMS_Sales_Force_Desc__c, TMS_Sales_Force_ID__c, TMS_Territory_ID__c, TMS_Territory_Number__c, Account__c, Territory_ID__c, District__c, AccountAccessLevel__c, CaseAccessLevel__c, ContactAccessLevel__c, Description__c, OpportunityAccessLevel__c,  TMS_Sales_Force_Code__c, TMS_Market_Segment_Code__c, TMS_Ref_Function_Code__c FROM TMS_Territory__c where Territory_ID__c IN :oTerritoryID ];        
            System.debug('TMs_Territorylst:-'+TMs_Territorylst);    
            List<Account_Territory__c> AccTerritorylst =[select  id,name ,Account__c,AMI_Territory__c,AM_Territory__c,LastModifiedDate,Field_Sales_Territory__c from Account_Territory__c ];
            System.debug('AccTerritorylst:-'+AccTerritorylst);
        }  
            
      }
   
   }
   

@isTest static void testAccountTerritoryCreate() {
        
        Profile profileId = [Select id from profile where name = 'System Administrator'];
        User testUser = new User(
            Alias = 'sUser', 
            Email='abc1@testorg.com',
            EmailEncodingKey='UTF-8', 
            LastName='Testing', 
            LanguageLocaleKey='en_US',
            LocaleSidKey='en_US', 
            ProfileId = profileid.id,
            Sales_Org__c = 'WEST',
            Sub_Bu__c='USL',
            TimeZoneSidKey='America/Los_Angeles', 
            UserName='abc1235@testorg.com'
        );
        insert testUser;
        
        System.runAs(testUser) {
            List<RecordType> RecordtypeIDs=[SELECT Id,DeveloperName,IsActive FROM RecordType WHERE DeveloperName LIKE '%GLI%' AND SobjectType = 'Account' and IsActive =true];
            List<GLI_Record_type_Ids__c> ListofRecordtype = new List<GLI_Record_type_Ids__c>();
            GLI_Record_type_Ids__c OAccRecordtype = new GLI_Record_type_Ids__c ();
            OAccRecordtype.name ='GLI Account';       
            OAccRecordtype.GLI_Account_RecordTypeId__c = RecordtypeIDs[0].Id;
            ListofRecordtype.add(OAccRecordtype);
            
            GLI_Record_type_Ids__c AccRecordtype = new GLI_Record_type_Ids__c ();
            AccRecordtype.name ='GLI Account ECM';       
            AccRecordtype.GLI_Account_RecordTypeId__c = RecordtypeIDs[1].Id;
            ListofRecordtype.add(AccRecordtype);
            
            GLI_Record_type_Ids__c AccRecordtypeValue = new GLI_Record_type_Ids__c ();
            AccRecordtypeValue.name ='GLI_Archive';       
            AccRecordtypeValue.GLI_Account_RecordTypeId__c = RecordtypeIDs[1].Id;
            ListofRecordtype.add(AccRecordtypeValue);
            
            //create GLI Load tracked Data
            GLI_Load_Tracker__c gliloadtracker = new GLI_Load_Tracker__c();
            gliloadtracker.name = 'Informatica Territory Load';
            gliloadtracker.AccountTeamJobStartedDate__c = datetime.now() - 2;
            gliloadtracker.TerritoryJobStartedDate__c = datetime.now() - 30;
            gliloadtracker.JobCompletedDate__c= datetime.newInstance(2017, 9, 15, 12, 30, 0);
            Insert gliloadtracker;
            
            if(ListofRecordtype.size()>0){
                insert ListofRecordtype;            
            }
            List<Account> Accountlst = new List<Account>();
            Account oAccountA = UnitTest.getAccountInstance();
            oAccountA.Is_GLI__c=true;
            Accountlst.add(oAccountA);
            
            Account oAccountB = UnitTest.getAccountInstance();
            oAccountB.Is_GLI__c=true;
            Accountlst.add(oAccountB);
            
            if(Accountlst.size()>0){
                insert Accountlst;
            }
            LCRM_BatchsizeDefine__c cs1 = new LCRM_BatchsizeDefine__c();
            cs1.Name ='Display_AccTerritory_Batch';
            cs1.Object__c ='Account Territory';
            cs1.Batch_Size__c = 10 ;
            insert cs1;
            
            List<Account_Territory_Creation__c > CustomSettingAccTerritory= new List<Account_Territory_Creation__c>();
            Account_Territory_Creation__c accAMterritory = new Account_Territory_Creation__c();
            accAMterritory.name = '1';
            accAMterritory.Account_Territory_Fields__c='AM_Territory__c';
            accAMterritory.Terr_Combine_code__c = 'NT-FGOV-AM';
            CustomSettingAccTerritory.add(accAMterritory);
            Account_Territory_Creation__c accAMIterritory = new Account_Territory_Creation__c();
            accAMIterritory.name = '2';
            accAMIterritory.Terr_Combine_code__c = 'HO-FII-AM'; 
            accAMIterritory.Account_Territory_Fields__c = 'AMI_Territory__c';
            CustomSettingAccTerritory.add(accAMIterritory);
            Account_Territory_Creation__c accFieldSalesterritory = new Account_Territory_Creation__c();
            accFieldSalesterritory.name = '3';
            accFieldSalesterritory.Terr_Combine_code__c = 'NT-CE-AE';   
            accFieldSalesterritory.Account_Territory_Fields__c = 'Field_Sales_Territory__c';
            CustomSettingAccTerritory.add(accFieldSalesterritory);
            
            if(CustomSettingAccTerritory.size()>0){
                insert CustomSettingAccTerritory;}
            
            UserTerritory2Association oUserTerritory = [SELECT Id, Territory2Id, UserId FROM UserTerritory2Association WHERE IsActive=true and UserId!=null LIMIT 1];
            UserTerritory2Association oUserTerritory2 = [SELECT Id, Territory2Id, UserId FROM UserTerritory2Association WHERE Id !=:oUserTerritory.Id AND IsActive=true and UserId!=null LIMIT 1];
            //userTerritory_ID.add(oUserTerritory.TerritoryId);
            //userTerritory_ID.add(oUserTerritory2.TerritoryId);
            //User oUser = [SELECT Id, Name FROM User WHERE Id=:oUserTerritory.UserId and IsActive = true];
            
            Territory2 oTerritory = [SELECT Id, Name,District__c,TMS_Territory_Team_Role__c,ParentTerritory2Id, Description, 
            AccountAccessLevel, OpportunityAccessLevel, CaseAccessLevel, ContactAccessLevel,   CurrencyIsoCode, DeveloperName,
            TMS_Market_Segment_Desc__c, TMS_Market_Segment_ID__c, TMS_Parent_Territory_ID__c, TMS_Rep_Function_Desc__c, 
            TMS_Rep_Function_ID__c, TMS_Sales_Force_Desc__c, TMS_Sales_Force_ID__c, TMS_Terr_Num__c, TMS_Territory_ID__c,
             TMS_New_Sales_Quota_Curr_Yr__c, TMS_Renewal_Sales_Quota_Curr_Yr__c, Region__c, TMS_Sales_Force_Code__c,
              TMS_Market_Segment_Code__c, TMS_Ref_Function_Code__c FROM Territory2 WHERE Id=:oUserTerritory.Territory2Id  limit 1];
            System.debug('oTerritory_12:-'+oTerritory);
            oTerritory.TMS_Sales_Force_Code__c = 'HO';
            oTerritory.TMS_Market_Segment_Code__c= 'FII';
            oTerritory.TMS_Ref_Function_Code__c= 'AM';
            System.debug('oTerritory_1:-'+oTerritory);
            //update oTerritory;
            
            Territory2 oTerritory2 = [SELECT Id, Name,District__c,TMS_Territory_Team_Role__c,ParentTerritory2Id, Description,
             AccountAccessLevel, OpportunityAccessLevel, CaseAccessLevel, ContactAccessLevel,   CurrencyIsoCode,  DeveloperName,
             TMS_Market_Segment_Desc__c, TMS_Market_Segment_ID__c, TMS_Parent_Territory_ID__c, TMS_Rep_Function_Desc__c,
              TMS_Rep_Function_ID__c, TMS_Sales_Force_Desc__c, TMS_Sales_Force_ID__c, TMS_Terr_Num__c, TMS_Territory_ID__c, 
              TMS_New_Sales_Quota_Curr_Yr__c, TMS_Renewal_Sales_Quota_Curr_Yr__c, Region__c, TMS_Sales_Force_Code__c, 
              TMS_Market_Segment_Code__c, TMS_Ref_Function_Code__c FROM Territory2 WHERE Id=:oUserTerritory2.Territory2Id limit 1];
            System.debug('oTerritory2_2:-'+oTerritory2);
            
            
            TMS_Territory__c TMS_Terr =new TMS_Territory__c();
            TMS_Terr.Name = 'Test_created by SystemAdmin';
            TMS_Terr.Account__c = oAccountA.id;
            //TMS_Terr.ForecastUser__c=gliUser.Id;
            TMS_Terr.TMS_Sales_Force_Desc__c ='ACC';
            TMS_Terr.TMS_Market_Segment_Desc__c='Team';
            TMS_Terr.TMS_Rep_Function_Desc__c ='Mem';
            TMS_Terr.TMS_Sales_Force_Code__c='NT';
            TMS_Terr.TMS_Market_Segment_Code__c='FGOV';
            TMS_Terr.TMS_Ref_Function_Code__c='AM';
            TMS_Terr.TMS_Territory_Number__c ='1234';
            TMS_Terr.Territory_ID__c=oUserTerritory2.id;
            insert TMS_Terr;
            
            TMS_Territory__c A_tmsTerr =new TMS_Territory__c();
            A_tmsTerr.Name = 'Test_created by SystemAdmin 01';
            A_tmsTerr.Account__c = oAccountA.id;
            A_tmsTerr.TMS_Sales_Force_Desc__c ='ACC';
            A_tmsTerr.TMS_Market_Segment_Desc__c='Team';
            A_tmsTerr.TMS_Rep_Function_Desc__c ='Mem';
            A_tmsTerr.TMS_Territory_Number__c ='1004';
            A_tmsTerr.TMS_Sales_Force_Code__c='HO';
            A_tmsTerr.TMS_Market_Segment_Code__c='HFT';
            A_tmsTerr.TMS_Ref_Function_Code__c='AM';
            A_tmsTerr.Territory_ID__c=oUserTerritory.id;
            insert A_tmsTerr;
            
            
            TMS_Territory__c B_TMS_Terr =new TMS_Territory__c();
            B_TMS_Terr.Name = 'Test_created by SystemAdmin';
            B_TMS_Terr.Account__c = oAccountB.id;
            //TMS_Terr.ForecastUser__c=gliUser.Id;
            B_TMS_Terr.TMS_Sales_Force_Desc__c ='ACC';
            B_TMS_Terr.TMS_Market_Segment_Desc__c='Team';
            B_TMS_Terr.TMS_Rep_Function_Desc__c ='Mem';
            B_TMS_Terr.TMS_Sales_Force_Code__c='NT';
            B_TMS_Terr.TMS_Market_Segment_Code__c='FGOV';
            B_TMS_Terr.TMS_Ref_Function_Code__c='AM';
            B_TMS_Terr.TMS_Territory_Number__c ='1234';
            B_TMS_Terr.Territory_ID__c=oUserTerritory2.id;
            insert B_TMS_Terr;
            
            TMS_Territory__c C_tmsTerr =new TMS_Territory__c();
            C_tmsTerr.Name = 'Test_created by SystemAdmin 01';
            C_tmsTerr.Account__c = oAccountB.id;
            C_tmsTerr.TMS_Sales_Force_Desc__c ='ACC';
            C_tmsTerr.TMS_Market_Segment_Desc__c='Team';
            C_tmsTerr.TMS_Rep_Function_Desc__c ='Mem';
            C_tmsTerr.TMS_Territory_Number__c ='1004';
            C_tmsTerr.TMS_Sales_Force_Code__c='HO';
            C_tmsTerr.TMS_Market_Segment_Code__c='HFT';
            C_tmsTerr.TMS_Ref_Function_Code__c='AM';
            C_tmsTerr.Territory_ID__c=oUserTerritory.id;
            insert C_tmsTerr;
            //AccountTerritoriesHandler.AccountTerrCreationandUpdation(Accountlst);
            
            Account_Territory__c accterritory = new Account_Territory__c();
            accterritory.AMI_Territory__c=A_tmsTerr.id;
            accterritory.AM_Territory__c=TMS_Terr.id;
            accterritory.Account__c = oAccountA.id;
            insert accterritory;
            
            Test.startTest();
            Display_AccTerritory_Batch AccountTerritoryLoad = new Display_AccTerritory_Batch();
            Database.executeBatch(AccountTerritoryLoad,integer.valueof(cs1.Batch_Size__c));
            
            LCRM_Exception_Log__c excepObj = new LCRM_Exception_Log__c();
            excepObj = new LCRM_Exception_Log__c();
            excepObj.LCRM_Exception_Message__c = 'test';
            excepObj.LCRM_Exception_Trace__c = 'Account Territory Batch'+' '+'test';
            excepObj.LCRM_Exception_Type__c = 'Error found in Account Territory Batch'; 
            List<LCRM_Exception_Log__c> lst = new List<LCRM_Exception_Log__c>();
            lst.add(excepObj);
           // AccountTerritoriesHandler.createExceptionLog(lst,'strStackTrace','Batchclassname');
            
            Test.stopTest();
            
            
            
        }
    }
    
    @isTest static void testCreateTMSTerritory() {
    Profile profileId = [Select id from profile where name = 'System Administrator'];
    //create user data
        User testUser = new User(
            Alias = 'sUser', 
            Email='abc1@testorg.com',
            EmailEncodingKey='UTF-8', 
            LastName='Testing', 
            LanguageLocaleKey='en_US',
            LocaleSidKey='en_US', 
            ProfileId = profileId.id,
            Sales_Org__c = 'WEST',
            Sub_Bu__c='USL',
            TimeZoneSidKey='America/Los_Angeles', 
            UserName='abc123@testorg.com'
        );
        insert testUser;
        
        //create account data
        System.runAs(testUser) {
        List<RecordType> RecordtypeIDs=[SELECT Id,DeveloperName,IsActive FROM RecordType WHERE DeveloperName LIKE '%GLI%' AND SobjectType = 'Account' and IsActive =true];
        List<GLI_Record_type_Ids__c> ListofRecordtype = new List<GLI_Record_type_Ids__c>();
        GLI_Record_type_Ids__c OAccRecordtype = new GLI_Record_type_Ids__c ();
        OAccRecordtype.name ='GLI Account';       
        OAccRecordtype.GLI_Account_RecordTypeId__c = RecordtypeIDs[0].Id;
        ListofRecordtype.add(OAccRecordtype);

        GLI_Record_type_Ids__c AccRecordtype = new GLI_Record_type_Ids__c ();
        AccRecordtype.name ='GLI Account ECM';       
        AccRecordtype.GLI_Account_RecordTypeId__c = RecordtypeIDs[1].Id;
        ListofRecordtype.add(AccRecordtype);

        GLI_Record_type_Ids__c AccRecordtypeValue = new GLI_Record_type_Ids__c ();
        AccRecordtypeValue.name ='GLI_Archive';       
        AccRecordtypeValue.GLI_Account_RecordTypeId__c = RecordtypeIDs[1].Id;
        ListofRecordtype.add(AccRecordtypeValue);

        if(ListofRecordtype.size()>0){
        insert ListofRecordtype;            
        }
        List<Account> Accountlst = new List<Account>();
        Account oAccountA = UnitTest.getAccountInstance();
        oAccountA.Is_GLI__c=true;
        Accountlst.add(oAccountA);

        Account oAccountB = UnitTest.getAccountInstance();
        oAccountB.Is_GLI__c=true;
        Accountlst.add(oAccountB);

        if(Accountlst.size()>0){
        insert Accountlst;
        }

        GLI_Load_Tracker__c gliloadtracker = new GLI_Load_Tracker__c();
        gliloadtracker.name = 'Informatica Territory Load';
        //gliloadtracker.AccountTeamJobStartedDate__c = datetime.now() - 2;
        //gliloadtracker.TerritoryJobStartedDate__c = datetime.now() - 30;
        gliloadtracker.JobCompletedDate__c =datetime.now();
        Insert gliloadtracker;


        UserTerritory2Association oUserTerritory = [SELECT Id, Territory2Id, UserId FROM UserTerritory2Association WHERE IsActive=true and UserId!=null LIMIT 1];
        //UserTerritory oUserTerritory2 = [SELECT Id, TerritoryId, UserId FROM UserTerritory WHERE Id !=:oUserTerritory.Id AND IsActive=true and LastModifiedBy.isActive=true AND UserId!=null LIMIT 1];

        User oUser = [SELECT Id, Name FROM User WHERE Id=:oUserTerritory.UserId];
        oUser.Isactive=true;
        update OUser;
        
        Territory2 oTerritory = [SELECT Id, Name,District__c,TMS_Territory_Team_Role__c,ParentTerritory2Id, Description, 
        AccountAccessLevel, OpportunityAccessLevel, CaseAccessLevel, ContactAccessLevel,   CurrencyIsoCode,  DeveloperName,
        TMS_Market_Segment_Desc__c, TMS_Market_Segment_ID__c, TMS_Parent_Territory_ID__c, TMS_Rep_Function_Desc__c, 
        TMS_Rep_Function_ID__c, TMS_Sales_Force_Desc__c, TMS_Sales_Force_ID__c, TMS_Terr_Num__c, TMS_Territory_ID__c,
         TMS_New_Sales_Quota_Curr_Yr__c, TMS_Renewal_Sales_Quota_Curr_Yr__c, Region__c, TMS_Sales_Force_Code__c,
          TMS_Market_Segment_Code__c, TMS_Ref_Function_Code__c FROM Territory2 WHERE Id=:oUserTerritory.Territory2Id limit 1];       
         
        List<AccountTeamMember> members = new list<AccountTeamMember>();
        members.add(New AccountTeamMember(AccountId = Accountlst[0].id, TeamMemberRole = 'ACC-Team-Mem', UserId= testUser.Id));
        members.add(New AccountTeamMember(AccountId = Accountlst[0].id, TeamMemberRole = oTerritory.TMS_Territory_Team_Role__c, UserId= oUser.Id));
        insert members;
        
            List<LCRM_BatchsizeDefine__c> batchsizelst = new List<LCRM_BatchsizeDefine__c>();
            LCRM_BatchsizeDefine__c cs = new LCRM_BatchsizeDefine__c();
            cs.Name ='TMSTerritory_AccountTeamBatch';
            cs.Object__c ='TMS Territory';
            cs.Batch_Size__c = 10 ;
            batchsizelst.add(cs);
            
             
            LCRM_BatchsizeDefine__c cs01 = new LCRM_BatchsizeDefine__c();
            cs01.Name ='TMSTerritory_TerritoryBatch';
            cs01.Object__c ='TMS Territory';
            cs01.Batch_Size__c = 10 ;
            batchsizelst.add(cs01);
            
            LCRM_BatchsizeDefine__c cs1 = new LCRM_BatchsizeDefine__c();
            cs1.Name ='DisplayAccTerritory_Batch';
            cs1.Object__c ='Account Territory';
            cs1.Batch_Size__c = 10 ;
            batchsizelst.add(cs1);
            
           if(batchsizelst.size()>0){
                insert batchsizelst;
            }       
            
            List<Account_Territory_Creation__c > CustomSettingAccTerritory= new List<Account_Territory_Creation__c>();
            Account_Territory_Creation__c accAMterritory = new Account_Territory_Creation__c();
            accAMterritory.name = '1';
            accAMterritory.Account_Territory_Fields__c='AM_Territory__c';
            accAMterritory.Terr_Combine_code__c = 'NT-FGOV-AM';
            CustomSettingAccTerritory.add(accAMterritory);
            Account_Territory_Creation__c accAMIterritory = new Account_Territory_Creation__c();
            accAMIterritory.name = '2';
            accAMIterritory.Terr_Combine_code__c = 'HO-FII-AM'; 
            accAMIterritory.Account_Territory_Fields__c = 'AMI_Territory__c';
            CustomSettingAccTerritory.add(accAMIterritory);
            Account_Territory_Creation__c accFieldSalesterritory = new Account_Territory_Creation__c();
            accFieldSalesterritory.name = '3';
            accFieldSalesterritory.Terr_Combine_code__c = 'NT-CE-AE';   
            accFieldSalesterritory.Account_Territory_Fields__c = 'Field_Sales_Territory__c';
            CustomSettingAccTerritory.add(accFieldSalesterritory);
            
            if(CustomSettingAccTerritory.size()>0){
                insert CustomSettingAccTerritory;
                
            }//End size checking
            
             Test.StartTest(); 
            gliloadtracker.JobCompletedDate__c= datetime.now() + 2;
            UPDATE gliloadtracker;      
            Test.StopTest();
            
           /* members[0]. TeamMemberRole='Test';
            Update members;
            
            gliloadtracker.JobCompletedDate__c= datetime.newInstance(2018, 01, 01, 11, 30, 0);
            UPDATE gliloadtracker; ////
            
        }run AS
}    


 @isTest static void testMultipleAccountTeamTMSTerritory() {
Profile profileId = [Select id from profile where name = 'System Administrator'];
    //create user data
        User testUser = new User(
            Alias = 'sUser', 
            Email='abc1@testorg.com',
            EmailEncodingKey='UTF-8', 
            LastName='Testing', 
            LanguageLocaleKey='en_US',
            LocaleSidKey='en_US', 
            ProfileId = profileId.id,
            Sales_Org__c = 'WEST',
            Sub_Bu__c='USL',
            TimeZoneSidKey='America/Los_Angeles', 
            UserName='abc123@testorg.com'
        );
        insert testUser;
        
        //create account data
        System.runAs(testUser) {
        List<RecordType> RecordtypeIDs=[SELECT Id,DeveloperName,IsActive FROM RecordType WHERE DeveloperName LIKE '%GLI%' AND SobjectType = 'Account' and IsActive =true];
        List<GLI_Record_type_Ids__c> ListofRecordtype = new List<GLI_Record_type_Ids__c>();
        GLI_Record_type_Ids__c OAccRecordtype = new GLI_Record_type_Ids__c ();
        OAccRecordtype.name ='GLI Account';       
        OAccRecordtype.GLI_Account_RecordTypeId__c = RecordtypeIDs[0].Id;
        ListofRecordtype.add(OAccRecordtype);

        GLI_Record_type_Ids__c AccRecordtype = new GLI_Record_type_Ids__c ();
        AccRecordtype.name ='GLI Account ECM';       
        AccRecordtype.GLI_Account_RecordTypeId__c = RecordtypeIDs[1].Id;
        ListofRecordtype.add(AccRecordtype);

        GLI_Record_type_Ids__c AccRecordtypeValue = new GLI_Record_type_Ids__c ();
        AccRecordtypeValue.name ='GLI_Archive';       
        AccRecordtypeValue.GLI_Account_RecordTypeId__c = RecordtypeIDs[1].Id;
        ListofRecordtype.add(AccRecordtypeValue);

        if(ListofRecordtype.size()>0){
        insert ListofRecordtype;            
        }
        List<Account> Accountlst = new List<Account>();
        Account oAccountA = UnitTest.getAccountInstance();
        oAccountA.Is_GLI__c=true;
        Accountlst.add(oAccountA);

        Account oAccountB = UnitTest.getAccountInstance();
        oAccountB.Is_GLI__c=true;
        Accountlst.add(oAccountB);

        if(Accountlst.size()>0){
        insert Accountlst;
        }

        GLI_Load_Tracker__c gliloadtracker = new GLI_Load_Tracker__c();
        gliloadtracker.name = 'Informatica Territory Load';
        //gliloadtracker.AccountTeamJobStartedDate__c = datetime.now() - 2;
        //gliloadtracker.TerritoryJobStartedDate__c = datetime.now() - 30;
        gliloadtracker.JobCompletedDate__c =datetime.now();
        Insert gliloadtracker;


        UserTerritory2Association oUserTerritory = [SELECT Id, Territory2Id, UserId FROM UserTerritory2Association WHERE IsActive=true and UserId!=null  LIMIT 1];
        //UserTerritory oUserTerritory2 = [SELECT Id, TerritoryId, UserId FROM UserTerritory WHERE Id !=:oUserTerritory.Id AND IsActive=true and UserId!=null LIMIT 1];

        User oUser = [SELECT Id, Name FROM User WHERE Id=:oUserTerritory.UserId];
        oUser.isActive = true;
        update oUser;
        Territory2 oTerritory = [SELECT Id, Name,District__c,TMS_Territory_Team_Role__c,ParentTerritory2Id, Description,
         AccountAccessLevel, OpportunityAccessLevel, CaseAccessLevel, ContactAccessLevel,   CurrencyIsoCode,  DeveloperName,
         TMS_Market_Segment_Desc__c, TMS_Market_Segment_ID__c, TMS_Parent_Territory_ID__c, TMS_Rep_Function_Desc__c, 
         TMS_Rep_Function_ID__c, TMS_Sales_Force_Desc__c, TMS_Sales_Force_ID__c, TMS_Terr_Num__c, TMS_Territory_ID__c, 
         TMS_New_Sales_Quota_Curr_Yr__c, TMS_Renewal_Sales_Quota_Curr_Yr__c, Region__c, TMS_Sales_Force_Code__c, 
         TMS_Market_Segment_Code__c, TMS_Ref_Function_Code__c FROM Territory2 WHERE Id=:oUserTerritory.Territory2Id limit 1 ];  
        
        List<AccountTeamMember> members = new list<AccountTeamMember>();
        /*if(oUserTerritory2.UserId !=null){
            User oUser1 = [SELECT Id, Name FROM User WHERE Id=:oUserTerritory2.UserId and isActive=true];           
            if(oUser1!=null )
            members.add(New AccountTeamMember(AccountId = Accountlst[0].id, TeamMemberRole = 'ACC-Team-Mem', UserId= oUser1.Id));
        }////
        
            members.add(New AccountTeamMember(AccountId = Accountlst[0].id, TeamMemberRole = oTerritory.TMS_Territory_Team_Role__c, UserId= oUser.Id));
            insert members;
        
            List<LCRM_BatchsizeDefine__c> batchsizelst = new List<LCRM_BatchsizeDefine__c>();
            LCRM_BatchsizeDefine__c cs = new LCRM_BatchsizeDefine__c();
            cs.Name ='TMSTerritory_AccountTeamBatch';
            cs.Object__c ='TMS Territory';
            cs.Batch_Size__c = 10 ;
            batchsizelst.add(cs);
            
             
            LCRM_BatchsizeDefine__c cs01 = new LCRM_BatchsizeDefine__c();
            cs01.Name ='TMSTerritory_TerritoryBatch';
            cs01.Object__c ='TMS Territory';
            cs01.Batch_Size__c = 10 ;
            batchsizelst.add(cs01);
            
            LCRM_BatchsizeDefine__c cs1 = new LCRM_BatchsizeDefine__c();
            cs1.Name ='DisplayAccTerritory_Batch';
            cs1.Object__c ='Account Territory';
            cs1.Batch_Size__c = 10 ;
            batchsizelst.add(cs1);
            
           if(batchsizelst.size()>0){
                insert batchsizelst;
            }       
            
            List<Account_Territory_Creation__c > CustomSettingAccTerritory= new List<Account_Territory_Creation__c>();
            Account_Territory_Creation__c accAMterritory = new Account_Territory_Creation__c();
            accAMterritory.name = '1';
            accAMterritory.Account_Territory_Fields__c='AM_Territory__c';
            accAMterritory.Terr_Combine_code__c = 'NT-FGOV-AM';
            CustomSettingAccTerritory.add(accAMterritory);
            Account_Territory_Creation__c accAMIterritory = new Account_Territory_Creation__c();
            accAMIterritory.name = '2';
            accAMIterritory.Terr_Combine_code__c = 'HO-FII-AM'; 
            accAMIterritory.Account_Territory_Fields__c = 'AMI_Territory__c';
            CustomSettingAccTerritory.add(accAMIterritory);
            Account_Territory_Creation__c accFieldSalesterritory = new Account_Territory_Creation__c();
            accFieldSalesterritory.name = '3';
            accFieldSalesterritory.Terr_Combine_code__c = 'NT-CE-AE';   
            accFieldSalesterritory.Account_Territory_Fields__c = 'Field_Sales_Territory__c';
            CustomSettingAccTerritory.add(accFieldSalesterritory);
            
            if(CustomSettingAccTerritory.size()>0){
                insert CustomSettingAccTerritory;
                
            }//End size checking
            
             Test.StartTest(); 
            gliloadtracker.JobCompletedDate__c= datetime.now() + 2;
            UPDATE gliloadtracker;      
            Test.StopTest();
            
           /* members[0]. TeamMemberRole='Test';
            Update members;
            
            gliloadtracker.JobCompletedDate__c= datetime.newInstance(2018, 01, 01, 11, 30, 0);
            UPDATE gliloadtracker; ///
            
        }//run AS
}

@isTest static void testTMSTerritory_TerritoryTest() {
        //create user data
        Profile profileId = [Select id from profile where name = 'System Administrator'];
        User testUser = new User(
            Alias = 'sUser', 
            Email='abc1@testorg.com',
            EmailEncodingKey='UTF-8', 
            LastName='Testing', 
            LanguageLocaleKey='en_US',
            LocaleSidKey='en_US', 
            ProfileId = profileId.id,
            Sales_Org__c = 'WEST',
            Sub_Bu__c='USL',
            TimeZoneSidKey='America/Los_Angeles', 
            UserName='abc123@testorg.com'
        );
        insert testUser;
        
        //create account data
        System.runAs(testUser) {
            List<RecordType> RecordtypeIDs=[SELECT Id,DeveloperName,IsActive FROM RecordType WHERE DeveloperName LIKE '%GLI%' AND SobjectType = 'Account' and IsActive =true];
            List<GLI_Record_type_Ids__c> ListofRecordtype = new List<GLI_Record_type_Ids__c>();
            GLI_Record_type_Ids__c OAccRecordtype = new GLI_Record_type_Ids__c ();
            OAccRecordtype.name ='GLI Account';       
            OAccRecordtype.GLI_Account_RecordTypeId__c = RecordtypeIDs[0].Id;
            ListofRecordtype.add(OAccRecordtype);
            
            GLI_Record_type_Ids__c AccRecordtype = new GLI_Record_type_Ids__c ();
            AccRecordtype.name ='GLI Account ECM';       
            AccRecordtype.GLI_Account_RecordTypeId__c = RecordtypeIDs[1].Id;
            ListofRecordtype.add(AccRecordtype);
            
            GLI_Record_type_Ids__c AccRecordtypeValue = new GLI_Record_type_Ids__c ();
            AccRecordtypeValue.name ='GLI_Archive';       
            AccRecordtypeValue.GLI_Account_RecordTypeId__c = RecordtypeIDs[1].Id;
            ListofRecordtype.add(AccRecordtypeValue);
            
            if(ListofRecordtype.size()>0){
                insert ListofRecordtype;            
            }
            List<Account> Accountlst = new List<Account>();
            Account oAccountA = UnitTest.getAccountInstance();
            oAccountA.Is_GLI__c=true;
            Accountlst.add(oAccountA);
            
            Account oAccountB = UnitTest.getAccountInstance();
            oAccountB.Is_GLI__c=true;
            Accountlst.add(oAccountB);
            
            if(Accountlst.size()>0){
                insert Accountlst;
            }
            
            //create GLI Load tracked Data
            GLI_Load_Tracker__c gliloadtracker = new GLI_Load_Tracker__c();
            gliloadtracker.name = 'Informatica Territory Load';
            //gliloadtracker.AccountTeamJobStartedDate__c = datetime.now() - 2;
            gliloadtracker.TerritoryJobStartedDate__c = datetime.now() - 30;
            gliloadtracker.JobCompletedDate__c= datetime.newInstance(2017, 9, 15, 12, 30, 0);
            Insert gliloadtracker;
            
            UserTerritory2Association oUserTerritory = [SELECT Id, Territory2Id, UserId FROM UserTerritory2Association  WHERE IsActive=true and UserId!=null LIMIT 1];
            UserTerritory2Association oUserTerritory2 = [SELECT Id, Territory2Id, UserId FROM UserTerritory2Association  WHERE Id !=:oUserTerritory.Id AND IsActive=true and UserId!=null LIMIT 1];
            
            User oUser = [SELECT Id, Name FROM User WHERE Id=:oUserTerritory.UserId ];
            oUser.isActive = true;
            update oUser;
            
            User oUser01 = [SELECT Id, Name FROM User WHERE Id=:oUserTerritory2.UserId ];
            oUser01.isActive = true;
            update oUser01;
            
            Territory2 oTerritory = [SELECT Id, Name,District__c,TMS_Territory_Team_Role__c,ParentTerritory2Id, Description, 
            AccountAccessLevel, OpportunityAccessLevel, CaseAccessLevel, ContactAccessLevel,   CurrencyIsoCode,  DeveloperName,
            TMS_Market_Segment_Desc__c, TMS_Market_Segment_ID__c, TMS_Parent_Territory_ID__c, TMS_Rep_Function_Desc__c,
             TMS_Rep_Function_ID__c, TMS_Sales_Force_Desc__c, TMS_Sales_Force_ID__c, TMS_Terr_Num__c, TMS_Territory_ID__c, 
             TMS_New_Sales_Quota_Curr_Yr__c, TMS_Renewal_Sales_Quota_Curr_Yr__c, Region__c, TMS_Sales_Force_Code__c, 
             TMS_Market_Segment_Code__c, TMS_Ref_Function_Code__c FROM Territory2 WHERE Id=:oUserTerritory.Territory2Id limit 1];
            
             TMS_Territory__c TMS_Terr =new TMS_Territory__c();
            TMS_Terr.Name = 'Test_created by SystemAdmin';
            TMS_Terr.Account__c = Accountlst[0].id;
            //TMS_Terr.ForecastUser__c=gliUser.Id;
            TMS_Terr.TMS_Sales_Force_Desc__c ='ACC';
            TMS_Terr.TMS_Market_Segment_Desc__c='Team';
            TMS_Terr.TMS_Rep_Function_Desc__c ='Mem';
            TMS_Terr.Territory_ID__c =oTerritory.id;
            TMS_Terr.TMS_Territory_Number__c ='1234';
            TMS_Terr.TMS_Sales_Force_Code__c = '123';
            TMS_terr.TMS_Market_Segment_Code__c = '1234';
            TMS_Terr.TMS_Ref_Function_Code__c = '1234';
            insert TMS_Terr; 
            
            Territory2 oTerritory2 = [SELECT Id,Channel__c, Name,TMS_Territory_Team_Role__c,District__c,ParentTerritory2Id, 
            Description, AccountAccessLevel, OpportunityAccessLevel, CaseAccessLevel, ContactAccessLevel,   CurrencyIsoCode,  
            DeveloperName,TMS_Market_Segment_Desc__c, TMS_Market_Segment_ID__c, TMS_Parent_Territory_ID__c, TMS_Rep_Function_Desc__c, 
            TMS_Rep_Function_ID__c, TMS_Sales_Force_Desc__c, TMS_Sales_Force_ID__c, TMS_Terr_Num__c, TMS_Territory_ID__c, 
            TMS_New_Sales_Quota_Curr_Yr__c, TMS_Renewal_Sales_Quota_Curr_Yr__c, Region__c, TMS_Sales_Force_Code__c,
             TMS_Market_Segment_Code__c, TMS_Ref_Function_Code__c FROM Territory2 WHERE Id=:oUserTerritory2.Territory2Id limit 1];
            oTerritory.Channel__c='test';
            update oTerritory2 ;
            
            set<ID> oTerritoryID = new set<ID>();
            oTerritoryID.add(oTerritory.Id);
            oTerritoryID.add(oTerritory2.Id);
            system.assertEquals(oTerritoryID.size(),1);
            Group oGroup = [SELECT Id, RelatedId FROM Group WHERE RelatedId=:oTerritory.Id AND Type='Territory' LIMIT 1];
            Group oGroup2 = [SELECT Id, RelatedId FROM Group WHERE RelatedId=:oTerritory2.Id AND Type='Territory' LIMIT 1];
            
            
            //System.assertEquals(gliContact.AccountId, gliAccount.id);
            List<AccountShare> accountsharelist = new List<AccountShare>();
            AccountShare oAccountShareA = new AccountShare();
            oAccountShareA.AccountId = Accountlst[0].Id;
            oAccountShareA.UserOrGroupId = oGroup.Id;
            accountsharelist.add(oAccountShareA);
            if(accountsharelist.size()>0){
                //insert accountsharelist;            
            }
            
            List<AccountTeamMember> members = new list<AccountTeamMember>();
            members.add(New AccountTeamMember(AccountId = Accountlst[0].id, TeamMemberRole = 'ACC-Team-Mem', UserId= testUser.Id));
            members.add(New AccountTeamMember(AccountId = Accountlst[1].id, TeamMemberRole = 'ACC-Team-Mem', UserId= testUser.Id));
            members.add(New AccountTeamMember(AccountId = Accountlst[0].id, TeamMemberRole = oTerritory.TMS_Territory_Team_Role__c, UserId= oUser.Id));
            members.add(New AccountTeamMember(AccountId = Accountlst[1].id, TeamMemberRole = oTerritory.TMS_Territory_Team_Role__c, UserId= oUser.Id));
            
            insert members;
            
            //define batch size
            List<LCRM_BatchsizeDefine__c> batchsizelst = new List<LCRM_BatchsizeDefine__c>();
            LCRM_BatchsizeDefine__c cs = new LCRM_BatchsizeDefine__c();
            cs.Name ='TMSTerritory_TerritoryBatch';
            cs.Object__c ='TMS Territory';
            cs.Batch_Size__c = 10 ;
            batchsizelst.add(cs);
            
            LCRM_BatchsizeDefine__c cs1 = new LCRM_BatchsizeDefine__c();
            cs1.Name ='Display_AccTerritory_Batch';
            cs1.Object__c ='Account Territory';
            cs1.Batch_Size__c = 10 ;
            batchsizelst.add(cs1);
           if(batchsizelst.size()>0){
                insert batchsizelst;
            }
            
            oTerritory.Channel__c='test';
            update oTerritory;
            
            Test.StartTest(); 
                TMSTerritory_TerritoryBatch UpdateTerritoryLoad = new TMSTerritory_TerritoryBatch();                
                Database.executeBatch(UpdateTerritoryLoad,100);    
               Test.StopTest();
            
            }
            
            
    
    } 
    
    
    @isTest static void testExceptionlog() {
   
   Profile profileId = [Select id from profile where name = 'System Administrator'];
    //create user data
        User testUser = new User(
            Alias = 'sUser', 
            Email='abc1@testorg.com',
            EmailEncodingKey='UTF-8', 
            LastName='Testing', 
            LanguageLocaleKey='en_US',
            LocaleSidKey='en_US', 
            ProfileId = profileId.id,
            Sales_Org__c = 'WEST',
            Sub_Bu__c='USL',
            TimeZoneSidKey='America/Los_Angeles', 
            UserName='abc123@testorg.com'
        );
        insert testUser;
        
        //create account data
        System.runAs(testUser) {
        LCRM_Exception_Log__c excepObj = new LCRM_Exception_Log__c();
        excepObj = new LCRM_Exception_Log__c();
        excepObj.LCRM_Exception_Message__c = 'test';
        excepObj.LCRM_Exception_Trace__c = 'TMSTerritory_AccountTeamBatch'+' '+'test';
        excepObj.LCRM_Exception_Type__c = 'Error found in TMS Territories Creation/updation';       
        //excepObj.LCRM_User_ID__c = userinfo.getUserId();
        insert excepObj;    
        String Excep='Null value';
        String strStackTrace='Test';
        String Batchclassname='TMSTerritory_AccountTeamBatch';
       // TMSTerritoryBatchHelper.createExceptionLog(Excep,strStackTrace,Batchclassname);
        
        //TMSTerritoryBatchHelper.getQueryString(Datetime.Now(),false);
        //TMSTerritoryBatchHelper.getQueryString(null ,false);      
        
        
    }
}

  @isTest static void testmultiAccTeammemberTMSTerr() {
Profile profileId = [Select id from profile where name = 'System Administrator'];
    //create user data
        User testUser = new User(
            Alias = 'sUser', 
            Email='abc1@testorg.com',
            EmailEncodingKey='UTF-8', 
            LastName='Testing', 
            LanguageLocaleKey='en_US',
            LocaleSidKey='en_US', 
            ProfileId = profileId.id,
            Sales_Org__c = 'WEST',
            Sub_Bu__c='USL',
            TimeZoneSidKey='America/Los_Angeles', 
            UserName='abc123@testorg.com'
        );
        insert testUser;
        
        //create account data
        System.runAs(testUser) {
        List<RecordType> RecordtypeIDs=[SELECT Id,DeveloperName,IsActive FROM RecordType WHERE DeveloperName LIKE '%GLI%' AND SobjectType = 'Account' and IsActive =true];
        List<GLI_Record_type_Ids__c> ListofRecordtype = new List<GLI_Record_type_Ids__c>();
        GLI_Record_type_Ids__c OAccRecordtype = new GLI_Record_type_Ids__c ();
        OAccRecordtype.name ='GLI Account';       
        OAccRecordtype.GLI_Account_RecordTypeId__c = RecordtypeIDs[0].Id;
        ListofRecordtype.add(OAccRecordtype);

        GLI_Record_type_Ids__c AccRecordtype = new GLI_Record_type_Ids__c ();
        AccRecordtype.name ='GLI Account ECM';       
        AccRecordtype.GLI_Account_RecordTypeId__c = RecordtypeIDs[1].Id;
        ListofRecordtype.add(AccRecordtype);

        GLI_Record_type_Ids__c AccRecordtypeValue = new GLI_Record_type_Ids__c ();
        AccRecordtypeValue.name ='GLI_Archive';       
        AccRecordtypeValue.GLI_Account_RecordTypeId__c = RecordtypeIDs[1].Id;
        ListofRecordtype.add(AccRecordtypeValue);

        if(ListofRecordtype.size()>0){
        insert ListofRecordtype;            
        }
        List<Account> Accountlst = new List<Account>();
        Account oAccountA = UnitTest.getAccountInstance();
        oAccountA.Is_GLI__c=true;
        Accountlst.add(oAccountA);

        Account oAccountB = UnitTest.getAccountInstance();
        oAccountB.Is_GLI__c=true;
        Accountlst.add(oAccountB);

        if(Accountlst.size()>0){
        insert Accountlst;
        }

        GLI_Load_Tracker__c gliloadtracker = new GLI_Load_Tracker__c();
        gliloadtracker.name = 'Informatica Territory Load';
        gliloadtracker.AccountTeamJobStartedDate__c = datetime.now() - 2;
        //gliloadtracker.TerritoryJobStartedDate__c = datetime.now() - 30;
        gliloadtracker.JobCompletedDate__c =datetime.now();
        Insert gliloadtracker;


        UserTerritory2Association oUserTerritory = [SELECT Id, Territory2Id, UserId FROM UserTerritory2Association WHERE IsActive=true and UserId!=null LIMIT 1];
        UserTerritory2Association oUserTerritory2 = [SELECT Id, Territory2Id, UserId FROM UserTerritory2Association WHERE Id !=:oUserTerritory.Id AND IsActive=true and UserId!=null LIMIT 1];
        
        System.debug('oUserTerritory2 **'+oUserTerritory2 );      
        User oUser = [SELECT Id,IsActive, Name FROM User WHERE Id=:oUserTerritory.UserId ];
        oUser.isActive = true;
        update oUser;
        
        Territory2 oTerritory = [SELECT Id, Name,TMS_Territory_Team_Role__c,District__c,ParentTerritory2Id, Description,
         AccountAccessLevel, OpportunityAccessLevel, CaseAccessLevel, ContactAccessLevel,   CurrencyIsoCode,  DeveloperName,
         TMS_Market_Segment_Desc__c, TMS_Market_Segment_ID__c, TMS_Parent_Territory_ID__c, TMS_Rep_Function_Desc__c,
          TMS_Rep_Function_ID__c, TMS_Sales_Force_Desc__c, TMS_Sales_Force_ID__c, TMS_Terr_Num__c, TMS_Territory_ID__c,
           TMS_New_Sales_Quota_Curr_Yr__c, TMS_Renewal_Sales_Quota_Curr_Yr__c, Region__c, TMS_Sales_Force_Code__c,
            TMS_Market_Segment_Code__c, TMS_Ref_Function_Code__c FROM Territory2 WHERE Id=:oUserTerritory.Territory2Id limit 1];
        
        UserTerritory2Association  oUserTerritory3 = [SELECT Id, Territory2Id, UserId FROM UserTerritory2Association  WHERE Id !=:oUserTerritory2.Id AND IsActive=true and Id !=:oUserTerritory.Id and UserId!=null LIMIT 1];
        System.debug('oUserTerritory3**'+oUserTerritory3);      
        User oUser3 = [SELECT Id,IsActive, Name FROM User WHERE Id=:oUserTerritory3.UserId];
        oUser3.isActive = true;
        update oUser3;
        
        Territory2 oTerritory2 = [SELECT Id, Name,TMS_Territory_Team_Role__c,District__c,ParentTerritory2Id, Description,
         AccountAccessLevel, OpportunityAccessLevel, CaseAccessLevel, ContactAccessLevel,   CurrencyIsoCode, 
          DeveloperName,TMS_Market_Segment_Desc__c, TMS_Market_Segment_ID__c, TMS_Parent_Territory_ID__c, TMS_Rep_Function_Desc__c, 
          TMS_Rep_Function_ID__c, TMS_Sales_Force_Desc__c, TMS_Sales_Force_ID__c, TMS_Terr_Num__c, TMS_Territory_ID__c, 
          TMS_New_Sales_Quota_Curr_Yr__c, TMS_Renewal_Sales_Quota_Curr_Yr__c, Region__c, TMS_Sales_Force_Code__c, 
          TMS_Market_Segment_Code__c, TMS_Ref_Function_Code__c FROM Territory2 WHERE Id=:oUserTerritory3.Territory2Id limit 1];
        
        System.debug('oUser3**'+oUser3);
        List<AccountTeamMember> members = new list<AccountTeamMember>();
        members.add(New AccountTeamMember(AccountId = Accountlst[0].id, TeamMemberRole = oTerritory2.TMS_Territory_Team_Role__c, UserId= oUser3.Id));
        members.add(New AccountTeamMember(AccountId = Accountlst[0].id, TeamMemberRole = oTerritory.TMS_Territory_Team_Role__c, UserId= oUser.Id));
        insert members;
        
            List<LCRM_BatchsizeDefine__c> batchsizelst = new List<LCRM_BatchsizeDefine__c>();
            LCRM_BatchsizeDefine__c cs = new LCRM_BatchsizeDefine__c();
            cs.Name ='TMSTerritory_AccountTeamBatch';
            cs.Object__c ='TMS Territory';
            cs.Batch_Size__c = 10 ;
            batchsizelst.add(cs);
            
             
            LCRM_BatchsizeDefine__c cs01 = new LCRM_BatchsizeDefine__c();
            cs01.Name ='TMSTerritory_TerritoryBatch';
            cs01.Object__c ='TMS Territory';
            cs01.Batch_Size__c = 10 ;
            batchsizelst.add(cs01);
            
            LCRM_BatchsizeDefine__c cs1 = new LCRM_BatchsizeDefine__c();
            cs1.Name ='Display_AccTerritory_Batch';
            cs1.Object__c ='Account Territory';
            cs1.Batch_Size__c = 10 ;
            batchsizelst.add(cs1);
            
           if(batchsizelst.size()>0){
                insert batchsizelst;
            }       
            
            List<Account_Territory_Creation__c > CustomSettingAccTerritory= new List<Account_Territory_Creation__c>();
            Account_Territory_Creation__c accAMterritory = new Account_Territory_Creation__c();
            accAMterritory.name = '1';
            accAMterritory.Account_Territory_Fields__c='AM_Territory__c';
            accAMterritory.Terr_Combine_code__c = 'NT-FGOV-AM';
            CustomSettingAccTerritory.add(accAMterritory);
            Account_Territory_Creation__c accAMIterritory = new Account_Territory_Creation__c();
            accAMIterritory.name = '2';
            accAMIterritory.Terr_Combine_code__c = 'HO-FII-AM'; 
            accAMIterritory.Account_Territory_Fields__c = 'AMI_Territory__c';
            CustomSettingAccTerritory.add(accAMIterritory);
            Account_Territory_Creation__c accFieldSalesterritory = new Account_Territory_Creation__c();
            accFieldSalesterritory.name = '3';
            accFieldSalesterritory.Terr_Combine_code__c = 'NT-CE-AE';   
            accFieldSalesterritory.Account_Territory_Fields__c = 'Field_Sales_Territory__c';
            CustomSettingAccTerritory.add(accFieldSalesterritory);
            
            if(CustomSettingAccTerritory.size()>0){
                insert CustomSettingAccTerritory;
                
            }//End size checking
            
             Test.StartTest(); 
            gliloadtracker.JobCompletedDate__c= datetime.now() + 2;
            UPDATE gliloadtracker;      
            Test.StopTest();
            
           
            
        }//run AS
    }    

@isTest static void testAccountTerritoryUpdate(){
        
        Profile profileId = [Select id from profile where name = 'System Administrator'];
        User testUser = new User(
            Alias = 'sUser', 
            Email='abc1@testorg.com',
            EmailEncodingKey='UTF-8', 
            LastName='Testing', 
            LanguageLocaleKey='en_US',
            LocaleSidKey='en_US', 
            ProfileId = profileid.id,
            Sales_Org__c = 'WEST',
            Sub_Bu__c='USL',
            TimeZoneSidKey='America/Los_Angeles', 
            UserName='abc1235@testorg.com'
        );
        insert testUser;
        
        System.runAs(testUser) {
            List<RecordType> RecordtypeIDs=[SELECT Id,DeveloperName,IsActive FROM RecordType WHERE DeveloperName LIKE '%GLI%' AND SobjectType = 'Account' and IsActive =true];
            List<GLI_Record_type_Ids__c> ListofRecordtype = new List<GLI_Record_type_Ids__c>();
            GLI_Record_type_Ids__c OAccRecordtype = new GLI_Record_type_Ids__c ();
            OAccRecordtype.name ='GLI Account';       
            OAccRecordtype.GLI_Account_RecordTypeId__c = RecordtypeIDs[0].Id;
            ListofRecordtype.add(OAccRecordtype);
            
            GLI_Record_type_Ids__c AccRecordtype = new GLI_Record_type_Ids__c ();
            AccRecordtype.name ='GLI Account ECM';       
            AccRecordtype.GLI_Account_RecordTypeId__c = RecordtypeIDs[1].Id;
            ListofRecordtype.add(AccRecordtype);
            
            GLI_Record_type_Ids__c AccRecordtypeValue = new GLI_Record_type_Ids__c ();
            AccRecordtypeValue.name ='GLI_Archive';       
            AccRecordtypeValue.GLI_Account_RecordTypeId__c = RecordtypeIDs[1].Id;
            ListofRecordtype.add(AccRecordtypeValue);
            
            //create GLI Load tracked Data
            GLI_Load_Tracker__c gliloadtracker = new GLI_Load_Tracker__c();
            gliloadtracker.name = 'Informatica Territory Load';
            gliloadtracker.AccountTeamJobStartedDate__c = datetime.now() - 2;
            gliloadtracker.TerritoryJobStartedDate__c = datetime.now() - 30;
            gliloadtracker.JobCompletedDate__c= datetime.newInstance(2017, 9, 15, 12, 30, 0);
            Insert gliloadtracker;
            
            if(ListofRecordtype.size()>0){
                insert ListofRecordtype;            
            }
            List<Account> Accountlst = new List<Account>();
            Account oAccountA = UnitTest.getAccountInstance();
            oAccountA.Is_GLI__c=true;
            Accountlst.add(oAccountA);
            
            Account oAccountB = UnitTest.getAccountInstance();
            oAccountB.Is_GLI__c=true;
            Accountlst.add(oAccountB);
            
            if(Accountlst.size()>0){
                insert Accountlst;
            }
            LCRM_BatchsizeDefine__c cs1 = new LCRM_BatchsizeDefine__c();
            cs1.Name ='Display_AccTerritory_Batch';
            cs1.Object__c ='Account Territory';
            cs1.Batch_Size__c = 10 ;
            insert cs1;
            
            List<Account_Territory_Creation__c > CustomSettingAccTerritory= new List<Account_Territory_Creation__c>();
            Account_Territory_Creation__c accAMterritory = new Account_Territory_Creation__c();
            accAMterritory.name = '1';
            accAMterritory.Account_Territory_Fields__c='AM_Territory__c';
            accAMterritory.Terr_Combine_code__c = 'NT-FGOV-AM';
            CustomSettingAccTerritory.add(accAMterritory);
            Account_Territory_Creation__c accAMIterritory = new Account_Territory_Creation__c();
            accAMIterritory.name = '2';
            accAMIterritory.Terr_Combine_code__c = 'HO-FII-AM'; 
            accAMIterritory.Account_Territory_Fields__c = 'AMI_Territory__c';
            CustomSettingAccTerritory.add(accAMIterritory);
            Account_Territory_Creation__c accFieldSalesterritory = new Account_Territory_Creation__c();
            accFieldSalesterritory.name = '3';
            accFieldSalesterritory.Terr_Combine_code__c = 'NT-CE-AE';   
            accFieldSalesterritory.Account_Territory_Fields__c = 'Field_Sales_Territory__c';
            CustomSettingAccTerritory.add(accFieldSalesterritory);
            
            if(CustomSettingAccTerritory.size()>0){
                insert CustomSettingAccTerritory;}
            
            UserTerritory2Association oUserTerritory = [SELECT Id, Territory2Id, UserId FROM UserTerritory2Association WHERE IsActive=true and UserId!=null LIMIT 1];
            UserTerritory2Association oUserTerritory2 = [SELECT Id, Territory2Id, UserId FROM UserTerritory2Association WHERE Id !=:oUserTerritory.Id AND IsActive=true and UserId!=null LIMIT 1];
            //userTerritory_ID.add(oUserTerritory.TerritoryId);
            //userTerritory_ID.add(oUserTerritory2.TerritoryId);
            //User oUser = [SELECT Id, Name FROM User WHERE Id=:oUserTerritory.UserId and IsActive = true];
            
            Territory2 oTerritory = [SELECT Id, Name,District__c,TMS_Territory_Team_Role__c,ParentTerritory2Id, Description, 
            AccountAccessLevel, OpportunityAccessLevel, CaseAccessLevel, ContactAccessLevel,   CurrencyIsoCode,  DeveloperName,
            TMS_Market_Segment_Desc__c, TMS_Market_Segment_ID__c, TMS_Parent_Territory_ID__c, TMS_Rep_Function_Desc__c, 
            TMS_Rep_Function_ID__c, TMS_Sales_Force_Desc__c, TMS_Sales_Force_ID__c, TMS_Terr_Num__c, TMS_Territory_ID__c, 
            TMS_New_Sales_Quota_Curr_Yr__c, TMS_Renewal_Sales_Quota_Curr_Yr__c, Region__c, TMS_Sales_Force_Code__c, 
            TMS_Market_Segment_Code__c, TMS_Ref_Function_Code__c FROM Territory2 WHERE Id=:oUserTerritory.Territory2Id  limit 1];
            System.debug('oTerritory_12:-'+oTerritory);
            oTerritory.TMS_Sales_Force_Code__c = 'HO';
            oTerritory.TMS_Market_Segment_Code__c= 'FII';
            oTerritory.TMS_Ref_Function_Code__c= 'AM';
            System.debug('oTerritory_1:-'+oTerritory);
            //update oTerritory;
            
            Territory2 oTerritory2 = [SELECT Id, Name,District__c,TMS_Territory_Team_Role__c,ParentTerritory2Id, Description, 
            AccountAccessLevel, OpportunityAccessLevel, CaseAccessLevel, ContactAccessLevel,   CurrencyIsoCode,  DeveloperName,
            TMS_Market_Segment_Desc__c, TMS_Market_Segment_ID__c, TMS_Parent_Territory_ID__c, TMS_Rep_Function_Desc__c, 
            TMS_Rep_Function_ID__c, TMS_Sales_Force_Desc__c, TMS_Sales_Force_ID__c, TMS_Terr_Num__c, TMS_Territory_ID__c, 
            TMS_New_Sales_Quota_Curr_Yr__c, TMS_Renewal_Sales_Quota_Curr_Yr__c, Region__c, TMS_Sales_Force_Code__c,
             TMS_Market_Segment_Code__c, TMS_Ref_Function_Code__c FROM Territory2 WHERE Id=:oUserTerritory2.Territory2Id limit 1];
            System.debug('oTerritory2_2:-'+oTerritory2);
            
            List<TMS_Territory__c> TMSTerritorylst = new List<TMS_Territory__c>();
            TMS_Territory__c TMS_Terr =new TMS_Territory__c();
            TMS_Terr.Name = 'Test_created by SystemAdmin';
            TMS_Terr.Account__c = oAccountA.id;
            //TMS_Terr.ForecastUser__c=gliUser.Id;
            TMS_Terr.TMS_Sales_Force_Desc__c ='ACC';
            TMS_Terr.TMS_Market_Segment_Desc__c='Team';
            TMS_Terr.TMS_Rep_Function_Desc__c ='Mem';
            TMS_Terr.TMS_Sales_Force_Code__c='NT';
            TMS_Terr.TMS_Market_Segment_Code__c='FGOV';
            TMS_Terr.TMS_Ref_Function_Code__c='AM';
            TMS_Terr.TMS_Territory_Number__c ='1234';
            TMS_Terr.Territory_ID__c=oUserTerritory2.id;
            TMSTerritorylst.add(TMS_Terr);
            
            TMS_Territory__c A_tmsTerr =new TMS_Territory__c();
            A_tmsTerr.Name = 'Test_created by SystemAdmin 01';
            A_tmsTerr.Account__c = oAccountA.id;
            A_tmsTerr.TMS_Sales_Force_Desc__c ='ACC';
            A_tmsTerr.TMS_Market_Segment_Desc__c='Team';
            A_tmsTerr.TMS_Rep_Function_Desc__c ='Mem';
            A_tmsTerr.TMS_Territory_Number__c ='1004';
            A_tmsTerr.TMS_Sales_Force_Code__c='HO';
            A_tmsTerr.TMS_Market_Segment_Code__c='FII';
            A_tmsTerr.TMS_Ref_Function_Code__c='AM';
            A_tmsTerr.Territory_ID__c=oUserTerritory.id;
            TMSTerritorylst.add(A_tmsTerr);
            
            
            TMS_Territory__c B_TMS_Terr =new TMS_Territory__c();
            B_TMS_Terr.Name = 'Test_created by SystemAdmin';
            B_TMS_Terr.Account__c = oAccountA.id;
            //TMS_Terr.ForecastUser__c=gliUser.Id;
            B_TMS_Terr.TMS_Sales_Force_Desc__c ='ACC';
            B_TMS_Terr.TMS_Market_Segment_Desc__c='Team';
            B_TMS_Terr.TMS_Rep_Function_Desc__c ='Mem';
            B_TMS_Terr.TMS_Sales_Force_Code__c='NT';
            B_TMS_Terr.TMS_Market_Segment_Code__c='CE';
            B_TMS_Terr.TMS_Ref_Function_Code__c='AE';
            B_TMS_Terr.TMS_Territory_Number__c ='1234';
            B_TMS_Terr.Territory_ID__c=oUserTerritory2.id;
            TMSTerritorylst.add(B_TMS_Terr);
            
            TMS_Territory__c C_tmsTerr =new TMS_Territory__c();
            C_tmsTerr.Name = 'Test_created by SystemAdmin 01';
            C_tmsTerr.Account__c = oAccountA.id;
            C_tmsTerr.TMS_Sales_Force_Desc__c ='ACC';
            C_tmsTerr.TMS_Market_Segment_Desc__c='Team';
            C_tmsTerr.TMS_Rep_Function_Desc__c ='Mem';
            C_tmsTerr.TMS_Territory_Number__c ='1004';
            C_tmsTerr.TMS_Sales_Force_Code__c='HO';
            C_tmsTerr.TMS_Market_Segment_Code__c='HFTT';
            C_tmsTerr.TMS_Ref_Function_Code__c='AM';
            C_tmsTerr.Territory_ID__c=oUserTerritory.id;
            TMSTerritorylst.add(C_tmsTerr);
            if(TMSTerritorylst.size()>0){
                    insert TMSTerritorylst;
            }
            //AccountTerritoriesHandler.AccountTerrCreationandUpdation(Accountlst);
            
            Account_Territory__c accterritory = new Account_Territory__c();
            accterritory.AMI_Territory__c=A_tmsTerr.id;
            accterritory.AM_Territory__c=TMS_Terr.id;
            accterritory.Account__c = oAccountA.id;
            insert accterritory;
            
            Test.startTest();
            System.debug('TestclassOTMSTerritorylst'+TMSTerritorylst);
           // AccountTerritoriesHandler.AccountTerrCreationandUpdation(TMSTerritorylst);
            LCRM_Exception_Log__c excepObj = new LCRM_Exception_Log__c();
            excepObj = new LCRM_Exception_Log__c();
            excepObj.LCRM_Exception_Message__c = 'test';
            excepObj.LCRM_Exception_Trace__c = 'Account Territory Batch'+' '+'test';
            excepObj.LCRM_Exception_Type__c = 'Error found in Account Territory Batch'; 
            List<LCRM_Exception_Log__c> lst = new List<LCRM_Exception_Log__c>();
            lst.add(excepObj);
            //AccountTerritoriesHandler.createExceptionLog(lst,'strStackTrace','Batchclassname');
            
            Test.stopTest();
            List<TMS_Territory__c> OTMSTerritorylst = new list<TMS_Territory__c>();
            for(TMS_Territory__c TMSTerritory:TMSTerritorylst){
                String TMSCombineCode='';
                TMSCombineCode=TMSTerritory.TMS_Sales_Force_Code__c+'-'+TMSTerritory.TMS_Market_Segment_Code__c+'-'+TMSTerritory.TMS_Ref_Function_Code__c;
                if(TMSCombineCode=='NT-CE-AE'){
                    TMSTerritory.TMS_Sales_Force_Code__c='';
                    TMSTerritory.TMS_Market_Segment_Code__c='';
                    TMSTerritory.TMS_Ref_Function_Code__c='';
                }
                if(TMSCombineCode=='HO-HFTT-AM'){
                    TMSTerritory.TMS_Sales_Force_Code__c='NT';
                    TMSTerritory.TMS_Market_Segment_Code__c='CE';
                    TMSTerritory.TMS_Ref_Function_Code__c='AE';
                }
                OTMSTerritorylst.add(TMSTerritory);
            }
            if(OTMSTerritorylst.size()>0){
                update OTMSTerritorylst;
            }
            System.debug('TestclassOTMSTerritorylst'+OTMSTerritorylst);
           // AccountTerritoriesHandler.AccountTerrCreationandUpdation(OTMSTerritorylst);
            
        }
    }
*/
}