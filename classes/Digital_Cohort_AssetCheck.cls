/***************************************************************************************************
 CLASS NAME  : Digital_Cohort_AssetCheck
 DESCRIPTION : Checks Valid Data on Asset records present at SSD Object
 ====================================================================================================
 CUSTOM MESSAGES ADDED
 ====================================================================================================
 S.NO      OBJECT                                      MESSAGE
 1       AssetLineItem&SourceSystemDetail            SSD-APTS Band Number is lesser than Asset-Quantity
 2       AssetLineItem                               AssetLineItem has No Renewal Date
 3       AssetLineItem                               AssetLineItem has Renewal Date Lesser Than Today
 4       AssetLineItem                               AssetLineItem has Renewal Date greater than 450 days
 5       AssetLineItem                               AssetLineItem is Accepted on Quote
 6       AssetLineItem&DigitalSubscription           Renewal Date Mismatch between Asset and DS Data
 7       AssetLineItem                               Asset Line Item Status is Cancelled
 8       AssetLineItem                               Asset Line Item Status is Different
 9       SourceSystemDetail                          SSD has more than 30 Active assets
 10      SourceSystemDetail                          SSD has no Active assets
 11      AssetLineItem                               AssetLineItem is Inactive for Non-Straight Offer
 12      AssetLineItem                               SSD Has no Active FL Assets
 ====================================================================================================
 CHANGE HISTORY
 ====================================================================================================
 DATE            NAME                    DESCRIPTION
 31-05-2020      Rahul Natarajan         Created For CXD Project
 07-10-2020      Rahul Natarajan         DLT-20728 - Updated to track Fatal errors during Automation
                                         Updated for PMD violations
 ====================================================================================================
 ***************************************************************************************************/
public class Digital_Cohort_AssetCheck implements Database.Batchable < Digital_Customer__c > , Database.Stateful {
    Digital_Settings__c ds;
    Integer activeAsset;
    String sfdcBaseUrl;
    List < Digital_Message__c > dmList;
    List < Digital_Customer__c > dcsList;
    List < Digital_Cohort_Messages__mdt > dcmlist;
    Source_System_Detail__c ssd;
    List < Apttus_Config2__AssetLineItem__c > ssdAssetList;
    List < Product_Account_Detail__c > dsDataList;
    List < String > findlawAssetNames;
    public Digital_Cohort_AssetCheck(Digital_Settings__c digitalSettings) {
        this.Ds = digitalSettings;
        findlawAssetNames = new List < String > ();
        sfdcBaseUrl = URL.getSalesforceBaseUrl().toExternalForm();
        dmList = new List < Digital_Message__c > ();
        dcmlist = [SELECT Class__c, Label, Message__c, Object__c, Fatal_Error__c, Severity_Level__c
            FROM Digital_Cohort_Messages__mdt
            WHERE Class__c = 'Digital_Cohort_AssetCheck'
            ORDER BY Label ASC
            NULLS LAST
        ];
    }

	// Start method - select customers to process
    public Iterable < Digital_Customer__c > start(Database.BatchableContext bc) {
        ds.Class__c = 'Digital_Cohort_AssetCheck';
        ds.Completion__c = 60;
        update ds;
        dcsList = [Select Id, Cohort_Execution__c, Customer_SSD__c, Digital_Settings__c, Has_Account__c, Has_Assets__c, Has_Contact__c, Has_DSdata__c, Has_Opportunity__c, Has_Quotes__c, Has_SSD__c, SAP_Number__c
            from Digital_Customer__c
            where Digital_Settings__c =: ds.Id AND Cohort_Execution__c = false AND Has_SSD__c = true AND Has_DSdata__c = true AND Has_Assets__c = true
        ];
        if (dcsList.isEmpty()) {
            ds.Completion__c = 100;
            ds.Job_Status__c = dcmlist[0].Message__c;
            ds.End_Time__c = DateTime.now();
            update ds;
        }
        return dcsList;
    }

	// Execute method - check Asset information
    public void execute(Database.BatchableContext bc, List < Digital_Customer__c > dcsList) {
        try {
            for (Digital_Customer__c dcs: dcsList) {
                activeAsset = 0;
                checkAsset(dcs);
                if (activeAsset > 30) {
                    // dmList.add(new Digital_Message__c(Name = dcmlist[10].Object__c, Digital_Customer__c = dcs.Id, Digital_Settings__c = ds.Id, Message__c = dcmlist[10].Message__c, URL_1__c = sfdcBaseUrl + '/' + ssd.Id));
                    dmList.add(createMessage(10, dcs.Id, String.valueof(ssd.Id)));
                } else if (activeAsset == 0) {
                    //  dmList.add(new Digital_Message__c(Name = dcmlist[11].Object__c, Digital_Customer__c = dcs.Id, Digital_Settings__c = ds.Id, Message__c = dcmlist[11].Message__c, URL_1__c = sfdcBaseUrl + '/' + ssd.Id));
                    dmList.add(createMessage(11, dcs.Id, String.valueof(ssd.Id)));
                }
                if ((ds.Segment__c == 'FindLaw') && (findlawAssetNames.isEmpty())) {
                    // dmList.add(new Digital_Message__c(Name = dcmlist[12].Object__c, Digital_Customer__c = dcs.Id, Digital_Settings__c = ds.Id, Message__c = dcmlist[12].Message__c, URL_1__c = sfdcBaseUrl + '/' + ssd.Id));
                    dmList.add(createMessage(12, dcs.Id, String.valueof(ssd.Id)));
                }
            }
        } catch (Exception e) {
            Digital_Exception_Log__c ex = new Digital_Exception_Log__c();
            ex.Exception_Message__c = e.getMessage();
            ex.Exception_Type__c = e.getStackTraceString();
            ex.Additional_Information__c = String.valueof(e.getLineNumber());
            ex.User_Message__c = String.valueof(e.getCause());
            ex.Class_Reference__c = 'Digital_Cohort_AssetCheck > Execute';
            insert ex;
        }
    }
    
    // Select SSD account and Assets for this customer
    public void checkAsset(Digital_Customer__c dcs) {
        ssd = [Select Id, LCRM_APTS_Band_Number__c, LCRM_Email__c, Source_System_Account_Number__c, BU_Segment_Level_2__c, Digital_Firm__c
            FROM Source_System_Detail__c
            WHERE Id =: dcs.Customer_SSD__c
            LIMIT 1
        ][0];
        ssdAssetList = [SELECT Id, Name, APTS_Contract_Number__c, APTS_SSD_Sold_To__c, Apttus_Config2__Quantity__c, Apttus_Config2__AssetStatus__c, APTS_Subscription_Number__c, APTS_Material_Number__c, APTS_Info_RenewalDate__c, Apttus_QPConfig__ProposalId__c, Apttus_QPConfig__ProposalId__r.Apttus_Proposal__Approval_Stage__c, Apttus_Config2__IsInactive__c, Apttus_QPConfig__ProposalId__r.Name
            from Apttus_Config2__AssetLineItem__c
            where APTS_SSD_Sold_To__c =: ssd.Id
        ];
        // select records fro pre-cohort run
        if (ds.Data_Status__c == 'Pre-CohortsJob') {
            dsDataList = [SELECT Id, AccountSSD__c, DC_Contract_Number__c, ZP_Cust_Number__c, Current_Subscription__c, Renewal_Date__c, Quantity__c, Actual_New_Service__c, Actual_New_Subscription__c, Premium_New_Service__c, Premium_New_Subscription__c, Type__c, Digital_Firm__c
                FROM Product_Account_Detail__c
                WHERE ZP_Cust_Number__c =: dcs.SAP_Number__c AND Renewal_Date__c > Today AND Current_Subscription__c != null AND Digital_Firm__c =: ds.Segment__c AND Bypass_Automation__c = FALSE
            ];
        } else {
            dsDataList = [SELECT Id, AccountSSD__c, DC_Contract_Number__c, ZP_Cust_Number__c, Current_Subscription__c, Renewal_Date__c, Quantity__c, Actual_New_Service__c, Actual_New_Subscription__c, Premium_New_Service__c, Premium_New_Subscription__c, Type__c, Digital_Firm__c
                FROM Product_Account_Detail__c
                WHERE ZP_Cust_Number__c =: dcs.SAP_Number__c AND Renewal_Date__c > Today AND Current_Subscription__c != null AND Digital_Firm__c =: ds.Segment__c
            ];
        }
        for (Apttus_Config2__AssetLineItem__c ssdAsset: ssdAssetList) {
            for (Product_Account_Detail__c dsData: dsDataList) {
                // Checks Asset with Subscription Number matching DS Data Current Subscription Number
                if ((ssdAsset.APTS_Subscription_Number__c == dsData.Current_Subscription__c) && (ds.Segment__c != 'FindLaw')) {
                    loopCheck(ssdAsset, dsData, dcs);
                } else if ((ssdAsset.APTS_Contract_Number__c == dsData.DC_Contract_Number__c) && (ds.Segment__c == 'FindLaw')) {
                    loopCheck(ssdAsset, dsData, dcs);
                    // check Asset name
                    checkAssetName(ssdAsset);
                }
            }
        }  // end of for loop
    }
    
    // validate the asset status
	public void checkAssetName(Apttus_Config2__AssetLineItem__c ssdAsset) {
        
        if (ssdAsset.Apttus_Config2__AssetStatus__c == 'Activated') {
            String fLAssetName = ssdAsset.Name;
            if (fLAssetName.contains('FINDLAW') || fLAssetName.contains('SUPER LAWYERS') || fLAssetName.contains('LAWINFO') || fLAssetName.contains('ABOGADO')) {
                findlawAssetNames.add(fLAssetName);
            }
        }
	}
	
	// check additional asset information
    public void loopCheck(Apttus_Config2__AssetLineItem__c ssdAsset, Product_Account_Detail__c dsData, Digital_Customer__c dcs) {

        // check detail
        loopCheckDetail(ssdAsset, dsData, dcs);

        if ((ssdAsset.APTS_Info_RenewalDate__c != dsData.Renewal_Date__c) && (ssdAsset.APTS_Info_RenewalDate__c != null)) {
            //dmList.add(new Digital_Message__c(Name = dcmlist[7].Object__c, Digital_Customer__c = dcs.Id, Digital_Settings__c = ds.Id, Message__c = dcmlist[7].Message__c + ssdAsset.APTS_Material_Number__c, URL_1__c = sfdcBaseUrl + '/' + ssdAsset.Id, URL_2__c = sfdcBaseUrl + '/' + dsData.Id));
            dmList.add(createMessage(7, dcs.Id, String.valueof(dsData.Id)));
        }
        if (ssdAsset.Apttus_Config2__AssetStatus__c == 'Cancelled') {
            // dmList.add(new Digital_Message__c(Name = dcmlist[8].Object__c, Digital_Customer__c = dcs.Id, Digital_Settings__c = ds.Id, Message__c = dcmlist[8].Message__c + ssdAsset.APTS_Material_Number__c, URL_1__c = sfdcBaseUrl + '/' + ssdAsset.Id));
            dmList.add(createMessage(8, dcs.Id, String.valueof(ssdAsset.Id)));
        } else if (ssdAsset.Apttus_Config2__AssetStatus__c == 'Activated') {
            activeAsset++;
        } else {
            // dmList.add(new Digital_Message__c(Name = dcmlist[9].Object__c, Digital_Customer__c = dcs.Id, Digital_Settings__c = ds.Id, Message__c = dcmlist[9].Message__c + ssdAsset.APTS_Material_Number__c, URL_1__c = sfdcBaseUrl + '/' + ssdAsset.Id));
            dmList.add(createMessage(9, dcs.Id, String.valueof(ssdAsset.Id)));
        }
    }
    
    // Validate Asset information
    public void loopCheckDetail(Apttus_Config2__AssetLineItem__c ssdAsset, Product_Account_Detail__c dsData, Digital_Customer__c dcs) {
        if (ssd.LCRM_APTS_Band_Number__c < ssdAsset.Apttus_Config2__Quantity__c) {
            // dmList.add(new Digital_Message__c(Name = dcmlist[1].Object__c, Digital_Customer__c = dcs.Id, Digital_Settings__c = ds.Id, Message__c = dcmlist[1].Message__c + ssdAsset.APTS_Material_Number__c, URL_1__c = sfdcBaseUrl + '/' + ssdAsset.Id, URL_2__c = sfdcBaseUrl + '/' + ssd.Id));
            dmList.add(createMessage(1, dcs.Id, String.valueof(ssdAsset.Id)));
        }
        if (ssdAsset.Apttus_Config2__IsInactive__c == true && dsData.Type__c != 'Straight') {
            // dmList.add(new Digital_Message__c(Name = dcmlist[2].Object__c, Digital_Customer__c = dcs.Id, Digital_Settings__c = ds.Id, Message__c = dcmlist[2].Message__c, URL_1__c = sfdcBaseUrl + '/' + ssdAsset.Id, URL_2__c = sfdcBaseUrl + '/' + dsData.Id));
            dmList.add(createMessage(2, dcs.Id, String.valueof(ssdAsset.Id)));
        }
        if (ssdAsset.APTS_Info_RenewalDate__c == null) {
            // dmList.add(new Digital_Message__c(Name = dcmlist[3].Object__c, Digital_Customer__c = dcs.Id, Digital_Settings__c = ds.Id, Message__c = dcmlist[3].Message__c + ssdAsset.APTS_Material_Number__c, URL_1__c = sfdcBaseUrl + '/' + ssdAsset.Id));
            dmList.add(createMessage(3, dcs.Id, String.valueof(ssdAsset.Id)));
        } else if (ssdAsset.APTS_Info_RenewalDate__c < System.today()) {
            // dmList.add(new Digital_Message__c(Name = dcmlist[4].Object__c, Digital_Customer__c = dcs.Id, Digital_Settings__c = ds.Id, Message__c = dcmlist[4].Message__c + ssdAsset.APTS_Material_Number__c, URL_1__c = sfdcBaseUrl + '/' + ssdAsset.Id));
            dmList.add(createMessage(4, dcs.Id, String.valueof(ssdAsset.Id)));
        } else if (ssdAsset.APTS_Info_RenewalDate__c > (System.today().adddays(449))) {
            // dmList.add(new Digital_Message__c(Name = dcmlist[5].Object__c, Digital_Customer__c = dcs.Id, Digital_Settings__c = ds.Id, Message__c = dcmlist[5].Message__c + ssdAsset.APTS_Material_Number__c, URL_1__c = sfdcBaseUrl + '/' + ssdAsset.Id));
            dmList.add(createMessage(5, dcs.Id, String.valueof(ssdAsset.Id)));
            if (ssdAsset.Apttus_QPConfig__ProposalId__c != null && ssdAsset.Apttus_QPConfig__ProposalId__r.Apttus_Proposal__Approval_Stage__c == 'Accepted') {
                // dmList.add(new Digital_Message__c(Name = dcmlist[6].Object__c, Digital_Customer__c = dcs.Id, Digital_Settings__c = ds.Id, Message__c = dcmlist[6].Message__c + ssdAsset.APTS_Material_Number__c, URL_1__c = sfdcBaseUrl + '/' + ssdAsset.Id, URL_2__c = sfdcBaseUrl + '/' + ssdAsset.Apttus_QPConfig__ProposalId__c));
                dmList.add(createMessage(6, dcs.Id, String.valueof(ssdAsset.Id)));
            }
        }
    }

    // Create the digital message with error content
    public Digital_Message__c createMessage(integer msgNumber, id custId, string urlString) {
        Digital_Message__c valMessage = new Digital_Message__c();
        valMessage.Name = dcmlist[msgNumber].Object__c;
        valMessage.Digital_Customer__c = custId;
        valMessage.Digital_Settings__c = ds.Id;
        valMessage.Message__c = dcmlist[msgNumber].Message__c;
        valMessage.Fatal_Error__c = dcmlist[msgNumber].Fatal_Error__c;
        valMessage.Severity_Level__c = dcmlist[msgNumber].Severity_Level__c;
        if (urlString != '') {
            valMessage.URL_1__c = sfdcBaseUrl + '/' + urlString;
        }
        return valMessage;
    }
    
	// finish method to start next validation job
    public void finish(Database.BatchableContext bc) {
        if (ds.Completion__c != 100) {
            if (!dmList.isEmpty()) {
                insert dmList;
            }
            ds.Batch_Id__c = String.valueof(Database.executeBatch(new Digital_Cohort_AccConCheck(ds), Integer.valueOf(ds.Batch_Size__c)));
            update ds;
        } else {
            Digital_Cohort_CompletionTasks dc = new Digital_Cohort_CompletionTasks();
            dc.sendcompletionemail(ds.Id);
        }
    }
}