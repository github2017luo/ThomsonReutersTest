@istest
public class TestLCRMPostbackServiceAPI {
    
    //Status Update method
    @isTest static void lcrmStatusUpdate() {
        test.startTest();
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = 'https://'+URL.getSalesforceBaseUrl().getHost()+'/services/apexrest/LCRMPostbackServiceAPI';
        req.httpMethod = 'POST';
        
        createPostbackData();
        Opportunity opp = [Select Id from opportunity WHERE name = 'Unit Test Opportuntiy postback' LIMIT 1];
        
        req.requestBody = Blob.valueOf('{ "updateOpportunityRequest": { "esiHeader": { "applicationId": "CW", "transactionId": "", "messageId": "LCRM_Status", "messageHistory": "", "tracingId": "", "timeStamp": "", "instanceId": "", "companyId": "", "configGroup": "", "payloadVersion": "", "postBackURL": "", "extensibleAttributes": [{ "systemIdentifier": "", "key": "", "value": "" }] }, "opportunity": { "actionCode": "Update", "opportunityHeader": { "opptyId": "'+opp.id+'", "salesStage": "", "opptyStatus": "Extended Access", "contractType": "", "quoteId": "" }, "opportunityRenewal": { "expectedEndDate": "", "negotiationExtnDate": "", "extensionAccessDate": "" }, "opportunityLineItem": [{ "opptyProductId": "", "opptyLineItemId": "", "newActualContractValue": "","currentActualContractValue": "" , "opptyProductAction": "" }] } } }');
        RestContext.request = req;
        RestContext.response = res;
        
        
        LCRMPostbackServiceAPI.ResponseWrapper testList = LCRMPostbackServiceAPI.updateLCRMOpportunity();
        system.debug('testList** '+testList);
        System.assertEquals('200', testList.updateOpportunityResponse.StatusDetails.statusCode);
        test.stopTest();
        
    }
    //Stage Update method
    @isTest static void lcrmStageUpdate() {
        test.startTest();
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = 'https://'+URL.getSalesforceBaseUrl().getHost()+'/services/apexrest/LCRMPostbackServiceAPI';
        req.httpMethod = 'POST';
        
        //custom settings value
        KeyValueListStore__c testCustomSetting = new KeyValueListStore__c();
        testCustomSetting.Name = 'LCRMOpptyStageValues';
        testCustomSetting.TextValue__c = 'Contract Signed,Order Complete,Closed Lost';
        insert testCustomSetting;
        
        createPostbackData();
        Opportunity opp = [Select Id from opportunity WHERE name = 'Unit Test Opportuntiy postback' LIMIT 1];
        
        req.requestBody = Blob.valueOf('{ "updateOpportunityRequest": { "esiHeader": { "applicationId": "CW", "transactionId": "", "messageId": "LCRM_Stage", "messageHistory": "", "tracingId": "", "timeStamp": "", "instanceId": "", "companyId": "", "configGroup": "", "payloadVersion": "", "postBackURL": "", "extensibleAttributes": [{ "systemIdentifier": "", "key": "", "value": "" }] }, "opportunity": { "actionCode": "Update", "opportunityHeader": { "opptyId": "'+opp.id+'", "salesStage": "Needs Analysis", "opptyStatus": "Extended Access", "contractType": "", "quoteId": "" }, "opportunityRenewal": { "expectedEndDate": "", "negotiationExtnDate": "", "extensionAccessDate": "" }, "opportunityLineItem": [{ "opptyProductId": "", "opptyLineItemId": "", "newActualContractValue": "","currentActualContractValue": "", "opptyProductAction": "" }] } } }');
        RestContext.request = req;
        RestContext.response = res;
        
        
        LCRMPostbackServiceAPI.ResponseWrapper testList = LCRMPostbackServiceAPI.updateLCRMOpportunity();
        system.debug('testList** '+testList);
        System.assertEquals('200', testList.updateOpportunityResponse.StatusDetails.statusCode);
        test.stopTest();
        
    }
    //Renewal date update method
   /* @isTest static void lcrmrenewalDate() {
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = 'https://'+URL.getSalesforceBaseUrl().getHost()+'/services/apexrest/LCRMPostbackServiceAPI';
        req.httpMethod = 'POST';
        
        createPostbackData();
        Opportunity opp = [Select Id from opportunity WHERE name = 'Unit Test Opportuntiy postback' LIMIT 1];
        
        req.requestBody = Blob.valueOf('{ "updateOpportunityRequest": { "esiHeader": { "applicationId": "CW", "transactionId": "string", "messageId": "LCRM_renewalDate", "messageHistory": "string", "tracingId": "string", "timeStamp": "2008-09-29T01:49:45", "instanceId": "string", "companyId": "string", "configGroup": "string", "payloadVersion": "string", "postBackURL": "string", "extensibleAttributes": [{ "systemIdentifier": "string", "key": "string", "value": "string" }] }, "opportunity": { "actionCode": "Update", "opportunityHeader": { "opptyId": "'+opp.id+'", "salesStage": "string", "opptyStatus": "Extended Access", "contractType": "string", "quoteId": "string" }, "opportunityRenewal": { "expectedEndDate": "2017-09-25", "negotiationExtnDate": "", "extensionAccessDate": "" }, "opportunityLineItem": [{ "opptyProductId": "", "opptyLineItemId": "", "newActualContractValue": "", "opptyProductAction": "" }] } } }');
        RestContext.request = req;
        RestContext.response = res;
        
        test.startTest();
        LCRMPostbackServiceAPI.ResponseWrapper testList = LCRMPostbackServiceAPI.updateLCRMOpportunity();
        system.debug('testList** '+testList);
        System.assertEquals('200', testList.updateOpportunityResponse.StatusDetails.statusCode);
        test.stopTest();
        
    }*/
    //Negotiation Extention date update
    @isTest static void lcrmnegotiationExtnDate() {
        test.startTest();
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = 'https://'+URL.getSalesforceBaseUrl().getHost()+'/services/apexrest/LCRMPostbackServiceAPI';
        req.httpMethod = 'POST';
        
        createPostbackData();
        Opportunity opp = [Select Id from opportunity WHERE name = 'Unit Test Opportuntiy postback' LIMIT 1];
        
        req.requestBody = Blob.valueOf('{ "updateOpportunityRequest": { "esiHeader": { "applicationId": "CW", "transactionId": "string", "messageId": "LCRM_negotiationExtnDate", "messageHistory": "string", "tracingId": "string", "timeStamp": "2008-09-29T01:49:45", "instanceId": "string", "companyId": "string", "configGroup": "string", "payloadVersion": "string", "postBackURL": "string", "extensibleAttributes": [{ "systemIdentifier": "string", "key": "string", "value": "string" }] }, "opportunity": { "actionCode": "Update", "opportunityHeader": { "opptyId": "'+opp.id+'", "salesStage": "string", "opptyStatus": "Extended Access", "contractType": "string", "quoteId": "string" }, "opportunityRenewal": { "expectedEndDate": "2017-09-25", "negotiationExtnDate": "2017-09-25", "extensionAccessDate": "" }, "opportunityLineItem": [{ "opptyProductId": "", "opptyLineItemId": "", "newActualContractValue": "","currentActualContractValue": "", "opptyProductAction": "" }] } } }');
        RestContext.request = req;
        RestContext.response = res;
        
        
        LCRMPostbackServiceAPI.ResponseWrapper testList = LCRMPostbackServiceAPI.updateLCRMOpportunity();
        system.debug('testList** '+testList);
        System.assertEquals('200', testList.updateOpportunityResponse.StatusDetails.statusCode);
        test.stopTest();
        
    }
  
   @isTest static void lcrmAccessDate() {
        test.startTest();
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = 'https://'+URL.getSalesforceBaseUrl().getHost()+'/services/apexrest/LCRMPostbackServiceAPI';
        req.httpMethod = 'POST';
        
        createPostbackData();
        Opportunity opp = [Select Id from opportunity WHERE name = 'Unit Test Opportuntiy postback' LIMIT 1];
        
        req.requestBody = Blob.valueOf('{ "updateOpportunityRequest": { "esiHeader": { "applicationId": "CW", "transactionId": "", "messageId": "LCRM_extensionAccessDate", "messageHistory": "", "tracingId": "", "timeStamp": "", "instanceId": "", "companyId": "", "configGroup": "", "payloadVersion": "", "postBackURL": "", "extensibleAttributes": [{ "systemIdentifier": "", "key": "", "value": "" }] }, "opportunity": { "actionCode": "Update", "opportunityHeader": { "opptyId": "'+opp.id+'", "salesStage": "", "opptyStatus": "", "contractType": "", "quoteId": "CW" }, "opportunityRenewal": { "expectedStartDate": "2017-09-30", "expectedEndDate": "2017-09-28", "negotiationExtnDate": "", "extensionAccessDate": "2017-09-30" }, "opportunityLineItem": [{ "opptyProductId": "", "opptyLineItemId": "", "newAnnualContractValue": "","currentActualContractValue": "", "opptyProductAction": "", "cancelReason": "" }] } } }');
        RestContext.request = req;
        RestContext.response = res;
        
        
        LCRMPostbackServiceAPI.ResponseWrapper testList = LCRMPostbackServiceAPI.updateLCRMOpportunity();
        system.debug('testList** '+testList);
        System.assertEquals('200', testList.updateOpportunityResponse.StatusDetails.statusCode);
        test.stopTest();
        
    }
    //insert product method
    @isTest static void lcrminsertCWProduct() {
        
        test.startTest();
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = 'https://'+URL.getSalesforceBaseUrl().getHost()+'/services/apexrest/LCRMPostbackServiceAPI';
        req.httpMethod = 'POST';
              
        createPostbackData();
        Opportunity opp = [Select Id from opportunity WHERE name = 'Unit Test Opportuntiy postback' LIMIT 1];
        Product2 prod = [Select productcode from product2 where productcode = '123' limit 1];
        OpportunityLineItem oppLineItem=[Select Id from OpportunityLineItem WHERE opportunityId =: opp.Id];
        
     req.requestBody = Blob.valueOf('{ "updateOpportunityRequest": { "esiHeader": { "applicationId": "CW", "transactionId": "string", "messageId": "LCRM_productUpdate", "messageHistory": "string", "tracingId": "string", "timeStamp": "2008-09-29T01:49:45", "instanceId": "string", "companyId": "string", "configGroup": "string", "payloadVersion": "string", "postBackURL": "string", "extensibleAttributes": [{ "systemIdentifier": "string", "key": "string", "value": "string" }] }, "opportunity": { "actionCode": "Update", "opportunityHeader": { "opptyId": "'+opp.id+'", "salesStage": "string", "opptyStatus": "Extended Access", "contractType": "string", "quoteId": "string" }, "opportunityRenewal": { "expectedEndDate": "2017-09-25", "negotiationExtnDate": "2017-09-25", "extensionAccessDate": "" }, "opportunityLineItem": [{ "opptyProductId": "'+prod.productcode+'", "opptyLineItemId": "", "newActualContractValue": "20","currentActualContractValue": "10", "opptyProductAction": "Add" ,"productComments" : ""}] } } }');
     
        RestContext.request = req;
        RestContext.response = res;
        
        
        LCRMPostbackServiceAPI.ResponseWrapper testList = LCRMPostbackServiceAPI.updateLCRMOpportunity();
        system.debug('testList** '+testList);
       
        test.stopTest();
        
    }
    //update product method
    @isTest static void lcrmupdateCWProduct() {
        test.startTest();
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = 'https://'+URL.getSalesforceBaseUrl().getHost()+'/services/apexrest/LCRMPostbackServiceAPI';
        req.httpMethod = 'POST';
              
        createPostbackData();
        Opportunity opp = [Select Id from opportunity WHERE name = 'Unit Test Opportuntiy postback' LIMIT 1];
        OpportunityLineItem oppLineItem=[Select Id from OpportunityLineItem WHERE opportunityId =: opp.Id];
        //req.requestBody = Blob.valueOf('{ "updateOpportunityRequest": { "esiHeader": { "applicationId": "CW", "transactionId": "string", "messageId": "LCRM_productUpdate", "messageHistory": "string", "tracingId": "string", "timeStamp": "2008-09-29T01:49:45", "instanceId": "string", "companyId": "string", "configGroup": "string", "payloadVersion": "string", "postBackURL": "string", "extensibleAttributes": [{ "systemIdentifier": "string", "key": "string", "value": "string" }] }, "opportunity": { "actionCode": "Update", "opportunityHeader": { "opptyId": "'+opp.id+'", "salesStage": "string", "opptyStatus": "Extended Access", "contractType": "string", "quoteId": "string" }, "opportunityRenewal": { "expectedEndDate": "2017-09-25", "negotiationExtnDate": "2017-09-25", "extensionAccessDate": "" }, "opportunityLineItem": [{ "opptyProductId": "", "opptyLineItemId": "'+oppLineItem.id+'", "newActualContractValue": "20", "opptyProductAction": "Add" ,"productComments" : ""}] } } }');
        req.requestBody = Blob.valueOf('{ "updateOpportunityRequest": { "esiHeader": { "applicationId": "CW", "transactionId": "string", "messageId": "LCRM_productUpdate", "messageHistory": "string", "tracingId": "string", "timeStamp": "2008-09-29T01:49:45", "instanceId": "string", "companyId": "string", "configGroup": "string", "payloadVersion": "string", "postBackURL": "string", "extensibleAttributes": [{ "systemIdentifier": "string", "key": "string", "value": "string" }] }, "opportunity": { "actionCode": "Update", "opportunityHeader": { "opptyId": "'+opp.id+'", "salesStage": "string", "opptyStatus": "Extended Access", "contractType": "string", "quoteId": "string" }, "opportunityRenewal": { "expectedStartDate":"2017-09-25","expectedEndDate": "2017-09-30", "negotiationExtnDate": "2017-09-25", "extensionAccessDate": "" }, "opportunityLineItem": [{ "opptyProductId": "", "opptyLineItemId": "'+oppLineItem.id+'", "newActualContractValue": "20","currentActualContractValue": "10", "opptyProductAction": "Add" ,"productComments" : ""}] } } }');
        RestContext.request = req;
        RestContext.response = res;
        
        
        LCRMPostbackServiceAPI.ResponseWrapper testList = LCRMPostbackServiceAPI.updateLCRMOpportunity();
        system.debug('testList** '+testList);
        System.assertEquals('200', testList.updateOpportunityResponse.StatusDetails.statusCode);
        test.stopTest();
        
    }
    
     @isTest static void lcrmupdateTWProduct() {
        
        test.startTest();
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = 'https://'+URL.getSalesforceBaseUrl().getHost()+'/services/apexrest/LCRMPostbackServiceAPI';
        req.httpMethod = 'POST';
              
        createPostbackData();
        Opportunity opp = [Select Id from opportunity WHERE name = 'Unit Test Opportuntiy postback' LIMIT 1];
        OpportunityLineItem oppLineItem=[Select Id from OpportunityLineItem WHERE opportunityId =: opp.Id];
        req.requestBody = Blob.valueOf('{ "updateOpportunityRequest": { "esiHeader": { "applicationId": "TW", "transactionId": "string", "messageId": "LCRM_productUpdate", "messageHistory": "string", "tracingId": "string", "timeStamp": "2008-09-29T01:49:45", "instanceId": "string", "companyId": "string", "configGroup": "string", "payloadVersion": "string", "postBackURL": "string", "extensibleAttributes": [{ "systemIdentifier": "string", "key": "string", "value": "string" }] }, "opportunity": { "actionCode": "Update", "opportunityHeader": { "opptyId": "'+opp.id+'", "salesStage": "string", "opptyStatus": "Extended Access", "contractType": "string", "quoteId": "string" }, "opportunityRenewal": { "expectedEndDate": "2017-09-25", "negotiationExtnDate": "2017-09-25", "extensionAccessDate": "" }, "opportunityLineItem": [{ "opptyProductId": "", "opptyLineItemId": "'+oppLineItem.id+'", "newActualContractValue": "20","currentActualContractValue": "10","opptyProductAction": "Add" ,"productComments" : ""}] } } }');
        RestContext.request = req;
        RestContext.response = res;
        
        
        LCRMPostbackServiceAPI.ResponseWrapper testList = LCRMPostbackServiceAPI.updateLCRMOpportunity();
        system.debug('testList** '+testList);
        System.assertEquals('200', testList.updateOpportunityResponse.StatusDetails.statusCode);
        test.stopTest();
        
    }
    //Exception Negative scenarios
    @isTest static void lcrmStatusUpdateException() {
        
        test.startTest();
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = 'https://'+URL.getSalesforceBaseUrl().getHost()+'/services/apexrest/LCRMPostbackServiceAPI';
        req.httpMethod = 'POST';
        
        createPostbackData();
        Opportunity opp = [Select Id from opportunity WHERE name = 'Unit Test Opportuntiy postback' LIMIT 1];
        
        req.requestBody = Blob.valueOf('{ "updateOpportunityRequest": { "esiHeader": { "applicationId": "CW", "transactionId": "", "messageId": "LCRM_Status", "messageHistory": "", "tracingId": "", "timeStamp": "", "instanceId": "", "companyId": "", "configGroup": "", "payloadVersion": "", "postBackURL": "", "extensibleAttributes": [{ "systemIdentifier": "", "key": "", "value": "" }] }, "opportunity": { "actionCode": "Update", "opportunityHeader": { "opptyId": "'+opp.id+'", "salesStage": "", "opptyStatus": "Demo", "contractType": "", "quoteId": "" }, "opportunityRenewal": { "expectedEndDate": "", "negotiationExtnDate": "", "extensionAccessDate": "" }, "opportunityLineItem": [{ "opptyProductId": "", "opptyLineItemId": "", "newActualContractValue": "","currentActualContractValue": "", "opptyProductAction": "" }] } } }');
        RestContext.request = req;
        RestContext.response = res;
        
        
        LCRMPostbackServiceAPI.ResponseWrapper testList = LCRMPostbackServiceAPI.updateLCRMOpportunity();
        system.debug('testList** '+testList);
        System.assertEquals('400', testList.updateOpportunityResponse.StatusDetails.statusCode);
        System.debug('statusDetailMessage*** '+testList.updateOpportunityResponse.StatusDetails.statusDetailMessage);
        test.stopTest();
        
    }
    /*@isTest static void lcrmrenewalDateException() {
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = 'https://'+URL.getSalesforceBaseUrl().getHost()+'/services/apexrest/LCRMPostbackServiceAPI';
        req.httpMethod = 'POST';
        
        createPostbackData();
        Opportunity opp = [Select Id from opportunity WHERE name = 'Unit Test Opportuntiy postback' LIMIT 1];
        
        req.requestBody = Blob.valueOf('{ "updateOpportunityRequest": { "esiHeader": { "applicationId": "CW", "transactionId": "string", "messageId": "LCRM_renewalDate", "messageHistory": "string", "tracingId": "string", "timeStamp": "2008-09-29T01:49:45", "instanceId": "string", "companyId": "string", "configGroup": "string", "payloadVersion": "string", "postBackURL": "string", "extensibleAttributes": [{ "systemIdentifier": "string", "key": "string", "value": "string" }] }, "opportunity": { "actionCode": "Update", "opportunityHeader": { "opptyId": "'+opp.id+'", "salesStage": "string", "opptyStatus": "Extended Access", "contractType": "string", "quoteId": "string" }, "opportunityRenewal": { "expectedEndDate": "20170925", "negotiationExtnDate": "", "extensionAccessDate": "" }, "opportunityLineItem": [{ "opptyProductId": "", "opptyLineItemId": "", "newActualContractValue": "", "opptyProductAction": "" }] } } }');
        RestContext.request = req;
        RestContext.response = res;
        
        test.startTest();
        LCRMPostbackServiceAPI.ResponseWrapper testList = LCRMPostbackServiceAPI.updateLCRMOpportunity();
        system.debug('testList** '+testList);
        System.assertEquals('400', testList.updateOpportunityResponse.StatusDetails.statusCode);
        test.stopTest();
        
    }*/
    @isTest static void lcrmnegotiationExtnDateException() {
        test.startTest();
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = 'https://'+URL.getSalesforceBaseUrl().getHost()+'/services/apexrest/LCRMPostbackServiceAPI';
        req.httpMethod = 'POST';
        
        createPostbackData();
        Opportunity opp = [Select Id from opportunity WHERE name = 'Unit Test Opportuntiy postback' LIMIT 1];
        
        req.requestBody = Blob.valueOf('{ "updateOpportunityRequest": { "esiHeader": { "applicationId": "CW", "transactionId": "string", "messageId": "LCRM_negotiationExtnDate", "messageHistory": "string", "tracingId": "string", "timeStamp": "2008-09-29T01:49:45", "instanceId": "string", "companyId": "string", "configGroup": "string", "payloadVersion": "string", "postBackURL": "string", "extensibleAttributes": [{ "systemIdentifier": "string", "key": "string", "value": "string" }] }, "opportunity": { "actionCode": "Update", "opportunityHeader": { "opptyId": "'+opp.id+'", "salesStage": "string", "opptyStatus": "Extended Access", "contractType": "string", "quoteId": "string" }, "opportunityRenewal": { "expectedEndDate": "20170925", "negotiationExtnDate": "20170925", "extensionAccessDate": "" }, "opportunityLineItem": [{ "opptyProductId": "", "opptyLineItemId": "", "newActualContractValue": "","currentActualContractValue": "","opptyProductAction": "" }] } } }');
        RestContext.request = req;
        RestContext.response = res;
        
        
        LCRMPostbackServiceAPI.ResponseWrapper testList = LCRMPostbackServiceAPI.updateLCRMOpportunity();
        system.debug('testList** '+testList);
        System.assertEquals('400', testList.updateOpportunityResponse.StatusDetails.statusCode);
        test.stopTest();
        
    }
  
      @isTest static void lcrmAccessDateException() {
        test.startTest();
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = 'https://'+URL.getSalesforceBaseUrl().getHost()+'/services/apexrest/LCRMPostbackServiceAPI';
        req.httpMethod = 'POST';
        
        createPostbackData();
        Opportunity opp = [Select Id from opportunity WHERE name = 'Unit Test Opportuntiy postback' LIMIT 1];
        
        req.requestBody = Blob.valueOf('{ "updateOpportunityRequest": { "esiHeader": { "applicationId": "CW", "transactionId": "", "messageId": "LCRM_extensionAccessDate", "messageHistory": "", "tracingId": "", "timeStamp": "", "instanceId": "", "companyId": "", "configGroup": "", "payloadVersion": "", "postBackURL": "", "extensibleAttributes": [{ "systemIdentifier": "", "key": "", "value": "" }] }, "opportunity": { "actionCode": "Update", "opportunityHeader": { "opptyId": "'+opp.id+'", "salesStage": "", "opptyStatus": "", "contractType": "", "quoteId": "CW" }, "opportunityRenewal": { "expectedStartDate": "2017-09-30", "expectedEndDate": "2017-09-28", "negotiationExtnDate": "", "extensionAccessDate": "2017-09-3000" }, "opportunityLineItem": [{ "opptyProductId": "", "opptyLineItemId": "", "newAnnualContractValue": "","currentActualContractValue": "", "opptyProductAction": "", "cancelReason": "" }] } } }');
        RestContext.request = req;
        RestContext.response = res;
        
        
        LCRMPostbackServiceAPI.ResponseWrapper testList = LCRMPostbackServiceAPI.updateLCRMOpportunity();
        system.debug('testList** '+testList);
        System.assertEquals('400', testList.updateOpportunityResponse.StatusDetails.statusCode);
        test.stopTest();
        
    }
  
   @isTest static void lcrmAccessDateExceptionDuplicateAttributes() {
        test.startTest();
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = 'https://'+URL.getSalesforceBaseUrl().getHost()+'/services/apexrest/LCRMPostbackServiceAPI';
        req.httpMethod = 'POST';
        
        createPostbackData();
        Opportunity opp = [Select Id from opportunity WHERE name = 'Unit Test Opportuntiy postback' LIMIT 1];
        
        req.requestBody = Blob.valueOf('{ "updateOpportunityRequest": { "esiHeader": { "applicationId": "CW", "transactionId": "", "messageId": "LCRM_extensionAccessDate", "messageHistory": "", "tracingId": "", "timeStamp": "", "instanceId": "", "companyId": "", "configGroup": "", "payloadVersion": "", "postBackURL": "", "extensibleAttributes": [{ "systemIdentifier": "", "key": "", "value": "" }] }, "opportunity": { "actionCode": "Update", "opportunityHeader": { "opptyId": "'+opp.id+'", "salesStage": "", "opptyStatus": "", "contractType": "", "quoteId": "CW" }, "opportunityRenewal": { "expectedStartDate": "2017-09-30", "expectedEndDate": "2017-09-28", "negotiationExtnDate": "", "extensionAccessDate": "2017-09-30","extensionAccessDate": "2017-09-28", }, "opportunityLineItem": [{ "opptyProductId": "", "opptyLineItemId": "", "newAnnualContractValue": "","currentActualContractValue": "","opptyProductAction": "", "cancelReason": "" }] } } }');
        RestContext.request = req;
        RestContext.response = res;
        
        
        LCRMPostbackServiceAPI.ResponseWrapper testList = LCRMPostbackServiceAPI.updateLCRMOpportunity();
        system.debug('testList** '+testList);
        System.assertEquals('400', testList.updateOpportunityResponse.StatusDetails.statusCode);
        test.stopTest();
        
    }
    //START Added w.r.t. CRM-13416 by Shovon
    @isTest static void lcrmupdateCWProductWithPeriodPrice() {
        
        test.startTest();
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = 'https://'+URL.getSalesforceBaseUrl().getHost()+'/services/apexrest/LCRMPostbackServiceAPI';
        req.httpMethod = 'POST';
              
        createPostbackData();
        Opportunity opp = [Select Id from opportunity WHERE name = 'Unit Test Opportuntiy postback' LIMIT 1];
        OpportunityLineItem oppLineItem=[Select Id from OpportunityLineItem WHERE opportunityId =: opp.Id];
        req.requestBody = Blob.valueOf('{ "updateOpportunityRequest": { "esiHeader": { "applicationId": "CW", "transactionId": "string", "messageId": "LCRM_productUpdate", "messageHistory": "string", "tracingId": "string", "timeStamp": "2008-09-29T01:49:45", "instanceId": "string", "companyId": "string", "configGroup": "string", "payloadVersion": "string", "postBackURL": "string", "extensibleAttributes": [{ "systemIdentifier": "string", "key": "string", "value": "string" }] }, "opportunity": { "actionCode": "Update", "opportunityHeader": { "opptyId": "'+opp.id+'", "salesStage": "string", "opptyStatus": "Extended Access", "contractType": "Bridge", "quoteId": "string" }, "opportunityRenewal": { "expectedStartDate":"2017-09-25","expectedEndDate": "2017-09-30", "negotiationExtnDate": "2017-09-25", "extensionAccessDate": "", "multiYearOrBridgeInfo": [{ "period": "1", "startDate": "2021-09-20", "endDate": "2018-09-20", "price": "10" }, { "period": "2", "startDate": "2019-09-20", "endDate": "2020-09-20",  "price": "20" }, { "period": "3", "startDate": "2021-09-20", "endDate": "2022-09-20", "price": "30" }, { "period": "4", "startDate": "2023-09-20", "endDate": "2024-09-20", "price": "40" }, { "period": "5", "startDate": "2025-09-20", "endDate": "2026-09-20", "price": "50" } ] }, "opportunityLineItem": [{ "opptyProductId": "", "opptyLineItemId": "'+oppLineItem.id+'", "newActualContractValue": "20","currentActualContractValue": "", "opptyProductAction": "Add" ,"productComments" : ""}] } } }');
        RestContext.request = req;
        RestContext.response = res;
        
        
        LCRMPostbackServiceAPI.ResponseWrapper testList = LCRMPostbackServiceAPI.updateLCRMOpportunity();
        system.debug('testList** '+testList);
        System.assertEquals('200', testList.updateOpportunityResponse.StatusDetails.statusCode);
        test.stopTest();
        
    }
    
    @isTest static void lcrmupdateCWProductWithPeriodPriceAsNull() {
        
        test.startTest();
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = 'https://'+URL.getSalesforceBaseUrl().getHost()+'/services/apexrest/LCRMPostbackServiceAPI';
        req.httpMethod = 'POST';
              
        createPostbackData();
        Opportunity opp = [Select Id from opportunity WHERE name = 'Unit Test Opportuntiy postback' LIMIT 1];
        OpportunityLineItem oppLineItem=[Select Id from OpportunityLineItem WHERE opportunityId =: opp.Id];
        req.requestBody = Blob.valueOf('{ "updateOpportunityRequest": { "esiHeader": { "applicationId": "CW", "transactionId": "string", "messageId": "LCRM_productUpdate", "messageHistory": "string", "tracingId": "string", "timeStamp": "2008-09-29T01:49:45", "instanceId": "string", "companyId": "string", "configGroup": "string", "payloadVersion": "string", "postBackURL": "string", "extensibleAttributes": [{ "systemIdentifier": "string", "key": "string", "value": "string" }] }, "opportunity": { "actionCode": "Update", "opportunityHeader": { "opptyId": "'+opp.id+'", "salesStage": "string", "opptyStatus": "Extended Access", "contractType": "Bridge", "quoteId": "string" }, "opportunityRenewal": { "expectedStartDate":"2017-09-25","expectedEndDate": "2017-09-30", "negotiationExtnDate": "2017-09-25", "extensionAccessDate": "", "multiYearOrBridgeInfo": [{ "period": "1", "startDate": null, "endDate": null, "price": null }, { "period": "2", "startDate": null, "endDate": null,  "price": null }, { "period": "3", "startDate": null, "endDate": null, "price": null }, { "period": "4", "startDate": null, "endDate": null, "price": null }, { "period": "5", "startDate": null, "endDate": null, "price": null } ] }, "opportunityLineItem": [{ "opptyProductId": "", "opptyLineItemId": "'+oppLineItem.id+'", "newActualContractValue": "20","currentActualContractValue": "10", "opptyProductAction": "Add" ,"productComments" : ""}] } } }');
        RestContext.request = req;
        RestContext.response = res;
        
        
        LCRMPostbackServiceAPI.ResponseWrapper testList = LCRMPostbackServiceAPI.updateLCRMOpportunity();
        system.debug('testList** '+testList);
        System.assertEquals('200', testList.updateOpportunityResponse.StatusDetails.statusCode);
        test.stopTest();
        
    }
    //END Added w.r.t. CRM-13416 by Shovon
    //Data creation method
    @testSetup static void createPostbackData() {
        KeyValueListStore__c customSett = new KeyValueListStore__c();
        customSett.Name = 'ANZUsersProfileId';
        //Profile p =[Select Id from Profile where Name ='ANZ Users' Limit 1];
        //customSett.TextValue__c = '00e30000001ZUki';
        //customSett.TextValue__c = p.id;
        customSett.TextValue__c = System.Label.Digital_ANZ_User_Profile_Id;
        insert customsett;
        System.debug('customsett'+customsett);
        
        //RecordtypeId custom setting for OpportunityAfterEventListener
        RecordtypeIds__c testRecordtypeSetting= new RecordtypeIds__c();
        testRecordtypeSetting.name = 'Pipeline Opportunities';
        testRecordtypeSetting.recTypeId__c = System.Label.Digital_Pipeline_Record_Type_ID; 
        insert testRecordtypeSetting;
        
        RecordtypeIds__c testRecordtypeSetting2 = new RecordtypeIds__c();
        testRecordtypeSetting2.name = 'Pre-Pipeline Opportunities';
        testRecordtypeSetting2.recTypeId__c = System.Label.Digital_Pre_Pipeline_Record_Type_Id; 
        insert testRecordtypeSetting2;
        Account oAccount = new Account();
        oAccount.Name = 'Unit Test';
        oAccount.Sales_Org__c = 'West';
        oAccount.Customer_Type__c = 'Individual';
        oAccount.Customer_Group__c = 'ACADEMIC';
        oAccount.Industry = 'TAX';
        oAccount.Phone = '114157882035';
        oAccount.Street_Address_3__c = 'West';
        oAccount.Street_Address_4__c = 'Eastwatch';
        oAccount.Data_Remediation_Required__c  = true;
        insert oAccount;
        
        Pricebook2 pricebook1 = new Pricebook2();
        pricebook1.Name = 'GLI Price Book - UKI';
        pricebook1.IsActive = true;
        insert pricebook1;
        
        Product2 oProduct = new Product2();
        oProduct.Name = 'Unit Test Product';
        oProduct.isActive = true;
        oProduct.ProductCode = '123';
        insert oProduct;
        
        Id standardPriceBookId = Test.getStandardPricebookId();        
        PricebookEntry pbe1 = new PricebookEntry (Pricebook2Id=standardPriceBookId, Product2Id=oProduct.id, IsActive=true, UnitPrice=100.0);
        insert pbe1;
        
        //PricebookEntry pbe2 = TestLCRMPostbackServiceAPI.createPricebookEntry(prod1.id,pricebook1.id);
        PricebookEntry pbe2 = new PricebookEntry (Pricebook2Id=pricebook1.id, Product2Id=oProduct.id, IsActive=true, UnitPrice=100.0);
        insert pbe2;
        
        Opportunity oOpportunity = new Opportunity();
        oOpportunity.AccountId = oAccount.id;
        oOpportunity.Name = 'Unit Test Opportuntiy postback';
        oOpportunity.CloseDate = System.Today() + 5;             
        oOpportunity.stageName = 'Appointment Scheduled';
        oOpportunity.Pricebook2Id = pricebook1.id;
        //oOpportunity.Is_Master_Opportunity__c = true;
        oOpportunity.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();        
        oOpportunity.Is_GLI__c = TRUE;
        oOpportunity.LCRM_Sub_BU__c = 'Elite';
        oOpportunity.Expected_End_Date__c = Date.Today();
        oOpportunity.CurrencyIsoCode = 'USD';
        //oOpportunity.LCRM_Split_On__c = false;
        oOpportunity.Expiration_Date__c = Date.Today();
        insert oOpportunity;
        
        OpportunityLineItem oppLineItem = new OpportunityLineItem();
        oppLineItem.OpportunityId = oOpportunity.id;
        oppLineItem.PricebookEntryId = pbe2.id;
        //oppLineItem.UnitPrice = 7000;
        oppLineItem.Quantity = 5;
        oppLineItem.LCRM_Units__c = 1;
        oppLineItem.LCRM_Current_ACV__c =16;
        insert oppLineItem;
        
        
        
        
    }
    
    
}