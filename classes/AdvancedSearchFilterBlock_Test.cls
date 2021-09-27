/**
 * Validates the functionality provided by the AdvancedSearchFilterBlock class
 *
 * @author	John De Santiago
 * @version	2012-08-03
 */
@IsTest
private class AdvancedSearchFilterBlock_Test {
	
	/**
	 * Validates that items can be added and removed
	 */
	private static testMethod void testAddRemoveItems() {
		//Setup Test
		AdvancedSearchFilterBlock oAdvancedSearchFilterBlock = new AdvancedSearchFilterBlock();
		
		//Execute Test
		Test.startTest();
		
		//Add Items
		for (integer i=0; i<10; i++) {
			AdvancedSearchFilterBlockItem oAdvancedSearchFilterBlockItem = new AdvancedSearchFilterBlockItem();
			oAdvancedSearchFilterBlockItem.AdvancedSearchDetail.Name = 'Test';
			oAdvancedSearchFilterBlockItem.AdvancedSearchDetail.Operator__c = 'Equal';
			oAdvancedSearchFilterBlockItem.AdvancedSearchDetail.DataType__c = 'Text';
			
			if (i==1) {
				oAdvancedSearchFilterBlockItem.AdvancedSearchDetail.Operator__c = 'Between';
				oAdvancedSearchFilterBlockItem.AdvancedSearchDetail.DataType__c = 'Numeric';
			}
			else if (i==2) {
				oAdvancedSearchFilterBlockItem.AdvancedSearchDetail.DataType__c = 'List';
				oAdvancedSearchFilterBlockItem.FieldValuesMap.put(1, 'Test1');
				oAdvancedSearchFilterBlockItem.FieldValuesMap.put(2, 'Test2');
				oAdvancedSearchFilterBlockItem.FieldValuesMap.put(3, 'Test3');
				oAdvancedSearchFilterBlockItem.SelectedListOptions = new List<string>{'1','2'};
			}
			
			oAdvancedSearchFilterBlock.AdvancedSearchFilterBlockItems.add(oAdvancedSearchFilterBlockItem); 
		}
		System.assertEquals(11, oAdvancedSearchFilterBlock.ActiveSelectOptions.getSize());
		
		//Remove Item
		SelectOption oSelectOption = oAdvancedSearchFilterBlock.ActiveSelectOptions.get(0);
		oAdvancedSearchFilterBlock.SelectedItem = oSelectOption.getValue();
		oAdvancedSearchFilterBlock.removeItem();
		System.assertEquals(10, oAdvancedSearchFilterBlock.ActiveSelectOptions.getSize());
		
		//Remove All
		oAdvancedSearchFilterBlock.removeAll();
		System.assertEquals(0, oAdvancedSearchFilterBlock.ActiveSelectOptions.getSize());
		
		Test.stopTest();
			
	}
}