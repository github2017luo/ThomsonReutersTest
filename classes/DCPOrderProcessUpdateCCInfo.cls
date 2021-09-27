/** 
* @description : This is the class to handle the update on the proposal record 
* @Author : Avudaiappan A
*/ 
public without sharing class DCPOrderProcessUpdateCCInfo implements Queueable{
    
    private DCP_OrderService.DCP_OrderRequestClass orderReq;
    private string quoteId;
    private string emailId;
    public Static String supportEmail = Static_Values__c.getValues('OrderProcessSupportEmail').Value__c; // Email address of support team member
    
    /** 
* @description : Constructor
* @param orderRequest
* @param quoteId
*/ 
    public DCPOrderProcessUpdateCCInfo(DCP_OrderService.DCP_OrderRequestClass orderRequest,String quoteId){
        orderReq = orderRequest;
        this.quoteId = quoteId;
    }
    /** 
* @description : execute
* @param context
*/ 
    public void execute(QueueableContext context) {
        system.debug(LoggingLevel.INFO, 'Queuable Started');
        Apttus_Proposal__Proposal__c proposal = new Apttus_Proposal__Proposal__c(Id=quoteId);
        if(orderReq.autopay =='true'){
            /* Kavya Gangaraju: Commenting as Part of DCP-2989
proposal.APTS_Payment_Option__c = 'Payment Express Auto EFT/Auto Charge';*/
            proposal.APTS_Payment_Option__c = 'Autopay'; // kavya Ganagarju added as part of DCP-2989
            DCPQuoteSyncUpHelper.mapMasterContact(orderReq.leadId,quoteId);
        }else{
            proposal.APTS_Payment_Option__c = 'Credit Card';
        }
        
        /*START--Anitha Kodimyala--Date:22-Aug-2021-DCP-2451  Check on Autopay CC Auth implementation*/
        if(Static_Values__c.getValues('DCPOrderVersioning').Value__c =='v2'){
              if(orderReq.ccInfo.authorizationNumber!=null && orderReq.ccInfo.transactionId!=null && orderReq.ccInfo.ccVendorTransactionId!=null && orderReq.ccInfo.transactionMessageType!=null){
            proposal.APTS_Authorization_Number__c = orderReq.ccInfo.authorizationNumber;
            proposal.APTS_Authorization_Transaction__c = orderReq.ccInfo.transactionId;  
            proposal.APTS_VisaTransNumber__c = orderReq.ccInfo.ccVendorTransactionId; 
            proposal.APTS_VisaMessageType__c = orderReq.ccInfo.transactionMessageType;
        }
        }
      
        /*END--Anitha Kodimyala--Date:22-Aug-2021--DCP-2451  Check on Autopay CC Auth implementation*/
        
        proposal.APTS_Card_Type__c = orderReq.cardType;
        Integer month = integer.valueof(orderReq.cardExpiry.substring(0,2));
        Integer year = integer.valueof('20' + orderReq.cardExpiry.substring(2,4));
        Integer dayOfMonth = date.daysInMonth(year, month);
        proposal.APTS_Card_Expiration_Date__c = Date.newInstance(year, month, dayOfMonth);
        proposal.APTS_Credit_Card_Token__c = orderReq.cardToken;
        
        Map<String,String> resMap; 
        
        try{
            Database.upsert(proposal);
            Apttus_Config2__ProductConfiguration__c config = new Apttus_Config2__ProductConfiguration__c (Id=orderReq.cartId,Apttus_QPConfig__Proposald__c=orderReq.quoteId, Apttus_Config2__BusinessObjectType__c = 'Proposal', Apttus_Config2__BusinessObjectRefId__c = orderReq.quoteId,Apttus_Config2__BusinessObjectId__c=orderReq.quoteId);
            Database.Update(config,false);
            if(orderReq.trialPropertyInfo == null) {
            resMap= new Map<String,String>{'quoteId'=>orderReq.quoteId,'leadId'=>orderReq.leadId,'cartId'=>orderReq.cartId,'emailId'=>orderReq.emailId};}
            else{ 
                resMap= new Map<String,String>{'quoteId'=>orderReq.quoteId,'leadId'=>orderReq.leadId,'cartId'=>orderReq.cartId,'emailId'=>orderReq.emailId,'TrialID'=>orderReq.trialPropertyInfo.trialID,
                'trialStatus'=>orderReq.trialPropertyInfo.trialStatus,
                'reviewRequiredNotes'=>orderReq.trialPropertyInfo.reviewRequiredNotes};
            }
            
                System.enqueueJob(new DCPOrderConfirmationQueue(resMap));
        }
        catch(Exception e){
            Map<String,String> errorHandlerMap = new Map<String,String>{'objectName'=>'Quote/Proposal','expMsg'=>e.getMessage()+':'+e.getLineNumber()+':'+e.getStackTraceString(),'webServiceName'=>'CCAUTH','requestType'=>'Quote update with CC Info','reqMsg'=>'Exception Class Name: DCP_OrderService','module'=>'UEStore','recId'=>quoteId,'supportEmail'=>supportEmail,'toSupport'=>'false'};
                DCPNewSaleUtilityCls.logException(errorHandlerMap);
        }
        
      }  
        
    
}