public class AccountCreatePagination {
   //Protected Members
  private final integer DefaultPageSize = 25;
  private integer iPageSize;  

  
  //Properties  
  public integer PageIndex {get;set;}
  
  public List<AccountCreateController.MatchedECMAccount> listMatchedECMAccounts {get;set;}
  
  public List<List<AccountCreateController.MatchedECMAccount>> Pages {get; private set;}
  
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
  
  public List<AccountCreateController.MatchedECMAccount> CurrentPage {
    get { return getCurrentPage(PageIndex); }
  }
   public integer CurrentPageRecordSize {
    get { return getCurrentPage(PageIndex).size(); }
  }
  
   public integer RecordStart {
    get { return PageIndex*PageSize+1; }
  }
  public integer RecordEnd {
   // get { return (PageIndex+1)*CurrentPageRecordSize; }
    get { return (this.PageIndex + 1) == this.NumOfPages ? (PageIndex*PageSize)+CurrentPageRecordSize : (PageIndex+1)*CurrentPageRecordSize;}
      
  }
  //Constructors
  public AccountCreatePagination() {
    this.iPageSize = this.DefaultPageSize;
    
    this.PageIndex = 0;   
    this.listMatchedECMAccounts = new List<AccountCreateController.MatchedECMAccount>();
    this.Pages = new List<List<AccountCreateController.MatchedECMAccount>>();
  }
  
  //Public Methods
  
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
    
  
  //Private Methods
  
  private void splitRowsIntoPages() {
    this.Pages = new List<List<AccountCreateController.MatchedECMAccount>>();
    this.PageIndex = 0;
    
    integer pageIndex = -1;
    for (AccountCreateController.MatchedECMAccount oMatchedECMAcc : this.listMatchedECMAccounts) {
      if (pageIndex == -1 || this.Pages[pageIndex].size() == this.iPageSize) {
        pageIndex++;
        this.Pages.add(new List<AccountCreateController.MatchedECMAccount>());
      }
      
      this.Pages[pageIndex].add(oMatchedECMAcc);  
    }
  }
  
  private List<AccountCreateController.MatchedECMAccount> getCurrentPage(integer iPageIndex) {
    List<AccountCreateController.MatchedECMAccount> listPage = new List<AccountCreateController.MatchedECMAccount>();
    
    if (this.listMatchedECMAccounts.isEmpty() == false && iPageIndex >= 0 && iPageIndex <= NumOfPages) {
      listPage = this.Pages[iPageIndex];
    }
    
    return listPage;
  }

}