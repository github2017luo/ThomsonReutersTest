/*******************************************************************************
Class Name : UECaseManagementResponseClasses
@description : This class encloses response structures used for 
                for various operations supported by UE case management service
********************************************************************************
Modification Details:
Date                    description                       Owner
29/09/2020              Created                           Deepika Motamarri
*********************************************************************************/
global with sharing class UECaseManagementResponseClasses {
     /********************************************************************************
   Class Name : CreateCaseResponse
   @description : Create a Response for CREATECASE Operation
   *********************************************************************************/ 
    //Response Structure
    global class CreateCaseResponse{
        
        public string errorMessage;
        public Boolean isSuccess;
        public string caseNumber;
        public string caseId;
        /** @description status code */
        public string statusCode{get;set;}
    }
    
     /********************************************************************************
   Class Name : DeleteFeedResponseMessage
   @description : Response Structure for DELETEATTACHMENT Operation
   *********************************************************************************/ 
  /*
   public class DeleteFeedResponseMessage{
    public string statusCode;
    public string message;
    public Boolean isSuccess;
    }  
  */
  //end of DeleteFeedResponseMessage

}