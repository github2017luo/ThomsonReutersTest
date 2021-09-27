/*
 * Modified by Bharat Bhushan on 6th Aug 2018
 * DLT-11509 - [TECH STORY] SAP Contact ID field to modify as per GLI to be replace with Source Contact ID]
 * Modified by Navleen Kaur on 8th Oct 2018
 * DLT-12028 - Tech Story [Code Scan] Fix Digital_ProposalCreationCommoncode, Digital_ProposalCreationCommoncode_Test.
 * Modified By Harika Sai P on 21st Oct 2018.
 * DLT-12773 - Remove the automation exclusion logic code in Salesforce based on MHLC
 * DLT-12833 - [Gov] Order Confirmation Contact logic
 * DLT-20643 - Crtical/Blocker PMD fix
 *
 * 2021-04-01  Brenda shields  DLT-21575 - Update logic to correctly set OCC and associated fields
 */ 
@istest
public class Digital_ProposalCreationCommoncode_Test{

    public static String opp1id;
    public static String acctid;
    public static String acctssdid;
    public static String pboookid;
    public static String cQuoteID;
    public  static list<Apttus_Config2__AssetLineItem__c>  opt1 ;
 
     
    private static testmethod void proposalAutomationTest1(){
		Account acc = CreateacctCommonCode('1'); 
        system.debug(logginglevel.INFO, 'Account information: ' + acc);
        test.starttest();
        Digital_ProposalCreationCommoncode.ProposalCreation(DCTestdata.oppList1, opt1, 'Straight Renewal');
        test.stoptest();
        //For Assersion   
        Apttus_Proposal__Proposal__c prop = [SELECT Id,Name,Digital_Quote_Type__c  FROM Apttus_Proposal__Proposal__c  where Apttus_Proposal__Opportunity__c = :opp1Id];
        System.assertEquals(prop.Digital_Quote_Type__c ,'Straight Renewal','Assert failed');    
        
    } 
    
   private static testmethod void proposalAutomationManual(){
        
        test.starttest();
        Account acc = CreateacctCommonCode('1');  
        Apttus_Proposal__Proposal__c p= DCTestData.createProposalRec(opp1Id,acctssdid,acc.Id,null,'');
        p.Digital_Quote_Type__c  = 'Manual' ;
        p.APTS_Proposal_Business_Unit__c = 'SCS';
        p.APTS_Payment_Option__c = 'Bill to Account';
        Insert p;
        test.stoptest();        
        
         Digital_ProposalCreationCommoncode.ProposalCreation(DCTestdata.oppList1, opt1, 'Straight Renewal');
        
       
        //For Assersion   
        Apttus_Proposal__Proposal__c prop = [SELECT Id,Name,Digital_Quote_Type__c  FROM Apttus_Proposal__Proposal__c  where Apttus_Proposal__Opportunity__c = :opp1Id limit 1];
        System.assertEquals(prop.Digital_Quote_Type__c ,'Manual','Assert failed');    
        
    }
    private static testmethod void proposalAutomationCorporate(){
        
        Account acc = CreateacctCommonCode('Corporate');     
        System.assert(acc != null,'Assert failed');
        test.starttest();
        Digital_ProposalCreationCommoncode.ProposalCreation(DCTestdata.oppList1, opt1, 'Straight Renewal');
        test.stoptest();
    }
    
  
   /* private static testmethod void proposalAutomationTest99(){
        Account acc = CreateacctCommonCode('99'); 
        acc.APTS_eOutput_Eligibilty__c = '';
        Apttus_Config2__AssetLineItem__c assList = [ select id, Apttus_Config2__AssetStatus__c from Apttus_Config2__AssetLineItem__c LIMIT 1];
        assList.Apttus_Config2__AssetStatus__c = 'Cancelled';
        update assList;
       
        test.starttest();
         Digital_ProposalCreationCommoncode.ProposalCreation(DCTestdata.oppList1, opt1, 'Straight Renewal');
        test.stoptest();
        //For Assersion
        Apttus_Config2__AssetLineItem__c assetAfterBatch = [Select id, Apttus_Config2__AssetStatus__c from Apttus_Config2__AssetLineItem__c LIMIT 1];
        System.assertEquals(assetAfterBatch.Apttus_Config2__AssetStatus__c , 'Cancelled');
    }*/
    
    
    
    private static testmethod void proposalAutomationTestPositive(){
        Account acc = CreateacctCommonCode('6');
        acc.APTS_eOutput_Eligibilty__c = '';
     
        test.starttest();
         Digital_ProposalCreationCommoncode.ProposalCreation(DCTestdata.oppList1, opt1, 'Straight Renewal');
        test.stoptest();
        //For Assersion
        Apttus_Proposal__Proposal__c prop = [SELECT Id,Name,Digital_Quote_Type__c  FROM Apttus_Proposal__Proposal__c  where Apttus_Proposal__Opportunity__c = :opp1Id];
        System.assertEquals(prop.Digital_Quote_Type__c ,'Straight Renewal','Assert failed');    
        
        
    }
    
    private static testmethod void proposalAutomationTestOPCamCode(){
        Account acc = CreateacctCommonCode('6');
         acc.APTS_eOutput_Eligibilty__c = '';
         
        list<Apttus_Config2__AssetLineItem__c>  opt1 = [ select id, APTS_Info_RenewalDate__c  from Apttus_Config2__AssetLineItem__c  LIMIT 1];
        opt1[0].APTS_Info_RenewalDate__c = System.Today().addDays(-90);
        update opt1;
        test.starttest();
         Digital_ProposalCreationCommoncode.ProposalCreation(DCTestdata.oppList1, opt1, 'Best Value');
        test.stoptest();
        Apttus_Proposal__Proposal__c prop = [SELECT Id,Name,Apttus_Proposal__Primary__c FROM Apttus_Proposal__Proposal__c  LIMIT 1];
        System.assertEquals(prop.Apttus_Proposal__Primary__c,false,'Assert failed');  
        
    }
    
    private static testmethod void proposalAutomationTestCamCode(){
        Account acc = CreateacctCommonCode('6'); 
        acc.APTS_eOutput_Eligibilty__c = '';
        Opportunity opt11 = [ select id, Campaign_Code__c  from Opportunity  LIMIT 1];
        opt11.Campaign_Code__c = 'SOQL';
        update opt11;
        test.starttest();
         Digital_ProposalCreationCommoncode.ProposalCreation(DCTestdata.oppList1, opt1, 'Straight Renewal');       
        test.stoptest();
        //For Assersion
        Apttus_Proposal__Proposal__c prop = [SELECT Id,Name,Digital_Quote_Type__c  FROM Apttus_Proposal__Proposal__c  where Apttus_Proposal__Opportunity__c = :opp1Id];
        System.assertEquals(prop.Digital_Quote_Type__c ,'Straight Renewal','Assert failed');    
        
    }
    
    private static testmethod void proposalAutomationTestExCamCode(){
        Account acc = CreateacctCommonCode('1');
        acc.APTS_eOutput_Eligibilty__c = '';        
        list<Product_Account_Detail__c> dSubscriptionsList =  new list<Product_Account_Detail__c>();
        for(Product_Account_Detail__c digitalSubscriptionsList : [SELECT Account__c,AccountSSD__c,Campaign_Code__c,sub_Campaign_Code__c,Quantity__c,Actual_New_Service__c,Actual_New_Subscription_Product__c,Current_Subscription__c,Premium_New_Subscription__c,ZP_Cust_Number__c,Hard_Bounce__c FROM Product_Account_Detail__c where Current_Subscription__c != Null AND Campaign_Code__c != Null ]){
            if(digitalSubscriptionsList !=null){
                 digitalSubscriptionsList.Campaign_Code__c = null;
                 dSubscriptionsList.add(digitalSubscriptionsList);
            }
           
        }
        update dSubscriptionsList;
        
        test.starttest();
         Digital_ProposalCreationCommoncode.ProposalCreation(DCTestdata.oppList1, opt1, 'Straight Renewal');
        test.stoptest();
        //For Assersion
        list<Product_Account_Detail__c> dsListAfterBatch = [SELECT Account__c,AccountSSD__c,Campaign_Code__c,sub_Campaign_Code__c,Quantity__c,Actual_New_Service__c,Actual_New_Subscription_Product__c,Current_Subscription__c,Premium_New_Subscription__c,ZP_Cust_Number__c,Hard_Bounce__c FROM Product_Account_Detail__c LIMIT 50000];
        System.AssertEquals(dsListAfterBatch[0].Campaign_Code__c,null,'Assert failed');
    } 
    
    private static testmethod void proposalAutomationTestExpct(){
        
        Account acc = CreateacctCommonCode('2');
        
        acc.APTS_eOutput_Eligibilty__c = 'NEL';
        update acc;
        
        /*Media_High_Level_Code__c mediaCode = new Media_High_Level_Code__c(Name = 'Code07', Media_Value__c ='07');
        insert mediaCode;*/
        
        test.starttest();
         Digital_ProposalCreationCommoncode.ProposalCreation(DCTestdata.oppList1, opt1, 'Straight Renewal');
        test.stoptest();
        //For Assersion
        Apttus_Proposal__Proposal__c  prop= [SELECT Digital_Quote_Type__c from Apttus_Proposal__Proposal__c WHERE APTS_SSD_Sold_To__c =: acctssdid LIMIT 1];
        System.AssertEquals(prop.Digital_Quote_Type__c, 'Straight Renewal','Assert failed');
    }
    
    private static testmethod void proposalAutomationTest2(){
        
        Account acc = CreateacctCommonCode('2');
        acc.APTS_Band_Number__c = 2 ;
        acc.APTS_Customer_Category__c = '7';
        acc.APTS_eOutput_Eligibilty__c = '';
        update acc;
        Source_System_Detail__c ssd = [Select id, LCRM_APTS_Band_Number__c, APTS_Customer_Category__c, LCRM_eOutput_Eligibility__c from Source_System_Detail__c where Account_Name__c =: acc.id];
        ssd.LCRM_APTS_Band_Number__c = 2;
        ssd.APTS_Customer_Category__c = '7';
        ssd.LCRM_eOutput_Eligibility__c = '';
        update ssd;
        
       
        
        test.starttest();
         Digital_ProposalCreationCommoncode.ProposalCreation(DCTestdata.oppList1, opt1, 'Premium');
        test.stoptest();
        //For Assersion
        Apttus_Proposal__Proposal__c  prop= [SELECT Digital_Quote_Type__c from Apttus_Proposal__Proposal__c WHERE APTS_SSD_Sold_To__c =: acctssdid LIMIT 1];
        System.AssertEquals(prop.Digital_Quote_Type__c, 'Premium','Assert failed');

    } 
    
    private static testmethod void proposalAutomationTest3(){
        
        Account acc = CreateacctCommonCode('3'); 
        acc.FrozenMarketSegment__c = 'Solo Law Firm' ;
        acc.APTS_eOutput_Eligibilty__c = ''; 
         
        List<LCRM_Contact_SSD__c> listContactSSD  = [select id,name,LCRM_SAP_Role__c from LCRM_Contact_SSD__c where LCRM_SAP_Role__c='EML ORDER CONFIRM' limit 1];
        if(listContactSSD!=null && listContactSSD.size()>0){
            listContactSSD[0].LCRM_SAP_Role__c = 'EML ORDER CONFIRM';
        }update listContactSSD;
        
        test.starttest();
         Digital_ProposalCreationCommoncode.ProposalCreation(DCTestdata.oppList1, opt1, 'Straight Renewal');
        test.stoptest();
        //For Assersion      
        LCRM_Contact_SSD__c listContactSSD2  =   [select id,name,LCRM_SAP_Role__c,LCRM_Contact__c from LCRM_Contact_SSD__c where LCRM_SAP_Role__c='EML ORDER CONFIRM' limit 1];        
        Apttus_Proposal__Proposal__c prop= [SELECT APTS_Order_Confirmation_Contact__c from Apttus_Proposal__Proposal__c WHERE Apttus_Proposal__Opportunity__c =: opp1id];
        System.AssertEquals(prop.APTS_Order_Confirmation_Contact__c, listContactSSD2.LCRM_Contact__c,'Assert failed');
        
    }
    private static testmethod void proposalAutomationTest4(){
        
        Account acc = CreateacctCommonCode('3');
         acc.APTS_eOutput_Eligibilty__c = '';        
                        
        List<LCRM_Contact_SSD__c > listContactSSD  = [select id,name,LCRM_SAP_Role__c from LCRM_Contact_SSD__c limit 1];
        if(listContactSSD !=null && listContactSSD.size()>0){
            listContactSSD[0].LCRM_SAP_Role__c = 'WL PSWD ACTIVE';
        }
        update listContactSSD;
        
        test.starttest();
         Digital_ProposalCreationCommoncode.ProposalCreation(DCTestdata.oppList1, opt1, 'Straight Renewal');
        test.stoptest();
        //For Assersion      
        LCRM_Contact_SSD__c listContactSSD2  =   [select id,name,LCRM_SAP_Role__c,LCRM_Contact__c from LCRM_Contact_SSD__c where LCRM_SAP_Role__c='EML ORDER CONFIRM' limit 1];        
        Apttus_Proposal__Proposal__c prop= [SELECT APTS_Order_Confirmation_Contact__c from Apttus_Proposal__Proposal__c WHERE Apttus_Proposal__Opportunity__c =: opp1id];
        System.AssertEquals(prop.APTS_Order_Confirmation_Contact__c, listContactSSD2.LCRM_Contact__c,'Assert failed');
    }
    
    private static testmethod void proposalAutomationTest5(){
        
        Account acc = CreateacctCommonCode('3');
        acc.APTS_eOutput_Eligibilty__c = '';  
        test.starttest();
         Digital_ProposalCreationCommoncode.proposalCreation(DCTestdata.oppList1, opt1, 'Straight Renewal');
        test.stoptest();
        //For Assersion
        Apttus_Proposal__Proposal__c  prop= [SELECT Digital_Quote_Type__c from Apttus_Proposal__Proposal__c WHERE APTS_SSD_Sold_To__c =: acctssdid LIMIT 1];
        System.AssertEquals(prop.Digital_Quote_Type__c, 'Straight Renewal','Assert failed');
    }
    
    private static testmethod void proposalAutomationTest6(){
        
        Account acc = CreateacctCommonCode('3');
        acc.APTS_eOutput_Eligibilty__c = 'NEL';        
                        
        list<LCRM_Contact_SSD__c> listContactSSD  = [select id,name,LCRM_SAP_Role__c from LCRM_Contact_SSD__c LIMIT 50000 ];
        delete listContactSSD;
        test.starttest();
        Digital_ProposalCreationCommoncode.ProposalCreation(DCTestdata.oppList1, opt1, 'Straight Renewal');
        test.stoptest();
        //For Assersion      
       
        List<Apttus_Proposal__Proposal__c> propList= new List<Apttus_Proposal__Proposal__c>();
        propList= [SELECT Id,APTS_Order_Confirmation_Contact__c from Apttus_Proposal__Proposal__c WHERE Apttus_Proposal__Opportunity__c =: opp1id];
        System.AssertEquals(propList.Size(), 0,'Assert failed');
    }
    private static testmethod void proposalAutomationTest7(){
        Account acc = CreateacctCommonCode('4');  
        acc.APTS_Band_Number__c = 2 ;
        acc.APTS_eOutput_Eligibilty__c = '';
        update acc;
        Source_System_Detail__c ssd = [Select id, LCRM_APTS_Band_Number__c, APTS_Customer_Category__c, LCRM_eOutput_Eligibility__c from Source_System_Detail__c where Account_Name__c =: acc.id];
        ssd.LCRM_APTS_Band_Number__c = 2;
        update ssd;

        List<LCRM_Contact_SSD__c> listContactSSD  = [select id,name,LCRM_SAP_Role__c from LCRM_Contact_SSD__c limit 1];
        if(listContactSSD !=null && listContactSSD.size()>0){
            listContactSSD[0].LCRM_SAP_Role__c = 'EBILL EMAIL CONTACT';
            listContactSSD[0].LCRM_Job_Function__c= 'Other';
           

        }
        update listContactSSD;
        test.starttest();
        
        Digital_ProposalCreationCommoncode.proposalCreation(DCTestdata.oppList1, opt1, 'Straight Renewal');
       
        test.stoptest();        
        //For Assersion
        Apttus_Proposal__Proposal__c  prop= [SELECT Digital_Quote_Type__c from Apttus_Proposal__Proposal__c WHERE APTS_SSD_Sold_To__c =: acctssdid LIMIT 1];
        System.AssertEquals(prop.Digital_Quote_Type__c, 'Straight Renewal','Assert failed');       
        
    }  
    private static testmethod void proposalAutomationTest72(){
        Account acc = CreateacctCommonCode('4');  
        acc.APTS_Band_Number__c = 2 ;
         acc.APTS_eOutput_Eligibilty__c = '';
        update acc;
        Source_System_Detail__c ssd = [Select id, LCRM_APTS_Band_Number__c, APTS_Customer_Category__c, LCRM_eOutput_Eligibility__c from Source_System_Detail__c where Account_Name__c =: acc.id];
        ssd.LCRM_APTS_Band_Number__c = 2;
        update ssd;
        List<LCRM_Contact_SSD__c> listContact  = [select id,name,LCRM_SAP_Role__c from LCRM_Contact_SSD__c limit 1];
        if(listContact !=null && listContact.size()>0){
            listContact[0].LCRM_SAP_Role__c = 'EBILL EMAIL CONTACT';
            listContact[0].LCRM_Job_Function__c = 'Attorney - Associate';           
            
        }
        update listContact;
        test.starttest();
        Digital_ProposalCreationCommoncode.proposalCreation(DCTestdata.oppList1, opt1, 'Straight Renewal');
        test.stoptest();
        //For Assersion
        Apttus_Proposal__Proposal__c  prop= [SELECT Digital_Quote_Type__c from Apttus_Proposal__Proposal__c WHERE APTS_SSD_Sold_To__c =: acctssdid LIMIT 1];
        System.AssertEquals(prop.Digital_Quote_Type__c, 'Straight Renewal','Assert failed');    
       
    }
    
    private static testmethod void proposalAutomationTestconatct(){
        Account acc = CreateacctCommonCode('4');  
        acc.APTS_Band_Number__c = 2 ;        
         acc.APTS_eOutput_Eligibilty__c = '';
        update acc;
        Source_System_Detail__c ssd = [Select id, LCRM_APTS_Band_Number__c, APTS_Customer_Category__c, LCRM_eOutput_Eligibility__c from Source_System_Detail__c where Account_Name__c =: acc.id];
        ssd.LCRM_APTS_Band_Number__c = 2;
        update ssd;
        List<LCRM_Contact_SSD__c> listContact  = [select id,name,LCRM_SAP_Role__c from LCRM_Contact_SSD__c limit 1];
        if(listContact !=null && listContact.size()>0){
            listContact[0].LCRM_SAP_Role__c = 'SAP - 18 BILLING/ACCT PAYABLE';
            listContact[0].LCRM_Job_Function__c = 'Other';
        }
        update listContact;
        test.starttest();
        Digital_ProposalCreationCommoncode.proposalCreation(DCTestdata.oppList1, opt1, 'Straight Renewal');
        test.stoptest();
        //For Assersion
        Apttus_Proposal__Proposal__c  prop= [SELECT Digital_Quote_Type__c from Apttus_Proposal__Proposal__c WHERE APTS_SSD_Sold_To__c =: acctssdid LIMIT 1];
        System.AssertEquals(prop.Digital_Quote_Type__c, 'Straight Renewal','Assert failed');     
    }  
    
    private static testmethod void proposalAutomationTestconatctotherc(){
        Account acc = CreateacctCommonCode('6');  
        acc.APTS_eOutput_Eligibilty__c = '';
        acc.APTS_Band_Number__c = 2 ;
        acc.FrozenMarketSegment__c = 'Solo Law Firm';
        update acc;
        Source_System_Detail__c ssd = [Select id, LCRM_APTS_Band_Number__c, APTS_Customer_Category__c, LCRM_eOutput_Eligibility__c from Source_System_Detail__c where Account_Name__c =: acc.id];
        ssd.LCRM_APTS_Band_Number__c = 2;
        update ssd;
        List<LCRM_Contact_SSD__c> listContact  = [select id,name,LCRM_SAP_Role__c from LCRM_Contact_SSD__c limit 1];
        if(listContact !=null && listContact.size()>0){
            listContact[0].LCRM_SAP_Role__c = 'EBILL EMAIL CONTACT';
            listContact[0].LCRM_Job_Function__c = 'Other';
        }
        update listContact;
        test.starttest();
         Digital_ProposalCreationCommoncode.ProposalCreation(DCTestdata.oppList1, opt1, 'Straight Renewal');
       test.stoptest();
        //For Assersion
        Apttus_Proposal__Proposal__c  prop= [SELECT Digital_Quote_Type__c from Apttus_Proposal__Proposal__c WHERE APTS_SSD_Sold_To__c =: acctssdid LIMIT 1];
        System.AssertEquals(prop.Digital_Quote_Type__c, 'Straight Renewal','Assert failed');     
    }  
    
    private static testmethod void proposalAutomationTestconatctotherc2(){
        Account acc = CreateacctCommonCode('6');  
        acc.APTS_eOutput_Eligibilty__c = 'USG';
        acc.APTS_Band_Number__c = 2 ;
        acc.FrozenMarketSegment__c = 'Solo Law Firm';
        update acc;
        Source_System_Detail__c ssd = [Select id, LCRM_APTS_Band_Number__c, APTS_Customer_Category__c, LCRM_eOutput_Eligibility__c from Source_System_Detail__c where Account_Name__c =: acc.id];
        ssd.LCRM_APTS_Band_Number__c = 2;
        ssd.LCRM_eOutput_Eligibility__c = 'USG';
        update ssd;
        List<LCRM_Contact_SSD__c> listContact  = [select id,name,LCRM_SAP_Role__c from LCRM_Contact_SSD__c limit 1];
        if(listContact !=null && listContact.size()>0){
            listContact[0].LCRM_SAP_Role__c = 'EML ORDER CONFIRM';
            listContact[0].LCRM_Job_Function__c = 'Other';
            listContact[0].LCRM_Hard_Bounce__c = true;
            
        }
        update listContact;
        test.starttest();
        Digital_ProposalCreationCommoncode.proposalCreation(DCTestdata.oppList1, opt1, 'Straight Renewal');
        test.stoptest();
        //For Assersion            
        LCRM_Contact_SSD__c listContactSSD2  =   [select id,name,LCRM_SAP_Role__c,LCRM_Contact__c from LCRM_Contact_SSD__c where LCRM_SAP_Role__c='EML ORDER CONFIRM' limit 1];        
        Apttus_Proposal__Proposal__c prop= [SELECT APTS_Order_Confirmation_Contact__c from Apttus_Proposal__Proposal__c WHERE Apttus_Proposal__Opportunity__c =: opp1id];
        System.AssertEquals(prop.APTS_Order_Confirmation_Contact__c, listContactSSD2.LCRM_Contact__c,'Assert failed');
    } 
    
    private static testmethod void proposalAutomationTestconatctother(){
        Account acc = CreateacctCommonCode('6');
        acc.APTS_eOutput_Eligibilty__c = '';
        acc.APTS_Band_Number__c = 1 ;
        acc.FrozenMarketSegment__c = 'Solo Law Firm';
        update acc;
        Source_System_Detail__c ssd = [Select id, LCRM_APTS_Band_Number__c, APTS_Customer_Category__c, LCRM_eOutput_Eligibility__c from Source_System_Detail__c where Account_Name__c =: acc.id];
        ssd.LCRM_APTS_Band_Number__c = 1;
        update ssd;
        List<LCRM_Contact_SSD__c> listContact  = [select id,name,LCRM_SAP_Role__c from LCRM_Contact_SSD__c limit 1];
        if(listContact !=null && listContact.size()>0){
            listContact[0].LCRM_SAP_Role__c = 'Other';
            listContact[0].LCRM_Job_Function__c = 'Attorney - Associate';
        }
        update listContact;
        test.starttest();
         Digital_ProposalCreationCommoncode.ProposalCreation(DCTestdata.oppList1, opt1, 'Straight Renewal');
        test.stoptest();
        //For Assersion
        Apttus_Proposal__Proposal__c  prop= [SELECT Digital_Quote_Type__c from Apttus_Proposal__Proposal__c WHERE APTS_SSD_Sold_To__c =: acctssdid LIMIT 1];
        System.AssertEquals(prop.Digital_Quote_Type__c, 'Straight Renewal','Assert failed');     
    }    
    private static testmethod void proposalAutomationTest8(){
        Account acc = CreateacctCommonCode('5');        
        acc.APTS_eOutput_Eligibilty__c = '';
        test.starttest();
        Digital_ProposalCreationCommoncode.proposalCreation(DCTestdata.oppList1, opt1, 'Straight Renewal');
        test.stoptest();
         //For Assersion
        Apttus_Proposal__Proposal__c  prop= [SELECT Digital_Quote_Type__c from Apttus_Proposal__Proposal__c WHERE APTS_SSD_Sold_To__c =: acctssdid LIMIT 1];
        System.AssertEquals(prop.Digital_Quote_Type__c, 'Straight Renewal','Assert failed');    
       
    }
    
    private static testmethod void premiumProposalOpptyerror(){
        Account acc = CreateacctCommonCode('6');        
        acc.APTS_eOutput_Eligibilty__c = '';
        test.starttest();
        list<Opportunity> oppList = [SELECT Name from  Opportunity LIMIT 50000];
        system.debug(logginglevel.INFO, 'Oppertunity List: ' + oppList);
        Digital_ProposalCreationCommoncode.ProposalCreation(DCTestdata.oppList1, opt1, 'Straight Renewal');
       test.stoptest();
         //For Assersion
        Apttus_Proposal__Proposal__c  prop= [SELECT Digital_Quote_Type__c from Apttus_Proposal__Proposal__c WHERE APTS_SSD_Sold_To__c =: acctssdid LIMIT 1];
        System.AssertEquals(prop.Digital_Quote_Type__c, 'Straight Renewal','Assert failed');    
       
    } 
     
    @istest public static void proposalAutomationTest10(){
        Account acc = CreateacctCommonCode('7');        
        acc.APTS_eOutput_Eligibilty__c = '';
        test.starttest();
         Digital_ProposalCreationCommoncode.ProposalCreation(DCTestdata.oppList1, opt1, 'Straight Renewal');
        test.stoptest();
         //For Assersion
        Apttus_Proposal__Proposal__c  prop= [SELECT Digital_Quote_Type__c from Apttus_Proposal__Proposal__c WHERE APTS_SSD_Sold_To__c =: acctssdid LIMIT 1];
        System.AssertEquals(prop.Digital_Quote_Type__c, 'Straight Renewal','Assert failed');    
       
    } 
    
    private static testmethod void proposalAutomationTestebil(){
        Account acc = CreateacctCommonCode('41');        
        acc.APTS_eOutput_Eligibilty__c = '';
        test.starttest();
         Digital_ProposalCreationCommoncode.ProposalCreation(DCTestdata.oppList1, opt1, 'Straight Renewal');
        test.stoptest();
         //For Assersion
        Apttus_Proposal__Proposal__c  prop= [SELECT Digital_Quote_Type__c from Apttus_Proposal__Proposal__c WHERE APTS_SSD_Sold_To__c =: acctssdid LIMIT 1];
        System.AssertEquals(prop.Digital_Quote_Type__c, 'Straight Renewal','Assert failed');    
       
    }

    private static testmethod void getKeyContactSmallLawTest(){
        List<LCRM_Contact_SSD__c> contactSSD = new List<LCRM_Contact_SSD__c>();
        Map<id, boolean> contactToHardBounceMap = new Map<id,boolean>();
        LCRM_Contact_SSD__c c1 = new LCRM_Contact_SSD__c(LCRM_SAP_Role__c = 'null',LCRM_Job_Function__c = 'Attorney - Associate',LCRM_Hard_Bounce__c = true);
        LCRM_Contact_SSD__c c2 = new LCRM_Contact_SSD__c(LCRM_SAP_Role__c = 'null',LCRM_Job_Function__c = 'Attorney - Associate',LCRM_Hard_Bounce__c = false);
        contactSSD.add(c1);
        contactSSD.add(c2);
        insert contactSSD;
        contactSSD = [SELECT id,LCRM_Job_Function__c,LCRM_SAP_Role__c,LCRM_Hard_Bounce__c FROM LCRM_Contact_SSD__c];
        for(LCRM_Contact_SSD__c contact: contactSSD){
            contactToHardBounceMap.put(contact.id,true);
        }
        List<LCRM_Contact_SSD__c> returnedContacts;
        //Tests hardbounce amount
        returnedContacts = Digital_ProposalCreationCommoncode.getKeyContactSmallLaw(0,contactSSD,contactToHardBounceMap,contactToHardBounceMap);
        returnedContacts = Digital_ProposalCreationCommoncode.getKeyContactSmallLaw(1,contactSSD,contactToHardBounceMap,contactToHardBounceMap);
        //Tests >1 wlCount amount
        contactSSD[0].LCRM_SAP_Role__c = 'WL PSWD ACTIVE';
        contactSSD[1].LCRM_SAP_Role__c = 'WL PSWD ACTIVE';
        returnedContacts = Digital_ProposalCreationCommoncode.getKeyContactSmallLaw(0,contactSSD,contactToHardBounceMap,contactToHardBounceMap);
        contactSSD[0].LCRM_SAP_Role__c = 'null';
        returnedContacts = Digital_ProposalCreationCommoncode.getKeyContactSmallLaw(0,contactSSD,contactToHardBounceMap,contactToHardBounceMap);

        //Test EML ORDER CONFIRM amounts
        contactSSD[0].LCRM_SAP_Role__c = 'EML ORDER CONFIRM';
        contactSSD[1].LCRM_SAP_Role__c = 'EML ORDER CONFIRM';
        returnedContacts = Digital_ProposalCreationCommoncode.getKeyContactSmallLaw(0,contactSSD,contactToHardBounceMap,contactToHardBounceMap);
        contactSSD[0].LCRM_SAP_Role__c = 'null';
        returnedContacts = Digital_ProposalCreationCommoncode.getKeyContactSmallLaw(0,contactSSD,contactToHardBounceMap,contactToHardBounceMap);

        //Test attorney amount 
        contactSSD[0].LCRM_SAP_Role__c = null;
        contactSSD[1].LCRM_SAP_Role__c = null;
        contactSSD[0].LCRM_Job_Function__c = null;
        contactSSD[1].LCRM_Job_Function__c = null;
        returnedContacts = Digital_ProposalCreationCommoncode.getKeyContactSmallLaw(1,contactSSD,contactToHardBounceMap,contactToHardBounceMap);

        System.AssertNotEquals(returnedContacts,null,'No contacts returned');
    }

    //DLT-12833 
     @istest public static void proposalAutomationTestOCCGov(){
        Account acc = CreateacctCommonCode('Government'); 
        system.debug(logginglevel.INFO, 'Account Info: ' + acc);
        test.starttest();
        Digital_ProposalCreationCommoncode.ProposalCreation(DCTestdata.oppList1, opt1, 'Straight Renewal');
        test.stoptest();
         //For Assersion
        Apttus_Proposal__Proposal__c  prop= [SELECT Digital_Quote_Type__c from Apttus_Proposal__Proposal__c WHERE APTS_SSD_Sold_To__c =: acctssdid LIMIT 1];
        System.AssertEquals(prop.Digital_Quote_Type__c, 'Straight Renewal','Assert failed');    
       
    } //Ends

  /**
    * @description : method to create Account records
    * @param mode : mode
    * @return Account : Account record
    */    
 	public static account createacctCommonCode(string mode) {
 
    	LTS_Disable_Application_Automation__c ltstemp = new LTS_Disable_Application_Automation__c();
        ltstemp.LTS_Disable_Process_Builders__c = true;
        ltstemp.LTS_Disable_Triggers__c = true;
        ltstemp.LTS_Disable_Validation_Rules__c = true;
        ltstemp.LTS_Disable_Workflow_Rules__c = true;
        ltstemp.Name = 'temp';
        ltstemp.SetupOwnerId = userinfo.getuserid();
        insert ltstemp;
    
        DCTestData.createData(); 
        opp1id = DCTestdata.oppId;
        acctid = DCTestData.accountId;
        acctssdid = DCTestData.accssdid;
        pboookid = DCTestdata.pBookId;
        cQuoteID = DCTestData.cQuoteID;
        DCTestData.createPaymentCreditWebService();
	    if (mode == 'Corporate') {
	        DCTestData.accountSSDlst.LCRM_Frozen_Market_Segment__c= 'Corp Counsel'; 
	        DCTestData.acct.FrozenMarketSegment__c = 'Corp Counsel';
	        update DCTestData.acct;
	        update DCTestData.accountSSDlst;
	    }
    
  
    list<LCRM_Contact_SSD__c> contactList = new list<LCRM_Contact_SSD__c>();
    Contact testcontact= UnitTest.getContactInstance(acctid);
    LCRM_Contact_SSD__c testContactSSD = new LCRM_Contact_SSD__c();
    testContactSSD = DCTestData.createContactSSD(testcontact,DCTestData.accountSSDlst);
    testContactSSD.LCRM_Last_Name__c = 'testContactSSD';
    testContactSSD.LCRM_First_Name__c = 'testContactSSD';
    testContactSSD.LCRM_Account_SSD__c= acctssdid;
    if (mode == '1' || mode == 'Corporate') {
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
    else if(mode == '41'){
        testContactSSD.LCRM_Email__c = 'testfirst.testlast@thomson.com';
        testContactSSD.LCRM_Job_Function__c = 'Attorney - Associate';
        testContactSSD.LCRM_SAP_Role__c = 'EBILL EMAIL CONTACT';
       
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
    //DLT-12833
    else if(mode == 'Government'){
        testContactSSD.LCRM_Email__c = 'testfirst.testlast@thomson.com';
        testContactSSD.LCRM_Job_Function__c = 'Attorney - Government';
        testContactSSD.LCRM_SAP_Role__c = 'EML PASSWORD CONTACT';
        testContactSSD.LCRM_Hard_Bounce__c = false;
        DCTestData.accountSSDlst.LCRM_Frozen_Market_Segment__c= 'State Government'; 
        DCTestData.acct.FrozenMarketSegment__c = 'State Government';
        update DCTestData.acct;
        update DCTestData.accountSSDlst;
    }
    //Ends
    
    testContactSSD.LCRM_Source_Contact_Id__c= '12345';
    contactList.add(testContactSSD);
    
    Contact testcontact2 = UnitTest.getContactInstance(acctid);
    LCRM_Contact_SSD__c testContactSSD2 = new LCRM_Contact_SSD__c();
    testContactSSD2 = DCTestData.createContactSSD(testcontact2,DCTestData.accountSSDlst);
    testContactSSD2.LCRM_Last_Name__c = 'testContact2';
    testContactSSD2.LCRM_First_Name__c = 'testContact2';
    testContactSSD2.LCRM_Account_SSD__c = acctssdid;
    if (mode =='1' || mode=='Corporate') {
        testContactSSD2.LCRM_Email__c = 'testfirst2.testlast@thomson.com';
        testContactSSD2.LCRM_Job_Function__c = 'Attorney - Associate';
        testContactSSD2.LCRM_SAP_Role__c = 'WL PSWD ACTIVE';
    
    }else if (mode == '2') {
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
        testContactSSD.LCRM_Email__c = 'testfirst.testlast@thomson.com';
        testContactSSD.LCRM_Job_Function__c = 'Other';
        testContactSSD.LCRM_SAP_Role__c = 'EBILL EMAIL CONTACT';
        testContactSSD.LCRM_Hard_Bounce__c = true;
    }
    else if(mode == '41'){
        testContactSSD2.LCRM_Email__c = 'testfirst.testlast@thomson.com';
        testContactSSD2.LCRM_Job_Function__c = 'Attorney - Associate';
        testContactSSD2.LCRM_SAP_Role__c = 'EBILL EMAIL CONTACT';
        testContactSSD2.LCRM_Hard_Bounce__c = true;
    }
    else if(mode == '5'){
        testContactSSD.LCRM_Email__c= 'testfirst.testlast@thomson.com';
        testContactSSD.LCRM_Job_Function__c = 'Other';
        testContactSSD.LCRM_SAP_Role__c = 'SAP - 18 BILLING/ACCT PAYABLE';
    }
    else if(mode == '6'){
        testContactSSD.LCRM_Email__c= 'testfirst.testlast@thomson.com';
        testContactSSD.LCRM_Job_Function__c = 'Other';
        testContactSSD.LCRM_SAP_Role__c = 'EML ORDER CONFIRM';
    }
    else if(mode == '7'){
        testContactSSD.LCRM_Email__c = 'testfirst.testlast@thomson.com';
        testContactSSD.LCRM_Job_Function__c = 'Other';
        testContactSSD.LCRM_SAP_Role__c = 'WL PSWD ACTIVE';
        testContactSSD.LCRM_Hard_Bounce__c = true;
    }
    else if(mode == '99'){
        testcontact.email = 'testfirst.testlast@thomson.com';
        testcontact.Job_Function__c = 'Other';
        testcontact.SAP_Role__c = 'SAP - 18 BILLING/ACCT PAYABLE';
        
    }
    testContactSSD2.LCRM_Source_Contact_Id__c= '12344';
    contactList.add(testContactSSD2);
    
    Contact testcontact3 = UnitTest.getContactInstance(acctid);
    LCRM_Contact_SSD__c testContactSSD3 = new LCRM_Contact_SSD__c();
    testContactSSD3 = DCTestData.createContactSSD(testcontact3,DCTestData.accountSSDlst);
    testContactSSD3.LCRM_Last_Name__c = 'testContact3';
    testContactSSD3.LCRM_First_Name__c = 'testContact3';
    testContactSSD3.LCRM_Account_SSD__c = acctssdid;
   
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
    prodObj = DCTestData.createProduct('Essentials Library — Florida (Westlaw PRO™)','40982845','40974107');
    prodObj.APTS_Media_High_Level_Code__c = '05';        
    prodObj.Productcode = '42009613';
    prodList.add(prodObj);
    
    Product2 prodObj2 = new Product2(); //new sub
    prodObj2 = DCTestData.createProduct('Essentials Library — US (Westlaw PRO™)','40982846','40974108');
    prodObj2.APTS_Media_High_Level_Code__c = '06';       
    prodObj2.Productcode = '42009614';
    prodList.add(prodObj2);
    
    Product2 prodObj4 = new Product2(); //current sub
    prodObj4 = DCTestData.createProduct('Essentials Plus — Alabama (Westlaw PRO™)','41091542','41091475');
    prodObj4.APTS_Media_High_Level_Code__c = '05';        
    prodObj4.Productcode = '42009615';
    prodList.add(prodObj4);
    
    Product2 prodObj3 = new Product2(); //new sub
    prodObj3 = DCTestData.createProduct('SL Missouri Analytical (Westlaw PRO™)','42009560','42009613');
    prodObj3.APTS_Media_High_Level_Code__c = '04';        
    prodObj3.Productcode = '42009616';
    prodList.add(prodObj3); 
        
    update prodList;          
    
    list<Product_Account_Detail__c> prodactdetailList = new list<Product_Account_Detail__c>();
    list<Product_Account_Detail__c> prodactdetailList2 = new list<Product_Account_Detail__c>();
  
		Product_Account_Detail__c prodactdetail1 = new Product_Account_Detail__c();
    	prodactdetail1 = createProductAccountDetail('1004284494','00237KI','40974107');  
    	prodactdetail1.AccountSSD__c= acctssdid;     
     	prodactdetail1.Offer_Price__c = -5;
	    prodactdetailList.add(prodactdetail1);     
    
    	Product_Account_Detail__c prodactdetail2 = new Product_Account_Detail__c();       
	    prodactdetail2 = createProductAccountDetail('1004284494','00237KI','40974108');  
	    prodactdetail2.AccountSSD__c= acctssdid;      
	    prodactdetail2.Hard_Bounce__c = True;
	    prodactdetailList.add(prodactdetail2);
    
	    Product_Account_Detail__c prodactdetail3 = new Product_Account_Detail__c();
	    prodactdetail3 = createProductAccountDetail('1004284494','00237KI','41091475'); 
	    prodactdetail3.AccountSSD__c= acctssdid;
	    prodactdetail3.Hard_Bounce__c = True;
	    prodactdetailList2.add(prodactdetail3);
	     
	    Product_Account_Detail__c prodactdetail4 = new Product_Account_Detail__c();       
	    prodactdetail4 = createProductAccountDetail('1004284494','00237KI','42009613'); 
	    prodactdetail4.AccountSSD__c= acctssdid;       
	    prodactdetail4.Hard_Bounce__c = True;
	    prodactdetailList.add(prodactdetail4);
    
    update prodactdetailList;
    update prodactdetailList2;
    system.debug(logginglevel.INFO, '@@@@ : '+ prodactdetailList); 
    
    set<String> productIds =new set<String>();
    set<Boolean> hardids = new set<Boolean>();
    for(Product_Account_Detail__c p : [select Actual_New_Subscription_Product__c from Product_Account_Detail__c where id in :prodactdetailList]){
        if(p.Actual_New_Subscription_Product__c !=null){
            productIds.add(p.Actual_New_Subscription_Product__c);
        }
    }
    for(Product_Account_Detail__c p : [select Hard_Bounce__c from Product_Account_Detail__c where id in :prodactdetailList]){
        if(p.Hard_Bounce__c !=null){
            hardids.add(p.Hard_Bounce__c);
        }    
    }
    
    List<Apttus_Config2__PriceListItem__c> lstPLis = new List<Apttus_Config2__PriceListItem__c>();
    Pricebook2 pbook1 = new Pricebook2();
        pbook1.name =  'GLI Price Book - FindLaw';
        insert pbook1;
    for(Product2 pod : [select id from product2 where id in :productIds]){
    
        Apttus_Config2__PriceListItem__c pli = new Apttus_Config2__PriceListItem__c();
        pli.Apttus_Config2__PriceListId__c = pbook1.id;
        pli.Apttus_Config2__ProductId__c = pod.id;
        pli.Apttus_Config2__ChargeType__c ='Subscription Fee';
        pli.Apttus_Config2__PriceType__c  = 'Recurring';
        pli.Apttus_Config2__Frequency__c = 'Monthly';
        pli.Apttus_Config2__PriceMethod__c = 'Per Unit';
        pli.Apttus_Config2__PriceUom__c = 'Each';
        pli.Apttus_Config2__Active__c  =true;
        pli.Apttus_Config2__ListPrice__c = 100;
        lstPLis.add(pli);
        
        }
        insert lstPLis;
        
        list<Apttus_Config2__AssetLineItem__c> aliList = new list<Apttus_Config2__AssetLineItem__c>();
        Apttus_Config2__AssetLineItem__c ali = new Apttus_Config2__AssetLineItem__c();
        ali.Name = 'Essentials Library — Florida (Westlaw PRO™)';
        ali.Apttus_Config2__Quantity__c = 1;
        ali.Apttus_Config2__Description__c = 'Test';        
        ali.APTS_SAP_MLA_Agreement_Number__c = '12345678';
        ali.Apttus_Config2__PricingDate__c = System.Today()+2;
        ali.Apttus_Config2__IsPrimaryLine__c = TRUE;
        if (mode =='99') {
            ali.Apttus_Config2__AssetStatus__c = 'Cancelled'; 
        } else {
        	ali.Apttus_Config2__AssetStatus__c = 'Activated';
        }
        ali.Apttus_Config2__AssetStatus__c = 'Activated';
        ali.Apttus_Config2__LineType__c = 'Product/Service';
        ali.Apttus_Config2__LineNumber__c = 1;
        ali.Apttus_Config2__ItemSequence__c = 1;
        ali.Apttus_Config2__ProductId__c = prodObj.id;
        ali.Apttus_Config2__BillToAccountId__c = acctid;
        ali.Apttus_Config2__AccountId__c = acctid;
        ali.APTS_SSD_Sold_To__c = acctssdid;
        ali.Apttus_Config2__ShipToAccountId__c = acctid;
        ali.Apttus_Config2__ChargeType__c = 'Subscription Fee';
        ali.APTS_Contract_Term__c = '3 Years';
        ali.APTS_YoY_Adjustment_Type__c = 'Increase';
        ali.Apttus_Config2__PriceListId__c = pBoookId;
        ali.APTS_Subscription_Number__c = '0974107';
        ali.APTS_Info_RenewalDate__c = System.Today().addDays(20);
        ali.Apttus_Config2__RenewalDate__c = System.Today().addDays(20);
        ali.APTS_Info_PlanType__c = 'R03';
        ali.Apttus_Config2__SellingFrequency__c = 'Monthly';
        ali.Apttus_Config2__SellingTerm__c = 1;
        ali.Apttus_Config2__NetPrice__c = 163;   
        ali.APTS_SSD_Bill_To__c = acctssdid; 
        ali.APTS_SSD_Ship_to__c = acctssdid;  
        ali.Apttus_QPConfig__ProposalId__c = cQuoteID;   
        aliList.add(ali); 
        
        Apttus_Config2__AssetLineItem__c ali2 = new Apttus_Config2__AssetLineItem__c();
        ali2.Name = 'SL Missouri Analytical (Westlaw PRO™)';
        ali2.Apttus_Config2__Quantity__c = 1;
        ali2.Apttus_Config2__Description__c = 'Test';        
        ali2.APTS_SAP_MLA_Agreement_Number__c = '12345678';
        ali2.Apttus_Config2__PricingDate__c = System.Today()+2;
        ali2.Apttus_Config2__IsPrimaryLine__c = TRUE;
        if (mode =='99') {
        	ali.Apttus_Config2__AssetStatus__c = 'Cancelled';
        } else {
        	ali.Apttus_Config2__AssetStatus__c = 'Activated';
        }
        ali2.Apttus_Config2__AssetStatus__c = 'Activated';
        ali2.Apttus_Config2__LineType__c = 'Product/Service';
        ali2.Apttus_Config2__LineNumber__c = 1;
        ali2.Apttus_Config2__ItemSequence__c = 1;
        ali2.Apttus_Config2__ProductId__c = prodObj2.id;
        ali2.Apttus_Config2__BillToAccountId__c = acctid;
        ali2.Apttus_Config2__AccountId__c = acctid;
        ali2.APTS_SSD_Sold_To__c = acctssdid;
        ali2.Apttus_Config2__ShipToAccountId__c = acctid;
        ali2.Apttus_Config2__ChargeType__c = 'Subscription Fee';
        ali2.APTS_Contract_Term__c = '3 Years';
        ali2.APTS_YoY_Adjustment_Type__c = 'Increase';
        ali2.Apttus_Config2__PriceListId__c = pBoookId;
        ali2.APTS_Subscription_Number__c = '41091475';
        ali2.APTS_Info_RenewalDate__c = System.Today().addDays(20);
        ali2.Apttus_Config2__RenewalDate__c = System.Today().addDays(20);
        ali2.APTS_Info_PlanType__c = 'R03';
        ali2.Apttus_Config2__SellingFrequency__c = 'Monthly';
        ali2.Apttus_Config2__SellingTerm__c = 1;
        ali2.Apttus_Config2__NetPrice__c = 163;    
        ali2.APTS_SSD_Bill_To__c = acctssdid; 
        ali2.APTS_SSD_Ship_to__c = acctssdid;  
        ali2.Apttus_QPConfig__ProposalId__c = cQuoteID;    
        aliList.add(ali2); 
   
        insert aliList;
      	Opt1 = [ select id, APTS_Info_RenewalDate__c,Apttus_Config2__AssetStatus__c  from Apttus_Config2__AssetLineItem__c  LIMIT 1];
       
        if(mode=='99'){
            Apttus_Proposal__Proposal__c propManual = new Apttus_Proposal__Proposal__c();
            propManual.Apttus_Proposal__Primary__c = FALSE;
            propManual.Apttus_Proposal__Account__c = acctid;
            propManual.Apttus_Proposal__Opportunity__c = opp1id;
            propManual.Digital_Batch_Processed__c = TRUE;
            propManual.APTS_Order_Confirmation_Contact_Email__c = 'test.test@gmail.com';
            propManual.Digital_Quote_Type__c = 'Manual';
            propManual.Apttus_Proposal__Approval_Stage__c = 'Draft';
            propManual.APTS_MLA_Quote__c = TRUE;
            propManual.Digital_Batch_Processed__c = TRUE;
            propManual.APTS_Proposal_Business_Unit__c = 'SCS';
            insert propManual; 
        }
        return DCTestData.Acct;
    } 
    
  /**
    * @description : method to create Product Account Detail records
    * @param zpNum : zp customer number
    * @param campCode : campaign code
    * @param subNum : subscription number
    * @return Product Account Detail record
    */
    public static Product_Account_Detail__c createProductAccountDetail(string zpNum, string campCode, string subNum) {
        Product_Account_Detail__c prodactdetail = new Product_Account_Detail__c();
        prodactdetail.ZP_Cust_Number__c = zpNum;
        //prodactdetail.AccountSSD__c= ssdId;        
        prodactdetail.Current_Subscription__c = subNum;
        prodactdetail.Premium_New_Service__c = '42009560'; 
        prodactdetail.Premium_New_Subscription__c =  '42009613';     
        prodactdetail.Quantity__c = 1;
        prodactdetail.campaign_code__c = campCode;
        prodactdetail.sub_Campaign_Code__c = campCode;        
        prodactdetail.Renewal_Date__c = System.Today()+1;
        prodactdetail.Product_Pricing_Model__c = 'Banded';
        prodactdetail.SAP_Contact_Id__c = '12345';
        prodactdetail.Hard_Bounce__c = false;
        prodactdetail.Contract_Type__c='Old Mid Contract';
        insert prodactdetail;
        return prodactdetail;  
             
    } 
    
    @istest public static void getDSObjectTest(){
    
        Account acc = CreateacctCommonCode('1');  
        system.debug(logginglevel.INFO, 'Account Info: ' + acc);
        Opportunity opp = [SELECT id, SAP_Account_Number__c,Renewal_date__c,Campaign_Code__c,Digital_MidContract_Status__c
                             FROM Opportunity LIMIT 1];
        Product_Account_Detail__c pad1 = new Product_Account_Detail__c();
        pad1.Renewal_Date__c = opp.Renewal_date__c;
        pad1.Campaign_Code__c = opp.Campaign_Code__c;
        pad1.ZP_Cust_Number__c = opp.SAP_Account_Number__c;
        pad1.Current_Subscription__c = '123456789';
        pad1.Actual_New_Service__c = '123456789';
        pad1.Actual_New_Subscription__c = '123456789';
        pad1.Premium_New_Service__c = '123456789';
        pad1.Premium_New_Subscription__c ='123456789';
        pad1.Type__c = 'Premium';
        insert pad1;
        Test.startTest();
        System.assert(pad1 != null,'DS record is null');
        Digital_ProposalCreationCommonCode.getDSObject('Straight Renewal',opp);
        Digital_ProposalCreationCommonCode.getDSObject('Best Value',opp);
        Digital_ProposalCreationCommonCode.getDSObject('Premium',opp);
        Test.stopTest();
    }
    
    @istest public static void createProposalTestMidContract(){
        Account acc = CreateacctCommonCode('1');  
        Opportunity opp = [SELECT id, Name, Owner.Name, SAP_Account_Number__c,Renewal_date__c,Campaign_Code__c,Digital_MidContract_Status__c,
                            Source_System_Detail__c,AccountId
                             FROM Opportunity LIMIT 1];
        Product_Account_Detail__c pad1 = new Product_Account_Detail__c();
        System.assert(acc!= null,'Assert failed');
        pad1.Renewal_Date__c = opp.Renewal_date__c;
        pad1.Campaign_Code__c = opp.Campaign_Code__c;
        pad1.ZP_Cust_Number__c = opp.SAP_Account_Number__c;
        pad1.Current_Subscription__c = '123456789';
        pad1.Actual_New_Service__c = '123456789';
        pad1.Actual_New_Subscription__c = '123456789';
        pad1.Premium_New_Service__c = '123456789';
        pad1.Premium_New_Subscription__c ='123456789';
        pad1.Type__c = 'Premium';
        pad1.Contract_Type__c = 'Mid Contract';
        Test.startTest();
        Digital_ProposalCreationCommonCode.createProposal(opp,'Straight Renewal', pad1);
        Digital_ProposalCreationCommonCode.createProposal(opp,'Best Value', pad1);
        Digital_ProposalCreationCommonCode.createProposal(opp,'Premium', pad1);
        Test.stopTest();
    }
}