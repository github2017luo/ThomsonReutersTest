public with Sharing class Ixos_Test{
    private static testMethod void testController(){
        Account testAcc1 = UnitTest.getAccountInstance();
        insert testAcc1;
        Test.setCurrentPageReference(Page.IXOS_Document);
        ApexPages.currentPage().getParameters().put('AccId',testAcc1.id);
        ApexPages.currentPage().getParameters().put('AcctSapId','1234');
        ApexPages.currentPage().getParameters().put('OrderNumber','1234');       
        ApexPages.standardController sc = new ApexPages.standardController(testAcc1);
        Ixos controller = new Ixos(sc);
        controller.displayIxosDocument();
        
    }
}