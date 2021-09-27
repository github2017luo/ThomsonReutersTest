@isTest
public class ODTTrialTriggerHandlerTest {
    static testmethod void handleODTTrialAfterUpdateTest()
    {
       //create Trial
       Trial__c tr=new Trial__c();
       tr.Trial_Id__c='56576';
       tr.Trial_Source__c=label.ODT_Trial_Source;
       tr.InvitedDateTime__c=System.today()-200;
       tr.Trial_Status__c = 'Invited';
       tr.Trial_Start_Date__c = System.today();
       tr.Trial_End_Date__c = System.today()+7;
       tr.Trial_Journey__c = 'Rep Initiated Journey';
       insert tr;
        
        LCRM_Recommended_Product__c leadPrd = New LCRM_Recommended_Product__c();
        leadPrd.Trial_ID__c = '123456';
        leadPrd.Cell_Code__C = 'CellCode';
        leadPrd.Trial_Details__c= tr.id;
        insert leadPrd;
        
        /* //DLT-11637 starts: Added by Harshitha 
        LeadStatus convertedStatus = [Select Id, MasterLabel from LeadStatus where IsConverted=true AND MasterLabel='Sales Qualified'];
        LeadStatus beforeConvertingStatus = [Select Id, MasterLabel from LeadStatus LIMIT 1];
        Lead lead=new Lead(LastName='Doe',FirstName='John',Company='Test',Status=beforeConvertingStatus.MasterLabel);
        insert lead;
        Database.LeadConvert lc = new database.LeadConvert();
        lc.setLeadId(lead.id);
        lc.setDoNotCreateOpportunity(true);
        lc.setConvertedStatus(convertedStatus.MasterLabel);
        Database.LeadConvertResult lcr = Database.convertLead(lc);
        System.assert(lcr.isSuccess());

        Account acct = new Account();
        acct = UnitTest.getAccountInstance();
        acct.Phone = '123456';
        acct.Website = 'test.website@email.xxx';
        acct.SAPAccountNumber__c = '1004284494';
        insert acct;
        
        asset a = new Asset();
        a.Trial_Details__c= tr.id;
        a.Name='check';
        a.AccountId=acct.id;
        insert a; 
        
        Invite_Colleagues__c invitedClg1 = New Invite_Colleagues__c();
        invitedClg1.First_Name__c = 'test invite';
        invitedClg1.Last_Name__c = 'tessstt';
        invitedClg1.Trial_Status__c = 'Invited';
        invitedClg1.Trial__c = tr.id;
        invitedClg1.Lead__c = lead.id; 
        insert invitedClg1; 
        
        invitedClg1.Trial_Status__c='Accepted';
        update invitedClg1;
        //DLT-11637 ends */
        
        //DLT-12322 Starts:Added by Harshitha
        Invite_Colleagues__c invitedClg2 = New Invite_Colleagues__c();
        invitedClg2.First_Name__c = 'test invite';
        invitedClg2.Last_Name__c = 'tessstt';
        invitedClg2.Trial_Status__c = 'Invited';
        invitedClg2.Trial__c = tr.id;
        //vitedClg2.Lead__c = lead.id; 
        invitedClg2.Primary_User__c = true;
        insert invitedClg2;
        //DLT-12322 Ends
        
        tr.Trial_Status__c='Accepted';
        update tr;
    }
}