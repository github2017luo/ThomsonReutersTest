/**
* {Purpose} Test Class for CNData_14_Login
*
* @author   Glen Cunningham
* @version  2015.12.7
*/ 

/**
* CHANGE HISTORY
* =============================================================================
* Date          Name                    Description
*  
* =============================================================================
*/
@isTest
private class CNData_14_OAuth_Test {

    static testMethod void myUnitTest() {
         CNData_14_OAuth cn = new CNData_14_OAuth();
         string json = '{"access_token":"ewrt2436524365435","signature":"abcde","instance_url":"http://test.foo.moo","id":"myid","token_type":"Bearer","issued_at":"01/01/1990"}';
		 CNData_14_OAuth c = ( CNData_14_OAuth) CNData_14_OAuth.parse(json);
    }
}