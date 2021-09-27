/**
* {Purpose} - Controller class used to manage the entries from CN_App_Settings custom setting
*
* @author	Shah Kadirmohideen
* @version	2012-01-05
*/

/**
* CHANGE HISTORY 
* =============================================================================
* Date			Name					Description
* 2012-01-05	Shah Kadirmohideen		Created
* 2012-01-20	Shah Kadirmohideen		Added 3 new custom fields to support data storage settings      
* 2012-01-26	Shah Kadirmohideen		Added validation rules
* 2012-01-30	Mike Eaton				Added with sharing 
* 2012-05-03	Shah Kadirmohideen		Added gotoDeleteAllCachePage() method
* 2012-10-03	Shah Kadirmohideen		Added support for 2 new fields (Display_General_Error_Message__c, General_Error_Message__c).
*										Added validation rule for the above two fields.	
* 2014-06-01	Mike Eaton				Added concatenation of OrgId (ie. Security Token) to WS AuthKey					
* 2014-07-08	Mike Eaton				Added resetSecurityToken
* 2014-09-10	David Sarbello			Added method to handle emailing/viewing of Audit Log
* 2014-09-10	Mike Eaton				Added CNAppUtils.insertLogEntry is various key locations
* 2014-09-10	Mike Eaton				Added gotoViewAuditLogPage() method
* 2014-09-11	Mike Eaton				Removed emailAuditLog() method stub
* 2014-11-16	Mike Eaton				Added validate for Auth_Key__c cannot be blank
* 2015-02-10	David Sarbello			Added PrimeAPIVersionOptions method
* 2015-12-12	Glen Cunningham			Added API Version call
* =============================================================================
*/ 
public with sharing class CNAppSettingsController {
	/* PUBLIC VARIABLES */
	public CN_App_Settings__c oAppSetup 			{get; set;}
	public Boolean bEditMode 						{get; set;}
	public Boolean bUseSecurityToken 				{get; set;}
	public list<SelectOption> listAPIVersionOptions {get; set;}
	
	/* PRIVATE VARIABLES */
	private CN_App_Settings__c oAppSetupOld {get; set;}
	private Boolean bIsNewSecurityToken {get; set;}
	
	/* CONSTRUCTOR */
	
	public CNAppSettingsController() {
		this.bEditMode = false;
		this.bUseSecurityToken = false;
		this.bIsNewSecurityToken = false;
		//get version based on current endpoint 
	}
	
	/* PUBLIC METHODS */	
	
	/**
		Saves the custom setting and return the control back to the current page.
		Also it redirects the control to the view page by setting the boolean flag which controls the layout on the VF page.
	*/
	public PageReference savePage() {
		Boolean bSuccess = validate();
		if (bSuccess) {
			if (oAppSetupOld.Enable_Data_Cleanup_Job__c == false  && oAppSetup.Enable_Data_Cleanup_Job__c == true) {
				System.debug('trying to schedule the job');
				oAppSetup.Data_Cleanup_Job_Id__c = CNDataCleanupJob.scheduleJob();
				if (oAppSetup.Data_Cleanup_Job_Id__c == null) {
					oAppSetup.Enable_Data_Cleanup_Job__c.addError('Job scheduling failed as there was another job scheduled by same name [' + CNConstants.DATA_CLEANUP_JOB_NAME + ']');
					bSuccess = false;
				}
			}
			else if (oAppSetupOld.Enable_Data_Cleanup_Job__c == true  && oAppSetup.Enable_Data_Cleanup_Job__c == false) {
				System.debug('trying to abort the job');
				CNDataCleanupJob.unscheduleJob(oAppSetup.Data_Cleanup_Job_Id__c);
			}
			
			System.debug('bSuccess: ' + bSuccess);
			if (bSuccess) {
				System.debug('saving the record');
				//update version info using current url
				CNServices_14 cn = new CNServices_14();
				string v = CNServices_14.ReleaseInfo(oAppSetup.WS_Endpoint__c);
				oAppSetup.WS_API_Version__c = (v!='')?v:'failed';				 	
				update oAppSetup;
				// Insert package admin audit log entry
				CNAppUtils.insertLogEntry(CNConstants.AUDIT_COMPONENT_SOURCE_PACKAGE_CONFIG, 
									CNConstants.AUDIT_ACTION_TYPE_EDIT_PACKAGE_CONFIG, 
									'User edited the BDP package configuration settings');
				
				this.bEditMode = false;
				this.oAppSetupOld = CNAppUtils.fetchExistingCustomSetting();				
			}
		}
		return null;
	}

	/**
		Redirects the control to the view page by setting the boolean flag which controls the layout on the VF page.
	*/
	public PageReference cancelPage() {
		// Insert package admin audit log entry
		CNAppUtils.insertLogEntry(CNConstants.AUDIT_COMPONENT_SOURCE_PACKAGE_CONFIG, 
									CNConstants.AUDIT_ACTION_TYPE_CANCEL_PACKAGE_CONFIG, 
									'User cancelled the edit to the BDP package configuration settings');		
		this.bEditMode = false;
		loadCustomSetting();
		return null;
	}

	/**
		Redirects the control to the edit page by setting the boolean flag which controls the layout on the VF page.
	*/
	public PageReference editPage() {
		this.bEditMode = true;
		return null;
	}
	
	/**
		Redirects the control to another VF page that starts a job to delete all cached CN records.
	*/
	public PageReference gotoDeleteAllCachePage() {
		// Insert package admin audit log entry
		CNAppUtils.insertLogEntry(CNConstants.AUDIT_COMPONENT_SOURCE_PACKAGE_CONFIG, 
									CNConstants.AUDIT_ACTION_TYPE_DELETE_PACKAGE_CACHE, 
									'User deleted all BDP relationship cache');
		return Page.CNDataCleanupAll;
	}
	
	/**
		Loads the application setting from the custom setting if present. Otherwise it initilizes using a default setup.
	*/
	public void loadCustomSetting() {
		this.oAppSetup = CNAppUtils.fetchExistingCustomSetting();
		if (this.oAppSetup == null) {
			this.oAppSetup = loadDefaultSetup();
		}

		if (oAppSetup.Enable_Data_Cleanup_Job__c == true  && dataCleanupJobExists() == false) {
			oAppSetup.Enable_Data_Cleanup_Job__c = false;
			oAppSetup.Data_Cleanup_Job_Id__c = null;
			update oAppSetup;
		}

		this.oAppSetupOld = CNAppUtils.fetchExistingCustomSetting();
		
		// Insert package admin audit log entry
		CNAppUtils.insertLogEntry(CNConstants.AUDIT_COMPONENT_SOURCE_PACKAGE_CONFIG, 
									CNConstants.AUDIT_ACTION_TYPE_VIEW_PACKAGE_CONFIG, 
									'User accessed the BDP package configuration settings');
	}

	
	/**
		Redirects to View Audit Log page
	*/
	public PageReference gotoViewAuditLogPage() {
		// Insert package admin audit log entry
		CNAppUtils.insertLogEntry(CNConstants.AUDIT_COMPONENT_SOURCE_PACKAGE_CONFIG, 
									CNConstants.AUDIT_ACTION_TYPE_VIEW_AUDIT_LOG, 
									'User clicked the BDP package configuration View Audit Log button');
											
		return Page.CNAuditLog;
	}

	/**
		Initiates a reset of the security token and sends email
	*/
	public void resetSecurityToken() {

		String sToken = CNAppUtils.getSecurityToken();
		oAppSetup.Security_Token__c = sToken;
		oAppSetup.WS_Auth_Key__c += sToken;
		update oAppSetup;

		// Send out security token confirmation
		CNAppUtils.sendSecurityToken();
		
		// Insert package admin audit log entry
		CNAppUtils.insertLogEntry(CNConstants.AUDIT_COMPONENT_SOURCE_PACKAGE_CONFIG, 
									CNConstants.AUDIT_ACTION_TYPE_RESET_SECURITY_TOKEN, 
									'User reset the BDP package configuration Security Token');

	}
	
	

	/* PRIVATE METHODS */
	
	/**
		Returns a default setup for the application
	*/
	private CN_App_Settings__c loadDefaultSetup() {
		CN_App_Settings__c oSetting = new CN_App_Settings__c();
		oSetting.Name = CNConstants.APP_SETTING_KEY;
		
		insert oSetting;
		
		oSetting = CNAppUtils.fetchExistingCustomSetting();
		return oSetting;
	}
	
	/**
		Validates the input data before saving to database. Returns true if no errors found.
	*/
	private Boolean validate() {
		Boolean bStatus = true;
		String msg = null;
		if (oAppSetup.Data_Cache_Size__c < oAppSetup.Data_Display_Size__c) {
			msg = 'Data cache size can\'t be lower than the display size.';
			oAppSetup.Data_Cache_Size__c.addError(msg);
			System.debug(msg);
			bStatus = false;
		}
		else if (oAppSetup.Data_Cache_Size__c <= 0) {
			msg = 'Data cache size should be greater than zero.';
			oAppSetup.Data_Cache_Size__c.addError(msg);
			System.debug(msg);
			bStatus = false;
		}
		else if (oAppSetup.Data_Display_Size__c <= 0) {
			msg = 'Data display size should be greater than zero.';
			oAppSetup.Data_Display_Size__c.addError(msg);
			System.debug(msg);
			bStatus = false;
		}
		else if (oAppSetup.Inner_Relationship_Data_Display_Size__c <= 0) {
			msg = 'Inner relationship data display size should be greater than zero.';
			oAppSetup.Inner_Relationship_Data_Display_Size__c.addError(msg);
			System.debug(msg);
			bStatus = false;
		}
		else if (oAppSetup.Enhanced_List_Data_Display_Size__c <= 0) {
			msg = 'Enhanced list data display size should be greater than zero.';
			oAppSetup.Enhanced_List_Data_Display_Size__c.addError(msg);
			System.debug(msg);
			bStatus = false;
		}
		else if (oAppSetup.Data_Expiration_Hours__c < 1) {
			msg = 'Data expiration hours should be greater than or equal to one.';
			oAppSetup.Data_Expiration_Hours__c.addError(msg);
			System.debug(msg);
			bStatus = false;
		}
		else if (oAppSetup.Max_Data_Storage__c <= 0) {
			msg = 'Max data storage size should be greater than zero.';
			oAppSetup.Max_Data_Storage__c.addError(msg);
			System.debug(msg);
			bStatus = false;
		}
		else if (oAppSetup.Display_General_Error_Message__c == true && CNAppUtils.isEmpty(oAppSetup.General_Error_Message__c)) {
			msg = 'General Error Message should be entered since the corresponding checkbox is enabled.';
			oAppSetup.General_Error_Message__c.addError(msg);
			System.debug(msg);
			bStatus = false;
		}
		else if (!CNAppUtils.isEmpty(oAppSetup.WS_Consumer_Name__c) && CNAppUtils.isEmpty(oAppSetup.WS_Auth_Key__c)) {
			msg = 'If the Consumer Name is defined, the Auth Key below cannot be blank!';
			oAppSetup.WS_Consumer_Name__c.addError(msg);
			System.debug(msg);
			bStatus = false;
		}
		
		System.debug('validation status: ' + bStatus);
		return bStatus; 
	}
	

	
	/**
		Checks if the data clean up job exists (using the stored job id)
	*/
	private Boolean dataCleanupJobExists() {
		if (oAppSetup.Data_Cleanup_Job_Id__c != null) {
			return [Select count() from CronTrigger where Id=:oAppSetup.Data_Cleanup_Job_Id__c] == 1;
		}
		return false;
	}


}