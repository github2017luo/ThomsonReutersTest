/**
 * Test class for testing the Digital_DS_Mass_Update_Controller class.  That class is a button on the 
 * DS list view that will allow support to bulk update the bypass automation flag  
 */
/**
 * CHANGE HISTORY
 * =============================================================================
 * Date         Name                    Description
 * 2020-07317   Brenda Shields          Created 
 * =============================================================================
 */
@isTest
public with sharing class Digital_DS_Mass_Update_Controller_Test {
 
    public static String acctid;
    public static String acctssdid;
    
    @testSetup static void init() {
    	test.starttest();
        DCTestData.createData(); 
        test.stoptest();

        acctid = DCTestData.accountId;
        acctssdid = DCTestData.accssdid;
        
        list<Product_Account_Detail__c> prodactdetailList = new list<Product_Account_Detail__c>();
        // created over 20 DS records
        for (Integer i = 0; i < 26; i++) {
	        Product_Account_Detail__c prodactdetail1 = new Product_Account_Detail__c();
	        prodactdetail1.ZP_Cust_Number__c = '1004284494';
        	prodactdetail1.Account__c = acctid;
        	prodactdetail1.AccountSSD__c = acctssdid;
        	prodactdetail1.Actual_New_Service__c = '42004986';  
        	prodactdetail1.Actual_New_Subscription__c = '42004988';
        	prodactdetail1.campaign_code__c = '00237KI';
        	prodactdetail1.Quantity__c = 1;
        	prodactdetail1.Offer_Price__c = -5;
        	prodactdetail1.Type__c ='Config';
        	prodactdetail1.Renewal_Date__c = System.Today().addDays(60);	
        	if (i < 5) {
        		prodactdetail1.Bypass_Automation__c = true;
        	}
        	prodactdetailList.add(prodactdetail1); 
        }
        insert prodactdetailList; 
     }


    @isTest static void testUpdateDSRecords() {
       
        Test.startTest();       
        list<Product_Account_Detail__c> listDSRecords = [Select id, name from Product_Account_Detail__c]; 

        PageReference pageRef = Page.Digital_DS_Mass_Update;
        Test.setCurrentPage(pageRef);        
        ApexPages.StandardSetController con = new ApexPages.StandardSetController(listDSRecords);
        Digital_DS_Mass_Update_Controller conBulk = new Digital_DS_Mass_Update_Controller(con); 
        PageReference pg = conBulk.updateDSRecords();
        Product_Account_Detail__c dsRec = [Select id, Bypass_Automation__c from Product_Account_Detail__c limit 1];
        System.AssertEquals(true, dsRec.Bypass_Automation__c, true);
        Test.stopTest();
    }
    
     
    @isTest static void testMarkBypassing() {
       
        Test.startTest();       
        list<Product_Account_Detail__c> listDSRecords = [Select id, name from Product_Account_Detail__c]; 

        PageReference pageRef = Page.Digital_DS_Mass_Update;
        Test.setCurrentPage(pageRef);        
        ApexPages.StandardSetController con = new ApexPages.StandardSetController(listDSRecords);
        Digital_DS_Mass_Update_Controller conBulk = new Digital_DS_Mass_Update_Controller(con); 
        PageReference pg = conBulk.updateToBypass();
        Product_Account_Detail__c dsRec = [Select id, Bypass_Automation__c from Product_Account_Detail__c limit 1];
        System.AssertEquals(true, dsRec.Bypass_Automation__c, true);
        Test.stopTest();
    }
    
    
     @isTest static void testUnMarkBypassing() {
       
        Test.startTest();       
        list<Product_Account_Detail__c> listDSRecords = [Select id, name from Product_Account_Detail__c]; 

        PageReference pageRef = Page.Digital_DS_Mass_Update;
        Test.setCurrentPage(pageRef);        
        ApexPages.StandardSetController con = new ApexPages.StandardSetController(listDSRecords);
        Digital_DS_Mass_Update_Controller conBulk = new Digital_DS_Mass_Update_Controller(con); 
        PageReference pg = conBulk.updateToUnBypass();
        Product_Account_Detail__c dsRec = [Select id, Bypass_Automation__c from Product_Account_Detail__c limit 1];
        System.AssertEquals(false, dsRec.Bypass_Automation__c, true);
        Test.stopTest();
    }  
    
    
	@isTest static void testNoRecords() {
       
        Test.startTest();       
        list<Product_Account_Detail__c> listDSRecords = new list<Product_Account_Detail__c>(); 

        PageReference pageRef = Page.Digital_DS_Mass_Update;
        Test.setCurrentPage(pageRef);        
        ApexPages.StandardSetController con = new ApexPages.StandardSetController(listDSRecords);
        Digital_DS_Mass_Update_Controller conBulk = new Digital_DS_Mass_Update_Controller(con); 
        PageReference pg = conBulk.updateDSRecords();
        PageReference pg1 = conBulk.returnToDSView();
        Product_Account_Detail__c dsRec = [Select id, Bypass_Automation__c from Product_Account_Detail__c where Bypass_Automation__c = false limit 1];
        System.AssertEquals(false, dsRec.Bypass_Automation__c, true);
        Test.stopTest();
    }
    
    
}