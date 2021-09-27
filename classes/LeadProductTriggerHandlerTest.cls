/**
 * CHANGE HISTORY
 * =============================================================================
 * Date         Name                    Description
 * 2018-04-16   Shailesh Patel          Created
 * =============================================================================
 */ 
@isTest
private class LeadProductTriggerHandlerTest{
    
    public static testMethod void testLeadPrd(){
        
         //Setup Test
        Account account = UnitTest.getAccountInstance();
        account.Name = 'UTLeadAccount';
        insert account;
        
        Lead lead = UnitTest.getLeadInstance();
        lead.Company = 'UTLeadAccount';
        //lead.ConvertedAccountId = account.Id;
        lead.Billing_City__c = 'test';
        lead.Billing_Street__c = 'test';
        lead.Billing_State__c = 'test';
        lead.Billing_Zip__c = 'test';
        insert lead;
        
        Trial__c tr = new Trial__c();
            tr.Contact_LeadId__c = lead.id;        
            
            tr.Trial_Status__c ='Invited';
            insert tr;  
        
        
        Invite_Colleagues__c inviteClg = New Invite_Colleagues__c();
        inviteclg.Lead__c = lead.Id;
        inviteClg.Account__c = account.Id;
        inviteClg.Email__c = 'test@test.com';
        inviteClg.First_Name__c = 'test Shailesh';
        inviteClg.GUID__c = 'GUID';
        inviteClg.Trial_Status__c ='Invited';
        insert inviteClg;
        
        Invite_Colleagues__c inviteClg1 = New Invite_Colleagues__c();
        inviteclg1.Lead__c = lead.Id;
        inviteClg1.Account__c = account.Id;
        inviteClg1.Email__c = 'test@test.com';
        inviteClg1.First_Name__c = 'test invite';
        inviteClg1.GUID__c = 'GUID';
        inviteClg1.Trial_Status__c ='Accepted';
        insert inviteClg1;
        
        Product2 prd = New Product2();
        prd.Name = 'Product Test';
        prd.IsActive = true;
        prd.Duration__c = '12';
        prd.ProductCode = '123456';
        prd.Cellcode__C = 'CellCode';
        insert prd;

        Product2 prd1 = New Product2();
        prd1.Name = 'Product 1 Test';
        prd1.IsActive = true;
        prd1.Duration__c = '12';
        prd1.ProductCode = '12345678';
        prd1.Cellcode__C = 'CellCodeee';
        insert prd1;
        
        LCRM_Recommended_Product__c leadPrd = New LCRM_Recommended_Product__c();
        //leadPrd.External_Id__c = 'testExternal132';
        //leadPrd.Lead__c = lead.Id;
        leadPrd.Trial_ID__c = '123456';
        leadPrd.Cell_Code__C = 'CellCode';
        leadPrd.LCRM_Lead_Name__c = lead.id;
        //leadPrd.Trial_Details__c = tr.id;
        insert leadPrd;
        
        
        
        LCRM_Recommended_Product__c leadPrdinsert =[Select Id,LCRM_Product_Name__c from LCRM_Recommended_Product__c WHERE Cell_Code__C = 'CellCode'];
       
        //System.assert(leadPrdinsert.LCRM_Product_Name__c == prd.Id);
        LeadProductTriggerHandler.trialProductFlag = true;
        leadPrd.Trial_ID__c = '12345678';
        leadPrd.Cell_Code__C = 'CellCodeee';
        update leadPrd;         
    }
}