/**
 * ====================================================================================================================
 * TEST CLASS NAME: TRPSProjectTaskEndDateAlertFlow_test
 * FLOW NAME      : TR_PS_Project_task_dependency_status_update_flow
 * ======================================================================================================================
 * CHANGE HISTORY
 * ===================================================================================================================
 * Date         Name                    Description
 * 08-06-2021   Miriam Ghosh            Created as part of JIRA story DPS-15991
 
 * ===================================================================================================================
 */

 /**
     * TRPSProjectTaskStatusUpdateFlow_Test
     * @description TRPSProjectTaskStatusUpdateFlow_Test class
 */

@isTest
public class TRPSProjectTaskStatusUpdateFlow_Test {

    @isTest
    private static void testCase(){
        Profile p = [SELECT Id FROM profile WHERE name='System Administrator'];   
        UserRole psRole = [SELECT Id FROM UserRole WHERE DeveloperName = 'Legal' limit 1];
        User u1;
        System.runAs ( new User(Id = UserInfo.getUserId()) ) {
            u1 = new User(alias = 'User1', email='user1@tr.com', 
                           emailencodingkey='UTF-8', lastname='Testing12', languagelocalekey='en_US', 
                           localesidkey='en_US', profileid = p.Id, employeenumber='0144020',
                           Sales_Org__c = 'GLI', timezonesidkey='America/Los_Angeles', username='usertest123@tr.com.prod',UserRoleId = psRole.Id);        
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
        System.debug(LoggingLevel.DEBUG,'@@@Project Name proj'+proj.Name);
        
        pse__Project_Task__c pt1 = new pse__Project_Task__c(
        Name = 'New task1',   
        pse__Project__c = proj.id,
        pse__Status__c = 'Started',
        pse__Priority__c = 'P2', 
        pse__Completed__c = false                                                                                                                  
        );
        insert pt1;
        System.debug(LoggingLevel.DEBUG,'@@@Project status Taks1'+pt1.pse__Status__c ); 
        
        pse__Project_Task__c pt2 = new pse__Project_Task__c(
        Name = 'Dependent New task1',   
        pse__Project__c = proj.id,
        pse__Status__c = 'Draft',
        pse__Priority__c = 'P2'                                                                                                                   
        );
        insert pt2;
        
        pse__Project_Task_Dependency__c ptd = new pse__Project_Task_Dependency__c(
        pse__Preceding_Task__c = pt1.id,
        pse__Dependent_Task__c = pt2.id,
        pse__Type__c ='Start to Finish'
        );
         insert ptd;
        pse__Project_Task_Assignment__c pta = new pse__Project_Task_Assignment__c(
          pse__Resource__c = con.id,           
          pse__Project_Task__c = pt1.id,         
          pse__Resource_Role__c = 'Architect',          
          pse__Allocation_Percentage__c = 50,        
          TR_PS_Task_Travel_Required__c = 'No'       
        );
        insert pta;
        system.assertEquals('Architect', pta.pse__Resource_Role__c, 'Role');
        //system.assertEquals(pt1.pse__Status__c,pt2.pse__Status__c,'Complete');
        test.startTest();
        pt1.pse__Status__c = 'Complete';
        UPDATE pt1;
        test.stopTest();
        // Asserting the result after project task update
        pse__Project_Task__c objProjTaskAfterUpdate = [select id,pse__Status__c from pse__Project_Task__c where id=: pt2.Id ];
        
        System.assertEquals('Planned', objProjTaskAfterUpdate.pse__Status__c,'Status');
        
        }

}