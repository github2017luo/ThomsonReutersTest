@isTest
public class TestLCRMStandardContactRestApi {
    

    
    /* -----------------------------------------------------------------------------------------------------
Method NAME: contactFuzzyaccountId
PURPOSE : The purpose of this method is to search contact on basis of account id .
-------------------------------------------------------------------------------------------------------*/    
    @isTest
    static void contactFuzzyaccountId() {
        test.startTest();
        Id accountIdtest = accountId();
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        req.requestURI = 'https://'+URL.getSalesforceBaseUrl().getHost()+'/services/apexrest/LCRMStandardContactRestApi';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf('{ "GetContactsRequest" : { "ESIHeader" : { "applicationId" : "CW", "transactionId" : "", "messageId" : "Fuzzy", "messageHistory" : "", "tracingId" : "", "timeStamp" : "2017-07-19T22:12:16.112", "instanceId" : "", "companyId" : "", "configGroup" : "", "payloadVersion" : "", "postBackURL" : "", "extensibleAttributes" : [ { "key" : "", "value" : "" } ] }, "contact" : { "address" : { "firstName" : "", "lastName" : "", "emailAddress" : "", "extensibleAttributes" : [ { "key" : "", "value" : "" } ] }, "account" : { "companyId" : "'+accountIdtest+'", "companyName" : "", "extensibleAttributes" : [ { "key" : "", "value" : "" } ] }, "extensibleAttributes" : [ { "key" : "", "value" : "" } ] } } }');
        // TestDataFactory();
        RestContext.request = req;
        RestContext.response = res;
        
        LCRMStandardContactRestApi.ContactResponseWrapper testList = LCRMStandardContactRestApi.getContact();         
        System.assertEquals('200', testList.GetContactsResponse.statusDetails.statusCode);
        test.stopTest();
    }
    
/* -----------------------------------------------------------------------------------------------------
Method NAME: contactFuzzyAccountName
PURPOSE : The purpose of this method is to search contact on basis of account id or account name or contact fname .
-------------------------------------------------------------------------------------------------------*/    
    @isTest
    static void contactFuzzyAccountName() {
       test.startTest();
        Id accountIdtest = accountId();
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = 'https://'+URL.getSalesforceBaseUrl().getHost()+'/services/apexrest/LCRMStandardContactRestApi';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf('{ "GetContactsRequest" : { "ESIHeader" : { "applicationId" : "CW", "transactionId" : "", "messageId" : "Fuzzy", "messageHistory" : "", "tracingId" : "", "timeStamp" : "2017-07-19T22:12:16.112", "instanceId" : "", "companyId" : "", "configGroup" : "", "payloadVersion" : "", "postBackURL" : "", "extensibleAttributes" : [ { "key" : "", "value" : "" } ] }, "contact" : { "address" : { "firstName" : "", "lastName" : "", "emailAddress" : "", "extensibleAttributes" : [ { "key" : "", "value" : "" } ] }, "account" : { "companyId" : "", "companyName" : "Test", "extensibleAttributes" : [ { "key" : "", "value" : "" } ] }, "extensibleAttributes" : [ { "key" : "", "value" : "" } ] } } }');
        RestContext.request = req;
        RestContext.response = res;
        
        LCRMStandardContactRestApi.ContactResponseWrapper testList = LCRMStandardContactRestApi.getContact();        
        System.assertEquals('200', testList.GetContactsResponse.statusDetails.statusCode);
        test.stopTest();
    } 
    

 
    /* -----------------------------------------------------------------------------------------------------
Method NAME: contactFuzzyaccountIdOrAccountName
PURPOSE : The purpose of this method is to search contact on basis of account id or account name .
-------------------------------------------------------------------------------------------------------*/    
    @isTest
    static void contactFuzzyaccountIdOrAccountName() {
       Id accountIdtest = accountId();
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = 'https://'+URL.getSalesforceBaseUrl().getHost()+'/services/apexrest/LCRMStandardContactRestApi';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf('{ "GetContactsRequest" : { "ESIHeader" : { "applicationId" : "CW", "transactionId" : "", "messageId" : "Fuzzy", "messageHistory" : "", "tracingId" : "", "timeStamp" : "2017-07-19T22:12:16.112", "instanceId" : "", "companyId" : "", "configGroup" : "", "payloadVersion" : "", "postBackURL" : "", "extensibleAttributes" : [ { "key" : "", "value" : "" } ] }, "contact" : { "address" : { "firstName" : "", "lastName" : "", "emailAddress" : "", "extensibleAttributes" : [ { "key" : "", "value" : "" } ] }, "account" : { "companyId" : "'+accountIdtest+'", "companyName" : "Test", "extensibleAttributes" : [ { "key" : "", "value" : "" } ] }, "extensibleAttributes" : [ { "key" : "", "value" : "" } ] } } }');
        RestContext.request = req;
        RestContext.response = res;
        test.startTest();
        LCRMStandardContactRestApi.ContactResponseWrapper testList = LCRMStandardContactRestApi.getContact();
        System.assertEquals('200', testList.GetContactsResponse.statusDetails.statusCode);
        test.stopTest();
    }
    
    /* -----------------------------------------------------------------------------------------------------
Method NAME: contactFuzzyaccountIdOrAccountNameOrconFname
PURPOSE : The purpose of this method is to search contact on basis of account id or account name or contact fname .
-------------------------------------------------------------------------------------------------------*/    
    @isTest
    static void contactFuzzyaccountIdOrAccountNameOrconFname() {
       Id accountIdtest = accountId();
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();    
        req.requestURI = 'https://'+URL.getSalesforceBaseUrl().getHost()+'/services/apexrest/LCRMStandardContactRestApi';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf('{ "GetContactsRequest" : { "ESIHeader" : { "applicationId" : "CW", "transactionId" : "", "messageId" : "Fuzzy", "messageHistory" : "", "tracingId" : "", "timeStamp" : "2017-07-19T22:12:16.112", "instanceId" : "", "companyId" : "", "configGroup" : "", "payloadVersion" : "", "postBackURL" : "", "extensibleAttributes" : [ { "key" : "", "value" : "" } ] }, "contact" : { "address" : { "firstName" : "Test", "lastName" : "", "emailAddress" : "", "extensibleAttributes" : [ { "key" : "", "value" : "" } ] }, "account" : { "companyId" : "'+accountIdtest+'", "companyName" : "Test", "extensibleAttributes" : [ { "key" : "", "value" : "" } ] }, "extensibleAttributes" : [ { "key" : "", "value" : "" } ] } } }');
        RestContext.request = req;
        RestContext.response = res;
        test.startTest();
        LCRMStandardContactRestApi.ContactResponseWrapper testList = LCRMStandardContactRestApi.getContact();
        System.assertEquals('200', testList.GetContactsResponse.statusDetails.statusCode);
        test.stopTest();
    }    

    /* -----------------------------------------------------------------------------------------------------
Method NAME: allSearch
PURPOSE : The purpose of this method is to search contact on basis of account id or account name or contact fname .
-------------------------------------------------------------------------------------------------------*/    
    @isTest
    static void allSearch() {
       Id accountIdtest = accountId();
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
       req.requestURI = 'https://'+URL.getSalesforceBaseUrl().getHost()+'/services/apexrest/LCRMStandardContactRestApi';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf('{ "GetContactsRequest" : { "ESIHeader" : { "applicationId" : "CW", "transactionId" : "", "messageId" : "Fuzzy", "messageHistory" : "", "tracingId" : "", "timeStamp" : "2017-07-19T22:12:16.112", "instanceId" : "", "companyId" : "", "configGroup" : "", "payloadVersion" : "", "postBackURL" : "", "extensibleAttributes" : [ { "key" : "", "value" : "" } ] }, "contact" : { "address" : { "firstName" : "Test", "lastName" : "Test", "emailAddress" : "Test@test.com", "extensibleAttributes" : [ { "key" : "", "value" : "" } ] }, "account" : { "companyId" : "'+accountIdtest+'", "companyName" : "Test", "extensibleAttributes" : [ { "key" : "", "value" : "" } ] }, "extensibleAttributes" : [ { "key" : "", "value" : "" } ] } } }');
        RestContext.request = req;
        RestContext.response = res;
        test.startTest();
        LCRMStandardContactRestApi.ContactResponseWrapper testList = LCRMStandardContactRestApi.getContact();
        System.assertEquals('400', testList.GetContactsResponse.statusDetails.statusCode);
        test.stopTest();
    }     
    

/* -----------------------------------------------------------------------------------------------------
Method NAME: contactFuzzyContactFnameSearch
PURPOSE : The purpose of this method is to search contact on basis of given contact first name .
-------------------------------------------------------------------------------------------------------*/  
    @isTest
    static void contactFuzzyContactFnameSearch() {
      
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        req.requestURI = 'https://'+URL.getSalesforceBaseUrl().getHost()+'/services/apexrest/LCRMStandardContactRestApi';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf('{ "GetContactsRequest" : { "ESIHeader" : { "applicationId" : "CW", "transactionId" : "", "messageId" : "Fuzzy", "messageHistory" : "", "tracingId" : "", "timeStamp" : "2017-07-19T22:12:16.112", "instanceId" : "", "companyId" : "", "configGroup" : "", "payloadVersion" : "", "postBackURL" : "", "extensibleAttributes" : [ { "key" : "", "value" : "" } ] }, "contact" : { "address" : { "firstName" : "Test", "lastName" : "", "emailAddress" : "", "extensibleAttributes" : [ { "key" : "", "value" : "" } ] }, "account" : { "companyId" : "", "companyName" : "", "extensibleAttributes" : [ { "key" : "", "value" : "" } ] }, "extensibleAttributes" : [ { "key" : "", "value" : "" } ] } } }');
        contactData();
        RestContext.request = req;
        RestContext.response = res;
        test.startTest();
        LCRMStandardContactRestApi.ContactResponseWrapper testList = LCRMStandardContactRestApi.getContact();
        System.assertEquals('200', testList.GetContactsResponse.statusDetails.statusCode);
        test.stopTest();
    }    
    
    /* -----------------------------------------------------------------------------------------------------
Method NAME: contactFuzzyContactLnameSearch
PURPOSE : The purpose of this method is to search contact on basis of given contact Last name .
-------------------------------------------------------------------------------------------------------*/  
    @isTest
    static void contactFuzzyContactLnameSearch() {
      
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        req.requestURI = 'https://'+URL.getSalesforceBaseUrl().getHost()+'/services/apexrest/LCRMStandardContactRestApi';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf('{ "GetContactsRequest" : { "ESIHeader" : { "applicationId" : "CW", "transactionId" : "", "messageId" : "Fuzzy", "messageHistory" : "", "tracingId" : "", "timeStamp" : "2017-07-19T22:12:16.112", "instanceId" : "", "companyId" : "", "configGroup" : "", "payloadVersion" : "", "postBackURL" : "", "extensibleAttributes" : [ { "key" : "", "value" : "" } ] }, "contact" : { "address" : { "firstName" : "", "lastName" : "Test", "emailAddress" : "", "extensibleAttributes" : [ { "key" : "", "value" : "" } ] }, "account" : { "companyId" : "", "companyName" : "", "extensibleAttributes" : [ { "key" : "", "value" : "" } ] }, "extensibleAttributes" : [ { "key" : "", "value" : "" } ] } } }');
        contactData();
        RestContext.request = req;
        RestContext.response = res;
        test.startTest();
        LCRMStandardContactRestApi.ContactResponseWrapper testList = LCRMStandardContactRestApi.getContact();
        System.assertEquals('200', testList.GetContactsResponse.statusDetails.statusCode);
        test.stopTest();
    }  
    /* -----------------------------------------------------------------------------------------------------
Method NAME: contactFuzzyContactEmailSearch
PURPOSE : The purpose of this method is to search contact on basis of given contact email .
-------------------------------------------------------------------------------------------------------*/  
    @isTest
    static void contactFuzzyContactEmailSearch() {
      
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        req.requestURI = 'https://'+URL.getSalesforceBaseUrl().getHost()+'/services/apexrest/LCRMStandardContactRestApi';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf('{ "GetContactsRequest" : { "ESIHeader" : { "applicationId" : "CW", "transactionId" : "", "messageId" : "Fuzzy", "messageHistory" : "", "tracingId" : "", "timeStamp" : "2017-07-19T22:12:16.112", "instanceId" : "", "companyId" : "", "configGroup" : "", "payloadVersion" : "", "postBackURL" : "", "extensibleAttributes" : [ { "key" : "", "value" : "" } ] }, "contact" : { "address" : { "firstName" : "", "lastName" : "", "emailAddress" : "Test@test.com", "extensibleAttributes" : [ { "key" : "", "value" : "" } ] }, "account" : { "companyId" : "", "companyName" : "", "extensibleAttributes" : [ { "key" : "", "value" : "" } ] }, "extensibleAttributes" : [ { "key" : "", "value" : "" } ] } } }');
        contactData();
        RestContext.request = req;
        RestContext.response = res;
        test.startTest();
        LCRMStandardContactRestApi.ContactResponseWrapper testList = LCRMStandardContactRestApi.getContact();
        System.assertEquals('200', testList.GetContactsResponse.statusDetails.statusCode);
        test.stopTest();
    }  
    
    /* -----------------------------------------------------------------------------------------------------
Method NAME: contactFuzzyContactEmptySearch
PURPOSE : The purpose of this method for empty list search .
-------------------------------------------------------------------------------------------------------*/  
    @isTest
    static void contactFuzzyContactEmptySearch() {
      
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        req.requestURI = 'https://'+URL.getSalesforceBaseUrl().getHost()+'/services/apexrest/LCRMStandardContactRestApi';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf('{ "GetContactsRequest" : { "ESIHeader" : { "applicationId" : "CW", "transactionId" : "", "messageId" : "Fuzzy", "messageHistory" : "", "tracingId" : "", "timeStamp" : "2017-07-19T22:12:16.112", "instanceId" : "", "companyId" : "", "configGroup" : "", "payloadVersion" : "", "postBackURL" : "", "extensibleAttributes" : [ { "key" : "", "value" : "" } ] }, "contact" : { "address" : { "firstName" : "Test123456214", "lastName" : "", "emailAddress" : "", "extensibleAttributes" : [ { "key" : "", "value" : "" } ] }, "account" : { "companyId" : "", "companyName" : "", "extensibleAttributes" : [ { "key" : "", "value" : "" } ] }, "extensibleAttributes" : [ { "key" : "", "value" : "" } ] } } }');
        contactData();
        RestContext.request = req;
        RestContext.response = res;
        test.startTest();
        LCRMStandardContactRestApi.ContactResponseWrapper testList = LCRMStandardContactRestApi.getContact();
        System.assertEquals('400', testList.GetContactsResponse.statusDetails.statusCode);
        test.stopTest();
    }  


    /* -----------------------------------------------------------------------------------------------------
Method NAME: contactFuzzyContactExceptionSearch
PURPOSE : The purpose of this method for exception .
-------------------------------------------------------------------------------------------------------*/  
    @isTest
    static void contactFuzzyContactExceptionSearch() {
      
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
       req.requestURI = 'https://'+URL.getSalesforceBaseUrl().getHost()+'/services/apexrest/LCRMStandardContactRestApi';
        req.httpMethod = 'POST';
        //req.requestBody = Blob.valueOf('{ "GetContactsRequest" : { "ESIHeader" : { "applicationId" : "CW", "transactionId" : "", "messageId" : "Fuzzy", "messageHistory" : "", "tracingId" : "", "timeStamp" : "2017-07-19T22:12:16.112", "instanceId" : "", "companyId" : "", "configGroup" : "", "payloadVersion" : "", "postBackURL" : "", "extensibleAttributes" : [ { "key" : "", "value" : "" } ] }, "contact" : { "address" : { "firstName" : "Test123456214", "lastName" : "", "emailAddress" : "", "extensibleAttributes" : [ { "key" : "", "value" : "" } ] }, "account" : { "companyId" : "", "companyName" : "", "extensibleAttributes" : [ { "key" : "", "value" : "" } ] }, "extensibleAttributes" : [ { "key" : "", "value" : "" } ] } } }');
        req.requestBody = Blob.valueOf('{ "GetContactsRequest" : { "ESIHeader" : { "applicationId" : "CW", "transactionId" : "", "messageId" : "Fuzzy", "messageHistory" : "", "tracingId" : "", "timeStamp" : "2017-07-19T22:12:16.112", "instanceId" : "", "companyId" : "", "configGroup" : "", "payloadVersion" : "", "postBackURL" : "", "extensibleAttributes" : [ { "key" : "", "value" : "" } ] }, "contact" : { "address" : { "firstName1" : "Test123456214", "lastName1" : "", "emailAddress1" : "", "extensibleAttributes" : [ { "key" : "", "value" : "" } ] }, "account" : { "companyId1" : "", "companyName1" : "", "extensibleAttributes" : [ { "key" : "", "value" : "" } ] }, "extensibleAttributes" : [ { "key" : "", "value" : "" } ] } } }');
        contactData();
        RestContext.request = req;
        RestContext.response = res;
        test.startTest();
        LCRMStandardContactRestApi.ContactResponseWrapper testList = LCRMStandardContactRestApi.getContact();
        System.assertEquals('400', testList.GetContactsResponse.statusDetails.statusCode);
        test.stopTest();
    }  
    
    
        /* -----------------------------------------------------------------------------------------------------
Method NAME: contactFuzzyJSONExceptionSearch
PURPOSE : The purpose of this method for JSON exception .
-------------------------------------------------------------------------------------------------------*/  
    @isTest
    static void contactFuzzyJSONExceptionSearch() {
      
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        req.requestURI = 'https://'+URL.getSalesforceBaseUrl().getHost()+'/services/apexrest/LCRMStandardContactRestApi';
        req.httpMethod = 'POST';
        //req.requestBody = Blob.valueOf('{ "GetContactsRequest" : { "ESIHeader" : { "applicationId" : "CW", "transactionId" : "", "messageId" : "Fuzzy", "messageHistory" : "", "tracingId" : "", "timeStamp" : "2017-07-19T22:12:16.112", "instanceId" : "", "companyId" : "", "configGroup" : "", "payloadVersion" : "", "postBackURL" : "", "extensibleAttributes" : [ { "key" : "", "value" : "" } ] }, "contact" : { "address" : { "firstName" : "Test123456214", "lastName" : "", "emailAddress" : "", "extensibleAttributes" : [ { "key" : "", "value" : "" } ] }, "account" : { "companyId" : "", "companyName" : "", "extensibleAttributes" : [ { "key" : "", "value" : "" } ] }, "extensibleAttributes" : [ { "key" : "", "value" : "" } ] } } }');
        req.requestBody = Blob.valueOf('{{ "GetContactsRequest" : { "ESIHeader" : { "applicationId" : "CW", "transactionId" : "", "messageId" : "Fuzzy", "messageHistory" : "", "tracingId" : "", "timeStamp" : "2017-07-19T22:12:16.112", "instanceId" : "", "companyId" : "", "configGroup" : "", "payloadVersion" : "", "postBackURL" : "", "extensibleAttributes" : [ { "key" : "", "value" : "" } ] }, "contact" : { "address" : { "firstName1" : "Test123456214", "lastName1" : "", "emailAddress1" : "", "extensibleAttributes" : [ { "key" : "", "value" : "" } ] }, "account" : { "companyId1" : "", "companyName1" : "", "extensibleAttributes" : [ { "key" : "", "value" : "" } ] }, "extensibleAttributes" : [ { "key" : "", "value" : "" } ] } } }');
        contactData();
        RestContext.request = req;
        RestContext.response = res;
        test.startTest();
        LCRMStandardContactRestApi.ContactResponseWrapper testList = LCRMStandardContactRestApi.getContact();
        test.stopTest();
    }
    
  /* -----------------------------------------------------------------------------------------------------
Method NAME: contactFuzzyContactEmailSearchException
PURPOSE : The purpose of this method is to search contact on basis of given contact email .
-------------------------------------------------------------------------------------------------------*/  
    @isTest
    static void contactFuzzyContactEmailSearchException() {
      
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        req.requestURI = 'https://'+URL.getSalesforceBaseUrl().getHost()+'/services/apexrest/LCRMStandardContactRestApi';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf('{ "GetContactsRequest" : { "ESIHeader" : { "applicationId" : "CW", "transactionId" : "", "messageId" : "Fuzzy", "messageHistory" : "", "tracingId" : "", "timeStamp" : "2017-07-19T22:12:16.112", "instanceId" : "", "companyId" : "", "configGroup" : "", "payloadVersion" : "", "postBackURL" : "", "extensibleAttributes" : [ { "key" : "", "value" : "" } ] }, "contact" : { "address" : { "firstName" : "", "lastName" : "", "emailAddress" : "123", "extensibleAttributes" : [ { "key" : "", "value" : "" } ] }, "account" : { "companyId" : "", "companyName" : "", "extensibleAttributes" : [ { "key" : "", "value" : "" } ] }, "extensibleAttributes" : [ { "key" : "", "value" : "" } ] } } }');
        contactData();
        RestContext.request = req;
        RestContext.response = res;
        test.startTest();
        LCRMStandardContactRestApi.ContactResponseWrapper testList = LCRMStandardContactRestApi.getContact();
        System.assertEquals('400', testList.GetContactsResponse.statusDetails.statusCode);
        test.stopTest();
    }
    
/* -----------------------------------------------------------------------------------------------------
Method NAME: fuzzyException
PURPOSE : The purpose of this method to check exception.
-------------------------------------------------------------------------------------------------------*/    
    @isTest
    static void fuzzyException() {
       Id accountIdtest = accountId();
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = 'https://'+URL.getSalesforceBaseUrl().getHost()+'/services/apexrest/LCRMStandardContactRestApi';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf('{ "GetContactsRequest" : { "ESIHeader" : { "applicationId" : "CW", "transactionId" : "", "messageId" : "Fuzzy", "messageHistory" : "", "tracingId" : "", "timeStamp" : "2017-07-19T22:12:16.112", "instanceId" : "", "companyId" : "", "configGroup" : "", "payloadVersion" : "", "postBackURL" : "", "extensibleAttributes" : [ { "key" : "", "value" : "" } ] }, "contact" : { "address" : { "firstName" : "", "lastName" : "", "emailAddress" : "", "extensibleAttributes" : [ { "key" : "", "value" : "" } ] }, "account" : { "companyId" : "", "companyName" : "<html>Test</html>", "extensibleAttributes" : [ { "key" : "", "value" : "" } ] }, "extensibleAttributes" : [ { "key" : "", "value" : "" } ] } } }');
        RestContext.request = req;
        RestContext.response = res;
        test.startTest();
        LCRMStandardContactRestApi.ContactResponseWrapper testList = LCRMStandardContactRestApi.getContact();
        //System.assertEquals('200', testList.GetContactsResponse.statusDetails.statusCode);
        test.stopTest();
    } 
    
      public static void contactData(){
            Account acc1  = new Account();
            acc1.NAME = 'Test';
            acc1.Type = 'Source System';
            acc1.BillingCity = 'San francisco';
            acc1.BillingCountry = 'US';
            acc1.BillingPostalCode = '91324-45677';
            acc1.BillingState = 'IL';
            acc1.is_gli__c = true;
            Id parentId = accountId();
            acc1.Operational_Ultimate_Parent_Name1__c = parentId;
            insert acc1;
            
            Contact cont1 = new Contact();
            cont1.FirstName='Test';
            cont1.LastName='Test';
            cont1.Email ='Test@test.com';
            cont1.Accountid= acc1.id;
            insert cont1;
            
            
        }
        
        public static id ultimateParentAccountId(){
            Account acc1  = new Account();
            acc1.NAME = 'Test';
            acc1.Type = 'Source System';
            acc1.BillingCity = 'San francisco';
            acc1.BillingCountry = 'US';
            acc1.BillingPostalCode = '91324-45677';
            acc1.BillingState = 'IL';
            acc1.is_gli__c = true;
            Id parentId = accountId();
            acc1.Operational_Ultimate_Parent_Name1__c = parentId;
            acc1.Global_Ultimate_Parent_Flag__c = true;
            insert acc1;
            
            Contact cont1 = new Contact();
            cont1.FirstName='Test';
            cont1.LastName='Test';
            cont1.Email ='Test@test.com';
            cont1.Accountid= acc1.id;
            insert cont1;
            
            return acc1.Id;
        }
        
        Public static Id accountId(){
            System.debug('');
            Account acc = new Account();
            
            acc.NAME = 'Test';
            acc.Type = 'Source System';
            acc.BillingCity = 'San francisco';
            acc.BillingCountry = 'US';
            acc.BillingPostalCode = '91324-45677';
            acc.BillingState = 'IL';
            acc.is_gli__c = true;
            //acc.Operational_Ultimate_Parent_Name1__c = '';
            insert acc;
            
            
            
            Contact cont = new Contact();
            cont.FirstName='Test';
            cont.LastName='Test';
            cont.Accountid= acc.id;
            insert cont;
            
            
            
            return acc.id;
        }
        
}