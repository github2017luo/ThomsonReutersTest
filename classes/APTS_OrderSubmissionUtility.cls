/**
 * @description Utility for 'APTS_OrderSubmission'
 */
//DOC-14248
public with sharing class APTS_OrderSubmissionUtility {
    //SOC-5793
    /**
     * @description orderheaderAttachment
     * @param propId 
     * @param ordreq 
     * 
     */
public static  Integer counter=0;
public static void orderheaderAttachment(string propId, CreateOrderRequest ordreq){
    
    Set<String> attNameset=new  Set<String>{'%signed%','%CVMS Offer Sheet%', '%Product User Detail%', '%Digital Signature Detail%','%Order Form%'};  
    Set<String> contentDocIds=new Set<String>();
    contentDocIds = returnConentDocIds(contentDocIds, propId);
    List<ContentVersion> contVLst=new List<ContentVersion>();
    //Boolean signedflag=false;
    if(!contentDocIds.isEmpty() && Schema.sObjectType.ContentVersion.isAccessible() && Schema.sObjectType.ContentVersion.isQueryable()){
           contVLst=createContentVersion(attNameset, contentDocIds, contVLst);
           System.debug(LoggingLevel.WARN,'contVLst'+ contVLst.size());
        
}                 
            
           System.debug(LoggingLevel.WARN,'contVLst'+contVLst.size());
           //Set<String> sTitle=new Set<String>(); 
           createOrdRqst(contVLst, ordreq);
}

/**
 * @description method called for orderHeaderAttachment and APTS_CorpOrderQueuetoESI
 * @param attNameset
 * @param contentDocIds
 * @param contVLst
 * @return List
 */
public static List<ContentVersion> createContentVersion( Set<String> attNameset, Set<String> contentDocIds, List<ContentVersion> contVLst){
    Integer indexOF = 0;
    Boolean signedflag=false;
    Boolean hasOrderForm=false;
    for(ContentVersion cv : [SELECT Id,ContentDocumentId,Title FROM ContentVersion WHERE (ContentDocumentId IN :contentDocIds AND Title LIKE :attNameset) ORDER BY LastModifiedDate ASC, Title DESC NULLS LAST] ){
        System.debug(LoggingLevel.DEBUG , cv.title);
        if(signedTitle(cv)){
            
            System.debug(LoggingLevel.WARN,'indexOF '+indexOF);
            System.debug(LoggingLevel.WARN,'counter' + counter);
            if(hasOrderForm){
            contVLst = returnRemoveConVersion(indexOF, contVLst);}
            contVLst.add(cv);
            counter++;
            signedflag=true;
            System.debug(LoggingLevel.WARN,'Signed Flag Return'+signedflag);
        }
        
        contVLst = returnLstConVersion(cv,contVLst);
        System.debug(LoggingLevel.WARN,'counter:' + counter);
        if(cv.Title!=null && cv.Title.containsIgnoreCase('Order Form') &&  !signedflag){
            hasOrderForm=true;
            System.debug(LoggingLevel.WARN,'counter:' + counter);
            indexOF = counter;
            counter++;
            contVLst.add(cv);
            System.debug(LoggingLevel.WARN,'IndexOF:' + indexOF);
            
        }
    }
    return contVLst;
}
        @testVisible
        private static Set<String> returnConentDocIds(Set<String> contentDocIds,string propId){
        
            if(Schema.sObjectType.ContentDocumentLink.isAccessible() && Schema.sObjectType.ContentDocumentLink.isQueryable()){
                for(ContentDocumentLink contentDocId: [SELECT ContentDocumentId  FROM ContentDocumentLink WHERE LinkedEntityId =: propId]){
                contentDocIds.add(contentDocId.ContentDocumentId  );
                }               
            }
            return contentDocIds;
        }

        @testVisible
        private static Boolean signedTitle(ContentVersion cv)
        {
            Boolean flag = False; 
            if(cv.Title!=null && cv.Title.containsIgnoreCase('signed')){
                flag= True;
            }
            return flag;
        }

        @testVisible
        private static List<ContentVersion> returnRemoveConVersion(Integer indexOF, List<ContentVersion> contVLst){
            System.debug(LoggingLevel.WARN,'indexOF : '+indexOF+' : contVLst.size : '+contVLst.size());
            if(!contVLst.isEmpty() && contVLst[indexOF]!=null){//(indexOF > 0) && !contVLst.isEmpty() /*&& (contVLst.size()-1) >= indexOF*/
                System.debug(LoggingLevel.WARN, 'indexOF '+indexOF);
                contVLst.remove(indexOF);
            }
            return contVLst;
        }

        @testVisible
        private static List<ContentVersion> returnLstConVersion(ContentVersion cv, List<ContentVersion> contVLst){
            if(cv.Title!=null && cv.Title.containsIgnoreCase('CVMS Offer Sheet')){
                counter++;
                contVLst.add(cv);
            }
            if(cv.Title!=null && cv.Title.containsIgnoreCase('Product User Detail')){
                counter++;
                contVLst.add(cv);
            }
            if(cv.Title!=null && cv.Title.containsIgnoreCase('Digital Signature Detail')){
                counter++;
                contVLst.add(cv);
            }
            
            return contVLst;
        }

        @testVisible
        private static void createOrdRqst(List<ContentVersion> contVLst, CreateOrderRequest ordreq){
            if(!contVLst.isEmpty()) { 
                For(ContentVersion cv: contVLst) 
               {                        
                CreateOrderRequest.attachments attachment = new CreateOrderRequest.attachments();
                attachment.path = cv.ContentDocumentId;
                attachment.type= 'OR';
                attachment.status= 'E'; 
                ordreq.CreateOrderRequest.OrderHeader.attachments.add(attachment);
                }      
            }
        }



/*=================================================================================
Method to logException details
===================================================================================*/   
/**
     * @description logException
     * @param strMap 
     *  @param orderId 
     *  @param retryCount 
     *@return string
     * 
     */ 
            
        public static String logException(Map<String, String> strMap, Id orderId, Decimal retryCount) {
        //if(retryCount>=1){
            String strBody = strMap.get('strBody');
            String error = strMap.get('error');
            String loggerId = null;
            system.debug(LoggingLevel.WARN, 'Order Queue ESI LogException Retry COunt ::'+retryCount);
            if(Schema.sObjectType.Integration_Logger__c.isAccessible() && Schema.sObjectType.Integration_Logger__c.isQueryable()){
            
                List<Integration_Logger__c> intLogList=[Select Id from Integration_Logger__c where Order__c=:orderId];
                system.debug(LoggingLevel.WARN, 'intLogList :: '+intLogList);
            if(intLogList!=null && intLogList.size()==1){
                loggerId = intLogList[0].Id;
                IntegrationLogger.TaxupdateMessage(intLogList[0].Id, false,error,strBody);
            //}
            }else{
                system.debug(LoggingLevel.WARN, 'else part of LogException Retry COunt :: '+retryCount);
                loggerId = IntegrationLogger.OCAddMessage(error,'', 'Quote/Proposal', strBody, 'Outbound','OrderSubmission',false,orderId);
             
            } 
            }
            return loggerId;
        }
    /**
     * @description Method created to set oaMode to 'W' as a part of DOC-15125
     * @param ordreq
     */
    public static void setOAModeW(CreateOrderRequest ordreq){
        ordreq.CreateOrderRequest.OrderHeader.oaMode='W';  
    }  
}