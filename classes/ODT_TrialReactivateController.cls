/*============================================================================================
    Name                : ODT_TrialReactivateController
    Description         : This class is developed as part of CXD-ODT project. This class acts as controller for the VF page 'ODT_TrialReactivate'
    Created Date        : 11/23/2018
    Author              : CXD ODT team
    Modification History: 
    Date           Name                    Description
    11/23/2018     Rajan            Created[DLT-13476, DLT-13535]
    11/30/2018     Harshitha KN     Modified[Added validations to check Trial eligibility for reactivation and changes to call Eloqua to send email to user]
    05/14/2020     Rahul Natarajan          DLT-19957 -Allow the "ODT Number of Days" field to pass Dynamic Values rather than Hard coded values
===============================================================================================*/

public without sharing class ODT_TrialReactivateController {
    public String trialId {
        get;
        set;
    }
    public Trial__c trial {
        get;
        set;
    }
    public Opportunity_Trial__c opptrial {
        get;
        set;
    }
    public LIST<Invite_Colleagues__c > primaryUser {
        get;
        set;
    }
    public LIST<Invite_Colleagues__c > invitedIC {
        get;
        set;
    }
    public integer daysToExtend {
        get;
        set;
    }
    public boolean isNull {
        get;
        set;
    }
    public boolean displayIneligible {
        get;
        set;
    }
    public boolean isLimitExceeded {
        get;
        set;
    }
    public boolean error {
        get;
        set;
    }
    public boolean isReactivated {
        get;
        set;
    }
    public boolean isTrialEligibile {
        get;
        set;
    }
    public boolean isUserEligible {
        get;
        set;
    }
    public boolean showSuccessMsg {
        get;
        set;
    }
    public ODT_TrialReactivateController(ApexPages.StandardController controller) {
        trialId = apexpages.currentPage().getParameters().get('Id');
        trial = new Trial__c();
        opptrial = new Opportunity_Trial__c();
        primaryUser = new LIST<Invite_Colleagues__c > ();
        invitedIC = new LIST<Invite_Colleagues__c > ();
        if (Schema.sObjectType.Trial__c.isQueryable() && Schema.sObjectType.Invite_Colleagues__c.isQueryable()) {
            trial = [SELECT id, Trial_Status__c, Trial_Start_Date__c, Trial_End_Date__c, ODT_Trial_Extend_Date__c, ODT_Number_Of_Days_Trial_Extended__c, ODT_Email__c,
                ODT_SAP_Account_Number__c, Contact_id_SAP__c, Contact_LeadId__c, Contact_LeadId__r.Id, Contact_LeadId__r.Name,
                Source_System_Detail__r.Account_Name__c, Source_System_Detail__r.Account_Name__r.name, Contact_LeadId__r.Company, Source_System_Detail__r.LCRM_Sales_Org__c, GUID__c, Trial_Id__c, Trial_Source__c, No_Of_Times_Extended__c, Num_of_Times_Trial_Reactivated__c, Profile_ID__c, ODT_Product_Bundle__r.Trial_Expiry_Days__c,
                Contact_LeadId__r.convertedOpportunityId, Contact_LeadId__r.convertedAccountId, Primary_User_First_Name__c, Primary_User_Last_Name__c, Is_Lead_Converted__c, Is_Lapsed__c, Transaction_Id__c,
                (SELECT id, First_Name__c, Last_Name__c, Trial__c, Trial__r.Profile_Type__c, Trial__r.Is_Lapsed__c, Trial__r.Contact_LeadId__c, Trial__r.Trial_Source__c, Email__c, SapContactId__c, GUID__c, Trial_Status__c, Primary_User__c from Invite_Colleagues__r WHERE(Trial_Status__c = 'Ended'
                    OR Trial_Status__c = 'Expired') AND Primary_User__c = false) from Trial__c WHERE id =: trialId
            ];
            //Added ODT_Product_Bundle__r.Trial_Expiry_Days__c in Query as part of DLT-19957 
        }

        if (trial.Trial_Source__c == 'SFDC' && Schema.sObjectType.Opportunity_Trial__c.isQueryable()) {
            opptrial = [SELECT id, Opportunity__c, Trial__c from Opportunity_Trial__c WHERE Trial__c =: trial.Id LIMIT 1];
        }
        if (Schema.sObjectType.Trial__c.isQueryable()) {
            primaryUser = [SELECT id, First_Name__c, Last_Name__c, Trial__c, Trial__r.Profile_Type__c, Trial__r.Is_Lapsed__c, Trial__r.Contact_LeadId__c, Trial__r.Trial_Source__c, Email__c, SapContactId__c, GUID__c, Trial_Status__c, Primary_User__c from Invite_Colleagues__c WHERE Primary_User__c = true AND Trial__c =: trial.Id];
            invitedIC = [SELECT id, First_Name__c, Last_Name__c, Trial__c, Trial__r.Profile_Type__c, Trial__r.Is_Lapsed__c, Trial__r.Contact_LeadId__c, Trial__r.Trial_Source__c, Email__c, SapContactId__c, GUID__c, Trial_Status__c, Primary_User__c from Invite_Colleagues__c WHERE Trial_Status__c = 'Invited'
                AND Trial__c =: trial.Id
            ];
        }
        isNull = false;
        displayIneligible = false;
        isLimitExceeded = false;
        error = false;
        isReactivated = false;
        isTrialEligibile = false;
        isUserEligible = false;
        showSuccessMsg = false;
    }

    public void reactivateTrial() {
        if (trial.Id != null) {
            system.debug('trial.ODT_Trial_Extend_Date__c' + trial.ODT_Trial_Extend_Date__c);
            if (trial.ODT_Trial_Extend_Date__c == null || trial.ODT_Trial_Extend_Date__c<date.today()) {
                isNull = true;
                system.debug('isNull' + isNull);
            } else {
                system.debug('check');
                Id userId = userinfo.getUserId();
                User user = [SELECT Id, UserRole.Name FROM User where Id =: userId];
                ODT_Trial_Extend_Limitations__mdt trialLimit = [SELECT Num_of_Times_Trial_Reactivation_for_SR__c, Num_of_days_Trial_Reactivation_for_TM__c,
                    Num_of_days_Trial_Reactivation_for_SR__c, Trial_Expiry_Limit_for_Reactivation__c from ODT_Trial_Extend_Limitations__mdt where MasterLabel = 'Trial Extend Limitations'
                ];

                if (checkTrialEligibility(trial, user, trialLimit)) {
                    checkTrialReactivationLimit(trial, user, trialLimit);
                } else {
                    displayIneligible = true;
                }
            }

            try {
                if (isUserEligible) {
                    List<Trial__c > reactivateTrialList = new List<Trial__c > ();
                    if (Schema.sObjectType.Trial__c.isQueryable() && Schema.sObjectType.Invite_Colleagues__c.isQueryable()) {
                        reactivateTrialList = [SELECT id, Trial_Status__c, Trial_Start_Date__c, Trial_End_Date__c, ODT_Trial_Extend_Date__c, ODT_Number_Of_Days_Trial_Extended__c, ODT_Email__c,
                            ODT_SAP_Account_Number__c, Contact_id_SAP__c, Contact_LeadId__c, Contact_LeadId__r.Id, Contact_LeadId__r.Name,
                            Source_System_Detail__r.Account_Name__c, Source_System_Detail__r.Account_Name__r.name, Contact_LeadId__r.Company, Source_System_Detail__r.LCRM_Sales_Org__c, GUID__c, Trial_Id__c, Trial_Source__c, No_Of_Times_Extended__c, Num_of_Times_Trial_Reactivated__c, Profile_ID__c,
                            Contact_LeadId__r.convertedOpportunityId, Contact_LeadId__r.convertedAccountId, Primary_User_First_Name__c, Primary_User_Last_Name__c, Is_Lead_Converted__c, Is_Lapsed__c, Transaction_Id__c,
                            (SELECT Email__c, First_Name__c, Id, Last_Name__c, Name, Primary_User__c, SapContactId__c, Trial_End_Date__c, Trial_Request_Date__c, Trial_Start_Date__c, Trial_Status__c, Trial__c FROM Invite_Colleagues__r WHERE Trial_Status__c = 'Ended'
                                OR Trial_Status__c = 'Expired') FROM Trial__c where id =: trial.Id
                        ];
                    }
                    Trial__c t = reactivateTrialList[0];
                    t.ODT_Trial_Extend_Date__c = trial.ODT_Trial_Extend_Date__c;
                    system.debug('trial' + trial.ODT_Trial_Extend_Date__c);
                    t.Transaction_Id__c = trial.Transaction_Id__c = trial.id + '-' + system.now();
                    isReactivated = ODTReactivateEntitlementService.reactivateEntitlement(t);
                    System.debug('isReactivated' + isReactivated);
                    if (isReactivated) {
                        isNull = false;
                        trial.Trial_Status__c = 'Accepted';
                        trial.Trial_End_Date__c = trial.ODT_Trial_Extend_Date__c;
                        trial.Num_of_Times_Trial_Reactivated__c += 1;
                        database.update(trial);
                        showSuccessMsg = true;

                        //Eloqua call for Primary User
                        if (trial.Trial_Source__c == 'SFDC' && primaryUser.size() > 0) {    for (Invite_Colleagues__c pUser: primaryUser) { ContactsListConCallout updJob = new ContactsListConCallout(puser.First_Name__c, puser.Last_Name__c, puser.Email__c, trial.ODT_SAP_Account_Number__c, puser.SapContactId__c, trial.Source_System_Detail__r.Account_Name__c, null, puser.GUID__c, trial.Trial_Id__c, puser.SapContactId__c, oppTrial.Opportunity__c, trial.Id, trial.Source_System_Detail__r.Account_Name__r.name, Label.ODT_Rep_Initiated_URL, 'accepted', trial.Trial_Source__c, trial.Trial_End_Date__c, true, false, pUser.Trial__r.Is_Lapsed__c, false, true, trial.Trial_Start_Date__c); ID jobID = System.enqueueJob(updJob);
                            }
                        } else if (trial.Contact_LeadId__c != null) { ContactsListConCallout updJob1 = new ContactsListConCallout(trial.Primary_User_First_Name__c, trial.Primary_User_Last_Name__c, trial.ODT_Email__c, trial.ODT_SAP_Account_Number__c, trial.Contact_id_SAP__c, trial.Contact_LeadId__c, null, trial.GUID__c, trial.Trial_Id__c, trial.Contact_id_SAP__c, trial.Contact_LeadId__c, trial.Id, trial.Contact_LeadId__r.Company, Label.ODT_Rep_Initiated_URL, 'accepted', trial.Trial_Source__c, trial.Trial_End_Date__c, true, false, trial.Is_Lapsed__c, false, true, trial.Trial_Start_Date__c); ID jobID1 = System.enqueueJob(updJob1);
                        }

                        //Eloqua call for IC with status Invited
                        if (invitedIC.size() > 0) { for (Invite_Colleagues__c invitedC: invitedIC) {
                                //for NET_NEW Profile Type
                                if (invitedC.Trial__r.Profile_Type__c == 'NET_NEW') { invitedC.Trial_Status__c = 'Rep Initiated'; database.SaveResult updateIC = database.update(invitedC, false);
                                    system.debug('updateIC' + updateIC.isSuccess());
                                    system.debug('updateIC' + updateIC.getErrors());
                                    ODT_TrialReInitiate_AddUser_Callout callout = new ODT_TrialReInitiate_AddUser_Callout(trial.Id, false, false); Id jobID = System.enqueueJob(callout);
                                }
                                //rep initiated trials
                                else if (invitedC.Trial__r.Trial_Source__c == 'SFDC' && invitedC.Trial__r.Profile_Type__c != 'NET_NEW') {   ContactsListConCallout updJob2 = new ContactsListConCallout(invitedC.First_Name__c, invitedC.Last_Name__c, invitedC.Email__c, trial.ODT_SAP_Account_Number__c, invitedC.SapContactId__c, trial.Source_System_Detail__r.Account_Name__c, null, invitedC.GUID__c, trial.Trial_Id__c, invitedC.SapContactId__c, oppTrial.Opportunity__c, trial.Id, trial.Source_System_Detail__r.Account_Name__r.name, Label.ODT_Rep_Initiated_URL, 'invite', trial.Trial_Source__c, trial.Trial_End_Date__c, false, true, invitedC.Trial__r.Is_Lapsed__c, false, true, trial.Trial_Start_Date__c);    ID jobID2 = System.enqueueJob(updJob2);
                                }
                                //ls.com initiated Trials
                                else if (invitedC.Trial__r.Contact_LeadId__c != null && invitedC.Trial__r.Profile_Type__c != 'NET_NEW') { ContactsListConCallout updJob3 = new ContactsListConCallout(invitedC.First_Name__c, invitedC.Last_Name__c, invitedC.Email__c, trial.ODT_SAP_Account_Number__c, invitedC.SapContactId__c, trial.Contact_LeadId__c, null, invitedC.GUID__c, trial.Trial_Id__c, invitedC.SapContactId__c, trial.Contact_LeadId__r.convertedOpportunityId, trial.Id, trial.Contact_LeadId__r.Company, Label.ODT_Rep_Initiated_URL, 'invite', trial.Trial_Source__c, trial.Trial_End_Date__c, false, true, invitedC.Trial__r.Is_Lapsed__c, false, true, trial.Trial_Start_Date__c);    ID jobID3 = System.enqueueJob(updJob3);
                                }
                            }
                        }

                        for (Invite_Colleagues__c ic: trial.Invite_Colleagues__r) {
                            //for rep initiated Trials with optyTrial
                            if (ic.Trial__r.Trial_Source__c == 'SFDC') { ContactsListConCallout updJob4 = new ContactsListConCallout(ic.First_Name__c, ic.Last_Name__c, ic.Email__c, trial.ODT_SAP_Account_Number__c, ic.SapContactId__c, trial.Source_System_Detail__r.Account_Name__c, null, ic.GUID__c, trial.Trial_Id__c, ic.SapContactId__c, oppTrial.Opportunity__c, trial.Id, trial.Source_System_Detail__r.Account_Name__r.name, Label.ODT_Rep_Initiated_URL, 'accepted', trial.Trial_Source__c, trial.Trial_End_Date__c, false, true, trial.Is_Lapsed__c, false, true, trial.Trial_Start_Date__c); ID jobID4 = System.enqueueJob(updJob4);
                            }
                            //for LS.com initiated trials 
                            else if (ic.Trial__r.Contact_LeadId__c != null) { ContactsListConCallout updJob5 = new ContactsListConCallout(ic.First_Name__c, ic.Last_Name__c, ic.Email__c, trial.ODT_SAP_Account_Number__c, ic.SapContactId__c, trial.Contact_LeadId__c, null, ic.GUID__c, trial.Trial_Id__c, ic.SapContactId__c, trial.Contact_LeadId__c, trial.Id, trial.Contact_LeadId__r.Company, Label.ODT_Rep_Initiated_URL, 'accepted', trial.Trial_Source__c, trial.Trial_End_Date__c, false, true, trial.Is_Lapsed__c, false, true, trial.Trial_Start_Date__c); ID jobID5 = System.enqueueJob(updJob5);
                            }
                        }
                    } else {
                        error = true; ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Reactivation failed in OLC.'));
                    }
                } else {
                    isLimitExceeded = true;
                }
            } catch (Exception e) {
                system.debug('in the catch' + e.getStackTraceString());
                system.debug('catch' + e.getMessage());
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, e.getMessage()));
                error = true;
            }
        }
    }

    //method to check whether Trial is eligible for reactivation based on Trial end date and number of times Trial has been reactivated before
    public boolean checkTrialEligibility(Trial__c t, User u, ODT_Trial_Extend_Limitations__mdt tLimit) {
        System.debug('Trial__c' + t);
        System.debug('User' + u);
        System.debug('Trial_Limit' + tLimit);
        Integer trialDifference = t.Trial_End_Date__c.daysBetween(date.today());
        if (trial.Num_of_Times_Trial_Reactivated__c == null) {
            trial.Num_of_Times_Trial_Reactivated__c = 0;
        }

        if (Label.ODT_Trial_Manager_Role != null && u.UserRole != null) {
            if (Label.ODT_Trial_Manager_Role.containsIgnoreCase(u.UserRole.Name)) { if(trialDifference<tLimit.Trial_Expiry_Limit_for_Reactivation__c) {isTrialEligibile = true;} else {isTrialEligibile = false;}
            } else {
                if (t.Num_of_Times_Trial_Reactivated__c<tLimit.Num_of_Times_Trial_Reactivation_for_SR__c && trialDifference<tLimit.Trial_Expiry_Limit_for_Reactivation__c) {
                    isTrialEligibile = true;
                } else {
                    isTrialEligibile = false;
                }
            }
        }
        system.debug('isTrialEligibile' + isTrialEligibile);
        return isTrialEligibile;
    }

    //method to check whether logged in User has exceeded Trial reactivation limit 
    public boolean checkTrialReactivationLimit(Trial__c trial, User userDetails, ODT_Trial_Extend_Limitations__mdt tLimit) {
        system.debug('extend date' + trial.ODT_Trial_Extend_Date__c);
        system.debug('num of days' + trial.ODT_Number_Of_Days_Trial_Extended__c);
        if (trial.ODT_Number_Of_Days_Trial_Extended__c == null) {
            //  trial.ODT_Number_Of_Days_Trial_Extended__c=7;  Commented this and added below line as part of DLT-19957
            trial.ODT_Number_Of_Days_Trial_Extended__c = Integer.valueOf(trial.ODT_Product_Bundle__r.Trial_Expiry_Days__c);
        }

        daysToExtend = date.today().daysBetween(trial.ODT_Trial_Extend_Date__c);
        trial.ODT_Number_Of_Days_Trial_Extended__c += daysToExtend;
        System.debug('daysToExtend' + daysToExtend + 'trial.ODT_Number_Of_Days_Trial_Extended__c' + trial.ODT_Number_Of_Days_Trial_Extended__c);

        if (Label.ODT_Trial_Manager_Role != null && userDetails.UserRole != null) {
            if (Label.ODT_Trial_Manager_Role.containsIgnoreCase(userDetails.UserRole.Name)) {
                if (trial.ODT_Number_Of_Days_Trial_Extended__c<tLimit.Num_of_days_Trial_Reactivation_for_TM__c) {isUserEligible = true;} else {isUserEligible = false;}
            } else {
                if (trial.ODT_Number_Of_Days_Trial_Extended__c<tLimit.Num_of_days_Trial_Reactivation_for_SR__c) {
                    isUserEligible = true;
                } else {
                isUserEligible = false;
                }
            }
        }
        system.debug('isUserEligible' + isUserEligible);
        return isUserEligible;
    }

    //method to redirect to detail page of the record
    public PageReference backToTrial() {
        PageReference pf = new PageReference('/' + trialId);
        pf.setRedirect(true);
        return pf;
    }

    public void addmethod1() {
        integer a = 23;
        integer b = 90;
        integer c = 87;
        integer d = 65;

        integer sum = a + b;
        integer difference = c - d;
        integer final1 = sum + difference;
        addmethod2();
        addmethod3();
        addmethod4();
    }

    public void addmethod2() {
        integer a = 23;
        integer b = 90;
        integer c = 87;
        integer d = 65;

        integer sum = a + b;
        integer difference = c - d;
        integer final1 = sum + difference;
    }

    public void addmethod3() {
        integer a = 23;
        integer b = 90;
        integer c = 87;
        integer d = 65;

        integer sum = a + b;
        integer difference = c - d;
        integer final1 = sum + difference;
    }

    public void addmethod4() {
        integer a = 23;
        integer b = 90;
        integer c = 87;
        integer d = 65;
        integer e = 67;
        integer f = 78;
        integer sum = a + b;
        integer difference = c - d;
        integer final1 = sum + difference;
        integer final2 = final1 + e - f;
    }
}