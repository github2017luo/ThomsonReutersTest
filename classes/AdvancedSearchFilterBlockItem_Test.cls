/**
 * Validates the functionality provided by the AdvancedSearchFilterBlockItem class
 *
 * @author	John De Santiago
 * @version	2012-08-03
 */
@IsTest
private class AdvancedSearchFilterBlockItem_Test {

	/**
	 * Validates the dynamic properties for the AdvancedSearchFilterBlockItem object
	 */
	private static testMethod void testBlockItemProperties() {
		//Setup Test
		AdvancedSearch__c oAdvancedSearch = UnitTest.getAdvancedSearchInstance();
		insert oAdvancedSearch;
		
		AdvancedSearchDetail__c oAdvancedSearchDetail = UnitTest.getAdvancedSearchDetailInstance(oAdvancedSearch.Id);
		oAdvancedSearchDetail.DataType__c = 'List';
		oAdvancedSearchDetail.Value__c = 'Test1;Test2;Test3';
		insert oAdvancedSearchDetail;
		
		//Execute Test
		Test.startTest();
		
		AdvancedSearchFilterBlockItem oAdvancedSearchFilterBlockItem = new AdvancedSearchFilterBlockItem(oAdvancedSearchDetail);
		oAdvancedSearchFilterBlockItem.resetSelectedValues();
		
		string sField = oAdvancedSearchFilterBlockItem.FieldName;
		oAdvancedSearchFilterBlockItem.FieldName = 'Test';
		
		string sOperator = oAdvancedSearchFilterBlockItem.Operator;
		oAdvancedSearchFilterBlockItem.Operator = 'Between';
		oAdvancedSearchFilterBlockItem.Operator = 'Equal';
		
		string sValue1 = oAdvancedSearchFilterBlockItem.Value1;
		string sValue2 = oAdvancedSearchFilterBlockItem.Value2;
		
		PaginatedSelectList listSelectOptions = oAdvancedSearchFilterBlockItem.FieldValueOptions;
		List<string> listSelectedValues = oAdvancedSearchFilterBlockItem.SelectedValues;
		
		boolean bIsBetween = oAdvancedSearchFilterBlockItem.IsBetween;
		boolean bIsBetweenAllowed = oAdvancedSearchFilterBlockItem.IsBetweenAllowed;
		boolean bIsLTGT = oAdvancedSearchFilterBlockItem.IsLessThanGreaterThan;
		boolean bIsLTGTAllowed = oAdvancedSearchFilterBlockItem.IsLessThanGreaterThanAllowed;
		
		boolean bIsTypeDate = oAdvancedSearchFilterBlockItem.IsTypeDate;
		boolean bIsTypeFlag = oAdvancedSearchFilterBlockItem.IsTypeFlag;
		boolean bIsTypeList = oAdvancedSearchFilterBlockItem.IsTypeList;
		boolean bIsTypeNumeric = oAdvancedSearchFilterBlockItem.IsTypeNumeric;
		boolean bIsTypeText = oAdvancedSearchFilterBlockItem.IsTypeText;
		
		Test.stopTest();
	}
	
	/**
	 * Validates the a value is returned based on the current
	 * data type and operator
	 */
	private static testMethod void validateValueMethods() {
		//Setup Test
		AdvancedSearch__c oAdvancedSearch = UnitTest.getAdvancedSearchInstance();
		insert oAdvancedSearch;
		
		AdvancedSearchDetail__c oAdvancedSearchDetail = UnitTest.getAdvancedSearchDetailInstance(oAdvancedSearch.Id);
		oAdvancedSearchDetail.Name = 'Name';
		oAdvancedSearchDetail.Operator__c = 'Equal';
		oAdvancedSearchDetail.Value__c = 'Test';
		insert oAdvancedSearchDetail;
		
		AdvancedSearchFilterBlockItem oAdvancedSearchFilterBlockItem = new AdvancedSearchFilterBlockItem(oAdvancedSearchDetail);
		
		//Execute Test
		Test.startTest();
		
		string sText = oAdvancedSearchFilterBlockItem.Value1;
		System.assertEquals('Test', sText);
		
		oAdvancedSearchFilterBlockItem.Operator = 'Between';
		oAdvancedSearchFilterBlockItem.AdvancedSearchDetail.NumberValue1__c = 1;
		oAdvancedSearchFilterBlockItem.AdvancedSearchDetail.NumberValue2__c = 10;
		oAdvancedSearchFilterBlockItem.AdvancedSearchDetail.DataType__c = 'Numeric';
		
		string sBetween1 = oAdvancedSearchFilterBlockItem.Value1;
		System.assertEquals('1', sBetween1);
		
		string sBetween2 = oAdvancedSearchFilterBlockItem.Value2;
		System.assertEquals('10', sBetween2);
		
		oAdvancedSearchFilterBlockItem.Operator = 'Between';
		oAdvancedSearchFilterBlockItem.AdvancedSearchDetail.DateValue1__c = System.today();
		oAdvancedSearchFilterBlockItem.AdvancedSearchDetail.DateValue2__c = System.today() + 4;
		oAdvancedSearchFilterBlockItem.AdvancedSearchDetail.DataType__c = 'Date';
		
		string sDate1 = oAdvancedSearchFilterBlockItem.Value1;
		System.assertEquals(AppUtil.formatDate(System.today(), 'MM-dd-yyyy', ''), sDate1);
		
		string sDate2 = oAdvancedSearchFilterBlockItem.Value2;
		System.assertEquals(AppUtil.formatDate(System.today() + 4, 'MM-dd-yyyy', ''), sDate2);
		
		oAdvancedSearchFilterBlockItem.Operator = 'Equal';
		oAdvancedSearchFilterBlockItem.AdvancedSearchDetail.DataType__c = 'List';
		oAdvancedSearchFilterBlockItem.FieldValuesMap.put(1, 'Test1');
		oAdvancedSearchFilterBlockItem.FieldValuesMap.put(2, 'Test2');
		oAdvancedSearchFilterBlockItem.FieldValuesMap.put(3, 'Test3');
		oAdvancedSearchFilterBlockItem.SelectedListOptions = new List<string>{'1','2'};
		
		string sListValue = oAdvancedSearchFilterBlockItem.Value1;
		System.assertEquals('Test1;Test2', sListValue);
		
		Test.stopTest();
	}
	
	/**
	 * Validates the validate method for the AdvancedSearchFilterBlockItem
	 */
	private static testMethod void testValidate() {
		//Setup Test
		AdvancedSearch__c oAdvancedSearch = UnitTest.getAdvancedSearchInstance();
		insert oAdvancedSearch;
		
		AdvancedSearchDetail__c oAdvancedSearchDetail = UnitTest.getAdvancedSearchDetailInstance(oAdvancedSearch.Id);
		oAdvancedSearchDetail.Name = 'Name';
		oAdvancedSearchDetail.Operator__c = 'Equal';
		oAdvancedSearchDetail.Value__c = 'Test';
		insert oAdvancedSearchDetail;
		
		AdvancedSearchFilterBlockItem oAdvancedSearchFilterBlockItem = new AdvancedSearchFilterBlockItem(oAdvancedSearchDetail);
		
		//Execute Test
		Test.startTest();
		
		ValidationResult oValidationResult1 = oAdvancedSearchFilterBlockItem.validate();
		System.assertEquals(true, oValidationResult1.IsValid);
		
		oAdvancedSearchDetail.Operator__c = 'Between';
		oAdvancedSearchDetail.DataType__c = 'Numeric';
		oAdvancedSearchDetail.NumberValue1__c = 1;
		oAdvancedSearchDetail.NumberValue2__c = 10;
		ValidationResult oValidationResult2 = oAdvancedSearchFilterBlockItem.validate();
		System.assertEquals(true, oValidationResult2.IsValid);
		
		oAdvancedSearchFilterBlockItem.FieldName = null;
		oAdvancedSearchFilterBlockItem.Operator = null;
		ValidationResult oValidationResult3 = oAdvancedSearchFilterBlockItem.validate();
		System.assertEquals(false, oValidationResult3.IsValid);
		
		Test.stopTest();
	}
}