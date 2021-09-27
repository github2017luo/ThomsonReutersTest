@isTest(seeAllData=True)
private class ApprovalRecall_Test
{
static testMethod void testClass()
{
     
      ApprovalRecall app = new ApprovalRecall();
    
      Account account = UnitTest.getAccountInstance();
        account.Name = 'UTLeadAccount';
        insert account;
        
        opportunity opp = new opportunity();
        opp.Name= 'opp1';
        opp.AccountId = account.id;
        opp.StageName ='75%';
        opp.CloseDate =System.Today();
        insert opp;
        
         
           
        Quote qt= new Quote(Name='QuoteTest', OpportunityId =opp.Id);
        insert qt;  

        id quoteId=qt.id;
            
        Test.StartTest();
        List<ProcessInstance> processInstances = [select Id, Status from ProcessInstance where TargetObjectId = :quoteId];
        ApprovalRecall.recallApproval(quoteId);
        //ApprovalRecall.recallApproval(opp.id);
        Test.StopTest();
        
        
                
        }
      
}