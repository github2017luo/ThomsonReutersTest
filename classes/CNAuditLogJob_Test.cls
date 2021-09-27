/**
* {Purpose} – Test class for CNAuditLogJob
*
* @author	Glen Cunningham
* @version	2015-12-3
*/

/**
* CHANGE HISTORY
* ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
* Date			Name					Description
*
* ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
*/
@isTest(seeAllData=true)
private class CNAuditLogJob_Test {

    static testMethod void myUnitTest() {
       	CNAuditLogJob j = new CNAuditLogJob();
		CNAuditLogJob j1 = new CNAuditLogJob(1);
		Test.startTest();
		Database.ExecuteBatch(j1);
		Test.stopTest();
    }
}