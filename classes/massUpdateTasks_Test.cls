/**
* Test class for the Controller "massUpdateTasks".
*
* @author  Sadasiva Banda
* @version  2013-07-08
*/
@IsTest(seeAllData=false)

class massUpdateTasks_Test{
    static testmethod void mymethod(){
        Lead l= New Lead();
        l.lastName='Test Lead';
        l.firstName='Test Lead';
        l.Company='Test Acc';
        l.Status='Unworked';
        Insert l;
        
        recordtype accountRT = [select id from recordtype where name ='Prospect' and sobjecttype='Account' limit 1];
        Account testAccount = UnitTest.getAccountInstance();
        testAccount.Name = 'Parent Test Account ';
        testAccount.RecordTypeId=accountRT.Id;
        insert testAccount;
        
        Profile p = [SELECT Id FROM profile WHERE name='System Administrator' limit 1];   
        User u = new User(alias = 'ne47012', email='news2E1995@mydomain.com', 
                          emailencodingkey='UTF-8', lastname='Tester', languagelocalekey='en_US', 
                          localesidkey='en_US', profileid = p.Id, employeenumber='0144015',Infrequent_User__c=true,Infrequent_User_Timeout__c=2
                          , Sub_Bu__c = 'Elite',timezonesidkey='America/Los_Angeles', username='newsS2e195@mydomain.com',Rep_Type_Description__c='test');        
        insert u;
        u.Business_Unit__c = 'GTM';
        
        update u;
        
        system.runAs(u){
            
            Task t= New Task();
            t.Subject='test';
            t.ActivityDate=system.today();
            t.whatid=testAccount.id;
            t.ownerid=u.id;
            insert t;
            ApexPages.StandardController controller= New ApexPages.StandardController (t);
            Test.setCurrentPageReference(Page.TasksMassUpdate);         
            apexpages.currentpage().getparameters().put('IDs' , t.Id);
            massUpdateTasks obj= New  massUpdateTasks(controller);
            massUpdateTasks obj1= New  massUpdateTasks();
            obj1.renderfun();
            obj1.selvalue='Update all Tasks';
            obj1.getItems();
            obj1.getTask();
            obj1.cancelBtn();
            PageReference pg= obj1.UpdateindualTasks();
            obj.renderfun();
            obj.selvalue='Update all Tasks';
            obj.getItems();
            obj.UpdateallTasks();
            obj.getTask();
            obj.renderfun();
            obj.next();
            obj.previous();
            
            
        }    
    }
    
    static testmethod void myMethodNew(){
        Lead l= New Lead();
        l.lastName='Test Lead';
        l.firstName='Test Lead';
        l.Company='Test Acc';
        l.Status='Unworked';
        Insert l;
        
        recordtype accountRT = [select id from recordtype where name ='Prospect' and sobjecttype='Account' limit 1];
        Account testAccount = UnitTest.getAccountInstance();
        testAccount.Name = 'Parent Test Account ';
        testAccount.RecordTypeId=accountRT.Id;
        insert testAccount;
        
        Profile p = [SELECT Id FROM profile WHERE name='System Administrator' limit 1];   
        User u = new User(alias = 'ne47012', email='news2E1995@mydomain.com', 
                          emailencodingkey='UTF-8', lastname='Tester', languagelocalekey='en_US', 
                          localesidkey='en_US', profileid = p.Id, employeenumber='0144015',Infrequent_User__c=true,Infrequent_User_Timeout__c=2
                          , Sub_Bu__c = 'Elite',timezonesidkey='America/Los_Angeles', username='newsS2e195@mydomain.com',Rep_Type_Description__c='test');        
        insert u;
        system.runAs(u){
            
            List<Task> task= New List<Task>();
            Task t = new Task();
            t.Subject='test';
            t.ActivityDate=system.today();
            t.whatid=testAccount.id;
            t.ownerid=u.id;
            task.add(t);
            
            Task t1 = new Task();
            t1.Subject='test1';
            t1.ActivityDate=system.today();
            t1.whatid=testAccount.id;
            t1.ownerid=u.id;
            task.add(t1);
            insert task;
            
            ApexPages.StandardController controller= New ApexPages.StandardController (t);
            Test.setCurrentPageReference(Page.TasksMassUpdate);
            apexpages.currentpage().getparameters().put('IDs' , t.Id);
            massUpdateTasks obj= New  massUpdateTasks(controller);
            massUpdateTasks obj1= New  massUpdateTasks();
            obj1.renderfun();
            obj1.selvalue='Update Individual Task';                    
            obj1.UpdateindualTasks();
            
            obj.renderfun();
            obj.selvalue='Update Individual Task';
            obj.getItems();
            
            obj.UpdateindualTasks();         
            obj.renderfun();        
            
            
        }   
    }
}