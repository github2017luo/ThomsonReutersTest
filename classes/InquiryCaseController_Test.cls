@istest
public class InquiryCaseController_Test {
    
    public static testMethod void testSaveDetailMethod() {
        //Method for evaluating the fisrt condition in the Class.
        Account acc = new Account(Name = 'Test');
        insert acc;
        
        Case caseRec = new Case(AccountId = acc.Id, CaseType__c = 'Award Timing', Case_Type_Detail__c = 'Bridge', Additional_Case_Type_Detail__c = 'BAR', Sales_Org__c = 'SSRL', Status ='New', Subject='Test', description = 'Test' );
        caseRec.Salesperson__c=userInfo.getUserID(); 
        
        
        KeyValueListStore__c testLcrmSUBBU = new KeyValueListStore__c();
        testLcrmSUBBU.Name = 'LCRMSubBuValues';
        testLcrmSUBBU.TextValue__c = 'abc';
        insert testLcrmSUBBU;
        
        KeyValueListStore__c testLcrmProfileName = new KeyValueListStore__c();
        testLcrmProfileName.Name = 'LCRMGLIProfileNames';
        testLcrmProfileName.TextValue__c = 'System Administrator';
        insert testLcrmProfileName;
        
        Attachment attachment = new Attachment(Name = 'Test.pdf', Body = Blob.Valueof('123'));
        attachment.OwnerId = userInfo.getUserID();
        attachment.ParentID = caseRec.id;
        
        test.StartTest();
        PageReference pageRef = Page.inquirycase;        
        Test.setCurrentPage(pageRef);
    	      
        ApexPages.StandardController sc = new ApexPages.StandardController(caseRec);
        InquiryCaseController Controller = new InquiryCaseController(sc);
        //System.CurrentPageReference().getParameters().put('retURL',acc.id);
        controller.ocase = caseRec;                                                           
        controller.attachment = attachment; 
        controller.sSapAcct = ' ';  
        controller.RegionalManager = '';
        controller.myAccountid = NULL;
        Controller.parentRecId = acc.Id;
        
        Controller.save();
        Controller.route();
        test.StopTest();
        
        system.assertEquals('Award Timing', caseRec.CaseType__c);
        system.assertEquals('Test.pdf', attachment.Name);
        
    }
    /*
     * Desc : The test class is used to check the functionality of populating the accountid from ssd for USL user
	*/
    @isTest
    public static void testPopulateAccountId(){
        Account acc = new Account(Name = 'Test');
        insert acc;
        
        List<Source_System_Detail__c> ListofSSD = new List<Source_System_Detail__c>();
        Source_System_Detail__c SSDwithSAPNo = new Source_System_Detail__c();
        SSDwithSAPNo.name ='SSD1_01';        
        SSDwithSAPNo.LCRM_Sales_org__c = 'WEST';
        SSDwithSAPNo.Source_System_Account_Number__c='1000000040';
        SSDwithSAPNo.Account_Name__c=acc.id;
        SSDwithSAPNo.Source_System_Name__c ='LCRMGLI';
        insert SSDwithSAPNo;
        
        Case caseRec = new Case(AccountId = acc.Id, CaseType__c = 'Award Timing', Case_Type_Detail__c = 'Bridge', Additional_Case_Type_Detail__c = 'BAR', Sales_Org__c = 'SSRL', Status ='New', Subject='Test', description = 'Test' );
        caseRec.Salesperson__c=userInfo.getUserID(); 
         Profile p = [SELECT Id FROM profile WHERE name='System Administrator'];
        User gliUser = new User(alias = 'GLIT', email='user@GLImydomain.com', 
                                emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
                                localesidkey='en_US', profileid = p.Id, employeenumber='0144020',
                                timezonesidkey='America/Los_Angeles', username=System.now().getTime() +'user@gli.com',Rep_Type_Description__c='test',
                                Sub_Bu__c = 'USL');        
        insert gliUser;
        
        KeyValueListStore__c testLcrmSUBBU = new KeyValueListStore__c();
        testLcrmSUBBU.Name = 'LCRMSubBuValues';
        testLcrmSUBBU.TextValue__c = 'USL';
        insert testLcrmSUBBU;
        
        KeyValueListStore__c testLcrmProfileName = new KeyValueListStore__c();
        testLcrmProfileName.Name = 'LCRMGLIProfileNames';
        testLcrmProfileName.TextValue__c = 'System Administrator';
        insert testLcrmProfileName;
        
        test.StartTest();
        system.runAs(gliUser){
            PageReference pageRef = Page.inquirycase;        
            Test.setCurrentPage(pageRef); 
            System.currentPageReference().getParameters().put('SAPAcct', '1000000040');  
            ApexPages.StandardController sc = new ApexPages.StandardController(caseRec);
            InquiryCaseController Controller = new InquiryCaseController(sc);
            //System.CurrentPageReference().getParameters().put('retURL',acc.id);
            controller.ocase = caseRec;                                                           
            //controller.attachment = attachment; 
            controller.sSapAcct = '1000000040';  
            controller.RegionalManager = '';
            controller.myAccountid = NULL;
            Controller.parentRecId = acc.Id;
            
            Controller.save();
            Controller.route();
            System.assertNotEquals(NULL, pageRef);
        }
        test.StopTest();
        
        
        
    }
    /*
     * Desc : The test class is used to check the functionality of populating the accountid from ssd for nonUSL user
	*/
    @isTest
    public static void  testPopulateAccountIdnotUSL(){
        Account acc = new Account(Name = 'Test',SAPAccountNumber__c='1000000040');
        insert acc;
        
        List<Source_System_Detail__c> ListofSSD = new List<Source_System_Detail__c>();
        Source_System_Detail__c SSDwithSAPNo = new Source_System_Detail__c();
        SSDwithSAPNo.name ='SSD1_01';        
        SSDwithSAPNo.LCRM_Sales_org__c = 'WEST';
        SSDwithSAPNo.Source_System_Account_Number__c='1000000040';
        SSDwithSAPNo.Account_Name__c=acc.id;
        SSDwithSAPNo.Source_System_Name__c ='LCRMGLI';
        insert SSDwithSAPNo;
        
        Case caseRec = new Case(AccountId = acc.Id, CaseType__c = 'Award Timing', Case_Type_Detail__c = 'Bridge', Additional_Case_Type_Detail__c = 'BAR', Sales_Org__c = 'SSRL', Status ='New', Subject='Test', description = 'Test' );
        caseRec.Salesperson__c=userInfo.getUserID(); 
         Profile p = [SELECT Id FROM profile WHERE name='UKI Users'];
        User gliUser = new User(alias = 'GLIT', email='user@GLImydomain.com', 
                                emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', Regional_Mgr__c = 'POMEROY, JOE',
                                localesidkey='en_US', profileid = p.Id, employeenumber='0144020',
                                timezonesidkey='America/Los_Angeles', username=System.now().getTime() +'user@gli.com',Rep_Type_Description__c='test',
                                Sub_Bu__c = 'NOT');        
        insert gliUser;
        
        KeyValueListStore__c testLcrmSUBBU = new KeyValueListStore__c();
        testLcrmSUBBU.Name = 'LCRMSubBuValues';
        testLcrmSUBBU.TextValue__c = 'USL';
        insert testLcrmSUBBU;
        
        KeyValueListStore__c testLcrmProfileName = new KeyValueListStore__c();
        testLcrmProfileName.Name = 'LCRMGLIProfileNames';
        testLcrmProfileName.TextValue__c = 'System Administrator';
        insert testLcrmProfileName;
        
        test.StartTest();
        system.runAs(gliUser){
            PageReference pageRef = Page.inquirycase;        
            Test.setCurrentPage(pageRef); 
            System.currentPageReference().getParameters().put('SAPAcct', '1000000040');  
            ApexPages.StandardController sc = new ApexPages.StandardController(caseRec);
            InquiryCaseController Controller = new InquiryCaseController(sc);
            //System.CurrentPageReference().getParameters().put('retURL',acc.id);
            controller.ocase = caseRec;                                                           
            //controller.attachment = attachment; 
            controller.sSapAcct = '1000000040';  
            controller.RegionalManager = '';
            controller.myAccountid = NULL;
            Controller.parentRecId = acc.Id;
            
            Controller.save();
            Controller.route();
            
            System.assertNotEquals(NULL, pageRef);
        }
        test.StopTest();
        
        
        
    }
}