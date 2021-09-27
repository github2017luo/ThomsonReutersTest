/**
* Class Description :Created as part of CRM -4943,ESD-1562 to  Restrict visiblity of Do Not Call,Do Not Mail,Do Not Pay a Visit fields to only accounts  where country equal to United States
                      and to enable edit button for only users having Edit access to those fields 
   Main Class : LCRMAccountMarketingPrefController                    
* CHANGE HISTORY
* =============================================================================
* Date         Name                    Description
* 2018-04-20   Harika Kalidindi        Created
* =============================================================================
*/ 

@isTest
public class LCRMAccountMarketingPrefController_Test {
    @isTest
    public static Void testAccounteditWithSystemAdmin(){
        User u = TestData.createTestUser();
        
        system.runAs(u){
        List<Account> lstaccinsert = new List<Account>();
        Account acct=new Account();
        acct.Name = 'Acme';
        acct.Do_Not_Call__c=true;
        acct.Do_Not_Mail__c=true;
        acct.Do_Not_Pay_a_Visit__c=true;
        acct.BillingCountry='US';
        lstaccinsert.add(acct);
        
               
        Account acct1=UnitTest.getAccountInstance();
        acct1.Name = 'Acme1';
        acct1.BillingCountry='IN';
        lstaccinsert.add(acct1);
        
        insert lstaccinsert;
        
        List<Account> lstacc = [Select Id,Name,BillingCountry from Account limit 2 ];
        if(lstacc[0].Name == 'Acme')
        {
            System.assertEquals('US',lstacc[0].BillingCountry);
            System.assertEquals('IN',lstacc[1].BillingCountry);
        }
        else 
        {
        System.assertEquals('US',lstacc[1].BillingCountry);
            System.assertEquals('IN',lstacc[0].BillingCountry);
        }
        
        test.startTest();
        PageReference accountPage = Page.LCRMAccountMarketingPreferencesSection;
        Test.setCurrentPage(accountPage);
        system.assertEquals(true, accountPage!=null);
            
        ApexPages.StandardController oStandardController = new ApexPages.StandardController(acct);
        LCRMAccountMarketingPrefController controller = new LCRMAccountMarketingPrefController(oStandardController);
        
        controller.changeToEdit();
        controller.save();
        controller.cancel();
        System.assertEquals(controller.isCountryUS,true);
        System.assertEquals(controller.CheckPermission,true);
        
        ApexPages.StandardController oStdController = new ApexPages.StandardController(acct1);
        LCRMAccountMarketingPrefController accmarketingcontroller = new LCRMAccountMarketingPrefController(oStdController);
        System.assertEquals(accmarketingcontroller.isCountryUS,false);
        System.assertEquals(accmarketingcontroller.CheckPermission,true);
        test.stopTest();
        }
    }
    
    @isTest
    public static Void testAccounteditWithGliSalesUser(){
       Profile p = [SELECT Id FROM Profile WHERE Name='USL Helpdesk Manager'];
        
        User ouser = UnitTest.getUserInstance();
        ouser .Username = 'testuser@trpcorelegal.com';
        ouser .profileid = p.Id;
        ouser .Sub_Bu__c = 'USL';
        insert ouser ;
        
        system.runAs(ouser){
        
        List<Account> lstaccinsert = new List<Account>();
        Account acct=new Account();
        acct.Name = 'Acme';
        acct.Do_Not_Call__c=true;
        acct.Do_Not_Mail__c=true;
        acct.Do_Not_Pay_a_Visit__c=true;
        acct.BillingCountry='US';
        lstaccinsert.add(acct);
        
               
        Account acct1=UnitTest.getAccountInstance();
        acct1.Name = 'Acme1';
        acct1.BillingCountry='IN';
        lstaccinsert.add(acct1);
        
        insert lstaccinsert;
        
        List<Account> lstacc = [Select Id,Name,BillingCountry from Account limit 2 ];
        if(lstacc[0].Name == 'Acme')
        {
            System.assertEquals('US',lstacc[0].BillingCountry);
            System.assertEquals('IN',lstacc[1].BillingCountry);
        }
        else 
        {
        System.assertEquals('US',lstacc[1].BillingCountry);
            System.assertEquals('IN',lstacc[0].BillingCountry);
        }
        
               
        
        test.startTest();
        PageReference accountPage = Page.LCRMAccountMarketingPreferencesSection;
        Test.setCurrentPage(accountPage);
        system.assertEquals(true, accountPage!=null);
            
        ApexPages.StandardController oStandardController = new ApexPages.StandardController(acct);
        LCRMAccountMarketingPrefController   controller = new LCRMAccountMarketingPrefController(oStandardController);
       // System.assertEquals(controller.isCountryUS,false);
        //System.assertEquals(controller.CheckPermission,false);
        
        
        controller.changeToEdit();
        controller.save();
        controller.cancel();
        
        
        ApexPages.StandardController oStdController = new ApexPages.StandardController(acct1);
        LCRMAccountMarketingPrefController  accmarketingcontroller = new LCRMAccountMarketingPrefController(oStdController);
       // System.assertEquals(accmarketingcontroller.isCountryUS,false);
        //System.assertEquals(accmarketingcontroller.CheckPermission,false);
        
        test.stopTest();
        }
    }

}