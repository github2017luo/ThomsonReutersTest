/** 
 * @description :  test class for LOTUS_NewCaseFromOpportunityController
*/
@istest 
public class LOTUS_NewCaseFromOptyController_Test {
/** 
 * @description :  test class for LOTUS_NewCaseFromOpportunityController
*/
    public static testMethod void testController(){
        //LOTUS_NewCaseFromOpportunityController.classicTheme = true;
        UnitTest.createTestData();    
        Account testAcc1 = UnitTest.getAccountInstance();
        testAcc1.Is_GLI__c = true;
        insert testAcc1; 
        system.assertEquals(testAcc1.id!= null,true,'account inserted.');
        Contact con1= new contact(lastname='test',AccountId=testAcc1.Id,Firstname='test',email='te@te.com');
        Insert con1;
        
        Opportunity testOpty = UnitTest.getOpportunityInstance(testAcc1.id);
        testOpty.StageName = 'Contract Signed';
        testOpty.Reason__c = 'Caselines';
        testOpty.Is_GLI__c = true;
        insert testOpty;
        
        
        Case newPICase = new Case();

        newPICase.accountId = testAcc1.id;
        newPICase.ContactId = con1.id;
        newPICase.Opportunity__c = testOpty.id;
        newPICase.ESC_Issue__c = 'Professional Services';
        newPICase.ESC_Reason__c = 'Project Initiation';
        newPICase.Subject = 'Test 123';
        newPICase.Description = 'Test 12321';
        newPICase.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('ESC_Sales_Case').getRecordTypeId();
        newPICase.ESC_Product_Title__c  = 'Global Trade Management';
        newPICase.ESC_Product_Segment_Brand__c ='Risk';
        newPICase.LCRM_Sub_BU__c ='AEM';
        newPICase.BU_Segment__c ='Professional Tax';
        
        insert newPICase;
         List <LCRM_Opty_Case_Brand_Map__c> optycaselist = new List<LCRM_Opty_Case_Brand_Map__c>();
            LCRM_Opty_Case_Brand_Map__c optycase = new LCRM_Opty_Case_Brand_Map__c();
            optycase.Case_Issue__c='Professional Services';
            optycase.Case_Brand__c='CaseLines';
            optycase.Case_Reason__c ='SoW Pricing';
            optycase.Name='Caselines';
            optycaselist.add(optycase);
            LCRM_Opty_Case_Brand_Map__c optycase1 = new LCRM_Opty_Case_Brand_Map__c();
            optycase1.Case_Issue__c='Professional Services';
            optycase1.Case_Brand__c='Risk';
            optycase1.Case_Reason__c ='SoW Pricing';
            optycase1.Name='Risk';
            optycaselist.add(optycase1);            
            insert(optycaselist);
        
        Test.startTest(); 
        
        
        Profile p = [SELECT Id FROM profile WHERE name='TR Sales'];   
        User u1 = new User(alias = 'newUser1', email='user@mydomain.com', 
                           emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
                           localesidkey='en_US', profileid = p.Id, employeenumber='0144020',
                           timezonesidkey='America/Los_Angeles', username='u11@mydomain.com');        
        insert u1;
        
        Test.stopTest(); 
        
        System.Runas(u1){
            
        
           
            
            //PageReference pageRef = Page.LOTUS_NewCaseFromOpportunity;                    
            Test.setCurrentPageReference(Page.LOTUS_NewCaseFromOpportunity); 
            ApexPages.currentPage().getParameters().put('id', testOpty.id);      
            
            //ApexPages.standardController sc = new ApexPages.standardController(testOpty);
            LOTUS_NewCaseFromOpportunityController  testcntrller = new LOTUS_NewCaseFromOpportunityController(); 
            testcntrller.RedirectCase();
            LOTUS_NewCaseFromOpportunityController.getSowCases();
            LOTUS_NewCaseFromOpportunityController.CreateProjectInitiationCase(testOpty.id);
            
        }
    }
    /** 
 * @description :  test class for LOTUS_NewCaseFromOpportunityController
*/
    public static testMethod void testController2(){
        //LOTUS_NewCaseFromOpportunityController.lightningTheme = true;
        UnitTest.createTestData();    
        Account testAcc1 = UnitTest.getAccountInstance();
        testAcc1.Is_GLI__c = true;
        insert testAcc1; 
        system.assertEquals(testAcc1.id!= null,true,'Account inserted');
        Contact con1= new contact(lastname='test',AccountId=testAcc1.Id,Firstname='test',email='te@te.com');
        Insert con1;
        
        Opportunity testOpty = UnitTest.getOpportunityInstance(testAcc1.id);
        testOpty.StageName = 'Contract Signed';
        testOpty.Reason__c = 'Brand';
        testOpty.Is_GLI__c = true;
        insert testOpty;
        List <LCRM_Opty_Case_Brand_Map__c> optycaselist = new List<LCRM_Opty_Case_Brand_Map__c>();
        LCRM_Opty_Case_Brand_Map__c optycase = new LCRM_Opty_Case_Brand_Map__c();
        optycase.Case_Issue__c='Professional Services';
        optycase.Case_Brand__c='CaseLines';
        optycase.Case_Reason__c ='SoW Pricing';
        optycase.Name='Caselines';
        optycaselist.add(optycase);
        LCRM_Opty_Case_Brand_Map__c optycase1 = new LCRM_Opty_Case_Brand_Map__c();
        optycase1.Case_Issue__c='Professional Services';
        optycase1.Case_Brand__c='Risk';
        optycase1.Case_Reason__c ='SoW Pricing';
        optycase1.Name='Risk';
        optycaselist.add(optycase1);
        
        insert(optycaselist);
        
        Test.startTest(); 
        
        
        Profile p = [SELECT Id FROM profile WHERE name='TR Sales'];   
        User u1 = new User(alias = 'newUser1', email='user@mydomain.com', 
                           emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
                           localesidkey='en_US', profileid = p.Id, employeenumber='0144020',
                           timezonesidkey='America/Los_Angeles', username='us1211@mydomain.com');        
        insert u1;
        
        Test.stopTest(); 
        
        System.Runas(u1){
            
            
            
            //PageReference pageRef = Page.LOTUS_NewCaseFromOpportunity;                    
            Test.setCurrentPageReference(Page.LOTUS_NewCaseFromOpportunity); 
            ApexPages.currentPage().getParameters().put('id', testOpty.id);      
            
            //ApexPages.standardController sc = new ApexPages.standardController(testOpty);
            LOTUS_NewCaseFromOpportunityController  testcntrller = new LOTUS_NewCaseFromOpportunityController(); 
            testcntrller.RedirectCase();
            LOTUS_NewCaseFromOpportunityController.CreateProjectInitiationCase(testOpty.id);
            
        }
    }
    /** 
 * @description :  test class for LOTUS_NewCaseFromOpportunityController
*/
    public static testMethod void testController3(){
        
        //LOTUS_NewCaseFromOpportunityController.mobileTheme = true;
        UnitTest.createTestData();    
        Account testAcc1 = UnitTest.getAccountInstance();
        testAcc1.Is_GLI__c = true;
        insert testAcc1; 
        system.assertEquals(testAcc1.id!= null,true,'Account inserted');
        Contact con1= new contact(lastname='test',AccountId=testAcc1.Id,Firstname='test',email='te@te.com');
        Insert con1;
        
        Opportunity testOpty = UnitTest.getOpportunityInstance(testAcc1.id);
        testOpty.StageName = 'Contract Signed';
        testOpty.Reason__c = 'Brand';
        testOpty.Is_GLI__c = true;
        insert testOpty;
        
         List <LCRM_Opty_Case_Brand_Map__c> optycaselist = new List<LCRM_Opty_Case_Brand_Map__c>();
            LCRM_Opty_Case_Brand_Map__c optycase = new LCRM_Opty_Case_Brand_Map__c();
            optycase.Case_Issue__c='Professional Services';
            optycase.Case_Brand__c='CaseLines';
            optycase.Case_Reason__c ='SoW Pricing';
            optycase.Name='Caselines';
            optycaselist.add(optycase);
            LCRM_Opty_Case_Brand_Map__c optycase1 = new LCRM_Opty_Case_Brand_Map__c();
            optycase1.Case_Issue__c='Professional Services';
            optycase1.Case_Brand__c='Risk';
            optycase1.Case_Reason__c ='SoW Pricing';
            optycase1.Name='Risk';
            optycaselist.add(optycase1);            
            insert(optycaselist);
        
        Test.startTest(); 
        
        
        Profile p = [SELECT Id FROM profile WHERE name='TR Sales'];   
        User u1 = new User(alias = 'newUser1', email='user@mydomain.com', 
                           emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
                           localesidkey='en_US', profileid = p.Id, employeenumber='0144020',
                           timezonesidkey='America/Los_Angeles', username='INer11@mydomain.com');        
        insert u1;
        
        Test.stopTest(); 
        
        System.Runas(u1){
            
            
            
            //PageReference pageRef = Page.LOTUS_NewCaseFromOpportunity;                    
            Test.setCurrentPageReference(Page.LOTUS_NewCaseFromOpportunity); 
            ApexPages.currentPage().getParameters().put('id', testOpty.id);      
            
            //ApexPages.standardController sc = new ApexPages.standardController(testOpty);
            LOTUS_NewCaseFromOpportunityController  testcntrller = new LOTUS_NewCaseFromOpportunityController(); 
            testcntrller.RedirectCase();
            LOTUS_NewCaseFromOpportunityController.CreateProjectInitiationCase(testOpty.id);
            
        }
    }
    /** 
 * @description :  test method for LOTUS_NewCaseFromOpportunityController
*/
    public static testMethod void testController4(){
        //LOTUS_NewCaseFromOpportunityController.classicTheme = true;
        UnitTest.createTestData();    
        
        Account testAcc1 = UnitTest.getAccountInstance();
        testAcc1.Is_GLI__c = true;
        insert testAcc1; 
        system.assertEquals(testAcc1.id!= null,true,'Account inserted');
        Contact con1= new Contact(lastname='test',AccountId=testAcc1.Id,Firstname='test',email='te@te.com');
        Insert con1;
            
        Opportunity testOpty = UnitTest.getOpportunityInstance(testAcc1.id);
        testOpty.StageName = 'Contract Signed';
        testOpty.Reason__c = 'Brand';
        testOpty.Is_GLI__c = true;
        insert testOpty;
         List <LCRM_Opty_Case_Brand_Map__c> optycaselist = new List<LCRM_Opty_Case_Brand_Map__c>();
            LCRM_Opty_Case_Brand_Map__c optycase = new LCRM_Opty_Case_Brand_Map__c();
            optycase.Case_Issue__c='Professional Services';
            optycase.Case_Brand__c='CaseLines';
            optycase.Case_Reason__c ='SoW Pricing';
            optycase.Name='Caselines';
            optycaselist.add(optycase);
            LCRM_Opty_Case_Brand_Map__c optycase1 = new LCRM_Opty_Case_Brand_Map__c();
            optycase1.Case_Issue__c='Professional Services';
            optycase1.Case_Brand__c='Risk';
            optycase1.Case_Reason__c ='SoW Pricing';
            optycase1.Name='Risk';
            optycaselist.add(optycase1);            
            insert(optycaselist);
        
        Case newPICase = new Case();
    
        newPICase.ESC_Case_Sub_Type__c='Account Enquiry';
        newPICase.ESC_Case_Type__c = 'Enquiry';
        newPICase.accountId = testAcc1.id;
        newPICase.ContactId = con1.id;
        newPICase.Opportunity__c = testOpty.id;
        newPICase.ESC_Issue__c = 'Professional Services';
        newPICase.ESC_Reason__c = 'SoW Pricing';
        newPIcase.origin = 'phone';
        newPICase.Subject = 'Test 123';
        newPICase.Description = 'Test 12321';
        newPICase.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('ESC_Sales_Case').getRecordTypeId();
        newPICase.ESC_Product_Title__c  = 'Global Trade Management';
        newPICase.ESC_Product_Segment_Brand__c ='Risk';
        newPICase.LCRM_Sub_BU__c ='AEM';
        newPICase.BU_Segment__c ='Professional Tax';
        
        insert newPICase;
        
        Test.startTest(); 
        
        
        Profile p = [SELECT Id FROM profile WHERE name='TR Sales'];   
        User u1 = new User(alias = 'newUser1', email='user@mydomain.com', 
                           emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
                           localesidkey='en_US', profileid = p.Id, employeenumber='0144020',
                           timezonesidkey='America/Los_Angeles', username='uten11@mydomain.com',Sub_Bu__c = 'US',Segment__c = 'Professional Legal');        
        insert u1;
        
        Test.stopTest(); 
        
        System.Runas(u1){
       
            LTS_Disable_Application_Automation__c ltstemp = new LTS_Disable_Application_Automation__c();
            ltstemp.LTS_Disable_Process_Builders__c = true;
            ltstemp.LTS_Disable_Triggers__c = true;
            ltstemp.LTS_Disable_Validation_Rules__c = true;
            ltstemp.LTS_Disable_Workflow_Rules__c = true;
            ltstemp.Name = 'tempC4';
            ltstemp.SetupOwnerId = userinfo.getuserid();
            insert ltstemp;
            //PageReference pageRef = Page.LOTUS_NewCaseFromOpportunity;                    
            Test.setCurrentPageReference(Page.LOTUS_NewCaseFromOpportunity); 
            ApexPages.currentPage().getParameters().put('id', testOpty.id);      
            
            //ApexPages.standardController sc = new ApexPages.standardController(testOpty);
            LOTUS_NewCaseFromOpportunityController  testcntrller = new LOTUS_NewCaseFromOpportunityController(); 
            testcntrller.RedirectCase();
            LOTUS_NewCaseFromOpportunityController.CreateProjectInitiationCase(testOpty.id);
            
        }
    }
    

}