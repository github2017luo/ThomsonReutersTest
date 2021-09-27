/**
 * Validates the functionality provided by the WebServiceSchema class.
 *
 * @author  Zahedul hossain
 * @version  2013-06-05
 */
 
 /**
 * CHANGE HISTORY
 * =============================================================================
 * Date         Name                    Description
 * 2013-07-05  Zahedul hossain          Created                                                                   
 * =============================================================================
 */

@ istest
public class CredentialInfoWS_Test{
  public static testMethod void testWebServiceSchema() {
    Decimal tSapId = decimal.valueof('1234');
    CredentialInfoWS testobj = new CredentialInfoWS();
    CredentialInfoWS.CredentialInfo_v2_0Port testobj1= new CredentialInfoWS.CredentialInfo_v2_0Port();
    CredentialInfoWS.GetCredentialInfoResponse_element testobj2 = new CredentialInfoWS.GetCredentialInfoResponse_element();
    CredentialInfoWS.GetCredentialInfo_element testobj3 = new CredentialInfoWS.GetCredentialInfo_element();
  
    testobj1.GetCredentialInfo( tSapId ,'test','test','test','test');
  
       
  }
 }