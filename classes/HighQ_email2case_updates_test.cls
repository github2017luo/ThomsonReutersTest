@isTest
public Class HighQ_email2case_updates_test{

 

    public static testmethod void testmethod1(){
    
    Profile prof = [SELECT Id FROM profile WHERE name='System Administrator']; 
        
        User us =  New User(FirstName = 'James1' , LastName= 'ThomasTest',Alias = 'jttest',Email='jas11.thomastest@thomsonreuters.com', emailencodingkey='UTF-8', 
        UserName='jamesxyz1.thomastest1@thomsonreuters.com',languagelocalekey='en_US', localesidkey='en_US', 
        profileid = prof.Id,timezonesidkey='America/Los_Angeles',CommunityNickname='JameThomasTest');
        insert us;
        
        Account testAccount = ESC_GenericTestutility.TestAccountUtil('TestAccount' ,'TestAccount001','7786864710');  
      insert testAccount;
    
      //insert contact data
      Contact testContact = ESC_GenericTestutility.TestContactUtil(testAccount.id ,'Mile','Dummy@thomsonreuters.com');
        testContact.FirstName='hello'; 
      insert testContact;
        
        List <User> usrlst= new List<User>();
        usrlst.add(us);
        //Group que=[select Id from Group where  Type = 'Queue' AND DeveloperNAME = 'ESC_Commission_Generic_Chat'];
        
        Group que = new Group();
            que.Name = 'ESC_Commission_Generic_Chat';
            que.type='Queue';
            insert que;

        QueueSobject mappingObject = new QueueSobject(QueueId = que.Id, SobjectType = 'Case');
            System.runAs(new User(Id = UserInfo.getUserId()))
             {insert mappingObject;}
        
     List <Case> ca= new List<Case>();
      Case cs = new Case();
     cs.Origin= 'Email';
     cs.OwnerId=us.Id;
     cs.BU_Segment__c= 'Professional Legal';
     ca.add(cs);
     insert ca;
     
        Id recordId=Schema.SObjectType.Case.getRecordTypeInfosByName().get('Incident').getRecordTypeId();
     
     
     
     ESC_segment_Region_Lotus__c seg = new ESC_segment_Region_Lotus__c();     
     seg.SegmentLegal__c = 'Professional Legal';       
     insert seg ;
     
     Case cstest = new Case();
     cstest.Origin= 'Email';
     cstest.Account=testAccount;
     cstest.Contact=testContact;
     cstest.OwnerId=que.Id;
     cstest.RecordtypeID=recordId;
     cstest.Is_GLI__c=true;
     cstest.BU_Segment__c= seg.SegmentLegal__c;

     insert cstest;
     
     Case cstest2 = new Case();
     cstest2.Origin= 'Email';
     cstest2.Account=testAccount;
     cstest2.Contact=testContact;
     cstest2.OwnerId=que.Id;
     cstest2.RecordtypeID=recordId;
     cstest2.Is_GLI__c=true;
     cstest2.BU_Segment__c= seg.SegmentLegal__c;
     cstest2.LCRM_Sub_BU__c='US';
     cstest2.ESC_Next_Response_Time_Flag__c=false;

     insert cstest2;
     
     test.startTest();
     EmailMessage newEmail1 = new EmailMessage(ParentId = cstest.Id, FromAddress = 'dummytest@thomsonreuters.com',Incoming=true,TextBody='test', Subject='MyAccount - Address Change');
        insert newEmail1;

         EmailMessage newEmail2 = new EmailMessage(ParentId = cstest2.Id, FromAddress = 'dummytest@thomsonreuters.com',Incoming=false,TextBody='test', Subject='MyAccount - Address Change',
          ToAddress='Dummy@thomsonreuters.com', CcAddress='Dummy@thomsonreuters.com',BccAddress='Dummy2@thomsonreuters.com');
        insert newEmail2;
        
        test.stopTest();    
     
     
     
  }   
}