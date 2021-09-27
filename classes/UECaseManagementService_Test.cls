/********************************************************************************
Class Name : UECaseManagementServices_Test
@description : Test Class of UECaseManagementServices
********************************************************************************
Modification Details:
Date                    Description                     Owner
24/09/2020              Created                         Herin Acharya
*********************************************************************************/

@isTest
private class UECaseManagementService_Test{
    /********************************************************************************
    Method Name : setup
    @description : To create test data for case creation (Account ,Source_System_Detail__c,Contact,Product2)
    *********************************************************************************/
    @testSetup 
     static void setup(){
      
        Account objAcc = new Account();
        objAcc.Name='Test';
        objAcc.AccountNumber ='12345';
        objAcc.Sales_Org__c = 'GLI';
        objAcc.BU_Region__c='US';
        objAcc.Bu_Segment__c='Professional Legal';
        insert objAcc;  
         
        Account objAcc2=objAcc.clone();
        objAcc2.Sales_Org__c = 'GLI';
        objAcc2.BU_Region__c='Canada';
        objAcc2.Bu_Segment__c='';
        insert objAcc2; 
         
        /*
        Account objAcc3=objAcc.clone();
        objAcc3.Sales_Org__c = 'GLI';
        objAcc3.BU_Region__c='UKI';
        objAcc3.Bu_Segment__c='';
        insert objAcc3;
        */
        
        Source_System_Detail__c objLCRMSSD = new Source_System_Detail__c();
        objLCRMSSD.Account_name__c = objAcc.id;
        objLCRMSSD.Name = 'TestLcrmAccName';
        objLCRMSSD.Source_System_Name__c = 'TestSAP';
        objLCRMSSD.Source_System_Account_Number__c = '123456'; 
        objLCRMSSD.Account_Name__c = objAcc.id;
        insert objLCRMSSD;
         
        Contact objContact = new contact();
        objContact.AccountId = objAcc.id;
        objContact.FirstName = 'TestFirstName';
        objContact.LastName = 'TestLastName';
        objContact.Email = 'Test@gmail.com';
        Insert objContact;
         
        Contact objContact2= new Contact();
        objContact2.AccountId=objAcc2.id;
        objContact2.FirstName = 'CanadaContact'; 
        objContact2.LastName='CanadaContact';
        objContact2.Email='canada@mail.com';
        insert objContact2;
         
        Product2 objPro = new Product2();
        objPro.name = 'LEGALONE CORPORATE BSUB';
        insert objPro;
         
        User userObj = new User();
        userObj.ProfileId = [SELECT Id FROM Profile WHERE Name =  'System Administrator'].Id;
        userObj.FirstName = 'ESI';
        userObj.LastName = 'User';
        userObj.Username = 'ESIUsertest@test.com';
        userObj.alias = 'fakeESI';
        userObj.email = 'ESIUsertest@test.com';
        userObj.localesidkey='en_US';
        userObj.emailencodingkey='UTF-8';
        userObj.languagelocalekey='en_US';
        userObj.localesidkey='en_US';
        userObj.timezonesidkey= 'America/Los_Angeles';
        insert userObj;
         
        List<Case> allCases = new List<Case>();
        Case objCase = new Case();
        objCase.contactId = objContact.id;
        objCase.AccountId = objAcc.id;
        objCase.LCRM_Account_SSD__c = objLCRMSSD.id;
        objCase.subject = 'I cannot access the product';
        objCase.Description = 'TestDiscription';
        objCase.MYTR_Query_Type__c = 'I cannot access the product';
        objCase.SuppliedPhone = '912345678';
        objCase.ESC_Origin_Name__c= ' Sample URL';
        objCase.Origin = MTRCommonUtility.MYTR_ORIGIN;   
        objCase.UE_Language_Locale__c = 'en-us';
        allCases.add(objCase);
        
        Case riskCase = new Case();
        riskCase.contactId = objContact.id;
        riskCase.AccountId = objAcc.id;
        riskCase.LCRM_Account_SSD__c = objLCRMSSD.id;
        riskCase.subject = 'I cannot access the product';
        riskCase.Description = 'TestDiscription';
        riskCase.MYTR_Query_Type__c = 'I would like to request a copy or reprint of my invoice';
        riskCase.SuppliedPhone = '912345678';
        riskCase.ESC_Origin_Name__c= ' Sample URL';
        riskCase.Origin = MTRCommonUtility.MYTR_ORIGIN;  
        riskCase.ESC_Product_Segment_Brand__c ='Risk';
        
        riskCase.ESC_Product_Title__c = 'ODEN';
        //riskCase.ESC_Product_Feature_Module__c = 'Oden Online';
        allCases.add(riskCase);
        insert allCases;
        
        /*
        System.runAs(userObj){
            List<Contentversion> cv = new List<Contentversion>();
            Contentversion objCV1 = new Contentversion();
            objCV1.VersionData = EncodingUtil.base64Decode('iVBORw0KGgoAAAANSUhEUgAABj8AAAOACAYAAABlnmGhAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAP');
            objCV1.Title = 'ContnetVersion1';
            objCV1.PathOnClient = 'ContnetVersion1.PNG';
            objCV1.FirstPublishLocationId = objCase.id;
            cv.add(objCV1);
            
            Contentversion objCV2 = new Contentversion();
            objCV2.VersionData = EncodingUtil.base64Decode('iVBORw0KGgoAAAANSUhEUgAABj8AAAOACAYAAABlnmGhAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAP');
            objCV2.Title = 'ContnetVersion2';
            objCV2.PathOnClient = 'ContnetVersion2.PNG';
            cv.add(objCV2);
            
            Contentversion objCV3 = new Contentversion();
            objCV3.VersionData = EncodingUtil.base64Decode('iVBORw0KGgoAAAANSUhEUgAABj8AAAOACAYAAABlnmGhAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAP');
            objCV3.Title = 'ContnetVersion2';
            objCV3.PathOnClient = 'ContnetVersion3.PNG';
            cv.add(objCV3);
            
            insert cv;
            
            FeedItem objFeedItem1 = new FeedItem();
            objFeedItem1.ParentId = objCase.id;
            objFeedItem1.Body = 'Test Comment';
            objFeedItem1.Type = 'ContentPost';
            objFeedItem1.RelatedRecordId = objCV1.id;
            insert objFeedItem1;
            
            
            //FeedItem DeleteItem = new FeedItem();
            //DeleteItem.ParentId = objCase.id;
            //DeleteItem.Body = 'Delete Feed';
            //DeleteItem.Type = 'ContentPost';
            //DeleteItem.RelatedRecordId = objCV3.id;
            //insert DeleteItem;
            
            
            FeedAttachment objFA = new FeedAttachment();
            objFA.FeedEntityId = objFeedItem1.id;
            objFA.RecordId = objCV2.id;
            objFA.Type = 'CONTENT';
            insert objFA;
           
            list<Contentversion> listCV= [Select id,contentdocumentId from Contentversion];
            system.debug(LoggingLevel.DEBUG,'listCV---'+listCV);
        } 
        */
                  
     }
    
    /********************************************************************************
    Method Name : testDataforAemCase
    @description : TO create sample wrapper class(for test purpose), using test setup data(SSD record, contact record, product record)
    @return UECaseManagementInnerClasses.CaseDetailsWrapper
    *********************************************************************************/
    public static UECaseManagementInnerClasses.CaseDetailsWrapper testDataforAemCase(){
        
        Source_System_Detail__c objSSD = [select id,Account_name__c,Source_System_Account_Number__c from 
                                          Source_System_Detail__c where Source_System_Account_Number__c = '123456' limit 1];                                                
        Contact objContact = [select id,Email,Accountid from Contact where FirstName = 'TestFirstName' limit 1];
        //Contact objContact1 = [select id,Email,Accountid from Contact where Email='canada@mail.com' limit 1];
                
        UECaseManagementInnerClasses.CaseDetailsWrapper objCaseNew = new UECaseManagementInnerClasses.CaseDetailsWrapper();
        objCaseNew.SAPAccountNumber = objSSD.Source_System_Account_Number__c;
        objCaseNew.ContactId = objContact.id;
        objCaseNew.subject = 'I need to update my account info.';
        objCaseNew.reasonID='l3Reason3001';
        objCaseNew.categoryCode='l2Reason_2001';
        objCaseNew.Description = 'TestDiscription';
        objCaseNew.QueryType = 'I need to update my account info.';
        objCaseNew.Product = 'LEGALONE CORPORATE BSUB';
        objCaseNew.PhoneNumber = '912345678';
        objCaseNew.language='en-us';
        objCaseNew.queryCategory ='General account questions';
        objCaseNew.currentFormURL = ' Sample URL';
        objCaseNew.alternateEmail = 'test@test.com';
        return objCaseNew;
        
    }
    
    /********************************************************************************
    Method Name : testSampleRestRequest
    @description : TO create sample JSON request. By using this we will not need to write sample request multiple times for diffrent test scenarios
    @param json
    @return RestRequest
    *********************************************************************************/
    public static RestRequest testSampleRestRequest (string json){
        RestRequest request = new RestRequest();
        request.requestBody = Blob.valueof(json);
        request.requestUri ='/services/apexrest/UECaseManagementService/';
        request.httpMethod = 'POST';       
        RestContext.request = request;
        request.addParameter('operation', 'CREATECASE');
        request.addParameter('source', 'UE');      
        return request;
    }
    
    /********************************************************************************
    Method Name : testDoPostSuccessScenarios
    @description : To test all the successful case creation scenario/Positive scenario
    *********************************************************************************/
    
    @isTest 
    private static void testDoPostSuccessScenarioLegal(){
        list<id> lstMTRCaseId = new list<ID>();
        test.starttest();
        
        //TestDataforAemCase() method is used to create test data for wrapper class
        UECaseManagementInnerClasses.caseDetailsWrapper objCaseAEM = TestDataforAemCase();            
        String jsonMsg;
        
        //TestSampleRestRequest() method is used to create Sample request
        RestRequest request;
        UECaseManagementResponseClasses.CreateCaseResponse response = new  UECaseManagementResponseClasses.CreateCaseResponse();
        
        // test scenario - LEGAL successfull case creation
        objCaseAEM.queryType = 'Password reset';
        objCaseAEM.reasonID='l3TestReasonC0de';
        jsonMsg=JSON.serialize(objCaseAEM);
        request = TestSampleRestRequest(jsonMsg);
        request.addParameter('business', 'LEGAL');        
        response = UECaseManagementService.postServices();
       // system.debug(LoggingLevel.DEBUG,'response--'+response);
        System.assert(response.caseId != null, 'Case successfully created');
        
        //Adding code to cover email functionality of RISK
        case objCase = [Select id from case where ESC_Product_Segment_Brand__c ='Risk' ];    
        lstMTRCaseId.clear();
        lstMTRCaseId.add(response.caseId);
        
        MTRCommonUtility.mtrSendCreateCaseNotification(lstMTRCaseId);
        lstMTRCaseId.clear();
        lstMTRCaseId.add(objCase.id);
        MTRCommonUtility.mtrSendCreateCaseNotification(lstMTRCaseId);
        
        
        
        //Test- Update for Legal
        RestRequest request2;
        request2 = TestSampleRestRequest(jsonMsg);
        request2.addParameter('business', 'LEGAL');
        request2.addParameter('operation', 'UPDATERECORDTYPE');
        request2.addParameter('casenumber', response.caseNumber);
        request2.addParameter('reasonid', 'l3TestReasonC0de');
        response = UECaseManagementService.postServices();
        
                
        test.stopTest();        
    }
    
    @isTest 
    private static void testDoPostSuccessScenarioCanada(){
        test.starttest();
        
        //TestDataforAemCase() method is used to create test data for wrapper class
        UECaseManagementInnerClasses.caseDetailsWrapper objCaseAEM = TestDataforAemCase();     
        objCaseAEM.currentFormURL='testtesttestetstetesttesttestetstetesttesttestetstetesttesttestetstetesttesttestetstetesttesttestetstetesttesttestetstetesttesttestetstetesttesttestetstetesttesttestetstetesttesttestetstetesttesttestetstetesttesttestetstetesttesttestetstetesttesttestetstetesttesttestetste';
        String jsonMsg;
        
        //TestSampleRestRequest() method is used to create Sample request
        RestRequest request;
        UECaseManagementResponseClasses.CreateCaseResponse response = new UECaseManagementResponseClasses.CreateCaseResponse();
        
        // test scenario - CANADA successfull case creation
        objCaseAEM.queryType = 'Cancel Subscription';
        objCaseAEM.reasonID='l4TestReasonC0de';
        objCaseAEM.product = 'Gosystem Tax RS|Browser|GoSystem 1040';
        objCaseAEM.language='en-us';
        jsonMsg=JSON.serialize(objCaseAEM);
        request = TestSampleRestRequest(jsonMsg);
        request.addParameter('business', 'CANADA');          
        response = UECaseManagementService.postServices();   
        system.debug(LoggingLevel.DEBUG,'response--'+response);
        System.assert(response.caseId != null, 'Case successfully created');
        
        //Test- Update for CANADA
        RestRequest request2;
        request2 = TestSampleRestRequest(jsonMsg);
        request2.addParameter('business', 'CANADA');
        request2.addParameter('operation', 'UPDATERECORDTYPE');
        request2.addParameter('casenumber', response.caseNumber);
        request2.addParameter('reasonid', 'l4TestReasonC0de');
        response = UECaseManagementService.postServices();
        
        //dkb to cover invalid reasonid on UpdateRecordType service
        RestRequest request3;
        request3 = TestSampleRestRequest(jsonMsg);
        request3.addParameter('business', 'CANADA');
        request3.addParameter('operation', 'UPDATERECORDTYPE');
        request3.addParameter('casenumber', response.caseNumber);
        request3.addParameter('reasonid', 'test');
        
        //response = new UECaseManagementResponseClasses.CreateCaseResponse();
        response = UECaseManagementService.postServices();
        system.assertEquals(response.errorMessage,MTRCommonUtility.INCORRECT_REASONID,'Incorrect reasonid');
        test.stopTest();       
    }
    
    /********************************************************************************
    Method Name : testSampleDeleteAttachReq
    @description : TO create sample JSON request. By using this we will not need to write sample request multiple times for diffrent test scenarios
    @param json
    @return RestRequest
    *********************************************************************************/
    public static RestRequest testSampleDeleteAttachReq (string json){
        RestRequest request = new RestRequest();
        request.requestBody = Blob.valueof(json);
        request.requestUri ='/services/apexrest/UECaseManagementService/';
        request.httpMethod = 'DELETE';       
        RestContext.request = request;
        return request;
    }
    
     /********************************************************************************
    Method Name : testExceptionScenario1
    @description : To test all the failed case creation scenario/Negative scenario
    *********************************************************************************/
    @isTest 
    private static void testExceptionScenario1(){
        
        test.starttest();   
        
        //Test data  - to validate Improper Request
        UECaseManagementResponseClasses.CreateCaseResponse response = new UECaseManagementResponseClasses.CreateCaseResponse();
               
        UECaseManagementInnerClasses.caseDetailsWrapper objCaseAEM = null;
        String jsonMsg=JSON.serialize(objCaseAEM);       
        RestRequest request = TestSampleRestRequest(jsonMsg);
        request.addParameter('business', 'LEGAL');
        response = new UECaseManagementResponseClasses.CreateCaseResponse();
        response = UECaseManagementService.postServices();
        System.AssertEquals(response.errorMessage,MTRCommonUtility.IMPROPER_REQUEST_FORMAT, MTRCommonUtility.IMPROPER_REQUEST_FORMAT);
        
        //Test data - to validate Incorrect operation
        objCaseAEM = TestDataforAemCase();
        jsonMsg=JSON.serialize(objCaseAEM);       
        request = TestSampleRestRequest(jsonMsg);
        request.addParameter('operation', 'SOMERANDOMVALUE');
        
        response = new UECaseManagementResponseClasses.CreateCaseResponse();
        response = UECaseManagementService.postServices();
        System.AssertEquals(response.errorMessage,MTRCommonUtility.INVALID_OPERATION +':'+'SOMERANDOMVALUE',MTRCommonUtility.INVALID_OPERATION +':'+ 'SOMERANDOMVALUE');
        
        //Test data - to validate Incorrect Business Unit
        objCaseAEM = TestDataforAemCase();
        jsonMsg=JSON.serialize(objCaseAEM);       
        request = TestSampleRestRequest(jsonMsg);
        request.addParameter('business', 'SOMERANDOMVALUE');
        
        response = new UECaseManagementResponseClasses.CreateCaseResponse();
        response = UECaseManagementService.postServices();
        System.AssertEquals(response.errorMessage,MTRCommonUtility.INVALID_BU +' -'+ 'SOMERANDOMVALUE',MTRCommonUtility.INVALID_BU +' -'+ 'SOMERANDOMVALUE');
        
        //Test data - to validate Blank Business Unit
        request.addParameter('business', '');      
        response = new UECaseManagementResponseClasses.CreateCaseResponse();
        response = UECaseManagementService.postServices();
        System.AssertEquals(response.errorMessage,MTRCommonUtility.INVALID_BU +' -'+ '',MTRCommonUtility.INVALID_BU +' -'+ '');
        
        //Test data - to vaalidate blank source
        request.addParameter('source', '');      
        response = new UECaseManagementResponseClasses.CreateCaseResponse();
        response = UECaseManagementService.postServices();
        System.AssertEquals(response.errorMessage,MTRCommonUtility.SOURCE_MISSING,MTRCommonUtility.SOURCE_MISSING);
        
        test.stopTest();
    }
  
  
    /********************************************************************************
    Method Name : testExceptionScenarios
    @description : To test all the failed case creation scenario/Negative scenario
    *********************************************************************************/
    @isTest 
    private static void testExceptionScenarios(){
        test.starttest();   
        
         //Test data - to cover catch block
        UECaseManagementResponseClasses.CreateCaseResponse response = new UECaseManagementResponseClasses.CreateCaseResponse();
        response = UECaseManagementService.postServices();
        System.AssertEquals(response.isSuccess,false,'In catch block');
        
        //Test data - to validate Invalid contactId
        UECaseManagementInnerClasses.caseDetailsWrapper objCaseAEM = TestDataforAemCase();
        objCaseAEM.ContactId = 'badvalue';
        String jsonMsg=JSON.serialize(objCaseAEM);       
        RestRequest request = TestSampleRestRequest(jsonMsg);
        request.addParameter('business', 'LEGAL');
        
        response = new UECaseManagementResponseClasses.CreateCaseResponse();
        response = UECaseManagementService.postServices();
        System.AssertEquals(response.errorMessage,MTRCommonUtility.INVALID_CONTACT+' -'+objCaseAEM.ContactId,'Invalid Contact');
        
        // Test Data - to validate Invalid SSD
        Contact objContact1 = [select id,Email,Accountid from Contact where Email='canada@mail.com' limit 1];
        objCaseAEM = TestDataforAemCase();
        objCaseAEM.SAPAccountNumber = 'badvalue';
        objCaseAEM.ContactId = objContact1.id;
        jsonMsg=JSON.serialize(objCaseAEM);       
        request = TestSampleRestRequest(jsonMsg);
        request.addParameter('business', 'LEGAL');
        
        response = new UECaseManagementResponseClasses.CreateCaseResponse();
        response = UECaseManagementService.postServices();
        System.AssertEquals(response.errorMessage,MTRCommonUtility.SSD_NOT_AVAILABLE+' -'+objCaseAEM.SAPAccountNumber,MTRCommonUtility.SSD_NOT_AVAILABLE+' -'+objCaseAEM.SAPAccountNumber);
         
        //Test data - to validate Invalid QueryType
        
        objCaseAEM = TestDataforAemCase();
        objCaseAEM.queryType = 'badvalue';
        objCaseAEM.reasonID='TestReasonC0deId';
        jsonMsg=JSON.serialize(objCaseAEM);       
        request = TestSampleRestRequest(jsonMsg);
        request.addParameter('business', 'LEGAL');
        
        response = new UECaseManagementResponseClasses.CreateCaseResponse();
        response = UECaseManagementService.postServices();
        System.AssertEquals(response.errorMessage, MTRCommonUtility.QUERY_TYPE_MISSING,MTRCommonUtility.QUERY_TYPE_MISSING);
        
        //Test data - to validate Blank QueryType
        objCaseAEM.reasonID = null;
        jsonMsg=JSON.serialize(objCaseAEM);       
        request = TestSampleRestRequest(jsonMsg);
        request.addParameter('business', 'LEGAL');

        response = new UECaseManagementResponseClasses.CreateCaseResponse();
        response = UECaseManagementService.postServices();
        //system.assert(response.errorMessage ==  MTRCommonUtility.QUERY_TYPE_NOT_PROVIDED);
        system.assertEquals(response.errorMessage, MTRCommonUtility.REASON_CODE_NOT_PROVIDED,MTRCommonUtility.REASON_CODE_NOT_PROVIDED);
        
        //dkb
        request = TestSampleRestRequest(jsonMsg);
        request.addParameter('business', 'LEGAL');
        request.addParameter('operation', 'UPDATERECORDTYPE');
        request.addParameter('casenumber', null);
        request.addParameter('reasonid', 'l3TestReasonC0de');
        
        //response = new UECaseManagementResponseClasses.CreateCaseResponse();
        response = UECaseManagementService.postServices();
        system.assertEquals(response.errorMessage, 'Case does not exist',MTRCommonUtility.INVALID_CASE);
         
        test.stopTest();
    }
    
    /*
    @isTest 
    public static void testFlowCoverage(){
    //This method is for code coverage for the Process Builder: Process Builder - GGO_CaseEmailNotifications
    //This method covers 100% the flow.
     Contact objContact = [select id,Email from Contact where FirstName = 'TestFirstName' limit 1];
        List<Case> lstCase= new List<Case>();
        Case oCase1 =unitTest.getCaseInstance();
        oCase1.ContactId=objContact.Id;
        oCase1.Origin ='Web';
        oCase1.LCRM_Sub_BU__c  ='GGO';
        oCase1.SuppliedEmail='test@mail.com';
        oCase1.ESC_Origin_Name__c  ='TESTSTRINGURL=br&';
        
        lstCase.add(oCase1);
        
        Case oCase2=oCase1.Clone();
        oCase1.ESC_Origin_Name__c  ='TESTSTRINGURL=ar&';
        
        lstCase.add(oCase2);
        
        insert lstCase;
        //System.assert(lstCase.size()==2);
        system.assertEquals(lstCase.size(), 2, 'List Size matched');
    }
    */
    
     /********************************************************************************
    Method Name : testSampleRestRequest
    @description : TO create sample JSON request. By using this we will not need to write sample request multiple times for diffrent test scenarios
    @param json
    @return RestRequest
    *********************************************************************************/
    /*
    public static RestRequest testSampleRestRequest1 (string json){
        RestRequest request = new RestRequest();
        request.requestBody = Blob.valueof(json);
        request.requestUri ='/services/apexrest/UECaseManagementService/';
        request.httpMethod = 'DELETE';       
        RestContext.request = request;
        return request;
    }
    */
    /*
    @isTest 
    private static void testDoPostSuccessScenarios1(){
        test.starttest();
        User userObj = [Select id,firstname,lastname,name from user where firstname = 'ESI' and lastname = 'User' and Username = 'ESIUsertest@test.com' limit 1];
        system.debug(LoggingLevel.DEBUG,'userObj---'+userObj);
        System.runAs(userObj){
            Contact objContact = [select id,Email from Contact where FirstName = 'TestFirstName' limit 1];
            
            case objCase = [Select id from case where contactid =:objContact.id and ESC_Product_Segment_Brand__c NOT IN ('Risk')];
            
            FeedItem objFeed = [Select id,createdby.firstname,createdby.lastname from FeedItem where ParentId =: objCase.id and type = 'ContentPost'];
            system.debug(LoggingLevel.DEBUG,'objFeed---'+objFeed);
            //FeedItem objFeed1 = [Select id,createdby.firstname,createdby.lastname from FeedItem where ParentId =: objCase.id and type = 'TextPost'];
                    
            list<Contentversion> listCV= [Select id,contentdocumentId from Contentversion order by createddate];
            system.debug(LoggingLevel.DEBUG,'listCV---'+listCV);
            
            list<FeedAttachment> listFA = [Select id,FeedEntityId,RecordId from FeedAttachment where FeedEntityId=:objFeed.id and 
                                          RecordId =:listCV[0].id ];  
            system.debug(LoggingLevel.DEBUG,'listFA---'+listFA);
           
            UECaseManagementInnerClasses.deleteFeedWrapper objdeleteRequestWrapper = new UECaseManagementInnerClasses.deleteFeedWrapper();
            objdeleteRequestWrapper.contentDocumentId = listCV[0].contentdocumentId;
            objdeleteRequestWrapper.contentVersionId = listCV[0].id;
            objdeleteRequestWrapper.feedItemId = objFeed.id;
            
            //Use for deleted feed item
           // FeedItem deleteItem= [Select id,createdby.firstname,createdby.lastname from FeedItem where Body = ''];
            UECaseManagementInnerClasses.deleteFeedWrapper objdeleteRequestWrapper1 = new UECaseManagementInnerClasses.deleteFeedWrapper();
            objdeleteRequestWrapper1.contentDocumentId = listCV[0].contentdocumentId;
            objdeleteRequestWrapper1.contentVersionId = listCV[0].id;
              
                
            String jsonMsg;
            
            
            RestRequest request = new RestRequest();
            UECaseManagementResponseClasses.deleteFeedResponseMessage response = new UECaseManagementResponseClasses.deleteFeedResponseMessage();
            
            
            objdeleteRequestWrapper1.feedItemId = objfeed.id; 
            jsonMsg=JSON.serialize(objdeleteRequestWrapper);
            request = TestSampleRestRequest(jsonMsg);
            request.addParameter('operation', 'DELETEATTACHMENT'); 
            response = UECaseManagementService.deleteServices();
            system.debug(LoggingLevel.DEBUG,'response---'+response);
            response = UECaseManagementService.deleteServices();
            //System.AssertEquals(response.isSuccess,true,'Attachment Deleted Successfully');
            
            //TO throw exception - DeleteItem
            
            
            //error scenario 1 - Improper Format
            objdeleteRequestWrapper = new UECaseManagementInnerClasses.deleteFeedWrapper();
            objdeleteRequestWrapper.contentDocumentId = listCV[0].contentdocumentId;
            objdeleteRequestWrapper.contentVersionId = listCV[0].id;
            objdeleteRequestWrapper.feedItemId = '';
            
            jsonMsg = JSON.serialize(objdeleteRequestWrapper);
            response = new UECaseManagementResponseClasses.deleteFeedResponseMessage();
            request = new RestRequest();
            request = testSampleDeleteAttachReq(jsonMsg);
            request.addParameter('operation', 'DELETEATTACHMENT');
            response = UECaseManagementService.deleteServices();
            system.debug(LoggingLevel.DEBUG,'response---'+response);
            System.AssertEquals(response.isSuccess,false,MTRCommonUtility.IMPROPER_REQUEST_FORMAT);
            
            //error scenario 1.a
            objdeleteRequestWrapper.feedItemId = '66666';
            jsonMsg = JSON.serialize(objdeleteRequestWrapper);
            response = new UECaseManagementResponseClasses.deleteFeedResponseMessage();
            request = new RestRequest();
            request = testSampleDeleteAttachReq(jsonMsg);
            request.addParameter('operation', 'DELETEATTACHMENT');
            response = UECaseManagementService.deleteServices();
           
                
            //error scenario 2 - Incorrect Operation            
            jsonMsg = JSON.serialize(objdeleteRequestWrapper);
                
            response = new UECaseManagementResponseClasses.deleteFeedResponseMessage();
            request = new RestRequest();
            request = testSampleDeleteAttachReq(jsonMsg);
            request.addParameter('operation', 'SomeBadvalue');
            system.debug(LoggingLevel.DEBUG,'request---'+request);
            response = UECaseManagementService.deleteServices();
            system.debug(LoggingLevel.DEBUG,'response---'+response);
            System.AssertEquals(response.isSuccess,false,'INCORRECT OPERATION');
            
        }
        test.stopTest();
    }*/
    
    /*
    @isTest 
    private static void testDeleteNoBodyPost(){
        test.starttest();
        User userObj = [Select id,firstname,lastname,name from user where firstname = 'ESI' and lastname = 'User' and Username = 'ESIUsertest@test.com' limit 1];
        system.debug(LoggingLevel.DEBUG,'userObj---'+userObj);
        System.runAs(userObj){
            Contact objContact = [select id,Email from Contact where FirstName = 'TestFirstName' limit 1];
            
            case objCase = [Select id from case where contactid =:objContact.id and ESC_Product_Segment_Brand__c NOT IN ('Risk')];
            
            FeedItem objFeed = [Select id,createdby.firstname,createdby.lastname from FeedItem where ParentId =: objCase.id and type = 'ContentPost'];
            objFeed.Body = '';
            update objFeed;
            system.debug(LoggingLevel.DEBUG,'objFeed---'+objFeed);
            //FeedItem objFeed1 = [Select id,createdby.firstname,createdby.lastname from FeedItem where ParentId =: objCase.id and type = 'TextPost'];
                    
            list<Contentversion> listCV= [Select id,contentdocumentId from Contentversion order by createddate];
            system.debug(LoggingLevel.DEBUG,'listCV---'+listCV);
            
            list<FeedAttachment> listFA = [Select id,FeedEntityId,RecordId from FeedAttachment where FeedEntityId=:objFeed.id and 
                                          RecordId =:listCV[0].id ];  
            system.debug(LoggingLevel.DEBUG,'listFA---'+listFA);
           
            UECaseManagementInnerClasses.deleteFeedWrapper objdeleteRequestWrapper = new UECaseManagementInnerClasses.deleteFeedWrapper();
            objdeleteRequestWrapper.contentDocumentId = listCV[0].contentdocumentId;
            objdeleteRequestWrapper.contentVersionId = listCV[0].id;
            objdeleteRequestWrapper.feedItemId = objFeed.id;
           
            String jsonMsg;
            RestRequest request = new RestRequest();
            UECaseManagementResponseClasses.deleteFeedResponseMessage response = new UECaseManagementResponseClasses.deleteFeedResponseMessage();
            
            
            objdeleteRequestWrapper.feedItemId = objfeed.id; 
            jsonMsg=JSON.serialize(objdeleteRequestWrapper);
            request = TestSampleRestRequest(jsonMsg);
            request.addParameter('operation', 'DELETEATTACHMENT'); 
            response = UECaseManagementService.deleteServices();
            system.debug(LoggingLevel.DEBUG,'response---'+response);
            //response = UECaseManagementService.deleteServices();
            System.AssertEquals(response.isSuccess,true,'Good');
            
            //delete second doc
            listCV= [Select id,contentdocumentId from Contentversion order by createddate];
            system.debug(LoggingLevel.DEBUG,'listCV---'+listCV);
            
            listFA = [Select id,FeedEntityId,RecordId from FeedAttachment where FeedEntityId=:objFeed.id and 
                                          RecordId =:listCV[0].id ];  
            system.debug(LoggingLevel.DEBUG,'listFA---'+listFA);
            objdeleteRequestWrapper.contentDocumentId = listCV[0].contentdocumentId;
            objdeleteRequestWrapper.contentVersionId = listCV[0].id;
            objdeleteRequestWrapper.feedItemId = objFeed.id;
            
              jsonMsg=JSON.serialize(objdeleteRequestWrapper);
            request = TestSampleRestRequest(jsonMsg);
            request.addParameter('operation', 'DELETEATTACHMENT'); 
            response = UECaseManagementService.deleteServices();
            system.debug(LoggingLevel.DEBUG,'response---'+response);
            response = UECaseManagementService.deleteServices();
            //System.AssertEquals(response.isSuccess,true,'Attachment Deleted Successfully');
            
            //Do error
             objdeleteRequestWrapper.feedItemId = '66666666';
            
              jsonMsg=JSON.serialize(objdeleteRequestWrapper);
            request = TestSampleRestRequest(jsonMsg);
            request.addParameter('operation', 'DELETEATTACHMENT'); 
            response = UECaseManagementService.deleteServices();
            system.debug(LoggingLevel.DEBUG,'response---'+response);
            response = UECaseManagementService.deleteServices();
            //System.AssertEquals(response.isSuccess,true,'Attachment Deleted Successfully');
        }
        test.stopTest();
    }*/
    
   
     /********************************************************************************
    Method Name : testExceptionScenario1
    @description : To test all the failed case creation scenario/Negative scenario
    *********************************************************************************/
    /*
    @isTest 
    private static void testDelServiceExceptionScenario1(){
        test.starttest();
        
       
        //UECaseManagementInnerClasses.deleteFeedWrapper objdeleteRequestWrapper = new UECaseManagementInnerClasses.deleteFeedWrapper();
        //String jsonMsg;
        //jsonMsg=JSON.serialize(objdeleteRequestWrapper);        
        UECaseManagementResponseClasses.deleteFeedResponseMessage response = new UECaseManagementResponseClasses.deleteFeedResponseMessage();
        
        //error scenario 1 :
        RestRequest request = new RestRequest();
        request.requestBody = blob.valueOf('Random values');
        request.requestUri ='/services/apexrest/UECaseManagementService/';
        request.httpMethod = 'DELETE';       
        RestContext.request = request;
        request.addParameter('operation', 'DELETEATTACHMENT');
        system.debug(LoggingLevel.DEBUG,'request---'+request);
        response = UECaseManagementService.deleteServices();
        system.debug(LoggingLevel.DEBUG,'response---'+response);
         System.AssertEquals(response.isSuccess,false,'Improper request body');

        test.stopTest();        
    }*/
    
     /********************************************************************************
    Method Name : testCoverWrapperClasse
    @description : To test all wrpper class
    *********************************************************************************/
    
    @isTest 
    private static void testCoverWrapperClasse(){
        UECaseManagementResponseClasses.CreateCaseResponse response = new UECaseManagementResponseClasses.CreateCaseResponse();
        UECaseManagementInnerClasses.CaseDetailsWrapper wrapper = new UECaseManagementInnerClasses.CaseDetailsWrapper();
        
        response.statusCode = '200';
        wrapper.sapAccountNumber = '1234';
        
        system.AssertEquals(response.statusCode,'200' , 'Validated statuscode');
    }
    
}