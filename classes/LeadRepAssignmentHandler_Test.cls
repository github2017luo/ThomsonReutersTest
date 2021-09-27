@isTest(SeeAllData= True)
public class LeadRepAssignmentHandler_Test{
  
    
private static testmethod void leadRepAssigmentProcess(){
    
    List<Lead> listlead = new List<Lead>();
    List<AccountTeamMember> listATM = new List<AccountTeamMember>();
    LeadRepAssignmentHandler handler = new LeadRepAssignmentHandler ();
    
    /*ILMGeneral__c ilmGen=new ILMGeneral__c();
    ilmGen.name= 'AllowedUsersForSalesRepAssignment';
    ilmGen.Value__C = 'SL Eloqua';        
    insert ilmGen;*/
    
    Profile p = [SELECT Id FROM profile WHERE name='System Administrator'];   
    User u1 = new User(alias = 'newUser', email='user@mydomain.com', 
        emailencodingkey='UTF-8', lastname='Eloqua',FirstName='SL', languagelocalekey='en_US', 
        localesidkey='en_US', profileid = p.Id, Rep_Employee_Number__c='0130083',
        timezonesidkey='America/Los_Angeles', username='user@mydomain.com.'+Math.random(),Rep_Type_Description__c='test');        
    insert u1;
    
    /*List<QueueSobject> listQueue;
    List<LLM_Queue_Assignment__c> listQueueAssignment;
    List<LLM_Sales_Rep_Assignment__c > salesRepAssignment;
    List<User> userList;*/
    
   /* User thisUser1 = [SELECT Id,EmployeeNumber FROM User WHERE Id = :UserInfo.getUserId()];
    
    System.runAs(thisUser1){
    Group testGroup = new Group(Name='test group', type='Queue');
    insert testGroup;

    QueuesObject testQueue = new QueueSObject(QueueID = testGroup.id, SobjectType = 'Lead');
    insert testQueue;
    }*/
    
    /*User thisUser1 = [SELECT Id,EmployeeNumber FROM User WHERE FirstName = 'SL' AND LastName= 'Eloqua'];
    
    System.runAs(thisUser1){
    
    }*/
    Account TestAcc = UnitTest.getAccountInstance();
    TestAcc.Is_Gli__c = false;
    insert TestAcc;
    
    Account TestAcc1 = UnitTest.getAccountInstance();
	TestAcc1.Is_Gli__c = false;
    insert TestAcc1;
    
    /*User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];

    System.runAs (thisUser){
        
        Profile p = [SELECT Id FROM profile WHERE name='System Administrator'];   
      User u1 = new User(alias = 'newUser', email='user@mydomain.com', 
            emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
            localesidkey='en_US', profileid = p.Id, employeenumber='0130083',
            timezonesidkey='America/Los_Angeles', username='user@mydomain.com',Rep_Type_Description__c='test');        
       insert u1;
       
    AccountTeamMember testAccTeamMember = new AccountTeamMember(AccountId=TestAcc.Id,UserId=u1.Id,TeamMemberRole='Account Manager');
    listATM.add(testAccTeamMember);
    
    
    AccountTeamMember testAccTeamMember1 = new AccountTeamMember(AccountId=TestAcc1.Id,UserId=u1.Id,TeamMemberRole='Sales Rep');
    listATM.add(testAccTeamMember1);
    
    insert listATM;
    
    }*/
    

       
    AccountTeamMember testAccTeamMember = new AccountTeamMember(AccountId=TestAcc.Id,UserId=u1.Id,TeamMemberRole='Account Manager');
    listATM.add(testAccTeamMember);
    
    
    AccountTeamMember testAccTeamMember1 = new AccountTeamMember(AccountId=TestAcc1.Id,UserId=u1.Id,TeamMemberRole='Sales Rep');
    listATM.add(testAccTeamMember1);
    
    insert listATM;
    
    
    List<LLM_Sales_Rep_Assignment__c > salesRepAssignment1 = new List<LLM_Sales_Rep_Assignment__c >();
        
    LLM_Sales_Rep_Assignment__c salesRep1 = new LLM_Sales_Rep_Assignment__c();
    salesRep1.Rep_Type__c='D4';
    salesRep1.Zipcode__c='33882-1234';
    salesRep1.Rep_Employee_Number__c='0130083';
    salesRep1.Sales_Rep_Name__c='Satyajit';
    salesRepAssignment1.add(salesRep1);
    
    LLM_Sales_Rep_Assignment__c salesRep2 = new LLM_Sales_Rep_Assignment__c();
    salesRep2 .Rep_Type__c='D4';
    salesRep2 .Zipcode__c='33882-1234';
    salesRep2 .Rep_Employee_Number__c='0130083';
    salesRep2.Sales_Rep_Name__c='Satyajit1';
    salesRep2.Account__c=TestAcc1.Id;
    salesRepAssignment1.add(salesRep2 );
    
    LLM_Sales_Rep_Assignment__c salesRep3 = new LLM_Sales_Rep_Assignment__c();
    salesRep3.Rep_Type__c='D5';
    salesRep3.Zipcode__c='33882-1235';
    salesRep3.Sales_Rep_Name__c='Satyajit3';
    salesRepAssignment1.add(salesRep3);
    //insert salesRep1;
 
    insert salesRepAssignment1;
    
    List<LLM_Queue_Assignment__c> listQueueAssignment1 = new List<LLM_Queue_Assignment__c> ();

    LLM_Queue_Assignment__c queueAssign1 = new LLM_Queue_Assignment__c();
    queueAssign1.Channel__c='Find Law';
    queueAssign1.Queue__c='Find Law Queue';
    listQueueAssignment1.add(queueAssign1);
    
    LLM_Queue_Assignment__c queueAssign2 = new LLM_Queue_Assignment__c();
    queueAssign2.Channel__c='Corporate';
    queueAssign2.Queue__c='Corporate Queue';
    listQueueAssignment1.add(queueAssign2);
    
    LLM_Queue_Assignment__c queueAssign3 = new LLM_Queue_Assignment__c();
    queueAssign3.Channel__c='default';
    queueAssign3.Queue__c='LM Lead Queue';
    listQueueAssignment1.add(queueAssign3);
    
    insert listQueueAssignment1;
        
    //Team Role and Account present.
    Lead TestLead = UnitTest.getLeadInstance();
    TestLead.Team_Role__c='Account Manager';
    //TestLead.Account__c=TestAcc.Id;
    listlead.add(TestLead);
    //Team Role and Account present.  
    Lead TestLead1 = UnitTest.getLeadInstance();
    TestLead1.Team_Role__c='Sales Rep';
    //TestLead1.Account__c=TestAcc1.Id;
    listlead.add(TestLead1);
    //Team Role and Account present.
    Lead TestLead16 = UnitTest.getLeadInstance();
    TestLead16.Team_Role__c='Sales Executive';
    //TestLead16.Account__c=TestAcc1.Id;
    listlead.add(TestLead16);
    
    //zip code,rep type and channel present.
    Lead TestLead2 = UnitTest.getLeadInstance();
    TestLead2.Billing_Zip__c='33882-1235';
    TestLead2.Rep_Type__c='D5';
    TestLead2.Business_Org__c='Find Law';
    listlead.add(TestLead2);
        
    //zip code,rep type present and channel not present.
    Lead TestLead3 = UnitTest.getLeadInstance();
    TestLead3.Billing_Zip__c='33882-1234';
    TestLead3.Rep_Type__c='D4';
    listlead.add(TestLead3);
    
        
    //zip code and channel present,rep type not present.
    Lead TestLead4 = UnitTest.getLeadInstance();
    TestLead4.Billing_Zip__c='33882-1235';
    TestLead4.Business_Org__c='Find Law';
    listlead.add(TestLead4);
    
    //zip code present ,rep type and channel not present.
    Lead TestLead5 = UnitTest.getLeadInstance();
    TestLead5.Billing_Zip__c='33882-1235';
    listlead.add(TestLead5);
    
    //zip code not present and channel present.
    Lead TestLead6 = UnitTest.getLeadInstance();
    TestLead6.Business_Org__c='Find Law';
    listlead.add(TestLead6);
    
    //Team role, zip code,rep type and channel present.
    Lead TestLead7 = UnitTest.getLeadInstance();
    TestLead7.Team_Role__c='Sales Rep';
    TestLead7.Billing_Zip__c='33882-1235';
    TestLead7.Rep_Type__c='D5';
    TestLead7.Business_Org__c='Find Law';
    listlead.add(TestLead7);
    
    //Team Role, zip code,rep type present and channel not present.
    Lead TestLead8 = UnitTest.getLeadInstance();    
    TestLead8.Team_Role__c='Sales Rep';
    TestLead8.Billing_Zip__c='33882-1234';
    TestLead8.Rep_Type__c='D4';
    listlead.add(TestLead8);
    
    //Team Role, zip code and channel present,rep type not present.
    Lead TestLead9 = UnitTest.getLeadInstance();
    TestLead9.Team_Role__c='Sales Rep';
    TestLead9.Billing_Zip__c='33882-1235';
    TestLead9.Business_Org__c='Find Law';
    listlead.add(TestLead9);
    
    //Team Role, zip code present ,rep type and channel not present.
    Lead TestLead10 = UnitTest.getLeadInstance();
    TestLead10.Team_Role__c='Sales Rep';
     TestLead10.Billing_Zip__c='33882-1235';
    listlead.add(TestLead10);
    //Team Role present, zip code not present and channel present.
    Lead TestLead11 = UnitTest.getLeadInstance();
    TestLead11.Team_Role__c='Sales Rep';
    TestLead11.Business_Org__c='Find Law';
    listlead.add(TestLead11);
  
    Lead TestLead12 = UnitTest.getLeadInstance();
    TestLead12.Billing_Zip__c='33882-1235';
    TestLead12.Rep_Type__c='D5';
    //TestLead12.Business_Org__c='Find Law';
    TestLead12.OwnerId=u1.Id;
    listlead.add(TestLead12);
    
    Lead TestLead13 = UnitTest.getLeadInstance();
    TestLead13.Billing_Zip__c='33882-1235';
    TestLead13.Rep_Type__c='D5';
    TestLead13.Business_Org__c='Find Law';
    TestLead13.OwnerId=u1.Id;
    listlead.add(TestLead13);
    
    system.runAs(u1){
     
        insert listlead;
    
    }
    
    List<Lead> nonTeamRoleLead = new List<Lead>();
    
    Lead TestLead14 = UnitTest.getLeadInstance();
    TestLead14.Billing_Zip__c='33882-1239';
    TestLead14.Rep_Type__c='RepType1';
    nonTeamRoleLead.add(TestLead14);
    
    Lead TestLead15 = UnitTest.getLeadInstance();
    TestLead15.Billing_Zip__c='33882-1238';
    TestLead15.Rep_Type__c='RepType1';
    nonTeamRoleLead.add(TestLead15);
    
    system.runAs(u1){
     
        insert nonTeamRoleLead;
    
    }
    
    
    

    
        
    
    //handler.channelQueue(TestLead13);
    //handler.assignDefaultQueue(TestLead13); 
}


}