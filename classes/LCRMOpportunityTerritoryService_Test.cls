/**
======================================================================================================================
TEST CLASS NAME: LCRMOpportunityTerritoryService_Test
======================================================================================================================
PURPOSE:    Validates the functionality provided by the LCRMOpportunityTerritoryService class.

CHANGE HISTORY:
======================================================================================================================
DATE                  NAME                           DESC


======================================================================================================================
*/

//Commenting out as a part of removal of TM1.0 components

@isTest(SeeAllData=false)
Public class LCRMOpportunityTerritoryService_Test{
    
        
    
    public static testmethod void UnitTest(){
        LCRMOpportunityTerritoryService obj= new LCRMOpportunityTerritoryService();
        test.starttest();
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
        //List<Opportunity> listobj = new List<Opportunity>();  
        Account accObj = new Account();
          accObj.name = 'test acc';
          accObj.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('GLI Account').getRecordTypeId();  
          accObj.BU_Region__c = 'Canada';
          accObj.Bu_Segment__c = 'Professional Tax';
          accObj.Is_GLI__c = true;
          insert accObj;
          
          Opportunity testOpportunity = UnitTest.getOpportunityInstance(accObj.Id);
          testOpportunity.Renewal_Flag__c = false;
          testOpportunity.Selling_Organization__c = 'LRA';
          testOpportunity.Expiration_Date__c = Date.Today().adddays(300);
          testOpportunity.Expected_Revenue_Date__c = date.today();
          //listobj.add(testOpportunity);
          
          insert testOpportunity;
          
        LcrmOpptyTerrIdUpdateBatch obj2 = new LcrmOpptyTerrIdUpdateBatch();
        Database.executebatch(obj2,1);
        
        test.stoptest();
        }
        /*List<KeyValueListStore__c> lstOfKeyStore = new List<KeyValueListStore__c>();
        KeyValueListStore__c KeyvalueStore3 = new KeyValueListStore__c();
        KeyvalueStore3.Name= 'LCRMCheckInformaticaUser';
        KeyvalueStore3.TextValue__c = 'Informatica GLI Integration';
        lstOfKeyStore.add(KeyvalueStore3);
        KeyValueListStore__c KeyvalueStore = new KeyValueListStore__c();
        KeyvalueStore.Name = 'LCRM Oppty Reason';
        KeyvalueStore.TextValue__c = 'Billing System Cancellation';
        lstOfKeyStore.add(KeyvalueStore);
        
        KeyValueListStore__c KeyvalueStore1 = new KeyValueListStore__c();
        KeyvalueStore1.Name='LCRM Oppty Win Loss'; 
        KeyvalueStore1.TextValue__c = 'Lost';
        lstOfKeyStore.add(KeyvalueStore1);
        
        KeyValueListStore__c KeyvalueStore2 = new KeyValueListStore__c();
        KeyvalueStore2.Name= 'ANZUsersProfileId';
        KeyvalueStore2.TextValue__c = '00e30000001ZUki';
        lstOfKeyStore.add(KeyvalueStore2);
        
        
        
        KeyValueListStore__c KeyvalueStore4 = new KeyValueListStore__c();
        KeyvalueStore4.Name= 'LCRMOpptyTerritoryStageValues';
        KeyvalueStore4.TextValue__c = 'Contract Signed,Order Complete,Closed Lost';
        lstOfKeyStore.add(KeyvalueStore4);
        //End Opportunity
        
        if(lstOfKeyStore.size()>0){ 
            insert lstOfKeyStore;
        }
        //
        RecordtypeIds__c rt = new RecordtypeIds__c(name = 'Pre-Pipeline Opportunities', recTypeId__c='01230000001MA4hAAG');
        insert rt;
        RecordtypeIds__c rt1 = new RecordtypeIds__c(name = 'Pipeline Opportunities', recTypeId__c='01230000001MA4gAAG');
        insert rt1;
        RecordtypeIds__c rt2 = new RecordtypeIds__c(name = 'LATAM Renewal Opportunity', recTypeId__c='01213000000AXGKAA4');
        insert rt2;
        RecordtypeIds__c rt3 = new RecordtypeIds__c(name = 'GLI Pipeline Opportunity', recTypeId__c='012e00000000wRJAAY');
        insert rt3;
        
        recordtype accountRT = [select id from recordtype where name ='GLI Account' and sobjecttype='Account' limit 1];
        recordtype opptyRT = [select id from recordtype where name ='GLI Pipeline Opportunity' and sobjecttype='Opportunity' limit 1];
        recordtype conRT = [select id from recordtype where name ='GLI Contact' and sobjecttype='Contact' limit 1];
        
        Profile adminProfile = [SELECT Id FROM profile WHERE name='System Administrator'];
        
        User gliUser;
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
        
        System.runAs(gliUser){
            
            //
            Account gliAccountB = UnitTest.getAccountInstance();
            gliAccountB.Name = 'Test Account';
            gliAccountB.Is_GLI__c = true;
            gliAccountB.RecordTypeId=accountRT.Id;
            //gliAccountB.OwnerId = gliUser.Id;
            insert gliAccountB;
            
            
            Account gliAccount = UnitTest.getAccountInstance();
            gliAccount.Name = 'Test Account Training Event';
            gliAccount.Is_GLI__c = true;
            gliAccount.RecordTypeId=accountRT.Id;
            //gliAccount.OwnerId = oUser.Id;
            insert gliAccount;
            
            
            Contact gliContact = UnitTest.getContactInstance(gliAccount.id);
            gliContact.RecordTypeId = conRT.Id;
            //gliContact.OwnerId = gliUser.Id;
            insert gliContact;
            UserTerritory oUserTerritory = [SELECT Id, TerritoryId, UserId FROM UserTerritory WHERE IsActive=true AND UserId !=null  LIMIT 1];
            UserTerritory oUserTerritory2 = [SELECT Id, TerritoryId, UserId FROM UserTerritory WHERE Id !=:oUserTerritory.Id AND IsActive=true AND UserId != null LIMIT 1];
            
            User oUser = [SELECT Id, Name FROM User WHERE Id=:oUserTerritory.UserId];
            oUser.isActive = true;
            update oUser;
            
            User oUser01 = [SELECT Id, Name FROM User WHERE Id=:oUserTerritory2.UserId];
            oUser01.isActive = true;
            update oUser01;
            
            Territory oTerritory = [SELECT Id, Name,District__c,ParentTerritoryId, Description, AccountAccessLevel, OpportunityAccessLevel, CaseAccessLevel, ContactAccessLevel, ForecastUserId, MayForecastManagerShare, CurrencyIsoCode, RestrictOpportunityTransfer, DeveloperName,TMS_Market_Segment_Desc__c, TMS_Market_Segment_ID__c, TMS_Parent_Territory_ID__c, TMS_Rep_Function_Desc__c, TMS_Rep_Function_ID__c, TMS_Sales_Force_Desc__c, TMS_Sales_Force_ID__c, TMS_Terr_Num__c, TMS_Territory_ID__c, TMS_New_Sales_Quota_Curr_Yr__c, TMS_Renewal_Sales_Quota_Curr_Yr__c, Region__c, TMS_Sales_Force_Code__c, TMS_Market_Segment_Code__c, TMS_Ref_Function_Code__c FROM Territory WHERE Id=:oUserTerritory.TerritoryId];
            
            Territory oTerritory2 = [SELECT Id, Name,District__c,ParentTerritoryId, Description, AccountAccessLevel, OpportunityAccessLevel, CaseAccessLevel, ContactAccessLevel, ForecastUserId, MayForecastManagerShare, CurrencyIsoCode, RestrictOpportunityTransfer, DeveloperName,TMS_Market_Segment_Desc__c, TMS_Market_Segment_ID__c, TMS_Parent_Territory_ID__c, TMS_Rep_Function_Desc__c, TMS_Rep_Function_ID__c, TMS_Sales_Force_Desc__c, TMS_Sales_Force_ID__c, TMS_Terr_Num__c, TMS_Territory_ID__c, TMS_New_Sales_Quota_Curr_Yr__c, TMS_Renewal_Sales_Quota_Curr_Yr__c, Region__c, TMS_Sales_Force_Code__c, TMS_Market_Segment_Code__c, TMS_Ref_Function_Code__c FROM Territory WHERE Id=:oUserTerritory2.TerritoryId];
            set<ID> oTerritoryID = new set<ID>();
            oTerritoryID.add(oTerritory.Id);
            oTerritoryID.add(oTerritory2.Id);
            system.assertEquals(oTerritoryID.size(),2);
            Group oGroup = [SELECT Id, RelatedId FROM Group WHERE RelatedId=:oTerritory.Id AND Type='Territory' LIMIT 1];
            Group oGroup2 = [SELECT Id, RelatedId FROM Group WHERE RelatedId=:oTerritory2.Id AND Type='Territory' LIMIT 1];
            
            
            System.assertEquals(gliContact.AccountId, gliAccount.id);
            List<AccountShare> accountsharelist = new List<AccountShare>();
            AccountShare oAccountShareA = new AccountShare();
            oAccountShareA.AccountId = gliAccount.Id;
            oAccountShareA.UserOrGroupId = oGroup.Id;
            accountsharelist.add(oAccountShareA);
            if(accountsharelist.size()>0){
                insert accountsharelist;            
            }
            
            List<AccountTeamMember> members = new list<AccountTeamMember>();
            members.add(New AccountTeamMember(AccountId = gliAccount.id, TeamMemberRole = 'ACC-Team-Mem', UserId= gliUser.Id));
            members.add(New AccountTeamMember(AccountId = gliAccountB.id, TeamMemberRole = 'ACC-Team-Mem', UserId= gliUser.Id));
            members.add(New AccountTeamMember(AccountId = gliAccount.id, TeamMemberRole = 'ACC-Team-Mem1', UserId= oUser.Id));
            members.add(New AccountTeamMember(AccountId = gliAccountB.id, TeamMemberRole = 'ACC-Team-Mem1', UserId= oUser.Id));
            
            insert members;
            List<TMS_Territory__c> TMs_Territorylst = new List<TMS_Territory__c>();
            TMS_Territory__c TMS_Terr =new TMS_Territory__c();
            TMS_Terr.Name = 'Test_created by SystemAdmin';
            TMS_Terr.Account__c = gliAccount.id;
            //TMS_Terr.ForecastUser__c=gliUser.Id;
            TMS_Terr.TMS_Sales_Force_Desc__c ='ACC';
            TMS_Terr.TMS_Market_Segment_Desc__c='Team';
            TMS_Terr.TMS_Rep_Function_Desc__c ='Mem';
            TMS_Terr.Territory_ID__c =oTerritory.id;
            //TMS_Terr.LCRM_AccountTeamMemberUserId__c = gliUser.id;
            TMS_Terr.TMS_Territory_Number__c ='1234';
            //TMS_Terr.LCRM_Account_team_role__c=members[0].TeamMemberRole;
            TMs_Territorylst.add(TMS_Terr);
            //insert TMS_Terr;
            TMS_Territory__c TMS_TerrRec =new TMS_Territory__c();
            TMS_TerrRec.Name = 'Test_created by SystemAdmin';
            TMS_TerrRec.Account__c = gliAccountB.id;
            TMS_TerrRec.TMS_Sales_Force_Desc__c ='ACC';
            TMS_TerrRec.Territory_ID__c =oTerritory.id;
            TMS_TerrRec.TMS_Market_Segment_Desc__c='Team';
            TMS_TerrRec.TMS_Rep_Function_Desc__c ='Mem';
            TMS_TerrRec.TMS_Territory_Number__c ='1234';
            //TMS_TerrRec.ForecastUser__c=gliUser.Id;
            TMs_Territorylst.add(TMS_TerrRec);
            
            TMS_Territory__c TMS_Terr1 =new TMS_Territory__c();
            TMS_Terr1.Name = 'Test_created by SystemAdmin';
            TMS_Terr1.Account__c = gliAccount.id;
            //TMS_Terr1.LCRM_AccountTeamMemberUserId__c = gliUser.id;
            TMS_Terr1.Territory_ID__c =oTerritory.id;
            TMS_Terr1.TMS_Sales_Force_Desc__c ='ACC';
            TMS_Terr1.TMS_Market_Segment_Desc__c='Team';
            TMS_Terr1.TMS_Rep_Function_Desc__c ='Mem1';
            TMS_Terr1.TMS_Territory_Number__c ='1234';
            //TMS_Terr.LCRM_Account_team_role__c  =  'Account Manager';
            TMs_Territorylst .add(TMS_Terr1);
            
            TMS_Territory__c TMS_TerrRec1 =new TMS_Territory__c();
            TMS_TerrRec1.Name = 'Test_created by SystemAdmin';
            TMS_TerrRec1.Account__c = gliAccountB.id;
            //TMS_TerrRec1.LCRM_AccountTeamMemberUserId__c = oUser.id;
            TMS_TerrRec1.TMS_Sales_Force_Desc__c ='ACC';
            TMS_Terr1.Territory_ID__c =oTerritory.id;
            TMS_TerrRec1.TMS_Market_Segment_Desc__c='Team';
            TMS_TerrRec1.TMS_Rep_Function_Desc__c ='Mem1';
            TMS_TerrRec1.TMS_Territory_Number__c ='123';
            TMs_Territorylst .add(TMS_TerrRec1);
            
            if(TMs_Territorylst.size()>0){
                insert TMs_Territorylst ;
            }  
            
            //TMs_Territorylst = [SELECT id,Account__c,TMS_Market_Segment_Desc__c,TMS_Rep_Function_Desc__c,TMS_Sales_Force_Desc__c,Territory_ID__c ,LCRM_Account_team_role__c 
            // FROM TMS_Territory__c ];
            
            system.assertEquals(TMs_Territorylst.size(),4);
            
            List<Opportunity> OpptyList = new  List<Opportunity>();
            Opportunity gliOpty = UnitTest.getOpportunityInstance(gliAccount.id);
            gliOpty.Name = 'Test Opportunity Training Event';
            gliOpty.Key_Contact__c = gliContact.id;
            gliOpty.Renewal_Flag__c = true;
            gliOpty.currencyIsoCode = 'USD';
            gliOpty.StageName = 'Needs Analysis';
            gliOpty.is_gli__c = true;
            gliOpty.LCRM_Status__c = 'Open';
            gliOpty.RecordTypeId = opptyRT.Id;
            gliOpty.CurrencyIsoCode = 'USD';
            gliOpty.Expiration_Date__c=Date.Today();
            gliOpty.OwnerId = oUser.Id;
            gliOpty.LCRM_Territory_Update_Timestamp__c=system.today();
            System.debug('gliOpty : '+gliOpty);
            OpptyList.add(gliOpty);
            //insert gliOpty;
            
            
            Opportunity gliOptyPendingCancel = UnitTest.getOpportunityInstance(gliAccountB.id);
            gliOptyPendingCancel.Name = 'Test Opportunity Training Event';
            gliOptyPendingCancel.Key_Contact__c = gliContact.id;
            gliOptyPendingCancel.Renewal_Flag__c = true;
            gliOptyPendingCancel.currencyIsoCode = 'USD';
            gliOptyPendingCancel.StageName = 'Needs Analysis';
            gliOptyPendingCancel.LCRM_Status__c = 'Open'; 
            //gliOptyPendingCancel.LCRM_Cancellation_Process__c = false;
            // gliOptyPendingCancel.LCRM_Cancellation_Approval_Status__c='Approved'; 
            gliOptyPendingCancel.is_gli__c = true;
            //gliOptyPendingCancel.LCRM_Sub_BU__c='UKI';
            gliOptyPendingCancel.RecordTypeId = opptyRT.Id;
            gliOptyPendingCancel.CurrencyIsoCode = 'USD';
            gliOptyPendingCancel.Expiration_Date__c=Date.Today();
            gliOptyPendingCancel.OwnerId = gliUser.Id;
            gliOptyPendingCancel.LCRM_Territory_Update_Timestamp__c=system.today();
            System.debug('gliOptyPendingCancel : '+gliOptyPendingCancel);
            OpptyList.add(gliOptyPendingCancel);
            
            //check size of Opportunity
            if(OpptyList.size()>0){
                insert OpptyList;
            }
            SYSTEM.assertEquals(OpptyList.size(), 2);
            Test.startTest();
            Opportunity oppRecord =[select id, OwnerId from Opportunity where is_gli__c= true limit 1];
            oppRecord.OwnerId= gliUser.id;
            update oppRecord;
            LCRMOpportunityTerritoryService.loggedinUserFlag =false;
            system.assertEquals(LCRMOpportunityTerritoryService.loggedinUserFlag, false);
            Test.stopTest();
        }  
    }
    
    
    public static testmethod void UnitTestStageError(){
        
        List<KeyValueListStore__c> lstOfKeyStore = new List<KeyValueListStore__c>();
        KeyValueListStore__c KeyvalueStore3 = new KeyValueListStore__c();
        KeyvalueStore3.Name= 'LCRMCheckInformaticaUser';
        KeyvalueStore3.TextValue__c = 'Informatica GLI Integration';
        lstOfKeyStore.add(KeyvalueStore3);
        KeyValueListStore__c KeyvalueStore = new KeyValueListStore__c();
        KeyvalueStore.Name = 'LCRM Oppty Reason';
        KeyvalueStore.TextValue__c = 'Billing System Cancellation';
        lstOfKeyStore.add(KeyvalueStore);
        
        KeyValueListStore__c KeyvalueStore1 = new KeyValueListStore__c();
        KeyvalueStore1.Name='LCRM Oppty Win Loss'; 
        KeyvalueStore1.TextValue__c = 'Lost';
        lstOfKeyStore.add(KeyvalueStore1);
        
        KeyValueListStore__c KeyvalueStore2 = new KeyValueListStore__c();
        KeyvalueStore2.Name= 'ANZUsersProfileId';
        KeyvalueStore2.TextValue__c = '00e30000001ZUki';
        lstOfKeyStore.add(KeyvalueStore2);
        
        
        
        KeyValueListStore__c KeyvalueStore4 = new KeyValueListStore__c();
        KeyvalueStore4.Name= 'LCRMOpptyTerritoryStageValues';
        KeyvalueStore4.TextValue__c = 'Contract Signed,Order Complete,Closed Lost';
        lstOfKeyStore.add(KeyvalueStore4);
        //End Opportunity
        
        if(lstOfKeyStore.size()>0){ 
            insert lstOfKeyStore;
        }
        //
        RecordtypeIds__c rt = new RecordtypeIds__c(name = 'Pre-Pipeline Opportunities', recTypeId__c='01230000001MA4hAAG');
        insert rt;
        RecordtypeIds__c rt1 = new RecordtypeIds__c(name = 'Pipeline Opportunities', recTypeId__c='01230000001MA4gAAG');
        insert rt1;
        RecordtypeIds__c rt2 = new RecordtypeIds__c(name = 'LATAM Renewal Opportunity', recTypeId__c='01213000000AXGKAA4');
        insert rt2;
        RecordtypeIds__c rt3 = new RecordtypeIds__c(name = 'GLI Pipeline Opportunity', recTypeId__c='012e00000000wRJAAY');
        insert rt3;
        
        recordtype accountRT = [select id from recordtype where name ='GLI Account' and sobjecttype='Account' limit 1];
        recordtype opptyRT = [select id from recordtype where name ='GLI Pipeline Opportunity' and sobjecttype='Opportunity' limit 1];
        recordtype conRT = [select id from recordtype where name ='GLI Contact' and sobjecttype='Contact' limit 1];
        
        Profile adminProfile = [SELECT Id FROM profile WHERE name='System Administrator'];
        
        User gliUser;
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
        
        System.runAs(gliUser){
            
            //
            Account gliAccountB = UnitTest.getAccountInstance();
            gliAccountB.Name = 'Test Account';
            gliAccountB.Is_GLI__c = true;
            gliAccountB.RecordTypeId=accountRT.Id;
            //gliAccountB.OwnerId = gliUser.Id;
            insert gliAccountB;
            
            
            Account gliAccount = UnitTest.getAccountInstance();
            gliAccount.Name = 'Test Account Training Event';
            gliAccount.Is_GLI__c = true;
            gliAccount.RecordTypeId=accountRT.Id;
            //gliAccount.OwnerId = oUser.Id;
            insert gliAccount;
            
            
            Contact gliContact = UnitTest.getContactInstance(gliAccount.id);
            gliContact.RecordTypeId = conRT.Id;
            //gliContact.OwnerId = gliUser.Id;
            insert gliContact;
            UserTerritory oUserTerritory = [SELECT Id, TerritoryId, UserId FROM UserTerritory WHERE IsActive=true AND UserId !=null  LIMIT 1];
            UserTerritory oUserTerritory2 = [SELECT Id, TerritoryId, UserId FROM UserTerritory WHERE Id !=:oUserTerritory.Id AND IsActive=true AND UserId != null LIMIT 1];
            
            User oUser = [SELECT Id, Name FROM User WHERE Id=:oUserTerritory.UserId];
            oUser.isActive = true;
            update oUser;
            
            User oUser01 = [SELECT Id, Name FROM User WHERE Id=:oUserTerritory2.UserId];
            oUser01.isActive = true;
            update oUser01;
            
            Territory oTerritory = [SELECT Id, Name,District__c,ParentTerritoryId, Description, AccountAccessLevel, OpportunityAccessLevel, CaseAccessLevel, ContactAccessLevel, ForecastUserId, MayForecastManagerShare, CurrencyIsoCode, RestrictOpportunityTransfer, DeveloperName,TMS_Market_Segment_Desc__c, TMS_Market_Segment_ID__c, TMS_Parent_Territory_ID__c, TMS_Rep_Function_Desc__c, TMS_Rep_Function_ID__c, TMS_Sales_Force_Desc__c, TMS_Sales_Force_ID__c, TMS_Terr_Num__c, TMS_Territory_ID__c, TMS_New_Sales_Quota_Curr_Yr__c, TMS_Renewal_Sales_Quota_Curr_Yr__c, Region__c, TMS_Sales_Force_Code__c, TMS_Market_Segment_Code__c, TMS_Ref_Function_Code__c FROM Territory WHERE Id=:oUserTerritory.TerritoryId];
            
            Territory oTerritory2 = [SELECT Id, Name,District__c,ParentTerritoryId, Description, AccountAccessLevel, OpportunityAccessLevel, CaseAccessLevel, ContactAccessLevel, ForecastUserId, MayForecastManagerShare, CurrencyIsoCode, RestrictOpportunityTransfer, DeveloperName,TMS_Market_Segment_Desc__c, TMS_Market_Segment_ID__c, TMS_Parent_Territory_ID__c, TMS_Rep_Function_Desc__c, TMS_Rep_Function_ID__c, TMS_Sales_Force_Desc__c, TMS_Sales_Force_ID__c, TMS_Terr_Num__c, TMS_Territory_ID__c, TMS_New_Sales_Quota_Curr_Yr__c, TMS_Renewal_Sales_Quota_Curr_Yr__c, Region__c, TMS_Sales_Force_Code__c, TMS_Market_Segment_Code__c, TMS_Ref_Function_Code__c FROM Territory WHERE Id=:oUserTerritory2.TerritoryId];
            set<ID> oTerritoryID = new set<ID>();
            oTerritoryID.add(oTerritory.Id);
            oTerritoryID.add(oTerritory2.Id);
            system.assertEquals(oTerritoryID.size(),2);
            Group oGroup = [SELECT Id, RelatedId FROM Group WHERE RelatedId=:oTerritory.Id AND Type='Territory' LIMIT 1];
            Group oGroup2 = [SELECT Id, RelatedId FROM Group WHERE RelatedId=:oTerritory2.Id AND Type='Territory' LIMIT 1];
            
            
            System.assertEquals(gliContact.AccountId, gliAccount.id);
            List<AccountShare> accountsharelist = new List<AccountShare>();
            AccountShare oAccountShareA = new AccountShare();
            oAccountShareA.AccountId = gliAccount.Id;
            oAccountShareA.UserOrGroupId = oGroup.Id;
            accountsharelist.add(oAccountShareA);
            if(accountsharelist.size()>0){
                insert accountsharelist;            
            }
            
            List<AccountTeamMember> members = new list<AccountTeamMember>();
            members.add(New AccountTeamMember(AccountId = gliAccount.id, TeamMemberRole = 'ACC-Team-Mem', UserId= gliUser.Id));
            members.add(New AccountTeamMember(AccountId = gliAccountB.id, TeamMemberRole = 'ACC-Team-Mem', UserId= gliUser.Id));
            members.add(New AccountTeamMember(AccountId = gliAccount.id, TeamMemberRole = 'ACC-Team-Mem1', UserId= oUser.Id));
            members.add(New AccountTeamMember(AccountId = gliAccountB.id, TeamMemberRole = 'ACC-Team-Mem1', UserId= oUser.Id));
            
            insert members;
            List<TMS_Territory__c> TMs_Territorylst = new List<TMS_Territory__c>();
            TMS_Territory__c TMS_Terr =new TMS_Territory__c();
            TMS_Terr.Name = 'Test_created by SystemAdmin';
            TMS_Terr.Account__c = gliAccount.id;
            //TMS_Terr.ForecastUser__c=gliUser.Id;
            TMS_Terr.TMS_Sales_Force_Desc__c ='ACC';
            TMS_Terr.TMS_Market_Segment_Desc__c='Team';
            TMS_Terr.TMS_Rep_Function_Desc__c ='Mem';
            TMS_Terr.Territory_ID__c =oTerritory.id;
            //TMS_Terr.LCRM_AccountTeamMemberUserId__c = gliUser.id;
            TMS_Terr.TMS_Territory_Number__c ='1234';
            //TMS_Terr.LCRM_Account_team_role__c=members[0].TeamMemberRole;
            TMs_Territorylst.add(TMS_Terr);
            //insert TMS_Terr;
            TMS_Territory__c TMS_TerrRec =new TMS_Territory__c();
            TMS_TerrRec.Name = 'Test_created by SystemAdmin';
            TMS_TerrRec.Account__c = gliAccountB.id;
            TMS_TerrRec.TMS_Sales_Force_Desc__c ='ACC';
            TMS_TerrRec.Territory_ID__c =oTerritory.id;
            TMS_TerrRec.TMS_Market_Segment_Desc__c='Team';
            TMS_TerrRec.TMS_Rep_Function_Desc__c ='Mem';
            TMS_TerrRec.TMS_Territory_Number__c ='1234';
            //TMS_TerrRec.ForecastUser__c=gliUser.Id;
            TMs_Territorylst.add(TMS_TerrRec);
            
            TMS_Territory__c TMS_Terr1 =new TMS_Territory__c();
            TMS_Terr1.Name = 'Test_created by SystemAdmin';
            TMS_Terr1.Account__c = gliAccount.id;
            //TMS_Terr1.LCRM_AccountTeamMemberUserId__c = gliUser.id;
            TMS_Terr1.Territory_ID__c =oTerritory.id;
            TMS_Terr1.TMS_Sales_Force_Desc__c ='ACC';
            TMS_Terr1.TMS_Market_Segment_Desc__c='Team';
            TMS_Terr1.TMS_Rep_Function_Desc__c ='Mem1';
            TMS_Terr1.TMS_Territory_Number__c ='1234';
            //TMS_Terr.LCRM_Account_team_role__c  =  'Account Manager';
            TMs_Territorylst .add(TMS_Terr1);
            
            TMS_Territory__c TMS_TerrRec1 =new TMS_Territory__c();
            TMS_TerrRec1.Name = 'Test_created by SystemAdmin';
            TMS_TerrRec1.Account__c = gliAccountB.id;
            //TMS_TerrRec1.LCRM_AccountTeamMemberUserId__c = oUser.id;
            TMS_TerrRec1.TMS_Sales_Force_Desc__c ='ACC';
            TMS_Terr1.Territory_ID__c =oTerritory.id;
            TMS_TerrRec1.TMS_Market_Segment_Desc__c='Team';
            TMS_TerrRec1.TMS_Rep_Function_Desc__c ='Mem1';
            TMS_TerrRec1.TMS_Territory_Number__c ='123';
            TMs_Territorylst .add(TMS_TerrRec1);
            
            if(TMs_Territorylst.size()>0){
                insert TMs_Territorylst ;
            }  
            
            //TMs_Territorylst = [SELECT id,Account__c,TMS_Market_Segment_Desc__c,TMS_Rep_Function_Desc__c,TMS_Sales_Force_Desc__c,Territory_ID__c ,LCRM_Account_team_role__c 
            // FROM TMS_Territory__c ];
            
            system.assertEquals(TMs_Territorylst.size(),4);
            
            List<Opportunity> OpptyList = new  List<Opportunity>();
            Opportunity gliOpty = UnitTest.getOpportunityInstance(gliAccount.id);
            gliOpty.Name = 'Test Opportunity Training Event';
            gliOpty.Key_Contact__c = gliContact.id;
            gliOpty.Renewal_Flag__c = true;
            gliOpty.currencyIsoCode = 'USD';
            gliOpty.StageName = 'Closed Lost';
            gliOpty.Win_Loss__c  = 'Lost';
      gliOpty.Reason__c = 'Billing/Invoicing Problem';
            gliOpty.is_gli__c = true;
            gliOpty.LCRM_Status__c = 'Open';
            gliOpty.RecordTypeId = opptyRT.Id;
            gliOpty.CurrencyIsoCode = 'USD';
            gliOpty.Expiration_Date__c=Date.Today();
            gliOpty.OwnerId = oUser.Id;
            gliOpty.LCRM_Territory_Update_Timestamp__c=system.today();
            System.debug('gliOpty : '+gliOpty);
            OpptyList.add(gliOpty);
            //insert gliOpty;
            
            
            Opportunity gliOptyPendingCancel = UnitTest.getOpportunityInstance(gliAccountB.id);
            gliOptyPendingCancel.Name = 'Test Opportunity Training Event';
            gliOptyPendingCancel.Key_Contact__c = gliContact.id;
            gliOptyPendingCancel.Renewal_Flag__c = true;
            gliOptyPendingCancel.currencyIsoCode = 'USD';
            gliOptyPendingCancel.StageName = 'Needs Analysis';
            gliOptyPendingCancel.LCRM_Status__c = 'Open'; 
            //gliOptyPendingCancel.LCRM_Cancellation_Process__c = false;
            // gliOptyPendingCancel.LCRM_Cancellation_Approval_Status__c='Approved'; 
            gliOptyPendingCancel.is_gli__c = true;
            //gliOptyPendingCancel.LCRM_Sub_BU__c='UKI';
            gliOptyPendingCancel.RecordTypeId = opptyRT.Id;
            gliOptyPendingCancel.CurrencyIsoCode = 'USD';
            gliOptyPendingCancel.Expiration_Date__c=Date.Today();
            gliOptyPendingCancel.OwnerId = gliUser.Id;
            gliOptyPendingCancel.LCRM_Territory_Update_Timestamp__c=system.today();
            System.debug('gliOptyPendingCancel : '+gliOptyPendingCancel);
            OpptyList.add(gliOptyPendingCancel);
            
            //check size of Opportunity
            if(OpptyList.size()>0){
                insert OpptyList;
            }
            SYSTEM.assertEquals(OpptyList.size(), 2);
            Test.startTest();
            Opportunity oppRecord =[select id, OwnerId from Opportunity where is_gli__c= true limit 1];
            oppRecord.OwnerId= gliUser.id;
            update oppRecord;
            LCRMOpportunityTerritoryService.loggedinUserFlag =false;
            system.assertEquals(LCRMOpportunityTerritoryService.loggedinUserFlag, false);
            Test.stopTest();
        }  
    }
    
    static testMethod void testOpptyTerrBatch(){
        List<KeyValueListStore__c> lstOfKeyStore = new List<KeyValueListStore__c>();
        KeyValueListStore__c KeyvalueStore3 = new KeyValueListStore__c();
        KeyvalueStore3.Name= 'LCRMCheckInformaticaUser';
        KeyvalueStore3.TextValue__c = 'Test Informatica GLI Integration';
        lstOfKeyStore.add(KeyvalueStore3);
        KeyValueListStore__c KeyvalueStore = new KeyValueListStore__c();
        KeyvalueStore.Name = 'LCRM Oppty Reason';
        KeyvalueStore.TextValue__c = 'Billing System Cancellation';
        lstOfKeyStore.add(KeyvalueStore);
        
        KeyValueListStore__c KeyvalueStore1 = new KeyValueListStore__c();
        KeyvalueStore1.Name='LCRM Oppty Win Loss'; 
        KeyvalueStore1.TextValue__c = 'Lost';
        lstOfKeyStore.add(KeyvalueStore1);
        
        KeyValueListStore__c KeyvalueStore2 = new KeyValueListStore__c();
        KeyvalueStore2.Name= 'ANZUsersProfileId';
        KeyvalueStore2.TextValue__c = '00e30000001ZUki';
        lstOfKeyStore.add(KeyvalueStore2);
        
        
        KeyValueListStore__c KeyvalueStore4 = new KeyValueListStore__c();
        KeyvalueStore4.Name= 'LCRMOpptyTerritoryStageValues';
        KeyvalueStore4.TextValue__c = 'Contract Signed,Order Complete,Closed Lost';
        lstOfKeyStore.add(KeyvalueStore4);
        //End Opportunity
        
        if(lstOfKeyStore.size()>0){ 
            insert lstOfKeyStore;
        }
        
        GLI_Load_Tracker__c gliloadtracker = new GLI_Load_Tracker__c();
        gliloadtracker.name = 'Opportunity Assignment';           
        gliloadtracker.JobCompletedDate__c= datetime.newInstance(2017, 9, 16, 12, 30, 0);
        gliloadtracker.LCRMOpportunityStartDate__c = datetime.newInstance(2017, 9, 15, 12, 30, 0);
        Insert gliloadtracker;
        
        RecordtypeIds__c rt = new RecordtypeIds__c(name = 'Pre-Pipeline Opportunities', recTypeId__c='01230000001MA4hAAG');
        insert rt;
        RecordtypeIds__c rt1 = new RecordtypeIds__c(name = 'Pipeline Opportunities', recTypeId__c='01230000001MA4gAAG');
        insert rt1;
        RecordtypeIds__c rt2 = new RecordtypeIds__c(name = 'LATAM Renewal Opportunity', recTypeId__c='01213000000AXGKAA4');
        insert rt2;
        RecordtypeIds__c rt3 = new RecordtypeIds__c(name = 'GLI Pipeline Opportunity', recTypeId__c='012e00000000wRJAAY');
        insert rt3;
        
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        
        User u = new User(Alias = 'test', Email='testuser@thomsonreuters.com',EmailEncodingKey ='UTF-8', LastName ='Test Informatica Gli Integration', LanguageLocaleKey='en_US',LocaleSidKey='en_US', ProfileId = p.Id,TimeZoneSidKey='America/Los_Angeles',UserName='testuser@trpcorelegal.com',Sub_Bu__c ='USL',Sales_Org__c = 'West');
        insert u;
        
        
        
        recordtype leadRt= [select id from recordtype where name ='GLI' and sobjecttype='Lead' limit 1];
        recordtype accountRT = [select id from recordtype where name ='GLI Account' and sobjecttype='Account' limit 1];
        recordtype opptyRT = [select id from recordtype where name ='GLI Pipeline Opportunity' and sobjecttype='Opportunity' limit 1];
        
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
        
        System.runas(u){
            UserTerritory oUserTerritory = [SELECT Id, TerritoryId, UserId FROM UserTerritory WHERE IsActive=true AND UserId !=null  LIMIT 1];
            UserTerritory oUserTerritory2 = [SELECT Id, TerritoryId, UserId FROM UserTerritory WHERE Id !=:oUserTerritory.Id AND IsActive=true AND UserId != null LIMIT 1];
            
            User oUser = [SELECT Id, Name FROM User WHERE Id=:oUserTerritory.UserId];
            oUser.isActive = true;
            update oUser;
            
            User oUser01 = [SELECT Id, Name FROM User WHERE Id=:oUserTerritory2.UserId];
            oUser01.isActive = true;
            update oUser01;
            
            Territory oTerritory = [SELECT Id, Name,District__c,ParentTerritoryId, Description, AccountAccessLevel, OpportunityAccessLevel, CaseAccessLevel, ContactAccessLevel, ForecastUserId, MayForecastManagerShare, CurrencyIsoCode, RestrictOpportunityTransfer, DeveloperName,TMS_Market_Segment_Desc__c, TMS_Market_Segment_ID__c, TMS_Parent_Territory_ID__c, TMS_Rep_Function_Desc__c, TMS_Rep_Function_ID__c, TMS_Sales_Force_Desc__c, TMS_Sales_Force_ID__c, TMS_Terr_Num__c, TMS_Territory_ID__c, TMS_New_Sales_Quota_Curr_Yr__c, TMS_Renewal_Sales_Quota_Curr_Yr__c, Region__c, TMS_Sales_Force_Code__c, TMS_Market_Segment_Code__c, TMS_Ref_Function_Code__c FROM Territory WHERE Id=:oUserTerritory.TerritoryId];
            Territory oTerritory2 = [SELECT Id, Name,District__c,ParentTerritoryId, Description, AccountAccessLevel, OpportunityAccessLevel, CaseAccessLevel, ContactAccessLevel, ForecastUserId, MayForecastManagerShare, CurrencyIsoCode, RestrictOpportunityTransfer, DeveloperName,TMS_Market_Segment_Desc__c, TMS_Market_Segment_ID__c, TMS_Parent_Territory_ID__c, TMS_Rep_Function_Desc__c, TMS_Rep_Function_ID__c, TMS_Sales_Force_Desc__c, TMS_Sales_Force_ID__c, TMS_Terr_Num__c, TMS_Territory_ID__c, TMS_New_Sales_Quota_Curr_Yr__c, TMS_Renewal_Sales_Quota_Curr_Yr__c, Region__c, TMS_Sales_Force_Code__c, TMS_Market_Segment_Code__c, TMS_Ref_Function_Code__c FROM Territory WHERE Id=:oUserTerritory2.TerritoryId];
            
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
                insert accountsharelist;            
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
            //TMS_Terr.LCRM_AccountTeamMemberUserId__c = u.id;
            TMS_Terr.Territory_ID__c =oTerritory.id;
            TMS_Terr.TMS_Sales_Force_Desc__c ='ACC';
            TMS_Terr.TMS_Market_Segment_Desc__c='Team';
            TMS_Terr.TMS_Rep_Function_Desc__c ='Mem';
            TMS_Terr.TMS_Territory_Number__c ='1234';
            lstTMsTerritory .add(TMS_Terr);
            
            TMS_Territory__c TMS_TerrRec =new TMS_Territory__c();
            TMS_TerrRec.Name = 'Test_created by SystemAdmin';
            TMS_TerrRec.Account__c = gliAccountB.id;
            //TMS_TerrRec.LCRM_AccountTeamMemberUserId__c = u.id;
            TMS_TerrRec.TMS_Sales_Force_Desc__c ='ACC';
            TMS_Terr.Territory_ID__c =oTerritory.id;
            TMS_TerrRec.TMS_Market_Segment_Desc__c='Team';
            TMS_TerrRec.TMS_Rep_Function_Desc__c ='Mem';
            TMS_TerrRec.TMS_Territory_Number__c ='12345';
            lstTMsTerritory .add(TMS_TerrRec);
            
            TMS_Territory__c TMS_Terr1 =new TMS_Territory__c();
            TMS_Terr1.Name = 'Test_created by SystemAdmin';
            TMS_Terr1.Account__c = gliAccount.id;
            //TMS_Terr1.LCRM_AccountTeamMemberUserId__c = oUser.id;
            TMS_Terr1.Territory_ID__c =oTerritory.id;
            TMS_Terr1.TMS_Sales_Force_Desc__c ='ACC';
            TMS_Terr1.TMS_Market_Segment_Desc__c='Team';
            TMS_Terr1.TMS_Rep_Function_Desc__c ='Mem1';
            TMS_Terr1.TMS_Territory_Number__c ='1234';
            lstTMsTerritory .add(TMS_Terr1);
            
            TMS_Territory__c TMS_TerrRec1 =new TMS_Territory__c();
            TMS_TerrRec1.Name = 'Test_created by SystemAdmin';
            TMS_TerrRec1.Account__c = gliAccountB.id;
            //TMS_TerrRec1.LCRM_AccountTeamMemberUserId__c = oUser.id;
            TMS_TerrRec1.TMS_Sales_Force_Desc__c ='ACC';
            TMS_TerrRec1.Territory_ID__c =oTerritory.id;
            TMS_TerrRec1.TMS_Market_Segment_Desc__c='Team';
            TMS_TerrRec1.TMS_Rep_Function_Desc__c ='Mem1';
            TMS_TerrRec1.TMS_Territory_Number__c ='123';
            lstTMsTerritory .add(TMS_TerrRec1);
            
            if(lstTMsTerritory.size()>0)
            {
                insert lstTMsTerritory ;
            } 
            
            List<TMS_Territory__c > lsttmsterri =[Select Id,Name  from TMS_Territory__c  ];
            System.assertEquals(lsttmsterri .size(),4);
            
            
            Opportunity gliOpty = UnitTest.getOpportunityInstance(gliAccount.id);
            gliOpty.Name = 'Test Opportunity Batch Oppty';
            //gliOpty.Key_Contact__c = gliContact.id;
            gliOpty.Renewal_Flag__c = false;
            gliOpty.currencyIsoCode = 'USD';
            gliOpty.StageName = 'Needs Analysis';
            gliOpty.is_gli__c = true;
            //gliOpty.LCRM_Sub_BU__c='UKI';
            gliOpty.RecordTypeId = opptyRT.Id;
            gliOpty.CurrencyIsoCode = 'USD';
            gliOpty.closedate=Date.Today()+5;
            gliOpty.OwnerId = oUser.Id;
            System.debug('gliOpty : '+gliOpty);
            insert gliOpty;
            
            Test.startTest();
            Opportunity oppRecord =[select id, OwnerId,Name,territoryid from Opportunity where is_gli__c= true AND Name = 'Test Opportunity Batch Oppty' limit 1];
            //update oppRecord;
            
            
            UPDATE gliloadtracker;
            LcrmOpptyTerrIdUpdateBatch oLcrmOpptyTerrIdUpdateBatch= new LcrmOpptyTerrIdUpdateBatch();
            LCRMOpportunityTerritoryService.loggedinUserFlag =true;
            Database.executeBatch(oLcrmOpptyTerrIdUpdateBatch, 100);
            
            
            
            
            Test.stopTest();
            
        }
        
    }
    
 
 */   
    
    
}