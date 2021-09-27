@isTest
public class Lotus_create_new_lead_switch_test {
    
    
    @testSetup static void addKeyValueStore() {
        KeyValueListStore__c profilename = new KeyValueListStore__c();
        profilename.TextValue__c = 'TR Corp Partner Community User';
        profilename.Name = 'LTS_partnerUserProfileName';
        insert profilename;
        
        KeyValueListStore__c leadsourcevalue = new KeyValueListStore__c();
        leadsourcevalue.Name = 'LTS_partnerUserLeadSourceValue';
        leadsourcevalue.TextValue__c = 'Partner';
        insert leadsourcevalue;
        
        KeyValueListStore__c busegment = new KeyValueListStore__c();
        busegment.Name = 'LTS_partnerUserBUSegmentValue';
        busegment.TextValue__c = 'Corporate';
        insert busegment;
    }
    
    
    @isTest static void testLeadSwitchUKILightning(){
        
        Profile p = [SELECT Id FROM profile WHERE name='UKI Users'];   
        User u1 = new User(alias = 'newUser', email='user@mydomain.com', 
                           emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
                           localesidkey='en_US', profileid = p.Id, employeenumber='0144020',
                           timezonesidkey='America/Los_Angeles', username='user@mydomain.com.'+Math.random(),Rep_Type_Description__c='test');        
        insert u1;
        
        system.runas(u1){
            
            
            LTS_Disable_Application_Automation__c ltstemp = new LTS_Disable_Application_Automation__c();
            ltstemp.LTS_Disable_Process_Builders__c = false;
            ltstemp.LTS_Disable_Triggers__c = true;
            ltstemp.LTS_Disable_Validation_Rules__c = true;
            ltstemp.LTS_Disable_Workflow_Rules__c = true;
            ltstemp.Name = 'temp';
            ltstemp.SetupOwnerId = userinfo.getuserid();
            insert ltstemp;
            
            recordtype leadRt= [select id from recordtype where developername ='Create_New_Lead' and sobjecttype='Lead' limit 1];
            List<Lead> listlead = new List<Lead>();
            test.starttest();
            Lead TestLead1 = UnitTest.getLeadInstance();
            TestLead1.LeadSource='Customer Service'; 
            TestLead1 .RecordTypeId=leadRt.Id;      
            TestLead1.SAPAccountNumber__c = '98711';
            TestLead1.FirstName = 'Unit';
            TestLead1.LastName = 'Tester1';
            TestLead1.Company = 'Unit Test Company';
            
            TestLead1.is_GLI__c =true;
            TestLead1.Sales_Org__c='GLI';
            TestLead1.Status = 'Contacting';         
            TestLead1.Billing_Country__c='US';
            TestLead1.Description='Lead is created for GLI';
            listlead.add(TestLead1);
            
            if(listlead.size()>0){
                insert listlead;
                System.assertEquals(true, listlead[0].id != null);
            }
            
            Test.stoptest();
            
        }
        
    }
    @isTest static void testLeadSwitchEliteLightning(){
        
        Profile p = [SELECT Id FROM profile WHERE name='Elite User'];   
        User u1 = new User(alias = 'newUser', email='user@mydomain.com', 
                           emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
                           localesidkey='en_US', profileid = p.Id,
                           timezonesidkey='America/Los_Angeles', username='user@mydomain.com.'+Math.random(),Rep_Type_Description__c='test');        
        insert u1;
        
        system.runas(u1){
            
            
            LTS_Disable_Application_Automation__c ltstemp = new LTS_Disable_Application_Automation__c();
            ltstemp.LTS_Disable_Process_Builders__c = false;
            ltstemp.LTS_Disable_Triggers__c = true;
            ltstemp.LTS_Disable_Validation_Rules__c = true;
            ltstemp.LTS_Disable_Workflow_Rules__c = true;
            ltstemp.Name = 'temp';
            ltstemp.SetupOwnerId = userinfo.getuserid();
            insert ltstemp;
            
            recordtype leadRt= [select id from recordtype where developername ='Create_New_Lead' and sobjecttype='Lead' limit 1];
            List<Lead> listlead = new List<Lead>();
            test.starttest();
            Lead TestLead1 = UnitTest.getLeadInstance();
            TestLead1.LeadSource='Customer Service'; 
            TestLead1 .RecordTypeId=leadRt.Id;      
            TestLead1.SAPAccountNumber__c = '98711';
            TestLead1.FirstName = 'Unit';
            TestLead1.LastName = 'Tester1';
            TestLead1.Company = 'Unit Test Company';
            
            TestLead1.is_GLI__c =true;
            TestLead1.Sales_Org__c='GLI';
            TestLead1.Status = 'Contacting';         
            TestLead1.Billing_Country__c='US';
            TestLead1.Description='Lead is created for GLI';
            listlead.add(TestLead1);
            
            if(listlead.size()>0){
                insert listlead;
                System.assertEquals(true, listlead[0].id != null);
            }
            
            Test.stoptest();
            
        }
        
    }
    @isTest static void testLeadSwitchGliLightning(){
        
        Profile p = [SELECT Id FROM profile WHERE name='GLI Sales User'];   
        User u1 = new User(alias = 'newUser', email='user@mydomain.com', 
                           emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
                           localesidkey='en_US', profileid = p.Id, employeenumber='0144020',
                           timezonesidkey='America/Los_Angeles', username='user@mydomain.com.'+Math.random(),Rep_Type_Description__c='test');        
        insert u1;
        
        system.runas(u1){
            
            
            LTS_Disable_Application_Automation__c ltstemp = new LTS_Disable_Application_Automation__c();
            ltstemp.LTS_Disable_Process_Builders__c = false;
            ltstemp.LTS_Disable_Triggers__c = true;
            ltstemp.LTS_Disable_Validation_Rules__c = true;
            ltstemp.LTS_Disable_Workflow_Rules__c = true;
            ltstemp.Name = 'temp';
            ltstemp.SetupOwnerId = userinfo.getuserid();
            insert ltstemp;
            
            recordtype leadRt= [select id from recordtype where developername ='Create_New_Lead' and sobjecttype='Lead' limit 1];
            List<Lead> listlead = new List<Lead>();
            test.starttest();
            Lead TestLead1 = UnitTest.getLeadInstance();
            TestLead1.LeadSource='Customer Service'; 
            TestLead1 .RecordTypeId=leadRt.Id;      
            TestLead1.SAPAccountNumber__c = '98711';
            TestLead1.FirstName = 'Unit';
            TestLead1.LastName = 'Tester1';
            TestLead1.Company = 'Unit Test Company';
            
            TestLead1.is_GLI__c =true;
            TestLead1.Sales_Org__c='GLI';
            TestLead1.Status = 'Contacting';         
            TestLead1.Billing_Country__c='US';
            TestLead1.Description='Lead is created for GLI';
            listlead.add(TestLead1);
            
            if(listlead.size()>0){
                insert listlead;
                System.assertEquals(true, listlead[0].id != null);
            }
            
            Test.stoptest();
            
        }
        
    }
    @isTest static void testLeadSwitchinvokeDummy(){
        
        Profile p = [SELECT Id FROM profile WHERE name='System administrator'];   
        User u1 = new User(alias = 'newUser', email='user@mydomain.com', 
                           emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
                           localesidkey='en_US', profileid = p.Id, employeenumber='0144020',
                           timezonesidkey='America/Los_Angeles', username='user@mydomain.com.'+Math.random(),Rep_Type_Description__c='test');        
        insert u1;
        
        system.runas(u1){
            
            
            LTS_Disable_Application_Automation__c ltstemp = new LTS_Disable_Application_Automation__c();
            ltstemp.LTS_Disable_Process_Builders__c = true;
            ltstemp.LTS_Disable_Triggers__c = true;
            ltstemp.LTS_Disable_Validation_Rules__c = true;
            ltstemp.LTS_Disable_Workflow_Rules__c = true;
            ltstemp.Name = 'temp';
            ltstemp.SetupOwnerId = userinfo.getuserid();
            insert ltstemp;
            System.assertEquals(true, ltstemp != null);
            recordtype leadRt= [select id from recordtype where developername ='Create_New_Lead' and sobjecttype='Lead' limit 1];
            List<Lead> listlead = new List<Lead>();
            test.starttest();
            Lead TestLead1 = UnitTest.getLeadInstance();
            TestLead1.LeadSource='Customer Service'; 
            TestLead1 .RecordTypeId=leadRt.Id;      
            TestLead1.SAPAccountNumber__c = '98711';
            TestLead1.FirstName = 'Unit';
            TestLead1.LastName = 'Tester1';
            TestLead1.Company = 'Unit Test Company';
            
            TestLead1.is_GLI__c =true;
            TestLead1.Sales_Org__c='GLI';
            TestLead1.Status = 'Contacting';         
            TestLead1.Billing_Country__c='US';
            TestLead1.Description='Lead is created for GLI';
            listlead.add(TestLead1);
            
            if(listlead.size()>0){
                insert listlead;
                System.assertEquals(true, listlead[0].id != null);
            }
            Test.stopTest();
            
            
        }
        
        
    }
    
    
    
    
}