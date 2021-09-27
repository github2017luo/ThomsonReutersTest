/*
@Author: Navjyoti Mohanta
@JIRA Story: CRM-8058
@Purpose: This Test class is for LCRMBatchForActiveContactEntitlements batch Class and LCRMScheduledBatchForContactEntitlements schedule class.
@Version: 

* CHANGE HISTORY
* =============================================================================
* Date              Name                    Description
* 01/04/2018    Navjyoti            For EQA comments and CRM-13693 Bug                                  
* =============================================================================
*/
@isTest()
public class LCRMBatchContactEntitlementsTest {
    static testMethod void myUnitTest() {
    
        Id RecordTypeIdContact = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('GLI Contact').getRecordTypeId();
        Account testAccount = new Account(
            Name = 'Test To Check For Abbriviated Name', 
            Phone = '3198374720',
            BillingCountry ='US',
            BillingState='IL',
            BillingPostalCode = '60603-3801',        
            Description='Good'
        );
        insert testAccount;
        
        Contact testContact = new Contact(
            FirstName='Test' ,
            LastName = 'TestLastName To Check For Abbriviated Name', 
            Title='senior devloper',
            Phone = '3198374720', 
            AccountId = testAccount.Id, 
            DoNotCall=true,
            Do_not_Mail__c=false,
            Email = 'test@gmail.com',
            RecordTypeId = RecordTypeIdContact          
        );
        insert testContact;
        
        Contact testContact2 = new Contact(
            FirstName='Test2' ,
            LastName = 'TestLastName2 To Check For Abbriviated Name', 
            Title='senior devloper',
            Phone = '3198374720', 
            AccountId = testAccount.Id, 
            DoNotCall=true,
            Do_not_Mail__c=false,
            Email = 'test@gmail.com',
            RecordTypeId = RecordTypeIdContact          
        );
        insert testContact2;
        
        Asset testAsset = new Asset(
            Name ='Test Asset',
            AccountId = testAccount.Id
            //TR_Retention__Product_Family__c ='Research',
            //TR_Retention__Sub_Business_Unit__c ='Small Law'            
        );
        insert  testAsset ;
        
        LCRM_Contact_Entitlement__c contactEntitlement = new LCRM_Contact_Entitlement__c(
            LCRM_Contact__c =testContact.Id,
            LCRM_Asset__c = testAsset.Id,
            LCRM_Access_Start_Date__c = Date.Today() -1,
            LCRM_Access_End_Date__c = Date.Today() +1        
        );
        insert contactEntitlement ;
        
         LCRM_Contact_Entitlement__c contactEntitlement2 = new LCRM_Contact_Entitlement__c(
            LCRM_Contact__c =testContact2.Id,
            LCRM_Asset__c = testAsset.Id,
            LCRM_Access_Start_Date__c = Date.Today() -1,
            LCRM_Access_End_Date__c = Date.Today() -1        
        );
        insert contactEntitlement2 ;
        
        Test.StartTest();
        LCRMBatchForActiveContactEntitlements  contactsUpdated = new LCRMBatchForActiveContactEntitlements();
        Database.executeBatch(contactsUpdated);
        System.AssertEquals(testContact2.LCRM_Active_Entitlement__c , false);
        Test.StopTest();        
         
         
    }
    
    public static testMethod void testschedule(){
        Test.StartTest();
        LCRMScheduledBatchForContactEntitlements sh1 = new LCRMScheduledBatchForContactEntitlements ();
        String sch = '0 0 5 * * ?';
        system.schedule('Test Territory Check', sch, sh1);
        Test.stopTest();
    }
    
    static testMethod void myUnitTest2() {
    
        //Test class for LCRMBatch2ForActiveContactEntitlements class
        Id RecordTypeIdContact = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('GLI Contact').getRecordTypeId();
        Account testAccount = new Account(
            Name = 'Test To Check For Abbriviated Name', 
            Phone = '3198374720',
            BillingCountry ='US',
            BillingState='IL',
            BillingPostalCode = '60603-3801', 
            Is_GLI__c = true,       
            Description='Good'
        );
        insert testAccount;
        
        Contact testContact = new Contact(
            FirstName='Test' ,
            LastName = 'TestLastName To Check For Abbriviated Name', 
            Title='senior devloper',
            Phone = '3198374720', 
            AccountId = testAccount.Id, 
            DoNotCall=true,
            Do_not_Mail__c=false,
            Email = 'test@gmail.com',
            LCRM_Active_Entitlement__c = false,
            RecordTypeId = RecordTypeIdContact          
        );
        insert testContact;
        
        Contact testContact2 = new Contact(
            FirstName='Test2' ,
            LastName = 'TestLastName2 To Check For Abbriviated Name', 
            Title='senior devloper',
            Phone = '3198374720', 
            AccountId = testAccount.Id, 
            DoNotCall=true,
            Do_not_Mail__c=false,
            Email = 'test@gmail.com',
            LCRM_Active_Entitlement__c = true ,
            RecordTypeId = RecordTypeIdContact          
        );
        insert testContact2;
        
        Contact testContact3 = new Contact(
            FirstName='Test3' ,
            LastName = 'TestLastName3 To Check For Abbriviated Name', 
            Title='senior devloper',
            Phone = '3199374720', 
            AccountId = testAccount.Id, 
            DoNotCall=true,
            Do_not_Mail__c=false,
            Email = 'test@gmail.com',
            LCRM_Active_Entitlement__c = true ,
            RecordTypeId = RecordTypeIdContact          
        );
        insert testContact3;
        
        Asset testAsset = new Asset(
            Name ='Test Asset',
            AccountId = testAccount.Id
            //TR_Retention__Product_Family__c ='Research',
            //TR_Retention__Sub_Business_Unit__c ='Small Law'            
        );
        insert  testAsset ;
        
        LCRM_Contact_Entitlement__c contactEntitlement = new LCRM_Contact_Entitlement__c(
            LCRM_Contact__c =testContact.Id,
            LCRM_Asset__c = testAsset.Id,
            LCRM_Access_Start_Date__c = Date.Today(),
            LCRM_Access_End_Date__c = Date.Today() +1        
        );
        insert contactEntitlement ;
        
         LCRM_Contact_Entitlement__c contactEntitlement2 = new LCRM_Contact_Entitlement__c(
            LCRM_Contact__c =testContact2.Id,
            LCRM_Asset__c = testAsset.Id,
            LCRM_Access_Start_Date__c = Date.Today() -1,
            LCRM_Access_End_Date__c = Date.Today() -1        
        );
        insert contactEntitlement2 ;
        
        LCRM_Contact_Entitlement__c contactEntitlement3 = new LCRM_Contact_Entitlement__c(
            LCRM_Contact__c =testContact3.Id,
            LCRM_Asset__c = testAsset.Id,
            LCRM_Access_Start_Date__c = Date.Today() -1,
            LCRM_Access_End_Date__c = Date.Today() +1        
        );
        insert contactEntitlement3 ;
        
        LCRM_Contact_Entitlement__c contactEntitlement4 = new LCRM_Contact_Entitlement__c(
            LCRM_Contact__c =testContact3.Id,
            LCRM_Asset__c = testAsset.Id,
            LCRM_Access_Start_Date__c = Date.Today() -1,
            LCRM_Access_End_Date__c = Date.Today() -1        
        );
        insert contactEntitlement4 ;
        
        Test.StartTest();
        LCRMBatch2ForActiveContactEntitlements  contactsUpdated2 = new LCRMBatch2ForActiveContactEntitlements();
        Database.executeBatch(contactsUpdated2);        
        Test.StopTest();          
         
         
    }
     public static testMethod void testschedule2(){
        Test.StartTest();
        LCRMScheduledBatch2ForContactEntitlement sh2 = new LCRMScheduledBatch2ForContactEntitlement ();
        String sch = '0 0 5 * * ?';
        system.schedule('Test Territory Check', sch, sh2);
        Test.stopTest();
    }
}