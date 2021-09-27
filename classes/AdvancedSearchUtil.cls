/**
 * Provides methods helper methods for working with the AdvancedSearchWS web service
 *
 * @author  John De Santiago
 * @version 2012-07-23
 */

/**
 * CHANGE HISTORY
 * =============================================================================
 * Date         Name                    Description
 * 2012-07-23   John De Santiago        Created                                                           
 * 2012-07-25   Glenda Ninan            Updated   
 * 2013-04-24   Nandita Shet            QC #3702 - Add field Number Of Attorneys - Org     
 * 2018-02-20   Arti Choudhari          [CRM-11595]- Mdified code in inner class- SearchResponse
 *                                      Data filtering for GLI on Advanced Serach resultes 
 * 2020-4-1     Shyamsundar Shet        BMP-1591 - Inserted the Token generation operation as part of Rocket services to Dellboomi migration

 * =============================================================================
 */
public without sharing class AdvancedSearchUtil {
    //Protected Members
    public static final string serviceName = 'AdvancedSearchService';
    public static final string runSearchMethod = 'SearchAccounts';
    public static final string getSearchParmValuesMethod = 'GetFieldValues';
    public static final string getSearchParamMethod = 'GetFields';
    
    @TestVisible 
    private static final string application = 'SFDC';
    @TestVisible 
    private static final string businessUnit = 'LEGAL';
    @TestVisible 
    private static final string searchName = 'ADVANCED SEARCH';
    
    private static final string ListFieldType = 'List';
    private static final string IncludeIndicator = 'I';
    private static final string ExcludeIndicator = 'E';
    private static final string JoinConditionAND = 'AND';
    private static final string JoinConditionOR = 'OR';
    private static final string SortASC = 'ASC';
    private static final string SortDESC = 'DESC';
    private static final string OperatorEqual = 'EQ';
    private static final string OperatorLessThan = 'LT';
    private static final string OperatorGreaterThan = 'GT';
    private static final string OperatorLessThanEqualTo = 'LTE';
    private static final string OperatorGreaterThanEqualTo = 'GTE';
    private static final string OperatorBetween = 'BT';
    private static final string OperatorEqualLabel = 'Equal';
    private static final string OperatorLessThanLabel = 'LessThan';
    private static final string OperatorGreaterThanLabel = 'GreaterThan';
    private static final string OperatorLessThanEqualToLabel = 'LessThanEqualTo';
    private static final string OperatorGreaterThanEqualToLabel = 'GreaterThanEqualTo';
    private static final string OperatorBetweenLabel = 'Between';
    
    //Public Methods
    /**
     * Initiates a web service request to retrive AdvancedSearchWS field information
     *
     * @param   oRequest    an instance of a FieldInfoRequest object
     * @return  a FieldInfoResponse object
     */
    public static FieldInfoResponse getAdvancedSearchFields(FieldInfoRequest oRequest) {
        FieldInfoResponse oResponse = new FieldInfoResponse();
        Set<String> listTerritories = New Set<String> (); 
        try {
            ValidationResult oValidationResult = validateFieldInfoRequest(oRequest);
            if (oValidationResult.IsValid) {
                system.debug('@123 '+oValidationResult.IsValid);
                //Initialize Web Service
                //string sAuthorizationHeader = 'Basic ' + EncodingUtil.base64Encode( Blob.valueOf(oRequest.Username+':'+oRequest.Password));
                AdvancedSearchWS.AdvancedSearch_v1_0Port oService = new AdvancedSearchWS.AdvancedSearch_v1_0Port();
                oService.inputHttpHeaders_x = new Map<String, String>();
                try{
                string sAuthorizationHeader = 'Bearer ' + oRequest.accessToken;//retreives the token as part of Rocket to Dellboomi migration
                             
                oService.inputHttpHeaders_x.put('Authorization', sAuthorizationHeader);
                }
                catch(Exception e){
            ApexPages.addMessages(e);
    } 
                oService.timeout_x = oRequest.Timeout.intValue();
                oService.endpoint_x = oRequest.EndPoint;
                System.debug('getAdvancedSearchFields.Endpoint: ' + oRequest.EndPoint);
                
                //Get Fields
                AdvancedSearchWS.SearchParm[] oSearchParmResponse = oService.GetSearchParms(application
                    , businessUnit
                    , searchName
                    , oRequest.UseInSelect
                    , oRequest.UseInBlock);
                   system.debug('&&&&oSearchParmResponse'+oSearchParmResponse); 
                oResponse.parse(oSearchParmResponse);
            }
            else {
                oResponse.parse(oValidationResult);
            }
        }
        catch (CalloutException oException) {
            oResponse.parse(oException);
        }
        catch (Exception oException) {
            oResponse.parse(oException);
        }
        
        return oResponse;
    }
    
    public static FieldValueResponse getAdvancedSearchFieldValues(FieldValueRequest oRequest) {
        FieldValueResponse oResponse = new FieldValueResponse();
        Set<String> listTerritories = New Set<String> (); 
        try {
            ValidationResult oValidationResult = validateFieldValueRequest(oRequest);
            if (oValidationResult.IsValid) {
                //Initialize Web Service
                //string sAuthorizationHeader = 'Basic ' + EncodingUtil.base64Encode( Blob.valueOf(oRequest.Username+':'+oRequest.Password));
                AdvancedSearchWS.AdvancedSearch_v1_0Port oService = new AdvancedSearchWS.AdvancedSearch_v1_0Port();
                
                
                oService.inputHttpHeaders_x = new Map<String, String>();
                try{
                string sAuthorizationHeader = 'Bearer ' + oRequest.accessToken;//retreives the token as part of Rocket to Dellboomi migration
                oService.inputHttpHeaders_x.put('Authorization', sAuthorizationHeader);
                }
                catch(Exception e){
            ApexPages.addMessages(e);
    } 
                oService.timeout_x = oRequest.Timeout.intValue();
                oService.endpoint_x = oRequest.EndPoint;
                System.debug('getAdvancedSearchFields.Endpoint: ' + oRequest.EndPoint);
                
                //Get Field Values
                if (oRequest.SearchFieldNames.isEmpty() == false && oRequest.TerritoryNumbers != null) {
                    //Set Territory Block
                    List<AdvancedSearchWS.SearchBlock> listSearchBlocks = new List<AdvancedSearchWS.SearchBlock>();
                    AdvancedSearchWS.SearchBlock oTerritorySearchBlock = new AdvancedSearchWS.SearchBlock();
                    listSearchBlocks.add(oTerritorySearchBlock);
                    
                    oTerritorySearchBlock.IncludeExcludeInd = IncludeIndicator;
                    oTerritorySearchBlock.ParmName = 'Territory';
                    oTerritorySearchBlock.SearchSetJoinCondition = JoinConditionAND;
                    oTerritorySearchBlock.SearchSet = new List<AdvancedSearchWS.SearchSet>();
                    
                    AdvancedSearchWS.SearchSet oTerritorySearchSet = new AdvancedSearchWS.SearchSet();
                    oTerritorySearchSet.SearchMemberJoinCondition = JoinConditionOR;
                    oTerritorySearchSet.SearchMember = new List<AdvancedSearchWS.SearchMember>();   
                    oTerritorySearchBlock.SearchSet.add(oTerritorySearchSet);
                    
                    If (oRequest.TerritoryNumbers.IsEmpty() == false) {
                        listTerritories = oRequest.TerritoryNumbers;
                        for (string sTerritoryNumber : listTerritories) {
                            AdvancedSearchWS.SearchMember oSearchMember = new AdvancedSearchWS.SearchMember();
                            oTerritorySearchSet.SearchMember.add(oSearchMember);
                    
                            oSearchMember.Operator = getOperatorValue(Operator.Equal);
                            oSearchMember.ParmValue = sTerritoryNumber;
                        }
                    }
//                  system.debug('listSearchBlocks '+listSearchBlocks);
                    AdvancedSearchWS.SearchParmItem[] oSearchParmItemResponse = oService.GetSearchParmValues(application
                    , businessUnit
                    , searchName
                    , oRequest.SearchFieldNames
                    , listSearchBlocks);
                    
//                  system.debug('oSearchParmItemResponse '+oSearchParmItemResponse);
                    oResponse.parse(oSearchParmItemResponse);
                    system.debug('oResponse '+oResponse);
                }
            }
            else {
                oResponse.parse(oValidationResult);
            }
        }
        catch (CalloutException oException) {
            oResponse.parse(oException);
        }
        catch (Exception oException) {
            oResponse.parse(oException);
        }
        
        return oResponse;
    }
    
    /**
     * Initiates a web service request to search accounts utilizing the AdvancedSearchWS web service
     *
     * @param   oRequest    an instance of a SearchRequest object
     * @return  a SearchResponse object
     */
    public static SearchResponse searchAccounts(SearchRequest oRequest) {
        SearchResponse oResponse = new SearchResponse();
        
        try {
            ValidationResult oValidationResult = validateSearchRequest(oRequest);
            if (oValidationResult.IsValid) {
                //Initialize Web Service
                //string sAuthorizationHeader = 'Basic ' + EncodingUtil.base64Encode( Blob.valueOf(oRequest.Username+':'+oRequest.Password));
                AdvancedSearchWS.AdvancedSearch_v1_0Port oService = new AdvancedSearchWS.AdvancedSearch_v1_0Port();
                
                
                oService.inputHttpHeaders_x = new Map<String, String>();
                try{
                string sAuthorizationHeader = 'Bearer ' + oRequest.accessToken;//retreives the token as part of Rocket to Dellboomi migration
                oService.inputHttpHeaders_x.put('Authorization', sAuthorizationHeader);
                }
                catch(Exception e){
            ApexPages.addMessages(e);
    } 
                oService.timeout_x = oRequest.Timeout.intValue();
                oService.endpoint_x = oRequest.EndPoint;
                System.debug('searchAccounts.Endpoint: ' + oRequest.EndPoint);
                
                //Build Search Grid
                AdvancedSearchWS.SearchGrid oSearchGrid = new AdvancedSearchWS.SearchGrid();
                oSearchGrid.SelectParmName = new List<string>(oRequest.SelectFields);
                oSearchGrid.SortParm = new List<AdvancedSearchWS.SortParm>();
                oSearchGrid.SearchBlock = new List<AdvancedSearchWS.SearchBlock>();
                                
                //Set Default Sort
                AdvancedSearchWS.SortParm oSortParm = new AdvancedSearchWS.SortParm();
                oSearchGrid.SortParm.add(oSortParm);
                
                oSortParm.ParmName = oRequest.SortBy;
                oSortParm.SortDirection = getSortDirectionValue(oRequest.SortDirectionType);
                
                //Set Territory Block
                AdvancedSearchWS.SearchBlock oTerritorySearchBlock = new AdvancedSearchWS.SearchBlock();
                oSearchGrid.SearchBlock.add(oTerritorySearchBlock);
                
                oTerritorySearchBlock.IncludeExcludeInd = IncludeIndicator;
                oTerritorySearchBlock.ParmName = 'Territory';
                oTerritorySearchBlock.SearchSetJoinCondition = JoinConditionAND;
                oTerritorySearchBlock.SearchSet = new List<AdvancedSearchWS.SearchSet>();
                
                AdvancedSearchWS.SearchSet oTerritorySearchSet = new AdvancedSearchWS.SearchSet();
                oTerritorySearchSet.SearchMemberJoinCondition = JoinConditionOR;
                oTerritorySearchSet.SearchMember = new List<AdvancedSearchWS.SearchMember>();   
                oTerritorySearchBlock.SearchSet.add(oTerritorySearchSet);
                
                If (oRequest.TerritoryNumbers != null) {
                    for (string sTerritoryNumber : oRequest.TerritoryNumbers) {
                        AdvancedSearchWS.SearchMember oSearchMember = new AdvancedSearchWS.SearchMember();
                        oTerritorySearchSet.SearchMember.add(oSearchMember);
                        
                        oSearchMember.Operator = getOperatorValue(Operator.Equal);
                        oSearchMember.ParmValue = sTerritoryNumber;
                    }
                }
                
                //Set Include Block
                AdvancedSearchWS.SearchBlock oIncludeBlock = new AdvancedSearchWS.SearchBlock();
                Map<String, AdvancedSearchWS.SearchBlock> mapFieldIncludeBlock =  New Map<String, AdvancedSearchWS.SearchBlock> ();
                for (SearchBlock oSearchBlock : oRequest.Include) {
                    If (!mapFieldIncludeBlock.ContainsKey(oSearchBlock.FieldName)) {
                        oIncludeBlock = new AdvancedSearchWS.SearchBlock();
                        oIncludeBlock.IncludeExcludeInd = IncludeIndicator;
                        oIncludeBlock.ParmName = oSearchBlock.FieldName;
                        oIncludeBlock.SearchSetJoinCondition = getJoinConditionValue(oSearchBlock.JoinConditionType);
                        oSearchGrid.SearchBlock.add(oIncludeBlock);
                        oIncludeBlock.SearchSet = new List<AdvancedSearchWS.SearchSet>();
                    }
                    else {
                        oIncludeBlock = mapFieldIncludeBlock.get(oSearchBlock.FieldName);   
                    }           
                    for (SearchBlockItem oSearchBlockItem : oSearchBlock.SearchBlockItems) {
                        AdvancedSearchWS.SearchSet oSearchSet = new AdvancedSearchWS.SearchSet();
                        oIncludeBlock.SearchSet.add(oSearchSet);
                        
                        oSearchSet.SearchMemberJoinCondition = JoinConditionOR;
                        oSearchSet.SearchMember = new List<AdvancedSearchWS.SearchMember>();    
                        for (string sValue : oSearchBlockItem.Values) {
                            AdvancedSearchWS.SearchMember oSearchMember = new AdvancedSearchWS.SearchMember();
                            oSearchSet.SearchMember.add(oSearchMember);
                            
                            oSearchMember.Operator = getOperatorValue(oSearchBlockItem.operatorType);
                            oSearchMember.ParmValue = sValue;
                        }
                    }
//                  system.debug('oIncludeBlock '+oIncludeBlock);
                    mapFieldIncludeBlock.put(oSearchBlock.FieldName,oIncludeBlock); 
//                  system.debug('mapFieldIncludeBlock '+mapFieldIncludeBlock);
                }   

                //Set Exclude Block
                AdvancedSearchWS.SearchBlock oExcludeBlock = new AdvancedSearchWS.SearchBlock();
                Map<String, AdvancedSearchWS.SearchBlock> mapFieldExcludeBlock =  New Map<String, AdvancedSearchWS.SearchBlock> ();
                for (SearchBlock oSearchBlock : oRequest.Exclude) {
                    If (!mapFieldExcludeBlock.ContainsKey(oSearchBlock.FieldName)) {
                        oExcludeBlock = new AdvancedSearchWS.SearchBlock();
                        oExcludeBlock.IncludeExcludeInd = ExcludeIndicator;
                        oExcludeBlock.ParmName = oSearchBlock.FieldName;
                        oExcludeBlock.SearchSetJoinCondition = getJoinConditionValue(oSearchBlock.JoinConditionType);
                        oSearchGrid.SearchBlock.add(oExcludeBlock);
                        oExcludeBlock.SearchSet = new List<AdvancedSearchWS.SearchSet>();
                    }
                    else {
                        oExcludeBlock = mapFieldExcludeBlock.get(oSearchBlock.FieldName);   
                    }           
                    for (SearchBlockItem oSearchBlockItem : oSearchBlock.SearchBlockItems) {
                        AdvancedSearchWS.SearchSet oSearchSet = new AdvancedSearchWS.SearchSet();
                        oExcludeBlock.SearchSet.add(oSearchSet);
                        
                        oSearchSet.SearchMemberJoinCondition = JoinConditionOR;
                        oSearchSet.SearchMember = new List<AdvancedSearchWS.SearchMember>();    
                        for (string sValue : oSearchBlockItem.Values) {
                            AdvancedSearchWS.SearchMember oSearchMember = new AdvancedSearchWS.SearchMember();
                            oSearchSet.SearchMember.add(oSearchMember);
                            
                            oSearchMember.Operator = getOperatorValue(oSearchBlockItem.operatorType);
                            oSearchMember.ParmValue = sValue;
                        }
                    }
//                  system.debug('oExcludeBlock '+oExcludeBlock);
                    mapFieldExcludeBlock.put(oSearchBlock.FieldName,oExcludeBlock); 
//                  system.debug('mapFieldExcludeBlock '+mapFieldExcludeBlock);
                }   
    
                system.debug('oSearchGrid.SearchBlock '+oSearchGrid.SearchBlock);               
                //Run Search
                AdvancedSearchWS.SearchResult oSearchResultResponse = oService.RunSearch(application
                    , businessUnit
                    , searchName
                    , oRequest.MaxResults
                    , oSearchGrid);
                    
                oResponse.parse(oSearchResultResponse);
            }
            else {
                oResponse.parse(oValidationResult);
            }
        }
        catch (CalloutException oException) {
            oResponse.parse(oException);
        }
        catch (Exception oException) {
            oResponse.parse(oException);
        }
        
        return oResponse;
    }
    
    /**
     * Gets an Operator enum for the specified text
     *
     * @param   sValue  a string to translate to an enum
     * @return  an Operator enum
     */
    public static Operator toOperator(string sValue) {
        if (OperatorEqual.equals(sValue) || OperatorEqualLabel.equals(sValue)) {
            return Operator.Equal;
        }
        else if (OperatorLessThan.equals(sValue) || OperatorLessThanLabel.equals(sValue)) {
            return Operator.LessThan;
        }
        else if (OperatorGreaterThan.equals(sValue) || OperatorGreaterThanLabel.equals(sValue)) {
            return Operator.GreaterThan;
        }
        else if (OperatorBetween.equals(sValue) || OperatorBetweenLabel.equals(sValue)) {
            return Operator.Between;
        }
        else if (OperatorLessThanEqualTo.equals(sValue) || OperatorLessThanEqualToLabel.equals(sValue)) {
            return Operator.LessThanEqualTo;
        }
        else if (OperatorGreaterThanEqualTo.equals(sValue) || OperatorGreaterThanEqualToLabel.equals(sValue)) {
            return Operator.GreaterThanEqualTo;
        }
        else {
            return Operator.Equal;
        }
    }
    
    /**
     * Gets the web service value for the specified Operator enum
     *
     * @param   eOperator   an Operator enum
     * @return  a string
     */
    public static string getOperatorValue(Operator eOperator) {
        if (eOperator == Operator.Equal) {
            return OperatorEqual;
        }
        else if (eOperator == Operator.LessThan) {
            return OperatorLessThan;
        }
        else if (eOperator == Operator.GreaterThan) {
            return OperatorGreaterThan;
        }
        else if (eOperator == Operator.Between) {
            return OperatorBetween;
        }
        else if (eOperator == Operator.LessThanEqualTo) {
            return OperatorLessThanEqualTo;
        }
        else if (eOperator == Operator.GreaterThanEqualTo) {
            return OperatorGreaterThanEqualTo;
        }
        else {
            return OperatorEqual;
        }
    }
    
    //Private Methods
    
    /**
     * Validates that all required information has been supplied for the specified request
     * 
     * @param   oRequest an instance of a Request object to validate
     * @returns a instance of a ValidationResult object representing the results of the validation
     */
    private static ValidationResult validateRequest(Request oRequest) {
        ValidationResult oValidationResult = new ValidationResult();
        oValidationResult.IsValid = true;
        
        if (oRequest != null) {
            //Validate Request Credentials
            boolean isMissingEndPoint = AppUtil.isEmpty(oRequest.EndPoint);
            //boolean isMissingUsername = AppUtil.isEmpty(oRequest.Username);
            //boolean isMissingPassword = AppUtil.isEmpty(oRequest.Password);
            boolean isMissingaccessToken = String.isEmpty(oRequest.accessToken);
            if (isMissingEndpoint || isMissingaccessToken) {
                oValidationResult.IsValid = false;
                oValidationResult.Failures.add(System.Label.InvalidOrMissingCredentials);
            }
            
            //Validate Timeout Limit
            boolean isTimeoutValid = (oRequest.Timeout > 0);
            
            if (!isTimeoutValid) {
                oValidationResult.IsValid = false;
                oValidationResult.Failures.Add(System.Label.InvalidTimeoutValue);   
            }
        }
        else {
            oValidationResult.IsValid = false;
            oValidationResult.Failures.add(System.Label.Invalid_Request_Object_Request_can_not_be_null);
        }
        
        return oValidationResult;   
    }
    
    /**
     * Validates the the specified request contains all required information
     * 
     * @param   oRequest    an instance of a FieldInfoRequest object
     * @return  an instance of a ValidationResult object
     */
    private static ValidationResult validateFieldInfoRequest(FieldInfoRequest oRequest) {
        ValidationResult oValidationResult = validateRequest(oRequest);
        
        if (oRequest.UseInSelect == false && oRequest.UseInBlock == false) {
            oValidationResult.IsValid = false;
            oValidationResult.Failures.add(System.Label.Request_must_specify_UseInSelect_or_UseInBlock);
        }
        
        return oValidationResult;
    }
    
    /**
     * Validates the the specified request contains all required information
     * 
     * @param   oRequest    an instance of a FieldValueRequest object
     * @return  an instance of a ValidationResult object
     */
    private static ValidationResult validateFieldValueRequest(FieldValueRequest oRequest) {
        ValidationResult oValidationResult = validateRequest(oRequest);
        
        if (oRequest.TerritoryNumbers.isEmpty()) {
            oValidationResult.IsValid = false;
            oValidationResult.Failures.add(System.Label.Territory_is_required);
        }
        
        return oValidationResult;
    }
    
    /**
     * Validates the the specified request contains all required information
     * 
     * @param   oSearchRequest  an instance of a SearchRequest object
     * @return  an instance of a ValidationResult object
     */
    private static ValidationResult validateSearchRequest(SearchRequest oSearchRequest) {
        ValidationResult oValidationResult = validateRequest(oSearchRequest);
        
        return oValidationResult;
    }
    
    /**
     * Gets the web service value for the specified JoinCondition enum
     *
     * @param   eJoinCondition  an JoinCondition enum
     * @return  a string
     */
    private static string getJoinConditionValue(JoinCondition eJoinCondition) {
        if (eJoinCondition == JoinCondition.JoinAND) {
            return JoinConditionAND;
        }   
        else if (eJoinCondition == JoinCondition.JoinOR) {
            return JoinConditionOr;
        }
        else {
            return JoinConditionAND;
        }
    }
    
    /**
     * Gets the web service value for the specified SortDirection enum
     *
     * @param   eSortDirection  an SortDirection enum
     * @return  a string
     */
    private static string getSortDirectionValue(SortDirection eSortDirection) {
        if (eSortDirection == SortDirection.SortASC) {
            return SortASC;
        }   
        else if (eSortDirection == SortDirection.SortDESC) {
            return SortDESC;
        }
        else {
            return SortASC;
        }
    }
    
    //Enumerators
    public enum Operator { Equal, LessThan, GreaterThan, LessThanEqualTo, GreaterThanEqualTo, Between }
    public enum JoinCondition { JoinAND, JoinOR }
    public enum SortDirection { SortASC, SortDESC }
    
    //Internal Classes
    
    /**
     * Data structure representing an AdvancedSearchWS field
     */
    public class FieldInfo {
        public string Name {get;set;}
        public string FieldType {get;set;}
        public string Description {get;set;}
        public boolean UseInSelect {get;set;}
        public boolean UseInBlock {get;set;}
        public List<string> ValidValues {get;set;}
        
        public FieldInfo() {
            this.UseInSelect = false;
            this.UseInBlock = false;
            this.ValidValues = new List<string>();
        }
    }

    //Internal Web Service Request Classes
    
    /**
     * Base request class for web service calls to AdvancedSearchWS
     */
    public virtual class Request {
        public string Username {get;set;}
        public string Password {get;set;}
        public string Endpoint {get;set;}
        public decimal Timeout {get;set;}
        public String accessToken {get;set;}
        
        public Request() {
            this.Endpoint = '';
            this.Timeout = (10 * 1000); //10 Seconds
        }
    }
    
    /**
     * Request object for requesting field information from
     * the AdvancedSearchWS web service
     */
    public class FieldInfoRequest extends Request {
        public Set<string> TerritoryNumbers {get;set;}
        public boolean UseInSelect {get;set;}
        public boolean UseInBlock {get;set;}
        
        
        public FieldInfoRequest() {
            this.TerritoryNumbers = new Set<string>();
            this.UseInSelect = false;
            this.UseInBlock = false;
        }
    }
    
    /**
     * Request object for requesting field information from
     * the AdvancedSearchWS web service
     */
    public class FieldValueRequest extends Request {
        public Set<string> TerritoryNumbers {get;set;}
        public list<string> SearchFieldNames {get;set;}
        
                
        public FieldValueRequest() {
            this.TerritoryNumbers = new Set<string>();
            this.SearchFieldNames = New list<string>();
        }
    }

    /**
     * Request object for requesting an account search from
     * the AdvancedSearchWS web service
     */
    public class SearchRequest extends Request {
        public integer MaxResults {get;set;}
        public Set<string> SelectFields {get;set;}
        public Set<string> TerritoryNumbers {get;set;}
        public string SortBy {get;set;}
        public SortDirection SortDirectionType {get;set;}
        public List<SearchBlock> Include {get;set;}
        public List<SearchBlock> Exclude {get;set;}
        
        
        public SearchRequest() {
            this.MaxResults = 500;
            this.SelectFields = new Set<string>();
            this.TerritoryNumbers = new Set<string>();
            this.SortBy = 'Name';
            this.SortDirectionType = SortDirection.sortASC;
            this.Include = new List<SearchBlock>();
            this.Exclude = new List<SearchBlock>();
        }
    }
    
    public class SearchBlock {
        public JoinCondition JoinConditionType {get;set;}
        public string FieldName {get;set;}
        public List<SearchBlockItem> SearchBlockItems {get;set;}
        
        public SearchBlock() {
            this.JoinConditionType = JoinCondition.JoinAND;
            this.SearchBlockItems = new List<SearchBlockItem>();
        }
    }
    
    public class SearchBlockItem {
        public Operator operatorType {get;set;}
        public List<String> values {get;set;}
        public JoinCondition itemCondition {get;set;}
        
        public SearchBlockItem() {
            this.operatorType = Operator.Equal;
            this.values = new List<string>();
        }
    }
    
    //Internal Web Services Response Classes 
    
    /**
     * Base response class for web service calls to AdvancedSearchWS
     */
    public virtual class Response {
        public boolean isSuccess {get;set;}
        public string errorMessage {get;set;}
        
        public Response() {
            this.isSuccess = true;
            this.errorMessage = '';
        }
        
        public void parse(Exception oException) {
            this.isSuccess = false;
            this.errorMessage = oException.getMessage();
        }
        
        public void parse(ValidationResult oValidationResult) {
            this.isSuccess = oValidationResult.isValid;
            this.errorMessage = oValidationResult.getHTMLErrorMessage();
        }
    }
  
    /**
     * Response object for requesting field information from
     * the AdvancedSearchWS web service
     */
    public class FieldInfoResponse extends Response {
        //Protected Members
       @TestVisible 
        private Map<string, FieldInfo> mapFields;
        
        //Properties
        public List<FieldInfo> fields {
            get { return mapFields.Values(); }
        }
        
        //Constructors
        
        /**
         * Default Constructor
         */
        public FieldInfoResponse() {
            this.mapFields = new Map<string, FieldInfo>();
        }
        
        //Public Methods
        
        /**
         * Retrieves a list of field names of type List
         * 
         * @return a list of strings
         */




        public List<string> getListFieldNames() {
            List<string> fieldNames = new List<string>();
            
            for (FieldInfo oFieldInfo : this.Fields) {
                if (oFieldInfo.FieldType == ListFieldType) {
                    fieldNames.add(oFieldInfo.Name);
                }
            }
            
            return fieldNames;
        }
        
        /**
         * Parses a list of AdvancedSearchWS.SearchParm objects into
         * FieldInfo objects
         *
         * @param   oResponse   a list of AdvancedSearchWS.SearchParmItem objects
         */
        public void parse(AdvancedSearchWS.SearchParm[] oResponse) {
            mapFields = new Map<string, FieldInfo>();

            if (oResponse != null) {
                for (AdvancedSearchWS.SearchParm oSearchParm : oResponse) {
                    FieldInfo oFieldInfo = new FieldInfo();
                    oFieldInfo.Name = oSearchParm.ParmName;
                    oFieldInfo.FieldType = oSearchParm.ControlType;
                    oFieldInfo.Description = oSearchParm.ParmDesc;
                    oFieldInfo.UseInSelect = oSearchParm.UseInSelect;
                    oFieldInfo.UseInBlock = oSearchParm.UseInBlock;
                    
                    mapFields.put(oFieldInfo.Name, oFieldInfo);
                }
            }
        }
    }
            
    /**
     * Response object for requesting field information from
     * the AdvancedSearchWS web service
     */
    public class FieldValueResponse extends Response {
        //Properties
        public Map<string, List<string>> fieldValues {get;set;}

        //Constructors
        
        /**
         * Default Constructor
         */
        public FieldValueResponse() {
            this.fieldValues = new Map<string, List<string>>();
        }
        
        //Public Methods

        /** 
         * Parses a list of AdvanceSearchWS.SearchParmItem values into the associated
         * FieldInfo values list
         *
         * @param   oResponse   a list of AdvancedSearchWS.SearchParmItem objects
         */
        public void parse(AdvancedSearchWS.SearchParmItem[] oResponse) {
            if (oResponse != null) {
                for (AdvancedSearchWS.SearchParmItem oSearchParmItem : oResponse) {
                    if (oSearchParmItem.ParmValue != null) {
                        if (fieldValues.containsKey(oSearchParmItem.ParmName)) {
                            fieldValues.get(oSearchParmItem.ParmName).addAll(oSearchParmItem.ParmValue);
                        }
                        else {
                            fieldValues.put(oSearchParmItem.ParmName, new List<string>(oSearchParmItem.ParmValue));
                        }
                    } 
                }
            }
        }
    }
    
    /**
     * Response object for requesting an account search from
     * the AdvancedSearchWS web service
     * Arti:  #11595 Modified code, Data filtering for GLI User. 
     */
    public class SearchResponse extends Response {
        public List<AdvancedSearchAccount> searchResults {get;set;}
        //Arti: listcheck List to store only Is_GLI record
        public List<AdvancedSearchAccount> listcheck {get;set;}
        public Set<string> sapAccountNumbers {get;set;}
        //Arti: Set<string> setSAPAccountNumber to store SAPAccountNuber from webservice  
        public Set<String> setSAPAccountNumber{get;set;}
        public SearchResponse() {
            this.searchResults = new List<AdvancedSearchAccount>();
            this.sapAccountNumbers = new Set<string>();
            this.setSAPAccountNumber= new Set<String>();
            this.listcheck= new List<AdvancedSearchAccount>();
            
        }
        
        public void parse(AdvancedSearchWS.SearchResult oResponse) {
            this.searchResults = new List<AdvancedSearchAccount>();
            this.sapAccountNumbers = new Set<string>();
            this.listcheck= new List<AdvancedSearchAccount>();
           //Arti: Set<String> prospectSAPAccount to store Non-GLI SAPAccountNumber, getting from web services 
           Set<String> prospectSAPAccount= new Set<String>();
           if (oResponse != null && oResponse.ParmValueRecord != null) {
                List<string> listFields = oResponse.SelectParmName;

                for (AdvancedSearchWS.ParmValueRecord oRecord : oResponse.ParmValueRecord) {
                    AdvancedSearchAccount oAccount = new AdvancedSearchAccount();
                    List<string> listValues = oRecord.ParmValue.ParmValue;
                    
                    string sFirstName = '';
                    string sLastName = '';
                    
                    for (integer i=0; i<listFields.size(); i++) {
                        string sFieldName = listFields[i];
                        
                        if (sFieldName == 'Name') oAccount.Name = listValues[i];
                        if (sFieldName == 'Name 2') oAccount.Name2 = listValues[i];
                        if (sFieldName == 'Name 3') oAccount.Name3 = listValues[i];
                        
                        if (sFieldName == 'SAP Account Number') {
                            oAccount.SAPAccountNumber = listValues[i];
                            this.sapAccountNumbers.add(oAccount.SAPAccountNumber);
                        }
                        
                        if (sFieldName == 'Phone 1') oAccount.Phone1 = listValues[i];
                        if (sFieldName == 'Address Line 1') oAccount.AddressLine1 = listValues[i];
                        if (sFieldName == 'City') oAccount.City = listValues[i];
                        if (sFieldName == 'State') oAccount.State = listValues[i];
                        if (sFieldName == 'Number of Attorneys . Org') oAccount.NumberOfAttorneyOrg = AppUtil.isEmpty(listValues[i]) ? 0 : integer.valueOf(listValues[i]);
                        if (sFieldName == 'Number of Attorneys - Location') oAccount.NumberOfAttorneyLocations = AppUtil.isEmpty(listValues[i]) ? 0 : integer.valueOf(listValues[i]);
                        if (sFieldName == 'Total Active Subscriptions') oAccount.TotalActiveSubs = AppUtil.isEmpty(listValues[i]) ? 0 : integer.valueOf(listValues[i]);
                        if (sFieldName == 'Total Lapsed Subscriptions') oAccount.TotalLapsedSubs = AppUtil.isEmpty(listValues[i]) ? 0 : integer.valueOf(listValues[i]);
                        if (sFieldName == 'Contact First Name') sFirstName = listValues[i];
                        if (sFieldName == 'Contact Last Name') sLastName = listValues[i];
                        if (sFieldName == 'Zip') oAccount.ZipCode = listValues[i]; 
                    }
                    
                    oAccount.ContactName = String.format('{0} {1}', new List<string>{ sFirstName, sLastName });
                    searchResults.add(oAccount);
                    // system.debug('inside loop ' + searchResults);
               
                }
                 if(searchResults.size()>0){
               // system.debug('insideIf loop ' + searchResults.size());
             for(AdvancedSearchAccount acc: searchResults){
               setSAPAccountNumber.add(acc.SAPAccountNumber);
            }

          }
         //Arti: list will store Non-GLI records based on SAPAccountNumber.
         List<Account> accNonGLIList = new List<Account>(); 
           if(Schema.sObjectType.Account.isAccessible() && Schema.sObjectType.Contact.isAccessible())    
          accNonGLIList= [select id, name, Is_GLI__c, Account_Name_2__c,Account_Name_3__c,SAPAccountNumber__c,Account_SAP_Phone_1__c,BillingStreet,BillingCity,BillingState, Number_of_Attorneys_Location__c,Number_of_Attorneys_Org__c, Total_Active_Subscriptions__c
                                , Total_Lapsed_Subscriptions__c,BillingPostalCode, (Select id, name, LCRM_Is_GLI__c from Contacts LIMIT 1) from Account where SAPAccountNumber__c IN: setSAPAccountNumber ];  

         //Arti: list will store GLI records which exist in org based on SAPAccountNumber.  
         /*   List<Account> accGLIList= [select id, name, Is_GLI__c, Account_Name_2__c,Account_Name_3__c,SAPAccountNumber__c,Account_SAP_Phone_1__c,BillingStreet,BillingCity,BillingState, Number_of_Attorneys_Location__c,Number_of_Attorneys_Org__c, Total_Active_Subscriptions__c
                                , Total_Lapsed_Subscriptions__c,BillingPostalCode, (Select id, name, LCRM_Is_GLI__c from Contacts LIMIT 1) from Account where SAPAccountNumber__c IN: setSAPAccountNumber AND Is_GLI__c=:true];  
           system.debug('acc'+accGLIList.size());
           */  
           // List to get all Account based upon SAPAccountNumber
         List<Source_System_Detail__c> oSourceSystem = new List<Source_System_Detail__c>();
               if(Schema.sObjectType.Source_System_Detail__c.isAccessible())
               oSourceSystem = [select id, name, Account_Name__c,Account_Name__r.name, Account_Name__r.Is_GLI__c, Account_Name__r.Account_Name_2__c,Account_Name__r.Account_Name_3__c,Account_Name__r.Account_SAP_Phone_1__c, Account_Name__r.BillingStreet,
Account_Name__r.BillingCity,Account_Name__r.BillingState, Account_Name__r.Number_of_Attorneys_Location__c,Account_Name__r.Number_of_Attorneys_Org__c, Account_Name__r.Total_Active_Subscriptions__c
, Account_Name__r.Total_Lapsed_Subscriptions__c,Account_Name__r.BillingPostalCode, Source_System_Account_Number__c,LCRM_Sub_BU__c from Source_System_Detail__c where Source_System_Account_Number__c IN: setSAPAccountNumber limit 1000]; 
          Map<String, Source_System_Detail__c> oMapSource= new Map<String,Source_System_Detail__c>();
          map<id,Contact> mapContid =new map<id,Contact>();
          Set<String> accountnameids = new Set<String>();
          for(Source_System_Detail__c sc: oSourceSystem){
                oMapSource.put(sc.Source_System_Account_Number__c, sc); 
                accountnameids.add(sc.Account_Name__c);         
            }
            
            /*
            if(!oMapSource.values().isempty()){
            List<Contact> conList = new List<Contact>();
            if(Schema.sObjectType.Contact.isAccessible())
            conList=  [select id, name,accountId, salutation, FirstName, LastName,SAP_Contact_ID__c from Contact where accountId IN:accountnameids LIMIT 10000];
            if(conList.size()>0){
            for(Contact a:conList){  
                mapContid.put(a.accountid, a);
            } 
            system.debug('@@@mapContid'+mapContid);
            }
            }
            
          */
          
          
          
          // preparing the map of AccountId with ContactName
          List<Account>accountList = new List<Account>();
          map<id,String> mapAccConName =new map<id,String>();
          if(Schema.sObjectType.Account.isAccessible() && Schema.sObjectType.Contact.isAccessible()){
                accountList = [SELECT Id, (Select id, name from Contacts LIMIT 1) From Account WHERE Id IN:accountnameids];
                if(accountList != null){
                    for(Account accRec : accountList){
                        if(accRec.Contacts!=null){
                            for(Contact conRec: accRec.Contacts){
                                mapAccConName.put(accRec.Id, conRec.Name);
                            }
                        }
                    }
                }
          }
            
            if(accNonGLIList.size()>0){
            // Assigned Non-GLI records to the AdvancedSearchAccount values to display in a Advanced Search Page  
                for(Account oAcc1: accNonGLIList){
             AdvancedSearchAccount adc1= new AdvancedSearchAccount();
             
             adc1.Name=oAcc1.Name;
             adc1.Name2= oAcc1.Account_Name_2__c;
             adc1.Name3=oAcc1.Account_Name_3__c;
             adc1.SAPAccountNumber= oAcc1.SAPAccountNumber__c;
             adc1.Phone1= oAcc1.Account_SAP_Phone_1__c;
             adc1.AddressLine1= oAcc1.BillingStreet;
             adc1.City=oAcc1.BillingCity;
             adc1.State=oAcc1.BillingState;
             adc1.NumberOfAttorneyLocations= Integer.valueOf(oAcc1.Number_of_Attorneys_Location__c);
             adc1.NumberOfAttorneyOrg=Integer.valueOf(oAcc1.Number_of_Attorneys_Org__c);
             adc1.TotalActiveSubs=Integer.valueOf(oAcc1.Total_Active_Subscriptions__c);
             adc1.TotalLapsedSubs=Integer.valueOf(oAcc1.Total_Lapsed_Subscriptions__c);
             adc1.ZipCode=oAcc1.BillingPostalCode;
             //if contact is available for associated account
             if(oAcc1.Contacts!=null){
             for(Contact con1: oAcc1.Contacts){
              adc1.ContactName=con1.name;
               }
             }
             else {
                 adc1.ContactName='';
                }
                prospectSAPAccount.add(oAcc1.SAPAccountNumber__c);
                
                }
            }
            
            IF(oSourceSystem!=null){
              for(Source_System_Detail__c oAcc: oSourceSystem){
                  if(oMapSource.containsKey(oAcc.Source_System_Account_Number__c)){
                if(oAcc.Account_Name__r.Is_GLI__c==true){
                 AdvancedSearchAccount adc1= new AdvancedSearchAccount();
             adc1.Name=oAcc.Account_Name__r.Name;
             adc1.Name2= oAcc.Account_Name__r.Account_Name_2__c;
             adc1.Name3=oAcc.Account_Name__r.Account_Name_3__c;
             adc1.SAPAccountNumber= oAcc.Source_System_Account_Number__c;
             adc1.Phone1= oAcc.Account_Name__r.Account_SAP_Phone_1__c;
             adc1.AddressLine1= oAcc.Account_Name__r.BillingStreet;
             adc1.City=oAcc.Account_Name__r.BillingCity;
             adc1.State=oAcc.Account_Name__r.BillingState;
             adc1.NumberOfAttorneyLocations= Integer.valueOf(oAcc.Account_Name__r.Number_of_Attorneys_Location__c);
             adc1.NumberOfAttorneyOrg=Integer.valueOf(oAcc.Account_Name__r.Number_of_Attorneys_Org__c);
             adc1.TotalActiveSubs=Integer.valueOf(oAcc.Account_Name__r.Total_Active_Subscriptions__c);
             adc1.TotalLapsedSubs=Integer.valueOf(oAcc.Account_Name__r.Total_Lapsed_Subscriptions__c);
             adc1.ZipCode=oAcc.Account_Name__r.BillingPostalCode;
             
              
              /*
               if(mapContid.values().size()>0){
                   if(mapContid.containsKey(oAcc.Account_Name__c)){
                        for(Contact con1: mapContid.Values()){
                            if(con1.accountid==oAcc.Account_Name__c){
                            adc1.ContactName=con1.name;
                            }
                     }
                 }
               } 
             */
           if(!mapAccConName.isEmpty() && mapAccConName.containsKey(oAcc.Account_Name__c)){
               adc1.ContactName =  mapAccConName.get(oAcc.Account_Name__c);   
           }
            else 
             adc1.ContactName='';
             listcheck.add(adc1);
             listcheck.sort();  

                } 
                  }
               }  
            }
            //Arti: Map to hold prospect SAPAccountNumber with Accounts
            Map<set<String>, AdvancedSearchAccount>  mapProspectrecord= new Map<set<String>, AdvancedSearchAccount>();
            List<AdvancedSearchAccount> tempList= new  List<AdvancedSearchAccount>();
                for(AdvancedSearchAccount ac: searchResults){
                    setSAPAccountNumber.removeAll(prospectSAPAccount);
                  if(setSAPAccountNumber.contains(ac.SAPAccountNumber)){
                        mapProspectrecord.put(setSAPAccountNumber, ac);
                 listcheck.addAll(mapProspectrecord.values());
                 listcheck.sort();
                 
                    }
  
                   }
           
                this.isSuccess = true;
            }
            else {
                this.isSuccess = false;
            }
        }
        
    }
   
    /**
     * Data structure representing an account search result record
     */
    public class SearchResultRecord {
        public List<string> fieldNames {get;set;}
        public List<string> fieldValues {get;set;}
    }
}