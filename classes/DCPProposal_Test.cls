/********************************************************************************
Class Name : DCPProposal_Test 
@description : This class is used to test DCPProposal class 
********************************************************************************
CHANGE HISTORY
===============================================================================
Date				           Developer				  Description
26-05-2021                  Vishnu Santhosh            Initial Creation
*********************************************************************************/ 

@isTest
public with sharing class DCPProposal_Test {
    
    @TestSetup
    static void setup(){
        
        List<Source_System_Detail__c> ssdList = new List<Source_System_Detail__c>();
        List<Opportunity> opportunityList = new List<Opportunity>();
        List<Apttus_Proposal__Proposal__c> proposalList = new List<Apttus_Proposal__Proposal__c>();
        List<Apttus_Config2__ProductConfiguration__c> cartList = new List<Apttus_Config2__ProductConfiguration__c>();
        Map<String, SObject> objectToDataMap = DCPTestDataFactory.declareSObjectData();
        DCPTestDataFactory.disableApplicationAutomation();

        //Insert Source System Detail
        ssdList.add((Source_System_Detail__c)objectToDataMap.get('Source_System_Detail__c'));
        insert ssdList;

        //Insert Opportunity
        opportunityList.add((Opportunity)objectToDataMap.get('Opportunity'));
        opportunityList[0].Source_System_Detail__c = ssdList[0].Id;
        insert opportunityList;

        //Insert Proposal
        proposalList.add((Apttus_Proposal__Proposal__c)objectToDataMap.get('Apttus_Proposal__Proposal__c'));
        proposalList[0].Apttus_Proposal__Approval_Stage__c = 'Presented';
        proposalList[0].APTS_SSD_bill_to__c = ssdList[0].Id;
        proposalList[0].Apttus_Proposal__Opportunity__c = opportunityList[0].Id;
        proposalList[0].Apttus_Proposal__Primary__c=true;
        proposalList[0].DocuSign_Envelope_ID__c='bnb';
        insert proposalList;

        //Insert Cart
        cartList.add((Apttus_Config2__ProductConfiguration__c)objectToDataMap.get('Apttus_Config2__ProductConfiguration__c'));
        cartList[0].Apttus_QPConfig__Proposald__c = proposalList[0].id;
        cartList[0].Apttus_Config2__Status__c = 'Finalized';
        insert cartList;
        
         Apttus_Proposal__Proposal_Line_Item__c p = new Apttus_Proposal__Proposal_Line_Item__c();      
          p.APTS_Proposal_Business_Unit__c ='Corp OneOTC US';         
          p.APTS_Contract_Term__c = '1 Year';
          p.Apttus_QPConfig__PriceType__c='Recurring';
          p.Apttus_QPConfig__ChargeType__c='Subscription fee';
        
          p.Apttus_QPConfig__LineType__c = 'Product/Service';
          p.Apttus_QPConfig__LineNumber__c = 1;
          p.Apttus_QPConfig__NetPrice__c=1;
          p.Apttus_QPConfig__LineStatus__c = 'New';
          p.APTS_Renewal_Type__c = 'Evergreen';
          p.APTS_Term_Type__c = null;
          p.APTS_Item_Category_Group__c = 'ZT07';
          p.APTS_Contract_Term_Number__c = 24;
          p.APTS_WLEC_Product_Category__c = 'PS';
          p.Apttus_Proposal__Proposal__c=proposallist[0].id; 
	    	insert p;        
      
      
       
    }
    
    @isTest static void testGetProposalLineItems() {
        List<Apttus_Proposal__Proposal__c> testProposal1 =   [SELECT Id
                                                        FROM Apttus_Proposal__Proposal__c];
        id testProposal =  testProposal1[0].id;
        List<Apttus_Proposal__Proposal_Line_Item__c> retrievedProposalLineitem = new List<Apttus_Proposal__Proposal_Line_Item__c>();
  

        Test.startTest();
        retrievedProposalLineitem = DCPProposal.getProposalLineItems(testProposal);
        Test.stopTest();
        System.assertNotEquals(testProposal1[0].id, retrievedProposalLineitem[0].Id, 'The returned data from DCPProposal is not correct.');
    }

@isTest static void testGetProposal() {
        List<Id> proposalId = new List<Id>(); 
        List<Apttus_Proposal__Proposal__c> testProposal =   [SELECT Id
                                                        FROM Apttus_Proposal__Proposal__c];
        List<Apttus_Proposal__Proposal__c> retrievedProposal = new List<Apttus_Proposal__Proposal__c>();
        proposalId.add(testProposal[0].Id);

        Test.startTest();
        retrievedProposal = DCPProposal.getProposal(proposalId);
        Test.stopTest();
        System.assertEquals(testProposal[0].Id, retrievedProposal[0].Id, 'The returned data from DCPProposal is not correct.');
    }

    @isTest static void testGetPresentedProposal() {
        
        Source_System_Detail__c testSSD = [SELECT id FROM Source_System_Detail__c LIMIT 1];
        Opportunity testOpportunity = [ SELECT id from Opportunity LIMIT 1];
        List<Apttus_Proposal__Proposal__c> testProposal = [SELECT id 
                                                            FROM Apttus_Proposal__Proposal__c
                                                            WHERE Apttus_Proposal__Opportunity__c =: testOpportunity.Id
                                                            AND APTS_SSD_bill_to__c =: testSSD.Id
                                                            AND Apttus_Proposal__Approval_Stage__c = 'Presented'];

        Test.startTest();
        List<Apttus_Proposal__Proposal__c> retrievedProposal = DCPProposal.getPresentedProposal(testOpportunity.Id, testSSD.Id);
        Test.stopTest();
        System.assertEquals(testProposal[0].Id, retrievedProposal[0].Id,'The returned data from DCPProposal is not correct.');
    }
    @isTest static void testGetPresentedProposalWithCart() {
        
        Source_System_Detail__c testSSD = [SELECT id FROM Source_System_Detail__c LIMIT 1];
        Opportunity testOpportunity = [ SELECT id from Opportunity LIMIT 1];
        List<Apttus_Proposal__Proposal__c> testProposal = [SELECT id
                                                            FROM Apttus_Proposal__Proposal__c
                                                            WHERE Apttus_Proposal__Opportunity__c =: testOpportunity.Id
                                                            AND APTS_SSD_bill_to__c =: testSSD.Id
                                                            AND Apttus_Proposal__Approval_Stage__c = 'Presented'];

        Test.startTest();
        List<Apttus_Proposal__Proposal__c> retrievedProposal = DCPProposal.getPresentedProposalWithCart(testOpportunity.Id, testSSD.Id);
        Test.stopTest();
        System.assertEquals(testProposal[0].Id, retrievedProposal[0].Id,'The returned data from DCPProposal is not correct.');
    }
}