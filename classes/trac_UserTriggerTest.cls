/**
 * trac_UserTriggerTest
 * @description Tetst class for user trigger
 *
 * @author Rauza Zhenissova, Traction on Demand
 * @date 06-01-2015
 */

@isTest
private class trac_UserTriggerTest {
	
	@isTest static void testLanguageUpdate() {
		Id profileId = [SELECT id FROM Profile WHERE name='Standard User' LIMIT 1].id;

		User newUser = new User(
			UserName = 'test@tractioondemand.com.test',
			Email = 'test@tractioondemand.com.test',
			FirstName = 'userFirstName',
			LastName = 'userLastName',
			ALias = 'usr',
			TimezoneSIDKey = 'America/Los_Angeles',
	        LocaleSIDKey = 'en_US',
	        EmailEncodingKey = 'UTF-8',
	        LanguageLocaleKey = 'fr',
	        ProfileId = profileId
		);
		insert newUser;

		List<User> userList = [SELECT UserName, Language__c 
								FROM User 
								WHERE Id = :newUser.Id];
		System.assert(userList!=null && !userList.isEmpty());
		System.assertEquals(userList[0].Language__c, 'French');

		newUser.LanguageLocaleKey='ko';
		update newUser;

		userList = [SELECT UserName, Language__c 
								FROM User 
								WHERE Id = :newUser.Id];
		System.assert(userList!=null && !userList.isEmpty());
		System.assertEquals(userList[0].Language__c, 'Korean');
	}
	
}