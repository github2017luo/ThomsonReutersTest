/********************************************************************************
Class Name : DCPSSD_Test 
@description : This class is used to test DCPSSD Class. 
********************************************************************************
CHANGE HISTORY
===============================================================================
Date				          Developer				     Description
25-05-2021                  Vishnu Santhosh            Initial Creation
*********************************************************************************/ 
@isTest
public with sharing class DCPSSD_Test {
    
    @TestSetup
    static void setup() {
        
        List<Source_System_Detail__c> testSSD = new List<Source_System_Detail__c>();
        Map<String, SObject> ssdMap = DCPTestDataFactory.declareSObjectData();
        DCPTestDataFactory.disableApplicationAutomation();
        testSSD.add((Source_System_Detail__c)ssdMap.get('Source_System_Detail__c'));
        insert testSSD;
    }

    @isTest static void testSSDRetrievalSuccess() {
        List<Source_System_Detail__c> testSSDs= [SELECT Id from Source_System_Detail__c];
        List<Id> testSSDIds = new List<Id>();
        List<Source_System_Detail__c> retrievedSSDs = new List<Source_System_Detail__c>();
        testSSDIds.add(testSSDs[0].Id);
        Test.startTest();
        retrievedSSDs = DCPSSD.getSSD(testSSDIds);
        Test.stopTest();
        System.assertEquals(testSSDs[0].id, retrievedSSDs[0].id,'The returned Data from DCPSSD is not correct.');
    }
}