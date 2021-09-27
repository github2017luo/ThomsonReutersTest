@isTest
public class LOTUSTerritoryAssignment_Test {
    
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
        testterr.DeveloperName = 'testterr';
        testterr.Territory2ModelId = terrModel.Id;
        testterr.Territory2TypeId = terriType[0].Id;
        testterr.Name = 'testterritory2';
        testterr.TMS_Terr_Num__c = '123';
        insert testterr;
        
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
    
    @isTest static void methodName() {
        
        Territory2 terr22 = [select Id FRoM territory2 WHERE name ='testterritory2' Limit 1];
        List<KeyValueListStore__c> lstOfKeyStore = new List<KeyValueListStore__c>();
        KeyValueListStore__c keyvalueStore4 = new KeyValueListStore__c();
        keyvalueStore4.Name= 'LCRMOpptyTerritoryStageValues';
        keyvalueStore4.TextValue__c = 'Contract Signed,Order Complete,Closed Lost';
        lstOfKeyStore.add(keyvalueStore4);
        
        KeyValueListStore__c keyvaluestore=new  KeyValueListStore__c();
        keyvaluestore.Name='ANZUsersProfileId';
        keyvaluestore.TextValue__c='00e30000001ZUki';      
        lstOfKeyStore.add(keyvaluestore);
        KeyValueListStore__c lCRMStrikeIronFlagINS1 = new KeyValueListStore__c();
        lCRMStrikeIronFlagINS1.Name='LCRMDisableStrikeIronServices';
        lCRMStrikeIronFlagINS1.TextValue__c='True';
        lstOfKeyStore.add(lCRMStrikeIronFlagINS1 );
        
        KeyValueListStore__c keyval = new KeyValueListStore__c();
        keyval.Name='ReasonWithCompetitor';
        keyval.TextValue__c='Price';
        lstOfKeyStore.add(keyval);
        //End Opportunity
        
        if(lstOfKeyStore.size()>0){ 
            insert lstOfKeyStore;
        }
        List<RecordtypeIds__c> recordlist=new List<RecordtypeIds__c>();
        RecordtypeIds__c recordtype=new RecordtypeIds__c();
        recordtype.Name='Pre-Pipeline Opportunities';
        recordtype.recTypeId__c='01230000001MA4c';
        recordlist.add(recordtype);
        
        RecordtypeIds__c recordtype1=new RecordtypeIds__c();
        recordtype1.Name='Pipeline Opportunities';
        recordtype1.recTypeId__c='01230000001MA4c';
        recordlist.add(recordtype1);
        insert recordlist;
        
        Id accountRTID = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('GLI_Account').getRecordTypeId();
        Account gliAccount = new Account(); 
        gliAccount.Name = 'Unit Test';
        gliAccount.Sales_Org__c = 'WEST';
        gliAccount.Customer_Type__c = 'Individual';
        gliAccount.Customer_Group__c = 'ACADEMIC';
        gliAccount.Industry = 'TAX';
        gliAccount.is_gli__c = true;
        gliAccount.RecordTypeId = accountRTID;
        
        insert gliAccount;
        
        ObjectTerritory2Association objObjectTerritory2Association = new ObjectTerritory2Association(ObjectId = gliAccount.id, Territory2Id =terr22.Id, AssociationCause='Territory2Manual' );
        insert objObjectTerritory2Association;
        
        Contact gliContact = UnitTest.getContactInstance(gliAccount.id);
        insert gliContact;
        
        //Setup required mock web service requests
        MDBIntegrationUtil_Test.setupUpsertAccountServiceSettings();
        MDBIntegrationUtil_Test.setupMockUpsertAccountSuccessResponse();
        
        
        
        User gliUser = [select id from User where Username = 'TestUser1@TR.com' ];
        AccountShare accountShare = new AccountShare();
        accountShare.AccountId = gliAccount.Id;
        accountShare.UserOrGroupId = gliUser.Id;
        accountShare.AccountAccessLevel = 'Edit';  // or 'Read'
        // accountShare.ContactAccessLevel = 'Edit';  // or 'Read'
        accountShare.OpportunityAccessLevel = 'Edit';   // or 'Read'
        
        accountShare.RowCause = 'Manual';
        
        
        insert accountShare ;
        
        
        
        
        
        Test.starttest();
        system.runAs(gliUser){
            Account acc = [select id from Account WHERE Name = 'Unit Test'];
            contact con = [select id from contact where accountid =:acc.id];
            UserTerritory2Association oUserTerritory = [SELECT Id, Territory2Id, UserId FROM UserTerritory2Association WHERE IsActive=true LIMIT 1];
            recordtype opptyRT = [select id from recordtype where name ='GLI Pipeline Opportunity' and sobjecttype='Opportunity' limit 1];
            Opportunity gliOpty = UnitTest.getOpportunityInstance(acc.id);
            gliOpty.Name = 'Test Opportunity Training Event';
            gliOpty.Key_Contact__c = con.id;
            gliOpty.Renewal_Flag__c = true;
            gliOpty.currencyIsoCode = 'USD';
            gliOpty.StageName = 'Needs Analysis';
            gliOpty.is_gli__c = true;
            gliOpty.LCRM_Status__c = 'Open';
            gliOpty.RecordTypeId = opptyRT.Id;
            gliOpty.CurrencyIsoCode = 'USD';
            gliOpty.Expiration_Date__c=Date.Today();       
            gliOpty.LCRM_Territory_Update_Timestamp__c=system.today(); 
            
            insert gliOpty;
            system.debug('gliOpty@@ '+gliOpty);
            system.assertEquals(terr22.Id != null ,true);
        }
        
        Test.stoptest();
        
        
    }
    
}