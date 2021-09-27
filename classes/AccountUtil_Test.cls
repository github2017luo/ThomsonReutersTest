/*
======================================================================================================================
TEST CLASS NAME: AccountUtil_Test
======================================================================================================================
PURPOSE:    Validates the functionality provided by the AccountUtil class.

CHANGE HISTORY:
======================================================================================================================
DATE                  NAME                           DESC

2011-02-02          John De Santiago             Legacy code

Optimized the coverage
2017-03-31            Karthi                     as per JIRA STORY: PS0-1
======================================================================================================================
*/

@IsTest
private class AccountUtil_Test {
    
    /**
* Validates that required record types are available
*/
    private static testMethod void testGetRecordTypeIds() {
        //Execute Test
        Test.startTest();
        
        System.assert(AccountUtil.CustomerRecordTypeId != null, 'Account record type Customer is not configured or is unavailable');
        
        System.assert(AccountUtil.ProspectRecordTypeId != null, 'Account record type Prospect is not configured or is unavailable');
        
        System.assert(AccountUtil.GlobalRecordTypeId != null, 'Account record type Global is not configured or is unavailable');
        
        Test.stopTest();
    }
    
    /**
* Validates that default values are applied to the account
*/
    private static testMethod void testApplyDefaults() {
        //Setup Test
        Account oAccount = UnitTest.getAccountInstance();
        oAccount.OwnerId = UserInfo.getUserId();
        
        //Execute Test
        Test.startTest();
        
        AccountUtil.applyAccountDefaults(new List<Account>{ oAccount });
        
        Test.stopTest();
        System.assertEquals(true, oAccount != null);
    }
    
    /**
* Validates that sales org default values are applied to the account
*/
    private static testMethod void testApplySalesOrgDefaults() {
        //Setup Test
        SalesOrgDetail__c oSalesOrgDetail = new SalesOrgDetail__c();
        oSalesOrgDetail.Name = 'WEST';
        oSalesOrgDetail.Company_Code__c = 'CCTest';
        oSalesOrgDetail.Distribution_Channel__c = 'DCTest';
        oSalesOrgDetail.Division_Code__c = 'DVCTest';
        oSalesOrgDetail.Sales_Org_Code__c = 'UT';
        insert oSalesOrgDetail;
        
        Account oAccount = UnitTest.getAccountInstance();
        oAccount.Sales_Org__c = 'UT';
        oAccount.OwnerId = UserInfo.getUserId();
        
        //Execute Test
        Test.startTest();
        
        AccountUtil.applySalesOrgDefaults(new List<Account>{ oAccount });
        
        Test.stopTest();
        
        //Validate Test
        System.assertEquals(oAccount.OwnerId != null , true);
        
    }
    
    /**
* Validates that sales org default values are applied to the account for WEST Sales org if it is null
*/
    private static testMethod void testNullApplySalesOrgDefaults() {
        //Setup Test
        SalesOrgDetail__c oSalesOrgDetail = new SalesOrgDetail__c();
        oSalesOrgDetail.Name = 'WEST Group';
        oSalesOrgDetail.Company_Code__c = 'CCTest';
        oSalesOrgDetail.Distribution_Channel__c = 'DCTest';
        oSalesOrgDetail.Division_Code__c = 'DVCTest';
        oSalesOrgDetail.Sales_Org_Code__c = 'WEST';
        insert oSalesOrgDetail;
        
        Account oAccount = UnitTest.getAccountInstance();
        oAccount.Sales_Org__c = '';
        oAccount.OwnerId = UserInfo.getUserId();
        
        //Execute Test
        Test.startTest();
        
        AccountUtil.applySalesOrgDefaults(new List<Account>{ oAccount });
        Test.stopTest();
        
        //Validate Test
        System.assertEquals(false, oAccount.Id != null);
        
    }
    
    
    /**
* Validates that a map of SalesOrgDetail__c objects is mapped by sales org code
*/
    private static testMethod void testGetSalesCodeMap() {
        //Setup Test
        SalesOrgDetail__c oSalesOrgDetail = new SalesOrgDetail__c();
        oSalesOrgDetail.Name = 'WEST';
        oSalesOrgDetail.Company_Code__c = 'CCTest';
        oSalesOrgDetail.Distribution_Channel__c = 'DCTest';
        oSalesOrgDetail.Division_Code__c = 'DVCTest';
        oSalesOrgDetail.Sales_Org_Code__c = 'UT';
        insert oSalesOrgDetail;
        
        //Execute Test
        Test.startTest();
        
        Map<string, SalesOrgDetail__c> mapSalesOrgDetail = AccountUtil.getSalesOrgCodesMap();
        
        Test.stopTest();
        
        //Validate Test
        SalesOrgDetail__c oTestSalesOrgDetail = mapSalesOrgDetail.get('UT');
        System.assertNotEquals(null, oTestSalesOrgDetail);
    }
    
    /**
* Valdates that an address token value is generated for the account
*/
    private static testMethod void testUpdateAddressTokens() {
        //Setup Test
        Account oAccount = UnitTest.getAccountInstance();
        oAccount.BillingStreet = '444 Some Street';
        oAccount.BillingCity = 'Dallas';
        oAccount.BillingState = 'TX';
        oAccount.BillingPostalCode = '55555';
        oAccount.BillingCountry = 'US';
        oAccount.Address_Token__c = null;
        oAccount.OwnerId = UserInfo.getUserId();
        
        AccountUtil.applyAccountDefaults(new List<Account>{ oAccount });
        
        //Execute Test
        Test.startTest();
        
        AccountUtil.updateAddressTokens(new List<Account>{ oAccount });
        
        Test.stopTest();
        
        //Validate Test
        System.assert(oAccount.Address_Token__c != null, 'Expected Address_Token__c to be populated with a value');
    }
    
    /**
* Validates that the account billing address is properly mapped to
* an instance of an DataQualityUtil.Address object
*/
    private static testMethod void testGetAccountBillingAddress() {
        //Setup Test
        Account oAccount = UnitTest.getAccountInstance();
        oAccount.BillingStreet = '444 Some Street';
        oAccount.BillingCity = 'Dallas';
        oAccount.BillingState = 'TX';
        oAccount.BillingPostalCode = '55555';
        oAccount.BillingCountry = 'US';
        oAccount.OwnerId = UserInfo.getUserId();
        
        //Execute Test
        Test.startTest();
        
        DataQualityUtil.Address oAddress = AccountUtil.getBillingAddress(oAccount);
        
        Test.stopTest();
        
        //Validate Test
        System.assertEquals(oAddress.Street, oAccount.BillingStreet);
    }
    
    /**
* Validates that the account billing address is properly mapped to based
* an instance of the specified DataQualityUtil.Address object
*/
    private static testMethod void testSetAccountBillingAddress() {
        //Setup Test
        Account oAccount = UnitTest.getAccountInstance();
        oAccount.BillingStreet = '444 Some Street';
        oAccount.BillingCity = 'Dallas';
        oAccount.BillingState = 'TX';
        oAccount.BillingPostalCode = '55555';
        oAccount.BillingCountry = 'US';
        oAccount.OwnerId = UserInfo.getUserId();
        
        DataQualityUtil.Address oAddress = AccountUtil.getBillingAddress(oAccount);
        
        //Execute Test
        Test.startTest();
        
        AccountUtil.setBillingAddress(oAccount, oAddress);
        
        Test.stopTest();
        
        //Validate Test
        System.assertEquals(oAccount.BillingStreet, oAddress.Street);
    }
    
    /**
* Validates that potential duplicates are identified and returned as a list
* of AccountUtil.AccountMatchResult objects
*/
    private static testMethod void testMatchAccounts() {
        //Setup Test
        WebServiceSettings__c oWebServiceSettings = DataQualityUtil_Test.setupAccountMatchingServiceSettings();
        DataQualityUtil_Test.setupMockMatchAccountServiceSuccessResponse();
        
        //Setup dependent services for account creation
        MDBIntegrationUtil_Test.setupUpsertAccountServiceSettings();
        MDBIntegrationUtil_Test.setupMockUpsertAccountSuccessResponse();
        
        Account oAccount = UnitTest.getAccountInstance();
        oAccount.Name = 'Unit Test';
        oAccount.BillingStreet = '55 Some Street';
        oAccount.BillingCity = 'Dallas';
        oAccount.BillingState = 'TX';
        oAccount.BillingCountry = 'US';
        oAccount.BillingPostalCode = '55555';
        oAccount.Street_Name__c = 'Some Street';
        oAccount.Sales_Org__c = 'WEST';
        
        DataQualityUtil.Address oAddress = AccountUtil.getBillingAddress(oAccount);
        string sAddressToken = AccountUtil.buildAddressToken(oAddress, 'WEST');
        
        //Execute Test
        Test.startTest();
        
        // List<DataQualityUtil.AccountInfo> listAccountsNoMatches = AccountUtil.matchAccounts(sAddressToken);
        
        insert oAccount;
        // List<DataQualityUtil.AccountInfo> listAccountsWithMatches = AccountUtil.matchAccounts(sAddressToken);
        
        Test.stopTest();
        System.assertEquals(oAccount != null, true);
        //Validate Test
        //   System.assertEquals(0, listAccountsNoMatches.size());
        //   System.assertEquals(1, listAccountsWithMatches.size());
    }
    
    /**
* Validates that prospect accounts are processed which is the entry 
* point for a trigger that will send accounts to be processed and
* submitted to MDB
*/
    private static testMethod void testUpsertAccounts() {
        //Setup Test
        WebServiceSettings__c oWebServiceSettings = MDBIntegrationUtil_Test.setupUpsertAccountServiceSettings();
        MDBIntegrationUtil_Test.setupMockUpsertAccountSuccessResponse();
        
        Account oAccount = UnitTest.getAccountInstance();
        oAccount.RecordTypeId = AccountUtil.ProspectRecordTypeId;
        oAccount.BillingStreet = '444 Some Street';
        oAccount.BillingCity = 'Dallas';
        oAccount.BillingState = 'TX';
        oAccount.BillingPostalCode = '55555';
        oAccount.BillingCountry = 'US';
        insert oAccount;
        
        //Execute Test
        Test.startTest();
        
        AccountUtil.executeMDBAccountUpsertService(new List<Account> { oAccount });
        
        Test.stopTest();
        
        //Validate Test
        oAccount = [SELECT Id, MDBID__c FROM Account WHERE Id = :oAccount.Id LIMIT 1];
        System.assertEquals('10089', oAccount.MDBID__c);
    }
    
    
    
    /**
* Validates that prospect accounts are reports an simulated error on
* the web service occurs
*/
    private static testMethod void testUpsertAccountsFailed() {
        
        //Setup Test
        SalesOrgDetail__c oSalesOrgDetail = new SalesOrgDetail__c();
        oSalesOrgDetail.Name = 'WEST';
        oSalesOrgDetail.Company_Code__c = 'CCTest';
        oSalesOrgDetail.Distribution_Channel__c = 'DCTest';
        oSalesOrgDetail.Division_Code__c = 'DVCTest';
        oSalesOrgDetail.Sales_Org_Code__c = 'UT';
        insert oSalesOrgDetail;
        
        WebServiceSettings__c oWebServiceSettings = MDBIntegrationUtil_Test.setupUpsertAccountServiceSettings();
        MDBIntegrationUtil_Test.setupMockUpsertAccountFailureResponse();
        
        Account oAccount = UnitTest.getAccountInstance();
        oAccount.RecordTypeId = AccountUtil.ProspectRecordTypeId;
        oAccount.BillingStreet = '444 Some Street';
        oAccount.BillingCity = 'Dallas';
        oAccount.BillingState = 'TX';
        oAccount.BillingPostalCode = '55555';
        oAccount.BillingCountry = 'US';
        oAccount.Sales_Org__c='UT';
        insert oAccount;
        
        //Execute Test
        try {
            Test.startTest();
            
            AccountUtil.executeMDBAccountUpsertService(new List<Account> { oAccount });
            
            Test.stopTest();
        }
        catch (Exception unknownException) {
            System.assert(false, 'An unexpected exception occured');
        }
    }
    
    private static testMethod void testupdatePhoneonContact() {
        Account oAccount = UnitTest.getAccountInstance();
        oAccount.RecordTypeId = AccountUtil.ProspectRecordTypeId;
        oAccount.Address_Token__c = 'US1120 GLI';
        oAccount.BillingStreet = '444 Some Street';
        oAccount.BillingCity = 'Dallas';
        oAccount.BillingState = 'TX';
        oAccount.BillingPostalCode = '55555';
        oAccount.BillingCountry = 'US';
        insert oAccount;
        
        List<Id> acclst =new list<Id>();
        acclst.add(oAccount.Id);
        
        
        
        //Execute Test
        Test.startTest();
        
        AccountHandler.updatePhoneonContactOpportunity(acclst);
        System.assertEquals(acclst.size() > 0 , true);
        AccountUtil.queryAccountByAddressToken('US1120 GLI');
        
        Test.stopTest();
        
        //Validate Test
        
    }
    
    private static testMethod void testApplySalesOrgDefaultsGLI() {
        //Setup Test
        
        
        Profile ukiProfiles = [SELECT Id FROM profile WHERE name='GLI Sales Ops User'];
        User gliUser2 = UnitTest.getUserInstance();
        gliUser2.Username = 'UT'+Math.random()*100 +'@TR.com';        
        gliUser2.profileid = ukiProfiles.Id;
        gliUser2.CommunityNickname = 'nkpa2';
        gliUser2.Sales_Org__c = 'GLI';
        gliUser2.Segment__c  = 'Corporate';
        gliUser2.Sub_Bu__c = 'USL';
        insert gliUser2;
        
        
        
        Account oAccount = new Account();
        oAccount.name = 'test acc';
        oAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('GLI Account').getRecordTypeId();  
        oAccount.BU_Region__c = 'Canada';
        oAccount.Bu_Segment__c = 'Professional Tax';
        oAccount.Is_GLI__c = true;
        insert oAccount;
        
        //Execute Test
        
        System.runas(gliUser2){
            Test.startTest();
            
            AccountUtil.applySalesOrgDefaults(new List<Account>{ oAccount });
            AccountUtil.getTimeStamp();
            Test.stopTest();
            
            //Validate Test
            System.assertEquals(true, String.isNotBlank(oAccount.Sales_Org__c));
            
        }}
    
    private static testMethod void testApplySalesOrgDefaultsGlobalRecordTypeId() {
        //Setup Test
        
        
        Profile ukiProfiles = [SELECT Id FROM profile WHERE name='GLI Sales Ops User'];
        User gliUser2 = UnitTest.getUserInstance();
        gliUser2.Username = 'UT'+Math.random()*100 +'@TR.com';        
        gliUser2.profileid = ukiProfiles.Id;
        gliUser2.CommunityNickname = 'nkpa2';
        gliUser2.Sales_Org__c = 'GLI';
        gliUser2.Segment__c  = 'Corporate';
        gliUser2.Sub_Bu__c = 'USL';
        insert gliUser2;
        
        
        
        Account oAccount = new Account();
        oAccount.name = 'test acc';
        oAccount.RecordTypeId = Accountutil.GlobalRecordTypeId;
        oAccount.BU_Region__c = 'Canada';
        oAccount.Bu_Segment__c = 'Professional Tax';
        oAccount.Is_GLI__c = true;
        insert oAccount;
        
        //Execute Test
        
        System.runas(gliUser2){
            Test.startTest();
            
            AccountUtil.applySalesOrgDefaults(new List<Account>{ oAccount });
            AccountUtil.getTimeStamp();
            Test.stopTest();
            
            //Validate Test
            System.assertEquals(true, String.isNotBlank(oAccount.Sales_Org__c));
            
        }}
    
    private static testMethod void testApplySalesOrgDefaultsGLIAccountECMRecordTypeId() {
        //Setup Test
        
        
        Profile ukiProfiles = [SELECT Id FROM profile WHERE name='GLI Sales Ops User'];
        User gliUser2 = UnitTest.getUserInstance();
        gliUser2.Username = 'UT'+Math.random()*100 +'@TR.com';        
        gliUser2.profileid = ukiProfiles.Id;
        gliUser2.CommunityNickname = 'nkpa2';
        gliUser2.Sales_Org__c = 'GLI';
        gliUser2.Segment__c  = 'Corporate';
        gliUser2.Sub_Bu__c = 'USL';
        insert gliUser2;
        
        
        
        Account oAccount = new Account();
        oAccount.name = 'test acc';
        oAccount.RecordTypeId = Accountutil.GLIAccountECMRecordTypeId;
        oAccount.BU_Region__c = 'Canada';
        oAccount.Bu_Segment__c = 'Professional Tax';
        oAccount.Is_GLI__c = true;
        insert oAccount;
        
        //Execute Test
        
        System.runas(gliUser2){
            Test.startTest();
            
            AccountUtil.applySalesOrgDefaults(new List<Account>{ oAccount });
            AccountUtil.getTimeStamp();
            Test.stopTest();
            
            //Validate Test
            System.assertEquals(true, String.isNotBlank(oAccount.Sales_Org__c));
            
        }}
    
    private static testMethod void testApplySalesOrgDefaultsGLINewAccountRecordTypeId() {
        //Setup Test
        
        
        Profile ukiProfiles = [SELECT Id FROM profile WHERE name='GLI Sales Ops User'];
        User gliUser2 = UnitTest.getUserInstance();
        gliUser2.Username = 'UT'+Math.random()*100 +'@TR.com';        
        gliUser2.profileid = ukiProfiles.Id;
        gliUser2.CommunityNickname = 'nkpa2';
        gliUser2.Sales_Org__c = 'GLI';
        gliUser2.Segment__c  = 'Corporate';
        gliUser2.Sub_Bu__c = 'USL';
        insert gliUser2;
        
        
        
        Account oAccount = new Account();
        oAccount.name = 'test acc';
        oAccount.RecordTypeId = Accountutil.GLINewAccountRecordTypeId;
        oAccount.BU_Region__c = 'Canada';
        oAccount.Bu_Segment__c = 'Professional Tax';
        oAccount.Is_GLI__c = true;
        insert oAccount;
        
        //Execute Test
        
        System.runas(gliUser2){
            Test.startTest();
            
            AccountUtil.applySalesOrgDefaults(new List<Account>{ oAccount });
            AccountUtil.getTimeStamp();
            Test.stopTest();
            
            //Validate Test
            System.assertEquals(true, String.isNotBlank(oAccount.Sales_Org__c));
            
        }}
    
    private static testMethod void testApplySalesOrgDefaultsGLIAccountRecordTypeId() {
        //Setup Test
        
        
        Profile ukiProfiles = [SELECT Id FROM profile WHERE name='GLI Sales Ops User'];
        User gliUser2 = UnitTest.getUserInstance();
        gliUser2.Username = 'UT'+Math.random()*100 +'@TR.com';        
        gliUser2.profileid = ukiProfiles.Id;
        gliUser2.CommunityNickname = 'nkpa2';
        gliUser2.Sales_Org__c = 'GLI';
        gliUser2.Segment__c  = 'Corporate';
        gliUser2.Sub_Bu__c = 'USL';
        insert gliUser2;
        
        
        
        Account oAccount = new Account();
        oAccount.name = 'test acc';
        oAccount.RecordTypeId = Accountutil.GLIAccountRecordTypeId;
        oAccount.BU_Region__c = 'Canada';
        oAccount.Bu_Segment__c = 'Professional Tax';
        oAccount.Is_GLI__c = true;
        insert oAccount;
        
        //Execute Test
        
        System.runas(gliUser2){
            Test.startTest();
            
            AccountUtil.applySalesOrgDefaults(new List<Account>{ oAccount });
            AccountUtil.getTimeStamp();
            Test.stopTest();
            
            //Validate Test
            System.assertEquals(true, String.isNotBlank(oAccount.Sales_Org__c));
            
        }}    
    
    private static testMethod void testApplyDefaultsPR() {
        //Setup Test
        
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
        gliUser.LanguageLocaleKey='pt_BR';
        gliUser.TimeZoneSidKey='America/Sao_Paulo';
        //gliUser.Sub_Bu__c = 'USL';
        
        
        insert gliUser;
        System.runas(gliUser){
            Account oAccount = UnitTest.getAccountInstance();
            oAccount.OwnerId = UserInfo.getUserId();
            oAccount.RecordTypeId = Accountutil.ProspectRecordTypeId;
            
            //Execute Test
            Test.startTest();
            
            AccountUtil.applyAccountDefaults(new List<Account>{ oAccount });
            
            Test.stopTest();
            System.assertEquals(true, oAccount != null);
        }
    }
    private static testMethod void testApplyDefaultses() {
        //Setup Test
        
        Profile adminProfile = [SELECT Id FROM profile WHERE name='System Administrator'];
        User gliUseres;
        gliUseres = new User();
        gliUseres.Username = 'TestUser1@TR.com'+math.random();
        gliUseres.profileid = adminProfile.Id;
        gliUseres.Email='testuser'+math.random()+'@thomsonreuters.com';
        gliUseres.Alias = 'i';
        //gliUser.FirstName='Informatica';
        gliUseres.LastName='Integration';
        gliUseres.EmailEncodingKey='UTF-8';
        gliUseres.LocaleSidKey='es_AR';
        gliUseres.LanguageLocaleKey='es';
        gliUseres.TimeZoneSidKey='America/Los_Angeles';
        //gliUser.Sub_Bu__c = 'USL';
        
        
        insert gliUseres;
        System.runas(gliUseres){  
            Account oAccount = UnitTest.getAccountInstance();
            oAccount.OwnerId = UserInfo.getUserId();
            oAccount.RecordTypeId = Accountutil.CustomerRecordTypeId;
            //Execute Test
            Test.startTest();
            
            AccountUtil.applyAccountDefaults(new List<Account>{ oAccount });
            
            Test.stopTest();
            
            System.assertEquals(true, oAccount != null);
        }
    }
    private static testMethod void testApplyDefaultsesp() {
        //Setup Test
        
        Profile adminProfile = [SELECT Id FROM profile WHERE name='System Administrator'];
        User gliUseres;
        gliUseres = new User();
        gliUseres.Username = 'TestUser1@TR.com'+math.random();
        gliUseres.profileid = adminProfile.Id;
        gliUseres.Email='testuser'+math.random()+'@thomsonreuters.com';
        gliUseres.Alias = 'i';
        //gliUser.FirstName='Informatica';
        gliUseres.LastName='Integration';
        gliUseres.EmailEncodingKey='UTF-8';
        gliUseres.LocaleSidKey='es_AR';
        gliUseres.LanguageLocaleKey='es';
        gliUseres.TimeZoneSidKey='America/Los_Angeles';
        //gliUser.Sub_Bu__c = 'USL';
        
        
        insert gliUseres;
        System.runas(gliUseres){  
            Account oAccount = UnitTest.getAccountInstance();
            oAccount.OwnerId = UserInfo.getUserId();
            oAccount.RecordTypeId = Accountutil.ProspectRecordTypeId;
            //Execute Test
            Test.startTest();
            
            AccountUtil.applyAccountDefaults(new List<Account>{ oAccount });
            
            Test.stopTest();
            
            System.assertEquals(true, oAccount != null);
        }
    }
}