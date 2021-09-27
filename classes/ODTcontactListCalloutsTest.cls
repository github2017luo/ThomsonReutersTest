/*============================================================================================
    Name                : ODTcontactListCalloutsTest
    Description         : This class is developed as part of CXD-ODT project and it is Test Class covering three classes contactsListCon, EsiResponseWrapper and CallToOLCTofetchActiveTr  
    Created Date        : 2/16/2018 
    Author              : TCS CXD ODT team
    Modification History: Optimizing the code by Harshitha
==============================================================================================*/

@isTest(Seealldata = false)
public class ODTcontactListCalloutsTest {

    public static testMethod void testContactListCreation() {
        Profile p1 = [SELECT Id FROM Profile WHERE Name =: 'ANZ Users'];
        User u = [Select ID, Sales_Org__c FROM User where Sales_Org__c = 'LRA'
            AND Profile.id =: p1.id limit 1
        ];
        System.assert(u!=null,'No user found');
        Map<String, Schema.RecordTypeInfo > recordTypes = Opportunity.sObjectType.getDescribe().getRecordTypeInfosByName();
        Id optyPipeRecTypeId = recordTypes.get('Pipeline Opportunity').getRecordTypeId();
        Id optyPreRecTypeID = recordTypes.get('Pre-Pipeline Opportunity').getRecordTypeId();
        Id optyGLIRecTypeID = recordTypes.get('GLI Pipeline Opportunity').getRecordTypeId();
        RecordType defaultRecordType = [SELECT id,Name FROM RecordType WHERE SobjectType='Opportunity' Limit 1];
        System.debug('Pipeline' + optyPipeRecTypeId + 'Pre-pipeline' + optyPreRecTypeID + 'GLI pipeline' + optyGLIRecTypeID);

        //Keyvalue setting for OpportunityUtil class
        KeyValueListStore__C keyCustomSetting = new KeyValueListStore__c(Name = 'ANZUsersProfileId', TextValue__c = p1.id);
        insert keyCustomSetting;

        RecordtypeIds__c recT1 = new RecordtypeIds__c();
        recT1.Name = 'Pipeline Opportunities';
        recT1.recTypeId__C = optyPipeRecTypeId != null ? optyPipeRecTypeId : defaultRecordType.id;
        insert recT1;

        RecordtypeIds__c recT2 = new RecordtypeIds__c();
        recT2.Name = 'GLI Pipeline Opportunity';
        recT2.recTypeId__C = optyGLIRecTypeID != null ? optyGLIRecTypeID : defaultRecordType.id;
        insert recT2;

        RecordtypeIds__c recT = new RecordtypeIds__c();
        recT.name = 'Pre-Pipeline Opportunities';
        recT.recTypeId__C = optyPreRecTypeID != null ? optyPreRecTypeID : defaultRecordType.id;
        insert recT;

        Pricebook2 pbook = new Pricebook2();
        pbook.name = 'GLI Price Book - US Legal/LMS';
        pbook.IsActive = true;
        insert pbook;

        WebServiceSettings__c web1Service = new WebServiceSettings__c();
        web1Service.Endpoint__c = 'test.endpoint';
        web1Service.Name = 'ODTReactivateEntitlementService';
        web1Service.Username__c = 'test.user';
        web1Service.Password__c = 'test:123';
        web1Service.Service_Unavailable_Message__c = 'testservice';

        insert web1Service;

        List < WebServiceSettings__c > webserviceList = new List < WebServiceSettings__c > {
            new WebServiceSettings__c(Name = 'EnterpriseWSDL', Endpoint__c = 'https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount', Service_Unavailable_Message__c = 'Service not Available'),
            new WebServiceSettings__c(Name = 'StatusPostbackLocation', Endpoint__c = 'https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount', Service_Unavailable_Message__c = 'Service not Available'),
            new WebServiceSettings__c(Name = 'PostbackLocation', Endpoint__c = 'https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount', Service_Unavailable_Message__c = 'Service not Available'),
            new WebServiceSettings__c(Name = 'Payment AutoCharge', Endpoint__c = 'https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount', Service_Unavailable_Message__c = 'Service not Available'),
            new WebServiceSettings__c(Name = 'PaymentCreditIncrease', Endpoint__c = 'https://testingfromsfdc.com/processReq', Service_Unavailable_Message__c = 'Service not Available')
        };
        insert webserviceList;

        // create Account
        Account newAcct = new Account();
        newAcct.Name = 'Test Class Account';
        newAcct.SAPAccountNumber__c = '173468929';
        newAcct.BillingState = 'FL';
        newAcct.BillingCity = 'Orlando';
        newAcct.BillingCountry = 'US';
        newAcct.BillingPostalCode = '32801';
        newAcct.BillingStreet = '223 E. Concord Street';
        newAcct.Phone = '08061393678';
        newAcct.OwnerId = UserInfo.getUserId();
        insert newAcct;

        //Create AccountSSD record
        Source_System_Detail__c accSSD = new Source_System_Detail__c();
        accSSD.Name = 'Test Account SSD';
        accSSD.Source_System_Name__c = 'Test System';
        accSSD.Source_System_Account_Number__c = '173468930';
        accSSD.Account_Name__c = newAcct.id;
        accSSD.Trial_Status__c = '';
        accSSD.BU_Segment_Level_2__c = 'SLF 4-6';
        insert accSSD;

        //Create Contact
        Contact con = new Contact();
        con.FirstName = 'John';
        con.LastName = 'Ray';
        con.SAP_Contact_ID__c = '0006271252';
        con.AccountId = newAcct.id;
        con.Email = 'john.ray@tr.com';
        insert con;

        //create lead
        Lead newlead = new Lead();
        Map<String,Schema.RecordTypeInfo> leadRecordTypeInfo = Schema.SObjectType.Lead.getRecordTypeInfosByName(); 
        Id leadRecordTypeId = leadRecordTypeInfo.get('S2E').getRecordTypeId();
        newLead.FirstName = con.FirstName;
        newLead.LastName = con.LastName;
        newLead.Email = 'System.now()@mailinator.com';
        newLead.Company = newAcct.Name;
        newLead.Type__c = 'A';
        newLead.Sales_Org__c = 'WEST';
        newLead.RecordTypeId = leadRecordTypeId;
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
        newLead.Form_Organization_Type__c = '';
        newLead.Phone = newAcct.Phone;
        newLead.Campaign_Cell__c = 'Free Trial';
        insert newLead;

        //create opportunity
        Id ssdRecorType = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();

        Opportunity opp = new Opportunity();
        opp.Name = 'Test Opportunity';
        opp.closeDate = System.Today() + 5;
        opp.recordTypeId = ssdRecorType;
        opp.Owner = u;
        opp.StageName = 'Prospect';
        opp.AccountId = newAcct.Id;
        opp.Pricebook2id = pbook.id;
        opp.Source_System_Detail__c = accSSD.Id;
        insert opp;

        //create Trial
        Trial__c tr = new Trial__c();
        tr.Source_System_Detail__c = accSSD.id;
        tr.Trial_Id__c = '56576';
        tr.Contact_LeadId__c = newLead.Id;
        tr.Contact_id_SAP__c = con.SAP_Contact_ID__c;
        tr.Trial_Source__c = label.ODT_Trial_Source;
        tr.ODT_Email__c = 'invclgemail@test.com';
        tr.Trial_Initiated_Mode__c = 'Started Immediately';
        tr.Profile_Type__c = 'NET_NEW';
        tr.InvitedDateTime__c = System.today() - 20;
        tr.Trial_Status__c = 'Timed-out';
        insert tr;

        //create Invited Colleague
        Invite_Colleagues__c invitedClg1 = New Invite_Colleagues__c();
        invitedClg1.First_Name__c = 'test invite';
        invitedClg1.Last_Name__c = 'tessstt';
        invitedClg1.Trial_Status__c = 'Rep Initiated';
        invitedClg1.Trial__c = tr.id;
        invitedClg1.Source_System_Detail__c = accSSD.id;
        invitedClg1.Email__c = 'invclgemail@test.com';
        invitedClg1.Primary_User__c = true;
        invitedClg1.SapContactId__c = con.SAP_Contact_ID__c;
        insert invitedClg1;

        //create Trial
        Trial__c tr1 = new Trial__c();
        tr1.Source_System_Detail__c = accSSD.id;
        tr1.Trial_Id__c = '56576';
        tr1.Contact_LeadId__c = newLead.Id;
        tr1.Contact_id_SAP__c = con.SAP_Contact_ID__c;
        tr1.Trial_Source__c = label.ODT_Trial_Source;
        tr1.ODT_Email__c = 'invclgemail@test.com';
        tr1.Trial_Initiated_Mode__c = 'Started by Marketing';
        tr1.Profile_Type__c = 'EXISTING_USER_SAME_DOMAIN';
        tr1.InvitedDateTime__c = System.today() - 20;
        tr1.Trial_Status__c = 'Timed-out';
        insert tr1;

        //create Invited Colleague
        Invite_Colleagues__c invitedClg2 = New Invite_Colleagues__c();
        invitedClg2.First_Name__c = 'test invite';
        invitedClg2.Last_Name__c = 'tessstt';
        invitedClg2.Trial_Status__c = 'Rep Initiated';
        invitedClg2.Trial__c = tr1.id;
        invitedClg2.Source_System_Detail__c = accSSD.id;
        invitedClg2.Email__c = 'invclgemail@test.com';
        invitedClg2.Primary_User__c = true;
        invitedClg2.SapContactId__c = con.SAP_Contact_ID__c;
        insert invitedClg2;

        LIST<WebServiceSettings__c > webList = new LIST<WebServiceSettings__c > ();
        WebServiceSettings__c web = new WebServiceSettings__c();
        web.Endpoint__c = 'test.endpoint';
        web.Name = 'ODTSubscriptionService';
        web.Username__c = 'test.user';
        web.Password__c = 'test:123';
        web.Service_Unavailable_Message__c = 'testservice';
        webList.add(web);

        WebServiceSettings__c web2 = new WebServiceSettings__c();
        web2.Endpoint__c = 'test.endpoint';
        web2.Name = 'ODTGenericEntitlementService';
        web2.Username__c = 'test.user';
        web2.Password__c = 'test:123';
        web2.Service_Unavailable_Message__c = 'testservice';
        webList.add(web2);

        WebServiceSettings__c webs3 = new WebServiceSettings__c();
        webs3.Endpoint__c = 'test2.endpoint';
        webs3.Name = 'ODTEloquaService';
        webs3.Username__c = 'test2.user';
        webs3.Password__c = 'test2:123';
        webs3.Service_Unavailable_Message__c = 'test2service';
        webList.add(webs3);

        WebServiceSettings__c webs4 = new WebServiceSettings__c();
        webs4.Endpoint__c = 'test2.endpoint';
        webs4.Name = 'ODTEloquaServiceSFDCSource'; //ODTEloquaServiceOtherSources
        webs4.Username__c = 'test2.user';
        webs4.Password__c = 'test2:123';
        webs4.Service_Unavailable_Message__c = 'test2service';
        webList.add(webs4);

        WebServiceSettings__c webs5 = new WebServiceSettings__c();
        webs5.Endpoint__c = 'test2.endpoint';
        webs5.Name = 'ODTGetLapsedAccountDetails'; //ODTEloquaServiceOtherSources
        webs5.Username__c = 'test2.user';
        webs5.Password__c = 'test2:123';
        webs5.Service_Unavailable_Message__c = 'test2service';
        webList.add(webs5);

        insert webList;

        LIST<Static_Values__c > staticCSList = new LIST<Static_Values__c > ();
        Static_Values__c stl = new Static_Values__c(name = 'GLIOpportunityRecordType', value__c = 'GLI Pipeline Opportunity');
        Static_Values__c stl1 = new Static_Values__c(name = 'DisplayNCJFromECJ', value__c = 'True');
        staticCSList.add(stl);
        staticCSList.add(stl1);
        insert staticCSList;

        ODT_Market_Segments__mdt odtSeg1 = [SELECT Id, Market_Segment__c, Business_Type__c FROM ODT_Market_Segments__mdt where Market_Segment__c =: accSSD.BU_Segment_Level_2__c];

        //To create ODT Product Bundle Records
        List<ODT_Product_Bundle__c > listPrdBnlODT = New List<ODT_Product_Bundle__c > ();
        ODT_Product_Bundle__c prdBndl1 = New ODT_Product_Bundle__c();
        prdBndl1.Name = 'Indigo';
        prdBndl1.Bundle_ID__c = '725545';
        prdBndl1.Is_Active__c = true;
        prdBndl1.Trial_Expiry_Days__c=7;
        prdBndl1.Is_Enabled_For_Sales_Rep_Trial__c = true;
        prdBndl1.Product_Category__c = 'IND1';
        prdBndl1.Bundle_Type__c = 'CTX';
        prdBndl1.Business_Type__c = 'SLF';
        prdBndl1.Contacts_User_Type__c = 'EXISTING_USER_NEW_DOMAIN';
        prdBndl1.Profile_ID__c = '431';
        prdBndl1.Hive9_Media_Code__c = '9007949';
        prdBndl1.SAP_Promotion_Code__c = '1234';
        listPrdBnlODT.add(prdBndl1);
        insert listPrdBnlODT;

        apexpages.currentpage().getparameters().put('oppID', opp.id);
        apexpages.currentpage().getparameters().put('id', newAcct.id);
        apexpages.currentpage().getparameters().put('ssdID', accSSD.id);
        apexpages.currentpage().getparameters().put('OLCStatus', 'Active');
        ApexPages.StandardController scon = new ApexPages.StandardController(newAcct);
        contactsListCon cto = new contactsListCon(scon);
        cto.getSDDRecordId = accSSD.id;
        cto.executeAcctSSD();
        cto.newCustomerRedirect();

        system.debug('Test' + cto.contasTodisplay);
        string odtDomainSelected;
        odtDomainSelected = prdBndl1.Bundle_ID__c;

        string selectedDomain = apexpages.currentpage().getparameters().put('selectedDomain', odtDomainSelected);

        cto.startTrial();

        apexpages.currentpage().getparameters().put('oppID', null);
        cto.startTrial();
        apexpages.currentpage().getparameters().put('oppID', opp.id);

        string selectedcustomer = apexpages.currentpage().getparameters().put('selectedContact', con.SAP_Contact_ID__c);
        String emailOrPhone = apexpages.currentpage().getparameters().put('emailOrPhone', 'false');

        //fetching the name of the product 
        String prodName;
        prodName = prdBndl1.Name;
        cto.refreshDomain();
        cto.listPrdBundle.addAll(listPrdBnlODT);
        system.debug('contasTodisplay--->' + cto.contasTodisplay);

        Test.startTest();

        cto.startTrial();
        cto.closeEloquaPopup();

        String emailOrPhoneTrue = apexpages.currentpage().getparameters().put('emailOrPhone', 'true');
        cto.startTrial();

        String selectedTrialOption = apexpages.currentpage().getparameters().put('selectedTrialOption', 'Start by Phone');
        cto.refreshTrialSelectionOptions();

        String selectedTrialOptionByEmail = apexpages.currentpage().getparameters().put('selectedTrialOption', 'Send Email Invitation');
        cto.refreshTrialSelectionOptions();

        system.debug('start wrapper testclasses.');
        EsiResponseWrapper.onlineContact esion = new EsiResponseWrapper.onlineContact();
        string s1 = esion.contactNumber;

        LapsedAccountResponse lapsedSub = new LapsedAccountResponse();
        system.debug('End of wrapper testclasses............');

        Test.stopTest();
    }
    public static testMethod void testContactListCreation2() {
        Profile p1 = [SELECT Id FROM Profile WHERE Name =: 'ANZ Users'];
        User u = [Select ID, Sales_Org__c FROM User where Sales_Org__c = 'LRA'
            AND Profile.id =: p1.id limit 1
        ];
        System.assert(u!=null,'No user found');
        Map<String, Schema.RecordTypeInfo > recordTypes = Opportunity.sObjectType.getDescribe().getRecordTypeInfosByName();
        Id optyPipeRecTypeId = recordTypes.get('Pipeline Opportunity').getRecordTypeId();
        Id optyPreRecTypeID = recordTypes.get('Pre-Pipeline Opportunity').getRecordTypeId();
        Id optyGLIRecTypeID = recordTypes.get('GLI Pipeline Opportunity').getRecordTypeId();
        RecordType defaultRecordType = [SELECT id,Name FROM RecordType WHERE SobjectType='Opportunity' Limit 1];
        System.debug('Pipeline' + optyPipeRecTypeId + 'Pre-pipeline' + optyPreRecTypeID + 'GLI pipeline' + optyGLIRecTypeID);

        //Keyvalue setting for OpportunityUtil class
        KeyValueListStore__C keyCustomSetting = new KeyValueListStore__c(Name = 'ANZUsersProfileId', TextValue__c = p1.id);
        insert keyCustomSetting;

        RecordtypeIds__c recT1 = new RecordtypeIds__c();
        recT1.Name = 'Pipeline Opportunities';
        recT1.recTypeId__C = optyPipeRecTypeId != null ? optyPipeRecTypeId : defaultRecordType.id;
        insert recT1;

        RecordtypeIds__c recT2 = new RecordtypeIds__c();
        recT2.Name = 'GLI Pipeline Opportunity';
        recT2.recTypeId__C = optyGLIRecTypeID != null ? optyGLIRecTypeID : defaultRecordType.id;
        insert recT2;

        RecordtypeIds__c recT = new RecordtypeIds__c();
        recT.name = 'Pre-Pipeline Opportunities';
        recT.recTypeId__C = optyPreRecTypeID != null ? optyPreRecTypeID : defaultRecordType.id;
        insert recT;

        Pricebook2 pbook = new Pricebook2();
        pbook.name = 'GLI Price Book - US Legal/LMS';
        pbook.IsActive = true;
        insert pbook;

        WebServiceSettings__c web1Service = new WebServiceSettings__c();
        web1Service.Endpoint__c = 'test.endpoint';
        web1Service.Name = 'ODTReactivateEntitlementService';
        web1Service.Username__c = 'test.user';
        web1Service.Password__c = 'test:123';
        web1Service.Service_Unavailable_Message__c = 'testservice';

        insert web1Service;

        List < WebServiceSettings__c > webserviceList = new List < WebServiceSettings__c > {
            new WebServiceSettings__c(Name = 'EnterpriseWSDL', Endpoint__c = 'https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount', Service_Unavailable_Message__c = 'Service not Available'),
            new WebServiceSettings__c(Name = 'StatusPostbackLocation', Endpoint__c = 'https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount', Service_Unavailable_Message__c = 'Service not Available'),
            new WebServiceSettings__c(Name = 'PostbackLocation', Endpoint__c = 'https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount', Service_Unavailable_Message__c = 'Service not Available'),
            new WebServiceSettings__c(Name = 'Payment AutoCharge', Endpoint__c = 'https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount', Service_Unavailable_Message__c = 'Service not Available'),
            new WebServiceSettings__c(Name = 'PaymentCreditIncrease', Endpoint__c = 'https://testingfromsfdc.com/processReq', Service_Unavailable_Message__c = 'Service not Available')
        };
        insert webserviceList;

        // create Account
        Account newAcct = new Account();
        newAcct.Name = 'Test Class Account';
        newAcct.SAPAccountNumber__c = '173468929';
        newAcct.BillingState = 'FL';
        newAcct.BillingCity = 'Orlando';
        newAcct.BillingCountry = 'US';
        newAcct.BillingPostalCode = '32801';
        newAcct.BillingStreet = '223 E. Concord Street';
        newAcct.Phone = '08061393678';
        newAcct.OwnerId = UserInfo.getUserId();
        insert newAcct;

        //Create AccountSSD record
        Source_System_Detail__c accSSD = new Source_System_Detail__c();
        accSSD.Name = 'Test Account SSD';
        accSSD.Source_System_Name__c = 'Test System';
        accSSD.Source_System_Account_Number__c = '173468930';
        accSSD.Account_Name__c = newAcct.id;
        accSSD.Trial_Status__c = '';
        accSSD.BU_Segment_Level_2__c = 'SLF 4-6';
        insert accSSD;

        //Create Contact
        Contact con = new Contact();
        con.FirstName = 'John';
        con.LastName = 'Ray';
        con.SAP_Contact_ID__c = '0006271252';
        con.AccountId = newAcct.id;
        con.Email = 'john.ray@tr.com';
        insert con;

        //create lead
        Lead newlead = new Lead();
        Map<String,Schema.RecordTypeInfo> leadRecordTypeInfo = Schema.SObjectType.Lead.getRecordTypeInfosByName(); 
        Id leadRecordTypeId = leadRecordTypeInfo.get('S2E').getRecordTypeId();
        newLead.FirstName = con.FirstName;
        newLead.LastName = con.LastName;
        newLead.Email = 'System.now()@mailinator.com';
        newLead.Company = newAcct.Name;
        newLead.Type__c = 'A';
        newLead.Sales_Org__c = 'WEST';
        newLead.RecordTypeId = leadRecordTypeId;
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
        newLead.Form_Organization_Type__c = '';
        newLead.Phone = newAcct.Phone;
        newLead.Campaign_Cell__c = 'Free Trial';
        insert newLead;

        //create opportunity
        Id ssdRecorType = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();

        Opportunity opp = new Opportunity();
        opp.Name = 'Test Opportunity';
        opp.closeDate = System.Today() + 5;
        opp.recordTypeId = ssdRecorType;
        opp.Owner = u;
        opp.StageName = 'Prospect';
        opp.AccountId = newAcct.Id;
        opp.Pricebook2id = pbook.id;
        opp.Source_System_Detail__c = accSSD.Id;
        insert opp;

        //create Trial
        Trial__c tr = new Trial__c();
        tr.Source_System_Detail__c = accSSD.id;
        tr.Trial_Id__c = '56576';
        tr.Contact_LeadId__c = newLead.Id;
        tr.Contact_id_SAP__c = con.SAP_Contact_ID__c;
        tr.Trial_Source__c = label.ODT_Trial_Source;
        tr.ODT_Email__c = 'invclgemail@test.com';
        tr.Trial_Initiated_Mode__c = 'Started Immediately';
        tr.Profile_Type__c = 'NET_NEW';
        tr.InvitedDateTime__c = System.today() - 20;
        tr.Trial_Status__c = 'Timed-out';
        insert tr;

        //create Invited Colleague
        Invite_Colleagues__c invitedClg1 = New Invite_Colleagues__c();
        invitedClg1.First_Name__c = 'test invite';
        invitedClg1.Last_Name__c = 'tessstt';
        invitedClg1.Trial_Status__c = 'Rep Initiated';
        invitedClg1.Trial__c = tr.id;
        invitedClg1.Source_System_Detail__c = accSSD.id;
        invitedClg1.Email__c = 'invclgemail@test.com';
        invitedClg1.Primary_User__c = true;
        invitedClg1.SapContactId__c = con.SAP_Contact_ID__c;
        insert invitedClg1;

        //create Trial
        Trial__c tr1 = new Trial__c();
        tr1.Source_System_Detail__c = accSSD.id;
        tr1.Trial_Id__c = '56576';
        tr1.Contact_LeadId__c = newLead.Id;
        tr1.Contact_id_SAP__c = con.SAP_Contact_ID__c;
        tr1.Trial_Source__c = label.ODT_Trial_Source;
        tr1.ODT_Email__c = 'invclgemail@test.com';
        tr1.Trial_Initiated_Mode__c = 'Started by Marketing';
        tr1.Profile_Type__c = 'EXISTING_USER_SAME_DOMAIN';
        tr1.InvitedDateTime__c = System.today() - 20;
        tr1.Trial_Status__c = 'Timed-out';
        insert tr1;

        //create Invited Colleague
        Invite_Colleagues__c invitedClg2 = New Invite_Colleagues__c();
        invitedClg2.First_Name__c = 'test invite';
        invitedClg2.Last_Name__c = 'tessstt';
        invitedClg2.Trial_Status__c = 'Rep Initiated';
        invitedClg2.Trial__c = tr1.id;
        invitedClg2.Source_System_Detail__c = accSSD.id;
        invitedClg2.Email__c = 'invclgemail@test.com';
        invitedClg2.Primary_User__c = true;
        invitedClg2.SapContactId__c = con.SAP_Contact_ID__c;
        insert invitedClg2;

        LIST<WebServiceSettings__c > webList = new LIST<WebServiceSettings__c > ();
        WebServiceSettings__c web = new WebServiceSettings__c();
        web.Endpoint__c = 'test.endpoint';
        web.Name = 'ODTSubscriptionService';
        web.Username__c = 'test.user';
        web.Password__c = 'test:123';
        web.Service_Unavailable_Message__c = 'testservice';
        webList.add(web);

        WebServiceSettings__c web2 = new WebServiceSettings__c();
        web2.Endpoint__c = 'test.endpoint';
        web2.Name = 'ODTGenericEntitlementService';
        web2.Username__c = 'test.user';
        web2.Password__c = 'test:123';
        web2.Service_Unavailable_Message__c = 'testservice';
        webList.add(web2);

        WebServiceSettings__c webs3 = new WebServiceSettings__c();
        webs3.Endpoint__c = 'test2.endpoint';
        webs3.Name = 'ODTEloquaService';
        webs3.Username__c = 'test2.user';
        webs3.Password__c = 'test2:123';
        webs3.Service_Unavailable_Message__c = 'test2service';
        webList.add(webs3);

        WebServiceSettings__c webs4 = new WebServiceSettings__c();
        webs4.Endpoint__c = 'test2.endpoint';
        webs4.Name = 'ODTEloquaServiceSFDCSource'; //ODTEloquaServiceOtherSources
        webs4.Username__c = 'test2.user';
        webs4.Password__c = 'test2:123';
        webs4.Service_Unavailable_Message__c = 'test2service';
        webList.add(webs4);

        WebServiceSettings__c webs5 = new WebServiceSettings__c();
        webs5.Endpoint__c = 'test2.endpoint';
        webs5.Name = 'ODTGetLapsedAccountDetails'; //ODTEloquaServiceOtherSources
        webs5.Username__c = 'test2.user';
        webs5.Password__c = 'test2:123';
        webs5.Service_Unavailable_Message__c = 'test2service';
        webList.add(webs5);

        insert webList;

        LIST<Static_Values__c > staticCSList = new LIST<Static_Values__c > ();
        Static_Values__c stl = new Static_Values__c(name = 'GLIOpportunityRecordType', value__c = 'GLI Pipeline Opportunity');
        Static_Values__c stl1 = new Static_Values__c(name = 'DisplayNCJFromECJ', value__c = 'True');
        staticCSList.add(stl);
        staticCSList.add(stl1);
        insert staticCSList;

        ODT_Market_Segments__mdt odtSeg1 = [SELECT Id, Market_Segment__c, Business_Type__c FROM ODT_Market_Segments__mdt where Market_Segment__c =: accSSD.BU_Segment_Level_2__c];

        //To create ODT Product Bundle Records
        List<ODT_Product_Bundle__c > listPrdBnlODT = New List<ODT_Product_Bundle__c > ();
        ODT_Product_Bundle__c prdBndl1 = New ODT_Product_Bundle__c();
        prdBndl1.Name = 'Indigo';
        prdBndl1.Bundle_ID__c = '725545';
        prdBndl1.Is_Active__c = true;
        prdBndl1.Trial_Expiry_Days__c=7;
        prdBndl1.Is_Enabled_For_Sales_Rep_Trial__c = true;
        prdBndl1.Product_Category__c = 'IND1';
        prdBndl1.Bundle_Type__c = 'CTX';
        prdBndl1.Business_Type__c = 'SLF';
        prdBndl1.Contacts_User_Type__c = 'EXISTING_USER_NEW_DOMAIN';
        prdBndl1.Profile_ID__c = '431';
        prdBndl1.Hive9_Media_Code__c = '9007949';
        prdBndl1.SAP_Promotion_Code__c = '1234';
        listPrdBnlODT.add(prdBndl1);
        insert listPrdBnlODT;

        Test.startTest();

        CallToOLCTofetchActiveTr.CallOLCForActiveTrials(accSSD.Source_System_Account_Number__c);

        Test.setMock(HttpCalloutMock.class, new HttpResponseMock());
        String productCategory = prdBndl1.Product_Category__c;
        Id productId = prdBndl1.Id;
        string odtDomainSelected;
        odtDomainSelected = prdBndl1.Bundle_ID__c;

        string selectedDomain = apexpages.currentpage().getparameters().put('selectedDomain', odtDomainSelected);
        string selectedcustomer = apexpages.currentpage().getparameters().put('selectedContact', con.SAP_Contact_ID__c);
        String emailOrPhone = apexpages.currentpage().getparameters().put('emailOrPhone', 'false');

        CallToOLCTofetchActiveTr.createOpportunity(newAcct, con.firstName, con.lastName, con.email, 'A', accSSD, null, null, null);
        CallToOLCTofetchActiveTr.createOpportunityTrialJun(opp.ID, tr.ID);
        CallToOLCTofetchActiveTr.createInvitedColleague(accSSD.id, con.Email, con.firstName, con.lastName, con.SAP_Contact_ID__c, tr.ID, true, invitedClg2.Id);
        CallToOLCTofetchActiveTr.createTrial(odtDomainSelected, con.SAP_Contact_ID__c, accSSD.id, con.Email, accSSD.Source_System_Account_Number__c, productId, productCategory, null, null, false, 'EXISTING_USER_NEW_DOMAIN', '431', '12345', false);

        ContactsListConCallout clcv1 = new ContactsListConCallout(con.firstName, con.lastName, con.email, newAcct.SAPAccountNumber__c, con.SAP_Contact_ID__c, newAcct.Id, con.Id, '12344', selectedDomain, selectedcustomer, newLead.Id, tr.id, newAcct.Id, 'V2', 'invite', tr.Trial_Source__c, tr.Trial_End_Date__c, null, null, false, false, null, null);
        System.enqueueJob(clcv1);

        ContactsListConCallout clcv2 = new ContactsListConCallout(con.firstName, con.lastName, con.email, newAcct.SAPAccountNumber__c, con.SAP_Contact_ID__c, newAcct.Id, con.Id, '12344', selectedDomain, selectedcustomer, newLead.Id, tr1.id, newAcct.Id, 'V2', 'invite', tr1.Trial_Source__c, tr1.Trial_End_Date__c, null, null, false, false, null, null);
        System.enqueueJob(clcv2);

        EloquaEmailCallouts clcv3 = new EloquaEmailCallouts(con.firstName, con.lastName, con.email, newAcct.SAPAccountNumber__c, con.SAP_Contact_ID__c, newAcct.Id, con.Id, '12344', selectedDomain, selectedcustomer, newLead.Id, tr.id, newAcct.Id, 'V2', 'invite', tr.Trial_Source__c, tr.Trial_End_Date__c, null, null, false, false, null, null, 'NET_NEW');
        System.enqueueJob(clcv3);

        EloquaEmailCallouts clcv4 = new EloquaEmailCallouts(con.firstName, con.lastName, con.email, newAcct.SAPAccountNumber__c, con.SAP_Contact_ID__c, newAcct.Id, con.Id, '12344', selectedDomain, selectedcustomer, newLead.Id, tr1.id, newAcct.Id, 'V2', 'invite', tr1.Trial_Source__c, tr1.Trial_End_Date__c, null, null, false, false, null, null, 'NET_NEW');
        System.enqueueJob(clcv4);

    }

    public static testMethod void testContactListCreation3() {
        Profile p1 = [SELECT Id FROM Profile WHERE Name =: 'ANZ Users'];
        User u = [Select ID, Sales_Org__c FROM User where Sales_Org__c = 'LRA'
            AND Profile.id =: p1.id limit 1
        ];
        System.assert(u!=null,'No user found');
        Map<String, Schema.RecordTypeInfo > recordTypes = Opportunity.sObjectType.getDescribe().getRecordTypeInfosByName();
        Id optyPipeRecTypeId = recordTypes.get('Pipeline Opportunity').getRecordTypeId();
        Id optyPreRecTypeID = recordTypes.get('Pre-Pipeline Opportunity').getRecordTypeId();
        Id optyGLIRecTypeID = recordTypes.get('GLI Pipeline Opportunity').getRecordTypeId();
        RecordType defaultRecordType = [SELECT id,Name FROM RecordType WHERE SobjectType='Opportunity' Limit 1];
        System.debug('Pipeline' + optyPipeRecTypeId + 'Pre-pipeline' + optyPreRecTypeID + 'GLI pipeline' + optyGLIRecTypeID);

        //Keyvalue setting for OpportunityUtil class
        KeyValueListStore__C keyCustomSetting = new KeyValueListStore__c(Name = 'ANZUsersProfileId', TextValue__c = p1.id);
        insert keyCustomSetting;

        RecordtypeIds__c recT1 = new RecordtypeIds__c();
        recT1.Name = 'Pipeline Opportunities';
        recT1.recTypeId__C = optyPipeRecTypeId != null ? optyPipeRecTypeId : defaultRecordType.id;
        insert recT1;

        RecordtypeIds__c recT2 = new RecordtypeIds__c();
        recT2.Name = 'GLI Pipeline Opportunity';
        recT2.recTypeId__C = optyGLIRecTypeID != null ? optyGLIRecTypeID : defaultRecordType.id;
        insert recT2;

        RecordtypeIds__c recT = new RecordtypeIds__c();
        recT.name = 'Pre-Pipeline Opportunities';
        recT.recTypeId__C = optyPreRecTypeID != null ? optyPreRecTypeID : defaultRecordType.id;
        insert recT;

        Pricebook2 pbook = new Pricebook2();
        pbook.name = 'GLI Price Book - US Legal/LMS';
        pbook.IsActive = true;
        insert pbook;

        WebServiceSettings__c web1Service = new WebServiceSettings__c();
        web1Service.Endpoint__c = 'test.endpoint';
        web1Service.Name = 'ODTReactivateEntitlementService';
        web1Service.Username__c = 'test.user';
        web1Service.Password__c = 'test:123';
        web1Service.Service_Unavailable_Message__c = 'testservice';

        insert web1Service;

        List < WebServiceSettings__c > webserviceList = new List < WebServiceSettings__c > {
            new WebServiceSettings__c(Name = 'EnterpriseWSDL', Endpoint__c = 'https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount', Service_Unavailable_Message__c = 'Service not Available'),
            new WebServiceSettings__c(Name = 'StatusPostbackLocation', Endpoint__c = 'https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount', Service_Unavailable_Message__c = 'Service not Available'),
            new WebServiceSettings__c(Name = 'PostbackLocation', Endpoint__c = 'https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount', Service_Unavailable_Message__c = 'Service not Available'),
            new WebServiceSettings__c(Name = 'Payment AutoCharge', Endpoint__c = 'https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount', Service_Unavailable_Message__c = 'Service not Available'),
            new WebServiceSettings__c(Name = 'PaymentCreditIncrease', Endpoint__c = 'https://testingfromsfdc.com/processReq', Service_Unavailable_Message__c = 'Service not Available')
        };
        insert webserviceList;

        // create Account
        Account newAcct = new Account();
        newAcct.Name = 'Test Class Account';
        newAcct.SAPAccountNumber__c = '173468929';
        newAcct.BillingState = 'FL';
        newAcct.BillingCity = 'Orlando';
        newAcct.BillingCountry = 'US';
        newAcct.BillingPostalCode = '32801';
        newAcct.BillingStreet = '223 E. Concord Street';
        newAcct.Phone = '08061393678';
        newAcct.OwnerId = UserInfo.getUserId();
        insert newAcct;

        //Create AccountSSD record
        Source_System_Detail__c accSSD = new Source_System_Detail__c();
        accSSD.Name = 'Test Account SSD';
        accSSD.Source_System_Name__c = 'Test System';
        accSSD.Source_System_Account_Number__c = '173468930';
        accSSD.Account_Name__c = newAcct.id;
        accSSD.Trial_Status__c = '';
        accSSD.BU_Segment_Level_2__c = 'SLF 4-6';
        insert accSSD;

        //Create Contact
        Contact con = new Contact();
        con.FirstName = 'John';
        con.LastName = 'Ray';
        con.SAP_Contact_ID__c = '0006271252';
        con.AccountId = newAcct.id;
        con.Email = 'john.ray@tr.com';
        insert con;

        //create lead
        Lead newlead = new Lead();
        Map<String,Schema.RecordTypeInfo> leadRecordTypeInfo = Schema.SObjectType.Lead.getRecordTypeInfosByName(); 
        Id leadRecordTypeId = leadRecordTypeInfo.get('S2E').getRecordTypeId();
        newLead.FirstName = con.FirstName;
        newLead.LastName = con.LastName;
        newLead.Email = 'System.now()@mailinator.com';
        newLead.Company = newAcct.Name;
        newLead.Type__c = 'A';
        newLead.Sales_Org__c = 'WEST';
        newLead.RecordTypeId = leadRecordTypeId;
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
        newLead.Form_Organization_Type__c = '';
        newLead.Phone = newAcct.Phone;
        newLead.Campaign_Cell__c = 'Free Trial';
        insert newLead;

        //create opportunity
        Id ssdRecorType = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();

        Opportunity opp = new Opportunity();
        opp.Name = 'Test Opportunity';
        opp.closeDate = System.Today() + 5;
        opp.recordTypeId = ssdRecorType;
        opp.Owner = u;
        opp.StageName = 'Prospect';
        opp.AccountId = newAcct.Id;
        opp.Pricebook2id = pbook.id;
        opp.Source_System_Detail__c = accSSD.Id;
        insert opp;

        //create Trial
        Trial__c tr = new Trial__c();
        tr.Source_System_Detail__c = accSSD.id;
        tr.Trial_Id__c = '56576';
        tr.Contact_LeadId__c = newLead.Id;
        tr.Contact_id_SAP__c = con.SAP_Contact_ID__c;
        tr.Trial_Source__c = label.ODT_Trial_Source;
        tr.ODT_Email__c = 'invclgemail@test.com';
        tr.Trial_Initiated_Mode__c = 'Started Immediately';
        tr.Profile_Type__c = 'NET_NEW';
        tr.InvitedDateTime__c = System.today() - 20;
        tr.Trial_Status__c = 'Timed-out';
        insert tr;

        //create Invited Colleague
        Invite_Colleagues__c invitedClg1 = New Invite_Colleagues__c();
        invitedClg1.First_Name__c = 'test invite';
        invitedClg1.Last_Name__c = 'tessstt';
        invitedClg1.Trial_Status__c = 'Rep Initiated';
        invitedClg1.Trial__c = tr.id;
        invitedClg1.Source_System_Detail__c = accSSD.id;
        invitedClg1.Email__c = 'invclgemail@test.com';
        invitedClg1.Primary_User__c = true;
        invitedClg1.SapContactId__c = con.SAP_Contact_ID__c;
        insert invitedClg1;

        //create Trial
        Trial__c tr1 = new Trial__c();
        tr1.Source_System_Detail__c = accSSD.id;
        tr1.Trial_Id__c = '56576';
        tr1.Contact_LeadId__c = newLead.Id;
        tr1.Contact_id_SAP__c = con.SAP_Contact_ID__c;
        tr1.Trial_Source__c = label.ODT_Trial_Source;
        tr1.ODT_Email__c = 'invclgemail@test.com';
        tr1.Trial_Initiated_Mode__c = 'Started by Marketing';
        tr1.Profile_Type__c = 'EXISTING_USER_SAME_DOMAIN';
        tr1.InvitedDateTime__c = System.today() - 20;
        tr1.Trial_Status__c = 'Timed-out';
        insert tr1;

        //create Invited Colleague
        Invite_Colleagues__c invitedClg2 = New Invite_Colleagues__c();
        invitedClg2.First_Name__c = 'test invite';
        invitedClg2.Last_Name__c = 'tessstt';
        invitedClg2.Trial_Status__c = 'Rep Initiated';
        invitedClg2.Trial__c = tr1.id;
        invitedClg2.Source_System_Detail__c = accSSD.id;
        invitedClg2.Email__c = 'invclgemail@test.com';
        invitedClg2.Primary_User__c = true;
        invitedClg2.SapContactId__c = con.SAP_Contact_ID__c;
        insert invitedClg2;

        LIST<WebServiceSettings__c > webList = new LIST<WebServiceSettings__c > ();
        WebServiceSettings__c web = new WebServiceSettings__c();
        web.Endpoint__c = 'test.endpoint';
        web.Name = 'ODTSubscriptionService';
        web.Username__c = 'test.user';
        web.Password__c = 'test:123';
        web.Service_Unavailable_Message__c = 'testservice';
        webList.add(web);

        WebServiceSettings__c web2 = new WebServiceSettings__c();
        web2.Endpoint__c = 'test.endpoint';
        web2.Name = 'ODTGenericEntitlementService';
        web2.Username__c = 'test.user';
        web2.Password__c = 'test:123';
        web2.Service_Unavailable_Message__c = 'testservice';
        webList.add(web2);

        WebServiceSettings__c webs3 = new WebServiceSettings__c();
        webs3.Endpoint__c = 'test2.endpoint';
        webs3.Name = 'ODTEloquaService';
        webs3.Username__c = 'test2.user';
        webs3.Password__c = 'test2:123';
        webs3.Service_Unavailable_Message__c = 'test2service';
        webList.add(webs3);

        WebServiceSettings__c webs4 = new WebServiceSettings__c();
        webs4.Endpoint__c = 'test2.endpoint';
        webs4.Name = 'ODTEloquaServiceSFDCSource'; //ODTEloquaServiceOtherSources
        webs4.Username__c = 'test2.user';
        webs4.Password__c = 'test2:123';
        webs4.Service_Unavailable_Message__c = 'test2service';
        webList.add(webs4);

        WebServiceSettings__c webs5 = new WebServiceSettings__c();
        webs5.Endpoint__c = 'test2.endpoint';
        webs5.Name = 'ODTGetLapsedAccountDetails'; //ODTEloquaServiceOtherSources
        webs5.Username__c = 'test2.user';
        webs5.Password__c = 'test2:123';
        webs5.Service_Unavailable_Message__c = 'test2service';
        webList.add(webs5);

        insert webList;

        LIST<Static_Values__c > staticCSList = new LIST<Static_Values__c > ();
        Static_Values__c stl = new Static_Values__c(name = 'GLIOpportunityRecordType', value__c = 'GLI Pipeline Opportunity');
        Static_Values__c stl1 = new Static_Values__c(name = 'DisplayNCJFromECJ', value__c = 'True');
        staticCSList.add(stl);
        staticCSList.add(stl1);
        insert staticCSList;

        ODT_Market_Segments__mdt odtSeg1 = [SELECT Id, Market_Segment__c, Business_Type__c FROM ODT_Market_Segments__mdt where Market_Segment__c =: accSSD.BU_Segment_Level_2__c];

        //To create ODT Product Bundle Records
        List<ODT_Product_Bundle__c > listPrdBnlODT = New List<ODT_Product_Bundle__c > ();
        ODT_Product_Bundle__c prdBndl1 = New ODT_Product_Bundle__c();
        prdBndl1.Name = 'Indigo';
        prdBndl1.Bundle_ID__c = '725545';
        prdBndl1.Is_Active__c = true;
        prdBndl1.Trial_Expiry_Days__c=7;
        prdBndl1.Is_Enabled_For_Sales_Rep_Trial__c = true;
        prdBndl1.Product_Category__c = 'IND1';
        prdBndl1.Bundle_Type__c = 'CTX';
        prdBndl1.Business_Type__c = 'SLF';
        prdBndl1.Contacts_User_Type__c = 'EXISTING_USER_NEW_DOMAIN';
        prdBndl1.Profile_ID__c = '431';
        prdBndl1.Hive9_Media_Code__c = '9007949';
        prdBndl1.SAP_Promotion_Code__c = '1234';
        listPrdBnlODT.add(prdBndl1);
        insert listPrdBnlODT;

        apexpages.currentpage().getparameters().put('oppID', opp.id);
        apexpages.currentpage().getparameters().put('id', newAcct.id);
        apexpages.currentpage().getparameters().put('ssdID', accSSD.id);
        apexpages.currentpage().getparameters().put('OLCStatus', 'Active');
        ApexPages.StandardController scon = new ApexPages.StandardController(newAcct);
        Test.startTest();

        // Added as Part of DLT-12948 by Rohit
        ODT_TrialDetailsCon trll = new ODT_TrialDetailsCon(scon);
        trll.sendDetails();
        //DLT-12948 ends

        //DLT-16849 by Sneha
        PageReference oPage = Page.contactslist;
        Test.setCurrentPage(oPage);
        trll.callToContactListPage();
        //DLT-16849 ends

        //DLT-12946 and DLT-12949 Starts:Added by Harshitha
        Lead_Trials__c leadT = new Lead_Trials__c();
        leadT.Lead__c = newLead.Id;
        leadT.Trial__c = tr.Id;
        insert leadT;

        apexpages.currentpage().getparameters().put('id', newLead.id);
        ApexPages.StandardController cont = new ApexPages.StandardController(newLead);
        ODT_trialInitiationFromLeadController trialFromLead = new ODT_trialInitiationFromLeadController(cont);
        trialFromLead.fetchTrialDetails();
        //DLT-12946 and DLT-12949 Ends

        Test.stopTest();
    }

    public static testMethod void testContactListCreationTwo() {
        Profile p1 = [SELECT Id FROM Profile WHERE Name =: 'ANZ Users'];
        User u = [Select ID, Sales_Org__c FROM User where Sales_Org__c = 'LRA'
            AND Profile.id =: p1.id limit 1
        ];
        System.assert(u!=null, 'No user found');
        //Keyvalue setting for OpportunityUtil class
        KeyValueListStore__C keyCustomSetting = new KeyValueListStore__c(Name = 'ANZUsersProfileId', TextValue__c = p1.id);
        insert keyCustomSetting;

        Pricebook2 pbook = new Pricebook2();
        pbook.name = 'GLI Price Book - US Legal/LMS';
        pbook.IsActive = true;
        insert pbook;

        WebServiceSettings__c web1Service = new WebServiceSettings__c();
        web1Service.Endpoint__c = 'test.endpoint';
        web1Service.Name = 'ODTReactivateEntitlementService';
        web1Service.Username__c = 'test.user';
        web1Service.Password__c = 'test:123';
        web1Service.Service_Unavailable_Message__c = 'testservice';

        insert web1Service;

        List<WebServiceSettings__c > webserviceList = new List<WebServiceSettings__c > {
            new WebServiceSettings__c(Name = 'EnterpriseWSDL', Endpoint__c = 'https://api.thomsonreuters.com/ebs/entitlement/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount', Service_Unavailable_Message__c = 'Service not Available'),
            new WebServiceSettings__c(Name = 'StatusPostbackLocation', Endpoint__c = 'https://api.thomsonreuters.com/ebs/entitlement/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount', Service_Unavailable_Message__c = 'Service not Available'),
            new WebServiceSettings__c(Name = 'PostbackLocation', Endpoint__c = 'https://api.thomsonreuters.com/ebs/entitlement/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount', Service_Unavailable_Message__c = 'Service not Available'),
            new WebServiceSettings__c(Name = 'PaymentCreditIncrease', Endpoint__c = 'https://api.thomsonreuters.com/ebs/entitlement/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount', Service_Unavailable_Message__c = 'Service not Available'),
            new WebServiceSettings__c(Name = 'Payment AutoCharge', Endpoint__c = 'https://api.thomsonreuters.com/ebs/entitlement/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount', Service_Unavailable_Message__c = 'Service not Available')
        };
        insert webserviceList;

        // create Account
        Account newAcct = new Account();
        newAcct.Name = 'Test Class Account';
        newAcct.SAPAccountNumber__c = '173468929';
        newAcct.BillingState = 'FL';
        newAcct.BillingCity = 'Orlando';
        newAcct.BillingCountry = 'US';
        newAcct.BillingPostalCode = '32801';
        newAcct.BillingStreet = '223 E. Concord Street';
        newAcct.Phone = '08061393678';
        newAcct.OwnerId = UserInfo.getUserId();
        insert newAcct;

        //Create AccountSSD record
        Source_System_Detail__c accSSD = new Source_System_Detail__c();
        accSSD.Name = 'Test Account SSD';
        accSSD.Source_System_Name__c = 'Test System';
        accSSD.Source_System_Account_Number__c = '173468930';
        accSSD.Account_Name__c = newAcct.id;
        accSSD.Trial_Status__c = '';
        accSSD.BU_Segment_Level_2__c = 'SLF 4-6';
        insert accSSD;

        //Create Contact
        Contact con = new Contact();
        con.FirstName = 'John';
        con.LastName = 'Ray';
        con.SAP_Contact_ID__c = '0006271252';
        con.AccountId = newAcct.id;
        con.Email = 'john.ray@tr.com';
        insert con;

        //create lead
        Lead newlead = new Lead();
        Map<String,Schema.RecordTypeInfo> leadRecordTypeInfo = Schema.SObjectType.Lead.getRecordTypeInfosByName(); 
        Id leadRecordTypeId = leadRecordTypeInfo.get('S2E').getRecordTypeId();
        newLead.FirstName = con.FirstName;
        newLead.LastName = con.LastName;
        newLead.Email = 'System.now()@mailinator.com';
        newLead.Company = newAcct.Name;
        newLead.Type__c = 'A';
        newLead.Sales_Org__c = 'WEST';
        newLead.RecordTypeId = leadRecordTypeId;
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
        newLead.Form_Organization_Type__c = '';
        newLead.Phone = newAcct.Phone;
        newLead.Campaign_Cell__c = 'Free Trial';
        insert newLead;

        //create Trial
        Trial__c tr = new Trial__c();
        tr.Source_System_Detail__c = accSSD.id;
        tr.Trial_Id__c = '56576';
        tr.Contact_LeadId__c = newLead.Id;
        tr.Contact_id_SAP__c = con.SAP_Contact_ID__c;
        tr.Trial_Source__c = label.ODT_Trial_Source;
        tr.ODT_Email__c = 'invclgemail@test.com';
        tr.Trial_Initiated_Mode__c = 'Started Immediately';
        tr.Profile_Type__c = 'NET_NEW';
        tr.InvitedDateTime__c = System.today() - 20;
        tr.Trial_Status__c = 'Timed-out';
        insert tr;

        //create Invited Colleague
        Invite_Colleagues__c invitedClg1 = New Invite_Colleagues__c();
        invitedClg1.First_Name__c = 'test invite';
        invitedClg1.Last_Name__c = 'tessstt';
        invitedClg1.Trial_Status__c = 'Rep Initiated';
        invitedClg1.Trial__c = tr.id;
        invitedClg1.Source_System_Detail__c = accSSD.id;
        invitedClg1.Email__c = 'invclgemail@test.com';
        invitedClg1.Primary_User__c = true;
        invitedClg1.SapContactId__c = con.SAP_Contact_ID__c;
        insert invitedClg1;

        //create Trial
        Trial__c tr1 = new Trial__c();
        tr1.Source_System_Detail__c = accSSD.id;
        tr1.Trial_Id__c = '56576';
        tr1.Contact_LeadId__c = newLead.Id;
        tr1.Contact_id_SAP__c = con.SAP_Contact_ID__c;
        tr1.Trial_Source__c = label.ODT_Trial_Source;
        tr1.ODT_Email__c = 'invclgemail@test.com';
        tr1.Trial_Initiated_Mode__c = 'Started by Marketing';
        tr1.Profile_Type__c = 'EXISTING_USER_SAME_DOMAIN';
        tr1.InvitedDateTime__c = System.today() - 20;
        tr1.Trial_Status__c = 'Timed-out';
        insert tr1;

        //create Invited Colleague
        Invite_Colleagues__c invitedClg2 = New Invite_Colleagues__c();
        invitedClg2.First_Name__c = 'test invite';
        invitedClg2.Last_Name__c = 'tessstt';
        invitedClg2.Trial_Status__c = 'Rep Initiated';
        invitedClg2.Trial__c = tr1.id;
        invitedClg2.Source_System_Detail__c = accSSD.id;
        invitedClg2.Email__c = 'invclgemail@test.com';
        invitedClg2.Primary_User__c = true;
        invitedClg2.SapContactId__c = con.SAP_Contact_ID__c;
        insert invitedClg2;

        LIST<WebServiceSettings__c > webList = new LIST<WebServiceSettings__c > ();
        WebServiceSettings__c web = new WebServiceSettings__c();
        web.Endpoint__c = 'test.endpoint';
        web.Name = 'ODTSubscriptionService';
        web.Username__c = 'test.user';
        web.Password__c = 'test:123';
        web.Service_Unavailable_Message__c = 'testservice';
        webList.add(web);

        WebServiceSettings__c web2 = new WebServiceSettings__c();
        web2.Endpoint__c = 'test.endpoint';
        web2.Name = 'ODTGenericEntitlementService';
        web2.Username__c = 'test.user';
        web2.Password__c = 'test:123';
        web2.Service_Unavailable_Message__c = 'testservice';
        webList.add(web2);

        WebServiceSettings__c webs3 = new WebServiceSettings__c();
        webs3.Endpoint__c = 'test2.endpoint';
        webs3.Name = 'ODTEloquaService';
        webs3.Username__c = 'test2.user';
        webs3.Password__c = 'test2:123';
        webs3.Service_Unavailable_Message__c = 'test2service';
        webList.add(webs3);

        WebServiceSettings__c webs4 = new WebServiceSettings__c();
        webs4.Endpoint__c = 'test2.endpoint';
        webs4.Name = 'ODTEloquaServiceSFDCSource'; //ODTEloquaServiceOtherSources
        webs4.Username__c = 'test2.user';
        webs4.Password__c = 'test2:123';
        webs4.Service_Unavailable_Message__c = 'test2service';
        webList.add(webs4);

        WebServiceSettings__c webs5 = new WebServiceSettings__c();
        webs5.Endpoint__c = 'test2.endpoint';
        webs5.Name = 'ODTGetLapsedAccountDetails'; //ODTEloquaServiceOtherSources
        webs5.Username__c = 'test2.user';
        webs5.Password__c = 'test2:123';
        webs5.Service_Unavailable_Message__c = 'test2service';
        webList.add(webs5);

        insert webList;

        LIST<Static_Values__c > staticCSList = new LIST<Static_Values__c > ();
        Static_Values__c stl = new Static_Values__c(name = 'GLIOpportunityRecordType', value__c = 'GLI Pipeline Opportunity');
        Static_Values__c stl1 = new Static_Values__c(name = 'DisplayNCJFromECJ', value__c = 'True');
        staticCSList.add(stl);
        staticCSList.add(stl1);
        insert staticCSList;

        //To create ODT Product Bundle Records
        List<ODT_Product_Bundle__c > listPrdBnlODT = New List<ODT_Product_Bundle__c > ();
        ODT_Product_Bundle__c prdBndl1 = New ODT_Product_Bundle__c();
        prdBndl1.Name = 'Indigo';
        prdBndl1.Bundle_ID__c = '725545';
        prdBndl1.Is_Active__c = true;
        prdBndl1.Is_Enabled_For_Sales_Rep_Trial__c = true;
        prdBndl1.Product_Category__c = 'IND1';
        prdBndl1.Bundle_Type__c = 'CTX';
        prdBndl1.Business_Type__c = 'SLF';
        prdBndl1.Trial_Expiry_Days__c=7;
        prdBndl1.Contacts_User_Type__c = 'NCJ';
        prdBndl1.Profile_ID__c = '431';
        prdBndl1.Hive9_Media_Code__c = '9007949';
        prdBndl1.SAP_Promotion_Code__c = '1234';
        listPrdBnlODT.add(prdBndl1);
        insert listPrdBnlODT;

        // apexpages.currentpage().getparameters().put('oppID', opp.id);    
        apexpages.currentpage().getparameters().put('id', newAcct.id);
        apexpages.currentpage().getparameters().put('ssdID', accSSD.id);
        apexpages.currentpage().getparameters().put('OLCStatus', 'Active');
        ApexPages.StandardController scon = new ApexPages.StandardController(newAcct);
        contactsListCon cto = new contactsListCon(scon);
        cto.getSDDRecordId = accSSD.id;
        cto.executeAcctSSD();
        cto.newCustomerRedirect();

        system.debug('Test' + cto.contasTodisplay);
        string odtDomainSelected;
        odtDomainSelected = prdBndl1.Bundle_ID__c;

        string selectedDomain = apexpages.currentpage().getparameters().put('selectedDomain', odtDomainSelected);
        string selectedcustomer = apexpages.currentpage().getparameters().put('selectedContact', con.SAP_Contact_ID__c);
        String emailOrPhone = apexpages.currentpage().getparameters().put('emailOrPhone', 'false');

        cto.startTrial();

    }

}