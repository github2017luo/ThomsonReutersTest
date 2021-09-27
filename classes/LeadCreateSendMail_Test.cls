@IsTest(seeAllData=TRUE)
public class LeadCreateSendMail_Test{
    
    public static Group g;
    public static Group gp;
    
    public static testMethod void Testsave(){
    
     string testprofile = [SELECT Id FROM profile WHERE name='System Administrator'].id;   
         
        User testuser = [select Id from User where ProfileId =:testprofile limit 1];
        Group grp = [Select Id from Group where Type = 'Queue' and Name = 'ANZ Sales Leads' limit 1];
        
        LM_SLA__C LMSLA1 = new LM_SLA__C();
        LMSLA1.Lead_Score__c='A2';    
        LMSLA1.Send_Notification_Email__c=true;
        LMSLA1.Channel__c='Tax Profile';
       // LMSLA1.add(LMSLA1);
        insert LMSLA1;
        list<Lead> NewLeadList = new list<Lead>();
       // Map<id,Lead> NewLeadList1 = new map<id,Lead>();
        Lead NewLeadListinsert = new lead();
        //                      NewLeadListinsert.lead.id='2F07M29000000KroJ';
        NewLeadListinsert.Company='TCS';
        //   .. NewLeadListinsert.name='TCS1';
        NewLeadListinsert.firstname='Test1';
        NewLeadListinsert.lastname='Test2';
        NewLeadListinsert.Business_Org__c='Tax Profile';
        NewLeadListinsert.Lead_Scoring_Combined__c='A2';
         NewLeadListinsert.Ownerid=grp.id;
        NewLeadListinsert.Source_Desc__c='UAT';
        NewLeadListinsert.Description='test Lead';
        NewLeadListinsert.Billing_Street__c='Gokul';
        NewLeadListinsert.Billing_City__c='Bangalore';
        NewLeadListinsert.Billing_Zip__c='343434';
        NewLeadListinsert.Billing_State__c='Karnataka';
        NewLeadListinsert.Source__c='UAT';
        NewLeadListinsert.Phone='349876254245';
        NewLeadListinsert.Email='test@gamil.com';
        NewLeadListinsert.Sales_Org__c = 'LRA';
        NewLeadList.add(NewLeadListinsert);
        insert NewLeadList;    
    LeadCreateSendMail.NewLeadCreation(NewLeadList);
        
  /*  g = new Group(
    Name = 'unit test group',
    DeveloperName = 'unit_test_group',
    Type = 'Queue'
);
insert g;

GroupMember gp1 = new GroupMember(
    GroupId = g.Id,
    UserOrGroupId = testuser.Id
);
insert gp1; */
    
  }
  
  
    public static testMethod void TestsaveUser(){
    
     string testprofile = [SELECT Id FROM profile WHERE name='System Administrator' ].id;   
         
        User testuser = [select Id from User where ProfileId =:testprofile and isActive=true limit 1];
        Group grp = [Select Id from Group where Type = 'Queue' and Name = 'ANZ Sales Leads' limit 1];
        
        LM_SLA__C LMSLA2 = new LM_SLA__C();
        LMSLA2.Lead_Score__c='A2';    
        LMSLA2.Send_Notification_Email__c=true;
        LMSLA2.Channel__c='User Profile';
       // LMSLA1.add(LMSLA1);
        insert LMSLA2;
        list<Lead> NewLeadList1 = new list<Lead>();
       // Map<id,Lead> NewLeadList1 = new map<id,Lead>();
        Lead NewLeadListinsert1 = new lead();
        //                      NewLeadListinsert.lead.id='2F07M29000000KroJ';
        NewLeadListinsert1.Company='TCS1';
        //   .. NewLeadListinsert.name='TCS1';
        NewLeadListinsert1.firstname='Test2';
        NewLeadListinsert1.lastname='Test3';
        NewLeadListinsert1.Business_Org__c='User Profile';
        NewLeadListinsert1.Lead_Scoring_Combined__c='A2';
         NewLeadListinsert1.Ownerid=testuser.id;
        NewLeadListinsert1.Source_Desc__c='UAT';
        NewLeadListinsert1.Description='test Lead';
        NewLeadListinsert1.Billing_Street__c='Gokul';
        NewLeadListinsert1.Billing_City__c='Bangalore';
        NewLeadListinsert1.Billing_Zip__c='343434';
        NewLeadListinsert1.Billing_State__c='Karnataka';
        NewLeadListinsert1.Source__c='UAT';
        NewLeadListinsert1.Phone='349876254245';
        NewLeadListinsert1.Email='test@gamil.com';
        NewLeadListinsert1.Sales_Org__c = 'LRA';
        NewLeadList1.add(NewLeadListinsert1);
        insert NewLeadList1;    
    LeadCreateSendMail.NewLeadCreation(NewLeadList1);
          
  }
 
}