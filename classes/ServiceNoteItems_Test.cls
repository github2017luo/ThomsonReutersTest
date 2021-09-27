/**
 * Test class for ServiceNoteItems - to support paging

 *
 * @author  Sripriya Kongot 
 * @version  2012-10-23
 */
 /**
 * CHANGE HISTORY
 * =============================================================================
 * Date         Name                    Description
 * 2012-10-23   Sripriya Kongot         Created
 * =============================================================================
 */
@IsTest
private  class ServiceNoteItems_Test {
	/**
	 * Verify for MoveNext & Moveprev 
	 */
	private static testMethod void testMoveNextAndPrev() {
		//Setup Test
		ServiceNoteItems oServiceNoteItems = new ServiceNoteItems();
		List<ServiceNotesServices.ServiceNoteItem> listServiceNoteItems = new List<ServiceNotesServices.ServiceNoteItem>();
		Integer size=0;
				
		for (integer i=0; i<100; i++) {			
			ServiceNotesServices.ServiceNoteItem oServiceNoteItem = new ServiceNotesServices.ServiceNoteItem ();
			oServiceNoteItem.ServiceNoteId = 'ServiceNoteId ' + string.valueOf(i);
			oServiceNoteItem.ServiceNoteId = 'DepartmentId ' + string.valueOf(i);
			oServiceNoteItems.listServiceNotesItems.add(oServiceNoteItem);
		}
		
		//Execute Test
		Test.startTest();
		
		oServiceNoteItems.initPaging();
		// Assert that the pagesize=50(default value)
		System.assertEquals(50, oServiceNoteItems.PageSize);
		
		System.assertEquals(true, oServiceNoteItems.AllowMoveNext);		
		oServiceNoteItems.moveNext();
		// Assert that the pageIndex=1
		System.assertEquals(1, oServiceNoteItems.PageIndex);
		System.assertEquals(true, oServiceNoteItems.AllowMovePrev);
		
		oServiceNoteItems.movePrev();
		// Assert that the pageIndex=0
		System.assertEquals(0, oServiceNoteItems.PageIndex);
	
		oServiceNoteItems.movePrev();
		listServiceNoteItems = oServiceNoteItems.CurrentPage;
		size = oServiceNoteItems.CurrentPageRecordSize;
		size = oServiceNoteItems.RecordStart;
		size = oServiceNoteItems.RecordEnd;
		Test.stopTest();
	}

}