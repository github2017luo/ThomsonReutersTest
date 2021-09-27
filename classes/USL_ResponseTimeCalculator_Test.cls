@isTest
   private class USL_ResponseTimeCalculator_Test {

   
    testMethod static void testmilestone(){
      
        
    Test.StartTest();
        Profile prof = [SELECT Id FROM profile WHERE name='system administrator'];
                        
        UserRole r = [Select Id from UserRole where DeveloperName = 'USL_Customer_Service_Agent_Level_2']; 
        User us =  New User(FirstName = 'James' , LastName= 'ThomasTest',Alias = 'jttest',Email='james.thomastest@thomsonreuters.com', emailencodingkey='UTF-8', 
        UserName='testmilestone@thomsonreuters.com',languagelocalekey='en_US', localesidkey='en_US',Segment__c='Professional Legal',Sub_Bu__c='Canada', 
        profileid = prof.Id,timezonesidkey='America/Los_Angeles',CommunityNickname='James.ThomasTest',UserRoleid=r.id);
        insert us;
        Group grp = new Group(Name='group name', type='Queue');       
        insert grp;        
        QueuesObject q1 = new QueueSObject(QueueID = grp.id, SobjectType = 'Case'); 
                
         system.runas(us) {
         insert q1;
          LTS_Disable_Application_Automation__c dis = new LTS_Disable_Application_Automation__c();
        dis.LTS_Disable_Validation_Rules__c =true;
        insert dis;
     
         Account acct= ESC_GenericTestutility.TestAccountUtil('TestAccount' ,'TestAccount001','7786864710');  
         insert acct;
        
        Contact con= ESC_GenericTestutility.TestContactUtil(acct.id ,'Mile','test@tr.com');
        con.firstname='testfirst';
        con.ESC_tocLanguage__c='English';
        insert con;
                     
         //insert new USL_Case_SLA_Matrix__c(Name='testSLA',USL_Queue__c='testQueue',USL_SLA_Minutes__c=100);         
        
         List<BusinessHours> bhs=[select id from BusinessHours where IsDefault=true]; 
         
        List <Case> ca= new List<Case>();
        Case cs = new Case();
        cs.Type='Data';
        
        cs.Status='Fix Applied';
        cs.Origin='phone';
        cs.Subject='Test Subject';
        cs.businesshoursid = bhs[0].id;
        cs.Description = 'Test Description111';
        cs.contactid=con.id;
        cs.accountid=acct.id;
        cs.BU_Segment__c='Professional Legal';
        cs.LCRM_Sub_BU__c='Canada';
        cs.RecordTypeId =  Schema.SObjectType.Case.getRecordTypeInfosByName().get('Incident').getRecordTypeId();
        cs.Is_GLI__c=true;
        cs.OwnerId=Us.id;
        cs.GGOIsReferralFlag__c =true;
        cs.GGO_Referral_Milestone_Type__c='BR_Billing';
        cs.ESC_LastQueueOwner__c ='';
        ca.add(cs);
        insert ca;
          
        USL_Case_SLA_Matrix__c UslSla=new USL_Case_SLA_Matrix__c();
        UslSla.USL_Queue__c='BR_Billing';
        UslSla.USL_SLA_Minutes__c=100;
        UslSla.USL_Referral_SLA_Minutes__c=10;
        UslSla.name='name';
        UslSla.USL_Autofeed_Check__c=false;
        insert UslSla;
      
      MassValidationSettings__c mvs = new MassValidationSettings__c(Name = 'TR Sales', DisableMassTransfer__c= false);
       insert mvs;
      
       
       
        ESC_Case_Collaborator__c cc = new ESC_Case_Collaborator__c();
        cc.OwnerId = us.id;
        cc.ESC_Case__c = cs.id;
        cc.ESC_Role__c = 'Accountable Resolver';
        cc.ESC_referral_status__c = 'New';
        cc.OwnerId=grp.id;
        //insert cc;
       
        ESC_Case_Collaborator__c cc1 = new ESC_Case_Collaborator__c();
        cc1.ESC_Case__c = cs.id;
        cc1.ESC_Role__c = 'Collaborator';
        cc1.ESC_referral_status__c = 'New';
        cc1.OwnerId = us.id;
        
        USL_ResponseTimeCalculator.getCaseResponseTime(ca);
        }
        test.stoptest();
        }
   
   testMethod static void testmilestone2(){
    Test.StartTest();
    
       
        Profile prof = [SELECT Id FROM profile WHERE name='system administrator'];
                 
        UserRole r = [Select Id from UserRole where DeveloperName = 'USL_Customer_Service_Agent_Level_2']; 
        User us =  New User(FirstName = 'James' , LastName= 'ThomasTest',Alias = 'jttest',Email='james.thomastest@thomsonreuters.com', emailencodingkey='UTF-8', 
        UserName='testmilestone@thomsonreuters.com',languagelocalekey='en_US', localesidkey='en_US',Segment__c='Professional Legal',Sub_Bu__c='Canada', 
        profileid = prof.Id,timezonesidkey='America/Los_Angeles',CommunityNickname='James.ThomasTest',UserRoleid=r.id);
        insert us;
        
        Group grp = new Group(Name='group name', type='Queue');       
        insert grp;
        QueuesObject q1 = new QueueSObject(QueueID = grp.id, SobjectType = 'Case');    
              
        system.runas(us) {
        insert q1;
       LTS_Disable_Application_Automation__c dis = new LTS_Disable_Application_Automation__c();
        dis.LTS_Disable_Validation_Rules__c =true;
        insert dis;
        Account acct= ESC_GenericTestutility.TestAccountUtil('TestAccount' ,'TestAccount001','7786864710');  
        insert acct;
        
        Contact con= ESC_GenericTestutility.TestContactUtil(acct.id ,'Mile','test@tr.com');
        con.firstname='testfirst';
        con.ESC_tocLanguage__c='English';
        insert con;
        
         List<BusinessHours> bhs=[select id from BusinessHours where IsDefault=true]; 
         
        List <Case> ca= new List<Case>();
        Case cs = new Case();
        cs.Type='Data';
        
        cs.Status='Fix Applied';
        cs.Origin='phone';
        cs.Subject='Test Subject';
        cs.businesshoursid = bhs[0].id;
        cs.Description = 'Test Description111';
        cs.contactid=con.id;
        cs.accountid=acct.id;
        cs.BU_Segment__c='Professional Legal';
        cs.LCRM_Sub_BU__c='Canada';
        cs.RecordTypeId =  Schema.SObjectType.Case.getRecordTypeInfosByName().get('Incident').getRecordTypeId();
        cs.Is_GLI__c=true;
        cs.OwnerId=grp.id;
        cs.GGOIsReferralFlag__c =false;
        cs.GGO_Referral_Milestone_Type__c='BR_Billing';
        cs.ESC_LastQueueOwner__c ='';
        ca.add(cs);
        insert ca;
          
        USL_Case_SLA_Matrix__c UslSla=new USL_Case_SLA_Matrix__c();
        UslSla.USL_Queue__c='BR_Billing';
        UslSla.USL_SLA_Minutes__c=100;
        UslSla.name='name';
        UslSla.USL_Autofeed_Check__c=false;
        insert UslSla;
      
      MassValidationSettings__c mvs = new MassValidationSettings__c(Name = 'TR Sales', DisableMassTransfer__c= false);
       insert mvs;
          
        ESC_Case_Collaborator__c cc = new ESC_Case_Collaborator__c();
        cc.OwnerId = us.id;
        cc.ESC_Case__c = cs.id;
        cc.ESC_Role__c = 'Accountable Resolver';
        cc.ESC_referral_status__c = 'New';
        cc.OwnerId=grp.id;
        //insert cc;
       
        ESC_Case_Collaborator__c cc1 = new ESC_Case_Collaborator__c();
        cc1.ESC_Case__c = cs.id;
        cc1.ESC_Role__c = 'Collaborator';
        cc1.ESC_referral_status__c = 'New';
        cc1.OwnerId = us.id;
        
        USL_ResponseTimeCalculator.getCaseResponseTime(ca);
        }
        test.stoptest();
        }
   }