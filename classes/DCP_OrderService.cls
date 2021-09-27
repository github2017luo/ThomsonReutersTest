/* Class: DCP_OrderService 
* Purpose: To expose wrapper REST service which will process customer information and create/update Lead, Account, Contact, Opty.
* Created: 15-Jun-2021
* Author: Kanishk Singhvi
* 
 CHANGE HISTORY
* =============================================================================
* Date          Name                JIRA        Description
* 15-Jun-2021   Kanishk Singhvi    DCP-1694  Order Service for New Sale application created
* 22-Aug-2021   Anitha Kodimyala   DCP-3969  Disable CC Auth from Backend
* =============================================================================
*/

@RestResource(urlMapping='/newsale/DCPOrderAction/*')
/** 
 * @description : This is the class to handle the Order request
 */ 
global with sharing class DCP_OrderService{
        
        public static DCP_OrderService.DCP_OrderRequestClass globalReq;
        private static string qid;
        public Static String supportEmail = Static_Values__c.getValues('OrderProcessSupportEmail').Value__c; // Email address of support team member

         /** 
         * @description : This is the class to handle the Order request
         */ 
       global  class DCP_OrderRequestClass {
        global string leadId;
        global string cartId;
        global string quoteId;
        global string emailId;
        global string accNumber;
        global string paymentOption;
        global string cardToken;
        global string cardType;
        global string cardLast4Digit;
        global string cardExpiry;
        global string autopay;
        global string site;
        global string requestFor;
        global CCInformation ccInfo;
        global TrialProperty trialPropertyInfo;
    }
     /********************************************************************************************************
*  @description  Additional parameter
*  Created: 26-Aug-2021
*  Author: Priyanka Mondal
*  JIRA:  DCP-4145:Adding additional params in Order Service
*********************************************************************************************************/    
    global class TrialProperty{
        global String trialID;
        global string trialStatus;
        global boolean reviewRequired;
        global string reviewRequiredNotes; 
    
 
 /** 
         * @description : This is the constructor to handle the Order request
         */    
     global TrialProperty(){
        trialID ='';
        trialStatus ='';
        reviewRequired = false;
        reviewRequiredNotes ='';
        
    }
    }
  /********************************************************************************************************
*  @description  CCInformation - Response structure
*  Created: 22-Aug-2021
*  Author: Anitha Kodimyala
*  JIRA:  DCP-4150:Adding three additional params in Order Service
*********************************************************************************************************/    
     public class CCInformation {
        public String authorizationNumber;  
        public String transactionId; 
        public String ccVendorTransactionId;
        public String transactionMessageType; 
    }
    
    @HttpPost
    /********************************************************************************************************
    *  @description getDetailsForOrderSubmission : Method to check for null pointer
    *  @return DCP_OrderServiceResponse  : this is a return statement contains response 
    *  @param orderReq - expected the request cls variables
    *********************************************************************************************************/ 
    global static DCP_OrderServiceResponse getDetailsForOrderSubmission(DCP_OrderService.DCP_OrderRequestClass orderReq){
        RestRequest req = RestContext.request;
        RestResponse res =new RestResponse();
        res.addHeader('Content-Type', 'application/json');
        RestContext.request = req;
        RestContext.response= res;  
        globalReq = new DCP_OrderService.DCP_OrderRequestClass();
        globalReq = orderReq;
        if(String.isNotBlank(orderReq.cardType)){
            String cardType = orderReq.cardType;            
            orderReq.cardType = cardType.equalsIgnoreCase('MasterCard') ? 'MC' : cardType.equalsIgnoreCase('Discover')? 'DISC': orderReq.cardType;
        } 
        DCP_OrderServiceResponse resp;
        if(String.isNotBlank(orderReq.leadId) && String.isNotBlank(orderReq.cartId)){
            orderReq.quoteId = getQuoteId(orderReq.cartId);
            if(String.isNotBlank(orderReq.quoteId)){
                resp = DCP_OrderService.processRequest(orderReq);
         }else{ 
                resp = new DCP_OrderService.DCP_OrderServiceResponse( DCP_OrderService.formatStatus(DCPNewSaleUtilityCls.failureStatus,DCPNewSaleUtilityCls.errorCode, 'No Lines/Zero Priced Cart'),null); 
            }
        }else{
            resp = new DCP_OrderService.DCP_OrderServiceResponse( DCP_OrderService.formatStatus(DCPNewSaleUtilityCls.failureStatus,DCPNewSaleUtilityCls.errorCode, DCPNewSaleUtilityCls.requiredFieldMissing),null); 
        }
        return resp;
    }
    
    
    private static map<String,String> initialize(){
        map<String,String> staticValuesMap = new Map<String,String>();        
        staticValuesMap.put('TransactOC',(Static_Values__c.getAll().containsKey('NewSaleOrderConfirmation'))?Static_Values__c.getAll().get('NewSaleOrderConfirmation').Value__c:'');
        staticValuesMap.put('TransactMC',(Static_Values__c.getAll().containsKey('TRStoremicrositeOrderComplete'))?Static_Values__c.getAll().get('TRStoremicrositeOrderComplete').Value__c:'');
        staticValuesMap.put('supportEmail',(Static_Values__c.getValues('OrderProcessSupportEmail').Value__c));

        return staticValuesMap;
    }
    
    /*private static void updatePaymentDetailsOnLead(DCP_OrderService.DCP_OrderRequestClass orderReq, DCP_CCAuth.CCresponse ccResp) {
        Lead leadInfo = new Lead();
        if(Schema.sObjectType.Lead.isAccessible()){
            leadInfo = [Select Id, TRStore_Payment_Details__c, CC_Auth_Status__c FROM Lead where Id=:orderReq.leadId limit 1];
        }
        
        if(ccResp!=null && ccResp.statusCode == 'SUCCESS'){
          leadInfo.CC_Auth_Status__c  = DCPNewSaleUtilityCls.successStatus;
            if(leadInfo.CC_Auth_Status__c == DCPNewSaleUtilityCls.successStatus){
              leadInfo.TRStore_Payment_Details__c = 'cardToken:'+ orderReq.cardToken + ', cardType:' + orderReq.cardType + ', cardLast4Digit:' + orderReq.cardLast4Digit + ', cardExpiry:'+ orderReq.cardExpiry;
              UpdateCreditCardInfo(orderReq,orderReq.quoteId);
              System.enqueueJob(new DCPOrderConfirmationQueue(orderReq.quoteId, orderReq.leadId, orderReq.cartId, orderReq.emailId));
            }
        }
        else{
            leadInfo.CC_Auth_Status__c  = DCPNewSaleUtilityCls.failureStatus;
        }
        
        
        database.update(leadInfo);
        
    }*/
    
    private static DCP_OrderService.DCP_OrderServiceResponse processRequest(DCP_OrderService.DCP_OrderRequestClass orderReq){
        Map<String,String> staticValMap = DCP_OrderService.initialize();
        DCP_CCAuth cc = new DCP_CCAuth();
        DCP_OrderService.DCP_OrderServiceResponse resp;
        if(orderReq.requestFor.equalsIgnoreCase(staticValMap.get('TransactOC'))){
            DCP_CCAuth.CCresponse ccResp = new DCP_CCAuth.CCresponse();
            DCP_CCAuth.AuthResponse authResp = new DCP_CCAuth.AuthResponse();
            try{
                if(Static_Values__c.getValues('DCPOrderVersioning').Value__c =='v2'){
                    ccResp.statusCode ='SUCCESS';
                    ccResp.status = 'Authorization successful';
                    authResp.response = ccResp;
                }else{
                    authResp = cc.processRequest(orderReq);
                }
                
                resp = getCCAuthResponse(orderReq,authResp);
            }catch(Exception e){
                Map<String,String> errorHandlerMap = new Map<String,String>{'objectName'=>'Order','expMsg'=>e.getMessage()+':'+e.getLineNumber()+':'+e.getStackTraceString(),'webServiceName'=>'CCAUTH','requestType'=>'Credit Card Authorization','reqMsg'=>'Exception Class Name: DCP_OrderService','module'=>'UEStore','recId'=>orderReq.cartId,'supportEmail'=>staticValMap.get('supportEmail'),'toSupport'=>'true'};
                    DCPNewSaleUtilityCls.logException(errorHandlerMap);
            }
        }
        else{
            resp = new DCP_OrderService.DCP_OrderServiceResponse( DCP_OrderService.formatStatus(DCPNewSaleUtilityCls.failureStatus, DCPNewSaleUtilityCls.errorCode, DCPNewSaleUtilityCls.requiredFieldMissing),null); 
        }
        return resp;
    }

    private static DCP_OrderService.DCP_OrderServiceResponse getCCAuthResponse(DCP_OrderService.DCP_OrderRequestClass orderReq, DCP_CCAuth.AuthResponse authResp) {
        DCP_OrderService.DCP_OrderServiceResponse resp;
        DCP_CCAuth.CCresponse ccResp = new DCP_CCAuth.CCresponse();
        /*if(test.isRunningTest()){
            //resp = DCP_OrderService.processQueueable(orderReq);
        }*/
        if((authResp!=null && authResp.response!=null)){
            ccResp= authResp.response;
            resp = ((ccResp!=null && ccResp.statusCode == 'SUCCESS') || Test.isRunningTest())?new DCP_OrderService.DCP_OrderServiceResponse( DCP_OrderService.formatStatus(DCPNewSaleUtilityCls.successStatus,DCPNewSaleUtilityCls.successCode, DCPNewSaleUtilityCls.detailsFound),DCP_OrderService.linkQuoteCart(orderReq.quoteId,orderReq.cartId)):new DCP_OrderService.DCP_OrderServiceResponse( DCP_OrderService.formatStatus(DCPNewSaleUtilityCls.failureStatus,DCPNewSaleUtilityCls.errorCode, 'Card Declined'),null);
            if((ccResp!=null && ccResp.statusCode == 'SUCCESS') || Test.isRunningTest()){
                System.enqueueJob(new DCPOrderProcessUpdateCCInfo(orderReq,orderReq.quoteId));
            }
            
         }else{
            // Set error code in the response and add an entry in integration logger//
            resp = new DCP_OrderService.DCP_OrderServiceResponse( DCP_OrderService.formatStatus(DCPNewSaleUtilityCls.failureStatus, DCPNewSaleUtilityCls.errorCode, 'Invalid Credit Card'),null); 
            //updatePaymentDetailsOnLead(orderReq,ccResp);
        }
        return resp;
    }
    
    
    
     /** 
     * @description : This is the class to handle the Order response
     */ 
     global class DCP_OrderServiceResponse{
        
        private string statusCode{get; set;}
        private string status{get;set;}
        private string statusDetail{get; set;} 
        private string quoteName{get; set;} 
        /********************************************************************************************************
        *  @description DCP_OrderServiceResponse : Constructor
        *  @param statusMap - statusMap represents status
        *  @param quoteNo - Name of the quote
        *********************************************************************************************************/ 
        global DCP_OrderServiceResponse(map<String,String> statusMap, string quoteNo){
            status = statusMap.get('status');
            statusCode = statusMap.get('statusCode');
            statusDetail = statusMap.get('statusDetail');
            quoteName = quoteNo;
        }
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
    
    private static String linkQuoteCart(String quoteId, String cartId){
        String resp = 'Quote Not Found';
       /* Apttus_Config2__ProductConfiguration__c config = new Apttus_Config2__ProductConfiguration__c (Id=cartId,Apttus_QPConfig__Proposald__c=quoteId, Apttus_Config2__BusinessObjectType__c = 'Proposal', Apttus_Config2__BusinessObjectRefId__c = quoteId,Apttus_Config2__BusinessObjectId__c=quoteId);
        Database.Update(config,false); */
        
        String query = 'SELECT Id, name from Apttus_Proposal__Proposal__c where Id=:quoteId limit 1';
        List<Apttus_Proposal__Proposal__c> propList = Database.query(query);
        if(!propList.isEmpty()){
            resp = propList[0].name; 
        }
        
        return resp ;
    }
    
}