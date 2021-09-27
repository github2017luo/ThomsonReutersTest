/**
* {Purpose} – 
* 		Fetches the colleague information for a given contact from ContactNet. It also acts as a cache
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
* 2014-09-12  David Sarbello				Added logging for service calls
* =============================================================================
*/
public class CNContactRelationshipService extends CNListHandler {
	/* Private variables */
	private String sSFDCContId;
	private String sEmailAddress;
	private String sContactCNID;
	private static final String sClassName = 'CNContactRelationshipService';
	public CNData.CNWebserviceResult oResult;
	public static CNAppUtils.CNWebServiceQueueHandler oQueueHandler;
	//Constructor
	public CNContactRelationshipService(String sSFDCContId, String sEmailAddress) {
		this.sSFDCContId = sSFDCContId;
		this.sEmailAddress = sEmailAddress;
		this.tabName = 'Colleague';
		fetchInitialDataFromCN();
	}

	/* PUBLIC METHODS */

	//Invokes CN service to search for contact relationships based on contact email. Returns true if CN has more data to return.
	public override Boolean fetchInitialDataFromCN() {
		System.debug('fetchInitialDataFromCN starts');
		if (CNAppUtils.isEmpty(sEmailAddress)) return false;
		oResult = CNServices_14.fetchRelationshipsForContactEmail(sEmailAddress, loadCapacity);
		if(oResult==null){return null;}
		this.iTotalRecords = oResult.iTotalRelationships;		
		if (oResult.listRelationships != null) {
			System.debug('relationships found');
			for (CNData.CNRelationship oRel : oResult.listRelationships) {
				System.debug('oRel: ' + oRel);
				this.listData.add(oRel);
			}
		}
		return true;
	}

	//Fetches the relationship data from Relationship__c custom object from Salesforce
	public override Boolean fetchAllDataFromSFDC() {
		/*for (CNData.CNRelationship oRel : CNAppUtils.fetchColleaguesFromSFDC(null, sSFDCContId, CNConstants.EMBEDDED_LIST_SOQL_RECORDS_CAP, false)) {
			this.listData.add(oRel);
		}
		oQueueHandler = new CNAppUtils.CNWebServiceQueueHandler(null, sSFDCContId, null, 'Colleague');
		try{
			this.iTotalRecords = oQueueHandler.oQueue.Total_Colleague_Relationships__c.intValue();
			this.bObjectCacheFullyLoaded = true;
			return true;
		}catch(Exception e){
			return false;
		}*/
		return false;
	}

	//Invokes CN service to search for CNID based on contact email address
	public override Boolean fetchMoreDataFromCN() {
		return false;/*
		System.debug('fetching additional colleagues from CN');
		if (sContactCNID != null) {
			CNData.CNWebserviceResult oResult = CNServices_14.fetchRelationshipsForContactCNID(sContactCNID, loadCapacity+1, listData.size(), false);
			if (oResult.errorFound) {
				return false;
			}
			if (oResult.listRelationships != null) {
				for (CNData.CNRelationship rel : oResult.listRelationships) {
					this.listData.add(rel);
				}
			}
		} 
		return true;*/
	}

	//Returns the next set of records from cache or from CN
	public override List<Object> massageNextPageData(List<Object> listNextPageData) {
		return listNextPageData;
	}		 

	//Loads queue handler record from custom object
	public override void loadQueueHandler() {
		if (oQueueHandler == null) {
			this.oQueueHandler = new CNAppUtils.CNWebServiceQueueHandler(null, sSFDCContId, null, 'Contact');
		}
	} 

	//Returns the total cached relationships count
	public override Integer getCachedRelationshipsCount() {
		try{
		return oQueueHandler.oQueue.Total_Colleague_Relationships__c.intValue();
		}catch(Exception e){
			return 0;
		}
	}


	/* PUBLIC STATIC METHODS */

	//Invokes CN service to pull the rest of colleagues for the purpose of storing into local cache.
	@future (callout=true)
	public static void fetchRestOfDataFromCN_Async(String sContactCNID, Integer iStartIndex, String sContactSFDCId, String sWSQueueId) {
	/*	System.debug('fetching additional colleagues from CN (starting from 2nd page till the end of data)');
		if (CNAppUtils.isEmpty(sWSQueueId)) return;
		oQueueHandler = new CNAppUtils.CNWebServiceQueueHandler(sWSQueueId, 'Colleague');
		System.debug('oQueueHandler: ' + oQueueHandler);

		try { 
			CNData.CNWebserviceResult oResult = CNServices_14.fetchRelationshipsForContactCNID(sContactCNID, 99999, iStartIndex, true);
			System.debug('oResult.listRelationships: ' + oResult.listRelationships);
			if (oResult.errorFound) {
				oQueueHandler.updateColleagueStatus(oQueueHandler.FAILED_STATUS);
				return;
			}

			if (oResult.listRelationships != null && oQueueHandler.oQueue.Colleague_Status__c != oQueueHandler.ALL_DATA_RECEIVED_STATUS) {
				List<CN_Relationship__c> listRels = CNAppUtils.convertCNRelationshipForColleague(oResult.listRelationships, null, sContactSFDCId, sWSQueueId);  //persist into salesforce cache
				insert listRels;
				System.debug('cache inserted: ' + listRels.size());
			}

			oQueueHandler.updateColleagueStatus(oQueueHandler.ALL_DATA_RECEIVED_STATUS);
		}
		catch (Exception oException) {
			String sMoreInfo = 'Contact SFDC Id: ' + sContactSFDCId + 
					', Contact CNID: ' + sContactCNID + ', WS QueueId: ' + sWSQueueId; 
			CNAppUtils.handleException(new CNData.CNExceptionInfo(oException, ApexPages.Severity.ERROR, 
					sClassName, 'fetchRestOfDataFromCN_Async()',
					sMoreInfo, false, true, 'Colleague Webservice Future Call'));
			oQueueHandler.updateColleagueStatus(oQueueHandler.FAILED_STATUS);
		} **/
	}

}