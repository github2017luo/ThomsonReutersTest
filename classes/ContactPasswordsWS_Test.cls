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
 * =============================================================================
 */
 
@IsTest(seealldata=true)
private class ContactPasswordsWS_Test {

    public static testmethod void testContactPasswordsWS(){
        Account testAcc1 = UnitTest.getAccountInstance();
        testAcc1.SAPAccountNumber__c = '1';
        insert testAcc1;
        
        Contact testContact = UnitTest.getContactInstance(testAcc1.Id);
        testContact.SAP_Contact_ID__c = '16113';
        insert testContact;
        ContactPasswordWS testContactPasswordsWS = new ContactPasswordWS();
        ContactPasswordWS.Contact_v11_0Port testPort =  new ContactPasswordWS.Contact_v11_0Port();
        
        ContactPasswordWS.GetOnlineUserByAccountResponse_element testobj1 = new ContactPasswordWS.GetOnlineUserByAccountResponse_element();
        ContactPasswordWS.GetOnlineUserByContactSapId_element testobj2 = new ContactPasswordWS.GetOnlineUserByContactSapId_element();
        ContactPasswordWS.UpdateIvrPhonePermissionResponse_element testobj3 = new ContactPasswordWS.UpdateIvrPhonePermissionResponse_element();        
        ContactPasswordWS.GetOnlineUserByUserName_element  testobj4 = new ContactPasswordWS.GetOnlineUserByUserName_element();
        ContactPasswordWS.GetOnlineUserByContactSapIdResponse_element testobj5 = new ContactPasswordWS.GetOnlineUserByContactSapIdResponse_element();
        ContactPasswordWS.FindContactByIvrPhone_element  testobj6 = new ContactPasswordWS.FindContactByIvrPhone_element();
        ContactPasswordWS.AddPhoneNumberResponse_element  testobj7 = new ContactPasswordWS.AddPhoneNumberResponse_element();
        ContactPasswordWS.FindContactByIvrPhoneResponse_element testobj8 = new ContactPasswordWS.FindContactByIvrPhoneResponse_element();
        ContactPasswordWS.GetOnlineUserByUserNameResponse_element testobj9 = new ContactPasswordWS.GetOnlineUserByUserNameResponse_element();
        ContactPasswordWS.DeletePhoneNumber_element testobj0 = new ContactPasswordWS.DeletePhoneNumber_element();
        ContactPasswordWS.UpdateIvrPhonePermission_element testobj11 = new ContactPasswordWS.UpdateIvrPhonePermission_element();
        ContactPasswordWS.GetOnlineUserByAccount_element testobj12 = new ContactPasswordWS.GetOnlineUserByAccount_element();
        ContactPasswordWS.GetEmailByContactSapIdResponse_element testobj13 = new ContactPasswordWS.GetEmailByContactSapIdResponse_element();
        ContactPasswordWS.GetContactsByIvrPhoneNumber_element testobj14 = new ContactPasswordWS.GetContactsByIvrPhoneNumber_element();
        ContactPasswordWS.GetContactsByCustSapPhoneNumber_element testobj15 = new ContactPasswordWS.GetContactsByCustSapPhoneNumber_element();
        ContactPasswordWS.GetEmailByContactSapId_element testobj16 = new ContactPasswordWS.GetEmailByContactSapId_element();
        ContactPasswordWS.GetContactsByIvrPhoneNumberResponse_element testobj17 = new ContactPasswordWS.GetContactsByIvrPhoneNumberResponse_element();
        ContactPasswordWS.GetContactsByAcctSapIdResponse_element testobj18 = new ContactPasswordWS.GetContactsByAcctSapIdResponse_element();
        ContactPasswordWS.GetContactsByAcctSapId_element testobj19 = new ContactPasswordWS.GetContactsByAcctSapId_element();
        ContactPasswordWS.GetContactsByCustSapPhoneNumberResponse_element testObj20 = new ContactPasswordWS.GetContactsByCustSapPhoneNumberResponse_element();
        ContactPasswordWS.GetContactsByAcctSapIdResponse_element  testObj21 = new ContactPasswordWS.GetContactsByAcctSapIdResponse_element();
        
        testPort.GetContactsByAcctSapId(decimal.valueof(testAcc1.SAPAccountNumber__c),'test','test','test','test',new string[]{'test'},new string[]{'test'},1);
        testPort.DeletePhoneNumber(decimal.valueof(testContact.SAP_Contact_ID__c),'test','123');
        testPort.AddPhoneNumber(decimal.valueof(testContact.SAP_Contact_ID__c),'test','123','test','test','test');
        testPort.GetOnlineUserByContactSapId(decimal.valueof(testContact.SAP_Contact_ID__c));
        testPort.UpdateIvrPhonePermission(decimal.valueof(testContact.SAP_Contact_ID__c),'test');
        testPort.FindContactByIvrPhone('123',2);
        testPort.GetEmailByContactSapId(decimal.valueof(testContact.SAP_Contact_ID__c));
        testPort.GetOnlineUserByAccount('test',decimal.valueof(testAcc1.SAPAccountNumber__c),'test','test','test','test',1,1);
        testPort.GetContactsByCustSapPhoneNumber('123',new string[]{'test'},new string[]{'test'},1);    
        testPort.GetContactsByIvrPhoneNumber('123',new string[]{'test'},new string[]{'test'},1);                          
        testPort.GetOnlineUserByUserName('test');
        
    }
    
}