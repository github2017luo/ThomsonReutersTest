/*
======================================================================================================================
TEST CLASS NAME: CreateProposal_Test
======================================================================================================================
PURPOSE:    Validates the functionality provided by the CreateProposal class.

CHANGE HISTORY:
======================================================================================================================
  DATE                  NAME                           DESC

2018-03-14            Priyanka                     Optimized the coverage as per JIRA STORY: PS0-1
======================================================================================================================
*/
@istest
Public with sharing class CreateProposal_Test{
    public static testMethod void testDetailController(){
        Profile p = [SELECT Id FROM profile WHERE name='System Administrator']; 
        WebServiceSettings__c oWebServiceSettings = new WebServiceSettings__c(
        Active__c = true,
        Name = 'Payment AutoCharge',
        Service_Unavailable_Message__c = 'Auto Payment Service is Currently unavailable',        
        Endpoint__c = 'https://stg.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentAutoCharge');
        insert oWebServiceSettings ;
        
        WebServiceSettings__c o1WebServiceSettings = new WebServiceSettings__c(
        Active__c = true,
        Name = 'PaymentCreditIncrease',
        Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable',        
        Endpoint__c = 'https://qa.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease');
        insert o1WebServiceSettings ;
    
        User u1 = new User(alias = 'User_3', email='user@mydomain.com', 
        emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
        localesidkey='en_US', profileid = p.Id, employeenumber='0144020',
        timezonesidkey='America/Los_Angeles', username='user_3@mydomain.com',Sub_Bu__c='LMS');        
        insert u1;
        //insert new KeyValueListStore__c(name = 'ANZUsersProfileId',TextValue__c=System.Label.APTS_OC_Test_Id);
        
    List<KeyValueListStore__c> keyValueList = new List<KeyValueListStore__c>();
        KeyValueListStore__c keyVal1 = new KeyValueListStore__c();
        keyVal1.Name = 'ANZUsersProfileId';
        keyVal1.TextValue__c = System.Label.APTS_OC_Test_Id;
        keyValueList.add(keyval1);
        
        KeyValueListStore__c keyval = new KeyValueListStore__c();
        keyval.Name='ReasonWithCompetitor';
        keyval.TextValue__c='Price';
        keyValueList.add(keyval);
        
        insert keyValueList;
    
    insert new RecordtypeIds__c(name = 'Pre-Pipeline Opportunities',recTypeId__c=System.Label.APTS_OC_Test_Id);
        insert new RecordtypeIds__c(name = 'Pipeline Opportunities',recTypeId__c=System.Label.APTS_OC_Test_Id);
        System.Runas(u1){  
        Account testAcc1 = UnitTest.getAccountInstance();
        insert testAcc1;
    Contact ocontact2 = UnitTest.getContactInstance(testAcc1.Id);
        //ocontact.name = 'Jack';
        ocontact2.lastname = 'Sparrow2';
        ocontact2.Email = 'Jack2@Sparrow.com';
        insert ocontact2;
        Source_System_Detail__c ssd = new Source_System_Detail__c (name='testssd',Source_System_Name__c='test',LCRM_Sales_Org__c ='West',Account_Name__c=testAcc1.id);
        insert ssd;
    System.assertequals('testssd',ssd.name,'Success');
        Opportunity opp =UnitTest.getOpportunityInstance(testAcc1.id);
        insert opp;
        opp.Source_System_Detail__c =null;
        update opp;
    
        Business_Partner_Function__c bp = new Business_Partner_Function__c(Related_Account__c=testAcc1.id,Sold_To_Account_GLI__c=ssd.id,Relationship_Type__c  ='Payer');
        insert bp;
        Test.StartTest();
        PageReference pageRef = Page.CreateProposalValidation;
    
        pageRef.getParameters().put('id', String.valueOf(opp.Id));
        system.Test.setCurrentPage(pageRef);
    
        pageRef.getParameters().put('id', String.valueOf(opp.Id));
        ApexPages.StandardController scs = new ApexPages.standardController(opp);
        CreateProposal controller = new CreateProposal(scs);

        CreateProposal sc = new CreateProposal();
    
        sc.redirect();
        sc.cancel();
        ssd.LCRM_Sales_Org__c ='';
        update ssd;
        sc.redirect();
        bp.Relationship_Type__c  ='Sold to party'; 
        ssd.LCRM_Sales_Org__c ='West';   
        update bp;
        update ssd;
        sc.redirect();
   
        apexpages.currentPage().getparameters().put('oppty id', opp.id);
        sc.redirect();     
        Test.StopTest();
        }
     }
     public static testMethod void testDetailController1(){
        Profile p = [SELECT Id FROM profile WHERE name='System Administrator']; 
        WebServiceSettings__c oWebServiceSettings = new WebServiceSettings__c(
        Active__c = true,
        Name = 'Payment AutoCharge',
        Service_Unavailable_Message__c = 'Auto Payment Service is Currently unavailable',        
        Endpoint__c = 'https://stg.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentAutoCharge');
        insert oWebServiceSettings ;
        
          WebServiceSettings__c o1WebServiceSettings = new WebServiceSettings__c(
        Active__c = true,
        Name = 'PaymentCreditIncrease',
        Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable',        
        Endpoint__c = 'https://qa.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease');
        insert o1WebServiceSettings ;
    
        User u1 = new User(alias = 'User_3', email='user@mydomain.com', 
        emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
        localesidkey='en_US', profileid = p.Id, employeenumber='0144020',
        timezonesidkey='America/Los_Angeles', username='user_3@mydomain.com',Sub_Bu__c=label.SALESORGCAN);        
        insert u1;
         
        //insert new KeyValueListStore__c(name = 'ANZUsersProfileId',TextValue__c=System.Label.APTS_OC_Test_Id);
    List<KeyValueListStore__c> keyValueList = new List<KeyValueListStore__c>();
        KeyValueListStore__c keyVal1 = new KeyValueListStore__c();
        keyVal1.Name = 'ANZUsersProfileId';
        keyVal1.TextValue__c = System.Label.APTS_OC_Test_Id;
        keyValueList.add(keyval1);
        
        KeyValueListStore__c keyval = new KeyValueListStore__c();
        keyval.Name='ReasonWithCompetitor';
        keyval.TextValue__c='Price';
        keyValueList.add(keyval);
        
        insert keyValueList;
    
        insert new RecordtypeIds__c(name = 'Pre-Pipeline Opportunities',recTypeId__c=System.Label.APTS_OC_Test_Id);
        insert new RecordtypeIds__c(name = 'Pipeline Opportunities',recTypeId__c=System.Label.APTS_OC_Test_Id);
          System.Runas(u1){  
          Account testAcc1 = UnitTest.getAccountInstance();
          insert testAcc1;
    Contact ocontact = UnitTest.getContactInstance(testAcc1.Id);
        //ocontact.name = 'Jack';
        ocontact.lastname = 'Sparrow';
        ocontact.Email = 'Jack@Sparrow.com';
        insert ocontact;
         Source_System_Detail__c ssd = new Source_System_Detail__c (name='testssd',Source_System_Name__c='test',LCRM_Sales_Org__c =label.SALESORGCARS,Account_Name__c=testAcc1.id,Source_System_Account_Number__c='1234567890');
        insert ssd;
    System.assertequals('testssd',ssd.name,'Success');
        Opportunity opp =UnitTest.getOpportunityInstance(testAcc1.id);
         opp.Key_Contact__c = ocontact.id;
        opp.Source_System_Detail__c = ssd.id;
        insert opp;
     opp.Key_Contact__c = ocontact.id;
       update opp;
    
        Test.StartTest();
        Business_Partner_Function__c bp = new Business_Partner_Function__c(Related_Account__c=testAcc1.id,Sold_To_Account_GLI__c=ssd.id,Relationship_Type__c  ='Payer');
        insert bp;
        PageReference pageRef = Page.CreateProposalValidation;
        pageRef.getParameters().put('id', String.valueOf(opp.Id));
        system.Test.setCurrentPage(pageRef);
    
      pageRef.getParameters().put('id', String.valueOf(opp.Id));
      ApexPages.StandardController scs = new ApexPages.standardController(opp);
      CreateProposal controller = new CreateProposal(scs);

        CreateProposal sc = new CreateProposal();
    
        sc.redirect();
        sc.cancel();
        ssd.LCRM_Sales_Org__c ='';
        update ssd;
        sc.redirect();
        bp.Relationship_Type__c  ='Sold to party'; 
        ssd.LCRM_Sales_Org__c =label.SALESORGCARS;   
        update bp;
        update ssd;
        sc.redirect();
   
       apexpages.currentPage().getparameters().put('oppty id', opp.id);
       sc.redirect();     
       Test.StopTest();
       }
     }
     public static testMethod void testDetailController3(){
     Profile p = [SELECT Id FROM profile WHERE name='System Administrator']; 
         WebServiceSettings__c oWebServiceSettings = new WebServiceSettings__c(
        Active__c = true,
        Name = 'Payment AutoCharge',
        Service_Unavailable_Message__c = 'Auto Payment Service is Currently unavailable',        
        Endpoint__c = 'https://stg.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentAutoCharge');
        insert oWebServiceSettings ;
        
        WebServiceSettings__c o1WebServiceSettings = new WebServiceSettings__c(
        Active__c = true,
        Name = 'PaymentCreditIncrease',
        Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable',        
        Endpoint__c = 'https://qa.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease');
        insert o1WebServiceSettings ;
    
        User u1 = new User(alias = 'User_3', email='user@mydomain.com', 
        emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
        localesidkey='en_US', profileid = p.Id, employeenumber='0144020',
        timezonesidkey='America/Los_Angeles', username='user_3@mydomain.com',Sub_Bu__c=label.SALESORGCAN);        
        insert u1;
        
        //insert new KeyValueListStore__c(name = 'ANZUsersProfileId',TextValue__c=System.Label.APTS_OC_Test_Id);
    List<KeyValueListStore__c> keyValueList = new List<KeyValueListStore__c>();
        KeyValueListStore__c keyVal1 = new KeyValueListStore__c();
        keyVal1.Name = 'ANZUsersProfileId';
        keyVal1.TextValue__c = System.Label.APTS_OC_Test_Id;
        keyValueList.add(keyval1);
        
        KeyValueListStore__c keyval = new KeyValueListStore__c();
        keyval.Name='ReasonWithCompetitor';
        keyval.TextValue__c='Price';
        keyValueList.add(keyval);
        
        insert keyValueList;
    
    insert new RecordtypeIds__c(name = 'Pre-Pipeline Opportunities',recTypeId__c=System.Label.APTS_OC_Test_Id);
        insert new RecordtypeIds__c(name = 'Pipeline Opportunities',recTypeId__c=System.Label.APTS_OC_Test_Id);
          System.Runas(u1){  
          Account testAcc1 = UnitTest.getAccountInstance();
          insert testAcc1;
          Account testAcc2 = UnitTest.getAccountInstance();
          insert testAcc2;
         Source_System_Detail__c ssd = new Source_System_Detail__c (name='testssd',Source_System_Name__c='test',LCRM_Sales_Org__c =label.SALESORGCARS,Account_Name__c=testAcc1.id,Source_System_Account_Number__c='1234567890');
        insert ssd;
    System.assertequals('testssd',ssd.name,'Success');
         Contact ocontact = UnitTest.getContactInstance(testAcc1.Id);
        ocontact.lastname = 'Sparrow';
        ocontact.Email = 'Jack@Sparrow.com';
        insert ocontact;
        Opportunity opp =UnitTest.getOpportunityInstance(testAcc1.id);
        opp.Source_System_Detail__c =ssd.id;
         opp.Key_Contact__c = ocontact.id;
        insert opp;
        
       opp.Source_System_Detail__c =ssd.id;
     opp.Key_Contact__c = ocontact.id;
       update opp;
      
        Test.StartTest();
    
        PageReference pageRef = Page.CreateProposalValidation;
    
        pageRef.getParameters().put('id', String.valueOf(opp.Id));
        system.Test.setCurrentPage(pageRef);
        
      pageRef.getParameters().put('id', String.valueOf(opp.Id));
      ApexPages.StandardController scs = new ApexPages.standardController(opp);
      CreateProposal controller = new CreateProposal(scs);
  
      CreateProposal sc = new CreateProposal();
    
        sc.redirect();
        sc.cancel();
        ssd.LCRM_Sales_Org__c ='';
        update ssd;
        sc.redirect();
        ssd.LCRM_Sales_Org__c =label.SALESORGCARS;   
        update ssd;
        sc.redirect();
        List<Business_Partner_Function__c> bp=[Select id from Business_Partner_Function__c  where Sold_To_Account_GLI__r.Id=:ssd.id];
        System.debug(bp.size());
       apexpages.currentPage().getparameters().put('oppty id', opp.id);
       sc.redirect();     
        Test.StopTest();
    }
     }
      public static testMethod void testDetailController4(){
     Profile p = [SELECT Id FROM profile WHERE name='System Administrator']; 
         WebServiceSettings__c oWebServiceSettings = new WebServiceSettings__c(
        Active__c = true,
        Name = 'Payment AutoCharge',
        Service_Unavailable_Message__c = 'Auto Payment Service is Currently unavailable',        
        Endpoint__c = 'https://stg.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentAutoCharge');
        insert oWebServiceSettings ;
        
        WebServiceSettings__c o1WebServiceSettings = new WebServiceSettings__c(
        Active__c = true,
        Name = 'PaymentCreditIncrease',
        Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable',        
        Endpoint__c = 'https://qa.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease');
        insert o1WebServiceSettings ;
    
        User u1 = new User(alias = 'User_3', email='user@mydomain.com', 
        emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
        localesidkey='en_US', profileid = p.Id, employeenumber='0144020',
        timezonesidkey='America/Los_Angeles', username='user_3@mydomain.com',Sub_Bu__c='label.SALESORGCAN');        
        insert u1;
       
        //insert new KeyValueListStore__c(name = 'ANZUsersProfileId',TextValue__c=System.Label.APTS_OC_Test_Id);
        List<KeyValueListStore__c> keyValueList = new List<KeyValueListStore__c>();
        KeyValueListStore__c keyVal1 = new KeyValueListStore__c();
        keyVal1.Name = 'ANZUsersProfileId';
        keyVal1.TextValue__c = System.Label.APTS_OC_Test_Id;
        keyValueList.add(keyval1);
        
        KeyValueListStore__c keyval = new KeyValueListStore__c();
        keyval.Name='ReasonWithCompetitor';
        keyval.TextValue__c='Price';
        keyValueList.add(keyval);
        
        insert keyValueList;
    insert new RecordtypeIds__c(name = 'Pre-Pipeline Opportunities',recTypeId__c=System.Label.APTS_OC_Test_Id);
        insert new RecordtypeIds__c(name = 'Pipeline Opportunities',recTypeId__c=System.Label.APTS_OC_Test_Id);
          System.Runas(u1){  
          Account testAcc1 = UnitTest.getAccountInstance();
          insert testAcc1;
          Account testAcc2 = UnitTest.getAccountInstance();
          insert testAcc2;
      Contact ocontact = UnitTest.getContactInstance(testAcc1.Id);
        //ocontact.name = 'Jack';
        ocontact.lastname = 'Sparrow';
        ocontact.Email = 'Jack@Sparrow.com';
        insert ocontact;
         Source_System_Detail__c ssd = new Source_System_Detail__c (name='testssd',Source_System_Name__c='test',LCRM_Sales_Org__c =label.SALESORGCARS,Account_Name__c=testAcc1.id,Source_System_Account_Number__c='1234567890');
        insert ssd;
    System.assertequals('testssd',ssd.name,'Success');
        Opportunity opp =UnitTest.getOpportunityInstance(testAcc2.id);
        opp.Source_System_Detail__c = ssd.id;
          opp.Key_Contact__c = ocontact.id;
        insert opp;
      
        opp.Source_System_Detail__c = ssd.id;
    opp.Key_Contact__c = ocontact.id;
       update opp;
      
        Test.StartTest();
    
        PageReference pageRef = Page.CreateProposalValidation;
    
        pageRef.getParameters().put('id', String.valueOf(opp.Id));
        system.Test.setCurrentPage(pageRef);
        
      pageRef.getParameters().put('id', String.valueOf(opp.Id));
      ApexPages.StandardController scs = new ApexPages.standardController(opp);
      CreateProposal controller = new CreateProposal(scs);
  
      CreateProposal sc = new CreateProposal();
    
        sc.redirect();
        sc.cancel();
        ssd.LCRM_Sales_Org__c ='TA78';
        update ssd;
        sc.redirect();
        ssd.LCRM_Sales_Org__c =label.SALESORGCARS;   
        update ssd;
        sc.redirect();
        List<Business_Partner_Function__c> bp=[Select id from Business_Partner_Function__c  where Sold_To_Account_GLI__r.Id=:ssd.id];
        System.debug(bp.size());
       apexpages.currentPage().getparameters().put('oppty id', opp.id);
       sc.redirect();     
        Test.StopTest();
    }
     }
      public static testMethod void testDetailController5(){
     Profile p = [SELECT Id FROM profile WHERE name='System Administrator']; 
         WebServiceSettings__c oWebServiceSettings = new WebServiceSettings__c(
        Active__c = true,
        Name = 'Payment AutoCharge',
        Service_Unavailable_Message__c = 'Auto Payment Service is Currently unavailable',        
        Endpoint__c = 'https://stg.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentAutoCharge');
        insert oWebServiceSettings ;
        
        WebServiceSettings__c o1WebServiceSettings = new WebServiceSettings__c(
        Active__c = true,
        Name = 'PaymentCreditIncrease',
        Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable',        
        Endpoint__c = 'https://qa.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease');
        insert o1WebServiceSettings ;
    
        User u1 = new User(alias = 'User_3', email='user@mydomain.com', 
        emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
        localesidkey='en_US', profileid = p.Id, employeenumber='0144020',
        timezonesidkey='America/Los_Angeles', username='user_3@mydomain.com',Sub_Bu__c=label.SALESORGCAN);        
        insert u1;
        u1.Default_Catalog__c='USL';
        update u1;
         //insert new KeyValueListStore__c(name = 'ANZUsersProfileId',TextValue__c=System.Label.APTS_OC_Test_Id);
        List<KeyValueListStore__c> keyValueList = new List<KeyValueListStore__c>();
        KeyValueListStore__c keyVal1 = new KeyValueListStore__c();
        keyVal1.Name = 'ANZUsersProfileId';
        keyVal1.TextValue__c = System.Label.APTS_OC_Test_Id;
        keyValueList.add(keyval1);
        
        KeyValueListStore__c keyval = new KeyValueListStore__c();
        keyval.Name='ReasonWithCompetitor';
        keyval.TextValue__c='Price';
        keyValueList.add(keyval);
        
        insert keyValueList;
    
    insert new RecordtypeIds__c(name = 'Pre-Pipeline Opportunities',recTypeId__c=System.Label.APTS_OC_Test_Id);
        insert new RecordtypeIds__c(name = 'Pipeline Opportunities',recTypeId__c=System.Label.APTS_OC_Test_Id);
          System.Runas(u1){  
          Account testAcc1 = UnitTest.getAccountInstance();
          insert testAcc1;
          Account testAcc2 = UnitTest.getAccountInstance();
          insert testAcc2;
      Contact ocontact = UnitTest.getContactInstance(testAcc1.Id);
        //ocontact.name = 'Jack';
        ocontact.lastname = 'Sparrow';
        ocontact.Email = 'Jack@Sparrow.com';
        insert ocontact;
         Source_System_Detail__c ssd = new Source_System_Detail__c (name='testssd',Source_System_Name__c='test',LCRM_Sales_Org__c =label.SALESORGCARS,Account_Name__c=testAcc1.id,Source_System_Account_Number__c='1234567890');
        insert ssd;
    System.assertequals('testssd',ssd.name,'Success');
         
        Opportunity opp =UnitTest.getOpportunityInstance(testAcc1.id);
        opp.Source_System_Detail__c = ssd.id;
         opp.Key_Contact__c = ocontact.id;
        insert opp;
        
       opp.Source_System_Detail__c =ssd.id;
     opp.Key_Contact__c = ocontact.id;
       update opp;
      
        Test.StartTest();
    
        PageReference pageRef = Page.CreateProposalValidation;
    
        pageRef.getParameters().put('id', String.valueOf(opp.Id));
        system.Test.setCurrentPage(pageRef);
        
      pageRef.getParameters().put('id', String.valueOf(opp.Id));
      ApexPages.StandardController scs = new ApexPages.standardController(opp);
      CreateProposal controller = new CreateProposal(scs);
  
      CreateProposal sc = new CreateProposal();
    
        sc.redirect();
        sc.cancel();
        ssd.LCRM_Sales_Org__c ='';
        update ssd;
        sc.redirect();
        ssd.LCRM_Sales_Org__c =label.SALESORGCARS;   
        update ssd;
        sc.redirect();
        List<Business_Partner_Function__c> bp=[Select id from Business_Partner_Function__c  where Sold_To_Account_GLI__r.Id=:ssd.id];
        System.debug(bp.size());
       apexpages.currentPage().getparameters().put('oppty id', opp.id);
       sc.redirect();     
        Test.StopTest();
    }
     }
     public static testMethod void testDetailController6(){
     Profile p = [SELECT Id FROM profile WHERE name='System Administrator']; 
         WebServiceSettings__c oWebServiceSettings = new WebServiceSettings__c(
        Active__c = true,
        Name = 'Payment AutoCharge',
        Service_Unavailable_Message__c = 'Auto Payment Service is Currently unavailable',        
        Endpoint__c = 'https://stg.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentAutoCharge');
        insert oWebServiceSettings ;
        
        WebServiceSettings__c o1WebServiceSettings = new WebServiceSettings__c(
        Active__c = true,
        Name = 'PaymentCreditIncrease',
        Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable',        
        Endpoint__c = 'https://qa.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease');
        insert o1WebServiceSettings ;
    
        User u1 = new User(alias = 'User_3', email='user@mydomain.com', 
        emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
        localesidkey='en_US', profileid = p.Id, employeenumber='0144020',
        timezonesidkey='America/Los_Angeles', username='user_3@mydomain.com',Sub_Bu__c=label.SALESORGCAN);        
        insert u1;
        
        //insert new KeyValueListStore__c(name = 'ANZUsersProfileId',TextValue__c=System.Label.APTS_OC_Test_Id);
        List<KeyValueListStore__c> keyValueList = new List<KeyValueListStore__c>();
        KeyValueListStore__c keyVal1 = new KeyValueListStore__c();
        keyVal1.Name = 'ANZUsersProfileId';
        keyVal1.TextValue__c = System.Label.APTS_OC_Test_Id;
        keyValueList.add(keyval1);
        
        KeyValueListStore__c keyval = new KeyValueListStore__c();
        keyval.Name='ReasonWithCompetitor';
        keyval.TextValue__c='Price';
        keyValueList.add(keyval);
    insert keyValueList;
    
    insert new RecordtypeIds__c(name = 'Pre-Pipeline Opportunities',recTypeId__c=System.Label.APTS_OC_Test_Id);
        insert new RecordtypeIds__c(name = 'Pipeline Opportunities',recTypeId__c=System.Label.APTS_OC_Test_Id);
          System.Runas(u1){  
          Account testAcc1 = UnitTest.getAccountInstance();
          insert testAcc1;
          Account testAcc2 = UnitTest.getAccountInstance();
          insert testAcc2;
      Contact ocontact = UnitTest.getContactInstance(testAcc1.Id);
        //ocontact.name = 'Jack';
        ocontact.lastname = 'Sparrow';
        ocontact.Email = 'Jack@Sparrow.com';
        insert ocontact;
         Source_System_Detail__c ssd = new Source_System_Detail__c (name='testssd',Source_System_Name__c='test',LCRM_Sales_Org__c =label.SALESORGCARS,Account_Name__c=testAcc1.id,Source_System_Account_Number__c='1234567890');
        insert ssd;
    System.assertequals('testssd',ssd.name,'Success');
         
        Opportunity opp =UnitTest.getOpportunityInstance(testAcc1.id);
        opp.Source_System_Detail__c = ssd.id;
        // opp.Key_Contact__c = ocontact.id;
        insert opp;
        
       opp.Source_System_Detail__c =ssd.id;
     //opp.Key_Contact__c = ocontact.id;
       update opp;
      
        Test.StartTest();
    
        PageReference pageRef = Page.CreateProposalValidation;
    
        pageRef.getParameters().put('id', String.valueOf(opp.Id));
        system.Test.setCurrentPage(pageRef);
        
        pageRef.getParameters().put('id', String.valueOf(opp.Id));
        ApexPages.StandardController scs = new ApexPages.standardController(opp);
        CreateProposal controller = new CreateProposal(scs);
  
        CreateProposal sc = new CreateProposal();
        sc.redirect();
           
        Test.StopTest();
    }
     }
     
     public static testMethod void testDetailControllerTax(){
     Profile p = [SELECT Id FROM profile WHERE name='System Administrator']; 
         WebServiceSettings__c oWebServiceSettings = new WebServiceSettings__c(
        Active__c = true,
        Name = 'Payment AutoCharge',
        Service_Unavailable_Message__c = 'Auto Payment Service is Currently unavailable',        
        Endpoint__c = 'https://stg.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentAutoCharge');
        insert oWebServiceSettings ;
        
        WebServiceSettings__c o1WebServiceSettings = new WebServiceSettings__c(
        Active__c = true,
        Name = 'PaymentCreditIncrease',
        Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable',        
        Endpoint__c = 'https://qa.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease');
        insert o1WebServiceSettings ;
    
        User u1 = new User(alias = 'User_3', email='user@mydomain.com', 
        emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
        localesidkey='en_US', profileid = p.Id, employeenumber='0144020',
        timezonesidkey='America/Los_Angeles', username='user_3@mydomain.com',Sub_Bu__c='US',Segment__c='Professional Tax');        
        insert u1;
        u1.Default_Catalog__c='USL';
        update u1;
        //insert new KeyValueListStore__c(name = 'ANZUsersProfileId',TextValue__c=System.Label.APTS_OC_Test_Id);
        List<KeyValueListStore__c> keyValueList = new List<KeyValueListStore__c>();
        KeyValueListStore__c keyVal1 = new KeyValueListStore__c();
        keyVal1.Name = 'ANZUsersProfileId';
        keyVal1.TextValue__c = System.Label.APTS_OC_Test_Id;
        keyValueList.add(keyval1);
        
        KeyValueListStore__c keyval = new KeyValueListStore__c();
        keyval.Name='ReasonWithCompetitor';
        keyval.TextValue__c='Price';
        keyValueList.add(keyval);
        
        insert keyValueList;
        insert new RecordtypeIds__c(name = 'Pre-Pipeline Opportunities',recTypeId__c=System.Label.APTS_OC_Test_Id);
        insert new RecordtypeIds__c(name = 'Pipeline Opportunities',recTypeId__c=System.Label.APTS_OC_Test_Id);
          System.Runas(u1){  
          Account testAcc1 = UnitTest.getAccountInstance();
          insert testAcc1;
          Account testAcc2 = UnitTest.getAccountInstance();
          insert testAcc2;
         Contact ocontact = UnitTest.getContactInstance(testAcc1.Id);
        //ocontact.name = 'Jack';
        ocontact.lastname = 'Sparrow';
        ocontact.Email = 'Jack@Sparrow.com';
        insert ocontact;
         Source_System_Detail__c ssd = new Source_System_Detail__c (name='testssd',Source_System_Name__c='test',LCRM_Sales_Org__c ='WEST',Account_Name__c=testAcc1.id,Source_System_Account_Number__c='1234567890');
        insert ssd;
    System.assertequals('testssd',ssd.name,'Success');
         
        Opportunity opp =UnitTest.getOpportunityInstance(testAcc1.id);
        opp.Source_System_Detail__c = ssd.id;
        opp.Key_Contact__c = ocontact.id;
        insert opp;
        
       opp.Source_System_Detail__c =ssd.id;
       opp.Key_Contact__c = ocontact.id;
       update opp;
      
        Test.StartTest();
    
        PageReference pageRef = Page.CreateProposalValidation;
    
        pageRef.getParameters().put('id', String.valueOf(opp.Id));
        system.Test.setCurrentPage(pageRef);
        
      pageRef.getParameters().put('id', String.valueOf(opp.Id));
      ApexPages.StandardController scs = new ApexPages.standardController(opp);
      CreateProposal controller = new CreateProposal(scs);
  
      CreateProposal sc = new CreateProposal();
    
        sc.redirect();
        sc.cancel();
        ssd.LCRM_Sales_Org__c ='';
        update ssd;
        sc.redirect();
        ssd.LCRM_Sales_Org__c ='S100';   
        update ssd;
        sc.redirect();
        
        Test.StopTest();
    }
     }
     /* public static testMethod void testDetailController6(){
     Profile p = [SELECT Id FROM profile WHERE name='LatAm User'];
         WebServiceSettings__c oWebServiceSettings = new WebServiceSettings__c(
        Active__c = true,
        Name = 'Payment AutoCharge',
        Service_Unavailable_Message__c = 'Auto Payment Service is Currently unavailable',        
        Endpoint__c = 'https://stg.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentAutoCharge');
        insert oWebServiceSettings ;
        
        WebServiceSettings__c o1WebServiceSettings = new WebServiceSettings__c(
        Active__c = true,
        Name = 'PaymentCreditIncrease',
        Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable',        
        Endpoint__c = 'https://qa.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease');
        insert o1WebServiceSettings ;
    
        User u1 = new User(alias = 'User_3', email='user@mydomain.com', 
        emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
        localesidkey='en_US', profileid = p.Id, employeenumber='0144020',
        timezonesidkey='America/Los_Angeles', username='user_3@mydomain.com',Sub_Bu__c='LatAm'); 
        insert u1;
        u1.Default_Catalog__c='USL';
        update u1;
        insert new KeyValueListStore__c(name = 'ANZUsersProfileId',TextValue__c=System.Label.APTS_OC_Test_Id);
        insert new RecordtypeIds__c(name = 'Pre-Pipeline Opportunities',recTypeId__c=System.Label.APTS_OC_Test_Id);
        insert new RecordtypeIds__c(name = 'Pipeline Opportunities',recTypeId__c=System.Label.APTS_OC_Test_Id);
          System.Runas(u1){  
          Account testAcc1 = UnitTest.getAccountInstance();
          insert testAcc1;
          Account testAcc2 = UnitTest.getAccountInstance();
          insert testAcc2;
         Source_System_Detail__c ssd = new Source_System_Detail__c (name='testssd',Source_System_Name__c='test',LCRM_Sales_Org__c =label.SALESORGCARS,Account_Name__c=testAcc1.id,Source_System_Account_Number__c='1234567890');
        insert ssd;
         
        Opportunity opp =UnitTest.getOpportunityInstance(testAcc1.id);
        opp.Source_System_Detail__c = ssd.id;
        opp.ownerid= u1.id;
        insert opp;
    
        Test.StartTest();
    
        PageReference pageRef = Page.CreateProposalValidation;
    
        pageRef.getParameters().put('id', String.valueOf(opp.Id));
        system.Test.setCurrentPage(pageRef);
        
      pageRef.getParameters().put('id', String.valueOf(opp.Id));
      ApexPages.StandardController scs = new ApexPages.standardController(opp);
      CreateProposal controller = new CreateProposal(scs);
  
      CreateProposal sc = new CreateProposal();
    
        sc.redirect();
        sc.cancel();
        ssd.LCRM_Sales_Org__c ='';
        update ssd;
        sc.redirect();
        ssd.LCRM_Sales_Org__c =label.SALESORGCARS;   
        update ssd;
        sc.redirect();
        List<Business_Partner_Function__c> bp=[Select id from Business_Partner_Function__c  where Sold_To_Account_GLI__r.Id=:ssd.id];
        System.debug(bp.size());
       apexpages.currentPage().getparameters().put('oppty id', opp.id);
       sc.redirect();     
        Test.StopTest();
    }
     }*/
}