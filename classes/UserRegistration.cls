/**********************************************************************************
Class Name : UserRegistration
Description : This is a REST Resource used by My TR for UserOnboarding . 
Functionalities : Create contact and Contact SSD record as and when required during
self registration process
***********************************************************************************
Modification Details:
Date                    Description                           Owner
22/05/2019              Created                               Akshay Kakkar
22/05/2019              Resolving Duplicity Issue             Akshay Kakkar
*********************************************************************************/
@RestResource(urlMapping = '/userRegister/*')
global with sharing class UserRegistration {
    
    /**********************************************************************
    Method Name : postServices
    Description : Insert Contact
    Parameters : Contact Details 
    Return Type:  Contact ID
    ***********************************************************************/
    @HttpPost
    global static String doPost(String sapContactID, String sapAccountNumber, String sapContactType, String emailId, 
                                                String role, String firstName, String lastName) {
        RestRequest req = RestContext.request;
        String json;
        
        try { 
            //Verify if SAPAccountNumber 
            if(String.isNotBlank(sapAccountNumber) && String.isNOtBlank(sapContactID)){
            
                //Retrieve the account id
                List<Account> currentAccount = [Select id, name from Account where SAPAccountNumber__c = :sapAccountNumber Limit 1];
                
                if (currentAccount != null && currentAccount.size() > 0) {
                    
                    List<Contact> currentContact = [SELECT Id, Name,MyTR_DBRole__c  FROM Contact WHERE AccountId =: currentAccount[0].id
                                                    AND SAP_Contact_ID__c =: sapContactID Limit 1];
                    
                    //If existing record is found
                    if(currentContact != null  &&  currentContact.size() > 0){  
                    
                        if(role != null && role != '' && currentContact[0].MyTR_DBRole__c != role){
                            currentContact[0].MyTR_DBRole__c = role;
                            update currentContact[0];
                        }                     
                        return json = '{ Contact Id ' + currentContact[0].Id + '}';
                    }else{  
                        //Validate if required values are available to create contact
                        if(String.isNotBlank(lastName) && String.isNotBlank(emailId) && String.isNotBlank(firstName) 
                                                && String.isNotBlank(role)){
                            
                            Contact newContact = new Contact();
                            newContact.accountId = currentAccount[0].id;
                            newContact.FirstName = firstName;
                            newContact.LastName = lastName;
                            newContact.Email = emailId;                     
                            newContact.MyTR_DBRole__c = role;
                            newContact.SAP_Contact_ID__c = sapContactID;
                            newContact.RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('S2E').getRecordTypeId();
                            insert newContact;
                            
                            return json = ' { Contact Id' + newContact.id + ' }';
                        }else{
                            return json = 'Error: One of the values first name/last name/role is missing  ';
                        }
                    }
                    
                }else{
                   return json = 'Exception  : SFDC Account does not exist ';    
                }
            }else{
                return json = 'Exception  : Either SAP Account number or SAP Contact ID is missing ';
            }//end of account number check
        }catch(Exception ex) {
            system.debug(ex.getStackTraceString());
            system.debug('  Json' + ex.getMessage());
            return ex.getMessage();
        }
        
    }//end of doPost
    
}