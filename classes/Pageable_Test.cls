/**
 * Validates the functionality provided by the KeyValuePair class.
 *
 * @author	John De Santiago - Thomson Reuters Code Share
 * @version	2012-10-22
 */

/**
 * CHANGE HISTORY
 * =============================================================================
 * Date			Name					Description
 * 2012-10-22   John De Santiago        Created
 * =============================================================================
 */
@IsTest
private class Pageable_Test {
	
	private static testMethod void testDefaultPageableBehavior() {
		Test.startTest();
		
		Pageable oPageable = new Pageable();
		oPageable.PageSize = 10;
		
		System.assertEquals(0, oPageable.RecordCount);
		System.assertEquals(1, oPageable.PageCount);
		System.assertEquals(1, oPageable.PageNumber);
		System.assertEquals(0, oPageable.Offset);
		System.assertEquals(0, oPageable.LNumber);
		System.assertEquals(0, oPageable.UNumber);
		System.assertEquals(false, oPageable.AllowMoveNext);
		System.assertEquals(false, oPageable.AllowMovePrev);
		
		Test.stopTest();
	}
	
	private static testMethod void testPagingAccounts() {
		//Setup Test
		List<PageItem> listItems = new List<PageItem>();
		
		for (integer i=0; i < 32; i++) {
			PageItem oItem = new PageItem();
			oItem.Name = 'Test' + string.valueOf(i);
			
			listItems.add(oItem);
		}
		
		Test.startTest();
		
		PageItems oPageable = new PageItems();
		oPageable.Items = listItems;
		oPageable.PageSize = 10;
		
		System.assertEquals(32, oPageable.RecordCount);
		System.assertEquals(4, oPageable.PageCount);
		System.assertEquals(1, oPageable.PageNumber);
		System.assertEquals(0, oPageable.Offset);
		System.assertEquals(1, oPageable.LNumber);
		System.assertEquals(10, oPageable.UNumber);
		System.assertEquals(true, oPageable.AllowMoveNext);
		System.assertEquals(false, oPageable.AllowMovePrev);
		
		//Move Next
		oPageable.moveNext();
		System.assertEquals(2, oPageable.PageNumber);
		System.assertEquals(10, oPageable.Offset);
		System.assertEquals(true, oPageable.AllowMoveNext);
		System.assertEquals(true, oPageable.AllowMovePrev);
		
		//Move Last
		oPageable.moveLast();
		System.assertEquals(4, oPageable.PageNumber);
		System.assertEquals(30, oPageable.Offset);
		System.assertEquals(false, oPageable.AllowMoveNext);
		System.assertEquals(true, oPageable.AllowMovePrev);
		
		//Move Prev
		oPageable.movePrev();
		System.assertEquals(3, oPageable.PageNumber);
		System.assertEquals(20, oPageable.Offset);
		System.assertEquals(true, oPageable.AllowMoveNext);
		System.assertEquals(true, oPageable.AllowMovePrev);
		
		//Move First
		oPageable.moveFirst();
		System.assertEquals(1, oPageable.PageNumber);
		System.assertEquals(0, oPageable.Offset);
		System.assertEquals(true, oPageable.AllowMoveNext);
		System.assertEquals(false, oPageable.AllowMovePrev);
		
		//Move Next Invalid Page
		oPageable.PageNumber = 20;
		oPageable.moveNext();
		System.assertEquals(oPageable.PageCount, oPageable.PageNumber);
		
		//Move Next Invalid Page
		oPageable.PageNumber = 0;
		oPageable.movePrev();
		System.assertEquals(1, oPageable.PageNumber);
		
		Test.stopTest();
	}
	
	//Internal Classes
	public class PageItem {
		public string Name {get;set;}
	}
	
	public class PageItems extends Pageable {
		public List<PageItem> Items {get;set;}
		
		public override integer getRecordCount() {
			return Items == null ? 0 : Items.size();
		}
	}
}