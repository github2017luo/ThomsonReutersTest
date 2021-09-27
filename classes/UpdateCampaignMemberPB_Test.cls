/**
* Test Class for 'Update_Campaign_Member_fields_when_the_lead_is_first_associated' Process Builder
*
*/

/**
* CHANGE HISTORY
* =============================================================================
* Date         Name                    Description
* 2020-07-07   Miriam Ghosh            Created     
* =============================================================================
*/

@isTest
public class UpdateCampaignMemberPB_Test {
    public static testmethod void updatecampaignmemberTestMethod1(){
        
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

        Id RecordTypeIdContact = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Create New Contact').getRecordTypeId();
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
        lod.LCRM_Do_Not_Reassign__c=false;
        //lod.LCRM_Product_Interest__c = 'CheckPoint';
        lod.Campaign_Cell__c = 'test cell';
        lod.Form_Organization_Type__c = 'testOrg';
        lod.Line_of_Business__c = 'HighQ';
        lod.Marketing_Cloud_ID__c = 'test Cloud';
        lod.Operating_Unit__c = 'SLF';
        lod.Source_Desc__c = 'test desc';
        lod.Source__c = 'Direct';
        lod.LeadSource = 'All';
        lod.Tele_Interaction__c = 'BDR';
        insert lod;
                       
        //Campaign cp =  [SELECT Id FROM Campaign LIMIT 1];
        campaign cp = new campaign();
        cp.name = 'test';
        cp.Lead__c = lod.Id;
        cp.Offer_Code__c ='12345';
        insert cp;
        
        CampaignMember cm = new CampaignMember();
        cm.campaignid = cp.id;
        cm.LeadId = lod.id;
        cm.Cloned_from_Lead__c = false;
        /*cm.Tele_Interaction__c = lod.Tele_Interaction__c;
        cm.Source__c = lod.source__c;
        cm.Source_Description__c = lod.Source_Desc__c;
        cm.Operating_Unit__c = lod.Operating_Unit__c;
        cm.Marketing_Cloud_ID__c = lod.Marketing_Cloud_ID__c;
        cm.Line_of_Business__c = lod.Line_of_Business__c;
        cm.Form_Organization_Type__c = lod.Form_Organization_Type__c;
        cm.Campaign_Cell_from_Lead__c = lod.Campaign_Cell__c;*/
        insert cm;
        
        CampaignMember cmp1 = [select id, leadID, cloned_from_lead__c from CampaignMember where id =: cm.id];
        system.debug('@@@value of cmp1'+cmp1);
        
        system.debug('@@@value of lead1'+lod.Id);
        //system.debug('@@@value of product interest from lod2'+lod2.LCRM_Product_Interest__c);

        Test.stopTest();
        
        /*system.assertEquals(lod.Tele_Interaction__c,cm.Tele_Interaction__c);
        system.assertEquals(lod.LeadSource, cm.LeadSource);
        system.assertEquals( lod.Source__c, cm.Source__c);
        system.assertEquals(lod.Source_Desc__c, cm.Source_Description__c);
        system.assertEquals(lod.Operating_Unit__c, cm.Operating_Unit__c);
        system.assertEquals(lod.Marketing_Cloud_ID__c, cm.Marketing_Cloud_ID__c);
        system.assertEquals(lod.Line_of_Business__c, cm.Line_of_Business__c);
        system.assertEquals(lod.Form_Organization_Type__c,  cm.Form_Organization_Type__c);
        system.assertEquals(lod.LCRM_Product_Interest__c, cm.Product_of_Interest__c);
        system.assertEquals(lod.Campaign_Cell__c, cm.Campaign_Cell_from_Lead__c);*/
        
        
    }

    
    public static testmethod void updatecampaignmemberTestMethod2(){
        
        LTS_Disable_Application_Automation__c ltstemp2 = new LTS_Disable_Application_Automation__c();
        ltstemp2.LTS_Disable_Process_Builders__c = false;
        ltstemp2.LTS_Disable_Triggers__c = true;
        ltstemp2.LTS_Disable_Validation_Rules__c = true;
        ltstemp2.LTS_Disable_Workflow_Rules__c = true;
        ltstemp2.Name = 'temp';
        ltstemp2.SetupOwnerId = userinfo.getuserid();
        insert ltstemp2;
        
        Test.startTest();
        
        Account gliAccount2 = UnitTest.getAccountInstance();
        gliAccount2.Name = 'Test Account';
        gliAccount2.Phone = '1234567890';
        gliAccount2.BillingCountry = 'US';
        gliAccount2.BillingState='IL';
        gliAccount2.BillingPostalCode = '60603-3801';
        gliAccount2.SAPAccountNumber__c = 'UTSAP001';
        gliAccount2.is_gli__c = True;
        insert gliAccount2;

        Id RecordTypeIdContact2 = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Create New Contact').getRecordTypeId();
        Contact con2 = new Contact();
        con2.AccountId = gliAccount2.Id;
        con2.FirstName = 'Unit';
        con2.LastName = 'Test';
        con2.MailingStreet = '123 Unit Test';
        con2.MailingCity = 'Dallas';
        con2.MailingCountry = 'US';
        con2.MailingState = 'TX';
        con2.MailingPostalCode = '75019';
        con2.RecordTypeId = RecordTypeIdContact2;
        insert con2;
        
              
        Lead lod2=new Lead();
        lod2.FirstName='M';
        lod2.LastName='Ghosh';
        lod2.Company='TCS';
        lod2.Status='Telesales Qualified';
        lod2.Country='IN';
        lod2.LCRM_Do_Not_Reassign__c=false;
        lod2.LCRM_Product_Interest__c = 'CheckPoint';
        insert lod2;
        
        //Campaign cp =  [SELECT Id FROM Campaign LIMIT 1];
        campaign cp = new campaign();
        cp.name = 'test';
        cp.Lead__c = lod2.Id;
        cp.Offer_Code__c ='12345';
        insert cp;
                     
        CampaignMember cm2 = new CampaignMember();
        cm2.campaignid = cp.id;
        cm2.LeadId = lod2.id;
        cm2.Cloned_from_Lead__c = false;
        insert cm2;
        
        CampaignMember cmp2 = [select id, leadID, cloned_from_lead__c from CampaignMember where id =: cm2.id];
        system.debug('@@@value of cmp2'+cmp2);
        system.debug('@@@value of lead2'+lod2.Id);
        system.debug('@@@value of product interest from lod2'+lod2.LCRM_Product_Interest__c);

        Test.stopTest();
    }

}