@isTest
public class personWidgetCtrlTest{

    public static Contact createContact(String fName, String lName, Integer perID){
        Contact oContact = new Contact();
        oContact.FirstName = fName;
        oContact.LastName = lName;
        oContact.Person_ID__c = String.valueof(perID);
        insert oContact;
        return oContact;
    }
    
    public static testMethod void testContructor(){
        Contact oContact = createContact('test', 'tester', 12345);
        
        WebServiceSettings__c oWebServiceSettings = new WebServiceSettings__c();
        oWebServiceSettings.Name = PersonWidgetIntegrationHelper.PersonWidgetMainScreenDataService;
        oWebServiceSettings.Endpoint__c = 'https:\\test.thomsonreuters.com';
        oWebServiceSettings.Timeout__c = 5;
        oWebServiceSettings.Username__c = '';
        oWebServiceSettings.Password__c = '';
        oWebServiceSettings.Active__c = true;
        oWebServiceSettings.Service_Unavailable_Message__c = 'Service is currently unavailable';
        insert oWebServiceSettings;
        
        PageReference oPage = Page.personWidgetMainPage;
        Test.setCurrentPage(oPage);
        
        ApexPages.StandardController oStandardController = new ApexPages.StandardController(oContact);
        Test.startTest();
            Test.setMock(HttpCalloutMock.class, new PersonWidgetMockHttpResponse()); 
            personWidgetCtrl oController = new personWidgetCtrl(oStandardController);
            oController.dosomething();
            System.assert(oController.hisDataCol1Name == System.Label.Person_Con_His_DateTime);
            System.assert(oController.hisDataCol2Name == System.Label.Person_Con_His_ContactName);
            System.assert(oController.hisDataCol3Name == System.Label.Person_Con_His_LastUp);
            System.assert(oController.selPanel == 'none');
        Test.stopTest();
    }
    
    public static testMethod void testChangePanel(){
        Contact oContact = createContact('test', 'tester', 12345);
        
        PageReference oPage = Page.personWidgetMainPage;
        Test.setCurrentPage(oPage);
        
        ApexPages.StandardController oStandardController = new ApexPages.StandardController(oContact);
        Test.startTest();
            Test.setMock(HttpCalloutMock.class, new PersonWidgetMockHttpResponse()); 
            personWidgetCtrl oController = new personWidgetCtrl(oStandardController);
            oController.hisDataList = new personWidgetCtrl.CreatePagination();
            System.currentPageReference().getParameters().put('selPanel', '');
            oController.changePanel();
            System.currentPageReference().getParameters().put('selPanel', 'none');
            oController.changePanel();
            System.assert(oController.selPanel == 'none');
            System.currentPageReference().getParameters().put('selPanel', 'viewAll');
            oController.changePanel();
            System.assert(oController.selPanel == 'viewAll');
            System.currentPageReference().getParameters().put('selPanel', 'recAct');
            oController.changePanel();
            System.assert(oController.selPanel == 'recAct');
            System.currentPageReference().getParameters().put('selPanel', 'openLead');
            oController.changePanel();
            System.assert(oController.selPanel == 'openLead');
            System.currentPageReference().getParameters().put('selPanel', 'unworkLead');
            oController.changePanel();
            System.assert(oController.selPanel == 'unworkLead');
            System.currentPageReference().getParameters().put('selPanel', 'allOpen');
            oController.changePanel();
            System.assert(oController.selPanel == 'allOpen');
            System.currentPageReference().getParameters().put('selPanel', 'closedPipe');
            oController.changePanel();
            System.assert(oController.selPanel == 'closedPipe');
            System.currentPageReference().getParameters().put('selPanel', 'oppOnDemTrails');
            oController.changePanel();
            System.assert(oController.selPanel == 'oppOnDemTrails');
            System.currentPageReference().getParameters().put('selPanel', 'allAct');
            oController.changePanel();
            System.assert(oController.selPanel == 'allAct');
            System.currentPageReference().getParameters().put('selPanel', 'subRenNext');
            oController.changePanel();
            System.assert(oController.selPanel == 'subRenNext');
            System.currentPageReference().getParameters().put('selPanel', 'subAccess');
            oController.changePanel();
            System.assert(oController.selPanel == 'subAccess');
            System.currentPageReference().getParameters().put('selPanel', 'markActLast90');
            oController.changePanel();
            System.assert(oController.selPanel == 'markActLast90');
            System.currentPageReference().getParameters().put('selPanel', 'salesAct90');
            oController.changePanel();
            System.assert(oController.selPanel == 'salesAct90');
            System.currentPageReference().getParameters().put('selPanel', 'test');
            oController.changePanel();
        Test.stopTest();
    }
    
    public static testMethod void testGetFormatedDate(){
        Contact oContact = createContact('test', 'tester', 12345);
        
        PageReference oPage = Page.personWidgetMainPage;
        Test.setCurrentPage(oPage);
        
        ApexPages.StandardController oStandardController = new ApexPages.StandardController(oContact);
        Test.startTest();
            personWidgetCtrl oController = new personWidgetCtrl(oStandardController);
            String resp = oController.getFormatedDate('2015-10-21T03:41:19Z');
            System.assert(resp == '10/21/2015 Wed 03:41 AM');
        Test.stopTest();
    }
    
    public static testMethod void testPaginationClass(){
        Contact oContact = createContact('test', 'tester', 12345);
        
        PageReference oPage = Page.personWidgetMainPage;
        Test.setCurrentPage(oPage);
        
        ApexPages.StandardController oStandardController = new ApexPages.StandardController(oContact);
        Test.startTest();
            Test.setMock(HttpCalloutMock.class, new PersonWidgetMockHttpResponse()); 
            personWidgetCtrl oController = new personWidgetCtrl(oStandardController);
            oController.hisDataList = new personWidgetCtrl.CreatePagination();
            List<personWidgetCtrl.HistoryData> hisList = new List<personWidgetCtrl.HistoryData>();
            for(Integer i = 0;i<1;i++){ 
                personWidgetCtrl.HistoryData hw = new personWidgetCtrl.HistoryData('data11', 'data12', 'data13');
                hisList.add(hw);
            }
            oController.hisDataList.splitRowsIntoPages(hisList,'contact');
            hisList = new List<personWidgetCtrl.HistoryData>();
            for(Integer i = 0;i<1;i++){ 
                personWidgetCtrl.HistoryData hw = new personWidgetCtrl.HistoryData('data11', 'data12', 'data13');
                hisList.add(hw);
            }
            oController.hisDataList.splitRowsIntoPages(hisList,'lead');
            hisList = new List<personWidgetCtrl.HistoryData>();
            for(Integer i = 0;i<1;i++){ 
                personWidgetCtrl.HistoryData hw = new personWidgetCtrl.HistoryData('data11', 'data12', 'data13');
                hisList.add(hw);
            }
            oController.hisDataList.splitRowsIntoPages(hisList,'opp');
            hisList = new List<personWidgetCtrl.HistoryData>();
            for(Integer i = 0;i<1;i++){ 
                personWidgetCtrl.HistoryData hw = new personWidgetCtrl.HistoryData('data11', 'data12', 'data13');
                hisList.add(hw);
            }
            oController.hisDataList.splitRowsIntoPages(hisList,'subs');
            hisList = new List<personWidgetCtrl.HistoryData>();
            for(Integer i = 0;i<1;i++){ 
                personWidgetCtrl.HistoryData hw = new personWidgetCtrl.HistoryData('data11', 'data12', 'data13');
                hisList.add(hw);
            }
            oController.hisDataList.splitRowsIntoPages(hisList,'markAct');
            hisList = new List<personWidgetCtrl.HistoryData>();
            for(Integer i = 0;i<1;i++){ 
                personWidgetCtrl.HistoryData hw = new personWidgetCtrl.HistoryData('data11', 'data12', 'data13');
                hisList.add(hw);
            }
            oController.hisDataList.splitRowsIntoPages(hisList,'salesAct');
            
            oController.hisDataList.selPanel = 'none';
            oController.hisDataList.PageIndex = 0;
            Integer pageSize = oController.hisDataList.PageSize;
            Boolean AllowMoveNext = oController.hisDataList.AllowMoveNext;
            Boolean AllowMovePrev = oController.hisDataList.AllowMovePrev;
            Integer NumOfPages = oController.hisDataList.NumOfPages;
            List<personWidgetCtrl.HistoryData> CurrentPage = oController.hisDataList.CurrentPage;
            Integer CurrentPageRecordSize = oController.hisDataList.CurrentPageRecordSize;
            Integer RecordStart = oController.hisDataList.RecordStart;
            Integer RecordEnd = oController.hisDataList.RecordEnd;
            Integer totalCount = oController.hisDataList.totalCount;
            
            oController.hisDataList.selPanel = 'openLead';
            totalCount = oController.hisDataList.totalCount;
            NumOfPages = oController.hisDataList.NumOfPages;
            CurrentPage = oController.hisDataList.CurrentPage;
            
            oController.hisDataList.selPanel = 'openLead';
            totalCount = oController.hisDataList.totalCount;
            NumOfPages = oController.hisDataList.NumOfPages;
            CurrentPage = oController.hisDataList.CurrentPage;
            
            oController.hisDataList.selPanel = 'allOpen';
            totalCount = oController.hisDataList.totalCount;
            NumOfPages = oController.hisDataList.NumOfPages;
            CurrentPage = oController.hisDataList.CurrentPage;
            
            oController.hisDataList.selPanel = 'allAct';
            totalCount = oController.hisDataList.totalCount;
            NumOfPages = oController.hisDataList.NumOfPages;
            CurrentPage = oController.hisDataList.CurrentPage;
            
            oController.hisDataList.selPanel = 'markActLast90';
            totalCount = oController.hisDataList.totalCount;
            NumOfPages = oController.hisDataList.NumOfPages;
            CurrentPage = oController.hisDataList.CurrentPage;
            
            oController.hisDataList.selPanel = 'salesAct90';
            totalCount = oController.hisDataList.totalCount;
            NumOfPages = oController.hisDataList.NumOfPages;
            CurrentPage = oController.hisDataList.CurrentPage;
            
            oController.hisDataList.selPanel = 'test';
            totalCount = oController.hisDataList.totalCount;
            NumOfPages = oController.hisDataList.NumOfPages;
            CurrentPage = oController.hisDataList.CurrentPage;
            
            oController.hisDataList.movePrev();
            oController.hisDataList.moveNext();
            
            
        Test.stopTest();
    }
}