/**
 * CHANGE HISTORY
 * @description test
 * ============================================================================================================================
 * Date         Name             JIRA          Description
 * ============================================================================================================================
 * 
 * 06-08-2017  Rupesh Sharma           EBB         Test class for ESC_EmailPublisherLoader2
 * ============================================================================================================================
 */
@isTest
private class ESC_EmailPublisherLoader2_Test{
 static testMethod void testEmailPublisherLoader() {
     
     Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
     UserRole r = new UserRole(DeveloperName = 'TR_Legal_Sales_Rep1', Name = 'My_Role');
        insert r;
    
    User u = new User(Alias = 'standt2', Email='sysadmin@2testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing2', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id,
      TimeZoneSidKey='America/Los_Angeles',UserName='sysadmin2@testorg.com',UserRoleId = r.Id);
      insert u;
      System.assertEquals(u.LastName,'Testing2','is Correct?!!'); 
    Test.startTest();
    
    System.runAs(u){
         Account testAccount = ESC_GenericTestutility.TestAccountUtil('TestAccount' ,'TestAccount001','7786864710');  
         insert testAccount;
         
         Contact testContact = ESC_GenericTestutility.TestContactUtil(testAccount.id ,'test','Mile','test@tr.com');
         insert testContact;
         
         Case ca = ESC_GenericTestutility.TestCaseUtil(testContact.id,TestAccount.id,'New');
         ca.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Incident').getRecordTypeId();
         //ca.ESC_Origin_Name__c ='test@tr.com';
         insert ca;
         
         ESC_EmailPublisherLoader2 ebl = new ESC_EmailPublisherLoader2();
    ESC_Static_Values__c esc=new ESC_Static_Values__c();
    esc.name='OrgWideDisplayName';
    esc.ESC_value__C = 'Thomson Reuters Customer Support';
    insert esc;
    
     ESC_EmailSelectorFields__c eIDs =new ESC_EmailSelectorFields__c(); 
     eids.ESC_Case_Field1__c='Status';
     eids.ESC_Case_Field2__c='Recordtype.name';
     /*eids.ESC_Case_Field3__c='id';
     eids.ESC_Case_Field4__c='CaseNumber';
     eids.ESC_Case_Field5__c='ESC_Cause__c ';*/

      insert eids;
      
      
QuickAction.SendEmailQuickActionDefaults sdf ; 
//QuickAction.QuickActionDefaultsHandler qdf ; 
//QuickAction.SendEmailQuickActionDefaults sdf1=Test.newSendEmailQuickActionDefaults(ca.Id, null);  

//insert ESC_EmailSelectorList__c  object  data
ESC_EmailSelectorList__c esl = new ESC_EmailSelectorList__c(ESC_ProfileName__c = 'System Administrator', ESC_UserRole__c = 'My_Role', ESC_From_Address__c ='ESC_Origin_Name__c',ESC_EmailTemplateName__c ='GLI_Empty_Template',ESC_To_Address__c='ContactEmail,ESC_Origin_Name__c',ESC_CC_Address__c='ESC_Origin_Name__c', ESC_Case_Field1__c = 'New', ESC_Case_Field2__c ='Incident');
insert esl;

ESC_EmailSelectorList__c esl1 = new ESC_EmailSelectorList__c(ESC_ProfileName__c = 'System Administrator', ESC_UserRole__c = '', ESC_From_Address__c ='ESC_Origin_Name__c,SuppliedEmail',ESC_EmailTemplateName__c ='GLI_Empty_Template',ESC_To_Address__c='ContactEmail,ESC_Origin_Name__c',ESC_CC_Address__c='ESC_Origin_Name__c,SuppliedEmail', ESC_Case_Field1__c = 'New', ESC_Case_Field2__c ='Incident');
insert esl1;

List<Map<String, Object>> defaultSettingAsObject = new List<Map<String, Object>>
        {
          new Map<String, Object>
          {
                'targetSObject' => new EmailMessage(),
                'contextId' => ca.Id,
                'actionType' => 'Email',
                'actionName' => 'Case.Email',
                'fromAddressList' => new List<String> { 'salesforce@test.com' }
          }
        };

        List<QuickAction.SendEmailQuickActionDefaults> defaultsSettings = 
            (List<QuickAction.SendEmailQuickActionDefaults>)JSON.deserialize(JSON.serialize(defaultSettingAsObject), List<QuickAction.SendEmailQuickActionDefaults>.class);
 
 //User currentUser = [Select id from user where id =: userinfo.getUserId()];
 //System.RunAs(u){
  //insert date for EmailTemplate
  EmailTemplate et = new EmailTemplate();
  et.Name = 'SUPPORT: Self-Service New Comment (SAMPLE)';
  et.DeveloperName = 'SUPPORT_Self_Service_New_Comment_SAMPLE';
  et.TemplateType = 'text';
  et.folderId = [SELECT Id FROM Organization limit 1].Id;
  insert et;


for (QuickAction.QuickActionDefaults dfv :defaultsSettings) { 
dfv = sdf ;

}

         //data inserted  related to the class : ESC_Utility -- error comming Null pointer exception - Attemp to deference a null object  line 459
         ESC_MilestoneIdentifierSetting__c ms = new ESC_MilestoneIdentifierSetting__c(Name = 'Next Response Time');
         ms.FieldAPIName__c = 'ESC_Response_Time__c';
         ms.ControllingFieldAPI__c = 'ESC_Next_Response_Time_Flag__c';
         insert ms;

PageReference pageRef = new PageReference('/'+ca.id); 
Test.setCurrentPage(pageRef ); 
ebl.onInitDefaults(defaultsSettings); 
ebl.getFromAddress(esl,ca.id);
ebl.getToAddress(esl,ca.id);
ebl.getccAddress(esl,ca.id);
ebl.getDefaultEmailTemplateId('GLI_Empty_Template');
ebl.getBccAddress();

Case ca1 = ESC_GenericTestutility.TestCaseUtil(testContact.id,TestAccount.id,'New');
ca1.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Incident').getRecordTypeId();
ca1.ESC_Origin_Name__c ='test@tr.com';
insert ca1;
ebl.getFromAddress(esl1,ca1.id);
ebl.getccAddress(esl1,ca1.id);

Test.stopTest();
}}
static testMethod void testEmailPublisherLoader1() {
     
     Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
     UserRole r = new UserRole(DeveloperName = 'TR_Legal_Sales_Rep1', Name = 'My_Role');
        insert r;
    
    User u = new User(Alias = 'standt2', Email='sysadmin@2testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing2', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id,
      TimeZoneSidKey='America/Los_Angeles',UserName='sysadmin2@testorg.com',UserRoleId = r.Id);
      insert u;
      System.assertEquals(u.LastName,'Testing2','is Correct?!!'); 
    Test.startTest();
    
    System.runAs(u){
         Account testAccount = ESC_GenericTestutility.TestAccountUtil('TestAccount' ,'TestAccount001','7786864710');  
         insert testAccount;
         
         Contact testContact = ESC_GenericTestutility.TestContactUtil(testAccount.id ,'test','Mile','test@tr.com');
         insert testContact;
         
         Case ca = ESC_GenericTestutility.TestCaseUtil(testContact.id,TestAccount.id,'New');
         ca.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Incident').getRecordTypeId();
         //ca.ESC_Origin_Name__c ='test@tr.com';
         insert ca;
         
         ESC_EmailPublisherLoader2 ebl = new ESC_EmailPublisherLoader2();
    ESC_Static_Values__c esc=new ESC_Static_Values__c();
    esc.name='OrgWideDisplayName';
    esc.ESC_value__C = 'Thomson Reuters Customer Support';
    insert esc;
    
     ESC_EmailSelectorFields__c eIDs =new ESC_EmailSelectorFields__c(); 
     eids.ESC_Case_Field1__c='Status';
     eids.ESC_Case_Field2__c='Recordtype.name';
     /*eids.ESC_Case_Field3__c='id';
     eids.ESC_Case_Field4__c='CaseNumber';
     eids.ESC_Case_Field5__c='ESC_Cause__c ';*/

      insert eids;
      
      
QuickAction.SendEmailQuickActionDefaults sdf ; 
//QuickAction.QuickActionDefaultsHandler qdf ; 
//QuickAction.SendEmailQuickActionDefaults sdf1=Test.newSendEmailQuickActionDefaults(ca.Id, null);  

//insert ESC_EmailSelectorList__c  object  data
ESC_EmailSelectorList__c esl = new ESC_EmailSelectorList__c(ESC_ProfileName__c = 'System Administrator', ESC_UserRole__c = 'My_Role', ESC_From_Address__c ='ESC_Origin_Name__c',ESC_EmailTemplateName__c ='GLI_Empty_Template',ESC_To_Address__c='ContactEmail,ESC_Origin_Name__c',ESC_CC_Address__c='ESC_Origin_Name__c', ESC_Case_Field1__c = 'Work In Progress', ESC_Case_Field2__c ='Incident');
insert esl;

ESC_EmailSelectorList__c esl1 = new ESC_EmailSelectorList__c(ESC_ProfileName__c = 'System Administrator', ESC_UserRole__c = '', ESC_From_Address__c ='ESC_Origin_Name__c,SuppliedEmail',ESC_EmailTemplateName__c ='GLI_Empty_Template',ESC_To_Address__c='ContactEmail,ESC_Origin_Name__c',ESC_CC_Address__c='ESC_Origin_Name__c,SuppliedEmail', ESC_Case_Field1__c = 'Work In Progress', ESC_Case_Field2__c ='Incident');
insert esl1;
 EmailMessage myMsg = new EmailMessage(ParentId = ca.Id);
        insert myMsg;
List<Map<String, Object>> defaultSettingAsObject = new List<Map<String, Object>>
        {
          new Map<String, Object>
          {
                'targetSObject' => new EmailMessage(),
                'replyToId' => myMsg.Id,
                'contextId' => ca.Id,
                'actionType' => 'Email',
                'actionName' => 'Case.Email',
                'fromAddressList' => new List<String> { 'salesforce@test.com' }
          }
        };

        List<QuickAction.SendEmailQuickActionDefaults> defaultsSettings = 
            (List<QuickAction.SendEmailQuickActionDefaults>)JSON.deserialize(JSON.serialize(defaultSettingAsObject), List<QuickAction.SendEmailQuickActionDefaults>.class);
 
 //User currentUser = [Select id from user where id =: userinfo.getUserId()];
 //System.RunAs(u){
  //insert date for EmailTemplate
  EmailTemplate et = new EmailTemplate();
  et.Name = 'SUPPORT: Self-Service New Comment (SAMPLE)';
  et.DeveloperName = 'SUPPORT_Self_Service_New_Comment_SAMPLE';
  et.TemplateType = 'text';
  et.folderId = [SELECT Id FROM Organization limit 1].Id;
  insert et;


for (QuickAction.QuickActionDefaults dfv :defaultsSettings) { 
dfv = sdf ;

}

         //data inserted  related to the class : ESC_Utility -- error comming Null pointer exception - Attemp to deference a null object  line 459
         ESC_MilestoneIdentifierSetting__c ms = new ESC_MilestoneIdentifierSetting__c(Name = 'Next Response Time');
         ms.FieldAPIName__c = 'ESC_Response_Time__c';
         ms.ControllingFieldAPI__c = 'ESC_Next_Response_Time_Flag__c';
         insert ms;

PageReference pageRef = new PageReference('/'+ca.id); 
Test.setCurrentPage(pageRef ); 
ebl.onInitDefaults(defaultsSettings); 
ebl.getFromAddress(esl,ca.id);
ebl.getToAddress(esl,ca.id);
ebl.getccAddress(esl,ca.id);
ebl.getDefaultEmailTemplateId('GLI_Empty_Template');
ebl.getBccAddress();

Case ca1 = ESC_GenericTestutility.TestCaseUtil(testContact.id,TestAccount.id,'New');
ca1.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Incident').getRecordTypeId();
ca1.ESC_Origin_Name__c ='test@tr.com';
insert ca1;
ebl.getFromAddress(esl1,ca1.id);
ebl.getccAddress(esl1,ca1.id);

Test.stopTest();
}}
}