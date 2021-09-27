/**
 * Validates the functionality provided by the ContactDeDupWSObjects class.
 *
 * @author  Shawn Gray
 * @version 2013-07-22
 */

/**
 * CHANGE HISTORY
 * =============================================================================
 * Date         Name                    Description
 * 2013-07-22   Shawn Gray              Created                                                                   
 * =============================================================================
 */
@IsTest(seealldata = true)
private class ContactDeDupWSObjects_Test {

        public static testmethod void testContactDeDupWSObjects(){
        ContactDeDupWSObjects testobj = new ContactDeDupWSObjects();
        ContactDeDupWSObjects.WS_Contact_MatchRequestType testObj1 = new ContactDeDupWSObjects.WS_Contact_MatchRequestType();
        ContactDeDupWSObjects.WS_Contact_MatchResponseType testobj2 = new ContactDeDupWSObjects.WS_Contact_MatchResponseType();
        ContactDeDupWSObjects.WS_Contact_MatchRequestElement_element testobj3 = new ContactDeDupWSObjects.WS_Contact_MatchRequestElement_element();
        ContactDeDupWSObjects.WS_Contact_MatchResponseElement_element testobj4 = new ContactDeDupWSObjects.WS_Contact_MatchResponseElement_element();
    }

}