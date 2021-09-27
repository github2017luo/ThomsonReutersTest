/**
 * Helper collection class for managing advanced search filter block items
 *
 * @author  John De Santiago
 * @version 2012-07-30
 */

/**
 * CHANGE HISTORY
 * =============================================================================
 * Date         Name                    Description
 * 2012-07-30   John De Santiago        Created                                                     
 * 2012-08-21  Glenda Ninan 			Use PaginatedSelectList instead of List<SelectOption> 
 * 2012-09-04  Glenda Ninan 			Defect 3197: Modify the list items to each have a unique key value
   2012-09-06   Glenda Ninan            Fix Too Many Script Statements : 2000001 
 * =============================================================================
 */
public class AdvancedSearchFilterBlock {
	//Properties
	public string FilterLogic {get;set;}
	public string SelectedItem {get;set;}
	public List<AdvancedSearchFilterBlockItem> AdvancedSearchFilterBlockItems {get;set;}
	
	public List<AdvancedSearchFilterBlockItem> ActiveItems {
		get { return getActiveItems(); }
	}
	
	public PaginatedSelectList ActiveSelectOptions {
		get { return getSelectOptions(); }
	}

	public List<Id> ItemstoDelete {get;set;}
	
	//Constructors
	
	/**
	 * Default Constructor
	 */
	public AdvancedSearchFilterBlock() {
		AdvancedSearchFilterBlockItems = new List<AdvancedSearchFilterBlockItem>();
		ItemstoDelete = new List<Id> ();
	}
	
	//Public Methods
	
	/**
	 * Flags the selected AdvancedSearchFilterBlockItem as deleted
	 */
	public void removeItem() {
		Map<String,List<Integer>> MapSelectedItem = New Map<String,List<Integer>>();
		//Map<String,AdvancedSearchFilterBlockItem> MapBlockItem = New Map<String,AdvancedSearchFilterBlockItem>();
		//AdvancedSearchFilterBlockItem BlockItem = New AdvancedSearchFilterBlockItem (); 
		Integer DeletedCount = 0;
		Integer SelectedKeyItem = 0;
		String SelectedKey = '';
		string sCurrentIndex = '';
		
		//Build List of Selected Items		
		if (AppUtil.isEmpty(SelectedItem) == false) {
			if (SelectedItem.Substring(0,1) == '[') {
				SelectedItem = SelectedItem.Substring(1,SelectedItem.indexOf(']'));
			}
			if (AppUtil.isEmpty(SelectedItem) == false) {
				List<Integer> ListSelectedKeyItem = New List<Integer>();
				system.debug('SelectedItem '+SelectedItem);
				for (String SelectedItemStr : SelectedItem.split(',')) {
					system.debug('SelectedItemStr '+SelectedItemStr);
					system.debug('SelectedItemStr.indexOf() '+SelectedItemStr.indexOf('.'));
					if (SelectedItemStr.indexOf('.') != -1) {
						SelectedKey = SelectedItemStr.substring(0,SelectedItemStr.indexOf('.'));  
						SelectedKey = SelectedKey.Trim();  
						SelectedKeyItem = Integer.ValueOf(SelectedItemStr.substring(SelectedItemStr.indexOf('.')+1));
					}
					else {
						SelectedKey = SelectedItemStr;
						SelectedKeyItem = -1;
					}  
					if (MapSelectedItem.ContainsKey(SelectedKey)) {
						ListSelectedKeyItem.Add(SelectedKeyItem);
					}
					else {
						ListSelectedKeyItem = New List<Integer>();
						MapSelectedItem.put(SelectedKey,ListSelectedKeyItem);
						if (SelectedKeyItem >= 0) {
							ListSelectedKeyItem.Add(SelectedKeyItem);
						}
					}
					system.debug('MapSelectedItem '+MapSelectedItem);
				}
			}
/*			for (String sKey : MapSelectedItem.KeySet()) {
				AdvancedSearchFilterBlockItem oItem = AdvancedSearchFilterBlockItems.get(integer.ValueOf(sKey)-1);
				sCurrentIndex = oItem.AdvancedSearchDetail.Index__c == null ? '' : string.valueOf(oItem.AdvancedSearchDetail.Index__c);
				if (sCurrentIndex == sKey) {
					MapBlockItem.put(sKey,oItem);
				}
			}*/
			for (String sKey : MapSelectedItem.KeySet()) {
				//BlockItem = MapBlockItem.get(sKey);
				AdvancedSearchFilterBlockItem BlockItem = AdvancedSearchFilterBlockItems.get(integer.ValueOf(sKey)-1);
				DeletedCount = 0;
				if (MapSelectedItem.get(sKey).Size() == 0) {
					system.debug('AdvancedSearchFilterBlockItems '+AdvancedSearchFilterBlockItems);
					if (!AppUtil.IsEmpty(AdvancedSearchFilterBlockItems.get(integer.ValueOf(sKey)-1).AdvancedSearchDetail.Id)) {
						ItemstoDelete.add(AdvancedSearchFilterBlockItems.get(integer.ValueOf(sKey)-1).AdvancedSearchDetail.Id);
					}
					AdvancedSearchFilterBlockItems.Remove(integer.ValueOf(sKey)-1);
				}
				else {
					for (Integer SelectedKeyInt : MapSelectedItem.get(sKey)) {
						BlockItem.SelectedValues.Remove(SelectedKeyInt - DeletedCount);
						DeletedCount ++;
						if(BlockItem.SelectedValues.Size()==0) {
							BlockItem.IsDeleted = true;
							if (!AppUtil.IsEmpty(BlockItem.AdvancedSearchDetail.Id)) {
								ItemstoDelete.add(BlockItem.AdvancedSearchDetail.Id);
							}
							AdvancedSearchFilterBlockItems.Remove(integer.ValueOf(sKey)-1);
						}
					}
				}
			}
		}
	}
	
	/**
	 * Flags all AdvancedSearchFilterBlockItem objects for deletion
	 */
	public void removeAll() {
		for (AdvancedSearchFilterBlockItem oItem : AdvancedSearchFilterBlockItems) {
			if (!AppUtil.IsEmpty(oItem.AdvancedSearchDetail.Id)) {
				ItemstoDelete.add(oItem.AdvancedSearchDetail.Id);
			}
		}
		AdvancedSearchFilterBlockItems.Clear();
	}
	
	//Private Methods
	
	/**
	 * Retrieves a list of SelectOption objects based on the current
	 * list of active AdvancedSearchFilterBlockItem objects
	 *
	 * @return a list of SelectOption objects
	 */
	private PaginatedSelectList getSelectOptions() {
		PaginatedSelectList listSelectOptions = new PaginatedSelectList();
		Map<string, AdvancedSearchFilterBlockItem> MapList = New Map<string, AdvancedSearchFilterBlockItem> ();
		string sJoinCondition = '';

		system.debug('getSelectOptions');
		for (AdvancedSearchFilterBlockItem oItem : ActiveItems) {
			string sItemKey = string.valueOf(AppUtil.isNull(oItem.AdvancedSearchDetail.Index__c, 1));
			
			string sItemText = String.format('{0}. {1}{2} {3}', new List<string>{
				  sItemKey
				, sJoinCondition
				, AppUtil.isNull(oItem.FieldName, '?')
				, AppUtil.isNull(oItem.Operator, '?')
			});
			
			if (oItem.IsBetween) {
				sItemText += String.format(' {0} AND {1}', new List<string>{ 
					  AppUtil.isNull(oItem.Value1, '?')
					, AppUtil.isNull(oItem.Value2, '?')
				});
				
				listSelectOptions.add(new SelectOption(sItemKey, sItemText));
			}
			else {
				if (oItem.IsTypeList == false) {
					//Add First Value
					sItemText += ' ' + AppUtil.isNull(oItem.Value1, '?');				
					listSelectOptions.add(new SelectOption(sItemKey, sItemText));
				}
				else {
					
					string sSubItemKey = '';
					Integer LoopSize = oItem.SelectedValues.size();
					Integer LoopSize2 = 0;
					If (LoopSize > 4500) {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,Label.reduce_the_number_of_criteria_values1 +LoopSize+ Label.reduce_the_number_of_criteria_values2));	
						LoopSize2 = LoopSize - 4500; 
						LoopSize = 4500;
					}  
					//Add List Values
					for (integer i=0; i< LoopSize; i++) {
						sSubItemKey = sItemKey + '.' + string.valueOf(i);
						string sSubItemBullet = (i == 0) ? sItemKey + '.' : '';
						string sSubItemOperator = (i > 0) ? '-> OR ' : sJoinCondition;
						
						string sSubItemText = String.format('{0} {1} {2} {3} {4}', new List<string>{
							  sSubItemBullet
							, sSubItemOperator
							, AppUtil.isNull(oItem.FieldName, '?')
							, AppUtil.isNull(oItem.Operator, '?')
							, AppUtil.isNull(oItem.SelectedValues[i], '?')
						});
						
						listSelectOptions.add(new SelectOption(sSubItemKey, sSubItemText));
					}
/*					for (integer i=4500; i< 4500+LoopSize2; i++) {
						sSubItemKey = sItemKey + '.' + string.valueOf(i);
						string sSubItemBullet = (i == 0) ? sItemKey + '.' : '';
						string sSubItemOperator = (i > 0) ? 'OR ' : sJoinCondition;
						
						string sSubItemText = String.format('{0} {1} {2} {3} {4}', new List<string>{
							  sSubItemBullet
							, sSubItemOperator
							, AppUtil.isNull(oItem.FieldName, '?')
							, AppUtil.isNull(oItem.Operator, '?')
							, AppUtil.isNull(oItem.SelectedValues[i], '?')
						});
						
						listSelectOptions.add(new SelectOption(sSubItemKey, sSubItemText));
					}*/

				}
			}
			
			sJoinCondition = 'AND '; //Every entry after this should display AND
		}
		
		return listSelectOptions;
	}
	
	/**
	 * Retrieves a list of active AdvancedSearchFilterBlockItems by ignoring any item
	 * that is flagged as deleted
	 *
	 * @return	a list of AdvancedSearchFilterBlockItem objects
	 */
	private List<AdvancedSearchFilterBlockItem> getActiveItems() {
		List<AdvancedSearchFilterBlockItem> listActiveItems = new List<AdvancedSearchFilterBlockItem>();
		integer iIndex = 0;
		
		system.debug('getActiveItems');
		for (AdvancedSearchFilterBlockItem oItem : AdvancedSearchFilterBlockItems) {
			if (oItem.IsDeleted == false) {
				oItem.AdvancedSearchDetail.Index__c = ++iIndex;
				listActiveItems.add(oItem);
			}
			else {
				oItem.AdvancedSearchDetail.Index__c = 0;
			}
		}
		
		return listActiveItems;
	}
}