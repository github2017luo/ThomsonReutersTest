@isTest
public class LCRMMassEditTrainingContacts_Test{

@testSetup static void testDataSetUp() {

    RecordType teRT = [select id from recordtype where name ='GLI' and sobjecttype='Training_Event__c' limit 1];
    RecordType accountRT = [select id from recordtype where name ='GLI Account' and sobjecttype='Account' limit 1]; 
    Recordtype contactRT = [select id from recordtype where name ='GLI Contact' and sobjecttype='Contact' limit 1]; 
    
    
    Training_Event__c gliTE = UnitTest.getTrainingEventInstance();
    gliTE.LCRM_Is_GLI__c = true;
    gliTE.LCRM_Sub_Bu__c = 'UKI';
    gliTE.RecordTypeId = teRT.Id;
    insert gliTE;
    
    Account gliAccount = UnitTest.getAccountInstance();
    gliAccount.Is_GLI__c = true;
    gliAccount.RecordTypeId = accountRT.Id;
    insert gliAccount;
    
    Contact gliContact1 = UnitTest.getContactInstance(gliAccount.Id);
    gliContact1.LastName = 'Test Contact 1';
    gliContact1.RecordTypeId = contactRT.id;
    gliContact1.Email = 'saloni.sukhija@thomsonreuters.com';
    insert gliContact1;
    
    Contact gliContact2 = UnitTest.getContactInstance(gliAccount.Id);
    gliContact2.LastName = 'Test Contact 2';
    gliContact2.RecordTypeId = contactRT.id;
    gliContact2.Email = 'saloni.sukhija@tcs.com';
    insert gliContact2;
    
    Contact gliContact3 = UnitTest.getContactInstance(gliAccount.Id);
    gliContact3.LastName = 'Test Contact 3';
    gliContact3.RecordTypeId = contactRT.id;
    insert gliContact3;
    
    Training_Event_Contact__c tec1 = new Training_Event_Contact__c(Training_Event__c=gliTe.Id, Contact_Name__c=gliContact1.Id,LCRM_Send_Survey__c =true,LCRM_Send_Reminder__c =true );
    insert tec1;
    
    Training_Event_Contact__c tec2 = new Training_Event_Contact__c(Training_Event__c=gliTe.Id, Contact_Name__c=gliContact2.Id,LCRM_Send_Survey__c =true,LCRM_Send_Reminder__c =true );
    insert tec2;
    
    Training_Event_Contact__c tec3 = new Training_Event_Contact__c(Training_Event__c=gliTe.Id, Contact_Name__c=gliContact3.Id,LCRM_Send_Survey__c =true,LCRM_Send_Reminder__c =true );
    insert tec3;
  }
  
  @isTest public static void testMassEdit(){
        Training_Event__c gliTE = [SELECT Id,ownerid FROM Training_Event__c WHERE LCRM_Sub_Bu__c LIKE 'UKI' LIMIT 1];
        List<Training_Event_Contact__c> trainingEventContacts = [SELECT Id FROM Training_Event_Contact__c];
        
        PageReference oPage = Page.LCRMMassEditTrainingContacts;
        Test.setCurrentPage(oPage);
        ApexPages.currentPage().getParameters().put('id', gliTE.Id);
        ApexPages.currentPage().getParameters().put('param1', 'true');
        
        ApexPages.StandardSetController sc1 = new ApexPages.StandardSetController(trainingEventContacts);
        sc1.setSelected(trainingEventContacts);              
        LCRMMassEditTrainingContacts controller = new LCRMMassEditTrainingContacts(new ApexPages.StandardSetController(trainingEventContacts));
        
        controller.listTrainingEventContacts[0].bSelected = true;
        controller.listTrainingEventContacts[1].bSelected = true;
        controller.oPagingContacts.moveNext(); 
        controller.oPagingContacts.movePrev(); 
        
        Test.startTest();
            controller.getTrngEvntId();
            controller.toggleSort();
            controller.toggleSort();
            controller.SaveMassDate();
            controller.Save();
            //controller.getNamesOfContacts();
            controller.sendSurvey();
            controller.sendReminder();
            System.assert(controller.listTrainingEventContacts.size()==3,controller.listTrainingEventContacts);
            System.assert(controller.listTrainingEventContacts[0].oTrainingEventContact.Trained__c==true,'Trained not set to true');
            System.assert(controller.listTrainingEventContacts[1].oTrainingEventContact.Trained__c==true,'Trained not set to true');
        Test.stopTest();
    }
    
   /* @isTest public static void testMassEditWithNoContacts(){
        Training_Event__c gliTE = [SELECT Id,ownerid FROM Training_Event__c WHERE LCRM_Sub_Bu__c LIKE 'UKI' LIMIT 1];
        List<Training_Event_Contact__c> trainingEventContacts = [SELECT Id FROM Training_Event_Contact__c];
        delete trainingEventContacts;
        PageReference oPage = Page.LCRMMassEditTrainingContacts;
        Test.setCurrentPage(oPage);
        ApexPages.currentPage().getParameters().put('id', gliTE.Id);
        ApexPages.currentPage().getParameters().put('param1', 'true');
        
        ApexPages.StandardSetController sc1 = new ApexPages.StandardSetController(trainingEventContacts);
        sc1.setSelected(trainingEventContacts);              
        LCRMMassEditTrainingContacts controller = new LCRMMassEditTrainingContacts(new ApexPages.StandardSetController(trainingEventContacts));
        
        System.assert(controller.listTrainingEventContacts.size()==0,controller.listTrainingEventContacts);
    }*/
    
    @isTest public static void testRemoveSelectedWithSomeContacts(){
        Training_Event__c gliTE = [SELECT Id,ownerid FROM Training_Event__c WHERE LCRM_Sub_Bu__c LIKE 'UKI' LIMIT 1];
        List<Training_Event_Contact__c> trainingEventContacts = [SELECT Id FROM Training_Event_Contact__c];
        
        PageReference oPage = Page.LCRMMassEditTrainingContacts;
        Test.setCurrentPage(oPage);
        ApexPages.currentPage().getParameters().put('id', gliTE.Id);
        ApexPages.currentPage().getParameters().put('param1', 'true');
        
        ApexPages.StandardSetController sc1 = new ApexPages.StandardSetController(trainingEventContacts);
        sc1.setSelected(trainingEventContacts);              
        LCRMMassEditTrainingContacts controller = new LCRMMassEditTrainingContacts(new ApexPages.StandardSetController(trainingEventContacts));
        
        controller.listTrainingEventContacts[0].bSelected = true;
        
        Test.startTest();
            controller.RemoveSelected();
            System.assert(controller.listTrainingEventContacts.size()==2,controller.listTrainingEventContacts);
        Test.stopTest();
    }
    
    @isTest public static void testRemoveSelectedWithAllContacts(){
        Training_Event__c gliTE = [SELECT Id,ownerid FROM Training_Event__c WHERE LCRM_Sub_Bu__c LIKE 'UKI' LIMIT 1];
        List<Training_Event_Contact__c> trainingEventContacts = [SELECT Id FROM Training_Event_Contact__c];
        
        PageReference oPage = Page.LCRMMassEditTrainingContacts;
        Test.setCurrentPage(oPage);
        ApexPages.currentPage().getParameters().put('id', gliTE.Id);
        ApexPages.currentPage().getParameters().put('param1', 'true');
        
        ApexPages.StandardSetController sc1 = new ApexPages.StandardSetController(trainingEventContacts);
        sc1.setSelected(trainingEventContacts);              
        LCRMMassEditTrainingContacts controller = new LCRMMassEditTrainingContacts(new ApexPages.StandardSetController(trainingEventContacts));
        
        controller.listTrainingEventContacts[0].bSelected = true;
        controller.listTrainingEventContacts[1].bSelected = true;
        controller.listTrainingEventContacts[2].bSelected = true;
        
        Test.startTest();
            controller.RemoveSelected();
            System.assert(controller.listTrainingEventContacts.size()==0,controller.listTrainingEventContacts);
        Test.stopTest();
    }
    
    @isTest public static void testSaveAndReturn(){
        Training_Event__c gliTE = [SELECT Id,ownerid FROM Training_Event__c WHERE LCRM_Sub_Bu__c LIKE 'UKI' LIMIT 1];
        List<Training_Event_Contact__c> trainingEventContacts = [SELECT Id FROM Training_Event_Contact__c];
        
        PageReference oPage = Page.LCRMMassEditTrainingContacts;
        Test.setCurrentPage(oPage);
        ApexPages.currentPage().getParameters().put('id', gliTE.Id);
        ApexPages.currentPage().getParameters().put('param1', 'true');
        
        ApexPages.StandardSetController sc1 = new ApexPages.StandardSetController(trainingEventContacts);
        sc1.setSelected(trainingEventContacts);              
        LCRMMassEditTrainingContacts controller = new LCRMMassEditTrainingContacts(new ApexPages.StandardSetController(trainingEventContacts));
        
        controller.listTrainingEventContacts[0].bSelected = true;
                
        Test.startTest();
            controller.SaveAndReturn();
            System.assert(controller.listTrainingEventContacts.size()==3,controller.listTrainingEventContacts);
        Test.stopTest();
    }
    
     // Harika - 29/12/2017 Added for code coverage
    @isTest public static void testMassEditwithuki(){
         Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        
        
        User u = new User(Alias = 'test', Email='testuser@thomsonreuters.com',EmailEncodingKey ='UTF-8', LastName ='Testing', LanguageLocaleKey='en_US',LocaleSidKey='en_US', ProfileId = p.Id,TimeZoneSidKey='America/Los_Angeles',UserName='testuser@trpcorelegal.com',Sub_Bu__c='UKI');
        insert u;
        System.runAs(u)
         { 
       
        Training_Event__c gliTE = [SELECT Id,ownerid FROM Training_Event__c WHERE LCRM_Sub_Bu__c LIKE 'UKI' LIMIT 1];
        List<Training_Event_Contact__c> trainingEventContacts = [SELECT Id FROM Training_Event_Contact__c];
        
        PageReference oPage = Page.LCRMMassEditTrainingContacts;
        Test.setCurrentPage(oPage);
        ApexPages.currentPage().getParameters().put('id', gliTE.Id);
        ApexPages.currentPage().getParameters().put('param1', 'true');
        
        ApexPages.StandardSetController sc1 = new ApexPages.StandardSetController(trainingEventContacts);
        sc1.setSelected(trainingEventContacts);              
        LCRMMassEditTrainingContacts controller = new LCRMMassEditTrainingContacts(new ApexPages.StandardSetController(trainingEventContacts));
        
        controller.listTrainingEventContacts[0].bSelected = true;
        controller.listTrainingEventContacts[1].bSelected = true;
        controller.oPagingContacts.moveNext(); 
        controller.oPagingContacts.movePrev(); 
        
        Test.startTest();
            controller.getTrngEvntId();
            controller.toggleSort();
            controller.toggleSort();
            controller.SaveMassDate();
            controller.Save();
            //controller.getNamesOfContacts();
            controller.sendSurvey();
            //controller.sendReminder();
            System.assert(controller.listTrainingEventContacts.size()==3,controller.listTrainingEventContacts);
            System.assert(controller.listTrainingEventContacts[0].oTrainingEventContact.Trained__c==true,'Trained not set to true');
            System.assert(controller.listTrainingEventContacts[1].oTrainingEventContact.Trained__c==true,'Trained not set to true');
        Test.stopTest();
    }
    }
    
    // Harika - 29/12/2017 Added for code coverage
    @isTest public static void testMassEditwithusl(){
         Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        
        
        User u = new User(Alias = 'test', Email='testuser@thomsonreuters.com',EmailEncodingKey ='UTF-8', LastName ='Testing', LanguageLocaleKey='en_US',LocaleSidKey='en_US', ProfileId = p.Id,TimeZoneSidKey='America/Los_Angeles',UserName='testuser@trpcorelegal.com',Sub_Bu__c='USL');
        insert u;
        System.runAs(u)
         { 
       
        Training_Event__c gliTE = [SELECT Id,ownerid FROM Training_Event__c WHERE LCRM_Sub_Bu__c LIKE 'UKI' LIMIT 1];
        List<Training_Event_Contact__c> trainingEventContacts = [SELECT Id FROM Training_Event_Contact__c];
        
        PageReference oPage = Page.LCRMMassEditTrainingContacts;
        Test.setCurrentPage(oPage);
        ApexPages.currentPage().getParameters().put('id', gliTE.Id);
        ApexPages.currentPage().getParameters().put('param1', 'true');
        
        ApexPages.StandardSetController sc1 = new ApexPages.StandardSetController(trainingEventContacts);
        sc1.setSelected(trainingEventContacts);              
        LCRMMassEditTrainingContacts controller = new LCRMMassEditTrainingContacts(new ApexPages.StandardSetController(trainingEventContacts));
        
        controller.listTrainingEventContacts[0].bSelected = true;
        controller.listTrainingEventContacts[1].bSelected = true;
        controller.oPagingContacts.moveNext(); 
        controller.oPagingContacts.movePrev(); 
        
        Test.startTest();
            controller.getTrngEvntId();
            controller.toggleSort();
            controller.toggleSort();
            controller.SaveMassDate();
            controller.Save();
            //controller.getNamesOfContacts();
            controller.sendSurvey();
            controller.sendReminder();
            System.assert(controller.listTrainingEventContacts.size()==3,controller.listTrainingEventContacts);
            System.assert(controller.listTrainingEventContacts[0].oTrainingEventContact.Trained__c==true,'Trained not set to true');
            System.assert(controller.listTrainingEventContacts[1].oTrainingEventContact.Trained__c==true,'Trained not set to true');
        Test.stopTest();
    }
    }
     
}