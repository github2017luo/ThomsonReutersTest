@isTest
public class ODT_AddNetnewInvitedcolleagueCalloutTest{

    static testmethod void handleODTTrialAfterUpdateTest()
    {
       //create Trial
       Trial__c tr=new Trial__c();
       tr.Trial_Id__c='56576';
       tr.Trial_Source__c='ls.com';
       tr.InvitedDateTime__c=System.today()-200;
       tr.Trial_Status__c = 'Invited';
       tr.Trial_Start_Date__c = System.today();
       tr.Trial_End_Date__c = System.today()+7;
       tr.Trial_Journey__c = 'Rep Initiated Journey';
       insert tr;
     
     
       Invite_Colleagues__c invitedClg1 = New Invite_Colleagues__c();
        invitedClg1.First_Name__c = 'test invite';
        invitedClg1.Last_Name__c = 'tessstt';
        invitedClg1.Trial_Status__c = 'Invited';
        invitedClg1.Trial__c = tr.id;
        insert invitedClg1; 
        
        
        WebServiceSettings__c webs4 = new WebServiceSettings__c();
        webs4.Endpoint__c = 'test2.endpoint';
        webs4.Name = 'ODTEloquaServiceOtherSources';   //ODTEloquaServiceOtherSources
        webs4.Username__c = 'test2.user';
        webs4.Password__c = 'test2:123';
        webs4.Service_Unavailable_Message__c = 'test2service';
         
       insert webs4;
       
       
       
       LIST<id> incList = new LIST<id>();
       incList.add(invitedClg1.id);
       
       
       ODT_AddNetnewInvitedcolleagueCallout incC = new ODT_AddNetnewInvitedcolleagueCallout(incList);
       System.enqueueJob(incC);
       
       ODT_AddNetnewInvitedcolleagueCallout.sendEloquaRequestToINC(invitedClg1);
       
       
       
    }   


}