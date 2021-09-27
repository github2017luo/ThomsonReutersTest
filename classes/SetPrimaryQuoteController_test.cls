/*
======================================================================================================================
TEST CLASS NAME: SetPrimaryQuoteController_test
======================================================================================================================
PURPOSE: Validates the functionality provided by the SetPrimaryQuoteController class.

CHANGE HISTORY:
======================================================================================================================
DATE             NAME           DESC
31/03/2017       Gunaseelan K   Optimized the code as per JIRA STORY: PS0-1
======================================================================================================================
*/
@istest(SeeAllData=false) // As part of  s2e Optimisation project making seeAllData as false [Rajashree]
public class SetPrimaryQuoteController_test{
    public static testmethod void SetPrimaryQuoteController_test(){
      /*  Account oTestAccount = unitTest.getAccountInstance();
        insert oTestAccount;
        Opportunity oTestOpp = unitTest.getOpportunityInstance(oTestAccount.Id);
        insert oTestOpp;
        Quote oTestQuote = new Quote();
        oTestQuote.name = 'testQuote';
        oTestQuote.OpportunityId = oTestOpp.Id;
        insert oTestQuote;
        Quote oTestQuote2 = new Quote();
        oTestQuote2.name = 'testQuote2';
        oTestQuote2.OpportunityId = oTestOpp.Id;
        insert oTestQuote2; */
        UnitTest.createTestData();  //  As part of  s2e Optimisation project adding test data [Rajashree]  
        Account oTestAccount = UnitTest.getAccountInstance();
        insert oTestAccount ;

        Opportunity oTestOpp = UnitTest.getOpportunityInstance(oTestAccount .Id);
        oTestOpp .StageName = '50%';
        oTestOpp .Was_There_a_Competitor__c = 'No';
        oTestOpp .Competitor_Name__c = 'BloomBerg';
        oTestOpp .Reason__c = 'Test';
        oTestOpp .Name__c = 'Test';
        oTestOpp .Expiration_Date__c = System.today().adddays(1);
        oTestOpp .currencyIsoCode = 'USD';
        insert oTestOpp ;

        Quote oTestQuote = New Quote ();
        oTestQuote.OpportunityId = oTestOpp.id;
        oTestQuote.Name = 'Test Quote';
        oTestQuote.Primary_Quote__c = false;
        Insert oTestQuote ;
         
        Quote oTestQuote2 = New Quote ();
        oTestQuote2.OpportunityId = oTestOpp.id;
        oTestQuote2.Name = 'Test Quote';
        oTestQuote2.Primary_Quote__c = false;
        Insert oTestQuote2 ;
        
        test.startTest();
        ApexPages.StandardController otestController = new ApexPages.StandardController(oTestOpp);
        SetPrimaryQuoteController controller = new SetPrimaryQuoteController(otestController);
        pageReference pg = controller.setAsPrimary();
        for(SetPrimaryQuoteController.wrapQuotes oTestWrapQuote : controller.listWrapQuotes){
            oTestWrapQuote.bSelected = true;
        }
        
        pg = controller.setAsPrimary();
        
        SetPrimaryQuoteController.setAsPrimary(oTestQuote.Id,oTestOpp.Id);
        test.stopTest();
         
    }
}