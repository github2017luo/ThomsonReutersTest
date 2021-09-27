/********************************************************************************
Class Name : MTRUserManagementServiceTest
@description : Test Class of MTRUserManagementService
********************************************************************************
Modification Details:
Date                    Description                     Owner
20/09/2019              Created                         Deepthi/Deepika
29/07/2020             Updated the             Deepthi KB                   DUE-4054
                       logic for GLI
*********************************************************************************/

@isTest
public class MTRUserManagementServiceTest {
    // setup method : To create test data 
     @testSetup 
    static void setup(){
        Test.startTest();
              
        //S2E data
        Account s2EAccount = new Account(Name='s2EAccount',SAPAccountNumber__c='12345');
        insert s2EAccount ;
        
        Contact s2EContact = new Contact(FirstName='Test',LastName='User',Email='test.user@mailinator.com',
                                           SAP_Contact_ID__c='987654',MyTR_DBRole__c='Billing Admin',Accountid=s2EAccount.id);
        insert s2EContact;
        
        //GLI data
        Account gLIAccount = new Account(Name='gLIAccount');
        insert gLIAccount ;
        Contact gLIContact = new Contact(FirstName='Test',LastName='User',Email='test.user@mailinator.com');
        insert gLIContact;
        
        //Create SSD records
        Source_System_Detail__c accSSD = new Source_System_Detail__c(Source_System_Name__c='ENTWRP',
                                         Account_name__c=gLIAccount.id,Source_System_Account_Number__c = '123456');
        insert accSSD;
        
        LCRM_Contact_SSD__c conSSD = new LCRM_Contact_SSD__c(LCRM_SAP_Account_Number__c='123456',Name='Test User',LCRM_First_Name__c='Test',
                    LCRM_Last_Name__c='User',LCRM_Email__c='test.user@mailinator.com',LCRM_Legacy_Contact_Type__c='ENTWRP',
                    LCRM_Source_Contact_ID__c='57864',LCRM_Contact_ID__c='57864',LCRM_Contact__c=gLIContact.id,LCRM_Account_SSD__c=accSSD.id); 
        insert conSSD;
        
        Source_System_Detail__c accSSD1 = new Source_System_Detail__c(Source_System_Name__c='HANA',
                                         Account_name__c=gLIAccount.id,Source_System_Account_Number__c = '123456');
        insert accSSD1;
        
        LCRM_Contact_SSD__c conSSD1 = new LCRM_Contact_SSD__c(LCRM_SAP_Account_Number__c='15677',Name='Test User',LCRM_First_Name__c='Test',
                    LCRM_Last_Name__c='User',LCRM_Email__c='test.user@mailinator.com',LCRM_Legacy_Contact_Type__c='HANA',
                    LCRM_Source_Contact_ID__c='57864',LCRM_Contact_ID__c='57864',LCRM_Contact__c=gLIContact.id,LCRM_Account_SSD__c=accSSD.id); 
        insert conSSD1; 
       
        Test.stopTest();
    }
    /**********************************************
    Method Name : testSampleRestRequest
    @description : to test Request
    @param json
    @return RestRequest 
    **********************************************/
     public static RestRequest testSampleRestRequest (string json){
        RestRequest request = new RestRequest();
        request.requestBody = Blob.valueof(json);
        request.requestUri ='/services/apexrest/MTRUserManagementService/';
        request.httpMethod = 'POST';       
        RestContext.request = request;
        request.addParameter('operation', 'CREATECONTACT');       
        return request;
    }
    
     @isTest static void s2ESuccess(){
         Test.startTest();
         
        //Existing Contact
        MTRUMSAPIClass.UserDetailsWrapper userReq = new MTRUMSAPIClass.UserDetailsWrapper();
        MTRUserManagementService.ResponseMessage response = new MTRUserManagementService.ResponseMessage();
        userReq.SAPAccountNumber = '12345';
        userReq.sapContactID = '987654';
        userReq.Email='test.user@mailinator.com';
        userReq.s2EContactRole='Global User';
        userReq.FirstName='Test'; 
        userReq.LastName='User'; 
        String jsonMsg = JSON.serialize(userReq); 
         
        RestRequest request = testSampleRestRequest(jsonMsg);        
        request.addParameter('BusinessUnit', 'LATAM');
        response = MTRUserManagementService.postServices();
        Contact conS2e=[Select id,Name,Email,SAP_Contact_ID__c ,MyTR_DBRole__c from Contact where id =: response.primaryContactId];
        System.AssertEquals(conS2e.SAP_Contact_ID__c,'987654','check the sap contact id on contact created');
        System.assert(response.primaryContactId==conS2e.id,'verify the primaryContactId');
        System.assert(response.s2eContactID!=null,'check s2eContactID'); 
                
        //New Contact
        userReq = new MTRUMSAPIClass.UserDetailsWrapper();
        userReq.SAPAccountNumber = '12345';
        userReq.sapContactID = '987656';
        userReq.Email='test.user@mailinator.com';
        userReq.s2EContactRole='Global User';
        userReq.FirstName='Test'; 
        userReq.LastName='User';
         
        jsonMsg = JSON.serialize(userReq); 
         
        request = testSampleRestRequest(jsonMsg);        
        request.addParameter('BusinessUnit', 'LATAM');
        response = MTRUserManagementService.postServices();
        Contact newconS2E=[Select id,Name,Email,SAP_Contact_ID__c ,MyTR_DBRole__c from Contact where id =: response.primaryContactId];
        System.AssertEquals(newconS2E.SAP_Contact_ID__c,'987656','verify the sapcontactid');
        System.assert(response.primaryContactId==newconS2E.id,'check primaryContactId');
        System.assert(response.s2eContactID!=null,'check s2eContactID');
   
        Test.stopTest();
   }
     @isTest static void s2EErrors(){
        Test.startTest(); 
        //Existing contact
        MTRUMSAPIClass.UserDetailsWrapper userReq = new MTRUMSAPIClass.UserDetailsWrapper();
        MTRUserManagementService.ResponseMessage response = new MTRUserManagementService.ResponseMessage();
        String jsonMsg=JSON.serialize(userReq); 
         
        RestRequest request = testSampleRestRequest(jsonMsg);        
        request.addParameter('business', 'LATAM');
        response = MTRUserManagementService.postServices();
        System.assert(response.errorMessage==MTRCommonUtility.BUSINESS_UNIT_NOT_CONFIG,'verify the businessunit');
        
        //Improper Operation value
        jsonMsg=JSON.serialize(userReq ); 
         
        request = testSampleRestRequest(jsonMsg);        
        request.addParameter('BusinessUnit', 'LATAM');
        request.addParameter('operation', '');
        response = MTRUserManagementService.postServices();
        system.assert(response.errorMessage==MTRCommonUtility.INVALID_OPERATION,'check for valid opeartion parameter');
         
        //Improper request
        request = testSampleRestRequest(jsonMsg);        
        request.addParameter('BusinessUnit', 'LATAM');
        response = MTRUserManagementService.postServices();
        System.assert(response.errorMessage!=null,'check errormessage');
        
        //Missing account details
        userReq = new MTRUMSAPIClass.UserDetailsWrapper();
        userReq.SAPAccountNumber = '123451'; 
        userReq.sapContactID = '987654';
        userReq.Email='test@tr.com';
        userReq.firstName='Test';
        userReq.lastName='User';
        jsonMsg = JSON.serialize(userReq); 
         
        request = testSampleRestRequest(jsonMsg);        
        request.addParameter('BusinessUnit', 'LATAM');
        response = MTRUserManagementService.postServices();
        system.assert(response.isSuccess == false,'verify the response is false');
        System.assert(response.errorMessage==MTRCommonUtility.ACCOUNT_MISSING,'verify if account is existing or not');
        
        //Other values not passed
        userReq = new MTRUMSAPIClass.UserDetailsWrapper();
        userReq.SAPAccountNumber = '12345';
        userReq.sapContactID = '987656';
        userReq.Email='test.user@mailinator.com';
        userReq.s2EContactRole='Global User';
        jsonMsg = JSON.serialize(userReq); 
         
        request = testSampleRestRequest(jsonMsg);        
        request.addParameter('BusinessUnit', 'LATAM');
        response = MTRUserManagementService.postServices();
        System.assert(response.errorMessage==MTRCommonUtility.OTHER_VALUES_NOT_PASSED,'check if FN,LN,email is the request'); 
        
        Test.stopTest();
   } 
    
   @isTest static void gLIErrors(){
         Test.startTest();
        //Existing contact
        MTRUMSAPIClass.UserDetailsWrapper userReq = new MTRUMSAPIClass.UserDetailsWrapper();
        MTRUserManagementService.ResponseMessage response = new MTRUserManagementService.ResponseMessage();
        
        String jsonMsg=JSON.serialize(userReq ); 
        RestRequest request = testSampleRestRequest(jsonMsg);        
        request.addParameter('business', 'TAX');
        response = MTRUserManagementService.postServices();
        System.assert(response.errorMessage==MTRCommonUtility.BUSINESS_UNIT_NOT_CONFIG,'veify businessunit');
       
        // Invalid BusinessUnit
        jsonMsg=JSON.serialize(userReq ); 
         
        request = testSampleRestRequest(jsonMsg);        
        request.addParameter('BusinessUnit', 'XYZ');
        response = MTRUserManagementService.postServices();
        System.assert(response.errorMessage==MTRCommonUtility.BUSINESS_UNIT_NOT_CONFIG,'verify businessunit configuration');

        //Missing account details, account SSD record not available or not mapped
        userReq = new MTRUMSAPIClass.UserDetailsWrapper();
        userReq.SAPAccountNumber = '123451'; 
        userReq.sapContactID = '57865';
        userReq.Email='test.user@mailinator.com';
        userReq.FirstName='Test'; 
        userReq.LastName='User';
        jsonMsg = JSON.serialize(userReq); 
         
        request = testSampleRestRequest(jsonMsg);        
        request.addParameter('BusinessUnit', 'TAX');
        response = MTRUserManagementService.postServices();
        system.debug(LoggingLevel.ERROR,'glierror .... '+response);
        system.assert(response.errorMessage==MTRCommonUtility.SSD_NOT_AVAILABLE,'check for SSD record');
        
        //Other values not passed
        userReq = new MTRUMSAPIClass.UserDetailsWrapper();
        userReq.SAPAccountNumber = '123456';
        userReq.sapContactID = '5786700';
        userReq.Email='test@tr.com';
        userReq.firstName='';
        userReq.lastName='';
        jsonMsg = JSON.serialize(userReq); 
       
        request = testSampleRestRequest(jsonMsg);        
        request.addParameter('BusinessUnit', 'TAX');
        response=MTRUserManagementService.postServices();
        system.debug(LoggingLevel.INFO,'Print response...'+response);
        system.assert(response.errorMessage==MTRCommonUtility.OTHER_VALUES_NOT_PASSED,'verify FN,LN,email parameters in the request');
        
        userReq= null;
        jsonMsg = JSON.serialize(userReq);

        request = testSampleRestRequest(jsonMsg);       
        request.addParameter('BusinessUnit', 'TAX');
        MTRUserManagementService.postServices();
       
        //catch exception
        userReq = new MTRUMSAPIClass.UserDetailsWrapper();
        userReq.SAPAccountNumber = '123456';
        userReq.sapContactID = '5786700';
        userReq.Email='test@tr.com';
        userReq.firstName='';
        userReq.lastName='';
        jsonMsg = JSON.serialize(userReq); 
       
        request = testSampleRestRequest(jsonMsg);        
        request.addParameter('BusinessUnit', 'LEGAL');
        MTRUserManagementService.postServices();
       
        Test.stopTest();
   }
    
   @isTest private static void testException(){
        
       Test.startTest();                                      
       
        MTRUserManagementService.ResponseMessage response = new MTRUserManagementService.ResponseMessage();
        response = MTRUserManagementService.postServices();
        system.assert(response.isSuccess == false,'check for exception');
        system.assert(response.errorMessage!=null,'check for errormsg');
                
        Test.stopTest();
        
    } 
    
   @isTest static void gLISuccess(){
        Test.startTest();
         
        //Online User available & return existing GLIcontact
        MTRUMSAPIClass.UserDetailsWrapper userReq = new MTRUMSAPIClass.UserDetailsWrapper();
       
        userReq.SAPAccountNumber = '123456';
        userReq.sapContactID = '57864';
        userReq.Email='test.user@mailinator.com';
        userReq.FirstName='Test'; 
        userReq.LastName='User';
        String jsonMsg = JSON.serialize(userReq); 
         
        RestRequest request = testSampleRestRequest(jsonMsg);        
        request.addParameter('BusinessUnit', 'LEGAL');
        MTRUserManagementService.ResponseMessage response = new MTRUserManagementService.ResponseMessage();
        response = MTRUserManagementService.postServices();
        
        system.debug(LoggingLevel.INFO,'Response of glisuccess...'+response);
        system.assert(response.contactType == 'GLI','verify contacttype');
        system.assert(response.primaryContactId!=null,'verify primaryContactId');

         
        //New Contact
        userReq = new MTRUMSAPIClass.UserDetailsWrapper();
        userReq.SAPAccountNumber = '12345';
        userReq.sapContactID = '987656';
        userReq.Email='test.newuser@mailinator.com';
        userReq.FirstName='Testfirstname'; 
        userReq.LastName='Userlastname';
         
        jsonMsg = JSON.serialize(userReq); 
         
        request = testSampleRestRequest(jsonMsg);        
        request.addParameter('BusinessUnit', 'LATAM');
        response = MTRUserManagementService.postServices();
        system.assert(response.isSuccess == true,'verify the isSuccess value');
        system.assert(response.primaryContactId!=null,'check primaryContactId');
       
        // existing contact ID and new admin SSD   
        userReq.SAPAccountNumber = '123456';
        userReq.sapContactID = '12121';
        userReq.Email='test.user@mailinator.com';
        userReq.FirstName='Test'; 
        userReq.LastName='User'; 
        jsonMsg = JSON.serialize(userReq);

        request = testSampleRestRequest(jsonMsg);       
        request.addParameter('BusinessUnit', 'TAX');
        response=MTRUserManagementService.postServices();
        system.assert(response.primaryContactId!=null,'check primaryContactId');
        
        //if admin contact ID available
        userReq.SAPAccountNumber = '123456';
        userReq.sapContactID = '12412';
        userReq.Email='test.user@mailinator.com';
        userReq.FirstName='Test'; 
        userReq.LastName='User'; 
        jsonMsg = JSON.serialize(userReq);
       
        request = testSampleRestRequest(jsonMsg);       
        request.addParameter('BusinessUnit', 'LEGAL');
        response=MTRUserManagementService.postServices();
        system.assert(response.primaryContactId!=null,'check primaryContactId');
       
        Test.stopTest();
        
   } 
}