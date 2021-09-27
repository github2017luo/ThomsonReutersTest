/*
 * CHANGE HISTORY
 * =======================================================================================================================
 * Date                 Name                Story
 * 2020-07-27           Benjamin Her        DLT-20456 - Updated class to remove segmentation references
 *
 */

@isTest
public class Digital_ResetBestPropConfigQuote_Test {

    @testSetup
    static void createData(){
    
        DCTestData.createData();
        Test.startTest();
        DCTestData.createQuote();  
        Test.stopTest();
        DCTestData.createOnline(DCTestData.bQuoteID,DCTestData.accountId);
        
    }
    public static testmethod void resetQuoteTest(){
        
        Apttus_Proposal__Proposal__c prop = [SELECT id FROM Apttus_Proposal__Proposal__c WHERE Digital_Quote_Type__c = 'Best Value' LIMIT 1];
        List<Id> bestValQuoteIds = new List<Id>{prop.id};

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new DCConfiguratorMockHttpLoginTest());

        Digital_ResetBestProposalConfigQuote.resetQuote(bestValQuoteIds);
        System.assert(bestValQuoteIds != null,'No best value id found');
        Test.stopTest();
          
    }  
    
     
}