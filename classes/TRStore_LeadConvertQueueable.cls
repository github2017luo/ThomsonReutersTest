public without sharing class TRStore_LeadConvertQueueable implements Queueable{

    private id leadId;
    private id cartId;
    private Id quoteId;
    private string emailId;
    private string westAccNumber;

    public TRStore_LeadConvertQueueable(Id quoteId, id lId, id cId, string eId, string aNumber){
         leadId = lId;
         cartId = cId;
         emailId = eId;
         this.quoteId = quoteId;
         westAccNumber = aNumber;
    }
    
    public void execute(QueueableContext context) {
        system.debug(LoggingLevel.INFO, 'Queuable Started');
        TRStore_OrderRequest.TRStoreResponse TRStoreResponse = TRStoreLeadprocess.convertLead(leadId, cartId, emailId, westAccNumber);
         
         checkRepriceCartStatus(cartId);
         
        if(!test.isRunningTest()) {
            if(leadId != null && TRStoreResponse.responseCode == TRStoreConstants.SUCCESS_CODE ) {
                System.enqueueJob(new TRStore_OrderSubmissionQueueable(quoteId, cartId, leadId));
            }
        }
            
    }


    public static  void checkRepriceCartStatus(id cId){
    
        
        LIST<Apttus_Config2__LineItem__c> lineItems = new LIST<Apttus_Config2__LineItem__c>();
        
        if(Schema.sObjectType.Apttus_Config2__LineItem__c.isAccessible()){
            lineItems  = [Select id from Apttus_Config2__LineItem__c where (Apttus_Config2__ConfigurationId__c =: cId and Apttus_Config2__NetPrice__c = null)] ;
        }
        
        
        if(!lineItems.isEmpty()){
            try{
                Apttus_CpqApi.CPQ.UpdatePriceRequestDO objUpdatePriceRequestDO = new Apttus_CpqApi.CPQ.UpdatePriceRequestDO();
                objUpdatePriceRequestDO.CartId = cId;
                Apttus_CpqApi.CPQ.UpdatePriceResponseDO result = Apttus_CpqApi.CPQWebService.updatePriceForCart(objUpdatePriceRequestDO);
                system.debug(LoggingLevel.INFO,'Any exception:'+result);
            }catch(exception e){
                String supportEmail = Static_Values__c.getValues('LeadSupportEmail').Value__c;    
                Map<String,String> errorHandlerMap = new Map<String,String>{'objectName'=>'Cart','expMsg'=>'Errors While Update Price/reprice'+string.valueOf(e)+': '+e.getLineNumber(),'webServiceName'=>'reprice','requestType'=>'Cart Update','reqMsg'=>'Exception Class Name: TRStore_LeadConvertQueueable','module'=>'TRStore','recId'=>cId,'supportEmail'=>supportEmail,'toSupport'=>'true'};
                TRStore_ErrorHandler.logException(errorHandlerMap);
            }
        }  
            
    }

}