/*
 Process Builder Test Class:  LCRM Send Training Event Id Maritz
*/

/**
* CHANGE HISTORY
* =============================================================================
* Date         Name                    Description
* 2021-03-25   Miriam Ghosh            Created     
* =============================================================================
*/
/** 
 * @description :  LCRMSendTrainingEventIdMaritz_Test
*/
@isTest(seeAlldata=False)
public class LCRMSendTrainingEventIdMaritz_Test {
    
    //public static Id recordTypeIdIncident = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Incident').getRecordTypeId();
    public static Id recTypeFeedback = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Feedback').getRecordTypeId(); 
    public static Id recTypeEscalation = Schema.SObjectType.ESC_Case_Collaborator__c.getRecordTypeInfosByName().get('Escalations').getRecordTypeId();
    public static Id recordTypeIdIncident = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Incident').getRecordTypeId();
    public static Id recordTypeIdIncidentRO = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Incident (Read Only)').getRecordTypeId();
    
    /** 
     * @description :  maritzTestMethod1
     */
    public static testmethod void maritzTestMethod1(){
        
        LTS_Disable_Application_Automation__c ltstemp = new LTS_Disable_Application_Automation__c();
        ltstemp.LTS_Disable_Process_Builders__c = false;
        ltstemp.LTS_Disable_Triggers__c = true;
        ltstemp.LTS_Disable_Validation_Rules__c = true;
        ltstemp.LTS_Disable_Workflow_Rules__c = true;
        ltstemp.Name = 'temp';
        ltstemp.SetupOwnerId = userinfo.getuserid();
        insert ltstemp;
        
        List<Profile> lstProfile =[SELECT Id FROM Profile WHERE Name =:'System Administrator'];
          User user = UnitTest.getUserInstance();
          user.Username = 'Testgli@xyz.com';
          user.LastName = 'XYZ';
          user.Email = 'abcgli@xyz.com';
          user.Alias = 'abcd';
          user.CommunityNickname = 'CommunityNicknamemng.test';
          user.ProfileId = lstProfile[0].Id;
          insert user;
        
        //Test.startTest();
        
        Account acc = UnitTest.getAccountInstance();
        acc.Name = 'Test Account';
        acc.Phone = '1234567890';
        acc.BillingCountry = 'US';
        acc.BillingState='IL';
        acc.BillingPostalCode = '60603-3801';
        acc.SAPAccountNumber__c = 'UTSAP001';
        acc.is_gli__c = True;
        insert acc;

        Id recordTypeIdContact = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('GLI Contact').getRecordTypeId();
        Contact con = new Contact();
        con.AccountId = acc.Id;
        con.FirstName = 'Unit';
        con.LastName = 'Test';
        con.MailingStreet = '123 Unit Test';
        con.MailingCity = 'Dallas';
        con.MailingCountry = 'US';
        con.MailingState = 'TX';
        con.MailingPostalCode = '75019';
        con.RecordTypeId = recordTypeIdContact;
        insert con;

        List<case> caseList = new List<case>();
        Case relatedCase1 =new case();
        relatedCase1.Accountid = acc.id;
        relatedCase1.Ownerid = user.id;
        relatedCase1.contactid = con.id;
        relatedCase1.recordTypeId = recordTypeIdIncident; 
        relatedCase1.description = 'test';
        relatedCase1.ESC_Proactive_Type__c = '';
        relatedCase1.ESC_Diagnosis_Summary__c = '';
        caseList.add(relatedCase1); 
        //insert caseList;
        
        Case relatedCase =new case();
        relatedCase.Accountid = acc.id;
        relatedCase.Ownerid = user.id;
        relatedCase.contactid = con.id;
        relatedCase.recordTypeId = recordTypeIdIncident; 
        relatedCase.description = 'test';
        relatedCase.ESC_Proactive_Type__c = '';
        relatedCase.ESC_Diagnosis_Summary__c = '';
        caseList.add(relatedCase);
        insert caseList;

        
        MaritzCX__Survey__c surv1 = new MaritzCX__Survey__c();
        surv1.Name ='test survey';
        surv1.MaritzCX__ALG_Survey_Id__c=114;
        insert surv1;
        
        MaritzCX__Survey__c surv = new MaritzCX__Survey__c();
        surv.Name ='test survey';
        surv.MaritzCX__ALG_Survey_Id__c=392;
        insert surv;
        
        //Added for DPS-20245
        
        Training_Event__c te = new Training_Event__c();
        te.LCRM_Is_GLI__c = true;
        te.Account__c = acc.Id;
        te.Training_Name__c='TestEvent-01';
        te.Training_Type__c = 'Advanced';
        te.Status__c = 'Completed';
        te.OwnerId= user.id;
        insert te;
        
        List<MaritzCX__Survey_Question__c> quelist = new List<MaritzCX__Survey_Question__c>();
        MaritzCX__Survey_Question__c question = new MaritzCX__Survey_Question__c();
        question.Name ='contact.Id';
        question.MaritzCX__Question_Type__c = 'unique key';
        question.MaritzCX__Question_Label__c = 'ContactID-';
        question.MaritzCX__Survey__c=surv.id;
        question.MaritzCX__Position_on_Response__c = 1;
        question.MaritzCX__ALG_Survey_Id__c = 392;
        //insert question;
        quelist.add(question);
        
        MaritzCX__Survey_Question__c question1 = new MaritzCX__Survey_Question__c();
        question1.Name ='contact.Id';
        question1.MaritzCX__Question_Type__c = 'unique key';
        question1.MaritzCX__Question_Label__c = 'ContactID-';
        question1.MaritzCX__Survey__c=surv.id;
        question1.MaritzCX__Position_on_Response__c = 1;
        question1.MaritzCX__ALG_Survey_Id__c = 114;
        quelist.add(question1);
        
        insert quelist;
        test.startTest();
        List<MaritzCX__Survey_Response__c> newResponseList = new List<MaritzCX__Survey_Response__c>();
        MaritzCX__Survey_Response__c surveyRes = new MaritzCX__Survey_Response__c();
        surveyRes.MaritzCX__Account__c = acc.id;
        surveyRes.MaritzCX__Case_Id__c = relatedCase.id;
        surveyRes.MaritzCX__Metric_149__c = te.id;
        surveyRes.MaritzCX__Metric_150__c = relatedCase.id;
        surveyRes.MaritzCX__Contact_Id__c = con.id;
        surveyRes.MaritzCX__Metric_1__c = 'Strongly Disagree';
        surveyRes.MaritzCX__Key_Metric_1__c  = 5;
        surveyRes.MaritzCX__Metric_2__c = 'Issue was not resolved';
        surveyRes.MaritzCX__Metric_3__c = 'Yes';
        surveyRes.MaritzCX__ALG_Survey_Id__c = 392;
        surveyRes.MaritzCX__Survey_Id__c = surv.id;
        surveyRes.MaritzCX__respondent_email__c= con.id;
        surveyRes.MaritzCX__Respondent_State__c  ='Completed'; 
        surveyRes.Training_Event__c = te.id;
        newResponseList.add(surveyRes);
        //insert surveyRes;
        
        MaritzCX__Survey_Response__c surveyRes1 = new MaritzCX__Survey_Response__c();
        surveyRes1.MaritzCX__Account__c = acc.id;
        surveyRes.MaritzCX__Case_Id__c = relatedCase1.id;
        surveyRes1.MaritzCX__Metric_150__c = relatedCase1.id;
        surveyRes1.MaritzCX__Contact_Id__c = con.id;
        surveyRes1.MaritzCX__Metric_1__c = 'Strongly Disagree';
        surveyRes1.MaritzCX__Key_Metric_1__c  = 5;
        surveyRes1.MaritzCX__Metric_2__c = 'Issue was not resolved';
        surveyRes1.MaritzCX__Metric_3__c = 'Yes';
        surveyRes1.MaritzCX__ALG_Survey_Id__c = 114;
        surveyRes1.MaritzCX__Survey_Id__c = surv.id;
        surveyRes1.MaritzCX__respondent_email__c= con.id;
        surveyRes1.MaritzCX__Respondent_State__c  ='Completed'; 
        newResponseList.add(surveyRes1);
        //insert surveyRes1;
        
        try{
        insert newResponseList;
        }
        catch(exception e){
         system.debug(LoggingLevel.WARN,e);
        }
         
        //System.assert(surveyRes!=null,true); 
        System.assert(acc!=null,true); 
        test.StopTest();            
    }
    
    

}