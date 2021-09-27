/**
* {Purpose} – Test class for CNAuditLogController.
*
* @author	David Sarbello
* @version	2014-09-10
*/

/**
* CHANGE HISTORY
* =============================================================================
* Date			Name					Description
* 2014-09-11	David Sarbello			Created      
* =============================================================================
*/
@isTest(SeeAllData=true)
private class CNAuditLogControllerTest {
	
	

    /**
    * Validates Constructor.
    */
    @isTest (OnInstall=false)
    private static void test_Constructor() {
        //Note the use of startTest() and stopTest() because LogEntry calls an @future method
        Test.startTest();  

		Account a = CNUnitTest.getAccount(true);

		CNAppUtils.insertLogEntry('Account Component', 'Initial Load','Component was loaded', a.id, null);
		
        Test.stopTest();
        
        CNAuditLogController oController = new CNAuditLogController();

		List<CN_Audit_Log__c> auditLogs = oController.oauditLogs;

        CN_Audit_Log__c oLog = [Select Id, Account__c from CN_Audit_Log__c Where Account__c=:a.id and Action_Type__c='Initial Load' LIMIT 1];

        System.assert(auditLogs.size() > 0,'CNAuditLogController logic not working');
 
    } 	

    
    /**
    * Validates getSupportNotificationEmail.
    */
    @isTest (OnInstall=false)
    private static void test_getSupportNotificationEmail() {  

    	//09.15.14 CN_App_Settings__c csSettings = CNUnitTest.initializeCustomSetting();
    	CN_App_Settings__c csSettings = CNAppUtils.getAppCustomSetting();
    	
    	Test.startTest();
    	
		Account a = CNUnitTest.getAccount(true);

		CNAppUtils.insertLogEntry('Account Component', 'Initial Load','Component was loaded', a.id, null);
		
		Test.stopTest();
		
    	CNAuditLogController oController = new CNAuditLogController();

    	String s = oController.getSupportNotificationEmail();

		System.assertEquals(s, csSettings.Support_Notification_Email__c,'getSupportNotificationEmail logic not working');

    }  

    /**
    * Validates initialLoad.
    */
    @isTest (OnInstall=false)
    private static void test_initialLoad() {  

    	//09.15.14 CN_App_Settings__c csSettings = CNUnitTest.initializeCustomSetting();
    	CN_App_Settings__c csSettings = CNAppUtils.getAppCustomSetting();

    	CNAuditLogController oController = new CNAuditLogController();

		Test.startTest();

    	oController.initialLoad();
		oController.fetchReportURL();
		List<CN_App_Settings__c> sett = [Select Id,Exclude_Sensitive_Audit_Log_Data__c from CN_App_Settings__c order by createddate desc limit 1];
		sett[0].Exclude_Sensitive_Audit_Log_Data__c = true;
		update sett;
		oController.fetchReportURL();
		Test.stopTest();

		//Nothing to assert

    }  


	
}