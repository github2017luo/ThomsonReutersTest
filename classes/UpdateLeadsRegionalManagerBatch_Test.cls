@IsTest
Private class UpdateLeadsRegionalManagerBatch_Test{

    private static testMethod void testRegionalManagerOnLead () {
        
         String pId=[select id from Profile where Name='System Administrator'].id;
        //setup Test
        
        
        User leadOwner= new User();
        leadOwner.Alias='TLO';
        leadOwner.FirstName='test';
        leadOwner.LastName='leadOwner';
        leadOwner.Email='testLeadOwner@test.com';
        leadOwner.Username='testLeadOwner@test.com';
        leadOwner.ProfileId=pId;
        leadOwner.TimeZoneSidKey='America/Los_Angeles';
        leadOwner.LanguageLocaleKey='en_US';
        leadOwner.LocaleSidKey='en_US';
        leadOwner.EmailEncodingKey='ISO-8859-1';
        leadOwner.CurrencyIsoCode='USD';
        
        insert leadOwner;
        
        
        
        Lead testLead=new Lead();
        testLead.FirstName='Test';
        testLead.LastName='Lead';
        testLead.OwnerId=leadOwner.Id;
        testLead.Company='testing';
        
        insert testLead;
        
        User regionalManager= new User();
        regionalManager.Alias='TRM';
        regionalManager.FirstName='test';
        regionalManager.LastName='RegionalManager';
        regionalManager.Email='testRegionalManager@test.com';
        regionalManager.Username='testRegionalManager@test.com';
        regionalManager.ProfileId=pId;
        regionalManager.TimeZoneSidKey='America/Los_Angeles';
        regionalManager.LanguageLocaleKey='en_US';
        regionalManager.LocaleSidKey='en_US';
        regionalManager.EmailEncodingKey='ISO-8859-1';
        regionalManager.CurrencyIsoCode='USD';
        
        insert regionalManager;
        
        leadOwner.LM_Regional_Manager__c=regionalManager.Id;
        
        update leadOwner;
        
        Map<string,string> userManagerIdMap=new Map<string,string>();
        userManagerIdMap.put(testLead.OwnerId,leadOwner.LM_Regional_Manager__c);
        
        //Execute Test
        Test.startTest();
        UpdateLeadsSalesRegionalManagerBatch updlead = new UpdateLeadsSalesRegionalManagerBatch(userManagerIdMap);
        ID batchJobId=Database.executeBatch(updlead);
        Test.stopTest();
        
        //Validate Test
        testLead=[Select id,Regional_Manager__c from Lead where id= :testLead.id];
        System.assertEquals(regionalManager.id, testLead.Regional_Manager__c);
    }
}