/**
* This is the test class for mass TE update class.
* @ Author: Anshita Sharma
* Last Modified: Sep 7, 2012
*/

@isTest
private class TestMassUpdateTEController
{
    public TestMassUpdateTEController()
    {
        
    }
    
    public static testMethod void testUpdateTE()
    {
        
        List<Training_Event__c> teLst = new List<Training_Event__c>(); 
        List<Training_Event__c> tevntlst = new List<Training_Event__c>(); 
        
        Account account = UnitTest.getAccountInstance();
        account.Name = 'testAccount';
        account.Customer_Type__c = 'Induvidual';
        account.Customer_Group__c = 'ACADEMIC';
        account.Industry = 'Energy';
        account.SAPAccountNumber__c = '1000550771';
        insert account;
        
        Contact contact = UnitTest.getContactInstance(account.Id);
        contact.LastName = 'testContact';
        contact.FirstName = 'testContact';
        insert contact;
        
        Training_Event__c tEvnt = new Training_Event__c();
        tEvnt.Training_Name__c = 'Test Training Event1';
        tEvnt.Training_Date__c = date.today();
        tEvnt.Status__c='Completed';
        tEvnt.Account__c =account.id;
       
        teLst.add(tEvnt); 
        
        Training_Event__c tEvnt1 = new Training_Event__c();
        tEvnt1.Training_Name__c = 'Test Training Event2';
        tEvnt1.Training_Date__c = date.today();
        tEvnt1.Status__c='Pending';
        tEvnt1.Account__c =account.id;
        
        
        teLst.add(tEvnt1); 
        
        insert teLst;
        
        ApexPages.StandardSetController con = new ApexPages.StandardSetController(teLst);
        con.setSelected(teLst);

        massUpdateTEController mu = new massUpdateTEController(con);     
                 
        Test.startTest();
       
        System.assertEquals(null, mu.Test());
        
        
        System.assertEquals('Update all Training Events', mu.getRadioOption());
        mu.setRadioOption('Update Individual Training Event');
        System.assertEquals('Update Individual Training Event', mu.getRadioOption());
        mu.setRadioOption('Update all Training Events');        
          
        System.assertEquals('/a0K', mu.saveTEvnts().getURL());        
        
       
        Test.stopTest();
        
        ApexPages.StandardSetController con1 = new ApexPages.StandardSetController(tevntlst);
        con1.setSelected(tevntlst);

        massUpdateTEController mu1 = new massUpdateTEController(con1);       
        

    }
    
   
   //Harika -Created as a part of CRM - 10860 for  code coverage
    public static testMethod void testUpdateTErolehireracy()
    {
    
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        UserRole ur = new UserRole(Name = 'USL Manager');
        insert ur ;
        
        UserRole ur1 = new UserRole(Name = 'USL Role 1',ParentRoleID =ur.Id);
        insert ur1 ;
         
        UserRole ur2 = new UserRole(Name = 'USL Role 2',ParentRoleID =ur1.Id);
        insert ur2 ;
        
        User u = new User(Alias = 'test', Email='testuser@thomsonreuters.com',EmailEncodingKey ='UTF-8', LastName ='Testing', LanguageLocaleKey='en_US',LocaleSidKey='en_US', ProfileId = p.Id,TimeZoneSidKey='America/Los_Angeles',UserName='testuser@trpcorelegal.com',UserRoleId = ur.Id);
        insert u;
        
        User u1 = new User(Alias = 'test1', Email='testuser@thomsonreuters.com',EmailEncodingKey ='UTF-8', LastName ='Testing1', LanguageLocaleKey='en_US',LocaleSidKey='en_US', ProfileId = p.Id,TimeZoneSidKey='America/Los_Angeles',UserName='testuser1@trpcorelegal.com',UserRoleId = ur1.Id,ManagerID = u.Id );
        insert u1;
       
        User u2 = new User(Alias = 'test2', Email='testuser@thomsonreuters.com',EmailEncodingKey='UTF-8', LastName ='Testing2', LanguageLocaleKey='en_US',LocaleSidKey='en_US', ProfileId = p.Id,TimeZoneSidKey='America/Los_Angeles',UserName='testuser2@trpcorelegal.com',UserRoleId = ur2.Id,ManagerID = u1.Id);
        insert u2;
        
        List<Training_Event__c> teLst = new List<Training_Event__c>(); 
        List<Training_Event__c> tevntlst = new List<Training_Event__c>(); 
        System.runAs(u)
         { 
        Account account = UnitTest.getAccountInstance();
        account.Name = 'testAccount';
        account.Customer_Type__c = 'Induvidual';
        account.Customer_Group__c = 'ACADEMIC';
        account.Industry = 'Energy';
        account.SAPAccountNumber__c = '1000550771';
        
        insert account;
        
        Contact contact = UnitTest.getContactInstance(account.Id);
        contact.LastName = 'testContact';
        contact.FirstName = 'testContact';
        insert contact;
        
        Training_Event__c tEvnt = new Training_Event__c();
        tEvnt.Training_Name__c = 'Test Training Event1';
        tEvnt.Training_Date__c = date.today();
        tEvnt.Status__c='Completed';
        tEvnt.Account__c =account.id;
        
        insert tEvnt;
       
        
        Training_Event__c tEvnt1 = new Training_Event__c();
        tEvnt1.Training_Name__c = 'Test Training Event2';
        tEvnt1.Training_Date__c = date.today();
        tEvnt1.Status__c='Pending';
        tEvnt1.Account__c =account.id;
        insert tEvnt1;
        
        Training_Event__c tEvnt2 = new Training_Event__c();
        tEvnt2 .Training_Name__c = 'Test Training Event2';
        tEvnt2 .Training_Date__c = date.today();
        tEvnt2 .Status__c='Completed';
        tEvnt2 .Account__c =account.id;
        insert tEvnt2;
       
        Test.startTest();
        ApexPages.StandardSetController con = new ApexPages.StandardSetController(teLst);
        con.setSelected(teLst);

        massUpdateTEController mu = new massUpdateTEController(con);
        mu.getMySelectedSize();
        mu.getEditSize();
        mu.getNonEditSize();
        mu.getEditList();
        mu.getNonEditList();     
        
        System.assertEquals('Update all Training Events', mu.getRadioOption());
        mu.setRadioOption('Update Individual Training Event');
        System.assertEquals('Update Individual Training Event', mu.getRadioOption());
        mu.setRadioOption('Update all Training Events');        
         
        System.assertEquals('/a0K', mu.saveTEvnts().getURL());        
        
        Test.stopTest();
          
       } 

    }
}