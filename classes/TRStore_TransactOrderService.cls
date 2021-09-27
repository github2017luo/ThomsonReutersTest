/* Class: TRStore_TransactOrderService 
* Purpose: To expose wrapper REST service which will process customer information and create/update Lead, Account, Contact, Opty.
* Created: 27-Nov-2020
* Author: Kanishk Singhvi
* 
 CHANGE HISTORY
* =============================================================================
* Date         Name               JIRA        Description
* 27-Nov-2020   Kanishk Singhvi   DUE-6660  Order Service for Transact created
* 11-Dec-2020   Ameeta            DUE-6661  Queueable jobs to submit order
* 17-Feb-2021   Avudaiappan A     DUE-3525  Get QuoteId from cartId/CCAUTH call in SFDC
* =============================================================================
*/

@RestResource(urlMapping='/TransactOrderAction/*')
/********************************************************************************************************
*  @description TRStore_TransactOrderService : This class is to process order in SFDC by converting lead, cart finalization 
*********************************************************************************************************/ 
global with sharing class TRStore_TransactOrderService {
 /********************************************************************************************************
*  @description TRStore_TransactOrderRequestClass : Request class for order 
*********************************************************************************************************/ 
   
    public static TRStore_TransactOrderService.TRStore_TransactOrderRequestClass globalReq;
     private static string qid;
     
    global  class TRStore_TransactOrderRequestClass {
        global string leadId;
        global string cartId;
        global string quoteId;
        global string emailId;
        global string accNumber;
        global string paymentOption;
        global string cardToken;
        global string cardType;
        global string shippingMethod;
        //global string authNumber;
        //global string pnRefNum;
        global string cardLast4Digit;
        //global string txnNumber;
        global string cardExpiry;
        global string site;
        global string requestFor;
    
    }
    
    
    
    @HttpPost
    /********************************************************************************************************
    *  @description getDetailsForOrderSubmission : Method to check for null pointer
    *  @return TRStore_TransactOrderServiceResponse  : this is a return statement contains response 
    *  @param orderReq - expected the request cls variables
    *********************************************************************************************************/ 
    global static TRStore_TransactOrderServiceResponse getDetailsForOrderSubmission(TRStore_TransactOrderService.TRStore_TransactOrderRequestClass orderReq){
        RestRequest req = RestContext.request;
        RestResponse res =new RestResponse();
        res.addHeader('Content-Type', 'application/json');
        RestContext.request = req;
        RestContext.response= res;  
        globalReq = new TRStore_TransactOrderService.TRStore_TransactOrderRequestClass();
        globalReq = orderReq;
        if(String.isNotBlank(orderReq.cardType)){
            String cardType = orderReq.cardType;            
            orderReq.cardType = cardType.equalsIgnoreCase('MasterCard') ? 'MC' : cardType.equalsIgnoreCase('Discover')? 'DISC': orderReq.cardType;
        } 
        TRStore_TransactOrderServiceResponse resp;
        if(String.isNotBlank(orderReq.leadId) && String.isNotBlank(orderReq.cartId)){
            orderReq.quoteId = getQuoteId(orderReq.cartId);
            if(String.isNotBlank(orderReq.quoteId)){
                resp = TRStore_TransactOrderService.processRequest(orderReq);
            }else{
                resp = new TRStore_TransactOrderService.TRStore_TransactOrderServiceResponse(null, TRStore_TransactOrderService.formatStatus(TRStoreConstants.FAILURESTATUS, TRStoreConstants.ERROR_CODE, 'No Lines/Zero Priced Cart'),null); 
            }
        }else{
            resp = new TRStore_TransactOrderService.TRStore_TransactOrderServiceResponse(null, TRStore_TransactOrderService.formatStatus(TRStoreConstants.FAILURESTATUS, TRStoreConstants.ERROR_CODE, TRStoreConstants.REQUIREDFIELDSMISSING),null); 
        }
        return resp;
    }
    
    private static map<String,String> initialize(){
        map<String,String> staticValuesMap = new Map<String,String>();        
        staticValuesMap.put('TransactOC',(Static_Values__c.getAll().containsKey('TransactOrderConfirmationCode'))?Static_Values__c.getAll().get('TransactOrderConfirmationCode').Value__c:'');
        staticValuesMap.put('TransactMC',(Static_Values__c.getAll().containsKey('TRStoremicrositeOrderComplete'))?Static_Values__c.getAll().get('TRStoremicrositeOrderComplete').Value__c:'');
        staticValuesMap.put('supportEmail',(Static_Values__c.getValues('OrderProcessSupportEmail').Value__c));

        return staticValuesMap;
    }
    
    private static void updatePaymentDetailsOnLead(TRStore_TransactOrderService.TRStore_TransactOrderRequestClass orderReq, TRStore_TransactCCAuth.CCresponse ccResp) {
        Lead leadInfo = new Lead();
        if(Schema.sObjectType.Lead.isAccessible()){
            leadInfo = [Select Id, TRStore_Payment_Details__c, CC_Auth_Status__c FROM Lead where Id=:orderReq.leadId limit 1];
        }
        
        if(ccResp!=null && ccResp.statusCode == 'SUCCESS'){
          leadInfo.CC_Auth_Status__c  = TRStoreConstants.SUCCESS_STATUS;
            if(leadInfo.CC_Auth_Status__c == TRStoreConstants.SUCCESS_STATUS){
              leadInfo.TRStore_Payment_Details__c = 'cardToken:'+ orderReq.cardToken + ', cardType:' + orderReq.cardType + ', cardLast4Digit:' + orderReq.cardLast4Digit + ', cardExpiry:'+ orderReq.cardExpiry;
          }
        }
        else{
            leadInfo.CC_Auth_Status__c  = TRStoreConstants.FAILURESTATUS;
        }
        
        
        database.update(leadInfo);
    }

    
    private static TRStore_TransactOrderService.TRStore_TransactOrderServiceResponse processRequest(TRStore_TransactOrderService.TRStore_TransactOrderRequestClass orderReq){
        Map<String,String> staticValMap = TRStore_TransactOrderService.initialize();
        TRStore_TransactOrderService.TRStore_TransactOrderServiceResponse resp;
        if(orderReq.requestFor.equalsIgnoreCase(staticValMap.get('TransactOC'))){
            //Authorize Payment//
            TRStore_TransactCCAuth cc = new TRStore_TransactCCAuth();
            TRStore_TransactCCAuth.CCresponse ccResp = new TRStore_TransactCCAuth.CCresponse();
            try{
                TRStore_TransactCCAuth.AuthResponse authResp = cc.processRequest(orderReq.cardToken,orderReq.cardType,orderReq.cardExpiry);
                if(test.isRunningTest()){
                    resp = TRStore_TransactOrderService.processQueueable(orderReq);
                }
                if((authResp!=null && authResp.response!=null)){
                    ccResp= authResp.response;
                    resp = (ccResp!=null && ccResp.statusCode == 'SUCCESS')?TRStore_TransactOrderService.processQueueable(orderReq):new TRStore_TransactOrderService.TRStore_TransactOrderServiceResponse(null, TRStore_TransactOrderService.formatStatus(TRStoreConstants.FAILURESTATUS, TRStoreConstants.ERROR_CODE, 'Card Declined'),null); 
                    updatePaymentDetailsOnLead(orderReq,ccResp);
                 }else{
                    // Set error code in the response and add an entry in integration logger//
                    resp = new TRStore_TransactOrderService.TRStore_TransactOrderServiceResponse(null, TRStore_TransactOrderService.formatStatus(TRStoreConstants.FAILURESTATUS, TRStoreConstants.ERROR_CODE, 'Invalid Credit Card'),null); 
                    updatePaymentDetailsOnLead(orderReq,ccResp);
                }
                
    
            }catch(Exception e){
                Map<String,String> errorHandlerMap = new Map<String,String>{'objectName'=>'Order','expMsg'=>e.getMessage()+':'+e.getLineNumber()+':'+e.getStackTraceString(),'webServiceName'=>'CCAUTH','requestType'=>'Credit Card Authorization','reqMsg'=>'Exception Class Name: TRStore_TransactOrderService','module'=>'UEStore','recId'=>orderReq.cartId,'supportEmail'=>staticValMap.get('supportEmail'),'toSupport'=>'true'};
                TRStore_ErrorHandler.logException(errorHandlerMap);
            }
                            
        }
        else{
            resp = new TRStore_TransactOrderService.TRStore_TransactOrderServiceResponse(null, TRStore_TransactOrderService.formatStatus(TRStoreConstants.FAILURESTATUS, TRStoreConstants.ERROR_CODE, TRStoreConstants.REQUIREDFIELDSMISSING),null); 
        }
        
        return resp;
    }
    
    private static TRStore_TransactOrderService.TRStore_TransactOrderServiceResponse processQueueable(TRStore_TransactOrderService.TRStore_TransactOrderRequestClass orderReq){
        TRStore_TransactOrderService.TRStore_TransactOrderServiceResponse resp;
        if(String.isNotBlank(orderReq.leadId) && String.isNotBlank(orderReq.cartId)){
            TRStoreLeadProcess_Convertlead.ConvertLeadWrapperDetails cw = new TRStoreLeadProcess_Convertlead.ConvertLeadWrapperDetails();
            cw.quoteId = orderReq.quoteId;
            cw.leadId = orderReq.leadId;
            cw.cartId = orderReq.cartId;
            cw.emailId = orderReq.emailId;
            cw.westAccNumber = orderReq.accNumber;
            qid = orderReq.quoteId;
            Id jobId = system.enqueueJob(new Transact_LeadConvertQueueable(cw, orderReq));
            
            resp = TRStore_TransactOrderService.responseCode(jobId,'Issue on Order Creation',null);
        }else{
            resp = new TRStore_TransactOrderService.TRStore_TransactOrderServiceResponse(null, TRStore_TransactOrderService.formatStatus(TRStoreConstants.FAILURESTATUS, TRStoreConstants.ERROR_CODE, TRStoreConstants.REQUIREDFIELDSMISSING),null); 
        }        
        return resp;
    }    
    
    private static TRStore_TransactOrderService.TRStore_TransactOrderServiceResponse responseCode(Id jobId, String msg, database.saveresult leadresp){
        TRStore_TransactOrderService.TRStore_TransactOrderServiceResponse resp ;
        if(jobId != null || leadresp.isSuccess()){
            String quoteName = getQuoteName(qid);
            resp = new TRStore_TransactOrderService.TRStore_TransactOrderServiceResponse(jobid, TRStore_TransactOrderService.formatStatus(TRStoreConstants.SUCCESS_STATUS, TRStoreConstants.SUCCESS_CODE, ''),quoteName);
            
        }else{
            resp = new TRStore_TransactOrderService.TRStore_TransactOrderServiceResponse(jobid, TRStore_TransactOrderService.formatStatus(TRStoreConstants.FAILURESTATUS, TRStoreConstants.ERROR_CODE, msg),null);
            
        }
        return resp;
    }
    
    private static String getQuoteName(String quoteId){
        String resp = 'Quote Not Found';
        String query = 'SELECT Id, name from Apttus_Proposal__Proposal__c where id =: quoteId';
        List<Apttus_Proposal__Proposal__c> propList = Database.query(query);
        if(!propList.isEmpty()){
            resp = propList[0].name; 
        }        
        return resp ;
    }

    private static String getQuoteId(String cartId){
        String resp = null;
        String query = 'SELECT Apttus_QPConfig__Proposald__c,Rollup_Net_Price__c from Apttus_Config2__ProductConfiguration__c where id =: cartId';
        List<Apttus_Config2__ProductConfiguration__c> pcList = Database.query(query);
        if(!pcList.isEmpty() && pcList[0].Rollup_Net_Price__c!=0){
            resp = pcList[0].Apttus_QPConfig__Proposald__c; 
        }        
        return resp ;
    }
    
    private static Map<String,String> formatStatus(String status, String code, String msg){
        Map<String,String> statusMap = new Map<String,String>();
        statusMap.put('status',status);
        statusMap.put('statusCode',code);
        statusMap.put('statusDetail',msg);
        return statusMap;
    }
     /********************************************************************************************************
    *  @description TRStore_TransactOrderServiceResponse : Response class for order 
    *********************************************************************************************************/ 

    global class TRStore_TransactOrderServiceResponse{
        
        private id jobId{get; set;}
        private string statusCode{get; set;}
        private string status{get;set;}
        private string statusDetail{get; set;} 
        private string quoteName{get; set;} 
        /********************************************************************************************************
        *  @description TRStore_TransactOrderServiceResponse : Constructor
        *  @param j - JobId
        *  @param statusMap - statusMap represents status
        *  @param quoteNo - Name of the quote
        *********************************************************************************************************/ 
        global TRStore_TransactOrderServiceResponse(id j, map<String,String> statusMap, string quoteNo){
            jobId = j;
            status = statusMap.get('status');
            statusCode = statusMap.get('statusCode');
            statusDetail = statusMap.get('statusDetail');
            quoteName = quoteNo;
        }
    }
    /********************************************************************************************************
        *  @description Transact_LeadConvertQueueable : Class to hold request for lead covert
        *********************************************************************************************************/ 
        
    public class Transact_LeadConvertQueueable implements Queueable{
        private id leadId;
        private id cartId;
        private Id quoteId;
        private string emailId;
        private string westAccNumber;
        
        private TRStoreLeadProcess_Convertlead.ConvertLeadWrapperDetails convDetails;
        private TRStore_TransactOrderService.TRStore_TransactOrderRequestClass request;
        /********************************************************************************************************
        *  @description Transact_LeadConvertQueueable : Constructor
        *  @param cod - Wrapper details
        *  @param orderReq - Request of Order
        *********************************************************************************************************/ 
       public Transact_LeadConvertQueueable(TRStoreLeadProcess_Convertlead.ConvertLeadWrapperDetails  cod, TRStore_TransactOrderService.TRStore_TransactOrderRequestClass orderReq){
         this.convDetails = new TRStoreLeadProcess_Convertlead.ConvertLeadWrapperDetails();
         this.convDetails = cod;
         this.request = new TRStore_TransactOrderService.TRStore_TransactOrderRequestClass();
         this.request = orderReq;
         this.quoteId = cod.quoteId;
        }
         /********************************************************************************************************
        *  @description execute : Method to execute
        *  @param context - running variable
        *********************************************************************************************************/ 
       
        public void execute(QueueableContext context){
            system.debug(LoggingLevel.INFO, 'Queuable Started');
            TRStoreLeadProcess_Convertlead processConv = new TRStoreLeadProcess_Convertlead(); 
            TRStore_LeadRequest.TRStoreResponse trResponse;
            
            if(this.convDetails != null){
                trResponse = processConv.convertLead(convDetails);               
                system.debug(LoggingLevel.INFO,'trResponseresponseCode'+trResponse.responseCode);
                
                if(request.leadId != null && trResponse.responseCode == TRStoreConstants.SUCCESS_CODE) {
                    system.debug(LoggingLevel.INFO,'trResponse.responseCode calling order submission');
                    TRStore_TransactOrderSubmission.processTransactOrder(request);
                    System.debug(LoggingLevel.INFO,'quoteid1......'+quoteId);
                    Id jobId = System.enqueueJob(new Transact_OrderSubmissionQueueable(quoteId));
                    System.debug(LoggingLevel.INFO,'jobId......'+jobId);
                }
            }
        }
    }
     /********************************************************************************************************
        *  @description Transact_OrderSubmissionQueueable : Class
        ***********************************************************************/
    public class Transact_OrderSubmissionQueueable implements Queueable{
        private id quoteId;
          /********************************************************************************************************
        *  @description Transact_OrderSubmissionQueueable : COnstructor
        *  @param qId - QuoteId
        *********************************************************************************************************/ 
       
        public Transact_OrderSubmissionQueueable(id qId){
            this.quoteId = qId;
            
        }
          /********************************************************************************************************
        *  @description execute : Method to execute
        *  @param context - running variable
        *********************************************************************************************************/ 
       
        public void execute(QueueableContext context){
            System.debug(LoggingLevel.INFO,'quoteid1......'+quoteId);
            string timeframeToProcessOrder = (Static_Values__c.getAll().containsKey('TransactOrderProcessTimeFrame'))?Static_Values__c.getAll().get('TransactOrderProcessTimeFrame').Value__c:'5';
            integer schMin = 5;
            
            if(timeframeToProcessOrder.isNumeric()){
                schmin = integer.valueOf(timeframeToProcessOrder);
            }
            
            TRStore_PlaceOrderSchedulable os = new TRStore_PlaceOrderSchedulable(this.quoteId);
            dateTime dt = system.now();
            dt = dt.addMinutes(schmin);
            
            system.debug(LoggingLevel.INFO,'Hello Time 11111111.......'+dt);           
            
            String day = string.valueOf(dt.day());
            String month = string.valueOf(dt.month());
            String hour = string.valueOf(dt.hour());
            String minute = string.valueOf(dt.minute() );
            //String second = string.valueOf(dt.second());
            String year = string.valueOf(dt.year());
            
            String strJobName = 'TRSTR-'+quoteId+'-'+DateTime.now();
            String strSchedule = '0 ' + minute + ' ' + hour + ' ' + day + ' ' + month + ' ?' + ' ' + year;
                       
            system.debug(LoggingLevel.INFO,'Hello Time 2222222.......'+strSchedule );
            String jobID;
            jobID = system.schedule(strJobName , strSchedule, os);
        }
    }
    
    

}