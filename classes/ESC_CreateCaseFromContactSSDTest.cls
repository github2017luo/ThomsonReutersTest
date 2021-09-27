@IsTest public with sharing class ESC_CreateCaseFromContactSSDTest{
     @IsTest(SeeAllData=false) public static void testCreateCaseFromContactSSDController() {
         
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

List <Case> listcase= new List<Case>();
      Case testCase=ESC_GenericTestutility.testCaseUtil(testContact.id,TestAccount.id,'New');
      testCase.ESC_Impact__c = '1-Whole Site';
      testCase.subject='tst';
      testCase.ESC_Customer_Symptom__c='Content Addition';
      testCase.ESC_Diagnosis_Summary__c='Content Explanation';
      testCase.ESC_Severity__c='1 - High';
      testCase.ESC_Case_Type__c = 'Request for Service';
      testCase.ESC_Apply_Milestone_Closure_Flag__c = true;
      
      testCase.RecordtypeID=Schema.SObjectType.Case.getRecordTypeInfosByName().get('Incident').getRecordTypeId();
      testCase.accountID=testAccount.id;
      testCase.ESC_Apply_Entitlement_Milestone__c=True;
      
      insert testCase;
      listcase.add(testCase);
         
         LCRM_Contact_SSD__c ContactSourceSystem=new LCRM_Contact_SSD__c();
         ContactSourceSystem.CurrencyIsoCode='USD';
         ContactSourceSystem.Name='Nameid';
         insert ContactSourceSystem;
         //Creation of custom settings
           // RecordTypeInfo RecordType11 = Schema.SObjectType.Case.RecordTypeInfosByName.get('Incident');
            list<ESC_CasefromContactFieldValueList__c> Cusset=new list<ESC_CasefromContactFieldValueList__c>();
         ESC_CasefromContactFieldValueList__c CaseCS = New ESC_CasefromContactFieldValueList__c(name ='RecordTypeId',ESC_Value__c ='Incident');
         //ESC_CasefromContactFieldValueList__c CaseCS1 = New ESC_CasefromContactFieldValueList__c(name ='ESC_Business_Unit__c',ESC_Value__c ='');
         ESC_CasefromContactFieldValueList__c CaseCS2 = New ESC_CasefromContactFieldValueList__c(name ='Status',ESC_Value__c ='WorkInProgress');
         Cusset.add(CaseCS);
         Cusset.add(CaseCS2);
        // Cusset.add(CaseCS);
         insert Cusset;
         case css = new Case(AccountId=testAccount.Id,ContactId=testContact.Id,Status = 'New',Subject = 'test subject',Description = 'test description');
         insert css;
         list<Case> css1=new list<Case>();        
         css1.add(css);
         Test.StartTest();
         PageReference pageRef = Page.ESC_CreateCaseFromContact;
         Test.setCurrentPage(pageRef);
         pageRef.getParameters().put('Id',ContactSourceSystem.id);
         ApexPages.StandardController sc = new ApexPages.standardController(css);
         ESC_CreateCaseFromContactSSDController cont = new ESC_CreateCaseFromContactSSDController(sc);
          LCRMGenericComponent.isLotusUser();
         cont.CreateCase();
         Test.StopTest();  
     }
    } 
  /* @IsTest(SeeAllData=false) public static void testCreateCaseFromContactSSDController2() {
         
          Profile p1 = [SELECT Id FROM Profile WHERE Name='TR Sales']; 

        UserRole r1 = new UserRole(DeveloperName = 'GLI5', Name = 'My_Role5');
        insert r1;
         User u1 = new User(Alias = 'standt2', Email='sysadmin@2testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing2', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p1.Id,
      TimeZoneSidKey='America/Los_Angeles',UserName='sysadmin2@testorg.com',Segment__c='Professional Legal',Sub_Bu__c='Canada',UserRoleId = r1.Id);
      insert u1;
      
      
System.RunAs(u1)
     {
         Account testAccount1 = New Account();  
         testAccount1.Name= 'TestAccount';
         testAccount1.AccountNumber= 'TestAccount001';
         testAccount1.Phone= '7786864710';
         insert testAccount1 ;
         Contact testContact1 = New Contact(AccountId = testAccount1.id, Salutation = 'Mr' , FirstName = 'John' , LastName= 'Mile',Email ='test@tr.com');
         insert testContact1 ;
         
         BusinessHours defaultBH = [Select Id From BusinessHours Where IsDefault = True limit 1];

List<ESCSegmentRegionMappingSet__c> listESCSegmentRegionMappingSet = new List<ESCSegmentRegionMappingSet__c>();

    ESCSegmentRegionMappingSet__c eseSegmentRMaping =new ESCSegmentRegionMappingSet__c();
    eseSegmentRMaping.ESC_BusHours__c=defaultBH.id;//CHAGE TO QUERY
    eseSegmentRMaping.ESC_OrgWideDisplayName__c='core@tr.com';
    eseSegmentRMaping.ESC_Region__c='Canada';
    eseSegmentRMaping.ESC_Segment__c='Professional Canada';
    //eseSegmentRMaping.ESC_Timezone__c='America/Los_Angeles';
    eseSegmentRMaping.ESC_Role__c='TR_Legal_Sales_Rep1';
    eseSegmentRMaping.ESC_Recordtype__c='Incident';
    eseSegmentRMaping.ESC_IsRecType_BusHours__c='Record Type';
    listESCSegmentRegionMappingSet.add(eseSegmentRMaping);
    
    insert listESCSegmentRegionMappingSet;

List <Case> listcase= new List<Case>();
      Case testCase=ESC_GenericTestutility.testCaseUtil(testContact1.id,TestAccount1.id,'Work in Progress');
      testCase.ESC_Impact__c = '1-Whole Site';
      testCase.subject='tst';
      testCase.ESC_Customer_Symptom__c='Content Addition';
      testCase.ESC_Diagnosis_Summary__c='Content Explanation';
      testCase.ESC_Severity__c='1 - High';
      testCase.ESC_Case_Type__c = 'Request for Service';
      testCase.ESC_Apply_Milestone_Closure_Flag__c = true;
      testCase.BU_segment__c= 'Professional Legal';
      testCase.Lcrm_sub_bu__c= 'Canada';
      
      testCase.RecordtypeID=Schema.SObjectType.Case.getRecordTypeInfosByName().get('Incident').getRecordTypeId();
      testCase.accountID=testAccount1.id;
      testCase.ESC_Apply_Entitlement_Milestone__c=True;
      
      insert testCase;
      listcase.add(testCase);
         
         LCRM_Contact_SSD__c ContactSourceSystem=new LCRM_Contact_SSD__c();
         ContactSourceSystem.CurrencyIsoCode='USD';
         ContactSourceSystem.Name='Nameid';
         insert ContactSourceSystem;
         //Creation of custom settings
           // RecordTypeInfo RecordType11 = Schema.SObjectType.Case.RecordTypeInfosByName.get('Incident');
            list<ESC_CasefromContactFieldValueList__c> Cusset=new list<ESC_CasefromContactFieldValueList__c>();
         ESC_CasefromContactFieldValueList__c CaseCS4 = New ESC_CasefromContactFieldValueList__c(name ='RecordTypeId',ESC_Value__c ='Incident');
         //ESC_CasefromContactFieldValueList__c CaseCS = New ESC_CasefromContactFieldValueList__c(name ='ESC_Business_Unit__c',ESC_Value__c ='');
         ESC_CasefromContactFieldValueList__c CaseCS5 = New ESC_CasefromContactFieldValueList__c(name ='Status',ESC_Value__c ='WorkInProgress');
         Cusset.add(CaseCS4);
         Cusset.add(CaseCS5);
        // Cusset.add(CaseCS);
         insert Cusset;
         case css2 = new Case(AccountId=testAccount1.Id,ContactId=testContact1.Id,Status = 'Work In Progress',Subject = 'test subject',Description = 'test description');
         insert css2;
         list<Case> css3=new list<Case>();        
         css3.add(css2);
         Test.StartTest();
         PageReference pageRef = Page.ESC_CreateCaseFromContact;
         Test.setCurrentPage(pageRef);
         pageRef.getParameters().put('Id',ContactSourceSystem.id);
         ApexPages.StandardController sc2 = new ApexPages.standardController(css2);
         ESC_CreateCaseFromContactSSDController cont2 = new ESC_CreateCaseFromContactSSDController(sc2);
          LCRMGenericComponent.isLotusUser();
         cont2.CreateCase();
         Test.StopTest();  
     }
    }   */
}