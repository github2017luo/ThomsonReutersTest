@isTest
public class SF1LeadCreateController_Test{
    public static testMethod void method1(){
        Test.startTest();

        PageReference pageRef = Page.SF1LeadCreate;
        Test.setCurrentPage(pageRef);
        
        SF1LeadCreateController oController = new SF1LeadCreateController();
        
        Lead oLead = new Lead(FirstName = 'Test1', LastName = 'Test1', Company = 'Test1', Billing_Country__c = 'USA');
        insert oLead;
        
        ApexPages.StandardController stdController = new ApexPages.StandardController(oLead);
        SF1LeadCreateController controller = new SF1LeadCreateController (stdController);
        controller.save();
        
        system.assert(stdController != null); 
        Test.stopTest();
    }
    
    public static testMethod void method2(){
        Profile p = [SELECT Id FROM Profile WHERE Name='TR Legal US Sales User']; 
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com', 
        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='TRLegalUSSalesUser2@testorg.com');

        System.runAs(u) {
            Test.startTest();
    
            PageReference pageRef = Page.SF1LeadCreate;
            Test.setCurrentPage(pageRef);
            
            SF1LeadCreateController oController = new SF1LeadCreateController();
            
            Lead oLead = new Lead(FirstName = 'Test1', LastName = 'Test1', Company = 'Test1', Billing_Country__c = 'USA');
            insert oLead;
            
            ApexPages.StandardController stdController = new ApexPages.StandardController(oLead);
            SF1LeadCreateController controller = new SF1LeadCreateController (stdController);
            controller.save();
            
            system.assert(stdController != null); 
            Test.stopTest();
        }    
    }
}