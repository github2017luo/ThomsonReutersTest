/**
* CHANGE HISTORY
* =============================================================================
* Date         Name                    Description
*  
* 2018-01-06   Arti Choudhari          Mdified code [CRM-11595] created methods AdvancedSearchListLeadURL, cancel, saveLead, massLeadCreation1
* 2019-03-13   Lovedeep Singh          Modified code [DPS-3229] Changes made to Delete function to explicitly redirect the page to LIST view of Advanced controller as the oStandardController.delete() is not redirecting the page to list view in Lightning.
  2020-4-1     Shyamsundar Shet        BMP-1591 - Inserted the Token generation operation as part of Rocket services to Dellboomi migration

* =============================================================================
*/

public with sharing class AdvancedSearchController {
    //Protected Members
    public  ApexPages.StandardController oStandardController;
    //public ApexPages.StandardController accountController;
    @TestVisible 
    private AdvancedSearch__c oAdvancedSearch;
    @TestVisible 
    private List<string> listMyTerritoryNumbers;
    @TestVisible 
    private List<string> listAllTerritoryNumbers;
    @TestVisible 
    private List<string> listTeamTerritoryNumbers;
    public String profileName{get;set;}
    public Map<string, AdvancedSearchUtil.FieldInfo> mapFilterFields;
    public Map<string, AdvancedSearchUtil.FieldInfo> mapSelectFields;
    
    private SelectOption OperatorEqual = new SelectOption(AdvancedSearchUtil.Operator.Equal.name(), Label.Equal);
    private SelectOption OperatorLessThan = new SelectOption(AdvancedSearchUtil.Operator.LessThan.name(), Label.Less_Than);
    private SelectOption OperatorGreaterThan = new SelectOption(AdvancedSearchUtil.Operator.GreaterThan.name(), Label.Greater_Than);
    private SelectOption OperatorBetween = new SelectOption(AdvancedSearchUtil.Operator.Between.name(), Label.Between);
    
    //Constants
    public static final string TerritoryTypeAll = 'All';
    public static final string TerritoryTypeMy = 'My';
    public static final string TerritoryTypeTeam = 'Team';
    
    Public String recordId{get;set;} 
    Public List<Account> acc{get;set;}
    
    //Properties
    public string TerritoryView {get;set;}
    public boolean AllowEdit {get;set;}
    public AdvancedSearchFilterBlockItem NewFilterInput {get;set;}
    public AdvancedSearchFilterBlock IncludeFilterBlock {get;set;}
    public AdvancedSearchFilterBlock ExcludeFilterBlock {get;set;}
    public AdvancedSearchAccounts SearchResults {get;set;}
    public List<SelectOption> FilterFields {get;set;}
    public list<SelectOption> TerritoryOptions {get;set;}
    Public set<Id> listAccountId;
    public List<SelectOption> AvailableTerritoryOptions {
        get { return getAvailableTerritoryOptions(); }
    }
    
    public List<SelectOption> FilterOperators {
        get {
            return new List<SelectOption>{
                                            OperatorEqual ,
                                            OperatorLessThan ,
                                            OperatorGreaterThan ,
                                            OperatorBetween
                                        };
            }
    }
    
    public List<SelectOption> SelectedTerritoryOptions {
        get { return toSelectOptions(SelectedTerritoryNumbers); }
    }
    
    public List<string> SelectedTerritoryNumbers {
        get { return parseTerritoryNumbers(); }
    }
    
    public Set<string> SelectFieldNames {
        get { return getSelectFieldNames(); } 
    }
    
    public string AdvancedSearchListURL {
        get { return Schema.SObjectType.AdvancedSearch__c.getKeyPrefix(); }
    }
    
    public boolean AllowDelete {
        get { return (oAdvancedSearch.Id != null); }
    }
    
    public boolean AllowCancel {
        get { return (oAdvancedSearch.Id == null); }
    }
    public PageReference AdvancedSearchListLeadURL(){
        
        PageReference pg = new PageReference('/apex/AdvancedSearch?id='+recordId);
        pg.setRedirect(true);
        return pg;
    }
    
    /**
* Sets AllowEdit to TRUE if the specified Advanced Search record can be edited by the current user
* AllowEdit is used to display Save and Delete button.
*/
    private void getAllowEdit(Id oRecordId) {
        AllowEdit = TRUE;
        List<UserRecordAccess> listUserRecordAccess = new List<UserRecordAccess>();
        if (oRecordId != null) {
            if(Schema.sObjectType.UserRecordAccess.isAccessible())
            listUserRecordAccess = [SELECT RecordId,
                                           HasReadAccess,
                                           HasEditAccess FROM UserRecordAccess
                                           WHERE UserId=:UserInfo.getUserId()
                                           AND RecordId =:oRecordId];
            AllowEdit = listUserRecordAccess[0].HasEditAccess;
        }
        
    }
    
    //Constructors
    
    /**
* Default Constructor
*/
    
    private AdvancedSearchController() {
        //Init Members
        listMyTerritoryNumbers = new List<string>();
        listAllTerritoryNumbers = new List<string>();
        listTeamTerritoryNumbers = new List<string>();
        
        mapFilterFields = new Map<string, AdvancedSearchUtil.FieldInfo>();
        mapSelectFields = new Map<string, AdvancedSearchUtil.FieldInfo>();        
        
        //Init Properties
        NewFilterInput = new AdvancedSearchFilterBlockItem();
        NewFilterInput.AdvancedSearchDetail.Operator__c = AdvancedSearchUtil.Operator.Equal.name();
        
        IncludeFilterBlock = new AdvancedSearchFilterBlock();
        ExcludeFilterBlock = new AdvancedSearchFilterBlock();
        SearchResults = new AdvancedSearchAccounts();
        oAdvancedSearcSelected= new List<AdvancedSearchAccount>();
        recordId= ApexPages.currentPage().getParameters().get('id');
        system.debug('$$$$$$SearchResultsCurrentPagerecordId'+recordId);
        listAccountId= new set<Id>();
        
        FilterFields = new List<SelectOption>();
        //oAdvancedSearchAccountNew= new List<AdvancedSearchAccount>();
        TerritoryView = TerritoryTypeAll;
        TerritoryOptions = new List<SelectOption> {
                  new SelectOption(TerritoryTypeAll,  Label.All_Territories) ,
                  new SelectOption(TerritoryTypeMy,   Label.My_Territories) ,
                  new SelectOption(TerritoryTypeTeam, Label.My_Team_Territories)
                };
                    
                    
    }
    
    /**
* AdvancedSearch__c Standard Controller Constructor
*
* @param       oController     an ApexPages.StandardController object
*/
    public AdvancedSearchController(ApexPages.StandardController oController) {
        
        try {
            this();
            oStandardController = oController;
            oAdvancedSearch = (AdvancedSearch__c) oController.getRecord();
            // oAdvancedSearch= oStandardController.getSelected();
            getAllowEdit(oAdvancedSearch.Id);
            profileName = [SELECT Id,
                                  Name FROM Profile
                                  WHERE Id=:userinfo.getProfileId() LIMIT 1].Name;
            
            acc= new List<Account>();
            sapAccNo= new Set<String>();
            //mapAcc= NEW map<String, Account>();
            //getRecordsDetail();
            
            
        }
        catch (Exception oException) { ApexPages.addMessages(oException);}
        system.debug('>>>>>>>>>>>>>inCONSTRUCTORACC:'+acc);
        
    }
    
    //Public Methods
    
    /**
* Initializes the current page
*/
    public void onPageLoad() {
        try {
            loadTerritoryNumbers();
            loadAdvancedSearchDetails();
            loadAdvancedSearchFields();
            system.debug('%%%%%%onloadSearchResultscurrent'+SearchResults.CurrentPage);
            system.debug('dbi-->'+SearchResults.CurrentPage);
            //Init Filter Input
            updateFilterValueInput();
            
        }
        catch (Exception oException) {
            ApexPages.addMessages(oException);
        }
    }
    
    /**
* Updates the state of the field fiter criteria section
* based on changes made to selected territories
* <p>
* Because field list values are dependent on the territories
* selected any current values cached need to be reset and will
* require that the next time the user selects a list field for use
* the values will need to be retrieved from the web service
*/
    public void onTerritoryChange() {
        try {    
            system.debug('@@@@@mapFilterFields.values()'+mapFilterFields.values());
            for (AdvancedSearchUtil.FieldInfo oFieldInfo : mapFilterFields.values()) {
                oFieldInfo.ValidValues = new List<string>();
                
            }  
        }
        catch (Exception oException) {  ApexPages.addMessages(oException); }
    }
    
    /**
* Updates the state of the field filter criteria section
* based on the users input
*/
    public void onFilterFieldChanged() {
        try {
            onTerritoryChange();            // reset ALL ValidValues to blank List before uploading new LOV
            NewFilterInput.FieldValuesMap = New Map<integer, string>();
            updateFilterValueInput();
            
            //Always reset operator to equal
            NewFilterInput.resetSelectedValues();
            NewFilterInput.AdvancedSearchDetail.Operator__c = AdvancedSearchUtil.Operator.Equal.name();
        }
        catch (Exception oException) { ApexPages.addMessages(oException);
        }
    }
    
    /**
* Updates the state of the field filter criteria section
* based on the users input
*/
    public void onFilterOperatorChanged() {
        try {
            updateFilterValueInput();
        }
        catch (Exception oException) {ApexPages.addMessages(oException);
        }
    }
    
    /**
* Initiates a request to delete the current AdvancedSearch__c data
- DPS-3229: Changes made to this function to explicitly redirect the page to LIST view of Advanced controller as the oStandardController.delete() 
is not redirecting the page to list view in Lightning. Earlier code for deleteSearch is commented below 

 public PageReference deleteSearch() {
        PageReference oPageReference = null;
        
        try {
            oPageReference = oStandardController.delete();
        }
        catch (Exception oException) {
            ApexPages.addMessages(oException);
        }
        
        return oPageReference;
    }

*/
      
/**
* DPS-3229 - New code for delete search which is compatible on both Lightning and classic

*/    
    public PageReference deleteSearch() {
        string delId=ApexPages.CurrentPage().getparameters().get('id');
        PageReference oPageReference = null;      
        try {
            //DPS-3229: Apex CRUD validation Schema.sObjectType.AdvancedSearch__c.isQueryable() && Schema.sObjectType.AdvancedSearch__c.isDeletable() in order to resolve PMD issue    
            if( Schema.sObjectType.AdvancedSearch__c.isQueryable() && 
                Schema.sObjectType.AdvancedSearch__c.isDeletable() &&
                delId!=NULL){ 
                AdvancedSearch__c ac = new AdvancedSearch__c(id=delId);               
                delete ac; 
                Schema.DescribeSObjectResult result = AdvancedSearch__c.SObjectType.getDescribe(); 
                oPageReference = new PageReference('/' + result.getKeyPrefix());  
                oPageReference.setRedirect(true);
                
            } else {oPageReference = oStandardController.delete();} 
            
        }
        catch (Exception oException) {   ApexPages.addMessages(oException);} 
        return oPageReference;
    }
    
  

    
    /**
* Initiates a request to save the current AdvancedSearch__c data
*/
    public void save() {
        Boolean IsSaveAborted = false;
        try {
            ValidationResult oValidationResult = validateSave();
            if (oValidationResult.IsValid) {
                PageReference oSavePageReference = oStandardController.save();
                oAdvancedSearch = (AdvancedSearch__c) oStandardController.getRecord();
                
                //Save Search Criteria
                List<AdvancedSearchDetail__c> listAdvancedSearchDetail = new List<AdvancedSearchDetail__c>();
                //                              List<Id> toDelete = new List<Id>();
                
                List<AdvancedSearchFilterBlockItem> listAdvancedSearchFilterBlockItems = new List<AdvancedSearchFilterBlockItem>();
                listAdvancedSearchFilterBlockItems.addAll(IncludeFilterBlock.AdvancedSearchFilterBlockItems);
                listAdvancedSearchFilterBlockItems.addAll(ExcludeFilterBlock.AdvancedSearchFilterBlockItems);
                
                for (AdvancedSearchFilterBlockItem oItem : listAdvancedSearchFilterBlockItems) {
                    AdvancedSearchDetail__c oAdvancedSearchDetail = oItem.AdvancedSearchDetail;
                    
                    if (oItem.IsTypeList) {if (oItem.Value1.length() <= 32768) {  oAdvancedSearchDetail.ListValue__c = oItem.Value1;
                        }
                        else {
                            if (oItem.Value1.length() <= 65536) { oAdvancedSearchDetail.ListValue__c = oItem.Value1.substring(0, 32767); oAdvancedSearchDetail.ListValue2__c = oItem.Value1.substring(32767);
                            }
                            else {
                                //                                                              ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'Cannot save search. Please reduce the number of entries on list to save.'+oItem.Value1.substring(65500)));
                                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'Cannot save search. Please reduce the number of entries on list to save.')); IsSaveAborted = true; Break;
                            }
                        }
                    }
                    
 /*       
 if (oItem.IsDeleted == true) {
        if (AppUtil.IsEmpty(oAdvancedSearchDetail.Id) == false) {
            toDelete.add(oAdvancedSearchDetail.Id);
        }
    }
else {*/
                    if (AppUtil.isEmpty(oAdvancedSearchDetail.AdvancedSearch__c)) { oAdvancedSearchDetail.AdvancedSearch__c = oAdvancedSearch.Id;  }
                    
                    listAdvancedSearchDetail.add(oAdvancedSearchDetail);
                    //                                      }
                }
                
                /*                              //Delete Removed Criteria
if (toDelete.isEmpty() == false) {
Database.delete(toDelete, false);
}
*/                              
                if(!IsSaveAborted) {
                    if (IncludeFilterBlock.ItemstoDelete.isEmpty() == false) { Database.delete(IncludeFilterBlock.ItemstoDelete, false);  }
                    if (ExcludeFilterBlock.ItemstoDelete.isEmpty() == false) { Database.delete(ExcludeFilterBlock.ItemstoDelete, false);  }
                    
                    //Upsert Search Criteria
                    if (!listAdvancedSearchDetail.isEmpty()) {
                        if(Schema.sObjectType.AdvancedSearchDetail__c.isCreateable() && Schema.sObjectType.AdvancedSearchDetail__c.isUpdateable())
                        upsert listAdvancedSearchDetail;
                    }
                }
            }
            else {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, oValidationResult.getHTMLErrorMessage()));
            }
        }
        catch (Exception oException) { ApexPages.addMessages(oException);  }
    }
    
    
    /**
* Initiates a request to search for AdvancedSearchAccounts
*/
    public void searchAccounts() {
        try {
            ValidationResult oValidationResult = validateSearch();
            if (oValidationResult.IsValid) {
                SearchResults = new AdvancedSearchAccounts();
                system.debug('%%%%%%SearchResultscurrent'+SearchResults.CurrentPage);
                system.debug('%%%%SearchResults.Accounts'+SearchResults.Accounts);
                WebServiceSettings__c oWebServiceSettings = AppUtil.getWebServiceSettings(AdvancedSearchUtil.ServiceName); 
                AdvancedSearchUtil.SearchRequest oRequest = new AdvancedSearchUtil.SearchRequest();
                //oRequest.UserName = oWebServiceSettings.Username__c;  
                //oRequest.Password = oWebServiceSettings.Password__c; 
                oRequest.EndPoint = oWebServiceSettings.Endpoint__c; 
                try{
          String accessToken=DellBoomiTokenGeneration.getAuthToken();//retreives the token as part of Rocket to Dellboomi migration
          oRequest.accessToken=accessToken;
            }
                catch(Exception e){
                ApexPages.addMessages(e);
        } 
                oRequest.Timeout = (oWebServiceSettings.Timeout__c * 1000); //Convert seconds to milliseconds
                oRequest.TerritoryNumbers = new Set<string>(SelectedTerritoryNumbers);   
                oRequest.SelectFields = getSelectFieldNames();
                
                //Set Include Filters
                for (AdvancedSearchFilterBlockItem oItem : IncludeFilterBlock.ActiveItems) {
                    AdvancedSearchUtil.SearchBlock oSearchBlock = new AdvancedSearchUtil.SearchBlock(); oSearchBlock.FieldName = oItem.FieldName; oSearchBlock.JoinConditionType = AdvancedSearchUtil.JoinCondition.JoinAND;
                    
                    if (oItem.IsBetween) {
                        AdvancedSearchUtil.SearchBlockItem oSearchBlockItem1 = new AdvancedSearchUtil.SearchBlockItem();  oSearchBlockItem1.OperatorType = AdvancedSearchUtil.Operator.GreaterThanEqualTo;  oSearchBlockItem1.Values = new List<string>{ oItem.Value1 };
                            oSearchBlock.SearchBlockItems.add(oSearchBlockItem1);
                        
                        AdvancedSearchUtil.SearchBlockItem oSearchBlockItem2 = new AdvancedSearchUtil.SearchBlockItem();  oSearchBlockItem2.OperatorType = AdvancedSearchUtil.Operator.LessThanEqualTo;
                        oSearchBlockItem2.Values = new List<string>{ oItem.Value2 };
                            oSearchBlock.SearchBlockItems.add(oSearchBlockItem2);
                    }
                    else {
                        AdvancedSearchUtil.SearchBlockItem oSearchBlockItem = new AdvancedSearchUtil.SearchBlockItem(); oSearchBlockItem.OperatorType = AdvancedSearchUtil.toOperator(oItem.Operator);
                        
                        if (oItem.IsTypeList) { oSearchBlockItem.Values = AppUtil.isNull(oItem.Value1, '').split(';');   }
                        else if (oItem.IsTypeFlag) {  oSearchBlockItem.Values.add((oItem.Value1 == 'Yes') ? 'True' : 'False');    }
                        else {  oSearchBlockItem.Values = new List<string>{ oItem.Value1 };      }
                        
                        oSearchBlock.SearchBlockItems.add(oSearchBlockItem);
                    }
                    
                    oRequest.Include.add(oSearchBlock);     
                }
                
                //Set Exclude Filters
                for (AdvancedSearchFilterBlockItem oItem : ExcludeFilterBlock.ActiveItems) {
                    AdvancedSearchUtil.SearchBlock oSearchBlock = new AdvancedSearchUtil.SearchBlock();  oSearchBlock.FieldName = oItem.FieldName;   oSearchBlock.JoinConditionType = AdvancedSearchUtil.JoinCondition.JoinAND;
                    
                    if (oItem.IsBetween) {
                        AdvancedSearchUtil.SearchBlockItem oSearchBlockItem1 = new AdvancedSearchUtil.SearchBlockItem(); oSearchBlockItem1.OperatorType = AdvancedSearchUtil.Operator.GreaterThanEqualTo;
                        oSearchBlockItem1.Values = new List<string>{ oItem.Value1 };
                            oSearchBlock.SearchBlockItems.add(oSearchBlockItem1);
                        
                        AdvancedSearchUtil.SearchBlockItem oSearchBlockItem2 = new AdvancedSearchUtil.SearchBlockItem();  oSearchBlockItem2.OperatorType = AdvancedSearchUtil.Operator.LessThanEqualTo;
                        oSearchBlockItem2.Values = new List<string>{ oItem.Value2 };  oSearchBlock.SearchBlockItems.add(oSearchBlockItem2);
                    }
                    else {
                        AdvancedSearchUtil.SearchBlockItem oSearchBlockItem = new AdvancedSearchUtil.SearchBlockItem();  oSearchBlockItem.OperatorType = AdvancedSearchUtil.toOperator(oItem.Operator);
                        
                        if (oItem.IsTypeList) {  oSearchBlockItem.Values = AppUtil.isNull(oItem.Value1, '').split(';'); }
                        else if (oItem.IsTypeFlag) { oSearchBlockItem.Values.add((oItem.Value1 == 'Yes') ? 'True' : 'False');  }
                        else { oSearchBlockItem.Values = new List<string>{ oItem.Value1 }; }
                        
                        oSearchBlock.SearchBlockItems.add(oSearchBlockItem);
                    }
                    
                    oRequest.Exclude.add(oSearchBlock);     
                }
                system.debug('####SearchResultscurrent'+SearchResults.CurrentPage);
                system.debug('####SearchResults.Accounts'+SearchResults.Accounts);
                System.debug('oRequest@@@@ '+oRequest);
                //Execute Search
                AdvancedSearchUtil.SearchResponse oResponse = AdvancedSearchUtil.searchAccounts(oRequest);
                System.debug('oResponse@@@@ '+oResponse);
                if (oResponse.IsSuccess) {
                     //SearchResults.Accounts = oResponse.SearchResults;
                    // String oProfile= [select name from profile where id=:UserInfo.getProfileId()].Name;
                    
                    if(profileName=='GLI Sales User' || profileName=='GLI Sales Ops User') {
                    SearchResults.Accounts = oResponse.listcheck;
                    system.debug('####SearchResults.Accounts'+SearchResults.Accounts);
                    // system.debug('####oAdvancedSearchAccountNew'+oAdvancedSearchAccountNew);
                    //Match Salesforce Accounts to Search Results
                    Map<string, Id> mapAccounts = new Map<string, Id>();
                    Map<String,Source_System_Detail__c > MapSDDid =new Map<String,Source_System_Detail__c>();
                    
                    for(Source_System_Detail__c ssdid:[Select id,Name,Source_System_Account_Number__c,Account_Name__c FROM Source_System_Detail__c where Source_System_Account_Number__c IN :oResponse.SAPAccountNumbers]){
                        system.debug('%%%test1 :' + ssdid);
                        MapSDDid.put(ssdid.Source_System_Account_Number__c, ssdid);
                        
                    }
                    for (AdvancedSearchAccount oAdvancedSearchAccount : SearchResults.Accounts) {
                        string sSAPAccountNumber = oAdvancedSearchAccount.SAPAccountNumber;
                        
                        if (AppUtil.isEmpty(sSAPAccountNumber) == false && MapSDDid.containsKey(sSAPAccountNumber)) { oAdvancedSearchAccount.AccountId = MapSDDid.get(sSAPAccountNumber).Account_Name__c; oAdvancedSearchAccount.SSDID = MapSDDid.get(sSAPAccountNumber).Id; oAdvancedSearchAccount.SSDIDName = MapSDDid.get(sSAPAccountNumber).Name;
                            system.debug('%%%test2 :' + MapSDDid.containsKey(sSAPAccountNumber));
                            system.debug('&&&test :'+ oAdvancedSearchAccount.SSDID);
                        }
                        
                        // }
                    }
                    }
                    else {
                     SearchResults.Accounts = oResponse.SearchResults;   
                    }
                }
                else {
                    //Display error message only if exists.  
                    //If no error message exist, no results are found.
                    if(oResponse.ErrorMessage!=null && oResponse.ErrorMessage!=''){  ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, oResponse.ErrorMessage));  } } this.SearchResults.initPaging();
            }
            else {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, oValidationResult.getHTMLErrorMessage()));
            }
        }
        catch (Exception oException) {
            ApexPages.addMessages(oException);
        }
    }
    
    /**
* Initiates a request to download the current set of AdvancedSearchAccounts
*
* @return      a PageReference object
*/
    public PageReference exportAccounts() {
        PageReference oPageReference = Page.AdvancedSearchExport;
        oPageReference.setRedirect(false);
        
        return oPageReference;  
    }
    
    /**
* Adds the filter criteria specified by the user to the 
* IncludeFilterBlock object
*/
    public void addNewIncludeFilter() {
        try {
            //AdvancedSearchFilterBlockItem oNewItem = NewFilterInput.clone();  //DONT CLONE!
            AdvancedSearchFilterBlockItem oNewItem = New AdvancedSearchFilterBlockItem();
            Map<integer, string> SaveMap = New Map<integer, string>();
            
            oNewItem = NewFilterInput;
            SaveMap = NewFilterInput.FieldValuesMap;
            
            ValidationResult oValidationResult = oNewItem.validate();
            if (oValidationResult.IsValid) {
                oNewItem.AdvancedSearchDetail.FilterType__c = 'Include'; oNewItem.FieldValuesMap = New Map<integer, string>();  oNewItem.SelectedListOptions = New List<string> (); IncludeFilterBlock.AdvancedSearchFilterBlockItems.add(oNewItem);   NewFilterInput = new AdvancedSearchFilterBlockItem();  NewFilterInput.AdvancedSearchDetail.Name = oNewItem.AdvancedSearchDetail.Name;   NewFilterInput.AdvancedSearchDetail.DataType__c = oNewItem.AdvancedSearchDetail.DataType__c; NewFilterInput.AdvancedSearchDetail.Operator__c = oNewItem.AdvancedSearchDetail.Operator__c;  NewFilterInput.FieldValuesMap = SaveMap;  //Reset FilterBlockItems before adding to save memory  //Reset Filter Input      //Glenda 8/22/2012
            }
            else {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, oValidationResult.getHTMLErrorMessage()));
            }
        }
        catch (Exception oException) { ApexPages.addMessages(oException); }
    }
    
    /**
* Adds the filter criteria specified by the user to the 
* ExcludeFilterBlock object
*/
    public void addNewExcludeFilter() {
        try {
            //                      AdvancedSearchFilterBlockItem oNewItem = NewFilterInput.clone();
            AdvancedSearchFilterBlockItem oNewItem = New AdvancedSearchFilterBlockItem();
            Map<integer, string> SaveMap = New Map<integer, string>();
            
            oNewItem = NewFilterInput;
            SaveMap = NewFilterInput.FieldValuesMap;
            
            ValidationResult oValidationResult = oNewItem.validate();
            if (oValidationResult.IsValid) { oNewItem.AdvancedSearchDetail.FilterType__c = 'Exclude'; oNewItem.FieldValuesMap = New Map<integer, string>(); oNewItem.SelectedListOptions = New List<string> (); ExcludeFilterBlock.AdvancedSearchFilterBlockItems.add(oNewItem); NewFilterInput = new AdvancedSearchFilterBlockItem(); NewFilterInput.AdvancedSearchDetail.Name = oNewItem.AdvancedSearchDetail.Name; NewFilterInput.AdvancedSearchDetail.DataType__c = oNewItem.AdvancedSearchDetail.DataType__c; NewFilterInput.AdvancedSearchDetail.Operator__c = oNewItem.AdvancedSearchDetail.Operator__c; NewFilterInput.FieldValuesMap = SaveMap; 
                 //Reset FilterBlockItems before adding to save memory
//Reset Filter Input                //Glenda 8/22/2012
            }
            else {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, oValidationResult.getHTMLErrorMessage()));
            }
        }
        catch (Exception oException) {  ApexPages.addMessages(oException);  }
    }
    
    //Private Methods
    
    /**
* Modifies the filter value input state based on the user specified
* filter field and operator
*/
    @TestVisible
    private void updateFilterValueInput() {
        //Reset Values
        NewFilterInput.AdvancedSearchDetail.Value__c = null;
        NewFilterInput.AdvancedSearchDetail.ListValue__c = null;
        NewFilterInput.AdvancedSearchDetail.ListValue2__c = null;
        NewFilterInput.AdvancedSearchDetail.NumberValue1__c = null;
        NewFilterInput.AdvancedSearchDetail.NumberValue2__c = null;
        NewFilterInput.AdvancedSearchDetail.DateValue1__c = null;
        NewFilterInput.AdvancedSearchDetail.DateValue2__c = null;
        
        //Set Value Input
        string sFieldName = NewFilterInput.AdvancedSearchDetail.Name;
        AdvancedSearchUtil.FieldInfo oFieldInfo = mapFilterFields.get(sFieldName);
        //system.debug('oFieldInfo '+oFieldInfo);
        if (oFieldInfo != null) { NewFilterInput.AdvancedSearchDetail.DataType__c = oFieldInfo.FieldType;
            
            if (NewFilterInput.IsTypeList) { NewFilterInput.FieldValuesMap = new Map<integer, string>();
                
                if (oFieldInfo.ValidValues == null || oFieldInfo.ValidValues.isEmpty()) { oFieldInfo.ValidValues = getFieldValues(sFieldName);
                }
                
                integer iIndex = 0; oFieldInfo.ValidValues.sort();
                
                for (String sValue : oFieldInfo.ValidValues) {  NewFilterInput.FieldValuesMap.put(iIndex, sValue);iIndex++;}oFieldInfo.ValidValues = new List<string>();
            }
        }
        else {
            NewFilterInput.AdvancedSearchDetail.DataType__c = '';
        }
        
        //Update Operator Options
        OperatorEqual.setDisabled(false);
        OperatorLessThan.setDisabled(NewFilterInput.IsLessThanGreaterThanAllowed == false);
        OperatorGreaterThan.setDisabled(NewFilterInput.IsLessThanGreaterThanAllowed == false);
        OperatorBetween.setDisabled(NewFilterInput.IsBetweenAllowed == false);
    }
    
    /**
* Validates that the current AdvancedSearch__c contains all required
* information to perform a search
*
* @return      a ValidationResult object
*/
     @TestVisible    
    private ValidationResult validateSearch() {
        ValidationResult oValidationResult = new ValidationResult();
        oValidationResult.IsValid = true;
        
        boolean bIsMissingTerritory = AppUtil.isEmpty(oAdvancedSearch.TerritoryFilter__c);
        system.debug('@@bIsMissingTerritory'+bIsMissingTerritory);
        if (bIsMissingTerritory) {
            oValidationResult.IsValid = false;
            oValidationResult.Failures.add(System.Label.You_must_select_at_least_one_territory);
        }
        
        boolean bHasIncludes = (IncludeFilterBlock.ActiveItems.isEmpty() == false);
        boolean bHasExcludes = (ExcludeFilterBlock.ActiveItems.isEmpty() == false);
        
        if (!bHasIncludes && !bHasExcludes) {
            oValidationResult.IsValid = false;
            oValidationResult.Failures.add(System.Label.You_must_add_at_least_one_include_or_exclude_filter);
        }
        
        return oValidationResult;
    }
    
    /**
* Validates that the current AdvancedSearch__c contains all required
* information to save the object
*
* @return      a ValidationResult object
*/
    private ValidationResult validateSave() {
        ValidationResult oValidationResult = validateSearch();
        
        boolean bIsMissingName = AppUtil.isEmpty(oAdvancedSearch.Name);
        if (bIsMissingName) {
            oValidationResult.IsValid = false;
            oValidationResult.Failures.add(System.Label.Search_name_is_required);
        }
        
        return oValidationResult;
    }
    
    /**
* Loads territory numbers based on the current user or the owner of the current
* AdvancedSearch__c object
*/
    private void loadTerritoryNumbers() {
        TerritoryHierarchy oTerritoryHierarchy = new TerritoryHierarchy();
        
        Id userId = (oAdvancedSearch.OwnerId == null) ? UserInfo.getUserId() : oAdvancedSearch.OwnerId;
        
        listMyTerritoryNumbers = new List<string>(oTerritoryHierarchy.getActiveTMSTerritoryNumbersByUserId(userId));
        listAllTerritoryNumbers = new List<string>(oTerritoryHierarchy.getTMSTerritoryNumbers());
        listTeamTerritoryNumbers = new List<string>(oTerritoryHierarchy.getActiveTeamTMSTerritoryNumbersByUserId(userId));
        //listTeamTerritoryNumbers = new List<string>(oTerritoryHierarchy.getActiveTeamTMSTerritoryNumbersByUserId(userId));
        
        if (AppUtil.isEmpty(oAdvancedSearch.TerritoryFilter__c) == true) {
            //Default Selected to User's Territory Numbers
            string sTerritoryNumbers = '';
            
            for (string sTerritoryNumber : listMyTerritoryNumbers) {sTerritoryNumbers += sTerritoryNumbers.length() == 0 ? '' : ';';sTerritoryNumbers += sTerritoryNumber;
            }
            
            oAdvancedSearch.TerritoryFilter__c = sTerritoryNumbers;
        }
    }
    
    /**
* Loads existing include and exclude filter data
*/
    private void loadAdvancedSearchDetails() {
        IncludeFilterBlock = new AdvancedSearchFilterBlock();
        ExcludeFilterBlock = new AdvancedSearchFilterBlock();
        
        for (AdvancedSearchDetail__c oAdvancedSearchDetail : queryAdvancedSearchDetail(oAdvancedSearch.Id)) {
            AdvancedSearchFilterBlockItem oAdvancedSearchFilterBlockItem = new AdvancedSearchFilterBlockItem(oAdvancedSearchDetail);
            
            if (oAdvancedSearchDetail.FilterType__c == 'Include') {
                IncludeFilterBlock.AdvancedSearchFilterBlockItems.add(oAdvancedSearchFilterBlockItem);
            }
            else if (oAdvancedSearchDetail.FilterType__c == 'Exclude') {
                ExcludeFilterBlock.AdvancedSearchFilterBlockItems.add(oAdvancedSearchFilterBlockItem);
            }
        }
    }
    
    /**
* Loads filterable and selectable fields utilizing the AdvancedSearchWS web service
*/
    @TestVisible    
    private void loadAdvancedSearchFields() {
        mapFilterFields = new Map<string, AdvancedSearchUtil.FieldInfo>();
        mapSelectFields = new Map<string, AdvancedSearchUtil.FieldInfo>();
        
        FilterFields = new List<SelectOption>();
        FilterFields.add(new SelectOption('', Label.None));
        
        WebServiceSettings__c oWebServiceSettings = AppUtil.getWebServiceSettings(AdvancedSearchUtil.ServiceName);
        AdvancedSearchUtil.FieldInfoRequest oRequest = new AdvancedSearchUtil.FieldInfoRequest();
        //oRequest.UserName = oWebServiceSettings.Username__c;
        //oRequest.Password = oWebServiceSettings.Password__c;
        oRequest.EndPoint = oWebServiceSettings.Endpoint__c;
        try{
          String accessToken=DellBoomiTokenGeneration.getAuthToken();//retreives the token as part of Rocket to Dellboomi migration
          oRequest.accessToken=accessToken;
            }
                catch(Exception e){
                ApexPages.addMessages(e);
        } 
        oRequest.Timeout = (oWebServiceSettings.Timeout__c * 1000); //Convert seconds to milliseconds
        oRequest.UseInSelect = true;
        oRequest.UseInBlock = true;
        //oRequest.TerritoryNumbers = SelectedTerritoryNumbers;
        System.debug('oRequest@@@'+oRequest);
        AdvancedSearchUtil.FieldInfoResponse oResponse = AdvancedSearchUtil.getAdvancedSearchFields(oRequest);
        System.debug('oResponse@@@'+oResponse);
        if (oResponse.IsSuccess) {for (AdvancedSearchUtil.FieldInfo oFieldInfo : oResponse.Fields) { if (oFieldInfo.UseInSelect) { mapSelectFields.put(oFieldInfo.Name, oFieldInfo);
                }
                
                if (oFieldInfo.UseInBlock && oFieldInfo.Name != Label.Territory) { mapFilterFields.put(oFieldInfo.Name, oFieldInfo); FilterFields.add(new SelectOption(oFieldInfo.Name, oFieldInfo.Name));
                }
                
            }
            system.debug('after put @@@@@mapFilterFields.values()'+mapFilterFields.values());
            filterFields.sort();
        }
        else {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, oResponse.ErrorMessage));
        }
    }
    
    /**
* Gets field values for the specified field name
*/
    @TestVisible 
    private List<string> getFieldValues(string sFieldName) {
        List<string> listFieldValues = new List<string>();
        
        WebServiceSettings__c oWebServiceSettings = AppUtil.getWebServiceSettings(AdvancedSearchUtil.ServiceName);
        AdvancedSearchUtil.FieldValueRequest oRequest = new AdvancedSearchUtil.FieldValueRequest();
        //oRequest.UserName = oWebServiceSettings.Username__c;
        //oRequest.Password = oWebServiceSettings.Password__c;
        oRequest.EndPoint = oWebServiceSettings.Endpoint__c;
        try{
          String accessToken=DellBoomiTokenGeneration.getAuthToken();//retreives the token as part of Rocket to Dellboomi migration
          oRequest.accessToken=accessToken;
            }
                catch(Exception e){
                ApexPages.addMessages(e);
        } 
        oRequest.Timeout = (oWebServiceSettings.Timeout__c * 1000); //Convert seconds to milliseconds
        oRequest.TerritoryNumbers = new Set<string>(SelectedTerritoryNumbers);
        oRequest.SearchFieldNames = new List<string>{ sFieldName };
            
            AdvancedSearchUtil.FieldValueResponse oResponse = AdvancedSearchUtil.getAdvancedSearchFieldValues(oRequest);
        //      system.debug('oResponse '+oResponse);
        if (oResponse.IsSuccess) { if (oResponse.FieldValues.containsKey(sFieldName)) { listFieldValues = oResponse.FieldValues.get(sFieldName); }listFieldValues.sort();
        }
        else {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, oResponse.ErrorMessage));
        }
        
        return listFieldValues;
    }
    
    /**
* Retrieves available options based on the users territory view
* selection
*
* @return a list of SelectOption objects
*/
    @TestVisible
    private List<SelectOption> getAvailableTerritoryOptions() {
        List<SelectOption> listOptions = new List<SelectOption>();
        
        TerritoryView = AppUtil.isNull(TerritoryView, TerritoryTypeAll);
        
        List<string> listValues = new List<string>();
        if (TerritoryView == TerritoryTypeAll) {
            listValues = listAllTerritoryNumbers;   
        }       
        else if (TerritoryView == TerritoryTypeMy) {
            listValues = listMyTerritoryNumbers;
        }
        else if (TerritoryView == TerritoryTypeTeam) {
            listValues = listTeamTerritoryNumbers;
        }
        listValues.sort();
        
        return toSelectOptions(filterValues(listValues, SelectedTerritoryNumbers));
    }
    
    /**
* Creates a list of field names based on the values in the mapSelectFields variable
*
* @return      a list of strings
*/
    @TestVisible
    private Set<string> getSelectFieldNames() {
        Set<string> listFieldNames = new Set<string>();
        for (AdvancedSearchUtil.FieldInfo oFieldInfo : mapSelectFields.values()) {
            if (oFieldInfo.UseInSelect) {
                listFieldNames.add(oFieldInfo.Name);
            }       
        }
        
        return listFieldNames;
    }
    
    /**
* Parses the semi-colon delimited list of territory filter values
* as a set of strings
*
* @return      a list of strings
*/
    private List<string> parseTerritoryNumbers() {
        Set<string> setValues = new Set<string>();
        
        string sValues = oAdvancedSearch.TerritoryFilter__c;
        if (AppUtil.isEmpty(sValues) == false) {
            String[] listValues = sValues.split(';');
            
            for (string sValue : listValues) {
                setValues.add(sValue);
            }
        }
        List<string> listValues = new List<string>(setValues);
        listValues.sort();
        
        return listValues;
    }
    
    /**
* Filters the specified list of values by removing values that match what is specified in
* the list of ignore values
*
* @param       listValues                      a list of string values
* @param       listIgnoreValues        a list of string values to exclude from the listValues list
* @return      a list of strings
*/
    private List<string> filterValues(List<string> listValues, List<string> listIgnoreValues) {
        List<string> listAvailableValues = new List<string>();
        
        if (listValues != null && listIgnoreValues != null) {
            Set<string> setIgnoreValues = new Set<string>(listIgnoreValues);
            
            for (string sValue : listValues) {
                if (setIgnoreValues.contains(sValue) == false) {
                    listAvailableValues.add(sValue);
                }
            }
        }
        listAvailableValues.sort();
        
        return listAvailableValues;
    }
    
    /**
* Converts the specified list of strings into SelectObject objects
*
* @return      a list of SelectOption objects
*/
    private List<SelectOption> toSelectOptions(List<string> listValues) {
        List<SelectOption> listSelectOptions = new List<SelectOption>();
        
        if (listValues != null) {
            for (string sValue : listValues) {
                listSelectOptions.add(new SelectOption(sValue, sValue));
            }
        }
        
        if (listSelectOptions.isEmpty() == true) {
            listSelectOptions.add(new SelectOption('--None--','--None--'));
        }
        
        return listSelectOptions;
    }
    
    /**
* Queries the database for AdvancedSearchDetail__c objects associated with the 
* specified AdvancedSearch__c object id
*
* @param       advancedSearchId        an AdvancedSearch__c object id
* @return      a list of AdvancedSearchDetail__c objects
*/
    private List<AdvancedSearchDetail__c> queryAdvancedSearchDetail(Id advancedSearchId) {
        List<AdvancedSearchDetail__c>  queryAdvancedSearchDetail = new List<AdvancedSearchDetail__c>();
        if(Schema.sObjectType.AdvancedSearchDetail__c.isAccessible())
        queryAdvancedSearchDetail = [SELECT 
                Id
                , Name
                , Index__c
                , FilterType__c
                , Operator__c
                , DataType__c
                , Value__c 
                , DateValue1__c
                , DateValue2__c
                , NumberValue1__c
                , NumberValue2__c
                , AdvancedSearch__c
                , ListValue__c 
                , ListValue2__c 
                FROM 
                AdvancedSearchDetail__c 
                WHERE 
                AdvancedSearch__c = :advancedSearchId
                ORDER BY
                FilterType__c
                , Index__c];
            return queryAdvancedSearchDetail;
    }
    // Arti: List to hold selected record from advanced search results.
    public List<AdvancedSearchAccount> oAdvancedSearcSelected{get;set;}
    Public Set<String> sapAccNo {get;set;}
    /**Arti - 
* CRM-11595 display the selcted records from advance search results page.
* @param  None
* @returns PageReference
*/  
    Public PageReference massLeadCreation1(){
        if(!SearchResults.Accounts.isEmpty()){ for (AdvancedSearchAccount oAdvancedSearchAccount : SearchResults.Accounts) { if(oAdvancedSearchAccount.bSelected){ AdvancedSearchAccount adc1= new AdvancedSearchAccount(); adc1= oAdvancedSearchAccount; oAdvancedSearcSelected.add(adc1);
                    
                }
            }
        }
        system.debug('sapAccNo->'+sapAccNo );
        system.debug('oAdvancedSearcSelected->'+oAdvancedSearcSelected );
        
        if(!oAdvancedSearcSelected.isEmpty()){
            PageReference pg= new PageReference('/apex/massLeaddatapage?adcid='+recordId);
            pg.setRedirect(false);
            return pg;
        }
        else {
            return null;
            
        }
    }
    
    /**Arti - 
* CRM-11595 request to cancel mass lead creation process 
* @param  None
* @returns PageReference
*/  
    Public PageReference cancel(){
        PageReference pg =new PageReference('/apex/AdvancedSearch?id='+recordId);
        pg.setRedirect(true);
        return pg;
    }
    
    /**Arti - 
* CRM-11595 request to create mass lead records.
* @param  None
* @returns PageReference
*/  
    Public PageReference saveLead(){
        List<Lead> listLead= new List<Lead>();        
        Map<String, Source_System_Detail__c> oMapSource= new Map<String,Source_System_Detail__c>();
        map<id,Contact> mapContid =new map<id,Contact>();
        set<string> sSAPAccountNumber = new Set<String>(); 
        Set<String> accountnameids = new Set<String>();
        for(AdvancedSearchAccount ac:oAdvancedSearcSelected){
            sSAPAccountNumber.add(ac.SAPAccountNumber); 
        }
        List<Source_System_Detail__c> listSourceSystem = new List<Source_System_Detail__c>();
        if(Schema.sObjectType.Source_System_Detail__c.isAccessible())
        listSourceSystem= [select id,
    Source_System_Account_Number__c,
    Account_Name__c
    from Source_System_Detail__c
    where Source_System_Account_Number__c IN:sSAPAccountNumber LIMIT 50000];
        if(!listSourceSystem.isEmpty()){
            for(Source_System_Detail__c sc: listSourceSystem){
                oMapSource.put(sc.Source_System_Account_Number__c, sc); 
                accountnameids.add(sc.Account_Name__c);         
            }
        }
        system.debug('oMapSource""""""'+oMapSource);
      
        if(!oMapSource.values().isempty()){
            List<Contact> conList = new List<Contact>();
            if(Schema.sObjectType.Contact.isAccessible())
            conList=  [select
        id,
        name,
        accountId,
        salutation, 
        FirstName, 
        LastName,
        SAP_Contact_ID__c
        from
        Contact
        where
        accountId   IN:accountnameids ];
            //if(conList.size()>0){
            for(Contact a:conList){  
                mapContid.put(a.accountid, a);
          }
          }
        system.debug('$$$$$oAdvancedSearcSelected'+oAdvancedSearcSelected.size());
        
        if(!oAdvancedSearcSelected.isEmpty()){
            system.debug('@@test');
            for(AdvancedSearchAccount oRecord: oAdvancedSearcSelected){
                string sSAPAccountNumber1 = oRecord.SAPAccountNumber;
                String str= oRecord.name;
                Lead objLead= new Lead();
                    objLead.Description = oRecord.SAPAccountNumber;
                    objLead.Company= oRecord.name;
                    objLead.status= 'Unworked';
                    objLead.Source__c= 'Advance Search'; 
                    objLead.LastName= str.split(' ').get(1);
                    objLead.FirstName= str.split(' ').get(0);
                if(oMapSource.containsKey(oRecord.SAPAccountNumber)){
                    //objLead.Account__c = oMapSource.get(sSAPAccountNumber1).Account_Name__c;
                    objLead.Account__c = oRecord.AccountId;
                    objLead.Description = oRecord.SAPAccountNumber;
                    objLead.Company= oRecord.name;
                    objLead.status= 'Unworked';
                    objLead.Source__c= 'Advance Search';
                    objLead.LastName= str.split(' ').get(1);
                    objLead.FirstName= str.split(' ').get(0);
                    
                    if(mapContid.Values().size()>0){
                        //if(mapContid.containsKey(oRecord.AccountId)){
                        for(Contact c: mapContid.Values()){
                            if(c.accountid==oRecord.AccountId){ objLead.contact__c=c.Id ;    objLead.Contact_SAP_ID__c=c.SAP_Contact_ID__c;
                        }
                       // }
                    }
                    }
                    else {
                    objLead.contact__c='';    
                    }
                    system.debug('mapContid11 :'+mapContid.size());
                }  //Else part is moved above the if part where thye values are getting set by default.
              /*   else { 
                    objLead.Description = oRecord.SAPAccountNumber;
                    objLead.Company= oRecord.name;
                    objLead.status= 'Unworked';
                    objLead.Source__c= 'Advance Search'; 
                    objLead.LastName= str.split(' ').get(1);
                    objLead.FirstName= str.split(' ').get(0);
                }  */
                listLead.add(objLead); 
            }       
            if(!listLead.isEmpty())
            {
                try{
                    if(Schema.sObjectType.Lead.isCreateable())
                    insert listLead;
                    
                }
                catch(Exception objException){ Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'objException-'+objException)); system.debug('listLead'); return null; }
            }
            Schema.DescribeSObjectResult c = Lead.sObjectType.getDescribe();
            String prefix= c.getKeyPrefix();
            PageReference pg =new PageReference('/'+prefix+'?id='+Label.LeadList_View_Id);
            pg.setRedirect(true);       
            return pg;
        }
        return null;
    }
    
}