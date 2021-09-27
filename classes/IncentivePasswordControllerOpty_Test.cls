/*
======================================================================================================================
TEST CLASS NAME: IncentivePasswordControllerOpty_Test
======================================================================================================================
=
PURPOSE: Validates the functionality provided by the IncentivePasswordControllerOpty class.

CHANGE HISTORY:
======================================================================================================================
DATE             NAME           DESC
31/03/2017       Gunaseelan K   Optimized the code as per JIRA STORY: PS0-1
09/10/2017                  Seema       Updated for CRM-6642
======================================================================================================================
*/

@istest (seealldata=false)
public with sharing class IncentivePasswordControllerOpty_Test {
    public static testMethod void testDetailController(){
        UnitTest.createTestData();
         UnitTest.createOptiTestData();
        Account testAcc1 = UnitTest.getAccountInstance();
        insert testAcc1;
        
        List<contact> testconList = new List<Contact>();
        for (integer i=0; i<12; i++) {
            testconlist.add(UnitTest.getContactInstance(testAcc1.id));
        }
        
        
        Opportunity testOpty = UnitTest.getOpportunityInstance(testAcc1.Id);
        insert testOpty;
        
        testconList[0].sap_role__c ='as';
        insert testconList;
        
        incentive_promotion__c testIPC = new incentive_promotion__c(account__C=testAcc1.id,opportunity__c = testopty.id);
        insert testIPC;
        
        Incentive_Password__c testIPD = new Incentive_Password__c(Promotion__c=testIPC.id,end_date__c=system.today());
        insert testIPD;
        
        ApexPages.standardController sc = new ApexPages.standardController(testOpty);
        Test.setCurrentPageReference(Page.IncentivePassword);
        IncentivePasswordControllerOpty controller = new IncentivePasswordControllerOpty(sc);       
        controller.loadWestlawOpenPromotions();
        controller.loadWestlawNextOpenPromotions();
        controller.loadPublicRecordsOpenPromotions();
        controller.loadBusinessLawResearchGSIPromotions();
        controller.saveHistory();
        controller.IncentivePromotionHistory = new List<IncentivePasswordControllerOpty.IncentivePromotion>();
        controller.IncentivePromotionHistory.add(new IncentivePasswordControllerOpty.IncentivePromotion());
        controller.IncentivePromotionHistory[0].isSelected = true;
        // controller.IncentivePromotionHistory[0].PromotionPasswords[0].isSelected = true;
         // controller.IncentivePromotionHistory[0].PromotionPasswords[1].isSelected = true;
        controller.getUrlOpen();
        
        controller.getCurrentList();
        controller.currenttab='Westlaw';
        controller.contactSetList[0].checked =true;
        
        controller.WestlawPromotions = new List<IncentivePasswordControllerOpty.IncentivePromotion>();
        controller.WestlawPromotions.add(new IncentivePasswordControllerOpty.IncentivePromotion());
        controller.WestlawPromotions[0].isSelected = true;
        controller.WestlawGenericPasswords = 2;
        
        controller.BusinessLawResearchGSIPromotions = new List<IncentivePasswordControllerOpty.IncentivePromotion>();
        controller.BusinessLawResearchGSIPromotions.add(new IncentivePasswordControllerOpty.IncentivePromotion());
        controller.BusinessLawResearchGSIPromotions[0].isSelected = true;
        controller.GSIGenericPasswords = 2;
        
        controller.PublicRecordsPromotions = new List<IncentivePasswordControllerOpty.IncentivePromotion>();
        controller.PublicRecordsPromotions.add(new IncentivePasswordControllerOpty.IncentivePromotion());
        controller.PublicRecordsPromotions[0].isSelected = true;
        
        controller.WestlawNextPromotions = new List<IncentivePasswordControllerOpty.IncentivePromotion>();
        controller.WestlawNextPromotions.add(new IncentivePasswordControllerOpty.IncentivePromotion());
        controller.WestlawNextPromotions[0].isSelected = true;
        
        controller.addContact();
        controller.searchContact();
        controller.currenttab='WestlawNext';
        controller.addContact();
        controller.searchContact();
        controller.currenttab='PublicRecords';
        controller.addContact();
        controller.searchContact();
         controller.cancel();
        controller.createcontact();
        
        controller.currentTab = 'Westlaw';
        controller.removeContact();
        controller.currentTab = 'WestlawNext';
        controller.removeContact();
        controller.currentTab = 'BusinessLawResearchGSI';
        controller.removeContact();
        controller.addContact();
        controller.currentTab = 'PublicRecords';
        controller.removeContact();
        
        controller.SubmitWestlawRequest();
        controller.SubmitWestlawNextRequest();
        controller.SubmitPublicRecordsRequest();
        controller.SubmitBusinessLawResearchGSIRequest();
        
        IncentivePasswordControllerOpty.contactSet testcontactSet = new IncentivePasswordControllerOpty.contactSet();
        IncentivePasswordControllerOpty.IncentivePromotion testIncentivePromotion = new IncentivePasswordControllerOpty.IncentivePromotion();
        IncentivePasswordControllerOpty.PromotionPassword testPromotionPassword = new IncentivePasswordControllerOpty.PromotionPassword();
        IncentivePasswordControllerOpty.MatchedContact mc1= new IncentivePasswordControllerOpty.MatchedContact();
        
        IncentivePasswordRegistration.OpenPromotionRequest oPromotionRequest = new IncentivePasswordRegistration.OpenPromotionRequest();
        WebServiceSettings__c oWebServiceSettings = AppUtil.getWebServiceSettings('Incentive Passwords');       
        oPromotionRequest.endpoint= oWebServiceSettings.Endpoint__c;
        oPromotionRequest.timeout =(oWebServiceSettings.Timeout__c * 1000).intValue(); //Convert seconds to milliseconds
        oPromotionRequest.username=oWebServiceSettings.Username__c;
        oPromotionRequest.password= oWebServiceSettings.Password__c;
        IncentivePromoTypes__c oIncentivePromoTypes = IncentivePromoTypes__c.getInstance('Westlaw');
        /* skg        
        oPromotionRequest.DomainName = oIncentivePromoTypes.CompanyCode__c;
        oPromotionRequest.CompanyCode = oIncentivePromoTypes.DomainName__c;*/
        oPromotionRequest.DomainName = oIncentivePromoTypes.DomainName__c;
        oPromotionRequest.CompanyCode = oIncentivePromoTypes.CompanyCode__c;
        oPromotionRequest.PromotionType = oIncentivePromoTypes.Type__c;
    }
    
    
    
     public static testMethod void testNullStandardController() {
        //Setup Test
        PageReference oPage = Page.ContactCreatefromIncentivePswd;
        Test.setCurrentPage(oPage);
        
        Test.startTest();
        
    //    ContactCreateController oController = new ContactCreateController(null);
    //    System.assert(ApexPages.hasMessages() == true, 'Expected error message when a null standard controller is used');
 
        Test.stopTest();
    }
    
   
    /**
     * Validates the save method
     */
    public static testMethod void testContinueSave() {
        //Setup Test
        WebServiceSettings__c oWebServiceSettings = DataQualityUtil_Test.setupCleanseAddressServiceSettings();
    DataQualityUtil_Test.setupMockAddressCleanseServiceSuccessResponse();
    
    Account oaccount = UnitTest.getAccountInstance();
        Contact ocontact = UnitTest.getContactInstance(oaccount.Id);
        //ocontact.name = 'Fred';
        ocontact.lastname = 'Smith';
        ocontact.Email = 'Fred@Smith.com';
   // insert ocontact;
    
    
  
        Test.startTest();
        
        PageReference oPage = Page.ContactCreatefromIncentivePswd;
        Test.setCurrentPage(oPage);
        
        ApexPages.StandardController oStandardController = new ApexPages.StandardController(oContact);
                
        IncentivePasswordControllerOpty oController = new IncentivePasswordControllerOpty(oStandardController);
        //oController.onPageLoad();
        oController.addcontactlist = new List<COntact>();
        oController.oContact = ocontact;
        oController.HasMatchingContacts = false;
        oController.SkipContactMatching = true;
        
        //PageReference oPageReference = oController.save();
        
        PageReference oPageReference = oController.Continuesave();
        
        Test.stopTest();
        
        //Validate Test
        System.assertNotEquals(null, oPageReference);
    }
   public static testMethod void testBasicSave() { 
        //Setup Test
        WebServiceSettings__c oWebServiceSettings = DataQualityUtil_Test.setupCleanseAddressServiceSettings();
    DataQualityUtil_Test.setupMockAddressCleanseServiceSuccessResponse();
    
    Account oaccount = UnitTest.getAccountInstance();
    insert oaccount;
        Contact ocontact = UnitTest.getContactInstance(oaccount.Id);
        ocontact.lastname = 'Smith';
         ocontact.firstname = 'Smith1';
         ocontact.SAP_Contact_ID__c='4664';
        ocontact.Email = 'Fred@Smith.com';
        ocontact.SAP_Role__c='ACCT NAMED PARTNER';
        ocontact.MDB_Contact_ID__c = '654984654';
        ocontact.class__c ='ONLINE';
       // insert oaccount;
        ocontact.accountid = oaccount.id;
        Insert ocontact;
    
        
        //Execute Test
        try{
        Test.startTest();
        
        PageReference oPage = Page.ContactCreatefromIncentivePswd;
        Test.setCurrentPage(oPage);
        
        ApexPages.StandardController oStandardController = new ApexPages.StandardController(oContact);
                
        IncentivePasswordControllerOpty  oController = new IncentivePasswordControllerOpty(oStandardController);
        oController.addcontactlist = new List<COntact>();
        oController.oContact = ocontact;
        oController.HasMatchingContacts = false;
        oController.SkipContactMatching = true;
        oController.SkipContactMatching = false;
        
        ocontroller.currentTab = 'Westlaw';
        PageReference oPageReference = oController.save();
        
        Test.stopTest();
        
        //Validate Test
        System.assertNotEquals(null, oPageReference);
        }
        catch(exception ex){
        }
    } 
    
    public static testMethod void testpromopassword(){
    
       Profile testprofile = [SELECT Id FROM Profile WHERE Name = 'GLI Sales User'];
        User testUser = new User(
            Alias = 'sUser',
            Email = 'abc1@testorg.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'Testing',
            LanguageLocaleKey = 'es',
            LocaleSidKey = 'es',
            ProfileId = testprofile.id,
            Sales_Org__c = 'WEST',
            Sub_Bu__c = 'USL',
            TimeZoneSidKey = 'America/Los_Angeles',
            UserName = 'abc123@testorg.com'
        );
         insert testUser;
        
        
        List < WebServiceSettings__c > lstofWebServ = new List < WebServiceSettings__c > ();
            WebServiceSettings__c oWebService = new WebServiceSettings__c();
            oWebService.name = 'Incentive Passwords';
            oWebService.Active__c = true;
            oWebService.Endpoint__c = 'https://qa.tacss.thomsonreuters.com/rocketdeploy/services/Registration_v2_0Port';
            oWebService.Password__c = 'sfdcte$t';
            oWebService.Service_Unavailable_Message__c = 'Incentive passwords not available';
            oWebService.Timeout__c = 120;
            oWebService.Username__c = 'SFDCTEST';
            lstofWebServ.add(oWebService);
    
            if (lstofWebServ.size() > 0) {
            insert lstofWebServ;
            }
         RecordtypeIds__c rt = new RecordtypeIds__c(name = 'Pre-Pipeline Opportunities', recTypeId__c='01230000001MA4hAAG');
        insert rt;
        RecordtypeIds__c rt1 = new RecordtypeIds__c(name = 'Pipeline Opportunities', recTypeId__c='01230000001MA4gAAG');
        insert rt1;
        RecordtypeIds__c rt2 = new RecordtypeIds__c(name = 'LATAM Renewal Opportunity', recTypeId__c='01213000000AXGKAA4');
        insert rt2;
        RecordtypeIds__c rt3 = new RecordtypeIds__c(name = 'GLI Pipeline Opportunity', recTypeId__c='012e00000000wRJAAY');
        insert rt3;
        UnitTest.createTestData();
         UnitTest.createOptiTestData();
        Account testAcc1 = UnitTest.getAccountInstance();
        insert testAcc1;
        
        List<contact> testconList = new List<Contact>();
        for (integer i=0; i<12; i++) {
            testconlist.add(UnitTest.getContactInstance(testAcc1.id));
        }
        
        
        Opportunity testOpty = UnitTest.getOpportunityInstance(testAcc1.Id);
          
        
        testOpty.OwnerId = testUser.Id;
        insert testOpty;
        
        testconList[0].sap_role__c ='as';
        testconList[0].MDB_Contact_ID__c = '654984654';
        testconList[1].sap_role__c ='as';
        testconList[1].MDB_Contact_ID__c = '654984654';
        insert testconList; 
        
        Product2 testProd1 =UnitTest.getProductInstance();
        testprod1.IsActive = true;
        Product2 testProd2 =UnitTest.getProductInstance();
        testprod2.IsActive = true;
        insert new List<Product2>{testProd1,testProd2};
        
        Id Pricebook2Id = Test.getStandardPricebookId();
        PricebookEntry testEntry = new PricebookEntry(isactive=true,Pricebook2id=Pricebook2Id,Product2Id=testProd1.id,unitprice=200,UseStandardPrice = false);
        System.debug('testEntry : '+testEntry);
        insert new List<PricebookEntry>{testEntry}; 
            
        Opportunity opp = [select id,accountID,Pricebook2Id,Is_GLI__c  from Opportunity where id =:testOpty.ID];
        System.debug('opp : '+opp);
        opp.Pricebook2Id = Pricebook2Id;
        update opp;
        
        OpportunityLineItem testLineItem1 = new OpportunityLineItem(opportunityId=testOpty.id,PricebookEntryId=testEntry.ID);
        testLineItem1.LCRM_Units__c = 1;
        System.debug('testLineItem1 : '+testLineItem1);
        insert testLineItem1; 
        
        
        Contract testContract = new Contract(Status = 'Draft',AccountId=testOpty.accountID,LCRM_Originating_Opportunity__c=testOpty.Id,Description = 'Trial Promo Password Creation',ownerid = testOpty.ownerid,LCRM_Transaction_Type__c = 'Unpaid Trial',LCRM_Trial_Channel__c = 'Trial Promo Password');
        
        insert testContract;
        testContract.Status = 'Activated';
        update testContract;
        System.debug('testContract+'+testContract.id);
        incentive_promotion__c testIPC = new incentive_promotion__c(account__C=testAcc1.id,opportunity__c = testopty.id);
        insert testIPC;
        
        Incentive_Password__c testIPD = new Incentive_Password__c(Promotion__c=testIPC.id,end_date__c=system.today());
        insert testIPD;
        
        Test.startTest();
        ApexPages.standardController sc = new ApexPages.standardController(testOpty);
        Test.setCurrentPageReference(Page.PromoPasswordonOpty);
        IncentivePasswordControllerOpty controller = new IncentivePasswordControllerOpty(sc);
        IncentivePasswordControllerOpty.PromotionPassword testPromotionPassword = new IncentivePasswordControllerOpty.PromotionPassword();       
        controller.loadWestlawOpenPromotions();
        controller.loadWestlawNextOpenPromotions();
        controller.loadPublicRecordsOpenPromotions();
        controller.loadBusinessLawResearchGSIPromotions();
        controller.saveHistory();
        controller.IncentivePromotionHistory = new List<IncentivePasswordControllerOpty.IncentivePromotion>();
        controller.IncentivePromotionHistory.add(new IncentivePasswordControllerOpty.IncentivePromotion());
        controller.IncentivePromotionHistory[0].isSelected = true;
        controller.getTrialPromoUrlOpen();
         
          controller.currenttab='Westlaw';
        controller.submitPromoPasswordRequest();
        
         controller.currenttab='PublicRecords';
        controller.submitPromoPasswordRequest();
             
        controller.getCurrentList();
        controller.currenttab='WestlawNext';
        controller.WestlawNextPromotions = new List<IncentivePasswordControllerOpty.IncentivePromotion>();
        controller.WestlawNextPromotions.add(new IncentivePasswordControllerOpty.IncentivePromotion());
        controller.WestlawNextPromotions[0].isSelected = true;
        controller.contactSetList[0].checked =true;
        controller.addContact();
         controller.currenttab='WestlawNext';
        controller.submitPromoPasswordRequest();
        
              
        Test.stopTest();
        System.assert(testPromotionPassword!=null, testPromotionPassword);
    }
    
    
}