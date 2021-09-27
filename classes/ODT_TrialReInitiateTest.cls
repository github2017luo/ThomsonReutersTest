/*============================================================================================
Name                : ODT_TrialReInitiateTest
Description         : This class is developed as part of CXD-ODT project and serves as a Test Class for ODT_TrialReInitiate  and ODT_trialExtendController classes 
Created Date        : 10/9/2018
Author              : Ameeta Antonio

==============================================================================================*/
/**
 * Test class 
 */
/**
 * CHANGE HISTORY
 * =============================================================================
 * Date         Name                    Description
 * 2020-03-23   Brenda Shields          DLT-19804 - Move State/Country references from Account/Contact/Leads to methods in DCTestData                                
 * 2020-05-24  Rahul Natarajan         DLT-19957 :  [SFDC] Add ODT product Detail on ODT Number of days trial Extended
 * =============================================================================
 */

@isTest(Seealldata = false)
public class ODT_TrialReInitiateTest {

    public static testMethod void testContactListCreation() {

        /*
         * PPE Fix For SOQL101 Error - Disable all process builders, triggers, validation rules, workflow rules
         * from running as there is a large amount of SOQL queries occurring in these logic.
         */
        LTS_Disable_Application_Automation__c ltstemp = new LTS_Disable_Application_Automation__c();
        ltstemp.LTS_Disable_Process_Builders__c = true;
        ltstemp.LTS_Disable_Triggers__c = true;
        ltstemp.LTS_Disable_Validation_Rules__c = true;
        ltstemp.LTS_Disable_Workflow_Rules__c = true;
        ltstemp.Name = 'temp';
        ltstemp.SetupOwnerId = userinfo.getuserid();
        insert ltstemp;
        //End of PPE Fix

        Profile p = [SELECT Id FROM profile WHERE name = 'GLI Sales USer'];
        UserRole ukiRole = [SELECT Id FROM UserRole WHERE Name = 'Corp'];
        User u1;
        PermissionSet trainingPermissionSet = [SELECT Id FROM PermissionSet WHERE name = 'ODT_Sales_Rep_Permissions'];
        System.runAs(new User(Id = UserInfo.getUserId())) {
            u1 = new User(alias = 'newUser9', email = 'user@mydomain.com',
                emailencodingkey = 'UTF-8', lastname = 'Testing', languagelocalekey = 'en_US',
                localesidkey = 'en_US', profileid = p.Id, employeenumber = '0144020',
                Sales_Org__c = 'GLI', Sub_Bu__c = 'Elite', timezonesidkey = 'America/Los_Angeles', username = 'user89@mydomain.com', Rep_Type_Description__c = 'test', UserRoleId = ukiRole.Id);
            insert u1;
            PermissionSetAssignment psa = new PermissionSetAssignment(PermissionSetId = trainingPermissionSet.Id, AssigneeId = u1.Id);
            insert psa;
            System.debug('u1' + u1);
        }
    System.assert(u1!=null,'No user selected');
        system.runAs(u1) {

            Profile p1 = [SELECT Id FROM Profile WHERE Name =: 'ANZ Users'];
            //  User u = [Select ID, Sales_Org__c FROM User where Sales_Org__c = 'LRA'AND Profile.id =:p1.id limit 1];
            Map < String, Schema.RecordTypeInfo > recordTypes = Opportunity.sObjectType.getDescribe().getRecordTypeInfosByName();
            Id optyPipeRecTypeId = recordTypes.get('Pipeline Opportunity').getRecordTypeId();
            Id optyPreRecTypeID = recordTypes.get('Pre-Pipeline Opportunity').getRecordTypeId();
            Id optyGLIRecTypeID = recordTypes.get('GLI Pipeline Opportunity').getRecordTypeId();
            //RecordType defaultRecordType = [SELECT id,Name FROM RecordType WHERE SobjectType='Opportunity' Limit 1];
            System.debug('Pipeline' + optyPipeRecTypeId + 'Pre-pipeline' + optyPreRecTypeID + 'GLI pipeline' + optyGLIRecTypeID);

            //Keyvalue setting for OpportunityUtil class
            KeyValueListStore__C keyCustomSetting = new KeyValueListStore__c(Name = 'ANZUsersProfileId', TextValue__c = p1.id);
            insert keyCustomSetting;

            List < WebServiceSettings__c > webserviceList = new List < WebServiceSettings__c > {
                new WebServiceSettings__c(Name = 'EnterpriseWSDL', Endpoint__c = 'https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount', Service_Unavailable_Message__c = 'Service not Available'),
                new WebServiceSettings__c(Name = 'StatusPostbackLocation', Endpoint__c = 'https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount', Service_Unavailable_Message__c = 'Service not Available'),
                new WebServiceSettings__c(Name = 'PostbackLocation', Endpoint__c = 'https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount', Service_Unavailable_Message__c = 'Service not Available'),
                new WebServiceSettings__c(Name = 'Payment AutoCharge', Endpoint__c = 'https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount', Service_Unavailable_Message__c = 'Service not Available'),
                new WebServiceSettings__c(Name = 'PaymentCreditIncrease', Endpoint__c = 'https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount', Service_Unavailable_Message__c = 'Service not Available'),
                new WebServiceSettings__c(Name = 'ODTCreateEntitlementService', Endpoint__c = 'https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount', Service_Unavailable_Message__c = 'Service not Available')

            };
            insert webserviceList;

            //Creation of 3 record types.
            List < RecordtypeIds__c > rclist = createRecType(optyPreRecTypeID,optyGLIRecTypeID);
            

            Pricebook2 pbook = new Pricebook2();
            pbook.name = 'GLI Price Book - US Legal/LMS';
            pbook.IsActive = true;
            insert pbook;

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
            insert accSSD;

            //Create Contact
            Contact con = new Contact();
            con.FirstName = 'John';
            con.LastName = 'Ray';
            con.SAP_Contact_ID__c = '0006271252';
            con.AccountId = newAcct.id;
            con.Email = 'john.ray@tr.com';
            insert con;

            //create opportunity
            Opportunity opp = new Opportunity();
            opp.Name = 'Test Opportunity';
            opp.closeDate = System.Today() + 5;
            opp.recordTypeId = optyPreRecTypeID;
            opp.Owner = u1;
            opp.StageName = 'Prospect';
            opp.AccountId = newAcct.Id;
            opp.Pricebook2id = pbook.id;
            opp.Source_System_Detail__c = accSSD.Id;
            insert opp;

            //To create ODT Product Bundle Records
            ODT_Product_Bundle__c prdBndl1 = New ODT_Product_Bundle__c();
            prdBndl1.Name = 'Westlaw Edge Add-on (14 days)';
            prdBndl1.Bundle_ID__c = '725545';
            prdBndl1.Is_Active__c = true;
            prdBndl1.Trial_Expiry_Days__c = 14;
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
            //tr.Contact_LeadId__c=newLead.Id;
            tr.Contact_id_SAP__c = con.SAP_Contact_ID__c;
            tr.Trial_Source__c = 'SFDC';
            tr.InvitedDateTime__c = System.today() - 25;
            tr.Trial_Status__c = 'Timed-out';
            tr.Trial_Start_Date__c = System.today() - 20;
            tr.Trial_End_Date__c = System.today();
            tr.ODT_Number_Of_Days_Trial_Extended__c = 1;
            tr.ODT_Trial_Extend_Date__c = system.today() + Integer.valueof(prdBndl1.Trial_Expiry_Days__c);
            tr.ODT_SAP_Account_Number__c = accSSD.Source_System_Account_Number__c;
            tr.Profile_Type__c = 'EXISTING_USER_NEW_DOMAIN';
            tr.No_Of_Times_Extended__c = 1;
            insert tr;

            //create Opportunity trial
            Opportunity_Trial__c opTrial = new Opportunity_Trial__c();
            opTrial.Trial__c = tr.id;
            opTrial.Opportunity__c = opp.id;
            insert opTrial;

            //create Invited Colleague
            Invite_Colleagues__c invitedClg1 = New Invite_Colleagues__c();
            invitedClg1.First_Name__c = 'test invite';
            invitedClg1.Last_Name__c = 'tessstt';
            invitedClg1.Trial_Status__c = 'Accepted';
            invitedClg1.Trial__c = tr.id;
            invitedClg1.Source_System_Detail__c = accSSD.id;
            invitedClg1.Email__c = 'invclgemail@test.com';
            invitedClg1.Primary_User__c = true;
            invitedClg1.SapContactId__c = con.SAP_Contact_ID__c;
            //invitedClg1.Lead__c = lead.id; 
            insert invitedClg1;

            Trial__c tr1 = new Trial__c();
            tr1.Source_System_Detail__c = accSSD.id;
            tr1.Trial_Id__c = '56576';
            //tr.Contact_LeadId__c=newLead.Id;
            tr1.Contact_id_SAP__c = con.SAP_Contact_ID__c;
            tr1.Trial_Source__c = 'SFDC';
            tr1.InvitedDateTime__c = System.today() - 25;
            tr1.Trial_Status__c = 'Timed-out';
            tr1.Trial_Start_Date__c = System.today() - 20;
            tr1.Trial_End_Date__c = System.today() - 6;
            tr1.ODT_Trial_Extend_Date__c = system.today() + Integer.valueof(prdBndl1.Trial_Expiry_Days__c);
            tr1.ODT_SAP_Account_Number__c = accSSD.Source_System_Account_Number__c;
            tr1.ODT_Number_Of_Days_Trial_Extended__c = 1;
            tr1.No_Of_Times_Extended__c = 1;
            insert tr1;

            Opportunity_Trial__c opTrial1 = new Opportunity_Trial__c();
            opTrial1.Trial__c = tr1.id;
            opTrial1.Opportunity__c = opp.id;
            insert opTrial1;

            //create Invited Colleague
            Invite_Colleagues__c invitedClg2 = New Invite_Colleagues__c();
            invitedClg2.First_Name__c = 'test invite1';
            invitedClg2.Last_Name__c = 'test1';
            invitedClg2.Trial_Status__c = 'Accepted';
            invitedClg2.Trial__c = tr1.id;
            invitedClg2.Source_System_Detail__c = accSSD.id;
            invitedClg2.Email__c = 'invclgemail1@test.com';
            invitedClg2.Primary_User__c = false;
            invitedClg2.SapContactId__c = con.SAP_Contact_ID__c;
            //invitedClg2.Lead__c = lead.id; 
            insert invitedClg2;

            Trial__c tr3 = new Trial__c();
            tr3.Source_System_Detail__c = accSSD.id;
            tr3.Trial_Id__c = '56576';
            tr3.Account_Name__c = newAcct.id;
            //tr3.Contact_LeadId__c=newLead.Id;
            tr3.Contact_id_SAP__c = con.SAP_Contact_ID__c;
            tr3.Trial_Source__c = 'SFDC';
            tr3.InvitedDateTime__c = System.today() - 25;
            tr3.Trial_Status__c = 'Timed-out';
            tr3.Trial_Start_Date__c = System.today() - 20;
            tr3.Trial_End_Date__c = System.today() - 6;
            tr3.ODT_Trial_Extend_Date__c = null;
            tr3.ODT_SAP_Account_Number__c = accSSD.Source_System_Account_Number__c;
            tr3.ODT_Number_Of_Days_Trial_Extended__c = 1;
            tr3.No_Of_Times_Extended__c = 1;
            insert tr3;

            Lead newlead = createODTLead(con,newAcct);
            

            Trial__c tr5 = new Trial__c();
            //tr.Account_Name__c=newAcct.Id;
            tr5.Source_System_Detail__c = accSSD.id;
            tr5.Trial_Id__c = '56576';
            //tr.Contact_LeadId__c=newLead.Id;
            tr5.Contact_id_SAP__c = con.SAP_Contact_ID__c;
            tr5.Account_Name__c = newAcct.id;
            tr5.Contact_LeadId__c = newLead.Id;
            tr5.Trial_Source__c = 'SFDC';
            tr5.InvitedDateTime__c = System.today() - 25;
            tr5.Trial_Status__c = 'Timed-out';
            tr5.Trial_Start_Date__c = System.today() - 4;
            tr5.Trial_End_Date__c = System.today() + 14;
            tr.ODT_Number_Of_Days_Trial_Extended__c = 1;
            tr5.ODT_Trial_Extend_Date__c = system.today() + Integer.valueof(prdBndl1.Trial_Expiry_Days__c) + 10;
            tr5.ODT_SAP_Account_Number__c = '1004631219';
            tr5.Profile_Type__c = 'EXISTING_USER_NEW_DOMAIN';
            tr5.No_Of_Times_Extended__c = 1;
            insert tr5;

            Opportunity_Trial__c opTrial3 = new Opportunity_Trial__c();
            opTrial3.Trial__c = tr5.id;
            opTrial3.Opportunity__c = opp.id;
            insert opTrial3;

            Invite_Colleagues__c invitedClg5 = New Invite_Colleagues__c();
            invitedClg5.First_Name__c = 'test invite';
            invitedClg5.Last_Name__c = 'tessstt';
            invitedClg5.Trial_Status__c = 'Accepted';
            invitedClg5.Trial__c = tr5.id;
            // invitedClg5.Source_System_Detail__c = accSSD.id;
            invitedClg5.Email__c = 'invclgemail@test.com';
            invitedClg5.Primary_User__c = true;
            invitedClg5.SapContactId__c = con.SAP_Contact_ID__c;
            //invitedClg1.Lead__c = lead.id; 
            insert invitedClg5;

            Opportunity_Trial__c opTrial2 = new Opportunity_Trial__c();
            opTrial2.Trial__c = tr3.id;
            opTrial2.Opportunity__c = opp.id;
            insert opTrial2;

            insertWebServiceSetting();           

            Test.startTest();

            //Start:DLT-12947--Added by Ameeta
            testODTTrialInitiateOpportunity(opp,tr,con);
            

            // DLT-
      
            testAddUserAndPagination(tr);
            testAddUser(tr5);
            

            //ODT_TrialReInitiate_AddUser_Callout occ = new ODT_TrialReInitiate_AddUser_Callout(tr.id);
            //ID batchprocessid = Database.executeBatch(occ);

            //System.debug('selectedcustomer'+selectedcustomer+'SAP'+con.SAP_Contact_ID__c);
            // odt.closeEloquaPopup();

            // DLT-16849
            testODTTrialInitiationHelper(tr,u1);

            //Test.stopTest();
            //End:DLT-12947

            //DLT-12390 Starts:Added by harshitha
            testTrialExtendOne(tr);
            
            

            testTrialExtend(tr3,tr1);
			Test.stopTest();
            //ODT_TrialReInitiate.validateEmail('test@domain.com');
            //  apexpages.currentpage().getparameters().put('uniqueField', '0006305031');

            //DLT-12390 Ends
        }
    }
    
    
    public static void testTrialExtend(Trial__c tr3, Trial__c tr1){
        apexpages.currentpage().getparameters().put('id', tr1.id);
            ApexPages.StandardController scon1 = new ApexPages.StandardController(tr1);
            ODT_trialExtendController odExtend1 = new ODT_trialExtendController(scon1);
            ODTTrialManagement.testServiceBoolean = false;
            odExtend1.extendTrialDate();

            ODTTrialManagement.testServiceBoolean = true;
            odExtend1.extendTrialDate();
            odExtend1.backToTrial();
        
        apexpages.currentpage().getparameters().put('id', tr3.id);
            ApexPages.StandardController scon3 = new ApexPages.StandardController(tr3);
            ODT_trialExtendController odExtend3 = new ODT_trialExtendController(scon3);
            ODTTrialManagement.testServiceBoolean = false;
            odExtend3.extendTrialDate();

            ODTTrialManagement.testServiceBoolean = true;
            odExtend3.extendTrialDate();
            odExtend3.backToTrial();
        
    }
    
    private static void testTrialExtendOne(trial__c tr){
        apexpages.currentpage().getparameters().put('id', tr.id);
            ApexPages.StandardController scon = new ApexPages.StandardController(tr);
            ODT_trialExtendController odExtend = new ODT_trialExtendController(scon);
            ODTTrialManagement.testServiceBoolean = false;
            odExtend.extendTrialDate();

            ODTTrialManagement.testServiceBoolean = true;
            odExtend.extendTrialDate();
            odExtend.backToTrial();

    }
    
    private static List < RecordtypeIds__c > createRecType(Id optyPipeRecTypeId, Id optyGLIRecTypeID){
        List < RecordtypeIds__c > rclist = new List < RecordtypeIds__c > ();
            RecordtypeIds__c recT = new RecordtypeIds__c();
            recT.name = 'Pre-Pipeline Opportunities';
            recT.recTypeId__C = optyPipeRecTypeId;
            rclist.add(recT);

            RecordtypeIds__c recT1 = new RecordtypeIds__c();
            recT1.Name = 'Pipeline Opportunities';
            recT1.recTypeId__C = optyPipeRecTypeId;
            rclist.add(recT1);

            RecordtypeIds__c recT2 = new RecordtypeIds__c();
            recT2.Name = 'GLI Pipeline Opportunity';
            recT2.recTypeId__C = optyGLIRecTypeID;
            rclist.add(recT2);

            insert rclist;
        return rclist;
    }
    
    private static void testAddUser(Trial__c tr5){
        apexpages.currentpage().getparameters().put('id', tr5.id);
            apexpages.currentpage().getparameters().put('action', 'addUser');
            string selectedcustomer3 = apexpages.currentpage().getparameters().put('sid', '0006305031');
            ODT_TrialReInitiate odt3 = new ODT_TrialReInitiate();

            odt3.next();
            odt3.next();
            odt3.previous();
            odt3.addSelected();
            odt3.createIC();
    }
    
    private static void testODTTrialInitiateOpportunity(opportunity opp,Trial__c tr,Contact con){
        apexpages.currentpage().getparameters().put('id', opp.id);
            ApexPages.StandardController cont = new ApexPages.StandardController(opp);
            ODTTrialInitiateOpportunity trialFromOpp = new ODTTrialInitiateOpportunity(cont);
            trialFromOpp.getTrialOpportunity();
            trialFromOpp.callToContactList();
            trialFromOpp.newCustomerRedirect();

            apexpages.currentpage().getparameters().put('id', tr.id);
            apexpages.currentpage().getparameters().put('action', 'Resend');
            string selectedcustomer = apexpages.currentpage().getparameters().put('selectedContact', con.SAP_Contact_ID__c);
            ODT_TrialReInitiate odt = new ODT_TrialReInitiate();
            odt.reInitiateTrial();
            odt.closeEloquaPopup();
    }
    
    private static void testAddUserAndPagination(Trial__c tr){
        apexpages.currentpage().getparameters().put('id', tr.id);
            apexpages.currentpage().getparameters().put('action', 'addUser');
            string selectedcustomer2 = apexpages.currentpage().getparameters().put('sid', '0006305031');
            ODT_TrialReInitiate odt2 = new ODT_TrialReInitiate();

            odt2.next();
            odt2.next();
            odt2.previous();

            for (ODT_TrialReInitiate.ContactsWrapper contact: odt2.allOtherOLCcontactsPagination) {
                contact.isNewContact = true;
                if (contact.uniqueField != '0006305031'){contact.isSelected = false;}
                    
            }

            odt2.selectAll();
            odt2.addSelected();
            odt2.createIC();

            system.debug('AAAAAAAAA MALLIK...........' + odt2.allOtherOLCcontactsPagination);
            apexpages.currentpage().getparameters().put('uniqueField', '0006305031');

            for (ODT_TrialReInitiate.ContactsWrapper contact: odt2.allOtherOLCcontactsPagination) {
                contact.isNewContact = true;

            }

            odt2.addUser();

            odt2.createUser();
            apexpages.currentpage().getparameters().put('uniqueField', string.valueof(system.now()));

            odt2.addUser();
            boolean hn = odt2.hasNext;
            boolean hp = odt2.hasPrevious;
            odt2.deselectAll();
            odt2.searchStr = 'aug16';
            odt2.searchOnlineContacts();
            odt2.deselectAll();
            odt2.selectAll();

    }
    
    private static void testODTTrialInitiationHelper(Trial__c tr,User u1){
        apexpages.currentpage().getparameters().put('id', tr.id);
            ApexPages.StandardController scont = new ApexPages.StandardController(tr);
            ODT_TrialInitiationHelper.hasValidUserPermissions(u1);
            ODT_TrialInitiationHelper odtTIH = new ODT_TrialInitiationHelper();
            ODT_TrialInitiationHelper.getMarketSegmentsList();
            ODT_TrialInitiationHelper.getProductBundleList();
            ODT_TrialInitiationHelper.getUserRoleList();
            ODT_TrialInitiationHelper.getProductBundleList('NET_NEW', true, true);
    }
    
    private static void insertWebServiceSetting(){

        //Create WebServiceSettings for the services
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
        webs4.Endpoint__c = 'test4.endpoint';
        webs4.Name = 'ODTEloquaServiceSFDCSource';
        webs4.Username__c = 'test4.user';
        webs4.Password__c = 'test4:123';
        webs4.Service_Unavailable_Message__c = 'test2service';
        webList.add(webs4);

        //LIST<WebServiceSettings__c > webList5 = new LIST<WebServiceSettings__c>();
        WebServiceSettings__c web5 = new WebServiceSettings__c();
        web5.Endpoint__c = 'test.endpoint';
        web5.Name = 'ODTTrialExtensionService';
        web5.Username__c = 'test.user';
        web5.Password__c = 'test:123';
        web5.Service_Unavailable_Message__c = 'testservice';
        webList.add(web5);
        insert webList;

    }
    
    private static Lead createODTLead(Contact con, Account newAcct){
        Lead newLead = new Lead();
        Map<String,Schema.RecordTypeInfo> leadRecordTypeInfo = Schema.SObjectType.Lead.getRecordTypeInfosByName(); 
        Id leadRecordTypeId = leadRecordTypeInfo.get('S2E').getRecordTypeId();
        newLead.FirstName = con.FirstName;
        newLead.LastName = con.LastName;
        newLead.Email = con.Email;
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
        //newLead.External_Trial_Account_ID__c = newAcct.External_Trial_Account_ID__c;
        newLead.Form_Organization_Type__c = '';
        //newLead.Product_Solution_of_Interest__c = prodName;
        //newLead.Business_Org__c = businessOrg;  
        newLead.Phone = newAcct.Phone;
        newLead.Campaign_Cell__c = 'Free Trial';

        insert newLead;

        return newLead;
    }
    
    
}