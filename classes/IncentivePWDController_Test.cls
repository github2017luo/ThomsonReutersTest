@istest(seeAllData=True)

public with sharing class IncentivePWDController_Test {

    public static testMethod void testIncentivePWDController(){
    
      
        Account testAcc1 = UnitTest.getAccountInstance();
        insert testAcc1;
        
        Training_Event__c testTE = new Training_Event__c(Training_Name__c=testAcc1.id);
        insert testTE;
        
        List<contact> testconList = new List<Contact>();
        for (integer i=0; i<3; i++) {
          testconlist.add(UnitTest.getContactInstance(testAcc1.id));
        }
        
        testconList[0].sap_role__c ='as';
        insert testconList;
        
        List<Training_Event_Contact__c> listTEContact = new List<Training_Event_Contact__c>();
        
        for(Contact con: testconList){
            Training_Event_Contact__c tec = new Training_Event_Contact__c();
            tec.Training_Event__c=testTE.id;
            tec.Contact_Name__c=con.id;
            listTEContact.add(tec);
        }
        insert listTEContact;
        
        
        incentive_promotion__c testIPC = new incentive_promotion__c(Training_Event__c=testTE.id);
        insert testIPC;
        Incentive_Password__c testIPD = new Incentive_Password__c(Promotion__c=testIPC.id,end_date__c=system.today());
        insert testIPD;
        ApexPages.standardController sc = new ApexPages.standardController(testTE);
        Test.startTest();
        Test.setCurrentPageReference(Page.IncentivePassword);
        IncentivePWDController controller = new IncentivePWDController(sc);       
        controller.loadWestlawOpenPromotions();
        controller.loadWestlawNextOpenPromotions();
        controller.loadPublicRecordsOpenPromotions();
        controller.loadBusinessLawResearchGSIPromotions();
        controller.saveHistory();        
        controller.getUrlOpen();
        
        controller.getCurrentList();
        controller.currenttab='WestlawNext'; 
        controller.contactSetList[0].checked =true;
        
    
        
        controller.WestlawPromotions = new List<IncentivePWDController.IncentivePromotion>();
        controller.WestlawPromotions.add(new IncentivePWDController.IncentivePromotion());
        controller.WestlawPromotions[0].isSelected = true;
        controller.WestlawGenericPasswords = 2;
        
        controller.BusinessLawResearchGSIPromotions = new List<IncentivePWDController.IncentivePromotion>();
        controller.BusinessLawResearchGSIPromotions.add(new IncentivePWDController.IncentivePromotion());
        controller.BusinessLawResearchGSIPromotions[0].isSelected = true;
        controller.GSIGenericPasswords = 2;
        
        controller.PublicRecordsPromotions = new List<IncentivePWDController.IncentivePromotion>();
        controller.PublicRecordsPromotions.add(new IncentivePWDController.IncentivePromotion());
        controller.PublicRecordsPromotions[0].isSelected = true;
        
        controller.WestlawNextPromotions = new List<IncentivePWDController.IncentivePromotion>();
        controller.WestlawNextPromotions.add(new IncentivePWDController.IncentivePromotion());
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
        controller.SubmitWestlawRequest();
        controller.SubmitWestlawNextRequest();
        controller.SubmitPublicRecordsRequest();
        controller.SubmitBusinessLawResearchGSIRequest();
       // controller.requestOpenPromotions('WESTLAW','WEST','WESTLAW-WEB');
        
        
        
        IncentivePWDController.contactSet testcontactSet = new IncentivePWDController.contactSet();
        IncentivePWDController.IncentivePromotion testIncentivePromotion = new IncentivePWDController.IncentivePromotion();
        IncentivePWDController.PromotionPassword testPromotionPassword = new IncentivePWDController.PromotionPassword();
        Test.stopTest();
    }
}