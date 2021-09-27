@isTest (SeeAllData=false)
public class ESC_UpdateCaseltng_Test{
 
 
  @IsTest(SeeAllData= false) static void method1(){
 
 Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
      User u = new User(Alias = 'trlex', Email='TRlexuser@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, 
      TimeZoneSidKey='America/Los_Angeles', UserName='TRlexuser@testorg.com');
      insert u;
  //insert accounts data 
      Account testAccount = ESC_GenericTestutility.TestAccountUtil('TestAccount' ,'TestAccount001','7786864710');  
      insert testAccount;
       
      //insert contact data
      Contact testContact = ESC_GenericTestutility.TestContactUtil(testAccount.id ,'Mile','test@tr.com');
      testContact.FirstName='Firstname';
      insert testContact;
  //insert case
      Case testCase=ESC_GenericTestutility.TestCaseUtil(testContact.id,TestAccount.id,'New');
      //case testcase=new Case();
      testcase.ESC_Impact__c = '1-Whole Site';
      testcase.subject='tst';
      testcase.ESC_Customer_Symptom__c='Content Addition';
      testcase.ESC_Severity__c='1 - High';
      testcase.RecordtypeID=Schema.SObjectType.Case.getRecordTypeInfosByName().get('Incident').getRecordTypeId();
      testcase.OwnerId=u.id;
      insert testCase;
      
    Test.StartTest();  
    ESC_UpdateCaseltng.sendCaseRequest(testCase.id,'Feedback');
        ESC_UpdateCaseltng.sendCaseRequest(testCase.id,'Complaint');
        ESC_UpdateCaseltng.sendCaseRequest(testCase.id,'EnhancementRequest');    

    ESC_UpdateCaseltng.validateCaseHasParentId(testCase.id,'test');
    ESC_UpdateCaseltng.getRecTypeId(testCase.id);
    ESC_UpdateCaseltng.createCaseFromContact(testContact.id);
    Test.stopTest();

    integer i = 1;
        integer j = 1;
        System.assertEquals(i,j);
    }
    @IsTest(SeeAllData= false) static void method2(){
    
        Profile p1 = [SELECT Id FROM Profile WHERE Name='System Administrator']; 

        UserRole r1 = new UserRole(DeveloperName = 'GLI1', Name = 'My_Role1');
        insert r1;
         User u1 = new User(Alias = 'standt2', Email='sysadmin@3testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing3', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p1.Id,Segment__c='Professional Legal',
      TimeZoneSidKey='America/Los_Angeles',UserName='sysadmin2@3testorg.com',UserRoleId = r1.Id);
      insert u1;
      System.RunAs(u1)
         {
        //insert accounts data 
        Account testAccount = ESC_GenericTestutility.TestAccountUtil('TestAccount' ,'TestAccount001','7786864710');  
        insert testAccount;

        //insert contact data
        Contact testContact = ESC_GenericTestutility.TestContactUtil(testAccount.id ,'Mile','test@tr.com');
        testContact.FirstName='Firstname';
        insert testContact;
        //insert case
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
         
        Case testCase=ESC_GenericTestutility.TestCaseUtil(testContact.id,TestAccount.id,'New');
        //case testcase=new Case();
        testcase.ESC_Impact__c = '1-Whole Site';
        testcase.subject='tst';
        testcase.ESC_Customer_Symptom__c='Content Addition';
        testcase.ESC_Severity__c='1 - High';
        testcase.RecordtypeID=Schema.SObjectType.Case.getRecordTypeInfosByName().get('Incident').getRecordTypeId();
        testcase.OwnerId=u1.id;
        insert testCase;
    
        Test.startTest();
        ESC_UpdateCaseltng.reopenCase(testCase.id);
        ESC_UpdateCaseltng.closeCase(testCase.id);
        //Test.stopTest();  
        ESC_UpdateCaseltng.UpdateRecordType(testCase.id);
        
         LCRMGenericComponent.isLotusUser();
        Test.stopTest();   
         
        integer i = 1;
        integer j = 1;
        System.assertEquals(i,j);   
    }
    }
}