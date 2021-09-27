@isTest( seeAllData = false)
public  class MarketingPreferencesController_Test 
{
   
    @isTest static void unitTest() 
    {
        LCRM_Country_List_Europe__c cle = new LCRM_Country_List_Europe__c(Name = 'GB');
        insert cle;
        User u = TestData.createTestUser();
        System.runAs(u) 
        {
            Boolean Test1=false;
            LCRM_Preference_Center__c PreferenceCenter= testData.createTestPreferenceCenter();
            Account acc = TestData.createTestAccount();         
            Contact con= TestData.createTestContact(acc);
            Profile stdProfile = TestData.TestDataProfile();
            PageReference pageRef = Page.MarketingPreferencesSection;
            Test one = new Test();
            test.setCurrentPage(pageRef);
            ApexPages.StandardController oStandardController = new ApexPages.StandardController(con); 
            Apexpages.currentpage().getParameters().put('id',con.Id);          
            MarketingPreferencesController oController = new MarketingPreferencesController(oStandardController);
            string IDOfthePage = apexpages.currentpage().getparameters().get('id'); 
            LCRMPreferenceMethod oMethod = new LCRMPreferenceMethod();
            test.StartTest();
            oMethod.preferenceCenterLink = oMethod.getPreferenceCenterLink(con.Email,con.Id,u.Sub_Bu__c,con.LCRM_Country__c,con.id);
            
            //system.debug('@@ ID Of The Page'+ oMethod.IDOfthePage); 
            // oController.LCRMPreferenceMethod = oMethod;
            oController.oContact = con;
            oController.isEditable = false;
            oController.CheckPermission = false;
            oController.profileName =stdProfile.name;
            oController.changeToEdit();
            //Call Savepoint
            oController.save();
            System.assertNotEquals(null,oController.Save());
            oController.cancel();
            test.StopTest();
            
        }
    }
    
    //LCRM Lead Preference Section Controller code coverage
    
    @isTest static void TestLead() 
    {
        LCRM_Country_List_Europe__c cle = new LCRM_Country_List_Europe__c(Name = 'GB');
        insert cle;
        User u = TestData.createTestUser();
        System.runAs(u) 
        {
            Boolean Test1=false;
            LCRM_Preference_Center__c PreferenceCenter= testData.createTestPreferenceCenter();
            Account acc = TestData.createTestAccount();         
            Contact con= TestData.createTestContact(acc);
            Lead oLead = TestData.createTestLead(con);
            Profile stdProfile = TestData.TestDataProfile();
            PageReference pageRef = Page.LCRM_LeadMarketingPreferencesSection;
            test.setCurrentPage(pageRef);
            ApexPages.StandardController oStandardController = new ApexPages.StandardController(oLead);    
            Apexpages.currentpage().getParameters().put('id',oLead.Id);       
            LeadMarketingPreferencesController oController = new LeadMarketingPreferencesController(oStandardController);
            string IDOfthePage = string.valueOf(Apexpages.currentpage().getparameters().get('id'));
            system.debug('@@ ID Of The Page'+ IDOfthePage);  
            LCRMPreferenceMethod oMethod = new LCRMPreferenceMethod();
            test.StartTest();
            oMethod.IDOfthePage = oLead.Id; 
            
            oController.preferenceCenterLink = oMethod.getPreferenceCenterLink(con.Email,con.Id,u.Sub_Bu__c,oLead.Billing_Country__c,OLead.id);
            //oController.tpsLink = oMethod.getTPSLink(oLead.Id);
            oController.preferenceMethod = oMethod;
            oController.oLead = oLead;
            test.Stoptest();
            
            
            
        }
    }
    
    @isTest static void getTRPreferenceCenterLinkTest(){
        LCRM_Country_List_Europe__c cle = new LCRM_Country_List_Europe__c(Name = 'GB');
        insert cle;
        LCRM_Preference_Center__c PreferenceCenter= testData.createTestPreferenceCenter();
        Account acc = TestData.createTestAccount();         
        Contact con= TestData.createTestContact(acc);
        //LCRMPreferenceMethod oMethod = new LCRMPreferenceMethod();
        LCRMPreferenceMethod.getTRPreferenceCenterLink(String.valueof(con.id));
        System.assertEquals(String.isNotBlank( LCRMPreferenceMethod.getTRPreferenceCenterLink(String.valueof(con.id))),true);
    }
    //Lightning-PreferenceLink
    @isTest static void getLightningPreferenceLink(){
        
        
        Profile stdProfile = [SELECT Id,name FROM Profile WHERE Name='System Administrator'];
        User u = new User(
            Alias = 'standt', 
            Email='abc1@testorg.com',
            EmailEncodingKey='UTF-8', 
            LastName='Testing', 
            LanguageLocaleKey='en_US',
            LocaleSidKey='en_US', 
            ProfileId = stdProfile.Id,
            TimeZoneSidKey='America/Los_Angeles',
            Sub_Bu__c ='UKI ',
            UserName='abc1@testorg.com'
        ); 
        insert u;
        PermissionSet ps = [SELECT Id FROM PermissionSet WHERE Name = 'LEX_LightningExpAccess' Limit 1 ];
        insert new PermissionSetAssignment(AssigneeId = u.id, PermissionSetId = ps.Id);
        
        //LEX_HideClassicAccess
        
        PermissionSet ps1 = [SELECT Id FROM PermissionSet WHERE Name = 'LEX_HideClassicAccess' Limit 1 ];
        insert new PermissionSetAssignment(AssigneeId = u.id, PermissionSetId = ps1.Id);
        
        
        
        System.runAs(u){
            LCRM_Country_List_Europe__c cle = new LCRM_Country_List_Europe__c(Name = 'AL',CountryName__c = 'AL');
            insert cle;

            LCRM_Preference_Center__c PreferenceCenter = new LCRM_Preference_Center__c(
                name='AL',
                LCRM_Preference_Center_Link__c='http://ask.legalsolutions.thomsonreuters.info/gli-preference-center'
            );
            insert PreferenceCenter;
            LeadMarketingPreferencesController.lightningFlag = true;
           
            Account acc = new Account(
                Name = 'Test To Check For Abbriviated Name', 
                Phone = '3198374720',
                BillingCountry ='AL',
                BillingState='11',
                BillingPostalCode = '1019',        
                Description='Good'
            );
            insert acc;
            
            Contact con = new Contact(
                FirstName='Test' ,
                LastName = 'TestLastName To Check For Abbriviated Name', 
                Title='senior devloper',
                Phone = '3198374720', 
                AccountId = acc.Id, 
                DoNotCall=true,
                Do_not_Mail__c=false,
                Email = 'test@gmail.com'
                
                
            );
            insert con; 
            
            Lead TestLead = new Lead();
            TestLead.FirstName = 'Unit';
            TestLead.LastName = 'Tester';
            TestLead.Company = 'Unit Test Company';
            TestLead.Status = 'Contacting';
            TestLead.country='AL';
            TestLead.PostalCode= '1019';
            TestLead.City= 'TIRANE';
            TestLead.Contact__c = con.Id;
            TestLead.email = 'testa2@test.com';
            insert TestLead;
            
            
            test.StartTest();      
            ApexPages.StandardController oStandardController = new ApexPages.StandardController(TestLead);      
            PageReference pageRef = Page.LCRM_LeadMarketingPreferencesSection;                     
            pageRef.getParameters().put('id',TestLead.Id);    
            test.setCurrentPage(pageRef);     
            LeadMarketingPreferencesController oController = new LeadMarketingPreferencesController(oStandardController);               
            string IDOfthePage = string.valueOf(Apexpages.currentpage().getparameters().get('id'));
            system.debug('@@ ID Of The Page'+ IDOfthePage);  
            LCRMPreferenceMethod oMethod = new LCRMPreferenceMethod();
           
            
            oMethod.IDOfthePage = TestLead.Id; 
            
            oController.preferenceCenterLink = oMethod.getPreferenceCenterLink(con.Email,con.Id,u.Sub_Bu__c,TestLead.Country,TestLead.id);
            //oController.tpsLink = oMethod.getTPSLink(oLead.Id);
            oController.preferenceMethod = oMethod;
            oController.oLead = TestLead;
            test.Stoptest();
        }
        
        
        
        
    }
    
}