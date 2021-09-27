/**********************************
Class Name: ESC_ReferalTriggerTest
Purpose:
Author: Rupesh/Gousia
Date Created:15/08/2017
Date Updated:V0 :  TEst class for ESC_ReferalTriggerHelperClass
             V1 : Updated with  method : updateUPDFlagForReferrals
**********************************/
@isTest(SeeAllData=false)
public with sharing class ESC_ReferalTriggerTest{
@isTest static void ReferralTriggerTest(){
        
        
        //create a user records  
        Profile Prof = [SELECT Id FROM profile WHERE name='LatAM Helpdesk Agent']; 
        
        User Us =  New User(FirstName = 'James' , LastName= 'ThomasTest',Alias = 'jttest',Email='james1.thomastest@thomsonreuters.com', emailencodingkey='UTF-8', 
        UserName='james1.thomastest@thomsonreuters.com',languagelocalekey='en_US', localesidkey='en_US', 
        profileid = Prof.Id,timezonesidkey='America/Los_Angeles',CommunityNickname='James.ThomasTest');
        insert Us;
        
        
        System.assert(Us.id != null);
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
        Product2 prod = new Product2(name='Teest Prod');
       insert prod;
        
       Group g = new Group();
            g.Name = 'TXP_C2C_Order_Management12';
            g.type='Queue';
            insert g;

        QueueSobject mappingObject = new QueueSobject(QueueId = g.Id, SobjectType = 'Case');
            System.runAs(new User(Id = UserInfo.getUserId()))
             {insert mappingObject;}
        
        Test.startTest();
        // insert a case records
        Case cs = new Case();
        cs.Type='Data';
        //cs.Status='Work In Progress';
        cs.Status='New';
        cs.Subject='Test Subject';
        cs.Description = 'Test Description111';
        cs.contactid=con.id;
        cs.Origin='Email';
        cs.OwnerId=g.id;
        cs.Is_GLI__c=false;
        cs.ESC_Origin_Name__c='txt';
        cs.accountid=acct.id;
        cs.LCRM_Sub_BU__c  ='Canada';
        cs.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Incident').getRecordTypeId();
        cs.productId = prod.id;
        cs.ESC_Case_Type__c = 'Incident';
        cs.ESC_Impact__c='3-Single User';
        cs.ESC_Diagnosis_Summary__c='Application/Infrastructure/Upgrade';
        cs.ESC_Resolution_Code__c='Config Change';
        cs.Priority='1-High';
        //cs.ESC_UPD_Owner__c = False;
        
        insert cs;
        
        Map<id,ESC_Case_Collaborator__c> newreferralMap=new Map<id,ESC_Case_Collaborator__c>();
        Map<id,ESC_Case_Collaborator__c> oldreferralMap=new Map<id,ESC_Case_Collaborator__c>();
        
        List<ESC_Case_Collaborator__c> listRefNew = new List<ESC_Case_Collaborator__c>();
        List<ESC_Case_Collaborator__c> listRefold = new List<ESC_Case_Collaborator__c>();
        
        // insert Case collaborator records
        ESC_Case_Collaborator__c cc = new ESC_Case_Collaborator__c();
        cc.ESC_Case__c = cs.id;
        cc.ESC_Role__c = 'Escalation';
       // cc.ESC_referral_status__c = 'Work In Progress';
        cc.ESC_referral_status__c = 'In Progress';
        cc.ESC_ReferralUPD__c = False;
        cc.OwnerId=Us.id;
        insert cc;
        oldreferralMap.put(cc.id,cc);
       
        ESC_Case_Collaborator__c cc11=cc.clone();
        cc11.id=cc.id;
        cc11.ESC_Role__c='Accountable Resolver';
        newreferralMap.put(cc11.id,cc11);
        
        ESC_ReferalTriggerHelperClass.addremoveOwnerToCaseTeamFilter(newreferralMap,oldreferralMap);
        ESC_ReferalTriggerHelperClass.EndDatingOldReferralFilter(newreferralMap,oldreferralMap);
        
        // calling a method : 
        List<EmailMessage> emails = new List<EmailMessage>();
        EmailMessage newEmail = new EmailMessage(ParentId = cs.Id, FromAddress = 'dummytest@thomsonreuters.com');
        emails.add(newEmail);
        insert emails;
        ESC_ReferalTriggerHelperClass.updateUPDFlagForReferrals(emails);
        
        // Process Builder Can_email-to-case
        try
        {
        EmailMessage newEmail1 = new EmailMessage(ParentId = cs.Id, FromAddress = 'dummytest@thomsonreuters.com',Incoming=true,TextBody='test', Subject='MyAccount - Address Change' );
        insert newEmail1;
        }
        catch(Exception e)
        {
            system.debug(e);
        }
        
         /*
         ESC_MilestoneIdentifierSetting__c ms = new ESC_MilestoneIdentifierSetting__c(Name = 'Next Response Time');
         ms.FieldAPIName__c = 'ESC_Response_Time__c';
         ms.ControllingFieldAPI__c = 'ESC_Next_Response_Time_Flag__c';
         insert ms;
        
         Entitlement ent = new  Entitlement (Name= 'VIP Entiltlement',accountid=acct.id);
         insert ent;
         
         EntitlementSelectorList__c esl = new  EntitlementSelectorList__c(ESC_Entitlement__c = ent.id);
         insert esl;
       
         // calling a method: updateUPDFlagForReferrals
         Set<String> s = new Set<String>{'Jon', 'Quinton', 'Reid'}; 
          ESC_ReferalTriggerHelperClass.updateUPDFlagForReferrals(s);
        ESC_ReferalTriggerHelperClass ref = new ESC_ReferalTriggerHelperClass();
        ESC_ReferalTriggerHelperClass.updateUPDFlagForReferrals(s,'test','test');
        
 
        
        // insert a FeedItem 
        
        FeedItem fd  = new FeedItem();
        fd.ParentId = cs.Id;
        fd.Body = '[xzxzxzxz]';
        fd.Type ='ContentPost';
        insert fd;
       */
      Test.stopTest();
}  
    @isTest
    static void ReferralTriggerTest0()
    {
        Test.startTest();
        
        Profile Prof = [SELECT Id FROM profile WHERE name='LatAM Helpdesk Agent']; 
        
        User Us =  New User(FirstName = 'James' , LastName= 'ThomasTest',Alias = 'jttest',Email='james1.thomastest@thomsonreuters.com', emailencodingkey='UTF-8', 
                            UserName='james1.thomastest@thomsonreuters.com',languagelocalekey='en_US', localesidkey='en_US', 
                            profileid = Prof.Id,timezonesidkey='America/Los_Angeles',CommunityNickname='James.ThomasTest');
        insert Us;
        
        
        System.assert(Us.id != null);
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
        Product2 prod = new Product2(name='Teest Prod');
        insert prod;
        
        Group g = new Group();
        g.Name = 'TXP_C2C_Order_Management12';
        g.type='Queue';
        insert g;
        
        QueueSobject mappingObject = new QueueSobject(QueueId = g.Id, SobjectType = 'Case');
        System.runAs(new User(Id = UserInfo.getUserId()))
        {insert mappingObject;}
        
        // insert a case records
        Case cs = new Case();
        cs.Type='Data';
        //cs.Status='Work In Progress';
        cs.Status='New';
        cs.Subject='Test Subject';
        cs.Description = 'Test Description111';
        cs.contactid=con.id;
        cs.Origin='Email';
        cs.OwnerId=g.id;
        cs.Is_GLI__c=false;
        cs.ESC_Origin_Name__c='txt';
        cs.accountid=acct.id;
        cs.LCRM_Sub_BU__c  ='Canada';
        cs.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Incident').getRecordTypeId();
        cs.productId = prod.id;
        cs.ESC_Case_Type__c = 'Incident';
        cs.ESC_Impact__c='3-Single User';
        cs.ESC_Diagnosis_Summary__c='Application/Infrastructure/Upgrade';
        cs.ESC_Resolution_Code__c='Config Change';
        cs.Priority='1-High';
        //cs.ESC_UPD_Owner__c = False;
        
        insert cs;
        
        ESC_MilestoneIdentifierSetting__c ms = new ESC_MilestoneIdentifierSetting__c(Name = 'Next Response Time');
        ms.FieldAPIName__c = 'ESC_Response_Time__c';
        ms.ControllingFieldAPI__c = 'ESC_Next_Response_Time_Flag__c';
        insert ms;
        
        Entitlement ent = new  Entitlement (Name= 'VIP Entiltlement',accountid=acct.id);
        insert ent;
        
        EntitlementSelectorList__c esl = new  EntitlementSelectorList__c(ESC_Entitlement__c = ent.id);
        insert esl;
        
        // calling a method: updateUPDFlagForReferrals
        Set<String> s = new Set<String>{'Jon', 'Quinton', 'Reid'}; 
            ESC_ReferalTriggerHelperClass.updateUPDFlagForReferrals(s);
        ESC_ReferalTriggerHelperClass ref = new ESC_ReferalTriggerHelperClass();
        ESC_ReferalTriggerHelperClass.updateUPDFlagForReferrals(s,'test','test');
        
        
        
        // insert a FeedItem 
        
        FeedItem fd  = new FeedItem();
        fd.ParentId = cs.Id;
        fd.Body = '[xzxzxzxz]';
        fd.Type ='ContentPost';
        insert fd;
        
        Test.stopTest();
    }
    
@isTest static void ReferralTriggerTest2(){
        Test.startTest();
        
        //create a user records  
        Profile Prof = [SELECT Id FROM profile WHERE name='LatAM Helpdesk Agent']; 
        
        User Us =  New User(FirstName = 'James' , LastName= 'ThomasTest',Alias = 'jttest',Email='james1.thomastest@thomsonreuters.com', emailencodingkey='UTF-8', 
        UserName='james1.thomastest@thomsonreuters.com',languagelocalekey='en_US', localesidkey='en_US', 
        profileid = Prof.Id,timezonesidkey='America/Los_Angeles',CommunityNickname='James.ThomasTest');
        insert Us;
        System.assert(Us.id != null);
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
        Product2 prod = new Product2(name='Teest Prod');
       insert prod;
        
        //insert a case list
        List<Case> clist = new List<Case>();
        Case cs1  = new Case(Type='Data',Status='New', contactid=con.id,accountid=acct.id);
        clist.add(cs1);
        insert clist;
 
        List<ESC_Case_Collaborator__c> ecc = new List<ESC_Case_Collaborator__c>();
        ESC_Case_Collaborator__c cc1 = new ESC_Case_Collaborator__c();
        cc1.ESC_Case__c = cs1.id;
        cc1.ESC_Role__c = 'Collaborator';
        cc1.ownerid=Us.id;
        cc1.ESC_referral_status__c = 'In Progress';
        cc1.ESC_ReferralUPD__c = true;
        ecc.add(cc1);
        insert ecc;
       
        List<ESC_Case_Collaborator__c> ecc1 = new List<ESC_Case_Collaborator__c>();
        ESC_Case_Collaborator__c cc2 = new ESC_Case_Collaborator__c();
        cc2.ESC_Case__c = cs1.id;
        cc2.ESC_Role__c = 'Collaborator';
        cc2.ownerid=Us.id;
        cc2.ESC_referral_status__c = 'In Progress';
        cc2.ESC_ReferralUPD__c = true;
        //ecc1.add(cc2);
        insert cc2;
        cc2.ESC_referral_status__c = 'Rejected';
        cc2.ESC_Rejection_Cancellation_Reason__c = 'test';
        ecc1.add(cc2);
        update ecc1;
        
        ESC_ReferalTriggerHelperClass.updUnchecking(ecc1);
       
      Test.stopTest();
}  

@isTest static void ReferralTriggerFormRef(){
        
        
        //create a user records  
        Profile Prof = [SELECT Id FROM profile WHERE name='LatAM Helpdesk Agent']; 
        
        User Us =  New User(FirstName = 'James' , LastName= 'ThomasTest',Alias = 'jttest',Email='james1.thomastest@thomsonreuters.com', emailencodingkey='UTF-8', 
        UserName='james1.thomastest@thomsonreuters.com',languagelocalekey='en_US', localesidkey='en_US', 
        profileid = Prof.Id,timezonesidkey='America/Los_Angeles',CommunityNickname='James.ThomasTest');
        insert Us;
        
         
        System.assert(Us.id != null);
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
        Product2 prod = new Product2(name='Teest Prod');
       insert prod;
        //BusinessHours defaultBH = [Select Id From BusinessHours Where IsDefault = True limit 1];
        BusinessHours defaultBH;
       for( BusinessHours BusinessHoursId : [SELECT Id FROM BusinessHours WHERE IsActive=true]){
         if (BusinessHours.isWithin(BusinessHoursId.Id, system.now())){ 
          defaultBH=BusinessHoursId;
          break;
         }}
         Group g = new Group();
            g.Name = 'TXP_C2C_Order_Management12';
            g.type='Queue';
            insert g;
      // insert a case records
        Case cs = new Case();
        cs.Type='Data';
        //cs.Status='Work In Progress';
        cs.Status='New';
        cs.Subject='Test Subject';
        cs.Description = 'Test Description111';
        cs.contactid=con.id;
        cs.accountid=acct.id;
        cs.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Incident').getRecordTypeId();
        cs.productId = prod.id;
        cs.ESC_Case_Type__c = 'Incident';
        cs.ESC_Impact__c='3-Single User';
        cs.ESC_Diagnosis_Summary__c='Application/Infrastructure/Upgrade';
        cs.ESC_Resolution_Code__c='Config Change';
        cs.Priority='1-High';
        cs.ESC_UPD_Action__c= '1#Via Email,2#ViaAttachment';
        cs.BusinessHoursId=defaultBH.id;
        cs.ownerid = Us.id;
        cs.LCRM_Sub_BU__c='US';
        insert cs;
        Test.startTest();
        set<String> caseset = new set<String>();
        caseset.add(cs.id);
        
        
       
            QueueSobject mappingObject = new QueueSobject(QueueId = g.Id, SobjectType = 'ESC_Case_Collaborator__c');
            System.runAs(new User(Id = UserInfo.getUserId()))
             {insert mappingObject;}
            
            USL_Case_SLA_Matrix__c sla= new USL_Case_SLA_Matrix__c();
            sla.Name='TXP_C2C_Order_Management12';
            sla.USL_Queue__c='TXP_C2C_Order_Management12';
            sla.USL_Referral_SLA_Minutes__c=1220;
            insert sla;
        
        Map<id,ESC_Case_Collaborator__c> newreferralMap=new Map<id,ESC_Case_Collaborator__c>();
        Map<id,ESC_Case_Collaborator__c> newreferralMap1=new Map<id,ESC_Case_Collaborator__c>();
        Map<id,ESC_Case_Collaborator__c> oldreferralMap=new Map<id,ESC_Case_Collaborator__c>();
        
        List<ESC_Case_Collaborator__c> listRefNew = new List<ESC_Case_Collaborator__c>();
        
        // insert Case collaborator records
        ESC_Case_Collaborator__c cc = new ESC_Case_Collaborator__c();
        cc.ESC_Case__c = cs.id;
        cc.ESC_Role__c = 'Accountable Resolver';
        cc.ESC_referral_status__c = 'In Progress';
        cc.ESC_ReferralUPD__c = False;
        cc.OwnerId=g.id;
        insert cc;
        ESC_Case_Collaborator__c cc1 = new ESC_Case_Collaborator__c();
        cc1.ESC_Case__c = cs.id;
        cc1.ESC_Role__c = 'Accountable Resolver';
        cc1.ESC_referral_status__c = 'In Progress';
        cc1.ESC_ReferralUPD__c = False;
        cc1.OwnerId=g.id;
        insert cc1;
        newreferralMap.put(cc.id,cc);
        listRefNew.add(cc);
        //listRefNew.add(cc1);
        
        
        //ESC_Case_Collaborator__c cc11= new ESC_Case_Collaborator__c();
        //cc.clone();
        //cc11.id=cc.id;
        cc.OwnerId=Us.id;
        //insert cc;
        oldreferralMap.put(cc.id,cc);
        ESC_ReferalTriggerHelperClass.CalculateReferralSLA(newreferralMap,oldreferralMap);
        ESC_ReferalTriggerHelperClass.CalculateReferralSLAinsert(listRefNew);
        //ESC_ReferalTriggerHelperClass.updateFileUPDForCases(caseset);
        newreferralMap1.put(cc1.id,cc1);
        ESC_ReferalTriggerHelperClass.caseChatterPostforRejectedReferral(newreferralMap1,newreferralMap);
        ESC_ReferalTriggerHelperClass.updateUPDForCases(caseset,'ESC_ViaAttachment','2#ViaAttachment');
     Test.stopTest();
}  
  
}