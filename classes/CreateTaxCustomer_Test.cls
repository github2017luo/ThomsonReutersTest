/**
 * Test class to validate the functionality provided by the createCustomer class 
 *

 * CHANGE HISTORY
 * =================================================================================================================================================
 * Date         Name                    Description
 * 2019-09-07   Gokila              Created    
      
 * =================================================================================================================================================
**/

@isTest(SeeAlldata=false)
/**
     * @description CreateTaxCustomer_Test
     */
public class CreateTaxCustomer_Test{ 
    /**
     * @description testCreateCustomer
     */
    public static testMethod void testCreateCustomer() {
    
        Apttus_Config2__PriceList__c priceList = APTS_TestDataFactory.createPriceList('Thomson Reuters Master - US Legal');
        insert priceList;
                
        List<KeyValueListStore__c> keyvaluestoreList=new List<KeyValueListStore__c>();
        KeyValueListStore__c keyvaluestore=new  KeyValueListStore__c();
        keyvaluestore.Name='ANZUsersProfileId';
        keyvaluestore.TextValue__c=System.Label.APTS_OC_Test_Id;
        
        KeyValueListStore__c lCRMStrikeIronFlagINS1 = new KeyValueListStore__c();
        lCRMStrikeIronFlagINS1.Name='LCRMDisableStrikeIronServices';
        lCRMStrikeIronFlagINS1.TextValue__c='True';
        keyvaluestoreList.add(lCRMStrikeIronFlagINS1);
        keyvaluestoreList.add(keyvaluestore);
        
        KeyValueListStore__c keyval = new KeyValueListStore__c();
        keyval.Name='ReasonWithCompetitor';
        keyval.TextValue__c='Price';
        keyvaluestoreList.add(keyval);
        insert keyvaluestoreList;
        
        List<RecordtypeIds__c> recordlist=new List<RecordtypeIds__c>();
        RecordtypeIds__c recordtype=new RecordtypeIds__c();
        recordtype.Name='Pre-Pipeline Opportunities';
        recordtype.recTypeId__c=System.Label.APTS_OC_Test_Id;
        recordlist.add(recordtype);
        
        RecordtypeIds__c recordtype1=new RecordtypeIds__c();
        recordtype1.Name='Pipeline Opportunities';
        recordtype1.recTypeId__c=System.Label.APTS_OC_Test_Id;
        recordlist.add(recordtype1);
        insert recordlist;
        
        Account oAccount = new Account();
        oAccount.Name = 'Unit Test';
        //oAccount.Sales_Org__c = 'WEST';
        oAccount.Customer_Type__c = 'Individual';
        oAccount.Customer_Group__c = 'ACADEMIC';
        oAccount.Industry = 'TAX';
        
        oAccount.BillingStreet = '275 BATTERY ST STE 1500';
        oAccount.BillingCity = 'SAN FRANCISCO';
        oAccount.BillingState = 'CA';
        oAccount.BillingPostalCode = '94111-3334';
        oAccount.BillingCountry = 'US';
        oAccount.BU_Segment__c = 'Professional Tax';
        
        oAccount.Is_Customer_Review_Complete__c=true;
        insert oAccount;
        System.assertequals('Unit Test',oAccount.Name,'Success');
        
        
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByDeveloperName().get('LatAm_Source_Systems').getRecordTypeId();
        Source_System_Detail__c accountSSD= new Source_System_Detail__c();
        accountSSD.RecordtypeId=ssdRecorType;
        accountSSD.Name='ABC';
        accountSSD.Source_System_Name__c='ABC';
        accountSSD.Account_Name__c=oAccount.ID;
        accountSSD.Account_Inactive__c=false;
        accountSSD.LCRM_Customer_Group__c='Academic';
        accountSSD.Source_System_Account_Number__c='11111112';
        accountSSD.LCRM_SAP_Account_Number__c ='11111112';
        accountSSD.LCRM_Sales_Org__c='S100';
        insert accountSSD;
        
        
        Opportunity oOpportunity = new Opportunity();
        oOpportunity.AccountId = oAccount.Id;
        oOpportunity.Name = 'Unit Test Opportuntiy';
        oOpportunity.CloseDate = System.Today() + 5;
        oOpportunity.StageName = '10%';
        oOpportunity.Source_System_Detail__c = accountSSD.id;
        insert oOpportunity;
        
        Id propRecorType=Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Proposal').getRecordTypeId();
        Apttus_Proposal__Proposal__c proposal = APTS_TestDataFactory.createProposal(oOpportunity.id,oAccount.Id);
        proposal.Apttus_Proposal__Approval_Stage__c='Draft';
        proposal.APTS_Proposal_Business_Unit__c='Tax Professional';
        proposal.RecordtypeId = propRecorType;
        proposal.Apttus_Proposal__Opportunity__c = oOpportunity.id;
        proposal.APTS_SSD_Sold_To__c = accountSSD.Id;
        proposal.Apttus_Proposal__Account__c = oAccount.Id;
        proposal.Apttus_Proposal__Primary__c = true;
        proposal.APTS_SSD_bill_to__c = accountSSD.Id;
        proposal.APTS_SSD_ship_to__c = accountSSD.Id;
       // proposal.APTS_Agreement_Language__c = 'English';
        insert proposal; 
         
        Apttus_Config2__ProductConfiguration__c prodConfig = APTS_TestDataFactory.createProductConfiguration(proposal.Id);
        prodConfig.Apttus_Config2__BusinessObjectType__c = 'Proposal';
        insert prodConfig;
        
        test.StartTest();
        // Create a new email and envelope object
        Messaging.InboundEmail email = new Messaging.InboundEmail();
        Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
        
        // Create the email body
        email.plainTextBody = 'This should become a note';
        email.fromAddress ='test@test.com';
        email.ccAddresses = new String[] {'sapquotecreation@m-27qvut4jdjntz8djm7d9jbgfbw2qd3hmp2rgyhfdy46ucrmste.q-5ncfma2.q.apex.sandbox.salesforce.com'};   
       
        
        email.subject = 'CreateSoldToTaxCustomer:>'+proposal.Id+':'+accountSSD.id;
        TaxSAPCustomerQuoteCreateServiceHandler oTestEmailHandler2 = new TaxSAPCustomerQuoteCreateServiceHandler();
        Messaging.InboundEmailResult oTestResult2 = new Messaging.InboundEmailresult();
        oTestResult2 = oTestEmailHandler2.handleInboundEmail(email, env);
        
               
        //state/region is blank
        oAccount.BillingState = '';
        update oAccount;
        
       
        test.StopTest();
        //----------code coverage for other classes generated from wsdl
        /*ecomTocServicesThomsonCom20Common oCommon = new ecomTocServicesThomsonCom20Common();
        ecomTocServicesThomsonCom20Common.Confirmation oConfirmation = new ecomTocServicesThomsonCom20Common.Confirmation();
        ecomTocServicesThomsonCom20Common.EcomResponse oEcomResponse = new ecomTocServicesThomsonCom20Common.EcomResponse();
        ecomTocServicesThomsonCom20Common.ConfirmationResponse oConfirmationResponse = new ecomTocServicesThomsonCom20Common.ConfirmationResponse();
        ecomTocServicesThomsonCom20Common.Property oProperty = new ecomTocServicesThomsonCom20Common.Property();
        ecomTocServicesThomsonCom20Common.CallbackEvent oCallbackEvent = new ecomTocServicesThomsonCom20Common.CallbackEvent();
        ecomTocServicesThomsonCom20Common.EcomSystemError oEcomSystemError = new ecomTocServicesThomsonCom20Common.EcomSystemError();
        ecomTocServicesThomsonCom20Common.Notification oNotification = new ecomTocServicesThomsonCom20Common.Notification();
        ecomTocServicesThomsonCom20Common.EcomContext oEcomContext = new ecomTocServicesThomsonCom20Common.EcomContext();
        ecomTocServicesThomsonCom20Common.EcomValidationError oEcomValidationError = new ecomTocServicesThomsonCom20Common.EcomValidationError();
        ecomTocServicesThomsonCom20Common.User_x oUserx = new ecomTocServicesThomsonCom20Common.User_x();
        ecomTocServicesThomsonCom20Common.EcomRequest oEcomRequest = new ecomTocServicesThomsonCom20Common.EcomRequest();
        ecomTocServicesThomsonCom20Common.Address oAddress = new ecomTocServicesThomsonCom20Common.Address();
        ecomTocServicesThomsonCom20Common.EcomServiceError oEcomServiceError = new ecomTocServicesThomsonCom20Common.EcomServiceError();
        ecomTocServicesThomsonCom20Common.EcomError oEcomError = new ecomTocServicesThomsonCom20Common.EcomError();
        ecomTocServicesThomsonCom20Common.UserContext oUserContext = new ecomTocServicesThomsonCom20Common.UserContext();*/
    }
     /**
     * @description testUpdateOrderOnCaseClosed
     */
    public static testMethod void testUpdateOrderOnCaseClosed() {
        
        Apttus_Config2__PriceList__c priceList = APTS_TestDataFactory.createPriceList('Thomson Reuters Master - US Legal');
        insert priceList;
        
        List<KeyValueListStore__c> keyvaluestoreList=new List<KeyValueListStore__c>();
        KeyValueListStore__c keyvaluestore=new  KeyValueListStore__c();
        keyvaluestore.Name='ANZUsersProfileId';
        keyvaluestore.TextValue__c=System.Label.APTS_OC_Test_Id;
        
        KeyValueListStore__c lCRMStrikeIronFlagINS1 = new KeyValueListStore__c();
        lCRMStrikeIronFlagINS1.Name='LCRMDisableStrikeIronServices';
        lCRMStrikeIronFlagINS1.TextValue__c='True';
        keyvaluestoreList.add(lCRMStrikeIronFlagINS1 );
        keyvaluestoreList.add(keyvaluestore);
        
        KeyValueListStore__c keyval = new KeyValueListStore__c();
        keyval.Name='ReasonWithCompetitor';
        keyval.TextValue__c='Price';
        keyvaluestoreList.add(keyval);
        insert keyvaluestoreList;
        
        List<RecordtypeIds__c> recordlist=new List<RecordtypeIds__c>();
        RecordtypeIds__c recordtype=new RecordtypeIds__c();
        recordtype.Name='Pre-Pipeline Opportunities';
        recordtype.recTypeId__c=System.Label.APTS_OC_Test_Id;
        recordlist.add(recordtype);
        
        RecordtypeIds__c recordtype1=new RecordtypeIds__c();
        recordtype1.Name='Pipeline Opportunities';
        recordtype1.recTypeId__c=System.Label.APTS_OC_Test_Id;
        recordlist.add(recordtype1);
        insert recordlist;
        
        Account oAccount = new Account();
        oAccount.Name = 'Unit Test';
        //oAccount.Sales_Org__c = 'WEST';
        oAccount.Customer_Type__c = 'Individual';
        oAccount.Customer_Group__c = 'ACADEMIC';
        oAccount.Industry = 'TAX';
        
        oAccount.BillingStreet = '275 BATTERY ST STE 1500';
        oAccount.BillingCity = 'SAN FRANCISCO';
        oAccount.BillingState = 'CA';
        oAccount.BillingPostalCode = '94111-3334';
        oAccount.BillingCountry = 'US';
        oAccount.BU_Segment__c = 'Professional Tax';        
        oAccount.Is_Customer_Review_Complete__c=true;
        insert oAccount;
        
        System.assertequals('Unit Test',oAccount.Name,'Success');        
        
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByDeveloperName().get('LatAm_Source_Systems').getRecordTypeId();
        Source_System_Detail__c accountSSD= new Source_System_Detail__c();
        accountSSD.RecordtypeId=ssdRecorType;
        accountSSD.Name='ABC';
        accountSSD.Source_System_Name__c='ABC';
        accountSSD.Account_Name__c=oAccount.ID;
        accountSSD.Account_Inactive__c=false;
        accountSSD.LCRM_Customer_Group__c='Academic';
        accountSSD.Source_System_Account_Number__c='11111112';
        accountSSD.LCRM_SAP_Account_Number__c ='11111112';
        accountSSD.LCRM_Sales_Org__c='S100';
        insert accountSSD;        
        
        Opportunity oOpportunity = new Opportunity();
        oOpportunity.AccountId = oAccount.Id;
        oOpportunity.Name = 'Unit Test Opportuntiy';
        oOpportunity.CloseDate = System.Today() + 5;
        oOpportunity.StageName = '10%';
        oOpportunity.Source_System_Detail__c = accountSSD.id;
        insert oOpportunity;
        
        Id propRecorType=Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Proposal').getRecordTypeId();
        Apttus_Proposal__Proposal__c proposal = APTS_TestDataFactory.createProposal(oOpportunity.id,oAccount.Id);
        proposal.Apttus_Proposal__Approval_Stage__c='Draft';
        proposal.APTS_Proposal_Business_Unit__c='Tax Professional';
        proposal.RecordtypeId = propRecorType;
        proposal.Apttus_Proposal__Opportunity__c = oOpportunity.id;
        proposal.APTS_SSD_Sold_To__c = accountSSD.Id;
        proposal.Apttus_Proposal__Account__c = oAccount.Id;
        proposal.Apttus_Proposal__Primary__c = true;
        proposal.APTS_SSD_bill_to__c = accountSSD.Id;
        proposal.APTS_SSD_ship_to__c = accountSSD.Id;       
        insert proposal; 
        
        Apttus_Config2__ProductConfiguration__c prodConfig = APTS_TestDataFactory.createProductConfiguration(proposal.Id);
        prodConfig.Apttus_Config2__BusinessObjectType__c = 'Proposal';
        insert prodConfig;
        
        Apttus_Config2__Order__c orderRec = APTS_TestDataFactory.createOrder('Pending', 0, accountSSD.ID);        
        orderRec.Apttus_QPConfig__ProposalId__c=proposal.ID;
        orderRec.APTS_SAP_Status__c ='Case Created';
        insert orderRec;

        //test.StartTest();
        // Create a new email and envelope object
        Messaging.InboundEmail email = new Messaging.InboundEmail();
        Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();        
        // Create the email body
        email.plainTextBody = 'This should become a note';
        email.fromAddress ='test@test.com';
        email.ccAddresses = new String[] {'sapquotecreation@m-27qvut4jdjntz8djm7d9jbgfbw2qd3hmp2rgyhfdy46ucrmste.q-5ncfma2.q.apex.sandbox.salesforce.com'};   
            
        email.subject = 'UpdateOrderForClosedCase:>'+':'+orderRec.id;
        test.StartTest();
        TaxSAPCustomerQuoteCreateServiceHandler oTestEmailHandler2 = new TaxSAPCustomerQuoteCreateServiceHandler();
        Messaging.InboundEmailResult oTestResult2 = new Messaging.InboundEmailresult();
        oTestResult2 = oTestEmailHandler2.handleInboundEmail(email, env);
        
        test.StopTest();
        
    }
}