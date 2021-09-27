/**
 * This class is designed to be utilized as a schedulable routine which is expected to run daily.
 * This job will sync Digital Subscriptions and Opportunities and update the Digital flag and the Digital Engagement fields
 * if no Opportunity is found, one is created
 */
/**
 * CHANGE HISTORY
 * =============================================================================
 * Date         Name               Description
 * 2018-10-18   Brenda Shields     Created for CX Digital Project
 * 2019-01-17   Brenda Shields     DLT-14423 - optomize code and schedule to run automation upon completion
 * 2019-03-01   Brenda Shields     DLT-15263 - Add SSD to Opportunity if it's not there already on Opportunity
 * 2019-03-20   Navleen Kaur       DLT-15672 - [Tech Story] [SLF] Automation Changes for New Mid Contract Flag
 * 2019-06-24   Brenda Shields     DLT-16903 - Combine code for Opportunity update/creation for the Automation process
 * 2019-07-05   Brenda Shields     DLT-16853 - set new Opp lookup field on DS once the opp has been created/updated
 * 2019-07-08   Brenda Shields     DLT-16681 - set Sub Campaign Code in Opp if it's created or 
 * 2020-01-14   Srikanth Kota      DLT-19157 - Update Opportunity Sync Job to set old Opps to 'Unmarked Digital Channel'.
 * 2020-04-07   Brenda Shields     DLT-19189 - Fix multiple batch job runtime errors
 * 2020-04-07   Brenda Shields     DLT-19746 - Allow for update/creation of multiple Opps per account if there are multiple Renewal Dates
 * 2020-04-13   Brenda Shields     DLT-19703 - Change from using Account Team Members to Terrirory2 for assigning Opp owners
 * 2020-04-13   Brenda Shields     DLT-19777 - Update Opp Owner for existing Opps based or current assignment criteris
 * 2020-05-07   Brenda Shields     DLT-19816 - Add Team members to Opp for Findlaw Opportunities
 * 2020-05-22   Brenda Shields     DLT-20099 - If Digital Opp already exists, then just update DS with existing Opp id
 *                                             For Digital Firm Defaults - don't use label field
 * 2020-08-10   Brenda Shields     DLT-20475 - Only add Contacts if they are active and not bounced email update existing opps if they are not active
 * 2020-08-12   Brenda Shields     DLT-20482 - [SFDC] [REN] Opportunity Creation
 * 2020-10-05   Benjamin Her       DLT-20742 - Add prioritization to role assignment
 * 2020-10-27   Brenda Shields     DLT-21010 - Create new Opp if a finance one is not found (remove contract type logic for early renewals) 
 *                                             Update for PMD Violations
 * 2020-12-23   Brenda Shields     DLT-21196 - Update Territory Roles --- include new early/mid contract roles for Small Law Territories
 * 2021-03-17   Brenda Shields     DLT-21426 - [SFDC][ALL]PI - Duplicate opportunities are creating if bypass automation is not true on DS
 *                                             This includes changes for DLT-21425 - [SFDC][ALL]PI - Opportunity name being updated and appended with “-DigitalOpp”
 * 2021-05-18   Brenda Shields     DLT-21788 - The Check for FindLaw Opps is changing Opp.Owner.sub bu check is no longer valid 
 * =============================================================================
 */  

/** 
 * @description : Matches Digital Subscription records to Opportunities
 */ 
public with sharing class Digital_OpportunityDigitalFlagSync implements Database.Batchable<Product_Account_Detail__c>, Database.Stateful {

    private static final String OLD_MID_CONTRACT = 'Old Mid Contract';
    private static final String GLIOPP = 'GLI Pipeline Opportunity';
    private static final string DRS_DECLINE_STATUS = 'Declined Digital / Ready for Channel';
    private static final string STAGE_CLOSED = 'Closed Lost';
    private static final string STAGE_SIGNED = 'Contract Signed';
    private static final string STAGE_COMPLETED = 'Order Complete';
    private static final string STAGE_SCHEDULED = 'Appointment Scheduled';
    
    private static Set<Id> recordIds = new Set<Id>{Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(GLIOPP).getRecordTypeId()};
    private static list<Opportunity> listUpdateOpps = new list<Opportunity>();
    private static list<Opportunity> listDigitalOpps = new list<Opportunity>();
    private static list<Opportunity> listDigitalRepDrivenOpps = new list<Opportunity>();
   
    private static list<Source_System_Detail__c> ssdCreationList = new list<Source_System_Detail__c>();  
    private static list<Digital_Exception_Log__c> exList = new list<Digital_Exception_Log__c>();
    private static map<string, string> mapMidContract = new map<string, string>(); 
    private static map<string, string> mapAcctMidContract = new map<string, string>(); 
    private static map<string, string> mapAccountL2DigitalFirm = new map<string, string>();

    // DLT-15263 - add new list and maps to hold Account specific information
    private static list<string> listMatchAcctKey = new list<string>();
    private static list<string> listMatchKey = new list<string>();  
    private static list<string> listFoundMatchKey = new list<string>();  
    private static map<string, string> mapDSKey2Firm = new map<string, string>();
    // ds match key, sub campaign code
    private static map<string, string> mapDSSubCampaignCode = new map<string, string>();
    
    // sets needed to created new Opps 
    private static set<string> setSSDIds = new set<string>();  
    //private static set<string> setAcctIds = new set<string>();
    private static set<string> setSSDIdsForAllOpps = new set<string>();  
    // ssd account, ssd id
    //private static map<id, id> mapAcctSSD = new map<id, id>();
    private static set<string> setSAPAccounts = new set<string>();
       
    /** 
     * @description : Start method
     * @param bC : batchableContext
     * @return : list of Digital Subscription records
     */ 
    public Iterable<Product_Account_Detail__c> start(database.batchablecontext bC) {
        list<Product_Account_Detail__c> digitalSubscriptionsList = new list<Product_Account_Detail__c>();  
        list<Product_Account_Detail__c> digitalSubsList = new list<Product_Account_Detail__c>();
        list<string> listUniqueKey = new list<string>(); 
        set<string> setDigitalFirms = new set<string>(); 
        string strDSKey;

        // Digital Subscription records - that are multiple records for each customer 
        if (schema.sObjectType.Product_Account_Detail__c.isAccessible()) {
            // Get subscriptions whose renewal date is greater than today and with non empty fields that are needed for processing
            // DLT-21426 Don't get DS records that already have an Opportunity assigned to them
            digitalSubscriptionsList = [SELECT AccountSSD__c, AccountSSD__r.Account_Name__c, AccountSSD__r.BU_Segment_Level_2__c, 
            						Account__c, Campaign_Code__c, Contract_Type__c ,Id, Renewal_Date__c, 
                                    ZP_Cust_Number__c, Digital_Firm__c, Sub_Campaign_Code__c                                    
                                    FROM Product_Account_Detail__c where Current_Subscription__c != Null and Campaign_Code__c != Null and Renewal_Date__c > Today 
                                    and Digital_Firm__c != Null and Bypass_Automation__c = false and Opportunity__c = null
                                    order by AccountSSD__c, Campaign_Code__c, Renewal_Date__c, Digital_Firm__c limit 50000]; 
            for (Product_Account_Detail__c  dsRecord : digitalSubscriptionsList) {
                
                // weed out any duplicates - only process one record for each SSD account record with unique campaign code and renewal date  
                strDSKey = buildDSMatchString(dsRecord.ZP_Cust_Number__c, dsRecord); 
                if (!listUniqueKey.contains(strDSKey)) {
                    listUniqueKey.add(strDSKey);
                    // create a set of Segments to create unique Digital Settings records
                    setDigitalFirms.add(dsRecord.Digital_Firm__c);
                    digitalSubsList.add(dsRecord);                  
                }
            }
            // Create Digital Setting and Customers for Validation
            Digital_OpportunityDigitalFlagSyncUtil.createValCustomers(setDigitalFirms, digitalSubsList);
            system.debug(LoggingLevel.INFO, 'Digital Opp Sync - DS Selected: ' + digitalSubscriptionsList.size() + ' DS Passed to Exec: ' + digitalSubsList.size());
            return digitalSubsList;
        } else {
            return null;
        }
    }
    
    
    /** 
     * @description : Execute method
     * @param bC : Batch of Digital Subscription Record
     * @param scope : Digital Subscription Records in scope 
     */ 
    public void execute(Database.BatchableContext bC, list<Product_Account_Detail__c> scope) {        
        // sets used to query Opportunities              
        set<string> setCampaignCodes = new set<string>();
        set<date> setRenewalDates = new set<date>();
        set<string> setAccounts = new set<string>();
        set<string> setSSDAccounts = new set<string>();
      
        //list<string> listAccounts = new list<string>();
        list<Source_System_Detail__c> ssdOpp = new list<Source_System_Detail__c>();
        list<Opportunity> oppNoSSDList = new list<Opportunity>();
        list<Product_Account_Detail__c> listDSRecords = new list<Product_Account_Detail__c>();
    
        // Build selection lists for Opportunity selection criteria
        for (sObject oScope : Scope) {          
       
            Product_Account_Detail__c prodDetail = (Product_Account_Detail__c)oScope;
            system.debug(LoggingLevel.INFO, 'Digital Subscriptions Selected ==> ' + prodDetail);
            
            listDSRecords.add(prodDetail);
            
            // build a list of accounts 
            // build matching keys so we can identify Opps to set as Digital
            // build map to check to see if this account is Mid Contract
            // build maps to hold campaign and sub campaign codes
            buildSearchLists(prodDetail);

            // build a list of accounts 
            setAccounts.add(prodDetail.AccountSSD__r.Account_Name__c);
            setSSDAccounts.add(prodDetail.AccountSSD__c);
            
            // create sets to select the correct SSDs and Opportunities
            setSAPAccounts.add(prodDetail.ZP_Cust_Number__c);
            setCampaignCodes.add(prodDetail.Campaign_Code__c);
            setRenewalDates.add(prodDetail.Renewal_Date__c);
        } // end of for loop
        
        if (Schema.sObjectType.Source_System_Detail__c.isAccessible() && Schema.sObjectType.Opportunity.isAccessible()) {  
            // select Opps with no SSD but are associated with the correct Account - We could have matching Opp on the Account
            // DLT-21426 exclude Opps that have a contract type (old/new) 
            oppNoSSDList = [select Id, Name, AccountID, SAP_Account_Number__c, Renewal_Date__c, Campaign_Code__c, Digital_Opportunity_Failure_Reason__c, Digital_Firm__c,
                    isDigitalSpearHead__c, Unmarked_Digital_Channel__c, DRS_Status_Digital__c, Contract_Type__c, Source_System_Detail__c, Stagename,
                    Source_System_Detail__r.Digital_Firm__c, Key_Contact__c, Key_Contact__r.Contact_Inactive__c, Key_Contact__r.IsEmailBounced,
                    OwnerId, Owner.Sub_Bu__c, Owner.Rep_Type_Description__c
                    from Opportunity
                    where Source_System_Detail__r.Source_System_Account_Number__c = null and AccountID in : setAccounts
                    and Renewal_Date__c in : setRenewaldates and Campaign_Code__c in : setCampaignCodes  
                    and Unmarked_Digital_Channel__c = false and DRS_Status_Digital__c != : DRS_DECLINE_STATUS
                    and isDigitalSpearhead__c = false and Contract_Type__c = null
                    and RecordTypeId IN : recordIds
                    and Stagename != : STAGE_CLOSED and Stagename != : STAGE_SIGNED and Stagename != : STAGE_COMPLETED];
            system.debug(LoggingLevel.INFO, 'Digital Opp Sync - Opps with no SSD but valid Account: ' + oppNoSSDList.size());
        
            // select SSD and associated Opportunities so we can match or create Opps as needed
            // Added Owner.Sub_Bu__c to select query 
            // exclude opps that are closed 
            // DLT-21426 exclude Opps that have a contract type (old/new)     
            ssdOpp = [Select id, Name, Account_Name__c, Source_System_Account_Number__c, Digital_Firm__c, BU_Segment_Level_2__c,
                    (Select Id, Name, AccountID, SAP_Account_Number__c, Renewal_Date__c, Campaign_Code__c, Digital_Opportunity_Failure_Reason__c,
                    isDigitalSpearHead__c, Unmarked_Digital_Channel__c, DRS_Status_Digital__c, Contract_Type__c, Source_System_Detail__c, 
                    StageName, OwnerId, Owner.Sub_Bu__c, Owner.Rep_Type_Description__c, Source_System_Detail__r.Digital_Firm__c,
                    Key_Contact__c, Key_Contact__r.Contact_Inactive__c, Key_Contact__r.IsEmailBounced, Digital_Firm__c, Source_System_Detail__r.BU_Segment_Level_2__c
                    from Opportunities__r where RecordTypeId IN : recordIds and Contract_Type__c = null and
                    Stagename != : STAGE_CLOSED and Stagename != : STAGE_SIGNED and Stagename != : STAGE_COMPLETED and
                    Renewal_Date__c IN : setRenewaldates AND Campaign_Code__c IN : setCampaignCodes)
                    FROM Source_System_Detail__c where Source_System_Account_Number__c IN : setSAPAccounts];
        }
        // Check for existing Opportunities 
        checkForDigitalOpportunities(oppNoSSDList, ssdOpp);

        // create Opportunities if one was not found
        createOpportunity(listDSRecords, ssdCreationList);
        
        // Update Old Opportunities to unmarked Digital
        unmarkDigitalOpportunity(setSAPAccounts);
              
        // Update/insert any Opportunities and create any FindLaw Opp Team Members if needed
        // DLT-21196 - pass contract type map finalize method to set new mid-contract territory roles
        if (listUpdateOpps != null && listUpdateOpps.size() > 0 && Schema.sObjectType.Opportunity.isUpdateable()) {  
            Digital_OpportunityDigitalFlagSyncUtil.finalizeOppRecords(listUpdateOpps, setSSDAccounts, mapAcctMidContract); 
        }            
              
        // update DS records to include newly created/updated Opportunity lookup 
        Digital_OpportunityDigitalFlagSyncUtil.updateDigitalSubscriptions(listUpdateOpps, listDigitalOpps, setSSDIdsForAllOpps);
 
        // update DS records to display error that no Opp was created and rep driven offer was found 
        Digital_OpportunityDigitalFlagSyncUtil.setDigitalSubOppError(listDigitalRepDrivenOpps);
            
        // insert any Digital errors
        Digital_OpportunityDigitalFlagSyncUtil.insertDigitalErrors(exList);     
    }
    
    
    private static boolean checkForNewDigitalOpportunity(boolean bFoundMatchingOpp, Opportunity oppRecord,Source_System_Detail__c ssd){
        boolean tempBool = bFoundMatchingOpp;

        // only Opps with these setting can be marked as digital
        if (oppRecord.Unmarked_Digital_Channel__c == false && oppRecord.DRS_Status_Digital__c != DRS_DECLINE_STATUS
            && oppRecord.isDigitalSpearhead__c == false && oppRecord.Stagename != STAGE_CLOSED 
            && oppRecord.Stagename != STAGE_SIGNED && oppRecord.Stagename != STAGE_COMPLETED) {
            //  reset opp name so if this is a match it will be updated as digital
            oppRecord.Name = ssd.Name;
            tempBool = checkForMatchingOpp(oppRecord);
        }  // end of found matching Opp  
        return tempBool;
    }


    private static boolean checkForExistingDigitalOpportunity(boolean bFoundMatchingOpp, Opportunity oppRecord){
        boolean tempBool = bFoundMatchingOpp;

        // check to see if we already have an existing matching Digital Opp - then just update DS
        if (oppRecord.isDigitalSpearHead__c == true) {
            // if opp matches - the appropriate lists are updated as needed                         
            tempBool = checkForMatchingOpp(oppRecord);
        }
        return tempBool;
    } 


    private static boolean checkForOldDigitalOpportunity(boolean bFoundDigitalOpp, Opportunity oppRecord){
        boolean tempBool = bFoundDigitalOpp;

        // check if we have found an old Digital Opp (expired/denied or not) we don't want to created a new Opp in this instance
        if (oppRecord.Unmarked_Digital_Channel__c == true || oppRecord.isDigitalSpearHead__c == true) {
            tempBool = true;
            // exclude from updating/creating new opp
            String strRenewalMatchKey =  buildOppMatchString(oppRecord.SAP_Account_Number__c, oppRecord); 
            listFoundMatchKey.add(strRenewalMatchKey);
        }
        return tempBool;
    } 


    private static void checkForDigitalOpportunities(list<Opportunity> oppNoSSDList, list<Source_System_Detail__c> ssdOpp){

        boolean bFoundMatchingOpp;
        boolean bFoundDigitalOpp;
        boolean bFoundRepDrivenOpp;
        map<id, list<Opportunity>> opids = new map<id, list<Opportunity>>();
        map<id, boolean> oppsWithManualQuotes = new map<id, boolean>();
        set<id> oppsManualToBypass = new set<id>();

		// DLT-21426 build list of Opps and check to see if any are manual
		oppsWithManualQuotes = checkOppForManual(ssdOpp);
		// create a set of opp ids where we need to bypass creating an opp if one is not found
		for (id oppId : oppsWithManualQuotes.keySet()) {
			// if the value is true - bypass creating the Opportunity
			if (oppsWithManualQuotes.get(oppId)) {
				oppsManualToBypass.add(oppId);
			}
		}		
		
        // Check to see if we have any Opps with no associated SSD that should be marked as Digital
        for (Opportunity oppAcctRecord : oppNoSSDList) {
            system.debug(LoggingLevel.INFO, 'Starting search for Opps with no SSD, but valid Account ' + oppAcctRecord);
            // check each Opportunity & add it to the list to be updated            
            bFoundMatchingOpp = checkForMatchingOpp(oppAcctRecord);  
        }
        
        // check each SSD Account, then all it's associated Opportunities                    
        for (Source_System_Detail__c ssd: ssdOpp) {            
            opids.put(ssd.id, ssd.Opportunities__r);
   
            // we can have mulptiple Opps per SSD, but if we mark one as Digital we don't want to process any other Opps 
            bFoundMatchingOpp = false;
            bFoundDigitalOpp = false;
            bFoundRepDrivenOpp = false;
           
            // we have one or more opportunities, so lets see if any matches so we can mark one as Digital             
            if (!opids.get(ssd.id).isEmpty()) {
                // loop through any opps
                for (Opportunity oppRecord : ssd.Opportunities__r) {
					// if we don't find any manual quotes for this Opportunity, check to see if it matches
					if (!oppsWithManualQuotes.containskey(oppRecord.Id)) {						
                    	bFoundMatchingOpp = checkForNewDigitalOpportunity(bFoundMatchingOpp,oppRecord,ssd);
                    	bFoundMatchingOpp = checkForExistingDigitalOpportunity(bFoundMatchingOpp,oppRecord);
                    	// DLT-21010 - always create and not so we don't need to look for old digital opps
                    	//bFoundDigitalOpp = checkForOldDigitalOpportunity(bFoundDigitalOpp,oppRecord);
					}
					// for Opps with Manual quotes to not create an Opportunity (manual over 50%)
					if (oppsWithManualQuotes.containskey(oppRecord.Id) && oppsWithManualQuotes.get(oppRecord.Id)) { 
						bFoundRepDrivenOpp = true;
						listDigitalRepDrivenOpps.add(oppRecord);
					}					
                    // what what found for each Opp
                    system.debug(LoggingLevel.INFO, 'SSD-Opp: SSD Id: ' + ssd.id + ' Opp Id: ' + oppRecord.Id + ' Flags: Matching: ' + bFoundMatchingOpp + ' Digital: ' + bFoundDigitalOpp);
                } // end of Opps loop
            } // end of if Opps 

            // for this SSD, if we didn't find a matching opp or one that been unmarked, then we need to create one
            if (bFoundMatchingOpp == false && bFoundRepDrivenOpp == false) { // && bFoundDigitalOpp == false) {
                // create list of SSD where we need to create Opps from
                ssdCreationList.add(ssd); 
                // set for only records where we want to create an Opp
                setSSDIds.add(ssd.id);
                // for all updated or created Opps
                setSSDIdsForAllOpps.add(ssd.id);
            }
        } // end of SSD Loop
    }
    
    
     /** 
     * @description : Builds a list of Opp ids if they have manual quotes
     * @param ssdOpp : List of SSD records with associated Opportunities
     * @return : map of Opps for those having manual quotes 
     */ 
    public static map<id, boolean> checkOppForManual(list<Source_System_Detail__c> ssdOpp) {
		map<id, boolean> oppsWithManualQuotes = new map<id, boolean>();
        set<id> allOpps = new set<id>();
        
        // check access
        if (!Schema.sObjectType.Apttus_Proposal__Proposal__c.isAccessible()) {
    		return null;
    	}
    	 
        // DLT-21426 build list of Opps and check to see if any are manual
		for (Source_System_Detail__c ssd: ssdOpp) {  
			for (Opportunity oppRecord : ssd.Opportunities__r) {         
            	allOpps.add(oppRecord.id);
			}
		}
		system.debug(logginglevel.INFO, 'Opp Sync Existing Opps: ' + allOpps);   	
    	
    	//Select all manual proposals based on the set of Opportunities
    	// we need to check if probability >= 50 so include it in the map
        for (Apttus_Proposal__Proposal__c oProposal: [SELECT Id, Apttus_Proposal__Opportunity__c,
        		Apttus_Proposal__Opportunity__r.Probability
                FROM Apttus_Proposal__Proposal__c 
                where Apttus_Proposal__Opportunity__c in : allOpps 
                and Digital_Quote_Type__c = 'Manual']) {
            if (oProposal.Apttus_Proposal__Opportunity__r.Probability >= 50) {
				oppsWithManualQuotes.put(oProposal.Apttus_Proposal__Opportunity__c, true);
            } else {
            	oppsWithManualQuotes.put(oProposal.Apttus_Proposal__Opportunity__c, false);
            }
        }
        system.debug(logginglevel.INFO, 'Opp Sync Manual Opps: ' + oppsWithManualQuotes);
     	return oppsWithManualQuotes;   
    }
    
    
    /** 
     * @description : Builds various lists for processing
     * @param prodDetail : DS record
     */ 
    public static void buildSearchLists(Product_Account_Detail__c prodDetail) {
        string strDSKey;
        string strDSAcctKey;
            
        // build matching keys so we can identify Opps to set as Digital
        strDSKey = buildDSMatchString(prodDetail.ZP_Cust_Number__c, prodDetail);
        if (!listMatchKey.contains(strDSKey)) {
            listMatchKey.add(strDSKey);
            mapDSKey2Firm.put(strDSKey, prodDetail.Digital_Firm__c);
        }       
        // set the sub campaign code to update existing Opps if a match is found
        mapDSSubCampaignCode.put(strDSKey, prodDetail.Sub_Campaign_Code__c);   
        // build map of accounts and L2 values
        mapAccountL2DigitalFirm.put(prodDetail.AccountSSD__r.Account_Name__c, prodDetail.AccountSSD__r.BU_Segment_Level_2__c);   
        // DLT-15263 - build account based lists/maps if no SSD found for the Opportunity
        strDSAcctKey = buildDSMatchString(prodDetail.AccountSSD__r.Account_Name__c, prodDetail);
        if (!listMatchAcctKey.contains(strDSAcctKey)) {
            listMatchAcctKey.add(strDSAcctKey);           
        }
               
        // build map to check to see if this account is Mid Contract
        if (prodDetail.Contract_Type__c != null && prodDetail.Contract_Type__c != 'none') {
            mapMidContract.put(prodDetail.ZP_Cust_Number__c, prodDetail.Contract_Type__c);
            mapAcctMidContract.put(prodDetail.AccountSSD__r.Account_Name__c, prodDetail.Contract_Type__c);
        }
    }
    
                 
    /** 
     * @description : Check to see if this Opportunity matches a DS record
     * @param oOpp : Opportunity record
     * @return : Returns true or false
     */ 
    public static boolean checkForMatchingOpp(Opportunity oOpp) {
        string strRenewalmatchKey;
        string strRenewalMatchAcctKey;

        // DLT-15263  - create new account based match key and use tha key of SSD is not available
        strRenewalMatchKey = buildOppMatchString(oOpp.SAP_Account_Number__c, oOpp);
        strRenewalMatchAcctKey = buildOppMatchString(oOpp.AccountID, oOpp);
        system.debug(LoggingLevel.INFO, 'Opp Match key: ' + strRenewalMatchKey + ' Opp Account Match Key: ' + strRenewalMatchAcctKey);

        // Do we have a match
        if (listMatchKey.contains(strRenewalMatchKey) || (oOpp.Source_System_Detail__c == null && listMatchAcctKey.contains(strRenewalMatchAcctKey))) {
            // if this is already a digital opp, then we don't want to update the Opp, but we still need to update the DS records
            if (oOpp.isDigitalSpearHead__c == false) {
                // Update Opportunitiy
                updateOpportunity(oOpp);
            } else {
                // keep track of all Digital Opps we found
                listDigitalOpps.add(oOpp);
                // save account so we can update DS records
                setSSDIdsForAllOpps.add(oOpp.Source_System_Detail__c); 
            }
            // keep a list of all the found DS records
            listFoundMatchKey.add(strRenewalMatchKey);
            return true;
        } else {
            return false;
        }
    }
    
    
    /** 
     * @description : Found existing Opportunity - update it as Digital
     * @param oOpp : Opportunity to update
     */     
    private static void updateOpportunity(Opportunity oOpp) {
        boolean bMidContract;
        string strRenewalMatchKey;
        //string strOwner;
        string strDigitalFirm;

        strRenewalMatchKey = buildOppMatchString(oOpp.SAP_Account_Number__c, oOpp);
        // get the Digital Firm value from the DS record
        strDigitalFirm = mapDSKey2Firm.get(strRenewalMatchKey);
        
        // check for Mid Contract - DLT-15263 - get mid contract flag if no SSD is available
        bMidContract = false; 
        if ((oOpp.Source_System_Detail__c != null && mapAcctMidContract.get(oOpp.AccountID) == OLD_MID_CONTRACT) ||
            (oOpp.Source_System_Detail__c == null && mapMidContract.get(oOpp.SAP_Account_Number__c) == OLD_MID_CONTRACT)) {
            bMidContract = true;
        }
        oOpp.Name = oOpp.Name; 
        if (oOpp.Source_System_Detail__r.BU_Segment_Level_2__c == 'Corp-SMB') {
        	oOpp.Digital_Firm__c = 'Corp-SMB';
        } else {
        	oOpp.Digital_Firm__c = strDigitalFirm; //oOpp.Source_System_Detail__r.Digital_Firm__c;
        }
        // DLT-21778 - Set the Proposal Business Unit to FindLaw as needed   
        if (strDigitalFirm == 'FindLaw') {
			oOpp.APTS_Proposal_Business_Unit__c = 'FindLaw';
 		} else { 
          	oOpp.APTS_Proposal_Business_Unit__c = 'SCS';
      	} 
            	       
        oOpp.DRS_Status_Digital__c = setDigitalEngagement(oOpp.Renewal_Date__c, bMidContract);
        oOpp.isDigitalSpearHead__c = true;
        oOpp.Digital_Opportunity_Failure_Reason__c = '';
        oOpp.sub_Campaign_Code__c = mapDSSubCampaignCode.get(strRenewalMatchKey);

        listUpdateOpps.add(oOpp);
        // save account so we can update DS records
        setSSDIdsForAllOpps.add(oOpp.Source_System_Detail__c); 
    }
    
    
    /** 
     * @description : Create Opportunities
     * @param listDSRecords : All DS records
     * @param ssdCreationList : SSD records for all Opp that are to be created 
     */     
    private static void createOpportunity(list<Product_Account_Detail__c> listDSRecords, list<Source_System_Detail__c> ssdCreationList) {
        //Source_System_Detail__c oSSDRecord = new Source_System_Detail__c();
        string strDSKey;
           
        // Search though all SSD Keys we were trying to match.  If we find one that we didn't find an opportunity for
        // then we need to create an Opportunity
        for (Product_Account_Detail__c oDSRec : listDSRecords) {
            strDSKey = buildDSMatchString(oDSRec.ZP_Cust_Number__c, oDSRec);
            system.debug(LoggingLevel.INFO, 'DS Search for key: ' + strDSKey + ' DS ID: ' + oDSRec.Id + ' DS ACCT: ' + oDSRec.ZP_Cust_Number__c);
            // if we didn't already find the opp - create it now 
            if (listFoundMatchKey.contains(strDSKey)) {
                system.debug(LoggingLevel.INFO, 'Found Opp - dont create new one');
                continue;
            }
            createOpportunityObject(oDSRec);
        } // end of for listMatchKey loop
    }
    
    
    private static void createOpportunityObject(Product_Account_Detail__c oDSRec ){
        //string strOwner;
        boolean bMidContract;
                
        id oppRecId = null;
        for (string recId : recordIds) {
            oppRecId = recId;
            break;
        }

        for (Source_System_Detail__c oSSDAcctRec : ssdCreationList) {
            if (oSSDAcctRec.id == oDSRec.AccountSSD__c) {
                Source_System_Detail__c oSSDRecord = oSSDAcctRec;
                system.debug(LoggingLevel.INFO, 'DS OPP Create: ' + oSSDRecord);

                // check for Mid Contract - DLT-15263 - get mid contract flag if no SSD is available
                bMidContract = false; 
                if (mapMidContract.get(oDSRec.ZP_Cust_Number__c) == OLD_MID_CONTRACT) {
                    bMidContract = true;
                }

                // Create the Opportunity
                Opportunity opts = new Opportunity();
            
                opts.RecordTypeId = oppRecId;
                opts.Name = oSSDRecord.Name; 
                // Need to include Digital Firm code so we can easily identify Opps   
                if (oSSDRecord.BU_Segment_Level_2__c == 'Corp-SMB') {
        			opts.Digital_Firm__c = 'Corp-SMB';
        		} else {             
                	opts.Digital_Firm__c = oDSRec.Digital_Firm__c;
                }
                // DLT-21778 - Set the Proposal Business Unit to FindLaw as needed   
                if (oDSRec.Digital_Firm__c == 'FindLaw') {
        			opts.APTS_Proposal_Business_Unit__c = 'FindLaw';
        		} else { 
                	opts.APTS_Proposal_Business_Unit__c = 'SCS';
            	}
                opts.StageName = STAGE_SCHEDULED;
                opts.AccountID = oSSDRecord.Account_Name__c;
                opts.Renewal_Date__c = oDSRec.Renewal_Date__c;
                opts.Campaign_Code__c = oDSRec.Campaign_Code__c;
                opts.Sub_Campaign_Code__c = oDSRec.Sub_Campaign_Code__c;
                opts.CloseDate = oDSRec.Renewal_Date__c + 365;
                opts.isDigitalSpearHead__c = true;
                opts.Is_GLI__c = true;
                opts.Source_System_Detail__c = oSSDRecord.id;
                opts.DRS_Status_Digital__c = setDigitalEngagement(oDSRec.Renewal_Date__c, bMidContract);
        
                listUpdateOpps.add(opts);
            }
        }
    }

    
    /** 
     * @description : Update Old digital Opportunity to unmark as Digital
     * @param setSAPAccounts : Account is to select Opportunities
     */     
    private static void unmarkDigitalOpportunity(set<string> setSAPAccounts) {
        list<Opportunity> oppNoActOferList = new list<Opportunity>();
        
        // End DLT-19157                
        // select Opps which has old renew date and part of active DS list. 
        oppNoActOferList = [Select Id, Name, AccountID, SAP_Account_Number__c, Renewal_Date__c, Campaign_Code__c, Digital_Opportunity_Failure_Reason__c, Digital_Firm__c,
                        isDigitalSpearHead__c, Unmarked_Digital_Channel__c, DRS_Status_Digital__c, Contract_Type__c, Source_System_Detail__c, StageName,
                        Other_W_L_Reason__c, CloseDate,
                        (select id, name, Apttus_Proposal__Approval_Stage__c 
                        from Apttus_Proposal__R00N70000001yUfDEAU__r ) 
                        from Opportunity where Renewal_Date__c < Today AND Unmarked_Digital_Channel__c = false and 
                        DRS_Status_Digital__c != : DRS_DECLINE_STATUS and isDigitalSpearhead__c = true and 
                        Stagename != : STAGE_CLOSED and Stagename != : STAGE_SIGNED and Stagename != : STAGE_COMPLETED and 
                        RecordTypeId IN : recordIds AND 
                        Campaign_Code__c != Null and Source_System_Detail__r.Source_System_Account_Number__c IN : setSAPAccounts];
            
        for (Opportunity oppPropRecord : oppNoActOferList) {
        	system.debug(logginglevel.INFO, 'UNMARK OPP - Checking: ' + oppPropRecord);
        	system.debug(logginglevel.INFO, 'UNMARK OPP - Quote Count: ' + oppPropRecord.Apttus_Proposal__R00N70000001yUfDEAU__r.size());
            if (oppPropRecord.Apttus_Proposal__R00N70000001yUfDEAU__r.size() <1 ) {
                oppPropRecord.isDigitalSpearHead__c = false;
                oppPropRecord.Unmarked_Digital_Channel__c = true;  
                // fix any old validation issues
                //Other_W_L_Reason__c is sometimes required, reset it if it's null
                if (oppPropRecord.Other_W_L_Reason__c == null) {
                    oppPropRecord.Other_W_L_Reason__c = 'Digital';
                }
                // CloseDate can't be more then 3 years in the future, adjust if needed
                if (oppPropRecord.CloseDate == null || oppPropRecord.CloseDate > system.today() + 1090) {
                    oppPropRecord.CloseDate = system.today();
                }

                listUpdateOpps.add(oppPropRecord);  
            }  
        }
    }    
    
     
    /** 
     * @description : Sets the Digital Engagement field
     * @param renewalDate : Renewal Date
     * @param bMidContract : Mid contract flag
     * @return : returns string of the Digital Engagement value      
     */ 
    public static string setDigitalEngagement(date renewalDate, boolean bMidContract) {
		// Get Renewal Date Ranges and Engagement Message for each type of Digital Renewal 
    	// Opp Ready Initial values:        10,130,Digital / Ready for Channel
 	    list<String> lstDigitalReady = new list<String>(Label.Digital_Opp_Sync_ReadyDateRange.split(','));  
 	    // Opp Only Initial values:         10,185,Digital Only
	    list<String> lstDigitalOnly = new list<String>(Label.Digital_Opp_Sync_OnlyDateRange.split(','));  
 	    // Opp Mid Contract Initial values: 10,450,Digital Only
 	    list<String> lstMidContract = new list<String>(Label.Digital_Opp_Sync_MidContractDateRange.split(','));   
  
        // get date range values
        integer intReadyStartDt = integer.valueOf(lstDigitalReady[0]);
        integer intReadyEndDt = integer.valueOf(lstDigitalReady[1]);
        integer intDigitalStartDt = integer.valueOf(lstDigitalOnly[0]);
        integer intDigitalEndDt = integer.valueOf(lstDigitalOnly[1]);
        integer intMidContractStartDt = integer.valueOf(lstMidContract[0]);
        integer intMidContractEndDt = integer.valueOf(lstMidContract[1]);
        string strReadyEngValue = lstDigitalReady[2];
        string strDigitalEngValue = lstDigitalOnly[2];
        string strMidContractEngValue = lstMidContract[2];
    
        string strDigitalEngagement;
        integer intRenewalDue;
        
        // calculate the number of days until the Renewal is Due
        intRenewalDue = system.today().daysBetween(renewalDate);

        // if there was already an error, but it was fixed and the job ran again, we need to clear out the errors.
        // The order of the ifs is important as the smallest range goes first
        // between 10 and 130
        if (intRenewalDue > intReadyStartDt & intRenewalDue <= intReadyEndDt & bMidContract == false) {   
            strDigitalEngagement = strReadyEngValue;  //'Digital / Ready for Channel';
        // between 10 and 185
        } else if (intRenewalDue > intDigitalStartDt & intRenewalDue <= intDigitalEndDt & bMidContract == false) {   
            strDigitalEngagement = strDigitalEngValue;  //'Digital Only';
        // between 10 and 450  
        } else if (intRenewalDue > intMidContractStartDt & intRenewalDue <= intMidContractEndDt & bMidContract == true) {   
            strDigitalEngagement = strMidContractEngValue;  //'Digital Only';
        }
        system.debug(LoggingLevel.INFO, 'Set Digital Engagement: Renewal Due: ' + intRenewalDue + ' Eng Value: ' + strDigitalEngagement);
        return strDigitalEngagement;
    }       
 
    
    /** 
     * @description : Creates a match key from DS records to find a matching Opp record
     * @param strAcct : which account to use to match on
     * @param oDSRecord : DS Record
     * @return : Returns string match key
     */ 
    public static string buildDSMatchString(string strAcct, Product_Account_Detail__c oDSRecord) {
        string strMatchKey;
        
        // strAcct is oDSRecord.ZP_Cust_Number__c for matching DS to Opportunities with a SSD record
        // strAcct is oDSRecord.AccountSSD__r.Account_Name__c for matching DS to Opportunities with no no SSD record
        strMatchKey = strAcct + ':' + oDSRecord.Campaign_Code__c + ':' + string.valueOf(oDSRecord.Renewal_Date__c); // + ':' + oDSRecord.Digital_Firm__c;
        return strMatchKey;
    }

    
    /** 
     * @description : Creates a match key from Opp records to find a matching DS record
     * @param strAcct : which account to use to match on
     * @param oOppRecord : Opp Record
     * @return : Returns string match key
     */ 
    public static string buildOppMatchString(string strAcct, Opportunity oOppRecord) {
        string strMatchKey;
        string strDigitalFirm;
        
        // check for FindLaw (which is a part of Small Law)
        // there is no way to tell if an existing Opp is Small Law or FindLaw we so check the Owner's BU
        if (oOppRecord.Owner.Sub_Bu__c == 'FindLaw' || 
            (oOppRecord.Owner.Rep_Type_Description__c != null && oOppRecord.Owner.Rep_Type_Description__c.containsIgnoreCase('FindLaw'))) {
            strDigitalFirm = 'FindLaw';
        } else {
            strDigitalFirm = oOppRecord.Source_System_Detail__r.Digital_Firm__c;
        }
        // strAcct is oOppRecord.SAP_Account_Number__c for matching DS to Opportunities with a SSD record
        // strAcct is oOppRecord.AccountID for matching DS to Opportunities with no no SSD record
        strMatchKey = strAcct + ':' + oOppRecord.Campaign_Code__c + ':' + string.valueOf(oOppRecord.Renewal_Date__c); // + ':' + strDigitalFirm; 
        return strMatchKey;
    }    
    
    
    /** 
     * @description : Exception handler - Write out exceptions to the Exception log
     * @param i : index to error record
     * @param updateList : List of records to update
     * @param updatedRecordId : ID of record in error
     */     
    public static void handleException (integer i, Database.UpsertResult[] updateList, Id updatedRecordId) {
        Digital_Exception_Log__c ex = new Digital_Exception_Log__c();
        Database.Error error = updateList.get(i).getErrors().get(0);
        ex.Exception_Message__c = error.getMessage(); //failedDML;
        ex.Exception_Type__c = 'Record Update Error: Id - ' + updatedRecordId; //failed record from the list
        for (string errorField : error.getfields()) {
            ex.Additional_Information__c += errorField + ',';            
        }
        ex.User_Message__c = String.Valueof(error.getStatusCode());
        ex.Class_Reference__c = 'Digital_OpportunityDigitalFlagSync - Error Updating Opportunity';
        exList.add(ex);   
    } // end of error handling     
     
     
    /** 
     * @description : Internal Class
     */     
    public class Digital_OpportunityDigitalFlagSyncException extends Exception {}
    

    /** 
     * @description : Finish method - submit automation job
     * @param info : BatchableContext
     */     
    public void finish(Database.BatchableContext info) {
        // when this job finishes, schedule the automation to start 
        if (!test.isrunningtest()) {    
            Digital_ProposalAutomation dpb = new Digital_ProposalAutomation();        
            Database.executeBatch(dpb, 1);       
        }
    }
    
}