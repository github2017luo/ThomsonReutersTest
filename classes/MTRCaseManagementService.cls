/********************************************************************************
Class Name : MTRCaseManagementService
description : This is a REST Resource used by My TR for case management. 
This class will cater to all services needed for case management.
Functionalities : Create Cases, Retrieve Case Details
Parameters : Business ( LATAM/Legal/Tax/RISK), Case Number, 
Operation (CreateCase)
********************************************************************************
Modification Details:
Date                    description                     Owner
22/05/2019              Created                         Deepika Motamarri
22/05/2020              Added logic for RISK            Deepika Motamarri
*********************************************************************************/
@RestResource(urlMapping='/MTRCaseManagementService/*')
global without sharing class MTRCaseManagementService{ 
    
    /********************************************************************************
    Method Name : postServices
    description : Retrieve case Details
    Parameters : Case Number
    Return Type:  None
    *********************************************************************************/
    global static boolean  myTRCase;
    @HttpPost
    global static ResponseMessage postServices(){
        //Retrieve request parameters
        ResponseMessage objSuccessError;
        List<Contact> currentContact = new List<Contact>();
        
        try{ 
            RestRequest req = RestContext.request;
            Map<String,String> requestParameters = req.params;
            
            if(requestParameters.containskey('operation') && requestParameters.get('operation').equalsIgnoreCase('CREATECASE')){
                
                // Return error if Business Unit is not passed 
                if(!(requestParameters.containskey('business') && requestParameters.get('business') != null 
                     && requestParameters.get('business') != '' && MTRCommonUtility.userSettings('BUSINESSUNIT',requestParameters.get('business')) == 'VALID')){
                         objSuccessError = createResponse(null, MTRCommonUtility.INVALID_BU +' -'+requestParameters.get('business'));
                         return objSuccessError;
                     } 
                
                //Retrieve the AEM Case Details
                CaseDetailsWrapper aemCase = (CaseDetailsWrapper)System.JSON.deserialize(RestContext.request.requestBody.tostring(),CaseDetailsWrapper.class);                
                myTRCase = true;
                //Return error if requets is not in proper format 
                if(aemCase ==null){
                    objSuccessError = createResponse(null, MTRCommonUtility.IMPROPER_REQUEST_FORMAT );
                    return objSuccessError;
                }
                
                    //Return error if contact id is not passed
                    /* if(String.isBlank(aemCase.contactId)){
                        objSuccessError = createResponse(null, MTRCommonUtility.CONTACT_IS_MISSING);
                        return objSuccessError;
                    }*/
                
                //Verify if the contact id is passed and it exists                    
                currentContact = [select id,name,AccountId,Account.Sales_Org__c,Account.BU_Region__c,Account.Bu_Segment__c from Contact 
                                  where Id =: aemCase.contactId with SECURITY_ENFORCED];
                
                //Return error if contact does not exist
                if(currentContact != null && currentContact.size() == 0){
                    objSuccessError = createResponse(null, MTRCommonUtility.INVALID_CONTACT+' -'+aemCase.contactId);
                    return objSuccessError;
                }
                
                //Return error if region is missing for RISK business
                if(requestParameters.get('business') =='RISK' && (currentContact[0].Account.BU_Region__c ==null || currentContact[0].Account.BU_Region__c =='')){
                    objSuccessError = createResponse(null, MTRCommonUtility.BU_REGION_MISSING+' -'+aemCase.contactId);
                    return objSuccessError;
                }
                
                List<MyTr_Case_Record_Type_Setting__mdt> queryTypeMetaData = new List<MyTr_Case_Record_Type_Setting__mdt>();
                //DM :  Added separate condition for RISK as it needs more parameters          
                // validate Query type is available in metadata or not
                if(requestParameters.get('business') != 'RISK' && !String.isBlank(aemCase.queryType)){
                    queryTypeMetaData = checkQueryTypeInMetaData(aemCase.queryType ,requestParameters.get('business'));
                }else if(requestParameters.get('business') == 'RISK' && !String.isBlank(aemCase.queryType)){
                    queryTypeMetaData = checkQueryTypeInMetaDataRISK(aemCase.queryType ,requestParameters.get('business'), currentContact[0].Account.BU_Region__c);
                }else{
                    objSuccessError = createResponse(null, MTRCommonUtility.QUERY_TYPE_NOT_PROVIDED );
                    return objSuccessError;
                }               
                //Return error if query metadata is not available
                if(queryTypeMetaData.IsEmpty()){
                    objSuccessError = createResponse(null, MTRCommonUtility.QUERY_TYPE_MISSING );
                    return objSuccessError;
                }
                
                //Create Case
                objSuccessError = createCase(currentContact, aemCase,queryTypeMetaData[0],requestParameters);
            }               
        }catch(Exception ex) {
            system.debug(ex.getStackTraceString());
            system.debug('  Json' + ex.getMessage());
            //Log the error 
            ApplicationLogUtility.logException('MY TR' , 'MTRCaseManagementService' , 'postServices' , ex);
            objSuccessError= createResponse(new Case(),ex.getStackTraceString());
            
        }//end of catch
        return objSuccessError;
    }//end of postServices
    
    /********************************************************************************
    Method Name : Case Creation
    description : The case creation logic
    Parameters : case record, error message
    Return Type:  Response Message
    *********************************************************************************/
    global static ResponseMessage createCase(List<Contact> currentContact,CaseDetailsWrapper aemCase,
                                             MyTr_Case_Record_Type_Setting__mdt sfdcQuery ,Map<String,String> requestParameters){
                                                 
       Case currentCase = new Case();
       ResponseMessage objSuccessError = new ResponseMessage();
                                                 
       try{
          //populate the common fields for the case
          currentCase = populateCommonFields(currentCase, currentContact, aemCase,sfdcQuery,requestParameters);
                                                     
          //Populate BU specific values
          if(requestParameters.get('business').equalsIgnoreCase('LATAM')){                                  
             currentCase = populateLATAMFields(currentCase, aemCase);                                
          }else if(requestParameters.get('business').equalsIgnoreCase('LEGAL')){
             currentCase = populateLEGALFields(currentCase, aemCase);
          }/*else if(requestParameters.get('business').equalsIgnoreCase('TAX')){
            currentCase = populateTAXFields(currentCase,aemCase);
          }*/else if(requestParameters.get('business').equalsIgnoreCase('RISK')){
            currentCase = populateRISKFields(currentCase,aemCase);
    
            // populate case region and segment based on queryType and Account Region
                List<MTR_Case_Region_and_Segment__mdt> lstRegionSegment = new List<MTR_Case_Region_and_Segment__mdt>();
                lstRegionSegment = retrieveRegionSegmentData(currentContact[0].Account.BU_Region__c,sfdcQuery.Query_Category__c,requestParameters.get('business'));
        
                if(!lstRegionSegment.isEmpty()){
                    currentCase = populateRegionSegment(currentCase,currentContact[0],lstRegionSegment[0]);
                }else{
                    objSuccessError = createResponse(null, MTRCommonUtility.REGION_SEGMENT_DATA_MISSING );
                    return objSuccessError;
                }
            }
                                                     
            system.debug('Before insert ...'+currentCase);
                                                     
            if(Schema.sObjectType.Case.isAccessible() || Schema.sObjectType.Case.isCreateable()){
               insert currentCase ;
             }
                                                     
             system.debug('currentCase---'+currentCase);
             //system.debug('currentCase.ESC_EnquiryType__c---'+currentCase.ESC_EnquiryType__c);
             //return case creation success message
             objSuccessError = createResponse(currentCase,null);               
           }catch(Exception ex) {
               system.debug(ex.getStackTraceString());
               system.debug('  Json' + ex.getMessage());
               //Log the error 
               ApplicationLogUtility.logException('MY TR' , 'MTRCaseManagementService' , 'postServices' , ex);
               objSuccessError= createResponse(currentCase,ex.getStackTraceString());
                                                     
           }//end of catch
           return objSuccessError;
    }//end of createCase
    
    /********************************************************************************
    Method Name : checkQueryTypeInMetaData
    description : Verify if the passed query type is available
    Parameters : case record, error message
    Return Type:  Response Message
    *********************************************************************************/
        global static List<MyTr_Case_Record_Type_Setting__mdt> checkQueryTypeInMetaData(String aemQueryType , String businessUnit){
        
        
        List<MyTr_Case_Record_Type_Setting__mdt> mapCaseRecordType = [Select id,Case_Record_Sub_Type__c,Case_Record_Type__c,Case_Type__c,
                                                                      Record_Type_Developer_Name__c,English__c,Symptom__c,Case_Sub_Type__c, Source__c,Business_Unit__c 
                                                                      from MyTr_Case_Record_Type_Setting__mdt where English__c = : aemQueryType 
                                                                      and Business_Unit__c = : businessUnit and Source__c = 'MyTR' with SECURITY_ENFORCED];
        
        return mapCaseRecordType;                 
        
    }//end of checkQueryTypeInMetaData
    
    /********************************************************************************
    Method Name : checkQueryTypeInMetaDataRISK
    description : Verify if the passed query type is available for RISK
    Parameters : case record, error message
    Return Type:  Response Message
    *********************************************************************************/
        global static List<MyTr_Case_Record_Type_Setting__mdt> checkQueryTypeInMetaDataRISK(String aemQueryType , String businessUnit, String region){
        
        
        List<MyTr_Case_Record_Type_Setting__mdt> mapCaseRecordType = [Select id,Case_Record_Sub_Type__c,Case_Record_Type__c,Case_Type__c,
                                                                      Record_Type_Developer_Name__c,English__c,Symptom__c,Case_Sub_Type__c, Source__c, Diagnosis__c, Region__c,Business_Unit__c, 
                                                                      Query_Category__c from MyTr_Case_Record_Type_Setting__mdt where English__c = : aemQueryType 
                                                                      and Business_Unit__c = : businessUnit and Source__c = 'MyTR' and (Region__c =: region OR Region__c = 'ALL') with SECURITY_ENFORCED];
        
        return mapCaseRecordType;                 
        
    }//end of checkQueryTypeInMetaData
    
    
    /********************************************************************************
    Method Name : populateCommonFields
    description : populates common fields on the case record
    Parameters : case record, associated contact, AEM case details
    Return Type:  case record
    *********************************************************************************/
    global static Case populateCommonFields(Case newCase, List<Contact> associatedContact,CaseDetailsWrapper aemCase,
                                            MyTr_Case_Record_Type_Setting__mdt sfdcQuery ,Map<String,String> requestParameters){
                                                
      if(MTRCommonUtility.userSettings('SYSTEM',requestParameters.get('business')) != ''){
         switch on MTRCommonUtility.userSettings('SYSTEM',requestParameters.get('business')){
         when 'S2E' {  
                    newCase.Sales_Org__c =  associatedContact[0].Account.Sales_Org__c;
                    newCase.Is_GLI__c = false;
               }
        when 'GLI'{
                  List<Source_System_Detail__c> associatedGLiAccount = [select id from Source_System_Detail__c  
                                                                        where Source_System_Account_Number__c =: aemCase.sapAccountNumber WITH SECURITY_ENFORCED ];
                                                            
                  if(associatedGLiAccount != null && associatedGLiAccount.size() > 0){
                    newCase.LCRM_Account_SSD__c = associatedGLiAccount[0].id; // GLI SSD Account
                    newCase.Is_GLI__c = true;
                  }
             }    
        }
      }
                                                
        Integer maxSize = 255;
        String formURL = aemCase.currentFormURL;
        if(formURL !=null && formURL.length() >= maxSize ){
          formURL = formURL.substring(0, maxSize);
        }
        newCase.ESC_Origin_Name__c = formURL;
        newCase.Origin = MTRCommonUtility.MYTR_ORIGIN;       
        newCase.contactId = associatedContact[0].id;
        newCase.AccountId  = associatedContact[0].AccountId;       
        if(aemCase.country != '' || aemCase.country != null){
          newCase.ESC_Country__c = aemCase.country;
        }   
        newCase.ESC_Unique_Identifier__c = MTRCommonUtility.MYTR_ESC_UNIQUE_IDENTIFIER;
        newCase.ESC_Geographic_Impact__c = MTRCommonUtility.MYTR_ESC_GEOGRAPHIC_IMPACT;
        newCase.SuppliedPhone = aemCase.phoneNumber;
        newCase.MYTR_Query_Type__c = aemCase.queryType;
        newCase.MYTR_Category__c = aemCase.queryCategory;
        populateFieldsBasedOnRecordType(newCase,sfdcQuery);
                                                
        if(!String.isBlank(aemCase.description)){ 
           newCase.description = aemCase.description;
        }//end of description
                                                
        if(!String.isBlank(aemCase.subject)){
           newCase.subject = aemCase.subject;
        }//end of subject
                                                
        return newCase ;
    }//end of populateCOmmonFields
    
    /********************************************************************************
    Method Name : populateLATAMFields
    description : populates LATAM specific fields on case record
    Parameters : case record
    Return Type:  case record
    *********************************************************************************/
    global static Case populateLATAMFields(Case newCase, CaseDetailsWrapper aemCase){
        Case currentCase = newCase;
        
        if(!String.isBlank(aemCase.product)){
            currentCase.Product__c = aemCase.product;
        }
        
        currentCase.LCRM_Sub_BU__c = 'GGO';
        
        return currentCase ;
    }//end of populate LATAMFields
    
    /********************************************************************************
    Method Name : populateLEGALFields
    description : populates Legal specific fields on case record
    Parameters : case record
    Return Type:  case record
    *********************************************************************************/
    global static Case populateLEGALFields(Case newCase, CaseDetailsWrapper aemCase){
        
        Case currentCase = newCase;
        
        currentCase.LCRM_Sub_BU__c = 'USL';
        return currentCase ;
    }//end of populateLEGALFields
    
    /********************************************************************************
    Method Name : populateRISKFields
    description : populates RISK specific fields on case record
    Parameters : case record, Wrapper class
    Return Type:  case record
    *********************************************************************************/
    global static Case populateRISKFields(Case newCase, CaseDetailsWrapper aemCase){
        
        Case currentCase = newCase;
        //Populate product details
        String productName= (aemCase.product !=null) ? aemCase.product :'' ;
        currentCase.ESC_Product_Segment_Brand__c = 'Risk';
        if(productName.contains('/')){
            List<String> productDetails = productName.split('/');
            currentCase.ESC_Product_Title__c = productDetails[0];
            currentCase.ESC_Product_Feature_Module__c = productDetails[1];
        }else{
            currentCase.ESC_Product_Title__c = aemCase.product;
        }
        
        //Populate Risk specific fields
        if(!String.isBlank(aemCase.severity)){
            currentCase.ESC_Severity__c = aemCase.severity;
        }
        if(!String.isBlank(aemCase.impact)){
            currentCase.ESC_Impact__c = aemCase.impact;
        }    
        if(!String.isBlank(aemCase.billingAccNum)){
            currentCase.USL_SAP_Account_Number__c = aemCase.billingAccNum;
        }
        if(!String.isBlank(aemCase.invoiceNumber)){
            currentCase.ESC_Invoice_Numbers__c = aemCase.invoiceNumber;
        }
        if(!String.isBlank(aemCase.dispatchRefNum)){
            currentCase.GLI_Despatch_Reference__c = aemCase.dispatchRefNum;
        }
        if(!String.isBlank(aemCase.preferredContactMethod)){
            currentCase.ESC_Preferred_Contact_Method__c = aemCase.preferredContactMethod;
            
            if(!String.isBlank(aemCase.alternateEmail)){
                currentCase.SuppliedEmail = aemCase.alternateEmail;
            }
        }
        
        return currentCase ;
    }//end of populateRISKFields
    
    /********************************************************************************
    Method Name : retrieveRegionSegmentData
    description : populates RISK specific Region & Segment on case record
    Parameters :  Account Region, Query Category, Business Unit
    Return Type:  List<MTR_Case_Region_and_Segment__mdt> record
    *********************************************************************************/
    global static List<MTR_Case_Region_and_Segment__mdt> retrieveRegionSegmentData(String accRegion,String queryCategory,String bu){
        
        List<MTR_Case_Region_and_Segment__mdt> lstCaseRegionSegment= new List<MTR_Case_Region_and_Segment__mdt>();
        
        //productQuery decides whether the case queryType relatd to Product or non-product
        Boolean productQuery= (queryCategory!=null && queryCategory.contains('Product'))?true:false;
        lstCaseRegionSegment= [select Account_Region__c,Business_Unit__c,Case_Region__c,
                               Case_Segment__c,Product_Query__c from MTR_Case_Region_and_Segment__mdt
                               where Account_Region__c=:accRegion and Product_Query__c=:productQuery
                               and Business_Unit__c=:bu WITH SECURITY_ENFORCED];
        
        return lstCaseRegionSegment;
    }//end of retrieveRegionSegmentData
    
    /********************************************************************************
    Method Name : populateRegionSegment
    description : populates Case Region & Segment
    Parameters :  Case record, Contact record,MTR_Case_Region_and_Segment__mdt record
    Return Type:  case record
    *********************************************************************************/    
    
    global static Case populateRegionSegment(Case newCase,Contact con,MTR_Case_Region_and_Segment__mdt regionSegment){
        //DM: Have one return statement and also opitimize the number of lines in else if condition
        Case currentCase = newCase;
        
        if((regionSegment.Case_Region__c != null || regionSegment.Case_Region__c != '') && regionSegment.Case_Region__c =='INHERIT'){
            
            //map region & segment values from Contact's related Account
            currentCase.LCRM_Sub_BU__c = con.Account.BU_Region__c;
            currentCase.BU_Segment__c = con.Account.BU_Segment__c;
            return currentCase;    
            
        }else if(regionSegment.Case_Region__c != null || regionSegment.Case_Region__c != ''){
            
            //map region & segment from MTR_Case_Region_and_Segment metadata
            if(regionSegment.Case_Segment__c != null || regionSegment.Case_Segment__c != ''){
                currentCase.LCRM_Sub_BU__c = regionSegment.Case_Region__c;
                currentCase.BU_Segment__c = regionSegment.Case_Segment__c;
                return currentCase; 
            }else{
                currentCase.LCRM_Sub_BU__c = regionSegment.Case_Region__c;
                return currentCase; 
            }
        }
        
        return currentCase;
    }//end of populateRegionSegment
    
    /********************************************************************************
    Method Name : populateTAXFields
    description : populates Tax specific fields on case record
    Parameters : case record
    Return Type:  case record
    *********************************************************************************/
    global static Case populateTAXFields(Case newCase, CaseDetailsWrapper aemCase){
        
        Case currentCase = newCase;
        /*if(!String.isBlank(aemCase.product)){
        Map<String,String> mappingData = getControllingFieldValue('Case','ESC_Product_Title__c');
        currentCase.ESC_Product_Title__c = aemCase.product;
        currentCase.ESC_Product_Segment_Brand__c = mappingData.get(aemCase.product);
        }
        currentCase.LCRM_Sub_BU__c = 'US';
        currentCase.BU_Segment__c = 'Professional Tax';    */    
        return currentCase ;
    }//end of populateTAXFields
    
    /********************************************************************************
    Method Name : populateFieldsBasedOnRecordType
    description : Assigns business unit and sales org values on the case record
    Parameters : case record, businessunit and contact record
    Return Type:  case record
    *********************************************************************************/
    public static Case populateFieldsBasedOnRecordType(Case newCase,MyTr_Case_Record_Type_Setting__mdt sfdcQuery){
        
        Id devRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get(sfdcQuery.Record_Type_Developer_Name__c).getRecordTypeId();
        system.debug('devRecordTypeId---'+devRecordTypeId);
        if(devRecordTypeId != null){
            
            newCase.RecordTypeId = devRecordTypeId;
            newCase.ESC_Case_Type__c = sfdcQuery.Case_Record_Type__c;
            
            if(!String.isBlank(sfdcQuery.Case_Record_Sub_Type__c)){
                newCase.ESC_Case_Sub_Type__c = sfdcQuery.Case_Record_Sub_Type__c;
            }
            if(!String.isBlank(sfdcQuery.Case_Type__c)){
                newCase.ESC_EnquiryType__c = sfdcQuery.Case_Type__c;
            }
            if(!String.isBlank(sfdcQuery.Case_Sub_Type__c)){
                newCase.ESC_Sub_Type__c= sfdcQuery.Case_Sub_Type__c;
            }
            if(!String.isBlank(sfdcQuery.Symptom__c)){
                newCase.ESC_Customer_Symptom__c = sfdcQuery.Symptom__c;
            }
            if(sfdcQuery.Business_Unit__c=='RISK' &&  !String.isBlank(sfdcQuery.Diagnosis__c)){
                newCase.ESC_Diagnosis_Summary__c = sfdcQuery.Diagnosis__c;
            }
        }
        
        return newCase;
    }//end of populateFieldsBasedOnRecordType
    
    /********************************************************************************
    Method Name : getControllingFieldValue
    Description : Retrieve the controlling field and dependent field values as a map of values
    Parameters : Dependent Field Value
    Return Type:  Map of Strings
    *********************************************************************************/ 
    public static Map<String, String> getControllingFieldValue(String objName, String fieldName) {
        
            //Get the details of dependent field and controlling field
            
            /*Schema.SObjectType objType = Schema.getGlobalDescribe().get(objName);
    Map<String,Schema.SObjectField> fieldMap = objType.getDescribe().fields.getMap();
    Schema.SObjectField dependToken = fieldMap.get(fieldName);
    Schema.DescribeFieldResult depend = dependToken.getDescribe();
    Schema.sObjectField controlToken = depend.getController();
    
    system.debug('Here...'+depend );
    if (controlToken == null) {
    return new Map<String, String>();
    }
    
    Schema.DescribeFieldResult control = controlToken.getDescribe();
    List<Schema.PicklistEntry> controlEntries;
    
    //Validate that controlling field is not a boolean
    if(control.getType() != Schema.DisplayType.Boolean) {
    controlEntries = control.getPicklistValues();
    }
    system.debug('controlEntries---'+controlEntries);
    
    String base64map = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';
    Map<String,List<String>> dependentPicklistValues = new Map<String,List<String>>();
    Map<String,String> mapOfDepContVals = new Map<String,String>();
    
    system.debug('depend list....'+ depend.getPicklistValues());
    
    //
    for (Schema.PicklistEntry entry : depend.getPicklistValues()){
    
    if (entry.isActive() && String.isNotEmpty(String.valueOf(((Map<String,Object>) JSON.deserializeUntyped(JSON.serialize(entry))).get('validFor')))) {
    system.debug('In loop....'+JSON.deserializeUntyped(JSON.serialize(entry)));
    List<String> base64chars = String.valueOf(((Map<String,Object>) JSON.deserializeUntyped(JSON.serialize(entry))).get('validFor')).split('');
    system.debug('base...'+base64chars);
    for (Integer index = 0; index < (controlEntries != null ? controlEntries.size() : 2); index++) {
    Object controlValue =
    (controlEntries == null? (Object) (index == 1)
    : (Object) (controlEntries[index].isActive() ? controlEntries[index].getLabel() : null)
    );
    system.debug('COntrol Value...'+controlValue );
    Integer bitIndex = index / 6, bitShift = 5 - Math.mod( index, 6 );
    
    if  (controlValue == null || (base64map.indexOf( base64chars[ bitIndex ] ) & (1 << bitShift)) == 0)
    continue;
    
    system.debug('Dependent Value - Control Value : ' +entry.getLabel()+ '-' +(String) controlValue );
    mapOfDepContVals.put(entry.getLabel(),(String) controlValue);
    
    //system.debug('dependentPicklistValues--'+dependentPicklistValues);
    }
    }
    }*/
            //return mapOfDepContVals;
        return new Map<String,String>();
    }//end of getControllingFieldValue 
    
    
    /********************************************************************************
    Method Name : ResponseMessage
    description : To construct the response of the call
    Parameters : case record, error message
    Return Type:  Response Message
    *********************************************************************************/    
    global static ResponseMessage createResponse(Case currentCase, String errorMsg){
        ResponseMessage objSuccessError = new ResponseMessage();
        if(errorMsg == null){
            Case objCase = [select CaseNumber,Id from Case where Id=:currentCase.Id WITH SECURITY_ENFORCED];
            system.debug('objCase---'+objCase);
            objSuccessError.caseNumber = objCase.CaseNumber;
            objSuccessError.caseId = objCase.Id;
            //objSuccessError.caseNumber = currentCase.casenumber;
            //objSuccessError.caseId = currentCase.id;
            objSuccessError.statusCode = '200';
            objSuccessError.isSuccess = true;
        }else{
            objSuccessError.statusCode = '400';
            objSuccessError.isSuccess = false;
            objSuccessError.errorMessage = errorMsg;
        }
        
        system.debug('objSuccessError---'+objSuccessError);
        return objSuccessError;
    }
    
    //Response Structure
    global class ResponseMessage{
        public string statusCode;
        public string errorMessage;
        public Boolean isSuccess;
        public string caseNumber;
        public string caseId;
    }
    //Inner Class Declarations
    //DM : Added more parameters for Risk
    global class CaseDetailsWrapper{
        public string sapAccountNumber;
        public string contactId;
        public string subject;
        public String phoneNumber;
        public String description;
        public String queryType;
        public string product;
        public String isoCountrycode;
        public String currentFormURL;
        public String country;
        public String queryCategory;
        public String severity;
        public String impact;
        public String preferredContactMethod;
        public String billingAccNum;
        public String invoiceNumber;
        public String dispatchRefNum;
        public String alternateEmail;
        
    }//end ofcaseDetailsWrapper
    
}