/*
 * Modified by Bharat Bhushan on 6th Aug 2018
 * DLT-11509 - [TECH STORY] SAP Contact ID field to modify as per GLI to be replace with Source Contact ID]
 *
 *   2019-10-09   Brenda Shields  DLT-17732 - Fix Too many SOQL 5001 Error - Update test class for PMD violations   
 */
@istest 
public class Digital_BestProposalAutomation_Test {     
    public static String opp1id;
    public static String acctId;
    public static String acctSSDId;
    public static String pboookid;
    public static String cQuoteID;
    
    @testsetUp static void setupData() {     
        //To fix the test class error from UpdateMultiListAccountTier
        WebServiceSettings__c web = new WebServiceSettings__c();
        web.Endpoint__c = 'https://thomsonreutersglis2e--merge.cs19.my.salesforce.com/servlet/servlet.ExternalRedirect?url=https%3A%2F%2Fqa.securepayment.thomsonreuters.com%2FTRPaymentGateway%2FBilling%2FInvoiceSummary%2FTRPaymentAutoCharge';
        web.Name = 'Payment AutoCharge';
        web.Username__c = 'test.user';
        web.Password__c = 'test:123';
        web.Service_Unavailable_Message__c = 'testservice';
        insert web;
        
        DCTestData.createPaymentCreditWebService();
        //Ends 
    }
    
    public static testmethod void bestProposalAutomationTest1() {
        Account acct = CreateacctCommonCode('1');        
        
        test.starttest();
        Digital_BestProposalAutomation dbp = new Digital_BestProposalAutomation();
        DataBase.executeBatch(dbp);
        test.stoptest();

        Apttus_Proposal__Proposal__c propos = [SELECT Id,Name,Digital_Quote_Type__c  FROM Apttus_Proposal__Proposal__c  where Apttus_Proposal__Opportunity__c = :opp1id AND Digital_Quote_Type__c!= 'Straight Renewal' limit 1];
        System.assertEquals(propos.Digital_Quote_Type__c ,'Best Value'); 
    }
     
    public static testmethod void bestProposalAutomationTestmakeEx2() {
        Account acct = CreateacctCommonCode('4');
            
        List<DC_Contract_Term_V2__mdt> fullContractTerms = [select Customer_Category__c,Default_Customer_Category__c,Markup_Percentage__c,YoY_1_Renewal__c,DC_Years_2_Plus_Adjustment__c,Contract_Term__c,Quote_Type__c From DC_Contract_Term_V2__mdt Limit 100];
        
        test.starttest();
        Digital_BestProposalAutomation dbp = new Digital_BestProposalAutomation();
        DataBase.executeBatch(dbp);
        test.stoptest();
        
        Apttus_Proposal__Proposal__c propos = [SELECT Id,Name,Digital_Quote_Type__c  FROM Apttus_Proposal__Proposal__c  where Apttus_Proposal__Opportunity__c = :opp1id AND Digital_Quote_Type__c!= 'Straight Renewal' limit 1];
        System.assertEquals(propos.Digital_Quote_Type__c ,'Best Value'); 
    }
     
    public static testmethod void premiumProposalAutomationTestExCamCode() {
        Account acct = CreateacctCommonCode('1');
             
        list<Product_Account_Detail__c> dSubscriptionsList =  new list<Product_Account_Detail__c>();
        for (Product_Account_Detail__c digitalSubscriptionsList : [SELECT Account__c,Campaign_Code__c,Quantity__c,Actual_New_Service__c,Actual_New_Subscription_Product__c,Current_Subscription__c,Premium_New_Subscription__c FROM Product_Account_Detail__c where Current_Subscription__c != Null AND Campaign_Code__c != Null ]) {
            if (digitalSubscriptionsList != null) {
                 digitalSubscriptionsList.Campaign_Code__c = null;
                 dSubscriptionsList.add(digitalSubscriptionsList);
            }
        }
        update dSubscriptionsList;
        
        test.starttest();
        Digital_ProposalAutomation dbp = new Digital_ProposalAutomation();
        DataBase.executeBatch(dbp);
        Digital_BestProposalAutomation.createExceptionLog('','','');
        

        Apttus_Proposal__Proposal__c propos = [SELECT Id,Name,Digital_Quote_Type__c  FROM Apttus_Proposal__Proposal__c  where Apttus_Proposal__Opportunity__c = :opp1id limit 1];
        System.assertEquals(propos.Digital_Quote_Type__c ,'Straight Renewal'); 
		test.stoptest();
    }
     
   /* Public static testmethod void BestProposalAutomationTest2(){
     Account Acc = CreateacctCommonCode('2');
        Acc.APTS_eOutput_Eligibilty__c = '';
        acc.APTS_Band_Number__c = 2 ;
        acc.APTS_Customer_Category__c = '2';
        update Acc;
        Source_System_Detail__c ssd = [Select id, LCRM_APTS_Band_Number__c, APTS_Customer_Category__c, LCRM_eOutput_Eligibility__c from Source_System_Detail__c where Account_Name__c =: acc.id limit 1];
        ssd.LCRM_APTS_Band_Number__c = 2;
        ssd.APTS_Customer_Category__c = '7';
        ssd.LCRM_eOutput_Eligibility__c = '';
        update ssd;
         list<Product_Account_Detail__c> dSubscriptionsList =  new list<Product_Account_Detail__c>();
        for(Product_Account_Detail__c digitalSubscriptionsList : [SELECT Account__c,Campaign_Code__c,Quantity__c,Actual_New_Service__c,Actual_New_Subscription_Product__c,Current_Subscription__c,Premium_New_Subscription__c FROM Product_Account_Detail__c where Current_Subscription__c != Null AND Campaign_Code__c != Null AND ZP_Cust_Number__c=: Acc.SAPAccountNumber__c]){
            if(digitalSubscriptionsList !=null){
                 digitalSubscriptionsList.Quantity__c = 2;
                digitalSubscriptionsList.Offer_Price__c = -5;
                 dSubscriptionsList.add(digitalSubscriptionsList);
            }
           
        }
        update dSubscriptionsList;
        test.starttest();
        List<LCRM_Contact_SSD__c> listContact  = [select id,name,LCRM_SAP_Role__c from LCRM_Contact_SSD__c where LCRM_SAP_Role__c != NULL limit 7];
        
        
        Digital_BestProposalAutomation dbp = new Digital_BestProposalAutomation();
        DataBase.executeBatch(dbp);

        
        Apttus_Proposal__Proposal__c propos = [SELECT Id,Name,Digital_Quote_Type__c  FROM Apttus_Proposal__Proposal__c  where Apttus_Proposal__Opportunity__c = :opp1id AND Digital_Quote_Type__c!= 'Straight Renewal' limit 1];
        
        test.stoptest();
        //System.assertEquals(propos.Digital_Quote_Type__c ,'Best Value'); 
    
    } */

    public static testmethod void bestProposalAutomationTest3() {
        
        Account acct = CreateacctCommonCode('3');        
        List<LCRM_Contact_SSD__c> listContact  = [select id,name,LCRM_SAP_Role__c from LCRM_Contact_SSD__c where LCRM_SAP_Role__c='EML ORDER CONFIRM' limit 1];
        if (listContact !=null && listContact.size() > 0) {
            listContact[0].LCRM_SAP_Role__c = null;
        }
        update listContact;
        
        test.starttest();
        Digital_BestProposalAutomation dbp = new Digital_BestProposalAutomation();
        DataBase.executeBatch(dbp);
        test.stoptest();
        
        Apttus_Proposal__Proposal__c propos = [SELECT Id,Name,Digital_Quote_Type__c  FROM Apttus_Proposal__Proposal__c  where Apttus_Proposal__Opportunity__c = :opp1id AND Digital_Quote_Type__c!= 'Straight Renewal' limit 1];
        System.assertEquals(propos.Digital_Quote_Type__c ,'Best Value'); 
    }
    
    public static testmethod void bestProposalAutomationTest4() {
        
        Account acct = CreateacctCommonCode('3');        
        List<LCRM_Contact_SSD__c> listContact  = [select id,name,LCRM_SAP_Role__c from LCRM_Contact_SSD__c limit 1];
        if (listContact !=null && listContact.size() > 0) {
            listContact[0].LCRM_SAP_Role__c = 'WL PSWD ACTIVE';
        }
        update listContact;
        
        test.starttest();
        Digital_BestProposalAutomation dbp = new Digital_BestProposalAutomation();
        DataBase.executeBatch(dbp);
        test.stoptest();
        
        Apttus_Proposal__Proposal__c propos = [SELECT Id,Name,Digital_Quote_Type__c  FROM Apttus_Proposal__Proposal__c  where Apttus_Proposal__Opportunity__c = :opp1id AND Digital_Quote_Type__c!= 'Straight Renewal' limit 1];
        System.assertEquals(propos.Digital_Quote_Type__c ,'Best Value'); 
    }
    
    public static testmethod void bestProposalAutomationTest5() {
        Account acct = CreateacctCommonCode('3'); 
        Contact testcontact= UnitTest.getContactInstance(acct.Id);
        testcontact.LastName = 'testContact1';
        testcontact.FirstName = 'testContact1';
        testcontact.AccountId = acct.Id;
        testcontact.email = 'testfirst1.testlast@thomson.com';
        testcontact.Job_Function__c = 'Other';
        testcontact.SAP_Role__c = 'EML ORDER CONFIRM';
        insert testcontact;
        LCRM_Contact_SSD__c conSSD = new LCRM_Contact_SSD__c ();
        conSSD = DCTestData.createContactSSD(testcontact, DCTestData.accountSSDlst);
         
        test.starttest();
        Digital_BestProposalAutomation dbp = new Digital_BestProposalAutomation();
        DataBase.executeBatch(dbp);
        test.stoptest();
        
        Apttus_Proposal__Proposal__c propos = [SELECT Id,Name,Digital_Quote_Type__c  FROM Apttus_Proposal__Proposal__c  where Apttus_Proposal__Opportunity__c = :opp1id AND Digital_Quote_Type__c!= 'Straight Renewal' limit 1];
        System.assertEquals(propos.Digital_Quote_Type__c ,'Best Value'); 
    }    
 
    public static testmethod void premiumProposalAutomationTestOPCamCode() {
        Account acct = CreateacctCommonCode('6'); 
        list<Apttus_Config2__AssetLineItem__c>  opt11 = [ select id, APTS_Info_RenewalDate__c  from Apttus_Config2__AssetLineItem__c  LIMIT 5];
        /*for(Apttus_Config2__AssetLineItem__c opt1: opt11){
            opt1.APTS_Info_RenewalDate__c = System.Today().addDays(-90);
        }
        update opt11;
        Boolean bIsPending = true;*/
        
        test.starttest();
        Digital_BestProposalAutomation dbp = new Digital_BestProposalAutomation();
        DataBase.executeBatch(dbp);
        test.stoptest();
        
        Apttus_Proposal__Proposal__c propos = [SELECT Id,Name,Digital_Quote_Type__c  FROM Apttus_Proposal__Proposal__c  where Apttus_Proposal__Opportunity__c = :opp1id AND Digital_Quote_Type__c!= 'Straight Renewal' limit 1];
        System.assertEquals(propos.Digital_Quote_Type__c ,'Best Value'); 
    }  
    
    public static testmethod void bestProposalAutomationTest7() {
        Account acct = CreateacctCommonCode('4'); 
        Opportunity  opt1 = [ select id, Campaign_Code__c  from Opportunity  LIMIT 5];
        opt1.Campaign_Code__c = 'SOQL';
        update opt1;
                
        test.starttest();        
        Digital_BestProposalAutomation dbp = new Digital_BestProposalAutomation();
        DataBase.executeBatch(dbp);
        test.stoptest();
        
        Apttus_Proposal__Proposal__c propos = [SELECT Id,Name,Digital_Quote_Type__c  FROM Apttus_Proposal__Proposal__c  where Apttus_Proposal__Opportunity__c = :opp1id limit 1];
        System.assertEquals(propos.Digital_Quote_Type__c ,'Straight Renewal'); 
    }
    
    public static testmethod void premiumProposalAutomationTestdiffaccCon() {
        Account accy = CreateacctCommonCode('4'); 
        List<LCRM_Contact_SSD__c> listContact  = [select id,name,LCRM_SAP_Role__c from LCRM_Contact_SSD__c limit 1];
        if (listContact !=null && listContact.size() > 0) {
            listContact[0].LCRM_SAP_Role__c = 'EBILL EMAIL CONTACT';
            listContact[0].LCRM_Job_Function__c = 'Other';
        }
        update listContact;

        test.starttest();
        Digital_BestProposalAutomation dbp = new Digital_BestProposalAutomation();
        DataBase.executeBatch(dbp);
        test.stoptest();
        
        Apttus_Proposal__Proposal__c propos = [SELECT Id,Name,Digital_Quote_Type__c  FROM Apttus_Proposal__Proposal__c  where Apttus_Proposal__Opportunity__c = :opp1id AND Digital_Quote_Type__c!= 'Straight Renewal'limit 1];
        System.assertEquals(propos.Digital_Quote_Type__c ,'Best Value'); 
    }
      
    public static testmethod void premiumProposalAutomationTest72() {
        
		
        Account acct = CreateacctCommonCode('4');  
        acct.APTS_Band_Number__c = 2 ;
        update acct;
		test.starttest();
        List<LCRM_Contact_SSD__c> listContact  = [select id,name,LCRM_SAP_Role__c from LCRM_Contact_SSD__c Limit 2 ];
        if (listContact != null && listContact.size() > 0) {
            listContact[0].LCRM_SAP_Role__c = 'EBILL EMAIL CONTACT';
            listContact[0].LCRM_Job_Function__c = 'Attorney - Associate';
            listContact[0].LCRM_Account_SSD__c = DCTestData.accssdid;
        }
        update listContact;
        
        
        Digital_BestProposalAutomation dbp = new Digital_BestProposalAutomation();
        DataBase.executeBatch(dbp);
        test.stoptest();
        
        Apttus_Proposal__Proposal__c propos = [SELECT Id,Name,Digital_Quote_Type__c  FROM Apttus_Proposal__Proposal__c  where Apttus_Proposal__Opportunity__c = :opp1id AND Digital_Quote_Type__c!= 'Straight Renewal'limit 1];
        System.assertEquals(propos.Digital_Quote_Type__c ,'Best Value'); 
    }
    
    public static testmethod void premiumProposalAutomationTestconatct() {
        
		test.starttest();
		Account acct = CreateacctCommonCode('4');
        acct.APTS_Band_Number__c = 2 ;
        update acct;
		test.stoptest();
        List<LCRM_Contact_SSD__c> listContact  = [select id,name,LCRM_SAP_Role__c from LCRM_Contact_SSD__c limit 1];
        if (listContact != null && listContact.size() > 0) {
            listContact[0].LCRM_SAP_Role__c = 'SAP - 18 BILLING/ACCT PAYABLE';
            listContact[0].LCRM_Job_Function__c = 'Other';
        }
        update listContact;
        
        
        Digital_BestProposalAutomation dbp = new Digital_BestProposalAutomation();
        DataBase.executeBatch(dbp);
        
        
        Apttus_Proposal__Proposal__c propos = [SELECT Id,Name,Digital_Quote_Type__c  FROM Apttus_Proposal__Proposal__c  where Apttus_Proposal__Opportunity__c = :opp1id AND Digital_Quote_Type__c!= 'Straight Renewal' limit 1];
        System.assertEquals(propos.Digital_Quote_Type__c ,'Best Value'); 
    }  
    
    public static testmethod void premiumProposalAutomationTestconatctotherc() {
        
		test.starttest();
		Account acct = CreateacctCommonCode('6'); 
        acct.APTS_Band_Number__c = 2 ;
        update acct;
		test.stoptest();
        List<LCRM_Contact_SSD__c> listContact  = [select id,name,LCRM_SAP_Role__c from LCRM_Contact_SSD__c limit 1];
        if (listContact != null && listContact.size() > 0) {
            listContact[0].LCRM_SAP_Role__c = 'EML ORDER CONFIRM';
            listContact[0].LCRM_Job_Function__c = 'Other';
        }
        update listContact;
        
       
        Digital_BestProposalAutomation dbp = new Digital_BestProposalAutomation();
        DataBase.executeBatch(dbp);
        
        
        Apttus_Proposal__Proposal__c propos = [SELECT Id,Name,Digital_Quote_Type__c  FROM Apttus_Proposal__Proposal__c  where Apttus_Proposal__Opportunity__c = :opp1id AND Digital_Quote_Type__c!= 'Straight Renewal' limit 1];
        System.assertEquals(propos.Digital_Quote_Type__c ,'Best Value'); 
    }  
    
    public static testmethod void premiumProposalAutomationTestconatctother() {
        
		test.starttest();
		Account acct = CreateacctCommonCode('6'); 
        acct.APTS_Band_Number__c = 2 ;
        update acct;
		test.stoptest();
        List<LCRM_Contact_SSD__c> listContact  = [select id,name,LCRM_SAP_Role__c from LCRM_Contact_SSD__c limit 1];
        if (listContact != null && listContact.size() > 0) {
            listContact[0].LCRM_SAP_Role__c = 'Other';
            listContact[0].LCRM_Job_Function__c = 'Attorney - Associate';
        }
        update listContact;
        
       
        Digital_BestProposalAutomation dbp = new Digital_BestProposalAutomation();
        DataBase.executeBatch(dbp);
        
        
        Apttus_Proposal__Proposal__c propos = [SELECT Id,Name,Digital_Quote_Type__c  FROM Apttus_Proposal__Proposal__c  where Apttus_Proposal__Opportunity__c = :opp1id AND Digital_Quote_Type__c!= 'Straight Renewal' limit 1];
        System.assertEquals(propos.Digital_Quote_Type__c ,'Best Value'); 
    }

    public static testmethod void bestProposalAutomationTest8() {
        
        
        Account acct = CreateacctCommonCode('5');
        acct.APTS_Customer_Category__c  = '' ;  
        update acct;
		test.starttest();
        Source_System_Detail__c ssd = [Select id, Digital_Billing_City__c,Digital_Firm_Name__c,LCRM_APTS_Band_Number__c, APTS_Customer_Category__c, LCRM_eOutput_Eligibility__c from Source_System_Detail__c where Account_Name__c =: acct.id limit 1];
        ssd.APTS_Customer_Category__c = '';
        ssd.LCRM_eOutput_Eligibility__c = '';
        ssd.Digital_Billing_City__c ='test';
        ssd.Digital_Firm_Name__c ='Small Law';
        update ssd;
        
        
        Digital_BestProposalAutomation dbp = new Digital_BestProposalAutomation();
        DataBase.executeBatch(dbp);
        test.stoptest();
        
        Apttus_Proposal__Proposal__c propos = [SELECT Id,Name,Digital_Quote_Type__c  FROM Apttus_Proposal__Proposal__c  where Apttus_Proposal__Opportunity__c = :opp1id AND Digital_Quote_Type__c!= 'Straight Renewal' limit 1];
        System.assertEquals(propos.Digital_Quote_Type__c ,'Best Value'); 
    }   
    
    public static testmethod void premiumProposalAutomationTest9() {
        Account acct = CreateacctCommonCode('6');  
        list<Product2> prodList = [Select id, Name , Subscription_Number__c  from Product2];
        for (Product2 prd: prodList) {
            prd.Subscription_Number__c = '';
        }
        update prodList;
        
        test.starttest();
        Digital_BestProposalAutomation  dbp = new Digital_BestProposalAutomation();
        DataBase.executeBatch(dbp);
        test.stoptest();
        
        Apttus_Proposal__Proposal__c propos = [SELECT Id,Name,Digital_Quote_Type__c  FROM Apttus_Proposal__Proposal__c  where Apttus_Proposal__Opportunity__c = :opp1id AND Digital_Quote_Type__c!= 'Straight Renewal' limit 1];
        System.assertEquals(propos.Digital_Quote_Type__c ,'Best Value'); 
    } 
      
    public static testmethod void premiumProposalAutomationTest10() {
        Account acct = CreateacctCommonCode('7');
                
        test.starttest();
        Digital_BestProposalAutomation  dbp = new Digital_BestProposalAutomation();
        DataBase.executeBatch(dbp);
        test.stoptest();
        
        Apttus_Proposal__Proposal__c propos = [SELECT Id,Name,Digital_Quote_Type__c  FROM Apttus_Proposal__Proposal__c  where Apttus_Proposal__Opportunity__c = :opp1id AND Digital_Quote_Type__c!= 'Straight Renewal' limit 1];
        System.assertEquals(propos.Digital_Quote_Type__c ,'Best Value'); 
    }  

    public static account createacctCommonCode(string mode) {
 
        DCTestData.createData(); 
        opp1id = DCTestdata.oppId;
        acctId = DCTestData.accountId;
        acctSSDId = DCTestData.accssdid;
        pboookid = DCTestdata.pBookId;
        cQuoteID = DCTestData.cQuoteID;
        
        List<Apttus_Proposal__Proposal__c > listOfProp = new List<Apttus_Proposal__Proposal__c >();
        Apttus_Proposal__Proposal__c prop = new Apttus_Proposal__Proposal__c();
        prop.Apttus_Proposal__Primary__c = TRUE;
        prop.Apttus_Proposal__Account__c = acctId;
        prop.Apttus_Proposal__Opportunity__c = opp1Id;
        prop.APTS_SSD_Sold_To__c = acctSSDId;
        prop.APTS_SSD_ship_to__c = acctSSDId;
        prop.APTS_SSD_bill_to__c = acctSSDId;
        prop.Digital_Batch_Processed__c = TRUE;
        prop.APTS_Order_Confirmation_Contact_Email__c = 'test.test@gmail.com';
        prop.Digital_Quote_Type__c = 'Straight Renewal';
        prop.Apttus_Proposal__Approval_Stage__c = 'Draft';
        prop.APTS_MLA_Quote__c = TRUE;
        prop.APTS_Proposal_Business_Unit__c = 'SCS';
        prop.APTS_Payment_Option__c = 'Bill to Account';
        listOfProp.add(prop); 
         
        Apttus_Proposal__Proposal__c prop1 = new Apttus_Proposal__Proposal__c();
        prop1.Apttus_Proposal__Primary__c = TRUE;
        prop1.Apttus_Proposal__Account__c = acctId;
        prop1.Apttus_Proposal__Opportunity__c = opp1Id;
        prop1.APTS_SSD_Sold_To__c = acctSSDId;
        prop1.APTS_SSD_ship_to__c = acctSSDId;
        prop1.APTS_SSD_bill_to__c = acctSSDId;
        prop1.Digital_Batch_Processed__c = TRUE;
        prop1.APTS_Order_Confirmation_Contact_Email__c = 'test.test@gmail.com';
        prop1.Digital_Quote_Type__c = 'Best Value';
        prop1.Apttus_Proposal__Approval_Stage__c = 'Draft';
        prop1.APTS_MLA_Quote__c = TRUE;
        prop1.APTS_Proposal_Business_Unit__c = 'SCS';
        prop1.APTS_Payment_Option__c = 'Bill to Account';
        listOfProp.add(prop1);
        
        insert listOfProp;
        
        System.debug('Accountssd-->'+DCTestData.accountSSDlst);
        list<LCRM_Contact_SSD__c> contactList = new list<LCRM_Contact_SSD__c>();
        Contact testcontact= UnitTest.getContactInstance(acctId);
        testcontact.LastName = 'testContact';
        testcontact.FirstName = 'testContact';
        testcontact.AccountId = acctId;
        LCRM_Contact_SSD__c testContactSSD = new LCRM_Contact_SSD__c();
        testContactSSD = DCTestData.createContactSSD(testcontact,DCTestData.accountSSDlst);
        testContactSSD.LCRM_Last_Name__c = 'testContactSSD';
        testContactSSD.LCRM_First_Name__c = 'testContactSSD';
        testContactSSD.LCRM_Account_SSD__c= acctSSDId;
       
        if (mode == '1') {
            testContactSSD.LCRM_Email__c = 'testfirst.testlast@thomson.com';
            testContactSSD.LCRM_Job_Function__c = 'Attorney - Associate';
            testContactSSD.LCRM_SAP_Role__c= 'WL PSWD ACTIVE';
        }
        else if (mode == '2') {
            testContactSSD.LCRM_Email__c = 'testfirst.testlast@thomson.com';
            testContactSSD.LCRM_Job_Function__c = 'Other';
            testContactSSD.LCRM_SAP_Role__c = 'WL PSWD ACTIVE';
            testContactSSD.LCRM_Hard_Bounce__c = true;
        }
        else if (mode == '3') {
            testContactSSD.LCRM_Email__c = 'testfirst.testlast@thomson.com';
            testContactSSD.LCRM_Job_Function__c = 'Other';
            testContactSSD.LCRM_SAP_Role__c = 'EML ORDER CONFIRM';
        }
        else if(mode == '4'){
            testContactSSD.LCRM_Email__c = 'testfirst.testlast@thomson.com';
            testContactSSD.LCRM_Job_Function__c = 'Other';
            testContactSSD.LCRM_SAP_Role__c = 'EBILL EMAIL CONTACT';
            testContactSSD.LCRM_Hard_Bounce__c = true;
        }
        else if(mode == '5'){
            testContactSSD.LCRM_Email__c = 'testfirst.testlast@thomson.com';
            testContactSSD.LCRM_Job_Function__c = 'Other';
            testContactSSD.LCRM_SAP_Role__c = 'SAP - 18 BILLING/ACCT PAYABLE';
        }
        else if(mode == '6'){
            testContactSSD.LCRM_Email__c = 'testfirst.testlast@thomson.com';
            testContactSSD.LCRM_Job_Function__c = 'Other';
            testContactSSD.LCRM_SAP_Role__c = 'EML ORDER CONFIRM';
        }
        else if(mode == '7'){
            testContactSSD.LCRM_Email__c = 'testfirst.testlast@thomson.com';
            testContactSSD.LCRM_Job_Function__c = 'Other';
            testContactSSD.LCRM_SAP_Role__c = 'WL PSWD ACTIVE';
            testContactSSD.LCRM_Hard_Bounce__c = true;
        }
        testContactSSD.LCRM_Source_Contact_Id__c= '12345';
        contactList.add(testContactSSD);
        
        Contact testcontact2 = UnitTest.getContactInstance(acctId);
       
        testcontact2.AccountId = acctId;
        LCRM_Contact_SSD__c testContactSSD2 = new LCRM_Contact_SSD__c();
        testContactSSD2 = DCTestData.createContactSSD(testcontact2,DCTestData.accountSSDlst);
        testContactSSD2.LCRM_Last_Name__c = 'testContact2';
        testContactSSD2.LCRM_First_Name__c = 'testContact2';
        testContactSSD2.LCRM_Account_SSD__c = acctSSDId;
        if (mode =='1') {
            testContactSSD2.LCRM_Email__c = 'testfirst2.testlast@thomson.com';
            testContactSSD2.LCRM_Job_Function__c = 'Attorney - Associate';
            testContactSSD2.LCRM_SAP_Role__c = 'WL PSWD ACTIVE';
        }
        else if (mode == '2') {
            testContactSSD2.LCRM_Email__c = 'testfirst2.testlast@thomson.com';
            testContactSSD2.LCRM_Job_Function__c = 'Attorney - Associate';
            testContactSSD2.LCRM_SAP_Role__c = 'WL PSWD ACTIVE';
            testContactSSD2.LCRM_Hard_Bounce__c = true;
        }
        else if (mode =='3') {
            testContactSSD2.LCRM_Email__c = 'testfirst.testlast@thomson.com';
            testContactSSD2.LCRM_Job_Function__c = 'Other';
            testContactSSD2.LCRM_SAP_Role__c = 'EML ORDER CONFIRM';
        }
        else if(mode == '4'){
            testContactSSD2.LCRM_Email__c = 'testfirst.testlast@thomson.com';
            testContactSSD2.LCRM_Job_Function__c = 'Other';
            testContactSSD2.LCRM_SAP_Role__c = 'EBILL EMAIL CONTACT';
            testContactSSD2.LCRM_Hard_Bounce__c = true;
        }
        else if(mode == '5'){
            testContactSSD2.LCRM_Email__c= 'testfirst.testlast@thomson.com';
            testContactSSD2.LCRM_Job_Function__c = 'Other';
            testContactSSD2.LCRM_SAP_Role__c = 'SAP - 18 BILLING/ACCT PAYABLE';
        }
        else if(mode == '6'){
            testContactSSD2.LCRM_Email__c= 'testfirst.testlast@thomson.com';
            testContactSSD2.LCRM_Job_Function__c = 'Other';
            testContactSSD2.LCRM_SAP_Role__c = 'EML ORDER CONFIRM';
        }
        else if(mode == '7'){
            testContactSSD2.LCRM_Email__c = 'testfirst.testlast@thomson.com';
            testContactSSD2.LCRM_Job_Function__c = 'Other';
            testContactSSD2.LCRM_SAP_Role__c = 'WL PSWD ACTIVE';
            testContactSSD2.LCRM_Hard_Bounce__c = true;
        }
        else if(mode == '99'){
            testcontact.email = 'testfirst.testlast@thomson.com';
            testcontact.Job_Function__c = 'Other';
            testcontact.SAP_Role__c = 'SAP - 18 BILLING/ACCT PAYABLE';
            
        }
        testContactSSD2.LCRM_Source_Contact_Id__c= '12345';
        contactList.add(testContactSSD2);
        
        Contact testcontact3 = UnitTest.getContactInstance(acctId);
        LCRM_Contact_SSD__c testContactSSD3 = new LCRM_Contact_SSD__c();
        testContactSSD3 = DCTestData.createContactSSD(testcontact3,DCTestData.accountSSDlst);
        testContactSSD3.LCRM_Last_Name__c = 'testContact3';
        testContactSSD3.LCRM_First_Name__c = 'testContact3';
        testContactSSD3.LCRM_Account_SSD__c = acctSSDId;
        
        if (mode =='3') {
            testContactSSD3.LCRM_Email__c = 'testfirst.testlast@thomson.com';
            testContactSSD3.LCRM_Job_Function__c = 'Attorney - Associate';
            testContactSSD3.LCRM_SAP_Role__c = Null;
        }
        testcontactSSD3.LCRM_Source_Contact_Id__c = '12345';
        contactList.add(testcontactSSD3);
        update contactList; 

        list<Product2> prodList = new list<Product2>();
        
        Product2 prodObj = new Product2(); //current sub
        prodObj.Name = 'Essentials Library — Florida (Westlaw PRO™)';
        prodObj.List_Price__c = 0;
        prodObj.Format__c = 'Online';
        prodObj.Is_Orderable__c = TRUE;
        prodObj.IS_WP_Eligible__c = TRUE;
        prodObj.Media_High_Level__c = 'Online';
        prodObj.Service_Number__c = '40982845';
        prodObj.Subscription_Number__c = '40974107';
        prodObj.APTS_Product_Pricing_Model__c = 'Banded';
        prodObj.Family = 'WESTLAW';
        prodObj.Apttus_Filter_Media__c = 'Online';
        prodObj.APTS_Media_High_Level_Code__c = '07';
        prodObj.APTS_Media_Lower_Level_Code__c = 'E5';
        prodObj.Productcode = '42009613';
        prodObj.isActive = true;
        prodList.add(prodObj);
        
        Product2 prodObj2 = new Product2(); //new sub
        prodObj2.Name = 'Essentials Library — US (Westlaw PRO™)';
        prodObj2.List_Price__c = 10;
        prodObj2.Format__c = 'Online';
        prodObj2.Is_Orderable__c = TRUE;
        prodObj2.IS_WP_Eligible__c = TRUE;
        prodObj2.Media_High_Level__c = 'Online';
        prodObj2.Service_Number__c = '42009613';
        prodObj2.Subscription_Number__c = '42009613';
        prodObj2.APTS_Product_Pricing_Model__c = 'Banded';
        prodObj2.Family = 'WESTLAW';
        prodObj2.Apttus_Filter_Media__c = 'Online';
        prodObj2.APTS_Media_High_Level_Code__c = '05';
        prodObj2.APTS_Media_Lower_Level_Code__c = 'E5';
        prodObj2.Productcode = '42009614';
        prodObj2.isActive = true;
        prodList.add(prodObj2);
        insert prodList;          
        
        list<Product_Account_Detail__c> prodactdetailList = new list<Product_Account_Detail__c>();
        Product_Account_Detail__c prodactdetail1 = new Product_Account_Detail__c();
        prodactdetail1.ZP_Cust_Number__c = '1004284494';
        prodactdetail1.AccountSSD__c = acctSSDId;
        prodactdetail1.Current_Subscription__c = '40974107';
        prodactdetail1.Actual_New_Subscription__c = '42009613';
        prodactdetail1.Current_Term_Length__c = 3;
        prodactdetail1.Year1_YoYvalue__c = 1;
        prodactdetail1.Year2_YoYvalue__c = 11;
        prodactdetail1.Year3_YoYvalue__c = 22;
        prodactdetail1.Actual_New_Service__c = '42009613';
        prodactdetail1.Actual_New_Subscription_Product__c = prodObj2.id;
        //prodactdetail1.Premium_New_Service__c = '42009613';
        //prodactdetail1.Sub_Retail__c = 300;
        prodactdetail1.campaign_code__c = '00237KI';
        prodactdetail1.Offer_Price__c = -5;
        prodactdetail1.Type__c ='Plus';
        prodactdetail1.Quantity__c = 1;
        //prodactdetail1.Renewal_Date__c = System.Today().addDays(integer.valueof(label.Digital_Max_Asset_Days.trim()));
        prodactdetail1.Renewal_Date__c = System.Today()+1;        
        prodactdetail1.SAP_Contact_Id__c = '12345';
        prodactdetail1.Hard_Bounce__c = false;
        prodactdetail1.Opportunity__c = opp1id;
        prodactdetailList.add(prodactdetail1); 
        
        Product_Account_Detail__c prodactdetail2 = new Product_Account_Detail__c();
        prodactdetail2.ZP_Cust_Number__c = '1004284494';
        prodactdetail2.AccountSSD__c= acctSSDId;
        // prodactdetail2.Current_Subscription__c = '40974107';
        prodactdetail2.Actual_New_Subscription__c = '40974108';
        prodactdetail2.Actual_New_Service__c = '40982846';
        prodactdetail2.Actual_New_Subscription_Product__c = prodObj.id;
        prodactdetail2.campaign_code__c = '00237KI';
        prodactdetail2.Type__c ='Plus';
        prodactdetail2.Quantity__c = 1;
        prodactdetail2.Current_Term_Length__c = 3;
        prodactdetail2.Year1_YoYvalue__c = 1;
        prodactdetail2.Year2_YoYvalue__c = 11;
        prodactdetail2.Year3_YoYvalue__c = 22;
        prodactdetail2.Offer_Price__c = 5;
        //prodactdetail2.Renewal_Date__c = System.Today().addDays(integer.valueof(label.Digital_Max_Asset_Days.trim()));
        prodactdetail2.Renewal_Date__c = System.Today()+1;        
        prodactdetail2.SAP_Contact_Id__c = '12345';
        prodactdetail2.Hard_Bounce__c = false;
        prodactdetail2.Opportunity__c = opp1id;
        prodactdetailList.add(prodactdetail2);
        
        Product_Account_Detail__c prodactdetail3 = new Product_Account_Detail__c();
        prodactdetail3.ZP_Cust_Number__c = '1004284494';
        prodactdetail3.Account__c = acctId;
        prodactdetail3.AccountSSD__c = acctSSDId;
        // prodactdetail3.Premium_New_Service__c = '42009614'; //40982846
        prodactdetail3.Current_Subscription__c = '40974107';
        prodactdetail3.Actual_New_Subscription__c = '42009613';
        prodactdetail3.Actual_New_Service__c = '42009613';
        prodactdetail3.Actual_New_Subscription_Product__c = prodObj2.id;
        prodactdetail3.Quantity__c = 1;
        prodactdetail3.Current_Term_Length__c = 3;
        prodactdetail3.Year1_YoYvalue__c = 1;
        prodactdetail3.Year2_YoYvalue__c = 11;
        prodactdetail3.Year3_YoYvalue__c = 22;
        //prodactdetail3.Premium_New_Subscription__c = '40974108';
        //  prodactdetail3.Sub_Retail__c = 300;
        prodactdetail3.Offer_Price__c = 5;
        prodactdetail3.campaign_code__c = '00237KI';
        prodactdetail3.Type__c='Plus';
        //prodactdetail3.Renewal_Date__c = System.Today().addDays(integer.valueof(label.Digital_Max_Asset_Days.trim())); 
        prodactdetail3.Renewal_Date__c = System.Today()+1;             
        prodactdetail3.SAP_Contact_Id__c = '12345';
        prodactdetail3.Hard_Bounce__c = True;
        prodactdetail3.Opportunity__c = opp1id;
        prodactdetailList.add(prodactdetail3);
        
        insert prodactdetailList;
        system.debug('@@@@ : '+ prodactdetailList);
        
        set<String> productIds = new set<String>();
        for(Product_Account_Detail__c p : [select Actual_New_Subscription_Product__c from Product_Account_Detail__c where id in :prodactdetailList]){
            if (p.Actual_New_Subscription_Product__c != null) {
                productIds.add(p.Actual_New_Subscription_Product__c);
            }
            system.debug('p.Actual_New_Subscription_Product__c'+p.Actual_New_Subscription_Product__c);
        }
        
        Pricebook2 pbook1 = new Pricebook2();
        pbook1.name =  'GLI Price Book - FindLaw';
        insert pbook1;
        List<Apttus_Config2__PriceListItem__c> lstPLis = new List<Apttus_Config2__PriceListItem__c>();
        
        for(Product2 pod : [select id from product2 where id in :productIds]){
        
        Apttus_Config2__PriceListItem__c pli = new Apttus_Config2__PriceListItem__c();
        pli.Apttus_Config2__PriceListId__c = pboookid;
        pli.Apttus_Config2__ProductId__c = pod.id;
        pli.Apttus_Config2__ChargeType__c ='Subscription Fee';
        pli.Apttus_Config2__PriceType__c  = 'Recurring';
        pli.Apttus_Config2__Frequency__c = 'Monthly';
        pli.Apttus_Config2__PriceMethod__c = 'Per Unit';
        pli.Apttus_Config2__PriceUom__c = 'Each';
        pli.Apttus_Config2__Active__c  =true;
        pli.Apttus_Config2__ListPrice__c = 10;
        lstPLis.add(pli);
        
        }
        insert lstPLis;
        
       
       /* Apttus_Config2__ProductConfiguration__c newCart2 = new Apttus_Config2__ProductConfiguration__c(Id=DCTestdata.createCart(prop.Id), Apttus_Config2__Status__c = 'Finalized');
        System.debug('test1'+newCart2);
        
        list<Apttus_Config2__LineItem__c> listLines = new list<Apttus_Config2__LineItem__c>();
        
        Apttus_Config2__LineItem__c line1 = DCTestdata.createLineItem(newCart2.Id, 1, 1, true, 'Product/Service', prodObj2.id, null, 2, DCTestdata.pBookId, null, false,false);
        listLines.add(line1);

        Insert listLines;*/
        
         list<Apttus_Config2__AssetLineItem__c> aliList = new list<Apttus_Config2__AssetLineItem__c>();
        Apttus_Config2__AssetLineItem__c ali = new Apttus_Config2__AssetLineItem__c();
        ali.Name = 'Essentials Library — Florida (Westlaw PRO™)1';
        ali.Apttus_Config2__Quantity__c = 1;
        ali.Apttus_Config2__Description__c = 'Test';        
        ali.APTS_SAP_MLA_Agreement_Number__c = '12345678';
        ali.Apttus_Config2__PricingDate__c = System.Today()+2;
        ali.Apttus_Config2__IsPrimaryLine__c = TRUE;
        ali.Apttus_Config2__AssetStatus__c = 'Activated';
        ali.Apttus_Config2__LineType__c = 'Product/Service';
        ali.Apttus_Config2__LineNumber__c = 1;
        ali.Apttus_Config2__ItemSequence__c = 1;
        ali.Apttus_Config2__ProductId__c = prodObj.id;
        ali.Apttus_Config2__BillToAccountId__c = acctId;
        ali.Apttus_Config2__AccountId__c = acctId;
        ali.APTS_SSD_Sold_To__c = acctSSDId;
        ali.Apttus_Config2__ShipToAccountId__c = acctId;
        ali.Apttus_Config2__ChargeType__c = 'Subscription Fee';
        ali.APTS_Contract_Term__c = '3 Years';
        ali.APTS_YoY_Adjustment_Type__c = 'Increase';
        ali.Apttus_Config2__PriceListId__c = pBoookId;
        ali.APTS_Subscription_Number__c = '0974107';
        ali.APTS_Info_RenewalDate__c = System.Today()+2;
        ali.Apttus_Config2__RenewalDate__c = System.Today()+2;
        ali.APTS_Info_PlanType__c = 'R03';
        ali.Apttus_Config2__SellingFrequency__c = 'Monthly';
        ali.Apttus_Config2__SellingTerm__c = 1;
        ali.Apttus_Config2__NetPrice__c = 163;
        ali.Apttus_QPConfig__ProposalId__c = prop.id;
        ali.APTS_SSD_Bill_To__c = acctSSDId; 
        ali.APTS_SSD_Ship_to__c = acctSSDId;  
        aliList.add(ali); 
        
        Apttus_Config2__AssetLineItem__c ali2 = new Apttus_Config2__AssetLineItem__c();
        ali2.Name = 'Essentials Library — Florida (Westlaw PRO™)1';
        ali2.Apttus_Config2__Quantity__c = 1;
        ali2.Apttus_Config2__Description__c = 'Test2';        
        ali2.APTS_SAP_MLA_Agreement_Number__c = '12345678';
        ali2.Apttus_Config2__PricingDate__c = System.Today();
        ali2.Apttus_Config2__IsPrimaryLine__c = TRUE;
        ali2.Apttus_Config2__AssetStatus__c = 'Activated';
        ali2.Apttus_Config2__LineType__c = 'Product/Service';
        ali2.Apttus_Config2__LineNumber__c = 2;
        ali2.Apttus_Config2__ItemSequence__c = 2;
        ali2.Apttus_Config2__ProductId__c = prodObj2.id;
        ali2.Apttus_Config2__BillToAccountId__c = acctId;
        ali2.Apttus_Config2__AccountId__c = acctId;
        ali2.APTS_SSD_Sold_To__c = acctSSDId;
        ali2.Apttus_Config2__ShipToAccountId__c = acctId;
        ali2.Apttus_Config2__ChargeType__c = 'Subscription Fee';
        ali2.APTS_Contract_Term__c = '3 Years';
        ali2.APTS_YoY_Adjustment_Type__c = 'Increase';
        ali2.Apttus_Config2__PriceListId__c = pBoookId;
        ali2.APTS_Subscription_Number__c = '0974107';
        ali2.APTS_Info_RenewalDate__c = System.Today()+2;
        ali2.Apttus_Config2__RenewalDate__c = System.Today()+2;
        ali2.APTS_Info_PlanType__c = 'R03';
        ali2.Apttus_Config2__SellingFrequency__c = 'Monthly';
        ali2.Apttus_Config2__SellingTerm__c = 1;
        ali2.Apttus_Config2__NetPrice__c = 83;
        ali2.Apttus_QPConfig__ProposalId__c = prop.id;
         ali2.APTS_SSD_Bill_To__c = acctSSDId; 
        ali2.APTS_SSD_Ship_to__c = acctSSDId;  
        aliList.add(ali2);
        
        insert aliList; 
        opportunity opp= [select id,name from opportunity where accountId =: acctId limit 1];
        return DCTestData.Acct;
    } 
    
}