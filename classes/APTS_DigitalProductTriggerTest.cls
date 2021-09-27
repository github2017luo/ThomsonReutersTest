/**
 * Test class for testing the APTS_DigitalProductTriggerHelper and APTS_DigitalProductTriggerHandler classes.
 * These are the support classes for the Digital Subscriptions trigger.  
 */
/**
 * CHANGE HISTORY
 * =============================================================================
 * Date         Name                    Description
 * 2020-08-06   Brenda Shields          DLT-20508 Updated for new functionality test 
 * 2021-04-01   Brenda shields          DLT-21575 - Update logic to correctly set OCC and associated fields
 * =============================================================================
 */
/**
 * @description : Test class for the APTS_DigitalProductTriggerHelper and APTS_DigitalProductTriggerHandler classes
 */ 
@isTest
private class APTS_DigitalProductTriggerTest {

    @testSetup
    static void setup(){
    	
        Account acct = new Account(Name='Digital Test Account', SAPAccountNumber__c = '1234567890');
        insert acct;
        Product2 prd = DCTestData.createProduct('Test Product','12345','67890');
        system.debug(logginglevel.INFO, 'Products : ' + prd);
        Source_System_Detail__c acctssd = DCTestData.createSourceSystemDetail(acct);
        // create contact and ssd contact
        Contact oContact = DCTestData.createContactRec('Testcontact', acct.Id);
        insert oContact;
        LCRM_Contact_SSD__c oSSDContact = DCTestData.createContactSSD(oContact, acctssd);
        oSSDContact.LCRM_Source_Contact_Id__c = '1234567890';
        update oSSDContact;
    }

    @isTest
    static void insertDigitalSubscription() {
    	
        Source_System_Detail__c acctssd = [SELECT id FROM Source_System_Detail__c WHERE Source_System_Account_Number__c = '1234567890'];
        Product_Account_Detail__c pad = new Product_Account_Detail__c();
        pad.ZP_Cust_Number__c = '1234567890';
        pad.Actual_New_Service__c = '12345'; // match with Product1 product code
        pad.Actual_New_Subscription__c = '67890';
        pad.SAP_Contact_Id__c = '1234567890';
        
        Test.startTest();
        insert pad;
        Test.stopTest();
        
        pad = [SELECT id, AccountSSD__c, Actual_New_Subscription_Product__c FROM Product_Account_Detail__c WHERE ZP_Cust_Number__c = '1234567890' LIMIT 1];
        System.assertEquals(acctssd.id, pad.AccountSSD__c, 'Source System Detail:'+pad.AccountSSD__c);
    }

    @isTest
    static void digitalSubscriptionBundleProductTest() {
    	
        Source_System_Detail__c acctssd = [SELECT id FROM Source_System_Detail__c WHERE Source_System_Account_Number__c = '1234567890'];
        //Product2 prd = [SELECT id FROM Product2 WHERE Name = 'Test Product'];
        Product_Account_Detail__c pad = new Product_Account_Detail__c();
        pad.ZP_Cust_Number__c = '1234567890';
        pad.Bundle_product_Name__C = 'Test Product2';
        //pad.Premium_New_Service__c = '12345';
                
        Test.startTest();
        insert pad;
        Test.stopTest();
       
        pad = [SELECT id, AccountSSD__c, Actual_New_Subscription_Product__c,Premium_New_Service__c, Premium_New_Subscription__c FROM Product_Account_Detail__c WHERE ZP_Cust_Number__c = '1234567890' LIMIT 1];
        System.assertEquals(acctssd.id, pad.AccountSSD__c, 'Source System Detail:'+pad.AccountSSD__c);
        //System.assertEquals(prd.id,pad.Actual_New_Subscription_Product__c,'Actual New Subscription Product:'+pad.Actual_New_Subscription_Product__c);
    }
    
    @isTest
    static void updateDigitalSubscription() {
    	
        Source_System_Detail__c acctssd = [SELECT id FROM Source_System_Detail__c WHERE Source_System_Account_Number__c = '1234567890'];
        Product_Account_Detail__c pad = new Product_Account_Detail__c();
        pad.ZP_Cust_Number__c = '1234567890';
        insert pad;
        pad = [SELECT id, AccountSSD__c, Actual_New_Subscription_Product__c,Premium_New_Service__c, Premium_New_Subscription__c FROM Product_Account_Detail__c WHERE ZP_Cust_Number__c = '1234567890' LIMIT 1];
        pad.Premium_New_Service__c = '12345';
        pad.Premium_New_Subscription__c = '67890';

        Test.startTest();
        update pad;
        Test.stopTest();   
        
        pad = [SELECT id, AccountSSD__c, Actual_New_Subscription_Product__c,Premium_New_Service__c, Premium_New_Subscription__c FROM Product_Account_Detail__c WHERE ZP_Cust_Number__c = '1234567890' LIMIT 1];
        System.assertEquals(acctssd.id, pad.AccountSSD__c, 'Source System Detail:'+pad.AccountSSD__c);
    }
    
    @isTest
    static void bypassDigitalSubscription() {
		
		// create Digital Subscription with no matching SSD Account
		Product_Account_Detail__c pad = new Product_Account_Detail__c();
        pad.ZP_Cust_Number__c = 'XYZ4567890';
        pad.Actual_New_Service__c = '12345'; // match with Product1 product code
        pad.Actual_New_Subscription__c = '67890';
        
        Test.startTest();
        insert pad;
        Test.stopTest();
        
        pad = [SELECT id, Bypass_Automation__c FROM Product_Account_Detail__c WHERE ZP_Cust_Number__c = 'XYZ4567890' LIMIT 1];
        System.assertEquals(pad.Bypass_Automation__c, true, 'Source System Detail:' + pad.Bypass_Automation__c);
    }
    
}