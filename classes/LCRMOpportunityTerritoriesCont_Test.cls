//Commenting out as a part of removal of TM1.0 components

@isTest
Public class LCRMOpportunityTerritoriesCont_Test{

/*
*@Created by Radhika Pawar for LCRMOpportunityTerritoriesController
*/    
    public static testmethod void unitTest(){
    LCRMOpportunityTerritoriesController obj = new LCRMOpportunityTerritoriesController();}
        /*KeyValueListStore__c keyValue = new KeyValueListStore__c(name='ANZUsersProfileId', TextValue__c = '00e30000001ZUki');
        insert keyValue;
            // KeyValueListStore__c Insert All for update Some Fields When Oppty Closed Lost
            List<KeyValueListStore__c> lstOfKeyStore = new List<KeyValueListStore__c>();
        //For Opportunity
        KeyValueListStore__c KeyvalueStore = new KeyValueListStore__c();
        KeyvalueStore.Name = 'LCRM Oppty Reason';
        KeyvalueStore.TextValue__c = 'Billing System Cancellation';
        lstOfKeyStore.add(KeyvalueStore);

        KeyValueListStore__c KeyvalueStore1 = new KeyValueListStore__c();
        KeyvalueStore1.Name='LCRM Oppty Win Loss'; 
        KeyvalueStore1.TextValue__c = 'Lost';
        lstOfKeyStore.add(KeyvalueStore1);

        KeyValueListStore__c KeyvalueStore2 = new KeyValueListStore__c();
        KeyvalueStore2.Name= 'LCRM Oppty Competitor?';
        KeyvalueStore2.TextValue__c = 'No';
        lstOfKeyStore.add(KeyvalueStore2);
        //End Opportunity

        //For Task type
        KeyValueListStore__c KeyTaskvalueSt = new KeyValueListStore__c();
        KeyTaskvalueSt.name='LCRM Task Type';
        KeyTaskvalueSt.TextValue__c='To Do';
        lstOfKeyStore.add(KeyTaskvalueSt);
        //Task Status
        KeyValueListStore__c KeyTaskstatusval = new KeyValueListStore__c();
        KeyTaskstatusval.name='LCRM Task Status';
        KeyTaskstatusval.TextValue__c='In Progress';
        lstOfKeyStore.add(KeyTaskstatusval);
        //Task Subject
        KeyValueListStore__c KeyTaskSubval = new KeyValueListStore__c();
        KeyTaskSubval.name='LCRM Task Subject';
        KeyTaskSubval.TextValue__c='Please update Customer Cancellation Reason and optional Competitor information on the Opportunity Win/Loss information.';
        lstOfKeyStore.add(KeyTaskSubval);
        //Task Priority
        KeyValueListStore__c KeyTaskPrival = new KeyValueListStore__c();
        KeyTaskPrival.name='LCRM Task Priority';
        KeyTaskPrival.TextValue__c='Normal';
        lstOfKeyStore.add(KeyTaskPrival);
        //Task Value End
        //OpportunityLineIteam Action
        KeyValueListStore__c KeyOpptyProdActionVal = new KeyValueListStore__c();
        KeyOpptyProdActionVal.name='LCRM Oppty Prod Action';
        KeyOpptyProdActionVal.TextValue__c='Cancel';
        lstOfKeyStore.add(KeyOpptyProdActionVal);
        //OpportunityLineIteam LCRM_Cancel_Reason

        KeyValueListStore__c KeyOpptyProdRes = new KeyValueListStore__c();
        KeyOpptyProdRes.name='LCRM Oppty Prod CancelReason';
        KeyOpptyProdRes.TextValue__c='Billing System Cancellation';
        lstOfKeyStore.add(KeyOpptyProdRes);
        
        KeyValueListStore__c KeyTaskPrival1 = new KeyValueListStore__c();
        KeyTaskPrival1.name='ReasonWithCompetitor';
        KeyTaskPrival1.TextValue__c='Price';
        lstOfKeyStore.add(KeyTaskPrival1);
        //End OpportunityLine Iteam

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
        profile_list__c plist = new profile_list__c(name = 'Partner Portal User',Profile_Name__c='Partner Portal User',ProfileId__c = '00ea00000024JwaAAE');
        insert plist;
        
        //
        Product2 testProd =UnitTest.getProductInstance();
        insert testProd;        
        //Standard PricebookEntry 
        PricebookEntry testEntry = new PricebookEntry(CurrencyIsoCode='USD',isactive=true,Pricebook2id=Test.getStandardPricebookId(),Product2Id=testProd.id,unitprice=1,UseStandardPrice=false);
        insert testEntry;        
        Pricebook2 customPB = new Pricebook2(Name='Custom Pricebook', isActive=true);
        insert customPB;        
        //Custom PricebookEntry
        PricebookEntry testEntry1 = new PricebookEntry(CurrencyIsoCode='USD',isactive=true,Pricebook2id=customPB.Id,Product2Id=testProd.id,unitprice=1,UseStandardPrice=false);
        insert testEntry1;        
        //
         System.assertEquals(testEntry1.pricebook2id, customPB.id);
        //
        recordtype accountRT = [select id from recordtype where name ='GLI Account' and sobjecttype='Account' limit 1];
        recordtype opptyRT = [select id from recordtype where name ='GLI Pipeline Opportunity' and sobjecttype='Opportunity' limit 1];
        recordtype conRT = [select id from recordtype where name ='GLI Contact' and sobjecttype='Contact' limit 1];
       
        Profile ukiProfile = [SELECT Id FROM profile WHERE name='UKI Users'];
        UserRole ukiRole = [SELECT Id FROM UserRole WHERE Name = 'Legal'];
        PermissionSet trainingPermissionSet = [SELECT Id FROM PermissionSet WHERE name='LCRM_GLI_Training_Users']; 
        
        User gliUser;
        System.runAs(new User(Id=UserInfo.getUserId())){       
            gliUser = UnitTest.getUserInstance();
            gliUser.Username = 'TestUser1@TR.com';
            gliUser.profileid = ukiProfile.Id;
            gliUser.UserRoleId = ukiRole.Id;
            gliUser.Sub_Bu__c = 'UKI';
            insert gliUser;
        
            }
       
        Account gliAccount = UnitTest.getAccountInstance();
        gliAccount.Name = 'Test Account Training Event';
        gliAccount.Is_GLI__c = true;
        gliAccount.RecordTypeId=accountRT.Id;
        gliAccount.OwnerId = gliUser.Id;
        insert gliAccount;
        
        //
         Account gliAccountB = UnitTest.getAccountInstance();
        gliAccountB.Name = 'Test Account';
        gliAccountB.Is_GLI__c = true;
        gliAccountB.RecordTypeId=accountRT.Id;
        gliAccountB.OwnerId = gliUser.Id;
        insert gliAccountB;
        
        Contact gliContact = UnitTest.getContactInstance(gliAccount.id);
        gliContact.RecordTypeId = conRT.Id;
        gliContact.OwnerId = gliUser.Id;
        insert gliContact;
        
        System.assertEquals(gliContact.AccountId, gliAccount.id);
        
        /*UserTerritory oUserTerritory = [SELECT Id, TerritoryId, UserId FROM UserTerritory WHERE IsActive=true LIMIT 1];
        UserTerritory oUserTerritory2 = [SELECT Id, TerritoryId, UserId FROM UserTerritory WHERE Id !=:oUserTerritory.Id AND IsActive=true LIMIT 1];
        
        User oUser = [SELECT Id, Name FROM User WHERE Id=:oUserTerritory.UserId];
        
        Territory oTerritory = [SELECT Id, Name,District__c,ParentTerritoryId, Description, AccountAccessLevel, OpportunityAccessLevel, CaseAccessLevel, ContactAccessLevel, ForecastUserId, MayForecastManagerShare, CurrencyIsoCode, RestrictOpportunityTransfer, DeveloperName,TMS_Market_Segment_Desc__c, TMS_Market_Segment_ID__c, TMS_Parent_Territory_ID__c, TMS_Rep_Function_Desc__c, TMS_Rep_Function_ID__c, TMS_Sales_Force_Desc__c, TMS_Sales_Force_ID__c, TMS_Terr_Num__c, TMS_Territory_ID__c, TMS_New_Sales_Quota_Curr_Yr__c, TMS_Renewal_Sales_Quota_Curr_Yr__c, Region__c, TMS_Sales_Force_Code__c, TMS_Market_Segment_Code__c, TMS_Ref_Function_Code__c FROM Territory WHERE Id=:oUserTerritory.TerritoryId];
        
        Territory oTerritory2 = [SELECT Id, Name,District__c,ParentTerritoryId, Description, AccountAccessLevel, OpportunityAccessLevel, CaseAccessLevel, ContactAccessLevel, ForecastUserId, MayForecastManagerShare, CurrencyIsoCode, RestrictOpportunityTransfer, DeveloperName,TMS_Market_Segment_Desc__c, TMS_Market_Segment_ID__c, TMS_Parent_Territory_ID__c, TMS_Rep_Function_Desc__c, TMS_Rep_Function_ID__c, TMS_Sales_Force_Desc__c, TMS_Sales_Force_ID__c, TMS_Terr_Num__c, TMS_Territory_ID__c, TMS_New_Sales_Quota_Curr_Yr__c, TMS_Renewal_Sales_Quota_Curr_Yr__c, Region__c, TMS_Sales_Force_Code__c, TMS_Market_Segment_Code__c, TMS_Ref_Function_Code__c FROM Territory WHERE Id=:oUserTerritory2.TerritoryId];
        
        System.debug('oTerritory:-'+oTerritory);
        System.debug('oTerritory2:-'+oTerritory2);
        set<ID> oTerritoryID = new set<ID>();
        oTerritoryID.add(oTerritory.Id);
        oTerritoryID.add(oTerritory2.Id);
        
        Group oGroup = [SELECT Id, RelatedId FROM Group WHERE RelatedId=:oTerritory.Id AND Type='Territory' LIMIT 1];
        Group oGroup2 = [SELECT Id, RelatedId FROM Group WHERE RelatedId=:oTerritory2.Id AND Type='Territory' LIMIT 1];
        
        List<AccountShare> accountsharelist = new List<AccountShare>();
        AccountShare oAccountShareA = new AccountShare();
        oAccountShareA.AccountId = gliAccount.Id;
        oAccountShareA.UserOrGroupId = oGroup.Id;
        accountsharelist.add(oAccountShareA);
        if(accountsharelist.size()>0){
            insert accountsharelist;            
        }
        
        *
        List<Opportunity> OpptyList = new  List<Opportunity>();
        
        Opportunity gliOpty = UnitTest.getOpportunityInstance(gliAccount.id);
        gliOpty.Name = 'Test Opportunity Training Event';
        gliOpty.Key_Contact__c = gliContact.id;
        gliOpty.Renewal_Flag__c = true;
        gliOpty.currencyIsoCode = 'USD';
        gliOpty.StageName = 'Needs Analysis';
        gliOpty.LCRM_Status__c = 'Cancelled'; 
        gliOpty.Reason__c='Budget';
        
        gliOpty.Other_W_L_Reason__c='Budget';
        gliOpty.LCRM_Cancellation_Process__c = false;
        gliOpty.LCRM_Cancellation_Approval_Status__c='Approved'; 
        gliOpty.is_gli__c = true;
        gliOpty.LCRM_Sub_BU__c='UKI';
        gliOpty.RecordTypeId = opptyRT.Id;
        gliOpty.CurrencyIsoCode = 'USD';
        gliOpty.Expiration_Date__c=Date.Today();
        gliOpty.OwnerId = gliUser.Id;
        System.debug('gliOpty : '+gliOpty);
        OpptyList.add(gliOpty);
        //insert gliOpty;
           
        //
        
        //Opportunity Product   
        Opportunity gliOptyRenew = UnitTest.getOpportunityInstance(gliAccount.id);
        gliOptyRenew.Name = 'Oppty Renewal Cancellation';
        gliOptyRenew.Key_Contact__c = gliContact.id;
        gliOptyRenew.Renewal_Flag__c = true;
        gliOptyRenew.currencyIsoCode = 'USD';
        gliOptyRenew.StageName = 'Closed Lost'; 
        gliOptyRenew.Other_W_L_Reason__c='Budget';      
         //Commented as part of DPS-5353
        //gliOptyRenew.Win_Loss__c='Lost';
        gliOptyRenew.Reason__c='Other';
        gliOptyRenew.Was_There_a_Competitor__c ='No';
        gliOptyRenew.Win_Loss__c='Lost – Price';
        gliOptyRenew.LCRM_Status__c = 'Open'; 
        gliOptyRenew.LCRM_Cancellation_Process__c = false;
        gliOptyRenew.LCRM_Cancellation_Approval_Status__c='Approved'; 
        gliOptyRenew.is_gli__c = true;
        gliOptyRenew.LCRM_Sub_BU__c='UKI';
        gliOptyRenew.RecordTypeId = opptyRT.Id;
        gliOptyRenew.CurrencyIsoCode = 'USD';
        gliOptyRenew.Other_W_L_Reason__c='Other';
        gliOptyRenew.Expiration_Date__c=Date.Today();
        gliOptyRenew.OwnerId = gliUser.Id;
        System.debug('gliOptyRenew : '+gliOptyRenew);
        OpptyList.add(gliOptyRenew);
       
        //Pending Cancel Status
        Opportunity gliOptyPendingCancel = UnitTest.getOpportunityInstance(gliAccount.id);
        gliOptyPendingCancel.Name = 'Test Opportunity Training Event';
        gliOptyPendingCancel.Key_Contact__c = gliContact.id;
        gliOptyPendingCancel.Win_Loss__c='Lost – Price';
        gliOptyPendingCancel.Renewal_Flag__c = true;
        gliOptyPendingCancel.Reason__c='Other';
        gliOptyPendingCancel.Other_W_L_Reason__c='Budget';  
        gliOptyPendingCancel.currencyIsoCode = 'USD';
        gliOptyPendingCancel.StageName = 'Needs Analysis';
        gliOptyPendingCancel.LCRM_Status__c = 'Pending Cancel'; 
        gliOptyPendingCancel.LCRM_Cancellation_Process__c = false;
        gliOptyPendingCancel.LCRM_Cancellation_Approval_Status__c='Approved'; 
        gliOptyPendingCancel.is_gli__c = true;
        gliOptyPendingCancel.LCRM_Sub_BU__c='UKI';
        gliOptyPendingCancel.RecordTypeId = opptyRT.Id;
        gliOptyPendingCancel.CurrencyIsoCode = 'USD';
        gliOptyPendingCancel.Expiration_Date__c=Date.Today();
        gliOptyPendingCancel.OwnerId = gliUser.Id;
        System.debug('gliOptyPendingCancel : '+gliOptyPendingCancel);
        OpptyList.add(gliOptyPendingCancel);
       
        //check size of Opportunity
        if(OpptyList.size()>0){
           insert OpptyList;
        }
        System.debug('OpptyList:-'+OpptyList);
        //Opportunity Products 
        
        GLI_Load_Tracker__c gliloadtracker = new GLI_Load_Tracker__c();
        gliloadtracker.name = 'testload';
        gliloadtracker.JobCompletedDate__c= datetime.newInstance(2017, 9, 15, 12, 30, 0);
        Insert gliloadtracker;
        
        Test.StartTest();   
        UPDATE gliloadtracker;      
       // Test.StopTest();   

      //  List<TMS_Territory__c> TMs_Territorylst = [SELECT Id, Name, RestrictOpportunityTransfer__c, ParentTerritory__c, DeveloperName__c, ForecastUser__c, MayForecastManagerShare__c, Region__c, TMS_Market_Segment_Desc__c, TMS_Market_Segment_ID__c, TMS_New_Sales_Quota_Curr_Yr__c, TMS_Parent_Territory_ID__c, TMS_Renewal_Sales_Quota_Curr_Yr__c, TMS_Rep_Function_Desc__c, TMS_Rep_Function_ID__c, TMS_Sales_Force_Desc__c, TMS_Sales_Force_ID__c, TMS_Territory_ID__c, TMS_Territory_Number__c, Account__c, Territory_ID__c, District__c, AccountAccessLevel__c, CaseAccessLevel__c, ContactAccessLevel__c, Description__c, OpportunityAccessLevel__c, TMS_Sales_Force_Code__c, TMS_Market_Segment_Code__c, TMS_Ref_Function_Code__c FROM TMS_Territory__c where Territory_ID__c IN :oTerritoryID ];
        
        //System.debug('TMs_Territorylst:-'+TMs_Territorylst); 
        
        ApexPages.standardController sc = new ApexPages.standardController(gliOpty);
        LCRMOpportunityTerritoriesController controller = new LCRMOpportunityTerritoriesController(sc);
        
        
       }//End Of the UnitTest
/*
*@Created by Navjyoti
*    
    
    static void testMethod1(){
        
        Profile testprofile = [SELECT Id FROM Profile WHERE Name = 'GLI Sales User'];
          User testUser = new User(
            Alias = 'sUser',
            Email = 'abc1@testorg.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'Testing',
            LanguageLocaleKey = 'es',
            LocaleSidKey = 'es',
            ProfileId = testprofile.id,
            Sales_Org__c = 'WEST',
            Sub_Bu__c = 'USL',
            TimeZoneSidKey = 'America/Los_Angeles',
            UserName = 'abc123@testorg.com'
        );
        insert testUser;
        
        List<Account> Accountlst = new List<Account>();
        Account oAccountA = UnitTest.getAccountInstance();
        oAccountA.RecordTypeId = AccountUtil.CustomerRecordTypeId;
        Accountlst.add(oAccountA);
        
         if(Accountlst.size()>0){
        insert Accountlst;
        }
        
        List<Opportunity> opportunityList = new List<Opportunity>();
        Opportunity oOpty = UnitTest.getOpportunityInstance(oAccountA.Id);
        oOpty.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI_Pipeline_Opportunity').getRecordTypeId();
        //system.debug('@oOpty.RecordTypeId-->'+oOpty.RecordTypeId);
        opportunityList.add(oOpty);
        
         if(opportunityList.size()>0){
        insert opportunityList;
        }
        
    /*   UserTerritory oUserTerritory = [SELECT Id, TerritoryId, UserId FROM UserTerritory WHERE IsActive=true LIMIT 1];
       
       Territory oTerritory = [SELECT Id FROM Territory WHERE Id=:oUserTerritory.TerritoryId];
       
       Group oGroup = [SELECT Id, RelatedId FROM Group WHERE RelatedId=:oTerritory.Id AND Type='Territory' LIMIT 1];
       
        List<AccountShare> accountsharelist = new List<AccountShare>();
        AccountShare oAccountShareA = new AccountShare();
        oAccountShareA.AccountId = oAccountA.Id;
        oAccountShareA.UserOrGroupId = oGroup.Id;
        accountsharelist.add(oAccountShareA);
        
        if(accountsharelist.size()>0){
            insert accountsharelist;            
        }
     *
        GLI_Load_Tracker__c gliloadtracker = new GLI_Load_Tracker__c();
        gliloadtracker.name = 'testload';
        gliloadtracker.JobCompletedDate__c= datetime.newInstance(2017, 9, 15, 12, 30, 0);
        Insert gliloadtracker;
        
        //Test.StartTest();   
        UPDATE gliloadtracker;      
        //Test.StopTest();
        
        Test.StartTest();
        Test.setCurrentPageReference(Page.LCRMOpportunityRelatedAccountTerritories);
        ApexPages.standardController sc = new ApexPages.standardController(oOpty);
        LCRMOpportunityTerritoriesController controller = new LCRMOpportunityTerritoriesController(sc);
        Test.StopTest();
    }
*/
}