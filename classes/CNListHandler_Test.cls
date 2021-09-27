/**
* This class contains unit tests for CNListHandler
* created 2015-12-2 Glen Cunningham
* 2017-01-11    Denis Mitropolsky       Decrease number of iteration to avoid "Too many queries" error
*/
@isTest(seeAllData=true)
private class CNListHandler_Test {
    private class testCNListHandler extends CNListHandler{
        //Pulls the initial set of records from CN which are required to display the first page. Returns true if CN has more data to return.
        public override Boolean fetchInitialDataFromCN(){
            return true;
        }

        //Pulls additional set of records from CN which are required to display subsequent pages. Returns true if CN has more data to return.
        public override Boolean fetchMoreDataFromCN(){
            return true;
        }

        //Manipulates the input data for display purposes
        public override List<Object> massageNextPageData(List<Object> nextPageData){
            return nextPageData;
        }

        //pulls the initial set of relationship records from SFDC
        public override Boolean fetchAllDataFromSFDC(){
            return true;
        }

        //Loads queue handler record
        public override void loadQueueHandler(){}

        //Returns the total cached relationships count
        public override Integer getCachedRelationshipsCount(){
            return 5;
        }
    }
    static testMethod void myUnitTest() {
        Account a = CNUnitTest.getAccount(true);
        Test.startTest();
        testCNListHandler cn = new testCNListHandler();
        system.assertEquals(cn.fetchInitialDataFromCN(),true);
        system.assertEquals(cn.fetchMoreDataFromCN(),true);
        system.assertEquals(cn.fetchAllDataFromSFDC(),true);
        cn.loadQueueHandler();
        system.assertEquals(cn.getCachedRelationshipsCount(),5);

        cn.bObjectCacheFullyLoaded=false;
        cn.gotoListDynamicLabel='test label';
        CNAppUtils.CNWebServiceQueueHandler q = new CNAppUtils.CNWebServiceQueueHandler(a.id, '', '5003895', 'Contact'); 
        system.assertNotEquals(null,q);
        boolean bb = q.queueExistsWithFullyLoaded();  
        cn.oQueueHandler = q;
        cn.bRenderGotoListActionPoller = true;
        cn.iTotalRecords = 234;
        cn.tabName = 'contact';
        String s = cn.getNextPageLabel();
        PageReference pref = cn.checkObjectCacheStatus();
        cn.nextPageSize=0;
        List<Object> np1 = cn.nextPage();
        cn = new testCNListHandler();

        //
        List<Object> l = new List<Object>();
        List<Object> nextPageData = cn.massageNextPageData(l);
        List<Object> ol = cn.listData;
        cn.nextPageSize=1;
        cn.iTotalRecords = 900;
        string g = cn.getNextPageLabel();
        cn.loadQueueHandler();
        cn.bCNHasNoMoreData = false;
        List<Object> np = cn.nextPage();
        g = cn.getNextPageLabel();
        integer t = cn.getRemainingRecordsInCache();
        cn.bCNHasNoMoreData = true;
        np = cn.nextPage();
        g = cn.getNextPageLabel();
        t = cn.getRemainingRecordsInCache();
        cn.checkIfEndOfDataReached();
        List<Object> c = new List<Object>(); //loadCapacity iListSizeBeforeLoad
        for(integer i=0;i<5;i++){
            Account o = CNUnitTest.getAccount(true);
            c.add(o);
        }
        cn.listData = c;
        t = cn.getRemainingRecordsInCache();
        cn.checkIfEndOfDataReached();
        List<Object> av = cn.previousPage();
        av = cn.lastPage();
        av = cn.specificPage('1'); 
        cn.iTotalRecords = 100;
        cn.currentPageSize = 20;
        av = cn.nextPage();
        cn.checkIfEndOfDataReached(); 
        Account o = CNUnitTest.getAccount(true);
        CNAppUtils.CNWebServiceQueueHandler oQueueHandler = new CNAppUtils.CNWebServiceQueueHandler(o.id, '', '2657437','account');
        cn.oQueueHandler = oQueueHandler;
        cn.oQueueHandler.queueExistsWithFullyLoaded();
        av = cn.nextPage();
        cn.prepareGotoListLabel();
        av = cn.prepareSpecificPageData('1');
        List<Object> cq = new List<Object>(); //loadCapacity iListSizeBeforeLoad
        for(integer i=0;i<5;i++){
            Account oq = CNUnitTest.getAccount(true);
            cq.add(oq);
        }
        cn.listData = cq;
        cn.nextPageSize = 10;
        cn.currentPageNo = 2;
        av = cn.prepareNextPageData();
        av = cn.prepareFirstPageData();
        av = cn.prepareLastPageData();
        av = cn.preparePreviousPageData();
        integer xc = cn.getRemainingRecordsInCache();
        test.stopTest();
    }
    
    static testmethod void contactInnerColleagueTest() {
        CNContactInnerColleagueService service = new CNContactInnerColleagueService();
        service = new CNContactInnerColleagueService(new List<CNData.CNRelationship>());
        service.fetchInitialDataFromCN();
        service.fetchMoreDataFromCN();
        service.massageNextPageData(new List<Object>());
        service.loadQueueHandler();
        service.getCachedRelationshipsCount();
    }
}