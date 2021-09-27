/**
 * Validates the functionality provided by the UnitTest class and to ensure
 * that the instances provided can be created using both basic and bulk
 * insert operations
 *
 * @author  John De Santiago - Thomson Reuters Code Share
 * @version 2010-11-01
 */

/**
 * CHANGE HISTORY
 * =============================================================================
 * Date         Name                    Description
 * 2010-11-01   John De Santiago        Created
 * 2010-11-19   John De Santiago        Updated/Added support for bulk testing and save results
 * 2012-06-14   John De Santiago        Removed support for bulk instance methods as they did not provide
 *                                      any significant value to testing
 * =============================================================================
 */
@IsTest
private class UnitTest_Test {
    
    /**
     * Validates the storage and retreival of a global static mock response object
     */
    private static testMethod void testStoreMockResponse() {
        //Run Test
        Test.startTest();
        
        Account oAccount = UnitTest.getAccountInstance();
        UnitTest.MockWebServiceResponse.put('TestMockResponse', oAccount);
        
        Test.stopTest();
        
        //Validate Test
        object oMockResponse = UnitTest.MockWebServiceResponse.get('TestMockResponse');
        System.assert((oMockResponse instanceof Account), 'Expected a mock response object to match the object type supplied');
    }

    /**
     * Validates all Lead methods and ensures the
     * instance can be inserted into the database
     */
    private static testmethod void testLeadMethods() {
        //Run Test
        Test.startTest();
        
        Lead oLead = UnitTest.getLeadInstance();
        insert oLead;
        
        Test.stopTest();
        
        //Validate Test
        System.assertNotEquals(null, oLead.Id);
    }
    
    /**
     * Validates all Lead Product methods and ensures the
     * instance can be inserted into the database
     */
    private static testmethod void testLeadProductMethods() {
        Lead oLead = UnitTest.getLeadInstance();
        insert oLead;
        
        Product2 oProduct = UnitTest.getProductInstance();
        insert oProduct;
        
        //Run Test
        Test.startTest();
        
        Lead_Product__c oLeadProduct = UnitTest.getLeadProductInstance(oLead.Id, oProduct.Id);
        insert oLeadProduct;
        
        Test.stopTest();
        
        //Validate Test
        System.assertNotEquals(null, oLeadProduct.Id);
    }

    /**
     * Validates all Account methods and ensures the
     * instance can be inserted into the database
     */
    private static testmethod void testAccountMethods() {
        //Run Test
        Test.startTest();
        
        Account oAccount = UnitTest.getAccountInstance();
        insert oAccount;
        
        Test.stopTest();
        
        //Validate Test
        System.assertNotEquals(null, oAccount.Id);
    }

    /**
     * Validates all Contact methods and ensures the
     * instance can be inserted into the database
     */
    private static testmethod void testContactMethods() {
        //Setup Test
        Account oAccount = UnitTest.getAccountInstance();
        insert oAccount;
        
        //Run Test
        Test.startTest();
        
        Contact oContact = UnitTest.getContactInstance(oAccount.Id);
        insert oContact;
        
        Test.stopTest();
        
        //Validate Test
        System.assertNotEquals(null, oContact.Id);
    }   
    
    /**
     * Validates all Opportunity methods and ensures the
     * instance can be inserted into the database
     */
    private static testmethod void testOpportunityMethods() {
        //Setup Test
        Account oAccount = UnitTest.getAccountInstance();
        insert oAccount;
        
        //Run Test
        Test.startTest();
        
        Opportunity oOpportunity = UnitTest.getOpportunityInstance(oAccount.Id);
        insert oOpportunity;
        
        Test.stopTest();
        
        //Validate Test
        System.assertNotEquals(null, oOpportunity.Id);
    }
    
    /**
     * Validates all Task methods and ensures the
     * instance can be inserted into the database
     */
    private static testmethod void testTaskMethods() {
        //Setup Test
        Account oAccount = UnitTest.getAccountInstance();
        insert oAccount;
        
        //Run Test
        Test.startTest();
        
        Task oTask = UnitTest.getTaskInstance(oAccount.Id, true);
        insert oTask;
        
        Test.stopTest();
        
        //Validate Test
        System.assertNotEquals(null, oTask.Id);
    }
    
    /**
     * Validates all Product methods and ensures the
     * instance can be inserted into the database
     */
    private static testmethod void testProductMethods() {
        //Run Test
        Test.startTest();
        
        Product2 oProduct = UnitTest.getProductInstance();
        insert oProduct;        
        Test.stopTest();
        
        //Validate Test
        System.assertNotEquals(null, oProduct.Id);
    }
    
    
    /**
     * Validates all Opportunity_Product_Type__c methods and ensures the
     * instance can be inserted into the database
     */
    private static testmethod void testOpportunityProductTypeMethods() {
        //Setup Test
        Account oAccount = UnitTest.getAccountInstance();
        insert oAccount;
        
        Opportunity oOpportunity = UnitTest.getOpportunityInstance(oAccount.Id);
        insert oOpportunity;
        
        //Run Test
        Test.startTest();
        
        Opportunity_Product_Type__c oProductType = UnitTest.getOpportunityProductTypeInstance(oOpportunity.Id);
        oProductType.Incremental_Amount__c = 10;
        oProductType.Renewal_Amount__c = 10;
        insert oProductType;
        
        Test.stopTest();
        
        //Validate Test
        System.assertNotEquals(null, oProductType.Id);
    }
    
    private static testmethod void testCaseMethods() {
        //Run Test
        
        Test.startTest();
        
        Case oCase = UnitTest.getCaseInstance();
        insert oCase;        
        Test.stopTest();
        
        
        
        //Validate Test
        System.assertNotEquals(null, oCase.Id);
    }
    private static testmethod void testUserMethods() {
        //Run Test
        Test.startTest();
        
        User oUser = UnitTest.getUserInstance();
        insert oUser;    
        
        Training_Event__c oTraining = UnitTest.getTrainingEventInstance();
        insert oTraining; 
        
        
        
        Id RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
        
        Test.stopTest();
        
        //Validate Test
        System.assertNotEquals(null, oUser.Id);
        System.assertNotEquals(null, oTraining.Id);
    }
    
    
    /**
     * Validates all AdvancedSearch__c methods and ensures the
     * instance can be inserted into the database
     */
    private static testmethod void testAdvancedSearchMethods() {
        //Run Test
        Test.startTest();
        
        AdvancedSearch__c oAdvancedSearch = UnitTest.getAdvancedSearchInstance();
        insert oAdvancedSearch;
        
        Test.stopTest();
        
        //Validate Test
        System.assertNotEquals(null, oAdvancedSearch.Id);
    }

    /**
     * Validates all AdvancedSearchDetail__c methods and ensures the
     * instance can be inserted into the database
     */
    private static testmethod void testAdvancedSearchDetailMethods() {
        //Setup Test
        AdvancedSearch__c oAdvancedSearch = UnitTest.getAdvancedSearchInstance();
        insert oAdvancedSearch;
        
        //Run Test
        Test.startTest();
        
        AdvancedSearchDetail__c oAdvancedSearchDetail = UnitTest.getAdvancedSearchDetailInstance(oAdvancedSearch.Id);
        insert oAdvancedSearchDetail;
        
        Test.stopTest();
        
        //Validate Test
        System.assertNotEquals(null, oAdvancedSearchDetail.Id);
    }  
  
}