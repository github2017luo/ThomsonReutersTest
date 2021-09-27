/******************************************************************************
Class Name : UECaseManagementDeleteHelper
@description : This is the helper class for Delete operation
********************************************************************************
Modification Details:
Date                    description                       Owner
29/09/2020              Created                           Deepika Motamarri
*********************************************************************************/
public without sharing class UECaseManagementDeleteHelper {
    /********************************************************************************
       Method Name : deleteServices
       @description : delete Attachments
       @param objFeedDetails
       @return UEDeleteAttachmentService.deleteFeedResponseMessage
       *********************************************************************************/
   
       public static UEDeleteAttachmentService.deleteFeedResponseMessage 
                    validateDeleteAttachConditions(UEDeleteAttachmentService.deleteFeedWrapper objFeedDetails){
           
           UEDeleteAttachmentService.deleteFeedResponseMessage reponseDeleteAttach;
           
           try{ 
               // Checking If all the required parameters are present in the request or not - If not throw error message  
               if(!string.isnotBlank(objFeedDetails.contentVersionId) || 
                   !string.isnotBlank(objFeedDetails.contentDocumentId) || !string.isnotBlank(objFeedDetails.feedItemId)){
                       reponseDeleteAttach = UEDeleteAttachmentService.deleteResponse(MTRCommonUtility.IMPROPER_REQUEST_FORMAT);
                           return reponseDeleteAttach;
               }
               // Query FeedItem with FeedAttachment to delete
               list<feedItem> lstFeedItem = new List<feedItem>();
               lstFeedItem =[ select id,createdby.firstname,createdby.lastname,body,(select Id from feedattachments limit 2)
                   from feeditem where id =: objFeedDetails.feedItemId  WITH SECURITY_ENFORCED LIMIT 10]; 
                
               //If FeedItem is not found with the provided id - throw error 
               if(lstFeedItem.IsEmpty()){
                   reponseDeleteAttach = UEDeleteAttachmentService.deleteResponse(MTRCommonUtility.IMPROPER_REQUEST_FORMAT);
                   return reponseDeleteAttach;
               }
               list<ContentDocument> listCd= [SELECT id,OwnerId,owner.name FROM ContentDocument where id=: objFeedDetails.contentDocumentId  WITH SECURITY_ENFORCED LIMIT 1];

               //if(!(listCd.size()>1))
               if(listCd[0].owner.name!='ESI User'){
                   reponseDeleteAttach = UEDeleteAttachmentService.deleteResponse(MTRCommonUtility.AGENT_FILES_CANNOT_BE_DELETED);
                   return reponseDeleteAttach;
               }               
               
               list<FeedAttachment> lstFeedAttchments = new list<FeedAttachment>();
                       lstFeedAttchments = [select id from FeedAttachment where FeedEntityId =:objFeedDetails.feedItemId 
                           and RecordId=:objFeedDetails.contentVersionId WITH SECURITY_ENFORCED];
               
               if(!lstFeedAttchments.IsEmpty()){  
                   reponseDeleteAttach = deleteRecords(lstFeedItem,objFeedDetails,lstFeedAttchments);  
                   return reponseDeleteAttach;
               }
              
           }catch(Exception ex){
               ApplicationLogUtility.logException('Unified Account' , 'UECaseManagementService' , 'validateDeleteAttachCnditions ' , ex);
               reponseDeleteAttach = UEDeleteAttachmentService.deleteResponse(ex.getStackTraceString()); 
           }
           return reponseDeleteAttach;  
       }//end of validateDeleteAttachConditions
    /******************************************************************************
    Method Name : deleteRecords
    @description  delete Attachments
    @param  lstFeedItem
    @param  objFeedDetails
    @param  lstFeedAttchments
    @return UEDeleteAttachmentService.deleteFeedResponseMessage
    *********************************************************************************/

    public static UEDeleteAttachmentService.deleteFeedResponseMessage deleteRecords(list<feedItem> lstFeedItem, 
                            UEDeleteAttachmentService.deleteFeedWrapper objFeedDetails,list<FeedAttachment> lstFeedAttchments){
        
        UEDeleteAttachmentService.deleteFeedResponseMessage objSuccessError;
        
        
        list<id> toBedeletedRecords = new list<id>();                        
        /*
        Check If body(Comment) is there in the feed or not - If Body is blank and only one feedattachment is left - Delete the feed
        If more than 1 feed attachment is there on the feed - delete feedattachment
        */
        if(lstFeedItem[0].feedattachments.size() == 1 && String.isblank(lstFeedItem[0].body)){
            toBedeletedRecords.add(lstFeedItem[0].id);
        }else{
            toBedeletedRecords.add(lstFeedAttchments[0].id);
        }

        toBedeletedRecords.add(objFeedDetails.contentDocumentId);
        /*
        Used - DataBase.DeleteResult
        Delete all the ids in the "toBedeletedRecords" list - 
        If all the records do not get deleted in one go , roll back all the deleted records
        */
            
        Database.DeleteResult[] drList = Database.delete(toBedeletedRecords ,true);

        for(Database.DeleteResult dr : drList){
            if (!dr.isSuccess()){
                // Operation failed, so get all errors                
                for(Database.Error err : dr.getErrors()) {
                    return UEDeleteAttachmentService.deleteResponse(err.getMessage());
                }
            }
        } 
        objSuccessError = UEDeleteAttachmentService.deleteResponse(null);    
        return objSuccessError;

    }//end of deleteRecords

   }//end of UECaseManagementDeleteHelper