/**
@description HVS_CallDisposition_Test 
LCRM_HVS_Lead_Update process builder
HVS_Update_CallDisposition process builder
 *
 */
@isTest
public class HVS_CallDisposition_Test {
    
    @istest
    static void method1(){
        LTS_Disable_Application_Automation__c ltstemp = new LTS_Disable_Application_Automation__c();
        ltstemp.LTS_Disable_Process_Builders__c = false;
        ltstemp.LTS_Disable_Triggers__c = true;
        ltstemp.LTS_Disable_Validation_Rules__c = true;
        ltstemp.LTS_Disable_Workflow_Rules__c = true;
        ltstemp.Name = 'temp';
        ltstemp.SetupOwnerId = userinfo.getuserid();
        insert ltstemp;
        
        Lead lead = new Lead();
        lead.Company = 'Test 1 New Company';
        lead.FirstName = 'Martha2';
        lead.LastName = 'Belly2';       
        lead.LeadSource = 'Not Converted';
        lead.Is_GLI__c = true;
        insert lead;
     
        System.assertEquals(lead!= null , true,'Lead check');
        List<Task> tasks = new List<Task>();
        tasks.add(new Task(
            ActivityDate = Date.today().addDays(7),
            LCRM_Activity_Type__c='Call Outbound',
            Activity_category__c = 'Appointment Request',
            Call_Disposition__c = 'Connected' ,
            Subject='Sample Task',        
            whoId= lead.id,     
            OwnerId = UserInfo.getUserId(),
            Status='Completed'));
        insert tasks;
    }
    @istest
    static void method2(){
        LTS_Disable_Application_Automation__c ltstemp = new LTS_Disable_Application_Automation__c();
        ltstemp.LTS_Disable_Process_Builders__c = false;
        ltstemp.LTS_Disable_Triggers__c = true;
        ltstemp.LTS_Disable_Validation_Rules__c = true;
        ltstemp.LTS_Disable_Workflow_Rules__c = true;
        ltstemp.Name = 'temp';
        ltstemp.SetupOwnerId = userinfo.getuserid();
        insert ltstemp;
        
        Lead lead = new Lead();
        lead.Company = 'Test 1 New Company';
        lead.FirstName = 'Martha2';
        lead.LastName = 'Belly2';       
        lead.LeadSource = 'Not Converted';
        lead.Is_GLI__c = true;
        insert lead;
        System.assertEquals(lead!= null , true,'Lead check');
        List<Task> tasks = new List<Task>();
        tasks.add(new Task(
            ActivityDate = Date.today().addDays(7),
            LCRM_Activity_Type__c='Call Outbound',
            Activity_category__c = 'Appointment Request',
            Call_Disposition__c = 'Not Interested' ,
            Subject='Sample Task 2 ',        
            whoId= lead.id,     
            OwnerId = UserInfo.getUserId(),
            Status='Completed'));
        insert tasks;
    }
    @istest
    static void method3(){
        LTS_Disable_Application_Automation__c ltstemp = new LTS_Disable_Application_Automation__c();
        ltstemp.LTS_Disable_Process_Builders__c = true;
        ltstemp.LTS_Disable_Triggers__c = true;
        ltstemp.LTS_Disable_Validation_Rules__c = true;
        ltstemp.LTS_Disable_Workflow_Rules__c = true;
        ltstemp.Name = 'temp';
        ltstemp.SetupOwnerId = userinfo.getuserid();
        insert ltstemp;
        
        Lead lead = new Lead();
        lead.Company = 'Test 1 New Company';
        lead.FirstName = 'Martha2';
        lead.LastName = 'Belly2';       
        lead.LeadSource = 'Not Converted';
        lead.Is_GLI__c = true;
        insert lead;
        System.assertEquals(lead!= null , true,'Lead check');
        List<Task> tasks = new List<Task>();
        tasks.add(new Task(
            ActivityDate = Date.today().addDays(7),
            Activity_category__c = 'Appointment Requested',
            Call_Disposition__c = 'Connected' ,
            Subject='Sample Task',        
            whoId= lead.id,     
            OwnerId = UserInfo.getUserId(),
            Status='Completed'));
        insert tasks;
    }
    
}