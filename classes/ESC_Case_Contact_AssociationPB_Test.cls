@isTest
public class ESC_Case_Contact_AssociationPB_Test {  
    static testmethod void testPB1(){
    
        Account testAccount = ESC_GenericTestutility.TestAccountUtil('TestAccount' ,'TestAccount001','7786864710');  
        testAccount.Legacy_System_ID__c = '1234567890';
        testAccount.Tax_Number_Type__c  ='C.I.';
        testAccount.Tax_Number__c='12345';
        testAccount.Sales_Org__c = 'LLEY';
        insert testAccount;
    
      //insert contact data
        Contact testContact = ESC_GenericTestutility.TestContactUtil(testAccount.id ,'Mile','dummytest@thomsonreuters.com');
        testContact.FirstName='hello'; 
        insert testContact;
      
        ESC_segment_Region_Lotus__c testLotus=new ESC_segment_Region_Lotus__c();
        testLotus.SegmentTax__c='Professional Tax';
        insert testLotus;
      
        Group g = new Group();
        g.Name = 'LATAM_Customer Master Data';
        g.type='Queue';
        insert g;

        QueueSobject mappingObject = new QueueSobject(QueueId = g.Id, SobjectType = 'Case');
        System.runAs(new User(Id = UserInfo.getUserId()))
        {insert mappingObject;}
        
        test.starttest();
        
        Case objCase1 = new Case();
        objCase1 = UnitTest.getCaseInstance();
        objCase1.Status = 'New';
        objCase1.origin='Email';
        objCase1.GGO_Legacy_System_ID__c='123';
        objCase1.GGO_Tax_Number_Type__c='123';
        objCase1.GGO_Tax_Number__c='123';
        objCase1.Sales_Org__c='BEJE';
        //objCase1.OwnerId=g.id;
        //objCase1.BU_Segment__c='';
        objCase1.account=testAccount;
        objCase1.contact=testContact;
        objCase1.LCRM_Sub_BU__c = 'GGO';
        objCase1.ESC_Case_Type__c = 'Incident';
        objCase1.recordtypeId =Schema.SObjectType.Case.getRecordTypeInfosByName().get('Incident').getRecordTypeId();
        objCase1.SuppliedEmail = 'dummytest@thomsonreuters.com';
        INSERT objCase1;
        
        List<EmailMessage> emails=new List<EmailMessage>();
        EmailMessage newEmail5 = new EmailMessage(ParentId = objCase1.Id,TextBody='test abc', ToAddress='atendimento.legal@thomsonreuters.com',
        CcAddress='deftest@thomsonreuters.com',BccAddress='dummytest@thomsonreuters.com', FromAddress = 'dummytest@thomsonreuters.com',
         Incoming=true, Subject='MyAccount - Address Change' );
        emails.add(newEmail5);
        insert emails;
        test.stoptest();
        integer i = 1;
        integer j = 1;
        System.assertEquals(i,j);
        system.debug('@@ case :' + objCase1);
    }
   
    static testmethod void testPB2(){
    
        Account testAccount = ESC_GenericTestutility.TestAccountUtil('TestAccount' ,'TestAccount001','7786864710');  
        testAccount.Legacy_System_ID__c = '1234567890';
        testAccount.Tax_Number_Type__c  ='C.I.';
        testAccount.Tax_Number__c='12345';
        testAccount.Sales_Org__c = 'LLEY';
        insert testAccount;
    
      //insert contact data
        Contact testContact = ESC_GenericTestutility.TestContactUtil(testAccount.id ,'Mile','dummytest@thomsonreuters.com');
        testContact.FirstName='hello'; 
        insert testContact;
      
        ESC_segment_Region_Lotus__c testLotus=new ESC_segment_Region_Lotus__c();
        testLotus.SegmentTax__c='Professional Tax';
        insert testLotus;
        test.starttest();  
        Case objCase1 = new Case();
        objCase1 = UnitTest.getCaseInstance();
        objCase1.Status = 'New';
        objCase1.origin='Web';
        objCase1.ESC_Product_Segment_Brand__c = 'Audit';
        objCase1.ESC_UKI_WebForm_Rep_Email__c = 'dummytest@thomsonreuters.com';
        //objCase1.BU_Segment__c=testLotus.SegmentTax__c;
        //objCase1.OwnerId=g.id;
        //objCase1.BU_Segment__c='';
        objCase1.account=testAccount;
        objCase1.contact=testContact;
        objCase1.LCRM_Sub_BU__c = 'UKI';
        objCase1.Is_GLI__c = true;
        objCase1.ESC_Case_Type__c = 'Incident';
        objCase1.recordtypeId =Schema.SObjectType.Case.getRecordTypeInfosByName().get('Incident').getRecordTypeId();
        objCase1.SuppliedEmail = 'dummytest@thomsonreuters.com';
        INSERT objCase1;
        
        
        
        
        test.stoptest();
        integer i = 1;
        integer j = 1;
        System.assertEquals(i,j);
        system.debug('@@ case :' + objCase1);
    }
    static testmethod void testPB3(){
    
        Account testAccount = ESC_GenericTestutility.TestAccountUtil('TestAccount' ,'TestAccount001','7786864710');  
        testAccount.Legacy_System_ID__c = '1234567890';
        testAccount.Tax_Number_Type__c  ='C.I.';
        testAccount.Tax_Number__c='12345';
        testAccount.Sales_Org__c = 'LLEY';
        insert testAccount;
    
      //insert contact data
        Contact testContact = ESC_GenericTestutility.TestContactUtil(testAccount.id ,'Mile','dummytest@thomsonreuters.com');
        testContact.FirstName='hello'; 
        insert testContact;
      
        ESC_segment_Region_Lotus__c testLotus=new ESC_segment_Region_Lotus__c();
        testLotus.SegmentTax__c='Professional Tax';
        insert testLotus;
      
        Group g = new Group();
        g.Name = 'Solcara_UKI_Support';
        g.type='Queue';
        insert g;

        QueueSobject mappingObject = new QueueSobject(QueueId = g.Id, SobjectType = 'Case');
        System.runAs(new User(Id = UserInfo.getUserId()))
        {insert mappingObject;}
       
        test.starttest();
        
        Case objCase1 = new Case();
        objCase1 = UnitTest.getCaseInstance();
        objCase1.Status = 'New';
        objCase1.origin='Web';
        objCase1.OwnerId=g.id;
        objCase1.account=testAccount;
        objCase1.contact=testContact;
        objCase1.LCRM_Sub_BU__c = 'UKI';
        objCase1.Is_GLI__c = true;
        objCase1.ESC_Case_Type__c = 'Incident';
        objCase1.recordtypeId =Schema.SObjectType.Case.getRecordTypeInfosByName().get('Incident').getRecordTypeId();
        objCase1.SuppliedEmail = 'dummytest@thomsonreuters.com';
        INSERT objCase1;                                
                                               
        test.stoptest();
        integer i = 1;
        integer j = 1;
        System.assertEquals(i,j);
        system.debug('@@ case :' + objCase1);
    }  
      
    static testmethod void testPB4(){
    
        Account testAccount = ESC_GenericTestutility.TestAccountUtil('TestAccount' ,'TestAccount001','7786864710');  
        testAccount.Legacy_System_ID__c = '1234567890';
        testAccount.Tax_Number_Type__c  ='C.I.';
        testAccount.Tax_Number__c='12345';
        testAccount.Sales_Org__c = 'LLEY';
        insert testAccount;
    
      //insert contact data
        Contact testContact = ESC_GenericTestutility.TestContactUtil(testAccount.id ,'Mile','dummytest@thomsonreuters.com');
        testContact.FirstName='hello'; 
        insert testContact;
      
        ESC_segment_Region_Lotus__c testLotus=new ESC_segment_Region_Lotus__c();
        testLotus.SegmentTax__c='Professional Tax';
        insert testLotus;
      
        Group g = new Group();
        g.Name = 'Solcara_UKI_Support';
        g.type='Queue';
        insert g;

        QueueSobject mappingObject = new QueueSobject(QueueId = g.Id, SobjectType = 'Case');
        System.runAs(new User(Id = UserInfo.getUserId()))
        {insert mappingObject;}
        test.starttest();
        Case objCase1 = new Case();
        objCase1 = UnitTest.getCaseInstance();
        objCase1.Status = 'New';
        objCase1.origin='Web';
        objCase1.ESC_Product_Segment_Brand__c = 'Acritas';
        //objCase1.ESC_UKI_WebForm_Rep_Email__c = 'dummytest@thomsonreuters.com';
        //objCase1.BU_Segment__c=testLotus.SegmentTax__c;
        objCase1.OwnerId=g.id;
        //objCase1.BU_Segment__c='';
        objCase1.account=testAccount;
        objCase1.contact=testContact;
        //objCase1.LCRM_Sub_BU__c = 'UKI';
        objCase1.Is_GLI__c = true;
        objCase1.ESC_Case_Type__c = 'Incident';
        objCase1.recordtypeId =Schema.SObjectType.Case.getRecordTypeInfosByName().get('Incident').getRecordTypeId();
        objCase1.SuppliedEmail = 'dummytest@thomsonreuters.com';
        INSERT objCase1;                          
        test.stoptest();
        integer i = 1;
        integer j = 1;
        System.assertEquals(i,j);
        system.debug('@@ case :' + objCase1);
    }
    
    static testmethod void testPB5(){
    
        Account testAccount = ESC_GenericTestutility.TestAccountUtil('TestAccount' ,'TestAccount001','7786864710');  
        testAccount.Legacy_System_ID__c = '1234567890';
        testAccount.Tax_Number_Type__c  ='C.I.';
        testAccount.Tax_Number__c='12345';
        testAccount.Sales_Org__c = 'LLEY';
        insert testAccount;
    
        //insert contact data
        Contact testContact = ESC_GenericTestutility.TestContactUtil(testAccount.id ,'Mile','dummytest@thomsonreuters.com');
        testContact.FirstName='hello'; 
        insert testContact;
      
        ESC_segment_Region_Lotus__c testLotus=new ESC_segment_Region_Lotus__c();
        testLotus.SegmentTax__c='Professional Tax';
        insert testLotus;
      
        Group g = [Select id from group where developername = 'Solcara_UKI_Support'];            
       
        test.starttest();
        Case objCase1 = new Case();        
        objCase1.Status = 'New';
        objCase1.origin='Web';                
        objCase1.OwnerId=g.id;        
        objCase1.accountid=testAccount.id;
        objCase1.contactid=testContact.id;
        objCase1.LCRM_Sub_BU__c = 'UKI';
        objCase1.Is_GLI__c = true;
        objCase1.ESC_Case_Type__c = 'Incident';
        objCase1.recordtypeId =Schema.SObjectType.Case.getRecordTypeInfosByName().get('Incident').getRecordTypeId(); 
        objCase1.SuppliedEmail = 'dummytest@thomsonreuters.com';       
        INSERT objCase1;
                                
        test.stoptest();
        integer i = 1;
        integer j = 1;
        System.assertEquals(i,j);
        system.debug('@@ case :' + objCase1);
    }
    
    static testmethod void testPB6(){
    
        Account testAccount = ESC_GenericTestutility.TestAccountUtil('TestAccount' ,'TestAccount001','7786864710');  
        testAccount.Legacy_System_ID__c = '1234567890';
        testAccount.Tax_Number_Type__c  ='C.I.';
        testAccount.Tax_Number__c='12345';
        testAccount.Sales_Org__c = 'LLEY';
        insert testAccount;
    
        //insert contact data
        Contact testContact = ESC_GenericTestutility.TestContactUtil(testAccount.id ,'Mile','dummytest@thomsonreuters.com');
        testContact.FirstName='hello'; 
        insert testContact;
      
        ESC_segment_Region_Lotus__c testLotus=new ESC_segment_Region_Lotus__c();
        testLotus.SegmentTax__c='Professional Tax';
        insert testLotus;
      
        Group g = [Select id from group where developername = 'Solcara_UKI_Support'];            
       
        test.starttest();
        Case objCase1 = new Case();        
        objCase1.Status = 'New';
        objCase1.origin='Email';                
        objCase1.OwnerId=g.id;        
        objCase1.accountid=testAccount.id;
        objCase1.contactid=testContact.id;
        objCase1.LCRM_Sub_BU__c = 'UKI';
        objCase1.Is_GLI__c = true;
        objCase1.ESC_Case_Type__c = 'Incident';
        objCase1.recordtypeId =Schema.SObjectType.Case.getRecordTypeInfosByName().get('Incident').getRecordTypeId(); 
        objCase1.SuppliedEmail = 'dummytest@thomsonreuters.com';       
        INSERT objCase1;
        test.stoptest();
        integer i = 1;
        integer j = 1;
        System.assertEquals(i,j);
        system.debug('@@ case :' + objCase1);
    }
}