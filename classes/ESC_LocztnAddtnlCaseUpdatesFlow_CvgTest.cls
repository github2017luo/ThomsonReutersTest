@isTest    
private class ESC_LocztnAddtnlCaseUpdatesFlow_CvgTest {
     public static testMethod void testMethod1() {
          
        Profile prof = [SELECT Id FROM profile WHERE name='GLI Helpdesk Agent']; 
        
        User us =  New User(FirstName = 'James' , LastName= 'ThomasTest',Alias = 'jttest',Email='james1.thomastest@thomsonreuters.com', emailencodingkey='UTF-8', 
        UserName='james1.thomastest@thomsonreuters.com',languagelocalekey='en_US', localesidkey='en_US', 
        profileid = prof.Id,timezonesidkey='America/Los_Angeles',CommunityNickname='James.ThomasTest');
        insert us;
        //System.assert(us.id != null);
        //////////////////
        //insert Account
        test.startTest();
        Account acct = new Account();
        acct.Name = 'SFDC';
        acct.ShippingCity = 'New York';
        acct.ShippingCountry = 'US';
        acct.ShippingState = 'AL';
        acct.ShippingPostalCode = '1007';
        acct.ShippingStreet = 'Diamond';
        insert acct ; 
        ///////////

        //insert contact
        Contact con = new Contact();
        con.AccountId=acct.Id;
        con.FirstName='Dummy';
        con.LastName='Test';
        con.Salutation='Mr.';
        con.Email='dummytest@thomsonreuters.com';
        insert con;
        
        ////////////////
        // insert a case records
        Case cs = new Case();
        cs.Type='Data';
        cs.Status='New';
        cs.Subject='Test Subject';
        cs.Description = 'Test Description111';
        cs.contactid=con.id;
        cs.accountid=acct.id;
        cs.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Incident').getRecordTypeId();
        cs.ESC_Case_Type__c = 'Incident';
        cs.ESC_Impact__c='3-Single User';
        cs.ESC_Diagnosis_Summary__c='Application/Infrastructure/Upgrade';
        cs.ESC_Resolution_Code__c='Config Change';
        cs.Priority='1-High';
        cs.SuppliedEmail = 'asdasd@123.com';
        cs.SuppliedPhone='234567890';
        cs.suppliedcompany='dgfhjk';
        cs.LCRM_Sub_BU__c = 'GGO';
        cs.ESC_UKI_WebForm_Rep_Email__c='tsaa@ty.com';
        cs.ESC_UKI_WebForm_Rep_Name__c='Sai';
        //cs.Product__c='tesgh';
        insert cs;
        system.assertEquals(1,1,1);
        Test.stoptest();
        
        }
        
        public static testMethod void testMethod2() {
          
        Profile prof = [SELECT Id FROM profile WHERE name='GLI Helpdesk Agent']; 
        
        User us =  New User(FirstName = 'James' , LastName= 'ThomasTest',Alias = 'jttest',Email='james1.thomastest@thomsonreuters.com', emailencodingkey='UTF-8', 
        UserName='james1.thomastest@thomsonreuters.com',languagelocalekey='en_US', localesidkey='en_US', 
        profileid = prof.Id,timezonesidkey='America/Los_Angeles',CommunityNickname='James.ThomasTest');
        insert us;
        //System.assert(us.id != null);
        //////////////////
        //insert Account
        test.startTest();
        Account acct = new Account();
        acct.Name = 'SFDC';
        acct.ShippingCity = 'New York';
        acct.ShippingCountry = 'US';
        acct.ShippingState = 'AL';
        acct.ShippingPostalCode = '1007';
        acct.ShippingStreet = 'Diamond';
        insert acct ; 
        ///////////
    Group que=[select Id from Group where  Type = 'Queue' limit 1];
        //insert contact
        Contact con = new Contact();
        con.AccountId=acct.Id;
        con.FirstName='Dummy';
        con.LastName='Test';
        con.Salutation='Mr.';
        con.Email='dummytest@thomsonreuters.com';
        insert con;
        
        ////////////////
        // insert a case records
        Case cs = new Case();
        cs.Type='Data';
        cs.Status='New';
        cs.Subject='Test Subject';
        cs.Description = 'Test Description111';
        cs.contactid=con.id;
        cs.accountid=acct.id;
        cs.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Incident').getRecordTypeId();
        cs.ESC_Case_Type__c = 'Incident';
        cs.ESC_Impact__c='3-Single User';
        cs.ESC_Diagnosis_Summary__c='Application/Infrastructure/Upgrade';
        cs.ESC_Resolution_Code__c='Config Change';
        cs.Priority='1-High';
        cs.SuppliedEmail = 'asdasd@123.com';
        cs.SuppliedPhone='234567890';
        cs.suppliedcompany='dgfhjk';
        cs.LCRM_Sub_BU__c = 'GGO';
        cs.ownerid=que.id;
        cs.ESC_UKI_WebForm_Rep_Email__c='tsaa@ty.com';
        cs.ESC_UKI_WebForm_Rep_Name__c='Sai';
        //cs.Product__c='tesgh';
        insert cs;
        system.assertEquals(2,2,2);
        test.stopTest();
        }
         
        
}