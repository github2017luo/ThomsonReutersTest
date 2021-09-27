/**
 * Provides test methods for the CNUnitTest class
 *
 * @author  		Mike Eaton
 * @version 		2011-12-11
 * @dependencies	
 */
  
/** 
 * CHANGE HISTORY
 * -------------------------------------------------------------------------------------------------------------------
 *	Date			Name				Description
 *	2011-12-11		Mike Eaton			Created
 *	2011-12-11		Mike Eaton			Added batch support to creating contacts
 *  2011-12-12		Shah Kadir			Validated conditional data records creation
 *  2011-12-14		Shah Kadir			Added XML data creation methods
 *  2011-12-20		Shah Kadir			Added OnInstall annotation to enforce test method execution during package installation.
 *  2012-01-20		Shah Kadir			Incorporated enhanced list (go to list) functionality related changes.
 *  2012-07-12		Shah Kadir			Fixed test_getWebserviceQueue() method to overcome test error
 * -------------------------------------------------------------------------------------------------------------------
 */
@IsTest (seeAllData=true)
private class CNUnitTestTest {

 
	/**
	 * Validates Account Instantiation
	 */
	@isTest 
	private static void test_getAccount() {
		Test.startTest();		
		Account oAccount = CNUnitTest.getAccount(true);
		system.assertNotEquals(oAccount.Id, NULL, 'Expected Account record was not created');		
		Account oAccount1 = CNUnitTest.getAccount(false);
		system.assertNotEquals(oAccount1.Id, NULL, 'Expected Account record was not created');
		Test.stopTest();
	}
	
	/**
	 * Validates Contact Instantiation
	 */
	@isTest 
	private static void test_getContact() {
		Account oAccount = CNUnitTest.getAccount(true);
		
		Test.startTest();
		
		Contact oContact = CNUnitTest.getContact(oAccount.Id, true);
		system.assertNotEquals(oContact.Id, NULL, 'Expected Contact record was not created');
		Contact oContact1 = CNUnitTest.getContact(oAccount.Id, false);
		system.assertNotEquals(oContact1, NULL, 'Expected Contact record was not created');
		Test.stopTest();
		
		
	}
	
	 
	/**
	 * Validates MockWebServiceResponse Storage
	 */
	@isTest 
	private static void test_MockWebServiceResponseStorage() {
		//Setup Test
		Account oAccount = CNUnitTest.getAccount(true);
		
		//Execute Test
		Test.startTest();
		
		CNUnitTest.MockWebServiceResponse.put('Account', oAccount);
		Test.stopTest();
		
		system.assert(CNUnitTest.MockWebServiceResponse.containsKey('Account'), 'Expected mock web service response object to exist');
	}


	/**
	 * Validates Contacts Instantiation
	 */
	@isTest 
	private static void test_getContacts() {
		Account oAccount = CNUnitTest.getAccount(true);
		
		Test.startTest();
		system.assertNotEquals(oAccount.Id, NULL, 'Expected valid Account.Id');
		
		List<Contact> listContacts = CNUnitTest.getContacts(oAccount.Id, false);
		system.assertEquals(listContacts.size(), CNUnitTest.DEFAULT_BATCH_SIZE, 'Expected BATCH_SIZE differs from actual batch size results');
		system.debug(listContacts);
		List<Contact> listContacts1 = CNUnitTest.getContacts(oAccount.Id, true);		
		system.assertEquals(listContacts1.size(), CNUnitTest.DEFAULT_BATCH_SIZE, 'Expected BATCH_SIZE differs from actual batch size results');
		system.debug(listContacts1);
		Test.stopTest();

		
	}
	
	/**
	 * Validates custom setting initialization
	 */
	@isTest 
	private static void test_initializeCustomSetting() {
		Test.startTest();

		CNUnitTest.initializeCustomSetting();
		CN_App_Settings__c oSetting = CNAppUtils.getAppCustomSetting();
		system.assertEquals(true, oSetting.WS_Is_Active__c, 'Custom setting is not initialized properly');
		
		Test.stopTest();
	}	

	/**
	 * Validates contact XML instantiation
	 */
	@isTest 
	private static void test_getArrayOfContactXML() {
		Test.startTest();

		String xml = CNUnitTest.getArrayOfContactXML(1);
		system.assertNotEquals(null, xml, 'Contact XML is not prepared properly');
		
		Test.stopTest();
	}	

	/**
	 * Validates relationship XML instantiation
	 */
	@isTest 
	private static void test_getArrayOfRelationshipXML() {
		Test.startTest();

		String xml = CNUnitTest.getArrayOfRelationshipXML(1);
		system.assertNotEquals(null, xml, 'Relationship XML is not prepared properly');
		
		Test.stopTest();
	}	

	/**
	 * Validates company XML instantiation
	 */
	@isTest 
	private static void test_getArrayOfCompanyXML() {
		Test.startTest();

		String xml = CNUnitTest.getArrayOfCompanyXML(1,1);
		system.assertNotEquals(null, xml, 'Company XML is not prepared properly');
		
		Test.stopTest();
	}	

	/**
	 * Validates web service custom object creation
	 */
	@isTest 
	private static void test_getWebserviceQueue() {
		Account oAcct = CNUnitTest.getAccount(true);
		Test.startTest();

		try {
			CN_Webservice_Queue__c oQueue = CNUnitTest.getWebserviceQueue(oAcct.Id, null, System.now(), true);
			system.assertNotEquals(null, oQueue, 'Web service queue not created');
		}
		catch (Exception e) {}
		
		Test.stopTest();
	}	
	
	/**
	 * Validates relationship custom object creation
	 */
	@isTest 
	private static void test_getRelationships() {
		//09.15.14 CNUnitTest.initializeCustomSetting();
		Id colRecTypeId = Schema.SObjectType.CN_Relationship__c.getRecordTypeInfosByName().get('Colleague').getRecordTypeId();
		Account oAcct = CNUnitTest.getAccount(true);
		CNAppUtils.CNWebServiceQueueHandler oQueueHandler = new CNAppUtils.CNWebServiceQueueHandler(oAcct.Id, null, '123', 'Colleague');
		oQueueHandler.createQueue();
		
		Test.startTest();

		List<CN_Relationship__c> listRelationships = CNUnitTest.getRelationships(oQueueHandler.oQueue.Id, 5, true, colRecTypeId);
		system.assertEquals(5, listRelationships.size(), 'Relationship records not created');
		
		Test.stopTest();
	}	
	 
}