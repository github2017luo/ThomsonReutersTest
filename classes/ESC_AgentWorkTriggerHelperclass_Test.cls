@isTest
Public Class ESC_AgentWorkTriggerHelperclass_Test{

    static testmethod void ESC_AgentWork(){
    
    
            Account Acc1 = new Account();
            Contact Con = new Contact();
            Case cas=new Case();
            Case cas1=new Case();
                  Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 

            Acc1 = ESC_GenericTestutility.TestAccountUtil('test account', '12345','9876543210');
            insert Acc1;
            Con =ESC_GenericTestutility.TestContactUtil(Acc1.ID, 'test','contact','test7365@gmail.com');
            insert Con;
            cas = ESC_GenericTestutility.TestCaseUtil(Con.ID,Acc1.ID,'Work In Progress');
            cas.RecordtypeID=Schema.SObjectType.Case.getRecordTypeInfosByName().get('Incident').getRecordTypeId();
            insert cas;
            cas1 = ESC_GenericTestutility.TestCaseUtil(Con.ID,Acc1.ID,'new');
            cas.RecordtypeID=Schema.SObjectType.Case.getRecordTypeInfosByName().get('Incident').getRecordTypeId();
            insert cas1;
            /* Group g1 = new Group(Name='group name', type='Queue');
            insert g1;
            QueuesObject q1 = new QueueSObject(QueueID = g1.id, SobjectType = 'Case');
            insert q1;*/
        
    
            ID SChannelId= [SELECT Id FROM ServiceChannel Where DeveloperName='Case' Limit 1].Id;
                 
            list<AgentWork> AgentWorklist=new list<AgentWork>();
            AgentWork awork = new AgentWork();
            awork.WorkItemId = cas.id;
            awork.UserId = userinfo.getuserid();
            awork.ServiceChannelId=SChannelId;
            AgentWorklist.add(awork);
            insert AgentWorklist; 
            
             /*User u = new User(Alias = 'standt2', Email='sysadmin@2testorg.com', 
              EmailEncodingKey='UTF-8', LastName='Testing2', LanguageLocaleKey='en_US', 
              LocaleSidKey='en_US', ProfileId = p.Id,
              TimeZoneSidKey='America/Los_Angeles', UserName='sysadmin2@testorg.com');
              insert u;
            System.runAs(u){  
            awork.Status= 'ope';
            update awork;
            }*/
                
            ESC_AgentWorkTriggerHelperclass.ChangeStatusOfCases(AgentWorklist);
                update AgentWorklist; 

              }
    
}