/**
 * Validates the functionality provided by the AdvancedSearchWS class
 *
 * @author	John De Santiago
 * @version	2012-08-03
 */
@IsTest
private class AdvancedSearchWS_Test {

	/**
	 * Validates that current schema of the AdvancedSearchWS proxy class
	 */
	private static testMethod void testWebServiceSchema() {
		AdvancedSearchWS.GetSearchParms_element oGetSearchParms_element = new AdvancedSearchWS.GetSearchParms_element();
		AdvancedSearchWS.GetSearchParmsResponse_element oGetSearchParmsResponse_element = new AdvancedSearchWS.GetSearchParmsResponse_element();
		AdvancedSearchWS.GetSearchParmValues_element oGetSearchParmValues_element = new AdvancedSearchWS.GetSearchParmValues_element();
		AdvancedSearchWS.GetSearchParmValuesResponse_element oGetSearchParmValuesResponse_element = new AdvancedSearchWS.GetSearchParmValuesResponse_element();
		
		AdvancedSearchWS.ParmValue oParmValue = new AdvancedSearchWS.ParmValue();
		AdvancedSearchWS.ParmValueRecord oParmValueRecord = new AdvancedSearchWS.ParmValueRecord();
		
		AdvancedSearchWS.RunSearch_element oRunSearch_element = new AdvancedSearchWS.RunSearch_element();
		AdvancedSearchWS.RunSearchResponse_element oRunSearchResponse_element = new AdvancedSearchWS.RunSearchResponse_element();
		
		AdvancedSearchWS.SearchBlock oSearchBlock = new AdvancedSearchWS.SearchBlock();
		AdvancedSearchWS.SearchGrid oSearchGrid = new AdvancedSearchWS.SearchGrid();
		AdvancedSearchWS.SearchMember oSearchMember = new AdvancedSearchWS.SearchMember();
		AdvancedSearchWS.SearchParm oSearchParm = new AdvancedSearchWS.SearchParm();
		AdvancedSearchWS.SearchParmItem oSearchParmItem = new AdvancedSearchWS.SearchParmItem();
		AdvancedSearchWS.SearchResult oSearchResult = new AdvancedSearchWS.SearchResult();
		AdvancedSearchWS.SearchSet oSearchSet = new AdvancedSearchWS.SearchSet();
		AdvancedSearchWS.SortParm oSortParm = new AdvancedSearchWS.SortParm();
		
		AdvancedSearchWS.AdvancedSearch_v1_0Port oService = new AdvancedSearchWS.AdvancedSearch_v1_0Port();
	}
}