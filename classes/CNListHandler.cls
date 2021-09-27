/**
 * {Purpose} – Manages common properties for a list which is used by various services.
 *
 * @author  Shah Kadirmohideen
 * @version  2011-12-03
 */   

/**
 * CHANGE HISTORY
 * =============================================================================
 * Date      Name          Description
 * 2011-12-03  Shah Kadirmohideen    Created      
 * 2012-01-20  Shah Kadirmohideen    Incorporated enhanced list (go to list) functionality related changes.
 * 2016-09-14  Denis Mitropolsky     Updated to fix the issue with navigating to the last page
 * 2016-09-16  Denis Mitropolsky        Fixed issue with previous/next handlers
 * 2016-09-19  Denis Mitropolsky        Fixed more issues with previous/next handlers
* =============================================================================
 */
public abstract class CNListHandler {

    //Private variables
    private transient Integer iListSizeBeforeLoad = 0;
    private Integer iInitialLoadCapacity;
    private Boolean bCacheAvailable = false;
    private Integer iGotoListActionPollerRetryAttempts;

    //Protected variables
    public Integer lastIndex; //starts at 0
    public Integer lastPageSize;
    public Integer currentPageSize;
    public Integer currentPageNo;  //starts at 1
    public Integer loadCapacity;
    public Boolean bCNHasNoMoreData;
    public integer startRecordPosition; //for tracking page contents in list
    public integer endRecordPosition;  
    //Public variables
    public List<Object> listData;
    public Integer nextPageSize;
    public Boolean bObjectCacheFullyLoaded {get; set;}
    public String gotoListDynamicLabel {get; set;}
    public CNAppUtils.CNWebServiceQueueHandler oQueueHandler;
    public Boolean bRenderGotoListActionPoller {get; set;}
    public Integer iTotalRecords {get; set;}
    public String tabName {get; set;}

    /* CONSTRUCTORS */

    public CNListHandler() {
        this.currentPageSize = 1;
        
        this.loadCapacity = Integer.valueOf(CNAppUtils.getAppCustomSetting().Data_Cache_Size__c);
        this.iInitialLoadCapacity = loadCapacity;
        this.lastIndex = -1;
        this.lastPageSize = -1;
        this.bCNHasNoMoreData = false;
        this.currentPageNo = 1;

        this.listData = new List<Object>();
        this.bObjectCacheFullyLoaded = false;
        this.bRenderGotoListActionPoller = true;
        this.iGotoListActionPollerRetryAttempts = 0;
        this.iTotalRecords = 0;
    }

    /* PUBLIC METHODS */

    //Prepares the collection of records for next page based on pagination parameters.
    public List<Object> nextPage() {
        System.debug('identifying nextPage data');
        printDebugData('START');

        currentPageNo++;
        if (listData != null) iListSizeBeforeLoad = listData.size();
        prepareCurrentPageSize();
        if (oQueueHandler == null) loadQueueHandler();
        loadDataFromCN();

        List<Object> listNextPageData = prepareNextPageData();
        listNextPageData = massageNextPageData(listNextPageData);
        System.debug('listNextPageData size: ' + listNextPageData.size());

        lastPageSize = currentPageSize;
        printDebugData('END');    
        return listNextPageData;
    }
    //Prepares the collection of records for next page based on pagination parameters.
    public List<Object> previousPage() {
        System.debug('identifying previousPage data');
        printDebugData('START');
        currentPageNo--;
        if (listData != null) iListSizeBeforeLoad = listData.size();
        prepareCurrentPageSize();
        if (oQueueHandler == null) loadQueueHandler();
        loadDataFromCN();

        List<Object> listNextPageData = preparePreviousPageData();
        listNextPageData = massageNextPageData(listNextPageData);
        System.debug('listNextPageData size: ' + listNextPageData.size());

        lastPageSize = currentPageSize;
        printDebugData('END');

        return listNextPageData;
    }  
    
    //Prepares the collection of records for first page based on pagination parameters.
    public List<Object> lastPage() {
        System.debug('identifying lastPage data');
        printDebugData('START');
        if(Math.MOD(iTotalRecords,currentPageSize)>0){
            currentPageNo=integer.valueOf((iTotalRecords/currentPageSize))+1;
        }else{
            currentPageNo = integer.valueOf((iTotalRecords/currentPageSize));     
        }
        
        return specificPage(currentPageNo.format());
    }
    //return list for a specific page  
    public List<Object> specificPage(string pageNo) {
        System.debug('identifying specificPage data');
        printDebugData('START');
        if(integer.valueOf(pageNo)==1){// handle returning to first page
            this.lastIndex = -1;
            this.lastPageSize = -1;
            this.bCNHasNoMoreData = false;
        }
        currentPageNo = integer.valueOf(pageNo)+1; 
        if (listData != null) iListSizeBeforeLoad = listData.size();
        //prepareCurrentPageSize();
        if (oQueueHandler == null) loadQueueHandler();
        loadDataFromCN();      
        List<Object> listNextPageData = prepareSpecificPageData(pageNo);
        listNextPageData = massageNextPageData(listNextPageData);
        System.debug('listNextPageData size: ' + listNextPageData.size());
        lastPageSize = currentPageSize;
        //prepareNextPageSize();
        printDebugData('END');    
        return listNextPageData;
    }
    //Returns the label for next page link which is displayed on VF page. It includes the count in the label until all the records from cache is used.
    public String getNextPageLabel() {
        System.debug('getNextPageLabel starts, nextPageSize: ' + nextPageSize + ', lastIndex: ' + lastIndex);
        String sLabel = '';
        if (nextPageSize > 0 && iTotalRecords > CNAppUtils.getAppCustomSetting().Data_Display_Size__c) { 
            //sLabel = 'Show ';
            Integer recordsReturnedSoFar = lastIndex+1;
            System.debug('recordsReturnedSoFar: ' + recordsReturnedSoFar + ', iInitialLoadCapacity: ' + iInitialLoadCapacity);
            if (recordsReturnedSoFar + nextPageSize <= iInitialLoadCapacity) {
                sLabel += nextPageSize;// + ' '; 
            }
            //sLabel += 'More »';
        }
        System.debug('sLabel: ' + sLabel);
        return sLabel;  
    }

    //Checks if all relationship data have been fully stored in cache custom object
    public PageReference checkObjectCacheStatus() {
        System.debug('checkObjectCacheStatus starts. oQueueHandler: ' + oQueueHandler);
        oQueueHandler.refresh();
        this.bObjectCacheFullyLoaded = oQueueHandler.queueExistsWithFullyLoaded();
        System.debug('bObjectCacheFullyLoaded: ' + bObjectCacheFullyLoaded);
        iGotoListActionPollerRetryAttempts++;
        if (bObjectCacheFullyLoaded || iGotoListActionPollerRetryAttempts >= CNConstants.GOTO_LIST_LINK_DISPLAY_POLLER_MAX_ATTEMPTS) {
            bRenderGotoListActionPoller = false;
        }
        prepareGotoListLabel();    
        return null;
    }

    /* ABSTRACT METHODS */

    //Pulls the initial set of records from CN which are required to display the first page. Returns true if CN has more data to return.
    public abstract Boolean fetchInitialDataFromCN();

    //Pulls additional set of records from CN which are required to display subsequent pages. Returns true if CN has more data to return.
    public abstract Boolean fetchMoreDataFromCN();

    //Manipulates the input data for display purposes
    public abstract List<Object> massageNextPageData(List<Object> nextPageData);

    //pulls the initial set of relationship records from SFDC
    public abstract Boolean fetchAllDataFromSFDC();

    //Loads queue handler record
    public abstract void loadQueueHandler();

    //Returns the total cached relationships count
    public abstract Integer getCachedRelationshipsCount();

    /* PROTECTED METHODS */

    //Prints the context data for troubleshooting purposes.    
    protected void printDebugData(String label) {
        Integer iListSize = 0;
        if (listData != null) iListSize = listData.size();
        System.debug(label + ': lastIndex: ' + lastIndex + ', lastPageSize: ' + lastPageSize + ', loadCapacity: ' + loadCapacity + 
                ', bCNHasNoMoreData: ' + bCNHasNoMoreData + ', currentPageNo: ' + currentPageNo + 
                ', currentPageSize: ' + currentPageSize + ', iListSize: ' + iListSize);  
    }

    /* PRIVATE METHODS */

    //Prepares go to list label
    public void prepareGotoListLabel() {
        System.debug('prepareGotoListLabel start., bObjectCacheFullyLoaded: ' + bObjectCacheFullyLoaded);
        this.gotoListDynamicLabel = null;
        if (bObjectCacheFullyLoaded) {
            this.gotoListDynamicLabel = 'Go to list (' + getCachedRelationshipsCount() + ') »';
            System.debug('gotoListDynamicLabel: ' + gotoListDynamicLabel);
        }
    }
    //get specific page of data based on passed value + reset index
    public List<Object> prepareSpecificPageData(string pageNo) {
        List<Object> listDataSlice = new List<Object>();
        integer pg = integer.valueOf(pageNo);    
        integer startPos=((currentPageSize*pg)-(1+currentPageSize)>-1)?(currentPageSize*pg)-(currentPageSize):0; // gives us the starting point and checks for -0
        integer endPos;
        if( startPos + currentPageSize <= listData.size()-1){
            endPos = startPos + currentPageSize; 
        }else{
            endPos=startPos+(listData.size()-startPos);
        }
        
        startPos = math.max(startPos, 0);
        endPos = math.min(endPos, listData.size());
        
        //integer loopEnd = (startPos+10>listData.size()-1)?listData.size()-1:startPos+10;
        for (Integer i = startPos; i < endPos; i++) {
            listDataSlice.add(listData.get(i));
            lastIndex = i;
        }      
        return listDataSlice;
    }
    //Iterates through the local cache to identify the next set of records for next page.
    //need to watch end cases so first 5 and last modulo
    public List<Object> prepareNextPageData() {
        List<Object> listDataSlice = new List<Object>();
        integer startPos = lastIndex + 1; //first page this is 0 all others the last element of the last slice
        integer endPos;

        if( startPos + currentPageSize < listData.size()){
            endPos = startPos + currentPageSize; 
        } else {
            endPos = startPos + (listData.size() - startPos);
        }
        
        startPos = math.max(startPos, 0);
        endPos = math.min(endPos, listData.size());
            
        for (Integer i = startPos; i < endPos; i++) {      
            listDataSlice.add(listData.get(i));
            lastIndex = i;
        }      
        return listDataSlice;
    }
    
    //go to first page results
    public List<Object> prepareFirstPageData() {
        List<Object> listDataSlice = new List<Object>();
        for(integer i=0;i<currentPageSize;i++)
        {  
            listDataSlice.add(listData.get(i));
            lastIndex=i;
        }       
        currentPageSize = listDataSlice.size();
        currentPageNo = 1;
        return listDataSlice;
    }
    //go to last page results
    public List<Object> prepareLastPageData() {
        List<Object> listDataSlice = new List<Object>();
        integer remainingRecords = Math.MOD(iTotalRecords,currentPageSize);
        integer endPos = listData.size(); 
        integer startPos = listData.size() - (remainingRecords);//0 based
        for(integer i=startPos;i<endPos;i++)
        {  
            listDataSlice.add(listData.get(i));
            lastIndex = i;
        } 

        return listDataSlice;
    }
    //backup currentPageSize on index or to 0 and then get next currentPageSize of records from list
    //lastIndex should hold value of the last List's last row we have fetched so we want the  previous 
    // page of items not the previous 10 items since if the last page is not 10 items this would skew us
    public List<Object> preparePreviousPageData() {
        List<Object> listDataSlice = new List<Object>();
        integer endPos = lastIndex-(lastPageSize);
        integer startPos = (endPos - currentPageSize>-1)?endPos - currentPageSize:0;     
        for (Integer i=startPos; i< endPos; i++) {
            listDataSlice.add(listData.get(i));      
        }    
        lastIndex++; //
        return listDataSlice;
    }
    //Calculate the rest of records which are available in local cache.
    public Integer getRemainingRecordsInCache() {
        Integer iRecordsReturnedSoFar = lastIndex+1;
        Integer iListSize = 0;
        if (listData != null) iListSize = listData.size();
        Integer iRemainingRecords = iListSize - iRecordsReturnedSoFar;
        System.debug('iRecordsReturnedSoFar: ' + iRecordsReturnedSoFar + ', iRemainingRecords: ' + iRemainingRecords);
        return iRemainingRecords;
    }

    //Calculates the total number of records from current page
    private void prepareCurrentPageSize() {
        //just make it what ever is configured
        currentPageSize = Integer.valueOf(CNAppUtils.getAppCustomSetting().Data_Display_Size__c);//lastPageSize;
        System.debug('currentPageSize: ' + currentPageSize);
    }

    //Calculates the total number of records which are eligible for next page.
    private void prepareNextPageSize() {
        return;
    }  

    //Fetches the next set of records from ContactNet which will be stored in local cache.
    private void loadDataFromCN() {
        return; //implement when queue is working   
    }

    //Identifies if there are any more records present in ContactNet.
    public void checkIfEndOfDataReached() {
        return;    
    }
}