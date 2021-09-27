/**
 * CHANGE HISTORY
 * =============================================================================
 * Date         Name                    Description
 * 2018-04-02   Shailesh Patel          Created
 * 2018-09-17   Harshitha KN            Added some changes for DLT-12091
 * =============================================================================
 */ 
@isTest
private class LeadConvDetail_Test{
    
   
   public static testMethod void testLeadSSDConvertDetailswitssd(){      
         //Setup Test
        Account account = UnitTest.getAccountInstance();
        account.Name = 'UTLeadAccount1';
        insert account;
        
               
        Source_System_Detail__c ssdacc =new Source_System_Detail__c();
        ssdacc.Account_Name__c=account.id;
        ssdacc.Source_System_Account_Number__c='10002121';
        ssdacc.name='test';
        ssdacc.Source_System_Name__c='test';
        insert ssdacc;
        
        Id leadRecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('GLI').getRecordTypeId();
        Lead lead = UnitTest.getLeadInstance();
        lead.Company = 'UTLeadAccount1';        
        lead.Billing_City__c = 'test';
        lead.Billing_Street__c = 'test';
        lead.Billing_State__c = 'test';
        lead.Billing_Zip__c = 'test'; 
        lead.Billing_Country__c='test';
        lead.SAPAccountNumber__c='10002121'; 
        lead.RecordTypeId = leadRecordTypeId;     
        insert lead;  
        
        Trial__c tr = new Trial__c();
        tr.Contact_LeadId__c = lead.id;        
        tr.Account_Name__c = account.id;
        tr.Trial_Status__c ='Invited';
        insert tr;   
        
        Invite_Colleagues__c inviteClg = New Invite_Colleagues__c();
        inviteclg.Lead__c = lead.Id;
        inviteClg.Account__c = account.Id;
        inviteClg.Email__c = 'test@test.com';
        inviteClg.First_Name__c = 'test Shailesh';
        inviteClg.Last_Name__c = 'ODT';
        inviteClg.GUID__c = 'GUID';
        inviteClg.Trial_Status__c ='Invited';
        insert inviteClg;
       
        //DLT-12091 Start: Added by Harshitha 
        date d1=Date.today();
        date d2=Date.today()+7;
       
        ODT_UpdateInvitedColleagueStatus.updateInvitedColleague('asbdvsjilbvsdbvlksjdvbsdbv', 'cfjjgjkjkjkjjkkj', '', 'Accepted', '0987653', d1, d2);
        //DLT-12091 End
       
        Invite_Colleagues__c inviteClg1 = New Invite_Colleagues__c();
        inviteclg1.Lead__c = lead.Id;
        inviteClg1.Account__c = account.Id;
        inviteClg1.Email__c = 'test1@test.com';
        inviteClg1.First_Name__c = 'test invite';
        inviteClg1.Last_Name__c = 'ODT2';
        inviteClg1.GUID__c = 'GUID';
        inviteClg1.Trial_Status__c ='Invited';
        insert inviteClg1;
       
        //DLT-12091 Start:Added by Harshitha
        Trial__c tr1= new Trial__c();
        tr1.Trial_Status__c ='Accepted';
        tr1.Trial_Start_Date__c=date.today();
        tr1.Trial_End_Date__c=date.today()+7;
        insert tr1; 
       
        ODT_UpdateInvitedColleagueStatus.updateInvitedColleague('efwrftgt', '12465497', 'test1234@test.com', 'Accepted', '659874', d1, d2);
        
        Invite_Colleagues__c inviteClg2 = New Invite_Colleagues__c();
        inviteClg2.Email__c = 'test3@test.com';
        inviteClg2.First_Name__c = 'test invite';
        inviteClg2.Last_Name__c = 'ODT2';
        inviteClg2.Global_Trial_ID__c = 'jeiojfpeojf';
        inviteClg2.GUID__c = 'GUID';
        inviteClg2.Trial_Status__c ='Invited';
        inviteClg2.SapContactId__c = '9877897';
        inviteClg2.Trial__c = tr1.Id;
        insert inviteClg2;
       
        date d3=date.today()+1;
        date d4=date.today()+8;
        ODT_UpdateInvitedColleagueStatus.updateInvitedColleague('kjhfihfihff', '131647', 'test3@test.com', 'Accepted', '098754', d3, d4); 
        //DLT-12091 End
       
        Set<Id> inviteclgIds = New Set<Id>();
        inviteclgIds.add(inviteClg.Id);
        LeadConvDetail.createInvitedColleagues(inviteclgIds);  
        
        Product2 prd = New Product2();
        prd.Name = 'Product Test';
        prd.IsActive = true;
        prd.Duration__c = '12';
        insert prd;
        
        /*Lead_Product__c leadPrd = New Lead_Product__c();
        leadPrd.External_Id__c = 'testExternal132';
        leadPrd.Lead__c = lead.Id;
        leadPrd.Product__c = prd.ID;
        insert leadPrd;*/
       
        LCRM_Recommended_Product__c leadPrd = new LCRM_Recommended_Product__c();
        leadPrd.LCRM_Lead_Name__c = lead.Id;
        leadPrd.LCRM_Product_Name__c = prd.ID;
        insert leadPrd;
        
        Test.startTest();
        Database.LeadConvert lc = new Database.LeadConvert();
        lc.setLeadId(Lead.id);              
        LeadStatus convertStatus = [Select Id, MasterLabel from LeadStatus where IsConverted=true AND MasterLabel LIKE 'Sales%' limit 1];
        lc.setConvertedStatus(convertStatus.MasterLabel);
        lc.setDoNotCreateOpportunity(true);       
        Database.LeadConvertResult lcr = Database.convertLead(lc);
        System.assert(lcr.isSuccess());

        Set<Id> leadIds = New Set<Id>();
        leadIds.add(lead.Id);
        LeadConvDetail.getLeadProdDetails(leadIds);
        LeadConvDetail.getContractDetails(leadIds);
        Test.stopTest();
  }
}