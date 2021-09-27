/**
* {Purpose} – Test class for CNGetAuthController.
*
* @author	Denis Mitropolsky
* @version	2017-01-12
*/

/** 
* CHANGE HISTORY
* =============================================================================
* Date			Name					Description
* 2017-01-12	Denis Mitropolsky		Created  
* =============================================================================
*/
@isTest
private class CNGetAuthController_Test {
	@isTest
    private static void createController() {
        Test.startTest();
        
        CNGetAuthController controller = new CNGetAuthController();
        
        Test.stopTest();
    }
}