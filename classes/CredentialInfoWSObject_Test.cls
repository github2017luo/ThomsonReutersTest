/**
 * Validates the functionality provided by the CredentialInfoWSObject class.
 *
 * @author  Zahedul hossain
 * @version  2013-07-05
 */
 
 /**
 * CHANGE HISTORY
 * =============================================================================
 * Date         Name                    Description
 * 2013-07-05  Zahedul hossain          Created                                                                   
 * =============================================================================
 */

@istest
public with sharing class CredentialInfoWSObject_Test{
    public static testmethod void testController(){   
        CredentialInfoWSObject testobj1 = new CredentialInfoWSObject();
        CredentialInfoWSObject.CredentialInfoBusinessRestrictionItem testobj2 = new CredentialInfoWSObject.CredentialInfoBusinessRestrictionItem(); 
    
        CredentialInfoWSObject.CredentialInfoItem testobj3 = new CredentialInfoWSObject.CredentialInfoItem();
        CredentialInfoWSObject.BusinessRestrictionItem testobj4 = new CredentialInfoWSObject.BusinessRestrictionItem();
      
    } 
}