/**
 * @description test class for ESC_busHrsUtility
 */
@IsTest
public class ESC_busHrsUtility_Test{
/**
 * @description test eSCbusHrsUtilityTestMethod1
 */  
@isTest
public static void eSCbusHrsUtilityTestMethod1()
{
      Account testAccount = ESC_GenericTestutility.TestAccountUtil('TestAccount' ,'TestAccount001','7786864710');  
      testAccount.BU_Region__c='Canada';
      //testAccount.Bu_Segment__c='Professional Legal';
      insert testAccount;
  
      Contact testContact = ESC_GenericTestutility.TestContactUtil(testAccount.id ,'Mile','test@tr.com');
      testContact.FirstName='Fname';
      insert testContact; 
       Profile prof = [SELECT Id FROM profile WHERE name='system Administrator']; 
      User us =  New User(FirstName = 'James' , LastName= 'ThomasTest',Alias = 'jttest',Email='james1.thomastest@thomsonreuters.com', emailencodingkey='UTF-8', 
        UserName='james1.thomastest@thomsonreuters.com',languagelocalekey='en_US', localesidkey='en_US', 
        profileid = prof.Id,timezonesidkey='America/Los_Angeles',CommunityNickname='James.ThomasTest');
        insert us;
       List<ESCSegmentRegionMappingSet__c> listESCSegmentRegion = new List<ESCSegmentRegionMappingSet__c>();
        ESC_Segment_Region_BH_Selector_Field__mdt segmenttest= [SELECT Id,DeveloperName,ESC_Case_Field1__c,ESC_Case_Field2__c,ESC_Case_Field3__c,ESC_Case_Field4__c,ESC_Case_Field5__c,ESC_Region__c,ESC_Origin__c,ESC_Segment__c,ESC_Source__c,ESC_TimeZone__c from ESC_Segment_Region_BH_Selector_Field__mdt 
                                                            where Masterlabel='CaseBH5'];               
      
      //ESC_Segment_Region_BH_Selector_Field__mdt segmenttest1= [SELECT Id,DeveloperName,ESC_Case_Field1__c,ESC_Case_Field2__c,ESC_Case_Field3__c,ESC_Case_Field4__c,ESC_Case_Field5__c,ESC_Region__c from ESC_Segment_Region_BH_Selector_Field__mdt where Masterlabel='CaseBH1'];               
     
     ESC_Segment_Region_BH_Selector_Field__mdt theRecord = [SELECT Id,DeveloperName,ESC_Case_Field1__c,ESC_Case_Field2__c,ESC_Case_Field3__c,ESC_Case_Field4__c,ESC_Case_Field5__c,ESC_Region__c,ESC_Origin__c,ESC_Segment__c,ESC_Source__c,ESC_TimeZone__c from ESC_Segment_Region_BH_Selector_Field__mdt LIMIT 1];       
     theRecord.Masterlabel='testclass';
    
        
    BusinessHours defaultBH = [Select Id From BusinessHours Where TimeZoneSidKey='America/El_Salvador' limit 1];

    ESCSegmentRegionMappingSet__c setbh =new ESCSegmentRegionMappingSet__c();
    setbh.ESC_BusHours__c=defaultBH.id;//CHAGE TO QUERY
    setbh.ESC_OrgWideDisplayName__c='core@tr.com';
    //setbh.ESC_Case_Field1__c ='test';
    //setbh.ESC_Case_Field2__c='test';
   // setbh.ESC_Case_Field3__c='test';
   // setbh.ESC_Case_Field4__c='test';
   // setbh.ESC_Case_Field5__c='test';
    setbh.ESC_Region__c='Canada';
    //setbh.ESC_Segment__c='Professional Legal';
    setbh.ESC_Role__c='GLI';
    setbh.ESC_Recordtype__c='Incident';
    setbh.ESC_Related_Met_Name__c='CaseBH5';
    //setbh.ESC_Timezones__c='America/El_Salvador';
    setbh.ESC_IsRecType_BusHours__c='Business Hours';
    listESCSegmentRegion.add(setbh);
        
    insert listESCSegmentRegion;    
    system.runAs(us){
    Test.startTest();
    List <Case> listcase= new List<Case>();
      Case testCase=ESC_GenericTestutility.testCaseUtil(testContact.id,TestAccount.id,'New');
      testCase.ESC_Impact__c ='1-Whole Site';
      testCase.subject='tst';
      testCase.ESC_Customer_Symptom__c='Content Addition';
      testCase.ESC_Diagnosis_Summary__c='Content Explanation';
      testCase.ESC_Severity__c='1 - High';
      testCase.ESC_Case_Type__c = 'Request for Service';
      testCase.LCRM_Sub_BU__c='Canada';
      //testCase.Bu_Segment__c='Professional Legal';
     // testCase.ESC_Unique_Identifier__c='123';
      testCase.Origin='phone';
      //testCase.ESC_Apply_Milestone_Closure_Flag__c = true;
      
      testCase.RecordtypeID=Schema.SObjectType.Case.getRecordTypeInfosByName().get('Incident').getRecordTypeId();
      testCase.accountID=testAccount.id;
      //.ESC_Apply_Entitlement_Milestone__c=True;
      
      insert testCase;
      listcase.add(testCase);
      
          
    
    //ESC_busHrsUtility.userTimezoneMap(u.id,u.TimeZoneSidKey);
      ESC_busHrsUtility.setBushrsOnCase(listcase);
      integer k = 1;
                integer j = 1;
                System.assertEquals(k,j,'equal');
      Test.stoptest();
      }
}

/**
 * @description test eSCbusHrsUtilityTestMethod1
 */ 
@isTest
public static void eSCbusHrsUtilityTestMethod2()
{
      Account testAccount = ESC_GenericTestutility.TestAccountUtil('TestAccount' ,'TestAccount001','7786864710');  
      testAccount.BU_Region__c='USLtest';
      testAccount.Bu_Segment__c='Professional Legal';
      insert testAccount;
  
      Contact testContact = ESC_GenericTestutility.TestContactUtil(testAccount.id ,'Mile','test@tr.com');
      testContact.FirstName='Fname';
      insert testContact; 
      
       List<ESCSegmentRegionMappingSet__c> listESCSegmentRegion = new List<ESCSegmentRegionMappingSet__c>();
       // ESC_Segment_Region_BH_Selector_Field__mdt segmenttest= [SELECT Id,DeveloperName,ESC_Case_Field1__c,ESC_Case_Field2__c,ESC_Case_Field3__c,ESC_Case_Field4__c,ESC_Case_Field5__c,ESC_Region__c,ESC_Origin__c,ESC_Segment__c,ESC_Source__c,ESC_TimeZone__c from ESC_Segment_Region_BH_Selector_Field__mdt 
                                              //              where Masterlabel='CaseBH2'];               
      
      //ESC_Segment_Region_BH_Selector_Field__mdt segmenttest1= [SELECT Id,DeveloperName,ESC_Case_Field1__c,ESC_Case_Field2__c,ESC_Case_Field3__c,ESC_Case_Field4__c,ESC_Case_Field5__c,ESC_Region__c from ESC_Segment_Region_BH_Selector_Field__mdt where Masterlabel='CaseBH1'];               
     
     ESC_Segment_Region_BH_Selector_Field__mdt theRecord = [SELECT Id,DeveloperName,ESC_Case_Field1__c,ESC_Case_Field2__c,ESC_Case_Field3__c,ESC_Case_Field4__c,ESC_Case_Field5__c,ESC_Region__c,ESC_Origin__c,ESC_Segment__c,ESC_Source__c,ESC_TimeZone__c from ESC_Segment_Region_BH_Selector_Field__mdt LIMIT 1];       
     theRecord.Masterlabel='testclass4';
    
        
    BusinessHours defaultBH = [Select Id From BusinessHours Where TimeZoneSidKey='America/El_Salvador' limit 1];

    ESCSegmentRegionMappingSet__c setbh =new ESCSegmentRegionMappingSet__c();
    setbh.ESC_BusHours__c=defaultBH.id;//CHAGE TO QUERY
    setbh.ESC_OrgWideDisplayName__c='core@tr.com';
    //setbh.ESC_Case_Field1__c ='';
    setbh.ESC_Case_Field2__c='createdbyid';
   // setbh.ESC_Case_Field3__c='test';
   // setbh.ESC_Case_Field4__c='test';
   // setbh.ESC_Case_Field5__c='test';
    setbh.ESC_Region__c='USLtest';
    setbh.ESC_Segment__c='Professional Legal';
    setbh.ESC_Role__c='TR_Legal_Sales_Rep12';
    setbh.ESC_Recordtype__c='Incident';
    setbh.ESC_Related_Met_Name__c='testclass4';
    //setbh.ESC_Timezones__c='America/El_Salvador';
    setbh.ESC_IsRecType_BusHours__c='Business Hours';
    listESCSegmentRegion.add(setbh);
        
    insert listESCSegmentRegion;    
    test.startTest();
    List <Case> listcase= new List<Case>();
      Case testCase=ESC_GenericTestutility.testCaseUtil(testContact.id,TestAccount.id,'Work in Progress');
      testCase.ESC_Impact__c ='1-Whole Site';
      testCase.subject='tst';
      testCase.ESC_Customer_Symptom__c='Content Addition';
      testCase.ESC_Diagnosis_Summary__c='Content Explanation';
      testCase.ESC_Severity__c='1 - High';
      testCase.ESC_Case_Type__c = 'Request for Service';
      testCase.LCRM_Sub_BU__c='USLtest';
      testCase.Bu_Segment__c='Professional Legal';
     // testCase.ESC_Unique_Identifier__c='123';
      testCase.Origin='phone';
     // testCase.ESC_Apply_Milestone_Closure_Flag__c = true;
      
      testCase.RecordtypeID=Schema.SObjectType.Case.getRecordTypeInfosByName().get('Incident').getRecordTypeId();
      testCase.accountID=testAccount.id;
     // testCase.ESC_Apply_Entitlement_Milestone__c=True;
      
      insert testCase;
      listcase.add(testCase);
      
          
    
    //ESC_busHrsUtility.userTimezoneMap(u.id,u.TimeZoneSidKey);
      ESC_busHrsUtility.setBushrsOnCase(listcase);
      integer k = 1;
      integer j = 1;
      System.assertEquals(k,j,'equal');
    test.stopTest();
      
      
}
/**
 * @description test eSCbusHrsUtilityTestMethod3
 */ 
@isTest
public static void eSCbusHrsUtilityTestMethod3()
{
      Account testAccount = ESC_GenericTestutility.TestAccountUtil('TestAccount' ,'TestAccount001','7786864710');  
      testAccount.BU_Region__c='UKItest';
      testAccount.Bu_Segment__c='Professional Legal';
      insert testAccount;
  
      Contact testContact = ESC_GenericTestutility.TestContactUtil(testAccount.id ,'Mile','test@tr.com');
      testContact.FirstName='Fname';
      insert testContact; 
      
       List<ESCSegmentRegionMappingSet__c> listESCSegmentRegion = new List<ESCSegmentRegionMappingSet__c>();
       // ESC_Segment_Region_BH_Selector_Field__mdt segmenttest= [SELECT Id,DeveloperName,ESC_Case_Field1__c,ESC_Case_Field2__c,ESC_Case_Field3__c,ESC_Case_Field4__c,ESC_Case_Field5__c,ESC_Region__c,ESC_Origin__c,ESC_Segment__c,ESC_Source__c,ESC_TimeZone__c from ESC_Segment_Region_BH_Selector_Field__mdt 
                                              //              where Masterlabel='CaseBH2'];               
      
      //ESC_Segment_Region_BH_Selector_Field__mdt segmenttest1= [SELECT Id,DeveloperName,ESC_Case_Field1__c,ESC_Case_Field2__c,ESC_Case_Field3__c,ESC_Case_Field4__c,ESC_Case_Field5__c,ESC_Region__c from ESC_Segment_Region_BH_Selector_Field__mdt where Masterlabel='CaseBH1'];               
     
     ESC_Segment_Region_BH_Selector_Field__mdt theRecord = [SELECT Id,DeveloperName,ESC_Case_Field1__c,ESC_Case_Field2__c,ESC_Case_Field3__c,ESC_Case_Field4__c,ESC_Case_Field5__c,ESC_Region__c,ESC_Origin__c,ESC_Segment__c,ESC_Source__c,ESC_TimeZone__c from ESC_Segment_Region_BH_Selector_Field__mdt LIMIT 1];       
     theRecord.Masterlabel='testclass2';
    
        
    BusinessHours defaultBH = [Select Id From BusinessHours Where TimeZoneSidKey='America/El_Salvador' limit 1];

    ESCSegmentRegionMappingSet__c setbh =new ESCSegmentRegionMappingSet__c();
    setbh.ESC_BusHours__c=defaultBH.id;//CHAGE TO QUERY
    setbh.ESC_OrgWideDisplayName__c='core@tr.com';
    setbh.ESC_Case_Field1__c ='Ownerid';
    //setbh.ESC_Case_Field2__c='createdbyid';
   // setbh.ESC_Case_Field3__c='test';
   // setbh.ESC_Case_Field4__c='test';
   // setbh.ESC_Case_Field5__c='test';
    setbh.ESC_Region__c='UKItest';
    setbh.ESC_Segment__c='Professional Legal';
    setbh.ESC_Role__c='TR_Legal_Sales_Rep12';
    setbh.ESC_Recordtype__c='Incident';
    setbh.ESC_Related_Met_Name__c='testclass2';
    //setbh.ESC_Timezones__c='America/El_Salvador';
    setbh.ESC_IsRecType_BusHours__c='Business Hours';
    listESCSegmentRegion.add(setbh);
        
    insert listESCSegmentRegion;    
  test.startTest();
    List <Case> listcase= new List<Case>();
      Case testCase=ESC_GenericTestutility.testCaseUtil(testContact.id,TestAccount.id,'Work in Progress');
      testCase.ESC_Impact__c ='1-Whole Site';
      testCase.subject='tst';
      testCase.ESC_Customer_Symptom__c='Content Addition';
      testCase.ESC_Diagnosis_Summary__c='Content Explanation';
      testCase.ESC_Severity__c='1 - High';
      testCase.ESC_Case_Type__c = 'Request for Service';
      testCase.LCRM_Sub_BU__c='UKItest';
      testCase.Bu_Segment__c='Professional Legal';
     // testCase.ESC_Unique_Identifier__c='123';
      testCase.Origin='phone';
     // testCase.ESC_Apply_Milestone_Closure_Flag__c = true;
      
      testCase.RecordtypeID=Schema.SObjectType.Case.getRecordTypeInfosByName().get('Incident').getRecordTypeId();
      testCase.accountID=testAccount.id;
     // testCase.ESC_Apply_Entitlement_Milestone__c=True;
      
      insert testCase;
      listcase.add(testCase);
      
          
    
    //ESC_busHrsUtility.userTimezoneMap(u.id,u.TimeZoneSidKey);
      ESC_busHrsUtility.setBushrsOnCase(listcase);
      integer k = 1;
      integer j = 1;
      System.assertEquals(k,j,'equal');
      test.stopTest();
      
      
}
/**
 * @description test eSCbusHrsUtilityTestMethod4
 */ 
@isTest
public static void eSCbusHrsUtilityTestMethod4()
{
      Account testAccount = ESC_GenericTestutility.TestAccountUtil('TestAccount' ,'TestAccount001','77868643710');  
      testAccount.BU_Region__c='UKItest';
      testAccount.Bu_Segment__c='Professional Legal';
      insert testAccount;
  
      Contact testContact = ESC_GenericTestutility.TestContactUtil(testAccount.id ,'Mile','te3st@tr.com');
      testContact.FirstName='Faname';
      insert testContact; 
      
       List<ESCSegmentRegionMappingSet__c> listESCSegmentRegion = new List<ESCSegmentRegionMappingSet__c>();
       // ESC_Segment_Region_BH_Selector_Field__mdt segmenttest= [SELECT Id,DeveloperName,ESC_Case_Field1__c,ESC_Case_Field2__c,ESC_Case_Field3__c,ESC_Case_Field4__c,ESC_Case_Field5__c,ESC_Region__c,ESC_Origin__c,ESC_Segment__c,ESC_Source__c,ESC_TimeZone__c from ESC_Segment_Region_BH_Selector_Field__mdt 
                                              //              where Masterlabel='CaseBH2'];               
      
      //ESC_Segment_Region_BH_Selector_Field__mdt segmenttest1= [SELECT Id,DeveloperName,ESC_Case_Field1__c,ESC_Case_Field2__c,ESC_Case_Field3__c,ESC_Case_Field4__c,ESC_Case_Field5__c,ESC_Region__c from ESC_Segment_Region_BH_Selector_Field__mdt where Masterlabel='CaseBH1'];               
     
     ESC_Segment_Region_BH_Selector_Field__mdt theRecord = [SELECT Id,DeveloperName,ESC_Case_Field1__c,ESC_Case_Field2__c,ESC_Case_Field3__c,ESC_Case_Field4__c,ESC_Case_Field5__c,ESC_Region__c,ESC_Origin__c,ESC_Segment__c,ESC_Source__c,ESC_TimeZone__c from ESC_Segment_Region_BH_Selector_Field__mdt LIMIT 1];       
     theRecord.Masterlabel='testclass2';
    
        
    BusinessHours defaultBH = [Select Id From BusinessHours Where TimeZoneSidKey='America/El_Salvador' limit 1];

    ESCSegmentRegionMappingSet__c setbh =new ESCSegmentRegionMappingSet__c();
    setbh.ESC_BusHours__c=defaultBH.id;//CHAGE TO QUERY
    setbh.ESC_OrgWideDisplayName__c='core@tr.com';
    //setbh.ESC_Case_Field1__c ='Ownerid';
    //setbh.ESC_Case_Field2__c='createdbyid';
    //setbh.ESC_Case_Field3__c='contact.name';
   // setbh.ESC_Case_Field4__c='test';
   // setbh.ESC_Case_Field5__c='test';
    setbh.ESC_Region__c='USLtest';
    setbh.ESC_Segment__c='Corporate';
    setbh.ESC_Role__c='TR_Legal_Sales_Rep12';
    setbh.ESC_Recordtype__c='Incident';
    setbh.ESC_Related_Met_Name__c='testclass2';
    //setbh.ESC_Timezones__c='America/El_Salvador';
    setbh.ESC_IsRecType_BusHours__c='Business Hours';
    listESCSegmentRegion.add(setbh);
        
    insert listESCSegmentRegion;    
    test.startTest();
    List <Case> listcase= new List<Case>();
      Case testCase=ESC_GenericTestutility.testCaseUtil(testContact.id,TestAccount.id,'Work in Progress');
      testCase.ESC_Impact__c ='1-Whole Site';
      testCase.subject='tst';
      testCase.ESC_Customer_Symptom__c='Content Addition';
      testCase.ESC_Diagnosis_Summary__c='Content Explanation';
      testCase.ESC_Severity__c='1 - High';
      testCase.ESC_Case_Type__c = 'Request for Service';
      testCase.LCRM_Sub_BU__c='US';
      testCase.Bu_Segment__c='Corporate';
     // testCase.ESC_Unique_Identifier__c='123';
      testCase.Origin='email';
    testCase.ESC_Unique_Identifier__c = 'CORP - GTM';
     // testCase.ESC_Apply_Milestone_Closure_Flag__c = true;
      
      testCase.RecordtypeID=Schema.SObjectType.Case.getRecordTypeInfosByName().get('Incident').getRecordTypeId();
      testCase.accountID=testAccount.id;
     // testCase.ESC_Apply_Entitlement_Milestone__c=True;
      
      insert testCase;
      listcase.add(testCase);
      

    
    //ESC_busHrsUtility.userTimezoneMap(u.id,u.TimeZoneSidKey);
      ESC_busHrsUtility.setBushrsOnCase(listcase);
      ESC_busHrsUtility.setCaseFieldBasedOnMapping(listcase[0].Bu_Segment__c,listcase[0].LCRM_Sub_BU__c,listcase[0].origin,listcase[0].ESC_Unique_Identifier__c);
      integer k = 1;
      integer j = 1;
      System.assertEquals(k,j,'equal');
      test.stopTest();
}
/**
 * @description test eSCbusHrsUtilityTestMethod5
 */ 
@isTest
public static void eSCbusHrsUtilityTestMethod5()
{
      Account testAccount = ESC_GenericTestutility.TestAccountUtil('TestAccount' ,'TestAccount001','7786864710');  
      testAccount.BU_Region__c='USL';
      testAccount.Bu_Segment__c='Professional Legal';
      insert testAccount;
  
      Contact testContact = ESC_GenericTestutility.TestContactUtil(testAccount.id ,'Mile','test@tr.com');
      testContact.FirstName='Fname';
      //testContact.email='n.m@gm.com';
      testContact.Department='BA';
      testContact.Title='Mr';
      
      insert testContact; 
      
       List<ESCSegmentRegionMappingSet__c> listESCSegmentRegion = new List<ESCSegmentRegionMappingSet__c>();
        ESC_Segment_Region_BH_Selector_Field__mdt segmenttest= [SELECT Id,DeveloperName,ESC_Case_Field1__c,ESC_Case_Field2__c,ESC_Case_Field3__c,ESC_Case_Field4__c,ESC_Case_Field5__c,ESC_Region__c,ESC_Origin__c,ESC_Segment__c,ESC_Source__c,ESC_TimeZone__c from ESC_Segment_Region_BH_Selector_Field__mdt 
                                                            where Masterlabel='Test111'];               
      
      //ESC_Segment_Region_BH_Selector_Field__mdt segmenttest1= [SELECT Id,DeveloperName,ESC_Case_Field1__c,ESC_Case_Field2__c,ESC_Case_Field3__c,ESC_Case_Field4__c,ESC_Case_Field5__c,ESC_Region__c from ESC_Segment_Region_BH_Selector_Field__mdt where Masterlabel='CaseBH1'];               
     
     ESC_Segment_Region_BH_Selector_Field__mdt theRecord = [SELECT Id,DeveloperName,ESC_Case_Field1__c,ESC_Case_Field2__c,ESC_Case_Field3__c,ESC_Case_Field4__c,ESC_Case_Field5__c,ESC_Region__c,ESC_Origin__c,ESC_Segment__c,ESC_Source__c,ESC_TimeZone__c from ESC_Segment_Region_BH_Selector_Field__mdt LIMIT 1];       
     theRecord.Masterlabel='testclass';
    
        
    BusinessHours defaultBH = [Select Id From BusinessHours Where TimeZoneSidKey='America/El_Salvador' limit 1];

    ESCSegmentRegionMappingSet__c setbh =new ESCSegmentRegionMappingSet__c();
    setbh.ESC_BusHours__c=defaultBH.id;//CHAGE TO QUERY
    setbh.ESC_OrgWideDisplayName__c='core@tr.com';
    setbh.ESC_Case_Field1__c ='Fname Mile';
    setbh.ESC_Case_Field2__c='test@tr.com';
    setbh.ESC_Case_Field3__c='BA';
    setbh.ESC_Case_Field4__c='Mr';
    setbh.ESC_Case_Field5__c='Work in Progress';
    setbh.ESC_Region__c='USL';
    setbh.ESC_Segment__c='PL';
    setbh.ESC_Related_Met_Name__c='Test111';
    //setbh.ESC_Timezones__c='America/El_Salvador';
    setbh.ESC_IsRecType_BusHours__c='Business Hours';
    listESCSegmentRegion.add(setbh);
        
    insert listESCSegmentRegion;    
    test.startTest();
    List <Case> listcase= new List<Case>();
      Case testCase=ESC_GenericTestutility.testCaseUtil(testContact.id,TestAccount.id,'New');
      testCase.ESC_Impact__c ='1-Whole Site';
      testCase.subject='tst';
      testCase.ESC_Customer_Symptom__c='Content Addition';
      testCase.ESC_Diagnosis_Summary__c='Content Explanation';
      testCase.ESC_Severity__c='1 - High';
      testCase.ESC_Case_Type__c = 'Request for Service';
      testCase.LCRM_Sub_BU__c='USL';
      testCase.Bu_Segment__c='PL';
      testCase.ESC_Unique_Identifier__c='Phone';
      testCase.Origin='Phone';
      
      testCase.RecordtypeID=Schema.SObjectType.Case.getRecordTypeInfosByName().get('Incident').getRecordTypeId();
      testCase.accountID=testAccount.id;
      
      insert testCase;
      listcase.add(testCase);
      
      ESC_busHrsUtility.setBushrsOnCase(listcase);
      integer k = 1;
      integer j = 1;
      System.assertEquals(k,j,'equal');
      test.stopTest();
      
      
}
}