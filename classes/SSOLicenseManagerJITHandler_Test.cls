/********************************************************

Class name   : SSOLicenseManagerJITHandler_Test

Purpose      : Test class for SSOLicenseManagerJITHandler apex class 
               For DPS-7686 [Creation of Registration Handler (JIT- dynamic licensing)]

Developed By : Niket Kapasi

Date         : 09-10-2019
*********************************************************/
@isTest
private  class SSOLicenseManagerJITHandler_Test {
    
    @isTest static void createUserandUpdateUser(){
        SSOLicenseManagerJITHandler handler = new SSOLicenseManagerJITHandler();
        
        User federationUser = new User();
        Profile p = [SELECT Id FROM profile WHERE name='Standard User'];
        federationUser.ProfileId = p.Id;
        federationUser.Email = 'efuser@er.com';
        federationUser.FirstName = 'fname';
        federationUser.LastName = 'lname';
        federationUser.Username = 'fname.lname@l.com';
        federationUser.Alias = 'aliasF';
        //CommunityNickname, TimeZoneSidKey, LocaleSidKey, EmailEncodingKey, LanguageLocaleKey
        federationUser.FederationIdentifier = 'XID01';
        federationUser.CommunityNickname = 'testCU';
        federationUser.TimeZoneSidKey = 'GMT';
        federationUser.LocaleSidKey = 'en_US';
        federationUser.EmailEncodingKey = 'ISO-8859-1';
        federationUser.LanguageLocaleKey = 'en_US';
        federationUser.InFrequent_User__c = true;
        federationUser.Infrequent_User_Timeout__c=4.0;
        federationUser.IsActive = false;
        insert federationUser;
        
        Auth.UserData sampleData = new Auth.UserData('XID01',
                                                     'testFirst',
                                                     'testLast',
                                                     'testFirst testLast',
                                                     'testuser@example.org',
                                                     null,
                                                     'testuserlong',
                                                     'en_US',
                                                     'facebok',
                                                     null, new Map<String, String>{'language' => 'en_US'});
        User u = handler.createUser(null, sampleData);
        handler.updateUser(federationUser.id,null, sampleData);
        
        String uid = u.id;
        System.assertEquals(u.id, federationUser.Id);
    }
    
    /* @isTest static void updateUser(){}

@testSetup static void futureMethod(){}*/
    
    
}