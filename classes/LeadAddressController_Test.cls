@isTest//(SeeAllData=true)
public class LeadAddressController_Test{
    private static testmethod void method1(){
        Test.startTest();
        Lead oLead = UnitTest.getLeadInstance();
        insert oLead;
        ApexPages.StandardController oTestController = new ApexPages.StandardController(oLead);
        LeadAddressController oController = new LeadAddressController(oTestController);
        Test.setcurrentPage(page.LeadAddress);
        ApexPages.currentPage().getParameters().put('id',oLead.Id);
        oController.addressCountryChanged();
        oController.edit();
        oController.save();
        oController.continueSave();
        oController.cancel();
        system.assertEquals( oLead.Id == oLead.Id, true);
        
/*
        
        oLead.Billing_Street__c = 'Test Street 123Test Street 123Test Street 123Test Street 123';
        update oLead;
        oController.save();
        
        oLead.Billing_Street__c = 'Test Street 123';
        oLead.Billing_City__c = 'TestCity TestCity TestCity TestCity TestCity TestCity TestCity TestCity TestCity';
        update oLead;
        oController.save();
         oLead.Billing_City__c = 'TestCity';
          oLead.Billing_Zip__c = '012345678901234';
        update oLead;
         oController.save();
*/
        Test.stopTest();
    }

    private static testmethod void method2(){
        Test.startTest();
        Lead oLead = UnitTest.getLeadInstance();
        insert oLead;
        ApexPages.StandardController oTestController = new ApexPages.StandardController(oLead);
        LeadAddressController oController = new LeadAddressController(oTestController);
        Test.setcurrentPage(page.LeadAddress);
        ApexPages.currentPage().getParameters().put('id',oLead.Id);
        
        oLead.Billing_Street__c = 'Test Street 123Test Street 123Test Street 123Test Street 123';
        system.assertEquals( oLead.Billing_Street__c == 'Test Street 123Test Street 123Test Street 123Test Street 123', true);
        update oLead;
        oController.save();
        
        Test.stopTest();
    }

    private static testmethod void method3(){
        Test.startTest();
        Lead oLead = UnitTest.getLeadInstance();
        insert oLead;
        ApexPages.StandardController oTestController = new ApexPages.StandardController(oLead);
        LeadAddressController oController = new LeadAddressController(oTestController);
        Test.setcurrentPage(page.LeadAddress);
        ApexPages.currentPage().getParameters().put('id',oLead.Id);
        
        oLead.Billing_Street__c = 'Test Street 123Test Street 123Test Street 123Test Street 123';
        update oLead;
        oController.save();
        
        oLead.Billing_Street__c = 'Test Street 123';
        oLead.Billing_City__c = 'TestCity TestCity TestCity TestCity TestCity TestCity TestCity TestCity TestCity';
        system.assertEquals( oLead.Billing_City__c == 'TestCity TestCity TestCity TestCity TestCity TestCity TestCity TestCity TestCity', true);
        update oLead;
        oController.save();
        
        Test.stopTest();
    }

    private static testmethod void method4(){
        Test.startTest();
        Lead oLead = UnitTest.getLeadInstance();
        insert oLead;
        ApexPages.StandardController oTestController = new ApexPages.StandardController(oLead);
        LeadAddressController oController = new LeadAddressController(oTestController);
        Test.setcurrentPage(page.LeadAddress);
        ApexPages.currentPage().getParameters().put('id',oLead.Id);
        
        oLead.Billing_Street__c = 'Test Street 123';
        oLead.Billing_City__c = 'TestCity TestCity TestCity TestCity TestCity TestCity TestCity TestCity TestCity';
        update oLead;
        oController.save();
        
         oLead.Billing_City__c = 'TestCity';
         oLead.Billing_Zip__c = '012345678901234';
         system.assertEquals( oLead.Billing_Zip__c == '012345678901234', true);
          update oLead;
        oController.save();
        oController.oLead.Billing_Street__c = 'Test Street 123123456789012345678901234567890123456';
        oController.save();
        oController.oLead.Billing_Street__c = 'Test Street 123';
        oController.oLead.Billing_City__c = 'TestCity1234567890123456789012345678901234567890';
        oController.save();
        oController.oLead.Billing_City__c = 'TestCity';
        oController.oLead.Billing_Zip__c = '012345678901234';
        oController.save();
        Test.stopTest();
    }

}