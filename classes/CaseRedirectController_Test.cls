@istest
public class CaseRedirectController_Test {
    
    public static testMethod void testRedirectMethod() {
        //Method for evaluating the fisrt condition in the Class.
        list<Case> caseList = new list<Case>();
        Account acc = new Account(Name='Test');
        insert acc;
        Case caseRec = new Case(AccountId= acc.Id, CaseType__c = 'Award Timing', Case_Type_Detail__c = 'Bridge', Additional_Case_Type_Detail__c = 'BAR', Sales_Org__c = 'SSRL', Status ='New', Subject='Test', description = 'Test' );
        caseRec.Salesperson__c=userInfo.getUserID(); 
        caseList.add(caseRec);
        
        Profile p = [SELECT Id FROM Profile WHERE Name='ANZ Users']; 
        User usr = [Select Id FROM User WHERE ProfileId =:p.Id AND IsActive=TRUE LIMIT 1];
        Id rtId = [SELECT Id,Name FROM RecordType WHERE Name = 'Findlaw Inquiry'].Id;    
        
        System.runas(usr){
        test.StartTest();
            PageReference pageRef = Page.CaseRedirect;        
            Test.setCurrentPage(pageRef);        
            ApexPages.StandardSetController sc = new ApexPages.StandardSetController(caseList);
            System.CurrentPageReference().getParameters().put('id',acc.id);
           
            CaseRedirectController Controller = new CaseRedirectController(sc);
            Controller.setselectedRtype(rtId);
            Controller.getselectedRtype();
            controller.getItems();
            Controller.redirectToPage();
            Controller.redirectToANZrecordtype();
        test.StopTest();
        
        system.assertEquals('Award Timing', caseRec.CaseType__c);
        
      }  
    } 
    
    public static testMethod void testContactIDpassMethod() {
        //Method for evaluating the fisrt condition in the Class.
        list<Case> caseList = new list<Case>();
        Account acc = new Account(Name='Test');
        insert acc;
        Contact cont = new Contact(LastName = 'Sreenu', FirstName ='D');
        insert cont; 
        Case caseRec = new Case(CaseType__c = 'Award Timing', Case_Type_Detail__c = 'Bridge', Additional_Case_Type_Detail__c = 'BAR', Sales_Org__c = 'SSRL', Status ='New', Subject='Test', description = 'Test' );
        caseRec.Salesperson__c=userInfo.getUserID(); 
        caseList.add(caseRec);
        Profile p = [SELECT Id FROM Profile WHERE Name='ANZ Users']; 
        User usr = [Select Id FROM User WHERE ProfileId =:p.Id AND IsActive=TRUE LIMIT 1];
        Id rtId = [SELECT Id,Name FROM RecordType WHERE Name = 'ANZ'].Id; 
        
        System.runas(usr){   
        test.StartTest();
            PageReference pageRef = Page.CaseRedirect;        
            Test.setCurrentPage(pageRef);        
            ApexPages.StandardSetController sc = new ApexPages.StandardSetController(caseList);
            System.CurrentPageReference().getParameters().put('id',cont.Id );
           
            CaseRedirectController Controller = new CaseRedirectController(sc);
            Controller.setselectedRtype(rtId);
            Controller.getselectedRtype();
            controller.getItems();
            Controller.redirectToPage();
            Controller.redirectToANZrecordtype();
        test.StopTest();
        
        system.assertEquals('Award Timing', caseRec.CaseType__c);
       }
    } 
    
    
    public static testMethod void testRedirectMethodwoacc() {
        //Method for evaluating the fisrt condition in the Class.
        list<Case> caseList = new list<Case>();              
        Case caseRec = new Case(CaseType__c = 'Award Timing', Case_Type_Detail__c = 'Bridge', Additional_Case_Type_Detail__c = 'BAR', Sales_Org__c = 'SSRL', Status ='New', Subject='Test', description = 'Test' );
        caseRec.Salesperson__c=userInfo.getUserID(); 
        caseList.add(caseRec);
        Profile p = [SELECT Id FROM Profile WHERE Name='ANZ Users']; 
        User usr = [Select Id FROM User WHERE ProfileId =:p.Id AND IsActive=TRUE LIMIT 1];
        Id rtId = [SELECT Id,Name FROM RecordType WHERE Name = 'WPD'].Id;    
        
        System.runas(usr){
        test.StartTest();
            PageReference pageRef = Page.CaseRedirect;        
            Test.setCurrentPage(pageRef);        
            ApexPages.StandardSetController sc = new ApexPages.StandardSetController(caseList);
            System.CurrentPageReference().getParameters().put('id',NULL);
           
            CaseRedirectController Controller = new CaseRedirectController(sc);
            Controller.setselectedRtype(rtId);
            Controller.getselectedRtype();
            controller.getItems();
            Controller.redirectToPage();
            Controller.redirectToANZrecordtype();
        test.StopTest();
        
        system.assertEquals('Award Timing', caseRec.CaseType__c);
        
      }  
    } 
   public static testMethod void testRedirectconstr() {
       CaseRedirectController Controller = new CaseRedirectController();
       list<Case> caseList = new list<Case>();              
       Case caseRec = new Case(CaseType__c = 'Award Timing', Case_Type_Detail__c = 'Bridge', Additional_Case_Type_Detail__c = 'BAR', Sales_Org__c = 'SSRL', Status ='New', Subject='Test', description = 'Test' );
       caseRec.Salesperson__c=userInfo.getUserID(); 
       caseList.add(caseRec);
       Profile p = [SELECT Id FROM Profile WHERE Name='ANZ Users']; 
       User usr = [Select Id FROM User WHERE ProfileId =:p.Id AND IsActive=TRUE LIMIT 1];
       Id rtId = [SELECT Id,Name FROM RecordType WHERE Name = 'Archive Requests'].Id;
       
       System.runas(usr){    
       test.StartTest();
           PageReference pageRef = Page.CaseRedirect;        
           Test.setCurrentPage(pageRef);        
           ApexPages.StandardSetController sc = new ApexPages.StandardSetController(caseList);
           System.CurrentPageReference().getParameters().put('id',NULL);
           Controller.setselectedRtype(rtId);
           Controller.getselectedRtype();
           controller.getItems();
           Controller.redirectToPage();
           
        test.StopTest();
      }
   }
}