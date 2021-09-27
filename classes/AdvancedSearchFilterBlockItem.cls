/**
 * Helper class for working with advanced search filter block items
 *
 * @author  John De Santiago
 * @version 2012-07-30
 */

/**
 * CHANGE HISTORY
 * =============================================================================
 * Date         Name                    Description
 * 2012-07-30   John De Santiago        Created                                                     
 * 2012-08-15   Glenda Ninan            Fixed sorting problem                                                     
 * 2012-08-21   Glenda Ninan 			Use PaginatedSelectList instead of List<SelectOption> 
 * 2012-08-21   Glenda Ninan            Added new field ListValue for saving LOV (as long text) 
 * 2012-09-06   Glenda Ninan            Fix Too Many Script Statements : 2000001 
 * =============================================================================
 */
public class AdvancedSearchFilterBlockItem {
	//Constants
	public static final string SearchDateFormat = 'MM-dd-yyyy';
	private List<string> listSelectedValues;
	
	//Properties
	public boolean IsDeleted {get;set;}
	public Map<integer, string> FieldValuesMap {get;set;}
	public List<string> SelectedListOptions {get;set;}
	public AdvancedSearchDetail__c AdvancedSearchDetail {get;set;}
	
	public string FieldName {
		get { return AdvancedSearchDetail.Name; }
		set { AdvancedSearchDetail.Name = value; }
	}
	
	public string Operator {
		get { return AdvancedSearchDetail.Operator__c; }
		set { AdvancedSearchDetail.Operator__c = value; }
	}
	
	public PaginatedSelectList FieldValueOptions {
		get { return getFieldValueSelectOptions(); }
	}

	public string Value1 {
		get { return getSearchValue1(); }
	}
	
	public string Value2 {
		get { return getSearchValue2(); }
	}
	
	public List<string> SelectedValues {
		get { return getSelectedValues(); }
	}
	
	public boolean IsTypeText {
		get { return (AdvancedSearchDetail.DataType__c == 'Text'); }
	}
	
	public boolean IsTypeDate {
		get { return (AdvancedSearchDetail.DataType__c == 'Date'); }
	}
	
	public boolean IsTypeNumeric {
		get { return (AdvancedSearchDetail.DataType__c == 'Numeric'); }
	}
	
	public boolean IsTypeList {
		get { return (AdvancedSearchDetail.DataType__c == 'List'); }
	}
	
	public boolean IsTypeFlag {
		get { return (AdvancedSearchDetail.DataType__c == 'Flag'); }
	}
	
	public boolean IsBetween { 
		get { return (AdvancedSearchDetail.Operator__c == 'Between'); } 
	}
	
	public boolean IsLessThanGreaterThan { 
		get { return (AdvancedSearchDetail.Operator__c == 'LessThan' || AdvancedSearchDetail.Operator__c == 'GreaterThan'); } 
	}
	
	public boolean IsBetweenAllowed {
		get { return (IsTypeNumeric || IsTypeDate); }
	}
	
	public boolean IsLessThanGreaterThanAllowed {
		get { return (IsTypeNumeric || IsTypeDate); }
	}
	
	//Constructors 
	
	/**
	 * Default Constructor
	 */
	public AdvancedSearchFilterBlockItem() {
		IsDeleted = false;
		FieldValuesMap = new Map<integer, string>();
		SelectedListOptions = new List<string>();
		AdvancedSearchDetail = new AdvancedSearchDetail__c();
	}
	
	/**
	 * AdvancedSearchDetail__c Constructor
	 *
	 * @param	oAdvancedSearchDetail	an existing AdvancedSearchDetail__c object
	 */
	public AdvancedSearchFilterBlockItem(AdvancedSearchDetail__c oAdvancedSearchDetail) {
		this();
		AdvancedSearchDetail = oAdvancedSearchDetail;
		
		string strValues;
		if (IsTypeList && AppUtil.isEmpty(oAdvancedSearchDetail.ListValue__c) == false) {
			if (AppUtil.isEmpty(oAdvancedSearchDetail.ListValue2__c) == false) {
				strValues = oAdvancedSearchDetail.ListValue__c + oAdvancedSearchDetail.ListValue2__c;
			}
			else {
				strValues = oAdvancedSearchDetail.ListValue__c ;
			}
			List<string> listValues = strValues.split(';');
			integer iIndex = 0;

			for (string sValue : listValues) {
				FieldValuesMap.put(iIndex, sValue);
				SelectedListOptions.add(string.valueOf(iIndex));
				
				iIndex++;
			}
		}
	}
	
	/**
	 * Validates required information is set for the current filter block
	 *
	 * @return	a ValidationResult object
	 */
	public ValidationResult validate() {
		ValidationResult oValidationResult = new ValidationResult();
		oValidationResult.IsValid = true;
		
		String sFieldName = AdvancedSearchDetail.Name;
		
		boolean bIsMissingRequiredData = false;
		bIsMissingRequiredData |= AppUtil.isEmpty(sFieldName);
		bIsMissingRequiredData |= AppUtil.isEmpty(AdvancedSearchDetail.Operator__c);
		
		if (IsBetween) {
			bIsMissingRequiredData |= (AppUtil.isEmpty(Value1) || AppUtil.isEmpty(Value2));
		}
		else {
			bIsMissingRequiredData |= AppUtil.isEmpty(Value1);
		}
		
		if (bIsMissingRequiredData) {
			oValidationResult.IsValid = false;
			oValidationResult.Failures.add('You must specify a field name, operator, and value.');
		}

		Integer ListSize = SelectedValues.size();
		If (ListSize > 4500) {
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,Label.reduce_the_number_of_criteria_values1 +ListSize+ Label.reduce_the_number_of_criteria_values2));	
		}
		  
		return oValidationResult;
	}

	/**
	 * Resets the selected values
	 */
	public void resetSelectedValues() {
		listSelectedValues = null;
	}
	
	//Private Methods
	
	/**
	 * Identifies which value to return based on the current field type
	 *
	 * @return	a string
	 */
	private string getSearchValue1() {
		string sValue = '';
		
		if (IsTypeDate) {	
			sValue = AppUtil.formatDate(AdvancedSearchDetail.DateValue1__c, SearchDateFormat, '');
		}
		else if (IsTypeNumeric) {
			sValue = string.valueOf(AdvancedSearchDetail.NumberValue1__c);
		}
		else if (IsTypeList) {
			sValue = '';
			
			for (String sItem : getSelectedValues()) {
				if (sValue.length() > 0) sValue += ';';
				sValue += sItem;
			}
		}
		else {
			sValue = AdvancedSearchDetail.Value__c;
		}
		
		return sValue;
	}
	
	/**
	 * Identifies which value to return based on the current field type
	 *
	 * @return	a string
	 */
	private string getSearchValue2() {
		string sValue = '';
		
		if (IsTypeDate) {	
			sValue = AppUtil.formatDate(AdvancedSearchDetail.DateValue2__c, SearchDateFormat, '');
		}
		else if (IsTypeNumeric) {
			sValue = string.valueOf(AdvancedSearchDetail.NumberValue2__c);
		}
		
		return sValue;
	}
	
	/**
	 * Converts the selected list of key values to a list of 
	 * string values based on the data contained in the FieldValuesMap
	 *
	 * @return	a list of strings
	 */
	private List<string> getSelectedValues() {
		if (listSelectedValues == null) {
			listSelectedValues = new List<string>();
	
			for (string sIndex : SelectedListOptions) {
				integer iIndex = integer.valueOf(sIndex);
				string sValue = FieldValuesMap.get(iIndex);
				
				if (sValue != null) {
					listSelectedValues.add(sValue);
				}
			}
		}
	
		return listSelectedValues;
	}
	
	/**
	 * Converts the FieldValuesMap to a list of SelectOption objects
	 *
	 * @return	a list of SelectOption objects
	 */
	private PaginatedSelectList getFieldValueSelectOptions() {
		PaginatedSelectList listSelectOptions = new PaginatedSelectList();
		
		for (integer iIndex = 0; iIndex < FieldValuesMap.size(); iIndex++) {
			listSelectOptions.add(new SelectOption(string.valueOf(iIndex), FieldValuesMap.get(iIndex)));
		}
		
		return listSelectOptions;
	}
}