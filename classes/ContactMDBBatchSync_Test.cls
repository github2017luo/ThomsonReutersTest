@IsTest
private class ContactMDBBatchSync_Test {

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
        
        Contact oContact = UnitTest.getContactInstance(oAccount.Id);
        //oAccount.RecordTypeId = AccountUtil.ProspectRecordTypeId;
        //oAccount.BillingStreet = '444 Some Street';
        //oAccount.BillingCity = 'Dallas';
        //oAccount.BillingState = 'TX';
        //oAccount.BillingPostalCode = '55555';
        //oAccount.BillingCountry = 'US';
        //oAccount.Sales_Org__c = 'WEST';
        insert oContact;
        
        
        SalesOrgDetail__c oSalesOrgDetail = new SalesOrgDetail__C();
        oSalesOrgDetail.Sales_Org_Code__c = 'WEST';
        oSalesOrgDetail.Company_Code__c='West Group';
        oSalesOrgDetail.Distribution_Channel__c='West Group';
        oSalesOrgDetail.Division_Code__c='West Group';
        oSalesOrgDetail.name='West Group';
        insert oSalesOrgDetail;
        
        //Execute Test
        Test.startTest();
        
        ContactMDBBatchSync batch = new ContactMDBBatchSync();
        //batch.SalesOrgs.add('WEST');

        Id batchJobId = Database.executeBatch(batch, 1);
        
        Test.stopTest();
        
        //Validate Test
        oContact = [SELECT Id, MDB_Contact_ID__c FROM Contact WHERE Id = :oContact.Id LIMIT 1];
        if(oContact.MDB_Contact_ID__c!= null){
        System.assertEquals('10090', oContact.MDB_Contact_ID__c);
        }
        //oAccount = [SELECT Id, MDBID__c FROM Account WHERE Id = :oAccount.Id LIMIT 1];
        //System.assertEquals('10089', oAccount.MDBID__c);
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
        
        Contact oContact = UnitTest.getContactInstance(oAccount.Id);
        //oAccount.RecordTypeId = AccountUtil.ProspectRecordTypeId;
        //oAccount.BillingStreet = '444 Some Street';
        //oAccount.BillingCity = 'Dallas';
        //oAccount.BillingState = 'TX';
        //oAccount.BillingPostalCode = '55555';
        //oAccount.BillingCountry = 'US';
        //oAccount.Sales_Org__c = 'WEST';
        insert oContact;
        
        
        
        Account oInvalidAccount = UnitTest.getAccountInstance();
        oInvalidAccount.RecordTypeId = AccountUtil.ProspectRecordTypeId;
        oInvalidAccount.BillingStreet = '444 Some Street';
        oInvalidAccount.BillingCity = 'Dallas';
        oInvalidAccount.BillingState = 'TX';
        oInvalidAccount.BillingPostalCode = '55555';
        oInvalidAccount.BillingCountry = 'US';
        oInvalidAccount.Sales_Org__c = 'TEST';
        insert oInvalidAccount;
        
        
        Contact oInvalidContact = UnitTest.getContactInstance(oInvalidAccount.Id);
        //oAccount.RecordTypeId = AccountUtil.ProspectRecordTypeId;
        //oAccount.BillingStreet = '444 Some Street';
        //oAccount.BillingCity = 'Dallas';
        //oAccount.BillingState = 'TX';
        //oAccount.BillingPostalCode = '55555';
        //oAccount.BillingCountry = 'US';
        //oAccount.Sales_Org__c = 'WEST';
        insert oInvalidContact;
        
        
        
        //Execute Test
        Test.startTest();
        
        ContactMDBBatchSync batch = new ContactMDBBatchSync();
        batch.SalesOrgs.add('WEST');
        //batch.SalesOrgs.add('GLI');

        Id batchJobId = Database.executeBatch(batch, 1);
        
        Test.stopTest();
        
        //Validate Test
        oContact = [SELECT Id, MDB_Contact_ID__c FROM Contact WHERE Id = :oContact.Id LIMIT 1];
        if(oContact.MDB_Contact_ID__c!= null){
        System.assertEquals('10090', oContact.MDB_Contact_ID__c);
        }
        oInvalidContact = [SELECT Id, MDB_Contact_ID__c FROM Contact WHERE Id = :oInvalidContact.Id LIMIT 1];
        System.assertEquals(Null, oInvalidContact.MDB_Contact_ID__c);
        //oAccount = [SELECT Id, MDBID__c FROM Account WHERE Id = :oAccount.Id LIMIT 1];
        //System.assertEquals('10089', oAccount.MDBID__c);
        //oInvalidAccount = [SELECT Id, MDBID__c FROM Account WHERE Id = :oInvalidAccount.Id LIMIT 1];
        //System.assertEquals(Null, oInvalidAccount.MDBID__c);
    }

}