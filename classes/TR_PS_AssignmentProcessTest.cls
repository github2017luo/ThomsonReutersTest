@isTest
private class TR_PS_AssignmentProcessTest {
    
    @isTest
    private static void testCase(){
        Date d = System.Today();
    Date newDate = d.addDays(12);
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
              pse__Project_Manager__c = con.id,
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
        pse__Schedule__c sch = new pse__Schedule__c();
            
              sch.pse__Start_Date__c = system.today();
              sch.pse__End_Date__c = System.today().addDays(25);
              sch.pse__Scheduled_Hours__c = 120.00;
              sch.pse__Scheduled_Days__c = 15.00;
              sch.pse__Monday_Hours__c = 8.00;
              sch.pse__Saturday_Hours__c = 0.00;
              sch.pse__Tuesday_Hours__c = 8.00;
              sch.pse__Sunday_Hours__c = 0.00;
              sch.pse__Wednesday_Hours__c = 8.00;
              sch.pse__Thursday_Hours__c = 8.00;                      
              sch.pse__Friday_Hours__c = 8.00;                   
           
           insert sch;
        
        pse__Assignment__c assign = new pse__Assignment__c(
            Name = 'test ps qa project - GENERIC PS EXECUTIVE LEADER',
            pse__Resource__c = con.Id,
            pse__Schedule_Updated__c = false,
            pse__Project__c = proj.id,
            pse__Projected_Revenue__c = 840.00,
            pse__Status__c = 'Tentative', 
            pse__Schedule__c = sch.Id,     
            pse__Percent_Allocated__c = 100,
            pse__Bill_Rate__c = 7.00,
            pse__Is_Billable__c = true
          );
            test.startTest();
             insert assign;
            /* Testing the fault connecter in flow for code covergae by giving invalid ID*/
            Map<String, Object> params = new Map<String, Object>();
            params.put('assignmentId', 'ff8Y');// Giving Invalid ID 
            Flow.Interview.TR_PS_Enterprise_Assignment_Alert_Flow assignAlertFlow = new Flow.Interview.TR_PS_Enterprise_Assignment_Alert_Flow(params);
            assignAlertFlow.start();
            test.stopTest();
            
            TR_Retention__Error_Log__c errorLog = [select Id,TR_Retention__Error_Point__c from TR_Retention__Error_Log__c limit 1 ];
            FeedItem chatterPost = [select Id, ParentId from FeedItem limit 1];
            System.assertEquals('Assignment Alert Error', errorLog.TR_Retention__Error_Point__c);
            System.assertEquals(u1.id, chatterPost.ParentId);
        
        }
        
    }

}