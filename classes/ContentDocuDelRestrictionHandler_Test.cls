/**
* Test Class for ContentDocuDelRestrictionHandler and contentdoculinktrigger
* CHANGE HISTORY
* =============================================================================
* Date         Name                    Description
* 2020-10-29   Miriam Ghosh            Created     
* =============================================================================
*/

@isTest
public class ContentDocuDelRestrictionHandler_Test {
    
    //@isTest public static void testCheckStage()
     static testMethod void testCheckFunctionality()
    {
        //Test.startTest();
        set<Id> cdlLinkId = new set<Id>();
        Profile stdProfile = [SELECT Id,name FROM Profile WHERE Name='LatAm User' limit 1];
        
          User testUser = new User(
              Alias = 'standt', 
              Email='abc1@testorg.com',
              EmailEncodingKey='UTF-8', 
              LastName='Testing', 
              LanguageLocaleKey='en_US',
              LocaleSidKey='en_US', 
              ProfileId = stdProfile.Id,
              TimeZoneSidKey='America/Los_Angeles',
              Sub_Bu__c ='UKI',
              Sales_Org__c = 'LRA',
              UserName='abc1@testorg.com'
              );

        /*Profile_List__c objPro1 = new Profile_List__c();
        objPro1.name = 'LatAm User';
        objPro1.Profile_Name__c = 'LatAm User';
        objPro1.ProfileId__c = stdProfile.id;*/
        //objPro1.ProfileId__c = '00ea00000024JzKAAU';
        
        /*Profile_List__c objPro2 = new Profile_List__c();
        objPro2.name = 'System Administrator';
        objPro2.Profile_Name__c = 'System Administrator';
        objPro2.ProfileId__c = '00e30000001gFezAAE';*/
        //INSERT new List<Profile_List__c>{objPro1}; 
            
        LatAm_Profile_List__c test2 = new LatAm_Profile_List__c(Name='LatAmProfileList',Profile_List__c='LatAm User  System Administrator');
        insert test2;
        
        List<Opportunity> opptyLst1 = new List<Opportunity>();
            
        Account acct = new Account(Name='TEST_ACCT');
        insert acct;
        
        Contact testcontact= UnitTest.getContactInstance(acct.Id);
        insert testcontact;
            
        KeyValueListStore__c listStore=new KeyValueListStore__c();
        listStore.Name = 'ANZUsersProfileId';
        listStore.TextValue__c = stdProfile.Id;
        insert listStore;
            
        RecordtypeIds__c recT1= new RecordtypeIds__c();
        recT1.name= 'LATAM Renewal Opportunity';
        recT1.recTypeId__C = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('LATAM Renewal Opportunity').getRecordTypeId();      
        insert recT1;
            
        RecordtypeIds__c recT2= new RecordtypeIds__c();
        recT2.Name= 'Pipeline Opportunities';
        recT2.recTypeId__C = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Pipeline Opportunity').getRecordTypeId();        
        insert recT2;
            
        RecordtypeIds__c recT3= new RecordtypeIds__c();
        recT3.name= 'Pre-Pipeline Opportunities';
        recT3.recTypeId__C = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Pre-Pipeline Opportunity').getRecordTypeId();      
        insert recT3;
        
        Opportunity opp = new Opportunity();
        opp.AccountId = acct.Id;
        opp.Name = 'Unit Test Opportuntiy';
        opp.CloseDate = System.Today() + 5;
        opp.RecordTypeId = recT2.recTypeId__C;
        opp.StageName = '10%';
        opp.Competitor_Name__c = 'BloomBerg';
        opp.Renewal_Flag__c = true;
        opp.Reason__c = 'Test';
        opp.Name__c = 'Test';
        opp.Was_There_a_Competitor__c = 'No';
        opp.Expiration_Date__c = System.today().adddays(40); 
        insert opp;
        
        
        Opportunity opp1 = new Opportunity();
        opp1.AccountId = acct.Id;
        opp1.Name = 'Unit Test Opportuntiy2';
        opp1.CloseDate = System.Today() + 7;
        opp1.RecordTypeId = recT2.recTypeId__C;
        opp1.StageName = '10%';
        opp1.Competitor_Name__c = 'BloomBerg';
        opp1.Renewal_Flag__c = true;
        opp1.Reason__c = 'Test2';
        opp1.Name__c = 'Testw2';
        opp1.Was_There_a_Competitor__c = 'No';
        opp1.Expiration_Date__c = System.today().adddays(60); 
        insert opp1;
        cdlLinkId.add(opp.id);
        
        Opportunity oppty1 = new Opportunity(RecordTypeId = recT2.recTypeId__C, CloseDate= System.Today() + 8, 
                                             AccountId = acct.Id,name='testClass_Oppty1',StageName = '95%',
                                             Reason__c = 'Test', Was_There_a_Competitor__c = 'No');
        opptyLst1.add(oppty1);
        Opportunity oppty2 = new Opportunity(RecordTypeId = recT2.recTypeId__C, CloseDate= System.Today() + 9, 
                                             AccountId = acct.Id,name='testClass_Oppty1',StageName = '100%',
                                             Reason__c = 'Test', Was_There_a_Competitor__c = 'No');
        opptyLst1.add(oppty2);
        insert opptyLst1;
        
         Map<Id,Opportunity> mapOpptylist=new Map<Id,Opportunity>();
             for(Opportunity oppy:opptyLst1){
                 mapOpptylist.put(oppy.Id,oppy);
             }
        
        
        
        //opp1.StageName = '100%';
        //update opp1;
        
        Blob beforeblob=Blob.valueOf('Unit Test Attachment Body');
        
        Test.startTest();
        ContentVersion cv = new ContentVersion();
        cv.title = 'test content trigger';
        cv.ContentLocation = 'S';
        cv.PathOnClient ='testDemo.pdf'; 
        cv.Title = 'signed Demo.pdf';
        cv.VersionData =beforeblob;          
        insert cv; 
        
        ContentVersion cv2 = new ContentVersion();
        cv2.title = 'test content trigger2';
        cv2.ContentLocation = 'S';
        cv2.PathOnClient = cv2.Title + '.snote';
        cv2.VersionData =beforeblob;          
        insert cv2; 
        
        Id conDoc = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:cv.Id].ContentDocumentId;
        Id conDoc2 = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:cv2.Id].ContentDocumentId;
        
        //Get Content Version
        //List<ContentVersion> cvList = [SELECT Id, Title, ContentDocumentId FROM ContentVersion WHERE Id = :cv.Id];
        ContentVersion cvList = [SELECT Id, Title, ContentDocumentId FROM ContentVersion WHERE Id = :cv.Id];
        //System.assertEquals(cvList.size(), 1);
        
        //Get Content Documents
        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument Limit 2];
        Map<Id, ContentDocument> mapCDD = new Map<Id, ContentDocument>([SELECT Id, Title, LatestPublishedVersionId 
                                                                        FROM ContentDocument Limit 2]);
        
        //create ContentDocumentLink  record 
        ContentDocumentLink cdl = New ContentDocumentLink();
        cdl.LinkedEntityId = opp.id;
        cdl.ContentDocumentId = conDoc;
        //cdl.ContentDocumentId = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id =: cv.Id].ContentDocumentId;
        //cdl.ContentDocumentId = documents[0].Id;
        cdl.shareType = 'v';
        cdl.Visibility = 'AllUsers';
        insert cdl;
        
        ContentDocumentLink cdl1 = New ContentDocumentLink();
        cdl1.LinkedEntityId = opp1.id;
        //cdl.ContentDocumentId = conDoc;
        cdl1.ContentDocumentId = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id =: cv.Id].ContentDocumentId;
        //cdl.ContentDocumentId = documents[0].Id;
        cdl1.shareType = 'v';
        cdl1.Visibility = 'AllUsers';
        insert cdl1;
        
        ContentNote cn = new ContentNote();
        cn.Title = 'test1';
        String body = 'test note';
        cn.Content = Blob.valueOf(body.escapeHTML4());
        insert cn;
        
        ContentDocumentLink link2 = new ContentDocumentLink();
        link2.ContentDocumentId = conDoc2;
        link2.LinkedEntityId = opp1.id;
        link2.ShareType = 'v';
        link2.Visibility = 'AllUsers';
        insert link2;
        
        system.assertEquals(link2.LinkedEntityId, cdl1.LinkedEntityId);
        
        
        cdlLinkId.add(cdl.LinkedEntityId);
        
        List<ContentDocumentLink> cdlist = new List<ContentDocumentLink>([select ID, LinkedEntityId,ContentDocumentId from ContentDocumentLink  where id =: cdl.id limit 2]);
        Map<Id, ContentDocumentLink> mapCD = new Map<Id, ContentDocumentLink>([select ID, LinkedEntityId,ContentDocumentId from ContentDocumentLink  where id =: cdl.id limit 2]);
        Set<Id> stid = new Set<Id>();
        stid.add(opp.id);
        
        ContentDocuDelRestrictionHandler hnd = new ContentDocuDelRestrictionHandler();
        
        Set<Id> contentDocuIds = new Set<Id>();
        stid.add(documents[0].id);
        
        delete link2;
        delete cdl1;
        
        delete documents;
        LTS_Disable_Application_Automation__c ltstemp = new LTS_Disable_Application_Automation__c();
        ltstemp.LTS_Disable_Process_Builders__c = true;
        ltstemp.LTS_Disable_Triggers__c = true;
        ltstemp.LTS_Disable_Validation_Rules__c = true;
        ltstemp.LTS_Disable_Workflow_Rules__c = true;
        ltstemp.Name = 'temp';
        ltstemp.SetupOwnerId = userinfo.getuserid();
        insert ltstemp;
            
        //ContentDocuDelRestrictionHandler.onBeforeDeleteContentDocu(true, mapCDD);
           
    }
}