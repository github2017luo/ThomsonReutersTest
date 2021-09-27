/**
* Test Class for 'Update Campaign Hierarchy fields based on Tactic Level' Process Builder
*
*/

/**
* CHANGE HISTORY
* =============================================================================
* Date         Name                    Description
* 2020-11-24   Miriam Ghosh            Created     
* =============================================================================
*/


@isTest
public class UpdateCampaignHierarchyOnTactic_Test {
    
    public static testmethod void UpdateCampaignHierarchyTestMethod1()
    {
        LTS_Disable_Application_Automation__c ltstemp = new LTS_Disable_Application_Automation__c();
        ltstemp.LTS_Disable_Process_Builders__c = false;
        ltstemp.LTS_Disable_Triggers__c = true;
        ltstemp.LTS_Disable_Validation_Rules__c = true;
        ltstemp.LTS_Disable_Workflow_Rules__c = true;
        ltstemp.Name = 'temp';
        ltstemp.SetupOwnerId = userinfo.getuserid();
        insert ltstemp;
        
        Test.startTest();
        
        Account gliAccount = UnitTest.getAccountInstance();
        gliAccount.Name = 'Test Account';
        gliAccount.Phone = '1234567890';
        gliAccount.BillingCountry = 'US';
        gliAccount.BillingState='IL';
        gliAccount.BillingPostalCode = '60603-3801';
        gliAccount.SAPAccountNumber__c = 'UTSAP001';
        gliAccount.is_gli__c = True;
        insert gliAccount;

        Id RecordTypeIdContact = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('GLI Contact').getRecordTypeId();
        Contact con = new Contact();
        con.AccountId = gliAccount.Id;
        con.FirstName = 'Unit';
        con.LastName = 'Test';
        con.MailingStreet = '123 Unit Test';
        con.MailingCity = 'Dallas';
        con.MailingCountry = 'US';
        con.MailingState = 'TX';
        con.MailingPostalCode = '75019';
        con.RecordTypeId = RecordTypeIdContact;
        insert con;
        
        Lead lod=new Lead();
        lod.FirstName='Miriam';
        lod.LastName='Ghosh';
        lod.Company='TCS';
        lod.Status='Telesales Qualified';
        lod.Country='IN';
        insert lod;
                       
        //Campaign cp =  [SELECT Id FROM Campaign LIMIT 1];
        campaign cp = new campaign();
        cp.name = 'test';
        cp.Lead__c = lod.Id;
        cp.Campaign_Level__c = 'Tactic';
        cp.Offer_Code__c ='12345';
        insert cp;
        
        campaign cp1 = new campaign();
        cp1.name = 'test1';
        cp1.ParentId = cp.Id;
        cp1.Campaign_Level__c = 'Tactic';
        cp1.Offer_Code__c ='12345';
        insert cp1;
        
        campaign cp2 = new campaign();
        cp2.name = 'test2';
        cp2.ParentId = cp1.Id;
        cp2.Campaign_Level__c = 'Tactic';
        cp2.Offer_Code__c ='12345';
        cp2.Program_Type__c = 'TR Live Event';
        insert cp2;
                
        Test.stopTest();
    }
    
    public static testmethod void UpdateCampaignHierarchyTestMethod2()
    {
        LTS_Disable_Application_Automation__c ltstemp = new LTS_Disable_Application_Automation__c();
        ltstemp.LTS_Disable_Process_Builders__c = false;
        ltstemp.LTS_Disable_Triggers__c = true;
        ltstemp.LTS_Disable_Validation_Rules__c = true;
        ltstemp.LTS_Disable_Workflow_Rules__c = true;
        ltstemp.Name = 'temp';
        ltstemp.SetupOwnerId = userinfo.getuserid();
        insert ltstemp;
        
        Test.startTest();
        
        Account gliAccount = UnitTest.getAccountInstance();
        gliAccount.Name = 'Test Account';
        gliAccount.Phone = '1234567890';
        gliAccount.BillingCountry = 'US';
        gliAccount.BillingState='IL';
        gliAccount.BillingPostalCode = '60603-3801';
        gliAccount.SAPAccountNumber__c = 'UTSAP001';
        gliAccount.is_gli__c = True;
        insert gliAccount;

        Id RecordTypeIdContact = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('GLI Contact').getRecordTypeId();
        Contact con = new Contact();
        con.AccountId = gliAccount.Id;
        con.FirstName = 'Unit';
        con.LastName = 'Test';
        con.MailingStreet = '123 Unit Test';
        con.MailingCity = 'Dallas';
        con.MailingCountry = 'US';
        con.MailingState = 'TX';
        con.MailingPostalCode = '75019';
        con.RecordTypeId = RecordTypeIdContact;
        insert con;
        
        Lead lod=new Lead();
        lod.FirstName='Miriam';
        lod.LastName='Ghosh';
        lod.Company='TCS';
        lod.Status='Telesales Qualified';
        lod.Country='IN';
        insert lod;
                       
        //Campaign cp =  [SELECT Id FROM Campaign LIMIT 1];
        campaign cp = new campaign();
        cp.name = 'test';
        cp.Lead__c = lod.Id;
        cp.Campaign_Level__c = 'Tactic';
        cp.Offer_Code__c ='12345';
        cp.Campaign_Theme__c = 'Legal Department 2025';
        insert cp;
        
        campaign cp1 = new campaign();
        cp1.name = 'test1';
        cp1.ParentId = cp.Id;
        cp1.Campaign_Level__c = 'Tactic';
        cp1.Offer_Code__c ='12345';
        cp1.Campaign_Theme__c = 'Legal Department 2025';
        insert cp1;
        
        campaign cp2 = new campaign();
        cp2.name = 'test2';
        cp2.ParentId = cp1.Id;
        cp2.Campaign_Level__c = 'Tactic';
        cp2.Offer_Code__c ='12345';
        insert cp2;
        
        campaign cp3 = new campaign();
        cp3.name = 'test2';
        cp3.ParentId = cp2.Id;
        cp3.Campaign_Level__c = 'Tactic';
        cp3.Offer_Code__c ='12345';
        cp3.Program_Type__c = 'TR Live Event';
        insert cp3;
                
        Test.stopTest();
    }
    
    public static testmethod void UpdateCampaignHierarchyTestMethod3()
    {
        LTS_Disable_Application_Automation__c ltstemp = new LTS_Disable_Application_Automation__c();
        ltstemp.LTS_Disable_Process_Builders__c = false;
        ltstemp.LTS_Disable_Triggers__c = true;
        ltstemp.LTS_Disable_Validation_Rules__c = true;
        ltstemp.LTS_Disable_Workflow_Rules__c = true;
        ltstemp.Name = 'temp';
        ltstemp.SetupOwnerId = userinfo.getuserid();
        insert ltstemp;
        
        Test.startTest();
        
        Account gliAccount = UnitTest.getAccountInstance();
        gliAccount.Name = 'Test Account';
        gliAccount.Phone = '1234567890';
        gliAccount.BillingCountry = 'US';
        gliAccount.BillingState='IL';
        gliAccount.BillingPostalCode = '60603-3801';
        gliAccount.SAPAccountNumber__c = 'UTSAP001';
        gliAccount.is_gli__c = True;
        insert gliAccount;

        Id RecordTypeIdContact = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('GLI Contact').getRecordTypeId();
        Contact con = new Contact();
        con.AccountId = gliAccount.Id;
        con.FirstName = 'Unit';
        con.LastName = 'Test';
        con.MailingStreet = '123 Unit Test';
        con.MailingCity = 'Dallas';
        con.MailingCountry = 'US';
        con.MailingState = 'TX';
        con.MailingPostalCode = '75019';
        con.RecordTypeId = RecordTypeIdContact;
        insert con;
        
        Lead lod=new Lead();
        lod.FirstName='Miriam';
        lod.LastName='Ghosh';
        lod.Company='TCS';
        lod.Status='Telesales Qualified';
        lod.Country='IN';
        insert lod;
                       
        //Campaign cp =  [SELECT Id FROM Campaign LIMIT 1];
        campaign cp = new campaign();
        cp.name = 'test';
        cp.Lead__c = lod.Id;
        cp.Campaign_Level__c = 'Tactic';
        cp.Offer_Code__c ='12345';
        cp.Operating_Unit__c = 'Government';
        insert cp;
        
        campaign cp1 = new campaign();
        cp1.name = 'test1';
        cp1.ParentId = cp.Id;
        cp1.Campaign_Level__c = 'Tactic';
        cp1.Offer_Code__c ='12345';
        cp1.Operating_Unit__c = 'Government';
        insert cp1;
        
        campaign cp2 = new campaign();
        cp2.name = 'test2';
        cp2.ParentId = cp1.Id;
        cp2.Campaign_Level__c = 'Tactic';
        cp2.Offer_Code__c ='12345';
        cp2.Operating_Unit__c = 'Government';
        insert cp2;
        
        campaign cp3 = new campaign();
        cp3.name = 'test3';
        cp3.ParentId = cp2.Id;
        cp3.Campaign_Level__c = 'Tactic';
        cp3.Offer_Code__c ='12345';
        insert cp3;
        
        campaign cp4 = new campaign();
        cp4.name = 'test4';
        cp4.ParentId = cp3.Id;
        cp4.Campaign_Level__c = 'Tactic';
        cp4.Offer_Code__c ='12345';
        insert cp4;

        Test.stopTest();
    }
}