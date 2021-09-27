/*============================================================================================
    Name                : ODT_trialExtendController
    Description         : This class is developed as part of CXD-ODT project. This class acts as controller for the VF page 'ODT_trialextend'
    Created Date        : 11/02/2018
    Author              : CXD ODT team
    Modification History: 
    Date           Name                    Description
    11/02/2018     Harshitha KN            Created[DLT-13290]
    11/21/2018     Harshitha KN            Modified[DLT-12331:Added validations to check Trial Extension limit]
    05/14/2020     Rahul Natarajan          DLT-19957 -Allow the "ODT Number of Days" field to pass Dynamic Values rather than Hard coded values
    05/23/2020      Rahul Natarajan         DLT-20097 - Sending Trial Extension request to Eloqua
===============================================================================================*/

public without sharing class ODT_trialExtendController {
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
    public boolean isNull {
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
    public boolean isExtended {
        get;
        set;
    }
    public boolean checkEligibility {
        get;
        set;
    }
    public integer daysToExtend {
        get;
        set;
    }
    public ODT_trialExtendController(ApexPages.StandardController controller) {

        trialId = apexpages.currentPage().getParameters().get('Id').escapeHtml4();
        trial = new Trial__c();
        opptrial = new Opportunity_Trial__c();

        if (Schema.sObjectType.Trial__c.isAccessible()) {
            trial = [SELECT Id, Trial_Status__c, Trial_Start_Date__c, Trial_End_Date__c, ODT_Trial_Extend_Date__c, ODT_Number_Of_Days_Trial_Extended__c, ODT_Email__c,
                ODT_SAP_Account_Number__c, Is_Lead_Converted__c, Contact_id_SAP__c, Contact_LeadId__c, Contact_LeadId__r.Id, Contact_LeadId__r.Name, Primary_User_First_Name__c, Primary_User_Last_Name__c, Contact_LeadId__r.Company,
                Source_System_Detail__r.Account_Name__c, GUID__c, Trial_Id__c, Trial_Source__c, Is_Lapsed__c, No_Of_Times_Extended__c, Contact_LeadId__r.convertedOpportunityId, ODT_Product_Bundle__r.Trial_Expiry_Days__c,
                Contact_LeadId__r.convertedAccountId,
                (SELECT id, First_Name__c, Last_Name__c, Trial__c, Email__c, SapContactId__c, GUID__c, Trial_Status__c from Invite_Colleagues__r WHERE Trial_Status__c = 'Accepted') from Trial__c WHERE id =: trialId
            ];
        } //Added ODT_Product_Bundle__r.Trial_Expiry_Days__c in Query as part of DLT-19957 
        if (trial.Trial_Source__c == 'SFDC' && Schema.sObjectType.Opportunity_Trial__c.isAccessible())
            opptrial = [SELECT id, Opportunity__c, Trial__c from Opportunity_Trial__c WHERE Trial__c =: trial.Id LIMIT 1];

        isNull = false;
        isLimitExceeded = false;
        error = false;
        isExtended = false;
        checkEligibility = false;
    }

    public void extendTrialDate() {
        system.debug('>>>>Button Called Succesfully>>');
        if (trial.Id != null) {
            system.debug('trial.ODT_Trial_Extend_Date__c' + trial.ODT_Trial_Extend_Date__c);
            if (trial.ODT_Trial_Extend_Date__c == null) {
                isNull = true;
                system.debug('isNull' + isNull);
            } else {

                checkEligibility = checkTrialExtendEligibilty(trial);
            }
            system.debug('checkEligibility....' + checkEligibility);
            //if Trial limit is not exceeded then calls OLC service to extend the trial and then calls Eloqua to send confirmation email
            try {
                if (checkEligibility) {
                    HTTPResponse res = ODTTrialManagement.postTrialExtendDetails(trialId, 'Extend', '', String.valueOf(trial.ODT_Trial_Extend_Date__c));
                    if (res != null) {
                        system.debug('@@@@60' + res);
                        if (res.getStatusCode() == 200) {
                            ESIResponseGetSubscription esiRes = (ESIResponseGetSubscription) JSON.deserialize(res.getBody(), ESIResponseGetSubscription.class);
                            System.debug('esiResp:' + esiRes);
                            if (esiRes.notification != null) {
                                String statusCode = esiRes.notification.statusCode;
                                String statusDescription = esiRes.notification.statusDescription;
                                system.debug('status code ' + statusCode + ' Description  ' + statusDescription);
                                if (statusCode.equals('200')) {
                                    system.debug('Active Trial present');
                                    isNull = false;
                                    trial.Trial_End_Date__c = trial.ODT_Trial_Extend_Date__c;
                                    trial.No_Of_Times_Extended__c += 1;
                                    Database.SaveResult updateTrial = Database.update(trial, false);
                                    isExtended = true;
                                } else {
                                    system.debug('Active Trial not there in OLC');
                                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Trial extension failed due to inactive Trial in OLC'));error = true;
                                }
                            }
                        } else if (res.getStatusCode() == 400) {system.debug('other error');ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'something went wrong'));error = true;
                        }
                    } else {
                        system.debug('response null');
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'No response'));error = true;
                    }

                    if (isExtended) {
                        system.debug('ic' + trial.Invite_Colleagues__r);
                        for (Invite_Colleagues__c ic: trial.Invite_Colleagues__r) {
                            //for rep initiated Trials with optyTrial
                            if (trial.Trial_Source__c == 'SFDC') {
                                system.debug('send callout');
                                ContactsListConCallout updJob = new ContactsListConCallout(ic.First_Name__c, ic.Last_Name__c, ic.Email__c, trial.ODT_SAP_Account_Number__c, ic.SapContactId__c, trial.Source_System_Detail__r.Account_Name__c, null, ic.GUID__c, trial.Trial_Id__c, ic.SapContactId__c, oppTrial.Opportunity__c, trial.Id, trial.Source_System_Detail__r.Account_Name__c, Label.ODT_Rep_Initiated_URL, 'Extended', trial.Trial_Source__c, trial.Trial_End_Date__c, null, null, false, false, null, trial.Trial_Start_Date__c);
                                ID jobID = System.enqueueJob(updJob);
                            }
                            /* //for trials initiated from LS.com with lead not converted
                            else if( trial.Contact_LeadId__c!=null  && trial.Is_Lead_Converted__c==false){
                                ContactsListConCallout updJob2 = new ContactsListConCallout(ic.First_Name__c, ic.Last_Name__c, ic.Email__c, trial.ODT_SAP_Account_Number__c, ic.SapContactId__c, trial.Contact_LeadId__c, null, ic.GUID__c, trial.Trial_Id__c, ic.SapContactId__c, trial.Contact_LeadId__c, trial.Id , trial.Contact_LeadId__c, Label.ODT_Rep_Initiated_URL,'Extended', trial.Trial_Source__c, trial.Trial_End_Date__c, null, null, false, false, null, trial.Trial_Start_Date__c); 
                                ID jobID2 = System.enqueueJob(updJob2);
                            }*/
                            //for trials with Lead converted
                            else if (trial.Contact_LeadId__c != null && trial.Is_Lead_Converted__c == true) {ContactsListConCallout updJob2 = new ContactsListConCallout(ic.First_Name__c, ic.Last_Name__c, ic.Email__c, trial.ODT_SAP_Account_Number__c, ic.SapContactId__c, trial.Contact_LeadId__c, null, ic.GUID__c, trial.Trial_Id__c, ic.SapContactId__c, trial.Contact_LeadId__r.convertedOpportunityId, trial.Id, trial.Contact_LeadId__r.convertedAccountId, Label.ODT_Rep_Initiated_URL, 'Extended', trial.Trial_Source__c, trial.Trial_End_Date__c, null, null, false, false, null, trial.Trial_Start_Date__c);ID jobID2 = System.enqueueJob(updJob2);
                            }
                        }
                        //  Added as part of DLT-20097 
                        List<Invite_Colleagues__c > iclist = [Select Id from Invite_Colleagues__c where Trial__c =: trial.Id];
                        if ((iclist.isEmpty()) && (trial.Contact_LeadId__c != null && trial.Is_Lead_Converted__c == true)) {
                            system.debug('send callout for trial alone as no invited Colleagues there');
                            ContactsListConCallout updJob3 = new ContactsListConCallout(trial.Primary_User_First_Name__c, trial.Primary_User_Last_Name__c, trial.ODT_Email__c, trial.ODT_SAP_Account_Number__c, trial.Contact_id_SAP__c, trial.Contact_LeadId__c, null, trial.GUID__c, trial.Trial_Id__c, trial.Contact_id_SAP__c, trial.Contact_LeadId__r.convertedOpportunityId, trial.Id, trial.Contact_LeadId__r.Company, Label.ODT_Rep_Initiated_URL, 'Extended', trial.Trial_Source__c, trial.Trial_End_Date__c, true, false, trial.Is_Lapsed__c, false, true, trial.Trial_Start_Date__c);ID jobID1 = System.enqueueJob(updJob3);
                        }
                        //  Added as part of DLT-20097 

                    }
                } else {
                    isLimitExceeded = true;
                }
            } catch (Exception e) {system.debug('in the catch' + e.getStackTraceString());system.debug('in the catch' + e.getMessage());ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Trial Extension Failed'));error = true;
            }
        }
    }

    //method to check whether logged in User has exceeded Trial extension Limit
    public boolean checkTrialExtendEligibilty(Trial__c trial) {
        system.debug('extend date' + trial.ODT_Trial_Extend_Date__c);
        system.debug('num of days' + trial.ODT_Number_Of_Days_Trial_Extended__c);
        Id userId = userinfo.getUserId();
        User userDetails = [SELECT Id, UserRole.Name FROM User where Id =: userId];
        if (trial.ODT_Number_Of_Days_Trial_Extended__c == null) { trial.ODT_Number_Of_Days_Trial_Extended__c = Integer.valueOf(trial.ODT_Product_Bundle__r.Trial_Expiry_Days__c); }
            //  trial.ODT_Number_Of_Days_Trial_Extended__c=7;  Commented this and added below line as part of DLT-19957
    
        if (trial.No_Of_Times_Extended__c == null) {trial.No_Of_Times_Extended__c = 0;}

        if (trial.Trial_End_Date__c > date.today()) {
            daysToExtend = trial.Trial_End_Date__c.daysBetween(trial.ODT_Trial_Extend_Date__c);
            trial.ODT_Number_Of_Days_Trial_Extended__c += daysToExtend;
            System.debug('daysToExtend->' + daysToExtend + 'trial.ODT_Number_Of_Days_Trial_Extended__c->' + trial.ODT_Number_Of_Days_Trial_Extended__c);
        } else {
            daysToExtend = date.today().daysBetween(trial.ODT_Trial_Extend_Date__c);
            trial.ODT_Number_Of_Days_Trial_Extended__c += daysToExtend;
            System.debug('daysToExtend' + daysToExtend + 'trial.ODT_Number_Of_Days_Trial_Extended__c' + trial.ODT_Number_Of_Days_Trial_Extended__c);
        }

        ODT_Trial_Extend_Limitations__mdt trialLimit = [SELECT Num_of_Times_Trial_Extension_for_SR__c, Num_of_Times_Trial_Extension_for_TM__c,
            Num_of_Trial_Extension_days_for_SR__c, Num_of_Trial_Extension_days_for_TM__c from ODT_Trial_Extend_Limitations__mdt where
            MasterLabel = 'Trial Extend Limitations'
        ];

        //if(Label.ODT_Trial_Manager_Role != null && userDetails.UserRole != null){        
        if (Label.ODT_Trial_Manager_Role.containsIgnoreCase(userDetails.UserRole.Name)) {
            if (trial.ODT_Number_Of_Days_Trial_Extended__c<trialLimit.Num_of_Trial_Extension_days_for_TM__c) {checkEligibility = true;} else {checkEligibility = false;}
        } else if (ODT_TrialInitiationHelper.isValidUserRole(userDetails)) {

            if (trial.ODT_Number_Of_Days_Trial_Extended__c<trialLimit.Num_of_Trial_Extension_days_for_SR__c &&
                trial.No_Of_Times_Extended__c<trialLimit.Num_of_Times_Trial_Extension_for_SR__c) {
                checkEligibility = true;
            } else {
                checkEligibility = false;
            }
        }
        system.debug('checkEligibility' + checkEligibility);
        return checkEligibility;
    }

    //method to redirect to detail page of the record
    public PageReference backToTrial() {
        PageReference pf = new PageReference('/' + trialId);
        pf.setRedirect(true);
        return pf;
    }
}