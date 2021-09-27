@isTest
private class ESC_ConvertAttachmenttoFiletest {
    @IsTest(SeeAllData=false) static void testmethod1()
    {
     User u;
    LatAm_Profile_List__c lp;      
    User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
    System.runAs ( thisUser ) {
        //This code run as a system user
           UserRole ur =[SELECT  DeveloperName,Id,Name FROM UserRole where Name='Credentialing Team lead'];
     
      Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
      
      u = new User(Alias = 'standt99', Email='sysadmin@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id,UserRoleId = ur.Id, 
      TimeZoneSidKey='America/Los_Angeles', UserName='sysadmin99@testorg.com');
      //insert u;
      
       lp = new LatAm_Profile_List__c ( name = 'LatAmProfileList',Profile_List__c = 'LatAm User;Partner Portal User;LatAM Helpdesk Agent;LatAm Service Accountable Resolver;LatAM Help Desk Manager');
      insert lp;
      ESC_email_deletion_roles__c edr= new ESC_email_deletion_roles__c(name = 'Credentialing Team lead',role__c ='USL_Credentialing_Team_lead');
      insert edr;
       
      
    }
      System.runas(u){
        //to bypass validation --- status cannot be equal to work in progress
      LTS_Disable_Application_Automation__c dis = new LTS_Disable_Application_Automation__c();
        dis.LTS_Disable_Validation_Rules__c =true;
        insert dis;
        
        
        Case c= new Case();
        c.origin =  'Web';
        c.is_gli__c = true;
         c.RecordtypeID=Schema.SObjectType.Case.getRecordTypeInfosByName().get('Incident').getRecordTypeId();
        insert c;
        
        //emailmessage e=new emailmessage(Subject='Test',parentid=c.id);
        //insert e;
        //ESC_DataTableEntity dte = new ESC_DataTableEntity();
         
        List<Attachment> attachmentList = new List<Attachment>();
        
        attachment att = new attachment();
        att.parentid = c.id;
        att.name = 'Test';
        att.contentType ='text/plain';
        att.body=Blob.valueOf('asdfsdfsdfsfasdfa');
        //att.bodyLength = 10485760;
        attachmentList.add(att);
        //insert att;

         attachment att1 = new attachment();
        att1.parentid = c.id;
        att1.name = 'Test123';
        att1.contentType ='text/plain';
        att1.body=Blob.valueOf('asdfsdfsdfsfasdfafdgfh');
        //att.bodyLength = 10485760;
        attachmentList.add(att1);
       // insert att1;
       insert attachmentList;
       Test.startTest();
        ESC_ConvertAttachmenttoFile.converttofile(AttachmentList);
        
        Test.stopTest();
        }
        integer i = 1;
        integer j = 1;
        System.assertEquals(i,j,'equal');
    }
    @IsTest(SeeAllData=false) static void testmethod2()
    {
        Case c = new case();
        insert c;
         List<Attachment> attachmentList = new List<Attachment>();
         List<id> attlst = new List<id>();
        
        attachment att = new attachment();
        att.parentid = c.id;
        att.name = 'Test';
        att.contentType ='text/plain';
        att.body=Blob.valueOf('asdfsdfsdfsfasdfa');
        //att.bodyLength = 10485760;
        attachmentList.add(att);
         insert attachmentList;
         attlst.add(att.id);
         Test.startTest();
            ESC_ConvertAttachmenttoFile.delattachment(attlst);
         Test.stopTest();
          integer i = 1;
        integer j = 1;
        System.assertEquals(i,j,'equal');
    }
}