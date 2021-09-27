/**
* {Purpose} – 	This custom component can we used to provide a Find outputLink that
*				redirects to the Salesforce Search feature with the appropriate
				criteria searching against Contacts, Leads or Both
* {Comments} -	Controller for the CNFindContact.component
*
* @author	Mike Eaton
* @version	2012-01-20
*/
 
/**
* CHANGE HISTORY
* =============================================================================
* Date			Name			Description
* 2012-01-20	Mike Eaton		Created      
* 2013-04-25	Mike Eaton		Updated the BASE_URL_GLOBAL constant to current version used in Spring '13
* 2014-08-29	David Sarbello	Added new optional attribute to pass the AccountId when applicable.
* {Date}    	{Changed By}	({Ticket}) – {Change Description}
* =============================================================================
*/
public class CNFindContactController {

	public string searchCriteria {get;set;} 
	public boolean includeContact {get;set;}
	public boolean includeLead {get;set;}
	public boolean includeAccount {get;set;}
	public string searchURL;
	public boolean useGlobal {get;set;}

	//2014-08-29 Sarbello
	public string accountId {get;set;}
	 
	private static final string BASE_URL_BASIC = '/search/SearchResults?searchType=2';
	private static final string BASE_URL_GLOBAL = '/_ui/search/ui/UnifiedSearchResults?searchType=2';
	private static final string INCLUDE_ACCOUNT = 'sen=001';
	private static final string INCLUDE_CONTACT = 'sen=003';
	private static final string INCLUDE_LEAD = 'sen=00Q';
	
	public string getSearchURL() {
		// Which native Salesforce search should be used?
		if (useGlobal) {
			searchURL = BASE_URL_GLOBAL;
		}
		else {
			searchURL = BASE_URL_BASIC;
		}

		// Which objects should be included in the search?
		if (includeAccount) {
			searchURL += '&' + INCLUDE_ACCOUNT;
		}
		if (includeContact) { 
			searchURL += '&' + INCLUDE_CONTACT;
		}
		if (includeLead) {
			searchURL += '&' + INCLUDE_LEAD;
		}
		searchURL += '&str=' + searchCriteria;
		return searchURL;
	}
}