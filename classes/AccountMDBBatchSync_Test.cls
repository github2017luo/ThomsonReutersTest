/*
======================================================================================================================
TEST CLASS NAME:AccountMDBBatchSync_Test 
======================================================================================================================
PURPOSE: Validates the functionality provided by the AccountMDBBatchSync class.

CHANGE HISTORY:
======================================================================================================================
DATE             NAME           DESC
31/03/2017       Gunaseelan K   Optimized the code as per JIRA STORY: PS0-1
======================================================================================================================
*/
@IsTest
private class AccountMDBBatchSync_Test {

/**
     * Validates that prospect accounts are processed which is the entry 
     * point for a trigger that will send accounts to be processed and
     * submitted to MDB
     */
    private static testMethod void testDefaultSalesOrgUpsert() {
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
        oAccount.Sales_Org__c = 'WEST';
        insert oAccount;
        
        
        SalesOrgDetail__c oSalesOrgDetail = new SalesOrgDetail__C();
        oSalesOrgDetail.Sales_Org_Code__c = 'WEST';
        oSalesOrgDetail.Company_Code__c='West Group';
        oSalesOrgDetail.Distribution_Channel__c='West Group';
        oSalesOrgDetail.Division_Code__c='West Group';
        oSalesOrgDetail.name='West Group';
        insert oSalesOrgDetail;
        
        //Execute Test
        Test.startTest();
        
        AccountMDBBatchSync batch = new AccountMDBBatchSync();
        //batch.SalesOrgs.add('WEST');

        Id batchJobId = Database.executeBatch(batch, 1);
        
        Test.stopTest();
        
        //Validate Test
        oAccount = [SELECT Id, MDBID__c FROM Account WHERE Id = :oAccount.Id LIMIT 1];
        if(oAccount.MDBID__c!=null){
        System.assertEquals('10089', oAccount.MDBID__c);
        }
    }

    private static testMethod void testSalesOrgUpsert() {
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
        oAccount.Sales_Org__c = 'WEST';
        insert oAccount;
        
        Account oInvalidAccount = UnitTest.getAccountInstance();
        oInvalidAccount.RecordTypeId = AccountUtil.ProspectRecordTypeId;
        oInvalidAccount.BillingStreet = '444 Some Street';
        oInvalidAccount.BillingCity = 'Dallas';
        oInvalidAccount.BillingState = 'TX';
        oInvalidAccount.BillingPostalCode = '55555';
        oInvalidAccount.BillingCountry = 'US';
        oInvalidAccount.Sales_Org__c = 'TEST';
        insert oInvalidAccount;
        
        //Execute Test
        Test.startTest();
        
        AccountMDBBatchSync batch = new AccountMDBBatchSync();
        batch.SalesOrgs.add('WEST');
        //batch.SalesOrgs.add('GLI');

        Id batchJobId = Database.executeBatch(batch, 1);
        
        Test.stopTest();
        
        //Validate Test
        oAccount = [SELECT Id, MDBID__c FROM Account WHERE Id = :oAccount.Id LIMIT 1];
        if(oAccount.MDBID__c!=null){
        System.assertEquals('10089', oAccount.MDBID__c);
        }
        oInvalidAccount = [SELECT Id, MDBID__c FROM Account WHERE Id = :oInvalidAccount.Id LIMIT 1];
        System.assertEquals(Null, oInvalidAccount.MDBID__c);
    }

}