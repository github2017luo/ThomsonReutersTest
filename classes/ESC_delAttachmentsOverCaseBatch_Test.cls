@isTest(SeeAllData=false)
/******Written by Mouna
    Written on 04/11/2020
                      ******/

Public class ESC_delAttachmentsOverCaseBatch_Test{

 static testMethod void testMethod1()
{
    List<Case> lstCase = new List<Case>();
    List<ESC_ServiceNow_Scheduler_Settings__c> lstsschset = new List<ESC_ServiceNow_Scheduler_Settings__c>();
         
         Profile p = [SELECT Id FROM Profile WHERE Name='TR Business Administrator']; 
      User u = new User(Alias = 'Testa3', Email='sysadmina3@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testinga3', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, 
      TimeZoneSidKey='America/Los_Angeles', UserName='Testa3@ss.com');
      insert u;
       System.runas(u){
              
           //insert Account
        /*Account acct = new Account();
        acct.Name = 'SFDC';
        acct.ShippingCity = 'New York';
        acct.ShippingCountry = 'US';
        acct.ShippingState = 'AL';
        acct.ShippingPostalCode = '1007';
        acct.ShippingStreet = 'Diamond';
        insert acct ; 
        ///////////

        //insert contact
        Contact con = new Contact();
        con.AccountId=acct.Id;
        con.FirstName='Dummy';
        con.LastName='Test';
        con.Salutation='Mr.';
        con.Email='dummytest@thomsonreuters.com';
        insert con;*/
        
       
        ////////////////
        // insert a case records
        Case cs = new Case();
        cs.Type='Data';
        cs.Status='New';
        cs.Subject='Test Subject';
        cs.Description = 'Test Description111';
        //cs.contactid=con.id;
        //cs.accountid=acct.id;
        cs.ownerid=u.id;
        cs.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Incident').getRecordTypeId();
        cs.ESC_Case_Type__c = 'Incident';
        cs.ESC_Impact__c='3-Single User';
        cs.ESC_Diagnosis_Summary__c='Application/Infrastructure/Upgrade';
        cs.ESC_Resolution_Code__c='Config Change';
        cs.Priority='1-High';
        cs.SuppliedEmail = 'asdasd@123.com';
        cs.SuppliedPhone='234567890';
        cs.suppliedcompany='dgfhjk';
        cs.ESC_UKI_WebForm_Rep_Email__c='tsaa@ty.com';
        cs.ESC_UKI_WebForm_Rep_Name__c='Sai';
        cs.Origin = 'Web';
        cs.LCRM_Sub_BU__c = 'UKI';
        cs.ESC_Migrated_to_Sharepoint__c = true;
        cs.ESC_Origin_Name__c = 'DirectDebit';
        //cs.Product__c='tesgh';
        insert cs;
        System.debug('case is --->'+cs.Is_ESC_Case__c);
        //insert attachments
        
        list<Attachment> testAtt = new list<Attachment>();
        
        Attachment attach = new Attachment();       
        attach.Name='Unit Test Attachment';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=cs.id;
        attach.ownerid = u.id;
        testAtt.add(attach);
       
        insert testatt;
        
        cs.status = 'closed';
        update cs;
        
        System.debug('case is --->'+cs);
        System.debug(cs.Is_ESC_Case__c+' '+cs.isClosed+' '+cs.ClosedDate+' '+cs.createdbyid);
        System.debug(attach.createdbyid);
        System.debug(system.now());
        System.debug('attachment is --->'+attach); 
            Test.startTest(); 
           // ESC_delAttachmentsOverCaseBatch  obj = new ESC_delAttachmentsOverCaseBatch (); 
           // DataBase.executeBatch(obj); 
            ESC_delAttachmentScheduler deleteAttachScheduled= new ESC_delAttachmentScheduler(); 
            String sch = '0 00 00 * * ?';
            System.schedule('My batch Job', sch, deleteAttachScheduled);
            Test.stopTest();
            }
    }  
}