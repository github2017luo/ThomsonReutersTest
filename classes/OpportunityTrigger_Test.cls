@IsTest
(seeAllData=false)
private class OpportunityTrigger_Test {

    private static testMethod void OpportunityTriggerMethod() {

        UnitTest.createTestData();
        
        KeyValueListStore__c kv1 = new KeyValueListStore__c ();
        kv1.Name = 'ReasonWithCompetitor';
        kv1.TextValue__c ='TR Corp Partner Community User';
        Insert kv1;
        
        Account oAccount = UnitTest.getAccountInstance();
        insert oAccount;
        
        Opportunity oOpportunity = UnitTest.getOpportunityInstance(oAccount.Id);
        insert oOpportunity;
        
        Account oAccount1 = UnitTest.getAccountInstance();
        insert oAccount1;
        
        Opportunity oOpportunity1 = UnitTest.getOpportunityInstance(oAccount1.Id);
       // oOpportunity1.RecordTypeId= [SELECT Id FROM RecordType WHERE sObjectType = 'Opportunity' AND DeveloperName = 'LATAM_Renewal_Opportunity' LIMIT 1].Id;
       oOpportunity1.RecordTypeId = RecordtypeIds__c.getInstance('LATAM Renewal Opportunity').recTypeId__c;
        oOpportunity1.Renewal_Flag__c = true;
        oOpportunity1.CloseDate = System.today();
        insert oOpportunity1;


    } 
        
}