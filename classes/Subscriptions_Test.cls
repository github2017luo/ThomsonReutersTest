/*
======================================================================================================================
TEST CLASS NAME: Subscriptions_Test
======================================================================================================================
=
PURPOSE: Validates the functionality provided by the Subscriptions class.

CHANGE HISTORY:
======================================================================================================================
DATE             NAME           DESC
31/03/2017       Gunaseelan K   Optimized the code as per JIRA STORY: PS0-1

======================================================================================================================
*/
@istest (SeeAllData=false)
public with sharing class Subscriptions_Test{

    // testMethod for the controller

    private static testMethod void testController(){
        
        
        Account testAcc1 = UnitTest.getAccountInstance();
        testAcc1.sapAccountNumber__C = '512345';
        testAcc1.CompanyCodeDescription__c = '0010';
        testAcc1.Sales_Org__c = 'WEST';
        testAcc1.DistributionChannel__c = 'W';
        testAcc1.DivisionCodeDescription__c = 'W';
        testAcc1.parentid =null;
        testAcc1.Account_Indicator__c='Branch';
        insert testAcc1;
        Account testAcc2 = UnitTest.getAccountInstance();
        testAcc2.parentid = testAcc1.id;   
        insert testacc2;
        
      
        SubscriptionSortByField__c customSettingsSortByFields = new SubscriptionSortByField__c();
        customSettingsSortByFields.name = 'Details2';
        customSettingsSortByFields.Sort_By__c = 'ProgramDiscountDesc';
        customSettingsSortByFields.Portuguese__c='sidufh';
        customSettingsSortByFields.Spanish__c='siduh';
        insert customSettingsSortByFields; 
         
        SubscriptionServices.SubsRequest oRequest = new SubscriptionServices.SubsRequest();
      
        oRequest.SystemId = 'SFDC CORE LEGAL'; 
        oRequest.AcctSAPId = new List<decimal>();
        oRequest.AcctSAPId.add(Decimal.valueOf('512345'));
        oRequest.CompanyCode = 'test';
        oRequest.SalesOrgCode = 'Online';
        oRequest.DistChanCode = 'test1';
        oRequest.DivisionCode = 'test3';
        oRequest.IncludeActiveSubs=true;
        oRequest.IncludeLapsedSubs=true;
        oRequest.MaxResults = 250;
        oRequest.SubType='ALL';  
        
        
        Profile testProfile = [SELECT Id 
                           FROM profile
                           WHERE Name = 'System Administrator' 
                           LIMIT 1];

    User testUser = new User(LastName = 'test user 1', 
                             Username = 'test.user.1@example.com', 
                             Email = 'test.1@example.com', 
                             Alias = 'testu1', 
                             TimeZoneSidKey = 'GMT', 
                             LocaleSidKey = 'en_GB', 
                             EmailEncodingKey = 'ISO-8859-1', 
                             ProfileId = testProfile.Id, 
                             LanguageLocaleKey = 'pt_BR');   
     System.runas(testUser)
       {
        Test.startTest();
        
        ApexPages.standardController sc = new ApexPages.standardController(testAcc1);
        Test.setCurrentPageReference(Page.subscriptions);
        subscriptions controller = new subscriptions(sc);        
        
        SubscriptionsWSObject.SubItem oMockSubItem = new SubscriptionsWSObject.SubItem();
        oMockSubItem.SubKey = '63828958070142803';
        
       // SubscriptionServices.Subitem testSubItem = new SubscriptionServices.Subitem();   
        string subsId=Page.subscriptions.getParameters().get('subsId');
         subsId = '63828958070142803';
        
        Subscriptions.PagingSubscriptions pgSubs = new Subscriptions.PagingSubscriptions();
    

        controller.sSelectedOption = 'All Active';
        List<selectOption> options =  Controller.sortSubscriptionByfield;
        controller.getSubscriptionListOptions();
        controller.DisplaySubsList();
        controller.displayDetail();
       // controller.subsId='63828958070142803';
        controller.displaySubUserItem();
        controller.getSortByOrder();
        controller.sortSubscription();
        controller.getWPDsubscriptionList();
        
        User testUser1 = new User(LastName = 'test user 1', 
                             Username = 'test.user1.1@example.com', 
                             Email = 'test.1@example.com', 
                             Alias = 'testu1', 
                             TimeZoneSidKey = 'GMT', 
                             LocaleSidKey = 'en_GB', 
                             EmailEncodingKey = 'ISO-8859-1', 
                             ProfileId = testProfile.Id, 
                             LanguageLocaleKey = 'es');
        
        System.runas(testuser1){
        ApexPages.standardController sc1 = new ApexPages.standardController(testAcc1);
        Test.setCurrentPageReference(Page.subscriptions);
        subscriptions controller1 = new subscriptions(sc1); 
        
        List<selectOption> options1 =  Controller1.sortSubscriptionByfield;
        controller1.getSortByOrder();
        controller1.getSubscriptionListOptions();
        }
         User testUser2 = new User(LastName = 'test user 1', 
                             Username = 'test.user2.1@example.com', 
                             Email = 'test.1@example.com', 
                             Alias = 'testu1', 
                             TimeZoneSidKey = 'GMT', 
                             LocaleSidKey = 'en_GB', 
                             EmailEncodingKey = 'ISO-8859-1', 
                             ProfileId = testProfile.Id, 
                             LanguageLocaleKey = 'en_US');
        
        System.runas(testuser2){
        ApexPages.standardController sc2 = new ApexPages.standardController(testAcc1);
        Test.setCurrentPageReference(Page.subscriptions);
        subscriptions controller2 = new subscriptions(sc2); 
        
        List<selectOption> options2 =  Controller2.sortSubscriptionByfield;
        controller2.getSortByOrder();
        controller2.getSubscriptionListOptions();
        }
          Test.stopTest();
          
       }

       
          
         
        } 
        // testMethod for the paging
         
        private static testMethod void testpaging(){
        Subscriptions.PagingSubscriptions pgSubs = new Subscriptions.PagingSubscriptions();
   
        pgSubs.Pagesize = 2;
        pgSubs.pagenumber=10;
       
        pgSubs.oRequest = new SubscriptionServices.SubsRequest();
        pgSubs.oRequest.SystemId = 'SFDC CORE LEGAL'; 
        pgSubs.oRequest.AcctSAPId = new List<decimal>();
        pgSubs.oRequest.AcctSAPId.add(Decimal.valueOf('512345'));
        pgSubs.oRequest.CompanyCode = 'test';
        pgSubs.oRequest.SalesOrgCode = 'online';
        pgSubs.oRequest.DistChanCode = 'test';
        pgSubs.oRequest.DivisionCode = 'test';
        pgSubs.oRequest.IncludeActiveSubs=true;
        pgSubs.oRequest.IncludeLapsedSubs=true;
        pgSubs.oRequest.MaxResults = 5;
        pgSubs.oRequest.SubType='ALL'; 
        pgSubs.getSubscriptions();
        pgsubs.getrecordcount();
        
       
       IXOSCodeMap__c oIXOSCodeMap = IXOSCodeMap__c.getinstance();
       
      
       
        Test.startTest(); 
        pgsubs.movenext();
        pgsubs.moveFirst();
        pgsubs.moveLast();
        pgsubs.moveprev();
        
        Test.stopTest();
        
        }  
        
        static testMethod void testSelectedSubsOption(){
            
             
        Profile testProfile = [SELECT Id 
                           FROM profile
                           WHERE Name = 'System Administrator' 
                           LIMIT 1];

    User testUser = new User(LastName = 'test user 1', 
                             Username = 'test.user.1@example.com', 
                             Email = 'test.1@example.com', 
                             Alias = 'testu1', 
                             TimeZoneSidKey = 'GMT', 
                             LocaleSidKey = 'en_GB', 
                             EmailEncodingKey = 'ISO-8859-1', 
                             ProfileId = testProfile.Id, 
                             LanguageLocaleKey = 'pt_BR');   
     System.runas(testUser)
       {
           
            Account testAcc1 = UnitTest.getAccountInstance();
            ApexPages.standardController sc = new ApexPages.standardController(testAcc1);
            Test.setCurrentPageReference(Page.subscriptions);  
            subscriptions controller = new subscriptions(sc); 
            
            controller.sSelectedOption = 'All Lapsed';
            controller.DisplaySubsList();
            
            controller.sSelectedOption = 'All Active';
            controller.DisplaySubsList();
            
            controller.sSelectedOption = 'Online';
            controller.DisplaySubsList();
            
            controller.sSelectedOption = 'FindLaw';
            controller.DisplaySubsList();
            
            controller.sSelectedOption = 'Print';
            controller.DisplaySubsList();
            
            controller.sSelectedOption = 'WPD';
            controller.DisplaySubsList();
            
       }
        User testUser1 = new User(LastName = 'test user 1', 
                             Username = 'test.user.11@example.com', 
                             Email = 'test.1@example.com', 
                             Alias = 'testu1', 
                             TimeZoneSidKey = 'GMT', 
                             LocaleSidKey = 'en_GB', 
                             EmailEncodingKey = 'ISO-8859-1', 
                             ProfileId = testProfile.Id, 
                             LanguageLocaleKey = 'es');   
     System.runas(testUser1)
       {
           
            Account testAcc2 = UnitTest.getAccountInstance();
            ApexPages.standardController sc = new ApexPages.standardController(testAcc2);
            Test.setCurrentPageReference(Page.subscriptions);  
            subscriptions controller1 = new subscriptions(sc); 
            
            controller1.sSelectedOption = 'All Lapsed';
            controller1.DisplaySubsList();
            
            controller1.sSelectedOption = 'All Active';
            controller1.DisplaySubsList();
            
            controller1.sSelectedOption = 'Online';
            controller1.DisplaySubsList();
            
            controller1.sSelectedOption = 'FindLaw';
            controller1.DisplaySubsList();
            
            controller1.sSelectedOption = 'Print';
            controller1.DisplaySubsList();
            
            controller1.sSelectedOption = 'WPD';
            controller1.DisplaySubsList();
            controller1.getSubscriptionListOptions();
            controller1.translateSubscriptionView();
            
       }
            
            
        }
}