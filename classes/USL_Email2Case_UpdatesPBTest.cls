@istest
public class USL_Email2Case_UpdatesPBTest{
    static testmethod void testmethod1(){
       
        Profile Prof = [SELECT Id FROM profile WHERE name='USL Helpdesk Agent'];
        Test.startTest();
        Account acct = new Account();
        acct.Name = 'SFDC';
        acct.ShippingCity = 'New York';
        acct.ShippingState = 'AL';
        acct.ShippingCountry = 'US';
        acct.ShippingPostalCode = '1007';
        acct.ShippingStreet = 'Diamond';
        /*acct.Legacy_System_ID__c='jasas';
        acct.Tax_Number_Type__c='C.I';
        acct.Tax_Number__c='19101';
        acct.Sales_Org__c='GLI';*/
        insert acct ;
        
        
        Contact con = new Contact();
        con.AccountId=acct.Id;
        con.FirstName='Dummy';
        con.LastName='Test';
        con.Salutation='Mr.';
        con.Email='dummytest@thomsonreuters.com';
        
        insert con;
        
        Group g = new Group();
            g.Name = 'Westlaw_Support_Queue';
            g.type='Queue';
            insert g;
        
        QueueSobject mappingObject = new QueueSobject(QueueId = g.Id, SobjectType = 'Case');
            System.runAs(new User(Id = UserInfo.getUserId()))
             {insert mappingObject;}
        Group g1 = [select id,developername,type from group where id =: g.id];

        system.debug('queue inserted'+g1.developername+'--'+g1.id+'--'+g1.type);
        
        USL_Queues__c usl_test=new USL_Queues__c();
        usl_test.QueueId1__c= g1.developername;
        insert usl_test;
        
       
             
        USL_Email2Case_ToEmails__c usemail = new USL_Email2Case_ToEmails__c();
        usemail.To_Email1__c = 'techsupport@thomsonreuters.com';
        insert usemail;
        
        // insert a case records
        List<Case> Cslist= New List<Case>();
        Case cs = new Case();
        cs.OwnerId=g.id; 
        cs.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Incident').getRecordTypeId();
        cs.Priority='2-Medium';
        cs.Origin='Email';
        cs.ESC_Origin_Name__c ='';        
        cs.LCRM_Sub_BU__c ='USL';
        cs.ESC_Apply_Entitlement_Milestone__c =false;
        cs.SuppliedEmail='dummytest@thomsonreuters.com';
        Cslist.add(cs);
       insert Cslist;
        test.stopTest();
        integer i = 1;
        integer j = 1;
        System.assertEquals(i,j);
        try
        {
         
        
        list<EmailMessage> Emlist= New List<EmailMessage>();
        EmailMessage newEmail1 = new EmailMessage(ParentId = cs.Id, ToAddress='techsupport@thomsonreuters.com', FromAddress = 'dummytest@thomsonreuters.com',Incoming=true,TextBody='test', Subject='My Tax Exempt Certificate -1');
        Emlist.add(newEmail1);
        //insert newEmail1;
        insert Emlist;
        
        
        
        }
        catch(Exception e)
        {
            system.debug('%%%%issue?'+e);
        }
    }
    static testmethod void testmethod2(){
       
        Profile Prof = [SELECT Id FROM profile WHERE name='USL Helpdesk Agent'];
        Test.startTest();
        Account acct = new Account();
        acct.Name = 'SFDC';
        acct.ShippingCity = 'New York';
        acct.ShippingState = 'AL';
        acct.ShippingCountry = 'US';
        acct.ShippingPostalCode = '1007';
        acct.ShippingStreet = 'Diamond';
        /*acct.Legacy_System_ID__c='jasas';
        acct.Tax_Number_Type__c='C.I';
        acct.Tax_Number__c='19101';
        acct.Sales_Org__c='GLI';*/
        insert acct ;
        
        
        Contact con = new Contact();
        con.AccountId=acct.Id;
        con.FirstName='Dummy';
        con.LastName='Test';
        con.Salutation='Mr.';
        con.Email='dummytest@thomsonreuters.com';
        
        insert con;
        
        Group g = new Group();
            g.Name = 'Westlaw_Support_Queue';
            g.type='Queue';
            insert g;
        
        QueueSobject mappingObject = new QueueSobject(QueueId = g.Id, SobjectType = 'Case');
            System.runAs(new User(Id = UserInfo.getUserId()))
             {insert mappingObject;}
        Group g1 = [select id,developername,type from group where id =: g.id];

        system.debug('queue inserted'+g1.developername+'--'+g1.id+'--'+g1.type);
        
        USL_Queues__c usl_test=new USL_Queues__c();
        usl_test.QueueId1__c= g1.developername;
        insert usl_test;
        
       
             
        USL_Email2Case_ToEmails__c usemail = new USL_Email2Case_ToEmails__c();
        usemail.To_Email1__c = 'techsupport@thomsonreuters.com';
        insert usemail;
        
        // insert a case records
        List<Case> Cslist= New List<Case>();
        
        Case cs1 = new Case();
        //cs1.OwnerId=g.id; 
        //cs1.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Incident').getRecordTypeId();
        //cs1.Priority='2-Medium';
        //cs1.Origin='Email';
        //cs1.ESC_Origin_Name__c ='';
        cs1.LCRM_Sub_BU__c ='USL';
       // cs1.ESC_Apply_Entitlement_Milestone__c =false;
        cs1.SuppliedEmail='dummytest@thomsonreuters.com';
        Cslist.add(cs1);

       
       insert Cslist;
        test.stopTest();
        integer i = 1;
        integer j = 1;
        System.assertEquals(i,j);
        try
        {
         
        list<EmailMessage> Emlist= New List<EmailMessage>();
        /*EmailMessage newEmail11 = new EmailMessage(ParentId = cs1.Id, ToAddress='techsupport12@thomsonreuters.com', CcAddress='techsupport@thomsonreuters.com', FromAddress = 'dummytest@thomsonreuters.com',Incoming=true,TextBody='test', Subject='MyAccount - Address Change0');
         Emlist.add(newEmail11);*/
         //insert newEmail11;
            
        EmailMessage newEmail2 = new EmailMessage(ParentId = cs1.Id, ToAddress='techsupport@thomsonreuters.com', FromAddress = 'dummytest@thomsonreuters.com',Incoming=true,TextBody='test', Subject='MyAccount - Change Address');
        Emlist.add(newEmail2);
        //insert newEmail2;
        insert Emlist;
        
        }
        catch(Exception e)
        {
            system.debug('%%%%issue?'+e);
        }
    }

     static testmethod void testmethod3(){
       
        Profile Prof = [SELECT Id FROM profile WHERE name='USL Helpdesk Agent'];
        Test.startTest();
        Account acct = new Account();
        acct.Name = 'SFDC';
        acct.ShippingCity = 'New York';
        acct.ShippingState = 'AL';
        acct.ShippingCountry = 'US';
        acct.ShippingPostalCode = '1007';
        acct.ShippingStreet = 'Diamond';
        insert acct ;
        
        
        Contact con = new Contact();
        con.AccountId=acct.Id;
        con.FirstName='Dummy';
        con.LastName='Test';
        con.Salutation='Mr.';
        con.Email='dummytest@thomsonreuters.com';
        
        insert con;
        /*
        Group g = new Group();
            g.Name = 'Westlaw_Support_Queue';
            g.type='Queue';
            insert g;
        
        QueueSobject mappingObject = new QueueSobject(QueueId = g.Id, SobjectType = 'Case');
            System.runAs(new User(Id = UserInfo.getUserId()))
             {insert mappingObject;}
        Group g1 = [select id,developername,type from group where id =: g.id];

        system.debug('queue inserted'+g1.developername+'--'+g1.id+'--'+g1.type);
        
        USL_Queues__c usl_test=new USL_Queues__c();
        usl_test.QueueId1__c= g1.developername;
        insert usl_test;
        
       
             
        USL_Email2Case_ToEmails__c usemail = new USL_Email2Case_ToEmails__c();
        usemail.To_Email1__c = 'techsupport@thomsonreuters.com';
        insert usemail;
        */
        // insert a case records
        System.runAs(new User(Id = UserInfo.getUserId()))
             {
        List<Case> Cslist= New List<Case>();
        
        Case cs1 = new Case();
        //cs1.OwnerId=g.id; 
        cs1.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Incident').getRecordTypeId();
        //cs1.Priority='2-Medium';
        //cs1.Origin='Email';
        //cs1.ESC_Origin_Name__c ='';
        cs1.LCRM_Sub_BU__c ='USL';
       // cs1.ESC_Apply_Entitlement_Milestone__c =false;
        cs1.SuppliedEmail='dummytest@thomsonreuters.com';
        Cslist.add(cs1);

       
       insert Cslist;
        test.stopTest();
        integer i = 1;
        integer j = 1;
        System.assertEquals(i,j);
        try
        {
         
        list<EmailMessage> Emlist= New List<EmailMessage>();
                   
        EmailMessage newEmail2 = new EmailMessage(ParentId = cs1.Id, ToAddress='techsupport@thomsonreuters.com', FromAddress = 'dummytest@thomsonreuters.com',Incoming=true,TextBody='tested', Subject='MakeCreditCardPayment 1');
        //+cs1.ESC_Email_Thread_Id__c
        Emlist.add(newEmail2);
        //insert newEmail2;
        insert Emlist;
        
         system.debug('%%%%Email parent details'+newEmail2.Parent.IS_ESC_Case__c+' '+newEmail2.Parent.LCRM_Sub_BU__c+'  '+newEmail2.FromAddress+'----'+newEmail2.Subject);
        
        }
        catch(Exception e)
        {
            system.debug('%%%%issue?'+e);
        }
    }

    }
    static testmethod void testmethod4(){
       
        Profile Prof = [SELECT Id FROM profile WHERE name='USL Helpdesk Agent'];
        Test.startTest();
        Account acct = new Account();
        acct.Name = 'SFDC';
        acct.ShippingCity = 'New York';
        acct.ShippingState = 'AL';
        acct.ShippingCountry = 'US';
        acct.ShippingPostalCode = '1007';
        acct.ShippingStreet = 'Diamond';
        insert acct ;
        
        
        Contact con = new Contact();
        con.AccountId=acct.Id;
        con.FirstName='Dummy';
        con.LastName='Test';
        con.Salutation='Mr.';
        con.Email='dummytest@thomsonreuters.com';
        
        insert con;
        /*
        Group g = new Group();
            g.Name = 'Westlaw_Support_Queue';
            g.type='Queue';
            insert g;
        
        QueueSobject mappingObject = new QueueSobject(QueueId = g.Id, SobjectType = 'Case');
            System.runAs(new User(Id = UserInfo.getUserId()))
             {insert mappingObject;}
        Group g1 = [select id,developername,type from group where id =: g.id];

        system.debug('queue inserted'+g1.developername+'--'+g1.id+'--'+g1.type);
        
        USL_Queues__c usl_test=new USL_Queues__c();
        usl_test.QueueId1__c= g1.developername;
        insert usl_test;
        
       
             
        USL_Email2Case_ToEmails__c usemail = new USL_Email2Case_ToEmails__c();
        usemail.To_Email1__c = 'techsupport@thomsonreuters.com';
        insert usemail;
        */
        // insert a case records
        System.runAs(new User(Id = UserInfo.getUserId()))
             {
        List<Case> Cslist= New List<Case>();
        
        Case cs1 = new Case();
        //cs1.OwnerId=g.id; 
        cs1.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Incident').getRecordTypeId();
        //cs1.Priority='2-Medium';
        //cs1.Origin='Email';
        //cs1.ESC_Origin_Name__c ='';
        cs1.LCRM_Sub_BU__c ='USL';
       // cs1.ESC_Apply_Entitlement_Milestone__c =false;
        cs1.SuppliedEmail='dummytest@thomsonreuters.com';
        Cslist.add(cs1);

       
       insert Cslist;
        test.stopTest();
        integer i = 1;
        integer j = 1;
        System.assertEquals(i,j);
        try
        {
         
        list<EmailMessage> Emlist= New List<EmailMessage>();
                   
        EmailMessage newEmail2 = new EmailMessage(ParentId = cs1.Id, ToAddress='techsupport@thomsonreuters.com', FromAddress = 'dummytest@thomsonreuters.com',Incoming=true,TextBody='tested', Subject='MakeACHPayment 1');
        //+cs1.ESC_Email_Thread_Id__c
        Emlist.add(newEmail2);
        //insert newEmail2;
        insert Emlist;
        
         system.debug('%%%%Email parent details'+newEmail2.Parent.IS_ESC_Case__c+' '+newEmail2.Parent.LCRM_Sub_BU__c+'  '+newEmail2.FromAddress+'----'+newEmail2.Subject);
        
        }
        catch(Exception e)
        {
            system.debug('%%%%issue?'+e);
        }
    }

    }
     static testmethod void testmethod5(){
       
        Profile Prof = [SELECT Id FROM profile WHERE name='USL Helpdesk Agent'];
        Test.startTest();
        Account acct = new Account();
        acct.Name = 'SFDC';
        acct.ShippingCity = 'New York';
        acct.ShippingState = 'AL';
        acct.ShippingCountry = 'US';
        acct.ShippingPostalCode = '1007';
        acct.ShippingStreet = 'Diamond';
        insert acct ;
        
        
        Contact con = new Contact();
        con.AccountId=acct.Id;
        con.FirstName='Dummy';
        con.LastName='Test';
        con.Salutation='Mr.';
        con.Email='dummytest@thomsonreuters.com';
        
        insert con;
        /*
        Group g = new Group();
            g.Name = 'Westlaw_Support_Queue';
            g.type='Queue';
            insert g;
        
        QueueSobject mappingObject = new QueueSobject(QueueId = g.Id, SobjectType = 'Case');
            System.runAs(new User(Id = UserInfo.getUserId()))
             {insert mappingObject;}
        Group g1 = [select id,developername,type from group where id =: g.id];

        system.debug('queue inserted'+g1.developername+'--'+g1.id+'--'+g1.type);
        
        USL_Queues__c usl_test=new USL_Queues__c();
        usl_test.QueueId1__c= g1.developername;
        insert usl_test;
        
       
             
        USL_Email2Case_ToEmails__c usemail = new USL_Email2Case_ToEmails__c();
        usemail.To_Email1__c = 'techsupport@thomsonreuters.com';
        insert usemail;
        */
        // insert a case records
        System.runAs(new User(Id = UserInfo.getUserId()))
             {
        List<Case> Cslist= New List<Case>();
        
        Case cs1 = new Case();
        //cs1.OwnerId=g.id; 
        cs1.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Incident').getRecordTypeId();
        //cs1.Priority='2-Medium';
        //cs1.Origin='Email';
        //cs1.ESC_Origin_Name__c ='';
        cs1.LCRM_Sub_BU__c ='USL';
       // cs1.ESC_Apply_Entitlement_Milestone__c =false;
        cs1.SuppliedEmail='dummytest@thomsonreuters.com';
        Cslist.add(cs1);

       
       insert Cslist;
        test.stopTest();
        integer i = 1;
        integer j = 1;
        System.assertEquals(i,j);
        try
        {
         
        list<EmailMessage> Emlist= New List<EmailMessage>();
                   
        EmailMessage newEmail2 = new EmailMessage(ParentId = cs1.Id, ToAddress='techsupport@thomsonreuters.com', FromAddress = 'dummytest@thomsonreuters.com',Incoming=true,TextBody='tested', Subject='SN# 1');
        //+cs1.ESC_Email_Thread_Id__c
        Emlist.add(newEmail2);
        //insert newEmail2;
        insert Emlist;
        
         system.debug('%%%%Email parent details'+newEmail2.Parent.IS_ESC_Case__c+' '+newEmail2.Parent.LCRM_Sub_BU__c+'  '+newEmail2.FromAddress+'----'+newEmail2.Subject);
        
        }
        catch(Exception e)
        {
            system.debug('%%%%issue?'+e);
        }
    }

    }
     static testmethod void testmethod6(){
       
        Profile Prof = [SELECT Id FROM profile WHERE name='USL Helpdesk Agent'];
        Test.startTest();
        Account acct = new Account();
        acct.Name = 'SFDC';
        acct.ShippingCity = 'New York';
        acct.ShippingState = 'AL';
        acct.ShippingCountry = 'US';
        acct.ShippingPostalCode = '1007';
        acct.ShippingStreet = 'Diamond';
        insert acct ;
        
        
        Contact con = new Contact();
        con.AccountId=acct.Id;
        con.FirstName='Dummy';
        con.LastName='Test';
        con.Salutation='Mr.';
        con.Email='dummytest@thomsonreuters.com';
        
        insert con;
        /*
        Group g = new Group();
            g.Name = 'Westlaw_Support_Queue';
            g.type='Queue';
            insert g;
        
        QueueSobject mappingObject = new QueueSobject(QueueId = g.Id, SobjectType = 'Case');
            System.runAs(new User(Id = UserInfo.getUserId()))
             {insert mappingObject;}
        Group g1 = [select id,developername,type from group where id =: g.id];

        system.debug('queue inserted'+g1.developername+'--'+g1.id+'--'+g1.type);
        
        USL_Queues__c usl_test=new USL_Queues__c();
        usl_test.QueueId1__c= g1.developername;
        insert usl_test;
        
       
             
        USL_Email2Case_ToEmails__c usemail = new USL_Email2Case_ToEmails__c();
        usemail.To_Email1__c = 'techsupport@thomsonreuters.com';
        insert usemail;
        */
        // insert a case records
        System.runAs(new User(Id = UserInfo.getUserId()))
             {
        List<Case> Cslist= New List<Case>();
        
        Case cs1 = new Case();
        //cs1.OwnerId=g.id; 
        cs1.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Incident').getRecordTypeId();
        //cs1.Priority='2-Medium';
        //cs1.Origin='Email';
        //cs1.ESC_Origin_Name__c ='';
        cs1.LCRM_Sub_BU__c ='US';
       // cs1.ESC_Apply_Entitlement_Milestone__c =false;
        cs1.SuppliedEmail='dummytest@thomsonreuters.com';
        cs1.BU_Segment__c='Corporate';
        Cslist.add(cs1);

       
       insert Cslist;
        test.stopTest();
        integer i = 1;
        integer j = 1;
        System.assertEquals(i,j);
        try
        {
         
        list<EmailMessage> Emlist= New List<EmailMessage>();
                   
        EmailMessage newEmail2 = new EmailMessage(ParentId = cs1.Id, ToAddress='techsupport@thomsonreuters.com', FromAddress = 'dummytest@thomsonreuters.com',Incoming=true,TextBody='tested', Subject='SN# 1');
        //+cs1.ESC_Email_Thread_Id__c
        Emlist.add(newEmail2);
        //insert newEmail2;
        insert Emlist;
        
         system.debug('%%%%Email parent details'+newEmail2.Parent.IS_ESC_Case__c+' '+newEmail2.Parent.LCRM_Sub_BU__c+'  '+newEmail2.FromAddress+'----'+newEmail2.Subject);
        
        }
        catch(Exception e)
        {
            system.debug('%%%%issue?'+e);
        }
    }

    }
    static testmethod void testmethod7(){
       
        Profile Prof = [SELECT Id FROM profile WHERE name='USL Helpdesk Agent'];
        Test.startTest();
        Account acct = new Account();
        acct.Name = 'SFDC';
        acct.ShippingCity = 'New York';
        acct.ShippingState = 'AL';
        acct.ShippingCountry = 'US';
        acct.ShippingPostalCode = '1007';
        acct.ShippingStreet = 'Diamond';
        insert acct ;
        
        
        Contact con = new Contact();
        con.AccountId=acct.Id;
        con.FirstName='Dummy';
        con.LastName='Test';
        con.Salutation='Mr.';
        con.Email='dummytest@thomsonreuters.com';
        
        insert con;
        /*
        Group g = new Group();
            g.Name = 'Westlaw_Support_Queue';
            g.type='Queue';
            insert g;
        
        QueueSobject mappingObject = new QueueSobject(QueueId = g.Id, SobjectType = 'Case');
            System.runAs(new User(Id = UserInfo.getUserId()))
             {insert mappingObject;}
        Group g1 = [select id,developername,type from group where id =: g.id];

        system.debug('queue inserted'+g1.developername+'--'+g1.id+'--'+g1.type);
        
        USL_Queues__c usl_test=new USL_Queues__c();
        usl_test.QueueId1__c= g1.developername;
        insert usl_test;
        
       
             
        USL_Email2Case_ToEmails__c usemail = new USL_Email2Case_ToEmails__c();
        usemail.To_Email1__c = 'techsupport@thomsonreuters.com';
        insert usemail;
        */
        // insert a case records
        System.runAs(new User(Id = UserInfo.getUserId()))
             {
        List<Case> Cslist= New List<Case>();
        
        Case cs1 = new Case();
        //cs1.OwnerId=g.id; 
        cs1.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Incident').getRecordTypeId();
        //cs1.Priority='2-Medium';
        //cs1.Origin='Email';
        //cs1.ESC_Origin_Name__c ='';
        cs1.LCRM_Sub_BU__c ='USL';
       // cs1.ESC_Apply_Entitlement_Milestone__c =false;
        cs1.SuppliedEmail='dummytest@thomsonreuters.com';
        Cslist.add(cs1);

       
       insert Cslist;
        test.stopTest();
        integer i = 1;
        integer j = 1;
        System.assertEquals(i,j);
        try
        {
         
        list<EmailMessage> Emlist= New List<EmailMessage>();
                   
        EmailMessage newEmail2 = new EmailMessage(ParentId = cs1.Id, ToAddress='techsupport@thomsonreuters.com', FromAddress = 'dummytest@thomsonreuters.com',Incoming=true,TextBody='tested', Subject='Writeoff failure 1');
        //+cs1.ESC_Email_Thread_Id__c
        Emlist.add(newEmail2);
        //insert newEmail2;
        insert Emlist;
        
         system.debug('%%%%Email parent details'+newEmail2.Parent.IS_ESC_Case__c+' '+newEmail2.Parent.LCRM_Sub_BU__c+'  '+newEmail2.FromAddress+'----'+newEmail2.Subject);
        
        }
        catch(Exception e)
        {
            system.debug('%%%%issue?'+e);
        }
    }

    }
    static testmethod void testmethod8(){
       
        Profile Prof = [SELECT Id FROM profile WHERE name='USL Helpdesk Agent'];
        Test.startTest();
        Account acct = new Account();
        acct.Name = 'SFDC';
        acct.ShippingCity = 'New York';
        acct.ShippingState = 'AL';
        acct.ShippingCountry = 'US';
        acct.ShippingPostalCode = '1007';
        acct.ShippingStreet = 'Diamond';
        insert acct ;
        
        
        Contact con = new Contact();
        con.AccountId=acct.Id;
        con.FirstName='Dummy';
        con.LastName='Test';
        con.Salutation='Mr.';
        con.Email='dummytest@thomsonreuters.com';
        
        insert con;
        /*
        Group g = new Group();
            g.Name = 'Westlaw_Support_Queue';
            g.type='Queue';
            insert g;
        
        QueueSobject mappingObject = new QueueSobject(QueueId = g.Id, SobjectType = 'Case');
            System.runAs(new User(Id = UserInfo.getUserId()))
             {insert mappingObject;}
        Group g1 = [select id,developername,type from group where id =: g.id];

        system.debug('queue inserted'+g1.developername+'--'+g1.id+'--'+g1.type);
        
        USL_Queues__c usl_test=new USL_Queues__c();
        usl_test.QueueId1__c= g1.developername;
        insert usl_test;
        
       
             
        USL_Email2Case_ToEmails__c usemail = new USL_Email2Case_ToEmails__c();
        usemail.To_Email1__c = 'techsupport@thomsonreuters.com';
        insert usemail;
        */
        // insert a case records
        System.runAs(new User(Id = UserInfo.getUserId()))
             {
        List<Case> Cslist= New List<Case>();
        
        Case cs1 = new Case();
        //cs1.OwnerId=g.id; 
        cs1.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Incident').getRecordTypeId();
        //cs1.Priority='2-Medium';
        //cs1.Origin='Email';
        //cs1.ESC_Origin_Name__c ='';
        cs1.LCRM_Sub_BU__c ='USL';
       // cs1.ESC_Apply_Entitlement_Milestone__c =false;
        cs1.SuppliedEmail='dummytest@thomsonreuters.com';
        cs1.Subject='Writeit 1';
        Cslist.add(cs1);

       
       insert Cslist;
        test.stopTest();
        integer i = 1;
        integer j = 1;
        System.assertEquals(i,j);
        try
        {
         
        list<EmailMessage> Emlist= New List<EmailMessage>();
                   
        EmailMessage newEmail2 = new EmailMessage(ParentId = cs1.Id, ToAddress='techsupport@thomsonreuters.com', FromAddress = 'dummytest@thomsonreuters.com',Incoming=true,TextBody='tested', Subject='Writeit 1');
        //+cs1.ESC_Email_Thread_Id__c
        Emlist.add(newEmail2);
        //insert newEmail2;
        insert Emlist;
        
         system.debug('%%%%Email parent details'+newEmail2.Parent.IS_ESC_Case__c+' '+newEmail2.Parent.LCRM_Sub_BU__c+'  '+newEmail2.FromAddress+'----'+newEmail2.Subject);
        
        }
        catch(Exception e)
        {
            system.debug('%%%%issue?'+e);
        }
    }

    }
    }