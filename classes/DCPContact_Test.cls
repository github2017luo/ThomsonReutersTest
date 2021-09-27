/********************************************************************************
Class Name : DCPContact_Test 
@description : This class is used for testing DCPContact Class. 
********************************************************************************
CHANGE HISTORY
===============================================================================
Date				           Developer				 Description
25-05-2021                  Vishnu Santhosh            Initial Creation
*********************************************************************************/ 


@isTest
public class DCPContact_Test {

    @TestSetup
    static void setup() {

        List<Contact> testContacts = new List<Contact>();
        Map<String, SObject> contactMap = DCPTestDataFactory.declareSObjectData();
        testContacts.add((Contact)contactMap.get('Contact'));
        insert testContacts; 
    }
    @isTest static void testContactInsertion() {

        List<Contact> testContacts = [SELECT id from Contact];
        List<Id> testContactIds = new List<Id>();
        List<Contact> retrievedTestContacts = new List<Contact>();
        testContactIds.add(testContacts[0].Id);
        test.startTest();
        retrievedTestContacts = DCPContact.getContact(testContactIds);
        test.stopTest();
        System.assertEquals(testContacts[0].Id, retrievedTestContacts[0].Id,'The returned data from DCPContact is not correct.');
    }
}