/***********************************************************************************************
Purpose      : Test class for BulkAccountMergerBatch class 
Developed By : TCS Offshore
Date         : 11/23/2016
Changed Log  :
************************************************************************************************/
@istest
public class BulkAccountMergerBatch_Test {
    public static testmethod void bulkAccountMerge_Test(){
        Integer countAcc = 10;
        Integer i;
        Integer j = 0;
        Integer k = 0;        
        Integer countContact = 200;
        list<Account> listPLAccounts = new List<Account>();
        list<Account> listSAPAccounts = new List<Account>();
        list<Contact> listPLContacts = new List<Contact>();
        list<Contact> listSAPContacts = new List<Contact>();
        
        //Calling method from UnitTest class to prepare test data for Custom Settings
        UnitTest.createTestData();

        //Preparing Account test data : Set1
        for (i = 0; i < countAcc; i++) { 
            Account sapAcc = getAccountInstance(i,'sapAccount',''); 
            listSAPAccounts.add(sapAcc);            
        }
        system.debug('listSAPAccounts1' + listSAPAccounts);
        
        INSERT listSAPAccounts;
        
        for(Account a : listSAPAccounts)
        {
            Account plAcc = getAccountInstance(j,'PLAccount','PL_LegacyId');
            plAcc.MasterAccount__c = a.Id;
            listPLAccounts.add(plAcc);                      
            Contact sapCon = getContactInstance(j,'SAPContact',a.Id);
            listSAPContacts.add(sapCon);            
            j++;            
        }
        INSERT listPLAccounts;
        INSERT listSAPContacts;
        j = 0;
        for(Account a : listPLAccounts)
        {
            for (k = 0; k < countContact; k++) { 
                Contact plCon = getContactInstance(k,'PLContact',a.Id);
                listPLContacts.add(plCon); 
            }
            j++;
        }
        INSERT listPLContacts;

        Test.StartTest();
        BulkAccountMergerBatch bulkAccMergeBatch = new BulkAccountMergerBatch();
        Database.executeBatch(bulkAccMergeBatch);   
        Test.StopTest();
        system.debug('listSAPAccounts2' + listSAPAccounts);
    }
        public static Account getAccountInstance(Integer i, String accName, String legacyId) {
        Account oAccount = new Account();
        oAccount.Name = accName + i;
        oAccount.Sales_Org__c = 'BEJE';
        oAccount.Customer_Type__c = 'Individual';
        oAccount.Customer_Group__c = 'ACADEMIC';
        oAccount.Legacy_System_ID__c = legacyId + i;
        oAccount.Industry = 'TAX';
        return oAccount;
        }
        public static Contact getContactInstance(Integer i, String cName, String accId) {
            Contact oCon = new Contact();
            oCon.FirstName = cName + i;
            oCon.LastName = cName + i;
            oCon.Email= 'PL_test.test@tr.com' + i;
            oCon.accountId = accId;
            return oCon;
        }
}