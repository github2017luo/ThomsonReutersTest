/***************************************************************************************************
    CLASS NAME  : Digital_CXD_FlowTest
    DESCRIPTION : Test Class for Increasing Flow Coverage for Digital CXD Process Builders
    Authors:
        CXD Development Team
    Process Builders Covered
        1)ODT_IC_trial_status_update
        2)Digital_Post_Accept_Attachment
        3)ODT_Activity_Creation_at_Account_Level
        4)Ecom_Remove_Abandoned
        5)Digital_Offer_URL_Update_in_Opportunity
        6)NSE_Opp_Owner_Email_Alert
***************************************************************************************************
Change History
        Jira            Date            Developer           Description
1)      DLT-20253       01-07-2020      Rahul Natarajan     Covered Process Builders 1 and 2
2)      DLT-20261       27-07-2020      Rahul Natarajan     Covered Process Builders 3,4,5,6
1)      DLT-20483       06-08-2020      Benjamin Her        Updated coverage for Process Builder 5     
        DLT-21865       06-10-2021      Brenda Shields      Updated Coverage for Digital Offer URL Update in Opportunity
====================================================================================================*/
/** 
 * @description : Test Class for Process Builder Flows
 */
@isTest
public class Digital_CXD_FlowTest {
    // Test Data for all test methods
    @testSetup static void digitalFlowRecordsCreation() {

        List < Trial__c > trialList = new List < Trial__c > ();
        List < Invite_Colleagues__c > icList = new List < Invite_Colleagues__c > ();
        List < Account > acclist = new List < Account > ();
        List < Contact > conList = new List < Contact > ();
        List < Source_System_Detail__c > ssdList = new List < Source_System_Detail__c > ();
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
        insert new List < KeyValueListStore__c > { kvs,kvs1,kvs2,oStore2,oStore3,oStore4,keyval1 };
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

         List<WebServiceSettings__c > webServiceList = new List<WebServiceSettings__c > {
            new WebServiceSettings__c(Name = 'EnterpriseWSDL', Endpoint__c = 'https://api.thomsonreuters.com/ebs/entitlement/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount', Service_Unavailable_Message__c = 'Service not Available'),
            new WebServiceSettings__c(Name = 'StatusPostbackLocation', Endpoint__c = 'https://api.thomsonreuters.com/ebs/entitlement/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount', Service_Unavailable_Message__c = 'Service not Available'),
            new WebServiceSettings__c(Name = 'PostbackLocation', Endpoint__c = 'https://api.thomsonreuters.com/ebs/entitlement/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount', Service_Unavailable_Message__c = 'Service not Available'),
            new WebServiceSettings__c(Name = 'PaymentCreditIncrease', Endpoint__c = 'https://api.thomsonreuters.com/ebs/entitlement/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount', Service_Unavailable_Message__c = 'Service not Available'),
            new WebServiceSettings__c(Name = 'Payment AutoCharge', Endpoint__c = 'https://api.thomsonreuters.com/ebs/entitlement/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount', Service_Unavailable_Message__c = 'Service not Available')
        };
        insert webServiceList;

        Account ac0 = new Account();
        ac0.Name = 'Test Account0';
        ac0.Email__c = 'testaccount1@thomsonreuters.com';
        ac0.Phone = '9876543210';
        ac0.RecordTypeId = Schema.Sobjecttype.Account.getRecordTypeInfosByName().get('GLI Account').getRecordTypeId();
        ac0.Bu_Segment__c = 'Government';
        acclist.add(ac0);
        Account ac1 = new Account();
        ac1.Name = 'Test Account1';
        ac1.Email__c = 'testaccount1@thomsonreuters.com';
        ac1.Phone = '9876543210';
        ac1.RecordTypeId = Schema.Sobjecttype.Account.getRecordTypeInfosByName().get('GLI Account').getRecordTypeId();
        ac1.Bu_Segment__c = 'Government';
        acclist.add(ac1);
        Account ac2 = new Account();
        ac2.Name = 'Test Account2';
        ac2.Email__c = 'testaccount1@thomsonreuters.com';
        ac2.Phone = '9876543210';
        ac2.RecordTypeId = Schema.Sobjecttype.Account.getRecordTypeInfosByName().get('GLI Account').getRecordTypeId();
        ac2.Bu_Segment__c = 'Government';
        acclist.add(ac2);
        insert acclist;

        Contact con1 = new Contact();
        con1.FirstName = 'Test';
        con1.LastName = 'Contact1';
        con1.AccountId = ac0.Id;
        con1.Email = 'testcontact1@thomsonreuters.com';
        con1.Phone = '9876543210';
        conList.add(con1);
        Contact con2 = new Contact();
        con2.FirstName = 'Test';
        con2.LastName = 'Contact2';
        con2.AccountId = ac1.Id;
        con2.Email = 'testcontact1@thomsonreuters.com';
        con2.Phone = '9876543210';
        conList.add(con2);
        Contact con3 = new Contact();
        con3.FirstName = 'Test';
        con3.LastName = 'Contact3';
        con3.AccountId = ac2.Id;
        con3.Email = 'testcontact1@thomsonreuters.com';
        con3.Phone = '9876543210';
        conList.add(con3);
        insert conList;

        Source_System_Detail__c ssd0 = new Source_System_Detail__c();
        ssd0.Name = 'Test SSD0';
        ssd0.Source_System_Name__c = 'Test SSD0';
        ssd0.Account_Name__c = ac0.Id;
        ssd0.LCRM_Email__c = 'testssd0@thomsonreuters.com';
        ssd0.LCRM_APTS_Band_Number__c = 5;
        ssd0.BU_Segment_Level_2__c = 'Government';
        ssd0.LCRM_Customer_Group__c='GOVERNMENT';
        ssd0.Source_System_Account_Number__c = '100001';
        ssdList.add(ssd0);
        Source_System_Detail__c ssd1 = new Source_System_Detail__c();
        ssd1.Name = 'Test SSD1';
        ssd1.Source_System_Name__c = 'Test SSD1';
        ssd1.Account_Name__c = ac1.Id;
        ssd1.LCRM_Email__c = 'testssd0@thomsonreuters.com';
        ssd1.LCRM_APTS_Band_Number__c = 5;
        ssd1.BU_Segment_Level_2__c = 'Small Law';
        ssd1.LCRM_Customer_Group__c='GOVERNMENT';
        ssd1.Source_System_Account_Number__c = '100002';
        ssdList.add(ssd1);
        Source_System_Detail__c ssd2 = new Source_System_Detail__c();
        ssd2.Name = 'Test SSD2';
        ssd2.Source_System_Name__c = 'Test SSD2';
        ssd2.Account_Name__c = ac2.Id;
        ssd2.LCRM_Email__c = 'testssd0@thomsonreuters.com';
        ssd2.LCRM_APTS_Band_Number__c = 5;
        ssd2.BU_Segment_Level_2__c = 'Corp-Emerging';
        ssd2.LCRM_Customer_Group__c='Corporate';
        ssd2.Source_System_Account_Number__c = '100003';
        ssdList.add(ssd2);
        insert ssdList;

        Trial__c t1 = new Trial__c();
        t1.Trial_Status__c = 'Accepted';
        t1.Trial_Start_Date__c = System.Today() - 5;
        t1.Trial_End_Date__c = System.Today() + 5;
        t1.Campaign_Code__c = 'Trial 1';
        trialList.add(t1);
        Trial__c t2 = new Trial__c();
        t2.Trial_Status__c = 'Ended';
        t2.Trial_Start_Date__c = System.Today() - 5;
        t2.Trial_End_Date__c = System.Today() + 5;
        t2.Campaign_Code__c = 'Trial 2';
        trialList.add(t2);
        insert trialList;

        Invite_Colleagues__c ic1 = new Invite_Colleagues__c();
        ic1.First_Name__c = 'Test';
        ic1.Last_Name__c = 'IC 1';
        ic1.Trial__c = t1.Id;
        ic1.Trial_Status__c = t1.Trial_Status__c;
        ic1.Primary_User__c = false;
        ic1.Trial_End_Date__c = t1.Trial_End_Date__c;
        icList.add(ic1);
        Invite_Colleagues__c ic2 = new Invite_Colleagues__c();
        ic2.First_Name__c = 'Test';
        ic2.Last_Name__c = 'IC 2';
        ic2.Trial__c = t1.Id;
        ic2.Trial_Status__c = null;
        ic2.Primary_User__c = false;
        ic2.Trial_End_Date__c = t1.Trial_End_Date__c;
        icList.add(ic2);
        Invite_Colleagues__c ic3 = new Invite_Colleagues__c();
        ic3.First_Name__c = 'Test';
        ic3.Last_Name__c = 'IC 3';
        ic3.Trial__c = t2.Id;
        ic3.Trial_Status__c = t2.Trial_Status__c;
        ic3.Primary_User__c = false;
        ic3.Trial_End_Date__c = t2.Trial_End_Date__c;
        icList.add(ic3);
        Invite_Colleagues__c ic4 = new Invite_Colleagues__c();
        ic4.First_Name__c = 'Test';
        ic4.Last_Name__c = 'IC 4';
        ic4.Trial__c = t2.Id;
        ic4.Trial_Status__c = null;
        ic4.Primary_User__c = false;
        ic4.Trial_End_Date__c = t2.Trial_End_Date__c;
        icList.add(ic4);
        insert icList;
    }
    
    
    // Process Builder -> ODT_IC_trial_status_update Starts
    @isTest static void digitalTrialStatusUpdateExpired() {
        Test.startTest();
        Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User usr = [Select Id, Sub_Bu__c FROM User WHERE ProfileId =: p.Id AND IsActive = TRUE LIMIT 1];
        System.assert(usr!=null, 'No user was found');
        usr.Sub_Bu__c = label.SALESORGCAN;
        update usr;
        System.runas(usr) {
            Trial__c trial = [Select Id,Trial_Status__c, Trial_End_Date__c, Campaign_Code__c from Trial__c where Campaign_Code__c = 'Trial 1'][0];
            trial.Trial_Status__c = 'Expired';
            update trial;
        }
        Test.stopTest();
    }
    
    
    @isTest static void digitalTrialStatusUpdateEnded() {
        Test.startTest();
        Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User usr = [Select Id FROM User WHERE ProfileId =: p.Id AND IsActive = TRUE LIMIT 1];
        System.assert(usr!=null, 'No user was found');
        System.runas(usr) {
            Trial__c trial = [Select Id,Trial_Status__c, Trial_End_Date__c, Campaign_Code__c from Trial__c where Campaign_Code__c = 'Trial 1'][0];
            trial.Trial_Status__c = 'Ended';
            update trial;
        }
        Test.stopTest();
    }
    
    
    @isTest static void digitalTrialStatusUpdateAccepted() {
        Test.startTest();
        Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User usr = [Select Id FROM User WHERE ProfileId =: p.Id AND IsActive = TRUE LIMIT 1];
        System.assert(usr!=null, 'No user was found');
        System.runas(usr) {
            Trial__c trial = [Select Id,Trial_Status__c, Trial_End_Date__c, Campaign_Code__c from Trial__c where Campaign_Code__c = 'Trial 2'][0];
            trial.Trial_Status__c = 'Accepted';
            update trial;
        }
        Test.stopTest();
    }
    
    
    // Process Builder -> ODT_IC_trial_status_update Ends
    // Process Builder -> ODT_Activity_Creation_at_Account_Level Starts
    @isTest static void digitalTrialStatusUpdateAccepted2() {
        Test.startTest();
        Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User usr = [Select Id,Sub_Bu__c FROM User WHERE ProfileId =: p.Id AND IsActive = TRUE LIMIT 1];
        System.assert(usr!=null, 'No user was found');
        usr.Sub_Bu__c = label.Ecom_Government;
        update usr;
        System.runas(usr) {
            Trial__c trial = [Select Id,Trial_Status__c, Trial_End_Date__c, Campaign_Code__c from Trial__c where Campaign_Code__c = 'Trial 2'][0];
            Account ac = [Select Id, Name,Account_Tier__c ,Email__c, Phone, RecordTypeId, Bu_Segment__c from Account where Name = 'Test Account0'][0];
            Contact cc = [Select Id, FirstName, LastName, AccountId, Email, Phone from Contact where AccountId =: ac.Id][0];
            Source_System_Detail__c sc = [Select Id,LCRM_Customer_Master_Att_5__c,LCRM_Customer_Group__c,Name, Source_System_Name__c, Account_Name__c, LCRM_Email__c, LCRM_APTS_Band_Number__c, BU_Segment_Level_2__c,Trial_Status__c,Source_System_Account_Number__c from Source_System_Detail__c where Account_Name__c =: ac.Id][0];
            
            LCRM_Contact_SSD__c cssd=new LCRM_Contact_SSD__c();
            cssd.LCRM_Account_SSD__c=sc.Id;
            cssd.LCRM_Contact__c=cc.Id;
            insert cssd;

            trial.Trial_Status__c = 'Accepted';
            trial.Contact_ssd__c=cssd.Id;
            trial.Source_System_Detail__c=sc.Id;
            update trial;
        }
        Test.stopTest();
    }
    
    
    // Process Builder -> ODT_Activity_Creation_at_Account_Level Ends
    // Process Builder -> Digital_Post_Accept_Attachment Starts
    @isTest static void digitalRenewalsQuoteAccepted() {
        Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User usr = [Select Id, Sub_Bu__c FROM User WHERE ProfileId =: p.Id AND IsActive = TRUE LIMIT 1];
        System.assert(usr!=null, 'No user was found');
        usr.Sub_Bu__c = label.DCSegmentFindLaw;
        update usr;
        System.runas(usr) {
            Account ac = [Select Id, Name, Email__c, Phone, RecordTypeId, Bu_Segment__c from Account where Name = 'Test Account0'][0];
            Contact cc = [Select Id, FirstName, LastName, AccountId, Email, Phone from Contact where AccountId =: ac.Id][0];
            Source_System_Detail__c sc = [Select Id,LCRM_Customer_Group__c,Name, Source_System_Name__c, Account_Name__c, LCRM_Email__c, LCRM_APTS_Band_Number__c, BU_Segment_Level_2__c, Source_System_Account_Number__c from Source_System_Detail__c where Account_Name__c =: ac.Id][0];
            List < Opportunity > oppList = new List < Opportunity > ();
            List < Apttus_Proposal__Proposal__c > qlist = new List < Apttus_Proposal__Proposal__c > ();
            Pricebook2 pbook = new Pricebook2();
            pbook.name = 'GLI Price Book - US Legal/LMS';
            insert pbook;
            Test.startTest();
            Opportunity opp1 = new Opportunity();
            opp1 = DCTestData.createOpportunityRec('Test Opportunity1 DigitalOpp', ac.Id, 'Appointment Scheduled', System.Today().addDays(20), sc.Id);
            opp1.priceBook2 = pBook;
            opp1.Renewal_Date__c = System.Today().addDays(20);
            opp1.Status__c = 'Unworked';
            opp1.Campaign_Code__c = '00237KI';
            opp1.key_Contact__c = cc.Id;
            opp1.isdigitalSpearhead__c = true;
            opp1.Reason__c = 'Digital';
            opp1.Win_Loss__c = 'Digital';
            opp1.Digital_Review_Complete__c = true;
            opp1.recordtypeID = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
            oppList.add(opp1);
            insert oppList;
            Apttus_Proposal__Proposal__c q1 = new Apttus_Proposal__Proposal__c();
            q1.Apttus_Proposal__Approval_Stage__c = 'Draft';
            q1.APTS_Approval_Segment__c = 'Government';
            q1.Apttus_Proposal__Opportunity__c = opp1.Id;
            q1.Digitally_Signed_Date__c = null;
            qlist.add(q1);
            insert qlist;
            
            q1.Apttus_Proposal__Approval_Stage__c = 'Accepted';
            q1.Digitally_Signed_Date__c = System.Today();
            q1.Latam_APTS_Reason__c = 'Price';
            q1.Latam_APTS_Win_Loss__c = 'Won';
            q1.Apttus_Proposal__Primary__c = true;
            q1.APTS_Proposal_Business_Unit__c = 'SCS';
            q1.Latam_APTS_Reason__c = 'Digital';
            update q1;
            Test.stopTest();
        }
    }
    
    
    @isTest static void digitalNewSalesQuoteAccepted() {

        Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User usr = [Select Id, Sub_Bu__c FROM User WHERE ProfileId =: p.Id AND IsActive = TRUE LIMIT 1];
        System.assert(usr!=null, 'No user was found');
        usr.Sub_Bu__c = label.SALESORGCAN;
        update usr;
        System.runas(usr) {
            
            Account ac = [Select Id, Name, Email__c, Phone, RecordTypeId, Bu_Segment__c from Account where Name = 'Test Account1'][0];
            Contact cc = [Select Id, FirstName, LastName, AccountId, Email, Phone from Contact where AccountId =: ac.Id][0];
            Source_System_Detail__c sc = [Select Id,LCRM_Customer_Group__c,Name, Source_System_Name__c, Account_Name__c, LCRM_Email__c, LCRM_APTS_Band_Number__c, BU_Segment_Level_2__c, Source_System_Account_Number__c from Source_System_Detail__c where Account_Name__c =: ac.Id][0];
            List < Opportunity > oppList = new List < Opportunity > ();
            List < Apttus_Proposal__Proposal__c > qlist = new List < Apttus_Proposal__Proposal__c > ();
            Pricebook2 pbook = new Pricebook2();
            pbook.name = 'GLI Price Book - US Legal/LMS';
            insert pbook;
            Test.startTest();
            Opportunity opp1 = new Opportunity();
            opp1 = DCTestData.createOpportunityRec('Test Opportunity1 DigitalOpp', ac.Id, 'Appointment Scheduled', System.Today().addDays(20), sc.Id);
            opp1.priceBook2 = pBook;
            opp1.Renewal_Date__c = System.Today().addDays(20);
            opp1.Status__c = 'Unworked';
            opp1.Campaign_Code__c = '00237KI';
            opp1.key_Contact__c = cc.Id;
            opp1.Is_Digital_New_Sales__c = true;
            opp1.Reason__c = 'Digital';
            opp1.Win_Loss__c = 'Digital';
            opp1.Digital_Review_Complete__c = true;
            opp1.StageName='Contract Signed';
            opp1.Campaign_Cell__c='Abandoned';
            opp1.Is_Digital_Owner_Updated__c=true;
            opp1.recordtypeID = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
            oppList.add(opp1);
            insert oppList;

            Apttus_Proposal__Proposal__c q1 = new Apttus_Proposal__Proposal__c();
            q1.Apttus_Proposal__Approval_Stage__c = 'Draft';
            q1.APTS_Approval_Segment__c = 'Government';
            q1.Apttus_Proposal__Opportunity__c = opp1.Id;
            q1.Digitally_Signed_Date__c = null;
            q1.Is_NSE_SR__c=false;
            qlist.add(q1);
            insert qlist;
            q1.Apttus_Proposal__Approval_Stage__c = 'Accepted';
            q1.Digitally_Signed_Date__c = System.Today();
            q1.Latam_APTS_Reason__c = 'Price';
            q1.Latam_APTS_Win_Loss__c = 'Won';
            q1.Apttus_Proposal__Primary__c = true;
            q1.APTS_Proposal_Business_Unit__c = 'SCS';
            q1.Latam_APTS_Reason__c = 'Digital';
            update q1;
            Test.stopTest();
        }
    }
    
    
    // Process Builder -> Digital_Post_Accept_Attachment Ends
    // Process Builder -> Digital_Offer_URL_Update_in_Opportunity Starts
    @isTest static void digitalRenewalsQuoteAccepted2() {
        Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User usr = [Select Id, Sub_Bu__c FROM User WHERE ProfileId =: p.Id AND IsActive = TRUE LIMIT 1];
        System.assert(usr!=null, 'No user was found');
        usr.Sub_Bu__c = label.Corporate_Digital_Firm;
        update usr;
        System.runas(usr) {
            Account ac = [Select Id, Name, Email__c, Phone, RecordTypeId, Bu_Segment__c from Account where Name = 'Test Account2'][0];
            Contact cc = [Select Id, FirstName, LastName, AccountId, Email, Phone from Contact where AccountId =: ac.Id][0];
            Source_System_Detail__c sc = [Select Id,LCRM_Customer_Group__c,Name, Source_System_Name__c, Account_Name__c, LCRM_Email__c, LCRM_APTS_Band_Number__c, BU_Segment_Level_2__c, Source_System_Account_Number__c from Source_System_Detail__c where Account_Name__c =: ac.Id][0];
            List < Opportunity > oppList = new List < Opportunity > ();
            List < Apttus_Proposal__Proposal__c > qlist = new List < Apttus_Proposal__Proposal__c > ();
            Pricebook2 pbook = new Pricebook2();
            pbook.name = 'GLI Price Book - US Legal/LMS';
            insert pbook;
            Test.startTest();
            Opportunity opp1 = new Opportunity();
            opp1 = DCTestData.createOpportunityRec('Test Opportunity1 DigitalOpp', ac.Id, 'Appointment Scheduled', System.Today().addDays(20), sc.Id);
            opp1.priceBook2 = pBook;
            opp1.Renewal_Date__c = System.Today().addDays(20);
            opp1.Status__c = 'Unworked';
            opp1.Campaign_Code__c = '00237KI';
            opp1.key_Contact__c = cc.Id;
            opp1.isdigitalSpearhead__c = true;
            opp1.Reason__c = 'Digital';
            opp1.Win_Loss__c = 'Digital';
            opp1.Digital_Review_Complete__c = true;
            opp1.recordtypeID = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
            oppList.add(opp1);
            insert oppList;
            Apttus_Proposal__Proposal__c q1 = new Apttus_Proposal__Proposal__c();
            q1.Apttus_Proposal__Approval_Stage__c = 'Draft';
            q1.APTS_Approval_Segment__c = 'Government';
            q1.Apttus_Proposal__Opportunity__c = opp1.Id;
            q1.Digitally_Signed_Date__c = null;
            qlist.add(q1);
            insert qlist;
            
            q1.Apttus_Proposal__Approval_Stage__c = 'Accepted';
            q1.Digitally_Signed_Date__c = System.Today();
            q1.Latam_APTS_Reason__c = 'Price';
            q1.Latam_APTS_Win_Loss__c = 'Won';
            q1.Apttus_Proposal__Primary__c = true;
            q1.APTS_Proposal_Business_Unit__c = 'SCS';
            q1.Latam_APTS_Reason__c = 'Digital';
            update q1;
            Test.stopTest();
        }
    }

    
    // Process Builder -> Digital_Offer_URL_Update_in_Opportunity - test for 3 segments
    @isTest static void digitalOfferURLUpdateTest() {
        Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User usr = [Select Id, Sub_Bu__c FROM User WHERE ProfileId =: p.Id AND IsActive = TRUE LIMIT 1];
        System.assert(usr!=null, 'No user was found');
        usr.Sub_Bu__c = 'FindLaw';
        update usr;
        System.runas(usr) {
            Account ac = [Select Id, Name, Email__c, Phone, RecordTypeId, Bu_Segment__c from Account where Name = 'Test Account2'][0];
            Contact cc = [Select Id, FirstName, LastName, AccountId, Email, Phone from Contact where AccountId =: ac.Id][0];
            Source_System_Detail__c sc = [Select Id,LCRM_Customer_Group__c,Name, Source_System_Name__c, Account_Name__c, LCRM_Email__c, LCRM_APTS_Band_Number__c, BU_Segment_Level_2__c, Source_System_Account_Number__c from Source_System_Detail__c where Account_Name__c =: ac.Id][0];
            List < Opportunity > oppList = new List < Opportunity > ();
            List < Apttus_Proposal__Proposal__c > qlist = new List < Apttus_Proposal__Proposal__c > ();
            system.debug(logginglevel.INFO, 'Quote List : ' + qlist);
            Pricebook2 pbook = new Pricebook2();
            pbook.name = 'GLI Price Book - US Legal/LMS';
            insert pbook;
            
            Test.startTest();
            Opportunity opp1 = new Opportunity();
            opp1 = DCTestData.createOpportunityRec('Test Opportunity1 DigitalOpp', ac.Id, 'Appointment Scheduled', System.Today().addDays(20), sc.Id);
            opp1.priceBook2 = pBook;
            opp1.Renewal_Date__c = System.Today().addDays(20);
            opp1.Status__c = 'Unworked';
            opp1.Campaign_Code__c = '00237KI';
            opp1.key_Contact__c = cc.Id;
            opp1.isdigitalSpearhead__c = true;
            opp1.Reason__c = 'Digital';
            opp1.Win_Loss__c = 'Digital';
            opp1.Digital_Review_Complete__c = true;
            opp1.recordtypeID = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
            oppList.add(opp1);
            insert oppList;

            // Findlaw 
            opp1.APTS_Proposal_Business_Unit__c = 'FindLaw';
            update oppList;
            
            // Small Law Test - Digital Firm == 'Small Law'
            sc.BU_Segment_Level_2__c = 'Small Law';
            update sc;
            update oppList;

            // Corporate Test - Digital Firm == 'Corporate'
            sc.BU_Segment_Level_2__c = 'Corp Large';
            update sc;
            update oppList;
            
            Test.stopTest();
        }
    }
    
    
    // Process Builder -> Digital_Offer_URL_Update_in_Opportunity -> test for 2 segments
    @isTest static void digitalOfferURLUpdateTest2() {
        Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User usr = [Select Id, Sub_Bu__c FROM User WHERE ProfileId =: p.Id AND IsActive = TRUE LIMIT 1];
        System.assert(usr!=null, 'No user was found');
        usr.Sub_Bu__c = 'FindLaw';
        update usr;
        System.runas(usr) {
            Account ac = [Select Id, Name, Email__c, Phone, RecordTypeId, Bu_Segment__c from Account where Name = 'Test Account2'][0];
            Contact cc = [Select Id, FirstName, LastName, AccountId, Email, Phone from Contact where AccountId =: ac.Id][0];
            Source_System_Detail__c sc = [Select Id,LCRM_Customer_Group__c,Name, Source_System_Name__c, Account_Name__c, LCRM_Email__c, LCRM_APTS_Band_Number__c, BU_Segment_Level_2__c, Source_System_Account_Number__c from Source_System_Detail__c where Account_Name__c =: ac.Id][0];
            List < Opportunity > oppList = new List < Opportunity > ();
            List < Apttus_Proposal__Proposal__c > qlist = new List < Apttus_Proposal__Proposal__c > ();
            system.debug(logginglevel.INFO, 'Quote List : ' + qlist);
            Pricebook2 pbook = new Pricebook2();
            pbook.name = 'GLI Price Book - US Legal/LMS';
            insert pbook;
            
            Test.startTest();
            Opportunity opp1 = new Opportunity();
            opp1 = DCTestData.createOpportunityRec('Test Opportunity1 DigitalOpp', ac.Id, 'Appointment Scheduled', System.Today().addDays(20), sc.Id);
            opp1.priceBook2 = pBook;
            opp1.Renewal_Date__c = System.Today().addDays(20);
            opp1.Status__c = 'Unworked';
            opp1.Campaign_Code__c = '00237KI';
            opp1.key_Contact__c = cc.Id;
            opp1.isdigitalSpearhead__c = true;
            opp1.Reason__c = 'Digital';
            opp1.Win_Loss__c = 'Digital';
            opp1.Digital_Review_Complete__c = true;
            opp1.recordtypeID = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
            oppList.add(opp1);
            insert oppList;
 
            // Government Test - Digital Firm == 'Government'
            sc.BU_Segment_Level_2__c = 'Academic';
            update sc;
            update oppList;     
                        
            // Medium Law Test - Digital Firm = 'Medium Law'
            sc.BU_Segment_Level_2__c = 'Medium Law';
            update sc;
            update oppList;           
                                    
            Test.stopTest();
        }
    }   	

}