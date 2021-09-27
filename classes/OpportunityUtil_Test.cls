/**
======================================================================================================================
TEST CLASS NAME: OpportunityUtil_Test
======================================================================================================================
PURPOSE:    Validates the functionality provided by the OpportunityUtil class.

CHANGE HISTORY:
======================================================================================================================
  DATE                  NAME                           DESC

2012-04-24          John De Santiago             Created
2017-03-31            Karthi                     Optimized the coverage as per JIRA STORY: PS0-1
======================================================================================================================
*/

@IsTest
(seeAllData=false) // As part of  s2e Optimisation project making seeAllData as false [Rajashree]
private class OpportunityUtil_Test {

    /**
     * Validates the syncRollupRevenueAmounts method when the Override_Revenue_Amount__c field
     * is not checked on the opportunity
     */
    private static testMethod void testSyncRollupRevenueAmountsEnabled() {
        //Setup Test
        
        UnitTest.createTestData(); //  As part of  s2e Optimisation project adding test data [Rajashree]   
        
        Account oAccount = UnitTest.getAccountInstance();
        insert oAccount;
        
        Opportunity oOpportunity = UnitTest.getOpportunityInstance(oAccount.Id);
        insert oOpportunity;
        
        Opportunity_Product_Type__c oOpportunityProductTypeA = UnitTest.getOpportunityProductTypeInstance(oOpportunity.Id);
        oOpportunityProductTypeA.Incremental_Amount__c = 50;
        oOpportunityProductTypeA.Renewal_Amount__c = 100;
        insert oOpportunityProductTypeA;
        
        Opportunity_Product_Type__c oOpportunityProductTypeB = UnitTest.getOpportunityProductTypeInstance(oOpportunity.Id);
        oOpportunityProductTypeB.Incremental_Amount__c = 50;
        oOpportunityProductTypeB.Renewal_Amount__c = 100;
        insert oOpportunityProductTypeB;
        
        //Execute Test
        Test.startTest();
        
        OpportunityUtil.syncRevenueAmounts(new Set<Id>{ oOpportunity.Id });
        
        Test.stopTest();
        
        //Validate Test
        oOpportunity = [SELECT Id, Total_Incremental__c, Total_Renewal__c FROM Opportunity WHERE Id = :oOpportunity.Id LIMIT 1];
        System.assertEquals(100, oOpportunity.Total_Incremental__c);
        System.assertEquals(200, oOpportunity.Total_Renewal__c);
    } 
    
    /**
     * Validates the syncRollupRevenueAmounts method when the Override_Revenue_Amount__c field
     * is checked on the opportunity
     */
    private static testMethod void testSyncRollupRevenueAmountsDisabled() {
        //Setup Test
        
        UnitTest.createTestData(); //  As part of  s2e Optimisation project adding test data [Rajashree] 
        
        Account oAccount = UnitTest.getAccountInstance();
        insert oAccount;
        
        Opportunity oOpportunity = UnitTest.getOpportunityInstance(oAccount.Id);
        insert oOpportunity;
        
        Opportunity_Product_Type__c oOpportunityProductTypeA = UnitTest.getOpportunityProductTypeInstance(oOpportunity.Id);
        oOpportunityProductTypeA.Incremental_Amount__c = 50;
        oOpportunityProductTypeA.Renewal_Amount__c = 100;
        insert oOpportunityProductTypeA;
        
        Opportunity_Product_Type__c oOpportunityProductTypeB = UnitTest.getOpportunityProductTypeInstance(oOpportunity.Id);
        oOpportunityProductTypeB.Incremental_Amount__c = 50;
        oOpportunityProductTypeB.Renewal_Amount__c = 100;
        insert oOpportunityProductTypeB;
        
        //Execute Test
        Test.startTest();
        
        oOpportunity.Override_Revenue_Amounts__c = true;
        oOpportunity.Total_Incremental__c = 400;
        oOpportunity.Total_Renewal__c = 600;
        update oOpportunity;
        
        OpportunityUtil.syncRevenueAmounts(new Set<Id>{ oOpportunity.Id });
        
        Test.stopTest();
        
        //Validate Test
        oOpportunity = [SELECT Id, Total_Incremental__c, Total_Renewal__c FROM Opportunity WHERE Id = :oOpportunity.Id LIMIT 1];
        System.assertEquals(400, oOpportunity.Total_Incremental__c);
        System.assertEquals(600, oOpportunity.Total_Renewal__c);
    } 
    
    /**
     * Validates the syncRollupRevenueAmounts method when a Opportunity_Product_Type__c record is removed
     */
    private static testMethod void testSyncRollupRevenueAmountsProductTypeRemoved() {
        //Setup Test
        
        UnitTest.createTestData(); //  As part of  s2e Optimisation project adding test data [Rajashree] 
        
        Account oAccount = UnitTest.getAccountInstance();
        insert oAccount;
        
        Opportunity oOpportunity = UnitTest.getOpportunityInstance(oAccount.Id);
        insert oOpportunity;
        
        Opportunity_Product_Type__c oOpportunityProductTypeA = UnitTest.getOpportunityProductTypeInstance(oOpportunity.Id);
        oOpportunityProductTypeA.Incremental_Amount__c = 50;
        oOpportunityProductTypeA.Renewal_Amount__c = 100;
        insert oOpportunityProductTypeA;
        
        Opportunity_Product_Type__c oOpportunityProductTypeB = UnitTest.getOpportunityProductTypeInstance(oOpportunity.Id);
        oOpportunityProductTypeB.Incremental_Amount__c = 50;
        oOpportunityProductTypeB.Renewal_Amount__c = 100;
        insert oOpportunityProductTypeB;
        
        //Execute Test
        Test.startTest();
        
        delete oOpportunityProductTypeB;
        OpportunityUtil.syncRevenueAmounts(new Set<Id>{ oOpportunity.Id });
        
        Test.stopTest();
        
        //Validate Test
        oOpportunity = [SELECT Id, Total_Incremental__c, Total_Renewal__c FROM Opportunity WHERE Id = :oOpportunity.Id LIMIT 1];
        System.assertEquals(50, oOpportunity.Total_Incremental__c);
        System.assertEquals(100, oOpportunity.Total_Renewal__c);
    } 
    
    /**
     * Validates the getOpportunityIdsFromProductTypes method
     */
    private static testMethod void testGetOpportunityIdsFromProductTypes() {
        //Setup Test
        
        UnitTest.createTestData(); //  As part of  s2e Optimisation project adding test data [Rajashree] 
        
        Account oAccount = UnitTest.getAccountInstance();
        insert oAccount;
        
        Opportunity oOpportunity = UnitTest.getOpportunityInstance(oAccount.Id);
        insert oOpportunity;
        
        List<Opportunity_Product_Type__c> listOpportunityProductTypes = new List<Opportunity_Product_Type__c>();
        
        Opportunity_Product_Type__c oOpportunityProductTypeA = UnitTest.getOpportunityProductTypeInstance(oOpportunity.Id);
        oOpportunityProductTypeA.Incremental_Amount__c = 50;
        oOpportunityProductTypeA.Renewal_Amount__c = 100;
        listOpportunityProductTypes.add(oOpportunityProductTypeA);
        
        Opportunity_Product_Type__c oOpportunityProductTypeB = UnitTest.getOpportunityProductTypeInstance(oOpportunity.Id);
        oOpportunityProductTypeB.Incremental_Amount__c = 50;
        oOpportunityProductTypeB.Renewal_Amount__c = 100;
        listOpportunityProductTypes.add(oOpportunityProductTypeB);
        
        //Execute Test
        Test.startTest();
        
        Set<Id> opportunityIds = OpportunityUtil.getOpportunityIdsFromProductTypes(listOpportunityProductTypes);
        System.assertEquals(1, opportunityIds.size());
        
        Test.stopTest();
        
        
       // testing callAddToSalesTeam() method included in the class OpportunityUtil
       //Execute Test
       
       
        
    } 
    private static testMethod void testCallAddToSalesTeam() 
        {    
           
          UnitTest.createTestData(); //  As part of  s2e Optimisation project adding test data [Rajashree] 
        
           user u = new user();
           u = [select id from user where id !=:userinfo.getuserid() and IsActive=true limit 1];
           
           Account oAccount = UnitTest.getAccountInstance();
           insert oAccount;
           
         
           
           Opportunity oOpportunity = UnitTest.getOpportunityInstance(oAccount.Id);
           
          
           insert oOpportunity;
           
           Opportunityteammember oteamMember = new Opportunityteammember(UserId=u.id,OpportunityId=oOpportunity.id);
         
           insert oteamMember;
           
           
           
           OpportunityShare oppshare = new OpportunityShare(UserorGroupId=u.id,OpportunityId=oOpportunity.id,OpportunityAccessLevel = 'Edit');
           insert oppshare;
       
           Test.startTest();
           
           pageReference pgAddToSalesTeam = page.OpportunityDetail;
           Test.setCurrentPage(pgAddToSalesTeam);
           ApexPages.currentPage().getParameters().put('Id', oOpportunity.Id); 
           OpportunityUtil controller = new OpportunityUtil();

           controller.callAddToSalesTeam();
       
        
           Test.stopTest();
        } 
}