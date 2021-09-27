/********************************************************************************
Class Name : UECaseManagementHelper
@description : This is the Helper clas used by UE for case management. 
              This class holds the helper methods for UE case management
********************************************************************************
Modification Details:
Date                    description                          Owner
29/09/2020              Created                              Deepika Motamarri
06/14/2021              Created a new method ueValidation()  Deepthi KB
                        Added logic to validated supported
                        locales for given BU, DUE-9614
23/05/2021              Added logic for populate proactive type     Saravana Kumar
                        for UKI records(specific reasons)
*********************************************************************************/
public without sharing class UECaseManagementHelper {
    
    public static MyTr_Case_Record_Type_Setting__mdt reasonDetails;
        
    /********************************************************************************
    @description  populates Business specific fields on case record which are configured in custom meta data
    @param newCase
    @param aemCase
    @return Case
    *********************************************************************************/
    public static Case populateConfiguredFields(Case newCase, UECaseManagementInnerClasses.CaseDetailsWrapper aemCase){
        
        List<MTR_Case_Region_and_Segment__mdt> listCaseRegionSegment = new List<MTR_Case_Region_and_Segment__mdt>();
        
        listCaseRegionSegment = [select Case_Region__c,Product_Field_Type__c,Case_Segment__c
            from MTR_Case_Region_and_Segment__mdt where Account_Region__c='' AND Product_Query__c = false
            AND Business_Unit__c=:UECaseManagementService.businessUnit WITH SECURITY_ENFORCED limit 1];
            
        Case currentCase = newCase;
        
        if(!listCaseRegionSegment.isEmpty()){
           
            
            //need to check empty
            if(!String.IsBlank(listCaseRegionSegment[0].Case_Region__c)){
                currentCase.LCRM_Sub_BU__c = listCaseRegionSegment[0].Case_Region__c;
            }
            if(!String.IsBlank(listCaseRegionSegment[0].Case_Segment__c)){
                currentCase.BU_Segment__c= listCaseRegionSegment[0].Case_Segment__c;
            }
            if(!String.IsBlank(aemCase.product)){
                currentCase = populateProductField(currentCase,listCaseRegionSegment[0].Product_Field_Type__c,aemCase.product);    
            } 
        }   
         return currentCase;

    }//end of populateConfiguredFields
    /*******************************************************************************
    Method Name: ueValidation()
    @description This method is used to validate UE parameters
    @param aemCase
    @return UECaseManagementResponseClasses.CreateCaseResponse
    ********************************************************************************/
    public static UECaseManagementResponseClasses.CreateCaseResponse ueValidation(UECaseManagementInnerClasses.CaseDetailsWrapper aemCase){
        Case insertCase = new Case();
        List<Contact> currentContact=new List<Contact>();
        String supLocale;
        UECaseManagementResponseClasses.CreateCaseResponse reponseCaseCreation;
        
        //Validate supported locales for the given BU
        supLocale=MTRCommonUtility.userSettings('SUPPORTEDLOCALE',aemCase.language);
        //system.debug('locales...'+supLocale);
        //system.debug('locales 2...'+supLocale.CONTAINS(aemCase.language));
        if(!(supLocale.CONTAINS(aemCase.language))){
            reponseCaseCreation = UECaseManagementService.createResponse(null, MTRCommonUtility.UNSUPPORTED_LANGUAGE+' -'+aemCase.language);   
            return reponseCaseCreation ;
        }

        //Verify if the contact id is passed and it exists
        currentContact = [select id,name,AccountId,Account.Sales_Org__c,Account.BU_Region__c,Account.Bu_Segment__c from Contact 
                            where Id =: aemCase.contactId  WITH SECURITY_ENFORCED LIMIT 1];
        //Return error if contact does not exist
        if(currentContact.IsEmpty()){
            reponseCaseCreation = UECaseManagementService.createResponse(null, MTRCommonUtility.INVALID_CONTACT+' -'+aemCase.contactId);
            return reponseCaseCreation ;
        }

        //Verify if the account ssd is passed and it exists
        List<Source_System_Detail__c> listAssociatedGLiAccount = [select id from Source_System_Detail__c where Source_System_Account_Number__c =: aemCase.sapAccountNumber WITH SECURITY_ENFORCED limit 1];
            //Return error if contact does not exist
            if(listAssociatedGLiAccount.IsEmpty()){
                reponseCaseCreation = UECaseManagementService.createResponse(null, MTRCommonUtility.SSD_NOT_AVAILABLE+' -'+aemCase.sapAccountNumber);
                return reponseCaseCreation ;
            }

        //validate QueryTyep - Return error for invaid QueryType 
        reponseCaseCreation = validateMetadata(aemCase.ReasonID);
        //system.debug(LoggingLevel.DEBUG,'reponseCaseCreation---'+reponseCaseCreation);
        if((reponseCaseCreation!=null) && (reponseCaseCreation.statusCode=='400')){
            return reponseCaseCreation;
        } 
        insertCase = populateUECommonFields(currentContact,aemCase, listAssociatedGLiAccount);
        insertCase = populateFieldsBasedOnRecordType(insertCase,UECaseManagementService.operationValue);
                     
        //Populate BU specific values
        insertCase = populateConfiguredFields(insertCase, aemCase);
        //insert a case
        if(Schema.sObjectType.Case.isAccessible() || Schema.sObjectType.Case.isCreateable()){
            insert insertCase ;
        }
        //return case creation success message
        reponseCaseCreation = UECaseManagementService.createResponse(insertCase,null);  
        return reponseCaseCreation;         
    } //end of ueValidation
    
    /********************************************************************************
    @description  populates product field 
    @param newCase
    @param productFieldType
    @param product
    @return Case
    *********************************************************************************/
    public static Case populateProductField(Case newCase,String productFieldType,String product){
        
        switch on productFieldType{
            when 'Standard Field'{
                List<Product2> listProduct = new List<Product2>();
                listProduct = [Select id from Product2 where name =:product with SECURITY_ENFORCED limit 1];
                if(!listProduct.isEmpty()){
                    newCase.ProductId = listProduct[0].id;
                }
            }
            when 'Product Segment/Brand'{
                List<String> listTempString = new list<String>();
                listTempString = product.split('\\|');
                if(!listTempString.isEmpty() && listTempString.size() == 3){
                    newCase.ESC_Product_Segment_Brand__c = listTempString[0];
                    newCase.ESC_Product_Feature_Module__c = listTempString[1]; // Comtrolling field  is ESC_Product_Title__c
                    newCase.ESC_Product_Title__c = listTempString[2]; // controlling field is ESC_Product_Segment_Brand__c
                }

            }           
        }
        return newCase;  
    }  

  
    /********************************************************************************
    @description  populates common fields on the case record for UE
    @param associatedContact
    @param aemCase
    @param listAssociatedGLiAccount
    @return Case
    *********************************************************************************/
    public static Case populateUECommonFields(List<Contact> associatedContact,UECaseManagementInnerClasses.CaseDetailsWrapper aemCase, List<Source_System_Detail__c> listAssociatedGLiAccount){
        Case newCase = new case();

        switch on MTRCommonUtility.userSettings('SYSTEM',UECaseManagementService.businessUnit){
            
            when 'GLI'{                
                if(!listAssociatedGLiAccount.isEmpty()){
                    newCase.LCRM_Account_SSD__c = listAssociatedGLiAccount[0].id; // GLI SSD Account
                    newCase.USL_SAP_Account_Number__c = aemCase.sapAccountNumber;
                    newCase.Is_GLI__c = true;
                }
            }       
        }//switch case for S2E/GLI
    
                
        Integer maxSize = 255;
        String formURL = aemCase.currentFormURL;
        if(formURL !=null && formURL.length() >= maxSize ){
        formURL = formURL.substring(0, maxSize);
        }
        newCase.ESC_Origin_Name__c = formURL;        
        newCase.Origin = Label.UE_Account;
        newCase.ESC_Unique_Identifier__c = MTRCommonUtility.UE_ESC_UNIQUE_IDENTIFIER;
        newCase.contactId = associatedContact[0].id;
        newCase.AccountId  = associatedContact[0].AccountId; 
        newCase.SuppliedPhone = aemCase.phoneNumber;
        newCase.SuppliedEmail = aemCase.alternateEmail;
        newCase.MYTR_Query_Type__c = aemCase.queryType;
        newCase.MYTR_Category__c = aemCase.queryCategory;
        newCase.UE_Reason_Code__c = aemCase.reasonID;
        newCase.UE_Category_Code__c = aemCase.categoryCode;
        newCase.UE_Language_Locale__c = aemCase.language;
                
        if(!String.isBlank(aemCase.description)){ 
            newCase.description = aemCase.description;
        }//end of description
                
        if(!String.isBlank(aemCase.subject)){
            newCase.subject = aemCase.subject;
        }//end of subject
                
        return newCase ;
    }//end of populateUECommonFields
    
      /********************************************************************************
      Method Name : checkQueryTypeInMetaData
     @description : Retrieve the Reason record from meatdata
     @param reasonId
     @param businessUnit
     @return list<MyTr_Case_Record_Type_Setting__mdt>
     *********************************************************************************/
    public static list<MyTr_Case_Record_Type_Setting__mdt> checkQueryTypeInMetaData(String reasonId , String businessUnit){
         
        // DUE-7463:Updated SOQL(condition) to checkQueryTypeInMetaData based on 'reasonID' instead of 'queryType'-DKB
        // DUE-9615: Added Proactive_type__c field in SOQL query and added logic to retrieve UKI records for specific reasons -Saravana
        list<MyTr_Case_Record_Type_Setting__mdt> mapCaseRecordType = [Select id,Case_Record_Sub_Type__c,Case_Record_Type__c,Case_Type__c,
                                                                    Record_Type_Developer_Name__c,English__c,Reason_Code__c,Symptom__c,Case_Sub_Type__c, Source__c,Business_Unit__c,Proactive_Type__c
                                                                    from MyTr_Case_Record_Type_Setting__mdt where Reason_Code__c = : reasonId
                                                                    and (Business_Unit__c = : businessUnit OR Business_Unit__c = 'ALL') and Source__c = 'UE' WITH SECURITY_ENFORCED LIMIT 2];
        
       if(mapCaseRecordType.size()>1)
        {
            list<MyTr_Case_Record_Type_Setting__mdt> mapCaseRecordType1=new list<MyTr_Case_Record_Type_Setting__mdt>();
           for(MyTr_Case_Record_Type_Setting__mdt temp : mapCaseRecordType )  
            {
                if(temp.Business_Unit__c==businessUnit)
                {
                    mapCaseRecordType1.add(temp);
                    return mapCaseRecordType1;
                }
            }
        }           
        return mapCaseRecordType;
    }//end of checkQueryTypeInMetaData
       
     /********************************************************************************
      Method Name : validateMetadata
     @description : This method is used to validate case data with mata data in salesforce
     @param reasonId
    @return UECaseManagementResponseClasses.CreateCaseResponse
     *********************************************************************************/
    public static UECaseManagementResponseClasses.CreateCaseResponse validateMetadata(String reasonId){
     
        list<MyTr_Case_Record_Type_Setting__mdt> listSfdcQuery= new list<MyTr_Case_Record_Type_Setting__mdt>();
        reasonDetails = new MyTr_Case_Record_Type_Setting__mdt();
        UECaseManagementResponseClasses.CreateCaseResponse reponseCaseCreation;
        // validate Query type is available in metadata or not
        
        //DUE-7463: Added reasonId request parameter for 'checkQueryTypeInMetaData'- DKB
        if(!String.isBlank(reasonId)){
            listSfdcQuery = checkQueryTypeInMetaData(reasonId ,UECaseManagementService.businessUnit);
        }else{
           reponseCaseCreation = UECaseManagementService.createResponse(null, MTRCommonUtility.REASON_CODE_NOT_PROVIDED);
            return reponseCaseCreation;
        }    

        //Return error if query metadata is not available       
        if(!listSfdcQuery.IsEmpty()){
            reasonDetails  = listSfdcQuery[0];
        }else{
           reponseCaseCreation = UECaseManagementService.createResponse(null, MTRCommonUtility.QUERY_TYPE_MISSING );
            return reponseCaseCreation;
        }
        //system.debug(LoggingLevel.DEBUG,'reponseCaseCreation---'+reponseCaseCreation);
        return reponseCaseCreation;
    }//end of validateMetadata
      /********************************************************************************
      Method Name : populateFieldsBasedOnRecordType
     @description : Assigns business unit and sales org values on the case record
     @param newCase
     @param operationValue
     @return Case reasonDetails
     *********************************************************************************/
    public static Case populateFieldsBasedOnRecordType(Case newCase, String operationValue){

        switch on operationValue{
            when 'CREATECASE'{
                Id devRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Unified_Account').getRecordTypeId();
               
                newCase.RecordTypeId = devRecordTypeId;
            }
            when 'UPDATERECORDTYPE'{   
                  
                Id devRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get(reasonDetails.Record_Type_Developer_Name__c).getRecordTypeId();
                newCase.RecordTypeId = devRecordTypeId;
                
                if(devRecordTypeId != null){
            
                    newCase.RecordTypeId = devRecordTypeId;
                    newCase.ESC_Case_Type__c = reasonDetails.Case_Record_Type__c;
                    newCase.ESC_Proactive_Type__c= reasonDetails.Proactive_Type__c;
                    
                    if(!String.isBlank(reasonDetails.Case_Record_Sub_Type__c)){
                        newCase.ESC_Case_Sub_Type__c = reasonDetails.Case_Record_Sub_Type__c;
                    }
                    if(!String.isBlank(reasonDetails.Case_Type__c)){
                        newCase.ESC_EnquiryType__c = reasonDetails.Case_Type__c;
                    }
                    if(!String.isBlank(reasonDetails.Case_Sub_Type__c)){
                        newCase.ESC_Sub_Type__c= reasonDetails.Case_Sub_Type__c;
                    }      
                }
            }//end of condition
        }//end of switch
        return newCase;
    }//end of populateFieldsBasedOnRecordType
 }