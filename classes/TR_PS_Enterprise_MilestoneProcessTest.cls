/**
 * ====================================================================================================================
 * TEST CLASS NAME: TR_PS_Enterprise_MilestoneProcessTest
 * ======================================================================================================================
 * @description PURPOSE:   Validate the functionality in Milestone Process Builder

 * CHANGE HISTORY
 * ===================================================================================================================
 * Date         Name                    Description
 * 04-14-2021  Debashis Dash             Created as part of JIRA story DPS-15891
 
 * ===================================================================================================================
 */
@isTest
public class TR_PS_Enterprise_MilestoneProcessTest {
   //Setting up Test data
   @isTest
    public static void testCase(){
        //Date d = System.Today();
       //Date newDate = d.addDays(12);
    Profile p = [SELECT Id FROM profile WHERE name='System Administrator'];   
        UserRole psRole = [SELECT Id FROM UserRole WHERE DeveloperName = 'Legal' limit 1];// Updated this method to fix test class error for CRM-1324
        User u1;
        System.runAs ( new User(Id = UserInfo.getUserId()) ) {
            u1 = new User(alias = 'newUser1', email='user12@mydomain12.com', 
                           emailencodingkey='UTF-8', lastname='Testing12', languagelocalekey='en_US', 
                           localesidkey='en_US', profileid = p.Id, employeenumber='0144020',
                           Sales_Org__c = 'GLI', timezonesidkey='America/Los_Angeles', username='usertest123@mydomain.com.prod',UserRoleId = psRole.Id);        
        insert u1;
        }
        System.runAs(u1){
        Account oAccount = new Account();
        oAccount.Name = 'Unit Test';
        oAccount.BillingStreet = '123 Unit Test Street';
        oAccount.BillingCity='Dallas';
        oAccount.BillingState = 'TX';
        oAccount.BillingPostalCode = '75006';
        oAccount.BillingCountry='US';
        insert oAccount;
            
        Contact con = new Contact(
          pse__Allow_Timecards_Without_Assignment__c = true,  // Allow Timecards Without Assignment
          pse__Is_Resource__c = true,                         // Is Resource
          pse__Is_Resource_Active__c = true,
          FirstName = 'Generic',
          LastName  = 'PS EXECUTIVE LEADER',
          pse__Salesforce_User__c = u1.id
          
      );
        insert con;
        pse__Permission_Control__c pControl = new pse__Permission_Control__c(
          pse__User__c = u1.id, 
          pse__Resource__c = con.id,                
          //pse__Cascading_Permission__c = true,             
          pse__Start_Date__c = System.Today(),  
          pse__Resource_Request_Entry__c = true,           
          pse__Timecard_Entry__c = true,
          pse__Staffing__c = true,
          pse__Timecard_Ops_Edit__c = true,
          pse__Expense_Entry__c = true
          );  
          insert pControl ;
          pse__Proj__c proj = new pse__Proj__c(
              Name = 'test ps qa project',                                                
              pse__Start_Date__c = system.today(),                            
              pse__End_Date__c = system.today().addDays(30),                       
              pse__Account__c = oAccount.id,                                          
              pse__Billing_Type__c = 'Fixed Price',             
              pse__Is_Active__c = true,      
              pse__Is_Billable__c = true, 
              pse__Allow_Timecards_Without_Assignment__c = false
            );
        insert proj;
        
         pse__Permission_Control__c pControl2 = new pse__Permission_Control__c(
          pse__User__c = u1.id, 
          pse__Project__c = proj.id ,              
          //pse__Cascading_Permission__c = true,             
          pse__Start_Date__c = System.Today(),  
          pse__Resource_Request_Entry__c = true,           
          pse__Timecard_Entry__c = true,
          pse__Staffing__c = true,
          pse__Timecard_Ops_Edit__c = true,
          pse__Expense_Entry__c = true
          );  
          insert pControl2 ;
          pse__Milestone__c objMilestone = new pse__Milestone__c(
          Name = 'SFDC development',
          pse__Project__c = proj.Id,
          pse__Target_Date__c = System.today(),
          pse__Actual_Date__c = System.today().addDays(15),
          pse__Milestone_Amount__c = 2000,
          pse__Status__c = 'Approved'
          );
         
            test.startTest();
            insert objMilestone;  
            test.stopTest();
            pse__Milestone__c milestoneAfterInsert = [SELECT id,pse__Approved__c,pse__Include_In_Financials__c
                                                                           FROM pse__Milestone__c WHERE id=:objMilestone.id];
            System.assertEquals(TRUE, milestoneAfterInsert.pse__Approved__c,'Something went wrong');
            System.assertEquals(TRUE, milestoneAfterInsert.pse__Include_In_Financials__c,'Something went wrong');
        }
    }
    

}