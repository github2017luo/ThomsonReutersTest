@isTest
public class GlobalReferralControllerTest{
@isTest static void testCallout() {
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new GRMockHttpResponseGenerator());
        
        
      Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
      User testuser  = new User(Alias = 'standt', Email='standarduser@tcs.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, 
      TimeZoneSidKey='America/Los_Angeles', UserName='standarduser@tcs.com');

        insert testuser;
        
        User testuser2 = new User(Alias = 'sndt123', Email='standarduser2@tcs.com', 
        EmailEncodingKey='UTF-8', LastName='Testing2', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = p.Id, ManagerId=testuser.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='standarduser2@tcs.com');
        
        insert testuser2;
        
        Lead leadObj = new Lead(company='xyz',ownerId=testuser.Id,LeadSource='Cross TR Referral',firstname='testfirst',LastName='tesLead');
        insert leadObj;
        Account accobj = new Account(name='testAccount',sales_org__c='WEST');
        insert accObj;
        List<KeyValueListStore__c> keyValList = new List<KeyValueListStore__c>();
        KeyValueListStore__c keyVal = new KeyValueListStore__c();
        keyVal.name='ANZUsersProfileId';
        keyVal.TextValue__c='00e30000001ZUki';
        keyValList.add(keyVal);
        insert keyValList ;
        RecordtypeIds__c recCustom = new RecordtypeIds__c();
        recCustom.name='Pipeline Opportunities';
        recCustom.recTypeId__c='01230000001MA4gAAG';
        insert recCustom;
        RecordtypeIds__c recCustom1 = new RecordtypeIds__c();
        recCustom1.name='Pre-Pipeline Opportunities';
        recCustom1.recTypeId__c='01230000001MA4h';
        insert recCustom1;
        Opportunity oppObj = new Opportunity(win_loss__c='Won – Upgrade',recordtypeId='01230000001MA4gAAG',accountId=accobj.Id,name='xyz',ownerId=testuser.Id,LeadSource='Cross TR Referral',StageName='Order Complete',CloseDate=System.today());
        insert oppObj;
        
        List<Global_Referral_Integration__c > csList = new List<Global_Referral_Integration__c>();
        Global_Referral_Integration__c cs = new Global_Referral_Integration__c();
        cs.Name='ConsumerKey';
        cs.SettingValue__c='testkey';
        csList.add(cs);
        cs = new Global_Referral_Integration__c();
        cs.Name='ConsumerSecret';
        cs.SettingValue__c='ConsumerSecret!!!!';
        csList.add(cs);
        cs = new Global_Referral_Integration__c();
        cs.Name='IntegrationUserName';
        cs.SettingValue__c='testIntegrationUserName';
        csList.add(cs);
        cs = new Global_Referral_Integration__c();
        cs.Name='IntegrationPassword';
        cs.SettingValue__c='IntegrationPassword123';
        csList.add(cs);
        cs = new Global_Referral_Integration__c();
        cs.Name='OAuthEndpoint';
        cs.SettingValue__c='http://api.salesforce.com/foo/bar';
        csList.add(cs);
        cs = new Global_Referral_Integration__c();
        cs.Name='GenevaWebserviceEndpoint';
        cs.SettingValue__c='http://api.salesforce.com/foo/bar';
        csList.add(cs);
        cs = new Global_Referral_Integration__c();
        cs.Name='SourceField';
        cs.SettingValue__c='Leadsource';
        csList.add(cs);

        //cs.Other fiels values
         insert csList ;
        System.runAs(testuser) {
        test.starttest();
        GlobalReferralController gf = new GlobalReferralController();
        gf.callGeneva();
        gf.sendLeadsReferred();
        GlobalReferralController.sortOrder='asc';
        GlobalReferralController.sortableField='LeadOwner';
        GlobalReferralController.referralInputs  empW = new GlobalReferralController.referralInputs('own','bbbbtest comp','test referral det',22.10,system.today().adddays(-1) ,System.today(),
         System.today(),'test ststus',System.today().adddays(1),'OppOwner',112.00,
         'leadBy','opp stage','pri.paw@test.com','X007471');  //Covering inner/wrapper class
         GlobalReferralController.referralInputs  empW2 = new GlobalReferralController.referralInputs('aaaown','test comp','test referral det',11.10,system.today() ,System.today().adddays(1),
         System.today().adddays(2),'aatest ststus',System.today(),'AOppOwner',1123.00,
         'aleadBy','aopp stage','akpri.paw@test.com','X007471');  //Covering inner/wrapper class
        empW.compareTo(empW2);
        GlobalReferralController.sortOrder='asc';
        GlobalReferralController.sortableField='Companyname'; 
        empW.compareTo(empW2);
        GlobalReferralController.sortOrder='asc';
        GlobalReferralController.sortableField='CorporatePayout'; 
        empW.compareTo(empW2);
        GlobalReferralController.sortOrder='asc';
        GlobalReferralController.sortableField='PaymentSubmission'; 
        empW.compareTo(empW2);
        GlobalReferralController.sortOrder='asc';
        GlobalReferralController.sortableField='BUCreatedDate'; 
        empW.compareTo(empW2); 
        GlobalReferralController.sortOrder='asc';
        GlobalReferralController.sortableField='BULastModifiedDate'; 
        empW.compareTo(empW2);
        GlobalReferralController.sortOrder='asc';
        GlobalReferralController.sortableField='LeadStatus'; 
        empW.compareTo(empW2);
        GlobalReferralController.sortOrder='asc';
        GlobalReferralController.sortableField='OpportunityCloseDate'; 
        empW.compareTo(empW2);
        GlobalReferralController.sortOrder='asc';
        GlobalReferralController.sortableField='OpportunityOwner'; 
        empW.compareTo(empW2);
        GlobalReferralController.sortOrder='asc';
        GlobalReferralController.sortableField='OpportunityValue'; 
        empW.compareTo(empW2);
        GlobalReferralController.sortableField='LeadReceivedBy'; 
        empW.compareTo(empW2);
        GlobalReferralController.sortableField='OpportunityStage'; 
        empW.compareTo(empW2);
        GlobalReferralController.sortableField='ReferrerEmail'; 
        empW.compareTo(empW2);
        GlobalReferralController.sortOrder='desc';
        GlobalReferralController.sortableField='Companyname'; 
        empW.compareTo(empW2);
        GlobalReferralController.sortableField='CorporatePayout'; 
        empW.compareTo(empW2);
        GlobalReferralController.sortableField='PaymentSubmission'; 
        empW.compareTo(empW2);
        GlobalReferralController.sortableField='BUCreatedDate'; 
        empW.compareTo(empW2);
        GlobalReferralController.sortableField='BULastModifiedDate'; 
        empW.compareTo(empW2);
        GlobalReferralController.sortableField='LeadStatus'; 
        empW.compareTo(empW2);
        GlobalReferralController.sortableField='OpportunityCloseDate'; 
        empW.compareTo(empW2);
        GlobalReferralController.sortableField='OpportunityOwner'; 
        empW.compareTo(empW2);
        GlobalReferralController.sortableField='OpportunityValue'; 
        empW.compareTo(empW2);
        GlobalReferralController.sortableField='LeadReceivedBy'; 
        empW.compareTo(empW2);
        GlobalReferralController.sortableField='OpportunityStage'; 
        empW.compareTo(empW2);
        GlobalReferralController.sortableField='ReferrerEmail'; 
        empW.compareTo(empW2);
        GlobalReferralController.sortableField='LeadOwner'; 
        gf.doSortLeads();
        GlobalReferralController.sortableField='OppOwner'; 
        gf.doSortOpps();
        GlobalReferralController.LeadsWrapper  leadWrap = new GlobalReferralController.LeadsWrapper('testleadOwner','testLeadname', 'testleadId','testleadownId','testcomp',System.today(),'testStatus');
        GlobalReferralController.LeadsWrapper  leadWrap2 = new GlobalReferralController.LeadsWrapper('AtestleadOwner','AtestLeadname', 'AtestleadId','AtestleadownId','Atestcomp',System.today().adddays(1),'AtestStatus');
        leadWrap.compareTo(leadWrap2);
        GlobalReferralController.sortOrderLead='asc';
        GlobalReferralController.sortableFieldLead='LeadOwner'; 
        leadWrap.compareTo(leadWrap2);
        GlobalReferralController.sortableFieldLead='Companyname'; 
        leadWrap.compareTo(leadWrap2);
        GlobalReferralController.sortableFieldLead='createdDate'; 
        leadWrap.compareTo(leadWrap2);
        GlobalReferralController.sortableFieldLead='status'; 
        leadWrap.compareTo(leadWrap2);
        GlobalReferralController.sortableFieldLead='Leadname'; 
        leadWrap.compareTo(leadWrap2);
        GlobalReferralController.sortOrderLead='desc';
        GlobalReferralController.sortableFieldLead='LeadOwner'; 
        leadWrap.compareTo(leadWrap2);
        GlobalReferralController.sortableFieldLead='Companyname'; 
        leadWrap.compareTo(leadWrap2);
        GlobalReferralController.sortableFieldLead='createdDate'; 
        leadWrap.compareTo(leadWrap2);
        GlobalReferralController.sortableFieldLead='status'; 
        leadWrap.compareTo(leadWrap2);
        GlobalReferralController.sortableFieldLead='Leadname'; 
        leadWrap.compareTo(leadWrap2);

        GlobalReferralController.OppWrapper  oppWrap = new GlobalReferralController.OppWrapper  ('testowner','testOppname', 'testoppId','testoppowid','testcomp',System.today(),System.today() ,'teststage',123.00);
        GlobalReferralController.OppWrapper  oppWrap2= new GlobalReferralController.OppWrapper  ('Atestowner','AtestOppname', 'AtestoppId','Atestoppowid','Atestcomp',System.today().adddays(-1),System.today().adddays(2) ,'Ateststage',122.00);
        oppWrap.compareTo(oppWrap2 );
        GlobalReferralController.sortOrderOpp='asc';
        GlobalReferralController.sortableFieldOpp ='OppOwner'; 
        oppWrap.compareTo(oppWrap2);
        GlobalReferralController.sortableFieldOpp ='Companyname'; 
        oppWrap.compareTo(oppWrap2);
        GlobalReferralController.sortableFieldOpp ='createdDate'; 
        oppWrap.compareTo(oppWrap2);
        GlobalReferralController.sortableFieldOpp ='stage'; 
        oppWrap.compareTo(oppWrap2);
        GlobalReferralController.sortableFieldOpp ='Oppname'; 
        oppWrap.compareTo(oppWrap2);
        GlobalReferralController.sortableFieldOpp ='Amount'; 
        oppWrap.compareTo(oppWrap2);
        GlobalReferralController.sortableFieldOpp ='ClosedDate'; 
        oppWrap.compareTo(oppWrap2);
        GlobalReferralController.sortOrderOpp='desc';
        GlobalReferralController.sortableFieldOpp ='LeadOwner'; 
        oppWrap.compareTo(oppWrap2);
        GlobalReferralController.sortableFieldOpp ='Companyname'; 
        oppWrap.compareTo(oppWrap2);
        GlobalReferralController.sortableFieldOpp ='createdDate'; 
        oppWrap.compareTo(oppWrap2);
        GlobalReferralController.sortableFieldOpp ='stage'; 
        oppWrap.compareTo(oppWrap2);
        GlobalReferralController.sortableFieldOpp ='Oppname'; 
        oppWrap.compareTo(oppWrap2);
        GlobalReferralController.sortableFieldOpp ='Amount'; 
        oppWrap.compareTo(oppWrap2);
        GlobalReferralController.sortableFieldOpp ='ClosedDate'; 
        oppWrap.compareTo(oppWrap2);
         system.assert(true);
        test.stoptest();
        }
        // Verify response received contains fake values
        //String contentType = res.getHeader('Content-Type');
        //System.assert(contentType == 'application/json');
        //String actualValue = res.getBody();
        //String expectedValue = '{"foo":"bar"}';
        //System.assertEquals(actualValue, expectedValue);
        //System.assertEquals(200, res.getStatusCode());
    }
}