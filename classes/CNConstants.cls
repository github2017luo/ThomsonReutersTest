/**
* {Purpose} – Contains all constants
*
* @author	Shah Kadirmohideen
* @version	2011-10-26
*/

/**
* CHANGE HISTORY
* =============================================================================
* Date			Name					Description
* 2011-10-26	Shah Kadirmohideen		Created
* 2012-02-02	Shah Kadirmohideen		Replaced URL_PARAM_XML variable to URL_PARAM_JSON      
* 2012-01-20	Shah Kadirmohideen		Incorporated enhanced list (go to list) functionality related changes.
* 2012-07-12	Shah Kadirmohideen		Added support for calendar icon display
* 2012-10-02	Shah Kadirmohideen		Added more constants (EXCEPTION_HEADER_MSG, EXCEPTION_EMAIL_FOOTER_MSG) 
* 2013-09-12	Mike Eaton				[CR-063] Added SOURCE_TYPE_ISSIGNATURE constant
* 2014-07-13	Mike Eaton				Added SECURITY_TOKEN_LENGTH = 25
* 2014-09-10	Mike Eaton				Added Audit Log constants
* 2014-09-12	Mike Eaton				Added DEBUG_MODE
* 2014-09-23	David Sarbello			Added API Version Constants section
* =============================================================================
*/
public class CNConstants {
	   
	//Custom setting keys
	public static final String APP_SETTING_KEY = 'CNAPP';
	
	//Debug constants
	public static final Boolean DEBUG_MODE = true;
	  
	//URL merge fields related constants.
	public static final String MERGE_FIELD_ID= '{ID}';
	public static final String MERGE_FIELD_EMAIL = '{EMAIL}';
	public static final String MERGE_FIELD_CNID = '{CNID}';	
	public static final String MERGE_FIELD_COMPANY_CNID = '{CompanyCNID}';	
	public static final String MERGE_FIELD_COMPANY_NAME = '{CompanyName}';	
	public static final String MERGE_FIELD_COMPANY_DOMAIN = '{CompanyDomain}';	
	public static final String MERGE_FIELD_FIRST = '{First}';  //index	
	public static final String MERGE_FIELD_TOP = '{Top}';  //records count or size
	public static final String MERGE_FIELD_INCLUDE_FIRST = '{IncludeFirst}';
	public static final String MERGE_FIELD_INCLUDE_TOP = '{IncludeTop}';
	
	//URL parameter names		
	public static final String URL_PARAM_APP = 'app';
	public static final String URL_PARAM_AUTHKEY = 'authKey';
	public static final String URL_PARAM_FORMAT = 'format';
	public static final String URL_PARAM_JSON = 'json';
	
	//Source type constants
	public static final String SOURCE_TYPE_ISCALENDAR = 'IsCalendar';
	public static final String SOURCE_TYPE_ISEMAIL = 'IsEmail';
	public static final String SOURCE_TYPE_ISADDRESSBOOK = 'IsAddressBook';
	public static final String SOURCE_TYPE_ISPHONE = 'IsPhone';
	public static final String SOURCE_TYPE_ISCRM = 'IsInterAction';
	public static final String SOURCE_TYPE_ISBILLING = 'IsTimeAndBilling';
	public static final String SOURCE_TYPE_ISSIGNATURE = 'IsSignature';
	public static final String SOURCE_TYPE_ISVISIT = 'IsVisit';
	public static final String SOURCE_TYPE_ISACCNTMGR = 'IsAccntMgr';
	public static final String SOURCE_TYPE_ISIARELATIONSHIP = 'IsIAReleationship';
	public static final String SOURCE_TYPE_ISREFERRAL = 'IsReferral';
	//Relationship type constants
	public static final String RELATIONSHIP_TYPE_TOCONTACT = 'toContact';
	public static final String RELATIONSHIP_TYPE_TOCOMPANY = 'toCompany';
	public static final String RELATIONSHIP_TYPE_TOINDUSTRY = 'toIndustry';
	
	//Page constants
	public static final Integer PAGE_SIZE_CAP = 10; //Maximum no of records displayed each time during pagination
	
	//Other constants
	public static final Integer EMBEDDED_LIST_SOQL_RECORDS_CAP = 100; //Maximum no of records fetched from custom object for the main embedded list page.
	public static final Integer GOTO_LIST_LINK_DISPLAY_POLLER_MAX_ATTEMPTS = 10;
	public static final String ERROR_EMAIL_SENDER_DISPLAY_NAME = 'ContactNet Integration';
	public static final Integer DATA_CLEANUP_JOB_BATCH_SIZE = 50;
	public static String DATA_CLEANUP_JOB_NAME = 'CNDataCleanupJob';
	public static final Integer SECURITY_TOKEN_LENGTH = 25;
	
	public static final String EXCEPTION_HEADER_MSG = 'The Business Development Premier application has experienced an unexpected error. ' +
							'Should this message persists, please contact your System Administrator and provide tracking id {TOKEN}';
	public static final String EXCEPTION_EMAIL_FOOTER_MSG = 'This email was auto generated by Business Development Premier for Salesforce Integration. ' + 
																'Don\'t reply to this message.';	
		
	//Contact page related APIs
	public static final String CONTACT_SEARCH_AND_RELATIONSHIP_API = 'contacts?emailAddress=' + MERGE_FIELD_EMAIL + 
						'&includeRelationships=true&top=1&includeTop=' + MERGE_FIELD_INCLUDE_TOP;  //search for a contact using email address & returns the colleagues
	public static final String CONTACT_RELATIONSHIP_API = 'contacts/' + MERGE_FIELD_CNID + '/relationships?' + 
						'top=' + MERGE_FIELD_TOP + '&first=' + MERGE_FIELD_FIRST;  //fetch relationships for a given contact

	//Company page related APIs
	public static final String COLLEAGUE_RELATIONSHIP_API = 'colleagues/' + MERGE_FIELD_CNID + '/relationships?' + 
						'companyId=' + MERGE_FIELD_COMPANY_CNID + '&top=' + MERGE_FIELD_TOP + '&first=' + MERGE_FIELD_FIRST;  //fetch contacts for a given colleague
	public static final String COMPANY_COLLEAGUES_API = 'companies?name=' + MERGE_FIELD_COMPANY_NAME + '&domain=' + MERGE_FIELD_COMPANY_DOMAIN + '&IDs=' + MERGE_FIELD_ID +  
						'&includeContacts=false&includeCompanyRelationships=true&includeDeepRelationships=false&top=1&includeTop=' + MERGE_FIELD_INCLUDE_TOP +
						'&includeFirst=' + MERGE_FIELD_INCLUDE_FIRST;  //fetch colleagues for a given company
	public static final String COMPANY_CONTACTS_API = 'companies?name=' + MERGE_FIELD_COMPANY_NAME + '&domain=' + MERGE_FIELD_COMPANY_DOMAIN + '&IDs=' + MERGE_FIELD_ID +  
						'&includeContacts=true&includeCompanyRelationships=false&includeDeepRelationships=false&top=1&includeTop=' + MERGE_FIELD_INCLUDE_TOP +
						'&includeFirst=' + MERGE_FIELD_INCLUDE_FIRST;  //fetch contacts for a given company


	//Audit Log constants
	public static final String AUDIT_COMPONENT_SOURCE_PACKAGE_CONFIG = 'Package Administration';
	public static final String AUDIT_ACTION_TYPE_VIEW_PACKAGE_CONFIG = 'View Config';
	public static final String AUDIT_ACTION_TYPE_EDIT_PACKAGE_CONFIG = 'Edit Config';
	public static final String AUDIT_ACTION_TYPE_CANCEL_PACKAGE_CONFIG = 'Cancelled Edit Config';
	public static final String AUDIT_ACTION_TYPE_DELETE_PACKAGE_CACHE = 'Delete Cache';
	public static final String AUDIT_ACTION_TYPE_VIEW_AUDIT_LOG = 'View Audit Log';
	public static final String AUDIT_ACTION_TYPE_DOWNLOAD_AUDIT_LOG = 'Download Audit Log';
	public static final String AUDIT_ACTION_TYPE_RESET_SECURITY_TOKEN = 'Reset Security Token';
	
	//Report Name Constants
	public static final String AUDIT_LOG_REPORT_SANITIZED = 'CN_Audit_Log_sanitized';
	public static final String AUDIT_LOG_REPORT_NON_SANITIZED = 'CN_Audit_Log_non_sanitized';
	
	
}