/********************************************************************************
Class Name : UECaseManagementService
@description : This class acts as the REST service for case management in Unified Account.
This supports 2 operations and multiple business units
***********************************************************************************************************
Modification Details:
Date                    description                          Owner
25/06/2020              Created                              Herin Acharya
22/06/2020              Added logic for Delete Attachment    Herin Acharya
29/09/2020              Added logic for Case Creation        Deepika Motamarri
13/01/2021              Updated CREATECASE,UPDATERECORDTYPE  Deepthi KB
                        logic to derive the mapping based
                        on the ‘ReasonID’: DUE-7463
10/02/2021              Updated CREATECASE,UPDATERECORDTYPE  Herin Acharya
                        logic to derive the mapping based
                        on the ‘categoryReasonCode’: DUE-8538
06/04/2021              Moved some create Case validations to 
                        method:UECaseManagementHelper.ueValidation();   Deepthi KB
                        
*********************************************************************************/

@RestResource(urlMapping='/UECaseManagementService/*')
global without sharing class UECaseManagementService{ 

    //Declare varibales
    global static boolean myTRCase;
    
    global static List<Contact> currentContact;
    global static UECaseManagementResponseClasses.CreateCaseResponse reponseCaseCreation;
    global static String businessUnit;
    global static String source;
    global static String operationValue;
    
  
    /********************************************************************************
    Method Name : deleteServices
    @description : delete Attachments
    @return UECaseManagementResponseClasses.deleteFeedResponseMessage
    *********************************************************************************/
    
   /* Commenting out Delete Service to Deploy DUE-8538
    @HttpDelete
    global static UECaseManagementResponseClasses.deleteFeedResponseMessage deleteServices(){
        
        UECaseManagementResponseClasses.deleteFeedResponseMessage reponseDeleteAttach;
        
        try{ 
            RestRequest req = RestContext.request;
            Map<String,String> requestParameters = req.params;
            
            //Checking if Operation parameter is present with exact value "DELETEATTACHMENT" | If not send error message
            if(string.isBlank(requestParameters.get('operation')) || requestParameters.get('operation') != 'DELETEATTACHMENT'){
                
                reponseDeleteAttach = deleteResponse(MTRCommonUtility.INVALID_OPERATION +':'+requestParameters.get('operation'));
                return reponseDeleteAttach;
            }
            
            //Deserialising json using wrapper class
            UECaseManagementInnerClasses.deleteFeedWrapper objFeedDetails = (UECaseManagementInnerClasses.deleteFeedWrapper)System.JSON.deserialize
                        (RestContext.request.requestBody.tostring(),UECaseManagementInnerClasses.deleteFeedWrapper.class);
            
            reponseDeleteAttach = UECaseManagementDeleteHelper.validateDeleteAttachConditions(objFeedDetails);
            
            return reponseDeleteAttach;
            
        }catch(Exception ex){
            ApplicationLogUtility.logException('Unified Account' , 'UECaseManagementService' , 'deleteServices' , ex);
            reponseDeleteAttach = deleteResponse(ex.getStackTraceString());  
            return reponseDeleteAttach;          
        }
        
    }
    */ 
    //end of deleteServices

    /********************************************************************************
    Method Name : deleteFeedResponseMessage
    @description : Create a Response of DELETEATTACHMENT service
    @param errorMsg
    @return UECaseManagementResponseClasses.deleteFeedRes
    *********************************************************************************/ 
    
    /*
    global static UECaseManagementResponseClasses.deleteFeedResponseMessage deleteResponse(String errorMsg){
        
        UECaseManagementResponseClasses.deleteFeedResponseMessage reponseDeleteAttach = new UECaseManagementResponseClasses.deleteFeedResponseMessage();
        if(errorMsg == null){
            reponseDeleteAttach.statusCode = '200';
            reponseDeleteAttach.isSuccess = true;
            reponseDeleteAttach.Message = 'Attachment Deleted Successfully'; 
        }else{
            reponseDeleteAttach.statusCode = '400';
            reponseDeleteAttach.isSuccess = False;
            reponseDeleteAttach.Message = errorMsg;
        }
        
        return reponseDeleteAttach;
    }*/
    //end of deleteFeedResponseMessage   
    
   /************************************** END of deleteServices *******************************************/

    /********************************************************************************
    Method Name : postServices
    @description : Retrieve case Details
    @return UECaseManagementResponseClasses.CreateCaseResponse
    *********************************************************************************/
    
    @HttpPost
    global static UECaseManagementResponseClasses.CreateCaseResponse postServices(){               
        try{ 
            RestRequest req = RestContext.request;
            Map<String,String> requestParameters = req.params;
            //Intialize this variable to true as it is an identifier for cases
            //cretaed from Digital
            myTRCase = true;
            operationValue = requestParameters.get('operation');  

                switch on operationValue{
                    when 'CREATECASE'{ 
                        //Validate Source parameter
                        if(!requestParameters.containskey('source') || String.IsBlank(requestParameters.get('source'))){
                            reponseCaseCreation = createResponse(null, MTRCommonUtility.SOURCE_MISSING);
                            return reponseCaseCreation;
                        }
                        //validate BU
                        if(!(requestParameters.containskey('business') && !String.IsBlank(requestParameters.get('business'))  && MTRCommonUtility.userSettings('BUSINESSUNIT',requestParameters.get('business')) == 'VALID')){
                            reponseCaseCreation = createResponse(null, MTRCommonUtility.INVALID_BU +' -'+requestParameters.get('business'));
                            return reponseCaseCreation;
                        }
        
                        source = requestParameters.get('source');                    
                        businessUnit = requestParameters.get('business');  
        
                        //Create Case if no errror found
                        return reponseCaseCreation = createCase();
                    }
                    when 'UPDATERECORDTYPE'{
                        businessUnit = requestParameters.get('business');
                        //DUE-7463: Added reasonId request parameter for 'updateCaseDetails'- DKB
                        
                        reponseCaseCreation = updateCaseDetails(requestParameters.get('casenumber'),requestParameters.get('reasonid'));
                        return reponseCaseCreation;
                    }
                    when else{
                        reponseCaseCreation = createResponse(null,MTRCommonUtility.INVALID_OPERATION +':'+operationValue);
                        return reponseCaseCreation;
                    }
                }
                       
        }catch(Exception ex) {
            ApplicationLogUtility.logException('Unified Account' , 'UECaseManagementService' , 'postServices' , ex);
            reponseCaseCreation = createResponse(new Case(),ex.getStackTraceString());
            return reponseCaseCreation;
        }//end of catch

        //return   reponseCaseCreation;   
    }//end of postServices 
    
     /********************************************************************************
     Method Name : createCase
     @description : The case creation logic
     @return UECaseManagementResponseClasses.CreateCaseResponse
     *********************************************************************************/
     global static UECaseManagementResponseClasses.CreateCaseResponse createCase(){
         RestRequest req = RestContext.request;
         Map<String,String> requestParameters = req.params;                                        
         Case currentCase = new Case();
         businessUnit = requestParameters.get('business');
                
         try{
            //Retrieve the AEM Case Details
            UECaseManagementInnerClasses.CaseDetailsWrapper aemCase = 
            (UECaseManagementInnerClasses.CaseDetailsWrapper)System.JSON.deserialize(RestContext.request.requestBody.tostring(),UECaseManagementInnerClasses.CaseDetailsWrapper.class);
                     
            //Return error if requets is not in proper format 
            if(aemCase ==null){
                reponseCaseCreation = createResponse(null, MTRCommonUtility.IMPROPER_REQUEST_FORMAT );
                return reponseCaseCreation;
            }
            //populate the common fields for the case
             switch on source{

                when 'UE'{
                    reponseCaseCreation= UECaseManagementHelper.ueValidation(aemCase);
                    
                } //end of UE condition
             }                
         }catch(Exception ex) {                
             //Log the error 
             ApplicationLogUtility.logException('Unified Account' , 'UECaseManagementService' , 'createCase' , ex);
             return createResponse(currentCase,ex.getStackTraceString());                                       
         }//end of catch

         return reponseCaseCreation;
     }//end of createCase

     /********************************************************************************
      Method Name : createResponse
     @description : To construct the response of the  create case API
     @param currentCase
     @param errorMsg
     @return UECaseManagementResponseClasses.CreateCaseResponse
     *********************************************************************************/    
     global static UECaseManagementResponseClasses.CreateCaseResponse createResponse(Case currentCase, String errorMsg){
        UECaseManagementResponseClasses.CreateCaseResponse reponseCaseCreation = new UECaseManagementResponseClasses.CreateCaseResponse();
 
         if(errorMsg == null){            
             Case objCase = [select CaseNumber,Id from Case where Id=:currentCase.Id WITH SECURITY_ENFORCED];
             
             reponseCaseCreation.caseNumber = objCase.casenumber;
             reponseCaseCreation.caseId = objCase.id;
             reponseCaseCreation.statusCode = '200';
             reponseCaseCreation.isSuccess = true;
         }else{
            reponseCaseCreation.statusCode = '400';
            reponseCaseCreation.isSuccess = false;
            reponseCaseCreation.errorMessage = errorMsg;
         }
         return reponseCaseCreation;
     }//end of createResponse

     /********************************************************************************
    @description : This method updates record type and related fiels
    @param caseNumber
    @param reasonID
    @return UECaseManagementResponseClasses.CreateCaseResponse
    *********************************************************************************/
    public static UECaseManagementResponseClasses.CreateCaseResponse updateCaseDetails(String caseNumber,String reasonID){

        Case updateCase = new Case();
        
        try{//Verify if the case id passed exists or not
            List<Case> retrieveCase = [select id,caseNumber, UE_Reason_Code__c from Case 
                        where caseNumber =: caseNumber with SECURITY_ENFORCED LIMIT 1];
                        
           system.debug(LoggingLevel.DEBUG,'retrieveCase---'+retrieveCase ); 
            //Return error if contact does not exist
            if(retrieveCase.IsEmpty()){
                return reponseCaseCreation = createResponse(null, MTRCommonUtility.INVALID_CASE);
            }         
            
            if(!retrieveCase.IsEmpty() && retrieveCase[0].UE_Reason_Code__c != reasonID){
                reponseCaseCreation = createResponse(null, MTRCommonUtility.INCORRECT_REASONID);
                return reponseCaseCreation ;
            }
            
            //validate QueryTyep - Return error for invaid QueryType 
            reponseCaseCreation = UECaseManagementHelper.validateMetadata(reasonID);
            system.debug(LoggingLevel.DEBUG,'reponseCaseCreation---'+reponseCaseCreation);
            if(reponseCaseCreation != null && reponseCaseCreation.statusCode == '400'){
                return reponseCaseCreation;
            }
            
            updateCase = UECaseManagementHelper.populateFieldsBasedOnRecordType(retrieveCase[0],operationValue);
            
            //update updateCase;
            
            if(Schema.sObjectType.Case.isAccessible() || Schema.sObjectType.Case.isUpdateable()){
                 update updateCase;
             }
              
             //return case creation success message
             reponseCaseCreation = createResponse(updateCase,null); 

            return reponseCaseCreation;
        }catch(Exception ex) {                
            //Log the error 
            ApplicationLogUtility.logException('Unified Account' , 'UECaseManagementService' , 'updateCaseDetails' , ex);
            reponseCaseCreation= createResponse(updateCase,ex.getStackTraceString());
            return reponseCaseCreation;                                       
        }//end of catch
    }//updateCaseDetails
     
  
}