/**
 * Validates the functionality provided by the AdvancedSearchFilterBlock class
 *
 * @author	John De Santiago
 * @version	2012-08-03
 */
@IsTest
private class PaginatedSelectList_Test {
	
	/**
	 * Validates that items can be added and removed
	 */
	private static testMethod void testAddItems() {
		//Setup Test
		PaginatedSelectList listPage = new PaginatedSelectList();
		SelectOption oOptions ;
		List<SelectOption> listOptions = New List<SelectOption>();
		
		//Execute Test
		Test.startTest();
	
		for (integer i=0; i<10000; i++) {
			oOptions = new SelectOption(string.valueof(i), string.valueof(i+1000));
			listPage.add(oOptions);
		}

		for (integer i=0; i<1000; i++) {
			oOptions = new SelectOption(string.valueof(i+10000), string.valueof(i+2000));
			listPage.add(oOptions);
		}

 		System.assertEquals(11000, listPage.getSize());
 		System.assertEquals('1', listPage.get(1).getValue());

		listOptions = listPage.get0();
 		System.assertEquals('2', listOptions.get(2).getValue());
		listOptions = listPage.get1();
 		System.assertEquals('1002', listOptions.get(2).getValue());

		
		Test.stopTest();
    }

	private static testMethod void testRemoveItems() {
		//Setup Test
		PaginatedSelectList listPage = new PaginatedSelectList();
		SelectOption listOptions ;
		
		//Execute Test
		Test.startTest();
	
		for (integer i=0; i<1000; i++) {
			listOptions = new SelectOption(string.valueof(i), string.valueof(i+2000));
			listPage.add(listOptions);
		}

		for (integer i=0; i<100; i++) {
			listPage.remove(i);
		}

 		System.assertEquals(900, listPage.getSize());
		
		listPage.clear();
 		System.assertEquals(0, listPage.getSize());
		
		Test.stopTest();
    }

	private static testMethod void testGetItems() {
		//Setup Test
		PaginatedSelectList listPage = new PaginatedSelectList();
		SelectOption oOptions ;
		List<SelectOption> listOptions = New List<SelectOption>();
		
		//Execute Test
		Test.startTest();
	
		for (integer i=0; i<25000; i++) {
			oOptions = new SelectOption(string.valueof(i), string.valueof(i+1000));
			listPage.add(oOptions);
		}

		listOptions = listPage.get0();
 		System.assertEquals('2', listOptions.get(2).getValue());
		listOptions = listPage.get1();
 		System.assertEquals('1002', listOptions.get(2).getValue());
		listOptions = listPage.get2();
 		System.assertEquals('2002', listOptions.get(2).getValue());
		listOptions = listPage.get3();
 		System.assertEquals('3002', listOptions.get(2).getValue());
		listOptions = listPage.get4();
 		System.assertEquals('4002', listOptions.get(2).getValue());
		listOptions = listPage.get5();
 		System.assertEquals('5002', listOptions.get(2).getValue());
		listOptions = listPage.get6();
 		System.assertEquals('6002', listOptions.get(2).getValue());
		listOptions = listPage.get7();
 		System.assertEquals('7002', listOptions.get(2).getValue());
		listOptions = listPage.get8();
 		System.assertEquals('8002', listOptions.get(2).getValue());
		listOptions = listPage.get9();
 		System.assertEquals('9002', listOptions.get(2).getValue());
		listOptions = listPage.get10();
 		System.assertEquals('10002', listOptions.get(2).getValue());
		listOptions = listPage.get11();
 		System.assertEquals('11002', listOptions.get(2).getValue());
		listOptions = listPage.get12();
 		System.assertEquals('12002', listOptions.get(2).getValue());
		listOptions = listPage.get13();
 		System.assertEquals('13002', listOptions.get(2).getValue());
		listOptions = listPage.get14();
 		System.assertEquals('14002', listOptions.get(2).getValue());
		listOptions = listPage.get15();
 		System.assertEquals('15002', listOptions.get(2).getValue());
		listOptions = listPage.get16();
 		System.assertEquals('16002', listOptions.get(2).getValue());
		listOptions = listPage.get17();
 		System.assertEquals('17002', listOptions.get(2).getValue());
		listOptions = listPage.get18();
 		System.assertEquals('18002', listOptions.get(2).getValue());
		listOptions = listPage.get19();
 		System.assertEquals('19002', listOptions.get(2).getValue());
		listOptions = listPage.get20();
 		System.assertEquals('20002', listOptions.get(2).getValue());
		listOptions = listPage.get21();
 		System.assertEquals('21002', listOptions.get(2).getValue());
		listOptions = listPage.get22();
 		System.assertEquals('22002', listOptions.get(2).getValue());
		listOptions = listPage.get23();
 		System.assertEquals('23002', listOptions.get(2).getValue());
		listOptions = listPage.get24();
 		System.assertEquals('24002', listOptions.get(2).getValue());

		
		Test.stopTest();
    }
}