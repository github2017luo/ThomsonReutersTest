/**
 * ====================================================================================================================
 * TEST CLASS NAME: TRPSMilestoneTargetDateUpdate_Test
 * FLOW NAME      : Update Target Date Field on Milestone
 * ======================================================================================================================
 */

 /**
     * TRPSMilestoneTargetDateUpdate_Test
     * @description TRPSMilestoneTargetDateUpdate_Test class
 */
@isTest
public class TRPSMilestoneTargetDateUpdate_Test {
    @isTest
    private static void testCase(){
        Profile p = [SELECT Id FROM profile WHERE name='System Administrator'];   
        UserRole psRole = [SELECT Id FROM UserRole WHERE DeveloperName = 'Legal' limit 1];
        User u1;
        System.runAs ( new User(Id = UserInfo.getUserId()) ) {
            u1 = new User(alias = 'newUser1', email='user12@mydomain12.com', 
                           emailencodingkey='UTF-8', lastname='Testing12', languagelocalekey='en_US', 
                           localesidkey='en_US', profileid = p.Id, employeenumber='0144020',
                           Sales_Org__c = 'GLI', timezonesidkey='America/Los_Angeles', username='usertest123@mydomain.com.prod',UserRoleId = psRole.Id);        
        insert u1;
        }
        Account oAccount = new Account();
        oAccount.Name = 'Unit Test';
        oAccount.BillingStreet = '123 Unit Test Street';
        oAccount.BillingCity='Dallas';
        oAccount.BillingState = 'TX';
        oAccount.BillingPostalCode = '75006';
        oAccount.BillingCountry='US';
        insert oAccount;
        
        Contact con = new Contact(
          pse__Allow_Timecards_Without_Assignment__c = true,
          pse__Is_Resource__c = true, 
          pse__Is_Resource_Active__c = true,
          FirstName = 'Generic',
          LastName  = 'PS EXECUTIVE LEADER',
          pse__Salesforce_User__c = u1.id
          
      );
        insert con;
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
        
        pse__Milestone__c objMilestone = new pse__Milestone__c(
          Name = 'SFDC development',
          pse__Project__c = proj.Id,
          pse__Target_Date__c = System.today(),
          pse__Actual_Date__c = System.today().addDays(15),
          pse__Milestone_Amount__c = 2000,
          pse__Approved__c = false,
          pse__Include_In_Financials__c = false,
          pse__Status__c = 'Open'
          );
        insert objMilestone;
        
        pse__Project_Task__c pt = new pse__Project_Task__c(
        Name = 'Design element',   
        pse__Project__c = proj.id,
        pse__Status__c = 'Draft',
        pse__Priority__c = 'P2', 
        pse__Actual_End_Date_Time__c = System.today().addDays(10), 
        pse__End_Date_Time__c = System.today().addDays(10),
        pse__Estimated_Hours__c = 24,
        pse__Milestone__c = objMilestone.Id                                                                                                                  
         );
        insert pt;
        
        test.startTest();
        pt.pse__End_Date_Time__c= System.today().addDays(20);
        update pt;
        test.stopTest();
        
        pse__Milestone__c objMilestoneUpdated = [select id, name, pse__Target_Date__c  from pse__Milestone__c WHERE id =:objMilestone.id  LIMIT 1];
        
        System.debug(LoggingLevel.DEBUG,'@@@Project task End date'+pt.pse__End_Date_Time__c);
        System.debug(LoggingLevel.DEBUG,'@@@Milestone Target Date'+objMilestoneUpdated.pse__Target_Date__c);
        System.assertEquals(pt.pse__End_Date_Time__c, objMilestoneUpdated.pse__Target_Date__c, 'TargetDate Updated');
    }
    

}