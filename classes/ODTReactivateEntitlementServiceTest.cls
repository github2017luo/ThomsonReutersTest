/**
 * Test class 
 */
/**
 * CHANGE HISTORY
 * =============================================================================
 * Date         Name                    Description
 * 2020-03-23   Brenda Shields          DLT-19804 - Move State/Country references from Account/Contact/Leads to methods in DCTestData    
 *  05/14/2020   Rahul Natarajan          DLT-19957 -Allow the "ODT Number of Days" field to pass Dynamic Values rather than Hard coded values   
 * =============================================================================
 */

@isTest(Seealldata = false)
public class ODTReactivateEntitlementServiceTest {
    @testsetup
    public static void testdata() {

        WebServiceSettings__c web = new WebServiceSettings__c();
        web.Endpoint__c = 'test.endpoint';
        web.Name = 'ODTReactivateEntitlementService';
        web.Username__c = 'test.user';
        web.Password__c = 'test:123';
        web.Service_Unavailable_Message__c = 'testservice';

        insert web;

        List<WebServiceSettings__c > WebserviceList = new List<WebServiceSettings__c > {
            new WebServiceSettings__c(Name = 'EnterpriseWSDL', Endpoint__c = 'https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount', Service_Unavailable_Message__c = 'Service not Available'),
            new WebServiceSettings__c(Name = 'StatusPostbackLocation', Endpoint__c = 'https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount', Service_Unavailable_Message__c = 'Service not Available'),
            new WebServiceSettings__c(Name = 'PostbackLocation', Endpoint__c = 'https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount', Service_Unavailable_Message__c = 'Service not Available'),
            new WebServiceSettings__c(Name = 'Payment AutoCharge', Endpoint__c = 'https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount', Service_Unavailable_Message__c = 'Service not Available')
        };
        insert WebserviceList;

        // Create Account
        Account newAcct = DCTestData.createAccount('Test Class Account');
        newAcct.OwnerId = UserInfo.getUserId();
        insert newAcct;

        //Create AccountSSD record
        Source_System_Detail__c accSSD = new Source_System_Detail__c();
        accSSD.Name = 'Test Account SSD';
        accSSD.Source_System_Name__c = 'Test System';
        accSSD.Source_System_Account_Number__c = '173468930';
        accSSD.Account_Name__c = newAcct.id;
        accSSD.Trial_Status__c = '';
        accSSD.LCRM_Market_Segment__c = 'SLF 4-6';
        accSSD.LCRM_Sales_Org__c = 'West';
        insert accSSD;

        //Create Contact
        Contact con = new Contact();
        con.FirstName = 'John';
        con.LastName = 'Ray';
        con.SAP_Contact_ID__c = '6271252';
        con.AccountId = newAcct.id;
        con.Email = 'john.ray@tr.com';
        insert con;

        //create lead
        Lead newlead = new Lead();
        newLead.FirstName = con.FirstName;
        newLead.LastName = con.LastName;
        newLead.Email = con.Email;
        newLead.Company = newAcct.Name;
        newLead.Type__c = 'A';
        newLead.Sales_Org__c = 'WEST';
        newLead.RecordTypeId = '01213000000AXWP';
        newLead.Customer_Type__c = 'Organization';
        newLead.LeadSource = 'Rep Generated';
        newLead.Source__c = 'On Demand Trial';
        newLead.Customer_Group__c = 'ACADEMIC';
        newLead.Status = 'Unworked';
        newLead.OwnerId = newAcct.OwnerId;
        newLead.Billing_Street__c = newAcct.BillingStreet;
        newLead.Billing_City__c = newAcct.BillingCity;
        newLead.Billing_State__c = newAcct.BillingState;
        newLead.Billing_Country__c = newAcct.BillingCountry;
        newLead.Billing_Zip__c = newAcct.BillingPostalCode;
        newLead.Account__c = newAcct.Id;
        newLead.Contact_SAP_ID__c = con.SAP_Contact_ID__c;
        newLead.SAPAccountNumber__c = newAcct.SAPAccountNumber__c;
        //newLead.External_Trial_Account_ID__c = newAcct.External_Trial_Account_ID__c;
        newLead.Form_Organization_Type__c = '';
        //newLead.Product_Solution_of_Interest__c = prodName;
        //newLead.Business_Org__c = businessOrg;  
        newLead.Phone = newAcct.Phone;
        newLead.Campaign_Cell__c = 'Free Trial';
        insert newLead;

        //To create ODT Product Bundle Records
        ODT_Product_Bundle__c prdBndl1 = New ODT_Product_Bundle__c();
        prdBndl1.Name = 'Westlaw Edge Add-on (14 days)';
        prdBndl1.Bundle_ID__c = '725545';
        prdBndl1.Trial_Expiry_Days__c = 14; // Added as part of DLT-19957
        prdBndl1.Is_Active__c = true;
        prdBndl1.Is_Enabled_For_Sales_Rep_Trial__c = true;
        prdBndl1.Product_Category__c = 'WL';
        prdBndl1.Bundle_Type__c = 'CTX';
        prdBndl1.Business_Type__c = 'SLF';
        prdBndl1.Contacts_User_Type__c = 'NET_NEW';
        prdBndl1.Profile_ID__c = '431';
        prdBndl1.SAP_Promotion_Code__c = '1234';
        insert prdBndl1;

        //create Trial
        Trial__c tr = new Trial__c();
        //tr.Account_Name__c=newAcct.Id;
        tr.Source_System_Detail__c = accSSD.id;
        tr.Trial_Id__c = '56576';
        tr.Contact_LeadId__c = newLead.Id;
        tr.Contact_id_SAP__c = con.SAP_Contact_ID__c;
        tr.Trial_Source__c = label.ODT_Trial_Source;
        tr.InvitedDateTime__c = System.today() - 200;
        tr.Trial_Status__c = 'Timed-out';
        tr.ODT_Product_Bundle__c = prdBndl1.Id;
        tr.ODT_SAP_Account_Number__c = '173468930';
        //tr.ODT_Trial_Extend_Date__c = System.today()+50;
        tr.ODT_Trial_Extend_Date__c = Date.today() + Integer.valueof(prdBndl1.Trial_Expiry_Days__c);
        insert tr;

        List<Invite_Colleagues__c > invitedClgList = new List<Invite_Colleagues__c > ();
        //create Invited Colleague
        Invite_Colleagues__c invitedClg1 = New Invite_Colleagues__c();
        invitedClg1.First_Name__c = 'test invite';
        invitedClg1.Last_Name__c = 'tessstt';
        invitedClg1.Trial_Status__c = 'Invited';
        invitedClg1.Trial__c = tr.id;
        invitedClg1.Source_System_Detail__c = accSSD.id;
        invitedClg1.Email__c = 'invclgemail@test.com';
        invitedClg1.Primary_User__c = false;
        invitedClg1.SapContactId__c = con.SAP_Contact_ID__c;
        invitedClgList.add(invitedClg1);

        Invite_Colleagues__c invitedClg2 = New Invite_Colleagues__c();
        invitedClg2.First_Name__c = 'test invite';
        invitedClg2.Last_Name__c = 'tessstt';
        invitedClg2.Trial_Status__c = 'Invited';
        invitedClg2.Trial__c = tr.id;
        invitedClg2.Source_System_Detail__c = accSSD.id;
        invitedClg2.Email__c = 'invclgemail@test.com';
        invitedClg2.Primary_User__c = false;
        invitedClg2.SapContactId__c = con.SAP_Contact_ID__c;
        invitedClgList.add(invitedClg2);

        insert invitedClgList;

    }

    public static testMethod void testReactivateEntitlementService() {
        Test.startTest();
        List<Trial__c > myTrial = [SELECT Id, Name, Account_Name__c, Account_Name__r.name, Contact_id_SAP__c, Contact_LeadId__c, Contact_Name__c, Contact_ssd__c, Early_End_Other_Reason__c, Early_End_Reason__c, Global_trial_Id__c, GUID__c, Initiated_User_Profile__c, Initiated_User_Role__c, InvitedDateTime__c, No_Of_Days_To_Extend__c, ODT_Email__c, ODT_Ended_By__c, ODT_Number_Of_Days_Trial_Extended__c, ODT_Product_Bundle__c, ODT_SAP_Account_Number__c, ODT_Trial_Extend_Date__c, ODT_Trial_Product_Category__c, PrimaryContact__c, Source_System_Detail__c, Source_System_Detail__r.Name, Source_System_Detail__r.LCRM_Sales_Org__c, Trial_Campaign__c, Trial_End_Date__c, Trial_Id__c, Trial_Journey__c, Trial_Products_Recommendation__c, Trial_products__c, Trial_Source__c, Trial_Start_Date__c, Trial_Status__c, (SELECT Email__c, First_Name__c, Id, Last_Name__c, Name, Primary_User__c, SapContactId__c, Trial_End_Date__c, Trial_Request_Date__c, Trial_Start_Date__c, Trial_Status__c, Trial__c FROM Invite_Colleagues__r) FROM Trial__c where ODT_SAP_Account_Number__c = '173468930'];

        Boolean isReactivate = ODTReactivateEntitlementService.reactivateEntitlement(myTrial[0]);
        system.assertNotEquals(isReactivate, null);

        /*
        ReactivateEntitlementRequest reactEntRequest = ODTReactivateEntitlementService.getReactEntRequest(myTrial[0]);
        system.assertNotEquals(reactEntRequest,null);

        String esiReactEntRequest = JSON.serialize(reactEntRequest);
        WebServiceSettings__c web = WebServiceSettings__c.getInstance('ODTReactivateEntitlementService');
        HttpRequest request = ODTReactivateEntitlementService.callReactivateESIService(esiReactEntRequest, web);
        system.assertNotEquals(request,null);
        */
        Test.stopTest();
    }

    public static testmethod void testTrialReactivateController() {
        Test.startTest();
        Profile p = [SELECT Id FROM profile WHERE name = 'GLI Sales USer'];
        UserRole ukiRole = [SELECT Id FROM UserRole WHERE Name = 'Small Law'];
        //System.debug('inside11 :::ukiRole'+ukiRole);
        User u1;
        System.runAs(new User(Id = UserInfo.getUserId())) {
            u1 = new User(alias = 'newUser4', email = 'user@mydomain.com',
                emailencodingkey = 'UTF-8', lastname = 'Testing', languagelocalekey = 'en_US',
                localesidkey = 'en_US', profileid = p.Id, employeenumber = '0144020',
                Sales_Org__c = 'GLI', Sub_Bu__c = 'Elite', timezonesidkey = 'America/Los_Angeles', username = 'user343413@mydomain.com', Rep_Type_Description__c = 'test', UserRoleId = ukiRole.Id);
            insert u1;
            System.debug('inside222 :::u1' + u1);
        }

        system.runAs(u1) {

            Profile p1 = [SELECT Id FROM Profile WHERE Name =: 'ANZ Users'];
            User u = [Select ID, Sales_Org__c FROM User where Sales_Org__c = 'LRA'
                AND Profile.id =: p1.id limit 1
            ];
            Map<String, Schema.RecordTypeInfo > recordTypes = Opportunity.sObjectType.getDescribe().getRecordTypeInfosByName();
            Id optyPipeRecTypeId = recordTypes.get('Pipeline Opportunity').getRecordTypeId();
            Id optyPreRecTypeID = recordTypes.get('Pre-Pipeline Opportunity').getRecordTypeId();
            Id optyGLIRecTypeID = recordTypes.get('GLI Pipeline Opportunity').getRecordTypeId();
            System.debug('Pipeline' + optyPipeRecTypeId + 'Pre-pipeline' + optyPreRecTypeID + 'GLI pipeline' + optyGLIRecTypeID);

            //Keyvalue setting for OpportunityUtil class
            KeyValueListStore__C keyCustomSetting = new KeyValueListStore__c(Name = 'ANZUsersProfileId', TextValue__c = p1.id);
            insert keyCustomSetting;

            //Creation of 3 record types.
            RecordtypeIds__c recT = new RecordtypeIds__c();
            recT.name = 'Pre-Pipeline Opportunities';
            recT.recTypeId__C = optyPipeRecTypeId != null ? optyPreRecTypeID : '012a0000001ZJxn';
            insert recT;

            RecordtypeIds__c recT1 = new RecordtypeIds__c();
            recT1.Name = 'Pipeline Opportunities';
            recT1.recTypeId__C = optyPipeRecTypeId != null ? optyPipeRecTypeId : '012a0000001ZJxn';
            insert recT1;

            RecordtypeIds__c recT2 = new RecordtypeIds__c();
            recT2.Name = 'GLI Pipeline Opportunity';
            recT2.recTypeId__C = optyGLIRecTypeID != null ? optyGLIRecTypeID : '012a0000001ZJxn';
            insert recT2;

            Pricebook2 pbook = new Pricebook2();
            pbook.name = 'GLI Price Book - US Legal/LMS';
            pbook.IsActive = true;
            insert pbook;

            //Create webservice setting
            LIST<WebServiceSettings__c > webList1 = new LIST<WebServiceSettings__c > ();
            WebServiceSettings__c web1 = new WebServiceSettings__c();
            web1.Endpoint__c = 'test.endpoint';
            web1.Name = 'ODTTrialExtensionService';
            web1.Username__c = 'test.user';
            web1.Password__c = 'test:123';
            web1.Service_Unavailable_Message__c = 'testservice';
            webList1.add(web1);

            WebServiceSettings__c webs5 = new WebServiceSettings__c();
            webs5.Endpoint__c = 'test4.endpoint';
            webs5.Name = 'ODTEloquaServiceSFDCSource';
            webs5.Username__c = 'test4.user';
            webs5.Password__c = 'test4:123';
            webs5.Service_Unavailable_Message__c = 'test2service';
            webList1.add(webs5);

            WebServiceSettings__c web6 = new WebServiceSettings__c();
            web6.Endpoint__c = 'test.endpoint';
            web6.Name = 'ODTReactivateEntitlementService';
            web6.Username__c = 'test.user';
            web6.Password__c = 'test:123';
            web6.Service_Unavailable_Message__c = 'testservice';
            webList1.add(web6);

            insert webList1;

            // create Account
            Account newAcct1 = DCTestData.createAccount('Test Class Account1');
            //newAcct.SAPAccountNumber__c ='173468929';
            //newAcct.BillingState='karnataka';
            //newAcct.BillingCity='Bangalore';
            //newAcct.BillingCountry='India';
            //newAcct.BillingPostalCode='560066';
            //newAcct.BillingStreet='Whitefiled road';    
            //newAcct.Phone='08061393678';
            //newAcct.Sales_Org__c = 'WEST';
            newAcct1.SAPAccountNumber__c = '1734689292';
            newAcct1.OwnerId = UserInfo.getUserId();
            insert newAcct1;

            //Create AccountSSD record
            Source_System_Detail__c accSSD1 = new Source_System_Detail__c();
            accSSD1.Name = 'Test Account SSD1';
            accSSD1.Source_System_Name__c = 'Test System1';
            accSSD1.Source_System_Account_Number__c = '1734689302';
            accSSD1.Account_Name__c = newAcct1.id;
            accSSD1.Trial_Status__c = '';
            accSSD1.LCRM_Market_Segment__c = 'SLF 4-6';
            insert accSSD1;

            //Create Contact
            Contact con1 = new Contact();
            con1.FirstName = 'John1';
            con1.LastName = 'Ray';
            con1.SAP_Contact_ID__c = '62712522';
            con1.AccountId = newAcct1.id;
            con1.Email = 'john1.ray@tr.com';
            insert con1;

            List<ODT_Product_Bundle__c > opblist = new List<ODT_Product_Bundle__c > ();
            //To create ODT Product Bundle Records
            ODT_Product_Bundle__c prdBndl2 = New ODT_Product_Bundle__c();
            prdBndl2.Name = 'Westlaw Edge Add-on (14 days)';
            prdBndl2.Bundle_ID__c = '725545';
            prdBndl2.Trial_Expiry_Days__c = 14; // Added as part of DLT-19957
            prdBndl2.Is_Active__c = true;
            prdBndl2.Is_Enabled_For_Sales_Rep_Trial__c = true;
            prdBndl2.Product_Category__c = 'WL';
            prdBndl2.Bundle_Type__c = 'CTX';
            prdBndl2.Business_Type__c = 'SLF';
            prdBndl2.Contacts_User_Type__c = 'NET_NEW';
            prdBndl2.Profile_ID__c = '431';
            prdBndl2.SAP_Promotion_Code__c = '1234';
            opblist.add(prdBndl2);
            //To create ODT Product Bundle Records
            ODT_Product_Bundle__c prdBndl3 = New ODT_Product_Bundle__c();
            prdBndl3.Name = 'Westlaw Edge Add-on (14 days)';
            prdBndl3.Bundle_ID__c = '725545';
            prdBndl3.Trial_Expiry_Days__c = 14; // Added as part of DLT-19957
            prdBndl3.Is_Active__c = true;
            prdBndl3.Is_Enabled_For_Sales_Rep_Trial__c = true;
            prdBndl3.Product_Category__c = 'WL';
            prdBndl3.Bundle_Type__c = 'CTX';
            prdBndl3.Business_Type__c = 'SLF';
            prdBndl3.Contacts_User_Type__c = 'NET_NEW';
            prdBndl3.Profile_ID__c = '431';
            prdBndl3.SAP_Promotion_Code__c = '1234';
            opblist.add(prdBndl3);
            //To create ODT Product Bundle Records
            ODT_Product_Bundle__c prdBndl6 = New ODT_Product_Bundle__c();
            prdBndl6.Name = 'Westlaw Edge Add-on (14 days)';
            prdBndl6.Bundle_ID__c = '725545';
            prdBndl6.Trial_Expiry_Days__c = 14; // Added as part of DLT-19957
            prdBndl6.Is_Active__c = true;
            prdBndl6.Is_Enabled_For_Sales_Rep_Trial__c = true;
            prdBndl6.Product_Category__c = 'WL';
            prdBndl6.Bundle_Type__c = 'CTX';
            prdBndl6.Business_Type__c = 'SLF';
            prdBndl6.Contacts_User_Type__c = 'NET_NEW';
            prdBndl6.Profile_ID__c = '431';
            prdBndl6.SAP_Promotion_Code__c = '1234';
            opblist.add(prdBndl6);
            //To create ODT Product Bundle Records
            ODT_Product_Bundle__c prdBndl7 = New ODT_Product_Bundle__c();
            prdBndl7.Name = 'Westlaw Edge Add-on (14 days)';
            prdBndl7.Bundle_ID__c = '725545';
            prdBndl7.Trial_Expiry_Days__c = 14; // Added as part of DLT-19957
            prdBndl7.Is_Active__c = true;
            prdBndl7.Is_Enabled_For_Sales_Rep_Trial__c = true;
            prdBndl7.Product_Category__c = 'WL';
            prdBndl7.Bundle_Type__c = 'CTX';
            prdBndl7.Business_Type__c = 'SLF';
            prdBndl7.Contacts_User_Type__c = 'NET_NEW';
            prdBndl7.Profile_ID__c = '431';
            prdBndl7.SAP_Promotion_Code__c = '1234';
            opblist.add(prdBndl7);
            //To create ODT Product Bundle Records
            ODT_Product_Bundle__c prdBndl8 = New ODT_Product_Bundle__c();
            prdBndl8.Name = 'Westlaw Edge Add-on (14 days)';
            prdBndl8.Bundle_ID__c = '725545';
            prdBndl8.Trial_Expiry_Days__c = 14; // Added as part of DLT-19957
            prdBndl8.Is_Active__c = true;
            prdBndl8.Is_Enabled_For_Sales_Rep_Trial__c = true;
            prdBndl8.Product_Category__c = 'WL';
            prdBndl8.Bundle_Type__c = 'CTX';
            prdBndl8.Business_Type__c = 'SLF';
            prdBndl8.Contacts_User_Type__c = 'NET_NEW';
            prdBndl8.Profile_ID__c = '431';
            prdBndl8.SAP_Promotion_Code__c = '1234';
            opblist.add(prdBndl8);

            insert opblist;
            //create Trial---to cover positive scenarios in all conditions
            Trial__c tr2 = new Trial__c();
            tr2.Source_System_Detail__c = accSSD1.id;
            tr2.Trial_Id__c = '56576';
            // tr2.ODT_Trial_Extend_Date__c=date.today()+8;
            //tr.Contact_LeadId__c=newLead.Id;
            tr2.Contact_id_SAP__c = con1.SAP_Contact_ID__c;
            tr2.Trial_Source__c = label.ODT_Trial_Source;
            tr2.InvitedDateTime__c = System.today() - 200;
            tr2.Trial_Status__c = 'Timed-out';
            tr2.Trial_Start_Date__c = System.today() - 14;
            tr2.Trial_End_Date__c = System.today();
            tr2.ODT_SAP_Account_Number__c = accSSD1.Source_System_Account_Number__c;
            tr2.Num_of_Times_Trial_Reactivated__c = null;
            tr2.ODT_Number_Of_Days_Trial_Extended__c = null;
            tr2.ODT_Product_Bundle__c = prdBndl2.Id;
            
            tr2.ODT_Trial_Extend_Date__c = System.today() +5;
            insert tr2;

            List<Invite_Colleagues__c > iclist = new List<Invite_Colleagues__c > ();
            Invite_Colleagues__c invitedClg1 = New Invite_Colleagues__c();
            invitedClg1.First_Name__c = 'test invite';
            invitedClg1.Last_Name__c = 'test';
            invitedClg1.Trial_Status__c = 'ended';
            invitedClg1.Trial__c = tr2.id;
            //vitedClg2.Lead__c = lead.id; 
            invitedClg1.Primary_User__c = true;
            invitedClg1.SapContactId__c = con1.SAP_Contact_ID__c;
            iclist.add(invitedClg1);

            Invite_Colleagues__c invitedClg3 = New Invite_Colleagues__c();
            invitedClg3.First_Name__c = 'test invite';
            invitedClg3.Last_Name__c = 'test';
            invitedClg3.Trial_Status__c = 'invited';
            invitedClg3.Trial__c = tr2.id;
            //vitedClg2.Lead__c = lead.id; 
            invitedClg3.Primary_User__c = false;
            invitedClg3.SapContactId__c = con1.SAP_Contact_ID__c;
            iclist.add(invitedClg3);

            Invite_Colleagues__c invitedClg4 = New Invite_Colleagues__c();
            invitedClg4.First_Name__c = 'test invite';
            invitedClg4.Last_Name__c = 'test';
            invitedClg4.Trial_Status__c = 'ended';
            invitedClg4.Trial__c = tr2.id;
            //vitedClg2.Lead__c = lead.id; 
            invitedClg4.Primary_User__c = false;
            invitedClg4.SapContactId__c = con1.SAP_Contact_ID__c;
            iclist.add(invitedClg4);

            insert iclist;

            //create opportunity
            Opportunity opp = new Opportunity();
            opp.Name = 'Test Opportunity';
            opp.closeDate = System.Today() + 5;
            opp.recordTypeId = optyPreRecTypeID;
            opp.Owner = u;
            opp.StageName = 'Prospect';
            opp.AccountId = newAcct1.Id;
            opp.Pricebook2id = pbook.id;
            opp.Source_System_Detail__c = accSSD1.Id;
            insert opp;

            //create Opportunity trial
            Opportunity_Trial__c opTrial = new Opportunity_Trial__c();
            opTrial.Trial__c = tr2.id;
            opTrial.Opportunity__c = opp.id;
            insert opTrial;

            apexpages.currentpage().getparameters().put('id', tr2.id);
            ApexPages.StandardController scon2 = new ApexPages.StandardController(tr2);
            ODT_TrialReactivateController testODTCntl = new ODT_TrialReactivateController(scon2);
            testODTCntl.reactivateTrial();
            testODTCntl.backToTrial();
            testODTCntl.addmethod1();

            //create to Trial--to cover Trial ineligibility scenario based on Extend date(limit exceeded) for SR/TM
            Trial__c tr4 = new Trial__c();
            tr4.Source_System_Detail__c = accSSD1.id;
            tr4.Trial_Id__c = '56576';
            // tr4.ODT_Trial_Extend_Date__c=date.today()+50;
            //tr.Contact_LeadId__c=newLead.Id;
            tr4.Contact_id_SAP__c = con1.SAP_Contact_ID__c;
            tr4.Trial_Source__c = label.ODT_Trial_Source;
            tr4.InvitedDateTime__c = System.today() - 200;
            tr4.Trial_Status__c = 'Timed-out';
            tr4.ODT_Product_Bundle__c = prdBndl3.Id;
            tr4.Trial_Start_Date__c = System.today()-14;
            tr4.Trial_End_Date__c = System.today();
            tr4.ODT_SAP_Account_Number__c = accSSD1.Source_System_Account_Number__c;
            tr4.ODT_Trial_Extend_Date__c = date.today() +5;
            tr4.Num_of_Times_Trial_Reactivated__c = null;
            insert tr4;

            Opportunity_Trial__c opTrial1 = new Opportunity_Trial__c();
            opTrial1.Trial__c = tr4.id;
            opTrial1.Opportunity__c = opp.id;
            insert opTrial1;

            Invite_Colleagues__c invitedClg2 = New Invite_Colleagues__c();
            invitedClg2.First_Name__c = 'test invite';
            invitedClg2.Last_Name__c = 'tessstt';
            invitedClg2.Trial__c = tr4.id;
            invitedClg2.Source_System_Detail__c = accSSD1.id;
            invitedClg2.Email__c = 'invclgemail@test.com';
            invitedClg2.Primary_User__c = false;
            invitedClg2.SapContactId__c = con1.SAP_Contact_ID__c;
            invitedClg2.Trial_Status__c = 'invited';
            insert invitedClg2;

            ApexPages.currentPage().getParameters().put('Id', tr4.id);
            ApexPages.StandardController sc = new ApexPages.StandardController(tr4);
            ODT_TrialReactivateController testODTCntl2 = new ODT_TrialReactivateController(sc);
            testODTCntl2.reactivateTrial();
            testODTCntl2.backToTrial();

            //create trial--to cover when Extend date is null
            Trial__c tr6 = new Trial__c();
            tr6.Source_System_Detail__c = accSSD1.id;
            tr6.ODT_Product_Bundle__c = prdBndl6.Id;
            tr6.Trial_Id__c = '56576';
            tr6.ODT_Trial_Extend_Date__c = null;
            //tr.Contact_LeadId__c=newLead.Id;
            tr6.Contact_id_SAP__c = con1.SAP_Contact_ID__c;
            tr6.Trial_Source__c = label.ODT_Trial_Source;
            tr6.InvitedDateTime__c = System.today() - 200;
            tr6.Trial_Status__c = 'Timed-out';
            tr6.Trial_Start_Date__c = System.today();
            tr6.Trial_End_Date__c = System.today() + 7;
            tr6.ODT_SAP_Account_Number__c = accSSD1.Source_System_Account_Number__c;
            tr6.Num_of_Times_Trial_Reactivated__c = null;
            insert tr6;

            Opportunity_Trial__c opTrial2 = new Opportunity_Trial__c();
            opTrial2.Trial__c = tr6.id;
            opTrial2.Opportunity__c = opp.id;
            insert opTrial2;

            ApexPages.currentPage().getParameters().put('Id', tr6.id);
            ApexPages.StandardController sc2 = new ApexPages.StandardController(tr6);
            ODT_TrialReactivateController testODTCntl3 = new ODT_TrialReactivateController(sc2);
            testODTCntl3.reactivateTrial();
            testODTCntl3.backToTrial();

            //create Trial--to cover when Trial ineligibility scenario based on Trial end date
            Trial__c tr7 = new Trial__c();
            tr7.Source_System_Detail__c = accSSD1.id;
            tr7.Trial_Id__c = '56576';
            //  tr7.ODT_Trial_Extend_Date__c=date.today()+5;
            tr7.ODT_Product_Bundle__c = prdBndl7.Id;
            tr7.ODT_Trial_Extend_Date__c = date.today() + Integer.valueof(prdBndl7.Trial_Expiry_Days__c);
            //tr.Contact_LeadId__c=newLead.Id;
            tr7.Contact_id_SAP__c = con1.SAP_Contact_ID__c;
            tr7.Trial_Source__c = 'SFDC';
            tr7.InvitedDateTime__c = System.today() - 200;
            tr7.Trial_Status__c = 'Timed-out';
            tr7.Trial_Start_Date__c = System.today() - 250;
            tr7.Trial_End_Date__c = System.today() - 200;
            tr7.ODT_SAP_Account_Number__c = accSSD1.Source_System_Account_Number__c;
            tr7.Num_of_Times_Trial_Reactivated__c = 3;
            insert tr7;

            Opportunity_Trial__c opTrial3 = new Opportunity_Trial__c();
            opTrial3.Trial__c = tr7.id;
            opTrial3.Opportunity__c = opp.id;
            insert opTrial3;

            ApexPages.currentPage().getParameters().put('Id', tr7.id);
            ApexPages.StandardController sc3 = new ApexPages.StandardController(tr7);
            ODT_TrialReactivateController testODTCntl4 = new ODT_TrialReactivateController(sc3);
            testODTCntl4.reactivateTrial();
            testODTCntl4.backToTrial();
            //testODTCntl4.testCoverage(1,2 );

            //create Trial---to cover for NET_NEW scenario
            Trial__c tr8 = new Trial__c();
            tr8.Source_System_Detail__c = accSSD1.id;
            tr8.ODT_Product_Bundle__c = prdBndl8.Id;
            tr8.Trial_Id__c = '56576';
            tr8.ODT_Trial_Extend_Date__c = date.today() +5;
            tr8.Contact_id_SAP__c = con1.SAP_Contact_ID__c;
            tr8.Trial_Source__c = 'SFDC';
            tr8.InvitedDateTime__c = System.today() - 200;
            tr8.Trial_Status__c = 'Timed-out';
            tr8.Trial_Start_Date__c = System.today() - 14;
            tr8.Trial_End_Date__c = System.today();
            tr8.ODT_SAP_Account_Number__c = accSSD1.Source_System_Account_Number__c;
            tr8.Num_of_Times_Trial_Reactivated__c = null;
            tr8.ODT_Number_Of_Days_Trial_Extended__c = null;
            tr8.Profile_Type__c = 'NET_NEW';
            insert tr8;

            Opportunity_Trial__c opTrial4 = new Opportunity_Trial__c();
            opTrial4.Trial__c = tr8.id;
            opTrial4.Opportunity__c = opp.id;
            insert opTrial4;

            Invite_Colleagues__c invitedClg6 = New Invite_Colleagues__c();
            invitedClg6.First_Name__c = 'test invite';
            invitedClg6.Last_Name__c = 'test';
            invitedClg6.Trial_Status__c = 'invited';
            invitedClg6.Trial__c = tr8.id;
            invitedClg6.Primary_User__c = false;
            invitedClg6.SapContactId__c = con1.SAP_Contact_ID__c;
            insert invitedClg6;
            System.debug('tr8' + tr8);
            System.debug('invitedClg6' + invitedClg6);
            ApexPages.currentPage().getParameters().put('Id', tr8.id);
            ApexPages.StandardController sc4 = new ApexPages.StandardController(tr8);
            ODT_TrialReactivateController testODTCntl5 = new ODT_TrialReactivateController(sc4);
            testODTCntl5.reactivateTrial();
            testODTCntl5.backToTrial();

        }
        Test.stopTest();
    }
}