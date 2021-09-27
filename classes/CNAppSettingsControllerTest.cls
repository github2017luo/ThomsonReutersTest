/**
* {Purpose} – Test class for CNAppSettingsController
*
* @author	Shah Kadirmohideen
* @version	2012-01-05
*/

/**
* CHANGE HISTORY
* =============================================================================
* Date			Name					Description
* 2012-01-05	Shah Kadirmohideen		Created      
* 2012-01-20	Shah Kadirmohideen		Added 3 new fields to support data storage settings
* 2012-05-01	Shah Kadirmohideen		Enhanced test method for proper data cleanup
* 2014-07-14	Mike Eaton				Deprecated assert related to gotoWebServiceQueue tab
* =============================================================================
*/
@isTest 
private class CNAppSettingsControllerTest {
	
	/**
	* Validates CNAppSetting controller operations
	*/
	@isTest (OnInstall=false)
    private static void testCustomSetting() {
    	//Delete any pre existing records from custom setting & unschedules the job
    	System.runAs(new User(Id=UserInfo.getUserId())) {
	    	List<CN_App_Settings__c> existingSettings = [Select Id, Data_Cleanup_Job_Id__c from CN_App_Settings__c limit 1];  
	    	if (existingSettings.size() == 1) {
	    		CN_App_Settings__c existingSetup = existingSettings.get(0);
	    		if (existingSetup.Data_Cleanup_Job_Id__c != null) {
	    			CNDataCleanupJob.unscheduleJob(existingSetup.Data_Cleanup_Job_Id__c);
	    		}
	    		delete existingSetup;
	    	}
    	}
    	
    	Test.startTest();
    	Test.setCurrentPage(Page.CNAppSettings);
    	Test.setMock(HttpCalloutMock.class, new CNWebServiceMockImpl());
		CNAppSettingsController oController = new CNAppSettingsController();
		
		//Validate default custom setting information
		oController.loadCustomSetting();
		System.assert(oController.oAppSetup != null, 'Custom setting default data not loaded properly');
		System.assert(oController.oAppSetup.Data_Display_Size__c == 5, 'Custom setting default data not loaded properly for field: Data Display Size');
		
		//Validate edit & schedule cleanup job
		oController.oAppSetup.Data_Display_Size__c = 2;
		oController.oAppSetup.Enable_Data_Cleanup_Job__c = true;
		oController.savePage();
		System.assert([Select Data_Display_Size__c from CN_App_Settings__c where Id=:oController.oAppSetup.Id].Data_Display_Size__c == 2, 'Data Edit did not work as intended');
		//System.assert([Select Data_Cleanup_Job_Id__c from CN_App_Settings__c where Id=:oController.oAppSetup.Id].Data_Cleanup_Job_Id__c == null, 'Data cleanup job not scheduled');
		
		//Abort the scheduled job
		oController.oAppSetup.Enable_Data_Cleanup_Job__c = false;
		oController.savePage();
		
		//Validate loading existing data
		oController = new CNAppSettingsController();
		oController.loadCustomSetting();
		System.assert(oController.oAppSetup != null, 'Custom setting pre existing data not loaded properly');
		System.assert(oController.oAppSetup.Data_Display_Size__c == 2, 'Custom setting pre existing data not loaded properly for field: Data Display Size');
		
		//Validate cancel button
		oController.cancelPage();
		System.assert(oController.bEditMode == false, 'Cancel button is not setting the boolean flag');
		
		//Validate edit button
		oController.editPage();
		System.assert(oController.bEditMode == true, 'Edit button is not setting the boolean flag');
		
		List<selectOption> sel = oController.listAPIVersionOptions;
		oController.oAppSetup.Data_Cleanup_Job_Id__c = CNDataCleanupJob.scheduleJob();
		oController.oAppSetup.Data_Cleanup_Job_Id__c = null;
		oController.savePage();
		oController.bUseSecurityToken = true;
		oController.oAppSetup.Security_Token__c = null;
		oController.savePage();
		oController.bUseSecurityToken = false;
		oController.savePage();
		PageReference p =  oController.gotoDeleteAllCachePage();
		system.assertNotEquals(null,p);
		oController.oAppSetup.Enable_Data_Cleanup_Job__c = true;
		 oController.savePage();
    	Test.stopTest();
    }
   	
	/**
	* Tests various validation rules
	*/
	@isTest (OnInstall=false)
    private static void testCustomSettingValidation() {
    	//Delete any pre existing records from custom setting & unschedules the job
    	System.runAs(new User(Id=UserInfo.getUserId())) {
	    	List<CN_App_Settings__c> existingSettings = [Select Id, Data_Cleanup_Job_Id__c from CN_App_Settings__c limit 1];  
	    	if (existingSettings.size() == 1) {
	    		CN_App_Settings__c existingSetup = existingSettings.get(0);
	    		if (existingSetup.Data_Cleanup_Job_Id__c != null) {
	    			CNDataCleanupJob.unscheduleJob(existingSetup.Data_Cleanup_Job_Id__c);
	    		}
	    		delete existingSetup;
	    	}
    	}

    	Test.startTest();
    	Test.setCurrentPage(Page.CNAppSettings);
    	Test.setMock(HttpCalloutMock.class, new CNWebServiceMockImpl());
		CNAppSettingsController oController = new CNAppSettingsController();
		oController.loadCustomSetting();
		oController.editPage();  //go to edit page
		
		oController.oAppSetup.Data_Cache_Size__c = 5;
		oController.oAppSetup.Data_Display_Size__c = 20;
		oController.oAppSetup.WS_API_Version__c = '15.3';
		oController.savePage();
		System.assertEquals(true, oController.bEditMode, 'Data display size comparision against Data cache size validation is not working');
		
		oController.oAppSetup.Data_Cache_Size__c = 0;
		oController.oAppSetup.Data_Display_Size__c = 0;
		oController.oAppSetup.WS_API_Version__c = '15.3';
		oController.savePage();
		System.assertEquals(true, oController.bEditMode, 'Data cache & display size check against zero is not working');

		oController.oAppSetup.Data_Cache_Size__c = 10;
		oController.oAppSetup.Data_Display_Size__c = 5;
		oController.oAppSetup.Inner_Relationship_Data_Display_Size__c = 0;
		oController.oAppSetup.WS_API_Version__c = '15.3';
		oController.savePage();
		System.assertEquals(true, oController.bEditMode, 'Inner relationship data display size check against zero is not working');

		oController.oAppSetup.Inner_Relationship_Data_Display_Size__c = 10;
		oController.oAppSetup.Enhanced_List_Data_Display_Size__c = 0;
		oController.oAppSetup.WS_API_Version__c = '15.3';
		oController.savePage();
		System.assertEquals(true, oController.bEditMode, 'Enhanced list data display size check against zero is not working');

		oController.oAppSetup.Enhanced_List_Data_Display_Size__c = 25;
		oController.oAppSetup.Data_Expiration_Hours__c = 0;
		oController.oAppSetup.WS_API_Version__c = '15.3';
		oController.savePage();
		System.assertEquals(true, oController.bEditMode, 'Data expiration hour check is not working');

		oController.oAppSetup.Data_Expiration_Hours__c = 4;
		oController.oAppSetup.Max_Data_Storage__c = 0;
		oController.oAppSetup.WS_API_Version__c = '15.3';
		oController.savePage();
		System.assertEquals(true, oController.bEditMode, 'Max storage size check is not working');
		
		oController.oAppSetup.Max_Data_Storage__c = 20;
		oController.oAppSetup.WS_API_Version__c = '15.3';
		oController.savePage();
		System.assertEquals(false, oController.bEditMode, 'One of the validation rule misfired');
		 
		 oController.oAppSetup.Display_General_Error_Message__c = false;
		 oController.oAppSetup.WS_API_Version__c = '15.3';
		oController.savePage();
		System.assertEquals(false, oController.bEditMode, 'One of the validation rule misfired');
		oController.resetSecurityToken();
		oController.oAppSetup.Inner_Relationship_Data_Display_Size__c = 0;
		oController.oAppSetup.WS_API_Version__c = '15.3';
		oController.savePage();
		oController.oAppSetup.WS_Consumer_Name__c = '';
		oController.oAppSetup.WS_API_Version__c = '15.3';
		oController.savePage();
		//
		oController.oAppSetup.Data_Display_Size__c = 0;
		oController.savePage();
		oController.oAppSetup.Display_General_Error_Message__c = true;
		oController.oAppSetup.General_Error_Message__c = '';
		oController.savePage();
		oController.oAppSetup.Data_Cleanup_Job_Id__c = null;
		oController.savePage();
		oController.oAppSetup.WS_Consumer_Name__c = 'test this';
		oController.oAppSetup.WS_Auth_Key__c = '';
		oController.savePage();
		oController.oAppSetup.Enable_Data_Cleanup_Job__c = true;  
		oController.oAppSetup.Data_Cleanup_Job_Id__c = null;
		oController.savePage();
		Test.stopTest();
    }
   	
}