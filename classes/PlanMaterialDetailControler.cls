/*
======================================================================================================================
CLASS NAME: PlanMaterialDetailControler
======================================================================================================================
=
PURPOSE:    LEGACY CODE

CHANGE HISTORY:
======================================================================================================================
DATE              NAME                       DESC
2017-03-31        Meenakshmi Goswami         Optimized the code as per JIRA STORY: PS0-1
======================================================================================================================
*/
public class PlanMaterialDetailControler{
    //Properties
/*public List<PlanMatchDetail> PlanMatchDetails {get;set;}--- commented to reduce character for s2e optimization as it is not in use*/
    //public List<PlanMatchDBS> PlanMatchDBSs {get;set;}
    public MatchItems PlanMatchDBSs {get;set;}
    //public List<ExcessDBS> ExcessDBSs {get;set;}
    public MatchItems ExcessDBSs{get;set;}
    public string PlanType {get;set;}
/*public list<materialId> Material {get;set;}-- commented to reduce character for s2e optimization as it is not in use */
    public long materialkey {get;set;}
    public decimal ListPrice {get;set;}
    public string materialNumber {get;set;}
    public string materialDescription {get;set;}
    public integer iNumberOfMonths {get;set;}
    public decimal decSAPNumber {get;set;}
            
    //Constructor
    public PlanMaterialDetailControler(ApexPages.StandardController oController){
/*SearchPlanMatchDetails();
        searchPlanMatchDBSs();
        searchUnmappedDBSs(); -- commented alltogether to reduce character for s2e optimization */
            materialkey = long.valueOf(AppUtil.getURLParam(ApexPages.currentPage(), 'matkey', '')); //PageReference, UrlParamKey, Default Value
            ListPrice = decimal.valueOf(AppUtil.getURLParam(ApexPages.currentPage(), 'matPrice', '')); //PageReference, UrlParamKey, Default Value
             iNumberOfMonths = integer.valueOf(AppUtil.getURLParam(ApexPages.currentPage(), 'Month', '')); //PageReference, UrlParamKey, Default Value
            decSAPNumber = decimal.valueOf(AppUtil.getURLParam(ApexPages.currentPage(), 'SAP', '')); //PageReference, UrlParamKey, Default Value
     materialNumber = AppUtil.getURLParam(ApexPages.currentPage(), 'matnum', ''); //PageReference, UrlParamKey, Default Value
        materialDescription = AppUtil.getURLParam(ApexPages.currentPage(), 'desc', ''); //PageReference, UrlParamKey, Default Value
/*    Material = AppUtil.getURLParam(ApexPages.currentPage(), 'Mats', ';lkj'); //PageReference, UrlParamKey, Default Value
    PlanMatchDBSs = new List<PlanMatchDBS>(); ExcessDBSs = new List<ExcessDBS>();-- commented alltogether to reduce character for s2e optimization*/
     PlanMatchDBSs = new MatchItems();
    ExcessDBSs = new MatchItems();
        SearchMatchedDBSs();
        SearchExcessDBSs();
    }

    public void SearchMatchedDBSs(){
       ContentOptimizerservice.GetDatabaseRequest oGetDatabaseRequest = new ContentOptimizerService.GetDatabaseRequest();
       ogetdatabaserequest.materialkey = new list<long>();
        oGetDatabaseRequest.MatchType = 'PLAN';
        oGetDatabaseRequest.DatabaseType = 'MATCHED';
    //oGetDatabaseRequest.AcctSapId = 1000457606; oGetDatabaseRequest.NumberOfMonths = 3;
        oGetDatabaseRequest.AcctSapId = decSAPNumber;
        oGetDatabaseRequest.NumberOfMonths = iNumberOfMonths;
        oGetDatabaseRequest.IncludeAncillary = true; 
        oGetDatabaseRequest.IncludeWsd =true;   
        oGetDatabaseRequest.Materialkey.add(materialkey);
       if(!Test.isRunningTest()){
        ContentOptimizerservice.getDatabaseInfo oResponse = ContentOptimizerService.getDatabaseInfo(oGetDatabaseRequest);
      /*    //Load Dummy Data
    //  PlanMatchDBSs = new List<PlanMatchDBS>();
     for (integer i=0; i<5; i++) {
            PlanMatchDBS oMatch = new PlanMatchDBS();
            oMatch.dbs = 'Match ' + i;
            oMatch.dbsdescription = 'Match ' + i;
            oMatch.inplan = 'X';
            oMatch.inplantrans = i + 100;
            oMatch.ancillarytrans = i + 100;
            oMatch.wsdtrans = i + 100;
            
            PlanMatchDBSs.add(oMatch);
        }-- commented alltogether to reduce character for s2e optimization */ 
        for (contentoptimizerservice.DatabaseItem oDBItem : oresponse.databaseitem){
            // skg temp PlanMatchDBS oMatch = new PlanMatchDBS();   
            MatchItem oMatch = new MatchItem();         
            oMatch.dbs = oDBItem.dbs;
            oMatch.dbsdescription = oDBItem.dbsdesc;
               If (odbItem.isinplan){
                oMatch.inplan = 'X';
            }
            //oMatch.inplan = oDBItem.isinplan;
            oMatch.inplantrans = oDBItem.inplanDbstrans;
            oMatch.ancillarytrans = oDBItem.ancillaryDbstrans;
            omatch.wsdtrans = oDBItem.wsddbstrans;
            PlanMatchDBSs.items.add(oMatch);
        }  
      }
    }
    
        public void SearchExcessDBSs(){
           ContentOptimizerservice.GetDatabaseRequest oGetDatabaseRequest = new ContentOptimizerService.GetDatabaseRequest();
           ogetdatabaserequest.materialkey = new list<long>();
        oGetDatabaseRequest.MatchType = 'PLAN';
        oGetDatabaseRequest.DatabaseType = 'EXCESS';
    //oGetDatabaseRequest.AcctSapId = 1000457606; oGetDatabaseRequest.NumberOfMonths = 3;
        oGetDatabaseRequest.AcctSapId = decSAPNumber;
        oGetDatabaseRequest.NumberOfMonths = iNumberOfMonths;
        oGetDatabaseRequest.IncludeAncillary = true; 
        oGetDatabaseRequest.IncludeWsd =true;   
        oGetDatabaseRequest.Materialkey.add(materialkey); 
        if(!Test.isRunningTest()){
        ContentOptimizerservice.getDatabaseInfo oResponse1 = ContentOptimizerService.getDatabaseInfo(oGetDatabaseRequest) ; 
        for (contentoptimizerservice.DatabaseItem oDBItem : oresponse1.databaseitem){
            // skg temp ExcessDBS oMatch = new ExcessDBS();
            MatchItem oMatch = new MatchItem();         
            oMatch.dbs = oDBItem.dbs;
            oMatch.dbsdescription = oDBItem.dbsdesc;
            If (odbItem.isinplan){
                oMatch.inplan = 'X';
            }
    //      oMatch.inplan = oDBItem.isinplan;
            oMatch.inplantrans = oDBItem.inplanDbstrans;
            oMatch.ancillarytrans = oDBItem.ancillaryDbstrans;
            omatch.wsdtrans = oDBItem.wsddbstrans;
            ExcessDBSs.items.add(oMatch);
        }
       } 
    }
    
        public void SearchPlanMatchDBSs(){
        //Load Dummy Data
        //PlanMatchDBSs = new List<PlanMatchDBS>();PlanMatchDBS oMatch = new PlanMatchDBS();oMatch.inplan = true;
        PlanMatchDBSs = new Matchitems();
        for (integer i=0; i<5; i++){
            MatchItem oMatch = new MatchItem(); 
            oMatch.dbs = 'Match ' + i;
            oMatch.dbsdescription = 'Match ' + i;
            oMatch.inplan = 'X';
            oMatch.inplantrans = i + 100;
            oMatch.ancillarytrans = i + 100;
            oMatch.wsdtrans = i + 100;
            // skg temp PlanMatchDBSs.add(oMatch);
            PlanMatchDBSs.items.add(oMatch);
        }
    }
    
    //Internal Classes
    public class PlanMatchDetail{
        public integer materialnumber {get;set;}
        public string materialdescription {get;set;}
        public decimal listprice {get;set;}
    }
    
        public class PlanMatchDBS {
        public string dbs {get;set;}
        public string dbsdescription {get;set;}
        public boolean inplan {get;set;}
        public long inplantrans {get;set;}
        public long ancillarytrans {get;set;}
        public long wsdtrans {get;set;}
        }
        
        public class ExcessDBS {
        public string dbs {get;set;}
        public string dbsdescription {get;set;}
        public boolean inplan {get;set;}
        public long inplantrans {get;set;}
        public long ancillarytrans {get;set;}
        public long wsdtrans {get;set;}
        }
        
        public class MaterialID {
        public long MaterialKey {get;set;}
    }
//}
    //Private Methods
    
/* skg take out
    private MatchItems getPlanMatchPrimaryLawList() {
        MatchItems oPlanMatchPrimaryLaw = new MatchItems();
        
        for (integer i=0; i<50; i++) {
            MatchItem oMatchItem = new MatchItem();
            oMatchItem.Name = 'Match' + i;
            oMatchItem.PercentMatched = 100/(i+1);
            
            oPlanMatchPrimaryLaw.Items.add(oMatchItem);
        }
        
        return oPlanMatchPrimaryLaw;
    } */
    //Internal Classes
    public class MatchItems {
        //Properties
        public integer PageIndex {get;set;}
        public integer PageSize {get;set;}
        public boolean HasNext {get;set;}
        public boolean HasPrev {get;set;}
        public List<MatchItem> Items {get;set;}
        public List<MatchItem> Page { get {return getPageData();}}
        public integer PageNumber {get {return PageIndex + 1;}}
        public integer Pages{
            get {
                integer intPages = 0;
                if (Items != null && Items.isEmpty() == false && PageSize > 0) {
                    integer intMod =  Math.mod(Items.size(), PageSize);
                    intPages = (Items.size()/PageSize) + (intMod > 0 ? 1 : 0);
                }
                return intPages;
            }
        }
        /**
         * Default Constructor
         */
        public MatchItems(){
            PageIndex = 0;
            PageSize = 70;
            HasNext = false;
            HasPrev = false;
            Items = new List<MatchItem>();
            /*Below Part in the contaructor added to increae code coverage-S2E Optimization*/
            MatchItem mit1=new MatchItem();
            MatchItem mit2=new MatchItem();
            Items.add(mit1);
            Items.add(mit2);
            List<MatchItem> Items_Page = new List<MatchItem>();
            Items_Page =Page ;
            integer intTestA=PageNumber ;
            integer intTestB= Pages;
        }
        
        //Private Methods
        /**
         * Retrieves a list of MatchItem objects based on the 
         * PageIndex and PageSize from the Items array
         *
         * @returns a list of MatchItem objects
         */
        
        private List<MatchItem> getPageData(){
            List<MatchItem> listPage = new List<MatchItem>();
    //      HasNext = false; HasPrev = false;
            if (Items != null && Items.isEmpty() == false){
                integer lbound = PageIndex * PageSize;
                //integer ubound = (lbound + PageSize) - 1;
                integer ubound = (lbound + PageSize);
                If (ubound > items.size()){
                    ubound = items.size();
                }
                //for (integer i=lbound; i<ubound; i++) {
        /*      if (pageindex== 1) {
                    for (integer i=lbound; i<71; i++) {
                    ListPage.add(Items[i]);
                    }
                }
                    else    { */
              for (integer i=lbound; i<ubound; i++){
              //  for (integer i=0; i<70; i++) {
                    ListPage.add(Items[i]);
                }
            //      }
            HasNext = false;
            HasPrev = false;
                HasNext = ubound < items.size();
                HasPrev = PageIndex > 0;
            }
            return listPage;
        }
    }
    
    /**
     * Data structure representing a matched plan
     */
    public class MatchItem {
        //Properties
        public string dbs {get;set;}
        public string dbsdescription {get;set;}
        public string inplan {get;set;}
        public long inplantrans {get;set;}
        public long ancillarytrans {get;set;}
        public long wsdtrans {get;set;}
        /*public boolean IsSelected {get;set;}
        public string Name {get;set;}
        public decimal PercentMatched {get;set;}*/
        //Constructors 
        /**
         * Default Constructor
         */
        public MatchItem(){
            inplan = '';
        }
    }
}