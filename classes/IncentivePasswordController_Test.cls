/**
======================================================================================================================
TEST CLASS NAME: IncentivePasswordController_Test
======================================================================================================================
PURPOSE:    Validates the functionality provided by the IncentivePasswordController class.

CHANGE HISTORY:
======================================================================================================================
  DATE                  NAME                           DESC

2017-03-31            Karthi                     Optimized the coverage as per JIRA STORY: PS0-1
2017-11-03            Harika Devi Kalidindi      CRM - 3257 Added testDetailTEControllerPromoPassword method for Code coverage
======================================================================================================================
*/
@istest //(seealldata=true)
public with sharing class IncentivePasswordController_Test {
    public static testMethod void testDetailController(){
        Test.starttest();
        Account testAcc1 = UnitTest.getAccountInstance();
        testAcc1.Billingcountry='US';
        insert testAcc1;
        System.debug('INSERTED ACCOUNT: '+testAcc1);
        List<contact> testconList = new List<Contact>();
        for (integer i=0; i<12; i++) {
            testconlist.add(UnitTest.getContactInstance(testAcc1.id));
        }
        
        testconList[0].sap_role__c ='as';
        insert testconList;
        
        incentive_promotion__c testIPC = new incentive_promotion__c(account__C=testAcc1.id);
        insert testIPC;
        
        Incentive_Password__c testIPD = new Incentive_Password__c(Promotion__c=testIPC.id,LCRM_Account__c=testAcc1.id,end_date__c=system.today());
        insert testIPD;
        

        ApexPages.standardController sc = new ApexPages.standardController(testAcc1);
         System.debug('ApexPages.standardController: '+sc);
        Test.setCurrentPageReference(Page.IncentivePassword);
        System.currentPageReference().getParameters().put('id', testAcc1.Id);
        
        IncentivePasswordController controller = new IncentivePasswordController(sc);
              
        controller.loadWestlawOpenPromotions();
        controller.loadWestlawNextOpenPromotions();
        controller.loadPublicRecordsOpenPromotions();
        controller.loadBusinessLawResearchGSIPromotions();
        controller.saveHistory();        
        controller.getUrlOpen();
        
        controller.getCurrentList();
        controller.currenttab='Westlaw';
        controller.contactSetList[0].checked =true;
        
        controller.WestlawPromotions = new List<IncentivePasswordController.IncentivePromotion>();
        controller.WestlawPromotions.add(new IncentivePasswordController.IncentivePromotion());
        controller.WestlawPromotions[0].isSelected = true;
        controller.WestlawGenericPasswords = 2;
        
        controller.BusinessLawResearchGSIPromotions = new List<IncentivePasswordController.IncentivePromotion>();
        controller.BusinessLawResearchGSIPromotions.add(new IncentivePasswordController.IncentivePromotion());
        controller.BusinessLawResearchGSIPromotions[0].isSelected = true;
        controller.GSIGenericPasswords = 2;
        
        controller.PublicRecordsPromotions = new List<IncentivePasswordController.IncentivePromotion>();
        controller.PublicRecordsPromotions.add(new IncentivePasswordController.IncentivePromotion());
        controller.PublicRecordsPromotions[0].isSelected = true;
        
        controller.WestlawNextPromotions = new List<IncentivePasswordController.IncentivePromotion>();
        controller.WestlawNextPromotions.add(new IncentivePasswordController.IncentivePromotion());
        controller.WestlawNextPromotions[0].isSelected = true;
        
        controller.addContact();
        controller.searchContact();
        controller.currenttab='WestlawNext';
        controller.addContact();
        controller.searchContact();
        controller.currenttab='PublicRecords';
        controller.addContact();
        controller.searchContact();
        
        controller.currentTab = 'Westlaw';
        controller.removeContact();
        controller.currentTab = 'WestlawNext';
        controller.removeContact();
        controller.currentTab = 'BusinessLawResearchGSI';
        controller.removeContact();
        controller.currentTab = 'PublicRecords';
        controller.removeContact();
        
        controller.SubmitWestlawRequest();
        controller.SubmitWestlawNextRequest();
        controller.SubmitPublicRecordsRequest();
        controller.SubmitBusinessLawResearchGSIRequest();
        
        IncentivePasswordController.contactSet testcontactSet = new IncentivePasswordController.contactSet();
        IncentivePasswordController.IncentivePromotion testIncentivePromotion = new IncentivePasswordController.IncentivePromotion();
        IncentivePasswordController.PromotionPassword testPromotionPassword = new IncentivePasswordController.PromotionPassword();
        Test.stoptest();
        
    }
  
  public static testMethod void testDetailControllerPromoPassword(){
        Account testAcc1 = UnitTest.getAccountInstance();
        testAcc1.Billingcountry='US';
        insert testAcc1;
        
        List<contact> testconList = new List<Contact>();
        for (integer i=0; i<12; i++) {
            testconlist.add(UnitTest.getContactInstance(testAcc1.id));
        }
        
        testconList[0].sap_role__c ='as';
        insert testconList;
        
        incentive_promotion__c testIPC = new incentive_promotion__c(account__C=testAcc1.id);
        insert testIPC;
        
        Incentive_Password__c testIPD = new Incentive_Password__c(Promotion__c=testIPC.id,LCRM_Account__c=testAcc1.id,end_date__c=system.today());
        insert testIPD;
        
        
        ApexPages.standardController sc = new ApexPages.standardController(testAcc1);
        Test.setCurrentPageReference(Page.PromoPassword);
        //Test.setCurrentPageReference(Page.IncentivePassword);
        System.currentPageReference().getParameters().put('id', testAcc1.Id);
        IncentivePasswordController controller = new IncentivePasswordController(sc);       
        //controller.loadWestlawOpenPromotions();
        controller.loadWestlawNextOpenPromotions();
        IncentivePasswordController.sendEmailcheck = false;
        controller.trialIndicator = false;
        //controller.loadPublicRecordsOpenPromotions();
        //controller.loadBusinessLawResearchGSIPromotions();
        controller.saveHistory();        
        //controller.getUrlOpen();
        controller.getPromoUrlOpen();
        
        controller.getCurrentList();
        controller.currenttab='Westlaw';
        controller.contactSetList[0].checked =true;
        
        controller.WestlawPromotions = new List<IncentivePasswordController.IncentivePromotion>();
        controller.WestlawPromotions.add(new IncentivePasswordController.IncentivePromotion());
        controller.WestlawPromotions[0].isSelected = true;
        controller.WestlawGenericPasswords = 2;
        
        controller.BusinessLawResearchGSIPromotions = new List<IncentivePasswordController.IncentivePromotion>();
        controller.BusinessLawResearchGSIPromotions.add(new IncentivePasswordController.IncentivePromotion());
        controller.BusinessLawResearchGSIPromotions[0].isSelected = true;
        controller.GSIGenericPasswords = 2;
        
        controller.PublicRecordsPromotions = new List<IncentivePasswordController.IncentivePromotion>();
        controller.PublicRecordsPromotions.add(new IncentivePasswordController.IncentivePromotion());
        controller.PublicRecordsPromotions[0].isSelected = true;
        
        controller.WestlawNextPromotions = new List<IncentivePasswordController.IncentivePromotion>();
        controller.WestlawNextPromotions.add(new IncentivePasswordController.IncentivePromotion());
        controller.WestlawNextPromotions[0].isSelected = true;
        
        controller.addContact();
        controller.searchContact();
        controller.currenttab='WestlawNext';        
        controller.addContact();
        controller.searchContact();
        controller.currenttab='PublicRecords';        
        controller.addContact();
        controller.searchContact();        
        controller.currentTab = 'Westlaw';        
        controller.removeContact();        
        controller.currentTab = 'WestlawNext';        
        controller.removeContact();        
        controller.currentTab = 'BusinessLawResearchGSI';        
        controller.removeContact();        
        controller.currentTab = 'PublicRecords';        
        controller.removeContact();
        
        //controller.SubmitWestlawRequest();
        //controller.SubmitWestlawNextRequest();
        controller.submitLCRMPromoPasswordRequest();
        System.debug('controller.submitLCRMPromoPasswordRequest()@@@ '+controller.submitLCRMPromoPasswordRequest());        
        //controller.SubmitPublicRecordsRequest();
        //controller.SubmitBusinessLawResearchGSIRequest();
        
        IncentivePasswordController.contactSet testcontactSet = new IncentivePasswordController.contactSet();
        IncentivePasswordController.IncentivePromotion testIncentivePromotion = new IncentivePasswordController.IncentivePromotion();
        IncentivePasswordController.PromotionPassword testPromotionPassword = new IncentivePasswordController.PromotionPassword();
        System.debug('testPromotionPassword@@@ '+testPromotionPassword);
        System.assert(testPromotionPassword!=null, testPromotionPassword);
      
        
    }
    //Created as a part of CRM - 3257  for  code coverage
   
   public static testMethod void testDetailTEControllerPromoPassword(){
    
      
        Account testAcc1 = UnitTest.getAccountInstance();
        testAcc1.Billingcountry='US';
        insert testAcc1;
                
        Training_Event__c testTE = new Training_Event__c(Training_Name__c=testAcc1.id);
        insert testTE;
        
        List<contact> testconList = new List<Contact>();
        for (integer i=0; i<12; i++) {
          testconlist.add(UnitTest.getContactInstance(testAcc1.id));
        }
        
        testconList[0].sap_role__c ='as';
        insert testconList;
        System.debug(testTE);
        System.assertEquals(testconList.size(),12);
        
        List<Training_Event_Contact__c> listTEContact = new List<Training_Event_Contact__c>();
        
        for(Contact con: testconList){
            Training_Event_Contact__c tec = new Training_Event_Contact__c();
            tec.Training_Event__c=testTE.id;
            tec.Contact_Name__c=con.id;
            listTEContact.add(tec);
        }
        insert listTEContact;
        
        System.assertEquals(listTEContact.size(),12);
        
        incentive_promotion__c testIPC = new incentive_promotion__c(Training_Event__c=testTE.id);
        insert testIPC;
        Incentive_Password__c testIPD = new Incentive_Password__c(Promotion__c=testIPC.id,LCRM_Training_Event__c =testTE.id,end_date__c=system.today());
        insert testIPD;
        System.assertEquals(testIPD.LCRM_Training_Event__c,testTE.id);
        ApexPages.standardController sc = new ApexPages.standardController(testTE);
        Test.setCurrentPageReference(Page.IncentivePassword);
        System.currentPageReference().getParameters().put('id', testTE.Id);
                
        IncentivePasswordController controller = new IncentivePasswordController(sc);       
        controller.loadWestlawOpenPromotions();
        controller.loadWestlawNextOpenPromotions();
        controller.loadPublicRecordsOpenPromotions();
        controller.loadBusinessLawResearchGSIPromotions();
        controller.saveHistory();        
        controller.getUrlOpen();
        
        controller.getCurrentList();
        controller.currenttab='WestlawNext'; 
        controller.contactSetList[0].checked =true;
        System.assertEquals(controller.contactSetList.size(),1);
    
        
        controller.WestlawPromotions = new List<IncentivePasswordController.IncentivePromotion>();
        controller.WestlawPromotions.add(new IncentivePasswordController.IncentivePromotion());
        controller.WestlawPromotions[0].isSelected = true;
        controller.WestlawGenericPasswords = 2;
        
        controller.BusinessLawResearchGSIPromotions = new List<IncentivePasswordController.IncentivePromotion>();
        controller.BusinessLawResearchGSIPromotions.add(new IncentivePasswordController.IncentivePromotion());
        controller.BusinessLawResearchGSIPromotions[0].isSelected = true;
        controller.GSIGenericPasswords = 2;
        
        controller.PublicRecordsPromotions = new List<IncentivePasswordController.IncentivePromotion>();
        controller.PublicRecordsPromotions.add(new IncentivePasswordController.IncentivePromotion());
        controller.PublicRecordsPromotions[0].isSelected = true;
        System.assertEquals(controller.PublicRecordsPromotions.size(),1);
        controller.WestlawNextPromotions = new List<IncentivePasswordController.IncentivePromotion>();
        controller.WestlawNextPromotions.add(new IncentivePasswordController.IncentivePromotion());
        controller.WestlawNextPromotions[0].isSelected = true;
        
        
        controller.addContact();
        controller.searchContact();
        controller.currenttab='WestlawNext';
        controller.addContact();
        controller.currentTab='Westlaw';
        controller.addContact();    
        controller.currentTab='PublicRecords';
        controller.addContact();
        controller.currentTab='BusinessLawResearchGSI';
        controller.addContact();
        controller.searchContact();
        controller.currenttab='PublicRecords';
        controller.addContact();
        controller.searchContact();
        controller.currentTab='Westlaw';
        controller.removeContact();
        controller.currentTab='WestlawNext';
        controller.removeContact();
        controller.currentTab='PublicRecords';
        controller.removeContact();
        controller.currentTab='BusinessLawResearchGSI';
        controller.removeContact();
        controller.submitLCRMPromoPasswordRequest();
        controller.SubmitWestlawRequest();
        controller.SubmitWestlawNextRequest();
        controller.SubmitPublicRecordsRequest();
        controller.SubmitBusinessLawResearchGSIRequest();
       // controller.requestOpenPromotions('WESTLAW','WEST','WESTLAW-WEB');
        
        
        
        IncentivePasswordController.contactSet testcontactSet = new IncentivePasswordController.contactSet();
        IncentivePasswordController.IncentivePromotion testIncentivePromotion = new IncentivePasswordController.IncentivePromotion();
        IncentivePasswordController.PromotionPassword testPromotionPassword = new IncentivePasswordController.PromotionPassword();
        System.assert(testPromotionPassword!=null, testPromotionPassword);
        
    }
}