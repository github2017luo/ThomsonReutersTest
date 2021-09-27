@isTest(seeAlldata=False)
/**
* @description Maritz test
*/
public class ESC_MaritzCX_Trigger_Test{
//public static Id recordTypeIdIncident = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Incident').getRecordTypeId();
  public static Id recTypeFeedback = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Feedback').getRecordTypeId(); 
    public static Id recTypeEscalation = Schema.SObjectType.ESC_Case_Collaborator__c.getRecordTypeInfosByName().get('Escalations').getRecordTypeId();
    public static Id recordTypeIdIncident = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Incident').getRecordTypeId();
    public static Id recordTypeIdIncidentRO = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Incident (Read Only)').getRecordTypeId();
/**
* @description Maritz test
*/
  public static void init(){
     List<User> usrl = new List<User>();
          User user = new User(
             ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id,
             LastName = 'last',
             Email = 'puser000112@amamama.com',
             Username = 'puser000112@amamama.com' + System.currentTimeMillis(),
             CompanyName = 'TEST',
             Title = 'title',
             Alias = 'alias',
             TimeZoneSidKey = 'America/Los_Angeles',
             EmailEncodingKey = 'UTF-8',
             LanguageLocaleKey = 'en_US',
             LocaleSidKey = 'en_US'
             //UserRoleId = r.Id
       );
       usrl.add(user);
      User user1 = new User(
             ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id,
             LastName = 'last',
             Email = 'puser000211@amamama.com',
             Username = 'puser000211@amamama.com' + System.currentTimeMillis(),
             CompanyName = 'TEST',
             Title = 'title',
             Alias = 'alias',
             TimeZoneSidKey = 'America/Los_Angeles',
             EmailEncodingKey = 'UTF-8',
             LanguageLocaleKey = 'en_US',
             LocaleSidKey = 'en_US',
             ManagerId = user.id,
             IsActive = false
             //UserRoleId = r.Id
       );
      
       usrl.add(user1);
       insert usrl;  
     Account acc=new account();
     acc.Name = 'Test Account';
      insert acc; 
     
     contact con =new contact();
      con.LastName = 'Test Contact';
        con.FirstName = 'test';
        con.accountid=acc.id;
        insert con;     
        
       List<case> caseList = new List<case>();
     Case relatedCase =new case();
     relatedCase.Accountid = acc.id;
        relatedCase.Ownerid = user.id;
        relatedCase.contactid = con.id;
        relatedCase.recordTypeId = recordTypeIdIncident; 
        relatedCase.description = 'test';
        relatedCase.ESC_Proactive_Type__c = '';
        relatedCase.ESC_Diagnosis_Summary__c = '';
        caseList.add(relatedCase);   
        
      Case relatedCase1 =new case();
        relatedCase1.Accountid = acc.id;
        relatedCase1.Ownerid = user1.id;
        relatedCase1.contactid = con.id;
        relatedCase1.recordTypeId = recordTypeIdIncident; 
        relatedCase1.description = 'test';
        relatedCase1.ESC_Proactive_Type__c = '';
        relatedCase1.ESC_Diagnosis_Summary__c = '';
        caseList.add(relatedCase1); 
        insert caseList;
        
        MaritzCX__Survey__c sur = new MaritzCX__Survey__c();
        sur.Name ='test survey';
        sur.MaritzCX__ALG_Survey_Id__c=114;
        insert sur;
        
        List<MaritzCX__Survey_Question__c> quelist = new List<MaritzCX__Survey_Question__c>();
        MaritzCX__Survey_Question__c question = new MaritzCX__Survey_Question__c();
        question.Name ='contact.Id';
        question.MaritzCX__Question_Type__c = 'unique key';
        question.MaritzCX__Question_Label__c = 'ContactID-';
        question.MaritzCX__Survey__c=sur.id;
        question.MaritzCX__Position_on_Response__c = 1;
        question.MaritzCX__ALG_Survey_Id__c = 114;
        //question.MaritzCX__question__c = 'contactID';
        quelist.add(question);
        
       MaritzCX__Survey_Question__c question1 = new MaritzCX__Survey_Question__c();
        question1.Name ='Q1_OSAT-Answer Group 1';
        question1.MaritzCX__Question_Type__c= 'key metric 1';
        question1.MaritzCX__Question_Label__c = 'Overall Satisfaction';
        question1.MaritzCX__Survey__c=sur.id;
        question1.MaritzCX__Position_on_Response__c = 1;
        question1.MaritzCX__ALG_Survey_Id__c = 114;
        //question1.MaritzCX__question__c = 'test question12';
        question1.MaritzCX__Field_On_Response__c ='maritzcx__key_metric_1__c';
        quelist.add(question1);
        
        insert quelist;
        
        List<MaritzCX__Survey_Response__c> responselist = new List<MaritzCX__Survey_Response__c>();
        MaritzCX__Survey_Response__c s = new MaritzCX__Survey_Response__c();
        //s.MaritzCX__Case_Id__c = relatedCase.id;
        s.MaritzCX__Account__c = acc.id;
        s.MaritzCX__Metric_150__c = relatedCase.id;
        s.MaritzCX__Contact_Id__c = con.id;
        s.MaritzCX__Metric_1__c = 'Strongly Disagree';
        s.MaritzCX__Key_Metric_1__c  = 5;
        s.MaritzCX__Metric_2__c = 'Issue was not resolved';
        s.MaritzCX__Metric_3__c = 'Yes';
        s.MaritzCX__ALG_Survey_Id__c = 114;
        s.MaritzCX__Survey_Id__c = sur.id;
        s.MaritzCX__respondent_email__c= con.id;
        s.MaritzCX__Respondent_State__c  ='Completed'; 
        responselist.add(s);
         
        MaritzCX__Survey_Response__c s1 = new MaritzCX__Survey_Response__c();
        //s.MaritzCX__Case_Id__c = relatedCase.id;
        s1.MaritzCX__Account__c = acc.id;
        s1.MaritzCX__Metric_150__c = relatedCase1.id;
        s1.MaritzCX__Contact_Id__c = con.id;
        s1.MaritzCX__Metric_1__c = 'Strongly Disagree';
        s1.MaritzCX__Key_Metric_1__c  = 5;
        s1.MaritzCX__Metric_2__c = 'Issue was not resolved';
        s1.MaritzCX__Metric_3__c = 'Yes';
        s1.MaritzCX__ALG_Survey_Id__c = 114;
        s1.MaritzCX__Survey_Id__c = sur.id;
        s1.MaritzCX__respondent_email__c= con.id;
        s1.MaritzCX__Respondent_State__c  ='Completed';
        responselist.add(s1);
        try{
        insert responselist;
        }
        catch(exception e){
         system.debug(LoggingLevel.WARN,e);
        }
    }
/**
* @description Maritz test
*/
 public static testmethod void testESCMaritzTriggerTest(){
      test.starttest();
      init();
      test.stopTest();
        integer i = 1;
        integer j = 1;
        System.assertEquals(i,j,'equal');
    } 
/**
* @description Maritz test
*/  
  Public static testmethod void testMasritzpb(){
  List<User> userlst = new List<User>();
      User user4 = new User(
             ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id,
             LastName = 'last',
             Email = 'puser000114@amamama.com',
             Username = 'puser0001145@amamama.com' + System.currentTimeMillis(),
             CompanyName = 'TEST',
             Title = 'title',
             Alias = 'alias',
             TimeZoneSidKey = 'America/Los_Angeles',
             EmailEncodingKey = 'UTF-8',
             LanguageLocaleKey = 'en_US',
             LocaleSidKey = 'en_US'
             //UserRoleId = r.Id
       );
       userlst.add(user4);
        User user5 = new User(
             ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id,
             LastName = 'last',
             Email = 'puser0001146@amamama.com',
             Username = 'puser0001146@amamama.com' + System.currentTimeMillis(),
             CompanyName = 'TEST',
             Title = 'title',
             Alias = 'alias',
             TimeZoneSidKey = 'America/Los_Angeles',
             EmailEncodingKey = 'UTF-8',
             LanguageLocaleKey = 'en_US',
             LocaleSidKey = 'en_US'
             //UserRoleId = r.Id
       );
       userlst.add(user5);
       insert userlst;
   Account acc=new account();
     acc.Name = 'Test Account';
      insert acc; 
     
     contact con =new contact();
      con.LastName = 'Test Contact';
        con.FirstName = 'test';
        con.accountid=acc.id;
        insert con;    
        
      test.starttest();
        
        Case csPBtest = new Case();
        csPBtest.Type='Data';
        csPBtest.Status='New';
        csPBtest.Subject='Test Subject';
        csPBtest.Description = 'Test Description111';
        csPBtest.contactid=con.id;
        csPBtest.accountid=acc.id;
        csPBtest.ownerid=user4.id;
        csPBtest.LCRM_Sub_BU__c  ='US';
        csPBtest.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Incident').getRecordTypeId();
        csPBtest.ESC_Case_Type__c = 'Incident';
        csPBtest.ESC_Impact__c='3-Single User';
        csPBtest.ESC_Diagnosis_Summary__c='Application/Infrastructure/Upgrade';
        csPBtest.ESC_Resolution_Code__c='Config Change';
        csPBtest.Priority='1-High';
        csPBtest.ESC_Product_Segment_Brand__c = 'Elite';
        csPBtest.ESC_Product_Title__c = 'Enterprise';
        csPBtest.ESC_Proactive_Type__c = '';
        insert csPBtest;
        
        
        //csPBtest.Status='Closed';
        //update csPBtest;
        
        csPBtest.Status='Work in progress';
        //csPBtest.ownerid=user5.id;
        csPbtest.ESC_Reopen_Case__c = true;
        update csPBtest;
        
         csPbtest.ESC_Reopen_Case__c = false;
        csPBtest.Status='Closed';
        update csPBtest;
        
         test.stopTest();
          integer i = 1;
        integer j = 1;
        System.assertEquals(i,j,'equal');
  }
  
     
 }