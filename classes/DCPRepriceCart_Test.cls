/********************************************************************************
Class Name : DCPRepriceCart_Test 
@description : This class is used to test DCPRepriceCart class. 
********************************************************************************
CHANGE HISTORY
===============================================================================
Date				           Developer				 Description
26-05-2021                  Vishnu Santhosh            Initial Creation
*********************************************************************************/ 


@isTest
public with sharing class DCPRepriceCart_Test {
    
    @TestSetup
    static void setup(){
        
        List<Apttus_Config2__ProductConfiguration__c> cart = new List<Apttus_Config2__ProductConfiguration__c>();
        List<Apttus_Config2__LineItem__c> lineItem = new List<Apttus_Config2__LineItem__c>();

        Map<String, SObject> objectToDataMap = DCPTestDataFactory.declareSObjectData();
        DCPTestDataFactory.disableApplicationAutomation();

        cart.add((Apttus_Config2__ProductConfiguration__c)objectToDataMap.get('Apttus_Config2__ProductConfiguration__c'));
        insert cart;

        lineItem.add((Apttus_Config2__LineItem__c)objectToDataMap.get('Apttus_Config2__LineItem__c'));
        lineItem[0].Apttus_Config2__ConfigurationId__c = cart[0].Id;
        lineItem[0].Apttus_Config2__PricingStatus__c='Pending';
        insert lineItem;

        
    }
    
    @isTest static void repriceCartSuccessfull() {
        
        List<Apttus_Config2__ProductConfiguration__c> cart =    [SELECT id
                                                                FROM Apttus_Config2__ProductConfiguration__c];
        System.debug(LoggingLevel.DEBUG, '*** DEBUGGING FROM DEV *** >> cart  :  '+ cart);
        Map<String, String> requestBody = new Map<String, String>();
        requestBody.put('cartId', cart[0].Id);
        System.debug(LoggingLevel.DEBUG, '*** DEBUGGING FROM DEV *** >> RequestBody  :  '+ requestBody);

        Test.startTest();
        String result = DCPRepriceCart.repriceCart(requestBody);
        Test.stopTest();

        System.assertEquals('Success', result,'The returned data is not correct !');
    }

    @isTest static void invalidRequestFormat() {

        Map<String, String> requestBody = new Map<String, String>();
        requestBody.put('configurationId', 'ABCDEFG');
        try{
            Test.startTest();
            DCPRepriceCart.repriceCart(requestBody);
            Test.stopTest();
        }
        catch(Exception ex){

            Boolean expectedExceptionThrown = ex.getMessage().contains('Request format is Invalid')?true:false;
            System.assertEquals(expectedExceptionThrown, true, 'The returned data is not correct !');
        }

    }

    @isTest static void invalidCartId(){

        Map<String,String> requestBody = new Map<String,String>();
        requestBody.put('cartId','ThisIsaWrongCartId');
        try{
            Test.startTest();
            DCPRepriceCart.repriceCart(requestBody);
            Test.stopTest();
        }
        catch(Exception ex) {
            Boolean expectedExceptionThrown = !String.isBlank(ex.getStackTraceString())?true:false;
            System.assertEquals(expectedExceptionThrown, true,'The returned data is not correct !');
        }
    }
    
}