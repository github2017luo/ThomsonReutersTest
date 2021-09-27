@istest
Public with sharing class AccountOppRelatedListController_Test{
  public static testMethod void testOpportunityRelatedListController(){
      Account testAcc1 = UnitTest.getAccountInstance();
      
      List<Opportunity> opp = new List<Opportunity>();
      
      for (integer i=0; i < 12; i++) {
      	opp.add(UnitTest.getOpportunityInstance(testAcc1.id));
      }
      
      Test.setCurrentPageReference(Page.AccountDetail);
      AccountOpportunityRelatedListController testcontroller=new AccountOpportunityRelatedListController();
        testcontroller.recordtypename = 'Pre-Pipeline Opportunity';
           testcontroller.showmore();
           testcontroller.getopportunities();
           testcontroller.goToList();
        testcontroller.recordtypename = 'Pipeline Opportunity';
           testcontroller.showmore();
           testcontroller.getopportunities();
        testcontroller.recordtypename = 'Renewal Opportunities';
           testcontroller.showmore();
           testcontroller.getopportunities();
  }

}