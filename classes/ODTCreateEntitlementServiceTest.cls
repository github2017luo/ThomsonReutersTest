/**
 * CHANGE HISTORY
 * =============================================================================
 * Date         Name                    Description
 * 2020-03-23   Brenda Shields          DLT-19804 - Move State/Country references from Account/Contact/Leads to methods in DCTestData            
 * 23-07-2020   Rahul Natarajan         DLT-20035 - Remove Segmentation Field References from CX Digital components.                    
 * =============================================================================
 */

@isTest(Seealldata = false)
public class ODTCreateEntitlementServiceTest {
    @testsetup
    public static void testdata() {

        WebServiceSettings__c web = new WebServiceSettings__c();
        web.Endpoint__c = 'test.endpoint';
        web.Name = 'ODTCreateEntitlementService';
        web.Username__c = 'test.user';
        web.Password__c = 'test:123';
        web.Service_Unavailable_Message__c = 'testservice';

        insert web;

        List < WebServiceSettings__c > webserviceList = new List < WebServiceSettings__c > {
            new WebServiceSettings__c(Name = 'EnterpriseWSDL', Endpoint__c = 'https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount', Service_Unavailable_Message__c = 'Service not Available'),
            new WebServiceSettings__c(Name = 'StatusPostbackLocation', Endpoint__c = 'https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount', Service_Unavailable_Message__c = 'Service not Available'),
            new WebServiceSettings__c(Name = 'PostbackLocation', Endpoint__c = 'https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount', Service_Unavailable_Message__c = 'Service not Available'),
            new WebServiceSettings__c(Name = 'Payment AutoCharge', Endpoint__c = 'https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount', Service_Unavailable_Message__c = 'Service not Available')
        };
        insert webserviceList;

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

        // Commented Segmentation Fields - DLT-20035
        //create lead
        Lead newlead = new Lead();
        newLead.FirstName = con.FirstName;
        newLead.LastName = con.LastName;
        newLead.Email = con.Email;
        newLead.Company = newAcct.Name;
        newLead.Type__c = 'A';
        // newLead.Sales_Org__c = 'WEST';
        newLead.RecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('GLI').getRecordTypeId();
        newLead.Customer_Type__c = 'Organization';
        newLead.LeadSource = 'Rep Generated';
        newLead.Source__c = 'On Demand Trial';
        //  newLead.Customer_Group__c = 'ACADEMIC';
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
        tr.ODT_SAP_Account_Number__c = '173468930';
        tr.ODT_Trial_Extend_Date__c = System.today() + 50;
        insert tr;

        List < Invite_Colleagues__c > invitedClgList = new List < Invite_Colleagues__c > ();
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
        invitedClg1.Trial_Status__c = 'Rep Initiated';
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
        invitedClg2.Trial_Status__c = 'Rep Initiated';
        invitedClgList.add(invitedClg2);

        insert invitedClgList;
    }

    public static testMethod void testReactivateEntitlementService() {
        Test.startTest();
        List < Trial__c > myTrial = [SELECT Id, Name, Account_Name__c, Account_Name__r.name, Contact_id_SAP__c, Contact_LeadId__c, Contact_Name__c, Contact_ssd__c, Early_End_Other_Reason__c, Early_End_Reason__c, Global_trial_Id__c, GUID__c, Initiated_User_Profile__c, Initiated_User_Role__c, InvitedDateTime__c, No_Of_Days_To_Extend__c, ODT_Email__c, ODT_Ended_By__c, ODT_Number_Of_Days_Trial_Extended__c, ODT_Product_Bundle__c, ODT_SAP_Account_Number__c, ODT_Trial_Extend_Date__c, ODT_Trial_Product_Category__c, PrimaryContact__c, Source_System_Detail__c, Source_System_Detail__r.Name, Source_System_Detail__r.LCRM_Sales_Org__c, Trial_Campaign__c, Trial_End_Date__c, Trial_Id__c, Trial_Journey__c, Trial_Products_Recommendation__c, Trial_products__c, Trial_Source__c, Trial_Start_Date__c, Trial_Status__c, (SELECT Email__c, First_Name__c, Id, Last_Name__c, Name, Primary_User__c, SapContactId__c, Trial_End_Date__c, Trial_Request_Date__c, Trial_Start_Date__c, Trial_Status__c, Trial__c FROM Invite_Colleagues__r) FROM Trial__c where ODT_SAP_Account_Number__c = '173468930'];
        Boolean isReactivate = ODTCreateEntitlementService.createEntitlement(myTrial[0].Id);
        system.assertNotEquals(isReactivate, null);
        Test.stopTest();
    }

}