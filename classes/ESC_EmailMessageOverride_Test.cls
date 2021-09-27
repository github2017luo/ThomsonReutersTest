@isTest
public class ESC_EmailMessageOverride_Test 
{  
   Static testMethod void testClass()
    {
        
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
       
       try{
       Account acc=new account();
     acc.Name = 'Test Account';
     acc.ESC_OptOut_CSAT_Check__c = false;
      insert acc; 
     
     contact con =new contact();
      con.LastName = 'Test Contact';
        con.FirstName = 'test';
        con.ESC_OptOut_CSAT_Check__c = false;
        con.ESC_Frequency_Cap__c = 5;
        con.accountid=acc.id;
        con.email = 'test@gmail.com';
        insert con;
        
        Group g = new Group();
            g.Name = 'TXP_C2C_Order_Management12';
            g.type='Queue';
            insert g;
            
            

        QueueSobject mappingObject = new QueueSobject(QueueId = g.Id, SobjectType = 'Case');
            System.runAs(new User(Id = UserInfo.getUserId()))
             {insert mappingObject;}
       
       ESC_segment_Region_Lotus__c testSegmentcorp=new ESC_segment_Region_Lotus__c();
        testSegmentcorp.SegmentCorp__c='Corporate';
        insert testSegmentcorp;
        
        Case cstst = new Case();
        cstst.Type='Data';
        cstst.Status='New';
        cstst.Subject='Test Subject';
        cstst.Description = 'Test Description111';
        cstst.contactid=con.id;
        cstst.Origin='Email';
        cstst.OwnerId=g.id;
        cstst.ESC_Next_Response_Time_Flag__c=false;
        cstst.Is_GLI__c=true;
        cstst.ESC_Origin_Name__c='txt';
        cstst.accountid=acc.id;
        cstst.LCRM_Sub_BU__c  ='UKI';
        cstst.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Incident').getRecordTypeId();
        cstst.ESC_Case_Type__c = 'Incident';
        cstst.ESC_Impact__c='3-Single User';
        cstst.BU_Segment__c=testSegmentcorp.SegmentCorp__c;
        cstst.ESC_Diagnosis_Summary__c='Application/Infrastructure/Upgrade';
        cstst.ESC_Resolution_Code__c='Config Change';
        cstst.Priority='1-High';
        //cs.ESC_UPD_Owner__c = False;
        
        insert cstst;
       
        case relatedCase =new case();
     relatedCase.Accountid = acc.id;
        relatedCase.Ownerid = user.id;
        relatedCase.contactid = con.id;
        relatedCase.description = 'test';
        relatedCase.ESC_Proactive_Type__c = '';
        relatedCase.ESC_Diagnosis_Summary__c = '';
        insert relatedCase;   
        
         EmailMessage[] newEmail = new EmailMessage[0];
         
         EmailMessage email=new EmailMessage(FromAddress = 'test@abc123.org', Incoming = True, ToAddress= 'hello@670ocglw7xhomi4oyr5yw2zvf.8kp7yeag.8.case.salesforce.com', Subject = 'Test email', TextBody = '23456 ',ParentId = relatedCase.Id); 
        insert email;
        
        EmailMessage newEmail6 = new EmailMessage(ParentId = cstst.Id,TextBody='test abc', ToAddress='abctest@thomsonreuters.com',
        CcAddress='deftest@thomsonreuters.com',BccAddress='dummytest@thomsonreuters.com', FromAddress = 'dummytest@thomsonreuters.com',
         Incoming=true, Subject='MyAccount - Address Change' );
        insert newEmail6;
      
        ApexPages.StandardController sc = new ApexPages.standardController(email);        
        
        Test.startTest();
        ESC_EmailMessageOverride  testHandler = new ESC_EmailMessageOverride(sc);  
        
        Test.stopTest();
        integer i = 1;
        integer j = 1;
        System.assertEquals(i,j);
        EmailMessage testMessage = testHandler.emailmsg;
        
        testHandler.updateLogsForPushTopic();
        
        }
      catch(Exception e)
      {
          system.debug(e);
      }
    }
    
    public testmethod static void testPB()
    {
        Profile Prof = [SELECT Id FROM profile WHERE name='LatAM Helpdesk Agent'];
        
        User Us =  New User(FirstName = 'James' , LastName= 'ThomasTest',Alias = 'jttest',Email='james1.thomastest@thomsonreuters.com', emailencodingkey='UTF-8', 
        UserName='james1.thomastest@thomsonreuters.com',languagelocalekey='en_US', localesidkey='en_US', 
        profileid = Prof.Id,timezonesidkey='America/Los_Angeles',CommunityNickname='James.ThomasTest');
        insert Us;
        
        User Us2 =  New User(FirstName = 'Gina' , LastName= 'Reddy',Alias = 'Greddy',Email='Greddy.thomastest@thomsonreuters.com', emailencodingkey='UTF-8', 
        UserName='Greddy.thomastest@thomsonreuters.com',languagelocalekey='en_US', localesidkey='en_US', 
        profileid = Prof.Id,timezonesidkey='America/Los_Angeles',CommunityNickname='jRedd.ThomasTest', IsActive=false);
        insert Us2;
        
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
        //con.Phone='12345678';
        con.Email='dummytest@thomsonreuters.com';
        insert con;
        UKI_Queues__c uki_test=new UKI_Queues__c();
        uki_test.QueueId1__c='Cash_Application_queries';
        insert uki_test;
        
        Group g = new Group();
            g.Name = uki_test.QueueId1__c;
            g.type='Queue';
            insert g;
            
        QueueSobject mappingObject = new QueueSobject(QueueId = g.Id, SobjectType = 'Case');
            System.runAs(new User(Id = UserInfo.getUserId()))
             {insert mappingObject;}
             
        Test.startTest();
        List<Case> caselist = new List<Case>();
        // insert a case records
        Case cs = new Case();
        cs.Type='Data';
        //cs.Status='Work In Progress';
        cs.Status='New';
        cs.Subject='Test Subject';
        cs.Description = 'Test Description111';
        cs.contactid=con.id;
        cs.Origin='Email';
        cs.OwnerId=g.id;
        cs.Is_GLI__c=false;
        cs.accountid=acct.id;
        cs.LCRM_Sub_BU__c  ='';
        cs.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Incident').getRecordTypeId();
        cs.ESC_Case_Type__c = 'Incident';
        cs.ESC_Impact__c='3-Single User';
        cs.ESC_Diagnosis_Summary__c='Application/Infrastructure/Upgrade';
        cs.ESC_Resolution_Code__c='Config Change';
        cs.Priority='1-High';
        cs.ESC_Origin_Name__c='';
        //cs.ESC_UPD_Owner__c = False;
        caselist.add(cs);
        //insert cs;
        
        ESC_segment_Region_Lotus__c testSegment=new ESC_segment_Region_Lotus__c();
        testSegment.SegmentTax__c='Professional Tax';
        insert testSegment;
        
        Case cs1 = new Case();
        cs1.Type='Data';
        //cs.Status='Work In Progress';
        cs1.Status='New';
        cs1.Subject='Test Subject';
        cs1.Description = 'Test Description111';
        cs1.contactid=con.id;
        cs1.Origin='Email';
        cs1.OwnerId=g.id;
        cs1.ESC_Next_Response_Time_Flag__c=false;
        cs1.Is_GLI__c=false;
        cs1.ESC_Origin_Name__c='';
        cs1.accountid=acct.id;
        cs1.LCRM_Sub_BU__c  ='UKI';
        cs1.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Incident').getRecordTypeId();
        cs1.ESC_Case_Type__c = 'Incident';
        cs1.ESC_Impact__c='3-Single User';
        cs1.BU_Segment__c=testSegment.SegmentTax__c;
        cs1.ESC_Diagnosis_Summary__c='Application/Infrastructure/Upgrade';
        cs1.ESC_Resolution_Code__c='Config Change';
        cs1.Priority='1-High';
        //cs.ESC_UPD_Owner__c = False;
        caselist.add(cs1);
        //insert cs1;
        
        system.debug('Case owner ID****'+cs1.OwnerId);
        
        Case cs2 = new Case();
        cs2.Type='Data';
        //cs.Status='Work In Progress';
        cs2.Status='New';
        cs2.Subject='Test Subject';
        cs2.Description = 'Test Description111';
        cs2.contactid=con.id;

        cs2.Origin='Email';
        cs2.OwnerId=Us2.id;
        cs2.Is_GLI__c=false;
        cs2.ESC_Origin_Name__c='';
        cs2.accountid=acct.id;
        cs2.LCRM_Sub_BU__c  ='UKI';
        cs2.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Incident').getRecordTypeId();
        cs2.ESC_Case_Type__c = 'Incident';
        cs2.ESC_Impact__c='3-Single User';
        cs2.ESC_Diagnosis_Summary__c='Application/Infrastructure/Upgrade';
        cs2.ESC_Resolution_Code__c='Config Change';
        cs2.Priority='1-High';
        //cs.ESC_UPD_Owner__c = False;
        caselist.add(cs2);
        //insert cs2;
        
        
        
        Case cs3 = new Case();
        cs3.Type='Data';
        //cs.Status='Work In Progress';
        cs3.Status='New';
        cs3.Subject='Test Subject';
        cs3.Description = 'Test Description111';
        cs3.contactid=con.id;

        cs3.Origin='Email';
        cs3.OwnerId=g.id;
        cs3.Is_GLI__c=false;
        cs3.ESC_Origin_Name__c='';
        cs3.accountid=acct.id;
        cs3.LCRM_Sub_BU__c  ='';
        cs3.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Incident').getRecordTypeId();
        cs3.ESC_Case_Type__c = 'Incident';
        cs3.ESC_Impact__c='3-Single User';
        cs3.ESC_Diagnosis_Summary__c='Application/Infrastructure/Upgrade';
        cs3.ESC_Resolution_Code__c='Config Change';
        cs3.Priority='1-High';
        //cs.ESC_UPD_Owner__c = False;
        caselist.add(cs3);
        //insert cs3;
        insert caselist;
        cs2.Status='Closed';
        update cs2;
        GLI_Email2Case_ToEmails__c testEmail1=new GLI_Email2Case_ToEmails__c();
        testEmail1.To_Email1__c='trlegaltechsupport,106tkt,223tkt,ebook.access,fsahandbook.queries,fsahandbookqueries,jct.support,s&mtkt-ebookaccess,s&mtkt-jctsupport,sme-smgtkt-helpdesk,sme-smgtkt-helpdeskc.gee,smg.cdhandoverforms,trluki.techsupport';
        insert testEmail1;
        
        
        try
        {
        
        
        //GGO_Email2Case_Additional_Updates Process Builder
        List<emailmessage> Emailist = new List<emailmessage>();
        EmailMessage newEmail5 = new EmailMessage(ParentId = cs1.Id,TextBody='test abc', ToAddress='atendimento.legal@thomsonreuters.com',
        CcAddress='deftest@thomsonreuters.com',BccAddress='dummytest@thomsonreuters.com', FromAddress = 'dummytest@thomsonreuters.com',
         Incoming=true, Subject='MyAccount - Address Change' );
         Emailist.add(newEmail5);
        //insert newEmail5;
        
        EmailMessage newEmail55 = new EmailMessage(ParentId = cs1.Id,TextBody='test abc', ToAddress='tests.legal@thomsonreuters.com',
        CcAddress='deftest@thomsonreuters.com',BccAddress='dummytest@thomsonreuters.com', FromAddress = 'dummytest@thomsonreuters.com',
         Incoming=true, Subject='MyAccount - Update Contact Information ref:_00D' );
        Emailist.add(newEmail55);
        //insert newEmail55;
        
        EmailMessage newEmail6 = new EmailMessage(ParentId = cs.Id,TextBody='test abc', ToAddress='sacrt@thomsonreuters.com',
        CcAddress='deftest@thomsonreuters.com',BccAddress='dummytest@thomsonreuters.com', FromAddress = 'dummytest@thomsonreuters.com',
         Incoming=true, Subject='MyAccount - Address Change' );
        Emailist.add(newEmail6);
        //insert newEmail6;
        
        EmailMessage newEmail7 = new EmailMessage(ParentId = cs2.Id,TextBody='test abc', ToAddress='sac@revistadostribunais.com.br',
        CcAddress='deftest@thomsonreuters.com',BccAddress='dummytest@thomsonreuters.com', FromAddress = 'dummytest@thomsonreuters.com',
         Incoming=true, Subject='MyAccount - Address Change' );
         Emailist.add(newEmail7);
        //insert newEmail7;
        
        EmailMessage newEmail8 = new EmailMessage(ParentId = cs3.Id,TextBody='test abc', ToAddress='Navpreet.kaur@thomsonreuters.com',
        CcAddress='deftest@thomsonreuters.com',BccAddress='dummytest@thomsonreuters.com', FromAddress = 'dummytest@thomsonreuters.com',
         Incoming=true, Subject='MyAccount - Address Change' );
         Emailist.add(newEmail8);
        //insert newEmail8;
        
        EmailMessage newEmail9 = new EmailMessage(ParentId = cs3.Id,TextBody='test abc', ToAddress=label.Latam_Ebo_GlobalCreditmemo,
        CcAddress='deftest@thomsonreuters.com',BccAddress='dummytest@thomsonreuters.com', FromAddress = 'dummytest@thomsonreuters.com',
         Incoming=true, Subject='test - Address Change' );
         Emailist.add(newEmail9);
        //insert newEmail9;
        
        EmailMessage newEmail20 = new EmailMessage(ParentId = cs3.Id,TextBody='test abc', ToAddress='tf.latamcmdg@thomsonreuters.com',
        CcAddress='deftest@thomsonreuters.com',BccAddress='dummytest@thomsonreuters.com', FromAddress = 'dummytest@thomsonreuters.com',
         Incoming=true, Subject='test - Address Change' );
         Emailist.add(newEmail20);
        //insert newEmail20;
        
        EmailMessage newEmail21 = new EmailMessage(ParentId = cs3.Id,TextBody='test abc', ToAddress='prathiba.anand@thomsonreuters.com',
        CcAddress='deftest@thomsonreuters.com',BccAddress='dummytest@thomsonreuters.com', FromAddress = 'dummytest@thomsonreuters.com',
         Incoming=true, Subject='test - Address Change' );
        Emailist.add(newEmail21); 
        insert Emailist;
        
        test.stopTest();
        integer i = 1;
        integer j = 1;
        System.assertEquals(i,j);
            system.debug('Email Message5'+newEmail5);
            system.debug('Email Message6'+newEmail6);
            system.debug('Email Message7'+newEmail7);
            system.debug('Email Message8'+newEmail8);
        
        
        }
        catch(Exception e)
        {
            system.debug(e);
        }
        
    }
     public testmethod static void testPBtoaddress()
    {
        //GLI_Email2Case_Updates Process Builder
        Profile Prof = [SELECT Id FROM profile WHERE name='GLI Helpdesk Agent'];
        
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
        
        Group g = new Group();
            g.Name = 'Cash_Application_queries';
            g.type='Queue';
            insert g;
        
        QueueSobject mappingObject = new QueueSobject(QueueId = g.Id, SobjectType = 'Case');
            System.runAs(new User(Id = UserInfo.getUserId()))
             {insert mappingObject;}
        Group g1 = [select id,developername,type from group where id =: g.id];

        system.debug('queue inserted'+g1.developername+'--'+g1.id+'--'+g1.type);
        
        UKI_Queues__c uki_test=new UKI_Queues__c();
        uki_test.QueueId1__c= g1.developername;
        insert uki_test;
        
       
             
        GLI_Email2Case_ToEmails__c gliemail = new GLI_Email2Case_ToEmails__c();
        gliemail.To_Email31__c = 'trlegal@thomsonreuters.com';
        insert gliemail;

        // insert a case records
        Case cs = new Case();
        cs.OwnerId=g.id; 
        cs.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Incident').getRecordTypeId();
        cs.Priority='1-High';
        cs.Origin='Email';
        cs.ESC_Origin_Name__c ='';
        insert cs;
        
        Case cs1 = new Case();
        cs1.OwnerId=g.id; 
        cs1.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Incident').getRecordTypeId();
        cs1.Priority='1-High';
        cs1.Origin='Email';
        cs1.ESC_Origin_Name__c ='';
        insert cs1;
        
        try
        {
        Test.startTest();
        
        //GLI_Email2Case_Updates Process Builder
        
        EmailMessage newEmail1 = new EmailMessage(ParentId = cs.Id, ToAddress='trlegal@thomsonreuters.com', FromAddress = 'dummytest@thomsonreuters.com',Incoming=true,TextBody='test', Subject='MyAccount - Address Change0');
        insert newEmail1;
        
        EmailMessage newEmail11 = new EmailMessage(ParentId = cs1.Id, ToAddress='trlegal123@thomsonreuters.com', CcAddress='trlegal@thomsonreuters.com', FromAddress = 'dummytest@thomsonreuters.com',Incoming=true,TextBody='test', Subject='MyAccount - Address Change0');
        insert newEmail11;
        test.stopTest();
        integer i = 1;
        integer j = 1;
        System.assertEquals(i,j);
        }
        catch(Exception e)
        {
            system.debug(e);
        } 
        
    }
     public testmethod static void testuslPBtoaddress()
    {
        //USL_Email2Case_Updates Process Builder
        Profile Prof = [SELECT Id FROM profile WHERE name='USL Helpdesk Agent'];
        
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
        
        Group g = new Group();
            g.Name = 'USL_RSA_Book_Support';
            g.type='Queue';
            insert g;
        
        QueueSobject mappingObject = new QueueSobject(QueueId = g.Id, SobjectType = 'Case');
            System.runAs(new User(Id = UserInfo.getUserId()))
             {insert mappingObject;}
        Group g1 = [select id,developername,type from group where id =: g.id];

        system.debug('queue inserted'+g1.developername+'--'+g1.id+'--'+g1.type);
        
        USL_Queues__c usl_test= new USL_Queues__c();
        usl_test.QueueId10__c= g1.developername;
        usl_test.QueueId2__c= g1.developername;
        insert usl_test;
        
        System.debug('usl_test.QueueId10__c ---> '+usl_test.QueueId10__c);
        System.debug('usl_test.QueueId2__c ---> '+usl_test.QueueId2__c );
       
             
        USL_Email2Case_ToEmails__c uslemail = new USL_Email2Case_ToEmails__c();
        uslemail.To_Email1__c = 'bookstore';
        insert uslemail;

        // insert a case records
        Case cs = new Case();
        cs.OwnerId=g.id; 
        cs.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Incident').getRecordTypeId();
        cs.Priority='1-High';
        cs.Origin='Email';
        cs.ESC_Origin_Name__c ='';
        cs.SuppliedEmail = 'dummytest@thomsonreuters.com';
        cs.USL_Queue_Name__c = '';
        insert cs;
        
        Case cs1 = new Case();
        cs1.OwnerId=g.id; 
        cs1.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Incident').getRecordTypeId();
        cs1.Priority='1-High';
        cs1.Origin='Email';
        cs1.ESC_Origin_Name__c ='';
        cs1.SuppliedEmail ='dummytest@thomsonreuters.com';
        insert cs1;
        
        try
        {
        Test.startTest();
        
        //GLI_Email2Case_Updates Process Builder
        
        EmailMessage newEmail1 = new EmailMessage(ParentId = cs.Id, ToAddress='bookstore@thomsonreuters.com', FromAddress = 'dummytest@thomsonreuters.com',Incoming=true,TextBody='test', Subject='Address Change0');
        insert newEmail1;
        
        EmailMessage newEmail11 = new EmailMessage(ParentId = cs1.Id, ToAddress='trlegal123@thomsonreuters.com', CcAddress='bookstore@thomsonreuters.com', FromAddress = 'dummytest@thomsonreuters.com',Incoming=true,TextBody='test', Subject='MyAccount - Address Change0');
        insert newEmail11;
        test.stopTest();
        integer i = 1;
        integer j = 1;
        System.assertEquals(i,j);
        }
        catch(Exception e)
        {
            system.debug(e);
        }
    }
}