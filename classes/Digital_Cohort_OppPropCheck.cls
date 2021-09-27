/***************************************************************************************************
 CLASS NAME  : Digital_Cohort_OppPropCheck
 DESCRIPTION : Checks Valid Data on Opportunity and Proposal records present at SSD Object
 ====================================================================================================
 CUSTOM MESSAGES ADDED
 ====================================================================================================
 S.NO      OBJECT                          MESSAGE
 1         Opportunity                     Opportunity has no Amount value on it
 2         Opportunity                     Opportunity has no Offer Link on it
 3         Quote                           Quote has no Amount on it
 4         Quote                           Quote is Stuck at Stage
 5         Quote                           Quote Failue Reason
 6         Quote                           Quote OC Validation Message
 7         Quote                           Quote has no Order Confirmation Contact
 8         Quote                           Quote has no Docusign Envelope Id
 9         Quote                           Quote has no Order Confirmation Email on it
 10        Quote                           Approval Queue Details Added
 ====================================================================================================
 CHANGE HISTORY
 ====================================================================================================
 DATE            NAME                    DESCRIPTION
 31-05-2020      Rahul Natarajan         Created For CXD Project
 07-10-2020      Rahul Natarajan         DLT-20728 - Updated to track Fatal errors during Automation
                                         Updated for PMD violations
 ====================================================================================================
 ***************************************************************************************************/
public class Digital_Cohort_OppPropCheck implements Database.Batchable < Digital_Customer__c > , Database.Stateful {
    Digital_Settings__c ds;
    String sfdcBaseUrl;
    List < Digital_Customer__c > dcList;
    List < Digital_Message__c > dmList;
    List < Digital_Cohort_Messages__mdt > dcmlist;
    List < Opportunity > oppList;
    public Digital_Cohort_OppPropCheck(Digital_Settings__c digitalSettings) {
        this.ds = digitalSettings;
        sfdcBaseUrl = URL.getSalesforceBaseUrl().toExternalForm();
        dcList = new List < Digital_Customer__c > ();
        dmList = new List < Digital_Message__c > ();
        dcmlist = [SELECT Class__c, Label, Message__c, Object__c, Fatal_Error__c, Severity_Level__c
            FROM Digital_Cohort_Messages__mdt
            WHERE Class__c = 'Digital_Cohort_OppPropCheck'
            ORDER BY Label ASC
            NULLS LAST
        ];
    }
    
	// Start method - Select all digital customers to be processed
    public Iterable < Digital_Customer__c > start(Database.BatchableContext bc) {
        ds.Class__c = 'Digital_Cohort_OppPropCheck';
        ds.Completion__c = 90;
        update ds;
        dcList = [Select Id, Cohort_Execution__c, Customer_SSD__r.Digital_Firm__c, Customer_SSD__r.Source_System_Account_Number__c, Customer_SSD__c, Customer_SSD__r.BU_Segment_Level_2__c, Customer_SSD__r.Account_Name__c, Digital_Settings__c, Has_Account__c, Has_Assets__c, Has_Contact__c, Has_DSdata__c, Has_Opportunity__c, Has_Quotes__c, Has_SSD__c, SAP_Number__c
            from Digital_Customer__c
            where Digital_Settings__c =: ds.Id AND Cohort_Execution__c = false AND Has_SSD__c = true AND Has_DSdata__c = true AND Has_Assets__c = true AND Has_Account__c = true AND Has_Opportunity__c = true
        ];
        if (ds.Data_Status__c != 'Pre-CohortsJob') {
            if (dcList.isEmpty()) {
                ds.Completion__c = 100;
                ds.Job_Status__c = 'Digital Customers has no Opportunities on it';
                ds.End_Time__c = DateTime.now();
                update ds;
            }
        }
        return dcList;
    }
    
	// Execute method - Process a batch of customer records
    public void execute(Database.BatchableContext bc, List < Digital_Customer__c > dcsList) {
        try {
            if (!dcsList.isEmpty()) {
                for (Digital_Customer__c dcs: dcsList) {
                    getOppData(dcs);
                }
            }
        } catch (Exception e) {
            Digital_Exception_Log__c ex = new Digital_Exception_Log__c();
            ex.Exception_Message__c = e.getMessage();
            ex.Exception_Type__c = e.getStackTraceString();
            ex.Additional_Information__c = String.valueof(e.getLineNumber());
            ex.User_Message__c = String.valueof(e.getCause());
            ex.Class_Reference__c = 'Digital_Cohort_OppPropCheck > Execute';
            insert ex;
        }
    }
    
    // Get Opportunities to validate
    public void getOppData(Digital_Customer__c dcs) {
        set<Date> dsRenewalDates = new set<Date> ();
        list<Product_Account_Detail__c> dsList = [Select Id, Renewal_Date__c
            from Product_Account_Detail__c
            where ZP_Cust_Number__c =: dcs.Customer_SSD__r.Source_System_Account_Number__c and Renewal_Date__c > Today
        ];
        for (Product_Account_Detail__c dsl: dsList) {
        	system.debug(LoggingLevel.INFO, 'OppPropCheck - DS Record: ' + dsl);
            dsRenewalDates.add(dsl.Renewal_Date__c);
        }
        system.debug(LoggingLevel.INFO, 'OppPropCheck - getOppData Digital Customer: ' + dcs);
        system.debug(LoggingLevel.INFO, 'OppPropCheck - Renewal Dates: ' + dsRenewalDates);
        
        oppList = [Select Id, LCRM_Total_Actual_Renewal__c, Digital_Offer__c, Digi_Offer__c, Digital_Review_Complete__c, Renewal_Date__c
            from Opportunity
            where Name LIKE '%DigitalOpp'
            AND isDigitalSpearHead__c = TRUE AND Source_System_Detail__c =: dcs.Customer_SSD__c And Renewal_Date__c IN: dsRenewalDates
        ];
        for (Opportunity dcOpp: oppList) {
            if (dcOpp.LCRM_Total_Actual_Renewal__c == null) {
                //  dmList.add(new Digital_Message__c(Name = dcmlist[0].Object__c, Digital_Customer__c = dcs.Id, Digital_Settings__c = ds.Id, Message__c = dcmlist[0].Message__c, URL_1__c = sfdcBaseUrl + '/' + dcOpp.Id));
                dmList.add(createMessage(0, dcs.Id, dcOpp.Id));
            }
            // Digital_Offer__c is only set if Digital_Review_Complete__c = true
            if (dcOpp.Digi_Offer__c == null) {
                //  dmList.add(new Digital_Message__c(Name = dcmlist[1].Object__c, Digital_Customer__c = dcs.Id, Digital_Settings__c = ds.Id, Message__c = dcmlist[1].Message__c, URL_1__c = sfdcBaseUrl + '/' + dcOpp.Id));
                dmList.add(createMessage(1, dcs.Id, dcOpp.Id));
            }
            if (dcs.Has_Quotes__c == true) {
                getQuotes(dcOpp.Id, dcs);
            }
        }
    }

	// Get Quotes to validate
    public void getQuotes(Id oppId, Digital_Customer__c dcs) {
        List < Apttus_Proposal__Proposal__c > dcQuotes = [Select Id, Name, APTS_Renewal__c, Apttus_Proposal__Approval_Stage__c, Digital_Quote_Failure_Reason__c, APTS_Validation_Messages__c, APTS_Order_Confirmation_Contact__c, DocuSign_Envelope_ID__c, APTS_Order_Confirmation_Contact_Email__c
            from Apttus_Proposal__Proposal__c
            where Apttus_Proposal__Opportunity__c =: oppId
        ];
        if (!dcQuotes.isEmpty()) {
            for (Apttus_Proposal__Proposal__c dcq: dcQuotes) {
                checkQuoteData(dcq, dcs);
                checkQuoteApproval(dcq, dcs);
            }
        }
    }

	// Validate Quote for errors 
    public void checkQuoteData(Apttus_Proposal__Proposal__c dcq, Digital_Customer__c dcs) {
        if (dcq.APTS_Renewal__c == null) {
            //  dmList.add(new Digital_Message__c(Name = dcmlist[2].Object__c, Digital_Customer__c = dcs.Id, Digital_Settings__c = ds.Id, Message__c = dcmlist[2].Message__c, URL_1__c = sfdcBaseUrl + '/' + dcq.Id));
            dmList.add(createMessage(2, dcs.Id, dcq.Id));
        }
        if ((dcq.Digital_Quote_Failure_Reason__c != null) && (dcq.Digital_Quote_Failure_Reason__c != 'NA')) {
            // dmList.add(new Digital_Message__c(Name = dcmlist[4].Object__c, Digital_Customer__c = dcs.Id, Digital_Settings__c = ds.Id, Message__c = dcmlist[4].Message__c + dcq.Digital_Quote_Failure_Reason__c, URL_1__c = sfdcBaseUrl + '/' + dcq.Id));
            // the message field is not standard so update it with additional information
			Digital_Message__c valMessage = createMessage(4, dcs.Id, dcq.Id);  
			valMessage.Message__c = dcmlist[4].Message__c + ' ' + dcq.Digital_Quote_Failure_Reason__c;
			dmList.add(valMessage);
        }
        if (dcq.APTS_Validation_Messages__c != null) {
            //  dmList.add(new Digital_Message__c(Name = dcmlist[5].Object__c, Digital_Customer__c = dcs.Id, Digital_Settings__c = ds.Id, Message__c = dcmlist[5].Message__c + dcq.APTS_Validation_Messages__c, URL_1__c = sfdcBaseUrl + '/' + dcq.Id));
            // the message field is not standard so update it with additional information
			Digital_Message__c valMessage = createMessage(5, dcs.Id, dcq.Id);  
			valMessage.Message__c = dcmlist[5].Message__c + ' ' + dcq.APTS_Validation_Messages__c;
			dmList.add(valMessage);            
        }
        if (dcq.APTS_Order_Confirmation_Contact__c == null) {
            //  dmList.add(new Digital_Message__c(Name = dcmlist[6].Object__c, Digital_Customer__c = dcs.Id, Digital_Settings__c = ds.Id, Message__c = dcmlist[6].Message__c, URL_1__c = sfdcBaseUrl + '/' + dcq.Id));
            dmList.add(createMessage(6, dcs.Id, dcq.Id));
        }
        if (dcq.DocuSign_Envelope_ID__c == null) {
            // dmList.add(new Digital_Message__c(Name = dcmlist[7].Object__c, Digital_Customer__c = dcs.Id, Digital_Settings__c = ds.Id, Message__c = dcmlist[7].Message__c, URL_1__c = sfdcBaseUrl + '/' + dcq.Id));
            dmList.add(createMessage(7, dcs.Id, dcq.Id));
        }
        if (dcq.APTS_Order_Confirmation_Contact_Email__c == null) {
            // dmList.add(new Digital_Message__c(Name = dcmlist[8].Object__c, Digital_Customer__c = dcs.Id, Digital_Settings__c = ds.Id, Message__c = dcmlist[8].Message__c, URL_1__c = sfdcBaseUrl + '/' + dcq.Id));
            dmList.add(createMessage(8, dcs.Id, dcq.Id));
        }
    }
    
    // Check quote for approvals
    public void checkQuoteApproval(Apttus_Proposal__Proposal__c dcq, Digital_Customer__c dcs) {

        if (dcq.Apttus_Proposal__Approval_Stage__c != 'Presented') {
            //  dmList.add(new Digital_Message__c(Name = dcmlist[3].Object__c, Digital_Customer__c = dcs.Id, Digital_Settings__c = ds.Id, Message__c = dcmlist[3].Message__c + dcq.Apttus_Proposal__Approval_Stage__c, URL_1__c = sfdcBaseUrl + '/' + dcq.Id));
            // the message field is not standard so update it with additional information
			Digital_Message__c valMessage = createMessage(3, dcs.Id, dcq.Id);  
			valMessage.Message__c = dcmlist[3].Message__c + ' ' + dcq.Apttus_Proposal__Approval_Stage__c;
			dmList.add(valMessage);
        }

        if (dcq.Apttus_Proposal__Approval_Stage__c == 'In Review') {
            List < Apttus_Approval__Approval_Request__c > approvalRequests = new List < Apttus_Approval__Approval_Request__c > ();
            String sysMsg = 'For system use only. No action needed';
            String quoteId = String.valueof(dcq.Id);
            approvalRequests = [Select Id, Apttus_Approval__Assigned_To_Link__c, Apttus_Approval__Request_Comments__c, Apttus_Approval__Approval_Status__c from Apttus_Approval__Approval_Request__c where Apttus_QPApprov__ProposalId__c =: quoteId];
            for (Apttus_Approval__Approval_Request__c ar: approvalRequests) {
                if (ar.Apttus_Approval__Request_Comments__c != sysMsg) {
                	// there is no MDT message for this error message
                    dmList.add(new Digital_Message__c(Name = 'Quote', Digital_Customer__c = dcs.Id, Digital_Settings__c = ds.Id, Message__c = dcq.Name + ' Approval Required,Status->' + ar.Apttus_Approval__Approval_Status__c + ',Assigned to-' + ar.Apttus_Approval__Assigned_To_Link__c + ' ,Comments->' + ar.Apttus_Approval__Request_Comments__c, URL_1__c = sfdcBaseUrl + '/' + ar.Id, URL_2__c = sfdcBaseUrl + '/' + dcq.Id));
                }
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
    
	// Finish method - Update the Digital Settings record and call the next Validation job
    public void finish(Database.BatchableContext bc) {
        if (!dmList.isEmpty()) {
            insert dmList;
        }
        if (ds.Completion__c != 100) {
            ds.Completion__c = 100;
            ds.Job_Status__c = 'Completed';
            ds.End_Time__c = DateTime.now();
            update ds;
        }
        Digital_Cohort_CompletionTasks dc = new Digital_Cohort_CompletionTasks();
        dc.sendcompletionemail(ds.Id);
    }
}