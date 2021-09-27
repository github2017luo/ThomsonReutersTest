/**
 * Represents a collection of Advanced Search Accounts
 * <p>
 * Supports methods for paging and sorting
 *
 * @author  John De Santiago
 * @version 2012-07-23
 */

/**
 * CHANGE HISTORY
 * =============================================================================
 * Date         Name                    Description
 * 2012-07-23   John De Santiago        Created                                                           
 * =============================================================================
 */
public class AdvancedSearchAccounts {
	//Protected Members
	private final integer DefaultPageSize = 50;
	private integer iPageSize;
	
	//Constants
	private static final string SortAsc = 'Asc';
	private static final string SortDesc = 'Desc';
	
	//Properties
	public string SortField {get;set;}
	
	public string SortDirection {get;set;}
	
	public integer PageIndex {get;set;}
	
	public List<AdvancedSearchAccount> Accounts {get;set;}
	
	public List<List<AdvancedSearchAccount>> Pages {get; private set;}
	
	public integer PageSize {
		get { return this.iPageSize; }
	}
	
	public boolean AllowMoveNext {
		get{ return ((PageIndex + 1) < NumOfPages); }
	}
	
	public boolean AllowMovePrev {
		get{ return (PageIndex > 0); }
	}
	
	public integer NumOfPages {
		get{ return Pages.isEmpty() ? 1 : Pages.size(); }
	}
	
	public List<AdvancedSearchAccount> CurrentPage {
		get { return getCurrentPage(PageIndex); }
	}
	
	//Constructors
	public AdvancedSearchAccounts() {
		this.iPageSize = this.DefaultPageSize;
		
		this.PageIndex = 0;
		this.SortField = 'Name';
		this.SortDirection = SortAsc;
		this.Accounts = new List<AdvancedSearchAccount>();
		this.Pages = new List<List<AdvancedSearchAccount>>();
	}
	
	//Public Methods
	
	public void changePageSize(integer iValue) {
		this.iPageSize = iValue;
		this.splitRowsIntoPages();
	}
	
	public void initPaging() {
		this.splitRowsIntoPages();
	}
	
	public void movePrev() {
		try {
			this.PageIndex = this.PageIndex -1;
			
			if (this.PageIndex < 0) {	
				this.PageIndex = 0;
			}
		}
		catch(Exception oException) {
			ApexPages.addMessages(oException);
		}
	}
	
	public void moveNext() {
		try {
			this.PageIndex = this.PageIndex +1;
			
			if ((this.PageIndex + 1) > this.NumOfPages) {
				this.PageIndex = (this.NumOfPages - 1);
			}
		}
		catch(Exception oException) {
			ApexPages.addMessages(oException);
		}
	}
	
	public void sortData() {
		try {
			if (this.Accounts.isEmpty() == false) {
				AdvancedSearchAccount oFirstItem = this.Accounts[0];
				boolean bChanged = oFirstItem.SortBy != SortField;
				boolean bSortAsc = true;
				
				//Toggle Sort Direction
				if (this.sortDirection == SortAsc && bChanged == false) {
					this.sortDirection = SortDesc;
					bSortAsc = false;
				}
				else {
					this.sortDirection = SortAsc;
					bSortAsc = true;
				}
				
				//Set Sort Info and Sort
				for (AdvancedSearchAccount oAccountInfo : this.Accounts) {
					oAccountInfo.SortBy = SortField;
					oAccountInfo.SortAscending = bSortAsc;
				}
				
				this.Accounts.sort();
			}
			
			this.initPaging();
		}
		catch(Exception oException) {
			ApexPages.addMessages(oException);
		}
	}
	
	//Private Methods
	
	private void splitRowsIntoPages() {
		this.Pages = new List<List<AdvancedSearchAccount>>();
		this.PageIndex = 0;
		
		integer pageIndex = -1;
		for (AdvancedSearchAccount oAccountInfo : this.Accounts) {
			if (pageIndex == -1 || this.Pages[pageIndex].size() == this.iPageSize) {
				pageIndex++;
				this.Pages.add(new List<AdvancedSearchAccount>());
			}
			
			this.Pages[pageIndex].add(oAccountInfo);	
		}
	}
	
	private List<AdvancedSearchAccount> getCurrentPage(integer iPageIndex) {
		List<AdvancedSearchAccount> listPage = new List<AdvancedSearchAccount>();
		
		if (this.Accounts.isEmpty() == false && iPageIndex >= 0 && iPageIndex <= NumOfPages) {
			listPage = this.Pages[iPageIndex];
		}
		
		return listPage;
	}
}