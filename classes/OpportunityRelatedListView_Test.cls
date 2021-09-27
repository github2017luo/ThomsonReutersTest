/*
===============================================================================
TEST CLASS NAME: OpportunityRelatedListView_Test
===============================================================================
PURPOSE: Contains all the testMethods and Validates the functionality provided by the OpportunityRelatedListView class.

CHANGE HISTORY
===============================================================================
DATE             NAME            DESC
2012-05-16       Nandita        Created
31/03/2017       Gunaseelan K   Optimized the code as per JIRA STORY: PS0-1
===============================================================================
*/
@isTest (seealldata=false)  // As part of  s2e Optimisation project making seeAllData as false [Rajashree]

public class OpportunityRelatedListView_Test{
   public static testmethod void relatedSalesteammethod() {
      UnitTest.createTestData();   //  As part of  s2e Optimisation project adding test data [Rajashree]   
      Account testAcc = UnitTest.getAccountInstance();
       insert testAcc;
      Opportunity TestOpp = UnitTest.getOpportunityInstance(testAcc.Id);
       insert TestOpp;
       
      Profile p = [SELECT Id FROM profile WHERE name='System Administrator'];   
      User u1 = new User(alias = 'newUser', email='user@mydomain.com', 
            emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
            localesidkey='en_US', profileid = p.Id, employeenumber='0144020',
            timezonesidkey='America/Los_Angeles', username='user@mydomain.com');        
       insert u1;
       
       OpportunityTeamMember testoppteammember = new OpportunityTeamMember(OpportunityId=TestOpp.Id,UserId=u1.Id);
       insert testoppteammember;
       
        ApexPages.standardController sc = new ApexPages.standardController(TestOpp);
        
         Test.setCurrentPageReference(Page.OpportunityRelatedListView);  
         
         OpportunityRelatedListView  testcntrller = new OpportunityRelatedListView(sc); 
         testcntrller.getGoToListSalesTeam();
         testcntrller.strSortField ='id'; 
         testcntrller.doSort();
   }

}