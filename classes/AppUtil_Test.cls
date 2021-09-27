/**
 * Validates the functionality provided by the AppUtil class.
 * <p>
 * Origin: Thomson Reuters Code Share
 *
 * @author	John De Santiago - Thomson Reuters Code Share
 * @version	2010-10-21
 */

/**
 * CHANGE HISTORY
 * =============================================================================
 * Date			Name					Description
 * 2010-11-01   John De Santiago      	Created
 * 2011-02-22	John De Santiago		Updated test for decimal format method fix
 * 2017-03-31   Karthi                  Optimized the coverage as per JIRA STORY: PS0-1
 * =============================================================================
 */
@IsTest
private class AppUtil_Test {
	
	/**
	 * Validates the getInstance method returns an existing instance after being initialized
	 * by a previous call.
	 */
	private static testMethod void testGetInstance() {
		//Execute Test
		Test.startTest();
		
		AppUtil oAppUtil1 = AppUtil.getInstance();
		AppUtil oAppUtil2 = AppUtil.getInstance();
		
		System.assertEquals(oAppUtil1, oAppUtil2, 'Expected AppUtil instances to match');
		
		Test.stopTest();
	}
	
	/**
	 * Validates that the isEmpty method can determine a value as null or empty
	 */
	private static testMethod void testIsEmpty() {
		Test.startTest();
		
		System.assert(AppUtil.isEmpty(null), 'Expected isEmpty method to return true');
		System.assert(AppUtil.isEmpty(''), 'Expected isEmpty method to return true');
		System.assert(AppUtil.isEmpty('   '), 'Expected isEmpty method to return true');
		System.assert(!AppUtil.isEmpty('Unit Test'), 'Expected isEmpty method to return false');
		
		Test.stopTest();
	}
	
	/**
	 * Validates that the isNull methods can determine a value as null or empty
	 * and return the default value specified
	 */
	private static testMethod void testIsNull() {
		Test.startTest();
		
		//Test: String
		System.assertEquals('Default', AppUtil.isNull(null, 'Default'));
		System.assertEquals('Default', AppUtil.isNull('', 'Default'));
		System.assertEquals('Default', AppUtil.isNull('  ', 'Default'));
		System.assertEquals('Test', AppUtil.isNull('Test', 'Default'));
		
		//Test: Decimal
		System.assertEquals(10.2, AppUtil.isNull(null, 10.2));
		System.assertEquals(10.12, AppUtil.isNull(10.12, 10.2));
		
		//Test: Integer
		System.assertEquals(10, AppUtil.isNull(null, 10));
		System.assertEquals(20, AppUtil.isNull(20, 10));
		
		Test.stopTest();
	}
	
	/**
	 * Validates the the truncateString method truncates a string
	 * based on the user specified length
	 */
	private static testMethod void testTruncateString() {
		Test.startTest();
		
		System.assertEquals('123', AppUtil.truncateString('123', 5));
		System.assertEquals('12345', AppUtil.truncateString('12345', 5));
		System.assertEquals('12345', AppUtil.truncateString('123456', 5));
		System.assertEquals('', AppUtil.truncateString(null, 5), 'Expected an empty string when a null string is passed for truncation');
		
		Test.stopTest();	
	}

	/**
	 * Validates the the fixedWidthString method returns a string
	 * based on the user specified length
	 */
	private static testMethod void testFixedWidthString() {
		Test.startTest();
		
		System.assertEquals('1234 ', AppUtil.fixedWidthString('1234', 5));
		System.assertEquals('     ', AppUtil.fixedWidthString(null, 5));
		System.assertEquals('12345', AppUtil.fixedWidthString('1234567', 5));
		
		Test.stopTest();	
	}

	/**
	 * Validates the the rightPadString method returns a string
	 * based on the user specified pad count
	 */
	private static testMethod void testRightPadString() {
		Test.startTest();
		
		System.assertEquals('     ', AppUtil.rightPadString(null, ' ', 5));
		System.assertEquals('11111', AppUtil.rightPadString(null, '1', 5));
		System.assertEquals('12345xxxxx', AppUtil.rightPadString('12345', 'x', 5));
		
		Test.stopTest();	
	}
	
	/**
	 * Validates the the leftPadString method returns a string
	 * based on the user specified pad count
	 */
	private static testMethod void testLeftPadString() {
		Test.startTest();
		
		System.assertEquals('     ', AppUtil.leftPadString(null, ' ', 5));
		System.assertEquals('11111', AppUtil.leftPadString(null, '1', 5));
		System.assertEquals('xxxxx12345', AppUtil.leftPadString('12345', 'x', 5));
		
		Test.stopTest();	
	}
	
	/**
	 * Validates that dates and date time values are formatted
	 * based on the user defined format
	 */
	private static testMethod void testFormatDateAndDateTimes() {
		//Setup Test
		Date dDate = Date.newInstance(2011, 01, 01);
		Time tTime = Time.newInstance(10, 30, 0, 0);
		
		DateTime dtDateTime = DateTime.newInstance(dDate, tTime);
		
		Test.startTest();
		
		System.assertEquals('20110101', AppUtil.formatDate(dDate, 'yyyyMMdd', null));
		System.assertEquals('20110202', AppUtil.formatDate(dDate, null, '20110202'));
		System.assertEquals('1030', AppUtil.formatDateTime(dtDateTime, 'hhmm', null));
		System.assertEquals('1040', AppUtil.formatDateTime(dtDateTime, null, '1040'));
		System.assertEquals('201101011030', AppUtil.formatDateTime(dtDateTime, 'yyyyMMddhhmm', null));
		
		Test.stopTest();
	}
	
	/**
	 * Validates that a decimal are formatted based on the
	 * user defined scale
	 */
	private static testMethod void testFormatDecimal() {
		Test.startTest();
		
		System.assertEquals('10', AppUtil.formatDecimal(10.2, 0, ''));
		System.assertEquals('10.2', AppUtil.formatDecimal(10.2, 1, ''));
		System.assertEquals('20.3', AppUtil.formatDecimal(null, 0, '20.3'));
		System.assertEquals('10.56', AppUtil.formatDecimal(10.5555, 2, ''));
		System.assertEquals('1234567.00', AppUtil.formatDecimal(1234567, 2, ''));
		
		Test.stopTest();
	}
	
	/**
	 * Validates the getRecordTypeIdByName method returns the requested record type id
	 */
	private static testMethod void testGetRecordTypeIdByName() {
		//Setup Test
		AppUtil oAppUtil = AppUtil.getInstance();
		List<RecordType> listRecordTypes = [SELECT Id, Name, DeveloperName, SObjectType FROM RecordType];
		
		//Execute Test
		Test.startTest();
		
		//Only perform test if record types have been configured
		if (!listRecordTypes.isEmpty()) {
			RecordType oRecordType = listRecordTypes[0];
						
			//Test: Success
			Id successRecordTypeId = AppUtil.getRecordTypeIdByName(oRecordType.SObjectType, oRecordType.Name);
			
			System.assertEquals(successRecordTypeId, oRecordType.Id, 'Invalid record type id returned');
		}
		
		//Test: Invalid Name
		Id failureRecordTypeId = AppUtil.getRecordTypeIdByName('Account', 'Invalid Name');
		
		System.assertEquals(failureRecordTypeId, null, 'Expected a null record type id value');
		
		Test.stopTest();
	}
	
	/**
	 * Validates the getUrlParam method returns the requested url parameter value or
	 * the default value in the case the parameter does not exist or contains an
	 * empty string.
	 */
	private static testMethod void testGetUrlParam() {
		//Setup Test
		PageReference oPageReference = new PageReference('/001?param1=x&param2=y');
		
		Test.startTest();
		
		string sParam1 = AppUtil.getURLParam(oPageReference, 'param1', '');
		System.assert(sParam1 == 'x', 'Expected a url parameter named param1 to exist with a value of x');
		
		string sParam2 = AppUtil.getURLParam(oPageReference, 'param2', '');
		System.assert(sParam2 == 'y', 'Expected a url parameter named param2 to exist with a value of y');
		
		string sParam3 = AppUtil.getURLParam(oPageReference, 'param3', 'default');
		System.assert(sParam3 == 'default', 'Expected a url parameter named param3 not to exist, returning the value default');
		
		string sParam4 = AppUtil.getURLParam(null, null, null);
		System.assert(sParam4 == null, 'Expected method to handle null arguments gracefully by returning a null value');
		
		Test.stopTest();
	}
	
	/**
	 * Validates the getWebServiceSettings method returns the configured web service by name
	 */
	private static testMethod void testGetWebServiceSettings() {
		//Setup Test
		string sActiveServiceName = 'Active Unit Test';
		string sInactiveServiceName = 'Inactive Unit Test';
		string sInvalidServiceName = 'Invalid Unit Test';
		
		WebServiceSettings__c oActiveWebServiceSettings = new WebServiceSettings__c();
		oActiveWebServiceSettings.Name = sActiveServiceName;
		oActiveWebServiceSettings.Active__c = true;
		oActiveWebServiceSettings.Username__c = 'user_ut';
		oActiveWebServiceSettings.Password__c = 'pass_ut';
		oActiveWebServiceSettings.Endpoint__c = 'ut@thomsonreuters.com';
		oActiveWebServiceSettings.Timeout__c = 20;
		oActiveWebServiceSettings.Service_Unavailable_Message__c = 'Service is unavailable for unit testing';
		insert oActiveWebServiceSettings;

		WebServiceSettings__c oInactiveWebServiceSettings = new WebServiceSettings__c();
		oInactiveWebServiceSettings.Name = sInactiveServiceName;
		oInactiveWebServiceSettings.Active__c = false;
		oInactiveWebServiceSettings.Username__c = 'user_ut';
		oInactiveWebServiceSettings.Password__c = 'pass_ut';
		oInactiveWebServiceSettings.Endpoint__c = 'ut@thomsonreuters.com';
		oInactiveWebServiceSettings.Timeout__c = 20;
		oInactiveWebServiceSettings.Service_Unavailable_Message__c = 'Service is unavailable for unit testing';
		insert oInactiveWebServiceSettings;
				
		//Execute Test
		Test.startTest();
		
		//Test Success
		WebServiceSettings__c oTestActiveWebServiceSettings = AppUtil.getWebServiceSettings(sActiveServiceName);
		System.assert(oTestActiveWebServiceSettings != null, 'Expected a valid web service settings instance');
		System.assert(oTestActiveWebServiceSettings.Name == sActiveServiceName, 'Expected returned service to match the requested service name');
		
		//Test Failed - Inactive Service
		try {
			WebServiceSettings__c oTestInactiveWebServiceSettings = AppUtil.getWebServiceSettings(sInactiveServiceName);
			System.assert(false, 'Expected InvalidWebServiceException to be thrown');
		}
		catch (AppUtil.InactiveWebServiceException oInactiveWebServiceException) {
			System.assert(true);
		}
		catch (Exception oException) {
			System.assert(false, 'Expected InactiveWebServiceException to be thrown');
		}
		
		//Test Failed - Invalid Service
		try {
			WebServiceSettings__c oTestInactiveWebServiceSettings = AppUtil.getWebServiceSettings(sInvalidServiceName);
			System.assert(false, 'Expected InvalidWebServiceException to be thrown');
		}
		catch (AppUtil.InvalidWebServiceException oInvalidWebServiceException) {
			System.assert(true);
		}
		catch (Exception oException) {
			System.assert(false, 'Expected InvalidWebServiceException to be thrown');
		}
		
		Test.stopTest();
	}
	
	/**
	 * Validates the handleError method returns the configured user message and logs
	 * the error to the exception log.
	 */
	private static testMethod void testHandleError() {
		//Setup Test
		string sDefaultErrorMessage = 'Unit Test: User Error Message';
		string sExceptionMessage = 'Unit Test: Exception Message';
		
		SystemSettings__c oSystemSettings = SystemSettings__c.getInstance();
		oSystemSettings.Default_Error_Message__c = sDefaultErrorMessage;
		oSystemSettings.Display_Friendly_Error_Message__c = true;
		update oSystemSettings;
		
		AppUtil.AppException oInnerException = new AppUtil.AppException('Inner Exception');
		AppUtil.AppException oException = new AppUtil.AppException(sExceptionMessage, oInnerException);
		
		//Execute Test
		Test.startTest();

		string sUserMessage = AppUtil.handleError(oException);
		System.assert(sUserMessage.contains(sDefaultErrorMessage),'Expected user message to contain default error message');
		
		Test.stopTest();
		
		//Validate Test
		List<Exception_Log__c> listExceptionLogs = [SELECT Id, Exception_Message__c FROM Exception_Log__c WHERE User_Message__c =: sDefaultErrorMessage];
		if (!listExceptionLogs.isEmpty()) {
			Exception_Log__c oExceptionLog = listExceptionLogs[0];
			System.assert(oExceptionLog.Exception_Message__c == sExceptionMessage, 'Expected test exception message to have been logged. Instead logged: ' + oExceptionLog.Exception_Message__c);
		}
		else {
			System.assert(false, 'Expected at least one exception message to have been logged.');	
		}
	}
	
	/**
	 * Validates the handleError method returns the non-friendly user message
	 */
	private static testMethod void testHandleErrorNonFriendlyMessage() {
		//Setup Test
		string sDefaultErrorMessage = 'Unit Test: User Error Message';
		string sExceptionMessage = 'Unit Test: Exception Message';
		
		SystemSettings__c oSystemSettings = SystemSettings__c.getInstance();
		oSystemSettings.Default_Error_Message__c = sDefaultErrorMessage;
		oSystemSettings.Display_Friendly_Error_Message__c = false;
		update oSystemSettings;
		
		AppUtil.AppException oInnerException = new AppUtil.AppException('Inner Exception');
		AppUtil.AppException oException = new AppUtil.AppException(sExceptionMessage, oInnerException);
		
		//Execute Test
		Test.startTest();

		string sUserMessage = AppUtil.handleError(oException);
		System.assert(sUserMessage.contains(sExceptionMessage),'Expected user message to contain exception message');
		
		Test.stopTest();
	}
	
	/**
	 * Validates the handleError method responds appropriately when an error log
	 * entry fails to save.
	 */
	private static testMethod void testHandleErrorWriteToLogFailure() {
		//Setup Test
		string sExceptionMessage = 'Unit Test: Exception Message';
		
		//Max out string length to force a DML Error
		while (sExceptionMessage.length() < 32000) {
			sExceptionMessage += sExceptionMessage;
		}
		
		//Create test exception
		AppUtil.AppException oInnerException = new AppUtil.AppException('Inner Exception');
		AppUtil.AppException oException = new AppUtil.AppException(sExceptionMessage, oInnerException);
		
		//Execute Test
		Test.startTest();
		
		//Attempt to log an error
		string sUserMessage = AppUtil.handleError(oException);
		string sInsertError = string.format(System.Label.ExceptionLogError, new string[] {''});
		
		System.assert(sUserMessage.contains(sInsertError), 'Expected user message to reflect that the error could not be logged: ' + sUserMessage);
		
		Test.stopTest();
	}
	
	/**
	 * Validates the handleError method responds appropriately when method
	 * encounters an unhandled exception.
	 */
	private static testMethod void testHandleErrorUnknownException() {
		//Setup Test
		string sExceptionMessage = 'Unit Test: Exception Message';
		
		//Create test log entry				
		Exception_Log__c oExceptionLog = new Exception_Log__c();
		oExceptionLog.User_Message__c = 'User Message';
		oExceptionLog.Exception_Type__c = 'Exception Type';
		oExceptionLog.Exception_Message__c = 'Exception Message';
		oExceptionLog.Additional_Information__c = 'Exception Details';
		insert oExceptionLog;
		
		//Create test exception
		AppUtil.AppException oInnerException = new AppUtil.AppException('Inner Exception');
		AppUtil.AppException oException = new AppUtil.AppException(sExceptionMessage, oInnerException);
		
		//Execute Test
		Test.startTest();

		//Attempt to log a null exception
		string sUserMessage = AppUtil.handleError(null);
		
		Test.stopTest();
	}
	
	/**
	 * Validates the handleError method returns the values by the
	 * specified HandleErrorResult
	 */
	private static testMethod void testHandleErrorResultTypes() {
		//Setup Test
		string sDefaultErrorMessage = 'Unit Test: User Error Message';
		string sExceptionMessage = 'Unit Test: Exception Message';
		
		SystemSettings__c oSystemSettings = SystemSettings__c.getInstance();
		oSystemSettings.Default_Error_Message__c = sDefaultErrorMessage;
		oSystemSettings.Display_Friendly_Error_Message__c = false;
		update oSystemSettings;
		
		AppUtil.AppException oInnerException = new AppUtil.AppException('Inner Exception');
		AppUtil.AppException oException = new AppUtil.AppException(sExceptionMessage, oInnerException);
		
		//Execute Test
		Test.startTest();

		string sUserMessage = AppUtil.handleError(oException, AppUtil.HandleErrorResult.FriendlyMessage);
		System.assert(sUserMessage != null, 'Expected user message to user friendly message');
		
		string sErrorMessage = AppUtil.handleError(oException, AppUtil.HandleErrorResult.ExceptionMessage);
		System.assertEquals(sExceptionMessage, sErrorMessage);
		
		Id exceptionLogId = AppUtil.handleError(oException, AppUtil.HandleErrorResult.ExceptionId);
		List<Exception_Log__c> listExceptionLogs = [SELECT Id, Name FROM Exception_Log__c WHERE Id=:exceptionLogId];
		System.assert(!listExceptionLogs.isEmpty(), 'Expected a valid exception log number to be returned');
		
		Test.stopTest();
	}
}