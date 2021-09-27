/**
 * Validates the functionality provided by the AdvancedSearchAccounts class
 *
 * @author	John De Santiago
 * @version	2012-08-03
 */
@IsTest
private class AdvancedSearchAccounts_Test {

	/**
	 * Validates that changing the page size reinitalizes the pages
	 */
	private static testMethod void testChangePageSize() {
		//Setup Test
		AdvancedSearchAccounts oAdvancedSearchAccounts = new AdvancedSearchAccounts();
		
		for (integer i=0; i<50; i++) {
			AdvancedSearchAccount oAdvancedSearchAccount = new AdvancedSearchAccount();
			oAdvancedSearchAccount.Name = 'Name ' + string.valueOf(i);
			
			oAdvancedSearchAccounts.Accounts.add(oAdvancedSearchAccount);
		}
		    
		//Execute Test
		Test.startTest();
		
		oAdvancedSearchAccounts.changePageSize(10);
		List<AdvancedSearchAccount> listAccounts = oAdvancedSearchAccounts.CurrentPage;
		
		Test.stopTest();
		
		//Validate Test
		System.assertEquals(10, oAdvancedSearchAccounts.PageSize);
		System.assertEquals(5, oAdvancedSearchAccounts.Pages.Size());
	}
	
	/**
	 * Validates that paging can move forward and back
	 */
	private static testMethod void testMoveNextAndPrev() {
		//Setup Test
		AdvancedSearchAccounts oAdvancedSearchAccounts = new AdvancedSearchAccounts();
		oAdvancedSearchAccounts.changePageSize(10);
		
		for (integer i=0; i<50; i++) {
			AdvancedSearchAccount oAdvancedSearchAccount = new AdvancedSearchAccount();
			oAdvancedSearchAccount.Name = 'Name ' + string.valueOf(i);
			
			oAdvancedSearchAccounts.Accounts.add(oAdvancedSearchAccount);
		}
		
		//Execute Test
		Test.startTest();
		
		oAdvancedSearchAccounts.initPaging();
		System.assertEquals(true, oAdvancedSearchAccounts.AllowMoveNext);
		
		oAdvancedSearchAccounts.moveNext();
		System.assertEquals(1, oAdvancedSearchAccounts.PageIndex);
		System.assertEquals(true, oAdvancedSearchAccounts.AllowMovePrev);
		
		oAdvancedSearchAccounts.movePrev();
		System.assertEquals(0, oAdvancedSearchAccounts.PageIndex);
		
		Test.stopTest();
	}
	
	/**
	 * Validates data can be sorted based on a specified field name and
	 * sort direction.
	 */
	private static testMethod void testSortData() {
		//Setup Test
		AdvancedSearchAccounts oAdvancedSearchAccounts = new AdvancedSearchAccounts();
		
		for (integer i=0; i<10; i++) {
			AdvancedSearchAccount oAdvancedSearchAccount = new AdvancedSearchAccount();
			oAdvancedSearchAccount.Name = 'Name ' + string.valueOf(i);
			
			oAdvancedSearchAccounts.Accounts.add(oAdvancedSearchAccount);
		}
		
		//Execute Test
		Test.startTest();
		
		oAdvancedSearchAccounts.initPaging();
		oAdvancedSearchAccounts.SortField = 'Name';
		
		oAdvancedSearchAccounts.SortDirection = 'Asc';
		oAdvancedSearchAccounts.sortData();
		
		oAdvancedSearchAccounts.SortDirection = 'Desc';
		oAdvancedSearchAccounts.sortData();
		
		Test.stopTest();		
	}
}