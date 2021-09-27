/**
 * CHANGE HISTORY
 * =============================================================================
 * Date         Name                    Description
 * 2020-03-23   Brenda Shields          DLT-19804 - Move State/Country references from Account/Contact/Leads to methods in DCTestData     
 * 2020-10-01  Rahul                   DLT-20756 :  [SFDC] [ODT] Critical and Blocker Code scan issue                           
 * =============================================================================
 */
@isTest(Seealldata = false)
public class ODTStartNCJConTest {

    public static testMethod void testNewCustomerTrial() {
        Profile p = [SELECT Id FROM profile WHERE name = 'GLI Sales USer'];
        UserRole ukiRole = [SELECT Id FROM UserRole WHERE Name = 'Small Law'];
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

        system.runAs(new User(Id = UserInfo.getUserId())) {

            Profile p1 = [SELECT Id FROM Profile WHERE Name =: 'ANZ Users'];
            User u = [Select ID, Sales_Org__c FROM User where Sales_Org__c = 'LRA'
                AND Profile.id =: p1.id limit 1
            ];
            Map < String, Schema.RecordTypeInfo > recordTypes = Opportunity.sObjectType.getDescribe().getRecordTypeInfosByName();
            Id optyPipeRecTypeId = recordTypes.get('Pipeline Opportunity').getRecordTypeId();
            Id optyPreRecTypeID = recordTypes.get('Pre-Pipeline Opportunity').getRecordTypeId();
            Id optyGLIRecTypeID = recordTypes.get('GLI Pipeline Opportunity').getRecordTypeId();
            System.debug('Pipeline' + optyPipeRecTypeId + 'Pre-pipeline' + optyPreRecTypeID + 'GLI pipeline' + optyGLIRecTypeID);

            //Keyvalue setting for OpportunityUtil class
            KeyValueListStore__C keyCustomSetting = new KeyValueListStore__c(Name = 'ANZUsersProfileId', TextValue__c = p1.id);
            insert keyCustomSetting;

            List < WebServiceSettings__c > webserviceList = new List < WebServiceSettings__c > {
                new WebServiceSettings__c(Name = 'EnterpriseWSDL', Endpoint__c = 'https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount', Service_Unavailable_Message__c = 'Service not Available'),
                new WebServiceSettings__c(Name = 'StatusPostbackLocation', Endpoint__c = 'https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount', Service_Unavailable_Message__c = 'Service not Available'),
                new WebServiceSettings__c(Name = 'PostbackLocation', Endpoint__c = 'https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount', Service_Unavailable_Message__c = 'Service not Available'),
                new WebServiceSettings__c(Name = 'Payment AutoCharge', Endpoint__c = 'https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount', Service_Unavailable_Message__c = 'Service not Available'),
                new WebServiceSettings__c(Name = 'PaymentCreditIncrease', Endpoint__c = 'https://testingfromsfdc.com/processReq', Service_Unavailable_Message__c = 'Service not Available')
            };
            //DLT-20756 - PMD Fix
            insert webserviceList;
            //DLT-20756 - PMD Fix
            List < RecordtypeIds__c > recTList = new List < RecordtypeIds__c > ();
            RecordtypeIds__c recT = new RecordtypeIds__c();
            recT.name = 'Pre-Pipeline Opportunities';
            recT.recTypeId__C = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Pre-Pipeline Opportunity').getRecordTypeId();
            recTList.add(recT);

            RecordtypeIds__c recT1 = new RecordtypeIds__c();
            recT1.Name = 'Pipeline Opportunities';
            recT1.recTypeId__C = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Pipeline Opportunity').getRecordTypeId();
            recTList.add(recT1);

            RecordtypeIds__c recT2 = new RecordtypeIds__c();
            recT2.Name = 'GLI Pipeline Opportunity';
            recT2.recTypeId__C = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
            recTList.add(recT2);

            insert recTList;

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
            accSSD.BU_Segment_Level_2__c = 'SLF 4-6';
            accSSD.Trial_Status__c = 'Rep Initiated';
            accSSD.LCRM_Market_Segment__c = 'SLF 4-6';
            accSSD.Country__c = 'India';
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
            opp.Owner = u;
            opp.StageName = 'Prospect';
            opp.AccountId = newAcct.Id;
            opp.Pricebook2id = pbook.id;
            opp.Source_System_Detail__c = accSSD.Id;
            insert opp;

            //To create ODT Product Bundle Records
            ODT_Product_Bundle__c prdBndl1 = New ODT_Product_Bundle__c();
            prdBndl1.Name = 'Westlaw Edge Add-on (7 days)';
            prdBndl1.Bundle_ID__c = '725545';
            prdBndl1.Is_Active__c = true;
            prdBndl1.Trial_Expiry_Days__c = 7;
            prdBndl1.Is_Enabled_For_Sales_Rep_Trial__c = true;
            prdBndl1.Product_Category__c = 'WL';
            prdBndl1.Bundle_Type__c = 'CTX';
            prdBndl1.Business_Type__c = 'CTX';
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
            tr.InvitedDateTime__c = System.today() - 200;
            tr.Trial_Status__c = 'Rep Initiated';
            tr.Trial_Start_Date__c = System.today();
            tr.Trial_End_Date__c = System.today() + 7;
            tr.ODT_Trial_Extend_Date__c = system.today() + 10;
            tr.ODT_SAP_Account_Number__c = accSSD.Source_System_Account_Number__c;
            tr.ODT_Product_Bundle__c = prdBndl1.ID;
            tr.Profile_Type__c = 'NET_NEW';
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
            invitedClg1.Trial_Status__c = 'Rep Initiated';
            invitedClg1.Trial__c = tr.id;
            invitedClg1.Source_System_Detail__c = accSSD.id;
            invitedClg1.Email__c = 'invclgemail@test.com';
            invitedClg1.Primary_User__c = true;
            invitedClg1.SapContactId__c = con.SAP_Contact_ID__c;
            //invitedClg1.Lead__c = lead.id; 
            insert invitedClg1;

            //Create WebServiceSettings for the services
            LIST < WebServiceSettings__c > webList = new LIST < WebServiceSettings__c > ();
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
            WebServiceSettings__c web6 = new WebServiceSettings__c();
            web6.Endpoint__c = 'test.endpoint';
            web6.Name = 'PaymentCreditIncrease';
            web6.Active__c = true;
            web6.Username__c = 'test.user';
            web6.Password__c = 'test:123';
            web6.Service_Unavailable_Message__c = 'testservice';
            webList.add(web6);
            insert webList;

            Opportunity_Trial__c opptrial = new Opportunity_Trial__c();
            opptrial.Opportunity__c = opp.id;
            opptrial.Trial__c = tr.id;
            insert opptrial;

            Test.startTest();
            apexpages.currentpage().getparameters().put('id', opp.id);
            ApexPages.StandardController cont = new ApexPages.StandardController(opp);
            ODTStartNCJCon ncj = new ODTStartNCJCon(cont);
            ncj.getSalesOrgs();
            ODT_Market_Segments__mdt odtSeg1 = [SELECT Id, Market_Segment__c, Business_Type__c FROM ODT_Market_Segments__mdt where Market_Segment__c =: accSSD.LCRM_Market_Segment__c];
            apexpages.currentpage().getparameters().put('selval', odtSeg1.id);
            ncj.refreshINCProducts();
            ncj.fetchProducts('CTX');
            ncj.wrapper.selMarketSegment = odtSeg1.Business_Type__c;
            ncj.wrapper.selProductBundle = String.valueof(prdBndl1.Id);
            ncj.finish();
            ncj.getListVal();
            //DLT-20756 - PMD Fix
            System.assertEquals(tr.Trial_Status__c, 'Rep Initiated', 'Expected Trial Status Value');
            Test.stopTest();
        }
    }
}