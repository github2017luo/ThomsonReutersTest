/**
 * {Purpose} � This class provides a test for the  CNData_14_ColleagueContacts  
 * 
 * @author   Glen Cunningham
 * @version  2015.12.01
 */
/** 
 * CHANGE HISTORY
 * =============================================================================
 * Date          Name                    Description
 * 
 * =============================================================================
 */
@isTest(seeAllData=true)
private class CNData_14_ColleagueContacts_Test {
	static testMethod void testParse() {
		String json = '{\"Vcard\":null,\"Phone\":null,\"Relationships\":[{\"OrganizationId\":0,\"OrganizationName\":null,\"Phone\":null,\"Industry\":null,\"MailingAddress\":null,\"HasVisibleSignatures\":false,\"FirstName\":\"Annie\",\"LastName\":\"Kottman\",\"Title\":\"Senior Marketing Director\",\"Email\":\"anne.kottman@pepsi.com\",\"Id\":1662422,\"Strength\":4.95,\"SourcesBitmask\":1,\"MostRecentSource\":1,\"MostRecentSourceDate\":\"2015-04-25T00:00:00\",\"Recency\":\"144 days\",\"RelationshipCount\":null},{\"OrganizationId\":0,\"OrganizationName\":null,\"Phone\":\"617-357-9500 x42499\",\"Industry\":null,\"MailingAddress\":null,\"HasVisibleSignatures\":false,\"FirstName\":\"Ramona\",\"LastName\":\"Gallagher\",\"Title\":\"Vice President And Assistant General Counsel\",\"Email\":\"ramona.gallagher@pepsi.com\",\"Id\":1684078,\"Strength\":4.76,\"SourcesBitmask\":1,\"MostRecentSource\":1,\"MostRecentSourceDate\":\"2015-04-25T00:00:00\",\"Recency\":\"144 days\",\"RelationshipCount\":null},{\"OrganizationId\":0,\"OrganizationName\":null,\"Phone\":\"914-253-2483\",\"Industry\":null,\"MailingAddress\":null,\"HasVisibleSignatures\":false,\"FirstName\":\"David\",\"LastName\":\"Yawman\",\"Title\":\"Senior Vice President, Marketing\",\"Email\":\"david.yawman@pepsi.com\",\"Id\":1653367,\"Strength\":4.66,\"SourcesBitmask\":1,\"MostRecentSource\":1,\"MostRecentSourceDate\":\"2015-04-25T00:00:00\",\"Recency\":\"144 days\",\"RelationshipCount\":null},{\"OrganizationId\":0,\"OrganizationName\":null,\"Phone\":\"617-357-9503\",\"Industry\":null,\"MailingAddress\":null,\"HasVisibleSignatures\":false,\"FirstName\":\"Verlinda\",\"LastName\":\"DiMarino\",\"Title\":\"Senior Benefits Consultant\",\"Email\":\"verlinda.dimarino@pepsi.com\",\"Id\":1688090,\"Strength\":4.48,\"SourcesBitmask\":1,\"MostRecentSource\":1,\"MostRecentSourceDate\":\"2015-04-25T00:00:00\",\"Recency\":\"144 days\",\"RelationshipCount\":null}],\"NumResults\":4}';
		CNData_14_ColleagueContacts obj = CNData_14_ColleagueContacts.parse(json);
		System.assert(obj != null);
		CNData.CNCompany oCompany = new CNData.CNCompany();
		list<CNData_14_ColleagueContacts.Relationships> oColleagues = new list<CNData_14_ColleagueContacts.Relationships>(obj.Relationships);
		List<CNData.CNRelationship> rl = CNData_14_ColleagueContacts.MapTo(oColleagues, oCompany);
		//change Recency_as_Date__c from true to false or vise versa
		CN_App_Settings__c css  = [SELECT Recency_as_Date__c FROM CN_App_Settings__c limit 1];
		css.Recency_as_Date__c = !css.Recency_as_Date__c ;
		update css;
		rl = CNData_14_ColleagueContacts.MapTo(oColleagues, oCompany);		
	}
}