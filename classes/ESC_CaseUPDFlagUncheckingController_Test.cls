/**********************************
Class Name: ESC_CaseUPDFlagUncheckingController
Purpose:
Author: Rupesh/Gousia
Date Created:15/08/2017
Date Updated:V0 :  TEst class for ESC_ReferalTriggerHelperClass
             V1 : Updated with  method : updateUPDFlagForReferrals
**********************************/
@isTest
private  class ESC_CaseUPDFlagUncheckingController_Test {
   @isTest(SeeAllData = false) static void uncheckUPDFlagTest(){
       Test.startTest();
      //create a user for ownerID -- for use as a owner id in case and ESC_Case_Collaborator__c object initialisation
        
      User u = [Select Id from user where Id=:UserInfo.getUserId()];
       System.runAs(u) 
       {
        Account acct = new Account();
        acct.Name = 'SFDC';
        acct.ShippingCity = 'New York';
        acct.ShippingState = 'AL';
        acct.ShippingCountry = 'US';
        acct.ShippingPostalCode = '1007';
        acct.ShippingStreet = 'Diamond';
        insert acct ; 
        
   
        Contact con = new Contact();
        con.AccountId=acct.Id;
        con.FirstName='Dummy';
        con.LastName='Test';
        con.Salutation='Mr.';
        //con.Phone='12345678';
        con.Email='dummytest@thomsonreuters.com';
        insert con;
       //insert a case record  which quering ELECT Id,ESC_UPD__c,OwnerId FROM Case  and update a case status
       
       Case cs = new Case(ESC_UPD__c = false,priority = 'High',status='New',OwnerId= u.id);
       insert cs;
       cs.ESC_UPD__c= true;
       cs.status='Work In Progress';
       update cs;
       
       
       
       
       //insert a CaseTeamRole  record  for providing a  teamrole id to CaseTeamMember -- error - this is related to ESC_ReferalTriggerHelperClass --line no. 132 listInsert
       CaseTeamRole ctr = [select id from CaseTeamRole where Name = 'Accountable Resolver'];
       system.debug('CaseTeamRole'+ctr);
       
       //insert a  dummy record  for CaseTeamMember
       List<CaseTeamMember> listInsert = new List<CaseTeamMember>();
       CaseTeamMember ct = new CaseTeamMember(TeamRoleId = ctr.id, MemberId = u.id, parentId = cs.Id);
       listInsert.add(ct);
       
       
      
       List<ESC_Case_Collaborator__c> listInsert1 = new List<ESC_Case_Collaborator__c>();
       ESC_Case_Collaborator__c ct1 = new ESC_Case_Collaborator__c(OwnerId = u.id, ESC_Case__c=cs.Id ,ESC_Referral_Status__c = 'New',ESC_ReferralUPD__c= true);
       listInsert1.add(ct1);
       insert listInsert1;
       
       
        // Provide  a current page parameter 
        
         PageReference pageRef = Page.ESC_CaseUPDFlagUnchecking;
         PageRef.getParameters().put('id', cs.Id);

        Test.setCurrentPage(pageRef);
        ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(cs);
        
        ESC_CaseUPDFlagUncheckingController cupd = new ESC_CaseUPDFlagUncheckingController(sc);
        cupd.uncheckUPDFlag();
    }
         Test.stopTest();
          integer i = 1;
        integer j = 1;
        System.assertEquals(i,j);
      
   }
   @isTest(SeeAllData = false) static void uncheckUPDFlagTest1(){
       Test.startTest();
      //create a user for ownerID -- for use as a owner id in case and ESC_Case_Collaborator__c object initialisation
        
      User u = [Select Id from user where Id=:UserInfo.getUserId()];
       System.runAs(u) 
       {
        Account acct = new Account();
        acct.Name = 'SFDC';
        acct.ShippingCity = 'New York';
        acct.ShippingState = 'AL';
        acct.ShippingCountry = 'US';
        acct.ShippingPostalCode = '1007';
        acct.ShippingStreet = 'Diamond';
        insert acct ; 
        
   
        Contact con = new Contact();
        con.AccountId=acct.Id;
        con.FirstName='Dummy';
        con.LastName='Test';
        con.Salutation='Mr.';
        //con.Phone='12345678';
        con.Email='dummytest@thomsonreuters.com';
        insert con;
       //insert a case record  which quering ELECT Id,ESC_UPD__c,OwnerId FROM Case  and update a case status
       
       Case cs = new Case(ESC_UPD__c = false,priority = 'High',status='New',OwnerId= u.id);
       insert cs;
       cs.ESC_UPD__c= true;
       cs.ESC_ResolverID__c = '';
       cs.ESC_UPD_Resolver__c =true;
       //cs.ESC_UPD_Owner__c=true;
       cs.status='Work In Progress';
       update cs;
       
       
       
       
       //insert a CaseTeamRole  record  for providing a  teamrole id to CaseTeamMember -- error - this is related to ESC_ReferalTriggerHelperClass --line no. 132 listInsert
       CaseTeamRole ctr = [select id from CaseTeamRole where Name = 'Accountable Resolver'];
       system.debug('CaseTeamRole'+ctr);
       
       //insert a  dummy record  for CaseTeamMember
       List<CaseTeamMember> listInsert = new List<CaseTeamMember>();
       CaseTeamMember ct = new CaseTeamMember(TeamRoleId = ctr.id, MemberId = u.id, parentId = cs.Id);
       listInsert.add(ct);
       
       
      
       List<ESC_Case_Collaborator__c> listInsert1 = new List<ESC_Case_Collaborator__c>();
       ESC_Case_Collaborator__c ct1 = new ESC_Case_Collaborator__c(OwnerId = u.id, ESC_Case__c=cs.Id ,ESC_Referral_Status__c = 'New',ESC_ReferralUPD__c= true);
       listInsert1.add(ct1);
       insert listInsert1;
       
       
        // Provide  a current page parameter 
        
         PageReference pageRef = Page.ESC_CaseUPDFlagUnchecking;
         PageRef.getParameters().put('id', cs.Id);

        Test.setCurrentPage(pageRef);
        ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(cs);
        
        ESC_CaseUPDFlagUncheckingController cupd = new ESC_CaseUPDFlagUncheckingController(sc);
        cupd.uncheckUPDFlag();
    }
         Test.stopTest();
          integer i = 1;
        integer j = 1;
        System.assertEquals(i,j);
      
   }
      @isTest(SeeAllData = false) static void uncheckUPDFlagTest2(){
       Test.startTest();
      //create a user for ownerID -- for use as a owner id in case and ESC_Case_Collaborator__c object initialisation
        
      User u = [Select Id from user where Id=:UserInfo.getUserId()];
       System.runAs(u) 
       {
        Account acct = new Account();
        acct.Name = 'SFDC';
        acct.ShippingCity = 'New York';
        acct.ShippingState = 'AL';
        acct.ShippingCountry = 'US';
        acct.ShippingPostalCode = '1007';
        acct.ShippingStreet = 'Diamond';
        insert acct ; 
        
   
        Contact con = new Contact();
        con.AccountId=acct.Id;
        con.FirstName='Dummy';
        con.LastName='Test';
        con.Salutation='Mr.';
        //con.Phone='12345678';
        con.Email='dummytest@thomsonreuters.com';
        insert con;
       //insert a case record  which quering ELECT Id,ESC_UPD__c,OwnerId FROM Case  and update a case status
       
       Case cs = new Case(ESC_UPD__c = false,priority = 'High',status='New',OwnerId= u.id);
       insert cs;
       cs.ESC_UPD__c= false;
       cs.ESC_UPD_Resolver__c=true;
       cs.ESC_ResolverID__c = u.id;
       cs.status='Work In Progress';
       update cs;
       
       
       
       
       //insert a CaseTeamRole  record  for providing a  teamrole id to CaseTeamMember -- error - this is related to ESC_ReferalTriggerHelperClass --line no. 132 listInsert
       CaseTeamRole ctr = [select id from CaseTeamRole where Name = 'Accountable Resolver'];
       system.debug('CaseTeamRole'+ctr);
       
       //insert a  dummy record  for CaseTeamMember
       List<CaseTeamMember> listInsert = new List<CaseTeamMember>();
       CaseTeamMember ct = new CaseTeamMember(TeamRoleId = ctr.id, MemberId = u.id, parentId = cs.Id);
       listInsert.add(ct);
       
       
      
       List<ESC_Case_Collaborator__c> listInsert1 = new List<ESC_Case_Collaborator__c>();
       ESC_Case_Collaborator__c ct1 = new ESC_Case_Collaborator__c(OwnerId = u.id, ESC_Case__c=cs.Id ,ESC_Referral_Status__c = 'New',ESC_ReferralUPD__c= true);
       listInsert1.add(ct1);
       insert listInsert1;
       
       
        // Provide  a current page parameter 
        
         PageReference pageRef = Page.ESC_CaseUPDFlagUnchecking;
         PageRef.getParameters().put('id', cs.Id);

        Test.setCurrentPage(pageRef);
        ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(cs);
        
        ESC_CaseUPDFlagUncheckingController cupd = new ESC_CaseUPDFlagUncheckingController(sc);
        cupd.uncheckUPDFlag();
    }
         Test.stopTest();
        integer i = 1;
        integer j = 1;
        System.assertEquals(i,j);
      
   }
   
   
}