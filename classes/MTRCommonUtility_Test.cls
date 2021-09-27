/********************************************************************************
Class Name : MTRCommonUtility_Test
@description : Test Class of MTRCommonUtility
********************************************************************************
Modification Details:
Date                    Description                     Owner
06/08/2021              Created                         Deepthi KB
*********************************************************************************/

@isTest
private class MTRCommonUtility_Test{
    /********************************************************************************
    Method Name : setup
    @description : To create test data 
    *********************************************************************************/
    @testSetup 
     static void setup(){
     Account objAcc = new Account();
     objAcc.Name='Test';
     objAcc.AccountNumber ='12345';
     objAcc.Sales_Org__c = 'GLI';
     objAcc.BU_Region__c='US';
     objAcc.Bu_Segment__c='Professional Legal';
     objAcc.SAPAccountNumber__c ='123456';
     insert objAcc;
     
     Source_System_Detail__c objLCRMSSD = new Source_System_Detail__c();
     objLCRMSSD.Account_name__c = objAcc.id;
     objLCRMSSD.Name = 'TestLcrmAccName';
     objLCRMSSD.Source_System_Account_Number__c = '123456';
     objLCRMSSD.Source_System_Name__c='ENTWRP';
     objLCRMSSD.Account_Name__c = objAcc.id;
     insert objLCRMSSD;
      
      Contact objContact = new contact();
      objContact.AccountId = objAcc.id;
      objContact.FirstName = 'TestFirstName';
      objContact.LastName = 'TestLastName';
      objContact.Email = 'Test@gmail.com';
      Insert objContact;
      
      List<Case> allCases = new List<Case>();
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
         
      allCases.add(riskCase);
      insert allCases;
        
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
    Method Name : testDataforAemCase
    @description : TO create sample wrapper class(for test purpose), using test setup data(SSD record, contact record, product record)
    @return UECaseManagementInnerClasses.CaseDetailsWrapper
    *********************************************************************************/
    public static UECaseManagementInnerClasses.CaseDetailsWrapper testDataforAemCase(){
        
        Source_System_Detail__c objSSD = [select id,Account_name__c,Source_System_Account_Number__c from 
                                          Source_System_Detail__c where Source_System_Account_Number__c = '123456' limit 1];                                                
        Contact objContact = [select id,Email,Accountid from Contact where FirstName = 'TestFirstName' limit 1];
                        
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
    Method Name : test_UsersettingsEmailconfig
    @description : To test user settings method and 
                   Email configuration method from MTRCommonutility Class
    *********************************************************************************/
    
    @isTest 
    private static void testUsersettingsEmailconfig(){
        list<id> lstMTRCaseId = new list<ID>();
        test.starttest();
        
        //TestDataforAemCase() method is used to create test data for wrapper class
        UECaseManagementInnerClasses.caseDetailsWrapper objCaseAEM = TestDataforAemCase();            
        String jsonMsg;
        
        //TestSampleRestRequest() method is used to create Sample request
        RestRequest request;
        UECaseManagementResponseClasses.CreateCaseResponse response = new  UECaseManagementResponseClasses.CreateCaseResponse();
        
        // test scenario - LEGAL successfull case creation
        jsonMsg=JSON.serialize(objCaseAEM);
        request = TestSampleRestRequest(jsonMsg);
        request.addParameter('business', 'LEGAL');        
        response = UECaseManagementService.postServices();
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
        request2.addParameter('reasonid', 'l3Reason3001');
        response = UECaseManagementService.postServices();
                        
        test.stopTest();        
    }
     /**********************************************
    Method Name : testSampleRestRequest1
    @description : to test Request for MTRUserManagementService
    @param json
    @return RestRequest 
    **********************************************/
     public static RestRequest testSampleRestRequest1 (string json){
        RestRequest request = new RestRequest();
        request.requestBody = Blob.valueof(json);
        request.requestUri ='/services/apexrest/MTRUserManagementService/';
        request.httpMethod = 'POST';       
        RestContext.request = request;
        request.addParameter('operation', 'CREATECONTACT');       
        return request;
    }
    /**********************************************************************
    Method Name : gLICreateCase
    @description : To validate Source while creating Contact
    @param
    *************************************************************************/
    @isTest static void gLICreateCase(){
        Test.startTest();
        
        MTRUMSAPIClass.UserDetailsWrapper userReq = new MTRUMSAPIClass.UserDetailsWrapper();
        MTRUserManagementService.ResponseMessage response = new MTRUserManagementService.ResponseMessage();
        
         //New Contact
        userReq = new MTRUMSAPIClass.UserDetailsWrapper();
        userReq.SAPAccountNumber = '123456';
        userReq.sapContactID = '987656';
        userReq.Email='test.newuser@mailinator.com';
        userReq.FirstName='Testfirstname'; 
        userReq.LastName='Userlastname';
        userReq.isGLIAdminContact=false;
        userReq.s2EContactRole ='Global User';
                
        String jsonMsg = JSON.serialize(userReq); 
         
        RestRequest request = testSampleRestRequest1(jsonMsg);        
        request.addParameter('BusinessUnit','LEGAL');
        response = MTRUserManagementService.postServices();
        system.assert(response.primaryContactId!=null,'check primaryContactId');

        test.stopTest();        
    }
    
    }