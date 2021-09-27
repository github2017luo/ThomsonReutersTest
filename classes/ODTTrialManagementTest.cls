/**
 * CHANGE HISTORY
 * =============================================================================
 * Date         Name                    Description
 * 2020-03-23   Brenda Shields          DLT-19804 - Move State/Country references from Account/Contact/Leads to methods in DCTestData    
 * 10/1/2020    Rahul                   DLT-20756 :[SFDC] [ODT] Critical and Blocker Code scan issue 
 * 2020-12-16   Brenda Shields          DLT-21137 [ODT][tech Story] Fix Test class for smoother deployment                            
 * =============================================================================
 */

@isTest
public class ODTTrialManagementTest {
    
    static testmethod void testTrialExtendToEsiCallout() {

        Profile p1 = [SELECT Id FROM profile WHERE name = 'GLI Sales User'];
        UserRole ukiRole1 = [SELECT Id FROM UserRole WHERE Name = 'Small Law'];
        //System.debug('inside11 :::ukiRole'+ukiRole);
        User u2;
        String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
 
        System.runAs(new User(Id = UserInfo.getUserId())) {
            u2 = new User(alias = 'newUser', email = 'user@mydomain.com', firstName = 'Firsttest', 
                emailencodingkey = 'UTF-8', lastname = 'Testing', languagelocalekey = 'en_US',
                localesidkey = 'en_US', profileid = p1.Id, employeenumber = '0144020',
                Sales_Org__c = 'GLI', Sub_Bu__c = 'Elite', timezonesidkey = 'America/Los_Angeles', 
                username = 'test'+dateString+'@mydomain.com', Rep_Type_Description__c = 'test', UserRoleId = ukiRole1.Id);
            insert u2;
            system.debug(LoggingLevel.INFO, 'inside222 :::u2' + u2);
        }

        system.runAs(u2) {

            //Create webservice setting
            LIST < WebServiceSettings__c > webList = new LIST < WebServiceSettings__c > ();
            WebServiceSettings__c web = new WebServiceSettings__c();
            web.Endpoint__c = 'test.endpoint';
            web.Name = 'ODTTrialExtensionService';
            web.Username__c = 'test.user';
            web.Password__c = 'test:123';
            web.Service_Unavailable_Message__c = 'testservice';
            webList.add(web);
            insert webList;
            
            // Create Account
            Account newAcct = DCTestData.createAccount('Test Class Account');
            newAcct.OwnerId = u2.id; //UserInfo.getUserId();
            newAcct.Is_GLI__c = false;
            insert newAcct;

            //Create AccountSSD record            
            Source_System_Detail__c accSSD = new Source_System_Detail__c();
            accSSD.Name = 'Test Account SSD';
            accSSD.Source_System_Name__c = 'Test System';
            accSSD.Source_System_Account_Number__c = '173468930';
            //accSSD.Account_Name__c = newAcct.id;
            accSSD.Trial_Status__c = '';
            accSSD.LCRM_Market_Segment__c = 'SLF 4-6';
            accSSD.Trial_Status__c = 'Ended';
            insert accSSD;


            //Create Contact
            Contact con = new Contact();
            con.FirstName = 'John';
            con.LastName = 'Ray';
            con.SAP_Contact_ID__c = '6271252';
            //con.AccountId = newAcct.id;
            con.Email = 'john.ray@tr.com';
            insert con;

            //create Trial
            Trial__c tr = new Trial__c();
            tr.Source_System_Detail__c = accSSD.id;
            tr.Trial_Id__c = '56576';
            tr.ODT_Trial_Extend_Date__c = date.today() + 8;
            //tr.Contact_LeadId__c=newLead.Id;
            tr.Contact_id_SAP__c = con.SAP_Contact_ID__c;
            tr.Trial_Source__c = label.ODT_Trial_Source;
            tr.InvitedDateTime__c = System.today() - 200;
            tr.Trial_Status__c = 'Timed-out';
            tr.Trial_Start_Date__c = System.today();
            tr.Trial_End_Date__c = System.today() + 7;
            tr.ODT_SAP_Account_Number__c = accSSD.Source_System_Account_Number__c;
            insert tr;

            Trial__c tr1 = new Trial__c();
            tr1.Source_System_Detail__c = accSSD.id;
            tr1.Trial_Id__c = '56576';
            tr1.ODT_Trial_Extend_Date__c = date.today() + 14;
            //tr.Contact_LeadId__c=newLead.Id;
            tr1.Contact_id_SAP__c = con.SAP_Contact_ID__c;
            tr1.Trial_Source__c = label.ODT_Trial_Source;
            tr1.InvitedDateTime__c = System.today() - 200;
            tr1.Trial_Status__c = 'Timed-out';
            tr1.Trial_Start_Date__c = System.today() - 14;
            tr1.Trial_End_Date__c = System.today() - 7;
            tr1.ODT_SAP_Account_Number__c = accSSD.Source_System_Account_Number__c;
            insert tr1;

            //create Invited colleagues
            Invite_Colleagues__c invitedClg2 = New Invite_Colleagues__c();
            invitedClg2.First_Name__c = 'test invite';
            invitedClg2.Last_Name__c = 'tessstt';
            invitedClg2.Trial_Status__c = 'Accepted';
            invitedClg2.Trial__c = tr.id;
            //vitedClg2.Lead__c = lead.id; 
            invitedClg2.Primary_User__c = false;
            invitedClg2.SapContactId__c = '6271253';
            insert invitedClg2;

            Invite_Colleagues__c invitedClg3 = New Invite_Colleagues__c();
            invitedClg3.First_Name__c = 'test invite3';
            invitedClg3.Last_Name__c = 'tessstt3';
            invitedClg3.Trial_Status__c = 'Accepted';
            invitedClg3.Trial__c = tr.id;
            //vitedClg2.Lead__c = lead.id; 
            invitedClg3.Primary_User__c = true;
            invitedClg3.SapContactId__c = con.SAP_Contact_ID__c;
            insert invitedClg3;

            test.startTest();
            String extendDate=String.valueof(System.today());
            Test.setMock(HttpCalloutMock.class, new HttpResponseMock());
            ODTTrialManagement.postTrialExtendDetails(tr.id, 'Extend', 'Incorrect Trial', extendDate);
            apexpages.currentpage().getparameters().put('id', tr.id);
            ApexPages.StandardController scon = new ApexPages.StandardController(tr);

            ODT_TrialEndCon od = new ODT_TrialEndCon(scon);
            od.closePopup();
            od.backToTrial();
            od.closeOtherReason();
            od.showOtherReason();
            od.showReason();
            ODTTrialManagement.testServiceBoolean = false;
            od.endTrial();
            ODTTrialManagement.testServiceBoolean = true;
            od.endTrial();
            ESIResponseGetSubscription.onlineContact eoc = new ESIResponseGetSubscription.onlineContact();
            ESIResponseGetSubscription.notification eno = new ESIResponseGetSubscription.notification();
            //DLT-20756 - PMD Fix
            System.assertEquals(tr1.Trial_End_Date__c, System.today()-7, 'Expected Trial Status Value');
            test.stopTest();
        }
    }
}