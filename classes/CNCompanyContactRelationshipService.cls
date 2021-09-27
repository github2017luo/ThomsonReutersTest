/**
* {Purpose} – 
* 		Fetches the contacts for a given company from ContactNet. It also acts as a cache
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
* 2012-02-02	Shah Kadirmohideen		Changed variable name from 'relationshipType' to 'Type' on CNRelationship object.
*										Changed variable name from 'toContact' to 'contact' on CNRelationship object.
* 2012-01-20	Shah Kadirmohideen		Incorporated enhanced list (go to list) functionality related changes.
* 2012-07-12	Shah Kadirmohideen		Added code to prevent REQUIRED_FIELD_MISSING error while 
*										inserting relationship records
* 2012-10-05	Shah Kadirmohideen		Enhanced exception handling using handleException() method
* 2013-09-06	Mike Eaton				[CR-069] - Add support for Sensitive Data Display 
* =============================================================================
*/    
public class CNCompanyContactRelationshipService extends CNListHandler {  
	/* Private variables */  
	private String sCompanySFDCId;
	private String sCompanyCNID;
	public Integer iAlternateIndex;
	private static final String sClassName = 'CNCompanyContactRelationshipService';
	
	/* Public variables */
	public List<CNData.CNRelationship> listRelationships {get; set;}
	
	//Constructor - based on ids
	public CNCompanyContactRelationshipService(String sCompanySFDCId, String sCompanyCNID, List<CNData.CNRelationship> listRelationships, Integer iTotalRecords) {
		this.sCompanySFDCId = sCompanySFDCId;
		this.sCompanyCNID = sCompanyCNID;
		this.listRelationships = listRelationships;
		iAlternateIndex = 0;
		this.iTotalRecords = iTotalRecords;
		this.tabName = 'Contact';
		fetchInitialDataFromCN(); //GMC
	}
	
	/* PUBLIC METHODS */
	
	//Invokes CN service to search for contact relationships based on contact email.
	public override Boolean fetchInitialDataFromCN() {
		System.debug('fetching company contacts');		
		if (Test.isRunningTest()) {
			CNAppUtils.sHttpBodyInTestContext = CNUnitTest.getArrayOfCompanyXML(0, 11);
		}
		CNData.CNWebserviceResult oResult =  CNServices_14.fetchCompanyContacts('', '', sCompanyCNID, loadCapacity,listData.size() , false);
		system.debug('*********CNServices_14.fetchCompanyContacts:' + sCompanyCNID + ' ' + loadCapacity + ' ' + listData.size());
		if(oResult != null){
			if (oResult.errorFound) {
				return false;
			}
		}else{
			return false;
		}
		system.debug('total relationships and oResult:' + oResult);
		this.iTotalRecords = oResult.iTotalRelationships;
		system.debug('total contact relationships: ' + iTotalRecords);
		
		if (oResult.listContacts != null) {
			List<CNData.CNRelationship> listRelsCN = new List<CNData.CNRelationship>();
			for (CNData.CNContact oCont : oResult.listContacts) {
				CNData.CNRelationship oRel = convertContactIntoRelationship(oCont);
				if (oRel.contact.LastModificationTimeAlt != null) {
					CNPaginator.displayLastUpdateDate = true;
				}
				this.listData.add(oRel);
				listRelsCN.add(oRel);
			}
			System.debug('listRelsCN: ' + listRelsCN);
			this.listRelationships = listRelsCN;
/*
			System.debug('Contact Service - Create the master record for local cache');
			loadQueueHandler();

			try {
				oQueueHandler.createQueue();
			}
			catch (Exception e) {
				System.debug(e);
				//ignore exception as it could most likely related to duplicate records (due to concurrency issues)
			}
			
			if (oQueueHandler.oQueue != null && oQueueHandler.oQueue.Id != null) {
				System.debug('oQueueHandler.oQueue.Contact_Status__c: ' + oQueueHandler.oQueue.Contact_Status__c);
				if (oQueueHandler.oQueue.Contact_Status__c == null || 
							(oQueueHandler.oQueue.Contact_Status__c == 'Failed' && oQueueHandler.oQueue.Total_Contact_Relationships__c == 0)) {
					List<CN_Relationship__c> listRels = CNAppUtils.convertCNRelationshipForContact(listRelsCN, sCompanySFDCId, oQueueHandler.queueId);  //persist into salesforce cache
					insert listRels;
					oQueueHandler.updateContactStatus(oQueueHandler.INITIAL_DATA_RECEIVED_STATUS);
					oQueueHandler.refresh();
				}
				
				if (!Test.isRunningTest()) {
					if (oQueueHandler.oQueue.Contact_Status__c == oQueueHandler.INITIAL_DATA_RECEIVED_STATUS || 
							(oQueueHandler.oQueue.Contact_Status__c == 'Failed' && oQueueHandler.oQueue.Total_Contact_Relationships__c > 0)) {
						System.debug('invoking async call to pull additional contact relationships');
						//fetchRestOfDataFromCN_Async(oResult.sCompanyCNID, oResult.listContacts.size(), sCompanySFDCId, oQueueHandler.queueId);
					}
				}
			}*/
		}
		return true;
	}
	  
	//Fetches the relationship data from Relationship__c custom object from Salesforce
	public override Boolean fetchAllDataFromSFDC() {
		//Integer iLimit = CNAppUtils.getAppCustomSetting().Data_Cache_Size__c.intValue();
		for (CNData.CNRelationship oRel : CNAppUtils.fetchContactsFromSFDC(sCompanySFDCId, CNConstants.EMBEDDED_LIST_SOQL_RECORDS_CAP, true)) {
			this.listData.add(oRel);
			if (oRel.contact.LastModificationTimeAlt != null) {
				CNPaginator.displayLastUpdateDate = true;
			}
		}
		CNAppUtils.CNWebServiceQueueHandler oQueueHandler = new CNAppUtils.CNWebServiceQueueHandler(sCompanySFDCId, null, null, 'Contact');
		this.iTotalRecords = oQueueHandler.oQueue.Total_Contact_Relationships__c.intValue();
		this.bObjectCacheFullyLoaded = true;
		System.debug('setting bObjectCacheFullyLoaded as true for contact');
		return true;
	}
	  
	//Invokes CN service to search for CNID based on contact email address
	public override Boolean fetchMoreDataFromCN() {
		System.debug('fetching additional contacts from CN CCRS line 148');
		return false;//for debug
		/*if (sCompanyCNID != null) {
			CNData.CNWebserviceResult oResult = CNServices_14.fetchCompanyContacts('', '', sCompanyCNID, loadCapacity, listData.size(), false);
			if (oResult.errorFound) {
				return false;
			}
			if (Test.isRunningTest()) {
				CNAppUtils.sHttpBodyInTestContext = CNUnitTest.getArrayOfCompanyXML(0, 11);
			}
			if (oResult.listContacts != null) {
				for (CNData.CNContact oCont : oResult.listContacts) {
					CNData.CNRelationship oRel = convertContactIntoRelationship(oCont);
					this.listData.add(oRel);
				}
			}
		} 
		return true; */
	}
	
	//Returns the next set of records from cache or from CN
	public override List<Object> massageNextPageData(List<Object> listNextPageData) {
		System.debug('massageNextPageData starts');
		List<Object> listRelationshipSlice = new List<Object>();
		for (Object oRow : listNextPageData) {
			System.debug('row: ' + oRow);
			CNData.CNRelationship oRel = (CNData.CNRelationship) oRow;
			System.debug('oRel: ' + oRel);
			
			oRel.display = true;
			oRel.index = iAlternateIndex++;
			listRelationshipSlice.add(oRel);

			CNData.CNContact oHiddenCont = new CNData.CNContact();
			oHiddenCont.CNID = oRel.contact.CNID;
			oHiddenCont.firstName = oRel.contact.firstName;
			oHiddenCont.lastName = oRel.contact.lastName;
			oHiddenCont.emailAddresses = oRel.contact.emailAddresses;
			
			CNData.CNRelationship oHiddenRelationship = new CNData.CNRelationship();
			oHiddenRelationship.contact = oHiddenCont;
			oHiddenRelationship.display = false;
			oHiddenRelationship.index = iAlternateIndex++;
			listRelationshipSlice.add(oHiddenRelationship);
			
		}
		
		return listRelationshipSlice;
	}	

	//Loads queue handler record from custom object
	public override void loadQueueHandler() {
		if (oQueueHandler == null) {
			this.oQueueHandler = new CNAppUtils.CNWebServiceQueueHandler(sCompanySFDCId, null, sCompanyCNID, 'Contact');
		}
	}

	//Returns the total cached relationships count
	public override Integer getCachedRelationshipsCount() {
		return oQueueHandler.oQueue.Total_Contact_Relationships__c.intValue();	
	}

	/* PUBLIC STATIC METHODS */
	
	//Invokes CN service to pull rest of contacts from CN
	@future (callout=true)
	public static void fetchRestOfDataFromCN_Async(String sCompanyCNID, Integer iStartIndex, String sCompanySFDCId, String sWSQueueId) {
		System.debug('ASYNC: fetching additional contacts from CN (starting from 2nd page till the end of data)');
		if (CNAppUtils.isEmpty(sWSQueueId)) return;
		CNAppUtils.CNWebServiceQueueHandler oQueueHandler = new CNAppUtils.CNWebServiceQueueHandler(sWSQueueId, 'Contact');
		System.debug('oQueueHandler.oQueue: ' + oQueueHandler.oQueue);
		return;//for debug purposes	
		try {
			CNData.CNWebserviceResult oResult = CNServices_14.fetchCompanyContacts('', '', sCompanyCNID, 99999, iStartIndex, true);
			System.debug('oResult.listContacts: ' + oResult.listContacts);
			if (oResult.errorFound) {
				oQueueHandler.updateContactStatus(oQueueHandler.FAILED_STATUS);
				return;
			}

			if (oResult.listContacts != null && oQueueHandler.oQueue.Contact_Status__c != oQueueHandler.ALL_DATA_RECEIVED_STATUS) {
				List<CNData.CNRelationship> listRelsCN = new List<CNData.CNRelationship>();
				for (CNData.CNContact oCont : oResult.listContacts) {
					CNData.CNRelationship oRel = convertContactIntoRelationship(oCont);
					listRelsCN.add(oRel);
				}
				List<CN_Relationship__c> listRels = CNAppUtils.convertCNRelationshipForContact(listRelsCN, sCompanySFDCId, sWSQueueId);
				insert listRels;
				System.debug('cache inserted: ' + listRels.size());
			}
			
			oQueueHandler.updateContactStatus(oQueueHandler.ALL_DATA_RECEIVED_STATUS);
		}
		catch (Exception oException) {
			String sMoreInfo = 'Account SFDC Id: ' + sCompanySFDCId + 
								', Account CNID: ' + sCompanyCNID + ', WS QueueId: ' + sWSQueueId; 
			CNAppUtils.handleException(new CNData.CNExceptionInfo(oException, ApexPages.Severity.ERROR, 
					sClassName, 'fetchRestOfDataFromCN_Async()',
					sMoreInfo, false, true, 'Contact Webservice Future Call'));
			oQueueHandler.updateContactStatus(oQueueHandler.FAILED_STATUS);
		} 
	}
	
	/* PRIVATE METHODS */
	
	//Restructures the relationship data
	public static CNData.CNRelationship convertContactIntoRelationship(CNData.CNContact oCont) {

		//[CR-069] M.Eaton - Add unavailable data support 
		if (oCont.getFirstEmail() == null) {
			oCont.emailAddresses.add('Email ' + CNAppUtils.getDataSensitiveDefault());
		}
		if (oCont.getFirstPhoneNumber() == null) {
			//oCont.phones = new List<CNData.CNPhone>{new CNData.CNPhone('Phone ' + CNAppUtils.getDataSensitiveDefault(), '')};
			oCont.phones = new List<CNData.CNPhone>{new CNData.CNPhone(' ' + CNAppUtils.getDataSensitiveDefault(), '')};
		}
		
		CNData.CNRelationship oRel = new CNData.CNRelationship();
		oRel.contact = oCont;
		oRel.Type = 'toContact';
		oRel.score = oCont.score;
		
		oRel.normalizedScore = oCont.normalizedScore;
		oRel.sources = oCont.sources;
		//set graph display values
		if(oCont.score>0.49){oRel.d1 = 'selected';}
		if(oCont.score>1.49){oRel.d2 = 'selected';}
		if(oCont.score>2.49){oRel.d3 = 'selected';}
		if(oCont.score>3.49){oRel.d4 = 'selected';}
		if(oCont.score>4.49){oRel.d5 = 'selected';}
		if(oCont.score>5.49){oRel.d6 = 'selected';}
		if(oCont.score>6.49){oRel.d7 = 'selected';}
		system.debug('############score=' + oCont.score + ' d1=' + oRel.d1);
		
		
		CNData.CNCompany oComp = new CNData.CNCompany();
		System.debug('firstName: ' + oCont.firstName + ', lastName: ' + oCont.lastName + ', oCont: ' + oCont);
		if (oCont.company != null) {
			oComp.CNID = oCont.company.CNID;
		}
		oRel.company = oComp;
		
		return oRel;
	}
	
	
}