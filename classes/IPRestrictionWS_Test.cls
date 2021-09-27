/**
 * Validates the functionality provided by the IPRestriction WebServiceSchema class.
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

@ istest(SeeAllData=true)
public class IPRestrictionWS_Test{

public static testMethod void testWebServiceSchema() {

    Decimal tSapId = decimal.valueof('1234');
    Date tValidityDt = date.valueOf('2012-05-08');
    
    IPRestrictionWS testobj = new IPRestrictionWS();
    IPRestrictionWS.IPRestriction_v2_0Port testobj2 = new IPRestrictionWS.IPRestriction_v2_0Port();
    IPRestrictionWS.GetIPRestriction_element testobj3 = new IPRestrictionWS.GetIPRestriction_element();
    IPRestrictionWS.GetIPRestrictionResponse_element testobj4 = new IPRestrictionWS.GetIPRestrictionResponse_element();
   
    testobj2.GetIPRestriction('test',tSapId,tValidityDt);
    
       
  }
 }