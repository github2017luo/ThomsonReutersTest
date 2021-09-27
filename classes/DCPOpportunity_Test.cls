/********************************************************************************
Class Name : DCPOpportunity_Test 
@description : This class is used to test DCPOpportunity class 
********************************************************************************
CHANGE HISTORY
===============================================================================
Date				          Developer					Description
26-05-2021                  Vishnu Santhosh            Initial Creation
*********************************************************************************/ 

@isTest
public with sharing class DCPOpportunity_Test {
    
    @TestSetup
    static void setup() {

        List<Opportunity> testOpportunity = new List<Opportunity>();
        Map<String, Sobject> objectToDataMap = DCPTestDataFactory.declareSObjectData();
        DCPTestDataFactory.disableApplicationAutomation(); 
        testOpportunity.add((Opportunity)objectToDataMap.get('Opportunity'));
        insert testOpportunity;
    }
    @isTest static void testGetOpportunity() {

        List<Opportunity> testOpportunity = [SELECT id, Name From Opportunity];
        List<Id> testOpportuntiyId = new List<Id>();
        List<Opportunity> retrievedTestOpportunity = new List<Opportunity>();
        testOpportuntiyId.add(testOpportunity[0].Id);
        Test.startTest();
        retrievedTestOpportunity = DCPOpportunity.getOpportunity(testOpportuntiyId);
        Test.stopTest();
        System.assertEquals(testOpportunity[0].Id, retrievedTestOpportunity[0].Id, 'The returned data from DCPOpportunity is not correct.');
    }
}