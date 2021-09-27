@isTest
private class USL_chargeCancellationController_Test  {

	private static testMethod void testmethod1() {
	USL_chargeCancellationController USLC =new USL_chargeCancellationController();   
	list<SelectOption> reasonCodelist;
    list<SelectOption> rootCauselist ;
    string reasonCode;
    string rootCause;
    USLC.getreasonCodelist();
    USLC.getrootCauselist();
	}

}