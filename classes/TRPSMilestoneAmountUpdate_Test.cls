/**
 * ====================================================================================================================
 * TEST CLASS NAME: TRPSMilestoneAmountUpdate_Test
 * FLOW NAME      : TR_PS_Milestone_Amount_update_Flow
 * ======================================================================================================================
 * CHANGE HISTORY
 * ===================================================================================================================
 * Date         Name                    Description
 * 15-06-2021   Reshma Ramakrishnan            Created as part of JIRA story DPS-20529
 
 * ===================================================================================================================
 */

 /**
     * TRPSMilestoneAmountUpdate_Test
     * @description TRPSMilestoneAmountUpdate_Test class
 */

@isTest
public class TRPSMilestoneAmountUpdate_Test {
        
        @isTest
        private static void testCase(){
        Profile p = [SELECT Id FROM profile WHERE name='System Administrator'];   
        UserRole psRole = [SELECT Id FROM UserRole WHERE DeveloperName = 'Legal' limit 1];
        User u1;
        System.runAs ( new User(Id = UserInfo.getUserId()) ) {
            u1 = new User(alias = 'User1', email='user1@tr.com', 
                           emailencodingkey='UTF-8', lastname='Testing12', languagelocalekey='en_US', 
                           localesidkey='en_US', profileid = p.Id, employeenumber='0144020',
                           Sales_Org__c = 'GLI', timezonesidkey='America/Los_Angeles', username='usertest123@tr.com',UserRoleId = psRole.Id);        
        insert u1;
        }
        Account acc = new Account(
            Name = 'Unit Test',
            BillingStreet = '123 Unit Test Street',
            BillingCity='Dallas',
            BillingState = 'TX',
            BillingPostalCode = '75006',
            BillingCountry='US'
        );
        insert acc;
        
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
              Name = 'test project', 
              //CurrencyIsoCode = 'U.S. Dollar',
              pse__Start_Date__c = system.today(),                            
              pse__End_Date__c = system.today().addDays(30),                       
              pse__Account__c = acc.id,                                          
              pse__Billing_Type__c = 'Fixed Price',             
              pse__Is_Active__c = true,      
              pse__Is_Billable__c = true, 
              pse__Allow_Timecards_Without_Assignment__c = false
            );
        insert proj;
    
        pse__Budget__c budget = new pse__Budget__c(
            Name = 'My Budget',
            pse__Project__c = proj.id,
            pse__Status__c = 'Approved',
            pse__Type__c ='Customer Purchase Order',
            pse__Amount__c = 100000,
            pse__Effective_Date__c = system.today()         
        );
        insert budget;
    	system.assertEquals('My Budget', budget.Name,'PMD FIX');
        pse__Milestone__c mile1= new pse__Milestone__c(
            Name = 'Milestone1',
            Percent_To_Bill__c = 10,
            pse__Project__c = proj.id,
            pse__Target_Date__c = system.today().addDays(5)
        );
        insert mile1;
    
        pse__Milestone__c mile2= new pse__Milestone__c(
            Name = 'Milestone2',
            Percent_To_Bill__c = 20,
            pse__Project__c = proj.id,
            pse__Target_Date__c = system.today().addDays(5)
        );
        insert mile2;
    
        pse__Milestone__c mile3= new pse__Milestone__c(
            Name = 'Milestone3',
            Percent_To_Bill__c = 10,
            pse__Project__c = proj.id,
            pse__Target_Date__c = system.today().addDays(5)
        );
        insert mile3;
            
            
        test.startTest();
          Map<String, Object> params = new Map<String, Object>();
            params.put('varProjId', proj.id);
                 
            Flow.Interview.TR_PS_Milestone_Amount_update_Flow callMilestoneFLow= new Flow.Interview.TR_PS_Milestone_Amount_update_Flow(params);
            callMilestoneFLow.start();
            
        
        test.stopTest();

       
        }
    
    @isTest private static void testcase2(){
        
        Profile p = [SELECT Id FROM profile WHERE name='System Administrator'];   
        UserRole psRole = [SELECT Id FROM UserRole WHERE DeveloperName = 'Legal' limit 1];
        User u1;
        System.runAs ( new User(Id = UserInfo.getUserId()) ) {
            u1 = new User(alias = 'User1', email='user1@tr.com', 
                           emailencodingkey='UTF-8', lastname='Testing12', languagelocalekey='en_US', 
                           localesidkey='en_US', profileid = p.Id, employeenumber='0144020',
                           Sales_Org__c = 'GLI', timezonesidkey='America/Los_Angeles', username='usertest123@tr.com',UserRoleId = psRole.Id);        
        insert u1;
        }
        Account acc = new Account(
            Name = 'Unit Test',
            BillingStreet = '123 Unit Test Street',
            BillingCity='Dallas',
            BillingState = 'TX',
            BillingPostalCode = '75006',
            BillingCountry='US'
        );
        insert acc;
        
        Contact con = new Contact(
          pse__Allow_Timecards_Without_Assignment__c = true,
          pse__Is_Resource__c = true, 
          pse__Is_Resource_Active__c = true,
          FirstName = 'Generic',
          LastName  = 'PS EXECUTIVE LEADER',
          pse__Salesforce_User__c = u1.id
          
        );
        
        insert con;
        pse__Proj__c proj1 = new pse__Proj__c(
              Name = 'test project', 
              //CurrencyIsoCode = 'U.S. Dollar',
              pse__Start_Date__c = system.today(),                            
              pse__End_Date__c = system.today().addDays(30),                       
              pse__Account__c = acc.id,                                          
              pse__Billing_Type__c = 'Fixed Price',             
              pse__Is_Active__c = true,      
              pse__Is_Billable__c = true, 
              pse__Allow_Timecards_Without_Assignment__c = false
            );
        insert proj1;
        System.assertEquals('test project',proj1.Name,'PMD FIX');
            pse__Budget__c budget1 = new pse__Budget__c(
            Name = 'My new Budget',
            pse__Project__c = proj1.id,
            pse__Status__c = 'Approved',
            pse__Type__c ='Customer Purchase Order',
            pse__Amount__c = 100000,
            pse__Effective_Date__c = system.today()         
        );
        insert budget1;
        pse__Budget_Header__c budgetHeader = new pse__Budget_Header__c(
            Name = 'SFDC development',                       // Budget Header Name
               pse__Project__c = proj1.Id,               // Project
              pse__Active__c = true,                             // Active
              pse__Account__c = acc.id,               // Account
              pse__Type__c = 'Customer Purchase Order',          // Type
              pse__Amount__c = 10000,                             // Amount
              pse__Amount_Overrun_Allowed__c = false
        );
        insert budgetHeader;
        pse__Project_Task__c pt1 = new pse__Project_Task__c(
        Name = 'P1',                                                                                                                                                   // Project Task Name
        pse__Project__c = proj1.Id,                                                                                                                             // Project
        pse__Status__c = 'Draft'
        );
        
        insert pt1;
    
        pse__Milestone__c mile= new pse__Milestone__c(
            Name = 'New Milestone',
            Percent_To_Bill__c = 110,
            pse__Project__c = proj1.id,
            pse__Target_Date__c = system.today().addDays(5)
        );
        insert mile;
        test.startTest();
            Map<String, Object> params1 = new Map<String, Object>();
            params1.put('varProjId', proj1.id);
                 
            Flow.Interview.TR_PS_Milestone_Amount_update_Flow callMilestoneFLow1= new Flow.Interview.TR_PS_Milestone_Amount_update_Flow(params1);
            callMilestoneFLow1.start();
        test.stopTest();
      
    }
}