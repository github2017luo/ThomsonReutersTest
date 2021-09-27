@isTest
public class ESC_EPx_Send_Survey_Test{

    public static Case relatedCase = new Case();
    public static Account acc = new Account();
    public static Contact con = new Contact();
    public static User user;
    public static List<Case> listCases = new List<Case>();

    public static ESC_EPx__c s;// = new ESC_EPx__c();
    
    public static Id recTypeFeedback = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Feedback').getRecordTypeId();
    public static Id recTypeEPsComplete = Schema.SObjectType.ESC_EPx__c.getRecordTypeInfosByName().get('ESC_EPs_Complete').getRecordTypeId(); 
    public static Id recTypeEscalation = Schema.SObjectType.ESC_Case_Collaborator__c.getRecordTypeInfosByName().get('Escalations').getRecordTypeId();
    public static Id recordTypeIdComplete = Schema.SObjectType.ESC_EPx__c.getRecordTypeInfosByName().get('ESC_EPs_Complete').getRecordTypeId();
    public static Id recordTypeIdSent = Schema.SObjectType.ESC_EPx__c.getRecordTypeInfosByName().get('ESC_EPs_Sent').getRecordTypeId();
    public static Id recordTypeIdIncident = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Incident').getRecordTypeId();
    public static Id recordTypeIdIncidentRO = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Incident (Read Only)').getRecordTypeId();

    public static List<ESC_EPS_Re_openValues__c> custSetReopen;
    public static List<ESC_EPx_RecordTypesAvailable__c> custSetAvailableRecordTypes = new List<ESC_EPx_RecordTypesAvailable__c>();
    
    public static ESC_EPX_Trigger_Methods methods;
    public static ESC_EPx_Template_Selector__c ts;
    
                                        
    public static Map<Id, ESC_EPx_Template_Selector__c> mapTS; 
                                                                  
    static void init(){
    
        UserRole r = new UserRole(DeveloperName = 'ESC_Agent', Name = 'ESC_Agent');
        insert r;

        
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
             UserRoleId = r.id
       );
       insert user;

       System.RunAs(user){
       
        init2();
       
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
            
            Languages__c langSpanish = new Languages__c(
                ISO_Code__c = 'es',
                Language_Name__c = 'Spanish',
                Salesforce_ISO_Code__c = 'es'
            );

            insert langEnglish;
            insert langEnglishDefault;
            insert langSpanish;

            mapTS = new Map<Id, ESC_EPx_Template_Selector__c>();
            mapTS.put(ts.id, ts);

            acc.Name = 'Test Account';
            acc.ESC_OptOut_CSAT_Check__c = false;
             acc.BU_Region__c ='UKI';
            acc.BU_Segment__c = 'Professional Legal';
            insert acc;

            con.LastName = 'Test Contact';
            con.FirstName = 'abc';
            con.Accountid = acc.id;
            con.ESC_OptOut_CSAT_Check__c = false;
            con.ESC_Frequency_Cap__c = 5;
            con.ESC_tocLanguage__c = 'English';
            insert con;

            

            //relatedCase = [SELECT id, caseNumber, OwnerId, contactID from case where recordTypeid =: recordTypeIdIncident limit 1];
            relatedCase.Accountid = acc.id;
            relatedCase.Ownerid = user.id;
            relatedCase.contactid = con.id;
            relatedCase.recordTypeId = recordTypeIdIncident;
            relatedCase.description = 'test';
            relatedCase.ESC_Proactive_Type__c = '';
            relatedCase.ESC_SLA_Flag__c = 'test';
            relatedCase.ESC_Diagnosis_Summary__c = '';
            insert relatedCase;
        
       
        listCases.add(relatedCase);  
        
        //relatedCase.recordTypeId = recordTypeIdIncidentRO;
        //update relatedCase;
        
        custSetReopen = new List<ESC_EPs_Re_openValues__c>();//.getall().values();
        
        ESC_EPs_Re_openValues__c record1 = new ESC_EPs_Re_openValues__c();
        record1.Field__c = 'status';
        record1.Value__c = 'Work In Progress';
        
        ESC_EPs_Re_openValues__c record2 = new ESC_EPs_Re_openValues__c();
        record2.Field__c = 'ESC_Last_Update__c';
        record2.Value__c = 'Re-opened by Customer';
        
        ESC_EPs_Re_openValues__c record3 = new ESC_EPs_Re_openValues__c();
        record3.Field__c = 'ESC_UPD__c';
        record3.Value__c = 'true';
            
        custSetReopen.add(record1);
        custSetReopen.add(record2);
        custSetReopen.add(record3);
        
        insert new ESC_EPx_RecordTypesAvailable__c(Name = 'rec1', RecordTypes__c = 'Incident');
        insert new ESC_EPx_RecordTypesAvailable__c(Name = 'rec2', RecordTypes__c = 'Incident (Read Only)');
        insert new ESC_EPx_RecordTypesAvailable__c(Name = 'rec3', RecordTypes__c = 'Request for Action');
        insert new ESC_EPx_RecordTypesAvailable__c(Name = 'rec4', RecordTypes__c = 'Request for Action (Read Only)');

        insert new ESC_EPx_Survey_Reply_Address__c(Name = 'rec11', Region__c = 'UKI',ReplyTo_Address__c='test@gmail.com');
        insert new ESC_EPx_Survey_Reply_Address__c(Name = 'rec12', Region__c = 'UKI',ReplyTo_Address__c='test@gmail.com',Segment__c='Professional Legal');
        
       //insert new ESC_EPx_DeclineCriteria__c(Name = 'dec1', Object_Name__c = 'Account' , Object_Field_Name__c = 'ESC_OptOut_CSAT_Check__c',  Field_Value__c = 'True' );
       insert new ESC_EPx_DeclineCriteria__c(Name = 'dec2', User_Role__c = '', Object_Name__c = 'Contact' , Object_Field_Name__c = 'ESC_OptOut_CSAT_Check__c',  Field_Value__c = 'True' );
       insert new ESC_EPx_DeclineCriteria__c(Name = 'dec3', User_Role__c = '', Object_Name__c = 'Case' , Object_Field_Name__c = 'ESC_Proactive_Type__c',  Field_Value__c = 'Internal' );
       insert new ESC_EPx_DeclineCriteria__c(Name = 'dec4', User_Role__c = '', Object_Name__c = 'Case' , Object_Field_Name__c = 'ESC_Proactive_Type__c',  Field_Value__c = 'Social Media' );
       insert new ESC_EPx_DeclineCriteria__c(Name = 'dec5', User_Role__c = '', Object_Name__c = 'Case' , Object_Field_Name__c = 'ESC_Diagnosis_Summary__c',  Field_Value__c = 'test' );
        //insert new ESC_EPx_DeclineCriteria__c(Name = 'dec6', Object_Name__c = 'Case' , Object_Field_Name__c = 'Service_Product_Category__c',  Field_Value__c = 'test' );

       //Field is not writable error thrown since custom metadata types can not be inserted or updated via apex.
       //ESC_EPX_Team_Lang_Settings__mdt team_lang_settings = new ESC_EPX_Team_Lang_Settings__mdt(Label = 'ESC_Agent_Team_Lang_Setting', User_Role__c = 'ESC_Agent' , Language__c = '',  Language_Choice__c = 'A. Use Contacts preferred language if present and in the available list of supported EPx languages; otherwise use English' );
       //insert team_lang_settings;
  //Create Parent Group
        Group grp = new Group();
        grp.name = 'Test Group1';
        grp.Type = 'Regular'; 
        Insert grp; 
 
        //Create Group Member
        GroupMember grpMem1 = new GroupMember();
        grpMem1.UserOrGroupId = UserInfo.getUserId();
        grpMem1.GroupId = grp.Id;
        Insert grpMem1;
 
        //Create Sub group
        Group subGrp  = new Group();
        subGrp.name = 'Test Group2';
        subGrp.Type = 'Regular'; 
        Insert subGrp; 
 
        //Assign Role To Parent Group
        GroupMember grpMem2 = new GroupMember();
        grpMem2.UserOrGroupId = subGrp.Id;
        grpMem2.GroupId = grp.Id;
        Insert grpMem2;

        s = new ESC_EPx__c();
        s.ESC_Case__c = relatedCase.id;
        s.ESC_Case_Owner__c = relatedCase.Ownerid;
        s.ESC_EPx_Template_Selector__c = ts.id;
        s.ESC_EPx_Expired_Response__c = false;
        s.ESC_EPx_Category__c = 'EPs';
        //s.ESC_EPx_Type__c = ''
        
        insert s;
        

        Date today = Date.today();
        today = today.addDays(-5);
        Test.setCreatedDate(s.id, DateTime.newInstance(today.year(),today.month(),today.day()));
        
        s = [SELECT ESC_Case__c, ESC_Case_Owner__c, ESC_EPx_Template_Selector__c, ESC_EPx_Expired_Response__c, createdDate 
             From ESC_EPx__c
             where id = : s.id];
        
         Test.setCreatedDate(s.id, DateTime.newInstance(2019,today.month(),20));
         
         }
           
        
    }
    
    
    private static void init2(){
         EmailTemplate e;
        try{
            e = new EmailTemplate (developerName = 'testqwertyuiojhgfdsasdf', FolderId = UserInfo.getOrganizationId(), TemplateType= 'Text', Name = 'test');
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
         ts.ESC_EPs_Make_EscalationScore__c = 50;
         ts.ESC_EPs_Make_FeedbackScore__c = 75;
         ts.ESC_EPs_Reopen_Auto__c = true;
         ts.Case_Field_1__c = 'Description';
         ts.Case_Value_1__c = 'test';
         ts.Condition_1__c = '=';
         ts.Allow_Multiple_EPS_Requests__c = false;
         insert ts;
    }
    
    public static testMethod void sendSurveyTestDriver(){
         init();
        test.startTest();
         System.RunAs(user) {
             ESC_EPx_Send_Survey_Test.validateDelayedSend();
         }      
         ESC_EPx_Send_Survey_Test.validateLanguageChoiceA();
         ESC_EPx_Send_Survey_Test.validateLanguageChoiceB();
         ESC_EPx_Send_Survey_Test.validateLanguageChoiceC();
         //ESC_EPx_Send_Survey_Test.validateLanguageChoiceD();
         ESC_EPx_Send_Survey_Test.validateLanguageChoiceE();

         test.stopTest();


     }
     
     static testmethod void sendSurveyDriver2(){
          
          init();
            test.startTest();
          System.RunAs(user) {

             ESC_EPx_Send_Survey.sendSurvey(listCases);

            String recName = ESC_EPx_Send_Survey.getRecordTypeNameById('case',recordTypeIdIncident);
             ESC_EPx_Send_Survey_Test.validateDeclineCriteriaUserRole();

             //Record Type Check = False
             ESC_EPx_Send_Survey_Test.validateRecordTypeCheck();

             //Suppression Checks
             ESC_EPx_Send_Survey_Test.validateSuppressionChecks();

             
             //No Email Template Selected
             ESC_EPx_Send_Survey_Test.validateEmailTemplateSelectedNull();

             //No RecordTypes in Template Selected
             ESC_EPx_Send_Survey_Test.validateNoRecordTypesOnTS();


             //Ts Match does not Equal condition '='
             ts.Case_Value_1__c = 'testssss';
             update ts;
             ESC_EPx_Send_Survey.sendSurvey(listCases);

             ts.Case_Value_1__c = 'test';
             update ts;

             //Ts Match does not Equal condition '!='
            // ESC_EPx_Send_Survey_Test.tsMatchedNotEqualCondition();

             //ESC_EPx_Send_Survey_Test.validateAccountSuppression();
             
            // ESC_EPx_Send_Survey_Test.validatecontactSuppression1();
            //ESC_EPx_Send_Survey_Test.validateUserRoleSuppression1();
            test.stopTest();
            
         }
     }



    public static void validateDelayedSend(){
        ts.ESC_EPs_Delay_Mins__c = 1;
        update ts;
        ESC_EPx_Send_Survey.sendSurvey(listCases);

        ts.ESC_EPs_Delay_Mins__c = 0;
        update ts;

    }

    public static void validateRecordTypeCheck(){
        relatedCase.RecordTypeId = recTypeFeedback;
        update relatedCase;
        List<Case> list2 = new List<Case>();
        list2.add(relatedCase);
        ESC_EPx_Send_Survey.sendSurvey(list2);

        relatedCase.RecordTypeId = recordTypeIdIncident;
        update relatedCase;
    }

    public static void validateAccountSuppression(){
        insert new ESC_EPx_DeclineCriteria__c(Name = 'dec1', Object_Name__c = 'Account' , Object_Field_Name__c = 'ESC_OptOut_CSAT_Check__c',  Field_Value__c = 'True' );
        acc.ESC_OptOut_CSAT_Check__c = true;
        update acc;
        ESC_EPx_Send_Survey.sendSurvey(listCases);

        acc.ESC_OptOut_CSAT_Check__c = false;
        update acc;
    }
    
    public static void validatecontactSuppression1(){
        insert new ESC_EPx_DeclineCriteria__c(Name = 'dec2', Object_Name__c = 'Contact' , Object_Field_Name__c = 'ESC_OptOut_CSAT_Check__c',  Field_Value__c = 'True' );
        con.ESC_OptOut_CSAT_Check__c = true;
        update con;
        ESC_EPx_Send_Survey.sendSurvey(listCases);

        con.ESC_OptOut_CSAT_Check__c = false;
        update con;
    }

 public static void validateUserRoleSuppression1(){
        insert new ESC_EPx_DeclineCriteria__c(Name = 'Userrole', Object_Name__c = 'User' , Object_Field_Name__c = 'UserRole',  Field_Value__c = 'VP' );
        con.ESC_OptOut_CSAT_Check__c = true;
        update con;
       // ESC_EPx_Send_Survey.sendSurvey(listCases);

        con.ESC_OptOut_CSAT_Check__c = false;
       // update acc;
    }
    
    
    public static void validateEmailTemplateSelectedNull(){
        ts.Profile__c = '';
        update ts;
        ESC_EPx_Send_Survey.sendSurvey(listCases);

        ts.Profile__c = 'Standard User,System Administrator';
        update ts;
    }
    
    public static void validateSuppressionChecks(){

        acc.ESC_OptOut_CSAT_Check__c = true;
        con.ESC_OptOut_CSAT_Check__c = true;
        relatedCase.ESC_Proactive_Type__c = 'Internal';


        update acc;
        update con;
        update relatedCase;

        ESC_EPx_Send_Survey.sendSurvey(listCases);

        //Suppression Checks reversion
        acc.ESC_OptOut_CSAT_Check__c = false;
        con.ESC_OptOut_CSAT_Check__c = false;
        relatedCase.ESC_Proactive_Type__c = '';

        update acc;
        update con;
        update relatedCase;
    }


    public static void tsMatchedNotEqualCondition(){

        ts.Condition_1__c = '!=';
        update ts;
        ESC_EPx_Send_Survey.sendSurvey(listCases);

        ts.Condition_1__c = '=';
        update ts;

    }

    public static void validateNoRecordTypesOnTS(){

        ts.Record_Type__c = '';
        update ts;
        ESC_EPx_Send_Survey.sendSurvey(listCases);

        ts.Record_Type__c = 'Incident';
        update ts;
    }
    

    public static void validateDeclineCriteriaUserRole() {
        ESC_EPx_DeclineCriteria__c userRoleDecline = new ESC_EPx_DeclineCriteria__c(Name = 'userRole', User_Role__c = 'ESC_Agent', Object_Name__c = 'user' , Object_Field_Name__c = 'UserRole',  Field_Value__c = 'ESC_Agent' );
        insert userRoleDecline;

        ESC_EPx_Send_Survey.sendSurvey(listCases);

        delete userRoleDecline;


    }

    public static void validateLanguageChoiceA(){


        UserRole r1 = new UserRole(DeveloperName = 'EPx_Test_Role_1', Name = 'EPx_Test_Role_1');
        insert r1;
        user.userRoleId = r1.id;
        update user;


        System.runas(user) {
            con.ESC_tocLanguage__c = 'English (Default)';
            update con;
            ESC_EPx_Send_Survey.sendSurvey(listCases);
            con.ESC_tocLanguage__c = null;
            update con;
            ESC_EPx_Send_Survey.sendSurvey(listCases);
        }


    }

    public static void validateLanguageChoiceB(){
        UserRole r1 = new UserRole(DeveloperName = 'EPx_Test_Role_2', Name = 'EPx_Test_Role_2');
        insert r1;

        user.userRoleId = r1.id;
        update user;



        System.runas(user){
            con.ESC_tocLanguage__c = 'English (Default)';
            update con;
            ESC_EPx_Send_Survey.sendSurvey(listCases);

            //Test Neagtive Case
            con.ESC_tocLanguage__c = null;
            update con;
            ESC_EPx_Send_Survey.sendSurvey(listCases);
        }
    }


    public static void validateLanguageChoiceC(){
        UserRole r1 = new UserRole(DeveloperName = 'EPx_Test_Role_3', Name = 'EPx_Test_Role_3');
        insert r1;

        user.userRoleId = r1.id;
        update user;

        System.runas(user){
            con.ESC_tocLanguage__c = 'English (Default)';
            update con;
            ESC_EPx_Send_Survey.sendSurvey(listCases);

            con.ESC_tocLanguage__c = null;
            update con;
            ESC_EPx_Send_Survey.sendSurvey(listCases);
        }

    }


    public static void validateLanguageChoiceD(){
        UserRole r1 = new UserRole(DeveloperName = 'EPx_Test_Role_4', Name = 'EPx_Test_Role_4');
        insert r1;

        user.userRoleId = r1.id;
        update user;

        System.runas(user){
            ESC_EPx_Send_Survey.sendSurvey(listCases);
        }
    }
    public static void validateLanguageChoiceE(){
        UserRole r1 = new UserRole(DeveloperName = 'EPx_Test_Role_5', Name = 'EPx_Test_Role_5');
        insert r1;

        user.userRoleId = r1.id;
        update user;

        System.runas(user){
            ESC_EPx_Send_Survey.sendSurvey(listCases);
        }
        
        
    }
    public testMethod static void testProcessBuilder(){
  
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
             LocaleSidKey = 'en_US'
             
       );
       insert user;
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
        
      case relatedCase =new case();
     relatedCase.Accountid = acc.id;
        relatedCase.Ownerid = user.id;
        relatedCase.contactid = con.id;
        relatedCase.recordTypeId = recordTypeIdIncident; 
        relatedCase.description = 'test';
        relatedCase.ESC_Proactive_Type__c = '';
        //relatedCase.Service_Product_Category__c = '';
        relatedCase.ESC_Diagnosis_Summary__c = '';
        insert relatedCase;  
        
    ESC_EPx__c test_survey=new ESC_EPx__c();
    test_survey.ESC_Answer_1__c=123;
    test_survey.ESC_Case__c=relatedCase.id;
    test_survey.ESC_EPx_Category__c='EPs';
    test_survey.ESC_EPx_Type__c='EPs - Initial Feedback';
    insert test_survey;

    }

  }     
 
}