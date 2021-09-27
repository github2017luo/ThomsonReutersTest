/**
 * Validates the functionality provided by the IPRestrictionWSObject class.
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
public with sharing class IPRestrictionWSObject_Test{
    public static testmethod void testController(){   
        IPRestrictionWSObject testobj1 = new IPRestrictionWSObject();
        IPRestrictionWSObject.IPRestrictionItem testobj2 = new IPRestrictionWSObject.IPRestrictionItem(); 
    } 
}