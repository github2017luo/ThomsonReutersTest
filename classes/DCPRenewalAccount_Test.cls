@isTest
public class DCPRenewalAccount_Test{
    
    @TestSetup
    static void makeData(){
    
        DCPTestDataFactory.disableApplicationAutomation();

        Map<String, SObject> objectToDataMap = DCPTestDataFactory.declareSObjectData();
        Account acc = (Account)objectToDataMap.get('Account');
        insert acc;
        
        Source_System_Detail__c ssd = (Source_System_Detail__c)objectToDataMap.get('Source_System_Detail__c');
        ssd.Account_Name__c = acc.id;
        insert ssd;
        
    }

    @isTest
    private static void populateAccountDetailsTest(){

        Source_System_Detail__c ssd = [SELECT id,Account_Name__c FROM Source_System_Detail__c WHERE Name = 'ABC' LIMIT 1];
        ssd = DCPSSD.getSSD(new List<Id>{ssd.Id})[0];
        Account acc = DCPAccount.getAccounts(new List<id>{ssd.Account_Name__c})[0];  

        Test.startTest();
        DCPRenewalAccountWrapper accountWrapper = DCPRenewalAccount.populateAccountDetails(acc, ssd);
        System.assert(accountWrapper != null, 'Wrapper is null');
        Test.stopTest();
    }

}