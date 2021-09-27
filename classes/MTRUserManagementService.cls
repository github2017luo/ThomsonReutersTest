/********************************************************************************
Class Name : MTRUserManagementService
@description : This is a REST Resource used by My TR for user management. 
              This class will cater to all services needed for user management.
Functionalities : Create Contacts
Parameters : Business ( LATAM/Legal/Tax), 
            Operation (CreateContacts)
********************************************************************************
Modification Details:
Date                   Description              Owner                       Jira#
27/08/2019             Created                  Deepika Motamarri
29/07/2020             Updated the              Deepthi KB                   DUE-4054
                       logic for GLI                                    
03/06/2021             Removed Mandatory        Deepika Motamarri           DUE-11221
                       check on SAP Contact ID   
21/07/2021             Updated SOQL to filter   Pragati Goyal                DUE-11998
                       contact ssd and account 
                       ssd based on SourceName  
13/08/2021             Updated the Recordtype   Saravana kumar Balasubramaniam    DUE-12065
                       value for GLI             
*********************************************************************************/
@RestResource(urlMapping='/MTRUserManagementService/*')
global without sharing class MTRUserManagementService{ 
        
    /********************************************************************************
    Method Name : postServices
    @description : Create Contact Details
    @param : null
    @return : ResponseMessage 
    *********************************************************************************/
    //Initialize variables
    
    global static MTRUMSAPIClass.UserDetailsWrapper requestDetails;
    global static ResponseMessage objSuccessError;
    global static String businessUnit;
        
    @HttpPost
    global static ResponseMessage postServices(){
        //Retrieve request parameters
        objSuccessError = new ResponseMessage();
        //Contact contact = new Contact();
                
        try {
            RestRequest req = RestContext.request;
            Map<String,String> requestParameters = req.params;
            if((requestParameters.get('operation')=='')||(requestParameters.get('operation')!='CREATECONTACT')){
                return createResponse(NULL,NULL,MTRCommonUtility.INVALID_OPERATION);   
            }
            
            if(requestParameters.get('BusinessUnit') != ''){
                businessUnit = requestParameters.get('BusinessUnit');
            }
            
            switch on (requestParameters.get('operation')){
                when 'CREATECONTACT' {
                    //Execute functionality based on the system name
                    if(MTRCommonUtility.userSettings('SYSTEM',requestParameters.get('BusinessUnit')) == ''){
                        return createResponse(NULL,NULL,MTRCommonUtility.BUSINESS_UNIT_NOT_CONFIG);
                    }//End of Execute functionality based on the system name
                    
                    ResponseMessage validateRequest = validateRequestDetails();
                    if(validateRequest.errorMessage != NULL){
                        return validateRequest;
                    }
                    
                    // Switch functionality on System value
                    switch on MTRCommonUtility.userSettings('SYSTEM',requestParameters.get('BusinessUnit')){
                        when 'S2E' {
                            //Put S2E logic
                            ResponseMessage s2eResponse = getS2EContact();
                            system.debug(LoggingLevel.INFO,'s2eResponse....'+s2eResponse);
                            return s2eResponse;
                        }//end of S2E switch
                                    
                        when 'GLI'{
                            //Put GLI logic
                            ResponseMessage gliResponse = getGLIContact();
                            system.debug(LoggingLevel.INFO,'gliResponse....'+gliResponse);
                            return gliResponse;
                        }//end of GLI switch
                                
                    }//End of Switch
                }  //End of CREATECONTACT switch case
            }//end of Operation switch
        }catch (Exception ex) {
             //Log the error 
             ApplicationLogUtility.logException('MY TR' , 'MTRUserManagementService' , 'postServices' , ex);
             return createResponse(NULL,NULL,ex.getStackTraceString());  
        }
        return createResponse(NULL,NULL,NULL);
    }//end of postServices
    /*********************************
    Method Name:validateRequestDetails
    @description : Validates the request details
    @param: User/contact Details 
    @return : MTRUMSAPIClass.ResponseMessage
    **********************************/
    global static ResponseMessage validateRequestDetails(){
        //Retrieve the Request Details
        requestDetails = (MTRUMSAPIClass.UserDetailsWrapper)System.JSON.deserialize
                        (RestContext.request.requestBody.tostring(),MTRUMSAPIClass.UserDetailsWrapper.class);                
                    
        //Initialize Boolean value
        if (requestDetails.isGLIAdminContact == NULL){
            requestDetails.isGLIAdminContact = FALSE;
        }
        //If the details are obtained in proper format
                    
        if(requestDetails == null){
            return createResponse(NULL,NULL,MTRCommonUtility.IMPROPER_REQUEST_FORMAT ); 
        }   

        //check if account number & SAPContactid has been provided else send error
        if(String.isBlank(requestDetails.sapAccountNumber)){
            return createResponse(NULL,NULL,MTRCommonUtility.SAP_ACCOUNT_NOT_PASSED);
        }
        
         if (String.isBlank(requestDetails.lastName) || String.isBlank(requestDetails.email) 
                    || String.isBlank(requestDetails.firstName)) {
            
            return createResponse(NULL,NULL,MTRCommonUtility.OTHER_VALUES_NOT_PASSED);
        }
        return createResponse(NULL,NULL,NULL);
    
    } // end of validation method

    /**********************************************
    Method Name : getS2EContact
    @description : Retrieves or creates S2E Contact
    @param : Contact Details 
    @return :  MTRUMSAPIClass.ResponseMessage 
    **********************************************/
    global static ResponseMessage getS2EContact(){
        
        //Retrieve the account id
        system.debug(LoggingLevel.INFO,'s2e entered');
        system.debug(LoggingLevel.INFO,'Hello Value 1....'+requestDetails.sAPAccountNumber);
        List<Account> currentAccount = [Select id, name from Account where SAPAccountNumber__c = :requestDetails.sAPAccountNumber with SECURITY_ENFORCED Limit 1];
         system.debug(LoggingLevel.INFO,'Hello Value 2....'+currentAccount);               
        //Validate if SFDC account is missing or not
        if (currentAccount.isEmpty()) {
            //Return the error that account related to the passed SAP account number does not exist
            return createResponse(NULL,NULL,MTRCommonUtility.ACCOUNT_MISSING);
        }    
                      
        //Retrieve all the contacts based on the email ID
        Map<String,String> s2EContacts = new Map<String,String>();
        Contact primaryContact;
                         
        //Iterate over the list of S2E contacts based on email ID to build the map
        for(Contact currentContact : [SELECT Id, Name, MyTR_DBRole__c,email , SAP_Contact_ID__c  FROM Contact 
                                        WHERE email =: requestDetails.email AND SAP_Account_Number__c =: requestDetails.sAPAccountNumber 
                                        AND SAP_Contact_ID__c!=null]){
                //Generate the map of S2E contacts
                s2EContacts.put(currentContact.SAP_Contact_ID__c,currentContact.ID);
                if(currentContact.SAP_Contact_ID__c == requestDetails.sapContactID ){
                    primaryContact = currentContact; 
                }
        }
           system.debug(LoggingLevel.INFO,'Hello Value 3....'+s2EContacts);  
        //If the contact for the passed SAP contact id exists
        if(primaryContact != null && primaryContact.MyTR_DBRole__c != requestDetails.s2EContactRole 
                        && Schema.sObjectType.Contact.isUpdateable()){             
            //Update the existing contact  
                primaryContact.MyTR_DBRole__c = requestDetails.s2EContactRole;
                update primaryContact ;
            
            return createResponse(primaryContact.id,s2EContacts,NULL);
        }
                //Validate if all required details are passed
       
        Contact newContact = new Contact();
        newContact.accountId = currentAccount[0].id;
        newContact.firstName = requestDetails.firstName;
        newContact.lastName = requestDetails.lastName;
        newContact.email = requestDetails.email;                     
        newContact.MyTR_DBRole__c = requestDetails.s2EContactRole;
        newContact.SAP_Contact_ID__c = requestDetails.sapContactID;
        newContact.RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(System.label.S2E_CONTACT).getRecordTypeId();
        if(Schema.sObjectType.Contact.isCreateable()){
            insert newContact;
        }
                                                        
        //Add the newly created contact to the S2E contact list
        s2EContacts.put(requestDetails.sapContactID, newContact.ID);  
        system.debug(LoggingLevel.INFO,'Deepika check...'+s2EContacts);
        //Return the success message with newly created contact
        return createResponse(newContact.id,s2EContacts,NULL);
        
    }//end of getS2EContact

     /**********************************************
    Method Name : getGLIContact
    @description : Retrieves or creates GLI Contact
    @param : Contact Details 
    @return :  MTRUMSAPIClass.ResponseMessage 
    **********************************************/
   global static ResponseMessage getGLIContact(){
        try{
            String sourceName;
            
            //fetching the sourceName from the utility class
            sourceName = MTRCommonUtility.userSettings('SOURCENAME',businessUnit);
             
            //Check if the contactSSD  Exist on the basis of SapContactId(LCRM_Contact_ID__c) and SapAccountNumber
            //Updated the SOQL to search contact ssd on LCRM_Source_Contact_Id__c
            //Updated the SOQL to search and filter the contact ssd records based on the sourceName(LCRM_Legacy_Contact_Type__c)
            if(!String.isBlank(requestDetails.sapContactID)) {
                List<LCRM_Contact_SSD__c> existContactSSD=[SELECT id, LCRM_Contact__c, LCRM_Account_SSD__c FROM LCRM_Contact_SSD__c
                                                             WHERE LCRM_Source_Contact_Id__c=:requestDetails.sapContactID 
                                                            AND LCRM_SAP_Account_Number__c=:requestDetails.SAPAccountNumber 
                                                            AND LCRM_Legacy_Contact_Type__c =:sourceName with SECURITY_ENFORCED Limit 1];
    
                if(!existContactSSD.IsEmpty()){
                    // if contactssd exists with given SAPaccountNumber & sapContactid, return GLI Contactid
                    return createResponse(existContactSSD[0].LCRM_Contact__c,NULL,NULL);
                }
             }
             
            //Check if GLI Contact exists else create a new contact on the Account given SAPaccountNumber
            //Updated the SOQL to search and filter the account ssd records based on the sourceName(Source_System_Name__c)                            
            List<Source_System_Detail__c> listSSDAccount = [Select id, name, Account_Name__c from Source_System_Detail__c 
                                                                    where Source_System_Account_Number__c =:requestDetails.sAPAccountNumber 
                                                                    AND Source_System_Name__c =:sourceName with SECURITY_ENFORCED LIMIT 1];
            
            if(listSSDAccount.isEmpty()){
                
                return createResponse(NULL,NULL,MTRCommonUtility.SSD_NOT_AVAILABLE);
            }  
           
            System.debug(LoggingLevel.INFO,'Request Details: '+requestDetails);
            List<Contact> existingContact = [SELECT Id, Name,Account.Id,UE_CSP_Contact__c FROM Contact WHERE Account.Id =: listSSDAccount[0].Account_Name__c
                                            AND lastName =: requestDetails.lastName  AND firstName =: requestDetails.firstName 
                                                        AND email =: requestDetails.email Limit 1];

            system.debug(LoggingLevel.INFO,'COntact retrieved...'+existingContact);
            //Verify if contact exists
            if (!existingContact.isEmpty()) {
                    existingContact[0].UE_CSP_Contact__c = true;
                    if(Schema.sObjectType.Contact.isUpdateable()){
                        update existingContact[0];
                    }
                    return createResponse(existingContact[0].id,NULL,NULL);
            }
                        
            //Creating a  GLI Contact 
            Contact newContact = new Contact();
            newContact.AccountId = listSSDAccount[0].Account_Name__c;
            newContact.firstName = requestDetails.firstName;
            newContact.lastName = requestDetails.lastName;
            newContact.email = requestDetails.email;
            newContact.UE_CSP_Contact__c = true;
            newContact.RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(System.label.CREATE_NEW_CONTACT).getRecordTypeId();
            insert newContact;

            return createResponse(newContact.id,NULL,NULL);                                             
              
        } catch (Exception ex) {
                ApplicationLogUtility.logException('MY TR' , 'MTRUserManagementService' , 'postServices' , ex);
            return createResponse(NULL,NULL,ex.getStackTraceString());  
        }
       
    }//end of getGLIContact
     /**********************************************
    Method Name : createContact
    @description : Creates a contact record
    @param primaryContactId
    @param s2eContactID
    @param errorMsg
    @return MTRUMSAPIClass.ResponseMessage 
    **********************************************/
    global static ResponseMessage createResponse(String primaryContactId,Map<String,String> s2eContactID,String errorMsg){
                                                         
        //MTRUMSAPIClass.ResponseMessage objSuccessError = new MTRUMSAPIClass.ResponseMessage();
        if(ErrorMsg == null){
            objSuccessError.statusCode = '200';
            objSuccessError.isSuccess = true;
            objSuccessError.primaryContactId = primaryContactId;
            objSuccessError.s2eContactID = s2eContactID;
          
            if(s2eContactID!=null){
                objSuccessError.contactType = 'S2E';
            }else{
                objSuccessError.contactType = 'GLI';
            }
            
        }else{
            objSuccessError.statusCode = '400';
            objSuccessError.isSuccess = false;
            objSuccessError.errorMessage = errorMsg;
        } 
            
        system.debug(LoggingLevel.ERROR,'objSuccessError---'+objSuccessError);
        return objSuccessError;
    }
    //Inner Class Declarations
       /********************************************************************************
   @description : Defines the response structure of the service
                and also contains methods to populate the values 
                for success and error scenarios
   *********************************************************************************/ 
    global class ResponseMessage{
        public Boolean isSuccess;
        public string primaryContactId;
        public Map<String,String> s2eContactID;
        /** @description statuscode , @param get;set; ,@return string **/
        public string statusCode{get;set;}
        /** @description errorMessage , @param get;set; ,@return string **/
        public string errorMessage{get;set;}

       /** @description contact type */
       public string contactType{get;set;}
    }

}//end of MTRUserManagementServices