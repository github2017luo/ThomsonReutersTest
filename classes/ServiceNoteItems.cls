/**
 * Wrapper class for a collection of ServiceNoteItems - to support paging

 *
 * @author  Sripriya Kongot 
 * @version  2012-10-20
 */
 /**
 * CHANGE HISTORY
 * =============================================================================
 * Date         Name                    Description
 * 2012-10-20   Sripriya Kongot         Created
 * =============================================================================
 */
public class ServiceNoteItems {
	 //Protected Members
  private final integer DefaultPageSize = 50;
  private integer iPageSize;  

  
  //Properties  
  public integer PageIndex {get;set;}
  
  public List<ServiceNotesServices.ServiceNoteItem> listServiceNotesItems {get;set;}
  
  public List<List<ServiceNotesServices.ServiceNoteItem>> Pages {get; private set;}
  
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
  
  public List<ServiceNotesServices.ServiceNoteItem> CurrentPage {
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
  public ServiceNoteItems() {
    this.iPageSize = this.DefaultPageSize;
    
    this.PageIndex = 0;   
    this.listServiceNotesItems = new List<ServiceNotesServices.ServiceNoteItem>();
    this.Pages = new List<List<ServiceNotesServices.ServiceNoteItem>>();
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
    this.Pages = new List<List<ServiceNotesServices.ServiceNoteItem>>();
    this.PageIndex = 0;
    
    integer pageIndex = -1;
    for (ServiceNotesServices.ServiceNoteItem oServiceNote : this.listServiceNotesItems) {
      if (pageIndex == -1 || this.Pages[pageIndex].size() == this.iPageSize) {
        pageIndex++;
        this.Pages.add(new List<ServiceNotesServices.ServiceNoteItem>());
      }
      
      this.Pages[pageIndex].add(oServiceNote);  
    }
  }
  
  private List<ServiceNotesServices.ServiceNoteItem> getCurrentPage(integer iPageIndex) {
    List<ServiceNotesServices.ServiceNoteItem> listPage = new List<ServiceNotesServices.ServiceNoteItem>();
    
    if (this.listServiceNotesItems.isEmpty() == false && iPageIndex >= 0 && iPageIndex <= NumOfPages) {
      listPage = this.Pages[iPageIndex];
    }
    
    return listPage;
  }

}