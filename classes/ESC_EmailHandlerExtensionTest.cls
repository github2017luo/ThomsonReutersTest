@isTest
public class ESC_EmailHandlerExtensionTest 
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
      
        ApexPages.StandardController sc = new ApexPages.standardController(email);        
        
        Test.startTest();
        ESC_EmailHandlerExtension  testHandler = new ESC_EmailHandlerExtension(sc);  
        
        Test.stopTest();
        
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
    try{
    
        Profile Prof = [SELECT Id FROM profile WHERE name='System Administrator'];
        
        User Us =  New User(FirstName = 'James' , LastName= 'ThomasTest',Alias = 'jttest',Email='james1.thomastest@thomsonreuters.com', emailencodingkey='UTF-8', 
        UserName='james1.thomastest@thomsonreuters.com',languagelocalekey='en_US', localesidkey='en_US', 
        profileid = Prof.Id,timezonesidkey='America/Los_Angeles',CommunityNickname='James.ThomasTest');
        insert Us;
        
        User Us1 =  New User(FirstName = 'Madan' , LastName= 'Jenkin',Alias = 'Mjkin',Email='Madan123.thomastest@thomsonreuters.com',
         emailencodingkey='UTF-8', 
        UserName='Madan.jenkin@thomsonreuters.com',languagelocalekey='en_US', localesidkey='en_US', 
        profileid = Prof.Id,timezonesidkey='America/Los_Angeles',CommunityNickname='Madan.Jenkin');
        insert Us1;
        
        test.starttest();
        //fill account
        Account testAccount1=new Account(Name= 'testName',ShippingCity= 'testCity',ShippingCountry= 'IN',ShippingStreet='testStreet');
        insert testAccount1;
        
        //fill contact
        Contact testContact1=new Contact (AccountId = testAccount1.id,firstname= 'John',lastname= 'Mile',email = 'abc@tr.com', phone='7786864710');
        testContact1.ESC_tocContactStatus__c = 'Inactive';
        insert testContact1;
        
                Id recordid=Schema.SObjectType.Case.getRecordTypeInfosByName().get('Incident').getRecordTypeId();
        
        Case cs_testPB3 = new Case(AccountId=testAccount1.Id,ContactId=testContact1.Id,RecordtypeID=recordid,Status='New'); 
        cs_testPB3.Origin='Web';
        cs_testPB3.LCRM_Sub_BU__c='GGO';
        insert cs_testPB3;
        
        Group que = new Group();
            que.Name = 'Solcara_UKI_Support';
            que.type='Queue';
            insert que;

        QueueSobject mappingObject = new QueueSobject(QueueId = que.Id, SobjectType = 'Case');
            System.runAs(new User(Id = UserInfo.getUserId()))
             {insert mappingObject;}

        

        Case cs_testPB4 = new Case(AccountId=testAccount1.Id,ContactId=testContact1.Id,RecordtypeID=recordid,Status='New'); 
        cs_testPB4.Origin='Web';
        cs_testPB4.LCRM_Sub_BU__c='UKI';
        cs_testPB4.RecordtypeID=recordid;
        cs_testPB4.Is_GLI__c=true;
        cs_testPB4.ParentId='';
        cs_testPB4.OwnerId=que.Id;
        cs_testPB4.ESC_UKI_WebForm_Rep_Email__c='Dummy@gmail.com';
        cs_testPB4.SuppliedEmail='Dummymail123@gmail.com';
        insert cs_testPB4;
        
        
        
        Case cs_testPB5 = new Case(AccountId=testAccount1.Id,ContactId=testContact1.Id,RecordtypeID=recordid,Status='New'); 
        cs_testPB5.Origin='Email';
        cs_testPB5.LCRM_Sub_BU__c='GGO';
        cs_testPB5.ESC_Impact__c = '1-Whole Site';
        cs_testPB5.RecordtypeID=recordid;
        cs_testPB5.Is_GLI__c=false;
        cs_testPB5.ParentId='';
        cs_testPB5.subject='tst';
        cs_testPB5.ESC_Diagnosis_Summary__c='Cancellation';
        cs_testPB5.OwnerId=que.Id;
        cs_testPB5.Priority='3 - Low';
        cs_testPB5.Description='test';
        cs_testPB5.ESC_UKI_WebForm_Rep_Email__c='Dummy@gmail.com';
        cs_testPB5.SuppliedEmail='Dummymail123@gmail.com';
        insert cs_testPB5;
        
        cs_testPB5.ESC_Diagnosis_Summary__c='Collection';
        update cs_testPB5;
        
        
        test.stoptest();
        }
        catch(Exception e)
        {
            system.debug(e);
        }
    }
    static testmethod void testPB_Additionalupdates()
    {
    
         Account testAccount = ESC_GenericTestutility.TestAccountUtil('TestAccount' ,'TestAccount001','7786864710');  
      insert testAccount;
    
      //insert contact data
      Contact testContact = ESC_GenericTestutility.TestContactUtil(testAccount.id ,'Mile','test@tr.com');
        testContact.FirstName='hello'; 
      insert testContact;
      
      ESC_segment_Region_Lotus__c testLotus=new ESC_segment_Region_Lotus__c();
      testLotus.SegmentTax__c='Professional Tax';
      insert testLotus;
      
      Group g = new Group();
            g.Name = 'TXP_C2C_Order_Management12';
            g.type='Queue';
            insert g;

        QueueSobject mappingObject = new QueueSobject(QueueId = g.Id, SobjectType = 'Case');
            System.runAs(new User(Id = UserInfo.getUserId()))
             {insert mappingObject;}
      
         Case objCase1 = new Case();
        objCase1 = UnitTest.getCaseInstance();
        objCase1.Status = 'new';
        objCase1.origin='Email';
        objCase1.BU_Segment__c=testLotus.SegmentTax__c;
        objCase1.OwnerId=g.id;
        objCase1.BU_Segment__c='';
        objCase1.account=testAccount;
        objCase1.contact=testContact;
        INSERT objCase1;
        
        Case objCase2 = new Case();
        objCase2 = UnitTest.getCaseInstance();
        objCase2.Status = 'new';
        objCase2.BU_Segment__c=testLotus.SegmentTax__c;
        objCase2.origin='Email';
        objCase2.OwnerId=g.id;
         objCase2.account=testAccount;
        objCase2.contact=testContact;
        INSERT objCase2;
        
        Case objCase3 = new Case();
        objCase3 = UnitTest.getCaseInstance();
         objCase3.account=testAccount;
         objCase3.BU_Segment__c=testLotus.SegmentTax__c;
         objCase3.origin='Email';
        objCase3.OwnerId=g.id;
        objCase3.contact=testContact;
        objCase3.Status = 'new';
        INSERT objCase3;
        
        Case objCase4 = new Case();
        objCase4 = UnitTest.getCaseInstance();
        objCase4.BU_Segment__c=testLotus.SegmentTax__c;
        objCase4.origin='Email';
        objCase4.OwnerId=g.id;
        objCase4.account=testAccount;
        objCase4.contact=testContact;
        objCase4.Status = 'new';
        INSERT objCase4;
        
        test.starttest();
        List<EmailMessage> emails=new List<EmailMessage>();
        EmailMessage newEmail5 = new EmailMessage(ParentId = objCase1.Id,TextBody='test abc', ToAddress='atendimento.legal@thomsonreuters.com',
        CcAddress='deftest@thomsonreuters.com',BccAddress='dummytest@thomsonreuters.com', FromAddress = 'dummytest@thomsonreuters.com',
         Incoming=true, Subject='MyAccount - Address Change' );
         emails.add(newEmail5);
        
        EmailMessage newEmail6 = new EmailMessage(ParentId = objCase2.Id,TextBody='test abc', ToAddress='sacrt@thomsonreuters.com',
        CcAddress='deftest@thomsonreuters.com',BccAddress='dummytest@thomsonreuters.com', FromAddress = 'dummytest@thomsonreuters.com',
         Incoming=true, Subject='MyAccount - Address Change' );
         emails.add(newEmail6);
        
        EmailMessage newEmail7 = new EmailMessage(ParentId = objCase3.Id,TextBody='test abc', ToAddress='sac@revistadostribunais.com.br',
        CcAddress='deftest@thomsonreuters.com',BccAddress='dummytest@thomsonreuters.com', FromAddress = 'dummytest@thomsonreuters.com',
         Incoming=true, Subject='MyAccount - Address Change' );
                 emails.add(newEmail7);
        
        EmailMessage newEmail8 = new EmailMessage(ParentId = objCase4.Id,TextBody='test abc', ToAddress='Navpreet.kaur@thomsonreuters.com',
        CcAddress='deftest@thomsonreuters.com',BccAddress='dummytest@thomsonreuters.com', FromAddress = 'dummytest@thomsonreuters.com',
         Incoming=true, Subject='MyAccount - Address Change' );
                 emails.add(newEmail8);
                 
                 insert emails;
        test.stoptest();
    }
}