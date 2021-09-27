/**
* Test Class for 'Update_Tele_Interaction_field_for_BDR_SDR_GLI_records' Process Builder
*
*/

/**
* CHANGE HISTORY
* =============================================================================
* Date         Name                    Description
* 2020-07-20   Miriam Ghosh            Created     
* =============================================================================
*/

@isTest
public class UpdateTeleInteractionFieldBDRSDRGLI_Test {
    
    
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
        
         KeyValueListStore__c kValue1 = new KeyValueListStore__c();
         kValue1.Name ='ANZUsersProfileId';
         kValue1.TextValue__c = '01pK0000001JUbx';
         insert kValue1;
         
         RecordtypeIds__c rt = new RecordtypeIds__c(name = 'Pre-Pipeline Opportunities', recTypeId__c='01230000001MA4hAAG');
        insert rt;
        RecordtypeIds__c rt1 = new RecordtypeIds__c(name = 'Pipeline Opportunities', recTypeId__c='01230000001MA4gAAG');
        insert rt1;
        RecordtypeIds__c rt2 = new RecordtypeIds__c(name = 'LATAM Renewal Opportunity', recTypeId__c='01213000000AXGKAA4');
        insert rt2;
        RecordtypeIds__c rt3 = new RecordtypeIds__c(name = 'GLI Pipeline Opportunity', recTypeId__c='012e00000000wRJAAY');
        insert rt3;
 
}
    
    @isTest
    public static void UpdateTeleInteractionFieldBDRSDRGLI_Method1(){
        
        
        Profile p = [SELECT Id FROM profile WHERE name='System Administrator' limit 1];   
          User u1 = new User(alias = 'newUser', email='user@mydomain.com',
            emailencodingkey='UTF-8', lastname='userLTR', languagelocalekey='en_US', 
            localesidkey='en_US', profileid = p.Id, employeenumber='0144020', UserRoleId ='00E1B000001vLyQ',
            timezonesidkey='America/Los_Angeles', username='userLTR@mydomain.com.'+Math.random(),Rep_Type_Description__c='test',
            Sub_bu__c = 'US', Segment__c = 'Corporate');        
       insert u1;
        
        
        test.starttest();
        system.runas(u1){
        /*LTS_Disable_Application_Automation__c ltstemp = new LTS_Disable_Application_Automation__c();
        ltstemp.LTS_Disable_Process_Builders__c = false;
        ltstemp.LTS_Disable_Triggers__c = true;
        ltstemp.LTS_Disable_Validation_Rules__c = true;
        ltstemp.LTS_Disable_Workflow_Rules__c = true;
        ltstemp.Name = 'temp';
        ltstemp.SetupOwnerId = userinfo.getuserid();
        insert ltstemp;*/
        
        
        
        Account acc1 = new account();
        acc1.is_gli__c = true;
        acc1.name ='portal account 2';
        insert acc1 ;
        
        List<Lead> listlead = new List<Lead>();
        Lead TestLead1 = UnitTest.getLeadInstance();
        TestLead1.LeadSource='Customer Service'; 
        //TestLead1 .RecordTypeId=leadRt.Id;      
        TestLead1.SAPAccountNumber__c = '98711';
        TestLead1.FirstName = 'Unit 786786';
        TestLead1.LastName = 'Tester1';
        TestLead1.Lead_Scoring_Combined__c = 'B4';
        TestLead1.Company = 'TCS';     
        TestLead1.is_GLI__c =true;
        TestLead1.Sales_Org__c='GLI';
        TestLead1.Status = 'Unworked';         
        TestLead1.Billing_Country__c='US';
        TestLead1.Description='Lead is created for GLI';
        TestLead1.OwnerId = u1.id;
        TestLead1.LCRM_Sub_BU__c = 'USL';
        TestLead1.Account__c = acc1.id;
        listlead.add(TestLead1);
        
        if(listlead.size()>0){
            insert listlead;
        }
        }
        Test.stoptest();
       
        
    }
    
    @isTest
    public static void UpdateTeleInteractionFieldBDRSDRGLI_Method2(){
        
        
        Profile p = [SELECT Id FROM profile WHERE name='System Administrator' limit 1];   
          User u2 = new User(alias = 'newUser', email='user@mydomain.com',
            emailencodingkey='UTF-8', lastname='userLTR', languagelocalekey='en_US', 
            localesidkey='en_US', profileid = p.Id, employeenumber='0144020', UserRoleId ='00E13000001EJ1W',
            timezonesidkey='America/Los_Angeles', username='userLTR@mydomain.com.'+Math.random(),Rep_Type_Description__c='test',
            Sub_bu__c = 'US', Segment__c = 'Corporate');        
       insert u2;
        
        
        test.starttest();
        system.runas(u2){
        
        Account acc1 = new account();
        acc1.is_gli__c = true;
        acc1.name ='portal account 2';
        insert acc1 ;
        
        List<Lead> listlead = new List<Lead>();
        Lead TestLead2 = UnitTest.getLeadInstance();
        TestLead2.LeadSource='Customer Service'; 
        //TestLead1 .RecordTypeId=leadRt.Id;      
        TestLead2.SAPAccountNumber__c = '98711';
        TestLead2.FirstName = 'Unit 786786';
        TestLead2.LastName = 'Tester1';
        TestLead2.Lead_Scoring_Combined__c = 'B4';
        TestLead2.Company = 'TCS';     
        TestLead2.is_GLI__c =true;
        TestLead2.Sales_Org__c='GLI';
        TestLead2.Status = 'Unworked';         
        TestLead2.Billing_Country__c='US';
        TestLead2.Description='Lead is created for GLI';
        TestLead2.OwnerId = u2.id;
        TestLead2.LCRM_Sub_BU__c = 'USL';
        TestLead2.Account__c = acc1.id;
        listlead.add(TestLead2);
        
        if(listlead.size()>0){
            insert listlead;
        }
        }
        Test.stoptest();
       
        
    }
    
    @isTest
    public static void UpdateTeleInteractionFieldBDRSDRGLI_Method3(){
        
        
        Profile p = [SELECT Id FROM profile WHERE name='System Administrator' limit 1];   
          User u3 = new User(alias = 'newUser', email='user@mydomain.com',
            emailencodingkey='UTF-8', lastname='userLTR', languagelocalekey='en_US', 
            localesidkey='en_US', profileid = p.Id, employeenumber='0144020',
            timezonesidkey='America/Los_Angeles', username='userLTR@mydomain.com.'+Math.random(),Rep_Type_Description__c='test',
            Sub_bu__c = 'US', Segment__c = 'Corporate', BDR_SDR__c = 'BDR');        
       insert u3;
        
        
        test.starttest();
        system.runas(u3){
        
        Account acc1 = new account();
        acc1.is_gli__c = true;
        acc1.name ='portal account 2';
        insert acc1 ;
        
        List<Lead> listlead = new List<Lead>();
        Lead TestLead3 = UnitTest.getLeadInstance();
        TestLead3.LeadSource='Customer Service'; 
        //TestLead1 .RecordTypeId=leadRt.Id;      
        TestLead3.SAPAccountNumber__c = '98711';
        TestLead3.FirstName = 'Unit 786786';
        TestLead3.LastName = 'Tester1';
        TestLead3.Lead_Scoring_Combined__c = 'B4';
        TestLead3.Company = 'TCS';     
        TestLead3.is_GLI__c =true;
        TestLead3.Sales_Org__c='GLI';
        TestLead3.Status = 'Unworked';         
        TestLead3.Billing_Country__c='US';
        TestLead3.Description='Lead is created for GLI';
        TestLead3.OwnerId = u3.id;
        TestLead3.LCRM_Sub_BU__c = 'USL';
        TestLead3.Account__c = acc1.id;
        listlead.add(TestLead3);
        
        if(listlead.size()>0){
            insert listlead;
        }
        }
        Test.stoptest();
       
        
    }
    
    @isTest
    public static void UpdateTeleInteractionFieldBDRSDRGLI_Method4(){
        
        
        Profile p = [SELECT Id FROM profile WHERE name='System Administrator' limit 1];   
          User u4 = new User(alias = 'newUser', email='user@mydomain.com',
            emailencodingkey='UTF-8', lastname='userLTR', languagelocalekey='en_US', 
            localesidkey='en_US', profileid = p.Id, employeenumber='0144020', 
            timezonesidkey='America/Los_Angeles', username='userLTR@mydomain.com.'+Math.random(),Rep_Type_Description__c='test',
            Sub_bu__c = 'US', Segment__c = 'Corporate' );        
       insert u4;
        
        
        test.starttest();
        system.runas(u4){
        
        Account acc1 = new account();
        acc1.is_gli__c = true;
        acc1.name ='portal account 2';
        insert acc1 ;
        
        List<Lead> listlead = new List<Lead>();
        Lead TestLead4 = UnitTest.getLeadInstance();
        TestLead4.LeadSource='Customer Service'; 
        //TestLead1 .RecordTypeId=leadRt.Id;      
        TestLead4.SAPAccountNumber__c = '98711';
        TestLead4.FirstName = 'Unit 786786';
        TestLead4.LastName = 'Tester1';
        TestLead4.Lead_Scoring_Combined__c = 'B4';
        TestLead4.Company = 'TCS';     
        TestLead4.is_GLI__c =true;
        TestLead4.Sales_Org__c='GLI';
        TestLead4.Status = 'Unworked';         
        TestLead4.Billing_Country__c='US';
        TestLead4.Description='Lead is created for GLI';
        //TestLead4.OwnerId = u4.id;
        TestLead4.LCRM_Sub_BU__c = 'USL';
        TestLead4.Account__c = acc1.id;
        TestLead4.Tele_Interaction__c = '';
        listlead.add(TestLead4);
        
        if(listlead.size()>0){
            insert listlead;
        }
        }
        Test.stoptest();
       
        
    }



}