/**
 * ODT_OnePassErrorINC ODT_NCJCreateEntitlementTest
 *  DLT-20639 - 18-09-202 - Refactored Code ,Solved PMD violations
 */

@isTest(Seealldata = false)
public class ODT_NCJCreateEntitlementTest {

    @testSetup static void setup() {
        list<WebServiceSettings__c> webserviceList = new list<WebServiceSettings__c> {
            new WebServiceSettings__c(Name = 'PaymentCreditIncrease', Endpoint__c = 'https://api.thomsonreuters.com/ebs/entitlement/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount', Service_Unavailable_Message__c = 'Service not Available'),
            new WebServiceSettings__c(Name = 'Payment AutoCharge', Endpoint__c = 'https://api.thomsonreuters.com/ebs/entitlement/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount', Service_Unavailable_Message__c = 'Service not Available'),
            new WebServiceSettings__c(Name = 'ODTEloquaServiceOtherSources', Endpoint__c = 'https://api.thomsonreuters.com/ebs/entitlement/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount', Service_Unavailable_Message__c = 'Service not Available')
        };
        insert webserviceList;
        
        // create Account
        Account newAcct = new Account();
        newAcct.Name = 'Test Class Account';
        newAcct.SAPAccountNumber__c = '1400357566';
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
        accSSD.Source_System_Account_Number__c = '1400357566';
        accSSD.Account_Name__c = newAcct.id;
        accSSD.Trial_Status__c = '';
        accSSD.BU_Segment_Level_2__c = 'SLF 4-6';
        accSSD.LCRM_Phone__c = '08061393678';
        accSSD.Country__c = 'US';
        accSSD.Postal_Code__c = '32801';
        insert accSSD;
        
        //To create ODT Product Bundle Records        
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
        insert prdBndl1;
        
        //create Trial
        List < Trial__c > tList = new List < Trial__c > ();
        Trial__c tr = new Trial__c();
        tr.Trial_Id__c = '56576';
        tr.Trial_Source__c = 'Website';
        tr.InvitedDateTime__c = System.today() - 2;
        tr.Trial_Status__c = 'Entitlement Error';
        tr.Trial_Start_Date__c = System.today();
        tr.Trial_End_Date__c = System.today() + 7;
        tr.Trial_Journey__c = 'Rep Initiated Journey';
        tr.Contact_id_SAP__c = '74236588';
        tr.ODT_Email__c = 'abc@test.com';
        tr.ODT_SAP_Account_Number__c = '1400357566';
        tr.ODT_Product_Bundle__c = prdBndl1.id;
        tr.Source_System_Detail__c = accSSD.id;
        tr.User_Auth_ID__c = 'aaa123bbb';
        tr.One_Pass_Identifier__c = 'd2g4m6p8dfjh13256';
        tr.Service_Count__c = 1;
        tList.add(tr);
        Trial__c tr2 = new Trial__c();
        tr2.Trial_Id__c = '56576';
        tr2.Trial_Source__c = label.ODT_Trial_Source;
        tr2.InvitedDateTime__c = System.today() - 2;
        tr2.Trial_Status__c = 'Entitlement Error';
        tr2.Trial_Start_Date__c = System.today();
        tr2.Trial_End_Date__c = System.today() + 7;
        tr2.Trial_Journey__c = 'Rep Initiated Journey';
        tr2.Contact_id_SAP__c = '74236588';
        tr2.ODT_Email__c = 'abc@test.com';
        tr2.ODT_SAP_Account_Number__c = '1400357566';
        tr2.User_Auth_ID__c = 'aaa123bbb';
        tr2.One_Pass_Identifier__c = 'd2g4m6p8dfjh13256';
        tr2.Service_Count__c = 1;
        tList.add(tr2);
        insert tList;

        //create Invited Colleagues
        List < Invite_Colleagues__c > iList = new List < Invite_Colleagues__c > ();
        Invite_Colleagues__c invitedClg2 = New Invite_Colleagues__c();
        invitedClg2.First_Name__c = 'test invite';
        invitedClg2.Last_Name__c = 'tessstt';
        invitedClg2.Trial_Status__c = 'Entitlement Error';
        invitedClg2.Trial__c = tr.id;
        invitedClg2.Primary_User__c = true;
        invitedClg2.SapContactId__c = '74236588';
        invitedClg2.User_Auth_ID__c = 'aaa123bbb';
        invitedClg2.One_Pass_Identifier__c = 'd2g4m6p8dfjh13256';
        invitedClg2.Service_Count__c = 1;
        iList.add(invitedClg2);
        Invite_Colleagues__c invitedClg23 = New Invite_Colleagues__c();
        invitedClg23.First_Name__c = 'test invite';
        invitedClg23.Last_Name__c = 'tessstt';
        invitedClg23.Trial_Status__c = 'Entitlement Error';
        invitedClg23.Trial__c = tr.id;
        invitedClg23.Primary_User__c = true;
        invitedClg23.SapContactId__c = '74236588';
        invitedClg23.User_Auth_ID__c = 'aaa123bbb';
        invitedClg23.One_Pass_Identifier__c = 'd2g4m6p8dfjh13256';
        invitedClg23.Service_Count__c = 1;
        iList.add(invitedClg23);
        insert iList;

        List < WebServiceSettings__c > wList = new List < WebServiceSettings__c > ();
        WebServiceSettings__c web = new WebServiceSettings__c();
        web.Endpoint__c = 'test.endpoint';
        web.Name = 'ODTCreateEntitlementService';
        web.Username__c = 'test.user';
        web.Password__c = 'test:123';
        web.Service_Unavailable_Message__c = 'testservice';
        wList.add(web);
        WebServiceSettings__c web2 = new WebServiceSettings__c();
        web2.Endpoint__c = 'test.endpoint';
        web2.Name = 'ODTEloquaServiceSFDCSource';
        web2.Username__c = 'test.user';
        web2.Password__c = 'test:123';
        web2.Service_Unavailable_Message__c = 'testservice';
        wList.add(web2);
        insert wList;
    }
    public static testMethod void digitalCheckTrialOnePass() {
        Test.startTest();
        List < Trial__c > tList = [Select Id, Source_System_Detail__c, Profile_Type__c, Profile_ID__c, SAP_Promotion_Code__c, Lapsed_Reason_Code__c, Is_Lapsed__c, ODT_Email__c, Trial_Initiated_Account_Number__c, One_Pass_Identifier__c, User_Auth_ID__c,
            Source_System_Detail__r.Account_Name__c, Source_System_Detail__r.Account_Name__r.Name, Contact_id_SAP__c, Contact_LeadId__c, ODT_SAP_Account_Number__c, Trial_Id__c, ODT_Product_Bundle__c, ODT_Trial_Product_Category__c, Trial_Status__c,
            Trial_Source__c, Primary_User_First_Name__c, Primary_User_Last_Name__c, Service_Count__c, Contact_LeadId__r.Company, Trial_End_Date__c, Trial_Start_Date__c, GUID__c FROM Trial__c where trial_Status__C = 'Entitlement Error'
        ];

        apexpages.currentpage().getparameters().put('id', tList[0].id);
        ApexPages.StandardController scon = new ApexPages.StandardController(tList[0]);
        ODT_NCJCreateEntitlementPrimary ent = new ODT_NCJCreateEntitlementPrimary(scon);
        ent.callService();
        ent.closePopup();
        System.schedule('Test DL', '0 0 0 ? * *', new ODT_OnePassSchedulable());
        System.assertEquals(tList[0].Trial_Status__c, 'Entitlement Error', 'Expected Trial Status Value');
        Test.stopTest();
    }
    public static testMethod void digitalcheckICOnePass() {
        Test.startTest();
        List < Invite_Colleagues__c > icList = [Select ID, Source_System_Detail__c, Trial_Status__c, Email__c, First_Name__c, Last_Name__c, Primary_User__c, Trial__c, SapContactId__c, Trial__r.ODT_SAP_Account_Number__c, User_Auth_ID__c, One_Pass_Identifier__c, Service_Count__c, Trial__r.Profile_Type__c,
            Trial__r.Contact_LeadId__c, Trial__r.Id, Trial__r.Contact_LeadId__r.Company, Trial__r.Trial_Source__c, Trial__r.Trial_End_Date__c, Trial__r.Is_Lapsed__c, Trial__r.Trial_Start_Date__c, Trial__r.Trial_Id__c, GUID__c FROM Invite_Colleagues__c where Trial_Status__c = 'Entitlement Error'
        ];
        apexpages.currentpage().getparameters().put('id', icList[0].id);
        ApexPages.StandardController scon1 = new ApexPages.StandardController(icList[0]);
        ODT_NCJCreateEntitlementINC ent1 = new ODT_NCJCreateEntitlementINC(scon1);
        ent1.callService();
        ent1.closePopup();
        DataBase.executeBatch(new ODT_OnePassErrorINC(), 1);
        System.assertEquals(icList[0].Trial_Status__c, 'Entitlement Error', 'Expected Trial Status Value');
        test.stopTest();
    }
}