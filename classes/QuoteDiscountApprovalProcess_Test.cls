@isTest(seeAllData = True)

public class QuoteDiscountApprovalProcess_Test{
    
    @isTest public static void test_GetThisQLIs(){
        
        Account oAccount = UnitTest.getAccountInstance();
        insert oAccount;
        
        Opportunity oOpportunity = UnitTest.getOpportunityInstance(oAccount.Id);
        insert oOpportunity;

        Pricebook2 oPricebook = [SELECT Id, Name FROM Pricebook2 where isActive = True limit 1] ;

        Quote oQuote = new Quote(Name = 'Test SKJ Quote', 
                                 OpportunityId = oOpportunity.Id, 
                                 Pricebook2Id = oPricebook.Id
                                // recordTypeId = KeyValueListStore__c.getInstance('LATAM_New_Quote').textValue__c
                                 ) ;
        
        insert oQuote;
        
        QuoteDiscountApprovalProcessController oQuoteDiscountApprovalProcessController = new QuoteDiscountApprovalProcessController();
        oQuoteDiscountApprovalProcessController.thisQuoteId = oQuote.Id;
        
        System.assert(oQuote != null);
        //System.assertEquals(KeyValueListStore__c.getInstance('LATAM_New_Quote').textValue__c, oQuote.recordTypeId);
        
            
        Test.startTest();
            
            oQuoteDiscountApprovalProcessController.getThisQLIs();
            
        Test.stopTest();
    }
}