/*============================================================================================
    Name                : contactsListCon
    Description         : This class is developed as part of CXD-ODT project and here we are displaying all OLC contacts and proceeds for Trial 
                          Three services are integrated in this. 
                          1. Call to ESI to get the active trial details related to Account. 
                          2. Call to ESI to get the all online contact which are available on OLC system.
                          3. After selected contact by SalesRep, need to send email notification to Eloqua. 
    Created Date        : 01/19/2018
    Author              : TCS CXD ODT team
    Modification History: Modified by Mallik for showing all contacts which are available on OLC
                          Optimizing the code by Harshitha

                          Modified by Harshitha
                          DLT-8079:Creating lead and Trial from SFDC when Sales Rep iniates a Trial 

                          Modified by Harshitha 04/05/2018
                          DLT-8421:Sales Rep will not be able to initiate new Trial if account already has a Trail iniated from SFDC within last 30 days of period
                          
                          Modified  By Shailesh Patel 22/5/2018 DLT-9880
                          
                          Modified by Ameeta Antonio 
                          DLT-10234 : Modified the class as part of GLI Migration.
                          DLT-10931 : create/ Update Opportunity records instead of Lead

                          Modified by Ameeta Antonio on 14/9/2018
                          DLT-11633 : Modified the code to control the visibility of SLF and CORP products in the dropdown when sales rep initiates trial.

                          Modified by Ameeta Antonio on 10/19/2018
                          DLT-12944 : Initiation of trial by SalesRep or Trial Manager from the opportunity page

                          Modified by Ameeta Antonio on 10/19/2018
                          DLT-12962 : [SFDC] TM/SR-N-Initiate: 3.b existing NOT Cobalt - SFDC: ability to initiate a trial

                          Modified by Mallikarjuna Rao,Ameeta Antonio
                          DLT-12958 : [SFDC] TM/SR-N-Initiate: 2.b inactive sub - SFDC: ability to initiate a trial and link accounts
                                      with valid and invalid Reason codes

                         Modified by Harshitha 12/21/2018
                         DLT-14125 : Adding changes as part of Onbehalf functionality
CHANGE HISTORY
 ==============================================================================
 Date            Name                    Jira             Description
 23-07-2020      Rahul Natarajan         DLT-20035        Remove Segmentation Field References from CX Digital components.
==============================================================================================*/

global without sharing class contactsListCon {

    public string selectedCamp {
        get;
        set;
    }
    public List < SelectOption > allCampaignslist {
        get;
        set;
    }
    public LIST < contactsWrapper > contasTodisplay {
        get;
        set;
    }
    public string accountID {
        get;
        set;
    }
    public Source_System_Detail__c disAcc {
        get;
        set;
    }
    public string getSDDRecordId {
        get;
        set;
    } //SSD Record Id
    public Boolean hasTrialRec {
        get;
        set;
    }
    public Boolean hasAlreadyTrialInitiated {
        get;
        set;
    }
    public Boolean eloquaEmailTriggered {
        get;
        set;
    }
    public Boolean accountSSDActive {
        get;
        set;
    }
    public Boolean checkError {
        get;
        set;
    }
    public Boolean displayComponent {
        get;
        set;
    }
    public id leadRecordId {
        get;
        set;
    }
    public id trialRecordId {
        get;
        set;
    }
    public List < ODT_Product_Bundle__c > listPrdBundle;
    public id invitedColleagueId {
        get;
        set;
    }
    public string oppIDSelected {
        get;
        set;
    }
    public Opportunity selectedOppRecord {
        get;
        set;
    }
    public Source_System_Detail__c selectedSDDRecord {
        get;
        set;
    }
    public string lapsedReasonCode {
        get;
        set;
    }
    public string lapsedReasonCodeDesc {
        get;
        set;
    }
    public Boolean isLapsedAccount {
        get;
        set;
    }
    public Boolean isValid {
        get;
        set;
    }
    public String invalidReasonMsg {
        get;
        set;
    }
    public String userType {
        get;
        set;
    }
    public String checkboxText {
        get;
        set;
    }
    public boolean isOLCActive {
        get;
        set;
    }
    public boolean displayCheckBox {
        get;
        set;
    }
    public boolean NCJFromECJ {
        get;
        set;
    }

    //Constructor to call two services for Active Trial and Online Contacts
    public contactsListCon(ApexPages.StandardController controller) {
        try {
            System.debug('in contactsListCon');
            contasTodisplay = new LIST < contactsWrapper > ();
            listPrdBundle = New List < ODT_Product_Bundle__c > ();
            accountSSDActive = true;
            checkError = false;
            accountID = apexpages.currentpage().getparameters().get('id').escapeHtml4();
            disAcc = new Source_System_Detail__c();
            selectedOppRecord = New Opportunity();
            selectedSDDRecord = New Source_System_Detail__c();
            hasAlreadyTrialInitiated = FALSE;
            hasTrialRec = FALSE;
            displayComponent = TRUE;
            isLapsedAccount = FALSE;
            isValid = TRUE;
            checkboxText = label.ODT_CheckBox_Text;
            isOLCActive = false;
            displayCheckBox = false;
            System.debug('in contactsListCon');
            if (Static_Values__c.getAll().containsKey('DisplayNCJFromECJ')) {
                NCJFromECJ = Boolean.valueof(Static_Values__c.getAll().get('DisplayNCJFromECJ').Value__c);
            }
            //DLT-12944....Start:Added by Ameeta
            if (apexpages.currentpage().getparameters().get('ssdID') != null)
                getSDDRecordId = apexpages.currentpage().getparameters().get('ssdID').escapeHtml4();

            if (apexpages.currentpage().getparameters().get('oppID') != null)
                oppIDSelected = apexpages.currentpage().getparameters().get('oppID').escapeHtml4();
            system.debug('sdd---' + getSDDRecordId + 'opp------' + oppIDSelected);
            if (oppIDSelected != null && oppIDSelected != '') {

                if (getSDDRecordId != null && getSDDRecordId != '') {

                    displayComponent = false;
                    if (Schema.sObjectType.Opportunity.isAccessible()) {
                        selectedOppRecord = [Select Id, Name, Type, StageName FROM Opportunity where id =: oppIDSelected];
                    }
                    if (Schema.sObjectType.Source_System_Detail__c.isAccessible()) {
                        selectedSDDRecord = [Select Id, Name, Source_System_Account_Number__c FROM Source_System_Detail__c WHERE id =: getSDDRecordId];
                    }
                } else {
                    displayComponent = true;
                }
            }
            //DLT-12944....End:Added by Ameeta

        } catch (Exception e) {
            system.debug('Exception from line number 68' + e);
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, +e.getMessage()));
        }

    }

    //method to checkselected Trial initiation option
    public void refreshTrialSelectionOptions() {
        string selectedTrialOption = apexpages.currentpage().getparameters().get('selectedTrialoption');
        system.debug('selectedTrialOption' + selectedTrialOption);
        if (selectedTrialOption.equalsIgnoreCase(Label.ODT_Trial_Initiation_Option1)) {
            displayCheckBox = false;
        } else {
            displayCheckBox = true;
        }
        System.debug('displayCheckBox--->' + displayCheckBox);
    }

    //calling Eloqua Invitation EmailTrigger based on SalesRep Selection 
    public void startTrial() {
        system.debug('START .......');
        string qaselectedDomain = apexpages.currentpage().getparameters().get('selectedDomain');
        system.debug('qaselectedDomain-->' + qaselectedDomain);
        string selectedDomain = apexpages.currentpage().getparameters().get('selectedDomain').escapeHtml4();
        string selectedcustomer = apexpages.currentpage().getparameters().get('selectedContact');
        string emailOrPhone = apexpages.currentpage().getparameters().get('emailOrPhone');
        system.debug('selectedDomain-->' + selectedDomain + ' ' + 'selectedcustomer-->' + selectedcustomer + 'emailOrPhone-->' + emailOrPhone);

        // get the Callout parameters from Custom Setting
        WebServiceSettings__c oWebServiceSettings2 = AppUtil.getWebServiceSettings('ODTEloquaService');
        if (selectedcustomer != null && selectedDomain != null) {

            try {
                //Get the codes from Label 
                system.debug('oWebServiceSettings2' + oWebServiceSettings2);

                // Removed  Account Customer_Group__c from Below Query - DLT-20035
                Account newAcc = new Account();
                if (Schema.sObjectType.Account.isAccessible()) {
                    newAcc = [Select ID, Name, OwnerId, Phone, Customer_Type__c, BillingCity, BillingCountry, BillingPostalCode, BillingState, BillingStreet, SAPAccountNumber__c, External_Trial_Account_ID__c, Trial_Status__c FROM Account WHERE ID =: accountID];
                }

                for (contactsWrapper cw: contasTodisplay) {
                    if (cw.SAPContactId == selectedcustomer) {
                        if (cw.firstName != null && cw.firstName != '' && cw.lastName != null && cw.lastName != '' && cw.EmailId != null && cw.EmailId != '' && cw.SAPContactId != null && cw.SAPContactId != '') {

                            system.debug('selectedcustomer.......' + cw.SFDCContactId + '    ' + selectedcustomer);
                            system.debug('sapcontactid' + cw.sapcontactid);
                            MAP < string, string > campaignCodes = new MAP < string, string > ();

                            if (!listPrdBundle.isEmpty()) {
                                for (ODT_Product_Bundle__c odtprods: listPrdBundle) {
                                    campaignCodes.put(odtprods.Bundle_ID__c, odtprods.Product_Category__c);
                                }
                            }
                            string prodCategory;
                            if (campaignCodes.containsKey(selectedDomain)) {
                                prodCategory = campaignCodes.get(selectedDomain);
                            }

                            //Added by Harshitha for Trial reinitiate functionality
                            MAP < String, Id > productBundleIds = new MAP < String, Id > ();
                            if (!listPrdBundle.isEmpty()) {
                                for (ODT_Product_Bundle__c odtproduct: listPrdBundle) {
                                    productBundleIds.put(odtproduct.Bundle_ID__c, odtproduct.Id);
                                }
                            }
                            Id productBundleId;
                            if (productBundleIds.containsKey(selectedDomain)) {
                                productBundleId = productBundleIds.get(selectedDomain);
                            }
                            //reinitiate changes end  

                            //DLT-14125 Starts: Fetch Campaign and Hive9 Media Code from OPB record
                            MAP < String, Id > productCampaigns = new MAP < String, Id > ();
                            if (!listPrdBundle.isEmpty()) {
                                for (ODT_Product_Bundle__c odtproduct: listPrdBundle) {
                                    productCampaigns.put(odtproduct.Bundle_ID__c, odtproduct.Campaign__c);
                                }
                            }
                            Id productCampaign;
                            if (productCampaigns.containsKey(selectedDomain)) {
                                productCampaign = productCampaigns.get(selectedDomain);
                            }

                            MAP < String, String > productHiveCodes = new MAP < String, String > ();
                            if (!listPrdBundle.isEmpty()) {
                                for (ODT_Product_Bundle__c odtproduct: listPrdBundle) {
                                    productHiveCodes.put(odtproduct.Bundle_ID__c, odtproduct.Hive9_Media_Code__c);
                                }
                            }
                            String productHiveCode;
                            if (productHiveCodes.containsKey(selectedDomain)) {
                                productHiveCode = productHiveCodes.get(selectedDomain);
                            }

                            MAP < String, String > productProfileIds = new MAP < String, String > ();
                            if (!listPrdBundle.isEmpty()) {
                                for (ODT_Product_Bundle__c odtproduct: listPrdBundle) {
                                    productProfileIds.put(odtproduct.Bundle_ID__c, odtproduct.Profile_ID__c);
                                }
                            }
                            String productProfileId;
                            if (productProfileIds.containsKey(selectedDomain)) {
                                productProfileId = productProfileIds.get(selectedDomain);
                            }

                            MAP < String, String > productPromotionCodes = new MAP < String, String > ();
                            if (!listPrdBundle.isEmpty()) {
                                for (ODT_Product_Bundle__c odtproduct: listPrdBundle) {
                                    productPromotionCodes.put(odtproduct.Bundle_ID__c, odtproduct.SAP_Promotion_Code__c);
                                }
                            }
                            String productPromotionCode;
                            if (productPromotionCodes.containsKey(selectedDomain)) {
                                productPromotionCode = productPromotionCodes.get(selectedDomain);
                            }
                            //DLT-14125 End

                            Savepoint sp = Database.setSavepoint();

                            Database.UpsertResult resultOpps;
                            String errMsgInsertion = '';
                            try {
                                System.debug('oppIDSelected==check==' + oppIDSelected);
                                if (String.isBlank(oppIDSelected)) {
                                    resultOpps = CallToOLCTofetchActiveTr.createOpportunity(newAcc, cw.firstName, cw.lastName, cw.EmailId, 'A', disAcc, productCampaign, productHiveCode, null);
                                    System.debug('resultOpps....' + resultOpps);
                                } else {
                                    System.debug('resultOpps....Before  line no 250' + resultOpps);
                                    resultOpps = CallToOLCTofetchActiveTr.createOpportunity(newAcc, cw.firstName, cw.lastName, cw.EmailId, 'A', disAcc, productCampaign, productHiveCode, oppIDSelected);
                                    System.debug('resultOpps....' + resultOpps);
                                }
                                if (!resultOpps.isSuccess()) {
                                    for (Database.Error errOpps: resultOpps.getErrors()) {
                                        errMsgInsertion += 'Opportunity: ' + errOpps.getMessage() + '\r\n';
                                    }
                                }
                                oppIDSelected = resultOpps.getId();
                                //}

                                Database.UpsertResult tr;
                                if (emailOrPhone == 'false') {
                                    tr = CallToOLCTofetchActiveTr.createTrial(selectedDomain, cw.SAPContactId, disAcc.Id, cw.EmailId, disAcc.Source_System_Account_Number__c, productBundleId, prodCategory, null, lapsedReasonCode, isLapsedAccount, userType, productProfileId, productPromotionCode, false);
                                    trialRecordId = tr.getId();
                                } else {
                                    tr = CallToOLCTofetchActiveTr.createTrial(selectedDomain, cw.SAPContactId, disAcc.Id, cw.EmailId, disAcc.Source_System_Account_Number__c, productBundleId, prodCategory, null, lapsedReasonCode, isLapsedAccount, userType, productProfileId, productPromotionCode, true);
                                    trialRecordId = tr.getId();
                                }

                                //DLT-12370 Starts
                                Database.UpsertResult invColleague = CallToOLCTofetchActiveTr.createInvitedColleague(disAcc.Id, cw.EmailId, cw.firstName, cw.lastName, cw.SAPContactId, trialRecordId, true, /*INCid*/ null);
                                invitedColleagueId = invColleague.getId();
                                //DLT-12370 ends

                                Opportunity_Trial__c oppTrialJun = CallToOLCTofetchActiveTr.createOpportunityTrialJun(oppIDSelected, trialRecordId);
                                Database.SaveResult resultsOppTrial = Database.insert(oppTrialJun, false);

                                System.debug('oppIDSelected ID : ' + oppIDSelected);
                                System.debug('resultsOppTrial: ' + resultsOppTrial);
                                System.debug('trialRecordId : ' + trialRecordId);
                                System.debug('invitedColleagueId : ' + invitedColleagueId);


                                if (tr.isSuccess() && String.isNotblank(oppIDSelected) && resultsOppTrial.isSuccess()) {
                                    if (emailOrPhone == 'false') {
                                        ContactsListConCallout updJob = new ContactsListConCallout(cw.firstName, cw.lastName, cw.EmailId, cw.SAPAccountId, cw.SAPContactId, cw.SFDCAccountId, cw.SFDCContactId, cw.appGUID, selectedDomain, selectedcustomer, oppIDSelected, trialRecordId, disAcc.Account_Name__r.name, Label.ODT_Rep_Initiated_URL, 'Invite', 'SFDC', null, null, null, isLapsedAccount, null, false, null);
                                        ID jobID = System.enqueueJob(updJob);
                                        System.debug('@@@JobId.....: ' + jobID);
                                        eloquaEmailTriggered = TRUE;
                                        checkError = false;
                                    } else {
                                        ODT_TrialReInitiate_AddUser_Callout callout = new ODT_TrialReInitiate_AddUser_Callout(trialRecordId, true, true);
                                        Id jobID = System.enqueueJob(callout);
                                        System.debug('@@@JobId.....: ' + jobID);
                                        eloquaEmailTriggered = TRUE;
                                        checkError = false;
                                    }
                                } else {

                                    Database.rollback(sp);
                                    if (!tr.isSuccess()) {
                                        for (Database.Error errTr: tr.getErrors()) {
                                            errMsgInsertion += 'Trial: ' + errTr.getMessage() + '\r\n';
                                        }
                                    }

                                    if (!resultsOppTrial.isSuccess()) {
                                        for (Database.Error errTrOpp: resultsOppTrial.getErrors()) {
                                            errMsgInsertion += 'Opportunity-Trial: ' + errTrOpp.getMessage() + '\r\n';
                                        }
                                    }

                                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Trial not initiated. ' + errMsgInsertion));

                                    checkError = true;
                                    System.debug('checkError:::: ' + checkError + 'ApexPages.hasMessages() : ' + ApexPages.hasMessages());
                                }
                            } catch (Exception e) {
                                Database.rollback(sp);
                                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, +e.getMessage()));
                            }

                        } else { // any value as null in First Name, Last Name, Email, SAP Contact Number than show the error message. 
                            //checkError = true;
                            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, Label.ODT_Required_fields_Null_on_Rep_journey));
                        }
                    }
                }
            } catch (exception e) {
                system.debug('Exception from line number 206' + e);
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, e.getMessage()));

            }
        }
    }

    //To query Account SSD records
    public void executeAcctSSD() {

        hasTrialRec = FALSE;
        hasAlreadyTrialInitiated = FALSE;
        try {
            contasTodisplay = new LIST < contactsWrapper > ();
            System.debug('AcctSSd...' + getSDDRecordId + 'oppIDSelected: ' + oppIDSelected);
            if (Schema.sObjectType.Source_System_Detail__c.isAccessible()&&Schema.sObjectType.Trial__c.fields.Source_System_Detail__c.isAccessible()&&Schema.sObjectType.Trial__c.fields.Trial_Source__c.isAccessible()&&Schema.sObjectType.Trial__c.fields.InvitedDateTime__c.isAccessible()&&Schema.sObjectType.Trial__c.fields.Trial_Start_Date__c.isAccessible()&&Schema.sObjectType.Trial__c.fields.Trial_Status__c.isAccessible()) {
                disAcc = [Select Id, Name, Account__c, Account_Name__c, Account_Name__r.name, Source_System_Account_Number__c, LCRM_Customer_Group__c, Trial_Status__c, BU_Segment_Level_2__c, (SELECT Source_System_Detail__c,Trial_Source__c,InvitedDateTime__c,Trial_Start_Date__c,Trial_Status__c from Trials__r ORDER by InvitedDateTime__c Desc LIMIT 1) From Source_System_Detail__c Where Account_Name__c =: accountID AND id =: getSDDRecordId];
                system.debug('disAcc' + disAcc);
            }
            //checking for 30 days Trial Expiry based on Trial Source and Invited Date
            if (disAcc.Trials__r != null) {
                String day = Label.ODT_Trial_Expiry_Days;
                Integer trialDiff;
                if (day.isNumeric()) {
                    trialDiff = integer.valueOf(day);
                }

                for (Trial__c tr: disAcc.Trials__r) {
                    Integer trialDifference;
                    if (tr.InvitedDateTime__c != null) {
                        trialDifference = tr.InvitedDateTime__c.Daysbetween(system.today());
                    }
                    system.debug('trialDifference' + trialDifference + 'trialDiff' + trialDiff);
                    if (tr.Trial_Source__c == Label.ODT_Trial_Source && trialDifference < trialDiff) {
                        If((String.isNotBlank(tr.Trial_Status__c) && (tr.Trial_Status__c.equalsIgnoreCase('Invited') || tr.Trial_Status__c.equalsIgnoreCase('Rep Initiated')))) {
                            system.debug('check3');
                            hasAlreadyTrialInitiated = TRUE;
                            break;
                        }
                        else if (String.isNotBlank(tr.Trial_Status__c) && tr.Trial_Status__c.equalsIgnoreCase('Accepted')) {
                            hasTrialRec = TRUE;
                            break;
                        }

                    }

                }
            }

            system.debug('hasAlreadyTrialInitiated: ' + hasAlreadyTrialInitiated + ' hasTrialRec: ' + hasTrialRec);

            //DLT-12958 : Methid call to check if the account is lapsed and if the reason code is valid
            Boolean isValidLapsedAccount = checkValidityofLapsedReason(disAcc.Source_System_Account_Number__c);
            system.debug('SSSSSSSSSS Lapsed Account    ' + isValidLapsedAccount);

            //Get the Active Trial details: below method returns true or false based on active trial availability    
            if (!hasAlreadyTrialInitiated && !hasTrialRec && isValidLapsedAccount == TRUE) {
                hasTrialRec = CallToOLCTofetchActiveTr.CallOLCForActiveTrials(disAcc.Source_System_Account_Number__c);

                if (!hasTrialRec && isValidLapsedAccount == TRUE) {

                    HTTPResponse res = CallToOLCTofetchActiveTr.showOnlineContacts(disAcc.Source_System_Account_Number__c);
                    if (res.getStatusCode() == 200) {
                        EsiResponseWrapper esiResp = (EsiResponseWrapper) JSON.deserialize(res.getBody(), EsiResponseWrapper.class);
                        System.debug('esiResp:.......' + esiResp);
                        if (esiresp.onlineContact != null) {
                            for (EsiResponseWrapper.onlineContact olcon: esiresp.onlineContact) {
                                // contasTodisplay
                                string fname;
                                string lname;
                                string apguid;
                                string email;
                                string sAPConId;
                                string sFDCconid = '';
                                string sAPAccid;
                                string sFDCaccid = accountID;
                                string OLCStatus;
                                string appid;
                                Boolean registeredWithOLC = FALSE;
                                Boolean isCobalt = FALSE;
                                Boolean isActive = FALSE;

                                try {
                                    if (olcon.entitlements != null) {
                                        for (EsiResponseWrapper.entitlements enti: olcon.entitlements) {
                                            //DLT-12962 : Start
                                            try {
                                                if (enti.registered != null && enti.status != null && enti.registered == true) {
                                                    if (enti.applicationId.equalsIgnoreCase('COBALT') && enti.status == 'ACTIVE') {
                                                        // if(enti.status.equalsIgnoreCase('ACTIVE'))
                                                        registeredWithOLC = TRUE;
                                                        apguid = enti.appUserGuid;
                                                        email = enti.authEmail;
                                                        appid = enti.applicationId;
                                                        OLCStatus = enti.status;
                                                        isCobalt = TRUE;
                                                        isActive = TRUE;
                                                    } else if (enti.applicationId.equalsIgnoreCase('COBALT') && enti.status == 'INACTIVE') {
                                                        registeredWithOLC = TRUE;
                                                        apguid = enti.appUserGuid;
                                                        email = enti.authEmail;
                                                        appid = enti.applicationId;
                                                        OLCStatus = enti.status;
                                                        isCobalt = TRUE;
                                                        isActive = FALSE;
                                                    } else if (isCobalt != TRUE && enti.status == 'ACTIVE' && !enti.applicationId.equalsIgnoreCase('COBALT')) {
                                                        registeredWithOLC = TRUE;
                                                        apguid = enti.appUserGuid;
                                                        email = enti.authEmail;
                                                        appid = enti.applicationId;
                                                        OLCStatus = enti.status;
                                                        isActive = TRUE;
                                                    } else if (isCobalt != TRUE && enti.status == 'INACTIVE' && isActive != TRUE) {
                                                        registeredWithOLC = TRUE;
                                                        apguid = enti.appUserGuid;
                                                        email = enti.authEmail;
                                                        appid = enti.applicationId;
                                                        OLCStatus = enti.status;
                                                        isActive = FALSE;
                                                    }

                                                }
                                            } catch (Exception e) {
                                                System.debug('Error' + e.getMessage());
                                            }
                                        }

                                        if (registeredWithOLC) {
                                            sAPConId = olcon.contactNumber;


                                            EsiResponseWrapper.address adrs = olcon.address;
                                            if (adrs != null) {
                                                fname = adrs.firstName;
                                                lname = adrs.lastName;
                                            }
                                            if (olcon.account != null) {
                                                sAPAccid = olcon.account.accountNumber;
                                            }

                                            //if(enti.registered == true){
                                            contasTodisplay.add(new contactsWrapper(fname, lname, apguid, email, sAPConId, sFDCconid, sAPAccid, sFDCaccid, OLCStatus, appid));
                                            System.debug('contasTodisplay' + contasTodisplay);
                                            //}
                                        }
                                        //DLT-12962 : END
                                    }
                                } catch (exception e) {
                                    system.debug('Exception While parsing OLC contact and skipping only that contact' + e);
                                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, +e.getMessage()));
                                }
                            }
                        }
                    }
                } else {
                    // Write the logic to show Error MSG as Trial already eligible*****ON VF page we are showing the error message 

                }
            }

        } catch (Exception e) {
            system.debug('Exception from line number 319' + e);
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, +e.getMessage()));
        }
    }
    // DLT-12958 - AB - Start
    public void refreshDomain() {
        String businessType;


        //DLT-12962: START
        String OLCStatus = apexpages.currentpage().getparameters().get('OLCStatus');
        String UserDomain = apexpages.currentpage().getparameters().get('UserDomain');

        system.debug('OLCStatus  ' + OLCStatus + 'UserDomain  ' + UserDomain);

        if (OLCStatus == 'Active') {
            isOLCActive = true;
            //isOLCActive1=true;
            System.debug('isOLCActive' + isOLCActive);
        }
        If(OLCStatus == 'Active' && UserDomain == 'COBALT') {
            userType = 'EXISTING_USER_SAME_DOMAIN';
        }
        else if ((OLCStatus == 'InActive' && UserDomain == 'COBALT') || (OLCStatus == 'Active' && UserDomain != 'COBALT')) {
            userType = 'EXISTING_USER_NEW_DOMAIN';
        } else {
            userType = 'NET_NEW';
        }
        //DLT-12962: END

        //Start : DLT-14600 : Dynamic Market Segment
        List < ODT_Market_Segments__mdt > marketSegmentList = new List < ODT_Market_Segments__mdt > ([SELECT Business_Type__c, Market_Segment__c FROM ODT_Market_Segments__mdt WHERE Market_Segment__c =: disAcc.BU_Segment_Level_2__c limit 1]);
        if (marketSegmentList.size() > 0) {
            for (ODT_Market_Segments__mdt mktSegment: marketSegmentList) {
                businessType = mktSegment.Business_Type__c;
                System.debug('businessType' + businessType);
            }
        }
        //END : DLT-14600

        /*if(disAcc.BU_Segment_Level_2__c == 'SLF 11-20' || disAcc.BU_Segment_Level_2__c == 'SLF 21-29' || disAcc.BU_Segment_Level_2__c == 'SLF 2-3' ||
           disAcc.BU_Segment_Level_2__c == 'SLF 4-6' || disAcc.BU_Segment_Level_2__c == 'SLF 7-10' || disAcc.BU_Segment_Level_2__c == 'Solo Law Firm'){
             System.debug('SLF Type');
            businessType='SLF';
        
        }
        /*else if(disAcc.BU_Segment_Level_2__c == 'Corporation National Accounts' || disAcc.BU_Segment_Level_2__c == 'Corp National Investigative' || disAcc.BU_Segment_Level_2__c == 'Corp Counsel' ||
                disAcc.BU_Segment_Level_2__c == 'Corp Investigative Financial' || disAcc.BU_Segment_Level_2__c == 'Corp Investigative' || disAcc.BU_Segment_Level_2__c == 'Corp Counsel Existing'){*/
        /*else if(disAcc.BU_Segment_Level_2__c.startsWith('Corp')){
                System.debug('Corp Type');
                 businessType='CORP';
        }*/

        if (businessType != null && userType != null) {
            selectDomain(businessType, userType);
        }
    }

    public void selectDomain(String businessType, String userType) {


        listPrdBundle = new List < ODT_Product_Bundle__c > ();
        if (Schema.sObjectType.ODT_Product_Bundle__c.isAccessible()) {
            listPrdBundle = [SELECT ID, Name, Bundle_ID__c, Bundle_Type__c, Business_Type__c, Company_Code__c, Product_Category__c, Campaign__c, Hive9_Media_Code__c, Profile_ID__c, SAP_Promotion_Code__c from ODT_Product_Bundle__c WHERE Is_Enabled_For_Sales_Rep_Trial__c = TRUE AND Is_Active__c = TRUE AND Bundle_Type__c = 'CTX'
                AND Business_Type__c INCLUDES(: businessType) AND Contacts_User_Type__c INCLUDES(: userType) ORDER BY Bundle_Order__c ASC
            ];
        }

        allCampaignslist = new List < SelectOption > ();
        allCampaignslist.add(new selectoption('', '--None--'));
        if (!listPrdBundle.isEmpty()) {
            for (ODT_Product_Bundle__c odtprods: listPrdBundle) {
                allCampaignslist.add(new selectoption(odtprods.Bundle_ID__c, odtprods.Name));
            }
        }
    }
    // DLT-12958 - AB - End


    //START : DLT-12958 : This method checks the validity of the Lapsed Reason Code on Account SSD
    public boolean checkValidityofLapsedReason(String ssdAccountNumber) {
        isValid = TRUE;

        CallToOLCTofetchActiveTr.LapsedAccountDetails lapsedAcc = CallToOLCTofetchActiveTr.checkLapsedAccountDetails(ssdAccountNumber);
        if (lapsedAcc != null && lapsedAcc.isLapsed == TRUE) {
            System.debug('@@@lapsedAcc' + lapsedAcc);
            List < ODT_Trial_Reason_Codes__mdt > reasonCodeList = new List < ODT_Trial_Reason_Codes__mdt > ([Select ODT_Reason_Code__c, ODT_Reason_Description__c, ODT_Reason_Validity__c FROM ODT_Trial_Reason_Codes__mdt WHERE ODT_Reason_Code__c =: lapsedAcc.reasonCode limit 1]);
            System.debug('------------reasonCode' + reasonCodeList);
            if (reasonCodeList.size() > 0) {
                for (ODT_Trial_Reason_Codes__mdt reasonCode: reasonCodeList) {
                    if (reasonCode.ODT_Reason_Validity__c == TRUE) {

                        isValid = FALSE;
                        lapsedReasonCode = reasonCode.ODT_Reason_Code__c;
                        lapsedReasonCodeDesc = reasonCode.ODT_Reason_Description__c;
                        isLapsedAccount = lapsedAcc.isLapsed;
                        invalidReasonMsg = 'This SAP account is not eligible for trials. Lapsed Code: ' + lapsedReasonCode + ' Message: ' + lapsedReasonCodeDesc;
                    }
                }
            } else {
                isValid = TRUE;
                lapsedReasonCode = lapsedAcc.reasonCode;
                lapsedReasonCodeDesc = lapsedAcc.reasonDesc;
                isLapsedAccount = lapsedAcc.isLapsed;
            }
        } else {
            isLapsedAccount = FALSE;
        }

        return isValid;
    }
    //END : DLT-12958


    public PageReference closeEloquaPopup() {
        PageReference myVFPage = new PageReference('/' + accountID);
        myVFPage.setRedirect(true);
        return myVFPage;
    }


    public class contactsWrapper {
        public string firstName {
            get;
            set;
        }
        public string lastName {
            get;
            set;
        }
        public string appGUID {
            get;
            set;
        }
        public string EmailId {
            get;
            set;
        }
        public string SAPContactId {
            get;
            set;
        }
        public string SFDCContactId {
            get;
            set;
        }
        public string SAPAccountId {
            get;
            set;
        }
        public string SFDCAccountId {
            get;
            set;
        }
        //DLT-12958
        public string OLCStatus {
            get;
            set;
        }
        public LCRM_Contact_SSD__c contactSSD {
            get;
            set;
        }
        public string userDomain {
            get;
            set;
        } //DLT-12962

        public contactsWrapper(string fname, string lname, string apguid, string email, string sAPConId, string sFDCconid, string sAPAccid, string sFDCaccid, string uStatus, string uDomain) {
            firstName = fname;
            lastName = lname;
            appGUID = apguid;
            EmailId = email;
            SAPContactId = sAPConId;
            SFDCContactId = sFDCconid;
            SAPAccountId = sAPAccid;
            SFDCAccountId = sFDCaccid;
            OLCStatus = uStatus;
            userDomain = uDomain;
        }
    }

    public PageReference newCustomerRedirect() {
        String pfParams = 'Id=' + oppIDSelected;
        PageReference pf = new PageReference('/apex/ODTStartNCJ?' + pfParams);
        System.debug('PageRef: ' + pf);

        pf.setRedirect(true);
        return pf;
    }

}