@istest(seeAllData=true)
public with sharing class OpportunityConvertController_test{
    public static testMethod void testController(){
        Account testAcc1 = UnitTest.getAccountInstance();
        insert testAcc1;
        opportunity testOpty = UnitTest.getOpportunityInstance(testAcc1.id);
        insert testOpty;
        ApexPages.standardController sc = new ApexPages.standardController(testOpty);
        Test.setCurrentPageReference(Page.OpportunityConvert);
        OpportunityConvertController cont = new OpportunityConvertController(sc);
        OpportunityConvertController.Convert(testOpty.Id);
      //  cont.onPageLoad();
    }
}