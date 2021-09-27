/*The main purpose of this class is to perform Core libraries functionality in Account object.

   CHANGE HISTORY
   ================================================================================================================
   Date         Name                    Description
   2020-03-24   Shyamsundar Shet        BMP-1528 - Inserted the Token generation operation as part of Rocket services to Dellboomi migration


   -----------------------------------------------------------------------------------------------------------------

*/


public with sharing class CoreLibraryService { 
    //Constants
    public static final string WebServiceName = 'CoreLibraryService';
    public static final string MockCalloutGetCoreLibraries = 'GetCoreLibraries';
    public static final string MockCalloutGetAccountCoreLibraryMaterials = 'GetAccountCoreLibraryMaterials';
    public static final string MockCalloutGetCoreLibraryCodes = 'GetCoreLibraryCodes';
    

    public static final string SystemId = '1';
    //public list<Id> listId{get;set;}

    /**
    * Retrieves order info utilizing the Order web service.
    *
    * @paramdSAPCustomerNumberthe SAP unique customer number
    * @parambIncludeNameAddressindicates true to retrieve the address information
    * @returnan instance of a ContentOptimizerService.CustomerInfo object
    */
    public static list<string> GetCoreLibraryCodes(CoreLibraryService.CodeRequest oCodeRequest) {
        list<string> outputCode = new list<string>();
        
        if (oCodeRequest.MarketSegment != null) {
            WebServiceSettings__c oWebServiceSettings = AppUtil.getWebServiceSettings(WebServiceName);
            
            
            CoreLibraryWS.CoreLibrary_v3_0Port oService = new CoreLibraryWS.CoreLibrary_v3_0Port();
            
            
            oService.inputHttpHeaders_x = new Map<String, String>();
            oService.endpoint_x = oWebServiceSettings.Endpoint__c;
            oService.timeout_x = (oWebServiceSettings.Timeout__c * 1000).intValue(); //Convert seconds to milliseconds
            try{
            String accessToken=DellBoomiTokenGeneration.getAuthToken();//retreives the token as part of Rocket to Dellboomi migration
            string sAuthorizationHeader = 'Bearer ' +accessToken;
            //Blob blobCredentials = Blob.valueOf(oWebServiceSettings.Username__c + ':' + oWebServiceSettings.Password__c);
            //string sAuthorizationHeader = 'Basic ' + EncodingUtil.base64Encode(blobCredentials);
            oService.inputHttpHeaders_x.put('Authorization', sAuthorizationHeader);
            }
            catch(Exception e){
            ApexPages.addMessages(e);
    } 
            
            oService.outputHttpHeaders_x = new Map<String,String>();    
            //list<CoreLibraryWS.GetCoreLibraryCodes_element> outputCode = new list<CoreLibraryWS.GetCoreLibraryCodes_element>();
            //list<codelibrary> outputCode = new list<codelibrary>();
            
            if (Test.isRunningTest()) {
            //Get Mock Response
                object oMockResponse = UnitTest.MockWebServiceResponse.get(MockCalloutGetCoreLibraryCodes);
                if (oMockResponse instanceof List<string>) {
                    //outputCode = (CoreLibraryWS.GetCoreLibraryCodes_element) oMockResponse;
                    outputCode = (list<string>) oMockResponse;
                }
            }
            else {
            //Execute Web Service Callout
                outputCode = oService.GetCoreLibraryCodes(oCodeRequest.MarketSegment);
            }

        }
        else {
        throw new ContentOptimizerServiceException('Invalid market segment');
        }
        
        
        return outputCode;
    }


    public static list<CoreLibraries> GetCoreLibraries(CoreLibraryService.CoreLibraryRequest oCoreLibraryRequest) {
        list<CoreLibraries> oCoreLibraries = new list<CoreLibraries>(); 
        
        if (oCoreLibraryRequest.CoreLibraryCode != null) {
            WebServiceSettings__c oWebServiceSettings = AppUtil.getWebServiceSettings(WebServiceName);
            
            CoreLibraryWS.CoreLibrary_v3_0Port oService = new CoreLibraryWS.CoreLibrary_v3_0Port();
            oService.inputHttpHeaders_x = new Map<String, String>();
            oService.endpoint_x = oWebServiceSettings.Endpoint__c;
            oService.timeout_x = (oWebServiceSettings.Timeout__c * 1000).intValue(); //Convert seconds to milliseconds
            try{
                String accessToken=DellBoomiTokenGeneration.getAuthToken();//retreives the token as part of Rocket to Dellboomi migration
            //Blob blobCredentials = Blob.valueOf(oWebServiceSettings.Username__c + ':' + oWebServiceSettings.Password__c);
            //string sAuthorizationHeader = 'Basic ' + EncodingUtil.base64Encode(blobCredentials);
            string sAuthorizationHeader = 'Bearer ' +accessToken;
            oService.inputHttpHeaders_x.put('Authorization', sAuthorizationHeader);
            }
            catch(Exception e){
            ApexPages.addMessages(e);
    } 
            
            oService.outputHttpHeaders_x = new Map<String,String>();
            list<CoreLibraryWS.CoreLibrary> outputCoreLibraries = new list<CoreLibraryWS.CoreLibrary>();
            if (Test.isRunningTest()) {
                //Get Mock Response
                object oMockResponse = UnitTest.MockWebServiceResponse.get(MockCalloutGetCoreLibraries);
                if (oMockResponse instanceof CoreLibraryWS.CoreLibrary) {
                    outputCoreLibraries = (list<CoreLibraryWS.CoreLibrary>) oMockResponse;
                }
            }
            else {
            //Execute Web Service Callout
                outputCoreLibraries = oService.GetCoreLibraries(oCoreLibraryRequest.MarketSegment, oCoreLibraryRequest.CoreLibraryCode);
            }
            //oCoreLibraries.parse(outputCoreLibraries);
            if(outputCoreLibraries != null){
                for (CoreLibraryWS.CoreLibrary oCoreLibraryList : outputCoreLibraries) {
                    CoreLibraryService.CoreLibraries oCoreLibrarySingle = new CoreLibraryService.CoreLibraries(oCoreLibraryList);                    
                    oCoreLibraries.add(oCoreLibrarySingle);                                                                                                 
                }
            }
        }
        else {
            throw new ContentOptimizerServiceException('Invalid core library code');
        }
        
        return oCoreLibraries;
    }

    public static list<CoreLibraryMaterials> GetCoreLibraryMaterial(CoreLibraryService.CoreLibraryMaterialRequest oCoreLibraryMaterialRequest) {
        list<CoreLibraryMaterials> oCoreLibraries = new list<CoreLibrarymaterials>(); 
        system.debug('***Herea');
       
        if (oCoreLibrarymaterialRequest.MDBId != null) {
            system.debug('***Hereb');
            WebServiceSettings__c oWebServiceSettings = AppUtil.getWebServiceSettings(WebServiceName);
            
            system.debug('***Herec');
            CoreLibraryWS.CoreLibrary_v3_0Port oService = new CoreLibraryWS.CoreLibrary_v3_0Port();
            system.debug('***Hered');
            oService.inputHttpHeaders_x = new Map<String, String>();
            oService.endpoint_x = oWebServiceSettings.Endpoint__c;
            oService.timeout_x = (oWebServiceSettings.Timeout__c * 1000).intValue(); //Convert seconds to milliseconds
            try{
            String accessToken=DellBoomiTokenGeneration.getAuthToken();//retreives the token as part of Rocket to Dellboomi migration
            //Blob blobCredentials = Blob.valueOf(oWebServiceSettings.Username__c + ':' + oWebServiceSettings.Password__c);
            //string sAuthorizationHeader = 'Basic ' + EncodingUtil.base64Encode(blobCredentials);
            string sAuthorizationHeader = 'Bearer ' +accessToken;
            oService.inputHttpHeaders_x.put('Authorization', sAuthorizationHeader);
            }
            catch(Exception e){
            ApexPages.addMessages(e);
    } 
            oService.outputHttpHeaders_x = new Map<String,String>();
            list<CoreLibraryWS.CoreLibraryMaterial> outputCoreLibraries = new list<CoreLibraryWS.CoreLibraryMaterial>();
            system.debug('***Heree');
            if (Test.isRunningTest()) {
                //Get Mock Response
                object oMockResponse = UnitTest.MockWebServiceResponse.get(MockCalloutGetCoreLibraries);
                if (oMockResponse instanceof CoreLibraryWS.CoreLibraryMaterial) {
                    outputCoreLibraries = (list<CoreLibraryWS.CoreLibraryMaterial>) oMockResponse;
                }
            }
            else {
            //Execute Web Service Callout

                outputCoreLibraries = oService.GetAccountCoreLibraryMaterials(oCoreLibrarymaterialRequest.MDBId, oCoreLibrarymaterialRequest.MarketSegment, oCoreLibraryMaterialRequest.CoreLibrary);
                system.debug('***Hereg');
            }
            //oCoreLibraries.parse(outputCoreLibraries);
            if(outputCoreLibraries != null){
                system.debug('***Hereh');
                for (CoreLibraryWS.CoreLibraryMaterial oCoreLibraryMaterialList : outputCoreLibraries) {
                    CoreLibraryService.CoreLibraryMaterials oCoreLibrarySingle = new CoreLibraryService.CoreLibraryMaterials(oCoreLibraryMaterialList);                    
                    oCoreLibrarySingle.MaterialNumber = drop_leading_zeros(oCoreLibrarySingle.MaterialNumber);
                    
                    
                    oCoreLibraries.add(oCoreLibrarySingle);                                                                                               
                }
            }
        }
        else {
            throw new ContentOptimizerServiceException('Invalid core library code');
        }
        
        system.debug('***Herej');
        system.debug('***Herek' + oCoreLibraries);
        return oCoreLibraries;
    }


public static String drop_leading_zeros(String passedValue) {
        String return_string = null; //return string for passing back
        if (passedValue != null) { //if the passed value is not null
            return_string = passedValue.trim(); //trim the whitespace from the start and end of the value
            Pattern valid_characters = Pattern.compile('([0-9]+)'); //only numbers
            Matcher check_chars = valid_characters.matcher(return_string); //compare the string to the set of valid characters
            if (check_chars.matches()) { //if we have a somewhat valid number
                if (return_string.startsWith('0') && return_string.length() > 1) { //if the string begins with a 0 and the length is greater than 1
                    boolean keepChecking = true; //create a boolean variable
                    while (keepChecking) { //if boolean is true
                        if (return_string.startsWith('0') && return_string.length() > 1) { //if the string begins with 0 and there is more than 1 character
                            return_string = return_string.substring(1); //drop the first character
                        } else { //either the string doesn't begin with 0 or the length is less than or equal to 1
                            keepChecking = false; //stop the loop
                        }
                    }
                }
                
                return_string=(return_string == '0')?null:return_string;
                 //if the resulting string is now a single '0'
                    //set the string to null
                
            } else { //otherwise the value passed was not valid
                return_string = null; //set the string to null
            }
        }
        return return_string; //pass back a value
    }
    
/* -----------------------------------------------------------Internal Classes --------------------------------------------------------------*/

    /**
    * Custom Exception thrown a web service callout fails
    */
    public class ContentOptimizerServiceException extends Exception {}

    /**
    * Data structure representing customer information
    */

    
    public class CoreLibraries {
        public String CoreLibraryId {get;set;}
        public String CoreLibraryDesc {get;set;}
        
        
        public CoreLibraries(CoreLibraryWS.CoreLibrary oCoreLibraryList){         
            CoreLibraryId = oCoreLibraryList.CoreLibraryId;
            CoreLibraryDesc = oCoreLibraryList.CoreLibraryDesc;
            
        } 
    }

    public class CoreLibraryMaterials {
        public String SubStatus {get;set;}
        public integer Quantity {get;set;}
        public String MaterialNumber {get;set;}
        public String MaterialDesc {get;set;}
        public String CoreLibraryDesc {get;set;}
        public Integer Priority{get;set;}
        
        public CoreLibraryMaterials(CoreLibraryWS.CoreLibraryMaterial oCoreLibrarymaterialList){         
            SubStatus = oCoreLibrarymaterialList.SubStatus;
            Quantity = oCoreLibrarymaterialList.Quantity;
            MaterialNumber = oCoreLibrarymaterialList.MaterialNumber;
            MaterialDesc = oCoreLibrarymaterialList.MaterialDesc;
            CoreLibraryDesc = oCoreLibrarymaterialList.CoreLibraryDesc;
            Priority = oCoreLibrarymaterialList.Priority;
            
            
        } 
    }

    public class CodeRequest { 
        public Integer MarketSegment {get;set;}
        
    }
  
    public class CoreLibraryRequest { 
        public Integer MarketSegment {get;set;}
        public String CoreLibraryCode {get;set;}
        
    }

    public class CoreLibraryMaterialRequest { 
        public String MDBId {get;set;}
        public Integer MarketSegment {get;set;}
        public list<CorelibraryWS.CoreLibrary> CoreLibrary {get;set;}
        
    }  

}