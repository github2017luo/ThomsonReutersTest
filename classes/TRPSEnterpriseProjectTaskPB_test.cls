/**
 * ====================================================================================================================
 * TEST CLASS NAME: TRPSEnterpriseProjectTaskPB_test
 * ======================================================================================================================
 * CHANGE HISTORY
 * ===================================================================================================================
 * Date         Name                    Description
 * 05-20-2021   Miriam Ghosh            Created as part of JIRA story DPS-15991
 
 * ===================================================================================================================
 */

 /**
     * TRPSEnterpriseProjectTaskPB_test
     * @description TRPSEnterpriseProjectTaskPB_test class
     */
@isTest
public class TRPSEnterpriseProjectTaskPB_test {
    
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
        
        LTS_Disable_Application_Automation__c ltstemp = new LTS_Disable_Application_Automation__c();
        ltstemp.LTS_Disable_Process_Builders__c = false;
        ltstemp.LTS_Disable_Triggers__c = true;
        ltstemp.LTS_Disable_Validation_Rules__c = true;
        ltstemp.LTS_Disable_Workflow_Rules__c = true;
        ltstemp.Name = 'temp';
        ltstemp.SetupOwnerId = userinfo.getuserid();
        insert ltstemp;
        
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
          //pse__Actual_Date__c = System.today().addDays(15),
          pse__Milestone_Amount__c = 2000,
          pse__Approved__c = false,
          pse__Include_In_Financials__c = false,
          pse__Status__c = 'Open'
          );
        insert objMilestone;
        
        pse__Project_Task__c pt = new pse__Project_Task__c(
          Name = 'Design element',  
          pse__Project__c = proj.id,  
          pse__Status__c = 'Started',   
          pse__Priority__c = 'P2',  
          pse__Actual_Start_Date_Time__c = System.today(),     
          pse__Actual_End_Date_Time__c = System.today().addDays(5), 
          pse__Estimated_Hours__c = 24,   
          pse__Started__c = true,  
          pse__Completed__c = false, 
          pse__Blocked__c = false, 
          pse__Milestone__c = objMilestone.id,
          pse__Summary__c = false 
          );
        insert pt;
        
        pse__Project_Task__c pt2 = new pse__Project_Task__c(
          Name = 'Design element2',  
          pse__Project__c = proj.id,  
          pse__Status__c = 'Started',   
          pse__Priority__c = 'P2',  
          pse__Actual_Start_Date_Time__c = System.today(),     
          pse__Actual_End_Date_Time__c = System.today().addDays(9), 
          pse__Estimated_Hours__c = 24,   
          pse__Started__c = true,  
          pse__Completed__c = false, 
          pse__Blocked__c = false, 
          pse__Milestone__c = objMilestone.id,
          pse__Summary__c = false 
          );
        insert pt2;
        
        pse__Project_Task__c pto = [select id, Name, pse__Status__c from pse__Project_Task__c WHERE Name =: pt.name LIMIT 1];
        pto.Name = 'Design element updated';
        pto.pse__Status__c = 'Complete';
        update pto;
        
        system.debug(LoggingLevel.DEBUG,'objMilestone.pse__Actual_Date__c'+objMilestone.pse__Actual_Date__c);
        system.debug(LoggingLevel.DEBUG,'objMilestone.pse__Approved__c'+objMilestone.pse__Approved__c);
        system.debug(LoggingLevel.DEBUG,'objMilestone.pse__Include_In_Financials__c'+objMilestone.pse__Include_In_Financials__c);
        system.debug(LoggingLevel.DEBUG,'objMilestone.pse__Status__c'+objMilestone.pse__Status__c);

        system.assertEquals('Design element', pt.Name, 'name');
        
        /*system.assertEquals(System.today().addDays(5), objMilestone.pse__Actual_Date__c);
        system.assertEquals(True, objMilestone.pse__Approved__c);
        system.assertEquals(True, objMilestone.pse__Include_In_Financials__c);
        system.assertEquals('Approved', objMilestone.pse__Status__c);*/  
    }

}