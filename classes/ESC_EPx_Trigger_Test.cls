@isTest
public class ESC_EPx_Trigger_Test{
public static User user;
public static User user1;
public static User manager;
//public static Id recordTypeIdIncident = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Incident').getRecordTypeId();
public static List<ESC_EPx_RecordTypesAvailable__c> custSetAvailableRecordTypes = new List<ESC_EPx_RecordTypesAvailable__c>();
  public static Id recTypeFeedback = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Feedback').getRecordTypeId();
    public static Id recTypeEPsComplete = Schema.SObjectType.ESC_EPx__c.getRecordTypeInfosByName().get('ESC_EPs_Complete').getRecordTypeId(); 
    public static Id recTypeEscalation = Schema.SObjectType.ESC_Case_Collaborator__c.getRecordTypeInfosByName().get('Escalations').getRecordTypeId();
    public static Id recordTypeIdComplete = Schema.SObjectType.ESC_EPx__c.getRecordTypeInfosByName().get('ESC_EPs_Complete').getRecordTypeId();
    public static Id recordTypeIdSent = Schema.SObjectType.ESC_EPx__c.getRecordTypeInfosByName().get('ESC_EPs_Sent').getRecordTypeId();
    public static Id recordTypeIdIncident = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Incident').getRecordTypeId();
    public static Id recordTypeIdIncidentRO = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Incident (Read Only)').getRecordTypeId();
    public static ESC_EPx__c s;
    public static ESC_EPx_Template_Selector__c ts;
    static List<ESC_EPx__c> EPxList;
    static Map<id,ESC_EPX__c> newEPsMap;
    static Map<id,ESC_EPX__c> oldEPsMap;
    static List<Case> caseList;
    static case relatedCase;

  public static void init(){
  
  manager = new User(
                ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id,
                LastName = 'last',
                Email = 'puserManager000@amamama.com',
                Username = 'puserManager000@amamama.com' + System.currentTimeMillis(),
                CompanyName = 'TEST',
                Title = 'title',
                Alias = 'alias',
                TimeZoneSidKey = 'America/Los_Angeles',
                EmailEncodingKey = 'UTF-8',
                LanguageLocaleKey = 'en_US',
                LocaleSidKey = 'en_US'
                //ManagerId =
                //UserRoleId = r.Id
        );
        insert manager;
        
    user = new User(
             ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id,
             LastName = 'last',
             Email = 'puser000@amamama.com',
             Username = 'puser000@amamama.com' + System.currentTimeMillis(),
             CompanyName = 'TEST',
             Title = 'title',
             Alias = 'alias',
             TimeZoneSidKey = 'America/Los_Angeles',
             EmailEncodingKey = 'UTF-8',
             LanguageLocaleKey = 'en_US',
             LocaleSidKey = 'en_US',
             ManagerId = manager.id
             //UserRoleId = r.Id
       );
       insert user;
       
       user1 = new User(
             ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id,
             LastName = 'last',
             Email = 'puser000@amamama.com',
             Username = 'puser000@amamama.com' + System.currentTimeMillis(),
             CompanyName = 'TEST',
             Title = 'title',
             Alias = 'alias',
             TimeZoneSidKey = 'America/Los_Angeles',
             EmailEncodingKey = 'UTF-8',
             LanguageLocaleKey = 'en_US',
             LocaleSidKey = 'en_US',
             ManagerId = manager.id,
             IsActive = false
             //UserRoleId = r.Id
       );
       insert user1;
       
       
    System.RunAs(user){
             
     Account acc=new account();
     acc.Name = 'Test Account';
     acc.ESC_OptOut_CSAT_Check__c = false;
      insert acc; 
     
     contact con =new contact();
      con.LastName = 'Test Contact';
        con.FirstName = 'test';
        con.ESC_OptOut_CSAT_Check__c = false;
        con.ESC_Frequency_Cap__c = 5;
        con.accountid=acc.id;
        insert con;     
       
     relatedCase =new case();
     relatedCase.Accountid = acc.id;
        relatedCase.Ownerid = user.id;
        relatedCase.contactid = con.id;
        relatedCase.recordTypeId = recordTypeIdIncident; 
        relatedCase.description = 'test';
        relatedCase.ESC_Proactive_Type__c = '';
        //relatedCase.Service_Product_Category__c = '';
        relatedCase.ESC_Diagnosis_Summary__c = '';
        insert relatedCase;   
        
        
      EmailTemplate e;
        try{
            e = new EmailTemplate (developerName = 'testmainhello11221', FolderId = UserInfo.getOrganizationId(), TemplateType= 'Text', Name = 'test');
            insert e;
           }
           catch(Exception ex){}
         
         
         ts = new ESC_EPx_Template_Selector__c();
         ts.ESC_EPs_Delay_Mins__c = 0;
         ts.ESC_EPx_Email_Template__c = e.id;
         ts.ESC_Expiration_In_Days__c = 3;
         //ts.ESC_SurveyFailover_Language__c;
         ts.Profile__c = 'Standard User,System Administrator';
         ts.Record_Type__c = 'Incident';
         ts.ESC_EPs_Make_EscalationScore__c = 45;
         ts.ESC_EPs_Make_FeedbackScore__c = 1;
        // ts.ESC_EPs_Reopen_Auto__c = true;
         //ts.Case_Field_1__c = 'Description';
         //ts.Case_Value_1__c = 'test';
         //ts.Condition_1__c = '=';
         insert ts;
 
 
  Languages__c langEnglish = new Languages__c(
                ISO_Code__c = 'en',
                Language_Name__c = 'English',
                Salesforce_ISO_Code__c = 'en_US'
        );

        Languages__c langEnglishDefault = new Languages__c(
                ISO_Code__c = 'en',
                Language_Name__c = 'English (Default)',
                Salesforce_ISO_Code__c = 'en_US'
        );
        
        
        insert langEnglish;
        insert langEnglishDefault;
        
        list<ESC_EPs_Re_openValues__c> custSetReopen =new list<ESC_EPs_Re_openValues__c>();
        ESC_EPs_Re_openValues__c record1 = new ESC_EPs_Re_openValues__c();
        record1.Name = 'Reopen1';
        record1.Field__c = 'status';
        record1.Value__c = 'Work In Progress';
        
        ESC_EPs_Re_openValues__c record2 = new ESC_EPs_Re_openValues__c();
        record2.Name = 'Reopen2';
        record2.Field__c = 'ESC_Last_Update__c';
        record2.Value__c = 'Re-opened by Customer';
        
        ESC_EPs_Re_openValues__c record3 = new ESC_EPs_Re_openValues__c();
        record3.Name = 'Reopen3';
        record3.Field__c = 'ESC_UPD__c';
        record3.Value__c = 'true';
            
        custSetReopen.add(record1);
        custSetReopen.add(record2);
        custSetReopen.add(record3);
        
        insert custSetReopen;
        
        
        ESC_EPx_RecordTypesAvailable__c EPXRecordtype =new ESC_EPx_RecordTypesAvailable__c(Name = 'rec1', RecordTypes__c = 'Incident');
        
        
        insert EPXRecordtype;

        ESC_EPx_DeclineCriteria__c EPXDecline =new ESC_EPx_DeclineCriteria__c(Name = 'dec2', User_Role__c = '', Object_Name__c = 'Contact' , Object_Field_Name__c = 'ESC_OptOut_CSAT_Check__c',  Field_Value__c = 'True' );
            insert EPXDecline;
        
        ESC_EPx_DeclineCriteria__c EPXDecline1 = new ESC_EPx_DeclineCriteria__c(Name = 'dec3', User_Role__c = '', Object_Name__c = 'Case' , Object_Field_Name__c = 'ESC_Proactive_Type__c',  Field_Value__c = 'Internal' );
        
            insert EPXDecline1;
        ESC_EPx_DeclineCriteria__c EPXDecline2 =new ESC_EPx_DeclineCriteria__c(Name = 'dec4', User_Role__c = '', Object_Name__c = 'Case' , Object_Field_Name__c = 'ESC_Proactive_Type__c',  Field_Value__c = 'Social Media' );
        
            insert EPXDecline2;
        ESC_EPx_DeclineCriteria__c EPXDecline3 = new ESC_EPx_DeclineCriteria__c(Name = 'dec5', User_Role__c = '', Object_Name__c = 'Case' , Object_Field_Name__c = 'description',  Field_Value__c = 'testabc' );
        
            insert EPXDecline3;
      

        s = new ESC_EPx__c();
        s.ESC_Case__c = relatedCase.id;
        s.ESC_Case_Owner__c = relatedCase.Ownerid;
        s.ESC_EPX_Case_Owner__c = relatedCase.Ownerid;
        s.ESC_EPx_Template_Selector__c = ts.id;
        s.ESC_EPs_Is_Solved_Answer__c = 'Issue was not resolved';
        s.ESC_EPx_Expired_Response__c = false;
        s.ESC_EPx_Category__c = 'EPs';
        s.ESC_EPx_Decimal_Score__c = -1;
        s.Date_Time_Sent__c=Date.newInstance(2020, 4, 9);

        //s.ESC_EPx_Type__c = ''
        
        insert s;
        
        EpxList = new List<ESC_EPx__c>();
        EPxList.add(s);
        
        newEpsMap = new Map<id,ESC_EPX__c>();
        newEPsMap.put(s.id,s);
         
        oldEPsMap = new Map<id,ESC_EPX__c>();
        oldEPsMap.put(s.id,s);
        
        caseList = new List<Case>();
        caseList.add(relatedCase);
        
  
  }
  }

 public static testmethod void TestESC_EPx_Trigger_Test(){
 
     init();
     test.startTest();
     System.RunAs(user){
      ESC_EPx_Trigger_Methods EpxTrigger = new ESC_EPx_Trigger_Methods(EPxList,newEPsMap,oldEPsMap);
          //EpxTrigger.expirationCheck();
          EpxTrigger.getRelatedCase(s);
          EpxTrigger.getListTemplateSelectors();
          EPxTrigger.getMapTemplateSelectors();    
      }
     
      test.stopTest();
        
    }   
  
  
  public static testMethod void test1(){
      init();
      test.startTest();
      
      System.RunAs(user){
          ESC_EPx_Trigger_Methods EpxTrigger = new ESC_EPx_Trigger_Methods(EPxList,newEPsMap,oldEPsMap);
          EpxTrigger.setCaseOwnerAndTeam();
          EpxTrigger.setLanguage();
          //EpxTrigger.reopenCases();
          reopenCase(EpxTrigger);
          EpxTrigger.getOwnerId(s, relatedCase);
          EpxTrigger.createFeedbackCases();
          //EpxTrigger.createEscalations();
      }
      
      test.stopTest();

  }
  
  public static testMethod void test2(){
      init();
      test.startTest();
      
      System.RunAs(user){
          ESC_EPx_Trigger_Methods EpxTrigger = new ESC_EPx_Trigger_Methods(EPxList,newEPsMap,oldEPsMap);
          EpxTrigger.getTemplateSelector(s);
          EpxTrigger.getAuthSessionMap();
          EpxTrigger.setSurveyType();
          
       }
       test.stopTest();
  }
  
  public static testMethod void test3(){
  init();
      test.startTest();
      
      System.RunAs(user){
          ESC_EPx_Trigger_Methods EpxTrigger = new ESC_EPx_Trigger_Methods(EPxList,newEPsMap,oldEPsMap);
          //EpxTrigger.createEscalations();
          EpxTrigger.userIsActive(user.id);
          ESC_EPx_Trigger_Methods.removeScheduledSurveysOnCaseReopen(caseList);
          ESC_EPX_Language_List_Wrapper langWrapper = ESC_EPX_Language_List_Wrapper.getInstance();
          langWrapper.getLanguageByName('English');
          langWrapper.getLanguageByClicktoolsISOCode('en');
      }
      
      test.stopTest();
  }
  
  public static testMethod void testInActive(){
  init();
      test.startTest();
      
         ESC_EPx_Trigger_Methods EpxTrigger = new ESC_EPx_Trigger_Methods(EPxList,newEPsMap,oldEPsMap);
          //EpxTrigger.createEscalations();
          EpxTrigger.userIsActive(user.id);
          ESC_EPx_Trigger_Methods.removeScheduledSurveysOnCaseReopen(caseList);
          ESC_EPX_Language_List_Wrapper langWrapper = ESC_EPX_Language_List_Wrapper.getInstance();
          langWrapper.getLanguageByName('English');
          langWrapper.getLanguageByClicktoolsISOCode('en');
           
          relatedCase.Ownerid = user1.id;
         relatedCase.ESC_Case_Owner_Team__c='relatedCase';
         relatedCase.ESC_LastQueueOwner__c='00G30000003KD6u';
         relatedCase.status='closed';
          update relatedCase;
          
          list<case> casel=[select id,closedDate from case where ESC_LastQueueOwner__c='lastqueueowner'];
          
          EpxTrigger.getOwnerId(s,relatedCase);
         EpxTrigger.expirationCheck();
      test.stopTest();
  }
  public static void reopenCase(ESC_EPx_Trigger_Methods EpxTrigger){
       ts.ESC_Expiration_In_Days__c = 3;
       ts.ESC_EPs_Reopen_Auto__c = true;
       s.ESC_EPs_Reopen_Req_Answer__c = 'Yes';
       update s;
       update ts; 
       EpxTrigger.reopenCases();


  }      
 
 
       
 }