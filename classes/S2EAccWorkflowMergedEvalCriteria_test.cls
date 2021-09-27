/**
* Test Class for 'Active S2E Account Workflow Merged-Eval Criteria:created' Process Builder
*
*/

/**
* CHANGE HISTORY
* =============================================================================
* Date         Name                    Description
* 2020-08-19   Miriam Ghosh            Created     
* =============================================================================
*/

@isTest
public class S2EAccWorkflowMergedEvalCriteria_test {
    
    @isTest
    public static void S2EAccWorkflow_Method1(){
        
        LTS_Disable_Application_Automation__c ltstemp = new LTS_Disable_Application_Automation__c();
        ltstemp.LTS_Disable_Process_Builders__c = false;
        ltstemp.LTS_Disable_Triggers__c = true;
        ltstemp.LTS_Disable_Validation_Rules__c = true;
        ltstemp.LTS_Disable_Workflow_Rules__c = true;
        ltstemp.Name = 'temp';
        ltstemp.SetupOwnerId = userinfo.getuserid();
        insert ltstemp;
        
        Profile p = [SELECT Id FROM profile WHERE name='System Administrator' limit 1];   
          User u1 = new User(alias = 'newUser', email='user@mydomain.com',
            emailencodingkey='UTF-8', lastname='userLTR', languagelocalekey='en_US', 
            localesidkey='en_US', profileid = p.Id, employeenumber='0144020',
            timezonesidkey='America/Los_Angeles', username='userLTR@mydomain.com.'+Math.random(),Rep_Type_Description__c='test',
            Sales_Org__c = 'BKRS');        
            insert u1;
        
        Test.startTest();
        system.runas(u1){
            Account acc1 = UnitTest.getAccountInstance();
            acc1.Name = 'Test Account';
            acc1.Phone = '1234567890';
            acc1.BillingCountry = 'US';
            acc1.BillingState='IL';
            acc1.BillingPostalCode = '60603-3801';
            acc1.SAPAccountNumber__c = 'UTSAP001';
            acc1.Bu_Segment__c = 'Professional Legal';
            acc1.ECC_Top_Named_Law_Firms__c = 'DENTONS';
            acc1.Customer_Group__c = 'ACADEMIC';
            acc1.Industry = 'Not Applicable';
            acc1.Is_GLI__c = False;
            insert acc1;
            
            acc1.Industry = 'ED Academic Teacher';
            update acc1;
        }
        
        Test.stopTest();
    }
    
     @isTest
    public static void S2EAccWorkflow_Method2(){
        
        LTS_Disable_Application_Automation__c ltstemp = new LTS_Disable_Application_Automation__c();
        ltstemp.LTS_Disable_Process_Builders__c = false;
        ltstemp.LTS_Disable_Triggers__c = true;
        ltstemp.LTS_Disable_Validation_Rules__c = true;
        ltstemp.LTS_Disable_Workflow_Rules__c = true;
        ltstemp.Name = 'temp';
        ltstemp.SetupOwnerId = userinfo.getuserid();
        insert ltstemp;
        
        Profile p = [SELECT Id FROM profile WHERE name='System Administrator' limit 1];   
          User u2 = new User(alias = 'newUser', email='user@mydomain.com',
            emailencodingkey='UTF-8', lastname='userLTR', languagelocalekey='en_US', 
            localesidkey='en_US', profileid = p.Id, employeenumber='0144020',
            timezonesidkey='America/Los_Angeles', username='userLTR@mydomain.com.'+Math.random(),Rep_Type_Description__c='test',
            Sales_Org__c = 'BKRS');        
            insert u2;
        
        Test.startTest();
        system.runas(u2){
            Account acc2 = UnitTest.getAccountInstance();
            acc2.Name = 'Test Account';
            acc2.Phone = '1234567890';
            acc2.BillingCountry = 'US';
            acc2.BillingState='IL';
            acc2.BillingPostalCode = '60603-3801';
            acc2.SAPAccountNumber__c = 'UTSAP001';
            acc2.Bu_Segment__c = 'Professional Legal';
            acc2.ECC_Top_Named_Law_Firms__c = 'DENTONS';
            acc2.Customer_Group__c = 'BARRISTER';
            acc2.Industry = 'Not Applicable';
            acc2.Is_GLI__c = False;
            insert acc2;
            
            acc2.Industry = 'LE Barristers & QCs';
            update acc2;
        }
        
        Test.stopTest();
    }

    @isTest
    public static void S2EAccWorkflow_Method3(){
        
        LTS_Disable_Application_Automation__c ltstemp = new LTS_Disable_Application_Automation__c();
        ltstemp.LTS_Disable_Process_Builders__c = false;
        ltstemp.LTS_Disable_Triggers__c = true;
        ltstemp.LTS_Disable_Validation_Rules__c = true;
        ltstemp.LTS_Disable_Workflow_Rules__c = true;
        ltstemp.Name = 'temp';
        ltstemp.SetupOwnerId = userinfo.getuserid();
        insert ltstemp;
        
        Profile p = [SELECT Id FROM profile WHERE name='System Administrator' limit 1];   
          User u3 = new User(alias = 'newUser', email='user@mydomain.com',
            emailencodingkey='UTF-8', lastname='userLTR', languagelocalekey='en_US', 
            localesidkey='en_US', profileid = p.Id, employeenumber='0144020',
            timezonesidkey='America/Los_Angeles', username='userLTR@mydomain.com.'+Math.random(),Rep_Type_Description__c='test',
            Sales_Org__c = 'BKRS');    
            insert u3;
        
        Test.startTest();
        system.runas(u3){
            Account acc3 = UnitTest.getAccountInstance();
            acc3.Name = 'Test Account';
            acc3.Phone = '1234567890';
            acc3.BillingCountry = 'US';
            acc3.BillingState='IL';
            acc3.BillingPostalCode = '60603-3801';
            acc3.SAPAccountNumber__c = 'UTSAP001';
            acc3.Bu_Segment__c = 'Professional Legal';
            acc3.ECC_Top_Named_Law_Firms__c = 'DENTONS';
            acc3.Customer_Group__c = 'Corporation';
            acc3.Industry = 'Not Applicable';
            acc3.Is_GLI__c = False;
            insert acc3;
            
            acc3.Industry = 'BU Architects, Town';
            update acc3;
        }
        
        Test.stopTest();
    }
    
    @isTest
    public static void S2EAccWorkflow_Method4(){
        
        LTS_Disable_Application_Automation__c ltstemp = new LTS_Disable_Application_Automation__c();
        ltstemp.LTS_Disable_Process_Builders__c = false;
        ltstemp.LTS_Disable_Triggers__c = true;
        ltstemp.LTS_Disable_Validation_Rules__c = true;
        ltstemp.LTS_Disable_Workflow_Rules__c = true;
        ltstemp.Name = 'temp';
        ltstemp.SetupOwnerId = userinfo.getuserid();
        insert ltstemp;
        
        Profile p = [SELECT Id FROM profile WHERE name='System Administrator' limit 1];   
          User u4 = new User(alias = 'newUser', email='user@mydomain.com',
            emailencodingkey='UTF-8', lastname='userLTR', languagelocalekey='en_US', 
            localesidkey='en_US', profileid = p.Id, employeenumber='0144020',
            timezonesidkey='America/Los_Angeles', username='userLTR@mydomain.com.'+Math.random(),Rep_Type_Description__c='test',
            Sales_Org__c = 'BKRS');       
            insert u4;
        
        Test.startTest();
        system.runas(u4){
            Account acc4 = UnitTest.getAccountInstance();
            acc4.Name = 'Test Account';
            acc4.Phone = '1234567890';
            acc4.BillingCountry = 'US';
            acc4.BillingState='IL';
            acc4.BillingPostalCode = '60603-3801';
            acc4.SAPAccountNumber__c = 'UTSAP001';
            acc4.Bu_Segment__c = 'Professional Legal';
            acc4.ECC_Top_Named_Law_Firms__c = 'DENTONS';
            acc4.Customer_Group__c = 'Court';
            acc4.Industry = 'Not Applicable';
            acc4.Is_GLI__c = False;
            insert acc4;
            
            acc4.Industry = 'CT Court Federal';
            update acc4;
        }
        
        Test.stopTest();
    }
    
    @isTest
    public static void S2EAccWorkflow_Method5(){
        
        LTS_Disable_Application_Automation__c ltstemp = new LTS_Disable_Application_Automation__c();
        ltstemp.LTS_Disable_Process_Builders__c = false;
        ltstemp.LTS_Disable_Triggers__c = true;
        ltstemp.LTS_Disable_Validation_Rules__c = true;
        ltstemp.LTS_Disable_Workflow_Rules__c = true;
        ltstemp.Name = 'temp';
        ltstemp.SetupOwnerId = userinfo.getuserid();
        insert ltstemp;
        
        Profile p = [SELECT Id FROM profile WHERE name='System Administrator' limit 1];   
          User u5 = new User(alias = 'newUser', email='user@mydomain.com',
            emailencodingkey='UTF-8', lastname='userLTR', languagelocalekey='en_US', 
            localesidkey='en_US', profileid = p.Id, employeenumber='0144020',
            timezonesidkey='America/Los_Angeles', username='userLTR@mydomain.com.'+Math.random(),Rep_Type_Description__c='test',
            Sales_Org__c = 'BKRS');        
            insert u5;
        
        Test.startTest();
        system.runas(u5){
            Account acc5 = UnitTest.getAccountInstance();
            acc5.Name = 'Test Account';
            acc5.Phone = '1234567890';
            acc5.BillingCountry = 'US';
            acc5.BillingState='IL';
            acc5.BillingPostalCode = '60603-3801';
            acc5.SAPAccountNumber__c = 'UTSAP001';
            acc5.Bu_Segment__c = 'Professional Legal';
            acc5.ECC_Top_Named_Law_Firms__c = 'DENTONS';
            acc5.Customer_Group__c = 'GOVERNMENT (FEDERAL)';
            acc5.Industry = 'Not Applicable';
            acc5.Is_GLI__c = False;
            insert acc5;
            
            acc5.Industry = 'GV Government Fed';
            update acc5;
        }
        
        Test.stopTest();
    }
    
    @isTest
    public static void S2EAccWorkflow_Method6(){
        
        LTS_Disable_Application_Automation__c ltstemp = new LTS_Disable_Application_Automation__c();
        ltstemp.LTS_Disable_Process_Builders__c = false;
        ltstemp.LTS_Disable_Triggers__c = true;
        ltstemp.LTS_Disable_Validation_Rules__c = true;
        ltstemp.LTS_Disable_Workflow_Rules__c = true;
        ltstemp.Name = 'temp';
        ltstemp.SetupOwnerId = userinfo.getuserid();
        insert ltstemp;
        
        Profile p = [SELECT Id FROM profile WHERE name='System Administrator' limit 1];   
          User u6 = new User(alias = 'newUser', email='user@mydomain.com',
            emailencodingkey='UTF-8', lastname='userLTR', languagelocalekey='en_US', 
            localesidkey='en_US', profileid = p.Id, employeenumber='0144020',
            timezonesidkey='America/Los_Angeles', username='userLTR@mydomain.com.'+Math.random(),Rep_Type_Description__c='test',
            Sales_Org__c = 'BKRS');       
            insert u6;
        
        Test.startTest();
        system.runas(u6){
            Account acc6 = UnitTest.getAccountInstance();
            acc6.Name = 'Test Account';
            acc6.Phone = '1234567890';
            acc6.BillingCountry = 'US';
            acc6.BillingState='IL';
            acc6.BillingPostalCode = '60603-3801';
            acc6.SAPAccountNumber__c = 'UTSAP001';
            acc6.Bu_Segment__c = 'Professional Legal';
            acc6.ECC_Top_Named_Law_Firms__c = 'DENTONS';
            acc6.Customer_Group__c = 'GOVERNMENT (STATE, LOCAL)';
            acc6.Industry = 'Not Applicable';
            acc6.Is_GLI__c = False;
            insert acc6;
            
            acc6.Industry = 'GV Government Local';
            update acc6;
        }
        
        Test.stopTest();
    }
    
    @isTest
    public static void S2EAccWorkflow_Method7(){
        
        LTS_Disable_Application_Automation__c ltstemp = new LTS_Disable_Application_Automation__c();
        ltstemp.LTS_Disable_Process_Builders__c = false;
        ltstemp.LTS_Disable_Triggers__c = true;
        ltstemp.LTS_Disable_Validation_Rules__c = true;
        ltstemp.LTS_Disable_Workflow_Rules__c = true;
        ltstemp.Name = 'temp';
        ltstemp.SetupOwnerId = userinfo.getuserid();
        insert ltstemp;
        
        Profile p = [SELECT Id FROM profile WHERE name='System Administrator' limit 1];   
          User u7 = new User(alias = 'newUser', email='user@mydomain.com',
            emailencodingkey='UTF-8', lastname='userLTR', languagelocalekey='en_US', 
            localesidkey='en_US', profileid = p.Id, employeenumber='0144020',
            timezonesidkey='America/Los_Angeles', username='userLTR@mydomain.com.'+Math.random(),Rep_Type_Description__c='test',
            Sales_Org__c = 'BKRS');       
            insert u7;
        
        Test.startTest();
        system.runas(u7){
            Account acc7 = UnitTest.getAccountInstance();
            acc7.Name = 'Test Account';
            acc7.Phone = '1234567890';
            acc7.BillingCountry = 'US';
            acc7.BillingState='IL';
            acc7.BillingPostalCode = '60603-3801';
            acc7.SAPAccountNumber__c = 'UTSAP001';
            acc7.Bu_Segment__c = 'Professional Legal';
            acc7.ECC_Top_Named_Law_Firms__c = 'DENTONS';
            acc7.Customer_Group__c = 'IN HOUSE';
            acc7.Industry = 'Not Applicable';
            acc7.Is_GLI__c = False;
            insert acc7;
            
            acc7.Industry = 'TR Intercompany';
            update acc7;
        }
        
        Test.stopTest();
    }
    
    @isTest
    public static void S2EAccWorkflow_Method8(){
        
        LTS_Disable_Application_Automation__c ltstemp = new LTS_Disable_Application_Automation__c();
        ltstemp.LTS_Disable_Process_Builders__c = false;
        ltstemp.LTS_Disable_Triggers__c = true;
        ltstemp.LTS_Disable_Validation_Rules__c = true;
        ltstemp.LTS_Disable_Workflow_Rules__c = true;
        ltstemp.Name = 'temp';
        ltstemp.SetupOwnerId = userinfo.getuserid();
        insert ltstemp;
        
        Profile p = [SELECT Id FROM profile WHERE name='System Administrator' limit 1];   
          User u8 = new User(alias = 'newUser', email='user@mydomain.com',
            emailencodingkey='UTF-8', lastname='userLTR', languagelocalekey='en_US', 
            localesidkey='en_US', profileid = p.Id, employeenumber='0144020',
            timezonesidkey='America/Los_Angeles', username='userLTR@mydomain.com.'+Math.random(),Rep_Type_Description__c='test',
            Sales_Org__c = 'BKRS');       
            insert u8;
        
        Test.startTest();
        system.runas(u8){
            Account acc8 = UnitTest.getAccountInstance();
            acc8.Name = 'Test Account';
            acc8.Phone = '1234567890';
            acc8.BillingCountry = 'US';
            acc8.BillingState='IL';
            acc8.BillingPostalCode = '60603-3801';
            acc8.SAPAccountNumber__c = 'UTSAP001';
            acc8.Bu_Segment__c = 'Professional Legal';
            acc8.ECC_Top_Named_Law_Firms__c = 'DENTONS';
            acc8.Customer_Group__c = 'NON PROFIT';
            acc8.Industry = 'Not Applicable';
            acc8.Is_GLI__c = False;
            insert acc8;
            
            acc8.Industry = 'AS CHARITY/NONPROFIT';
            update acc8;
        }
        
        Test.stopTest();
    }
    
    @isTest
    public static void S2EAccWorkflow_Method9(){
        
        LTS_Disable_Application_Automation__c ltstemp = new LTS_Disable_Application_Automation__c();
        ltstemp.LTS_Disable_Process_Builders__c = false;
        ltstemp.LTS_Disable_Triggers__c = true;
        ltstemp.LTS_Disable_Validation_Rules__c = true;
        ltstemp.LTS_Disable_Workflow_Rules__c = true;
        ltstemp.Name = 'temp';
        ltstemp.SetupOwnerId = userinfo.getuserid();
        insert ltstemp;
        
        Profile p = [SELECT Id FROM profile WHERE name='System Administrator' limit 1];   
          User u9 = new User(alias = 'newUser', email='user@mydomain.com',
            emailencodingkey='UTF-8', lastname='userLTR', languagelocalekey='en_US', 
            localesidkey='en_US', profileid = p.Id, employeenumber='0144020',
            timezonesidkey='America/Los_Angeles', username='userLTR@mydomain.com.'+Math.random(),Rep_Type_Description__c='test',
            Sales_Org__c = 'BKRS');        
            insert u9;
        
        Test.startTest();
        system.runas(u9){
            Account acc9 = UnitTest.getAccountInstance();
            acc9.Name = 'Test Account';
            acc9.Phone = '1234567890';
            acc9.BillingCountry = 'US';
            acc9.BillingState='IL';
            acc9.BillingPostalCode = '60603-3801';
            acc9.SAPAccountNumber__c = 'UTSAP001';
            acc9.Bu_Segment__c = 'Professional Legal';
            acc9.ECC_Top_Named_Law_Firms__c = 'DENTONS';
            acc9.Customer_Group__c = 'PRIVATE (INDIVIDUAL NO BUS)';
            acc9.Industry = 'Not Applicable';
            acc9.Is_GLI__c = False;
            insert acc9;
            
            acc9.Industry = 'PRV-CONSUMER';
            update acc9;
        }
        
        Test.stopTest();
    }
    
    @isTest
    public static void S2EAccWorkflow_Method10(){
        
        LTS_Disable_Application_Automation__c ltstemp = new LTS_Disable_Application_Automation__c();
        ltstemp.LTS_Disable_Process_Builders__c = false;
        ltstemp.LTS_Disable_Triggers__c = true;
        ltstemp.LTS_Disable_Validation_Rules__c = true;
        ltstemp.LTS_Disable_Workflow_Rules__c = true;
        ltstemp.Name = 'temp';
        ltstemp.SetupOwnerId = userinfo.getuserid();
        insert ltstemp;
        
        Profile p = [SELECT Id FROM profile WHERE name='System Administrator' limit 1];   
          User u10 = new User(alias = 'newUser', email='user@mydomain.com',
            emailencodingkey='UTF-8', lastname='userLTR', languagelocalekey='en_US', 
            localesidkey='en_US', profileid = p.Id, employeenumber='0144020',
            timezonesidkey='America/Los_Angeles', username='userLTR@mydomain.com.'+Math.random(),Rep_Type_Description__c='test',
            Sales_Org__c = 'BKRS');        
            insert u10;
        
        Test.startTest();
        system.runas(u10){
            Account acc10 = UnitTest.getAccountInstance();
            acc10.Name = 'Test Account';
            acc10.Phone = '1234567890';
            acc10.BillingCountry = 'US';
            acc10.BillingState='IL';
            acc10.BillingPostalCode = '60603-3801';
            acc10.SAPAccountNumber__c = 'UTSAP001';
            acc10.Bu_Segment__c = 'Professional Legal';
            acc10.ECC_Top_Named_Law_Firms__c = 'DENTONS';
            acc10.Customer_Group__c = 'RESELLER';
            acc10.Industry = 'Not Applicable';
            acc10.Is_GLI__c = False;
            insert acc10;
            
            acc10.Industry = 'TR Library Suppliers';
            update acc10;
        }
        
        Test.stopTest();
    }
    
    @isTest
    public static void S2EAccWorkflow_Method11(){
        
        LTS_Disable_Application_Automation__c ltstemp = new LTS_Disable_Application_Automation__c();
        ltstemp.LTS_Disable_Process_Builders__c = false;
        ltstemp.LTS_Disable_Triggers__c = true;
        ltstemp.LTS_Disable_Validation_Rules__c = true;
        ltstemp.LTS_Disable_Workflow_Rules__c = true;
        ltstemp.Name = 'temp';
        ltstemp.SetupOwnerId = userinfo.getuserid();
        insert ltstemp;
        
        Profile p = [SELECT Id FROM profile WHERE name='System Administrator' limit 1];   
          User u11 = new User(alias = 'newUser', email='user@mydomain.com',
            emailencodingkey='UTF-8', lastname='userLTR', languagelocalekey='en_US', 
            localesidkey='en_US', profileid = p.Id, employeenumber='0144020',
            timezonesidkey='America/Los_Angeles', username='userLTR@mydomain.com.'+Math.random(),Rep_Type_Description__c='test',
            Sales_Org__c = 'BKRS');        
            insert u11;
        
        Test.startTest();
        system.runas(u11){
            Account acc11 = UnitTest.getAccountInstance();
            acc11.Name = 'Test Account';
            acc11.Phone = '1234567890';
            acc11.BillingCountry = 'US';
            acc11.BillingState='IL';
            acc11.BillingPostalCode = '60603-3801';
            acc11.SAPAccountNumber__c = 'UTSAP001';
            acc11.Bu_Segment__c = 'Professional Legal';
            acc11.ECC_Top_Named_Law_Firms__c = 'DENTONS';
            acc11.Customer_Group__c = 'STUDENT';
            acc11.Industry = 'Not Applicable';
            acc11.Is_GLI__c = False;
            insert acc11;
            
            acc11.Industry = 'ED Student';
            update acc11;
        }
        
        Test.stopTest();
    }
    
    @isTest
    public static void S2EAccWorkflow_Method12(){
        
        LTS_Disable_Application_Automation__c ltstemp = new LTS_Disable_Application_Automation__c();
        ltstemp.LTS_Disable_Process_Builders__c = false;
        ltstemp.LTS_Disable_Triggers__c = true;
        ltstemp.LTS_Disable_Validation_Rules__c = true;
        ltstemp.LTS_Disable_Workflow_Rules__c = true;
        ltstemp.Name = 'temp';
        ltstemp.SetupOwnerId = userinfo.getuserid();
        insert ltstemp;
        
        Profile p = [SELECT Id FROM profile WHERE name='System Administrator' limit 1];   
          User u12 = new User(alias = 'newUser', email='user@mydomain.com',
            emailencodingkey='UTF-8', lastname='userLTR', languagelocalekey='en_US', 
            localesidkey='en_US', profileid = p.Id, employeenumber='0144020',
            timezonesidkey='America/Los_Angeles', username='userLTR@mydomain.com.'+Math.random(),Rep_Type_Description__c='test',
            Sales_Org__c = 'BKRS');        
            insert u12;
        
        Test.startTest();
        system.runas(u12){
            Account acc12 = UnitTest.getAccountInstance();
            acc12.Name = 'Test Account';
            acc12.Phone = '1234567890';
            acc12.BillingCountry = 'US';
            acc12.BillingState='IL';
            acc12.BillingPostalCode = '60603-3801';
            acc12.SAPAccountNumber__c = 'UTSAP001';
            acc12.Bu_Segment__c = 'Professional Legal';
            acc12.ECC_Top_Named_Law_Firms__c = 'DENTONS';
            acc12.Customer_Group__c = 'TERTIARY INSTITUTION';
            acc12.Industry = 'Not Applicable';
            acc12.Is_GLI__c = False;
            insert acc12;
            
            acc12.Industry = 'ED Tertiary Inst';
            update acc12;
        }
        
        Test.stopTest();
    }
    
    @isTest
    public static void S2EAccWorkflow_Method13(){
        
        LTS_Disable_Application_Automation__c ltstemp = new LTS_Disable_Application_Automation__c();
        ltstemp.LTS_Disable_Process_Builders__c = false;
        ltstemp.LTS_Disable_Triggers__c = true;
        ltstemp.LTS_Disable_Validation_Rules__c = true;
        ltstemp.LTS_Disable_Workflow_Rules__c = true;
        ltstemp.Name = 'temp';
        ltstemp.SetupOwnerId = userinfo.getuserid();
        insert ltstemp;
        
        Profile p = [SELECT Id FROM profile WHERE name='System Administrator' limit 1];   
          User u13 = new User(alias = 'newUser', email='user@mydomain.com',
            emailencodingkey='UTF-8', lastname='userLTR', languagelocalekey='en_US', 
            localesidkey='en_US', profileid = p.Id, employeenumber='0144020',
            timezonesidkey='America/Los_Angeles', username='userLTR@mydomain.com.'+Math.random(),Rep_Type_Description__c='test',
            Sales_Org__c = 'BKRS');        
            insert u13;
        
        Test.startTest();
        system.runas(u13){
            Account acc13 = UnitTest.getAccountInstance();
            acc13.Name = 'Test Account';
            acc13.Phone = '1234567890';
            acc13.BillingCountry = 'US';
            acc13.BillingState='IL';
            acc13.BillingPostalCode = '60603-3801';
            acc13.SAPAccountNumber__c = 'UTSAP001';
            acc13.Bu_Segment__c = 'Professional Legal';
            acc13.ECC_Top_Named_Law_Firms__c = 'DENTONS';
            acc13.Customer_Group__c = 'TRADE HOUSE';
            acc13.Industry = 'Not Applicable';
            acc13.Is_GLI__c = False;
            insert acc13;
            
            acc13.Industry = 'TR Campus Bookshops';
            update acc13;
        }
        
        Test.stopTest();
    }
    
    @isTest
    public static void S2EAccWorkflow_Method14(){
        
        LTS_Disable_Application_Automation__c ltstemp = new LTS_Disable_Application_Automation__c();
        ltstemp.LTS_Disable_Process_Builders__c = false;
        ltstemp.LTS_Disable_Triggers__c = true;
        ltstemp.LTS_Disable_Validation_Rules__c = true;
        ltstemp.LTS_Disable_Workflow_Rules__c = true;
        ltstemp.Name = 'temp';
        ltstemp.SetupOwnerId = userinfo.getuserid();
        insert ltstemp;
        
        Profile p = [SELECT Id FROM profile WHERE name='System Administrator' limit 1];   
          User u14 = new User(alias = 'newUser', email='user@mydomain.com',
            emailencodingkey='UTF-8', lastname='userLTR', languagelocalekey='en_US', 
            localesidkey='en_US', profileid = p.Id, employeenumber='0144020',
            timezonesidkey='America/Los_Angeles', username='userLTR@mydomain.com.'+Math.random(),Rep_Type_Description__c='test',
            Sales_Org__c = 'BKRS');        
            insert u14;
        
        Test.startTest();
        system.runas(u14){
            Account acc14 = UnitTest.getAccountInstance();
            acc14.Name = 'Test Account';
            acc14.Phone = '1234567890';
            acc14.BillingCountry = 'US';
            acc14.BillingState='IL';
            acc14.BillingPostalCode = '60603-3801';
            acc14.SAPAccountNumber__c = 'UTSAP001';
            acc14.Bu_Segment__c = 'Professional Legal';
            acc14.ECC_Top_Named_Law_Firms__c = 'DENTONS';
            acc14.Customer_Group__c = 'ACADEMIC';
            acc14.Industry = 'Not Applicable';
            acc14.Is_GLI__c = False;
            insert acc14;
            
            acc14.Industry = 'ACAD-OTHER SCHOOL';
            update acc14;
        }
        
        Test.stopTest();
    }
    
    @isTest
    public static void S2EAccWorkflow_Method15(){
        
        LTS_Disable_Application_Automation__c ltstemp = new LTS_Disable_Application_Automation__c();
        ltstemp.LTS_Disable_Process_Builders__c = false;
        ltstemp.LTS_Disable_Triggers__c = true;
        ltstemp.LTS_Disable_Validation_Rules__c = true;
        ltstemp.LTS_Disable_Workflow_Rules__c = true;
        ltstemp.Name = 'temp';
        ltstemp.SetupOwnerId = userinfo.getuserid();
        insert ltstemp;
        
        Profile p = [SELECT Id FROM profile WHERE name='System Administrator' limit 1];   
          User u15 = new User(alias = 'newUser', email='user@mydomain.com',
            emailencodingkey='UTF-8', lastname='userLTR', languagelocalekey='en_US', 
            localesidkey='en_US', profileid = p.Id, employeenumber='0144020',
            timezonesidkey='America/Los_Angeles', username='userLTR@mydomain.com.'+Math.random(),Rep_Type_Description__c='test',
            Sales_Org__c = 'BKRS');        
            insert u15;
        
        Test.startTest();
        system.runas(u15){
            Account acc15 = UnitTest.getAccountInstance();
            acc15.Name = 'Test Account';
            acc15.Phone = '1234567890';
            acc15.BillingCountry = 'US';
            acc15.BillingState='IL';
            acc15.BillingPostalCode = '60603-3801';
            acc15.SAPAccountNumber__c = 'UTSAP001';
            acc15.Bu_Segment__c = 'Professional Legal';
            acc15.ECC_Top_Named_Law_Firms__c = 'DENTONS';
            acc15.Customer_Group__c = 'CORPORATION';
            acc15.Industry = 'Not Applicable';
            acc15.Is_GLI__c = False;
            insert acc15;
            
            acc15.Industry = 'CORP-OTHER';
            update acc15;
        }
        
        Test.stopTest();
    }
    
    @isTest
    public static void S2EAccWorkflow_Method16(){
        
        LTS_Disable_Application_Automation__c ltstemp = new LTS_Disable_Application_Automation__c();
        ltstemp.LTS_Disable_Process_Builders__c = false;
        ltstemp.LTS_Disable_Triggers__c = true;
        ltstemp.LTS_Disable_Validation_Rules__c = true;
        ltstemp.LTS_Disable_Workflow_Rules__c = true;
        ltstemp.Name = 'temp';
        ltstemp.SetupOwnerId = userinfo.getuserid();
        insert ltstemp;
        
        Profile p = [SELECT Id FROM profile WHERE name='System Administrator' limit 1];   
          User u16 = new User(alias = 'newUser', email='user@mydomain.com',
            emailencodingkey='UTF-8', lastname='userLTR', languagelocalekey='en_US', 
            localesidkey='en_US', profileid = p.Id, employeenumber='0144020',
            timezonesidkey='America/Los_Angeles', username='userLTR@mydomain.com.'+Math.random(),Rep_Type_Description__c='test',
            Sales_Org__c = 'BKRS');        
            insert u16;
        
        Test.startTest();
        system.runas(u16){
            Account acc16 = UnitTest.getAccountInstance();
            acc16.Name = 'Test Account';
            acc16.Phone = '1234567890';
            acc16.BillingCountry = 'US';
            acc16.BillingState='IL';
            acc16.BillingPostalCode = '60603-3801';
            acc16.SAPAccountNumber__c = 'UTSAP001';
            acc16.Bu_Segment__c = 'Professional Legal';
            acc16.ECC_Top_Named_Law_Firms__c = 'DENTONS';
            acc16.Customer_Group__c = 'GOVERNMENT (FEDERAL)';
            acc16.Industry = 'Not Applicable';
            acc16.Is_GLI__c = False;
            insert acc16;
            
            acc16.Industry = 'FG-OTHER';
            update acc16;
        }
        
        Test.stopTest();
    }
    
    @isTest
    public static void S2EAccWorkflow_Method17(){
        
        LTS_Disable_Application_Automation__c ltstemp = new LTS_Disable_Application_Automation__c();
        ltstemp.LTS_Disable_Process_Builders__c = false;
        ltstemp.LTS_Disable_Triggers__c = true;
        ltstemp.LTS_Disable_Validation_Rules__c = true;
        ltstemp.LTS_Disable_Workflow_Rules__c = true;
        ltstemp.Name = 'temp';
        ltstemp.SetupOwnerId = userinfo.getuserid();
        insert ltstemp;
        
        Profile p = [SELECT Id FROM profile WHERE name='System Administrator' limit 1];   
          User u17 = new User(alias = 'newUser', email='user@mydomain.com',
            emailencodingkey='UTF-8', lastname='userLTR', languagelocalekey='en_US', 
            localesidkey='en_US', profileid = p.Id, employeenumber='0144020',
            timezonesidkey='America/Los_Angeles', username='userLTR@mydomain.com.'+Math.random(),Rep_Type_Description__c='test',
            Sales_Org__c = 'WEST');        
            insert u17;
        
        Test.startTest();
        system.runas(u17){
            Account acc17 = UnitTest.getAccountInstance();
            acc17.Name = 'Test Account';
            acc17.Phone = '1234567890';
            acc17.BillingCountry = 'US';
            acc17.BillingState='IL';
            acc17.BillingPostalCode = '60603-3801';
            acc17.SAPAccountNumber__c = 'UTSAP001';
            acc17.Bu_Segment__c = 'Professional Legal';
            acc17.ECC_Top_Named_Law_Firms__c = 'DENTONS';
            acc17.Customer_Group__c = 'LAW FIRM';
            acc17.Industry = 'Not Applicable';
            acc17.Is_GLI__c = False;
            insert acc17;
            
            acc17.Industry = 'FIRM-LAW SMALL';
            update acc17;
        }
        
        Test.stopTest();
    }
    
    @isTest
    public static void S2EAccWorkflow_Method18(){
        
        LTS_Disable_Application_Automation__c ltstemp = new LTS_Disable_Application_Automation__c();
        ltstemp.LTS_Disable_Process_Builders__c = false;
        ltstemp.LTS_Disable_Triggers__c = true;
        ltstemp.LTS_Disable_Validation_Rules__c = true;
        ltstemp.LTS_Disable_Workflow_Rules__c = true;
        ltstemp.Name = 'temp';
        ltstemp.SetupOwnerId = userinfo.getuserid();
        insert ltstemp;
        
        Profile p = [SELECT Id FROM profile WHERE name='System Administrator' limit 1];   
          User u18 = new User(alias = 'newUser', email='user@mydomain.com',
            emailencodingkey='UTF-8', lastname='userLTR', languagelocalekey='en_US', 
            localesidkey='en_US', profileid = p.Id, employeenumber='0144020',
            timezonesidkey='America/Los_Angeles', username='userLTR@mydomain.com.'+Math.random(),Rep_Type_Description__c='test',
            Sales_Org__c = 'WEST');        
            insert u18;
        
        Test.startTest();
        system.runas(u18){
            Account acc18 = UnitTest.getAccountInstance();
            acc18.Name = 'Test Account';
            acc18.Phone = '1234567890';
            acc18.BillingCountry = 'US';
            acc18.BillingState='IL';
            acc18.BillingPostalCode = '60603-3801';
            acc18.SAPAccountNumber__c = 'UTSAP001';
            acc18.Bu_Segment__c = 'Professional Legal';
            acc18.ECC_Top_Named_Law_Firms__c = 'DENTONS';
            acc18.Customer_Group__c = 'GOVERNMENT (STATE, LOCAL)';
            acc18.Industry = 'Not Applicable';
            acc18.Is_GLI__c = False;
            insert acc18;
            
            acc18.Industry = 'GVT-STATE';
            update acc18;
        }
        
        Test.stopTest();
    }
    
    @isTest
    public static void S2EAccWorkflow_Method19(){
        
        LTS_Disable_Application_Automation__c ltstemp = new LTS_Disable_Application_Automation__c();
        ltstemp.LTS_Disable_Process_Builders__c = false;
        ltstemp.LTS_Disable_Triggers__c = true;
        ltstemp.LTS_Disable_Validation_Rules__c = true;
        ltstemp.LTS_Disable_Workflow_Rules__c = true;
        ltstemp.Name = 'temp';
        ltstemp.SetupOwnerId = userinfo.getuserid();
        insert ltstemp;
        
        Profile p = [SELECT Id FROM profile WHERE name='System Administrator' limit 1];   
          User u19 = new User(alias = 'newUser', email='user@mydomain.com',
            emailencodingkey='UTF-8', lastname='userLTR', languagelocalekey='en_US', 
            localesidkey='en_US', profileid = p.Id, employeenumber='0144020',
            timezonesidkey='America/Los_Angeles', username='userLTR@mydomain.com.'+Math.random(),Rep_Type_Description__c='test',
            Sales_Org__c = 'WEST');        
            insert u19;
        
        Test.startTest();
        system.runas(u19){
            Account acc19 = UnitTest.getAccountInstance();
            acc19.Name = 'Test Account';
            acc19.Phone = '1234567890';
            acc19.BillingCountry = 'US';
            acc19.BillingState='IL';
            acc19.BillingPostalCode = '60603-3801';
            acc19.SAPAccountNumber__c = 'UTSAP001';
            acc19.Bu_Segment__c = 'Professional Legal';
            acc19.ECC_Top_Named_Law_Firms__c = 'DENTONS';
            acc19.Customer_Group__c = 'PRIVATE (INDIVIDUAL NO BUS)';
            acc19.Industry = 'Not Applicable';
            acc19.Is_GLI__c = False;
            insert acc19;
            
            acc19.Industry = 'PRV-CONSUMER';
            update acc19;
        }
        
        Test.stopTest();
    }
    
    @isTest
    public static void S2EAccWorkflow_Method20(){
        
        LTS_Disable_Application_Automation__c ltstemp = new LTS_Disable_Application_Automation__c();
        ltstemp.LTS_Disable_Process_Builders__c = false;
        ltstemp.LTS_Disable_Triggers__c = true;
        ltstemp.LTS_Disable_Validation_Rules__c = true;
        ltstemp.LTS_Disable_Workflow_Rules__c = true;
        ltstemp.Name = 'temp';
        ltstemp.SetupOwnerId = userinfo.getuserid();
        insert ltstemp;
        
        Profile p = [SELECT Id FROM profile WHERE name='System Administrator' limit 1];   
          User u20 = new User(alias = 'newUser', email='user@mydomain.com',
            emailencodingkey='UTF-8', lastname='userLTR', languagelocalekey='en_US', 
            localesidkey='en_US', profileid = p.Id, employeenumber='0144020',
            timezonesidkey='America/Los_Angeles', username='userLTR@mydomain.com.'+Math.random(),Rep_Type_Description__c='test',
            Sales_Org__c = 'WEST');        
            insert u20;
        
        Test.startTest();
        system.runas(u20){
            Account acc20 = UnitTest.getAccountInstance();
            acc20.Name = 'Test Account';
            acc20.Phone = '1234567890';
            acc20.BillingCountry = 'US';
            acc20.BillingState='IL';
            acc20.BillingPostalCode = '60603-3801';
            acc20.SAPAccountNumber__c = 'UTSAP001';
            acc20.Bu_Segment__c = 'Professional Legal';
            acc20.ECC_Top_Named_Law_Firms__c = 'DENTONS';
            acc20.Customer_Group__c = 'RESELLER';
            acc20.Industry = 'Not Applicable';
            acc20.Is_GLI__c = False;
            insert acc20;
            
            acc20.Industry = 'RS-DISTRIBUTOR INTL';
            update acc20;
        }
        
        Test.stopTest();
    }
    
   /* @isTest
    public static void S2EAccWorkflow_Method21(){
        
        LTS_Disable_Application_Automation__c ltstemp = new LTS_Disable_Application_Automation__c();
        ltstemp.LTS_Disable_Process_Builders__c = false;
        ltstemp.LTS_Disable_Triggers__c = true;
        ltstemp.LTS_Disable_Validation_Rules__c = true;
        ltstemp.LTS_Disable_Workflow_Rules__c = true;
        ltstemp.Name = 'temp';
        ltstemp.SetupOwnerId = userinfo.getuserid();
        insert ltstemp;
        
         Id profileId = [SELECT Id From Profile Where Name = 'Partner Portal User' LIMIT 1].Id;
         user u21 = [SELECT Id FROM User WHERE profileId =:profileId AND IsActive = True LIMIT 1];
         Profile_List__c pl = new Profile_List__c(Name= profileId,Profile_Name__c='Partner Portal User');
         insert pl;
        
        /*Profile p = [SELECT Id FROM profile WHERE name='Partner Portal User' limit 1];   
          User u21 = new User(alias = 'newUser', email='user@mydomain.com',
            emailencodingkey='UTF-8', lastname='userLTR', languagelocalekey='en_US', 
            localesidkey='en_US', profileid = p.Id, employeenumber='0144020',
            timezonesidkey='America/Los_Angeles', username='userLTR@mydomain.com.'+Math.random(),Rep_Type_Description__c='test',
            Sales_Org__c = 'WEST', ContactId = contact1.Id);        
            insert u21;//
        
        Test.startTest();
        system.runas(u21){
            Account acc21 = UnitTest.getAccountInstance();
            acc21.Name = 'Test Account';
            acc21.Phone = '1234567890';
            acc21.Is_GLI__c = False;
            insert acc21;
            
            acc21.OwnerId = '00530000007LMPs';
            update acc21;
            
            
            Contact oContact1 = UnitTest.getContactInstance(acc21.Id);
            oContact1.Title = 'test1';
            oContact1.Job_Function__c = 'test1';
            oContact1.Email = 'test1@test.com';
            insert oContact1;
        }
        
        Test.stopTest();
    }*/
    
    @isTest
    public static void S2EAccWorkflow_Method22(){
        
        LTS_Disable_Application_Automation__c ltstemp = new LTS_Disable_Application_Automation__c();
        ltstemp.LTS_Disable_Process_Builders__c = false;
        ltstemp.LTS_Disable_Triggers__c = true;
        ltstemp.LTS_Disable_Validation_Rules__c = true;
        ltstemp.LTS_Disable_Workflow_Rules__c = true;
        ltstemp.Name = 'temp';
        ltstemp.SetupOwnerId = userinfo.getuserid();
        insert ltstemp;
        
        Profile p = [SELECT Id FROM profile WHERE name='System Administrator' limit 1];   
          User u22 = new User(alias = 'newUser', email='user@mydomain.com',
            emailencodingkey='UTF-8', lastname='userLTR', languagelocalekey='en_US', 
            localesidkey='en_US', profileid = p.Id, employeenumber='0144020',
            timezonesidkey='America/Los_Angeles', username='userLTR@mydomain.com.'+Math.random(),Rep_Type_Description__c='test',
            Sales_Org__c = 'WEST');        
            insert u22;
        
        Test.startTest();
        system.runas(u22){
            Account acc22 = UnitTest.getAccountInstance();
            acc22.recordTypeId =  Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Prospect').getRecordTypeId();
            acc22.Name = 'Test Account';
            acc22.Phone = '1234567890';
            acc22.Sales_Org__c = 'LLEY';
            insert acc22;
            
            acc22.Is_Primary__c = true ;
            update acc22;
        }
        
        Test.stopTest();
    }
    
    @isTest
    public static void S2EAccWorkflow_Method23(){
        
        LTS_Disable_Application_Automation__c ltstemp = new LTS_Disable_Application_Automation__c();
        ltstemp.LTS_Disable_Process_Builders__c = false;
        ltstemp.LTS_Disable_Triggers__c = true;
        ltstemp.LTS_Disable_Validation_Rules__c = true;
        ltstemp.LTS_Disable_Workflow_Rules__c = true;
        ltstemp.Name = 'temp';
        ltstemp.SetupOwnerId = userinfo.getuserid();
        insert ltstemp;
        
        Profile p = [SELECT Id FROM profile WHERE name='System Administrator' limit 1];   
          User u23 = new User(alias = 'newUser', email='user@mydomain.com',
            emailencodingkey='UTF-8', lastname='userLTR', languagelocalekey='en_US', 
            localesidkey='en_US', profileid = p.Id, employeenumber='0144020',
            timezonesidkey='America/Los_Angeles', username='userLTR@mydomain.com.'+Math.random(),Rep_Type_Description__c='test',
            Sales_Org__c = 'BKRS');        
            insert u23;
        
        Test.startTest();
        system.runas(u23){
            Account acc23 = UnitTest.getAccountInstance();
            acc23.Name = 'Test Account';
            acc23.Phone = '1234567890';
            acc23.BillingCountry = 'US';
            acc23.BillingState='IL';
            acc23.BillingPostalCode = '60603-3801';
            acc23.SAPAccountNumber__c = 'UTSAP001';
            acc23.Bu_Segment__c = 'Professional Legal';
            acc23.ECC_Top_Named_Law_Firms__c = 'DENTONS';
            acc23.Customer_Group__c = 'Accounting';
            acc23.Industry = 'Not Applicable';
            insert acc23;
            
            acc23.Industry = 'AC ACCOUNTING';
            update acc23;
        }
        
        Test.stopTest();
    }
    
    @isTest
    public static void S2EAccWorkflow_Method24(){
        
        LTS_Disable_Application_Automation__c ltstemp = new LTS_Disable_Application_Automation__c();
        ltstemp.LTS_Disable_Process_Builders__c = false;
        ltstemp.LTS_Disable_Triggers__c = true;
        ltstemp.LTS_Disable_Validation_Rules__c = true;
        ltstemp.LTS_Disable_Workflow_Rules__c = true;
        ltstemp.Name = 'temp';
        ltstemp.SetupOwnerId = userinfo.getuserid();
        insert ltstemp;
        
        Profile p = [SELECT Id FROM profile WHERE name='System Administrator' limit 1];   
          User u24 = new User(alias = 'newUser', email='user@mydomain.com',
            emailencodingkey='UTF-8', lastname='userLTR', languagelocalekey='en_US', 
            localesidkey='en_US', profileid = p.Id, employeenumber='0144020',
            timezonesidkey='America/Los_Angeles', username='userLTR@mydomain.com.'+Math.random(),Rep_Type_Description__c='test',
            Sales_Org__c = 'BKRS');        
            insert u24;
        
        Test.startTest();
        system.runas(u24){
            Account acc24 = UnitTest.getAccountInstance();
            acc24.Name = 'Test Account';
            acc24.Phone = '1234567890';
            acc24.BillingCountry = 'US';
            acc24.BillingState='IL';
            acc24.BillingPostalCode = '60603-3801';
            acc24.SAPAccountNumber__c = 'UTSAP001';
            acc24.Bu_Segment__c = 'Professional Legal';
            acc24.ECC_Top_Named_Law_Firms__c = 'DENTONS';
            acc24.Customer_Group__c = 'FIRM';
            acc24.Industry = 'Not Applicable';
            insert acc24;
            
            acc24.Industry = 'LE Legal';
            update acc24;
        }
        
        Test.stopTest();
    }    
    
}