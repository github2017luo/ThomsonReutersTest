/*This class is created for flow coverage of 'Panorama_Lead_stage_based_on_Lead_score_and_DQ_reason'[Update Panorama Lead stage based on Lead score and DQ reason] process builder
*/
@isTest
public class Panorama_Lead_stage_Test {
    
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
    @isTest static void method1() {
        
        /*
AND(
$Setup.LTS_Disable_Application_Automation__c.LTS_Disable_Process_Builders__c = false,
ISPICKVAL([Lead].Status ,"Unworked") ,
[Lead].Is_GLI__c = TRUE,

NOT([Lead].LCRM_Sub_BU__c="UKI"), 

OR
([Lead].Lead_Scoring_Combined__c =  "A4",
[Lead].Lead_Scoring_Combined__c =  "B4",
[Lead].Lead_Scoring_Combined__c =  "C4",
[Lead].Lead_Scoring_Combined__c =  "D3",
[Lead].Lead_Scoring_Combined__c =  "D4")
)  */
        
        LTS_Disable_Application_Automation__c ltstemp = new LTS_Disable_Application_Automation__c();
        ltstemp.LTS_Disable_Process_Builders__c = false;
        ltstemp.LTS_Disable_Triggers__c = true;
        ltstemp.LTS_Disable_Validation_Rules__c = true;
        ltstemp.LTS_Disable_Workflow_Rules__c = true;
        ltstemp.Name = 'temp';
        ltstemp.SetupOwnerId = userinfo.getuserid();
        insert ltstemp;
        
        recordtype leadRt= [select id from recordtype where name ='GLI' and sobjecttype='Lead' limit 1];
        List<Lead> listlead = new List<Lead>();
        test.starttest();
        Lead TestLead1 = UnitTest.getLeadInstance();
        TestLead1.LeadSource='Customer Service'; 
        TestLead1 .RecordTypeId=leadRt.Id;      
        TestLead1.SAPAccountNumber__c = '98711';
        TestLead1.FirstName = 'Unit 786786';
        TestLead1.LastName = 'Tester1';
        TestLead1.Lead_Scoring_Combined__c = 'B4';
        TestLead1.Company = '786th floor';     
        TestLead1.is_GLI__c =true;
        TestLead1.Sales_Org__c='GLI';
        TestLead1.Status = 'Unworked';         
        TestLead1.Billing_Country__c='US';
        TestLead1.Description='Lead is created for GLI';
        listlead.add(TestLead1);
        
        if(listlead.size()>0){
            insert listlead;
        }
        
        Test.stoptest();
        
        
        
    } 
    
    @isTest static void method2() {       
        
        
        LTS_Disable_Application_Automation__c ltstemp = new LTS_Disable_Application_Automation__c();
        ltstemp.LTS_Disable_Process_Builders__c = false;
        ltstemp.LTS_Disable_Triggers__c = true;
        ltstemp.LTS_Disable_Validation_Rules__c = true;
        ltstemp.LTS_Disable_Workflow_Rules__c = true;
        ltstemp.Name = 'temp';
        ltstemp.SetupOwnerId = userinfo.getuserid();
        insert ltstemp;
        
        recordtype leadRt= [select id from recordtype where name ='GLI' and sobjecttype='Lead' limit 1];
        List<Lead> listlead = new List<Lead>();
        test.starttest();
        Lead TestLead1 = UnitTest.getLeadInstance();
        TestLead1.LeadSource='Customer Service'; 
        TestLead1 .RecordTypeId=leadRt.Id;      
        TestLead1.SAPAccountNumber__c = '98711';
        TestLead1.FirstName = 'Unit 786786';
        TestLead1.LastName = 'Tester1';
        TestLead1.Lead_Scoring_Combined__c = 'D2';
        TestLead1.Company = '786th floor';     
        TestLead1.is_GLI__c =true;
        TestLead1.Sales_Org__c='GLI';
        TestLead1.Status = 'Unworked';         
        TestLead1.Billing_Country__c='US';
        TestLead1.Description='Lead is created for GLI';
        listlead.add(TestLead1);
        
        if(listlead.size()>0){
            insert listlead;
        }
        
        Test.stoptest();
        
        
        
    } 
    
    @isTest static void method3() {       
        
        
        LTS_Disable_Application_Automation__c ltstemp = new LTS_Disable_Application_Automation__c();
        ltstemp.LTS_Disable_Process_Builders__c = false;
        ltstemp.LTS_Disable_Triggers__c = true;
        ltstemp.LTS_Disable_Validation_Rules__c = true;
        ltstemp.LTS_Disable_Workflow_Rules__c = true;
        ltstemp.Name = 'temp';
        ltstemp.SetupOwnerId = userinfo.getuserid();
        insert ltstemp;
        
        recordtype leadRt= [select id from recordtype where name ='GLI' and sobjecttype='Lead' limit 1];
        List<Lead> listlead = new List<Lead>();
        test.starttest();
        Lead TestLead1 = UnitTest.getLeadInstance();
        TestLead1.LeadSource='Customer Service'; 
        TestLead1 .RecordTypeId=leadRt.Id;      
        TestLead1.SAPAccountNumber__c = '98711';
        TestLead1.FirstName = 'Unit 786786';
        TestLead1.LastName = 'Tester1';
        TestLead1.TRWayLeadMgmt__Panorama_DQ_Reason__c = 'No Budget';
        TestLead1.Company = '786th floor 2 ';     
        TestLead1.is_GLI__c =true;
        TestLead1.Sales_Org__c='GLI';
        TestLead1.Status = 'Disqualified';         
        TestLead1.Billing_Country__c='US';
        TestLead1.Description='Lead is created for GLI';
        listlead.add(TestLead1);
        
        if(listlead.size()>0){
            insert listlead;
        }
        
        Test.stoptest();
        
        
        
    } 
    
    @isTest static void method4() {       
        
        
        LTS_Disable_Application_Automation__c ltstemp = new LTS_Disable_Application_Automation__c();
        ltstemp.LTS_Disable_Process_Builders__c = false;
        ltstemp.LTS_Disable_Triggers__c = true;
        ltstemp.LTS_Disable_Validation_Rules__c = true;
        ltstemp.LTS_Disable_Workflow_Rules__c = true;
        ltstemp.Name = 'temp';
        ltstemp.SetupOwnerId = userinfo.getuserid();
        insert ltstemp;
        
        recordtype leadRt= [select id from recordtype where name ='GLI' and sobjecttype='Lead' limit 1];
        List<Lead> listlead = new List<Lead>();
        test.starttest();
        Lead TestLead1 = UnitTest.getLeadInstance();
        TestLead1.LeadSource='Customer Service'; 
        TestLead1 .RecordTypeId=leadRt.Id;      
        TestLead1.SAPAccountNumber__c = '98711';
        TestLead1.FirstName = 'Unit 786786232';
        TestLead1.LastName = 'Tester1';
        TestLead1.Lead_Scoring_Combined__c = 'A1';
        TestLead1.Company = '786th floor';     
        TestLead1.is_GLI__c =true;
        TestLead1.Sales_Org__c='GLI';
        TestLead1.Status = 'Disqualified'; 
        TestLead1.TRWayLeadMgmt__Panorama_DQ_Reason__c = 'Invalid/Unsellable Account';
        TestLead1.Billing_Country__c='US';
        TestLead1.Description='Lead is created for GLI';
        listlead.add(TestLead1);
        
        if(listlead.size()>0){
            insert listlead;
        }
        
        Test.stoptest();
        
        
        
    } 
    
    //Process builder : Update_Lead_Stage_Field
    @isTest static void method5(){
        LTS_Disable_Application_Automation__c ltstemp = new LTS_Disable_Application_Automation__c();
        ltstemp.LTS_Disable_Process_Builders__c = false;
        ltstemp.LTS_Disable_Triggers__c = true;
        ltstemp.LTS_Disable_Validation_Rules__c = true;
        ltstemp.LTS_Disable_Workflow_Rules__c = true;
        ltstemp.Name = 'temp';
        ltstemp.SetupOwnerId = userinfo.getuserid();
        insert ltstemp;
        
        recordtype leadRt= [select id from recordtype where name ='GLI' and sobjecttype='Lead' limit 1];
        List<Lead> listlead = new List<Lead>();
        test.starttest();
        Lead TestLead1 = UnitTest.getLeadInstance();
        TestLead1.LeadSource='Customer Service'; 
        TestLead1 .RecordTypeId=leadRt.Id;      
        TestLead1.SAPAccountNumber__c = '98711';
        TestLead1.FirstName = 'Unit 786786';
        TestLead1.LastName = 'Tester1';
        TestLead1.Lead_Scoring_Combined__c = 'B4';
        TestLead1.Company = '786th floor';     
        TestLead1.is_GLI__c =true;
        TestLead1.Sales_Org__c='WEST';
        TestLead1.Status = 'Unworked';         
        TestLead1.Billing_Country__c='US';
        TestLead1.Description='Lead is created for GLI';
        listlead.add(TestLead1);
        
        if(listlead.size()>0){
            insert listlead;
        }
        
        Test.stoptest();
        
    }
    //Process builder : Update_Lead_Stage_Field
    @isTest static void method6(){
        LTS_Disable_Application_Automation__c ltstemp = new LTS_Disable_Application_Automation__c();
        ltstemp.LTS_Disable_Process_Builders__c = false;
        ltstemp.LTS_Disable_Triggers__c = true;
        ltstemp.LTS_Disable_Validation_Rules__c = true;
        ltstemp.LTS_Disable_Workflow_Rules__c = true;
        ltstemp.Name = 'temp';
        ltstemp.SetupOwnerId = userinfo.getuserid();
        insert ltstemp;
        
        recordtype leadRt= [select id from recordtype where name ='GLI' and sobjecttype='Lead' limit 1];
        List<Lead> listlead = new List<Lead>();
        test.starttest();
        Lead TestLead1 = UnitTest.getLeadInstance();
        TestLead1.LeadSource='Customer Service'; 
        TestLead1 .RecordTypeId=leadRt.Id;      
        TestLead1.SAPAccountNumber__c = '98711';
        TestLead1.FirstName = 'Unit 786786';
        TestLead1.LastName = 'Tester1';
        TestLead1.Lead_Scoring_Combined__c = 'A3';
        TestLead1.Company = '786th floor';     
        TestLead1.is_GLI__c =true;
        TestLead1.Sales_Org__c='WEST';
        TestLead1.Status = 'Unworked';         
        TestLead1.Billing_Country__c='US';
        TestLead1.Description='Lead is created for GLI';
        listlead.add(TestLead1);
        
        if(listlead.size()>0){
            insert listlead;
        }
        
        Test.stoptest();
        
    }
}