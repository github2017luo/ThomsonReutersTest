/*
 * This test class has westlaw service related to SAP Account Number and returns corresponding OppID, Acc ID and Trial Data for Main Class - WestLawOpptyDetails 
 * 
 * CHANGE HISTORY
 * ==================================================================================================================================
 * Date         Name                    Description
 * 2020-08-05   Rahul Natarajan         DLT-20503   [PL] [REN][SFDC] Add Subcampagn Code Field and Made Few PMD fixes
 * 2021-02-23   Ameeta Antonio          DLT-21440 - [SFDC][REN][ML] In product Renewal Prompt and fixed PMD errors.
=================================================================================================================================
 */

@isTest
private class DCPRenewalInProductTest {

    @testsetup
    static void testdata() {
        Profile p1 = [SELECT Id FROM Profile WHERE Name =: 'ANZ Users'];
        User u = [Select ID, Sales_Org__c FROM User where Sales_Org__c = 'LRA'
            AND Profile.id =: p1.id limit 1
        ];
        Map < String, Schema.RecordTypeInfo > recordTypes = Opportunity.sObjectType.getDescribe().getRecordTypeInfosByName();
        Id optyPipeRecTypeId = recordTypes.get('Pipeline Opportunity').getRecordTypeId();
        Id optyPreRecTypeID = recordTypes.get('Pre-Pipeline Opportunity').getRecordTypeId();
        System.debug(LoggingLevel.INFO,'Pipeline' + optyPipeRecTypeId + 'Pre-pipeline' + optyPreRecTypeID);

        KeyValueListStore__c kvs = new KeyValueListStore__c();
        kvs.name = 'ANZUsersProfileId';
        kvs.TextValue__C = System.Label.Digital_ANZ_User_Profile_Id;
        KeyValueListStore__c kvs1 = new KeyValueListStore__c();
        kvs1.name = 'LCRMMergeOpportunityPageSize';
        kvs1.TextValue__C = '20';
        KeyValueListStore__c kvs2 = new KeyValueListStore__c();
        kvs2.name = 'LCRMMergeOpportunityExcludeStage';
        kvs2.TextValue__C = 'Contract Signed,Order Complete,Closed Lost';
        KeyValueListStore__c oStore2 = new KeyValueListStore__c();
        oStore2.Name = 'AptsOpportunityWinLoss';
        oStore2.TextValue__c = 'Won';
        KeyValueListStore__c oStore3 = new KeyValueListStore__c();
        oStore3.Name = 'AptsOpportunityCompetitor';
        oStore3.TextValue__c = 'Unknown';
        KeyValueListStore__c oStore4 = new KeyValueListStore__c();
        oStore4.Name = 'AptsOpportunityReason';
        oStore4.TextValue__c = 'Other';
        KeyValueListStore__c keyval1 = new KeyValueListStore__c();
        keyval1.Name = 'ReasonWithCompetitor';
        keyval1.TextValue__c = 'Price';
        insert new List < KeyValueListStore__c > {
            kvs,
            kvs1,
            kvs2,
            oStore2,
            oStore3,
            oStore4,
            keyval1
        };

        //*** START :: Added by Rajan :: DLT-10215 - added to fix deployment failure suggested by Priyanka Pawar
        List < WebServiceSettings__c > webserviceList = new List < WebServiceSettings__c > {
            new WebServiceSettings__c(Name = 'EnterpriseWSDL', Endpoint__c = 'https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount', Service_Unavailable_Message__c = 'Service not Available'),
            new WebServiceSettings__c(Name = 'StatusPostbackLocation', Endpoint__c = 'https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount', Service_Unavailable_Message__c = 'Service not Available'),
            new WebServiceSettings__c(Name = 'PostbackLocation', Endpoint__c = 'https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount', Service_Unavailable_Message__c = 'Service not Available'),
            new WebServiceSettings__c(Name = 'Payment AutoCharge', Endpoint__c = 'https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount', Service_Unavailable_Message__c = 'Service not Available'),
            new WebServiceSettings__c(Name = 'PaymentCreditIncrease', Endpoint__c = 'https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount', Service_Unavailable_Message__c = 'Service not Available')
        };
        insert webserviceList;
        //*** END :: Added by Rajan :: DLT-10215 - added to fix deployment failure suggested by Priyanka Pawar

        // create Account
        List < Account > acclist = new List < Account > ();
        Account acct = new Account();
        acct = UnitTest.getAccountInstance();
        acct.Phone = '123456';
        acct.Website = 'test.website@email.xxx';
        acct.SAPAccountNumber__c = '1004284494';
        acct.Trial_Status__c = 'Invited';
        //*** START :: Added by Rajan :: DLT-10215 - Enable/Disable In Product Notifications
        acct.Disable_In_Product_Notifications__c = false;
        //*** END :: Added by Rajan :: DLT-10215 - Enable/Disable In Product Notifications
        acclist.add(acct);

        Account acctexpired = new Account();
        acctexpired = UnitTest.getAccountInstance();
        acctexpired.Phone = '123456';
        acctexpired.Website = 'test.website@email.xxx';
        acctexpired.SAPAccountNumber__c = '1000212139';
        acctexpired.Trial_Status__c = 'Expired';
        acclist.add(acctexpired);

        insert acclist;

        List < RecordtypeIds__c > recTList = new List < RecordtypeIds__c > ();
        RecordtypeIds__c recT = new RecordtypeIds__c();
        recT.name = 'Pre-Pipeline Opportunities';
        recT.recTypeId__C = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Pre-Pipeline Opportunity').getRecordTypeId();
        recTList.add(recT);
        RecordtypeIds__c recT1 = new RecordtypeIds__c();
        recT1.Name = 'Pipeline Opportunities';
        recT1.recTypeId__C = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Pipeline Opportunity').getRecordTypeId();
        recTList.add(recT1);
        insert recTList;

        Pricebook2 pbook = new Pricebook2();
        pbook.name = 'Standard Price Book';
        insert pbook;

        // Confirmation Contact
        Contact newContact = new Contact();
        newContact.FirstName = 'Test';
        newContact.LastName = 'User1';
        newContact.Email = 'test.user1@email.xxx';
        newContact.AccountId = acct.Id;
        newContact.ContactPrimaryUserFlag__c = True;
        insert newContact;

        List < Source_System_Detail__c > ssdList = new List < Source_System_Detail__c > ();

        Source_System_Detail__c ssdacc = new Source_System_Detail__c();
        ssdacc.Account_Name__c = acct.id;
        ssdacc.Account_Inactive__c = false;
        ssdacc.Trial_Status__c = 'Invited';
        ssdacc.LCRM_Sales_Org__c = 'WEST';
        ssdacc.Source_System_Account_Number__c = '1004284494';
        ssdacc.name = 'test';
        ssdacc.Source_System_Name__c = 'test';
        ssdacc.BU_Segment_Level_2__c = 'SLF 11-20';
        ssdList.add(ssdacc);
        
         Source_System_Detail__c ssdacc1 = new Source_System_Detail__c();
        ssdacc1.Account_Name__c = acct.id;
        ssdacc1.Account_Inactive__c = false;
        ssdacc1.Trial_Status__c = 'Invited';
        ssdacc1.LCRM_Sales_Org__c = 'WEST';
        ssdacc1.Source_System_Account_Number__c = '1004284499';
        ssdacc1.name = 'test';
        ssdacc1.Source_System_Name__c = 'test';
        ssdacc1.BU_Segment_Level_2__c = 'Medium Law';
        ssdList.add(ssdacc1);
           

        Source_System_Detail__c ssdaccexpired = new Source_System_Detail__c();
        ssdaccexpired.Account_Name__c = acctexpired.id;
        ssdaccexpired.Source_System_Account_Number__c = '1000212139';
        ssdaccexpired.name = 'test';
        ssdaccexpired.Source_System_Name__c = 'test';
        ssdList.add(ssdaccexpired);

        //Start: DLT-11317 ----Added by Harshitha for CXD ODT
        Source_System_Detail__c ssdaccODT = new Source_System_Detail__c();
        ssdaccODT.Account_Name__c = acct.id;
        ssdaccODT.Account_Inactive__c = false;
        ssdaccODT.Trial_Status__c = '';
        ssdaccODT.LCRM_Sales_Org__c = 'WEST';
        ssdaccODT.Source_System_Account_Number__c = '1004284485';
        ssdaccODT.name = 'testODT';
        ssdaccODT.Source_System_Name__c = 'testODTY';
        ssdaccODT.BU_Segment_Level_2__c = 'Corporation National Accounts';
        ssdList.add(ssdaccODT);

        insert ssdList;

        List < Trial__c > trialList = new List < Trial__c > ();

        Trial__c t1 = new Trial__c();
        t1.Trial_Status__c = 'Expired';
        t1.Trial_Id__c = '76656';
        t1.Trial_start_Date__c = System.today() - 200;
        t1.Trial_End_Date__c = System.today() - 190;
        t1.Account_Name__c = acctexpired.Id;
        t1.Source_System_Detail__c = ssdaccODT.id;
        trialList.add(t1);
        Trial__c t2 = new Trial__c();
        t2.Trial_Status__c = 'Accepted';
        t2.Trial_Id__c = '76656';
        t2.Trial_start_Date__c = System.today() - 200;
        t2.Trial_End_Date__c = System.today() - 190;
        t2.Account_Name__c = acctexpired.Id;
        t2.Source_System_Detail__c = ssdaccODT.id;
        trialList.add(t2);
        Trial__c t3 = new Trial__c();
        t3.Trial_Status__c = 'Timed-out';
        t3.Trial_Id__c = '76656';
        t3.Trial_start_Date__c = System.today() - 200;
        t3.Trial_End_Date__c = System.today() - 190;
        t3.Account_Name__c = acctexpired.Id;
        t3.Source_System_Detail__c = ssdaccODT.id;
        trialList.add(t3);
        insert trialList;
        //End: DLT-11317 

        List < LCRM_Contact_SSD__c > lcSSDList = new List < LCRM_Contact_SSD__c > ();
        LCRM_Contact_SSD__c c1 = new LCRM_Contact_SSD__c();
        c1.name = 'Testcontssd1';
        c1.LCRM_Account_SSD__c = ssdacc.id;
        c1.LCRM_Contact_ID__c = '12345';
        c1.LCRM_Contact__c = newContact.id;
        lcSSDList.add(c1);

        LCRM_Contact_SSD__c c1exp = new LCRM_Contact_SSD__c();
        c1exp.name = 'Testcontssd1';
        c1exp.LCRM_Account_SSD__c = ssdaccexpired.id;
        c1exp.LCRM_Contact_ID__c = '12345';
        lcSSDList.add(c1exp);

        insert lcSSDList;

        Test.startTest();
        // create opportunity
        Opportunity opp = new Opportunity();
        opp.Name = 'Test Opportunity WestLaw';
        opp.AccountId = acct.Id;
        opp.Source_System_Detail__c = ssdacc.id;
        opp.sub_Campaign_Code__c = 'Hello';
        opp.Renewal_Date__c = System.today();
        opp.StageName = '10%';
        opp.CloseDate = System.today().addMonths(1);
        opp.isDigitalSpearHead__c = TRUE;
        //*** START :: Added by Rajan :: DLT-11707 - Utilizing Digitally reviewed flag for suppressing in-product notification when Renewal offer not reviewed and approved
        opp.Digital_Review_Complete__c = TRUE;
        //*** END :: Added by Rajan :: DLT-11707 - Utilizing Digitally reviewed flag for suppressing in-product notification when Renewal offer not reviewed and approved
        opp.RecordTypeId = optyPipeRecTypeId;
        System.debug(LoggingLevel.INFO,'@@@@Record' + optyPipeRecTypeId);
        opp.Pricebook2 = pBook;
        System.debug(LoggingLevel.INFO,'@@@@Pricebook' + pBook);
        opp.Renewal_Date__c = System.Today();
        opp.OwnerId = u.id;
        insert opp;

        // create Proposal
        Apttus_Proposal__Proposal__c q = new Apttus_Proposal__Proposal__c();
        q.Apttus_Proposal__Proposal_Name__c = 'Q345';
        //*** START :: Added by Rajan :: DLT-10853 - Ensure In-Product WESTLAW notifications do not appear based on certain Proposal types
        q.Apttus_Proposal__Approval_Stage__c = 'Presented';
        //*** END :: Added by Rajan :: DLT-10853 - Ensure In-Product WESTLAW notifications do not appear based on certain Proposal types
        q.Apttus_Proposal__Opportunity__c = opp.Id;
        q.APTS_Order_Confirmation_Contact__c = newContact.Id;
        q.Apttus_Proposal__Primary__c = true;
        q.Apttus_Proposal__Account__c = acct.Id;

        //*** START :: Added by Rajan :: DLT-10853 - Ensure In-Product WESTLAW notifications do not appear based on certain Proposal types 
        q.Digital_Quote_Type__c = 'Best Value';
        q.Contract_Type__c = 'NTO';
        q.Apttus_Proposal__Approval_Stage__c='Presented';
        q.Apttus_Proposal__Primary__c=TRUE;
        q.APTS_Proposal_Business_Unit__c='SCS';
        //*** END :: Added by Rajan :: DLT-10853 - Ensure In-Product WESTLAW notifications do not appear based on certain Proposal types 
        insert q;
       

        // create Proposal Line Item
        Apttus_Proposal__Proposal_Line_Item__c lineItem = new Apttus_Proposal__Proposal_Line_Item__c();
        lineItem.Apttus_Proposal__Proposal__c = q.Id;
        lineItem.Apttus_QPConfig__LineNumber__c = 1;
        insert lineItem;
      
        //create Trial Record
        Trial__c t = new Trial__c();
        t.Trial_Status__c = 'Timed-out';
        t.Trial_Id__c = '76656';
        t.Trial_End_Date__c = System.today();
        t.Account_Name__c = acct.id;
        t.Source_System_Detail__c = ssdacc.id;
        insert t;

        Test.stopTest();
    }


    static testMethod void testAccOptyWrapper() {
        // createTestRecord();
        //DataFactoryClass.globalSetupMethod();
        Test.startTest();
        RestRequest request = new RestRequest();
        //request.requestUri = 'https://cs65.salesforce.com/services/apexrest/westLawOpportunity/';
        request.httpMethod = 'GET';
        request.params.put('sapAccountNum', '1004284494');
        RestContext.request = request;
        //response.addHeader("Content-type", "application/json");
        DCPRenewalInProduct.InProductServiceWrapper resp = DCPRenewalInProduct.doGet();
        System.assert(resp != null, 'Valid Response');  

        //End:DLT-11317
        Test.stopTest();
    }
     

    static testMethod void testAccOptyWrapperWithNoOppty() {
        //createTestRecordWithNoOppty();
        // DataFactoryClass.globalSetupMethod();
        Test.startTest();
        RestRequest request = new RestRequest();
        request.httpMethod = 'GET';
        request.params.put('sapAccountNum', '1000212139');
        RestContext.request = request;
        DCPRenewalInProduct.InProductServiceWrapper resp = DCPRenewalInProduct.doGet();
        System.assert(resp != null, 'Valid Response');

        Test.stopTest();

    }
     static testMethod void testAccOptyWrapperWithNoOppty1() {
        //createTestRecordWithNoOppty();
        // DataFactoryClass.globalSetupMethod();
        Test.startTest();
        RestRequest request = new RestRequest();
        request.httpMethod = 'GET';
        request.params.put('sapAccountNum', '1004284499');
        RestContext.request = request;
        DCPRenewalInProduct.InProductServiceWrapper resp = DCPRenewalInProduct.doGet();
        System.assert(resp != null, 'Valid Response');

        //End:DLT-11317
        Test.stopTest();

    }

    //Start:DLT-11317 ----Added by Harshitha for CXD ODT
    static testMethod void testODTAccTrialWrapperWithExpCORP() {
        //createTestRecordWithNoOppty();
        // DataFactoryClass.globalSetupMethod();
        Test.startTest();
        RestRequest request = new RestRequest();
        request.httpMethod = 'GET';
        request.params.put('sapAccountNum', '1004284485');
        RestContext.request = request;
        DCPRenewalInProduct.InProductServiceWrapper resp = DCPRenewalInProduct.doGet();
        System.assert(resp != null, 'Valid Response');
        Test.stopTest();
    }
    //End:DLT-11317
}