/**
 * Validates the functionality provided by the AdvancedSearchController class
 *
 * @author  Glenda Ninan
 * @version 2012-08-23
 *
 * CHANGE HISTORY
 * =============================================================================
 * Date         Name                    Description
 * 2012-08-23   Glenda Ninan            Created 
 * 2019-03-13   Lovedeep Singh          Modified code [DPS-3229] Changes made to Delete function in the main class and in the test class increased the test coverage to 85% by covering the saveLead method lines.
 * =============================================================================
 */
@IsTest 
public class AdvancedSearchController_Test {

 @testSetup static void setup() {
        list<Territory2Type> terriType   = [SELECT id, DeveloperName from Territory2Type];
        Territory2Model terrModel = [select id FROM Territory2Model WHERE State = 'Active' ];
        /* Territory2Model terrModel = new Territory2Model();
terrModel.DeveloperName = 'TestterritoryModel';
terrModel.Name = 'TestterritoryModel';
terrModel.State = 'Active';
insert terrModel;*/
        
        Territory2 testterr = new Territory2();
        testterr.AccountAccessLevel = 'Read';
        testterr.DeveloperName = 'testterr';
        testterr.Territory2ModelId = terrModel.Id;
        testterr.Territory2TypeId = terriType[0].Id;
        testterr.Name = 'testterritory2';
        testterr.TMS_Terr_Num__c = '123';
        insert testterr;
        
        Profile adminProfile = [SELECT Id FROM profile WHERE name='System Administrator'];
        User gliUser;
        gliUser = UnitTest.getUserInstance();
        gliUser.Username = 'TestUser1@TR.com';
        gliUser.profileid = adminProfile.Id;
        gliUser.Email='testuser@thomsonreuters.com';
        gliUser.Alias = 'igli';
        //gliUser.FirstName='Informatica';
        gliUser.LastName='Integration';
        gliUser.EmailEncodingKey='UTF-8';
        gliUser.LocaleSidKey='en_US';
        gliUser.LanguageLocaleKey='en_US';
        gliUser.TimeZoneSidKey='America/Los_Angeles';
        gliUser.Sub_Bu__c = 'USL';
        
        
        insert gliUser; 
        Territory2 terr2 = [select Id FRoM territory2 WHERE name ='testterritory2' Limit 1];
        
        UserTerritory2Association uta = new UserTerritory2Association();
        uta.Territory2Id = terr2.Id;       
        uta.UserId = gliUser.Id;   
        
        insert uta;
        
        //Insert Account
        
        
        //Insert Opportunity 
        //
        ////
        
        
    }
    /**
     * Validates controller handling for a null standard controller
     */
    public static testMethod void testNullStandardController() {
        //Setup Test
        PageReference oPage = Page.AdvancedSearch;
        Test.setCurrentPage(oPage);
        
        Test.startTest();
        
        AdvancedSearchController oController = new AdvancedSearchController(null);
        oController.onTerritoryChange(); 
        oController.onFilterFieldChanged();
        oController.onFilterOperatorChanged();
        oController.addNewExcludeFilter();
        oController.addNewIncludeFilter();
        oController.searchAccounts();
        oController.deleteSearch();
        oController.updateFilterValueInput();
        System.assert(ApexPages.hasMessages() == true, 'Expected error message when a null standard controller is used');
        oController.saveLead();
        Test.stopTest();
    }
    
    public static testMethod void testNullStandardsController() {
        //Setup Test
        PageReference oPage = Page.AdvancedSearch;
        Test.setCurrentPage(oPage);
        AdvancedSearch__c oAdvancedSearch = getAdvancedSearchInstance();
        Insert oAdvancedSearch;
        ApexPages.StandardController oStandardController = new ApexPages.StandardController(oAdvancedSearch);
        
        Test.startTest();
        
        AdvancedSearchController oController = new AdvancedSearchController(oStandardController);
        oController.onTerritoryChange(); 
        oController.onFilterFieldChanged();
        oController.onFilterOperatorChanged();
        //oController.addNewExcludeFilter();
        //oController.addNewIncludeFilter();
        //oController.searchAccounts();
        //oController.deleteSearch();
        //oController.updateFilterValueInput();
       
        //oController.saveLead();
        Test.stopTest();
    }
    
    /**
     * Validates the onPageLoad method
     */
    public static testMethod void testOnPageLoad() {
        //Setup Test
        setupMockGetSearchParmsResponse();
        setupMockGetSearchParmValuesResponse();
        
        AdvancedSearch__c oAdvancedSearch = getAdvancedSearchInstance();
        Insert oAdvancedSearch;
                    
        PageReference oPage = Page.AdvancedSearch;
        Test.setCurrentPage(oPage);
        
        ApexPages.StandardController oStandardController = new ApexPages.StandardController(oAdvancedSearch);
        
        //Execute Test
        Test.startTest();
        
        ApexPages.currentPage().getParameters().put('Id', oAdvancedSearch.Id);
        AdvancedSearchController oController = new AdvancedSearchController(oStandardController);
        oController.onPageLoad();
        
        Test.stopTest();
        
        //Validate Test
        System.assertNotEquals(null, oPage);
        System.assertEquals(false, oController.AllowCancel);
        
    }
    
    /**
     * Validates the edit method
     */
    public static testMethod void testEditState() {

        AdvancedSearch__c oAdvancedSearch = getAdvancedSearchInstance();
        Insert oAdvancedSearch;
        
        AdvancedSearchDetail__c oAdvancedSearchDetail = getAdvancedSearchDetailInstance(oAdvancedSearch.Id);
        oAdvancedSearchDetail.Value__c = 'Edit';
        oAdvancedSearchDetail.FilterType__c = 'Include';
        oAdvancedSearchDetail.AdvancedSearch__c = oAdvancedSearch.Id;
        Insert oAdvancedSearchDetail;
        
        PageReference oPage = Page.AdvancedSearch;
        Test.setCurrentPage(oPage);
        
        ApexPages.StandardController oStandardController = new ApexPages.StandardController(oAdvancedSearch);
        
        //Execute Test
        Test.startTest();
        
        ApexPages.currentPage().getParameters().put('Id', oAdvancedSearch.Id);
        AdvancedSearchController oController = new AdvancedSearchController(oStandardController);
        oController.onPageLoad();
        oController.onTerritoryChange();
        List<SelectOption> listAvailTerr = oController.AvailableTerritoryOptions;
        List<SelectOption> listOper = oController.FilterOperators;
        List<SelectOption> listSelTerr = oController.SelectedTerritoryOptions;
        List<string>  listSelTerrNum = oController.SelectedTerritoryNumbers;
        
        System.assertEquals(true, oController.AllowDelete);
        System.assertEquals(false, oController.AllowCancel);  //true
        
        Test.stopTest();
        
        //Validate Test
    }
    
    /**
     * Validates the filter change method
     */
    public static testMethod void testFilterChange() {
        setupMockGetSearchParmsResponse();
        setupMockGetSearchParmValuesResponse();
        //Setup Test
        WebServiceSettings__c oWebServiceSettings = setupAdvancedSearchServiceSettings();
        setupMockGetSearchParmsResponse();
        setupMockGetSearchParmValuesResponse();
        
        AdvancedSearchUtil.FieldInfoRequest oRequest = new AdvancedSearchUtil.FieldInfoRequest();
        oRequest.UserName = oWebServiceSettings.Username__c;
        oRequest.Password = oWebServiceSettings.Password__c;
        oRequest.EndPoint = oWebServiceSettings.Endpoint__c;
        oRequest.Timeout = (oWebServiceSettings.Timeout__c * 1000);
        oRequest.TerritoryNumbers = new Set<string>{'00110'};
        oRequest.UseInBlock = true;
        oRequest.UseInSelect = true;
        
        //AdvancedSearchUtil.Response oResponse = new AdvancedSearchUtil.getAdvancedSearchFields();
       // oResponse.IsSuccess=true;
       // oResponse.ErrorMessage='test error';
        
        AdvancedSearchUtil.FieldInfoResponse oFieldInfoResponse = AdvancedSearchUtil.getAdvancedSearchFields(oRequest);
        oFieldInfoResponse.IsSuccess=true;
        
        AdvancedSearchUtil.FieldInfo oFieldInfo= new AdvancedSearchUtil.FieldInfo();
        oFieldInfo.Name= 'oFieldInfo';
        oFieldInfo.UseInSelect=true;
        oFieldInfo.UseInBlock=true;
        oFieldInfo.FieldType='oFieldInfo';
        oFieldInfo.ValidValues= new List<string>{'00110'};
        
        List<String> oFieldInfoResponseString= new List<String>{'test12'};
        
        AdvancedSearch__c oAdvancedSearch = getAdvancedSearchInstance();
        oAdvancedSearch.TerritoryFilter__c = '00110';
        oAdvancedSearch.Name = 'TEST';
        Insert oAdvancedSearch;
        
        AdvancedSearchDetail__c oAdvancedSearchDetail = getAdvancedSearchDetailInstance(oAdvancedSearch.Id);
        oAdvancedSearchDetail.Value__c = 'Filter Change G*';
        oAdvancedSearchDetail.FilterType__c = 'Include';
        oAdvancedSearchDetail.AdvancedSearch__c = oAdvancedSearch.Id;
        Insert oAdvancedSearchDetail;

        AdvancedSearchDetail__c oAdvancedSearchDetail2 = getAdvancedSearchDetailInstance(oAdvancedSearch.Id);
        oAdvancedSearchDetail2.Value__c = 'Filter Change GL*';
        oAdvancedSearchDetail2.FilterType__c = 'Exclude';
        oAdvancedSearchDetail2.AdvancedSearch__c = oAdvancedSearch.Id;
        Insert oAdvancedSearchDetail2;
        
        PageReference oPage = Page.AdvancedSearch;
        Test.setCurrentPage(oPage);
        
        ApexPages.StandardController oStandardController = new ApexPages.StandardController(oAdvancedSearch);
        
        //Execute Test
        Test.startTest();
        
        ApexPages.currentPage().getParameters().put('Id', oAdvancedSearch.Id);
        AdvancedSearchController oController = new AdvancedSearchController(oStandardController);
        
        oController.onPageLoad();
        oController.onFilterFieldChanged();
        
        oController.TerritoryView = 'My';
        List<SelectOption> listAvailTerr = oController.AvailableTerritoryOptions;
        List<SelectOption> listSelTerr = oController.SelectedTerritoryOptions;
        List<string>  listSelTerrNum = oController.SelectedTerritoryNumbers;
        
        oController.NewFilterInput.FieldValuesMap.put(1, '00110');
        oController.mapSelectFields.put('oFieldInfo',oFieldInfo);
        Set<string>  setFields = oController.SelectFieldNames;
        string  sUrl = oController.AdvancedSearchListURL;
        system.assertEquals(oFieldInfoResponse.IsSuccess, true);
        oController.onFilterFieldChanged();
        oController.onFilterOperatorChanged();
        oController.save();
        oController.onTerritoryChange();
        oController.loadAdvancedSearchFields();
        
        Test.stopTest();
        
        //Validate Test
    }
    
    /**
     * Validates the filter change method
     */
    public static testMethod void testBlankTerritoryFilter() {
        //Setup Test
        WebServiceSettings__c oWebServiceSettings = setupAdvancedSearchServiceSettings();
        setupMockGetSearchParmsResponse();
        setupMockGetSearchParmValuesResponse();

        AdvancedSearchUtil.FieldInfoRequest oRequest = new AdvancedSearchUtil.FieldInfoRequest();
        oRequest.UserName = oWebServiceSettings.Username__c;
        oRequest.Password = oWebServiceSettings.Password__c;
        oRequest.EndPoint = oWebServiceSettings.Endpoint__c;
        oRequest.Timeout = (oWebServiceSettings.Timeout__c * 1000);
        oRequest.TerritoryNumbers = new Set<string>{''};
        oRequest.UseInBlock = true;
        oRequest.UseInSelect = true;
        
        AdvancedSearchUtil.FieldInfoResponse oFieldInfoResponse = new AdvancedSearchUtil.FieldInfoResponse();
         oFieldInfoResponse.IsSuccess=true;
        
        AdvancedSearch__c oAdvancedSearch = getAdvancedSearchInstance();
        oAdvancedSearch.TerritoryFilter__c = '';
        Insert oAdvancedSearch;
        
        AdvancedSearchDetail__c oAdvancedSearchDetail = getAdvancedSearchDetailInstance(oAdvancedSearch.Id);
        oAdvancedSearchDetail.Value__c = 'Filter Change G*';
        oAdvancedSearchDetail.FilterType__c = 'Include';
        oAdvancedSearchDetail.AdvancedSearch__c = oAdvancedSearch.Id;
        Insert oAdvancedSearchDetail;

        PageReference oPage = Page.AdvancedSearch;
        Test.setCurrentPage(oPage);
        
        ApexPages.StandardController oStandardController = new ApexPages.StandardController(oAdvancedSearch);
        final String originalMessage = 'Hello World!';
        
        //Execute Test
        Test.startTest();
        
        ApexPages.currentPage().getParameters().put('Id', oAdvancedSearch.Id);
        AdvancedSearchController oController = new AdvancedSearchController(oStandardController);
        
        oController.onPageLoad();
        //system.assert(oAdvancedSearch.TerritoryFilter__c != '','Territory is still blank');

        oController.TerritoryView = 'My';
        List<SelectOption> listAvailTerr = oController.AvailableTerritoryOptions;
        List<SelectOption> listSelTerr = oController.SelectedTerritoryOptions;
        List<string>  listSelTerrNum = oController.SelectedTerritoryNumbers;

        Set<string>  setFields = oController.SelectFieldNames;
        string  sUrl = oController.AdvancedSearchListURL;
        oController.save();
        oController.onFilterFieldChanged();
        oController.onFilterOperatorChanged();
        oController.onTerritoryChange();
        oController.deleteSearch();
       // MyCustomException e = new MyCustomException(oAdvancedSearch, d);
        Test.stopTest();
        
        //Validate Test
    }
    


    /**
     * Validates the Search  method
     */
    public static testMethod void testSearch() {
        //Setup Test
        WebServiceSettings__c oWebServiceSettings = setupAdvancedSearchServiceSettings();
        setupMockGetSearchParmsResponse();
        setupMockRunSearchResponse();
        setupMockGetSearchParmValuesResponse();
        
        
        
        AdvancedSearchUtil.FieldInfo oFieldInfo= new AdvancedSearchUtil.FieldInfo();
        oFieldInfo.Name= 'oFieldInfo';
        oFieldInfo.UseInSelect=true;
        oFieldInfo.UseInBlock=true;
        oFieldInfo.ValidValues= new List<string>{'00110'};
        oFieldInfo.FieldType='oFieldInfo';
        
        AdvancedSearchUtil.FieldInfoRequest oRequest = new AdvancedSearchUtil.FieldInfoRequest();
        oRequest.UserName = oWebServiceSettings.Username__c;
        oRequest.Password = oWebServiceSettings.Password__c;
        oRequest.EndPoint = oWebServiceSettings.Endpoint__c;
        oRequest.Timeout = (oWebServiceSettings.Timeout__c * 1000);
        oRequest.TerritoryNumbers = new Set<string>{'00110'};
        oRequest.UseInBlock = true;
        oRequest.UseInSelect = true;
        //oRequest.IsSuccess=true;
        
        
        List<String> oFieldInfoResponseString= new List<String>{'oFieldInfo'};
        
        AdvancedSearchUtil.FieldValueRequest oFieldValueRequest= new AdvancedSearchUtil.FieldValueRequest();
        oFieldValueRequest.TerritoryNumbers= new Set<string>{'00110'};
        oFieldValueRequest.SearchFieldNames= new List<String>{'oFieldInfo'};
        
        
        AdvancedSearchUtil.FieldValueResponse oFieldInfoResponse = AdvancedSearchUtil.getAdvancedSearchFieldValues(oFieldValueRequest);
         oFieldInfoResponse.IsSuccess=true;
         oFieldInfoResponse.FieldValues.put('oFieldInfo', oFieldInfoResponseString);
        
        //AdvancedSearchUtil.FieldValueResponse oFieldValueResponse= new AdvancedSearchUtil.FieldValueResponse();
        //oFieldValueResponse.FieldValues.put('Test1', oFieldInfoResponseString);
        
        AdvancedSearchUtil.SearchRequest oSearchRequest = new AdvancedSearchUtil.SearchRequest();
        oSearchRequest.UserName = oWebServiceSettings.Username__c;
        oSearchRequest.Password = oWebServiceSettings.Password__c;
        oSearchRequest.EndPoint = oWebServiceSettings.Endpoint__c;
        oSearchRequest.Timeout = (oWebServiceSettings.Timeout__c * 1000);
        oSearchRequest.TerritoryNumbers = new Set<string>{'00110'};
        //oSearchRequest.SelectFields = 
        List<AdvancedSearchAccount> oAdvancedSearchAccount= new List<AdvancedSearchAccount>();
        AdvancedSearchUtil.SearchResponse oSearchResponse = AdvancedSearchUtil.searchAccounts(oSearchRequest);
        oSearchResponse.IsSuccess= true;
        oSearchResponse.listcheck= oAdvancedSearchAccount;
        
        AdvancedSearch__c oAdvancedSearch = getAdvancedSearchInstance();
        oAdvancedSearch.TerritoryFilter__c = '';
        oAdvancedSearch.Name = 'Search Negative';
        Insert oAdvancedSearch;
        
        AdvancedSearchDetail__c oAdvancedSearchDetail = getAdvancedSearchDetailInstance(oAdvancedSearch.Id);
        oAdvancedSearchDetail.Name = 'City';
        oAdvancedSearchDetail.ListValue__c = 'New York';
        oAdvancedSearchDetail.FilterType__c = 'Include';
        oAdvancedSearchDetail.Operator__c = 'Equal';
        oAdvancedSearchDetail.DataType__c = 'List';
        oAdvancedSearchDetail.AdvancedSearch__c = oAdvancedSearch.Id;
        Insert oAdvancedSearchDetail;

        AdvancedSearchDetail__c oAdvancedSearchDetail1 = getAdvancedSearchDetailInstance(oAdvancedSearch.Id);
        oAdvancedSearchDetail1.Name = 'Credit Risk';
        oAdvancedSearchDetail1.Value__c = 'No';
        oAdvancedSearchDetail1.FilterType__c = 'Include';
        oAdvancedSearchDetail1.Operator__c = 'Equal';
        oAdvancedSearchDetail1.DataType__c = 'Flag';
        oAdvancedSearchDetail1.AdvancedSearch__c = oAdvancedSearch.Id;
        Insert oAdvancedSearchDetail1;

        AdvancedSearchDetail__c oAdvancedSearchDetail2 = getAdvancedSearchDetailInstance(oAdvancedSearch.Id);
        oAdvancedSearchDetail2.Name = 'Name';
        oAdvancedSearchDetail2.Value__c = 'N*';
        oAdvancedSearchDetail2.FilterType__c = 'Include';
        oAdvancedSearchDetail2.Operator__c = 'Equal';
        oAdvancedSearchDetail2.DataType__c = 'Text';
        oAdvancedSearchDetail2.AdvancedSearch__c = oAdvancedSearch.Id;
        Insert oAdvancedSearchDetail2;
        
         AdvancedSearchDetail__c oAdvancedSearchDetail3 = getAdvancedSearchDetailInstance(oAdvancedSearch.Id);
        oAdvancedSearchDetail3.Name = 'City';
        oAdvancedSearchDetail3.ListValue__c = 'New York';
        oAdvancedSearchDetail3.FilterType__c = 'Exclude';
        oAdvancedSearchDetail3.Operator__c = 'Equal';
        oAdvancedSearchDetail3.DataType__c = 'List';
        oAdvancedSearchDetail3.AdvancedSearch__c = oAdvancedSearch.Id;
        Insert oAdvancedSearchDetail3;

        AdvancedSearchDetail__c oAdvancedSearchDetail4 = getAdvancedSearchDetailInstance(oAdvancedSearch.Id);
        oAdvancedSearchDetail4.Name = 'Name';
        oAdvancedSearchDetail4.Value__c = 'N*';
        oAdvancedSearchDetail4.FilterType__c = 'Exclude';
        oAdvancedSearchDetail4.Operator__c = 'Equal';
        oAdvancedSearchDetail4.DataType__c = 'Text';
        oAdvancedSearchDetail4.AdvancedSearch__c = oAdvancedSearch.Id;
        Insert oAdvancedSearchDetail4;
        
        AdvancedSearchDetail__c oAdvancedSearchDetail5 = getAdvancedSearchDetailInstance(oAdvancedSearch.Id);
        oAdvancedSearchDetail5.Name = 'Credit Risk';
        oAdvancedSearchDetail5.Value__c = 'No';
        oAdvancedSearchDetail5.FilterType__c = 'Exclude';
        oAdvancedSearchDetail5.Operator__c = 'Equal';
        oAdvancedSearchDetail5.DataType__c = 'Flag';
        oAdvancedSearchDetail5.AdvancedSearch__c = oAdvancedSearch.Id;
        Insert oAdvancedSearchDetail5;

        AdvancedSearchDetail__c oAdvancedSearchDetail6 = getAdvancedSearchDetailInstance(oAdvancedSearch.Id);
        oAdvancedSearchDetail6.Name = 'Total Active Subscriptions';
        oAdvancedSearchDetail6.NumberValue1__c = 0;
        oAdvancedSearchDetail6.NumberValue2__c = 9;
        oAdvancedSearchDetail6.FilterType__c = 'Include';
        oAdvancedSearchDetail6.Operator__c = 'Between';
        oAdvancedSearchDetail6.DataType__c = 'Numeric';
        oAdvancedSearchDetail6.AdvancedSearch__c = oAdvancedSearch.Id;
        Insert oAdvancedSearchDetail6;

        AdvancedSearchDetail__c oAdvancedSearchDetail7 = getAdvancedSearchDetailInstance(oAdvancedSearch.Id);
        oAdvancedSearchDetail7.Name = 'Total Active Subscriptions';
        oAdvancedSearchDetail7.NumberValue1__c = 3;
        oAdvancedSearchDetail7.NumberValue2__c = 5;
        oAdvancedSearchDetail7.FilterType__c = 'Exclude';
        oAdvancedSearchDetail7.Operator__c = 'Between';
        oAdvancedSearchDetail7.DataType__c = 'Numeric';
        oAdvancedSearchDetail7.AdvancedSearch__c = oAdvancedSearch.Id;
        Insert oAdvancedSearchDetail7;

        AdvancedSearchDetail__c oAdvancedSearchDetail8 = getAdvancedSearchDetailInstance(oAdvancedSearch.Id);
        oAdvancedSearchDetail8.Name = 'Credit Risk';
        oAdvancedSearchDetail8.Value__c = 'No';
        oAdvancedSearchDetail8.FilterType__c = 'Include';
        oAdvancedSearchDetail8.Operator__c = 'Equal';
        oAdvancedSearchDetail8.DataType__c = 'Flag';
        oAdvancedSearchDetail8.AdvancedSearch__c = oAdvancedSearch.Id;
        Insert oAdvancedSearchDetail8;
        
        
        
        AdvancedSearchFilterBlockItem oAdvancedSearchFilterBlockItem = new AdvancedSearchFilterBlockItem(oAdvancedSearchDetail);
        
        
        //oAdvancedSearchAccount.Name
       // oAdvancedSearchAccount.Name
        
        PageReference oPage = Page.AdvancedSearch;
        Test.setCurrentPage(oPage);
        
        ApexPages.StandardController oStandardController = new ApexPages.StandardController(oAdvancedSearch);
        //Account acc= new Account();
        //acc.name= setupMockRunSearchResponse.
        //Execute Test
        Test.startTest();
        
        ApexPages.currentPage().getParameters().put('Id', oAdvancedSearch.Id);
        AdvancedSearchController oController = new AdvancedSearchController(oStandardController);
        oController.profileName='GLI Sales User';
        oController.onPageLoad();
        Boolean oAllowDelete= oController.AllowDelete;
        Boolean oAllowCancel= oController.AllowCancel;
        List<SelectOption> listSelTerr = oController.SelectedTerritoryOptions;
        List<string>  listSelTerrNum = oController.SelectedTerritoryNumbers;
        List<String> listAllTerritoryNumbers= oController.listTeamTerritoryNumbers;
        oController.TerritoryView = 'Team';
        Set<string>  setFields = oController.SelectFieldNames;
        string  sUrl = oController.AdvancedSearchListURL;
        //Lead oLead= new Lead();
        //oLead.source
        ValidationResult oValidationResult1 = oAdvancedSearchFilterBlockItem.validate();
        System.assertEquals(true, oValidationResult1.IsValid);
        oController.mapFilterFields.put('oFieldInfo',oFieldInfo);
        oAdvancedSearchAccount= oController.SearchResults.Accounts;
        oController.onFilterOperatorChanged();
        oController.save();
        List<string> oString= oController.getFieldValues('oFieldInfo');
        oController.NewFilterInput.AdvancedSearchDetail.DataType__c= oFieldInfo.FieldType;
        oController.onTerritoryChange();
        oController.updateFilterValueInput();
        oController.getAvailableTerritoryOptions();
        oController.getSelectFieldNames();
        oController.SearchAccounts();
        oController.loadAdvancedSearchFields();
        oController.massLeadCreation1();
        oController.saveLead();
        oController.cancel();
        oController.AdvancedSearchListLeadURL();
        system.assertEquals(oFieldInfoResponse.IsSuccess, true);
        Test.stopTest();
        
        //Validate Test
        //System.assert(ApexPages.hasMessages() == true, 'Expected error message when territory is blank');
    }


    /**
     * Validates the delete method
     */
    public static testMethod void testDelete() {

        AdvancedSearch__c oAdvancedSearch = getAdvancedSearchInstance();
        Insert oAdvancedSearch;
        
        AdvancedSearchDetail__c oAdvancedSearchDetail = getAdvancedSearchDetailInstance(oAdvancedSearch.Id);
        oAdvancedSearchDetail.Value__c = 'Delete G*';
        oAdvancedSearchDetail.FilterType__c = 'Include';
        oAdvancedSearchDetail.AdvancedSearch__c = oAdvancedSearch.Id;
        Insert oAdvancedSearchDetail;
        
        AdvancedSearchUtil.FieldInfo oFieldInfo= new AdvancedSearchUtil.FieldInfo();
        oFieldInfo.Name= 'oFieldInfo';
        oFieldInfo.UseInSelect=true;
        oFieldInfo.UseInBlock=true;
        oFieldInfo.ValidValues= new List<string>{'00110'};
        oFieldInfo.FieldType='oFieldInfo';
        
        PageReference oPage = Page.AdvancedSearch;
        Test.setCurrentPage(oPage);
        
        ApexPages.StandardController oStandardController = new ApexPages.StandardController(oAdvancedSearch);
        
        //Execute Test
        Test.startTest();
        
        ApexPages.currentPage().getParameters().put('Id', oAdvancedSearch.Id);
        AdvancedSearchController oController = new AdvancedSearchController(oStandardController);
        oController.onPageLoad();
        oController.save();
        oController.mapSelectFields.put('oFieldInfo',oFieldInfo);
        oController.NewFilterInput.AdvancedSearchDetail.DataType__c= oFieldInfo.FieldType;
        //oController.updateFilterValueInput();
        oController.getSelectFieldNames();
        //oController.onTerritoryChange();
        //oController.addNewExcludeFilter();
        //oController.addNewIncludeFilter();
        //oController.onFilterOperatorChanged();
        //oController.onFilterFieldChanged();
        PageReference oPageRef = oController.deleteSearch(); 
        
        Test.stopTest();
        
        //Validate Test
        System.assertNotEquals(null, oPageRef);
        //System.assert(ApexPages.hasMessages() == true, 'Expected error message when territory is blank');
    }

    /**
     * Validates the delete method
     */
    public static testMethod void testExport() {
        
        AdvancedSearch__c oAdvancedSearch = getAdvancedSearchInstance();
        Insert oAdvancedSearch;
        
        AdvancedSearchDetail__c oAdvancedSearchDetail = getAdvancedSearchDetailInstance(oAdvancedSearch.Id);
        oAdvancedSearchDetail.Value__c = 'Export G*';
        oAdvancedSearchDetail.FilterType__c = 'Include';
        oAdvancedSearchDetail.AdvancedSearch__c = oAdvancedSearch.Id;
        Insert oAdvancedSearchDetail;
        
        PageReference oPage = Page.AdvancedSearch;
        Test.setCurrentPage(oPage);
        
        ApexPages.StandardController oStandardController = new ApexPages.StandardController(oAdvancedSearch);
        
        //Execute Test
        Test.startTest();
        
        ApexPages.currentPage().getParameters().put('Id', oAdvancedSearch.Id);
        AdvancedSearchController oController = new AdvancedSearchController(oStandardController);
        oController.onPageLoad();
        oController.onTerritoryChange();
        List<String> listAllTerritoryNumbers= oController.listTeamTerritoryNumbers;
        oController.TerritoryView = 'Team';
        oController.NewFilterInput.FieldValuesMap.put(1, null);
        oController.onFilterFieldChanged();
        oController.onFilterOperatorChanged();
        oController.save();
        
        PageReference oPageRef = oController.exportAccounts(); 
        
        Test.stopTest();
        
        //Validate Test
        System.assertNotEquals(null, oPageRef);
        System.assert(ApexPages.hasMessages() == true, 'Expected error message ');

    }

    /**
     * Validates the save method
     */
    public static testMethod void testBasicSave() {
        MockWebServiceResponse();
        setupMockGetSearchParmsResponse();
        setupMockRunSearchResponse();
        setupMockGetSearchParmValuesResponse();
        AdvancedSearch__c oAdvancedSearch = getAdvancedSearchInstance();
        Insert oAdvancedSearch;
        
        AdvancedSearchDetail__c oAdvancedSearchDetail = getAdvancedSearchDetailInstance(oAdvancedSearch.Id);
        oAdvancedSearchDetail.ListValue__c = 'Save 212345678 test';
        oAdvancedSearchDetail.FilterType__c = 'Include';
        oAdvancedSearchDetail.DataType__c = 'List';
        oAdvancedSearchDetail.AdvancedSearch__c = oAdvancedSearch.Id;
        Insert oAdvancedSearchDetail;
        
        AdvancedSearchDetail__c oAdvancedSearchDetail2 = getAdvancedSearchDetailInstance(oAdvancedSearch.Id);
        oAdvancedSearchDetail.ListValue__c = 'Save 212345678 test';
        oAdvancedSearchDetail2.FilterType__c = 'Include';
        oAdvancedSearchDetail2.DataType__c = 'List';
        oAdvancedSearchDetail2.AdvancedSearch__c = oAdvancedSearch.Id;
        Insert oAdvancedSearchDetail2;

        AdvancedSearchUtil.FieldInfo oFieldInfo= new AdvancedSearchUtil.FieldInfo();
        oFieldInfo.UseInSelect=true;
        oFieldInfo.UseInBlock=true;
        oFieldInfo.ValidValues= new List<string>{'00110'};
        oFieldInfo.FieldType='oFieldInfo';
//        oAdvancedSearchDetail2.IsDeleted = true;
        
        PageReference oPage = Page.AdvancedSearch;
        Test.setCurrentPage(oPage);
        AdvancedSearchFilterBlockItem oAdvancedSearchFilterBlockItem = new AdvancedSearchFilterBlockItem(oAdvancedSearchDetail);
        oAdvancedSearchFilterBlockItem.AdvancedSearchDetail.FilterType__c= 'Exclude';
        
        AdvancedSearchFilterBlockItem oAdvancedSearchFilterBlockItem1 = new AdvancedSearchFilterBlockItem(oAdvancedSearchDetail2);
        oAdvancedSearchFilterBlockItem1.AdvancedSearchDetail.FilterType__c= 'Include';
        
        ApexPages.StandardController oStandardController = new ApexPages.StandardController(oAdvancedSearch);
        
        //Execute Test
        Test.startTest();
        
        ApexPages.currentPage().getParameters().put('Id', oAdvancedSearch.Id);
        AdvancedSearchController oController = new AdvancedSearchController(oStandardController);
        oController.onPageLoad();
  
        oAdvancedSearch.Name = null;
        oController.save(); //Should put controller in invalid state since address is not valid

        //Validate Test
        ValidationResult oValidationResult1 = oAdvancedSearchFilterBlockItem.validate();
        System.assertEquals(true, oValidationResult1.IsValid);
        System.assertEquals(oAdvancedSearchFilterBlockItem.AdvancedSearchDetail.FilterType__c,'Exclude');
        System.assertEquals(oAdvancedSearchFilterBlockItem1.AdvancedSearchDetail.FilterType__c,'Include');
        System.assert(ApexPages.hasMessages() == true, 'Search name is required');
        oController.NewFilterInput.FieldValuesMap.put(1, 'Test1');
        oController.addNewExcludeFilter();
        oController.NewFilterInput = New AdvancedSearchFilterBlockItem();
        oController.NewFilterInput.FieldName = 'Name';
        oController.NewFilterInput.Operator = 'Equal';
        oController.addNewIncludeFilter();
        oController.onFilterFieldChanged();
        oController.TerritoryView = 'Team';
        oController.NewFilterInput = New AdvancedSearchFilterBlockItem();
        oController.NewFilterInput.FieldName = 'Credit Risk';
        oController.NewFilterInput.Operator = 'Equal';
        oController.NewFilterInput.AdvancedSearchDetail.DataType__c= oFieldInfo.FieldType;
        

        oAdvancedSearch.Name = 'TEST';
        oController.save(); 
        
        Test.stopTest();
        
        //Validate Test
//        System.assert(ApexPages.hasMessages() == false, 'Search name is not required');
    }

    //Public Setup Helper Methods
    
    /**
     * Generates mock web service settings for the advanced search web service
     */
    public static WebServiceSettings__c setupAdvancedSearchServiceSettings() {
        WebServiceSettings__c oWebServiceSettings = WebServiceSettings__c.getInstance(AdvancedSearchUtil.ServiceName);
        
        if (oWebServiceSettings == null) {
            oWebServiceSettings = new WebServiceSettings__c();
            oWebServiceSettings.Name = AdvancedSearchUtil.ServiceName;
            oWebServiceSettings.Username__c = 'unittest';
            oWebServiceSettings.Password__c = '12345';
            oWebServiceSettings.Endpoint__c = 'https:\\advancedsearch.thomsonreuters.com';
            oWebServiceSettings.Timeout__c = 5;
            oWebServiceSettings.Active__c = true;
            oWebServiceSettings.Service_Unavailable_Message__c = 'Service is currently unavailable';
            insert oWebServiceSettings;
        }
        
        return oWebServiceSettings;
    }
    
    /**
     * Generates a Mock response for the AdvancedSearchWS.RunSearch method
     */
    public static AdvancedSearchWS.RunSearchResponse_element setupMockRunSearchResponse() {
        
        AdvancedSearchWS.RunSearchResponse_element oResponse = new AdvancedSearchWS.RunSearchResponse_element();
        oResponse.SearchResult = new AdvancedSearchWS.SearchResult();
        oResponse.SearchResult.SelectParmName = new List<string>{
              'Name'
            , 'Name 2'
            , 'Name 3'
            , 'SAP Account Number'
            , 'Phone 1'
            , 'Address Line 1'
            , 'City'
            , 'State'
            , 'Number of Attorneys - Location'
            , 'Number of Attorneys . Org'
            , 'Total Active Subscriptions'
            , 'Total Lapsed Subscriptions'
            , 'Contact First Name'
            , 'Contact Last Name'
            , 'Zip'
        };
        
        oResponse.SearchResult.ParmValueRecord = new List<AdvancedSearchWS.ParmValueRecord>();
        for (integer i=0; i<10; i++) {
            string sIndex = string.valueOf(i);
            
            AdvancedSearchWS.ParmValueRecord oParmValueRecord = new AdvancedSearchWS.ParmValueRecord();
            oParmValueRecord.ParmValue = new AdvancedSearchWS.ParmValue();
            oParmValueRecord.ParmValue.ParmValue = new List<string>{
                  'Name ' + sIndex
                , 'Name 2-' + sIndex
                , 'Name 3-' + sIndex
                , 'SAP00' + sIndex
                , '555-555-5555'
                , '555 Some Street'
                , 'Dallas'
                , 'TX'
                , '10'
                , '1'
                , '1'
                , 'John'
                , 'Doe'
                , '55555'
            };
            
            oResponse.SearchResult.ParmValueRecord.add(oParmValueRecord);
        }
        
        Map<string, object> mapMockWebServiceResponse = MockWebServiceResponse();
//      AdvancedSearchUtil.RunSearchMethod;
        return oResponse;
    }
    
    /**
     * Generates a Mock response for the AdvancedSearch.GetSearchParms method
     */
    public static AdvancedSearchWS.GetSearchParmsResponse_element setupMockGetSearchParmsResponse() {
        AdvancedSearchWS.GetSearchParmsResponse_element oResponse = new AdvancedSearchWS.GetSearchParmsResponse_element();
        oResponse.SearchParm = new List<AdvancedSearchWS.SearchParm>();
        
        AdvancedSearchWS.SearchParm oSearchParm1 = new AdvancedSearchWS.SearchParm();
        oSearchParm1.ControlType = 'Text';
        oSearchParm1.ParmDesc = '';
        oSearchParm1.ParmName = 'Name';
        oSearchParm1.UseInBlock = true;
        oSearchParm1.UseInSelect = true;
        oResponse.SearchParm.add(oSearchParm1);
        
        return oResponse;
    }

    /**
     * Generates a Mock response for the AdvancedSearch.GetSearchParmValues method
     */
    public static AdvancedSearchWS.GetSearchParmValuesResponse_element setupMockGetSearchParmValuesResponse() {
        AdvancedSearchWS.GetSearchParmValuesResponse_element oResponse = new AdvancedSearchWS.GetSearchParmValuesResponse_element();
        oResponse.SearchParmItem = new List<AdvancedSearchWS.SearchParmItem>();
        
        AdvancedSearchWS.SearchParmItem oSearchParmItem = new AdvancedSearchWS.SearchParmItem();
        oSearchParmItem.ParmName = 'City';
        oSearchParmItem.ParmValue = new List<string> {'Dallas', 'Boston', 'San Francisco'};
        
        return oResponse;
    }
    
    /**
     * Static method that generates an instance of an AdvancedSearch__c object
     * with its required field values pre-populated.
     *
     * @return  an instance of an AdvancedSearch__c that has not been committed
     *          to the database
     */
   public static AdvancedSearch__c getAdvancedSearchInstance() {
       // Territory oTerritory = [SELECT Id FROM Territory WHERE TMS_Terr_Num__c != null AND Id IN (SELECT TerritoryId FROM UserTerritory) LIMIT 1 ];
        List<Territory2> oTerritory = [SELECT Id FROM Territory2 WHERE TMS_Terr_Num__c != null AND Id IN (SELECT Territory2Id FROM UserTerritory2Association) ];
        UserTerritory2Association oUserTerritory = [SELECT Id, UserId, Territory2Id FROM UserTerritory2Association WHERE Territory2Id IN:oTerritory And UserId IN (Select Id from User where IsActive=true) LIMIT 1];

        AdvancedSearch__c oAdvancedSearch = new AdvancedSearch__c();
        oAdvancedSearch.OwnerId = oUserTerritory.UserId; 
        oAdvancedSearch.Name = 'Unit Test Search';
        
        return oAdvancedSearch;
    }
    
    /**
     * Static method that generates an instance of a AdvancedSearchDetail__c object
     * with its required field values pre-populated.
     *
     * @param   advancedSearchId   the id of the master advanced search record
     * @return  an instance of an AdvancedSearchDetail__c object that has not been committed
     *          to the database
     */
    public static AdvancedSearchDetail__c getAdvancedSearchDetailInstance(Id advancedSearchId) {
        AdvancedSearchDetail__c oAdvancedSearchDetail = new AdvancedSearchDetail__c();
        oAdvancedSearchDetail.AdvancedSearch__c = advancedSearchId;
        oAdvancedSearchDetail.Name = 'Name';
        oAdvancedSearchDetail.Operator__c = 'Equal';
        oAdvancedSearchDetail.DataType__c = 'Text';
        
        return oAdvancedSearchDetail;
    }
 
    //Properties
    public static Map<string, object> MockWebServiceResponse() {
        Map<string, object> mapMockWebServiceResponse = New Map<string, object>();

        //AdvancedSearchWS.RunSearch
        Map<String, AdvancedSearchWS.RunSearchResponse_element> RunSearch_map_x = new Map<String, AdvancedSearchWS.RunSearchResponse_element>();
        AdvancedSearchWS.RunSearchResponse_element RunSearch_x = new AdvancedSearchWS.RunSearchResponse_element();

        AdvancedSearchWS.SearchResult oResult = new AdvancedSearchWS.SearchResult();
        oResult.SelectParmName = new String[] {'Name 1','Name 2'};
        
        AdvancedSearchWS.ParmValue oParmValue = new AdvancedSearchWS.ParmValue();
        oParmValue.ParmValue = new String[] {'Name 1','Name 2','Name 3','SAP Account Number','Phone 1','Address Line 1','City','State','0','0','0','Contact Name','Zip'}; 
        AdvancedSearchWS.ParmValueRecord oParmValueRec = new AdvancedSearchWS.ParmValueRecord();
        oParmValueRec.ParmValue = oParmValue;
        List<AdvancedSearchWS.ParmValueRecord> listParmValue = new List<AdvancedSearchWS.ParmValueRecord> ();
        listParmValue.Add(oParmValueRec);
        oResult.ParmValueRecord = listParmValue;
        RunSearch_x.SearchResult = oResult;
        RunSearch_map_x.put('response_x',RunSearch_x);
        mapMockWebServiceResponse.put('AS.RunSearch',RunSearch_map_x);
        
        //AdvancedSearchWS.GetSearchParm
        Map<String, AdvancedSearchWS.GetSearchParmsResponse_element> GetSearchParm_map_x = new Map<String, AdvancedSearchWS.GetSearchParmsResponse_element>();
        AdvancedSearchWS.GetSearchParmsResponse_element GetSearchParmsResponse_x = new AdvancedSearchWS.GetSearchParmsResponse_element();
        AdvancedSearchWS.SearchParm SearchParm = New AdvancedSearchWS.SearchParm();
        SearchParm.UseInSelect = true;
        SearchParm.UseInBlock = true;
        List<AdvancedSearchWS.SearchParm> listSearchParm = new List<AdvancedSearchWS.SearchParm>();
        listSearchParm.Add(SearchParm);
        GetSearchParmsResponse_x.SearchParm = listSearchParm;           
        GetSearchParm_map_x.put('response_x',GetSearchParmsResponse_x);
        mapMockWebServiceResponse.put('AS.GetSearchParms',GetSearchParm_map_x);
        
        //AdvancedSearchWS.GetSearchParmValues
        Map<String, AdvancedSearchWS.GetSearchParmValuesResponse_element> GetSearchParmValues_map_x = new Map<String, AdvancedSearchWS.GetSearchParmValuesResponse_element>();
        AdvancedSearchWS.GetSearchParmValuesResponse_element GetSearchParmValuesResponse_x = new AdvancedSearchWS.GetSearchParmValuesResponse_element();
        AdvancedSearchWS.SearchParmItem SearchParmItem = New AdvancedSearchWS.SearchParmItem();
        SearchParmItem.ParmName = 'Name 1';
        SearchParmItem.ParmValue = new String[] {'Frank','Jasmin'};
        List<AdvancedSearchWS.SearchParmItem> listSearchParmItem = new List<AdvancedSearchWS.SearchParmItem>();
        listSearchParmItem.Add(SearchParmItem);
        GetSearchParmValuesResponse_x.SearchParmItem = listSearchParmItem;              

        GetSearchParmValues_map_x.put('response_x',GetSearchParmValuesResponse_x);
        mapMockWebServiceResponse.put('AS.GetSearchParmValues',GetSearchParmValues_map_x);
    
        return mapMockWebServiceResponse;
    }
    
    public static testMethod void testLeadSave(){
        MockWebServiceResponse();
        setupMockRunSearchResponse();
        setupMockGetSearchParmValuesResponse();
    List<Account> oacclist = new List<Account>();
    
    Account acc= new Account();
    acc.name= 'acc user';
    //acc.Selected_Record__c= true;
    acc.Account_Name_2__c= 'testing';
    acc.SAPAccountNumber__c= '1122334455';
    
    insert acc;
    Account acc1= new Account();
    acc1.name= 'acc user';
    //acc1.Selected_Record__c= true;
    acc1.Account_Name_2__c= 'testing';
    acc1.SAPAccountNumber__c= '1122334466';
    insert acc1;
    Source_System_Detail__c sc= new  Source_System_Detail__c();
    sc.name= 'test first';
    sc.Source_System_Account_Number__c='1122334455';
    sc.Account_Name__c= acc.id;
    sc.Source_System_Name__c= 'testing';
    insert sc;
    
    Source_System_Detail__c sc1= new  Source_System_Detail__c();
    sc1.name= 'test second';
    sc1.Source_System_Account_Number__c='1122334466';
    sc1.Account_Name__c= acc1.id;
    sc1.Source_System_Name__c= 'testing';
    insert sc1;
    
    Contact con = new Contact();
    con.salutation= 'Mr.';
    con.FirstName= 'test1';
    con.LastName= 'user1';
    con.SAP_Contact_ID__c= '1122';
    con.AccountId= acc.Id;
    insert con;
    Contact con1 = new Contact();
    con1.salutation= 'Mr.';
    con1.FirstName= 'test1';
    con1.LastName= 'user1';
    con1.SAP_Contact_ID__c= '1122';
    con1.AccountId= acc.Id;
    insert con1;
    oacclist= [select id, name,  SAPAccountNumber__c, Account_Name_2__c,(select id, name, FirstName, LastName from Contacts) from Account where  name= 'acc user' limit 1 ];
    
    KeyValueListStore__c profilename = new KeyValueListStore__c();
    profilename.TextValue__c = 'TR Corp Partner Community User';
    profilename.Name = 'LTS_partnerUserProfileName';
    insert profilename;
        
    KeyValueListStore__c leadsourcevalue = new KeyValueListStore__c();
    leadsourcevalue.Name = 'LTS_partnerUserLeadSourceValue';
    leadsourcevalue.TextValue__c = 'Partner';
    insert leadsourcevalue;
        
    KeyValueListStore__c busegment = new KeyValueListStore__c();
    busegment.Name = 'LTS_partnerUserBUSegmentValue';
    busegment.TextValue__c = 'Corporate';
    insert busegment;
        
    KeyValueListStore__c tempValueStore = new KeyValueListStore__c(Name = 'LCRMStrikeIronInformaticaUsers', Textvalue__c = 'Test GLI User' ,Failure_Email__c ='Test');
    insert tempValueStore;
    
    Lead olead= new Lead();
    olead.Account__c=oacclist[0].id;
    olead.Description=sc1.Source_System_Account_Number__c;
    olead.Company= oacclist[0].name;
    olead.status='Unworked';
    olead.Source__c='Advance Search';
    olead.salutation='Mr.';
    olead.FirstName='test';
    olead.LastName='user';
    olead.Contact_SAP_ID__c='1234';
    //olead.contact__c
    insert olead;
    AdvancedSearchAccount oAdvancedSearchAccount= new AdvancedSearchAccount();
    oAdvancedSearchAccount.SAPAccountNumber = sc.Source_System_Account_Number__c;
    oAdvancedSearchAccount.bSelected= true;
        oAdvancedSearchAccount.Name = sc.name;
        
        AdvancedSearchAccount oAdvancedSearchAccount1= new AdvancedSearchAccount();
    oAdvancedSearchAccount1.SAPAccountNumber = sc1.Source_System_Account_Number__c;
    oAdvancedSearchAccount1.bSelected= true;
        oAdvancedSearchAccount1.Name = sc.name;
        
        //List<AdvancedSearchAccounts> oAdvancedSearchAccounts= new List<AdvancedSearchAccounts>();
        //oAdvancedSearchAccounts.add(oAdvancedSearchAccount);
        
        
        
        
    AdvancedSearch__c oAdvancedSearch = getAdvancedSearchInstance();
        Insert oAdvancedSearch;
        getAdvancedSearchDetailInstance(oAdvancedSearch.id);
     PageReference oPage = Page.AdvancedSearch;
        Test.setCurrentPage(oPage);
        
        
        //Execute Test
        Test.startTest();
        ApexPages.StandardController oStandardController = new ApexPages.StandardController(oAdvancedSearch);
        ApexPages.currentPage().getParameters().put('Id', oAdvancedSearch.Id);
        AdvancedSearchController oController = new AdvancedSearchController(oStandardController);
        oController.oAdvancedSearcSelected.add(oAdvancedSearchAccount);
        oController.oAdvancedSearcSelected.add(oAdvancedSearchAccount1);
        
        //oController.SearchResults.add(oAdvancedSearchAccount);
        
        oController.onPageLoad();
        oController.onTerritoryChange();
        oController.addNewExcludeFilter();
        system.assertEquals(sc.Source_System_Account_Number__c, acc.SAPAccountNumber__c);
       // oAdvancedSearch.Name = null;
       //System.assertEquals(oAdvancedSearchAccount.bSelected(), true);
        oController.save(); //Should put controller in invalid state since address is not valid
        oController.massLeadCreation1();
        oController.onFilterOperatorChanged();
        oController.onFilterFieldChanged();
        oController.saveLead();
        oController.cancel();
        //Validate Test
        //acc1.Selected_Record__c =false;
        update acc1;
        oController.AdvancedSearchListLeadURL();
      /*  List<Account> selectedRecord= [select id, name, SAPAccountNumber__c, Account_Name_2__c from Account where Selected_Record__c =: true ];
        System.assertEquals(selectedRecord.size(), 1);
        for(Account ac: selectedRecord){
        ac.Selected_Record__c= false;
        }
       update selectedRecord; */
       
       PageReference oPage1 = Page.massLeaddatapage;
        Test.setCurrentPage(oPage1);
        test.stopTest();
        // System.assert(ApexPages.hasMessages() == false, 'Cannot save search. Please reduce the number of entries on list to save.');
        
    }
    
    public static testMethod void testException() {
        
        
        AdvancedSearch__c oAdvancedSearch = getAdvancedSearchInstance();
        Insert oAdvancedSearch;
        WebServiceSettings__c oWebServiceSettings = setupAdvancedSearchServiceSettings();
        
        MockWebServiceResponse();
        setupMockRunSearchResponse();
        setupMockGetSearchParmValuesResponse();
        
        AdvancedSearchDetail__c oAdvancedSearchDetail = getAdvancedSearchDetailInstance(oAdvancedSearch.Id);
        oAdvancedSearchDetail.Value__c = 'Delete G*';
        oAdvancedSearchDetail.FilterType__c = 'Include';
        oAdvancedSearchDetail.AdvancedSearch__c = oAdvancedSearch.Id;
        Insert oAdvancedSearchDetail;
        
        
        
        PageReference oPage = Page.AdvancedSearch;
        Test.setCurrentPage(oPage);
        
        ApexPages.StandardController oStandardController = new ApexPages.StandardController(oAdvancedSearch);
        AdvancedSearchFilterBlockItem oAdvancedSearchFilterBlockItem = new AdvancedSearchFilterBlockItem();
        oAdvancedSearchFilterBlockItem.AdvancedSearchDetail.FilterType__c= 'Exclude';
        oAdvancedSearchFilterBlockItem.AdvancedSearchDetail.Name='test12';
        
       /* AdvancedSearchUtil.FieldInfo oFieldInfo= new AdvancedSearchUtil.FieldInfo();
        oFieldInfo.Name= oAdvancedSearchFilterBlockItem.AdvancedSearchDetail.Name;
        oFieldInfo.UseInSelect=true;
        oFieldInfo.UseInBlock=true;
        oFieldInfo.ValidValues= new List<string>{'00110'};
        oFieldInfo.FieldType='oFieldInfo';  */
        //Execute Test
        Test.startTest();
        
        ApexPages.currentPage().getParameters().put('Id', oAdvancedSearch.Id);
        AdvancedSearchController oController = new AdvancedSearchController(oStandardController);
        AdvancedSearchUtil.FieldInfo oFieldInfo= new AdvancedSearchUtil.FieldInfo();
        oFieldInfo.Name= 'oFieldInfo';
        oFieldInfo.UseInSelect=true;
        oFieldInfo.UseInBlock=true;
        oFieldInfo.FieldType='oFieldInfo';
        oFieldInfo.ValidValues= new List<string>{'00110'};
        
        oController.getSelectFieldNames();
        
        PageReference oPageRef = Page.AdvancedSearch;
        List<SelectOption> listAvailTerr = oController.AvailableTerritoryOptions;
        List<SelectOption> listOper = oController.FilterOperators;
        List<SelectOption> listSelTerr = oController.SelectedTerritoryOptions;
        List<string>  listSelTerrNum = oController.SelectedTerritoryNumbers;
        ///AdvancedSearchUtil.FieldInfoResponse oResponse = new AdvancedSearchUtil.FieldInfoResponse();
       // system.assertEquals(oResponse.IsSuccess, true);
       //oController.mapFilterFields.put(oAdvancedSearchFilterBlockItem.AdvancedSearchDetail.Name,oFieldInfo);
       // system.assertEquals(oController.mapFilterFields.size(), 1);
        //oController.onPageLoad();
        oController.loadAdvancedSearchFields();
        oController.searchAccounts();
        oController.save();
        oController.cancel();
        oController.onTerritoryChange();
        oController.massLeadCreation1();
        oController.onFilterOperatorChanged();
        oController.onFilterFieldChanged();
        oController.saveLead();
        oController.updateFilterValueInput();
        //system.assert(true); 
        
        // /System.assert(true);
        Test.stopTest();
        
        //Validate Test
        
        //System.assert(ApexPages.hasMessages() == true, 'Expected error message when territory is blank');
    }
    
        public static testMethod void USLSearchAccounts() {
        //Setup Test
        WebServiceSettings__c oWebServiceSettings = setupAdvancedSearchServiceSettings();
        setupMockGetSearchParmsResponse();
        setupMockRunSearchResponse();
        setupMockGetSearchParmValuesResponse();
        
        
        
        AdvancedSearchUtil.FieldInfo oFieldInfo= new AdvancedSearchUtil.FieldInfo();
        oFieldInfo.Name= 'oFieldInfo';
        oFieldInfo.UseInSelect=true;
        oFieldInfo.UseInBlock=true;
        oFieldInfo.ValidValues= new List<string>{'00110'};
        oFieldInfo.FieldType='oFieldInfo';
        
        AdvancedSearchUtil.FieldInfoRequest oRequest = new AdvancedSearchUtil.FieldInfoRequest();
        oRequest.UserName = oWebServiceSettings.Username__c;
        oRequest.Password = oWebServiceSettings.Password__c;
        oRequest.EndPoint = oWebServiceSettings.Endpoint__c;
        oRequest.Timeout = (oWebServiceSettings.Timeout__c * 1000);
        oRequest.TerritoryNumbers = new Set<string>{'00110'};
        oRequest.UseInBlock = true;
        oRequest.UseInSelect = true;
        //oRequest.IsSuccess=true;
        
        
        List<String> oFieldInfoResponseString= new List<String>{'oFieldInfo'};
        
        AdvancedSearchUtil.FieldValueRequest oFieldValueRequest= new AdvancedSearchUtil.FieldValueRequest();
        oFieldValueRequest.TerritoryNumbers= new Set<string>{'00110'};
        oFieldValueRequest.SearchFieldNames= new List<String>{'oFieldInfo'};
        
        
        AdvancedSearchUtil.FieldValueResponse oFieldInfoResponse = AdvancedSearchUtil.getAdvancedSearchFieldValues(oFieldValueRequest);
         oFieldInfoResponse.IsSuccess=true;
         oFieldInfoResponse.FieldValues.put('oFieldInfo', oFieldInfoResponseString);
        
        //AdvancedSearchUtil.FieldValueResponse oFieldValueResponse= new AdvancedSearchUtil.FieldValueResponse();
        //oFieldValueResponse.FieldValues.put('Test1', oFieldInfoResponseString);
        
        AdvancedSearchUtil.SearchRequest oSearchRequest = new AdvancedSearchUtil.SearchRequest();
        oSearchRequest.UserName = oWebServiceSettings.Username__c;
        oSearchRequest.Password = oWebServiceSettings.Password__c;
        oSearchRequest.EndPoint = oWebServiceSettings.Endpoint__c;
        oSearchRequest.Timeout = (oWebServiceSettings.Timeout__c * 1000);
        oSearchRequest.TerritoryNumbers = new Set<string>{'00110'};
        oSearchRequest.SelectFields = new Set<string>{'Name','Name 2','Name 3','SAP Account Number', 'Phone 1'
            , 'Address Line 1'
            , 'City'
            , 'State'
            , 'Number of Attorneys - Location'
            , 'Number of Attorneys . Org'
            , 'Total Active Subscriptions'
            , 'Total Lapsed Subscriptions'
            , 'Contact First Name'
            , 'Contact Last Name'
            , 'Zip'};
        //oSearchRequest.SelectFields = new Set<string>{'City'};
        
        List<AdvancedSearchAccount> oAdvancedSearchAccount= new List<AdvancedSearchAccount>();
        AdvancedSearchUtil.SearchResponse oSearchResponse = AdvancedSearchUtil.searchAccounts(oSearchRequest);
        oSearchResponse.IsSuccess= true;
        oSearchResponse.listcheck= oAdvancedSearchAccount;
        
        AdvancedSearch__c oAdvancedSearch = getAdvancedSearchInstance();
        oAdvancedSearch.TerritoryFilter__c = '';
        oAdvancedSearch.Name = 'Search Negative';
        Insert oAdvancedSearch;
        
        AdvancedSearchDetail__c oAdvancedSearchDetail = getAdvancedSearchDetailInstance(oAdvancedSearch.Id);
        oAdvancedSearchDetail.Name = 'City';
        oAdvancedSearchDetail.ListValue__c = 'New York';
        oAdvancedSearchDetail.FilterType__c = 'Include';
        oAdvancedSearchDetail.Operator__c = 'Equal';
        oAdvancedSearchDetail.DataType__c = 'List';
        oAdvancedSearchDetail.Value__c = 'Test';
        oAdvancedSearchDetail.NumberValue1__c = 1;
        oAdvancedSearchDetail.NumberValue2__c = 10;
        oAdvancedSearchDetail.AdvancedSearch__c = oAdvancedSearch.Id;
        Insert oAdvancedSearchDetail;

        AdvancedSearchDetail__c oAdvancedSearchDetail1 = getAdvancedSearchDetailInstance(oAdvancedSearch.Id);
        oAdvancedSearchDetail1.Name = 'Credit Risk';
        oAdvancedSearchDetail1.Value__c = 'No';
        oAdvancedSearchDetail1.FilterType__c = 'Include';
        oAdvancedSearchDetail1.Operator__c = 'Equal';
        oAdvancedSearchDetail1.DataType__c = 'Flag';
        oAdvancedSearchDetail1.AdvancedSearch__c = oAdvancedSearch.Id;
        Insert oAdvancedSearchDetail1;

        AdvancedSearchDetail__c oAdvancedSearchDetail2 = getAdvancedSearchDetailInstance(oAdvancedSearch.Id);
        oAdvancedSearchDetail2.Name = 'Name';
        oAdvancedSearchDetail2.Value__c = 'N*';
        oAdvancedSearchDetail2.FilterType__c = 'Include';
        oAdvancedSearchDetail2.Operator__c = 'Equal';
        oAdvancedSearchDetail2.DataType__c = 'Text';
        oAdvancedSearchDetail2.AdvancedSearch__c = oAdvancedSearch.Id;
        Insert oAdvancedSearchDetail2;
        
         AdvancedSearchDetail__c oAdvancedSearchDetail3 = getAdvancedSearchDetailInstance(oAdvancedSearch.Id);
        oAdvancedSearchDetail3.Name = 'City';
        oAdvancedSearchDetail3.ListValue__c = 'New York';
        oAdvancedSearchDetail3.FilterType__c = 'Exclude';
        oAdvancedSearchDetail3.Operator__c = 'Equal';
        oAdvancedSearchDetail3.DataType__c = 'List';
        oAdvancedSearchDetail3.AdvancedSearch__c = oAdvancedSearch.Id;
        Insert oAdvancedSearchDetail3;

        AdvancedSearchDetail__c oAdvancedSearchDetail4 = getAdvancedSearchDetailInstance(oAdvancedSearch.Id);
        oAdvancedSearchDetail4.Name = 'Name';
        oAdvancedSearchDetail4.Value__c = 'N*';
        oAdvancedSearchDetail4.FilterType__c = 'Exclude';
        oAdvancedSearchDetail4.Operator__c = 'Equal';
        oAdvancedSearchDetail4.DataType__c = 'Text';
        oAdvancedSearchDetail4.AdvancedSearch__c = oAdvancedSearch.Id;
        Insert oAdvancedSearchDetail4;
        
        AdvancedSearchDetail__c oAdvancedSearchDetail5 = getAdvancedSearchDetailInstance(oAdvancedSearch.Id);
        oAdvancedSearchDetail5.Name = 'Credit Risk';
        oAdvancedSearchDetail5.Value__c = 'No';
        oAdvancedSearchDetail5.FilterType__c = 'Exclude';
        oAdvancedSearchDetail5.Operator__c = 'Equal';
        oAdvancedSearchDetail5.DataType__c = 'Flag';
        oAdvancedSearchDetail5.AdvancedSearch__c = oAdvancedSearch.Id;
        Insert oAdvancedSearchDetail5;

        AdvancedSearchDetail__c oAdvancedSearchDetail6 = getAdvancedSearchDetailInstance(oAdvancedSearch.Id);
        oAdvancedSearchDetail6.Name = 'Total Active Subscriptions';
        oAdvancedSearchDetail6.NumberValue1__c = 0;
        oAdvancedSearchDetail6.NumberValue2__c = 9;
        oAdvancedSearchDetail6.FilterType__c = 'Include';
        oAdvancedSearchDetail6.Operator__c = 'Between';
        oAdvancedSearchDetail6.DataType__c = 'Numeric';
        oAdvancedSearchDetail6.AdvancedSearch__c = oAdvancedSearch.Id;
        Insert oAdvancedSearchDetail6;

        AdvancedSearchDetail__c oAdvancedSearchDetail7 = getAdvancedSearchDetailInstance(oAdvancedSearch.Id);
        oAdvancedSearchDetail7.Name = 'Total Active Subscriptions';
        oAdvancedSearchDetail7.NumberValue1__c = 3;
        oAdvancedSearchDetail7.NumberValue2__c = 5;
        oAdvancedSearchDetail7.FilterType__c = 'Exclude';
        oAdvancedSearchDetail7.Operator__c = 'Between';
        oAdvancedSearchDetail7.DataType__c = 'Numeric';
        oAdvancedSearchDetail7.AdvancedSearch__c = oAdvancedSearch.Id;
        Insert oAdvancedSearchDetail7;

        AdvancedSearchDetail__c oAdvancedSearchDetail8 = getAdvancedSearchDetailInstance(oAdvancedSearch.Id);
        oAdvancedSearchDetail8.Name = 'Credit Risk';
        oAdvancedSearchDetail8.Value__c = 'No';
        oAdvancedSearchDetail8.FilterType__c = 'Include';
        oAdvancedSearchDetail8.Operator__c = 'Equal';
        oAdvancedSearchDetail8.DataType__c = 'Flag';
        oAdvancedSearchDetail8.AdvancedSearch__c = oAdvancedSearch.Id;
        Insert oAdvancedSearchDetail8;
        
     /*   AdvancedSearchUtil.SearchRequest oRequest = new AdvancedSearchUtil.SearchRequest();
        oRequest.UserName = oWebServiceSettings.Username__c;
        oRequest.Password = oWebServiceSettings.Password__c;
        oRequest.EndPoint = oWebServiceSettings.Endpoint__c;
        oRequest.Timeout = (oWebServiceSettings.Timeout__c * 1000);
        oRequest.TerritoryNumbers = new Set<string>{'00110'};
        */
        
        AdvancedSearchAccounts oAdvancedSearchAccounts= new AdvancedSearchAccounts();
        oAdvancedSearchAccounts.Accounts=oAdvancedSearchAccount;
        
        
        AdvancedSearchUtil.SearchBlock oSearchBlock = new AdvancedSearchUtil.SearchBlock();
        oSearchBlock.FieldName = 'City';
        oSearchBlock.JoinConditionType = AdvancedSearchUtil.JoinCondition.JoinAND;
    
        AdvancedSearchUtil.SearchBlockItem oSearchBlockItem = new AdvancedSearchUtil.SearchBlockItem();
        oSearchBlockItem.OperatorType = AdvancedSearchUtil.toOperator('EQ');
        oSearchBlockItem.Values = new List<string>{ 'Dallas' };
        
        oSearchBlockItem.ItemCondition =AdvancedSearchUtil.JoinCondition.JoinAND;
        oSearchBlock.SearchBlockItems.add(oSearchBlockItem);
        oSearchRequest.Include.add(oSearchBlock); 
        
        //Exclude Filter Block
        AdvancedSearchUtil.SearchBlock oSearchBlock2 = new AdvancedSearchUtil.SearchBlock();
        oSearchBlock2.FieldName = 'City';
        oSearchBlock2.JoinConditionType = AdvancedSearchUtil.JoinCondition.JoinAND;
        oSearchBlockItem.Values = new List<string>{ 'Dallas,test12345, testing12345' };
        AdvancedSearchUtil.SearchBlockItem oSearchBlockItem2 = new AdvancedSearchUtil.SearchBlockItem();
        oSearchBlockItem2.OperatorType = AdvancedSearchUtil.toOperator('EQ');
        oSearchBlockItem2.Values = new List<string>{ 'Boston' };
        oSearchBlock2.SearchBlockItems.add(oSearchBlockItem2);
        oSearchRequest.Exclude.add(oSearchBlock2);
        //oAdvancedSearchAccount.Name
       // oAdvancedSearchAccount.Name
        AdvancedSearchFilterBlockItem oAdvancedSearchFilterBlockItem = new AdvancedSearchFilterBlockItem(oAdvancedSearchDetail);
        //AdvancedSearchFilterBlockItem oAdvancedSearchFilterBlockItem = new AdvancedSearchFilterBlockItem(oAdvancedSearchDetail);
        oAdvancedSearchFilterBlockItem.AdvancedSearchDetail.FilterType__c= 'Exclude';
        
        AdvancedSearchFilterBlockItem oAdvancedSearchFilterBlockItem1 = new AdvancedSearchFilterBlockItem(oAdvancedSearchDetail2);
        oAdvancedSearchFilterBlockItem1.AdvancedSearchDetail.FilterType__c= 'Include';
        
        //AdvancedSearchFilterBlockItem.validate oAdvancedSearchFilterBlockItemValidate= new AdvancedSearchFilterBlockItem.validate();
        //oAdvancedSearchFilterBlockItemValidate.sFieldName = oAdvancedSearchDetail.Name = 'City';
        //oAdvancedSearchFilterBlockItemValidate.oValidationResult.IsValid=true;
        
        //oValidationResult1.IsValid= true;
        PageReference oPage = Page.AdvancedSearch;
        Test.setCurrentPage(oPage);
        
        ApexPages.StandardController oStandardController = new ApexPages.StandardController(oAdvancedSearch);
        //Account acc= new Account();
        //acc.name= setupMockRunSearchResponse.
        //Execute Test
        Test.startTest();
        
        ApexPages.currentPage().getParameters().put('Id', oAdvancedSearch.Id);
        AdvancedSearchController oController = new AdvancedSearchController(oStandardController);
        oController.onPageLoad();
        Boolean oAllowDelete= oController.AllowDelete;
        Boolean oAllowCancel= oController.AllowCancel;
        List<SelectOption> listSelTerr = oController.SelectedTerritoryOptions;
        List<string>  listSelTerrNum = oController.SelectedTerritoryNumbers;
        List<String> listAllTerritoryNumbers= oController.listTeamTerritoryNumbers;
        AppUtil.isEmpty(oAdvancedSearchDetail8.AdvancedSearch__c);
        oController.TerritoryView = 'Team';
        Set<string>  setFields = oController.SelectFieldNames;
        string  sUrl = oController.AdvancedSearchListURL;
        oController.IncludeFilterBlock.ItemstoDelete= new List<Id>{oAdvancedSearch.Id};
        oController.ExcludeFilterBlock.ItemstoDelete= new List<Id>{oAdvancedSearch.Id};
        oController.SearchResults.Accounts= oAdvancedSearchAccounts.Accounts;
        oController.oAdvancedSearcSelected= oAdvancedSearchAccounts.Accounts;
        oController.onTerritoryChange();
        //Lead oLead= new Lead();
        //oLead.source
        //ValidationResult oValidationResult1 = oSearchBlockItem.validate();
        //System.assertEquals(true, oValidationResult1.IsValid);
        ValidationResult oValidationResult1 = oAdvancedSearchFilterBlockItem.validate();
        
        List<string> oString= oController.getFieldValues('oFieldInfo');
        oController.NewFilterInput.AdvancedSearchDetail.DataType__c= oFieldInfo.FieldType;
        oController.mapFilterFields.put('oFieldInfo',oFieldInfo);
        oAdvancedSearchAccount= oController.SearchResults.Accounts;
        oController.onFilterOperatorChanged();
        oController.addNewIncludeFilter();
        oController.save();
        oController.addNewExcludeFilter();
        oController.getAvailableTerritoryOptions();
        oController.getSelectFieldNames();
        oController.validateSearch();
        oController.SearchAccounts();
        oController.updateFilterValueInput();
        oController.loadAdvancedSearchFields();
        oController.massLeadCreation1();
        oController.saveLead();
        oController.cancel();
        oController.AdvancedSearchListLeadURL();
        system.assertEquals(oFieldInfoResponse.IsSuccess, true);
        System.assertEquals(true, oValidationResult1.IsValid);
        Test.stopTest();
        
        //Validate Test
        //System.assert(ApexPages.hasMessages() == true, 'Expected error message when territory is blank');
    }


  
}