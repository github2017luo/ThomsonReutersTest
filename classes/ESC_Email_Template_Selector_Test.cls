@isTest
public class ESC_Email_Template_Selector_Test{
public static User user;
public static User manager;
public static Id recordTypeIdIncident = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Incident').getRecordTypeId();

 public static testmethod void testESCEmailTemplateSelector(){
 
    
 
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
        
    ESC_EPx_Template_Selector__c tS= new ESC_EPx_Template_Selector__c();
      EmailTemplate e;
        try{
            e = new EmailTemplate (developerName = 'test', FolderId = UserInfo.getOrganizationId(), TemplateType= 'Text', Name = 'test');
            insert e;
           }
           catch(Exception ex){}
      
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
 PageReference refPage = Page.ESC_EPx_New_Email_Template_Selector;
        Test.setCurrentPage(refPage);
        system.assertEquals(true, refPage!=null);
         ApexPages.StandardController oStandardController = new ApexPages.StandardController(ts);
          ESC_Email_Template_Selector_Extension controller = new ESC_Email_Template_Selector_Extension(oStandardController);
        controller.getRecordTypeList();
        controller.getselectedRecordTypeList();
        controller.getprofileList();
        
       // controller.getTemplateName();
        controller.getMyPersonalTemplateOptions();
 }

 public static testmethod void testESCEmailTemplateSelector1(){
 
    
 
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
        
    ESC_EPx_Template_Selector__c tS= new ESC_EPx_Template_Selector__c();
      EmailTemplate e;
        try{
            e = new EmailTemplate (developerName = 'test', FolderId = UserInfo.getOrganizationId(), TemplateType= 'Text', Name = 'test');
            insert e;
           }
           catch(Exception ex){}
      
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
 PageReference refPage = Page.ESC_EPx_Edit_Email_Template_Selector;
        Test.setCurrentPage(refPage);
        system.assertEquals(true, refPage!=null);
         ApexPages.StandardController oStandardController = new ApexPages.StandardController(ts);
          ESC_Email_Template_Selector_Extension controller = new ESC_Email_Template_Selector_Extension(oStandardController);
        controller.getRecordTypeList();
        controller.getselectedRecordTypeList();
        controller.getprofileList();
        
        controller.getTemplateName();
        controller.getMyPersonalTemplateOptions();
        controller.getselectedProfileList();
 }

}