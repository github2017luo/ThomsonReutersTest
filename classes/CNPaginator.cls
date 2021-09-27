/**
* {Purpose} – Pagination helper class which iterates over a collection of relationships.
*
* @author  Shah Kadirmohideen
* @version  2011-12-07
*/   
  
/**
* CHANGE HISTORY
* =============================================================================
* Date      Name          Description
* 2011-12-07  Shah Kadirmohideen    Created      
* 2012-01-20  Shah Kadirmohideen    Incorporated enhanced list (go to list) functionality related changes.
* 2012-05-01  Shah Kadirmohideen    Modified error handling signature in next() method
* 2012-10-05  Shah Kadirmohideen    Enhanced exception handling using handleException() method 
* 2016-09-16  Denis Mitropolsky     Fixed issue with previous/next handlers
* 2016-09-19  Denis Mitropolsky     Fixed more issues with previous/next handlers
** =============================================================================
*/
public class CNPaginator {
  //Private variables
  public List<CNData.CNRelationship> relationships;
  private static final String sClassName = 'CNPaginator'; 
  //Public variables
  public CNListHandler oListHandler {get; set;}
  public CNEnhancedListHandler oEListHandler {get; set;}
  public static Boolean displayLastUpdateDate = true;
  public string pageNo{get;set;}
  public integer startRecordNo{get;set;}
  public integer endRecordNo{get;set;}
  public integer pageSize{get;set;}
  private string sortBy; 
  public string getsortBy(){
    return sortBy;
  }
  public void setsortBy(string val){
    CNData.sortBy = val;
    sortBy = val; 
  }  
  private string innersortBy;  
  public string getinnersortBy(){
    return innersortBy;
  }
  public void setinnersortBy(string val){
    CNData.innersortBy = val;
    innersortBy = val; 
  }  
  private string whichSort;
  public string getwhichSort(){
    return whichSort;
  }
  public void setwhichSort(string val){
    CNData.whichSort = val;
    whichSort = val; 
  } 
  /* CONSTRUCTORS */
  
  //Empty constructor
  public CNPaginator() {
    relationships = new List<CNData.CNRelationship>();    
  }
  
  //Constructor used for regular pagination which is used on embedded pages
  public CNPaginator(CNListHandler oListHandler) {  
     
    this.oListHandler = oListHandler;  
    system.debug('??????????>CNPaginator list passed has :' + oListHandler.listData.size());
    relationships = new List<CNData.CNRelationship>();
    setpagerStartNumber(oListHandler.currentPageNo);
    startRecordNo = 0;
    pageNo = '1';
    pageSize = Integer.valueOf(CNAppUtils.getAppCustomSetting().Data_Display_Size__c);
    endRecordNo = pageSize;
    sortBy = 'scoreDesc';
    innerSortBy = 'innerscoreDesc';
    whichSort = 'outer';
    next();
  }
  
  public void sortDataBy(){
    //pass sortOrderName from page grid header !**must have implemented Comparable and sort in the innerClass of sorted List<Class>
    //CNData.sortBy is set py page link param.
    relationships = new List<CNData.CNRelationship>();
    //handle title and name differently, emails and emptys at end in asc/desc sort 
   
    //check if sorting contacts or colleagues
    string currSort = CNData.sortBy;
    //
    if(currSort.contains('score') || currSort.contains('email') || currSort.contains('recency')){
      oListHandler.listData.sort(); 
}
    if(currSort.contains('location')){
      system.debug(' entered into location sort');
      List<object> blankLocations = new List<object>();
      List<object> normalLocations = new List<object>();
      for(object cnr : oListHandler.listData){
        CNData.CNRelationship c = (CNData.CNRelationship)cnr;        
        if(c.colleague.workingLocation!=null){
            if(c.colleague.workingLocation.trim()==''){
              blankLocations.add((object)c);
            }else{
              normalLocations.add((object)c);
            }
        }else{
            blankLocations.add((object)c);
        }        
      }
      system.debug('normal Locations list size:' + normalLocations.size());
      system.debug('blank Locations list size:' + blankLocations.size());
      normalLocations.sort();
       
      normalLocations.addAll(blankLocations);//this should put them at end
      oListHandler.listData.clear();
      oListHandler.listData.addAll(normalLocations);
    }
    //    
    // 
    if(currSort.contains('name')){
      //
      system.debug(' entered into name sort');
      List<object> emailNames = new List<object>();
      List<object> normalNames = new List<object>();
       
      for(object cnr : oListHandler.listData){
        CNData.CNRelationship c = (CNData.CNRelationship)cnr;
        string compare = '';
        if(c.contact!=null){
            compare = c.contact.lastName + c.contact.firstName;
        }else{ 
            compare = c.colleague.lastName + c.colleague.firstName;
        }
        if(compare.contains('@')||compare==''){
          emailNames.add((object)c);
        }else{
          normalNames.add((object)c);
        }
      }
      system.debug('normal names list size:' + normalNames.size());
      system.debug('email names list size:' + emailNames.size());
      normalNames.sort();
      string csort = currSort;
      currSort = (currSort.contains('Asc'))?'emailAsc':'emailDesc';
      CNData.sortBy = currSort;
      emailNames.sort();
      currSort = csort;
      CNData.sortBy = csort;
      normalNames.addAll(emailNames);//this should put them at end
      oListHandler.listData.clear();
      oListHandler.listData.addAll(normalNames);
            
    }  
    if(currSort.contains('title')){
      system.debug(' entered into title sort');
      List<object> blankTitles = new List<object>();
      List<object> normalTitles = new List<object>();
       
      for(object cnr : oListHandler.listData){
        CNData.CNRelationship c = (CNData.CNRelationship)cnr;
        if(c.contact!=null){  
            if(c.contact.title!=null){       
                if(c.contact.title.trim()==''){
                  blankTitles.add((object)c);
                }else{
                  normalTitles.add((object)c);
                }
            }else{
                blankTitles.add((object)c);
            }
        }else{
            if(c.colleague.title!=null){
                if(c.colleague.title.trim()==''){
                  blankTitles.add((object)c);
                }else{
                  normalTitles.add((object)c);
                }
            }else{
                blankTitles.add((object)c);
            }
        }
      }
      normalTitles.sort();
       
      normalTitles.addAll(blankTitles);//this should put them at end
      oListHandler.listData.clear();
      oListHandler.listData.addAll(normalTitles);
    }
    
    oListHandler.lastIndex = -1;
    oListHandler.lastPageSize = -1;
    oListHandler.bCNHasNoMoreData = false;      
    oListHandler.currentPageNo = 1;
    first();
  }
  //Constructor used for enhanced list pagination which is used as 'Go to list'
  public CNPaginator(CNEnhancedListHandler oEListHandler) {
    this.oEListHandler = oEListHandler;
  }
  
  /* PUBLIC METHODS */
  
  //Fetches the next set of records which will be displayed on next page.
  //change this for paging by 
  public void next() {      
      setSort();
      if(oListHandler == null) {
          system.debug('oListHandler passed to CNPaginator was null');
      }
      
      try {
        System.debug('invoked' + sClassName );
        relationships = new List<CNData.CNRelationship>();//added for paging by x
        relationships.addAll(convertObjectsToRelationships(oListHandler.nextPage()));        
        System.debug('relationships count after fetching next page: ' + relationships.size());

          //ignore first page
        if(getcurrentPageNo()-pagerStartNumber>4&&getcurrentPageNo()>5){
          pagerStartNumber = pagerStartNumber+5;
          setcurrentPageNo(pagerStartNumber+1);//handle button view             
        }
          
        integer trecs = getTotalRecords();
        //if on first page do nothing
        if(startRecordNo!=0 ) {
          //advance 1 page unless that exceeds total 
          startRecordNo = (startRecordNo + pageSize<= trecs)?(startRecordNo + pageSize):trecs;
          //set end count to start plus page size unless that is > total then set to total (note the before and after effect!!!!!)
          endRecordNo = (startRecordNo + pageSize<= trecs)?((startRecordNo + pageSize)-1):trecs;
        } else {
          startRecordNo = 1; //for first load...
          endRecordNo = (startRecordNo + pageSize<= trecs)?((startRecordNo + pageSize)-1):trecs;
        }
      }
      catch (Exception oExp) {
        CNAppUtils.handleException(new CNData.CNExceptionInfo(oExp, ApexPages.Severity.ERROR, 
            sClassName, 'next()',
            'sMoreInfo', true, true, sClassName));
      }            
  }
    
  public void previous() {
    // this is to handle button clicks on the pager going back 1 page
    setSort();
    try {
        integer currentPg = getcurrentPageNo() - 1;//  Math.max(getcurrentPageNo() - 1, 1);
        currentPg = Math.max(currentPg, 1);
        pageNo = currentPg.format();
        specificPage();
        pagerStartNumber = ((pagerStartNumber - getcurrentPageNo() > 0)) ? (pagerStartNumber - 5) : pagerStartNumber;          
     } catch (Exception oExp) {
          CNAppUtils.handleException(
              new CNData.CNExceptionInfo(
                  oExp, 
                  ApexPages.Severity.ERROR, 
                  sClassName, 
                  'previous()',
                  'sMoreInfo', 
                  true, 
                  true, 
                  sClassName
              )
          );
      }            
  }
  
  public void last() {
    // this is to handle button clicks on the pager***
    setSort();
    if(oListHandler != null){
      try {
        //start pageNo is the first page in the series of 5 so 1,6,11,16 etc 
        //find by (total records/ records per page)add 1 page if mod((total records/ records per page))>0
        //divide whole thing by 5 (we have 5 buttons)and that should give us the start pager number
        endRecordNo = getTotalRecords();
        integer lastPageNo = (math.mod(oListHandler.iTotalRecords,pageSize)>0)?(oListHandler.iTotalRecords/pageSize)+1:(oListHandler.iTotalRecords/pageSize);
        setcurrentPageNo(lastPageNo + 1);
        //start record is page start no lower than total (so 91-98 of 98 or 101-101 of 101)
        pageNo = string.valueOf(lastPageNo);
          
        specificPage();

        if(math.Mod(lastPageNo,5)>0){         
            setpagerStartNumber((Integer.valueOf(lastPageNo/5)*5)+1); //add 1 page for the overage
        }else{
            setpagerStartNumber((Integer.valueOf(lastPageNo/5)*5)-4);
        }
      }
      catch (Exception oExp) {
         system.debug('CNPaginator last() fn threw error:' + oExp.getMessage());
        CNAppUtils.handleException(new CNData.CNExceptionInfo(oExp, ApexPages.Severity.ERROR, 
            sClassName, 'next()',
            'sMoreInfo', true, true, sClassName));
      }            
    }else{
      system.debug('oListHandler passed to CNPaginator was null');
    }
  }
    
    private void setSort() {
        CNData.sortBy = sortBy;
        CNData.innerSortBy = innerSortBy;
        CNData.whichSort = whichSort;
    }
    
  public void first() {
    // this is to handle button clicks on the pager
    setSort();
    pagerStartNumber = 1;
    pageNo = '1';
    specificPage();        
  }
  public void specificPage() {
    // this is to handle button clicks on the pager
    system.debug('in specificPage code');
    setSort();
    if(oListHandler != null){
      try {
        if(pageNo == null) { 
            pageNo = '1'; 
        }
        System.debug('invoked' + sClassName );
        relationships = new List<CNData.CNRelationship>();//added for paging by x
        relationships.addAll(convertObjectsToRelationships(oListHandler.specificPage(pageNo)));
        System.debug('relationships count after fetching next page: ' + relationships.size());
        integer cPg = integer.valueOf(pageNo);
        integer trecs = getTotalRecords();
        startRecordNo = ((cPg*pageSize)-pageSize)+1;
        endRecordNo = Math.min(((cPg*pageSize)-pageSize) + pageSize, getTotalRecords());
        system.debug('cPg =' + cPg);
        system.debug('startRecordNo = ' + startRecordNo);
        system.debug('endRecordNo = ' + endRecordNo);
      }
      catch (Exception oExp) {
        CNAppUtils.handleException(new CNData.CNExceptionInfo(oExp, ApexPages.Severity.ERROR, 
            sClassName, 'next()',
            'sMoreInfo', true, true, sClassName));
      }            
    }else{
      system.debug('oListHandler passed to CNPaginator was null');
    }
  }  
  //advance to next set of buttons and set page
  public void Elipsis(){
    // this is to handle button clicks on the pager
    setSort();
    //set button start# this should be the base 5 lower value of pageno so 1,6,11,16 etc
    integer baseNo = ((integer)integer.valueOf(pageNo)/5)*5;  //this is currently selected page span    
    setpagerStartNumber(baseNo +1); //1 based not 0 based
    specificPage();//this should nav us to correct page set with the correct left end button selected
  }
    
  //advance to next set of buttons and set page
  public void backElipsis(){
    // this is to handle button clicks on the pager
    setSort();
    //set button start# 
    //set button start# this should be the base 5 lower value of pageno so 1,6,11,16 etc
    integer baseNo = ((integer)integer.valueOf(pageNo)/5)*5;  //this is currently selected page span    
    setpagerStartNumber(baseNo -4); //1 based not 0 based
    pagerStartNumber = ((baseNo -4)<1)?1:baseNo -4;
    
    pageNo = string.valueOf(pagerStartNumber + 4);
    specificPage();//this should naqv us to correct page
  }
  //Calculates the total number of records displayed so far on the page.
  public Integer getSize() {  
    if (relationships != null) {
      return relationships.size();
    }
    return 0;
  }
  private integer pagerStartNumber;
  public integer getpagerStartNumber(){
    //holds the first and last nos of the pager display buttons imnitially 1-5 if 5 or more pages but slides forward or back
    return pagerStartNumber;
  } 
  public void setpagerStartNumber(integer val){
    pagerStartNumber = val;
  }
  private integer pagerEndNumber;
  public integer getpagerEndNumber(){
    // 5 at a time but obviously if less than 5 more pages it doesn't show buttons for non existant pages so button display may be from 1 to 5 
    return pagerEndNumber;
  }
  public void setpagerEndNumber(integer val){
    pagerEndNumber=val;
  }
  //Returns the total records count from the list handler.
  public Integer getTotalRecords() {
    if (oListHandler != null) {
      return oListHandler.iTotalRecords;
    }
    else if (oEListHandler != null) {
      return oEListHandler.iTotalRecords;
    }
    return 0;
  }
  //seperate end of pager control tracking #
  
  public integer getEndOfPages(){   
    integer iTotalRecords = getTotalRecords();
    return ((iTotalRecords-endRecordNo)>0)?1:0;    
  }
  //   
  //returns total pages based on int(total/size of page)+1 
  //returns currentPageNo
  public integer getTotalPages(){
    if(MATH.MOD(getTotalRecords(),pageSize) !=0){
      return (integer)((getTotalRecords()/pageSize)+1);
    }else{
      return (integer)(getTotalRecords()/pageSize);
    }
  }
  public integer getcurrentPageNo()
  {
    return oListHandler.currentPageNo-1;//seems to always be on the next count?
  }
  public void setcurrentPageNo(integer value){
    oListHandler.currentPageNo = value;
  }
  //returns lastindex
  public integer getlastindex()
  {
    return (oListHandler.lastIndex);
  }
  //returns size of last page
  public integer getlastPageSize(){
    return oListHandler.lastPageSize;
  }
  //returns size of current page
  public integer getcurrentPageSize(){
    return oListHandler.currentPageSize;
  }
  //returens load capacity
  public integer getloadCapacity(){
    return oListHandler.loadCapacity;
  }
  //returns no more data
  public boolean getbCNHasNoMoreData(){
    return oListHandler.bCNHasNoMoreData;
  }
  //Includes both filtered & non filtered records counts which is displayed on the tab name
  public String getRecordsCountOnTabName() {
    Integer iTotalRecs = getTotalRecords();
    if (oListHandler != null) {
      if (iTotalRecs != null && iTotalRecs > 0) {
        return '(' + iTotalRecs + ')';
      } else {
        return '';
      }
    }
    else { //Enhanced list page
      String sLabel = '(';
      if (oEListHandler.sStartsWith != null && oEListHandler.sStartsWith != 'All') {
        if (oEListHandler.tabName == 'Colleague') {
          sLabel += iTotalRecs + ' of ' + oEListHandler.oQueueHandler.getTotalColleagues();
        }
        else {
          sLabel += iTotalRecs + ' of ' + oEListHandler.oQueueHandler.getTotalContacts();
        }
      }
      else {
        sLabel += iTotalRecs;
      }
      sLabel += ')';
      return sLabel;
    }
  }
    
  //Retrieves the records count for next page based on pagination parameters.
  public String getNextPageLabel() {
    return oListHandler != null ? oListHandler.getNextPageLabel() : '';
  }
  
  //Decides if next page label is empty or not
  public Boolean getHasNextPageLabel() {
    return CNAppUtils.isNonEmpty(getNextPageLabel());
  }
  
  //Decides if the last update field can be displayed or not
  public Boolean getDisplayLastUpdateDate() {
    return displayLastUpdateDate;
  }
  
  //Fetches the relationship information from memory cache.
  public List<CNData.CNRelationship> getAllRelationshipsInCache() {
    List<CNData.CNRelationship> listAllRels = new List<CNData.CNRelationship>();
    if (oListHandler != null) {
      listAllRels.addAll(convertObjectsToRelationships(oListHandler.listData));
    }
    System.debug('listAllRels: ' + listAllRels);
    return listAllRels;
  }
  
  //Returns the relationship from either the standard one or enhanced
  public List<CNData.CNRelationship> getRelationships() {
    if (oEListHandler != null) {
      return this.oEListHandler.getRelationships();
    }
    else {
      return this.relationships;
    }
  }
  public void setRelationships(List<CNData.CNRelationship> val){
    this.relationships = val;
  }
  /* PRIVATE METHODS */
  
  //Restructures the relationship data for display purposes.
  private List<CNData.CNRelationship> convertObjectsToRelationships(List<Object> oList) {
    List<CNData.CNRelationship> listRel = new List<CNData.CNRelationship>();
    CNPaginator.displayLastUpdateDate = true;//false;
    
    if (oList != null) {
      System.debug('input size: ' + oList.size());
      integer count = 0;
      for (Object oRelObj : oList) {
        CNData.CNRelationship oRel = (CNData.CNRelationship) oRelObj;
        if (oRel.contact != null && oRel.contact.LastModificationTimeAlt != null) {
          CNPaginator.displayLastUpdateDate = true;
        }
        oRel.index = count;
        count++;
        listRel.add(oRel);
      }
    }
    return listRel;
  }  
}