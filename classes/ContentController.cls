/*
======================================================================================================================
CLASS NAME:    ContentController
======================================================================================================================
=
PURPOSE:    LEGACY CODE

CHANGE HISTORY:
======================================================================================================================
DATE              NAME                    DESC
2017-03-31        Meenakshmi Goswami      Optimized the code as per JIRA STORY: PS0-1
======================================================================================================================
*/
public with sharing class ContentController {
    //Properties
    public List<Content> PlanPublicContents {get;set;}
    public List<Content> PlanPrimaryContents {get;set;}
    public List<Content> PlanOtherContents {get;set;}
    public List<Content> UsagePublicContents {get;set;}
    public List<Content> UsagePrimaryContents {get;set;}
    public List<Content> UsageOtherContents {get;set;}
    public List<Content> KnownPublicContents {get;set;}
    public List<Content> KnownPrimaryContents {get;set;}
    public List<Content> KnownOtherContents {get;set;}
    public List<Content> PlanUsagePublicContents {get;set;}
    public List<Content> PlanUsagePrimaryContents {get;set;}
    public List<Content> PlanUsageOtherContents {get;set;}
    public List<Content> TotalPublicContents {get;set;}
    public List<Content> TotalPrimaryContents {get;set;}
    public List<Content> TotalOtherContents {get;set;}
    public List<Content> Contents {get;set;}
    public string sSAPSearchParm {get;set;}
    public string SearchText {get;set;}
    public string SearchMonths {get;set;}
    public integer SearchMonths2 {get;set;}
    public string accountid {get;set;}
    public decimal PercentExcess{get;set;}
    public decimal PercentMatch{get;set;}
    public string sType {get;set;}
    public list<long> tempmaterialkeys {get;set;}
    public decimal dSAPAccountNumber {get;set;}
    public string sCurrentTab {get;set;}
    private Account oAccount;
    public string sState {get;set;}
    public PageReference pageReftmp {get;set;}
    public boolean bRendered {get;set;}
    // from plandetailcontroller
    public List<PlanMatchDetail> PlanMatchDetails {get;set;}
    public MatchItems PlanMatchDBSs {get;set;}
    public MatchItems UnmappedDBSs {get;set;}
    public MatchItems ExcessDBSs {get;set;}
    public string PlanType {get;set;}
    public boolean bIncludeAncillary {get;set;}
    public boolean bIncludeWsd {get;set;}
    public list<Content> MaterialsSelected {get;set;}
    public list<long> ListMaterialkeys {get;set;}
    public Id IdAccountId{get;set;}
    //public string IdAccountId{get;set;}
    public long LMaterialKey {get;set;}
    //public string LMaterialKey {get;set;}
    public string strMaterialNumber{get;set;}
    public string strMaterialDesc {get;set;}
    public decimal decListPrice {get;set;}
    
    public class MyException extends Exception {}
     
     // for checkbox
     public Boolean selectAllCheckbox {get; set;}
     //end for checkbox
    
    //Constructor
    public ContentController(ApexPages.StandardController oController){
        try {
/*system.debug('Begin Controller ');
            system.debug('skg');-- commented to reduce character for s2e optimization */
            Contents = new List<Content>();
            PlanPublicContents = new List<Content>();
            PlanOtherContents = new List<Content>();
            UsagePublicContents = new List<Content>();
            UsageOtherContents = new List<Content>();
            KnownPublicContents = new List<Content>();
            KnownPrimaryContents = new List<Content>();
            KnownOtherContents = new List<Content>();
            PlanUsagePublicContents = new List<Content>();
            PlanUsagePrimaryContents = new List<Content>();
            PlanUsageOtherContents = new List<Content>();
            TotalPublicContents = new List<Content>();
            TotalPrimaryContents = new List<Content>();
            TotalOtherContents = new List<Content>();
            dSAPAccountNumber = 0;
            PlanPublicContents = null;
            PlanPrimaryContents = null; 
            PlanOtherContents = null;   
            UsagePublicContents = null;
            UsagePrimaryContents = null;    
            UsageOtherContents = null;  
            KnownPublicContents = null;
            KnownPrimaryContents = null;    
            KnownOtherContents = null;
            PlanUsagePublicContents = null;
            PlanUsagePrimaryContents = null;    
            PlanUsageOtherContents = null;  
            TotalPublicContents = null;
            TotalPrimaryContents = null;    
            TotalOtherContents = null;
            bRendered = true;
            SearchMonths2 = integer.valueof(AppUtil.getURLParam(ApexPages.currentPage(), 'mo', '3')); //PageReference, UrlParamKey, Default Value
            searchMonths = AppUtil.getURLParam(ApexPages.currentPage(), 'mo', '3');
            sSAPSearchParm = AppUtil.getURLParam(ApexPages.currentPage(), 'SAP', ''); //PageReference, UrlParamKey, Default Value
            if ((sSAPSearchParm == '') || (sSAPSearchParm == null)){
              sSAPSearchParm = null;
            }
            else{
                dSAPAccountNumber = decimal.valueof(sSAPSearchParm.trim());
            }                       
            oAccount = (Account) oController.getRecord();   
            /*If (AppUtil.isempty(oAccount)) {
                ApexPages.Message oMessage = new ApexPages.Message(ApexPages.Severity.ERROR, 'Customer is not in SFDC');
                ApexPages.addMessage(oMessage);
            }
            else {
            */
            if (oAccount.Id != null && AppUtil.isEmpty(SearchMonths) == false){
                ContentOptimizerService oContentOptimizerService = new ContentOptimizerService(); 
                ContentOptimizerservice.CustomerInfo oResponse = ContentOptimizerService.getcustomerinfo(dSAPAccountNumber,true) ;
                if (oresponse.state != null){
                  sState = oresponse.state;
                  sState = sState.trim();
                  dSAPAccountNumber = oresponse.ZwAcctSapId;
                }
                else{
                    ApexPages.Message oMessage = new ApexPages.Message(ApexPages.Severity.ERROR, 'Customer is not a valid Content tool customer');
                    ApexPages.addMessage(oMessage);
                }
            }
            //}
            /*if (sstate == null || sstate == '') {
                ApexPages.Message oMessage = new ApexPages.Message(ApexPages.Severity.FATAL, 'Customer is not a valid Content tool customer with a state');
                ApexPages.addMessage(oMessage);
            }*/                            
/*system.debug('customer state = ' + sstate);
            system.debug('skg');-- commented to reduce character for s2e optimization */
// from plan detail controller
            PlanMatchDetails = new List<PlanMatchDetail>();
            PlanMatchDBSs = new MatchItems();
            unmappedDBSs = new MatchItems();
            ExcessDBSs = new MatchItems();
            oAccount = (Account) oController.getRecord();                             
        }
        catch (CalloutException oException) {ApexPages.addMessages(oException);} 
        catch (MyException oException) {ApexPages.addMessages(oException);}
        catch (Exception oException) {ApexPages.addMessages(oException);}
    }
    
//Private Methods
    Public List<Content> getUsageData(){
        UsagePublicContents = new List<Content>();
        UsagePrimaryContents = new List<Content>();
        UsageOtherContents = new List<Content>();          
        //Make your web service call and populate listMyObject variable
        ContentOptimizerservice.CalculateMatchRequest oCalculateMatchRequest = new ContentOptimizerService.CalculateMatchRequest();
        oCalculateMatchRequest.MatchType = 'USAGE';
        oCalculateMatchRequest.AcctSapId = dSAPAccountNumber;
        //oCalculateMatchRequest.AcctSapId = 1000457606;
        //oCalculateMatchRequest.ExcessThresholdPercent = 100;
        //oCalculateMatchRequest.State = 'NY';
        if (sstate == null || sstate == ''){
            throw new MyException(dsapaccountNumber + ' is not in the Content tool Database');
        }
        oCalculateMatchRequest.State = sState;
        //oCalculateMatchRequest.NumberOfMonths = 12;
        oCalculateMatchRequest.NumberOfMonths = searchmonths2;
        oCalculateMatchRequest.IncludeAncillary = true;
        oCalculateMatchRequest.IncludeWsd = false;
        ContentOptimizerservice.MaterialPlanInfo oUsageResponse = ContentOptimizerService.getMaterialPlanInfo(oCalculateMatchRequest) ;
        for (ContentOptimizerservice.MaterialItem oPlanMaterialItem : oUsageResponse.PrimaryMaterials){
            Content oCntnt = new Content();
            oCntnt.MaterialNumber = oPlanMaterialItem.MaterialNumber;
            oCntnt.Material = oPlanMaterialItem.MaterialDesc;
            oCntnt.PercentMatch = oPlanMaterialItem.MatchPercent;
            oCntnt.PercentExcess = oPlanMaterialItem.ExcessPercent;
            oCntnt.ListPrice = oPlanMaterialItem.ListPrice; 
            oCntnt.materialkey = oPlanmaterialItem.MaterialKey;
            UsagePrimaryContents.add(oCntnt);
        }
        for (ContentOptimizerservice.MaterialItem oPlanMaterialItem : oUsageResponse.PublicMaterials){
            Content oCntnt = new Content();
            oCntnt.MaterialNumber = oPlanMaterialItem.MaterialNumber;
            oCntnt.Material = oPlanMaterialItem.MaterialDesc;
            oCntnt.PercentMatch = oPlanMaterialItem.MatchPercent;
            oCntnt.PercentExcess = oPlanMaterialItem.ExcessPercent;
            oCntnt.ListPrice = oPlanMaterialItem.ListPrice;
            oCntnt.materialkey = oPlanmaterialItem.MaterialKey;
            UsagePublicContents.add(oCntnt);
        }
        
        for (ContentOptimizerservice.MaterialItem oPlanMaterialItem : oUsageResponse.OtherMaterials){
            Content oCntnt = new Content();
            oCntnt.MaterialNumber = oPlanMaterialItem.MaterialNumber;
            oCntnt.Material = oPlanMaterialItem.MaterialDesc;
            oCntnt.PercentMatch = oPlanMaterialItem.MatchPercent;
            oCntnt.PercentExcess = oPlanMaterialItem.ExcessPercent;
            oCntnt.ListPrice = oPlanMaterialItem.ListPrice;
            oCntnt.materialkey = oPlanmaterialItem.MaterialKey;
            UsageOtherContents.add(oCntnt);
        }  
        return UsagePrimaryContents;
    }


Private List<Content> getPlanMatchData(){
    PlanPublicContents = new List<Content>();
    PlanPrimaryContents = new List<Content>();
    PlanOtherContents = new List<Content>();
 //try{         
    ContentOptimizerservice.CalculateMatchRequest oCalculateMatchRequest = new ContentOptimizerService.CalculateMatchRequest();
    oCalculateMatchRequest.MatchType = 'PLAN';
    oCalculateMatchRequest.AcctSapId = dSAPAccountNumber;
    //oCalculateMatchRequest.AcctSapId = 1000457606;
    oCalculateMatchRequest.ExcessThresholdPercent = 100;
    //oCalculateMatchRequest.State = 'TX';
    //   throw new MyException('test Message');
    if (sstate == null || sstate == ''){
          // if (sstate != 'BB') {
        throw new MyException(dsapaccountNumber + ' is not in the Content tool Database');
        //ApexPages.Message oMessage = new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Customer is not a valid Content tool customer with a state');
        // ApexPages.addMessage(oMessage);
    }  
    oCalculateMatchRequest.State = sState;
    //oCalculateMatchRequest.NumberOfMonths = 12;
    oCalculateMatchRequest.NumberOfMonths = searchMonths2;
    oCalculateMatchRequest.ExcessThresholdPercent =100; 
    oCalculateMatchRequest.IncludeAncillary = false;
    oCalculateMatchRequest.IncludeWsd =false;
    ContentOptimizerservice.MaterialPlanInfo oPlanResponse = ContentOptimizerService.getMaterialPlanInfo(oCalculateMatchRequest) ;
    //          system.debug('getplanmatchdataprimary = ' + oPlanResponse.PrimaryMaterials.size());
    //  system.debug('skg');
        for (ContentOptimizerservice.MaterialItem oPlanMaterialItem : oPlanResponse.PrimaryMaterials){
            Content oCntnt = new Content();
            oCntnt.MaterialNumber = oPlanMaterialItem.MaterialNumber;
            oCntnt.Material = oPlanMaterialItem.MaterialDesc;
            oCntnt.PercentMatch = oPlanMaterialItem.MatchPercent;
            oCntnt.PercentExcess = oPlanMaterialItem.ExcessPercent;
            oCntnt.ListPrice = oPlanMaterialItem.ListPrice; 
            oCntnt.materialkey = oPlanmaterialItem.MaterialKey;
            PlanPrimaryContents.add(oCntnt);
        }
    //system.debug('getplanmatchdatapublic = ' + oPlanResponse.PublicMaterials.size());
    //  system.debug('skg');
           for (ContentOptimizerservice.MaterialItem oPlanMaterialItem : oPlanResponse.PublicMaterials){
            Content oCntnt = new Content();
            oCntnt.MaterialNumber = oPlanMaterialItem.MaterialNumber;
            oCntnt.Material = oPlanMaterialItem.MaterialDesc;
            oCntnt.PercentMatch = oPlanMaterialItem.MatchPercent;
            oCntnt.PercentExcess = oPlanMaterialItem.ExcessPercent;
            oCntnt.ListPrice = oPlanMaterialItem.ListPrice;
            oCntnt.materialkey = oPlanmaterialItem.MaterialKey;
            PlanPublicContents.add(oCntnt);
        } //system.debug('getplanmatchdataother = ' + oPlanResponse.otherMaterials.size());
    //  system.debug('skg');
           for (ContentOptimizerservice.MaterialItem oPlanMaterialItem : oPlanResponse.OtherMaterials){
            Content oCntnt = new Content();
            oCntnt.MaterialNumber = oPlanMaterialItem.MaterialNumber;
            oCntnt.Material = oPlanMaterialItem.MaterialDesc;
            oCntnt.PercentMatch = oPlanMaterialItem.MatchPercent;
            oCntnt.PercentExcess = oPlanMaterialItem.ExcessPercent;
            oCntnt.ListPrice = oPlanMaterialItem.ListPrice; 
            oCntnt.materialkey = oPlanmaterialItem.MaterialKey;
            PlanOtherContents.add(oCntnt);
        }
          return PlanPrimaryContents;
   }
   
       private List<Content> getKnownData(){
            KnownPublicContents = new List<Content>();
            KnownPrimaryContents = new List<Content>();
            KnownOtherContents = new List<Content>();
          ContentOptimizerservice.CalculateMatchRequest oCalculateMatchRequest = new ContentOptimizerService.CalculateMatchRequest();
            oCalculateMatchRequest.MatchType = 'USAGE';
oCalculateMatchRequest.AcctSapId = dSAPAccountNumber;
//oCalculateMatchRequest.AcctSapId = 1000457606;
oCalculateMatchRequest.ExcessThresholdPercent = 100;
//oCalculateMatchRequest.State = 'TX';
            if (sstate == null || sstate == ''){
              throw new MyException(dsapaccountNumber + ' is not in the Content tool Database');
         }
oCalculateMatchRequest.State = sState;
//oCalculateMatchRequest.NumberOfMonths = 12;
oCalculateMatchRequest.NumberOfMonths = searchMonths2;
oCalculateMatchRequest.ExcessThresholdPercent =100; 
oCalculateMatchRequest.IncludeAncillary = true;
oCalculateMatchRequest.IncludeWsd =true;
    ContentOptimizerservice.MaterialPlanInfo oKnownResponse = ContentOptimizerService.getMaterialPlanInfo(oCalculateMatchRequest) ;
        for (ContentOptimizerservice.MaterialItem oPlanMaterialItem : oKnownResponse.PrimaryMaterials){
            Content oCntnt = new Content();
            oCntnt.MaterialNumber = oPlanMaterialItem.MaterialNumber;
            oCntnt.Material = oPlanMaterialItem.MaterialDesc;
            oCntnt.PercentMatch = oPlanMaterialItem.MatchPercent;
            oCntnt.PercentExcess = oPlanMaterialItem.ExcessPercent;
            oCntnt.ListPrice = oPlanMaterialItem.ListPrice;
            oCntnt.materialkey = oPlanmaterialItem.MaterialKey;
            KnownPrimaryContents.add(oCntnt);
        }
            for (ContentOptimizerservice.MaterialItem oPlanMaterialItem : oKnownResponse.PublicMaterials){
            Content oCntnt = new Content();
            oCntnt.MaterialNumber = oPlanMaterialItem.MaterialNumber;
            oCntnt.Material = oPlanMaterialItem.MaterialDesc;
            oCntnt.PercentMatch = oPlanMaterialItem.MatchPercent;
            oCntnt.PercentExcess = oPlanMaterialItem.ExcessPercent;
            oCntnt.ListPrice = oPlanMaterialItem.ListPrice;
            oCntnt.materialkey = oPlanmaterialItem.MaterialKey;
            KnownPublicContents.add(oCntnt);
        }
           for (ContentOptimizerservice.MaterialItem oPlanMaterialItem : oKnownResponse.OtherMaterials){
            Content oCntnt = new Content();
            oCntnt.MaterialNumber = oPlanMaterialItem.MaterialNumber;
            oCntnt.Material = oPlanMaterialItem.MaterialDesc;
            oCntnt.PercentMatch = oPlanMaterialItem.MatchPercent;
            oCntnt.PercentExcess = oPlanMaterialItem.ExcessPercent;
            oCntnt.ListPrice = oPlanMaterialItem.ListPrice; 
            oCntnt.materialkey = oPlanmaterialItem.MaterialKey;
            KnownOtherContents.add(oCntnt);
        }
          return KnownPrimaryContents;
    }


       private List<Content> getPlanUsageData(){
           PlanUsagePublicContents = new List<Content>();
           PlanUsagePrimaryContents = new List<Content>();
           PlanUsageOtherContents = new List<Content>();
          ContentOptimizerservice.CalculateMatchRequest oCalculateMatchRequest = new ContentOptimizerService.CalculateMatchRequest();
          oCalculateMatchRequest.MatchType = 'PLAN';
          oCalculateMatchRequest.AcctSapId = dSAPAccountNumber; //oCalculateMatchRequest.AcctSapId = 1000457606;
          oCalculateMatchRequest.ExcessThresholdPercent = 100; //oCalculateMatchRequest.State = 'TX';
            if (sstate == null || sstate == ''){
               throw new MyException(dsapaccountNumber + ' is not in the Content tool Database');
        }  
        oCalculateMatchRequest.State = sState; //oCalculateMatchRequest.NumberOfMonths = 12;
        oCalculateMatchRequest.NumberOfMonths = searchMonths2;
        oCalculateMatchRequest.ExcessThresholdPercent =100; 
        oCalculateMatchRequest.IncludeAncillary = true;
        oCalculateMatchRequest.IncludeWsd =false;
        ContentOptimizerservice.MaterialPlanInfo oPlanUsageResponse = ContentOptimizerService.getMaterialPlanInfo(oCalculateMatchRequest) ;
        for (ContentOptimizerservice.MaterialItem oPlanMaterialItem : oPlanUsageResponse.PrimaryMaterials){
            Content oCntnt = new Content();
            oCntnt.MaterialNumber = oPlanMaterialItem.MaterialNumber;
            oCntnt.Material = oPlanMaterialItem.MaterialDesc;
            oCntnt.PercentMatch = oPlanMaterialItem.MatchPercent;
            oCntnt.PercentExcess = oPlanMaterialItem.ExcessPercent;
            oCntnt.ListPrice = oPlanMaterialItem.ListPrice; 
            oCntnt.materialkey = oPlanmaterialItem.MaterialKey;
            PlanUsagePrimaryContents.add(oCntnt);
        }
           for (ContentOptimizerservice.MaterialItem oPlanMaterialItem : oPlanUsageResponse.PublicMaterials){
            Content oCntnt = new Content();
            oCntnt.MaterialNumber = oPlanMaterialItem.MaterialNumber;
            oCntnt.Material = oPlanMaterialItem.MaterialDesc;
            oCntnt.PercentMatch = oPlanMaterialItem.MatchPercent;
            oCntnt.PercentExcess = oPlanMaterialItem.ExcessPercent;
            oCntnt.ListPrice = oPlanMaterialItem.ListPrice;
            oCntnt.materialkey = oPlanmaterialItem.MaterialKey;
            PlanUsagePublicContents.add(oCntnt);
        }
            for (ContentOptimizerservice.MaterialItem oPlanMaterialItem : oPlanUsageResponse.OtherMaterials){
            Content oCntnt = new Content();
            oCntnt.MaterialNumber = oPlanMaterialItem.MaterialNumber;
            oCntnt.Material = oPlanMaterialItem.MaterialDesc;
            oCntnt.PercentMatch = oPlanMaterialItem.MatchPercent;
            oCntnt.PercentExcess = oPlanMaterialItem.ExcessPercent;
            oCntnt.ListPrice = oPlanMaterialItem.ListPrice; 
            oCntnt.materialkey = oPlanmaterialItem.MaterialKey;
            PlanUsageOtherContents.add(oCntnt);
        }
          return PlanUsagePrimaryContents;
  }

       private List<Content> getTotalData(){
            TotalPublicContents = new List<Content>();
            TotalPrimaryContents = new List<Content>();
            TotalOtherContents = new List<Content>();
          ContentOptimizerservice.CalculateMatchRequest oCalculateMatchRequest = new ContentOptimizerService.CalculateMatchRequest();
          oCalculateMatchRequest.MatchType = 'PLAN';
oCalculateMatchRequest.AcctSapId = dSAPAccountNumber; //oCalculateMatchRequest.AcctSapId = 1000457606;
oCalculateMatchRequest.ExcessThresholdPercent = 100; //oCalculateMatchRequest.State = 'TX';
            if (sstate == null || sstate == ''){
               throw new MyException(dsapaccountNumber + ' is not in the Content tool Database');
            }  
oCalculateMatchRequest.State = sState;//oCalculateMatchRequest.NumberOfMonths = 12;
oCalculateMatchRequest.NumberOfMonths = searchMonths2;
oCalculateMatchRequest.ExcessThresholdPercent =100; 
oCalculateMatchRequest.IncludeAncillary = true;
oCalculateMatchRequest.IncludeWsd =true;
    ContentOptimizerservice.MaterialPlanInfo oTotalResponse = ContentOptimizerService.getMaterialPlanInfo(oCalculateMatchRequest) ;
        for (ContentOptimizerservice.MaterialItem oPlanMaterialItem : oTotalResponse.PrimaryMaterials){
            Content oCntnt = new Content();
            oCntnt.MaterialNumber = oPlanMaterialItem.MaterialNumber;
            oCntnt.Material = oPlanMaterialItem.MaterialDesc;
            oCntnt.PercentMatch = oPlanMaterialItem.MatchPercent;
            oCntnt.PercentExcess = oPlanMaterialItem.ExcessPercent;
            oCntnt.ListPrice = oPlanMaterialItem.ListPrice;
            oCntnt.materialkey = oPlanmaterialItem.MaterialKey;
            TotalPrimaryContents.add(oCntnt);
        }
           for (ContentOptimizerservice.MaterialItem oPlanMaterialItem : oTotalResponse.PublicMaterials){
            Content oCntnt = new Content();
            oCntnt.MaterialNumber = oPlanMaterialItem.MaterialNumber;
            oCntnt.Material = oPlanMaterialItem.MaterialDesc;
            oCntnt.PercentMatch = oPlanMaterialItem.MatchPercent;
            oCntnt.PercentExcess = oPlanMaterialItem.ExcessPercent;
            oCntnt.ListPrice = oPlanMaterialItem.ListPrice;
            oCntnt.materialkey = oPlanmaterialItem.MaterialKey;
            TotalPublicContents.add(oCntnt);
        }
        for (ContentOptimizerservice.MaterialItem oPlanMaterialItem : oTotalResponse.OtherMaterials){
            Content oCntnt = new Content();
            oCntnt.MaterialNumber = oPlanMaterialItem.MaterialNumber;
            oCntnt.Material = oPlanMaterialItem.MaterialDesc;
            oCntnt.PercentMatch = oPlanMaterialItem.MatchPercent;
            oCntnt.PercentExcess = oPlanMaterialItem.ExcessPercent;
            oCntnt.ListPrice = oPlanMaterialItem.ListPrice; 
            oCntnt.materialkey = oPlanmaterialItem.MaterialKey;
            TotalOtherContents.add(oCntnt);
        }        
          return TotalPrimaryContents;
   }

    public void lazyLoadPlanMatch(){
        try{
            bRendered = true; 
            if (sCurrentTab == null){
                sCurrentTab = 'tabPlanMatch';}
            /*else{
                this.selectedTab = sCurrentTab;
            }*/
            //ApexPages.addMessages(sCurrentTab);
            if (PlanPrimaryContents == null & dsapAccountnumber != 0){
                PlanPrimaryContents = getPlanMatchData();
             }
            }
            catch (MyException oException) {ApexPages.addMessages(oException);}
            //Do what you need to do with this exception
                //ApexPages.Message oMessage = new ApexPages.Message(ApexPages.Severity.ERROR, 'Customer is not a valid Content tool customer with a state');
                // ApexPages.addMessage(oMessage);}Catch any unexpected exceptions
            catch (Exception oException) {ApexPages.addMessages(oException);}
        }
        
        
    public void lazyLoadUsageMatch(){
        try{
             bRendered = true; 
        sCurrentTab = 'tabUsageMatch';
        if (UsagePrimaryContents == null) {
            UsagePrimaryContents = getUsageData();
        }
            }
    catch (MyException oException) {ApexPages.addMessages(oException);}
    catch (Exception oException) {ApexPages.addMessages(oException);}
    }
    
    public void lazyLoadKnownMatch(){
        try{
             bRendered = true; 
        sCurrentTab = 'tabKnownMatch';
        if (KnownPrimaryContents == null) {
            KnownPrimaryContents = getKnownData();
        }
      }
    catch (MyException oException) {ApexPages.addMessages(oException);}
    catch (Exception oException) {ApexPages.addMessages(oException);}
    }   
    
    public void lazyLoadPlanUsageMatch(){
        try{
             bRendered = true; 
        sCurrentTab = 'tabPlanUsageMatch';
        if (PlanUsagePrimaryContents == null) {
            PlanUsagePrimaryContents = getPlanUsageData();
        }
      }
    catch (MyException oException) {ApexPages.addMessages(oException);}
    catch (Exception oException) {ApexPages.addMessages(oException);}
    }
    
    public void lazyLoadTotalMatch(){
        try{
             bRendered = true; 
        sCurrentTab = 'tabTotalMatch';
        if (TotalPrimaryContents == null) {
            TotalPrimaryContents = getTotalData();
        }
      }
    catch (MyException oException) {ApexPages.addMessages(oException);}
    catch (Exception oException) {ApexPages.addMessages(oException);}
    }


    public PageReference findAccount2(){
        PageReference oPageReference = null;
        try {
            if (searchText == null)  {
                throw new AccountNotFoundException('Must enter SAP Number');
            }
            Planprimarycontents = null;
            dSAPAccountNumber = decimal.valueof(searchText);
            List<Account> listAccounts = [SELECT Id, SAPAccountNumber__c FROM Account WHERE SAPAccountNumber__c = :searchText];
            if (listAccounts.isEmpty() == false) {
                oPageReference = new PageReference('/apex/PlanMatch');
                oPageReference.getParameters().put('id', listAccounts[0].Id);
                oPageReference.getParameters().put('mo', searchMonths);
                oPageReference.getParameters().put('sap', searchText);
                oPageReference.setRedirect(true);
            }
            else {throw new AccountNotFoundException('Unable to find account for SAP Number: ' + searchText);}
        }       
        catch (Exception oException) {ApexPages.addMessages(oException);return null;}
        return oPageReference;
    }

    public PageReference GotoPage(){
        PageReference oPageReference = null;
        try {
            List<long> oListMaterialkeys = new list<long>();
            olistmaterialkeys.add(LMaterialKey);
            listmaterialkeys = olistmaterialkeys;
            plantype = 'PLAN';
            bIncludeAncillary = false;
            bIncludeWsd = false;
            //SearchPlanMatchDetails();
            searchPlanMatchDBSs();
            //oPageReference = new PageReference('/apex/PlanMaterialDetailPage?id=' + IdAccountId + 'matkey=' + LMaterialKey + 'desc=' + strmaterialDesc + 'matnum=' + strMaterialNumber + 'matprice=' + decListPrice);
            //oPageReference = new PageReference('/apex/PlanMaterialDetailPage');
            oPageReference = new PageReference('/apex/ContentMaterialDetail');
            oPageReference.getParameters().put('id', IdAccountId);
            oPageReference.getParameters().put('matkey', string.valueof(LMaterialKey));
            oPageReference.getParameters().put('matnum', strMaterialNumber);
            oPageReference.getParameters().put('desc', strMaterialDesc);
            oPageReference.getParameters().put('matprice', string.valueof(decListPrice));
            oPageReference.getParameters().put('Month', string.valueof(searchMonths2));
            oPageReference.getParameters().put('SAP', string.valueof(dSAPAccountNumber));
            //?Id={!Account.id}&matkey={!c.materialkey}&desc={!c.material}&matnum={!c.materialnumber}&matprice={!c.ListPrice}">{!c.MaterialNumber}  -->
            oPageReference.setRedirect(false);
        }
        catch (Exception oException) {ApexPages.addMessages(oException);}    
        return oPageReference;
    }

    public PageReference backpage(){
        PageReference oPageReference = null;
        try {
            oPageReference = new PageReference('/apex/PlanMatch');
            oPageReference.setRedirect(false);
        }   
        catch (Exception oException) {ApexPages.addMessages(oException);}
        return oPageReference;
    }

    public PageReference findAccount3(){
        PageReference oPageReference = null;
        try {
            if (searchText == null){
                throw new AccountNotFoundException('Must enter SAP Number');
            }
            Planprimarycontents = null;
            oPageReference = new PageReference('/apex/PlanMatch');
            oPageReference.getParameters().put('id', oAccount.ID);  
            oPageReference.getParameters().put('mo', string.valueof(searchMonths));
            oPageReference.getParameters().put('sap', oAccount.SAPAccountNumber__C);
            oPageReference.setRedirect(true);
        }
        catch (Exception oException) {ApexPages.addMessages(oException);}
        return oPageReference;
}


public class AccountNotFoundException extends Exception {}
    
/* skg 5/9/2012 removed while writing test because couldn't find it being called from anywhere
    public void SearchContents(Id accountId, string sMonths) {
        //Load Dummy Data
        Contents = new List<Content>();
        
        ContentOptimizerservice.CalculateMatchRequest oCalculateMatchRequest = new ContentOptimizerService.CalculateMatchRequest();
        
    
        }
    */
    
    public PageReference DisplayPlanDetail1() {
        PageReference oPageRef = null;
        try{ 
            //skg debug
/*system.debug('in displayplandetail1');
            system.debug('skg');-- commented to reduce character for s2e optimization */
            List<Content> oMaterialKeys = new List<Content>();
            List<long> oListMaterialkeys = new list<long>();
            if (PlanPrimaryContents != null){
                for (Content oMaterialPlanPrimary : PlanPrimaryContents){
                    if (oMaterialPlanPrimary.IsSelected == true) {
                        omaterialkeys.add(oMaterialPlanPrimary);
                        oListMaterialkeys.add(omaterialPlanPrimary.materialkey);
                    }
                }
            }           
            if (PlanPublicContents != null){
                for (Content oMaterialPlanPublic : PlanPublicContents){
                    if (oMaterialPlanPublic.IsSelected == true){
                        omaterialkeys.add(oMaterialPlanPublic);
                        oListMaterialkeys.add(omaterialPlanPublic.materialkey);
                    }
                }
            }
            if (PlanOtherContents != null){
                for (Content oMaterialPlanOther : PlanOtherContents){
                    if (oMaterialPlanOther.IsSelected == true) {
                        omaterialkeys.add(oMaterialPlanOther);
                        oListMaterialkeys.add(omaterialPlanOther.materialkey);
                    }
                }
            }
            materialsSelected = omaterialkeys;
            listmaterialkeys= olistmaterialkeys;
            if (listmaterialkeys.isempty() == true){
                brendered = false;
                // throw new MyException('At least one meterial needs to be selected'); //Replaced with Custom Label as part of S2E Optimization
                throw new MyException(Label.ContentCntlrEx);
            }
            plantype = 'PLAN';
            bIncludeAncillary = false;
            bIncludeWsd = false;
            SearchPlanMatchDetails();
            searchPlanMatchDBSs();
/*system.debug('test1');-- commented to reduce character for s2e optimization */
            //PageReference pageReftmp = ApexPages.currentPage();
            //PageReference pageRef = new PageReference('/apex/PlanDetail?id=' + accountid + '&type=Plan');
            //return pageRef;
            //PageReference pageRef = new PageReference('/apex/PlanDetail?id=' + accountid + '&type=Plan');
            opageRef = new PageReference('/apex/PlanDetail?id=' + accountid + '&type=Plan');
            //oPageRef.setRedirect(true);
            //return opageRef;  
        }
        catch (MyException oException) {ApexPages.addMessages(oException);}
            //pagereference oPageRef = new PageReference('/apex/PlanMatch');
            //PageRef.setRedirect(false);
            //return pageRef;
        //}
        catch (Exception oException) {ApexPages.addMessages(oException);}
            //pagereference PageRef = new PageReference('/apex/PlanMatch');PageRef.setRedirect(false); return pageRef;}
        //PageReference pageRef = new PageReference('/apex/PlanDetail?id=' + accountid + '&type=Plan');
        return opageRef;    
    }

 /*  skg 5/9/2012 removed while writing test becaus couldn't find it being called from anywhere
    public PageReference DisplayPlanDetailtmp1() {
        pagereference opageref = null;   
        //skg debug
        system.debug('in displayplandetail1');
        system.debug('skg');
        //SearchPlanMatchDetails();
        try{

            List<Content> oMaterialKeys = new List<Content>();
            List<long> oListMaterialkeys = new list<long>();
            if (PlanPrimaryContents != null) {  

                for (Content oMaterialPlanPrimary : PlanPrimaryContents) {
                    //  content oMaterialId = new content();
                    if (oMaterialPlanPrimary.IsSelected == true) {
                                
                        //Add to selected list
                        //  omaterialId.materialkey = oMaterialPlan.MaterialKey;
                        //  omaterialId.materialnumber = oMaterialPlan.Materialnumber;
                        //  omaterialId.material = oMaterialPlan.material;
                        //  omaterialId.listprice = oMaterialPlan.listprice;
                        omaterialkeys.add(oMaterialPlanPrimary);
                        oListMaterialkeys.add(omaterialPlanPrimary.materialkey);
                    }
                }
            }
            if (PlanPublicContents != null) {           
                for (Content oMaterialPlanPublic : PlanPublicContents) {
                    // content oMaterialId = new content();
                    if (oMaterialPlanPublic.IsSelected == true) {
                                
                        //Add to selected list
                        //  omaterialId.materialkey = oMaterialPlan.MaterialKey;
                        //  omaterialId.materialnumber = oMaterialPlan.Materialnumber;
                        //  omaterialId.material = oMaterialPlan.material;
                        //  omaterialId.listprice = oMaterialPlan.listprice;
                        omaterialkeys.add(oMaterialPlanPublic);
                        oListMaterialkeys.add(omaterialPlanPublic.materialkey);
                    }
                }
            }
            if (PlanOtherContents != null) {
                for (Content oMaterialPlanOther : PlanOtherContents) {
            
                    if (oMaterialPlanOther.IsSelected == true) {
                                
                        //Add to selected list
                        omaterialkeys.add(oMaterialPlanOther);
                        oListMaterialkeys.add(omaterialPlanOther.materialkey);
                    
                    }
                }
            }           

            materialsSelected = omaterialkeys;
            listmaterialkeys= olistmaterialkeys;
            if (listmaterialkeys.isempty() == true){
                brendered = false;
               // throw new MyException('At least one meterial needs to be selected'); //Replaced with Custom Label as part of S2E Optimization
               throw new MyException(Label.ContentCntlrEx);
            }
 
            plantype = 'PLAN';
            bIncludeAncillary = false;
            bIncludeWsd = false;
    
            SearchPlanMatchDetails();
            searchPlanMatchDBSs();
            //searchUnmappedDBSs();

            PageReference pageReftmp = ApexPages.currentPage();


            stype = 'Plan';
    
            accountid = AppUtil.getURLParam(ApexPages.currentPage(), 'id', ''); 
            PageReference pageRef = new PageReference('/apex/PlanDetail?id=' + accountid + '&type=Plan');
            // PageReference pageRef = new PageReference('/apex/PlanDetail?id=' + accountid + '&type=Plan&Mats=' + oMaterialkeys );
        
            pageRef.setRedirect(false); 
        
    
//          return pageRef;
    
        }
        catch (MyException oException) {
            ApexPages.addMessages(oException);
            //pagereference oPageRef = new PageReference('/apex/PlanMatch');
            //PageRef.setRedirect(false);
            //return pageRef;
        }
        catch (Exception oException) {
            ApexPages.addMessages(oException);
            //pagereference PageRef = new PageReference('/apex/PlanMatch');
            //PageRef.setRedirect(false);
            //return pageRef;
        }
        //PageReference pageRef = new PageReference('/apex/PlanDetail?id=' + accountid + '&type=Plan');
        return opageRef;    
    }

*/

    public PageReference DisplayUsageDetail(){
        pagereference opageref = null;
    try{        
        List<Content> oMaterialKeys = new List<Content>();
        List<long> oListMaterialkeys = new list<long>();
        if (UsagePrimaryContents != null){   
            for (Content oMaterialUsagePrimary : UsagePrimaryContents){
                if (oMaterialUsagePrimary.IsSelected == true){
                    omaterialkeys.add(oMaterialUsagePrimary);
                    oListMaterialkeys.add(omaterialUsagePrimary.materialkey);
                }
            }
        }
        if (UsagePublicContents != null){
            for (Content oMaterialUsagePublic : UsagePublicContents){
                if (oMaterialUsagePublic.IsSelected == true){
                    omaterialkeys.add(oMaterialUsagePublic);
                    oListMaterialkeys.add(omaterialUsagePublic.materialkey);
                }
            }
        }
        if (UsageOtherContents != null){     
            for (Content oMaterialUsageOther : UsageOtherContents){
                if (oMaterialUsageOther.IsSelected == true){
                    omaterialkeys.add(oMaterialUsageOther);
                    oListMaterialkeys.add(omaterialUsageOther.materialkey);
                }
            }
        }           
        materialsSelected = omaterialkeys;
        listmaterialkeys= olistmaterialkeys;
        if (listmaterialkeys.isempty() == true){
        brendered = false;
       // throw new MyException('At least one meterial needs to be selected'); //Replaced with Custom Label as part of S2E Optimization
        throw new MyException(Label.ContentCntlrEx);
        }
        else{
            bRendered = true;
        }
 
        plantype = 'USAGE';
        bIncludeAncillary = true;
        bIncludeWsd = false;
        SearchPlanMatchDetails();
        searchPlanMatchDBSs();
        stype = 'Usage';
        accountid = AppUtil.getURLParam(ApexPages.currentPage(), 'id', ''); 
        opageRef = new PageReference('/apex/PlanDetail?id=' + accountid + '&type=Usage' );
    //  pageRef.setRedirect(false); 
    //      return pageRef;
    }   
catch (MyException oException) {ApexPages.addMessages(oException);}
 //pagereference oPageRef = new PageReference('/apex/PlanMatch');
 //PageRef.setRedirect(false);
 //return pageRef;
//}
catch (Exception oException) {ApexPages.addMessages(oException);}
 //pagereference PageRef = new PageReference('/apex/PlanMatch');PageRef.setRedirect(false);
 //return pageRef;}
//PageReference pageRef = new PageReference('/apex/PlanDetail?id=' + accountid + '&type=Plan');
return opageRef;    
}
    
    public PageReference DisplayKnownDemandDetail() {
    pagereference opageref = null;
    try{
        List<Content> oMaterialKeys = new List<Content>();
        List<long> oListMaterialkeys = new list<long>();
        if (KnownPrimaryContents != null){
            for (Content oMaterialKnownPrimary : KnownPrimaryContents){
                if (oMaterialKnownPrimary.IsSelected == true){
                    omaterialkeys.add(oMaterialKnownPrimary);
                    oListMaterialkeys.add(omaterialKnownPrimary.materialkey);
                }
            }           
            for(Content oMaterialKnownPublic : KnownPublicContents){
                if (oMaterialKnownPublic.IsSelected == true){
                    omaterialkeys.add(oMaterialKnownPublic);
                    oListMaterialkeys.add(omaterialKnownPublic.materialkey);
                }
            }
            for (Content oMaterialKnownOther : KnownOtherContents){
                if (oMaterialKnownOther.IsSelected == true){
                    omaterialkeys.add(oMaterialKnownOther);
                    oListMaterialkeys.add(omaterialKnownOther.materialkey);
                }
              }   
         }
        materialsSelected = omaterialkeys;
        listmaterialkeys= olistmaterialkeys;
        if (listmaterialkeys.isempty() == true){
            brendered = false;
   // throw new MyException('At least one meterial needs to be selected'); //Replaced with Custom Label as part of S2E Optimization
           throw new MyException(Label.ContentCntlrEx);
        }
        plantype = 'USAGE';
        bIncludeAncillary = true;
        bIncludeWsd = true;
        SearchPlanMatchDetails();
        searchPlanMatchDBSs();  
        stype = 'Known Demand';
        accountid = AppUtil.getURLParam(ApexPages.currentPage(), 'id', ''); 
        opageRef = new PageReference('/apex/PlanDetail?id=' + accountid + '&type=Known Demand' );
        //  pageRef.setRedirect(false); return pageRef;
        }   
        catch (MyException oException) {ApexPages.addMessages(oException);}
 //pagereference oPageRef = new PageReference('/apex/PlanMatch');
 //PageRef.setRedirect(false);
 //return pageRef;
//}
    catch (Exception oException) {ApexPages.addMessages(oException);}
 //pagereference PageRef = new PageReference('/apex/PlanMatch');
 //PageRef.setRedirect(false);
 //return pageRef;
//}
//PageReference pageRef = new PageReference('/apex/PlanDetail?id=' + accountid + '&type=Plan');
        return opageRef;    
    }
    public PageReference DisplayPlanAndUsageDetail() {
    pagereference opageref = null;
    try{
        List<Content> oMaterialKeys = new List<Content>();
        List<long> oListMaterialkeys = new list<long>();
            if (PlanUsagePrimaryContents != null){
            for (Content oMaterialPlanUsagePrimary : PlanUsagePrimaryContents){
                if (oMaterialPlanUsagePrimary.IsSelected == true){
                    omaterialkeys.add(oMaterialPlanUsagePrimary);
                    oListMaterialkeys.add(omaterialPlanUsagePrimary.materialkey);
                }
            }           
            for (Content oMaterialPlanUsagePublic : PlanUsagePublicContents){
                if (oMaterialPlanUsagePublic.IsSelected == true){
                    omaterialkeys.add(oMaterialPlanUsagePublic);
                    oListMaterialkeys.add(omaterialPlanUsagePublic.materialkey);
                }
            }
            for (Content oMaterialPlanUsageOther : PlanUsageOtherContents){
                if (oMaterialPlanUsageOther.IsSelected == true){
                    omaterialkeys.add(oMaterialPlanUsageOther);
                    oListMaterialkeys.add(omaterialPlanUsageOther.materialkey);
                }
              }
            }
        materialsSelected = omaterialkeys;
    listmaterialkeys= olistmaterialkeys;
    if (listmaterialkeys.isempty() == true){
        brendered = false;
       // throw new MyException('At least one meterial needs to be selected'); //Replaced with Custom Label as part of S2E Optimization
       throw new MyException(Label.ContentCntlrEx);
    }
    plantype = 'PLAN';
    bIncludeAncillary = true;
    bIncludeWsd = false;
        SearchPlanMatchDetails();
        searchPlanMatchDBSs();
        stype = 'Plan and Usage';
        accountid = AppUtil.getURLParam(ApexPages.currentPage(), 'id', ''); 
        opageRef = new PageReference('/apex/PlanDetail?id=' + accountid + '&type=Plan and Usage' );
    //  pageRef.setRedirect(false); 
    //      return pageRef;
    }   
    catch (MyException oException) { ApexPages.addMessages(oException);}
 //pagereference oPageRef = new PageReference('/apex/PlanMatch');
 //PageRef.setRedirect(false);return pageRef;}
    catch (Exception oException) {ApexPages.addMessages(oException);}
     //pagereference PageRef = new PageReference('/apex/PlanMatch');
     //PageRef.setRedirect(false);return pageRef;}
    //PageReference pageRef = new PageReference('/apex/PlanDetail?id=' + accountid + '&type=Plan');
    return opageRef;    
}   
    public PageReference DisplayTotalDetail(){
    pagereference opageref = null;
    try{        
        List<Content> oMaterialKeys = new List<Content>();
        List<long> oListMaterialkeys = new list<long>();
            if (TotalPrimaryContents != null){
            for (Content oMaterialTotalPrimary : TotalPrimaryContents){
                if (oMaterialTotalPrimary.IsSelected == true){
                    omaterialkeys.add(oMaterialTotalPrimary);
                    oListMaterialkeys.add(omaterialTotalPrimary.materialkey);
                }
            }       
            for (Content oMaterialTotalPublic : TotalPublicContents){                
                if (oMaterialTotalPublic.IsSelected == true){
                    omaterialkeys.add(oMaterialTotalPublic);
                    oListMaterialkeys.add(omaterialTotalPublic.materialkey);
                }
            }
            for (Content oMaterialTotalOther : TotalOtherContents){
                if (oMaterialTotalOther.IsSelected == true){
                    omaterialkeys.add(oMaterialTotalOther);
                    oListMaterialkeys.add(omaterialTotalOther.materialkey);
                }
            }
        }
        materialsSelected = omaterialkeys;
        listmaterialkeys= olistmaterialkeys;
        if (listmaterialkeys.isempty() == true){
            brendered = false;
           // throw new MyException('At least one meterial needs to be selected'); //Replaced with Custom Label as part of S2E Optimization
           throw new MyException(Label.ContentCntlrEx);
        }   
        plantype = 'PLAN';
        bIncludeAncillary = true;
        bIncludeWsd = true;
        SearchPlanMatchDetails();
        //skg debug
/*system.debug('after searchPlanMatchDetails');-- commented to reduce character for s2e optimization */
        searchPlanMatchDBSs();
        stype = 'Total';
        accountid = AppUtil.getURLParam(ApexPages.currentPage(), 'id', ''); 
        opageRef = new PageReference('/apex/PlanDetail?id=' + accountid + '&type=Total' );
    //  pageRef.setRedirect(false); 
    //      return pageRef;
    }   
    catch (MyException oException) {ApexPages.addMessages(oException);}
     //pagereference oPageRef = new PageReference('/apex/PlanMatch');PageRef.setRedirect(false);return pageRef;}
    catch (Exception oException) {ApexPages.addMessages(oException);}
     //pagereference PageRef = new PageReference('/apex/PlanMatch');PageRef.setRedirect(false);return pageRef;}
    //PageReference pageRef = new PageReference('/apex/PlanDetail?id=' + accountid + '&type=Plan');
    return opageRef;    
}   
    
//********************************************
//from plan detail Controller
    public void SearchPlanMatchDetails(){
        //Load Dummy Data
        PlanMatchDetails = new List<PlanMatchDetail>();
        try{
            for (content oPlanMaterialkey : materialsSelected){
            PlanMatchDetail oPubCntnt1 = new PlanMatchDetail();
            oPubCntnt1.MaterialNumber = oPlanmaterialkey.materialnumber;
            oPubCntnt1.Materialdescription = oplanmaterialkey.material;
            oPubCntnt1.ListPrice = oplanmaterialkey.listprice;
            oPubCntnt1.Materialkey = oPlanmaterialkey.materialkey;
            PlanMatchDetails.add(oPubCntnt1);
            }
          if (planmatchdetails.isEmpty() == true){
                       // throw new MyException('At least one meterial needs to be selected'); //Replaced with Custom Label as part of S2E Optimization
             throw new MyException(Label.ContentCntlrEx);
         }
        ContentOptimizerservice.CalculatePlanRequest oCalculatePlanRequest = new ContentOptimizerService.CalculatePlanRequest();
        tempmaterialkeys = new list<long>();
        //oCalculatePlanRequest.MatchType = 'PLAN';
        //oCalculatePlanRequest.MatchType = 'USAGE';
        oCalculatePlanRequest.MatchType = plantype;
        oCalculatePlanRequest.AcctSapId = dSAPAccountNumber;
        //oCalculatePlanRequest.AcctSapId = 123456789;
        //oCalculatePlanRequest.NumberOfMonths = 3;
        oCalculatePlanRequest.NumberOfMonths = searchMonths2;
        //oCalculatePlanRequest.IncludeAncillary = true;
        oCalculatePlanRequest.IncludeAncillary = bIncludeAncillary;
        //oCalculatePlanRequest.IncludeWsd = false;
        oCalculatePlanRequest.IncludeWsd = bIncludeWsd;
        tempmaterialkeys.add(1);
        // oCalculatePlanRequest.Materialkey = tempMaterialkeys;
        oCalculatePlanRequest.Materialkey = ListMaterialkeys;
        ContentOptimizerservice.CalculatePlanInfo oResponse3 = ContentOptimizerService.getCalculatePlanInfo(oCalculatePlanRequest) ;
        //skg debug
/*system.debug('contents of Response3'+ oresponse3);-- commented to reduce character for s2e optimization */
        PercentMatch = oresponse3.MatchPercent;
        PercentExcess = oresponse3.excessPercent;
      }
        catch (MyException oException) { ApexPages.addMessages(oException);}
        catch (Exception oException) {ApexPages.addMessages(oException);}
    }
    
        
        public void SearchPlanMatchDBSs(){
            ContentOptimizerservice.GetDatabaseRequest oGetDatabaseRequest = new ContentOptimizerService.GetDatabaseRequest();
            oGetDatabaseRequest.MatchType = 'PLAN';
            oGetDatabaseRequest.MatchType = plantype;
            oGetDatabaseRequest.AcctSapId = dSAPAccountNumber; //oGetDatabaseRequest.AcctSapId = 1000457606;
            oGetDatabaseRequest.NumberOfMonths = 12; //oGetDatabaseRequest.IncludeAncillary = true; oGetDatabaseRequest.IncludeWsd =true;
            oGetDatabaseRequest.IncludeAncillary = bIncludeAncillary; 
            oGetDatabaseRequest.IncludeWsd =bIncludeWsd;
            oGetDatabaseRequest.DatabaseType = 'MATCHED';   
            oGetDatabaseRequest.Materialkey = Listmaterialkeys;
/*system.debug('skg debug planmatchdbs before call');-- commented to reduce character for s2e optimization */
        ContentOptimizerservice.getDatabaseInfo oResponse4 = ContentOptimizerService.getDatabaseInfo(oGetDatabaseRequest) ;
        //Load Dummy Data
    //  PlanMatchDBSs = new List<PlanMatchDBS>();
        //skg debug
/*system.debug('size of Response4'+ oresponse4.databaseitem.size());
        system.debug('skg debug planmatchdbs');-- commented to reduce character for s2e optimization */
        PlanMatchDBSs = new MatchItems();
        planMatchDBSs.items = oresponse4.databaseitem; // contentoptimizerservice.DatabaseItem
        oGetDatabaseRequest.DatabaseType = 'UNMAPPED';
        ContentOptimizerservice.getDatabaseInfo oResponse5 = ContentOptimizerService.getDatabaseInfo(oGetDatabaseRequest) ; 
/*system.debug('oresponse5.databaseitem size = ' + oresponse5.databaseitem.size());
        system.debug('skg');-- commented to reduce character for s2e optimization */
        unmappedDBSs = new MatchItems();
        unmappedDBSs.items = oresponse5.databaseitem;
        oGetDatabaseRequest.DatabaseType = 'EXCESS';
        ContentOptimizerservice.getDatabaseInfo oResponse6 = ContentOptimizerService.getDatabaseInfo(oGetDatabaseRequest) ; 
        excessDBSs = new MatchItems();
        excessDBSs.items = oresponse6.databaseitem; // contentoptimizerservice.DatabaseItem
    }
  
        
    //Internal Classes
    public class Content{
        public long MaterialNumber {get;set;}
        public string Material {get;set;}
        public long MaterialKey {get;set;} // public string MaterialDescription {get;set;}
        public decimal PercentMatch {get;set;}
        public decimal PercentExcess {get;set;}
        public decimal ListPrice {get;set;}
        // checkbox thing
        public Boolean IsSelected {get; set;}
    }
    
    //********** from plan detail controller ******************************************
        
        // posibly take out planmatchdetail and use content
        public class PlanMatchDetail{
        public long materialnumber {get;set;}
        public string materialdescription {get;set;}
        public decimal listprice {get;set;}
        public long materialKey {get;set;}
        }
    
        public class PlanMatchDBS{
        public string dbs {get;set;}
        public string dbsdescription {get;set;}
        public boolean inplan {get;set;}
        public long inplantrans {get;set;}
        public long ancillarytrans {get;set;}
        public long wsdtrans {get;set;}
        }
        
        public class UnmappedDBS{
        public string dbs {get;set;}
        public string dbsdescription {get;set;}
        public boolean inplan {get;set;}
        public long inplantrans {get;set;}
        public long ancillarytrans {get;set;}
        public long wsdtrans {get;set;}
        }
        
        public class ExcessDBS{
        public string dbs {get;set;}
        public string dbsdescription {get;set;}
        public boolean inplan {get;set;}
        public long inplantrans {get;set;}
        public long ancillarytrans {get;set;}
        public long wsdtrans {get;set;}
        }
    
        //Internal Classes
        public class MatchItems{
        //Properties
        public integer PageIndex {get;set;}
        public integer PageSize {get;set;}
        public boolean HasNext {get;set;}
        public boolean HasPrev {get;set;}
        public List<contentoptimizerservice.DatabaseItem> Items {get;set;} //public List<MatchItem> Items {get;set;}
        public List<contentoptimizerservice.DatabaseItem> Page{
            get {return getPageData();}
        }
        public integer PageNumber {
            get {return PageIndex + 1;}
        }
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
         
        //Constructor
        
        /**
         * Default Constructor
         */

        public MatchItems(){
            PageIndex = 0;
            PageSize = 70;
            HasNext = false;
            HasPrev = false;
            Items = new List<contentoptimizerservice.DatabaseItem> ();
            //Items = new List<MatchItem>();
        }
        
        //Private Methods
        
        /**
         * Retrieves a list of MatchItem objects based on the 
         * PageIndex and PageSize from the Items array
         *
         * @returns a list of MatchItem objects
         */
        private List<contentoptimizerservice.DatabaseItem> getPageData(){
            List<contentoptimizerservice.DatabaseItem> listPage = new List<contentoptimizerservice.DatabaseItem>();
    //      HasNext = false; HasPrev = false;
            if (Items != null && Items.isEmpty() == false){
                integer lbound = PageIndex * PageSize;
                //integer ubound = (lbound + PageSize) - 1;
                integer ubound = (lbound + PageSize);
                If (ubound > items.size()){
                    ubound = items.size();
                }
        /* for (integer i=lbound; i<ubound; i++) {     if (pageindex== 1) {
                    for (integer i=lbound; i<71; i++) {
                    ListPage.add(Items[i]);
                    }
                }else    { */
                for (integer i=lbound; i<ubound; i++) {
                   //  for (integer i=0; i<70; i++) {
                    ListPage.add(Items[i]);
                } //}
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
        /*Constructors 
         * Default Constructor
         */
        public MatchItem(){
            inplan = '';
        }
    } 
}