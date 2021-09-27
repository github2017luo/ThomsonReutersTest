/**
 * Controller for the personWidgetMainPage.page that extends the 
 * Contact standard controller
 *
 * @author  TCS
 * @version 2016-03-28
 */

/**
 * CHANGE HISTORY
 * =============================================================================
 * Date         Name                    Description
 * 2015-09-01   TCS                     Created                                                                   
 * 2016-03-28   TCS                     Updated for lazy load
 * =============================================================================
 */
 
 public class personWidgetCtrl{
    //Properties
    public Boolean loadingFlag{get;set;}
    public String personID{get;set;}
    public ID ContactID{get;set;}
    public Boolean noRecordFlag{get;set;} //used as flag when peron record is not found in Contact Data Store or contact records is missing Person ID
    public String errorMsg{get;set;} //used to show error msg on screen
    public String selPanel{get;set;} //used to mark selection of user for diaplying list of records
    public String PersonName{get;set;}
    public String PersonLastUpdt{get;set;}
    //properties used to store count for various list of records
    public Integer countConAll{get;set;}
    public Integer countConRecAct{get;set;}
    public Integer countOpenLead{get;set;}
    public Integer countUnworLead{get;set;}
    public Integer countOppAll{get;set;}
    public Integer countOppClosed{get;set;}
    public Integer countOppOnDem{get;set;}
    public Integer countSubAll{get;set;}
    public Integer countSubRen{get;set;}
    public Integer countSubAccess{get;set;}
    public Integer countMarkAct90{get;set;}
    //public Integer countMarkActUnwork{get;set;}
    public Integer countSalesAct90{get;set;}
    //properties used to store table headers for history table
    public String hisDataCol1Name{get;set;}
    public String hisDataCol2Name{get;set;}
    public String hisDataCol3Name{get;set;}
    public String dataBlockName{get;set;} //used for Page block name of list of records
    public CreatePagination hisDataList{get;set;} //used for list of records in Last 24 hours section
    public boolean showNote {get;set;}
    //constructor
    public personWidgetCtrl(ApexPages.StandardController controller) {
        shownote = false;
        loadingFlag = true;
        Contact oContact = (Contact)controller.getRecord();
        //querying contact record
        //oContact = [Select ID, Person_ID__c from Contact Where Id =:oContact.ID];
        //personID = String.valueOF(oContact.Person_ID__c);
        ContactID = oContact.ID;
        //System.debug('personID : '+personID);
        selPanel = 'none';
        noRecordFlag = true; // default set to no record found
        //errorMsg = System.Label.Person_No_Person_Record_Found;
        //System.debug('PersonID component : '+personID);
        System.debug('ContactID component : '+ContactID);
        
        //if(personID != null){
        noRecordFlag = false;
        /*
        PersonWidgetIntegrationHelper.PersonWidgetWrapper pwObj = new PersonWidgetIntegrationHelper.PersonWidgetWrapper();
        PersonWidgetIntegrationHelper helperObj = new PersonWidgetIntegrationHelper();
        try{
            pwObj = helperObj.getPersonMainScreenData(ContactID);
            if(pwObj.output_PersonID == null || pwObj.output_PersonID == ''){
                throw new PersonWidgetIntegrationHelper.ServiceException(System.Label.Person_No_Person_Record_Found);//'Person Record not found in Data Store.');
            }
            personID = pwObj.output_PersonID;
            PersonName = pwObj.output_PersonFName + ' ' + pwObj.output_PersonLName;
            PersonLastUpdt = getFormatedDate(pwObj.output_PersonLastUp);
            countConAll = Integer.valueOf((pwObj.output_countContactAll == null)? '0' : pwObj.output_countContactAll);
            countConRecAct = Integer.valueOf((pwObj.output_countContactRecAct == null)? '0' : pwObj.output_countContactRecAct);
            countOpenLead = Integer.valueOf((pwObj.output_countLeadOpen == null)? '0' : pwObj.output_countLeadOpen);
            countUnworLead = Integer.valueOf((pwObj.output_countLeadUnWork == null)? '0' : pwObj.output_countLeadUnWork);
            countOppAll = Integer.valueOf((pwObj.output_countOppOpen == null)? '0' : pwObj.output_countOppOpen);
            countOppClosed = Integer.valueOf((pwObj.output_countOppClose == null)? '0' : pwObj.output_countOppClose);
            countOppOnDem = Integer.valueOf((pwObj.output_countOppOnDem == null)? '0' : pwObj.output_countOppOnDem);
            countSubAll = Integer.valueOf((pwObj.output_countSubsAll == null)? '0' : pwObj.output_countSubsAll);
            countSubRen = Integer.valueOf((pwObj.output_countSubsNext90 == null)? '0' : pwObj.output_countSubsNext90);
            countSubAccess = Integer.valueOf((pwObj.output_countSubsAccess == null)? '0' : pwObj.output_countSubsAccess);
            countMarkAct90 = Integer.valueOf((pwObj.output_countMarkActLast90 == null)? '0' : pwObj.output_countMarkActLast90);
            countSalesAct90 = Integer.valueOf((pwObj.output_countSalesActLast90 == null)? '0' :pwObj.output_countSalesActLast90);
            
            //setting default values for History table header to Contact labels
            hisDataList = new CreatePagination();
            hisDataCol1Name = System.Label.Person_Con_His_DateTime;
            hisDataCol2Name = System.Label.Person_Con_His_ContactName;
            hisDataCol3Name = System.Label.Person_Con_His_LastUp;
            hisDataList.selPanel = selPanel;
            hisDataList.PageIndex = 0;
            
            List<HistoryData> hisList = new List<HistoryData>();
            if(pwObj.output_hisContactList != NULL){
                for(PersonWidgetIntegrationHelper.HistoryData hisObj : pwObj.output_hisContactList){ 
                    HistoryData hw = new HistoryData(getFormatedDate(hisObj.UpdateDate), hisObj.Name, hisObj.ChangedValue);
                    hisList.add(hw);
                }
            }
            hisDataList.splitRowsIntoPages(hisList,'contact');
            hisList = new List<HistoryData>();
            if(pwObj.output_hisLeadList != NULL){
                for(PersonWidgetIntegrationHelper.HistoryData hisObj : pwObj.output_hisLeadList){ 
                    HistoryData hw = new HistoryData(getFormatedDate(hisObj.UpdateDate), hisObj.Name, hisObj.ChangedValue);
                    hisList.add(hw);
                }
            }
            hisDataList.splitRowsIntoPages(hisList,'lead');
            hisList = new List<HistoryData>();
            if(pwObj.output_hisOppList != NULL){
                for(PersonWidgetIntegrationHelper.HistoryData hisObj : pwObj.output_hisOppList){ 
                    HistoryData hw = new HistoryData(getFormatedDate(hisObj.UpdateDate), hisObj.Name, hisObj.ChangedValue);
                    hisList.add(hw);
                }
            }
            hisDataList.splitRowsIntoPages(hisList,'opp');
            hisList = new List<HistoryData>();
            if(pwObj.output_hisSubsList != NULL){
                for(PersonWidgetIntegrationHelper.HistoryData hisObj : pwObj.output_hisSubsList){ 
                    HistoryData hw = new HistoryData(getFormatedDate(hisObj.UpdateDate), hisObj.Name, hisObj.ChangedValue);
                    hisList.add(hw);
                }
            }
            hisDataList.splitRowsIntoPages(hisList,'subs');
            hisList = new List<HistoryData>();
            if(pwObj.output_hisMarkActList != NULL){
                for(PersonWidgetIntegrationHelper.HistoryData hisObj : pwObj.output_hisMarkActList){ 
                    HistoryData hw = new HistoryData(getFormatedDate(hisObj.UpdateDate), hisObj.Name, hisObj.ChangedValue);
                    hisList.add(hw);
                }
            }
            hisDataList.splitRowsIntoPages(hisList,'markAct');
            hisList = new List<HistoryData>();
            if(pwObj.output_hisSalesActList != NULL){
                for(PersonWidgetIntegrationHelper.HistoryData hisObj : pwObj.output_hisSalesActList){ 
                    HistoryData hw = new HistoryData(getFormatedDate(hisObj.UpdateDate), hisObj.Name, hisObj.ChangedValue);
                    hisList.add(hw);
                }
            }
            hisDataList.splitRowsIntoPages(hisList,'salesAct');
            //System.debug('hisDataList.CurrentPage : '+hisDataList.CurrentPage);
            //System.debug('hisDataList : '+hisDataList);
        }catch(Exception e){
            System.debug('exception : '+e.getStackTraceString());
            System.debug('exp message : '+e.getMessage());
            noRecordFlag = true;
            errorMsg = e.getMessage();
        }
        */
    }
    
    public void doSomething(){
        loadingFlag = false;
        PersonWidgetIntegrationHelper.PersonWidgetWrapper pwObj = new PersonWidgetIntegrationHelper.PersonWidgetWrapper();
        PersonWidgetIntegrationHelper helperObj = new PersonWidgetIntegrationHelper();
        try{
            pwObj = helperObj.getPersonMainScreenData(ContactID);
            if(pwObj.output_PersonID == null || pwObj.output_PersonID == ''){
                throw new PersonWidgetIntegrationHelper.ServiceException(System.Label.Person_No_Person_Record_Found);//'Person Record not found in Data Store.');
            }
            personID = pwObj.output_PersonID;
            PersonName = pwObj.output_PersonFName + ' ' + pwObj.output_PersonLName;
            PersonLastUpdt = getFormatedDate(pwObj.output_PersonLastUp);
            countConAll = Integer.valueOf((pwObj.output_countContactAll == null)? '0' : pwObj.output_countContactAll);
            countConRecAct = Integer.valueOf((pwObj.output_countContactRecAct == null)? '0' : pwObj.output_countContactRecAct);
            countOpenLead = Integer.valueOf((pwObj.output_countLeadOpen == null)? '0' : pwObj.output_countLeadOpen);
            countUnworLead = Integer.valueOf((pwObj.output_countLeadUnWork == null)? '0' : pwObj.output_countLeadUnWork);
            countOppAll = Integer.valueOf((pwObj.output_countOppOpen == null)? '0' : pwObj.output_countOppOpen);
            countOppClosed = Integer.valueOf((pwObj.output_countOppClose == null)? '0' : pwObj.output_countOppClose);
            countOppOnDem = Integer.valueOf((pwObj.output_countOppOnDem == null)? '0' : pwObj.output_countOppOnDem);
            countSubAll = Integer.valueOf((pwObj.output_countSubsAll == null)? '0' : pwObj.output_countSubsAll);
            countSubRen = Integer.valueOf((pwObj.output_countSubsNext90 == null)? '0' : pwObj.output_countSubsNext90);
            countSubAccess = Integer.valueOf((pwObj.output_countSubsAccess == null)? '0' : pwObj.output_countSubsAccess);
            countMarkAct90 = Integer.valueOf((pwObj.output_countMarkActLast90 == null)? '0' : pwObj.output_countMarkActLast90);
            countSalesAct90 = Integer.valueOf((pwObj.output_countSalesActLast90 == null)? '0' :pwObj.output_countSalesActLast90);
            
            //setting default values for History table header to Contact labels
            hisDataList = new CreatePagination();
            hisDataCol1Name = System.Label.Person_Con_His_DateTime;
            hisDataCol2Name = System.Label.Person_Con_His_ContactName;
            hisDataCol3Name = System.Label.Person_Con_His_LastUp;
            hisDataList.selPanel = selPanel;
            hisDataList.PageIndex = 0;
            
            List<HistoryData> hisList = new List<HistoryData>();
            if(pwObj.output_hisContactList != NULL){
                for(PersonWidgetIntegrationHelper.HistoryData hisObj : pwObj.output_hisContactList){ 
                    HistoryData hw = new HistoryData(getFormatedDate(hisObj.UpdateDate), hisObj.Name, hisObj.ChangedValue);
                    hisList.add(hw);
                }
            }
            hisDataList.splitRowsIntoPages(hisList,'contact');
            hisList = new List<HistoryData>();
            if(pwObj.output_hisLeadList != NULL){
                for(PersonWidgetIntegrationHelper.HistoryData hisObj : pwObj.output_hisLeadList){ 
                    HistoryData hw = new HistoryData(getFormatedDate(hisObj.UpdateDate), hisObj.Name, hisObj.ChangedValue);
                    hisList.add(hw);
                }
            }
            hisDataList.splitRowsIntoPages(hisList,'lead');
            hisList = new List<HistoryData>();
            if(pwObj.output_hisOppList != NULL){
                for(PersonWidgetIntegrationHelper.HistoryData hisObj : pwObj.output_hisOppList){ 
                    HistoryData hw = new HistoryData(getFormatedDate(hisObj.UpdateDate), hisObj.Name, hisObj.ChangedValue);
                    hisList.add(hw);
                }
            }
            hisDataList.splitRowsIntoPages(hisList,'opp');
            hisList = new List<HistoryData>();
            if(pwObj.output_hisSubsList != NULL){
                for(PersonWidgetIntegrationHelper.HistoryData hisObj : pwObj.output_hisSubsList){ 
                    HistoryData hw = new HistoryData(getFormatedDate(hisObj.UpdateDate), hisObj.Name, hisObj.ChangedValue);
                    hisList.add(hw);
                }
            }
            hisDataList.splitRowsIntoPages(hisList,'subs');
            hisList = new List<HistoryData>();
            if(pwObj.output_hisMarkActList != NULL){
                for(PersonWidgetIntegrationHelper.HistoryData hisObj : pwObj.output_hisMarkActList){ 
                    HistoryData hw = new HistoryData(getFormatedDate(hisObj.UpdateDate), hisObj.Name, hisObj.ChangedValue);
                    hisList.add(hw);
                }
            }
            hisDataList.splitRowsIntoPages(hisList,'markAct');
            hisList = new List<HistoryData>();
            if(pwObj.output_hisSalesActList != NULL){
                for(PersonWidgetIntegrationHelper.HistoryData hisObj : pwObj.output_hisSalesActList){ 
                    HistoryData hw = new HistoryData(getFormatedDate(hisObj.UpdateDate), hisObj.Name, hisObj.ChangedValue);
                    hisList.add(hw);
                }
            }
            hisDataList.splitRowsIntoPages(hisList,'salesAct');
            //System.debug('hisDataList.CurrentPage : '+hisDataList.CurrentPage);
            //System.debug('hisDataList : '+hisDataList);
        }catch(Exception e){
            System.debug('exception : '+e.getStackTraceString());
            System.debug('exp message : '+e.getMessage());
            noRecordFlag = true;
            errorMsg = e.getMessage();
        }
    }
    
    //method called on category selection
    public void changePanel(){
        shownote = false;
        selPanel = 'none';
        String paramVal = Apexpages.currentPage().getParameters().get('selPanel'); //retrieve parameters
        //if no value found 
        if(paramVal != null && paramVal != ''){
            selPanel = paramVal;
            hisDataList.selPanel = selPanel;
            hisDataList.PageIndex = 0;
            if(selPanel == 'none' || selPanel == 'viewAll' || selPanel == 'recAct'){ //when user is on Main screen or selected Contact category
                hisDataCol1Name = System.Label.Person_Con_His_DateTime;
                hisDataCol2Name = System.Label.Person_Con_His_ContactName;
                hisDataCol3Name = System.Label.Person_Con_His_LastUp;
                if(selPanel == 'viewAll'){
                    dataBlockName = System.Label.Person_Contacts + ' - ' + System.Label.Person_Con_View_All;
                }else if(selPanel == 'recAct'){
                    dataBlockName = System.Label.Person_Contacts + ' - ' + System.Label.Person_Con_With_Recent_Activities;
                }
                else{
                    dataBlockName = '';
                }
            }else if(selPanel == 'openLead' || selPanel == 'unworkLead'){ //when user selected Lead category
                hisDataCol1Name = System.Label.Person_Lead_His_DateTime;
                hisDataCol2Name = System.Label.Person_Lead_His_LeadName;
                hisDataCol3Name = System.Label.Person_Lead_His_LastUp;
                if(selPanel == 'openLead'){
                    dataBlockName = System.Label.Person_Lead_Header + ' - ' + System.Label.Person_Lead_Open_Leads;
                }else if(selPanel == 'unworkLead'){
                    dataBlockName = System.Label.Person_Lead_Header + ' - ' + System.Label.Person_Leads_Unworked_Leads;
                }
            }else if(selPanel == 'allOpen' || selPanel == 'closedPipe' || selPanel == 'oppOnDemTrails'){ //when user selected Opportunity category
                hisDataCol1Name = System.Label.Person_Oppt_His_DateTime;
                hisDataCol2Name = System.Label.Person_Oppt_His_OpportunityName;
                hisDataCol3Name = System.Label.Person_Oppt_His_LastUp;
                if(selPanel == 'allOpen'){
                    dataBlockName = System.Label.Person_Opportunities + ' - ' + System.Label.Person_Opp_All_Open;
                }else if(selPanel == 'closedPipe'){
                    dataBlockName = System.Label.Person_Opportunities + ' - ' + System.Label.Person_Opp_View_Closed_Pipeline;
                }else if(selPanel == 'oppOnDemTrails'){
                    dataBlockName = System.Label.Person_Lead_Header + ' - ' + System.Label.Person_Opp_On_Demand_Trials;
                }
            }else if(selPanel == 'allAct' || selPanel == 'subRenNext' || selPanel == 'subAccess'){ //when user selected Subscriptions category
                hisDataCol1Name = System.Label.Person_Subs_His_DateTime;
                hisDataCol2Name = System.Label.Person_Subs_His_Account;
                hisDataCol3Name = System.Label.Person_Subs_His_LastUp;
                if(selPanel == 'allAct'){
                    dataBlockName = System.Label.Person_Subscriptions + ' - ' + System.Label.Person_Subs_View_All_Active;
                    shownote = true;
                }else if(selPanel == 'subRenNext'){
                    dataBlockName = System.Label.Person_Subscriptions + ' - ' + System.Label.Person_Subs_Renewal_Next_90_Days;
                    shownote = true;
                }else if(selPanel == 'subAccess'){
                    dataBlockName = System.Label.Person_Subscriptions + ' - ' + System.Label.Person_Subs_Access;
                }
            }else if(selPanel == 'markActLast90'){ //when user selected Marketing Activities category
                hisDataCol1Name = System.Label.Person_Mark_His_DateTime;
                hisDataCol2Name = System.Label.Person_Mark_His_Activity;
                hisDataCol3Name = System.Label.Person_Mark_His_LastUp;
                if(selPanel == 'markActLast90'){
                    dataBlockName = 'Eloqua ' + System.Label.Person_Mark_Header + ' - ' + System.Label.Person_Mark_Last90;
                }
            }else if(selPanel == 'salesAct90'){ //when user selected Sales Activities category
                hisDataCol1Name = System.Label.Person_Sales_His_DateTime;
                hisDataCol2Name = System.Label.Person_Sales_His_Activity;
                hisDataCol3Name = System.Label.Person_Sales_His_LastUp;
                if(selPanel == 'salesAct90'){
                    dataBlockName = System.Label.Person_Sales_Header + ' - ' + System.Label.Person_Sales_Last90;
                }
            }else{
                dataBlockName = '';
            }
        }
        System.debug('test : '+selPanel);
        System.debug('test1 : '+noRecordFlag);
    }
    
    public String getFormatedDate(String dtString){
        String FinalString;
        try{
            String[] intitalSplit = dtString.split('T');
            intitalSplit[1] = intitalSplit[1].subString(0, intitalSplit[1].length() -1);
            String[] dateSplit = intitalSplit[0].split('-');
            String[] timeSplit = intitalSplit[1].split(':');
            DateTime myDateTime = DateTime.newinstance(Integer.valueOf(dateSplit[0]), Integer.valueOf(dateSplit[1]), Integer.valueOf(dateSplit[2]), Integer.valueOf(timeSplit[0]), Integer.valueOf(timeSplit[1]), Integer.valueOf(timeSplit[2]));
            String dayOfWeek = myDateTime.format('EEEE');
            FinalString = dateSplit[1] + '/' + dateSplit[2] + '/' + dateSplit[0] + ' ' + dayOfWeek.subString(0,3) 
                            + ' ' + ((Integer.valueOf(timeSplit[0])>12)?String.valueOf((Integer.valueOf(timeSplit[0])-12)):timeSplit[0]) 
                            + ':' + timeSplit[1]+ ' ' + ((Integer.valueOf(timeSplit[0])>=12)?'PM':'AM');
        }catch(Exception e){
            System.debug('exception msg : '+e.getMessage());
            System.debug('exception trace : '+e.getStackTraceString());
            FinalString = dtString;
        }
        System.debug('FinalString : '+FinalString);
        return FinalString;
    }
    
        
    /*Pagination Code Starts*/
    public class CreatePagination{
        //Protected Members
        private final integer DefaultPageSize = 3;
        private integer iPageSize;  
        private integer cols = 3;
    
        //Properties  
        public integer PageIndex{get;set;}
        public String selPanel{get;set;}
    
        public List<List<HistoryData>> contactPages{get; private set;}
        public List<List<HistoryData>> leadPages{get; private set;}
        public List<List<HistoryData>> oppPages{get; private set;}
        public List<List<HistoryData>> subsPages{get; private set;}
        public List<List<HistoryData>> markActPages{get; private set;}
        public List<List<HistoryData>> salesActPages{get; private set;}
        private Integer contactCount{get;set;}
        private Integer leadCount{get;set;}
        private Integer oppCount{get;set;}
        private Integer subsCount{get;set;}
        private Integer markActCount{get;set;}
        private Integer salesActCount{get;set;}
        
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
            get{ 
                integer numOfPages = 0;
                if(selPanel == 'none' || selPanel == 'viewAll' || selPanel == 'recAct')
                    numOfPages = contactPages.isEmpty() ? 1 : contactPages.size();
                else if(selPanel == 'openLead' || selPanel == 'unworkLead')
                    numOfPages = leadPages.isEmpty() ? 1 : leadPages.size();
                else if(selPanel == 'allOpen' || selPanel == 'closedPipe' || selPanel == 'oppOnDemTrails')
                    numOfPages = oppPages.isEmpty() ? 1 : oppPages.size();
                else if(selPanel == 'allAct' || selPanel == 'subRenNext'  || selPanel == 'subAccess')
                    numOfPages = subsPages.isEmpty() ? 1 : subsPages.size();
                else if(selPanel == 'markActLast90')
                    numOfPages = markActPages.isEmpty() ? 1 : markActPages.size();
                else if(selPanel == 'salesAct90')
                    numOfPages = salesActPages.isEmpty() ? 1 : salesActPages.size();
                else
                    numOfPages = 0;
                return numOfPages; 
            }
        }
    
        public List<HistoryData> CurrentPage {
            get { return getCurrentPage(PageIndex); }
        }
    
        public integer CurrentPageRecordSize {
            get { return getCurrentPage(PageIndex).size(); }
        }
    
        public integer RecordStart {
            get { return PageIndex*PageSize+1; }
        } 
    
        public integer RecordEnd {
            get { return (this.PageIndex + 1) == this.NumOfPages ? (PageIndex*PageSize)+CurrentPageRecordSize : (PageIndex+1)*CurrentPageRecordSize;}
        } 
        
        public integer totalCount{
            get{
                integer totalCount = 0;
                if(selPanel == 'none' || selPanel == 'viewAll' || selPanel == 'recAct'){
                    totalCount = contactCount;
                }else if(selPanel == 'openLead' || selPanel == 'unworkLead'){
                    totalCount = leadCount;
                }else if(selPanel == 'allOpen' || selPanel == 'closedPipe' || selPanel == 'oppOnDemTrails'){
                    totalCount = oppCount;
                }else if(selPanel == 'allAct' || selPanel == 'subRenNext'  || selPanel == 'subAccess'){
                    totalCount = subsCount;
                }else if(selPanel == 'markActLast90'){
                    totalCount = markActCount;
                }else if(selPanel == 'salesAct90'){
                    totalCount = salesActCount;
                }else{
                    totalCount = 0;
                }
                return totalCount;
            }
        }
    
        //Constructors
        public CreatePagination() {
            this.iPageSize = this.DefaultPageSize;
            
            this.PageIndex = 0;   
            this.contactPages = new List<List<HistoryData>>();
            this.leadPages = new List<List<HistoryData>>();
            this.oppPages = new List<List<HistoryData>>();
            this.subsPages = new List<List<HistoryData>>();
            this.markActPages = new List<List<HistoryData>>();
            this.salesActPages = new List<List<HistoryData>>();
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
        public void splitRowsIntoPages(List<HistoryData> hisData, String selPanel) {
            List<List<HistoryData>> Pages = new List<List<HistoryData>>();
            this.PageIndex = 0;
            integer pageIndex = -1;
            for (HistoryData oMatched : hisData) {
                if (pageIndex == -1 || Pages[pageIndex].size() == this.iPageSize) {
                    pageIndex++;
                    Pages.add(new List<HistoryData>());
                }
                Pages[pageIndex].add(oMatched);  
            }
            if(selPanel == 'contact'){
                contactPages = Pages;
                contactCount = hisData.Size();
            }else if(selPanel == 'lead'){
                leadPages = Pages;
                leadCount = hisData.Size();
            }else if(selPanel == 'opp'){
                oppPages = Pages;
                oppCount = hisData.Size();
            }else if(selPanel == 'subs'){
                subsPages = Pages;
                subsCount = hisData.Size();
            }else if(selPanel == 'markAct'){
                markActPages = Pages;
                markActCount = hisData.Size();
            }else if(selPanel == 'salesAct'){
                salesActPages = Pages;
                salesActCount = hisData.Size();
            }else{
            }
        }
        
        private List<HistoryData> getCurrentPage(integer iPageIndex) {
            List<HistoryData> listPage = new List<HistoryData>();
            if(selPanel == 'none' || selPanel == 'viewAll' || selPanel == 'recAct'){
                if(this.contactPages.isEmpty() == false && iPageIndex >= 0 && iPageIndex <= NumOfPages) {
                    listPage = this.contactPages[iPageIndex];
                }
            }
            else if(selPanel == 'openLead' || selPanel == 'unworkLead'){
                if(this.leadPages.isEmpty() == false && iPageIndex >= 0 && iPageIndex <= NumOfPages) {
                    listPage = this.leadPages[iPageIndex];
                }
            }
            else if(selPanel == 'allOpen' || selPanel == 'closedPipe' || selPanel == 'oppOnDemTrails'){
                if(this.oppPages.isEmpty() == false && iPageIndex >= 0 && iPageIndex <= NumOfPages) {
                    listPage = this.oppPages[iPageIndex];
                }
            }
            else if(selPanel == 'allAct' || selPanel == 'subRenNext'  || selPanel == 'subAccess'){
                if(this.subsPages.isEmpty() == false && iPageIndex >= 0 && iPageIndex <= NumOfPages) {
                    listPage = this.subsPages[iPageIndex];
                }
            }
            else if(selPanel == 'markActLast90'){
                if(this.markActPages.isEmpty() == false && iPageIndex >= 0 && iPageIndex <= NumOfPages) {
                    listPage = this.markActPages[iPageIndex];
                }
            }
            else if(selPanel == 'salesAct90'){
                if(this.salesActPages.isEmpty() == false && iPageIndex >= 0 && iPageIndex <= NumOfPages) {
                    listPage = this.salesActPages[iPageIndex];
                }
            }
            else{
            }
            return listPage;
        }
    
    }
    /*Pagination Code Ends***/
        
    //wrapper for history tracking data
    public class HistoryData{
        public String data1{get;set;}
        public String data2{get;set;}
        public String data3{get;set;}
        
        public HistoryData(){}
        
        public HistoryData(String data1, String data2, String data3){
            this.data1 = data1;
            this.data2 = data2;
            this.data3 = data3;
        }
    }

}