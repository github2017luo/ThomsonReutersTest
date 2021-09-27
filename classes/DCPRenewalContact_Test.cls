@isTest
public class DCPRenewalContact_Test{
    
    @TestSetup
    static void makeData(){
    
        DCPTestDataFactory.disableApplicationAutomation();

        Map<String, SObject> objectToDataMap = DCPTestDataFactory.declareSObjectData();
        Account acc = (Account)objectToDataMap.get('Account');
        insert acc;
        
        Contact con = (Contact)objectToDataMap.get('Contact');
        con.AccountId = acc.id;
        insert con;
        
    }

    @isTest
    private static void populateContactDetailsTest(){

        Contact con = [SELECT id FROM Contact LIMIT 1];
        con = DCPContact.getContact(new List<Id>{con.id})[0];

        Test.startTest();
        DCPRenewalContactWrapper  contactWrapper = DCPRenewalContact.populateContactDetails(con);
        System.assert(contactWrapper != null, 'Wrapper is null');
        Test.stopTest();
    }
}