@isTest
   private class ESC_EliteContactNoUpdateCtlr_Test {
   
   @IsTest(SeeAllData=false) static void testmMthod1() {
    UserRole userrole = [Select Id, DeveloperName From UserRole Where DeveloperName = 'GLI' Limit 1];
    Profile testprofile = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User testUser = new User(
            Alias = 'oslfu',
            Email = 'testslcccf@testorg.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'Testing',
            LanguageLocaleKey = 'es',
            LocaleSidKey = 'es',
            ProfileId = testprofile.id,
            Sales_Org__c = 'WEST',
            Sub_Bu__c = 'USL',
            TimeZoneSidKey = 'America/Los_Angeles',
            UserName = 'testslcccf@testorg.com'
        );
        insert testUser;
    testUser.UserRoleId = userRole.Id;
    update testUser;
    system.assertEquals(testUser.UserRoleId,userRole.Id);
    system.runAs(testUser){
    
    Id p = [select id from profile where name='TR Customer Community Service'].id;
        test.startTest();
        Account testAccount = ESC_GenericTestutility.TestAccountUtil('TestAccount' ,'TestAccount001','7786864710');  
      testAccount.Software_Account_Attributes__c='Medium';
     insert testAccount;
     
     
     Contact testContact = ESC_GenericTestutility.TestContactUtil(testAccount.id ,'Mile','test@tr.com');
     testcontact.firstname='testfirst';
     insert testContact;
     
     ESC_Create_Contact_Number__c conNum = new ESC_Create_Contact_Number__c();
     conNum.Name='Contact Number';
      conNum.ESC_Contact_Number__c = '200001';
      insert conNum;
      test.stopTest();
      User testUser1 = new User(
            Alias = 'oslfu',
            Email = 'testslcccf@testorg1.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'Testing',
            LanguageLocaleKey = 'es',
            LocaleSidKey = 'es',
            ProfileId = p,
            Sales_Org__c = 'WEST',
            Sub_Bu__c = 'USL',
            contactid =testcontact.id,
            TimeZoneSidKey = 'America/Los_Angeles',
            UserName = 'testslcccf@testorg1.com'
        );
        insert testUser1;
        system.assertEquals(testUser1.ProfileId,p);
    ApexPages.StandardController sc = new ApexPages.StandardController(testContact);
    PageReference pageRef = Page.ESC_EliteContactNoUpdatePage; // Add your VF page Name here
  pageRef.getParameters().put('id', String.valueOf(testContact.Id));
  Test.setCurrentPage(pageRef);
    ESC_EliteContactNoUpdateCtlr conUpdate = new ESC_EliteContactNoUpdateCtlr(sc);
    
    conUpdate.updateNum();
    }
    
    
      
    }
    
    @IsTest(SeeAllData=false) static void testmMthod2() {
    UserRole userrole = [Select Id, DeveloperName From UserRole Where DeveloperName = 'GLI' Limit 1];
    Profile testprofile = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User testUser = new User(
            Alias = 'oslfu',
            Email = 'testslcccf@testorg.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'Testing',
            LanguageLocaleKey = 'es',
            LocaleSidKey = 'es',
            ProfileId = testprofile.id,
            Sales_Org__c = 'WEST',
            Sub_Bu__c = 'USL',
            TimeZoneSidKey = 'America/Los_Angeles',
            UserName = 'testslcccf@testorg.com'
        );
        insert testUser;
    testUser.UserRoleId = userRole.Id;
    update testUser;
    system.runAs(testUser){
    
    Id p = [select id from profile where name='TR Customer Community Service'].id;
        test.startTest();
        Account testAccount = ESC_GenericTestutility.TestAccountUtil('TestAccount' ,'TestAccount001','7786864710');  
      testAccount.Software_Account_Attributes__c='Medium';
     insert testAccount;
     
     
     Contact testContact = ESC_GenericTestutility.TestContactUtil(testAccount.id ,'Mile','test@tr.com');
     testcontact.firstname='testfirst';
     testcontact.ESC_Contact_Number__c = '200002';
     insert testContact;
     system.assertEquals(testcontact.ESC_Contact_Number__c,'200002');
     ESC_Create_Contact_Number__c conNum = new ESC_Create_Contact_Number__c();
     conNum.Name='Contact Number';
      conNum.ESC_Contact_Number__c = '200001';
      insert conNum;
      test.stopTest();
      User testUser1 = new User(
            Alias = 'oslfu',
            Email = 'testslcccf@testorg1.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'Testing',
            LanguageLocaleKey = 'es',
            LocaleSidKey = 'es',
            ProfileId = p,
            Sales_Org__c = 'WEST',
            Sub_Bu__c = 'USL',
            contactid =testcontact.id,
            TimeZoneSidKey = 'America/Los_Angeles',
            UserName = 'testslcccf@testorg1.com'
        );
        insert testUser1;
        
    ApexPages.StandardController sc = new ApexPages.StandardController(testContact);
    PageReference pageRef = Page.ESC_EliteContactNoUpdatePage; // Add your VF page Name here
  pageRef.getParameters().put('id', String.valueOf(testContact.Id));
  Test.setCurrentPage(pageRef);
    ESC_EliteContactNoUpdateCtlr conUpdate = new ESC_EliteContactNoUpdateCtlr(sc);
    
    conUpdate.updateNum();
    }
    
    
      
    }
    
    }