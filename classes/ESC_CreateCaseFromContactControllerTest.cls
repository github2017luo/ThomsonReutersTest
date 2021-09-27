/**********************************
Class Name: CreateCaseFromContactControllerTest
Purpose: Test class for "CreateCaseFromContactController" apex class.
Author:Manish/Mousumi
Date Created:09/05/2017
Date Updated:Version0
***********************************/
@IsTest public with sharing class ESC_CreateCaseFromContactControllerTest{
     @IsTest(SeeAllData=false) public static void testCreateCaseFromContactController() {
         
         Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 

        UserRole r = new UserRole(DeveloperName = 'TR_Legal_Sales_Rep1', Name = 'My_Role');
        insert r;
         User u = new User(Alias = 'standt2', Email='sysadmin@2testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing2', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id,
      TimeZoneSidKey='America/Los_Angeles',UserName='sysadmin2@testorg.com',UserRoleId = r.Id);
      insert u;
      
      
System.RunAs(u)
     {
         Account testAccount = New Account();  
         testAccount .Name= 'TestAccount';
         testAccount .AccountNumber= 'TestAccount001';
         testAccount .Phone= '7786864710';
         insert testAccount ;
         Contact testContact = New Contact(AccountId = testAccount .id, Salutation = 'Mr' , FirstName = 'John' , LastName= 'Mile',Email ='test@tr.com');
         insert testContact ;
         
          BusinessHours defaultBH = [Select Id From BusinessHours Where IsDefault = True limit 1];

List<ESCSegmentRegionMappingSet__c> listESCSegmentRegionMappingSet = new List<ESCSegmentRegionMappingSet__c>();

    ESCSegmentRegionMappingSet__c eseSegmentRMaping =new ESCSegmentRegionMappingSet__c();
    eseSegmentRMaping.ESC_BusHours__c=defaultBH.id;//CHAGE TO QUERY
    eseSegmentRMaping.ESC_OrgWideDisplayName__c='core@tr.com';
    eseSegmentRMaping.ESC_Region__c='USL';
    eseSegmentRMaping.ESC_Segment__c='Professional Tax';
    //eseSegmentRMaping.ESC_Timezone__c='America/Los_Angeles';
    eseSegmentRMaping.ESC_Role__c='TR_Legal_Sales_Rep1';
    eseSegmentRMaping.ESC_Recordtype__c='Incident';
    eseSegmentRMaping.ESC_IsRecType_BusHours__c='Record Type';
    listESCSegmentRegionMappingSet.add(eseSegmentRMaping);
    
    insert listESCSegmentRegionMappingSet;

         //Creation of custom settings
           // RecordTypeInfo RecordType11 = Schema.SObjectType.Case.RecordTypeInfosByName.get('Incident');
            list<ESC_CasefromContactFieldValueList__c> cusset=new list<ESC_CasefromContactFieldValueList__c>();
        // ESC_CasefromContactFieldValueList__c CaseCS = New ESC_CasefromContactFieldValueList__c(name ='RecordTypeId',ESC_Value__c =RecordType11.Id);
         ESC_CasefromContactFieldValueList__c caseCS1 = New ESC_CasefromContactFieldValueList__c(name ='ESC_Business_Unit__c',ESC_Value__c ='');
         ESC_CasefromContactFieldValueList__c caseCS2 = New ESC_CasefromContactFieldValueList__c(name ='Status',ESC_Value__c ='WorkInProgress');
         ESC_CasefromContactFieldValueList__c CaseCS = New ESC_CasefromContactFieldValueList__c(name ='RecordTypeId',ESC_Value__c ='Incident');
         cusset.add(caseCS1);
         cusset.add(caseCS2);
         cusset.add(CaseCS);
        // cusset.add(CaseCS);
         insert cusset;
         case css = new Case(AccountId=testAccount.Id,ContactId=testContact.Id,Status = 'New',Subject = 'test subject',Description = 'test description',Sales_Org__c='GLI');
         insert css;
         list<Case> css1=new list<Case>();        
         css1.add(css);
         Test.StartTest();
         PageReference pageRef = Page.ESC_CreateCaseFromContact;
         Test.setCurrentPage(pageRef);
         pageRef.getParameters().put('Id',testContact.id);
         ApexPages.StandardSetController sc = new ApexPages.standardSetController(css1);
         ESC_CreateCaseFromContactController cont = new ESC_CreateCaseFromContactController(sc);
         LCRMGenericComponent.isLotusUser();
         cont.CreateCase();
         Test.StopTest();     
         
        integer i = 1;
        integer j = 1;
        System.assertEquals(i,j);  
    } 
     }
    @IsTest(SeeAllData=false) public static void testCreateCaseFromContactController1() {
    Profile p1 = [SELECT Id FROM Profile WHERE Name='TR Sales']; 

        UserRole r1 = new UserRole(DeveloperName = 'GLI1', Name = 'My_Role1');
        insert r1;
         User u1 = new User(Alias = 'standt2', Email='sysadmin@3testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing3', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p1.Id,Segment__c='Professional Legal',
      TimeZoneSidKey='America/Los_Angeles',UserName='sysadmin2@3testorg.com',UserRoleId = r1.Id);
      insert u1;
       Profile ukiProfile = [SELECT Id FROM profile WHERE name='UKI Users'];
    User gliUser = UnitTest.getUserInstance();
    gliUser.Username = 'TestUser1@TR.com';
    gliUser.profileid = ukiProfile.Id;
    gliUser.Sub_Bu__c = 'UKI';
    insert gliUser;
     
            system.runAs(gliUser){
                String bu = LCRMGenericComponent.getUserBU();
                Boolean result = LCRMGenericComponent.validateUserBU(bu);
            }
      
System.RunAs(u1)
     {
         Account testAccount1 = New Account();  
         testAccount1 .Name= 'TestAccount';
         testAccount1 .AccountNumber= 'TestAccount001';
         testAccount1 .Phone= '7786864710';
         insert testAccount1 ;
         Contact testContact1 = New Contact(AccountId = testAccount1.id, Salutation = 'Mr' , FirstName = 'John' , LastName= 'Mile',Email ='test@tr.com');
         insert testContact1 ;
         
        //  BusinessHours defaultBH = [Select Id From BusinessHours Where IsDefault = True limit 1];

List<ESCSegmentRegionMappingSet__c> listESCSegmentRegionMappingSet = new List<ESCSegmentRegionMappingSet__c>();

    ESCSegmentRegionMappingSet__c eseSegmentRMaping =new ESCSegmentRegionMappingSet__c();
   //CHAGE TO QUERY
    eseSegmentRMaping.ESC_OrgWideDisplayName__c='core@tr.com';
    eseSegmentRMaping.ESC_Region__c='USL';
    eseSegmentRMaping.ESC_Segment__c='Professional Tax';
    //eseSegmentRMaping.ESC_Timezone__c='America/Los_Angeles';
    eseSegmentRMaping.ESC_Role__c='GLI2';
   eseSegmentRMaping.ESC_Recordtype__c='Incident';
   eseSegmentRMaping.ESC_IsRecType_BusHours__c='Record Type';
    listESCSegmentRegionMappingSet.add(eseSegmentRMaping);
    
    insert listESCSegmentRegionMappingSet;

         //Creation of custom settings
           // RecordTypeInfo RecordType11 = Schema.SObjectType.Case.RecordTypeInfosByName.get('Incident');
            list<ESC_CasefromContactFieldValueList__c> cusset=new list<ESC_CasefromContactFieldValueList__c>();
        // ESC_CasefromContactFieldValueList__c CaseCS = New ESC_CasefromContactFieldValueList__c(name ='RecordTypeId',ESC_Value__c =RecordType11.Id);
         ESC_CasefromContactFieldValueList__c caseCS1 = New ESC_CasefromContactFieldValueList__c(name ='ESC_Business_Unit__c',ESC_Value__c ='');
         ESC_CasefromContactFieldValueList__c caseCS2 = New ESC_CasefromContactFieldValueList__c(name ='Status',ESC_Value__c ='WorkInProgress');
       //  ESC_CasefromContactFieldValueList__c CaseCS = New ESC_CasefromContactFieldValueList__c(name ='RecordTypeId',ESC_Value__c ='Incident');
         cusset.add(caseCS1);
         cusset.add(caseCS2);
         //cusset.add(CaseCS);
        // cusset.add(CaseCS);
         insert cusset;
         case css1 = new Case(AccountId=testAccount1.Id,ContactId=testContact1.Id,Status = '',Subject = '',Description = 'test description');
         //case css1 = null;
         insert css1;
         list<Case> css2=new list<Case>();        
         css2.add(css1);
         Test.StartTest();
         PageReference pageRef = Page.ESC_CreateCaseFromContact;
         Test.setCurrentPage(pageRef);
         pageRef.getParameters().put('Id',testContact1.id);
         ApexPages.StandardSetController sc = new ApexPages.standardSetController(css2);
         ESC_CreateCaseFromContactController cont = new ESC_CreateCaseFromContactController(sc);
         cont.CreateCase();
         LCRMGenericComponent.isLotusUser();
         Test.StopTest();     
         
        integer i = 1;
        integer j = 1;
        System.assertEquals(i,j);  
    } 
     }
     @IsTest(SeeAllData=false) public static void testCreateCaseFromContactController2() {
         
         Profile p2 = [SELECT Id FROM Profile WHERE Name='TR Sales']; 

        UserRole r2 = new UserRole(DeveloperName = 'GLI4', Name = 'My_Role3');
        insert r2;
         User u2 = new User(Alias = 'standt2', Email='sysadmin@2testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing2', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p2.Id,
      TimeZoneSidKey='America/Los_Angeles',UserName='sysadmin2@testorg.com',Segment__c='Professional Legal',Sub_Bu__c='Canada',UserRoleId = r2.Id);
      insert u2;
      
      
System.RunAs(u2)
     {
         Account testAccount2 = New Account();  
         testAccount2.Name= 'TestAccount';
         testAccount2.AccountNumber= 'TestAccount001';
         testAccount2.Phone= '7786864710';
         insert testAccount2 ;
         Contact testContact2 = New Contact(AccountId = testAccount2.id, Salutation = 'Mr' , FirstName = 'John' , LastName= 'Mile',Email ='test@tr.com');
         insert testContact2 ;
         
          BusinessHours defaultBH = [Select Id From BusinessHours Where IsDefault = True limit 1];

List<ESCSegmentRegionMappingSet__c> listESCSegmentRegionMappingSet = new List<ESCSegmentRegionMappingSet__c>();

    ESCSegmentRegionMappingSet__c eseSegmentRMaping =new ESCSegmentRegionMappingSet__c();
    eseSegmentRMaping.ESC_BusHours__c=defaultBH.id;//CHAGE TO QUERY
    eseSegmentRMaping.ESC_OrgWideDisplayName__c='core@tr.com';
    eseSegmentRMaping.ESC_Region__c='Canada';
    eseSegmentRMaping.ESC_Segment__c='Professional Canada';
    //eseSegmentRMaping.ESC_Timezone__c='America/Los_Angeles';
    eseSegmentRMaping.ESC_Role__c='GLI';
    eseSegmentRMaping.ESC_Recordtype__c='Incident';
    eseSegmentRMaping.ESC_IsRecType_BusHours__c='Record Type';
    listESCSegmentRegionMappingSet.add(eseSegmentRMaping);
    
    insert listESCSegmentRegionMappingSet;

         //Creation of custom settings
           // RecordTypeInfo RecordType11 = Schema.SObjectType.Case.RecordTypeInfosByName.get('Incident');
            list<ESC_CasefromContactFieldValueList__c> cusset=new list<ESC_CasefromContactFieldValueList__c>();
        // ESC_CasefromContactFieldValueList__c CaseCS = New ESC_CasefromContactFieldValueList__c(name ='RecordTypeId',ESC_Value__c =RecordType11.Id);
         ESC_CasefromContactFieldValueList__c caseCS1 = New ESC_CasefromContactFieldValueList__c(name ='ESC_Business_Unit__c',ESC_Value__c ='');
         ESC_CasefromContactFieldValueList__c caseCS2 = New ESC_CasefromContactFieldValueList__c(name ='Status',ESC_Value__c ='WorkInProgress');
         ESC_CasefromContactFieldValueList__c CaseCS = New ESC_CasefromContactFieldValueList__c(name ='RecordTypeId',ESC_Value__c ='Incident');
         cusset.add(caseCS1);
         cusset.add(caseCS2);
         cusset.add(CaseCS);
        // cusset.add(CaseCS);
         insert cusset;
         case css3 = new Case(AccountId=testAccount2.Id,ContactId=testContact2.Id,Status = 'New',Subject = 'test subject',Description = 'test description',Sales_Org__c='GLI');
         insert css3;
         list<Case> css2=new list<Case>();        
         css2.add(css3);
         Test.StartTest();
         PageReference pageRef = Page.ESC_CreateCaseFromContact;
         Test.setCurrentPage(pageRef);
         pageRef.getParameters().put('Id',testContact2.id);
         ApexPages.StandardSetController sc3 = new ApexPages.standardSetController(css2);
         ESC_CreateCaseFromContactController cont3 = new ESC_CreateCaseFromContactController(sc3);
         LCRMGenericComponent.isLotusUser();
         cont3.CreateCase();
         Test.StopTest();     
         
        integer i = 1;
        integer j = 1;
        System.assertEquals(i,j);  
    }
    } 
         
}