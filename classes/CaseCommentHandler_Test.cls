@isTest
public class CaseCommentHandler_Test {

/**
     * @description CaseCommentHelperextended
     
     */
    
    public static testMethod void testDataSetup(){
        
        recordtype accountRT = [select id from recordtype where name ='Prospect' and sobjecttype='Account' limit 1];
        recordtype caseRT = [select id from recordtype where name ='ANZ' and sobjecttype='Case' limit 1];
        
        
        Profile p1 = [SELECT Id FROM profile WHERE name='ANZ Users'];   
        User u1 = new User(alias = 'newUs89', email='news2E1995@mydomain.com', 
                           emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
                           localesidkey='en_US', profileid = p1.Id, employeenumber='0144020',Infrequent_User__c=true,Infrequent_User_Timeout__c=2
                           , Sub_Bu__c = 'Elite',timezonesidkey='America/Los_Angeles', username='newsS2e195@mydomain.com',Rep_Type_Description__c='test');        
        insert u1;
        System.assertEquals(u1.email,'news2E1995@mydomain.com','false');
        
        
        Account testAccount = UnitTest.getAccountInstance();
        testAccount.Name = 'Parent Test Account ';
        testAccount.RecordTypeId=accountRT.Id;
        insert testAccount;
        
        Case testCase = UnitTest.getCaseInstance();
        testCase.Subject = 'Testing CaseComment';
        testCase.Status = 'New';
        testCase.OwnerId = u1.Id;
        testCase.AccountID = testAccount.Id;
        testCase.RecordTypeId=caseRT.Id;
        testCase.Sales_Org__c='BKRS';
        testCase.Description=null;
        testCase.Priority='Low';
        testCase.Product__c='Print (Book)';
        insert testCase;
        
        EntitySubscription testSubcription=new EntitySubscription();
        testSubcription.ParentId=testCase.ID;
        testSubcription.SubscriberId=u1.ID; 
        insert testSubcription;
    
        Case testCase1 = UnitTest.getCaseInstance();
        testCase1.Subject = 'Testing CaseComment';
        testCase1.Status = 'New';
        testCase1.AccountID = testAccount.Id;
        testCase1.RecordTypeId=caseRT.Id;
        testCase1.Sales_Org__c='BKRS';
        testCase1.Priority='Low';
        testCase1.Product__c='Print (Book)';
        testCase1.OwnerId = u1.Id;
        insert testCase1;
        
        testCase1.Status='Open';
        testCase1.Description='testing';
        testCase1.Subject='Anz Case'; 
        testCase1.ParentId=testCase.id;
        update testCase1;   
        System.assertEquals(testCase1.Description, 'testing','false');  
        
        testCase1.Status='Open';
        testCase1.Description='testing';
        testCase1.Subject='Anz Case'; 
        testCase1.ParentId=testCase.id;
        update testCase1; 
        
        CaseComment testComment=new CaseComment();
        testComment.CommentBody='testing Anz Cases';
        testComment.ParentId= testCase.ID;  
        testComment.IsPublished=true;
        insert testComment;
        System.assertEquals(testComment.CommentBody, 'testing Anz Cases','false');
    
        EmailMessage email = new EmailMessage();
        email.FromAddress = 'test@abc.org';
        email.Incoming = True;
        email.ToAddress= 'test@xyz.org';
        email.Subject = 'Test email';
        email.HtmlBody = 'Test email body';
        email.ParentId = testCase.Id; 
        insert email;
        System.assertEquals(email.HtmlBody, 'Test email body','false');  
        
        EmailMessage email1 = new EmailMessage();
        email1.FromAddress = 'test@abc.org';
        email1.Incoming = False;
        email1.ToAddress= 'test@xyz.org';
        email1.Subject = 'Test email';
        email1.HtmlBody = 'Test email body';
        email1.ParentId = testCase.Id; 
        insert email1;
    }
}