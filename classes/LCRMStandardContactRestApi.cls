/* -----------------------------------------------------------------------------------------------------
CLASS NAME: LCRMStandardContactRestApi

PURPOSE : StandardContactRestApi Service is used to search contact on basis of request given by ESI team.
Request may have AccountID/Parent Account Id,Account Name,Contact FirstName,Contact lastName,Contact Email.

Created By : TCS

Date : 03/07/2017
-------------------------------------------------------------------------------------------------------*/
@RestResource(urlmapping='/LCRMStandardContactRestApi/*')
Global class LCRMStandardContactRestApi{
    
    @httppost
    global static ContactResponseWrapper getContact(){
        
        RestRequest request = RestContext.Request;
        RestResponse response = RestContext.response;
        
        String JSONSTR = request.requestBody.toString();
        System.debug('JSONSTR***' +JSONSTR);
        ContactRequestWrapper result;
        String messageId;
        String accountId;
        String accountName;
        String conFirstname;
        String conLastName;
        String conId;
        String conEmail;
        String queryString = 'Select Id,contact.LCRM_Contact_Number__c,Email,FirstName, LastName,LCRM_City__c,LCRM_Country__c,Account.name,Account.Operational_Ultimate_Parent_Name1__c FROM Contact  WHERE account.is_gli__c = true AND ( ';
        String dummyString = '';
        String fuzzyAccountName;
        String fuzzyFirstName;
        String fuzzyLastName;
        
        Final String fuzzyStr = 'Fuzzy';
        
        ContactResponseWrapper responseWrapper = new ContactResponseWrapper();
        GetContactsResponse GetContactsResponsewrapper = new GetContactsResponse();
        
        List<LCRM_Exception_Log__c> exceptionList = new List<LCRM_Exception_Log__c>();
        
        List<Contact> contactList = new List<Contact>();    
        
        try{
            result = (ContactRequestWrapper)JSON.deserialize(JSONSTR,ContactRequestWrapper.class);
            
            System.debug('result*** '+result);
            
            System.debug('result.contact.account.companyId is AccountId*** '+result.GetContactsRequest.contact.account.companyId);
            System.debug('result.contact.account.companyName is Account Name*** '+result.GetContactsRequest.contact.account.companyName);
            System.debug('result.contact.account.firstName is contact firstname*** '+result.GetContactsRequest.contact.address.firstName);
            System.debug('result.contact.account.lastName is contact lastname*** '+result.GetContactsRequest.contact.address.lastName);
            System.debug('result.contact.account.emailAddress*** is contact emailaddress '+result.GetContactsRequest.contact.address.emailAddress);
            
            
            
            messageId = result.GetContactsRequest.ESIHeader.messageId;
            accountId = result.GetContactsRequest.contact.account.companyId;
            accountName = result.GetContactsRequest.contact.account.companyName;
            conFirstname = result.GetContactsRequest.contact.address.firstName;
            conLastName = result.GetContactsRequest.contact.address.lastName;
            conEmail = result.GetContactsRequest.contact.address.emailAddress;
            
            fuzzyAccountName = '%'+accountName+'%';
            
            
            
        }
        catch(Exception e){
            System.debug('EXCEPTION***'+e.getMessage());
            LCRM_Exception_Log__c excepObj = new LCRM_Exception_Log__c();
            excepObj.LCRM_Exception_Message__c = e.getMessage();
            excepObj.LCRM_Exception_Trace__c = e.getStackTraceString();
            excepObj.LCRM_Exception_Type__c = 'Test';                
            excepObj.LCRM_User_ID__c = userinfo.getUserId();
            exceptionList.add(excepObj);
            insert exceptionList;            
        }
        
        System.debug('ACCOUNTID*** '+accountId);
        try{
            if(messageId == fuzzyStr){
                boolean isParentAccount = false;
                System.debug('INSIDE FUZZY');
                if((String.isNotBlank(accountId) && string.isNotEmpty(accountId)) || (String.isNotBlank(accountName) && string.isNotEmpty(accountName)) || (String.isNotBlank(conFirstname) && string.isNotEmpty(conFirstname)) || (String.isNotBlank(conLastName) && string.isNotEmpty(conLastName)) || (String.isNotBlank(conEmail) && string.isNotEmpty(conEmail))){
                    
                    if((String.isNotBlank(accountId) && string.isNotEmpty(accountId))){
                        
                        Account acc = [select id,Operational_Ultimate_Parent_Name1__c, Global_Ultimate_Parent_Flag__c from Account where id =: accountId];
                        system.debug('acc**'+acc);
                        if(acc.Global_Ultimate_Parent_Flag__c)
                        {
                                isParentAccount = true;
                                System.debug('isParentAccount**'+isParentAccount);
                         }
                        if(isParentAccount){
                            dummyString += ' (account.Operational_Ultimate_Parent_Name1__c =: accountId OR accountId =: accountId) ';
                            System.debug('dummyString country***'+dummyString);
                        }
                        else{
                            dummyString += '(accountId =: accountId) ';
                            System.debug('dummyString country***'+dummyString);
                        }
                        /*if(String.isNotBlank(dummyString))
                        {
                            if(isParentAccount){
                                dummyString +=  '(OR account.Operational_Ultimate_Parent_Name1__c =: accountId OR accountId =: accountId )';
                                System.debug('dummyString*** '+dummyString);
                            }
                            else{
                                dummyString +=  ' (OR accountId =: accountId )';
                                System.debug('dummyString operational ultimate parent ***'+dummyString);
                            }
                            
                        }
                        else
                        {
                            if(isParentAccount){
                                dummyString += ' (account.Operational_Ultimate_Parent_Name1__c =: accountId OR accountId =: accountId) ';
                                System.debug('dummyString country***'+dummyString);
                            }
                            else{
                                dummyString += '(accountId =: accountId) ';
                                System.debug('dummyString country***'+dummyString);
                            }
                            
                        }*/             
                    }
                    if(String.isNotBlank(accountName) && string.isNotEmpty(accountName)){
                        
                        if(String.isNotBlank(dummyString))
                        {
                            
                            dummyString +=  ' AND account.Name LIKE : fuzzyAccountName ';
                            System.debug('querying with account.name 1***'+dummyString);
                        }
                        else
                        {
                            dummyString += ' account.Name LIKE : fuzzyAccountName';
                            System.debug('dummyString country***'+dummyString);
                        }              
                        
                    }
                    if(String.isNotBlank(conFirstname) && string.isNotEmpty(conFirstname)){
                        
                        fuzzyFirstName = conFirstname+'%';
                        System.debug('fuzzyFirstName ***'+fuzzyFirstName );
                        if(String.isNotBlank(dummyString))
                        {
                            
                            //dummyString +=  ' AND FirstName =: conFirstname ';
                            dummyString +=  ' AND FirstName LIKE : fuzzyFirstName ';
                            System.debug('querying with FirstName 1***'+dummyString);
                        }
                        else
                        {
                            //dummyString += ' FirstName =: conFirstname';
                            dummyString += ' FirstName LIKE : fuzzyFirstName';
                            System.debug('dummyString FirstName 2***'+dummyString);
                        }              
                        
                    }
                    if(String.isNotBlank(conLastName) && string.isNotEmpty(conLastName)){
                        fuzzyLastName = conLastName+'%';
                        System.debug('fuzzyLastName ***'+fuzzyLastName );
                        if(String.isNotBlank(dummyString))
                        {
                            
                            //dummyString +=  ' AND LastName =: conLastName ';
                             dummyString +=  ' AND LastName LIKE : fuzzyLastName ';
                            System.debug('querying with LastName 1***'+dummyString);
                        }
                        else
                        {
                            //dummyString += ' LastName =: conLastName ';
                            dummyString += ' LastName LIKE : fuzzyLastName ';
                            System.debug('dummyString LastName 2***'+dummyString);
                        }              
                        
                    }
                    if(String.isNotBlank(conEmail) && string.isNotEmpty(conEmail)){
                        
                        if(String.isNotBlank(dummyString))
                        {
                            
                            dummyString +=  ' AND Email =: conEmail ';
                            System.debug('querying with Email 1***'+dummyString);
                        }
                        else
                        {
                            dummyString += ' Email =: conEmail ';
                            System.debug('dummyString Email 2***'+dummyString);
                        }              
                        
                    }
                    
                }
                
                
                System.debug('dummyString***'+dummyString);
                queryString = queryString + dummyString +')';
                System.debug('queryString**'+queryString);
                try{                
                    contactList = database.query(queryString);
                    System.debug('AccountList ***** '+contactList); 
                }Catch(Exception e){
                    System.debug('EXCEPTION***'+e.getMessage());
                    LCRM_Exception_Log__c excepObj = new LCRM_Exception_Log__c();
                    excepObj.LCRM_Exception_Message__c = e.getMessage();
                    excepObj.LCRM_Exception_Trace__c = e.getStackTraceString();
                    excepObj.LCRM_Exception_Type__c = 'Test';                
                    excepObj.LCRM_User_ID__c = userinfo.getUserId();
                    exceptionList.add(excepObj);
                    insert exceptionList;
                }
                
                
                
                System.debug('contactList ***** '+contactList);
                
                System.debug('contactList***'+contactList.size());
                
                if(contactList.isEmpty() || contactList.size() == 0) {
                    GetContactsResponsewrapper.contactdetail = iterateContactList(contactList);
                    ESIHeaderResponseWrapper ESIHeaderwrapper = new ESIHeaderResponseWrapper();
                    StatusDetails StatusDetailswrapper = new StatusDetails();                    
                    ESIHeaderwrapper.messageId = 'Fuzzy';
                    GetContactsResponsewrapper.ESIHeader = ESIHeaderwrapper;
                    System.debug('GetContactsResponsewrapper.contactdetail*** '+GetContactsResponsewrapper.contactdetail);
                    //ESIHeaderwrapper.messageId = 'Fuzzy';
                    StatusDetailswrapper.statusCode = '400';
                    StatusDetailswrapper.statusDescription = 'Failure';
                    StatusDetailswrapper.statusDetailMessage = system.label.Contact_Service_Error;
                    ResponseExtensibleAttributes ResponseExtensibleAttributesWrapper = new ResponseExtensibleAttributes();
                    List<ResponseExtensibleAttributes> ResponseExtensibleAttributesWrapperList = new List<ResponseExtensibleAttributes>();
                    ResponseExtensibleAttributesWrapper.key='';
                    ResponseExtensibleAttributesWrapper.value='';
                    ResponseExtensibleAttributesWrapperList.add(ResponseExtensibleAttributesWrapper);
                    StatusDetailswrapper.extensibleAttributes = ResponseExtensibleAttributesWrapperList;
                    GetContactsResponsewrapper.statusDetails = StatusDetailswrapper;
                    responseWrapper.GetContactsResponse = GetContactsResponsewrapper;
                }
                else{
                    GetContactsResponsewrapper.contactdetail = iterateContactList(contactList);
                    ESIHeaderResponseWrapper ESIHeaderwrapper = new ESIHeaderResponseWrapper();
                    StatusDetails StatusDetailswrapper = new StatusDetails();
                    
                    ESIHeaderwrapper.messageId = 'Fuzzy';
                    GetContactsResponsewrapper.ESIHeader = ESIHeaderwrapper;
                    System.debug('GetContactsResponsewrapper.contactdetail*** '+GetContactsResponsewrapper.contactdetail);
                    StatusDetailswrapper.statusCode = '200';
                    StatusDetailswrapper.statusDescription = 'SUCCESS';
                    StatusDetailswrapper.statusDetailMessage = 'SUCCESS';
                    ResponseExtensibleAttributes ResponseExtensibleAttributesWrapper = new ResponseExtensibleAttributes();
                    List<ResponseExtensibleAttributes> ResponseExtensibleAttributesWrapperList = new List<ResponseExtensibleAttributes>();
                    ResponseExtensibleAttributesWrapper.key='';
                    ResponseExtensibleAttributesWrapper.value='';
                    ResponseExtensibleAttributesWrapperList.add(ResponseExtensibleAttributesWrapper);
                    StatusDetailswrapper.extensibleAttributes = ResponseExtensibleAttributesWrapperList;
                    GetContactsResponsewrapper.statusDetails = StatusDetailswrapper;
                    responseWrapper.GetContactsResponse = GetContactsResponsewrapper;
                    
                }
                
                
            }   
        }
        Catch(Exception e){
            
            System.debug('EXCEPTION'+e.getMessage());            
            LCRM_Exception_Log__c excepObj = new LCRM_Exception_Log__c();
            excepObj.LCRM_Exception_Message__c = e.getMessage();
            excepObj.LCRM_Exception_Trace__c = e.getStackTraceString();
            excepObj.LCRM_Exception_Type__c = 'Error';                
            excepObj.LCRM_User_ID__c = userinfo.getUserId();
            exceptionList.add(excepObj);
            insert exceptionList;
            
        }
        
        return responseWrapper;
        
    }
    /* -------------------------------------------------------------------------------

Method Name:iterateContactList

Purpose : iterateContactList common method is used to assign values to the response by 
iterating contactList

Created by : TCS

Date : 28/07/2017
--------------------------------------------------------------------------------*/
    
    Public  static List<Contactdetail> iterateContactList(List<Contact> tempContactList){
        
        List<Contactdetail> contactDetailList = new List<Contactdetail>();
        for(contact contemp : tempContactList){
            Contactdetail tempContactdetailWrapper = new Contactdetail();
            AddressResponse tempAddressResponseWrapper = new AddressResponse();
            AccountResponseWrapper tempAccountResponseWrapper = new AccountResponseWrapper();
            ResponseExtensibleAttributes ResponseExtensibleAttributesWrapper = new ResponseExtensibleAttributes();
            List<ResponseExtensibleAttributes> ResponseExtensibleAttributesWrapperList = new List<ResponseExtensibleAttributes>();
            ResponseExtensibleAttributesWrapper.key='';
            ResponseExtensibleAttributesWrapper.value='';
            ResponseExtensibleAttributesWrapperList.add(ResponseExtensibleAttributesWrapper);
            
            //tempContactdetailWrapper.contactNumber = contemp.LCRM_Contact_Number__c;
            tempContactdetailWrapper.contactNumber = contemp.Id;
            
            tempAddressResponseWrapper.firstName = contemp.FirstName;
            tempAddressResponseWrapper.lastName = contemp.LastName;
            tempAddressResponseWrapper.emailAddress = contemp.Email;
            tempAddressResponseWrapper.city =  contemp.LCRM_City__c;
            tempAddressResponseWrapper.country = contemp.LCRM_Country__c;
            
            tempAccountResponseWrapper.companyId = contemp.accountId;
            tempAccountResponseWrapper.companyName = contemp.Account.Name;
            tempAccountResponseWrapper.parentAccountNumber = contemp.Account.Operational_Ultimate_Parent_Name1__c;
            
            tempContactdetailWrapper.address = tempAddressResponseWrapper;
            tempContactdetailWrapper.account = tempAccountResponseWrapper;
            tempContactdetailWrapper.extensibleAttributes = ResponseExtensibleAttributesWrapperList;
            contactDetailList.add(tempContactdetailWrapper);
            
            
        }
        System.debug('contactDetailList*** '+contactDetailList);
        return contactDetailList;    
        
    }    
    
    public class ContactRequestWrapper {
        public GetContactsRequest GetContactsRequest;
    }
    
    public class GetContactsRequest {
        public ESIHeader ESIHeader;
        public ContactWrapper contact;
    }
    
    public class Address {
        public String firstName;
        public String lastName;
        public String emailAddress;
        public List<ExtensibleAttributes> extensibleAttributes;
    }
    
    public class ExtensibleAttributes {
        public String key;
        public String value;
    }
    
    public class ESIHeader {
        public String applicationId;
        public String transactionId;
        public String messageId;
        public String messageHistory;
        public String tracingId;
        public String timeStamp;
        public String instanceId;
        public String companyId;
        public String configGroup;
        public String payloadVersion;
        public String postBackURL;
        public List<ExtensibleAttributes> extensibleAttributes;
    }
    
    public class ContactWrapper {
        public Address address;
        public AccountRequest account;
        public List<ExtensibleAttributes> extensibleAttributes;
    }
    public class AccountRequest {
        public String companyId;
        public String companyName;
        public List<ExtensibleAttributes> extensibleAttributes;
    }
    
    /* Response Wrapper */
    
    global class ContactResponseWrapper {
        public GetContactsResponse GetContactsResponse;
    }
    
    public class GetContactsResponse {
        public List<Contactdetail> contactdetail;
        public ESIHeaderResponseWrapper ESIHeader;
        public StatusDetails statusDetails;
        
    }
    
    public class AddressResponse {
        public String firstName;
        public String lastName;
        public String emailAddress;
        public String city;
        public String country;
        
    }
    
    public class ResponseExtensibleAttributes {
        public String key;
        public String value;
    }
    public class ESIHeaderResponseWrapper {
        public String messageId;
    }
    
    public class StatusDetails {
        public String statusCode;
        public String statusDescription;
        public String statusDetailMessage;
        public List<ResponseExtensibleAttributes> extensibleAttributes;
    }
    
    
    public class Contactdetail {
        public String contactNumber;
        public AddressResponse address;
        public List<ResponseExtensibleAttributes> extensibleAttributes;
        public AccountResponseWrapper account;
    }
    
    public class AccountResponseWrapper {
        public String companyId;
        public String companyName;
        public string parentAccountNumber;
    }
    
}