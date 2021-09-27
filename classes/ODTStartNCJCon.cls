/*============================================================================================
    Name                : ODTStartNCJCon   
    Description         : This class is developed as part of CXD-ODT project and FOr New Customer Trial Journey
    Created Date        : 2/15/2018 
    Author              : TCS CXD ODT team
    Modification History: Modified by Mallik for showing all contacts which are available  OLC
                          Optimizing the code by Harshitha,Ameeta Antonio

    DATE            DEVELOPER       CHANGE HISTORY
    05-23-2020      Rahul           DLT-19957 :  [SFDC] Add ODT product Detail on ODT Number of days trial Extended
    10-01-2020      Rahul           DLT-20756 :  [SFDC] [ODT] Critical and Blocker Code scan issue
    12-01-2020      Brenda Shields  DLT-21339 :  [SFDC] [ODT][PMD SCAN] Critical Components Code scan issue
==============================================================================================*/
public without sharing class ODTStartNCJCon {
    public Opportunity opp {
        get;
        set;
    }
    public Source_System_Detail__c ssd {
        get;
        set;
    }
    public Boolean hasSSD {
        get;
        set;
    }
    public Boolean isValidSSD {
        get;
        set;
    }

    public Boolean isTrialsExists {
        get;
        set;
    }

    public ODTWrapperClass.ODTStartNCJConWrapper wrapper {
        get;
        set;
    }

    //public class ODTStartNCJConWrapper {
    //	string selMarketSegment {get;set;}
    // 	string selProductBundle {get;set;}
    //	list < SelectOption > marketSegments {get;set;}
    //	list < SelectOption > productBundleList {get;set;}
    //	Invite_Colleagues__c invColleague {get;set;}
    //}

    private Trial__c trial {
        get;
        set;
    }
    private Opportunity_Trial__c oppTrialJun {
        get;
        set;
    }
    private map < id, ODT_Product_Bundle__c > pbMap {
        get;
        set;
    }
    private map < string, ODT_Market_Segments__mdt > marketSegmentIDMap {
        get;
        set;
    }
    public string selectedMS {
        get;
        set;
    } 
    //public string selMarketSegment {
    //    get;
    //    set;
    //}
    //public string selProductBundle {
    //    get;
    //    set;
    //}
    //private boolean showINCDetails {get;set;}

    public ODTStartNCJCon(ApexPages.StandardController controller) {
        constructorMethods();
    }

    public void constructorMethods() {
        string ssdId;
        string oppId;
        wrapper = new ODTWrapperClass.ODTStartNCJConWrapper();
        //wrapper.selMarketSegment = selMarketSegment;
        //wrapper.selProductBundle = selProductBundle;
        oppId = ApexPages.currentPage().getparameters().get('id').escapeHtml4();
        isValidSSD = true;
        //showINCDetails = false;
        isTrialsExists = false;
        wrapper.productBundleList = new LIST < SelectOption > ();
        wrapper.marketSegments = new List < SelectOption > ();
        trial = new Trial__c();
        oppTrialJun = new Opportunity_Trial__c();
        wrapper.invColleague = new Invite_Colleagues__c();
        ssd = new Source_System_Detail__c();

        if (!String.isBlank(oppId)) {
            //DLT-20756 - PMD Fix
            if (Schema.sObjectType.Opportunity.isAccessible()) {
                opp = [SELECT Id, name, Source_System_Detail__c, AccountId, StageName
                    FROM Opportunity WHERE Id =: oppId
                ];
            }
            list < Opportunity_Trial__c > trialsrecords = queryTrialContents(oppId);
            if (!trialsrecords.isEmpty()) {
                isTrialsExists = TRUE;
            }
        }
        // get account/ssd id's
        //accId = opp.AccountId;   
        ssdId = opp.Source_System_Detail__c;

        // check if Opp has SSD else create new
        hasSSD = (String.isEmpty(ssdId) ? false : true);
        map < string, ODT_Market_Segments__mdt > marketSegmentMap = new map < string, ODT_Market_Segments__mdt > ();
        marketSegmentIDMap = new MAP < string, ODT_Market_Segments__mdt > ();
        for (ODT_Market_Segments__mdt ms: ODT_TrialInitiationHelper.getMarketSegmentsList()) {
            marketSegmentMap.put(ms.Market_Segment__c, ms);
            marketSegmentIDMap.put(ms.id, ms);
        }
        //DLT-20756 - PMD Fix
        if (hasSSD && Schema.sObjectType.Source_System_Detail__c.isAccessible()) {
            ssd = [SELECT Id, Country__c, LCRM_Phone__c, BU_Segment_Level_2__c, Name
                FROM Source_System_Detail__c WHERE Id =: ssdId LIMIT 1
            ];

            if (!marketSegmentMap.containskey(ssd.BU_Segment_Level_2__c) || string.isBlank(ssd.BU_Segment_Level_2__c)) {
                isValidSSD = FALSE;
            } else {
                ODT_Market_Segments__mdt marketSeg = new ODT_Market_Segments__mdt();
                marketSeg = marketSegmentMap.get(ssd.BU_Segment_Level_2__c);
                fetchProducts(marketSeg.Business_Type__c);
            }
        }
        wrapper.marketSegments = new list < SelectOption > ();
        wrapper.marketSegments.add(new SelectOption('', 'Select Market Segment'));
        for (ODT_Market_Segments__mdt ms: marketSegmentMap.values()) {
            wrapper.marketSegments.add(new SelectOption(ms.id, ms.Market_Segment__c));
        }
    }

    // get product information
    public void refreshINCProducts() {
        //showINCDetails = true;
        if (string.isNotBlank(apexpages.currentpage().getparameters().get('selval').escapeHtml4())) {
            ODT_Market_Segments__mdt marketSegment = new ODT_Market_Segments__mdt();
            if (marketSegmentIDMap.containsKey(apexpages.currentpage().getparameters().get('selval').escapeHtml4())) {
                marketSegment = marketSegmentIDMap.get(apexpages.currentpage().getparameters().get('selval').escapeHtml4());
                fetchProducts(marketSegment.Business_Type__c);
                selectedMS = marketSegment.Market_Segment__c;
            }
        }
    }

    // query for product bundle information
    public void fetchProducts(string marketSeg) {
        pbMap = new MAP < id, ODT_Product_Bundle__c > ([SELECT Id, Name, Bundle_ID__c, Trial_Expiry_Days__c,
            Bundle_Order__c, Bundle_Type__c, Business_Type__c, Contacts_User_Type__c, Product_Category__c
            FROM ODT_Product_Bundle__c WHERE Is_Active__c =: TRUE AND Is_Enabled_For_Sales_Rep_Trial__c =: TRUE AND Contacts_User_Type__c = 'NET_NEW'
            AND Business_Type__c =: marketSeg
            ORDER BY Bundle_Order__c DESC
        ]);
        wrapper.productBundleList = new LIST < SelectOption > ();
        wrapper.productBundleList.add(new SelectOption('', 'Please select trial content'));
        for (ODT_Product_Bundle__c pb: pbMap.values()) {
            wrapper.productBundleList.add(new SelectOption(pb.Id, pb.Name));
        }
        system.debug(LoggingLevel.INFO, 'Product Bundle List: ' + pbMap);
        system.debug(LoggingLevel.INFO, 'Product Bundle List wrapper: ' + wrapper.productBundleList);
    }

    // finish process by updating/creating trial information
    public PageReference finish() {
        system.debug(LoggingLevel.INFO, 'Sel Value....' + string.isNotBlank(wrapper.selProductBundle) + '     ' + wrapper.selProductBundle);
        system.debug(LoggingLevel.INFO, 'Sel Value....' + (wrapper.selProductBundle != '') + '     ' + wrapper.selProductBundle);
        if (SSD.Country__c == 'other') {
            SSD.Country__c.addError('Please select valid value for Country');
        }
        if (string.isNotBlank(wrapper.selProductBundle) && wrapper.selProductBundle != '') {
        //if (string.isNotBlank(selProductBundle)&&selProductBundle != '') {
            Date tD = date.today();
            String todaydate = DateTime.newInstance(tD.year(), tD.month(), tD.day()).format('YYYY-MM-dd');
            wrapper.invColleague.Trial_Status__c = 'Rep Initiated';
            ODT_Product_Bundle__c odtProductBundle = new ODT_Product_Bundle__c();
            if (pbMap.containsKey(wrapper.selProductBundle)) {
                odtProductBundle = pbMap.get(wrapper.selProductBundle);
                // update trial record and insert associated records
                updateTrial(odtProductBundle);
            }
            PageReference pref = new ApexPages.StandardController(this.trial).view();
            pref.setRedirect(true);
            return pref;
        } else {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, system.Label.ODT_Select_Contact));
            return null;
        }
    }

    // query for trial records
    private list < Opportunity_Trial__c > queryTrialContents(string oppId) {
        list < Opportunity_Trial__c > trialRecords = new list < Opportunity_Trial__c > ();
        if (Schema.sObjectType.Opportunity_Trial__c.isAccessible()) {
            trialRecords = [Select ID, Trial__r.Trial_Status__c From Opportunity_Trial__c
                WHERE Opportunity__c =: oppId AND Trial__r.Trial_Status__c != 'Bounceback'
            ];
        }
        return trialRecords;
    }

    // get sales org information
    public list < SelectOption > getSalesOrgs() {
        list < SelectOption > selOptList = new list < SelectOption > ();
        selOptList.add(new SelectOption('WEST', 'WEST'));
        return selOptList;
    }

    // get option values
    public list < SelectOption > getListVal() {
        list < SelectOption > listValues = new list < SelectOption > ();
        listValues.add(new SelectOption('', '--None--'));
        listValues.add(new SelectOption('US', 'US'));
        return listValues;
    }

    // update the trial record and insert the associated records
    private void updateTrial(ODT_Product_Bundle__c odtProductBundle) {
        Date tD = date.today();
        string todaydate = DateTime.newInstance(tD.year(), tD.month(), tD.day()).format('YYYY-MM-dd');

        // set trial details
        trial.ODT_Trial_Product_Category__c = odtProductBundle.Product_Category__c;
        trial.Trial_Id__c = odtProductBundle.Bundle_ID__c;
        trial.Trial_products__c = odtProductBundle.Name;
        if ((Integer.valueof(odtProductBundle.Trial_Expiry_Days__c)) != null) {
            trial.ODT_Number_Of_Days_Trial_Extended__c = Integer.valueof(odtProductBundle.Trial_Expiry_Days__c); // Added as part of DLT-19957
        }
        trial.Trial_Status__c = 'Rep Initiated';
        trial.Trial_Source__c = 'SFDC';
        trial.InvitedDateTime__c = System.today();
        trial.Profile_Type__c = 'NET_NEW';
        trial.ODT_Email__c = wrapper.invColleague.Email__c;
        trial.Unique_Identifier__c = todaydate + '|' + trial.ODT_Email__c;

        // insert records and map trial fields
        insertTrial(odtProductBundle);

        if (!Test.isRunningTest()) {
            // make eloqua call if trial create is successful        
            ContactsListConCallout updJob = new ContactsListConCallout(wrapper.invColleague.First_Name__c, wrapper.invColleague.Last_Name__c, wrapper.invColleague.Email__c, '', '', '' /*SFDC AccountID*/ , '' /*SFDC Contact Id*/ , '', trial.Trial_Id__c, '', opp.Id, trial.id, ssd.name, Label.ODT_Rep_Initiated_URL, 'Invite', 'SFDC', null, null, null, false, null, false, null);
            ID jobID = System.enqueueJob(updJob);
            system.debug(LoggingLevel.INFO, '@@@JobId.....: ' + jobID);
        }
    }

    // insert trial and associated records
    private void insertTrial(ODT_Product_Bundle__c odtProductBundle) {
        System.Savepoint sp = Database.setSavepoint();
        try {
            // DLT-20756 - Fixed PMD Crud Violation
            if (string.isNotBlank(wrapper.selMarketSegment) && Schema.sObjectType.Source_System_Detail__c.isCreateable() && Schema.sObjectType.opportunity.isUpdateable()) {
                ssd.BU_Segment_Level_2__c = selectedMS;
                ssd.Source_System_Name__c = ssd.Name;
                insert ssd;
                opportunity op = new opportunity(id = opp.Id, Source_System_Detail__c = ssd.id);
                update op;
            }
            //DLT-20756 - PMD Fix
            if (Schema.sObjectType.Opportunity_Trial__c.isCreateable() && Schema.sObjectType.Invite_Colleagues__c.isCreateable() && Schema.sObjectType.Trial__c.isCreateable()) {
                // map trial lookups
                trial.Source_System_Detail__c = ssd.Id;
                trial.ODT_Product_Bundle__c = odtProductBundle.Id;
                insert trial;
                wrapper.invColleague.Primary_User__c = True;
                wrapper.invColleague.Trial__c = trial.Id;
                insert wrapper.invColleague;
                //Creation of Opportunity Trial Juction Record            
                oppTrialJun.Opportunity__c = opp.Id;
                oppTrialJun.Trial__c = trial.Id;
                insert oppTrialJun;
            }
        } catch (DmlException e) {
            system.debug(LoggingLevel.ERROR, 'ERROR: ' + e.getMessage());
            Database.rollback(sp);
        }
    }
}