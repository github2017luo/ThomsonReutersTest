@isTest
public class TestStandardAccountRestApi {
    
    /* -----------------------------------------------------------------------------------------------------
Method NAME: accountExactNameSearch
PURPOSE : The purpose of this method is to search account on basis of account number .
-------------------------------------------------------------------------------------------------------*/
    @isTest
    static  void accountExactNameSearch() {
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        //req.requestURI = 'https://cs1.salesforce.com/services/apexrest/StandardAccountRestApi';
        req.requestURI = 'https://'+URL.getSalesforceBaseUrl().getHost()+'/services/apexrest/StandardAccountRestApi'; 
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf('{"ESIHeader": {"applicationId": "string","transactionId": "string","messageId": "Exact","messageHistory": "string","tracingId": "string","timeStamp": "2008-09-29T01:49:45","instanceId": "string","companyId": "string","configGroup": "string","payloadVersion": "string","postBackURL": "string","extensibleAttributes": [{"key": "string","value": "string"}]},"account": {"accountNumber": "01777","companyId": "string","companyName": "string","address": [{"city": "string","county": "string"}]}}');
        TestDataFactory();
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();         
        StandardAccountRestApi.AccountResponseWrapper testList = StandardAccountRestApi.getAccount();       
        System.assertEquals('200', testList.GetAccountDetailsResponse.statusDetails.statusCode); 
        Test.stopTest();
        
    }
    /* -----------------------------------------------------------------------------------------------------
Method NAME: accountExactemptyListsearch
PURPOSE : The purpose of this method is to check empty account list .
-------------------------------------------------------------------------------------------------------*/
    @isTest
    static  void accountExactemptyListsearch(){
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        //req.requestURI = 'https://cs1.salesforce.com/services/apexrest/StandardAccountRestApi';
       req.requestURI = 'https://'+URL.getSalesforceBaseUrl().getHost()+'/services/apexrest/StandardAccountRestApi'; 
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf('{"ESIHeader": {"applicationId": "string","transactionId": "string","messageId": "Exact","messageHistory": "string","tracingId": "string","timeStamp": "2008-09-29T01:49:45","instanceId": "string","companyId": "string","configGroup": "string","payloadVersion": "string","postBackURL": "string","extensibleAttributes": [{"key": "string","value": "string"}]},"account": {"accountNumber": "","companyId": "string","companyName": "string","address": [{"city": "string","county": "string"}]}}');
        TestDataFactory();
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        StandardAccountRestApi.AccountResponseWrapper testList = StandardAccountRestApi.getAccount();
        System.debug('testList**' +testList);         
        System.assertEquals('400', testList.GetAccountDetailsResponse.statusDetails.statusCode);
        //System.assertEquals('400', testList.GetAccountDetailsResponse.statusDetails.statusCode);       
        Test.stopTest();
        
        
    }
    /* -----------------------------------------------------------------------------------------------------
Method NAME: accountExactException
PURPOSE : The purpose of this method is to check null exception .
-------------------------------------------------------------------------------------------------------*/    
    @isTest
    static  void accountExactException(){
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        //req.requestURI = 'https://cs1.salesforce.com/services/apexrest/StandardAccountRestApi';
        req.requestURI = 'https://'+URL.getSalesforceBaseUrl().getHost()+'/services/apexrest/StandardAccountRestApi'; 
        req.httpMethod = 'POST';
        //req.requestBody = Blob.valueOf('{"ESIHeader": {"applicationId": "string","transactionId": "string","messageId": "Exact","messageHistory": "string","tracingId": "string","timeStamp": "2008-09-29T01:49:45","instanceId": "string","companyId": "string","configGroup": "string","payloadVersion": "string","postBackURL": "string","extensibleAttributes": [{"key": "string","value": "string"}]},"account": {"accountNumber": "","companyId": "string","companyName": "string","address": [{"city": "string","county": "string"}]}}');
        req.requestBody = Blob.valueOf('{"ESIHeader": null ,"account": null}');
        //TestDataFactory();
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        TestDataFactory();
        StandardAccountRestApi.AccountResponseWrapper testList = StandardAccountRestApi.getAccount();
        System.debug('testList**' +testList);       
        //System.assertEquals('200', testList.GetAccountDetailsResponse.statusDetails.statusCode);
        Test.stopTest();
        
        
    }
    
    /* -----------------------------------------------------------------------------------------------------
Method NAME: accountQueryException
PURPOSE : The purpose of this method is to check query exception .
-------------------------------------------------------------------------------------------------------*/
    @isTest
    static  void accountQueryException(){
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        //req.requestURI = 'https://cs1.salesforce.com/services/apexrest/StandardAccountRestApi';
         req.requestURI = 'https://'+URL.getSalesforceBaseUrl().getHost()+'/services/apexrest/StandardAccountRestApi'; 
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf('{"ESIHeader": {"applicationId": "string","transactionId": "string","messageId": "Fuzzy","messageHistory": "string","tracingId": "string","timeStamp": "2008-09-29T01:49:45","instanceId": "string","companyId": "string","configGroup": "string","payloadVersion": "string","postBackURL": "string","extensibleAttributes": [{"key": "string","value": "string"}]},"account": {"accountNumber": "","companyId": "@@","companyName": "","address": [{"city": "","county": ""}]}}');
        //req.requestBody = Blob.valueOf('{"ESIHeader": null ,"account": null}');
        TestDataFactory();
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        StandardAccountRestApi.AccountResponseWrapper testList = StandardAccountRestApi.getAccount();
        System.debug('testList**' +testList);
        Test.stopTest();
        
        
    }
    
    
    
    /* -----------------------------------------------------------------------------------------------------
Method NAME: accountFuzzySearch
PURPOSE : The purpose of this method is to search account with account name or billingCity or billingCountry .
-------------------------------------------------------------------------------------------------------*/
    @isTest
    static  void accountFuzzySearch() {
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        // pass the req and resp objects to the method     
        //req.requestURI = 'https://cs1.salesforce.com/services/apexrest/StandardAccountRestApi';
        req.requestURI = 'https://'+URL.getSalesforceBaseUrl().getHost()+'/services/apexrest/StandardAccountRestApi'; 
        //req.addHeader('JSONSTRING','{"GetAccountRequest": {"esiHeader": {"applicationId": "TW","transactionId": "","messageId": "Fuzzy","messageHistory": "","tracingId": "","timeStamp": "","instanceId": "","companyId": "","configGroup": "","payloadVersion": "","postBackURL": ""},"AccountName": "Test","City": "SAN FRANCISCO","Country": "US"}}');
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf('{"ESIHeader": {"applicationId": "string","transactionId": "string","messageId": "Fuzzy","messageHistory": "string","tracingId": "string","timeStamp": "2008-09-29T01:49:45","instanceId": "string","companyId": "string","configGroup": "string","payloadVersion": "string","postBackURL": "string","extensibleAttributes": [{"key": "string","value": "string"}]},"account": {"accountNumber": "","companyId": "","companyName": "Test","address": [{"city": "San Francisco","county": "US"}]}}');
        TestDataFactory();
        RestContext.request = req;
        RestContext.response = res;
        test.startTest();
        StandardAccountRestApi.AccountResponseWrapper testList = StandardAccountRestApi.getAccount();
        System.debug('testList**' +testList);         
        System.assertEquals('200', testList.GetAccountDetailsResponse.statusDetails.statusCode);
        //System.assertEquals(200, res.statusCode);
        test.stopTest();
    }
    
    /* -----------------------------------------------------------------------------------------------------
Method NAME: accountFuzzyEmptyListSearch
PURPOSE : The purpose of this method is to check empty fuzzy list.
-------------------------------------------------------------------------------------------------------*/    
    @isTest
    static  void accountFuzzyEmptyListSearch(){
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();        
        //req.requestURI = 'https://cs1.salesforce.com/services/apexrest/StandardAccountRestApi';
         req.requestURI = 'https://'+URL.getSalesforceBaseUrl().getHost()+'/services/apexrest/StandardAccountRestApi'; 
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf('{"ESIHeader": {"applicationId": "","transactionId": "","messageId": "Fuzzy","messageHistory": "","tracingId": "","timeStamp": "","instanceId": "","companyId": "","configGroup": "","payloadVersion": "","postBackURL": "","extensibleAttributes": [{"key": "","value": ""}]},"account": {"accountNumber": "","companyId": "123456789012345678","companyName": "","address": [{"city": "San Franciscooo","county": "USS"}]}}');        
        RestContext.request = req;
        RestContext.response = res;
        Test.startTest();
        StandardAccountRestApi.AccountResponseWrapper testList = StandardAccountRestApi.getAccount();         
        System.assertEquals('400', testList.GetAccountDetailsResponse.statusDetails.statusCode);
        Test.stopTest();
        
    }
    
    /* -----------------------------------------------------------------------------------------------------
Method NAME: accountFuzzybillingcountrySearch
PURPOSE : The purpose of this method is to search account with the given billingCountry.
------------------------------------------------------------------------------------------------------- */   
    @isTest
    static  void accountFuzzybillingcountrySearch(){
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();        
        //req.requestURI = 'https://cs1.salesforce.com/services/apexrest/StandardAccountRestApi';
        req.requestURI = 'https://'+URL.getSalesforceBaseUrl().getHost()+'/services/apexrest/StandardAccountRestApi'; 
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf('{ "ESIHeader": { "applicationId": "", "transactionId": "", "messageId": "Fuzzy", "messageHistory": "", "tracingId": "", "timeStamp": "", "instanceId": "", "companyId": "", "configGroup": "", "payloadVersion": "", "postBackURL": "", "extensibleAttributes": [{ "key": "", "value": "" }] }, "account": { "accountNumber": "", "companyId": "", "companyName": "", "address": [{ "city" : "", "country" : "US" }] } }');        
        RestContext.request = req;
        RestContext.response = res;
        TestDataFactory();
        
        Test.startTest();        
        StandardAccountRestApi.AccountResponseWrapper testList = StandardAccountRestApi.getAccount();        
        System.assertEquals('400', testList.GetAccountDetailsResponse.statusDetails.statusCode);//changed the status on sanity check QA
        Test.stopTest();
    }
    
    /* -----------------------------------------------------------------------------------------------------
Method NAME: accountFuzzybillingcitySearch
PURPOSE : The purpose of this method is to search account with the given billingCity.
------------------------------------------------------------------------------------------------------- */  
    @isTest
    static  void accountFuzzybillingcitySearch(){
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();        
        //req.requestURI = 'https://cs1.salesforce.com/services/apexrest/StandardAccountRestApi';
        req.requestURI = 'https://'+URL.getSalesforceBaseUrl().getHost()+'/services/apexrest/StandardAccountRestApi'; 
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf('{ "ESIHeader": { "applicationId": "", "transactionId": "", "messageId": "Fuzzy", "messageHistory": "", "tracingId": "", "timeStamp": "", "instanceId": "", "companyId": "", "configGroup": "", "payloadVersion": "", "postBackURL": "", "extensibleAttributes": [{ "key": "", "value": "" }] }, "account": { "accountNumber": "", "companyId": "", "companyName": "Test", "address": [{ "city": "", "country": "US" }] } }');        
        RestContext.request = req;
        RestContext.response = res;
        TestDataFactory();
        
        Test.startTest();        
        StandardAccountRestApi.AccountResponseWrapper testList = StandardAccountRestApi.getAccount();         
        System.assertEquals('400', testList.GetAccountDetailsResponse.statusDetails.statusCode);
        Test.stopTest();
    }
    
    /* -----------------------------------------------------------------------------------------------------
Method NAME: accountFuzzycompanyNameSearch
PURPOSE : The purpose of this method is to search account with the given company name.
------------------------------------------------------------------------------------------------------- */ 
    @isTest
    static  void accountFuzzycompanyNameSearch(){
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();        
        //req.requestURI = 'https://cs1.salesforce.com/services/apexrest/StandardAccountRestApi';
        req.requestURI = 'https://'+URL.getSalesforceBaseUrl().getHost()+'/services/apexrest/StandardAccountRestApi'; 
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf('{ "ESIHeader": { "applicationId": "", "transactionId": "", "messageId": "Fuzzy", "messageHistory": "", "tracingId": "", "timeStamp": "", "instanceId": "", "companyId": "", "configGroup": "", "payloadVersion": "", "postBackURL": "", "extensibleAttributes": [{ "key": "", "value": "" }] }, "account": { "accountNumber": "", "companyId": "", "companyName": "Test", "address": [{ "city": "", "country": "" }] } }');        
        RestContext.request = req;
        RestContext.response = res;
        TestDataFactory();
        
        Test.startTest();        
        StandardAccountRestApi.AccountResponseWrapper testList = StandardAccountRestApi.getAccount();        
        System.assertEquals('200', testList.GetAccountDetailsResponse.statusDetails.statusCode);
        Test.stopTest();
    }
    
    /* -----------------------------------------------------------------------------------------------------
Method NAME: accountFuzzycityorcountrySearch
PURPOSE : The purpose of this method is to search account with the given city or country.
------------------------------------------------------------------------------------------------------- */ 
    @isTest
    static  void accountFuzzycityorcountrySearch(){
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();        
        //req.requestURI = 'https://cs1.salesforce.com/services/apexrest/StandardAccountRestApi';
        req.requestURI = 'https://'+URL.getSalesforceBaseUrl().getHost()+'/services/apexrest/StandardAccountRestApi'; 
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf('{ "ESIHeader": { "applicationId": "", "transactionId": "", "messageId": "Fuzzy", "messageHistory": "", "tracingId": "", "timeStamp": "", "instanceId": "", "companyId": "", "configGroup": "", "payloadVersion": "", "postBackURL": "", "extensibleAttributes": [{ "key": "", "value": "" }] }, "account": { "accountNumber": "", "companyId": "", "companyName": "", "address": [{ "city": "San francisco", "country": "US" }] } }');        
        RestContext.request = req;
        RestContext.response = res;
        TestDataFactory();
        
        Test.startTest();        
        StandardAccountRestApi.AccountResponseWrapper testList = StandardAccountRestApi.getAccount();        
        System.assertEquals('400', testList.GetAccountDetailsResponse.statusDetails.statusCode);//changed the status on sanity check QA
        Test.stopTest();
    }
    
    
    /* -----------------------------------------------------------------------------------------------------
Method NAME: accountFuzzycCompanyNameOrCountrySearch
PURPOSE : The purpose of this method is to search account with the given company name or country.
-------------------------------------------------------------------------------------------------------*/ 
    @isTest
    static  void accountFuzzycCompanyNameOrCountrySearch(){
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();        
        //req.requestURI = 'https://cs1.salesforce.com/services/apexrest/StandardAccountRestApi';
        req.requestURI = 'https://'+URL.getSalesforceBaseUrl().getHost()+'/services/apexrest/StandardAccountRestApi'; 
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf('{ "ESIHeader": { "applicationId": "", "transactionId": "", "messageId": "Fuzzy", "messageHistory": "", "tracingId": "", "timeStamp": "", "instanceId": "", "companyId": "", "configGroup": "", "payloadVersion": "", "postBackURL": "", "extensibleAttributes": [{ "key": "", "value": "" }] }, "account": { "accountNumber": "", "companyId": "", "companyName": "Test", "address": [{ "city": "", "country": "US" }] } }');        
        RestContext.request = req;
        RestContext.response = res;
        TestDataFactory();
        
        Test.startTest();        
        StandardAccountRestApi.AccountResponseWrapper testList = StandardAccountRestApi.getAccount();        
        System.assertEquals('400', testList.GetAccountDetailsResponse.statusDetails.statusCode);
        Test.stopTest();
    }
    
    /* -----------------------------------------------------------------------------------------------------
Method NAME: accountFuzzyAllSearch
PURPOSE : The purpose of this method is to search account with the all the inputs.
------------------------------------------------------------------------------------------------------- */ 
    @isTest
    static  void accountFuzzyAllSearch(){
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();        
        //req.requestURI = 'https://cs1.salesforce.com/services/apexrest/StandardAccountRestApi';
        req.requestURI = 'https://'+URL.getSalesforceBaseUrl().getHost()+'/services/apexrest/StandardAccountRestApi'; 
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf('{ "ESIHeader": { "applicationId": "", "transactionId": "", "messageId": "Fuzzy", "messageHistory": "", "tracingId": "", "timeStamp": "", "instanceId": "", "companyId": "", "configGroup": "", "payloadVersion": "", "postBackURL": "", "extensibleAttributes": [{ "key": "", "value": "" }] }, "account": { "accountNumber": "", "companyId": "", "companyName": "Test", "address": [{ "city": "San francisco", "country": "US" }] } }');        
        RestContext.request = req;
        RestContext.response = res;
        TestDataFactory();
        
        Test.startTest();        
        StandardAccountRestApi.AccountResponseWrapper testList = StandardAccountRestApi.getAccount();         
        System.assertEquals('400', testList.GetAccountDetailsResponse.statusDetails.statusCode);
        Test.stopTest();
    }
    
        /* -----------------------------------------------------------------------------------------------------
Method NAME: accountExactAccountIdSearch
PURPOSE : The purpose of this method is to search account with the input as  accountId as companyId .
-------------------------------------------------------------------------------------------------------*/   
    @isTest
    static  void accountExactAccountIdSearch(){

        Test.startTest();
        Id testId = TestDataFactoryID();
        System.debug('testId**'+testId);
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();        
        //req.requestURI = 'https://cs1.salesforce.com/services/apexrest/StandardAccountRestApi';
        req.requestURI = '/services/apexrest/StandardAccountRestApi';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf('{ "ESIHeader": { "applicationId": "", "transactionId": "", "messageId": "Exact", "messageHistory": "", "tracingId": "", "timeStamp": "", "instanceId": "", "companyId": "", "configGroup": "", "payloadVersion": "", "postBackURL": "", "extensibleAttributes": [{ "key": "", "value": "" }] }, "account": { "accountNumber": "", "companyId": "'+testId+'", "companyName": "", "address": [{ "city": "", "country": "" }] } }');        
        RestContext.request = req;
        RestContext.response = res;        
        StandardAccountRestApi.AccountResponseWrapper testList = StandardAccountRestApi.getAccount();        
        System.assertEquals('200', testList.GetAccountDetailsResponse.statusDetails.statusCode);
        Test.stopTest();
    }
    
    
    public static void TestDataFactory(){
        
        
        KeyValueListStore__c testCustomSetting = new KeyValueListStore__c();
        testCustomSetting.Name = 'Location_API_Source_System_Name';
        testCustomSetting.TextValue__c = 'ENTWRP';
        insert testCustomSetting;
        
        
        //List<Account> accountList = new List<Account>();
        Account acc = new Account();
        acc.NAME = 'Test';
        acc.Type = 'Source System';
        acc.BillingCity = 'San francisco';
        acc.BillingCountry = 'IN';
        acc.BillingPostalCode = '91324-45677';
        acc.BillingState = 'GJ';
        acc.is_gli__c = true;
        //acc.Operational_Ultimate_Parent_Name1__c = '';
        insert acc;
        //accountList.add(acc);
        //acc.BillingAddress = string.valueOf('');
        
        
        Source_System_Detail__c sourceSystem = new Source_System_Detail__c();
        sourceSystem.Source_System_Name__c = 'ENTWRP';
        sourceSystem.Account_Name__c = acc.Id;
        sourceSystem.Source_System_Account_Number__c = '01777';
        insert sourceSystem;
        
        
        
        
    }
    
        public static id TestDataFactoryID(){
        

        
        KeyValueListStore__c testCustomSetting = new KeyValueListStore__c();
        testCustomSetting.Name = 'Location_API_Source_System_Name';
        testCustomSetting.TextValue__c = 'ENTWRP';
        insert testCustomSetting;
        
        
        //List<Account> accountList = new List<Account>();
        Account acc = new Account();
        acc.NAME = 'Test';
        acc.Type = 'Source System';
        acc.BillingCity = 'San francisco';
        acc.BillingCountry = 'IN';
        acc.BillingPostalCode = '91324-45677';
        acc.BillingState = 'GJ';
        acc.is_gli__c = true;
        //acc.Operational_Ultimate_Parent_Name1__c = '';
        insert acc;
        //accountList.add(acc);
        //acc.BillingAddress = string.valueOf('');
        
        
        Source_System_Detail__c sourceSystem = new Source_System_Detail__c();
        sourceSystem.Source_System_Name__c = 'ENTWRP';
        sourceSystem.Account_Name__c = acc.Id;
        sourceSystem.Source_System_Account_Number__c = '01777';
        insert sourceSystem;
        
        return acc.Id;
        
        
    }
    
}