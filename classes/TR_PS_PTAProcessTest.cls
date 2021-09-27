@isTest
private class TR_PS_PTAProcessTest {
    @isTest
    private static void testCase(){
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
        pse__Project_Task__c pt = new pse__Project_Task__c(
      Name = 'Design element',                                                                                                                                       // Project Task Name
      pse__Project__c = proj.id,                                                                                                                             // Project
      pse__Status__c = 'Draft',                                                                                                                                        // Status
      pse__Priority__c = 'P2',                                                                                                                                         // Priority
      pse__Actual_Start_Date_Time__c = System.today(),                                                                                      // Actual Start Date & Time
      pse__Actual_End_Date_Time__c = System.today().addDays(5),                                                                                        // Actual End Date & Time
      pse__Estimated_Hours__c = 24,                                                                                                                               // Estimated Hours
      pse__Started__c = false,                                                                                                                                         // Started
      pse__Completed__c = false,                                                                                                                                       // Completed                                                                                                                                 // Actual Hours
      pse__Blocked__c = false,                                                                                                                                         // Blocked
      pse__Summary__c = false                                                                                                                                        // Summary
                                                                                                                  
    );
        insert pt;
        pse__Project_Task_Assignment__c pta = new pse__Project_Task_Assignment__c(
          pse__Resource__c = con.id,           
          pse__Project_Task__c = pt.id,         
          pse__Resource_Role__c = 'Architect',          
          pse__Allocation_Percentage__c = 50,        
          TR_PS_Task_Travel_Required__c = 'No'       
        );
        
       
        test.startTest();
       
        insert pta;
        /* Testing the fault connecter in flow for code covergae by giving invalid ID*/
        Map<String, Object> params = new Map<String, Object>();
        params.put('ptaId', 'ff8Y');// Giving Invalid ID 
        Flow.Interview.TR_PS_Enterprise_PTA_Alert_Flow ptaAlertFlow = new Flow.Interview.TR_PS_Enterprise_PTA_Alert_Flow(params);
        ptaAlertFlow.start();
        test.stopTest();
         
        TR_Retention__Error_Log__c errorLog = [select Id,TR_Retention__Error_Point__c from TR_Retention__Error_Log__c limit 1 ];
        FeedItem chatterPost = [select Id, ParentId from FeedItem];
        
        System.assertEquals('PTA Alert Error', errorLog.TR_Retention__Error_Point__c);
        System.assertEquals(u1.id, chatterPost.ParentId);
    }

}