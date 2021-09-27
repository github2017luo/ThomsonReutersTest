/**
 * Validates the functionality provided by the AdvancedSearchUtil class
 *
 * @author  John De Santiago
 * @version 2012-08-03
 */
@IsTest
private class AdvancedSearchUtil_Test {

    /**
     * Validates the helper methods for working with Operator values
     */
    private static testMethod void testOperatorHelperMethods() {
        string sOperator = AdvancedSearchUtil.getOperatorValue(AdvancedSearchUtil.Operator.Equal);
        sOperator = AdvancedSearchUtil.getOperatorValue(AdvancedSearchUtil.Operator.LessThan);
        sOperator = AdvancedSearchUtil.getOperatorValue(AdvancedSearchUtil.Operator.GreaterThan);
        sOperator = AdvancedSearchUtil.getOperatorValue(AdvancedSearchUtil.Operator.LessThanEqualTo);
        sOperator = AdvancedSearchUtil.getOperatorValue(AdvancedSearchUtil.Operator.GreaterThanEqualTo);
        sOperator = AdvancedSearchUtil.getOperatorValue(AdvancedSearchUtil.Operator.Between);
        //sOperator = AdvancedSearchUtil.getOperatorValue(AdvancedSearchUtil.Operator);
        
        AdvancedSearchUtil.Operator eOperator = AdvancedSearchUtil.toOperator('Between');
        eOperator = AdvancedSearchUtil.toOperator('Equal');
        eOperator = AdvancedSearchUtil.toOperator('LessThan');
        eOperator = AdvancedSearchUtil.toOperator('GreaterThan');
        eOperator = AdvancedSearchUtil.toOperator('LessThanEqualTo');
        eOperator = AdvancedSearchUtil.toOperator('GreaterThanEqualTo');
        eOperator = AdvancedSearchUtil.toOperator('Between');
    }
    
    @IsTest static void testSearchRequest() {
        //Setup Test
       
        List <Account> lstacc= new List<Account>();
        Account acc1= UnitTest.getAccountInstance();
        acc1.Name = 'testAccount';
        acc1.Customer_Type__c = 'Organization';
        acc1.Customer_Group__c = '';
        acc1.Industry = 'GVT-COUNTY';
        acc1.SAPAccountNumber__c = 'SAP001';
        acc1.Is_GLI__c=true;
        lstacc.add(acc1);
       
        
       
        
        Account acc2= UnitTest.getAccountInstance();
        acc2.Name = 'testAccount1';
        acc2.Account_Name_2__c ='testAbc2';
        acc2.Account_Name_3__c = 'testAbc3';
        acc2.Customer_Type__c = 'Organization';
        acc2.Customer_Group__c = '';
        acc2.Industry = 'GVT-COUNTY';
        acc2.SAPAccountNumber__c = 'SAP002';
        acc2.Is_GLI__c=true;
        lstacc.add(acc2); 
        
        insert lstacc;
         
        List<Contact> conList = new List<Contact>();
        Contact u = new Contact();
        u.accountId=acc2.id;
        u.FirstName='Steve';
        u.LastName='Mark'; 
        u.Email='stevemark@gmail.com';
        conList.add(u);
        
        Contact u1 = new Contact();
        u1.accountId=acc1.id;
        u1.FirstName='Steve1';
        u1.LastName='Mark1'; 
        u1.Email='stevemark123@gmail.com';
        conList.add(u1);
        
        insert conList;
         
        
        Account acc3= UnitTest.getAccountInstance();
        acc3.Name = 'testAccount1';
        acc3.Customer_Type__c = 'Organization';
        acc3.Customer_Group__c = '';
        acc3.Industry = 'GVT-COUNTY';
        acc3.SAPAccountNumber__c = 'SAP003';
        acc3.Is_GLI__c=false;
        lstacc.add(acc3); 
        
        WebServiceSettings__c oWebServiceSettings = setupAdvancedSearchServiceSettings();
        setupMockRunSearchResponse();
        setupMockGetSearchParmsResponse();
        setupMockGetSearchParmValuesResponse();
        
        //Test.setMock(HttpCalloutMock.class, new  DellBoomiTokenGeneration_Test.DellBoomiCalloutMock());
        
        AdvancedSearchUtil.SearchRequest oRequest = new AdvancedSearchUtil.SearchRequest();
        //oRequest.UserName = oWebServiceSettings.Username__c;
        //oRequest.Password = oWebServiceSettings.Password__c;
        oRequest.accessToken = 'aWHdci6rHDaEAHwcy9gJCg4lscFZ';
          //oRequest.accessToken=accessToken; 
        oRequest.EndPoint = oWebServiceSettings.Endpoint__c;
        oRequest.Timeout = (oWebServiceSettings.Timeout__c * 1000);
            oRequest.TerritoryNumbers = new Set<string>{'00110'};
        oRequest.SelectFields = new Set<string>{'Name','Name 2','Name 3','SAP Account Number', 'Phone 1'
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
          
            AdvancedSearchUtil.FieldInfo ofieldinfo = new AdvancedSearchUtil.FieldInfo();
        ofieldinfo .Name ='Name';
        ofieldinfo .FieldType ='Text';
        ofieldinfo .Description ='';
        ofieldinfo .UseInSelect = true;
        ofieldinfo .UseInBlock = true;
            
            AdvancedSearchUtil.FieldInfoResponse oFieldInfoResponse = new AdvancedSearchUtil.FieldInfoResponse();
        //oFieldInfoResponse.UserName = oWebServiceSettings.Username__c;
        //oFieldInfoResponse.Password = oWebServiceSettings.Password__c;
        //oFieldInfoResponse.EndPoint = oWebServiceSettings.Endpoint__c;
        //oFieldInfoResponse.Timeout = (oWebServiceSettings.Timeout__c * 1000);
       // oFieldInfoResponse.TerritoryNumbers = new Set<string>{'00110'};
        oFieldInfoResponse.mapFields.put('test1234', ofieldinfo);
       // oFieldInfoResponse.Fields = new List<AdvancedSearchUtil.FieldInfo>{ofieldinfo};
        
        ValidationResult oValidationResult=new ValidationResult();
        //Include Filter Block
        AdvancedSearchUtil.SearchBlock oSearchBlock = new AdvancedSearchUtil.SearchBlock();
        oSearchBlock.FieldName = 'City';
        oSearchBlock.JoinConditionType = AdvancedSearchUtil.JoinCondition.JoinAND;
    
        AdvancedSearchUtil.SearchBlockItem oSearchBlockItem = new AdvancedSearchUtil.SearchBlockItem();
        oSearchBlockItem.OperatorType = AdvancedSearchUtil.toOperator('EQ');
        oSearchBlockItem.Values = new List<string>{ 'Dallas' };
        
        oSearchBlockItem.ItemCondition =AdvancedSearchUtil.JoinCondition.JoinAND;
        oSearchBlock.SearchBlockItems.add(oSearchBlockItem);
        oRequest.Include.add(oSearchBlock); 
        
        //Exclude Filter Block
        AdvancedSearchUtil.SearchBlock oSearchBlock2 = new AdvancedSearchUtil.SearchBlock();
        oSearchBlock2.FieldName = 'City';
        oSearchBlock2.JoinConditionType = AdvancedSearchUtil.JoinCondition.JoinAND;
    
        AdvancedSearchUtil.SearchBlockItem oSearchBlockItem2 = new AdvancedSearchUtil.SearchBlockItem();
        oSearchBlockItem2.OperatorType = AdvancedSearchUtil.toOperator('EQ');
        oSearchBlockItem2.Values = new List<string>{ 'Boston' };
        oSearchBlock2.SearchBlockItems.add(oSearchBlockItem2);
        oRequest.Exclude.add(oSearchBlock2);    
        
        AdvancedSearchAccount oAdvancedSearchAccount = new AdvancedSearchAccount();
        oAdvancedSearchAccount.AccountId= acc1.id;
        oAdvancedSearchAccount.Name='ABILENE CHRISTIAN UNIV LIBRARY';
        oAdvancedSearchAccount.Name2='PARALEGAL ACCOUNT';
        oAdvancedSearchAccount.Name3='MARK MCCALLON';
        //oAdvancedSearchAccount.bSelected=
        oAdvancedSearchAccount.SAPAccountNumber='1003079390';
        oAdvancedSearchAccount.Phone1='325-674-234';
        oAdvancedSearchAccount.AddressLine1='221 BROWN LIBRARY ACU BOX 29208';
        oAdvancedSearchAccount.TotalLapsedSubs=21;
        oAdvancedSearchAccount.TotalActiveSubs= 4;
        oAdvancedSearchAccount.ZipCode='79699';
        oAdvancedSearchAccount.NumberOfAttorneyOrg=5;
        //oAdvancedSearchAccount.NumberOfAttorneyLocations=
        oAdvancedSearchAccount.City='ABILENE';
        oAdvancedSearchAccount.State='TX';
        oAdvancedSearchAccount.ContactName='- ABILENE CHRISTIAN UNIV';
        List<AdvancedSearchAccount> oAccountList=new List<AdvancedSearchAccount>();
        oAccountList.add(oAdvancedSearchAccount);
        
        
        
        
        Source_System_Detail__c source= new Source_System_Detail__c();
        source.Source_System_Name__c='Advanced srch1';
        source.Account_Name__c=acc1.Id;
        source.Name='Advanced srch';
        source.Source_System_Account_Number__c ='SAP001';
        
        List<Source_System_Detail__c> sourcelist =new List<Source_System_Detail__c>();
        sourcelist.add(source);
        insert sourcelist;
      
        //Execute Test
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new  DellBoomiTokenGeneration_Test.DellBoomiCalloutMock());
        AdvancedSearchUtil.Response oResponseObj = new AdvancedSearchUtil.Response();
        AdvancedSearchUtil.SearchResponse oResponse = AdvancedSearchUtil.searchAccounts(oRequest);
        //oResponse.SearchResults= 
        AdvancedSearchUtil.SearchResultRecord oResponse1 = new  AdvancedSearchUtil.SearchResultRecord();
        oResponse1.FieldNames =new List<string> {'Dallas', 'Boston', 'San Francisco'};
        oResponse1.FieldValues=new List<string> {'Dallas', 'Boston', 'San Francisco'};
        Test.stopTest();
        
    }
    
    private static testMethod void testGetSearchFields() {
        //Setup Test
         
        
        WebServiceSettings__c oWebServiceSettings = setupAdvancedSearchServiceSettings();
        setupMockGetSearchParmsResponse();
        AdvancedSearchUtil.FieldInfo ofieldinfo = new AdvancedSearchUtil.FieldInfo();
        ofieldinfo .Name ='Name';
        ofieldinfo .FieldType ='Text';
        ofieldinfo .Description ='';
        ofieldinfo .UseInSelect = true;
        ofieldinfo .UseInBlock = true;
        AdvancedSearchUtil.FieldInfoRequest oRequest = new AdvancedSearchUtil.FieldInfoRequest();
        oRequest.UserName = oWebServiceSettings.Username__c;
        //oRequest.Password = oWebServiceSettings.Password__c;
        //oRequest.EndPoint = oWebServiceSettings.Endpoint__c;
        oRequest.accessToken = 'aWHdci6rHDaEAHwcy9gJCg4lscFZ';
        oRequest.Timeout = (oWebServiceSettings.Timeout__c * 1000);
        oRequest.TerritoryNumbers = new Set<string>{'00110'};
        oRequest.UseInBlock = true;
        oRequest.UseInSelect = true;
        
        
        AdvancedSearchUtil.SearchRequest oSearchRequest = new AdvancedSearchUtil.SearchRequest();
        //oSearchRequest.UserName = oWebServiceSettings.Username__c;
        //oSearchRequest.Password = oWebServiceSettings.Password__c;
        oSearchRequest.accessToken = 'aWHdci6rHDaEAHwcy9gJCg4lscFZ';
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
        //Execute Test
         AdvancedSearchUtil.FieldInfoResponse oResponse1 = new AdvancedSearchUtil.FieldInfoResponse();
        Test.startTest();
        AdvancedSearchUtil.FieldInfoResponse oFieldInfoResponse = new AdvancedSearchUtil.FieldInfoResponse();
        oFieldInfoResponse.mapFields.put(ofieldinfo.Name, ofieldinfo);
        AdvancedSearchUtil.FieldInfoResponse oResponse = AdvancedSearchUtil.getAdvancedSearchFields(oRequest);
        oResponse.getListFieldNames();
        
        //List<String> lststring = oResponse .getListFieldNames();
        AdvancedSearchUtil.SearchResponse oSearchResponse = AdvancedSearchUtil.searchAccounts(oSearchRequest);
        AdvancedSearchUtil.SearchResultRecord searchresult = new AdvancedSearchUtil.SearchResultRecord();
        searchresult.FieldNames =new List<string> {'Dallas', 'Boston', 'San Francisco'};
        searchresult.FieldValues=new List<string> {'Dallas', 'Boston', 'San Francisco'};
        
        
        
        AdvancedSearchWS.SearchParmItem oSearchParmItem = new AdvancedSearchWS.SearchParmItem();
        oSearchParmItem.ParmName = 'City';
        oSearchParmItem.ParmValue = new List<string> {'Dallas', 'Boston', 'San Francisco'};
        
        AdvancedSearchWS.SearchParmItem oSearchParmItem1= new AdvancedSearchWS.SearchParmItem();
        oSearchParmItem1.ParmName = 'City';
        oSearchParmItem1.ParmValue = new List<string> {'Boston'};
        
        AdvancedSearchWS.SearchParm oSearchParm1 = new AdvancedSearchWS.SearchParm();
        oSearchParm1.ControlType = 'Text';
        oSearchParm1.ParmDesc = '';
        oSearchParm1.ParmName = 'Name';
        oSearchParm1.UseInBlock = true;
        oSearchParm1.UseInSelect = true;
        //oResponse1.parse(listsearchparam);
        
        ValidationResult oValidationResult1 = new ValidationResult();
        oValidationResult1.IsValid=true;
        oValidationResult1.Failures.add('Request must specify UseInSelect or UseInBlock');
        AdvancedSearchWS.SearchParmItem[] lstsearchparam = new AdvancedSearchWS.SearchParmItem[]{oSearchParmItem,oSearchParmItem1};
        AdvancedSearchWS.SearchParm[] listsearchparam = new AdvancedSearchWS.SearchParm[]{oSearchParm1};
        
        //AdvancedSearchUtil.FieldValueResponse.parse(lstsearchparam );
       AdvancedSearchUtil.FieldValueResponse oFieldValueResponse= new AdvancedSearchUtil.FieldValueResponse();
          oFieldValueResponse.parse(lstsearchparam);
          oFieldInfoResponse.parse(listsearchparam);
        
        Test.stopTest();
    }
    
    private static testMethod void testGetSearchFieldValues() {
        //Setup Test
        WebServiceSettings__c oWebServiceSettings = setupAdvancedSearchServiceSettings();
        setupMockGetSearchParmValuesResponse();
        setupMockGetSearchParmsResponse();
        AdvancedSearchUtil.FieldInfoRequest oFieldInfoRequest = new AdvancedSearchUtil.FieldInfoRequest();
        //oFieldInfoRequest.UserName = oWebServiceSettings.Username__c;
        //oFieldInfoRequest.Password = oWebServiceSettings.Password__c;
        oFieldInfoRequest.accessToken = 'aWHdci6rHDaEAHwcy9gJCg4lscFZ';
        oFieldInfoRequest.EndPoint = oWebServiceSettings.Endpoint__c;
        oFieldInfoRequest.Timeout = (oWebServiceSettings.Timeout__c * 1000);
        oFieldInfoRequest.TerritoryNumbers = new Set<string>{'00110'};
        oFieldInfoRequest.UseInBlock = false;
        oFieldInfoRequest.UseInSelect = false;
        
        //oFieldInfoRequest.FieldValueRequest();
        
        AdvancedSearchUtil.FieldValueRequest oRequest = new AdvancedSearchUtil.FieldValueRequest();
        //oRequest.UserName = oWebServiceSettings.Username__c;
        //oRequest.Password = oWebServiceSettings.Password__c;
        oRequest.accessToken = 'aWHdci6rHDaEAHwcy9gJCg4lscFZ';
        oRequest.EndPoint = oWebServiceSettings.Endpoint__c;
        oRequest.Timeout = (oWebServiceSettings.Timeout__c * 1000);
        oRequest.TerritoryNumbers = new Set<string>{'00110'};
        oRequest.SearchFieldNames = new List<string>{'City'};
        
        //Execute Test
        Test.startTest(); 
        
        AdvancedSearchUtil.FieldValueResponse oResponse = AdvancedSearchUtil.getAdvancedSearchFieldValues(oRequest);
        AdvancedSearchUtil.SearchResultRecord oResponse1 = new  AdvancedSearchUtil.SearchResultRecord();
        string sOperator = AdvancedSearchUtil.getOperatorValue(AdvancedSearchUtil.Operator.Equal);
        oResponse1.FieldNames =new List<string> {'Dallas', 'Boston', 'San Francisco'};
        oResponse1.FieldValues=new List<string> {'Dallas', 'Boston', 'San Francisco'};
        
        ValidationResult oValidationResult1 = new ValidationResult();
        oValidationResult1.IsValid=false;
        oValidationResult1.Failures.add('Request must specify UseInSelect or UseInBlock');
        AdvancedSearchUtil.FieldInfoResponse oResponse12 = AdvancedSearchUtil.getAdvancedSearchFields(oFieldInfoRequest);
        //oResponse.getListFieldNames();
        Test.stopTest();
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
                , '1'
                , 'John'
                , 'Doe'
                , '55555'
            };
            
            oResponse.SearchResult.ParmValueRecord.add(oParmValueRecord);
        }
        
        UnitTest.MockWebServiceResponse.put(AdvancedSearchUtil.RunSearchMethod, oResponse);
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
    
}