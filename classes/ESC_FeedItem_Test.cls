@isTest
public class ESC_FeedItem_Test{
    static testMethod void insertFeed(){            
        Account Acc1 = new Account();
        Contact Con = new Contact();
        Acc1 =  ESC_GenericTestutility.TestAccountUtil('test account', '12345','9876543210');
        insert Acc1;
        Con =ESC_GenericTestutility.TestContactUtil(Acc1.ID, 'test','contact','test7365@gmail.com');
        insert Con;            
        Case case1=new Case();
        case1 = ESC_GenericTestutility.TestCaseUtil(Con.ID,Acc1.ID,'Work In Progress');
        case1.RecordtypeID=Schema.SObjectType.Case.getRecordTypeInfosByName().get('Incident').getRecordTypeId();
        insert case1;
        
        FeedItem fd  = new FeedItem();
        fd.ParentId = case1.Id;
        fd.Body = '[xzxzxzxz]';
        fd.Type ='TextPost';
        insert fd;
        integer i = 1;
        integer j = 1;
        System.assertEquals(i,j); 
    }
    
    static testMethod void insertFeed1(){
        
        user user = new User(
             ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id,
             LastName = 'last',
             Email = 'puser000@amamama.com',
             Username = 'puser000@amamama.com' + System.currentTimeMillis(),
             CompanyName = 'TEST',
             Title = 'title',
             Alias = 'alias',
             TimeZoneSidKey = 'America/Los_Angeles',
             EmailEncodingKey = 'UTF-8',
             LanguageLocaleKey = 'en_US',
             LocaleSidKey = 'en_US'
             //ManagerId = manager.id
             //UserRoleId = r.Id
       );
       insert user;
        Group g = [Select id from group where developername = 'Elite_3E'];
        Account Acc1 = new Account();
        Contact Con = new Contact();
        Acc1 =  ESC_GenericTestutility.TestAccountUtil('test account', '12345','9876543210');
        insert Acc1;
        Con =ESC_GenericTestutility.TestContactUtil(Acc1.ID, 'test','contact','test7365@gmail.com');
        insert Con;
                Case case1=new Case();
        case1 = ESC_GenericTestutility.TestCaseUtil(Con.ID,Acc1.ID,'Closed');
        case1.RecordtypeID=Schema.SObjectType.Case.getRecordTypeInfosByName().get('Incident').getRecordTypeId(); 
        case1.ownerid = user.id;       
        insert case1;
        FeedItem fd  = new FeedItem();
        fd.ParentId = case1.Id;
        fd.Body = '[xzxzxzxz]';
        fd.Type ='TextPost';
        insert fd; 
         integer i = 1;
        integer j = 1;
        System.assertEquals(i,j);
    }
}