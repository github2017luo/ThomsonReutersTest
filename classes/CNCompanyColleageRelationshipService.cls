/**
* {Purpose} – 
* 		Fetches the colleagues for a given company from ContactNet. It also acts as a cache
* 		by keeping bulk data and provides only subset to the caller based on pagination parameters.
*
* @author	Shah Kadirmohideen
* @version	2011-11-16
*/

/** 
* CHANGE HISTORY
* =============================================================================
* Date			Name					Description
* 2011-11-16	Shah Kadirmohideen		Created      
* 2012-01-20	Shah Kadirmohideen		Incorporated enhanced list (go to list) functionality related changes.
* 2012-07-12	Shah Kadirmohideen		Added code to prevent REQUIRED_FIELD_MISSING error while 
*										inserting relationship records
* 2012-10-05	Shah Kadirmohideen		Enhanced exception handling using handleException() method
* 2014-09-12  David Sarbello				Added logging calls
* =============================================================================
*/     
public class CNCompanyColleageRelationshipService extends CNListHandler {
	/* Private variables */
	private String sCompanySFDCId;
	private String sCompanyName;
	private String sEmailDomain;
	public Integer iAlternateIndex;
	private static final String sClassName = 'CNCompanyColleageRelationshipService';
	  
	/* Public variables */
	public String companyCNID = '';
	public List<CNData.CNRelationship> listContactRelationships;
	public Integer iTotalContactRecords;
	
	//Constructor
	public CNCompanyColleageRelationshipService(String sCompanySFDCId,String sCompanyCNID, String sCompanyName, String sEmailDomain) {
		this.sCompanySFDCId = sCompanySFDCId;
		this.sCompanyName = sCompanyName;
		this.sEmailDomain = sEmailDomain;
		iAlternateIndex = 0;
		this.tabName = 'Colleague';
		companyCNID = sCompanyCNID;// CNServices_14.CNCompanyID;
		system.debug('*******CNCompanyColleageRelationshipService returned ' + sCompanyCNID);//CNServices_14.CNCompanyID);
		//fetchInitialDataFromCN(); 
		fetch();
	}
	
	/* PUBLIC METHODS */
	public boolean fetch(){
		if(companyCNID == null){return false;}
		cnservices_14 cn = new cnservices_14();
		String sJSON = cnservices_14.SearchResults(   '1', '{"Companies":[{"Id":"' + companyCNID +'"}]}','0','10');
		System.debug('sJSON Returned from fetch' + sJSON);
		if(sJSON=='{"Message":"An error has occurred."}'||sJSON==''){return false;} 
		CNData_14_Colleague oColleagues = CNData_14_Colleague.parse(sJSON);
		system.debug('managed to parse oColleagues result is:' + oColleagues.Results.size());
		System.debug('fetching initial colleagues from CN. sCompanyName: ' + sCompanyName + ', sEmailDomain: ' + sEmailDomain);
		if (CNAppUtils.isNonEmpty(sEmailDomain)){ sCompanyName = '';}//prefer to use domain for lookup not actual company name
		if (sEmailDomain == null){ sEmailDomain = '';}
		
		// Retrieve initial displayable records based on package config settings
		system.debug('@#$%@#$%@Call into CNServices_14.fetchCompanyColleagues ' + sCompanyName + ' ' + sEmailDomain);
		CNData.CNWebserviceResult oResult = CNServices_14.fetchCompanyColleagues(sCompanyName, sEmailDomain, '', loadCapacity , 0, false);
		system.debug('@#$%@#$%@Result of Call into CNServices_14.fetchCompanyColleagues ' + oResult);
		
		
		
		System.debug('@#$%@#$%@Result of Call into CNServices_14.fetchCompanyColleagues oResult.errorFound: ' + oResult.errorFound);
		if (oResult.errorFound==true) {return false;}
		this.companyCNID = oResult.sCompanyCNID;
		this.iTotalRecords = oResult.iTotalRelationships;
		System.debug('@#$%@#$%@Result of Call into CNServices_14.fetchCompanyColleagues oResult.iTotalRelationships: ' + oResult.iTotalRelationships);
		if (oResult.listRelationships.size()>0) {
			for (CNData.CNRelationship rel : oResult.listRelationships) {
				if(rel != null){
					this.listData.add(rel);
					system.debug('======>relationship:' + rel);
				}
			}
			//We are making this call to avoid "uncommitted changes error"
			System.debug('making contacts API call from colleague service - start');			
			CNCompanyContactRelationshipService oContactService = new CNCompanyContactRelationshipService(sCompanySFDCId, CNServices_14.CNCompanyID, null, 0);			
			 
			if (ApexPages.getMessages() != null && ApexPages.getMessages().size() > 0) {
				System.debug('Since error found while fetching contact relationships, skipping the rest of the logic');
				return false;
			}
			this.listContactRelationships = oContactService.listRelationships;
			this.iTotalContactRecords = oContactService.iTotalRecords;
			System.debug('making contacts API call from colleague service - end'); 
			
			System.debug('Colleague Service - Create the master record for local cache');
			loadQueueHandler();
		}
		return true;
	}
	//Invokes CN service to search for contact relationships based on contact email.
	public override Boolean fetchInitialDataFromCN() {
		
		System.debug('fetching initial colleagues from CN. sCompanyName: ' + sCompanyName + ', sEmailDomain: ' + sEmailDomain);
		if (CNAppUtils.isNonEmpty(sEmailDomain)){ sCompanyName = '';}//prefer to use domain for lookup not actual company name
		if (sEmailDomain == null){ sEmailDomain = '';}
		
		// Retrieve initial displayable records based on package config settings
		system.debug('@#$%@#$%@Call into CNServices_14.fetchCompanyColleagues ' + sCompanyName + ' ' + sEmailDomain);
		CNData.CNWebserviceResult oResult = CNServices_14.fetchCompanyColleagues(sCompanyName, sEmailDomain, '', loadCapacity , 0, false);
		system.debug('@#$%@#$%@Result of Call into CNServices_14.fetchCompanyColleagues ' + oResult);
		
		// Insert Audit Log
		CNAppUtils.insertLogEntry('Account Component - Colleagues Tab', 'Web service callout - Sync', 
									'Web service call for: ' + sCompanyName + '. Email domain: '+sEmailDomain, sCompanySFDCId, null);
		
        if(oResult == null) {
            return false;
        }
		System.debug('@#$%@#$%@Result of Call into CNServices_14.fetchCompanyColleagues oResult.errorFound: ' + oResult.errorFound);
		if (oResult.errorFound==true) {return false;}
		this.companyCNID = oResult.sCompanyCNID;
		this.iTotalRecords = oResult.iTotalRelationships;
		System.debug('@#$%@#$%@Result of Call into CNServices_14.fetchCompanyColleagues oResult.iTotalRelationships: ' + oResult.iTotalRelationships);
		if (oResult.listRelationships.size()>0) {
			for (CNData.CNRelationship rel : oResult.listRelationships) {
				if(rel != null){
					this.listData.add(rel);
					system.debug('======>relationship:' + rel);
				}
			}
			//We are making this call to avoid "uncommitted changes error"
			System.debug('making contacts API call from colleague service - start');			
			CNCompanyContactRelationshipService oContactService = new CNCompanyContactRelationshipService(sCompanySFDCId, CNServices_14.CNCompanyID, null, 0);			
			 
			if (ApexPages.getMessages() != null && ApexPages.getMessages().size() > 0) {
				System.debug('Since error found while fetching contact relationships, skipping the rest of the logic');
				return false;
			}
			this.listContactRelationships = oContactService.listRelationships;
			this.iTotalContactRecords = oContactService.iTotalRecords;
			System.debug('making contacts API call from colleague service - end'); 
			
			System.debug('Colleague Service - Create the master record for local cache');
			loadQueueHandler();
			
			try {
				oQueueHandler.createQueue();
			}
			catch (Exception e) {
				System.debug('create queue faild exception: ' + e);
				//ignore exception as it could most likely related to duplicate records (due to concurrency issues)
			}
				
			if (oQueueHandler.oQueue != null && oQueueHandler.oQueue.Id != null) {
				System.debug('oQueueHandler: ' + oQueueHandler);
				if (oQueueHandler.oQueue.Colleague_Status__c == null || 
												(oQueueHandler.oQueue.Colleague_Status__c == 'Failed' && oQueueHandler.oQueue.Total_Colleague_Relationships__c == 0)) {
					System.debug('trying to create colleague relationship records');
					List<CN_Relationship__c> listRels = CNAppUtils.convertCNRelationshipForColleague(oResult.listRelationships, sCompanySFDCId, null, oQueueHandler.queueId);
					System.debug('listRels: ' + listRels.size());  
					insert listRels;
					oQueueHandler.updateColleagueStatus(oQueueHandler.INITIAL_DATA_RECEIVED_STATUS);
					oQueueHandler.refresh();
				}
	
				if (!Test.isRunningTest()) {
					if (oQueueHandler.oQueue.Colleague_Status__c == oQueueHandler.INITIAL_DATA_RECEIVED_STATUS || 
							(oQueueHandler.oQueue.Colleague_Status__c == 'Failed' && oQueueHandler.oQueue.Total_Colleague_Relationships__c > 0)) {
						System.debug('invoking async call to pull additional colleague relationships');
						
					
						//fetchRestOfDataFromCN_Async(CNServices_14.CNCompanyID, oResult.listRelationships.size(), sCompanySFDCId, oQueueHandler.queueId);
						
						
					}
				}
			}
		}
		return true;
	}
	
	//Fetches the relationship data from Relationship__c custom object from Salesforce
	public override Boolean fetchAllDataFromSFDC() {
		//Integer iLimit = CNAppUtils.getAppCustomSetting().Data_Cache_Size__c.intValue();
		for (CNData.CNRelationship oRel : CNAppUtils.fetchColleaguesFromSFDC(sCompanySFDCId, null, CNConstants.EMBEDDED_LIST_SOQL_RECORDS_CAP, true)) {
			this.listData.add(oRel);
			if (oRel.company != null) {
				this.companyCNID = oRel.company.CNID;
			}
		}
		CNAppUtils.CNWebServiceQueueHandler oQueueHandler = new CNAppUtils.CNWebServiceQueueHandler(sCompanySFDCId, null, CNServices_14.CNCompanyID, 'Colleague');
		/*
		CNAppUtils.insertLogEntry('Account Component', 'Call to Cache', 'Colleague', sCompanySFDCId, null);		
		*/
		this.iTotalRecords = oQueueHandler.oQueue.Total_Colleague_Relationships__c.intValue();
		this.bObjectCacheFullyLoaded = true;
		
		return true;
	} 
	
	//Invokes CN service to search for CNID based on contact email address
	public override Boolean fetchMoreDataFromCN() {
		System.debug('fetching additional colleagues from CN');
		if (companyCNID != null) {
			CNData.CNWebserviceResult oResult = CNServices_14.fetchCompanyColleagues('', '', CNServices_14.CNCompanyID, loadCapacity, listData.size(), false);
			
			/*
			// Insert Audit Log
			CNAppUtils.insertLogEntry('Account Component - Colleagues Tab', 'Web service callout - Sync', 
										'Web service call for: ' + sCompanyName + '. Email domain: '+sEmailDomain, sCompanySFDCId, null);			
			*/
			if (oResult.errorFound) {
				return false;
			}
			if (oResult.listRelationships != null) {
				for (CNData.CNRelationship rel : oResult.listRelationships) {
					this.listData.add(rel);
				}
			}
		} 
		return true; 
	}
	
	//Returns the next set of records from cache or from CN
	public override List<Object> massageNextPageData(List<Object> listNextPageData) {
		List<Object> listRelationshipSlice = new List<Object>();
		for (Object oRow : listNextPageData) {
			CNData.CNRelationship oRel = (CNData.CNRelationship) oRow; 
			oRel.display = true;
			oRel.index = iAlternateIndex++;
			listRelationshipSlice.add(oRel);

			CNData.CNColleague oHiddenCol = new CNData.CNColleague();
			oHiddenCol.CNID = oRel.colleague.CNID;
			oHiddenCol.firstName = oRel.colleague.firstName;
			oHiddenCol.lastName = oRel.colleague.lastName;
			oHiddenCol.emailAddresses = oRel.colleague.emailAddresses;
			
			CNData.CNRelationship oHiddenRelationship = new CNData.CNRelationship();
			oHiddenRelationship.colleague = oHiddenCol;
			oHiddenRelationship.display = false;
			oHiddenRelationship.index = iAlternateIndex++;
			listRelationshipSlice.add(oHiddenRelationship);
		}
		
		return listRelationshipSlice;
	}	
	
	//Loads queue handler record from custom object
	public override void loadQueueHandler() {
		if (oQueueHandler == null) {
			this.oQueueHandler = new CNAppUtils.CNWebServiceQueueHandler(sCompanySFDCId, null, CNServices_14.CNCompanyID, 'Colleague');
		}
	}
	
	//Returns the total cached relationships count
	public override Integer getCachedRelationshipsCount() {
		return oQueueHandler.oQueue.Total_Colleague_Relationships__c.intValue();	
	}
	
	/* PUBLIC STATIC METHODS */
	
	//Invokes CN service to pull rest of colleagues from CN
	@future (callout=true)
	public static void fetchRestOfDataFromCN_Async(String sCompanyCNID, Integer iStartIndex, String sCompanySFDCId, String sWSQueueId) {
		System.debug('fetching additional colleagues from CN (starting from 2nd page till the end of data)');
		if (CNAppUtils.isEmpty(sWSQueueId)) return;
		CNAppUtils.CNWebServiceQueueHandler oQueueHandler = new CNAppUtils.CNWebServiceQueueHandler(sWSQueueId, 'Colleague');
		System.debug('oQueueHandler.oQueue: ' + oQueueHandler.oQueue);
		try {

			CNData.CNWebserviceResult oResult = CNServices_14.fetchCompanyColleagues('', '', CNServices_14.CNCompanyID, 99999, iStartIndex, true);
			System.debug('oResult.listRelationships: ' + oResult.listRelationships);
			if (oResult.errorFound) {
				oQueueHandler.updateColleagueStatus(oQueueHandler.FAILED_STATUS);
				return;
			}
			
			if (oResult.listRelationships != null && oQueueHandler.oQueue.Colleague_Status__c != oQueueHandler.ALL_DATA_RECEIVED_STATUS) {
				List<CN_Relationship__c> listRels = CNAppUtils.convertCNRelationshipForColleague(oResult.listRelationships, sCompanySFDCId, null, sWSQueueId);  //persist into salesforce cache
				insert listRels;
				System.debug('cache inserted: ' + listRels.size());
			}
			oQueueHandler.updateColleagueStatus(oQueueHandler.ALL_DATA_RECEIVED_STATUS);

			/*
			// Insert Audit Log
			CNAppUtils.insertLogEntry_Sync('Account Component - Colleagues Tab', 'Web service callout - Async', 
										'Web service callout', sCompanySFDCId, null);
			*/
		}
		catch (Exception oException) {
			String sMoreInfo = 'Account SFDC Id: ' + sCompanySFDCId + ', Account CNID: ' + sCompanyCNID + ', WS QueueId: ' + sWSQueueId; 
			CNAppUtils.handleException(new CNData.CNExceptionInfo(oException, ApexPages.Severity.ERROR, 
					sClassName, 'fetchRestOfDataFromCN_Async()',
					sMoreInfo, false, true, 'Colleague Webservice Future Call'));
			oQueueHandler.updateColleagueStatus(oQueueHandler.FAILED_STATUS);
		} 
	}
	
}