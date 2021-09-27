@istest
Public class IncentiveContactLookup_test{
    public static testMethod void testController(){
        Account testAcc1 = UnitTest.getAccountInstance();
        insert testAcc1;
        ApexPages.currentPage().getParameters().put('accountid',testAcc1.id); 
        Test.setCurrentPageReference(Page.IncentiveContactLookup);
        IncentiveContactLookup controller =new IncentiveContactLookup();
        controller.getFormTag();
        controller.getTextBox();
        ApexPages.currentPage().getParameters().put('accountid','123');
        IncentiveContactLookup controller2 =new IncentiveContactLookup();
    }
}