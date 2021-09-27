/**
======================================================================================================================
TEST CLASS NAME: LCRMLeadTerritoryService_Test
======================================================================================================================
PURPOSE:    Validates the functionality provided by the LCRMLeadTerritoryService class.

CHANGE HISTORY:
======================================================================================================================
  DATE                  NAME                           DESC
19/3/2018           Harika (Author)
26/3/2018           Navjyoti(Update)            For code coverage of LCRMBatchUpdateTMSTerritoryInLead class
======================================================================================================================
*/
@istest 
public  class LCRMLeadTerritoryService_Test 
{
 //Commenting out as a part of removal of TM1.0 components
    public static testMethod void testLeadTerritoryNoWithSystemAdmin()
    {
    LCRMLeadTerritoryService obj = new LCRMLeadTerritoryService();
    Test.starttest();
    List<Lead> listlead = new List<Lead>();
    Lead TestLead = UnitTest.getLeadInstance();
      TestLead.LeadSource='Customer Service';
      TestLead.SAPAccountNumber__c='1';
      TestLead.Contact_SAP_ID__c = '1';
      TestLead.Is_Web_To_Lead__c = true;
      TestLead.Rep_Channel__c = 'test';
      TestLead.LCRM_Sub_BU__c='USL';
       listlead.add(TestLead);
       insert listlead ;
  LCRMBatchUpdateTMSTerritoryInLead obj3 = new LCRMBatchUpdateTMSTerritoryInLead ();
  Database.executebatch(obj3,1);
    Test.stoptest();
    }
        /*Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        
        User u = new User(Alias = 'test', Email='testuser@thomsonreuters.com',EmailEncodingKey ='UTF-8', LastName ='Test User1', LanguageLocaleKey='en_US',LocaleSidKey='en_US', ProfileId = p.Id,TimeZoneSidKey='America/Los_Angeles',UserName='testuser@trpcorelegal.com',Sub_Bu__c ='USL');
        insert u;
                
        System.runAs(u) 
        {
             recordtype leadRt= [select id from recordtype where name ='GLI' and sobjecttype='Lead' limit 1];
          recordtype accountRT = [select id from recordtype where name ='GLI Account' and sobjecttype='Account' limit 1];
          
       
            Account gliAccount = UnitTest.getAccountInstance();
            gliAccount.Name = 'Test Account Training Event';
            gliAccount.Is_GLI__c = true;
            gliAccount.RecordTypeId=accountRT.Id;
       
            insert gliAccount;
        
            Account gliAccountB = UnitTest.getAccountInstance();
            gliAccountB.Name = 'Test Account';
            gliAccountB.Is_GLI__c = true;
            gliAccountB.RecordTypeId=accountRT.Id;
       
            insert gliAccountB;
        
            UserTerritory2Association oUserTerritory = [SELECT Id, Territory2Id, UserId FROM UserTerritory2Association WHERE IsActive=true LIMIT 1];
            UserTerritory2Association oUserTerritory2 = [SELECT Id, Territory2Id, UserId FROM UserTerritory2Association WHERE Id !=:oUserTerritory.Id AND IsActive=true LIMIT 1];
        
            User oUser = [SELECT Id, Name FROM User WHERE Id=:oUserTerritory.UserId];
            oUser.IsActive = true;
            //update oUser;
            
            Territory2 oTerritory = [SELECT Id, Name,District__c,ParentTerritory2Id, Description, AccountAccessLevel, 
            OpportunityAccessLevel, CaseAccessLevel, ContactAccessLevel,   CurrencyIsoCode,
              DeveloperName,TMS_Market_Segment_Desc__c, TMS_Market_Segment_ID__c,
              TMS_Parent_Territory_ID__c, TMS_Rep_Function_Desc__c, TMS_Rep_Function_ID__c, TMS_Sales_Force_Desc__c, 
              TMS_Sales_Force_ID__c, TMS_Terr_Num__c, TMS_Territory_ID__c, TMS_New_Sales_Quota_Curr_Yr__c, 
              TMS_Renewal_Sales_Quota_Curr_Yr__c, Region__c, TMS_Sales_Force_Code__c, TMS_Market_Segment_Code__c, 
              TMS_Ref_Function_Code__c FROM Territory2 WHERE Id=:oUserTerritory.Territory2Id];
        
            Territory2 oTerritory2 = [SELECT Id, Name,District__c,ParentTerritory2Id, Description, AccountAccessLevel, 
            OpportunityAccessLevel, CaseAccessLevel, ContactAccessLevel,   CurrencyIsoCode,
              DeveloperName,TMS_Market_Segment_Desc__c, TMS_Market_Segment_ID__c,
              TMS_Parent_Territory_ID__c, TMS_Rep_Function_Desc__c, TMS_Rep_Function_ID__c, TMS_Sales_Force_Desc__c,
               TMS_Sales_Force_ID__c, TMS_Terr_Num__c, TMS_Territory_ID__c, TMS_New_Sales_Quota_Curr_Yr__c,
                TMS_Renewal_Sales_Quota_Curr_Yr__c, Region__c, TMS_Sales_Force_Code__c, TMS_Market_Segment_Code__c, 
                TMS_Ref_Function_Code__c FROM Territory2 WHERE Id=:oUserTerritory2.Territory2Id];
        
            set<ID> oTerritoryID = new set<ID>();
            oTerritoryID.add(oTerritory.Id);
            oTerritoryID.add(oTerritory2.Id);
        
            Group oGroup = [SELECT Id, RelatedId FROM Group WHERE RelatedId=:oTerritory.Id AND Type='Territory' LIMIT 1];
            Group oGroup2 = [SELECT Id, RelatedId FROM Group WHERE RelatedId=:oTerritory2.Id AND Type='Territory' LIMIT 1];
        
            List<AccountShare> accountsharelist = new List<AccountShare>();
        
            AccountShare oAccountShareA = new AccountShare();
            oAccountShareA.AccountId =  gliAccount.Id;
            oAccountShareA.UserOrGroupId = oGroup.Id;
            accountsharelist.add(oAccountShareA);
        
            if(accountsharelist.size()>0)
            {
               // insert accountsharelist;            
            }
        
        
            List<AccountTeamMember> members = new list<AccountTeamMember>();
        
            members.add(New AccountTeamMember(AccountId = gliAccount.id, TeamMemberRole = 'ACC-Team-Mem1', UserId= u.Id));
            members.add(New AccountTeamMember(AccountId = gliAccountB.id, TeamMemberRole = 'ACC-Team-Mem1', UserId= u.Id));
            members.add(New AccountTeamMember(AccountId = gliAccount.id, TeamMemberRole = 'ACC-Team-Mem', UserId= oUser.Id));
            members.add(New AccountTeamMember(AccountId = gliAccountB.id, TeamMemberRole = 'ACC-Team-Mem', UserId= oUser.Id));
       
            insert members;
        
            List<TMS_Territory__c> lstTMsTerritory = new List<TMS_Territory__c>();
        
            TMS_Territory__c TMS_Terr =new TMS_Territory__c();
            TMS_Terr.Name = 'Test_created by SystemAdmin';
            TMS_Terr.Account__c = gliAccount.id;
            TMS_Terr.Territory_ID__c =oTerritory.id;
            TMS_Terr.TMS_Sales_Force_Desc__c ='ACC';
            TMS_Terr.TMS_Market_Segment_Desc__c='Team';
            TMS_Terr.TMS_Rep_Function_Desc__c ='Mem';
            TMS_Terr.TMS_Territory_Number__c ='1234';
            lstTMsTerritory .add(TMS_Terr);
        
            TMS_Territory__c TMS_TerrRec =new TMS_Territory__c();
            TMS_TerrRec.Name = 'Test_created by SystemAdmin';
            TMS_TerrRec.Account__c = gliAccountB.id;
            TMS_TerrRec.TMS_Sales_Force_Desc__c ='ACC';
            TMS_Terr.Territory_ID__c =oTerritory.id;
            TMS_TerrRec.TMS_Market_Segment_Desc__c='Team';
            TMS_TerrRec.TMS_Rep_Function_Desc__c ='Mem';
            TMS_TerrRec.TMS_Territory_Number__c ='12345';
            lstTMsTerritory .add(TMS_TerrRec);
        
            TMS_Territory__c TMS_Terr1 =new TMS_Territory__c();
            TMS_Terr1.Name = 'Test_created by SystemAdmin';
            TMS_Terr1.Account__c = gliAccount.id;
            TMS_Terr1.Territory_ID__c =oTerritory.id;
            TMS_Terr1.TMS_Sales_Force_Desc__c ='ACC';
            TMS_Terr1.TMS_Market_Segment_Desc__c='Team';
            TMS_Terr1.TMS_Rep_Function_Desc__c ='Mem1';
            TMS_Terr1.TMS_Territory_Number__c ='1234';
            lstTMsTerritory .add(TMS_Terr1);
        
            TMS_Territory__c TMS_TerrRec1 =new TMS_Territory__c();
            TMS_TerrRec1.Name = 'Test_created by SystemAdmin';
            TMS_TerrRec1.Account__c = gliAccountB.id;
            TMS_TerrRec1.TMS_Sales_Force_Desc__c ='ACC';
            TMS_Terr1.Territory_ID__c =oTerritory.id;
            TMS_TerrRec1.TMS_Market_Segment_Desc__c='Team';
            TMS_TerrRec1.TMS_Rep_Function_Desc__c ='Mem1';
            TMS_TerrRec1.TMS_Territory_Number__c ='123';
            lstTMsTerritory .add(TMS_TerrRec1);
        
            if(lstTMsTerritory.size()>0)
            {
                insert lstTMsTerritory ;
            } 
        
            List<TMS_Territory__c > lsttmsterri =[Select Id,Name  from TMS_Territory__c  ];
            //System.assertEquals(lsttmsterri .size(),4);
            Test.startTest();
         List<Lead> lstleadinsert = new List<Lead>();
            Lead objLead = UnitTest.getLeadInstance();
            objLead .Is_GLI__c =true;
            objLead .Account__c = gliAccount.Id;
             objLead .RecordTypeId=leadRt.Id;
            objLead.OwnerId =oUser.Id;
            lstleadinsert .add(objLead);
        
            Lead objLead1 = UnitTest.getLeadInstance();
            objLead1 .Is_GLI__c =true;
            objLead1 .Account__c = gliAccountB.Id;
             objLead1.RecordTypeId=leadRt.Id;
            objLead1.OwnerId =u.Id;
            lstleadinsert .add(objLead1 );
            insert lstleadinsert ;
        
            List<Lead> lstLead=[Select Id,Name,Account__c,LCRM_Lead_Owner_TMS_Territory__c   from Lead where Is_GLI__c =true ];
            //System.assertEquals(lstLead.size(),2);
            if(lstLead[0].Account__c == gliAccount.Id)
            {
                //System.assertEquals(lstLead[0].LCRM_Lead_Owner_TMS_Territory__c ,'1234');
                //System.assertEquals(lstLead[1].LCRM_Lead_Owner_TMS_Territory__c ,null);
            }
            else
            {
                //System.assertEquals(lstLead[0].LCRM_Lead_Owner_TMS_Territory__c ,null);
                //System.assertEquals(lstLead[1].LCRM_Lead_Owner_TMS_Territory__c ,'1234');
            }
        
            //LCRMLeadTerritoryService.canIRun();
           // LCRMLeadTerritoryService.allowTriggerHandlerToRun = false;
            Lead objLead2 = UnitTest.getLeadInstance();
            objLead2 .Is_GLI__c =true;
            objLead2 .Account__c = gliAccountB.Id;
            objLead2.RecordTypeId=leadRt.Id;
            objLead2.OwnerId =u.Id;
            insert objLead2 ;
            //System.assertNotEquals(objLead2.Id,null);
            //System.assertEquals(objLead2.LCRM_Lead_Owner_TMS_Territory__c ,null);
        
           // LCRMLeadTerritoryService.allowTriggerHandlerToRun =true;
        
            Lead olead =[Select Id,Name,ownerId,Account__c,SAPAccountNumber__c,Contact_SAP_ID__c,LCRM_Sub_BU__c from Lead where Account__c =:gliAccount.Id];
            olead.OwnerId =u.Id;
            olead .SAPAccountNumber__c= '12345';
            olead .Contact_SAP_ID__c= '12346';
            Update olead ;
            //System.assertEquals(olead.LCRM_Lead_Owner_TMS_Territory__c ,null);
            Test.stopTest();
               
        }


    }

public static testMethod void testLeadTerritoryNoWithUKIProfile()
{
    Profile ukiProfile = [SELECT Id FROM profile WHERE name='UKI Users'];
    UserRole ukiRole = [SELECT Id FROM UserRole WHERE Name = 'Legal'];
    User gliUser = UnitTest.getUserInstance();
            gliUser.Username = 'TestUser1@TR.com';
            gliUser.profileid = ukiProfile.Id;
            gliUser.UserRoleId = ukiRole.Id;
            gliUser.Sub_Bu__c = 'UKI';
            insert gliUser;
            User gliUser1  = new User(Alias = 'test1', Email='testuser@thomsonreuters.com',EmailEncodingKey ='UTF-8', LastName ='Test User1', LanguageLocaleKey='en_US',LocaleSidKey='en_US', profileid = ukiProfile.Id,UserRoleId = ukiRole.Id,TimeZoneSidKey='America/Los_Angeles',UserName='testuser12@trpcorelegal.com',Sub_Bu__c ='UKI',ManagerId =gliUser.Id);
        insert gliUser1 ;
             
        
    System.runAs(gliUser) 
        {
            
            recordtype leadRt= [select id from recordtype where name ='GLI' and sobjecttype='Lead' limit 1];
          recordtype accountRT = [select id from recordtype where name ='GLI Account' and sobjecttype='Account' limit 1];
          
       
            Account gliAccount = UnitTest.getAccountInstance();
            gliAccount.Name = 'Test Account Training Event';
            gliAccount.Is_GLI__c = true;
            gliAccount.RecordTypeId=accountRT.Id;
       
            insert gliAccount;
        
            Account gliAccountB = UnitTest.getAccountInstance();
            gliAccountB.Name = 'Test Account';
            gliAccountB.Is_GLI__c = true;
            gliAccountB.RecordTypeId=accountRT.Id;
       
            insert gliAccountB;
        
            UserTerritory2Association oUserTerritory = [SELECT Id, Territory2Id, UserId FROM UserTerritory2Association WHERE IsActive=true LIMIT 1];
            UserTerritory2Association oUserTerritory2 = [SELECT Id, Territory2Id, UserId FROM UserTerritory2Association WHERE Id !=:oUserTerritory.Id AND IsActive=true LIMIT 1];
        
            User oUser = [SELECT Id, Name FROM User WHERE Id=:oUserTerritory.UserId ];
        
            Territory2 oTerritory = [SELECT Id, Name,District__c,ParentTerritory2Id, Description, AccountAccessLevel, OpportunityAccessLevel,
             CaseAccessLevel, ContactAccessLevel,   CurrencyIsoCode,  DeveloperName,TMS_Market_Segment_Desc__c, TMS_Market_Segment_ID__c, 
             TMS_Parent_Territory_ID__c, TMS_Rep_Function_Desc__c, TMS_Rep_Function_ID__c, TMS_Sales_Force_Desc__c, TMS_Sales_Force_ID__c,
              TMS_Terr_Num__c, TMS_Territory_ID__c, TMS_New_Sales_Quota_Curr_Yr__c, TMS_Renewal_Sales_Quota_Curr_Yr__c, Region__c, 
              TMS_Sales_Force_Code__c, TMS_Market_Segment_Code__c, TMS_Ref_Function_Code__c 
              FROM Territory2 WHERE Id=:oUserTerritory.Territory2Id];
        
            Territory2 oTerritory2 = [SELECT Id, Name,District__c,ParentTerritory2Id, Description, AccountAccessLevel, OpportunityAccessLevel,
             CaseAccessLevel, ContactAccessLevel,   CurrencyIsoCode,  DeveloperName,TMS_Market_Segment_Desc__c, TMS_Market_Segment_ID__c, 
             TMS_Parent_Territory_ID__c, TMS_Rep_Function_Desc__c, TMS_Rep_Function_ID__c, TMS_Sales_Force_Desc__c, TMS_Sales_Force_ID__c,
              TMS_Terr_Num__c, TMS_Territory_ID__c, TMS_New_Sales_Quota_Curr_Yr__c, TMS_Renewal_Sales_Quota_Curr_Yr__c, Region__c,
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
            oAccountShareA.AccountId =  gliAccount.Id;
            oAccountShareA.UserOrGroupId = oGroup.Id;
            accountsharelist.add(oAccountShareA);
        
            if(accountsharelist.size()>0){
                //insert accountsharelist;            
            }
        
        
            List<AccountTeamMember> members = new list<AccountTeamMember>();
        
            members.add(New AccountTeamMember(AccountId = gliAccount.id, TeamMemberRole = 'ACC-Team-Mem1', UserId= gliUser.Id));
            members.add(New AccountTeamMember(AccountId = gliAccountB.id, TeamMemberRole = 'ACC-Team-Mem1', UserId= gliUser.Id));
            members.add(New AccountTeamMember(AccountId = gliAccount.id, TeamMemberRole = 'ACC-Team-Mem', UserId= oUser.Id));
            members.add(New AccountTeamMember(AccountId = gliAccountB.id, TeamMemberRole = 'ACC-Team-Mem', UserId= oUser.Id));
       
            insert members;
        
            List<TMS_Territory__c> lstTMsTerritory = new List<TMS_Territory__c>();
        
            TMS_Territory__c TMS_Terr =new TMS_Territory__c();
            TMS_Terr.Name = 'Test_created by SystemAdmin';
            TMS_Terr.Account__c = gliAccount.id;
            TMS_Terr.Territory_ID__c =oTerritory.id;
            TMS_Terr.TMS_Sales_Force_Desc__c ='ACC';
            TMS_Terr.TMS_Market_Segment_Desc__c='Team';
            TMS_Terr.TMS_Rep_Function_Desc__c ='Mem';
            TMS_Terr.TMS_Territory_Number__c ='1234';
            lstTMsTerritory .add(TMS_Terr);
        
            TMS_Territory__c TMS_TerrRec =new TMS_Territory__c();
            TMS_TerrRec.Name = 'Test_created by SystemAdmin';
            TMS_TerrRec.Account__c = gliAccountB.id;
            TMS_TerrRec.TMS_Sales_Force_Desc__c ='ACC';
            TMS_Terr.Territory_ID__c =oTerritory.id;
            TMS_TerrRec.TMS_Market_Segment_Desc__c='Team';
            TMS_TerrRec.TMS_Rep_Function_Desc__c ='Mem';
            TMS_TerrRec.TMS_Territory_Number__c ='12345';
            lstTMsTerritory .add(TMS_TerrRec);
        
            TMS_Territory__c TMS_Terr1 =new TMS_Territory__c();
            TMS_Terr1.Name = 'Test_created by SystemAdmin';
            TMS_Terr1.Account__c = gliAccount.id;
            TMS_Terr1.Territory_ID__c =oTerritory.id;
            TMS_Terr1.TMS_Sales_Force_Desc__c ='ACC';
            TMS_Terr1.TMS_Market_Segment_Desc__c='Team';
            TMS_Terr1.TMS_Rep_Function_Desc__c ='Mem1';
            TMS_Terr1.TMS_Territory_Number__c ='1234';
            lstTMsTerritory .add(TMS_Terr1);
        
            TMS_Territory__c TMS_TerrRec1 =new TMS_Territory__c();
            TMS_TerrRec1.Name = 'Test_created by SystemAdmin';
            TMS_TerrRec1.Account__c = gliAccountB.id;
            TMS_TerrRec1.TMS_Sales_Force_Desc__c ='ACC';
            TMS_Terr1.Territory_ID__c =oTerritory.id;
            TMS_TerrRec1.TMS_Market_Segment_Desc__c='Team';
            TMS_TerrRec1.TMS_Rep_Function_Desc__c ='Mem1';
            TMS_TerrRec1.TMS_Territory_Number__c ='123';
            lstTMsTerritory .add(TMS_TerrRec1);
        
            if(lstTMsTerritory.size()>0){
                insert lstTMsTerritory ;
            }  
            List<TMS_Territory__c > lsttmsterri =[Select Id,Name  from TMS_Territory__c  ];
            //System.assertEquals(lsttmsterri .size(),4);
        
            Test.startTest();
            List<Lead> lstleadinsert = new List<Lead>();
            Lead objLead = UnitTest.getLeadInstance();
            objLead .Is_GLI__c =true;
            objLead .Account__c = gliAccount.Id;
            objLead.OwnerId =oUser.Id;
            objLead.RecordTypeId=leadRt.Id;
            lstleadinsert .add(objLead);
        
            Lead objLead1 = UnitTest.getLeadInstance();
            objLead1 .Is_GLI__c =true;
            objLead1 .Account__c = gliAccountB.Id;
            objLead1.OwnerId =gliUser.Id;
            objLead1.RecordTypeId=leadRt.Id;
            lstleadinsert .add(objLead1 );
            insert lstleadinsert ;
        
            List<Lead> lstLead=[Select Id,Name,Account__c,LCRM_Lead_Owner_TMS_Territory__c   from Lead where Is_GLI__c =true ];
            //System.assertEquals(lstLead.size(),2);
            if(lstLead[0].Account__c == gliAccount.Id)
            {
                //System.assertEquals(lstLead[0].LCRM_Lead_Owner_TMS_Territory__c ,'1234');
                //System.assertEquals(lstLead[1].LCRM_Lead_Owner_TMS_Territory__c ,null);
            }
            else
            {
            //System.assertEquals(lstLead[1].LCRM_Lead_Owner_TMS_Territory__c ,'1234');
            //System.assertEquals(lstLead[0].LCRM_Lead_Owner_TMS_Territory__c ,null);
            }  
        
           // LCRMLeadTerritoryService.canIRun();
           // LCRMLeadTerritoryService.allowTriggerHandlerToRun = false;
            Lead objLead2 = UnitTest.getLeadInstance();
            objLead2 .Is_GLI__c =true;
            objLead2 .Account__c = gliAccountB.Id;
            objLead2.OwnerId =gliUser.Id;
            objLead2.RecordTypeId=leadRt.Id;
            insert objLead2 ;
            
            //System.assertEquals(objLead2.LCRM_Lead_Owner_TMS_Territory__c ,null);
        
           // LCRMLeadTerritoryService.allowTriggerHandlerToRun =true;
            
            Lead olead =[Select Id,Name,ownerId,Account__c,SAPAccountNumber__c,Contact_SAP_ID__c,LCRM_Sub_BU__c from Lead where Account__c =:gliAccount.Id];
            olead.OwnerId= gliUser.Id;
            olead.SAPAccountNumber__c= '12345';
            olead.Contact_SAP_ID__c= '12346';
            Update olead ;
            
           // System.assertEquals(olead.LCRM_Lead_Owner_TMS_Territory__c ,null);
            Test.stopTest();
            
       
        }
        
    }
    
    public static testMethod void testLeadTerritoryNoWithEloquaMarketing(){
    Profile eloqaProfile = [SELECT Id FROM profile WHERE name='Eloqua Marketing'];
    UserRole eloqaRole = [SELECT Id FROM UserRole WHERE Name = 'Legal'];
    User gliUser = UnitTest.getUserInstance();
            gliUser.Username = 'TestUser1@TR.com';
            gliUser.profileid = eloqaProfile.Id;
            gliUser.UserRoleId = eloqaRole.Id;
            gliUser.Sub_Bu__c = 'UKI';
            gliUser.Sales_Org__c ='GLI';
            insert gliUser;
    
        //UserTerritory2Association oUserTerritory = [SELECT Id, Territory2Id, UserId FROM UserTerritory2Association WHERE IsActive=true LIMIT 1];
           // UserTerritory2Association oUserTerritory2 = [SELECT Id, Territory2Id, UserId FROM UserTerritory2Association WHERE Id !=:oUserTerritory.Id AND IsActive=true LIMIT 1];
        
            //User oUser = [SELECT Id, Name FROM User WHERE Id=:oUserTerritory.UserId];
           // oUser.IsActive=true;
           // update oUser;
            
     System.runAs(gliUser) 
        {     
           recordtype leadRt= [select id from recordtype where name ='GLI' and sobjecttype='Lead' limit 1];
          recordtype accountRT = [select id from recordtype where name ='GLI Account' and sobjecttype='Account' limit 1];
          
       
            Account gliAccount = UnitTest.getAccountInstance();
            gliAccount.Name = 'Test Account Training Event';
            gliAccount.Is_GLI__c = true;
            gliAccount.RecordTypeId=accountRT.Id;
       
            insert gliAccount;
        
            Account gliAccountB = UnitTest.getAccountInstance();
            gliAccountB.Name = 'Test Account';
            gliAccountB.Is_GLI__c = true;
            gliAccountB.RecordTypeId=accountRT.Id;
       
            insert gliAccountB;
        
            UserTerritory2Association oUserTerritory = [SELECT Id, Territory2Id, UserId FROM UserTerritory2Association WHERE IsActive=true LIMIT 1];
            UserTerritory2Association oUserTerritory2 = [SELECT Id, Territory2Id, UserId FROM UserTerritory2Association WHERE Id !=:oUserTerritory.Id AND IsActive=true LIMIT 1];
        
            User oUser = [SELECT Id, Name FROM User WHERE Id=:oUserTerritory.UserId];
           // oUser.IsActive=true;
            //insert oUser;
         
            Territory2 oTerritory = [SELECT Id, Name,District__c,ParentTerritory2Id, Description, AccountAccessLevel,
             OpportunityAccessLevel, CaseAccessLevel, ContactAccessLevel,   CurrencyIsoCode,  DeveloperName,TMS_Market_Segment_Desc__c,
              TMS_Market_Segment_ID__c, TMS_Parent_Territory_ID__c, TMS_Rep_Function_Desc__c, TMS_Rep_Function_ID__c,
               TMS_Sales_Force_Desc__c, TMS_Sales_Force_ID__c, TMS_Terr_Num__c, TMS_Territory_ID__c, TMS_New_Sales_Quota_Curr_Yr__c, 
               TMS_Renewal_Sales_Quota_Curr_Yr__c, Region__c, TMS_Sales_Force_Code__c, TMS_Market_Segment_Code__c, 
               TMS_Ref_Function_Code__c FROM Territory2 WHERE Id=:oUserTerritory.Territory2Id];
        
            Territory2 oTerritory2 = [SELECT Id, Name,District__c,ParentTerritory2Id, Description, AccountAccessLevel, 
            OpportunityAccessLevel, CaseAccessLevel, ContactAccessLevel,   CurrencyIsoCode,  DeveloperName,TMS_Market_Segment_Desc__c, 
            TMS_Market_Segment_ID__c, TMS_Parent_Territory_ID__c, TMS_Rep_Function_Desc__c, TMS_Rep_Function_ID__c,
             TMS_Sales_Force_Desc__c, TMS_Sales_Force_ID__c, TMS_Terr_Num__c, TMS_Territory_ID__c, TMS_New_Sales_Quota_Curr_Yr__c, 
             TMS_Renewal_Sales_Quota_Curr_Yr__c, Region__c, TMS_Sales_Force_Code__c, TMS_Market_Segment_Code__c, 
             TMS_Ref_Function_Code__c FROM Territory2 WHERE Id=:oUserTerritory2.Territory2Id];
        
            System.debug('oTerritory:-'+oTerritory);
            System.debug('oTerritory2:-'+oTerritory2);
            set<ID> oTerritoryID = new set<ID>();
            oTerritoryID.add(oTerritory.Id);
            oTerritoryID.add(oTerritory2.Id);
        
            Group oGroup = [SELECT Id, RelatedId FROM Group WHERE RelatedId=:oTerritory.Id AND Type='Territory' LIMIT 1];
            Group oGroup2 = [SELECT Id, RelatedId FROM Group WHERE RelatedId=:oTerritory2.Id AND Type='Territory' LIMIT 1];
        
            List<AccountShare> accountsharelist = new List<AccountShare>();
        
            AccountShare oAccountShareA = new AccountShare();
            oAccountShareA.AccountId =  gliAccount.Id;
            oAccountShareA.UserOrGroupId = oGroup.Id;
            accountsharelist.add(oAccountShareA);
        
            if(accountsharelist.size()>0){
               // insert accountsharelist;            
            }
        
        
            List<AccountTeamMember> members = new list<AccountTeamMember>();
        
            members.add(New AccountTeamMember(AccountId = gliAccount.id, TeamMemberRole = 'ACC-Team-Mem1', UserId= gliUser.Id));
            members.add(New AccountTeamMember(AccountId = gliAccountB.id, TeamMemberRole = 'ACC-Team-Mem1', UserId= gliUser.Id));
            members.add(New AccountTeamMember(AccountId = gliAccount.id, TeamMemberRole = 'ACC-Team-Mem', UserId= oUser.Id));
            members.add(New AccountTeamMember(AccountId = gliAccountB.id, TeamMemberRole = 'ACC-Team-Mem', UserId= oUser.Id));
       
            insert members;
        
            List<TMS_Territory__c> lstTMsTerritory = new List<TMS_Territory__c>();
        
            TMS_Territory__c TMS_Terr =new TMS_Territory__c();
            TMS_Terr.Name = 'Test_created by SystemAdmin';
            TMS_Terr.Account__c = gliAccount.id;
            TMS_Terr.Territory_ID__c =oTerritory.id;
            TMS_Terr.TMS_Sales_Force_Desc__c ='ACC';
            TMS_Terr.TMS_Market_Segment_Desc__c='Team';
            TMS_Terr.TMS_Rep_Function_Desc__c ='Mem';
            TMS_Terr.TMS_Territory_Number__c ='1234';
            lstTMsTerritory .add(TMS_Terr);
        
            TMS_Territory__c TMS_TerrRec =new TMS_Territory__c();
            TMS_TerrRec.Name = 'Test_created by SystemAdmin';
            TMS_TerrRec.Account__c = gliAccountB.id;
            TMS_TerrRec.TMS_Sales_Force_Desc__c ='ACC';
            TMS_Terr.Territory_ID__c =oTerritory.id;
            TMS_TerrRec.TMS_Market_Segment_Desc__c='Team';
            TMS_TerrRec.TMS_Rep_Function_Desc__c ='Mem';
            TMS_TerrRec.TMS_Territory_Number__c ='12345';
            lstTMsTerritory .add(TMS_TerrRec);
        
            TMS_Territory__c TMS_Terr1 =new TMS_Territory__c();
            TMS_Terr1.Name = 'Test_created by SystemAdmin';
            TMS_Terr1.Account__c = gliAccount.id;
            TMS_Terr1.Territory_ID__c =oTerritory.id;
            TMS_Terr1.TMS_Sales_Force_Desc__c ='ACC';
            TMS_Terr1.TMS_Market_Segment_Desc__c='Team';
            TMS_Terr1.TMS_Rep_Function_Desc__c ='Mem1';
            TMS_Terr1.TMS_Territory_Number__c ='1234';
            lstTMsTerritory .add(TMS_Terr1);
        
            TMS_Territory__c TMS_TerrRec1 =new TMS_Territory__c();
            TMS_TerrRec1.Name = 'Test_created by SystemAdmin';
            TMS_TerrRec1.Account__c = gliAccountB.id;
            TMS_TerrRec1.TMS_Sales_Force_Desc__c ='ACC';
            TMS_Terr1.Territory_ID__c =oTerritory.id;
            TMS_TerrRec1.TMS_Market_Segment_Desc__c='Team';
            TMS_TerrRec1.TMS_Rep_Function_Desc__c ='Mem1';
            TMS_TerrRec1.TMS_Territory_Number__c ='123';
            lstTMsTerritory .add(TMS_TerrRec1);
        
            if(lstTMsTerritory.size()>0){
                insert lstTMsTerritory ;
            }  
            List<TMS_Territory__c > lsttmsterri =[Select Id,Name  from TMS_Territory__c  ];
            //System.assertEquals(lsttmsterri .size(),4);
        
        
            Test.startTest();
            List<GLI_Load_Tracker__c> gliloadtrackerList = new List<GLI_Load_Tracker__c>();
            GLI_Load_Tracker__c gliloadtracker = new GLI_Load_Tracker__c();
            gliloadtracker.name = 'Lead Assignment';           
            gliloadtracker.JobCompletedDate__c= datetime.newInstance(2017, 9, 16, 12, 30, 0);
            gliloadtracker.LCRMOpportunityStartDate__c = datetime.newInstance(2017, 9, 15, 12, 30, 0);
            gliloadtrackerList.add(gliloadtracker);
            
            GLI_Load_Tracker__c gliloadtracker1 = new GLI_Load_Tracker__c();
            gliloadtracker1.name = 'Lead Completed Activity Count';           
            gliloadtracker1.JobCompletedDate__c= datetime.newInstance(2017, 9, 16, 12, 30, 0);
            gliloadtracker1.LCRMOpportunityStartDate__c = datetime.newInstance(2017, 9, 15, 12, 30, 0);
            gliloadtrackerList.add(gliloadtracker1);
            
            insert gliloadtrackerList;
            
        
            List<Lead> lstleadinsert = new List<Lead>();
            Lead objLead = UnitTest.getLeadInstance();
            objLead .Is_GLI__c =true;
            objLead .Account__c = gliAccount.Id;
            objLead.OwnerId =oUser.Id;
            objLead.RecordTypeId=leadRt.Id;
            objLead.LCRM_Mass_Load_Indicator__c =true;
            objLead.Status ='Prospecting';
            lstleadinsert .add(objLead);
        
            Lead objLead1 = UnitTest.getLeadInstance();
            objLead1 .Is_GLI__c =true;
            objLead1 .Account__c = gliAccountB.Id;
            objLead1.OwnerId =gliUser.Id;
            objLead1.RecordTypeId=leadRt.Id;
            objLead1.LCRM_Mass_Load_Indicator__c =true;
            objLead1.Status ='Prospecting';
            lstleadinsert .add(objLead1 );
            insert lstleadinsert ;
        
           // LCRMLeadTerritoryService.getIntegartionUsersDetails();
            
            LCRMBatchUpdateTMSTerritoryInLead obj = new LCRMBatchUpdateTMSTerritoryInLead();
            DataBase.executeBatch(obj); 
            
            Test.stopTest();
        
   
        }
    }
   */ 
}