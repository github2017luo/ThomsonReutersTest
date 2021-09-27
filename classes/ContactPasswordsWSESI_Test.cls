/**
 * Validates the functionality provided by the ContactPasswordsServices class.
 *
 * @author  Subhajit Karmakar
 * @version  1.0
 */
 
 /**
 * CHANGE HISTORY
 * =============================================================================
 * Date         Name                    Description
 * 2016-09-27   Subhajit                Created                                                                   
 * =============================================================================
 */
 
@IsTest(seealldata=true)
private class ContactPasswordsWSESI_Test {

    public static testmethod void testContactPasswordsWS(){
        Account testAcc1 = UnitTest.getAccountInstance();
        testAcc1.SAPAccountNumber__c = '1';
        insert testAcc1;
        
        Contact testContact = UnitTest.getContactInstance(testAcc1.Id);
        testContact.SAP_Contact_ID__c = '16113';
        insert testContact;
        ContactPasswordWSESI testContactPasswordsWS = new ContactPasswordWSESI();
        ContactPasswordWSESI.Contact_v11_0BindingQSPort testPort =  new ContactPasswordWSESI.Contact_v11_0BindingQSPort();
        
        ContactPasswordWSESI.GetOnlineUserByAccountResponse_element testobj1 = new ContactPasswordWSESI.GetOnlineUserByAccountResponse_element();
        ContactPasswordWSESI.GetOnlineUserByContactSapId_element testobj2 = new ContactPasswordWSESI.GetOnlineUserByContactSapId_element();
        ContactPasswordWSESI.UpdateIvrPhonePermissionResponse_element testobj3 = new ContactPasswordWSESI.UpdateIvrPhonePermissionResponse_element();        
        ContactPasswordWSESI.GetOnlineUserByUserName_element  testobj4 = new ContactPasswordWSESI.GetOnlineUserByUserName_element();
        ContactPasswordWSESI.GetOnlineUserByContactSapIdResponse_element testobj5 = new ContactPasswordWSESI.GetOnlineUserByContactSapIdResponse_element();
        ContactPasswordWSESI.FindContactByIvrPhone_element  testobj6 = new ContactPasswordWSESI.FindContactByIvrPhone_element();
        ContactPasswordWSESI.AddPhoneNumberResponse_element  testobj7 = new ContactPasswordWSESI.AddPhoneNumberResponse_element();
        ContactPasswordWSESI.FindContactByIvrPhoneResponse_element testobj8 = new ContactPasswordWSESI.FindContactByIvrPhoneResponse_element();
        ContactPasswordWSESI.GetOnlineUserByUserNameResponse_element testobj9 = new ContactPasswordWSESI.GetOnlineUserByUserNameResponse_element();
        ContactPasswordWSESI.DeletePhoneNumber_element testobj0 = new ContactPasswordWSESI.DeletePhoneNumber_element();
        ContactPasswordWSESI.UpdateIvrPhonePermission_element testobj11 = new ContactPasswordWSESI.UpdateIvrPhonePermission_element();
        ContactPasswordWSESI.GetOnlineUserByAccount_element testobj12 = new ContactPasswordWSESI.GetOnlineUserByAccount_element();
        ContactPasswordWSESI.GetEmailByContactSapIdResponse_element testobj13 = new ContactPasswordWSESI.GetEmailByContactSapIdResponse_element();
        ContactPasswordWSESI.GetContactsByIvrPhoneNumber_element testobj14 = new ContactPasswordWSESI.GetContactsByIvrPhoneNumber_element();
        ContactPasswordWSESI.GetContactsByCustSapPhoneNumber_element testobj15 = new ContactPasswordWSESI.GetContactsByCustSapPhoneNumber_element();
        ContactPasswordWSESI.GetEmailByContactSapId_element testobj16 = new ContactPasswordWSESI.GetEmailByContactSapId_element();
        ContactPasswordWSESI.GetContactsByIvrPhoneNumberResponse_element testobj17 = new ContactPasswordWSESI.GetContactsByIvrPhoneNumberResponse_element();
        ContactPasswordWSESI.GetContactsByAcctSapIdResponse_element testobj18 = new ContactPasswordWSESI.GetContactsByAcctSapIdResponse_element();
        ContactPasswordWSESI.GetContactsByAcctSapId_element testobj19 = new ContactPasswordWSESI.GetContactsByAcctSapId_element();
        ContactPasswordWSESI.GetContactsByCustSapPhoneNumberResponse_element testObj20 = new ContactPasswordWSESI.GetContactsByCustSapPhoneNumberResponse_element();
        ContactPasswordWSESI.GetContactsByAcctSapIdResponse_element  testObj21 = new ContactPasswordWSESI.GetContactsByAcctSapIdResponse_element();
        
        /*testPort.GetContactsByAcctSapId(decimal.valueof(testAcc1.SAPAccountNumber__c),'test','test','test','test',new string[]{'test'},new string[]{'test'},1);
        testPort.DeletePhoneNumber(decimal.valueof(testContact.SAP_Contact_ID__c),'test','123');
        testPort.AddPhoneNumber(decimal.valueof(testContact.SAP_Contact_ID__c),'test','123','test','test','test');
        testPort.GetOnlineUserByContactSapId(decimal.valueof(testContact.SAP_Contact_ID__c));
        testPort.UpdateIvrPhonePermission(decimal.valueof(testContact.SAP_Contact_ID__c),'test');
        testPort.FindContactByIvrPhone('123',2);
        testPort.GetEmailByContactSapId(decimal.valueof(testContact.SAP_Contact_ID__c));
        testPort.GetOnlineUserByAccount('test',decimal.valueof(testAcc1.SAPAccountNumber__c),'test','test','test','test',1,1);
        testPort.GetContactsByCustSapPhoneNumber('123',new string[]{'test'},new string[]{'test'},1);    
        testPort.GetContactsByIvrPhoneNumber('123',new string[]{'test'},new string[]{'test'},1);                          
        testPort.GetOnlineUserByUserName('test'); */
        
    }
    
}