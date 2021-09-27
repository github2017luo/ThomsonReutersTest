/*
======================================================================================================================
TEST CLASS NAME: AccountDetailController_Test
======================================================================================================================
PURPOSE:    Validates the functionality provided by the AccountDetailController class.

CHANGE HISTORY:
======================================================================================================================
  DATE                  NAME                           DESC

2017-03-31            Karthi                     Optimized the coverage as per JIRA STORY: PS0-1
======================================================================================================================
*/
@istest
Public with sharing class AccountDetailController_Test{
public static testMethod void testDetailController(){
    
     
     Profile p = [SELECT Id FROM profile WHERE name='System Administrator']; 
    
        User u1 = new User(alias = 'User_3', email='user@mydomain.com', 
        emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
        localesidkey='en_US', profileid = p.Id, employeenumber='0144020',Sub_Bu__c='USL',
        timezonesidkey='America/Los_Angeles', username='user_3@mydomain.com');        
        insert u1;
        
        
    Account testAcc1 = UnitTest.getAccountInstance();
    Account testAcc2 = UnitTest.getAccountInstance();
   // testAcc1.IsPartner = true;
    insert testAcc1;        
    insert testAcc2;
   
    Set<Id> accset = new Set<Id>();
    accset.add(testacc1.id);
    accset.add(testacc2.id);
    task oActivty = new task(whatid=testAcc2.id);
    insert oActivty;
     task oActivty2 = new task(whatid=testAcc2.id,ActivityDate=system.today(),status='Completed');
    insert oActivty2;  
    ApexPages.standardController sc = new ApexPages.standardController(testAcc2);
    Test.setCurrentPageReference(Page.AccountDetail);
    AccountDetailController cont = new AccountDetailController(sc);
    testAcc2.parentId= testAcc1.id;
    update testAcc2;        
    System.assertEquals(true,testAcc2.Id != null);

        Test.startTest();
        AccountDetailController.getOpenActivities(accset,20,True);
        AccountDetailController.getActivityHistories(accset,20,True);
        AccountDetailController.getTrainingEvents(accset,20);
        AccountDetailController.getContacts(accset,20);
        AccountDetailController.getOpportunities(accset,20);
        AccountDetailController.getChildAccountIds(testAcc1.Id);
        
        
        Test.stopTest();
        
    AccountTeamMember testAccTeam = new AccountTeamMember(AccountId=testAcc2.Id,UserId=u1.Id);
    AccountDetailController cont2 = new AccountDetailController(sc);
    
    cont2.relListName='contact';
    cont2.showMore();
    cont2.relListName='OnlineContact';
    cont2.showMore();
    //cont2.NewContactEdit();           
    cont2.relListName='BusinessContact';           
    cont2.showMore();
    cont2.relListName='Opportunity'  ;
    cont2.showMore();          
    cont2.relListName='OpenActivity' ;
    cont2.showMore();        
    cont2.relListName='ActivityHistory';
    cont2.showMore();
    cont2.goToList();
    cont2.relListName='TrainingEvents';
    cont2.showMore(); 
    cont2.relListName='AccountTeam';
    cont2.showMore(); 
    cont2.InConsoleView= true;
    cont2.onPageLoad();
    cont2.addsalesteam();
    cont2.delRowId = '0';
    cont2.deleteRow();
    cont2.promopassword();
    cont2.credential();
    cont2.incentivepassword();
    
}  
  public static testMethod void testonpageload(){  
     
     //Create portal account owner
    UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
    Profile profile1 = [Select Id from Profile where name = 'System Administrator'];
    User portalAccountOwner1 = new User(
        UserRoleId = portalRole.Id,
        ProfileId = profile1.Id,
        Username = System.now().getTime() + 'test2@test.com',
        Alias = 'batman',
        Email='bruce.wayne@wayneenterprises.com',
        EmailEncodingKey='UTF-8',
        Firstname='Bruce',
        Lastname='Wayne',
        LanguageLocaleKey='en_US',
        LocaleSidKey='en_US',
        TimeZoneSidKey='America/Chicago'
    );
    Database.insert(portalAccountOwner1);

    System.runas(portalAccountOwner1){
    //Create account
    Account portalAccount1 = new Account(
        Name = 'TestAccount',
        OwnerId = portalAccountOwner1.Id
    );
    Database.insert(portalAccount1);
        
    //Create contact
    Contact contact1 = new Contact(
        FirstName = 'Test',
        Lastname = 'McTesty',
        AccountId = portalAccount1.Id,
        Email = System.now().millisecond() + 'test@test.com'
    );
    Database.insert(contact1);
    
        
    //Create user
    Profile portalProfile = [SELECT Id FROM Profile WHERE Name ='Partner Portal User'];
   // UserRole portalRole1 = [Select Id From UserRole Where PortalType = 'Partner' Limit 1];
        User user1 = new User(
        Username = System.now().getTime() + 'test12345@test.com', //  UserRoleId = portalRole1.Id,
        ContactId = contact1.Id,
        ProfileId = portalProfile.Id,
        Alias = 'test123',
        Email = 'test12345@test.com',
        EmailEncodingKey = 'UTF-8',
        LastName = 'McTesty',
        CommunityNickname = 'test12345',
        TimeZoneSidKey = 'America/Los_Angeles',
        LocaleSidKey = 'en_US',
        LanguageLocaleKey = 'en_US'
    );
    Database.insert(user1);
    System.assertEquals(true,user1.Id != null);
    //Reservation__c res = new Reservation__c(start_date__c = System.today(),End_Date__c=System.today().adddays(7),Active__C=True,Partner_Portal_User__c = user1.Id,Account__c=portalAccount1.Id);
    //Database.insert(res);
     

    System.runas(user1){
     Test.startTest();
     PageReference pageRef = Page.AccountDetail;
     Test.setCurrentPage(pageRef);
     ApexPages.standardController sc = new ApexPages.standardController(portalAccount1);
    // AccountTeamMember testAccTeam1 = new AccountTeamMember(AccountId=portalAccount1.Id,UserId=user1.Id);
     AccountDetailController cont3 = new AccountDetailController(sc);
     cont3.getCusReltdLst();
     cont3.getAccountTeamViews();
     cont3.FliterAccountteam();   
     cont3.onPageLoad();
     //res.Active__C=False;
     //Database.update(res);
     cont3.onPageLoad();
     
     test.Stoptest();
    }
    }                
}
    
    public static testmethod void mockupsec(){
        List<LCRMMockupButton__c> reclist = new List<LCRMMockupButton__c>();

        
        Profile testprofile = [SELECT Id FROM Profile WHERE Name = 'GLI Sales User' limit 1];
        User testUser1 = new User(
            Alias = 'sUser',
            Email = 'abc1@testorg.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'Testing',
            LanguageLocaleKey = 'es',
            LocaleSidKey = 'es',
            ProfileId = testprofile.id,
            Sales_Org__c = 'WEST',
            Sub_Bu__c = 'USL',
            TimeZoneSidKey = 'America/Los_Angeles',
            UserName = 'abc123@testorg.com'
        );
        
         Account testAcc1 = new Account();
            testAcc1 = UnitTest.getAccountInstance();
            testAcc1.SAPAccountNumber__c = '5491';
            insert testAcc1;
        System.assertEquals(true,testAcc1.Id != null);
        System.runAs(testUser1){
            Test.startTest();
            PageReference pageRef = Page.AccountDetail;
         Test.setCurrentPage(pageRef);
            ApexPages.standardController sc = new ApexPages.standardController(testAcc1);
           AccountDetailController cont3 = new AccountDetailController(sc);
            Test.stopTest();
        }
    }
}