/**
* Test class for the Controller "LCRMManageActivitiesCtrl".
*
* @author  Samarpreet
* @version  2019-03-18
*/

@IsTest(seeAllData=false)
public class LCRMManageActivitiesCtrl_test {
    
    static testmethod void mymethod(){
        recordtype accountRT = [select id from recordtype where name ='Prospect' and sobjecttype='Account' limit 1];
        Account testAccount = UnitTest.getAccountInstance();
        testAccount.Name = 'Parent Test Account ';
        testAccount.RecordTypeId=accountRT.Id;
        insert testAccount;
        
        Profile p1 = [SELECT Id FROM profile WHERE name='System Administrator' limit 1];   
        User u1 = new User(alias = 'newU912', email='news2E1995@mydomain.com', 
                           emailencodingkey='UTF-8', lastname='Tester', languagelocalekey='en_US', 
                           localesidkey='en_US', profileid = p1.Id, employeenumber='0144015',Infrequent_User__c=true,Infrequent_User_Timeout__c=2
                           , Sub_Bu__c = 'Elite',timezonesidkey='America/Los_Angeles', username='newsS2e195@mydomain.com',Rep_Type_Description__c='test');        
        insert u1;
        System.assertEquals(u1.email,'news2E1995@mydomain.com');
        
        system.runAs(u1){
            
            Task testTask= New Task();
            testTask.Subject='test';
            testTask.ActivityDate=system.today();
            testTask.whatid=testAccount.id;
            testTask.ownerid=u1.id;
            testTask.status='new';
            insert testTask;
            System.debug('@@@id:'+testTask.id);
            
            Event ev = new Event();
            ev.WhatId = testAccount.id;
            ev.Description = 'Event';
            ev.ShowAs = 'Busy';
            ev.Subject = 'Event';
            ev.StartDateTime=datetime.now();
            ev.EndDateTime=datetime.now();
            insert ev;
            
            ApexPages.StandardController controller= New ApexPages.StandardController (testTask);
            Test.setCurrentPageReference(Page.LCRMManageActivities);
            apexpages.currentpage().getparameters().put('IDs' , testTask.Id+','+ev.id);
            LCRMManageActivitiesCtrl obj= New  LCRMManageActivitiesCtrl();
            obj.getFunctionList();
            obj.retUrl='google.com';
            
            
            String theme=obj.getContextUserUiThemeDisplayed(); 
            
            Task testTask1= New Task();
            testTask1.Subject='test';
            testTask1.ActivityDate=system.today();
            testTask1.whatid=testAccount.id;
            testTask1.ownerid=u1.id;
            testTask1.status='new';
            obj.tempTask=testTask1;
            
            Event ev1 = new Event();
            ev1.WhatId = testAccount.id;
            ev1.Description = 'Event';
            ev1.ShowAs = 'Busy';
            ev1.Subject = 'Event';
            ev1.Status__c='Active';
            ev1.StartDateTime=datetime.now();
            ev1.EndDateTime=datetime.now();
            obj.tempEvent=ev1;
            
            obj.selFunction='Update Due Date';
            PageReference ref=obj.updateStatus();
            PageReference ref1=obj.updateDueDate();
            
            ApexPages.StandardController controller1= New ApexPages.StandardController (testTask);
            Test.setCurrentPageReference(Page.LCRMManageActivities);
            apexpages.currentpage().getparameters().put('IDs' , testTask.Id+','+ev.id);
            LCRMManageActivitiesCtrl obj1= New  LCRMManageActivitiesCtrl();
            PageReference ref2=obj1.updateStatus();
            PageReference ref3=obj1.updateDueDate();
            
        }    
    }
}