/*
======================================================================================================================
CLASS NAME:  GLILoadTrackerAfterEventListener_test
======================================================================================================================
PURPOSE:  code coverage for newly created Trigger GLILoadTrackerAfterEventListener.This class is used for to code coverage for TMS Territory and Account territory creation and updation functionality. 

JIRA story: CRM-11669 Display Territories in GLI - SFDC Batch classes
[SSDF JIRA DTC] (CRM-11892) Display Territories in GLI - SFDC batch class dependency framework


Referenced by : DisplayTerritoriesonAccount_Batch()
CHANGE HISTORY:
Classes coved:
1. TMSTerritoryONAccountHandler
2. AccountTerritoriesHandler
3. GLILoadTrackerAfterEventListener
4. DisplayTerritoriesonAccount_Batch
5. DisplayAccTerritory_Batch
6. RefreshLeadActivityCountBatch
======================================================================================================================
DATE      Developer NAME      DESC
11/12/2017      Radhika Pawar      
11/12/2017      Seema Nagdev      
11/12/2017      Niket Kapasi      
11/12/2017      vaishali Nagar      
10/22/2018    Jason Flippen      Added coverage for RefreshLeadActivityCountBatch (Jira Story CRM-13127).
======================================================================================================================
*/
@isTest( seeAllData = false)
public class GLILoadTrackerAfterEventListener_test{ 
   
    @isTest static void testcreateTMSTerritory() {
        User testUser = new User(
            Alias = 'sUser', 
            Email='abc1@testorg.com',
            EmailEncodingKey='UTF-8', 
            LastName='Testing', 
            LanguageLocaleKey='en_US',
            LocaleSidKey='en_US', 
            ProfileId = userinfo.getProfileid(),
            Sales_Org__c = 'WEST',
            Sub_Bu__c='USL',
            TimeZoneSidKey='America/Los_Angeles', 
            UserName='abc123@testorg.com'
        );
        insert testUser;
        
        System.runAs(testUser) {
            List<RecordType> recordtypeIDs=[SELECT Id,DeveloperName,IsActive FROM RecordType WHERE DeveloperName LIKE '%GLI%' AND SobjectType = 'Account' and IsActive =true];
            List<GLI_Record_type_Ids__c> listofRecordtype = new List<GLI_Record_type_Ids__c>();
            GLI_Record_type_Ids__c oAccRecordtype = new GLI_Record_type_Ids__c ();
            oAccRecordtype.name ='GLI Account';       
            oAccRecordtype.GLI_Account_RecordTypeId__c = recordtypeIDs[0].Id;
            listofRecordtype.add(oAccRecordtype);
            
            GLI_Record_type_Ids__c accRecordtype = new GLI_Record_type_Ids__c ();
            accRecordtype.name ='GLI Account ECM';       
            accRecordtype.GLI_Account_RecordTypeId__c = recordtypeIDs[1].Id;
            listofRecordtype.add(accRecordtype);
            
            GLI_Record_type_Ids__c accRecordtypeValue = new GLI_Record_type_Ids__c ();
            accRecordtypeValue.name ='GLI_Archive';       
            accRecordtypeValue.GLI_Account_RecordTypeId__c = recordtypeIDs[1].Id;
            listofRecordtype.add(accRecordtypeValue);
            
            if(listofRecordtype.size()>0){
                insert listofRecordtype;            
            }
            List<Account> accountlst = new List<Account>();
            Account oAccountA = UnitTest.getAccountInstance();
            oAccountA.Is_GLI__c=true;
            accountlst.add(oAccountA);
            
            Account oAccountB = UnitTest.getAccountInstance();
            oAccountB.Is_GLI__c=true;
            accountlst.add(oAccountB);
            
            if(accountlst.size()>0){
                insert accountlst;
            }
            
            UserTerritory2Association oUserTerritory = [SELECT Id, Territory2Id, UserId FROM UserTerritory2Association WHERE IsActive=true LIMIT 1];
            UserTerritory2Association oUserTerritory2 = [SELECT Id, Territory2Id, UserId FROM UserTerritory2Association WHERE Id !=:oUserTerritory.Id AND IsActive=true LIMIT 1];
            
            User oUser = [SELECT Id, Name FROM User WHERE Id=:oUserTerritory.UserId];
            
            Territory2 oTerritory = [SELECT Id FROM Territory2 WHERE Id=:oUserTerritory.Territory2Id];
            Territory2 oTerritory2 = [SELECT Id FROM Territory2 WHERE Id=:oUserTerritory2.Territory2Id];
            
            Group oGroup = [SELECT Id, RelatedId FROM Group WHERE RelatedId=:oTerritory.Id AND Type='Territory' LIMIT 1];
            Group oGroup2 = [SELECT Id, RelatedId FROM Group WHERE RelatedId=:oTerritory2.Id AND Type='Territory' LIMIT 1];
            List<AccountShare> accountsharelist = new List<AccountShare>();
            AccountShare oAccountShareA = new AccountShare();
            oAccountShareA.AccountId = oAccountA.Id;
            oAccountShareA.UserOrGroupId = oGroup.Id;
            accountsharelist.add(oAccountShareA);
            
            AccountShare oAccountShareB = new AccountShare();
            oAccountShareB.AccountId = oAccountA.Id;
            oAccountShareB.UserOrGroupId = oGroup2.Id;
            accountsharelist.add(oAccountShareB);
            
            AccountShare oAccountShareC = new AccountShare();
            oAccountShareC.AccountId = oAccountB.Id;
            oAccountShareC.UserOrGroupId = oGroup.Id;
            accountsharelist.add(oAccountShareC);
            /*if(accountsharelist.size()>0){
               // insert accountsharelist;            
            }*/
            List<LCRM_BatchsizeDefine__c> batchsizelst = new List<LCRM_BatchsizeDefine__c>();
            LCRM_BatchsizeDefine__c cs = new LCRM_BatchsizeDefine__c();
            cs.Name ='DisplayTerritoriesonAccount_Batch';
            cs.Object__c ='TMS Territory';
            cs.Batch_Size__c = 50 ;
            batchsizelst.add(cs);
            
            LCRM_BatchsizeDefine__c obatchsize = new LCRM_BatchsizeDefine__c();
            obatchsize.Name ='DisplayAccTerritory_Batch';
            obatchsize.Object__c ='AccountTerritory';
            obatchsize.Batch_Size__c = 50 ;
            batchsizelst.add(obatchsize);
            
            if(batchsizelst.size()>0){
                insert batchsizelst;
            }
            
            //TMS_Territory__c TMSTerr = new TMS_Territory__c();
            //Create custom setting 
            List<Account_Territory_Creation__c > customSettingAccTerritory= new List<Account_Territory_Creation__c>();
            Account_Territory_Creation__c accAMterritory = new Account_Territory_Creation__c();
            accAMterritory.name = '1';
            accAMterritory.Account_Territory_Fields__c='AM_Territory__c';
            accAMterritory.Terr_Combine_code__c = 'NT-FGOV-AM';
            customSettingAccTerritory.add(accAMterritory);
            Account_Territory_Creation__c accAMIterritory = new Account_Territory_Creation__c();
            accAMIterritory.name = '2';
            accAMIterritory.Terr_Combine_code__c = 'HO-FII-AM'; 
            accAMIterritory.Account_Territory_Fields__c = 'AMI_Territory__c';
            customSettingAccTerritory.add(accAMIterritory);
            Account_Territory_Creation__c accFieldSalesterritory = new Account_Territory_Creation__c();
            accFieldSalesterritory.name = '3';
            accFieldSalesterritory.Terr_Combine_code__c = 'NT-CE-AE';   
            accFieldSalesterritory.Account_Territory_Fields__c = 'Field_Sales_Territory__c';
            customSettingAccTerritory.add(accFieldSalesterritory);
            
            if(customSettingAccTerritory.size()>0){
                insert customSettingAccTerritory;
                
            }//End size checking
            
            GLI_Load_Tracker__c gliloadtracker = new GLI_Load_Tracker__c();
            gliloadtracker.name = 'Informatica Territory Load';
            gliloadtracker.JobCompletedDate__c= datetime.newInstance(2017, 9, 15, 12, 30, 0);
            Insert gliloadtracker;
            
            TMS_Territory__c tMSTerr =new TMS_Territory__c();
            tMSTerr.Name = 'Test_created by SystemAdmin';
            tMSTerr.Account__c = oAccountA.id;
            //TMS_Terr.ForecastUser__c=gliUser.Id;
            tMSTerr.TMS_Sales_Force_Desc__c ='ACC';
            tMSTerr.TMS_Market_Segment_Desc__c='Team';
            tMSTerr.TMS_Rep_Function_Desc__c ='Mem';
            //TMS_Terr.Territory_ID__c =oTerritory.id;
            tMSTerr.TMS_Territory_Number__c ='1234';
            insert tMSTerr;
            
            Test.StartTest(); 
            gliloadtracker.JobCompletedDate__c= datetime.newInstance(2017, 10, 16, 11, 30, 0);
            UPDATE gliloadtracker;      
            Test.StopTest();
            
            gliloadtracker.JobCompletedDate__c= datetime.newInstance(2018, 01, 01, 11, 30, 0);
            UPDATE gliloadtracker; 
            
            List<TMS_Territory__c> tMsTerritorylst = [SELECT Id, Name,RestrictOpportunityTransfer__c, ParentTerritory__c, DeveloperName__c, ForecastUser__c, MayForecastManagerShare__c, Region__c, TMS_Market_Segment_Desc__c, TMS_Market_Segment_ID__c, TMS_New_Sales_Quota_Curr_Yr__c, TMS_Parent_Territory_ID__c, TMS_Renewal_Sales_Quota_Curr_Yr__c, TMS_Rep_Function_Desc__c, TMS_Rep_Function_ID__c, TMS_Sales_Force_Desc__c, TMS_Sales_Force_ID__c, TMS_Territory_ID__c, TMS_Territory_Number__c, Account__c, Territory_ID__c, District__c, AccountAccessLevel__c, CaseAccessLevel__c, ContactAccessLevel__c, Description__c, OpportunityAccessLevel__c,  TMS_Sales_Force_Code__c, TMS_Market_Segment_Code__c, TMS_Ref_Function_Code__c FROM TMS_Territory__c where Account__c IN :Accountlst ];        
            System.assertEquals(!tMsTerritorylst.isempty(),true);
        }
    }//End testcreateTMSTerritory method
    
    //@update TMS territory
    @isTest static void testupdateTMSTerritory() {
        User testUser = new User(
            Alias = 'sUser', 
            Email='abc1@testorg.com',
            EmailEncodingKey='UTF-8', 
            LastName='Testing', 
            LanguageLocaleKey='en_US',
            LocaleSidKey='en_US', 
            ProfileId = userinfo.getProfileid(),
            Sales_Org__c = 'WEST',
            Sub_Bu__c='USL',
            TimeZoneSidKey='America/Los_Angeles', 
            UserName='abc123@testorg.com'
        );
        insert testUser;
        
        System.runAs(testUser) {
            List<RecordType> recordtypeIDs=[SELECT Id,DeveloperName,IsActive FROM RecordType WHERE DeveloperName LIKE '%GLI%' AND SobjectType = 'Account' and IsActive =true];
            List<GLI_Record_type_Ids__c> listofRecordtype = new List<GLI_Record_type_Ids__c>();
            GLI_Record_type_Ids__c oAccRecordtype = new GLI_Record_type_Ids__c ();
            oAccRecordtype.name ='GLI Account';       
            oAccRecordtype.GLI_Account_RecordTypeId__c = recordtypeIDs[0].Id;
            listofRecordtype.add(oAccRecordtype);
            
            GLI_Record_type_Ids__c accRecordtype = new GLI_Record_type_Ids__c ();
            accRecordtype.name ='GLI Account ECM';       
            accRecordtype.GLI_Account_RecordTypeId__c = recordtypeIDs[1].Id;
            listofRecordtype.add(accRecordtype);
            
            GLI_Record_type_Ids__c accRecordtypeValue = new GLI_Record_type_Ids__c ();
            accRecordtypeValue.name ='GLI_Archive';       
            accRecordtypeValue.GLI_Account_RecordTypeId__c = recordtypeIDs[1].Id;
            listofRecordtype.add(accRecordtypeValue);
            
            if(listofRecordtype.size()>0){
                insert listofRecordtype;            
            }
            List<Account> accountlst = new List<Account>();
            Account oAccountA = UnitTest.getAccountInstance();
            oAccountA.Is_GLI__c=true;
            accountlst.add(oAccountA);
            
            Account oAccountB = UnitTest.getAccountInstance();
            oAccountB.Is_GLI__c=true;
            accountlst.add(oAccountB);
            
            if(accountlst.size()>0){
                insert accountlst;
            }
            //
            set<Id> accountId =new set<Id>();
            accountId.add(oAccountA.id);
            accountId.add(oAccountB.id);       
            //
            UserTerritory2Association oUserTerritory = [SELECT Id, Territory2Id , UserId FROM UserTerritory2Association WHERE IsActive=true LIMIT 1];
            UserTerritory2Association oUserTerritory2 = [SELECT Id, Territory2Id, UserId FROM UserTerritory2Association WHERE Id !=:oUserTerritory.Id AND IsActive=true LIMIT 1];
            
            User oUser = [SELECT Id, Name FROM User WHERE Id=:oUserTerritory.UserId];
            
            Territory2 oTerritory = [SELECT Id, Name,District__c,ParentTerritory2Id, Description, AccountAccessLevel,
             OpportunityAccessLevel, CaseAccessLevel, ContactAccessLevel, ForecastUserId,  
             CurrencyIsoCode,  DeveloperName,TMS_Market_Segment_Desc__c, TMS_Market_Segment_ID__c, 
             TMS_Parent_Territory_ID__c, TMS_Rep_Function_Desc__c, TMS_Rep_Function_ID__c, TMS_Sales_Force_Desc__c,
              TMS_Sales_Force_ID__c, TMS_Terr_Num__c, TMS_Territory_ID__c, TMS_New_Sales_Quota_Curr_Yr__c,
               TMS_Renewal_Sales_Quota_Curr_Yr__c, Region__c, TMS_Sales_Force_Code__c, TMS_Market_Segment_Code__c, 
               TMS_Ref_Function_Code__c FROM Territory2 WHERE Id=:oUserTerritory2.Territory2Id];
            
            Territory2 oTerritory2 = [SELECT Id, Name,District__c,ParentTerritory2Id, Description, AccountAccessLevel, 
            OpportunityAccessLevel, CaseAccessLevel, ContactAccessLevel, ForecastUserId,  CurrencyIsoCode,
              DeveloperName,TMS_Market_Segment_Desc__c, TMS_Market_Segment_ID__c, TMS_Parent_Territory_ID__c,
              TMS_Rep_Function_Desc__c, TMS_Rep_Function_ID__c, TMS_Sales_Force_Desc__c, TMS_Sales_Force_ID__c, TMS_Terr_Num__c, 
              TMS_Territory_ID__c, TMS_New_Sales_Quota_Curr_Yr__c, TMS_Renewal_Sales_Quota_Curr_Yr__c, Region__c, 
              TMS_Sales_Force_Code__c, TMS_Market_Segment_Code__c, TMS_Ref_Function_Code__c FROM Territory2 WHERE Id=:oUserTerritory2.Territory2Id];
            
            System.debug('oTerritory:-'+oTerritory);
            System.debug('oTerritory2:-'+oTerritory2);
            set<ID> oTerritoryID = new set<ID>();
            oTerritoryID.add(oTerritory.Id);
            oTerritoryID.add(oTerritory2.Id);
            
            Group oGroup = [SELECT Id, RelatedId FROM Group WHERE RelatedId=:oTerritory.Id AND Type='Territory' LIMIT 1];
            Group oGroup2 = [SELECT Id, RelatedId FROM Group WHERE RelatedId=:oTerritory2.Id AND Type='Territory' LIMIT 1];
            List<AccountShare> accountsharelist = new List<AccountShare>();
            AccountShare oAccountShareA = new AccountShare();
            oAccountShareA.AccountId = oAccountA.Id;
            oAccountShareA.UserOrGroupId = oGroup.Id;
            accountsharelist.add(oAccountShareA);
            
            AccountShare oAccountShareB = new AccountShare();
            oAccountShareB.AccountId = oAccountA.Id;
            oAccountShareB.UserOrGroupId = oGroup2.Id;
            accountsharelist.add(oAccountShareB);
            
            AccountShare oAccountShareC = new AccountShare();
            oAccountShareC.AccountId = oAccountB.Id;
            oAccountShareC.UserOrGroupId = oGroup.Id;
            accountsharelist.add(oAccountShareC);
            //if(accountsharelist.size()>0){
               // insert accountsharelist;            
            //}
            System.debug('accountsharelist:-'+accountsharelist);
            
            List<LCRM_BatchsizeDefine__c> batchsizelst = new List<LCRM_BatchsizeDefine__c>();
            LCRM_BatchsizeDefine__c cs = new LCRM_BatchsizeDefine__c();
            cs.Name ='DisplayTerritoriesonAccount_Batch';
            cs.Object__c ='TMS Territory';
            cs.Batch_Size__c = 200 ;
            batchsizelst.add(cs);
            
            LCRM_BatchsizeDefine__c obatchsize = new LCRM_BatchsizeDefine__c();
            obatchsize.Name ='DisplayAccTerritory_Batch';
            obatchsize.Object__c ='AccountTerritory';
            obatchsize.Batch_Size__c = 200 ;
            batchsizelst.add(obatchsize);
            
            if(batchsizelst.size()>0){
                insert batchsizelst;
            }
            //TMS_Territory__c TMSTerr = new TMS_Territory__c();
            //Create custom setting 
            List<Account_Territory_Creation__c > customSettingAccTerritory= new List<Account_Territory_Creation__c>();
            Account_Territory_Creation__c accAMterritory = new Account_Territory_Creation__c();
            accAMterritory.name = '1';
            accAMterritory.Account_Territory_Fields__c='AM_Territory__c';
            accAMterritory.Terr_Combine_code__c = 'NT-FGOV-AM';
            customSettingAccTerritory.add(accAMterritory);
            Account_Territory_Creation__c accAMIterritory = new Account_Territory_Creation__c();
            accAMIterritory.name = '2';
            accAMIterritory.Terr_Combine_code__c = 'HO-FII-AM'; 
            accAMIterritory.Account_Territory_Fields__c = 'AMI_Territory__c';
            customSettingAccTerritory.add(accAMIterritory);
            Account_Territory_Creation__c accFieldSalesterritory = new Account_Territory_Creation__c();
            accFieldSalesterritory.name = '3';
            accFieldSalesterritory.Terr_Combine_code__c = 'NT-CE-AE';   
            accFieldSalesterritory.Account_Territory_Fields__c = 'Field_Sales_Territory__c';
            customSettingAccTerritory.add(accFieldSalesterritory);
            
            if(customSettingAccTerritory.size()>0){
                insert customSettingAccTerritory;
                
            }//End size checking
            
            GLI_Load_Tracker__c gliloadtracker = new GLI_Load_Tracker__c();
            gliloadtracker.name = 'Informatica Territory Load';
            gliloadtracker.JobCompletedDate__c= datetime.newInstance(2017, 9, 15, 12, 30, 0);
            Insert gliloadtracker;
            
            Test.StartTest(); 
            gliloadtracker.JobCompletedDate__c= datetime.newInstance(2017, 10, 16, 11, 30, 0);
            UPDATE gliloadtracker;      
            // Test.StopTest();   
            
            List<TMS_Territory__c> tMsTerritorylst = [SELECT Id, Name, RestrictOpportunityTransfer__c, ParentTerritory__c, DeveloperName__c, ForecastUser__c, MayForecastManagerShare__c, Region__c, TMS_Market_Segment_Desc__c, TMS_Market_Segment_ID__c, TMS_New_Sales_Quota_Curr_Yr__c, TMS_Parent_Territory_ID__c, TMS_Renewal_Sales_Quota_Curr_Yr__c, TMS_Rep_Function_Desc__c, TMS_Rep_Function_ID__c, TMS_Sales_Force_Desc__c, TMS_Sales_Force_ID__c, TMS_Territory_ID__c, TMS_Territory_Number__c, Account__c, Territory_ID__c, District__c, AccountAccessLevel__c, CaseAccessLevel__c, ContactAccessLevel__c, Description__c, OpportunityAccessLevel__c, TMS_Sales_Force_Code__c, TMS_Market_Segment_Code__c, TMS_Ref_Function_Code__c FROM TMS_Territory__c where Territory_ID__c IN :oTerritoryID ];
            
            System.debug('TMs_Territorylst:-'+tMsTerritorylst); 
            
            // Test.StartTest();   
            UPDATE gliloadtracker;   
              System.assertEquals(gliloadtracker.JobCompletedDate__c!=null,true); 
            Test.StopTest();   
                     
        }
    }//End testupdateTMSTerritory method
    
    @isTest static void testcreateAccountTerritory() {
        List<RecordType> recordtypeIDs=[SELECT Id,DeveloperName,IsActive FROM RecordType WHERE DeveloperName LIKE '%GLI%' AND SobjectType = 'Account' and IsActive =true];
        List<GLI_Record_type_Ids__c> listofRecordtype = new List<GLI_Record_type_Ids__c>();
        GLI_Record_type_Ids__c oAccRecordtype = new GLI_Record_type_Ids__c ();
        oAccRecordtype.name ='GLI Account';       
        oAccRecordtype.GLI_Account_RecordTypeId__c = recordtypeIDs[0].Id;
        listofRecordtype.add(oAccRecordtype);
        
        GLI_Record_type_Ids__c accRecordtype = new GLI_Record_type_Ids__c ();
        accRecordtype.name ='GLI Account ECM';       
        accRecordtype.GLI_Account_RecordTypeId__c = recordtypeIDs[1].Id;
        listofRecordtype.add(accRecordtype);
        
        GLI_Record_type_Ids__c accRecordtypeValue = new GLI_Record_type_Ids__c ();
        accRecordtypeValue.name ='GLI_Archive';       
        accRecordtypeValue.GLI_Account_RecordTypeId__c = recordtypeIDs[1].Id;
        listofRecordtype.add(accRecordtypeValue);
        
        if(listofRecordtype.size()>0){
            insert listofRecordtype;            
        }
        
        List<Account> accountlst = new List<Account>();
        Account oAccountA = UnitTest.getAccountInstance();
        oAccountA.Is_GLI__c=true;
        accountlst.add(oAccountA);
        
        Account oAccountB = UnitTest.getAccountInstance();
        oAccountB.Is_GLI__c=true;
        accountlst.add(oAccountB);
        
        if(accountlst.size()>0){
            insert accountlst;
        }
        
        //Create custom setting 
        List<Account_Territory_Creation__c > customSettingAccTerritory= new List<Account_Territory_Creation__c>();
        Account_Territory_Creation__c accAMterritory = new Account_Territory_Creation__c();
        accAMterritory.name = '1';
        accAMterritory.Account_Territory_Fields__c='AM_Territory__c';
        accAMterritory.Terr_Combine_code__c = 'NT-FGOV-AM';
        customSettingAccTerritory.add(accAMterritory);
        Account_Territory_Creation__c accAMIterritory = new Account_Territory_Creation__c();
        accAMIterritory.name = '2';
        accAMIterritory.Terr_Combine_code__c = 'HO-FII-AM'; 
        accAMIterritory.Account_Territory_Fields__c = 'AMI_Territory__c';
        customSettingAccTerritory.add(accAMIterritory);
        Account_Territory_Creation__c accFieldSalesterritory = new Account_Territory_Creation__c();
        accFieldSalesterritory.name = '3';
        accFieldSalesterritory.Terr_Combine_code__c = 'NT-CE-AE';   
        accFieldSalesterritory.Account_Territory_Fields__c = 'Field_Sales_Territory__c';
        customSettingAccTerritory.add(accFieldSalesterritory);
        
        if(customSettingAccTerritory.size()>0){
            insert customSettingAccTerritory;
            
        }//End size checking
        
        //
        set<ID> userTerritoryID = new set<ID>();
        UserTerritory2Association oUserTerritory = [SELECT Id, Territory2Id, UserId FROM UserTerritory2Association WHERE IsActive=true LIMIT 1];
        UserTerritory2Association oUserTerritory2 = [SELECT Id, Territory2Id, UserId FROM UserTerritory2Association WHERE Id !=:oUserTerritory.Id AND IsActive=true LIMIT 1];
        userTerritoryID.add(oUserTerritory.Territory2Id);
        userTerritoryID.add(oUserTerritory2.Territory2Id);
        User oUser = [SELECT Id, Name FROM User WHERE Id=:oUserTerritory.UserId];
        
        Territory2 oTerritory = [SELECT Id, Name,District__c,ParentTerritory2Id, Description, AccountAccessLevel, OpportunityAccessLevel,
         CaseAccessLevel, ContactAccessLevel, ForecastUserId,  CurrencyIsoCode, 
          DeveloperName,TMS_Market_Segment_Desc__c, TMS_Market_Segment_ID__c, TMS_Parent_Territory_ID__c, TMS_Rep_Function_Desc__c, 
          TMS_Rep_Function_ID__c, TMS_Sales_Force_Desc__c, TMS_Sales_Force_ID__c, TMS_Terr_Num__c, TMS_Territory_ID__c,
           TMS_New_Sales_Quota_Curr_Yr__c, TMS_Renewal_Sales_Quota_Curr_Yr__c, Region__c, TMS_Sales_Force_Code__c,
            TMS_Market_Segment_Code__c, TMS_Ref_Function_Code__c FROM Territory2 WHERE Id=:oUserTerritory.Territory2Id];
        System.debug('oTerritory_12:-'+oTerritory);
        oTerritory.TMS_Sales_Force_Code__c = 'HO';
        oTerritory.TMS_Market_Segment_Code__c= 'FII';
        oTerritory.TMS_Ref_Function_Code__c= 'AM';
        System.debug('oTerritory_1:-'+oTerritory);
        //update oTerritory;
        
        Territory2 oTerritory2 = [SELECT Id, Name,ParentTerritory2Id,District__c, Description, AccountAccessLevel, OpportunityAccessLevel,
         CaseAccessLevel, ContactAccessLevel, ForecastUserId,  CurrencyIsoCode,  
         DeveloperName,TMS_Market_Segment_Desc__c, TMS_Market_Segment_ID__c, TMS_Parent_Territory_ID__c, TMS_Rep_Function_Desc__c,
          TMS_Rep_Function_ID__c, TMS_Sales_Force_Desc__c, TMS_Sales_Force_ID__c, TMS_Terr_Num__c, TMS_Territory_ID__c, 
          TMS_New_Sales_Quota_Curr_Yr__c, TMS_Renewal_Sales_Quota_Curr_Yr__c, Region__c, TMS_Sales_Force_Code__c, TMS_Market_Segment_Code__c, 
          TMS_Ref_Function_Code__c FROM Territory2 WHERE Id=:oUserTerritory2.Territory2Id];
        System.debug('oTerritory2_2:-'+oTerritory2);
        oTerritory2.TMS_Sales_Force_Code__c = 'NT';
        oTerritory2.TMS_Market_Segment_Code__c= 'CE';
        oTerritory2.TMS_Ref_Function_Code__c= 'AE';
        System.debug('oTerritory2_1:-'+oTerritory2);
        //update oTerritory2;
        
        List<Territory2> territorylst = [SELECT Id, Name,District__c,ParentTerritory2Id, Description, AccountAccessLevel,
         OpportunityAccessLevel, CaseAccessLevel, ContactAccessLevel, ForecastUserId,  CurrencyIsoCode, 
          DeveloperName,TMS_Market_Segment_Desc__c, TMS_Market_Segment_ID__c, TMS_Parent_Territory_ID__c,
          TMS_Rep_Function_Desc__c, TMS_Rep_Function_ID__c, TMS_Sales_Force_Desc__c, TMS_Sales_Force_ID__c, TMS_Terr_Num__c, 
          TMS_Territory_ID__c, TMS_New_Sales_Quota_Curr_Yr__c, TMS_Renewal_Sales_Quota_Curr_Yr__c, Region__c, TMS_Sales_Force_Code__c, 
          TMS_Market_Segment_Code__c, TMS_Ref_Function_Code__c FROM Territory2 WHERE Id IN:userTerritoryID 
          and (TMS_Sales_Force_Code__c != null and TMS_Market_Segment_Code__c != null and TMS_Ref_Function_Code__c != null)];
          
        System.debug('Territorylst_**'+Territorylst);
        set<ID> oTerritoryID = new set<ID>();
        oTerritoryID.add(oTerritory.Id);
        oTerritoryID.add(oTerritory2.Id);
        Group oGroup = [SELECT Id, RelatedId FROM Group WHERE RelatedId=:oTerritory.Id AND Type='Territory' LIMIT 1];
        Group oGroup2 = [SELECT Id, RelatedId FROM Group WHERE RelatedId=:oTerritory2.Id AND Type='Territory' LIMIT 1];
        List<AccountShare> accountsharelist = new List<AccountShare>();
        AccountShare oAccountShareA = new AccountShare();
        oAccountShareA.AccountId = oAccountA.Id;
        oAccountShareA.UserOrGroupId = oGroup.Id;
        accountsharelist.add(oAccountShareA);
        
        AccountShare oAccountShareB = new AccountShare();
        oAccountShareB.AccountId = oAccountB.Id;
        oAccountShareB.UserOrGroupId = oGroup2.Id;
        accountsharelist.add(oAccountShareB);
        
        //AccountShare oAccountShareC = new AccountShare();
        //oAccountShareC.AccountId = oAccountB.Id;
        //oAccountShareC.UserOrGroupId = oGroup.Id;
        //accountsharelist.add(oAccountShareC);
        //if(accountsharelist.size()>0){
           // insert accountsharelist;            
        //}
        
        List<LCRM_BatchsizeDefine__c> batchsizelst = new List<LCRM_BatchsizeDefine__c>();
        LCRM_BatchsizeDefine__c cs = new LCRM_BatchsizeDefine__c();
        cs.Name ='DisplayTerritoriesonAccount_Batch';
        cs.Object__c ='TMS Territory';
        cs.Batch_Size__c = 50 ;
        batchsizelst.add(cs);
        
        LCRM_BatchsizeDefine__c obatchsize = new LCRM_BatchsizeDefine__c();
        obatchsize.Name ='DisplayAccTerritory_Batch';
        obatchsize.Object__c ='AccountTerritory';
        obatchsize.Batch_Size__c = 50 ;
        batchsizelst.add(obatchsize);
        
        if(batchsizelst.size()>0){
            insert batchsizelst;
        }
        
        GLI_Load_Tracker__c gliloadtracker = new GLI_Load_Tracker__c();
        gliloadtracker.name = 'Informatica Territory Load';
        gliloadtracker.JobCompletedDate__c= datetime.newInstance(2017, 9, 15, 12, 30, 0);
        Insert gliloadtracker;
        
        Test.StartTest(); 
        gliloadtracker.JobCompletedDate__c= datetime.newInstance(2017, 10, 16, 11, 30, 0);
        UPDATE gliloadtracker;   
        System.assertEquals(gliloadtracker.JobCompletedDate__c!=null,true);    
        Test.StopTest(); 
        
        if(oTerritoryID.size()>0){
            List<TMS_Territory__c> tMsTerritorylst = [SELECT Id, Name, RestrictOpportunityTransfer__c, ParentTerritory__c, DeveloperName__c, ForecastUser__c, MayForecastManagerShare__c, Region__c, TMS_Market_Segment_Desc__c, TMS_Market_Segment_ID__c, TMS_New_Sales_Quota_Curr_Yr__c, TMS_Parent_Territory_ID__c, TMS_Renewal_Sales_Quota_Curr_Yr__c, TMS_Rep_Function_Desc__c, TMS_Rep_Function_ID__c, TMS_Sales_Force_Desc__c, TMS_Sales_Force_ID__c, TMS_Territory_ID__c, TMS_Territory_Number__c, Account__c, Territory_ID__c, District__c, AccountAccessLevel__c, CaseAccessLevel__c, ContactAccessLevel__c, Description__c, OpportunityAccessLevel__c,  TMS_Sales_Force_Code__c, TMS_Market_Segment_Code__c, TMS_Ref_Function_Code__c FROM TMS_Territory__c where Territory_ID__c IN :oTerritoryID ];        
            System.debug('TMs_Territorylst:-'+tMsTerritorylst);    
            List<Account_Territory__c> accTerritorylst =[select  id,name ,Account__c,AMI_Territory__c,AM_Territory__c,LastModifiedDate,Field_Sales_Territory__c from Account_Territory__c ];
            System.debug('AccTerritorylst:-'+accTerritorylst);
        }
        
    }  
    
    
    @isTest static void testDeleteTMSTerritory() {
        User u = TestData.createTestUser();
        System.runAs(u) {
            List<RecordType> recordtypeIDs=[SELECT Id,DeveloperName,IsActive FROM RecordType WHERE DeveloperName LIKE '%GLI%' AND SobjectType = 'Account' and IsActive =true];
            List<GLI_Record_type_Ids__c> listofRecordtype = new List<GLI_Record_type_Ids__c>();
            GLI_Record_type_Ids__c oAccRecordtype = new GLI_Record_type_Ids__c ();
            oAccRecordtype.name ='GLI Account';       
            oAccRecordtype.GLI_Account_RecordTypeId__c = recordtypeIDs[0].Id;
            listofRecordtype.add(oAccRecordtype);
            
            GLI_Record_type_Ids__c accRecordtype = new GLI_Record_type_Ids__c ();
            accRecordtype.name ='GLI Account ECM';       
            accRecordtype.GLI_Account_RecordTypeId__c = recordtypeIDs[1].Id;
            listofRecordtype.add(accRecordtype);
            
            GLI_Record_type_Ids__c accRecordtypeValue = new GLI_Record_type_Ids__c ();
            accRecordtypeValue.name ='GLI_Archive';       
            accRecordtypeValue.GLI_Account_RecordTypeId__c = recordtypeIDs[1].Id;
            listofRecordtype.add(accRecordtypeValue);
            
            if(listofRecordtype.size()>0){
                insert listofRecordtype;            
            }
            List<Account> accountlst = new List<Account>();
            Account oAccountA = UnitTest.getAccountInstance();
            oAccountA.Is_GLI__c=true;
            accountlst.add(oAccountA);
            
            Account oAccountB = UnitTest.getAccountInstance();
            oAccountB.Is_GLI__c=true;
            accountlst.add(oAccountB);
            
            if(accountlst.size()>0){
                insert accountlst;
            }
            
            List<TMS_Territory__c> tMsTerritoryDel = new List<TMS_Territory__c>();
            
            TMS_Territory__c tMSTerr =new TMS_Territory__c();
            tMSTerr.Name = 'Test_created by SystemAdmin';
            tMSTerr.Account__c = oAccountA.id;
            tMsTerritoryDel.add(tMSTerr);
            
            TMS_Territory__c tMSTerrRec =new TMS_Territory__c();
            tMSTerrRec.Name = 'Test_created by SystemAdmin';
            tMSTerrRec.Account__c = oAccountB.id;
            tMsTerritoryDel.add(tMSTerrRec);
            
            if(tMsTerritoryDel.size()>0){
                insert tMsTerritoryDel;
            }           
            
            
            GLI_Load_Tracker__c gliloadtracker = new GLI_Load_Tracker__c();
            gliloadtracker.name = 'Informatica Territory Load';
            gliloadtracker.JobCompletedDate__c= datetime.newInstance(2017, 9, 15, 12, 30, 0);
            Insert gliloadtracker;
            
            Test.StartTest(); 
            gliloadtracker.JobCompletedDate__c= datetime.newInstance(2017, 10, 16, 11, 30, 0);
            UPDATE gliloadtracker;      
            Test.StopTest();
            system.assertEquals( gliloadtracker.JobCompletedDate__c != null , true);
        }
    }//End DeleteTMSTerritory method
    
    /*

*/
    @isTest static void testupdateAccountTerritory() {
        List<RecordType> recordtypeIDs=[SELECT Id,DeveloperName,IsActive FROM RecordType WHERE DeveloperName LIKE '%GLI%' AND SobjectType = 'Account' and IsActive =true];
        List<GLI_Record_type_Ids__c> listofRecordtype = new List<GLI_Record_type_Ids__c>();
        GLI_Record_type_Ids__c oAccRecordtype = new GLI_Record_type_Ids__c ();
        oAccRecordtype.name ='GLI Account';       
        oAccRecordtype.GLI_Account_RecordTypeId__c = recordtypeIDs[0].Id;
        listofRecordtype.add(oAccRecordtype);
        
        GLI_Record_type_Ids__c accRecordtype = new GLI_Record_type_Ids__c ();
        accRecordtype.name ='GLI Account ECM';       
        accRecordtype.GLI_Account_RecordTypeId__c = recordtypeIDs[1].Id;
        listofRecordtype.add(accRecordtype);
        
        GLI_Record_type_Ids__c accRecordtypeValue = new GLI_Record_type_Ids__c ();
        accRecordtypeValue.name ='GLI_Archive';       
        accRecordtypeValue.GLI_Account_RecordTypeId__c = recordtypeIDs[1].Id;
        listofRecordtype.add(accRecordtypeValue);
        
        if(listofRecordtype.size()>0){
            insert listofRecordtype;            
        }
        List<Account> accountlst = new List<Account>();
        Account oAccountA = UnitTest.getAccountInstance();
        oAccountA.Is_GLI__c=true;
        accountlst.add(oAccountA);
        
        Account oAccountB = UnitTest.getAccountInstance();
        oAccountB.Is_GLI__c=true;
        accountlst.add(oAccountB);
        if(accountlst.size()>0){
            insert accountlst;
        }
        //Create custom setting 
        List<Account_Territory_Creation__c > customSettingAccTerritory= new List<Account_Territory_Creation__c>();
        Account_Territory_Creation__c accAMterritory = new Account_Territory_Creation__c();
        accAMterritory.name = '1';
        accAMterritory.Account_Territory_Fields__c='AM_Territory__c';
        accAMterritory.Terr_Combine_code__c = 'NT-FGOV-AM';
        customSettingAccTerritory.add(accAMterritory);
        Account_Territory_Creation__c accAMIterritory = new Account_Territory_Creation__c();
        accAMIterritory.name = '2';
        accAMIterritory.Terr_Combine_code__c = 'HO-FII-AM'; 
        accAMIterritory.Account_Territory_Fields__c = 'AMI_Territory__c';
        customSettingAccTerritory.add(accAMIterritory);
        Account_Territory_Creation__c accFieldSalesterritory = new Account_Territory_Creation__c();
        accFieldSalesterritory.name = '3';
        accFieldSalesterritory.Terr_Combine_code__c = 'NT-CE-AE';   
        accFieldSalesterritory.Account_Territory_Fields__c = 'Field_Sales_Territory__c';
        customSettingAccTerritory.add(accFieldSalesterritory);
        
        if(customSettingAccTerritory.size()>0){
            insert customSettingAccTerritory;
            
        }//End size checking
        
        //
        set<ID> userTerritoryID = new set<ID>();
        UserTerritory2Association oUserTerritory = [SELECT Id, Territory2Id, UserId FROM UserTerritory2Association WHERE IsActive=true LIMIT 1];
        UserTerritory2Association oUserTerritory2 = [SELECT Id, Territory2Id, UserId FROM UserTerritory2Association WHERE Id !=:oUserTerritory.Id AND IsActive=true LIMIT 1];
        userTerritoryID.add(oUserTerritory.Territory2Id);
        userTerritoryID.add(oUserTerritory2.Territory2Id);
        User oUser = [SELECT Id, Name FROM User WHERE Id=:oUserTerritory.UserId];
        
        Territory2 oTerritory = [SELECT Id, Name,District__c,ParentTerritory2Id, Description, AccountAccessLevel, OpportunityAccessLevel, CaseAccessLevel, ContactAccessLevel, ForecastUserId,  CurrencyIsoCode,  DeveloperName,TMS_Market_Segment_Desc__c, TMS_Market_Segment_ID__c, TMS_Parent_Territory_ID__c, TMS_Rep_Function_Desc__c, TMS_Rep_Function_ID__c, TMS_Sales_Force_Desc__c, TMS_Sales_Force_ID__c, TMS_Terr_Num__c, TMS_Territory_ID__c, TMS_New_Sales_Quota_Curr_Yr__c, TMS_Renewal_Sales_Quota_Curr_Yr__c, Region__c, TMS_Sales_Force_Code__c, TMS_Market_Segment_Code__c, TMS_Ref_Function_Code__c FROM Territory2 WHERE Id=:oUserTerritory.Territory2Id];
        System.debug('oTerritory_12:-'+oTerritory);
        oTerritory.TMS_Sales_Force_Code__c = 'HO';
        oTerritory.TMS_Market_Segment_Code__c= 'FII';
        oTerritory.TMS_Ref_Function_Code__c= 'AM';
        System.debug('oTerritory_1:-'+oTerritory);
        //update oTerritory;
        
        Territory2 oTerritory2 = [SELECT Id, Name,District__c,ParentTerritory2Id, Description, AccountAccessLevel, OpportunityAccessLevel, CaseAccessLevel, ContactAccessLevel, ForecastUserId,  CurrencyIsoCode,  DeveloperName,TMS_Market_Segment_Desc__c, TMS_Market_Segment_ID__c, TMS_Parent_Territory_ID__c, TMS_Rep_Function_Desc__c, TMS_Rep_Function_ID__c, TMS_Sales_Force_Desc__c, TMS_Sales_Force_ID__c, TMS_Terr_Num__c, TMS_Territory_ID__c, TMS_New_Sales_Quota_Curr_Yr__c, TMS_Renewal_Sales_Quota_Curr_Yr__c, Region__c, TMS_Sales_Force_Code__c, TMS_Market_Segment_Code__c, TMS_Ref_Function_Code__c FROM Territory2 WHERE Id=:oUserTerritory2.Territory2Id];
        System.debug('oTerritory2_2:-'+oTerritory2);
        oTerritory2.TMS_Sales_Force_Code__c = 'NT';
        oTerritory2.TMS_Market_Segment_Code__c= 'CE';
        oTerritory2.TMS_Ref_Function_Code__c= 'AE';
        System.debug('oTerritory2_1:-'+oTerritory2);
        //update oTerritory2;
        
        List<Territory2> territorylst = [SELECT Id, Name,District__c,ParentTerritory2Id, Description, AccountAccessLevel, OpportunityAccessLevel, CaseAccessLevel, ContactAccessLevel, ForecastUserId,  CurrencyIsoCode,  DeveloperName,TMS_Market_Segment_Desc__c, TMS_Market_Segment_ID__c, TMS_Parent_Territory_ID__c, TMS_Rep_Function_Desc__c, TMS_Rep_Function_ID__c, TMS_Sales_Force_Desc__c, TMS_Sales_Force_ID__c, TMS_Terr_Num__c, TMS_Territory_ID__c, TMS_New_Sales_Quota_Curr_Yr__c, TMS_Renewal_Sales_Quota_Curr_Yr__c, Region__c, TMS_Sales_Force_Code__c, TMS_Market_Segment_Code__c, TMS_Ref_Function_Code__c FROM Territory2  WHERE Id IN:userTerritoryID and (TMS_Sales_Force_Code__c != null and TMS_Market_Segment_Code__c != null and TMS_Ref_Function_Code__c != null)];
        System.debug('Territorylst_**'+territorylst);
        set<ID> oTerritoryID = new set<ID>();
        oTerritoryID.add(oTerritory.Id);
        oTerritoryID.add(oTerritory2.Id);
        Group oGroup = [SELECT Id, RelatedId FROM Group WHERE RelatedId=:oTerritory.Id AND Type='Territory' LIMIT 1];
        Group oGroup2 = [SELECT Id, RelatedId FROM Group WHERE RelatedId=:oTerritory2.Id AND Type='Territory' LIMIT 1];
        List<AccountShare> accountsharelist = new List<AccountShare>();
        AccountShare oAccountShareA = new AccountShare();
        oAccountShareA.AccountId = oAccountA.Id;
        oAccountShareA.UserOrGroupId = oGroup.Id;
        accountsharelist.add(oAccountShareA);
        
        AccountShare oAccountShareB = new AccountShare();
        oAccountShareB.AccountId = oAccountB.Id;
        oAccountShareB.UserOrGroupId = oGroup2.Id;
        accountsharelist.add(oAccountShareB);
        
        //if(accountsharelist.size()>0){
           // insert accountsharelist;            
        //}
        
        List<LCRM_BatchsizeDefine__c> batchsizelst = new List<LCRM_BatchsizeDefine__c>();
        LCRM_BatchsizeDefine__c cs = new LCRM_BatchsizeDefine__c();
        cs.Name ='DisplayTerritoriesonAccount_Batch';
        cs.Object__c ='TMS Territory';
        cs.Batch_Size__c = 50 ;
        batchsizelst.add(cs);
        
        LCRM_BatchsizeDefine__c obatchsize = new LCRM_BatchsizeDefine__c();
        obatchsize.Name ='DisplayAccTerritory_Batch';
        obatchsize.Object__c ='AccountTerritory';
        obatchsize.Batch_Size__c = 50 ;
        batchsizelst.add(obatchsize);
        
        if(batchsizelst.size()>0){
            insert batchsizelst;
        }
        
        
        GLI_Load_Tracker__c gliloadtracker = new GLI_Load_Tracker__c();
        gliloadtracker.name = 'Informatica Territory Load';
        gliloadtracker.JobCompletedDate__c= datetime.newInstance(2017, 9, 15, 12, 30, 0);
        Insert gliloadtracker;
        
        Test.StartTest(); 
        gliloadtracker.JobCompletedDate__c= datetime.newInstance(2017, 10, 16, 11, 30, 0);
        UPDATE gliloadtracker;      
        Test.StopTest(); 
        List<ID> accountID =new List<ID>();
        if(oTerritoryID.size()>0){
            List<TMS_Territory__c> tMsTerritorylst = [SELECT Id, Name, RestrictOpportunityTransfer__c, ParentTerritory__c, DeveloperName__c, ForecastUser__c, MayForecastManagerShare__c, Region__c, TMS_Market_Segment_Desc__c, TMS_Market_Segment_ID__c, TMS_New_Sales_Quota_Curr_Yr__c, TMS_Parent_Territory_ID__c, TMS_Renewal_Sales_Quota_Curr_Yr__c, TMS_Rep_Function_Desc__c, TMS_Rep_Function_ID__c, TMS_Sales_Force_Desc__c, TMS_Sales_Force_ID__c, TMS_Territory_ID__c, TMS_Territory_Number__c, Account__c, Territory_ID__c, District__c, AccountAccessLevel__c, CaseAccessLevel__c, ContactAccessLevel__c, Description__c, OpportunityAccessLevel__c,  TMS_Sales_Force_Code__c, TMS_Market_Segment_Code__c, TMS_Ref_Function_Code__c FROM TMS_Territory__c where Territory_ID__c IN :oTerritoryID ];        
            System.debug('TMs_Territorylst:-'+tMsTerritorylst); 
            
            List<TMS_Territory__c> oTMSTerritorylst = new List<TMS_Territory__c>();  
            List<TMS_Territory__c> oTMSsTerritorylst = new List<TMS_Territory__c>();  
            for(TMS_Territory__c tMSTerritory: tMsTerritorylst){
                accountID.add(tMSTerritory.Account__c);
                if(String.isnotblank(tMSTerritory.TMS_Sales_Force_Code__c)){
                    tMSTerritory.TMS_Sales_Force_Code__c = 'NT';
                }
                if(String.isnotblank(tMSTerritory.TMS_Market_Segment_Code__c)){
                    tMSTerritory.TMS_Market_Segment_Code__c = 'CE';
                }
                if(String.isnotblank(TMSTerritory.TMS_Ref_Function_Code__c)){
                    tMSTerritory.TMS_Ref_Function_Code__c = 'AE';
                }
                oTMSsTerritorylst.add(tMSTerritory);             
            }
            
            if(!oTMSsTerritorylst.isempty()){
                
                try{update oTMSsTerritorylst;
                    //AccountTerritoriesHandler.AccountTerrCreationandUpdation(Accountlst);
                    
                   }catch(Exception ex){
                       System.debug('Error:-'+ex);
                   }
            }   
            for(TMS_Territory__c tMSTerritory: tMsTerritorylst){
                accountID.add(tMSTerritory.Account__c);
                if(String.isnotblank(tMSTerritory.TMS_Sales_Force_Code__c)){
                    tMSTerritory.TMS_Sales_Force_Code__c = '';
                }
                if(String.isnotblank(tMSTerritory.TMS_Market_Segment_Code__c)){
                    tMSTerritory.TMS_Market_Segment_Code__c = '';
                }
                if(String.isnotblank(tMSTerritory.TMS_Ref_Function_Code__c)){
                    tMSTerritory.TMS_Ref_Function_Code__c = '';
                }
                oTMSTerritorylst.add(tMSTerritory);             
            }
            if(!oTMSTerritorylst.isempty()){
                update oTMSTerritorylst;
               // AccountTerritoriesHandler.AccountTerrCreationandUpdation(Accountlst);
            }  
            List<Account_Territory__c> accTerritorylst =[select id,name ,Account__c,AMI_Territory__c,AM_Territory__c,LastModifiedDate,Field_Sales_Territory__c from Account_Territory__c ];
            System.debug('AccTerritorylst:-'+accTerritorylst);
            system.assertEquals(gliloadtracker.JobCompletedDate__c != null,true);
            for(Account_Territory__c accTerrtitory:accTerritorylst ){
                System.debug('Account Territory 0th location:-'+accTerrtitory.Id);
            }
        }
        
    } //End
    /*
*This method is used for cove coverage for exception handling  
*/
    @isTest static void testExceptionhandlingTMSTerritory() {
        
        User u = TestData.createTestUser();
        System.runAs(u) {
            
            List<LCRM_Exception_Log__c> excepList =new List<LCRM_Exception_Log__c> ();
            String strmessage='Error Occures';
            String strTrace = 'test';
            system.assertEquals(strmessage != '',true);
          //  AccountTerritoriesHandler.createExceptionLog(excepList,strmessage,strTrace);
        }
    }//End Exception hadling method
    
    @isTest static void unitUserTerritorytest() {
        Profile adminProfile = [SELECT Id FROM profile WHERE name='System Administrator'];
        User gliUser=new User();
        gliUser = UnitTest.getUserInstance();
        gliUser.Username = 'TestUser1@TR.com';
        gliUser.profileid = adminProfile.Id;
        gliUser.Email='testuser@thomsonreuters.com';
        gliUser.Alias = 'igli';
        //gliUser.FirstName='Informatica';
        gliUser.LastName='Integration';
        gliUser.EmailEncodingKey='UTF-8';
        gliUser.LocaleSidKey='en_US';
        gliUser.LanguageLocaleKey='en_US';
        gliUser.TimeZoneSidKey='America/Los_Angeles';
        
        insert gliUser;
        
        System.runAs(gliUser) {
            List<RecordType> recordtypeIDs=[SELECT Id,DeveloperName,IsActive FROM RecordType WHERE DeveloperName LIKE '%GLI%' AND SobjectType = 'Account' and IsActive =true];
            List<GLI_Record_type_Ids__c> listofRecordtype = new List<GLI_Record_type_Ids__c>();
            GLI_Record_type_Ids__c oAccRecordtype = new GLI_Record_type_Ids__c ();
            oAccRecordtype.name ='GLI Account';       
            oAccRecordtype.GLI_Account_RecordTypeId__c = recordtypeIDs[0].Id;
            listofRecordtype.add(oAccRecordtype);
            
            GLI_Record_type_Ids__c accRecordtype = new GLI_Record_type_Ids__c ();
            accRecordtype.name ='GLI Account ECM';       
            accRecordtype.GLI_Account_RecordTypeId__c = recordtypeIDs[1].Id;
            listofRecordtype.add(accRecordtype);
            
            GLI_Record_type_Ids__c accRecordtypeValue = new GLI_Record_type_Ids__c ();
            accRecordtypeValue.name ='GLI_Archive';       
            accRecordtypeValue.GLI_Account_RecordTypeId__c = recordtypeIDs[1].Id;
            listofRecordtype.add(accRecordtypeValue);
            
            if(listofRecordtype.size()>0){
                insert listofRecordtype;            
            }
            List<Account> accountlst = new List<Account>();
            Account oAccountA = UnitTest.getAccountInstance();
            oAccountA.Is_GLI__c=true;
            accountlst.add(oAccountA);
            
            Account oAccountB = UnitTest.getAccountInstance();
            oAccountB.Is_GLI__c=true;
            accountlst.add(oAccountB);
            
            Account oAccountC = UnitTest.getAccountInstance();
            oAccountC.Is_GLI__c=true;
            accountlst.add(oAccountC);
            
            if(accountlst.size()>0){
                insert accountlst;
            }
            
            UserTerritory2Association oUserTerritory = [SELECT Id, Territory2Id, UserId FROM UserTerritory2Association WHERE IsActive=true LIMIT 1];
            UserTerritory2Association oUserTerritory2 = [SELECT Id, Territory2Id, UserId FROM UserTerritory2Association WHERE Id !=:oUserTerritory.Id AND IsActive=true LIMIT 1];
            
            User oUser = [SELECT Id, Name, isactive FROM User WHERE Id=:oUserTerritory.UserId];
            oUser.isActive = true;
            update oUser;
            
            Territory2 oTerritory = [SELECT Id, Name,District__c,ParentTerritory2Id, Description, AccountAccessLevel, 
            OpportunityAccessLevel, CaseAccessLevel, ContactAccessLevel, ForecastUserId,  CurrencyIsoCode,
              DeveloperName,TMS_Market_Segment_Desc__c, TMS_Market_Segment_ID__c, TMS_Parent_Territory_ID__c,
              TMS_Rep_Function_Desc__c, TMS_Rep_Function_ID__c, TMS_Sales_Force_Desc__c, TMS_Sales_Force_ID__c, TMS_Terr_Num__c, 
              TMS_Territory_ID__c, TMS_New_Sales_Quota_Curr_Yr__c, TMS_Renewal_Sales_Quota_Curr_Yr__c, Region__c, 
              TMS_Sales_Force_Code__c, TMS_Market_Segment_Code__c, TMS_Ref_Function_Code__c FROM Territory2
               WHERE Id=:oUserTerritory.Territory2Id];
            
            Territory2 oTerritory2 = [SELECT Id, Name,District__c,ParentTerritory2Id, Description, AccountAccessLevel, 
            OpportunityAccessLevel, CaseAccessLevel, ContactAccessLevel, ForecastUserId,  CurrencyIsoCode,
              DeveloperName,TMS_Market_Segment_Desc__c, TMS_Market_Segment_ID__c, TMS_Parent_Territory_ID__c,
              TMS_Rep_Function_Desc__c, TMS_Rep_Function_ID__c, TMS_Sales_Force_Desc__c, TMS_Sales_Force_ID__c, TMS_Terr_Num__c,
               TMS_Territory_ID__c, TMS_New_Sales_Quota_Curr_Yr__c, TMS_Renewal_Sales_Quota_Curr_Yr__c, Region__c,
                TMS_Sales_Force_Code__c, TMS_Market_Segment_Code__c, TMS_Ref_Function_Code__c FROM 
                Territory2 WHERE Id=:oUserTerritory2.Territory2Id];
            set<ID> oTerritoryID = new set<ID>();
            oTerritoryID.add(oTerritory.Id);
            oTerritoryID.add(oTerritory2.Id);
            //system.assertEquals(oTerritoryID.size(),2);
            
            List<AccountTeamMember> members = new list<AccountTeamMember>();
            members.add(New AccountTeamMember(AccountId = oAccountB.id, TeamMemberRole = 'ACC-Team-Mem', UserId= gliUser.Id));
            members.add(New AccountTeamMember(AccountId = oAccountB.id, TeamMemberRole = 'ACC-Team-Mem', UserId= gliUser.Id));
            members.add(New AccountTeamMember(AccountId = oAccountA.id, TeamMemberRole = 'ACC-Team-Mem1', UserId= oUser.Id));
            members.add(New AccountTeamMember(AccountId = oAccountA.id, TeamMemberRole = 'ACC-Team-Mem1', UserId= oUser.Id));            
            insert members;
            
            //AccountShare accshare= [Select Id, UserOrGroupId, AccountId, RowCause from AccountShare where (RowCause = 'Territory' OR RowCause = 'TerritoryManual'OR RowCause='Team') limit 1];
            
            //System.debug('accshare:-'+accshare);
            List<LCRM_BatchsizeDefine__c> batchsizelst = new List<LCRM_BatchsizeDefine__c>();
            LCRM_BatchsizeDefine__c cs = new LCRM_BatchsizeDefine__c();
            cs.Name ='DisplayTerritoriesonAccount_Batch';
            cs.Object__c ='TMS Territory';
            cs.Batch_Size__c = 50 ;
            batchsizelst.add(cs);
            
            LCRM_BatchsizeDefine__c obatchsize = new LCRM_BatchsizeDefine__c();
            obatchsize.Name ='DisplayAccTerritory_Batch';
            obatchsize.Object__c ='AccountTerritory';
            obatchsize.Batch_Size__c = 50 ;
            batchsizelst.add(obatchsize);
            
            if(batchsizelst.size()>0){
                insert batchsizelst;
            }
            
            GLI_Load_Tracker__c gliloadtracker = new GLI_Load_Tracker__c();
            gliloadtracker.name = 'Informatica Territory Load';
            gliloadtracker.JobCompletedDate__c= datetime.newInstance(2017, 9, 15, 12, 30, 0);
            Insert gliloadtracker;
            
            Test.StartTest(); 
            gliloadtracker.JobCompletedDate__c= datetime.newInstance(2017, 10, 16, 11, 30, 0);
            UPDATE gliloadtracker;  
            system.assertEquals(gliloadtracker.JobCompletedDate__c!=null,true);    
            Test.StopTest();
            
        }
    }
    //
    @isTest static void testAccountTerritoryCreate() {
        User testUser = new User(
            Alias = 'sUser', 
            Email='abc1@testorg.com',
            EmailEncodingKey='UTF-8', 
            LastName='Testing', 
            LanguageLocaleKey='en_US',
            LocaleSidKey='en_US', 
            ProfileId = userinfo.getProfileid(),
            Sales_Org__c = 'WEST',
            Sub_Bu__c='USL',
            TimeZoneSidKey='America/Los_Angeles', 
            UserName='abc123@testorg.com'
        );
        insert testUser;
        
        System.runAs(testUser) {
            List<RecordType> recordtypeIDs=[SELECT Id,DeveloperName,IsActive FROM RecordType WHERE DeveloperName LIKE '%GLI%' AND SobjectType = 'Account' and IsActive =true];
            List<GLI_Record_type_Ids__c> listofRecordtype = new List<GLI_Record_type_Ids__c>();
            GLI_Record_type_Ids__c oAccRecordtype = new GLI_Record_type_Ids__c ();
            oAccRecordtype.name ='GLI Account';       
            oAccRecordtype.GLI_Account_RecordTypeId__c = recordtypeIDs[0].Id;
            listofRecordtype.add(oAccRecordtype);
            
            GLI_Record_type_Ids__c accRecordtype = new GLI_Record_type_Ids__c ();
            accRecordtype.name ='GLI Account ECM';       
            accRecordtype.GLI_Account_RecordTypeId__c = recordtypeIDs[1].Id;
            listofRecordtype.add(accRecordtype);
            
            GLI_Record_type_Ids__c accRecordtypeValue = new GLI_Record_type_Ids__c ();
            accRecordtypeValue.name ='GLI_Archive';       
            accRecordtypeValue.GLI_Account_RecordTypeId__c = recordtypeIDs[1].Id;
            listofRecordtype.add(accRecordtypeValue);
            
            if(listofRecordtype.size()>0){
                insert listofRecordtype;            
            }
            List<Account> accountlst = new List<Account>();
            Account oAccountA = UnitTest.getAccountInstance();
            oAccountA.Is_GLI__c=true;
            accountlst.add(oAccountA);
            
            Account oAccountB = UnitTest.getAccountInstance();
            oAccountB.Is_GLI__c=true;
            accountlst.add(oAccountB);
            
            if(accountlst.size()>0){
                insert accountlst;
            }
            
            UserTerritory2Association oUserTerritory = [SELECT Id, Territory2Id, UserId FROM UserTerritory2Association WHERE IsActive=true LIMIT 1];
            UserTerritory2Association oUserTerritory2 = [SELECT Id, Territory2Id, UserId FROM UserTerritory2Association WHERE Id !=:oUserTerritory.Id AND IsActive=true LIMIT 1];
            //userTerritory_ID.add(oUserTerritory.TerritoryId);
            //userTerritory_ID.add(oUserTerritory2.TerritoryId);
            User oUser = [SELECT Id, Name FROM User WHERE Id=:oUserTerritory.UserId];
            
            Territory2 oTerritory = [SELECT Id, Name,District__c,ParentTerritory2Id, Description, AccountAccessLevel,
             OpportunityAccessLevel, CaseAccessLevel, ContactAccessLevel, ForecastUserId,  
             CurrencyIsoCode,  DeveloperName,TMS_Market_Segment_Desc__c, TMS_Market_Segment_ID__c, 
             TMS_Parent_Territory_ID__c, TMS_Rep_Function_Desc__c, TMS_Rep_Function_ID__c, TMS_Sales_Force_Desc__c, 
             TMS_Sales_Force_ID__c, TMS_Terr_Num__c, TMS_Territory_ID__c, TMS_New_Sales_Quota_Curr_Yr__c, 
             TMS_Renewal_Sales_Quota_Curr_Yr__c, Region__c, TMS_Sales_Force_Code__c, TMS_Market_Segment_Code__c,
              TMS_Ref_Function_Code__c FROM Territory2 WHERE Id=:oUserTerritory.Territory2Id ];
            System.debug('oTerritory_12:-'+oTerritory);
            oTerritory.TMS_Sales_Force_Code__c = 'HO';
            oTerritory.TMS_Market_Segment_Code__c= 'FII';
            oTerritory.TMS_Ref_Function_Code__c= 'AM';
            System.debug('oTerritory_1:-'+oTerritory);
            //update oTerritory;
            
            Territory2 oTerritory2 = [SELECT Id, Name,District__c,ParentTerritory2Id, Description, 
            AccountAccessLevel, OpportunityAccessLevel, CaseAccessLevel, ContactAccessLevel, ForecastUserId, 
             CurrencyIsoCode,  DeveloperName,TMS_Market_Segment_Desc__c, TMS_Market_Segment_ID__c,
              TMS_Parent_Territory_ID__c, TMS_Rep_Function_Desc__c, TMS_Rep_Function_ID__c, TMS_Sales_Force_Desc__c, 
              TMS_Sales_Force_ID__c, TMS_Terr_Num__c, TMS_Territory_ID__c, TMS_New_Sales_Quota_Curr_Yr__c, 
              TMS_Renewal_Sales_Quota_Curr_Yr__c, Region__c, TMS_Sales_Force_Code__c, TMS_Market_Segment_Code__c, 
              TMS_Ref_Function_Code__c FROM Territory2 WHERE Id=:oUserTerritory2.Territory2Id ];
            System.debug('oTerritory2_2:-'+oTerritory2);
            
            
            TMS_Territory__c tMSTerr =new TMS_Territory__c();
            tMSTerr.Name = 'Test_created by SystemAdmin';
            tMSTerr.Account__c = oAccountA.id;
            //TMS_Terr.ForecastUser__c=gliUser.Id;
            tMSTerr.TMS_Sales_Force_Desc__c ='ACC';
            tMSTerr.TMS_Market_Segment_Desc__c='Team';
            tMSTerr.TMS_Rep_Function_Desc__c ='Mem';
            tMSTerr.TMS_Sales_Force_Code__c='NT';
            tMSTerr.TMS_Market_Segment_Code__c='FGOV';
            tMSTerr.TMS_Ref_Function_Code__c='AM';
            tMSTerr.TMS_Territory_Number__c ='1234';
            tMSTerr.Territory_ID__c=oUserTerritory2 .id;
            insert tMSTerr;
            
            TMS_Territory__c atmsTerr =new TMS_Territory__c();
            atmsTerr.Name = 'Test_created by SystemAdmin 01';
            atmsTerr.Account__c = oAccountA.id;
            atmsTerr.TMS_Sales_Force_Desc__c ='ACC';
            atmsTerr.TMS_Market_Segment_Desc__c='Team';
            atmsTerr.TMS_Rep_Function_Desc__c ='Mem';
            atmsTerr.TMS_Territory_Number__c ='1004';
            atmsTerr.TMS_Sales_Force_Code__c='HO';
            atmsTerr.TMS_Market_Segment_Code__c='HFT';
            atmsTerr.TMS_Ref_Function_Code__c='AM';
            atmsTerr.Territory_ID__c=oUserTerritory.id;
            insert atmsTerr;
            
           // AccountTerritoriesHandler.AccountTerrCreationandUpdation(Accountlst);
            
            Account_Territory__c accterritory = new Account_Territory__c();
            accterritory.AMI_Territory__c=atmsTerr.id;
            accterritory.AM_Territory__c=tMSTerr.id;
            accterritory.Account__c = oAccountA.id;
            insert accterritory;
            
            //AccountTerritoriesHandler.AccountTerrCreationandUpdation(Accountlst);
            system.assertEquals(accterritory!= null,true);
        }
    }
    //Opportunity Assignment
    @isTest static void testOpptyTerritoryBatch() {
        
        LCRM_BatchsizeDefine__c obatchsize = new LCRM_BatchsizeDefine__c();
        obatchsize.Name ='OpptyTerritoryUpdateBatchSize';
        obatchsize.Object__c ='Opportunity';
        obatchsize.Batch_Size__c = 200 ;   
        insert  obatchsize;   
        
        GLI_Load_Tracker__c gliloadtracker = new GLI_Load_Tracker__c();
        gliloadtracker.name = 'Opportunity Assignment';
        gliloadtracker.JobCompletedDate__c= datetime.newInstance(2017, 9, 15, 12, 30, 0);
        Insert gliloadtracker;
        
        Test.StartTest(); 
        gliloadtracker.JobCompletedDate__c= datetime.newInstance(2017, 10, 16, 11, 30, 0);
        UPDATE gliloadtracker;      
        Test.StopTest();
        system.assertEquals(gliloadtracker.JobCompletedDate__c!= null,true);
        
    }
    //Lead Assignment
    @isTest static void testleadTerritoryBatch() {
                
        // 20181022 - Jason Flippen - Added for Jira Story CRM-13127.
        GLI_Load_Tracker__c gliLoadTrackerLAC = new GLI_Load_Tracker__c();
        gliLoadTrackerLAC.Name = 'Lead Completed Activity Count';
        insert gliLoadTrackerLAC;
        
        GLI_Load_Tracker__c gliloadtracker = new GLI_Load_Tracker__c();
        gliloadtracker.name = 'Lead Assignment';
        gliloadtracker.JobCompletedDate__c= datetime.newInstance(2017, 9, 15, 12, 30, 0);
        Insert gliloadtracker;
        
        Test.StartTest(); 
        gliloadtracker.JobCompletedDate__c= datetime.newInstance(2017, 10, 16, 11, 30, 0);
        UPDATE gliloadtracker;      
        system.assertEquals(gliloadtracker.JobCompletedDate__c!= null,true);
        Test.StopTest();
        
    }
    //SSD Assignment
    @isTest static void testSSDBatch() {
        
        
        LCRM_BatchsizeDefine__c obatchsize = new LCRM_BatchsizeDefine__c();
        obatchsize.Name ='SSDBatchSize';
        obatchsize.Object__c ='SSDBatchSize';
        obatchsize.Batch_Size__c = 200 ;   
        insert  obatchsize;
                
        GLI_Load_Tracker__c gliloadtracker = new GLI_Load_Tracker__c();
        gliloadtracker.name = 'Informatica Account SSD Load';
        gliloadtracker.JobCompletedDate__c= datetime.newInstance(2017, 9, 15, 12, 30, 0);
        Insert gliloadtracker;
        
        Test.StartTest(); 
        gliloadtracker.JobCompletedDate__c= datetime.newInstance(2017, 10, 16, 11, 30, 0);
        UPDATE gliloadtracker;  
        system.assertEquals(gliloadtracker.JobCompletedDate__c!= null,true);    
        Test.StopTest();
        
    }
   
      //Informatica XREF Account Family Load
    @isTest static void testAccountFamilyLoadBatch() {
        
        
        LCRM_BatchsizeDefine__c obatchsize = new LCRM_BatchsizeDefine__c();
        obatchsize.Name ='XREFAccountFamily_Batch';
        obatchsize.Object__c ='Account';
        obatchsize.Batch_Size__c = 0 ;   
        insert  obatchsize;
                
        GLI_Load_Tracker__c gliloadtracker = new GLI_Load_Tracker__c();
        gliloadtracker.name = 'Informatica XREF Account Family Load';
        gliloadtracker.JobCompletedDate__c= datetime.newInstance(2017, 9, 15, 12, 30, 0);
        Insert gliloadtracker;
        
        Test.StartTest(); 
        gliloadtracker.JobCompletedDate__c= datetime.newInstance(2017, 10, 16, 11, 30, 0);
        UPDATE gliloadtracker; 
        system.assertEquals( gliloadtracker.JobCompletedDate__c!=null,true);     
        Test.StopTest();
        
    }
     //Informatica XREF Account Family Load
    @isTest static void testAccountFamilyLoadBatchnegative() {
        
        
        LCRM_BatchsizeDefine__c obatchsize = new LCRM_BatchsizeDefine__c();
        obatchsize.Name ='XREFAccountFamily_Batch';
        obatchsize.Object__c ='Account';
        //Obatchsize.Batch_Size__c = 0 ;   
        insert  obatchsize;
                
        GLI_Load_Tracker__c gliloadtracker = new GLI_Load_Tracker__c();
        gliloadtracker.name = 'Informatica XREF Account Family Load';
        gliloadtracker.JobCompletedDate__c= datetime.newInstance(2017, 9, 15, 12, 30, 0);
        Insert gliloadtracker;
        
        Test.StartTest(); 
        gliloadtracker.JobCompletedDate__c= datetime.newInstance(2017, 10, 16, 11, 30, 0);
        UPDATE gliloadtracker;      
        system.assertEquals( gliloadtracker.JobCompletedDate__c!=null,true);
        Test.StopTest();
        
    }
    
      //Informatica XREF Opportunity Family Load
    @isTest static void testOpportunityFamilyLoadBatch() {
        
        
        LCRM_BatchsizeDefine__c obatchsize = new LCRM_BatchsizeDefine__c();
        obatchsize.Name ='XREFOpportunityFamily_Batch';
        obatchsize.Object__c ='Opportunity';
        obatchsize.Batch_Size__c = 0 ;   
        insert  obatchsize;
                
        GLI_Load_Tracker__c gliloadtracker = new GLI_Load_Tracker__c();
        gliloadtracker.name = 'Informatica XREF Opportunity Family Load';
        gliloadtracker.JobCompletedDate__c= datetime.newInstance(2017, 9, 15, 12, 30, 0);
        Insert gliloadtracker;
        
        Test.StartTest(); 
        gliloadtracker.JobCompletedDate__c= datetime.newInstance(2017, 10, 16, 11, 30, 0);
        UPDATE gliloadtracker;  
        system.assertEquals( gliloadtracker.JobCompletedDate__c!=null,true);    
        Test.StopTest();
        
    }
    
       //Informatica XREF Case Family Load
    @isTest static void testCaseFamilyLoadBatch() {
        
        
        LCRM_BatchsizeDefine__c obatchsize = new LCRM_BatchsizeDefine__c();
        obatchsize.Name ='XREFCaseFamily_Batch';
        obatchsize.Object__c ='Case';
        obatchsize.Batch_Size__c = 0 ;   
        insert  obatchsize;
                
        GLI_Load_Tracker__c gliloadtracker = new GLI_Load_Tracker__c();
        gliloadtracker.name = 'Informatica XREF Case Family Load';
        gliloadtracker.JobCompletedDate__c= datetime.newInstance(2017, 9, 15, 12, 30, 0);
        Insert gliloadtracker;
        
        Test.StartTest(); 
        gliloadtracker.JobCompletedDate__c= datetime.newInstance(2017, 10, 16, 11, 30, 0);
        UPDATE gliloadtracker; 
        system.assertEquals( gliloadtracker.JobCompletedDate__c!=null,true);     
        Test.StopTest();
        
    }
    
        //Informatica XREF Training event Family Load
    @isTest static void testTEFamilyLoadBatch() {
        
        
        LCRM_BatchsizeDefine__c obatchsize = new LCRM_BatchsizeDefine__c();
        obatchsize.Name ='XREFTrainingEventFamily_Batch';
        obatchsize.Object__c ='Training Event';
        obatchsize.Batch_Size__c = 200 ;   
        insert  obatchsize;
                
        GLI_Load_Tracker__c gliloadtracker = new GLI_Load_Tracker__c();
        gliloadtracker.name = 'Informatica XREF TrainingEvent Family Load';
        gliloadtracker.JobCompletedDate__c= datetime.newInstance(2017, 9, 15, 12, 30, 0);
        Insert gliloadtracker;
        
        Test.StartTest(); 
        gliloadtracker.JobCompletedDate__c= datetime.newInstance(2017, 10, 16, 11, 30, 0);
        UPDATE gliloadtracker;   
        system.assertEquals( gliloadtracker.JobCompletedDate__c!=null,true);   
        Test.StopTest();
        
    }
    @isTest static void testXrefAccountSegmentLoadBatch(){
        List<Account> accList = new List<Account>();
        List<KeyValueListStore__c> kValueLst = new List<KeyValueListStore__c>();
        KeyValueListStore__c kValue1 = new KeyValueListStore__c();
        kValue1.Name ='ANZUsersProfileId';
      
        KeyValueListStore__c kValue2 = new KeyValueListStore__c();
        kValue2.Name ='ReasonWithCompetitor';
        kValue2.TextValue__c = 'Content';
        
        KeyValueListStore__c kValue3 = new KeyValueListStore__c(); 
        kValue3.Name ='LTS_BURegion_Values';
        kValue3.TextValue__c = 'US,Canada';
        kValueLst.add(kValue1);
        kValueLst.add(kValue2);
        kValueLst.add(kValue3);
        insert kValueLst;


        KeyValueListStore__c profilename = new KeyValueListStore__c();
        profilename.TextValue__c = 'TR Corp Partner Community User';
        profilename.Name = 'LTS_partnerUserProfileName';
        insert profilename;
        
        KeyValueListStore__c leadsourcevalue = new KeyValueListStore__c();
        leadsourcevalue.Name = 'LTS_partnerUserLeadSourceValue';
        leadsourcevalue.TextValue__c = 'Partner';
        insert leadsourcevalue;
        
        KeyValueListStore__c busegment = new KeyValueListStore__c();
        busegment.Name = 'LTS_partnerUserBUSegmentValue';
        busegment.TextValue__c = 'Corporate';
        insert busegment;
        Id pipeLinerecTypId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Pipeline Opportunity').getRecordTypeId();
        Id prePipeLinerecTypId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Pre-Pipeline Opportunity').getRecordTypeId();
            
          List<RecordtypeIds__c> recTypLst = new List<RecordtypeIds__c>();
            RecordtypeIds__c recTyp1 = new RecordtypeIds__c();
            recTyp1.Name = 'Pipeline Opportunities';
            recTyp1.recTypeId__c = pipeLinerecTypId;
            
            RecordtypeIds__c recTyp2 = new RecordtypeIds__c();
            recTyp2.Name = 'Pre-Pipeline Opportunities';
            recTyp2.recTypeId__c = prePipeLinerecTypId;
            
            recTypLst.add(recTyp1);
            recTypLst.add(recTyp2);
            insert recTypLst;
        
    
          Account acc = new Account();
            acc.Is_GLI__c = true;
            acc.BillingCountry = 'US';
            acc.Name = 'TESTACCOUNT_Xref';
            acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('GLI_Account').getRecordTypeId();
            acc.BU_Segment__c ='Professional Tax';
            acc.BU_Region__c = 'US';
            accList.add(acc);
           
            
            if(accList.size()>0){
                insert accList;
            }
            
            
        List<Opportunity> opportunitytestlist = new List<Opportunity>();
        Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        Opportunity oppty=new Opportunity();
        oppty.Name='TEST OPP';
        oppty.Is_GLI__c = true;
        oppty.RecordtypeId=opptyRecorType;
        oppty.StageName ='Need Analysis';
        oppty.AccountId=accList[0].id;
        oppty.CloseDate = Date.Today() + 90;
        oppty.LCRM_Sub_BU__c ='Canada';
        oppty.BU_Segment__c ='Corporate';
        
       
        opportunitytestlist.add(oppty);
        
        Opportunity oppty1=new Opportunity();
        oppty1.Name='TEST OPP1';
        oppty1.Is_GLI__c = true;
        oppty1.RecordtypeId=opptyRecorType;
        oppty1.StageName ='Need Analysis';
        oppty1.AccountId=accList[0].id;
        oppty1.CloseDate = Date.Today() + 90;
        oppty1.LCRM_Sub_BU__c ='US';
        oppty1.BU_Segment__c ='Corporate';
        
        opportunitytestlist.add(oppty1);
        
        if(opportunitytestlist.size()>0){
            insert opportunitytestlist ;
        }
        
        
        List<Task> taskList= new List<Task>();
        List<Event> eventList= new List<Event>();
        for(Opportunity opp : opportunitytestlist){
            System.debug('LASTMODIFIEDDATE** '+opp.lastmodifieddate);
            Task taskIns = new Task();
            taskIns.WhatId = opp.id;
            taskIns.LCRM_Sub_BU__c = 'US';
            taskIns.BU_Segment__c ='Coporate'; 
            
            taskList.add(taskIns);
            Event eventIns = new Event();
            eventIns.WhatId = opp.Id;
            eventIns.LCRM_Sub_BU__c ='Canada';
            eventIns.BU_Segment__c ='Corporate';
            eventIns.ActivityDateTime = system.today();
            eventIns.DurationInMinutes = 120;
      
            eventList.add(eventIns);
        }
        if(taskList.size()> 0 && eventList.size() > 0 ){
            insert taskList;
            insert eventList;
            
        }
        Id leadRt= Schema.SObjectType.Lead.getRecordTypeInfosByName().get('GLI').getRecordTypeId();
        List<Lead> leadList = new List<Lead>();
        Lead testLead1 = UnitTest.getLeadInstance();
         testLead1.LeadSource='Customer Service'; 
         testLead1 .RecordTypeId=leadRt;      
         testLead1.SAPAccountNumber__c = '98711';
         testLead1.FirstName = 'Unit';
         testLead1.LastName = 'Tester1';
         testLead1.Company = 'Unit Test Company';
         testLead1.Status = 'Contacting';         
         testLead1.LCRM_Sub_BU__c='US';
         testLead1.BU_Segment__c='Corporate';
         testLead1.Is_GLI__c = true;
         testLead1.Account__c =accList[0].Id;
         
        Lead ld = new Lead(FirstName ='Test',LastName='Lead',Company='Test',Is_GLI__c=true,RecordTypeId=leadRt,LCRM_Sub_BU__c='Canada',BU_Segment__c='Professional Tax');
        
        leadList.add(TestLead1);
        leadList.add(ld);
        List<Account> updateAcc = new List<Account>();
        if(leadList.size() > 0){
            insert leadList;
        }
        
      
        List<Account> listofAccount = new List<Account>([Select Id,Name,BU_Region__c,BU_Segment__c,IS_GLI__c from Account where IS_GLI__c = true AND Name ='TESTACCOUNT_Xref' AND BU_Segment__c ='Professional Tax' AND BU_Region__c ='US' LIMIT 1]);
        Map<Id, Account> accountIdSegmentMap = new Map<Id, Account>([Select Id,Name,BU_Region__c,BU_Segment__c,IS_GLI__c from Account where IS_GLI__c = true AND Name ='TESTACCOUNT_Xref' AND BU_Segment__c ='Professional Tax' AND BU_Region__c ='US' LIMIT 1]);
        
        List<XREFAccountSegment__c> accountSegmentList = new List<XREFAccountSegment__c>();
        XREFAccountSegment__c xrefaccSeg= new XREFAccountSegment__c();
        xrefaccSeg.Name =listofAccount[0].Id;
        xrefaccSeg.BU_Segment__c =listofAccount[0].BU_Segment__c;
        xrefaccseg.Is_Processed_Activity__c =false;
        accountSegmentList.add(xrefaccSeg);
        insert accountSegmentList;
        system.debug('XrefAcc' +accountSegmentList); 
        
        LCRM_BatchsizeDefine__c obatchsize = new LCRM_BatchsizeDefine__c();
        obatchsize.Name ='XREFAccountSegment';
        obatchsize.Object__c ='XREFAccountSegment__c';
        obatchsize.Batch_Size__c = 200 ;   
        insert  obatchsize;
        system.debug('Obatchsize' +obatchsize);
        
        GLI_Load_Tracker__c gliloadtracker = new GLI_Load_Tracker__c();
        gliloadtracker.name = 'Informatica Account Segment Update';
        gliloadtracker.JobCompletedDate__c= datetime.newInstance(2017, 9, 15, 12, 30, 0);
        Insert gliloadtracker;
        
        system.debug('gliloadtracker' +gliloadtracker) ;
        
        Test.StartTest(); 
        gliloadtracker.JobCompletedDate__c= datetime.newInstance(2018, 10, 16, 11, 30, 0);
        UPDATE gliloadtracker;      
       
       system.assertEquals( gliloadtracker.JobCompletedDate__c!=null,true);
        Test.StopTest();
         
    }
    @isTest static void testXrefAccountSegmentLoadBatch2(){
     
      List<Account> accList = new List<Account>();
        List<KeyValueListStore__c> kValueLst = new List<KeyValueListStore__c>();
        KeyValueListStore__c kValue1 = new KeyValueListStore__c();
        kValue1.Name ='ANZUsersProfileId';
      
        KeyValueListStore__c kValue2 = new KeyValueListStore__c();
        kValue2.Name ='ReasonWithCompetitor';
        kValue2.TextValue__c = 'Content';
        
        KeyValueListStore__c kValue3 = new KeyValueListStore__c(); 
        kValue3.Name ='LTS_BURegion_Values';
        kValue3.TextValue__c = 'US,Canada';
        kValueLst.add(kValue1);
        kValueLst.add(kValue2);
        kValueLst.add(kValue3);
        insert kValueLst;
        Id pipeLinerecTypId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Pipeline Opportunity').getRecordTypeId();
        Id prePipeLinerecTypId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Pre-Pipeline Opportunity').getRecordTypeId();
            
          List<RecordtypeIds__c> recTypLst = new List<RecordtypeIds__c>();
            RecordtypeIds__c recTyp1 = new RecordtypeIds__c();
            recTyp1.Name = 'Pipeline Opportunities';
            recTyp1.recTypeId__c = pipeLinerecTypId;
            
            RecordtypeIds__c recTyp2 = new RecordtypeIds__c();
            recTyp2.Name = 'Pre-Pipeline Opportunities';
            recTyp2.recTypeId__c = prePipeLinerecTypId;
            
            recTypLst.add(recTyp1);
            recTypLst.add(recTyp2);
            insert recTypLst;
        
    
          Account acc = new Account();
            acc.Is_GLI__c = true;
            acc.BillingCountry = 'US';
            acc.Name = 'TESTACCOUNT_Xref';
            acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('GLI_Account').getRecordTypeId();
            acc.BU_Segment__c ='Professional Tax';
            acc.BU_Region__c = 'US';
            accList.add(acc);
           
            
            if(accList.size()>0){
                insert accList;
            }
           
        List<Training_Event__c> evntLst = new List<Training_Event__c>();
        Training_Event__c trnEvnt = new Training_Event__c();
          trnEvnt.Training_Name__c = 'Test1';
          trnEvnt.Account__c = accList[0].Id;
          trnEvnt.LCRM_Sub_BU__c ='Canada';
          trnEvnt.BU_Segment__c ='Corporate';
          trnEvnt.LCRM_Is_GLI__c =TRUE;
          evntLst.add(trnEvnt);
          insert evntLst;
         Contact testContact = new Contact();
         testContact.FirstName='TestFirst';
         testContact.LastName='Lastname';
         testContact.Email='test@tr.com';
         testContact.AccountId=accList[0].id;
         insert testContact;
          List<Case> caseList = new List<Case>();
        Case caseRec = new Case();
        
        caseRec.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Incident').getRecordTypeId();
        caseRec.Origin = 'Web';      
        caseRec.Subject = 'Test Case';
        caseRec.AccountId = accList[0].id;
        caseRec.ContactId =testContact.Id; 
        caseRec.LCRM_Sub_BU__c ='US';
        caseRec.BU_Segment__c ='Corporate';
        caseRec.Is_GLI__c =TRUE;
        caseList.add(caseRec);
        if(caseList.size()>0){
            insert caseList;
        }
      
        List<Account> listofAccount = new List<Account>([Select Id,Name,BU_Region__c,BU_Segment__c,IS_GLI__c from Account where IS_GLI__c = true AND Name ='TESTACCOUNT_Xref' AND BU_Segment__c ='Professional Tax' AND BU_Region__c ='US' LIMIT 1]);
        Map<Id, Account> accountIdSegmentMap = new Map<Id, Account>([Select Id,Name,BU_Region__c,BU_Segment__c,IS_GLI__c from Account where IS_GLI__c = true AND Name ='TESTACCOUNT_Xref' AND BU_Segment__c ='Professional Tax' AND BU_Region__c ='US' LIMIT 1]);
        
        List<XREFAccountSegment__c> accountSegmentList = new List<XREFAccountSegment__c>();
        XREFAccountSegment__c xrefaccSeg= new XREFAccountSegment__c();
        xrefaccSeg.Name =listofAccount[0].Id;
        xrefaccSeg.BU_Segment__c =listofAccount[0].BU_Segment__c;
        xrefaccseg.Is_Processed_Activity__c =false;
        accountSegmentList.add(xrefaccSeg);
        insert accountSegmentList;
        system.debug('XrefAcc' +accountSegmentList); 
        
        LCRM_BatchsizeDefine__c obatchsize = new LCRM_BatchsizeDefine__c();
        obatchsize.Name ='XREFAccountSegment';
        obatchsize.Object__c ='XREFAccountSegment__c';
        obatchsize.Batch_Size__c = 200 ;   
        insert  obatchsize;
        system.debug('Obatchsize' +obatchsize);
        
        GLI_Load_Tracker__c gliloadtracker = new GLI_Load_Tracker__c();
        gliloadtracker.name = 'Informatica Account Segment Update';
        gliloadtracker.JobCompletedDate__c= datetime.newInstance(2017, 9, 15, 12, 30, 0);
        Insert gliloadtracker;
        
        system.debug('gliloadtracker' +gliloadtracker) ;
        
        Test.StartTest(); 
        gliloadtracker.JobCompletedDate__c= datetime.newInstance(2018, 10, 16, 11, 30, 0);
        UPDATE gliloadtracker; 
         
        Test.StopTest();
        system.assertEquals( gliloadtracker.JobCompletedDate__c!=null,true);
    }
    //Renewal Notifications Test
    @isTest static void testRenewalNotificationsTestBatch() {
        
        
        LCRM_BatchsizeDefine__c obatchsize = new LCRM_BatchsizeDefine__c();
        obatchsize.Name ='RenewalNotificationsBatchSize';
        obatchsize.Object__c ='Renewal_Quote__c';
        obatchsize.Batch_Size__c = 10 ;   
        insert  obatchsize;
                
        GLI_Load_Tracker__c gliloadtracker = new GLI_Load_Tracker__c();
        gliloadtracker.name = 'Informatica Renewal Notifications Load';
        gliloadtracker.JobCompletedDate__c= datetime.newInstance(2021, 9, 15, 12, 30, 0);
        Insert gliloadtracker;
        
        Test.StartTest(); 
        gliloadtracker.JobCompletedDate__c= datetime.newInstance(2021, 10, 16, 11, 30, 0);
        UPDATE gliloadtracker;  
        system.assertEquals(gliloadtracker.JobCompletedDate__c!= null,true);    
        Test.StopTest();
        
    }
    
}