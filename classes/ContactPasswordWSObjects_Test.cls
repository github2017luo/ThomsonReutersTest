/**
 * Validates the functionality provided by the ContactPasswordWSObjects class.
 *
 * @author  Nandita R. Shet
 * @version  2012-08-08
 */
 
 /**
 * CHANGE HISTORY
 * =============================================================================
 * Date         Name                    Description
 * 2012-08-08   Nandita R. Shet        Created                                                                   
 * =============================================================================
 */
 
@IsTest(seealldata=true)
private class ContactPasswordWSObjects_Test{

    public static testmethod void testContactPasswordsWSObjects(){
        ContactPasswordWSObjects testobj = new ContactPasswordWSObjects();
        ContactPasswordWSObjects.FederatedIdentity testObj1 = new ContactPasswordWSObjects.FederatedIdentity();
        ContactPasswordWSObjects.OnlineUser testobj2 = new ContactPasswordWSObjects.OnlineUser();
        ContactPasswordWSObjects.Contact testobj3 = new ContactPasswordWSObjects.Contact();
        ContactPasswordWSObjects.PrismUser testobj4 = new ContactPasswordWSObjects.PrismUser();
      
    
    }
 }