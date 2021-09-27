@IsTest
public class ESC_onePassUserLWCController_Test 
{
    
    static testMethod void testcallOutHelper()
    { 
        User testUserexp = new User(
            Alias = 'jonMay', 
            Email='jon-meyer@testorg.com',
            EmailEncodingKey='UTF-8', 
            LanguageLocaleKey='en_US',
            LocaleSidKey='en_US', 
            ProfileId = userinfo.getProfileid(),
            Sales_Org__c = 'West',
            Sub_Bu__c='Usl',
            TimeZoneSidKey='America/Los_Angeles', 
            UserName='jon-meyer@thomsonreuters.com',
            LastName='jon-meyer'
        );
        insert testUserexp;
        
        system.runAs(testUserexp)
        {
            Account oAcct = UnitTest.getAccountInstance();
            oAcct.BillingStreet = '18321 kerrville';
            oAcct.BillingCity = 'lakeville';
            oAcct.BillingState = 'MN';
            oAcct.BillingPostalCode = '55044';
            
            insert oAcct;
            
            
            Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();
            Source_System_Detail__c accountSSD= new Source_System_Detail__c();
            accountSSD.RecordtypeId=ssdRecorType;
            accountSSD.Name='ABC';
            accountSSD.Source_System_Name__c='ABC_account';
            accountSSD.Account_Name__c=oAcct.ID;
            accountSSD.LCRM_Frozen_Market_Segment__c ='valueMarket';
            accountSSD.Account_Inactive__c=false;
            accountSSD.LCRM_Sales_Org__c='WEST';
            
            insert accountSSD;
            List<LCRM_Contact_SSD__c> listContacts= new List<LCRM_Contact_SSD__c>();
            
            LCRM_Contact_SSD__c contacts1=new LCRM_Contact_SSD__c(Name='SSD Test',
                                                                  LCRM_Contact_ID__c='jon-meyer',
                                                                  LCRM_Account_SSD__c=accountSSD.Id,
                                                                  LCRM_First_Name__c='testConSSD',
                                                                  LCRM_Last_Name__c='testLastConSSD',
                                                                  LCRM_SAP_Account_Number__c='1234567890',
                                                                  LCRM_Source_Contact_Id__c = '1234567890',
                                                                  LCRM_Phone__c='87786642345');
            
            LCRM_Contact_SSD__c contacts2=new LCRM_Contact_SSD__c(Name='SSD Test2',
                                                                  LCRM_Contact_ID__c='jon-meyer-Jaya',
                                                                  LCRM_Account_SSD__c=accountSSD.Id,
                                                                  LCRM_First_Name__c='testConSSD',
                                                                  LCRM_Last_Name__c='testLastConSSD',
                                                                  LCRM_SAP_Account_Number__c='123456789',
                                                                  LCRM_Source_Contact_Id__c = '0123456789',
                                                                  LCRM_Phone__c='87786642349');
            
            
            listContacts.add(contacts1);
            listContacts.add(contacts2);
            insert listContacts;
            
            
        }
        Test.startTest();
        ESC_onePassUserLWCController.retriveAccs('jon-meyer');                     
        Test.setMock(HttpCalloutMock.class, new MockOnepassController());
        
        ESC_onePassUserLWCController.retriveAccs('jon-meyer');                     
        
        Test.stopTest();
        
    }  
}