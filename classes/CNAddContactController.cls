/**
* {Purpose} – 	This custom component can be used to provide 'Add' outputLink that
*				redirects to the Salesforce new contact create page. Even if the create
*				page was overridden with any custom page, this controller will redirect
*				to that page properly.
* {Comments} -	Controller for the CNAddContact.component
*
* @author	Shah Kadirmohideen
* @version	2012-07-12
*/
 
/**
* CHANGE HISTORY
* =============================================================================
* Date			Name					Description
* 2012-07-12	Shah Kadirmohideen		Created      
* {Date}    	{Changed By}	({Ticket}) – {Change Description}
* =============================================================================
*/
public class CNAddContactController {
	
	//Constant to define the constant parameters used to prepare the add contact URL
	private static final String PARAM_FIRSTNAME = 'name_firstcon2';
	private static final String PARAM_LASTNAME = 'name_lastcon2';
	private static final String PARAM_TITLE = 'con5';
	private static final String PARAM_PHONE = 'con10';
	private static final String PARAM_MOBILE = 'con12';
	private static final String PARAM_EMAIL = 'con15';
	private static final String PARAM_ACCOUNTID = 'con4_lkid'; 
	private static final String PARAM_STREETADDRESS = 'con18street';
	private static final String PARAM_LOCALITY = 'con18city';
	private static final String PARAM_REGION = 'con18state';
	private static final String PARAM_POSTALCODE = 'con18zip';
	//Variables that hold the main attributes of the contact	
	public String firstName {get; set;}
	public String lastName {get; set;}
	public String title {get; set;}
	public String phone {get; set;}
	public String mobile {get; set;}
	public String email {get; set;}
	public String accountId {get; set;} 
	public String MailingAddress {get; set;}
	public String MailingCity {get; set;}
	public String MailingState {get; set;}
	public String MailingPostalCode {get; set;}
	//Prepares the add contact URL by using a relative URL along with some of the default parameters 
	public string getAddURL() {
		//Prepare the params
		Map<String, String> mapParams = new Map<String, String>();
		mapParams.put(PARAM_STREETADDRESS, removeNull(MailingAddress));
		mapParams.put(PARAM_LOCALITY, removeNull(MailingState));
		mapParams.put(PARAM_REGION, removeNull(MailingCity));
		mapParams.put(PARAM_POSTALCODE, removeNull(MailingPostalCode));
		mapParams.put(PARAM_FIRSTNAME, removeNull(firstName));
		mapParams.put(PARAM_LASTNAME, removeNull(lastName));
		mapParams.put(PARAM_TITLE, removeNull(title));
		mapParams.put(PARAM_PHONE, removeNull(phone));
		mapParams.put(PARAM_MOBILE, removeNull(mobile));
		mapParams.put(PARAM_EMAIL, removeNull(email));
		mapParams.put(PARAM_ACCOUNTID, removeNull(accountId)); 
		
		
		//Prepare the main URL
		String sContObjectPrefix = Schema.SObjectType.Contact.getKeyPrefix();
		String sAddURL = '/' + sContObjectPrefix + '/e';
		
		//Concatenate the params to the URL
		sAddURL = CNAppUtils.prepareURL(sAddURL, mapParams, true);
		
		return sAddURL;
	}
	
	/* PRIVATE METHODS */
	
	//Replaces null value with empty space
	private String removeNull(String sData) {
		return sData == null ? '' : sData;
	}
}