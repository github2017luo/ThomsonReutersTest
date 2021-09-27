/**
 * Validates the functionality provided by the ContactPasswordsServices class.
 *
 * @author  Nandita R. Shet
 * @version  2012-08-08
 */
 
 /**
 * CHANGE HISTORY
 * =============================================================================
 * Date         Name                    Description
 * 2012-08-08   Nandita R. Shet        Created
 * 2012-09-29   Subhajit               Changed Settings to ESI
 * =============================================================================
 */
 
@IsTest(seealldata=true)
private class ContactPasswordsServices_Test {

    public static testmethod void testGetContactPasswords(){
         Account testAcc1 = UnitTest.getAccountInstance();
         testAcc1.Phone = '123';
         testAcc1.SAPAccountNumber__c = '001';
        insert testAcc1;
        
        Contact testContact = UnitTest.getContactInstance(testAcc1.Id);
        testContact.SAP_Contact_ID__c = '16113';
        insert testContact;
        
        
        
        ContactPasswordsServices oContactPasswordsServices = new ContactPasswordsServices();
        ContactPasswordsServices.FederatedIdentity oFederatedIdentity = new ContactPasswordsServices.FederatedIdentity();
        ContactPasswordsServices.Contact oContact = new ContactPasswordsServices.Contact();
        ContactPasswordsServices.PrismUser oPrismUser = new ContactPasswordsServices.PrismUser();
        ContactPasswordsServices.OnlineUser oOnlineUser = new ContactPasswordsServices.OnlineUser();
        
        List<ContactPasswordsServices.OnlineContact> listoutput = new List<ContactPasswordsServices.OnlineContact>();
        List<ContactPasswordsServices.OnlineAccountUsers> listAccpswdOutput = new List<ContactPasswordsServices.OnlineAccountUsers>();
        //WebServiceSettings__c oWebServiceSettings = AppUtil.getWebServiceSettings('ContactPasswords');   //2012-09-29   Subhajit               Changed Settings to ESI
        WebServiceSettings__c oWebServiceSettings = AppUtil.getWebServiceSettings('ContactPasswordsESI');  //2012-09-29   Subhajit               Changed Settings to ESI
        WebServiceSettings__c oWebServiceSettings2 = AppUtil.getWebServiceSettings('ContactPasswordByConSAPID');
       
        ContactPasswordsServices.ContactPasswordRequest testRequest = new ContactPasswordsServices.ContactPasswordRequest();       
        testRequest.Username = oWebServiceSettings.Username__c;
        testRequest.Password =  oWebServiceSettings.Password__c;     
        testRequest.Endpoint = oWebServiceSettings.Endpoint__c;
        testrequest.Timeout = (oWebServiceSettings.Timeout__c * 1000).intValue(); //Convert seconds to milliseconds
         
        testRequest.ContactSAPID = decimal.valueof(testContact.SAP_Contact_ID__c);
        listoutput = oContactPasswordsServices.GetContactPasswords(testRequest);  
        
        
        ContactPasswordsServices.AccountPasswordRequest testAccRequest = new ContactPasswordsServices.AccountPasswordRequest();      
        testAccRequest.Username = oWebServiceSettings.Username__c;
        testAccRequest.Password =  oWebServiceSettings.Password__c;     
        testAccRequest.Endpoint = oWebServiceSettings.Endpoint__c;
        testAccRequest.Timeout = (oWebServiceSettings.Timeout__c * 1000).intValue(); //Convert seconds to milliseconds
        testAccRequest.Domain = 'WEST';
        testAccRequest.AcctSapId = decimal.valueof(testAcc1.SAPAccountNumber__c);
        testAccRequest.SalesOrgCode = 'WEST';
        testAccRequest.CompanyCode = '0010';
        testAccRequest.DistChanCode = 'W';
        testAccRequest.DivisionCode = 'W';
        testAccRequest.StartRec = 1;
        testAccRequest.MaxResults = 250;                        
        
        listAccpswdOutput = oContactPasswordsServices.GetAccountPasswords(testAccRequest);  
        
       
        
    
    }
}