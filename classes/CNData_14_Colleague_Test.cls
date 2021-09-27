/**
 * This class contains unit tests for CNData_14_Colleague_Test

 */
@isTest(seeAllData=true)
private class CNData_14_Colleague_Test {
     
     static testMethod void testParse() {
		string json = '{"Results":[{"Office":"Washington","Department":"Administrative Support","Phone":"","FirstName":"Gina","LastName":"Boil","Title":"Senior Counsel","Email":"ginboil@yourcompany.com","Id":33144,"Strength":4.26,"SourcesBitmask":1,"MostRecentSource":1,"MostRecentSourceDate":"2015-05-04T18:34:13.62","Recency":"114 days","RelationshipCount":7},{"Office":"Boston","Department":"Information Services","Phone":"","FirstName":"Eric","LastName":"Ripa","Title":"Senior Systems Administrator","Email":"eriripa@yourcompany.com","Id":709,"Strength":3.78,"SourcesBitmask":1,"MostRecentSource":1,"MostRecentSourceDate":"2015-05-04T18:34:13.62","Recency":"114 days","RelationshipCount":17},{"Office":"Boston","Department":"Secretarial Support","Phone":"","FirstName":"Jason","LastName":"Lurenz","Title":"Secretary","Email":"jaslurenz@yourcompany.com","Id":700,"Strength":3.73,"SourcesBitmask":1,"MostRecentSource":1,"MostRecentSourceDate":"2015-05-04T18:34:13.62","Recency":"114 days","RelationshipCount":1},{"Office":"Boston","Department":"Employment","Phone":"","FirstName":"Peter","LastName":"Kovach","Title":"Assistant","Email":"pkovach@yourcompany.com","Id":40998,"Strength":3.51,"SourcesBitmask":1,"MostRecentSource":1,"MostRecentSourceDate":"2015-05-04T18:34:13.62","Recency":"114 days","RelationshipCount":1},{"Office":"New York","Department":"","Phone":"","FirstName":"Ashley","LastName":"Dorai","Title":"Senior Vice President","Email":"ashdorai@yourcompany.com","Id":331,"Strength":3.47,"SourcesBitmask":1,"MostRecentSource":1,"MostRecentSourceDate":"2015-05-04T18:34:13.62","Recency":"114 days","RelationshipCount":2}],"NumResults":59,"TrackedSearchId":38328}';
		CNData_14_Colleague obj = CNData_14_Colleague.parse(json);
		System.assert(obj != null);
		CNData.CNCompany oCompany = new CNData.CNCompany();
	  	list<CNData.CNColleague> cnc = CNData_14_Colleague.MapTo(obj.Results, oCompany);
	  	CN_App_Settings__c capp = [SELECT Recency_as_Date__c FROM CN_App_Settings__c limit 1];
		capp.Recency_as_Date__c = !capp.Recency_as_Date__c;
		update capp;
		obj = CNData_14_Colleague.parse(json);
		System.assert(obj != null);
		oCompany = new CNData.CNCompany();
	  	cnc = CNData_14_Colleague.MapTo(obj.Results, oCompany);
	  	json = json.replace('{"Results":[','').replace(']','');
	  	obj = CNData_14_Colleague.parse(json);
		System.assert(obj != null);
    }
}