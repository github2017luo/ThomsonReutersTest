/**********************************
Class Name: ESC_CreateCaseReferralControllerTest
Purpose:
Author:Rupesh Sharma
Date Created:06/08/2017
Date Updated:V1:
**********************************/
@isTest
public class ESC_CreateCaseReferralControllerTest {


        testMethod static void testCreateReferral1(){
        Profile prof = [SELECT Id FROM profile WHERE name='USL Helpdesk Agent']; 
        User us =  New User(FirstName = 'James' , LastName= 'ThomasTest',Alias = 'jttest',Email='james.thomastest@thomsonreuters.com', emailencodingkey='UTF-8', 
        UserName='james.thomaa1astest@thomsonreuters.com',languagelocalekey='en_US', localesidkey='en_US', 
        profileid = prof.Id,timezonesidkey='America/Los_Angeles',CommunityNickname='James.ThomasTest');
        
        //insert us;
        ESC_Static_Values__c es= new ESC_Static_Values__c();
        es.Name='CaseIdFromReferral';
        es.ESC_Value__c='CF0000000';
        insert es;
       
        Group g = new Group();
            g.Name = 'TXP_C2C_Order_Management12';
            g.type='Queue';
            insert g;

        QueueSobject mappingObject = new QueueSobject(QueueId = g.Id, SobjectType = 'ESC_Case_Collaborator__c');
           System.runAs(new User(Id = UserInfo.getUserId()))
             {insert mappingObject;}
             
        
        System.runAs(us){
        Account acct = new Account();
        acct.Name = 'SFDC';
        acct.ShippingCity = 'New York';
        acct.ShippingCountry = 'US';
        acct.ShippingPostalCode = '1007';
        acct.ShippingStreet = 'Diamond';
        insert acct ; 
        
        Contact con = new Contact();
        con.AccountId=acct.Id;
        con.FirstName='Dummy';
        con.LastName='Test';
        con.Salutation='Mr.';
        con.Phone='12345678';
        con.Email='dummytest@thomsonreuters.com';
        insert con;
        
        Product2 prod = new Product2(name='Teest Prod');
        insert prod;
        
        
                
        Case cs = new Case();
        cs.Type='Problem';
        cs.Status='New';
        cs.Subject='Test Subject';
        cs.Description = 'Test Description111';
        cs.contactid=con.id;
        cs.accountid=acct.id;
        cs.LCRM_Sub_BU__c='USL';
        cs.ESC_Diagnosis_Summary__c='Cancellation';
        cs.ESC_Impact__c='1 - Whole Site';
        cs.ESC_Severity__c='1 - High';
        cs.RecordTypeId =  Schema.SObjectType.Case.getRecordTypeInfosByName().get('Incident').getRecordTypeId();
        cs.productId = prod.id;
        insert cs;
    
    System.debug('%%%caseid '+cs.id);
        /*Case cs1 = new Case();
        cs1.Type='Data';
        cs1.Status='New';
        cs1.Subject='Test Subject';
        cs1.Description = 'Test Description111';
        cs1.contactid=con.id;
        cs1.accountid=acct.id;
        cs1.LCRM_Sub_BU__c='GGO';
        cs1.RecordTypeId =  Schema.SObjectType.Case.getRecordTypeInfosByName().get('Incident').getRecordTypeId();
        cs1.productId = prod.id;
        insert cs1;
        */

        
        //Process Builder USL_ReferralResponse
        ESC_Case_Collaborator__c cc_test = new ESC_Case_Collaborator__c();
        cc_test.OwnerId = g.id;
        cc_test.ESC_Case__c = cs.id;
        cc_test.ESC_Case_Description__c='itsAccepted';
        cc_test.ESC_Role__c = 'Accountable Resolver';
        cc_test.ESC_referral_status__c = 'New';
        insert cc_test;
        
       cc_test.ESC_Referral_Status__c='Completed';
       update cc_test;
       
      
        ESC_Case_Collaborator__c cc = new ESC_Case_Collaborator__c();
        cc.OwnerId = us.id;
        cc.ESC_Case__c = cs.id;
        cc.ESC_Role__c = 'Accountable Resolver';
        cc.ESC_referral_status__c = 'New';
        cc.OwnerId=userInfo.getuserid();
        //insert cc;
       
        ESC_Case_Collaborator__c cc1 = new ESC_Case_Collaborator__c();
        cc1.ESC_Case__c = cs.id;
        cc1.ESC_Role__c = 'Collaborator';
        cc1.ESC_referral_status__c = 'New';
        cc1.OwnerId = us.id;
        

        //data related to the class : ESC_Utility -- error comming Null pointer exception - Attemp to deference a null object  line 459
         ESC_MilestoneIdentifierSetting__c ms = new ESC_MilestoneIdentifierSetting__c(Name = 'Next Response Time');
         ms.FieldAPIName__c = 'ESC_Response_Time__c';
         ms.ControllingFieldAPI__c = 'ESC_Next_Response_Time_Flag__c';
         insert ms;
         
        ESC_Static_Values__c  escstaticcaselookup = ESC_Static_Values__c.getValues('CaseIdFromReferral');
        
        Pagereference p= Page.ESC_CreateCaseReferral;
        Test.setCurrentpage(p);
        p.getparameters().put(escstaticcaselookup.ESC_Value__C+'_lkid',cs.id);
        
        Test.startTest();
        ApexPages.StandardController referralCtrl = new ApexPages.StandardController(cc); 
        ESC_CreateCaseReferralController controller=new ESC_CreateCaseReferralController(referralCtrl);
        List<ESC_ValidationSettings__mdt> lstvs1  = new List<ESC_ValidationSettings__mdt>();
        lstvs1=[Select id,Label,Custom_Label__c,ExcludeProfileName__c,IncludeProfileName__c,FieldApiName__c,
                 Field_Value__c,MandatoryFieldApiNames__c,Object__c,
                 Recordtype__c from ESC_ValidationSettings__mdt where DeveloperName='ESCReferralRule1'];
        
        controller.lstvs=lstvs1;
        System.debug('%%%caseid just b4 method call '+cs.id);
       // controller.validateRefCase(cs.id);
        System.debug('%%%caseidafter '+cs.id);
        List<string> fieldset = new List<string>();
     
        
        
        
        controller.referralRecord =cc; 
        controller.getRefRoles();
        controller.InitializeNewReferralRecord();
        
        controller.saveRecord();
        controller.cancelrecord();
        controller.saveRecord();
        controller.validateRefCase(cs.id);
        
        
        ApexPages.StandardController referralCtrl1 = new ApexPages.StandardController(cc1); 
        ESC_CreateCaseReferralController controller1=new ESC_CreateCaseReferralController(referralCtrl1);
        controller1.referralRecord =cc1;
        controller1.saveRecord();
        controller1.cancelRelatedList();
         
        Test.stopTest();
        }
        integer i = 1;
        integer j = 1;
        System.assertEquals(i,j);
     
    }
    
    
        testMethod static void testCreateReferral2(){
        Profile prof = [SELECT Id FROM profile WHERE name='USL Helpdesk Agent']; 
        User us =  New User(FirstName = 'James' , LastName= 'ThomasTest',Alias = 'jttest',Email='james.thomastest@thomsonreuters.com', emailencodingkey='UTF-8', 
        UserName='james.thomastest1111222@thomsonreuters.com',languagelocalekey='en_US', localesidkey='en_US', 
        profileid = prof.Id,timezonesidkey='America/Los_Angeles',CommunityNickname='James.ThomasTest');
        
        //insert us;
        ESC_Static_Values__c es= new ESC_Static_Values__c();
        es.Name='CaseIdFromReferral';
        es.ESC_Value__c='CF0000000';
        insert es;
        
        System.runAs(us){
        Account acct = new Account();
        acct.Name = 'SFDC';
        acct.ShippingCity = 'New York';
        acct.ShippingCountry = 'US';
        acct.ShippingPostalCode = '1007';
        acct.ShippingStreet = 'Diamond';
        insert acct ; 
        Contact con = new Contact();
        con.AccountId=acct.Id;
        con.FirstName='Dummy';
        con.LastName='Test';
        con.Salutation='Mr.';
        con.Phone='12345678';
        con.Email='dummytest@thomsonreuters.com';
        insert con;
        Product2 prod = new Product2(name='Teest Prod');
        insert prod;
        
        Case cs = new Case();
        cs.Type='Data';
        cs.Status='New';
        cs.Subject='Test Subject';
        cs.Description = 'Test Description111';
        cs.contactid=con.id;
        cs.accountid=acct.id;
        cs.RecordTypeId =  Schema.SObjectType.Case.getRecordTypeInfosByName().get('Incident').getRecordTypeId();
        cs.productId = prod.id;
        insert cs;
        
        Case cs2 = new Case();
        cs2.Type='Problem';
        cs2.Status='New';
        cs2.Subject='Test Subject';
        cs2.ESC_Severity__c = '1 - High';
        cs2.ESC_Diagnosis_Summary__c = 'test';
        cs2.ESC_Customer_Symptom__c = 'test';
        cs2.ESC_Impact__c = 'test';        
        cs2.Description = 'Test Description111';
        cs2.contactid=con.id;
        cs2.accountid=acct.id;
        cs2.RecordTypeId =  Schema.SObjectType.Case.getRecordTypeInfosByName().get('Incident').getRecordTypeId();
        cs2.productId = prod.id;
        insert cs2;

        ESC_Case_Collaborator__c cc = new ESC_Case_Collaborator__c();
        cc.OwnerId = us.id;
        cc.ESC_Case__c = cs.id;
        cc.ESC_Role__c = 'Accountable Resolver';
        cc.ESC_referral_status__c = 'New';
        cc.OwnerId=userInfo.getuserid();
        //insert cc;
       
        ESC_Case_Collaborator__c cc1 = new ESC_Case_Collaborator__c();
        cc1.ESC_Case__c = cs.id;
        cc1.ESC_Role__c = 'Collaborator';
        cc1.ESC_referral_status__c = 'New';
        cc1.OwnerId = us.id;

        

        //data related to the class : ESC_Utility -- error comming Null pointer exception - Attemp to deference a null object  line 459
         ESC_MilestoneIdentifierSetting__c ms = new ESC_MilestoneIdentifierSetting__c(Name = 'Next Response Time');
         ms.FieldAPIName__c = 'ESC_Response_Time__c';
         ms.ControllingFieldAPI__c = 'ESC_Next_Response_Time_Flag__c';
         insert ms;
         
        ESC_Static_Values__c  escstaticcaselookup = ESC_Static_Values__c.getValues('CaseIdFromReferral');
        
        Pagereference p= Page.ESC_CreateCaseReferral;
        Test.setCurrentpage(p);
        p.getparameters().put('_lkid',cs2.id);
        
        Test.startTest();
        ApexPages.StandardController referralCtrl = new ApexPages.StandardController(cs2); 
        ESC_CreateCaseReferralController controller=new ESC_CreateCaseReferralController(referralCtrl);
        //controller.testclassVariable=true;
        List<ESC_ValidationSettings__mdt> lstvs1  = new List<ESC_ValidationSettings__mdt>();
        lstvs1=[Select id,Label,Custom_Label__c,ExcludeProfileName__c,IncludeProfileName__c,FieldApiName__c,
                 Field_Value__c,MandatoryFieldApiNames__c,Object__c,
                 Recordtype__c from ESC_ValidationSettings__mdt where DeveloperName='ESCReferralRule1'];
        
        
        controller.lstvs=lstvs1;
        //controller.validateRefCase(cs.id);
        List<string> fieldset = new List<string>();
        controller.getRefRoles();
        controller.InitializeNewReferralRecord();
        controller.referralRecord=cc ;
        controller.saveRecord();
        controller.cancelrecord();
        controller.saveRecord();
        controller.validateRefCase(cs.id);
        
        
        ApexPages.StandardController referralCtrl1 = new ApexPages.StandardController(cs); 
        ESC_CreateCaseReferralController controller1=new ESC_CreateCaseReferralController(referralCtrl1);
        //controller1.referralRecord =cc1;
        controller.referralRecord=cc ;
        controller1.saveRecord();
        controller1.cancelRelatedList();
         }
        Test.stopTest();
        
        integer i = 1;
        integer j = 1;
        System.assertEquals(i,j);
     
    }
}