/** 
* @description : This is the class to handle the Lead convert call in Queue
* @Author : Avudaiappan A
*/ 
public without sharing class DCPOrderConfirmationQueue implements Queueable{
    
    private String leadId;
    private String cartId;
    private String quoteId;
    private string emailId;
    private string trialId;//Added by Kunal as part of DCP-4147
   // private string reviewRequired;//Added by priyanka as part of DCP-4231
   // private string reviewRequiredNotes;//Added by priyanka as part of DCP-4231
    public Static String supportEmail = Static_Values__c.getValues('OrderProcessSupportEmail').Value__c; // Email address of support team member
    
    /** 
* @description : Constructor
* @param resMap : Input Params
*/ 
    public DCPOrderConfirmationQueue(Map<String,String> resMap){
        leadId = resMap.get('leadId');
        cartId = resMap.get('cartId');
        emailId = resMap.get('emailId');
        this.quoteId = resMap.get('quoteId');
        trialID = resMap.get('TrialID') == null?'':resMap.get('TrialID');//Added by Kunal as part of DCP-4147
        //reviewRequired = resMap.get('reviewRequired');//Added by Priyanka as part of DCP-4231
        //reviewRequiredNotes = resMap.get('reviewRequiredNotes');//Added by Priyanka as part of DCP-4231
    }
    /** 
* @description : execute
* @param context : QueueableContext
*/ 
    public void execute(QueueableContext context) {
        system.debug(LoggingLevel.INFO, 'Queuable Started');
        DCPConvertLeadHelperTwo.ConvertLeadWrapperDetails clwdt = new DCPConvertLeadHelperTwo.ConvertLeadWrapperDetails();
        DCPConvertLead dcl = new DCPConvertLead();
        clwdt.leadId = leadId;
        clwdt.cartId = cartId;
        clwdt.quoteId = quoteId;
        clwdt.emailId = emailId;
        //clwdt.reviewRequired = boolean.valueOf(reviewRequired);//Added by priyanka for dcp-4231
        //clwdt.reviewRequiredNotes = reviewRequiredNotes;//Added by priyanka for dcp-4231
        
        DCPConvertLeadHelperTwo.ProcessTRStoreWrapperDetails ptwd = new DCPConvertLeadHelperTwo.ProcessTRStoreWrapperDetails();
        ptwd.leadId = leadId;
        ptwd.cartId = cartId;
        ptwd.quoteId = quoteId;
        ptwd.trialId = trialID; 
        //ptwd.reviewRequired = boolean.valueOf(reviewRequired);//Added by priyanka for dcp-4231
        //ptwd.reviewRequiredNotes = reviewRequiredNotes; //Added by priyanka for dcp-4231
        try{
            dcl.convertLeadInitiation(clwdt);
            DCPQuoteSyncUpController.processTRStoreOrder(ptwd);//Added as part of DCP-4147
        }catch(Exception e){
            Map<String,String> errorHandlerMap = new Map<String,String>{'objectName'=>'Lead','expMsg'=>e.getMessage()+':'+e.getLineNumber()+':'+e.getStackTraceString(),'webServiceName'=>'CCAUTH','requestType'=>'Lead Conversion/Quote Sync up','reqMsg'=>'Exception Class Name: DCP_OrderService','module'=>'UEStore','recId'=>leadId,'supportEmail'=>supportEmail,'toSupport'=>'false'};
                DCPOrderConfirmationQueue.logExceptions(errorHandlerMap);
        }
        
        
        /*if(!test.isRunningTest()) {
if(leadId != null && TRStoreResponse.responseCode == TRStoreConstants.SUCCESS_CODE ) {
System.enqueueJob(new TRStore_OrderSubmissionQueueable(quoteId, cartId, leadId));
}
}*/
        
    }
    
    /********************************************************************************************************
* @description logException: Upsert Exception
*  @param logMap
*********************************************************************************************************/ 
    @TestVisible
    private static void logExceptions(Map<String,String> logMap){
        if(logMap!=null){
            DCPNewSaleUtilityCls.logException(logMap);
        }
    }
    
}