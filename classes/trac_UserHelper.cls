/**
 * trac_UserHelper
 * @description Helper class for User trigger
 *
 * @author Rauza Zhenissova, Traction on Demand
 * @date 06-01-2015
 */

public with sharing class trac_UserHelper {
	public static void updateLanguage(List<User> userList) {
		Map<String, String> localeMap = new Map<String,String>();
		Schema.DescribeFieldResult fieldResult = User.LanguageLocaleKey.getDescribe();
		List<Schema.PicklistEntry> picklistValues = fieldResult.getPicklistValues();
		for (Schema.PicklistEntry picklistEntry : picklistValues) {
			localeMap.put(picklistEntry.getValue(), picklistEntry.getLabel());
		}
		for(User tmpUser : userList){
			tmpUser.Language__c = localeMap.get(tmpUser.LanguageLocaleKey);
		}
	}
}