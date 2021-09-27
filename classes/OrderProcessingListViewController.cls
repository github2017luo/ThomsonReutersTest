/*
======================================================================================================================
CLASS NAME: OrderProcessingListViewController
======================================================================================================================
=
PURPOSE:    LEGACY CODE

CHANGE HISTORY:
======================================================================================================================
DATE              NAME                    DESC
2017-03-23        Meenakshmi Goswami      Optimized the code as per JIRA STORY: PS0-1
======================================================================================================================
*/
public class OrderProcessingListViewController{
    public List<wrapQuote> wrapQuoteList {get; set;}
/*public string strOppId{get;set;}
    public boolean boolQtErr{get;set;}    -- commented to reduce character for s2e optimization as this var is not in use */
    public List<Quote> selectedQuotes{get;set;}
    public string strSelectedFilter; 
    public List<SelectOption> SalesOrg {get;set;}
    public string selectedSalesORG{get; set;} //Contains Sales Org API Name
    public Boolean blnViewSalesOrg {get;set;} //Checks when to render Sales Org picklist   
    public String isColHeaderClick{get; set;} //Checks if header is clicked for sorting
    public Boolean isShowSortImage{get;set;} //Checks if sorting arrows to be displayed or not
    public String strFieldLabelName{get; set;} //Extract field label name from VF page
    public String strFieldLabel1 {get;set;} // Contains field label to set 'sortExp' && 'sortDirection'
    Public String strFieldLabel {get;set;}
    //Public List<Quote> quoteLst;
    public string getSelectedFilter(){
/*system.debug('***get called');-- commented to reduce character for s2e optimization */
        return strSelectedFilter;    
    }
    public void setSelectedFilter(string s){
/*system.debug('***Set called');-- commented to reduce character for s2e optimization */
        this.strSelectedFilter= s;        
    }
    public List<Schema.FieldSetMember> fsMemberLst;
/*    public string strfieldSetName{get;set;}
    public boolean boolShowAccept{get;set;}-- commented to reduce character for s2e optimization as this is not in use */
    public Quote q{ get; set; }
    String stringQuery;
    private String sortExp = ''; // Contains API Name by which Quotes to be sorted
    private String sortDirection = 'ASC NULLS FIRST'; // Contains direction(ASC/DESC) by which Quotes to be sorted
    String strFieldNameAssign = null; // Contains API name to set 'sortExp' && 'sortDirection'
    
    public Map<Decimal,List<wrapQuote>> mapPageToQuotes{get;set;}
    public Integer quotePageSize {get;set;}
    public Integer quoteListSize {get;set;}
    public Integer currentQuotePage{get;set;}
    public List<Integer> lstDisplayNumber {get;set;}
    
    public OrderProcessingListViewController(ApexPages.StandardController controller){
        // SelectedFilter =;
        // this.q= getQuoteList();
        isColHeaderClick = '';
        isShowSortImage = FALSE;  
        mapPageToQuotes = new Map<Decimal, List<wrapQuote>>();   
        currentQuotePage = 1;
        quotePageSize = Integer.valueOf(System.Label.Quote_Page_Size); // put it in custom label
        lstDisplayNumber = new List<Integer>();  
        //if(!Test.isRunningTest()){
           LoadData();
        //}
        receiveSalesOrg();
        /*s1 = 'SELECT Is_Mastered_Account__c, OP_Rejection_Date__c, Quote_Number__c, Quote_Name__c, Opportunity_Name__c, Account_Name_new__c, Sales_Category__c, Sales_Sub_Category__c, SAP_Quote_Number__c, SAP_Order_Number__c, OpportunityOwnerfullName__c, OP_Owner__c, Approved_Date_Time__c, TotalPrice, Business_Unit__c, Sales_Org__c, id FROM QUOTE Where op_owner__c = null AND status =\'Submitted for Processing\' AND opportunity.Oppty_Mgmt_Type__c <> NULL  AND(Sales_Org__c =\'RV01\' OR Sales_Org__c =\'TSL\' OR Sales_Org__c =\'FSCO\') ORDER BY Sales_Org__c ASC,Opportunity.Approved_Date_Time__c ASC';
        quoteLst = Database.query(s1);

        if(quoteLst != null && quoteLst.size() >0) {
            populateQuoteMap(quoteLst);
            calcDisplayPgNum(1);
        }
        else
            mapPageToQuotes.clear();*/
    }
    
    public PageReference Cancel(){
        return null;
    }
    
    public void LoadData(){
        strFieldLabel1 = null;
        wrapQuoteList = new List<wrapQuote>();
        List<Quote> quoteLst;
/*system.debug('**oppId' +oppId);-- commented to reduce character for s2e optimization */
        string strQuoteStatus = LatamGeneral__c.getInstance('Submitted for Processing').Value__c;
/*system.debug('***selectedFilter ::' +selectedFilter);-- commented to reduce character for s2e optimization */
        // Extracting API Name from Field Label for sorting
        String query='';
       // string strfieldSetName= OrderProcessingListView__c.getInstance(selectedFilter).ListView_FieldSet_Name__c;
        /*fsMemberLst= Schema.SObjectType.Quote.fieldSets.getMap().get(strfieldSetName).getFields(); 
            system.debug('****fsMemberLst'+fsMemberLst);
            for(Schema.FieldSetMember f : fsMemberLst) {
                query += f.getFieldPath() + ', ';
            }
            system.debug('****query '+query ); */
        String type='Quote';
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Schema.SObjectType leadSchema = schemaMap.get(type);
        Map<String, Schema.SObjectField> fieldMap = leadSchema.getDescribe().fields.getMap();
        for (String strFieldName: fieldMap.keySet()) {
/*System.debug('##Field API Name='+ strFieldName);// list of all field API name-- commented to reduce character for s2e optimization */
            strFieldLabel = fieldMap.get(strFieldName).getDescribe().getLabel();//Provides the object fields label.
            if(strFieldLabel == strFieldLabelName){
                //if(query.containsIgnoreCase(strFieldName)){
                    sortExp = strFieldName;
                    strFieldNameAssign = strFieldName;
/*System.debug('##strFieldLabel1 ='+ strFieldLabel1);
                    System.debug('##strFieldLabel ='+ strFieldLabel);-- commented to reduce character for s2e optimization */
                    strFieldLabel1 = strFieldLabel;
/*System.debug('##**strFieldLabel1 ='+ strFieldLabel1);-- commented to reduce character for s2e optimization */
                 // }
            }
            if(strFieldName=='OP_Owner__c' && sortExpression == 'OP_Owner__c'){
                sortExp = 'OP_Owner__r.FirstName';
                strFieldNameAssign = 'OP_Owner__r.FirstName'; 
            }
/*System.debug('##Field Labels='+ strFieldLabel);-- commented to reduce character for s2e optimization */
        }
       // if(Test.isRunningTest())                 --commented to increase code coverage
       //     quoteLst = getQuotes('TEST123');     --commented to increase code coverage
       // else{                                    --commented to increase code coverage
            if(strSelectedFilter== null){
              Map<String, OrderProcessingListView__c> mpAllCustomSttgs = OrderProcessingListView__c.getAll();
              for(OrderProcessingListView__c objOPL : mpAllCustomSttgs.values()) {
                  if(objOPL.Order__c == 1) {
                      strSelectedFilter= objOPL.Name;
                      break;
                  }
              }
              receiveSalesOrg();
              quoteLst = getQuotes(strSelectedFilter);
            }
            else{
                quoteLst = getQuotes(strSelectedFilter);
            }
        // }
        if(quoteLst != null && quoteLst.size() >0){
            populateQuoteMap(quoteLst);
            calcDisplayPgNum(1);
        }
        else
            mapPageToQuotes.clear();
        if(quoteLst != null && quoteLst.size() >0){
            for(List<wrapQuote> q: mapPageToQuotes.values()){
                // As each Quote is processed we create a new wrapQuote object and add it to the wrapQuoteList
                //wrapQuoteList.add(new wrapQuote(q, false));
                wrapQuoteList.addAll(q);
/*System.Debug('*******(mapPageToQuotes.get(currentQuotePage)='+mapPageToQuotes.values());
                System.Debug('*******currentQuotePage'+currentQuotePage);-- commented to reduce character for s2e optimization */
            }
/*system.debug('***test-oppId' + oppId);
            system.debug('***test- wrapQuoteList' + wrapQuoteList);-- commented to reduce character for s2e optimization */
        }
    }                
        
    // Loop through custom setting to get List View Names.
    public List<SelectOption> getFilters(){
        List<SelectOption> options = new List<SelectOption>();
        List<OrderProcessingListView__c> opViewLst= [SELECT Name,ListView_Query__c,ListView_FieldSet_Name__c,Order__c FROM OrderProcessingListView__c ORDER BY Order__c];
        if(opViewLst!= null && opViewLst.size() >0){
            for(OrderProcessingListView__c op:opViewLst){
                options.add(new SelectOption(op.Name,op.Name));            
            }
        }
        return options;
    }
    
    // Loop through custom setting to get List View Names.
    public Pagereference receiveSalesOrg(){
        //blnViewSalesOrg = false;
        SalesOrg = new List<SelectOption>();
        List<SelectOption> options = new List<SelectOption>();
        //To create Dependent picklist
        String sSalesORG = '';
        if(strSelectedFilter!= NULL && strSelectedFilter!= ''){
            if(strSelectedFilter== System.Label.Accept_Quotes_Brazil || strSelectedFilter== System.Label.Accept_Quotes_S_LatAm){
                sSalesORG = OrderProcessingListView__c.getInstance(strSelectedFilter).Sales_Org__c;
                blnViewSalesOrg = true;
            }
            else{
                blnViewSalesOrg = false;
            }
        }
        else{
            if(OrderProcessingListView__c.getInstance(System.Label.Accept_Quotes_Brazil).Order__c <> NULL && OrderProcessingListView__c.getInstance(System.Label.Accept_Quotes_Brazil).Order__c == 1){
                sSalesORG = OrderProcessingListView__c.getInstance(System.Label.Accept_Quotes_Brazil).Sales_Org__c;
                blnViewSalesOrg = true;
            }
            else if(OrderProcessingListView__c.getInstance(System.Label.Accept_Quotes_S_LatAm).Order__c <> NULL && OrderProcessingListView__c.getInstance(System.Label.Accept_Quotes_S_LatAm).Order__c == 1) {
                sSalesORG = OrderProcessingListView__c.getInstance(System.Label.Accept_Quotes_S_LatAm).Sales_Org__c;
                blnViewSalesOrg = true;
            }
            else{
                blnViewSalesOrg = false;
            }
        }
        for(String op : sSalesORG.split(',')){
            SalesOrg.add(new SelectOption(op, op));
        }
        selectedSalesORG = SalesOrg[0].getValue();
/*System.debug('*****SalesOrg='+SalesOrg);-- commented to reduce character for s2e optimization */
        return null;
    }

    // Used to process quotes after click of Accept button Assigen OP Owner to the selected quotes.
    public pageReference processSelected(){
        pageReference pagereference = null;
        selectedQuotes = new List<Quote>();
        for(wrapQuote wrapQuoteObj : wrapQuoteList){
           // if(!TEST.isRunningTest()){   commented as part of s2e optimization
                if(wrapQuoteObj.selected == true) {
                    selectedQuotes.add(wrapQuoteObj.QuoteRec);
                }
          //  }
          /*  else if(TEST.isRunningTest()){
                selectedQuotes.add(wrapQuoteObj.QuoteRec);                
            } */
        }
/*system.debug('******selectedQuotes='+selectedQuotes.size());-- commented to reduce character for s2e optimization */
        try {
            List<Quote> acceptQuotes= new List<Quote>();
            for(Quote q: selectedQuotes){
                if(q.OP_Owner__c != null ){
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,Label.acptQuoteNot));    //Added the hardcoded message in custom label as part of s2eOptimisation
                }
                else{
                    q.OP_Owner__c = UserInfo.getUserId();
                    acceptQuotes.add(q);
                }
            }
/*system.debug('******acceptQuotes='+acceptQuotes);-- commented to reduce character for s2e optimization */
            if(!acceptQuotes.isEmpty()){
                Update acceptQuotes;
            }
            LoadData();
            if(selectedQuotes!= null && selectedQuotes.size() ==1){
                PageReference pageRef = new PageReference('/'+selectedQuotes[0].id);
                return pageRef;
            }
            else{
                return null;
            }
        }
        catch(Exception ex){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMEssage()));
            return null;
        }
    }
    
    // Used to show teh list view results after clicking Go Button 
    public pageReference Go(){
/*system.debug('****SelectedFilter' +SelectedFilter);-- commented to reduce character for s2e optimization */
        isColHeaderClick = '';
        isShowSortImage = FALSE;
        LoadData();
        return null;
    }
    
    private list<Quote> getQuotes(string strListViewName){
        try{
/* system.debug('***strListViewName1::'+strListViewName);-- commented to reduce character for s2e optimization */
            string strQuoteStatus = LatamGeneral__c.getInstance('Submitted for Processing').Value__c;
/*system.debug('***strListViewName2::' + OrderProcessingListView__c.getInstance(strListViewName));-- commented to reduce character for s2e optimization */
            string strfieldSetName= OrderProcessingListView__c.getInstance(strListViewName).ListView_FieldSet_Name__c;
/*system.debug('***strListViewName3::'+strListViewName);-- commented to reduce character for s2e optimization */
            list<Quote> quoteList = new list<Quote>();
/*system.debug('***strfieldSetName::' + strfieldSetName);-- commented to reduce character for s2e optimization */
            stringQuery = 'SELECT ';
            fsMemberLst= Schema.SObjectType.Quote.fieldSets.getMap().get(strfieldSetName).getFields();
/*system.debug('****fsMemberLst'+fsMemberLst);-- commented to reduce character for s2e optimization */
            for(Schema.FieldSetMember f : fsMemberLst){
                stringQuery+= f.getFieldPath() + ', ';
            }
/*system.debug('****query '+query );-- commented to reduce character for s2e optimization */
            string strQuery= OrderProcessingListView__c.getInstance(strListViewName).ListView_Query__c;
            string strQuery1= OrderProcessingListView__c.getInstance(strListViewName).ListView_Query2__c;
            string strQuery2= OrderProcessingListView__c.getInstance(strListViewName).ListView_Query3__c;  //MCL-1944 
            string strQuery3= OrderProcessingListView__c.getInstance(strListViewName).ListView_Query4__c;  //MCL-2122 
            if(strQuery1 != null){
                 strQuery+=  ' ' + strQuery1;
            }
            if(strQuery2 != null){     //MCL-1944
                strQuery+=  ' ' + strQuery2;
             }  
            if(strQuery3 != null){     //MCL-2122
                strQuery+=  ' ' + strQuery3;
             }
/*system.debug('****strQuery::'+strQuery);-- commented to reduce character for s2e optimization */
            String sOrderBy = '';
            String strSubstring1 = '';
            integer index = strQuery.indexOfIgnoreCase('Order By');
            if(index != -1){
                sOrderBy = strQuery.substring(index, strQuery.length());
                strSubstring1 = strQuery.substring(0,index - 1);
            }
            else{
                strSubstring1 = strQuery.substring(0,strQuery.length());
            }
            if(sOrderBy.containsIgnoreCase('OP_Owner__c')){
/*system.debug('***//// strQuery' + sOrderBy);-- commented to reduce character for s2e optimization */
                sOrderBy = sOrderBy.toUpperCase();
                sOrderBy = sOrderBy.replaceAll('OP_OWNER__C','OP_Owner__r.FirstName');
/*system.debug('***//// sOrderBy ' + sOrderBy);-- commented to reduce character for s2e optimization */            
            }
            strQuery =  strSubstring1 + ' ' +  sOrderBy ;
/*system.debug('***//// strQuery' + strQuery);-- commented to reduce character for s2e optimization */
            string strUserId= UserInfo.getUserId();
/*system.debug('*** strUserId' + strUserId);-- commented to reduce character for s2e optimization */
            strQuery=strQuery.Replace('UserInfo.getUserId()', '\''+strUserId+'\'' );
/*system.debug('*** strQuery' + strQuery);
            system.debug('*** contais' + strQuery.containsIgnoreCase('OP_Owner__c')+ 'strQuery' + strQuery);-- commented to reduce character for s2e optimization */
            // For displaying quotes sorted by Sales Org
            if(strSelectedFilter== System.Label.Accept_Quotes_Brazil || strSelectedFilter== System.Label.Accept_Quotes_S_LatAm ){
/*system.debug('****selectedSalesORG' + selectedSalesORG);-- commented to reduce character for s2e optimization */
                strQuery = strSubstring1 + ' AND(';
                String strMulQuery = '';
                integer i;
                if(selectedSalesORG=='None'){
                        for(i=1;i<SalesOrg.size();i++){
                        if(i==SalesOrg.size()-1){
                            strMulQuery += 'Sales_Org__c =' + '\'' + SalesOrg.get(i).getValue() + '\'';
                        }
                        else{
                            strMulQuery += 'Sales_Org__c =' + '\'' + SalesOrg.get(i).getValue() + '\'' + ' ' + 'OR' + ' ';
                        }
                    }
                strQuery+= strMulQuery + ')' + ' ' + sOrderBy;
                }
                else{
                    strQuery = strSubstring1 + ' AND Sales_Org__c =' + '\'' + selectedSalesORG + '\'' + ' ' + sOrderBy;
                }
/*system.debug('****strQuery****' + strQuery);-- commented to reduce character for s2e optimization */
            }
            // For displaying quotes with default sorting
            if(index != -1){
                if(isColHeaderClick == ''){
                    String firstOrder = '';
                    if(sOrderBy.contains(',')){
                        firstOrder = sOrderBy.substring(0, sOrderBy.indexOfIgnoreCase(','));
                    }
                    if(firstOrder.toUpperCase().contains('ASC')){
                        setSortDirection('ASC NULLS FIRST');
                    }
                    else if(firstOrder.toUpperCase().contains('DESC')){
                        setSortDirection('DESC NULLS LAST');
                    }
                }
            }
            String sortFullExp = sortExpression  + ' ' + sortDirection;
/*system.debug('*** sortFullExp' + sortFullExp);-- commented to reduce character for s2e optimization */
            // For changing default sorting when header is clicked
            if(isColHeaderClick == '1'){
                isShowSortImage = TRUE;
                strQuery = strQuery.replace(sOrderBy, '');
            }
/*system.debug('*** contains' + strQuery);-- commented to reduce character for s2e optimization */
            if(!stringQuery.containsIgnoreCase('OP_Owner__c')){
/*system.debug('*** no op owner given');-- commented to reduce character for s2e optimization */   
                stringQuery+= 'op_Owner__c,id, QuoteNumber, Name, OpportunityId, Opportunity.Name, AccountId, Account.Name, Is_Mastered_Account__c FROM QUOTE ' + strQuery ;
            }
            else{
                stringQuery+= 'id, QuoteNumber,Name, OpportunityId, Opportunity.Name, AccountId, Account.Name, Is_Mastered_Account__c FROM QUOTE ' + strQuery ;
            }
            // For displaying quotes when header is clicked
            if(isColHeaderClick == '1'){
                stringQuery+= ' ORDER By ' + sortFullExp + ''  ;
            }
/*system.debug('***QuoteList:: '+query);-- commented to reduce character for s2e optimization */
            quoteList = Database.query(stringQuery);
            return quoteList;
        }Catch(Exception ex){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,Ex.getMessage()));
            return null;
        }
    }
    public List<Schema.FieldSetMember> getFields(){
        return fsMemberLst;
    }
    
    public String sortExpression{
        get{
/*system.debug('***sortExp:: '+sortExp);-- commented to reduce character for s2e optimization */
            return sortExp;
        }
        set{
            //if the column is clicked on then switch between Ascending and Descending modes
/*system.debug('***value:: '+value);    
            system.debug('***strFieldLabel1:: '+strFieldLabel1);
            system.debug('***strFieldLabel:: '+strFieldLabel);-- commented to reduce character for s2e optimization */
            if (value == strFieldLabel1){
/*system.debug('***value:: '+value);  
            system.debug('***strFieldLabel1:: '+strFieldLabel1);-- commented to reduce character for s2e optimization */  
                sortDirection = (sortDirection == 'ASC NULLS FIRST')? 'DESC NULLS LAST' : 'ASC NULLS FIRST';
            }
            else{
                sortDirection = 'ASC NULLS FIRST';
            }
            sortExp = strFieldNameAssign;
/*system.debug('***sortExp :: '+sortExp);-- commented to reduce character for s2e optimization */
        }
    }

    public String getSortDirection(){
        //if no column is selected
        if (sortExpression == null || sortExpression == ''){
            return 'ASC NULLS FIRST';
        }
        else{
            return sortDirection;
        }   
     }

    public void setSortDirection(String value){
        sortDirection = value;
    }
    

    private void populateQuoteMap(list<Quote> listQuote){
        mapPageToQuotes.clear();
        quotePageSize = Integer.valueOf(quotePageSize);
        quoteListSize = listQuote.size();
        try {
            List<wrapQuote> lstCurrent = new List<wrapQuote>();
            for(Integer i = 1; i <= listQuote.size(); i++){
                lstCurrent.add(new wrapQuote(listQuote[i-1], false));
                //if the counter has reached the map size or the total list size, add them to map and move to next page iteration
                if(math.mod(i, quotePageSize) == 0 || i == listQuote.size()){
                      Decimal t=i;
                      Decimal pageNumber = t / quotePageSize;
                      pageNumber = pageNumber.round(System.RoundingMode.CEILING);
                      mapPageToQuotes.put(pageNumber, lstCurrent);
                      lstCurrent=new List<wrapQuote>();
                }
            }
        }
        catch(Exception ex){
/*System.debug('Exception in class OrderProcessingListViewController in populateQuoteMap() = '+ex);-- commented to reduce character for s2e optimization */
        }
    }
    
    //Method to get the mapPageToQuotes currentPage size
    public Integer getCurrentQuotePageMapSize(){
        if(mapPageToQuotes.get(currentQuotePage) != null)
            return mapPageToQuotes.get(currentQuotePage).size();
        else
            return 0;
    }
    public Integer getQuoteMapSize(){
        if(mapPageToQuotes != null)
            return mapPageToQuotes.size();
        else
            return 0;
    }
    //Method to get the mapPageToQuotes.keySet size
    public Integer getQuoteMapKeySetSize(){
        if(mapPageToQuotes != null)
            return mapPageToQuotes.keySet().size();
        else
            return 0;
    }
    
    public void first(){
        currentQuotePage = 1;
        calcDisplayPgNum(currentQuotePage);
    }
    public void next(){
        currentQuotePage += 1;
        calcDisplayPgNum(currentQuotePage);
    }
    public void previous(){
        currentQuotePage -= 1;
        calcDisplayPgNum(currentQuotePage);
    }
    public void last(){
        currentQuotePage = mapPageToQuotes.size();
        calcDisplayPgNum(currentQuotePage);
    }
    
    private void calcDisplayPgNum(Integer p){
         Integer lastPgNum;
         lastPgNum = mapPageToQuotes.size();
         currentQuotePage = p;
         List<Integer> lstPageNumbers= new List<Integer>();
         LstDisplayNumber.clear();
         //rearrange the page numbers
         if(p==1) {
            lstPageNumbers =new List<Integer>{p,p+1,p+2,p+3,p+4};
         }
         else if(p==2){
             lstPageNumbers =new List<Integer>{p-1,p,p+1,p+2,p+3};
         }
         else if(p==lastPgNum-1){
             lstPageNumbers =new List<Integer>{p-3,p-2,p-1,p,p+1};
         }
         else if(p==lastPgNum){
             lstPageNumbers =new List<Integer>{p-4,p-3,p-2,p-1,p};
         }
         else{
             lstPageNumbers =new List<Integer>{p-2,p-1,p,p+1,p+2};
         }
         LstDisplayNumber.addAll(lstPageNumbers);
    }
    
    public class wrapQuote{
        public Quote quoteRec {get; set;}
        public Boolean selected {get; set;}
        public wrapQuote(Quote q, Boolean isChecked){
            quoteRec = q;
            selected = isChecked;
        }
    }
}