/***************************************************************************************************
 CLASS NAME  : Digital_Cohort_SSDCheck
 DESCRIPTION : Checks Valid Data on SSD records present at DigitalCustomer Object
 ====================================================================================================
 CUSTOM MESSAGES ADDED
 ====================================================================================================
 S.NO      OBJECT                          MESSAGE
 1.      General                         SAP Number has no SSD
 2.      General                         No DS Data found for SAP Number
 3.      SourceSystemDetail              SSD Has No Accounts
 4.      Account                         SSD Account Has No Contacts
 5.      SourceSystemDetail              SSD Has No Assets
 6.      SourceSystemDetail              SSD Has No Automation created Opportunities
 7.      Opportunity                     SSD Digital Opportunity has no Quotes
 8.      SourceSystemDetail              SSD Segmentation fields values Mismatched
 9.      SourceSystemDetail              SSD Has No ContactSourceSystemDetail
 10.     SourceSystemDetail              SSD has no Order Confirmation Contact mail
 11.     SourceSystemDetail              SSD has no APTS Band Number
 12.     SourceSystemDetail              SSD has no Frozen Market Current Year Segment L2
 13.     SourceSystemDetail              SSD has Invalid Digital Firm
 14.     General                         Interrupted , No Digital Customers Found
 15.     SourceSystemDetail              Segment Attorney Limit Reached
 ====================================================================================================
 CHANGE HISTORY
 ====================================================================================================
 DATE            NAME                    DESCRIPTION
 31-05-2020      Rahul Natarajan         Created For CXD Project
 07-10-2020      Brenda Shields          DLT-20728 - Updated to track Fatal errors during Automation
                                         Updated for PMD violations
 ====================================================================================================
 ***************************************************************************************************/
public class Digital_Cohort_SSDCheck implements Database.Batchable<Digital_Customer__c>, Database.Stateful {
    Digital_Settings__c ds;
    string sfdcBaseUrl;
    string ddid;
    list<Digital_Customer__c> dcList;
    list<Digital_Message__c> dmList;
    list<Digital_Customer__c> digitalCustomerList;
    list<Digital_Cohort_Messages__mdt> dcmlist;
    set<date> dsRenewalDates = new set<date>();
    
    
    public Digital_Cohort_SSDCheck(Digital_Settings__c digitalSettings) {
        this.Ds = digitalSettings;
        sfdcBaseUrl = URL.getSalesforceBaseUrl().toExternalForm();
        dcList = new list<Digital_Customer__c>();
        dmList = new list<Digital_Message__c>();
        ddid = ds.Id;
    }


	// start method
    public Iterable<Digital_Customer__c> start(Database.BatchableContext bc) {
        ds.Class__c = 'Digital_Cohort_SSDCheck';
        ds.Completion__c = 15;
        ds.Job_Status__c = 'In Progress';
        update ds;
        // get list of validation messages
        dcmlist = [SELECT Class__c, Label, Message__c, Object__c, Fatal_Error__c, Severity_Level__c
                   FROM Digital_Cohort_Messages__mdt
                   WHERE Class__c = 'Digital_Cohort_SSDCheck'
                   ORDER BY Label ASC
                   NULLS LAST];
                   
		// get a list of customer records already created for this validation run                 
        digitalCustomerList = [Select Id, Customer_SSD__r.Source_System_Account_Number__c, Cohort_Execution__c, Customer_SSD__c, Digital_Settings__c, Has_Account__c, Has_Assets__c, Has_Contact__c, Has_DSdata__c, Has_Opportunity__c, Has_Quotes__c, Has_SSD__c, SAP_Number__c
                               from Digital_Customer__c
                               where Digital_Settings__c = :ds.Id AND Cohort_Execution__c = false];
        if (digitalCustomerList.isEmpty()) {  
        	ds.Completion__c = 100;   
        	ds.Job_Status__c = dcmlist[13].Message__c;   
        	ds.End_Time__c = DateTime.now();  
        	update ds;
        }
        return digitalCustomerList;
    }


	// execute method for batch processing
    public void execute(Database.BatchableContext bc, list<Digital_Customer__c> digitalCustomerList) {

        try {
            for (Digital_Customer__c dcs : digitalCustomerList) {
            	system.debug(LoggingLevel.INFO, 'SSDCheck - execute Digital Customer: ' + dcs);
                list<Source_System_Detail__c> ssdList = new list<Source_System_Detail__c>();
                dsRenewalDates.clear();
                
                // SSD Error check and set initial dcs values
                ssdList = checkSSD(dcs);
              
                // DS Error check
                if (dcs.Has_SSD__c) {
                	dcs.Has_DSdata__c = checkValidDS(dcs);
                  
                    if (ssdList[0].Account_Name__c == null) { 
                    	//dmList.add(new Digital_Message__c(Name = dcmlist[2].Object__c, Digital_Customer__c = dcs.Id, Digital_Settings__c = ds.Id, Message__c = dcmlist[2].Message__c, URL_1__c = sfdcBaseUrl + '/' + ssdList[0].Id)); 
                    	dmList.add(createMessage(2, dcs.Id, ssdList[0].Id));
                    	dcs.Has_Account__c = false; 
                    	dcs.Has_Contact__c = false;
                    } else {
                        dcs.Has_Account__c = true;
                        // Contacts Error check
                        dcs.Has_Contact__c = checkValidContacts(dcs.Id, ssdList[0].Account_Name__c, ssdList[0].id);
                    }
                   
                    // Asset Error check
                    dcs.Has_Assets__c = checkValidAssets(dcs.Id, ssdList[0].id);
               
                    //Below Checks are Not Done for Pre-Cohorts Job
                    if (ds.Data_Status__c != 'Pre-CohortsJob' && dcs.Has_DSdata__c) {
                    	// check Opp and quote for issues
                    	system.debug(LoggingLevel.INFO, 'SSDCheck - before checkOppQUote Digital Customer: ' + dcs);
                    	checkOppQuote(dcs, ssdList[0].Id, dsRenewalDates);
                    } else {
                        dcs.Has_Opportunity__c = false; 
                        dcs.Has_Quotes__c = false;
                    }
                    
                    // check SSD values
                    checkSSDValues(ds.Segment__c, dcs.Id, ssdList);                  
                }
               
                dcList.add(dcs);
            } // end for loop
        } catch (Exception e) {
            Digital_Exception_Log__c ex = new Digital_Exception_Log__c();
            ex.Exception_Message__c = e.getMessage();
            ex.Exception_Type__c = e.getStackTraceString();
            ex.Additional_Information__c = String.valueof(e.getLineNumber());
            ex.User_Message__c = String.valueof(e.getCause());
            ex.Class_Reference__c = 'Digital_Cohort_SSDCheck > Execute';
            insert ex;
        }
    }


	// validate SSD
	private list<Source_System_Detail__c> checkSSD(Digital_Customer__c dcs) {
		system.debug(LoggingLevel.INFO, 'SSDCheck - checkSSD Digital Customer: ' + dcs);
		list<Source_System_Detail__c> ssdList = new list<Source_System_Detail__c>();
		
		if (dcs.Customer_SSD__c == null && schema.sObjectType.Source_System_Detail__c.isAccessible()) {
            ssdList = [Select Id, BU_Segment_Level_2__c, LCRM_Market_Segment__c, LCRM_Frozen_Market_Segment__c, Digital_Firm__c, LCRM_APTS_Band_Number__c, LCRM_Email__c, Account_Name__c, Source_System_Account_Number__c
                               from Source_System_Detail__c
                               where Source_System_Account_Number__c = :dcs.SAP_Number__c LIMIT 1];
            if (ssdList.isEmpty()){
                //dmList.add(new Digital_Message__c(Name = dcmlist[0].Object__c, Digital_Customer__c = dcs.Id, Digital_Settings__c = ds.Id, Message__c = dcmlist[0].Message__c));
                dmList.add(createMessage(0, dcs.Id, ''));
                dcs.Has_SSD__c = false;
                dcs.Cohort_Execution__c = true;
                dcs.Has_Account__c = false;
                dcs.Has_Assets__c = false;
                dcs.Has_Contact__c = false;
                dcs.Has_DSdata__c = false;
                dcs.Has_Opportunity__c = false;
                dcs.Has_Quotes__c = false;
            } else {
                dcs.Has_SSD__c = true;  
                dcs.SAP_Number__c = ssdList[0].Source_System_Account_Number__c;  
                dcs.Customer_SSD__c = ssdList[0].Id;
            }
        } else {
            dcs.Has_SSD__c = true;
            dcs.SAP_Number__c = dcs.Customer_SSD__r.Source_System_Account_Number__c;
            ssdList = [Select Id, BU_Segment_Level_2__c, LCRM_Market_Segment__c, LCRM_Frozen_Market_Segment__c, Digital_Firm__c, LCRM_APTS_Band_Number__c, LCRM_Email__c, Account_Name__c, Source_System_Account_Number__c
                       from Source_System_Detail__c
                       where Id = :dcs.Customer_SSD__c LIMIT 1];
        }
        return ssdList;
	}


	// check SSD values
    public void checkSSDValues(string strSegment, Id custId, list<Source_System_Detail__c> ssdList) {
    	// checkSSDValues(ds.Segment__c, dcs.Id, ssdList);
    	
		if (ssdList[0].LCRM_Email__c == null) {
            //dmList.add(new Digital_Message__c(Name = dcmlist[9].Object__c, Digital_Customer__c = dcs.Id, Digital_Settings__c = ds.Id, Message__c = dcmlist[9].Message__c, URL_1__c = sfdcBaseUrl + '/' + ssdList[0].Id));
            dmList.add(createMessage(9, custId, ssdList[0].Id));
        }
        if (ssdList[0].LCRM_APTS_Band_Number__c == null) {
            //dmList.add(new Digital_Message__c(Name = dcmlist[10].Object__c, Digital_Customer__c = dcs.Id, Digital_Settings__c = ds.Id, Message__c = dcmlist[10].Message__c, URL_1__c = sfdcBaseUrl + '/' + ssdList[0].Id));
            dmList.add(createMessage(10, custId, ssdList[0].Id));
        } else {
            list<DC_Max_Users_or_Attorneys__mdt> dcAttorneyLimit = [Select Id, Segment__c, Max_No_Of_Attorneys__c
                                                                    from DC_Max_Users_or_Attorneys__mdt
                                                                    where Segment__c = : strSegment Limit 1];
            if (ssdList[0].LCRM_APTS_Band_Number__c > dcAttorneyLimit[0].Max_No_Of_Attorneys__c) {
                //dmList.add(new Digital_Message__c(Name = dcmlist[14].Object__c, Digital_Customer__c = dcs.Id, Digital_Settings__c = ds.Id, Message__c = dcmlist[14].Message__c, URL_1__c = sfdcBaseUrl + '/' + ssdList[0].Id));
                dmList.add(createMessage(14, custId, ssdList[0].Id));
            }
        }
        checkSSDSegment(strSegment, custId, ssdList);
    }
    
    
    // check SSD record segment information
    public void checkSSDSegment(string strSegment, Id custId, list<Source_System_Detail__c> ssdList) {
    	
    	if (ssdList[0].BU_Segment_Level_2__c == null) { 
        	//dmList.add(new Digital_Message__c(Name = dcmlist[11].Object__c, Digital_Customer__c = dcs.Id, Digital_Settings__c = ds.Id, Message__c = dcmlist[11].Message__c, URL_1__c = sfdcBaseUrl + '/' + ssdList[0].Id));
           	dmList.add(createMessage(11, custId, ssdList[0].Id));
        }
        if (ssdList[0].Digital_Firm__c == null || ssdList[0].Digital_Firm__c == 'None') {
            //dmList.add(new Digital_Message__c(Name = dcmlist[12].Object__c, Digital_Customer__c = dcs.Id, Digital_Settings__c = ds.Id, Message__c = dcmlist[12].Message__c, URL_1__c = sfdcBaseUrl + '/' + ssdList[0].Id));
            dmList.add(createMessage(12, custId, ssdList[0].Id));
        } 
        if (ssdList[0].BU_Segment_Level_2__c != null && ssdList[0].LCRM_Market_Segment__c != null && 
        		ssdList[0].LCRM_Frozen_Market_Segment__c != null) {
            list<String> ssdSegments = new list<String>(); 
            ssdSegments.add(ssdList[0].BU_Segment_Level_2__c); 
            ssdSegments.add(ssdList[0].LCRM_Market_Segment__c); 
            ssdSegments.add(ssdList[0].LCRM_Frozen_Market_Segment__c); 
            Set<String> ssdSegmentType = new Set<String>();
            
            /*
            for (String ssdSegment : ssdSegments) {
                list<ODT_Market_Segments__mdt> oms = [Select Business_Type__c, Market_Segment__c 
        						from ODT_Market_Segments__mdt where Market_Segment__c = :ssdSegment];
                if (!oms.isEmpty()) { 
                  	ssdSegmentType.add(oms[0].Business_Type__c); 
                }
            }
            if (ssdSegmentType.size() > 1) { 
      	     	//dmList.add(new Digital_Message__c(Name = dcmlist[7].Object__c, Digital_Customer__c = dcs.Id, Digital_Settings__c = ds.Id, Message__c = dcmlist[7].Message__c, URL_1__c = sfdcBaseUrl + '/' + ssdList[0].Id));
               	dmList.add(createMessage(7, custId, ssdList[0].Id));
            }
            */
            list<ODT_Market_Segments__mdt> oms = [Select Business_Type__c, Market_Segment__c 
        						from ODT_Market_Segments__mdt where Market_Segment__c in :ssdSegments];

            if (oms.size() > 1) { 
      	     	//dmList.add(new Digital_Message__c(Name = dcmlist[7].Object__c, Digital_Customer__c = dcs.Id, Digital_Settings__c = ds.Id, Message__c = dcmlist[7].Message__c, URL_1__c = sfdcBaseUrl + '/' + ssdList[0].Id));
               	dmList.add(createMessage(7, custId, ssdList[0].Id));
            }
        }
    }    


	// validate DS 
	public boolean checkValidDS(Digital_Customer__c dcs) {
		boolean bHasDSdata;
             	
		list<Product_Account_Detail__c> dsList = [Select Id, Renewal_Date__c, AccountSSD__c, Opportunity__c
                                                  from Product_Account_Detail__c
                                                  where ZP_Cust_Number__c = : dcs.SAP_Number__c AND Renewal_Date__c > Today];
        if (dsList.isEmpty()) {
            bHasDSdata = false;
            //dmList.add(new Digital_Message__c(Name = dcmlist[1].Object__c, Digital_Customer__c = dcs.Id, Digital_Settings__c = ds.Id, Message__c = dcmlist[1].Message__c + dcs.SAP_Number__c));
            // the message is set differently from the create method so update it again
			Digital_Message__c valMessage = createMessage(1, dcs.Id, '');  
			valMessage.Message__c = dcmlist[1].Message__c + dcs.SAP_Number__c;
			dmList.add(valMessage);        
        } else {
            bHasDSdata = true;
            // get list of renewal dates for Opportunity selection
            for (Product_Account_Detail__c dsl : dsList) { 
              	dsRenewalDates.add(dsl.Renewal_Date__c); 
            }
            // update digital customer with DS data
     	   dcs.Customer_SSD__c = dsList[0].AccountSSD__c;
     	   dcs.Opportunity__c = dsList[0].Opportunity__c;
        }
		return bHasDSdata;
	}
	
	
	// validate contact
	public boolean checkValidContacts(id custId, string accountName, id ssdId) {
		boolean bHasContact;
		if (!schema.sObjectType.Contact.isAccessible() ||
			!schema.sObjectType.LCRM_Contact_SSD__c.isAccessible()) {
			dmList.add(createMessage(3, custId, accountName));
			return false;
		}
		//dcs.Id, ssdList[0].Account_Name__c, ssdList[0].id);
		list<Contact> dcContacts = [Select Id
                                    from Contact
                                    where AccountId = : accountName];
        if (dcContacts.isEmpty()) {
			//dmList.add(new Digital_Message__c(Name = dcmlist[3].Object__c, Digital_Customer__c = dcs.Id, Digital_Settings__c = ds.Id, Message__c = dcmlist[3].Message__c, URL_1__c = sfdcBaseUrl + '/' + ssdList[0].Account_Name__c));
            dmList.add(createMessage(3, custId, accountName));
            bHasContact = false;
        } else {
            bHasContact = true;
            list<LCRM_Contact_SSD__c> dcCsd = [select Name, LCRM_Account_SSD__c
                                               from LCRM_Contact_SSD__c
                                               where LCRM_Account_SSD__c = : ssdId];
        	if (dcCsd.isEmpty()) {
            	//dmList.add(new Digital_Message__c(Name = dcmlist[8].Object__c, Digital_Customer__c = dcs.Id, Digital_Settings__c = ds.Id, Message__c = dcmlist[8].Message__c, URL_1__c = sfdcBaseUrl + '/' + ssdList[0].Id));
        		dmList.add(createMessage(8, custId, ssdId));
        	}
        }
		return bHasContact;
	}
	
    
    // validate contact
	public boolean checkValidAssets(id custId, id ssdId) {
		boolean bHasAssets;
		if (!schema.sObjectType.Apttus_Config2__AssetLineItem__c.isAccessible()) {
			dmList.add(createMessage(4, custId, ssdId));
			return false;
		}
        //dcs.Has_Assets__c = checkValidAssets(dcs.Id, ssdList[0].id);           
        list<Apttus_Config2__AssetLineItem__c> dcAssets = [Select Id
                                                           from Apttus_Config2__AssetLineItem__c
                                                           where APTS_SSD_Sold_To__c = : ssdId];
        if (dcAssets.isEmpty()) {
        	//dmList.add(new Digital_Message__c(Name = dcmlist[4].Object__c, Digital_Customer__c = dcs.Id, Digital_Settings__c = ds.Id, Message__c = dcmlist[4].Message__c, URL_1__c = sfdcBaseUrl + '/' + ssdList[0].Id));
            dmList.add(createMessage(4, custId, ssdId));
            bHasAssets = false;
        } else {
            bHasAssets = true;
        }
        return bHasAssets;
    }
     
     
    // validate Opportunity and Quotes
    public void checkOppQuote(Digital_Customer__c dcs, Id ssdId, set<date> dsRenewalDates) {
    	system.debug(LoggingLevel.INFO, 'SSDCheck - checkOppQuote Digital Customer: ' + dcs);
    	//checkOppQuote(dcs, ssdList[0].Id);
    	system.debug(LoggingLevel.INFO, 'SSDCheck Select Opp: ds SSD: ' + dcs.Customer_SSD__c);
    	system.debug(LoggingLevel.INFO, 'SSDCheck Renewal Dates: ' + dsRenewalDates);
    	list<Opportunity> dcOpps; 
        dcOpps = [Select Id, LCRM_Total_Actual_Renewal__c, Digital_Offer__c, Renewal_Date__c 
              			from Opportunity where Name LIKE '%DigitalOpp' 
               			AND isDigitalSpearHead__c = TRUE AND Source_System_Detail__c = :dcs.Customer_SSD__c 
               			And Renewal_Date__c IN :dsRenewalDates];
        if (DcOpps.isEmpty()) { 
        	//dmList.add(new Digital_Message__c(Name = dcmlist[5].Object__c, Digital_Customer__c = dcs.Id, Digital_Settings__c = ds.Id, Message__c = dcmlist[5].Message__c, URL_1__c = sfdcBaseUrl + '/' + ssdList[0].Id));
            dmList.add(createMessage(5, dcs.Id, ssdId)); 
            dcs.Has_Opportunity__c = false; 
            dcs.Has_Quotes__c = false; 
        } else {
            list<String> oppId = new list<String>();
            for (Opportunity op : DcOpps) { 
            	oppId.add(String.valueOf(op.Id));
            } 
            dcs.Has_Opportunity__c = true; 
            dcs.Has_Quotes__c = true;
            list<Apttus_Proposal__Proposal__c> dcQuotes = [Select Id from Apttus_Proposal__Proposal__c 
                            			where Apttus_Proposal__Opportunity__c IN :oppId];
            if (dcQuotes.isEmpty()) { 
            	//dmList.add(new Digital_Message__c(Name = dcmlist[6].Object__c, Digital_Customer__c = dcs.Id, Digital_Settings__c = ds.Id, Message__c = dcmlist[6].Message__c, URL_1__c = sfdcBaseUrl + '/' + DcOpps[0].Id)); 
                dmList.add(createMessage(6, dcs.Id, DcOpps[0].Id));
                dcs.Has_Quotes__c = false; 
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
	
	// finish method for batch processing
    public void finish(Database.BatchableContext bc) {
    	
    	// Continue with validation processing
        if (ds.Completion__c != 100) {
        	// Insert all digital messages
            if (!dmList.isEmpty()) {
                insert dmList;
            }
            // Update all digital customers
            if (!dcList.isEmpty()) {
                update dcList;
            }
            // continue processing and update digital setting
            if (!test.isrunningtest()) {
            	ds.Batch_Id__c = String.valueof(Database.executeBatch(new Digital_Cohort_DSCheck(ds), Integer.valueOf(ds.Batch_Size__c))); 
            	update ds; 
            }
        // Validation is completed - run final tasks
        } else { 
        	if (!test.isrunningtest()) { 
        		Digital_Cohort_CompletionTasks dc = new Digital_Cohort_CompletionTasks(); 
        		dc.sendcompletionemail(ds.Id); 
        	} 
        }
        
    }
}