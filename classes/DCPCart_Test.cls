/********************************************************************************
Class Name : DCPCart_Test   
@description : This class is used for testing DCPCart class.
*********************************************************************************
CHANGE HISTORY
===============================================================================
Date                           Developer                Description
21-05-2021                  Vishnu Santhosh            Initial Creation
*********************************************************************************/ 

@isTest
public class DCPCart_Test {

    @TestSetup
    static void setup() {

        List<Apttus_Proposal__Proposal__c> proposal = new List<Apttus_Proposal__Proposal__c>();
        List<Apttus_Config2__ProductConfiguration__c> testCart = new List<Apttus_Config2__ProductConfiguration__c>();
        List<Apttus_Config2__LineItem__c> cartLineItem = new List<Apttus_Config2__LineItem__c>();

        Map<String, Sobject> objectToDataMap = DCPTestDataFactory.declareSObjectData();
        DCPTestDataFactory.disableApplicationAutomation();

        proposal.add((Apttus_Proposal__Proposal__c)objectToDataMap.get('Apttus_Proposal__Proposal__c'));
        insert proposal;

        testCart.add((Apttus_Config2__ProductConfiguration__c)objectToDataMap.get('Apttus_Config2__ProductConfiguration__c'));
        testCart[0].Apttus_QPConfig__Proposald__c = proposal[0].id;
        testCart[0].Apttus_Config2__Status__c = 'Finalized';
        insert testCart;

        cartLineItem.add((Apttus_Config2__LineItem__c)objectToDataMap.get('Apttus_Config2__LineItem__c'));
        cartLineItem[0].Apttus_Config2__ConfigurationId__c = testCart[0].id;
        cartLineItem[0].Apttus_Config2__LineNumber__c = 1;
        cartLineItem[0].Apttus_Config2__ItemSequence__c = 1;
        insert cartLineItem;
       

    }
    @isTest static void testGetCart() {

        List<Id> testCartIds = new List<Id>();
        List<Apttus_Config2__ProductConfiguration__c> testCart =    [SELECT id,Name,Apttus_QPConfig__Proposald__c,
                                                                        (SELECT id
                                                                        FROM Apttus_Config2__LineItems__r
                                                                        WHERE Apttus_Config2__LineStatus__c != 'Cancelled')  
                                                                    FROM Apttus_Config2__ProductConfiguration__c];

        List<Apttus_Config2__ProductConfiguration__c> retrievedCarts = new List<Apttus_Config2__ProductConfiguration__c>();

        testCartIds.add(testCart[0].Id);
        Test.startTest();
        retrievedCarts = DCPCart.getCart(testCartIds);
        Test.stopTest();
        System.assertEquals(testCart[0].Id, retrievedCarts[0].Id, 'The returned data from DCPAccount is not correct.');
    }
     
     @isTest static void testGetFinalizeCartFromProposal() {

        List<Apttus_Proposal__Proposal__c> testProposal =   [SELECT id 
                                                            FROM Apttus_Proposal__Proposal__c ];
        List<Id> testProposalId = new List<Id>();
        testProposalId.add(testProposal[0].Id);
        List<Apttus_Config2__ProductConfiguration__c> testCart =    [SELECT Id
                                                                    FROM Apttus_Config2__ProductConfiguration__c
                                                                    WHERE Apttus_QPConfig__Proposald__c IN :testProposalId];
        List<Apttus_Config2__ProductConfiguration__c> retrievedCart = new List<Apttus_Config2__ProductConfiguration__c>();

        Test.startTest();
        retrievedCart = DCPCart.getFinalizeCartFromProposal(testProposal);
        Test.stopTest();
        System.assertEquals(testCart[0].Id, retrievedCart[0].Id, 'The returned data from DCPAccount is not correct.');

    }

    @isTest static void testGetCartLineItems() {
        
        List<Id> testLineItemIds = new List<Id>();
        List<Id> retrievedLineItemIds = new List<Id>();
        Apttus_Config2__ProductConfiguration__c testCart = [ SELECT id 
                                                            FROM Apttus_Config2__ProductConfiguration__c
                                                            LIMIT 1];
                                                        
        List<Apttus_Config2__LineItem__c> testLineItems = [SELECT id 
                                                            FROM Apttus_Config2__LineItem__c
                                                            WHERE Apttus_Config2__ConfigurationId__c =:testCart.Id];
        List<Apttus_Config2__LineItem__c> retrievedLineItems = new List<Apttus_Config2__LineItem__c>();

        for(Apttus_Config2__LineItem__c lineItem :  testLineItems ) {
            testLineItemIds.add(lineItem.Id);
        }
        Test.startTest();
        retrievedLineItems = DCPCart.getCartLineItems(testCart.Id);
        test.stopTest();
        
         for(Apttus_Config2__LineItem__c lineItem :  retrievedLineItems ) {
            retrievedLineItemIds.add(lineItem.Id);
        }
        System.assertEquals(testLineItemIds, retrievedLineItemIds, 'The returned data from DCPCart is not correct.');
    }
    
}