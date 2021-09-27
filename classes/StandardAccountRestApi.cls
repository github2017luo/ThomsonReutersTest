/* -----------------------------------------------------------------------------------------------------
CLASS NAME: StandardAccountRestApi

PURPOSE : StandardAccountRestApi Service is used to search locatin on basis of request given by ESI team.

Created By : TCS

Date : 28/07/2017
-------------------------------------------------------------------------------------------------------*/
@RestResource(urlmapping='/StandardAccountRestApi/*')
Global  class StandardAccountRestApi {     
    
    @httppost
    global static AccountResponseWrapper getAccount(){
        RestRequest request = RestContext.request;
        RestResponse response = RestContext.response;
        
        System.debug('request.requestBody***'+request.requestBody+'request***');
        
        String JSONSTR = request.requestBody.toString();
        Final String exactStr = 'Exact';
        Final String fuzzyStr = 'Fuzzy';
        System.debug('JSONSTR***' +JSONSTR);
        List<LCRM_Exception_Log__c> exceptionList = new List<LCRM_Exception_Log__c>();
        List<Account> AccountList = new List<Account>();
        
        List<Source_System_Detail__c> sourceSystemList = new List<Source_System_Detail__c>();
        
        List<KeyValueListStore__c> sourceSystemNameList = new List<KeyValueListStore__c>();
        Set<id> accountNameSet = new Set<id>();
        String sourceSystemName;
        
        AccountRequestWrapper result = new AccountRequestWrapper();
        /*Response Wrapper instance*/
        AccountResponseWrapper responsewrapper = new AccountResponseWrapper();
        GetAccountDetailsResponse accountDetailsWrapper = new GetAccountDetailsResponse();
        StatusDetails statusDetailsWrapper = new StatusDetails();
        
        String companyId ;
        String companyName ;
        String FuzzycompanyName ;
        String billingCity ;
        String billingCountry ;
        
        System.debug('FuzzycompanyName ' +FuzzycompanyName+''+''+''+''+'');
        String messageId ;
        MESSAGEID = messageId;
        String accountnumber ;       
        
        
        String query;
        String queryString = 'SELECT NAME,is_gli__c,Type,BillingCity,BillingPostalCode,BillingCountry,BillingStreet,BillingState,Operational_Ultimate_Parent_Name1__c,Street_Address_2__c,County__c,Suite_Number__c FROM ACCOUNT WHERE is_gli__c = true AND (';
        String dummyString = '';
        
        try{
            result = (AccountRequestWrapper)System.JSON.deserialize(JSONSTR,AccountRequestWrapper.class);
            system.debug('****resultList '+result);
            System.debug(' result.applicationId**'+result.account.accountNumber);
            
            
            companyId = result.account.companyId;
            companyName = result.account.companyName;
            FuzzycompanyName = '%'+companyName+'%';
            billingCity = result.account.address[0].city;
            billingCountry = result.account.address[0].country;
            
            System.debug('FuzzycompanyName ' +FuzzycompanyName);
            messageId = result.EsiHeader.messageId;
            MESSAGEID = messageId;
            accountnumber = result.account.accountNumber;       
            
            System.debug('FuzzycompanyName***' +FuzzycompanyName+'companyId**'+companyId+'companyName***'+companyName+'billingCity***'+billingCity+'billingCountry***'+billingCountry+'');
            
            System.debug('messageId***'+messageId);
        }
        Catch(Exception e){
            System.debug('EXCEPTION***'+e.getMessage());
            LCRM_Exception_Log__c excepObj = new LCRM_Exception_Log__c();
            excepObj.LCRM_Exception_Message__c = e.getMessage();
            excepObj.LCRM_Exception_Trace__c = e.getStackTraceString();
            excepObj.LCRM_Exception_Type__c = 'Test';                
            excepObj.LCRM_User_ID__c = userinfo.getUserId();
            exceptionList.add(excepObj);
            insert exceptionList;
        }    
        
        if(messageId==exactStr){
            System.debug('Exact*** Inside Exact');
            
            sourceSystemNameList = KeyValueListStore__c.getall().values();
            sourceSystemName =KeyValueListStore__c.getInstance('Location_API_Source_System_Name').TextValue__c;
            
            
            
            if(result.account.accountNumber != '' && result.account.accountNumber.length()!= 18 && !result.account.accountNumber.startsWith('001')){
                
                sourceSystemList = [Select Account_Name__c, Source_System_Account_Number__c,Source_System_Name__c From Source_System_Detail__c WHERE
                                    Source_System_Account_Number__c =: accountnumber AND Source_System_Name__c =: sourceSystemName ];
                System.debug('sourceSystemList***'+sourceSystemList.size());
                for(Source_System_Detail__c SourceDetail : sourceSystemList){
                    accountNameSet.add(SourceDetail.Account_Name__c);
                }
                
                AccountList = [SELECT NAME,Type,BillingCity,BillingPostalCode,BillingCountry,BillingStreet,BillingState,Operational_Ultimate_Parent_Name1__c,Street_Address_2__c,County__c,Suite_Number__c,
                               (Select Account_Name__c, Source_System_Account_Number__c,Source_System_Name__c From Source_System_Details__r WHERE Source_System_Account_Number__c =: accountnumber 
                                AND Source_System_Name__c =: sourceSystemName ) FROM ACCOUNT 
                               WHERE is_gli__c = true and ID IN :accountNameSet];                    
                System.debug('AccountList inside account number loop' +AccountList.size());
                System.debug('Source_System_Details__r'+AccountList);
                
                
            }
            else if(companyId.length() == 18 && companyId.startsWith('001')){
                
                
                AccountList = [SELECT NAME,Type,BillingCity,BillingPostalCode,BillingCountry,BillingStreet,BillingState,Operational_Ultimate_Parent_Name1__c,Street_Address_2__c,County__c,Suite_Number__c,
                               (Select Account_Name__c, Source_System_Account_Number__c,Source_System_Name__c From Source_System_Details__r WHERE Source_System_Name__c =: sourceSystemName ) FROM ACCOUNT 
                               WHERE is_gli__c = true AND ID =: companyId  ];
                
                System.debug('Inside'+companyId.length()+''+'AccountList.size()***'+AccountList.size());
                System.debug('AccountList***'+AccountList);
                
            }
            
            
            System.debug('AccountList***'+AccountList.size()); 
            
            if( AccountList.isEmpty() || AccountList.size() == 0) {
                System.debug('INSIDE ACOUNT LIST EMPTY LOOP');
                
                accountDetailsWrapper.locations = iterateAccountlist(AccountList);
                responseWrapper.getAccountDetailsResponse = accountDetailsWrapper;
                statusDetailsWrapper.statusDescription= system.label.Location_Service_Error;
                statusDetailsWrapper.statusCode='400';
                accountDetailsWrapper.statusDetails = statusDetailsWrapper;
                return responsewrapper;
            }                
            else{
                System.debug('Account list is not empty.');                                  
                accountDetailsWrapper.locations = iterateAccountlist(AccountList);
                responseWrapper.getAccountDetailsResponse = accountDetailsWrapper;
                statusDetailsWrapper.statusDescription='SUCCESS';
                statusDetailsWrapper.statusCode='200';
                accountDetailsWrapper.statusDetails = statusDetailsWrapper;
                return responsewrapper;
            }
            
            
        }
        if(messageId==fuzzyStr){
            System.debug('INSIDE FUZZY');
            System.debug('result.account.address[0].city'+result.account.address[0].city+'result.account.address[0].country] '+result.account.address[0].country);
            
            System.debug('billingCountry***'+billingCountry+'billingCity*** '+billingCity+'companyName*** '+companyName);
            
            if((!String.isBlank(billingCountry) && !String.isEmpty(billingCountry)) || (!String.isBlank(billingCity) && !String.isEmpty(billingCity)) || (!String.isBlank(CompanyName) && !String.isEmpty(CompanyName))){
                
                               
                if(!String.isBlank(CompanyName) && !String.isEmpty(CompanyName))
                {
                    if(String.isNotBlank(dummyString))
                    {
                        dummyString +=  ' AND Name LIKE : FuzzycompanyName';
                        System.debug('dummyString company name***'+dummyString);
                    }
                    else
                    {
                        dummyString +=  ' Name LIKE : FuzzycompanyName';
                        System.debug('dummyString company name***'+dummyString);
                    }
                    
                                   // if(billingCountry != null && billingCountry!='' )
                if(!String.isBlank(billingCountry) && !String.isEmpty(billingCountry))
                {
                    if(String.isNotBlank(dummyString))
                    {
                        dummyString +=  ' AND BillingCountry =: billingCountry';
                        System.debug('dummyString country***'+dummyString);
                    }
                    else
                    {
                        dummyString += ' BillingCountry =: billingCountry';
                        System.debug('dummyString country***'+dummyString);
                    }
                }
                
                if(!String.isBlank(billingCity) && !String.isEmpty(billingCity))
                {
                    if(String.isNotBlank(dummyString))
                    {
                        dummyString +=  ' AND BillingCity =: billingCity';
                        System.debug('dummyString city***'+dummyString);
                    }
                    else
                    {
                        dummyString += ' BillingCity =: billingCity';
                        System.debug('dummyString city***'+dummyString);
                    }
                }
                }                
            }
            
            System.debug('dummyString***'+dummyString);
            queryString = queryString + DummyString +')';
            System.debug('queryString**'+queryString);
            try{                
                AccountList = database.query(queryString);
                System.debug('AccountList ***** '+AccountList); 
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
            
            System.debug('AccountList ***** '+AccountList);
            
            System.debug('AccountList***'+AccountList.size());
            
            if(!AccountList.isEmpty()){
                
                accountDetailsWrapper.locations = iterateAccountlist(AccountList);
                responseWrapper.getAccountDetailsResponse = accountDetailsWrapper;
                statusDetailsWrapper.statusDescription='SUCCESS';
                statusDetailsWrapper.statusCode='200';
                accountDetailsWrapper.statusDetails = statusDetailsWrapper;
                return responsewrapper;
                
            } 
            else{
                System.debug('Account list is empty.');                             
                accountDetailsWrapper.locations = iterateAccountlist(AccountList);
                responseWrapper.getAccountDetailsResponse = accountDetailsWrapper;
                statusDetailsWrapper.statusDescription=system.label.Location_Service_Error;
                statusDetailsWrapper.statusCode='400';
                accountDetailsWrapper.statusDetails = statusDetailsWrapper;
                return responsewrapper;
            }
            
            
        }
        return responsewrapper;   
        
    } 
    /* -------------------------------------------------------------------------------

Method Name:iterateAccountlist

Purpose : iterateAccountlist common method is used to assign values to the response

Created by : TCS

Date : 28/07/2017
--------------------------------------------------------------------------------*/
    Public  static List<Locations> iterateAccountlist(List<Account> tempAccountList){
        /*AccountResponseWrapper instances*/
        System.debug('tempAccountList.size()***'+tempAccountList.size());
        
        
        List<Locations> locationList = new List<Locations>();
        
        for(Account acctemp : tempAccountList){   
            Locations locationWrapper = new Locations();
            ResponseAddress responseAddressWrapper = new ResponseAddress();
            ResponseAccount responseAccountWrapper = new ResponseAccount();         
            
            
            system.debug('locationWrapper*** '+locationWrapper);
            system.debug('responseAddressWrapper*** '+responseAddressWrapper);
            system.debug('responseAccountWrapper*** '+responseAccountWrapper);
            
            
            System.debug('acctemp***'+acctemp);
            System.debug('acctemp.Source_System_Details__r***'+acctemp.Source_System_Details__r);
            
            List<SourceOrTargetReference>  SourceOrTargetReferenceList = new List<SourceOrTargetReference>();
            if(!acctemp.Source_System_Details__r.isEmpty() && acctemp.Source_System_Details__r !=null)
                for (Source_System_Detail__c ssTemp : acctemp.Source_System_Details__r){
                    SourceOrTargetReference sourceOrTargetReferenceWrapper = new SourceOrTargetReference();
                    
                    if(ssTemp.Account_Name__c == acctemp.id){
                        
                        System.debug('ssTemp *** '+ssTemp );
                        
                        
                        sourceOrTargetReferenceWrapper.sourceOrTargetSystemName = ssTemp.Source_System_Name__c;
                        sourceOrTargetReferenceWrapper.referenceID = ssTemp.Source_System_Account_Number__c;
                        System.debug('ssTemp.Source_System_Name__c***'+ssTemp.Source_System_Name__c+'ssTemp.Source_System_Account_Number__c***'+ssTemp.Source_System_Account_Number__c);
                        System.debug('sourceOrTargetReferenceWrapper*** '+sourceOrTargetReferenceWrapper );   
                        
                        SourceOrTargetReferenceList.add(sourceOrTargetReferenceWrapper);
                    }
                    
                    
                }
            responseAddressWrapper.country = acctemp.BillingCountry;
            responseAddressWrapper.street1 = acctemp.BillingStreet;
            responseAddressWrapper.street2 = acctemp.Street_Address_2__c;
            responseAddressWrapper.room = acctemp.Suite_Number__c;
            responseAddressWrapper.county = acctemp.County__c;
            responseAddressWrapper.city = acctemp.BillingCity;
            responseAddressWrapper.region = acctemp.BillingState;
            responseAddressWrapper.postalcode = acctemp.BillingPostalCode;
            
            
            responseAccountWrapper.companyId = acctemp.id;
            responseAccountWrapper.companyName = acctemp.Name;
            responseAccountWrapper.accountType = acctemp.Type;
            responseAccountWrapper.parentAccountNumber = acctemp.Operational_Ultimate_Parent_Name1__c;
            System.debug('SourceOrTargetReferenceList***'+SourceOrTargetReferenceList.size());
            System.debug('SourceOrTargetReferenceList***'+SourceOrTargetReferenceList);
            responseAccountWrapper.sourceOrTargetReference =SourceOrTargetReferenceList;             
            
            locationWrapper.address = responseAddressWrapper;
            locationWrapper.account = responseAccountWrapper;
            
            
            system.debug('locationWrapper*** '+locationWrapper);
            system.debug('responseAddressWrapper*** '+responseAddressWrapper);
            system.debug('responseAccountWrapper*** '+responseAccountWrapper);
            
            locationList.add(locationWrapper);    
            
            
        }
        return locationList;
        
    }
    
    /**** RESPONSE WRAPPER ****/
    global class AccountResponseWrapper {
        public GetAccountDetailsResponse GetAccountDetailsResponse;
        //public statusDetails statusDetails;
        
    }
    Public Class StatusDetails{
        public string statusDescription;
        public string statusCode;
    }
    
    public class GetAccountDetailsResponse{
        public List<Locations> locations;
        public statusDetails statusDetails;
    }
    public class Locations {
        public ResponseAddress address;
        public ResponseAccount account;
    }
    
    public class ResponseAccount {
        public String companyId;
        public String companyName;
        public String accountType;
        public String parentAccountNumber;
        public List<SourceOrTargetReference> sourceOrTargetReference;
    }
    
    public class ResponseAddress {
        public String street1;
        public String street2;
        public string room;
        public String city;
        public String region;
        public String country;
        public string county;       
        public String postalcode;
        
    }
    
    public class SourceOrTargetReference {
        public String sourceOrTargetSystemName;
        public String referenceID;
    }    
    
    /***** END Response Wrapper ****/ 
    /**** REQUEST WRAPPER ****/
    
    public class AccountRequestWrapper {
        public ESIHeader ESIHeader;
        public AccountHeader account;
    }
    
    public class AccountHeader {
        public String action;
        public String accountNumber;
        public String companyId;
        public String companyName;
        public List<Address> address;
    }    
    public class Address {
        public String city;
        public String country;
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
    
    /***** END Request Wrapper ****/      
}