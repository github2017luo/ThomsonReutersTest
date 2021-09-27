@isTest(seealldata=true)

public class OrdermationLink_Test{

    public static testMethod void testGetQuoteId()
    {
            Account testAcc1 = UnitTest.getAccountInstance();
            insert testAcc1;
            
            opportunity testOppty = UnitTest.getOpportunityInstance(testAcc1.id);
            insert testOppty;
            
            opportunity testOppty1 = UnitTest.getOpportunityInstance(testAcc1.id);
            insert testOppty1;
            
            Quote oQuote = new Quote(Name = 'test', OpportunityId = testOppty.Id);
            insert oQuote;

            System.assertEquals(oQuote.Name, 'test');
            System.assertEquals(testOppty1.SyncedQuoteID, null);
            
            Test.startTest();            
            OrdermationLink.getQuoteId(testOppty.id);
            OrdermationLink.getQuoteId(testOppty1.id);
            Test.stopTest();
            
             
             
             
            
    }


}