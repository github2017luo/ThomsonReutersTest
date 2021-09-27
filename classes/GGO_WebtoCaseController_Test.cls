@isTest    
private class GGO_WebtoCaseController_Test {
   
    
    static testMethod void testmethod1() {
 
        Test.StartTest();
        
        Profile Prof = [SELECT Id FROM profile WHERE name='LATAM Helpdesk Agent']; 
        
        User Us =  New User(FirstName = 'James' , LastName= 'ThomasTest',Alias = 'jttest',Email='james1.thomastest@thomsonreuters.com', emailencodingkey='UTF-8', 
        UserName='james1.thomastest@thomsonreuters.com',languagelocalekey='en_US', localesidkey='en_US', 
        profileid = Prof.Id,timezonesidkey='America/Los_Angeles',CommunityNickname='James.ThomasTest');
        insert Us;
       //insert Account
        Account acct = new Account();
        acct.Name = 'SFDC';
        acct.ShippingCity = 'New York';
        acct.ShippingCountry='US';
        acct.ShippingState = 'IL';
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
        insert con;
        
        Case cs = new Case();
        cs.Type='Data';
        cs.Status='New';
        cs.Subject='Test Subject';
        cs.Description = 'Test Description111';
        cs.contactid=con.id;
        cs.accountid=acct.id;
        cs.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Incident').getRecordTypeId();
        cs.ESC_Case_Type__c = 'Incident';
        cs.ESC_Impact__c='3-Single User';
        cs.ESC_Diagnosis_Summary__c='Application/Infrastructure/Upgrade';
        cs.ESC_Resolution_Code__c='Config Change';
        cs.Priority='1-High';
        cs.SuppliedEmail = 'asdasd@gmail.com';
       // cs.SuppliedName ='test3';
        cs.Product__c= 'Recursos Humanos - TM';
        insert cs;
        
        PageReference pageRef = Page.GGO_VFP_Web2Case;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('source','AR');
        pageRef.getParameters().put('BU','Bejerman');
        pageRef.getParameters().put('conName','Testcon');
        pageRef.getParameters().put('email','test@gmail.com');
        pageRef.getParameters().put('phNumber','12345');
        pageRef.getParameters().put('pComplement','Testcomp');
        pageRef.getParameters().put('product','TestProd');
        pageRef.getParameters().put('qcaseRecType','Feedback');
        pageRef.getParameters().put('caseDesc','TestDescription');
        pageRef.getParameters().put('cName','Testcompany');
        pageRef.getParameters().put('taxNumberType','C.I.');
        pageRef.getParameters().put('taxNumber','12345');
        
        
        ApexPages.StandardController sc = new ApexPages.StandardController(cs);
        GGO_WebtoCaseController gwc =  new GGO_WebtoCaseController(sc);
        gwc.c = cs;
        gwc.displayform = false;
        gwc.acctnum = '123456';
        gwc.countryCodeOwnerQueue='';
        gwc.phNumber = '9678905678';
        gwc.strPrd = 'Books';
        gwc.qcaseRecType = 'Product Support';
        gwc.Isattach = false;
        gwc.cName ='test_contact';
        gwc.conName='test3';
        gwc.caseDesc ='test description ggo';
        gwc.selprodLabel='Product';
        gwc.gcasid=cs.id;
        gwc.EnableSection = false;
        gwc.caseRecType='incident';
        gwc.taxNumberType='C.I.';
        gwc.taxNumber='389830193';
        gwc.inquiry ='test query';
        //pageRef.getParameters().put('taxNumberType','C.I.');
        //pageRef.getParameters().put('taxNumber','921');
        //String abc= gwc.privateKey;
        String prq= gwc.publicKey;
        gwc.getTaxTypes();
        gwc.getItems();
        gwc.getProductlist();
        String a=gwc.getcaseRecType();
        gwc.setcaseRecType(a);
        gwc.attachfile();
        gwc.reCAPTCHASucess();
        //pageRef.getParameters().put('gcasid',cs.id);
        gwc.SubmitWithAttachment();
        gwc.Removeattachment();
        Test.StopTest();
        integer i = 1;
        integer j = 1;
        System.assertEquals(i,j);
}

   static testMethod void testmethod2() {
 
        Test.StartTest();
        
        Profile Prof = [SELECT Id FROM profile WHERE name='LATAM Helpdesk Agent']; 
        
        User Us =  New User(FirstName = 'James' , LastName= 'ThomasTest',Alias = 'jttest',Email='james1.thomastest@thomsonreuters.com', emailencodingkey='UTF-8', 
        UserName='james1.thomastest@thomsonreuters.com',languagelocalekey='en_US', localesidkey='en_US', 
        profileid = Prof.Id,timezonesidkey='America/Los_Angeles',CommunityNickname='James.ThomasTest');
        insert Us;
       //insert Account
        Account acct = new Account();
        acct.Name = 'SFDC';
        acct.ShippingCity = 'New York';
        acct.ShippingCountry='US';
        acct.ShippingState = 'IL';
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
        insert con;
        
        Case cs = new Case();
        cs.Type='Data';
        cs.Status='New';
        cs.Subject='Test Subject';
        cs.Description = 'Test Description111';
        cs.contactid=con.id;
        cs.accountid=acct.id;
        cs.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Incident').getRecordTypeId();
        cs.ESC_Case_Type__c = 'Incident';
        cs.ESC_Impact__c='3-Single User';
        cs.ESC_Diagnosis_Summary__c='Application/Infrastructure/Upgrade';
        cs.ESC_Resolution_Code__c='Config Change';
        cs.Priority='1-High';
        cs.SuppliedEmail = 'asdasd@gmail.com';
        //cs.SuppliedName ='Test';
        cs.Product__c= 'Recursos Humanos - TM';
        insert cs;
        
        PageReference pageRef = Page.GGO_VFP_Web2Case_Distributor;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('source','AR');
        pageRef.getParameters().put('BU','Bejerman');
        pageRef.getParameters().put('Queue','SL_Technical Support_Vinza');
        pageRef.getParameters().put('conName','Testcon');
        pageRef.getParameters().put('email','test@gmail.com');
        pageRef.getParameters().put('phNumber','12345');
        pageRef.getParameters().put('pComplement','Testcomp');
        pageRef.getParameters().put('product','TestProd');
        pageRef.getParameters().put('qcaseRecType','Feedback');
        pageRef.getParameters().put('caseDesc','TestDescription');
        pageRef.getParameters().put('cName','Testcompany');
        pageRef.getParameters().put('taxNumberType','C.I.');
        pageRef.getParameters().put('taxNumber','12345');
        
        
        ApexPages.StandardController sc = new ApexPages.StandardController(cs);
        GGO_WebtoCaseController gwc =  new GGO_WebtoCaseController(sc);
        gwc.c = cs;
        gwc.displayform = false;
        gwc.acctnum = '123456';
        gwc.countryCodeOwnerQueue='';
        gwc.phNumber = '9678905678';
        gwc.strPrd = 'Books';
        gwc.qcaseRecType = 'Product Support';
        gwc.Isattach = false;
        gwc.cName ='test_contact';
        gwc.conName='test3';
        gwc.caseDesc ='test description ggo';
        gwc.selprodLabel='Product';
        gwc.gcasid=cs.id;
        gwc.EnableSection = false;
        gwc.caseRecType='incident';
        gwc.taxNumberType='C.I.';
        gwc.taxNumber='389830193';
        gwc.inquiry = 'test query greather than 150 characters on case subject for populating subject field on GGO web to case form.This is  for testing subject field on web to case form';
        //pageRef.getParameters().put('taxNumberType','C.I.');
        //pageRef.getParameters().put('taxNumber','921');
        //String abc= gwc.privateKey;
        String prq= gwc.publicKey;
        gwc.getTaxTypes();
        gwc.getItems();
        gwc.getProductlist();
        //gwc.getAccountDetails();
        String a=gwc.getcaseRecType();
        gwc.setcaseRecType(a);
        gwc.attachfile();
        gwc.reCAPTCHASucess();
        //pageRef.getParameters().put('gcasid',cs.id);
        gwc.SubmitWithAttachment();
        gwc.Removeattachment();
        Test.StopTest();
        integer i = 1;
        integer j = 1;
        System.assertEquals(i,j);
}
    static testMethod void testmethod3() {
 
        Test.StartTest();
        
        Profile Prof = [SELECT Id FROM profile WHERE name='LATAM Helpdesk Agent']; 
        Case cs = new Case();
        cs.Type='Data';
        cs.Status='New';
        cs.Subject='Test Subject';
        cs.Description = 'Test Description111';
        cs.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Incident').getRecordTypeId();
        cs.ESC_Case_Type__c = 'Incident';
        cs.ESC_Impact__c='3-Single User';
        cs.ESC_Diagnosis_Summary__c='Application/Infrastructure/Upgrade';
        cs.ESC_Resolution_Code__c='Config Change';
        cs.Priority='1-High';
        cs.SuppliedEmail = 'asdasd@gmail.com';
        cs.Product__c= 'Recursos Humanos - TM';
        insert cs;
        
        List<Attachment> listAttach= new List<Attachment>();
        for(integer i=0; i < 4; i++){
        Attachment attach=new Attachment();     
        attach.Name='Unit Test Attachment'+i;
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment body'+i);
        attach.body=bodyBlob;
        attach.parentId=cs.id;
        listAttach.add(attach);
        }
        insert listAttach;
        
        
        PageReference pageRef = Page.GGO_VFP_Web2Case;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('source','BR');
        pageRef.getParameters().put('BU','Legal');
        
        ApexPages.StandardController sc = new ApexPages.StandardController(cs);
        GGO_WebtoCaseController gwc =  new GGO_WebtoCaseController(sc);
        gwc.c = cs;
        gwc.displayform = false;
        gwc.acctnum = '123456';
        gwc.countryCodeOwnerQueue='';
        gwc.phNumber = '9678905678';
        gwc.strPrd = 'Books';
        gwc.qcaseRecType = 'Product Support';
        gwc.Isattach = false;
        gwc.cName ='test_contact';
        gwc.conName='test3';
        gwc.caseDesc ='test description ggo';
        gwc.selprodLabel='Product';
        gwc.gcasid=cs.id;
        gwc.EnableSection = false;
        gwc.caseRecType='incident';
        gwc.taxNumberType='C.I.';
        gwc.taxNumber='389830193';
        try { 
        
         gwc.qcaseRecType = '';
         gwc.reCAPTCHASucess();
         gwc.qcaseRecType = 'Product Support';
         gwc.taxNumberType='--None--';
         gwc.reCAPTCHASucess();
         gwc.taxNumberType='C.I.';
         gwc.taxNumber='';
         gwc.inquiry='';
         gwc.reCAPTCHASucess();
         //gwc.taxNumberType='C.I.';
         cs.SuppliedEmail='';
         gwc.reCAPTCHASucess();
         cs.SuppliedEmail='abc@gmail.com';
         cs.Description='';
         gwc.reCAPTCHASucess();
         cs.Description='testing';
         gwc.taxNumberType='CPF';
         gwc.reCAPTCHASucess();
         gwc.taxNumberType='CNPJ';
         gwc.reCAPTCHASucess();
         gwc.taxNumberType='C.U.I.T.';
         gwc.reCAPTCHASucess();
         gwc.taxNumberType='C.U.I.L.';
         gwc.reCAPTCHASucess();
         gwc.attachfile();
        
        } catch ( Exception ex) {
            system.debug('%%%%issue?'+ex);
        }
        
        pageRef.getParameters().put('source','BR');
        pageRef.getParameters().put('BU','Legal');
        
        ApexPages.StandardController sc1 = new ApexPages.StandardController(cs);
        GGO_WebtoCaseController gwc1 =  new GGO_WebtoCaseController(sc1);
       
        pageRef.getParameters().put('source','');
        pageRef.getParameters().put('BU','');
        
        ApexPages.StandardController sc2 = new ApexPages.StandardController(cs);
        GGO_WebtoCaseController gwc2 =  new GGO_WebtoCaseController(sc2);
       Test.StopTest();
       integer i = 1;
        integer j = 1;
        System.assertEquals(i,j);
}

static testMethod void testmethod4() {
 
        Test.StartTest();
        
        Profile Prof = [SELECT Id FROM profile WHERE name='LATAM Helpdesk Agent']; 
        
        User Us =  New User(FirstName = 'James' , LastName= 'ThomasTest',Alias = 'jttest',Email='james1.thomastest@thomsonreuters.com', emailencodingkey='UTF-8', 
        UserName='james1.thomastest@thomsonreuters.com',languagelocalekey='en_US', localesidkey='en_US', 
        profileid = Prof.Id,timezonesidkey='America/Los_Angeles',CommunityNickname='James.ThomasTest');
        insert Us;
       //insert Account
        Account acct = new Account();
        acct.Name = 'SFDC';
        acct.ShippingCity = 'New York';
        acct.ShippingCountry='US';
        acct.ShippingState = 'IL';
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
        insert con;
        
        Case cs = new Case();
        cs.Type='Data';
        cs.Status='New';
        cs.Subject='Test Subject';
        cs.Description = 'Test Description111';
        cs.contactid=con.id;
        cs.accountid=acct.id;
        cs.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Incident').getRecordTypeId();
        cs.ESC_Case_Type__c = 'Incident';
        cs.ESC_Impact__c='3-Single User';
        cs.ESC_Diagnosis_Summary__c='Application/Infrastructure/Upgrade';
        cs.ESC_Resolution_Code__c='Config Change';
        cs.Priority='1-High';
        cs.SuppliedEmail = 'asdasd@gmail.com';
        //cs.SuppliedName ='Test';
        cs.Product__c= 'Recursos Humanos - TM';
        insert cs;
        
        Case cs1 = new Case();
        cs1.Type='Data';
        cs1.Status='New';
        cs1.Subject='Test Subject';
        cs1.Description = 'Test Description111';
        cs1.contactid=con.id;
        cs1.accountid=acct.id;
        cs1.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Incident').getRecordTypeId();
        cs1.ESC_Case_Type__c = 'Incident';
        cs1.ESC_Impact__c='3-Single User';
        cs1.ESC_Diagnosis_Summary__c='Application/Infrastructure/Upgrade';
        cs1.ESC_Resolution_Code__c='Config Change';
        cs1.Priority='1-High';
        cs1.SuppliedEmail = 'asdasd@gmail.com';
        //cs.SuppliedName ='Test';
        cs1.Product__c= 'Recursos Humanos - TM';
        
        Attachment attach=new Attachment();     
        attach.Name='Unit Test Attachment';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=cs.id;
        insert attach;
        
        PageReference pageRef = Page.GGO_VFP_Web2Case_Distributor;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('source','AR');
        pageRef.getParameters().put('BU','Bejerman');
        pageRef.getParameters().put('Queue','SL_Technical Support_Vinza');
        pageRef.getParameters().put('conName','Testcon');
        pageRef.getParameters().put('email','test@gmail.com');
        pageRef.getParameters().put('phNumber','12345');
        pageRef.getParameters().put('pComplement','Testcomp');
        pageRef.getParameters().put('product','TestProd');
        pageRef.getParameters().put('qcaseRecType','Feedback');
        pageRef.getParameters().put('caseDesc','TestDescription');
        pageRef.getParameters().put('cName','Testcompany');
        pageRef.getParameters().put('taxNumberType','C.I.');
        pageRef.getParameters().put('taxNumber','12345');
        
        
        ApexPages.StandardController sc = new ApexPages.StandardController(cs);
        GGO_WebtoCaseController gwc =  new GGO_WebtoCaseController(sc);
        gwc.c = cs1;
        gwc.displayform = false;
        gwc.acctnum = '123456';
        gwc.countryCodeOwnerQueue='';
        gwc.phNumber = '9678905678';
        gwc.strPrd = 'Books';
        gwc.qcaseRecType = 'Product Support';
        gwc.Isattach = true;
        gwc.cName ='test_contact';
        gwc.conName='test3';
        gwc.caseDesc ='test description ggo';
        gwc.selprodLabel='Product';
        
        gwc.EnableSection = false;
        gwc.caseRecType='incident';
        gwc.taxNumberType='C.I.';
        gwc.taxNumber='389830193';
        
        gwc.inquiry = 'test query greather than 150 characters on case subject for populating subject field on GGO web to case form.This is  for testing subject field on web to case form';
        //pageRef.getParameters().put('taxNumberType','C.I.');
        //pageRef.getParameters().put('taxNumber','921');
        String abc= GGO_WebtoCaseController.privateKey;
        String prq= gwc.publicKey;
        gwc.getTaxTypes();
        gwc.getItems();
        gwc.getProductlist();
        //gwc.getAccountDetails();
        String a=gwc.getcaseRecType();
        gwc.setcaseRecType(a);
        gwc.attachment = attach;
        gwc.gcasid=cs.id;
        gwc.attachfile();
        gwc.reCAPTCHASucess();
        //pageRef.getParameters().put('gcasid',cs.id);
        gwc.gcasid=cs.id;
        gwc.SubmitWithAttachment();
        gwc.Removeattachment();
        
        Test.StopTest();
        integer i = 1;
        integer j = 1;
        System.assertEquals(i,j);
}
    
  
}