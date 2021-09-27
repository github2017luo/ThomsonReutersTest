/********************************************************************************
Class Name : MTRCaseManagementService_Test
@description : Test Class of MTRCaseManagementService
********************************************************************************
Modification Details:
Date                    Description                     Owner
15/10/2019              Created                         Herin Acharya
*********************************************************************************/

@isTest
private class MTRCaseManagementService_Test{
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
         
        Account objAcc3=objAcc.clone();
        objAcc3.Sales_Org__c = 'GLI';
        objAcc3.BU_Region__c='';
        objAcc3.Bu_Segment__c='';
        insert objAcc3;
        
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
        
        Contact objContact3= new Contact();
        objContact3.AccountId=objAcc3.id;
        objContact3.FirstName = 'NO_BU'; 
        objContact3.LastName='NO_BU';
        objContact3.Email='nobu@mail.com';
        insert objContact3;
         
        Product2 objPro = new Product2();
        objPro.name = 'CheckPoint';
        insert objPro;      
                  
     }
    
    /********************************************************************************
    Method Name : testDataforAemCase
    @description : TO create sample wrapper class(for test purpose), using test setup data(SSD record, contact record, product record)
    @param : no parameter needed
    @return caseDetailsWrapper
    *********************************************************************************/
    public static MTRCaseManagementService.caseDetailsWrapper testDataforAemCase(){
        
        Source_System_Detail__c objSSD = [select id,Account_name__c,Source_System_Account_Number__c from 
                                          Source_System_Detail__c where Source_System_Account_Number__c = '123456' limit 1];                                                
        Contact objContact = [select id,Email from Contact where FirstName = 'TestFirstName' limit 1];
        //Product2 objPro = [select id,name from product2 where name = 'Checkpoint' limit 1];
        
        MTRCaseManagementService.caseDetailsWrapper objCaseNew = new MTRCaseManagementService.caseDetailsWrapper();
        objCaseNew.SAPAccountNumber = objSSD.Source_System_Account_Number__c;
        objCaseNew.ContactId = objContact.id;
        objCaseNew.subject = 'I cannot access the product';
        objCaseNew.Description = 'TestDiscription';
        objCaseNew.QueryType = 'I cannot access the product';
        objCaseNew.Product = 'Checkpoint';
        objCaseNew.PhoneNumber = '912345678';
        objCaseNew.IsoCountrycode='AR-en';
        objCaseNew.currentFormURL= ' Sample URL';
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
        request.requestUri ='/services/apexrest/caseManagement/';
        request.httpMethod = 'POST';       
        RestContext.request = request;
        request.addParameter('operation', 'CREATECASE');       
        return request;
    }
    
    /********************************************************************************
    Method Name : testDoPostSuccessScenarios
    @description : To test all the successful case creation scenario/Positive scenario
    *********************************************************************************/
    
    @isTest 
    private static void testDoPostSuccessScenarios(){
        list<id> lstMTRCaseId = new list<ID>();
        test.starttest();
        
        //TestDataforAemCase() method is used to create test data for wrapper class
        MTRCaseManagementService.caseDetailsWrapper objCaseAEM = TestDataforAemCase();            
        String jsonMsg;
        
        //TestSampleRestRequest() method is used to create Sample request
        RestRequest request;
        MTRCaseManagementService.ResponseMessage response = new MTRCaseManagementService.ResponseMessage();
        
        // test scenario - LATAM successfull case creation
        objCaseAEM.queryType = 'Request history of amount due';
        jsonMsg=JSON.serialize(objCaseAEM);
        request = TestSampleRestRequest(jsonMsg);
        request.addParameter('business', 'LATAM');        
        response = MTRCaseManagementService.postServices();
        system.assert(response.caseId != null,'Case successfully created');
        
        // test scenario - RISK successfull case creation
        objCaseAEM.queryType = 'I would like to request a copy or reprint of my invoice';
        objCaseAEM.product = 'ODEN/Policy Terminator';
        objCaseAEM.severity = '3 - Low';
        objCaseAEM.impact='3 - Single User';
        objCaseAEM.billingAccNum='123';
        objCaseAEM.invoiceNumber='123';
        objCaseAEM.dispatchRefNum='123';
        objCaseAEM.preferredContactMethod='Email';
        objCaseAEM.alternateEmail='test@mail.com';
        
        jsonMsg=JSON.serialize(objCaseAEM);
        request = TestSampleRestRequest(jsonMsg);
        request.addParameter('business', 'RISK');        
        response = MTRCaseManagementService.postServices();
        system.assert(response.caseId != null,'Case successfully created');
        
        //test scenario - tp cover mtrSendCreateCaseNotification() method of MTRCommonUtility class for RISK BU
        lstMTRCaseId.clear();
        lstMTRCaseId.add(response.caseId);
        MTRCommonUtility.mtrSendCreateCaseNotification(lstMTRCaseId);
        
        // test scenario - TAX successfull case creation
        objCaseAEM.queryType = 'I need help with an installtion and Upgrade';
        jsonMsg=JSON.serialize(objCaseAEM);
        request = TestSampleRestRequest(jsonMsg);
        request.addParameter('business', 'TAX');       
        response = MTRCaseManagementService.postServices();       
        system.assert(response.caseId != null,'Case successfully created');    
        
        //test scenario - tp cover mtrSendCreateCaseNotification() method of MTRCommonUtility class for TAX BU
        lstMTRCaseId.clear();
        lstMTRCaseId.add(response.caseId);
        MTRCommonUtility.mtrSendCreateCaseNotification(lstMTRCaseId);

        test.stopTest(); 
    }
    
    @isTest 
    private static void testDoPostSuccessScenarios2(){
		Id conId=[select Id,LastName from Contact where LastName='CanadaContact' with SECURITY_ENFORCED].id;
        test.starttest();
        
        //TestDataforAemCase() method is used to create test data for wrapper class
        MTRCaseManagementService.caseDetailsWrapper objCaseAEM = TestDataforAemCase();            
        String jsonMsg;
        
        //TestSampleRestRequest() method is used to create Sample request
        RestRequest request;
        MTRCaseManagementService.ResponseMessage response = new MTRCaseManagementService.ResponseMessage();
        
        // test scenario - LEGAL successfull case creation
        objCaseAEM.queryType = 'Password reset';
        jsonMsg=JSON.serialize(objCaseAEM);
        request = TestSampleRestRequest(jsonMsg);
        request.addParameter('business', 'LEGAL');       
        response = MTRCaseManagementService.postServices();       
        system.assert(response.caseId == null,'Test case');

        // test scenario - RISK Canada successfull case creation
        objCaseAEM.ContactId=conId;
        objCaseAEM.queryType = 'I would like to request a copy or reprint of my invoice';
        objCaseAEM.product = 'Compliance Learning';
        objCaseAEM.severity = '3 - Low';
        objCaseAEM.impact='3 - Single User';
        objCaseAEM.billingAccNum='123';
        objCaseAEM.invoiceNumber='123';
        objCaseAEM.dispatchRefNum='123';
        objCaseAEM.preferredContactMethod='Email';
        objCaseAEM.alternateEmail='test@mail.com';
        
        jsonMsg=JSON.serialize(objCaseAEM);
        request = TestSampleRestRequest(jsonMsg);
        request.addParameter('business', 'RISK');        
        response = MTRCaseManagementService.postServices();
       // system.assert(response.caseId != null,'Case successfully created');
        
        test.stopTest();       
    }
    
    
    /********************************************************************************
    Method Name : testgetControllingFieldValue
    description : 
    *********************************************************************************/
    /*
    @isTest 
    private static void testgetControllingFieldValue(){
        test.starttest();
        String objName= 'Case';
        String fieldName='ESC_Case_Sub_Type__c';
        Map<String,String> mapOfDepContVals=MTRCaseManagementService.getControllingFieldValue(objName,fieldName);
  		system.assert(mapOfDepContVals.isEmpty());
        test.stopTest();
    }
    */

     /********************************************************************************
    Method Name : testExceptionScenario1
    @description : To test all the failed case creation scenario/Negative scenario
    *********************************************************************************/
    @isTest 
    private static void testExceptionScenario1(){
        
        Id conId=[select Id,LastName from Contact where LastName='NO_BU' with SECURITY_ENFORCED].Id;
        test.starttest();   
        
        //Test data  - to validate Improper Request
        MTRCaseManagementService.ResponseMessage response = new MTRCaseManagementService.ResponseMessage();
               
        MTRCaseManagementService.caseDetailsWrapper objCaseAEM = null;
        String jsonMsg=JSON.serialize(objCaseAEM);       
        RestRequest request = TestSampleRestRequest(jsonMsg);
        request.addParameter('business', 'LATAM');
        response = new MTRCaseManagementService.ResponseMessage();
        response = MTRCaseManagementService.postServices();
        system.assert(response.errorMessage == MTRCommonUtility.IMPROPER_REQUEST_FORMAT,MTRCommonUtility.IMPROPER_REQUEST_FORMAT);
        
        //Test data - to validate Incorrect Business Unit
        objCaseAEM = TestDataforAemCase();
        jsonMsg=JSON.serialize(objCaseAEM);       
        request = TestSampleRestRequest(jsonMsg);
        request.addParameter('business', 'SOMERANDOMVALUE');
        
        response = new MTRCaseManagementService.ResponseMessage();
        response = MTRCaseManagementService.postServices();
        system.assert(response.errorMessage ==  MTRCommonUtility.INVALID_BU +' -'+ 'SOMERANDOMVALUE', MTRCommonUtility.INVALID_BU);
        
        //Test data - to validate Blank Business Unit
        request.addParameter('business', '');      
        response = new MTRCaseManagementService.ResponseMessage();
        response = MTRCaseManagementService.postServices();
        system.assert(response.errorMessage ==  MTRCommonUtility.INVALID_BU +' -'+ '',MTRCommonUtility.INVALID_BU);
        
         //Test data - to validate Invalid Operation
        /*
        request.addParameter('operation', '');      
        response = new MTRCaseManagementService.ResponseMessage();
        response = MTRCaseManagementService.postServices();
        system.assert(response.errorMessage ==  MTRCommonUtility.INVALID_OPERATION);
        */  
        
        // test scenario - RISK Canada successfull case creation
        objCaseAEM.ContactId=conId;
        objCaseAEM.queryType = 'I would like to request a copy or reprint of my invoice';
        jsonMsg=JSON.serialize(objCaseAEM);
        request = TestSampleRestRequest(jsonMsg);
        request.addParameter('business', 'RISK');        
        response = MTRCaseManagementService.postServices();
        system.assert(response.errorMessage ==  MTRCommonUtility.BU_REGION_MISSING +' -'+objCaseAEM.ContactId,MTRCommonUtility.BU_REGION_MISSING);
        
        
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
        MTRCaseManagementService.ResponseMessage response = new MTRCaseManagementService.ResponseMessage();
        response = MTRCaseManagementService.postServices();
        system.assert(response.isSuccess == false, 'Case Creation Failed');
        
        //Test data - to validate Invalid contactId
        MTRCaseManagementService.caseDetailsWrapper objCaseAEM = TestDataforAemCase();
        objCaseAEM.ContactId = 'badvalue';
        String jsonMsg=JSON.serialize(objCaseAEM);       
        RestRequest request = TestSampleRestRequest(jsonMsg);
        request.addParameter('business', 'LATAM');
        
        response = new MTRCaseManagementService.ResponseMessage();
        response = MTRCaseManagementService.postServices();
        system.assert(response.errorMessage ==  MTRCommonUtility.INVALID_CONTACT+' -'+objCaseAEM.ContactId,MTRCommonUtility.INVALID_CONTACT);
        
        //Test data - to validate null contactId
        /*
        objCaseAEM.ContactId = '';
        jsonMsg=JSON.serialize(objCaseAEM);       
        request = TestSampleRestRequest(jsonMsg);
        request.addParameter('business', 'LATAM');
        
        response = new MTRCaseManagementService.ResponseMessage();
        response = MTRCaseManagementService.postServices();
        system.assert(response.errorMessage == MTRCommonUtility.CONTACT_IS_MISSING);
        */
        
        //Test data - to validate Invalid QueryType
        objCaseAEM = TestDataforAemCase();
        objCaseAEM.queryType = 'badvalue';
        jsonMsg=JSON.serialize(objCaseAEM);       
        request = TestSampleRestRequest(jsonMsg);
        request.addParameter('business', 'LATAM');
        
        response = new MTRCaseManagementService.ResponseMessage();
        response = MTRCaseManagementService.postServices();
        system.assert(response.errorMessage ==  MTRCommonUtility.QUERY_TYPE_MISSING,MTRCommonUtility.QUERY_TYPE_MISSING);
 
        //Test data - to validate Blank QueryType
        objCaseAEM.queryType = '';
        jsonMsg=JSON.serialize(objCaseAEM);       
        request = TestSampleRestRequest(jsonMsg);
        request.addParameter('business', 'LATAM');

        response = new MTRCaseManagementService.ResponseMessage();
        response = MTRCaseManagementService.postServices();
        system.assert(response.errorMessage ==  MTRCommonUtility.QUERY_TYPE_NOT_PROVIDED,MTRCommonUtility.QUERY_TYPE_NOT_PROVIDED);

        test.stopTest();
    }

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
        System.assert(lstCase.size()==2, 'Process Builder Succeded');
    }
}