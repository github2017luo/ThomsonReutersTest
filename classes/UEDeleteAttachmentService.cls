/********************************************************************************
Class Name : UEDeleteAttachmentService
@description : This class acts as the REST service for delete attachment on cases in Unified Account.

***********************************************************************************************************
Modification Details:
Date                    description                          Owner
26/05/2021              Created                              Deepthi KB
                        new end point for Delete attachment
                        Jira #: DUE-10968
*********************************************************************************/

@RestResource(urlMapping='/UEDeleteAttachmentService/*')
global without sharing class UEDeleteAttachmentService{

// Declare variables
//global static UECaseManagementResponseClasses.deleteFeedResponseMessage reponseDeleteAttach;
    
/********************************************************************************
Method Name : deleteServices
@description : delete Attachments
@return DeleteFeedResponseMessage
*********************************************************************************/
    
@HttpDelete
global static DeleteFeedResponseMessage deleteServices(){
        
    DeleteFeedResponseMessage reponseDeleteAttach;
        
    try{ 
        RestRequest req = RestContext.request;
        Map<String,String> requestParameters = req.params;
            
        //Checking if Operation parameter is present with exact value "DELETEATTACHMENT" | If not send error message
        if(string.isBlank(requestParameters.get('operation')) || requestParameters.get('operation') != 'DELETEATTACHMENT'){
                
            reponseDeleteAttach = deleteResponse(MTRCommonUtility.INVALID_OPERATION +':'+requestParameters.get('operation'));
            return reponseDeleteAttach;
        }
            
        //Deserialising json using wrapper class
        DeleteFeedWrapper objFeedDetails = (DeleteFeedWrapper)System.JSON.deserialize
                    (RestContext.request.requestBody.tostring(),DeleteFeedWrapper.class);
            
       reponseDeleteAttach = UECaseManagementDeleteHelper.validateDeleteAttachConditions(objFeedDetails);
            
        return reponseDeleteAttach;
            
    }catch(Exception ex){
        ApplicationLogUtility.logException('Unified Account' , 'UEDeleteAttachmentService' , 'deleteServices' , ex);
        reponseDeleteAttach = deleteResponse(ex.getStackTraceString());  
        return reponseDeleteAttach;          
    }
        
} //end of deleteServices

/********************************************************************************
Method Name : deleteFeedResponseMessage
@description : Create a Response of DELETEATTACHMENT service
@param errorMsg
@return DeleteFeedResponseMessage
*********************************************************************************/ 
    
    
global static DeleteFeedResponseMessage deleteResponse(String errorMsg){
        
   DeleteFeedResponseMessage reponseDeleteAttach = new DeleteFeedResponseMessage();
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
}
    //end of deleteFeedResponseMessage   

    /********************************************************************************
    Class Name : DeleteFeedResponseMessage
    @description : Response Structure for DELETEATTACHMENT Operation
   *********************************************************************************/ 
    global class DeleteFeedResponseMessage{
        public string statusCode;
        public string message;
        public Boolean isSuccess;
    }  

   /********************************************************************************
   Class Name : DeleteFeedWrapper
   @description : Request Structure for DELETEATTACHMENT Operation
   *********************************************************************************/ 
    public class DeleteFeedWrapper{
       public string contentVersionId;
       public string contentDocumentId;
       public string feedItemId;        
   }
   //end of DeleteFeedWrapper   
/************************************** END of deleteServices *******************************************/

}