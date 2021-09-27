@IsTest
public class ESC_SegmentregionUtility_Test{
@isTest
public static void ESC_SegmentregionUtility_TestMethoid1()
{
List<ESCSegmentRegionMappingSet__c> listESCSegmentRegionMappingSet = new List<ESCSegmentRegionMappingSet__c>();

      Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
      Profile p1 = [SELECT Id FROM Profile WHERE Name='TR Sales'];

UserRole r = new UserRole(DeveloperName = 'TR_Legal_Sales_Rep1', Name = 'My_Role');
insert r;

  User u = new User(Alias = 'standt2', Email='sysadmin@2testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing2', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id,
      TimeZoneSidKey='America/Los_Angeles',UserName='sysadmin2@testorg.com',UserRoleId = r.Id);
      insert u;

User u1 = new User(Alias = 'standt21', Email='sysadmin1241@2testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing2', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p1.Id,
      TimeZoneSidKey='America/Los_Angeles',UserName='sysadmin2214@testorg.com',UserRoleId = r.Id, Segment__c = 'Professional Legal' );
      insert u1;


System.RunAs(u1)
     {
        
   Account testAccount = ESC_GenericTestutility.TestAccountUtil('TestAccount' ,'TestAccount001','7786864710');  
      testAccount.BU_Region__c='Canada';
      testAccount.Bu_Segment__c='Professional Legal';
      insert testAccount;
  //insert contact data
      Contact testContact = ESC_GenericTestutility.TestContactUtil(testAccount.id ,'Mile','test@tr.com');
      testContact.FirstName='Fname';
      insert testContact;

BusinessHours defaultBH = [Select Id From BusinessHours Where TimeZoneSidKey='America/Los_Angeles' limit 1];

ESCSegmentRegionMappingSet__c eseSegmentRMaping =new ESCSegmentRegionMappingSet__c();
eseSegmentRMaping.ESC_BusHours__c=defaultBH.id;//CHAGE TO QUERY
eseSegmentRMaping.ESC_OrgWideDisplayName__c='core@tr.com';
eseSegmentRMaping.ESC_Region__c='Canada';
eseSegmentRMaping.ESC_Segment__c='Professional Legal';
//eseSegmentRMaping.ESC_Timezone__c='America/Los_Angeles';
eseSegmentRMaping.ESC_Role__c='TR_Legal_Sales_Rep1';
eseSegmentRMaping.ESC_Recordtype__c='Incident';
eseSegmentRMaping.ESC_IsRecType_BusHours__c='Record Type';
listESCSegmentRegionMappingSet.add(eseSegmentRMaping);

insert listESCSegmentRegionMappingSet;

List <Case> listcase= new List<Case>();
      Case testCase=ESC_GenericTestutility.testCaseUtil(testContact.id,TestAccount.id,'Work in Progress');
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
      
//ESC_SegmentregionUtility.getDetailInfo(testContact.id,'BusHrs');
ESC_SegmentregionUtility.getDetailInfo(testContact.id,'Rectype');
ESC_SegmentregionUtility.getDetailInfo(testCase.id,'OrgEmailAdd');

}
}



}